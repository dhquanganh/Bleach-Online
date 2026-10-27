package Processors.Game.Lobby.Activity.HDWorldCup
{
   import Foundation.Common.*;
   import Foundation.Queries.Coordinate.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityMode.*;
   import Logics.HDWorldCup.*;
   import Logics.Inventories.*;
   import Logics.Streamization.HDWorldCup.*;
   import Processors.Game.Common.Effects.Texts.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Utilities.EffectTextReward.*;
   import Rendering.Overlayers.HDGiftBox.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TProcessorWorldCup extends TProcessorHDSingleWindowsBase
   {
      
      public static const SIZE_Width:uint = 736;
      
      public static const SIZE_Height:uint = 550;
      
      public static const SIZE_Width2:uint = 645;
      
      public static const SIZE_Height2:uint = 475;
      
      protected var FProcessorWindowWorldCup:TProcessorWindowWorldCup;
      
      protected var FProcessorWindowWorldCupTeam:TProessorWindowWorldCupTeam;
      
      protected var FData_WorldCup:TActivityWorldCup;
      
      protected var FHD_WorldCup:THDWorldCup;
      
      protected var FUnstreamizerActivityWorldCup:TUnstreamizerWorldCup;
      
      protected var FInventories:TInventories;
      
      protected var FEffectCoordinateParameters:TEffectCoordinateParameters;
      
      protected var FQueryCoordinate:TQueryCoordinate;
      
      protected var FOnEffectAcquireInventory:Function;
      
      protected var FOnQueryShortcutCoordinate:Function;
      
      public function TProcessorWorldCup(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,FParameters);
         FActivityID = CONST_ACTIVITY_MODE.Activity_WorldCup;
         this.FData_WorldCup = new TActivityWorldCup();
         this.FUnstreamizerActivityWorldCup = new TUnstreamizerWorldCup();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityWorldCup);
      }
      
      override protected function InitWindows() : void
      {
         var _loc1_:TBounds = null;
         super.InitWindows();
         this.FProcessorWindowWorldCup = new TProcessorWindowWorldCup(this);
         this.FProcessorWindowWorldCup.Visible = false;
         this.FProcessorWindowWorldCup.OnBtnCloseClick = ProcessorClose;
         this.FProcessorWindowWorldCup.TeamsSelector = this.ProcessorOnTeamsSelector;
         this.FProcessorWindowWorldCup.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowWorldCup.OnHintOver = UIComponentsOnOver;
         this.FProcessorWindowWorldCup.OnHintOut = UIComponentsOnOut;
         this.FProcessorWindowWorldCup.OnSlotOver = UIComponentsHintOnOver;
         this.FProcessorWindowWorldCup.OnSlotOut = UIComponentsHintOnOut;
         this.FProcessorWindowWorldCup.OnGiftBoxMove = this.ProcessorOnGiftBoxMove;
         this.FProcessorWindowWorldCup.OnGiftBoxOut = ProcessorOnGiftBoxOut;
         _loc1_ = new TBounds();
         _loc1_.Width = SIZE_Width;
         _loc1_.Height = SIZE_Height;
         ComponentBoundsCenter(this.FProcessorWindowWorldCup,_loc1_);
         _loc1_ = null;
         this.FProcessorWindowWorldCupTeam = new TProessorWindowWorldCupTeam(this);
         this.FProcessorWindowWorldCupTeam.Visible = false;
         this.FProcessorWindowWorldCupTeam.OnBtnCloseClick = this.TeamsCloseOnClick;
         this.FProcessorWindowWorldCupTeam.TeamConfirm = this.ProcessorTeamConfirm;
         this.FProcessorWindowWorldCupTeam.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowWorldCupTeam.OnHintOver = UIComponentsOnOver;
         this.FProcessorWindowWorldCupTeam.OnHintOut = UIComponentsOnOut;
         this.FProcessorWindowWorldCupTeam.OnSlotOver = UIComponentsHintOnOver;
         this.FProcessorWindowWorldCupTeam.OnSlotOut = UIComponentsHintOnOut;
         this.FProcessorWindowWorldCupTeam.OnGiftBoxMove = this.ProcessorOnGiftBoxMove;
         this.FProcessorWindowWorldCupTeam.OnGiftBoxOut = ProcessorOnGiftBoxOut;
         _loc1_ = new TBounds();
         _loc1_.Width = SIZE_Width2;
         _loc1_.Height = SIZE_Height2;
         ComponentBoundsCenter(this.FProcessorWindowWorldCupTeam,_loc1_);
         _loc1_ = null;
         this.FInventories = new TInventories();
         this.FEffectCoordinateParameters = new TEffectCoordinateParameters();
         this.FQueryCoordinate = new TQueryCoordinate();
      }
      
      protected function ProcessorTeamConfirm(param1:int) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         _loc2_ = this.FData_WorldCup.Flags.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            if(param1 + 1 == this.FData_WorldCup.Flags[_loc3_])
            {
               EffectGenerateText(this.FHD_WorldCup.Tips);
               return;
            }
            _loc3_++;
         }
         this.FProcessorWindowWorldCup.CurTeam = param1;
         this.FProcessorWindowWorldCup.UpdateTempFlag();
         this.FProcessorWindowWorldCupTeam.Hide();
      }
      
      protected function TeamsCloseOnClick() : void
      {
         this.FProcessorWindowWorldCupTeam.Hide();
      }
      
      protected function ProcessorOnTeamsSelector() : void
      {
         this.FProcessorWindowWorldCupTeam.Show(FCurAtoms,this.FHD_WorldCup,this.FData_WorldCup);
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         this.FHD_WorldCup = FHDActivityConfig as THDWorldCup;
      }
      
      override protected function ProcessorSCInitWindow(param1:TActivityAtoms, param2:ByteArray) : void
      {
         super.ProcessorSCInitWindow(param1,param2);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param2,null);
         this.FUnstreamizerActivityWorldCup.UnstreamizeUpdateWorldCup(FActivityInitRetData,this.FData_WorldCup,this.FHD_WorldCup);
         if(!this.Visible)
         {
            return;
         }
         this.FProcessorWindowWorldCup.Show(FCurAtoms,this.FHD_WorldCup,this.FData_WorldCup);
      }
      
      override protected function ProcessorSCAwardStatusChangeNotify(param1:TActAwardStatusInfo) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         super.ProcessorSCAwardStatusChangeNotify(param1);
         if(param1.Index == 35)
         {
            this.FData_WorldCup.FinalStatus = param1.Status;
         }
         if(param1.Index == 33)
         {
            this.FData_WorldCup.HadMoney[0] = param1.Condition[0];
            this.FData_WorldCup.Flags[0] = param1.Status;
         }
         if(param1.Index == 34)
         {
            this.FData_WorldCup.HadMoney[1] = param1.Condition[0];
            this.FData_WorldCup.Flags[1] = param1.Status;
         }
         if(this.FProcessorWindowWorldCup.Visible)
         {
            this.FProcessorWindowWorldCup.Show(FCurAtoms,this.FHD_WorldCup,this.FData_WorldCup);
         }
      }
      
      override public function ValuesChange(param1:TActivityAtoms, param2:Vector.<int>) : void
      {
         super.ValuesChange(param1,param2);
         this.FData_WorldCup.Score = param2[0];
         if(this.Visible)
         {
            this.FProcessorWindowWorldCup.Show(FCurAtoms,this.FHD_WorldCup,this.FData_WorldCup);
         }
      }
      
      protected function ProcessorOnQueryMonsterCoordinate(param1:TQueryCoordinate) : void
      {
         this.FProcessorWindowWorldCup.QueryMonsterCoordinate(param1);
      }
      
      protected function ProcessorOnQueryCoordinateDestination(param1:Object, param2:TQueryCoordinate) : void
      {
         if(this.FOnQueryShortcutCoordinate != null)
         {
            this.FOnQueryShortcutCoordinate(this,CONST_SHORTCUTS.POSITION_MainFunction,CONST_SHORTCUTS.TYPE_MainFunction_Backpack,param2);
         }
      }
      
      override protected function ProcessorOnGiftBoxMove(param1:Object, param2:Object, param3:Object = null) : void
      {
         var _loc4_:TInventories = null;
         super.ProcessorOnGiftBoxMove(param1,param2,param3);
         _loc4_ = param2 as TInventories;
         FGiftBoxTipData.TipReset();
         FGiftBoxTipData.NormalInventories = _loc4_;
         FGiftBoxTipData.AwardType = TOverlayerGiftBox.TYPE_ONEOFALL;
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
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowWorldCup.Load();
            this.FProcessorWindowWorldCupTeam.Load();
            return;
         }
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_WorldCup);
         FCurAtoms = GetAtomsByActivityID(FActivityID);
         if(FMemoryID != FCurAtoms.Identifier)
         {
            if(this.FHD_WorldCup == null)
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
         this.FProcessorWindowWorldCup.Hide();
         this.FProcessorWindowWorldCupTeam.Hide();
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
         this.FQueryCoordinate.Value.Reset();
         this.ProcessorOnQueryMonsterCoordinate(this.FQueryCoordinate);
         this.FEffectCoordinateParameters.CoordinateSource.Assign(this.FQueryCoordinate.Value);
         this.FQueryCoordinate.Value.Reset();
         this.ProcessorOnQueryCoordinateDestination(this,this.FQueryCoordinate);
         this.FEffectCoordinateParameters.CoordinateDestination.Assign(this.FQueryCoordinate.Value);
         this.FInventories.Clear();
         SToolReward.GetInventoriesByFixedAwards(param1,this.FInventories);
         _loc3_ = this.FInventories.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FInventories.GetInventoryByIndex(_loc2_);
            if(this.FOnEffectAcquireInventory != null)
            {
               this.FOnEffectAcquireInventory(this,_loc4_,this.FEffectCoordinateParameters);
            }
            _loc2_++;
         }
      }
   }
}

