package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.*;
   import flash.utils.*;
   import ghostcat.util.data.*;
   
   use namespace ResourcesSpace;
   
   public class THomeSoulAward extends TDatebaseVO
   {
      
      protected var FLevel:int;
      
      protected var FQualitySoul:int;
      
      protected var FImgID:int;
      
      protected var FSoulAward:String;
      
      protected var FSoulAwardVect:Vector.<uint>;
      
      protected var FFixedVect:Vector.<Object>;
      
      protected var FRewardsVect:Vector.<Object>;
      
      public function THomeSoulAward()
      {
         super();
         this.FSoulAwardVect = new Vector.<uint>();
         this.FFixedVect = new Vector.<Object>();
         this.FRewardsVect = new Vector.<Object>();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         this.FLevel = param1.readUnsignedInt();
         this.FQualitySoul = param1.readUnsignedInt();
         this.FImgID = param1.readUnsignedInt();
         this.FSoulAward = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(this.FSoulAward) as Object;
         _loc4_ = _loc5_.fixed as Array;
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = _loc4_[_loc2_];
            this.FFixedVect.push(_loc6_);
            _loc2_++;
         }
         _loc4_ = _loc5_.rewards as Array;
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = _loc4_[_loc2_];
            this.FRewardsVect.push(_loc6_);
            _loc2_++;
         }
      }
      
      public function get Level() : int
      {
         return this.FLevel;
      }
      
      public function get QualitySoul() : int
      {
         return this.FQualitySoul;
      }
      
      public function get ImgID() : int
      {
         return this.FImgID;
      }
      
      public function get SoulAwardVect() : Vector.<uint>
      {
         return this.FSoulAwardVect;
      }
      
      public function get SoulAward() : String
      {
         return this.FSoulAward;
      }
      
      public function get FixedVect() : Vector.<Object>
      {
         return this.FFixedVect;
      }
      
      public function get RewardsVect() : Vector.<Object>
      {
         return this.FRewardsVect;
      }
   }
}

