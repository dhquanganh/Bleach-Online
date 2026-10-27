package Processors.Game.Lobby.SkyTower.Components
{
   import Foundation.Common.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.SLogicsCore;
   import Logics.SkyTower.*;
   import Processors.Game.Lobby.Components.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.text.*;
   
   public class TUIPlayer extends TUIComponent
   {
      
      protected var FUIHero:TUIHero;
      
      protected var FSP_RoleTitle:Sprite;
      
      protected var FTF_Level:TextField;
      
      protected var FTF_Nickname:TextField;
      
      protected var FResource:Sprite;
      
      protected var FContext:TLayer;
      
      protected var FOnQuerySequenceContext:Function;
      
      public function TUIPlayer(param1:TUIComponent)
      {
         super(param1);
         this.FUIHero = new TUIHero(null);
         this.FUIHero.OnQuerySequenceContext = this.HeroOnQuerySequenceContext;
      }
      
      protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:TBounds = null;
         var _loc4_:TCoordinate = null;
         if(this.FResource == null)
         {
            return;
         }
         this.FResource.mouseEnabled = false;
         this.FResource.mouseChildren = false;
         this.FSP_RoleTitle = this.FResource[CONST_SKYTOWER.RESOURCE_Link_SP_RoleTitle];
         this.FTF_Level = this.FSP_RoleTitle[CONST_SKYTOWER.RESOURCE_Link_TF_Level];
         this.FTF_Nickname = this.FSP_RoleTitle[CONST_SKYTOWER.RESOURCE_Link_TF_Nickname];
         if(FTag != CONST_SKYTOWER.TAG_SKYTOWER_SELF)
         {
            this.FUIHero.scaleX = -1;
         }
         _loc2_ = this.FResource[CONST_SKYTOWER.RESOURCE_Link_SP_MountPoint];
         _loc2_.addChild(this.FUIHero);
         _loc3_ = new TBounds();
         _loc4_ = new TCoordinate();
         this.FUIHero.SequenceDefaultRole.Evaluate(_loc4_,_loc3_);
         this.FUIHero.X = _loc3_.X;
         this.FUIHero.Y = _loc3_.Y;
         this.Reset();
      }
      
      protected function addEventListenerPlayer() : void
      {
         if(this.FResource == null)
         {
            return;
         }
      }
      
      protected function RemoveEventListenerPlayer() : void
      {
         if(this.FResource == null)
         {
            return;
         }
      }
      
      protected function UpdateUIPlayer() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:String = null;
         if(this.FResource == null)
         {
            return;
         }
         this.FSP_RoleTitle.visible = true;
         _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_02);
         if(FTag == CONST_SKYTOWER.TAG_SKYTOWER_SELF)
         {
            this.FTF_Level.text = TUtilityString.Format(_loc2_,SLogicsCore.Character.GetMainRebirthLevel());
            this.FTF_Nickname.text = SLogicsCore.Character.NickName;
         }
         else
         {
            this.FTF_Level.text = TUtilityString.Format(_loc2_,this.FContext.PveLevel);
            this.FTF_Nickname.text = this.FContext.PveNickname;
         }
      }
      
      protected function HeroOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:TBounds = null;
         var _loc7_:TCoordinate = null;
         if(this.FOnQuerySequenceContext != null)
         {
            if(FTag == CONST_SKYTOWER.TAG_SKYTOWER_SELF)
            {
               _loc5_ = this.FContext.PveRoleTempleteID;
               this.FContext.PveRoleTempleteID = SLogicsCore.Character.GetMainHero().Identifier;
               this.FOnQuerySequenceContext(param1,this.FContext,param3,param4);
               this.FContext.PveRoleTempleteID = _loc5_;
            }
            else
            {
               this.FOnQuerySequenceContext(param1,param2,param3,param4);
            }
            if(param3.Value != null)
            {
               _loc6_ = new TBounds();
               _loc7_ = new TCoordinate();
               param3.Value.Evaluate(_loc7_,_loc6_);
               if(this.FUIHero.scaleX == -1)
               {
                  this.FUIHero.X = Math.abs(_loc6_.X);
               }
               else
               {
                  this.FUIHero.X = _loc6_.X;
               }
               this.FUIHero.Y = _loc6_.Y;
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
      
      public function get Context() : TLayer
      {
         return this.FContext;
      }
      
      public function set Context(param1:TLayer) : void
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
         if(param1 != null)
         {
            this.UpdateUIPlayer();
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
      
      public function get SequenceDefaultRole() : TAnimationSequence
      {
         return this.FUIHero.SequenceDefaultRole;
      }
      
      public function set SequenceDefaultRole(param1:TAnimationSequence) : void
      {
         if(param1 != null)
         {
            this.FUIHero.SequenceDefaultRole = param1;
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
      
      override public function Dispose() : void
      {
         this.FSP_RoleTitle = null;
         this.FTF_Level = null;
         this.FTF_Nickname = null;
         this.FOnQuerySequenceContext = null;
         this.FUIHero.Dispose();
         this.FUIHero = null;
         this.FResource = null;
         if(this.Parent != null)
         {
            this.Parent.removeChild(this);
         }
      }
      
      public function Reset() : void
      {
         if(this.FResource == null)
         {
            return;
         }
         this.FTF_Level.text = "";
         this.FTF_Nickname.text = "";
         this.FSP_RoleTitle.visible = false;
      }
      
      public function Update() : void
      {
         this.FUIHero.Update();
      }
      
      public function HideRoleTitle() : void
      {
         this.FSP_RoleTitle.visible = false;
      }
   }
}

