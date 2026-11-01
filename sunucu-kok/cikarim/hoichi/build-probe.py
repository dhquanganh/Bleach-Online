from pathlib import Path
import importlib.util,json,re
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('c',B/'build-client.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m);c=m.c
source=(B.parent/'tsunade-asian/probe-source/TApplication.as').read_text().split(' internal class ProbeRole extends Sprite {')[0];a=json.loads((B/'animation.json').read_text())
def extract(text,name):
 match=re.search(r'[^\n]*function '+name+r'\(',text);start=match.start();return text[start:c.b.method_end(text,start)]
names=['mystery','standard','pillars','barrage'];ids=[13122901,13122902,13122903,13122904];bounds=[0]
for _ in range(2):
 for name in names:bounds.append(bounds[-1]+len(a['clips'][name]['assets'])*40+500)
source=re.sub(r'private var skills:Array=\[[^\]]+\]','private var skills:Array='+json.dumps(ids),source,count=1);source=re.sub(r'private var clipNames:Array=\[[^\]]+\]','private var clipNames:Array='+json.dumps(names),source,count=1);source=re.sub(r'private var metadata:Object=.*?;\n','private var metadata:Object='+json.dumps(a['clips'],separators=(',',':'))+';\n',source,count=1)
boot=extract(source,'boot');start=boot.index('   loadTexture(');end=boot.index('   addEventListener',start)
boot=boot[:start]+'''   loadTexture("00A9B174",["idle"]);
   loadTexture("A9B1740B",["standard"]);
   loadTexture("A9B1740C",["mystery","pillars","barrage"]);
'''+boot[end:];source=source.replace(extract(source,'boot'),boot,1)
source=source.replace(extract(source,'renderRole'),'''  private function renderRole(role:ProbeRole,name:String,index:int):void {
   var clip:Object=clips[name];if(clip==null)return;index=Math.max(0,Math.min(index,clip.images.length-1));role.actor.bitmapData=clip.images[index];role.actor.x=-clip.meta[index].px;role.actor.y=-clip.meta[index].py;role.HoichiStrikePose({Pivot:{X:clip.meta[index].px,Y:clip.meta[index].py}});
  }''',1)
tick='''  private function tick(event:Event):void {
   for each(var decoder:TPakDecoder in decoders)if(decoder.Unstreamizing)decoder.Process();if(loaded<5)return;
   if(readyAt<0){readyAt=getTimer()+2000;ProbeRole.PreloadHoichiNative();}if(getTimer()<readyAt)return;
   var age:int=getTimer()-readyAt;var bounds:Array=__BOUNDS__;var slot:int=0;while(slot<8 && age>=bounds[slot+1])slot++;
   if(slot>=8){left.FSkillId=0;right.FSkillId=0;left.ClearHoichiVfx();right.ClearHoichiVfx();var remaining:int=0;for(var q:int=0;q<battle.numChildren;q++)if(battle.getChildAt(q).name=="hoichiSkillVfx")remaining++;report("DONE Hoichi native component; remaining="+remaining);removeEventListener(Event.ENTER_FRAME,tick);return;}
   var side:int=slot<4?0:1;var index:int=slot%4;var caster:ProbeRole=side==0?left:right;var victim:ProbeRole=side==0?right:left;caster.Camp=side;victim.Camp=1-side;
   caster.FTargets=index==2?[caster]:[victim];caster.FResults=[{CMD:index==2?0:1,ResultInfo:{HurtHp:10}}];
   if(lastSlot!=slot){left.ClearHoichiVfx();right.ClearHoichiVfx();left.FSkillId=0;right.FSkillId=0;++caster.FCombatVfxSerial;caster.FSkillId=skills[index];caster.FFrameIndex=0;caster.y=440;victim.y=440;lastSlot=slot;label.text="Hoichi | "+clipNames[index]+" | camp "+side;report("CASE "+skills[index]+" camp="+side);}
   var frame:int=int((age-bounds[slot])/40);var name:String=clipNames[index];caster.FFrameIndex=frame;
   if(frame<clips[name].images.length){renderRole(caster,name,frame);caster.UpdateHoichiVfx();}else{caster.FSkillId=0;renderRole(caster,"idle",int(age/100)%clips.idle.images.length);}
   renderRole(victim,"idle",int(age/100)%clips.idle.images.length);
   for each(var phase:int in [4,int(clips[name].images.length*.4),int(clips[name].images.length*.7)]){var key:String="CASE-"+name+"-camp-"+side+"-frame-"+phase;if(frame>=phase&&!captured[key]){captured[key]=true;var started:int=getTimer();saveFrame(key);readyAt+=getTimer()-started;}}
  }'''.replace('__BOUNDS__',json.dumps(bounds));source=source.replace(extract(source,'tick'),tick,1)
runtime=(B/'native.as.txt').read_text().replace('__ENDS__',json.dumps({str(i):a['clips'][name]['returnFrame'] for i,name in a['moves'].items()},separators=(',',':')))
runtime=runtime[runtime.index('      private static function'):].replace(':TRole',':ProbeRole').replace(':TAnimationFrame',':Object').replace('private static function','public static function').replace('private function','public function')
source+=''' internal class ProbeRole extends Sprite {
 public var FId:int=11121012;public var FSkillId:int=0;public var FIndex:int=1;public var FFrameIndex:int=0;public var Camp:int=0;public var Pos:int=1;
 public const TYPE_ACTIVE_ATTACK:int=1;public const TYPE_ACTIVE_SKILL:int=2;
 public static var FHoichiNative:Object={};public var FHoichiStarted:Boolean=false;public var FHoichiLayers:Array=[];public var FCombatVfxSerial:uint=0;
 public var FBattleStage:Sprite;public var FTargets:Array=[];public var FResults:Array=[];public var actor:Bitmap=new Bitmap();public function get FBitmap():Bitmap{return actor;}
 public function ProbeRole(){actor.smoothing=true;addChild(actor);}
'''+runtime+'\n }\n}'
dest=B/'probe-source/TApplication.as';dest.parent.mkdir(exist_ok=True);dest.write_text(source,encoding='utf-8')
c.ff('-onerror','abort','-importScript',B/'source.swf',B/'raster-probe.swf',dest.parent)
raw=bytearray((B/'raster-probe.swf').read_bytes());raw[3]=21;(B/'raster-probe.swf').write_bytes(raw)
js=(B.parent/'naruto-nine-tails/runtime-raster.js').read_text().replace('7486','7607').replace('7487','7608').replace('nine-tails-vfx','hoichi-vfx').replace('(v3|extracted|aligned-hd|native-v2)','native')
(B/'runtime-raster.js').write_text(js);(B/'validation/native').mkdir(parents=True,exist_ok=True);print('PASS 8 original Hoichi component casts compiled')
