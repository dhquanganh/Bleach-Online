package Foundation.LoaderQueue.Adapter
{
   import Foundation.LoaderQueue.ILoaderAdapter;
   import Foundation.LoaderQueue.TLoaderQueueEvent;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   
   public class TLoaderAdapter extends AbstractLoaderAdapter implements ILoaderAdapter
   {
      
      private var FAdapter:Loader;
      
      public function TLoaderAdapter(param1:uint, param2:URLRequest, param3:LoaderContext = null)
      {
         super(param1,param2,param3);
      }
      
      public function get Adapter() : Loader
      {
         return this.FAdapter;
      }
      
      public function get Content() : DisplayObject
      {
         return this.Adapter.content;
      }
      
      public function get BytesLoaded() : Number
      {
         return this.Adapter ? this.Adapter.contentLoaderInfo.bytesLoaded : 0;
      }
      
      public function get BytesTotal() : Number
      {
         return this.Adapter ? this.Adapter.contentLoaderInfo.bytesTotal : 0;
      }
      
      override public function Dispose() : void
      {
         this.Stop();
         super.Dispose();
         this.FAdapter && this.FAdapter.unloadAndStop(true);
         this.FAdapter = null;
      }
      
      override public function Start() : void
      {
         this.FAdapter = new Loader();
         FAdapterAgent = this.FAdapter.contentLoaderInfo;
         PreStartHandle();
         try
         {
            this.FAdapter.load(FUrlRequest,FLoaderContext);
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
            this.FAdapter.close();
         }
         catch(error:Error)
         {
         }
      }
   }
}

