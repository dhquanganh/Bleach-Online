package Foundation.Resources.Streamization.Bin
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.Spaces.*;
   import Foundation.Resources.Streamization.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.TDatebaseVO;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.utils.*;
   
   use namespace ResourcesSpace;
   
   public class TResourceUnstreamizerBin extends TResourceUnstreamizerAsynchronous
   {
      
      protected static const UNSTREAMIZATIONSTATE_Properties:int = 1;
      
      protected static const UNSTREAMIZATIONSTATE_Traversal:int = 2;
      
      protected static const UNSTREAMIZATIONSTATE_Finalize:int = 3;
      
      public static const RESOURCESID_DATEBASE:Vector.<uint> = CONST_DATEBASEVO.RESOURCESID_DATEBASE;
      
      public static const CLASSTYPE_NAMES:Vector.<Class> = CONST_DATEBASEVO.CLASSTYPE_NAMES;
      
      protected var FBins:TBins;
      
      protected var FValidatingIdentifier:Boolean;
      
      public function TResourceUnstreamizerBin()
      {
         super();
         this.FValidatingIdentifier = true;
      }
      
      override protected function UnstreamizationRegisterRountines() : void
      {
         FUnstreamizationRoutines.Register(UNSTREAMIZATIONSTATE_Properties,this.UnstreamizationPerform_Properties);
         FUnstreamizationRoutines.Register(UNSTREAMIZATIONSTATE_Traversal,this.UnstreamizationPerform_Traversal);
         FUnstreamizationRoutines.Register(UNSTREAMIZATIONSTATE_Finalize,this.UnstreamizationPerform_Finalize);
      }
      
      override protected function UnstreamizationInitialize(param1:ByteArray, param2:Object, param3:Object) : void
      {
         super.UnstreamizationInitialize(param1,param2,param3);
         this.FBins = param2 as TBins;
         FUnstreamizationState = UNSTREAMIZATIONSTATE_Properties;
      }
      
      override protected function UnstreamizationFinalize() : void
      {
         super.UnstreamizationFinalize();
         this.FBins = null;
      }
      
      protected function UnstreamizationPerform_Properties() : void
      {
         var _loc1_:uint = 0;
         FStream.uncompress();
         _loc1_ = FStream.readUnsignedInt();
         if(this.FValidatingIdentifier)
         {
            if(_loc1_ != this.FBins.Identifier)
            {
               _loc1_ = this.FBins.Identifier;
            }
         }
         this.FBins.Coerce(_loc1_);
         FUnstreamizationState = UNSTREAMIZATIONSTATE_Traversal;
      }
      
      protected function UnstreamizationPerform_Traversal() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:Class = null;
         var _loc5_:TDatebaseVO = null;
         _loc3_ = this.FBins.Identifier;
         _loc1_ = RESOURCESID_DATEBASE.indexOf(_loc3_);
         if(_loc1_ == -1)
         {
            FUnstreamizationState = UNSTREAMIZATIONSTATE_Finalize;
            return;
         }
         _loc4_ = CLASSTYPE_NAMES[_loc1_];
         _loc2_ = int(FStream.readUnsignedInt());
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = new _loc4_();
            _loc5_.Coerce(FStream.readUnsignedInt());
            _loc5_.ReadDataByStream(FStream);
            this.FBins.DatebaseAppend(_loc5_.Identifier,_loc5_);
            _loc1_++;
         }
         if(FStream.bytesAvailable > 0)
         {
            throw new Error("When Unstreamize finished Bin is not Empty, ClassType is:" + _loc4_);
         }
         FUnstreamizationState = UNSTREAMIZATIONSTATE_Finalize;
      }
      
      protected function UnstreamizationPerform_Finalize() : void
      {
         var _loc1_:TBins = null;
         _loc1_ = this.FBins;
         this.UnstreamizationFinalize();
         FUnstreamizationState = UNSTREAMIZATIONSTATE_Idle;
         ResourceNotifyUnstreamized(_loc1_);
      }
      
      public function get ValidatingIdentifier() : Boolean
      {
         return this.FValidatingIdentifier;
      }
      
      public function set ValidatingIdentifier(param1:Boolean) : void
      {
         this.FValidatingIdentifier = param1;
      }
   }
}

