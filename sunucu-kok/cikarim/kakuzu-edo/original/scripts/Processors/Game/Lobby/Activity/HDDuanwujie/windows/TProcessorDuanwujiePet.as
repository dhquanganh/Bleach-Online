package Processors.Game.Lobby.Activity.HDDuanwujie.windows
{
   import Components.Standard.TUIButton;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.THDDuanwujiePet;
   import Logics.DatebaseVO.VO.TPetLevelUp;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDDuanwujie.TDuanwujiePet;
   import Processors.Game.Lobby.Activity.HDActivity.Common.THDScoreExchangeShop;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.HyperLink.SUtilityHyperLink;
   import Processors.Game.Utilities.HyperLink.TUtilityHyperLink;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorDuanwujiePet extends TProcessorHDSingleWindowBase
   {
      
      protected var FBtn_Funds:Vector.<TUIButton>;
      
      protected var FBtn_FundGift:TUIButton;
      
      protected var FBtn_ZongziBoxes:Vector.<TUIButton>;
      
      protected var FBtn_GetPet:TUIButton;
      
      protected var FSP_Pet:Sprite;
      
      protected var FPointPetMC:Sprite;
      
      protected var FPetBmp:Bitmap;
      
      protected var FPetLevelUp:TPetLevelUp;
      
      protected var FBtn_Shop:TUIButton;
      
      protected var FScoreExchangeShop:THDScoreExchangeShop;
      
      protected var FIsinit:Boolean;
      
      protected var FData:TDuanwujiePet;
      
      public function TProcessorDuanwujiePet(param1:TUIComponent)
      {
         super(param1);
         this.FPetBmp = new Bitmap();
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:THDDuanwujiePet = null;
         super.UpdateUIConfig();
         _loc3_ = FHDActivityConfig as THDDuanwujiePet;
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
         _loc2_ = 4;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            FScene["MC_FundBox_" + _loc1_]["TF_text"].text = _loc3_.Fund[_loc1_].gold + "";
            _loc1_++;
         }
         _loc2_ = 8;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            FScene["MC_Sever_" + _loc1_]["TF_text"].text = _loc3_.ZongZiGift.zongZi[_loc1_] + "";
            _loc1_++;
         }
         FScene["DayBox"]["TF_text"].text = _loc3_.FundGift.days + "";
         FScene["TF_Cost"].text = _loc3_.Pet.zongZi + "";
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         this.FData = param1 as TDuanwujiePet;
         FScene["TF_Had"].text = this.FData.ZongziNum + "";
         FScene["TF_SeverHad"].text = this.FData.ServerZongziNum + "";
         this.FScoreExchangeShop.Update(this.FData.ZongziNum,this.FData.MailStatus);
         if(!this.FIsinit)
         {
            this.SetupScoreShop();
            this.FIsinit = true;
         }
         _loc3_ = 4;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FBtn_Funds[_loc2_].Enabled = this.FData.FundStatus[_loc2_] == 1 ? true : false;
            _loc2_++;
         }
         this.FBtn_FundGift.Enabled = this.FData.FundGIftStatus == 1 ? true : false;
         FScene["DayBox"]["MC_Already"].visible = this.FData.FundGIftStatus == -1 ? true : false;
         _loc3_ = 8;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FBtn_ZongziBoxes[_loc2_].Enabled = this.FData.ServerZongziNum >= this.FData.Config.ZongZiGift.zongZi[_loc2_] ? true : false;
            this.FBtn_ZongziBoxes[_loc2_].Enabled = this.FData.ZongziStatus[_loc2_] == 1 ? false : this.FBtn_ZongziBoxes[_loc2_].Enabled;
            FScene["MC_Sever_" + _loc2_]["MC_Already"].visible = this.FData.ZongziStatus[_loc2_] == 1 ? true : false;
            _loc2_++;
         }
         this.FPetLevelUp = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_PetLevelUp,this.FData.Config.Pet.showId) as TPetLevelUp;
         if(this.FPetLevelUp != null)
         {
            SResourcesCore.TexturesLargeIcon.LoadAutoSecondary(this.FPetLevelUp.PetResourceID,this.AutoLoadCallBack);
         }
         FScene["MC_Already"].visible = this.FData.PetStatus != -1 ? false : true;
         this.FBtn_GetPet.Enabled = this.FData.PetStatus == 1 ? true : false;
      }
      
      protected function ShowShopOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FScoreExchangeShop.Visible = true;
         this.FScoreExchangeShop.Update(this.FData.ZongziNum,this.FData.MailStatus);
      }
      
      protected function SetupScoreShop() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Vector.<uint> = null;
         var _loc3_:Vector.<Boolean> = null;
         _loc2_ = new Vector.<uint>();
         _loc3_ = new Vector.<Boolean>();
         for each(_loc1_ in this.FData.Config.Mall)
         {
            _loc2_.push(_loc1_.score);
            _loc3_.push(_loc1_.count == 0);
         }
         this.FScoreExchangeShop.SetupBasicInfo(this.FData.MailInvs,_loc2_,_loc3_);
      }
      
      protected function ProcessorFundOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint((param1 as TUIButton).Tag);
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.Fund[_loc3_].index);
      }
      
      protected function ProcessorZongziOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:Vector.<int> = null;
         _loc4_ = new Vector.<int>(1);
         _loc3_ = uint((param1 as TUIButton).Tag);
         _loc4_[0] = _loc3_;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.ZongZiGift.index,0,_loc4_);
      }
      
      protected function ProcessorFundGiftOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.FundGift.index);
      }
      
      protected function ProcessorGetPet(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.Pet.index);
      }
      
      protected function ProcessorFundOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function ProcessorFundOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint((param1 as TUIButton).Tag);
         ProcessorOnGiftBoxMove(this,this.FData.FundBoxes[_loc3_],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function ProcessorFundGiftOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint((param1 as TUIButton).Tag);
         ProcessorOnGiftBoxMove(this,this.FData.FundGiftBox,TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function ProcessorZongziOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint((param1 as TUIButton).Tag);
         ProcessorOnGiftBoxMove(this,this.FData.ZongziBoxes[_loc3_],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function ExchangeCall(param1:uint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         _loc3_ = this.FData.Config.Mall[param1];
         _loc2_ = uint(_loc3_.score);
         if(this.FData.ZongziNum >= _loc2_)
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc3_.index);
         }
         else
         {
            SToolReward.ShowMessage(this.FData.Config.Text);
         }
      }
      
      protected function LinkPetOnClick(param1:MouseEvent) : void
      {
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Pet);
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
         _loc2_ = 4;
         this.FBtn_Funds = new Vector.<TUIButton>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FBtn_Funds[_loc3_] = new TUIButton();
            this.FBtn_Funds[_loc3_].Tag = _loc3_;
            this.FBtn_Funds[_loc3_].Substrate = FScene["MC_FundBox_" + _loc3_]["MC_Bag"];
            this.FBtn_Funds[_loc3_].OnClick = this.ProcessorFundOnClick;
            this.FBtn_Funds[_loc3_].OnMove = this.ProcessorFundOnMove;
            this.FBtn_Funds[_loc3_].OnOut = this.ProcessorFundOnOut;
            _loc3_++;
         }
         this.FBtn_FundGift = new TUIButton();
         this.FBtn_FundGift.Substrate = FScene["DayBox"]["MC_Bag"];
         this.FBtn_FundGift.OnClick = this.ProcessorFundGiftOnClick;
         this.FBtn_FundGift.OnMove = this.ProcessorFundGiftOnMove;
         this.FBtn_FundGift.OnOut = this.ProcessorFundOnOut;
         _loc2_ = 8;
         this.FBtn_ZongziBoxes = new Vector.<TUIButton>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FBtn_ZongziBoxes[_loc3_] = new TUIButton();
            this.FBtn_ZongziBoxes[_loc3_].Tag = _loc3_;
            this.FBtn_ZongziBoxes[_loc3_].Substrate = FScene["MC_Sever_" + _loc3_]["MC_Bag"];
            this.FBtn_ZongziBoxes[_loc3_].OnClick = this.ProcessorZongziOnClick;
            this.FBtn_ZongziBoxes[_loc3_].OnMove = this.ProcessorZongziOnMove;
            this.FBtn_ZongziBoxes[_loc3_].OnOut = this.ProcessorFundOnOut;
            _loc3_++;
         }
         this.FBtn_GetPet = new TUIButton();
         this.FBtn_GetPet.Substrate = FScene["Btn_GetPet"];
         this.FBtn_GetPet.OnClick = this.ProcessorGetPet;
         this.FBtn_Shop = new TUIButton();
         this.FBtn_Shop.Substrate = FScene["Btn_Shop"];
         this.FBtn_Shop.OnClick = this.ShowShopOnClick;
         this.FScoreExchangeShop = new THDScoreExchangeShop(this);
         this.FScoreExchangeShop.ExchangeCall = this.ExchangeCall;
         this.FScoreExchangeShop.UIDispatch(TUtilityReflection.CreateDisplayObjectInstance("MC_DuanwujiePetShop") as MovieClip);
         this.FSP_Pet = FScene["MC_MountPoint"];
         this.FPointPetMC = this.FSP_Pet;
         this.FPointPetMC.buttonMode = true;
         this.FPointPetMC.addEventListener(MouseEvent.CLICK,this.LinkPetOnClick);
         this.FPetBmp = new Bitmap();
         this.FPetBmp.x = -50;
         this.FPetBmp.y = -45;
         this.FPointPetMC.addChild(this.FPetBmp);
      }
   }
}

