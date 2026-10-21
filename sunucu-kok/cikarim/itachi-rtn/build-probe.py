"""Native Flash playback using the production Itachi actor textures/VFX methods."""
from pathlib import Path
import argparse,importlib.util,json,re
BASE=Path(__file__).resolve().parent
sp=importlib.util.spec_from_file_location('b',BASE/'build-client.py');b=importlib.util.module_from_spec(sp);sp.loader.exec_module(b)
def main():
 parser=argparse.ArgumentParser();parser.add_argument('--role-source',type=Path);parser.add_argument('--crow-only',action='store_true');args=parser.parse_args()
 anim=json.loads((BASE/'animation.json').read_text());production=(args.role_source or BASE/'patched'/b.b.ROLE).read_text(encoding='utf-8')
 names=['PreloadItachiVfx','ItachiPinPages','PumpItachiVfxQueue','LoadItachiVfxAtlas','TrimItachiVfxCache','ItachiFirstAtlas','PlayItachiVfxAsset','FitItachiPose','ItachiBackdrop','ItachiVfxManifest','UpdateItachiVfx','ShowItachiVfx','PlayItachiEffect']
 has_clone='function ShowItachiCrowClone(' in production
 if has_clone:names+=['ShowItachiCrowClone','ClearItachiCrowClone']
 methods='\n'.join(b.m.extract(production,n) for n in names).replace('TRole','ProbeRole')
 methods=re.sub(r'TBattleHandle\.PlaybackTime(?:\(\))?','getTimer()',methods)
 methods=methods.replace('layer.name = "itachiSkillVfx";','layer.name = "itachiSkillVfx";if(ExternalInterface.available)ExternalInterface.call("vfxProbe","VFX_ASSET "+name);')
 methods=methods.replace('private function','public function').replace('private static function','public static function')
 s=(BASE.parent/'jiraiya-toads/vfx-probe.as.txt').read_text(encoding='utf-8-sig').replace('11120903','11120960').replace('Jiraiya','Itachi')
 s=s.replace('  private static var FItachiShake:Object=null;','  private static var FItachiFxCache:Object={};\n  private static var FItachiFxLoading:Object={};\n  private var FItachiActiveVfx:Array=[];\n  private var FCombatVfxSerial:uint=0;\n  private function get FBitmap():Bitmap{return actor;}')
 s=s.replace('stage.frameRate=30','stage.frameRate=25').replace('__METADATA__',json.dumps(anim['clips'],separators=(',',':')))
 if has_clone:s=s.replace('  private var FCombatVfxSerial:uint=0;', '  private var FCombatVfxSerial:uint=0;\n  private var FItachiCrowClone:Sprite;\n  private var FItachiCrowCloneTick:Function;\n  private var FItachiCrowCloneRemoved:Function;\n  private var FTextureFightIdle:Object;\n  private var FIsDie:Boolean=false;\n  public var CurHealth:Number=1000;')
 skills=list(map(int,anim['moves']));clips=list(anim['moves'].values());bounds=[0]
 if args.crow_only:assert has_clone;skills=[13121207]*3;clips=['crow']*3
 for name in clips*2:bounds.append(bounds[-1]+(6000 if args.crow_only else len(anim['clips'][name]['assets'])*40+1500))
 s=re.sub(r'private var skills:Array=\[.*?\];','private var skills:Array='+json.dumps(skills)+';',s)
 s=re.sub(r'private var clipNames:Array=\[.*?\];','private var clipNames:Array='+json.dumps(clips)+';',s)
 s=s.replace('loadTexture("00A9B107",["idle"]);',f'loadTexture("{11120960:08X}",["idle"]);')
 s=s.replace('loadTexture("A9B1070B",["giant-gallant-rasengan"]);',f'loadTexture("{11120960:X}0B",["standard"]);')
 s=s.replace('loadTexture("A9B1070C",["toad-mouth-barrier","toad-confrontation-chant","raging-lions-mane","senjutsu-power","tale-of-jiraiya-revival"]);',f'loadTexture("{11120960:X}0C",'+json.dumps(anim['models']['11120960']['0c'])+');')
 start=s.index('  private function renderRole(');end=b.b.method_end(s,start);s=s[:start]+'''  private function renderRole(role:ProbeRole,name:String,index:int):void {
   var clip:Object=clips[name];if(clip==null)return;index=Math.max(0,Math.min(index,clip.images.length-1));role.actor.bitmapData=clip.images[index];role.actor.x=-clip.meta[index].px;role.actor.y=-clip.meta[index].py;role.FitItachiPose();
  }'''+s[end:]
 start=s.index('  private function tick(');end=b.b.method_end(s,start);s=s[:start]+'''  private function tick(event:Event):void {
   for each(var decoder:TPakDecoder in decoders)if(decoder.Unstreamizing)decoder.Process();if(loaded<8)return;
   if(readyAt<0){readyAt=getTimer()+3000;ProbeRole.PreloadItachiVfx();}if(getTimer()<readyAt)return;
   var age:int=getTimer()-readyAt;var bounds:Array=__BOUNDS__;var slot:int=0;while(slot<14 && age>=bounds[slot+1])slot++;
   if(slot>=14){left.FSkillId=0;right.FSkillId=0;var remaining:int=0;for(var q:int=0;q<battle.numChildren;q++)if(battle.getChildAt(q).name=="itachiSkillVfx")remaining++;report("DONE Itachi native component; remaining="+remaining);removeEventListener(Event.ENTER_FRAME,tick);return;}
   var side:int=slot<7?0:1;var index:int=slot%7;var caster:ProbeRole=side==0?left:right;var victim:ProbeRole=side==0?right:left;
   if(lastSlot!=slot){left.FSkillId=0;right.FSkillId=0;++caster.FCombatVfxSerial;caster.FSkillId=skills[index];caster.FFrameIndex=0;caster.FItachiVfxStarted=false;caster.Pos=1+(index%3)*5;caster.y=340+(index%3)*90;victim.y=390+(index%2)*100;lastSlot=slot;label.text="Itachi Road to Ninja | "+clipNames[index]+" | camp "+side;report("CASE "+skills[index]+" camp="+side);}
   var frame:int=int((age-bounds[slot])/40);var name:String=clipNames[index];caster.FFrameIndex=frame;
   if(frame<clips[name].images.length){renderRole(caster,name,frame);caster.UpdateItachiVfx();}else{caster.FSkillId=0;renderRole(caster,"idle",int(age/100)%clips.idle.images.length);}
   renderRole(victim,"idle",int(age/100)%clips.idle.images.length);
   var hit:int=metadata[name].hitFrames!=null?int(metadata[name].hitFrames[0]):12;
   var phases:Array=[Math.max(3,hit-4),hit+4,Math.max(hit+8,int(clips[name].images.length*.72))];
   for each(var phase:int in phases){var key:String="CASE-"+skills[index]+"-camp-"+side+"-frame-"+phase;if(frame>=phase&&!captured[key]){captured[key]=true;var started:int=getTimer();saveFrame(key);readyAt+=getTimer()-started;}}
  }'''.replace('__BOUNDS__',json.dumps(bounds))+s[end:]
 if has_clone:
  s=s.replace('if(readyAt<0){readyAt=', 'if(readyAt<0){left.FTextureFightIdle=cloneIdleTexture();right.FTextureFightIdle=cloneIdleTexture();readyAt=')
  s=s.replace('if(lastSlot!=slot){left.FSkillId=0;', 'if(lastSlot!=slot){left.ClearItachiCrowClone();right.ClearItachiCrowClone();left.FSkillId=0;')
  s=s.replace('if(slot>=14){left.FSkillId=0;', 'if(slot>=14){left.ClearItachiCrowClone();right.ClearItachiCrowClone();left.FSkillId=0;')
  helper='''  private function cloneIdleTexture():Object {
   var idle:Object=clips.idle;
   return {GetAnimationSequenceByIndex:function(index:int):Object{return {GetAnimationFrameByIndex:function(i:int):Object{return {Surface:idle.images[i],Pivot:{X:idle.meta[i].px,Y:idle.meta[i].py}};}};}};
  }
'''
  s=s.replace('  private function renderRole(',helper+'  private function renderRole(',1)
 if args.crow_only:
  s=s.replace('slot<14','slot<6').replace('slot>=14','slot>=6').replace('slot<7?0:1','slot<3?0:1').replace('slot%7','slot%3')
  s=s.replace('caster.Pos=1+(index%3)*5;', 'caster.Pos=1+(index%3)*5;caster.x=side==0?180+index*160:1070-index*160;')
  s=s.replace('var phases:Array=[Math.max(3,hit-4),hit+4,Math.max(hit+8,int(clips[name].images.length*.72))];','var phases:Array=[8,16,42,82];')
  s=s.replace('"-frame-"+phase','"-pos-"+caster.Pos+"-frame-"+phase')
  check='''
   var checked:String="clone-"+slot;
   if(frame>=82 && !captured[checked]){
    captured[checked]=true;var decoy:Sprite=caster.FItachiCrowClone;
    if(decoy==null || decoy.parent==null || decoy.alpha<.8){report("ERROR missing clone "+slot);return;}
    caster.ShowItachiCrowClone();if(caster.FItachiCrowClone!=decoy){report("ERROR stacked clone");return;}
    var rect:Rectangle=decoy.getBounds(stage);if(rect.left<11||rect.right>stage.stageWidth-11||rect.top<11||rect.bottom>stage.stageHeight-11){report("ERROR clone bounds "+rect);return;}
    report("CLONE_OK camp="+side+" pos="+caster.Pos+" persistent after Crow; one clone; native idle; in bounds");
    if(slot==5){caster.CurHealth=0;caster.FItachiCrowCloneTick();if(caster.FItachiCrowClone!=null)report("ERROR death retained clone");caster.CurHealth=1000;caster.ShowItachiCrowClone();var detached:Sprite=caster.FItachiCrowClone;detached.parent.removeChild(detached);if(caster.FItachiCrowClone!=null)report("ERROR removed retained clone");report("CLONE_LIFECYCLE_OK death and removed-from-stage");}
   }
'''
  s=s.replace('   var hit:int=',check+'   var hit:int=',1)
 fields=s[s.index('  private var FId:'):s.index('  private var clips:')].replace('private var','public var').replace('private const','public const').replace('private static var','public static var').replace('private function get','public function get')
 s=s.replace('left=new TApplication(false);right=new TApplication(false);','left=new ProbeRole();right=new ProbeRole();')
 for word in ['left','right','role','caster','victim']:s=s.replace(word+':TApplication',word+':ProbeRole')
 s=s.replace('__METHODS__','').rstrip();s=s[:-1]+'\n internal class ProbeRole extends Sprite {\n'+fields+'\n public function ProbeRole(){actor.smoothing=true;addChild(actor); }\n'+methods+'\n}\n}\n'
 dest=BASE/'probe-source/TApplication.as';dest.parent.mkdir(exist_ok=True);dest.write_text(s,encoding='utf-8')
 b.ff('-onerror','abort','-importScript',BASE/'source.swf',BASE/'raster-probe.swf',dest.parent)
 raw=bytearray((BASE/'raster-probe.swf').read_bytes());raw[3]=21;(BASE/'raster-probe.swf').write_bytes(raw)
 print('PASS native Itachi probe:',len(skills)*2,'casts, both camps,',bounds[-1]/1000,'seconds')
if __name__=='__main__':main()
