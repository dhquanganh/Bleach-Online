package Processors.Game.Lobby.Activity.HDLaborDay2016.Windows
{
   import Components.Standard.TUIButton;
   import Foundation.Common.THint;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.THDLaborDayPet;
   import Logics.DatebaseVO.VO.TPetLevelUp;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDLaborDay2016.TLaborDayPet;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.HyperLink.SUtilityHyperLink;
   import Processors.Game.Utilities.HyperLink.TUtilityHyperLink;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorLaborPet extends TProcessorHDSingleWindowBase
   {
      
      public static const BAREACHLEN:uint = 66;
      
      protected var FMC_Bags:Vector.<TUIButton>;
      
      protected var FBtn_Bars:Vector.<TUIButton>;
      
      protected var FSP_Pet:Sprite;
      
      protected var FBtn_GetPet:TUIButton;
      
      protected var FPointPetMC:Sprite;
      
      protected var FPetBmp:Bitmap = new Bitmap();
      
      protected var FPetLevelUp:TPetLevelUp;
      
      protected var FLastPeriod:uint;
      
      protected var FData:TLaborDayPet;
      
      protected var FConfig:THDLaborDayPet;
      
      public function TProcessorLaborPet(param1:TUIComponent)
      {
         FHint = new THint();
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:THDLaborDayPet = null;
         super.UpdateUIConfig();
         _loc3_ = FHDActivityConfig as THDLaborDayPet;
         this.FConfig = _loc3_;
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
         FScene["TF_text0"].text = this.FConfig.RechargePer + "";
         FScene["TF_text1"].text = "1";
         FScene["TF_text2"].text = this.FConfig.ConsumePer + "";
         FScene["TF_text3"].text = "1";
         FScene["TF_PetCost"].text = this.FConfig.Pet.gold + "";
         _loc2_ = 4;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            FScene["MC_Bag_" + _loc1_]["TF_Text_0"].text = this.FConfig.Fund[_loc1_].gold + "";
            _loc1_++;
         }
         _loc2_ = 6;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            FScene["TF_" + _loc1_].text = this.FConfig.Gift.score[_loc1_] + "";
            _loc1_++;
         }
         _loc2_ = 6;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            FScene["TF_" + (_loc1_ + 6)].text = this.FConfig.Gift.awardId[_loc1_] + "%";
            _loc1_++;
         }
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this.FData = param1 as TLaborDayPet;
         FScene["TF_Recharged"].text = this.FData.Recharged.toString();
         FScene["TF_Consumed"].text = this.FData.Consumed.toString();
         FScene["TF_Score"].text = this.FData.Score.toString();
         _loc3_ = 4;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FMC_Bags[_loc2_].Enabled = this.FData.BagStatus[_loc2_] == 1 ? true : false;
            _loc2_++;
         }
         _loc3_ = 6;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            FScene["MC_Bar_" + _loc2_]["MC_Receive"].visible = this.FData.BarStatus[_loc2_] == 1 ? true : false;
            this.FBtn_Bars[_loc2_].Enabled = this.FData.Score >= this.FConfig.Gift.score[_loc2_] ? true : false;
            if(this.FData.Score >= this.FConfig.Gift.score[_loc2_] && this.FData.BarStatus[_loc2_] == 0)
            {
               FScene["MC_Bar_" + _loc2_]["Bar"].visible = true;
               FScene["MC_Bar_" + _loc2_]["Bar"].play();
            }
            else
            {
               FScene["MC_Bar_" + _loc2_]["Bar"].visible = false;
            }
            _loc2_++;
         }
         this.UpdateTheFuckingBar();
         this.UpdateImage();
         this.FPetLevelUp = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_PetLevelUp,this.FData.Config.Pet.showId) as TPetLevelUp;
         if(this.FPetLevelUp != null)
         {
            SResourcesCore.TexturesLargeIcon.LoadAutoSecondary(this.FPetLevelUp.PetResourceID,this.AutoLoadCallBack);
         }
         FScene["MC_UltimateReward"]["MC_Receive"].visible = this.FData.PetStatus != -1 ? false : true;
         this.FBtn_GetPet.Enabled = this.FData.PetStatus == 1 ? true : false;
      }
      
      protected function PetOnClick(param1:Object, param2:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.Pet.index);
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
      
      protected function ProcessorBagsOnClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.Fund[param1.Tag].index);
      }
      
      protected function ProcessorGiftOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint((param1 as TUIButton).Tag);
         ProcessorOnGiftBoxMove(this,this.FData.Funds[_loc3_],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function ProcessorGiftOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function ProcessorBarsOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:Vector.<int> = null;
         _loc3_ = new Vector.<int>(1);
         _loc3_[0] = param1.Tag;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.Gift.index,0,_loc3_);
      }
      
      protected function ProcessorBarOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = (param1 as TUIButton).Tag;
         FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Vouchers) + this.FConfig.Gift.score[_loc3_] * this.FConfig.Gift.awardId[_loc3_] / 100 + "";
         SUtilityOverLayer.UIComponentsHintOnOver(this,FHint);
      }
      
      protected function ProcessorBarOnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,FHint);
      }
      
      protected function UpdateTheFuckingBar() : void
      {
         FScene["MC_Bar"]["MC_Mask"].width = this.FData.CurPeriod * BAREACHLEN * (this.FData.Score / this.FConfig.Gift.score[this.FData.CurPeriod - 1]);
      }
      
      protected function UpdateImage() : void
      {
         if(this.FData.CurPeriod > this.FLastPeriod)
         {
            FScene["MC_Image"].gotoAndPlay("step" + this.FData.CurPeriod);
         }
         this.FLastPeriod = this.FData.CurPeriod;
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.InitWindow(param1);
         this.FMC_Bags = new Vector.<TUIButton>(4);
         _loc2_ = 4;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FMC_Bags[_loc3_] = new TUIButton();
            this.FMC_Bags[_loc3_].Substrate = FScene["MC_Bag_" + _loc3_]["Btn"];
            this.FMC_Bags[_loc3_].OnClick = this.ProcessorBagsOnClick;
            this.FMC_Bags[_loc3_].Tag = _loc3_;
            this.FMC_Bags[_loc3_].OnMove = this.ProcessorGiftOnMove;
            this.FMC_Bags[_loc3_].OnOut = this.ProcessorGiftOnOut;
            _loc3_++;
         }
         this.FBtn_Bars = new Vector.<TUIButton>(6);
         _loc2_ = 6;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FBtn_Bars[_loc3_] = new TUIButton();
            this.FBtn_Bars[_loc3_].Substrate = FScene["MC_Bar_" + _loc3_]["Bar"];
            this.FBtn_Bars[_loc3_].OnClick = this.ProcessorBarsOnClick;
            this.FBtn_Bars[_loc3_].Tag = _loc3_;
            this.FBtn_Bars[_loc3_].OnMove = this.ProcessorBarOnMove;
            this.FBtn_Bars[_loc3_].OnOut = this.ProcessorBarOnOut;
            _loc3_++;
         }
         this.FSP_Pet = FScene["MC_UltimateReward"]["MC_MountPoint"];
         this.FBtn_GetPet = new TUIButton();
         this.FBtn_GetPet.Substrate = FScene["MC_UltimateReward"]["Btn_Receive"];
         this.FBtn_GetPet.OnClick = this.PetOnClick;
         this.FPointPetMC = this.FSP_Pet;
         this.FPointPetMC.buttonMode = true;
         this.FPointPetMC.addEventListener(MouseEvent.CLICK,this.LinkPetOnClick);
         this.FPetBmp = new Bitmap();
         this.FPetBmp.x = -40;
         this.FPetBmp.y = -35;
         this.FPointPetMC.addChild(this.FPetBmp);
         FScene["MC_Effect1"].play();
         FScene["MC_Effect2"].play();
         _loc2_ = 6;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            FScene["MC_Bar_" + _loc3_]["Bar"].play();
            _loc3_++;
         }
      }
   }
}

