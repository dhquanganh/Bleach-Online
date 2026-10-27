package Processors.Game.Lobby.MainScene.Role
{
   import Foundation.Resources.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.TUtilityString;
   import Logics.Characters.MoveRole.*;
   import Logics.DatebaseVO.VO.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TUIRoleCanMovePlayerRole extends TUIRoleCanMove
   {
      
      protected static const MILITARY_COLOR:uint = 16435253;
      
      protected var FMilitaryName:TextField;
      
      protected var FMilitaryFormat:TextFormat;
      
      protected var FRoleData:TRoleCanControl;
      
      protected var FPet:TUIRoleCanMovePet;
      
      protected var FChangeShape:Boolean;
      
      protected var FNewShapeBaseHeroID:uint;
      
      protected var FOnClicked:Function;
      
      public function TUIRoleCanMovePlayerRole(param1:TUIComponent)
      {
         super(param1);
         this.FMilitaryName = new TextField();
         this.FMilitaryName.autoSize = TextFieldAutoSize.CENTER;
         this.FMilitaryName.selectable = false;
         this.FMilitaryFormat = new TextFormat();
         this.FMilitaryName.filters = NameFilters;
         addChild(this.FMilitaryName);
         buttonMode = true;
      }
      
      protected function InitMilitaryRank() : void
      {
         var _loc1_:TMilitary = null;
         this.FMilitaryFormat.bold = true;
         this.FMilitaryFormat.font = "宋体";
         this.FMilitaryName.setTextFormat(this.FMilitaryFormat);
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Military,this.FRoleData.MilitaryRank) as TMilitary;
         this.FMilitaryName.text = _loc1_.Name;
         this.FMilitaryName.y = FTextFiledName.y - this.FMilitaryName.height;
         this.FMilitaryName.textColor = MILITARY_COLOR;
      }
      
      protected function InitRoleName() : void
      {
         FTextFiledNameFormat.font = "宋体";
         FTextFiledName.setTextFormat(FTextFiledNameFormat);
         if(this.FRoleData.RebirthNum > 0)
         {
            FTextFiledName.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Rebirth_19),this.FRoleData.RoleName,this.FRoleData.RebirthNum);
         }
         else
         {
            FTextFiledName.text = this.FRoleData.RoleName;
         }
         FTextFiledName.y = -FTextFiledName.height;
         FTextFiledName.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[this.RoleData.Quality];
      }
      
      protected function UpdateTextFieldPosition() : void
      {
         UpdateDisplayObjectPosition(FTextFiledName);
         UpdateDisplayObjectPosition(this.FMilitaryName);
      }
      
      override protected function DoArriveTargetPosition() : void
      {
         ChangeFrameSequence(CONST_ROLE.ROLE_SEQUENCEINDEX_Showcase);
         super.DoArriveTargetPosition();
      }
      
      override protected function HandleOnMouseOver(param1:MouseEvent) : void
      {
         this.filters = FFilters;
      }
      
      override protected function HandleOnMouseOut(param1:MouseEvent) : void
      {
         this.filters = null;
      }
      
      override protected function HandleOnMouseClick(param1:MouseEvent) : void
      {
         if(this.FOnClicked != null)
         {
            this.FOnClicked(this);
         }
         param1.stopImmediatePropagation();
      }
      
      public function get RoleData() : TRoleCanControl
      {
         return this.FRoleData;
      }
      
      public function set RoleData(param1:TRoleCanControl) : void
      {
         if(param1 != null)
         {
            param1.StubReferences.Reference(this);
         }
         this.FRoleData = param1;
      }
      
      public function get Pet() : TUIRoleCanMovePet
      {
         return this.FPet;
      }
      
      public function set Pet(param1:TUIRoleCanMovePet) : void
      {
         if(param1 != null)
         {
            param1.StubReferences.Reference(this);
         }
         this.FPet = param1;
      }
      
      public function get ChangeShape() : Boolean
      {
         return this.FChangeShape;
      }
      
      public function set ChangeShape(param1:Boolean) : void
      {
         this.FChangeShape = param1;
      }
      
      public function get NewShapeBaseHeroID() : uint
      {
         return this.FNewShapeBaseHeroID;
      }
      
      public function set NewShapeBaseHeroID(param1:uint) : void
      {
         this.FNewShapeBaseHeroID = param1;
      }
      
      public function set OnClicked(param1:Function) : void
      {
         this.FOnClicked = param1;
      }
      
      public function Assign(param1:TRoleCanControl) : void
      {
         FMapX = param1.MapX;
         FMapY = param1.MapY;
         this.FNewShapeBaseHeroID = param1.NewShapeBaseHeroID;
         this.FChangeShape = param1.ChangeShape;
         this.FRoleData.RoleTemplateID = param1.RoleTemplateID;
      }
      
      override public function UpdateData() : void
      {
         super.UpdateData();
         if(this.FPet.TemplateID != 0)
         {
            this.FPet.UpdateData();
         }
      }
      
      override public function UpdateView() : void
      {
         super.UpdateView();
         this.UpdateTextFieldPosition();
         if(this.FPet.TemplateID != 0)
         {
            this.FPet.UpdateView();
         }
      }
      
      override public function ChangeDirection(param1:int) : void
      {
         super.ChangeDirection(param1);
         this.UpdateTextFieldPosition();
      }
      
      public function Init() : void
      {
         ChangeFrameSequence(CONST_ROLE.ROLE_SEQUENCEINDEX_Showcase);
         OpenRebirthEffect(this.FRoleData.RebirthNum);
         this.InitRoleName();
         this.InitMilitaryRank();
         this.UpdateTextFieldPosition();
      }
      
      override public function Release() : void
      {
         super.Release();
         parent.removeChild(this);
         this.Pet.Release();
         this.Pet = null;
         this.RoleData.StubReferences.Dereference(this);
         this.RoleData = null;
      }
      
      public function ChangeHeroShape(param1:Boolean, param2:uint) : void
      {
         var _loc3_:TRoleModel = null;
         var _loc4_:uint = 0;
         this.FChangeShape = param1;
         if(this.FChangeShape)
         {
            this.FNewShapeBaseHeroID = param2;
            _loc4_ = param2;
         }
         else
         {
            _loc4_ = this.RoleData.RoleTemplateID;
         }
         ChangeFrameSequence(CONST_ROLE.ROLE_SEQUENCEINDEX_Showcase);
      }
      
      public function ChangePet(param1:int, param2:uint) : void
      {
         var _loc3_:TKnifeExpand = null;
         switch(param1)
         {
            case CONST_MainScene.UpdateType_UnmountKnifeOfKillSoul:
               this.FPet.TemplateID = 0;
               break;
            case CONST_MainScene.UpdateType_MountKnifeOfKillSoul:
               _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_KnifeExpand,param2) as TKnifeExpand;
               FTemplateID = _loc3_.RelationID;
               this.FPet.Init();
         }
      }
   }
}

