package {
 import flash.display.*;import flash.events.*;import flash.geom.*;import flash.text.*;import flash.filters.*;import flash.utils.*;import flash.external.ExternalInterface;
 public class TApplication extends Sprite {
  private var roles:Array=[];private var started:int;private var phases:Object={};
  public function TApplication(){if(stage)boot();else addEventListener(Event.ADDED_TO_STAGE,boot);}
  private function report(text:String):void{ExternalInterface.call("vfxProbe",text);}
  private function count():int{var n:int=0;for(var j:int=0;j<numChildren;j++)if(getChildAt(j).name.indexOf("characterBuffNotices_")==0)n++;return n;}
  private function boot(e:Event=null):void{
   graphics.beginFill(0x243744);graphics.drawRect(0,0,1250,650);graphics.endFill();
   for(var i:int=0;i<6;i++){var r:ProbeRole=new ProbeRole();r.Camp=i<3?0:1;r.Pos=i%3+1;r.x=200+(i%3)*400;r.y=i<3?300:600;r.scaleX=i<3?1:-1;addChild(r);roles.push(r);r.ShowBuffNoticeText(20100001);r.ShowBuffNoticeText(20100003);r.ShowBuffNoticeText(20100004);report("CASE buff role="+i);}
   started=getTimer();addEventListener(Event.ENTER_FRAME,tick);
  }
  private function tick(e:Event):void{
   var age:int=getTimer()-started;
   if(age>=1800&&!phases.refresh){phases.refresh=true;roles[0].ShowBuffNoticeText(20100001);}
   if(age>=3000&&!phases.hold){phases.hold=true;if(count()!=6)report("ERROR labels expired before four seconds");else report("HOLD_OK 3000ms");}
   if(age>=4400&&!phases.expire){phases.expire=true;if(count()!=1)report("ERROR original expiry / refresh count="+count());else report("EXPIRY_OK refreshed role remains");}
   if(age>=6200&&!phases.cleanup){phases.cleanup=true;if(count()!=0)report("ERROR labels exceeded four seconds");roles[0].ShowBuffNoticeText(20100001);roles[0].ShowBuffNoticeText(20100001);if(roles[0].FBuffNoticeLabel.text.split("\n").length!=1)report("ERROR duplicate label");roles[0].ClearBuffNoticeText();roles[1].ShowBuffNoticeText(20100001);removeChild(roles[1]);}
   if(age>=6500){if(count()!=0)report("ERROR reset/removal leaked labels");removeEventListener(Event.ENTER_FRAME,tick);report("DONE generic buff notice duration/refresh/mirror/reset; remaining="+count());}
  }
 }
 internal class ProbeRole extends Sprite {
  public var Camp:int=0;public var Pos:int=1;
  public function ProbeRole(){graphics.beginFill(0x8aafc2);graphics.drawCircle(0,-50,25);graphics.endFill();}
      public var FBuffNoticeEntries:Object={};
      public var FBuffNoticeLabel:TextField=null;
      public var FBuffNoticeStarted:int=0;
      public function ClearBuffNoticeText(event:Event=null):void {
         if(event!=null && event.target!=FBuffNoticeLabel)return;
         if(FBuffNoticeLabel!=null){
            FBuffNoticeLabel.removeEventListener(Event.ENTER_FRAME,UpdateBuffNoticeText);
            FBuffNoticeLabel.removeEventListener(Event.REMOVED_FROM_STAGE,ClearBuffNoticeText);
            if(FBuffNoticeLabel.parent!=null)FBuffNoticeLabel.parent.removeChild(FBuffNoticeLabel);
         }
         FBuffNoticeLabel=null;FBuffNoticeEntries={};
      }
      public function ShowBuffNoticeText(marker:uint):void {
         var messages:Object=JSON.parse("{\"20100001\":\"Physical ATK UP\",\"20100002\":\"Magic ATK UP\",\"20100003\":\"Physical DEF UP\",\"20100004\":\"Resistance UP\",\"20100005\":\"Speed UP\",\"20100006\":\"Critical Rate UP\",\"20100007\":\"Critical Damage UP\",\"20100008\":\"Accuracy UP\",\"20100009\":\"Dodge UP\",\"20100010\":\"Block UP\",\"20100011\":\"Combo Rate UP\",\"20100012\":\"Defense Break UP\",\"20100013\":\"Aid UP\",\"20100014\":\"Damage UP\",\"20100015\":\"Damage Reduction UP\",\"20100016\":\"Healing Received UP\",\"20100017\":\"Armor Penetration UP\",\"20100018\":\"Life Steal UP\",\"20100019\":\"Control Resistance UP\",\"20100020\":\"Silence Resistance UP\",\"20100021\":\"Fury Resistance UP\",\"20100022\":\"Fury Effect UP\",\"20100023\":\"Max HP UP\",\"20100024\":\"Debuff Immunity\",\"20100025\":\"Control Immunity\",\"20100026\":\"Invincibility\",\"20100027\":\"Reflection\",\"20100028\":\"Healing Block Immunity\",\"20100029\":\"Super Armor\",\"20100030\":\"Shield UP\",\"20100031\":\"Regeneration\",\"20100032\":\"Standard Attack Damage UP\",\"20100033\":\"Chase Damage UP\",\"20100034\":\"Extra Standard Attack\",\"20100035\":\"Extra Chase\",\"20100036\":\"Free Mystery\",\"20100037\":\"Interruption Immunity\",\"20100038\":\"Chakra Burst\",\"20100039\":\"Chakra Burst\",\"20100040\":\"Tailed Beast Mode\",\"20100041\":\"Prowess\",\"20100042\":\"Excited\",\"20100043\":\"Shukaku Resonance\",\"20100044\":\"Matatabi Resonance\",\"20100045\":\"Isobu Resonance\",\"20100046\":\"Son Goku Resonance\",\"20100047\":\"Kokuo Resonance\",\"20100048\":\"Saiken Resonance\",\"20100049\":\"Chomei Resonance\",\"20100050\":\"Gyuki Resonance\",\"20100051\":\"Kurama Resonance\"}");var message:String=messages[String(marker)];
         if(message==null || parent==null || parent.stage==null)return;
         FBuffNoticeEntries[String(marker)]={message:message,expires:getTimer()+4000};
         if(FBuffNoticeLabel==null){
            FBuffNoticeLabel=new TextField();FBuffNoticeLabel.name="characterBuffNotices_"+Camp+"_"+Pos;
            FBuffNoticeLabel.mouseEnabled=false;FBuffNoticeLabel.selectable=false;FBuffNoticeLabel.multiline=true;
            FBuffNoticeLabel.defaultTextFormat=new TextFormat("Arial",13,12320574,true,null,null,null,null,"center");
            FBuffNoticeLabel.width=300;FBuffNoticeLabel.filters=[new GlowFilter(0,1,4,4,5)];
            FBuffNoticeStarted=getTimer();parent.addChild(FBuffNoticeLabel);
            FBuffNoticeLabel.addEventListener(Event.ENTER_FRAME,UpdateBuffNoticeText);
            FBuffNoticeLabel.addEventListener(Event.REMOVED_FROM_STAGE,ClearBuffNoticeText);
         }
         UpdateBuffNoticeText(null);
      }
      public function UpdateBuffNoticeText(event:Event=null):void {
         if(FBuffNoticeLabel==null)return;
         var host:DisplayObjectContainer=FBuffNoticeLabel.parent;
         if(host==null || host.stage==null || parent!=host){ClearBuffNoticeText();return;}
         var now:int=getTimer();var keys:Array=[];var key:String;
         for(key in FBuffNoticeEntries){if(now>=int(FBuffNoticeEntries[key].expires))delete FBuffNoticeEntries[key];else keys.push(key);}
         if(keys.length==0){ClearBuffNoticeText();return;}
         keys.sort(Array.NUMERIC);var lines:Array=[];
         for each(key in keys)lines.push(String(FBuffNoticeEntries[key].message));
         FBuffNoticeLabel.text=lines.join("\n");FBuffNoticeLabel.height=FBuffNoticeLabel.textHeight+8;
         var anchor:Point=host.globalToLocal(localToGlobal(new Point(0,-160)));
         FBuffNoticeLabel.x=anchor.x-150;
         FBuffNoticeLabel.y=Math.max(4,anchor.y-FBuffNoticeLabel.height-Math.min(8,(now-FBuffNoticeStarted)/300));
      }

 }
}