package Processors.Game.Lobby.HeroChange
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Campaign.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HeroChange.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Lobby.WorldMapBleach.MonsterMap.*;
   import Processors.Game.Utilities.EffectTextReward.*;
   import Processors.Game.Utilities.HyperLink.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowSingleTrain extends TProcessorLobbyWindow
   {
      
      protected static const SOULSTAR_TabIndex:uint = 1;
      
      protected static const SOULSTAR_BaseID:uint = 0;
      
      protected var FrameIndex_WaitCross:int = 1;
      
      protected var FrameIndex_Selected:int = 2;
      
      protected var FrameIndex_AlreadyCross:int = 3;
      
      protected var PointNum:int = 15;
      
      protected var FFreeReliveTime:int;
      
      protected var FMainUI:Sprite;
      
      protected var FBtnClose:TUIButton;
      
      protected var FHeroName:TextField;
      
      protected var FHeroHead:Bitmap;
      
      protected var FPoints:Vector.<MovieClip>;
      
      protected var FBridge:Vector.<MovieClip>;
      
      protected var FTFChipNum:TextField;
      
      protected var FTFCanReliveTime:TextField;
      
      protected var FBtnRelive:TUIButton;
      
      protected var FBtnOneKey:TUIButton;
      
      protected var FHint:THint;
      
      protected var FProcessorWindowBarrierChoose:TProcessorWindowBarrierChoose;
      
      protected var FNodalModel:TNodal;
      
      protected var FHeroChange:THeroChange;
      
      protected var FHeroChangeData:THeroChangeData;
      
      public function TProcessorWindowSingleTrain(param1:TUIComponent)
      {
         super(param1);
      }
      
      public function UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:MovieClip = null;
         var _loc4_:TConfigValue = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("HeroTrainSingle") as Sprite;
         addChild(this.FMainUI);
         this.FHeroName = this.FMainUI["HeroPanle"]["Name"];
         this.FHeroHead = new Bitmap();
         this.FMainUI["HeroPanle"]["HeroHead"]["MountPoint"].addChild(this.FHeroHead);
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainUI["Close"];
         this.FBtnClose.OnClick = this.BtnCloseOnClick;
         this.FPoints = new Vector.<MovieClip>();
         this.FBridge = new Vector.<MovieClip>();
         _loc2_ = this.FMainUI["PointPanle"];
         _loc1_ = 0;
         while(_loc1_ < this.PointNum)
         {
            _loc3_ = _loc2_["Point" + _loc1_];
            _loc3_.addEventListener(MouseEvent.MOUSE_MOVE,this.PointOnMove);
            _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this.PointOnOut);
            _loc3_.addEventListener(MouseEvent.CLICK,this.PointOnClick);
            _loc3_.buttonMode = true;
            this.FPoints.push(_loc3_);
            this.FBridge.push(_loc2_["Bridge" + _loc1_]);
            _loc1_++;
         }
         this.FTFChipNum = this.FMainUI["TimePanle"]["ChipNum"];
         this.FTFCanReliveTime = this.FMainUI["RelivePanle"]["ReliveTime"];
         this.FBtnRelive = new TUIButton();
         this.FBtnRelive.Substrate = this.FMainUI["RelivePanle"]["Btn_Add"];
         this.FBtnRelive.OnClick = this.BtnAddOnClick;
         this.FBtnOneKey = new TUIButton();
         this.FBtnOneKey.Substrate = this.FMainUI["Btn_OneKey"];
         this.FBtnOneKey.OnClick = this.BtnOneKeyOnClick;
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.FreeReliveTime) as TConfigValue;
         this.FFreeReliveTime = _loc4_.Value as int;
         this.FHint = new THint();
         this.FProcessorWindowBarrierChoose = new TProcessorWindowBarrierChoose(this);
         this.FProcessorWindowBarrierChoose.OnChangeTeammate = this.ProcessorOnChangeTeammate;
         this.FProcessorWindowBarrierChoose.OnChangeSkill = this.ProcessorOnChangeSkill;
         this.FProcessorWindowBarrierChoose.OnBattle = this.ProcessorOnBattle;
         this.FProcessorWindowBarrierChoose.OnOverLayOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowBarrierChoose.OnOverLayOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowBarrierChoose.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowBarrierChoose.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowBarrierChoose.x = -75;
         this.FProcessorWindowBarrierChoose.y = 0;
         this.FProcessorWindowBarrierChoose.Load();
      }
      
      public function UILocation() : void
      {
         this.FNodalModel = SLogicsCore.Nodal;
      }
      
      protected function RenderTrainState() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         this.FHeroName.text = this.FHeroChange.Hero.Name;
         this.FHeroName.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[this.FHeroChange.Hero.Quality];
         SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(this.FHeroChange.Hero.SmallID,this.PicArrive);
         this.FTFChipNum.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_20),this.FHeroChange.Hero.Name,this.FHeroChange.HeroChipNum);
         this.FTFCanReliveTime.text = (this.FFreeReliveTime + this.FHeroChange.CurrentReliveTime - this.FHeroChange.CurrentDieTime).toString();
         _loc1_ = 0;
         while(_loc1_ < this.PointNum)
         {
            _loc2_ = this.FPoints[_loc1_];
            if(_loc1_ != 0)
            {
               this.FBridge[_loc1_ - 1].gotoAndStop(1);
            }
            if(this.FHeroChange.CurrentMonsterNum > _loc1_)
            {
               _loc2_.gotoAndStop(this.FrameIndex_AlreadyCross);
               if(_loc1_ != 0)
               {
                  this.FBridge[_loc1_ - 1].gotoAndStop(this.FBridge[_loc1_ - 1].totalFrames);
               }
            }
            else if(this.FHeroChange.CurrentMonsterNum == _loc1_)
            {
               _loc2_.gotoAndStop(this.FrameIndex_Selected);
            }
            else
            {
               _loc2_.gotoAndStop(this.FrameIndex_WaitCross);
            }
            _loc1_++;
         }
      }
      
      protected function PicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         this.FHeroHead.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
      }
      
      protected function ReqBuyReliveTime(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_HeroChange_ReliveReq);
         _loc2_.Data.writeInt(this.FHeroChange.Hero.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function ProcessorOnFight(param1:Object, param2:TNodal, param3:int, param4:int, param5:int) : void
      {
         this.FProcessorWindowBarrierChoose.UpDataBarrierChoose(param1,param2,param3,param4,param5);
         this.FProcessorWindowBarrierChoose.Visible = true;
         this.FProcessorWindowBarrierChoose.Mount();
      }
      
      protected function ProcessorOnChangeTeammate(param1:Object) : void
      {
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_TacticalDeployment);
         this.FProcessorWindowBarrierChoose.Visible = false;
      }
      
      protected function ProcessorOnChangeSkill(param1:Object) : void
      {
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Star,SOULSTAR_TabIndex,SOULSTAR_BaseID);
         this.FProcessorWindowBarrierChoose.Visible = false;
      }
      
      protected function ProcessorOnBattle(param1:Object, param2:int) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         if(this.FHeroChange.CurrentMonsterNum == 0)
         {
            _loc4_ = this.FHeroChangeData.BuyTime + this.FHeroChangeData.CanFightTimeEveryDay - this.FHeroChangeData.FightTime;
            if(_loc4_ <= 0)
            {
               SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_37));
               return;
            }
         }
         else
         {
            _loc5_ = this.FFreeReliveTime + this.FHeroChange.CurrentReliveTime - this.FHeroChange.CurrentDieTime <= 0;
            if(_loc5_)
            {
               SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_37));
               return;
            }
         }
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_HeroChange_FightReq);
         _loc3_.Data.writeInt(this.FHeroChange.Hero.Identifier);
         this.FHeroChangeData.CurrentBattleID = this.FHeroChange.ChangeHeroPoints[this.FHeroChange.CurrentMonsterNum].Identifier;
         this.FHeroChangeData.CurrentBattleHeroID = this.FHeroChange.Hero.Identifier;
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         this.FProcessorWindowBarrierChoose.Visible = false;
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function BtnAddOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FHeroChange.CurrentReliveTime >= this.FHeroChange.HeroChangeAttr.RebornGold.length)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_22));
            return;
         }
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_21),this.FHeroChange.HeroChangeAttr.RebornGold[this.FHeroChange.CurrentReliveTime],this.FHeroChange.HeroChangeAttr.RebornGold.length - this.FHeroChange.CurrentReliveTime);
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.ReqBuyReliveTime;
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
      }
      
      protected function BtnOneKeyOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         if(this.FHeroChange.HighestRecord == this.FHeroChange.CurrentMonsterNum)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_23));
            return;
         }
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_HeroChange_OneKeyReq);
         _loc3_.Data.writeInt(this.FHeroChange.Hero.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function PointOnClick(param1:MouseEvent) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:int = 0;
         _loc3_ = this.FPoints.indexOf(param1.currentTarget as MovieClip);
         if(_loc3_ != this.FHeroChange.CurrentMonsterNum)
         {
            return;
         }
         if(this.FHeroChange.ChangeHeroPoints.length <= this.FHeroChange.CurrentMonsterNum)
         {
            return;
         }
         this.PointOnOut();
         this.ProcessorOnFight(this,this.FNodalModel,CONST_BATTLE.BattleType_HeroChange,this.FHeroChange.HeroChangeAttr.CityID,this.FHeroChange.ChangeHeroPoints[this.FHeroChange.CurrentMonsterNum].Identifier);
      }
      
      protected function PointOnMove(param1:MouseEvent) : void
      {
         var _loc2_:TChangeHeroPoint = null;
         var _loc3_:int = 0;
         _loc3_ = this.FPoints.indexOf(param1.currentTarget as MovieClip);
         _loc2_ = this.FHeroChange.ChangeHeroPoints[_loc3_];
         this.FHint.Caption = _loc2_.Name;
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function PointOnOut(param1:MouseEvent = null) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      public function set HeroChangeData(param1:THeroChangeData) : void
      {
         this.FHeroChangeData = param1;
      }
      
      public function Show(param1:THeroChange) : void
      {
         this.FHeroChange = param1;
         this.RenderTrainState();
         Visible = true;
      }
      
      public function FightNotify() : void
      {
         this.RenderTrainState();
      }
      
      public function ReliveNotify() : void
      {
         this.RenderTrainState();
      }
      
      public function OneKeyFightNotify() : void
      {
         this.RenderTrainState();
      }
      
      public function GradeMaterialUpdateNotify() : void
      {
         this.RenderTrainState();
      }
   }
}

