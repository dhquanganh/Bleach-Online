package Processors.Game.Lobby.Activity.HDPyramid
{
   import Components.ScrollBar.TScrollBar;
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.Json.TRewards;
   import Logics.DatebaseVO.VO.TAward;
   import Logics.DatebaseVO.VO.THDPyramid;
   import Logics.HDActivityMode.TGiftBoxTipData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDPyramid.THDPyramidData;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Logics.KnifeOfKillSoul.TKnifeOfKillSoulData;
   import Logics.Log.TLog;
   import Processors.Game.Common.Effects.TWheelEffect;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_LOG;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import ghostcat.util.data.Json;
   
   public class TProsessorHDPyramidView extends TProcessorHDSingleWindowBase
   {
      
      public static const SHOPNUM:uint = 9;
      
      public static const PYRAMIDNUM:uint = 15;
      
      public static const PYRAMIDBASE:uint = 5;
      
      public static const PYRAMINDEX:Array = [0,5,9,12,14];
      
      protected var FDataVO:THDPyramidData;
      
      protected var FConfig:THDPyramid;
      
      protected var FMC_Shop:Sprite;
      
      protected var FBtn_CloseShop:TUIButton;
      
      protected var FTF_ShopScore:TextField;
      
      protected var FMC_ShopSlots:Vector.<TUISlot>;
      
      protected var FMC_ShopSlotTips:Vector.<Sprite>;
      
      protected var FMC_ShopSlotBtns:Vector.<TUIButton>;
      
      protected var FMC_ShopSlotCosts:Vector.<TextField>;
      
      protected var FMC_MainSlots:Vector.<TUISlot>;
      
      protected var FTF_Gold:TextField;
      
      protected var FTF_Num:TextField;
      
      protected var FBtn_OK_1:TUIButton;
      
      protected var FBtn_OK_10:TUIButton;
      
      protected var FBtn_OK_50:TUIButton;
      
      protected var FBtn_Report:TUIButton;
      
      protected var FMC_Mall:Sprite;
      
      protected var FBtn_Shop:TUIButton;
      
      protected var FTF_Score:TextField;
      
      protected var FBtn_OK:TUIButton;
      
      protected var FMC_Selected:MovieClip;
      
      protected var FSelectedIndex:uint;
      
      protected var FPlayLine:uint;
      
      protected var FScrollBar:TScrollBar;
      
      protected var FWheelEffect:TWheelEffect;
      
      protected var FGiftBoxTipData:TGiftBoxTipData;
      
      protected var FKnifeData:TKnifeOfKillSoulData;
      
      protected var FInventories:TInventories;
      
      protected var FOnLoadLog:Function;
      
      public function TProsessorHDPyramidView(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.UpdateUIConfig();
         this.FConfig = FHDActivityConfig as THDPyramid;
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
      }
      
      protected function UpdateShop() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         this.FTF_ShopScore.text = this.FDataVO.ScoreNum + "";
         _loc2_ = SHOPNUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_ShopSlotCosts[_loc1_].text = this.FConfig.Gift[_loc1_].costScore + "";
            this.SetData(this.FConfig.Gift[_loc1_].awardId,this.FMC_ShopSlots[_loc1_]);
            this.FMC_ShopSlotTips[_loc1_].visible = this.FConfig.Gift[_loc1_].limit == 1 ? true : false;
            this.FMC_ShopSlotBtns[_loc1_].Enabled = false;
            if(this.FDataVO.ScoreNum >= this.FConfig.Gift[_loc1_].costScore && this.FDataVO.GiftStatus[_loc1_] < this.FConfig.Gift[_loc1_].limit)
            {
               this.FMC_ShopSlotBtns[_loc1_].Enabled = true;
            }
            _loc1_++;
         }
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this.FDataVO = param1 as THDPyramidData;
         this.UpdateShop();
         this.UpdateMain();
         if(this.FOnLoadLog != null)
         {
            this.FOnLoadLog(CONST_LOG.LOGTYPE_Pyramid,this.LogArrive);
         }
      }
      
      protected function UpdateMain() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc2_ = PYRAMIDNUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.SetData(this.FConfig.Awards[_loc1_],this.FMC_MainSlots[_loc1_]);
            _loc1_++;
         }
         this.FTF_Gold.text = this.FDataVO.RechargeNum + "";
         this.FTF_Num.text = this.FDataVO.ExtractNum + "";
         this.FTF_Score.text = this.FDataVO.ScoreNum + "";
         this.FBtn_OK_1.Tag = this.FConfig.SmashOne;
         this.FBtn_OK_10.Tag = this.FConfig.SmashTen;
         this.FBtn_OK_50.Tag = this.FConfig.SmashFifty;
         this.FBtn_OK_1.Enabled = this.FBtn_OK_10.Enabled = this.FBtn_OK_50.Enabled = true;
         if(this.FDataVO.ExtractNum < 1)
         {
            this.FBtn_OK_1.Enabled = false;
         }
         if(this.FDataVO.ExtractNum < 10)
         {
            this.FBtn_OK_10.Enabled = false;
         }
         if(this.FDataVO.ExtractNum < 50)
         {
            this.FBtn_OK_50.Enabled = false;
         }
         this.FBtn_Report.Visible = this.FConfig.FightReportAddr != "" ? true : false;
         this.newMethod();
      }
      
      protected function OnCloseShop(param1:Object, param2:MouseEvent) : void
      {
         this.FMC_Shop.visible = false;
      }
      
      protected function AwardOnMove(param1:Object, param2:MouseEvent = null) : void
      {
         switch(this.FConfig.ShowType)
         {
            case 0:
            case 1:
               break;
            case 2:
               this.FGiftBoxTipData.TipReset();
               this.FGiftBoxTipData.NormalInventories = this.FInventories;
               this.FGiftBoxTipData.AwardType = 0;
               this.FGiftBoxTipData.NeedColour = true;
               SUtilityOverLayer.UIComponentsHintOnOver(this,this.FGiftBoxTipData);
         }
      }
      
      protected function AwardOnOut(param1:Object, param2:MouseEvent = null) : void
      {
         switch(this.FConfig.ShowType)
         {
            case 0:
            case 1:
               break;
            case 2:
               SUtilityOverLayer.UIComponentsHintOnOut(this,this.FGiftBoxTipData);
         }
      }
      
      protected function AwardOnClick(param1:Object, param2:MouseEvent = null) : void
      {
         switch(this.FConfig.ShowType)
         {
            case 0:
               SUtilityOverLayer.WindowShowHero.HeroID = this.FConfig.ShowID;
               SUtilityOverLayer.WindowShowHero.Show();
               break;
            case 1:
               this.FKnifeData = TUtilityLobby.CreateKnifeOfSkillSoulData(this.FConfig.ShowID);
               SUtilityOverLayer.KnifePop.KnifeData = this.FKnifeData;
               SUtilityOverLayer.KnifePop.Visible = true;
               break;
            case 2:
         }
      }
      
      protected function OnSmartGet(param1:Object, param2:MouseEvent) : void
      {
         this.FMC_Shop.visible = true;
      }
      
      protected function OnSelect(param1:MouseEvent) : void
      {
         this.FMC_Selected.gotoAndStop(2 - this.FSelectedIndex);
         this.FSelectedIndex = 1 - this.FSelectedIndex;
      }
      
      protected function OnExtract(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc4_ = PYRAMIDNUM;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            FScene["MC_Slot_" + _loc3_]["SelectBox"].visible = false;
            _loc3_++;
         }
         if(param1.Tag == this.FConfig.SmashOne && this.FSelectedIndex == 1 && this.FDataVO.CurLine != 4)
         {
            if(this.FDataVO.PreLine != 3 || this.FDataVO.Position != 0 || this.FDataVO.CurLine != 4)
            {
               if(!this.FWheelEffect.IsStart)
               {
                  this.FPlayLine = this.FDataVO.CurLine;
                  this.FWheelEffect.Init(PYRAMIDBASE - this.FPlayLine,50,1);
               }
               this.FWheelEffect.Play();
               FScene.mouseChildren = false;
               FScene.mouseEnabled = false;
            }
         }
         else if(this.FDataVO.CurLine == 4 && this.FDataVO.PreLine == 99 && this.FDataVO.Position == 99)
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param1.Tag);
            _loc4_ = PYRAMIDNUM;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               FScene["MC_Slot_" + _loc3_]["SelectBox"].visible = false;
               _loc3_++;
            }
            FScene["MC_Slot_" + (PYRAMIDNUM - 1)]["SelectBox"].visible = true;
         }
         else
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param1.Tag);
         }
      }
      
      protected function OnShopGet(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.Gift[param1.Tag].index);
      }
      
      protected function OnFightReport(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToLinkUrl(this.FConfig.FightReportAddr);
      }
      
      protected function UIDispatch_RankArea() : void
      {
         this.FScrollBar = new TScrollBar(FScene["MC_ScroolBarUI"],206,false);
      }
      
      protected function LogArrive(param1:Vector.<TLog>) : void
      {
         this.RenderRankArea(param1);
      }
      
      protected function RenderRankArea(param1:Vector.<TLog>) : void
      {
         var _loc2_:* = 0;
         var _loc3_:int = 0;
         var _loc4_:TRewards = null;
         var _loc5_:Sprite = null;
         var _loc6_:TLog = null;
         var _loc7_:Object = null;
         var _loc8_:Vector.<Sprite> = null;
         var _loc9_:String = null;
         this.FScrollBar.Clear();
         _loc3_ = int(param1.length);
         _loc8_ = new Vector.<Sprite>();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = param1[_loc2_];
            _loc7_ = Json.decode(_loc6_.Data);
            _loc5_ = TUtilityReflection.CreateDisplayObjectInstance("MC_Text") as Sprite;
            _loc5_["TF"].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_68),_loc6_.Name,SToolReward.GetNameByTypeCode(_loc7_.type,_loc7_.code),_loc7_.amount);
            _loc8_.push(_loc5_);
            _loc2_++;
         }
         _loc2_ = int(_loc3_ - 1);
         while(_loc2_ >= 0)
         {
            this.FScrollBar.AddItem(_loc8_[_loc2_]);
            _loc2_--;
         }
      }
      
      protected function OnGalleryChange(param1:uint, param2:uint) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc4_ = PYRAMIDNUM;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            FScene["MC_Slot_" + _loc3_]["SelectBox"].visible = false;
            _loc3_++;
         }
         FScene["MC_Slot_" + (PYRAMINDEX[this.FPlayLine] + param2)]["SelectBox"].visible = true;
      }
      
      protected function RandomTurnsFinishCall() : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.SmashOne);
      }
      
      protected function OnGalleryStop(param1:uint) : void
      {
         FScene.mouseChildren = true;
         FScene.mouseEnabled = true;
      }
      
      protected function newMethod() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(PYRAMIDBASE - this.FDataVO.PreLine - this.FDataVO.Position <= 0)
         {
            return;
         }
         this.FWheelEffect.Stop(this.FDataVO.Position);
         _loc2_ = PYRAMIDNUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            FScene["MC_Slot_" + _loc1_]["SelectBox"].visible = false;
            _loc1_++;
         }
         if(this.FDataVO.Position != 99 && this.FDataVO.PreLine != 99)
         {
            FScene["MC_Slot_" + (PYRAMINDEX[this.FDataVO.PreLine] + this.FDataVO.Position)]["SelectBox"].visible = true;
            (FScene["MC_Slot_" + (PYRAMINDEX[this.FDataVO.PreLine] + this.FDataVO.Position)]["MC_Done"] as MovieClip).gotoAndPlay(1);
         }
         this.FDataVO.PreLine = 99;
         this.FDataVO.Position = 99;
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.LogicsPerform();
         if(FScene == null)
         {
            return;
         }
         if(this.FMC_ShopSlots != null || this.FMC_Shop != null || this.FMC_Shop.visible != false)
         {
            _loc2_ = SHOPNUM;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FMC_ShopSlots[_loc1_].Update();
               _loc1_++;
            }
         }
         if(this.FMC_MainSlots != null || FScene.visible != false)
         {
            _loc2_ = PYRAMIDNUM;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FMC_MainSlots[_loc1_].Update();
               _loc1_++;
            }
         }
         if(this.FWheelEffect != null)
         {
            this.FWheelEffect.Loop();
         }
      }
      
      protected function SetData(param1:int, param2:TUISlot) : void
      {
         var _loc3_:TAward = null;
         var _loc4_:TInventories = null;
         var _loc5_:TInventory = null;
         _loc4_ = new TInventories();
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Award,param1) as TAward;
         SToolReward.GetInventoryByID(_loc3_.FixedAwards[0].Code,_loc4_);
         _loc5_ = _loc4_.GetInventoryByIndex(0);
         _loc5_.Quantity = _loc3_.FixedAwards[0].Amount;
         param2.Context = _loc5_;
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Sprite = null;
         var _loc5_:TUISlot = null;
         var _loc6_:TUIButton = null;
         super.InitWindow(param1);
         this.FMC_Shop = FScene["MC_Shop"];
         this.FBtn_CloseShop = new TUIButton();
         this.FBtn_CloseShop.Substrate = this.FMC_Shop["btn_close"];
         this.FBtn_CloseShop.OnClick = this.OnCloseShop;
         this.FTF_ShopScore = this.FMC_Shop["TF_Score"];
         _loc3_ = SHOPNUM;
         this.FMC_ShopSlots = new Vector.<TUISlot>(_loc3_);
         this.FMC_ShopSlotTips = new Vector.<Sprite>(_loc3_);
         this.FMC_ShopSlotBtns = new Vector.<TUIButton>(_loc3_);
         this.FMC_ShopSlotCosts = new Vector.<TextField>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = new Sprite();
            _loc4_ = this.FMC_Shop["MC_Slot_" + _loc2_];
            this.FMC_ShopSlotTips[_loc2_] = _loc4_["MC_Tip"];
            _loc6_ = new TUIButton();
            _loc6_.Substrate = _loc4_["Btn_OK"];
            _loc6_.OnClick = this.OnShopGet;
            _loc6_.Tag = _loc2_;
            this.FMC_ShopSlotBtns[_loc2_] = _loc6_;
            this.FMC_ShopSlotCosts[_loc2_] = _loc4_["TF_Value"];
            _loc5_ = new TUISlot(this);
            _loc5_.Resource = this.FMC_Shop["MC_Slot_" + _loc2_]["MC_Slot"];
            _loc5_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc5_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc5_);
            _loc5_.Init();
            this.FMC_ShopSlots[_loc2_] = _loc5_;
            _loc2_++;
         }
         this.FTF_Gold = FScene["TF_Gold"];
         this.FTF_Num = FScene["TF_Num"];
         _loc3_ = PYRAMIDNUM;
         this.FMC_MainSlots = new Vector.<TUISlot>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TUISlot(this);
            _loc5_.Resource = FScene["MC_Slot_" + _loc2_]["MC_Slot"];
            _loc5_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc5_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc5_);
            _loc5_.Init();
            this.FMC_MainSlots[_loc2_] = _loc5_;
            FScene["MC_Slot_" + _loc2_]["SelectBox"].visible = false;
            FScene["MC_Slot_" + _loc2_]["SelectBox"].mouseEnabled = false;
            FScene["MC_Slot_" + _loc2_]["SelectBox"].mouseChildren = false;
            (FScene["MC_Slot_" + _loc2_]["MC_Ing"] as MovieClip).gotoAndPlay(1);
            (FScene["MC_Slot_" + _loc2_]["MC_Ing"] as MovieClip).mouseChildren = false;
            (FScene["MC_Slot_" + _loc2_]["MC_Ing"] as MovieClip).mouseEnabled = false;
            (FScene["MC_Slot_" + _loc2_]["MC_Done"] as MovieClip).mouseChildren = false;
            (FScene["MC_Slot_" + _loc2_]["MC_Done"] as MovieClip).mouseEnabled = false;
            _loc2_++;
         }
         this.FMC_Mall = FScene["MC_Mall"];
         this.FBtn_Shop = new TUIButton();
         this.FBtn_Shop.Substrate = this.FMC_Mall["Btn_Shop"];
         this.FBtn_Shop.OnClick = this.AwardOnClick;
         this.FBtn_Shop.OnMove = this.AwardOnMove;
         this.FBtn_Shop.OnOut = this.AwardOnOut;
         this.FTF_Score = this.FMC_Mall["TF_Score"];
         this.FBtn_OK = new TUIButton();
         this.FBtn_OK.Substrate = this.FMC_Mall["Btn_OK"];
         this.FBtn_OK.OnClick = this.OnSmartGet;
         this.FBtn_OK_1 = new TUIButton();
         this.FBtn_OK_1.Substrate = FScene["Btn_OK_1"];
         this.FBtn_OK_1.OnClick = this.OnExtract;
         this.FBtn_OK_10 = new TUIButton();
         this.FBtn_OK_10.Substrate = FScene["Btn_OK_10"];
         this.FBtn_OK_10.OnClick = this.OnExtract;
         this.FBtn_OK_50 = new TUIButton();
         this.FBtn_OK_50.Substrate = FScene["Btn_OK_50"];
         this.FBtn_OK_50.OnClick = this.OnExtract;
         this.FMC_Selected = FScene["MC_Selected"]["MC_SelectBox"];
         this.FMC_Selected.addEventListener(MouseEvent.CLICK,this.OnSelect);
         this.FSelectedIndex = 0;
         this.UIDispatch_RankArea();
         this.FWheelEffect = new TWheelEffect();
         this.FWheelEffect.ChangeCall = this.OnGalleryChange;
         this.FWheelEffect.StopToTargetCall = this.OnGalleryStop;
         this.FWheelEffect.RandomTurnsFinishCall = this.RandomTurnsFinishCall;
         this.FBtn_Report = new TUIButton();
         this.FBtn_Report.Substrate = FScene["Btn_FightReport"];
         this.FBtn_Report.OnClick = this.OnFightReport;
         this.FMC_Shop.visible = false;
      }
      
      public function set OnLoadLog(param1:Function) : void
      {
         this.FOnLoadLog = param1;
      }
   }
}

