"""Recompress PNG IDAT without changing any decompressed scanline or ancillary chunk."""
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
import argparse
import hashlib
import json
import os
import struct
import time
import zlib

ROOT = Path(__file__).resolve().parents[1]
PUBLIC = ROOT / 'sunucu-kok/kaynak/login.gogames.me/public'
BUILD = ROOT / 'sunucu-kok/cikarim'
REPORT = ROOT / 'tools/vfx-png-compression-report.json'


def sha(data):
    return hashlib.sha256(data).hexdigest()


def replace(path, data):
    temp = path.with_name(path.name + '.compress-tmp')
    try:
        temp.write_bytes(data)
        os.replace(temp, path)
    finally:
        if temp.exists():
            temp.unlink()


def parse(data):
    assert data[:8] == b'\x89PNG\r\n\x1a\n'
    chunks = []
    pos = 8
    while pos < len(data):
        size = struct.unpack_from('>I', data, pos)[0]
        end = pos + size + 12
        assert end <= len(data)
        chunk = data[pos:end]
        assert zlib.crc32(chunk[4:-4]) == struct.unpack_from('>I', chunk, len(chunk) - 4)[0]
        chunks.append((chunk[4:8], chunk))
        pos = end
    assert chunks[-1][0] == b'IEND'
    raw = zlib.decompress(b''.join(c[8:-4] for kind, c in chunks if kind == b'IDAT'))
    return chunks, raw


def compress(path):
    old = path.read_bytes()
    chunks, raw = parse(old)
    packed = zlib.compress(raw, 9)
    payload = b'IDAT' + packed
    idat = struct.pack('>I', len(packed)) + payload + struct.pack('>I', zlib.crc32(payload))
    output = [old[:8]]
    emitted = False
    for kind, chunk in chunks:
        if kind == b'IDAT':
            if not emitted:
                output.append(idat)
                emitted = True
        else:
            output.append(chunk)
    new = b''.join(output)
    if len(new) >= len(old):
        new = old
    verified_chunks, verified_raw = parse(new)
    assert verified_raw == raw
    assert [c for k, c in chunks if k != b'IDAT'] == [c for k, c in verified_chunks if k != b'IDAT']
    if APPLY and new != old:
        replace(path, new)
        assert path.read_bytes() == new
    return {'path': str(path.relative_to(ROOT)), 'before': len(old), 'after': len(new),
            'oldSha256': sha(old), 'newSha256': sha(new), 'scanlineSha256': sha(raw)}


def update(value, changes):
    count = 0
    if isinstance(value, dict):
        for key, child in value.items():
            if isinstance(child, str) and child in changes:
                record = changes[child]
                value[key] = record['newSha256']
                # Streaming.bytes describes ARGB; sourcePngSha256 never changes it.
                if key in {'sha256', 'fileSha256'} and value.get('bytes') == record['before']:
                    value['bytes'] = record['after']
                count += 1
            elif isinstance(child, (list, dict)):
                count += update(child, changes)
    elif isinstance(value, list):
        for child in value:
            count += update(child, changes)
    return count


if __name__ == '__main__':
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--apply', action='store_true')
    APPLY = ap.parse_args().apply
    paths = sorted(p for d in PUBLIC.glob('*-vfx') for p in d.rglob('*.png'))
    report = {'applied': APPLY, 'files': [], 'metadata': []}
    started = time.monotonic()
    print(f'PNG files: {len(paths)}; apply={APPLY}', flush=True)
    try:
        with ThreadPoolExecutor(max_workers=2) as pool:
            for index, result in enumerate(pool.map(compress, paths), 1):
                report['files'].append(result)
                if index % 100 == 0:
                    saved = sum(r['before'] - r['after'] for r in report['files'])
                    print(f'{index}/{len(paths)} files; saved {saved / 1e6:.1f} MB', flush=True)
                    REPORT.write_text(json.dumps(report, indent=2), encoding='utf-8')
    finally:
        changes = {r['oldSha256']: r for r in report['files'] if r['before'] != r['after']}
        if APPLY and changes:
            # Source-asset audit manifests may describe identical copies in
            # asset/, which are untouched. Only streaming manifests refer to
            # the recompressed runtime PNGs through their vfx.json URLs.
            for p in BUILD.glob('*/streaming.json'):
                try:
                    data = json.loads(p.read_text(encoding='utf-8-sig'))
                except (UnicodeError, json.JSONDecodeError):
                    continue
                count = update(data, changes)
                if count:
                    replace(p, (json.dumps(data, indent=2, ensure_ascii=False) + '\n').encode('utf-8'))
                    report['metadata'].append({'path': str(p.relative_to(ROOT)), 'records': count})
        report['before'] = sum(r['before'] for r in report['files'])
        report['after'] = sum(r['after'] for r in report['files'])
        report['saved'] = report['before'] - report['after']
        report['elapsed_seconds'] = round(time.monotonic() - started, 1)
        REPORT.write_text(json.dumps(report, indent=2), encoding='utf-8')
    print(json.dumps({k: report[k] for k in ['before', 'after', 'saved', 'elapsed_seconds']}), flush=True)
