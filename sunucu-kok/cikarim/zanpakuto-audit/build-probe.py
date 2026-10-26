from pathlib import Path
import importlib.util,subprocess
b=Path('cikarim/zanpakuto-audit');sp=importlib.util.spec_from_file_location('h','cikarim/naruto-sage/verify-client.py');h=importlib.util.module_from_spec(sp);sp.loader.exec_module(h)
jar='C:/Users/quang/.copilot/session-state/b6dea4ff-70b7-44ac-b9f5-1136aca3d0d5/files/ffdec/app/ffdec.jar'
def ff(*a):subprocess.run(['java','-Xmx2g','-jar',jar,*map(str,a)],stdout=subprocess.DEVNULL,check=True)
(b/'probe-source.swf').write_bytes(h.swap((h.PUBLIC/'2026090619/TApplication.swf').read_bytes()))
p=b/'verify/scripts/Processors/Game/Lobby/KnifeOfKillSoul/TProcessorKnifeOfKillSoul.as';s=p.read_text(encoding='utf-8');s=s.replace('   import ', '   import flash.external.ExternalInterface;\n   import ',1)
needle='         super(param1,param2);';assert needle in s
s=s.replace(needle,needle+'''
         ExternalInterface.addCallback("zanpakutoProbeOpen",function():void { Visible = true; Mount(); });
         ExternalInterface.addCallback("zanpakutoProbeFortify",function():void { var packet:TPacket = SNetworkCore.PacketAcquire(25248005);packet.Data.writeInt(2000209);packet.Data.writeInt(0);packet.Data.writeInt(9);SNetworkCore.Transceiver.PacketTransmit(packet); });
         ExternalInterface.addCallback("zanpakutoProbeTrain",function(kind:int):void { var packet:TPacket = SNetworkCore.PacketAcquire(25248003);packet.Data.writeByte(kind);packet.Data.writeUnsignedInt(1);packet.Data.writeUnsignedInt(2000209);SNetworkCore.Transceiver.PacketTransmit(packet); });
         ExternalInterface.addCallback("zanpakutoProbeFight",function():void { var packet:TPacket = SNetworkCore.PacketAcquire(25231874);packet.Data.writeUnsignedInt(15100001);packet.Data.writeUnsignedInt(15101001);SNetworkCore.Transceiver.PacketTransmit(packet); });
         ExternalInterface.addCallback("zanpakutoProbeState",function():Object {
            var rows:Array = [];
            for(var i:int = 0; i < FKnifeOfkillSoulDatas.Count; i++) {
               var item:Object = FKnifeOfkillSoulDatas.GetByIndex(i);
               if(item.CurrentState == 4) rows.push({id:item.ID,exp:item.CurrentExp,levels:[item.StrengthenAdd[0].Level,item.StrengthenAdd[1].Level,item.StrengthenAdd[2].Level]});
            }
            return {selected:SLogicsCore.Character.KnifeSoul.ChangedID,owned:rows};
         });''',1)
p=b/'probe-patched/Processors/Game/Lobby/KnifeOfKillSoul/TProcessorKnifeOfKillSoul.as';p.parent.mkdir(parents=True,exist_ok=True);p.write_text(s,encoding='utf-8')
ff('-onerror','abort','-importScript',b/'probe-source.swf',b/'probe-compiled.swf',b/'probe-patched')
out=h.PUBLIC/'2060999999';out.mkdir(exist_ok=True);(out/'TApplication.swf').write_bytes(h.swap((b/'probe-compiled.swf').read_bytes()));print('probe ready')
