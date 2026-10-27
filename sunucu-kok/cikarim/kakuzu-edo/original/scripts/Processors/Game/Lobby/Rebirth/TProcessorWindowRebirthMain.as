package Processors.Game.Lobby.Rebirth
{
   import Foundation.UI.TUIComponent;
   import Logics.Rebirth.TRebirthData;
   import Logics.SLogicsCore;
   import Logics.Streamization.Rebirth.TUnstreamizerRebirth;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Resources.Constants.CONST_COMMON;
   
   public class TProcessorWindowRebirthMain extends TProcessorLobbyWindow
   {
      
      protected var FHeroRebirthWin:TProcessorWindowHeroRebirth;
      
      protected var FRebirthResetWin:TProcessorWindowRebirthReset;
      
      protected var FRebirthSelectWin:TProcessorWindowRebirthSelect;
      
      protected var FUnstreamizer:TUnstreamizerRebirth;
      
      protected var FData:TRebirthData;
      
      public function TProcessorWindowRebirthMain(param1:TUIComponent)
      {
         super(param1);
         this.FData = SLogicsCore.RebirthData;
         this.FUnstreamizer = new TUnstreamizerRebirth(this.FData);
         this.FHeroRebirthWin = new TProcessorWindowHeroRebirth(this);
         this.FHeroRebirthWin.Visible = true;
         this.FHeroRebirthWin.UIDispatchComplete = this.Layout;
         this.FHeroRebirthWin.OpenResetWin = this.OpenResetWin;
         this.FHeroRebirthWin.OpenSelectWin = this.OpenSelectWin;
         this.FHeroRebirthWin.OnClose = this.OnCloseCall;
         this.FRebirthResetWin = new TProcessorWindowRebirthReset(this);
         this.FRebirthResetWin.OpenSelectWin = this.OpenSelectWin;
         this.FRebirthResetWin.Visible = false;
         this.FRebirthSelectWin = new TProcessorWindowRebirthSelect(this);
         this.FRebirthSelectWin.Visible = false;
         this.FRebirthSelectWin.SelectHero = this.SelectHero;
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UIFinalize() : void
      {
         this.FUnstreamizer.UnstreamizerConfig();
         super.ResourcesPerform_UIFinalize();
      }
      
      protected function Layout() : void
      {
         this.FHeroRebirthWin.X = (CONST_COMMON.STAGE_Width - this.FHeroRebirthWin.Width) / 2;
         this.FHeroRebirthWin.Y = (CONST_COMMON.STAGE_Height - this.FHeroRebirthWin.Height) / 2;
      }
      
      protected function OpenResetWin() : void
      {
         this.CloseAllSubWin();
         this.FRebirthResetWin.Visible = true;
      }
      
      protected function OpenSelectWin() : void
      {
         this.CloseAllSubWin();
         this.FRebirthSelectWin.Visible = true;
      }
      
      protected function CloseAllSubWin() : void
      {
         this.FRebirthResetWin.Visible = false;
         this.FRebirthSelectWin.Visible = false;
      }
      
      protected function SelectHero() : void
      {
         this.FHeroRebirthWin.Hero = this.FRebirthSelectWin.Hero;
         this.FRebirthResetWin.Hero = this.FRebirthSelectWin.Hero;
         this.FHeroRebirthWin.UpdateUI();
         this.FRebirthResetWin.UpdateUI();
      }
      
      protected function OnCloseCall(param1:Object) : void
      {
         ProcessorWindowClose();
      }
      
      override public function Load() : void
      {
         super.Load();
         this.FHeroRebirthWin.Load();
         this.FRebirthResetWin.Load();
         this.FRebirthSelectWin.Load();
      }
      
      public function UpdateUI() : void
      {
         this.FHeroRebirthWin.UpdateUI();
         this.FRebirthResetWin.UpdateUI();
         this.FRebirthSelectWin.UpdateUI();
      }
      
      public function Reset() : void
      {
         this.FHeroRebirthWin.Hero = SLogicsCore.Character.MainHero;
         this.FRebirthResetWin.Hero = SLogicsCore.Character.MainHero;
         this.FRebirthSelectWin.Hero = SLogicsCore.Character.MainHero;
         this.FRebirthSelectWin.Reset();
      }
   }
}

