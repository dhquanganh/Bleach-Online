package Processors.Game.Battle
{
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.Battle.model.TStatisticsInfo;
   import Processors.Game.Battle.Components.TStatisticsItem;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Resources.Constants.CONST_BATTLE;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorWindowStatistics extends TProcessorLobbyWindow
   {
      
      protected static const Info_Num:int = 7;
      
      protected var FBtnClose:SimpleButton;
      
      protected var FMyHeros:Vector.<TStatisticsItem>;
      
      protected var FEnemies:Vector.<TStatisticsItem>;
      
      protected var FMainUI:Sprite;
      
      public function TProcessorWindowStatistics(param1:TUIComponent)
      {
         super(param1);
         this.FMyHeros = new Vector.<TStatisticsItem>();
         this.FEnemies = new Vector.<TStatisticsItem>();
         this.InitWindow();
      }
      
      protected function OnCloseClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function InitWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TStatisticsItem = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance(CONST_BATTLE.RESOURCE_ClassName_Statistics) as MovieClip;
         if(this.FMainUI == null)
         {
            return;
         }
         addChild(this.FMainUI);
         this.FBtnClose = new SimpleButton();
         this.FBtnClose = this.FMainUI["Btn_Close"];
         this.FBtnClose.addEventListener(MouseEvent.CLICK,this.OnCloseClick);
         _loc1_ = 0;
         while(_loc1_ < Info_Num)
         {
            _loc2_ = new TStatisticsItem();
            _loc2_.Init(this.FMainUI["MC_My_" + _loc1_]);
            this.FMyHeros.push(_loc2_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < Info_Num)
         {
            _loc2_ = new TStatisticsItem();
            _loc2_.Init(this.FMainUI["MC_Enemy_" + _loc1_]);
            this.FEnemies.push(_loc2_);
            _loc1_++;
         }
      }
      
      public function UpdateData(param1:TStatisticsInfo) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc4_ = param1.MyTotalHurt;
         _loc5_ = param1.EnemyTotalHurt;
         _loc6_ = _loc4_ + _loc5_;
         _loc3_ = int(param1.MyInfoVec.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FMyHeros[_loc2_].SetHpRate(param1.MyInfoVec[_loc2_].RemainHp);
            this.FMyHeros[_loc2_].SetHurt(param1.MyInfoVec[_loc2_].Hurt,_loc4_,_loc6_);
            this.FMyHeros[_loc2_].SetHead(param1.MyInfoVec[_loc2_].HeroId);
            _loc2_++;
         }
         while(_loc2_ < Info_Num)
         {
            this.FMyHeros[_loc2_].Clear();
            _loc2_++;
         }
         _loc3_ = int(param1.EnemyInfoVec.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FEnemies[_loc2_].SetHpRate(param1.EnemyInfoVec[_loc2_].RemainHp);
            this.FEnemies[_loc2_].SetHurt(param1.EnemyInfoVec[_loc2_].Hurt,_loc5_,_loc6_);
            this.FEnemies[_loc2_].SetHead(param1.EnemyInfoVec[_loc2_].HeroId);
            _loc2_++;
         }
         while(_loc2_ < Info_Num)
         {
            this.FEnemies[_loc2_].Clear();
            _loc2_++;
         }
      }
   }
}

