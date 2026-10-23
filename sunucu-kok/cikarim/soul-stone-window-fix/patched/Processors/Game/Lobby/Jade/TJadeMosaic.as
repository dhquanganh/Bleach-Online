package Processors.Game.Lobby.Jade
{
   import Components.ComboBox.*;
   import Components.Pages.*;
   import Components.ScrollBar.*;
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Queries.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.Characters.MainRoleWake.THeroWakeData;
   import Logics.Characters.MainRoleWake.THeroWakeEquipment;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Processors.Game.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Talisman.TSingleEquip;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.getTimer;
   import flash.text.*;
   
   public class TJadeMosaic extends TProcessorLobbyWindow
   {
      
      protected static const STATE_READY:int = 0;
      
      protected static const STATE_MOSAIC:int = 1;
      
      protected static const STATE_UNQUITE:int = 2;
      
      protected static const LOCKED:uint = 1;
      
      protected static const CAN_MOSAIC:uint = 2;
      
      protected static const MOSAICED:uint = 3;
      
      protected static const QUALITYCOLOR_INDEX:Vector.<uint> = CONST_COMMON.QUALITYCOLOR_INDEX;
      
      protected var FUIDispatchRoutines:Vector.<Function>;
      
      protected var FUILocationRoutines:Vector.<Function>;
      
      protected var FMC_HeroTags:Vector.<MovieClip>;
      
      protected var FTF_HeroName:Vector.<TextField>;
      
      protected var FHeroNameTab:TUITab;
      
      protected var FTagIndexBindingEquipment:int;
      
      protected var FCurrentShowTagIndex:int;
      
      protected var FCurrentShowEquipmentBag:TInventories;
      
      protected var FUIPageHeroList:TUIPage;
      
      protected var FPageIndexHeroList:int;
      
      protected var FCurrentShowEquipment:TEquipment;
      
      protected var FCurrentShowEquipmentName:TextField;
      
      protected var FScrollBar:TScrollBar;
      
      protected var FMC_List:MovieClip;
      
      protected var FList_SingleEquipment:Vector.<TSingleEquip>;
      
      protected var FCurrentClickSingleEquip:TSingleEquip;
      
      protected var FTF_CurHeroName:TextField;
      
      protected var FTF_Recommend:TextField;
      
      protected var FMC_EquipmentMountPoint:MovieClip;
      
      protected var FMC_EquipmentJadesLock:Vector.<MovieClip>;
      
      protected var FSingleEquipmentSlots:TUISlot;
      
      protected var FEquipmentJadeSlots:Vector.<TUISlot>;
      
      protected var FBackpackSlots:Vector.<TUISlot>;
      
      protected var FUIPage:TUIPage;
      
      protected var FPageIndex:int;
      
      protected var FJadeLevelComboBox:TComboBox;
      
      protected var FJadeLevelComboBoxSelectIndex:int;
      
      protected var FJadeTypeComboBox:TComboBox;
      
      protected var FJadeTypeComboBoxSelectIndex:int;
      
      protected var FSelectJadeUsetoShow:TInventories;
      
      protected var FCurrentMosaicJadeHeroID:uint;
      
      protected var FInitialization:Boolean;
      protected var FLastGemRefresh:int = 0;
      protected var FGemSignature:String = "";
      
      protected var FCurrentState:int;
      
      protected var FFatherUI:MovieClip;
      
      protected var FJadeLevelNames:Vector.<String>;
      
      protected var FJadeTypeNames:Vector.<String>;
      
      protected var FOnInventoryOver:Function;
      
      protected var FOnInventoryOut:Function;
      
      protected var FOnMountJade:Function;
      
      protected var FOnUnmountJade:Function;
      
      protected var FFlyText:Function;
      
      protected var FEmptyEquipmentText:TextField;
      protected var FResultCode:int;
      protected var FReplyReady:Boolean = false;
      
      protected var FUpdateHeroPower:Function;
      
      public function TJadeMosaic(param1:TUIComponent)
      {
         super(param1);
         this.ConstructDispatchRoutines();
         this.ConstructLocationRoutines();
      }
      
      protected function ConstructDispatchRoutines() : void
      {
         this.FUIDispatchRoutines = new Vector.<Function>();
         this.FUIDispatchRoutines.push(this.HeroTagUIDispath);
         this.FUIDispatchRoutines.push(this.EquipmentUIDispath);
         this.FUIDispatchRoutines.push(this.JadeRecommendDispath);
         this.FUIDispatchRoutines.push(this.EquipmentJadeUIDispath);
         this.FUIDispatchRoutines.push(this.BackpackJadeUIDispath);
      }
      
      public function Perform_UIDispatch(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Function = null;
         this.addChild(param1);
         this.FFatherUI = param1;
         _loc2_ = 0;
         while(_loc2_ < this.FUIDispatchRoutines.length)
         {
            _loc3_ = this.FUIDispatchRoutines[_loc2_];
            _loc3_(param1);
            _loc2_++;
         }
         this.FFatherUI.MC_ShowAllStoneAtt.addEventListener(MouseEvent.ROLL_OVER,this.OnShowAllStoneAttMCOver);
         this.FFatherUI.MC_ShowAllStoneAtt.addEventListener(MouseEvent.ROLL_OUT,this.OnShowAllStoneAttMCOut);
         this.FFatherUI.MC_AllAttTip.visible = false;
         this.FFatherUI.MC_ShowAllStoneAtt.MC_Anim.play();
      }
      
      protected function ConstructLocationRoutines() : void
      {
         this.FUILocationRoutines = new Vector.<Function>();
         this.FUILocationRoutines.push(this.HeroTagLocation);
         this.FUILocationRoutines.push(this.JadeRecommendLocation);
         this.FUILocationRoutines.push(this.EquipmentJadeLocation);
         this.FUILocationRoutines.push(this.BackpackJadeLocation);
      }
      
      public function Perform_UILocation() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Function = null;
         _loc1_ = 0;
         while(_loc1_ < this.FUILocationRoutines.length)
         {
            _loc2_ = this.FUILocationRoutines[_loc1_];
            _loc2_();
            _loc1_++;
         }
         this.Reset();
         this.FInitialization = true;
         this.FCurrentState = STATE_READY;
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TSingleEquip = null;
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(this.FInitialization)
         {
            TJadeCommon.ProcessorUpdateSlotsRenderingState(this.FBackpackSlots);
            TJadeCommon.ProcessorUpdateSlotsRenderingState(this.FEquipmentJadeSlots);
            _loc2_ = int(this.FList_SingleEquipment.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc3_ = this.FList_SingleEquipment[_loc1_];
               _loc3_.UpdateSingleEquip();
               _loc1_++;
            }
         }
               if(this.FInitialization && this.Visible && !this.PendingRequest && getTimer()-this.FLastGemRefresh > 250){
            this.FLastGemRefresh = getTimer();var signature:String = TJadeCommon.GemSignature();
            if(signature != this.FGemSignature){this.FGemSignature = signature;this.UpdateBackpackJade();}
         }
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         if(this.FFatherUI != null)
         {
            if(param1)
            {
               this.FFatherUI.MC_ShowAllStoneAtt.MC_Anim.play();
            }
            else
            {
               this.FFatherUI.MC_ShowAllStoneAtt.MC_Anim.stop();
            }
         }
      }
      
      protected function HeroTagUIDispath(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:TextField = null;
         this.FMC_HeroTags = new Vector.<MovieClip>();
         this.FTF_HeroName = new Vector.<TextField>();
         _loc2_ = 0;
         while(_loc2_ < CONST_JADE.MAX_HeroCount)
         {
            _loc3_ = param1["mc_hero_" + _loc2_];
            _loc4_ = _loc3_["tf_heroName"];
            this.FMC_HeroTags.push(_loc3_);
            this.FTF_HeroName.push(_loc4_);
            _loc2_++;
         }
         this.FCurrentShowEquipmentBag = new TInventories();
         this.FUIPageHeroList = new TUIPage(this);
         this.FUIPageHeroList.ButtonPrevious.Substrate = param1["MC_HeroPage"]["btn_left"];
         this.FUIPageHeroList.ButtonNext.Substrate = param1["MC_HeroPage"]["btn_right"];
         this.FUIPageHeroList.LabelPage = param1["MC_HeroPage"]["TF_Page"];
         this.FUIPageHeroList.PageSize = CONST_JADE.MAX_HeroCount;
         this.FUIPageHeroList.OnChangePage = this.HeroListPageOnChange;
         this.FJadeLevelNames = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.Jade_STRING_0);
         this.FJadeTypeNames = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.Jade_STRING_1);
      }
      
      protected function HeroTagLocation() : void
      {
         var _loc1_:int = 0;
         this.FHeroNameTab = new TUITab(this);
         _loc1_ = 0;
         while(_loc1_ < CONST_JADE.MAX_HeroCount)
         {
            this.FHeroNameTab.SetTabByIndex(this.FMC_HeroTags[_loc1_],_loc1_);
            _loc1_++;
         }
         this.FHeroNameTab.Init();
         this.FHeroNameTab.OnSwitch = this.OnSwitchTab;
         addChild(this.FHeroNameTab);
      }
      
      private function HeroListPageOnChange(param1:Object, param2:int) : void
      {
         this.FPageIndexHeroList = Math.max(0,Math.min(param2,Math.max(0,Math.ceil((SLogicsCore.Character.Heros.Count+1)/CONST_JADE.MAX_HeroCount)-1)));
         this.FCurrentShowTagIndex = -1;
         this.FCurrentShowEquipment = null;
         this.UpdateHerosTag();
         this.FHeroNameTab.SwithTagManual(0);
         this.OnSwitchTab(0);
         this.ResetEquipmentJade();
         this.FCurrentShowEquipmentName.text = "";
      }
      
      protected function UpdateHerosTag() : void
      {
         this.HideAndShowTagByNum(SLogicsCore.Character.Heros.Count + 1);
         this.SetTagName();
      }
      
      protected function SetTagName() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:THeros = null;
         var _loc4_:THero = null;
         _loc3_ = SLogicsCore.Character.Heros;
         _loc2_ = _loc3_.Count;
         _loc1_ = 0;
         while(_loc1_ < CONST_JADE.MAX_HeroCount)
         {
            if(_loc1_ + this.FPageIndexHeroList * CONST_JADE.MAX_HeroCount == _loc2_)
            {
               break;
            }
            _loc4_ = _loc3_.GetHeroByIndex(_loc1_ + this.FPageIndexHeroList * CONST_JADE.MAX_HeroCount);
            this.FHeroNameTab.SetTabCaptionByIndex(_loc4_.Name,_loc1_,QUALITYCOLOR_INDEX[_loc4_.Quality]);
            _loc1_++;
         }
         if(_loc1_ < CONST_JADE.MAX_HeroCount)
         {
            this.FHeroNameTab.SetTabCaptionByIndex(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Backpack),_loc1_,16775109);
         }
      }
      
      protected function HideAndShowTagByNum(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc5_ = this.FPageIndexHeroList;
         this.FHeroNameTab.Reset();
         if(param1 > CONST_JADE.MAX_HeroCount)
         {
            if(_loc5_ == uint(param1 / CONST_JADE.MAX_HeroCount))
            {
               _loc3_ = param1 % CONST_JADE.MAX_HeroCount;
            }
            else
            {
               _loc3_ = CONST_JADE.MAX_HeroCount;
            }
         }
         else
         {
            _loc3_ = param1;
         }
         if(_loc3_ <= 0)
         {
            return;
         }
         _loc4_ = _loc5_ * CONST_JADE.MAX_HeroCount;
         _loc2_ = 0;
         while(_loc2_ < CONST_JADE.MAX_HeroCount)
         {
            if(_loc2_ < _loc3_)
            {
               this.FHeroNameTab.SetTabShowByIndex(_loc2_);
            }
            else
            {
               this.FHeroNameTab.SetTabHideByIndex(_loc2_);
            }
            _loc2_++;
         }
      }
      
      protected function ResetHeroTag() : void
      {
         this.FHeroNameTab.SwithTagManual(0);
         this.FCurrentShowTagIndex = -1;
      }
      
      protected function EquipmentUIDispath(param1:MovieClip) : void
      {
         this.FList_SingleEquipment = new Vector.<TSingleEquip>();
         this.FMC_List = param1["mc_list"];
         this.FScrollBar = new TScrollBar(this.FMC_List,344,false,1,56);
               this.FEmptyEquipmentText = new TextField();
         this.FEmptyEquipmentText.defaultTextFormat = new TextFormat("Arial",12,0xFFE080);
         this.FEmptyEquipmentText.width = 145;this.FEmptyEquipmentText.height = 90;
         this.FEmptyEquipmentText.x = this.FMC_List.x+8;this.FEmptyEquipmentText.y = this.FMC_List.y+18;
         this.FEmptyEquipmentText.multiline = true;this.FEmptyEquipmentText.wordWrap = true;
         this.FEmptyEquipmentText.mouseEnabled = false;this.FEmptyEquipmentText.selectable = false;
         this.FEmptyEquipmentText.text = "No equipment.\nChoose another hero or the Backpack tab.";
         this.FEmptyEquipmentText.visible = false;param1.addChild(this.FEmptyEquipmentText);
      }
      
      protected function ConstructScroolBar() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TSingleEquip = null;
         var _loc4_:int = 0;
         _loc2_ = int(this.FList_SingleEquipment.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FList_SingleEquipment[_loc1_];
            _loc3_.Context = null;
            _loc3_.StubReferences.Dereference(this);
            _loc1_++;
         }
         this.FList_SingleEquipment.length = 0;
         this.FCurrentClickSingleEquip = null;
         this.FScrollBar.Clear();
         _loc4_ = this.FCurrentShowEquipmentBag.Count;
         if(_loc4_ < CONST_SMITHY.MinSingleEquipmentNum)
         {
            _loc2_ = CONST_SMITHY.MinSingleEquipmentNum;
         }
         else
         {
            _loc2_ = _loc4_;
         }
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = SLogicsCore.PoolUISingleEquipment.AcquireUISingleEquipment(this);
            _loc3_.StubReferences.Reference(this);
            _loc3_.OnClick = this.EquipmentClick;
            _loc3_.OnQuerySequenceContext = TJadeCommon.SlotsOnQuerySequenceContext;
            _loc3_.OnQueryEuqipLevel = this.SlotsOnQueryEuqipLevel;
            _loc3_.OnOut = this.SlotsOnOut;
            _loc3_.OnOver = this.SlotsOnMove;
            this.FScrollBar.AddItem(_loc3_);
            this.FList_SingleEquipment.push(_loc3_);
            _loc1_++;
         }
      }
      
      protected function SlotsOnQueryEuqipLevel(param1:Object, param2:Object, param3:TQueryString) : void
      {
         var _loc4_:TEquipment = null;
         if(param2 is TEquipment)
         {
            _loc4_ = param2 as TEquipment;
            if(_loc4_.UpgradingLevel > 0)
            {
               param3.Value = "Lv." + _loc4_.UpgradingLevel.toString();
            }
         }
      }
      
      protected function UpdateEquipment() : void
      {
         if(this.FList_SingleEquipment.length < Math.max(CONST_SMITHY.MinSingleEquipmentNum,this.FCurrentShowEquipmentBag.Count))this.ConstructScroolBar();
         for each(var row:TSingleEquip in this.FList_SingleEquipment)row.Release();
         if(this.FEmptyEquipmentText != null)this.FEmptyEquipmentText.visible = this.FCurrentShowEquipmentBag.Count == 0;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TEquipment = null;
         var _loc4_:int = 0;
         var _loc5_:TSingleEquip = null;
         var _loc6_:String = null;
         _loc6_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Jade_STRING_15);
         _loc4_ = this.FCurrentShowEquipmentBag.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc4_)
         {
            _loc3_ = this.FCurrentShowEquipmentBag.GetInventoryByIndex(_loc1_) as TEquipment;
            _loc5_ = this.FList_SingleEquipment[_loc1_];
            if(_loc3_ != null)_loc5_.SetEquip(_loc3_,_loc3_.Name,_loc6_ + _loc3_.UpgradingLevel,_loc3_.Quality);
            _loc1_++;
         }
               if(this.FCurrentShowEquipment == null && this.FCurrentShowEquipmentBag.Count > 0){
            this.FCurrentShowEquipment = this.FCurrentShowEquipmentBag.GetInventoryByIndex(0) as TEquipment;
            this.FCurrentClickSingleEquip = this.FList_SingleEquipment[0];this.FCurrentClickSingleEquip.BClick = true;
            if(this.FCurrentShowEquipment != null){this.FCurrentShowEquipmentName.text = this.FCurrentShowEquipment.Name;this.UpdateEquipmentJadeSlot();}
         }
      }
      
      protected function SelectEquipmentsByTabIndex(param1:int, param2:TInventories) : void
      {
         var _loc3_:THero = null;
         var _loc4_:int = 0;
         var _loc5_:TCollectionInventory = null;
         var _loc6_:TInventory = null;
         var _loc7_:int = 0;
         if(param1 + this.FPageIndexHeroList * CONST_JADE.MAX_HeroCount < SLogicsCore.Character.Heros.Count)
         {
            _loc3_ = SLogicsCore.Character.Heros.GetHeroByIndex(param1 + this.FPageIndexHeroList * CONST_JADE.MAX_HeroCount);
            _loc5_ = _loc3_.EquipmentsMounted;
            param2.Clear();
            _loc4_ = 0;
            while(_loc4_ < _loc5_.Capacity)
            {
               _loc6_ = _loc5_.GetInventoryByIndex(_loc4_);
               if(_loc6_ != null)
               {
                  param2.Add(_loc6_);
               }
               _loc4_++;
            }
         }
         else
         {
            _loc7_ = int(SLogicsCore.Character.Equipments.Count);
            param2.Clear();
            _loc4_ = 0;
            while(_loc4_ < _loc7_)
            {
               param2.Add(SLogicsCore.Character.Equipments.GetInventoryByIndex(_loc4_));
               _loc4_++;
            }
         }
      }
      
      protected function EquipmentClick(param1:Object, param2:Object) : void
      {
         if(param1 == null || param2 == null)return;
         var _loc3_:TSingleEquip = null;
         _loc3_ = param1 as TSingleEquip;
         if(this.FCurrentClickSingleEquip != null)
         {
            this.FCurrentClickSingleEquip.BClick = false;
         }
         this.FCurrentClickSingleEquip = _loc3_;
         this.FCurrentShowEquipment = param2 as TEquipment;
         this.FCurrentShowEquipmentName.text = this.FCurrentShowEquipment.Name;
         this.FCurrentShowEquipmentName.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[this.FCurrentShowEquipment.Quality];
         this.UpdateEquipmentJadeSlot();
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_SelectEquip);
      }
      
      protected function ResetEquipments() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TSingleEquip = null;
         this.FCurrentShowEquipment = null;
         this.FCurrentShowEquipmentBag.Clear();
         this.FCurrentClickSingleEquip = null;
         _loc2_ = int(this.FList_SingleEquipment.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FList_SingleEquipment[_loc1_];
            _loc3_.Context = null;
            _loc3_.StubReferences.Dereference(this);
            _loc1_++;
         }
      }
      
      protected function ResetCurrentEquipments() : void
      {
      }
      
      protected function GetEquipmentColor(param1:TInventory) : uint
      {
         return CONST_COMMON.QUALITYCOLOR_INDEX[param1.Quality];
      }
      
      protected function JadeRecommendDispath(param1:MovieClip) : void
      {
         this.FTF_CurHeroName = param1["tf_curHeroName"];
         this.FTF_Recommend = param1["tf_recommend"];
      }
      
      protected function JadeRecommendLocation() : void
      {
      }
      
      protected function UpdateJadeRecommend() : void
      {
         var _loc1_:THero = null;
         var _loc2_:TRecommendStone = null;
         var _loc3_:TStarPointDesc = null;
         var _loc4_:int = 0;
         var _loc5_:Vector.<int> = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         if(this.FCurrentShowTagIndex + this.FPageIndexHeroList * CONST_JADE.MAX_HeroCount >= SLogicsCore.Character.Heros.Count)
         {
            this.ResetJadeRecommend();
            return;
         }
         _loc1_ = SLogicsCore.Character.Heros.GetHeroByIndex(this.FCurrentShowTagIndex + this.FPageIndexHeroList * CONST_JADE.MAX_HeroCount);
         this.FTF_CurHeroName.text = _loc1_.Name;
         this.FTF_CurHeroName.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[_loc1_.Quality];
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RecommendStone,_loc1_.Identifier) as TRecommendStone;
         _loc5_ = _loc2_.StonesType;
         _loc7_ = "";
         _loc4_ = 0;
         while(_loc4_ < _loc5_.length)
         {
            _loc6_ = _loc5_[_loc4_];
            _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_StarPointDesc,17500000 + _loc6_) as TStarPointDesc;
            _loc7_ += _loc3_.Desc + " ";
            _loc4_++;
         }
         this.FTF_Recommend.text = _loc7_;
      }
      
      protected function ResetJadeRecommend() : void
      {
         this.FTF_Recommend.text = "";
         this.FTF_CurHeroName.text = "";
      }
      
      protected function EquipmentJadeUIDispath(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:TUISlot = null;
         _loc3_ = param1["mc_curEquipment"];
         _loc3_["mc_clock"].visible = false;
         _loc3_ = param1["mc_curEquipment"];
         this.FSingleEquipmentSlots = new TUISlot(this);
         this.FSingleEquipmentSlots.Resource = _loc3_["mc_slot"];
         this.FSingleEquipmentSlots.TextureAdvancedEffect = SResourcesCore.TexturesLobby.GetTextureByIdentifier(CONST_LOBBY.RESOURCESID_Texture_SlotAdvancedEffect);
         this.FSingleEquipmentSlots.OnQueryEdgeColor = this.SlotsOnQueryEdgeColor;
         _loc3_["mc_slot"]["TF_Subscript"].visible = false;
         this.FCurrentShowEquipmentName = param1["tf_curEquipmentName"];
         this.FMC_EquipmentJadesLock = new Vector.<MovieClip>();
         this.FEquipmentJadeSlots = new Vector.<TUISlot>();
         _loc2_ = 0;
         while(_loc2_ < CONST_JADE.MAX_MosaicJadeCount)
         {
            _loc3_ = param1["mc_mosaicJade_" + _loc2_];
            _loc3_["mc_clock"].mouseChildren = false;
            _loc3_["mc_clock"].mouseEnabled = false;
            this.FMC_EquipmentJadesLock.push(_loc3_["mc_clock"]);
            _loc4_ = new TUISlot(this);
            _loc4_.Resource = _loc3_["mc_slot"];
            _loc3_["mc_slot"]["TF_Subscript"].visible = false;
            this.FEquipmentJadeSlots.push(_loc4_);
            _loc2_++;
         }
      }
      
      protected function EquipmentJadeLocation() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TUISlot = null;
         this.FEquipmentJadeSlots.push(this.FSingleEquipmentSlots);
         _loc1_ = 0;
         while(_loc1_ < this.FEquipmentJadeSlots.length)
         {
            _loc2_ = this.FEquipmentJadeSlots[_loc1_];
            TJadeCommon.InitSlot(_loc2_);
            _loc2_.Tag = _loc1_;
            _loc2_.OnClick = this.EquipmentJadeSlotClick;
            _loc2_.Init();
            _loc2_.OnOver = this.SlotsOnMove;
            _loc2_.OnOut = this.SlotsOnOut;
            _loc1_++;
         }
         this.FSingleEquipmentSlots.OnClick = this.OnSlotClick;
         this.FCurrentShowEquipmentName.text = "";
      }
      
      protected function EquipmentJadeSlotClick(param1:Object, param2:Object) : void
      {
         if(this.PendingRequest)return;
         this.FReplyReady = false;
         if(this.FCurrentState != STATE_READY || this.FCurrentShowEquipment == null || param2 == null)
         {
            return;
         }
         var _loc3_:TAppliance = null;
         var _loc4_:THero = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc3_ = param2 as TAppliance;
         if(this.FCurrentShowTagIndex + this.FPageIndexHeroList * CONST_JADE.MAX_HeroCount < SLogicsCore.Character.Heros.Count)
         {
            _loc4_ = SLogicsCore.Character.Heros.GetHeroByIndex(this.FCurrentShowTagIndex + this.FPageIndexHeroList * CONST_JADE.MAX_HeroCount);
            this.FCurrentMosaicJadeHeroID = _loc4_.Identifier;
         }
         else
         {
            this.FCurrentMosaicJadeHeroID = 0;
         }
         if(this.FOnUnmountJade != null)
         {
            this.FCurrentState = STATE_UNQUITE;
            this.FOnUnmountJade(this,this.FCurrentMosaicJadeHeroID,this.FCurrentShowEquipment,_loc3_);
            this.FCurrentState = STATE_UNQUITE;
         }
         if(this.FOnInventoryOut != null)
         {
            this.FOnInventoryOut(this,param2);
         }
      }
      
      protected function GetEquipmentByIndex(param1:int, param2:int) : TEquipment
      {
         if(param2 == -1)
         {
            return null;
         }
         return this.FCurrentShowEquipmentBag.GetInventoryByIndex(param2) as TEquipment;
      }
      
      protected function UpdateEquipmentJadeSlot() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TGiftedStoneItems = null;
         this.SetSlotByEquipment(this.FCurrentShowEquipment);
         this.FSingleEquipmentSlots.Context = this.FCurrentShowEquipment;
         if(this.FCurrentShowEquipment != null)
         {
            _loc3_ = this.FCurrentShowEquipment.GiftedStoneItems;
            _loc2_ = 0;
            while(_loc2_ < Math.min(_loc3_.Count,this.FEquipmentJadeSlots.length))
            {
               this.FEquipmentJadeSlots[_loc2_].Context = _loc3_.GetGiftedStoneByIndex(_loc2_);
               this.FMC_EquipmentJadesLock[_loc2_].gotoAndStop(MOSAICED);
               _loc2_++;
            }
         }
      }
      
      protected function SetSlotByEquipment(param1:TEquipment) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.FSingleEquipmentSlots.Context = param1;
         if(param1 != null)
         {
            _loc3_ = Math.min(CONST_JADE.MAX_MosaicJadeCount,param1.HoleQuantity + param1.HoleAdditionalQuantity);
         }
         else
         {
            _loc3_ = 0;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FMC_EquipmentJadesLock[_loc2_].gotoAndStop(CAN_MOSAIC);
            this.FEquipmentJadeSlots[_loc2_].Context = null;
            _loc2_++;
         }
         _loc3_ = CONST_JADE.MAX_MosaicJadeCount;
         while(_loc2_ < _loc3_)
         {
            this.FMC_EquipmentJadesLock[_loc2_].gotoAndStop(LOCKED);
            this.FEquipmentJadeSlots[_loc2_].Context = null;
            _loc2_++;
         }
      }
      
      protected function ResetEquipmentJade() : void
      {
         this.SetSlotByEquipment(null);
      }
      
      protected function BackpackJadeUIDispath(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:DisplayObject = null;
         var _loc5_:int = 0;
         var _loc6_:Vector.<DisplayObject> = null;
         var _loc7_:Vector.<DisplayObject> = null;
         var _loc8_:Array = null;
         var _loc9_:TUISlot = null;
         this.FSelectJadeUsetoShow = new TInventories();
         this.FBackpackSlots = new Vector.<TUISlot>();
         _loc2_ = 0;
         while(_loc2_ < CONST_JADE.MAX_JadeSlotCount)
         {
            _loc3_ = param1["mc_stone_" + _loc2_];
            _loc9_ = new TUISlot(this);
            _loc9_.Resource = _loc3_;
            this.FBackpackSlots.push(_loc9_);
            TJadeCommon.InitSlot(_loc9_);
            _loc9_.Tag = _loc2_;
            _loc9_.OnClick = this.BackpackJadeSlotsOnClick;
            _loc9_.Init();
            _loc9_.OnOver = this.SlotsOnMove;
            _loc9_.OnOut = this.SlotsOnOut;
            _loc2_++;
         }
         this.FUIPage = new TUIPage(this);
         this.FUIPage.ButtonPrevious.Substrate = param1["btn_left"];
         this.FUIPage.ButtonNext.Substrate = param1["btn_right"];
         this.FUIPage.LabelPage = param1["TF_Page"];
         _loc6_ = new Vector.<DisplayObject>();
         _loc5_ = int(this.FJadeLevelNames.length);
         _loc2_ = 0;
         while(_loc2_ < _loc5_)
         {
            _loc4_ = this.MakeComboItem(this.FJadeLevelNames[_loc2_]);
            _loc6_.push(_loc4_);
            _loc2_++;
         }
         this.FJadeLevelComboBox = new TComboBox(this,param1["mc_list_level"],_loc6_,CONST_JADE.MAX_ComboboxHeight,this.OnLevelSelect);
         _loc7_ = new Vector.<DisplayObject>();
         _loc5_ = int(this.FJadeTypeNames.length);
         _loc2_ = 0;
         while(_loc2_ < _loc5_)
         {
            _loc4_ = this.MakeComboItem(this.FJadeTypeNames[_loc2_]);
            _loc7_.push(_loc4_);
            _loc2_++;
         }
         this.FJadeTypeComboBox = new TComboBox(this,param1.mc_list_type,_loc7_,CONST_JADE.MAX_ComboboxHeight,this.OnTypeSelect);
      }
      
      protected function BackpackJadeLocation() : void
      {
         this.FUIPage.PageSize = CONST_JADE.MAX_JadeSlotCount;
         this.FUIPage.OnChangePage = this.PageOnChange;
      }
      
      protected function SetupJadePage(param1:int, param2:int) : void
      {
         this.FUIPage.TotalQuantity = param1;
         this.FUIPage.Update();
         this.FUIPage.PageIndex = param2;
      }
      
      protected function SetupHeroListPage(param1:int, param2:int) : void
      {
         this.FUIPageHeroList.TotalQuantity = param1;
         this.FUIPageHeroList.Update();
         this.FUIPageHeroList.PageIndex = param2;
      }
      
      protected function UpdateBackpackJade() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TUISlot = null;
         var _loc6_:TAppliance = null;
         this.SelectCanShowJade(this.FJadeLevelComboBoxSelectIndex,this.FJadeTypeComboBoxSelectIndex,this.FSelectJadeUsetoShow);
         this.FPageIndex = Math.max(0,Math.min(this.FPageIndex,Math.max(0,Math.ceil(this.FSelectJadeUsetoShow.Count / CONST_JADE.MAX_JadeSlotCount) - 1)));
         this.SetupJadePage(this.FSelectJadeUsetoShow.Count,this.FPageIndex);
         _loc4_ = int(this.FBackpackSlots.length);
         _loc2_ = this.FSelectJadeUsetoShow.Count;
         _loc3_ = this.FPageIndex * CONST_JADE.MAX_JadeSlotCount;
         _loc1_ = 0;
         while(_loc1_ < _loc4_)
         {
            _loc5_ = this.FBackpackSlots[_loc1_];
            if(_loc1_ + _loc3_ < _loc2_)
            {
               _loc6_ = this.FSelectJadeUsetoShow.GetInventoryByIndex(_loc1_ + _loc3_) as TAppliance;
               _loc5_.Context = _loc6_;
            }
            else
            {
               _loc5_.Context = null;
            }
            _loc1_++;
         }
      }
      
      protected function SelectCanShowJade(param1:int, param2:int, param3:TInventories) : void
      {
         var _loc4_:TInventories = null;
         _loc4_ = SLogicsCore.Character.Gems;
         this.FSelectJadeUsetoShow.Clear();
         TJadeCommon.GetSpecialJade(_loc4_,param3,CONST_JADE.ComboBoxJadeLevel[param1],CONST_JADE.ComboBoxJadeSecondType[param2]);
      }
      
      protected function PageOnChange(param1:Object, param2:int) : void
      {
         this.FPageIndex = param2;
         this.UpdateBackpackJade();
      }
      
      protected function VerificationMosaic(param1:TAppliance) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TAppliance = null;
         if(this.FCurrentShowEquipment == null)
         {
            return false;
         }
         _loc3_ = this.FCurrentShowEquipment.GiftedStoneItems.Count;
         if(_loc3_ >= this.FCurrentShowEquipment.HoleQuantity + this.FCurrentShowEquipment.HoleAdditionalQuantity)
         {
            this.FFlyText(CONST_SYSTEMLANGUAGE.Jade_STRING_5);
            return false;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FCurrentShowEquipment.GiftedStoneItems.GetGiftedStoneByIndex(_loc2_);
            if(param1.CategorySecond == _loc4_.CategorySecond)
            {
               this.FFlyText(CONST_SYSTEMLANGUAGE.Jade_STRING_4);
               return false;
            }
            _loc2_++;
         }
         return true;
      }
      
      protected function BackpackJadeSlotsOnClick(param1:Object, param2:Object) : void
      {
         if(this.PendingRequest)return;
         this.FReplyReady = false;
         if(this.FCurrentState != STATE_READY || this.FCurrentShowEquipment == null || param2 == null)
         {
            return;
         }
         var _loc3_:TAppliance = null;
         var _loc4_:THero = null;
         var _loc5_:Boolean = false;
         _loc3_ = param2 as TAppliance;
         _loc5_ = this.VerificationMosaic(_loc3_);
         if(!_loc5_)
         {
            return;
         }
         if(this.FCurrentShowTagIndex + this.FPageIndexHeroList * CONST_JADE.MAX_HeroCount < SLogicsCore.Character.Heros.Count)
         {
            _loc4_ = SLogicsCore.Character.Heros.GetHeroByIndex(this.FCurrentShowTagIndex + this.FPageIndexHeroList * CONST_JADE.MAX_HeroCount);
            this.FCurrentMosaicJadeHeroID = _loc4_.Identifier;
         }
         else
         {
            this.FCurrentMosaicJadeHeroID = 0;
         }
         if(this.FOnMountJade != null)
         {
            this.FCurrentState = STATE_MOSAIC;
            this.FOnMountJade(this,this.FCurrentMosaicJadeHeroID,this.FCurrentShowEquipment,_loc3_);
            this.FCurrentState = STATE_MOSAIC;
         }
         if(this.FOnInventoryOut != null)
         {
            this.FOnInventoryOut(param1,param2);
         }
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_SelectJade);
      }
      
      protected function MakeComboItem(param1:String) : DisplayObject
      {
         var _loc2_:MovieClip = null;
         _loc2_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_JADE.RESOURCE_ClassName_ComboBoxItem) as MovieClip;
         _loc2_.tf_into.text = param1;
         return _loc2_;
      }
      
      protected function ResetBackpackJade() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUISlot = null;
         _loc2_ = int(this.FBackpackSlots.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FBackpackSlots[_loc1_];
            _loc3_.Context = null;
            _loc1_++;
         }
         this.FPageIndex = 0;
         this.SetupJadePage(0,0);
         this.FJadeLevelComboBoxSelectIndex = 0;
         this.FJadeTypeComboBoxSelectIndex = 0;
         this.FSelectJadeUsetoShow.Clear();
      }
      
      protected function ComputeStoneAllAtt(param1:THero) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Number = Number(NaN);
         var _loc6_:String = null;
         var _loc7_:uint = 0;
         var _loc8_:Number = Number(NaN);
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:uint = 0;
         _loc5_ = 0;
         _loc8_ = 0;
         _loc3_ = CONST_COMMON.StoneSecondaryType.length;
         _loc11_ = CONST_COMMON.StoneAttType.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = CONST_COMMON.StoneSecondaryType[_loc2_];
            _loc5_ = this.GetStoneAllAtt(param1,_loc4_);
            _loc6_ = (_loc5_ * 100).toFixed(2) + "%";
            _loc8_ = 0;
            if(_loc5_ != 0 && _loc2_ < _loc11_ && param1.IsMain)
            {
               _loc7_ = CONST_COMMON.StoneAttType[_loc2_];
               _loc8_ = this.GetStoneAttAdd(_loc7_);
               _loc8_ *= _loc5_;
            }
            if(_loc8_ == 0)
            {
               _loc9_ = "0%";
            }
            else
            {
               _loc9_ = (_loc8_ * 100).toFixed(2) + "%";
            }
            if(_loc5_ != 0)
            {
               _loc10_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Jade_STRING_17);
               _loc10_ = TUtilityString.Format(_loc10_,_loc6_,_loc9_);
            }
            else
            {
               _loc10_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Jade_STRING_16);
            }
            this.FFatherUI.MC_AllAttTip["TF_Att_" + _loc2_].htmlText = _loc10_;
            _loc2_++;
         }
      }
      
      protected function GetStoneAllAtt(param1:THero, param2:uint) : Number
      {
         var _loc3_:Number = Number(NaN);
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:TEquipment = null;
         var _loc9_:TAppliance = null;
         var _loc10_:TBaseStone = null;
         _loc3_ = 0;
         _loc6_ = uint(CONST_CHARACTER.CAPACITY_EquipmentsMounted);
         _loc4_ = 0;
         while(_loc4_ < _loc6_)
         {
            _loc8_ = param1.EquipmentsMounted.GetInventoryByIndex(_loc4_) as TEquipment;
            if(_loc8_ != null)
            {
               _loc7_ = uint(_loc8_.GiftedStoneItems.Count);
               _loc5_ = 0;
               while(_loc5_ < _loc7_)
               {
                  _loc9_ = _loc8_.GiftedStoneItems.GetGiftedStoneByIndex(_loc5_);
                  if(_loc9_.CategorySecond == param2)
                  {
                     _loc10_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseStone,_loc9_.IDTemplate) as TBaseStone;
                     if(param2 == 104)
                     {
                        _loc3_ += _loc10_.AddValue / 50;
                     }
                     else
                     {
                        _loc3_ += _loc10_.AddValue;
                     }
                  }
                  _loc5_++;
               }
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      protected function GetStoneAttAdd(param1:uint) : Number
      {
         var _loc2_:THeroWakeData = null;
         var _loc3_:THeroWakeEquipment = null;
         var _loc4_:Object = null;
         _loc2_ = SLogicsCore.HeroWakeData;
         _loc3_ = _loc2_.Equips[THeroWakeData.StonePos];
         for each(_loc4_ in _loc3_.WakeUpConfig.EquipAttr)
         {
            if(_loc4_.type == param1)
            {
               return _loc4_.value;
            }
         }
         return 0;
      }
      
      protected function OnShowAllStoneAttMCOver(param1:MouseEvent) : void
      {
         var _loc2_:THero = null;
         var _loc3_:uint = 0;
         _loc3_ = this.FCurrentShowTagIndex + this.FPageIndexHeroList * CONST_JADE.MAX_HeroCount;
         if(_loc3_ < SLogicsCore.Character.Heros.Count)
         {
            _loc2_ = SLogicsCore.Character.Heros.GetHeroByIndex(_loc3_);
            this.ComputeStoneAllAtt(_loc2_);
            this.FFatherUI.MC_AllAttTip.visible = true;
         }
      }
      
      protected function OnShowAllStoneAttMCOut(param1:MouseEvent) : void
      {
         this.FFatherUI.MC_AllAttTip.visible = false;
      }
      
      protected function OnSwitchTab(param1:int) : void
      {
         if(this.FCurrentShowTagIndex != param1)
         {
            this.FCurrentShowTagIndex = param1;
            this.SelectEquipmentsByTabIndex(param1,this.FCurrentShowEquipmentBag);
            this.ConstructScroolBar();
            this.FCurrentShowEquipment = null;
            this.UpdateJadeRecommend();
            this.UpdateEquipmentJadeSlot();
            this.FCurrentShowEquipmentName.text = "";
         }
         this.UpdateEquipment();
      }
      
      protected function OnLevelSelect(param1:Object, param2:int) : void
      {
         this.FPageIndex = 0;
         this.FJadeLevelComboBoxSelectIndex = param2;
         this.UpdateBackpackJade();
      }
      
      protected function OnTypeSelect(param1:Object, param2:int) : void
      {
         this.FPageIndex = 0;
         this.FJadeTypeComboBoxSelectIndex = param2;
         this.UpdateBackpackJade();
      }
      
      protected function OnSlotClick(param1:Object = null, param2:Object = null) : void
      {
         this.ResetEquipmentJade();
         this.FCurrentShowEquipmentName.text = "";
         this.SlotsOnOut(param1,param2 as TInventory);
      }
      
      protected function SlotsOnMove(param1:Object, param2:TInventory) : void
      {
         if(this.FOnInventoryOver != null)
         {
            this.FOnInventoryOver(param1,param2);
         }
      }
      
      protected function SlotsOnOut(param1:Object, param2:TInventory) : void
      {
         if(this.FOnInventoryOut != null)
         {
            this.FOnInventoryOut(param1,param2);
         }
      }
      
      protected function SlotsOnQueryEdgeColor(param1:Object, param2:Object, param3:TQueryUInt) : void
      {
         var _loc4_:TEquipment = null;
         if(param2 is TEquipment)
         {
            _loc4_ = param2 as TEquipment;
            param3.Value = _loc4_.IsEdgeColor;
         }
      }
      
      public function set OnInventoryOver(param1:Function) : void
      {
         this.FOnInventoryOver = param1;
      }
      
      public function set OnInventoryOut(param1:Function) : void
      {
         this.FOnInventoryOut = param1;
      }
      
      public function set OnMountJade(param1:Function) : void
      {
         this.FOnMountJade = param1;
      }
      
      public function set OnUnmountJade(param1:Function) : void
      {
         this.FOnUnmountJade = param1;
      }
      
      public function set FlyText(param1:Function) : void
      {
         this.FFlyText = param1;
      }
      
      public function set ResultCode(param1:int) : void
      {
         this.FResultCode = param1;
         this.FReplyReady = true;
      }
      
      public function set UpdateHeroPower(param1:Function) : void
      {
         this.FUpdateHeroPower = param1;
      }
      
      public function Update() : void
      {
         var selectedEquipmentId:uint = 0;
         var equipmentIndex:int = 0;
         var currentEquipment:TEquipment = null;
         selectedEquipmentId = this.FCurrentShowEquipment != null ? this.FCurrentShowEquipment.Identifier : 0;
         if(this.FCurrentShowTagIndex >= 0)
         {
            this.SelectEquipmentsByTabIndex(this.FCurrentShowTagIndex,this.FCurrentShowEquipmentBag);
            this.FCurrentShowEquipment = null;
            equipmentIndex = 0;
            while(equipmentIndex < this.FCurrentShowEquipmentBag.Count)
            {
               currentEquipment = this.FCurrentShowEquipmentBag.GetInventoryByIndex(equipmentIndex) as TEquipment;
               if(currentEquipment != null && currentEquipment.Identifier == selectedEquipmentId)
               {
                  this.FCurrentShowEquipment = currentEquipment;
                  break;
               }
               equipmentIndex++;
            }
         }
         switch(this.FCurrentState)
         {
            case STATE_READY:
               break;
            case STATE_MOSAIC:
               if(!this.FReplyReady)break;
               this.FReplyReady = false;
               this.FCurrentState = STATE_READY;
               if(this.FResultCode == 0)
               {
                  this.FFlyText(CONST_SYSTEMLANGUAGE.Jade_STRING_2);
               }
               else
               {
                  this.FFlyText(CONST_SYSTEMLANGUAGE.Jade_STRING_8);
               }
               if(this.FUpdateHeroPower != null && this.FCurrentMosaicJadeHeroID != 0)
               {
                  this.FUpdateHeroPower(this,this.FCurrentMosaicJadeHeroID);
               }
               break;
            case STATE_UNQUITE:
               if(!this.FReplyReady)break;
               this.FReplyReady = false;
               this.FCurrentState = STATE_READY;
               if(this.FResultCode == 0)
               {
                  this.FFlyText(CONST_SYSTEMLANGUAGE.Jade_STRING_3);
               }
               else
               {
                  this.FFlyText(CONST_SYSTEMLANGUAGE.Jade_STRING_9);
               }
               if(this.FUpdateHeroPower != null && this.FCurrentMosaicJadeHeroID != 0)
               {
                  this.FUpdateHeroPower(this,this.FCurrentMosaicJadeHeroID);
               }
         }
         if(this.FCurrentShowTagIndex == -1)
         {
            this.UpdateHerosTag();
            this.OnSwitchTab(0);
            this.SetupHeroListPage(SLogicsCore.Character.Heros.Count + 1,0);
         }
         else
         {
            this.OnSwitchTab(this.FCurrentShowTagIndex);
            if(this.FCurrentClickSingleEquip != null)
            {
               this.FCurrentClickSingleEquip.BClick = true;
            }
         }
         this.UpdateEquipmentJadeSlot();
         this.UpdateJadeRecommend();
         this.UpdateBackpackJade();
         TJadeCommon.ProcessorUpdateSlotsRenderingState(this.FEquipmentJadeSlots);
         TJadeCommon.ProcessorUpdateSlotsRenderingState(this.FBackpackSlots);
      }
      
      public function get PendingRequest():Boolean {return this.FCurrentState != STATE_READY;}
      public function Reset() : void
      {
         this.FCurrentState = STATE_READY;this.FReplyReady = false;
         this.ResetHeroTag();
         this.ResetEquipments();
         this.ResetEquipmentJade();
         this.ResetJadeRecommend();
         this.ResetBackpackJade();
         this.FPageIndexHeroList = 0;
         this.FCurrentShowEquipmentName.text = "";
         this.FJadeLevelComboBox.HideComboBoxList();
         this.FJadeTypeComboBox.HideComboBoxList();
      }
   }
}

