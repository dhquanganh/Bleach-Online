package Processors.Game.Lobby.MainScene.Role
{
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Resources.Constants.*;
   import flash.display.*;
   
   public class TUI extends TUIComponent
   {
      
      protected static const SIZE_FrameRatePerSecond:int = CONST_COMMON.SIZE_FrameRatePerSecond;
      
      public static const STATE_READY:int = -1;
      
      public static const STATE_LOADING:int = 0;
      
      public static const STATE_RUNING:int = 1;
      
      public static var RescourseBaseID_Main:int = 0;
      
      protected var FCurrentState:int;
      
      protected var FTextrueID:uint;
      
      protected var FTexture:TTexture;
      
      protected var FCurrentSequence:TAnimationSequence;
      
      protected var FCurrentFrame:TAnimationFrame;
      
      protected var FRoleBitMap:Bitmap;
      
      protected var FCurrentRebirthSequence:TAnimationSequence;
      
      protected var FCurrentRebirthFrame:TAnimationFrame;
      
      protected var FRoleRebirthBitMap:Bitmap;
      
      protected var FRoleState:int;
      
      protected var FTick:int;
      
      protected var FTemplateID:uint;
      
      protected var FOnLoadResourceOver:Function;
      
      public function TUI(param1:TUIComponent)
      {
         super(param1);
         this.FRoleBitMap = new Bitmap();
         addChild(this.FRoleBitMap);
         this.FRoleRebirthBitMap = new Bitmap();
         this.addChild(this.FRoleRebirthBitMap);
         this.FCurrentState = STATE_READY;
      }
      
      protected function UpdateModelTexture() : void
      {
         this.FTexture = SResourcesCore.TexturesModel.GetTextureByIdentifier(this.FTextrueID);
         if(this.FTexture)
         {
            if(this.FTexture.Count <= 0)
            {
               this.FTexture = null;
            }
         }
         if(this.FTexture != null)
         {
            this.FCurrentSequence = this.FTexture.GetAnimationSequenceByIndex(0);
            this.UpdateModelFrame();
            this.DoAfterLoadResourceOver();
         }
         else
         {
            SResourcesCore.TexturesModel.LoadSecondary(this.FTextrueID);
         }
      }
      
      protected function UpdateModelFrame() : void
      {
         this.FTick += SIZE_FrameRatePerSecond;
         this.FCurrentFrame = this.FCurrentSequence.GetAnimationFrameByTick(this.FTick);
         if(this.FRoleBitMap.bitmapData != this.FCurrentFrame.Surface)
         {
            this.FRoleBitMap.bitmapData = this.FCurrentFrame.Surface;
            this.SyncRebirthEffect();
         }
      }
      
      protected function UpdateRebirthEffect() : void
      {
         var _loc1_:TAnimationFrame = null;
         if(this.FCurrentRebirthSequence != null)
         {
            _loc1_ = this.FCurrentRebirthSequence.GetAnimationFrameByTick(this.FTick);
            if(this.FRoleRebirthBitMap.bitmapData != _loc1_.Surface)
            {
               this.FRoleRebirthBitMap.bitmapData = _loc1_.Surface;
            }
         }
      }
      
      protected function DoAfterLoadResourceOver() : void
      {
         this.FCurrentState = STATE_RUNING;
         if(this.FOnLoadResourceOver != null)
         {
            this.FOnLoadResourceOver();
         }
      }
      
      protected function InitBlackMan() : void
      {
         var _loc1_:TTexture = null;
         _loc1_ = SResourcesCore.TexturesLobby.GetTextureByIdentifier(CONST_LOBBY.RESOURCEID_Textures_DefaultRole);
         if(_loc1_ != null)
         {
            this.FCurrentSequence = _loc1_.GetAnimationSequenceByIndex(0);
            this.FCurrentFrame = this.FCurrentSequence.GetAnimationFrameByIndex(0);
            this.FRoleBitMap.bitmapData = this.FCurrentFrame.Surface;
         }
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
         return true;
      }
      
      protected function RebirthResArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:BitmapData = null;
         this.FCurrentRebirthSequence = param2.GetAnimationSequenceByIndex(0);
         this.FCurrentRebirthFrame = this.FCurrentRebirthSequence.GetAnimationFrameByIndex(0);
         _loc4_ = this.FCurrentRebirthFrame.Surface;
         this.FRoleRebirthBitMap.bitmapData = this.FCurrentRebirthFrame.Surface;
         this.SyncRebirthEffect();
      }
      
      protected function SyncRebirthEffect() : void
      {
         if(Boolean(this.FCurrentRebirthFrame) && Boolean(this.FCurrentFrame))
         {
            this.FRoleRebirthBitMap.x = this.FCurrentFrame.Pivot.X - this.FCurrentRebirthFrame.Pivot.X;
            this.FRoleRebirthBitMap.y = this.FCurrentFrame.Pivot.Y - this.FCurrentRebirthFrame.Pivot.Y;
            this.FRoleRebirthBitMap.scaleX = this.FRoleBitMap.scaleX;
            if(this.FRoleRebirthBitMap.scaleX < 0)
            {
               this.FRoleRebirthBitMap.x *= -1;
            }
         }
      }
      
      public function set OnLoadResourceOver(param1:Function) : void
      {
         this.FOnLoadResourceOver = param1;
      }
      
      public function get CurrentFrame() : TAnimationFrame
      {
         return this.FCurrentFrame;
      }
      
      public function set TemplateID(param1:uint) : void
      {
         this.FTemplateID = param1;
      }
      
      public function get TemplateID() : uint
      {
         return this.FTemplateID;
      }
      
      public function Update() : void
      {
         switch(this.FCurrentState)
         {
            case STATE_LOADING:
               this.UpdateModelTexture();
               break;
            case STATE_RUNING:
               this.UpdateModelFrame();
         }
         this.UpdateRebirthEffect();
      }
      
      private function ChangeTextureID(param1:uint) : Boolean
      {
         if(this.FTextrueID == param1)
         {
            return false;
         }
         this.FTextrueID = param1;
         this.FCurrentState = STATE_LOADING;
         this.UpdateModelTexture();
         if(this.FTexture == null)
         {
            this.InitBlackMan();
            return false;
         }
         return true;
      }
      
      public function ChangeScaleX(param1:int) : void
      {
         if(this.FRoleBitMap.scaleX != param1)
         {
            this.FRoleBitMap.scaleX = param1;
            this.SyncRebirthEffect();
         }
      }
      
      public function Release() : void
      {
         this.FTexture = null;
         this.FCurrentSequence = null;
         this.FCurrentFrame = null;
         this.FCurrentRebirthSequence = null;
         this.FRoleRebirthBitMap.bitmapData = null;
         this.FCurrentRebirthFrame = null;
         this.FRoleBitMap.bitmapData = null;
         this.FCurrentState = STATE_READY;
         this.FTick = 0;
         this.FTextrueID = 0;
      }
      
      public function Reload() : void
      {
         this.ChangeTextureID(this.FTextrueID);
      }
      
      public function ChangeFrameSequence(param1:uint) : void
      {
         if(this.FTemplateID != 0)
         {
            this.ChangeTextureID((this.FTemplateID << 8) + param1);
         }
      }
      
      public function OpenRebirthEffect(param1:uint) : void
      {
         var _loc2_:int = 0;
         if(RescourseBaseID_Main == 0 && !this.GetRebirthRescourseID())
         {
            return;
         }
         this.FRoleRebirthBitMap.bitmapData = null;
         this.FCurrentRebirthSequence = null;
         if(param1 == 0)
         {
            return;
         }
         _loc2_ = RescourseBaseID_Main + param1;
         SResourcesCore.TexturesLobby.LoadAutoSecondary(_loc2_,this.RebirthResArrive);
      }
   }
}

