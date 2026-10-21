"""Compare Flash's PNG decoder with the lossless ARGB path, including alpha."""
from pathlib import Path
import argparse,json,subprocess
B=Path(__file__).resolve().parent
p=argparse.ArgumentParser();p.add_argument('--ffdec',required=True);a=p.parse_args()
m=json.loads((B/'vfx.json').read_text());keys=list(m['atlases'])
urls=[m['atlases'][k]['url'] for k in keys]
s='''package {
import flash.display.*;import flash.events.*;import flash.net.*;import flash.utils.*;import flash.geom.*;import flash.external.ExternalInterface;
public class TApplication extends Sprite {
 private var urls:Array=__URLS__;private var index:int=0;private var old:BitmapData;private var png:Loader;private var raw:URLLoader;
 public function TApplication(){report("PIXEL_START");next();}
 private function report(s:String):void{if(ExternalInterface.available)ExternalInterface.call("vfxProbe",s);}
 private function fail(e:Event):void{report("ERROR "+e);report("DONE pixel comparison; remaining=0");}
 private function next():void {
  if(index==urls.length){report("DONE pixel comparison; remaining=0");return;}
  png=new Loader();png.contentLoaderInfo.addEventListener(Event.COMPLETE,pngReady);png.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,fail);png.load(new URLRequest(urls[index]));
 }
 private function pngReady(e:Event):void {
  old=Bitmap(png.content).bitmapData;raw=new URLLoader();raw.dataFormat=URLLoaderDataFormat.BINARY;raw.addEventListener(Event.COMPLETE,rawReady);raw.addEventListener(IOErrorEvent.IO_ERROR,fail);raw.load(new URLRequest(String(urls[index]).replace(".png",".argb")));
 }
 private function rawReady(e:Event):void {try{
  var data:ByteArray=raw.data as ByteArray;data.uncompress();var w:int=data.readUnsignedInt();var h:int=data.readUnsignedInt();var actual:BitmapData=new BitmapData(w,h,true,0);actual.setPixels(new Rectangle(0,0,w,h),data);data.clear();raw.data=null;
  var diff:Object=old.compare(actual);if(diff!==0){report("ERROR pixel mismatch "+urls[index]+" result="+diff);if(diff is BitmapData)BitmapData(diff).dispose();}else report("CASE pixel-identical "+urls[index]);
  actual.dispose();old.dispose();png.unload();index++;next();}catch(err:Error){report("ERROR "+err);report("DONE failed; remaining=0");}
 }
}
}'''.replace('__URLS__',json.dumps(urls))
dest=B/'pixel-probe-source/TApplication.as';dest.parent.mkdir(exist_ok=True);dest.write_text(s)
subprocess.run(['java','-Xmx1g','-jar',a.ffdec,'-onerror','abort','-importScript',str(B/'source.swf'),str(B/'pixel-probe.swf'),str(dest.parent)],check=True,stdout=subprocess.DEVNULL)
raw=bytearray((B/'pixel-probe.swf').read_bytes());raw[3]=21;(B/'pixel-probe.swf').write_bytes(raw)
print('PASS pixel probe built:',len(urls),'complete PNG/ARGB atlas comparisons')
