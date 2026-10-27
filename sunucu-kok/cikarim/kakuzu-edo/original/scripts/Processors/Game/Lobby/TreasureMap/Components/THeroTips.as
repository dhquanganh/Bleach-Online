package Processors.Game.Lobby.TreasureMap.Components
{
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.SLogicsCore;
   import Logics.TreasureMap.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.Timing.TUtilityTiming;
   import flash.display.*;
   
   public class THeroTips extends TUIComponent
   {
      
      protected var FScene:MovieClip;
      
      protected var FTreasureMapHero:TTreasureMapHero;
      
      protected var FDiggingBins:TBins;
      
      protected var FGameWinLessTimes:uint;
      
      protected var FBuyMoneyBin:TBins;
      
      public function THeroTips(param1:TUIComponent)
      {
         var _loc2_:TConfigValue = null;
         super(param1);
         this.FScene = TUtilityReflection.CreateDisplayObjectInstance(CONST_TREASUREMAP.RESOURCE_ClassName_MC_HeroTip) as MovieClip;
         addChild(this.FScene);
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.TreasureMap_ColdTime) as TConfigValue;
         this.FGameWinLessTimes = int(_loc2_.Value);
         this.FDiggingBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Digging);
         this.FBuyMoneyBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BuyMoney);
      }
      
      protected function MakeRobRewardStr(param1:uint) : String
      {
         var _loc2_:TDigging = null;
         var _loc3_:Vector.<Object> = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:TBuyMoney = null;
         var _loc8_:uint = 0;
         _loc2_ = this.FDiggingBins.GetDatebaseByIdentifier(param1) as TDigging;
         _loc6_ = "";
         _loc7_ = this.FBuyMoneyBin.GetDatebaseByIdentifier(this.FTreasureMapHero.PlayerLevel) as TBuyMoney;
         if(this.FTreasureMapHero.Identifier0 == SLogicsCore.Character.Identifier0 && this.FTreasureMapHero.Identifier1 == SLogicsCore.Character.Identifier1)
         {
            _loc3_ = _loc2_.Award1Vect;
            _loc8_ = _loc7_.Money * _loc2_.SilverNum1 / 100;
         }
         else
         {
            _loc3_ = _loc2_.RobGetReward;
            _loc8_ = _loc7_.Money * _loc2_.SilverNum1 * _loc2_.SilverNum2 / 10000;
         }
         _loc6_ += _loc8_ + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Coin);
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc6_ += "\n";
            _loc5_ = int(_loc3_[_loc4_].amount);
            _loc6_ += _loc5_ + TUtilityLobby.GetItemName(_loc3_[_loc4_].type,_loc3_[_loc4_].code);
            _loc4_++;
         }
         return _loc6_;
      }
      
      protected function UpdataUI() : void
      {
         var _loc1_:TDigging = null;
         _loc1_ = this.FDiggingBins.GetDatebaseByIdentifier(this.FTreasureMapHero.CurQuality) as TDigging;
         this.FScene.tf_name.text = this.FTreasureMapHero.PlayerNick;
         this.FScene.tf_level.text = "LV." + String(this.FTreasureMapHero.PlayerLevel);
         this.FScene.tf_unionName.text = this.FTreasureMapHero.HeroUnionName;
         this.FScene.tf_mapName.text = _loc1_.Name;
         this.FScene.tf_beRobberyTimes.text = _loc1_.Robbery - this.FTreasureMapHero.BeRobberyTimes;
         if(this.FTreasureMapHero.Identifier0 == SLogicsCore.Character.Identifier0 && this.FTreasureMapHero.Identifier1 == SLogicsCore.Character.Identifier1)
         {
            this.FScene.TF_Prompt.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_27);
         }
         else
         {
            this.FScene.TF_Prompt.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_43);
         }
         if(this.FTreasureMapHero.BeRobberyTimes == _loc1_.Robbery)
         {
            this.FScene.TF_Prompt.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_44);
            this.FScene.tf_rewards.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_28);
         }
         else
         {
            this.FScene.tf_rewards.text = this.MakeRobRewardStr(_loc1_.Identifier);
         }
      }
      
      public function UpdataColdDown() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TDigging = null;
         _loc2_ = this.FDiggingBins.GetDatebaseByIdentifier(this.FTreasureMapHero.CurQuality) as TDigging;
         _loc1_ = _loc2_.Digtime - (this.FTreasureMapHero.IsGameWin ? this.FGameWinLessTimes : 0);
         this.FScene.tf_lastTime.text = TUtilityTiming.fomatTime(_loc1_ + (this.FTreasureMapHero.LastTime - STimingCore.ServerTick));
      }
      
      public function SetHeroData(param1:TTreasureMapHero) : void
      {
         this.FTreasureMapHero = param1;
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

