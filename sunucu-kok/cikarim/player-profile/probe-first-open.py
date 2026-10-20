"""Run native request/reset-path regression without constructing uninitialized UI assets."""
from pathlib import Path
import argparse,importlib.util,re,subprocess,json
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('fix',BASE/'fix-first-open.py');fix=importlib.util.module_from_spec(spec);spec.loader.exec_module(fix)
p=argparse.ArgumentParser();p.add_argument('--ffdec',required=True);a=p.parse_args();work=BASE/'first-open'
for baseline in [True,False]:
 folder='original/scripts' if baseline else 'patched'
 request=fix.method((work/folder/fix.INSPECTOR).read_text(),'RequestShowHero')
 request=request.replace('TPacket','Object').replace('SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Inspector_CharInfoReq)','Acquire(0x0181a000)').replace('SNetworkCore.Transceiver.PacketTransmit','Transmit')
 reset=fix.method((work/folder/fix.WINDOW).read_text(),'Reset')
 stop=reset.index('         this.FHeros.Clear();')+len('         this.FHeros.Clear();');reset=reset[:stop]+'\n      }'
 fields=sorted(set(re.findall(r'this\.(F\w+)',reset)))
 reset=reset.replace('this.','FProcessorWindowPlayerAssets.')
 source="""package {
 import flash.display.*;import flash.events.*;import flash.utils.*;import flash.external.ExternalInterface;
 public class TApplication extends MovieClip {
  private var FProcessorWindowPlayerAssets:Object;
  private var FProcessorWindowInventoryInfor:Object;
  private var FHeros:Object;
  private var values:Array=[];
  private var sent:Array=[];
  public function TApplication(){addEventListener(Event.ADDED_TO_STAGE,run);}
  private function report(s:String):void{if(ExternalInterface.available)ExternalInterface.call("probe",s);}
  private function check(ok:Boolean,label:String):void{if(!ok)throw new Error(label);}
  private function Acquire(id:uint):Object{return {ID:id,Data:new ByteArray()};}
  private function Transmit(packet:Object):void{sent.push(packet);}
  private function noop(...args):void{}
  private function run(e:Event):void {
   removeEventListener(Event.ADDED_TO_STAGE,run);
   try {
    FHeros={Clear:function():void{values=[];}};
    FProcessorWindowPlayerAssets={};
    for each(var field:String in __FIELDS__)FProcessorWindowPlayerAssets[field]={Reset:noop,SwithTagManual:noop,gotoAndStop:noop};
    FProcessorWindowPlayerAssets.FHeros=null;FProcessorWindowPlayerAssets.Visible=false;
    FProcessorWindowPlayerAssets.Hide=function():void{Reset();FProcessorWindowPlayerAssets.Visible=false;};
    FProcessorWindowInventoryInfor={Visible:false,initialized:false};
    FProcessorWindowInventoryInfor.Hide=function():void{if(!FProcessorWindowInventoryInfor.initialized)throw new Error("uninitialized item window");FProcessorWindowInventoryInfor.Visible=false;};
    if(__BASELINE__){
     try{RequestShowHero(7,11);report("ERROR baseline unexpectedly succeeded");}
     catch(failure:Error){if(failure.errorID==1009)report("PASS baseline reproduced Flash #1009 before packet transmission");else report("ERROR unexpected baseline "+failure);}
     return;
    }
    FProcessorWindowPlayerAssets.Hide();
    RequestShowHero(7,11);check(sent.length==1,"first click sends packet");
    values.push(11100001);FProcessorWindowPlayerAssets.FHeros=FHeros;FProcessorWindowPlayerAssets.Visible=true;
    RequestShowHero(7,12);check(!FProcessorWindowPlayerAssets.Visible&&values.length==0,"A to B reset");
    FProcessorWindowInventoryInfor.initialized=true;FProcessorWindowInventoryInfor.Visible=true;
    RequestShowHero(7,13);check(!FProcessorWindowInventoryInfor.Visible,"tooltip reset");
    RequestShowHero(7,11);RequestShowHero(7,11);
    var expected:Array=[11,12,13,11,11];check(sent.length==expected.length,"reopen and repeated target");
    for(var i:int=0;i<expected.length;i++){
     var packet:Object=sent[i];check(packet.ID==0x0181a000&&packet.Data.length==8,"packet layout");packet.Data.position=0;
     check(packet.Data.readUnsignedInt()==7&&packet.Data.readUnsignedInt()==expected[i],"exact role ID pair");
    }
    report("PASS native first-open, null reset, A/B switching, tooltip reset, reopen and same target; exact role IDs transmitted");
   }catch(error:Error){report("ERROR "+error+" "+error.getStackTrace());}
  }
 __REQUEST__
 __RESET__
 }
}""".replace('__BASELINE__','true' if baseline else 'false').replace('__FIELDS__',json.dumps(fields)).replace('__REQUEST__',request).replace('__RESET__',reset)
 name='baseline' if baseline else 'fixed';dest=work/'probe'/name/'TApplication.as';dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(source)
 output=work/'probe'/(name+'.swf')
 subprocess.run(['java','-Xmx2g','-jar',a.ffdec,'-onerror','abort','-importScript',str(work/'source.swf'),str(output),str(dest.parent)],check=True)
 raw=bytearray(output.read_bytes());raw[3]=21;output.write_bytes(raw)
 print('PASS native Inspector probe compiled:',name)
