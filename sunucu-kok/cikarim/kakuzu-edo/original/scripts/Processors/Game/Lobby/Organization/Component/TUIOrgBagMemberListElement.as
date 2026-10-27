package Processors.Game.Lobby.Organization.Component
{
   import Foundation.UI.TUIComponent;
   import Logics.Organization.TBaseOrganizationMember;
   import Resources.Constants.CONST_ORGANIZATION;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class TUIOrgBagMemberListElement extends TUIComponent
   {
      
      protected var FTF_Name:TextField;
      
      protected var FTF_Level:TextField;
      
      protected var FTF_Contribution:TextField;
      
      protected var FIsInitialization:Boolean;
      
      protected var FData_Member:TBaseOrganizationMember;
      
      protected var FMC:MovieClip;
      
      public function TUIOrgBagMemberListElement(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function Resources_UIDispatch(param1:MovieClip) : void
      {
         this.FMC = param1;
         this.FTF_Name = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_TF_Name];
         this.FTF_Level = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_TF_Level];
         this.FTF_Contribution = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_TF_Contribution];
      }
      
      protected function UpdateUI() : void
      {
         this.FTF_Name.text = String(this.FData_Member.PlayerName);
         this.FTF_Level.text = String(this.FData_Member.PlayerLevel);
         this.FTF_Contribution.text = String(this.FData_Member.TotalContribution);
      }
      
      public function get MC() : MovieClip
      {
         return this.FMC;
      }
      
      public function Perform_UIDispatch(param1:MovieClip) : void
      {
         this.Resources_UIDispatch(param1);
         this.FIsInitialization = true;
      }
      
      public function UpData(param1:TBaseOrganizationMember) : void
      {
         this.FData_Member = param1;
      }
      
      public function UpDateUI() : void
      {
         this.UpdateUI();
      }
      
      public function ResetUI() : void
      {
         if(this.FTF_Name != null)
         {
            this.FTF_Name.text = "";
         }
         if(this.FTF_Name != null)
         {
            this.FTF_Level.text = "";
         }
         if(this.FTF_Name != null)
         {
            this.FTF_Contribution.text = "";
         }
      }
   }
}

