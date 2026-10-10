package Processors.Game.Lobby.CrashJade
{
   import Components.Pages.*;
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Common.THint;
   import Foundation.Network.*;
   import Foundation.Queries.*;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.CrashJade.*;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.Inventories.*;
   import Logics.Map.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Common.Map.SceneSprite.*;
   import Processors.Game.Lobby.Jade.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.ByteArray;
   
   public class TProcessorWindowEquipJade extends TProcessorLobbyWindow
   {
      
      protected static const HeroSlotNum:int = 8;
      
      protected static const BackPackSlotNum:int = 30;
      
      protected static const TabNum:int = 7;
      
      protected var FMainUI:Sprite;
      
      protected var FBtnClose:TUIButton;
      
      protected var FHeroSlots:Vector.<TUISlot>;
      
      protected var FHeroSlotDesUI:Vector.<Sprite>;
      
      protected var FHeroSlotDes:Vector.<TextField>;
      
      protected var FTFChipNum:TextField;
      
      protected var FTFJadePellet:TextField;
      
      protected var FQueryModel:TMoudleInfor;
      
      protected var FRoleMoudle:TSceneSpriteMoudle;
      
      protected var FHeroMountPoint:Sprite;
      
      protected var FCurrentShowHero:THero;
      
      protected var FJadePowerSwitch:TUIButton;
      
      protected var FJadePowerSwitchInfor:TextField;
      
      protected var FJadePowerPanle:Sprite;
      
      protected var FJadePowerInfor:TextField;
      
      protected var FHeroTab:TUITab;
      
      protected var FHeroPage:TUIPage;
      
      protected var FCurrentTabIndex:int;
      
      protected var FCurrentHeroPageIndex:int;
      
      protected var FCurrentSelectSlot:TUISlot;
      
      protected var FCurrentSelectJade:TCrashJade;
      
      protected var FIfPromot:Boolean;
      
      protected var FCurrentSwallowRes:TCrashJade;
      
      protected var FCurrentSwallowDes:TCrashJade;
      
      protected var FBackPackSlots:Vector.<TUISlot>;
      
      protected var FBackPackSlotLocks:Vector.<TUIButton>;
      
      protected var FBackPackFunction:Vector.<Sprite>;
      
      protected var FBackPackPage:TUIPage;
      
      protected var FCurrentBackPackPageIndex:int;
      
      protected var FBackPackInitNum:int;
      
      protected var FBackPackMaxSlotNum:int;
      
      protected var FUnlockSlotPrice:Vector.<int>;
      
      protected var FUIImage:TUIImage;
      
      protected var FBtnMakeJade:TUIButton;
      
      protected var FBtnJadeChip:TUIButton;
      
      protected var FBtnSwallowPellet:TUIButton;
      
      protected var FBtnSwallowCrashJade:TUIButton;
      
      protected var FHint:THint;
      
      protected var FComposeRate:int;
      
      protected var FLayerMask:Sprite;
      
      protected var FWindowChipCompose:TProcessorWindowCompose;
      
      protected var FWindowSwllowPellet:TProcessorWindowPelletSwallow;
      
      protected var FSwallowPelletLevelLimit:int;
      
      protected var FWindowSwallow:TProcessorWindowSwallow;
      
      protected var FCrashJadeData:TCrashJadeData;
      
      public function TProcessorWindowEquipJade(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!Visible)
         {
            return;
         }
         this.FRoleMoudle.UpdateView();
         this.UpdateHeroSlots();
         this.UpdateBackPackSlots();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:THero = null;
         var _loc2_:int = 0;
         var _loc3_:TUIButton = null;
         var _loc4_:Sprite = null;
         var _loc5_:TUISlot = null;
         var _loc6_:TConfigValue = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("EquipJadeUI") as Sprite;
         addChild(this.FMainUI);
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainUI["btn_close"];
         this.FBtnClose.OnClick = this.BtnCloseOnClick;
         this.FHeroMountPoint = this.FMainUI["MC_HeroPosition"];
         _loc1_ = SLogicsCore.Character.GetMainHero();
         this.FJadePowerPanle = this.FMainUI["JadePowerPanle"];
         this.FJadePowerPanle.visible = false;
         this.FJadePowerInfor = this.FJadePowerPanle["Lable"];
         this.FJadePowerSwitch = new TUIButton();
         this.FJadePowerSwitch.Substrate = this.FMainUI["Btn_ViewReward"];
         this.FJadePowerSwitch.OnClick = this.BtnJadePowerSwithOnClick;
         this.FJadePowerSwitchInfor = this.FMainUI["Btn_ViewReward"]["Infor"];
         this.FRoleMoudle = new TSceneSpriteMoudle();
         this.FRoleMoudle.RoleTempleteID = _loc1_.Identifier;
         this.FHeroMountPoint.addChild(this.FRoleMoudle);
         this.FQueryModel = new TMoudleInfor();
         this.FHeroSlots = new Vector.<TUISlot>();
         this.FHeroSlotDes = new Vector.<TextField>();
         this.FHeroSlotDesUI = new Vector.<Sprite>();
         _loc2_ = 0;
         while(_loc2_ < HeroSlotNum)
         {
            _loc4_ = this.FMainUI["HeroSlot_" + _loc2_];
            _loc5_ = new TUISlot(this);
            _loc5_.Resource = _loc4_;
            _loc5_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc5_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            _loc5_.OnClick = this.SlotOnClick;
            _loc5_.DraggingEnabled = true;
            _loc5_.DraggingActiveQuery = true;
            _loc5_.OnDragBegin = this.SlotsOnDragBegin;
            _loc5_.OnDragQuery = this.SlotsOnDragQuery;
            _loc5_.OnDragDrop = this.SlotsOnDragDrop;
            _loc5_.OnDragEnd = this.SlotsOnDragEnd;
            _loc5_.IsSelected = false;
            _loc5_.OnQueryEdgeColor = this.SlotsOnQueryEdgeColor;
            _loc5_.Tag = _loc2_ + 1;
            TJadeCommon.InitSlot(_loc5_);
            _loc5_.Init();
            this.FHeroSlots.push(_loc5_);
            _loc4_["SlotFunction"].visible = false;
            this.FHeroSlotDesUI.push(_loc4_["SlotDes"]);
            this.FHeroSlotDes.push(_loc4_["SlotDes"]["Lable"]);
            _loc2_++;
         }
         this.FTFChipNum = this.FMainUI["ChipNum"];
         this.FTFJadePellet = this.FMainUI["JadePellet"];
         this.FHeroTab = new TUITab(this);
         _loc2_ = 0;
         while(_loc2_ < TabNum)
         {
            this.FHeroTab.SetTabByIndex(this.FMainUI["TF_HeroName_" + _loc2_],_loc2_);
            _loc2_++;
         }
         this.FHeroTab.OnSwitch = this.TabOnSwitch;
         this.FHeroTab.Init();
         _loc4_ = this.FMainUI["MC_HeroPage"];
         this.FHeroPage = new TUIPage(this);
         this.FHeroPage.ButtonPrevious.Substrate = _loc4_["MC_PageLeft"];
         this.FHeroPage.ButtonNext.Substrate = _loc4_["MC_PageRight"];
         this.FHeroPage.LabelPage = _loc4_["TF_Page"];
         this.FHeroPage.PageSize = TabNum;
         this.FHeroPage.OnChangePage = this.HeroPageOnChange;
         this.FHeroPage.Init();
         this.FBackPackSlots = new Vector.<TUISlot>();
         this.FBackPackSlotLocks = new Vector.<TUIButton>();
         this.FBackPackFunction = new Vector.<Sprite>();
         this.FBackPackPage = new TUIPage(this);
         _loc2_ = 0;
         while(_loc2_ < BackPackSlotNum)
         {
            _loc4_ = this.FMainUI["PackSlot_" + _loc2_];
            _loc5_ = new TUISlot(this);
            _loc5_.Resource = _loc4_;
            _loc5_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc5_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            _loc5_.OnClick = this.SlotOnClick;
            _loc5_.DraggingEnabled = true;
            _loc5_.DraggingActiveQuery = true;
            _loc5_.OnDragBegin = this.SlotsOnDragBegin;
            _loc5_.OnDragQuery = this.SlotsOnDragQuery;
            _loc5_.OnDragDrop = this.SlotsOnDragDrop;
            _loc5_.OnDragEnd = this.SlotsOnDragEnd;
            _loc5_.IsSelected = false;
            _loc5_.OnQueryEdgeColor = this.SlotsOnQueryEdgeColor;
            TJadeCommon.InitSlot(_loc5_);
            _loc5_.Init();
            this.FBackPackSlots.push(_loc5_);
            _loc4_["SlotDes"].visible = false;
            this.FBackPackFunction.push(_loc4_["SlotFunction"]);
            _loc3_ = new TUIButton();
            _loc3_.Substrate = _loc4_["SlotFunction"]["Lock"];
            _loc3_.OnClick = this.SlotLockOnClick;
            this.FBackPackSlotLocks.push(_loc3_);
            this.FBackPackSlotLocks[_loc2_].Enabled = false;
            _loc2_++;
         }
         this.FBackPackPage = new TUIPage(this);
         this.FBackPackPage.ButtonPrevious.Substrate = this.FMainUI["MC_PageLeft"];
         this.FBackPackPage.ButtonNext.Substrate = this.FMainUI["MC_PageRight"];
         this.FBackPackPage.LabelPage = this.FMainUI["TF_Page"];
         this.FBackPackPage.PageSize = BackPackSlotNum;
         this.FBackPackPage.OnChangePage = this.BackPagePageOnChange;
         this.FBackPackPage.Init();
         this.FUIImage = new TUIImage(this);
         this.FUIImage.mouseEnabled = false;
         this.FUIImage.alpha = 0.6;
         this.FUIImage.SetRegistrationPoint(-24,-24);
         this.FBtnMakeJade = new TUIButton();
         this.FBtnMakeJade.Substrate = this.FMainUI["BtnJmpMakeJade"];
         this.FBtnMakeJade.OnClick = this.BtnCloseOnClick;
         this.FBtnJadeChip = new TUIButton();
         this.FBtnJadeChip.Substrate = this.FMainUI["MC_Btn_ChipCompose"];
         this.FBtnJadeChip.OnClick = this.BtnChipComposeOnClick;
         this.FBtnJadeChip.OnOut = this.ButtonOnOut;
         this.FBtnJadeChip.OnMove = this.BtnChipComposeOnOver;
         this.FBtnSwallowPellet = new TUIButton();
         this.FBtnSwallowPellet.Substrate = this.FMainUI["BtnSwllowPellet"];
         this.FBtnSwallowPellet.OnClick = this.BtnSwallowPelletOnClick;
         this.FBtnSwallowPellet.OnMove = this.BtnSwallowPelletOnMove;
         this.FBtnSwallowPellet.OnOut = this.ButtonOnOut;
         this.FBtnSwallowCrashJade = new TUIButton();
         this.FBtnSwallowCrashJade.Substrate = this.FMainUI["SwallowCrashJade"];
         this.FBtnSwallowCrashJade.OnClick = this.BtnSwallowCrashJadeOnClick;
         this.FBtnSwallowCrashJade.OnMove = this.BtnSwallowCrashJadeMove;
         this.FBtnSwallowCrashJade.OnOut = this.ButtonOnOut;
         this.FLayerMask = new Sprite();
         FParent.addChild(this.FLayerMask);
         this.FLayerMask.addChild(new Bitmap(SUtilityResource.BtmDataFullScreen));
         this.FLayerMask.visible = false;
         this.FWindowChipCompose = new TProcessorWindowCompose(FParent);
         this.FWindowChipCompose.UIDispatch();
         this.FWindowChipCompose.UILocations();
         this.FWindowChipCompose.x = (CONST_COMMON.STAGE_Width - this.FWindowChipCompose.width) / 2;
         this.FWindowChipCompose.y = (CONST_COMMON.STAGE_Height - this.FWindowChipCompose.height) / 2;
         this.FWindowChipCompose.OnClose = this.CancleMask;
         this.FWindowSwllowPellet = new TProcessorWindowPelletSwallow(FParent);
         this.FWindowSwllowPellet.UIDispatch();
         this.FWindowSwllowPellet.x = (CONST_COMMON.STAGE_Width - this.FWindowSwllowPellet.width) / 2;
         this.FWindowSwllowPellet.y = (CONST_COMMON.STAGE_Height - this.FWindowSwllowPellet.height) / 2;
         this.FWindowSwllowPellet.OnClose = this.CancleMask;
         this.FWindowSwallow = new TProcessorWindowSwallow(FParent);
         this.FWindowSwallow.UIDipatch();
         this.FWindowSwallow.UILocation();
         this.FWindowSwallow.x = (CONST_COMMON.STAGE_Width - this.FWindowSwallow.width) / 2;
         this.FWindowSwallow.y = (CONST_COMMON.STAGE_Height - this.FWindowSwallow.height) / 2;
         this.FWindowSwallow.OnClose = this.CancleMask;
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.CrashJade_BackPackInitSize) as TConfigValue;
         this.FBackPackInitNum = _loc6_.Value as int;
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.CrashJade_CanBuyBagCost) as TConfigValue;
         this.FUnlockSlotPrice = Vector.<int>(_loc6_.Value);
         this.FBackPackMaxSlotNum = this.FUnlockSlotPrice.length + this.FBackPackInitNum;
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.CrashJade_SwalloPelletLevelLimit) as TConfigValue;
         this.FSwallowPelletLevelLimit = _loc6_.Value as int;
         this.FHint = new THint();
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.CrashJade_ChipNeed) as TConfigValue;
         this.FComposeRate = _loc6_.Value as int;
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.CrashJade_SwalloPelletLevelLimit) as TConfigValue;
         this.FSwallowPelletLevelLimit = _loc6_.Value as int;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FIfPromot = true;
         this.Reset();
         super.ResourcesPerform_UILocations();
      }
      
      protected function RenderingTabName() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THeros = null;
         var _loc6_:THero = null;
         _loc5_ = SLogicsCore.Character.Heros;
         _loc2_ = this.FCurrentHeroPageIndex * TabNum;
         _loc3_ = _loc2_ + TabNum;
         _loc3_ = _loc3_ > _loc5_.Count ? _loc5_.Count : _loc3_;
         _loc4_ = 0;
         this.FHeroTab.SwithTagManual(0);
         _loc1_ = _loc2_;
         while(_loc1_ < _loc3_)
         {
            _loc6_ = _loc5_.GetHeroByIndex(_loc1_);
            this.FHeroTab.SetTabCaptionByIndex(_loc6_.Name,_loc4_,CONST_COMMON.QUALITYCOLOR_INDEX[_loc6_.Quality]);
            this.FHeroTab.SetTabShowByIndex(_loc4_);
            _loc4_++;
            _loc1_++;
         }
         _loc1_ = _loc4_;
         while(_loc1_ < TabNum)
         {
            this.FHeroTab.SetTabHideByIndex(_loc1_);
            _loc1_++;
         }
      }
      
      protected function RenderHeroInfor(param1:THero) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TInventory = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:TCrashJade = null;
         var _loc9_:int = 0;
         this.FRoleMoudle.RoleTempleteID = this.FCurrentShowHero.Identifier;
         TUtilityTexture.QueryTwoDirectionShowCase(CONST_MAP.DIRECTION_RIGHT,this.FRoleMoudle.RoleTempleteID,this.FQueryModel);
         this.FRoleMoudle.ChangeRoleMoudle(this.FQueryModel.TextureID,1);
         this.FRoleMoudle.OpenRebirthEffect(this.FCurrentShowHero.IsMain,this.FCurrentShowHero.RebirthNum);
         _loc2_ = param1.CrashJadeMounted.Capacity;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc8_ = param1.CrashJadeMounted.GetInventoryByIndex(_loc3_) as TCrashJade;
            this.FHeroSlots[_loc3_].Context = _loc8_;
            this.FHeroSlots[_loc3_].Resource["TF_CrashLevel"].text = "";
            if(_loc8_ != null)
            {
               this.FHeroSlots[_loc3_].TextureAdvancedEffect = SResourcesCore.TexturesLobby.GetTextureByIdentifier(_loc8_.EffectID);
               this.FHeroSlots[_loc3_].Resource["TF_CrashLevel"].text = "lv." + _loc8_.Level.toString();
            }
            _loc3_++;
         }
         _loc6_ = int(param1.Level);
         _loc2_ = int(param1.CrashJadeOpenLevel.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc5_ = param1.CrashJadeOpenLevel[_loc3_];
            if(_loc5_ <= _loc6_)
            {
               this.FHeroSlotDesUI[_loc3_].visible = false;
            }
            else
            {
               this.FHeroSlotDes[_loc3_].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_07),_loc5_);
               this.FHeroSlotDesUI[_loc3_].visible = true;
            }
            _loc3_++;
         }
         _loc9_ = 0;
         _loc7_ = "";
         _loc2_ = param1.CrashJadeMounted.Capacity;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc8_ = param1.CrashJadeMounted.GetInventoryByIndex(_loc3_) as TCrashJade;
            if(_loc8_ != null)
            {
               _loc7_ += TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_10),CONST_COMMON.TextColor[_loc8_.Quality],_loc8_.Name,this.GetAttDest(_loc8_)) + "\n";
               _loc9_ += _loc8_.JadePower;
            }
            _loc3_++;
         }
         this.FJadePowerSwitchInfor.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_11),_loc9_);
         _loc7_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_09),CONST_COMMON.TextColor[param1.Quality],param1.Name,_loc9_) + "\n" + _loc7_;
         this.FJadePowerInfor.htmlText = _loc7_;
      }
      
      protected function RenderJadeChip() : void
      {
         this.FTFChipNum.text = this.FCrashJadeData.ChipNum.toString();
         this.FTFJadePellet.text = this.FCrashJadeData.ExperiencePelletNum.toString();
      }
      
      protected function GetAttDest(param1:TCrashJade) : String
      {
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc2_ = "";
         _loc4_ = param1.AddAttributeType.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ += TUtilityLobby.GetAttributeName(param1.AddAttributeType[_loc3_]);
            _loc2_ += "+";
            _loc2_ += param1.AddAttributeValue[_loc3_] <= 1 ? Number(param1.AddAttributeValue[_loc3_] * 100).toFixed(2) + "%" : param1.AddAttributeValue[_loc3_];
            _loc2_ += " ";
            _loc3_++;
         }
         return _loc2_;
      }
      
      protected function RenderBackPack() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TInventories = null;
         var _loc7_:TInventory = null;
         var _loc8_:TCrashJade = null;
         _loc6_ = SLogicsCore.Character.CrashJade;
         _loc4_ = this.FCurrentBackPackPageIndex * BackPackSlotNum;
         if(_loc6_.Count < _loc4_)
         {
            _loc5_ = _loc4_;
         }
         else
         {
            _loc5_ = _loc4_ + BackPackSlotNum;
            _loc5_ = _loc5_ > _loc6_.Count ? _loc6_.Count : _loc5_;
         }
         _loc3_ = 0;
         _loc1_ = _loc4_;
         while(_loc1_ < _loc5_)
         {
            _loc8_ = _loc6_.GetInventoryByIndex(_loc1_) as TCrashJade;
            this.FBackPackSlots[_loc3_].Context = _loc8_;
            this.FBackPackSlots[_loc3_].Resource.visible = true;
            this.FBackPackSlotLocks[_loc3_].Visible = false;
            this.FBackPackFunction[_loc3_].visible = false;
            this.FBackPackSlots[_loc3_].TextureAdvancedEffect = SResourcesCore.TexturesLobby.GetTextureByIdentifier(_loc8_.EffectID);
            this.FBackPackSlots[_loc3_].Resource["TF_CrashLevel"].text = "lv." + _loc8_.Level.toString();
            _loc3_++;
            _loc1_++;
         }
         _loc1_ = _loc3_;
         while(_loc1_ < BackPackSlotNum)
         {
            this.FBackPackSlots[_loc1_].Context = null;
            this.FBackPackSlots[_loc1_].Resource["TF_CrashLevel"].text = "";
            if(_loc1_ + _loc4_ >= this.FBackPackMaxSlotNum)
            {
               this.FBackPackSlots[_loc1_].Resource.visible = false;
            }
            else if(_loc1_ + _loc4_ >= this.FCrashJadeData.CurrentSlotNum)
            {
               this.FBackPackSlotLocks[_loc1_].Visible = true;
               this.FBackPackFunction[_loc1_].visible = true;
               this.FBackPackSlots[_loc1_].Resource.visible = true;
            }
            else
            {
               this.FBackPackFunction[_loc1_].visible = false;
            }
            _loc1_++;
         }
         if(this.FCurrentSelectSlot != null)
         {
            this.FCurrentSelectSlot.IsSelected = this.FCurrentSelectSlot.Context == this.FCurrentSelectJade;
         }
      }
      
      protected function UpdateHeroSlots() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = this.FCurrentShowHero.CrashJadeMounted.Capacity;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this.FHeroSlots[_loc2_].Update();
            _loc2_++;
         }
      }
      
      protected function UpdateBackPackSlots() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = BackPackSlotNum;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this.FBackPackSlots[_loc2_].Update();
            _loc2_++;
         }
      }
      
      protected function SetupPage(param1:int, param2:int, param3:TUIPage) : void
      {
         param3.TotalQuantity = param1;
         param3.Update();
         param3.PageIndex = param2;
      }
      
      protected function UnlockSlotReq(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CrashJade_UnlockSlotReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function SetupSelectSlot(param1:TUISlot) : void
      {
         var _loc2_:TCrashJade = null;
         if(this.FCurrentSelectSlot != null)
         {
            this.FCurrentSelectSlot.IsSelected = false;
         }
         this.FCurrentSelectSlot = param1;
         if(this.FCurrentSelectSlot != null)
         {
            this.FCurrentSelectSlot.IsSelected = true;
         }
         this.FBtnSwallowPellet.Enabled = this.FCurrentSelectSlot != null;
         this.FBtnSwallowCrashJade.Enabled = this.FCurrentSelectSlot != null;
         if(this.FCurrentSelectSlot != null)
         {
            _loc2_ = this.FCurrentSelectSlot.Context as TCrashJade;
            this.FBtnSwallowPellet.Enabled = _loc2_.Level >= this.FSwallowPelletLevelLimit;
            this.FCurrentSelectJade = this.FCurrentSelectSlot.Context as TCrashJade;
         }
         else
         {
            this.FCurrentSelectJade = null;
         }
      }
      
      protected function UpdateBackLock() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = this.FCurrentBackPackPageIndex * BackPackSlotNum;
         _loc2_ = _loc1_ + BackPackSlotNum;
         this.FBackPackSlotLocks[this.FCrashJadeData.CurrentSlotNum % BackPackSlotNum].Enabled = this.FCrashJadeData.CurrentSlotNum >= _loc1_ && this.FCrashJadeData.CurrentSlotNum < _loc2_;
      }
      
      protected function SlotOnClick(param1:Object, param2:Object) : void
      {
         var _loc3_:TUISlot = null;
         _loc3_ = param1 as TUISlot;
         if(this.FCurrentSelectSlot == _loc3_)
         {
            this.SetupSelectSlot(null);
         }
         else
         {
            this.SetupSelectSlot(_loc3_);
         }
      }
      
      protected function SlotsOnDragBegin(param1:Object) : void
      {
         var _loc2_:TUISlot = null;
         _loc2_ = param1 as TUISlot;
         this.FUIImage.Sequence = _loc2_.SequenceContext;
         FUICore.MouseStartDrag(this.FUIImage,true);
      }
      
      protected function SlotsOnDragQuery(param1:Object, param2:TUIComponent, param3:Object, param4:TQueryBoolean) : void
      {
         param4.Value = true;
      }
      
      protected function SlotsOnDragDrop(param1:Object, param2:TUIComponent, param3:Object) : void
      {
         var _loc4_:TUISlot = null;
         var _loc5_:TUISlot = null;
         var _loc6_:TCrashJade = null;
         var _loc7_:TCrashJade = null;
         _loc4_ = param1 as TUISlot;
         _loc5_ = param2 as TUISlot;
         _loc7_ = _loc5_.Context as TCrashJade;
         if(this.IFSlotIn(_loc5_,this.FHeroSlots))
         {
            if(this.IFSlotIn(_loc4_,this.FBackPackSlots))
            {
               this.UnloadReq(this.FCurrentShowHero.Identifier,_loc5_.Tag);
            }
         }
         else if(this.IFSlotIn(_loc4_,this.FHeroSlots) && _loc4_.Context == null)
         {
            this.EquipReq(this.FCurrentShowHero.Identifier,_loc4_.Tag,_loc7_.Identifier0,_loc7_.Identifier1);
         }
         else if(_loc4_.Context != null)
         {
            this.FCurrentSwallowRes = _loc7_;
            this.FCurrentSwallowDes = _loc4_.Context as TCrashJade;
            this.SwallowPromot();
         }
      }
      
      protected function SlotsOnDragEnd(param1:Object) : void
      {
         FUICore.MouseStopDrag(this.FUIImage);
      }
      
      protected function SlotsOnQueryEdgeColor(param1:Object, param2:Object, param3:TQueryUInt) : void
      {
         var _loc4_:TCrashJade = null;
         if(param2 is TCrashJade)
         {
            _loc4_ = param2 as TCrashJade;
            param3.Value = 1;
         }
      }
      
      protected function HeroPageOnChange(param1:Object, param2:int) : void
      {
         this.FCurrentHeroPageIndex = param2;
         this.RenderingTabName();
      }
      
      protected function TabOnSwitch(param1:int) : void
      {
         this.FCurrentTabIndex = param1;
         this.FCurrentShowHero = SLogicsCore.Character.Heros.GetHeroByIndex(this.FCurrentTabIndex + this.FCurrentHeroPageIndex * TabNum);
         this.RenderHeroInfor(this.FCurrentShowHero);
         this.SetupSelectSlot(null);
      }
      
      protected function SlotLockOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FCrashJadeData.CurrentSlotNum - this.FBackPackInitNum;
         SUtilityOverLayer.UIWindowConfirmation.SetCheckBoxUsable(false);
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_08),this.FUnlockSlotPrice[_loc3_]);
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.UnlockSlotReq;
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
      }
      
      protected function BackPagePageOnChange(param1:Object, param2:int) : void
      {
         this.FCurrentBackPackPageIndex = param2;
         this.RenderBackPack();
         this.UpdateBackLock();
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
         this.Reset();
      }
      
      protected function IFSlotIn(param1:TUISlot, param2:Vector.<TUISlot>) : Boolean
      {
         var _loc3_:int = 0;
         _loc3_ = param2.indexOf(param1);
         return _loc3_ != -1;
      }
      
      protected function UnloadReq(param1:uint, param2:int) : void
      {
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CrashJade_UnloadJadeReq);
         _loc3_.Data.writeUnsignedInt(param1);
         _loc3_.Data.writeByte(param2);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function SwallowPromot() : void
      {
         if(this.FCurrentSwallowDes.NextLevelID == 0)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_13));
            return;
         }
         if(this.FCurrentSwallowDes.Quality < this.FCurrentSwallowRes.Quality)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_37));
            this.ReleseSelectCrashJade(this);
            return;
         }
         if(this.FIfPromot)
         {
            SUtilityOverLayer.UIWindowConfirmation.SetCheckBoxUsable(true);
            SUtilityOverLayer.UIWindowConfirmation.SetSelected(false);
            SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_12),this.FCurrentSwallowDes.Name,this.FCurrentSwallowRes.Name,this.FCurrentSwallowRes.SwallowExp + this.FCurrentSwallowRes.Exp);
            SUtilityOverLayer.UIWindowConfirmation.OnOK = this.SwallowReq;
            SUtilityOverLayer.UIWindowConfirmation.Visible = true;
            SUtilityOverLayer.UIWindowConfirmation.OnCancel = this.ReleseSelectCrashJade;
         }
         else
         {
            this.SwallowReq(this);
         }
      }
      
      protected function ReleseSelectCrashJade(param1:Object) : void
      {
         this.FCurrentSwallowDes = null;
         this.FCurrentSwallowRes = null;
         this.FIfPromot = !SUtilityOverLayer.UIWindowConfirmation.IsSelected;
      }
      
      protected function SwallowReq(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CrashJade_SwallowReq);
         _loc3_ = _loc2_.Data;
         _loc3_.writeUnsignedInt(this.FCurrentSwallowDes.Identifier0);
         _loc3_.writeUnsignedInt(this.FCurrentSwallowDes.Identifier1);
         _loc3_.writeUnsignedInt(this.FCurrentSwallowDes.MountedHeroID);
         _loc3_.writeShort(1);
         _loc3_.writeUnsignedInt(this.FCurrentSwallowRes.Identifier0);
         _loc3_.writeUnsignedInt(this.FCurrentSwallowRes.Identifier1);
         _loc3_.writeUnsignedInt(this.FCurrentSwallowRes.MountedHeroID);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
         this.ReleseSelectCrashJade(this);
      }
      
      protected function EquipReq(param1:uint, param2:int, param3:uint, param4:uint) : void
      {
         var _loc5_:TPacket = null;
         _loc5_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CrashJade_EquipJadeReq);
         _loc5_.Data.writeUnsignedInt(param1);
         _loc5_.Data.writeByte(param2);
         _loc5_.Data.writeUnsignedInt(param3);
         _loc5_.Data.writeUnsignedInt(param4);
         SNetworkCore.Transceiver.PacketTransmit(_loc5_);
      }
      
      protected function BtnChipComposeOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FWindowChipCompose.Show(this.FCrashJadeData);
         this.FLayerMask.visible = true;
      }
      
      protected function BtnChipComposeOnOver(param1:Object, param2:MouseEvent) : void
      {
         this.FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_33),this.FComposeRate);
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function BtnSwallowPelletOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TCrashJade = null;
         _loc3_ = this.FCurrentSelectSlot.Context as TCrashJade;
         this.FWindowSwllowPellet.Show(this.FCrashJadeData,_loc3_);
         this.FLayerMask.visible = true;
      }
      
      protected function BtnSwallowPelletOnMove(param1:Object, param2:MouseEvent) : void
      {
         this.FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_34),this.FSwallowPelletLevelLimit);
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function BtnSwallowCrashJadeMove(param1:Object, param2:MouseEvent) : void
      {
         this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_35);
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function BtnSwallowCrashJadeOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TCrashJade = null;
         _loc3_ = this.FCurrentSelectSlot.Context as TCrashJade;
         this.FWindowSwallow.Show(this.FCrashJadeData,_loc3_);
         this.FLayerMask.visible = true;
      }
      
      protected function BtnJadePowerSwithOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FJadePowerPanle.visible = !this.FJadePowerPanle.visible;
      }
      
      protected function CancleMask(param1:Object) : void
      {
         this.FLayerMask.visible = false;
      }
      
      protected function ButtonOnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      public function set CrashJadeData(param1:TCrashJadeData) : void
      {
         this.FCrashJadeData = param1;
      }
      
      public function Update() : void
      {
         this.SetupSelectSlot(null);
         this.SetupPage(SLogicsCore.Character.Heros.Count,0,this.FHeroPage);
         this.RenderingTabName();
         this.SetupPage(this.FBackPackMaxSlotNum,0,this.FBackPackPage);
         this.RenderBackPack();
         this.RenderJadeChip();
         this.UpdateBackLock();
      }
      
      public function EquipJadeNotify() : void
      {
         this.SetupSelectSlot(null);
         this.RenderBackPack();
         this.RenderHeroInfor(this.FCurrentShowHero);
      }
      
      public function UnloadJadeNotify() : void
      {
         this.SetupSelectSlot(null);
         this.RenderBackPack();
         this.RenderHeroInfor(this.FCurrentShowHero);
      }
      
      public function SwallowNotify() : void
      {
         this.SetupSelectSlot(null);
         this.RenderBackPack();
         this.RenderHeroInfor(this.FCurrentShowHero);
         if(this.FWindowSwallow.visible)
         {
            this.FWindowSwallow.SwallowNotify();
         }
      }
      
      public function ComposeNotify() : void
      {
         this.FWindowChipCompose.ComposeNotify();
         this.RenderJadeChip();
      }
      
      public function SwallowPelletNotify() : void
      {
         this.RenderBackPack();
         this.RenderJadeChip();
         this.RenderHeroInfor(this.FCurrentShowHero);
         this.FWindowSwllowPellet.SwallowPelletNotify();
      }
      
      public function UnlockSlotNotify() : void
      {
         this.RenderBackPack();
         this.UpdateBackLock();
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FCurrentBackPackPageIndex = 0;
         this.FJadePowerPanle.visible = false;
         this.FCurrentTabIndex = 0;
         this.FCurrentHeroPageIndex = 0;
         this.SetupSelectSlot(null);
         _loc2_ = int(this.FHeroSlots.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FHeroSlots[_loc1_].Context = null;
            _loc1_++;
         }
         _loc2_ = int(this.FBackPackSlots.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FBackPackSlots[_loc1_].Context = null;
            _loc1_++;
         }
         SUtilityOverLayer.UIWindowConfirmation.SetCheckBoxUsable(false);
         SUtilityOverLayer.UIWindowConfirmation.OnClose = null;
         this.FUIImage.Sequence = null;
      }
   }
}

