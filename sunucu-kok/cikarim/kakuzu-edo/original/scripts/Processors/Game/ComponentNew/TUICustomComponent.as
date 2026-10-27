package Processors.Game.ComponentNew
{
   import Foundation.Queries.Textures.TQueryAnimationSequence;
   import Foundation.Resources.Repositories.TResourceRepositoryTexture;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Logics.Inventories.TInventory;
   import flash.display.*;
   
   public class TUICustomComponent
   {
      
      protected var FInitialization:Boolean;
      
      protected var FParent:TUIComponent;
      
      protected var FResource:MovieClip;
      
      protected var FUserData:Object;
      
      protected var FEnabled:Boolean;
      
      protected var FTag:uint;
      
      public function TUICustomComponent()
      {
         super();
         this.FEnabled = true;
         this.FInitialization = false;
      }
      
      public static function GetUIComponentsCapacity(param1:DisplayObject, param2:String) : int
      {
         var _loc3_:* = 0;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         while(true)
         {
            _loc4_ = param1[param2 + _loc3_++];
            if(_loc4_ == null)
            {
               break;
            }
            _loc5_++;
         }
         return _loc5_;
      }
      
      protected function ResourcesPerform_UIDispatch() : void
      {
         if(this.FResource.totalFrames > 1)
         {
            this.FResource.stop();
         }
         this.FInitialization = true;
      }
      
      protected function AddEventListener() : void
      {
      }
      
      protected function RemoveEventListener() : void
      {
      }
      
      protected function AddAllEventListener() : void
      {
         this.AddEventListener();
      }
      
      protected function RemoveAllEventListener() : void
      {
         this.RemoveEventListener();
      }
      
      protected function SetAddEventListener(param1:DisplayObject, param2:String, param3:Function, param4:Boolean = false, param5:int = 0, param6:Boolean = true) : void
      {
         if(!param1.hasEventListener(param2))
         {
            param1.addEventListener(param2,param3,param4,param5,param6);
         }
      }
      
      protected function SetRemoveEventListener(param1:DisplayObject, param2:String, param3:Function) : void
      {
         if(param1.hasEventListener(param2))
         {
            param1.removeEventListener(param2,param3);
         }
      }
      
      protected function SetButtonMode(param1:Boolean) : void
      {
         if(this.FResource.buttonMode != param1)
         {
            this.FResource.buttonMode = param1;
         }
      }
      
      protected function UpdateUI() : void
      {
      }
      
      protected function OnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TInventory = null;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         _loc5_ = param2 as TInventory;
         _loc6_ = SResourcesCore.TexturesInventory;
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc5_.IDTexture);
         if(_loc7_ != null)
         {
            param3.Value = _loc7_.GetAnimationSequenceByIdentifier(param4);
         }
         else
         {
            _loc6_.LoadSecondary(_loc5_.IDTexture);
         }
      }
      
      public function get X() : int
      {
         return this.FResource.x;
      }
      
      public function set X(param1:int) : void
      {
         this.FResource.x = param1;
      }
      
      public function get Y() : int
      {
         return this.FResource.y;
      }
      
      public function set Y(param1:int) : void
      {
         this.FResource.y = param1;
      }
      
      public function get Width() : int
      {
         return this.FResource.width;
      }
      
      public function get Height() : int
      {
         return this.FResource.height;
      }
      
      public function get Visible() : Boolean
      {
         if(!this.FInitialization)
         {
            return false;
         }
         return this.FResource.visible;
      }
      
      public function set Visible(param1:Boolean) : void
      {
         if(this.FResource.visible != param1)
         {
            this.FResource.visible = param1;
            if(param1)
            {
               this.AddAllEventListener();
            }
            else
            {
               this.RemoveAllEventListener();
            }
         }
      }
      
      public function get Alpha() : Number
      {
         return this.FResource.alpha;
      }
      
      public function set Alpha(param1:Number) : void
      {
         if(this.FResource.alpha != param1)
         {
            this.FResource.alpha = param1;
         }
      }
      
      public function get Enabled() : Boolean
      {
         return this.FEnabled;
      }
      
      public function set Enabled(param1:Boolean) : void
      {
         if(!this.FInitialization)
         {
            return;
         }
         if(param1)
         {
            this.AddEventListener();
         }
         else
         {
            this.RemoveEventListener();
         }
         this.FEnabled = param1;
      }
      
      public function get Resource() : MovieClip
      {
         return this.FResource;
      }
      
      public function set Resource(param1:MovieClip) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1 != this.FResource)
         {
            this.FResource = param1;
         }
         if(!this.FInitialization)
         {
            this.ResourcesPerform_UIDispatch();
            this.Reset();
         }
      }
      
      public function get Parent() : TUIComponent
      {
         return this.FParent;
      }
      
      public function set Parent(param1:TUIComponent) : void
      {
         this.FParent = param1;
      }
      
      public function get Tag() : uint
      {
         return this.FTag;
      }
      
      public function set Tag(param1:uint) : void
      {
         this.FTag = param1;
      }
      
      public function get UserData() : Object
      {
         return this.FUserData;
      }
      
      public function set UserData(param1:Object) : void
      {
         this.FUserData = param1;
      }
      
      public function Reset() : void
      {
         this.FTag = 0;
         this.FUserData = null;
      }
      
      public function Dispose() : void
      {
         this.FResource = null;
         this.FParent = null;
         this.FUserData = null;
      }
      
      public function Update() : void
      {
         this.UpdateUI();
      }
      
      public function Show() : void
      {
         this.Update();
         this.Visible = true;
      }
      
      public function Hide() : void
      {
         this.Reset();
         this.Visible = false;
      }
   }
}

