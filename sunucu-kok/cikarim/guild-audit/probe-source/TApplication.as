package {
 import flash.display.Sprite;import flash.external.ExternalInterface;import flash.utils.ByteArray;
 import Logics.Organization.NewFeatures.TNewOrgData;import Logics.Organization.VO.TOrgCopyVO;import Logics.Organization.VO.TPointInfoVO;
 import Logics.Streamization.Organization.TUnstreamizerOrganizationNew;
 public class TApplication extends Sprite {public function TApplication(){try{
 var d:ProbeData=new ProbeData();var u:TUnstreamizerOrganizationNew=new TUnstreamizerOrganizationNew(d);var b:ByteArray=new ByteArray();
 b.writeInt(1);b.writeShort(1);b.writeInt(0);b.writeInt(3);b.writeInt(2);b.position=0;u.SingleEnterRet(b);
 if(b.bytesAvailable!=0||d.CurrentCopy.PointInfoVOs[0].FightCount!=3||d.CurrentCopy.PointInfoVOs[0].ResetCount!=2)throw Error("Solo packet mismatch");ExternalInterface.call("vfxProbe","CASE solo counts OK");
 b=new ByteArray();b.writeInt(0);b.writeShort(0);b.position=0;u.SingleEnterRet(b);
 for each(var p:TPointInfoVO in d.CurrentCopy.PointInfoVOs)if(p.FightCount!=0||p.ResetCount!=0)throw Error("Stale daily quota");ExternalInterface.call("vfxProbe","CASE solo daily reset OK");
 b=new ByteArray();b.writeInt(9);b.writeInt(0);b.writeShort(0);b.position=0;u.GroupEnterRet(b);if(b.bytesAvailable!=0||!d.CurrentCopy.Pass)throw Error("Group completion mismatch");ExternalInterface.call("vfxProbe","CASE group completion OK");
 b=new ByteArray();b.writeShort(1);b.writeUnsignedInt(0);b.writeUnsignedInt(102);b.writeUTF("Player102");b.writeInt(1);b.position=0;u.ApplyListRet(b);if(b.bytesAvailable!=0||d.ApplyListVOs.length!=1)throw Error("Loot applicants mismatch");ExternalInterface.call("vfxProbe","CASE loot applicants OK");
 ExternalInterface.call("vfxProbe","DONE Guild native protocol");
 }catch(e:Error){ExternalInterface.call("vfxProbe","ERROR "+e);}}}
 class ProbeData extends TNewOrgData {public function ProbeData(){super();FCurrentCopy=new TOrgCopyVO();for(var i:int=0;i<9;i++){var p:TPointInfoVO=new TPointInfoVO();p.FightCount=9;p.ResetCount=9;FCurrentCopy.PointInfoVOs.push(p);}}}
}