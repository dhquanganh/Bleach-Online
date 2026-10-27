package Processors.Game.Lobby.TreasureMap.Components
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.Characters.TCharacter;
   import Logics.DatebaseVO.VO.TBuyMoney;
   import Logics.DatebaseVO.VO.TDigging;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Logics.SLogicsCore;
   import Logics.Streamization.Inventories.TUnstreamizerInventoryReference;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import Resources.Constants.CONST_TREASUREMAP;
   import flash.display.MovieClip;
   
   public class TRewardTips extends TUIComponent
   {
      
      protected var FScene:MovieClip;
      
      protected var FDigging:TDigging;
      
      protected var FDiggingBins:TBins;
      
      protected var FInventories:TInventories;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FAwardIDVect:Vector.<uint>;
      
      protected var FBuyMoneyBin:TBins;
      
      protected var FCharacter:TCharacter;
      
      public function TRewardTips(param1:TUIComponent)
      {
         super(param1);
         this.FScene = TUtilityReflection.CreateDisplayObjectInstance(CONST_TREASUREMAP.RESOURCE_ClassName_MC_RewardTip) as MovieClip;
         addChild(this.FScene);
         this.FInventories = new TInventories();
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         this.FAwardIDVect = new Vector.<uint>();
         this.FDiggingBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Digging);
         this.FBuyMoneyBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BuyMoney);
         this.FCharacter = SLogicsCore.Character;
      }
      
      protected function MakeRewardStr(param1:Vector.<Object>) : String
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TBuyMoney = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         _loc7_ = this.FCharacter.GetMainRebirthLevel();
         _loc5_ = this.FBuyMoneyBin.GetDatebaseByIdentifier(_loc7_) as TBuyMoney;
         _loc2_ = "";
         switch(param1)
         {
            case this.FDigging.Award1Vect:
               _loc6_ = _loc5_.Money * this.FDigging.SilverNum1 / 100;
               break;
            case this.FDigging.RobGetReward:
               _loc6_ = _loc5_.Money * this.FDigging.SilverNum1 * this.FDigging.SilverNum2 / 10000;
         }
         _loc2_ += _loc6_ + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Coin) + "\n";
         _loc3_ = int(param1.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ += param1[_loc4_].amount + TUtilityLobby.GetItemName(param1[_loc4_].type,param1[_loc4_].code);
            _loc2_ += " ";
            _loc4_++;
         }
         return _loc2_;
      }
      
      protected function MakeItemRewardStr(param1:Vector.<Object>) : String
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TInventory = null;
         var _loc5_:uint = 0;
         var _loc6_:String = null;
         _loc3_ = int(this.FAwardIDVect.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FAwardIDVect.splice(_loc2_,1);
            _loc2_++;
         }
         _loc3_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = CONST_COMMON.RewardIDToTemplateID(param1[_loc2_].type,param1[_loc2_].code);
            this.FAwardIDVect[_loc2_] = _loc5_;
            _loc2_++;
         }
         this.FInventories.Clear();
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,this.FInventories,this.FAwardIDVect);
         _loc3_ = this.FInventories.Count;
         _loc6_ = "";
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FInventories.GetInventoryByIndex(_loc2_);
            _loc6_ += _loc4_.Name + "*" + param1[_loc2_].amount;
            if(_loc2_ != _loc3_ - 1)
            {
               _loc6_ += "\n";
            }
            _loc2_++;
         }
         return _loc6_;
      }
      
      protected function UpdataUI() : void
      {
         this.FScene.TF_HuntingReward.text = this.MakeRewardStr(this.FDigging.Award1Vect);
         this.FScene.TF_CostTime.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_20),this.FDigging.Digtime / 60);
         this.FScene.TF_Reward.text = this.MakeItemRewardStr(this.FDigging.Award2Vect);
         this.FScene.TF_BeRob.text = this.MakeRewardStr(this.FDigging.RobGetReward);
      }
      
      public function SetRewardData(param1:TDigging) : void
      {
         this.FDigging = param1;
         this.UpdataUI();
      }
      
      public function CheckTipPoint() : void
      {
         if(mouseX > CONST_COMMON.STAGE_Width - this.FScene.width)
         {
            this.FScene.x = Math.max(mouseX - this.FScene.width - 40,0);
         }
         else
         {
            this.FScene.x = Math.min(mouseX + 40,CONST_COMMON.STAGE_Width - this.FScene.width);
         }
         if(mouseY > CONST_COMMON.STAGE_Height - this.FScene.height)
         {
            this.FScene.y = Math.max(mouseY - this.FScene.height,0);
         }
         else
         {
            this.FScene.y = Math.min(mouseY,CONST_COMMON.STAGE_Height - this.FScene.height);
         }
      }
   }
}

