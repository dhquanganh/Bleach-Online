"""Publish the rebuilt client at a fresh URL and update the real Flash manifest."""
import hashlib
from pathlib import Path
import re
import shutil
import struct
import zlib
from datetime import datetime

BASE = Path(__file__).resolve().parent
PUBLIC = BASE.parents[1] / 'kaynak/login.gogames.me/public'


def read_manifest(data):
    raw = zlib.decompress(data)
    count = struct.unpack_from('<H', raw)[0]
    offset, entries = 2, []
    for _ in range(count):
        fields = []
        for _ in range(2):
            size = struct.unpack_from('<H', raw, offset)[0]
            offset += 2
            fields.append(raw[offset:offset + size])
            offset += size
        entries.append(tuple(fields))
    assert offset == len(raw), 'Unexpected manifest trailer'
    assert sum(key == b'TApplication.swf' for key, _ in entries) == 1
    return entries


def write_manifest(entries):
    parts = [struct.pack('<H', len(entries))]
    for key, value in entries:
        for field in (key, value):
            parts.extend([struct.pack('<H', len(field)), field])
    return zlib.compress(b''.join(parts))


def publish_client(data, public=PUBLIC, backups=BASE / 'backups'):
    manifest = public / '2026090619/version.swf'
    original = manifest.read_bytes()
    entries = read_manifest(original)
    today = datetime.now().strftime('%Y%m%d')
    revisions = [int(p.name) for p in public.iterdir() if p.is_dir() and re.fullmatch(today + r'\d{2}', p.name)]
    revision = str(max(revisions + [int(today + '00')]) + 1)
    target = public / revision / 'TApplication.swf'
    updated = [(key, revision.encode('ascii') if key == b'TApplication.swf' else value) for key, value in entries]
    assert [e for e in entries if e[0] != b'TApplication.swf'] == [e for e in updated if e[0] != b'TApplication.swf']
    encoded = write_manifest(updated)
    assert read_manifest(encoded) == updated
    backups.mkdir(parents=True, exist_ok=True)
    backup = backups / (datetime.now().strftime('%Y%m%d-%H%M%S-%f') + '-version.swf.bak')
    shutil.copy2(manifest, backup)
    target.parent.mkdir(exist_ok=False)
    target.write_bytes(data)
    assert target.read_bytes() == data
    assert manifest.read_bytes() == original, 'Manifest changed during publishing'
    manifest.write_bytes(encoded)
    assert (public / dict(read_manifest(manifest.read_bytes()))[b'TApplication.swf'].decode() / 'TApplication.swf').read_bytes() == data
    print('Flash manifest now selects:', target)
    print('Published SHA256:', hashlib.sha256(data).hexdigest())
    print('Manifest backup:', backup)
    return target


if __name__ == '__main__':
    publish_client((PUBLIC / '2026090619/TApplication.swf').read_bytes())
