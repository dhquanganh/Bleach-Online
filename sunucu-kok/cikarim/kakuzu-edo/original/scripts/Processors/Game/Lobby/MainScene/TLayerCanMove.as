package Processors.Game.Lobby.MainScene
{
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Logics.Affairs.TAffair;
   import Logics.Characters.MoveRole.*;
   import Logics.SLogicsCore;
   import Logics.Streamization.Characters.*;
   import Processors.*;
   import Processors.Game.Lobby.MainScene.Role.*;
   import Processors.Game.TProcessorGame;
   import Resources.Constants.*;
   import flash.utils.ByteArray;
   
   public class TLayerCanMove extends TProcessorGame
   {
      
      protected static const AFFAIRID_TimingWaitAddNewCanControlRole:uint = 1;
      
      protected static const TIME_AddNewCanControlRole:int = 100;
      
      protected static const TIME_AddNewCanControlRolePeriod:int = 250;
      
      protected var FCurrentMode:int;
      
      protected var FRolesUI:TUIRolePlayerRoles;
      
      protected var FMainRole:TUIRoleCanMovePlayerRoleMainRole;
      
      protected var FUnstreamizerRoleCanControl:TUnstreamizerRoleCanControl;
      
      protected var FRolesBackA:Vector.<TUIRoleCanMove>;
      
      protected var FRolesBackB:Vector.<TUIRoleCanMove>;
      
      protected var FRoleDatas:TRoleCanControls;
      
      protected var FTickAddNew:int;
      
      protected var FTickAddNewPeriod:int;
      
      protected var FIsFirstTime:Boolean;
      
      protected var FIsAffairAddNewRole:Boolean;
      
      protected var FNeedInitPos:Boolean;
      
      protected var FRoleClicked:Function;
      
      public function TLayerCanMove(param1:TUIComponent)
      {
         super(param1);
         this.FRolesUI = new TUIRolePlayerRoles();
         this.FUnstreamizerRoleCanControl = new TUnstreamizerRoleCanControl();
         this.FRolesBackA = new Vector.<TUIRoleCanMove>(500);
         this.FRolesBackB = new Vector.<TUIRoleCanMove>(500);
         this.FRoleDatas = new TRoleCanControls();
         this.FCurrentMode = CONST_MainScene.MODE_SHOW_OTHERROLE;
         this.FIsFirstTime = false;
         this.FIsAffairAddNewRole = false;
         this.FNeedInitPos = true;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
      }
      
      override protected function AffairRegisterRoutines() : void
      {
         super.AffairRegisterRoutines();
         FAffairRoutines.Register(AFFAIRID_TimingWaitAddNewCanControlRole,this.AffairPerform_TimingWaitAddNewCanControlRole);
      }
      
      protected function AffairPerform_TimingWaitAddNewCanControlRole(param1:TAffair) : void
      {
         var _loc2_:Boolean = false;
         _loc2_ = this.PerformAffair_TimingWaitAddNewCanControlRole(this.FRoleDatas,TIME_AddNewCanControlRole,TIME_AddNewCanControlRolePeriod);
         if(_loc2_)
         {
            param1.PostProcess = TAffair.POSTPROCESS_Pend;
         }
         else
         {
            param1.PostProcess = TAffair.POSTPROCESS_Remove;
            this.FIsAffairAddNewRole = false;
         }
      }
      
      protected function PerformAffair_TimingWaitAddNewCanControlRole(param1:TRoleCanControls, param2:int, param3:int) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:TRoleCanControl = null;
         var _loc8_:TUIRoleCanMovePlayerRole = null;
         var _loc9_:TUIRoleCanMovePet = null;
         _loc4_ = int(STimingCore.TickCount);
         _loc4_ = _loc4_ - this.FTickAddNew;
         if(_loc4_ > param2)
         {
            if(param1.Count == 0)
            {
               return false;
            }
            _loc4_ = int(STimingCore.TickCount);
            _loc4_ = _loc4_ - this.FTickAddNewPeriod;
            if(_loc4_ > param3)
            {
               _loc7_ = param1.GetRoleByIndex(0);
               _loc5_ = _loc7_.Identifier0;
               _loc6_ = _loc7_.Identifier1;
               _loc8_ = this.FRolesUI.GetRoleByIdentifier(_loc5_,_loc6_);
               if(_loc8_ == null)
               {
                  _loc8_ = SLogicsCore.PoolUIRoleCanMove.AcquireUIRoleCanMovePlayerRole(this);
                  _loc9_ = SLogicsCore.PoolUIRoleCanMove.AcquireUIRoleCanMovePet(this);
                  _loc8_.RoleData = _loc7_;
                  _loc8_.TemplateID = _loc7_.RoleTemplateID;
                  _loc8_.Assign(_loc7_);
                  _loc8_.OnClicked = this.FRoleClicked;
                  _loc8_.Pet = _loc9_;
                  _loc9_.TemplateID = _loc8_.RoleData.TextureID;
                  _loc9_.FollowRole = _loc8_;
                  this.FRolesUI.Add(_loc8_);
                  addChild(_loc8_);
                  addChild(_loc8_.Pet);
                  if(this.FCurrentMode == CONST_MainScene.MODE_SHOW_OTHERROLE)
                  {
                     _loc8_.visible = true;
                     _loc8_.Pet.visible = _loc8_.TemplateID != 0;
                  }
                  else
                  {
                     _loc8_.visible = false;
                     _loc8_.Pet.visible = false;
                  }
               }
               _loc8_.Init();
               _loc8_.Pet.Init();
               this.InitNewRole(_loc8_);
               param1.Delete(_loc7_);
               this.FTickAddNewPeriod = STimingCore.TickCount;
            }
         }
         return true;
      }
      
      protected function UpdateAllRole() : void
      {
         var _loc1_:TUIRoleCanMovePlayerRole = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         _loc3_ = this.FRolesUI.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = this.FRolesUI.GetRoleByIndex(_loc2_);
            _loc1_.UpdateData();
            _loc4_ = this.CheckIfInScreen(_loc1_);
            if(_loc4_)
            {
               _loc1_.UpdateView();
               _loc1_.visible = true;
               if(_loc1_.Pet.TemplateID != 0)
               {
                  _loc1_.Pet.visible = true;
               }
               else
               {
                  _loc1_.Pet.visible = false;
               }
            }
            else
            {
               _loc1_.visible = false;
               _loc1_.Pet.visible = false;
            }
            _loc2_++;
         }
         this.DeepSort();
      }
      
      protected function CheckIfInScreen(param1:TUIRoleCanMove) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(param1.Direction == CONST_MainScene.DIRECTION_Left)
         {
            _loc3_ = param1.MapX + param1.CurrentFrame.Pivot.X;
            _loc2_ = param1.MapX - param1.CurrentFrame.Surface.width + param1.CurrentFrame.Pivot.X;
         }
         else
         {
            _loc3_ = param1.MapX + param1.CurrentFrame.Surface.width - param1.CurrentFrame.Pivot.X;
            _loc2_ = param1.MapX - param1.CurrentFrame.Pivot.X;
         }
         if(_loc2_ > CONST_COMMON.STAGE_Width + SLogicsCore.ScreenMapX || _loc3_ < SLogicsCore.ScreenMapX)
         {
            return false;
         }
         return true;
      }
      
      protected function Merge(param1:Vector.<TUIRoleCanMove>, param2:Vector.<TUIRoleCanMove>, param3:int, param4:int, param5:int) : void
      {
         var _loc6_:* = param3;
         var _loc7_:* = param3;
         var _loc8_:int = param4;
         var _loc9_:* = int(param4 + 1);
         var _loc10_:int = param5;
         while(_loc6_ <= param5)
         {
            if(_loc7_ > _loc8_)
            {
               var _loc11_:Number;
               param2[_loc11_ = _loc6_++] = param1[_loc9_++];
            }
            else if(_loc9_ > _loc10_)
            {
               param2[_loc11_ = _loc6_++] = param1[_loc7_++];
            }
            else if(param1[_loc7_].MapY <= param1[_loc9_].MapY)
            {
               param2[_loc11_ = _loc6_++] = param1[_loc7_++];
            }
            else
            {
               param2[_loc11_ = _loc6_++] = param1[_loc9_++];
            }
         }
      }
      
      protected function MergePass(param1:Vector.<TUIRoleCanMove>, param2:Vector.<TUIRoleCanMove>, param3:int, param4:int) : void
      {
         var _loc6_:int = 0;
         var _loc5_:int = 0;
         while(_loc5_ <= param4 - 2 * param3)
         {
            this.Merge(param1,param2,_loc5_,_loc5_ + param3 - 1,_loc5_ + param3 * 2 - 1);
            _loc5_ += 2 * param3;
         }
         if(_loc5_ + param3 < param4)
         {
            this.Merge(param1,param2,_loc5_,_loc5_ + param3 - 1,param4 - 1);
         }
         else
         {
            _loc6_ = _loc5_;
            while(_loc6_ < param4)
            {
               param2[_loc6_] = param1[_loc6_];
               _loc6_++;
            }
         }
      }
      
      protected function DeepSort() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc1_:int = 1;
         _loc2_ = numChildren;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FRolesBackA[_loc3_] = this.getChildAt(_loc3_) as TUIRoleCanMove;
            _loc3_++;
         }
         while(_loc1_ < _loc2_)
         {
            this.MergePass(this.FRolesBackA,this.FRolesBackB,_loc1_,_loc2_);
            _loc1_ += _loc1_;
            this.MergePass(this.FRolesBackB,this.FRolesBackA,_loc1_,_loc2_);
            _loc1_ += _loc1_;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.setChildIndex(this.FRolesBackA[_loc3_],_loc3_);
            _loc3_++;
         }
      }
      
      public function Update() : void
      {
         if(this.FMainRole == null)
         {
            return;
         }
         if(this.FCurrentMode == CONST_MainScene.MODE_HIDE_OTHERROLE)
         {
            this.FMainRole.UpdateData();
            this.FMainRole.UpdateView();
            this.DeepSort();
            return;
         }
         this.UpdateAllRole();
      }
      
      public function set MainRole(param1:TUIRoleCanMovePlayerRoleMainRole) : void
      {
         this.FMainRole = param1;
         this.FMainRole.Pet.StubReferences.Reference(this.FMainRole);
         this.FMainRole.RoleData.StubReferences.Reference(this.FMainRole);
         this.FRolesUI.Add(param1);
         this.addChild(param1);
         this.addChild(param1.Pet);
      }
      
      public function get RoleCount() : uint
      {
         return this.FRoleDatas.Count;
      }
      
      public function get NeedInitPos() : Boolean
      {
         return this.FNeedInitPos;
      }
      
      public function set NeedInitPos(param1:Boolean) : void
      {
         this.FNeedInitPos = param1;
      }
      
      public function set RoleClicked(param1:Function) : void
      {
         this.FRoleClicked = param1;
      }
      
      public function get RolesUI() : TUIRolePlayerRoles
      {
         return this.FRolesUI;
      }
      
      public function AddNewCanControlRole(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:ByteArray = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:TRoleCanControl = null;
         _loc4_ = param1.Data;
         _loc2_ = _loc4_.readShort();
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc5_ = _loc4_.readUnsignedInt();
            _loc6_ = _loc4_.readUnsignedInt();
            _loc7_ = SLogicsCore.PoolUIRoleCanMove.AcquireRoleCanControl(_loc5_,_loc6_);
            this.FUnstreamizerRoleCanControl.Unstreamize(_loc4_,_loc7_,null);
            if(_loc7_.RoleTemplateID != 0)
            {
               if(this.FRoleDatas.GetRoleByIdentifier(_loc5_,_loc6_) == null)
               {
                  this.FRoleDatas.Add(_loc7_);
               }
            }
            _loc3_++;
         }
         if(!this.FIsAffairAddNewRole)
         {
            FAffairGenerator.Generate(AFFAIRID_TimingWaitAddNewCanControlRole);
            this.FIsAffairAddNewRole = true;
         }
         if(!this.FIsFirstTime)
         {
            this.FTickAddNew = STimingCore.TickCount;
            this.FIsFirstTime = true;
         }
      }
      
      public function InitNewRole(param1:TUIRoleCanMovePlayerRole) : void
      {
         --param1.RoleData.MapX;
         param1.Pet.MapY = param1.RoleData.MapY + 1;
         if(!this.FNeedInitPos)
         {
            param1.ChangeDirection(CONST_MainScene.DIRECTION_RIGHT);
            return;
         }
         param1.MapX = Math.random() * (600 - 150) + 150;
         param1.MapY = Math.random() * (600 - 415) + 415;
         --param1.MapX;
         param1.Pet.MapY = param1.MapY + 1;
         param1.ChangeDirection(CONST_MainScene.DIRECTION_RIGHT);
         param1.Pet.ChangeDirection(CONST_MainScene.DIRECTION_RIGHT);
         param1.StopMove();
         param1.Pet.StopMove();
      }
      
      public function PlayerAdd(param1:TRoleCanControl) : void
      {
         if(this.FRoleDatas.GetRoleByIdentifier(param1.Identifier0,param1.Identifier1) == null)
         {
            this.FRoleDatas.Add(param1);
         }
         if(!this.FIsAffairAddNewRole)
         {
            FAffairGenerator.Generate(AFFAIRID_TimingWaitAddNewCanControlRole);
            this.FIsAffairAddNewRole = true;
         }
      }
      
      public function PlayerMove(param1:uint, param2:uint, param3:uint, param4:uint) : void
      {
         var _loc5_:TUIRoleCanMove = null;
         _loc5_ = this.FRolesUI.GetRoleByIdentifier(param1,param2);
         if(_loc5_ != null)
         {
            _loc5_.SetupTargetPosition(param3,param4,CONST_MainScene.RoleMoveSpeed);
         }
      }
      
      public function PlayerRemove(param1:uint, param2:uint) : void
      {
         this.FRolesUI.DeleteRoleByIdentifier(param1,param2);
         this.FRoleDatas.DeleteRoleByIdentifier(param1,param2);
      }
      
      public function PlayerUpdate(param1:uint, param2:uint, param3:int, param4:uint) : void
      {
         var _loc5_:TUIRoleCanMovePlayerRole = null;
         var _loc6_:TRoleCanControl = null;
         var _loc7_:Boolean = false;
         _loc5_ = this.FRolesUI.GetRoleByIdentifier(param1,param2);
         _loc6_ = this.FRoleDatas.GetRoleByIdentifier(param1,param2);
         switch(param3)
         {
            case CONST_MainScene.UpdateType_ChangeShape:
               _loc7_ = param4 != 0;
               if(_loc5_ != null)
               {
                  _loc5_.ChangeHeroShape(_loc7_,param4);
               }
               else if(_loc6_ != null)
               {
                  _loc6_.ChangeShape = _loc7_;
                  _loc6_.NewShapeBaseHeroID = param4;
               }
               break;
            case CONST_MainScene.UpdateType_MountKnifeOfKillSoul:
            case CONST_MainScene.UpdateType_UnmountKnifeOfKillSoul:
               if(_loc5_ != null)
               {
                  _loc5_.ChangePet(param3,param4);
               }
               else if(_loc6_ != null)
               {
                  _loc6_.ChangeShape = _loc7_;
                  _loc6_.NewShapeBaseHeroID = param4;
               }
         }
      }
      
      public function ClearAllRole() : void
      {
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIRoleCanMovePlayerRole = null;
         _loc2_ = this.FRolesUI.Count;
         _loc1_ = int(_loc2_ - 1);
         while(_loc1_ >= 0)
         {
            _loc3_ = this.FRolesUI.GetRoleByIndex(_loc1_);
            if(_loc3_ != this.FMainRole)
            {
               this.FRolesUI.DeleteRoleByIndex(_loc1_);
            }
            _loc1_--;
         }
         this.FRoleDatas.Clear();
      }
      
      public function SwitchMode(param1:Boolean) : void
      {
         var _loc2_:TUIRoleCanMovePlayerRole = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = this.FRolesUI.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = this.FRolesUI.GetRoleByIndex(_loc3_);
            _loc2_.visible = param1;
            _loc2_.Pet.visible = param1;
            _loc3_++;
         }
         this.FMainRole.visible = true;
         this.FMainRole.Pet.visible = SLogicsCore.Character.KnifeSoul.IfFight;
         if(param1)
         {
            this.FCurrentMode = CONST_MainScene.MODE_SHOW_OTHERROLE;
         }
         else
         {
            this.FCurrentMode = CONST_MainScene.MODE_HIDE_OTHERROLE;
         }
      }
      
      public function ResetRolePosition() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FRolesUI.Count)
         {
            this.InitNewRole(this.FRolesUI.GetRoleByIndex(_loc1_));
            _loc1_++;
         }
      }
   }
}

