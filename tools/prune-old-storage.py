"""Remove old package backups and isolated test sandboxes. Default: dry run.

python tools/prune-old-storage.py --apply
This discards rollback package copies, while preserving active resources and
all SWF/config/source baselines used by builders. Junctions are never followed.
"""
from pathlib import Path
import argparse
import ctypes
import hashlib
import json
import os
import stat
import time

ROOT = Path(__file__).resolve().parents[1]
BUILD = ROOT / 'sunucu-kok/cikarim'
SANDBOXES = ['.battlefield-runtime-test', '.boss-runtime-test', '.partner-runtime-test']
REPARSE = stat.FILE_ATTRIBUTE_REPARSE_POINT


def linked(path):
    return bool(os.lstat(path).st_file_attributes & REPARSE)


def files(base):
    for folder, dirs, names in os.walk(base, followlinks=False):
        dirs[:] = [d for d in dirs if not linked(Path(folder) / d)]
        for name in names:
            p = Path(folder) / name
            if not linked(p):
                yield p


def safe(path):
    path.resolve().relative_to(ROOT)
    for parent in [path, *path.parents]:
        if parent == ROOT:
            break
        if linked(parent):
            raise RuntimeError(f'Refusing linked deletion target: {path}')


def sha(path):
    h = hashlib.sha256()
    with path.open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            h.update(block)
    return h.hexdigest()


def protected():
    result = {}
    for base in ['asset', 'sunucu-kok/kaynak', 'sunucu-kok/sunucu',
                 'sunucu-kok/cikarim/veri-json', 'sunucu-kok/cikarim/veri-json-yedek']:
        for p in files(ROOT / base):
            if p.suffix in {'.db', '.db-wal', '.db-shm'} or '__pycache__' in p.parts:
                continue
            result[str(p.relative_to(ROOT))] = sha(p)
    return result


def remove_sandbox_directories():
    for name in SANDBOXES:
        base = ROOT / name
        if not base.exists():
            continue
        safe(base)
        directories = []
        # Python 3.10 os.walk can traverse Windows junctions even with
        # followlinks=False. Prune them explicitly before descending.
        for folder, dirs, names in os.walk(base, topdown=True, followlinks=False):
            directories.append(Path(folder))
            for d in list(dirs):
                child = Path(folder) / d
                if linked(child):
                    child.absolute().relative_to(base)
                    child.rmdir()
                    dirs.remove(d)
        for folder in reversed(directories):
            safe(folder)
            folder.rmdir()


def stored(path):
    high = ctypes.c_ulong()
    ctypes.set_last_error(0)
    low = disk_size(str(path), ctypes.byref(high))
    if low == 0xffffffff and ctypes.get_last_error():
        raise ctypes.WinError(ctypes.get_last_error())
    return high.value * 2**32 + low


if __name__ == '__main__':
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--apply', action='store_true')
    args = ap.parse_args()
    kernel = ctypes.WinDLL('kernel32', use_last_error=True)
    disk_size = kernel.GetCompressedFileSizeW
    disk_size.argtypes = [ctypes.c_wchar_p, ctypes.POINTER(ctypes.c_ulong)]
    disk_size.restype = ctypes.c_ulong
    targets = []
    for p in files(BUILD):
        # Never select SWF baselines, JSON backups, textures, source or live data.
        parts = p.relative_to(BUILD).parts[:-1]
        if p.suffix == '.binPackage' and any('backup' in part.lower() for part in parts):
            targets.append(('old-package-backup', p))
    for name in SANDBOXES:
        base = ROOT / name
        if base.exists():
            safe(base)
            targets.extend(('isolated-test-sandbox', p) for p in files(base))
    records = []
    for category, p in targets:
        safe(p)
        records.append({'category': category, 'path': str(p.relative_to(ROOT)),
                        'bytes': p.stat().st_size, 'stored_bytes': stored(p)})
    report = {'date': time.strftime('%Y-%m-%dT%H:%M:%S%z'), 'applied': False,
              'files': records, 'bytes': sum(r['bytes'] for r in records),
              'stored_bytes': sum(r['stored_bytes'] for r in records)}
    output = ROOT / 'tools/prune-report.json'
    output.write_text(json.dumps(report, indent=2), encoding='utf-8')
    print(json.dumps({'files': len(records), 'bytes': report['bytes'],
                      'stored_bytes': report['stored_bytes'], 'apply': args.apply}), flush=True)
    if args.apply:
        before = protected()
        report['protected_sha256_before'] = before
        output.write_text(json.dumps(report, indent=2), encoding='utf-8')
        print(f'Protected file hashes recorded: {len(before)}', flush=True)
        for record in records:
            p = ROOT / record['path']
            safe(p)
            if p.stat().st_size != record['bytes']:
                raise RuntimeError(f'Target changed since planning: {p}')
            p.unlink()
        remove_sandbox_directories()
        print('Deletion complete; verifying active resources...', flush=True)
        after = protected()
        changed = sorted(k for k in before.keys() | after.keys() if before.get(k) != after.get(k))
        report['applied'] = True
        report['verification'] = {'sha256_checked': len(before), 'changed': changed}
        output.write_text(json.dumps(report, indent=2), encoding='utf-8')
        print(json.dumps({'deleted_files': len(records), 'logical_bytes_removed': report['bytes'],
                          'stored_bytes_removed': report['stored_bytes'],
                          'verified_files': len(before), 'changed': changed}), flush=True)
        raise SystemExit(bool(changed))
