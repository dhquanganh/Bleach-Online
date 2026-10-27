package Processors.Game.Lobby.Activity.HDChess
{
   import Components.ScrollBar.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HDActivityOS.*;
   import Logics.HDChess.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Activity.HDChess.Component.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   
   public class TProcessorWindowAchieve extends TProcessorHDSingleWindowBase
   {
      
      protected var FMC_ScollBar:TScrollBar;
      
      protected var FHD_Chess:THDChess;
      
      protected var FMC_AwardBar:Vector.<TUIAchieveItem>;
      
      protected var FData_Chess:TActivityChess;
      
      protected var FInventories:Vector.<TInventories>;
      
      public function TProcessorWindowAchieve(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = "MC_AchieveChess";
         FActivityID = CONST_ACTIVITY_MODE.Activity_Chess;
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         super.InitWindow(param1);
         this.FMC_ScollBar = new TScrollBar(FScene["MC_ScollBar"],300,false,0,60);
         this.FMC_ScollBar.Visible = false;
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         super.UpdateDataBase(param1);
         this.FData_Chess = param1 as TActivityChess;
         _loc3_ = this.FHD_Chess.AchieveAward.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FMC_AwardBar[_loc2_].UpdateUI(_loc2_,this.FInventories[_loc2_].GetInventoryByIndex(0),this.FHD_Chess.AchieveAward[_loc2_],this.FData_Chess.AchieveAward[_loc2_].Status);
            this.FMC_AwardBar[_loc2_].OnBtnOkClick = this.ProcessorOnOk;
            _loc2_++;
         }
      }
      
      protected function ProcessorOnOk(param1:Object, param2:uint) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param2);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TUIAchieveItem = null;
         var _loc4_:Vector.<uint> = null;
         var _loc5_:Sprite = null;
         super.UpdateUIConfig();
         this.FHD_Chess = FHDActivityConfig as THDChess;
         if(!this.FMC_ScollBar.Visible)
         {
            _loc2_ = this.FHD_Chess.AchieveAward.length;
            this.FMC_AwardBar = new Vector.<TUIAchieveItem>(_loc2_);
            this.FMC_ScollBar.Clear();
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc3_ = new TUIAchieveItem(this);
               _loc3_.OnQuerySequenceContext = SlotsOnQuerySequenceContext;
               _loc3_.OnSlotOver = this.ShowTipOnMove;
               _loc3_.OnSlotOut = this.HideTipOnOut;
               _loc3_.OnBtnOkClick = BtnOKOnClick;
               _loc3_.OnBtnOkMove = OnHintOver;
               _loc3_.OnBtnOkOut = OnHintOut;
               _loc3_.OnEffectText = FOnEffectText;
               _loc5_ = TUtilityReflection.CreateDisplayObjectInstance("MC_AchieveItemChess") as Sprite;
               _loc3_.Perform_UIDispatch(_loc5_);
               this.FMC_AwardBar[_loc1_] = _loc3_;
               this.FMC_ScollBar.AddItem(_loc3_);
               _loc1_++;
            }
            this.FMC_ScollBar.Visible = true;
         }
         _loc2_ = this.FHD_Chess.AchieveAward.length;
         _loc4_ = new Vector.<uint>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_[_loc1_] = this.FHD_Chess.AchieveAward[_loc1_].Award;
            _loc1_++;
         }
         this.FInventories = ProcessorGetInventoriesVectByAwardID(_loc4_);
      }
      
      protected function ShowTipOnMove(param1:Object, param2:uint) : void
      {
         if(FOnGiftBoxMove != null)
         {
            FOnGiftBoxMove(this,this.FInventories[param2]);
         }
      }
      
      protected function HideTipOnOut(param1:Object) : void
      {
         if(FOnGiftBoxOut != null)
         {
            FOnGiftBoxOut(this);
         }
      }
      
      override protected function UpdateUI() : void
      {
      }
      
      override protected function LogicsPerform() : void
      {
      }
      
      override protected function Reset() : void
      {
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         super.BtnCloseOnClick(param1,param2);
         if(FOnBtnCloseClick != null)
         {
            FOnBtnCloseClick();
         }
      }
   }
}

