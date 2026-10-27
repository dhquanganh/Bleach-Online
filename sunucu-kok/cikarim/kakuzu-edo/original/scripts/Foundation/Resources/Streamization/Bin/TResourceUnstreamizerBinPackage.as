package Foundation.Resources.Streamization.Bin
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.Common.TResource;
   import Foundation.Resources.Common.TResourceRequest;
   import Foundation.Resources.Streamization.TResourceUnstreamizerAsynchronous;
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   
   public class TResourceUnstreamizerBinPackage extends TResourceUnstreamizerAsynchronous
   {
      
      protected static const UNSTREAMIZATIONSTATE_Properties:int = 1;
      
      protected static const UNSTREAMIZATIONSTATE_BinEntry:int = 2;
      
      protected static const UNSTREAMIZATIONSTATE_BinWait:int = 3;
      
      protected static const CAPCITY_Unstreamizers:int = 16;
      
      protected var FUnstreamizers:Vector.<TResourceUnstreamizerBin>;
      
      protected var FBinCount:int;
      
      public function TResourceUnstreamizerBinPackage()
      {
         super();
         this.ConstructUnstreamizers();
      }
      
      protected function ConstructUnstreamizers() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TResourceUnstreamizerBin = null;
         this.FUnstreamizers = new Vector.<TResourceUnstreamizerBin>(CAPCITY_Unstreamizers);
         _loc1_ = 0;
         while(_loc1_ < CAPCITY_Unstreamizers)
         {
            _loc2_ = new TResourceUnstreamizerBin();
            _loc2_.ValidatingIdentifier = false;
            _loc2_.OnResourceUnstreamized = this.UnstreamizerOnResourceUnstreamized;
            this.FUnstreamizers[_loc1_] = _loc2_;
            _loc1_++;
         }
      }
      
      protected function UnstreamizersProcess() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TResourceUnstreamizerBin = null;
         _loc1_ = 0;
         _loc2_ = 0;
         while(_loc2_ < CAPCITY_Unstreamizers)
         {
            _loc3_ = this.FUnstreamizers[_loc2_];
            _loc3_.Process();
            if(_loc3_.Unstreamizing)
            {
               _loc1_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      protected function UnstreamizerAcquire() : TResourceUnstreamizerBin
      {
         var _loc1_:int = 0;
         var _loc2_:TResourceUnstreamizerBin = null;
         _loc1_ = 0;
         while(_loc1_ < CAPCITY_Unstreamizers)
         {
            _loc2_ = this.FUnstreamizers[_loc1_];
            if(!_loc2_.Unstreamizing)
            {
               return _loc2_;
            }
            _loc1_++;
         }
         return null;
      }
      
      override protected function UnstreamizationRegisterRountines() : void
      {
         FUnstreamizationRoutines.Register(UNSTREAMIZATIONSTATE_Properties,this.UnstreamizationPerform_Properties);
         FUnstreamizationRoutines.Register(UNSTREAMIZATIONSTATE_BinEntry,this.UnstreamizationPerform_BinEntry);
         FUnstreamizationRoutines.Register(UNSTREAMIZATIONSTATE_BinWait,this.UnstreamizationPerform_BinWait);
      }
      
      override protected function UnstreamizationInitialize(param1:ByteArray, param2:Object, param3:Object) : void
      {
         super.UnstreamizationInitialize(param1,param2,param3);
         FUnstreamizationState = UNSTREAMIZATIONSTATE_Properties;
      }
      
      protected function UnstreamizationPerform_Properties() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TResourceRequest = null;
         _loc2_ = FCorrelator as TResourceRequest;
         _loc1_ = FStream.readUnsignedInt();
         this.FBinCount = FStream.readUnsignedShort();
         if(this.FBinCount == 0)
         {
            FUnstreamizationState = UNSTREAMIZATIONSTATE_Idle;
         }
         else
         {
            FUnstreamizationState = UNSTREAMIZATIONSTATE_BinEntry;
         }
      }
      
      protected function UnstreamizationPerform_BinEntry() : void
      {
         var _loc1_:TResourceUnstreamizerBin = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TBins = null;
         var _loc5_:ByteArray = null;
         while(this.FBinCount != 0)
         {
            this.UnstreamizersProcess();
            _loc1_ = this.UnstreamizerAcquire();
            if(_loc1_ == null)
            {
               return;
            }
            _loc2_ = FStream.readUnsignedInt();
            _loc4_ = new TBins(0);
            _loc5_ = new ByteArray();
            _loc5_.endian = Endian.LITTLE_ENDIAN;
            FStream.readBytes(_loc5_,0,_loc2_);
            _loc1_.Unstreamize(_loc5_,_loc4_,null);
            --this.FBinCount;
         }
         FUnstreamizationState = UNSTREAMIZATIONSTATE_BinWait;
      }
      
      protected function UnstreamizationPerform_BinWait() : void
      {
         if(this.UnstreamizersProcess() == 0)
         {
            FUnstreamizationState = UNSTREAMIZATIONSTATE_Idle;
         }
      }
      
      protected function UnstreamizerOnResourceUnstreamized(param1:Object, param2:TResource) : void
      {
         ResourceNotifyUnstreamized(param2);
      }
   }
}

