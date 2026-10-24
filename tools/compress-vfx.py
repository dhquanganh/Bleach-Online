"""Losslessly recompress Naruto VFX ARGB streams using the existing zlib format.

Run with --apply to write files. PNGs and decoded pixels stay unchanged.
"""
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
REPORT = ROOT / 'tools/vfx-compression-report.json'


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


def compress(path):
    old = path.read_bytes()
    raw = zlib.decompress(old)
    w, h = struct.unpack_from('>II', raw)
    assert len(raw) == 8 + w * h * 4, path
    new = zlib.compress(raw, 9)
    assert zlib.decompress(new) == raw, path
    if len(new) >= len(old):
        new = old
    result = {'path': str(path.relative_to(ROOT)), 'before': len(old), 'after': len(new),
              'oldSha256': sha(old), 'newSha256': sha(new), 'pixelSha256': sha(raw[8:]),
              'width': w, 'height': h}
    if APPLY and new != old:
        replace(path, new)
        written = path.read_bytes()
        assert sha(written) == result['newSha256'] and zlib.decompress(written) == raw, path
    return result


def update_records(value, changes):
    updated = 0
    if isinstance(value, dict):
        old = value.get('fileSha256')
        if old in changes:
            record = changes[old]
            # Existing source and pixel hashes must continue to describe these pixels.
            if 'pixelSha256' in value:
                assert value['pixelSha256'] == record['pixelSha256']
            value['fileSha256'] = record['newSha256']
            if 'bytes' in value:
                value['bytes'] = record['after']
            updated += 1
        for key, child in value.items():
            if key == 'sha256' and isinstance(child, str) and child in changes:
                value[key] = changes[child]['newSha256']
                updated += 1
            else:
                updated += update_records(child, changes)
    elif isinstance(value, list):
        for child in value:
            updated += update_records(child, changes)
    return updated


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--apply', action='store_true')
    APPLY = parser.parse_args().apply
    paths = sorted(p for d in PUBLIC.glob('*-vfx') for p in d.rglob('*.argb'))
    report = {'applied': APPLY, 'compression_level': 9, 'files': [], 'metadata': [], 'scripts': []}
    started = time.monotonic()
    print(f'ARGB files: {len(paths)}; apply={APPLY}', flush=True)
    # Preflight and retain metadata on disk so interrupted runs can be reconciled.
    metadata = {str(p.relative_to(ROOT)): p.read_text(encoding='utf-8-sig')
                for p in BUILD.glob('*/streaming.json')}
    if APPLY:
        (ROOT / 'tools/vfx-streaming-before.json').write_text(json.dumps(metadata), encoding='utf-8')
    try:
        with ThreadPoolExecutor(max_workers=2) as pool:
            for index, result in enumerate(pool.map(compress, paths), 1):
                report['files'].append(result)
                if index % 50 == 0:
                    saved = sum(r['before'] - r['after'] for r in report['files'])
                    print(f'{index}/{len(paths)} files; saved {saved / 1e6:.1f} MB', flush=True)
                    REPORT.write_text(json.dumps(report, indent=2), encoding='utf-8')
    finally:
        # Synchronize hashes even if a later stream fails validation.
        changes = {r['oldSha256']: r for r in report['files'] if r['before'] != r['after']}
        if APPLY and changes:
            # Only manifests containing an exact compressed-file hash are rewritten.
            for p in BUILD.rglob('*.json'):
                if 'video-tools' in p.parts or p.name == REPORT.name:
                    continue
                try:
                    data = json.loads(p.read_text(encoding='utf-8-sig'))
                except (UnicodeError, json.JSONDecodeError):
                    continue
                count = update_records(data, changes)
                if count:
                    replace(p, (json.dumps(data, indent=2, ensure_ascii=False) + '\n').encode('utf-8'))
                    report['metadata'].append({'path': str(p.relative_to(ROOT)), 'records': count})
        report['before'] = sum(r['before'] for r in report['files'])
        report['after'] = sum(r['after'] for r in report['files'])
        report['saved'] = report['before'] - report['after']
        report['elapsed_seconds'] = round(time.monotonic() - started, 1)
        REPORT.write_text(json.dumps(report, indent=2), encoding='utf-8')
    if APPLY:
        for p in BUILD.glob('*/prepare-streaming.py'):
            source = p.read_text(encoding='utf-8')
            patched = source.replace('zlib.compress(raw,1)', 'zlib.compress(raw,9)')
            if patched != source:
                replace(p, patched.encode('utf-8'))
                report['scripts'].append(str(p.relative_to(ROOT)))
    REPORT.write_text(json.dumps(report, indent=2), encoding='utf-8')
    print(json.dumps({k: report[k] for k in ['before', 'after', 'saved', 'elapsed_seconds']}), flush=True)
