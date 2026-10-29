from pathlib import Path
import importlib.util,re
B=Path(__file__).resolve().parent;s=importlib.util.spec_from_file_location('capture',B/'capture.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m);c=m.c
role=(B/'patched'/m.paths[0]).read_text(encoding='utf-8')
setup=c.m.extract(role,'ResourcesPerform_UIDispatch');start=setup.index('         this.FRegistrationInfo =');end=setup.index('         _loc2_ = 7;',start);setup=setup[start:end]
helpers='\n'.join(c.m.extract(role,name) for name in ['HideTournamentText','SetTournamentCaption','UpdateTournamentCaptions','UpdateRegistrationPhase'])
text="""package {
 import flash.display.*;import flash.events.*;import flash.net.*;import flash.geom.*;import flash.text.*;import flash.utils.*;import flash.system.*;import flash.external.ExternalInterface;
 import Logics.KingChallenge.*;import Logics.Streamization.KingChallenge.TUnsteamizerKingChallenge;
 public class TApplication extends Sprite {
  private var view:ProbeWindow;private var step:int=0;private var clock:Timer;
  public function TApplication(){if(stage)boot();else addEventListener(Event.ADDED_TO_STAGE,boot);}
  private function boot(e:Event=null):void {stage.scaleMode=StageScaleMode.NO_SCALE;stage.align=StageAlign.TOP_LEFT;graphics.beginFill(0x15262c);graphics.drawRect(0,0,1250,720);graphics.endFill();loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,function(event:UncaughtErrorEvent):void{report("ERROR "+event.error);event.preventDefault();});
   var loader:Loader=new Loader();loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(e:Event):void{var type:Class=loader.contentLoaderInfo.applicationDomain.getDefinition("MC_KingChallenge") as Class;view=new ProbeWindow(new type() as Sprite);addChild(view);testProtocol();clock=new Timer(1400);clock.addEventListener(TimerEvent.TIMER,tick);clock.start();});loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(e:Event):void{report("ERROR "+e.text);});loader.load(new URLRequest("/ui.swf"),new LoaderContext(false,new ApplicationDomain(ApplicationDomain.currentDomain)));
  }
  private function roles(group:uint):ByteArray {var p:ByteArray=new ByteArray();p.writeShort(1);p.writeUnsignedInt(1);p.writeUnsignedInt(1);p.writeUnsignedInt(11100001);p.writeUnsignedInt(100);p.writeInt(0);p.writeInt(54);p.writeInt(974);p.writeUTF("Người chơi ki?m tra");p.writeUTF("Local");p.writeUnsignedInt(group);p.position=0;return p;}
  private function testProtocol():void {
   var data:TKingChallenge=new TKingChallenge();var decoder:TUnsteamizerKingChallenge=new TUnsteamizerKingChallenge(data);data.ViewGroup=4;decoder.InitRet(roles(1));if(data.PlayersInfo.length!=0)throw new Error("Stale tab response was accepted");data.ViewGroup=1;decoder.InitRet(roles(1));if(data.PlayersInfo.length!=1)throw new Error("Current tab response lost");decoder.InitRet(roles(4));if(data.PlayersInfo.length!=1)throw new Error("Stale tab cleared roster");
   var p:ByteArray=new ByteArray();p.writeUnsignedInt(0);p.writeUnsignedInt(12345);p.writeShort(0);p.writeByte(4);p.writeBoolean(true);p.writeByte(1);p.writeByte(0);p.writeByte(3);p.writeShort(2);p.position=0;decoder.BaseRet(p);if(data.RegistrationGroup!=3000||data.UserBaseInfo.Group!=4000||TKingChallenge.ArchivedBetRewards!=2)throw new Error("Reward and registration groups mixed");report("CASE protocol stale/current tabs and archived rewards OK");TKingChallenge.ArchivedBetRewards=0;
  }
  private function tick(e:TimerEvent):void {if(step<5){view.show(step);report("CASE UI "+step);saveFrame("TOURNAMENT-"+step);step++;return;}clock.stop();report("DONE tournament native UI and protocol; remaining=0");}
  private function report(t:String):void {if(ExternalInterface.available)ExternalInterface.call("vfxProbe",t);}
  private function saveFrame(name:String):void {var bmp:BitmapData=new BitmapData(1250,720,false,0);bmp.draw(this);var jpg:ByteArray=bmp.encode(bmp.rect,new JPEGEncoderOptions(90));var hex:String="";jpg.position=0;while(jpg.bytesAvailable){var v:String=jpg.readUnsignedByte().toString(16);hex+=v.length<2?"0"+v:v;}if(ExternalInterface.available)ExternalInterface.call("vfxSnapshot",name,hex);bmp.dispose();}
 }
 internal class ProbeWindow extends Sprite {
  private var FMainScene:Sprite;private var FMC_ButtonBar:MovieClip;private var FRegistrationInfo:TextField;private var FRegistrationList:Sprite;private var FRegistrationTitle:TextField;private var FRegistrationNames:Vector.<TextField>;
  private var FData:Object;private var FCurGroup:uint=4000;private var FBtn_ShowGamble:Object={Enabled:false};private var FDetailWin:Object={Visible:false};
  public function ProbeWindow(scene:Sprite){FMainScene=scene;addChild(scene);freeze(scene);FMC_ButtonBar=scene["MC_ButtonBar"];FMC_ButtonBar.gotoAndStop(FMC_ButtonBar.totalFrames);freeze(FMC_ButtonBar);
   for each(var key:String in ["MC_Gamble","MC_Detail","MC_PrizeList","rankList"])scene[key].visible=false;
__SETUP__
   var bounds:Rectangle=scene["MC_Table"].getBounds(scene);scene.x=625-(bounds.x+bounds.width*.5);scene.y=0;
  }
  private function freeze(host:DisplayObjectContainer):void {if(host is MovieClip)MovieClip(host).stop();for(var i:int=0;i<host.numChildren;i++)if(host.getChildAt(i) is DisplayObjectContainer)freeze(host.getChildAt(i) as DisplayObjectContainer);}
  private function ProcessorShowPrize(a:Object,e:Event):void {}
  public function show(state:int):void {var rows:Array=[];var count:int=state==1?8:state==2?3:0;for(var i:int=0;i<count;i++)rows.push({UserName:"Người chơi "+(i+1)});FCurGroup=state==1||state==2?3000:4000;TKingChallenge.ArchivedBetRewards=state==4?2:0;FData={SeasonStatus:state==3?1:0,PlayersInfo:rows,BettingsInfo:[],RegistrationGroup:state==1||state==2?3000:0,UserBaseInfo:{Permission:state==1||state==2,Group:3000,AwardStatus:state==4?0:2}};if(state==2)FCurGroup=1000;for(var tab:int=0;tab<4;tab++){FMainScene["Tab_"+tab].gotoAndStop(tab==FCurGroup/1000-1?1:2);if(tab<3){FMainScene["Tab_"+tab]["TF_0"].text=[60,101,121][tab];FMainScene["Tab_"+tab]["TF_1"].text=[100,120,159][tab];}else FMainScene["Tab_"+tab]["TF_0"].text="\u0043huy\u1ec3n sinh";}FMainScene["TF_NextFight"].text=state==3?"00:05:00":"26:25:57";UpdateRegistrationPhase();}
__HELPERS__
 }
}
""".replace('__SETUP__',setup).replace('__HELPERS__',helpers)
dest=B/'probe-source/TApplication.as';dest.parent.mkdir(exist_ok=True);dest.write_text(text,encoding='utf-8');c.ff('-onerror','abort','-importScript',B/'compiled.swf',B/'raster-probe.swf',dest.parent);raw=bytearray((B/'raster-probe.swf').read_bytes());raw[3]=21;(B/'raster-probe.swf').write_bytes(raw)
print('PASS tournament native UI/protocol probe compiled')
