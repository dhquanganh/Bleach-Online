package Processors.Game.Lobby.HeroCompanion.CardEmploy
{
   import Components.Standard.TUIButton;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.HeroCompanion.THeroCompanionData;
   import Processors.Game.Lobby.HeroCompanion.CardEmploy.EmployEffect.TCompanionEmployResult;
   import Processors.Game.Lobby.HeroCompanion.Components.TCompanionCardItem;
   import Processors.Game.Lobby.HeroCompanion.Components.TCompanionTextArea;
   import Processors.Game.Lobby.HeroCompanion.TCompanionBaseView;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class TProcessorCompanionEmploy extends TCompanionBaseView
   {
      
      protected static const Info_Width:int = CONST_HEROCOMPANION.COMPANION_EMPLOY_WIDTH;
      
      protected static const Info_Height:int = CONST_HEROCOMPANION.COMPANION_EMPLOY_HEIGHT;
      
      protected static const Result_Height:int = CONST_HEROCOMPANION.COMPANION_RESULT_HEIGHT;
      
      protected static const Card_Num:int = 3;
      
      protected static const Scroll_Height:int = 118;
      
      protected var FIcon:Sprite;
      
      protected var FBtnSilver:TUIButton;
      
      protected var FBtnGold:TUIButton;
      
      protected var FBtnEncounter:TUIButton;
      
      protected var FInfoView:TCompanionEmployInfo;
      
      protected var FResultView:TCompanionEmployResult;
      
      protected var FTextArea:TCompanionTextArea;
      
      public function TProcessorCompanionEmploy(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function SetIcon(param1:Boolean) : void
      {
         this.FIcon.visible = param1;
      }
      
      private function BtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         _loc3_ = param1 as TUIButton;
         this.FInfoView.Visible = true;
         switch(_loc3_)
         {
            case this.FBtnSilver:
               this.FInfoView.TabOnSwitch(CONST_HEROCOMPANION.TabType_Silver);
               break;
            case this.FBtnGold:
               this.FInfoView.TabOnSwitch(CONST_HEROCOMPANION.TabType_Gold);
               break;
            case this.FBtnEncounter:
               this.FInfoView.TabOnSwitch(CONST_HEROCOMPANION.TabType_Encounter);
         }
      }
      
      protected function ItemOnOver(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TCompanionCardItem = null;
         _loc3_ = param1 as TCompanionCardItem;
         this.OnOver(_loc3_.Data);
      }
      
      protected function ItemOnOut(param1:Object, param2:MouseEvent) : void
      {
         this.OnOut();
      }
      
      protected function OnOver(param1:Object) : void
      {
         if(FTipOnOver != null)
         {
            FTipOnOver(param1);
         }
      }
      
      protected function OnOut() : void
      {
         if(FTipOnOut != null)
         {
            FTipOnOut();
         }
      }
      
      protected function Update() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.SetIcon(!FData.EncounterStatus);
         this.FInfoView.SetData(FData);
      }
      
      protected function OnUpdateIcon() : void
      {
         this.SetIcon(!FData.EncounterStatus);
      }
      
      override public function UIDispatch(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TCompanionCardItem = null;
         var _loc5_:TConfigValue = null;
         var _loc6_:Point = null;
         this.FIcon = param1["MC_Icon"];
         super.UIDispatch(param1["MC_Main"]);
         this.FBtnSilver = new TUIButton();
         this.FBtnSilver.Substrate = FMainUI["Btn_Employ_0"];
         this.FBtnSilver.OnClick = this.BtnOnClick;
         this.FBtnGold = new TUIButton();
         this.FBtnGold.Substrate = FMainUI["Btn_Employ_1"];
         this.FBtnGold.OnClick = this.BtnOnClick;
         this.FBtnEncounter = new TUIButton();
         this.FBtnEncounter.Substrate = FMainUI["Btn_Employ_2"];
         this.FBtnEncounter.OnClick = this.BtnOnClick;
         this.FInfoView = new TCompanionEmployInfo(FParent);
         this.FInfoView.TipOnOver = this.OnOver;
         this.FInfoView.TipOnOut = this.OnOut;
         this.FInfoView.UpdateIcon = this.OnUpdateIcon;
         this.FInfoView.Load();
         this.FInfoView.Visible = false;
         this.FInfoView.X = CONST_HEROCOMPANION.COMPANION_WINDOW_WIDTH - Info_Width >> 1;
         this.FInfoView.Y = CONST_HEROCOMPANION.COMPANION_WINDOW_HEIGHT - Info_Height >> 1;
         _loc6_ = new Point();
         this.FResultView = new TCompanionEmployResult(FParent);
         this.FResultView.TipOnOver = this.OnOver;
         this.FResultView.TipOnOut = this.OnOut;
         this.FResultView.Load();
         this.FResultView.Visible = false;
         this.FResultView.X = -FParent.localToGlobal(_loc6_).x;
         this.FResultView.Y = CONST_HEROCOMPANION.COMPANION_WINDOW_HEIGHT - Result_Height >> 1;
         this.FTextArea = new TCompanionTextArea(this);
         this.FTextArea.Substrate = param1["MC_List"];
         this.FTextArea.ActivityHeight = Scroll_Height;
         this.FTextArea.Init();
         this.FTextArea.HtmlText = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_COMPANION_01);
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Companion_SkinFrame) as TConfigValue;
         param1["MC_Main"].gotoAndStop(int(_loc5_.Value));
      }
      
      override public function SetData(param1:THeroCompanionData) : void
      {
         super.SetData(param1);
         this.Update();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FTextArea != null)
         {
            this.FTextArea.Update();
         }
      }
      
      public function ShowResult() : void
      {
         this.FResultView.Show(FData.CardResults,FData.ChipResults);
      }
   }
}

