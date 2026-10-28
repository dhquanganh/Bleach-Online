from pathlib import Path
import importlib.util,json
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('build',B/'build-client.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m);c=m.c
cfg=json.loads((B.parents[1]/'sunucu/buff-notices.json').read_text());names={**cfg['stats'],**cfg['states']};messages={str(cfg['baseId']+i+1):v for i,v in enumerate(names.values())}
runtime=(B/'runtime.as.txt').read_text().replace('__MESSAGES__',json.dumps(json.dumps(messages,separators=(',',':')))).replace('private ','public ')
source='''package {
 import flash.display.*;import flash.events.*;import flash.geom.*;import flash.text.*;import flash.filters.*;import flash.utils.*;import flash.external.ExternalInterface;
 public class TApplication extends Sprite {
  private var roles:Array=[];private var started:int;private var phases:Object={};
  public function TApplication(){if(stage)boot();else addEventListener(Event.ADDED_TO_STAGE,boot);}
  private function report(text:String):void{ExternalInterface.call("vfxProbe",text);}
  private function count():int{var n:int=0;for(var j:int=0;j<numChildren;j++)if(getChildAt(j).name.indexOf("characterBuffNotices_")==0)n++;return n;}
  private function boot(e:Event=null):void{
   graphics.beginFill(0x243744);graphics.drawRect(0,0,1250,650);graphics.endFill();
   for(var i:int=0;i<6;i++){var r:ProbeRole=new ProbeRole();r.Camp=i<3?0:1;r.Pos=i%3+1;r.x=200+(i%3)*400;r.y=i<3?300:600;r.scaleX=i<3?1:-1;addChild(r);roles.push(r);r.ShowBuffNoticeText(20100001);r.ShowBuffNoticeText(20100003);r.ShowBuffNoticeText(20100004);report("CASE buff role="+i);}
   started=getTimer();addEventListener(Event.ENTER_FRAME,tick);
  }
  private function tick(e:Event):void{
   var age:int=getTimer()-started;
   if(age>=1800&&!phases.refresh){phases.refresh=true;roles[0].ShowBuffNoticeText(20100001);}
   if(age>=3000&&!phases.hold){phases.hold=true;if(count()!=6)report("ERROR labels expired before four seconds");else report("HOLD_OK 3000ms");}
   if(age>=4400&&!phases.expire){phases.expire=true;if(count()!=1)report("ERROR original expiry / refresh count="+count());else report("EXPIRY_OK refreshed role remains");}
   if(age>=6200&&!phases.cleanup){phases.cleanup=true;if(count()!=0)report("ERROR labels exceeded four seconds");roles[0].ShowBuffNoticeText(20100001);roles[0].ShowBuffNoticeText(20100001);if(roles[0].FBuffNoticeLabel.text.split("\\n").length!=1)report("ERROR duplicate label");roles[0].ClearBuffNoticeText();roles[1].ShowBuffNoticeText(20100001);removeChild(roles[1]);}
   if(age>=6500){if(count()!=0)report("ERROR reset/removal leaked labels");removeEventListener(Event.ENTER_FRAME,tick);report("DONE generic buff notice duration/refresh/mirror/reset; remaining="+count());}
  }
 }
 internal class ProbeRole extends Sprite {
  public var Camp:int=0;public var Pos:int=1;
  public function ProbeRole(){graphics.beginFill(0x8aafc2);graphics.drawCircle(0,-50,25);graphics.endFill();}
'''+runtime+'\n }\n}'
dest=B/'probe-source/TApplication.as';dest.parent.mkdir(exist_ok=True);dest.write_text(source)
c.ff('-onerror','abort','-importScript',B/'source.swf',B/'raster-probe.swf',dest.parent)
raw=bytearray((B/'raster-probe.swf').read_bytes());raw[3]=21;(B/'raster-probe.swf').write_bytes(raw)
js=(B.parent/'naruto-nine-tails/runtime-raster.js').read_text().replace('7486','7518').replace('7487','7519')
(B/'runtime-raster.js').write_text(js);(B/'validation/native').mkdir(parents=True,exist_ok=True)
print('PASS buff notice timing/refresh/removal probe compiled')
