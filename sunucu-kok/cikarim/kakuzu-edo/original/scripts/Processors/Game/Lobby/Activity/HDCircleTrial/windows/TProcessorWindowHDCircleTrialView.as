package Processors.Game.Lobby.Activity.HDCircleTrial.windows
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Common.THint;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.Json.TFixedAward;
   import Logics.HDActivityCircleTrial.TActivityCircleTrialData;
   import Logics.Inventories.TInventories;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.HyperLink.SUtilityHyperLink;
   import Processors.Game.Utilities.HyperLink.TUtilityHyperLink;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.setTimeout;
   import ghostcat.util.easing.TweenUtil;
   
   public class TProcessorWindowHDCircleTrialView extends TUIComponent
   {
      
      public const Block_Count:int = 5;
      
      public const Award_Count:int = 9;
      
      public const Gift_Count:int = 3;
      
      public const Hero_Gift_Count:int = 4;
      
      public const DelayTime:int = 800;
      
      public const GoldExtract:int = 1;
      
      public const ScoreExtract:int = 2;
      
      public const OneKeyExtract:int = 3;
      
      protected var FInitBol:Boolean;
      
      protected var FIsScanPlay:Boolean;
      
      protected var FIsOperateOver:Boolean = true;
      
      protected var FPlayFrame:int;
      
      protected var FIsStop:Boolean;
      
      protected var FMC_Scene:Sprite;
      
      protected var FBlockScoreTFVec:Vector.<TextField>;
      
      protected var FBlockPassTFVec:Vector.<TextField>;
      
      protected var FBlockNameTFVec:Vector.<TextField>;
      
      protected var FImageMCVec:Vector.<MovieClip>;
      
      protected var FBlockButtonVec:Vector.<TUIButton>;
      
      protected var FTotalScoreTF:TextField;
      
      protected var FExtractTF:TextField;
      
      protected var FDebrisTF:TextField;
      
      protected var FScoreExtractBtn:TUIButton;
      
      protected var FGoldExtractBtn:TUIButton;
      
      protected var FOnkeyExtractBtn:TUIButton;
      
      protected var FAwardSlots:Vector.<TUISlot>;
      
      protected var FAnimaBgList:Vector.<MovieClip>;
      
      protected var FGiftsList:Vector.<TUIButton>;
      
      protected var FGiftsGetStateList:Vector.<Sprite>;
      
      protected var FGiftsTFPercentList:Vector.<TextField>;
      
      protected var FGiftsTFList:Vector.<TextField>;
      
      protected var FGiftsBarMcList:Vector.<Sprite>;
      
      protected var FHeroGiftList:Vector.<TUIButton>;
      
      protected var FHeroGiftGetStateList:Vector.<Sprite>;
      
      protected var FHeroGiftInfoTFList:Vector.<TextField>;
      
      protected var FHeroGiftNameTFList:Vector.<TextField>;
      
      protected var FHeroGiftMCBarList:Vector.<Sprite>;
      
      protected var FHint:THint;
      
      protected var FActivityImage:Sprite;
      
      protected var FActivityImageTF:TextField;
      
      protected var FExtractType:int;
      
      protected var FActivityCircleTrialData:TActivityCircleTrialData;
      
      protected var FGiftMoveFun:Function;
      
      protected var FGiftOutFun:Function;
      
      protected var FSendData:Function;
      
      public function TProcessorWindowHDCircleTrialView(param1:TUIComponent, param2:Sprite)
      {
         super(param1);
         this.FMC_Scene = param2;
         this.FHint = new THint();
         this.FBlockScoreTFVec = new Vector.<TextField>();
         this.FBlockPassTFVec = new Vector.<TextField>();
         this.FBlockNameTFVec = new Vector.<TextField>();
         this.FImageMCVec = new Vector.<MovieClip>();
         this.FBlockButtonVec = new Vector.<TUIButton>();
         this.FAwardSlots = new Vector.<TUISlot>();
         this.FAnimaBgList = new Vector.<MovieClip>();
         this.FGiftsList = new Vector.<TUIButton>();
         this.FGiftsTFList = new Vector.<TextField>();
         this.FGiftsBarMcList = new Vector.<Sprite>();
         this.FGiftsGetStateList = new Vector.<Sprite>();
         this.FGiftsTFPercentList = new Vector.<TextField>();
         this.FHeroGiftList = new Vector.<TUIButton>();
         this.FHeroGiftGetStateList = new Vector.<Sprite>();
         this.FHeroGiftInfoTFList = new Vector.<TextField>();
         this.FHeroGiftMCBarList = new Vector.<Sprite>();
         this.FHeroGiftNameTFList = new Vector.<TextField>();
         this.FHint = new THint();
         this.FActivityImage = this.FMC_Scene["MC_ActivityImage"];
         this.FActivityImage.visible = false;
         this.FActivityImageTF = this.FActivityImage["TF_DebrisValue"];
         this.InitWindow();
      }
      
      protected function InitWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         this.InitBlockResource();
         this.InitAwardResource();
         this.InitGiftResource();
      }
      
      protected function UpdatePropSlots() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FAwardSlots.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FAwardSlots[_loc1_].Update();
            _loc1_++;
         }
         if(SLogicsCore.Character.CreditGold >= this.FActivityCircleTrialData.ExtractCostGold)
         {
            this.FGoldExtractBtn.Enabled = true;
         }
         else
         {
            this.FGoldExtractBtn.Enabled = false;
         }
      }
      
      protected function InitBlockResource() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         _loc2_ = this.Block_Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_Scene["MC_Level"]["MC_Point" + _loc1_];
            this.FBlockScoreTFVec.push(_loc3_["ScoreTF"]);
            this.FBlockPassTFVec.push(_loc3_["TimesTF"]);
            this.FBlockNameTFVec.push(_loc3_["LevelTF"]);
            this.FImageMCVec.push(_loc3_["MC_LevelType"]);
            _loc1_++;
         }
      }
      
      protected function InitAwardResource() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:MovieClip = null;
         var _loc5_:TUISlot = null;
         this.FTotalScoreTF = this.FMC_Scene["MC_Award"]["TotalScoreTF"];
         this.FExtractTF = this.FMC_Scene["MC_Award"]["ExtractScoreTF"];
         this.FDebrisTF = this.FMC_Scene["MC_Award"]["DebrisTFValue"];
         this.FScoreExtractBtn = new TUIButton();
         this.FScoreExtractBtn.Substrate = this.FMC_Scene["MC_Award"]["Btn_Extract"];
         this.FScoreExtractBtn.OnClick = this.ScoreOnClick;
         this.FScoreExtractBtn.OnOut = this.OutHandler;
         this.FScoreExtractBtn.OnMove = this.OverScoreHandler;
         this.FGoldExtractBtn = new TUIButton();
         this.FGoldExtractBtn.Substrate = this.FMC_Scene["MC_Award"]["Btn_GoldExtract"];
         this.FGoldExtractBtn.OnClick = this.GoldOnClick;
         this.FGoldExtractBtn.OnOut = this.OutHandler;
         this.FGoldExtractBtn.OnMove = this.OverGoldHandler;
         this.FOnkeyExtractBtn = new TUIButton();
         this.FOnkeyExtractBtn.Substrate = this.FMC_Scene["MC_Award"]["Btn_OneKeyExtract"];
         this.FOnkeyExtractBtn.OnClick = this.OneKeyOnClick;
         _loc2_ = this.Award_Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_Scene["MC_Award"]["Item" + _loc1_];
            _loc4_ = _loc3_["SelectBox"] as MovieClip;
            _loc4_.gotoAndStop(0);
            _loc5_ = new TUISlot(this);
            _loc5_.Resource = _loc3_["Slot"];
            _loc5_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc5_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc5_);
            _loc5_.Init();
            this.FAwardSlots.push(_loc5_);
            this.FAnimaBgList.push(_loc4_);
            _loc1_++;
         }
      }
      
      protected function InitGiftResource() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUISlot = null;
         var _loc4_:TUIButton = null;
         var _loc5_:TextField = null;
         var _loc6_:Sprite = null;
         _loc2_ = this.Gift_Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = new TUIButton();
            _loc4_.Substrate = this.FMC_Scene["MC_Item" + _loc1_]["MC_Award"];
            _loc4_.OnMove = this.GiftTaskBagOnMove;
            _loc4_.OnOut = this.GiftBagOnOut;
            _loc4_.OnClick = this.GetAwardOnClick;
            this.FGiftsList.push(_loc4_);
            _loc5_ = this.FMC_Scene["MC_Item" + _loc1_]["DebrisTF"];
            this.FGiftsTFList.push(_loc5_);
            _loc5_ = this.FMC_Scene["MC_Item" + _loc1_]["TFPercent"];
            this.FGiftsTFPercentList.push(_loc5_);
            _loc6_ = this.FMC_Scene["MC_Item" + _loc1_]["MC_Bar"];
            this.FGiftsBarMcList.push(_loc6_);
            _loc6_ = this.FMC_Scene["MC_Item" + _loc1_]["MC_Finish"];
            this.FGiftsGetStateList.push(_loc6_);
            _loc1_++;
         }
         _loc2_ = this.Hero_Gift_Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = new TUIButton();
            _loc4_.Substrate = this.FMC_Scene["MC_HeroAwardGift" + _loc1_]["MC_Slot"];
            _loc4_.OnMove = this.GiftHeroBagOnMove;
            _loc4_.OnOut = this.GiftBagOnOut;
            _loc4_.OnClick = this.GetHeroAwardOnClick;
            this.FHeroGiftList.push(_loc4_);
            _loc6_ = this.FMC_Scene["MC_HeroAwardGift" + _loc1_]["MC_Bar"];
            this.FHeroGiftMCBarList.push(_loc6_);
            _loc5_ = this.FMC_Scene["MC_HeroAwardGift" + _loc1_]["InfoTF"];
            this.FHeroGiftInfoTFList.push(_loc5_);
            _loc5_ = this.FMC_Scene["MC_HeroAwardGift" + _loc1_]["TFName"];
            this.FHeroGiftNameTFList.push(_loc5_);
            _loc6_ = this.FMC_Scene["MC_HeroAwardGift" + _loc1_]["MC_Finish"];
            _loc6_.visible = false;
            this.FHeroGiftGetStateList.push(_loc6_);
            _loc1_++;
         }
      }
      
      protected function RenderShowPorpList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TInventories = null;
         _loc2_ = int(this.FActivityCircleTrialData.ExtractInventories.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FActivityCircleTrialData.ExtractInventories[_loc1_];
            this.FAwardSlots[_loc1_].Context = null;
            this.FAwardSlots[_loc1_].Context = _loc3_.GetInventoryByIndex(0);
            _loc1_++;
         }
      }
      
      protected function RenderGiftFinishState() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIButton = null;
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         var _loc6_:Boolean = false;
         _loc2_ = int(this.FActivityCircleTrialData.HDDataList.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FActivityCircleTrialData.HDDataList[_loc1_].CurrentGetValue == -1)
            {
               this.FGiftsList[_loc1_].Enabled = false;
               _loc4_ = 1;
               this.FGiftsBarMcList[_loc1_].scaleX = _loc4_;
               this.FGiftsGetStateList[_loc1_].visible = true;
               this.FGiftsTFPercentList[_loc1_].text = this.FActivityCircleTrialData.HDDataList[_loc1_].TotalValue + "/" + this.FActivityCircleTrialData.HDDataList[_loc1_].TotalValue;
            }
            else
            {
               this.FGiftsList[_loc1_].Enabled = true;
               _loc4_ = this.FActivityCircleTrialData.HDDataList[_loc1_].CurrentGetValue / this.FActivityCircleTrialData.HDDataList[_loc1_].TotalValue;
               this.FGiftsBarMcList[_loc1_].scaleX = _loc4_ > 1 ? 1 : _loc4_;
               this.FGiftsGetStateList[_loc1_].visible = false;
               this.FGiftsTFPercentList[_loc1_].text = this.FActivityCircleTrialData.HDDataList[_loc1_].CurrentGetValue + "/" + this.FActivityCircleTrialData.HDDataList[_loc1_].TotalValue;
               if(this.FActivityCircleTrialData.HDDataList[_loc1_].CurrentGetValue >= this.FActivityCircleTrialData.HDDataList[_loc1_].TotalValue)
               {
                  this.FGiftsList[_loc1_].Enabled = true;
               }
               else
               {
                  this.FGiftsList[_loc1_].Enabled = false;
               }
            }
            _loc5_ = TUtilityString.Format(this.FActivityCircleTrialData.HDDataList[_loc1_].EmployName,this.FActivityCircleTrialData.HDDataList[_loc1_].TotalValue);
            this.FGiftsTFList[_loc1_].text = _loc5_;
            _loc1_++;
         }
         _loc2_ = int(this.FActivityCircleTrialData.HDHeroGiftDataList.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FActivityCircleTrialData.HDHeroGiftDataList[_loc1_].GetAwardState == -1)
            {
               this.FHeroGiftList[_loc1_].Enabled = false;
               _loc4_ = 1;
               this.FHeroGiftMCBarList[_loc1_].scaleX = _loc4_;
               this.FHeroGiftGetStateList[_loc1_].visible = true;
            }
            else
            {
               this.FHeroGiftList[_loc1_].Enabled = true;
               _loc4_ = this.FActivityCircleTrialData.HDHeroGiftDataList[_loc1_].CurrentGetValue / this.FActivityCircleTrialData.HDHeroGiftDataList[_loc1_].TotalValue;
               this.FHeroGiftMCBarList[_loc1_].scaleX = _loc4_ > 1 ? 1 : _loc4_;
               this.FHeroGiftGetStateList[_loc1_].visible = false;
               _loc6_ = Boolean(SLogicsCore.Character.Heros.GetHeroByIdentifier(this.FActivityCircleTrialData.HDHeroGiftDataList[_loc1_].HeroId)) || Boolean(SLogicsCore.Character.Heros.GetHeroByIdentifier(this.FActivityCircleTrialData.HDHeroGiftDataList[_loc1_].UpHeroId));
               this.FHeroGiftList[_loc1_].Enabled = _loc6_;
            }
            this.FHeroGiftInfoTFList[_loc1_].text = this.FActivityCircleTrialData.HDHeroGiftDataList[_loc1_].EmployName + this.FActivityCircleTrialData.HDHeroGiftDataList[_loc1_].CurrentGetValue + "/" + this.FActivityCircleTrialData.HDHeroGiftDataList[_loc1_].TotalValue;
            this.FHeroGiftNameTFList[_loc1_].text = this.FActivityCircleTrialData.HDHeroGiftDataList[_loc1_].HeroGiftName;
            _loc1_++;
         }
      }
      
      protected function UpdateGiftButtonState() : void
      {
      }
      
      protected function UpdateBaseView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FTotalScoreTF.text = this.FActivityCircleTrialData.PlayerTotalScore.toString();
         this.FDebrisTF.text = this.FActivityCircleTrialData.CurrentDebrisNum.toString();
         _loc2_ = int(this.FActivityCircleTrialData.BlockList.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FBlockPassTFVec[_loc1_].text = this.FActivityCircleTrialData.BlockList[_loc1_].BlockPassTimes.toString();
            this.FBlockScoreTFVec[_loc1_].text = this.FActivityCircleTrialData.BlockList[_loc1_].BlockScore.toString();
            this.FBlockNameTFVec[_loc1_].text = this.FActivityCircleTrialData.BlockList[_loc1_].BlockName;
            _loc1_++;
         }
         if(this.FActivityCircleTrialData.PlayerTotalScore >= this.FActivityCircleTrialData.ExtractCostScore)
         {
            this.FScoreExtractBtn.Enabled = true;
            this.FOnkeyExtractBtn.Enabled = true;
         }
         else
         {
            this.FScoreExtractBtn.Enabled = false;
            this.FOnkeyExtractBtn.Enabled = false;
         }
         if(SLogicsCore.Character.CreditGold >= this.FActivityCircleTrialData.ExtractCostGold)
         {
            this.FGoldExtractBtn.Enabled = true;
         }
         else
         {
            this.FGoldExtractBtn.Enabled = false;
         }
         this.FActivityImageTF.text = this.FActivityCircleTrialData.ImageDebris.toString();
      }
      
      protected function UpdateUI() : void
      {
         this.RenderGiftFinishState();
         this.RenderShowPorpList();
         this.UpdateBaseView();
         this.UpdateGiftButtonState();
      }
      
      protected function SendServiceData(param1:int = 0) : void
      {
         if(this.FSendData != null)
         {
            this.FSendData(param1);
         }
      }
      
      protected function ClearSelectBox() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FAnimaBgList.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FAnimaBgList[_loc1_].gotoAndStop(1);
            this.FAnimaBgList[_loc1_].alpha = 1;
            _loc1_++;
         }
      }
      
      protected function SetUIButton() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIButton = null;
         if(this.FInitBol)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < this.FActivityCircleTrialData.BlockList.length)
         {
            this.FImageMCVec[_loc1_].gotoAndStop(this.FActivityCircleTrialData.BlockList[_loc1_].BlockType);
            _loc1_++;
         }
         _loc2_ = int(this.FActivityCircleTrialData.BlockList.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new TUIButton();
            _loc3_.Substrate = this.FImageMCVec[_loc1_]["MC_Button"];
            _loc3_.OnClick = this.OpenTrialOnClick;
            this.FBlockButtonVec.push(_loc3_);
            _loc1_++;
         }
         this.FInitBol = true;
      }
      
      protected function PlayAnima() : void
      {
         var _loc1_:MovieClip = null;
         if(this.FIsScanPlay)
         {
            this.FIsScanPlay = false;
            _loc1_ = this.FAnimaBgList[this.FPlayFrame];
            _loc1_.play();
         }
         if(this.FAnimaBgList[this.FPlayFrame] != null && this.FIsStop)
         {
            if(this.FAnimaBgList[this.FPlayFrame].currentFrame >= this.FAnimaBgList[this.FPlayFrame].totalFrames)
            {
               this.FIsScanPlay = true;
               ++this.FPlayFrame;
               if(this.FPlayFrame >= this.Award_Count)
               {
                  this.FPlayFrame = 0;
               }
            }
         }
      }
      
      protected function GoldExtractRequest(param1:Object) : void
      {
         var Sender:Object = param1;
         this.FIsScanPlay = true;
         this.FIsStop = true;
         if(this.FIsOperateOver)
         {
            this.FExtractType = this.GoldExtract;
            this.FIsOperateOver = false;
            this.ClearSelectBox();
            setTimeout(function DelaySendFun():void
            {
               SendServiceData(FActivityCircleTrialData.ExtractGoldIndex);
            },this.DelayTime);
         }
      }
      
      protected function GiftTaskBagOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FGiftsList.indexOf(param1 as TUIButton);
         if(this.FGiftMoveFun != null)
         {
            this.FGiftMoveFun(this.FActivityCircleTrialData.HDDataList[_loc3_].Inventories);
         }
      }
      
      protected function GiftHeroBagOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FHeroGiftList.indexOf(param1 as TUIButton);
         if(this.FGiftMoveFun != null)
         {
            this.FGiftMoveFun(this.FActivityCircleTrialData.HDHeroGiftDataList[_loc3_].Inventories);
         }
      }
      
      protected function GiftBagOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FGiftOutFun != null)
         {
            this.FGiftOutFun();
         }
      }
      
      protected function ScoreOnClick(param1:Object, param2:MouseEvent) : void
      {
         var Sender:Object = param1;
         var E:MouseEvent = param2;
         this.FIsScanPlay = true;
         this.FIsStop = true;
         if(this.FIsOperateOver)
         {
            this.FExtractType = this.ScoreExtract;
            this.FIsOperateOver = false;
            this.ClearSelectBox();
            setTimeout(function DelaySendFun():void
            {
               SendServiceData(FActivityCircleTrialData.ExtractScoreIndex);
            },this.DelayTime);
         }
      }
      
      protected function GoldOnClick(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),this.FActivityCircleTrialData.ExtractCostGold);
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.GoldExtractRequest;
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
      }
      
      protected function OneKeyOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:MovieClip = null;
         _loc4_ = int(this.FAnimaBgList.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this.FAnimaBgList[_loc3_];
            _loc5_.gotoAndStop(2);
            _loc5_.alpha = 1;
            TweenUtil.to(_loc5_,800,{"alpha":0});
            _loc3_++;
         }
         this.FExtractType = this.OneKeyExtract;
         this.SendServiceData(this.FActivityCircleTrialData.ExtractOnKeyIndex);
      }
      
      protected function GetHeroAwardOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = this.FHeroGiftList.indexOf(param1 as TUIButton);
         _loc4_ = this.FActivityCircleTrialData.HDHeroGiftDataList[_loc3_].Index;
         this.SendServiceData(_loc4_);
      }
      
      protected function GetAwardOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = this.FGiftsList.indexOf(param1 as TUIButton);
         _loc4_ = this.FActivityCircleTrialData.HDDataList[_loc3_].Index;
         this.SendServiceData(_loc4_);
      }
      
      protected function OpenTrialOnClick(param1:Object, param2:MouseEvent) : void
      {
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_VainTravel);
      }
      
      protected function OverScoreHandler(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         _loc3_ = this.FActivityCircleTrialData.ExtractCostScore;
         _loc4_ = this.FActivityCircleTrialData.PromptFontArr[1];
         _loc4_ = TUtilityString.Format(_loc4_,_loc3_);
         this.FHint.Caption = _loc4_;
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function OverGoldHandler(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         _loc3_ = this.FActivityCircleTrialData.ExtractCostGold;
         _loc4_ = this.FActivityCircleTrialData.PromptFontArr[0];
         _loc4_ = TUtilityString.Format(_loc4_,_loc3_);
         this.FHint.Caption = _loc4_;
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function OutHandler(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      public function set ActivityCircleTrialData(param1:TActivityCircleTrialData) : void
      {
         this.FActivityCircleTrialData = param1;
         this.SetUIButton();
      }
      
      public function get GiftMoveFun() : Function
      {
         return this.FGiftMoveFun;
      }
      
      public function set GiftMoveFun(param1:Function) : void
      {
         this.FGiftMoveFun = param1;
      }
      
      public function get GiftOutFun() : Function
      {
         return this.FGiftOutFun;
      }
      
      public function set GiftOutFun(param1:Function) : void
      {
         this.FGiftOutFun = param1;
      }
      
      public function get SendData() : Function
      {
         return this.FSendData;
      }
      
      public function set SendData(param1:Function) : void
      {
         this.FSendData = param1;
      }
      
      public function ShowView() : void
      {
         this.UpdateUI();
         this.ShowActivityImage(false);
      }
      
      public function LogicsPerform() : void
      {
         if(this.visible)
         {
            this.UpdatePropSlots();
            this.PlayAnima();
         }
      }
      
      public function OnOperatRet(param1:Vector.<TFixedAward>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TFixedAward = null;
         var _loc5_:int = 0;
         var _loc6_:MovieClip = null;
         _loc3_ = int(this.FActivityCircleTrialData.FixedAwardVec.length);
         this.FIsOperateOver = true;
         this.FIsScanPlay = false;
         this.FIsStop = false;
         if(param1.length >= 1 && (this.FExtractType == this.GoldExtract || this.FExtractType == this.ScoreExtract))
         {
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               _loc4_ = this.FActivityCircleTrialData.FixedAwardVec[_loc2_];
               if(_loc4_.Amount == param1[0].Amount && _loc4_.Type == param1[0].Type && _loc4_.Code == param1[0].Code)
               {
                  _loc5_ = _loc2_;
                  this.FAnimaBgList[_loc5_].gotoAndStop(2);
                  this.FExtractType = 0;
                  break;
               }
               _loc2_++;
            }
         }
      }
      
      public function ShowActivityImage(param1:Boolean) : void
      {
         this.FActivityImage.visible = param1;
      }
      
      public function UpdateArrive(param1:int, param2:int) : void
      {
      }
   }
}

