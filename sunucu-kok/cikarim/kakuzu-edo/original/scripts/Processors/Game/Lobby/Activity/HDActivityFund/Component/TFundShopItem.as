package Processors.Game.Lobby.Activity.HDActivityFund.Component
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.HDActivityFund.TFundShopAward;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TFundShopItem extends TUIComponent
   {
      
      protected static const GOODS_NUM:uint = 6;
      
      protected var FTF_Name:TextField;
      
      protected var FTF_ReturnMoney:TextField;
      
      protected var FTF_NeedGold:TextField;
      
      protected var FGoodsList:Vector.<TextField>;
      
      protected var FBT_Buy:TUIButton;
      
      protected var FScence:Sprite;
      
      protected var FItemData:TFundShopAward;
      
      protected var FOnBuyItem:Function;
      
      public function TFundShopItem(param1:TUIComponent, param2:Sprite)
      {
         super(param1);
         this.FScence = param2;
         this.FGoodsList = new Vector.<TextField>(GOODS_NUM);
      }
      
      protected function GoodsItemInit() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:TextField = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         this.FTF_Name = this.FScence[CONST_ACTIVITY.RESOURCE_Link_TF_Name];
         this.FTF_ReturnMoney = this.FScence[CONST_ACTIVITY.RESOURCE_Link_TF_ReturnMoney];
         _loc1_ = this.FScence[CONST_ACTIVITY.RESOURCE_Link_BT_Buy];
         if(_loc1_ != null)
         {
            this.FBT_Buy = new TUIButton();
            this.FBT_Buy.Substrate = _loc1_;
            this.FBT_Buy.OnClick = this.BTBuyOnClick;
         }
         this.FTF_NeedGold = this.FScence[CONST_ACTIVITY.RESOURCE_LinkTF_NeedGold];
         _loc4_ = GOODS_NUM;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = this.FScence[CONST_ACTIVITY.RESOURCE_Link_TF_Goods + _loc3_];
            this.FGoodsList[_loc3_] = _loc2_;
            _loc3_++;
         }
      }
      
      protected function UpdateItem(param1:TInventories) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TextField = null;
         var _loc5_:String = null;
         var _loc6_:TInventory = null;
         _loc3_ = GOODS_NUM;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FGoodsList[_loc2_];
            _loc4_.text = "";
            _loc4_.visible = false;
            _loc2_++;
         }
         _loc3_ = uint(param1.Count);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = param1.GetInventoryByIndex(_loc2_);
            _loc4_ = this.FGoodsList[_loc2_];
            _loc5_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_07),_loc6_.Name,_loc6_.Quantity);
            _loc4_.text = _loc5_;
            _loc4_.visible = true;
            _loc2_++;
         }
         if(this.FTF_NeedGold != null)
         {
            this.FTF_NeedGold.text = this.ItemData.NeedGold.toString();
         }
      }
      
      protected function UpdateName() : void
      {
         this.FTF_Name.text = this.FItemData.ShopName;
         this.FTF_ReturnMoney.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_08),this.FItemData.ReturnMoney);
      }
      
      protected function BTBuyOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnBuyItem != null)
         {
            this.FOnBuyItem(this,FTag);
         }
      }
      
      public function get ItemData() : TFundShopAward
      {
         return this.FItemData;
      }
      
      public function set ItemData(param1:TFundShopAward) : void
      {
         this.FItemData = param1;
      }
      
      public function get OnBuyItem() : Function
      {
         return this.FOnBuyItem;
      }
      
      public function set OnBuyItem(param1:Function) : void
      {
         this.FOnBuyItem = param1;
      }
      
      public function Init(param1:uint) : void
      {
         this.GoodsItemInit();
         FTag = param1;
      }
      
      public function UpdateDesc(param1:TInventories) : void
      {
         this.UpdateItem(param1);
         this.UpdateName();
      }
   }
}

