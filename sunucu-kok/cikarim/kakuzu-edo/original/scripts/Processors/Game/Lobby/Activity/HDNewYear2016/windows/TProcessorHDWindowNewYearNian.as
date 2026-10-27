package Processors.Game.Lobby.Activity.HDNewYear2016.windows
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.THDNewYear2016Nian;
   import Logics.DatebaseVO.VO.TPetLevelUp;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNewYear2016.TNewYear2016Nian;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.HyperLink.SUtilityHyperLink;
   import Processors.Game.Utilities.HyperLink.TUtilityHyperLink;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorHDWindowNewYearNian extends TProcessorHDSingleWindowBase
   {
      
      protected var FOnceFund:Sprite;
      
      protected var FOnceBags:Vector.<Sprite>;
      
      protected var FTF_OnceBagCosts:Vector.<TextField>;
      
      protected var FTF_OnceBagText:Vector.<TextField>;
      
      protected var FBtn_OnceBags:Vector.<TUIButton>;
      
      protected var FSP_OnceBags:Vector.<Sprite>;
      
      protected var FDailyFund:Sprite;
      
      protected var FTF_DailyRecharge:TextField;
      
      protected var FTF_DailyCosts:Vector.<TextField>;
      
      protected var FDailyBags:Vector.<Sprite>;
      
      protected var FBtn_DailyBags:Vector.<TUIButton>;
      
      protected var FBtn_DailyBagAlready:Vector.<Sprite>;
      
      protected var FArrow:Sprite;
      
      protected var FTF_TotalRecharge:TextField;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FBtn_Arrow:TUIButton;
      
      protected var FBtn_Arrows:TUIButton;
      
      protected var FTF_Last:TextField;
      
      protected var FSP_Pet:Sprite;
      
      protected var FPointPetMC:Sprite;
      
      protected var FPetBmp:Bitmap;
      
      protected var FPetLevelUp:TPetLevelUp;
      
      protected var FBtn_GetPet:TUIButton;
      
      protected var FTF_Num:TextField;
      
      protected var FData:TNewYear2016Nian;
      
      protected var FConfig:THDNewYear2016Nian;
      
      public function TProcessorHDWindowNewYearNian(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.UpdateUIConfig();
         this.FConfig = FHDActivityConfig as THDNewYear2016Nian;
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
         _loc2_ = this.FConfig.DailyFund.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTF_DailyCosts[_loc1_].text = this.FConfig.DailyFund[_loc1_].gold + "";
            _loc1_++;
         }
         _loc2_ = this.FConfig.OnceFund.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTF_OnceBagCosts[_loc1_].text = this.FConfig.OnceFund[_loc1_].gold + "";
            this.FTF_OnceBagText[_loc1_].text = this.FConfig.OnceFund[_loc1_].text + "";
            _loc1_++;
         }
         this.FTF_Num.text = this.FConfig.ActivityFund.gold + "";
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         this.FData = param1 as TNewYear2016Nian;
         this.FTF_Last.text = this.FData.ArrowNum + "";
         this.FTF_TotalRecharge.text = this.FData.AllRecharge + "";
         _loc3_ = this.FConfig.ArrowAwards.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FSlots[_loc2_].Context = this.FData.NianBags.GetInventoryByIndex(_loc2_);
            _loc2_++;
         }
         this.FBtn_Arrow.Enabled = this.FData.ArrowNum > 0 ? true : false;
         this.FBtn_Arrows.Enabled = this.FData.ArrowNum >= 10 ? true : false;
         this.FTF_DailyRecharge.text = this.FData.DailyRecharge + "";
         _loc3_ = this.FData.Config.DailyFund.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FBtn_DailyBags[_loc2_].Enabled = this.FData.DailyBagsStatus[_loc2_] == 1 ? true : false;
            this.FBtn_DailyBagAlready[_loc2_].visible = this.FData.DailyBagsStatus[_loc2_] == -1 ? true : false;
            _loc2_++;
         }
         _loc3_ = this.FData.Config.OnceFund.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FBtn_OnceBags[_loc2_].Enabled = this.FData.OnceBagsStatus[_loc2_] == 1 ? true : false;
            _loc2_++;
         }
         this.FPetLevelUp = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_PetLevelUp,this.FConfig.ActivityFund.showId) as TPetLevelUp;
         if(this.FPetLevelUp != null)
         {
            SResourcesCore.TexturesLargeIcon.LoadAutoSecondary(this.FPetLevelUp.PetResourceID,this.AutoLoadCallBack);
         }
         this.FBtn_GetPet.Enabled = this.FData.PetStatus == 1 ? true : false;
         FScene["MC_Get"].visible = this.FData.PetStatus == -1 ? true : false;
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         _loc1_ = this.FConfig.ArrowAwards.length;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this.FSlots[_loc2_].Update();
            _loc2_++;
         }
      }
      
      protected function DailyBagsOnMove(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxMove(this,this.FData.DaysBags[param1.Tag],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function OnceBagsOnMove(param1:MouseEvent) : void
      {
         ProcessorOnGiftBoxMove(this,this.FData.OnceBags[uint(param1.currentTarget.parent.name.split("_")[2])],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function DailyBagsOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function OnceBagsOnOut(param1:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function PetOnClick(param1:Object, param2:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.ActivityFund.index);
      }
      
      protected function LinkPetOnClick(param1:MouseEvent) : void
      {
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Pet);
      }
      
      protected function ArrowOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:Vector.<int> = null;
         _loc3_ = new Vector.<int>();
         _loc3_[0] = 1;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.ArrowIndex,0,_loc3_);
      }
      
      protected function ArrowsOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:Vector.<int> = null;
         _loc3_ = new Vector.<int>();
         _loc3_[0] = 10;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.ArrowIndex,0,_loc3_);
      }
      
      protected function OnceBagsOnClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.OnceFund[param1.Tag].index);
      }
      
      protected function DailyBagsOnClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.DailyFund[param1.Tag].index);
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         switch(param3)
         {
            case this.FPetLevelUp.PetResourceID:
               _loc4_ = param2.GetAnimationSequenceByIndex(0);
               this.FPetBmp.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
         }
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.InitWindow(param1);
         this.FOnceFund = FScene["SP_OnceFund"];
         this.FArrow = FScene["SP_Arrow"];
         this.FDailyFund = FScene["SP_DailyFund"];
         this.FSP_Pet = FScene["SP_Pet"];
         this.FTF_TotalRecharge = new TextField();
         this.FTF_TotalRecharge = this.FArrow["TF_Candy"];
         this.FTF_Last = new TextField();
         this.FTF_Last = this.FArrow["TF_Last"];
         this.FBtn_Arrow = new TUIButton();
         this.FBtn_Arrow.Substrate = this.FArrow["Btn_Arrow"];
         this.FBtn_Arrow.OnClick = this.ArrowOnClick;
         this.FBtn_Arrows = new TUIButton();
         this.FBtn_Arrows.Substrate = this.FArrow["Btn_Arrows"];
         this.FBtn_Arrows.OnClick = this.ArrowsOnClick;
         _loc2_ = 9;
         this.FSlots = new Vector.<TUISlot>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FSlots[_loc3_] = new TUISlot(this);
            this.FSlots[_loc3_].Resource = this.FArrow["MC_RareItems"]["Item" + _loc3_];
            this.FSlots[_loc3_].OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FSlots[_loc3_].OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(this.FSlots[_loc3_]);
            this.FSlots[_loc3_].Init();
            _loc3_++;
         }
         this.FArrow["MC_Effect"].play();
         this.FTF_DailyRecharge = new TextField();
         this.FTF_DailyRecharge = this.FDailyFund["TF_Candy"];
         _loc2_ = 4;
         this.FDailyBags = new Vector.<Sprite>(_loc2_);
         this.FBtn_DailyBags = new Vector.<TUIButton>(_loc2_);
         this.FBtn_DailyBagAlready = new Vector.<Sprite>(_loc2_);
         this.FTF_DailyCosts = new Vector.<TextField>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FDailyBags[_loc3_] = this.FDailyFund["Gift_" + _loc3_];
            this.FBtn_DailyBags[_loc3_] = new TUIButton();
            this.FBtn_DailyBags[_loc3_].OnClick = this.DailyBagsOnClick;
            this.FBtn_DailyBags[_loc3_].Substrate = this.FDailyBags[_loc3_]["MC_Gift"];
            this.FBtn_DailyBags[_loc3_].OnMove = this.DailyBagsOnMove;
            this.FBtn_DailyBags[_loc3_].OnOut = this.DailyBagsOnOut;
            this.FBtn_DailyBags[_loc3_].Tag = _loc3_;
            this.FTF_DailyCosts[_loc3_] = new TextField();
            this.FTF_DailyCosts[_loc3_] = this.FDailyBags[_loc3_]["TF_NeedValue"];
            this.FBtn_DailyBagAlready[_loc3_] = this.FDailyBags[_loc3_]["SP_AlreadyGet"];
            _loc3_++;
         }
         _loc2_ = 4;
         this.FSP_OnceBags = new Vector.<Sprite>(_loc2_);
         this.FBtn_OnceBags = new Vector.<TUIButton>(_loc2_);
         this.FOnceBags = new Vector.<Sprite>(_loc2_);
         this.FTF_OnceBagCosts = new Vector.<TextField>(_loc2_);
         this.FTF_OnceBagText = new Vector.<TextField>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FSP_OnceBags[_loc3_] = this.FOnceFund["MC_RandomItem_" + _loc3_];
            this.FOnceBags[_loc3_] = this.FSP_OnceBags[_loc3_]["Slot"];
            this.FOnceBags[_loc3_].addEventListener(MouseEvent.MOUSE_MOVE,this.OnceBagsOnMove);
            this.FOnceBags[_loc3_].addEventListener(MouseEvent.MOUSE_OUT,this.OnceBagsOnOut);
            this.FTF_OnceBagCosts[_loc3_] = new TextField();
            this.FTF_OnceBagCosts[_loc3_] = this.FSP_OnceBags[_loc3_]["TF_Cost"];
            this.FTF_OnceBagText[_loc3_] = new TextField();
            this.FTF_OnceBagText[_loc3_] = this.FSP_OnceBags[_loc3_]["TF_Rnd"];
            this.FBtn_OnceBags[_loc3_] = new TUIButton();
            this.FBtn_OnceBags[_loc3_].OnClick = this.OnceBagsOnClick;
            this.FBtn_OnceBags[_loc3_].Tag = _loc3_;
            this.FBtn_OnceBags[_loc3_].Substrate = this.FSP_OnceBags[_loc3_]["Btn_Get"];
            _loc3_++;
         }
         this.FTF_Num = new TextField();
         this.FTF_Num = this.FSP_Pet["TF_Cost"];
         this.FBtn_GetPet = new TUIButton();
         this.FBtn_GetPet.Substrate = FScene["Btn_Receive"];
         this.FBtn_GetPet.OnClick = this.PetOnClick;
         this.FPointPetMC = this.FSP_Pet;
         this.FPointPetMC.buttonMode = true;
         this.FPointPetMC.addEventListener(MouseEvent.CLICK,this.LinkPetOnClick);
         this.FPetBmp = new Bitmap();
         this.FPetBmp.x = -60;
         this.FPetBmp.y = 30;
         this.FPointPetMC.addChild(this.FPetBmp);
      }
   }
}

