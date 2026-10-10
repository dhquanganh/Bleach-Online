from pathlib import Path
import hashlib
BASE=Path(__file__).resolve().parent
pcode=(BASE/'pcode-verify/scripts/Processors/Game/Lobby/TProcessorLobby.pcode').read_text(encoding='utf-8')
for package,name in [('Processors.Game.Battle','TBattleHandle'),('','JSON'),('flash.display','Sprite'),('flash.display','Loader'),('flash.geom','Point'),('flash.text','TextField')]:
 target=f'QName(PackageNamespace("{package}"),"{name}")'
 assert target in pcode, target
 print('Verified native class:',package+'.'+name)
assert 'QName(PackageNamespace(""),"TBattleHandle")' not in pcode
public=BASE.parents[1]/'kaynak/login.gogames.me/public'
canonical=(public/'2026090619/TApplication.swf').read_bytes()
assert canonical==(public/'2026101001/TApplication.swf').read_bytes()==(public/'2026101002/TApplication.swf').read_bytes()
print('Verified canonical and loader application files:',hashlib.sha256(canonical).hexdigest())
