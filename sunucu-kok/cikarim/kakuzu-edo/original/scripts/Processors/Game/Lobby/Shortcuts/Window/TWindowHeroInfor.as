package Processors.Game.Lobby.Shortcuts.Window
{
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Agent.SParametersCore;
   import Logics.Characters.*;
   import Logics.Characters.MoveRole.*;
   import Logics.Spaces.*;
   import Processors.Game.Lobby.Common.Map.SceneSprite.*;
   import Processors.Game.Lobby.MainScene.Role.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   use namespace LogicsSpace;
   
   public class TWindowHeroInfor extends TUIComponent
   {
      
      protected var FHeroAvatar:Sprite;
      
      protected var FAvatarHeroLevel:TextField;
      
      protected var FAvatarHeroName:TextField;
      
      protected var FAvatarGuideText:Vector.<TextField>;
      
      protected var FMC_Family:MovieClip;
      
      protected var FMC_Head:MovieClip;
      
      protected var FSP_YellowDiamondYear:Sprite;
      
      protected var FMC_YellowDiamond:MovieClip;
      
      protected var FCharacterDigest:TFriendDigest;
      
      protected var FDigest:TDigest;
      
      protected var FHeroInforOnClick:Function;
      
      public function TWindowHeroInfor(param1:TUIComponent)
      {
         super(param1);
      }
      
      public function Perform_UIDispatch() : void
      {
         this.AvatarUIDispatch();
         this.FCharacterDigest = new TFriendDigest(0,0);
         this.FDigest = new TDigest(0,0);
         this.Perform_UILocation();
      }
      
      public function Perform_UILocation() : void
      {
         this.AvatarUILocation();
      }
      
      protected function AvatarUIDispatch() : void
      {
         var _loc1_:int = 0;
         this.FHeroAvatar = TUtilityReflection.CreateDisplayObjectInstance("HeroAvatar") as Sprite;
         addChild(this.FHeroAvatar);
         this.FAvatarHeroLevel = this.FHeroAvatar["HeroLevel"];
         this.FAvatarHeroName = this.FHeroAvatar["HeroName"];
         this.FMC_Family = this.FHeroAvatar["MC_Country"];
         this.FMC_Head = this.FHeroAvatar["HeroHead"];
         this.FSP_YellowDiamondYear = this.FHeroAvatar["SP_YellowDiamondYear"];
         this.FMC_YellowDiamond = this.FHeroAvatar["MC_YellowDiamond"];
         this.FAvatarGuideText = new Vector.<TextField>();
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            this.FAvatarGuideText.push(this.FHeroAvatar["Guide" + (_loc1_ + 1)]);
            _loc1_++;
         }
      }
      
      protected function AvatarUILocation() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TextField = null;
         var _loc3_:String = null;
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = this.FAvatarGuideText[_loc1_];
            _loc3_ = TUtilityString.Format(TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_33)[_loc1_],TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_34)[_loc1_]);
            _loc2_.htmlText = _loc3_;
            _loc2_.addEventListener(TextEvent.LINK,this.GuideStringClick);
            _loc1_++;
         }
      }
      
      protected function UpdateAvaterInfor(param1:TSceneSpriteMoudleInMapCanRunPlayer) : void
      {
         var _loc2_:String = null;
         _loc2_ = "ID" + param1.RoleTempleteID.toString();
         this.FMC_Head.gotoAndStop(_loc2_);
         this.FAvatarHeroLevel.text = param1.Level.toString();
         this.FAvatarHeroName.text = param1.Name;
         if(SParametersCore.IfBaiDuGame)
         {
            this.FSP_YellowDiamondYear.visible = param1.IFYearYellowDiamondUser;
            this.FMC_YellowDiamond.visible = param1.YellowDiamondLevel != 0;
            if(param1.YellowDiamondLevel != 0)
            {
               this.FMC_YellowDiamond.gotoAndStop(param1.YellowDiamondLevel);
            }
         }
         else
         {
            if(this.FSP_YellowDiamondYear != null)
            {
               this.FSP_YellowDiamondYear.visible = false;
            }
            if(this.FMC_YellowDiamond != null)
            {
               this.FMC_YellowDiamond.visible = false;
            }
         }
         if(param1.FamilyID == 0)
         {
            this.FMC_Family.visible = false;
         }
         else
         {
            this.FMC_Family.gotoAndStop("Family" + param1.FamilyID);
            this.FMC_Family.visible = true;
         }
      }
      
      protected function GuideStringClick(param1:TextEvent) : void
      {
         if(this.FHeroInforOnClick != null)
         {
            this.FHeroInforOnClick(this,param1.text,this.FDigest,this.FCharacterDigest);
         }
      }
      
      public function set HeroInforOnClick(param1:Function) : void
      {
         this.FHeroInforOnClick = param1;
      }
      
      public function get ShortcutWidth() : int
      {
         return this.width;
      }
      
      public function ShowHeroInforPanle(param1:TSceneSpriteMoudleInMapCanRunPlayer) : void
      {
         this.FDigest.Coerce(param1.UserIDHigh,param1.UserIDLow);
         this.FDigest.Name = param1.Name;
         this.FCharacterDigest.Coerce(param1.UserIDHigh,param1.UserIDLow);
         this.FCharacterDigest.Name = param1.Name;
         this.UpdateAvaterInfor(param1);
         this.Visible = true;
      }
      
      public function HideHeroInforPanle() : void
      {
         this.Visible = false;
      }
   }
}

