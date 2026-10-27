package Foundation.LoaderQueue.Adapter
{
   import Foundation.LoaderQueue.ILoaderAdapter;
   import Foundation.LoaderQueue.TLoaderQueueEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   
   public class TURLLoaderAdapter extends AbstractLoaderAdapter implements ILoaderAdapter
   {
      
      protected var FAdapter:URLLoader;
      
      public function TURLLoaderAdapter(param1:uint, param2:URLRequest)
      {
         super(param1,param2,null);
      }
      
      public function get BytesLoaded() : Number
      {
         return this.Adapter ? this.Adapter.bytesLoaded : 0;
      }
      
      public function get BytesTotal() : Number
      {
         return this.Adapter ? this.Adapter.bytesTotal : 0;
      }
      
      public function get Adapter() : URLLoader
      {
         return this.FAdapter;
      }
      
      public function get Data() : *
      {
         return this.Adapter.data;
      }
      
      override public function Dispose() : void
      {
         this.Stop();
         super.Dispose();
         this.FAdapter = null;
      }
      
      override public function Start() : void
      {
         this.FAdapter = new URLLoader();
         this.FAdapter.dataFormat = URLLoaderDataFormat.BINARY;
         FAdapterAgent = this.FAdapter;
         PreStartHandle();
         try
         {
            this.FAdapter.load(FUrlRequest);
         }
         catch(error:Error)
         {
            dispatchEvent(new TLoaderQueueEvent(TLoaderQueueEvent.TASK_ERROR,FCustomData));
         }
      }
      
      public function Stop() : void
      {
         PreStopHandle();
         try
         {
            this.Adapter.close();
         }
         catch(error:Error)
         {
         }
      }
   }
}

