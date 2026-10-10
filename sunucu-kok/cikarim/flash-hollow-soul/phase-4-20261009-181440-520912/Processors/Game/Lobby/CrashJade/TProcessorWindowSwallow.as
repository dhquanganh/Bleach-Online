package Processors.Game.Lobby.CrashJade
{
   import Components.Pages.TUIPage;
   import Components.ScrollBar.TScrollBar;
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Queries.TQueryUInt;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.Characters.THero;
   import Logics.CrashJade.TCrashJadeData;
   import Logics.DatebaseVO.VO.TCrashedJade;
   import Logics.Inventories.TCrashJade;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class TProcessorWindowSwallow extends TProcessorLobbyWindow
   {
      
      protected static const AttributeFormat:String = "%0:%1";
      
      protected static const LevelFormat:String = "LV.%0";
      
      protected const AttMax:uint = 2;
      
      protected var SlotNum:int = 20;
      
      protected var CommandNum:int = 5;
      
      protected var SelectCommond_BackPackAll:int = 0;
      
      protected var SelectCommand_GreenJade:int = 1;
      
      protected var SelectCommand_BlueJade:int = 2;
      
      protected var SelectCommand_PurpleJade:int = 3;
      
      protected var SelectCommand_GoldJade:int = 4;
      
      protected var SelectState_Unselect:int = 1;
      
      protected var SelectState_Select:int = 2;
      
      protected var FMainScene:Sprite;
      
      protected var FSlotDes:TUISlot;
      
      protected var FCurrentLevel:TextField;
      
      protected var FCurrentAttribute:Vector.<TextField>;
      
      protected var FNextLevel:TextField;
      
      protected var FNextAttribute:Vector.<TextField>;
      
      protected var FTFBarLevel:TextField;
      
      protected var FSchedulBar:Sprite;
      
      protected var FRedBar:Sprite;
      
      protected var FIfFlash:Boolean;
      
      protected var FCurrentAngle:Number;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FJadeAll:TInventories;
      
      protected var FJadeFirstSelect:TInventories;
      
      protected var FJadeSecondSelect:Vector.<int>;
      
      protected var FUIPage:TUIPage;
      
      protected var FSelectableItem:MovieClip;
      
      protected var FBtnSwallow:TUIButton;
      
      protected var FBtnClose:TUIButton;
      
      protected var FScroolUI:TScrollBar;
      
      protected var FCurrentSelectLable:TextField;
      
      protected var FBtnGetDown:TUIButton;
      
      protected var FGetDownItems:Vector.<TUIButton>;
      
      protected var FCurrentSelectCommand:int;
      
      protected var FCurrentPageIndex:int;
      
      protected var CommandLables:Vector.<String>;
      
      protected var FCrashJade:TCrashJade;
      
      protected var FCrashJadeData:TCrashJadeData;
      
      public function TProcessorWindowSwallow(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(Visible)
         {
            this.UpdateSlot();
            this.UpdateSheduelBarFlash();
         }
      }
      
      public function UIDipatch() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:int = 0;
         var _loc3_:TUISlot = null;
         var _loc4_:TextField = null;
         this.FMainScene = TUtilityReflection.CreateDisplayObjectInstance("JadeSwallow") as Sprite;
         addChild(this.FMainScene);
         this.FSlotDes = new TUISlot(this);
         this.FSlotDes.Resource = this.FMainScene["SlotDes"];
         this.FSlotDes.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FSlotDes.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FSlotDes.OnQueryEdgeColor = this.SlotsOnQueryEdgeColor;
         this.FSlotDes.IsSelected = false;
         TJadeCommon.InitSlot(this.FSlotDes);
         this.FSlotDes.Init();
         this.FCurrentAttribute = new Vector.<TextField>();
         this.FNextAttribute = new Vector.<TextField>();
         _loc2_ = 0;
         while(_loc2_ < this.AttMax)
         {
            _loc4_ = this.FMainScene["CurrentAttribute_" + _loc2_];
            this.FCurrentAttribute.push(_loc4_);
            _loc4_ = this.FMainScene["NextAttribute_" + _loc2_];
            this.FNextAttribute.push(_loc4_);
            _loc2_++;
         }
         this.FCurrentLevel = this.FMainScene["CurrentLevel"];
         this.FNextLevel = this.FMainScene["NextLevel"];
         this.FTFBarLevel = this.FMainScene["SchedulBar"]["Level"];
         this.FSchedulBar = this.FMainScene["SchedulBar"]["bar"]["mask"];
         this.FRedBar = this.FMainScene["SchedulBar"]["bar"]["RedBar"];
         this.FCurrentAngle = 0;
         this.FSlots = new Vector.<TUISlot>();
         _loc1_ = this.FMainScene["SlotPanle"];
         _loc2_ = 0;
         while(_loc2_ < this.SlotNum)
         {
            _loc3_ = new TUISlot(this);
            _loc3_.Resource = _loc1_["Slot" + _loc2_];
            _loc3_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc3_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            _loc3_.OnClick = this.SlotOnClick;
            _loc3_.OnQueryEdgeColor = this.SlotsOnQueryEdgeColor;
            _loc3_.IsSelected = false;
            TJadeCommon.InitSlot(_loc3_);
            _loc3_.Init();
            this.FSlots.push(_loc3_);
            _loc2_++;
         }
         this.FJadeAll = new TInventories();
         this.FJadeFirstSelect = new TInventories();
         this.FJadeSecondSelect = new Vector.<int>();
         this.FUIPage = new TUIPage(this);
         this.FUIPage.ButtonPrevious.Substrate = this.FMainScene["MC_PageLeft"];
         this.FUIPage.ButtonNext.Substrate = this.FMainScene["MC_PageRight"];
         this.FUIPage.LabelPage = this.FMainScene["TF_Page"];
         this.FUIPage.PageSize = this.SlotNum;
         this.FUIPage.OnChangePage = this.OnPageSwitch;
         this.FUIPage.Init();
         this.FSelectableItem = this.FMainScene["Selectable"]["Btn_ShowALLEquip"];
         this.FSelectableItem.addEventListener(MouseEvent.CLICK,this.BtnSelectableItemOnClick);
         this.FBtnSwallow = new TUIButton();
         this.FBtnSwallow.Substrate = this.FMainScene["BtnSwallow"];
         this.FBtnSwallow.OnClick = this.BtnSwallowOnClick;
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainScene["btn_close"];
         this.FBtnClose.OnClick = this.BtnCloseOnClick;
         this.UILocation();
         this.InitScroolBar();
      }
      
      public function UILocation() : void
      {
         this.FCurrentSelectCommand = 0;
         this.FCurrentPageIndex = 0;
         this.CommandLables = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_19);
      }
      
      public function InitScroolBar() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:int = 0;
         var _loc3_:TUIButton = null;
         _loc1_ = this.FMainScene["SelectPanle"];
         this.FGetDownItems = new Vector.<TUIButton>();
         this.FScroolUI = new TScrollBar(_loc1_["mc_list"],80);
         _loc2_ = 0;
         while(_loc2_ < this.CommandNum)
         {
            _loc3_ = new TUIButton();
            _loc3_.Substrate = TUtilityReflection.CreateDisplayObjectInstance("MC_Item") as MovieClip;
            _loc3_.OnClick = this.BtnItemOnClick;
            _loc3_.Substrate["tf_into"].text = this.CommandLables[_loc2_];
            _loc3_.Tag = _loc2_;
            this.FGetDownItems.push(_loc3_);
            this.FScroolUI.AddItem(_loc3_.Substrate);
            _loc2_++;
         }
         this.FCurrentSelectLable = _loc1_["Command"]["tf_curInfo"];
         this.FBtnGetDown = new TUIButton();
         this.FBtnGetDown.Substrate = _loc1_["Command"]["btn_showlist"];
         this.FBtnGetDown.OnClick = this.BtnGetDownOnClick;
         this.FScroolUI.ScrollToUp();
         this.FScroolUI.Visible = false;
      }
      
      protected function FileterBaseJade(param1:TInventory) : Boolean
      {
         return param1.Quality <= this.FCrashJade.Quality;
      }
      
      protected function InitBaseJade() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TInventory = null;
         var _loc4_:TInventories = null;
         _loc4_ = SLogicsCore.Character.CrashJade;
         this.FJadeAll.Clear();
         _loc2_ = _loc4_.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = _loc4_.GetInventoryByIndex(_loc1_);
            if(this.FileterBaseJade(_loc3_))
            {
               this.FJadeAll.Add(_loc3_);
            }
            _loc1_++;
         }
         if(this.FSelectableItem.currentFrame == this.SelectState_Unselect)
         {
            return;
         }
         _loc2_ = int(SLogicsCore.Character.Heros.Count);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.GetCrashJadeByHero(SLogicsCore.Character.Heros.GetHeroByIndex(_loc1_),this.FJadeAll);
            _loc1_++;
         }
      }
      
      protected function GetCrashJadeByHero(param1:THero, param2:TInventories) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TInventory = null;
         _loc4_ = param1.CrashJadeMounted.Capacity;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = param1.CrashJadeMounted.GetInventoryByIndex(_loc3_);
            if(_loc5_ != null && this.FileterBaseJade(_loc5_))
            {
               param2.Add(_loc5_);
            }
            _loc3_++;
         }
      }
      
      protected function SelectCrashJadeByCommand(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.FCurrentSelectCommand = param1;
         this.FJadeFirstSelect.Clear();
         switch(param1)
         {
            case this.SelectCommond_BackPackAll:
               _loc3_ = this.FJadeAll.Count;
               _loc2_ = 0;
               while(_loc2_ < _loc3_)
               {
                  this.FJadeFirstSelect.Add(this.FJadeAll.GetInventoryByIndex(_loc2_));
                  _loc2_++;
               }
               break;
            case this.SelectCommand_GreenJade:
               this.SelectCrashJadeByQuality(CONST_COMMON.QUALITY_Green,this.FJadeAll,this.FJadeFirstSelect);
               break;
            case this.SelectCommand_BlueJade:
               this.SelectCrashJadeByQuality(CONST_COMMON.QUALITY_Blue,this.FJadeAll,this.FJadeFirstSelect);
               break;
            case this.SelectCommand_PurpleJade:
               this.SelectCrashJadeByQuality(CONST_COMMON.QUALITY_Purple,this.FJadeAll,this.FJadeFirstSelect);
               break;
            case this.SelectCommand_GoldJade:
               this.SelectCrashJadeByQuality(CONST_COMMON.QUALITY_Yellow,this.FJadeAll,this.FJadeFirstSelect);
         }
         this.FJadeFirstSelect.DeleteInventoryByLongIdentifier(this.FCrashJade.Identifier0,this.FCrashJade.Identifier1);
         this.FCurrentSelectLable.text = this.CommandLables[param1];
      }
      
      protected function SelectCrashJadeByQuality(param1:int, param2:TInventories, param3:TInventories) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TInventory = null;
         _loc5_ = param2.Count;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param2.GetInventoryByIndex(_loc4_);
            if(_loc6_.Quality == param1)
            {
               param3.Add(_loc6_);
            }
            _loc4_++;
         }
      }
      
      protected function RenderBaseInfor() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TextField = null;
         this.FSlotDes.Context = this.FCrashJade;
         this.FSlotDes.Resource["TF_CrashLevel"].text = "lv." + this.FCrashJade.Level.toString();
         this.FSlotDes.TextureAdvancedEffect = SResourcesCore.TexturesLobby.GetTextureByIdentifier(this.FCrashJade.EffectID);
         this.FCurrentLevel.text = TUtilityString.Format(LevelFormat,this.FCrashJade.Level);
         _loc1_ = 0;
         while(_loc1_ < this.AttMax)
         {
            _loc3_ = this.FCurrentAttribute[_loc1_];
            if(_loc1_ < this.FCrashJade.AddAttributeType.length)
            {
               _loc3_.text = TUtilityString.Format(AttributeFormat,TUtilityLobby.GetAttributeName(this.FCrashJade.AddAttributeType[_loc1_]),this.FCrashJade.AddAttributeValue[_loc1_] <= 1 ? Number(this.FCrashJade.AddAttributeValue[_loc1_] * 100).toFixed(2) + "%" : this.FCrashJade.AddAttributeValue[_loc1_]);
            }
            else
            {
               _loc3_.text = "";
            }
            _loc1_++;
         }
         this.FTFBarLevel.text = TUtilityString.Format(LevelFormat,this.FCrashJade.Level);
         if(this.FCrashJade.NextLevelID == 0)
         {
            this.FSchedulBar.scaleX = 0;
         }
         else
         {
            this.FSchedulBar.scaleX = this.FCrashJade.Exp / this.FCrashJade.LevelUpExp;
         }
      }
      
      protected function RenderCrashJade() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TCrashJade = null;
         _loc3_ = this.FCurrentPageIndex * this.SlotNum;
         _loc4_ = _loc3_ + this.SlotNum;
         _loc4_ = _loc4_ > this.FJadeFirstSelect.Count ? this.FJadeFirstSelect.Count : _loc4_;
         _loc2_ = 0;
         _loc1_ = _loc3_;
         while(_loc1_ < _loc4_)
         {
            _loc5_ = this.FJadeFirstSelect.GetInventoryByIndex(_loc1_) as TCrashJade;
            this.FSlots[_loc2_].Context = _loc5_;
            this.FSlots[_loc2_].Resource["TF_CrashLevel"].text = "lv." + _loc5_.Level.toString();
            this.FSlots[_loc2_].TextureAdvancedEffect = SResourcesCore.TexturesLobby.GetTextureByIdentifier(_loc5_.EffectID);
            this.FSlots[_loc2_].IsSelected = this.FJadeSecondSelect.indexOf(_loc1_) != -1;
            _loc2_++;
            _loc1_++;
         }
         _loc1_ = _loc2_;
         while(_loc1_ < this.SlotNum)
         {
            this.FSlots[_loc1_].Context = null;
            this.FSlots[_loc1_].Resource["TF_CrashLevel"].text = "";
            this.FSlots[_loc1_].IsSelected = false;
            _loc1_++;
         }
      }
      
      protected function PreSelectJade() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = this.FJadeFirstSelect.Count;
         _loc1_ = _loc1_ > this.SlotNum ? this.SlotNum : _loc1_;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this.FJadeSecondSelect.push(_loc2_);
            this.FSlots[_loc2_].IsSelected = true;
            _loc2_++;
         }
         this.RenderNextLevel();
      }
      
      protected function RenderNextLevel() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TextField = null;
         var _loc6_:TCrashJade = null;
         _loc4_ = int(this.FJadeSecondSelect.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = this.FJadeFirstSelect.GetInventoryByIndex(this.FJadeSecondSelect[_loc3_]) as TCrashJade;
            _loc2_ += _loc6_.SwallowExp + _loc6_.Exp;
            _loc3_++;
         }
         _loc1_ = this.CountNewJadeLevelByAddExp(_loc2_);
         this.FNextLevel.text = TUtilityString.Format(LevelFormat,_loc1_);
         _loc3_ = 0;
         while(_loc3_ < this.AttMax)
         {
            _loc5_ = this.FNextAttribute[_loc3_];
            if(_loc3_ < this.FCrashJade.AddAttributeType.length)
            {
               _loc5_.text = TUtilityString.Format(AttributeFormat,TUtilityLobby.GetAttributeName(this.FCrashJade.AddAttributeType[_loc3_]),this.GetAttributeValueByLevel(_loc1_,_loc3_));
            }
            else
            {
               _loc5_.text = "";
            }
            _loc3_++;
         }
         this.FTFBarLevel.text = TUtilityString.Format(LevelFormat,_loc1_);
         if(this.FCrashJade.Level != _loc1_)
         {
            this.FSchedulBar.scaleX = 1;
            this.FIfFlash = true;
         }
         else
         {
            this.FSchedulBar.scaleX = (this.FCrashJade.Exp + _loc2_) / this.FCrashJade.LevelUpExp;
            this.FIfFlash = false;
            this.FRedBar.alpha = 1;
         }
      }
      
      protected function CountNewJadeLevelByAddExp(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc3_:TCrashedJade = null;
         var _loc4_:TCrashJade = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc5_ = this.FCrashJade.Exp + param1;
         _loc2_ = int(this.FCrashJade.IDTemplate);
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_CrashJade,_loc2_) as TCrashedJade;
         while(_loc3_.NextID != 0)
         {
            if(_loc3_.LevelExp > _loc5_)
            {
               break;
            }
            _loc2_++;
            _loc5_ -= _loc3_.LevelExp;
            _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_CrashJade,_loc2_) as TCrashedJade;
         }
         return (_loc2_ - 1) % 100 + 1;
      }
      
      protected function GetAttributeValueByLevel(param1:int, param2:uint) : String
      {
         var _loc3_:TCrashedJade = null;
         var _loc4_:uint = 0;
         _loc4_ = this.FCrashJade.IDTemplate / 100;
         _loc4_ = _loc4_ * 100 + param1;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_CrashJade,_loc4_) as TCrashedJade;
         return _loc3_.AddValue[param2] <= 1 ? _loc3_.AddValue[param2] * 100 + "%" : _loc3_.AddValue[param2].toString();
      }
      
      protected function UpdateSlot() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.SlotNum)
         {
            this.FSlots[_loc1_].Update();
            _loc1_++;
         }
         this.FSlotDes.Update();
      }
      
      protected function SetupPage(param1:int, param2:int, param3:TUIPage) : void
      {
         param3.TotalQuantity = param1;
         param3.Update();
         param3.PageIndex = param2;
      }
      
      protected function UpdateSheduelBarFlash() : void
      {
         if(this.FIfFlash)
         {
            this.FRedBar.alpha = (1 + Math.sin(this.FCurrentAngle)) / 2;
            this.FCurrentAngle += 0.2;
         }
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
      
      protected function SwallowReq(param1:Object = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TCrashJade = null;
         var _loc5_:TPacket = null;
         var _loc6_:ByteArray = null;
         if(this.FCrashJade.NextLevelID == 0)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_40));
            return;
         }
         if(TProcessorCrashJade.Busy) return;
         TProcessorCrashJade.Busy = true;
         _loc5_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CrashJade_SwallowReq);
         _loc6_ = _loc5_.Data;
         _loc6_.writeUnsignedInt(this.FCrashJade.Identifier0);
         _loc6_.writeUnsignedInt(this.FCrashJade.Identifier1);
         _loc6_.writeUnsignedInt(this.FCrashJade.MountedHeroID);
         _loc6_.writeShort(this.FJadeSecondSelect.length);
         _loc3_ = int(this.FJadeSecondSelect.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FJadeFirstSelect.GetInventoryByIndex(this.FJadeSecondSelect[_loc2_]) as TCrashJade;
            _loc6_.writeUnsignedInt(_loc4_.Identifier0);
            _loc6_.writeUnsignedInt(_loc4_.Identifier1);
            _loc6_.writeUnsignedInt(_loc4_.MountedHeroID);
            _loc2_++;
         }
         SNetworkCore.Transceiver.PacketTransmit(_loc5_);
      }
      
      protected function BtnItemOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         _loc3_ = param1 as TUIButton;
         this.SelectCrashJadeByCommand(_loc3_.Tag);
         this.SetupPage(this.FJadeFirstSelect.Count,0,this.FUIPage);
         this.RenderCrashJade();
         this.FScroolUI.Visible = false;
         this.FJadeSecondSelect.length = 0;
         this.CancleSelectState();
      }
      
      protected function OnPageSwitch(param1:Object, param2:int) : void
      {
         this.FCurrentPageIndex = param2;
         this.RenderCrashJade();
      }
      
      protected function BtnSwallowOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TCrashJade = null;
         _loc3_ = false;
         _loc5_ = int(this.FJadeSecondSelect.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = this.FJadeFirstSelect.GetInventoryByIndex(this.FJadeSecondSelect[_loc4_]) as TCrashJade;
            if(_loc6_.MountedHeroID != 0)
            {
               _loc3_ = true;
               break;
            }
            _loc4_++;
         }
         if(_loc3_)
         {
            SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_20);
            SUtilityOverLayer.UIWindowConfirmation.OnOK = this.SwallowReq;
            SUtilityOverLayer.UIWindowConfirmation.Visible = true;
         }
         else
         {
            this.SwallowReq();
         }
      }
      
      protected function BtnSelectableItemOnClick(param1:MouseEvent) : void
      {
         if(this.FSelectableItem.currentFrame == this.SelectState_Select)
         {
            this.FSelectableItem.gotoAndStop(this.SelectState_Unselect);
            this.CancleSelectState();
         }
         else
         {
            this.FSelectableItem.gotoAndStop(this.SelectState_Select);
         }
         this.InitBaseJade();
         this.SelectCrashJadeByCommand(this.FCurrentSelectCommand);
         this.SetupPage(this.FJadeFirstSelect.Count,this.FCurrentPageIndex,this.FUIPage);
         this.RenderCrashJade();
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
         this.Reset();
      }
      
      protected function BtnGetDownOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FScroolUI.Visible = !this.FScroolUI.Visible;
      }
      
      protected function SlotOnClick(param1:Object, param2:TInventory) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TUISlot = null;
         var _loc7_:TCrashJade = null;
         _loc6_ = param1 as TUISlot;
         _loc4_ = this.FSlots.indexOf(_loc6_);
         _loc3_ = this.FCurrentPageIndex * this.SlotNum + _loc4_;
         _loc5_ = this.FJadeSecondSelect.indexOf(_loc3_);
         if(_loc5_ == -1)
         {
            _loc6_.IsSelected = true;
            this.FJadeSecondSelect.push(_loc3_);
         }
         else
         {
            _loc6_.IsSelected = false;
            this.FJadeSecondSelect.splice(_loc5_,1);
         }
         this.RenderNextLevel();
      }
      
      protected function CancleSelectState() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FJadeSecondSelect.length = 0;
         this.RenderNextLevel();
         _loc2_ = int(this.FSlots.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSlots[_loc1_].IsSelected = false;
            _loc1_++;
         }
      }
      
      public function Show(param1:TCrashJadeData, param2:TCrashJade) : void
      {
         this.FCrashJade = param2;
         this.FCrashJadeData = param1;
         this.Visible = true;
         this.InitBaseJade();
         this.SelectCrashJadeByCommand(this.SelectCommond_BackPackAll);
         this.SetupPage(this.FJadeFirstSelect.Count,0,this.FUIPage);
         this.FCurrentPageIndex = 0;
         this.RenderBaseInfor();
         this.RenderCrashJade();
         this.RenderNextLevel();
         this.PreSelectJade();
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         this.FScroolUI.Visible = false;
         this.FScroolUI.ScrollToUp();
         this.FSelectableItem.gotoAndStop(this.SelectState_Unselect);
         this.CancleSelectState();
         this.FJadeFirstSelect.Clear();
         this.FJadeAll.Clear();
         this.RenderNextLevel();
         _loc1_ = 0;
         while(_loc1_ < this.SlotNum)
         {
            this.FSlots[_loc1_].Context = null;
            _loc1_++;
         }
         this.FCurrentAngle = 0;
         this.FIfFlash = false;
         this.FRedBar.alpha = 1;
         this.FSlotDes.Context = null;
      }
      
      public function SwallowNotify() : void
      {
         this.CancleSelectState();
         this.InitBaseJade();
         this.FRedBar.alpha = 1;
         this.SelectCrashJadeByCommand(this.FCurrentSelectCommand);
         this.SetupPage(this.FJadeFirstSelect.Count,0,this.FUIPage);
         this.FCurrentPageIndex = 0;
         this.RenderCrashJade();
         this.RenderBaseInfor();
         this.RenderNextLevel();
         this.PreSelectJade();
      }
   }
}

