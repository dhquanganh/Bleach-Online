package Processors.Game.Lobby.GongFuFight.MainUIComponent
{
   import Components.Standard.TUIButton;
   import Foundation.Common.THint;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.GongFuFight.TGongFuFightData;
   import Logics.GongFuFight.TGongFuFightPlayerGroup;
   import Logics.GongFuFight.TGongFuFightPlayerInfor;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_GONGFUFIGHT;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TComponentPlayerGroup extends TProcessorLobbyWindow
   {
      
      protected var HintFormat:String = "%0 * %1\n";
      
      protected var FMainScene:MovieClip;
      
      protected var FPlayersHeadUI:Vector.<Sprite>;
      
      protected var FPlayersHeadInfor:Vector.<Vector.<TPlayerHeadInfor>>;
      
      protected var FCurrentSelectHead:TPlayerHeadInfor;
      
      protected var FTFGongFuTitle:TextField;
      
      protected var FAwardReciveFlag:Vector.<Sprite>;
      
      protected var FAwardEffect:Vector.<MovieClip>;
      
      protected var FAwardLock:Vector.<Sprite>;
      
      protected var FAwardBoxs:Vector.<TUIButton>;
      
      protected var FHint:THint;
      
      protected var FFireLeft:MovieClip;
      
      protected var FFireRight:MovieClip;
      
      protected var FOnPlayerClick:Function;
      
      protected var FOnPlayerOver:Function;
      
      protected var FOnPlayerOut:Function;
      
      protected var FGongFuFight:TGongFuFightData;
      
      public function TComponentPlayerGroup(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FMainScene.visible && this.FMainScene != null)
         {
            if(this.FMainScene.currentFrame == this.FMainScene.totalFrames)
            {
               this.FMainScene.stop();
            }
         }
      }
      
      public function UIDispatch(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Sprite = null;
         var _loc7_:MovieClip = null;
         var _loc8_:MovieClip = null;
         var _loc9_:TUIButton = null;
         var _loc10_:Sprite = null;
         var _loc11_:Vector.<TPlayerHeadInfor> = null;
         var _loc12_:TPlayerHeadInfor = null;
         var _loc13_:Vector.<uint> = null;
         this.FMainScene = param1["PlayerGroup"];
         _loc6_ = this.FMainScene["PlayerList"];
         this.FPlayersHeadInfor = new Vector.<Vector.<TPlayerHeadInfor>>();
         this.FPlayersHeadUI = new Vector.<Sprite>();
         _loc13_ = CONST_GONGFUFIGHT.GroupsPlayerNum;
         _loc4_ = int(_loc13_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc5_ = int(_loc13_[_loc2_]);
            _loc11_ = new Vector.<TPlayerHeadInfor>();
            _loc3_ = 0;
            while(_loc3_ < _loc5_)
            {
               _loc10_ = _loc6_["head" + _loc2_ + _loc3_];
               _loc12_ = new TPlayerHeadInfor();
               _loc12_.UIDispatch(_loc10_);
               _loc12_.OnClick = this.HeadOnClick;
               _loc12_.OnMove = this.HeadOnMove;
               _loc12_.OnOut = this.HeadOnOut;
               _loc11_.push(_loc12_);
               _loc3_++;
            }
            this.FPlayersHeadInfor.push(_loc11_);
            _loc2_++;
         }
         this.FFireLeft = _loc6_["FireLeft"];
         this.FFireRight = _loc6_["FireRight"];
         this.FTFGongFuTitle = _loc6_["GongFuFightTitle"];
         this.FAwardReciveFlag = new Vector.<Sprite>();
         this.FAwardEffect = new Vector.<MovieClip>();
         this.FAwardLock = new Vector.<Sprite>();
         this.FAwardBoxs = new Vector.<TUIButton>();
         this.FHint = new THint();
         _loc4_ = int(_loc13_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc8_ = this.FMainScene["box" + _loc2_];
            _loc9_ = new TUIButton();
            _loc9_.Substrate = _loc8_;
            _loc9_.OnClick = this.BoxOnClick;
            _loc9_.OnMove = this.BoxOnMove;
            _loc9_.OnOut = this.BoxOnOut;
            this.FAwardBoxs.push(_loc9_);
            this.FAwardReciveFlag.push(_loc8_["ReciveFlag"]);
            this.FAwardEffect.push(_loc8_["BoxEffect"]);
            this.FAwardLock.push(_loc8_["LockFlag"]);
            _loc2_++;
         }
      }
      
      protected function RenderPlayerList(param1:Vector.<TGongFuFightPlayerGroup>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TGongFuFightPlayerGroup = null;
         var _loc7_:Vector.<TPlayerHeadInfor> = null;
         var _loc8_:String = null;
         _loc3_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = param1[_loc2_];
            _loc7_ = this.FPlayersHeadInfor[_loc2_];
            _loc5_ = int(_loc6_.PlayersInfor.length);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc7_[_loc4_].Update(_loc6_.PlayersInfor[_loc4_]);
               _loc7_[_loc4_].CancleSelectState();
               _loc4_++;
            }
            _loc2_++;
         }
         _loc8_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_23);
         this.FTFGongFuTitle.text = TUtilityString.Format(_loc8_,this.FGongFuFight.GongFuFightBaseInfor.FightZoneID);
      }
      
      protected function RenderAwardList(param1:Vector.<TGongFuFightPlayerGroup>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TGongFuFightPlayerGroup = null;
         var _loc5_:Boolean = false;
         _loc3_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1[_loc2_];
            if(this.CheckIfGotReward(_loc2_))
            {
               this.FAwardReciveFlag[_loc2_].visible = true;
               this.FAwardEffect[_loc2_].stop();
               this.FAwardEffect[_loc2_].visible = false;
               this.FAwardBoxs[_loc2_].Enabled = false;
               this.FAwardLock[_loc2_].visible = false;
            }
            else
            {
               _loc5_ = this.CheckIfCanGetReward(_loc4_);
               if(_loc5_)
               {
                  this.FAwardReciveFlag[_loc2_].visible = false;
                  this.FAwardEffect[_loc2_].play();
                  this.FAwardEffect[_loc2_].visible = true;
                  this.FAwardBoxs[_loc2_].Enabled = true;
                  this.FAwardLock[_loc2_].visible = false;
               }
               else
               {
                  this.FAwardReciveFlag[_loc2_].visible = false;
                  this.FAwardEffect[_loc2_].stop();
                  this.FAwardEffect[_loc2_].visible = false;
                  this.FAwardBoxs[_loc2_].Enabled = false;
                  this.FAwardLock[_loc2_].visible = true;
               }
            }
            _loc2_++;
         }
      }
      
      protected function CheckIfGotReward(param1:uint) : Boolean
      {
         return (this.FGongFuFight.GongFuFightBaseInfor.BoxState & 1 << param1) != 0;
      }
      
      protected function CheckIfCanGetReward(param1:TGongFuFightPlayerGroup) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TGongFuFightPlayerInfor = null;
         _loc3_ = int(param1.PlayersInfor.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.PlayersInfor[_loc2_];
            if(_loc4_.State != CONST_GONGFUFIGHT.PlayerState_Killed)
            {
               return false;
            }
            _loc2_++;
         }
         return true;
      }
      
      protected function BoxOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TPacket = null;
         _loc3_ = this.FAwardBoxs.indexOf(param1 as TUIButton);
         _loc3_++;
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_GongFuFight_ReciveBox);
         _loc4_.Data.writeUnsignedInt(_loc3_);
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
      }
      
      protected function BoxOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TInventories = null;
         var _loc5_:TInventory = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc3_ = this.FAwardBoxs.indexOf(param1 as TUIButton);
         _loc4_ = this.FGongFuFight.PlayerNormalGroups[_loc3_].Rewards;
         _loc6_ = _loc4_.Count;
         this.FHint.Caption = "";
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc5_ = _loc4_.GetInventoryByIndex(_loc7_);
            this.FHint.Caption += TUtilityString.Format(this.HintFormat,_loc5_.Name,_loc5_.Quantity);
            _loc7_++;
         }
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function BoxOnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      protected function HeadOnClick(param1:TPlayerHeadInfor, param2:TGongFuFightPlayerInfor) : void
      {
         if(this.FCurrentSelectHead != null)
         {
            this.FCurrentSelectHead.CancleSelectState();
         }
         this.FCurrentSelectHead = param1;
         if(this.FOnPlayerClick != null)
         {
            this.FOnPlayerClick(param2);
         }
      }
      
      protected function HeadOnMove(param1:TPlayerHeadInfor, param2:TGongFuFightPlayerInfor) : void
      {
         if(this.FOnPlayerOver != null)
         {
            this.FOnPlayerOver(param2);
         }
      }
      
      protected function HeadOnOut(param1:TPlayerHeadInfor, param2:TGongFuFightPlayerInfor) : void
      {
         if(this.FOnPlayerOut != null)
         {
            this.FOnPlayerOut(param2);
         }
      }
      
      protected function ResetPlayerGrounpHeadInfor() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Vector.<TPlayerHeadInfor> = null;
         _loc2_ = int(this.FPlayersHeadInfor.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = this.FPlayersHeadInfor[_loc1_];
            _loc4_ = int(_loc5_.length);
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc5_[_loc3_].Reset();
               _loc3_++;
            }
            _loc1_++;
         }
      }
      
      public function set OnPlayerClick(param1:Function) : void
      {
         this.FOnPlayerClick = param1;
      }
      
      public function set OnPlayerOver(param1:Function) : void
      {
         this.FOnPlayerOver = param1;
      }
      
      public function set OnPlayerOut(param1:Function) : void
      {
         this.FOnPlayerOut = param1;
      }
      
      public function Update(param1:TGongFuFightData) : void
      {
         this.FGongFuFight = param1;
         this.FFireLeft.play();
         this.FFireRight.play();
         this.RenderPlayerList(this.FGongFuFight.PlayerNormalGroups);
         this.RenderAwardList(this.FGongFuFight.PlayerNormalGroups);
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         this.FFireLeft.stop();
         this.FFireRight.stop();
         this.FMainScene.gotoAndStop(1);
         this.FCurrentSelectHead = null;
         this.ResetPlayerGrounpHeadInfor();
      }
      
      public function OpenView() : void
      {
         this.FMainScene.play();
      }
   }
}

