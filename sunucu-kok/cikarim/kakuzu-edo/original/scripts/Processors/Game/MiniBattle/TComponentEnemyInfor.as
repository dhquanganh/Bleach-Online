package Processors.Game.MiniBattle
{
   import Foundation.Resources.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.MiniBattle.Mode.*;
   import Resources.Constants.*;
   import flash.display.*;
   
   public class TComponentEnemyInfor extends TProcessorLobbyWindow
   {
      
      protected static const EnemyNum:int = 6;
      
      protected var FUIBoard:Sprite;
      
      protected var FInforSlots:Vector.<Sprite>;
      
      protected var FLoseFlag:Vector.<Sprite>;
      
      protected var FBattingFlag:Vector.<Sprite>;
      
      protected var FEnemyArmyID:Vector.<uint>;
      
      protected var FPicMountPoint:Vector.<Bitmap>;
      
      protected var FLeaderID:Vector.<uint>;
      
      protected var FLeaderHeadID:Vector.<uint>;
      
      public function TComponentEnemyInfor(param1:TUIComponent)
      {
         super(param1);
      }
      
      public function LoadResource_Perform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:Bitmap = null;
         this.FUIBoard = TUtilityReflection.CreateDisplayObjectInstance("MiniSoliderInfor") as Sprite;
         addChild(this.FUIBoard);
         this.FInforSlots = new Vector.<Sprite>();
         this.FLoseFlag = new Vector.<Sprite>();
         this.FBattingFlag = new Vector.<Sprite>();
         this.FEnemyArmyID = new Vector.<uint>();
         this.FLeaderID = new Vector.<uint>();
         this.FLeaderHeadID = new Vector.<uint>();
         this.FPicMountPoint = new Vector.<Bitmap>();
         _loc1_ = 0;
         while(_loc1_ < EnemyNum)
         {
            _loc2_ = this.FUIBoard["Slot" + _loc1_];
            this.FInforSlots.push(_loc2_);
            this.FLoseFlag.push(_loc2_["LoseFlag"]);
            this.FBattingFlag.push(_loc2_["BattingFlag"]);
            _loc3_ = new Bitmap();
            _loc2_["MountPoint"].addChild(_loc3_);
            this.FPicMountPoint.push(_loc3_);
            _loc1_++;
         }
         this.AdjustBoardPosition();
      }
      
      protected function CallBack_HeadPicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc5_ = int(this.FLeaderHeadID.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(param3 == this.FLeaderHeadID[_loc4_])
            {
               this.FPicMountPoint[_loc4_].bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
            }
            _loc4_++;
         }
      }
      
      protected function AdjustBoardPosition() : void
      {
         if(this.FUIBoard == null)
         {
            return;
         }
         this.FUIBoard.x = CONST_COMMON.STAGE_Width - this.FUIBoard.width;
      }
      
      override public function ProcessorsResize() : void
      {
         super.ProcessorsResize();
         this.AdjustBoardPosition();
      }
      
      public function LoadResource() : void
      {
         this.LoadResource_Perform();
      }
      
      public function BattleStart(param1:TOneBattle) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FEnemyArmyID.indexOf(param1.EnemyID);
         this.FBattingFlag[_loc2_].visible = true;
      }
      
      public function BattleEnd(param1:TOneBattle) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FEnemyArmyID.indexOf(param1.EnemyID);
         if(param1.BattleResult == CONST_MINIBATTLE.BattleResult_Win)
         {
            this.FBattingFlag[_loc2_].visible = false;
            this.FLoseFlag[_loc2_].visible = true;
         }
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         this.FEnemyArmyID.length = 0;
         this.FLeaderID.length = 0;
         this.FLeaderHeadID.length = 0;
         _loc1_ = 0;
         while(_loc1_ < EnemyNum)
         {
            this.FPicMountPoint[_loc1_].bitmapData = null;
            this.FLoseFlag[_loc1_].visible = false;
            _loc1_++;
         }
      }
      
      public function InitEnemy(param1:uint) : void
      {
         var _loc2_:TLeaguePointPath = null;
         var _loc3_:TEnemyArmy = null;
         var _loc4_:TRoleModel = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         this.Reset();
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_LeaguePointPath,param1) as TLeaguePointPath;
         _loc6_ = int(_loc2_.ArmyID.length);
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            this.FEnemyArmyID.push(_loc2_.ArmyID[_loc5_]);
            _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_EnemyArmy,_loc2_.ArmyID[_loc5_]) as TEnemyArmy;
            this.FLeaderID.push(_loc3_.LeaderID);
            _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,_loc3_.LeaderID) as TRoleModel;
            this.FLeaderHeadID.push(_loc4_.RoleHead);
            _loc5_++;
         }
         _loc6_ = int(this.FLeaderHeadID.length);
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(this.FLeaderHeadID[_loc5_],this.CallBack_HeadPicArrive);
            this.FBattingFlag[_loc5_].visible = false;
            this.FLoseFlag[_loc5_].visible = false;
            this.FInforSlots[_loc5_].visible = true;
            _loc5_++;
         }
         while(_loc5_ < EnemyNum)
         {
            this.FInforSlots[_loc5_].visible = false;
            _loc5_++;
         }
      }
   }
}

