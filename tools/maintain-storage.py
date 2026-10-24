"""Audit storage without following junctions; optionally clear caches and NTFS-compress assets.

Usage: python tools/maintain-storage.py [--apply] [--compress]
Compression preserves ordinary file access; compact /U reverses it.
"""
import argparse
import ctypes
import hashlib
import json
import os
from pathlib import Path
import stat
import subprocess
import time

ROOT = Path(__file__).resolve().parents[1]
REPORT = ROOT / 'tools' / 'storage-report.json'
REPARSE = stat.FILE_ATTRIBUTE_REPARSE_POINT
CACHES = {'Cache', 'Code Cache', 'GPUCache', 'DawnCache', 'GrShaderCache', 'ShaderCache'}
COMPRESS_ROOTS = ['asset', 'sunucu-kok/cikarim', 'sunucu-kok/kaynak']


def is_link(path):
    return bool(os.lstat(path).st_file_attributes & REPARSE)


def walk(base):
    for folder, dirs, files in os.walk(base, followlinks=False):
        dirs[:] = [d for d in dirs if not is_link(Path(folder) / d)]
        yield Path(folder), dirs, files


def allocated(path):
    high = ctypes.c_ulong()
    ctypes.set_last_error(0)
    low = size_on_disk(str(path), ctypes.byref(high))
    if low == 0xFFFFFFFF and ctypes.get_last_error():
        raise ctypes.WinError(ctypes.get_last_error())
    return (high.value << 32) | low


def inventory():
    groups = {}
    candidates = []
    for folder, dirs, files in walk(ROOT):
        if folder == ROOT:
            dirs[:] = [d for d in dirs if d != '.git']
        for d in list(dirs):
            if d == '__pycache__' or ('cikarim' in folder.parts and d in CACHES):
                candidates.append(folder / d)
        for name in files:
            path = folder / name
            if is_link(path):
                continue
            group = path.relative_to(ROOT).parts[0]
            item = groups.setdefault(group, {'files': 0, 'logical': 0, 'stored': 0})
            item['files'] += 1
            item['logical'] += path.stat().st_size
            item['stored'] += allocated(path)
    return groups, candidates


def digest(path):
    h = hashlib.sha256()
    with path.open('rb') as source:
        for block in iter(lambda: source.read(1024 * 1024), b''):
            h.update(block)
    return h.hexdigest()


def remove_cache(path):
    # Resolve and check each target before deletion; refuse all reparse points.
    path.resolve().relative_to(ROOT)
    if is_link(path):
        raise RuntimeError(f'Refusing linked cache: {path}')
    entries = list(walk(path))
    for folder, dirs, files in entries:
        for entry in folder.iterdir():
            if is_link(entry):
                raise RuntimeError(f'Refusing cache containing link: {entry}')
    removed = 0
    for folder, dirs, files in reversed(entries):
        for name in files:
            target = folder / name
            removed += target.stat().st_size
            target.unlink()
        folder.rmdir()
    return removed


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--apply', action='store_true')
    parser.add_argument('--compress', action='store_true')
    args = parser.parse_args()
    kernel = ctypes.WinDLL('kernel32', use_last_error=True)
    size_on_disk = kernel.GetCompressedFileSizeW
    size_on_disk.argtypes = [ctypes.c_wchar_p, ctypes.POINTER(ctypes.c_ulong)]
    size_on_disk.restype = ctypes.c_ulong
    before, candidates = inventory()
    # Avoid double deleting nested cache directories.
    candidates = [p for p in candidates if not any(q in p.parents for q in candidates)]
    report = {'created': time.strftime('%Y-%m-%dT%H:%M:%S%z'), 'before': before,
              'cache_candidates': [str(p.relative_to(ROOT)) for p in candidates],
              'deleted_bytes': 0, 'compression': [], 'errors': []}
    print(json.dumps({'before': before, 'cache_directories': len(candidates)}), flush=True)
    if args.apply:
        for path in candidates:
            try:
                report['deleted_bytes'] += remove_cache(path)
            except OSError as error:
                report['errors'].append(str(error))
        print(f"Deleted cache bytes: {report['deleted_bytes']}", flush=True)
        # All character source assets and a deterministic runtime sample.
        samples = []
        for base in COMPRESS_ROOTS:
            paths = sorted(p / f for p, ds, fs in walk(ROOT / base) for f in fs)
            samples.extend(paths if base == 'asset' else paths[::100])
        hashes = {str(p.relative_to(ROOT)): digest(p) for p in samples}
        if args.compress:
            for base in COMPRESS_ROOTS:
                target = ROOT / base
                target.resolve().relative_to(ROOT)
                # compact traverses directories itself, so reject nested links.
                if any(is_link(Path(p) / d) for p, ds, fs in os.walk(target)
                       for d in ds):
                    raise RuntimeError(f'Compression root contains a junction: {target}')
                log = ROOT / 'tools' / ('compact-' + base.replace('/', '-') + '.log')
                with log.open('w', encoding='utf-8') as output:
                    result = subprocess.run(['compact.exe', '/C', '/I', '/Q', f'/S:{target}', str(target / '*')],
                                            stdout=output, stderr=subprocess.STDOUT)
                report['compression'].append({'root': base, 'exit_code': result.returncode})
                print(f'Compressed {base}: exit {result.returncode}', flush=True)
        changed = [name for name, expected in hashes.items() if digest(ROOT / name) != expected]
        report['verification'] = {'sha256_checked': len(hashes), 'changed': changed}
        if changed:
            report['errors'].append('Content verification failed')
    after, _ = inventory()
    report['after'] = after
    report['stored_bytes_saved'] = sum(g['stored'] for g in before.values()) - sum(g['stored'] for g in after.values())
    REPORT.write_text(json.dumps(report, indent=2, ensure_ascii=False), encoding='utf-8')
    print(json.dumps({'stored_bytes_saved': report['stored_bytes_saved'], 'errors': report['errors'],
                      'report': str(REPORT)}), flush=True)
    raise SystemExit(bool(report['errors'] or any(c['exit_code'] for c in report['compression'])))
