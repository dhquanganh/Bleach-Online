package Processors.Game.Lobby.HeroCompanion.CardEmploy
{
   import Components.Standard.TUIButton;
   import Components.Standard.TUITab;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.TCompanionCard;
   import Logics.HeroCompanion.THeroCompanionData;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import Resources.Constants.CONST_HEROCOMPANION;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import ghostcat.util.data.Json;
   
   public class TCompanionEmployInfo extends TProcessorLobbyWindow
   {
      
      protected static const Tab_Num:int = 3;
      
      protected var FBtnClose:TUIButton;
      
      protected var FMainUI:Sprite;
      
      protected var FTab:TUITab;
      
      protected var FEmployMoney:TCompanionEmployMoneyView;
      
      protected var FEmployEncounter:TCompanionEmployEncounterView;
      
      protected var FData:THeroCompanionData;
      
      protected var FTFTitle:TextField;
      
      protected var FTitleArr:Vector.<String>;
      
      protected var FBackGround:Bitmap;
      
      protected var FIcon:Sprite;
      
      protected var FTipOnOver:Function;
      
      protected var FTipOnOut:Function;
      
      protected var FUpdateIcon:Function;
      
      public function TCompanionEmployInfo(param1:TUIComponent)
      {
         super(param1);
         this.FEmployMoney = new TCompanionEmployMoneyView(this);
         this.FEmployMoney.TipOnOver = this.OnOver;
         this.FEmployMoney.TipOnOut = this.OnOut;
         this.FEmployEncounter = new TCompanionEmployEncounterView(this);
         this.FEmployEncounter.TipOnOver = this.OnOver;
         this.FEmployEncounter.TipOnOut = this.OnOut;
         this.FEmployEncounter.UpdateIcon = this.OnUpdateIcon;
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance(CONST_HEROCOMPANION.ResourceID_EmployInfo) as Sprite;
         addChild(this.FMainUI);
         this.InitWindow();
      }
      
      protected function InitWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc3_:Point = null;
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainUI["Btn_Close"];
         this.FBtnClose.OnClick = this.WindowOnClose;
         this.FEmployMoney.UIDispatch(this.FMainUI["MC_Money"]);
         this.FEmployEncounter.UIDispatch(this.FMainUI["MC_Encounter"]);
         this.FTab = new TUITab(this);
         _loc1_ = 0;
         while(_loc1_ < Tab_Num)
         {
            this.FTab.SetTabByIndex(this.FMainUI["MC_Tab_" + _loc1_],_loc1_);
            _loc1_++;
         }
         this.FTFTitle = this.FMainUI["TF_Title"];
         _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_COMPANION_03);
         this.FTitleArr = Vector.<String>(Json.decode(_loc2_) as Array);
         this.FTab.OnSwitch = this.TabViewOnSwitch;
         this.FTab.Init();
         this.FTab.SwithTagManual(0);
         this.FEmployMoney.Visible = false;
         this.FEmployEncounter.Visible = false;
         _loc3_ = new Point();
         this.FBackGround = new Bitmap();
         this.FMainUI.addChildAt(this.FBackGround,0);
         this.FBackGround.bitmapData = SUtilityResource.BtmDataFullScreen;
         _loc3_ = this.FMainUI.localToGlobal(new Point());
         this.FBackGround.x = -_loc3_.x;
         this.FBackGround.y = -_loc3_.y;
         this.FIcon = this.FMainUI["MC_Icon"];
      }
      
      protected function OnUpdateIcon() : void
      {
         this.FIcon.visible = !this.FData.EncounterStatus;
         this.FUpdateIcon();
      }
      
      protected function WindowOnClose(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function TabViewOnSwitch(param1:int) : void
      {
         switch(param1)
         {
            case CONST_HEROCOMPANION.TabType_Silver:
            case CONST_HEROCOMPANION.TabType_Gold:
               this.FEmployEncounter.Visible = false;
               this.FEmployMoney.Visible = true;
               this.FEmployMoney.ShowTab(param1);
               break;
            case CONST_HEROCOMPANION.TabType_Encounter:
               this.FEmployEncounter.Visible = true;
               if(!this.FData.EncounterStatus)
               {
                  this.FEmployEncounter.SendServer();
               }
               this.FEmployMoney.Visible = false;
         }
         this.FTFTitle.text = this.FTitleArr[param1];
      }
      
      protected function OnOver(param1:TCompanionCard) : void
      {
         if(this.FTipOnOver != null)
         {
            this.FTipOnOver(param1);
         }
      }
      
      protected function OnOut() : void
      {
         if(this.FTipOnOut != null)
         {
            this.FTipOnOut();
         }
      }
      
      public function get TipOnOver() : Function
      {
         return this.FTipOnOver;
      }
      
      public function set TipOnOver(param1:Function) : void
      {
         this.FTipOnOver = param1;
      }
      
      public function get TipOnOut() : Function
      {
         return this.FTipOnOut;
      }
      
      public function set TipOnOut(param1:Function) : void
      {
         this.FTipOnOut = param1;
      }
      
      public function get UpdateIcon() : Function
      {
         return this.FUpdateIcon;
      }
      
      public function set UpdateIcon(param1:Function) : void
      {
         this.FUpdateIcon = param1;
      }
      
      public function TabOnSwitch(param1:int) : void
      {
         this.FTab.SwithTagManual(param1);
      }
      
      public function SetData(param1:THeroCompanionData) : void
      {
         this.FData = param1;
         this.FIcon.visible = !this.FData.EncounterStatus;
         this.FEmployMoney.SetData(this.FData);
         this.FEmployEncounter.SetData(this.FData);
         this.FEmployMoney.ShowTab(this.FTab.TabIndex);
      }
   }
}

