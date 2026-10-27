package Processors.Game.Lobby.RelatedPartner
{
   import Foundation.Common.TBounds;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.Characters.THero;
   import Logics.RelatedPartner.TRelatedPartnerHeros;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Processors.Game.Lobby.RelatedPartner.RelatedAssistance.TWindowAssistanceList;
   import Processors.Game.Lobby.TacticalDeployment.Components.TDeploymentTip;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import Resources.Constants.CONST_RELATEDPARTNER;
   import flash.display.Bitmap;
   import flash.utils.ByteArray;
   
   public class TProcessorRelatedAssistance extends TProcessorLobbyWindows
   {
      
      protected static const AssistanceWindow_Width:int = 684;
      
      protected static const AssistanceWindow_Height:int = 445;
      
      protected static const AssistanceList_Width:int = 386;
      
      protected static const AssistanceList_Height:int = 398;
      
      protected var FProcessorWindowAssistance:TProcessorWindowRelatedAssistance;
      
      protected var FWindowList:TWindowAssistanceList;
      
      protected var FAssistanceBounds:TBounds;
      
      protected var FListBountds:TBounds;
      
      protected var FBackGround:Bitmap;
      
      protected var FHeroDatas:TRelatedPartnerHeros;
      
      protected var FHeroInfoTip:TDeploymentTip;
      
      public function TProcessorRelatedAssistance(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FProcessorWindowAssistance = new TProcessorWindowRelatedAssistance(this);
         this.FProcessorWindowAssistance.OnAssistanceList = this.OnAssistanceList;
         this.FProcessorWindowAssistance.OnClose = this.OnAssistanceClose;
         this.FProcessorWindowAssistance.OnItemOver = this.OnItemOver;
         this.FProcessorWindowAssistance.OnItemOut = this.OnItemOut;
         this.FAssistanceBounds = new TBounds();
         this.FAssistanceBounds.Width = AssistanceWindow_Width;
         this.FAssistanceBounds.Height = AssistanceWindow_Height;
         ComponentBoundsCenter(this.FProcessorWindowAssistance,this.FAssistanceBounds);
         this.FWindowList = new TWindowAssistanceList(FParent);
         this.FWindowList.Visible = false;
         this.FWindowList.OnItemOver = this.OnItemOver;
         this.FWindowList.OnItemOut = this.OnItemOut;
         this.FListBountds = new TBounds();
         this.FListBountds.Width = AssistanceList_Width;
         this.FListBountds.Height = AssistanceList_Height;
         ComponentBoundsCenter(this.FWindowList,this.FListBountds);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_RELATEDPARTNER.RESOURCESID_Swf_Assistance);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
         this.FBackGround = new Bitmap();
         this.FBackGround.bitmapData = SUtilityResource.BtmDataFullScreen;
         this.FBackGround.alpha = 0.3;
         this.FBackGround.x = -this.FProcessorWindowAssistance.X;
         this.FBackGround.y = -this.FProcessorWindowAssistance.Y;
         this.FProcessorWindowAssistance.addChildAt(this.FBackGround,0);
         this.FHeroInfoTip = new TDeploymentTip(FParent);
         this.FHeroInfoTip.Visible = false;
      }
      
      override protected function PacketRegisterRoutines() : void
      {
      }
      
      protected function ShowHeroInfoTip(param1:Object, param2:THero) : void
      {
         this.FHeroInfoTip.Visible = true;
         this.FHeroInfoTip.SetHeroData(param2);
      }
      
      protected function HideHeroInfoTip(param1:Object) : void
      {
         this.FHeroInfoTip.Visible = false;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FHeroInfoTip != null && this.FHeroInfoTip.visible == true)
         {
            this.FHeroInfoTip.UpdataBitmap();
         }
      }
      
      protected function OnItemOver(param1:Object, param2:THero) : void
      {
         this.ShowHeroInfoTip(param1,param2);
      }
      
      protected function OnItemOut(param1:Object) : void
      {
         this.HideHeroInfoTip(param1);
      }
      
      protected function OnAssistanceList(param1:int) : void
      {
         this.FWindowList.Show(param1);
      }
      
      protected function OnAssistanceDismount(param1:int) : void
      {
         this.FWindowList.Show(param1);
      }
      
      protected function OnAssistanceClose(param1:Object) : void
      {
         if(this.FWindowList.Visible)
         {
            this.FWindowList.Close();
         }
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowAssistance.Load();
            this.FWindowList.Load();
         }
         else if(TRelatedPartnerCommon.SkillInfoReq())
         {
            this.SetHeroData();
         }
      }
      
      public function SetHeroData() : void
      {
         if(TRelatedPartnerCommon.HeroDatas == null)
         {
            return;
         }
         this.FHeroDatas = TRelatedPartnerCommon.HeroDatas;
         if(!this.FHeroDatas.IsInit)
         {
            return;
         }
         if(Visible)
         {
            this.FProcessorWindowAssistance.Render(this.FHeroDatas);
            this.FProcessorWindowAssistance.Visible = true;
         }
      }
      
      public function UpdateAssistanceIcon(param1:int, param2:int) : void
      {
         this.FProcessorWindowAssistance.Update(param1,param2);
      }
      
      public function SetCenter(param1:Boolean) : void
      {
         if(param1)
         {
            ComponentBoundsCenter(this.FProcessorWindowAssistance,this.FAssistanceBounds);
            this.FBackGround.visible = true;
         }
         else
         {
            this.FProcessorWindowAssistance.X = 0;
            this.FProcessorWindowAssistance.Y = 0;
            this.FBackGround.visible = false;
         }
      }
   }
}

