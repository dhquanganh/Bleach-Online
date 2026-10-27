package Processors.Game.Lobby.SkyTower.Components
{
   import Components.Standard.*;
   import Foundation.Common.THint;
   import Foundation.Resources.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.SkyTower.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import Utilities.Timing.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TUIState extends TUIComponent
   {
      
      protected static const TIME_INTERVAL_PVP_PERIOD:int = 1000;
      
      protected static const TIME_INTERVAL_PVP_UPDATE_PERIOD:int = 3000;
      
      protected var FHintReceiving:THint;
      
      protected var FHintOccupy:THint;
      
      protected var FTF_Level:TextField;
      
      protected var FTF_Nickname:TextField;
      
      protected var FTF_PvpContext:TextField;
      
      protected var FTF_PvpTimer:TextField;
      
      protected var FBtn_Challenge:TUIButton;
      
      protected var FBtn_Occupy:TUIButton;
      
      protected var FBtn_Receiving:TUIButton;
      
      protected var FTickPvpTimer:int;
      
      protected var FTickHourTimer:int;
      
      protected var FTickHour:int;
      
      protected var FResource:Sprite;
      
      protected var FContext:TLayer;
      
      protected var FOnChallenge:Function;
      
      protected var FOnOccupy:Function;
      
      protected var FOnReceiving:Function;
      
      protected var FOnEffectText:Function;
      
      protected var FHintOnOver:Function;
      
      protected var FHintOnOut:Function;
      
      public function TUIState(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         if(this.FResource == null)
         {
            return;
         }
         this.FHintReceiving = new THint();
         this.FHintOccupy = new THint();
         this.FResource.mouseEnabled = false;
         this.FTF_Level = this.FResource[CONST_SKYTOWER.RESOURCE_Link_TF_Level];
         this.FTF_Nickname = this.FResource[CONST_SKYTOWER.RESOURCE_Link_TF_Nickname];
         this.FTF_PvpContext = this.FResource[CONST_SKYTOWER.RESOURCE_Link_TF_PvpContext];
         _loc2_ = this.FResource[CONST_SKYTOWER.RESOURCE_Link_SP_PvpTimer];
         this.FTF_PvpTimer = _loc2_[CONST_SKYTOWER.RESOURCE_Link_TF_PvpTimer];
         this.FBtn_Challenge = new TUIButton();
         this.FBtn_Challenge.Substrate = this.FResource[CONST_SKYTOWER.RESOURCE_Link_Btn_Pvp];
         this.FBtn_Occupy = new TUIButton();
         this.FBtn_Occupy.Substrate = this.FResource[CONST_SKYTOWER.RESOURCE_Link_Btn_Occupy];
         this.FBtn_Receiving = new TUIButton();
         this.FBtn_Receiving.Substrate = this.FResource[CONST_SKYTOWER.RESOURCE_Link_Btn_Receiving];
         this.Reset();
      }
      
      protected function addEventListenerPlayer() : void
      {
         if(this.FResource == null)
         {
            return;
         }
         this.FBtn_Challenge.OnClick = this.Btn_ChallengeOnClick;
         this.FBtn_Occupy.OnClick = this.Btn_OccupyOnClick;
         this.FBtn_Occupy.OnMove = this.Btn_OccupyOnMove;
         this.FBtn_Occupy.OnOut = this.Btn_OccupyOnOut;
         this.FBtn_Receiving.OnClick = this.Btn_ReceivingOnClick;
         this.FBtn_Receiving.OnMove = this.Btn_ReceivingOnMove;
         this.FBtn_Receiving.OnOut = this.Btn_ReceivingOnOut;
      }
      
      protected function RemoveEventListenerPlayer() : void
      {
         if(this.FResource == null)
         {
            return;
         }
         this.FBtn_Challenge.OnClick = null;
         this.FBtn_Occupy.OnClick = null;
         this.FBtn_Receiving.OnClick = null;
      }
      
      protected function UpdateUIState() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:uint = 0;
         var _loc7_:Date = null;
         var _loc8_:TConfigValue = null;
         var _loc9_:TSkyTower = null;
         var _loc10_:TTower = null;
         var _loc11_:TLayer = null;
         var _loc12_:int = 0;
         if(this.FResource == null)
         {
            return;
         }
         _loc3_ = "";
         _loc4_ = "";
         _loc5_ = "";
         _loc6_ = 0;
         _loc9_ = SLogicsCore.SkyTower;
         _loc10_ = _loc9_.Towers.GetTowerByIdentifier(_loc9_.SelectTowerID);
         _loc2_ = _loc10_.Layers.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc11_ = _loc10_.Layers.GetLayerByIndex(_loc1_);
            if(_loc11_.Identifier == this.FContext.Identifier)
            {
               _loc1_++;
               break;
            }
            _loc1_++;
         }
         if(_loc10_.Layers.MaxLayer == 0 || _loc10_.Layers.MaxLayer < _loc1_)
         {
            _loc3_ += TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_10),this.FContext.LayerName) + "\n";
            this.FBtn_Occupy.Enabled = false;
            this.FBtn_Challenge.Enabled = false;
         }
         else if(_loc9_.PvpMax + _loc9_.PVPBuyCount - _loc9_.PVPCount <= 0)
         {
            this.FBtn_Challenge.Enabled = false;
         }
         _loc12_ = STimingCore.ServerTick - this.FContext.PvpTimer;
         if(_loc12_ < 0)
         {
            _loc12_ = 0;
         }
         _loc7_ = new Date(_loc12_ * 1000);
         if(FTag == CONST_SKYTOWER.TAG_SKYTOWER_NONE)
         {
            _loc3_ += TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_06),this.FContext.AwardCount,this.FContext.AwardName);
            if(this.IsPvpOccupying() && !this.IsCanReceive(_loc7_,true))
            {
               this.FBtn_Occupy.Enabled = false;
            }
            this.FBtn_Occupy.Visible = true;
         }
         else if(FTag == CONST_SKYTOWER.TAG_SKYTOWER_SELF)
         {
            _loc4_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_02),this.FContext.PvpLevel);
            _loc5_ = this.FContext.PvpNickname;
            _loc6_ = this.FContext.AwardCount;
            _loc3_ += TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_11),_loc6_ * _loc7_.hoursUTC,this.FContext.AwardName) + "\n";
            _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.SkyTower_RobRate) as TConfigValue;
            _loc6_ = _loc6_ * _loc7_.hoursUTC * (uint(_loc8_.Value) / 100);
            _loc3_ += TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_12),_loc6_,this.FContext.AwardName) + "\n";
            _loc3_ += TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_13);
            this.FBtn_Receiving.Enabled = this.IsCanReceive(_loc7_);
            this.FBtn_Receiving.Visible = true;
            this.FTickHour = _loc7_.hoursUTC;
            this.FTickPvpTimer = STimingCore.TickCount;
            this.FTickHourTimer = STimingCore.TickCount;
         }
         else
         {
            _loc4_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_02),this.FContext.PvpLevel);
            _loc5_ = this.FContext.PvpNickname;
            _loc6_ = this.FContext.AwardCount;
            _loc3_ += TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_06),this.FContext.AwardCount,this.FContext.AwardName) + "\n";
            _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.SkyTower_RobRate) as TConfigValue;
            _loc6_ = _loc6_ * _loc7_.hoursUTC * (uint(_loc8_.Value) / 100);
            _loc3_ += TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_14),_loc6_,this.FContext.AwardName);
            this.FTickHour = _loc7_.hoursUTC;
            this.FBtn_Challenge.Visible = true;
            this.FTickPvpTimer = STimingCore.TickCount;
            this.FTickHourTimer = STimingCore.TickCount;
         }
         this.FTF_Level.text = _loc4_;
         this.FTF_Nickname.text = _loc5_;
         this.FTF_PvpContext.text = _loc3_;
      }
      
      protected function IsCanReceive(param1:Date, param2:Boolean = false) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TLayer = null;
         var _loc6_:int = 0;
         var _loc7_:TConfigValue = null;
         if(param2)
         {
            _loc5_ = SLogicsCore.SkyTower.GetCharacterPvpLayer(SLogicsCore.Character.Identifier0,SLogicsCore.Character.Identifier1);
            if(_loc5_ != null)
            {
               _loc6_ = STimingCore.ServerTick - _loc5_.PvpTimer;
               if(_loc6_ < 0)
               {
                  _loc6_ = 0;
               }
               param1 = new Date(_loc6_ * 1000);
            }
         }
         _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.SkyTower_PvpRefreshTime) as TConfigValue;
         _loc4_ = int(uint(_loc7_.Value));
         _loc3_ = param1.getTime() / 1000;
         _loc3_ /= _loc4_;
         if(_loc3_ / _loc4_ > 0)
         {
            return true;
         }
         return false;
      }
      
      protected function IsPvpOccupying() : Boolean
      {
         var _loc1_:TLayer = null;
         _loc1_ = SLogicsCore.SkyTower.GetCharacterPvpLayer(SLogicsCore.Character.Identifier0,SLogicsCore.Character.Identifier1);
         if(_loc1_ != null)
         {
            return true;
         }
         return false;
      }
      
      protected function Btn_ChallengeOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnChallenge != null)
         {
            this.FOnChallenge(this,this.FContext);
         }
         this.FBtn_Challenge.Enabled = false;
      }
      
      protected function Btn_OccupyOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnOccupy != null)
         {
            this.FOnOccupy(this,this.FContext);
         }
         this.FBtn_Occupy.Enabled = false;
      }
      
      protected function Btn_OccupyOnMove(param1:Object, param2:MouseEvent) : void
      {
         if(TUtilityString.Empty(this.FHintOccupy.Caption))
         {
            this.FHintOccupy.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_31);
         }
         if(this.FHintOnOver != null)
         {
            this.FHintOnOver(this,this.FHintOccupy);
         }
      }
      
      protected function Btn_OccupyOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHintOccupy);
            this.FHintOccupy.Caption = "";
         }
      }
      
      protected function Btn_ReceivingOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:Date = null;
         _loc3_ = new Date((STimingCore.ServerTick - this.FContext.PvpTimer) * 1000);
         if(_loc3_.hoursUTC <= 0)
         {
            if(this.FOnEffectText != null)
            {
               this.FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_25));
            }
         }
         if(this.FOnReceiving != null)
         {
            this.FOnReceiving(this,this.FContext);
         }
         this.FBtn_Receiving.Enabled = false;
      }
      
      protected function Btn_ReceivingOnMove(param1:Object, param2:MouseEvent) : void
      {
         if(TUtilityString.Empty(this.FHintReceiving.Caption))
         {
            this.FHintReceiving.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_30);
         }
         if(this.FHintOnOver != null)
         {
            this.FHintOnOver(this,this.FHintReceiving);
         }
      }
      
      protected function Btn_ReceivingOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHintReceiving);
            this.FHintReceiving.Caption = "";
         }
      }
      
      public function get Resource() : Sprite
      {
         return this.FResource;
      }
      
      public function set Resource(param1:Sprite) : void
      {
         this.FResource = param1;
      }
      
      public function get Context() : TLayer
      {
         return this.FContext;
      }
      
      public function set Context(param1:TLayer) : void
      {
         this.Reset();
         if(this.FContext == null && param1 != null)
         {
            this.addEventListenerPlayer();
         }
         else if(param1 == null)
         {
            this.RemoveEventListenerPlayer();
         }
         this.FContext = param1;
         if(param1 != null)
         {
            this.UpdateUIState();
         }
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         if(this.FResource != null)
         {
            this.FResource.visible = param1;
         }
      }
      
      public function get OnChallenge() : Function
      {
         return this.FOnChallenge;
      }
      
      public function set OnChallenge(param1:Function) : void
      {
         this.FOnChallenge = param1;
      }
      
      public function get OnOccupy() : Function
      {
         return this.FOnOccupy;
      }
      
      public function set OnOccupy(param1:Function) : void
      {
         this.FOnOccupy = param1;
      }
      
      public function get OnReceiving() : Function
      {
         return this.FOnReceiving;
      }
      
      public function set OnReceiving(param1:Function) : void
      {
         this.FOnReceiving = param1;
      }
      
      public function get OnEffectText() : Function
      {
         return this.FOnEffectText;
      }
      
      public function set OnEffectText(param1:Function) : void
      {
         this.FOnEffectText = param1;
      }
      
      public function set HintOnOver(param1:Function) : void
      {
         this.FHintOnOver = param1;
      }
      
      public function get HintOnOver() : Function
      {
         return this.FHintOnOver;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function get HintOnOut() : Function
      {
         return this.FHintOnOut;
      }
      
      public function Perform_UIDispatch() : void
      {
         this.ResourcesPerform_UIDispatch();
      }
      
      override public function Dispose() : void
      {
         this.FTF_Level = null;
         this.FTF_Nickname = null;
         this.FTF_PvpContext = null;
         this.FTF_PvpTimer = null;
         this.FBtn_Challenge.Dispose();
         this.FBtn_Challenge = null;
         this.FBtn_Occupy.Dispose();
         this.FBtn_Occupy = null;
         this.FBtn_Receiving.Dispose();
         this.FBtn_Receiving = null;
         this.FOnChallenge = null;
         this.FOnOccupy = null;
         this.FOnReceiving = null;
         this.FOnEffectText = null;
         this.FResource = null;
         if(this.Parent != null)
         {
            this.Parent.removeChild(this);
         }
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         if(this.FResource == null)
         {
            return;
         }
         this.FTickPvpTimer = 0;
         this.FTickHourTimer = 0;
         this.FTickHour = 0;
         this.FTF_Level.text = "";
         this.FTF_Nickname.text = "";
         this.FTF_PvpContext.text = "";
         this.FTF_PvpTimer.text = "";
         this.FBtn_Occupy.Enabled = true;
         this.FBtn_Challenge.Enabled = true;
         this.FBtn_Receiving.Enabled = false;
         this.FBtn_Challenge.Visible = false;
         this.FBtn_Occupy.Visible = false;
         this.FBtn_Receiving.Visible = false;
      }
      
      public function Update() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Date = null;
         var _loc3_:int = 0;
         if(this.FResource == null)
         {
            return;
         }
         if(this.FContext.PvpTimer == 0)
         {
            return;
         }
         _loc1_ = int(STimingCore.TickCount);
         if(_loc1_ - this.FTickPvpTimer >= TIME_INTERVAL_PVP_PERIOD)
         {
            this.FTF_PvpTimer.text = TUtilityTiming.fomatTime(STimingCore.ServerTick - this.FContext.PvpTimer);
            this.FTickPvpTimer = _loc1_;
         }
         if(_loc1_ - this.FTickHourTimer >= TIME_INTERVAL_PVP_UPDATE_PERIOD)
         {
            _loc3_ = STimingCore.ServerTick - this.FContext.PvpTimer;
            if(_loc3_ < 0)
            {
               _loc3_ = 0;
            }
            _loc2_ = new Date(_loc3_ * 1000);
            if(this.FTickHour != _loc2_.hoursUTC)
            {
               this.UpdateUIState();
            }
            this.FTickHourTimer = _loc1_;
         }
      }
   }
}

