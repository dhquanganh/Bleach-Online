"""Compile an isolated Flash probe from the actual installed Mecha methods."""
from pathlib import Path
import argparse,importlib.util,json,re,subprocess
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('b',BASE/'build-client.py');b=importlib.util.module_from_spec(spec);spec.loader.exec_module(b)
def main():
 p=argparse.ArgumentParser();p.add_argument('--ffdec',required=True);p.add_argument('--idle-only',action='store_true');p.add_argument('--recovery-only',action='store_true');p.add_argument('--role-source',type=Path);a=p.parse_args()
 anim=json.loads((BASE/'animation.json').read_text());production=(a.role_source or BASE/'patched'/b.b.ROLE).read_text(encoding='utf-8')
 names=['MechaFirstAtlas','PreloadMechaVfx','LoadMechaVfxAtlas','TrimMechaVfxCache','PlayMechaVfxAsset','MechaVfxManifest','UpdateMechaVfx','ShowMechaVfx','MechaStrikePose','FitMechaPose','MechaBackdrop']
 names += [n for n in ['MechaPinPages','PumpMechaVfxQueue'] if 'function '+n+'(' in production]
 methods='\n'.join(b.extract(production,n) for n in names).replace('TRole','TApplication').replace('frame:TAnimationFrame','frame:Object')
 methods=methods.replace('var manifest:Object = JSON.parse(', 'if(ExternalInterface.available)ExternalInterface.call("vfxProbe","MANIFEST_PARSE");var manifest:Object = JSON.parse(')
 methods=methods.replace('if(frames == null)', 'if(frames == null && ExternalInterface.available)ExternalInterface.call("vfxProbe","MISSING_FRAME "+name+" frame="+frame);\n            if(frames == null)')
 methods=methods.replace('FMechaFxCache[name] = frames;','FMechaFxCache[name] = frames;if(ExternalInterface.available)ExternalInterface.call("vfxProbe","ATLAS "+name);').replace('layer.name = "mechaSkillVfx";','layer.name = "mechaSkillVfx";if(ExternalInterface.available)ExternalInterface.call("vfxProbe","VFX_ASSET "+name);')
 methods=re.sub(r'TBattleHandle\.PlaybackTime(?:\(\))?','getTimer()',methods)
 s=(BASE.parent/'jiraiya-toads/vfx-probe.as.txt').read_text(encoding='utf-8-sig')
 s=s.replace('11120903','11120950').replace('Jiraiya','Mecha')
 s=s.replace('  private static var FMechaShake:Object=null;', '  private static var FMechaFxCache:Object={};\n  private static var FMechaFxLoading:Object={};\n  private var FMechaActiveVfx:Array=[];\n  private var FCombatVfxSerial:uint=0;\n  private var FMechaBeast:Boolean=false;\n  private function get FBitmap():Bitmap{return actor;}')
 s=s.replace('stage.frameRate=30;','stage.frameRate=25;')
 s=s.replace('var actors:Sprite=new Sprite();battle.addChild(actors);','var actors:Sprite=new Sprite();battle.addChild(actors);actors.x=35;actors.scaleX=.94;actors.scaleY=.94;')
 skills=list(map(int,anim['moves']));clips=list(anim['moves'].values());bounds=[0]
 if a.recovery_only:skills=[13121110,13121111];clips=['recovery','beast-bomb']
 for name in clips*2:bounds.append(bounds[-1]+len(anim['clips'][name]['assets'])*40+1000)
 s=re.sub(r'private var skills:Array=\[.*?\];','private var skills:Array='+json.dumps(skills)+';',s)
 s=re.sub(r'private var clipNames:Array=\[.*?\];','private var clipNames:Array='+json.dumps(clips)+';',s)
 s=s.replace('__METADATA__',json.dumps(anim['clips'],separators=(',',':')))
 s=s.replace('00A9B107',f'{11120950:08X}').replace('A9B1070B',f'{11120950:X}0B').replace('A9B1070C',f'{11120950:X}0C')
 s=s.replace('["giant-gallant-rasengan"]','["combo","beam"]')
 s=s.replace('["toad-mouth-barrier","toad-confrontation-chant","raging-lions-mane","senjutsu-power","tale-of-jiraiya-revival"]',json.dumps(anim['models']['11120950']['0c']))
 s=s.replace('loadTexture("00A9B136",["idle"]);','loadTexture("A9B1360A",["idle","beast-idle"]);')
 start=s.index('  private function renderRole(');old=s[start:b.b.method_end(s,start)];new=old[:old.index('{')]+"""{
   var clip:Object=clips[name];if(clip==null)return;index=Math.max(0,Math.min(index,clip.images.length-1));
   role.actor.bitmapData=clip.images[index];role.actor.x=-clip.meta[index].px;role.actor.y=-clip.meta[index].py;
   if(role.FSkillId>0){role.MechaStrikePose({Pivot:{X:clip.meta[index].px,Y:clip.meta[index].py}});role.FitMechaPose();}
  }""";s=s.replace(old,new)
 start=s.index('  private function tick(');old=s[start:b.b.method_end(s,start)];new=old[:old.index('{')]+"""{
   for each(var decoder:TPakDecoder in decoders)if(decoder.Unstreamizing)decoder.Process();if(loaded<15)return;
   if(readyAt<0){readyAt=getTimer()+3000;left.PreloadMechaVfx();}if(getTimer()<readyAt)return;
   var age:int=getTimer()-readyAt;var bounds:Array=__BOUNDS__;var slot:int=0;while(slot<26 && age>=bounds[slot+1])slot++;
   if(slot>=26){left.FSkillId=0;right.FSkillId=0;var remaining:int=0;for(var q:int=0;q<battle.numChildren;q++)if(battle.getChildAt(q).name=="mechaSkillVfx")remaining++;report("DONE Mecha native component; remaining="+remaining);removeEventListener(Event.ENTER_FRAME,tick);return;}
   var side:int=slot<13?0:1;var index:int=slot%13;var caster:TApplication=side==0?left:right;var victim:TApplication=side==0?right:left;
   if(lastSlot!=slot){left.FSkillId=0;right.FSkillId=0;++caster.FCombatVfxSerial;caster.FSkillId=skills[index];if(caster.FSkillId==13121109)caster.FMechaBeast=true;caster.FFrameIndex=0;caster.FMechaVfxStarted=false;caster.Pos=1+(index%3)*5;caster.y=340+(index%3)*90;victim.y=390+(index%2)*100;lastSlot=slot;label.text="Mecha-Naruto | "+clipNames[index]+" | camp "+side;report("CASE "+skills[index]+" camp="+side);}
   var frame:int=int((age-bounds[slot])/40);var name:String=clipNames[index];caster.FFrameIndex=frame;
   if(frame<clips[name].images.length){renderRole(caster,name,frame);caster.UpdateMechaVfx();}else{caster.FSkillId=0;renderRole(caster,caster.FMechaBeast?"beast-idle":"idle",int(age/100)%clips.idle.images.length);}
   renderRole(victim,victim.FMechaBeast?"beast-idle":"idle",int(age/100)%clips.idle.images.length);
   var hit:int=metadata[name].hitFrames!=null?int(metadata[name].hitFrames[0]):12;
   var phases:Array=[Math.max(3,hit-4),hit+4,Math.max(hit+8,int(clips[name].images.length*.72))];
   for each(var phase:int in phases){var key:String="CASE-"+skills[index]+"-camp-"+side+"-frame-"+phase;if(frame>=phase&&!captured[key]){captured[key]=true;var started:int=getTimer();saveFrame(key);readyAt+=getTimer()-started;}}
  }""";s=s.replace(old,new.replace('__BOUNDS__',json.dumps(bounds)))
 fields=s[s.index('  private var FId:'):s.index('  private var clips:')].replace('private var','public var').replace('private const','public const').replace('private static var','public static var').replace('private function get','public function get')
 s=s.replace('left=new TApplication(false);right=new TApplication(false);','left=new ProbeRole();right=new ProbeRole();')
 for word in ['left','right','role','caster','victim']:s=s.replace(word+':TApplication',word+':ProbeRole')
 s=s.replace('left.PreloadMechaVfx();','ProbeRole.PreloadMechaVfx();')
 methods=methods.replace('TApplication','ProbeRole').replace('private function','public function').replace('private static function','public static function')
 s=s.replace('__METHODS__','').rstrip();s=s[:-1]+'\n internal class ProbeRole extends Sprite {\n'+fields+'\n public function ProbeRole(){actor.smoothing=true;addChild(actor); }\n'+methods+'\n}\n}\n'

 if a.idle_only:
  s=s.replace('loadTexture("A9B1360A",["idle","beast-idle"]);','loadTexture("A9B1360A",["idle","beast-idle"]);loadTexture("A9B1360D",["hit","beast-hit"]);loadTexture("A9B1360F",["run","beast-run"]);')
  start=s.index('  private function tick(');end=b.b.method_end(s,start)
  s=s[:start]+'''  private function tick(event:Event):void {
   for each(var decoder:TPakDecoder in decoders)if(decoder.Unstreamizing)decoder.Process();if(loaded<19)return;
   if(readyAt<0)readyAt=getTimer()+1000;if(getTimer()<readyAt)return;
   var age:int=getTimer()-readyAt;var names:Array=["idle","beast-idle","beast-run","beast-hit","recovery"];var slot:int=int(age/4000);
   if(slot>=names.length){report("DONE Mecha idle native; remaining=0");removeEventListener(Event.ENTER_FRAME,tick);return;}
   var name:String=String(names[slot]);left.FSkillId=0;right.FSkillId=0;left.FMechaBeast=slot>0;right.FMechaBeast=slot>0;
   if(lastSlot!=slot){lastSlot=slot;label.text="Mecha-Naruto native size | "+name+" | both camps";report("CASE "+name+" both camps");}
   var frame:int=int(age/40)%clips[name].images.length;renderRole(left,name,frame);renderRole(right,name,frame);
   var key:String="IDLE-"+name;if(age%4000>=1000 && !captured[key]){captured[key]=true;var started:int=getTimer();saveFrame(key);readyAt+=getTimer()-started;}
  }'''+s[end:]
 if a.recovery_only:
  s=s.replace('slot<26','slot<4').replace('slot>=26','slot>=4').replace('slot<13','slot<2').replace('slot%13','slot%2')
  s=s.replace('left=new ProbeRole();right=new ProbeRole();','left=new ProbeRole();right=new ProbeRole();left.FMechaBeast=true;right.FMechaBeast=true;')
 output=BASE/('idle-probe.swf' if a.idle_only else 'recovery-probe.swf' if a.recovery_only else 'raster-probe.swf')
 dest=BASE/('idle-probe-source/TApplication.as' if a.idle_only else 'recovery-probe-source/TApplication.as' if a.recovery_only else 'probe-source/TApplication.as');dest.parent.mkdir(exist_ok=True);dest.write_text(s)
 subprocess.run(['java','-Xmx2g','-jar',a.ffdec,'-onerror','abort','-importScript',str(BASE/'source.swf'),str(output),str(dest.parent)],check=True)
 raw=bytearray(output.read_bytes());raw[3]=21;output.write_bytes(raw)
 print('PASS Mecha idle probe: 5 poses, both camps, 20 seconds' if a.idle_only else 'PASS Mecha Recovery/Bomb probe: 4 casts, both camps' if a.recovery_only else 'PASS Mecha probe 26 casts both camps '+str(bounds[-1]/1000)+' seconds')
if __name__=='__main__':main()
