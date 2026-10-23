package {
 import flash.display.MovieClip;
 import flash.display.Loader;
 import flash.events.Event;
 import flash.events.IOErrorEvent;
 import flash.net.URLRequest;
 import flash.system.LoaderContext;
 import flash.system.ApplicationDomain;
 import flash.system.Security;
 import flash.external.ExternalInterface;
 import flash.utils.getQualifiedClassName;
 public class TApplication extends MovieClip {
  private var testLoader:Loader;
  private var history:Array=[];
  private function remember(e:Event):void {var t:Object=e.target;history.push(e.type+" "+getQualifiedClassName(t)+" "+t.name);if(history.length>25)history.shift();}
  public function TApplication(){super();if(stage!=null)boot();else addEventListener(Event.ADDED_TO_STAGE,boot);}
  private function report(text:String):void {if(ExternalInterface.available)ExternalInterface.call("bossProbe",text);}
  private function boot(event:Event=null):void {
   removeEventListener(Event.ADDED_TO_STAGE,boot);
   testLoader=new Loader();addChild(testLoader);
   var errors:Object=Object(testLoader.contentLoaderInfo)["uncaughtErrorEvents"];
   errors.addEventListener("uncaughtError",fault);
   testLoader.contentLoaderInfo.addEventListener(Event.INIT,loaded);
   testLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,failed);
   var context:LoaderContext=new LoaderContext(false,new ApplicationDomain(null));
   Security.loadPolicyFile("xmlsocket://127.0.0.1:1843");
   context.parameters=loaderInfo.parameters;
   report("BOOT "+loaderInfo.parameters.target);
   testLoader.load(new URLRequest(String(loaderInfo.parameters.target)),context);
  }
  private function loaded(event:Event):void {testLoader.addEventListener(Event.REMOVED,remember,true);testLoader.addEventListener(Event.ADDED,remember,true);testLoader.addEventListener(Event.REMOVED_FROM_STAGE,remember,true);report("INIT child document loaded");}
  private function failed(event:IOErrorEvent):void {report("LOAD ERROR "+event.text);}
  private function fault(event:Event):void {
   var error:Object=Object(event)["error"];
   report("RUNTIME ERROR "+String(error)+(error is Error?"\n"+Error(error).getStackTrace():""));
   report("EVENT HISTORY\n"+history.join("\n"));
   event.preventDefault();
  }
 }
}
