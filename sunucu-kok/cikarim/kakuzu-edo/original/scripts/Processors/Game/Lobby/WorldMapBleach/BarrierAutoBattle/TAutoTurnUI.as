package Processors.Game.Lobby.WorldMapBleach.BarrierAutoBattle
{
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Campaign.AutoBattle.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Items.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class TAutoTurnUI extends TUIComponent
   {
      
      protected static const QUALITYCOLOR_INDEX:Vector.<uint> = CONST_COMMON.QUALITYCOLOR_INDEX;
      
      protected var FSceneTitie:MovieClip;
      
      protected var FSceneTurnInfo:MovieClip;
      
      protected var FSceneEnd:MovieClip;
      
      protected var FAutoTurnResult:TTurnResult;
      
      protected var FAutoResult:TItems;
      
      protected var FTurn:int;
      
      protected var FPosY:int;
      
      protected var FTotleExp:int;
      
      protected var FTotleMoney:int;
      
      protected var FArticleBins:TBins;
      
      protected var FTextformat:TextFormat;
      
      public function TAutoTurnUI(param1:TUIComponent)
      {
         super(param1);
         mouseEnabled = false;
         mouseChildren = false;
         this.FArticleBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Article);
         this.FTextformat = new TextFormat();
      }
      
      protected function InitUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:TextField = null;
         this.FSceneTitie = TUtilityReflection.CreateDisplayObjectInstance(CONST_CAMPAIGN.RESOURCE_ClassName_BattleTitle) as MovieClip;
         addChild(this.FSceneTitie);
         this.FPosY += this.FSceneTitie.height;
         this.FSceneTitie.tf_turn.text = String(this.FTurn);
         this.FSceneTitie.tf_turn.mouseEnabled = false;
         _loc1_ = 0;
         while(_loc1_ < this.FAutoTurnResult.WaveReward.length)
         {
            this.FSceneTurnInfo = TUtilityReflection.CreateDisplayObjectInstance(CONST_CAMPAIGN.RESOURCE_ClassName_BattleInfo) as MovieClip;
            addChild(this.FSceneTurnInfo);
            this.FSceneTurnInfo.y = this.FPosY;
            this.FPosY += this.FSceneTurnInfo.height;
            _loc2_ = int(this.FAutoTurnResult.WaveReward[_loc1_].Exp);
            _loc3_ = int(this.FAutoTurnResult.WaveReward[_loc1_].Money);
            this.FSceneTurnInfo.tf_times.text = String(_loc1_ + 1);
            this.FSceneTurnInfo.tf_times.mouseEnabled = false;
            this.FSceneTurnInfo.tf_exp.text = String("+" + _loc2_);
            this.FSceneTurnInfo.tf_exp.mouseEnabled = false;
            this.FSceneTurnInfo.tf_money.text = String("+" + _loc3_);
            this.FSceneTurnInfo.tf_money.mouseEnabled = false;
            _loc5_ = this.FSceneTurnInfo.tf_items;
            _loc5_.text = "";
            this.GetTotleItemName(this.FAutoTurnResult.WaveReward[_loc1_],_loc5_);
            this.FSceneTurnInfo.tf_items.mouseEnabled = false;
            this.FTotleExp += _loc2_;
            this.FTotleMoney += _loc3_;
            this.FAutoTurnResult.WaveReward[_loc1_].Clear();
            _loc1_++;
         }
         if(this.FAutoTurnResult.EndReward.Items.length > 0)
         {
            this.FSceneEnd = TUtilityReflection.CreateDisplayObjectInstance(CONST_CAMPAIGN.RESOURCE_ClassName_BattleEnd) as MovieClip;
            addChild(this.FSceneEnd);
            this.FSceneEnd.y = this.FPosY;
            this.FPosY += this.FSceneEnd.height;
            _loc5_ = this.FSceneEnd.tf_items;
            this.GetTotleItemName(this.FAutoTurnResult.EndReward,_loc5_);
            this.FSceneEnd.tf_items.mouseEnabled = false;
         }
         this.FAutoTurnResult.EndReward.Clear();
      }
      
      protected function InitResultUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TextField = null;
         this.FSceneTitie = TUtilityReflection.CreateDisplayObjectInstance(CONST_CAMPAIGN.RESOURCE_ClassName_BattleTitle) as MovieClip;
         addChild(this.FSceneTitie);
         this.FPosY += this.FSceneTitie.height;
         this.FSceneTitie.tf_turn.text = String(this.FTurn);
         this.FSceneTitie.tf_turn.mouseEnabled = false;
         this.FSceneTurnInfo = TUtilityReflection.CreateDisplayObjectInstance(CONST_CAMPAIGN.RESOURCE_ClassName_FBBattleInfo) as MovieClip;
         addChild(this.FSceneTurnInfo);
         this.FSceneTurnInfo.y = this.FPosY;
         this.FPosY += this.FSceneTurnInfo.height;
         _loc1_ = int(this.FAutoResult.Exp);
         _loc2_ = int(this.FAutoResult.Money);
         this.FSceneTurnInfo.tf_exp.text = String("+" + _loc1_);
         this.FSceneTurnInfo.tf_exp.mouseEnabled = false;
         this.FSceneTurnInfo.tf_money.text = String("+" + _loc2_);
         this.FSceneTurnInfo.tf_money.mouseEnabled = false;
         _loc3_ = this.FSceneTurnInfo.tf_items;
         this.GetTotleItemName(this.FAutoResult,_loc3_);
         this.FSceneTurnInfo.tf_items.mouseEnabled = false;
         this.FAutoResult.Clear();
      }
      
      protected function GetTotleItemName(param1:TItems, param2:TextField) : void
      {
         var _loc3_:int = 0;
         var _loc5_:Vector.<TItem> = null;
         var _loc6_:TArticle = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:String = null;
         var _loc4_:String = "";
         _loc5_ = param1.ItemIDs;
         _loc9_ = "";
         _loc3_ = 0;
         while(_loc3_ < _loc5_.length)
         {
            if(_loc3_ != 0)
            {
               _loc9_ += " ";
            }
            _loc4_ = "";
            _loc6_ = this.FArticleBins.GetDatebaseByIdentifier(_loc5_[_loc3_].ID) as TArticle;
            this.FTextformat.color = QUALITYCOLOR_INDEX[_loc6_.Quality];
            if(_loc5_[_loc3_].Type == 1 || _loc5_[_loc3_].Type == 17)
            {
               _loc4_ += _loc6_.Name;
            }
            else
            {
               _loc4_ += TUtilityLobby.GetItemName(_loc5_[_loc3_].Type,_loc5_[_loc3_].ID);
            }
            _loc4_ += "x" + _loc5_[_loc3_].Count;
            _loc7_ += _loc9_.length;
            _loc9_ += _loc4_;
            _loc8_ = uint(_loc9_.length);
            param2.text = _loc9_;
            param2.setTextFormat(this.FTextformat,_loc7_,_loc8_);
            _loc3_++;
         }
      }
      
      public function SetTurnResult(param1:TTurnResult, param2:int) : void
      {
         this.FAutoTurnResult = param1;
         this.FTurn = param2;
         this.FPosY = 0;
         this.FTotleExp = 0;
         this.FTotleMoney = 0;
         this.InitUI();
      }
      
      public function SetResult(param1:TItems, param2:int) : void
      {
         this.FAutoResult = param1;
         this.FTurn = param2;
         this.FPosY = 0;
         this.InitResultUI();
      }
      
      public function get TotleExp() : int
      {
         return this.FTotleExp;
      }
      
      public function get TotleMoney() : int
      {
         return this.FTotleMoney;
      }
   }
}

