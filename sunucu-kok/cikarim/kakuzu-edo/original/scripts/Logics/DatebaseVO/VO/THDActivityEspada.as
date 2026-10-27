package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.Json.TConditionStyleD;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDActivityEspada extends THDActivityBase
   {
      
      protected var FConditions:Vector.<TConditionStyleD>;
      
      protected var FAwards:Vector.<uint>;
      
      protected var FBuyAwards:Vector.<uint>;
      
      protected var FAwardsConditions:Vector.<TConditionStyleD>;
      
      protected var FBuyConditions:Vector.<TConditionStyleD>;
      
      public function THDActivityEspada()
      {
         super();
         this.FAwards = new Vector.<uint>();
         this.FBuyAwards = new Vector.<uint>();
         this.FAwardsConditions = new Vector.<TConditionStyleD>();
         this.FBuyConditions = new Vector.<TConditionStyleD>();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:TConditionStyleD = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_) as Array;
         _loc3_ = int(_loc5_.length);
         this.FConditions = new Vector.<TConditionStyleD>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = new TConditionStyleD(_loc5_[_loc2_]);
            if(_loc6_.Type == CONST_ACTIVITY_MODE.TYPE_Operate_Buy)
            {
               this.FBuyAwards.push(_loc6_.Awards[0]);
               this.FBuyConditions.push(_loc6_);
            }
            else if(_loc6_.Type == CONST_ACTIVITY_MODE.TYPE_Operate_Award)
            {
               this.FAwards.push(_loc6_.Awards[0]);
               this.FAwardsConditions.push(_loc6_);
            }
            this.FConditions[_loc2_] = _loc6_;
            _loc2_++;
         }
      }
      
      public function get Conditions() : Vector.<TConditionStyleD>
      {
         return this.FConditions;
      }
      
      public function get Awards() : Vector.<uint>
      {
         return this.FAwards;
      }
      
      public function get BuyAwards() : Vector.<uint>
      {
         return this.FBuyAwards;
      }
      
      public function get AwardsConditions() : Vector.<TConditionStyleD>
      {
         return this.FAwardsConditions;
      }
      
      public function get BuyConditions() : Vector.<TConditionStyleD>
      {
         return this.FBuyConditions;
      }
   }
}

