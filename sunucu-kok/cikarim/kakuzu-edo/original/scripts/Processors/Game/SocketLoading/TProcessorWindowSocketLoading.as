package Processors.Game.SocketLoading
{
   import Foundation.Queries.TQueryBoolean;
   import Foundation.Resources.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Affairs.*;
   import Processors.*;
   import Processors.Game.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.text.*;
   
   public class TProcessorWindowSocketLoading extends TProcessor
   {
      
      protected var FSP_SocketLoading:Sprite;
      
      protected var FSP_ProgressBigBar:Sprite;
      
      protected var FTF_ProgressText:TextField;
      
      protected var FQueryLoginStates:TQueryBoolean;
      
      protected var FOnQueryLoginStates:Function;
      
      public function TProcessorWindowSocketLoading(param1:TUIComponent)
      {
         super(param1);
         this.FQueryLoginStates = new TQueryBoolean();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfVital.LoadPrimary(CONST_LOADING.RESOURCESID_SwfVital_SocketLoading);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIWait() : void
      {
         if(!SResourcesCore.TexturesSwfVital.Loading)
         {
            FResourcesState = RESOURCESSTATE_UIDispatch;
         }
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FSP_SocketLoading = TUtilityReflection.CreateDisplayObjectInstance(CONST_LOADING.RESOURCE_ClassName_MC_ModuleLoading) as Sprite;
         addChild(this.FSP_SocketLoading);
         this.FSP_ProgressBigBar = this.FSP_SocketLoading[CONST_LOADING.RESOURCE_Link_SP_ProgressBigBar];
         this.FTF_ProgressText = this.FSP_SocketLoading[CONST_LOADING.RESOURCE_Link_TF_ProgressText];
         this.FTF_ProgressText.text = "";
         this.FSP_ProgressBigBar.visible = false;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FSP_SocketLoading.x = (CONST_COMMON.STAGE_Width - this.FSP_SocketLoading.width) / 2;
         this.FSP_SocketLoading.y = (CONST_COMMON.STAGE_Height - this.FSP_SocketLoading.height) / 2 + 10;
         super.ResourcesPerform_UILocations();
      }
      
      public function get OnQueryLoginStates() : Function
      {
         return this.FOnQueryLoginStates;
      }
      
      public function set OnQueryLoginStates(param1:Function) : void
      {
         this.FOnQueryLoginStates = param1;
      }
      
      override public function Dispose() : void
      {
         this.FQueryLoginStates = null;
         if(this.FSP_ProgressBigBar != null)
         {
            this.FSP_ProgressBigBar = null;
         }
         if(this.FTF_ProgressText != null)
         {
            this.FTF_ProgressText = null;
         }
         if(this.FSP_SocketLoading != null)
         {
            if(this.FSP_SocketLoading.parent != null)
            {
               this.FSP_SocketLoading.parent.removeChild(this.FSP_SocketLoading);
            }
            this.FSP_SocketLoading = null;
         }
      }
      
      public function ShowLoading() : void
      {
         if(this.FOnQueryLoginStates != null)
         {
            this.FQueryLoginStates.Value = false;
            this.FOnQueryLoginStates(this,this.FQueryLoginStates);
         }
         if(this.FTF_ProgressText != null)
         {
            if(TUtilityString.Empty(this.FTF_ProgressText.text))
            {
               if(this.FQueryLoginStates.Value)
               {
                  this.FTF_ProgressText.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SocketLoading);
               }
               else
               {
                  this.FTF_ProgressText.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SocketConnecting);
               }
            }
         }
         this.Visible = true;
      }
      
      public function HideLoading() : void
      {
         this.Visible = false;
      }
   }
}

