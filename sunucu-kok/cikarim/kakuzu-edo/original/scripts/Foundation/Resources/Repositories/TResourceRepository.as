package Foundation.Resources.Repositories
{
   import Debugging.*;
   import Foundation.Common.*;
   import Foundation.Resources.Common.*;
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Resources.Streamization.*;
   import flash.net.*;
   
   use namespace ResourcesSpace;
   
   public class TResourceRepository
   {
      
      protected static const TYPE_Primary:uint = TResourceLoader.TYPE_Primary;
      
      protected static const TYPE_Secondary:uint = TResourceLoader.TYPE_Secondary;
      
      protected var FPoolResourceRequest:TPoolResourceRequest;
      
      protected var FLoaderPrimary:TResourceLoader;
      
      protected var FLoaderSecondary:TResourceLoader;
      
      protected var FKnownIdentifiers:Vector.<uint>;
      
      protected var FResourcePath:String;
      
      protected var FAutoLoadResourceID:Vector.<uint>;
      
      protected var FAutoLoadCallBacks:Vector.<Function>;
      
      protected var FPriority:uint;
      
      protected var FInstanceType:String;
      
      protected var FResources:TEntityList;
      
      public function TResourceRepository(param1:String, param2:uint)
      {
         super();
         this.FResourcePath = param1;
         this.FPriority = param2;
         this.FPoolResourceRequest = new TPoolResourceRequest();
         this.ConstructLoaders();
         this.FKnownIdentifiers = new Vector.<uint>();
         this.FResources = new TEntityList();
         this.FAutoLoadResourceID = new Vector.<uint>();
         this.FAutoLoadCallBacks = new Vector.<Function>();
         this.FInstanceType = "";
      }
      
      protected function ConstructLoaders() : void
      {
      }
      
      protected function ProcessorLoadFailedResources(param1:Object, param2:uint) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FKnownIdentifiers.indexOf(param2);
         if(_loc3_ >= 0)
         {
            this.FKnownIdentifiers.splice(_loc3_,1);
         }
         _loc3_ = this.FAutoLoadResourceID.indexOf(param2);
         if(_loc3_ >= 0)
         {
            this.FAutoLoadResourceID.splice(_loc3_,1);
            this.FAutoLoadCallBacks.splice(_loc3_,1);
         }
      }
      
      protected function UpdateAutoLoad() : void
      {
      }
      
      protected function GetClassType() : String
      {
         return this.FInstanceType;
      }
      
      protected function LoadersOnResourceUnstreamized(param1:Object, param2:TResource) : void
      {
         this.FResources.Add(param2);
      }
      
      ResourcesSpace function get KnownIdentifiers() : Vector.<uint>
      {
         return this.FKnownIdentifiers;
      }
      
      public function get PrimaryCount() : int
      {
         return this.FLoaderPrimary.Count;
      }
      
      public function get SecondaryCount() : int
      {
         return this.FLoaderSecondary.Count;
      }
      
      public function get Loading() : Boolean
      {
         return this.LoadingPrimary || this.LoadingSecondary;
      }
      
      public function get LoadingPrimary() : Boolean
      {
         return this.FLoaderPrimary.Count != 0;
      }
      
      public function get LoadingSecondary() : Boolean
      {
         return this.FLoaderSecondary.Count != 0;
      }
      
      public function get Priority() : uint
      {
         return this.FPriority;
      }
      
      public function set Priority(param1:uint) : void
      {
         this.FPriority = param1;
      }
      
      public function get CurrentPercentage() : uint
      {
         return this.FLoaderPrimary.CurrentPercentage;
      }
      
      public function get CurrentKbps() : uint
      {
         return this.FLoaderPrimary.CurrentKbps;
      }
      
      public function get InstanceType() : String
      {
         return this.FInstanceType;
      }
      
      public function set InstanceType(param1:String) : void
      {
         this.FInstanceType = param1;
      }
      
      public function Process() : void
      {
         this.FLoaderPrimary.Process();
         this.FLoaderSecondary.Process();
         this.UpdateAutoLoad();
      }
      
      public function LoadPrimary(param1:uint) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FKnownIdentifiers.indexOf(param1);
         if(_loc2_ >= 0)
         {
            return;
         }
         this.FKnownIdentifiers.push(param1);
         this.FLoaderPrimary.Load(param1);
      }
      
      public function LoadSecondary(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:uint = 0;
         _loc2_ = this.FKnownIdentifiers.indexOf(param1);
         if(_loc2_ >= 0)
         {
            return;
         }
         this.FKnownIdentifiers.push(param1);
         this.FLoaderSecondary.Load(param1);
      }
      
      public function LoadAutoPrimary(param1:uint, param2:Function) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Function = null;
         _loc3_ = this.FAutoLoadResourceID.indexOf(param1);
         if(_loc3_ >= 0)
         {
            _loc4_ = this.FAutoLoadCallBacks[_loc3_];
            if(_loc4_ == param2)
            {
               return;
            }
         }
         this.FAutoLoadResourceID.push(param1);
         this.FAutoLoadCallBacks.push(param2);
         this.LoadPrimary(param1);
      }
      
      public function LoadAutoSecondary(param1:uint, param2:Function) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Function = null;
         _loc3_ = this.FAutoLoadResourceID.indexOf(param1);
         if(_loc3_ >= 0)
         {
            _loc4_ = this.FAutoLoadCallBacks[_loc3_];
            if(_loc4_ == param2)
            {
               return;
            }
         }
         this.FAutoLoadResourceID.push(param1);
         this.FAutoLoadCallBacks.push(param2);
         this.LoadSecondary(param1);
      }
      
      public function DeleteByIdentifier(param1:uint, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FKnownIdentifiers.indexOf(param1);
         if(_loc3_ < 0)
         {
            return;
         }
         this.FKnownIdentifiers.splice(_loc3_,1);
      }
   }
}

