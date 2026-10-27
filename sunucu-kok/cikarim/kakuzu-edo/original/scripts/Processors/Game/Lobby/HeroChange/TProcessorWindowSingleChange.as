package Processors.Game.Lobby.HeroChange
{
   import Components.Pages.*;
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HeroChange.*;
   import Logics.Map.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Common.Map.SceneSprite.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import ghostcat.util.data.Json;
   
   public class TProcessorWindowSingleChange extends TProcessorLobbyWindow
   {
      
      protected static const TalentNum:int = 7;
      
      protected static const MaterialIconNum:int = 3;
      
      protected static const MaxStarNum:int = 7;
      
      protected var FMainUI:Sprite;
      
      protected var FChipName:TextField;
      
      protected var FTFSpecialChip:TextField;
      
      protected var FTFCommonChip:TextField;
      
      protected var FMaterialIcons:Vector.<Sprite>;
      
      protected var FTF_NormalPill:TextField;
      
      protected var FTF_GradePill:TextField;
      
      protected var FLightStars:Vector.<Sprite>;
      
      protected var FDarkStars:Vector.<Sprite>;
      
      protected var FTFName:TextField;
      
      protected var FTFNeedMaterial:TextField;
      
      protected var FRoleMoudle:TSceneSpriteMoudle;
      
      protected var FQueryModel:TMoudleInfor;
      
      protected var FBtnChange:TUIButton;
      
      protected var FBtnMakePill:TUIButton;
      
      protected var FTalentNames:Vector.<TextField>;
      
      protected var FTalentLevel:Vector.<TextField>;
      
      protected var FTalentDes:Vector.<TextField>;
      
      protected var FTalentTextPanle:Vector.<Sprite>;
      
      protected var FTalentForecasts:Vector.<Sprite>;
      
      protected var FBtn_AdvanceChange:Vector.<TUIButton>;
      
      protected var FBtn_CloseAdvanceChange:TUIButton;
      
      protected var FBtn_AdvanceChangeViewList:TUIButton;
      
      protected var FBtn_AdvanceChangeRefresh:TUIButton;
      
      protected var FBtn_AdvanceChangeReturn:TUIButton;
      
      protected var FViewListHint:THint;
      
      protected var FCurLevel:uint;
      
      protected var FLock:uint;
      
      protected var FUIPage:TUIPage;
      
      protected var FBtnClose:TUIButton;
      
      protected var FHint:THint;
      
      protected var FStars:Sprite;
      
      protected var FHeroChangeLightStars:Vector.<Sprite>;
      
      protected var FHeroChangeDarkStars:Vector.<Sprite>;
      
      protected var FChangeLevelString:Vector.<String>;
      
      protected var FSoulPillNames:Vector.<String>;
      
      protected var FCurrentShowIndex:int;
      
      protected var FHeroChangeData:THeroChangeData;
      
      protected var FHeros:Vector.<THeroChange>;
      
      protected var FOnMakePill:Function;
      
      public function TProcessorWindowSingleChange(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(Visible)
         {
            this.FRoleMoudle.UpdateView();
         }
      }
      
      public function UIDispatch() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:TUIButton = null;
         var _loc3_:int = 0;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("HeroChangeSingle") as Sprite;
         addChild(this.FMainUI);
         this.FChipName = this.FMainUI["TF_ChipName"];
         this.FTFSpecialChip = this.FMainUI["TF_SpecialChip"];
         this.FTFCommonChip = this.FMainUI["TF_PowerFulChip"];
         this.FMaterialIcons = new Vector.<Sprite>();
         _loc3_ = 0;
         while(_loc3_ < MaterialIconNum)
         {
            _loc1_ = this.FMainUI["Icon" + _loc3_];
            _loc1_.addEventListener(MouseEvent.MOUSE_MOVE,this.MaterialIconOnMove);
            _loc1_.addEventListener(MouseEvent.MOUSE_OUT,this.MaterialIconOnOut);
            this.FMaterialIcons.push(_loc1_);
            _loc3_++;
         }
         this.FTF_NormalPill = this.FMainUI["TF_NormalPill"];
         this.FTF_GradePill = this.FMainUI["TF_GradelPill"];
         _loc1_ = this.FMainUI["MC_Heros"];
         this.FTFName = _loc1_["TF_Name"];
         this.FUIPage = new TUIPage(this);
         this.FUIPage.ButtonPrevious.Substrate = _loc1_["btn_left"];
         this.FUIPage.ButtonNext.Substrate = _loc1_["btn_right"];
         this.FUIPage.PageSize = 1;
         this.FUIPage.OnChangePage = this.PageOnChange;
         this.FUIPage.Init();
         _loc1_ = _loc1_["ChangeInfor"];
         this.FTFNeedMaterial = _loc1_["ChangeNeed"];
         this.FBtnChange = new TUIButton();
         this.FBtnChange.Substrate = _loc1_["BtnChange"];
         this.FBtnChange.OnClick = this.BtnChangeOnClick;
         this.FBtnMakePill = new TUIButton();
         this.FBtnMakePill.Substrate = _loc1_["BtnMakePill"];
         this.FBtnMakePill.OnClick = this.BtnMakePillOnClick;
         this.FTalentNames = new Vector.<TextField>();
         this.FTalentLevel = new Vector.<TextField>();
         this.FTalentDes = new Vector.<TextField>();
         this.FTalentTextPanle = new Vector.<Sprite>();
         this.FTalentForecasts = new Vector.<Sprite>();
         this.FBtn_AdvanceChange = new Vector.<TUIButton>();
         _loc3_ = 0;
         while(_loc3_ < TalentNum)
         {
            _loc1_ = this.FMainUI["Talent" + _loc3_];
            _loc1_ = _loc1_["TextPanle"];
            this.FTalentTextPanle.push(_loc1_);
            this.FTalentLevel.push(_loc1_["TalentLevel"]);
            this.FTalentNames.push(_loc1_["TalentName"]);
            this.FTalentDes.push(_loc1_["TalentDes"]);
            _loc1_ = this.FMainUI["Talent" + _loc3_];
            this.FTalentForecasts.push(_loc1_["Forecasts"]);
            this.FBtn_AdvanceChange[_loc3_] = new TUIButton();
            this.FBtn_AdvanceChange[_loc3_].Substrate = this.FMainUI["Talent" + _loc3_]["BtnAdvanceChange"];
            this.FBtn_AdvanceChange[_loc3_].Tag = _loc3_;
            this.FBtn_AdvanceChange[_loc3_].OnClick = this.ProcessorAddvanceChangeOnClick;
            _loc3_++;
         }
         this.FMainUI["MC_AdvanceChange"].visible = false;
         this.FBtn_CloseAdvanceChange = new TUIButton();
         this.FBtn_CloseAdvanceChange.Substrate = this.FMainUI["MC_AdvanceChange"]["Btn_close"];
         this.FBtn_CloseAdvanceChange.OnClick = this.ProcessorCloseAdvanceWin;
         this.FBtn_AdvanceChangeViewList = new TUIButton();
         this.FBtn_AdvanceChangeViewList.Substrate = this.FMainUI["MC_AdvanceChange"]["Btn_ViewList"];
         this.FBtn_AdvanceChangeViewList.OnMove = this.ProcessorViewListOnMove;
         this.FBtn_AdvanceChangeViewList.OnOut = this.ProcessorViewListOnOut;
         this.FBtn_AdvanceChangeRefresh = new TUIButton();
         this.FBtn_AdvanceChangeRefresh.Substrate = this.FMainUI["MC_AdvanceChange"]["Btn_Reflash"];
         this.FBtn_AdvanceChangeRefresh.OnClick = this.ProcessorAdvanceRefresh;
         this.FBtn_AdvanceChangeReturn = new TUIButton();
         this.FBtn_AdvanceChangeReturn.Substrate = this.FMainUI["MC_AdvanceChange"]["Btn_Return"];
         this.FBtn_AdvanceChangeReturn.OnClick = this.ProcessorCloseAdvanceReturn;
         (this.FMainUI["MC_AdvanceChange"]["Btn_Lock"] as MovieClip).addEventListener(MouseEvent.CLICK,this.ProcessorAdvanceLock);
         (this.FMainUI["MC_AdvanceChange"]["Btn_Lock"] as MovieClip).addEventListener(MouseEvent.MOUSE_MOVE,this.ProcessorAdvanceLockOnMove);
         (this.FMainUI["MC_AdvanceChange"]["Btn_Lock"] as MovieClip).addEventListener(MouseEvent.MOUSE_OUT,this.ProcessorAdvanceLockOnOut);
         (this.FMainUI["MC_AdvanceChange"]["Btn_Lock"] as MovieClip).gotoAndStop(2);
         (this.FMainUI["MC_AdvanceChange"]["Btn_Lock"] as MovieClip).buttonMode = true;
         this.FRoleMoudle = new TSceneSpriteMoudle();
         this.FQueryModel = new TMoudleInfor();
         this.FMainUI["MC_Heros"]["MC_MountPoint"].addChild(this.FRoleMoudle);
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainUI["Close"];
         this.FBtnClose.OnClick = this.BtnCloseOnClick;
         this.FHint = new THint();
         this.FStars = this.FMainUI["MC_Heros"]["StarLevel"];
         this.FHeroChangeLightStars = new Vector.<Sprite>();
         this.FHeroChangeDarkStars = new Vector.<Sprite>();
         _loc3_ = 0;
         while(_loc3_ < MaxStarNum)
         {
            this.FHeroChangeLightStars.push(this.FStars["Lightstar" + _loc3_]);
            this.FHeroChangeDarkStars.push(this.FStars["Darkstar" + _loc3_]);
            _loc3_++;
         }
         this.FChangeLevelString = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_18);
         this.FSoulPillNames = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_06);
      }
      
      public function UILocation() : void
      {
      }
      
      protected function RenderStarLevel(param1:THeroChange) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < MaxStarNum)
         {
            this.FHeroChangeLightStars[_loc2_].visible = _loc2_ < param1.Hero.ChangeSchedule;
            this.FHeroChangeDarkStars[_loc2_].visible = _loc2_ < param1.PartnerChanges.length;
            _loc2_++;
         }
      }
      
      protected function RenderHeroInfor(param1:THeroChange) : void
      {
         var _loc2_:TPartnerChange = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THero = null;
         this.FChipName.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_15),param1.Hero.Name);
         this.FTFSpecialChip.text = param1.HeroChipNum.toString();
         this.FTFCommonChip.text = this.FHeroChangeData.PowerfulChip.toString();
         this.FTF_NormalPill.text = this.FHeroChangeData.NormalSoulPillNum.toString();
         this.FTF_GradePill.text = this.FHeroChangeData.GradeSoulPillNum.toString();
         _loc5_ = SLogicsCore.Character.Heros.GetHeroByIdentifier(param1.Hero.Identifier);
         if(_loc5_ != null)
         {
            this.FTFName.text = TUtilityString.Format("%0 Lv%1",_loc5_.Name,_loc5_.RebirthLevel);
         }
         else
         {
            this.FTFName.text = TUtilityString.Format("%0 Lv%1",param1.Hero.Name,param1.Hero.RebirthLevel);
         }
         this.RenderStarLevel(param1);
         if(param1.Hero.ChangeSchedule >= param1.PartnerChanges.length)
         {
            this.FTFNeedMaterial.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_16);
            this.FBtnChange.Enabled = false;
         }
         else
         {
            _loc2_ = param1.PartnerChanges[param1.Hero.ChangeSchedule];
            if(_loc2_ == null)
            {
               this.FTFNeedMaterial.text = "";
               this.FBtnChange.Enabled = false;
            }
            else
            {
               this.FTFNeedMaterial.text = TUtilityString.Format("LV.%0\n",_loc2_.HeroLevel) + this.GetLevelUpMaterial(_loc2_);
               this.FBtnChange.Enabled = true;
            }
         }
         TUtilityTexture.QueryTwoDirectionShowCase(CONST_MAP.DIRECTION_RIGHT,param1.Hero.Identifier,this.FQueryModel);
         this.FRoleMoudle.ChangeRoleMoudle(this.FQueryModel.TextureID,1);
         _loc4_ = int(param1.PartnerChanges.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = param1.PartnerChanges[_loc3_];
            if(param1.PartnerChanges[_loc3_] != null)
            {
               this.FTalentLevel[_loc3_].text = this.FChangeLevelString[_loc3_];
               this.FTalentForecasts[_loc3_].visible = false;
               this.FTalentTextPanle[_loc3_].visible = true;
               if(_loc3_ >= param1.Hero.ChangeSchedule)
               {
                  this.FTalentTextPanle[_loc3_].filters = [TUtilityFilter.GaryColorFiltersTwo];
                  this.FTalentNames[_loc3_].text = _loc2_.Name;
                  this.FTalentDes[_loc3_].text = _loc2_.Desc;
               }
               else
               {
                  this.FTalentTextPanle[_loc3_].filters = null;
                  if(_loc5_.AdvanceChanges[_loc3_] == null || _loc5_.AdvanceChanges[_loc3_][0] == 0)
                  {
                     this.FTalentNames[_loc3_].text = _loc2_.Name;
                     this.FTalentDes[_loc3_].text = _loc2_.Desc;
                  }
                  else
                  {
                     this.FTalentNames[_loc3_].text = this.GetDescByIDValue(_loc5_.AdvanceChanges[_loc3_][0],_loc5_.AdvanceChanges[_loc3_][1]).name;
                     this.FTalentDes[_loc3_].text = this.GetDescByIDValue(_loc5_.AdvanceChanges[_loc3_][0],_loc5_.AdvanceChanges[_loc3_][1]).desc;
                  }
               }
            }
            else
            {
               this.FTalentForecasts[_loc3_].visible = true;
               this.FTalentTextPanle[_loc3_].visible = false;
            }
            _loc3_++;
         }
         while(_loc3_ < TalentNum)
         {
            this.FTalentForecasts[_loc3_].visible = false;
            this.FTalentTextPanle[_loc3_].visible = false;
            _loc3_++;
         }
         _loc4_ = int(param1.PartnerChanges.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = param1.PartnerChanges[_loc3_];
            if(param1.PartnerChanges[_loc3_] != null)
            {
               if(_loc3_ >= param1.Hero.ChangeSchedule)
               {
                  this.FBtn_AdvanceChange[_loc3_].Enabled = false;
               }
               else
               {
                  this.FBtn_AdvanceChange[_loc3_].Enabled = true;
               }
            }
            _loc3_++;
         }
         this.ConstructAdvanceWin();
         if(_loc5_ != null)
         {
            this.UpdateAdvanceWin(this.FCurLevel);
         }
      }
      
      protected function GetLevelUpMaterial(param1:TPartnerChange) : String
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc2_ = "";
         _loc5_ = int(param1.Rewards.Count);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc3_ = SToolReward.GetNameByTypeCode(param1.Rewards.Type[_loc4_],param1.Rewards.Code[_loc4_]);
            _loc2_ += TUtilityString.Format("%0 * %1\n",_loc3_,param1.Rewards.Amount[_loc4_]);
            _loc4_++;
         }
         return _loc2_.substr(0,_loc2_.length - 1);
      }
      
      protected function CountTalentIndex(param1:THeroChange) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TPartnerChange = null;
         _loc3_ = int(param1.PartnerChanges.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.PartnerChanges[_loc2_];
            if(_loc4_.Identifier > param1.Hero.ChangeSchedule)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return _loc3_ - 1;
      }
      
      protected function SetupPage(param1:int, param2:int, param3:TUIPage) : void
      {
         param3.TotalQuantity = param1;
         param3.Update();
         param3.PageIndex = param2;
      }
      
      protected function ChangeCheck(param1:THeroChange) : Boolean
      {
         var _loc2_:THero = null;
         var _loc3_:TPartnerChange = null;
         param1 = this.FHeros[this.FCurrentShowIndex];
         _loc2_ = SLogicsCore.Character.Heros.GetHeroByIdentifier(param1.Hero.Identifier);
         if(_loc2_ == null)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_07));
            return false;
         }
         _loc3_ = param1.PartnerChanges[param1.Hero.ChangeSchedule];
         if(_loc2_.Level < _loc3_.HeroLevel)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_17));
            return false;
         }
         return true;
      }
      
      protected function ConstructAdvanceWin() : void
      {
         var _loc1_:TBins = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         _loc4_ = "";
         _loc1_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_AdvanceChange);
         _loc2_ = uint(_loc1_.Count);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ += (_loc1_.GetDatebaseByIndex(_loc3_) as TPantnerAdvanceChange).ViewList + "\n";
            _loc3_++;
         }
         this.FViewListHint = new THint();
         this.FViewListHint.Caption = _loc4_;
         this.FMainUI["MC_AdvanceChange"]["TF_CostItem"].text = TUtilityLobby.GetItemName(TUtilityLobby.GetConfigValue(60380011)[0].type,TUtilityLobby.GetConfigValue(60380011)[0].code) + "*" + TUtilityLobby.GetConfigValue(60380011)[0].amount;
         this.FMainUI["MC_AdvanceChange"]["TF_CostGold"].text = TUtilityLobby.GetConfigValue(60380011)[1].amount + "";
      }
      
      protected function ProcessorViewListOnMove(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FViewListHint);
      }
      
      protected function ProcessorViewListOnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FViewListHint);
      }
      
      protected function ProcessorCloseAdvanceWin(param1:Object, param2:MouseEvent) : void
      {
         this.FMainUI["MC_AdvanceChange"].visible = false;
      }
      
      protected function ProcessorAddvanceChangeOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FCurLevel = param1.Tag;
         this.UpdateAdvanceWin(param1.Tag);
         this.FMainUI["MC_AdvanceChange"].visible = true;
      }
      
      protected function ProcessorAdvanceRefresh(param1:Object, param2:MouseEvent) : void
      {
         TUtilityLobby.GoldBuy(TUtilityLobby.GetConfigValue(60380011)[1].amount,this.ProcessorGoldAdvanceRefresh,null,true,true);
      }
      
      protected function ProcessorGoldAdvanceRefresh(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_HeroChange_AdvanceRefreshReq);
         _loc2_.Data.writeInt(this.FHeros[this.FCurrentShowIndex].Hero.Identifier);
         _loc2_.Data.writeInt(this.FCurLevel + 1);
         _loc2_.Data.writeByte(this.FLock);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function ProcessorCloseAdvanceReturn(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_HeroChange_AdvanceReturnReq);
         _loc3_.Data.writeInt(this.FHeros[this.FCurrentShowIndex].Hero.Identifier);
         _loc3_.Data.writeInt(this.FCurLevel + 1);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function ProcessorAdvanceLock(param1:MouseEvent) : void
      {
         this.FMainUI["MC_AdvanceChange"]["Btn_Lock"].gotoAndStop(this.FLock + 1);
         this.FLock = 1 - this.FLock;
      }
      
      protected function ProcessorAdvanceLockOnMove(param1:MouseEvent) : void
      {
         this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(70350044);
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function ProcessorAdvanceLockOnOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      protected function UpdateAdvanceWin(param1:uint) : void
      {
         var _loc2_:THeroChange = null;
         var _loc3_:THero = null;
         _loc3_ = SLogicsCore.Character.Heros.GetHeroByIdentifier(this.FHeros[this.FCurrentShowIndex].Hero.Identifier);
         _loc2_ = this.FHeros[this.FCurrentShowIndex];
         if(_loc3_.AdvanceChanges[param1] == null || _loc3_.AdvanceChanges[param1][0] == 0)
         {
            this.FMainUI["MC_AdvanceChange"]["TF_SkillName"].text = _loc2_.PartnerChanges[param1].Name;
            this.FMainUI["MC_AdvanceChange"]["TF_Desc"].text = _loc2_.PartnerChanges[param1].Desc;
         }
         else
         {
            this.FMainUI["MC_AdvanceChange"]["TF_SkillName"].text = this.GetDescByIDValue(_loc3_.AdvanceChanges[param1][0],_loc3_.AdvanceChanges[param1][1]).name;
            this.FMainUI["MC_AdvanceChange"]["TF_Desc"].text = this.GetDescByIDValue(_loc3_.AdvanceChanges[param1][0],_loc3_.AdvanceChanges[param1][1]).desc;
         }
      }
      
      protected function GetDescByIDValue(param1:uint, param2:uint) : Object
      {
         var _loc3_:TPantnerAdvanceChange = null;
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:Vector.<String> = null;
         _loc4_ = new Object();
         if(param1 == 105)
         {
            _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_AdvanceChange,param1) as TPantnerAdvanceChange;
            _loc4_.name = _loc3_.Desc;
            _loc5_ = uint(_loc3_.Value.indexOf(param2));
            _loc6_ = Vector.<String>(Json.decode(_loc3_.ClientDeec));
            _loc4_.desc = _loc6_[_loc5_];
         }
         else
         {
            _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_AdvanceChange,param1) as TPantnerAdvanceChange;
            _loc4_.name = _loc3_.Desc;
            _loc4_.desc = _loc3_.ClientDeec + param2.toString() + "%";
         }
         return _loc4_;
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function BtnChangeOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:TPacket = null;
         _loc3_ = this.ChangeCheck(this.FHeros[this.FCurrentShowIndex]);
         if(!_loc3_)
         {
            return;
         }
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_HeroChange_ChangeReq);
         _loc4_.Data.writeInt(this.FHeros[this.FCurrentShowIndex].Hero.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
      }
      
      protected function BtnMakePillOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
         if(this.FOnMakePill != null)
         {
            this.FOnMakePill(this);
         }
      }
      
      protected function PageOnChange(param1:Object, param2:int) : void
      {
         this.FCurrentShowIndex = param2;
         this.RenderHeroInfor(this.FHeros[this.FCurrentShowIndex]);
      }
      
      protected function MaterialIconOnMove(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FMaterialIcons.indexOf(param1.currentTarget as Sprite);
         this.FHint.Caption = this.FSoulPillNames[_loc2_];
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function MaterialIconOnOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      public function set HeroChangeData(param1:THeroChangeData) : void
      {
         this.FHeroChangeData = param1;
      }
      
      public function set OnMakePill(param1:Function) : void
      {
         this.FOnMakePill = param1;
      }
      
      public function Show(param1:Vector.<THeroChange>, param2:int) : void
      {
         this.FHeros = param1;
         this.FCurrentShowIndex = param2;
         this.RenderHeroInfor(param1[this.FCurrentShowIndex]);
         this.SetupPage(param1.length,param2,this.FUIPage);
         Visible = true;
      }
      
      public function ChangeNotify() : void
      {
         this.RenderHeroInfor(this.FHeros[this.FCurrentShowIndex]);
      }
   }
}

