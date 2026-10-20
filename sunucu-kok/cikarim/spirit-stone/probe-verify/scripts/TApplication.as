package
{
   import Logics.Inventories.*;
   import flash.display.Sprite;
   import flash.external.ExternalInterface;
   
   [SWF(width="1250", height="650", backgroundColor="#000000", frameRate="30")]
   public class TApplication extends Sprite
   {
      
      public function TApplication()
      {
         super();
         try
         {
            run();
         }
         catch(e:Error)
         {
            ExternalInterface.call("stoneProbe","ERROR " + e.toString() + " " + e.getStackTrace());
         }
      }
      
      private function check(ok:Boolean, label:String) : void
      {
         if(!ok)
         {
            throw new Error(label);
         }
         ExternalInterface.call("stoneProbe","PASS " + label);
      }
      
      private function run() : void
      {
         var w:StoneProbeWorker = new StoneProbeWorker();
         var old:StoneProbeWorker = new StoneProbeWorker();
         old.receive(0,stone(100,3,1),false);
         check(old.FCharacter.Gems.Count == 0,"reproduced old client dropping a new Spirit Stone");
         w.receive(0,stone(100,3,1),true);
         check(w.FCharacter.Gems.Count == 1 && w.FCharacter.Gems.GetInventoryByIdentifier(100).Quantity == 1,"first Spirit Stone appears immediately");
         w.receive(0,stone(100,3,4),true);
         check(w.FCharacter.Gems.Count == 1 && w.FCharacter.Gems.GetInventoryByIdentifier(100).Quantity == 4,"existing stone updates total without duplication");
         w.receive(0,stone(101,3,2),true);
         check(w.FCharacter.Gems.Count == 2,"second stone type appears independently");
         w.receive(0,stone(102,3,0),true);
         check(w.FCharacter.Gems.Count == 2,"zero quantity does not create ghost stone");
         w.receive(0,stone(200,1,1),true);
         w.receive(0,stone(201,5,3),true);
         check(w.FCharacter.Appliances.Count == 1 && w.FCharacter.Materials.Count == 1,"new normal items and materials appear");
         w.receive(1,stone(300,3,1),true);
         check(w.FCharacter.TemporaryInventories.Count == 1 && w.FCharacter.Gems.Count == 2,"temporary bag stays separate");
         ExternalInterface.call("stoneProbe","DONE");
      }
      
      private function stone(id:uint, cat:uint, n:uint) : TAppliance
      {
         var a:TAppliance = new TAppliance(id);
         a.Category = cat;
         a.Quantity = n;
         a.IDTemplate = 14500001;
         return a;
      }
   }
}

