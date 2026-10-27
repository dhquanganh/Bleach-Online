package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDLaborDayPet extends THDActivityBase
   {
      
      protected var FFund:Vector.<Object>;
      
      protected var FRechargePer:int;
      
      protected var FConsumePer:int;
      
      protected var FScore:int;
      
      protected var FRechargeIndex:int;
      
      protected var FConsumeIndex:int;
      
      protected var FGift:Object;
      
      protected var FPet:Object;
      
      public function THDLaborDayPet()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FFund = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FRechargePer = param1.readUnsignedInt();
         this.FConsumePer = param1.readUnsignedInt();
         this.FScore = param1.readUnsignedInt();
         this.FRechargeIndex = param1.readUnsignedInt();
         this.FConsumeIndex = param1.readUnsignedInt();
         this.FGift = Json.decode(TUtilityString.FetchUTF(param1));
         this.FPet = Json.decode(TUtilityString.FetchUTF(param1));
      }
      
      public function get Fund() : Vector.<Object>
      {
         return this.FFund;
      }
      
      public function get Score() : int
      {
         return this.FScore;
      }
      
      public function get RechargeIndex() : int
      {
         return this.FRechargeIndex;
      }
      
      public function get ConsumeIndex() : int
      {
         return this.FConsumeIndex;
      }
      
      public function get Gift() : Object
      {
         return this.FGift;
      }
      
      public function get Pet() : Object
      {
         return this.FPet;
      }
      
      public function get RechargePer() : int
      {
         return this.FRechargePer;
      }
      
      public function get ConsumePer() : int
      {
         return this.FConsumePer;
      }
   }
}

