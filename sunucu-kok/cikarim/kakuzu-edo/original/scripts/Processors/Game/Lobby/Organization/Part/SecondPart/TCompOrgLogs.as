package Processors.Game.Lobby.Organization.Part.SecondPart
{
   import Components.ScrollBar.TScrollBar;
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Organization.Component.TUIOrgLogElement;
   import flash.display.MovieClip;
   
   public class TCompOrgLogs extends TUIComponent
   {
      
      protected var FIsInitialization:Boolean;
      
      protected var FMC:MovieClip;
      
      protected var FMC_List:MovieClip;
      
      protected var FScrollBar:TScrollBar;
      
      protected var FData_Log:Vector.<Object>;
      
      public function TCompOrgLogs(param1:TUIComponent)
      {
         super(param1);
         this.FData_Log = new Vector.<Object>();
      }
      
      protected function Resources_UIDispatch(param1:MovieClip) : void
      {
         this.FMC = param1;
         addChild(this.FMC);
         this.FMC_List = this.FMC["mc_list"];
         this.FScrollBar = new TScrollBar(this.FMC_List,310,false,0,23);
      }
      
      protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIOrgLogElement = null;
         this.FData_Log.sort(this.SortOnOrgLogList);
         this.FScrollBar.Clear();
         _loc2_ = int(this.FData_Log.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new TUIOrgLogElement(this);
            _loc3_.Perform_UIDispatch(_loc1_);
            this.FScrollBar.AddItem(_loc3_);
            _loc3_.UpData(this.FData_Log[_loc1_]);
            _loc3_.UpDateUI();
            _loc3_.y = _loc3_.Height * _loc1_ + 6 * _loc1_;
            _loc1_++;
         }
         this.FScrollBar.ScrollToUp();
         this.FScrollBar.Visible = true;
      }
      
      protected function SortOnOrgLogList(param1:Object, param2:Object) : Number
      {
         if(int(param1.time) < int(param2.time))
         {
            return 1;
         }
         if(int(param1.time) > int(param2.time))
         {
            return -1;
         }
         return 0;
      }
      
      public function Perform_UIDispatch(param1:MovieClip) : void
      {
         this.Resources_UIDispatch(param1);
         this.FIsInitialization = true;
      }
      
      public function UpData(param1:Vector.<Object>) : void
      {
         this.FData_Log = param1;
      }
      
      public function UpDateUI() : void
      {
         this.UpdateUI();
      }
   }
}

