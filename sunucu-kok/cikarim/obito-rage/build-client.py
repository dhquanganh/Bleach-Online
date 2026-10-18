"""Patch the current Flash client, preserving all prior character patches."""
from pathlib import Path
import argparse,hashlib,importlib.util,json,shutil,struct,subprocess,zlib
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('client',BASE.parent/'naruto-sage/verify-client.py');helper=importlib.util.module_from_spec(spec);spec.loader.exec_module(helper)
ROLE=Path('Processors/Game/Battle/Character/TRole.as');ACTIVE=Path('Processors/Game/Battle/Character/TActive.as');STAGE=Path('Processors/Game/Battle/TBattleStage.as')
VERSION=b'2026101822'
def main():
    p=argparse.ArgumentParser();p.add_argument('--ffdec',required=True);p.add_argument('--install',action='store_true');args=p.parse_args()
    canonical=helper.PUBLIC/'2026090619/TApplication.swf';original=canonical.read_bytes();decoded=helper.swap(original)
    previous=BASE/'compiled.swf';backup=BASE/'backups'/canonical.relative_to(helper.ROOT)
    if previous.exists() and backup.exists() and original==helper.swap(previous.read_bytes()):decoded=helper.swap(backup.read_bytes())
    source=BASE/'source.swf';source.write_bytes(decoded)
    def ffdec(*a):subprocess.run(['java','-Xmx2g','-jar',args.ffdec,*map(str,a)],check=True)
    ffdec('-selectclass','Processors.Game.Battle.Character.TRole,Processors.Game.Battle.Character.TActive,Processors.Game.Battle.TBattleStage','-export','script',BASE/'original',source)
    text=(BASE/'original/scripts'/ROLE).read_text(encoding='utf-8')
    if 'function UpdateObitoVfx(' in text:raise RuntimeError('Obito client already installed; use the saved original source for rebuild')
    token='      private var FKabutoVfxStarted:Boolean'
    assert token in text
    text=text.replace(token,'      private var FObitoVfxStarted:Boolean = false;\n      private static var FObitoFxCache:Object = {};\n      private static var FObitoFxLoading:Object = {};\n'+token)
    token='         FSkilling = IsSkill(FSkillId);';assert text.count(token)==1
    text=text.replace(token,token+'\n         if(FId == 11120920) FObitoVfxStarted = false;')
    token='         this.UpdateKabutoVfx();';assert text.count(token)==1;text=text.replace(token,token+'\n         this.UpdateObitoVfx();')
    token='      public function PrepareDormantKabuto() : void';start=text.index(token);body=text.index('      {',start)+len('      {')
    text=text[:body]+'\n         if(FId == 11120920) PreloadObitoVfx();'+text[body:]
    token='         SkillName = Skill.Name;';assert text.count(token)==1
    text=text.replace(token,'         if(FId == 11120920 && SkillId != 13120951 && SkillId != 13120952) {ShowUIEnd();return;}\n'+token)
    # Existing cached alpha-atlas player already handles bounded lifetime, mirroring and reset.
    runtime=(BASE.parent/'kabuto-gnw/raster-vfx.as.txt').read_text(encoding='utf-8')
    runtime=runtime[:runtime.index('      private function UpdateKabutoVfx(')].replace('Kabuto','Obito').replace('kabuto','obito')
    manifest=json.loads((BASE/'vfx.json').read_text());layout=json.loads((BASE/'vfx-layout.json').read_text())
    manifest['layout']=layout['effects']
    for name,placement in layout['clips'].items():manifest['clips'][name].update(placement)
    runtime=runtime.replace('__KABUTO_VFX_MANIFEST__',json.dumps(json.dumps(manifest,separators=(',',':'))))
    runtime+=(BASE/'power-vfx.as.txt').read_text(encoding='utf-8')
    animation=json.loads((BASE/'animation.json').read_text())
    hit_times={sid:animation['clips'][name].get('hitFrames',[10])[0]*40 for sid,name in animation['moves'].items()}
    runtime+='''
      private function UpdateObitoVfx() : void
      {
         if(FId != 11120920 || FSkillId < 13120951 || FSkillId > 13120959 || (FIndex != TYPE_ACTIVE_ATTACK && FIndex != TYPE_ACTIVE_SKILL) || FObitoVfxStarted) return;
         FObitoVfxStarted = true;
         ShowObitoVfx(FSkillId);
      }
      private function ShowObitoVfx(skill:int) : void
      {
         var host:DisplayObjectContainer = parent;
         if(host == null || host.stage == null) return;
         var origin:Point = host.globalToLocal(localToGlobal(new Point()));
         var points:Array = [];
         var seen:Object = {};
         if(FTargets != null && FResults != null) for(var n:int=0;n<FTargets.length && n<FResults.length;n++)
         {
            if(FTargets[n] == null || FTargets[n] == this || FResults[n].CMD != TTargetInfo.CMD_ATTACK || FResults[n].ResultInfo.HurtHp < 0) continue;
            var key:String = FTargets[n].Camp+"_"+FTargets[n].Pos;
            if(seen[key]) continue;
            seen[key] = true;
            points.push(host.globalToLocal(FTargets[n].localToGlobal(new Point())));
         }
         var effect:String = skill == 13120951 ? "DT1shenwei" : skill == 13120952 ? "DTaoyi" : (skill == 13120953 || skill == 13120954) ? "DTpugong" : (skill == 13120955 || skill == 13120957) ? "dtpg" : (skill == 13120956 || skill == 13120958) ? "DTzhuida" : "DTbaozou";
         var manifest:Object = ObitoVfxManifest();
         var layers:Array = manifest.effects[effect] as Array;
         if(layers == null) return;
         var locations:Array = (skill == 13120951 || skill == 13120959 || points.length == 0) ? [origin] : points;
         var impactTimes:Object = __OBITO_IMPACT_TIMES__;
         var impactDelay:int = int(impactTimes[skill]);
         PlayObitoPowerFx(skill,origin,0,true,.85);
         for each(var impactPoint:Point in locations)
         {
            PlayObitoPowerFx(skill,impactPoint,impactDelay,false,locations.length > 1 ? .72 : 1);
         }
         var extent:Number = 1;
         for each(var layerName:String in layers)
         {
            var meta:Object = manifest.clips[layerName];
            extent = Math.max(extent,Number(meta.width)/Number(meta.renderScale));
         }
         var limit:Number = Number(manifest.layout[effect].width)*(locations.length > 1 ? .82 : 1);
         var factor:Number = limit/extent;
         for each(var point:Point in locations) for each(var name:String in layers)
         {
            var clip:Object = manifest.clips[name];
            var w:Number = Number(clip.width)/Number(clip.renderScale)*factor;
            var h:Number = w*Number(clip.height)/Number(clip.width);
            // Source origins include Naruto's travel distance. Anchor each visual
            // to this target's body/feet instead of carrying that horizontal offset.
            var anchored:Point = new Point(point.x,point.y+Number(clip.offsetY));
            PlayObitoVfxAsset(name,host,anchored,w,h,0,scaleX<0,false,false);
         }
      }
'''
    runtime=runtime.replace('__OBITO_IMPACT_TIMES__',json.dumps(hit_times,separators=(',',':')))
    text=text.replace('      override public function UpdateActive()',runtime+'      override public function UpdateActive()')
    start=text.index('      public function AddTextEffectByCMD(');body=text.index('      {',start)+len('      {')
    labels='''
         if(param1.CMD == TTargetInfo.CMD_FLOAT && param1.ResultInfo.BuffId >= 19000501 && param1.ResultInfo.BuffId <= 19000506)
         {
            var obitoNames:Array = ["RAGE MODE","KAMUI","KAMUI TAG II","SUPPRESS IMMUNITY","CHAKRA ABSORB","IMMOBILE"];
            var obitoText:TextField = new TextField();
            obitoText.defaultTextFormat = new TextFormat("Arial",14,param1.ResultInfo.BuffId == 19000501 ? 0xFF5555 : 0xB9F47A,true,null,null,null,null,"center");
            obitoText.text = obitoNames[param1.ResultInfo.BuffId-19000501];obitoText.width=230;obitoText.height=28;obitoText.x=-115;obitoText.y=-150;obitoText.mouseEnabled=false;
            obitoText.filters=[new GlowFilter(0,1,4,4,5)];addChild(obitoText);
            TweenUtil.to(obitoText,1100,{y:-185,alpha:0});
            setTimeout(function():void{if(obitoText.parent != null) obitoText.parent.removeChild(obitoText);},1150);
            return;
         }
'''
    # Read the native field names from the existing marker implementation.
    labels=labels.replace('ResultInfo.BuffId','ResultInfo.BuffId')
    text=text[:body]+labels+text[body:]
    active=(BASE/'original/scripts'/ACTIVE).read_text(encoding='utf-8')
    token='      public function IsSkill(param1:int) : Boolean';start=active.index(token);body=active.index('      {',start)+len('      {')
    active=active[:body]+'\n         if(this.FId == 11120920 && param1 == 13120954) return false;'+active[body:]
    token='         this.FCurSequence = this.FTextureSkill.GetAnimationSequenceByIndex(_loc1_);';assert active.count(token)==1
    active=active.replace(token,'''         if(this.FId == 11120920 && this.FTextureSkill.Count >= 5)
         {
            _loc1_ = uint(this.FSkillId == 13120952 ? 1 : (this.FSkillId == 13120955 || this.FSkillId == 13120957) ? 2 : (this.FSkillId == 13120956 || this.FSkillId == 13120958) ? 3 : this.FSkillId == 13120959 ? 4 : 0);
         }
'''+token)
    token='         this.FCurSequence = this.FTextureAttack.GetAnimationSequenceByIndex(_loc1_);';assert active.count(token)==1
    active=active.replace(token,'''         if(this.FId == 11120920 && this.FTextureAttack.Count >= 2) _loc1_ = uint(this.FSkillId == 13120954 ? 1 : 0);
'''+token)
    stage=(BASE/'original/scripts'/STAGE).read_text(encoding='utf-8')
    token='kabutoRasterHost.getChildAt(kabutoRasterIndex).name == "kabutoSkillVfx"';assert token in stage
    stage=stage.replace(token,'('+token+' || kabutoRasterHost.getChildAt(kabutoRasterIndex).name == "obitoSkillVfx")')
    for name,value in [(ROLE,text),(ACTIVE,active),(STAGE,stage)]:
        f=BASE/'patched'/name;f.parent.mkdir(parents=True,exist_ok=True);f.write_text(value,encoding='utf-8')
    output=BASE/'compiled.swf';ffdec('-onerror','abort','-importScript',source,output,BASE/'patched');rebuilt=output.read_bytes()
    assert [t for t in helper.tags(decoded) if t[0]!=82]==[t for t in helper.tags(rebuilt) if t[0]!=82]
    ffdec('-selectclass','Processors.Game.Battle.Character.TRole,Processors.Game.Battle.Character.TActive,Processors.Game.Battle.TBattleStage','-export','script',BASE/'verify',output)
    verified=(BASE/'verify/scripts'/ROLE).read_text(encoding='utf-8')
    assert all(t in verified for t in ['UpdateObitoVfx','SUPPRESS IMMUNITY','19000501','UpdateKabutoVfx','UpdateJiraiyaVfx','copyPixels','obitoSkillVfx'])
    if args.install:
        assert canonical.read_bytes()==original
        manifest=helper.PUBLIC/'2026090619/version.swf';raw=zlib.decompress(manifest.read_bytes());p=2;parts=[raw[:2]]
        for _ in range(struct.unpack_from('<H',raw)[0]):
            n=struct.unpack_from('<H',raw,p)[0];p+=2;k=raw[p:p+n];p+=n;n=struct.unpack_from('<H',raw,p)[0];p+=2;v=raw[p:p+n];p+=n
            if k==b'TApplication.swf':v=VERSION
            parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
        for f in [canonical,manifest]:
            backup=BASE/'backups'/f.relative_to(helper.ROOT);backup.parent.mkdir(parents=True,exist_ok=True)
            if not backup.exists():shutil.copy2(f,backup)
        dest=helper.PUBLIC/VERSION.decode()/'TApplication.swf';dest.parent.mkdir(exist_ok=True);dest.write_bytes(helper.swap(rebuilt));canonical.write_bytes(helper.swap(rebuilt));manifest.write_bytes(zlib.compress(b''.join(parts)))
    print('PASS Obito client, preserved prior patches; installed',args.install,'sha256',hashlib.sha256(rebuilt).hexdigest())
if __name__=='__main__':main()
