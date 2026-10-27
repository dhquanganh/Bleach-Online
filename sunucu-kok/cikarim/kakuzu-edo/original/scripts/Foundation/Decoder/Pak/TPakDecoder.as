package Foundation.Decoder.Pak
{
   import Foundation.Common.*;
   import Foundation.Resources.Streamization.TResourceUnstreamizerAsynchronous;
   import Foundation.Utilities.TUtilityVector;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.system.ImageDecodingPolicy;
   import flash.system.LoaderContext;
   import flash.utils.*;
   
   public class TPakDecoder extends TResourceUnstreamizerAsynchronous
   {
      
      protected static const UNSTREAMIZATIONSTATE_Properties:int = 1;
      
      protected static const UNSTREAMIZATIONSTATE_SurfaceLoad:int = 2;
      
      protected static const UNSTREAMIZATIONSTATE_SurfaceWait:int = 3;
      
      protected static const UNSTREAMIZATIONSTATE_SurfaceBind:int = 4;
      
      protected static const UNSTREAMIZATIONSTATE_Traversal:int = 5;
      
      protected static const UNSTREAMIZATIONSTATE_TraversalWait:int = 6;
      
      protected static const UNSTREAMIZATIONSTATE_Finalize:int = 7;
      
      protected static const STEP_Traversal_CopyPixels:uint = 0;
      
      protected static const STEP_Traversal_CopyChannel:uint = 1;
      
      protected static const STEP_Traversal_End:uint = 2;
      
      protected var FSurfaceLoader0:Loader;
      
      protected var FSurfaceLoader1:Loader;
      
      protected var FLoaderContext0:LoaderContext;
      
      protected var FLoaderContext1:LoaderContext;
      
      protected var FResult:Vector.<BitmapData>;
      
      protected var FBitmapDatas:Vector.<BitmapData>;
      
      protected var FLoadList:Vector.<ByteArray>;
      
      protected var FAtlasSourceRects:Array = [];
      
      protected var FSizes:Vector.<TCoordinate>;
      
      protected var FWidth:int;
      
      protected var FHeight:int;
      
      protected var FType:int;
      
      protected var FCoordinate:TCoordinate;
      
      protected var FNewPoint:Point;
      
      protected var FNewBmpData:BitmapData;
      
      protected var FRectBmpData:Rectangle;
      
      protected var FQuality:int;
      
      protected var FAlphaQuality:int;
      
      protected var FAlphaFilter:int;
      
      protected var FLength:int;
      
      protected var FDestinationX:int;
      
      protected var FTraversalIndex:int;
      
      protected var FTextureJointAlpha:Boolean;
      
      protected var FTraversalStep:uint;
      
      public function TPakDecoder(param1:ByteArray = null)
      {
         super();
         this.UnstreamizationRegisterRountines();
         this.FSurfaceLoader0 = new Loader();
         this.FSurfaceLoader0.contentLoaderInfo.addEventListener(Event.COMPLETE,this.SurfaceLoadersOnComplete);
         this.FLoaderContext0 = new LoaderContext();
         this.FSurfaceLoader1 = new Loader();
         this.FSurfaceLoader1.contentLoaderInfo.addEventListener(Event.COMPLETE,this.SurfaceLoadersOnComplete);
         this.FLoaderContext1 = new LoaderContext();
         this.FLoadList = new Vector.<ByteArray>();
         this.FBitmapDatas = new Vector.<BitmapData>(2);
         this.FSizes = new Vector.<TCoordinate>();
      }
      
      override protected function UnstreamizationRegisterRountines() : void
      {
         FUnstreamizationRoutines.Register(UNSTREAMIZATIONSTATE_Properties,this.UnstreamizationPerform_Properties);
         FUnstreamizationRoutines.Register(UNSTREAMIZATIONSTATE_SurfaceLoad,this.UnstreamizationPerform_SurfaceLoad);
         FUnstreamizationRoutines.Register(UNSTREAMIZATIONSTATE_SurfaceWait,this.UnstreamizationPerform_SurfaceWait);
         FUnstreamizationRoutines.Register(UNSTREAMIZATIONSTATE_SurfaceBind,this.UnstreamizationPerform_SurfaceBind);
         FUnstreamizationRoutines.Register(UNSTREAMIZATIONSTATE_Traversal,this.UnstreamizationPerform_Traversal);
         FUnstreamizationRoutines.Register(UNSTREAMIZATIONSTATE_TraversalWait,this.UnstreamizationPerform_TraversalWait);
         FUnstreamizationRoutines.Register(UNSTREAMIZATIONSTATE_Finalize,this.UnstreamizationPerform_Finalize);
      }
      
      override protected function UnstreamizationInitialize(param1:ByteArray, param2:Object, param3:Object) : void
      {
         super.UnstreamizationInitialize(param1,param2,param3);
         this.FResult = param2 as Vector.<BitmapData>;
         FUnstreamizationState = UNSTREAMIZATIONSTATE_Properties;
      }
      
      override protected function UnstreamizationFinalize() : void
      {
         var _loc1_:BitmapData = null;
         super.UnstreamizationFinalize();
         this.FTraversalStep = STEP_Traversal_CopyPixels;
         this.FCoordinate = null;
         this.FNewPoint = null;
         this.FNewBmpData = null;
         this.FRectBmpData = null;
         this.FLoadList.length = 0;
         this.FSizes.length = 0;
         this.FAtlasSourceRects.length = 0;
         this.FDestinationX = 0;
         this.FTraversalIndex = 0;
         if(this.FBitmapDatas.length != 0)
         {
            for each(_loc1_ in this.FBitmapDatas)
            {
               if(_loc1_ != null)
               {
                  _loc1_.dispose();
                  _loc1_ = null;
               }
            }
            this.FBitmapDatas.length = 0;
         }
         this.FResult.length = 0;
      }
      
      protected function UnstreamizationPerform_Properties() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:ByteArray = null;
         var _loc7_:TCoordinate = null;
         _loc6_ = new ByteArray();
         FStream.position = 0;
         FStream.readBytes(_loc6_,0,FStream.length);
         _loc6_.position = 0;
         _loc6_.uncompress();
         this.FType = _loc6_.readByte();
         this.FWidth = _loc6_.readUnsignedShort();
         this.FHeight = _loc6_.readUnsignedShort();
         this.FQuality = _loc6_.readByte();
         this.FAlphaQuality = _loc6_.readByte();
         this.FAlphaFilter = _loc6_.readByte();
         this.FLength = _loc6_.readUnsignedShort();
         _loc1_ = 0;
         while(_loc1_ < this.FLength)
         {
            _loc2_ = _loc6_.readShort();
            _loc3_ = _loc6_.readShort();
            _loc4_ = _loc6_.readShort();
            _loc5_ = _loc6_.readShort();
            _loc7_ = new TCoordinate();
            _loc7_.X = _loc4_;
            _loc7_.Y = _loc5_;
            this.FSizes.push(_loc7_);
            this.FAtlasSourceRects.push(new Rectangle(_loc2_,_loc3_,_loc4_,_loc5_));
            _loc1_++;
         }
         this.ReadData(_loc6_);
         FUnstreamizationState = UNSTREAMIZATIONSTATE_SurfaceLoad;
      }
      
      protected function UnstreamizationPerform_SurfaceLoad() : void
      {
         var _loc1_:String = null;
         if(this.FWidth > 50 || this.FHeight > 50)
         {
            _loc1_ = ImageDecodingPolicy.ON_LOAD;
         }
         else
         {
            _loc1_ = ImageDecodingPolicy.ON_DEMAND;
         }
         this.FLoaderContext0.imageDecodingPolicy = _loc1_;
         this.FLoaderContext1.imageDecodingPolicy = _loc1_;
         this.FSurfaceLoader0.loadBytes(this.FLoadList[0],this.FLoaderContext0);
         if(this.FTextureJointAlpha)
         {
            this.FSurfaceLoader1.loadBytes(this.FLoadList[1],this.FLoaderContext1);
         }
         FUnstreamizationState = UNSTREAMIZATIONSTATE_SurfaceWait;
      }
      
      protected function UnstreamizationPerform_SurfaceWait() : void
      {
         if(this.FSurfaceLoader0.content == null)
         {
            return;
         }
         if(this.FTextureJointAlpha)
         {
            if(this.FSurfaceLoader1.content == null)
            {
               return;
            }
         }
         FUnstreamizationState = UNSTREAMIZATIONSTATE_SurfaceBind;
      }
      
      protected function UnstreamizationPerform_SurfaceBind() : void
      {
         var _loc1_:Bitmap = null;
         var _loc2_:Bitmap = null;
         var _loc3_:BitmapData = null;
         var _loc4_:BitmapData = null;
         _loc1_ = this.FSurfaceLoader0.content as Bitmap;
         _loc3_ = _loc1_.bitmapData;
         this.FBitmapDatas[0] = _loc3_;
         if(this.FTextureJointAlpha)
         {
            _loc2_ = this.FSurfaceLoader1.content as Bitmap;
            _loc4_ = _loc2_.bitmapData;
            this.FBitmapDatas[1] = _loc4_;
         }
         FUnstreamizationState = UNSTREAMIZATIONSTATE_Traversal;
      }
      
      protected function UnstreamizationPerform_Traversal() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TCoordinate = null;
         var _loc3_:BitmapData = null;
         var _loc4_:BitmapData = null;
         var _loc5_:Point = null;
         var _loc6_:BitmapData = null;
         var _loc7_:Rectangle = null;
         var _loc8_:Boolean = false;
         if(this.FTraversalIndex < this.FLength)
         {
            _loc3_ = this.FBitmapDatas[0];
            _loc8_ = false;
            if(this.FAlphaQuality != 0)
            {
               _loc8_ = true;
               if(this.FQuality != this.FAlphaQuality)
               {
                  _loc4_ = this.FBitmapDatas[1];
               }
            }
            _loc2_ = this.FSizes[this.FTraversalIndex];
            switch(this.FTraversalStep)
            {
               case STEP_Traversal_CopyPixels:
                  if(_loc2_.X == 0 || _loc2_.Y == 0)
                  {
                     _loc2_ = new TCoordinate();
                     _loc2_.X = 1;
                     _loc2_.Y = 1;
                  }
                  _loc6_ = new BitmapData(_loc2_.X,_loc2_.Y,_loc8_,0);
                  _loc7_ = this.FType == 127 ? this.FAtlasSourceRects[this.FTraversalIndex] : new Rectangle(this.FDestinationX,0,_loc2_.X,_loc2_.Y);
                  _loc5_ = new Point();
                  _loc6_.lock();
                  _loc6_.copyPixels(_loc3_,_loc7_,_loc5_);
                  _loc6_.unlock();
                  this.FCoordinate = _loc2_;
                  this.FNewPoint = _loc5_;
                  this.FNewBmpData = _loc6_;
                  this.FRectBmpData = _loc7_;
                  this.FTraversalStep = STEP_Traversal_CopyChannel;
                  break;
               case STEP_Traversal_CopyChannel:
                  _loc2_ = this.FCoordinate;
                  _loc5_ = this.FNewPoint;
                  _loc6_ = this.FNewBmpData;
                  _loc7_ = this.FRectBmpData;
                  if(this.FAlphaQuality != 0 && this.FQuality != this.FAlphaQuality)
                  {
                     _loc6_.lock();
                     _loc6_.copyChannel(_loc4_,_loc7_,_loc5_,BitmapDataChannel.RED,BitmapDataChannel.ALPHA);
                     _loc6_.unlock();
                  }
                  else
                  {
                     _loc6_.lock();
                     _loc6_.copyChannel(_loc3_,new Rectangle(_loc7_.x,_loc7_.y + _loc3_.height / 2,_loc2_.X,_loc2_.Y),_loc5_,BitmapDataChannel.RED,BitmapDataChannel.ALPHA);
                     _loc6_.unlock();
                  }
                  this.DoAlphaFilter(_loc6_);
                  this.FResult.push(_loc6_);
                  this.FDestinationX += _loc2_.X;
                  this.FTraversalStep = STEP_Traversal_End;
                  break;
               default:
                  ++this.FTraversalIndex;
                  this.FTraversalStep = STEP_Traversal_CopyPixels;
            }
            _loc6_ = null;
         }
         FUnstreamizationState = UNSTREAMIZATIONSTATE_TraversalWait;
      }
      
      protected function UnstreamizationPerform_TraversalWait() : void
      {
         if(this.FTraversalIndex < this.FLength)
         {
            FUnstreamizationState = UNSTREAMIZATIONSTATE_Traversal;
            return;
         }
         FUnstreamizationState = UNSTREAMIZATIONSTATE_Finalize;
      }
      
      protected function UnstreamizationPerform_Finalize() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:Vector.<BitmapData> = null;
         this.FSurfaceLoader0.unload();
         this.FSurfaceLoader1.unload();
         _loc1_ = FCorrelator as uint;
         _loc2_ = new Vector.<BitmapData>(this.FResult.length);
         TUtilityVector.CopyBitmapDataVector(this.FResult,_loc2_);
         this.UnstreamizationFinalize();
         FUnstreamizationState = UNSTREAMIZATIONSTATE_Idle;
         this.ResourceUnstreamized(_loc2_,_loc1_);
      }
      
      protected function ReadData(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:ByteArray = null;
         _loc2_ = int(param1.readUnsignedInt());
         _loc3_ = new ByteArray();
         param1.readBytes(_loc3_,0,_loc2_);
         this.FLoadList.push(_loc3_);
         this.FTextureJointAlpha = false;
         if(this.FAlphaQuality != 0 && this.FQuality != this.FAlphaQuality)
         {
            _loc4_ = new ByteArray();
            _loc2_ = int(param1.readUnsignedInt());
            if(_loc2_)
            {
               param1.readBytes(_loc4_,0,_loc2_);
            }
            this.FLoadList.push(_loc4_);
            this.FTextureJointAlpha = true;
         }
      }
      
      protected function DoAlphaFilter(param1:BitmapData) : void
      {
         var _loc2_:Point = null;
         _loc2_ = new Point();
         if(this.FAlphaFilter > 0)
         {
            param1.threshold(param1,param1.rect,_loc2_,"<",this.FAlphaFilter << 24,0,4278190080,true);
         }
      }
      
      protected function ResourceUnstreamized(param1:Vector.<BitmapData>, param2:uint) : void
      {
         if(FOnResourceUnstreamized != null)
         {
            FOnResourceUnstreamized(this,param1,param2);
         }
      }
      
      protected function SurfaceLoadersOnComplete(param1:Event) : void
      {
         FUnstreamizationState = UNSTREAMIZATIONSTATE_SurfaceWait;
      }
   }
}

