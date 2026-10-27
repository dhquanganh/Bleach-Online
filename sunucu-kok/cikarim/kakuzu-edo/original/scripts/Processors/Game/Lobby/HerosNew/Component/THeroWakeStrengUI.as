package Processors.Game.Lobby.HerosNew.Component
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.Characters.MainRoleWake.THeroWakeEquipment;
   import Logics.DatebaseVO.VO.Json.TRewards;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Logics.Streamization.Inventories.TUnstreamizerInventoryHeroWake;
   import Processors.Game.Lobby.HerosNew.TMainHeroWakeSlot;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class THeroWakeStrengUI extends TUIComponent
   {
      
      protected const SlotCount:uint = 3;
      
      protected const Equip:uint = 0;
      
      protected const Exclusive:uint = 1;
      
      protected const Common:uint = 2;
      
      protected var FMainUI:MovieClip;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FStrengBtn:TUIButton;
      
      protected var FUnstreamizerInventoryHeroWake:TUnstreamizerInventoryHeroWake;
      
      protected var FHaveExclusive:uint;
      
      protected var FHaveCommon:uint;
      
      protected var FNeedExclusive:uint;
      
      protected var FNeedCommon:uint;
      
      protected var FHeroWakeEquipment:THeroWakeEquipment;
      
      public function THeroWakeStrengUI(param1:TUIComponent)
      {
         super(param1);
         this.FUnstreamizerInventoryHeroWake = new TUnstreamizerInventoryHeroWake();
      }
      
      protected function OnStrBtnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FHeroWakeEquipment.CurStreng == this.FHeroWakeEquipment.WakeUpConfig.MaxStr)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_43));
            return;
         }
         if(this.FHaveExclusive < this.FNeedExclusive || this.FHaveCommon < this.FNeedCommon)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_44));
            return;
         }
         this.FUnstreamizerInventoryHeroWake.AdvancedOrStrengReq(this.FUnstreamizerInventoryHeroWake.ReqType_Streng,this.FHeroWakeEquipment);
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
         this.FMainUI = param1;
         this.FSlots = new Vector.<TUISlot>(this.SlotCount);
         _loc3_ = 0;
         while(_loc3_ < this.SlotCount)
         {
            if(_loc3_ == this.Equip)
            {
               _loc2_ = new TMainHeroWakeSlot(this);
            }
            else
            {
               _loc2_ = new TUISlot(this);
            }
            _loc2_.Resource = this.FMainUI.MC_Boxs["MC_Slot_" + _loc3_];
            _loc2_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc2_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc2_);
            if(_loc3_ == this.Equip)
            {
               _loc2_.OnQuerySubscript = null;
            }
            _loc2_.Init();
            this.FSlots[_loc3_] = _loc2_;
            _loc3_++;
         }
         this.FStrengBtn = new TUIButton();
         this.FStrengBtn.Substrate = this.FMainUI.Btn_Str;
         this.FStrengBtn.OnClick = this.OnStrBtnClick;
      }
      
      public function UpdateUI() : void
      {
         var _loc1_:TInventories = null;
         var _loc2_:TInventory = null;
         var _loc3_:TInventory = null;
         var _loc4_:TRewards = null;
         var _loc5_:Object = null;
         if(!Visible || this.FMainUI == null)
         {
            return;
         }
         _loc1_ = new TInventories();
         _loc4_ = new TRewards(this.FHeroWakeEquipment.WakeUpConfig.StrengthenPriceStr);
         SToolReward.CreateRewardInventoryByRewardInfor(_loc4_,_loc1_);
         _loc2_ = _loc1_.GetInventoryByIndex(0);
         _loc3_ = _loc1_.GetInventoryByIndex(1);
         this.FSlots[this.Equip].Context = null;
         this.FSlots[this.Equip].Context = this.FHeroWakeEquipment;
         this.FSlots[this.Exclusive].Context = _loc2_;
         this.FSlots[this.Common].Context = _loc3_;
         this.FHaveExclusive = TUtilityLobby.GetArticleQuantity(_loc2_.IDTemplate,_loc2_.Category);
         this.FHaveCommon = TUtilityLobby.GetArticleQuantity(_loc3_.IDTemplate,_loc3_.Category);
         this.FNeedExclusive = _loc2_.Quantity;
         this.FNeedCommon = _loc3_.Quantity;
         _loc5_ = this.FHeroWakeEquipment.WakeUpConfig.EquipAttr[0];
         this.FMainUI.TF_StrAddAtt.text = TUtilityLobby.GetBaseAttributeNameByType(_loc5_.type) + "+" + this.FHeroWakeEquipment.WakeUpConfig.ValueStr;
         this.FMainUI.TF_StrMax.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_49),this.FHeroWakeEquipment.WakeUpConfig.MaxStr);
         if(this.FHaveExclusive >= this.FNeedExclusive)
         {
            this.FMainUI.TF_NeedArticle_0.htmlText = _loc2_.Name + "x" + "<font color=\'#00FF00\'>" + this.FHaveExclusive + "</font>";
         }
         else
         {
            this.FMainUI.TF_NeedArticle_0.htmlText = _loc2_.Name + "x" + "<font color=\'#FF0000\'>" + this.FHaveExclusive + "</font>";
         }
         if(this.FHaveCommon >= this.FNeedCommon)
         {
            this.FMainUI.TF_NeedArticle_1.htmlText = _loc3_.Name + "x" + "<font color=\'#00FF00\'>" + this.FHaveCommon + "</font>";
         }
         else
         {
            this.FMainUI.TF_NeedArticle_1.htmlText = _loc3_.Name + "x" + "<font color=\'#FF0000\'>" + this.FHaveCommon + "</font>";
         }
      }
   }
}

