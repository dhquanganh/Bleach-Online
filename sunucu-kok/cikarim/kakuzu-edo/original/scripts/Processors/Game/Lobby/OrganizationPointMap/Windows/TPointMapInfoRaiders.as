package Processors.Game.Lobby.OrganizationPointMap.Windows
{
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.Organization.NewFeatures.TNewOrgData;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TPointMapInfoRaiders extends TProcessorLobbyWindow
   {
      
      protected var FMainUI:MovieClip;
      
      protected var FData:TNewOrgData;
      
      protected var FTF_Info:TextField;
      
      public function TPointMapInfoRaiders(param1:TUIComponent)
      {
         super(param1);
         this.FData = SLogicsCore.NewOrgData;
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         this.Update();
      }
      
      protected function OnCloseCall(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      public function UIDispatch() : void
      {
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_PointMapInfoRaiders") as MovieClip;
         this.FTF_Info = this.FMainUI.MC_Scene.TF_Info;
         addChild(this.FMainUI);
         this.FMainUI.Btn_Close.addEventListener(MouseEvent.CLICK,this.OnCloseCall);
      }
      
      public function Update() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         if(Visible && this.FData != null)
         {
            _loc1_ = this.FData.GroupCopys.indexOf(this.FData.CurrentCopy);
            if(_loc1_ == -1)
            {
               _loc2_ = "";
            }
            else
            {
               _loc2_ = this.FData.NewOrgSystemLanguage.GetStr21(_loc1_);
            }
            this.FTF_Info.text = _loc2_;
         }
      }
   }
}

