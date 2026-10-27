package Logics.HDChristmas
{
   import Foundation.Timing.STimingCore;
   import Logics.DatebaseVO.VO.THDChristmasCarnivalConfig;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDChristmas.VO.TCarnivalHeroVO;
   import Logics.HDChristmas.VO.TCarnivalRandomItemVO;
   import Logics.TypeCodeAmount.TTypeCodeAmount;
   
   public class THDChristmasCarnivalData extends TActivityOSBase
   {
      
      public static const RareItem_Count:uint = 6;
      
      public static const RandomItem_Count:uint = 6;
      
      protected const Frame_Type_Zi:uint = 0;
      
      protected const FRame_Type_Jin:uint = 1;
      
      protected var FRandomFrames:Vector.<Vector.<uint>>;
      
      protected var FRareItems:Vector.<TTypeCodeAmount>;
      
      protected var FRandomItems:Vector.<TCarnivalRandomItemVO>;
      
      protected var FDiscountCoin:uint;
      
      protected var FLanguage:THDChristmasCarnivalLanguage;
      
      protected var FHero:TCarnivalHeroVO;
      
      protected var FRemainFreeRefreshTime:Number;
      
      protected var FMsg:Vector.<String>;
      
      protected var FAllRefreshGold:uint;
      
      protected var FConfig:THDChristmasCarnivalConfig;
      
      protected var FFirstInit:Boolean;
      
      public function THDChristmasCarnivalData()
      {
         super();
         this.FRareItems = new Vector.<TTypeCodeAmount>(RareItem_Count);
         this.FRandomItems = new Vector.<TCarnivalRandomItemVO>(RandomItem_Count);
         this.FLanguage = new THDChristmasCarnivalLanguage();
         this.FHero = new TCarnivalHeroVO();
         this.FMsg = new Vector.<String>();
         this.FRandomFrames = new Vector.<Vector.<uint>>();
         this.FRandomFrames.push(new Vector.<uint>());
         this.FRandomFrames.push(new Vector.<uint>());
         this.FFirstInit = true;
      }
      
      protected function GetFrameTypeByConfigType(param1:uint) : uint
      {
         return param1 == 1 ? this.FRame_Type_Jin : this.Frame_Type_Zi;
      }
      
      public function get RareItems() : Vector.<TTypeCodeAmount>
      {
         return this.FRareItems;
      }
      
      public function get RandomItems() : Vector.<TCarnivalRandomItemVO>
      {
         return this.FRandomItems;
      }
      
      public function get DiscountCoin() : uint
      {
         return this.FDiscountCoin;
      }
      
      public function set DiscountCoin(param1:uint) : void
      {
         this.FDiscountCoin = param1;
      }
      
      public function get Language() : THDChristmasCarnivalLanguage
      {
         return this.FLanguage;
      }
      
      public function get Hero() : TCarnivalHeroVO
      {
         return this.FHero;
      }
      
      public function get RemainFreeRefreshTime() : Number
      {
         return this.FRemainFreeRefreshTime;
      }
      
      public function set RemainFreeRefreshTime(param1:Number) : void
      {
         this.FRemainFreeRefreshTime = param1;
      }
      
      public function get Msg() : Vector.<String>
      {
         return this.FMsg;
      }
      
      public function get AllRefreshGold() : uint
      {
         return this.FAllRefreshGold;
      }
      
      public function set AllRefreshGold(param1:uint) : void
      {
         this.FAllRefreshGold = param1;
      }
      
      public function get Config() : THDChristmasCarnivalConfig
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDChristmasCarnivalConfig) : void
      {
         this.FConfig = param1;
         this.FLanguage.FillLanguage(this.FConfig);
         this.FAllRefreshGold = this.FConfig.RefreshItemGold;
      }
      
      public function get FirstInit() : Boolean
      {
         return this.FFirstInit;
      }
      
      public function set FirstInit(param1:Boolean) : void
      {
         this.FFirstInit = param1;
      }
      
      public function UpdateRefreshGoodsTimeStamp(param1:Number, param2:Number) : void
      {
         this.FRemainFreeRefreshTime = Math.max(param1 - (STimingCore.ServerTick - param2),0);
      }
      
      public function UpdateFreeRefreshTime(param1:Number) : void
      {
         this.FRemainFreeRefreshTime -= param1;
         if(this.FRemainFreeRefreshTime < 0)
         {
            this.FRemainFreeRefreshTime = 0;
         }
      }
      
      public function GetNeedDiscountCoinByCount(param1:uint) : uint
      {
         var _loc2_:uint = 0;
         _loc2_ = Math.min(param1,this.Config.RefreshConsume.length - 1);
         return this.Config.RefreshConsume[_loc2_];
      }
      
      public function ResetRandomItemsFrame() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:Vector.<uint> = null;
         var _loc4_:uint = 0;
         _loc2_ = 10;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc1_ < 5)
            {
               _loc3_ = this.FRandomFrames[this.Frame_Type_Zi];
               _loc4_ = _loc1_;
            }
            else
            {
               _loc3_ = this.FRandomFrames[this.FRame_Type_Jin];
               _loc4_ = _loc1_ - 5;
            }
            _loc3_[_loc4_] = _loc1_ + 1;
            _loc1_++;
         }
      }
      
      public function GerRandomItemsFrameByType(param1:int) : uint
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc2_ = this.GetFrameTypeByConfigType(param1);
         var _loc4_:Vector.<uint> = this.FRandomFrames[_loc2_];
         if(_loc4_.length == 0)
         {
            if(param1 == this.Frame_Type_Zi)
            {
               _loc3_ = Math.random() * 4 + 1;
            }
            else
            {
               _loc3_ = Math.random() * 4 + 6;
            }
         }
         else
         {
            _loc2_ = Math.random() * (_loc4_.length - 1);
            _loc3_ = uint(_loc4_.splice(_loc2_,1)[0]);
         }
         return _loc3_;
      }
   }
}

