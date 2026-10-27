package Processors.Game.Lobby.RelatedPartner.PartnerTrain
{
   import Foundation.Common.THint;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.*;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class TWindowTrainStarReward extends TWindowTrainBase
   {
      
      protected static const Star_Num:int = 5;
      
      protected var FStarGifts:Vector.<TItemTrainGift>;
      
      protected var FStarBins:TBins;
      
      protected var FStarNums:Vector.<int>;
      
      protected var FAwards:Vector.<int>;
      
      protected var FHint:THint;
      
      protected var FMaterialId:int;
      
      protected var FMaterialName:String;
      
      protected var FTFCount:TextField;
      
      protected var FOwnStarCount:int;
      
      protected var FHeroStarCount:int;
      
      public function TWindowTrainStarReward(param1:TUIComponent, param2:Sprite)
      {
         var _loc3_:int = 0;
         var _loc4_:TItemTrainGift = null;
         var _loc5_:TConfigValue = null;
         super(param1,param2);
         this.FStarGifts = new Vector.<TItemTrainGift>();
         _loc3_ = 0;
         while(_loc3_ < Star_Num)
         {
            _loc4_ = new TItemTrainGift(FMainUI["MC_StarItem_" + _loc3_]);
            _loc4_.StarIndex = _loc3_;
            _loc4_.StarOnClick = this.StarOnClick;
            _loc4_.StarOnMove = this.StarOnMove;
            _loc4_.StarOnOut = this.StarOnOut;
            this.FStarGifts.push(_loc4_);
            _loc3_++;
         }
         this.FStarBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         _loc5_ = this.FStarBins.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Related_StarNum) as TConfigValue;
         this.FStarNums = Vector.<int>(_loc5_.Value);
         _loc5_ = this.FStarBins.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Related_Award) as TConfigValue;
         this.FAwards = Vector.<int>(_loc5_.Value);
         this.FHint = new THint();
         this.FTFCount = FMainUI["TF_Count"];
      }
      
      protected function StarOnClick(param1:int) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         if(this.FStarNums[param1] < this.FHeroStarCount)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Related_01));
            return;
         }
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Related_RewardReq);
         _loc3_ = _loc2_.Data;
         _loc3_.writeUnsignedInt(param1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function StarOnOut(param1:int) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(FParent.Parent,this.FHint);
      }
      
      protected function StarOnMove(param1:int) : void
      {
         this.FHint.Caption = this.FMaterialName + " * " + this.FAwards[param1];
         SUtilityOverLayer.UIComponentsHintOnOver(FParent.Parent,this.FHint);
      }
      
      public function Show(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TInventories = null;
         var _loc5_:TConfigValue = null;
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Related_Material) as TConfigValue;
         this.FMaterialId = int(_loc5_.Value);
         this.FMaterialName = (SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,this.FMaterialId) as TArticle).Name;
         this.FOwnStarCount = param1;
         _loc3_ = int(this.FStarNums.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FStarGifts[_loc2_].SetStarCount(this.FStarNums[_loc2_]);
            this.FStarGifts[_loc2_].SetEnabled(this.FOwnStarCount >= this.FStarNums[_loc2_]);
            _loc2_++;
         }
         this.FTFCount.text = param1 + "";
         this.Visible = true;
      }
      
      public function SetStatus(param1:int) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < Star_Num)
         {
            this.FStarGifts[_loc2_].SetStatus((param1 & 1 << _loc2_) > 0);
            _loc2_++;
         }
      }
      
      public function get HeroStarCount() : int
      {
         return this.FHeroStarCount;
      }
      
      public function set HeroStarCount(param1:int) : void
      {
         this.FHeroStarCount = param1;
      }
   }
}

