"""Recompile the patched Reincarnation AS3 classes, verify assets, then optionally install."""
import argparse
import hashlib
import shutil
import struct
import subprocess
import zlib
from datetime import datetime
from pathlib import Path

BASE = Path(__file__).resolve().parent
CLIENT = BASE.parents[1] / 'kaynak/login.gogames.me/public/2026090619/TApplication.swf'
CLASSES = 'Logics.Rebirth.TRebirthData,Logics.Streamization.Rebirth.TUnstreamizerRebirth,Processors.Game.Lobby.Rebirth.TProcessorWindowRebirthReset,Processors.Game.Lobby.Rebirth.TProcessorWindowHeroRebirth,Processors.Game.Lobby.Rebirth.TProcessorRebirth'

def swap(data):
    data = bytearray(data)
    for a, b in [(1, 10), (20, 200)]:
        data[a], data[b] = data[b], data[a]
    return bytes(data)

def tags(data):
    assert data[:3] == b'CWS'
    raw = data[:8] + zlib.decompress(data[8:])
    assert len(raw) == struct.unpack_from('<I', raw, 4)[0]
    bits = raw[8] >> 3
    pos = 8 + (5 + 4 * bits + 7) // 8 + 4
    result = []
    while pos < len(raw):
        head = struct.unpack_from('<H', raw, pos)[0]
        pos += 2
        kind, length = head >> 6, head & 63
        if length == 63:
            length = struct.unpack_from('<I', raw, pos)[0]
            pos += 4
        result.append((kind, raw[pos:pos + length]))
        pos += length
        if kind == 0:
            break
    assert pos == len(raw)
    return result

def main():
    args = argparse.ArgumentParser()
    args.add_argument('--ffdec', type=Path, required=True, help='Path to ffdec.jar')
    args.add_argument('--install', action='store_true')
    args.add_argument('--window-only', action='store_true')
    args.add_argument('--tower-only', action='store_true')
    args.add_argument('--popup-only', action='store_true')
    args.add_argument('--baseline', type=Path)
    opts = args.parse_args()
    original = CLIENT.read_bytes()
    decoded = swap(opts.baseline.read_bytes() if opts.baseline else original)
    old_tags = tags(decoded)
    source, compiled = BASE / 'TApplication-decoded.swf', BASE / 'TApplication-compiled.swf'
    source.write_bytes(decoded)
    def ffdec(*args):
        completed = subprocess.run(['java', '-Xmx2g', '-jar', str(opts.ffdec), *map(str, args)], capture_output=True, text=True, errors='replace')
        if completed.returncode:
            raise RuntimeError(completed.stdout + completed.stderr)
    order = ['Logics/Rebirth/TRebirthData.as','Logics/Streamization/Rebirth/TUnstreamizerRebirth.as','Processors/Game/Lobby/Rebirth/TProcessorWindowRebirthReset.as','Processors/Game/Lobby/Rebirth/TProcessorWindowHeroRebirth.as','Processors/Game/Lobby/Rebirth/TProcessorRebirth.as']
    if opts.window_only: order = [order[3]]
    previous = source
    for index, name in enumerate(order):
        phase = BASE / ('phase-' + str(index))
        target = phase / name
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(BASE / 'patched' / name, target)
        output = compiled if index == len(order)-1 else BASE / ('phase-' + str(index) + '.swf')
        print('Compiling', name, flush=True)
        ffdec('-onerror', 'abort', '-importScript', previous, output, phase)
        previous = output

    rebuilt = compiled.read_bytes()
    new_tags = tags(rebuilt)
    assert len(old_tags) == len(new_tags)
    assert [t for t in old_tags if t[0] != 82] == [t for t in new_tags if t[0] != 82], 'Non-code SWF assets changed'
    ffdec('-selectclass', CLASSES, '-export', 'script', BASE / 'verify', compiled)
    scripts = BASE / 'verify/scripts'
    ui=(scripts/'Processors/Game/Lobby/Rebirth/TProcessorWindowHeroRebirth.as').read_text(encoding='utf-8')
    assert '100 fragments of this partner' in ui and 'Core stats:' in ui and 'row.ChipID' in ui
    assert 'this.FHero.IsMain' in ui and 'this.FFragmentSlot.Update()' in ui
    stream=(scripts/'Logics/Streamization/Rebirth/TUnstreamizerRebirth.as').read_text(encoding='utf-8')
    assert 'param1.bytesAvailable >= 17' in stream
    protected = swap(rebuilt)
    assert swap(protected) == rebuilt
    output = BASE / 'TApplication-protected.swf'
    output.write_bytes(protected)
    digest = hashlib.sha256(protected).hexdigest()
    print('Verified compiled client; only AS3 bytecode changed. SHA256:', digest)
    if opts.install:
        assert CLIENT.read_bytes() == original, 'Client changed during compilation'
        backup = BASE / 'backups' / (datetime.now().strftime('%Y%m%d-%H%M%S-%f') + '-TApplication.swf.bak')
        backup.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(CLIENT, backup)
        CLIENT.write_bytes(protected)
        print('Installed:', CLIENT)
        print('Backup:', backup)

if __name__ == '__main__':
    main()
