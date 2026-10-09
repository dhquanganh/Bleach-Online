'use strict';
// Patch the Void Region and Evil Spirit schedules in every local 0F000000.binPackage.
const fs = require('fs');
const path = require('path');
const zlib = require('zlib');

const ROOT = path.join(__dirname, '..');
const PUBLIC = path.join(ROOT, 'kaynak', 'login.gogames.me', 'public');
const DAILY_ACTIVITY_JSON = path.join(__dirname, 'veri-json', 'DailyActivity.json');
const DAILY_ACTIVITY_DB = 0x01000011;
const ORIGINAL_TIME = '["Event Start Time: ","21:00-22:00"]';
const PREVIOUS_TEST_TIME = '["Event Start Time: ","00:00 - 23:59"]';
const EVIL_NAMES = new Set(['Shinigami Evil Spirit', 'Quincy Evil Spirit', 'Arrancar Evil Spirit']);
const EVIL_ORIGINAL_TIME = '["Event Start Time: ","12:59 - 13:30"]';
const EVIL_TEST_TIME = '["Event Start Time: ","00:00 - 23:59"]';
const ORIGINAL_DESCRIPTION = "Minimum required level of Void Region is Lv.100.\nVoid Region will be available on 4th, 8th, 12th, 16th, 20th, 24th and 28th every month.\nAttendants of Void Region will receive participating rewards.\nTop 100 players on damage ranking list will receive ranking rewards.\nRewards for Void Region will be different each time, based on players' ranking, No.1 player will receive 10* corresponding reward, No.2 player will receive 9* corresponding reward, No.3 player will receive 8* corresponding reward, No.4 player will receive 7* corresponding reward, No.5 player will receive 6* corresponding reward, No.6-7 players will receive 5* corresponding reward, No.8-10 players will receive 4* corresponding reward and No.11-100 players will receive 2* corresponding reward.";
const CHECK_ONLY = process.argv.includes('--check');

function writeU32(parts, value) {
  const b = Buffer.alloc(4);
  b.writeUInt32LE(Number(value) >>> 0);
  parts.push(b);
}

function writeUtf(parts, value) {
  const b = Buffer.from(String(value == null ? '' : value), 'utf8');
  if (b.length > 0xffff) throw new Error('DailyActivity string exceeds u16 length');
  const length = Buffer.alloc(2);
  length.writeUInt16LE(b.length);
  parts.push(length, b);
}

function dailyActivityBlock(rows) {
  const parts = [];
  writeU32(parts, DAILY_ACTIVITY_DB);
  writeU32(parts, rows.length);
  for (const row of rows) {
    writeU32(parts, parseInt(row.id, 16));
    writeUtf(parts, row.activityName);
    writeU32(parts, row.activityType);
    writeUtf(parts, row.activityTime);
    writeUtf(parts, row.activityDescription);
    writeUtf(parts, row.activityRewards);
    writeUtf(parts, row.buttonState);
  }
  return Buffer.concat(parts);
}

function packageParts(buffer) {
  if (buffer.length < 6) throw new Error('Invalid binPackage header');
  const pkg = {
    packageId: buffer.readUInt32LE(0),
    blocks: [],
    tail: Buffer.alloc(0),
  };
  const count = buffer.readUInt16LE(4);
  let offset = 6;
  for (let i = 0; i < count; i++) {
    if (offset + 4 > buffer.length) throw new Error('Truncated binPackage block header');
    const length = buffer.readUInt32LE(offset);
    offset += 4;
    if (offset + length > buffer.length) throw new Error('Truncated binPackage block');
    pkg.blocks.push({ compressed: buffer.subarray(offset, offset + length) });
    offset += length;
  }
  pkg.tail = buffer.subarray(offset);
  return pkg;
}

function packageBuffer(pkg) {
  const parts = [];
  const header = Buffer.alloc(6);
  header.writeUInt32LE(pkg.packageId, 0);
  header.writeUInt16LE(pkg.blocks.length, 4);
  parts.push(header);
  for (const block of pkg.blocks) {
    const length = Buffer.alloc(4);
    length.writeUInt32LE(block.compressed.length, 0);
    parts.push(length, block.compressed);
  }
  if (pkg.tail.length) parts.push(pkg.tail);
  return Buffer.concat(parts);
}

const rows = JSON.parse(fs.readFileSync(DAILY_ACTIVITY_JSON, 'utf8'));
const voidRow = rows.find(row => row.activityName === 'Void Region' && Number(row.activityType) === 9);
if (!voidRow || voidRow.activityTime !== '["Event Start Time: ","00:00-23:59"]' ||
    !String(voidRow.activityDescription).includes('open all day for testing')) {
  throw new Error('Void Region all-day schedule is missing from DailyActivity.json');
}
const evilRows = rows.filter(row => EVIL_NAMES.has(row.activityName) && Number(row.activityType) === 3);
if (evilRows.length !== EVIL_NAMES.size || evilRows.some(row =>
  row.activityTime !== EVIL_TEST_TIME ||
  !String(row.activityDescription).includes('open all day for testing'))) {
  throw new Error('All three Evil Spirit all-day schedules are missing from DailyActivity.json');
}

const expectedUpdated = dailyActivityBlock(rows);
const beforeEvilRows = rows.map(row => EVIL_NAMES.has(row.activityName) ? {
  ...row,
  activityTime: EVIL_ORIGINAL_TIME,
  activityDescription: String(row.activityDescription).replace(
    ' at any time (open all day for testing)',
    ' during 12:59 -- 13:30',
  ),
} : row);
const expectedBeforeEvil = dailyActivityBlock(beforeEvilRows);
const previousTestRows = beforeEvilRows.map(row => row.activityName === 'Void Region' ? {
  ...row,
  activityTime: PREVIOUS_TEST_TIME,
} : row);
const expectedPreviousTest = dailyActivityBlock(previousTestRows);
const originalRows = beforeEvilRows.map(row => row.activityName === 'Void Region' ? {
  ...row,
  activityTime: ORIGINAL_TIME,
  activityDescription: ORIGINAL_DESCRIPTION,
} : row);
const expectedOriginal = dailyActivityBlock(originalRows);
const plans = [];

for (const version of fs.readdirSync(PUBLIC)) {
  const binRoot = path.join(PUBLIC, version, 'Resources', 'Bin');
  if (!fs.existsSync(binRoot)) continue;
  for (const variant of fs.readdirSync(binRoot)) {
    const file = path.join(binRoot, variant, '0F000000.binPackage');
    if (!fs.existsSync(file)) continue;
    const pkg = packageParts(fs.readFileSync(file));
    const matches = [];
    for (let i = 0; i < pkg.blocks.length; i++) {
      let inflated;
      try { inflated = zlib.inflateSync(pkg.blocks[i].compressed); } catch { continue; }
      if (inflated.length >= 8 && inflated.readUInt32LE(0) === DAILY_ACTIVITY_DB) {
        matches.push({ index: i, inflated });
      }
    }
    if (matches.length !== 1) throw new Error(`${version}/${variant}: expected one DailyActivity block, got ${matches.length}`);
    const match = matches[0];
    if (match.inflated.equals(expectedUpdated)) {
      plans.push({ file, pkg, index: match.index, state: 'updated' });
      continue;
    }
    if (match.inflated.equals(expectedPreviousTest)) {
      plans.push({ file, pkg, index: match.index, state: 'previous-test' });
      continue;
    }
    if (match.inflated.equals(expectedBeforeEvil)) {
      plans.push({ file, pkg, index: match.index, state: 'before-evil' });
      continue;
    }
    if (!match.inflated.equals(expectedOriginal)) {
      throw new Error(`${version}/${variant}: DailyActivity block differs from extracted JSON; refusing to patch`);
    }
    plans.push({ file, pkg, index: match.index, state: 'original' });
  }
}

if (!plans.length) throw new Error('No local 0F000000.binPackage files found');
let updated = 0;
let alreadyUpdated = 0;
for (const plan of plans) {
  if (plan.state === 'updated') {
    alreadyUpdated++;
    continue;
  }
  if (CHECK_ONLY) {
    console.log(`READY ${path.relative(PUBLIC, plan.file)}`);
    continue;
  }
  plan.pkg.blocks[plan.index].compressed = zlib.deflateSync(expectedUpdated);
  fs.writeFileSync(plan.file, packageBuffer(plan.pkg));
  updated++;
}

console.log(JSON.stringify({ updated, alreadyUpdated, checkOnly: CHECK_ONLY, packages: plans.length }));
