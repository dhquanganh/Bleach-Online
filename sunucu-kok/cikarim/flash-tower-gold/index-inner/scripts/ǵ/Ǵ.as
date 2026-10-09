package ǵ
{
   import Logics.Agent.SParametersCore;
   import flash.events.ContextMenuEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.Capabilities;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   
   public class Ǵ
   {
      
      protected static var Ȟ:String = "联系客服MM";
      
      protected static var ȟ:String = "死神狂潮(%0)";
      
      protected static var Ƞ:String = "※复制调试信息※";
      
      protected var ȏ:ContextMenu;
      
      protected var Ȑ:ContextMenuItem;
      
      protected var ȑ:ContextMenuItem;
      
      protected var Ȓ:ContextMenuItem;
      
      protected var ȓ:ContextMenuItem;
      
      protected var Ȕ:ContextMenuItem;
      
      protected var FSupportUrl:String;
      
      protected var FOfficeUrl:String;
      
      protected var ȕ:Boolean;
      
      protected var Ȗ:Function;
      
      public function Ǵ()
      {
         super();
         this.ȏ = new ContextMenu();
         this.ȏ.hideBuiltInItems();
         this.FSupportUrl = SParametersCore.SupportUrl;
         this.FOfficeUrl = SParametersCore.OfficeUrl;
         this.ȗ();
      }
      
      protected function ȗ() : void
      {
         var _loc1_:String = null;
         _loc1_ = "Version: " + SParametersCore.ClientVersion.toString();
         this.ȑ = new ContextMenuItem(_loc1_,true,false);
         this.ȏ.customItems.push(this.ȑ);
         _loc1_ = "FlashPlayer Version: " + Capabilities.version;
         if(Capabilities.isDebugger)
         {
            _loc1_ += "(Debug)";
         }
         this.Ȓ = new ContextMenuItem(_loc1_,true,false);
         this.ȏ.customItems.push(this.Ȓ);
         this.ȕ = SParametersCore.IsDebug;
         if(this.ȕ)
         {
            this.Ȕ = new ContextMenuItem(Ƞ);
            this.ȏ.customItems.push(this.Ȕ);
            this.Ȕ.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.ș);
         }
      }
      
      protected function Ș(param1:ContextMenuEvent) : void
      {
         this.ț(this.FOfficeUrl);
      }
      
      protected function ș(param1:ContextMenuEvent) : void
      {
         if(this.Ȗ != null)
         {
            this.Ȗ(this);
         }
      }
      
      protected function Ț(param1:ContextMenuEvent) : void
      {
         this.ț(this.FSupportUrl);
      }
      
      protected function ț(param1:String) : void
      {
         var _loc2_:URLRequest = null;
         _loc2_ = new URLRequest(param1);
         navigateToURL(_loc2_,"_blank");
      }
      
      public function get Ȝ() : ContextMenu
      {
         return this.ȏ;
      }
      
      public function get ȝ() : Function
      {
         return this.Ȗ;
      }
      
      public function set ȝ(param1:Function) : void
      {
         this.Ȗ = param1;
      }
      
      public function Dispose() : void
      {
         this.ȏ.customItems.length = 0;
         this.ȏ = null;
      }
   }
}

