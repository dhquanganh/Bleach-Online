'use strict';
// Patch the native Mall table in every local 0F000000.binPackage that matches Mall.json.
const fs = require('fs');
const path = require('path');
const zlib = require('zlib');

const ROOT = path.join(__dirname, '..');
const PUBLIC = path.join(ROOT, 'kaynak', 'login.gogames.me', 'public');
const MALL_JSON = path.join(__dirname, 'veri-json', 'Mall.json');
const MALL_DB = 0x01000020;
const DEMON_ROW = 0x00a97eb2;
const DEMON_HERO_ICON = '00A9FBA8.TexClient';
const DEMON_ITEM_ICON = '00D7276B.TexClient';
const CHECK_ONLY = process.argv.includes('--check');

function writeU16(parts, value) {
    const b = Buffer.alloc(2);
    b.writeUInt16LE(Number(value) >>> 0);
    parts.push(b);
}

function writeU32(parts, value) {
    const b = Buffer.alloc(4);
    b.writeUInt32LE(Number(value) >>> 0);
    parts.push(b);
}

function writeUtf(parts, value) {
    const b = Buffer.from(String(value == null ? '' : value), 'utf8');
    if (b.length > 0xffff) throw new Error('Mall string exceeds u16 length');
    writeU16(parts, b.length);
    parts.push(b);
}

function mallBlock(rows) {
    const parts = [];
    writeU32(parts, MALL_DB);
    writeU32(parts, rows.length);
    for (const row of rows) {
        writeU32(parts, parseInt(row.id, 16));
        writeU32(parts, row.model);
        writeUtf(parts, row.name);
        writeU32(parts, row.majorType);
        writeU32(parts, row.itemID);
        writeUtf(parts, row.type);
        for (const key of ['integration', 'level', 'isVip', 'isDisplay', 'amount', 'gold', 'discount', 'hotprice', 'page', 'vip', 'isHot', 'isnew', 'times', 'totalTimes']) writeU32(parts, row[key]);
        writeUtf(parts, row.honour);
        writeU32(parts, row.f20);
    }
    return Buffer.concat(parts);
}

function packageParts(buffer) {
    if (buffer.length < 6) throw new Error('Invalid binPackage header');
    const packageId = buffer.readUInt32LE(0);
    const count = buffer.readUInt16LE(4);
    const blocks = [];
    let offset = 6;
    for (let i = 0; i < count; i++) {
        if (offset + 4 > buffer.length) throw new Error('Truncated binPackage block header');
        const length = buffer.readUInt32LE(offset);
        offset += 4;
        if (offset + length > buffer.length) throw new Error('Truncated binPackage block');
        blocks.push({ compressed: buffer.subarray(offset, offset + length) });
        offset += length;
    }
    return { packageId, blocks, tail: buffer.subarray(offset) };
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

const rows = JSON.parse(fs.readFileSync(MALL_JSON, 'utf8'));
const demon = rows.find(row => (parseInt(row.id, 16) >>> 0) === DEMON_ROW);
if (!demon || demon.majorType !== 1 || demon.itemID !== 14100331 || demon.isHot !== 1 || demon.gold !== 500000) throw new Error('Demon Ichigo token Hot Mall row is missing or has unexpected fields');
const baseRows = rows.filter(row => (parseInt(row.id, 16) >>> 0) !== DEMON_ROW);
const expectedBase = mallBlock(baseRows);
const expectedUpdated = mallBlock(rows);
const previousRows = rows.map(row => (parseInt(row.id, 16) >>> 0) === DEMON_ROW ? { ...row, majorType: 2, itemID: 11140008 } : row);
const expectedPrevious = mallBlock(previousRows);

function sourceIcon(folder, fileName) {
    for (const version of fs.readdirSync(PUBLIC).sort().reverse()) {
        const file = path.join(PUBLIC, version, 'Resources', 'Textures', folder, fileName);
        if (fs.existsSync(file)) return file;
    }
    throw new Error(`Missing source texture: ${folder}/${fileName}`);
}

const iconSources = [
    ['HeadIcon', DEMON_HERO_ICON],
    ['LargeIcon', DEMON_HERO_ICON],
    ['Inventory', DEMON_ITEM_ICON],
].map(([folder, fileName]) => [folder, fileName, sourceIcon(folder, fileName)]);
for (const version of fs.readdirSync(PUBLIC)) {
    const resourceRoot = path.join(PUBLIC, version, 'Resources');
    if (!fs.existsSync(path.join(resourceRoot, 'Bin'))) continue;
    for (const [folder, fileName, source] of iconSources) {
        const target = path.join(resourceRoot, 'Textures', folder, fileName);
        if (fs.existsSync(target)) continue;
        if (CHECK_ONLY) {
            console.log(`ICON MISSING ${version}/${folder}/${fileName}`);
            continue;
        }
        fs.mkdirSync(path.dirname(target), { recursive: true });
        fs.copyFileSync(source, target);
        console.log(`ICON COPY ${version}/${folder}/${fileName}`);
    }
}

let updated = 0;
let alreadyUpdated = 0;
for (const version of fs.readdirSync(PUBLIC)) {
    const binRoot = path.join(PUBLIC, version, 'Resources', 'Bin');
    if (!fs.existsSync(binRoot)) continue;
    for (const variant of fs.readdirSync(binRoot)) {
        const file = path.join(binRoot, variant, '0F000000.binPackage');
        if (!fs.existsSync(file)) continue;
        const original = fs.readFileSync(file);
        const pkg = packageParts(original);
        const matches = [];
        for (let i = 0; i < pkg.blocks.length; i++) {
            let inflated;
            try { inflated = zlib.inflateSync(pkg.blocks[i].compressed); } catch { continue; }
            if (inflated.length >= 8 && inflated.readUInt32LE(0) === MALL_DB) matches.push({ index: i, inflated });
        }
        if (matches.length !== 1) throw new Error(`${version}/${variant}: expected one Mall block, got ${matches.length}`);
        const match = matches[0];
        if (match.inflated.equals(expectedUpdated)) {
            alreadyUpdated++;
            continue;
        }
        if (!match.inflated.equals(expectedBase) && !match.inflated.equals(expectedPrevious)) throw new Error(`${version}/${variant}: Mall block differs from extracted Mall.json; refusing to patch`);
        console.log(`${CHECK_ONLY ? 'READY' : 'PATCH'} ${version}/${variant}`);
        if (CHECK_ONLY) continue;
        pkg.blocks[match.index].compressed = zlib.deflateSync(expectedUpdated);
        fs.writeFileSync(file, packageBuffer(pkg));
        updated++;
    }
}
console.log(JSON.stringify({ updated, alreadyUpdated, checkOnly: CHECK_ONLY }));