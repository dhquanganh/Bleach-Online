package Processors.Game.Lobby.TeamBattle.Room.Components
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Rooms.Seat.Player.*;
   import Processors.Game.Lobby.Components.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TUIPlayerDouble extends TUIComponent
   {
      
      protected var FUIHero:TUIHero;
      
      protected var FUIKnife:TUIHero;
      
      protected var FSP_HeroTop:Sprite;
      
      protected var FSP_HeroPosition:Sprite;
      
      protected var FTF_HeroLevel:TextField;
      
      protected var FTF_HeroNickname:TextField;
      
      protected var FTF_HeroFightingPower:TextField;
      
      protected var FSP_KnifeTop:Sprite;
      
      protected var FSP_KnifePosition:Sprite;
      
      protected var FTF_KnifeNickname:TextField;
      
      protected var FResource:Sprite;
      
      protected var FContext:TPlayerRoomDigest;
      
      protected var FOnHeroQuerySequenceContext:Function;
      
      protected var FOnKnifeQuerySequenceContext:Function;
      
      public function TUIPlayerDouble(param1:TUIComponent)
      {
         super(param1);
         this.FUIHero = new TUIHero(null);
         this.FUIHero.OnQuerySequenceContext = this.HeroOnQuerySequenceContext;
         this.FUIKnife = new TUIHero(null);
         this.FUIKnife.OnQuerySequenceContext = this.KnifeOnQuerySequenceContext;
      }
      
      protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:TBounds = null;
         var _loc2_:TCoordinate = null;
         this.addChild(this.FResource);
         this.FResource.mouseEnabled = false;
         this.FResource.mouseChildren = false;
         _loc1_ = new TBounds();
         _loc2_ = new TCoordinate();
         this.FSP_HeroTop = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_SP_HeroTop];
         this.FTF_HeroLevel = this.FSP_HeroTop[CONST_TEAMBATTLE.RESOURCE_Link_TF_Level];
         this.FTF_HeroNickname = this.FSP_HeroTop[CONST_TEAMBATTLE.RESOURCE_Link_TF_Nickname];
         this.FTF_HeroFightingPower = this.FSP_HeroTop[CONST_TEAMBATTLE.RESOURCE_Link_TF_FightingPower];
         this.FSP_HeroPosition = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_SP_HeroPoint];
         this.FSP_HeroPosition.addChild(this.FUIHero);
         this.FUIHero.SequenceDefaultRole.Evaluate(_loc2_,_loc1_);
         this.FUIHero.X = _loc1_.X;
         this.FUIHero.Y = _loc1_.Y;
         this.FSP_KnifeTop = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_SP_KnifeTop];
         this.FTF_KnifeNickname = this.FSP_KnifeTop[CONST_TEAMBATTLE.RESOURCE_Link_TF_Nickname];
         this.FSP_KnifePosition = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_SP_KnifePoint];
         this.FSP_KnifePosition.addChild(this.FUIKnife);
         this.FUIKnife.SequenceDefaultRole.Evaluate(_loc2_,_loc1_);
         this.FUIKnife.X = _loc1_.X;
         this.FUIKnife.Y = _loc1_.Y;
         this.Reset();
      }
      
      protected function addEventListenerPlayer() : void
      {
      }
      
      protected function RemoveEventListenerPlayer() : void
      {
      }
      
      protected function UpdateUIPlayer() : void
      {
         this.FTF_HeroLevel.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_14),this.FContext.Level);
         this.FTF_HeroNickname.text = this.FContext.Nickname;
         this.FTF_HeroFightingPower.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_15),this.FContext.FightingPower);
         if(this.FContext.KnifeExpandID != 0)
         {
            this.FTF_KnifeNickname.text = this.FContext.KnifeCaption;
            this.FSP_KnifeTop.visible = true;
            this.FSP_KnifePosition.visible = true;
         }
      }
      
      protected function HeroOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TBounds = null;
         var _loc6_:TCoordinate = null;
         if(this.FOnHeroQuerySequenceContext != null)
         {
            this.FOnHeroQuerySequenceContext(param1,param2,param3,param4);
            if(param3.Value != null)
            {
               _loc5_ = new TBounds();
               _loc6_ = new TCoordinate();
               param3.Value.Evaluate(_loc6_,_loc5_);
               this.FUIHero.X = _loc5_.X;
               this.FUIHero.Y = _loc5_.Y;
            }
         }
      }
      
      protected function KnifeOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TBounds = null;
         var _loc6_:TCoordinate = null;
         if(this.FOnKnifeQuerySequenceContext != null)
         {
            this.FOnKnifeQuerySequenceContext(param1,param2,param3,param4);
            if(param3.Value != null)
            {
               _loc5_ = new TBounds();
               _loc6_ = new TCoordinate();
               param3.Value.Evaluate(_loc6_,_loc5_);
               this.FUIHero.X = _loc5_.X;
               this.FUIHero.Y = _loc5_.Y;
            }
         }
      }
      
      public function get Resource() : Sprite
      {
         return this.FResource;
      }
      
      public function set Resource(param1:Sprite) : void
      {
         this.FResource = param1;
      }
      
      public function get Context() : TPlayerRoomDigest
      {
         return this.FContext;
      }
      
      public function set Context(param1:TPlayerRoomDigest) : void
      {
         this.Reset();
         if(this.FContext == null && param1 != null)
         {
            this.addEventListenerPlayer();
         }
         else if(param1 == null)
         {
            this.RemoveEventListenerPlayer();
         }
         this.FContext = param1;
         this.FUIHero.Context = param1;
         this.FUIKnife.Context = param1;
         if(param1 != null)
         {
            this.UpdateUIPlayer();
         }
      }
      
      public function get OnHeroQuerySequenceContext() : Function
      {
         return this.FOnHeroQuerySequenceContext;
      }
      
      public function set OnHeroQuerySequenceContext(param1:Function) : void
      {
         this.FOnHeroQuerySequenceContext = param1;
      }
      
      public function get OnKnifeQuerySequenceContext() : Function
      {
         return this.FOnKnifeQuerySequenceContext;
      }
      
      public function set OnKnifeQuerySequenceContext(param1:Function) : void
      {
         this.FOnKnifeQuerySequenceContext = param1;
      }
      
      public function set SequenceDefaultRole(param1:TAnimationSequence) : void
      {
         if(param1 != null)
         {
            this.FUIHero.SequenceDefaultRole = param1;
            this.FUIKnife.SequenceDefaultRole = param1;
         }
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         if(this.FResource != null)
         {
            this.FResource.visible = param1;
         }
      }
      
      public function Perform_UIDispatch() : void
      {
         this.ResourcesPerform_UIDispatch();
      }
      
      public function Reset() : void
      {
         this.FTF_HeroLevel.text = "";
         this.FTF_HeroNickname.text = "";
         this.FTF_HeroFightingPower.text = "";
         this.FTF_KnifeNickname.text = "";
         this.FSP_KnifeTop.visible = false;
         this.FSP_KnifePosition.visible = false;
      }
      
      public function Update() : void
      {
         this.FUIHero.Update();
         this.FUIKnife.Update();
      }
   }
}

