package Processors.Game.Lobby.SevenKing.Component
{
   import Foundation.Common.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Logics.DatebaseVO.VO.*;
   import Processors.Game.Lobby.Components.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   
   public class TPillar extends TUIComponent
   {
      
      protected var FMC_Passed:Sprite;
      
      protected var FMC_RolePoint:Sprite;
      
      protected var FUIHero:TUIHero;
      
      protected var FScence:Sprite;
      
      protected var FHeroID:uint;
      
      protected var FOnPillarMove:Function;
      
      protected var FOnPillarOut:Function;
      
      protected var FIsPass:Boolean;
      
      protected var FModelId:uint;
      
      public function TPillar(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function UIDispatch() : void
      {
         var _loc1_:TBounds = null;
         var _loc2_:TCoordinate = null;
         this.FMC_Passed = this.FScence["MC_Passed"];
         this.FMC_Passed.mouseEnabled = false;
         this.FMC_Passed.mouseChildren = false;
         this.FMC_Passed.visible = false;
         this.FMC_RolePoint = this.FScence["MC_Hero"]["MC_RolePoint"];
         this.FUIHero = new TUIHero(this);
         this.FMC_RolePoint.addChild(this.FUIHero);
         this.FUIHero.OnQuerySequenceContext = this.HeroOnQuerySequenceContext;
         this.FUIHero.SequenceDefaultRole = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCEID_Textures_DefaultRole,0);
         _loc1_ = new TBounds();
         _loc2_ = new TCoordinate();
         this.FUIHero.SequenceDefaultRole.Evaluate(_loc2_,_loc1_);
         this.FUIHero.X = _loc1_.X;
         this.FUIHero.Y = _loc1_.Y;
         this.FMC_RolePoint.addEventListener(MouseEvent.MOUSE_MOVE,this.PillarOnMove,false,0,true);
         this.FMC_RolePoint.addEventListener(MouseEvent.MOUSE_OUT,this.PillarOnOut,false,0,true);
      }
      
      protected function HeroOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         var _loc8_:TBounds = null;
         var _loc9_:TCoordinate = null;
         var _loc10_:TRoleModel = null;
         var _loc11_:uint = 0;
         _loc5_ = param2 as uint;
         _loc6_ = SResourcesCore.TexturesModel;
         _loc10_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,_loc5_) as TRoleModel;
         this.FModelId = CONST_ROLE.GetModelIDByIndex(_loc10_.Model,CONST_ROLE.ROLE_SEQUENCEINDEX_Showcase);
         _loc7_ = _loc6_.GetTextureByIdentifier(this.FModelId);
         if(_loc7_ != null)
         {
            _loc8_ = new TBounds();
            _loc9_ = new TCoordinate();
            param3.Value = _loc7_.GetAnimationSequenceByIndex(0);
            param3.Value.Evaluate(_loc9_,_loc8_);
            this.FUIHero.X = _loc8_.X;
            this.FUIHero.Y = _loc8_.Y;
         }
         else
         {
            _loc6_.LoadSecondary(this.FModelId);
         }
      }
      
      protected function PillarOnMove(param1:MouseEvent) : void
      {
         if(this.FOnPillarMove != null)
         {
            this.FOnPillarMove(this,Tag);
         }
      }
      
      protected function PillarOnOut(param1:MouseEvent) : void
      {
         if(this.FOnPillarOut != null)
         {
            this.FOnPillarOut(this);
         }
      }
      
      public function get Scence() : Sprite
      {
         return this.FScence;
      }
      
      public function set Scence(param1:Sprite) : void
      {
         this.FScence = param1;
      }
      
      public function get OnPillarMove() : Function
      {
         return this.FOnPillarMove;
      }
      
      public function set OnPillarMove(param1:Function) : void
      {
         this.FOnPillarMove = param1;
      }
      
      public function get OnPillarOut() : Function
      {
         return this.FOnPillarOut;
      }
      
      public function set OnPillarOut(param1:Function) : void
      {
         this.FOnPillarOut = param1;
      }
      
      public function get HeroID() : uint
      {
         return this.FHeroID;
      }
      
      public function set HeroID(param1:uint) : void
      {
         this.FHeroID = param1;
         this.FUIHero.Context = param1;
      }
      
      public function get IsPass() : Boolean
      {
         return this.FIsPass;
      }
      
      public function set IsPass(param1:Boolean) : void
      {
         this.FIsPass = param1;
      }
      
      public function Init() : void
      {
         this.UIDispatch();
      }
      
      public function UpdateHero() : void
      {
         this.FUIHero.Update();
         if(this.FScence.alpha == 0)
         {
            if(!this.FScence.visible)
            {
               return;
            }
            this.FScence.visible = false;
         }
         else
         {
            if(this.FScence.visible)
            {
               return;
            }
            this.FScence.visible = true;
         }
      }
      
      public function IsPassed(param1:Boolean) : void
      {
         if(param1)
         {
            this.FMC_Passed.visible = true;
         }
         else
         {
            this.FMC_Passed.visible = false;
         }
      }
      
      public function Reset() : void
      {
         this.FUIHero.Context = null;
         SResourcesCore.TexturesModel.DeleteByIdentifier(this.FModelId,true);
      }
   }
}

