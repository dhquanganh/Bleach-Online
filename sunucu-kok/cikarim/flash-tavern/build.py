from pathlib import Path
import sys, subprocess, shutil
from datetime import datetime
BASE = Path(__file__).resolve().parent
sys.path.insert(0, str(BASE.parent / 'flash-cross-server'))
import build
JAR = 'C:/Users/quang/AppData/Local/Temp/ffdec-void/regular/ffdec.jar'
live = build.CLIENT.read_bytes()
old = build.swap(live)
source = BASE / 'source.swf'
source.write_bytes(old)
order = ['TProcessorWindowRecruit', 'TProcessorWindowChangeCard', 'TProcessorWindowTavern', 'TProcessorWindowTavernMora', 'TProcessorTavern']
for i, name in enumerate(order):
    phase = BASE / ('phase-' + datetime.now().strftime('%Y%m%d-%H%M%S-%f'))
    rel = Path('Processors/Game/Lobby/Tavern') / (name + '.as')
    target = phase / rel
    target.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(BASE / 'patched' / rel, target)
    out = BASE / ('phase-' + str(i) + '.swf')
    print('Compiling', name, flush=True)
    subprocess.run(['java', '-Xmx2g', '-jar', JAR, '-onerror', 'abort', '-importScript', str(source), str(out), str(phase)], check=True)
    source = out
new = source.read_bytes()
assert [t for t in build.tags(old) if t[0] != 82] == [t for t in build.tags(new) if t[0] != 82]
subprocess.run(['java', '-Xmx2g', '-jar', JAR, '-selectclass', ','.join('Processors.Game.Lobby.Tavern.' + n for n in order), '-export', 'script', str(BASE / 'verify'), str(source)], check=True)
checks = {'TProcessorWindowTavernMora': 'RetryMora', 'TProcessorWindowRecruit': 'PendingRecruitId', 'TProcessorWindowChangeCard': '32767', 'TProcessorWindowTavern': 'this.FCharacter.HeroSoulBlueSoul = param2', 'TProcessorTavern': 'TProcessorWindowRecruit.PendingRecruitId == _loc6_.Identifier'}
for name, expected in checks.items():
    assert expected in (BASE / 'verify/scripts/Processors/Game/Lobby/Tavern' / (name + '.as')).read_text()
assert build.CLIENT.read_bytes() == live, 'Live client changed during compilation'
shutil.copy2(build.CLIENT, BASE / ('backup-' + datetime.now().strftime('%Y%m%d-%H%M%S') + '.swf.bak'))
build.CLIENT.write_bytes(build.swap(new))
alias = build.CLIENT.parent.parent / '2026101001/TApplication.swf'
if alias.parent.exists():
    shutil.copy2(build.CLIENT, alias)
print('Installed verified Tavern client in both loader paths; assets preserved.')
