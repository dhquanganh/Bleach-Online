package Processors.Game.Lobby.Activity.HDIceDragon
{
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HDActivityChineseYear.ActivityLukia.*;
   import Logics.HDActivityOS.*;
   import Logics.KnifeOfKillSoul.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Activity.HDActivityOS.Component.*;
   import Processors.Game.Lobby.Activity.HDChineseYear.Component.TKnifePop;
   import Processors.Game.Lobby.Activity.HDIceDragon.Component.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorHDWindowIceDragon extends TProcessorHDSingleWindowBase
   {
      
      protected static const COUNT_MC_BUYBOX:uint = 2;
      
      protected static const COUNT_MC_EXCHANGEBOX:uint = 3;
      
      protected static const COUNT_TF_BUYBOX:uint = 3;
      
      protected static const COUNT_TF_EXCHANGEBOX:uint = 1;
      
      protected static const KNIFE_WIDTH:uint = 254;
      
      protected static const KNIFE_HEIGHT:uint = 435;
      
      protected static const TYPE_BOX_NONE:int = -1;
      
      protected static const TYPE_BOX_BUY:int = 0;
      
      protected static const TYPE_BOX_EXCHANGE:int = 1;
      
      protected static const TYPE_BOX_KNIFE:int = 2;
      
      protected var FSP_Scene:Sprite;
      
      protected var FMC_BuyBoxes:Vector.<TUIHDIDBuyBox>;
      
      protected var FMC_ExchangeBoxes:Vector.<TUIActivityOSAwardList>;
      
      protected var FMC_Knife:TUIHDIDKnife;
      
      protected var FTF_CurChip:TextField;
      
      protected var FKnifePop:TKnifePop;
      
      protected var FDataIceDragon:TActivityLukiaTotalInfor;
      
      protected var FHDIceDragon:THDChineseYearLukia;
      
      protected var FIsInitWindow:Boolean;
      
      protected var FKnifeOfKillSoulData:TKnifeOfKillSoulData;
      
      protected var FBoxUniqueIndex:uint;
      
      protected var FBoxType:int;
      
      protected var FCurBuyBoxCostVect:Vector.<int>;
      
      protected var FRoleModelIDs:Vector.<uint>;
      
      public function TProcessorHDWindowIceDragon(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = CONST_ACTIVITY.RESOURCE_ClassName_ActivitySingleIceDragon;
         this.FIsInitWindow = false;
         this.FRoleModelIDs = new Vector.<uint>();
         this.FBoxType = TYPE_BOX_NONE;
         this.FCurBuyBoxCostVect = new Vector.<int>(COUNT_MC_BUYBOX);
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.LogicsPerform();
         if(!this.FIsInitWindow)
         {
            return;
         }
         this.FMC_Knife.UpdateHero();
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TUIHDIDBuyBox = null;
         var _loc5_:TUIActivityOSAwardList = null;
         var _loc6_:Sprite = null;
         super.InitWindow(param1);
         _loc3_ = int(COUNT_MC_BUYBOX);
         this.FMC_BuyBoxes = new Vector.<TUIHDIDBuyBox>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = new TUIHDIDBuyBox(this);
            _loc4_.OnBtnOkClick = this.ProcessorBuyBoxOnClick;
            _loc4_.OnBtnOkMove = this.ProcessorBuyBoxOnOver;
            _loc4_.OnBtnOkOut = this.ProcessorBuyBoxOnOut;
            _loc4_.Perform_UIDispatch(FScene[CONST_ACTIVITY.RESOURCE_Link_MC_BuyBoxes + _loc2_],COUNT_TF_BUYBOX,0,false);
            _loc4_.UpDateUI(_loc2_);
            this.FMC_BuyBoxes[_loc2_] = _loc4_;
            _loc2_++;
         }
         _loc3_ = int(COUNT_MC_EXCHANGEBOX);
         this.FMC_ExchangeBoxes = new Vector.<TUIActivityOSAwardList>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TUIActivityOSAwardList(this);
            _loc5_.OnBtnOkClick = this.ProcessorExchangeBoxOnClick;
            _loc5_.OnBtnOkMove = this.ProcessorExchangeBoxOnOver;
            _loc5_.OnBtnOkOut = this.ProcessorExchangeBoxOnOut;
            _loc5_.Perform_UIDispatch(FScene[CONST_ACTIVITY.RESOURCE_Link_MC_ExchangeBoxes + _loc2_],COUNT_TF_EXCHANGEBOX,0,false);
            _loc5_.UpDateUI(_loc2_);
            this.FMC_ExchangeBoxes[_loc2_] = _loc5_;
            _loc2_++;
         }
         this.FMC_Knife = new TUIHDIDKnife(this);
         this.FMC_Knife.OnQuerySequenceContext = this.HeroOnQuerySequenceContext;
         this.FMC_Knife.OnShowKnifeClick = this.ProcessorOnShowKnifeClick;
         this.FMC_Knife.SequenceDefaultRole = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCEID_Textures_DefaultRole,0);
         this.FMC_Knife.OnExchangeClick = this.ProcessorOnExchangeKnifeClick;
         this.FMC_Knife.Perform_UIDispatch(FScene[CONST_ACTIVITY.RESOURCE_Link_MC_KnifeHero]);
         this.FTF_CurChip = FScene[CONST_ACTIVITY.RESOURCE_Link_TF_CurOwned];
         this.FTF_CurChip.mouseEnabled = false;
         this.FTF_CurChip.text = "";
         this.FKnifePop = new TKnifePop(this);
         this.FKnifePop.OnPopColse = this.KnifePopOnClose;
         this.FKnifePop.UIDispatch();
         this.FKnifePop.X = (this.Width - KNIFE_WIDTH) / 2;
         this.FKnifePop.Y = (this.Height - KNIFE_HEIGHT) / 2;
         this.FKnifePop.Visible = false;
         this.FIsInitWindow = true;
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.UpdateUIConfig();
         this.FHDIceDragon = FHDActivityConfig as THDChineseYearLukia;
         this.FKnifeOfKillSoulData = FCharacter.KnifeOfKillSoulShow.GetByIndentifier(this.FHDIceDragon.ActivityLukia.LukiaID);
         _loc2_ = int(COUNT_MC_EXCHANGEBOX);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FHDIceDragon.ActivityExchangeBag.BagInventories = ProcessorGetInventoriesVectByAwardID(this.FHDIceDragon.ActivityExchangeBag.BagsID);
            _loc1_++;
         }
         ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
         ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         super.UpdateDataBase(param1);
         this.FDataIceDragon = param1 as TActivityLukiaTotalInfor;
         this.ProcessorCheckEffect();
         this.UpdateUI();
      }
      
      protected function ProcessorCheckEffect() : void
      {
         if(FUpdateStatus != null)
         {
            if(FUpdateStatus != null)
            {
               FUpdateStatus(this);
            }
         }
      }
      
      override protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<String> = null;
         var _loc4_:Vector.<String> = null;
         super.UpdateUI();
         _loc2_ = int(COUNT_MC_BUYBOX);
         _loc3_ = new Vector.<String>(COUNT_TF_BUYBOX);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_[0] = this.FHDIceDragon.ActivitySuperBag.DescrptionTitle[_loc1_].toString();
            if(this.FHDIceDragon.ActivitySuperBag.IfBuyed[_loc1_])
            {
               _loc3_[1] = this.FHDIceDragon.ActivitySuperBag.BagPrice[_loc1_][1].toString();
               _loc3_[2] = this.FHDIceDragon.ActivitySuperBag.DescrptionTwo[_loc1_][1].toString();
            }
            else
            {
               _loc3_[1] = this.FHDIceDragon.ActivitySuperBag.BagPrice[_loc1_][0].toString();
               _loc3_[2] = this.FHDIceDragon.ActivitySuperBag.DescrptionTwo[_loc1_][0].toString();
            }
            this.FCurBuyBoxCostVect[_loc1_] = int(_loc3_[1]);
            this.FMC_BuyBoxes[_loc1_].UpDatePrompt(_loc3_);
            this.FMC_BuyBoxes[_loc1_].UpDateBtn(CONST_ACTIVITY_MODE.Activity_CanReceive);
            _loc1_++;
         }
         this.FMC_Knife.UpdateUI(this.FDataIceDragon.ActivityLukia,this.FDataIceDragon.ActivityLukiaChip);
         _loc2_ = int(COUNT_MC_EXCHANGEBOX);
         _loc4_ = new Vector.<String>(COUNT_TF_EXCHANGEBOX);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_[0] = this.FHDIceDragon.ActivityExchangeBag.ChipNeed[_loc1_].toString();
            this.FMC_ExchangeBoxes[_loc1_].UpDatePrompt(_loc4_);
            this.FMC_ExchangeBoxes[_loc1_].UpDateBtn(CONST_ACTIVITY_MODE.Activity_CanReceive);
            _loc1_++;
         }
         this.FTF_CurChip.text = this.FDataIceDragon.ActivityLukiaChip.ChipNum.toString();
      }
      
      override protected function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         super.Reset();
         if(!this.FIsInitWindow)
         {
            return;
         }
         _loc2_ = int(this.FRoleModelIDs.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FRoleModelIDs[_loc1_];
            SResourcesCore.TexturesModel.DeleteByIdentifier(_loc3_,true);
            _loc1_++;
         }
         this.FRoleModelIDs.length = 0;
         _loc2_ = int(COUNT_MC_BUYBOX);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_BuyBoxes[_loc1_].Clear();
            _loc1_++;
         }
         _loc2_ = int(COUNT_MC_EXCHANGEBOX);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_ExchangeBoxes[_loc1_].Clear();
            _loc1_++;
         }
         this.FKnifePop.Visible = false;
         this.FMC_Knife.Reset();
         this.FBoxType = TYPE_BOX_NONE;
      }
      
      override protected function WindowInformationOnOK(param1:Object) : void
      {
         super.WindowInformationOnOK(param1);
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FBoxUniqueIndex);
      }
      
      protected function ProcessorBuyBoxOnClick(param1:Object, param2:int) : void
      {
         if(FCharacter.CreditGold >= this.FCurBuyBoxCostVect[param2])
         {
            this.FBoxType = TYPE_BOX_BUY;
            this.FBoxUniqueIndex = this.FHDIceDragon.ActivitySuperBag.Index[param2];
            FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_59),this.FCurBuyBoxCostVect[param2]);
            FUIWindowConfirmation.OnOK = this.WindowInformationOnOK;
            FUIWindowConfirmation.OnCancel = WindowInformationOnCancel;
            FUIWindowConfirmation.Visible = true;
         }
         else
         {
            FUIWindowRecharge.Visible = true;
         }
      }
      
      protected function ProcessorExchangeBoxOnClick(param1:Object, param2:int) : void
      {
         if(this.FDataIceDragon.ActivityLukiaChip.ChipNum >= this.FHDIceDragon.ActivityExchangeBag.ChipNeed[param2])
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FHDIceDragon.ActivityExchangeBag.Index[param2]);
         }
         else if(FOnEffectText != null)
         {
            FOnEffectText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_63));
         }
      }
      
      protected function ProcessorOnShowKnifeClick(param1:Object) : void
      {
         this.FKnifePop.KnifeData = this.FKnifeOfKillSoulData;
         this.FKnifePop.Visible = true;
      }
      
      protected function KnifePopOnClose(param1:Object) : void
      {
         this.FKnifePop.Visible = false;
      }
      
      protected function ProcessorOnExchangeKnifeClick(param1:Object, param2:TActivityLukia) : void
      {
         if(this.FDataIceDragon.ActivityLukiaChip.ChipNum >= param2.EnlistNeed)
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param2.Index);
         }
         else
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_63));
         }
      }
      
      protected function HeroOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         var _loc8_:TRoleModel = null;
         var _loc9_:uint = 0;
         _loc5_ = param2 as uint;
         _loc6_ = SResourcesCore.TexturesModel;
         _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,_loc5_) as TRoleModel;
         if(_loc8_ == null)
         {
            return;
         }
         _loc9_ = (_loc8_.Model << 8) + CONST_ROLE.ROLE_SEQUENCEINDEX_Showcase;
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc9_);
         if(_loc7_ != null)
         {
            param3.Value = _loc7_.GetAnimationSequenceByIndex(0);
         }
         else
         {
            _loc6_.LoadSecondary(_loc9_);
         }
         this.SetRoleModelID(_loc9_);
      }
      
      protected function SetRoleModelID(param1:uint) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FRoleModelIDs.indexOf(param1);
         if(_loc2_ < 0)
         {
            this.FRoleModelIDs.push(param1);
         }
      }
      
      protected function ProcessorBuyBoxOnOver(param1:Object, param2:int) : void
      {
         FHint.Caption = this.FHDIceDragon.ActivitySuperBag.RewardInfor[param2];
         SUtilityOverLayer.UIComponentsHintOnOver(this,FHint);
      }
      
      protected function ProcessorBuyBoxOnOut(param1:Object, param2:int) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,FHint);
      }
      
      protected function ProcessorExchangeBoxOnOver(param1:Object, param2:int) : void
      {
         if(FOnGiftBoxMove != null)
         {
            FOnGiftBoxMove(this,this.FHDIceDragon.ActivityExchangeBag.BagInventories[param2]);
         }
      }
      
      protected function ProcessorExchangeBoxOnOut(param1:Object, param2:int) : void
      {
         if(FOnGiftBoxOut != null)
         {
            FOnGiftBoxOut(this);
         }
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         super.BtnCloseOnClick(param1,param2);
         if(FOnBtnCloseClick != null)
         {
            FOnBtnCloseClick(this);
         }
      }
   }
}

