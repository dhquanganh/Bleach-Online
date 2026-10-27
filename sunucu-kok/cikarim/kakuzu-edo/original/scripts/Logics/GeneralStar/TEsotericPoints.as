package Logics.GeneralStar
{
   import Foundation.Resources.SResourcesCore;
   import Logics.DatebaseVO.VO.TStarPointDesc;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_GENERAL_STAR;
   
   public class TEsotericPoints
   {
      
      protected static const FLOCATION:uint = 3;
      
      protected var FPofession:uint;
      
      protected var FPoints:Vector.<TEsotericPoint>;
      
      protected var FLocationFormationBonus:Vector.<Vector.<TAdditionRate>>;
      
      protected var FLag:int;
      
      protected var FLocationDescription:Vector.<String>;
      
      public function TEsotericPoints()
      {
         super();
         this.FPoints = new Vector.<TEsotericPoint>();
         this.FLocationFormationBonus = new Vector.<Vector.<TAdditionRate>>(FLOCATION);
         this.FLocationDescription = new Vector.<String>(FLOCATION);
      }
      
      public function get Pofession() : uint
      {
         return this.FPofession;
      }
      
      public function set Pofession(param1:uint) : void
      {
         this.FPofession = param1;
      }
      
      public function FPointsCount() : uint
      {
         return this.FPoints.length;
      }
      
      public function AddEsotericPoint(param1:TEsotericPoint) : void
      {
         this.FPoints.push(param1);
      }
      
      public function GetEsotericPointByIndex(param1:uint) : TEsotericPoint
      {
         return this.FPoints[param1];
      }
      
      public function GetEsotericPointByIdentifier(param1:uint) : TEsotericPoint
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TEsotericPoint = null;
         _loc2_ = int(this.FPoints.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.FPoints[_loc3_];
            if(_loc4_.Identifier == param1)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function GetRatesByIndex(param1:int) : Vector.<TAdditionRate>
      {
         var _loc2_:Vector.<TAdditionRate> = null;
         return this.FLocationFormationBonus[param1];
      }
      
      public function SetFormationBonus(param1:int, param2:Number, param3:int) : void
      {
         var _loc4_:Vector.<TAdditionRate> = null;
         var _loc5_:TAdditionRate = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         this.FLag = 0;
         _loc6_ = int(CONST_GENERAL_STAR.Location[param1]);
         _loc7_ = parseInt((param2 * 100).toFixed(2));
         _loc4_ = this.FLocationFormationBonus[_loc6_];
         _loc9_ = int(_loc4_.length);
         _loc8_ = 0;
         while(_loc8_ < _loc9_)
         {
            _loc5_ = _loc4_[_loc8_];
            if(_loc5_.Key == param3)
            {
               _loc5_.Value += _loc7_;
               this.FLag = 1;
            }
            _loc8_++;
         }
         if(this.FLag == 0)
         {
            _loc5_ = new TAdditionRate();
            _loc4_.push(_loc5_);
            _loc5_.Key = param3;
            _loc5_.Value = _loc7_;
         }
      }
      
      public function Init() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<TAdditionRate> = null;
         var _loc4_:TAdditionRate = null;
         var _loc5_:TStarPointDesc = null;
         var _loc6_:int = 0;
         _loc2_ = int(this.FLocationFormationBonus.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new Vector.<TAdditionRate>();
            this.FLocationFormationBonus[_loc1_] = _loc3_;
            if(_loc1_ == 0)
            {
               _loc4_ = new TAdditionRate();
               _loc4_.Key = 0;
               _loc4_.Value = 40;
               _loc3_.push(_loc4_);
            }
            _loc6_ = 17600000 + (_loc1_ + 2);
            _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_StarPointDesc,_loc6_) as TStarPointDesc;
            this.FLocationDescription[_loc1_] = _loc5_.Desc;
            _loc1_++;
         }
      }
   }
}

