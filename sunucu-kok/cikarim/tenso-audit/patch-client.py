"""Build and install Tensō fixes over the current client; preserve non-code assets."""
from pathlib import Path
import importlib.util, subprocess, struct, zlib, shutil, hashlib
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('swf_helpers',BASE.parent/'flash-refinery/build.py')
h=importlib.util.module_from_spec(spec);spec.loader.exec_module(h)
original=h.CLIENT.read_bytes();source=BASE/'source.swf'
assert h.swap(original)==source.read_bytes(),'Re-export the current client before building'
root=BASE/'original/scripts';patched=BASE/'patched'
def edit(path,changes):
    text=(root/path).read_text(encoding='utf-8')
    for old,new in changes:
        assert old in text,(path,old)
        text=text.replace(old,new)
    target=patched/path;target.parent.mkdir(parents=True,exist_ok=True);target.write_text(text,encoding='utf-8')
edit(Path('Logics/ExpDuplicate/TExpDuplicateData.as'),[('protected var FEnemyArmy','public var Pending:Boolean = false;\n      \n      protected var FEnemyArmy')])
edit(Path('Logics/Streamization/ExpDuplicate/TUnstreamizerExpDuplicate.as'),[
 ('this.FData.ConfigValueVO.BattleCount - _loc2_', 'Math.max(0,this.FData.ConfigValueVO.BattleCount - _loc2_)'),
 ('_loc6_.EnemyArmyID = _loc5_;','if(_loc6_.EnemyArmyID != _loc5_) _loc6_.SkillBuff.length = 0;\n            _loc6_.EnemyArmyID = _loc5_;'),
 ('_loc5_.RefreshCount = param1.readInt();','if(_loc5_ == null) return;\n         _loc5_.RefreshCount = param1.readInt();')])
edit(Path('Processors/Game/Lobby/ExpDuplicate/TProcessorExpDupItemCom.as'),[
 ('this.FMainUI.TF_Name.visible = false;','this.FMainUI.TF_Name.visible = true;\n            this.FMainUI.TF_Name.text = this.FData.Config.Name;'),
 ('TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ExpDupItem_01),this.FData.Config.LvLimit)','"Lv." + this.FData.Config.LvLimit'),
 ('TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ExpDupItem_02),this.FData.Exp)','"Fixed Rewards: Exp+" + this.FData.Exp'),
 ('TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ExpDupItem_03),this.FData.Config.RewardTxt)','"Possible Primogems: 0-" + this.FData.Config.RewardTxt'),
 ('TUtilityTexture.QueryTwoDirectionShowCase(CONST_MAP.DIRECTION_RIGHT,_loc1_.LeaderID,this.FQueryModel);','if(_loc1_ == null) return;\n            TUtilityTexture.QueryTwoDirectionShowCase(CONST_MAP.DIRECTION_RIGHT,_loc1_.LeaderID,this.FQueryModel);')])
edit(Path('Processors/Game/Lobby/ExpDuplicate/TProcessorWindowExpDuplicate.as'),[
 ('this.FSelectIndex = param1;','if(this.FData.Pending || param1 >= this.FData.EnemyArmy.length) return;\n         this.FSelectIndex = param1;'),
 ('if(_loc2_.SkillBuff.length == 0)','if(true)'),
 ('this.FUnstreamizer.SkillReq(_loc2_);','this.FData.Pending = true;\n            this.FUnstreamizer.SkillReq(_loc2_);')])
edit(Path('Processors/Game/Lobby/ExpDuplicate/TProcessorWindowExpDupBattle.as'),[
 ('this.FOnSetBattleStatus(this,CONST_BATTLE.BattleType_ExpDuplicate,0);','if(this.FData.Pending || this.FData.RemainBattle == 0 || this.FItemVO == null) return;\n         this.FData.Pending = true;\n         this.Update();\n         this.FOnSetBattleStatus(this,CONST_BATTLE.BattleType_ExpDuplicate,0);'),
 ('_loc5_ = this.FData.ConfigValueVO.RefreshPrice.length;','if(this.FData.Pending || this.FData.RemainBattle == 0) return;\n         _loc5_ = this.FData.ConfigValueVO.RefreshPrice.length;\n         if(_loc5_ == 0) return;'),
 ('this.FUnstreamizer.RefreshReq(this.FItemVO);','if(this.FData.Pending || this.FData.RemainBattle == 0) return;\n         this.FData.Pending = true;\n         this.Update();\n         this.FUnstreamizer.RefreshReq(this.FItemVO);'),
 ('_loc5_ = _loc6_.Desc;','if(_loc6_ == null) continue;\n            _loc5_ = _loc6_.Desc;'),
 ('if(this.FData.RemainBattle <= 0)','this.FRefreshBtn.Enabled = this.FData.RemainBattle > 0 && !this.FData.Pending;\n         if(this.FData.RemainBattle <= 0 || this.FData.Pending)')])
edit(Path('Processors/Game/Lobby/ExpDuplicate/TProcessorExpDuplicate.as'),[
 ('this.FUnstreamizer.InitRet(param1.Data);','this.FData.Pending = false;\n         this.FUnstreamizer.InitRet(param1.Data);'),
 ('_loc2_ = param1.Data.readInt();','this.FData.Pending = false;\n         this.FMainWin.Update();\n         _loc2_ = param1.Data.readInt();')])
jar=BASE.parents[2]/'.tools/ffdec/ffdec-cli.jar'
def ff(*args):
    result=subprocess.run(['java','-Xmx2g','-jar',str(jar),*map(str,args)],capture_output=True,text=True,errors='replace')
    if result.returncode:raise RuntimeError(result.stdout+result.stderr)
output=BASE/'compiled.swf';ff('-onerror','abort','-importScript',source,output,patched)
new=output.read_bytes()
assert [t for t in h.tags(source.read_bytes()) if t[0]!=82]==[t for t in h.tags(new) if t[0]!=82]
classes=','.join(str(p.relative_to(patched).with_suffix('')).replace('\\','.') for p in patched.rglob('*.as'))
ff('-selectclass',classes,'-export','script',BASE/'verify',output)
assert 'Possible Primogems: 0-' in (BASE/'verify/scripts/Processors/Game/Lobby/ExpDuplicate/TProcessorExpDupItemCom.as').read_text()
assert h.CLIENT.read_bytes()==original
manifest=h.CLIENT.parent/'version.swf';raw=zlib.decompress(manifest.read_bytes());pos=2;parts=[raw[:2]];version=b'2026102311';found=0
for _ in range(struct.unpack_from('<H',raw)[0]):
    n=struct.unpack_from('<H',raw,pos)[0];pos+=2;key=raw[pos:pos+n];pos+=n
    n=struct.unpack_from('<H',raw,pos)[0];pos+=2;value=raw[pos:pos+n];pos+=n
    if key==b'TApplication.swf':value=version;found+=1
    parts.extend([struct.pack('<H',len(key)),key,struct.pack('<H',len(value)),value])
assert found==1 and pos==len(raw)
backup=BASE/'backups';backup.mkdir(exist_ok=True)
for p in [h.CLIENT,manifest]:shutil.copy2(p,backup/p.name)
protected=h.swap(new);target=h.CLIENT.parent.parent/version.decode()/'TApplication.swf';assert not target.exists();target.parent.mkdir(exist_ok=True);target.write_bytes(protected);h.CLIENT.write_bytes(protected);manifest.write_bytes(zlib.compress(b''.join(parts)))
print('PASS: client compiled, assets unchanged, installed version',version.decode(),hashlib.sha256(protected).hexdigest())
