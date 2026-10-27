package Processors.Game.Lobby.GirlGame
{
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TAnimationFrame;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.Agent.SParametersCore;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.GirlGame.TGirlGameInfor;
   import Logics.GirlGame.TGirlInfor;
   import Logics.GirlGame.TGirlTextureInfor;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_CONFIGVALUE;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_FRESHGUIDE;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class TProcessorWindowGirlGame extends TProcessorLobbyWindow
   {
      
      protected var Mode_Explore:int = 0;
      
      protected var Mode_Enjoy:int = 1;
      
      protected var FMainUI:Sprite;
      
      protected var FCurrentMode:int;
      
      protected var FComponentGirlHead:TComponentGirlHead;
      
      protected var FBoardPicMountPoint:Bitmap;
      
      protected var FClothesMountPoint:Bitmap;
      
      protected var FCurrentWaitShowGirl:TGirlInfor;
      
      protected var FGirlTextureInfor:TGirlTextureInfor;
      
      protected var FComponentClothes:TComponentClothes;
      
      protected var FComponentCoverOne:TComponentCoverOne;
      
      protected var FComponentCoverTwo:TComponentCoverTwo;
      
      protected var FProcessorWindowPlayGame:TProcessorWindowPlayGame;
      
      protected var FTFExploreTime:TextField;
      
      protected var FTFAddExploreTime:TextField;
      
      protected var FGameIfWin:Boolean;
      
      protected var FBtn_Close:TUIButton;
      
      protected var FBtn_Enjoy:TUIButton;
      
      protected var FBtnLable:TextField;
      
      protected var FBtnArea:Sprite;
      
      protected var FBtn_Explore:TUIButton;
      
      protected var FOneKeyLimit:Sprite;
      
      protected var FBtn_OneKey:TUIButton;
      
      protected var FSingleClothesPrice:int;
      
      protected var FOneKeyVipLimit:int;
      
      protected var FOnBtnCloseClick:Function;
      
      protected var FGameGirls:Vector.<TGirlInfor>;
      
      protected var FGameInfor:TGirlGameInfor;
      
      public function TProcessorWindowGirlGame(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:TConfigValue = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("GirlGameUI") as Sprite;
         addChild(this.FMainUI);
         this.FComponentGirlHead = new TComponentGirlHead(this);
         this.FComponentGirlHead.LoadResource();
         this.FComponentGirlHead.OnSelectGirl = this.SwitchGirlNormal;
         this.FBoardPicMountPoint = new Bitmap();
         this.FClothesMountPoint = new Bitmap();
         addChildAt(this.FBoardPicMountPoint,0);
         addChildAt(this.FClothesMountPoint,1);
         this.FGirlTextureInfor = new TGirlTextureInfor();
         this.FComponentClothes = new TComponentClothes(this);
         this.FComponentClothes.LoadResources();
         this.FComponentClothes.OnBtnClick = this.SwitchGirlNormal;
         this.FComponentCoverOne = new TComponentCoverOne(this);
         this.FComponentCoverOne.LoadResource();
         this.FComponentCoverOne.OnCoverOver = this.CallBack_OneCoverOver;
         this.FComponentCoverTwo = new TComponentCoverTwo(this);
         this.FComponentCoverTwo.LoadResources();
         this.FComponentCoverTwo.OnCoverOver = this.CallBack_TwoCoverOver;
         this.FComponentCoverTwo.OnCancleOver = this.CallBackCancleOver;
         this.FProcessorWindowPlayGame = new TProcessorWindowPlayGame(this);
         this.FProcessorWindowPlayGame.LoadResources();
         this.FProcessorWindowPlayGame.GameOver = this.CallBack_GameOver;
         this.FBtn_Close = new TUIButton();
         this.FBtn_Close.OnClick = this.BtnCloseOnClick;
         this.FBtn_Close.Substrate = this.FMainUI["btn_close"];
         this.FBtn_Enjoy = new TUIButton();
         this.FBtn_Enjoy.Substrate = this.FMainUI["Btn_Enjoy"];
         this.FBtn_Enjoy.OnClick = this.BtnEnjoyOnClick;
         this.FBtnLable = this.FMainUI["Btn_Enjoy"]["BtnLable"];
         this.FBtn_Explore = new TUIButton();
         this.FBtnArea = this.FMainUI["BtnArea"];
         this.FBtn_Explore.Substrate = this.FMainUI["BtnArea"]["Btn_Explore"];
         this.FBtn_Explore.OnClick = this.BtnExploreOnClick;
         this.FTFExploreTime = this.FBtnArea["ExploreTime"];
         this.FTFAddExploreTime = this.FBtnArea["AddExploreTime"];
         this.FBtn_OneKey = new TUIButton();
         this.FBtn_OneKey.Substrate = this.FMainUI["BtnArea"]["BtnOneKey"];
         this.FBtn_OneKey.OnClick = this.BtnOneKeyOnClick;
         this.FOneKeyLimit = this.FMainUI["VipLimit"];
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.GirlGame_VipLimit) as TConfigValue;
         this.FOneKeyVipLimit = _loc1_.Value as uint;
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.GirlGame_SingleCost) as TConfigValue;
         this.FSingleClothesPrice = _loc1_.Value as uint;
         TutorialSendArrowParent(CONST_FRESHGUIDE.MCID_GirlGame,this);
         TutorialSendComponent(CONST_FRESHGUIDE.MCID_GirlGame,this);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FComponentClothes.X = FUICore.StageWidth - this.FComponentClothes.width;
         this.FComponentClothes.Y = 100;
         if(false)
         {
            this.FComponentClothes.Y = 40;
         }
         super.ResourcesPerform_UILocations();
      }
      
      protected function UpdateExploreTime() : void
      {
         this.FTFExploreTime.text = this.FGameInfor.UndressTime.toString();
         this.FTFAddExploreTime.text = this.FGameInfor.AddUndressTime.toString();
      }
      
      protected function SwitchGirlNormal(param1:TGirlInfor, param2:int) : void
      {
         this.FCurrentWaitShowGirl = param1;
         this.FComponentClothes.ChangeGirl(this.FCurrentWaitShowGirl);
         this.FGirlTextureInfor.TextureID = param1.ID;
         this.FGirlTextureInfor.SequnceIndex = param2;
         this.FClothesMountPoint.visible = false;
         this.FBoardPicMountPoint.visible = false;
         this.FComponentCoverOne.Visible = true;
         this.FComponentCoverOne.StartCover();
      }
      
      protected function CallBack_OneCoverOver(param1:Object) : void
      {
         SResourcesCore.TexturesLargeIcon.LoadAutoSecondary(this.FGirlTextureInfor.TextureID,this.CallBack_FirstGirlPicArrive);
         this.FClothesMountPoint.visible = true;
         this.FBoardPicMountPoint.visible = true;
      }
      
      protected function CallBack_FirstGirlPicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationFrame = null;
         var _loc5_:int = 0;
         _loc5_ = int(this.FGirlTextureInfor.SequnceIndex);
         if(false)
         {
            if(_loc5_ < 2)
            {
               _loc5_ = 1;
            }
         }
         if(SParametersCore.IfTXGame)
         {
            if(_loc5_ < 4)
            {
               _loc5_ = 3;
            }
         }
         this.FBoardPicMountPoint.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
         this.FClothesMountPoint.bitmapData = null;
         if(_loc5_ != 0)
         {
            _loc4_ = param2.GetAnimationSequenceByIndex(_loc5_).GetAnimationFrameByIndex(0);
            this.FClothesMountPoint.bitmapData = _loc4_.Surface;
            this.FClothesMountPoint.x = this.FBoardPicMountPoint.width / 2 - _loc4_.Pivot.X;
            this.FClothesMountPoint.y = this.FBoardPicMountPoint.height / 2 - _loc4_.Pivot.Y;
         }
         this.FComponentCoverOne.CancleCover();
      }
      
      protected function SwitchGirlSpecial(param1:TGirlInfor, param2:int, param3:String, param4:Boolean) : void
      {
         this.FComponentCoverTwo.Visible = true;
         this.FComponentCoverTwo.StartCover();
         this.FComponentCoverTwo.ShowResult(param3,"",param1.ID);
         this.FGirlTextureInfor.TextureID = param1.ID;
         this.FGirlTextureInfor.SequnceIndex = param2;
      }
      
      protected function CallBack_TwoCoverOver(param1:Object) : void
      {
         SResourcesCore.TexturesLargeIcon.LoadAutoSecondary(this.FGirlTextureInfor.TextureID,this.CallBack_GirlPicArrive);
      }
      
      protected function CallBack_GirlPicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationFrame = null;
         var _loc5_:int = 0;
         if(this.FGirlTextureInfor.TextureID == param3)
         {
            _loc5_ = int(this.FGirlTextureInfor.SequnceIndex);
            if(false)
            {
               if(_loc5_ < 2)
               {
                  _loc5_ = 1;
               }
            }
            if(SParametersCore.IfTXGame)
            {
               if(_loc5_ < 4)
               {
                  _loc5_ = 3;
               }
            }
            this.FBoardPicMountPoint.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
            this.FClothesMountPoint.bitmapData = null;
            if(_loc5_ != 0)
            {
               _loc4_ = param2.GetAnimationSequenceByIndex(_loc5_).GetAnimationFrameByIndex(0);
               this.FClothesMountPoint.bitmapData = _loc4_.Surface;
               this.FClothesMountPoint.x = this.FBoardPicMountPoint.width / 2 - _loc4_.Pivot.X;
               this.FClothesMountPoint.y = this.FBoardPicMountPoint.height / 2 - _loc4_.Pivot.Y;
            }
            this.FComponentCoverTwo.CancleCover();
         }
      }
      
      protected function CallBackCancleOver(param1:Object) : void
      {
         if(this.FGameIfWin && this.FCurrentWaitShowGirl.CurrentSchedule != 0)
         {
            this.SwitchMode(this.Mode_Explore);
            this.FProcessorWindowPlayGame.Visible = true;
            this.FProcessorWindowPlayGame.PlayGame(this.FCurrentWaitShowGirl.ID,this.FCurrentWaitShowGirl.Clothes[this.FCurrentWaitShowGirl.CurrentSchedule]);
         }
      }
      
      protected function BtnEnjoyOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FCurrentMode == this.Mode_Explore)
         {
            this.SwitchMode(this.Mode_Enjoy);
         }
         else
         {
            this.SwitchMode(this.Mode_Explore);
         }
      }
      
      protected function SwitchMode(param1:int) : void
      {
         this.FCurrentMode = param1;
         this.FComponentClothes.SetupMode(param1,this.FCurrentWaitShowGirl);
         if(param1 == this.Mode_Enjoy)
         {
            this.FBtnArea.visible = false;
            this.FBtnLable.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlGame_String_06);
            this.FComponentGirlHead.visible = false;
            this.FComponentClothes.GirlInfor = this.FCurrentWaitShowGirl;
         }
         else
         {
            this.FComponentGirlHead.visible = true;
            this.FComponentGirlHead.ShowGirl(this.FGameGirls);
            this.FBtnArea.visible = true;
            this.SwitchGirlNormal(this.FCurrentWaitShowGirl,this.FCurrentWaitShowGirl.CurrentSchedule);
            this.FBtnLable.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlGame_String_07);
         }
      }
      
      protected function BtnExploreOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:Boolean = false;
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_StartGirlGame);
         _loc3_ = this.CheckIfCanUndress();
         if(!_loc3_)
         {
            return;
         }
         _loc3_ = this.CheckIfFillCondtion(this.FCurrentWaitShowGirl);
         if(!_loc3_)
         {
            return;
         }
         _loc3_ = this.CheckIfHaveTime();
         if(!_loc3_)
         {
            return;
         }
         this.SwitchMode(this.Mode_Explore);
         this.FProcessorWindowPlayGame.Visible = true;
         this.FProcessorWindowPlayGame.PlayGame(this.FCurrentWaitShowGirl.ID,this.FCurrentWaitShowGirl.Clothes[this.FCurrentWaitShowGirl.CurrentSchedule]);
      }
      
      protected function ReqOneKeyClick(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_UndressOneKeyReq);
         _loc2_.Data.writeUnsignedInt(this.FCurrentWaitShowGirl.ID);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function BtnOneKeyOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_StartGirlGame);
         _loc4_ = this.CheckIfCanUndress();
         if(!_loc4_)
         {
            return;
         }
         _loc4_ = this.CheckIfFillCondtion(this.FCurrentWaitShowGirl);
         if(!_loc4_)
         {
            return;
         }
         _loc4_ = this.CheckIfHaveTime();
         if(!_loc4_)
         {
            return;
         }
         if(Boolean(SLogicsCore.BleachAgentData.Open) && SLogicsCore.BleachAgentData.Remain > 0)
         {
            this.ReqOneKeyClick(null);
         }
         else
         {
            _loc3_ = this.FCurrentWaitShowGirl.CurrentSchedule;
            _loc3_ *= this.FSingleClothesPrice;
            SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GirlCloth),_loc3_);
            SUtilityOverLayer.UIWindowConfirmation.OnOK = this.ReqOneKeyClick;
            SUtilityOverLayer.UIWindowConfirmation.Visible = true;
         }
      }
      
      protected function CheckIfFillCondtion(param1:TGirlInfor) : Boolean
      {
         var _loc2_:String = null;
         if(param1.OpenCondition > this.FGameInfor.SingedTime)
         {
            _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlGame_String_08);
            _loc2_ = TUtilityString.Format(_loc2_,param1.OpenCondition);
            EffectGenerateText(_loc2_);
            return false;
         }
         return true;
      }
      
      protected function CheckIfCanUndress() : Boolean
      {
         var _loc1_:String = null;
         if(this.FCurrentWaitShowGirl.CurrentSchedule == 0)
         {
            _loc1_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlGame_String_09);
            EffectGenerateText(_loc1_);
            return false;
         }
         return true;
      }
      
      protected function CheckIfHaveTime() : Boolean
      {
         var _loc1_:String = null;
         if(this.FGameInfor.UndressTime == 0 && this.FGameInfor.AddUndressTime == 0)
         {
            _loc1_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlGame_String_10);
            EffectGenerateText(_loc1_);
            return false;
         }
         return true;
      }
      
      protected function ReduseUndressTime() : void
      {
         if(this.FGameInfor.UndressTime != 0)
         {
            --this.FGameInfor.UndressTime;
         }
         else
         {
            --this.FGameInfor.AddUndressTime;
         }
         this.UpdateExploreTime();
      }
      
      protected function CallBack_GameOver(param1:Object, param2:int, param3:Boolean) : void
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         _loc5_ = int(param1 as uint);
         this.FGameIfWin = param3;
         this.NotifyServerScore(this.FCurrentWaitShowGirl.ID,_loc5_);
         if(param3)
         {
            if(this.FCurrentWaitShowGirl.ScheduleHistory > this.FCurrentWaitShowGirl.CurrentSchedule)
            {
               this.FCurrentWaitShowGirl.ScheduleHistory = this.FCurrentWaitShowGirl.CurrentSchedule;
            }
            this.FCurrentWaitShowGirl.CurrentSchedule = param3 ? int(this.FCurrentWaitShowGirl.CurrentSchedule - 1) : this.FCurrentWaitShowGirl.CurrentSchedule;
            if(this.FCurrentWaitShowGirl.CurrentSchedule == 0)
            {
               this.ReduseUndressTime();
            }
            _loc4_ = this.FCurrentWaitShowGirl.SuccessText[param2];
         }
         else
         {
            this.ReduseUndressTime();
            this.FCurrentWaitShowGirl.CurrentSchedule = this.FCurrentWaitShowGirl.Clothes.length - 1;
            _loc4_ = this.FCurrentWaitShowGirl.FailText;
         }
         this.FComponentClothes.Update();
         this.SwitchGirlSpecial(this.FCurrentWaitShowGirl,this.FCurrentWaitShowGirl.CurrentSchedule,_loc4_,param3);
      }
      
      protected function NotifyServerScore(param1:uint, param2:uint) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_GirlGameUndressReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeUnsignedInt(param1);
         _loc4_.writeUnsignedInt(param2);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnBtnCloseClick != null)
         {
            this.FOnBtnCloseClick(this);
         }
         ProcessorWindowClose();
      }
      
      public function ShowGirl(param1:TGirlGameInfor) : void
      {
         this.FGameGirls = param1.GameGirls;
         this.FGameInfor = param1;
         this.FOneKeyLimit.visible = SLogicsCore.Character.VipLevel < this.FOneKeyVipLimit;
         this.FBtn_OneKey.Visible = !this.FOneKeyLimit.visible;
         this.FComponentGirlHead.ShowGirl(this.FGameGirls);
         this.FComponentGirlHead.SelectFristGirl();
         this.UpdateExploreTime();
         this.SwitchGirlNormal(this.FGameGirls[0],this.FGameGirls[0].Clothes.length - 1);
         this.SwitchMode(this.Mode_Explore);
      }
      
      public function Reset() : void
      {
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
         if(this.FCurrentWaitShowGirl != null)
         {
            this.FCurrentWaitShowGirl.CurrentSchedule = this.FCurrentWaitShowGirl.Clothes.length - 1;
         }
         this.SwitchMode(this.Mode_Explore);
         this.FBoardPicMountPoint.bitmapData = null;
         this.FClothesMountPoint.bitmapData = null;
         this.FComponentGirlHead.Reset();
         this.FComponentCoverOne.Reset();
         this.FComponentCoverTwo.Reset();
         this.FProcessorWindowPlayGame.Reset();
      }
      
      public function OneKeySuccess() : void
      {
         this.ReduseUndressTime();
         this.FCurrentWaitShowGirl.CurrentSchedule = this.FCurrentWaitShowGirl.Clothes.length - 1;
         if(false)
         {
            this.FCurrentWaitShowGirl.CurrentSchedule = 0;
            this.SwitchGirlNormal(this.FCurrentWaitShowGirl,this.FCurrentWaitShowGirl.CurrentSchedule);
            this.FCurrentWaitShowGirl.ScheduleHistory = 1;
            this.FComponentClothes.GirlInfor = this.FCurrentWaitShowGirl;
         }
         this.FComponentClothes.Update();
      }
   }
}

