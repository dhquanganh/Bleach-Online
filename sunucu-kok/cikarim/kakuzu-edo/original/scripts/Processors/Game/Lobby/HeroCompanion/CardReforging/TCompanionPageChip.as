package Processors.Game.Lobby.HeroCompanion.CardReforging
{
   import Components.Pages.TUIPage;
   import Foundation.UI.TUIComponent;
   import Logics.HeroCompanion.THeroCompanionCardData;
   import Logics.HeroCompanion.THeroCompanionChipData;
   import Logics.HeroCompanion.THeroCompanionData;
   import Processors.Game.Lobby.HeroCompanion.Components.TCompanionChipItem;
   import Resources.Constants.*;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TCompanionPageChip
   {
      
      protected static const Reforging_Chip_Num:int = CONST_HEROCOMPANION.Reforging_Chip_Num;
      
      protected var FMainUI:Sprite;
      
      protected var FPage:TUIPage;
      
      protected var FChipVec:Vector.<TCompanionChipItem>;
      
      protected var FChipDatas:Vector.<THeroCompanionChipData>;
      
      protected var FPageIndex:int;
      
      protected var FData:THeroCompanionData;
      
      protected var FItemOnOver:Function;
      
      protected var FItemOnOut:Function;
      
      protected var FItemOnDown:Function;
      
      public function TCompanionPageChip(param1:TUIComponent, param2:Sprite)
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TCompanionChipItem = null;
         super();
         this.FMainUI = param2;
         this.FPage = new TUIPage(param1);
         this.FPage.ButtonPrevious.Substrate = this.FMainUI["MC_PageLeft"];
         this.FPage.ButtonNext.Substrate = this.FMainUI["MC_PageRight"];
         this.FPage.OnChangePage = this.PageOnSwitch;
         this.FPage.PageSize = Reforging_Chip_Num;
         this.FPage.LabelPage = this.FMainUI["TF_Page"];
         this.FPage.Init();
         this.FChipVec = new Vector.<TCompanionChipItem>();
         _loc4_ = 0;
         while(_loc4_ < Reforging_Chip_Num)
         {
            _loc5_ = new TCompanionChipItem(this.FMainUI["MC_Chip_" + _loc4_]);
            _loc5_.ItemOnMove = this.OnOver;
            _loc5_.ItemOnOut = this.OnOut;
            _loc5_.ItemOnDown = this.OnClick;
            this.FChipVec.push(_loc5_);
            _loc4_++;
         }
         this.FChipDatas = new Vector.<THeroCompanionChipData>();
      }
      
      protected function RenderPage() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:THeroCompanionCardData = null;
         var _loc8_:THeroCompanionChipData = null;
         this.FChipDatas.length = 0;
         _loc1_ = this.FData.ChipCount;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc6_ = this.FData.GetChipByIndex(_loc2_).LastId;
            _loc7_ = this.FData.CardDatas.GetCardByLastId(_loc6_);
            _loc8_ = this.FData.GetChipByIndex(_loc2_);
            if(_loc7_.Level >= _loc7_.Cards[_loc7_.Cards.length - 1].Level && _loc8_.Amount > 0)
            {
               this.FChipDatas.push(_loc8_);
            }
            _loc2_++;
         }
         _loc1_ = int(this.FChipDatas.length);
         this.FPage.SetupPage(_loc1_,this.FPageIndex);
         _loc3_ = this.FPageIndex * CONST_HEROCOMPANION.Reforging_Chip_Num;
         _loc4_ = Math.min(_loc3_ + CONST_HEROCOMPANION.Reforging_Chip_Num,_loc1_);
         _loc2_ = _loc3_;
         while(_loc2_ < _loc4_)
         {
            this.FChipVec[_loc5_].SetChipData(this.FChipDatas[_loc2_]);
            _loc2_++;
            _loc5_++;
         }
         _loc2_ = _loc5_;
         while(_loc2_ < CONST_HEROCOMPANION.Reforging_Chip_Num)
         {
            this.FChipVec[_loc2_].ClearData();
            _loc2_++;
         }
      }
      
      protected function OnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TCompanionChipItem = null;
         _loc3_ = param1 as TCompanionChipItem;
         this.FItemOnDown(_loc3_.Data);
      }
      
      protected function OnOver(param1:Object, param2:MouseEvent) : void
      {
         this.FItemOnOver(param1,param2);
      }
      
      protected function OnOut(param1:Object, param2:MouseEvent) : void
      {
         this.FItemOnOut(param1,param2);
      }
      
      protected function PageOnSwitch(param1:Object, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         this.FPageIndex = param2;
         _loc3_ = this.FData.ChipCount;
         this.FPage.SetupPage(_loc3_,this.FPageIndex);
         _loc5_ = this.FPageIndex * Reforging_Chip_Num;
         _loc6_ = Math.min(_loc5_ + Reforging_Chip_Num,_loc3_);
         _loc4_ = _loc5_;
         while(_loc4_ < _loc6_)
         {
            this.FChipVec[_loc7_].SetChipData(this.FData.GetChipByIndex(_loc4_));
            _loc4_++;
            _loc7_++;
         }
         _loc4_ = _loc7_;
         while(_loc4_ < Reforging_Chip_Num)
         {
            this.FChipVec[_loc4_].ClearData();
            _loc4_++;
         }
      }
      
      public function get ItemOnOver() : Function
      {
         return this.FItemOnOver;
      }
      
      public function set ItemOnOver(param1:Function) : void
      {
         this.FItemOnOver = param1;
      }
      
      public function get ItemOnOut() : Function
      {
         return this.FItemOnOut;
      }
      
      public function set ItemOnOut(param1:Function) : void
      {
         this.FItemOnOut = param1;
      }
      
      public function get ItemOnDown() : Function
      {
         return this.FItemOnDown;
      }
      
      public function set ItemOnDown(param1:Function) : void
      {
         this.FItemOnDown = param1;
      }
      
      public function get ChipDatas() : Vector.<THeroCompanionChipData>
      {
         return this.FChipDatas;
      }
      
      public function get ChipVec() : Vector.<TCompanionChipItem>
      {
         return this.FChipVec;
      }
      
      public function SetData(param1:THeroCompanionData) : void
      {
         this.FData = param1;
         this.RenderPage();
      }
   }
}

