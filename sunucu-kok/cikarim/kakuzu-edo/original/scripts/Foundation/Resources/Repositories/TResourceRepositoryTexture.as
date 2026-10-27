package Foundation.Resources.Repositories
{
   import Foundation.Common.*;
   import Foundation.Resources.Streamization.Textures.*;
   import Foundation.Resources.Textures.*;
   
   public class TResourceRepositoryTexture extends TResourceRepository
   {
      
      public function TResourceRepositoryTexture(param1:String, param2:uint)
      {
         super(param1,param2);
      }
      
      override protected function ConstructLoaders() : void
      {
         FLoaderPrimary = new TResourceLoaderTexture(FResourcePath,".TexClient",FPoolResourceRequest,TYPE_Primary,FPriority);
         FLoaderPrimary.OnResourceUnstreamized = LoadersOnResourceUnstreamized;
         FLoaderPrimary.OnLoadFailedResource = ProcessorLoadFailedResources;
         FLoaderSecondary = new TResourceLoaderTexture(FResourcePath,".TexClient",FPoolResourceRequest,TYPE_Secondary,FPriority + 100);
         FLoaderSecondary.OnResourceUnstreamized = LoadersOnResourceUnstreamized;
         FLoaderSecondary.OnLoadFailedResource = ProcessorLoadFailedResources;
      }
      
      override protected function UpdateAutoLoad() : void
      {
         var _loc1_:* = 0;
         var _loc2_:TResourceRepositoryTexture = null;
         var _loc3_:TTexture = null;
         var _loc4_:Function = null;
         var _loc5_:uint = 0;
         _loc1_ = int(FAutoLoadResourceID.length - 1);
         while(_loc1_ >= 0)
         {
            _loc5_ = FAutoLoadResourceID[_loc1_];
            _loc3_ = this.GetTextureByIdentifier(_loc5_);
            if(_loc3_ != null)
            {
               _loc4_ = FAutoLoadCallBacks[_loc1_];
               FAutoLoadResourceID.splice(_loc1_,1);
               FAutoLoadCallBacks.splice(_loc1_,1);
               if(_loc4_ != null)
               {
                  _loc4_(this,_loc3_,_loc5_);
               }
            }
            _loc1_--;
         }
      }
      
      public function GetTextureByIdentifier(param1:uint) : TTexture
      {
         var _loc2_:TTexture = null;
         _loc2_ = FResources.GetEntityByIdentifier(param1) as TTexture;
         if(_loc2_ != null)
         {
            ++_loc2_.Reference;
         }
         return _loc2_;
      }
      
      public function GetAnimationSequenceByIdentifiers(param1:uint, param2:uint) : TAnimationSequence
      {
         var _loc3_:TTexture = null;
         _loc3_ = FResources.GetEntityByIdentifier(param1) as TTexture;
         if(_loc3_ != null)
         {
            ++_loc3_.Reference;
            return _loc3_.GetAnimationSequenceByIdentifier(param2);
         }
         return null;
      }
      
      override public function DeleteByIdentifier(param1:uint, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TTexture = null;
         _loc4_ = FResources.GetEntityByIdentifier(param1) as TTexture;
         if(_loc4_ == null)
         {
            return;
         }
         --_loc4_.Reference;
         if(!param2)
         {
            if(_loc4_.Reference > 0)
            {
               return;
            }
         }
         _loc3_ = FResources.IndexOf(_loc4_);
         FResources.Delete(_loc3_);
         _loc4_.Clear();
         super.DeleteByIdentifier(param1);
      }
   }
}

