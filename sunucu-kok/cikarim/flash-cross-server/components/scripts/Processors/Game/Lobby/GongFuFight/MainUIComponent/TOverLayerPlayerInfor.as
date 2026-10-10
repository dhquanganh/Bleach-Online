package Processors.Game.Lobby.GongFuFight.MainUIComponent
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.TBaseHero;
   import Logics.DatebaseVO.VO.TKnife;
   import Logics.DatebaseVO.VO.TKnifeExpand;
   import Logics.DatebaseVO.VO.TRoleModel;
   import Logics.GongFuFight.TGongFuFightPlayerInfor;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class TOverLayerPlayerInfor extends TUIComponent
   {
      
      protected static const HeadNum:int = 5;
      
      protected var FMainScene:Sprite;
      
      protected var FName:TextField;
      
      protected var FLevel:TextField;
      
      protected var FKnifeInfor:TextField;
      
      protected var FFightPower:TextField;
      
      protected var FHeadMountPoints:Vector.<Bitmap>;
      
      protected var FKnifeStarName:Vector.<String>;
      
      protected var FPlayerInfor:TGongFuFightPlayerInfor;
      
      public function TOverLayerPlayerInfor(param1:TUIComponent)
      {
         super(param1);
      }
      
      public function UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Bitmap = null;
         this.FMainScene = TUtilityReflection.CreateDisplayObjectInstance("GongFuFightPlayerTip") as Sprite;
         addChild(this.FMainScene);
         this.FHeadMountPoints = new Vector.<Bitmap>();
         _loc1_ = 0;
         while(_loc1_ < HeadNum)
         {
            _loc2_ = new Bitmap();
            this.FMainScene["head" + _loc1_]["SP_HeroIconPoint"].addChild(_loc2_);
            this.FHeadMountPoints.push(_loc2_);
            _loc1_++;
         }
         this.FName = this.FMainScene["TF_Nickname"];
         this.FLevel = this.FMainScene["TF_Level"];
         this.FKnifeInfor = this.FMainScene["TF_KnifeOfKillSoul"];
         this.FFightPower = this.FMainScene["TF_FightingPower"];
         this.FKnifeStarName = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_3);
      }
      
      protected function RenderByPlayerInfor(param1:TGongFuFightPlayerInfor) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:TBaseHero = null;
         var _loc6_:TRoleModel = null;
         var _loc7_:TKnifeExpand = null;
         var _loc8_:TKnife = null;
         var _loc9_:String = null;
         this.FKnifeInfor.text = "";
         if(param1.KnifeID != 0)
         {
            _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_KnifeExpand,param1.KnifeID) as TKnifeExpand;
            _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Knife,_loc7_.RelationID) as TKnife;
            this.FKnifeInfor.text = _loc8_.Name + "[" + this.FKnifeStarName[_loc7_.Level - 1] + "]";
         }
         this.FName.text = param1.PlayerName;
         this.FFightPower.text = param1.PlayerFightPowerValue.toString();
         _loc9_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_22);
         this.FLevel.text = TUtilityString.Format(_loc9_,param1.PlayerLevel);
         _loc3_ = int(param1.PlayerFriendID.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.PlayerFriendID[_loc2_];
            _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,_loc4_) as TBaseHero;
            _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,_loc4_) as TRoleModel;
            SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc6_.RoleHead,this.PicArrive);
            _loc2_++;
         }
      }
      
      protected function PicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TRoleModel = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:uint = 0;
         _loc6_ = int(this.FPlayerInfor.PlayerFriendID.length);
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = this.FPlayerInfor.PlayerFriendID[_loc5_];
            _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,_loc7_) as TRoleModel;
            if(_loc4_.RoleHead == param3)
            {
               this.FHeadMountPoints[_loc5_].bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
            }
            _loc5_++;
         }
      }
      
      protected function UpdatePosition_Perform() : void
      {
         if(FUICore.MouseCoordinate.X > CONST_COMMON.STAGE_Width - width)
         {
            x = Math.max(FUICore.MouseCoordinate.X - width - 40,0);
         }
         else
         {
            x = Math.min(FUICore.MouseCoordinate.X + 40,CONST_COMMON.STAGE_Width - width);
         }
         if(FUICore.MouseCoordinate.Y > CONST_COMMON.STAGE_Height - height)
         {
            y = Math.max(FUICore.MouseCoordinate.Y - height,0);
         }
         else
         {
            y = Math.min(FUICore.MouseCoordinate.Y,CONST_COMMON.STAGE_Height - height);
         }
      }
      
      public function UpdatePosition() : void
      {
         this.UpdatePosition_Perform();
      }
      
      public function Update(param1:TGongFuFightPlayerInfor) : void
      {
         this.Reset();
         this.FPlayerInfor = param1;
         this.RenderByPlayerInfor(param1);
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FHeadMountPoints.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FHeadMountPoints[_loc1_].bitmapData = null;
            _loc1_++;
         }
      }
   }
}

