package Processors.Game.Lobby.HerosNew.Component
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Common.THint;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.Characters.MainRoleWake.THeroWakeData;
   import Logics.Characters.MainRoleWake.THeroWakeEquipment;
   import Logics.Characters.THero;
   import Logics.DatebaseVO.VO.Json.TRewards;
   import Logics.DatebaseVO.VO.TBaseStone;
   import Logics.Inventories.TAppliance;
   import Logics.Inventories.TEquipment;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Logics.SLogicsCore;
   import Logics.Streamization.Inventories.TUnstreamizerInventoryHeroWake;
   import Processors.Game.Lobby.HerosNew.TMainHeroWakeSlot;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_CHARACTER;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class THeroWakeAdvancedUI extends TUIComponent
   {
      
      protected const SlotCount:uint = 3;
      
      protected const CurPhase:uint = 1;
      
      protected const NextPhase:uint = 0;
      
      protected const Article:uint = 2;
      
      protected var FMainUI:MovieClip;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FAdvaBtn:TUIButton;
      
      protected var FHint:THint;
      
      protected var FNextHeroWakeEquipment:THeroWakeEquipment;
      
      protected var FUpHeroWakeEquipment:THeroWakeEquipment;
      
      protected var FUnstreamizerInventoryHeroWake:TUnstreamizerInventoryHeroWake;
      
      protected var FHaveArticle:uint;
      
      protected var FNeedArticle:uint;
      
      protected var FHeroWakeEquipment:THeroWakeEquipment;
      
      public function THeroWakeAdvancedUI(param1:TUIComponent)
      {
         super(param1);
         this.FUnstreamizerInventoryHeroWake = new TUnstreamizerInventoryHeroWake();
      }
      
      protected function ComputeStoneAllAtt(param1:THero) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Number = NaN;
         var _loc6_:String = null;
         var _loc7_:uint = 0;
         var _loc8_:Number = NaN;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:uint = 0;
         _loc5_ = 0;
         _loc8_ = 0;
         _loc3_ = CONST_COMMON.StoneSecondaryType.length;
         _loc11_ = CONST_COMMON.StoneAttType.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = CONST_COMMON.StoneSecondaryType[_loc2_];
            _loc5_ = this.GetStoneAllAtt(param1,_loc4_);
            _loc6_ = Number(_loc5_ * 100).toFixed(2) + "%";
            _loc8_ = 0;
            if(_loc5_ != 0 && _loc2_ < _loc11_ && param1.IsMain)
            {
               _loc7_ = CONST_COMMON.StoneAttType[_loc2_];
               _loc8_ = this.GetStoneAttAdd(_loc7_);
               _loc8_ = _loc8_ * _loc5_;
            }
            if(_loc8_ == 0)
            {
               _loc9_ = "0%";
            }
            else
            {
               _loc9_ = Number(_loc8_ * 100).toFixed(2) + "%";
            }
            if(_loc5_ != 0)
            {
               _loc10_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Jade_STRING_17);
               _loc10_ = TUtilityString.Format(_loc10_,_loc6_,_loc9_);
            }
            else
            {
               _loc10_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Jade_STRING_16);
            }
            this.FMainUI.MC_AllAttTip["TF_Att_" + _loc2_].htmlText = _loc10_;
            _loc2_++;
         }
      }
      
      protected function GetStoneAllAtt(param1:THero, param2:uint) : Number
      {
         var _loc3_:Number = NaN;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:TEquipment = null;
         var _loc9_:TAppliance = null;
         var _loc10_:TBaseStone = null;
         _loc3_ = 0;
         _loc6_ = uint(CONST_CHARACTER.CAPACITY_EquipmentsMounted);
         _loc4_ = 0;
         while(_loc4_ < _loc6_)
         {
            _loc8_ = param1.EquipmentsMounted.GetInventoryByIndex(_loc4_) as TEquipment;
            if(_loc8_ != null)
            {
               _loc7_ = uint(_loc8_.GiftedStoneItems.Count);
               _loc5_ = 0;
               while(_loc5_ < _loc7_)
               {
                  _loc9_ = _loc8_.GiftedStoneItems.GetGiftedStoneByIndex(_loc5_);
                  if(_loc9_.CategorySecond == param2)
                  {
                     _loc10_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseStone,_loc9_.IDTemplate) as TBaseStone;
                     if(param2 == 104)
                     {
                        _loc3_ += _loc10_.AddValue / 50;
                     }
                     else
                     {
                        _loc3_ += _loc10_.AddValue;
                     }
                  }
                  _loc5_++;
               }
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      protected function GetStoneAttAdd(param1:uint) : Number
      {
         var _loc2_:THeroWakeData = null;
         var _loc3_:THeroWakeEquipment = null;
         var _loc4_:Object = null;
         _loc2_ = SLogicsCore.HeroWakeData;
         _loc3_ = _loc2_.Equips[THeroWakeData.StonePos];
         for each(_loc4_ in _loc3_.WakeUpConfig.EquipAttr)
         {
            if(_loc4_.type == param1)
            {
               return _loc4_.value;
            }
         }
         return 0;
      }
      
      protected function OnAdvaBtnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FHeroWakeEquipment.WakeUpConfig.NextID == 0)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_39));
            return;
         }
         if(SLogicsCore.Character.GetMainLevel() < this.FHeroWakeEquipment.WakeUpConfig.UpLevel)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_40));
            return;
         }
         if(this.FHaveArticle < this.FNeedArticle)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_41));
            return;
         }
         if(THeroWakeData.IsEquips(this.FHeroWakeEquipment) && this.FHeroWakeEquipment.CurStreng < this.FHeroWakeEquipment.WakeUpConfig.MaxStr)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_42));
            return;
         }
         this.FUnstreamizerInventoryHeroWake.AdvancedOrStrengReq(this.FUnstreamizerInventoryHeroWake.ReqType_Advanced,this.FHeroWakeEquipment);
      }
      
      protected function OnShowAllStoneAttMCOver(param1:MouseEvent) : void
      {
         this.ComputeStoneAllAtt(SLogicsCore.Character.MainHero);
         this.FMainUI.MC_AllAttTip.visible = true;
      }
      
      protected function OnShowAllStoneAttMCOut(param1:MouseEvent) : void
      {
         this.FMainUI.MC_AllAttTip.visible = false;
      }
      
      public function set HeroWakeEquipment(param1:THeroWakeEquipment) : void
      {
         this.FHeroWakeEquipment = param1;
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         if(this.FMainUI != null)
         {
            this.FMainUI.visible = param1;
            if(param1)
            {
               this.FMainUI.MC_ShowAllStoneAtt.MC_Anim.play();
            }
            else
            {
               this.FMainUI.MC_ShowAllStoneAtt.MC_Anim.stop();
            }
         }
         this.UpdateUI();
      }
      
      public function LogicsPerform() : void
      {
         var _loc1_:TUISlot = null;
         if(this.FSlots != null)
         {
            for each(_loc1_ in this.FSlots)
            {
               _loc1_.Update();
            }
         }
      }
      
      public function UIDispatch(param1:MovieClip) : void
      {
         var _loc2_:TUISlot = null;
         var _loc3_:uint = 0;
         this.FHint = new THint();
         this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_38);
         this.FMainUI = param1;
         this.FSlots = new Vector.<TUISlot>(this.SlotCount);
         _loc3_ = 0;
         while(_loc3_ < this.SlotCount)
         {
            if(_loc3_ == this.Article)
            {
               _loc2_ = new TUISlot(this);
            }
            else
            {
               _loc2_ = new TMainHeroWakeSlot(this);
               (_loc2_ as TMainHeroWakeSlot).Hint = this.FHint;
            }
            _loc2_.Resource = this.FMainUI.MC_Boxs["MC_Slot_" + _loc3_];
            _loc2_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc2_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc2_);
            if(_loc3_ != this.Article)
            {
               _loc2_.OnQuerySubscript = null;
            }
            _loc2_.Init();
            this.FSlots[_loc3_] = _loc2_;
            _loc3_++;
         }
         this.FAdvaBtn = new TUIButton();
         this.FAdvaBtn.Substrate = this.FMainUI.Btn_Adva;
         this.FAdvaBtn.OnClick = this.OnAdvaBtnClick;
         this.FMainUI.MC_ShowAllStoneAtt.addEventListener(MouseEvent.ROLL_OVER,this.OnShowAllStoneAttMCOver);
         this.FMainUI.MC_ShowAllStoneAtt.addEventListener(MouseEvent.ROLL_OUT,this.OnShowAllStoneAttMCOut);
         this.FMainUI.MC_AllAttTip.visible = false;
         this.FMainUI.MC_ShowAllStoneAtt.MC_Anim.play();
      }
      
      public function UpdateUI() : void
      {
         var _loc1_:TInventories = null;
         var _loc2_:TInventory = null;
         var _loc3_:TRewards = null;
         if(!Visible || this.FMainUI == null)
         {
            return;
         }
         if(THeroWakeData.IsEquips(this.FHeroWakeEquipment))
         {
            this.FMainUI.MC_NeedLevel.visible = true;
            this.FMainUI.MC_NeedLevel.TF_NeedLevel.text = this.FHeroWakeEquipment.WakeUpConfig.UpLevel.toString();
         }
         else
         {
            this.FMainUI.MC_NeedLevel.visible = false;
         }
         this.FSlots[this.CurPhase].Context = null;
         this.FSlots[this.CurPhase].Context = this.FHeroWakeEquipment;
         this.FNextHeroWakeEquipment = this.FUnstreamizerInventoryHeroWake.CreateHeroWakeEquipment(this.FHeroWakeEquipment.WakeUpConfig.NextID);
         this.FUpHeroWakeEquipment = this.FUnstreamizerInventoryHeroWake.CreateHeroWakeEquipment(this.FHeroWakeEquipment.WakeUpConfig.UpID);
         if(this.FNextHeroWakeEquipment == null)
         {
            this.FNextHeroWakeEquipment = this.FHeroWakeEquipment;
         }
         this.FSlots[this.NextPhase].Context = this.FNextHeroWakeEquipment;
         if(this.FHeroWakeEquipment.WakeUpConfig.NextID == 0)
         {
            _loc3_ = new TRewards(this.FUpHeroWakeEquipment.WakeUpConfig.UpLevelPriceStr);
         }
         else
         {
            _loc3_ = new TRewards(this.FHeroWakeEquipment.WakeUpConfig.UpLevelPriceStr);
         }
         _loc1_ = new TInventories();
         SToolReward.CreateRewardInventoryByRewardInfor(_loc3_,_loc1_);
         _loc2_ = _loc1_.GetInventoryByIndex(0);
         this.FSlots[this.Article].Context = _loc2_;
         this.FNeedArticle = _loc2_.Quantity;
         this.FHaveArticle = TUtilityLobby.GetArticleQuantity(_loc2_.IDTemplate,_loc2_.Category);
         this.FMainUI.TF_Desc.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_50);
         if(this.FHaveArticle >= this.FNeedArticle)
         {
            this.FMainUI.TF_HaveArticle.htmlText = _loc2_.Name + "x" + "<font color=\'#00FF00\'>" + this.FHaveArticle + "</font>";
         }
         else
         {
            this.FMainUI.TF_HaveArticle.htmlText = _loc2_.Name + "x" + "<font color=\'#FF0000\'>" + this.FHaveArticle + "</font>";
         }
         this.FMainUI.MC_ShowAllStoneAtt.visible = THeroWakeData.IsStone(this.FHeroWakeEquipment);
      }
   }
}

