package Processors.Game.Lobby.YellowDiamon
{
   import Components.Standard.TUITab;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.Agent.SParametersCore;
   import Logics.SLogicsCore;
   import Logics.YellowDiamon.TYellowDiamon;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_INVENTORY;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorWindowYellowDiamon extends TProcessorLobbyWindow
   {
      
      protected static const ActivityNum:int = 4;
      
      public static const CATEGORY_Equipment:uint = CONST_INVENTORY.CATEGORY_Equipment;
      
      public static const CATEGORY_Treasure:uint = CONST_INVENTORY.CATEGORY_Treasure;
      
      protected var FMainScene:Sprite;
      
      protected var FProcessorWindowDailyGiftBag:TProcessorWindowDailyGiftBag;
      
      protected var FProcessorWindowLevelGiftBag:TProcessorWindowLevelGiftBag;
      
      protected var FProcessorWindowGrowUpGiftBag:TProcessorWindowGrowUpGiftBag;
      
      protected var FProcessorWindowFreshBirdGiftBag:TProcessorWindowFreshBirdGiftBag;
      
      protected var FWindowActivies:Vector.<TProcessorLobbyWindow>;
      
      protected var FTFYellowDiamondLevel:TextField;
      
      protected var FYellowDiamondInfor:Sprite;
      
      protected var FUI:TUITab;
      
      protected var FCurrentTab:int;
      
      protected var FBtnClose:SimpleButton;
      
      public function TProcessorWindowYellowDiamon(param1:TUIComponent)
      {
         super(param1);
         this.ConstructActivity();
      }
      
      protected function ConstructActivity() : void
      {
         this.FProcessorWindowDailyGiftBag = new TProcessorWindowDailyGiftBag(this);
         this.FProcessorWindowDailyGiftBag.SlotOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowDailyGiftBag.SlotOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowDailyGiftBag.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowDailyGiftBag.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowLevelGiftBag = new TProcessorWindowLevelGiftBag(this);
         this.FProcessorWindowLevelGiftBag.SlotOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowLevelGiftBag.SlotOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowLevelGiftBag.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowLevelGiftBag.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowGrowUpGiftBag = new TProcessorWindowGrowUpGiftBag(this);
         this.FProcessorWindowGrowUpGiftBag.SlotOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowGrowUpGiftBag.SlotOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowGrowUpGiftBag.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowGrowUpGiftBag.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowFreshBirdGiftBag = new TProcessorWindowFreshBirdGiftBag(this);
         this.FProcessorWindowFreshBirdGiftBag.SlotOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowFreshBirdGiftBag.SlotOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowFreshBirdGiftBag.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowFreshBirdGiftBag.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FWindowActivies = new Vector.<TProcessorLobbyWindow>();
         this.FWindowActivies.push(this.FProcessorWindowFreshBirdGiftBag);
         this.FWindowActivies.push(this.FProcessorWindowDailyGiftBag);
         this.FWindowActivies.push(this.FProcessorWindowLevelGiftBag);
         this.FWindowActivies.push(this.FProcessorWindowGrowUpGiftBag);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = undefined;
         var _loc3_:MovieClip = null;
         if(SParametersCore.IfBaiDuGame)
         {
            this.FMainScene = TUtilityReflection.CreateDisplayObjectInstance("YellowDiamonUI") as Sprite;
         }
         else if(SParametersCore.IfTXGame)
         {
            this.FMainScene = TUtilityReflection.CreateDisplayObjectInstance("TXYellowDiamonUI") as Sprite;
         }
         addChildAt(this.FMainScene,0);
         _loc3_ = this.FMainScene["ActivityUI"];
         this.FUI = new TUITab(this);
         _loc1_ = 0;
         while(_loc1_ < ActivityNum)
         {
            _loc3_.gotoAndStop(_loc1_ + 1);
            _loc2_ = this.FWindowActivies[_loc1_];
            _loc2_.UIDispatch(_loc3_["Activity"]);
            _loc2_.x = _loc3_.x;
            _loc2_.y = _loc3_.y;
            this.FUI.SetTabByIndex(this.FMainScene["Tab_" + _loc1_],_loc1_);
            _loc1_++;
         }
         this.FUI.OnSwitch = this.OnTabSwith;
         this.FUI.Init();
         this.FTFYellowDiamondLevel = this.FMainScene["YelloDiamonTitle"]["Level"]["Lable"];
         this.FYellowDiamondInfor = this.FMainScene["YelloDiamonTitle"]["Infor"];
         this.FBtnClose = this.FMainScene["Btn_Close"];
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = undefined;
         _loc1_ = 0;
         while(_loc1_ < ActivityNum)
         {
            _loc2_ = this.FWindowActivies[_loc1_];
            _loc2_.UILocation();
            _loc1_++;
         }
         this.FBtnClose.addEventListener(MouseEvent.CLICK,this.BtnCloseClick);
         this.Reset();
         super.ResourcesPerform_UILocations();
      }
      
      protected function Update_Perform() : void
      {
         var _loc1_:TYellowDiamon = null;
         _loc1_ = SLogicsCore.Character.YellowDimondInfor;
         if(SLogicsCore.Character.YellowDimondInfor.IFYellowDiamondUser)
         {
            if(SParametersCore.IfBaiDuGame)
            {
               this.FTFYellowDiamondLevel.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_YellowDiamond_02),_loc1_.Level);
            }
            else if(SParametersCore.IfTXGame)
            {
               this.FTFYellowDiamondLevel.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_YellowDiamond_01),_loc1_.Level);
            }
            this.FTFYellowDiamondLevel.visible = true;
            this.FYellowDiamondInfor.visible = false;
         }
         else
         {
            this.FYellowDiamondInfor.visible = true;
            this.FTFYellowDiamondLevel.visible = false;
         }
      }
      
      protected function OnTabSwith(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TProcessorLobbyWindow = null;
         _loc2_ = 0;
         while(_loc2_ < ActivityNum)
         {
            _loc3_ = this.FWindowActivies[_loc2_];
            _loc3_.visible = false;
            _loc2_++;
         }
         this.FWindowActivies[param1].visible = true;
         this.FCurrentTab = param1;
         this.Update();
      }
      
      protected function BtnCloseClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      public function Update() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.FWindowActivies[this.FCurrentTab];
         _loc1_.Update();
         this.Update_Perform();
      }
      
      public function Reset() : void
      {
         this.FUI.SwithTagManual(0);
      }
      
      public function CheckIfCanRecive() : Boolean
      {
         return this.FProcessorWindowDailyGiftBag.IfCanRecieve() || this.FProcessorWindowLevelGiftBag.IfCanRecieve() || this.FProcessorWindowGrowUpGiftBag.IfCanRecieve() || this.FProcessorWindowFreshBirdGiftBag.IfCanRecieve();
      }
   }
}

