package Processors.Game.Lobby.Activity.HDChess
{
   import Foundation.Common.*;
   import Foundation.Queries.Coordinate.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityMode.*;
   import Logics.HDChess.*;
   import Logics.Inventories.*;
   import Logics.Streamization.HDActivityChess.*;
   import Processors.Game.Common.Effects.Texts.*;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowsBase;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Rendering.Overlayers.HDGiftBox.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TProcessorChess extends TProcessorHDSingleWindowsBase
   {
      
      public static const SIZE_Width:uint = 657;
      
      public static const SIZE_Height:uint = 572;
      
      public static const SIZE_Width2:uint = 404;
      
      public static const SIZE_Height2:uint = 365;
      
      protected var FProcessorWindowChess:TProcessorWindowChess;
      
      protected var FProcessorWindowChessAchieve:TProcessorWindowAchieve;
      
      protected var FData_Chess:TActivityChess;
      
      protected var FHD_Chess:THDChess;
      
      protected var FUnstreamizerActivityChess:TunstreamizerActivityChess;
      
      protected var FInventories:TInventories;
      
      protected var FEffectCoordinateParameters:TEffectCoordinateParameters;
      
      protected var FQueryCoordinate:TQueryCoordinate;
      
      protected var FOnEffectAcquireInventory:Function;
      
      protected var FOnQueryShortcutCoordinate:Function;
      
      public function TProcessorChess(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,FParameters);
         FActivityID = CONST_ACTIVITY_MODE.Activity_Chess;
         this.FData_Chess = new TActivityChess();
         this.FUnstreamizerActivityChess = new TunstreamizerActivityChess();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityChess);
      }
      
      override protected function InitWindows() : void
      {
         var _loc1_:TBounds = null;
         super.InitWindows();
         this.FProcessorWindowChess = new TProcessorWindowChess(this);
         this.FProcessorWindowChess.Visible = false;
         this.FProcessorWindowChess.OnBtnCloseClick = ProcessorClose;
         this.FProcessorWindowChess.OnAchieve = this.ProcessorOnAchieve;
         this.FProcessorWindowChess.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowChess.OnHintOver = UIComponentsOnOver;
         this.FProcessorWindowChess.OnHintOut = UIComponentsOnOut;
         this.FProcessorWindowChess.OnSlotOver = UIComponentsHintOnOver;
         this.FProcessorWindowChess.OnSlotOut = UIComponentsHintOnOut;
         this.FProcessorWindowChess.OnGiftBoxMove = this.ProcessorOnGiftBoxMove;
         this.FProcessorWindowChess.OnGiftBoxOut = ProcessorOnGiftBoxOut;
         _loc1_ = new TBounds();
         _loc1_.Width = SIZE_Width;
         _loc1_.Height = SIZE_Height;
         ComponentBoundsCenter(this.FProcessorWindowChess,_loc1_);
         _loc1_ = null;
         this.FProcessorWindowChessAchieve = new TProcessorWindowAchieve(this);
         this.FProcessorWindowChessAchieve.Visible = false;
         this.FProcessorWindowChessAchieve.OnBtnCloseClick = this.AchieveCloseOnClick;
         this.FProcessorWindowChessAchieve.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowChessAchieve.OnHintOver = UIComponentsOnOver;
         this.FProcessorWindowChessAchieve.OnHintOut = UIComponentsOnOut;
         this.FProcessorWindowChessAchieve.OnSlotOver = UIComponentsHintOnOver;
         this.FProcessorWindowChessAchieve.OnSlotOut = UIComponentsHintOnOut;
         this.FProcessorWindowChessAchieve.OnGiftBoxMove = this.ProcessorOnGiftBoxMove;
         this.FProcessorWindowChessAchieve.OnGiftBoxOut = ProcessorOnGiftBoxOut;
         _loc1_ = new TBounds();
         _loc1_.Width = SIZE_Width2;
         _loc1_.Height = SIZE_Height2;
         ComponentBoundsCenter(this.FProcessorWindowChessAchieve,_loc1_);
         _loc1_ = null;
         this.FInventories = new TInventories();
         this.FEffectCoordinateParameters = new TEffectCoordinateParameters();
         this.FQueryCoordinate = new TQueryCoordinate();
      }
      
      protected function AchieveCloseOnClick() : void
      {
         this.FProcessorWindowChessAchieve.Hide();
      }
      
      protected function ProcessorOnAchieve() : void
      {
         this.FProcessorWindowChessAchieve.Show(FCurAtoms,this.FHD_Chess,this.FData_Chess);
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         this.FHD_Chess = FHDActivityConfig as THDChess;
      }
      
      override protected function ProcessorSCInitWindow(param1:TActivityAtoms, param2:ByteArray) : void
      {
         super.ProcessorSCInitWindow(param1,param2);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param2,null);
         this.FUnstreamizerActivityChess.UnstreamizeUpdateChess(FActivityInitRetData,this.FData_Chess,this.FHD_Chess);
         if(!this.Visible)
         {
            return;
         }
         this.FProcessorWindowChess.Show(FCurAtoms,this.FHD_Chess,this.FData_Chess);
      }
      
      override protected function ProcessorSCAwardStatusChangeNotify(param1:TActAwardStatusInfo) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         super.ProcessorSCAwardStatusChangeNotify(param1);
         _loc4_ = false;
         if(!this.Visible)
         {
            return;
         }
         if(param1.Index == 100)
         {
            this.FData_Chess.LocationPos = param1.Status;
            this.FProcessorWindowChess.PlayDice(param1.Status);
         }
         if(param1.Index == 101)
         {
            this.FData_Chess.FinalBoxIndex = param1.Status;
         }
         if(param1.Index < this.FHD_Chess.AchieveAward.length)
         {
            _loc2_ = 0;
            while(_loc2_ < this.FHD_Chess.AchieveAward.length)
            {
               this.FData_Chess.AchieveAward[param1.Index].Status = param1.Status;
               _loc2_++;
            }
         }
         if(this.FProcessorWindowChess.Visible)
         {
            this.FProcessorWindowChess.Show(FCurAtoms,this.FHD_Chess,this.FData_Chess);
         }
         if(this.FProcessorWindowChessAchieve.Visible)
         {
            this.FProcessorWindowChessAchieve.Show(FCurAtoms,this.FHD_Chess,this.FData_Chess);
         }
      }
      
      override public function ValuesChange(param1:TActivityAtoms, param2:Vector.<int>) : void
      {
         super.ValuesChange(param1,param2);
         this.FData_Chess.CoolDown = param2[0];
         this.FProcessorWindowChess.Show(FCurAtoms,this.FHD_Chess,this.FData_Chess);
      }
      
      protected function ProcessorOnQueryMonsterCoordinate(param1:TQueryCoordinate) : void
      {
         this.FProcessorWindowChess.QueryMonsterCoordinate(param1);
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
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowChess.Load();
            this.FProcessorWindowChessAchieve.Load();
            return;
         }
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_Chess);
         FCurAtoms = GetAtomsByActivityID(FActivityID);
         if(FMemoryID != FCurAtoms.Identifier)
         {
            if(this.FHD_Chess == null)
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
         this.FProcessorWindowChess.Hide();
         this.FProcessorWindowChessAchieve.Hide();
      }
      
      override public function OperateRet(param1:Vector.<TFixedAward>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TInventory = null;
         if(!this.Visible || this.FProcessorWindowChessAchieve.Visible)
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

