from pathlib import Path
import importlib.util,json,re,sys
B=Path(__file__).resolve().parent;s=importlib.util.spec_from_file_location('c',B/'build-client.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m);c=m.c
W=B/'revival-repair' if '--repair' in sys.argv else B
a=json.loads((B/'animation.json').read_text());source=(B.parent/'tsunade-asian/probe-source/TApplication.as').read_text().split(' internal class ProbeRole extends Sprite {')[0]
source=source.replace(' import flash.geom.*;',' import flash.geom.*;\n import flash.system.*;')
def extract(text,name):
 match=re.search(r'[^\n]*function '+name+r'\(',text);start=match.start();return text[start:c.b.method_end(text,start)]
names=['bond1', 'bond2', 'bond3', 'bond4', 'bond5', 'bond6', 'bond7', 'bond8', 'bond9', 'claw', 'tail', 'bomb', 'final', 'harem', 'chase', 'additional', 'recovery', 'restoration', 'entry', 'dead'];ids=[13122301, 13122302, 13122303, 13122304, 13122305, 13122306, 13122307, 13122308, 13122309, 13122310, 13122311, 13122312, 13122313, 13122314, 13122315, 13122316, 13122317, 13122318, 0, 0];bounds=[0]
for _ in range(2):
 for name in names:bounds.append(bounds[-1]+len(a['clips'][name]['assets'])*40+1000)
source=re.sub(r'private var skills:Array=\[[^\]]+\]','private var skills:Array='+json.dumps(ids),source,count=1);source=re.sub(r'private var clipNames:Array=\[[^\]]+\]','private var clipNames:Array='+json.dumps(names),source,count=1);source=re.sub(r'private var metadata:Object=.*?;\n','private var metadata:Object='+json.dumps(a['clips'],separators=(',',':'))+';\n',source,count=1)
boot=extract(source,'boot');start=boot.index('   loadTexture(');end=boot.index('   addEventListener',start)
boot=boot[:start]+'''   loadTexture("00A9B16E",["idle"]);
   loadTexture("A9B16E0B",["claw","tail","bomb"]);
   loadTexture("A9B16E0C",["bond1", "bond2", "bond3", "bond4", "bond5", "bond6", "bond7", "bond8", "bond9", "final", "harem", "chase", "additional", "recovery", "restoration", "entry", "dead"]);
'''+boot[end:];source=source.replace(extract(source,'boot'),boot,1)
source=source.replace(extract(source,'renderRole'),'''  private function renderRole(role:ProbeRole,name:String,index:int):void {
   var clip:Object=clips[name];if(clip==null)return;index=Math.max(0,Math.min(index,clip.images.length-1));role.actor.bitmapData=clip.images[index];role.actor.x=-clip.meta[index].px;role.actor.y=-clip.meta[index].py;role.NarutoFinalStrikePose({Pivot:{X:clip.meta[index].px,Y:clip.meta[index].py}});
  }''',1)
tick='''  private function tick(event:Event):void {
   for each(var decoder:TPakDecoder in decoders)if(decoder.Unstreamizing)decoder.Process();if(loaded<21)return;
   if(readyAt<0){clips["clone-idle"]=clips.idle;clips["clone-standard"]=clips.standard;clips["clone-counter"]=clips.counter;readyAt=getTimer()+4000;ProbeRole.PreloadNarutoFinalNative();}if(getTimer()<readyAt)return;
   var age:int=getTimer()-readyAt;var bounds:Array=__BOUNDS__;var slot:int=0;while(slot<40 && age>=bounds[slot+1])slot++;
   if(slot>=40){left.FSkillId=0;right.FSkillId=0;left.ClearNarutoFinalVfx();right.ClearNarutoFinalVfx();var remaining:int=0;for(var q:int=0;q<battle.numChildren;q++)if(battle.getChildAt(q).name=="madaraNarutoFinalSkillVfx")remaining++;report("DONE Naruto Final Battle native component; remaining="+remaining);removeEventListener(Event.ENTER_FRAME,tick);return;}
   var side:int=slot<20?0:1;var index:int=slot%20;var caster:ProbeRole=side==0?left:right;var victim:ProbeRole=side==0?right:left;
   caster.Camp=side;victim.Camp=1-side;
   caster.FTargets=[caster,victim];caster.FResults=[{CMD:0,ResultInfo:{HurtHp:0}},{CMD:1,ResultInfo:{HurtHp:index==6?-300:10}}];
   if(lastSlot!=slot){left.ClearNarutoFinalVfx();right.ClearNarutoFinalVfx();left.FSkillId=0;right.FSkillId=0;++caster.FCombatVfxSerial;caster.FSkillId=skills[index];caster.FId=(index==6||index>=10)?11121006:11121006;caster.FFrameIndex=0;caster.y=440;victim.y=440;lastSlot=slot;label.text="Naruto Final Battle | "+clipNames[index]+" | camp "+side;report("CASE "+skills[index]+" camp="+side);}
   var frame:int=int((age-bounds[slot])/40);var name:String=clipNames[index];caster.FFrameIndex=frame;
   if(frame<clips[name].images.length){renderRole(caster,name,frame);caster.UpdateNarutoFinalVfx();}else{caster.FSkillId=0;renderRole(caster,"idle",int(age/100)%clips.idle.images.length);}
   renderRole(victim,"idle",int(age/100)%clips.idle.images.length);
   var phases:Array=name=="mystery"?[4,16,32,48,60,72,84,100]:[4,int(clips[name].images.length*.4),int(clips[name].images.length*.7)];
   for each(var phase:int in phases){var key:String="CASE-"+name+"-camp-"+side+"-frame-"+phase;if(frame>=phase&&!captured[key]){captured[key]=true;var started:int=getTimer();saveFrame(key);readyAt+=getTimer()-started;}}
  }'''.replace('__BOUNDS__',json.dumps(bounds));source=source.replace(extract(source,'tick'),tick,1)
role=(W/'patched'/c.b.ROLE).read_text(encoding='utf-8');runtime='\n'.join(c.m.extract(role,name) for name in ['PreloadNarutoFinalNative','LoadNarutoFinalNative','ClearNarutoFinalVfx','UpdateNarutoFinalVfx','NarutoFinalContactOffset','NarutoFinalStrikePose','PlayNarutoFinalNative']).replace(':TRole',':ProbeRole').replace(':TAnimationFrame',':Object').replace('private static function','public static function').replace('private function','public function')
source+=''' internal class ProbeRole extends Sprite {
 public var FId:int=11121006;public var FSkillId:int=0;public var FIndex:int=1;public var FFrameIndex:int=0;public var Camp:int=0;public var Pos:int=1;
 public const TYPE_ACTIVE_ATTACK:int=1;public const TYPE_ACTIVE_SKILL:int=2;
 public static var FNarutoFinalNative:Object={};public var FNarutoFinalVfxStarted:Boolean=false;public var FNarutoFinalLayers:Array=[];public var FCombatVfxSerial:uint=0;
 public var FBattleStage:Sprite;public var FTargets:Array=[];public var FResults:Array=[];public var actor:Bitmap=new Bitmap();public function get FBitmap():Bitmap{return actor;}
 public function ProbeRole(){actor.smoothing=true;addChild(actor);}
'''+runtime+'\n }\n}'
dest=W/'probe-source/TApplication.as';dest.parent.mkdir(exist_ok=True);dest.write_text(source,encoding='utf-8');probe_source=W/'source.swf';c.ff('-onerror','abort','-importScript',probe_source,W/'raster-probe.swf',dest.parent)
raw=bytearray((W/'raster-probe.swf').read_bytes());raw[3]=21;(W/'raster-probe.swf').write_bytes(raw)
js=(B.parent/'naruto-nine-tails/runtime-raster.js').read_text().replace('7486','7516').replace('7487','7517').replace('nine-tails-vfx','naruto-final-vfx').replace('(v3|extracted|aligned-hd|native-v2)','native')
if W!=B:js=js.replace("'../../..'","'../../../..'")
js=js.replace('300000','300000')
(W/'runtime-raster.js').write_text(js);(W/'validation/native').mkdir(parents=True,exist_ok=True)
print('PASS 22 Naruto Final Battle native component casts compiled')
