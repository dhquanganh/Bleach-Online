package Processors.Game.Lobby.Activity.HDRushInSeireitei.windows
{
   import Components.SelectBox.TSelectBoxSingle;
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.Agent.SParametersCore;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDRushInSeireitei;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDRushInSeireitei.THDRushInSeireiteiData;
   import Logics.Inventories.TInventories;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDRushInSeireitei.components.TItemRushInSeireitei;
   import Processors.Game.Lobby.Activity.HDRushInSeireitei.components.TItemSeireiteiEffect;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TViewHDRushInSeireitei extends TProcessorHDSingleWindowBase
   {
      
      protected static const Head_Num:int = 13;
      
      protected static const Select_Num:int = 4;
      
      protected static const Can_Get:int = 1;
      
      protected static const CanNot_Get:int = 0;
      
      protected static const Has_Get:int = -1;
      
      protected var FTFMilitary:TextField;
      
      protected var FTFNomalCount:TextField;
      
      protected var FTFSpecialCount:TextField;
      
      protected var FBtnExchange:TUIButton;
      
      protected var FBtnShop:TUIButton;
      
      protected var FBtnRank:TUIButton;
      
      protected var FBtnReset:TUIButton;
      
      protected var FBtnDisplay:TUIButton;
      
      protected var FConfigData:THDRushInSeireitei;
      
      protected var FActivityData:THDRushInSeireiteiData;
      
      protected var FHeadItems:Vector.<TItemRushInSeireitei>;
      
      protected var FSelectBox:TSelectBoxSingle;
      
      protected var FCurIndex:int;
      
      protected var FCurLevel:int;
      
      protected var FAnimations:TItemSeireiteiEffect;
      
      protected var FSelectVec:Vector.<Sprite>;
      
      protected var FNomalNum:int;
      
      protected var FSpecialNum:int;
      
      protected var FIsWin:Boolean;
      
      protected var FOnGotoShop:Function;
      
      protected var FOnGotoRank:Function;
      
      public function TViewHDRushInSeireitei(param1:TUIComponent)
      {
         super(param1);
         this.FHeadItems = new Vector.<TItemRushInSeireitei>();
         this.FSelectVec = new Vector.<Sprite>();
      }
      
      protected function SendServerData(param1:int) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param1);
      }
      
      override protected function UpdateUI() : void
      {
         super.UpdateUI();
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         this.FBtnReset.Enabled = false;
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         super.UpdateDataBase(param1);
         this.FActivityData = param1 as THDRushInSeireiteiData;
         ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
         ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         this.FTFNomalCount.text = this.FActivityData.NomalCount + "";
         this.FTFSpecialCount.text = this.FActivityData.SpecialCount + "";
         this.FTFMilitary.text = SLogicsCore.Character.CreditMilitaryOrders + "";
         _loc3_ = int(this.FActivityData.LevelStatusVec.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FCurLevel = this.FConfigData.GiftIndexVec.indexOf(this.FActivityData.CurLevelIndex);
            if(_loc2_ > this.FCurLevel)
            {
               this.FHeadItems[_loc2_].Role = this.FConfigData.PicVec[_loc2_];
               this.FHeadItems[_loc2_].ShowFlag = false;
            }
            else if(this.FActivityData.LevelStatusVec[_loc2_] == CanNot_Get)
            {
               this.FHeadItems[_loc2_].Role = this.FConfigData.PicVec[_loc2_];
               this.FHeadItems[_loc2_].Hp = this.FConfigData.BossHpVec[_loc2_];
            }
            this.FHeadItems[_loc2_].GiftStatus = this.FActivityData.LevelStatusVec[_loc2_];
            _loc2_++;
         }
         if(this.FCurLevel >= 0)
         {
            this.FAnimations.SetPosition(this.FHeadItems[this.FCurLevel].Context);
         }
         this.FAnimations.InvisibleAll();
         if(this.FActivityData.CurLevelIndex == -1)
         {
            this.FBtnReset.Enabled = true;
         }
      }
      
      protected function StartFight() : void
      {
         if(this.FNomalNum > 0)
         {
            --this.FNomalNum;
            this.FAnimations.CallAnimationBack = this.StartFight;
            this.FAnimations.PlayAnimation(TItemSeireiteiEffect.Animation_Nomal);
         }
         else if(this.FSpecialNum > 0)
         {
            --this.FSpecialNum;
            this.FAnimations.CallAnimationBack = this.StartFight;
            this.FAnimations.PlayAnimation(TItemSeireiteiEffect.Animation_Special);
         }
         else
         {
            this.FAnimations.CallAnimationBack = this.FightEnd;
            if(this.FIsWin)
            {
               this.FAnimations.PlayAnimation(TItemSeireiteiEffect.Animation_Succ);
            }
            else
            {
               this.FAnimations.PlayAnimation(TItemSeireiteiEffect.Animation_Fail);
            }
         }
      }
      
      protected function FightEnd() : void
      {
         this.FHeadItems[this.FCurLevel].RoleEnabled = true;
         this.SendServerData(this.FConfigData.AttackIndex);
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function OnNomalClick(param1:Object, param2:MouseEvent) : void
      {
         FUIWindowConfirmation.Visible = true;
         FUIWindowConfirmation.Text = TUtilityString.Format(this.FConfigData.StrVec[3],this.FConfigData.MilitaryVec[this.FCurIndex],this.FConfigData.StrVec[3 + this.FCurIndex + 1]);
         FUIWindowConfirmation.OnOK = this.ConfirmationOnOk;
      }
      
      protected function ConfirmationOnOk(param1:Object) : void
      {
         this.SendServerData(this.FConfigData.AttackIndexVec[this.FCurIndex]);
      }
      
      protected function OnRecharge(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToRechargeUrl(SParametersCore.PayUrl);
      }
      
      protected function OnReset(param1:Object, param2:MouseEvent) : void
      {
         this.SendServerData(this.FConfigData.RefreshIndex);
      }
      
      protected function OnShopClick(param1:Object, param2:MouseEvent) : void
      {
         this.FOnGotoShop();
      }
      
      protected function OnRankClick(param1:Object, param2:MouseEvent) : void
      {
         this.FOnGotoRank();
      }
      
      protected function OnBtnOver(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FSelectVec.indexOf(param1.target as Sprite);
         if(_loc2_ < 0)
         {
            return;
         }
         FHint.Caption = TUtilityString.Format(this.FConfigData.StrVec[0],this.FConfigData.MilitaryVec[_loc2_],this.FConfigData.HurtVec[_loc2_]);
         SUtilityOverLayer.UIComponentsHintOnOver(FUICore,FHint);
      }
      
      protected function OnBtnOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(FUICore,FHint);
      }
      
      protected function BoxOnSelected(param1:int, param2:int) : void
      {
         this.FCurIndex = param2;
      }
      
      protected function GiftOnMove(param1:Object, param2:int) : void
      {
         var _loc3_:TInventories = null;
         if(param2 < 0)
         {
            return;
         }
         _loc3_ = new TInventories();
         SToolReward.GetAwardsByAwardID(this.FConfigData.AwardIdsVec[param2][this.FActivityData.RefreshType],_loc3_);
         ProcessorOnGiftBoxMove(param1,_loc3_);
      }
      
      protected function GiftOnOut(param1:Object) : void
      {
         ProcessorOnGiftBoxOut(param1);
      }
      
      protected function GiftOnClick(param1:Object, param2:int) : void
      {
         if(param2 < 0)
         {
            return;
         }
         if(this.FActivityData.LevelStatusVec[param2] == Can_Get)
         {
            this.SendServerData(this.FConfigData.GiftIndexVec[param2]);
         }
      }
      
      protected function RoleOnOver(param1:Object) : void
      {
         var _loc2_:TItemRushInSeireitei = null;
         _loc2_ = param1 as TItemRushInSeireitei;
         FHint.Caption = TUtilityString.Format(this.FConfigData.StrVec[1],_loc2_.Hp);
         SUtilityOverLayer.UIComponentsHintOnOver(FUICore,FHint);
      }
      
      protected function RoleOnOut(param1:Object) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(FUICore,FHint);
      }
      
      protected function RoleOnClick(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         _loc6_ = true;
         this.FIsWin = false;
         _loc5_ = this.FActivityData.NomalCount;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc2_ += this.FConfigData.NomalHurt;
            if(_loc2_ >= this.FHeadItems[this.FCurLevel].Hp)
            {
               _loc4_++;
               _loc6_ = false;
               this.FIsWin = true;
               break;
            }
            _loc4_++;
         }
         this.FNomalNum = _loc4_;
         if(_loc6_)
         {
            _loc5_ = this.FActivityData.SpecialCount;
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc3_ += this.FConfigData.SpecialHurt;
               if(_loc3_ + _loc2_ >= this.FHeadItems[this.FCurLevel].Hp)
               {
                  _loc4_++;
                  this.FIsWin = true;
                  break;
               }
               _loc4_++;
            }
            this.FSpecialNum = _loc4_;
         }
         if(this.FSpecialNum > 0 || this.FNomalNum > 0)
         {
            this.StartFight();
            this.FHeadItems[this.FCurLevel].RoleEnabled = false;
         }
         else
         {
            SToolReward.ShowMessage(this.FConfigData.StrVec[2]);
         }
      }
      
      protected function OnPetDisplayOver(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FActivityData.VicePet);
      }
      
      protected function OnPetDisplayOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FActivityData.VicePet);
      }
      
      public function get OnGotoShop() : Function
      {
         return this.FOnGotoShop;
      }
      
      public function set OnGotoShop(param1:Function) : void
      {
         this.FOnGotoShop = param1;
      }
      
      public function get OnGotoRank() : Function
      {
         return this.FOnGotoRank;
      }
      
      public function set OnGotoRank(param1:Function) : void
      {
         this.FOnGotoRank = param1;
      }
      
      override public function Show(param1:TActivityAtoms = null, param2:THDActivityBase = null, param3:TActivityOSBase = null) : void
      {
         this.FConfigData = param2 as THDRushInSeireitei;
         this.FActivityData = param3 as THDRushInSeireiteiData;
         super.Show(param1,param2,param3);
         this.UpdateUI();
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         super.LogicsPerform();
         if(this.FActivityData == null)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < Head_Num)
         {
            this.FHeadItems[_loc1_].Update();
            _loc1_++;
         }
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:TItemRushInSeireitei = null;
         super.InitWindow(param1);
         _loc3_ = FScene["MC_Detail"];
         this.FTFNomalCount = _loc3_["TF_NomalCount"];
         this.FTFSpecialCount = _loc3_["TF_SpecialCount"];
         this.FTFMilitary = _loc3_["TF_Military"];
         this.FBtnExchange = new TUIButton();
         this.FBtnExchange.Substrate = _loc3_["Btn_Exchange"];
         this.FBtnExchange.OnClick = this.OnNomalClick;
         this.FBtnReset = new TUIButton();
         this.FBtnReset.Substrate = FScene["Btn_Reset"];
         this.FBtnReset.OnClick = this.OnReset;
         this.FBtnReset.Enabled = false;
         this.FBtnDisplay = new TUIButton();
         this.FBtnDisplay.Substrate = FScene["Btn_Display"];
         this.FBtnDisplay.OnMove = this.OnPetDisplayOver;
         this.FBtnDisplay.OnOut = this.OnPetDisplayOut;
         this.FBtnShop = new TUIButton();
         this.FBtnShop.Substrate = FScene["Btn_Shop"];
         this.FBtnShop.OnClick = this.OnShopClick;
         this.FBtnRank = new TUIButton();
         this.FBtnRank.Substrate = FScene["Btn_Rank"];
         this.FBtnRank.OnClick = this.OnRankClick;
         _loc2_ = 0;
         while(_loc2_ < Head_Num)
         {
            _loc4_ = new TItemRushInSeireitei();
            _loc4_.InitView(FScene["MC_Head_" + _loc2_]);
            _loc4_.TargetIndex = _loc2_;
            _loc4_.OnOver = this.GiftOnMove;
            _loc4_.OnOut = this.GiftOnOut;
            _loc4_.OnClick = this.GiftOnClick;
            _loc4_.RoleOnOver = this.RoleOnOver;
            _loc4_.RoleOnOut = this.RoleOnOut;
            _loc4_.RoleOnClick = this.RoleOnClick;
            this.FHeadItems.push(_loc4_);
            _loc2_++;
         }
         this.FSelectBox = new TSelectBoxSingle();
         _loc2_ = 0;
         while(_loc2_ < Select_Num)
         {
            this.FSelectBox.SetTaskByIndex(_loc2_,_loc3_["MC_Check_" + _loc2_]["MC_Button"]);
            this.FSelectVec.push(_loc3_["MC_Check_" + _loc2_]);
            this.FSelectVec[_loc2_].addEventListener(MouseEvent.MOUSE_MOVE,this.OnBtnOver);
            this.FSelectVec[_loc2_].addEventListener(MouseEvent.MOUSE_OUT,this.OnBtnOut);
            _loc2_++;
         }
         this.FSelectBox.Init();
         this.FSelectBox.CallBackOnSelect = this.BoxOnSelected;
         this.FCurIndex = 0;
         this.FAnimations = new TItemSeireiteiEffect();
         this.FAnimations.InitView(FScene["MC_Effect"]);
      }
   }
}

