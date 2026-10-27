package Processors.Game.Lobby.Organization.Component
{
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.text.*;
   
   public class TUIOrgLogElement extends TUIComponent
   {
      
      protected var FMC:Sprite;
      
      protected var FTF_Log:TextField;
      
      protected var FTF_Time:TextField;
      
      protected var FData_Log:Object;
      
      protected var FIndex:uint;
      
      protected var FIsInitialization:Boolean;
      
      protected var FVerbTypeVect:Vector.<String>;
      
      protected var FFormatTimeVect:Vector.<String>;
      
      public function TUIOrgLogElement(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function Resources_UIDispatch() : void
      {
         this.FMC = TUtilityReflection.CreateDisplayObjectInstance("MC_OrgLogLi") as Sprite;
         addChild(this.FMC);
         this.FTF_Log = this.FMC["TF_Log"];
         this.FTF_Time = this.FMC["TF_Time"];
         this.FVerbTypeVect = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_61);
         this.FFormatTimeVect = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_62);
      }
      
      protected function UpdateUI() : void
      {
         if(this.FData_Log != null)
         {
            if(int(this.FData_Log.short) == 0)
            {
               this.FTF_Log.text = String(this.FData_Log.subject + this.FVerbTypeVect[this.FData_Log.verbType] + this.FData_Log.object);
            }
            else
            {
               this.FTF_Log.text = String(this.FData_Log.subject + this.FVerbTypeVect[this.FData_Log.verbType] + "*" + this.FData_Log.short + this.FData_Log.object);
            }
            this.FTF_Time.text = this.FormatTime();
         }
         else
         {
            this.FTF_Log.text = "";
            this.FTF_Time.text = "";
         }
      }
      
      protected function FormatTime() : String
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:String = null;
         _loc3_ = "";
         _loc2_ = uint(STimingCore.ServerTick);
         _loc1_ = Math.floor((_loc2_ - this.FData_Log.time) / 3600);
         if(_loc1_ < 1)
         {
            _loc1_ = Math.floor(_loc1_ / 60);
            if(_loc1_ < 1)
            {
               _loc1_ = 0;
            }
            _loc3_ = _loc1_ + this.FFormatTimeVect[0];
         }
         else if(_loc1_ >= 1 && _loc1_ < 24)
         {
            _loc3_ = _loc1_ + this.FFormatTimeVect[1];
         }
         else if(_loc1_ >= 24 && _loc1_ < 72)
         {
            _loc3_ = this.FFormatTimeVect[2];
         }
         else if(_loc1_ >= 72 && _loc1_ < 168)
         {
            _loc3_ = this.FFormatTimeVect[3];
         }
         else
         {
            _loc3_ = this.FFormatTimeVect[4];
         }
         return _loc3_;
      }
      
      public function Perform_UIDispatch(param1:uint) : void
      {
         this.Resources_UIDispatch();
         this.FIndex = param1;
         this.FIsInitialization = true;
      }
      
      public function UpData(param1:Object) : void
      {
         this.FData_Log = param1;
      }
      
      public function UpDateUI() : void
      {
         this.UpdateUI();
      }
   }
}

