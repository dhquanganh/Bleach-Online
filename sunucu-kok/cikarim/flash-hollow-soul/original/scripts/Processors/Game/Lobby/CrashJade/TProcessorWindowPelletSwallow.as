package Processors.Game.Lobby.CrashJade
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Queries.TQueryUInt;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.CrashJade.TCrashJadeData;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.DatebaseVO.VO.TCrashedJade;
   import Logics.Inventories.TCrashJade;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_CONFIGVALUE;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   
   public class TProcessorWindowPelletSwallow extends TProcessorLobbyWindow
   {
      
      protected static const AttributeFormat:String = "%0:%1";
      
      protected static const LevelFormat:String = "LV.%0";
      
      protected const AttMax:uint = 2;
      
      protected var FMainUI:Sprite;
      
      protected var FTFCurrentLevel:TextField;
      
      protected var FTFCurrentAttribute:Vector.<TextField>;
      
      protected var FTFLevel:TextField;
      
      protected var FTFNextLevel:TextField;
      
      protected var FTFNextAttribute:Vector.<TextField>;
      
      protected var FSlotDes:TUISlot;
      
      protected var FExperienceBar:Sprite;
      
      protected var FRedBar:Sprite;
      
      protected var FIfFlash:Boolean;
      
      protected var FCurrentAngle:Number;
      
      protected var FTFCurrentPellet:TextField;
      
      protected var FTFSwallowPellet:TextField;
      
      protected var FBtnSubNum:TUIButton;
      
      protected var FBtnAddNum:TUIButton;
      
      protected var FBtnSwallow:TUIButton;
      
      protected var FBtnClose:TUIButton;
      
      protected var FMaxNumCanSwallow:int;
      
      protected var FCurrentSelectNum:int;
      
      protected var FPelletExp:int;
      
      protected var FCrashJadeData:TCrashJadeData;
      
      protected var FCrashJade:TCrashJade;
      
      public function TProcessorWindowPelletSwallow(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(Visible)
         {
            this.UpdateSheduelBarFlash();
            this.FSlotDes.Update();
         }
      }
      
      public function UIDispatch() : void
      {
         var _loc1_:TConfigValue = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TextField = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("SwallowPullet") as Sprite;
         addChild(this.FMainUI);
         this.FTFCurrentLevel = this.FMainUI["CurrentLevel"];
         this.FTFCurrentAttribute = new Vector.<TextField>();
         this.FTFNextAttribute = new Vector.<TextField>();
         _loc2_ = 0;
         while(_loc2_ < this.AttMax)
         {
            _loc4_ = this.FMainUI["CurrentAttribute_" + _loc2_];
            this.FTFCurrentAttribute.push(_loc4_);
            _loc4_ = this.FMainUI["NextAttribute_" + _loc2_];
            this.FTFNextAttribute.push(_loc4_);
            _loc2_++;
         }
         this.FTFLevel = this.FMainUI["ExperienceBar"]["Level"];
         this.FTFNextLevel = this.FMainUI["NextLevel"];
         this.FSlotDes = new TUISlot(this);
         this.FSlotDes.Resource = this.FMainUI["SlotDes"];
         this.FSlotDes.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FSlotDes.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FSlotDes.OnQueryEdgeColor = this.SlotsOnQueryEdgeColor;
         this.FSlotDes.IsSelected = false;
         TJadeCommon.InitSlot(this.FSlotDes);
         this.FSlotDes.Init();
         this.FExperienceBar = this.FMainUI["ExperienceBar"]["bar"]["mask"];
         this.FRedBar = this.FMainUI["ExperienceBar"]["bar"]["RedBar"];
         this.FIfFlash = false;
         this.FCurrentAngle = 0;
         this.FTFCurrentPellet = this.FMainUI["CurrentPellet"];
         this.FTFSwallowPellet = this.FMainUI["SwallowPellet"];
         this.FTFSwallowPellet.autoSize = "left";
         this.FTFSwallowPellet.selectable = true;
         this.FTFSwallowPellet.type = TextFieldType.INPUT;
         this.FTFSwallowPellet.restrict = "0-9";
         this.FTFSwallowPellet.maxChars = 6;
         this.FTFSwallowPellet.addEventListener(Event.CHANGE,this.TextChange);
         this.FBtnSubNum = new TUIButton();
         this.FBtnSubNum.Substrate = this.FMainUI["BTN_Reduce"];
         this.FBtnSubNum.OnClick = this.BtnSubOnClick;
         this.FBtnAddNum = new TUIButton();
         this.FBtnAddNum.Substrate = this.FMainUI["BTN_Increase"];
         this.FBtnAddNum.OnClick = this.BtnAddOnClick;
         this.FBtnSwallow = new TUIButton();
         this.FBtnSwallow.Substrate = this.FMainUI["BtnSwallow"];
         this.FBtnSwallow.OnClick = this.BtnSwallowOnClick;
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainUI["btn_close"];
         this.FBtnClose.OnClick = this.BtnCloseOnClick;
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.CrashJade_PelletExp) as TConfigValue;
         this.FPelletExp = _loc1_.Value as int;
      }
      
      public function UILocation() : void
      {
      }
      
      protected function RenderBaseInfor() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TextField = null;
         this.FTFCurrentLevel.text = TUtilityString.Format(LevelFormat,this.FCrashJade.Level);
         _loc2_ = 0;
         while(_loc2_ < this.AttMax)
         {
            _loc4_ = this.FTFCurrentAttribute[_loc2_];
            if(_loc2_ < this.FCrashJade.AddAttributeType.length)
            {
               _loc4_.text = TUtilityString.Format(AttributeFormat,TUtilityLobby.GetAttributeName(this.FCrashJade.AddAttributeType[_loc2_]),this.FCrashJade.AddAttributeValue[_loc2_] <= 1 ? Number(this.FCrashJade.AddAttributeValue[_loc2_] * 100).toFixed(2) + "%" : this.FCrashJade.AddAttributeValue[_loc2_]);
            }
            else
            {
               _loc4_.text = "";
            }
            _loc2_++;
         }
         this.FTFLevel.text = TUtilityString.Format(LevelFormat,this.FCrashJade.Level);
         if(this.FCrashJade.NextLevelID == 0)
         {
            this.FExperienceBar.scaleX = 0;
         }
         else
         {
            this.FExperienceBar.scaleX = this.FCrashJade.Exp / this.FCrashJade.LevelUpExp;
         }
         this.FTFCurrentPellet.text = this.FCrashJadeData.ExperiencePelletNum.toString();
         this.FSlotDes.Context = this.FCrashJade;
         this.FSlotDes.Resource["TF_CrashLevel"].text = "lv." + this.FCrashJade.Level.toString();
         this.FSlotDes.TextureAdvancedEffect = SResourcesCore.TexturesLobby.GetTextureByIdentifier(this.FCrashJade.EffectID);
      }
      
      protected function RenderNextLevel(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TextField = null;
         this.FCurrentSelectNum = param1;
         _loc2_ = this.CountJadeLevelByAddExp(this.FCurrentSelectNum * this.FPelletExp);
         this.FTFNextLevel.text = TUtilityString.Format(LevelFormat,_loc2_);
         _loc3_ = 0;
         while(_loc3_ < this.AttMax)
         {
            _loc5_ = this.FTFNextAttribute[_loc3_];
            if(_loc3_ < this.FCrashJade.AddAttributeType.length)
            {
               _loc5_.text = TUtilityString.Format(AttributeFormat,TUtilityLobby.GetAttributeName(this.FCrashJade.AddAttributeType[_loc3_]),this.GetAttributeValueByLevel(_loc2_,_loc3_));
            }
            else
            {
               _loc5_.text = "";
            }
            _loc3_++;
         }
         this.FTFLevel.text = TUtilityString.Format(LevelFormat,_loc2_);
         if(this.FCrashJade.Level != _loc2_)
         {
            this.FExperienceBar.scaleX = 1;
            this.FIfFlash = true;
         }
         else
         {
            this.FExperienceBar.scaleX = (this.FCrashJade.Exp + this.FCurrentSelectNum * this.FPelletExp) / this.FCrashJade.LevelUpExp;
            this.FIfFlash = false;
            this.FRedBar.alpha = 1;
         }
         this.FTFSwallowPellet.text = this.FCurrentSelectNum.toString();
      }
      
      protected function UpdateSheduelBarFlash() : void
      {
         if(this.FIfFlash)
         {
            this.FRedBar.alpha = (1 + Math.sin(this.FCurrentAngle)) / 2;
            this.FCurrentAngle += 0.2;
         }
      }
      
      protected function CountJadeLevelByAddExp(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc3_:TCrashedJade = null;
         param1 += this.FCrashJade.Exp;
         _loc2_ = int(this.FCrashJade.IDTemplate);
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_CrashJade,_loc2_) as TCrashedJade;
         while(_loc3_.NextID != 0)
         {
            if(_loc3_.LevelExp > param1)
            {
               break;
            }
            _loc2_++;
            param1 -= _loc3_.LevelExp;
            _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_CrashJade,_loc2_) as TCrashedJade;
         }
         return _loc2_ % 100;
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
      
      protected function CheckSelectNum(param1:int) : int
      {
         if(param1 < 0)
         {
            return 0;
         }
         if(param1 > this.FCrashJadeData.ExperiencePelletNum)
         {
            return this.FCrashJadeData.ExperiencePelletNum;
         }
         return param1;
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
      
      protected function BtnSubOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FCurrentSelectNum = this.CheckSelectNum(this.FCurrentSelectNum - 1);
         this.RenderNextLevel(this.FCurrentSelectNum);
      }
      
      protected function BtnAddOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FCurrentSelectNum = this.CheckSelectNum(this.FCurrentSelectNum + 1);
         this.RenderNextLevel(this.FCurrentSelectNum);
      }
      
      protected function BtnSwallowOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         if(this.FCrashJade.NextLevelID == 0)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_40));
            return;
         }
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CrashJade_SwallowPelletReq);
         _loc3_.Data.writeUnsignedInt(this.FCrashJade.Identifier0);
         _loc3_.Data.writeUnsignedInt(this.FCrashJade.Identifier1);
         _loc3_.Data.writeUnsignedInt(this.FCrashJade.MountedHeroID);
         _loc3_.Data.writeUnsignedInt(this.FCurrentSelectNum);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
         this.Reset();
      }
      
      protected function InventoryOnMouseMove(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FCrashJade,null);
      }
      
      protected function InventoryOnMouseOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FCrashJade,null);
      }
      
      protected function TextChange(param1:Event) : void
      {
         var _loc2_:int = 0;
         _loc2_ = parseInt(this.FTFSwallowPellet.text);
         this.RenderNextLevel(this.CheckSelectNum(_loc2_));
      }
      
      public function Show(param1:TCrashJadeData, param2:TCrashJade) : void
      {
         this.FCrashJadeData = param1;
         this.FCrashJade = param2;
         this.RenderBaseInfor();
         this.RenderNextLevel(this.FCurrentSelectNum);
         this.Visible = true;
      }
      
      protected function Reset() : void
      {
         this.FCurrentSelectNum = 0;
         this.FSlotDes.Context = null;
         this.FIfFlash = false;
         this.FCurrentAngle = 0;
         this.FRedBar.alpha = 1;
      }
      
      public function SwallowPelletNotify() : void
      {
         this.RenderBaseInfor();
         this.FCurrentSelectNum = 0;
         this.FRedBar.alpha = 1;
         this.RenderNextLevel(this.FCurrentSelectNum);
      }
   }
}

