package Processors.Game.Lobby.VainTravel
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.TKnife;
   import Logics.DatebaseVO.VO.TKnifeExpand;
   import Logics.DatebaseVO.VO.TRoleModel;
   import Logics.VainTravel.TVainTravelPlayerInfor;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class TVainHeroInforTip extends TUIComponent
   {
      
      protected static const HeroNum:int = 5;
      
      protected static const LevelFormat:String = "Lv.%0";
      
      protected var FScene:MovieClip;
      
      protected var FHeroName:TextField;
      
      protected var FKnifeName:TextField;
      
      protected var FHeroSlots:Vector.<Sprite>;
      
      protected var FHeroLevels:Vector.<TextField>;
      
      protected var FHeroBloods:Vector.<Sprite>;
      
      protected var FHeroMountPoint:Vector.<Bitmap>;
      
      protected var FVainTravelPlayerInfor:TVainTravelPlayerInfor;
      
      protected var FHeadIconID:Vector.<int>;
      
      public function TVainHeroInforTip(param1:TUIComponent)
      {
         super(param1);
         this.InitDeploymentTip();
      }
      
      protected function InitDeploymentTip() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:Bitmap = null;
         this.FScene = TUtilityReflection.CreateDisplayObjectInstance("VainTravelHeroInfo") as MovieClip;
         addChild(this.FScene);
         this.FHeroName = this.FScene["Name"];
         this.FKnifeName = this.FScene["Knife"];
         this.FHeroSlots = new Vector.<Sprite>();
         this.FHeroLevels = new Vector.<TextField>();
         this.FHeroBloods = new Vector.<Sprite>();
         this.FHeroMountPoint = new Vector.<Bitmap>();
         _loc2_ = HeroNum;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FScene["Hero" + _loc1_];
            this.FHeroSlots.push(_loc3_);
            this.FHeroLevels.push(_loc3_["Level"]);
            this.FHeroBloods.push(_loc3_["Blood"]["Bar"]);
            _loc4_ = new Bitmap();
            this.FHeroMountPoint.push(_loc4_);
            _loc3_["MountPoint"].addChild(_loc4_);
            _loc1_++;
         }
         this.FHeadIconID = new Vector.<int>();
      }
      
      protected function UpdataUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TKnifeExpand = null;
         var _loc4_:TKnife = null;
         this.FHeroName.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_VAINTRAVEL_23),this.FVainTravelPlayerInfor.PlatformName,this.FVainTravelPlayerInfor.ServerID,this.FVainTravelPlayerInfor.PlayerName,this.FVainTravelPlayerInfor.PlayerLevel);
         this.FKnifeName.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.COMMON_NONE);
         if(this.FVainTravelPlayerInfor.KnifeID != 0)
         {
            _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_KnifeExpand,this.FVainTravelPlayerInfor.KnifeID) as TKnifeExpand;
            _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Knife,_loc3_.RelationID) as TKnife;
            this.FKnifeName.text = _loc4_.Name;
         }
         _loc2_ = int(this.FVainTravelPlayerInfor.HeroTemplateID.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FHeroSlots[_loc1_].visible = true;
            this.FHeroLevels[_loc1_].text = TUtilityString.Format(LevelFormat,this.FVainTravelPlayerInfor.HeroLevel[_loc1_]);
            this.FHeroBloods[_loc1_].scaleX = this.FVainTravelPlayerInfor.HeroBloodRateByIndex(_loc1_);
            SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(this.FHeadIconID[_loc1_],this.PicArrive);
            _loc1_++;
         }
         while(_loc1_ < HeroNum)
         {
            this.FHeroSlots[_loc1_].visible = false;
            _loc1_++;
         }
      }
      
      protected function PicArrive(param1:Object, param2:TTexture, param3:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc5_ = int(this.FHeadIconID.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(this.FHeadIconID[_loc4_] == param3)
            {
               this.FHeroMountPoint[_loc4_].bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
            }
            _loc4_++;
         }
      }
      
      public function SetContext(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TRoleModel = null;
         var _loc5_:TVainTravelPlayerInfor = null;
         this.FHeadIconID.length = 0;
         this.FVainTravelPlayerInfor = param1 as TVainTravelPlayerInfor;
         _loc3_ = int(this.FVainTravelPlayerInfor.HeroTemplateID.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,this.FVainTravelPlayerInfor.HeroTemplateID[_loc2_]) as TRoleModel;
            this.FHeadIconID.push(_loc4_.RoleHead);
            _loc2_++;
         }
         this.UpdataUI();
      }
      
      public function CheckTipPoint() : void
      {
         if(mouseX > CONST_COMMON.STAGE_Width - this.FScene.width)
         {
            this.FScene.x = Math.max(mouseX - this.FScene.width - 40,0);
         }
         else
         {
            this.FScene.x = Math.min(mouseX + 40,CONST_COMMON.STAGE_Width - this.FScene.width);
         }
         if(mouseY > CONST_COMMON.STAGE_Height - this.FScene.height)
         {
            this.FScene.y = Math.max(mouseY - this.FScene.height,0);
         }
         else
         {
            this.FScene.y = Math.min(mouseY,CONST_COMMON.STAGE_Height - this.FScene.height);
         }
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = HeroNum;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FHeroMountPoint[_loc1_].bitmapData = null;
            _loc1_++;
         }
      }
   }
}

