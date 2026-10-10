"""Install the runtime-tested UI and battle route without changing player data."""
from pathlib import Path
from datetime import datetime
import sys,shutil,subprocess
BASE=Path(__file__).resolve().parent
sys.path.insert(0,str(BASE.parent/'flash-cross-server'))
from build import swap,tags,CLIENT
compiled=(BASE/'runtime-probe/final.swf').read_bytes()
baseline=swap((BASE/'backups/20261010-163226-before-native-ui.swf.bak').read_bytes())
assert [t for t in tags(compiled) if t[0]!=82]==[t for t in tags(baseline) if t[0]!=82]
code=(BASE/'validation/decompiled/scripts/Processors/Game/Lobby/TProcessorLobby.as').read_text(encoding='utf-8')
for name in ['IllusionText','IllusionBox','IllusionButton','IllusionRow']:
 assert f'function {name}(parent:Sprite,' in code, f'Missing parameters: {name}'
assert 'anchor != null && !this.BattleQueryActive()' in code
root=(BASE/'validation/decompiled/scripts/Processors/Game/TProcessorGameRoot.as').read_text(encoding='utf-8')
assert 'RegisterRange(18382336,18382337,this.PacketPerform_ProcessorLobby)' in root
runtime=(BASE/'runtime-probe/runtime.log').read_text(encoding='utf-8')
assert 'INIT child document loaded' in runtime and 'RUNTIME ERROR' not in runtime
assert 'AUTO CLICK 1080,512' in runtime and 'AUTO CLICK 671,366' in runtime
assert (BASE/'validation/boss-battle.png').exists() and (BASE/'validation/boss-result.png').exists()
old=CLIENT.read_bytes();backup=BASE/'backups'/(datetime.now().strftime('%Y%m%d-%H%M%S')+'-before-1063-fix.swf.bak')
shutil.copy2(CLIENT,backup)
protected=swap(compiled);CLIENT.write_bytes(protected)
for version in ['2026101001','2026101002','2026101003']:
 alias=CLIENT.parent.parent/version/'TApplication.swf'
 if alias.exists():alias.write_bytes(protected)
subprocess.run([sys.executable,str(BASE/'refresh-loader.py')],check=True)
assert CLIENT.read_bytes()==protected
print('Installed Flash-runtime-tested startup and Challenge fix. Backup:',backup)
