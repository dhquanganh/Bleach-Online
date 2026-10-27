package Processors.Game.Lobby.HeroChange
{
   import Components.Pages.*;
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.Textures.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.BleachAgent.TBleachAgentData;
   import Logics.DatebaseVO.VO.*;
   import Logics.HeroChange.*;
   import Logics.Vip.TVip;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowTrainField extends TProcessorLobbyWindow
   {
      
      protected static const HeroNum:int = 5;
      
      protected var FLastIntoTime:TextField;
      
      protected var FBtnAddIntoTime:TUIButton;
      
      protected var FUIPage:TUIPage;
      
      protected var FHeroHeads:Vector.<Bitmap>;
      
      protected var FHeroNames:Vector.<TextField>;
      
      protected var FHeroChipNums:Vector.<TextField>;
      
      protected var FBtnsReset:Vector.<TUIButton>;
      
      protected var FBtnsFight:Vector.<TUIButton>;
      
      protected var FHeroInfors:Vector.<Sprite>;
      
      protected var FCurrentHeroPage:int;
      
      protected var FHint:THint;
      
      protected var FBuyIntoTimeCosts:Vector.<int>;
      
      protected var FBtnIntoDecs:Vector.<String>;
      
      protected var FIfCanInto:Vector.<Boolean>;
      
      protected var FHeros:Vector.<THeroChange>;
      
      protected var FHeroChangeData:THeroChangeData;
      
      protected var FOnIntoSingleTrain:Function;
      
      protected var FBAData:TBleachAgentData;
      
      public function TProcessorWindowTrainField(param1:TUIComponent)
      {
         super(param1);
         this.FBAData = SLogicsCore.BleachAgentData;
      }
      
      public function UIDispatch(param1:Sprite) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:int = 0;
         var _loc4_:Bitmap = null;
         var _loc5_:Sprite = null;
         var _loc6_:TUIButton = null;
         var _loc7_:TConfigValue = null;
         addChild(param1);
         _loc2_ = param1["PagePanle"];
         this.FUIPage = new TUIPage(this);
         this.FUIPage.ButtonNext.Substrate = _loc2_["MC_PageRight"];
         this.FUIPage.ButtonPrevious.Substrate = _loc2_["MC_PageLeft"];
         this.FUIPage.PageSize = HeroNum;
         this.FUIPage.OnChangePage = this.PageOnSwitch;
         this.FUIPage.LabelPage = _loc2_["TF_Page"];
         this.FUIPage.Init();
         _loc2_ = param1["IntoTimePanle"];
         this.FLastIntoTime = _loc2_["IntoTime"];
         this.FBtnAddIntoTime = new TUIButton();
         this.FBtnAddIntoTime.Substrate = _loc2_["Btn_Add"];
         this.FBtnAddIntoTime.OnClick = this.BtnAddTimeOnClick;
         this.FHeroHeads = new Vector.<Bitmap>();
         this.FHeroNames = new Vector.<TextField>();
         this.FHeroChipNums = new Vector.<TextField>();
         this.FBtnsReset = new Vector.<TUIButton>();
         this.FBtnsFight = new Vector.<TUIButton>();
         this.FHeroInfors = new Vector.<Sprite>();
         _loc2_ = param1["HeroInforPanle"];
         _loc3_ = 0;
         while(_loc3_ < HeroNum)
         {
            _loc5_ = _loc2_["HeroList" + _loc3_];
            this.FHeroInfors.push(_loc5_);
            _loc4_ = new Bitmap();
            this.FHeroHeads.push(_loc4_);
            _loc5_["MC_RoleHead"]["MC_MountPoint"].addChild(_loc4_);
            this.FHeroNames.push(_loc5_["Name"]);
            this.FHeroChipNums.push(_loc5_["ChipPanle"]["ChipNum"]);
            _loc6_ = new TUIButton();
            _loc6_.Substrate = _loc5_["Btn_Reset"];
            _loc6_.OnClick = this.BtnResetOnClick;
            _loc6_.OnMove = this.BtnResetOnMove;
            _loc6_.OnOut = this.BtnOnOut;
            this.FBtnsReset.push(_loc6_);
            _loc6_ = new TUIButton();
            _loc6_.Substrate = _loc5_["Btn_Fight"];
            _loc6_.OnClick = this.BtnFightOnClick;
            _loc6_.OnMove = this.BtnFightOnMove;
            _loc6_.OnOut = this.BtnOnOut;
            this.FBtnsFight.push(_loc6_);
            _loc3_++;
         }
         this.FHint = new THint();
         this.FBtnIntoDecs = new Vector.<String>();
         this.FIfCanInto = new Vector.<Boolean>();
         _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.FreeEnterTime) as TConfigValue;
         this.FHeroChangeData.CanFightTimeEveryDay = _loc7_.Value as int;
         _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.BuyEnterTimeCost) as TConfigValue;
         this.FBuyIntoTimeCosts = Vector.<int>(_loc7_.Value);
      }
      
      public function UILocation() : void
      {
      }
      
      protected function RenderIntoTime() : void
      {
         this.FLastIntoTime.text = String(this.FHeroChangeData.BuyTime + this.FHeroChangeData.CanFightTimeEveryDay - this.FHeroChangeData.FightTime + this.FBAData.GetWelfareCountByType(this.FBAData.WelfareType_ChangeHeroCount));
      }
      
      protected function RenderHeroList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:THeroChange = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc3_ = this.FCurrentHeroPage * HeroNum;
         _loc4_ = _loc3_ + HeroNum;
         _loc4_ = _loc4_ > this.FHeros.length ? int(this.FHeros.length) : _loc4_;
         _loc5_ = 0;
         this.FBtnIntoDecs.length = 0;
         this.FIfCanInto.length = 0;
         _loc1_ = _loc3_;
         while(_loc1_ < _loc4_)
         {
            _loc2_ = this.FHeros[_loc1_];
            SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc2_.Hero.SmallID,this.PicArrive);
            this.FHeroInfors[_loc5_].visible = true;
            this.FHeroNames[_loc5_].text = _loc2_.Hero.Name;
            this.FHeroNames[_loc5_].textColor = CONST_COMMON.QUALITYCOLOR_INDEX[_loc2_.Hero.Quality];
            this.FHeroHeads[_loc5_].bitmapData = null;
            this.FHeroChipNums[_loc5_].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_20),_loc2_.Hero.Name,_loc2_.HeroChipNum);
            this.CreateBtnIntoCaption(_loc2_,this.FBtnIntoDecs,this.FIfCanInto);
            this.FBtnsReset[_loc5_].Enabled = SLogicsCore.Character.Heros.GetHeroByIdentifier(_loc2_.Hero.Identifier) != null;
            this.FBtnsFight[_loc5_].Enabled = this.FBtnsReset[_loc5_].Enabled;
            _loc5_++;
            _loc1_++;
         }
         _loc1_ = _loc5_;
         while(_loc1_ < HeroNum)
         {
            this.FHeroInfors[_loc1_].visible = false;
            _loc1_++;
         }
      }
      
      protected function CreateBtnIntoCaption(param1:THeroChange, param2:Vector.<String>, param3:Vector.<Boolean>) : void
      {
         var _loc4_:String = null;
         var _loc5_:Date = null;
         var _loc6_:Date = null;
         var _loc7_:Date = null;
         if(!param1.HeroChangeAttr.IsOpen)
         {
            param2.push(TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_31));
            param3.push(false);
            return;
         }
         if(param1.HeroChangeAttr.StartTime[0] == 0 && param1.HeroChangeAttr.EndTime[0] == 0)
         {
            param2.push(null);
            param3.push(true);
            return;
         }
         _loc5_ = new Date(param1.HeroChangeAttr.StartTime[0],param1.HeroChangeAttr.StartTime[1] - 1,param1.HeroChangeAttr.StartTime[2],param1.HeroChangeAttr.StartTime[3],param1.HeroChangeAttr.StartTime[4],param1.HeroChangeAttr.StartTime[5]);
         _loc6_ = new Date(param1.HeroChangeAttr.EndTime[0],param1.HeroChangeAttr.EndTime[1] - 1,param1.HeroChangeAttr.EndTime[2],param1.HeroChangeAttr.EndTime[3],param1.HeroChangeAttr.EndTime[4],param1.HeroChangeAttr.EndTime[5]);
         _loc7_ = new Date(STimingCore.ServerTick * 1000);
         param3.push(_loc7_.time <= _loc6_.time && _loc7_.time >= _loc5_.time);
         param2.push(TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_32),TUtilityDate.FormatDateChineseNew(_loc5_),TUtilityDate.FormatDateChineseNew(_loc6_)));
      }
      
      protected function PicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:int = 0;
         var _loc5_:THeroChange = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         _loc6_ = this.FCurrentHeroPage * HeroNum;
         _loc7_ = _loc6_ + HeroNum;
         _loc7_ = _loc7_ > this.FHeros.length ? int(this.FHeros.length) : _loc7_;
         _loc8_ = 0;
         _loc4_ = _loc6_;
         while(_loc4_ < _loc7_)
         {
            _loc5_ = this.FHeros[_loc4_];
            if(_loc5_.Hero.SmallID == param3)
            {
               this.FHeroHeads[_loc8_].bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
               return;
            }
            _loc8_++;
            _loc4_++;
         }
      }
      
      protected function SetupPage(param1:int, param2:int, param3:TUIPage) : void
      {
         param3.TotalQuantity = param1;
         param3.Update();
         param3.PageIndex = param2;
      }
      
      protected function ReqBuyIntoTime(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_HeroChange_BuyIntoTimeReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function ReqReset(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_HeroChange_ResetReq);
         _loc2_.Data.writeInt(this.FHeros[SUtilityOverLayer.UIWindowConfirmation.Tag].Hero.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function PageOnSwitch(param1:Object, param2:int) : void
      {
         this.FCurrentHeroPage = param2;
         this.RenderHeroList();
      }
      
      protected function BtnAddTimeOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FHeroChangeData.BuyTime >= SLogicsCore.Character.VipData.ChangeHeroEnterBuy)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_27));
            return;
         }
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_26),this.FBuyIntoTimeCosts[this.FHeroChangeData.BuyTime],SLogicsCore.Character.VipData.ChangeHeroEnterBuy - this.FHeroChangeData.BuyTime);
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.ReqBuyIntoTime;
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
      }
      
      protected function BtnResetOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:THeroChange = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc3_ = this.FBtnsReset.indexOf(param1 as TUIButton);
         _loc3_ = this.FCurrentHeroPage * HeroNum + _loc3_;
         _loc4_ = this.FHeros[_loc3_];
         _loc6_ = this.FHeroChangeData.BuyTime + this.FHeroChangeData.CanFightTimeEveryDay - this.FHeroChangeData.FightTime;
         if(this.FHeroChangeData.BuyTime >= SLogicsCore.Character.VipData.ChangeHeroEnterBuy && _loc6_ <= 0)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_38));
            return;
         }
         if(SLogicsCore.Character.Heros.GetHeroByIdentifier(_loc4_.Hero.Identifier) == null)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_07));
            return;
         }
         _loc5_ = _loc4_.CurrentResetTime;
         if(_loc5_ >= SLogicsCore.Character.VipData.ChangeHeroReset)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_29));
            return;
         }
         _loc6_ = this.FHeroChangeData.BuyTime + this.FHeroChangeData.CanFightTimeEveryDay - this.FHeroChangeData.FightTime;
         if(_loc6_ == 0)
         {
            _loc7_ = _loc4_.HeroChangeAttr.ResetGold[_loc5_];
            SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_30),_loc7_);
         }
         else
         {
            SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_28),_loc4_.HeroChangeAttr.ResetGold[_loc5_],SLogicsCore.Character.VipData.ChangeHeroReset - _loc5_);
         }
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
         SUtilityOverLayer.UIWindowConfirmation.Tag = _loc3_;
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.ReqReset;
      }
      
      protected function BtnResetOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:THeroChange = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:TBins = null;
         var _loc10_:TVip = null;
         var _loc11_:TVipConfig = null;
         _loc10_ = SLogicsCore.Character.VipData;
         _loc3_ = this.FBtnsReset.indexOf(param1 as TUIButton);
         _loc3_ = this.FCurrentHeroPage * HeroNum + _loc3_;
         _loc4_ = this.FHeros[_loc3_];
         _loc9_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_VipConfig);
         _loc8_ = _loc9_.Count;
         _loc7_ = "";
         _loc3_ = 0;
         while(_loc3_ < _loc8_)
         {
            _loc11_ = _loc9_.GetDatebaseByIndex(_loc3_) as TVipConfig;
            _loc7_ += TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_36),_loc11_.Identifier,_loc11_.ChangeHeroReset);
            _loc3_++;
         }
         this.FHint.Caption = _loc7_;
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function BtnFightOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:THeroChange = null;
         _loc3_ = this.FBtnsFight.indexOf(param1 as TUIButton);
         _loc3_ = this.FCurrentHeroPage * HeroNum + _loc3_;
         _loc4_ = this.FHeros[_loc3_];
         if(SLogicsCore.Character.Heros.GetHeroByIdentifier(_loc4_.Hero.Identifier) == null)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_07));
            return;
         }
         if(this.FOnIntoSingleTrain != null)
         {
            this.FOnIntoSingleTrain(_loc4_);
         }
      }
      
      protected function BtnFightOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:THeroChange = null;
         var _loc5_:int = 0;
         _loc5_ = this.FBtnsFight.indexOf(param1 as TUIButton);
         _loc3_ = this.FCurrentHeroPage * HeroNum + _loc5_;
         _loc4_ = this.FHeros[_loc3_];
         if(SLogicsCore.Character.Heros.GetHeroByIdentifier(_loc4_.Hero.Identifier) == null)
         {
            return;
         }
         if(this.FBtnIntoDecs[_loc5_] != null)
         {
            this.FHint.Caption = this.FBtnIntoDecs[_loc5_];
            SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
         }
      }
      
      protected function BtnOnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      public function set HeroChangeData(param1:THeroChangeData) : void
      {
         this.FHeroChangeData = param1;
      }
      
      public function set OnIntoSingleTrain(param1:Function) : void
      {
         this.FOnIntoSingleTrain = param1;
      }
      
      public function ChangeHeroList(param1:Vector.<THeroChange>, param2:int) : void
      {
         this.FHeros = param1;
         this.SetupPage(param1.length,0,this.FUIPage);
         this.FCurrentHeroPage = 0;
         this.RenderHeroList();
         this.RenderIntoTime();
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < HeroNum)
         {
            this.FHeroHeads[_loc1_].bitmapData = null;
            _loc1_++;
         }
      }
      
      public function FightNotify() : void
      {
         this.RenderHeroList();
         this.RenderIntoTime();
      }
      
      public function BuyTimeNotify() : void
      {
         this.RenderIntoTime();
      }
      
      public function GradeMaterialUpdateNotify() : void
      {
         if(Visible)
         {
            this.RenderHeroList();
         }
      }
   }
}

