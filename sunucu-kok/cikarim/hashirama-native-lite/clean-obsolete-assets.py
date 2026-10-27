"""Remove generated public Hashirama atlases after the native release is active."""
from pathlib import Path
import json

B = Path(__file__).resolve().parent
P = B.parents[1]/'kaynak/login.gogames.me/public'
ROOT = (P/'hashirama-vfx/extracted').resolve()

def main():
    assert json.loads((P/'client-release.json').read_text())['version'] == '2026102702'
    assert (P/'2026102702/TApplication.swf').is_file()
    assert len(list((P/'hashirama-vfx/native').glob('*.swf'))) == 6
    files = sorted(f for f in ROOT.rglob('*') if f.is_file())
    assert len(files) == 147
    for f in files:
        assert f.resolve().is_relative_to(ROOT)
        assert f.suffix.lower() in {'.png','.swf'}
    size = sum(f.stat().st_size for f in files)
    for f in files:
        f.unlink()
    print(f'PASS removed {len(files)} generated files ({size/1048576:.1f} MiB)')

if __name__ == '__main__':
    main()
