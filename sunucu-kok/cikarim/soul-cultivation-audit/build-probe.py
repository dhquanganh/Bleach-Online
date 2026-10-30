from pathlib import Path
import importlib.util
B=Path(__file__).resolve().parent;s=importlib.util.spec_from_file_location('b',B/'build-client.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m);c=m.c
role=(B/'patched/Processors/Game/Lobby/CollectSoul/TProcessorCollectSoul.as').read_text();helper=c.m.extract(role,'RememberSoulClaim')
source="""package {
 import flash.display.Sprite;import flash.external.ExternalInterface;
 public class TApplication extends Sprite {
  public function TApplication(){try{var ledger:ProbeLedger=new ProbeLedger();ledger.RememberSoulClaim(12000001,100);ledger.RememberSoulClaim(12000002,200);ledger.RememberSoulClaim(12000001,300);for(var i:int=0;i<100;i++)ledger.RememberSoulClaim(12000002,400+i);if(ledger.FShopID.length!=2||ledger.FShopTime[0]!=300||ledger.FShopTime[1]!=499)throw Error("Claim list duplicated or lost updates");ExternalInterface.call("vfxProbe","CASE native cultivation claim tracking: first, second, repeat and 100 refreshes OK");ExternalInterface.call("vfxProbe","DONE cultivation native regression");}catch(e:Error){ExternalInterface.call("vfxProbe","ERROR "+e);}}
 }
 class ProbeLedger {public var FShopID:Vector.<uint>;public var FShopTime:Vector.<uint>;
 __HELPER__
 }
}""".replace('__HELPER__',helper)
dest=B/'probe-source/TApplication.as';dest.parent.mkdir(exist_ok=True);dest.write_text(source);c.ff('-onerror','abort','-importScript',B/'compiled.swf',B/'raster-probe.swf',dest.parent);raw=bytearray((B/'raster-probe.swf').read_bytes());raw[3]=21;(B/'raster-probe.swf').write_bytes(raw)
