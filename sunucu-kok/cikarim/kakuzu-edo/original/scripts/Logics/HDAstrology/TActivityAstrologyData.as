package Logics.HDAstrology
{
   import Logics.DatebaseVO.VO.THDAstrologyConfig;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDAstrology.vo.TSCStarPicture;
   import Logics.HDAstrology.vo.TSoulExchangeVo;
   import Logics.HDAstrology.vo.TStarCombinesVo;
   import Logics.HDAstrology.vo.TStarVo;
   import Logics.Inventories.TInventories;
   
   public class TActivityAstrologyData extends TActivityOSBase
   {
      
      protected var FActivityConfig:THDAstrologyConfig;
      
      protected var FCurDay:int;
      
      protected var FLoginGiftInventories:Vector.<TInventories>;
      
      protected var FExtractDataVec:Vector.<TSCStarPicture>;
      
      protected var FStarVec:Vector.<TStarVo>;
      
      protected var FStarCombineVec:Vector.<TStarCombinesVo>;
      
      protected var FLoginGiftState:int;
      
      protected var FStarVal:int;
      
      protected var FSoulVal:int;
      
      protected var FAstrologyFree:int;
      
      protected var FRefreshFree:int;
      
      protected var FStarShopList:Vector.<TSoulExchangeVo>;
      
      protected var FSoulShopList:Vector.<TSoulExchangeVo>;
      
      public function TActivityAstrologyData()
      {
         super();
         this.FLoginGiftInventories = new Vector.<TInventories>();
         this.FExtractDataVec = new Vector.<TSCStarPicture>();
         this.FStarVec = new Vector.<TStarVo>();
         this.FStarCombineVec = new Vector.<TStarCombinesVo>();
         this.FStarShopList = new Vector.<TSoulExchangeVo>();
         this.FSoulShopList = new Vector.<TSoulExchangeVo>();
      }
      
      public function get ActivityConfig() : THDAstrologyConfig
      {
         return this.FActivityConfig;
      }
      
      public function set ActivityConfig(param1:THDAstrologyConfig) : void
      {
         this.FActivityConfig = param1;
      }
      
      public function get CurDay() : int
      {
         return this.FCurDay;
      }
      
      public function set CurDay(param1:int) : void
      {
         this.FCurDay = param1;
      }
      
      public function get LoginGiftInventories() : Vector.<TInventories>
      {
         return this.FLoginGiftInventories;
      }
      
      public function set LoginGiftInventories(param1:Vector.<TInventories>) : void
      {
         this.FLoginGiftInventories = param1;
      }
      
      public function get ExtractDataVec() : Vector.<TSCStarPicture>
      {
         return this.FExtractDataVec;
      }
      
      public function set ExtractDataVec(param1:Vector.<TSCStarPicture>) : void
      {
         this.FExtractDataVec = param1;
      }
      
      public function get StarVec() : Vector.<TStarVo>
      {
         return this.FStarVec;
      }
      
      public function set StarVec(param1:Vector.<TStarVo>) : void
      {
         this.FStarVec = param1;
      }
      
      public function get StarCombineVec() : Vector.<TStarCombinesVo>
      {
         return this.FStarCombineVec;
      }
      
      public function set StarCombineVec(param1:Vector.<TStarCombinesVo>) : void
      {
         this.FStarCombineVec = param1;
      }
      
      public function get LoginGiftState() : int
      {
         return this.FLoginGiftState;
      }
      
      public function set LoginGiftState(param1:int) : void
      {
         this.FLoginGiftState = param1;
      }
      
      public function get StarVal() : int
      {
         return this.FStarVal;
      }
      
      public function set StarVal(param1:int) : void
      {
         this.FStarVal = param1;
      }
      
      public function get SoulVal() : int
      {
         return this.FSoulVal;
      }
      
      public function set SoulVal(param1:int) : void
      {
         this.FSoulVal = param1;
      }
      
      public function get AstrologyFree() : int
      {
         return this.FAstrologyFree;
      }
      
      public function set AstrologyFree(param1:int) : void
      {
         this.FAstrologyFree = param1;
      }
      
      public function get RefreshFree() : int
      {
         return this.FRefreshFree;
      }
      
      public function set RefreshFree(param1:int) : void
      {
         this.FRefreshFree = param1;
      }
      
      public function get StarShopList() : Vector.<TSoulExchangeVo>
      {
         return this.FStarShopList;
      }
      
      public function set StarShopList(param1:Vector.<TSoulExchangeVo>) : void
      {
         this.FStarShopList = param1;
      }
      
      public function get SoulShopList() : Vector.<TSoulExchangeVo>
      {
         return this.FSoulShopList;
      }
      
      public function set SoulShopList(param1:Vector.<TSoulExchangeVo>) : void
      {
         this.FSoulShopList = param1;
      }
      
      public function GetAstrologyFinishTimes() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TSCStarPicture = null;
         _loc3_ = int(this.FExtractDataVec.length);
         _loc1_ = 0;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FExtractDataVec[_loc2_];
            if(_loc4_.ExtractState == -1)
            {
               _loc1_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
   }
}

