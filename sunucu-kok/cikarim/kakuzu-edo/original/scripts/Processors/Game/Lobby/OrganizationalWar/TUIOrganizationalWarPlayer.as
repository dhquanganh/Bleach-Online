package Processors.Game.Lobby.OrganizationalWar
{
   import Foundation.Common.Stubs.TStubReferences;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.TBaseHero;
   import Logics.OrganizationalWar.TOraganizationalInfor;
   import Logics.OrganizationalWar.TOrganizationRole;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.display.MovieClip;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class TUIOrganizationalWarPlayer extends TUIComponent
   {
      
      public static const PLAYERSTATE_BORN:int = 1;
      
      public static const PLAYERSTATE_LEAVE:int = 2;
      
      public static const PLAYERSTATE_DEATH:int = 3;
      
      public static const PLAYERSTATE_MOVE:int = 4;
      
      public static const PLAYERSTATE_OVER:int = 5;
      
      public static const Direction_Up:String = "up";
      
      public static const Direction_Down:String = "down";
      
      protected static const NameFilters:Array = [new GlowFilter(0,1,2,2,12,1,false,false)];
      
      protected var FStubReferences:TStubReferences;
      
      protected var FRoleData:TOrganizationRole;
      
      protected var FState:int;
      
      protected var FExistPool:Object;
      
      protected var FTextFiledNameFormat:TextFormat;
      
      protected var FTextFiledName:TextField;
      
      protected var FMC_BloodUI:MovieClip;
      
      protected var FMC_Blood:MovieClip;
      
      protected var FMC_Avatar:MovieClip;
      
      protected var FDirection:String;
      
      protected var FOrganizationalInfor:TOraganizationalInfor;
      
      public function TUIOrganizationalWarPlayer(param1:TUIComponent)
      {
         super(param1);
         this.FTextFiledNameFormat = new TextFormat();
         this.FTextFiledName = new TextField();
         this.FTextFiledName.autoSize = TextFieldAutoSize.CENTER;
         this.FTextFiledName.filters = NameFilters;
         this.FTextFiledName.selectable = false;
         addChild(this.FTextFiledName);
         this.FStubReferences = new TStubReferences(this);
      }
      
      protected function InitAvatar() : void
      {
         var _loc1_:TBaseHero = null;
         this.FMC_BloodUI = TUtilityReflection.CreateDisplayObjectInstance("hp_bar") as MovieClip;
         this.FMC_Blood = this.FMC_BloodUI["BloodShow"];
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,this.FRoleData.TempleteID) as TBaseHero;
         this.FMC_Avatar = TUtilityReflection.CreateDisplayObjectInstance(_loc1_.Profession + "_" + _loc1_.Sex + "_" + this.FDirection) as MovieClip;
         this.FMC_BloodUI.y = -(this.FMC_BloodUI.height + this.FMC_Avatar.height);
         this.FMC_BloodUI.x = -(this.FMC_BloodUI.width / 2);
         addChild(this.FMC_Avatar);
         addChild(this.FMC_BloodUI);
      }
      
      protected function InitRoleName() : void
      {
         this.FTextFiledNameFormat.font = "宋体";
         this.FTextFiledName.setTextFormat(this.FTextFiledNameFormat);
         this.FTextFiledName.text = this.FRoleData.Name + " Lv." + this.FRoleData.RoleLevel;
         this.FTextFiledName.y = this.FMC_BloodUI.y - this.FTextFiledName.height;
         this.FTextFiledName.x = -this.FTextFiledName.width / 2;
      }
      
      public function UpdateData() : void
      {
      }
      
      public function UpdateView() : void
      {
      }
      
      public function get RoleData() : TOrganizationRole
      {
         return this.FRoleData;
      }
      
      public function set RoleData(param1:TOrganizationRole) : void
      {
         this.FRoleData = param1;
      }
      
      public function get ExistPool() : Object
      {
         return this.FExistPool;
      }
      
      public function set ExistPool(param1:Object) : void
      {
         this.FExistPool = param1;
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function set StubReferences(param1:TStubReferences) : void
      {
         this.FStubReferences = param1;
      }
      
      public function get Direction() : String
      {
         return this.FDirection;
      }
      
      public function set Direction(param1:String) : void
      {
         this.FDirection = param1;
      }
      
      public function get OrganizationalInfor() : TOraganizationalInfor
      {
         return this.FOrganizationalInfor;
      }
      
      public function set OrganizationalInfor(param1:TOraganizationalInfor) : void
      {
         this.FOrganizationalInfor = param1;
      }
      
      public function ChangeColor(param1:uint) : void
      {
         this.FTextFiledName.textColor = param1;
      }
      
      public function UpdateBooldRate() : void
      {
         this.FMC_Blood.scaleX = this.FRoleData.BloodRate / 100;
      }
      
      public function Init() : void
      {
         this.InitAvatar();
         this.InitRoleName();
      }
      
      public function StartMove() : void
      {
         this.FMC_Avatar.play();
      }
      
      public function StopMove() : void
      {
         this.FMC_Avatar.stop();
      }
      
      public function Release() : void
      {
      }
   }
}

