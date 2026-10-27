package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.*;
   import Logics.HDJigSaw.TActivityJSAward;
   import Logics.HDJigSaw.TActivityJSBuy;
   import Logics.HDJigSaw.TActivityJSScore;
   import flash.utils.*;
   import ghostcat.util.data.*;
   
   use namespace ResourcesSpace;
   
   public class THDJigSaw extends THDActivityBase
   {
      
      protected var FScore:TActivityJSScore;
      
      protected var FAwardsList:Vector.<TActivityJSAward>;
      
      protected var FBuysList:Vector.<TActivityJSBuy>;
      
      protected var FTitleID:uint;
      
      public function THDJigSaw()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:Object = null;
         var _loc7_:TActivityJSAward = null;
         var _loc8_:TActivityJSBuy = null;
         var _loc9_:TActivityJSScore = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc4_);
         _loc9_ = new TActivityJSScore(_loc6_.index);
         _loc9_.Score = 0;
         this.FScore = _loc9_;
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_);
         _loc3_ = int(_loc5_.length);
         this.FBuysList = new Vector.<TActivityJSBuy>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc8_ = new TActivityJSBuy(_loc5_[_loc2_].index);
            _loc8_.Value = _loc5_[_loc2_].costChip[0].value;
            _loc8_.Award = _loc5_[_loc2_].award[0];
            this.FBuysList[_loc2_] = _loc8_;
            _loc2_++;
         }
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_);
         _loc3_ = int(_loc5_.length);
         this.FAwardsList = new Vector.<TActivityJSAward>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc7_ = new TActivityJSAward(_loc5_[_loc2_].index);
            _loc7_.Award = _loc5_[_loc2_].award[0];
            _loc7_.Value = _loc5_[_loc2_].costChip[0].value;
            this.FAwardsList[_loc2_] = _loc7_;
            _loc2_++;
         }
         this.FTitleID = param1.readUnsignedInt();
      }
      
      public function get Score() : TActivityJSScore
      {
         return this.FScore;
      }
      
      public function set Score(param1:TActivityJSScore) : void
      {
         this.FScore = param1;
      }
      
      public function get AwardsList() : Vector.<TActivityJSAward>
      {
         return this.FAwardsList;
      }
      
      public function set AwardsList(param1:Vector.<TActivityJSAward>) : void
      {
         this.FAwardsList = param1;
      }
      
      public function get BuysList() : Vector.<TActivityJSBuy>
      {
         return this.FBuysList;
      }
      
      public function set BuysList(param1:Vector.<TActivityJSBuy>) : void
      {
         this.FBuysList = param1;
      }
      
      public function get TitleID() : uint
      {
         return this.FTitleID;
      }
   }
}

