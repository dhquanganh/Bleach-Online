"""Exercise the production speed button, Flash frame clock and pending battle timers."""
from pathlib import Path
import argparse,subprocess
BASE=Path(__file__).resolve().parent

def main():
    p=argparse.ArgumentParser();p.add_argument('--ffdec',required=True);a=p.parse_args()
    runtime=(BASE/'runtime.as.txt').read_text()
    probe='''package {
 import flash.display.*;
 import flash.events.*;
 import flash.utils.*;
 import flash.text.*;
 import flash.external.ExternalInterface;
 import flash.net.*;
 import flash.system.*;
 import Components.Standard.TUIButton;
 import Foundation.Utilities.TUtilityReflection;
 import Resources.Constants.CONST_BATTLE;
 public class TApplication extends MovieClip {
  public var Visible:Boolean=true;
  private var FSP_Skip:Sprite=new Sprite();
  private var frames:int=0;
  private var normalFrames:int=0;
  private var fastFrames:int=0;
  private var normalStart:int;
  private var fastStart:int;
  private var midStart:int;
  private var lastClock:int=0;
  private var status:TextField=new TextField();
  public function TApplication(){
   var loader:Loader=new Loader();
   loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(e:Event):void{initializeProbe();});
   loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(e:IOErrorEvent):void{report("ERROR native UI "+e.text);});
   loader.load(new URLRequest("/battle-ui.swf"),new LoaderContext(false,ApplicationDomain.currentDomain));
  }
  private function initializeProbe():void{
   loaderInfo.uncaughtErrorEvents.addEventListener("uncaughtError",function(e:Object):void{report("ERROR uncaught "+e.error);e.preventDefault();});
   stage.scaleMode=StageScaleMode.NO_SCALE;stage.align=StageAlign.TOP_LEFT;stage.frameRate=30;
   graphics.beginFill(0x202C36);graphics.drawRect(0,0,1250,650);graphics.endFill();
   status.defaultTextFormat=new TextFormat("Arial",24,0xFFDF8C,true);status.width=1200;status.height=90;status.x=30;status.y=30;addChild(status);
   FSP_Skip=TUtilityReflection.CreateDisplayObjectInstance(CONST_BATTLE.RESOURCE_ClassName_BTN_Skip) as Sprite;
   var skip:TUIButton=new TUIButton();skip.Substrate=FSP_Skip[CONST_BATTLE.RESOURCE_Link_MC_ButtonSkipBattle] as MovieClip;skip.Enabled=true;skip.Caption="Skip battle";
   FSP_Skip.x=565;FSP_Skip.y=605;addChild(FSP_Skip);
   CreatePlaybackButton();StartPlaybackSpeed();
   addEventListener(Event.ENTER_FRAME,onFrame);
   check(FPlaybackLabel!=null && FPlaybackLabel.text=="x1" && FPlaybackButton.visible,"initial normal button");
   check(Math.abs(FPlaybackButton.height-FSP_Skip.height)<.01 && Math.abs(FPlaybackButton.width-FSP_Skip.width)<.01,"identical native frame dimensions");
   FPlaybackNativeControl.Substrate.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER,true));
   check(FPlaybackNativeControl.Substrate.currentFrame==2 && FPlaybackLabel.text=="x1","native hover skin and caption");
   FPlaybackNativeControl.Substrate.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT,true));
   check(FPlaybackNativeControl.Substrate.currentFrame==1 && FPlaybackLabel.text=="x1","native normal skin and caption");
   report("STATE x1");normalStart=getTimer();frames=0;
   PlaybackTimeout(function():void{var age:int=getTimer()-normalStart;check(age>=250 && age<500,"x1 timer "+age);report("TIMER x1 "+age);},300);
   setTimeout(finishNormal,600);
  }
  private function dumpUI(node:DisplayObjectContainer):void{
   for(var i:int=0;i<node.numChildren;i++){var c:DisplayObject=node.getChildAt(i);report("UI "+node.name+"/"+c.name+" "+getQualifiedClassName(c)+(c is TextField?" text="+TextField(c).text:""));if(c is DisplayObjectContainer)dumpUI(c as DisplayObjectContainer);}
  }
  private function check(ok:Boolean,message:String):void{report((ok?"PASS ":"ERROR ")+message);}
  private function report(message:String):void{if(ExternalInterface.available)ExternalInterface.call("speedProbe",message);}
  private function onFrame(event:Event):void{
   frames++;PulsePlaybackTimers();UpdatePlaybackButton();
   var clock:int=PlaybackTime;checkMonotonic(clock);lastClock=clock;
   status.text="Battle playback x"+PlaybackRate+"\\nNative frames: "+frames;
  }
  private function checkMonotonic(clock:int):void{if(clock<lastClock)report("ERROR battle clock moved backwards");}
  private function click():void{
   var before:int=PlaybackTime;
   FPlaybackNativeControl.Substrate.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN,true));
   FPlaybackNativeControl.Substrate.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP,true));
   check(Math.abs(PlaybackTime-before)<20,"continuous clock on toggle");
  }
  private function finishNormal():void{
   normalFrames=frames;check(normalFrames>=12,"x1 native frames "+normalFrames);
   click();check(PlaybackRate==2 && stage.frameRate==60 && FPlaybackLabel!=null && FPlaybackLabel.text=="x2","x2 enabled");
   report("STATE x2");frames=0;fastStart=getTimer();
   PlaybackTimeout(function():void{var age:int=getTimer()-fastStart;check(age>=190 && age<400,"x2 timer "+age);report("TIMER x2 "+age);},500);
   setTimeout(finishFast,600);
  }
  private function finishFast():void{
   fastFrames=frames;check(fastFrames>=normalFrames*1.6 && fastFrames<=normalFrames*2.6,"native frame ratio "+normalFrames+" -> "+fastFrames);
   report("FRAMES "+normalFrames+" "+fastFrames);
   click();midStart=getTimer();
   var canceled:uint=PlaybackTimeout(function():void{report("ERROR canceled callback ran");},400);
   ClearPlaybackTimeout(canceled);
   PlaybackTimeout(function():void{
    var age:int=getTimer()-midStart;check(age>=700 && age<=1050,"pending timer follows both toggles "+age);
    report("TIMER changing "+age);finishLifecycle();
   },1000);
   setTimeout(click,200);setTimeout(click,400);
  }
  private function finishLifecycle():void{
   PlaybackTimeout(function():void{report("ERROR previous battle callback ran");},100);
   StopPlaybackSpeed();check(PlaybackRate==1 && stage.frameRate==30 && !FPlaybackButton.visible,"end restores stage FPS and hides control");
   setTimeout(function():void{
    StartPlaybackSpeed();check(PlaybackRate==1 && FPlaybackLabel!=null && FPlaybackLabel.text=="x1","new battle starts x1");
    FSP_Skip.x=600;FSP_Skip.y=550;UpdatePlaybackButton();
    var bounds:flash.geom.Rectangle=FSP_Skip.getBounds(FSP_Skip.parent);
    check(Math.abs(FPlaybackButton.getBounds(FSP_Skip.parent).x-bounds.right-8)<.01,"button follows Skip on resize");
    click();StopPlaybackSpeed();check(stage.frameRate==30 && PlaybackRate==1,"exit at x2 restores normal");
    removeEventListener(Event.ENTER_FRAME,onFrame);report("DONE");
   },220);
  }
__RUNTIME__
 }
}
'''.replace('TApplication.this','this').replace('__RUNTIME__',runtime)
    # The closure's lexical this is the root display object in AS3.
    dest=BASE/'probe-source/TApplication.as';dest.parent.mkdir(exist_ok=True);dest.write_text(probe)
    subprocess.run(['java','-Xmx2g','-jar',a.ffdec,'-onerror','abort','-importScript',str(BASE/'source.swf'),str(BASE/'probe.swf'),str(dest.parent)],check=True)
    data=bytearray((BASE/'probe.swf').read_bytes());data[3]=21;(BASE/'probe.swf').write_bytes(data)
    print('PASS native Flash speed probe compiled')
if __name__=='__main__':main()
