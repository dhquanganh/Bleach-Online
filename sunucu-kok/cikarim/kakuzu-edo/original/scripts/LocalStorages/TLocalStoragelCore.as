package LocalStorages
{
   import flash.net.SharedObject;
   
   public class TLocalStoragelCore
   {
      
      public static const LOCAL_STORAGEL_NAME:String = "BleachGame";
      
      protected var FSharedObject:SharedObject;
      
      protected var FData:Object;
      
      protected var FStoragelPath:String;
      
      protected var FMinDiskSpace:int;
      
      public function TLocalStoragelCore()
      {
         super();
         this.FStoragelPath = "";
         this.FMinDiskSpace = 0;
      }
      
      protected function FlushLocalStorage(param1:String, param2:*) : void
      {
         var Path:String = param1;
         var Data:* = param2;
         try
         {
            if(this.FSharedObject == null)
            {
               return;
            }
            this.FSharedObject.setProperty(Path,Data);
            this.FSharedObject.flush(this.FMinDiskSpace);
         }
         catch(e:Error)
         {
         }
      }
      
      protected function FetchLocalStorage(param1:String) : Object
      {
         var _loc2_:Object = null;
         if(this.FSharedObject == null)
         {
            this.FSharedObject = SharedObject.getLocal(param1);
         }
         _loc2_ = this.FSharedObject.data;
         if(_loc2_ != null)
         {
            this.FData = _loc2_;
         }
         return _loc2_;
      }
      
      public function get Data() : Object
      {
         return this.FData;
      }
      
      public function get StoragelPath() : String
      {
         return this.FStoragelPath;
      }
      
      public function set StoragelPath(param1:String) : void
      {
         this.FStoragelPath = param1;
      }
      
      public function Flush(param1:String, param2:*) : void
      {
         this.FlushLocalStorage(param1,param2);
      }
      
      public function Fetch(param1:String) : Object
      {
         return this.FetchLocalStorage(param1);
      }
   }
}

