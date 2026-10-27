package Processors.Accessories.RightMenu
{
   import Logics.Agent.SParametersCore;
   import flash.events.ContextMenuEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.Capabilities;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   
   public class TRightMenu
   {
      
      protected static var STRING_Service:String = "联系客服MM";
      
      protected static var FORMAT_Lable:String = "死神狂潮(%0)";
      
      protected static var STRING_CopyDebugInfo:String = "※复制调试信息※";
      
      protected var FContextMenu:ContextMenu;
      
      protected var FItemSupport:ContextMenuItem;
      
      protected var FItemVersion:ContextMenuItem;
      
      protected var FItemFlashVersion:ContextMenuItem;
      
      protected var FItemOffice:ContextMenuItem;
      
      protected var FItemCopyDebugInfo:ContextMenuItem;
      
      protected var FSupportUrl:String;
      
      protected var FOfficeUrl:String;
      
      protected var FIsCopyDebugInfo:Boolean;
      
      protected var FOnCopyDebugInfo:Function;
      
      public function TRightMenu()
      {
         super();
         this.FContextMenu = new ContextMenu();
         this.FContextMenu.hideBuiltInItems();
         this.FSupportUrl = SParametersCore.SupportUrl;
         this.FOfficeUrl = SParametersCore.OfficeUrl;
         this.AddCustomMenuItems();
      }
      
      protected function AddCustomMenuItems() : void
      {
         var _loc1_:String = null;
         _loc1_ = "Version: " + SParametersCore.ClientVersion.toString();
         this.FItemVersion = new ContextMenuItem(_loc1_,true,false);
         this.FContextMenu.customItems.push(this.FItemVersion);
         _loc1_ = "FlashPlayer Version: " + Capabilities.version;
         if(Capabilities.isDebugger)
         {
            _loc1_ += "(Debug)";
         }
         this.FItemFlashVersion = new ContextMenuItem(_loc1_,true,false);
         this.FContextMenu.customItems.push(this.FItemFlashVersion);
         this.FIsCopyDebugInfo = SParametersCore.IsDebug;
         if(this.FIsCopyDebugInfo)
         {
            this.FItemCopyDebugInfo = new ContextMenuItem(STRING_CopyDebugInfo);
            this.FContextMenu.customItems.push(this.FItemCopyDebugInfo);
            this.FItemCopyDebugInfo.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.CopyDebugInfoHandler);
         }
      }
      
      protected function MenuOfficeUrlHandler(param1:ContextMenuEvent) : void
      {
         this.ProcessorNavigateToURL(this.FOfficeUrl);
      }
      
      protected function CopyDebugInfoHandler(param1:ContextMenuEvent) : void
      {
         if(this.FOnCopyDebugInfo != null)
         {
            this.FOnCopyDebugInfo(this);
         }
      }
      
      protected function MenuSupportUrlHandler(param1:ContextMenuEvent) : void
      {
         this.ProcessorNavigateToURL(this.FSupportUrl);
      }
      
      protected function ProcessorNavigateToURL(param1:String) : void
      {
         var _loc2_:URLRequest = null;
         _loc2_ = new URLRequest(param1);
         navigateToURL(_loc2_,"_blank");
      }
      
      public function get MyContextMenu() : ContextMenu
      {
         return this.FContextMenu;
      }
      
      public function get OnCopyDebugInfo() : Function
      {
         return this.FOnCopyDebugInfo;
      }
      
      public function set OnCopyDebugInfo(param1:Function) : void
      {
         this.FOnCopyDebugInfo = param1;
      }
      
      public function Dispose() : void
      {
         this.FContextMenu.customItems.length = 0;
         this.FContextMenu = null;
      }
   }
}

