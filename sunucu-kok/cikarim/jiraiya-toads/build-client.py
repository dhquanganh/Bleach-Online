"""Build Jiraiya animation/status patches and correct passive damage/death playback."""
from pathlib import Path
import argparse,hashlib,importlib.util,json,shutil,struct,subprocess,zlib
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('client_helpers',BASE.parent/'naruto-sage/verify-client.py')
helper=importlib.util.module_from_spec(spec);spec.loader.exec_module(helper)
NAME=Path('Processors/Game/Battle/Character/TRole.as')
def remove_vfx_methods(text):
    # FFDec hoists static methods; replace each method independently on rebuild.
    for signature in ['private function UpdateJiraiyaVfx(', 'private function ShowJiraiyaVfx(',
                      'private static function ShakeJiraiyaBattle(']:
        if signature not in text:continue
        start=text.index(signature);body=text.index('{',start);depth=1;end=body+1
        while depth:
            if text[end]=='{':depth+=1
            elif text[end]=='}':depth-=1
            end+=1
        text=text[:start]+text[end:]
    return text

def main():
    parser=argparse.ArgumentParser();parser.add_argument('--ffdec',required=True);parser.add_argument('--install',action='store_true');opts=parser.parse_args()
    canonical=helper.PUBLIC/'2026090619/TApplication.swf';original=canonical.read_bytes();decoded=helper.swap(original)
    source=BASE/'source.swf';source.write_bytes(decoded)
    def ffdec(*args):subprocess.run(['java','-Xmx2g','-jar',opts.ffdec,*map(str,args)],check=True)
    ffdec('-selectclass','Processors.Game.Battle.Character.TRole,Processors.Game.Battle.Character.TActive,Resources.Constants.CONST_CHARACTER,Processors.Game.Lobby.HeroChange.TProcessorHeroChange','-export','script',BASE/'original',source)
    text=(BASE/'original/scripts'/NAME).read_text(encoding='utf-8')
    start=text.index('      public function AddTextEffectByCMD(param1:TTargetInfo) : void')
    body=text.index('      {',start)+len('      {')
    end=text.index('         _loc2_ = 0;',body)
    patch=(BASE/'float-label.as.txt').read_text(encoding='utf-8')
    text=text[:body]+'\n         var _loc2_:int;\n'+patch+text[end:]
    text=text.replace('if(FId == 11120902 && FIsDie)','if((FId == 11120902 || FId == 11120903) && FIsDie)')
    if 'SkillId != 13120911' not in text:
        token='         SkillName = Skill.Name;'
        assert text.count(token)==1
        text=text.replace(token,'''         if(FId == 11120903 && SkillId != 13120911)
         {
            ShowUIEnd();
            return;
         }
'''+token)
    passiveStart=text.index('      public function PassiveSkillPlay(')
    passiveEnd=text.index('      public function RoundSkill(',passiveStart)
    passive=text[passiveStart:passiveEnd]
    if 'CheckDie()' not in passive:
        passive=passive.replace('                  _loc6_.ChangeHP(_loc7_);','''                  _loc6_.ChangeHP(_loc7_);
                  if(_loc7_ > 0) _loc6_.CheckDie();''')
        passive=passive.replace('"+" + int(Math.abs(_loc7_))','(_loc7_ > 0 ? String(_loc7_) : "+" + int(Math.abs(_loc7_)))')
        text=text[:passiveStart]+passive+text[passiveEnd:]
    # Native vector overlays use animation frame markers, never combat callbacks or timers.
    if 'import flash.geom.Point;' not in text:
        text=text.replace('   import flash.events.*;','   import flash.events.*;\n   import flash.geom.Point;')
    if 'private var FJiraiyaVfxStarted:' not in text:
        text=text.replace('      protected var FWaitNextCommand:Boolean;', '''      private var FJiraiyaVfxStarted:Boolean = false;
      private var FJiraiyaVfxHit:Boolean = false;
      private static var FJiraiyaShake:Object = null;
      protected var FWaitNextCommand:Boolean;''')
    if 'this.UpdateJiraiyaVfx();' not in text:
        token='         _loc1_ = FAttackEffect[FSkillId];'
        assert text.count(token)==1
        text=text.replace(token,'         this.UpdateJiraiyaVfx();\n'+token)
        token='         FSkilling = IsSkill(FSkillId);'
        assert text.count(token)==1
        text=text.replace(token,token+'''
         if(FId == 11120903 && (Type == TYPE_ACTIVE_ATTACK || Type == TYPE_ACTIVE_SKILL))
         {
            FJiraiyaVfxStarted = false;
            FJiraiyaVfxHit = false;
         }''')
    text=remove_vfx_methods(text)
    anim=json.loads((BASE/'animation.json').read_text())['clips']
    hits={13120911:6*anim['toad-mouth-barrier']['interpolationSteps'],13120912:anim['toad-confrontation-chant']['hitFrames'][0],
          13120913:anim['giant-gallant-rasengan']['hitFrames'][0],13120914:anim['raging-lions-mane']['hitFrames'][0],
          13120915:2*anim['senjutsu-power']['interpolationSteps'],13120916:4*anim['tale-of-jiraiya-revival']['interpolationSteps']}
    vfx=(BASE/'skill-vfx.as.txt').read_text(encoding='utf-8').replace('__JIRAIYA_VFX_FRAMES__',json.dumps(hits,separators=(',',':')))
    text=text.replace('      override public function UpdateActive()',vfx+'      override public function UpdateActive()')
    target=BASE/'patched'/NAME;target.parent.mkdir(parents=True,exist_ok=True);target.write_text(text,encoding='utf-8')
    activeName=Path('Processors/Game/Battle/Character/TActive.as')
    active=(BASE/'original/scripts'/activeName).read_text(encoding='utf-8')
    token='         this.FCurSequence = this.FTextureSkill.GetAnimationSequenceByIndex(_loc1_);'
    if '13120916' not in active:
        assert active.count(token)==1
        active=active.replace(token,'''         if(this.FId == 11120903 && this.FTextureSkill.Count >= 5)
         {
            _loc1_ = this.FSkillId == 13120912 ? 1 : (this.FSkillId == 13120914 ? 2 : (this.FSkillId == 13120915 ? 3 : (this.FSkillId == 13120916 ? 4 : 0)));
         }
'''+token)
    (BASE/'patched'/activeName).write_text(active,encoding='utf-8')
    changeName=Path('Processors/Game/Lobby/HeroChange/TProcessorHeroChange.as')
    change=(BASE/'original/scripts'/changeName).read_text(encoding='utf-8')
    if '_loc9_.CityID == 0' not in change:
        token='            _loc9_ = _loc6_.GetDatebaseByIndex(_loc1_) as THeroChangeAttr;'
        assert change.count(token)==1
        change=change.replace(token,token+'''
            if(!_loc9_.IsOpen && _loc9_.CityID == 0)
            {
               _loc1_++;
               continue;
            }''')
    target=BASE/'patched'/changeName;target.parent.mkdir(parents=True,exist_ok=True);target.write_text(change,encoding='utf-8')
    output=BASE/'compiled.swf';ffdec('-onerror','abort','-importScript',source,output,BASE/'patched')
    rebuilt=output.read_bytes()
    assert [t for t in helper.tags(decoded) if t[0]!=82]==[t for t in helper.tags(rebuilt) if t[0]!=82]
    ffdec('-selectclass','Processors.Game.Battle.Character.TActive,Processors.Game.Battle.Character.TRole,Logics.HeroNew.TWakeHeroAttributes,Processors.Game.Lobby.HeroChange.TProcessorHeroChange','-export','script',BASE/'verify',output)
    exported=BASE/'verify/scripts'
    role=(exported/NAME).read_text(encoding='utf-8')
    passive=role[role.index('      public function PassiveSkillPlay('):role.index('      public function RoundSkill(')]
    assert 'CheckDie()' in passive and '_loc7_ > 0 ?' in passive
    assert all(token in role for token in ['19000200','ENTER_FRAME','REMOVED_FROM_STAGE','Low Float','High Float','Knockdown','Repulse','Immobile','CHASE','11120902','11120903','19000301'])
    assert all(token in role for token in ['UpdateJiraiyaVfx','ShowJiraiyaVfx','ShakeJiraiyaBattle','jiraiyaSkillVfx','originX','originY'])
    assert all(role.count('function '+name+'(')==1 for name in ['UpdateJiraiyaVfx','ShowJiraiyaVfx','ShakeJiraiyaBattle'])
    assert 'JIRAIYA_CAMERA' not in role and 'JIRAIYA_VFX skill=' not in role
    active=(exported/'Processors/Game/Battle/Character/TActive.as').read_text(encoding='utf-8')
    assert all(v in active for v in ['13120902','13120904','13120912','13120914','13120915','13120916'])
    wake=(exported/'Logics/HeroNew/TWakeHeroAttributes.as').read_text(encoding='utf-8')
    assert all(f'if({v} == null)' in wake for v in ['_loc12_','_loc11_','_loc8_'])
    change=(exported/changeName).read_text(encoding='utf-8');assert '_loc9_.CityID == 0' in change and '!_loc9_.IsOpen' in change
    if opts.install:
        assert canonical.read_bytes()==original
        manifest=helper.PUBLIC/'2026090619/version.swf';raw=zlib.decompress(manifest.read_bytes());pos=2;entries=[]
        for _ in range(struct.unpack_from('<H',raw)[0]):
            n=struct.unpack_from('<H',raw,pos)[0];pos+=2;k=raw[pos:pos+n];pos+=n
            n=struct.unpack_from('<H',raw,pos)[0];pos+=2;v=raw[pos:pos+n];pos+=n;entries.append((k,v))
        assert pos==len(raw) and sum(k==b'TApplication.swf' for k,v in entries)==1
        parts=[raw[:2]];version=b'2026101710'
        for k,v in entries:
            if k==b'TApplication.swf':v=version
            parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
        for f in [canonical,manifest]:
            backup=BASE/'backups/jiraiya-fix'/f.relative_to(helper.ROOT);backup.parent.mkdir(parents=True,exist_ok=True)
            if not backup.exists():shutil.copy2(f,backup)
        dest=helper.PUBLIC/version.decode()/'TApplication.swf';dest.parent.mkdir(exist_ok=True)
        dest.write_bytes(helper.swap(rebuilt));canonical.write_bytes(helper.swap(rebuilt));manifest.write_bytes(zlib.compress(b''.join(parts)))
    print('PASS Jiraiya skill VFX, bounded camera shake, deterministic animations, revival, status labels, prior patches and original SWF art preserved. Installed:',opts.install,'SHA256:',hashlib.sha256(helper.swap(rebuilt)).hexdigest())
if __name__=='__main__':main()
