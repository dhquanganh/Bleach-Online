from pathlib import Path
import importlib.util,json
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('shared',B.parent/'tsunade-asian/build-client.py');c=importlib.util.module_from_spec(s);s.loader.exec_module(c);c.JAR=str(B.parents[2]/'tools/ffdec/ffdec.jar')
s=importlib.util.spec_from_file_location('f',B.parent/'ninja-fragments/build.py');f=importlib.util.module_from_spec(s);s.loader.exec_module(f)
coin=json.loads((B/'coin.json').read_text());data=f.serialize(2,coin).hex()
source='''package {
 import flash.display.Sprite;import flash.external.ExternalInterface;import flash.utils.ByteArray;
 import Logics.DatebaseVO.VO.TArticle;import Foundation.Resources.Spaces.ResourcesSpace;
 use namespace ResourcesSpace;
 public class TApplication extends Sprite {public function TApplication(){try{
  var hex:String=__DATA__;var b:ByteArray=new ByteArray();b.endian="littleEndian";for(var i:int=0;i<hex.length;i+=2)b.writeByte(parseInt(hex.substr(i,2),16));b.position=0;
  if(b.readUnsignedInt()!=14900002)throw Error("Wrong Fortune Coin identifier");var item:ProbeArticle=new ProbeArticle();item.Read(b);
  if(b.bytesAvailable!=0 || item.Name!="Fortune Coins" || item.Picture!=14900002 || item.SellPrice!=10 || item.ItemFunction!=0 || !item.ValidFlags())throw Error("Fortune Coin native metadata mismatch");
  ExternalInterface.call("vfxProbe","CASE Fortune Coin native Article decode, sale price, usability and icon OK");ExternalInterface.call("vfxProbe","DONE Fortune Coin native protocol");
 }catch(e:Error){ExternalInterface.call("vfxProbe","ERROR "+e);}}}
 class ProbeArticle extends TArticle {public function Read(data:ByteArray):void{ReadDataByStream(data);}public function ValidFlags():Boolean{return !FExpands[0]&&FExpands[1];}}
}'''.replace('__DATA__',json.dumps(data))
(B/'probe-source').mkdir(exist_ok=True);(B/'probe-source/TApplication.as').write_text(source)
(B/'source.swf').write_bytes(c.h.swap((c.h.PUBLIC/'2026090619/TApplication.swf').read_bytes()))
c.ff('-onerror','abort','-importScript',B/'source.swf',B/'raster-probe.swf',B/'probe-source')
raw=bytearray((B/'raster-probe.swf').read_bytes());raw[3]=21;(B/'raster-probe.swf').write_bytes(raw)
js=(B.parent/'guild-audit/runtime-raster.js').read_text(encoding='utf-8-sig').replace('7591','7603')
(B/'runtime-raster.js').write_text(js);(B/'validation/native').mkdir(parents=True,exist_ok=True)
