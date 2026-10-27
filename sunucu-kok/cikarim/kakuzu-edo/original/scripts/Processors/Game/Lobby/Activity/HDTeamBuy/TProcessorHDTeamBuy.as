package Processors.Game.Lobby.Activity.HDTeamBuy
{
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityMode.*;
   import Logics.HDTeamBuy.*;
   import Logics.Streamization.HDActivitySingle.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Common.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TProcessorHDTeamBuy extends TProcessorHDSingleWindowsBase
   {
      
      protected static const SIZE_WIDTH_WindowSignUp:uint = 635;
      
      protected static const SIZE_HEIGHT_WindowSignUp:uint = 506;
      
      protected static const SIZE_WIDTH_WindowGetBuy:uint = 261;
      
      protected static const SIZE_HEIGHT_WindowGetBuy:uint = 434;
      
      protected var FProcessorWindowSignUp:TProcessorHDWindowTeamBuySign;
      
      protected var FProcessorWindowBuy:TProcessorHDWindowTeamBuyGetBuy;
      
      protected var FBoundsSign:TBounds;
      
      protected var FBoundsBuy:TBounds;
      
      protected var FServerDate:Date;
      
      protected var FServerTick:uint;
      
      protected var FData_TeamBuy:TActivityTeamBuy;
      
      protected var FHD_TeamBuy:THDTeamBuy;
      
      protected var FUnsteamizerActivitySingle:TUnstreamizerActivitySingle;
      
      protected var FIsInitData:Boolean;
      
      public function TProcessorHDTeamBuy(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FIsInitData = false;
         FActivityID = CONST_ACTIVITY_MODE.Activity_TeamBuy;
         this.FData_TeamBuy = new TActivityTeamBuy();
         this.FUnsteamizerActivitySingle = new TUnstreamizerActivitySingle();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityTeamBuy);
      }
      
      override protected function LogicsPerform() : void
      {
         if(this.FIsInitData)
         {
            this.CheckStartBuying();
            this.SetTeamBuyStatus();
         }
         super.LogicsPerform();
      }
      
      override protected function InitWindows() : void
      {
         super.InitWindows();
         this.FProcessorWindowSignUp = new TProcessorHDWindowTeamBuySign(this);
         this.FProcessorWindowSignUp.OnBtnCloseClick = this.ProcessorsOnBtnCloseClick;
         this.FProcessorWindowSignUp.OnSlotOver = UIComponentsHintOnOver;
         this.FProcessorWindowSignUp.OnSlotOut = UIComponentsHintOnOut;
         this.FProcessorWindowSignUp.Hide();
         this.FProcessorWindowBuy = new TProcessorHDWindowTeamBuyGetBuy(this);
         this.FProcessorWindowBuy.OnBtnCloseClick = this.ProcessorsOnBtnCloseClick;
         this.FProcessorWindowBuy.OnSlotOver = UIComponentsHintOnOver;
         this.FProcessorWindowBuy.OnSlotOut = UIComponentsHintOnOut;
         this.FProcessorWindowBuy.Hide();
         this.FBoundsSign = new TBounds();
         this.FBoundsSign.Width = SIZE_WIDTH_WindowSignUp;
         this.FBoundsSign.Height = SIZE_HEIGHT_WindowSignUp;
         ComponentBoundsCenter(this.FProcessorWindowSignUp,this.FBoundsSign);
         this.FBoundsBuy = new TBounds();
         this.FBoundsBuy.Width = SIZE_WIDTH_WindowGetBuy;
         this.FBoundsBuy.Height = SIZE_HEIGHT_WindowGetBuy;
         ComponentBoundsCenter(this.FProcessorWindowBuy,this.FBoundsBuy);
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         this.FHD_TeamBuy = FHDActivityConfig as THDTeamBuy;
      }
      
      override protected function ProcessorSCInitWindow(param1:TActivityAtoms, param2:ByteArray) : void
      {
         super.ProcessorSCInitWindow(param1,param2);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param2,null);
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_TeamBuy);
         FCurAtoms = GetAtomsByActivityID(FActivityID);
         if(FMemoryID != FCurAtoms.Identifier)
         {
            if(this.FHD_TeamBuy == null)
            {
               GetActivityConfigByActivityAtoms(FCurAtoms);
            }
            FMemoryID = FCurAtoms.Identifier;
         }
         this.SetTeamBuyTime();
         this.FIsInitData = true;
         this.FUnsteamizerActivitySingle.UnstreamizeUpdateTeamBuy(FActivityInitRetData,this.FData_TeamBuy,this.FHD_TeamBuy);
         this.SetFavorablePirce();
         if(!this.Visible)
         {
            return;
         }
         this.ProcessorOpenWindow();
      }
      
      override protected function ProcessorSCAwardStatusChangeNotify(param1:TActAwardStatusInfo) : void
      {
         super.ProcessorSCAwardStatusChangeNotify(param1);
         if(!this.FIsInitData)
         {
            return;
         }
         this.FData_TeamBuy.SetBoxStatusByUIndex(param1.Index,param1.Status);
         this.ProcessorOpenWindow();
      }
      
      override public function ValuesChange(param1:TActivityAtoms, param2:Vector.<int>) : void
      {
         super.ValuesChange(param1,param2);
         if(!this.FIsInitData)
         {
            return;
         }
         this.FData_TeamBuy.TBCurDay = param2[0];
         this.FData_TeamBuy.TBSignedPeople = param2[1];
         this.FData_TeamBuy.TBBoughtPeople = param2[2];
         this.SetTeamBuyTime();
         this.SetFavorablePirce();
         this.ProcessorOpenWindow();
      }
      
      protected function ProcessorOpenWindow() : void
      {
         if(!this.Visible)
         {
            return;
         }
         switch(this.FData_TeamBuy.TBStatus)
         {
            case CONST_ACTIVITY_MODE.STATUS_TeamBuy_Sign:
               this.FProcessorWindowSignUp.Show(FCurAtoms,this.FHD_TeamBuy,this.FData_TeamBuy);
               break;
            case CONST_ACTIVITY_MODE.STATUS_TeamBuy_Buy:
               this.FProcessorWindowBuy.Show(FCurAtoms,this.FHD_TeamBuy,this.FData_TeamBuy);
         }
      }
      
      protected function CheckStartBuying() : void
      {
         if(this.FData_TeamBuy.TBBuyBox.BoxStatus != CONST_ACTIVITY_MODE.Activity_AlreadyReceive)
         {
            if(this.FServerTick >= this.FData_TeamBuy.TBTimeStartBuy && this.FServerTick <= this.FData_TeamBuy.TBTimeEndBuy)
            {
               FCurAtoms.Status = CONST_ACTIVITY_MODE.Activity_CanReceive;
            }
            else
            {
               FCurAtoms.Status = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
            }
         }
         else
         {
            FCurAtoms.Status = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
         }
         if(FEffectNotification != null)
         {
            FEffectNotification(this,CONST_SHORTCUTS.TYPE_ActiveList_TeamBuy);
         }
      }
      
      protected function SetFavorablePirce() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<TActivityTBOffRate> = null;
         this.FData_TeamBuy.TBCurAward = this.FData_TeamBuy.ProcessorGetAwardByIndex(this.FData_TeamBuy.TBCurDay);
         _loc3_ = this.FHD_TeamBuy.TBOffRates;
         _loc2_ = int(_loc3_.length);
         this.FData_TeamBuy.TBCurPirce = this.FData_TeamBuy.TBCurAward.Cost * _loc3_[_loc3_.length - 1].Value / 1000;
         this.FData_TeamBuy.TBFavorablePeople = -1;
         this.FData_TeamBuy.TBCurLevel = _loc3_.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FData_TeamBuy.TBSignedPeople <= _loc3_[_loc1_].Condition)
            {
               if(this.FData_TeamBuy.TBSignedPeople == _loc3_[_loc1_].Condition)
               {
                  this.FData_TeamBuy.TBCurPirce = Math.floor(this.FData_TeamBuy.TBCurAward.Cost * _loc3_[_loc1_].Value / 1000);
                  this.FData_TeamBuy.TBCurLevel = _loc1_ + 1;
                  if(_loc1_ != _loc3_.length - 1)
                  {
                     this.FData_TeamBuy.TBFavorablePeople = _loc3_[_loc1_ + 1].Condition - this.FData_TeamBuy.TBSignedPeople;
                  }
               }
               else
               {
                  if(_loc1_ == 0)
                  {
                     this.FData_TeamBuy.TBCurPirce = this.FData_TeamBuy.TBCurAward.Cost;
                  }
                  else
                  {
                     this.FData_TeamBuy.TBCurPirce = Math.floor(this.FData_TeamBuy.TBCurAward.Cost * _loc3_[_loc1_ - 1].Value / 1000);
                  }
                  this.FData_TeamBuy.TBCurLevel = _loc1_;
                  this.FData_TeamBuy.TBFavorablePeople = _loc3_[_loc1_].Condition - this.FData_TeamBuy.TBSignedPeople;
               }
               break;
            }
            _loc1_++;
         }
      }
      
      protected function SetTeamBuyTime() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Date = null;
         var _loc3_:Date = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         _loc2_ = new Date((this.FServerTick = int(STimingCore.ServerTick)) * 1000);
         this.FServerDate = _loc2_;
         _loc4_ = _loc2_.getFullYear();
         _loc5_ = _loc2_.getMonth();
         _loc6_ = _loc2_.getDate();
         _loc7_ = 0;
         _loc8_ = 0;
         _loc9_ = 0;
         _loc10_ = 0;
         _loc3_ = new Date(_loc4_,_loc5_,_loc6_,_loc7_,_loc9_,_loc10_);
         this.FData_TeamBuy.TBTimeZero = _loc3_.getTime() / 1000;
         _loc3_ = null;
         _loc3_ = new Date(_loc4_,_loc5_,_loc6_,this.FHD_TeamBuy.TBSignStartTime[0],this.FHD_TeamBuy.TBSignStartTime[1],_loc10_);
         this.FData_TeamBuy.TBTimeStartSign = _loc3_.getTime() / 1000;
         _loc3_ = null;
         _loc3_ = new Date(_loc4_,_loc5_,_loc6_,this.FHD_TeamBuy.TBSignEndTime[0],this.FHD_TeamBuy.TBSignEndTime[1],_loc10_);
         this.FData_TeamBuy.TBTimeEndSign = _loc3_.getTime() / 1000;
         _loc3_ = null;
         _loc3_ = new Date(_loc4_,_loc5_,_loc6_,this.FHD_TeamBuy.TBBuyStartTime[0],this.FHD_TeamBuy.TBBuyStartTime[1],_loc10_);
         this.FData_TeamBuy.TBTimeStartBuy = _loc3_.getTime() / 1000;
         _loc3_ = null;
         _loc3_ = new Date(_loc4_,_loc5_,_loc6_,this.FHD_TeamBuy.TBBuyEndTime[0],this.FHD_TeamBuy.TBBuyEndTime[1],_loc10_);
         this.FData_TeamBuy.TBTimeEndBuy = _loc3_.getTime() / 1000;
         _loc7_ = 23;
         _loc8_ = 59;
         _loc10_ = 59;
         _loc3_ = null;
         _loc3_ = new Date(_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc10_);
         this.FData_TeamBuy.TBTimeTwentyFour = _loc3_.getTime() / 1000;
      }
      
      protected function SetTeamBuyStatus() : void
      {
         if(this.FServerTick > this.FData_TeamBuy.TBTimeZero && this.FServerTick < this.FData_TeamBuy.TBTimeStartBuy)
         {
            this.FData_TeamBuy.TBStatus = CONST_ACTIVITY_MODE.STATUS_TeamBuy_Sign;
         }
         else
         {
            this.FData_TeamBuy.TBStatus = CONST_ACTIVITY_MODE.STATUS_TeamBuy_Buy;
            if(this.FServerTick > this.FData_TeamBuy.TBTimeStartBuy && this.FServerTick < this.FData_TeamBuy.TBTimeEndBuy)
            {
               if(FCurAtoms.Status == CONST_ACTIVITY_MODE.Activity_CanNotReceive && this.FData_TeamBuy.TBBuyBox.BoxStatus != CONST_ACTIVITY_MODE.Activity_AlreadyReceive)
               {
                  FCurAtoms.Status = CONST_ACTIVITY_MODE.Activity_CanReceive;
               }
            }
         }
         if(FEffectNotification != null)
         {
            FEffectNotification(this,CONST_SHORTCUTS.TYPE_ActiveList_TeamBuy);
         }
      }
      
      protected function ProcessorsOnBtnCloseClick(param1:Object) : void
      {
         ProcessorClose();
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowSignUp.Load();
            this.FProcessorWindowBuy.Load();
            return;
         }
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_TeamBuy);
         FCurAtoms = GetAtomsByActivityID(FActivityID);
         if(FMemoryID != FCurAtoms.Identifier)
         {
            if(this.FHD_TeamBuy == null)
            {
               GetActivityConfigByActivityAtoms(FCurAtoms);
            }
            FMemoryID = FCurAtoms.Identifier;
         }
         Perform_CS_ActivityInitReq(FCurAtoms.Identifier);
         this.Visible = true;
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.FProcessorWindowSignUp.Hide();
         this.FProcessorWindowBuy.Hide();
      }
   }
}

