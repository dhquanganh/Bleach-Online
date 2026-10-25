package Processors.Game.Lobby.Common.Map.SceneSprite
{
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.Repositories.TResourceRepositoryTexture;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.Map.*;
   import Processors.Game.Lobby.Common.Map.SpriteMoudleContorl.*;
   import Resources.Constants.*;
   import flash.display.*;
   
   public class TSceneSpriteMoudle extends TSceneSprite
   {
      
      protected static const SIZE_FrameRatePerSecond:int = CONST_COMMON.SIZE_FrameRatePerSecond;
      
      public static const STATE_READY:int = -1;
      
      public static const STATE_LOADING:int = 0;
      
      public static const STATE_RUNING:int = 1;
      
      public static var RescourseBaseID_Main:int = 0;
      
      public static var RescourseBaseID_Hero:int = 0;
      
      public static const TextureLoader:Vector.<TResourceRepositoryTexture> = Vector.<TResourceRepositoryTexture>([SResourcesCore.TexturesModel,SResourcesCore.TexturesSkill]);
      
      protected var FCurrentState:int;
      
      protected var FTextrueID:uint;
      
      protected var FMouduleID:uint;
      
      protected var FTexture:TTexture;
      
      protected var FCurrentSequence:TAnimationSequence;
      
      protected var FCurrentFrame:TAnimationFrame;
      
      protected var FRoleBitMap:Bitmap;
      
      protected var FCurRebirthResID:int;
      
      protected var FCurrentRebirthSequence:TAnimationSequence;
      
      protected var FRoleRebirthBitMap:Bitmap;
      
      protected var FCurrentRebirthFrame:TAnimationFrame;
      
      protected var FRoleTempleteID:int;
      
      protected var FRoleActionID:int;
      
      protected var FRoleDirection:uint;
      
      protected var FSpriteMoudleContorl:ISpriteMoudleContorl;
      
      protected var FReplaceID:uint;
      
      protected var FQuery:TMoudleInfor;
      
      protected var FTick:int;
      
      protected var FOnMainMap:Boolean;
      
      protected var FUICore:TUICore;
      
      protected var FOnPlayOver:Function;
      
      public function TSceneSpriteMoudle()
      {
         super();
         this.Init();
         this.CreateSpriteMoudleContorl();
      }
      
      protected function Init() : void
      {
         this.FQuery = new TMoudleInfor();
         this.FRoleBitMap = new Bitmap();
         this.addChild(this.FRoleBitMap);
         this.FRoleActionID = 0;
         this.FRoleDirection = 1;
         this.FRoleRebirthBitMap = new Bitmap();
         this.addChild(this.FRoleRebirthBitMap);
         this.FOnMainMap = false;
         this.FCurRebirthResID = -1;
      }
      
      protected function CreateSpriteMoudleContorl() : void
      {
      }
      
      protected function LoadTexture(param1:uint, param2:int) : void
      {
         TextureLoader[param2].LoadAutoSecondary(param1,this.SpriteMoudleArrive);
      }
      
      protected function UpdateModelTexture(param1:uint, param2:int) : Boolean
      {
         if(this.FCurrentState != STATE_LOADING)
         {
            return false;
         }
         this.FTexture = TextureLoader[param2].GetTextureByIdentifier(param1);
         if(this.FTexture != null)
         {
            this.FCurrentState = STATE_RUNING;
            this.ChangeAnimationSequence(this.FTexture.GetAnimationSequenceByIndex(0));
            return true;
         }
         return false;
      }
      
      protected function SpriteMoudleArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         if(this.FTextrueID == param3)
         {
            this.FCurrentState = STATE_RUNING;
            this.FTexture = param2;
            this.ChangeAnimationSequence(param2.GetAnimationSequenceByIndex(0));
         }
      }
      
      protected function RebirthResArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:BitmapData = null;
         this.FCurrentRebirthSequence = param2.GetAnimationSequenceByIndex(0);
         this.FCurrentRebirthFrame = this.FCurrentRebirthSequence.GetAnimationFrameByIndex(0);
         _loc4_ = this.FCurrentRebirthFrame.Surface;
         this.FRoleRebirthBitMap.bitmapData = this.FCurrentRebirthFrame.Surface;
         this.UpdateRebirthEffectPos();
      }
      
      protected function KingChallengeArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:BitmapData = null;
         this.FCurrentRebirthSequence = param2.GetAnimationSequenceByIndex(0);
         this.FCurrentRebirthFrame = this.FCurrentRebirthSequence.GetAnimationFrameByIndex(0);
         _loc4_ = this.FCurrentRebirthFrame.Surface;
         this.FRoleRebirthBitMap.bitmapData = this.FCurrentRebirthFrame.Surface;
      }
      
      protected function UpdateRebirthEffectPos() : void
      {
         if(this.FCurrentRebirthFrame != null)
         {
            this.FRoleRebirthBitMap.y = -this.FCurrentRebirthFrame.Pivot.Y;
            if(this.FRoleRebirthBitMap.scaleX == 1)
            {
               this.FRoleRebirthBitMap.x = -this.FCurrentRebirthFrame.Pivot.X;
            }
            else
            {
               this.FRoleRebirthBitMap.x = this.FCurrentRebirthFrame.Pivot.X;
            }
         }
      }
      
      protected function UpdateModelFrame() : void
      {
         if(stage == null || this.FCurrentSequence == null)
         {
            return;
         }
         this.FCurrentFrame = this.FCurrentSequence.GetAnimationFrameByTick(this.FTick);
         if(this.FCurrentFrame != null)
         {
            if(this.FRoleBitMap.bitmapData != this.FCurrentFrame.Surface)
            {
               this.FRoleBitMap.bitmapData = this.FCurrentFrame.Surface;
            }
         }
         else if(this.FOnPlayOver != null)
         {
            this.FOnPlayOver(this);
         }
         if(this.FCurrentRebirthSequence != null)
         {
            this.FCurrentRebirthFrame = this.FCurrentRebirthSequence.GetAnimationFrameByTick(this.FTick);
            if(this.FRoleRebirthBitMap.bitmapData != this.FCurrentRebirthFrame.Surface)
            {
               this.FRoleRebirthBitMap.bitmapData = this.FCurrentRebirthFrame.Surface;
            }
         }
      }
      
      protected function InitBlackMan() : void
      {
         var _loc1_:TTexture = null;
         _loc1_ = SResourcesCore.TexturesLobby.GetTextureByIdentifier(CONST_LOBBY.RESOURCEID_Textures_DefaultRole);
         if(_loc1_ != null)
         {
            this.ChangeAnimationSequence(_loc1_.GetAnimationSequenceByIndex(0));
         }
      }
      
      protected function ChangeAnimationSequence(param1:TAnimationSequence) : void
      {
         var _loc2_:BitmapData = null;
         var _loc3_:TAnimationFrame = null;
         this.FCurrentSequence = param1;
         _loc3_ = this.FCurrentSequence.GetAnimationFrameByIndex(0);
         _loc2_ = _loc3_.Surface;
         this.FRoleBitMap.y = -_loc3_.Pivot.Y;
         if(this.FRoleBitMap.scaleX == 1)
         {
            this.FRoleBitMap.x = -_loc3_.Pivot.X;
         }
         else
         {
            this.FRoleBitMap.x = _loc3_.Pivot.X;
         }
         this.FRoleBitMap.bitmapData = _loc3_.Surface;
         this.FTick = 0;
      }
      
      protected function ChangeScaleX(param1:int) : void
      {
         this.FRoleBitMap.x = 0;
         this.FRoleBitMap.y = 0;
         this.FRoleBitMap.scaleX = param1;
         this.FRoleRebirthBitMap.scaleX = param1;
         this.UpdateRebirthEffectPos();
      }
      
      protected function GetScalxByFaceDirection(param1:int) : void
      {
      }
      
      protected function GetRebirthRescourseID() : Boolean
      {
         var _loc1_:TBins = null;
         var _loc2_:TConfigValue = null;
         var _loc3_:Vector.<uint> = null;
         _loc1_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         if(_loc1_ == null)
         {
            return false;
         }
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Rebirth_RebirthEffectID) as TConfigValue;
         _loc3_ = _loc2_.Value as Vector.<uint>;
         RescourseBaseID_Main = _loc3_[0];
         RescourseBaseID_Hero = _loc3_[1];
         return true;
      }
      
      public function set SpriteMoudleContorl(param1:ISpriteMoudleContorl) : void
      {
         this.FSpriteMoudleContorl = param1;
      }
      
      public function get RoleTempleteID() : int
      {
         return this.FRoleTempleteID;
      }
      
      public function set RoleTempleteID(param1:int) : void
      {
         this.FRoleTempleteID = param1;
      }
      
      public function get RoleActionID() : int
      {
         return this.FRoleActionID;
      }
      
      public function set RoleActionID(param1:int) : void
      {
         this.FRoleActionID = param1;
      }
      
      public function get RoleDirection() : uint
      {
         return this.FRoleDirection;
      }
      
      public function set RoleDirection(param1:uint) : void
      {
         this.FRoleDirection = param1;
      }
      
      public function get UICore() : TUICore
      {
         return this.FUICore;
      }
      
      public function set UICore(param1:TUICore) : void
      {
         this.FUICore = param1;
      }
      
      public function get TextrueID() : uint
      {
         return this.FTextrueID;
      }
      
      public function set TextrueID(param1:uint) : void
      {
         this.FTextrueID = param1;
      }
      
      public function get MouduleID() : uint
      {
         return this.FMouduleID;
      }
      
      public function set MouduleID(param1:uint) : void
      {
         this.FMouduleID = param1;
      }
      
      public function get ReplaceID() : uint
      {
         return this.FReplaceID;
      }
      
      public function set ReplaceID(param1:uint) : void
      {
         this.FReplaceID = param1;
      }
      
      public function get RoleBitMap() : Bitmap
      {
         return this.FRoleBitMap;
      }
      
      public function get OnPlayOver() : Function
      {
         return this.FOnPlayOver;
      }
      
      public function set OnPlayOver(param1:Function) : void
      {
         this.FOnPlayOver = param1;
      }
      
      override public function UpdateData() : void
      {
      }
      
      override public function UpdateView() : void
      {
         this.UpdateModelFrame();
         this.FTick += CONST_COMMON.ElapseTime;
         if(this.FTick == int.MAX_VALUE)
         {
            this.FTick = 0;
         }
      }
      
      public function UpdateMoudle() : void
      {
         var _loc1_:Boolean = false;
         this.FSpriteMoudleContorl.GetRoleMoudleInfor(this,this.FRoleTempleteID,this.FRoleActionID,this.FRoleDirection,this.FQuery);
         if(this.FTextrueID == this.FQuery.TextureID && this.FRoleBitMap.scaleX == this.FQuery.Scalx)
         {
            return;
         }
         this.ChangeScaleX(this.FQuery.Scalx);
         this.FTextrueID = this.FQuery.TextureID;
         this.FCurrentState = STATE_LOADING;
         if(!_loc1_)
         {
            this.LoadTexture(this.FTextrueID,0);
            this.InitBlackMan();
         }
      }
      
      override public function Release() : void
      {
         super.Release();
         this.FTexture = null;
         this.FTextrueID = 0;
         this.FCurrentSequence = null;
         this.FCurrentFrame = null;
         this.FRoleBitMap.bitmapData = null;
         this.FCurrentState = STATE_READY;
         this.FTick = 0;
         this.FRoleTempleteID = 0;
         this.FCurRebirthResID = -1;
         this.FCurrentRebirthSequence = null;
         this.FRoleRebirthBitMap.bitmapData = null;
         this.FCurrentRebirthFrame = null;
      }
      
      public function ChangeRoleMoudle(param1:uint, param2:int, param3:int = 0) : void
      {
         var _loc4_:Boolean = false;
         if(this.FTextrueID == param1 && this.FRoleBitMap.scaleX == param2)
         {
            return;
         }
         this.ChangeScaleX(param2);
         this.FTextrueID = param1;
         this.FCurrentState = STATE_LOADING;
         _loc4_ = this.UpdateModelTexture(this.FTextrueID,param3);
         if(!_loc4_)
         {
            this.LoadTexture(param1,param3);
            this.InitBlackMan();
         }
      }
      
      public function ChangeFrameSequence(param1:uint) : void
      {
         var _loc2_:Boolean = false;
         this.FRoleBitMap.bitmapData = null;
         this.FTextrueID = (this.FRoleTempleteID << 8) + param1;
         this.FCurrentState = STATE_LOADING;
         if(!_loc2_)
         {
            this.InitBlackMan();
         }
      }
      
      public function ReleaseModuleResource() : void
      {
         var _loc1_:int = 0;
         if(this.FRoleTempleteID == 0)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ <= CONST_ROLE.ROLE_SEQUENCEINDEX_NORMAL_RUN_Down)
         {
            SResourcesCore.TexturesModel.DeleteByIdentifier(this.FRoleTempleteID << 8 + _loc1_,true);
            _loc1_++;
         }
      }
      
      public function OpenRebirthEffect(param1:Boolean, param2:uint) : void
      {
         var _loc3_:uint = 0;
         if(RescourseBaseID_Main == 0 && !this.GetRebirthRescourseID())
         {
            return;
         }
         if(!this.FOnMainMap)
         {
            _loc3_ = param1 ? uint(RescourseBaseID_Main) : uint(RescourseBaseID_Hero);
            _loc3_ += param2;
         }
         if(this.FCurRebirthResID == _loc3_)
         {
            return;
         }
         this.FCurRebirthResID = _loc3_;
         this.FRoleRebirthBitMap.bitmapData = null;
         this.FCurrentRebirthSequence = null;
         if(param2 == 0)
         {
            return;
         }
         SResourcesCore.TexturesLobby.LoadAutoSecondary(_loc3_,this.RebirthResArrive);
      }
      
      public function SetKingChallenge(param1:uint) : void
      {
         SResourcesCore.TexturesModel.LoadAutoSecondary(param1,this.KingChallengeArrive);
      }
   }
}

