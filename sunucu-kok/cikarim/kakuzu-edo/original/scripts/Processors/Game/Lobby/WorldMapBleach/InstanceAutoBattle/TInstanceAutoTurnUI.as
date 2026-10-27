package Processors.Game.Lobby.WorldMapBleach.InstanceAutoBattle
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
   
   public class TInstanceAutoTurnUI extends TUIComponent
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
      
      public function TInstanceAutoTurnUI(param1:TUIComponent)
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
         _loc1_ = 0;
         while(_loc1_ < this.FAutoTurnResult.WaveReward.length)
         {
            this.FSceneTurnInfo = TUtilityReflection.CreateDisplayObjectInstance("MC_InstanceAutBattleInfo") as MovieClip;
            addChild(this.FSceneTurnInfo);
            this.FSceneTurnInfo.y = this.FPosY;
            this.FPosY += this.FSceneTurnInfo.height;
            _loc2_ = int(this.FAutoTurnResult.WaveReward[_loc1_].Exp);
            _loc3_ = int(this.FAutoTurnResult.WaveReward[_loc1_].Money);
            this.FSceneTurnInfo.tf_times.text = String(this.FTurn);
            this.FSceneTurnInfo.tf_times.mouseEnabled = false;
            this.FSceneTurnInfo.tf_exp.text = String("+" + _loc2_);
            this.FSceneTurnInfo.tf_exp.mouseEnabled = false;
            this.FSceneTurnInfo.tf_money.text = String("+" + _loc3_);
            this.FSceneTurnInfo.tf_money.mouseEnabled = false;
            this.FSceneTurnInfo.tf_items.text = this.GetTotleItemName(this.FAutoTurnResult.WaveReward[_loc1_]);
            this.FSceneTurnInfo.tf_items.mouseEnabled = false;
            if(this.FSceneTurnInfo.tf_items.text != "")
            {
               TextField(this.FSceneTurnInfo.tf_items).setTextFormat(this.FTextformat);
            }
            this.FTotleExp += _loc2_;
            this.FTotleMoney += _loc3_;
            this.FAutoTurnResult.WaveReward[_loc1_].Clear();
            _loc1_++;
         }
         if(this.FAutoTurnResult.EndReward.Items.length > 0)
         {
            this.FSceneEnd = TUtilityReflection.CreateDisplayObjectInstance("MC_InstanceAutBattleEnd") as MovieClip;
            addChild(this.FSceneEnd);
            this.FSceneEnd.y = this.FPosY;
            this.FPosY += this.FSceneEnd.height;
            _loc2_ = int(this.FAutoTurnResult.EndReward.Exp);
            _loc3_ = int(this.FAutoTurnResult.EndReward.Money);
            this.FSceneEnd.tf_exp.text = String("+" + _loc2_);
            this.FSceneEnd.tf_exp.mouseEnabled = false;
            this.FSceneEnd.tf_money.text = String("+" + _loc3_);
            this.FSceneEnd.tf_money.mouseEnabled = false;
            this.FSceneEnd.tf_items.text = this.GetTotleItemName(this.FAutoTurnResult.EndReward);
            this.FSceneEnd.tf_items.mouseEnabled = false;
            if(this.FSceneEnd.tf_items.text != "")
            {
               TextField(this.FSceneEnd.tf_items).setTextFormat(this.FTextformat);
            }
            this.FTotleExp += _loc2_;
            this.FTotleMoney += _loc3_;
         }
         this.FAutoTurnResult.EndReward.Clear();
      }
      
      protected function InitResultUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
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
         this.FSceneTurnInfo.tf_items.text = this.GetTotleItemName(this.FAutoResult);
         this.FSceneTurnInfo.tf_items.mouseEnabled = false;
         if(this.FSceneEnd.tf_items.text != "")
         {
            TextField(this.FSceneTurnInfo.tf_items).setTextFormat(this.FTextformat);
         }
         this.FAutoResult.Clear();
      }
      
      protected function GetTotleItemName(param1:TItems) : String
      {
         var _loc2_:int = 0;
         var _loc4_:Vector.<TItem> = null;
         var _loc5_:TArticle = null;
         var _loc3_:String = "";
         _loc4_ = param1.ItemIDs;
         _loc2_ = 0;
         while(_loc2_ < _loc4_.length)
         {
            if(_loc2_ != 0)
            {
               _loc3_ += " ";
            }
            _loc5_ = this.FArticleBins.GetDatebaseByIdentifier(_loc4_[_loc2_].ID) as TArticle;
            this.FTextformat.color = QUALITYCOLOR_INDEX[_loc5_.Quality];
            if(_loc4_[_loc2_].Type == 1)
            {
               _loc3_ += _loc5_.Name;
            }
            else
            {
               _loc3_ += TUtilityLobby.GetItemName(_loc4_[_loc2_].Type,_loc4_[_loc2_].ID);
            }
            _loc3_ += "x" + _loc4_[_loc2_].Count;
            _loc2_++;
         }
         return _loc3_;
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

