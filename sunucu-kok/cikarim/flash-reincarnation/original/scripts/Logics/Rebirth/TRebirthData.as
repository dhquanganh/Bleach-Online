package Logics.Rebirth
{
   import Foundation.Common.Integer.UInt64;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Logics.Characters.THero;
   import Logics.DatebaseVO.VO.THeroExp;
   import Logics.Rebirth.VO.TRebirthConfigValueVO;
   import Resources.Constants.CONST_DATEBASEVO;
   
   public class TRebirthData
   {
      
      public const RebirthExpGrowthFactor:Number = 0.2;
      
      protected var FGetBook:Boolean;
      
      protected var FHeroExpBin:TBins;
      
      protected var FConfigValueVO:TRebirthConfigValueVO;
      
      public function TRebirthData()
      {
         super();
         this.FConfigValueVO = new TRebirthConfigValueVO();
      }
      
      public function get GetBook() : Boolean
      {
         return this.FGetBook;
      }
      
      public function set GetBook(param1:Boolean) : void
      {
         this.FGetBook = param1;
      }
      
      public function get ConfigValueVO() : TRebirthConfigValueVO
      {
         return this.FConfigValueVO;
      }
      
      public function CalNeedExpByNumber(param1:Number, param2:uint) : Number
      {
         return param1;
      }
      
      public function CalNeedExpByUInt64(param1:UInt64, param2:uint) : UInt64
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         _loc3_ = param1.ToNumber();
         _loc4_ = this.CalNeedExpByNumber(_loc3_,param2);
         return UInt64.FromNumber(_loc4_);
      }
      
      public function GetAfterLevel(param1:THero) : uint
      {
         var _loc2_:Number = NaN;
         var _loc3_:THeroExp = null;
         var _loc4_:Number = NaN;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         if(param1.RebirthNum == this.ConfigValueVO.MaxRebirthNum)
         {
            return param1.RebirthLevel;
         }
         if(this.FHeroExpBin == null)
         {
            this.FHeroExpBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_HeroExp);
         }
         _loc7_ = Math.max(param1.RebirthLevel,this.FConfigValueVO.RebirthNeedLevel[param1.RebirthNum]);
         _loc3_ = this.FHeroExpBin.GetDatebaseByIdentifier(_loc7_ - 1) as THeroExp;
         if(_loc3_ == null)
         {
            _loc2_ = param1.Experience.ToNumber();
         }
         else
         {
            _loc2_ = param1.Experience.ToNumber() + _loc3_.AllExp.ToNumber();
         }
         _loc4_ = _loc2_ - Number(this.FConfigValueVO.ReduceExp[param1.RebirthNum]);
         _loc6_ = uint(this.FHeroExpBin.Count);
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc3_ = this.FHeroExpBin.GetDatebaseByIndex(_loc5_) as THeroExp;
            if(_loc3_.AllExp.ToNumber() > _loc4_)
            {
               return _loc3_.Identifier;
            }
            _loc5_++;
         }
         return 0;
      }
   }
}

