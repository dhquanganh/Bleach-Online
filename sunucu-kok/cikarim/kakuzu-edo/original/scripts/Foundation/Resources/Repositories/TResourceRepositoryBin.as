package Foundation.Resources.Repositories
{
   import Foundation.Common.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Common.*;
   import Foundation.Resources.Spaces.*;
   import Foundation.Resources.Streamization.Bin.*;
   import Logics.DatebaseVO.*;
   
   use namespace ResourcesSpace;
   
   public class TResourceRepositoryBin extends TResourceRepository
   {
      
      protected var FLoaderPackagePrimary:TResourceLoaderBinPackage;
      
      protected var FLoaderPackageSecondary:TResourceLoaderBinPackage;
      
      protected var FKnownPackageIdentifiers:Vector.<uint>;
      
      public function TResourceRepositoryBin(param1:String, param2:uint)
      {
         super(param1,param2);
         this.FKnownPackageIdentifiers = new Vector.<uint>();
      }
      
      override protected function ConstructLoaders() : void
      {
         FLoaderPrimary = new TResourceLoaderBin(FResourcePath,".bin",FPoolResourceRequest,TYPE_Primary,FPriority);
         FLoaderPrimary.OnResourceUnstreamized = this.LoadersOnResourceUnstreamized;
         FLoaderPrimary.OnLoadFailedResource = ProcessorLoadFailedResources;
         FLoaderSecondary = new TResourceLoaderBin(FResourcePath,".bin",FPoolResourceRequest,TYPE_Secondary,FPriority + 100);
         FLoaderSecondary.OnResourceUnstreamized = this.LoadersOnResourceUnstreamized;
         this.FLoaderPackagePrimary = new TResourceLoaderBinPackage(FResourcePath,".binPackage",FPoolResourceRequest,TYPE_Primary,FPriority);
         this.FLoaderPackagePrimary.OnResourceUnstreamized = this.LoadersOnResourceUnstreamized;
         this.FLoaderPackageSecondary = new TResourceLoaderBinPackage(FResourcePath,".binPackage",FPoolResourceRequest,TYPE_Secondary,FPriority + 100);
         FLoaderSecondary.OnLoadFailedResource = ProcessorLoadFailedResources;
      }
      
      override protected function LoadersOnResourceUnstreamized(param1:Object, param2:TResource) : void
      {
         var _loc3_:TBins = null;
         _loc3_ = param2 as TBins;
         FResources.Add(_loc3_);
      }
      
      override public function get PrimaryCount() : int
      {
         return FLoaderPrimary.Count + this.FLoaderPackagePrimary.Count;
      }
      
      override public function get SecondaryCount() : int
      {
         return FLoaderSecondary.Count + this.FLoaderPackageSecondary.Count;
      }
      
      override public function get LoadingPrimary() : Boolean
      {
         var _loc1_:int = 0;
         _loc1_ = FLoaderPrimary.Count + this.FLoaderPackagePrimary.Count;
         return _loc1_ != 0;
      }
      
      override public function get LoadingSecondary() : Boolean
      {
         var _loc1_:int = 0;
         _loc1_ = FLoaderSecondary.Count + this.FLoaderPackageSecondary.Count;
         return _loc1_ != 0;
      }
      
      override public function Process() : void
      {
         super.Process();
         this.FLoaderPackagePrimary.Process();
         this.FLoaderPackageSecondary.Process();
      }
      
      public function LoadPackagePrimary(param1:uint) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FKnownPackageIdentifiers.indexOf(param1);
         if(_loc2_ >= 0)
         {
            return;
         }
         this.FKnownPackageIdentifiers.push(param1);
         this.FLoaderPackagePrimary.Load(param1);
      }
      
      public function LoadPackageSecondary(param1:uint) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FKnownPackageIdentifiers.indexOf(param1);
         if(_loc2_ >= 0)
         {
            return;
         }
         this.FKnownPackageIdentifiers.push(param1);
         this.FLoaderPackageSecondary.Load(param1);
      }
      
      public function GetDatebase(param1:uint, param2:uint) : TDatebaseVO
      {
         var _loc3_:TBins = null;
         _loc3_ = this.GetBinsByResourceID(param1);
         return _loc3_.GetDatebaseByIdentifier(param2);
      }
      
      public function GetBinsByResourceID(param1:uint) : TBins
      {
         return FResources.GetEntityByIdentifier(param1) as TBins;
      }
      
      override public function DeleteByIdentifier(param1:uint, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TBins = null;
         _loc4_ = FResources.GetEntityByIdentifier(param1) as TBins;
         if(_loc4_ == null)
         {
            return;
         }
         _loc3_ = FResources.IndexOf(_loc4_);
         FResources.Delete(_loc3_);
         _loc4_.Clear();
         _loc4_ = null;
         super.DeleteByIdentifier(param1);
      }
   }
}

