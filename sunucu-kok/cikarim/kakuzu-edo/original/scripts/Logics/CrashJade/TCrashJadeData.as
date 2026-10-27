package Logics.CrashJade
{
   import Logics.Inventories.TInventory;
   
   public class TCrashJadeData
   {
      
      protected var FMakeJadeFlag:uint;
      
      protected var FMakeJadeTime:int;
      
      protected var FBuyTime:uint;
      
      protected var FChipNum:uint;
      
      protected var FExperiencePelletNum:int;
      
      protected var FCurrentSlotNum:int;
      
      protected var FMaxSlotNum:int;
      
      protected var FCrashJadePellet:TInventory;
      
      protected var FHightLevelMakeJadeTime:uint;
      
      protected var FIDHigh:Vector.<uint>;
      
      protected var FIDLow:Vector.<uint>;
      
      protected var FBtnPosition:Vector.<int>;
      
      protected var FHeroID:Vector.<uint>;
      
      protected var FIfGetChip:Boolean;
      
      protected var FIfGetShopCoin:Boolean;
      
      protected var FShopCoinCount:uint;
      
      protected var FShopItems:Vector.<TCrashJadeShopItemVO>;
      
      protected var FShopInited:Boolean;
      
      protected var FInited:Boolean;
      
      protected var FBackPackInited:Boolean;
      
      public function TCrashJadeData()
      {
         super();
         this.FIDHigh = new Vector.<uint>();
         this.FIDLow = new Vector.<uint>();
         this.FBtnPosition = new Vector.<int>();
         this.FHeroID = new Vector.<uint>();
         this.FShopItems = new Vector.<TCrashJadeShopItemVO>();
         this.FShopInited = false;
      }
      
      public function get MakeJadeFlag() : uint
      {
         return this.FMakeJadeFlag;
      }
      
      public function set MakeJadeFlag(param1:uint) : void
      {
         this.FMakeJadeFlag = param1;
      }
      
      public function get ChipNum() : uint
      {
         return this.FChipNum;
      }
      
      public function set ChipNum(param1:uint) : void
      {
         this.FChipNum = param1;
      }
      
      public function get ExperiencePelletNum() : int
      {
         return this.FExperiencePelletNum;
      }
      
      public function set ExperiencePelletNum(param1:int) : void
      {
         this.FExperiencePelletNum = param1;
      }
      
      public function get Inited() : Boolean
      {
         return this.FInited;
      }
      
      public function set Inited(param1:Boolean) : void
      {
         this.FInited = param1;
      }
      
      public function get IDHigh() : Vector.<uint>
      {
         return this.FIDHigh;
      }
      
      public function get IDLow() : Vector.<uint>
      {
         return this.FIDLow;
      }
      
      public function get MakeJadeTime() : int
      {
         return this.FMakeJadeTime;
      }
      
      public function set MakeJadeTime(param1:int) : void
      {
         this.FMakeJadeTime = param1;
      }
      
      public function get BuyTime() : uint
      {
         return this.FBuyTime;
      }
      
      public function set BuyTime(param1:uint) : void
      {
         this.FBuyTime = param1;
      }
      
      public function get BtnPosition() : Vector.<int>
      {
         return this.FBtnPosition;
      }
      
      public function get BackPackInited() : Boolean
      {
         return this.FBackPackInited;
      }
      
      public function set BackPackInited(param1:Boolean) : void
      {
         this.FBackPackInited = param1;
      }
      
      public function get HeroID() : Vector.<uint>
      {
         return this.FHeroID;
      }
      
      public function get MaxSlotNum() : int
      {
         return this.FMaxSlotNum;
      }
      
      public function set MaxSlotNum(param1:int) : void
      {
         this.FMaxSlotNum = param1;
      }
      
      public function get CurrentSlotNum() : int
      {
         return this.FCurrentSlotNum;
      }
      
      public function set CurrentSlotNum(param1:int) : void
      {
         this.FCurrentSlotNum = param1;
      }
      
      public function get CrashJadePellet() : TInventory
      {
         return this.FCrashJadePellet;
      }
      
      public function set CrashJadePellet(param1:TInventory) : void
      {
         this.FCrashJadePellet = param1;
      }
      
      public function get IfGetChip() : Boolean
      {
         return this.FIfGetChip;
      }
      
      public function set IfGetChip(param1:Boolean) : void
      {
         this.FIfGetChip = param1;
      }
      
      public function get HightLevelMakeJadeTime() : uint
      {
         return this.FHightLevelMakeJadeTime;
      }
      
      public function set HightLevelMakeJadeTime(param1:uint) : void
      {
         this.FHightLevelMakeJadeTime = param1;
      }
      
      public function get ShopCoinCount() : uint
      {
         return this.FShopCoinCount;
      }
      
      public function set ShopCoinCount(param1:uint) : void
      {
         this.FShopCoinCount = param1;
      }
      
      public function get ShopItems() : Vector.<TCrashJadeShopItemVO>
      {
         return this.FShopItems;
      }
      
      public function get IfGetShopCoin() : Boolean
      {
         return this.FIfGetShopCoin;
      }
      
      public function set IfGetShopCoin(param1:Boolean) : void
      {
         this.FIfGetShopCoin = param1;
      }
      
      public function get ShopInited() : Boolean
      {
         return this.FShopInited;
      }
      
      public function set ShopInited(param1:Boolean) : void
      {
         this.FShopInited = param1;
      }
      
      public function GetItemVOByMallID(param1:uint) : TCrashJadeShopItemVO
      {
         var _loc2_:TCrashJadeShopItemVO = null;
         for each(_loc2_ in this.FShopItems)
         {
            if(_loc2_.Mall.Identifier == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
   }
}

