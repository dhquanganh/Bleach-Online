package Logics.HDActivityEquipmentShop
{
   import Logics.HDActivityOS.TActivityOSBase;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TActivitySingleEquipementShop extends TActivityOSBase
   {
      
      protected static const TYPE_IndexType_Chip:uint = CONST_ACTIVITY_MODE.TYPE_IndexType_Chip;
      
      protected static const TYPE_IndexType_BuyBox:uint = CONST_ACTIVITY_MODE.TYPE_IndexType_BuyBox;
      
      protected static const TYPE_IndexType_FreeDraw:uint = CONST_ACTIVITY_MODE.TYPE_IndexType_FreeDraw;
      
      protected static const TYPE_IndexType_Exchange:uint = CONST_ACTIVITY_MODE.TYPE_IndexType_Exchange;
      
      protected var FChipVect:Vector.<TChip>;
      
      protected var FBuyBoxVect:Vector.<TBuyBox>;
      
      protected var FFreeDrawVect:Vector.<TFreeDraw>;
      
      protected var FExchangeVect:Vector.<TExchange>;
      
      public function TActivitySingleEquipementShop()
      {
         super();
         this.FChipVect = new Vector.<TChip>();
         this.FBuyBoxVect = new Vector.<TBuyBox>();
         this.FFreeDrawVect = new Vector.<TFreeDraw>();
         this.FExchangeVect = new Vector.<TExchange>();
      }
      
      public function get ChipVect() : Vector.<TChip>
      {
         return this.FChipVect;
      }
      
      public function set ChipVect(param1:Vector.<TChip>) : void
      {
         this.FChipVect = param1;
      }
      
      public function get BuyBoxVect() : Vector.<TBuyBox>
      {
         return this.FBuyBoxVect;
      }
      
      public function set BuyBoxVect(param1:Vector.<TBuyBox>) : void
      {
         this.FBuyBoxVect = param1;
      }
      
      public function get FreeDrawVect() : Vector.<TFreeDraw>
      {
         return this.FFreeDrawVect;
      }
      
      public function set FreeDrawVect(param1:Vector.<TFreeDraw>) : void
      {
         this.FFreeDrawVect = param1;
      }
      
      public function get ExchangeVect() : Vector.<TExchange>
      {
         return this.FExchangeVect;
      }
      
      public function set ExchangeVect(param1:Vector.<TExchange>) : void
      {
         this.FExchangeVect = param1;
      }
      
      public function GetChipByUniqueIndex(param1:uint) : TChip
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TChip = null;
         _loc3_ = int(this.FChipVect.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FChipVect[_loc2_];
            if(_loc4_.Index == param1)
            {
               return _loc4_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function GetExchangeListByType(param1:uint) : Vector.<TExchange>
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Vector.<TExchange> = null;
         _loc4_ = new Vector.<TExchange>();
         _loc3_ = int(this.FExchangeVect.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(param1 == this.FExchangeVect[_loc2_].Type)
            {
               _loc4_.push(this.FExchangeVect[_loc2_]);
            }
            _loc2_++;
         }
         return _loc4_;
      }
      
      public function GetExchangeByUniqueIndex(param1:uint) : TExchange
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(this.FExchangeVect.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FExchangeVect[_loc2_].Index == param1)
            {
               return this.FExchangeVect[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function GetBuyBoxListByChipUniqueIndex(param1:uint) : Vector.<TBuyBox>
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Vector.<TBuyBox> = null;
         _loc3_ = int(this.FBuyBoxVect.length);
         _loc4_ = new Vector.<TBuyBox>();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FBuyBoxVect[_loc2_].Chip.Index == param1)
            {
               _loc4_.push(this.FBuyBoxVect[_loc2_]);
            }
            _loc2_++;
         }
         return _loc4_;
      }
      
      public function GetBuyBoxByUniqueIndex(param1:uint) : TBuyBox
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(this.FBuyBoxVect.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(param1 == this.FBuyBoxVect[_loc2_].Index)
            {
               return this.FBuyBoxVect[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function SetStatus(param1:uint, param2:int) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = int(this.FChipVect.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(param1 == this.FChipVect[_loc3_].Index)
            {
               this.FChipVect[_loc3_].SetStatus(param2);
               return TYPE_IndexType_Chip;
            }
            _loc3_++;
         }
         _loc4_ = int(this.FFreeDrawVect.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(param1 == this.FFreeDrawVect[_loc3_].Index)
            {
               this.FFreeDrawVect[_loc3_].SetStatus(param2);
               return TYPE_IndexType_FreeDraw;
            }
            _loc3_++;
         }
         _loc4_ = int(this.FExchangeVect.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(param1 == this.FExchangeVect[_loc3_].Index)
            {
               this.FExchangeVect[_loc3_].SetStatus(param2);
               return TYPE_IndexType_Exchange;
            }
            _loc3_++;
         }
         return -1;
      }
   }
}

