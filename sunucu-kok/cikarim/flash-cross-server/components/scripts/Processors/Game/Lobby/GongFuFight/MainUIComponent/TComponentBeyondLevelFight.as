package Processors.Game.Lobby.GongFuFight.MainUIComponent
{
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.GongFuFight.TGongFuFightData;
   import Logics.GongFuFight.TGongFuFightPlayerGroup;
   import Logics.GongFuFight.TGongFuFightPlayerInfor;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_CONFIGVALUE;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_GONGFUFIGHT;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TComponentBeyondLevelFight extends TProcessorLobbyWindow
   {
      
      protected static const ItemNum:int = 4;
      
      protected static const PageFormat:String = "%0 / %1";
      
      protected static const CloseFrameIndex:int = 1;
      
      protected static const OpenFrameIndex:int = 18;
      
      protected static const ChangePlayerFrameIndex:int = 36;
      
      protected var FMainUI:MovieClip;
      
      protected var FCurrentSelectItem:TBeyondLevelPlayerHeadItem;
      
      protected var FTargetFrameIndex:int;
      
      protected var FHeroInforItem:Vector.<TBeyondLevelPlayerHeadItem>;
      
      protected var FIronGate:MovieClip;
      
      protected var FBtnFresh:TUIButton;
      
      protected var FPageInfor:TextField;
      
      protected var FEyeFire:Vector.<MovieClip>;
      
      protected var FPlayerNormalGroups:Vector.<TGongFuFightPlayerGroup>;
      
      protected var FGongFuFightData:TGongFuFightData;
      
      protected var FCost:int;
      
      protected var FOnPlayerClick:Function;
      
      protected var FOnPlayerOver:Function;
      
      protected var FOnPlayerOut:Function;
      
      public function TComponentBeyondLevelFight(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FMainUI != null && Visible)
         {
            if(this.FMainUI.currentFrame == this.FMainUI.totalFrames)
            {
               this.FMainUI.stop();
            }
            if(this.FTargetFrameIndex != 0 && this.FTargetFrameIndex == this.FIronGate.currentFrame)
            {
               this.ArriveTargetFreamIndex();
            }
         }
      }
      
      override public function ComponentsResize() : void
      {
         super.ComponentsResize();
         if(Visible && this.FMainUI != null)
         {
            this.FMainUI.x = FUICore.StageWidth - (1250 - 1066);
         }
      }
      
      public function UIDispatch(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TBeyondLevelPlayerHeadItem = null;
         var _loc4_:MovieClip = null;
         var _loc5_:TConfigValue = null;
         this.FMainUI = param1["BeyondLevelChallenge"];
         _loc4_ = this.FMainUI["Panle"];
         this.FHeroInforItem = new Vector.<TBeyondLevelPlayerHeadItem>();
         this.FEyeFire = new Vector.<MovieClip>();
         _loc2_ = 0;
         while(_loc2_ < ItemNum)
         {
            _loc3_ = new TBeyondLevelPlayerHeadItem();
            _loc3_.OnClick = this.HeadOnClick;
            _loc3_.OnMove = this.HeadOnMove;
            _loc3_.OnOut = this.HeadOnOut;
            _loc3_.UIDispatch(_loc4_["Item" + _loc2_]);
            this.FHeroInforItem.push(_loc3_);
            this.FEyeFire.push(_loc4_["fire" + _loc2_]);
            _loc2_++;
         }
         this.FIronGate = _loc4_["IronGate"];
         this.FPageInfor = _loc4_["PageInfor"];
         this.FBtnFresh = new TUIButton();
         this.FBtnFresh.Substrate = _loc4_["BthFresh"];
         this.FBtnFresh.OnClick = this.BtnFreshOnClick;
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.GongFuFight_BuySuperFightCost) as TConfigValue;
         this.FCost = _loc5_.Value as int;
      }
      
      protected function RenderView() : void
      {
         var _loc1_:int = 0;
         this.FPageInfor.text = TUtilityString.Format(PageFormat,this.FGongFuFightData.GongFuFightBaseInfor.SpanFightFlag,this.FGongFuFightData.PlayerSuperLevelGroups.length);
         if(this.FGongFuFightData.GongFuFightBaseInfor.SpanFightFlag == 0)
         {
            this.FIronGate.gotoAndStop(CloseFrameIndex);
            this.FBtnFresh.Enabled = true;
         }
         else
         {
            this.FIronGate.gotoAndStop(OpenFrameIndex);
            _loc1_ = this.FGongFuFightData.GongFuFightBaseInfor.SpanFightFlag - 1;
            this.UpdateItem(this.FGongFuFightData.PlayerSuperLevelGroups[_loc1_]);
            this.FBtnFresh.Enabled = this.CheckIfAllKilled(this.FGongFuFightData.PlayerSuperLevelGroups[_loc1_]) && _loc1_ != this.FGongFuFightData.PlayerSuperLevelGroups.length;
         }
      }
      
      protected function ArriveTargetFreamIndex() : void
      {
         if(this.FTargetFrameIndex == OpenFrameIndex)
         {
            this.RenderView();
            this.FTargetFrameIndex = 0;
         }
         else if(this.FTargetFrameIndex == ChangePlayerFrameIndex)
         {
            this.RenderView();
            this.FIronGate.gotoAndPlay(this.FTargetFrameIndex);
            this.FTargetFrameIndex = this.FIronGate.totalFrames;
         }
         else if(this.FTargetFrameIndex == this.FIronGate.totalFrames)
         {
            this.RenderView();
            this.FTargetFrameIndex = 0;
         }
      }
      
      protected function CheckIfAllKilled(param1:TGongFuFightPlayerGroup) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(param1.PlayersInfor.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(param1.PlayersInfor[_loc2_].State != CONST_GONGFUFIGHT.PlayerState_Killed)
            {
               return false;
            }
            _loc2_++;
         }
         return true;
      }
      
      protected function UpdateItem(param1:TGongFuFightPlayerGroup) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(param1.PlayersInfor.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FHeroInforItem[_loc2_].Update(param1.PlayersInfor[_loc2_]);
            _loc2_++;
         }
      }
      
      protected function SetupFire(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(this.FEyeFire.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(param1)
            {
               this.FEyeFire[_loc2_].play();
            }
            else
            {
               this.FEyeFire[_loc2_].stop();
            }
            _loc2_++;
         }
      }
      
      protected function FreshListRequest(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_GongFuFight_OpenBeyondLevelFightReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function HeadOnClick(param1:TBeyondLevelPlayerHeadItem, param2:TGongFuFightPlayerInfor) : void
      {
         if(this.FCurrentSelectItem != null)
         {
            this.FCurrentSelectItem.CancleSelectState();
         }
         this.FCurrentSelectItem = param1;
         if(this.FOnPlayerClick != null)
         {
            this.FOnPlayerClick(param2);
         }
      }
      
      protected function HeadOnMove(param1:TBeyondLevelPlayerHeadItem, param2:TGongFuFightPlayerInfor) : void
      {
         if(this.FOnPlayerOver != null && param2 != null)
         {
            this.FOnPlayerOver(param2);
         }
      }
      
      protected function HeadOnOut(param1:TBeyondLevelPlayerHeadItem, param2:TGongFuFightPlayerInfor) : void
      {
         if(this.FOnPlayerOut != null)
         {
            this.FOnPlayerOut(param2);
         }
      }
      
      protected function BtnFreshOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:String = null;
         _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_26);
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(_loc3_,this.FCost);
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.FreshListRequest;
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
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
         this.FGongFuFightData = param1;
         this.RenderView();
      }
      
      public function OpenView() : void
      {
         this.FMainUI.gotoAndPlay(1);
         this.SetupFire(true);
      }
      
      public function Reset() : void
      {
         this.SetupFire(false);
      }
      
      public function AddBeyondChanllgeFight() : void
      {
         if(this.FIronGate.currentFrame == CloseFrameIndex)
         {
            this.RenderView();
            this.FIronGate.gotoAndPlay(CloseFrameIndex);
            this.FTargetFrameIndex = OpenFrameIndex;
         }
         if(this.FIronGate.currentFrame == OpenFrameIndex)
         {
            this.FIronGate.play();
            this.FTargetFrameIndex = ChangePlayerFrameIndex;
         }
      }
   }
}

