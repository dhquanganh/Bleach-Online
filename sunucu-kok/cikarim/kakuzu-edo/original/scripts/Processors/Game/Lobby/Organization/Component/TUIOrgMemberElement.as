package Processors.Game.Lobby.Organization.Component
{
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Organization.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TUIOrgMemberElement extends TUIComponent
   {
      
      protected var FMC:Sprite;
      
      protected var FTF_Rank:TextField;
      
      protected var FTF_Name:TextField;
      
      protected var FTF_Level:TextField;
      
      protected var FTF_Power:TextField;
      
      protected var FTF_TodayContribution:TextField;
      
      protected var FTF_TotalContribution:TextField;
      
      protected var FTF_LastLoggin:TextField;
      
      protected var FTF_DayActive:TextField;
      
      protected var FMC_Bg:MovieClip;
      
      protected var FData_Member:TBaseOrganizationMember;
      
      protected var FIsInitialization:Boolean;
      
      protected var FIndex:uint;
      
      protected var FOriginalFrame:uint;
      
      protected var FFormatTimeVect:Vector.<String>;
      
      protected var FFormatOrgPowerNameVect:Vector.<String>;
      
      protected var FClickMemberElement:Function;
      
      public function TUIOrgMemberElement(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function Resources_UIDispatch() : void
      {
         this.FMC = TUtilityReflection.CreateDisplayObjectInstance("MC_OrgMemberLi") as Sprite;
         addChild(this.FMC);
         this.FMC.mouseChildren = false;
         this.FMC.addEventListener(MouseEvent.CLICK,this.OnFmcClick);
         this.FMC.addEventListener(MouseEvent.MOUSE_OVER,this.OnFmcOver);
         this.FMC.addEventListener(MouseEvent.MOUSE_OUT,this.OnFmcOut);
         this.FTF_Rank = this.FMC["TF_Rank"];
         this.FTF_Name = this.FMC["TF_Name"];
         this.FTF_Level = this.FMC["TF_Level"];
         this.FTF_Power = this.FMC["TF_Power"];
         this.FTF_TodayContribution = this.FMC["TF_TodayContribution"];
         this.FTF_TotalContribution = this.FMC["TF_TotalContribution"];
         this.FTF_DayActive = this.FMC["TF_DayActive"];
         this.FTF_LastLoggin = this.FMC["TF_LastLoggin"];
         this.FMC_Bg = this.FMC["MC_Bg"];
         this.FFormatTimeVect = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_62);
         this.FFormatOrgPowerNameVect = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_63);
      }
      
      protected function Update() : void
      {
         var _loc1_:String = null;
         this.FTF_Rank.text = String(this.FData_Member.Rank);
         this.FTF_Name.text = String(this.FData_Member.PlayerName);
         this.FTF_Level.text = String(this.FData_Member.PlayerLevel);
         if(this.FData_Member.OrgDuties == 2)
         {
            _loc1_ = this.FFormatOrgPowerNameVect[0];
         }
         else if(this.FData_Member.OrgDuties == 1)
         {
            _loc1_ = this.FFormatOrgPowerNameVect[1];
         }
         else
         {
            _loc1_ = this.FFormatOrgPowerNameVect[2];
         }
         this.FTF_Power.text = _loc1_;
         this.FTF_TodayContribution.text = String(this.FData_Member.TodayContribution);
         this.FTF_TotalContribution.text = String(this.FData_Member.TotalContribution);
         this.FTF_LastLoggin.text = this.FormatTime();
         this.FTF_DayActive.text = String(this.FData_Member.DayActive);
      }
      
      protected function FormatTime() : String
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:String = null;
         _loc3_ = "";
         _loc2_ = uint(STimingCore.ServerTick);
         if(this.FData_Member.LastLogginTime == 0)
         {
            return this.FFormatTimeVect[5];
         }
         _loc1_ = Math.floor((_loc2_ - this.FData_Member.LastLogginTime) / 3600);
         if(_loc1_ < 1)
         {
            _loc1_ = Math.floor(_loc1_ / 60);
            if(_loc1_ < 1)
            {
               _loc1_ = 1;
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
      
      protected function OnFmcClick(param1:MouseEvent) : void
      {
         if(this.FClickMemberElement != null)
         {
            this.FClickMemberElement(this,this.FData_Member.Identifier0,this.FData_Member.Identifier1,this.FData_Member.PlayerName);
         }
      }
      
      protected function OnFmcOver(param1:MouseEvent) : void
      {
         this.FMC_Bg.gotoAndStop(3);
      }
      
      protected function OnFmcOut(param1:MouseEvent) : void
      {
         this.FMC_Bg.gotoAndStop(this.FOriginalFrame);
      }
      
      public function get ClickMemberElement() : Function
      {
         return this.FClickMemberElement;
      }
      
      public function set ClickMemberElement(param1:Function) : void
      {
         this.FClickMemberElement = param1;
      }
      
      public function Perform_UIDispatch() : void
      {
         this.Resources_UIDispatch();
         this.FIsInitialization = true;
      }
      
      public function UpData(param1:TBaseOrganizationMember, param2:uint) : void
      {
         this.FIndex = param2;
         this.FData_Member = param1;
      }
      
      public function UpDateUI() : void
      {
         this.Update();
      }
   }
}

