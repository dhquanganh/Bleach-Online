package {
 import flash.display.Sprite;import flash.external.ExternalInterface;
 public class TApplication extends Sprite {
  public function TApplication(){try{var ledger:ProbeLedger=new ProbeLedger();ledger.RememberSoulClaim(12000001,100);ledger.RememberSoulClaim(12000002,200);ledger.RememberSoulClaim(12000001,300);for(var i:int=0;i<100;i++)ledger.RememberSoulClaim(12000002,400+i);if(ledger.FShopID.length!=2||ledger.FShopTime[0]!=300||ledger.FShopTime[1]!=499)throw Error("Claim list duplicated or lost updates");ExternalInterface.call("vfxProbe","CASE native cultivation claim tracking: first, second, repeat and 100 refreshes OK");ExternalInterface.call("vfxProbe","DONE cultivation native regression");}catch(e:Error){ExternalInterface.call("vfxProbe","ERROR "+e);}}
 }
 class ProbeLedger {public var FShopID:Vector.<uint>;public var FShopTime:Vector.<uint>;
       public function RememberSoulClaim(id:uint,time:uint) : void
      {
         if(this.FShopID == null)this.FShopID = new Vector.<uint>();
         if(this.FShopTime == null)this.FShopTime = new Vector.<uint>();
         var claimIndex:int = this.FShopID.indexOf(id);
         if(claimIndex >= 0)
         {
            this.FShopTime[claimIndex] = time;
         }
         else
         {
            this.FShopID.push(id);
            this.FShopTime.push(time);
         }
      }
 }
}