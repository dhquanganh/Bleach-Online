package Processors.Game.MiniBattle
{
   import Components.Slots.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Jade.*;
   import Processors.Game.MiniBattle.Mode.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.text.*;
   
   public class TComponentRewardSingle extends TProcessorLobbyWindow
   {
      
      protected static const RewardScreenX:int = (1250 - 622) / 2;
      
      protected static const MVPMountPointX:int = -25;
      
      protected static const MVPMountPointY:int = -30;
      
      protected static const NormalMountPointX:int = 11;
      
      protected static const NormalMountPointY:int = 11;
      
      protected var FUI:MovieClip;
      
      protected var FPicMountPointUI:Sprite;
      
      protected var FPicHeadMountPoint:Bitmap;
      
      protected var FPicBoard:Sprite;
      
      protected var FMVPFlag:MovieClip;
      
      protected var FPicBattleWinFlag:Sprite;
      
      protected var FName:TextField;
      
      protected var FKillNum:TextField;
      
      protected var FSlotBoard:Vector.<Sprite>;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FRewardNum:Vector.<TextField>;
      
      protected var FIsMVP:Boolean;
      
      public function TComponentRewardSingle(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(Visible)
         {
            _loc2_ = int(this.FSlots.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FSlots[_loc1_].Update();
               _loc1_++;
            }
            if(this.FUI.currentFrame == this.FUI.totalFrames)
            {
               this.FUI.stop();
            }
            if(this.FMVPFlag.currentFrame == this.FMVPFlag.totalFrames)
            {
               this.FMVPFlag.stop();
            }
         }
      }
      
      protected function LoadResource_Perform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:TUISlot = null;
         var _loc4_:MovieClip = null;
         this.FUI = TUtilityReflection.CreateDisplayObjectInstance("PVERewardMid") as MovieClip;
         addChild(this.FUI);
         this.FUI.x = RewardScreenX;
         _loc4_ = this.FUI["Board"];
         this.FPicHeadMountPoint = new Bitmap();
         this.FPicMountPointUI = _loc4_["PicSlot"]["MountPoint"];
         this.FPicMountPointUI.addChild(this.FPicHeadMountPoint);
         this.FPicBoard = _loc4_["PicSlot"]["PicBoard"];
         this.FMVPFlag = _loc4_["MVPFlag"];
         this.FName = _loc4_["Name"];
         this.FKillNum = _loc4_["KillNum"];
         this.FPicBattleWinFlag = _loc4_["WinFlag"];
         this.FSlotBoard = new Vector.<Sprite>();
         this.FSlots = new Vector.<TUISlot>();
         this.FRewardNum = new Vector.<TextField>();
         _loc1_ = 0;
         while(_loc1_ < 3)
         {
            _loc2_ = _loc4_["Slot" + _loc1_];
            this.FSlotBoard.push(_loc2_);
            _loc3_ = new TUISlot(this);
            _loc3_.Resource = _loc2_["mc_slot"];
            TJadeCommon.InitSlot(_loc3_);
            _loc3_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc3_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            _loc3_.Init();
            this.FSlots.push(_loc3_);
            this.FRewardNum.push(_loc2_["KillNum"]);
            _loc1_++;
         }
      }
      
      protected function RenderingByData(param1:TSoliderReward, param2:Boolean, param3:Boolean) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:TRoleModel = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:TUISlot = null;
         var _loc9_:TInventory = null;
         if(param1 != null)
         {
            _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,param1.SoliderTempleteID) as TRoleModel;
            SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc5_.RoleHead,this.CallBack_PicArrive);
            this.FName.text = param1.SoliderName;
            this.FKillNum.text = "x" + param1.KillNum.toString();
            _loc7_ = param1.Rewards.Count;
         }
         else
         {
            SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(SLogicsCore.Character.GetMainHero().SmallID,this.CallBack_PicArrive);
            this.FName.text = SLogicsCore.Character.NickName;
            this.FKillNum.text = "";
            _loc7_ = 0;
         }
         this.FPicBattleWinFlag.visible = param3;
         this.FPicBoard.visible = !param2;
         this.FMVPFlag.visible = param2;
         if(param2)
         {
            this.FMVPFlag.gotoAndPlay(1);
         }
         if(param2)
         {
            this.FPicMountPointUI.x = MVPMountPointX;
            this.FPicMountPointUI.y = MVPMountPointY;
         }
         else
         {
            this.FPicMountPointUI.x = NormalMountPointX;
            this.FPicMountPointUI.y = NormalMountPointY;
         }
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            this.FSlotBoard[_loc6_].visible = true;
            _loc9_ = param1.Rewards.GetInventoryByIndex(_loc6_);
            this.FSlots[_loc6_].Context = _loc9_;
            this.FRewardNum[_loc6_].text = "x" + _loc9_.Quantity.toString();
            _loc6_++;
         }
         while(_loc6_ < 3)
         {
            this.FSlotBoard[_loc6_].visible = false;
            _loc6_++;
         }
      }
      
      protected function CallBack_PicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:int = 0;
         _loc4_ = this.FIsMVP ? 1 : 0;
         this.FPicHeadMountPoint.bitmapData = param2.GetAnimationSequenceByIndex(_loc4_).GetAnimationFrameByIndex(0).Surface;
      }
      
      public function LoadResource() : void
      {
         this.LoadResource_Perform();
      }
      
      public function ShowRewardAccount(param1:TSoliderReward, param2:Boolean, param3:Boolean) : void
      {
         this.FIsMVP = param2;
         this.FUI.gotoAndPlay(1);
         this.RenderingByData(param1,param2,param3);
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FUI.gotoAndStop(1);
         this.FPicHeadMountPoint.bitmapData = null;
         this.FPicBattleWinFlag.visible = false;
         this.FName.text = "";
         this.FKillNum.text = "";
         _loc2_ = int(this.FSlots.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSlots[_loc1_].Context = null;
            this.FRewardNum[_loc1_].text = "";
            _loc1_++;
         }
         this.FUI.stop();
      }
   }
}

