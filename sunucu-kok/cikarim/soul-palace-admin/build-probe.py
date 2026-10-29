from pathlib import Path
import importlib.util
B=Path(__file__).resolve().parent;s=importlib.util.spec_from_file_location('b',B/'build-client.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m);c=m.c
source="""package {
 import flash.display.*;import flash.events.*;import flash.net.*;import flash.utils.*;import flash.external.ExternalInterface;
 import Logics.SkyTower.*;import Logics.Streamization.SkyTower.TUnstreamizerSkyTower;
 public class TApplication extends Sprite {
  public function TApplication(){var l:URLLoader=new URLLoader();l.dataFormat=URLLoaderDataFormat.BINARY;l.addEventListener(Event.COMPLETE,function(e:Event):void{try{var p:ByteArray=l.data as ByteArray;var d:TSkyTower=new TSkyTower();var decoder:TUnstreamizerSkyTower=new TUnstreamizerSkyTower();decoder.ApplyPalaceCatalog(p,d);if(d.Towers.Count!=14)throw Error("New tower missing");var t:TTower=d.Towers.GetTowerByIdentifier(15900014);if(!t||t.Layers.Count!=2||!t.IsUnlock)throw Error("New floors or unlock missing");if(t.Layers.GetLayerByIndex(0).LayerName!="New test floor"||!t.Layers.GetLayerByIndex(0).IsClear||t.Layers.GetLayerByIndex(1).IsClear)throw Error("Progress lost");p.position=0;decoder.ApplyPalaceCatalog(p,d);if(d.Towers.Count!=14)throw Error("Duplicate catalog");ExternalInterface.call("vfxProbe","CASE dynamic 14 towers, added floors, names, unlock, exact progress and reload OK");ExternalInterface.call("vfxProbe","DONE palace native decoder");}catch(error:Error){ExternalInterface.call("vfxProbe","ERROR "+error);}});l.load(new URLRequest("/catalog.bin"));}
 }
}"""
dest=B/'probe-source/TApplication.as';dest.parent.mkdir(exist_ok=True);dest.write_text(source);c.ff('-onerror','abort','-importScript',B/'compiled.swf',B/'raster-probe.swf',dest.parent);raw=bytearray((B/'raster-probe.swf').read_bytes());raw[3]=21;(B/'raster-probe.swf').write_bytes(raw)
