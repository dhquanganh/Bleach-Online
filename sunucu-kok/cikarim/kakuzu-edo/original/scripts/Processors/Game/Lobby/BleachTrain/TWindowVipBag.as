package Processors.Game.Lobby.BleachTrain
{
   import Components.Standard.TUIButton;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.BleachTrain.TBleachTrainVipBag;
   import Logics.HDActivityMode.TGiftBoxTipData;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import Utilities.UI.Overlayers.TUtilityUIOverlayer;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TWindowVipBag extends TProcessorLobbyWindow
   {
      
      protected const VipBagNum:int = 5;
      
      protected var FGoodsSlots:Vector.<Sprite>;
      
      protected var FGoodsMountResource:Vector.<Sprite>;
      
      protected var FGoodsMountPoint:Vector.<Bitmap>;
      
      protected var FBtnBuyGoods:Vector.<TUIButton>;
      
      protected var FBtnLable:Vector.<TextField>;
      
      protected var FGoodsDisCount:Vector.<TextField>;
      
      protected var FBuyedFlag:Vector.<Sprite>;
      
      protected var FGiftBoxTipData:TGiftBoxTipData;
      
      protected var FGiftOverLayer:TOverlayerGiftBox;
      
      protected var FVipBagVec:Vector.<TBleachTrainVipBag>;
      
      protected var FGroupID:uint;
      
      protected var FOnBuyBtnClick:Function;
      
      public function TWindowVipBag(param1:TUIComponent)
      {
         super(param1);
      }
      
      public function UIDispatch(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Bitmap = null;
         var _loc4_:Sprite = null;
         var _loc5_:TUIButton = null;
         var _loc6_:Sprite = null;
         this.FGoodsSlots = new Vector.<Sprite>();
         this.FGoodsMountPoint = new Vector.<Bitmap>();
         this.FBtnBuyGoods = new Vector.<TUIButton>();
         this.FBtnLable = new Vector.<TextField>();
         this.FGoodsDisCount = new Vector.<TextField>();
         this.FGoodsMountResource = new Vector.<Sprite>();
         this.FBuyedFlag = new Vector.<Sprite>();
         _loc2_ = 0;
         while(_loc2_ < this.VipBagNum)
         {
            _loc4_ = param1["Goods" + _loc2_];
            this.FGoodsSlots.push(_loc4_);
            _loc6_ = _loc4_["MountPoint"];
            _loc3_ = new Bitmap();
            _loc6_.addChild(_loc3_);
            this.FGoodsMountPoint.push(_loc3_);
            this.FGoodsMountResource.push(_loc6_);
            _loc6_.addEventListener(MouseEvent.MOUSE_MOVE,this.RewardPicOnMouseMove);
            _loc6_.addEventListener(MouseEvent.MOUSE_OUT,this.RewardPicOnMouseOut);
            _loc5_ = new TUIButton();
            _loc5_.Substrate = _loc4_["BtnBuy"];
            _loc5_.OnClick = this.BtnBuyOnMouseClick;
            this.FBtnBuyGoods.push(_loc5_);
            this.FBtnLable.push(_loc4_["BtnBuy"]["Lable"]);
            this.FGoodsDisCount.push(_loc4_["Discount"]);
            this.FBuyedFlag.push(_loc4_["BuyedFlag"]);
            _loc2_++;
         }
         this.FGiftBoxTipData = new TGiftBoxTipData();
         this.FGiftOverLayer = new TOverlayerGiftBox(this.Parent.Parent);
         this.FGiftOverLayer.visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FGiftOverLayer);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
      }
      
      protected function RenderingSlot() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TBleachTrainVipBag = null;
         _loc2_ = int(this.FVipBagVec.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FVipBagVec[_loc1_];
            SResourcesCore.TexturesInventory.LoadAutoSecondary(_loc3_.Icon,this.PicArrive);
            this.FBtnLable[_loc1_].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BleachTrain_02),_loc3_.VipNeed);
            this.FGoodsDisCount[_loc1_].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BleachTrain_03),_loc3_.RewardDiscount);
            this.FBtnBuyGoods[_loc1_].Visible = !_loc3_.IfSelled;
            _loc1_++;
         }
      }
      
      protected function PicArrive(param1:Object, param2:TTexture, param3:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc5_ = int(this.FVipBagVec.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(this.FVipBagVec[_loc4_].Icon == param3)
            {
               this.FGoodsMountPoint[_loc4_].bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
            }
            _loc4_++;
         }
      }
      
      protected function BtnBuyOnMouseClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TBleachTrainVipBag = null;
         _loc3_ = this.FBtnBuyGoods.indexOf(param1 as TUIButton);
         _loc4_ = this.FVipBagVec[_loc3_];
         this.FOnBuyBtnClick(this,_loc4_.Icon,_loc4_.RewardOriginal,_loc4_.RewardPrice,this.FGroupID,_loc3_);
      }
      
      protected function RewardPicOnMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FGoodsMountResource.indexOf(param1.currentTarget as Sprite);
         this.FGiftBoxTipData.TipReset();
         this.FGiftBoxTipData.NormalInventories = this.FVipBagVec[_loc2_].Rewards;
         this.FGiftBoxTipData.AwardType = TOverlayerGiftBox.TYPE_ALL;
         this.FGiftBoxTipData.NeedColour = true;
         this.FGiftOverLayer.Context = this.FGiftBoxTipData;
         this.FGiftOverLayer.Render(FUICore.MouseCoordinate);
         this.FGiftOverLayer.Show();
      }
      
      protected function RewardPicOnMouseOut(param1:MouseEvent) : void
      {
         this.FGiftOverLayer.Hide();
      }
      
      public function set OnBuyBtnClick(param1:Function) : void
      {
         this.FOnBuyBtnClick = param1;
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.VipBagNum)
         {
            this.FGoodsMountPoint[_loc1_].bitmapData = null;
            _loc1_++;
         }
      }
      
      public function ShowViewByVipBags(param1:Vector.<TBleachTrainVipBag>, param2:uint) : void
      {
         this.FGroupID = param2;
         this.FVipBagVec = param1;
         this.RenderingSlot();
      }
   }
}

