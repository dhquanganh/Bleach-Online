package Processors.Game.Lobby.Inspector
{
   import Components.Standard.TUIButton;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.SensitiveWord.*;
   import Foundation.Timing.*;
   import Foundation.Timing.Spaces.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import LocalStorages.*;
   import Logics.*;
   import Logics.Achievenment.TAchievementInfor;
   import Logics.Agent.*;
   import Logics.AntiAddiction.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HyperStrings.*;
   import Logics.Inventories.*;
   import Logics.Skills.*;
   import Logics.Spaces.*;
   import Logics.Streamization.Characters.*;
   import Logics.Streamization.HyperStrings.*;
   import Logics.Streamization.Inventories.*;
   import Processors.Game.Lobby.Chat.HyperString.Importers.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Common.Achievement.TProcessorWindowGetAchievementEffect;
   import Processors.Game.Lobby.Common.Hero.*;
   import Processors.Game.Lobby.Common.Inventory.*;
   import Processors.Game.Lobby.Common.Players.*;
   import Processors.Game.Lobby.HeroChange.TProcessorWindowHeroChangeMainUI;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.*;
   import Rendering.Overlayers.GeneralStar.*;
   import Rendering.Overlayers.Hints.*;
   import Rendering.Overlayers.Inventories.*;
   import Resources.Constants.*;
   import Utilities.UI.Overlayers.*;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.text.TextField;
   import flash.utils.*;
   
   use namespace LogicsSpace;
   use namespace TimingSpace;
   
   public class TProcessorInspector extends TProcessorLobbyWindows
   {
      
      public static const STAGE_Width:Number = CONST_COMMON.STAGE_Width;
      
      public static const STAGE_Height:Number = CONST_COMMON.STAGE_Height;
      
      protected static const SIZE_PlayerAssets_Width:uint = 420;
      
      protected static const SIZE_PlayerAssets_Height:uint = 548;
      
      protected static const SYNCHRONIZE_SEVERY_TIME:uint = CONST_INSPECTOR.SYNCHRONIZE_SEVERY_TIME;
      
      protected static const TIME_INTERVAL_InspectorAntiAddiction:int = CONST_INSPECTOR.TIME_INTERVAL_InspectorAntiAddiction;
      
      protected static const TIME_Radix_InspectorAntiAddictions:Vector.<int> = CONST_INSPECTOR.TIME_Radix_InspectorAntiAddictions;
      
      protected static const TIME_AntiAddictionUpperLimit:int = CONST_INSPECTOR.TIME_AntiAddictionUpperLimit;
      
      public static const TYPE_ANTIADDICTION_ADULTHOOD:uint = CONST_INSPECTOR.TYPE_ANTIADDICTION_ADULTHOOD;
      
      protected static const CATEGORY_Normal:uint = CONST_INVENTORY.CATEGORY_Normal;
      
      protected static const CATEGORY_Equipment:uint = CONST_INVENTORY.CATEGORY_Equipment;
      
      protected static const CATEGORY_Ornament:uint = CONST_INVENTORY.CATEGORY_Ornament;
      
      protected var FAntiAddiction:TAntiAddiction;
      
      protected var FTickInspectorAntiAddiction:int;
      
      protected var FIsAntiAddictionState:Boolean;
      
      protected var FAntiAddictionsState:Vector.<Boolean>;
      
      protected var FTickReference:int;
      
      protected var FIsInitialize:Boolean;
      
      protected var FProcessorWindowPlayerAssets:TProcessorWindowPlayerAssets;
      
      protected var FProcessorWindowInventoryInfor:TProcessorWindowInventoryInfor;
      
      protected var FProcessorWindowHeroDescription:TProcessorWindowHeroDescription;
      
      protected var FProcessorWindowGetAchievementEffect:TProcessorWindowGetAchievementEffect;
      
      protected var FUnstreamizerCharacter:TUnstreamizerCharacter;
      
      protected var FHeros:THeros;
      
      protected var FUnstreamizerReference:TUnstreamizerInventoryReference;
      
      protected var FInventoryReference:TInventoryReference;
      
      protected var FSecretMallCloseTime:int;
      
      protected var FSecretMallDurationTime:int;
      
      protected var FNotifyWindow:Sprite;
      
      protected var FNotifyWindowTF:TextField;
      
      protected var FNotifyWindowBtn:TUIButton;
      
      protected var FOnChatAnnouncement:Function;
      
      protected var FOnAntiAddiction:Function;
      
      protected var FOnQuertInventoryIDRet:Function;
      
      public function TProcessorInspector(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FAntiAddiction = SLogicsCore.AntiAddiction;
         this.FAntiAddictionsState = new Vector.<Boolean>(TIME_AntiAddictionUpperLimit);
         this.FTickInspectorAntiAddiction = STimingCore.TickCount;
         this.FProcessorWindowPlayerAssets = new TProcessorWindowPlayerAssets(param2.MountPointWindow);
         this.FProcessorWindowPlayerAssets.OnInventoryOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowPlayerAssets.OnInventoryOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowPlayerAssets.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowPlayerAssets.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowPlayerAssets.OnSkillOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowPlayerAssets.OnSkillOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowInventoryInfor = new TProcessorWindowInventoryInfor(this);
         this.FProcessorWindowHeroDescription = new TProcessorWindowHeroDescription(this);
         this.FProcessorWindowHeroDescription.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowHeroDescription.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowGetAchievementEffect = new TProcessorWindowGetAchievementEffect(this);
         this.FUnstreamizerCharacter = new TUnstreamizerCharacter();
         this.FHeros = new THeros();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfCommon.LoadPrimary(CONST_COMMON.RESOURCESID_SwfCommon_ViewCharacterInfo);
         SResourcesCore.TexturesSwfCommon.LoadPrimary(CONST_COMMON.RESOURCESID_SwfCommon_ViewHeroInfo);
         SResourcesCore.ResourceBin.LoadPrimary(CONST_DATEBASEVO.RESOURCEID_Maskword);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TBins = null;
         var _loc4_:TMaskword = null;
         var _loc5_:String = null;
         var _loc6_:TConfigValue = null;
         _loc3_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Maskword);
         _loc2_ = _loc3_.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = _loc3_.GetDatebaseByIndex(_loc1_) as TMaskword;
            _loc5_ = _loc4_.Name;
            SSensitiveWord.AddKey(_loc5_);
            _loc1_++;
         }
         SSensitiveWord.Init();
         SResourcesCore.ResourceBin.DeleteByIdentifier(CONST_DATEBASEVO.RESOURCEID_Maskword);
         this.FProcessorWindowPlayerAssets.Perform_UIDispatch();
         this.FProcessorWindowInventoryInfor.Perform_UIDispatch();
         this.FProcessorWindowHeroDescription.Perform_UIDispatch();
         this.FProcessorWindowGetAchievementEffect.Perform_UIDispatch();
         this.FUnstreamizerReference = new TUnstreamizerInventoryReference();
         this.FInventoryReference = new TInventoryReference();
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.BlackMarketCountDown) as TConfigValue;
         this.FSecretMallDurationTime = _loc6_.Value as int;
         this.FSecretMallDurationTime *= 1000;
         this.FNotifyWindow = TUtilityReflection.CreateDisplayObjectInstance("MC_Information") as Sprite;
         addChild(this.FNotifyWindow);
         this.FNotifyWindow.visible = false;
         this.FNotifyWindowTF = this.FNotifyWindow["TF_Text"];
         this.FNotifyWindowTF.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BlackMarket_08);
         this.FNotifyWindowBtn = new TUIButton();
         this.FNotifyWindowBtn.Substrate = this.FNotifyWindow["Btn_Ok"];
         this.FNotifyWindowBtn.OnClick = this.SecretMallConfirm;
         this.FNotifyWindow.x = CONST_COMMON.STAGE_Width - this.FNotifyWindow.width;
         this.FNotifyWindow.y = CONST_COMMON.STAGE_Height - this.FNotifyWindow.height - 80;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Inspector_CharInfoRet,this.PerformPacket_SC_CharInfoRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Inspector_QuertInventoryRet,this.PerformPacket_SC_InventoryInforRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Inspector_QuertServerTimeRet,this.PacketPerform_SC_QuertServerTime);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Inspector_QuertInventoryIDRet,this.PacketPerform_SC_QuertInventoryIDRet);
      }
      
      protected function PerformPacket_SC_CharInfoRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc2_ = int(param1.Data.readUnsignedInt());
         if(_loc2_ != 0)
         {
            return;
         }
         _loc3_ = TUtilityString.FetchUTF(param1.Data);
         this.FUnstreamizerCharacter.UnstreamizeHeros(param1.Data,this.FHeros,null);
         this.FHeros.GetHeroByIndex(0).Quality = param1.Data.readUnsignedInt();
         this.FHeros.GetHeroByIndex(0).Name = _loc3_;
         this.FProcessorWindowPlayerAssets.Heros = this.FHeros;
         this.FProcessorWindowPlayerAssets.KnifeOfKillSoulID = param1.Data.readUnsignedInt();
         TProcessorWindowHeroChangeMainUI.StarCounts = {};
         _loc4_ = param1.Data.readUnsignedShort();
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            TProcessorWindowHeroChangeMainUI.StarCounts[String(param1.Data.readUnsignedInt())] = int(param1.Data.readUnsignedByte());
            _loc5_++;
         }
         this.ProcessorPopupWindowHider();
         this.FProcessorWindowPlayerAssets.X = (STAGE_Width - SIZE_PlayerAssets_Width) / 2;
         this.FProcessorWindowPlayerAssets.Y = (STAGE_Height - SIZE_PlayerAssets_Height) / 2;
         this.FProcessorWindowPlayerAssets.Show();
      }
      
      protected function PerformPacket_SC_InventoryInforRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:uint = 0;
         _loc3_ = param1.Data;
         _loc2_ = int(_loc3_.readUnsignedInt());
         if(_loc2_ != 0)
         {
            _loc3_.readUnsignedByte();
            _loc4_ = _loc3_.readUnsignedInt();
            this.ShowInventoryInforByData(_loc4_);
            return;
         }
         this.FUnstreamizerReference.Unstreamize(_loc3_,this.FInventoryReference,null);
         this.ShowInventoryInforByData(0);
      }
      
      protected function ShowInventoryInforByData(param1:uint) : void
      {
         if(param1 != 0)
         {
            this.FUnstreamizerReference.UnstreamizeGenerateInventoryByIdentified(null,this.FInventoryReference,param1);
         }
         this.ProcessorPopupWindowHider();
         this.AddMouseUpEventListener();
         this.FProcessorWindowInventoryInfor.Inventory = this.FInventoryReference.Inventory;
         this.FProcessorWindowInventoryInfor.Show();
         this.FInventoryReference.Inventory = null;
      }
      
      protected function PacketPerform_SC_QuertServerTime(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         var _loc7_:ByteArray = null;
         _loc7_ = param1.Data;
         _loc2_ = _loc7_.readUnsignedInt();
         if(_loc2_ == 0)
         {
            _loc3_ = _loc7_.readInt();
            _loc4_ = _loc7_.readUnsignedInt();
            _loc5_ = _loc7_.readUnsignedInt();
            _loc6_ = _loc7_.readInt();
            STimingCore.TimingSpace::SetTimeZone(_loc3_);
            STimingCore.TimingSpace::SetServerTime(_loc4_);
            STimingCore.TimingSpace::SetServerStartTime(_loc5_);
            STimingCore.TimingSpace::SetServerStartTimeZone(_loc6_);
         }
      }
      
      protected function PacketPerform_SC_QuertInventoryIDRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         _loc3_ = param1.Data;
         _loc2_ = _loc3_.readUnsignedInt();
         if(_loc2_ != 0)
         {
            return;
         }
         _loc4_ = _loc3_.readUnsignedInt();
         _loc5_ = _loc3_.readUnsignedInt();
         _loc6_ = _loc3_.readUnsignedInt();
         _loc7_ = _loc3_.readUnsignedInt();
         if(this.FOnQuertInventoryIDRet != null)
         {
            this.FOnQuertInventoryIDRet(this,_loc4_,_loc5_,_loc6_,_loc7_);
         }
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:Boolean = false;
         super.LogicsPerform();
         if(this.FIsInitialize)
         {
            _loc1_ = this.LogicsPerform_ConnectionVerify();
            if(_loc1_)
            {
               this.LogicsPerform_UpdataServerTime();
               if(this.FIsAntiAddictionState)
               {
                  this.LogicsPerform_InspectorAntiAddiction();
               }
            }
            this.UpdateSecretTime();
         }
      }
      
      protected function LogicsPerform_ConnectionVerify() : Boolean
      {
         return SNetworkCore.ConnectionVerify();
      }
      
      protected function LogicsPerform_UpdataServerTime() : void
      {
         var _loc1_:int = 0;
         _loc1_ = int(STimingCore.TickCount);
         if(_loc1_ - this.FTickReference > SYNCHRONIZE_SEVERY_TIME)
         {
            this.ProcessorUpdataServerTimeReq();
            this.FTickReference = STimingCore.TickCount;
         }
      }
      
      protected function LogicsPerform_InspectorAntiAddiction() : void
      {
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Boolean = false;
         var _loc10_:Date = null;
         var _loc11_:Date = null;
         var _loc12_:int = 0;
         var _loc13_:Boolean = false;
         _loc3_ = int(STimingCore.TickCount);
         if(_loc3_ - this.FTickInspectorAntiAddiction < TIME_INTERVAL_InspectorAntiAddiction)
         {
            return;
         }
         _loc4_ = int(STimingCore.ServerTick);
         _loc5_ = this.FAntiAddiction.LastOnlineDate;
         _loc11_ = new Date(_loc4_ * 1000);
         _loc10_ = new Date(_loc5_ * 1000);
         _loc6_ = _loc11_.getTime() - _loc10_.getTime();
         this.FAntiAddiction.OnlineTime += _loc6_;
         _loc7_ = this.FAntiAddiction.OnlineTime / 1000;
         _loc2_ = TIME_AntiAddictionUpperLimit - 1;
         _loc1_ = _loc2_;
         while(_loc1_ >= 0)
         {
            _loc9_ = false;
            _loc12_ = TIME_Radix_InspectorAntiAddictions[_loc1_];
            _loc8_ = _loc12_ / 1000;
            _loc13_ = this.FAntiAddictionsState[_loc1_];
            if(_loc13_)
            {
               break;
            }
            if(_loc7_ >= _loc8_)
            {
               _loc9_ = true;
            }
            if(_loc9_)
            {
               if(this.FOnChatAnnouncement != null)
               {
                  this.FOnChatAnnouncement(this,_loc1_ + 1);
               }
               if(this.FOnAntiAddiction != null)
               {
                  this.FOnAntiAddiction(this,_loc1_ + 1);
               }
               this.FAntiAddiction.OnlineTime = _loc8_ * 1000;
               this.FAntiAddictionsState[_loc1_] = _loc9_;
               break;
            }
            _loc1_--;
         }
         _loc10_ = null;
         _loc11_ = null;
         this.FTickInspectorAntiAddiction = STimingCore.TickCount;
         this.FAntiAddiction.LastOnlineDate = STimingCore.ServerTick;
         this.ProcessorSaveAntiAddiction();
      }
      
      protected function ProcessorUpdataServerTimeReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Inspector_QuertServerTimeReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function ProcessorCharacterCheckAntiAddiction() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Date = null;
         var _loc6_:Date = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(this.FOnChatAnnouncement != null)
         {
            this.FOnChatAnnouncement(this,0);
         }
         _loc7_ = int(SParametersCore.AntiAddictionState);
         switch(_loc7_)
         {
            case TYPE_ANTIADDICTION_ADULTHOOD:
               this.FIsAntiAddictionState = false;
               break;
            default:
               this.FIsAntiAddictionState = true;
         }
         if(this.FIsAntiAddictionState)
         {
            _loc1_ = this.FAntiAddiction.LastOnlineDate;
            _loc2_ = int(STimingCore.ServerTick);
            _loc5_ = new Date(_loc1_ * 1000);
            _loc6_ = new Date(_loc2_ * 1000);
            _loc3_ = _loc6_.getTime() - _loc5_.getTime();
            if(_loc3_ < 0)
            {
               _loc3_ = 0;
            }
            _loc4_ = this.FAntiAddiction.OnlineTime - _loc3_;
            if(_loc4_ < 0)
            {
               _loc4_ = 0;
            }
            this.FAntiAddiction.OnlineTime = _loc4_;
            _loc4_ /= 1000;
            _loc9_ = TIME_Radix_InspectorAntiAddictions[TIME_AntiAddictionUpperLimit - 1];
            _loc8_ = _loc9_ / 1000;
            if(_loc4_ >= _loc8_)
            {
               if(this.FOnChatAnnouncement != null)
               {
                  this.FOnChatAnnouncement(this,TIME_AntiAddictionUpperLimit);
               }
               if(this.FOnAntiAddiction != null)
               {
                  this.FOnAntiAddiction(this,TIME_AntiAddictionUpperLimit);
               }
            }
            this.FAntiAddiction.LastOnlineDate = STimingCore.ServerTick;
            this.ProcessorSaveAntiAddiction();
            _loc5_ = null;
            _loc6_ = null;
         }
      }
      
      protected function ProcessorSaveAntiAddiction() : void
      {
         SLocalStoragelCore.Flush(SLocalStoragelCore.StoragelPath,this.FAntiAddiction.Data);
      }
      
      protected function ProcessorPopupWindowHider() : void
      {
         if(this.FProcessorWindowPlayerAssets.Visible)
         {
            this.FProcessorWindowPlayerAssets.Hide();
         }
         if(this.FProcessorWindowInventoryInfor.Visible)
         {
            this.RemoveMouseUpEventListener();
            this.FProcessorWindowInventoryInfor.Hide();
         }
         if(this.FProcessorWindowHeroDescription.Visible)
         {
            this.RemoveMouseUpEventListener();
            this.FProcessorWindowHeroDescription.Hide();
         }
      }
      
      protected function AddMouseUpEventListener() : void
      {
         FUICore.UIStage.addEventListener(MouseEvent.MOUSE_UP,this.OnMouseUp,false,0,true);
      }
      
      protected function RemoveMouseUpEventListener() : void
      {
         FUICore.UIStage.removeEventListener(MouseEvent.MOUSE_UP,this.OnMouseUp);
      }
      
      protected function CheckIfNeedGetDataFromSever(param1:uint) : Boolean
      {
         var _loc2_:TBins = null;
         var _loc3_:TArticle = null;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,param1) as TArticle;
         if(_loc3_ != null && _loc3_.MajorType == CONST_INVENTORY.CATEGORY_Treasure)
         {
            return true;
         }
         _loc2_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BaseEquip);
         if(_loc2_.GetDatebaseByIdentifier(param1) != null)
         {
            return true;
         }
         return false;
      }
      
      protected function UpdateSecretTime() : void
      {
         if(this.FSecretMallCloseTime != 0)
         {
            if(STimingCore.TickCount >= this.FSecretMallCloseTime)
            {
               this.FSecretMallCloseTime = 0;
               if(this.FNotifyWindow.visible)
               {
                  this.FNotifyWindow.visible = false;
               }
               return;
            }
         }
      }
      
      protected function OnMouseUp(param1:MouseEvent) : void
      {
         this.ProcessorPopupWindowHider();
      }
      
      protected function SecretMallConfirm(param1:Object, param2:MouseEvent) : void
      {
         this.FSecretMallCloseTime = 0;
         this.FNotifyWindow.visible = false;
      }
      
      public function get OnChatAnnouncement() : Function
      {
         return this.FOnChatAnnouncement;
      }
      
      public function set OnChatAnnouncement(param1:Function) : void
      {
         this.FOnChatAnnouncement = param1;
      }
      
      public function get OnAntiAddiction() : Function
      {
         return this.FOnAntiAddiction;
      }
      
      public function set OnAntiAddiction(param1:Function) : void
      {
         this.FOnAntiAddiction = param1;
      }
      
      public function get OnQuertInventoryIDRet() : Function
      {
         return this.FOnQuertInventoryIDRet;
      }
      
      public function set OnQuertInventoryIDRet(param1:Function) : void
      {
         this.FOnQuertInventoryIDRet = param1;
      }
      
      public function UpdataServerTime() : void
      {
         this.ProcessorUpdataServerTimeReq();
         this.FTickReference = STimingCore.TickCount;
      }
      
      public function UpdateCharacterCheckAntiAddiction() : void
      {
         this.ProcessorCharacterCheckAntiAddiction();
         this.FIsInitialize = true;
      }
      
      public function RequestShowHero(param1:uint, param2:uint) : void
      {
         var _loc3_:TPacket = null;
         if(this.FProcessorWindowPlayerAssets.Visible)
         {
            this.FProcessorWindowPlayerAssets.Hide();
         }
         if(this.FProcessorWindowInventoryInfor.Visible)
         {
            this.FProcessorWindowInventoryInfor.Hide();
         }
         this.FHeros.Clear();
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Inspector_CharInfoReq);
         _loc3_.Data.writeUnsignedInt(param1);
         _loc3_.Data.writeUnsignedInt(param2);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      public function RequestInventoryInfor(param1:uint, param2:uint, param3:uint, param4:uint, param5:uint) : void
      {
         var _loc6_:TPacket = null;
         var _loc7_:ByteArray = null;
         var _loc8_:Boolean = false;
         if(this.FProcessorWindowInventoryInfor.Inventory != null && this.FProcessorWindowInventoryInfor.Inventory.IDTemplate == param3)
         {
            return;
         }
         _loc8_ = this.CheckIfNeedGetDataFromSever(param3);
         if(_loc8_)
         {
            _loc6_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Inspector_QuertInventoryReq);
            _loc7_ = _loc6_.Data;
            _loc7_.writeUnsignedInt(param1);
            _loc7_.writeUnsignedInt(param2);
            _loc7_.writeUnsignedInt(param3);
            _loc7_.writeUnsignedInt(param4);
            _loc7_.writeUnsignedInt(param5);
            SNetworkCore.Transceiver.PacketTransmit(_loc6_);
         }
         else
         {
            this.ShowInventoryInforByData(param3);
         }
      }
      
      public function RequestShowHeroDescription(param1:uint) : void
      {
         if(this.FProcessorWindowHeroDescription.Visible)
         {
            return;
         }
         this.AddMouseUpEventListener();
         this.FProcessorWindowHeroDescription.HeroID = param1;
         this.FProcessorWindowHeroDescription.Show();
      }
      
      public function QuertInventoryID(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         var _loc4_:TInventory = null;
         _loc4_ = param1 as TInventory;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Inspector_QuertInventoryIDReq);
         _loc3_ = _loc2_.Data;
         _loc3_.writeUnsignedInt(_loc4_.Identifier);
         _loc3_.writeUnsignedInt(_loc4_.IDTemplate);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      public function ShowNewCompleteAchievment(param1:Object) : void
      {
         this.FProcessorWindowGetAchievementEffect.Show(param1 as TAchievementInfor);
      }
      
      public function UpdateAchievementEffect() : void
      {
         this.FProcessorWindowGetAchievementEffect.Update();
      }
      
      public function SecretMallOpenNotify() : void
      {
         this.FSecretMallCloseTime = STimingCore.TickCount + this.FSecretMallDurationTime;
         this.FNotifyWindow.visible = true;
      }
   }
}

