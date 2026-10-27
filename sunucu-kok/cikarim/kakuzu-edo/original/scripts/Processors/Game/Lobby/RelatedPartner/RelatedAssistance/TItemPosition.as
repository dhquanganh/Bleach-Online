package Processors.Game.Lobby.RelatedPartner.RelatedAssistance
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.Utilities.TUtilityFilter;
   import Logics.Characters.THeros;
   import Logics.RelatedPartner.TRelatedPartnerHero;
   import Processors.Game.Lobby.RelatedPartner.TRelatedPartnerCommon;
   import Resources.Constants.CONST_RELATEDPARTNER;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TItemPosition
   {
      
      protected static const Assistance_Hero_Num:int = CONST_RELATEDPARTNER.Assistance_Hero_Num;
      
      protected var FMainUI:Sprite;
      
      protected var FMountPoint:Bitmap;
      
      protected var FHeroId:int;
      
      protected var FHeads:Vector.<Bitmap>;
      
      protected var FLights:Vector.<Sprite>;
      
      protected var FEffect:MovieClip;
      
      protected var FHeroEffect:MovieClip;
      
      protected var FHeroData:TRelatedPartnerHero;
      
      protected var FHeadIds:Vector.<int>;
      
      protected var FHeadSps:Vector.<Sprite>;
      
      protected var FOnOver:Function;
      
      protected var FOnOut:Function;
      
      protected var FOnHeroOver:Function;
      
      protected var FOnHeroOut:Function;
      
      public function TItemPosition(param1:Sprite)
      {
         var _loc2_:int = 0;
         var _loc3_:Bitmap = null;
         super();
         this.FMainUI = param1;
         this.FHeadSps = new Vector.<Sprite>(Assistance_Hero_Num);
         this.FHeads = new Vector.<Bitmap>(Assistance_Hero_Num);
         this.FLights = new Vector.<Sprite>(Assistance_Hero_Num);
         _loc2_ = 0;
         while(_loc2_ < Assistance_Hero_Num)
         {
            this.FHeads[_loc2_] = new Bitmap();
            this.FHeadSps[_loc2_] = this.FMainUI["MC_Icon_" + _loc2_]["MC_Pos"];
            this.FHeadSps[_loc2_].addChild(this.FHeads[_loc2_]);
            this.FHeadSps[_loc2_].addEventListener(MouseEvent.MOUSE_MOVE,this.HeroOnOver);
            this.FHeadSps[_loc2_].addEventListener(MouseEvent.MOUSE_OUT,this.HeroOnOut);
            this.FLights[_loc2_] = this.FMainUI["MC_Icon_" + _loc2_]["MC_Light"];
            this.FLights[_loc2_].mouseChildren = false;
            this.FLights[_loc2_].mouseEnabled = false;
            this.FLights[_loc2_].visible = false;
            _loc2_++;
         }
         this.FMountPoint = new Bitmap();
         this.FMainUI["MC_Icon"]["MC_Pos"].addChild(this.FMountPoint);
         this.FMainUI["MC_Icon"]["MC_Pos"].addEventListener(MouseEvent.MOUSE_MOVE,this.HeadOnOver);
         this.FMainUI["MC_Icon"]["MC_Pos"].addEventListener(MouseEvent.MOUSE_OUT,this.HeadOnOut);
         this.FEffect = this.FMainUI["MC_Icon"]["MC_Effect"];
         this.FEffect.visible = false;
         this.FEffect.mouseChildren = false;
         this.FEffect.mouseEnabled = false;
         this.FHeroEffect = this.FMainUI["MC_HeroEffect"];
         this.FHeroEffect.visible = false;
         this.FHeroEffect.mouseChildren = false;
         this.FHeroEffect.mouseEnabled = false;
         this.FHeadIds = new Vector.<int>(Assistance_Hero_Num);
      }
      
      protected function PicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(param3 == this.FHeroId)
         {
            this.FMountPoint.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
         }
         else
         {
            _loc5_ = int(this.FHeroData.HeroSkills.length);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               if(this.FHeroData.HeroSkills[_loc4_].Partner.ConnectId == param3)
               {
                  _loc6_ = _loc4_;
                  break;
               }
               _loc4_++;
            }
            this.FHeads[_loc6_].bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
         }
      }
      
      protected function HeroOnOver(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc2_ = param1.target as Sprite;
         _loc3_ = this.FHeadSps.indexOf(_loc2_);
         if(_loc3_ > -1)
         {
            _loc4_ = this.FHeadIds[_loc3_];
         }
         if(this.FOnHeroOver != null)
         {
            this.FOnHeroOver(this,_loc4_);
         }
      }
      
      protected function HeroOnOut(param1:MouseEvent) : void
      {
         if(this.FOnHeroOut != null)
         {
            this.FOnHeroOut(this);
         }
      }
      
      protected function HeadOnOver(param1:MouseEvent) : void
      {
         if(this.FOnOver != null)
         {
            this.FOnOver(this,this.FHeroId);
         }
      }
      
      protected function HeadOnOut(param1:MouseEvent) : void
      {
         if(this.FOnOut != null)
         {
            this.FOnOut(this);
         }
      }
      
      public function get OnOver() : Function
      {
         return this.FOnOver;
      }
      
      public function set OnOver(param1:Function) : void
      {
         this.FOnOver = param1;
      }
      
      public function get OnOut() : Function
      {
         return this.FOnOut;
      }
      
      public function set OnOut(param1:Function) : void
      {
         this.FOnOut = param1;
      }
      
      public function get OnHeroOver() : Function
      {
         return this.FOnHeroOver;
      }
      
      public function set OnHeroOver(param1:Function) : void
      {
         this.FOnHeroOver = param1;
      }
      
      public function get OnHeroOut() : Function
      {
         return this.FOnHeroOut;
      }
      
      public function set OnHeroOut(param1:Function) : void
      {
         this.FOnHeroOut = param1;
      }
      
      public function Render(param1:TRelatedPartnerHero) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:THeros = null;
         var _loc6_:int = 0;
         this.FHeroData = param1;
         if(param1 == null)
         {
            this.FMountPoint.bitmapData = null;
            _loc2_ = 0;
            while(_loc2_ < Assistance_Hero_Num)
            {
               this.FHeads[_loc2_].bitmapData = null;
               this.FLights[_loc2_].visible = false;
               _loc2_++;
            }
            return;
         }
         this.FHeroId = param1.HeroId;
         SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(this.FHeroId,this.PicArrive);
         this.FHeadIds.length = 0;
         _loc5_ = TRelatedPartnerCommon.GetRelatedHeros();
         _loc3_ = int(param1.HeroSkills.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = this.FHeroData.HeroSkills[_loc2_].Partner.ConnectId;
            SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc6_,this.PicArrive);
            this.FHeadIds[_loc2_] = this.FHeroData.HeroSkills[_loc2_].Partner.ConnectId;
            if(this.FHeroData.HeroSkills[_loc2_].SkillId == 0)
            {
               this.FHeads[_loc2_].filters = [TUtilityFilter.GaryColorFiltersMask];
               this.FLights[_loc2_].visible = false;
               _loc4_ = true;
            }
            else
            {
               this.FHeads[_loc2_].filters = [];
               if(_loc5_.GetHeroByIdentifier(_loc6_) == null)
               {
                  this.FLights[_loc2_].visible = false;
                  _loc4_ = true;
               }
               else
               {
                  this.FLights[_loc2_].visible = true;
               }
            }
            _loc2_++;
         }
         while(_loc2_ < Assistance_Hero_Num)
         {
            this.FHeads[_loc2_].bitmapData = null;
            this.FLights[_loc2_].visible = false;
            _loc2_++;
         }
         if(!_loc4_)
         {
            this.FEffect.play();
            this.FHeroEffect.play();
            this.FEffect.visible = true;
            this.FHeroEffect.visible = true;
         }
         else
         {
            this.FEffect.stop();
            this.FHeroEffect.stop();
            this.FEffect.visible = false;
            this.FHeroEffect.visible = false;
         }
      }
   }
}

