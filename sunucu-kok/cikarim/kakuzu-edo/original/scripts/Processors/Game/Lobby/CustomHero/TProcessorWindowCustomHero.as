package Processors.Game.Lobby.CustomHero
{
   import Components.Pages.TUIPage;
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Components.Standard.TUITab;
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Foundation.Common.THint;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Foundation.Utilities.TUtilityTexture;
   import Logics.Characters.TCharacter;
   import Logics.Characters.THero;
   import Logics.Characters.THeros;
   import Logics.CustomHero.TCurHero;
   import Logics.CustomHero.TCustomHero;
   import Logics.CustomHero.TCustomHeroExp;
   import Logics.CustomHero.TCustomHeroInfo;
   import Logics.DatebaseVO.VO.TBaseHero;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.DatebaseVO.VO.TSkillConfig;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Logics.Map.TMoudleInfor;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudle;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_CONFIGVALUE;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_HEROS;
   import Resources.Constants.CONST_MAP;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.ByteArray;
   
   public class TProcessorWindowCustomHero extends TProcessorLobbyWindow
   {
      
      protected static const CAPACITY_TF_HerosName:uint = 13;
      
      protected static const CAPACITY_POWERS:uint = 4;
      
      protected static const QUALITYCOLOR_INDEX:Vector.<uint> = CONST_COMMON.QUALITYCOLOR_INDEX;
      
      protected static const EXPDATABASE:uint = 14500000;
      
      protected static const PROGERSSMAX:uint = 236;
      
      protected var FMainUI:MovieClip;
      
      protected var FCloseBtn:TUIButton;
      
      protected var FTipBtn:TUIButton;
      
      protected var FCurTipBtn:TUIButton;
      
      protected var FUITabHeros:TUITab;
      
      protected var FCharacter:TCharacter;
      
      protected var FPageHeroIndex:int;
      
      protected var FSpriteMoudle:TSceneSpriteMoudle;
      
      protected var FMoudleMountPoint:Sprite;
      
      protected var FQureyMoudleInfor:TMoudleInfor;
      
      protected var FHint:THint;
      
      protected var FProgressText:TextField;
      
      protected var FPregressSP:Sprite;
      
      protected var FHeroName:TextField;
      
      protected var FMC_HeroPage:MovieClip;
      
      protected var FUIPageHero:TUIPage;
      
      protected var FTabHeroIndex:int;
      
      protected var FManual:Boolean;
      
      protected var FBaseHeros:Vector.<TBaseHero>;
      
      protected var FHeroGrowths:Vector.<uint>;
      
      protected var FHeroSkills:Vector.<uint>;
      
      protected var FTF_Growths:Vector.<TextField>;
      
      protected var FTF_GrowthsRight:Vector.<Sprite>;
      
      protected var FCurHeroConfig:TCustomHeroInfo;
      
      protected var FCurHeroInfo:TCustomHero;
      
      protected var FCurHeroTipInfo:TCurHero;
      
      protected var FHerosBin:Vector.<TCustomHero>;
      
      protected var FBtn_Promote:TUIButton;
      
      protected var FBtn_Active:TUIButton;
      
      protected var FBtn_SkillOpen:TUIButton;
      
      protected var FBtn_SkillClose:TUIButton;
      
      protected var NEEDITEMID:uint;
      
      public function TProcessorWindowCustomHero(param1:TUIComponent)
      {
         super(param1);
         this.FCharacter = SLogicsCore.Character;
         this.FQureyMoudleInfor = new TMoudleInfor();
         this.FHint = new THint();
         this.FCurHeroInfo = new TCustomHero();
         this.FCurHeroTipInfo = new TCurHero();
         this.FHerosBin = new Vector.<TCustomHero>();
         this.FBaseHeros = new Vector.<TBaseHero>();
         this.FTF_Growths = new Vector.<TextField>(CAPACITY_POWERS);
         this.FTF_GrowthsRight = new Vector.<Sprite>(CAPACITY_POWERS);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:MovieClip = null;
         var _loc5_:TUISlot = null;
         var _loc6_:BitmapData = null;
         var _loc7_:TextField = null;
         var _loc8_:MovieClip = null;
         var _loc9_:TextField = null;
         var _loc10_:MovieClip = null;
         var _loc11_:MovieClip = null;
         var _loc12_:TBounds = null;
         var _loc13_:TCoordinate = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_CustomHero") as MovieClip;
         addChild(this.FMainUI);
         this.FCloseBtn = new TUIButton();
         this.FCloseBtn.Substrate = this.FMainUI.Btn_Close;
         this.FCloseBtn.OnClick = this.OnCloseBtnClick;
         this.FTipBtn = new TUIButton();
         this.FTipBtn.Substrate = this.FMainUI["MC_Main"]["MC_Mon"]["Btn_Tip"];
         this.FTipBtn.OnMove = this.OnTipBtnMove;
         this.FTipBtn.OnOut = this.OnTipBtnOut;
         this.FCurTipBtn = new TUIButton();
         this.FCurTipBtn.Substrate = this.FMainUI["MC_Main"]["MCRent"]["Btn_CurTip"];
         this.FCurTipBtn.OnMove = this.OnCurTipBtnMove;
         this.FCurTipBtn.OnOut = this.OnCurTipBtnOut;
         this.FUITabHeros = new TUITab(this);
         _loc2_ = int(CAPACITY_TF_HerosName);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FMainUI[CONST_HEROS.RESOURCE_Link_TF_HerosName + _loc1_];
            (_loc4_.getChildAt(1) as TextField).mouseEnabled = false;
            this.FUITabHeros.SetTabByIndex(_loc4_,_loc1_);
            this.FUITabHeros.SetTabCaptionByIndex("",_loc1_);
            _loc1_++;
         }
         this.FUITabHeros.OnSwitch = this.TabHerosOnSwitch;
         this.FUITabHeros.Init();
         this.FMoudleMountPoint = this.FMainUI["MC_Main"]["MC_Mon"]["MC_MountPoint"];
         this.FMainUI["MC_Main"].mouseEnabled = false;
         this.FMainUI["MC_Main"]["MC_Mon"].mouseEnabled = false;
         this.FMoudleMountPoint.mouseEnabled = false;
         this.FMoudleMountPoint.mouseChildren = false;
         this.FSpriteMoudle = new TSceneSpriteMoudle();
         this.FMoudleMountPoint.addChild(this.FSpriteMoudle);
         this.FProgressText = this.FMainUI["MC_Main"]["MCRent"]["TF_ProgressText"];
         this.FPregressSP = this.FMainUI["MC_Main"]["MCRent"]["MC_GoldBar"];
         this.FHeroName = this.FMainUI["MC_Main"]["MC_Mon"]["TF_Name"];
         this.FMC_HeroPage = this.FMainUI[CONST_HEROS.RESOURCE_Link_MC_HeroPage];
         this.FUIPageHero = new TUIPage(this);
         _loc8_ = this.FMC_HeroPage[CONST_HEROS.RESOURCE_Link_MC_PageLeft];
         this.FUIPageHero.ButtonPrevious.Substrate = _loc8_;
         _loc8_ = this.FMC_HeroPage[CONST_HEROS.RESOURCE_Link_MC_PageRight];
         this.FUIPageHero.ButtonNext.Substrate = _loc8_;
         _loc9_ = this.FMC_HeroPage[CONST_HEROS.RESOURCE_Link_TF_Page];
         this.FUIPageHero.LabelPage = _loc9_;
         _loc9_.text = "0/0";
         this.FUIPageHero.PageSize = CAPACITY_TF_HerosName;
         this.FUIPageHero.Init();
         this.FUIPageHero.OnChangePage = this.PageHeroOnChange;
         _loc2_ = int(CAPACITY_POWERS);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTF_Growths[_loc1_] = this.FMainUI["MC_Main"]["MC_Growth"]["TF_Text_" + _loc1_];
            this.FTF_GrowthsRight[_loc1_] = this.FMainUI["MC_Main"]["MCRent"]["SP_Text_" + _loc1_];
            _loc1_++;
         }
         this.FBtn_Active = new TUIButton();
         this.FBtn_Active.Substrate = this.FMainUI["MC_Main"]["MCRent"]["Btn_Active"];
         this.FBtn_Active.OnClick = this.OnPromoteBtnClick;
         this.FBtn_Promote = new TUIButton();
         this.FBtn_Promote.Substrate = this.FMainUI["MC_Main"]["MCRent"]["Btn_Promote"];
         this.FBtn_Promote.OnClick = this.OnPromoteBtnClick;
         this.FBtn_SkillOpen = new TUIButton();
         this.FBtn_SkillOpen.Substrate = this.FMainUI["MC_Main"]["MC_Skill"]["Btn_Open"];
         this.FBtn_SkillOpen.OnClick = this.OnSkillOpenBtnClick;
         this.FBtn_SkillClose = new TUIButton();
         this.FBtn_SkillClose.Substrate = this.FMainUI["MC_Main"]["MC_Skill"]["Btn_Close"];
         this.FBtn_SkillClose.OnClick = this.OnSkillCloseBtnClick;
         super.ResourcesPerform_UIDispatch();
      }
      
      protected function OnCurTipBtnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FCurHeroTipInfo);
      }
      
      protected function OnCurTipBtnMove(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FCurHeroTipInfo);
      }
      
      protected function OnPromoteBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CustomHero_UpdateReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeUnsignedInt(this.FCurHeroInfo.Identifier);
         _loc4_.writeUnsignedInt(this.FCurHeroInfo.Level);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function OnSkillOpenBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CustomHero_ChangeSkillReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeUnsignedInt(this.FCurHeroInfo.Identifier);
         _loc4_.writeUnsignedInt(0);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function OnSkillCloseBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CustomHero_ChangeSkillReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeUnsignedInt(this.FCurHeroInfo.Identifier);
         _loc4_.writeUnsignedInt(1);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function PageHeroOnChange(param1:Object, param2:int) : void
      {
         this.FPageHeroIndex = param2;
         this.FTabHeroIndex = 0;
         this.UpdateHeroUIPage();
         this.FManual = true;
         this.UpdateTabs();
         this.FUITabHeros.SwithTagManual(0);
      }
      
      protected function UpdateHeroUIPage() : void
      {
         var _loc1_:TBins = null;
         this.FUIPageHero.TotalQuantity = this.FBaseHeros.length;
         this.FUIPageHero.PageIndex = this.FPageHeroIndex;
         this.FUIPageHero.Update();
      }
      
      protected function OnTipBtnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FCurHeroInfo);
      }
      
      protected function OnTipBtnMove(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FCurHeroInfo);
      }
      
      override protected function ResourcesPerform_UIFinalize() : void
      {
         var _loc1_:TConfigValue = null;
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.CustomHeroItem) as TConfigValue;
         this.NEEDITEMID = _loc1_.Value as uint;
         this.UpdateData();
         this.UpdateTabs();
         this.TabHerosOnSwitch(0);
         super.ResourcesPerform_UIFinalize();
      }
      
      protected function UpdateData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TBins = null;
         var _loc4_:TBaseHero = null;
         var _loc5_:TConfigValue = null;
         this.FBaseHeros.length = 0;
         _loc3_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_CustomHeros) as TBins;
         _loc2_ = _loc3_.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,_loc3_.GetDatebaseByIndex(_loc1_).Identifier) as TBaseHero;
            this.FBaseHeros.push(_loc4_);
            _loc1_++;
         }
         this.SortHeros();
      }
      
      override protected function LogicsPerform() : void
      {
         if(!Visible)
         {
            return;
         }
         this.FSpriteMoudle.UpdateView();
      }
      
      protected function TabHerosOnSwitch(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TBaseHero = null;
         var _loc4_:THero = null;
         _loc2_ = param1 as int;
         _loc3_ = this.FBaseHeros[_loc2_ + CAPACITY_TF_HerosName * this.FPageHeroIndex];
         if(_loc3_.IsMain)
         {
            this.FHeroName.text = this.FCharacter.NickName;
            this.FCurHeroInfo.HeroName = this.FCharacter.NickName;
         }
         else
         {
            this.FHeroName.text = _loc3_.Name;
            this.FCurHeroInfo.HeroName = _loc3_.Name;
         }
         TUtilityTexture.QueryTwoDirectionShowCase(CONST_MAP.DIRECTION_RIGHT,_loc3_.Identifier,this.FQureyMoudleInfor);
         this.FSpriteMoudle.ChangeRoleMoudle(this.FQureyMoudleInfor.TextureID,this.FQureyMoudleInfor.Scalx);
         _loc4_ = SLogicsCore.Character.Heros.GetHeroByIdentifier(_loc3_.Identifier);
         if(_loc4_ != null)
         {
            this.FSpriteMoudle.OpenRebirthEffect(_loc4_.IsMain,_loc4_.RebirthNum);
         }
         else
         {
            this.FSpriteMoudle.OpenRebirthEffect(false,0);
         }
         this.FCurHeroConfig = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_CustomHeros,_loc3_.Identifier) as TCustomHeroInfo;
         this.FCurHeroInfo.HeroCongfig = this.FCurHeroConfig;
         this.FCurHeroInfo.Identifier = _loc3_.Identifier;
         this.UpdateUI();
      }
      
      protected function IsAlive(param1:uint) : Boolean
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc3_ = this.FHerosBin.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(param1 == this.FHerosBin[_loc2_].Identifier)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      protected function GetHeroInfoById(param1:uint) : TCustomHero
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc3_ = this.FHerosBin.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(param1 == this.FHerosBin[_loc2_].Identifier)
            {
               return this.FHerosBin[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      protected function UpdateTabs() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TBaseHero = null;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         _loc3_ = this.FPageHeroIndex;
         _loc4_ = 0;
         _loc5_ = this.FPageHeroIndex * CAPACITY_TF_HerosName;
         _loc6_ = _loc5_ + CAPACITY_TF_HerosName;
         _loc6_ = _loc6_ > this.FBaseHeros.length ? int(this.FBaseHeros.length) : _loc6_;
         _loc1_ = _loc5_;
         while(_loc1_ < _loc6_)
         {
            this.FUITabHeros.SetTabShowByIndex(_loc4_);
            _loc7_ = this.FBaseHeros[_loc1_];
            if(_loc7_.IsMain)
            {
               _loc8_ = QUALITYCOLOR_INDEX[SLogicsCore.Character.MainHero.Quality];
               this.FUITabHeros.SetTabCaptionByIndex(this.FCharacter.NickName,_loc4_,_loc8_);
            }
            else
            {
               _loc8_ = QUALITYCOLOR_INDEX[_loc7_.Quality];
               this.FUITabHeros.SetTabCaptionByIndex(_loc7_.Name,_loc4_,_loc8_);
            }
            _loc4_++;
            _loc1_++;
         }
         _loc1_ = _loc4_;
         while(_loc1_ < CAPACITY_TF_HerosName)
         {
            this.FUITabHeros.SetTabHideByIndex(_loc1_);
            _loc1_++;
         }
      }
      
      protected function UpdateUI() : void
      {
         this.UpdateCurHero();
         this.UpdateHeroUIPage();
         this.UpdateTabs();
         this.UpdateProgress();
         this.UpdateText();
         this.UpdateBtn();
      }
      
      protected function UpdateCurHero() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(this.IsAlive(this.FCurHeroInfo.Identifier))
         {
            this.FCurHeroInfo.Level = this.GetHeroInfoById(this.FCurHeroInfo.Identifier).Level;
            this.FCurHeroInfo.SkillSwitch = this.GetHeroInfoById(this.FCurHeroInfo.Identifier).SkillSwitch;
         }
         else
         {
            this.FCurHeroInfo.Level = 0;
            this.FCurHeroInfo.SkillSwitch = 0;
         }
         _loc1_ = this.FCurHeroInfo.HeroCongfig.ExclusiveLimit.length;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this.FCurHeroInfo.SkillNames[_loc2_] = (SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SkillConfig,this.FCurHeroConfig.ExclusiveSkill[_loc2_]) as TSkillConfig).Desc;
            _loc2_++;
         }
         this.FHeroGrowths = this.FCurHeroConfig.GrowthLimit;
         this.FHeroSkills = this.FCurHeroConfig.ExclusiveLimit;
         this.FCurHeroTipInfo.HeroName = this.FCurHeroInfo.HeroName;
         this.FCurHeroTipInfo.Level = this.FCurHeroInfo.Level;
         this.FCurHeroTipInfo.HeroCongfig = this.FCurHeroConfig;
         this.FCurHeroTipInfo.HeroGrowths = this.FCurHeroConfig.GrowthLimit;
         this.FCurHeroTipInfo.HeroSkills = this.FCurHeroConfig.ExclusiveLimit;
      }
      
      protected function UpdateBtn() : void
      {
         var _loc1_:TInventories = null;
         var _loc2_:TInventory = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:TCustomHeroExp = null;
         _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_CustomHeroExp,EXPDATABASE + this.FCurHeroInfo.Level + 1) as TCustomHeroExp;
         _loc6_ = _loc7_.NeedExp;
         _loc1_ = SLogicsCore.Character.Appliances;
         _loc3_ = uint(_loc1_.Count);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = _loc1_.GetInventoryByIndex(_loc4_);
            if(_loc2_.IDTemplate == this.NEEDITEMID)
            {
               _loc5_ += _loc2_.Quantity;
            }
            _loc4_++;
         }
         this.FBtn_SkillOpen.Enabled = !this.IsNotGet();
         this.FBtn_SkillClose.Enabled = !this.IsNotGet();
         this.FBtn_Promote.Enabled = !this.IsNotGet();
         this.FBtn_Active.Enabled = !this.IsNotGet();
         if(this.FCurHeroInfo.SkillSwitch == 0)
         {
            this.FBtn_SkillOpen.Visible = true;
            this.FBtn_SkillClose.Visible = false;
            this.FMainUI["MC_Main"]["MC_Skill"]["SP_UnActive"].gotoAndStop(2);
         }
         else
         {
            this.FBtn_SkillOpen.Visible = false;
            this.FBtn_SkillClose.Visible = true;
            this.FMainUI["MC_Main"]["MC_Skill"]["SP_UnActive"].gotoAndStop(3);
         }
         this.FBtn_Active.Enabled = _loc5_ >= _loc6_;
         if(this.FCurHeroConfig.ExclusiveLimit.length == 0)
         {
            this.FBtn_SkillOpen.Visible = false;
            this.FBtn_SkillClose.Visible = false;
            this.FMainUI["MC_Main"]["MC_Skill"]["SP_UnActive"].visible = false;
            return;
         }
         this.FMainUI["MC_Main"]["MC_Skill"]["SP_UnActive"].visible = true;
         if(this.FCurHeroInfo.Level < this.FCurHeroConfig.ExclusiveLimit[0])
         {
            this.FBtn_SkillOpen.Enabled = false;
            this.FBtn_SkillClose.Enabled = false;
            this.FMainUI["MC_Main"]["MC_Skill"]["SP_UnActive"].gotoAndStop(1);
         }
         else
         {
            this.FBtn_SkillOpen.Enabled = true;
            this.FBtn_SkillClose.Enabled = true;
         }
         if(this.FCurHeroInfo.Level == 0)
         {
            this.FBtn_Promote.Visible = false;
            this.FBtn_Active.Visible = true;
         }
         else
         {
            this.FBtn_Promote.Visible = true;
            this.FBtn_Active.Visible = false;
         }
      }
      
      protected function ValidGrowthLv() : int
      {
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FHeroGrowths.length);
         _loc1_ = int(_loc2_ - 1);
         while(_loc1_ >= 0)
         {
            if(this.FCurHeroInfo.Level >= this.FHeroGrowths[_loc1_])
            {
               return _loc1_ + 1;
            }
            _loc1_--;
         }
         return 0;
      }
      
      protected function ValidSkillLv() : int
      {
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FHeroSkills.length);
         _loc1_ = int(_loc2_ - 1);
         while(_loc1_ >= 0)
         {
            if(this.FCurHeroInfo.Level >= this.FHeroSkills[_loc1_])
            {
               return _loc1_ + 1;
            }
            _loc1_--;
         }
         return 1;
      }
      
      protected function UpdateText() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:TSkillConfig = null;
         var _loc5_:TBins = null;
         _loc5_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_CustomHeroExp);
         _loc2_ = int(CAPACITY_POWERS);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTF_Growths[_loc1_].text = "+" + Number(this.FCurHeroConfig.Growth[_loc1_] * this.ValidGrowthLv()).toFixed(2) + " (Max " + this.FCurHeroConfig.Growth[_loc1_] * this.FHeroGrowths.length + ")";
            _loc1_++;
         }
         if(this.ValidGrowthLv() >= this.FHeroGrowths.length)
         {
            this.FMainUI["MC_Main"]["MC_Growth"]["TF_Text_Next"].text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Exclusive_PanelText14);
         }
         else
         {
            this.FMainUI["MC_Main"]["MC_Growth"]["TF_Text_Next"].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Exclusive_PanelText12),this.FHeroGrowths[this.ValidGrowthLv()]);
         }
         this.FTF_GrowthsRight[0]["TF_InneLv"].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Exclusive_PanelText03),this.FCurHeroInfo.Level);
         this.FTF_GrowthsRight[1]["TF_InneLv"].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Exclusive_PanelText04),this.FCurHeroInfo.Level);
         this.FTF_GrowthsRight[2]["TF_InneLv"].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Exclusive_PanelText05),this.FCurHeroInfo.Level);
         this.FTF_GrowthsRight[3]["TF_InneLv"].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Exclusive_PanelText06),this.FCurHeroInfo.Level);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FCurHeroInfo.Level > 0)
            {
               this.FTF_GrowthsRight[_loc1_]["TF_Growth"].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(70810015 + _loc1_),this.FCurHeroConfig.BasicNumber[_loc1_] + this.FCurHeroConfig.BasisGrow[_loc1_] * (this.FCurHeroInfo.Level - 1),this.FCurHeroConfig.BasisGrow[_loc1_],this.FCurHeroConfig.BasisGrow[_loc1_] * (_loc5_.Count - 1));
            }
            else
            {
               this.FTF_GrowthsRight[_loc1_]["TF_Growth"].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(70810015 + _loc1_),0,this.FCurHeroConfig.BasisGrow[_loc1_],this.FCurHeroConfig.BasisGrow[_loc1_] * (_loc5_.Count - 1));
            }
            _loc1_++;
         }
         if(this.FHeroSkills.length != 0)
         {
            this.FMainUI["MC_Main"]["MCRent"]["TF_NextLv"].visible = true;
            this.FMainUI["MC_Main"]["MC_Skill"]["TF_Lv1"].visible = true;
            this.FMainUI["MC_Main"]["MC_Skill"]["TF_Lv1_head"].visible = true;
            this.FMainUI["MC_Main"]["MC_Skill"]["TF_Lv1_end"].visible = true;
            if(this.ValidSkillLv() >= this.FHeroSkills.length)
            {
               this.FMainUI["MC_Main"]["MC_Skill"]["TF_Lv1"].visible = false;
               this.FMainUI["MC_Main"]["MC_Skill"]["TF_Lv1_head"].visible = false;
               this.FMainUI["MC_Main"]["MC_Skill"]["TF_Lv1_end"].visible = false;
               this.FMainUI["MC_Main"]["MCRent"]["TF_NextLv_head"].visible = false;
               this.FMainUI["MC_Main"]["MCRent"]["TF_NextLv_end"].visible = false;
               this.FMainUI["MC_Main"]["MCRent"]["TF_NextLv"].text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Exclusive_PanelText14);
               (this.FMainUI["MC_Main"]["MCRent"]["TF_NextLv"] as TextField).autoSize = TextFieldAutoSize.CENTER;
            }
            else
            {
               this.FMainUI["MC_Main"]["MCRent"]["TF_NextLv_head"].visible = true;
               this.FMainUI["MC_Main"]["MCRent"]["TF_NextLv_end"].visible = true;
               this.FMainUI["MC_Main"]["MCRent"]["TF_NextLv"].text = "Lv:" + this.FHeroSkills[this.ValidSkillLv() - 1];
            }
            this.FMainUI["MC_Main"]["MC_Skill"]["TF_Lv1"].text = "Lv:" + this.FHeroSkills[this.ValidSkillLv() - 1];
            _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SkillConfig,this.FCurHeroConfig.ExclusiveSkill[this.ValidSkillLv() - 1]) as TSkillConfig;
            this.FMainUI["MC_Main"]["MC_Skill"]["TF_Desc"].text = _loc4_.Desc as String;
         }
         else
         {
            this.FMainUI["MC_Main"]["MCRent"]["TF_NextLv"].visible = false;
            this.FMainUI["MC_Main"]["MCRent"]["TF_NextLv_head"].visible = false;
            this.FMainUI["MC_Main"]["MCRent"]["TF_NextLv_end"].visible = false;
            this.FMainUI["MC_Main"]["MC_Skill"]["TF_Lv1"].visible = false;
            this.FMainUI["MC_Main"]["MC_Skill"]["TF_Lv1_head"].visible = false;
            this.FMainUI["MC_Main"]["MC_Skill"]["TF_Lv1_end"].visible = false;
            this.FMainUI["MC_Main"]["MC_Skill"]["TF_Desc"].text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Exclusive_PanelText15);
         }
         this.FMainUI["MC_Main"]["MC_Skill"]["TF_Lv2"].text = "Lv:" + this.FHeroGrowths[this.ValidGrowthLv() >= this.FHeroGrowths.length ? this.FHeroGrowths.length - 1 : this.ValidGrowthLv()];
         this.FMainUI["MC_Main"]["MC_Mon"]["TF_IsGet"].visible = this.IsNotGet();
         this.FMainUI["MC_Main"]["MCRent"]["TF_CurLv"].text = "Lv:" + this.FCurHeroInfo.Level;
      }
      
      protected function IsNotGet() : Boolean
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc1_ = uint(SLogicsCore.Character.Heros.Count);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            if(this.FCurHeroConfig.Identifier == SLogicsCore.Character.Heros.GetHeroByIndex(_loc2_).Identifier)
            {
               return false;
            }
            _loc2_++;
         }
         return true;
      }
      
      protected function SortHeros() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:* = 0;
         var _loc5_:uint = 0;
         var _loc6_:THeros = null;
         var _loc7_:Vector.<TBaseHero> = null;
         _loc7_ = new Vector.<TBaseHero>();
         _loc6_ = SLogicsCore.Character.Heros;
         _loc1_ = uint(_loc6_.Count);
         _loc3_ = 0;
         while(_loc3_ < _loc1_)
         {
            _loc5_ = _loc6_.GetHeroByIndex(_loc3_).Identifier;
            _loc2_ = this.FBaseHeros.length;
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               if(_loc5_ == this.FBaseHeros[_loc4_].Identifier)
               {
                  _loc7_.push(this.FBaseHeros[_loc4_]);
                  this.FBaseHeros.splice(_loc4_,1);
                  _loc2_ = this.FBaseHeros.length;
               }
               _loc4_++;
            }
            _loc3_++;
         }
         _loc1_ = 5;
         _loc3_ = 0;
         while(_loc3_ < _loc1_)
         {
            this.FBaseHeros.splice(0,1);
            _loc3_++;
         }
         _loc2_ = _loc7_.length;
         _loc4_ = int(_loc2_ - 1);
         while(_loc4_ >= 0)
         {
            this.FBaseHeros.unshift(_loc7_[_loc4_]);
            _loc4_--;
         }
      }
      
      protected function UpdateProgress() : void
      {
         var _loc1_:TInventories = null;
         var _loc2_:TInventory = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:TCustomHeroExp = null;
         _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_CustomHeroExp,EXPDATABASE + this.FCurHeroInfo.Level + 1) as TCustomHeroExp;
         _loc6_ = _loc7_.NeedExp;
         _loc1_ = SLogicsCore.Character.Appliances;
         _loc3_ = uint(_loc1_.Count);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = _loc1_.GetInventoryByIndex(_loc4_);
            if(_loc2_.IDTemplate == this.NEEDITEMID)
            {
               _loc5_ += _loc2_.Quantity;
            }
            _loc4_++;
         }
         this.FProgressText.text = _loc5_.toString() + "/" + _loc6_.toString();
         if(_loc5_ / _loc6_ >= 1)
         {
            this.FPregressSP["MC_GoldBar"].width = PROGERSSMAX;
            return;
         }
         this.FPregressSP["MC_GoldBar"].width = PROGERSSMAX * (_loc5_ / _loc6_);
      }
      
      protected function OnCloseBtnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      public function UpdateWinHerosBin(param1:Vector.<TCustomHero>) : void
      {
         this.FHerosBin = param1;
         this.UpdateData();
         this.UpdateUI();
      }
      
      public function UpdateWinData(param1:uint, param2:int, param3:int) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TCustomHero = null;
         if(param2 == -1)
         {
            _loc4_ = this.FHerosBin.length;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               if(this.FHerosBin[_loc5_].Identifier == param1)
               {
                  this.FHerosBin[_loc5_].SkillSwitch = param3;
               }
               _loc5_++;
            }
         }
         else if(this.IsAlive(param1))
         {
            _loc4_ = this.FHerosBin.length;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               if(this.FHerosBin[_loc5_].Identifier == param1)
               {
                  this.FHerosBin[_loc5_].Level = param2;
               }
               _loc5_++;
            }
            this.UpdateUI();
         }
         else
         {
            _loc4_ = this.FBaseHeros.length;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               if(this.FBaseHeros[_loc5_].Identifier == param1)
               {
                  _loc6_ = new TCustomHero();
                  _loc6_.Identifier = param1;
                  _loc6_.Level = param2;
                  _loc6_.SkillSwitch = 0;
                  this.FHerosBin.push(_loc6_);
               }
               _loc5_++;
            }
            this.UpdateUI();
         }
         this.UpdateUI();
      }
   }
}

