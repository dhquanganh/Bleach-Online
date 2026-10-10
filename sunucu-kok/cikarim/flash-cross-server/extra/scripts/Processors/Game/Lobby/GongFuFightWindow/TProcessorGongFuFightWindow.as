package Processors.Game.Lobby.GongFuFightWindow
{
   import Foundation.Common.TBounds;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.GongFuFight.TGongFuFightData;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Resources.Constants.CONST_GONGFUFIGHT;
   import flash.utils.ByteArray;
   
   public class TProcessorGongFuFightWindow extends TProcessorLobbyWindows
   {
      
      protected static const APPLYWINDOW_WIDTH:int = 612;
      
      protected static const APPLYWINDOW_HEIGHT:int = 515;
      
      protected var FWindowApply:TWindowApply;
      
      protected var FBounds:TBounds;
      
      protected var FOpenViewID:int;
      
      protected var FGongFuFight:TGongFuFightData;
      
      protected var FOnOpenTokenShop:Function;
      
      protected var FOnOpenStoneShop:Function;
      
      public function TProcessorGongFuFightWindow(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FGongFuFight = SLogicsCore.GongFuFightData;
         this.FWindowApply = new TWindowApply(this);
         this.FWindowApply.OnClose = this.SubWindowClose;
         this.FBounds = new TBounds();
         this.FBounds.Width = APPLYWINDOW_WIDTH;
         this.FBounds.Height = APPLYWINDOW_HEIGHT;
         ComponentBoundsCenter(this.FWindowApply,this.FBounds);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_GONGFUFIGHT.RESOURCESID_GongFuFightWindow);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      protected function MessageNotify_Perform(param1:uint, param2:Object) : void
      {
         switch(param1)
         {
            case CONST_GONGFUFIGHT.GONGFUFIGHTMESSAGE_Apply:
               this.FWindowApply.ApplyNotify(param2);
               break;
            case CONST_GONGFUFIGHT.GONGFUFIGHTMESSAGE_RankRecord:
               this.FWindowApply.RankRecordNotify(param2);
               break;
            case CONST_GONGFUFIGHT.GONGFUFIGHTMESSAGE_PayRecord:
               this.FWindowApply.PayInforNotify(param2);
               break;
            case CONST_GONGFUFIGHT.GONGFUFIGHTMESSAGE_Pay:
               this.FWindowApply.PayInforNotify(param2);
         }
      }
      
      protected function SubWindowClose(param1:Object) : void
      {
         ProcessorClose();
      }
      
      public function set OnOpenTokenShop(param1:Function) : void
      {
         this.FOnOpenTokenShop = param1;
         this.FWindowApply.OnOpenTokenShop = param1;
      }
      
      public function set OnOpenStoneShop(param1:Function) : void
      {
         this.FOnOpenStoneShop = param1;
         this.FWindowApply.OnOpenStoneShop = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(param1 != null)
         {
            this.FOpenViewID = param1.readUnsignedInt();
         }
         if(!FIsResourcesLoadCompleted)
         {
            this.FWindowApply.Load();
            return;
         }
         this.FWindowApply.OpenView(this.FOpenViewID);
         this.FWindowApply.Visible = true;
         this.FOpenViewID = 0;
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         if(FIsResourcesLoadCompleted)
         {
            this.FWindowApply.Reset();
         }
      }
      
      public function MessageNotify(param1:uint, param2:Object) : void
      {
         this.MessageNotify_Perform(param1,param2);
      }
   }
}

