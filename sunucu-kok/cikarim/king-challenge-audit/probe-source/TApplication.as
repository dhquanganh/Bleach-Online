package {
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
         this.FRegistrationInfo = new TextField();
         this.FRegistrationInfo.defaultTextFormat = new TextFormat("Tahoma",12,16764006,false,null,null,null,null,"center");
         this.FRegistrationInfo.x = 20;
         this.FRegistrationInfo.y = 307;
         this.FRegistrationInfo.width = 670;
         this.FRegistrationInfo.height = 24;
         this.FRegistrationInfo.mouseEnabled = false;
         this.FMainScene.addChild(this.FRegistrationInfo);
         this.FRegistrationList = new Sprite();
         this.FRegistrationList.x = 270;
         this.FRegistrationList.y = 175;
         this.FRegistrationList.graphics.lineStyle(1,9072710);
         this.FRegistrationList.graphics.beginFill(1055267,0.97);
         this.FRegistrationList.graphics.drawRoundRect(0,0,710,340,12,12);
         this.FRegistrationList.graphics.endFill();
         this.FRegistrationTitle = new TextField();
         this.FRegistrationTitle.defaultTextFormat = new TextFormat("Tahoma",18,16764006,true,null,null,null,null,"center");
         this.FRegistrationTitle.x = 15;
         this.FRegistrationTitle.y = 16;
         this.FRegistrationTitle.width = 680;
         this.FRegistrationTitle.height = 28;
         this.FRegistrationTitle.mouseEnabled = false;
         this.FRegistrationList.addChild(this.FRegistrationTitle);
         var guidance:TextField = new TextField();
         guidance.defaultTextFormat = new TextFormat("Tahoma",12,15658700,false,null,null,null,null,"center");
         guidance.text = "Hết hạn đăng ký mới chốt danh sách và xếp trận.";
         guidance.x = 15;
         guidance.y = 48;
         guidance.width = 680;
         guidance.height = 22;
         guidance.mouseEnabled = false;
         this.FRegistrationList.addChild(guidance);
         this.FRegistrationNames = new Vector.<TextField>();
         var row:uint = 0;
         while(row < 8)
         {
            var entry:TextField = new TextField();
            entry.defaultTextFormat = new TextFormat("Tahoma",14,16777215);
            entry.x = 20 + row % 2 * 345;
            entry.y = 85 + int(row / 2) * 58;
            entry.width = 325;
            entry.height = 40;
            entry.background = true;
            entry.backgroundColor = 1780019;
            entry.border = true;
            entry.borderColor = 5261619;
            entry.mouseEnabled = false;
            this.FRegistrationNames.push(entry);
            this.FRegistrationList.addChild(entry);
            row++;
         }
         this.FRegistrationList.addChild(this.FRegistrationInfo);
         this.FMainScene.addChild(this.FRegistrationList);
         var rewardButton:Sprite=new Sprite();rewardButton.name="kingRewardButton";rewardButton.x=805;rewardButton.y=535;rewardButton.buttonMode=true;
         rewardButton.graphics.lineStyle(1,0xe0b756);rewardButton.graphics.beginFill(0x4e260a);rewardButton.graphics.drawRoundRect(0,0,130,32,6,6);rewardButton.graphics.endFill();
         var rewardText:TextField=new TextField();rewardText.defaultTextFormat=new TextFormat("Tahoma",13,0xffdd88,true,null,null,null,null,"center");rewardText.text="Phần thưởng";rewardText.width=130;rewardText.height=26;rewardText.y=5;rewardText.mouseEnabled=false;rewardButton.addChild(rewardText);
         rewardButton.addEventListener(MouseEvent.CLICK,function(event:MouseEvent):void{ProcessorShowPrize(this,event);});this.FMainScene.addChild(rewardButton);


   var bounds:Rectangle=scene["MC_Table"].getBounds(scene);scene.x=625-(bounds.x+bounds.width*.5);scene.y=0;
  }
  private function freeze(host:DisplayObjectContainer):void {if(host is MovieClip)MovieClip(host).stop();for(var i:int=0;i<host.numChildren;i++)if(host.getChildAt(i) is DisplayObjectContainer)freeze(host.getChildAt(i) as DisplayObjectContainer);}
  private function ProcessorShowPrize(a:Object,e:Event):void {}
  public function show(state:int):void {var rows:Array=[];var count:int=state==1?8:state==2?3:0;for(var i:int=0;i<count;i++)rows.push({UserName:"Người chơi "+(i+1)});FCurGroup=state==1||state==2?3000:4000;TKingChallenge.ArchivedBetRewards=state==4?2:0;FData={SeasonStatus:state==3?1:0,PlayersInfo:rows,BettingsInfo:[],RegistrationGroup:state==1||state==2?3000:0,UserBaseInfo:{Permission:state==1||state==2,Group:3000,AwardStatus:state==4?0:2}};if(state==2)FCurGroup=1000;for(var tab:int=0;tab<4;tab++){FMainScene["Tab_"+tab].gotoAndStop(tab==FCurGroup/1000-1?1:2);if(tab<3){FMainScene["Tab_"+tab]["TF_0"].text=[60,101,121][tab];FMainScene["Tab_"+tab]["TF_1"].text=[100,120,159][tab];}else FMainScene["Tab_"+tab]["TF_0"].text="Chuyển sinh";}FMainScene["TF_NextFight"].text=state==3?"00:05:00":"26:25:57";UpdateRegistrationPhase();}
      private function HideTournamentText(host:DisplayObjectContainer):void {
         for(var i:int=0;i<host.numChildren;i++){var child:DisplayObject=host.getChildAt(i);if(child.name=="kingCaption")continue;if(child is TextField||child is StaticText)child.visible=false;else if(child is DisplayObjectContainer)this.HideTournamentText(child as DisplayObjectContainer);}
      }
      private function SetTournamentCaption(host:DisplayObjectContainer,caption:String):void {
         this.HideTournamentText(host);var label:TextField=host.getChildByName("kingCaption") as TextField;
         if(label==null){label=new TextField();label.name="kingCaption";label.defaultTextFormat=new TextFormat("Tahoma",13,0xffffff,true,null,null,null,null,"center");label.mouseEnabled=false;var bounds:Rectangle=host["Btn"]!=null?host["Btn"].getBounds(host):host.getBounds(host);label.width=bounds.width;label.height=24;label.x=bounds.x;label.y=bounds.y+(bounds.height-24)*.5;host.addChild(label);}label.text=caption;
      }
      private function UpdateTournamentCaptions():void {
         if(this.FMainScene==null||this.FData==null)return;
         this.SetTournamentCaption(this.FMainScene["MC_ButtonBar"]["Btn_Upload"],this.FData.UserBaseInfo.Permission?"Cập nhật":"Đăng ký");
         this.SetTournamentCaption(this.FMainScene["MC_ButtonBar"]["Btn_Gamble"],TKingChallenge.ArchivedBetRewards>0?"Cược ("+TKingChallenge.ArchivedBetRewards+")":"Cược của tôi");
      }
      protected function UpdateRegistrationPhase() : void
      {
         var registration:Boolean = this.FData.SeasonStatus == 0;
         this.FRegistrationList.visible = registration;
         this.FMainScene["MC_Table"].visible = !registration;
         this.FMainScene["MC_HeadPoint"].visible = !registration;
         this.FMainScene["Name"].visible = !registration;
         this.FMainScene["MC_JackPiont"].visible = !registration;
         this.FBtn_ShowGamble.Enabled = !registration || this.FData.BettingsInfo.length>0 || TKingChallenge.ArchivedBetRewards>0;
         this.FRegistrationTitle.text = "ĐĂNG KÝ - " + ["Sơ cấp","Trung cấp","Cao cấp","Chuyển sinh"][this.FCurGroup/1000-1] + " (" + this.FData.PlayersInfo.length + "/8)";
         var index:uint = 0;
         while(index < 8)
         {
            this.FRegistrationNames[index].text = index + 1 + ". " + (index < this.FData.PlayersInfo.length ? this.FData.PlayersInfo[index].UserName : "Vị trí trống");
            index++;
         }
         this.FRegistrationInfo.text = registration ? (this.FData.UserBaseInfo.Permission ? "Đã đăng ký" : "Chưa đăng ký") + " | Hết giờ sẽ chốt danh sách và xếp trận" : "Đã chốt danh sách | Thiếu đối thủ: thắng miễn đấu";
         this.FRegistrationInfo.visible=registration;
         if(registration)
         {
            this.FDetailWin.Visible = false;
         }
               if(registration&&this.FData.UserBaseInfo.Permission&&this.FData.RegistrationGroup!=this.FCurGroup)this.FRegistrationInfo.text="Bạn đã đăng ký nhóm "+["Sơ cấp","Trung cấp","Cao cấp","Chuyển sinh"][this.FData.RegistrationGroup/1000-1]+"; đang xem nhóm khác.";
         this.UpdateTournamentCaptions();
      }
 }
}
