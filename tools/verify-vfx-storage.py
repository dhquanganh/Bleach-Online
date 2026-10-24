"""Verify lossless VFX compression reports and current source/stream manifests."""
from pathlib import Path
import hashlib
import json
import runpy
import zlib

ROOT = Path(__file__).resolve().parents[1]
BUILD = ROOT / 'sunucu-kok/cikarim'
PUBLIC = ROOT / 'sunucu-kok/kaynak/login.gogames.me'
png_codec = runpy.run_path(str(ROOT / 'tools/compress-vfx-png.py'))


def sha(data):
    return hashlib.sha256(data).hexdigest()


checked = 0
for filename, kind in [('vfx-compression-report.json', 'argb'), ('vfx-png-compression-report.json', 'png')]:
    report = json.loads((ROOT / 'tools' / filename).read_text())
    assert report['applied']
    for record in report['files']:
        data = (ROOT / record['path']).read_bytes()
        assert len(data) == record['after'] and sha(data) == record['newSha256'], record['path']
        if kind == 'argb':
            assert sha(zlib.decompress(data)[8:]) == record['pixelSha256'], record['path']
        else:
            _, scanlines = png_codec['parse'](data)
            assert sha(scanlines) == record['scanlineSha256'], record['path']
        checked += 1
    print(f'PASS {kind}: {len(report["files"])} files', flush=True)

baseline = json.loads((ROOT / 'tools/vfx-streaming-before.json').read_text())
streams_checked = 0
for path in BUILD.glob('*/streaming.json'):
    streams = json.loads(path.read_text())
    old = json.loads(baseline[str(path.relative_to(ROOT))])
    vfx = json.loads((path.parent / 'vfx.json').read_text())
    assert set(streams) == set(old) == set(vfx['atlases'])
    for name, record in streams.items():
        for key in ['width', 'height', 'pixelSha256']:
            assert record[key] == old[name][key], (path, name, key)
        png = PUBLIC / vfx['atlases'][name]['url'].lstrip('/')
        argb = png.with_suffix('.argb').read_bytes()
        assert sha(png.read_bytes()) == record['sourcePngSha256'], (path, name)
        assert sha(argb) == record['fileSha256'] and len(argb) == record['bytes'], (path, name)
        assert sha(zlib.decompress(argb)[8:]) == record['pixelSha256'], (path, name)
        streams_checked += 1
    print(f'PASS manifest: {path.parent.name}, {len(streams)} streams', flush=True)

result = {'files_checked': checked, 'manifest_streams_checked': streams_checked,
          'original_pixel_hashes_unchanged': True, 'passed': True}
(ROOT / 'tools/vfx-storage-verification.json').write_text(json.dumps(result, indent=2) + '\n')
print(json.dumps(result), flush=True)
