"""Exercise the production close handler with the actual native Soul Stone skin."""
from pathlib import Path
import subprocess
BASE=Path(__file__).resolve().parent
source=(BASE/'verify/scripts/Processors/Game/Lobby/Jade/TProcessorWindowJade.as').read_text()
a=source.index('      protected function OnCloseWindow(');b=source.index('      protected function ButtonHelpOnOver(',a)
close=source[a:b]
code='''package {
import flash.display.*;import flash.events.*;import flash.net.*;import flash.system.*;import flash.geom.*;import flash.external.ExternalInterface;import flash.utils.setTimeout;
public class TApplication extends MovieClip {
 private var loader:Loader;private var skin:Class;private var panel:ProbeWindow;private var index:int=0;
 public function TApplication(){stage.align=StageAlign.TOP_LEFT;stage.scaleMode=StageScaleMode.NO_SCALE;stage.frameRate=25;loader=new Loader();loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loaded);loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(e:Event):void{report("ERROR skin load");});loader.load(new URLRequest("/jade.swf"),new LoaderContext(false,new ApplicationDomain(ApplicationDomain.currentDomain)));}
 public function report(s:String):void{ExternalInterface.call("soulProbe",s);}
 private function loaded(e:Event):void{skin=loader.contentLoaderInfo.applicationDomain.getDefinition("JadeCombin") as Class;next();}
 private function next():void{
  if(index>=4){report("DONE native close cases=4");return;}
  panel=new ProbeWindow(this,skin,index);panel.x=277;panel.y=98;addChild(panel);
  setTimeout(function():void{var r:Rectangle=panel.closeButton.getBounds(stage);report("READY "+index+" "+Math.round(r.x+r.width/2)+" "+Math.round(r.y+r.height/2));},250);
 }
 public function closed(p:ProbeWindow):void{if(p.visible){report("ERROR close retained panel");return;}report("CLOSED "+index);setTimeout(function():void{if(p.parent!=null)p.parent.removeChild(p);index++;next();},500);}
}
internal class ProbeWindow extends Sprite {
 private var owner:TApplication;public var closeButton:SimpleButton;private var fail:Boolean;
 public function ProbeWindow(parent:TApplication,skin:Class,index:int){owner=parent;fail=index>=2;var scene:MovieClip=new skin() as MovieClip;scene.gotoAndStop("mosaic");addChild(scene);
  var mosaic:DisplayObject=scene.getChildByName("MC_MosaicView");var first:Sprite=new Sprite();addChild(first);first.addChild(mosaic);
  scene.gotoAndStop("combine");var synth:DisplayObject=scene.getChildByName("MC_CombineView");var second:Sprite=new Sprite();addChild(second);second.addChild(synth);
  first.visible=index%2==0;second.visible=index%2==1;
  closeButton=scene.getChildByName("btn_close") as SimpleButton;addChild(closeButton);closeButton.mouseEnabled=true;
  closeButton.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{try{OnCloseWindow(e);}catch(error:Error){if(visible)owner.report("ERROR reset blocked close");else owner.report("EXPECTED_RESET_THROW "+index);}});
 }
 public function get Visible():Boolean{return visible;}public function set Visible(v:Boolean):void{visible=v;}
 private function Reset():void{if(fail)throw new Error("test reset");}
 private function ProcessorWindowClose():void{owner.closed(this);}
 private function SoulStoneKeyDown(event:KeyboardEvent):void{}
__CLOSE__
}
}'''.replace('__CLOSE__',close)
folder=BASE/'close-probe-source';folder.mkdir(exist_ok=True);(folder/'TApplication.as').write_text(code)
subprocess.run(['java','-Xmx2g','-jar','C:/Users/quang/.copilot/session-state/b6dea4ff-70b7-44ac-b9f5-1136aca3d0d5/files/ffdec/app/ffdec.jar','-onerror','abort','-importScript',str(BASE.parent/'sasuke-shinden/source.swf'),str(BASE/'close-probe.swf'),str(folder)],check=True)
raw=bytearray((BASE/'close-probe.swf').read_bytes());raw[3]=21;(BASE/'close-probe.swf').write_bytes(raw)
print('PASS native skin close probe compiled from production handler')
