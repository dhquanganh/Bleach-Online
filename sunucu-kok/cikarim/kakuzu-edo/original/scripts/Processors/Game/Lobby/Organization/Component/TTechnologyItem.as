package Processors.Game.Lobby.Organization.Component
{
   import Components.Standard.TUIButton;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Organization.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TTechnologyItem extends TUIComponent
   {
      
      protected static const PHYS_ATK_ADDITION:int = CONST_ORGANIZATION.PHYS_ATK_ADDITION;
      
      protected static const PHYS_DEF_ADDITION:int = CONST_ORGANIZATION.PHYS_DEF_ADDITION;
      
      protected static const MAG_DEF_ADDITION:int = CONST_ORGANIZATION.MAG_DEF_ADDITION;
      
      protected static const LIFE_ADDITION:int = CONST_ORGANIZATION.LIFE_ADDITION;
      
      protected static const SPEED_ADDITION:int = CONST_ORGANIZATION.SPEED_ADDITION;
      
      protected var FInitialization:Boolean;
      
      protected var FIsVisible:Boolean;
      
      protected var FSkillIndex:uint;
      
      protected var FSkillLevel:uint;
      
      protected var FMC_Scene:MovieClip;
      
      protected var FMC_SkillIcon:MovieClip;
      
      protected var FBtn_Learn:TUIButton;
      
      protected var FTF_Name:TextField;
      
      protected var FTF_Condition:TextField;
      
      protected var FTF_Cost:TextField;
      
      protected var FSkillName:Vector.<String>;
      
      protected var FOnLearnSkillClick:Function;
      
      protected var FOnTipMove:Function;
      
      protected var FOnTipOut:Function;
      
      public function TTechnologyItem(param1:TUIComponent)
      {
         super(param1);
         this.FInitialization = false;
      }
      
      protected function Resources_UIDispatch(param1:MovieClip) : void
      {
         this.FMC_Scene = param1;
         this.FBtn_Learn = new TUIButton();
         this.FBtn_Learn.Substrate = this.FMC_Scene[CONST_ORGANIZATION.RESOURCE_Link_Btn_Learn];
         this.FBtn_Learn.OnClick = this.LearnSkillClick;
         this.FMC_SkillIcon = this.FMC_Scene[CONST_ORGANIZATION.RESOURCE_Link_MC_SkillIcon];
         this.FMC_SkillIcon.addEventListener(MouseEvent.MOUSE_MOVE,this.OnIconMove);
         this.FMC_SkillIcon.addEventListener(MouseEvent.MOUSE_OUT,this.OnIconOut);
         this.FTF_Name = this.FMC_Scene[CONST_ORGANIZATION.RESOURCE_Link_TF_Name];
         this.FTF_Condition = this.FMC_Scene[CONST_ORGANIZATION.RESOURCE_Link_TF_Condition];
         this.FTF_Cost = this.FMC_Scene[CONST_ORGANIZATION.RESOURCE_Link_TF_Cost];
         this.FSkillName = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_05);
      }
      
      private function LearnSkillClick(param1:Object, param2:MouseEvent) : void
      {
         if(Boolean(param2.currentTarget) && !param2.currentTarget.buttonMode)
         {
            return;
         }
         if(this.FOnLearnSkillClick != null)
         {
            this.FOnLearnSkillClick(this,this.FSkillIndex);
         }
      }
      
      protected function OnIconMove(param1:MouseEvent) : void
      {
         if(this.FOnTipMove != null)
         {
            this.FOnTipMove(this);
         }
      }
      
      protected function OnIconOut(param1:MouseEvent) : void
      {
         if(this.FOnTipOut != null)
         {
            this.FOnTipOut(this);
         }
      }
      
      public function get IsVisible() : Boolean
      {
         return this.FIsVisible;
      }
      
      public function set IsVisible(param1:Boolean) : void
      {
         this.FIsVisible = param1;
         this.FMC_Scene.visible = this.FIsVisible;
      }
      
      public function get SkillIndex() : uint
      {
         return this.FSkillIndex;
      }
      
      public function set SkillIndex(param1:uint) : void
      {
         this.FSkillIndex = param1;
      }
      
      public function get SkillLevel() : uint
      {
         return this.FSkillLevel;
      }
      
      public function set SkillLevel(param1:uint) : void
      {
         this.FSkillLevel = param1;
      }
      
      public function get OnLearnSkillClick() : Function
      {
         return this.FOnLearnSkillClick;
      }
      
      public function set OnLearnSkillClick(param1:Function) : void
      {
         this.FOnLearnSkillClick = param1;
      }
      
      public function get OnTipMove() : Function
      {
         return this.FOnTipMove;
      }
      
      public function set OnTipMove(param1:Function) : void
      {
         this.FOnTipMove = param1;
      }
      
      public function get OnTipOut() : Function
      {
         return this.FOnTipOut;
      }
      
      public function set OnTipOut(param1:Function) : void
      {
         this.FOnTipOut = param1;
      }
      
      public function Perform_UIDispatch(param1:MovieClip) : void
      {
         this.Resources_UIDispatch(param1);
         this.FInitialization = true;
      }
      
      public function UpdateSkillInfo(param1:Object, param2:TBaseOrganization) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = param2.OrgLevel;
         this.FSkillLevel = param1.level;
         this.FTF_Name.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_06),param1.level) + this.FSkillName[param1.type - 1];
         this.FTF_Cost.text = this.GetSkillConsume(param1).toString();
         this.FMC_SkillIcon.gotoAndStop(param1.type.toString());
         var _loc4_:TBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_OrganizationAddition);
         if(param1.level >= _loc4_.Count - 1)
         {
            this.FTF_Condition.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_03);
            this.FBtn_Learn.Visible = false;
         }
         else if(param1.level < _loc3_)
         {
            this.FTF_Condition.text = "";
            this.FBtn_Learn.Visible = true;
            if(this.GetSkillConsume(param1) <= (param2 != null ? param2.OrgExploit : 0))
            {
               this.FTF_Cost.textColor = CONST_COMMON.TEXT_White_Color;
               this.FBtn_Learn.Enabled = true;
            }
            else
            {
               this.FTF_Cost.textColor = CONST_COMMON.TEXT_Red_Color;
               this.FBtn_Learn.Enabled = false;
            }
         }
         else
         {
            this.FTF_Condition.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_02),param1.level + 1);
            this.FBtn_Learn.Visible = false;
         }
      }
      
      public function GetSkillConsume(param1:Object) : int
      {
         var _loc4_:int = 0;
         var _loc2_:TBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_OrganizationAddition);
         var _loc3_:TOrganizationAddition = _loc2_.GetDatebaseByIdentifier(CONST_ORGANIZATION.Organization_Addition_Base + (param1.level + 1)) as TOrganizationAddition;
         if(_loc3_ == null)
         {
            return 0;
         }
         switch(param1.type)
         {
            case PHYS_ATK_ADDITION:
               _loc4_ = int(_loc3_.AtkConsume);
               break;
            case PHYS_DEF_ADDITION:
               _loc4_ = int(_loc3_.PhysDefConsume);
               break;
            case MAG_DEF_ADDITION:
               _loc4_ = int(_loc3_.MagDefConsume);
               break;
            case LIFE_ADDITION:
               _loc4_ = int(_loc3_.LifeConsume);
               break;
            case SPEED_ADDITION:
               _loc4_ = int(_loc3_.SpeedConsume);
         }
         return _loc4_;
      }
   }
}

