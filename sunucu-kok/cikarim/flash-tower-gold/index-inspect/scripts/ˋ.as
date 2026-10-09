package
{
   import avm2.intrinsics.memory.lf32;
   import avm2.intrinsics.memory.lf64;
   import avm2.intrinsics.memory.li16;
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.li8;
   import avm2.intrinsics.memory.sf32;
   import avm2.intrinsics.memory.sf64;
   import avm2.intrinsics.memory.si32;
   import avm2.intrinsics.memory.sxi1;
   import avm2.intrinsics.memory.sxi8;
   import flash.display.*;
   import flash.events.Event;
   import flash.events.ProgressEvent;
   import flash.net.*;
   import flash.system.*;
   import flash.utils.*;
   import laan.smart.proxies.filesystem.*;
   
   [SWF(width="1250", height="650", backgroundColor="#000000", frameRate="30")]
   public dynamic class ˋ extends MovieClip
   {
      
      private static const §̂ǵ§:String = "_doswf_package.LoadingBarBase";
      
      private var uiSWFBytes:*;
      
      private var context#8:*;
      
      private var context#9:*;
      
      private var isAS3#8:Boolean;
      
      private var isAS3#25:uint;
      
      private var isAS3#26:uint;
      
      private var skip#8:uint;
      
      private var skip#4:uint;
      
      private var skip#28:*;
      
      private var garbageSWFs#8:*;
      
      private var garbageSWFs#29:*;
      
      public function ˋ()
      {
         super();
         if(Security.sandboxType != "application")
         {
            Security.allowDomain("*");
         }
         if(stage)
         {
            this.init();
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.init);
         }
      }
      
      private function init(param1:Event = null) : void
      {
         var _loc2_:* = null;
         _loc2_ = null;
         if(param1)
         {
            removeEventListener(Event.ADDED_TO_STAGE,this.init);
         }
         this.context#8 = new LoaderContext(false,ApplicationDomain.currentDomain);
         if(this.context#8.hasOwnProperty("allowLoadBytesCodeExecution"))
         {
            Object(this.context#8).allowLoadBytesCodeExecution = true;
         }
         if(this.context#8.hasOwnProperty("parameters"))
         {
            Object(this.context#8)["parameters"] = stage.loaderInfo.parameters;
         }
         DisplayObject.prototype["@doswf__s"] = stage;
         DisplayObject.prototype.setPropertyIsEnumerable("@doswf__s",false);
         LoaderInfo.prototype["@doswf__u"] = stage.loaderInfo.url;
         LoaderInfo.prototype.setPropertyIsEnumerable("@doswf__u",false);
         LoaderInfo.prototype["@doswf__p"] = stage.loaderInfo.parameters;
         LoaderInfo.prototype.setPropertyIsEnumerable("@doswf__p",false);
         if(ApplicationDomain.currentDomain.hasDefinition(§̂ǵ§))
         {
            _loc2_ = ApplicationDomain.currentDomain.getDefinition(§̂ǵ§) as Class;
            this.context#9 = new _loc2_() as DisplayObject;
            addChild(this.context#9);
            stop();
            addEventListener(Event.ENTER_FRAME,this.loaderEventsHandler#23);
         }
         else
         {
            this.skip#24();
         }
      }
      
      private function skip#24() : void
      {
         var _loc8_:* = null;
         var _loc7_:* = null;
         var _loc6_:* = null;
         var _loc5_:* = null;
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         var _loc1_:* = null;
         _loc7_ = 0;
         _loc1_ = new §̂Ǵ§();
         _loc1_.endian = Endian.LITTLE_ENDIAN;
         _loc1_.position = 0;
         this.isAS3#26 = _loc1_.readUnsignedByte() - 1;
         this.isAS3#25 = _loc1_.readUnsignedByte() - 5;
         this.skip#8 = _loc1_.readUnsignedInt() - 7;
         this.skip#4 = _loc1_.readUnsignedInt() - 3;
         _loc2_ = new ByteArray();
         _loc2_.writeBytes(_loc1_,_loc1_.length - this.skip#4,this.skip#4);
         _loc3_ = 0;
         do
         {
            _loc7_ = 0;
            while(_loc7_ < this.isAS3#26)
            {
               _loc2_[_loc3_] ^= this.isAS3#25;
               _loc3_++;
               if(_loc3_ >= this.skip#4)
               {
                  break;
               }
               _loc7_ += 7;
            }
            _loc3_ += this.skip#8;
         }
         while(_loc3_ < this.skip#4);
         _loc2_.uncompress();
         _loc2_.endian = Endian.LITTLE_ENDIAN;
         _loc2_.position = 0;
         if(_loc2_.readBoolean())
         {
            this.garbageSWFs#27(_loc2_);
         }
         this.isAS3#8 = _loc2_.readBoolean();
         _loc4_ = _loc2_.readUnsignedInt();
         _loc5_ = new ByteArray();
         _loc2_.readBytes(_loc5_,0,_loc4_);
         this.uiSWFBytes = new ByteArray();
         _loc2_.readBytes(this.uiSWFBytes);
         _loc6_ = new Loader();
         _loc6_.contentLoaderInfo.addEventListener(Event.INIT,this.loaderEventsHandler#8);
         _loc6_.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.loaderEventsHandler#8);
         _loc6_[String(String(_loc6_).split(/[\s\]]+/g)[1]).toLocaleLowerCase().substr(0,-2) + "Bytes"](_loc5_,this.context#8);
      }
      
      private function loaderEventsHandler#8(param1:Event) : void
      {
         var _loc7_:* = null;
         var _loc6_:* = null;
         var _loc5_:* = null;
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         _loc4_ = null;
         _loc5_ = 0;
         _loc6_ = undefined;
         if(param1 is ProgressEvent)
         {
            this.skip#28 = param1 as ProgressEvent;
            return;
         }
         _loc2_ = param1.target as LoaderInfo;
         _loc2_.removeEventListener(Event.INIT,this.loaderEventsHandler#8);
         _loc2_.removeEventListener(ProgressEvent.PROGRESS,this.loaderEventsHandler#8);
         _loc3_ = _loc2_.loader;
         if(this.uiSWFBytes)
         {
            _loc3_ = new Loader();
            _loc3_.contentLoaderInfo.addEventListener(Event.INIT,this.loaderEventsHandler#8);
            _loc3_.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.loaderEventsHandler#8);
            _loc3_[String(String(_loc3_).split(/[\s\]]+/g)[1]).toLocaleLowerCase().substr(0,-2) + "Bytes"](this.uiSWFBytes,this.context#8);
            this.uiSWFBytes = null;
            return;
         }
         if(parent is Stage)
         {
            if(this.isAS3#8)
            {
               parent.addChildAt(_loc3_.content,0);
               parent.removeChild(this);
            }
            else
            {
               addChild(_loc3_);
            }
         }
         else if(this.isAS3#8)
         {
            addChildAt(_loc3_.content,0);
         }
         else
         {
            addChildAt(_loc3_,0);
         }
         if(Boolean(this.isAS3#8) && Boolean(this.skip#28))
         {
            _loc4_ = _loc2_.content as DisplayObjectContainer;
            if(_loc4_.hasOwnProperty("@doswf__lph"))
            {
               Object(_loc4_)["@doswf__lph"](this.skip#28);
            }
            else
            {
               _loc5_ = 0;
               while(_loc5_ < _loc4_.numChildren)
               {
                  _loc6_ = _loc4_.getChildAt(_loc5_);
                  if(_loc6_.hasOwnProperty("@doswf__lph"))
                  {
                     _loc6_["@doswf__lph"](this.skip#28);
                     break;
                  }
                  _loc5_++;
               }
            }
         }
      }
      
      private function loaderEventsHandler#23(param1:Event) : void
      {
         var _loc2_:Number = loaderInfo.bytesLoaded / loaderInfo.bytesTotal;
         Object(this.context#9).setProgress(this,_loc2_);
         if(_loc2_ == 1)
         {
            removeEventListener(Event.ENTER_FRAME,this.loaderEventsHandler#23);
            removeChild(this.context#9);
            gotoAndStop(2);
            this.skip#24();
         }
      }
      
      private function garbageSWFs#27(param1:ByteArray) : void
      {
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         this.garbageSWFs#8 = [];
         _loc2_ = param1.readUnsignedInt();
         _loc3_ = param1.readUnsignedInt();
         _loc4_ = new ByteArray();
         param1.readBytes(_loc4_,0,_loc3_);
         this.garbageSWFs#29 = new ByteArray();
         this.garbageSWFs#29.endian = Endian.LITTLE_ENDIAN;
         this.garbageSWFs#8 = [_loc2_,_loc4_];
         addEventListener(Event.ENTER_FRAME,this.createGarbageSWF);
         this.createGarbageSWF(null);
      }
      
      private function createGarbageSWF(param1:Event) : void
      {
         var _loc7_:* = null;
         var _loc6_:* = null;
         var _loc5_:* = null;
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         _loc5_ = null;
         _loc6_ = null;
         _loc7_ = 0;
         _loc2_ = uint(this.garbageSWFs#8[0]);
         _loc3_ = this.garbageSWFs#8[1];
         _loc4_ = 3;
         while(_loc4_-- > 0)
         {
            _loc5_ = new ByteArray();
            _loc5_.writeBytes(_loc3_);
            _loc5_.position = _loc5_.length;
            _loc5_.endian = Endian.LITTLE_ENDIAN;
            _loc6_ = new ByteArray();
            _loc7_ = uint(Math.random() * Math.min(_loc2_,2 * 1024 * 1024));
            while(_loc6_.length < _loc7_)
            {
               _loc6_.writeBytes(_loc3_,Math.random() * _loc3_.length / 3);
            }
            _loc6_.length = _loc7_;
            if(_loc6_.length >= 63)
            {
               _loc5_.writeShort(87 << 6 | 0x3F);
               _loc5_.writeUnsignedInt(_loc6_.length);
            }
            else
            {
               _loc5_.writeShort(87 << 6 | _loc6_.length);
            }
            _loc5_.writeBytes(_loc6_);
            _loc5_.writeShort(1 << 6);
            _loc5_.writeShort(0);
            _loc5_.position = 4;
            _loc5_.writeUnsignedInt(_loc5_.length);
            this.garbageSWFs#29.writeBytes(_loc5_);
            if(this.garbageSWFs#29.length > 30 * 1024 * 1024)
            {
               removeEventListener(Event.ENTER_FRAME,this.createGarbageSWF);
               break;
            }
         }
      }
   }
}

