package Logging.Requests
{
   import Foundation.Common.Stubs.TStubReferences;
   import Foundation.Common.TEntity;
   import Foundation.LoaderQueue.ILoaderAdapter;
   import Logging.Spaces.LoggingSpace;
   
   use namespace LoggingSpace;
   
   public class TRequest extends TEntity
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FIndex:uint;
      
      protected var FStartTime:uint;
      
      protected var FEndTime:uint;
      
      protected var FIsCache:Boolean;
      
      protected var FBytesLoaded:Number;
      
      protected var FBytesTotal:Number;
      
      protected var FMaxTries:uint;
      
      protected var FNumTries:uint;
      
      protected var FMaxBlockTries:int;
      
      protected var FNumBlockTries:int;
      
      protected var FMaxTimeOutTries:int;
      
      protected var FNumTimeOutTries:int;
      
      protected var FUrl:String;
      
      public function TRequest(param1:uint)
      {
         super(param1);
         this.FStubReferences = new TStubReferences(this);
      }
      
      LoggingSpace function Coerce(param1:uint) : void
      {
         FIdentifier = param1;
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get Index() : uint
      {
         return this.FIndex;
      }
      
      public function set Index(param1:uint) : void
      {
         this.FIndex = param1;
      }
      
      public function get StartTime() : uint
      {
         return this.FStartTime;
      }
      
      public function set StartTime(param1:uint) : void
      {
         this.FStartTime = param1;
      }
      
      public function get EndTime() : uint
      {
         return this.FEndTime;
      }
      
      public function set EndTime(param1:uint) : void
      {
         this.FEndTime = param1;
      }
      
      public function get IsCache() : Boolean
      {
         return this.FIsCache;
      }
      
      public function set IsCache(param1:Boolean) : void
      {
         this.FIsCache = param1;
      }
      
      public function get BytesLoaded() : Number
      {
         return this.FBytesLoaded;
      }
      
      public function set BytesLoaded(param1:Number) : void
      {
         this.FBytesLoaded = param1;
      }
      
      public function get BytesTotal() : Number
      {
         return this.FBytesTotal;
      }
      
      public function set BytesTotal(param1:Number) : void
      {
         this.FBytesTotal = param1;
      }
      
      public function get MaxTries() : uint
      {
         return this.FMaxTries;
      }
      
      public function set MaxTries(param1:uint) : void
      {
         this.FMaxTries = param1;
      }
      
      public function get NumTries() : uint
      {
         return this.FNumTries;
      }
      
      public function set NumTries(param1:uint) : void
      {
         this.FNumTries = param1;
      }
      
      public function get MaxBlockTries() : int
      {
         return this.FMaxBlockTries;
      }
      
      public function set MaxBlockTries(param1:int) : void
      {
         this.FMaxBlockTries = param1;
      }
      
      public function get NumBlockTries() : int
      {
         return this.FNumBlockTries;
      }
      
      public function set NumBlockTries(param1:int) : void
      {
         this.FNumBlockTries = param1;
      }
      
      public function get Url() : String
      {
         return this.FUrl;
      }
      
      public function set Url(param1:String) : void
      {
         this.FUrl = param1;
      }
      
      public function get MaxTimeOutTries() : int
      {
         return this.FMaxTimeOutTries;
      }
      
      public function set MaxTimeOutTries(param1:int) : void
      {
         this.FMaxTimeOutTries = param1;
      }
      
      public function get NumTimeOutTries() : int
      {
         return this.FNumTimeOutTries;
      }
      
      public function set NumTimeOutTries(param1:int) : void
      {
         this.FNumTimeOutTries = param1;
      }
      
      public function Assign(param1:ILoaderAdapter) : void
      {
         if(this.FUrl != param1.Url)
         {
            this.FUrl = param1.Url;
         }
         if(this.FBytesLoaded != param1.BytesLoaded)
         {
            this.FBytesLoaded = param1.BytesLoaded;
         }
         if(this.FBytesTotal != param1.BytesTotal)
         {
            this.FBytesTotal = param1.BytesTotal;
         }
         if(this.FMaxTries != param1.MaxTries)
         {
            this.FMaxTries = param1.MaxTries;
         }
         if(this.FNumTries != param1.NumTries)
         {
            this.FNumTries = param1.NumTries;
         }
         if(this.FMaxTimeOutTries != param1.MaxTimeOutTries)
         {
            this.FMaxTimeOutTries = param1.MaxTimeOutTries;
         }
         if(this.FNumTimeOutTries != param1.NumTimeOutTries)
         {
            this.FNumTimeOutTries = param1.NumTimeOutTries;
         }
         if(this.FMaxBlockTries != param1.MaxBlockTries)
         {
            this.FMaxBlockTries = param1.MaxBlockTries;
         }
         if(this.FNumBlockTries != param1.NumBlockTries)
         {
            this.FNumBlockTries = param1.NumBlockTries;
         }
      }
   }
}

