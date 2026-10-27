package Logging
{
   public class TState
   {
      
      protected var FLoading:uint;
      
      protected var FSuccess:uint;
      
      protected var FRetry:uint;
      
      protected var FTimeOut:uint;
      
      protected var FFail:uint;
      
      protected var FCancel:uint;
      
      protected var FBlock:uint;
      
      protected var FOnlinePlayer:uint;
      
      protected var FTransmit:uint;
      
      protected var FReceived:uint;
      
      protected var FBytesLoaded:Number;
      
      public function TState()
      {
         super();
         this.FBytesLoaded = 0;
      }
      
      public function get Loading() : uint
      {
         return this.FLoading;
      }
      
      public function set Loading(param1:uint) : void
      {
         if(this.FLoading != param1)
         {
            this.FLoading = param1;
         }
      }
      
      public function get Success() : uint
      {
         return this.FSuccess;
      }
      
      public function set Success(param1:uint) : void
      {
         if(this.FSuccess != param1)
         {
            this.FSuccess = param1;
         }
      }
      
      public function get Retry() : uint
      {
         return this.FRetry;
      }
      
      public function set Retry(param1:uint) : void
      {
         if(this.FRetry != param1)
         {
            this.FRetry = param1;
         }
      }
      
      public function get TimeOut() : uint
      {
         return this.FTimeOut;
      }
      
      public function set TimeOut(param1:uint) : void
      {
         if(this.FTimeOut != param1)
         {
            this.FTimeOut = param1;
         }
      }
      
      public function get Fail() : uint
      {
         return this.FFail;
      }
      
      public function set Fail(param1:uint) : void
      {
         if(this.FFail != param1)
         {
            this.FFail = param1;
         }
      }
      
      public function get Cancel() : uint
      {
         return this.FCancel;
      }
      
      public function set Cancel(param1:uint) : void
      {
         if(this.FCancel != param1)
         {
            this.FCancel = param1;
         }
      }
      
      public function get Block() : uint
      {
         return this.FBlock;
      }
      
      public function set Block(param1:uint) : void
      {
         if(this.FBlock != param1)
         {
            this.FBlock = param1;
         }
      }
      
      public function get OnlinePlayer() : uint
      {
         return this.FOnlinePlayer;
      }
      
      public function set OnlinePlayer(param1:uint) : void
      {
         this.FOnlinePlayer = param1;
      }
      
      public function get Transmit() : uint
      {
         return this.FTransmit;
      }
      
      public function set Transmit(param1:uint) : void
      {
         if(this.FTransmit != param1)
         {
            this.FTransmit = param1;
         }
      }
      
      public function get Received() : uint
      {
         return this.FReceived;
      }
      
      public function set Received(param1:uint) : void
      {
         if(this.FReceived != param1)
         {
            this.FReceived = param1;
         }
      }
      
      public function get BytesLoaded() : Number
      {
         return this.FBytesLoaded;
      }
      
      public function set BytesLoaded(param1:Number) : void
      {
         if(this.FBytesLoaded != param1)
         {
            this.FBytesLoaded = param1;
         }
      }
      
      public function Flush(param1:TState) : Boolean
      {
         var _loc2_:Boolean = false;
         _loc2_ = false;
         if(this.FLoading != param1.Loading)
         {
            param1.Loading = this.FLoading;
            _loc2_ = true;
         }
         if(this.FSuccess != param1.Success)
         {
            param1.Success = this.FSuccess;
            _loc2_ = true;
         }
         if(this.FRetry != param1.Retry)
         {
            param1.Retry = this.FRetry;
            _loc2_ = true;
         }
         if(this.FTimeOut != param1.TimeOut)
         {
            param1.TimeOut = this.FTimeOut;
            _loc2_ = true;
         }
         if(this.FFail != param1.Fail)
         {
            param1.Fail = this.FFail;
            _loc2_ = true;
         }
         if(this.FCancel != param1.Cancel)
         {
            param1.Cancel = this.FCancel;
            _loc2_ = true;
         }
         if(this.FBlock != param1.Block)
         {
            param1.Block = this.FBlock;
            _loc2_ = true;
         }
         if(this.FOnlinePlayer != param1.OnlinePlayer)
         {
            param1.OnlinePlayer = this.FOnlinePlayer;
            _loc2_ = true;
         }
         if(this.FTransmit != param1.Transmit)
         {
            param1.Transmit = this.FTransmit;
            _loc2_ = true;
         }
         if(this.FReceived != param1.Received)
         {
            param1.Received = this.FReceived;
            _loc2_ = true;
         }
         if(this.FBytesLoaded != param1.BytesLoaded)
         {
            param1.BytesLoaded = this.FBytesLoaded;
            _loc2_ = true;
         }
         return _loc2_;
      }
   }
}

