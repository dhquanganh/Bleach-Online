package Processors.Game.Lobby.KnifeOfKillSoul
{
   import Components.Pages.*;
   import Components.Standard.*;
   import Foundation.Common.THint;
   import Foundation.Network.TPacket;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.TBins;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.Inventories.*;
   import Logics.KnifeOfKillSoul.*;
   import Logics.KnifeOfKillSoul.VO.TKnifeStrengthenAdd;
   import Processors.Game.Common.Effects.Texts.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.HyperLink.*;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowKnifeOfkillSoul extends TProcessorLobbyWindow
   {
      
      protected const TabType_All:uint = 0;
      
      protected const TabType_Strengthen:uint = 4;
      
      protected var FMainUI:MovieClip;
      
      protected var FUIPage:TUIPage;
      
      protected var FCurrentPageIndex:int;
      
      protected var FUITab:TUITab;
      
      protected var FBtnClose:SimpleButton;
      
      protected var FBtnHelp:SimpleButton;
      
      protected var FTF_UseKnife:TextField;
      
      protected var FKnifes:Vector.<TSingleKnife>;
      
      protected var FKnifesUI:Vector.<MovieClip>;
      
      protected var FKnifeDatasByType:Vector.<TKnifeOfkillSoulDatas>;
      
      protected var FCurrentShowKnifeID:int;
      
      protected var FCurrentKnifeOfkillSoulDatas:TKnifeOfkillSoulDatas;
      
      protected var FWindowTrain:TProcessorWindowTrain;
      
      protected var FKnifeStrengthen:TKnifeStrengthenUI;
      
      protected var FKnifeStrengthenBox:TProcessorKnifeStrengthenBox;
      
      protected var FKnifeStrengthenSelect:TprocessorKnifeStrengthenSelect;
      
      protected var FKnifeStrengthenAllPhase:TProcessorKnifeStrengthenAllPhase;
      
      protected var FConfigValueBins:TBins;
      
      protected var FStrengthenUnlockLevel:int;
      
      protected var FLockLevelTip:String;
      
      protected var FKnifeOfkillSoulDatas:TKnifeOfkillSoulDatas;
      
      protected var FIfGoBackToDeployment:Boolean;
      
      protected var FTriggerFreshGuide:Boolean;
      
      protected var FKnifeLanguage:TKnifeLanguage;
      
      protected var FHint:THint;
      
      public function TProcessorWindowKnifeOfkillSoul(param1:TUIComponent)
      {
         super(param1);
         this.FKnifeDatasByType = new Vector.<TKnifeOfkillSoulDatas>();
         this.FKnifes = new Vector.<TSingleKnife>();
         this.FKnifesUI = new Vector.<MovieClip>();
         this.FWindowTrain = new TProcessorWindowTrain(param1);
         this.FWindowTrain.OnClickClose = this.WindowTrainClose;
         this.FWindowTrain.OnShortcutHyperlinks = this.WindowTrainLinkTextClick;
         this.FKnifeStrengthenBox = new TProcessorKnifeStrengthenBox(param1);
         this.FKnifeStrengthenBox.Visible = false;
         this.FKnifeStrengthenSelect = new TprocessorKnifeStrengthenSelect(param1);
         this.FKnifeStrengthenSelect.Visible = false;
         this.FKnifeStrengthenSelect.Select = this.OnSelectKnifeStrengthen;
         this.FKnifeStrengthenAllPhase = new TProcessorKnifeStrengthenAllPhase(param1);
         this.FKnifeStrengthenAllPhase.Visible = false;
      }
      
      protected function UIDispatch_Perform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TSingleKnife = null;
         var _loc3_:TConfigValue = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MainBoard") as MovieClip;
         addChild(this.FMainUI);
         this.FConfigValueBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         _loc3_ = this.FConfigValueBins.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Knife_StrongOpenLevel) as TConfigValue;
         this.FStrengthenUnlockLevel = int(_loc3_.Value);
         _loc1_ = 0;
         while(_loc1_ < CONST_KNIFEOFKILLSOUL.KNIFEONEPAGENUM)
         {
            _loc2_ = new TSingleKnife(this);
            _loc2_.KnifeLanguage = this.FKnifeLanguage;
            _loc2_.OnEffectText = this.ProcessorsOnEffectText;
            _loc2_.OnChangeShape = this.OnChangeShape;
            _loc2_.OnClickCommonBtn = this.ClickCommonBtn;
            this.FKnifesUI.push(this.FMainUI["Knife" + (_loc1_ + 1)]);
            _loc2_.UIDispatch(this.FMainUI["Knife" + (_loc1_ + 1)]);
            this.FKnifes.push(_loc2_);
            _loc1_++;
         }
         this.BtnUIDispatch(this.FMainUI);
         this.FWindowTrain.UIDispath();
         this.FKnifeStrengthenBox.UIDispatch();
         this.FKnifeStrengthenSelect.UIDispatch();
         this.FKnifeStrengthenAllPhase.UIDispatch();
         this.FKnifeStrengthen = new TKnifeStrengthenUI(this);
         this.FKnifeStrengthen.KnifeLanguage = this.FKnifeLanguage;
         this.FKnifeStrengthen.KnifeOfkillSoulDatas = this.FKnifeOfkillSoulDatas;
         this.FKnifeStrengthen.OpenStrengthenBox = this.OpenStrengthenBox;
         this.FKnifeStrengthen.OpenAllPhase = this.OpenAllPhase;
         this.FKnifeStrengthen.ChangeKnife = this.ChangeKnife;
         this.FKnifeStrengthen.UIDispath(this.FMainUI["MC_Strengthen"]);
         this.FKnifeStrengthen.Visible = false;
         this.FCurrentShowKnifeID = 0;
         this.Update();
         TutorialSendComponent(CONST_FRESHGUIDE.MCID_KnifeOfKillSoulView,this);
         TutorialSendArrowParent(CONST_FRESHGUIDE.MCID_KnifeOfKillSoulView,FParent);
         this.FHint = new THint();
         super.ResourcesPerform_UIDispatch();
      }
      
      protected function UILocation_Perform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TSingleKnife = null;
         super.ResourcesPerform_UILocations();
         _loc1_ = 0;
         while(_loc1_ < CONST_KNIFEOFKILLSOUL.KNIFEONEPAGENUM)
         {
            _loc2_ = this.FKnifes[_loc1_];
            _loc2_.UILocation();
            _loc1_++;
         }
         this.BtnUILocation();
         this.FWindowTrain.UILocation();
         this.FWindowTrain.x = (CONST_COMMON.STAGE_Width - TProcessorWindowTrain.WindowTrainWidth) / 2;
         this.FWindowTrain.y = (CONST_COMMON.STAGE_Height - TProcessorWindowTrain.WindowTrainHeight) / 2;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_KNIFEOFKILLSOUL.KNIFE_RESOURCEID);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TSingleKnife = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MainBoard") as MovieClip;
         addChild(this.FMainUI);
         _loc1_ = 0;
         while(_loc1_ < CONST_KNIFEOFKILLSOUL.KNIFEONEPAGENUM)
         {
            _loc2_ = new TSingleKnife(this);
            _loc2_.OnEffectText = this.ProcessorsOnEffectText;
            _loc2_.OnClickCommonBtn = this.ClickCommonBtn;
            this.FKnifesUI.push(this.FMainUI["Knife" + (_loc1_ + 1)]);
            _loc2_.UIDispatch(this.FMainUI["Knife" + (_loc1_ + 1)]);
            this.FKnifes.push(_loc2_);
            _loc1_++;
         }
         this.BtnUIDispatch(this.FMainUI);
         this.FWindowTrain.UIDispath();
         this.FCurrentShowKnifeID = 0;
         this.FCurrentKnifeOfkillSoulDatas = this.FKnifeDatasByType[0];
         this.SetupPage(this.FCurrentKnifeOfkillSoulDatas.Count,0);
         this.Update();
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TSingleKnife = null;
         super.ResourcesPerform_UILocations();
         _loc1_ = 0;
         while(_loc1_ < CONST_KNIFEOFKILLSOUL.KNIFEONEPAGENUM)
         {
            _loc2_ = this.FKnifes[_loc1_];
            _loc2_.UILocation();
            _loc1_++;
         }
         this.BtnUILocation();
         this.FWindowTrain.UILocation();
         this.FWindowTrain.x = (CONST_COMMON.STAGE_Width - this.FWindowTrain.width) / 2;
         this.FWindowTrain.y = (CONST_COMMON.STAGE_Height - this.FWindowTrain.height) / 2;
      }
      
      protected function BtnUIDispatch(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         this.FUIPage = new TUIPage(this);
         this.FUIPage.ButtonPrevious.Substrate = param1["PageArrowLeft"];
         this.FUIPage.ButtonNext.Substrate = param1["PageArrowRight"];
         this.FUIPage.LabelPage = param1["PageNum"];
         this.FUIPage.PageSize = CONST_KNIFEOFKILLSOUL.KNIFEONEPAGENUM;
         this.FUIPage.OnChangePage = this.SwitchPage;
         this.FUIPage.Init();
         this.FUITab = new TUITab(this);
         _loc2_ = 0;
         while(_loc2_ < CONST_KNIFEOFKILLSOUL.KNIFETABNUM)
         {
            this.FUITab.SetTabByIndex(param1["tab" + _loc2_],_loc2_);
            _loc2_++;
         }
         this.FUITab.OnSwitch = this.SwitchTab;
         this.FUITab.Init();
         this.FUITab.OnOver = this.OnTabOver;
         this.FUITab.OnOut = this.OnTabOut;
         this.FBtnClose = param1["MainUI"]["BtnClose"];
         this.FBtnHelp = param1["MainUI"]["BtnHelp"];
      }
      
      protected function BtnUILocation() : void
      {
         this.FBtnClose.addEventListener(MouseEvent.CLICK,this.OnCloseBtnClick);
      }
      
      protected function ShowKnifeByStartID(param1:int, param2:TKnifeOfkillSoulDatas) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TSingleKnife = null;
         _loc3_ = 0;
         while(_loc3_ < CONST_KNIFEOFKILLSOUL.KNIFEONEPAGENUM)
         {
            _loc5_ = this.FKnifes[_loc3_];
            _loc4_ = param1 + _loc3_;
            if(_loc4_ > param2.Count - 1)
            {
               this.FKnifesUI[_loc3_].visible = false;
            }
            else
            {
               this.FKnifesUI[_loc3_].visible = true;
               _loc5_.KnifeData = param2.GetByIndex(_loc4_);
               _loc5_.Update();
            }
            _loc3_++;
         }
      }
      
      protected function SetupPage(param1:int, param2:int) : void
      {
         this.FUIPage.TotalQuantity = param1;
         this.FUIPage.Update();
         this.FUIPage.PageIndex = param2;
      }
      
      protected function DispatchKnifeDataByType() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TKnifeOfKillSoulData = null;
         var _loc4_:TKnifeOfkillSoulDatas = null;
         _loc2_ = -1;
         _loc1_ = 0;
         while(_loc1_ < this.FKnifeOfkillSoulDatas.Count)
         {
            _loc3_ = this.FKnifeOfkillSoulDatas.GetByIndex(_loc1_);
            if(_loc2_ != _loc3_.Type)
            {
               _loc2_ = _loc3_.Type;
               _loc4_ = new TKnifeOfkillSoulDatas();
               this.FKnifeDatasByType.push(_loc4_);
            }
            _loc4_.Add(_loc3_);
            _loc1_++;
         }
      }
      
      protected function CompareMethod(param1:TKnifeOfKillSoulData, param2:TKnifeOfKillSoulData) : int
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(param1.ID == SLogicsCore.Character.KnifeSoul.ChangedID)
         {
            _loc3_ = 4294967295;
         }
         else if(param1.CurrentState == CONST_KNIFEOFKILLSOUL.KNIFESTATE_UNLOCK)
         {
            _loc3_ = param1.ID * 100;
         }
         else if(param1.CurrentState == CONST_KNIFEOFKILLSOUL.KNIFESTATE_WaitUnlock)
         {
            _loc3_ = param1.ID * 10;
         }
         else
         {
            _loc3_ = -param1.ID;
         }
         if(param2.ID == SLogicsCore.Character.KnifeSoul.ChangedID)
         {
            _loc4_ = 4294967295;
         }
         else if(param2.CurrentState == CONST_KNIFEOFKILLSOUL.KNIFESTATE_UNLOCK)
         {
            _loc4_ = param2.ID * 100;
         }
         else if(param2.CurrentState == CONST_KNIFEOFKILLSOUL.KNIFESTATE_WaitUnlock)
         {
            _loc4_ = param2.ID * 10;
         }
         else
         {
            _loc4_ = -param2.ID;
         }
         if(_loc3_ > _loc4_)
         {
            return -1;
         }
         return 1;
      }
      
      protected function CheckKnifeState() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FKnifeOfkillSoulDatas.Count)
         {
            this.CheckSingleKnifeState(this.FKnifeOfkillSoulDatas.GetByIndex(_loc1_));
            _loc1_++;
         }
      }
      
      protected function CheckSingleKnifeState(param1:TKnifeOfKillSoulData) : void
      {
         var _loc2_:TInventory = null;
         if(param1.CurrentState == CONST_KNIFEOFKILLSOUL.KNIFESTATE_UNLOCK)
         {
            return;
         }
         _loc2_ = SLogicsCore.Character.Appliances.GetInventoryByTempletID(param1.HandBook);
         if(_loc2_ == null)
         {
            param1.CurrentState = CONST_KNIFEOFKILLSOUL.KNIFESTATE_LackHandBook;
         }
         else if(_loc2_ != null)
         {
            param1.CurrentState = CONST_KNIFEOFKILLSOUL.KNIFESTATE_WaitUnlock;
         }
         else if(SLogicsCore.Character.KnifeSoul.Level < param1.NeedKnifeSoulLevel)
         {
            param1.CurrentState = CONST_KNIFEOFKILLSOUL.KNIFESTATE_KnifeSoulUnReach;
         }
      }
      
      protected function OnTabOver(param1:Object, param2:uint, param3:Boolean) : void
      {
         if(param2 == this.TabType_Strengthen && !param3)
         {
            this.FHint.Caption = this.FKnifeLanguage.GetStr8(this.FStrengthenUnlockLevel);
            SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
         }
      }
      
      protected function OnTabOut(param1:Object, param2:uint, param3:Boolean) : void
      {
         if(param2 == this.TabType_Strengthen && !param3)
         {
            SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
         }
      }
      
      protected function WindowTrainClose() : void
      {
         this.FWindowTrain.visible = false;
         this.FMainUI.visible = true;
         this.ShowKnifeByStartID(this.FCurrentShowKnifeID,this.FCurrentKnifeOfkillSoulDatas);
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_KnifeOfKillSoulTrainWindowClose);
      }
      
      protected function ClickCommonBtn(param1:TKnifeOfKillSoulData) : void
      {
         this.FWindowTrain.KnifeData = param1;
         this.FWindowTrain.Update();
         this.FWindowTrain.visible = true;
         this.FMainUI.visible = false;
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_KnifeOfKillSoulTrainWindowOpen);
      }
      
      protected function SwitchTab(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TPacket = null;
         _loc3_ = param1 as int;
         if(_loc3_ == this.TabType_Strengthen)
         {
            this.SwitchStrengthen();
            return;
         }
         if(_loc3_ == 0)
         {
            this.FCurrentKnifeOfkillSoulDatas = this.FKnifeOfkillSoulDatas;
            this.FCurrentKnifeOfkillSoulDatas.Sort(this.CompareMethod);
         }
         else
         {
            this.FCurrentKnifeOfkillSoulDatas = this.FKnifeDatasByType[_loc3_ - 1];
         }
         this.SetupPage(this.FCurrentKnifeOfkillSoulDatas.Count,0);
         this.FCurrentShowKnifeID = 0;
         this.ShowKnifeByStartID(this.FCurrentShowKnifeID,this.FCurrentKnifeOfkillSoulDatas);
         if(this.FKnifeStrengthen != null)
         {
            this.FKnifeStrengthen.Visible = false;
         }
      }
      
      protected function SwitchPage(param1:Object, param2:int) : void
      {
         var _loc3_:int = 0;
         _loc3_ = param2;
         this.FCurrentShowKnifeID = _loc3_ * CONST_KNIFEOFKILLSOUL.KNIFEONEPAGENUM;
         this.ShowKnifeByStartID(this.FCurrentShowKnifeID,this.FCurrentKnifeOfkillSoulDatas);
      }
      
      protected function OnCloseBtnClick(param1:MouseEvent = null) : void
      {
         if(this.FTriggerFreshGuide)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_30));
            return;
         }
         ProcessorWindowClose();
         this.FCurrentKnifeOfkillSoulDatas = null;
         if(this.FIfGoBackToDeployment)
         {
            SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_TacticalDeployment);
         }
         this.FIfGoBackToDeployment = false;
      }
      
      protected function OnChangeShape(param1:Object) : void
      {
         this.OnCloseBtnClick();
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_TacticalDeployment);
      }
      
      protected function WindowTrainLinkTextClick(param1:Object) : void
      {
         this.OnCloseBtnClick();
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_TreasureMap);
      }
      
      protected function ProcessorsOnEffectText(param1:Object, param2:String, param3:TEffectTextParameters = null, param4:TEffectCoordinateParameters = null) : void
      {
         EffectGenerateText(param2,param3,param4);
      }
      
      protected function OpenStrengthenBox(param1:TKnifeStrengthenAdd, param2:uint, param3:uint) : void
      {
         this.FKnifeStrengthenBox.SetData(param1,param2,param3);
         this.FKnifeStrengthenBox.Visible = true;
      }
      
      protected function OpenAllPhase(param1:TKnifeOfKillSoulData) : void
      {
         this.FKnifeStrengthenAllPhase.Data = param1;
         this.FKnifeStrengthenAllPhase.Visible = true;
      }
      
      protected function ChangeKnife() : void
      {
         this.FKnifeStrengthenSelect.Visible = true;
      }
      
      protected function OnSelectKnifeStrengthen(param1:TKnifeOfKillSoulData) : void
      {
         this.FKnifeStrengthen.KnifeData = param1;
         this.FKnifeStrengthen.UpdateUI();
      }
      
      public function set KnifeOfkillSoulDatas(param1:TKnifeOfkillSoulDatas) : void
      {
         this.FKnifeOfkillSoulDatas = param1;
         this.FKnifeStrengthenSelect.KnifeOfkillSoulDatas = param1;
         this.CheckKnifeState();
         this.DispatchKnifeDataByType();
      }
      
      public function set HintOnOver(param1:Function) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.FKnifes.length)
         {
            this.FKnifes[_loc2_].HintOnOver = param1;
            _loc2_++;
         }
         this.FWindowTrain.HintOnOver = param1;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.FKnifes.length)
         {
            this.FKnifes[_loc2_].HintOnOut = param1;
            _loc2_++;
         }
         this.FWindowTrain.HintOnOut = param1;
      }
      
      override public function get OnEffectText() : Function
      {
         return super.OnEffectText;
      }
      
      override public function set OnEffectText(param1:Function) : void
      {
         super.OnEffectText = param1;
         this.FWindowTrain.OnEffectText = param1;
      }
      
      public function set IfGoBackToDeployment(param1:Boolean) : void
      {
         this.FIfGoBackToDeployment = param1;
      }
      
      public function set KnifeLanguage(param1:TKnifeLanguage) : void
      {
         this.FKnifeLanguage = param1;
         this.FKnifeStrengthenBox.KnifeLanguage = param1;
      }
      
      public function Update() : void
      {
         this.CheckKnifeState();
         if(this.FCurrentKnifeOfkillSoulDatas == null)
         {
            this.FUITab.SwithTagManual(0);
            this.SwitchTab(0);
         }
         if(this.FMainUI.visible)
         {
            if(this.FCurrentKnifeOfkillSoulDatas == this.FKnifeOfkillSoulDatas)
            {
               this.FCurrentKnifeOfkillSoulDatas.Sort(this.CompareMethod);
               this.SwitchTab(0);
            }
            this.ShowKnifeByStartID(this.FCurrentShowKnifeID,this.FCurrentKnifeOfkillSoulDatas);
         }
         else if(this.FWindowTrain.visible)
         {
            this.FWindowTrain.Update();
         }
         if(SLogicsCore.Character.GetMainLevel() >= this.FStrengthenUnlockLevel)
         {
            this.FUITab.SetTabEnabledByIndex(this.TabType_Strengthen,true);
         }
         else
         {
            this.FUITab.SetTabEnabledByIndex(this.TabType_Strengthen,false,true);
         }
      }
      
      public function UIDispatch() : void
      {
         this.UIDispatch_Perform();
      }
      
      public function UILocation() : void
      {
         this.UILocation_Perform();
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FKnifes.length)
         {
            this.FKnifes[_loc1_].Reset();
            _loc1_++;
         }
         this.FWindowTrain.Reset();
         this.FKnifeStrengthen.Visible = false;
      }
      
      public function SetupForcePromptFreshGuide(param1:Boolean) : void
      {
         this.FTriggerFreshGuide = param1;
      }
      
      public function StrengthenUpdate() : void
      {
         this.FKnifeStrengthen.UpdateUI();
         this.FKnifeStrengthenBox.UpdateUI();
      }
      
      public function SwitchStrengthen() : void
      {
         this.FKnifeStrengthen.Reset();
         this.FKnifeStrengthen.Visible = true;
      }
   }
}

