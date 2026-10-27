package Logging
{
   import Foundation.LoaderQueue.*;
   import Foundation.Network.*;
   import Foundation.Timing.*;
   import Foundation.Utilities.*;
   import Logging.Digests.*;
   import Logging.Publisher.*;
   import Logging.Requests.*;
   import flash.utils.*;
   import flash.xml.*;
   
   public class TLogger
   {
      
      public static const TYPE_Normal:uint = 240;
      
      public static const TYPE_Network:uint = 241;
      
      public static const TYPE_State:uint = 242;
      
      public static const LEVEL_DEBUG:int = 0;
      
      public static const LEVEL_LoadStart:int = 1;
      
      public static const LEVEL_LoadFailed:int = 2;
      
      public static const LEVEL_LoadFailureRetry:int = 3;
      
      public static const LEVEL_LoadTimeOutRetry:int = 4;
      
      public static const LEVEL_LoadBlockRetry:int = 5;
      
      public static const LEVEL_LoadAbort:int = 6;
      
      public static const LEVEL_LoadEnd:int = 7;
      
      public static const LEVEL_UnLoad:int = 8;
      
      public static const LEVEL_Login:int = 9;
      
      public static const LEVEL_PacketTransmit:int = 10;
      
      public static const LEVEL_PacketReceive:int = 11;
      
      public static const LEVEL_INFORMATION:int = 12;
      
      public static const LEVEL_WARNING:int = 13;
      
      public static const LEVEL_ERROR:int = 14;
      
      public static const LEVEL_FATAL:int = 15;
      
      protected var FRequests:TRequests;
      
      protected var FDigests:TDigests;
      
      protected var FMultiPublisher:TMultiPublisher;
      
      protected var FRequestCount:uint;
      
      protected var FNextTick:uint;
      
      protected var FNextStateTick:uint;
      
      protected var FState:TState;
      
      protected var FPoolRequest:TPoolRequest;
      
      protected var FPoolDigest:TPoolDigest;
      
      protected var FOnState:Function;
      
      protected var FMinLogLevel:int;
      
      protected var FEnabled:Boolean;
      
      protected var FIsShowDetail:Boolean;
      
      public function TLogger()
      {
         super();
         this.FRequests = new TRequests();
         this.FDigests = new TDigests();
         this.FMultiPublisher = new TMultiPublisher();
         this.FState = new TState();
         this.FMinLogLevel = LEVEL_DEBUG;
         this.FRequestCount = 1;
         this.FEnabled = true;
         this.FIsShowDetail = false;
      }
      
      public static function GetLogType(param1:int) : String
      {
         switch(param1)
         {
            case LEVEL_DEBUG:
               return "DEBUG";
            case LEVEL_LoadStart:
               return "LOADSTART";
            case LEVEL_LoadFailed:
               return "LOADFAILED";
            case LEVEL_LoadFailureRetry:
               return "LOADFAILURERETRY";
            case LEVEL_LoadTimeOutRetry:
               return "LOADTIMEOUTRETRY";
            case LEVEL_LoadBlockRetry:
               return "LOADBLOCKED";
            case LEVEL_LoadAbort:
               return "LOADBLOCKRETRY";
            case LEVEL_LoadEnd:
               return "LOADEND";
            case LEVEL_UnLoad:
               return "UNLOAD";
            case LEVEL_Login:
               return "LOGIN";
            case LEVEL_PacketTransmit:
               return "PACKETTRANSMIT";
            case LEVEL_PacketReceive:
               return "PACKETRECEIVING";
            case LEVEL_INFORMATION:
               return "INFO";
            case LEVEL_WARNING:
               return "WARN";
            case LEVEL_ERROR:
               return "ERROR";
            case LEVEL_FATAL:
               return "FATAL";
            default:
               return "";
         }
      }
      
      protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TDigest = null;
         if(!this.FEnabled)
         {
            return;
         }
         _loc3_ = int(STimingCore.TickCount);
         if(_loc3_ > this.FNextTick)
         {
            _loc4_ = this.FDigests.Shift();
            if(_loc4_ != null)
            {
               this.Log.apply(TLogger,[_loc4_.OutputType,_loc4_.Level,_loc4_.Content].concat(_loc4_.Additional));
            }
            this.FNextTick += 30;
         }
         if(_loc3_ > this.FNextStateTick)
         {
            if(this.FOnState != null)
            {
               this.FOnState(this,this.FState);
            }
            this.FNextStateTick += 1000;
         }
      }
      
      protected function GetClass(param1:String) : String
      {
         return param1;
      }
      
      protected function ParseObject(param1:*, param2:int = 0) : String
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:XML = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:XML = null;
         _loc4_ = "";
         _loc6_ = "";
         _loc7_ = "";
         _loc3_ = 0;
         while(_loc3_ < param2)
         {
            _loc7_ += "\t";
            _loc3_++;
         }
         try
         {
            _loc5_ = describeType(param1);
            _loc6_ = this.GetClass(_loc5_.@name);
         }
         catch(error:Error)
         {
         }
         if(_loc6_ == "String")
         {
            _loc4_ += String(param1);
         }
         else if(_loc6_ == "Boolean" || _loc6_ == "Number" || _loc6_ == "int" || _loc6_ == "uint")
         {
            _loc4_ += String(param1);
         }
         else if(_loc6_ == "Array")
         {
            _loc4_ += "[" + param1["toString"]() + "]";
         }
         else if(_loc6_ == "undefined" || _loc6_ == "null")
         {
            _loc4_ += "(" + _loc6_ + ")";
         }
         else if(_loc6_ == "Date")
         {
            _loc4_ += param1["toString"]();
         }
         else if(_loc6_ == "XML")
         {
            _loc4_ += XML(param1).toXMLString();
         }
         else if(_loc6_ == "XMLNode")
         {
            _loc4_ += XMLNode(param1).toString();
         }
         else if(_loc6_ == "Object")
         {
            _loc4_ += "Object\n";
            _loc4_ = _loc4_ + (_loc7_ + "{\n");
            for(_loc8_ in param1)
            {
               _loc4_ += _loc7_ + "\t" + _loc8_ + ": " + this.ParseObject(param1[_loc8_],param2 + 1) + "\n";
            }
            _loc4_ += _loc7_ + "}";
         }
         else if(_loc5_.hasOwnProperty("variable"))
         {
            _loc4_ += _loc6_ + ":\n";
            _loc4_ = _loc4_ + (_loc7_ + "{\n");
            for each(_loc9_ in _loc5_["variable"])
            {
               _loc4_ += _loc7_ + "\t" + _loc9_.@name + ": " + this.ParseObject(param1[_loc9_.@name],param2 + 1) + "\n";
            }
            _loc4_ += _loc7_ + "}";
         }
         else if(param1["toString"])
         {
            _loc4_ += param1["toString"]();
         }
         return _loc4_;
      }
      
      protected function TraceStream(param1:ByteArray) : String
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         _loc3_ = int(param1.length);
         _loc2_ = "Detail: ";
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = uint(param1[_loc4_]);
            if(_loc4_ % 19 == 0)
            {
               _loc2_ += "\n\t";
            }
            _loc2_ += TUtilityHexadecimal.Format(_loc5_,2) + " ";
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function get State() : TState
      {
         return this.FState;
      }
      
      public function get PoolRequest() : TPoolRequest
      {
         return this.FPoolRequest;
      }
      
      public function set PoolRequest(param1:TPoolRequest) : void
      {
         this.FPoolRequest = param1;
      }
      
      public function get PoolDigest() : TPoolDigest
      {
         return this.FPoolDigest;
      }
      
      public function set PoolDigest(param1:TPoolDigest) : void
      {
         this.FPoolDigest = param1;
      }
      
      public function set Publisher(param1:IPublisher) : void
      {
         if(this.FMultiPublisher)
         {
            this.FMultiPublisher.Destroy();
         }
         this.FMultiPublisher.Add(param1);
      }
      
      public function get Publisher() : IPublisher
      {
         return this.FMultiPublisher;
      }
      
      public function set Enabled(param1:Boolean) : void
      {
         this.FEnabled = param1;
      }
      
      public function get Enabled() : Boolean
      {
         return this.FEnabled;
      }
      
      public function set LogLevel(param1:int) : void
      {
         this.FMinLogLevel = param1;
      }
      
      public function get LogLevel() : int
      {
         return this.FMinLogLevel;
      }
      
      public function get IsShowDetail() : Boolean
      {
         return this.FIsShowDetail;
      }
      
      public function set IsShowDetail(param1:Boolean) : void
      {
         this.FIsShowDetail = param1;
      }
      
      public function get OnState() : Function
      {
         return this.FOnState;
      }
      
      public function set OnState(param1:Function) : void
      {
         this.FOnState = param1;
      }
      
      public function TraceDebug(param1:*, ... rest) : void
      {
         this.Log.apply(TLogger,[TLogger.LEVEL_DEBUG,param1].concat(rest));
      }
      
      public function TraceInformation(param1:uint, param2:*, ... rest) : void
      {
         var _loc4_:String = null;
         var _loc5_:TDigest = null;
         if(!this.FEnabled)
         {
            return;
         }
         switch(param1)
         {
            case LEVEL_UnLoad:
               _loc4_ = "[卸载]\t" + String(param2) + "  @" + (STimingCore.TickCount / 1000).toFixed(3);
               _loc5_ = this.FPoolDigest.Acquire();
               _loc5_.OutputType = TYPE_Normal;
               _loc5_.Level = param1;
               _loc5_.Content = _loc4_;
               _loc5_.Additional = rest;
         }
         this.FDigests.Add(_loc5_);
      }
      
      public function TraceWarning(param1:*, ... rest) : void
      {
         this.Log.apply(TLogger,[TLogger.LEVEL_WARNING,param1].concat(rest));
      }
      
      public function TraceError(param1:*, ... rest) : void
      {
         this.Log.apply(TLogger,[TLogger.LEVEL_ERROR,param1].concat(rest));
      }
      
      public function TraceFatal(param1:*, ... rest) : void
      {
         this.Log.apply(TLogger,[TLogger.LEVEL_FATAL,param1].concat(rest));
      }
      
      public function TraceLoadRequest(param1:uint, param2:*, param3:Boolean, ... rest) : void
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:TRequest = null;
         var _loc8_:ILoaderAdapter = null;
         var _loc9_:int = 0;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:uint = 0;
         var _loc14_:Number = NaN;
         var _loc15_:TDigest = null;
         if(!this.FEnabled)
         {
            return;
         }
         _loc8_ = param2 as ILoaderAdapter;
         switch(param1)
         {
            case LEVEL_LoadStart:
               _loc7_ = this.FPoolRequest.Acquire(_loc8_.Identifier);
               _loc7_.Index = this.FRequestCount++;
               _loc7_.StartTime = STimingCore.TickCount;
               _loc7_.IsCache = param3;
               if(!param3)
               {
                  this.FRequests.Add(_loc7_);
               }
               break;
            case LEVEL_LoadFailed:
               _loc7_ = this.FRequests.GetRequestByIdentifier(_loc8_.Identifier);
               _loc7_.EndTime = STimingCore.TickCount;
               break;
            case LEVEL_LoadFailureRetry:
               _loc7_ = this.FRequests.GetRequestByIdentifier(_loc8_.Identifier);
               _loc7_.StartTime = STimingCore.TickCount;
               break;
            case LEVEL_LoadTimeOutRetry:
               _loc7_ = this.FRequests.GetRequestByIdentifier(_loc8_.Identifier);
               _loc7_.StartTime = STimingCore.TickCount;
               break;
            case LEVEL_LoadBlockRetry:
               _loc7_ = this.FRequests.GetRequestByIdentifier(_loc8_.Identifier);
               _loc7_.StartTime = STimingCore.TickCount;
               break;
            case LEVEL_LoadAbort:
               _loc7_ = this.FRequests.DeleteRequestByIdentifier(_loc8_.Identifier);
               _loc7_.EndTime = STimingCore.TickCount;
               break;
            case LEVEL_LoadEnd:
               _loc7_ = this.FRequests.DeleteRequestByIdentifier(_loc8_.Identifier);
               _loc7_.EndTime = STimingCore.TickCount;
         }
         _loc7_.Assign(_loc8_);
         _loc6_ = "\t";
         _loc5_ = "";
         if(param3)
         {
            _loc6_ = _loc6_ + ("\t" + "[Cached]\t");
         }
         switch(param1)
         {
            case LEVEL_LoadStart:
               _loc5_ = "[开始]\t[" + _loc7_.Index + "]\t" + _loc7_.Url + _loc6_ + "@" + (_loc7_.StartTime / 1000).toFixed(3);
               break;
            case LEVEL_LoadFailed:
               _loc5_ = "[失败]\t[" + _loc7_.Index + "]\t" + _loc7_.Url + _loc6_ + "@" + (_loc7_.EndTime / 1000).toFixed(3);
               break;
            case LEVEL_LoadFailureRetry:
               _loc5_ = "[准备]\t[" + _loc7_.Index + "]\t" + _loc7_.Url + _loc6_ + "[失败重试: " + _loc7_.NumTries + "/" + _loc7_.MaxTries + "]\t" + "@" + (_loc7_.StartTime / 1000).toFixed(3);
               break;
            case LEVEL_LoadTimeOutRetry:
               _loc5_ = "[准备]\t[" + _loc7_.Index + "]\t" + _loc7_.Url + _loc6_ + "[超时重试: " + _loc7_.NumTimeOutTries + "/" + _loc7_.MaxTimeOutTries + "]\t" + "@" + (_loc7_.StartTime / 1000).toFixed(3);
               break;
            case LEVEL_LoadBlockRetry:
               _loc5_ = "[准备]\t[" + _loc7_.Index + "]\t" + _loc7_.Url + _loc6_ + "[阻塞重试: " + _loc7_.NumBlockTries + "/" + _loc7_.MaxBlockTries + "]\t" + "@" + (_loc7_.StartTime / 1000).toFixed(3);
               break;
            case LEVEL_LoadAbort:
               _loc5_ = "[终止]\t[" + _loc7_.Index + "]\t" + _loc7_.Url + _loc6_ + "@" + (_loc7_.EndTime / 1000).toFixed(3);
               break;
            case LEVEL_LoadEnd:
               _loc9_ = _loc7_.EndTime - _loc7_.StartTime;
               _loc10_ = _loc9_ / 1000;
               _loc11_ = _loc7_.BytesLoaded / 1024 / 100;
               if(_loc10_ != 0)
               {
                  _loc12_ = _loc11_ / _loc10_;
               }
               else
               {
                  _loc12_ = _loc11_ / 1;
               }
               _loc13_ = Math.round(_loc12_ * 100);
               _loc5_ = "[完成]\t[" + _loc7_.Index + "]\t" + _loc7_.Url + _loc6_ + "[" + Math.ceil(_loc7_.BytesLoaded / 1024) + "KB" + "/" + Math.ceil(_loc7_.BytesTotal / 1024) + "KB" + " " + (_loc7_.EndTime - _loc7_.StartTime) + "ms " + _loc13_ + "KB/S" + "]" + " @" + (_loc7_.EndTime / 1000).toFixed(3);
               if(!param3)
               {
                  _loc14_ = SLogger.State.BytesLoaded + _loc7_.BytesTotal;
                  SLogger.State.BytesLoaded = _loc14_;
               }
         }
         _loc15_ = this.FPoolDigest.Acquire();
         _loc15_.OutputType = TYPE_Normal;
         _loc15_.Level = param1;
         _loc15_.Content = _loc5_;
         _loc15_.Additional = rest;
         this.FDigests.Add(_loc15_);
      }
      
      public function TraceTransceiver(param1:uint, param2:*, ... rest) : void
      {
         var _loc4_:TPacket = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:TDigest = null;
         if(!this.FEnabled)
         {
            return;
         }
         _loc7_ = int(STimingCore.TickCount);
         switch(param1)
         {
            case LEVEL_Login:
               _loc5_ = "[登录]\t" + String(param2).toString() + "\t@" + (_loc7_ / 1000).toFixed(3);
               break;
            case LEVEL_PacketTransmit:
               _loc4_ = param2 as TPacket;
               _loc5_ = "[发送]\t" + "Packet: 0x" + TUtilityHexadecimal.Format(_loc4_.Identifier) + "\tLength: " + _loc4_.Data.length + "\t@" + (_loc7_ / 1000).toFixed(3);
               break;
            case LEVEL_PacketReceive:
               _loc4_ = param2 as TPacket;
               _loc5_ = "[接收]\t" + "Packet: 0x" + TUtilityHexadecimal.Format(_loc4_.Identifier) + "\tLength: " + _loc4_.Data.length + "\t@" + (_loc7_ / 1000).toFixed(3);
         }
         if(this.FIsShowDetail && (param1 == LEVEL_PacketTransmit || param1 == LEVEL_PacketReceive))
         {
            _loc6_ = this.TraceStream(_loc4_.Data);
            _loc5_ = _loc5_ + ("\n\t" + _loc6_);
         }
         _loc8_ = this.FPoolDigest.Acquire();
         _loc8_.OutputType = TYPE_Network;
         _loc8_.Level = param1;
         _loc8_.Content = _loc5_;
         _loc8_.Additional = rest;
         this.FDigests.Add(_loc8_);
      }
      
      public function Log(param1:uint, param2:int, param3:*, ... rest) : void
      {
         var _loc5_:Array = null;
         var _loc6_:IPublisher = null;
         var _loc7_:String = null;
         var _loc8_:Array = null;
         var _loc9_:* = undefined;
         if(!this.FEnabled || param2 < this.FMinLogLevel)
         {
            return;
         }
         if(this.FMultiPublisher.Length == 0)
         {
            throw new Error("Can\'t log. Please define a publisher or disable the Logger.");
         }
         _loc5_ = this.FMultiPublisher.GetPublisherList();
         for each(var _loc12_ in _loc5_)
         {
            _loc6_ = _loc12_;
            _loc12_;
            _loc7_ = "";
            _loc8_ = [].concat(param3,rest);
            for each(var _loc14_ in _loc8_)
            {
               _loc9_ = _loc14_;
               _loc14_;
               if(_loc7_ != "")
               {
                  _loc7_ = _loc7_ + "\n";
               }
               _loc7_ = _loc7_ + this.ParseObject(_loc9_);
            }
            _loc6_.Publish(param1,param2,_loc7_);
         }
      }
      
      public function AddPublisher(param1:IPublisher) : void
      {
         this.FMultiPublisher.Add(param1);
      }
      
      public function Update() : void
      {
         this.LogicsPerform();
      }
   }
}

