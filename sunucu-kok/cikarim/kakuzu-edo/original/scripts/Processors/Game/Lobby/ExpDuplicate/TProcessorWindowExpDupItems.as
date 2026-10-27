package Processors.Game.Lobby.ExpDuplicate
{
   import Components.Pages.TUIPage;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.ExpDuplicate.TExpDuplicateData;
   import Logics.ExpDuplicate.VO.TDuplicateVO;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TProcessorWindowExpDupItems extends TProcessorLobbyWindow
   {
      
      protected const PageItemCount:uint = 3;
      
      protected var FMainUI:MovieClip;
      
      protected var FPage:TUIPage;
      
      protected var FData:TExpDuplicateData;
      
      protected var FPageIndex:uint;
      
      protected var FItem:Vector.<TProcessorExpDupItemCom>;
      
      protected var FItemOnClick:Function;
      
      public function TProcessorWindowExpDupItems(param1:TUIComponent)
      {
         super(param1);
         this.FData = SLogicsCore.ExpDuplicateData;
         this.FPageIndex = 0;
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:TProcessorExpDupItemCom = null;
         if(this.FMainUI != null)
         {
            for each(_loc1_ in this.FItem)
            {
               _loc1_.LogicsPerform();
            }
         }
      }
      
      protected function LocalIndexToGlobal(param1:uint) : uint
      {
         return this.FPageIndex * this.PageItemCount + param1;
      }
      
      protected function UpdatePage() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TProcessorExpDupItemCom = null;
         var _loc4_:TDuplicateVO = null;
         var _loc5_:uint = 0;
         _loc5_ = this.FData.EnemyArmy.length;
         _loc1_ = 0;
         while(_loc1_ < this.PageItemCount)
         {
            _loc2_ = this.LocalIndexToGlobal(_loc1_);
            _loc3_ = this.FItem[_loc1_];
            if(_loc2_ < _loc5_)
            {
               _loc4_ = this.FData.EnemyArmy[_loc2_];
               _loc3_.Visible = true;
               _loc3_.SetData(_loc4_);
            }
            else
            {
               _loc3_.Visible = false;
            }
            _loc1_++;
         }
      }
      
      protected function PageOnSwitch(param1:Object, param2:int) : void
      {
         this.FPageIndex = param2;
         this.UpdatePage();
      }
      
      protected function OnItemClick(param1:Object) : void
      {
         this.FItemOnClick(this.LocalIndexToGlobal(this.FItem.indexOf(param1)));
      }
      
      protected function OnWinClose(param1:MouseEvent) : void
      {
         if(FOnClose != null)
         {
            FOnClose(this);
         }
      }
      
      public function set ItemOnClick(param1:Function) : void
      {
         this.FItemOnClick = param1;
      }
      
      public function UIDispatch() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TProcessorExpDupItemCom = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_ExpDuplicateMain") as MovieClip;
         addChild(this.FMainUI);
         this.FPage = new TUIPage(this);
         this.FPage.ButtonNext.Substrate = this.FMainUI.MC_PageRight;
         this.FPage.ButtonPrevious.Substrate = this.FMainUI.MC_PageLeft;
         this.FPage.LabelPage = this.FMainUI.TF_Page;
         this.FPage.PageSize = this.PageItemCount;
         this.FPage.OnChangePage = this.PageOnSwitch;
         this.FPage.Init();
         this.FPage.Update();
         this.FItem = new Vector.<TProcessorExpDupItemCom>(this.PageItemCount);
         _loc1_ = 0;
         while(_loc1_ < this.PageItemCount)
         {
            _loc2_ = new TProcessorExpDupItemCom(this);
            this.FItem[_loc1_] = _loc2_;
            _loc2_.UIDispatch(this.FMainUI["MC_Item_" + _loc1_]);
            _loc2_.ClickFun = this.OnItemClick;
            _loc1_++;
         }
         this.FMainUI.BtnClose.addEventListener(MouseEvent.CLICK,this.OnWinClose);
         this.addChild(this.FMainUI.BtnClose);
      }
      
      public function UIFinalize() : void
      {
         this.FPage.SetupPage(this.FData.EnemyArmy.length,0);
      }
      
      public function Update() : void
      {
         this.FMainUI.TF_RemainBattle.text = this.FData.RemainBattle.toString();
         this.UpdatePage();
      }
   }
}

