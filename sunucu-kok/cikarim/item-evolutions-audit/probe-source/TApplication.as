package {
 import flash.display.Sprite;import flash.external.ExternalInterface;
 import Processors.Game.Lobby.EquipForge.TProcessorWinShop;
 import Processors.Game.Lobby.EquipForge.TProcessorWinMakeEquip;
 import Processors.Game.Lobby.EquipForge.TProcessorWinUpgradeEquip;
 public class TApplication extends Sprite {public function TApplication(){try{
 if(TProcessorWinShop.WorkExpired(0,1000))throw Error("Idle requested refresh");ExternalInterface.call("vfxProbe","CASE idle timer OK");
 if(TProcessorWinShop.WorkExpired(2000,1000))throw Error("Future job expired");ExternalInterface.call("vfxProbe","CASE future timer OK");
 if(!TProcessorWinShop.WorkExpired(1000,1000))throw Error("Boundary expiry missed");ExternalInterface.call("vfxProbe","CASE exact expiry OK");
 if(!TProcessorWinShop.WorkExpired(1000,3000))throw Error("Offline expiry missed");ExternalInterface.call("vfxProbe","CASE offline expiry OK");
 new ProbeMake().TryEmpty();ExternalInterface.call("vfxProbe","CASE empty forge click OK");
 new ProbeUpgrade().TryEmpty();ExternalInterface.call("vfxProbe","CASE empty evolution click OK");
 ExternalInterface.call("vfxProbe","DONE Item Evolutions native checks");
 }catch(e:Error){ExternalInterface.call("vfxProbe","ERROR "+e);}}}
 class ProbeMake extends TProcessorWinMakeEquip {public function ProbeMake(){super(null);}public function TryEmpty():void{ProcessorForge(null,null);}}
 class ProbeUpgrade extends TProcessorWinUpgradeEquip {public function ProbeUpgrade(){super(null);}public function TryEmpty():void{ProcessorAdvance(null,null);}}
}