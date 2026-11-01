from pathlib import Path
import importlib.util,json
B=Path(__file__).resolve().parent;s=importlib.util.spec_from_file_location('b',B/'build-client.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m);c=m.c
fixture=(B/'protocol-fixture.json').read_text()
text='''package {
 import flash.display.Sprite;import flash.external.ExternalInterface;import flash.utils.ByteArray;
 import Logics.DatebaseVO.VO.THDFirstPay;import Logics.DatebaseVO.VO.Json.TActAward;
 import Logics.HDActivityMode.TActivityInitRetData;import Logics.HDActivityRecharge.THDFirstPayData;
 import Logics.Streamization.HDActivity.TUnstreamizerActivity;import Logics.Streamization.HDActivityRecharge.TUnstreamizerActivityRecharge;
 import Processors.Game.Lobby.Activity.HDFirstPay.TProcessorHDFirstPay;
 public class TApplication extends Sprite {
  public function TApplication(){try{
   var fixture:Object=JSON.parse(__FIXTURE__);var config:ProbeConfig=new ProbeConfig(fixture.metadata);
   for each(var test:Object in fixture.cases){var packet:ByteArray=new ByteArray();for(var p:int=0;p<test.packet.length;p+=2)packet.writeByte(parseInt(test.packet.substr(p,2),16));packet.position=4;
    var decoded:TActivityInitRetData=new TUnstreamizerActivity().UnstreamizationPerform_Activity(packet,null);var data:THDFirstPayData=new THDFirstPayData();new TUnstreamizerActivityRecharge().UnstreamizeUpdateFirstPay(decoded,data,config);
    if(data.TotalPay!=test.paid||data.CountForAward()!=6)throw Error("Progress or tier count mismatch");
    for(var i:int=0;i<6;i++){var expected:int=test.claims.indexOf(i)>=0?-1:test.paid>=fixture.metadata[i].key?1:0;if(data.GetAwardByIndex(i).State!=expected)throw Error("Tier status mismatch "+i);}
    if(TProcessorHDFirstPay.AllTopUpAwardsClaimed(data)!=(test.claims.length==6))throw Error("Pack hidden before every tier claimed");
    ExternalInterface.call("vfxProbe","CASE native top-up protocol paid="+test.paid+" claims="+test.claims.length+" OK");
   }
   if(TProcessorHDFirstPay.AllTopUpAwardsClaimed(new THDFirstPayData()))throw Error("Empty award list marked complete");ExternalInterface.call("vfxProbe","DONE native top-up decode and completion checks");
  }catch(e:Error){ExternalInterface.call("vfxProbe","ERROR "+e);}}
 }
 class ProbeConfig extends THDFirstPay {public function ProbeConfig(rows:Array){super();FActAwards=new Vector.<TActAward>();for each(var row:Object in rows)FActAwards.push(new TActAward(row));}}
}'''.replace('__FIXTURE__',json.dumps(fixture))
dest=B/'probe-source/TApplication.as';dest.parent.mkdir(exist_ok=True);dest.write_text(text,encoding='utf-8');c.ff('-onerror','abort','-importScript',B/'compiled.swf',B/'raster-probe.swf',dest.parent);raw=bytearray((B/'raster-probe.swf').read_bytes());raw[3]=21;(B/'raster-probe.swf').write_bytes(raw)
