"""Patch current Flash client for Kabuto/Edo animations, resurrection, labels and VFX."""
from pathlib import Path
import argparse,hashlib,importlib.util,json,shutil,struct,subprocess,zlib
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('native_client',BASE.parent/'naruto-sage/verify-client.py');helper=importlib.util.module_from_spec(spec);spec.loader.exec_module(helper)
ROLE=Path('Processors/Game/Battle/Character/TRole.as');ACTIVE=Path('Processors/Game/Battle/Character/TActive.as')
STAGE=Path('Processors/Game/Battle/TBattleStage.as')
VERSION=b'2026101813'

def remove_methods(text):
    for name in ['UpdateKabutoVfx','ShowKabutoVfx','ShowKabutoSummonVfx','KabutoVfxManifest','PreloadKabutoVfx','LoadKabutoVfxAtlas','PlayKabutoVfxAsset','PlayKabutoNativeEffect','RestoreKabutoAfterRevival','PlayKabutoDeath']:
        signature='private function '+name+'('
        if signature not in text:signature='private static function '+name+'('
        if signature not in text:continue
        start=text.index(signature);p=text.index('{',start)+1;depth=1
        while depth:
            if text[p]=='{':depth+=1
            elif text[p]=='}':depth-=1
            p+=1
        text=text[:start]+text[p:]
    return text

def main():
    parser=argparse.ArgumentParser();parser.add_argument('--ffdec',required=True);parser.add_argument('--install',action='store_true');args=parser.parse_args()
    canonical=helper.PUBLIC/'2026090619/TApplication.swf';original=canonical.read_bytes();decoded=helper.swap(original)
    source=BASE/'source.swf';source.write_bytes(decoded)
    def ffdec(*a):subprocess.run(['java','-Xmx2g','-jar',args.ffdec,*map(str,a)],check=True)
    ffdec('-selectclass','Processors.Game.Battle.Character.TRole,Processors.Game.Battle.Character.TActive,Processors.Game.Battle.TBattleStage','-export','script',BASE/'original',source)
    text=(BASE/'original/scripts'/ROLE).read_text(encoding='utf-8')
    if 'private var FKabutoDeathStop:' not in text:
        text=text.replace('      private var FKabutoVfxStarted:Boolean','      private var FKabutoDeathStop:Function = null;\n      private var FKabutoVfxStarted:Boolean')
    if 'PlayKabutoDeath(Callback,Time);' not in text:
        token='         else if(Type == TYPE_ACTIVE_DIE)\n         {'
        assert token in text
        text=text.replace(token,token+'''
            if(FId == 11120910)
            {
               PlayKabutoDeath(Callback,Time);
               return;
            }
''')
    if 'kabutoLabel.name = "kabutoStatusVfx";' not in text:
        token='kabutoLabel = new TextField();' if 'kabutoLabel = new TextField();' in text else 'var kabutoLabel:TextField = new TextField();'
        assert token in text
        text=text.replace(token,token+'\n            kabutoLabel.name = "kabutoStatusVfx";')
    start=text.index('      public function ChangeHP(')
    end=text.index('      protected function OnMouseMove(',start)
    change_hp=text[start:end]
    if 'RestoreKabutoAfterRevival();' not in change_hp:
        token='         if(param1 < 0)\n         {'
        assert token in change_hp
        change_hp=change_hp.replace(token,token+'''
            var restoreKabuto:Boolean = FId >= 11120910 && FId <= 11120914 && (CurHealth <= 0 || FIsDie);
            if(restoreKabuto)
            {
               CurHealth -= param1;
               if(CurHealth > 0) RestoreKabutoAfterRevival();
               return;
            }
''')
        text=text[:start]+change_hp+text[end:]
    start=text.index('      public function PassiveSkillPlay(');end=text.index('      public function RoundSkill(',start)
    passive=text[start:end]
    if 'TTargetInfo.CMD_FLOAT' not in passive:
        token='            _loc6_.CheckTextEffect(_loc5_);';assert passive.count(token)==1
        passive=passive.replace(token,'''            if(_loc5_.CMD == TTargetInfo.CMD_FLOAT)
            {
               _loc6_.AddTextEffectByCMD(_loc5_);
               _loc4_++;
               continue;
            }
'''+token)
        text=text[:start]+passive+text[end:]
    if 'function PrepareDormantKabuto(' not in text:
        token='      public function ChangeHP(param1:Number) : void';assert token in text
        text=text.replace(token,'''      public function PrepareDormantKabuto() : void
      {
         if(FId >= 11120910 && FId <= 11120914 && CurHealth <= 0)
         {
            FIsDie = true;
            this.visible = false;
         }
      }

'''+token)
    if 'kabutoMarker' not in text:
        start=text.index('      public function AddTextEffectByCMD(param1:TTargetInfo) : void');body=text.index('      {',start)+len('      {')
        text=text[:body]+'\n'+(BASE/'float-label.as.txt').read_text(encoding='utf-8')+text[body:]
        # A newly-created barrier replaces the previous field's status banner.
        token='               if(marker == 19000301)\n               {'
        assert token in text
        text=text.replace(token,token+'''
                  var oldKabutoBarrier:DisplayObject = parent.getChildByName("kabutoBarrierStatus");
                  if(oldKabutoBarrier != null) parent.removeChild(oldKabutoBarrier);''')
    if 'FId >= 11120910 && FId <= 11120914' not in text:
        token='if((FId == 11120902 || FId == 11120903) && FIsDie)';assert token in text
        text=text.replace(token,'if((FId == 11120902 || FId == 11120903 || FId >= 11120910 && FId <= 11120914) && FIsDie)')
    if 'SkillId != 13120931' not in text:
        token='         SkillName = Skill.Name;';assert text.count(token)==1
        text=text.replace(token,'''         if(FId >= 11120910 && FId <= 11120914 && SkillId != 13120931)
         {
            ShowUIEnd();
            return;
         }
'''+token)
    if 'private var FKabutoVfxStarted:' not in text:
        text=text.replace('      protected var FWaitNextCommand:Boolean;', '''      private var FKabutoVfxStarted:Boolean = false;
      private var FKabutoVfxHit:Boolean = false;
      protected var FWaitNextCommand:Boolean;''')
    if 'this.UpdateKabutoVfx();' not in text:
        token='         this.UpdateJiraiyaVfx();';assert text.count(token)==1
        text=text.replace(token,token+'\n         this.UpdateKabutoVfx();')
        token='         FSkilling = IsSkill(FSkillId);';assert text.count(token)==1
        text=text.replace(token,token+'''
         if(FId >= 11120910 && FId <= 11120914 && (Type == TYPE_ACTIVE_ATTACK || Type == TYPE_ACTIVE_SKILL))
         {
            FKabutoVfxStarted = false;
            FKabutoVfxHit = false;
         }''')
    anim=json.loads((BASE/'animation.json').read_text())['clips']
    moves={13120931:'white-snake-assault',13120932:'bracken-dance',13120933:'white-extreme-attack',13120934:'self-healing',13120935:'white-snake-revival',13120936:'impure-world-reincarnation',13120937:'mu-strike',13120938:'mu-summon',13120939:'deidara-attack',13120940:'dan-attack',13120941:'pakura-attack',13120942:'mu-barrier'}
    hits={sid:anim[name].get('hitFrames',[anim[name]['steps']])[0] for sid,name in moves.items()}
    if 'private static var FKabutoFxCache:' not in text:
        token='      private var FKabutoVfxStarted:Boolean'
        assert token in text
        text=text.replace(token,'      private static var FKabutoFxCache:Object = {};\n      private static var FKabutoFxLoading:Object = {};\n'+token)
    start=text.index('      public function PrepareDormantKabuto(');body=text.index('      {',start)+len('      {')
    if 'PreloadKabutoVfx();' not in text[start:text.index('      public function ChangeHP(',start)]:
        text=text[:body]+'\n         if(FId >= 11120910 && FId <= 11120914) PreloadKabutoVfx();'+text[body:]
    vfx=(BASE/'raster-vfx.as.txt').read_text(encoding='utf-8').replace('__KABUTO_VFX_FRAMES__',json.dumps(hits,separators=(',',':')))
    manifest=json.loads((BASE/'vfx.json').read_text())
    vfx=vfx.replace('__KABUTO_VFX_MANIFEST__',json.dumps(json.dumps(manifest,separators=(',',':'))))
    legacy=(BASE/'skill-vfx.as.txt').read_text(encoding='utf-8')
    vfx+=legacy[legacy.index('      private function ShowKabutoVfx('):].replace('ShowKabutoVfx(','ShowKabutoSummonVfx(')
    vfx+=(BASE/'revival-visual.as.txt').read_text(encoding='utf-8')
    vfx+=(BASE/'death-visual.as.txt').read_text(encoding='utf-8')
    text=remove_methods(text).replace('      override public function UpdateActive()',vfx+'      override public function UpdateActive()')
    target=BASE/'patched'/ROLE;target.parent.mkdir(parents=True,exist_ok=True);target.write_text(text,encoding='utf-8')
    active=(BASE/'original/scripts'/ACTIVE).read_text(encoding='utf-8')
    if 'this.FId == 11120910' not in active:
        token='         this.FCurSequence = this.FTextureSkill.GetAnimationSequenceByIndex(_loc1_);';assert active.count(token)==1
        active=active.replace(token,'''         if(this.FId == 11120910 && this.FTextureSkill.Count >= 5)
         {
            _loc1_ = this.FSkillId == 13120933 ? 1 : (this.FSkillId == 13120934 ? 2 : (this.FSkillId == 13120935 ? 3 : (this.FSkillId == 13120936 ? 4 : 0)));
         }
         if(this.FId == 11120911 && this.FTextureSkill.Count >= 2)
         {
            _loc1_ = this.FSkillId == 13120942 ? 1 : 0;
         }
'''+token)
    (BASE/'patched'/ACTIVE).write_text(active,encoding='utf-8')
    stage=(BASE/'original/scripts'/STAGE).read_text(encoding='utf-8')
    stage=stage.replace('kabutoRasterHost.getChildAt(kabutoRasterIndex).name == "kabutoSkillVfx"','(kabutoRasterHost.getChildAt(kabutoRasterIndex).name == "kabutoSkillVfx" || kabutoRasterHost.getChildAt(kabutoRasterIndex).name == "kabutoStatusVfx")') if 'kabutoStatusVfx' not in stage else stage
    if 'PrepareDormantKabuto' not in stage:
        for group in ['param1','param2']:
            token='if('+group+'.RoleBattleInfos[_loc3_].CurHealth > 0)';assert stage.count(token)==1
            stage=stage.replace(token,'if('+group+'.RoleBattleInfos[_loc3_].CurHealth > 0 || '+group+'.RoleBattleInfos[_loc3_].RoleId >= 11120910 && '+group+'.RoleBattleInfos[_loc3_].RoleId <= 11120914)')
            token='               _loc4_ = TPoolRole.GetRole(this.FBattleFiled,'+group+'.RoleBattleInfos[_loc3_],this,this.SetEffectText);';assert stage.count(token)==1
            stage=stage.replace(token,token+'\n               _loc4_.PrepareDormantKabuto();')
    if 'kabutoResetBarrier' not in stage:
        start=stage.index('      public function Reset() : void');body=stage.index('      {',start)+len('      {')
        stage=stage[:body]+'''
         if(this.FBattleFiled != null)
         {
            var kabutoResetBarrier:DisplayObject = this.FBattleFiled.getChildByName("kabutoBarrierStatus");
            if(kabutoResetBarrier != null) this.FBattleFiled.removeChild(kabutoResetBarrier);
         }
'''+stage[body:]
    if 'kabutoRasterHosts' not in stage:
        start=stage.index('      public function Reset() : void');body=stage.index('      {',start)+len('      {')
        stage=stage[:body]+'''
         var kabutoRasterHosts:Array = [this,this.FBattleFiled];
         for each(var kabutoRasterHost:DisplayObjectContainer in kabutoRasterHosts)
         {
            if(kabutoRasterHost == null) continue;
            for(var kabutoRasterIndex:int=kabutoRasterHost.numChildren-1;kabutoRasterIndex>=0;kabutoRasterIndex--)
            {
               if(kabutoRasterHost.getChildAt(kabutoRasterIndex).name == "kabutoSkillVfx") kabutoRasterHost.removeChildAt(kabutoRasterIndex);
            }
         }
'''+stage[body:]
    target=BASE/'patched'/STAGE;target.parent.mkdir(parents=True,exist_ok=True);target.write_text(stage,encoding='utf-8')
    import runpy
    decoder=runpy.run_path(str(BASE/'patch-decoder.py'))
    decoder_source=decoder['prepare'](args.ffdec,source,BASE/'decoder')
    decoder_target=BASE/'patched'/decoder['CLASS'];decoder_target.parent.mkdir(parents=True,exist_ok=True)
    decoder_target.write_text(decoder_source.read_text(encoding='utf-8'),encoding='utf-8')
    output=BASE/'compiled.swf';ffdec('-onerror','abort','-importScript',source,output,BASE/'patched');rebuilt=output.read_bytes()
    assert [t for t in helper.tags(decoded) if t[0]!=82]==[t for t in helper.tags(rebuilt) if t[0]!=82]
    ffdec('-selectclass','Processors.Game.Battle.Character.TRole,Processors.Game.Battle.Character.TActive,Processors.Game.Battle.TBattleStage,Logics.HeroNew.TWakeHeroAttributes,Processors.Game.Lobby.HeroChange.TProcessorHeroChange,Foundation.Decoder.Pak.TPakDecoder','-export','script',BASE/'verify',output)
    role=(BASE/'verify/scripts'/ROLE).read_text(encoding='utf-8');active=(BASE/'verify/scripts'/ACTIVE).read_text(encoding='utf-8')
    assert all(token in role for token in ['19000401','19000418','LEVEL 2 BLINDNESS','SUPPRESS IMMUNITY','CURSE BINDING','Low Float','13120931','UpdateKabutoVfx','ShakeJiraiyaBattle','TOAD ESOPHAGUS','kabutoSkillVfx','CheckDie()'])
    assert all(token in active for token in ['13120902','13120904','13120912','13120916','13120933','13120935','13120942'])
    for name in ['UpdateKabutoVfx','ShowKabutoVfx','PlayKabutoVfxAsset','PreloadKabutoVfx']:assert role.count('function '+name+'(')==1
    assert all(token in role for token in ['FKabutoFxCache','/public/kabuto-vfx/extracted/','aoyitexie','tinengzhiyu','copyPixels'])
    restore=role[role.index('private function RestoreKabutoAfterRevival('):role.index('      override public function UpdateActive()')]
    assert all(token in restore for token in ['FWaitDie = false','FHasFrozen = false','FBitmap.visible = true','FBitmap.alpha = 1','GetAnimationFrameByIndex(0)','TYPE_ACTIVE_DIE'])
    passive=role[role.index('      public function PassiveSkillPlay('):role.index('      public function RoundSkill(')]
    assert 'TTargetInfo.CMD_FLOAT' in passive and '_loc6_.AddTextEffectByCMD(_loc5_)' in passive
    stage=(BASE/'verify/scripts'/STAGE).read_text(encoding='utf-8')
    assert stage.count('_loc4_.PrepareDormantKabuto();')==2 and 'kabutoResetBarrier' in stage
    wake=(BASE/'verify/scripts/Logics/HeroNew/TWakeHeroAttributes.as').read_text(encoding='utf-8')
    assert all('if('+name+' == null)' in wake for name in ['_loc12_','_loc11_','_loc8_'])
    change=(BASE/'verify/scripts/Processors/Game/Lobby/HeroChange/TProcessorHeroChange.as').read_text(encoding='utf-8');assert '_loc9_.CityID == 0' in change
    decoder_check=(BASE/'verify/scripts'/decoder['CLASS']).read_text(encoding='utf-8')
    assert 'FKabutoSourceRects' in decoder_check and '== 127' in decoder_check
    if args.install:
        assert canonical.read_bytes()==original
        manifest=helper.PUBLIC/'2026090619/version.swf';raw=zlib.decompress(manifest.read_bytes());p=2;entries=[]
        for _ in range(struct.unpack_from('<H',raw)[0]):
            length=struct.unpack_from('<H',raw,p)[0];p+=2;k=raw[p:p+length];p+=length
            length=struct.unpack_from('<H',raw,p)[0];p+=2;v=raw[p:p+length];p+=length;entries.append((k,v))
        assert p==len(raw) and sum(k==b'TApplication.swf' for k,v in entries)==1
        parts=[raw[:2]]
        for k,v in entries:
            if k==b'TApplication.swf':v=VERSION
            parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
        for f in [canonical,manifest]:
            backup=BASE/'backups'/f.relative_to(helper.ROOT);backup.parent.mkdir(parents=True,exist_ok=True)
            if not backup.exists():shutil.copy2(f,backup)
        dest=helper.PUBLIC/VERSION.decode()/'TApplication.swf';dest.parent.mkdir(exist_ok=True)
        dest.write_bytes(helper.swap(rebuilt));canonical.write_bytes(helper.swap(rebuilt));manifest.write_bytes(zlib.compress(b''.join(parts)))
    print('PASS native Kabuto/Edo sequence selection, death/revival/despawn, all status labels, bounded skill VFX; prior patches and SWF art preserved. Installed:',args.install,'SHA256:',hashlib.sha256(helper.swap(rebuilt)).hexdigest())
if __name__=='__main__':main()
