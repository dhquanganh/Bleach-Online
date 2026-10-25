"""Exercise the native fixed-first-pivot profile policy on all 34 idle frames."""
from pathlib import Path
import importlib.util,re
B=Path(__file__).resolve().parent;W=B/'profile-rasengan'
s=importlib.util.spec_from_file_location('m',B/'build-client.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m);c=m.c
template=(B/'probe-source/TApplication.as').read_text()
def extract(name):
 start=re.search(r'[^\n]*function '+name+r'\(',template).start();return template[start:c.b.method_end(template,start)]
helpers='\n'.join(extract(name) for name in ['loadTexture','decodeTexture','saveFrame'])
source='''package {
 import Foundation.Decoder.Pak.TPakDecoder;import flash.display.*;import flash.events.*;import flash.net.*;import flash.utils.*;import flash.geom.*;import flash.external.ExternalInterface;
 public class TApplication extends MovieClip {
  private var clips:Object={};private var decoders:Array=[];private var loaded:int=0;private var ready:int=-1;private var actor:Bitmap=new Bitmap();private var last:int=-1;
  public function TApplication(){if(stage)boot();else addEventListener(Event.ADDED_TO_STAGE,boot);}
  private function report(s:String):void{ExternalInterface.call("vfxProbe",s);}
  private function boot(e:Event=null):void{stage.scaleMode=StageScaleMode.NO_SCALE;stage.align=StageAlign.TOP_LEFT;stage.frameRate=25;graphics.beginFill(0x172027);graphics.drawRect(0,0,1250,650);graphics.endFill();graphics.lineStyle(1,0xFFD363);graphics.drawRect(400,80,450,500);graphics.moveTo(400,430);graphics.lineTo(850,430);actor.smoothing=true;addChild(actor);loadTexture("A9B1620E",["profile"]);addEventListener(Event.ENTER_FRAME,tick);}
  private function tick(event:Event):void{try{
   for each(var decoder:TPakDecoder in decoders)if(decoder.Unstreamizing)decoder.Process();if(loaded<1)return;
   var clip:Object=clips.profile;
   if(ready<0){ready=getTimer();actor.x=625-clip.meta[0].px;actor.y=450-clip.meta[0].py;report("CASE fixed-first-pivot partner idle, 34 frames");}
   var frame:int=int((getTimer()-ready)/80);if(frame>=clip.images.length){report("DONE profile idle; checked="+clip.images.length+" remaining=0");removeEventListener(Event.ENTER_FRAME,tick);return;}
   if(frame==last)return;last=frame;
   if(clip.meta[frame].px!=clip.meta[0].px || clip.meta[frame].py!=clip.meta[0].py)throw new Error("profile pivot drift");
   actor.bitmapData=clip.images[frame];var box:Rectangle=actor.bitmapData.getColorBoundsRect(0xFF000000,0,false);
   if(actor.y+box.bottom>430 || actor.y+box.top<80)throw new Error("idle overlaps stats or header");
   if(frame%8==0 || frame==33)saveFrame("profile-idle-"+frame);
  }catch(e:Error){report("ERROR "+e);removeEventListener(Event.ENTER_FRAME,tick);}}
__HELPERS__
 }
}'''.replace('__HELPERS__',helpers)
dest=W/'probe-source/TApplication.as';dest.parent.mkdir(exist_ok=True);dest.write_text(source,encoding='utf-8');c.ff('-onerror','abort','-importScript',W/'source.swf',W/'raster-probe.swf',dest.parent)
raw=bytearray((W/'raster-probe.swf').read_bytes());raw[3]=21;(W/'raster-probe.swf').write_bytes(raw)
js=(B/'runtime-raster.js').read_text().replace("path.resolve(base,'../../..')","path.resolve(base,'../../../..')").replace('7486','7488').replace('7487','7489');(W/'runtime-raster.js').write_text(js);(W/'validation/native').mkdir(parents=True,exist_ok=True)
print('PASS native partner idle probe compiled')
