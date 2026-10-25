package Processors.Game.Lobby.TeamBattle.Room.Components
{
   import Foundation.Common.*;
   import Foundation.Queries.Textures.TQueryAnimationSequence;
   import Foundation.Resources.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Rooms.Seat.Player.*;
   import Logics.Rooms.Seat.Player.Hero.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Rendering.Overlayers.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.text.*;
   
   public class TOverlayerPlayer extends TUIComponent
   {
      
      public static var STAGE_Width:Number = CONST_COMMON.STAGE_Width;
      
      public static var STAGE_Height:Number = CONST_COMMON.STAGE_Height;
      
      protected static const POSITION_HERO_MAPPING:Vector.<uint> = CONST_TEAMBATTLE.POSITION_HERO_MAPPING;
      
      protected static const CAPACITY_HEROS:uint = CONST_TEAMBATTLE.CAPACITY_HEROS;
      
      protected var FTF_Name:TextField;
      
      protected var FTF_Level:TextField;
      
      protected var FTF_KnifeOfKillSoul:TextField;
      
      protected var FTF_FightingPower:TextField;
      
      protected var FBmpHeroIcons:Vector.<Bitmap>;
      
      protected var FTF_HeroNames:Vector.<TextField>;
      
      protected var FQuerySequence:TQueryAnimationSequence;
      
      protected var FBounds:TBounds;
      
      protected var FResource:Sprite;
      
      protected var FContext:TPlayerRoomDigest;
      
      protected var FOnQuerySequenceContext:Function;
      
      public function TOverlayerPlayer(param1:TUIComponent)
      {
         super(param1);
         this.FBounds = new TBounds();
         this.FQuerySequence = new TQueryAnimationSequence();
         this.mouseEnabled = false;
         this.mouseChildren = false;
      }
      
      protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:Sprite = null;
         var _loc4_:Bitmap = null;
         var _loc5_:TextField = null;
         this.FResource.mouseEnabled = false;
         this.FResource.mouseChildren = false;
         this.addChild(this.FResource);
         this.FBounds.Width = this.FResource.width;
         this.FBounds.Height = this.FResource.height;
         this.FTF_Name = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_TF_Nickname];
         this.FTF_Level = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_TF_Level];
         this.FTF_KnifeOfKillSoul = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_TF_KnifeOfKillSoul];
         this.FTF_FightingPower = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_TF_FightingPower];
         this.FBmpHeroIcons = new Vector.<Bitmap>(CAPACITY_HEROS);
         this.FTF_HeroNames = new Vector.<TextField>(CAPACITY_HEROS);
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_HEROS)
         {
            _loc2_ = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_SP_HeroIcon + _loc1_];
            _loc3_ = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_SP_HeroIconPoint];
            _loc4_ = new Bitmap();
            _loc3_.addChild(_loc4_);
            this.FBmpHeroIcons[_loc1_] = _loc4_;
            _loc5_ = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_TF_HeroName + _loc1_];
            this.FTF_HeroNames[_loc1_] = _loc5_;
            _loc1_++;
         }
         this.Reset();
      }
      
      protected function UpdateUI() : void
      {
         var _loc1_:TPlayerRoomDigest = null;
         _loc1_ = this.FContext as TPlayerRoomDigest;
         this.FTF_Name.text = _loc1_.Nickname;
         this.FTF_Level.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_14),_loc1_.Level);
         this.FTF_KnifeOfKillSoul.text = _loc1_.KnifeCaption;
         this.FTF_FightingPower.text = _loc1_.FightingPower.toString();
      }
      
      protected function UpdateBitmaps() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TCollectionHero = null;
         var _loc3_:THero = null;
         var _loc4_:uint = 0;
         var _loc5_:TAnimationSequence = null;
         _loc2_ = this.FContext.Heros;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_HEROS)
         {
            _loc3_ = _loc2_.GetHeroByIndex(_loc1_);
            if(_loc3_ != null)
            {
               _loc4_ = _loc3_.HeadIconID;
               this.FTF_HeroNames[_loc1_].text = _loc3_.Name;
               if(this.FBmpHeroIcons[_loc1_].bitmapData == null)
               {
                  if(this.FOnQuerySequenceContext != null)
                  {
                     this.FQuerySequence.Value = null;
                     this.FOnQuerySequenceContext(this,_loc4_,this.FQuerySequence);
                     _loc5_ = this.FQuerySequence.Value;
                     if(_loc5_ != null)
                     {
                        this.FBmpHeroIcons[_loc1_].bitmapData = _loc5_.GetAnimationFrameByIndex(0).Surface;
                     }
                  }
               }
            }
            _loc1_++;
         }
      }
      
      protected function UpdateUIPosition(param1:TCoordinate) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc4_ = this.FBounds.Width;
         _loc5_ = this.FBounds.Height;
         _loc2_ = param1.X + 50;
         if(_loc2_ + _loc4_ > STAGE_Width)
         {
            _loc2_ -= _loc4_ + 60;
         }
         else
         {
            _loc2_ -= 30;
         }
         _loc3_ = param1.Y;
         if(_loc3_ + _loc5_ + 30 > STAGE_Height)
         {
            _loc3_ = param1.Y - _loc5_;
         }
         if(_loc3_ < 0)
         {
            _loc3_ = param1.Y;
            _loc3_ = param1.Y - (_loc3_ + _loc5_ + 30 - STAGE_Height);
         }
         this.X = _loc2_;
         this.Y = _loc3_;
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
         this.FContext = param1;
         if(param1 != null)
         {
            this.UpdateUI();
         }
      }
      
      public function get OnQuerySequenceContext() : Function
      {
         return this.FOnQuerySequenceContext;
      }
      
      public function set OnQuerySequenceContext(param1:Function) : void
      {
         this.FOnQuerySequenceContext = param1;
      }
      
      public function Perform_UIDispatch() : void
      {
         this.ResourcesPerform_UIDispatch();
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Bitmap = null;
         var _loc3_:TextField = null;
         this.FTF_Name.text = "";
         this.FTF_Level.text = "";
         this.FTF_KnifeOfKillSoul.text = "";
         this.FTF_FightingPower.text = "";
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_HEROS)
         {
            _loc2_ = this.FBmpHeroIcons[_loc1_];
            if(_loc2_.bitmapData != null)
            {
               _loc2_.bitmapData = null;
            }
            this.FTF_HeroNames[_loc1_].text = "";
            _loc1_++;
         }
      }
      
      public function Show() : void
      {
         this.Visible = true;
      }
      
      public function Hide() : void
      {
         this.Visible = false;
      }
      
      public function Render(param1:TCoordinate) : void
      {
         this.UpdateUIPosition(param1);
      }
      
      public function Update() : void
      {
         this.UpdateBitmaps();
      }
   }
}

