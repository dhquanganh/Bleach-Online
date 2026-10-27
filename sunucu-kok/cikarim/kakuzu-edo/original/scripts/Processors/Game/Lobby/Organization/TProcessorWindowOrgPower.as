package Processors.Game.Lobby.Organization
{
   import Components.Standard.TUIButton;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowOrgPower extends TProcessorLobbyWindow
   {
      
      protected static const MAX_POWERLIST_COUNT:uint = 6;
      
      protected var FMC:Sprite;
      
      protected var FMC_SelectElement:MovieClip;
      
      protected var FTF_PowerList:TextField;
      
      protected var FTF_Prompt:TextField;
      
      protected var FBtn_Ok:SimpleButton;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FBtn_Master:TUIButton;
      
      protected var FBtn_Pendragon:TUIButton;
      
      protected var FBtn_Member:TUIButton;
      
      protected var FPowerListVect:Vector.<TextField>;
      
      protected var FOrg_Powerman:Object;
      
      protected var FOrg_Power:Vector.<String>;
      
      protected var FOrg_PowerAssign:Array = [[0,0,0,0,0,1],[0,1,1,0,0,1],[1,1,1,1,1,1]];
      
      public function TProcessorWindowOrgPower(param1:TUIComponent)
      {
         super(param1);
         this.FPowerListVect = new Vector.<TextField>();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ORGANIZATION.RESOURCESID_Swf_OrganizationMain);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TextField = null;
         this.FMC = TUtilityReflection.CreateDisplayObjectInstance(CONST_ORGANIZATION.RESOURCE_ClassName_MC_OrgPower) as Sprite;
         addChild(this.FMC);
         this.FMC_SelectElement = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_MC_SelectElement];
         this.FMC_SelectElement.play();
         this.FTF_Prompt = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_TF_Prompt];
         this.FBtn_Ok = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_Btn_Ok];
         this.FBtn_Close = this.FMC[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtn_Master = new TUIButton();
         this.FBtn_Master.Substrate = this.FMC["Btn_Master"];
         this.FBtn_Master.OnClick = this.OnClickMasterPower;
         this.FBtn_Pendragon = new TUIButton();
         this.FBtn_Pendragon.Substrate = this.FMC["Btn_Pendragon"];
         this.FBtn_Pendragon.OnClick = this.OnClickPendragonPower;
         this.FBtn_Member = new TUIButton();
         this.FBtn_Member.Substrate = this.FMC["Btn_Member"];
         this.FBtn_Member.OnClick = this.OnClickMemberPower;
         this.FOrg_Power = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_64);
         _loc1_ = 0;
         while(_loc1_ < MAX_POWERLIST_COUNT)
         {
            _loc3_ = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_TF_PowerList + _loc1_];
            _loc3_.text = "";
            this.FPowerListVect[_loc1_] = _loc3_;
            _loc1_++;
         }
         this.UpdateUI(2);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FBtn_Ok.addEventListener(MouseEvent.CLICK,OnClose);
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,OnClose);
         super.ResourcesPerform_UILocations();
      }
      
      protected function UpdateUI(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         _loc5_ = new Array();
         _loc4_ = this.FOrg_PowerAssign[param1];
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(_loc4_[_loc2_] == 1)
            {
               _loc5_.push(_loc2_);
            }
            _loc2_++;
         }
         _loc3_ = int(_loc5_.length);
         _loc2_ = 0;
         while(_loc2_ < MAX_POWERLIST_COUNT)
         {
            if(_loc2_ < _loc3_)
            {
               this.FPowerListVect[_loc2_].text = this.FOrg_Power[_loc5_[_loc2_]];
            }
            else
            {
               this.FPowerListVect[_loc2_].text = "";
            }
            _loc2_++;
         }
      }
      
      protected function OnClickMasterPower(param1:Object, param2:MouseEvent) : void
      {
         this.UpdateUI(2);
         this.FMC_SelectElement.y = param2.currentTarget.y - 10;
      }
      
      protected function OnClickPendragonPower(param1:Object, param2:MouseEvent) : void
      {
         this.UpdateUI(1);
         this.FMC_SelectElement.y = param2.currentTarget.y - 10;
      }
      
      protected function OnClickMemberPower(param1:Object, param2:MouseEvent) : void
      {
         this.UpdateUI(0);
         this.FMC_SelectElement.y = param2.currentTarget.y - 10;
      }
   }
}

