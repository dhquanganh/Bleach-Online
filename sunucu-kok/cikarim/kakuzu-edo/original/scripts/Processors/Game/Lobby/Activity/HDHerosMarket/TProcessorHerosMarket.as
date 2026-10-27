package Processors.Game.Lobby.Activity.HDHerosMarket
{
   import Foundation.Common.*;
   import Foundation.Queries.Coordinate.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityMode.*;
   import Logics.HDHerosMarket.*;
   import Logics.Inventories.*;
   import Logics.Streamization.HDHerosMarket.*;
   import Processors.Game.Common.Effects.Texts.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Common.*;
   import Rendering.Overlayers.HDGiftBox.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TProcessorHerosMarket extends TProcessorHDSingleWindowsBase
   {
      
      public static const SIZE_Width:uint = 672;
      
      public static const SIZE_Height:uint = 550;
      
      public static const SIZE_Width2:uint = 300;
      
      public static const SIZE_Height2:uint = 430;
      
      protected var FProcessorWindowHerosMarkets:TProcessorWindowHerosMarkets;
      
      protected var FProcessorWindowHMAchieve:TProcessorWindowHMAchieve;
      
      protected var FData_HerosMarkets:TActivityHerosMarkets;
      
      protected var FHD_HerosMarkets:THDHerosMarket;
      
      protected var FUnstreamizerActivityHerosMarkets:TUnstreamizerHerosMarket;
      
      protected var FInventories:TInventories;
      
      protected var FEffectCoordinateParameters:TEffectCoordinateParameters;
      
      protected var FQueryCoordinate:TQueryCoordinate;
      
      protected var FOnEffectAcquireInventory:Function;
      
      protected var FOnQueryShortcutCoordinate:Function;
      
      public function TProcessorHerosMarket(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,FParameters);
         FActivityID = CONST_ACTIVITY_MODE.Activity_HerosMarkets;
         this.FData_HerosMarkets = new TActivityHerosMarkets();
         this.FUnstreamizerActivityHerosMarkets = new TUnstreamizerHerosMarket();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityHerosMarkets);
      }
      
      override protected function InitWindows() : void
      {
         var _loc1_:TBounds = null;
         var _loc2_:TBounds = null;
         super.InitWindows();
         this.FProcessorWindowHerosMarkets = new TProcessorWindowHerosMarkets(this);
         this.FProcessorWindowHerosMarkets.Visible = false;
         this.FProcessorWindowHerosMarkets.OnBtnCloseClick = ProcessorClose;
         this.FProcessorWindowHerosMarkets.OnAchieveShow = this.ProcessorOnAchieveShow;
         this.FProcessorWindowHerosMarkets.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowHerosMarkets.OnHintOver = UIComponentsOnOver;
         this.FProcessorWindowHerosMarkets.OnHintOut = UIComponentsOnOut;
         this.FProcessorWindowHerosMarkets.OnSlotOver = UIComponentsHintOnOver;
         this.FProcessorWindowHerosMarkets.OnSlotOut = UIComponentsHintOnOut;
         this.FProcessorWindowHerosMarkets.OnGiftBoxMove = this.ProcessorOnGiftBoxMove;
         this.FProcessorWindowHerosMarkets.OnGiftBoxOut = ProcessorOnGiftBoxOut;
         _loc1_ = new TBounds();
         _loc1_.Width = SIZE_Width;
         _loc1_.Height = SIZE_Height;
         ComponentBoundsCenter(this.FProcessorWindowHerosMarkets,_loc1_);
         this.FProcessorWindowHMAchieve = new TProcessorWindowHMAchieve(this);
         this.FProcessorWindowHMAchieve.Visible = false;
         this.FProcessorWindowHMAchieve.OnBtnCloseClick = this.ProcessorHide;
         this.FProcessorWindowHMAchieve.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowHMAchieve.OnHintOver = UIComponentsOnOver;
         this.FProcessorWindowHMAchieve.OnHintOut = UIComponentsOnOut;
         this.FProcessorWindowHMAchieve.OnSlotOver = UIComponentsHintOnOver;
         this.FProcessorWindowHMAchieve.OnSlotOut = UIComponentsHintOnOut;
         this.FProcessorWindowHMAchieve.OnGiftBoxMove = this.ProcessorOnGiftBoxMove;
         this.FProcessorWindowHMAchieve.OnGiftBoxOut = ProcessorOnGiftBoxOut;
         _loc2_ = new TBounds();
         _loc2_.Width = SIZE_Width2;
         _loc2_.Height = SIZE_Height2;
         ComponentBoundsCenter(this.FProcessorWindowHMAchieve,_loc2_);
         this.FInventories = new TInventories();
         this.FEffectCoordinateParameters = new TEffectCoordinateParameters();
         this.FQueryCoordinate = new TQueryCoordinate();
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         this.FHD_HerosMarkets = FHDActivityConfig as THDHerosMarket;
      }
      
      override protected function ProcessorSCInitWindow(param1:TActivityAtoms, param2:ByteArray) : void
      {
         super.ProcessorSCInitWindow(param1,param2);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param2,null);
         this.FUnstreamizerActivityHerosMarkets.UnstreamizeUpdateHerosMarket(FActivityInitRetData,this.FData_HerosMarkets,this.FHD_HerosMarkets);
         if(!this.Visible)
         {
            return;
         }
         this.FProcessorWindowHerosMarkets.Show(FCurAtoms,this.FHD_HerosMarkets,this.FData_HerosMarkets);
      }
      
      override protected function ProcessorSCAwardStatusChangeNotify(param1:TActAwardStatusInfo) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         super.ProcessorSCAwardStatusChangeNotify(param1);
         if(param1.Index == this.FHD_HerosMarkets.HeroExpIndex)
         {
            this.FData_HerosMarkets.HeroExpStatus = param1.Status;
         }
         if(param1.Index == this.FHD_HerosMarkets.KnifeExpIndex)
         {
            this.FData_HerosMarkets.KnifeExpStatus = param1.Status;
         }
         _loc3_ = int(this.FData_HerosMarkets.HerosHotStatus.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(param1.Index == this.FHD_HerosMarkets.HerosHotIndex[_loc2_])
            {
               this.FData_HerosMarkets.HerosHotStatus[_loc2_] = param1.Status;
            }
            _loc2_++;
         }
         _loc3_ = int(this.FData_HerosMarkets.KnifesHotStatus.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(param1.Index == this.FHD_HerosMarkets.KnifeHotIndex[_loc2_])
            {
               this.FData_HerosMarkets.KnifesHotStatus[_loc2_] = param1.Status;
            }
            _loc2_++;
         }
         _loc3_ = int(this.FData_HerosMarkets.HerosAchieveStatus.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(param1.Index == this.FHD_HerosMarkets.HerosAchieveIndex[_loc2_])
            {
               this.FData_HerosMarkets.HerosAchieveStatus[_loc2_] = param1.Status;
            }
            _loc2_++;
         }
         _loc3_ = int(this.FData_HerosMarkets.KnifesAchieveStatus.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(param1.Index == this.FHD_HerosMarkets.KnifeAchieveIndex[_loc2_])
            {
               this.FData_HerosMarkets.KnifesAchieveStatus[_loc2_] = param1.Status;
            }
            _loc2_++;
         }
         if(this.FProcessorWindowHerosMarkets.Visible)
         {
            this.FProcessorWindowHerosMarkets.Show(FCurAtoms,this.FHD_HerosMarkets,this.FData_HerosMarkets);
         }
         if(this.FProcessorWindowHMAchieve.Visible)
         {
            this.FProcessorWindowHMAchieve.Show(FCurAtoms,this.FHD_HerosMarkets,this.FData_HerosMarkets);
         }
      }
      
      override public function ValuesChange(param1:TActivityAtoms, param2:Vector.<int>) : void
      {
         super.ValuesChange(param1,param2);
         if(!this.Visible)
         {
            return;
         }
         this.FProcessorWindowHerosMarkets.Show(FCurAtoms,this.FHD_HerosMarkets,this.FData_HerosMarkets);
      }
      
      protected function ProcessorOnAchieveShow(param1:uint) : void
      {
         this.FProcessorWindowHMAchieve.Flag = param1;
         this.FProcessorWindowHMAchieve.Show(FCurAtoms,this.FHD_HerosMarkets,this.FData_HerosMarkets);
      }
      
      protected function ProcessorHide() : void
      {
         this.FProcessorWindowHMAchieve.Hide();
      }
      
      override protected function ProcessorOnGiftBoxMove(param1:Object, param2:Object, param3:Object = null) : void
      {
         var _loc4_:TInventories = null;
         super.ProcessorOnGiftBoxMove(param1,param2,param3);
         _loc4_ = param2 as TInventories;
         FGiftBoxTipData.TipReset();
         FGiftBoxTipData.NormalInventories = _loc4_;
         FGiftBoxTipData.AwardType = TOverlayerGiftBox.TYPE_ALL;
         FGiftBoxTipData.NeedColour = true;
         FGiftOverLayer.Context = FGiftBoxTipData;
         FGiftOverLayer.Render(FUICore.MouseCoordinate);
         FGiftOverLayer.Show();
      }
      
      public function get OnEffectAcquireInventory() : Function
      {
         return this.FOnEffectAcquireInventory;
      }
      
      public function set OnEffectAcquireInventory(param1:Function) : void
      {
         this.FOnEffectAcquireInventory = param1;
      }
      
      public function get OnQueryShortcutCoordinate() : Function
      {
         return this.FOnQueryShortcutCoordinate;
      }
      
      public function set OnQueryShortcutCoordinate(param1:Function) : void
      {
         this.FOnQueryShortcutCoordinate = param1;
      }
      
      public function set OnCreateKnifeOfKillSoulData(param1:Function) : void
      {
         this.FProcessorWindowHerosMarkets.OnCreateKnifeOfKillSoulData = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowHerosMarkets.Load();
            this.FProcessorWindowHMAchieve.Load();
            return;
         }
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_HerosMarket);
         FCurAtoms = GetAtomsByActivityID(FActivityID);
         if(FMemoryID != FCurAtoms.Identifier)
         {
            if(this.FHD_HerosMarkets == null)
            {
               GetActivityConfigByActivityAtoms(FCurAtoms);
            }
            FMemoryID = FCurAtoms.Identifier;
         }
         Perform_CS_ActivityInitReq(FCurAtoms.Identifier);
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.FInventories.Clear();
         this.FProcessorWindowHerosMarkets.Hide();
         this.FProcessorWindowHMAchieve.Hide();
      }
      
      override public function OperateRet(param1:Vector.<TFixedAward>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TInventory = null;
         if(!this.Visible)
         {
            return;
         }
         if(param1.length <= 0)
         {
            return;
         }
         if(this.FProcessorWindowHMAchieve.Visible)
         {
            return;
         }
         this.FProcessorWindowHerosMarkets.UpdateCurHero();
      }
   }
}

