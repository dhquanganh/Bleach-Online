package Processors.Game.Lobby.ExpDuplicate
{
   import Foundation.UI.TUIComponent;
   import Logics.ExpDuplicate.TExpDuplicateData;
   import Logics.ExpDuplicate.VO.TDuplicateVO;
   import Logics.SLogicsCore;
   import Logics.Streamization.ExpDuplicate.TUnstreamizerExpDuplicate;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Resources.Constants.CONST_COMMON;
   import flash.display.MovieClip;
   
   public class TProcessorWindowExpDuplicate extends TProcessorLobbyWindow
   {
      
      protected var FItemsWin:TProcessorWindowExpDupItems;
      
      protected var FBattleWin:TProcessorWindowExpDupBattle;
      
      protected var FMainUI:MovieClip;
      
      protected var FData:TExpDuplicateData;
      
      protected var FSelectIndex:uint;
      
      protected var FUnstreamizer:TUnstreamizerExpDuplicate;
      
      public function TProcessorWindowExpDuplicate(param1:TUIComponent)
      {
         super(param1);
         this.FItemsWin = new TProcessorWindowExpDupItems(this);
         this.FItemsWin.Visible = true;
         this.FItemsWin.OnClose = this.WinClose;
         this.FItemsWin.ItemOnClick = this.ItemOnClick;
         this.FBattleWin = new TProcessorWindowExpDupBattle(this);
         this.FBattleWin.Visible = false;
         this.FBattleWin.OnClose = this.WinClose;
         this.FData = SLogicsCore.ExpDuplicateData;
         this.FUnstreamizer = new TUnstreamizerExpDuplicate(this.FData);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FItemsWin.UIDispatch();
         this.FBattleWin.UIDispatch();
         this.FItemsWin.X = (CONST_COMMON.STAGE_Width - this.FItemsWin.Width) / 2;
         this.FItemsWin.Y = (CONST_COMMON.STAGE_Height - this.FItemsWin.Height) / 2;
         this.FBattleWin.X = (CONST_COMMON.STAGE_Width - this.FBattleWin.Width) / 2;
         this.FBattleWin.Y = (CONST_COMMON.STAGE_Height - this.FBattleWin.Height) / 2;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UIFinalize() : void
      {
         this.FUnstreamizer.UnstreamizerConfig();
         this.FItemsWin.UIFinalize();
         super.ResourcesPerform_UIFinalize();
      }
      
      protected function WinClose(param1:Object) : void
      {
         if(param1 == this.FBattleWin)
         {
            this.FItemsWin.Visible = true;
         }
         else
         {
            ProcessorWindowClose();
         }
      }
      
      protected function ItemOnClick(param1:uint) : void
      {
         var _loc2_:TDuplicateVO = null;
         this.FSelectIndex = param1;
         _loc2_ = this.FData.EnemyArmy[param1];
         if(_loc2_.SkillBuff.length == 0)
         {
            this.FUnstreamizer.SkillReq(_loc2_);
         }
         else
         {
            this.OpenBattleWin();
         }
      }
      
      public function Update() : void
      {
         this.FItemsWin.Update();
         this.FBattleWin.Update();
      }
      
      public function OpenBattleWin() : void
      {
         this.FItemsWin.Visible = false;
         this.FBattleWin.Visible = true;
         this.FBattleWin.SetData(this.FData.EnemyArmy[this.FSelectIndex]);
      }
      
      public function set OnSetBattleStatus(param1:Function) : void
      {
         this.FBattleWin.OnSetBattleStatus = param1;
      }
   }
}

