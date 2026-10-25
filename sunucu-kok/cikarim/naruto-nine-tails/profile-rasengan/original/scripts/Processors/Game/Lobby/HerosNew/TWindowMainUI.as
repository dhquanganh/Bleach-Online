package Processors.Game.Lobby.HerosNew
{
   import Components.Pages.TUIPage;
   import Components.Standard.TUIButton;
   import Components.Standard.TUITab;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.Characters.MainRoleWake.THeroWakeData;
   import Logics.Characters.MainRoleWake.THeroWakeEquipment;
   import Logics.Characters.TCharacter;
   import Logics.Characters.THero;
   import Logics.DatebaseVO.VO.TMilitary;
   import Logics.DatebaseVO.VO.TTeamMemberExpand;
   import Logics.HeroNew.TWakeHeroAttributes;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.HerosNew.HeroWakePopup.THeroWakeInfo;
   import Processors.Game.Lobby.HerosNew.HeroWakePopup.THeroWakeWin;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.HyperLink.SUtilityHyperLink;
   import Processors.Game.Utilities.HyperLink.TUtilityHyperLink;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   
   public class TWindowMainUI extends TProcessorLobbyWindow
   {
      
      protected static const InitSlotNum:int = 5;
      
      protected static const FunctionTabNum:int = 3;
      
      protected static const HeroTabNum:int = 9;
      
      protected static const DecorationShowIDS_Type1:Vector.<int> = Vector.<int>([TWindowDecoration.ElementType_Level,TWindowDecoration.ElementType_ExpBar,TWindowDecoration.ElementType_Star,TWindowDecoration.ElementType_CrashJade,TWindowDecoration.ElementType_FightPower,TWindowDecoration.ElementType_Talismans,TWindowDecoration.ElementType_Profession,TWindowDecoration.ElementType_ChangeSchdule,TWindowDecoration.ElementType_Unlist,TWindowDecoration.ElementType_HeroRent,TWindowDecoration.ElementType_WakeUp,TWindowDecoration.ElementType_RelatedPartner,TWindowDecoration.ElementType_Pet,TWindowDecoration.ElementType_CustomHero]);
      
      protected static const DecorationShowIDS_Type2:Vector.<int> = Vector.<int>([TWindowDecoration.ElementType_Level,TWindowDecoration.ElementType_ExpBar,TWindowDecoration.ElementType_Star,TWindowDecoration.ElementType_CrashJade,TWindowDecoration.ElementType_FightPower,TWindowDecoration.ElementType_Talismans,TWindowDecoration.ElementType_Profession,TWindowDecoration.ElementType_Unlist,TWindowDecoration.ElementType_WakeUp,TWindowDecoration.ElementType_RelatedPartner,TWindowDecoration.ElementType_Pet]);
      
      protected static const DecorationShowIDS_Type3:Vector.<int> = Vector.<int>([TWindowDecoration.ElementType_Level,TWindowDecoration.ElementType_ExpBar,TWindowDecoration.ElementType_Star,TWindowDecoration.ElementType_CrashJade,TWindowDecoration.ElementType_FightPower,TWindowDecoration.ElementType_Talismans,TWindowDecoration.ElementType_Profession,TWindowDecoration.ElementType_ChangeSchdule,TWindowDecoration.ElementType_WakeUp,TWindowDecoration.ElementType_Unlist,TWindowDecoration.ElementType_RelatedPartner,TWindowDecoration.ElementType_Pet]);
      
      protected static const DecorationShowIDS:Vector.<Vector.<int>> = Vector.<Vector.<int>>([DecorationShowIDS_Type1,DecorationShowIDS_Type2,DecorationShowIDS_Type3]);
      
      protected var FWindowAttribute:TWindowAttribute;
      
      protected var FWindowDecoration:TWindowDecoration;
      
      protected var FWindowInventory:TWindowInventory;
      
      protected var FWindowShowHero:TWindowShowHero;
      
      protected var FWakeInfo:THeroWakeInfo;
      
      protected var FHeroWakeWin:THeroWakeWin;
      
      protected var FMainUI:Sprite;
      
      protected var FTabFunction:TUITab;
      
      protected var FCurrentTabFunctionIndex:int;
      
      protected var FTabHero:TUITab;
      
      protected var FCurrentTabHeroIndex:int;
      
      protected var FUIPage:TUIPage;
      
      protected var FCurrentPageIndex:int;
      
      protected var FTF_CurrentNumber:TextField;
      
      protected var FBtn_AddSlot:TUIButton;
      
      protected var FBtnTraven:TUIButton;
      
      protected var FBtnOneKeySwitch:TUIButton;
      
      protected var FBtnClose:TUIButton;
      
      protected var FCharacter:TCharacter;
      
      protected var FOnOneKeySwapOnClick:Function;
      
      protected var FWakeHeroAttributes:TWakeHeroAttributes;
      
      protected var FHeroWakeData:THeroWakeData;
      
      public function TWindowMainUI(param1:TUIComponent)
      {
         super(param1);
         this.FWindowAttribute = new TWindowAttribute(this);
         this.FWindowDecoration = new TWindowDecoration(this);
         this.FWindowInventory = new TWindowInventory(this);
         this.FWindowShowHero = new TWindowShowHero(this);
         this.FCharacter = SLogicsCore.Character;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(Visible)
         {
            this.FWindowInventory.Running();
            this.FWindowAttribute.Running();
            this.FWindowDecoration.Running();
         }
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:Point = null;
         super.ResourcesPerform_UIDispatch();
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_Heros") as Sprite;
         addChild(this.FMainUI);
         this.FTabFunction = new TUITab(this);
         _loc2_ = FunctionTabNum;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTabFunction.SetTabByIndex(this.FMainUI["MC_Tab_" + _loc1_],_loc1_);
            _loc1_++;
         }
         this.FTabFunction.OnSwitch = this.TabFunctionOnSwitch;
         this.FTabFunction.Init();
         this.FTabHero = new TUITab(this);
         _loc2_ = HeroTabNum;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTabHero.SetTabByIndex(this.FMainUI["TF_HeroName_" + _loc1_],_loc1_);
            _loc1_++;
         }
         this.FTabHero.OnSwitch = this.TabHeroOnSwitch;
         this.FTabHero.Init();
         _loc3_ = this.FMainUI["MC_HeroPage"];
         this.FUIPage = new TUIPage(this);
         this.FUIPage.ButtonPrevious.Substrate = _loc3_["MC_PageLeft"];
         this.FUIPage.ButtonNext.Substrate = _loc3_["MC_PageRight"];
         this.FUIPage.LabelPage = _loc3_["TF_Page"];
         this.FUIPage.PageSize = HeroTabNum;
         this.FUIPage.OnChangePage = this.UIPageOnSwitch;
         this.FUIPage.Init();
         this.FBtnTraven = new TUIButton();
         this.FBtnTraven.Substrate = this.FMainUI["MC_Btn_Traven"];
         this.FBtnTraven.OnClick = this.BtnTravenOnClick;
         this.FBtnOneKeySwitch = new TUIButton();
         this.FBtnOneKeySwitch.Substrate = this.FMainUI["MC_Btn_AKeySwap"];
         this.FBtnOneKeySwitch.OnClick = this.BtnOneKeySwitchOnClick;
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainUI["Btn_Close"];
         this.FBtnClose.OnClick = this.BtnCloseOnClick;
         this.FTF_CurrentNumber = this.FMainUI["TF_CurrentNumber"];
         this.FBtn_AddSlot = new TUIButton();
         this.FBtn_AddSlot.Substrate = this.FMainUI["AddSlotNum"];
         this.FBtn_AddSlot.OnClick = this.BtnAddHeroSlotNumClick;
         this.FWakeInfo = new THeroWakeInfo(this);
         this.FWakeInfo.OnClose = this.WakeComposeOnClose;
         this.FWindowAttribute.UIDispatch(this.FMainUI);
         this.FWindowDecoration.UIDispatch(this.FMainUI);
         this.FWindowInventory.UIDispatch(this.FMainUI);
         this.FWindowShowHero.UIDispatch(this.FMainUI);
         this.FWakeInfo.UIDispatch();
         _loc4_ = localToGlobal(new Point());
         this.FHeroWakeWin = new THeroWakeWin(this);
         this.FHeroWakeWin.X = -_loc4_.x;
         this.FHeroWakeWin.Y = -_loc4_.y;
         this.FHeroWakeWin.UIDispatch();
         this.FHeroWakeWin.Visible = false;
         this.FWindowShowHero.WakeUpSlotOnClick = this.WakeComposeOnShow;
         this.FWindowShowHero.HeroSlotOnClick = this.HeroSlotOnClick;
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
         this.FCurrentTabFunctionIndex = 0;
         this.FCurrentTabHeroIndex = 0;
         this.FCurrentPageIndex = 0;
      }
      
      protected function WakeComposeOnShow(param1:int, param2:int, param3:Boolean) : void
      {
         if(param1 == SLogicsCore.Character.MainHero.Identifier)
         {
            return;
         }
         this.FMainUI.mouseChildren = false;
         this.FMainUI.mouseEnabled = false;
         this.FWakeInfo.ShowInfoById(param1,param2,param3);
      }
      
      protected function HeroSlotOnClick(param1:THeroWakeEquipment) : void
      {
         this.FHeroWakeWin.HeroWakeEquipment = param1;
         this.FHeroWakeWin.Visible = true;
      }
      
      protected function WakeComposeOnClose(param1:Object) : void
      {
         this.FMainUI.mouseChildren = true;
         this.FMainUI.mouseEnabled = true;
      }
      
      protected function RenderUI() : void
      {
         var _loc1_:THero = null;
         _loc1_ = this.GetCurrentSelectHero();
         this.FWindowAttribute.SwitchAttribute(_loc1_,this.GetShowType(),this.FWakeHeroAttributes);
         this.FWindowDecoration.SwitchDecoration(_loc1_,DecorationShowIDS[this.FCurrentTabFunctionIndex]);
         this.FWindowInventory.SwitchInventory(_loc1_,this.GetShowType());
         this.FWindowShowHero.SwitchHero(_loc1_,this.GetShowType());
         this.RenderHeroTabs();
         this.RenderHeroSlotNum();
      }
      
      protected function UpdateUI() : void
      {
         this.FWindowAttribute.Update();
         this.FWindowDecoration.Update();
         this.FWindowInventory.Update();
         this.FWindowShowHero.Update();
         this.FWakeInfo.Update();
         this.FHeroWakeWin.UpdateUI();
         this.RenderHeroTabs();
         this.RenderHeroSlotNum();
      }
      
      protected function RenderHeroTabs() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:THero = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         _loc1_ = this.FCharacter.Heros.Count;
         this.FUIPage.SetupPage(_loc1_,this.FCurrentPageIndex);
         _loc3_ = this.FCurrentPageIndex * HeroTabNum;
         _loc4_ = Math.min(_loc3_ + HeroTabNum,this.FCharacter.Heros.Count);
         _loc8_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Rebirth_19);
         _loc2_ = _loc3_;
         while(_loc2_ < _loc4_)
         {
            _loc6_ = this.FCharacter.Heros.GetHeroByIndex(_loc2_);
            if(_loc6_.RebirthNum > 0)
            {
               this.FTabHero.SetTabCaptionByIndex(TUtilityString.Format(_loc8_,_loc6_.Name,_loc6_.RebirthNum),_loc5_,CONST_COMMON.QUALITYCOLOR_INDEX[_loc6_.Quality + TUtilityLobby.GetConfigValue(60104009)[_loc6_.AddQuality - 1 < 0 ? 0 : _loc6_.AddQuality - 1]]);
            }
            else
            {
               this.FTabHero.SetTabCaptionByIndex(_loc6_.Name,_loc5_,CONST_COMMON.QUALITYCOLOR_INDEX[_loc6_.Quality + TUtilityLobby.GetConfigValue(60104009)[_loc6_.AddQuality - 1 < 0 ? 0 : _loc6_.AddQuality - 1]]);
            }
            this.FTabHero.SetTabShowByIndex(_loc5_);
            _loc2_++;
            _loc5_++;
         }
         _loc2_ = _loc5_;
         while(_loc2_ < HeroTabNum)
         {
            this.FTabHero.SetTabHideByIndex(_loc2_);
            _loc2_++;
         }
      }
      
      protected function RenderHeroSlotNum() : void
      {
         var _loc1_:TMilitary = null;
         var _loc2_:int = 0;
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Military,this.FCharacter.MilitaryRank) as TMilitary;
         _loc2_ = _loc1_ == null ? InitSlotNum : _loc1_.MaxHeroNum;
         _loc2_ += SLogicsCore.Character.HeroAddSlotNum;
         this.FTF_CurrentNumber.text = TUtilityString.Format(CONST_COMMON.STRING_Capacity,this.FCharacter.Heros.Count,_loc2_);
      }
      
      protected function GetShowType() : int
      {
         return this.FCurrentTabFunctionIndex;
      }
      
      protected function GetCurrentSelectHero() : THero
      {
         var _loc1_:int = 0;
         _loc1_ = this.FCurrentPageIndex * HeroTabNum + this.FCurrentTabHeroIndex;
         return this.FCharacter.Heros.GetHeroByIndex(_loc1_);
      }
      
      protected function AddHeroSlotReq(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Heros_BuyHeroCountReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function TabFunctionOnSwitch(param1:int) : void
      {
         this.FCurrentTabFunctionIndex = param1;
         this.RenderUI();
      }
      
      protected function TabHeroOnSwitch(param1:int) : void
      {
         this.FCurrentTabHeroIndex = param1;
         this.RenderUI();
      }
      
      protected function UIPageOnSwitch(param1:Object, param2:int) : void
      {
         this.FCurrentPageIndex = param2;
         this.FTabHero.SwithTagManual(0);
      }
      
      protected function BtnTravenOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(SLogicsCore.Character.RoleSencePosition != CONST_COMMON.SCENEPOSITION_MAINCITY)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ChatChannel_01));
            return;
         }
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Tavern);
      }
      
      protected function BtnOneKeySwitchOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnOneKeySwapOnClick != null)
         {
            this.FOnOneKeySwapOnClick(this);
         }
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
         Visible = false;
      }
      
      protected function BtnAddHeroSlotNumClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:TTeamMemberExpand = null;
         var _loc5_:String = null;
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_TeamMemberExpand,SLogicsCore.Character.HeroAddSlotNum + 1) as TTeamMemberExpand;
         if(_loc4_ == null)
         {
            if(FOnEffectText != null)
            {
               _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_34);
               SToolReward.ShowMessage(_loc5_);
            }
            return;
         }
         if(!SLogicsCore.Character.VipData.TeamerExpand)
         {
            _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_35);
            _loc5_ = TUtilityString.Format(_loc5_,SLogicsCore.Character.VipData.VipOpenLevel_TeamerExpand);
            SToolReward.ShowMessage(_loc5_);
            return;
         }
         _loc3_ = uint(_loc4_.Cost);
         _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_36);
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(_loc5_,_loc3_);
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.AddHeroSlotReq;
      }
      
      public function set OnUseApplianceNotify(param1:Function) : void
      {
         this.FWindowInventory.OnUseApplianceNotify = param1;
      }
      
      public function set OnChangeSkillReq(param1:Function) : void
      {
         this.FWindowAttribute.OnChangeSkillReq = param1;
      }
      
      public function set OnOneKeySwapOnClick(param1:Function) : void
      {
         this.FOnOneKeySwapOnClick = param1;
      }
      
      public function set WakeHeroAttributes(param1:TWakeHeroAttributes) : void
      {
         this.FWakeHeroAttributes = param1;
         this.FWindowDecoration.WakeAttributes = this.FWakeHeroAttributes;
      }
      
      public function set OpenRenewOnClick(param1:Function) : void
      {
         this.FWindowDecoration.OpenRenewOnClick = param1;
      }
      
      public function set HeroWakeData(param1:THeroWakeData) : void
      {
         this.FHeroWakeData = param1;
         this.FWindowShowHero.HeroWakeData = param1;
         this.FWindowAttribute.HeroWakeData = param1;
      }
      
      public function Reset() : void
      {
         this.FCurrentTabFunctionIndex = 0;
         this.FCurrentTabHeroIndex = 0;
         this.FCurrentPageIndex = 0;
         this.FTabHero.SwithTagManual(0);
         this.FWindowInventory.Reset();
         this.FWindowAttribute.Reset();
      }
      
      public function Show() : void
      {
         this.Visible = true;
         this.FTabFunction.SwithTagManual(0);
         this.RenderUI();
      }
      
      public function Update() : void
      {
         this.UpdateUI();
      }
      
      public function BtnComposeAllUpdate(param1:int) : void
      {
         if(this.FWakeInfo.Visible)
         {
            this.FWakeInfo.BtnComposeEnable = this.FWindowShowHero.CanCompose(param1);
         }
      }
      
      public function UnlistHeroNotify() : void
      {
         this.Reset();
         this.Show();
      }
      
      public function UpdateOrganizationData(param1:Object, param2:Boolean = true) : void
      {
         if(this.FWakeInfo == null)
         {
            return;
         }
         if(!Visible)
         {
            return;
         }
         this.FWakeInfo.UpdateOrganizationData(param1,param2);
      }
   }
}

