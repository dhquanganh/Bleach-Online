package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import Logics.DatebaseVO.VO.Json.TRewards;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TGrowRoadTask extends TDatebaseVO
   {
      
      protected var FName:String;
      
      protected var FDescriptionSimple:String;
      
      protected var FTaskTarget:String;
      
      protected var FAccept:int;
      
      protected var FTaskLocked:String;
      
      protected var FNormalReward:TRewards;
      
      protected var FVipNeed:int;
      
      protected var FVipReward:TRewards;
      
      protected var FType:int;
      
      protected var FAllNumber:int;
      
      protected var FIocnID:int;
      
      protected var FIsGoto:int;
      
      protected var FIsPoptip:Boolean;
      
      public function TGrowRoadTask()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         this.FName = TUtilityString.FetchUTF(param1);
         this.FDescriptionSimple = TUtilityString.FetchUTF(param1);
         this.FTaskTarget = TUtilityString.FetchUTF(param1);
         this.FAccept = param1.readUnsignedInt();
         this.FTaskLocked = TUtilityString.FetchUTF(param1);
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FNormalReward = new TRewards(_loc2_);
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FVipNeed = _loc3_[0] as int;
         _loc4_ = _loc2_.indexOf(",");
         _loc2_ = _loc2_.substr(_loc4_ + 1);
         _loc2_ = _loc2_.substring(0,_loc2_.length - 1);
         this.FVipReward = new TRewards(_loc2_);
         this.FType = param1.readInt();
         this.FAllNumber = param1.readInt();
         this.FIocnID = param1.readInt();
         this.FIsGoto = param1.readInt();
         this.FIsPoptip = param1.readInt() == 1;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get DescriptionSimple() : String
      {
         return this.FDescriptionSimple;
      }
      
      public function get TaskTarget() : String
      {
         return this.FTaskTarget;
      }
      
      public function get Accept() : int
      {
         return this.FAccept;
      }
      
      public function get TaskLocked() : String
      {
         return this.FTaskLocked;
      }
      
      public function get NormalReward() : TRewards
      {
         return this.FNormalReward;
      }
      
      public function get VipNeed() : int
      {
         return this.FVipNeed;
      }
      
      public function get VipReward() : TRewards
      {
         return this.FVipReward;
      }
      
      public function get Type() : int
      {
         return this.FType;
      }
      
      public function get AllNumber() : int
      {
         return this.FAllNumber;
      }
      
      public function get IocnID() : int
      {
         return this.FIocnID;
      }
      
      public function get IsPoptip() : Boolean
      {
         return this.FIsPoptip;
      }
      
      public function get IsGoto() : int
      {
         return this.FIsGoto;
      }
   }
}

