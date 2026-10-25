package {
 import Foundation.Decoder.Pak.TPakDecoder;
 import ghostcat.util.easing.TweenUtil;
 import Logics.Battle.model.*;
 import flash.display.*;
 import flash.events.*;
 import flash.net.*;
 import flash.geom.*;
 import flash.system.*;
 import flash.filters.GlowFilter;
 import flash.utils.*;
 import flash.text.*;
 import flash.external.ExternalInterface;
 public class TApplication extends MovieClip {
  private var FId:int=11120994;
  private var FSkillId:int=0;
  private var FIndex:int=1;
  private const TYPE_ACTIVE_ATTACK:int=1;
  private const TYPE_ACTIVE_SKILL:int=2;
  private var FFrameIndex:int=0;
  private var FNineTailsVfxStarted:Boolean=false;
  private var FNineTailsVfxHit:Boolean=false;
  private static var FNineTailsFxCache:Object={};
  private static var FNineTailsFxLoading:Object={};
  private var FNineTailsActiveVfx:Array=[];
  private var FCombatVfxSerial:uint=0;
  private var FNineTailsCrowClone:Sprite;
  private var FNineTailsCrowCloneTick:Function;
  private var FNineTailsCrowCloneRemoved:Function;
  private var FTextureFightIdle:Object;
  private var FIsDie:Boolean=false;
  public var CurHealth:Number=1000;
  private function get FBitmap():Bitmap{return actor;}
  private var FBattleStage:Sprite;
  private var FTargets:Array=[];
  private var FResults:Array=[];
  public var Camp:int=0;
  public var Pos:int=6;
  private var actor:Bitmap=new Bitmap();
  private var clips:Object={};
  private var decoders:Array=[];
  private var loaded:int=0;
  private var readyAt:int=-1;
  private var lastSlot:int=-1;
  private var captured:Object={};
  private var battle:Sprite;
  private var left:ProbeRole;
  private var right:ProbeRole;
  private var label:TextField;
  private var skills:Array=[13121701,13121702,13121703,13121704,13121706];
  private var clipNames:Array=["mystery","standard","standard2","combo","healing"];
  private var metadata:Object={"idle":{"assets":[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33],"loop":true,"duration":40,"sourceAction":"C_idle","sourceFrames":32,"hitFrames":[17]},"run":{"assets":[34,35,36,37],"loop":true,"duration":40,"sourceAction":"C_run1_2","sourceFrames":3,"hitFrames":[2]},"hit":{"assets":[38,39,40,41,42,43,44,0],"loop":false,"duration":40,"sourceAction":"D_stand_behit1","sourceFrames":6,"hitFrames":[3],"returnFrame":7},"dead":{"assets":[45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,61],"loop":false,"duration":40,"sourceAction":"C_dead","sourceFrames":16,"hitFrames":[8],"returnFrame":17},"standard":{"assets":[62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,79,79,79,0],"loop":false,"duration":40,"sourceAction":"A_1hit","sourceFrames":17,"hitFrames":[7],"returnFrame":21},"standard2":{"assets":[80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,0],"loop":false,"duration":40,"sourceAction":"A_2hit","sourceFrames":28,"hitFrames":[7,18],"returnFrame":30},"combo":{"assets":[110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,0],"loop":false,"duration":40,"sourceAction":"A_3hit","sourceFrames":43,"hitFrames":[7,18,32],"returnFrame":45},"mystery":{"assets":[155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,272,272,272,272,272,272,272,0],"loop":false,"duration":40,"sourceAction":"SP_skill1","sourceFrames":113,"hitFrames":[62,86],"returnFrame":125},"healing":{"assets":[273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,0],"loop":false,"duration":40,"sourceAction":"SP_skill2","sourceFrames":26,"hitFrames":[14],"returnFrame":28}};
  public function TApplication(root:Boolean=true){
   super();
   if(!root){actor.smoothing=true;addChild(actor);return;}
   addEventListener(Event.ADDED_TO_STAGE,boot);if(stage!=null)boot();
  }
  private function report(text:String):void {if(ExternalInterface.available)ExternalInterface.call("vfxProbe",text);}
  private function boot(event:Event=null):void {
   removeEventListener(Event.ADDED_TO_STAGE,boot);
   stage.scaleMode=StageScaleMode.NO_SCALE;stage.align=StageAlign.TOP_LEFT;stage.frameRate=25;
   loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,function(e:UncaughtErrorEvent):void {report("ERROR "+e.error);});
   battle=new Sprite();addChild(battle);
   battle.graphics.beginFill(0x344B38);battle.graphics.drawRect(0,0,1250,650);battle.graphics.endFill();
   battle.graphics.lineStyle(1,0x59734A,0.5);
   for(var i:int=0;i<12;i++){battle.graphics.moveTo(0,300+i*30);battle.graphics.lineTo(1250,300+i*30);}
   var actors:Sprite=new Sprite();battle.addChild(actors);
   left=new ProbeRole();right=new ProbeRole();
   left.FBattleStage=battle;right.FBattleStage=battle;
   left.x=350;left.y=470;right.x=900;right.y=470;right.scaleX=-1;
   right.Camp=1;left.FTargets=[left,right,right];right.FTargets=[right,left,left];
   var results:Array=[{CMD:0,ResultInfo:{HurtHp:0}},{CMD:1,ResultInfo:{HurtHp:10}},{CMD:9,ResultInfo:{HurtHp:0}}];
   left.FResults=results;right.FResults=results;
   actors.addChild(left);actors.addChild(right);
   label=new TextField();label.defaultTextFormat=new TextFormat("_sans",20,0xffffff,true);label.width=1200;label.height=30;label.x=25;label.y=20;addChild(label);
   loadTexture("00A9B162",["idle"]);
   loadTexture("A9B1620B",["standard","standard2","combo"]);
   loadTexture("A9B1620C",["mystery","healing"]);
   addEventListener(Event.ENTER_FRAME,tick);report("BOOT native Flash shared VFX component probe");
  }
  private function loadTexture(path:String,names:Array):void {
   var loader:URLLoader=new URLLoader();loader.dataFormat=URLLoaderDataFormat.BINARY;
   loader.addEventListener(IOErrorEvent.IO_ERROR,function(e:IOErrorEvent):void {report("ERROR texture "+path+" "+e.text);});
   loader.addEventListener(Event.COMPLETE,function(e:Event):void {
    var bytes:ByteArray=loader.data as ByteArray;bytes.endian=Endian.LITTLE_ENDIAN;bytes.readUnsignedInt();
    var count:uint=bytes.readUnsignedInt();var seq:ByteArray=new ByteArray();seq.endian=Endian.LITTLE_ENDIAN;bytes.readBytes(seq,0,count);
    var total:uint=bytes.readUnsignedShort();var all:Array=[];
    for(var j:int=0;j<total;j++){
     seq.readUnsignedInt();seq.readUnsignedByte();count=seq.readUnsignedShort();var meta:Array=[];
     for(var k:int=0;k<count;k++){seq.readShort();seq.readShort();seq.readUnsignedShort();seq.readUnsignedShort();meta.push({px:seq.readShort(),py:seq.readShort(),duration:seq.readUnsignedShort()});}
     all.push(meta);
    }
    for(j=0;j<total;j++){
     count=bytes.readUnsignedInt();var pak:ByteArray=new ByteArray();bytes.readBytes(pak,0,count);
     decodeTexture(pak,String(names[j]),all[j]);
    }
   });
   loader.load(new URLRequest("/public/2026090619/Resources/Textures/Model/"+path+".TexClient"));
  }
  private function decodeTexture(pak:ByteArray,name:String,meta:Array):void {
   var decoder:TPakDecoder=new TPakDecoder();decoders.push(decoder);
   decoder.OnResourceUnstreamized=function(sender:Object,images:Vector.<BitmapData>,index:uint):void {
    clips[name]={images:images,meta:meta};loaded++;report("TEXTURE "+name+" frames="+images.length);
   };
   decoder.Unstreamize(pak,new Vector.<BitmapData>(),0);
  }
  private function cloneIdleTexture():Object {
   var idle:Object=clips.idle;
   return {GetAnimationSequenceByIndex:function(index:int):Object{return {GetAnimationFrameByIndex:function(i:int):Object{return {Surface:idle.images[i],Pivot:{X:idle.meta[i].px,Y:idle.meta[i].py}};}};}};
  }
  private function renderRole(role:ProbeRole,name:String,index:int):void {
   var clip:Object=clips[name];if(clip==null)return;index=Math.max(0,Math.min(index,clip.images.length-1));role.actor.bitmapData=clip.images[index];role.actor.x=-clip.meta[index].px;role.actor.y=-clip.meta[index].py;role.NineTailsStrikePose({Pivot:{X:clip.meta[index].px,Y:clip.meta[index].py}});role.FitNineTailsPose();
  }
  private function tick(event:Event):void {
   for each(var decoder:TPakDecoder in decoders)if(decoder.Unstreamizing)decoder.Process();if(loaded<6)return;
   if(readyAt<0){
    left.FCurSequence=idleSequence();right.FCurSequence=idleSequence();
    readyAt=getTimer()+3000;ProbeRole.PreloadNineTailsVfx();ProbeRole.PreloadNineTailsNative();
   }if(getTimer()<readyAt)return;
   var age:int=getTimer()-readyAt;var bounds:Array=[0, 6540, 8920, 11660, 15000, 17660, 24200, 26580, 29320, 32660, 35320];var slot:int=0;while(slot<10 && age>=bounds[slot+1])slot++;
   if(slot>=10){left.FSkillId=0;right.FSkillId=0;var remaining:int=0;for(var q:int=0;q<battle.numChildren;q++)if(battle.getChildAt(q).name=="nineTailsSkillVfx")remaining++;report("DONE NineTails native component; remaining="+remaining);removeEventListener(Event.ENTER_FRAME,tick);return;}
   var side:int=slot<5?0:1;var index:int=slot%5;var caster:ProbeRole=side==0?left:right;var victim:ProbeRole=side==0?right:left;
   if(lastSlot!=slot){left.FSkillId=0;right.FSkillId=0;++caster.FCombatVfxSerial;caster.FSkillId=skills[index];caster.FFrameIndex=0;caster.FNineTailsVfxStarted=false;caster.Pos=1+(index%3)*5;caster.y=380+(index%3)*45;victim.y=420;lastSlot=slot;label.text="Naruto Nine-Tails Chakra | "+clipNames[index]+" | camp "+side;report("CASE "+skills[index]+" camp="+side);}
   var frame:int=int((age-bounds[slot])/40);var name:String=clipNames[index];caster.FFrameIndex=frame;
   if(frame<clips[name].images.length){renderRole(caster,name,frame);caster.UpdateNineTailsVfx();}else{caster.FSkillId=0;renderRole(caster,"idle",int(age/100)%clips.idle.images.length);}
   renderRole(victim,"idle",int(age/100)%clips.idle.images.length);
   var hit:int=metadata[name].hitFrames!=null?int(metadata[name].hitFrames[0]):12;
   var phases:Array=name=="mystery"?[3,12,26,34,46,58,62,66,86,95,115]:[Math.max(3,hit-4),hit+4,Math.max(hit+8,int(clips[name].images.length*.72))];
   for each(var phase:int in phases){var key:String="CASE-"+skills[index]+"-camp-"+side+"-frame-"+phase;if(frame>=phase&&!captured[key]){captured[key]=true;var started:int=getTimer();saveFrame(key);readyAt+=getTimer()-started;}}
  }
  private function idleSequence():Object {return {GetAnimationFrameByIndex:function(i:int):Object{return {Surface:clips.idle.images[0],Pivot:{X:clips.idle.meta[0].px,Y:clips.idle.meta[0].py}};}};}

  private function saveFrame(name:String):void {
   var snapshot:BitmapData=new BitmapData(1250,650,false,0);
   snapshot.draw(this);
   var png:ByteArray=snapshot.encode(snapshot.rect,new JPEGEncoderOptions(88));
   var hex:String="";png.position=0;
   while(png.bytesAvailable){var value:String=png.readUnsignedByte().toString(16);hex+=value.length<2?"0"+value:value;}
   if(ExternalInterface.available)ExternalInterface.call("vfxSnapshot",name,hex);
   snapshot.dispose();
  }

 
 }
 internal class ProbeRole extends Sprite {
      public function PlayNineTailsNativeRasengan(symbol:String,delay:int=0) : void {
         var caster:ProbeRole=this;var host:DisplayObjectContainer=FBattleStage;if(host==null || stage==null)return;
         PreloadNineTailsNative();
         var layer:Sprite=new Sprite();layer.name="nineTailsSkillVfx";layer.mouseEnabled=false;layer.mouseChildren=false;
         host.addChild(layer);FNineTailsActiveVfx.push(layer);
         var clip:MovieClip=null;var serial:uint=FCombatVfxSerial;var last:int=-1;var tick:Function;var clear:Function;var cleaned:Boolean=false;
         clear=function(event:Event=null):void{if(cleaned || event!=null && event.target!=layer)return;cleaned=true;layer.removeEventListener(Event.ENTER_FRAME,tick);layer.removeEventListener(Event.REMOVED_FROM_STAGE,clear);if(clip!=null)clip.stop();if(layer.parent!=null)layer.parent.removeChild(layer);};
         tick=function(event:Event=null):void{
            if(host.stage==null || caster.FCombatVfxSerial!=serial || caster.FSkillId!=13121701){clear();return;}
            var elapsed:int=caster.FFrameIndex-delay;
            if(elapsed<0){layer.visible=false;return;}
            if(FNineTailsNative.domain==null){layer.visible=false;return;}
            if(clip==null){var type:Class=FNineTailsNative.domain.getDefinition(symbol) as Class;clip=new type() as MovieClip;clip.stop();layer.addChild(clip);}
            var frame:int=Math.round(elapsed*24/25)+1;
            if(frame>clip.totalFrames){clear();return;}
            layer.visible=true;if(frame!=last){clip.gotoAndStop(frame);last=frame;}
            if(symbol=="zlxw"){
               var travel:Point=caster.NineTailsRasenganTravel();var point:Point=host.globalToLocal(caster.localToGlobal(new Point(70+travel.x,travel.y)));
               layer.x=point.x;layer.y=point.y;layer.scaleX=caster.scaleX<0?-1:1;
            }else{
               var view:Rectangle=new Rectangle(-112.4,230.8,1529.1,370);
               var tl:Point=host.globalToLocal(host.stage.localToGlobal(new Point()));
               var br:Point=host.globalToLocal(host.stage.localToGlobal(new Point(host.stage.stageWidth,host.stage.stageHeight)));
               var sw:Number=br.x-tl.x;var sh:Number=br.y-tl.y;var fit:Number=sw/view.width;
               clip.scaleX=fit;clip.scaleY=fit;clip.x=sw*.5-(view.x+view.width/2)*fit;clip.y=sh*.4-(view.y+view.height/2)*fit;
               layer.x=tl.x;layer.y=tl.y;layer.scrollRect=new Rectangle(0,0,sw,sh);
            }
         };
         layer.addEventListener(Event.ENTER_FRAME,tick);layer.addEventListener(Event.REMOVED_FROM_STAGE,clear);tick();
      }
      public function NineTailsRasenganTravel() : Point
      {
         var motion:Object = NineTailsVfxManifest().actorMotion["13121701"];
         var root:Number = Number(motion.roots[Math.min(Math.max(0,FFrameIndex),motion.roots.length - 1)]);
         var contact:Point = new Point(440,0);
         if(FTargets != null && FResults != null)
         {
            var i:int = 0;
            while(i < FTargets.length && i < FResults.length)
            {
               if(FTargets[i] != null && FTargets[i].Camp != Camp && FResults[i].CMD == 1)
               {
                  contact = globalToLocal(FTargets[i].localToGlobal(new Point()));
                  break;
               }
               i++;
            }
         }
         var desired:Number = contact.x - 85;
         var applied:Number = root * desired / 387;
         var phase:Number = Math.max(0,Math.min(1,root / 387));
         return new Point(applied - root,contact.y * phase);
      }
      public static function PreloadNineTailsNative() : void
      {
         var loader:Loader;
         if(FNineTailsNative.domain != null || FNineTailsNative.loading)
         {
            return;
         }
         FNineTailsNative.loading = true;
         loader = new Loader();
         FNineTailsNative.loader = loader;
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(event:Event):void
         {
            FNineTailsNative.domain = loader.contentLoaderInfo.applicationDomain;
            FNineTailsNative.loading = false;
            if(loader.content is MovieClip)
            {
               MovieClip(loader.content).stop();
            }
         });
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(event:IOErrorEvent):void
         {
            FNineTailsNative.loading = false;
         });
         loader.load(new URLRequest("/public/nine-tails-vfx/native-v2/rasengan.swf"),new LoaderContext(false,new ApplicationDomain()));
      }
 public static var FNineTailsNative:Object={};
      public function NineTailsStrikePose(frame:Object) : void
      {
         if(FId != 11120994 || frame == null || stage == null || FTargets == null || FResults == null)
         {
            return;
         }
         if(FSkillId == 13121701)
         {
            var travel:Point = NineTailsRasenganTravel();
            var config:Object = NineTailsVfxManifest().actorMotion["13121701"];
            var root:Number = Number(config.roots[Math.min(Math.max(0,FFrameIndex),config.roots.length - 1)]);
            FBitmap.x = -frame.Pivot.X + root + travel.x;
            FBitmap.y = -frame.Pivot.Y + travel.y;
            return;
         }
         var motion:Object = NineTailsVfxManifest().actorMotion[String(FSkillId)];
         if(motion == null)
         {
            return;
         }
         var enemy:ProbeRole = null;
         var i:int = 0;
         while(i < FTargets.length && i < FResults.length)
         {
            if(FTargets[i] != null && FTargets[i].Camp != Camp && FResults[i].CMD == 1)
            {
               enemy = FTargets[i];
               break;
            }
            i++;
         }
         if(enemy == null)
         {
            return;
         }
         var contact:Point = globalToLocal(enemy.localToGlobal(new Point()));
         var dx:Number = contact.x - (contact.x < 0 ? -85 : 85);
         if(FFrameIndex <= motion.first)
         {
            var phase:Number = Math.max(0,Math.min(1,(FFrameIndex - motion.start) / Math.max(1,motion.first - motion.start)));
         }
         else if(FFrameIndex <= motion.last)
         {
            phase = 1;
         }
         else
         {
            phase = Math.max(0,Math.min(1,(motion.end - FFrameIndex) / Math.max(1,motion.end - motion.last)));
         }
         phase = phase * phase * (3 - 2 * phase);
         FBitmap.x = -frame.Pivot.X + dx * phase;
         FBitmap.y = -frame.Pivot.Y + contact.y * phase;
      }
  public var FId:int=11120994;
  public var FSkillId:int=0;
  public var FIndex:int=1;
  public const TYPE_ACTIVE_ATTACK:int=1;
  public const TYPE_ACTIVE_SKILL:int=2;
  public var FFrameIndex:int=0;
  public var FNineTailsVfxStarted:Boolean=false;
  public var FNineTailsVfxHit:Boolean=false;
  public static var FNineTailsFxCache:Object={};
  public static var FNineTailsFxLoading:Object={};
  public var FNineTailsActiveVfx:Array=[];
  public var FCombatVfxSerial:uint=0;
  public var FNineTailsCrowClone:Sprite;
  public var FNineTailsCrowCloneTick:Function;
  public var FNineTailsCrowCloneRemoved:Function;
  public var FTextureFightIdle:Object;
  public var FIsDie:Boolean=false;
  public var CurHealth:Number=1000;
  public function get FBitmap():Bitmap{return actor;}
  public var FBattleStage:Sprite;
  public var FTargets:Array=[];
  public var FResults:Array=[];
  public var Camp:int=0;
  public var Pos:int=6;
  public var actor:Bitmap=new Bitmap();

 public var FWaitDie:Boolean=false;public var FWaitNextCommand:Boolean=false;public var FHideFrame:int=-1;public var FHasFrozen:Boolean=false;public var FHasGiddy:Boolean=false;public var FIsAntiColorBlackWhite:Boolean=false;public var FIsRedAntiColor:Boolean=false;public var FSkilling:Boolean=false;
 public var FCallBackDict:Object={};public var FTimeDict:Object={};public var FCurSequence:Object;public var FIdlePosition:Array=null;
 public const TYPE_ACTIVE_DIE:int=5;public var FShaderBmp:Sprite=new Sprite();public var FHpBar:Sprite=new Sprite();public var FBuffSprite:Sprite=new Sprite();public var FFrozenBitmap:Sprite=new Sprite();public var FGiddyBitmap:Sprite=new Sprite();
 public function PlayFightIdle():void{}

 public function ProbeRole(){actor.smoothing=true;addChild(actor); }
      public static function PreloadNineTailsVfx() : void
      {
         var manifest:Object = NineTailsVfxManifest();
         for each(var effect:String in ["1nrvDaji_lizi_quan","MRzy"])
         {
            for each(var name:String in manifest.effects[effect])
            {
               var clip:Object = manifest.clips[name];
               var seen:Object = {};
               var head:int = 0;
               while(head < Math.min(5,clip.timeline.length))
               {
                  var page:String = clip.frameAtlases != null ? String(clip.frameAtlases[head]) : String(clip.atlas);
                  if(!seen[page])
                  {
                     seen[page] = true;
                     LoadNineTailsVfxAtlas(page,manifest.atlases[page]);
                  }
                  head++;
               }
            }
         }
      }
      public static function NineTailsPinPages(previous:Array, current:Array) : void
      {
         var pins:Object = FNineTailsFxLoading["_pins"];
         if(pins == null)
         {
            pins = {};
            FNineTailsFxLoading["_pins"] = pins;
         }
         for each(var old:String in previous)
         {
            pins[old] = Math.max(0,int(pins[old]) - 1);
            if(pins[old] == 0)
            {
               delete pins[old];
            }
         }
         for each(var key:String in current)
         {
            pins[key] = int(pins[key]) + 1;
         }
         var queue:Array = FNineTailsFxLoading["_queue"] as Array;
         if(queue != null)
         {
            var i:int = queue.length - 1;
            while(i >= 0)
            {
               var queued:String = String(queue[i].name);
               if(int(pins[queued]) == 0 && !NineTailsFirstAtlas(queued))
               {
                  queue.splice(i,1);
                  delete FNineTailsFxLoading[queued];
               }
               i--;
            }
         }
      }
      public static function PumpNineTailsVfxQueue() : void
      {
         var job:Object;
         var name:String;
         var meta:Object;
         var loader:URLLoader;
         var complete:Function;
         var failed:Function;
         var release:Function;
         var queue:Array = FNineTailsFxLoading["_queue"] as Array;
         if(queue == null || queue.length == 0 || int(FNineTailsFxLoading["_inflight"]) >= 6)
         {
            return;
         }
         queue.sortOn("deadline",Array.NUMERIC);
         job = queue.shift();
         name = String(job.name);
         meta = job.meta;
         FNineTailsFxLoading["_inflight"] = int(FNineTailsFxLoading["_inflight"]) + 1;
         loader = new URLLoader();
         loader.dataFormat = URLLoaderDataFormat.BINARY;
         release = function():void
         {
            loader.removeEventListener(Event.COMPLETE,complete);
            loader.removeEventListener(IOErrorEvent.IO_ERROR,failed);
            loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,failed);
            delete FNineTailsFxLoading[name];
            FNineTailsFxLoading["_inflight"] = Math.max(0,int(FNineTailsFxLoading["_inflight"]) - 1);
            loader.data = null;
            PumpNineTailsVfxQueue();
         };
         failed = function(event:Event):void
         {
            release();
         };
         complete = function(event:Event):void
         {
            var w:int;
            var h:int;
            var source:BitmapData;
            var frames:Array;
            var data:ByteArray = loader.data as ByteArray;
            try
            {
               if(data != null)
               {
                  data.uncompress();
                  w = int(data.readUnsignedInt());
                  h = int(data.readUnsignedInt());
                  source = new BitmapData(w,h,true,0);
                  source.setPixels(new Rectangle(0,0,w,h),data);
                  data.clear();
                  frames = [source];
                  FNineTailsFxCache[name] = frames;
                  TrimNineTailsVfxCache(name);
               }
            }
            catch(error:Error)
            {
               if(data != null)
               {
                  data.clear();
               }
               if(source != null && FNineTailsFxCache[name] == null)
               {
                  source.dispose();
               }
            }
            release();
         };
         loader.addEventListener(Event.COMPLETE,complete);
         loader.addEventListener(IOErrorEvent.IO_ERROR,failed);
         loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,failed);
         loader.load(new URLRequest(String(meta.url).replace(".png",".argb")));
         PumpNineTailsVfxQueue();
      }
      public static function LoadNineTailsVfxAtlas(name:String, meta:Object, urgent:Boolean = false, lead:int = 0) : void
      {
         if(meta == null)
         {
            return;
         }
         FNineTailsFxLoading["_age_" + name] = getTimer();
         if(FNineTailsFxCache[name] != null)
         {
            return;
         }
         var queue:Array = FNineTailsFxLoading["_queue"] as Array;
         if(queue == null)
         {
            queue = [];
            FNineTailsFxLoading["_queue"] = queue;
         }
         if(FNineTailsFxLoading[name])
         {
            var i:int = 0;
            while(i < queue.length)
            {
               if(queue[i].name == name)
               {
                  queue[i].deadline = Math.min(Number(queue[i].deadline),getTimer() + lead * 40);
                  break;
               }
               i++;
            }
            return;
         }
         FNineTailsFxLoading[name] = true;
         var job:Object = {
            "name":name,
            "meta":meta,
            "deadline":getTimer() + lead * 40
         };
         if(urgent)
         {
            queue.unshift(job);
         }
         else
         {
            queue.push(job);
         }
         PumpNineTailsVfxQueue();
      }
      public static function TrimNineTailsVfxCache(keep:String) : void
      {
         var pixels:Number = 0;
         var pins:Object = FNineTailsFxLoading["_pins"];
         for(var key:String in FNineTailsFxCache)
         {
            var frames:Array = FNineTailsFxCache[key] as Array;
            if(frames != null && frames.length > 0)
            {
               pixels += BitmapData(frames[0]).width * BitmapData(frames[0]).height;
            }
         }
         while(pixels > 40000000)
         {
            var oldest:String = null;
            var age:Number = Number.MAX_VALUE;
            for(key in FNineTailsFxCache)
            {
               if(key != keep && !NineTailsFirstAtlas(key) && (pins == null || int(pins[key]) == 0) && Number(FNineTailsFxLoading["_age_" + key]) < age)
               {
                  oldest = key;
                  age = Number(FNineTailsFxLoading["_age_" + key]);
               }
            }
            if(oldest == null)
            {
               break;
            }
            frames = FNineTailsFxCache[oldest] as Array;
            var atlas:BitmapData = BitmapData(frames[0]);
            pixels -= atlas.width * atlas.height;
            delete FNineTailsFxCache[oldest];
            delete FNineTailsFxLoading["_age_" + oldest];
            atlas.dispose();
         }
      }
      public static function NineTailsFirstAtlas(key:String) : Boolean
      {
         return NineTailsVfxManifest().firstAtlases[key] === true;
      }
      public function PlayNineTailsVfxAsset(name:String, host:DisplayObjectContainer, point:Point, width:Number, height:Number, delay:int = 0, mirrored:Boolean = false, follow:Boolean = false, behind:Boolean = false, angle:Number = 0) : void
      {
         var caster:ProbeRole;
         var layer:Sprite;
         var image:Bitmap;
         var edgeMask:Sprite;
         var gradient:Matrix;
         var field:DisplayObject;
         var outer:DisplayObjectContainer;
         var started:int;
         var castSerial:uint;
         var castSkill:int;
         var castFrame:int;
         var lastFrame:int;
         var buffer:BitmapData;
         var animate:Function;
         var cleanup:Function;
         var pre:int;
         var preload:String;
         var copyRect:Rectangle = new Rectangle();
         var copyOrigin:Point = new Point();
         var pinned:Array = [];
         var cleaned:Boolean = false;
         var manifest:Object = NineTailsVfxManifest();
         var clip:Object = manifest.clips[name];
         if(clip == null || host == null || host.stage == null)
         {
            return;
         }
         pinned = clip.aheadPages[0];
         NineTailsPinPages([],pinned);
         pre = 0;
         while(pre < pinned.length)
         {
            preload = String(pinned[pre]);
            LoadNineTailsVfxAtlas(preload,manifest.atlases[preload],pre == 0,pre * 2);
            pre++;
         }
         caster = this;
         layer = new Sprite();
         layer.name = "nineTailsSkillVfx";
         FNineTailsActiveVfx.push(layer);
         layer.mouseEnabled = false;
         layer.mouseChildren = false;
         image = new Bitmap();
         image.smoothing = true;
         if(clip.additive)
         {
            image.blendMode = "add";
         }
         layer.addChild(image);
         if(clip.softEdges)
         {
            edgeMask = new Sprite();
            gradient = new Matrix();
            gradient.createGradientBox(width,height,0,-width * Number(clip.pivot[0]),-height * Number(clip.pivot[1]));
            edgeMask.graphics.beginGradientFill(GradientType.RADIAL,[16777215,16777215],[1,0],[175,255],gradient);
            edgeMask.graphics.drawRect(-width * Number(clip.pivot[0]),-height * Number(clip.pivot[1]),width,height);
            edgeMask.graphics.endFill();
            image.cacheAsBitmap = true;
            edgeMask.cacheAsBitmap = true;
            layer.addChild(edgeMask);
            image.mask = edgeMask;
         }
         if(FSkillId == 13121199)
         {
            host.addChildAt(layer,0);
         }
         else if(behind && host.parent != null)
         {
            field = host;
            outer = host.parent;
            point = outer.globalToLocal(host.localToGlobal(point));
            host = outer;
            host.addChildAt(layer,host.getChildIndex(field));
         }
         else
         {
            host.addChild(layer);
         }
         caster = this;
         castSerial = FCombatVfxSerial;
         castSkill = FSkillId;
         castFrame = Math.max(0,FFrameIndex);
         started = getTimer() + delay;
         lastFrame = -1;
         cleanup = function(event:Event = null):void
         {
            if(event != null && event.target != layer)
            {
               return;
            }
            if(cleaned)
            {
               return;
            }
            cleaned = true;
            NineTailsPinPages(pinned,[]);
            pinned = [];
            layer.removeEventListener(Event.ENTER_FRAME,animate);
            layer.removeEventListener(Event.REMOVED_FROM_STAGE,cleanup);
            image.bitmapData = null;
            if(buffer != null)
            {
               buffer.dispose();
               buffer = null;
            }
            TrimNineTailsVfxCache("");
            if(layer.parent != null && (event == null || event.type != Event.REMOVED_FROM_STAGE))
            {
               layer.parent.removeChild(layer);
            }
         };
         animate = function(event:Event):void
         {
            if(caster.FCombatVfxSerial != castSerial || caster.FSkillId != castSkill)
            {
               cleanup();
               return;
            }
            var elapsed:int = (Math.max(0,caster.FFrameIndex) - castFrame) * 40 - delay;
            if(host.stage == null || elapsed >= clip.timeline.length * 40)
            {
               cleanup();
               return;
            }
            if(elapsed < 0)
            {
               layer.visible = false;
               return;
            }
            var frame:int = int(elapsed / 40);
            var frameAtlas:String = clip.frameAtlases != null ? String(clip.frameAtlases[frame]) : String(clip.atlas);
            var wanted:Array = clip.aheadPages[frame];
            if(pinned != wanted)
            {
               NineTailsPinPages(pinned,wanted);
               pinned = wanted;
            }
            var ahead:int = 0;
            while(ahead < wanted.length)
            {
               var page:String = String(wanted[ahead]);
               LoadNineTailsVfxAtlas(page,manifest.atlases[page],ahead == 0,ahead * 2);
               ahead++;
            }
            var frames:Array = FNineTailsFxCache[frameAtlas] as Array;
            if(frames == null)
            {
               layer.visible = buffer != null;
               return;
            }
            layer.visible = true;
            if(frame != lastFrame)
            {
               var atlas:BitmapData = BitmapData(frames[0]);
               var meta:Object = manifest.atlases[frameAtlas];
               var cellW:int = int(atlas.width / int(meta.columns));
               var cellH:int = int(atlas.height / int(meta.rows));
               if(buffer == null)
               {
                  buffer = new BitmapData(cellW,cellH,true,0);
                  image.bitmapData = buffer;
               }
               var cell:int = int(clip.timeline[frame]);
               copyRect.x = cell % int(meta.columns) * cellW;
               copyRect.y = int(cell / int(meta.columns)) * cellH;
               copyRect.width = cellW;
               copyRect.height = cellH;
               buffer.copyPixels(atlas,copyRect,copyOrigin);
               image.width = width;
               image.height = height;
               image.x = -width * Number(clip.pivot[0]);
               image.y = -height * Number(clip.pivot[1]);
               if(clip.contactBounds != null)
               {
                  var bounds:Array = clip.contactBounds[frame] as Array;
                  if(bounds != null)
                  {
                     image.x = -width * (Number(bounds[0]) + Number(bounds[2])) / (2 * clip.width);
                     image.y = -height * (Number(bounds[1]) + Number(bounds[3])) / (2 * clip.height);
                  }
               }
               if(clip.tint != null)
               {
                  image.transform.colorTransform = new ColorTransform(Number(clip.tint[0]),Number(clip.tint[1]),Number(clip.tint[2]),1);
               }
               lastFrame = frame;
            }
            if(follow && caster.stage != null)
            {
               point = host.globalToLocal(caster.localToGlobal(new Point(0,0)));
            }
            layer.x = point.x;
            layer.y = point.y;
            layer.scaleX = mirrored ? -1 : 1;
            layer.rotation = angle;
            var duration:Number = clip.timeline.length * 40;
            var fade:Number = Math.min(80,duration / 4);
            layer.alpha = Math.min(1,(elapsed + 40) / fade,Math.max(0,(duration - elapsed) / Math.min(120,duration / 4)));
         };
         layer.addEventListener(Event.ENTER_FRAME,animate);
         layer.addEventListener(Event.REMOVED_FROM_STAGE,cleanup);
         animate(null);
      }
      public function FitNineTailsPose() : void
      {
         if(FId != 11120994 || stage == null || FBitmap.bitmapData == null)
         {
            return;
         }
         var r:Rectangle = FBitmap.getBounds(stage);
         var dx:Number = 0;
         var dy:Number = 0;
         if(r.width < stage.stageWidth - 24)
         {
            if(r.left < 12)
            {
               dx = 12 - r.left;
            }
            else if(r.right > stage.stageWidth - 12)
            {
               dx = stage.stageWidth - 12 - r.right;
            }
         }
         if(r.height < stage.stageHeight - 24)
         {
            if(r.top < 12)
            {
               dy = 12 - r.top;
            }
            else if(r.bottom > stage.stageHeight - 12)
            {
               dy = stage.stageHeight - 12 - r.bottom;
            }
         }
         if(dx || dy)
         {
            var zero:Point = globalToLocal(stage.localToGlobal(new Point()));
            var shift:Point = globalToLocal(stage.localToGlobal(new Point(dx,dy)));
            FBitmap.x += shift.x - zero.x;
            FBitmap.y += shift.y - zero.y;
         }
      }
      public function NineTailsBackdrop(host:DisplayObjectContainer) : void
      {
         var tl:Point;
         var br:Point;
         var caster:ProbeRole;
         var serial:uint;
         var skill:uint;
         var cleanup:Function;
         var dim:Sprite = new Sprite();
         dim.name = "nineTailsSkillVfx";
         dim.mouseEnabled = false;
         tl = host.globalToLocal(stage.localToGlobal(new Point()));
         br = host.globalToLocal(stage.localToGlobal(new Point(stage.stageWidth,stage.stageHeight)));
         dim.graphics.beginFill(329241,0.55);
         dim.graphics.drawRect(tl.x,tl.y,br.x - tl.x,br.y - tl.y);
         dim.graphics.endFill();
         host.addChildAt(dim,0);
         FNineTailsActiveVfx.push(dim);
         caster = this;
         serial = FCombatVfxSerial;
         skill = uint(FSkillId);
         cleanup = function(e:Event):void
         {
            if(caster.stage == null || caster.FCombatVfxSerial != serial || caster.FSkillId != skill)
            {
               dim.removeEventListener(Event.ENTER_FRAME,cleanup);
               if(dim.parent != null)
               {
                  dim.parent.removeChild(dim);
               }
            }
         };
         dim.addEventListener(Event.ENTER_FRAME,cleanup);
      }
      public static function NineTailsVfxManifest() : Object
      {
         if(FNineTailsFxLoading["_manifest"] != null)
         {
            return FNineTailsFxLoading["_manifest"];
         }
         var data:Object = JSON.parse("{\"version\":6,\"frameMs\":40,\"frameRate\":25,\"atlases\":{\"1nrvDaji_lizi_quan-148-pages-v3-0\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrvDaji_lizi_quan-148-pages-v3-0.png\",\"columns\":6,\"rows\":3,\"frameCount\":15},\"1nrvDaji_lizi_quan-169-pages-v3-0\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrvDaji_lizi_quan-169-pages-v3-0.png\",\"columns\":10,\"rows\":2,\"frameCount\":20},\"1nrvDaji_lizi_quan-170-pages-v3-0\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrvDaji_lizi_quan-170-pages-v3-0.png\",\"columns\":8,\"rows\":2,\"frameCount\":11},\"1nrv_luoxuanwan-502-pages-v3-0\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-502-pages-v3-0.png\",\"columns\":3,\"rows\":4,\"frameCount\":12},\"1nrv_luoxuanwan-502-pages-v3-1\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-502-pages-v3-1.png\",\"columns\":3,\"rows\":4,\"frameCount\":12},\"1nrv_luoxuanwan-502-pages-v3-2\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-502-pages-v3-2.png\",\"columns\":3,\"rows\":2,\"frameCount\":4},\"1nrv_luoxuanwan-393-pages-v3-0\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-0.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-1\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-1.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-2\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-2.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-3\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-3.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-4\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-4.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-5\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-5.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-6\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-6.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-7\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-7.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-8\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-8.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-9\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-9.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-10\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-10.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-11\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-11.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-12\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-12.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-13\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-13.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-14\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-14.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-15\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-15.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-16\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-16.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-17\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-17.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-18\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-18.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-19\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-19.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-20\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-20.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-21\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-21.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-22\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-22.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-23\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-23.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-24\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-24.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-25\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-25.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-26\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-26.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-27\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-27.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-28\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-28.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-29\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-29.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-30\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-30.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-31\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-31.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-32\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-32.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-33\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-33.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-34\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-34.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-35\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-35.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-36\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-36.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-37\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-37.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-38\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-38.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-39\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-39.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-40\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-40.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-41\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-41.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-42\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-42.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-43\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-43.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-44\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-44.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"1nrv_luoxuanwan-393-pages-v3-45\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/1nrv_luoxuanwan-393-pages-v3-45.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"MRzy-29-pages-v3-0\":{\"url\":\"/public/nine-tails-vfx/aligned-hd/MRzy-29-pages-v3-0.png\",\"columns\":4,\"rows\":3,\"frameCount\":12}},\"clips\":{\"1nrvDaji_lizi_quan-148\":{\"atlas\":\"1nrvDaji_lizi_quan-148-pages-v3-0\",\"frameAtlases\":[\"1nrvDaji_lizi_quan-148-pages-v3-0\",\"1nrvDaji_lizi_quan-148-pages-v3-0\",\"1nrvDaji_lizi_quan-148-pages-v3-0\",\"1nrvDaji_lizi_quan-148-pages-v3-0\",\"1nrvDaji_lizi_quan-148-pages-v3-0\",\"1nrvDaji_lizi_quan-148-pages-v3-0\",\"1nrvDaji_lizi_quan-148-pages-v3-0\",\"1nrvDaji_lizi_quan-148-pages-v3-0\",\"1nrvDaji_lizi_quan-148-pages-v3-0\",\"1nrvDaji_lizi_quan-148-pages-v3-0\",\"1nrvDaji_lizi_quan-148-pages-v3-0\",\"1nrvDaji_lizi_quan-148-pages-v3-0\",\"1nrvDaji_lizi_quan-148-pages-v3-0\",\"1nrvDaji_lizi_quan-148-pages-v3-0\",\"1nrvDaji_lizi_quan-148-pages-v3-0\",\"1nrvDaji_lizi_quan-148-pages-v3-0\"],\"timeline\":[0,1,2,3,4,5,6,7,8,9,10,11,12,12,13,14],\"width\":325,\"height\":503,\"pivot\":[-0.09624615384615386,0.9333598409542742],\"renderScale\":1.4,\"sourceFrames\":15,\"sourceCrop\":[59,53,384,556],\"sourceZoom\":1.4,\"contactBounds\":[[98,249,182,480],[77,195,215,482],[30,123,278,492],[5,4,317,489],[5,17,318,486],[7,31,316,493],[9,45,316,482],[8,47,314,482],[9,49,314,478],[11,50,313,484],[18,52,171,483],[38,156,163,483],[60,262,154,487],[60,262,154,487],[81,370,160,494],null]},\"1nrvDaji_lizi_quan-169\":{\"atlas\":\"1nrvDaji_lizi_quan-169-pages-v3-0\",\"frameAtlases\":[\"1nrvDaji_lizi_quan-169-pages-v3-0\",\"1nrvDaji_lizi_quan-169-pages-v3-0\",\"1nrvDaji_lizi_quan-169-pages-v3-0\",\"1nrvDaji_lizi_quan-169-pages-v3-0\",\"1nrvDaji_lizi_quan-169-pages-v3-0\",\"1nrvDaji_lizi_quan-169-pages-v3-0\",\"1nrvDaji_lizi_quan-169-pages-v3-0\",\"1nrvDaji_lizi_quan-169-pages-v3-0\",\"1nrvDaji_lizi_quan-169-pages-v3-0\",\"1nrvDaji_lizi_quan-169-pages-v3-0\",\"1nrvDaji_lizi_quan-169-pages-v3-0\",\"1nrvDaji_lizi_quan-169-pages-v3-0\",\"1nrvDaji_lizi_quan-169-pages-v3-0\",\"1nrvDaji_lizi_quan-169-pages-v3-0\",\"1nrvDaji_lizi_quan-169-pages-v3-0\",\"1nrvDaji_lizi_quan-169-pages-v3-0\",\"1nrvDaji_lizi_quan-169-pages-v3-0\",\"1nrvDaji_lizi_quan-169-pages-v3-0\",\"1nrvDaji_lizi_quan-169-pages-v3-0\",\"1nrvDaji_lizi_quan-169-pages-v3-0\",\"1nrvDaji_lizi_quan-169-pages-v3-0\"],\"timeline\":[0,1,2,3,4,5,6,7,8,9,10,11,12,12,13,14,15,16,17,18,19],\"width\":203,\"height\":190,\"pivot\":[0.7690147783251231,1.1024736842105263],\"renderScale\":1.4,\"sourceFrames\":20,\"sourceCrop\":[10,9,213,199],\"sourceZoom\":1.4,\"contactBounds\":[[12,21,199,147],[7,18,194,144],[6,17,193,141],[6,15,193,140],[5,14,193,138],[4,11,194,184],[4,10,194,181],[3,11,198,180],[3,10,198,176],[3,7,199,173],[3,19,200,169],[4,16,200,164],[5,15,200,159],[5,15,200,159],[6,13,200,182],[6,12,200,179],[7,10,200,175],[8,9,201,170],[11,10,200,165],[12,9,200,158],[12,6,200,151]]},\"1nrvDaji_lizi_quan-170\":{\"atlas\":\"1nrvDaji_lizi_quan-170-pages-v3-0\",\"frameAtlases\":[\"1nrvDaji_lizi_quan-170-pages-v3-0\",\"1nrvDaji_lizi_quan-170-pages-v3-0\",\"1nrvDaji_lizi_quan-170-pages-v3-0\",\"1nrvDaji_lizi_quan-170-pages-v3-0\",\"1nrvDaji_lizi_quan-170-pages-v3-0\",\"1nrvDaji_lizi_quan-170-pages-v3-0\",\"1nrvDaji_lizi_quan-170-pages-v3-0\",\"1nrvDaji_lizi_quan-170-pages-v3-0\",\"1nrvDaji_lizi_quan-170-pages-v3-0\",\"1nrvDaji_lizi_quan-170-pages-v3-0\",\"1nrvDaji_lizi_quan-170-pages-v3-0\",\"1nrvDaji_lizi_quan-170-pages-v3-0\"],\"timeline\":[0,1,2,3,4,5,6,7,8,9,10,10],\"width\":232,\"height\":238,\"pivot\":[0.4583620689655171,0.9627310924369746],\"renderScale\":1.4,\"sourceFrames\":11,\"sourceCrop\":[24,20,256,258],\"sourceZoom\":1.4,\"contactBounds\":[[81,99,128,145],[55,64,151,178],[23,35,196,212],[5,6,223,228],[5,6,225,230],[7,6,222,229],[7,8,224,227],[8,11,221,226],[9,11,221,227],[10,8,221,223],null,null]},\"1nrv_luoxuanwan-502\":{\"atlas\":\"1nrv_luoxuanwan-502-pages-v3-0\",\"frameAtlases\":[\"1nrv_luoxuanwan-502-pages-v3-0\",\"1nrv_luoxuanwan-502-pages-v3-0\",\"1nrv_luoxuanwan-502-pages-v3-0\",\"1nrv_luoxuanwan-502-pages-v3-0\",\"1nrv_luoxuanwan-502-pages-v3-0\",\"1nrv_luoxuanwan-502-pages-v3-0\",\"1nrv_luoxuanwan-502-pages-v3-0\",\"1nrv_luoxuanwan-502-pages-v3-0\",\"1nrv_luoxuanwan-502-pages-v3-0\",\"1nrv_luoxuanwan-502-pages-v3-0\",\"1nrv_luoxuanwan-502-pages-v3-0\",\"1nrv_luoxuanwan-502-pages-v3-0\",\"1nrv_luoxuanwan-502-pages-v3-1\",\"1nrv_luoxuanwan-502-pages-v3-1\",\"1nrv_luoxuanwan-502-pages-v3-1\",\"1nrv_luoxuanwan-502-pages-v3-1\",\"1nrv_luoxuanwan-502-pages-v3-1\",\"1nrv_luoxuanwan-502-pages-v3-1\",\"1nrv_luoxuanwan-502-pages-v3-1\",\"1nrv_luoxuanwan-502-pages-v3-1\",\"1nrv_luoxuanwan-502-pages-v3-1\",\"1nrv_luoxuanwan-502-pages-v3-1\",\"1nrv_luoxuanwan-502-pages-v3-1\",\"1nrv_luoxuanwan-502-pages-v3-1\",\"1nrv_luoxuanwan-502-pages-v3-1\",\"1nrv_luoxuanwan-502-pages-v3-2\",\"1nrv_luoxuanwan-502-pages-v3-2\",\"1nrv_luoxuanwan-502-pages-v3-2\",\"1nrv_luoxuanwan-502-pages-v3-2\",\"1nrv_luoxuanwan-502-pages-v3-2\",\"1nrv_luoxuanwan-502-pages-v3-2\"],\"timeline\":[0,1,2,3,4,5,6,7,8,9,10,11,0,0,1,2,3,4,5,6,7,8,9,10,11,0,1,2,2,3,3],\"width\":636,\"height\":429,\"pivot\":[0.09886526238727507,0.15185669031822885],\"renderScale\":0.34595034595034596,\"sourceFrames\":29,\"sourceCrop\":[314,575,950,1004],\"sourceZoom\":0.34595034595034596,\"contactBounds\":[[64,184,515,216],[63,184,509,215],[65,181,513,218],[62,167,522,237],[63,138,514,252],[63,121,514,277],[0,12,576,396],[12,36,549,393],[16,28,552,386],[20,31,554,389],[1,29,554,386],[18,32,550,390],[22,30,554,388],[22,30,554,388],[23,30,554,388],[24,30,553,388],[24,30,553,388],[25,30,553,388],[25,30,552,388],[26,30,552,388],[26,30,551,388],[27,30,551,388],[27,30,551,388],[28,30,550,388],[28,30,550,388],[29,30,549,388],[29,30,549,388],[69,4,519,388],[69,4,519,388],[53,0,636,429],[53,0,636,429]]},\"1nrv_luoxuanwan-393\":{\"atlas\":\"1nrv_luoxuanwan-393-pages-v3-0\",\"frameAtlases\":[\"1nrv_luoxuanwan-393-pages-v3-0\",\"1nrv_luoxuanwan-393-pages-v3-0\",\"1nrv_luoxuanwan-393-pages-v3-1\",\"1nrv_luoxuanwan-393-pages-v3-1\",\"1nrv_luoxuanwan-393-pages-v3-2\",\"1nrv_luoxuanwan-393-pages-v3-2\",\"1nrv_luoxuanwan-393-pages-v3-3\",\"1nrv_luoxuanwan-393-pages-v3-3\",\"1nrv_luoxuanwan-393-pages-v3-4\",\"1nrv_luoxuanwan-393-pages-v3-4\",\"1nrv_luoxuanwan-393-pages-v3-5\",\"1nrv_luoxuanwan-393-pages-v3-5\",\"1nrv_luoxuanwan-393-pages-v3-6\",\"1nrv_luoxuanwan-393-pages-v3-6\",\"1nrv_luoxuanwan-393-pages-v3-6\",\"1nrv_luoxuanwan-393-pages-v3-7\",\"1nrv_luoxuanwan-393-pages-v3-7\",\"1nrv_luoxuanwan-393-pages-v3-8\",\"1nrv_luoxuanwan-393-pages-v3-8\",\"1nrv_luoxuanwan-393-pages-v3-9\",\"1nrv_luoxuanwan-393-pages-v3-9\",\"1nrv_luoxuanwan-393-pages-v3-10\",\"1nrv_luoxuanwan-393-pages-v3-10\",\"1nrv_luoxuanwan-393-pages-v3-11\",\"1nrv_luoxuanwan-393-pages-v3-11\",\"1nrv_luoxuanwan-393-pages-v3-12\",\"1nrv_luoxuanwan-393-pages-v3-12\",\"1nrv_luoxuanwan-393-pages-v3-13\",\"1nrv_luoxuanwan-393-pages-v3-13\",\"1nrv_luoxuanwan-393-pages-v3-14\",\"1nrv_luoxuanwan-393-pages-v3-14\",\"1nrv_luoxuanwan-393-pages-v3-15\",\"1nrv_luoxuanwan-393-pages-v3-15\",\"1nrv_luoxuanwan-393-pages-v3-15\",\"1nrv_luoxuanwan-393-pages-v3-15\",\"1nrv_luoxuanwan-393-pages-v3-15\",\"1nrv_luoxuanwan-393-pages-v3-15\",\"1nrv_luoxuanwan-393-pages-v3-15\",\"1nrv_luoxuanwan-393-pages-v3-15\",\"1nrv_luoxuanwan-393-pages-v3-15\",\"1nrv_luoxuanwan-393-pages-v3-15\",\"1nrv_luoxuanwan-393-pages-v3-15\",\"1nrv_luoxuanwan-393-pages-v3-15\",\"1nrv_luoxuanwan-393-pages-v3-15\",\"1nrv_luoxuanwan-393-pages-v3-15\",\"1nrv_luoxuanwan-393-pages-v3-15\",\"1nrv_luoxuanwan-393-pages-v3-15\",\"1nrv_luoxuanwan-393-pages-v3-15\",\"1nrv_luoxuanwan-393-pages-v3-15\",\"1nrv_luoxuanwan-393-pages-v3-15\",\"1nrv_luoxuanwan-393-pages-v3-15\",\"1nrv_luoxuanwan-393-pages-v3-15\",\"1nrv_luoxuanwan-393-pages-v3-15\",\"1nrv_luoxuanwan-393-pages-v3-15\",\"1nrv_luoxuanwan-393-pages-v3-15\",\"1nrv_luoxuanwan-393-pages-v3-15\",\"1nrv_luoxuanwan-393-pages-v3-15\",\"1nrv_luoxuanwan-393-pages-v3-15\",\"1nrv_luoxuanwan-393-pages-v3-15\",\"1nrv_luoxuanwan-393-pages-v3-15\",\"1nrv_luoxuanwan-393-pages-v3-15\",\"1nrv_luoxuanwan-393-pages-v3-16\",\"1nrv_luoxuanwan-393-pages-v3-16\",\"1nrv_luoxuanwan-393-pages-v3-16\",\"1nrv_luoxuanwan-393-pages-v3-17\",\"1nrv_luoxuanwan-393-pages-v3-17\",\"1nrv_luoxuanwan-393-pages-v3-18\",\"1nrv_luoxuanwan-393-pages-v3-18\",\"1nrv_luoxuanwan-393-pages-v3-19\",\"1nrv_luoxuanwan-393-pages-v3-19\",\"1nrv_luoxuanwan-393-pages-v3-20\",\"1nrv_luoxuanwan-393-pages-v3-20\",\"1nrv_luoxuanwan-393-pages-v3-21\",\"1nrv_luoxuanwan-393-pages-v3-21\",\"1nrv_luoxuanwan-393-pages-v3-22\",\"1nrv_luoxuanwan-393-pages-v3-22\",\"1nrv_luoxuanwan-393-pages-v3-23\",\"1nrv_luoxuanwan-393-pages-v3-23\",\"1nrv_luoxuanwan-393-pages-v3-24\",\"1nrv_luoxuanwan-393-pages-v3-24\",\"1nrv_luoxuanwan-393-pages-v3-25\",\"1nrv_luoxuanwan-393-pages-v3-25\",\"1nrv_luoxuanwan-393-pages-v3-26\",\"1nrv_luoxuanwan-393-pages-v3-26\",\"1nrv_luoxuanwan-393-pages-v3-27\",\"1nrv_luoxuanwan-393-pages-v3-27\",\"1nrv_luoxuanwan-393-pages-v3-28\",\"1nrv_luoxuanwan-393-pages-v3-28\",\"1nrv_luoxuanwan-393-pages-v3-28\",\"1nrv_luoxuanwan-393-pages-v3-29\",\"1nrv_luoxuanwan-393-pages-v3-29\",\"1nrv_luoxuanwan-393-pages-v3-30\",\"1nrv_luoxuanwan-393-pages-v3-30\",\"1nrv_luoxuanwan-393-pages-v3-31\",\"1nrv_luoxuanwan-393-pages-v3-31\",\"1nrv_luoxuanwan-393-pages-v3-32\",\"1nrv_luoxuanwan-393-pages-v3-32\",\"1nrv_luoxuanwan-393-pages-v3-33\",\"1nrv_luoxuanwan-393-pages-v3-33\",\"1nrv_luoxuanwan-393-pages-v3-34\",\"1nrv_luoxuanwan-393-pages-v3-34\",\"1nrv_luoxuanwan-393-pages-v3-35\",\"1nrv_luoxuanwan-393-pages-v3-35\",\"1nrv_luoxuanwan-393-pages-v3-36\",\"1nrv_luoxuanwan-393-pages-v3-36\",\"1nrv_luoxuanwan-393-pages-v3-37\",\"1nrv_luoxuanwan-393-pages-v3-37\",\"1nrv_luoxuanwan-393-pages-v3-38\",\"1nrv_luoxuanwan-393-pages-v3-38\",\"1nrv_luoxuanwan-393-pages-v3-39\",\"1nrv_luoxuanwan-393-pages-v3-39\",\"1nrv_luoxuanwan-393-pages-v3-40\",\"1nrv_luoxuanwan-393-pages-v3-40\",\"1nrv_luoxuanwan-393-pages-v3-40\",\"1nrv_luoxuanwan-393-pages-v3-41\",\"1nrv_luoxuanwan-393-pages-v3-41\",\"1nrv_luoxuanwan-393-pages-v3-42\",\"1nrv_luoxuanwan-393-pages-v3-42\",\"1nrv_luoxuanwan-393-pages-v3-43\",\"1nrv_luoxuanwan-393-pages-v3-43\",\"1nrv_luoxuanwan-393-pages-v3-44\",\"1nrv_luoxuanwan-393-pages-v3-44\",\"1nrv_luoxuanwan-393-pages-v3-45\",\"1nrv_luoxuanwan-393-pages-v3-45\",\"1nrv_luoxuanwan-393-pages-v3-15\"],\"timeline\":[0,1,0,1,0,1,0,1,0,1,0,1,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,1,0,1,0,1,0,1,0,1,0,1,1],\"width\":1280,\"height\":810,\"pivot\":[0.312874251497006,0.597739221871714],\"renderScale\":0.8516300731869594,\"sourceFrames\":120,\"sourceCrop\":[113,113,1616,1064],\"sourceZoom\":1.0,\"contactBounds\":[[378,373,477,465],[387,364,481,470],[381,352,487,459],[350,380,418,455],[364,394,416,445],[355,416,394,453],[351,414,393,450],[351,319,435,470],[351,310,436,468],[350,299,438,466],[345,352,429,469],[347,339,432,467],[344,330,430,466],[344,330,430,466],[342,319,435,470],[337,310,436,469],[340,299,438,470],[335,352,429,471],[334,339,432,476],[333,330,430,473],[340,319,435,470],[340,310,436,468],[342,299,438,467],[341,352,429,469],[291,323,463,481],[281,317,489,475],[278,311,546,486],[273,330,572,499],[314,316,618,510],[341,348,656,510],[378,354,701,506],[411,374,740,484],null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,[428,353,786,483],[444,252,872,489],[444,252,872,489],[446,242,870,505],[446,161,932,569],[447,228,927,592],[447,231,942,624],[503,236,940,620],[505,219,948,605],[505,187,942,601],[505,188,957,634],[505,192,964,632],[506,153,965,599],[539,120,958,591],[499,121,973,606],[504,206,962,619],[557,195,973,654],[523,206,965,651],[489,189,973,631],[492,152,962,626],[507,154,973,664],[472,161,989,658],[478,126,982,546],[517,88,939,555],[598,230,941,574],[447,152,1026,657],[0,0,1280,810],[0,0,1280,810],[0,0,1280,810],[0,0,1280,810],[658,251,1050,529],[653,246,1066,525],[634,252,1061,521],[636,266,1077,518],[621,265,1075,519],[622,276,1066,519],[627,271,1063,530],[608,262,1045,524],[588,254,1051,518],[569,248,1050,515],[549,246,1011,511],[544,247,960,498],[510,249,929,492],[567,252,921,495],[643,321,907,491],[617,308,891,488],[592,340,875,485],[567,340,880,482],[542,350,867,479],[566,357,855,487],[552,351,841,483],[540,343,828,478],[540,343,828,478],[572,342,815,473],[546,337,803,468],[589,334,785,464],[652,333,775,459],[636,333,753,447],[622,338,731,436],[610,342,709,424],[624,360,688,412],[662,397,666,401],[642,387,644,389],null]},\"MRzy-29\":{\"atlas\":\"MRzy-29-pages-v3-0\",\"frameAtlases\":[\"MRzy-29-pages-v3-0\",\"MRzy-29-pages-v3-0\",\"MRzy-29-pages-v3-0\",\"MRzy-29-pages-v3-0\",\"MRzy-29-pages-v3-0\",\"MRzy-29-pages-v3-0\",\"MRzy-29-pages-v3-0\",\"MRzy-29-pages-v3-0\",\"MRzy-29-pages-v3-0\",\"MRzy-29-pages-v3-0\",\"MRzy-29-pages-v3-0\",\"MRzy-29-pages-v3-0\",\"MRzy-29-pages-v3-0\",\"MRzy-29-pages-v3-0\"],\"timeline\":[0,1,2,3,4,5,6,7,8,9,10,11,11,11],\"width\":458,\"height\":476,\"pivot\":[0.5042576419213973,0.9209453781512605],\"renderScale\":1.4,\"sourceFrames\":13,\"sourceCrop\":[27,23,485,499],\"sourceZoom\":1.4}},\"effects\":{\"1nrvDaji_lizi_quan\":[\"1nrvDaji_lizi_quan-148\",\"1nrvDaji_lizi_quan-169\",\"1nrvDaji_lizi_quan-170\"],\"1nrv_luoxuanwan\":[\"1nrv_luoxuanwan-502\",\"1nrv_luoxuanwan-393\"],\"MRzy\":[\"MRzy-29\"]},\"moves\":{\"13121701\":\"mystery\",\"13121702\":\"standard\",\"13121703\":\"standard2\",\"13121704\":\"combo\",\"13121706\":\"healing\"},\"actions\":{\"standard\":[\"1nrvDaji_lizi_quan\"],\"standard2\":[\"1nrvDaji_lizi_quan\"],\"combo\":[\"1nrvDaji_lizi_quan\"],\"mystery\":[\"1nrv_luoxuanwan\"],\"healing\":[\"MRzy\"]},\"actorMotion\":{\"13121701\":{\"start\":24,\"first\":62,\"last\":86,\"end\":125,\"hits\":[62,86],\"roots\":[5.0,5.0,5.0,5.0,5.0,5.0,5.0,5.0,5.0,5.0,5.0,5.0,5.0,5.0,5.0,5.0,5.0,5.0,5.0,5.0,5.0,5.0,5.0,5.0,74.0,77.0,95.0,124.0,174.0,236.0,278.0,315.0,315.0,315.0,315.0,315.0,315.0,315.0,315.0,315.0,315.0,315.0,315.0,315.0,315.0,315.0,315.0,315.0,315.0,315.0,315.0,315.0,315.0,315.0,315.0,315.0,315.0,315.0,315.0,315.0,315.0,336.0,387.0,387.0,387.0,387.0,387.0,387.0,387.0,387.0,387.0,387.0,387.0,387.0,387.0,387.0,387.0,387.0,387.0,387.0,387.0,387.0,387.0,387.0,387.0,387.0,356.0,361.0,361.0,365.0,368.0,370.0,370.0,370.0,370.0,370.0,370.0,371.0,371.0,371.0,371.0,371.0,371.0,371.0,371.0,371.0,371.0,371.0,371.0,371.0,371.0,371.0,371.0,371.0,371.0,371.0,371.0,371.0,0,0,0,0,0,0,0,0]},\"13121702\":{\"start\":0,\"first\":7,\"last\":7,\"end\":21,\"hits\":[7]},\"13121703\":{\"start\":0,\"first\":7,\"last\":18,\"end\":30,\"hits\":[7,18]},\"13121704\":{\"start\":0,\"first\":7,\"last\":32,\"end\":45,\"hits\":[7,18,32]}}}");
         data.firstAtlases = {};
         for(var key:String in data.clips)
         {
            var clip:Object = data.clips[key];
            data.firstAtlases[clip.atlas] = true;
            clip.nextAtlases = [];
            var next:String = null;
            var i:int = clip.frameAtlases.length - 1;
            while(i >= 0)
            {
               if(i + 1 < clip.frameAtlases.length && String(clip.frameAtlases[i]) != String(clip.frameAtlases[i + 1]))
               {
                  next = String(clip.frameAtlases[i + 1]);
               }
               clip.nextAtlases[i] = next;
               i--;
            }
            clip.aheadPages = [];
            var tick:int = 0;
            while(tick < clip.timeline.length)
            {
               var pages:Array = [];
               var seen:Object = {};
               var j:int = tick;
               while(j < Math.min(tick + 21,clip.timeline.length))
               {
                  var page:String = String(clip.frameAtlases[j]);
                  if(!seen[page])
                  {
                     seen[page] = true;
                     pages.push(page);
                  }
                  j++;
               }
               clip.aheadPages[tick] = pages;
               tick++;
            }
         }
         FNineTailsFxLoading["_manifest"] = data;
         return data;
      }
      public function UpdateNineTailsVfx() : void
      {
         if(FId != 11120994 || FSkillId != 13121701 && FSkillId != 13121702 && FSkillId != 13121703 && FSkillId != 13121704 && FSkillId != 13121706 || FIndex != TYPE_ACTIVE_ATTACK && FIndex != TYPE_ACTIVE_SKILL || FNineTailsVfxStarted)
         {
            return;
         }
         for each(var old:Sprite in FNineTailsActiveVfx)
         {
            if(old.parent != null)
            {
               old.parent.removeChild(old);
            }
         }
         FNineTailsActiveVfx = [];
         FNineTailsVfxStarted = true;
         ShowNineTailsVfx(FSkillId);
      }
      public function ShowNineTailsVfx(skill:int) : void
      {
         var host:DisplayObjectContainer = FBattleStage;
         if(host == null || stage == null)
         {
            return;
         }
         var origin:Point = host.globalToLocal(localToGlobal(new Point()));
         var targets:Array = [];
         var seen:Object = {};
         if(FTargets != null && FResults != null)
         {
            var i:int = 0;
            while(i < FTargets.length && i < FResults.length)
            {
               var enemy:ProbeRole = FTargets[i];
               if(!(enemy == null || enemy.Camp == Camp || FResults[i].CMD != 1))
               {
                  var key:String = enemy.Camp + "_" + enemy.Pos;
                  if(!seen[key])
                  {
                     seen[key] = true;
                     targets.push(host.globalToLocal(enemy.localToGlobal(new Point())));
                  }
               }
               i++;
            }
         }
         var unit:Number = Math.min(stage.stageWidth / 1250,stage.stageHeight / 650);
         var manifest:Object = NineTailsVfxManifest();
         var mirrored:Boolean = scaleX < 0;
         if(skill == 13121706)
         {
            var clip:Object = manifest.clips["MRzy-29"];
            PlayNineTailsVfxAsset("MRzy-29",host,origin,330 * unit,330 * unit * clip.height / clip.width,0,mirrored,true);
            return;
         }
         if(targets.length == 0)
         {
            return;
         }
         if(skill == 13121701)
         {
            PlayNineTailsNativeRasengan("zlxw");
            PlayNineTailsNativeRasengan("lian",31);
            return;
         }
         var motion:Object = manifest.actorMotion[String(skill)];
         if(motion == null)
         {
            return;
         }
         for each(point in targets)
         {
            at = point.clone();
            at.y -= 80 * unit;
            clip = manifest.clips["1nrvDaji_lizi_quan-170"];
            for each(var hit:int in motion.hits)
            {
               PlayNineTailsVfxAsset("1nrvDaji_lizi_quan-170",host,at,270 * unit,270 * unit * clip.height / clip.width,Math.max(0,hit - 2) * 40,mirrored);
            }
            clip = manifest.clips["1nrvDaji_lizi_quan-169"];
            PlayNineTailsVfxAsset("1nrvDaji_lizi_quan-169",host,at,230 * unit,230 * unit * clip.height / clip.width,Math.max(0,motion.last - 3) * 40,mirrored);
            if(skill == 13121704)
            {
               clip = manifest.clips["1nrvDaji_lizi_quan-148"];
               PlayNineTailsVfxAsset("1nrvDaji_lizi_quan-148",host,at,240 * unit,240 * unit * clip.height / clip.width,Math.max(0,motion.last - 4) * 40,mirrored);
            }
         }
      }
      public function PlayNineTailsEffect(effect:String, host:DisplayObjectContainer, at:Point, limit:Number, unit:Number, delay:int) : void
      {
         var data:Object = NineTailsVfxManifest();
         var layers:Array = data.effects[effect] as Array;
         if(layers == null)
         {
            return;
         }
         if(layers.length > 0 && data.clips[String(layers[0])].cameraClip)
         {
            var screenTL:Point = host.globalToLocal(stage.localToGlobal(new Point()));
            var screenBR:Point = host.globalToLocal(stage.localToGlobal(new Point(stage.stageWidth,stage.stageHeight)));
            var sw:Number = screenBR.x - screenTL.x;
            var sh:Number = screenBR.y - screenTL.y;
            var scale:Number = Math.min(sw / 1250,sh / 650);
            var px:Number = scaleX < 0 ? 925 : 325;
            var cameraAt:Point = new Point(screenTL.x + (sw - 1250 * scale) / 2 + px * scale,screenTL.y + (sh - 650 * scale) / 2 + 450 * scale);
            for each(var cameraKey:String in layers)
            {
               PlayNineTailsVfxAsset(cameraKey,host,cameraAt,1250 * scale,650 * scale,delay,scaleX < 0,false,false);
            }
            return;
         }
         var left:Number = 0;
         var right:Number = 0;
         var top:Number = 0;
         var bottom:Number = 0;
         for each(var key:String in layers)
         {
            var c:Object = data.clips[key];
            var w:Number = c.width / c.renderScale;
            var h:Number = c.height / c.renderScale;
            left = Math.min(left,-Number(c.pivot[0]) * w);
            right = Math.max(right,(1 - Number(c.pivot[0])) * w);
            top = Math.min(top,-Number(c.pivot[1]) * h);
            bottom = Math.max(bottom,(1 - Number(c.pivot[1])) * h);
         }
         var tl:Point = host.globalToLocal(stage.localToGlobal(new Point()));
         var br:Point = host.globalToLocal(stage.localToGlobal(new Point(stage.stageWidth,stage.stageHeight)));
         var width:Number = Math.max(1,right - left);
         var height:Number = Math.max(1,bottom - top);
         var fit:Number = Math.min(1.5 * unit,limit * unit / Math.max(width,height),(br.x - tl.x - 24 * unit) / width,(br.y - tl.y - 36 * unit) / height);
         var mirrored:Boolean = scaleX < 0;
         var low:Number = mirrored ? -right : left;
         var high:Number = mirrored ? -left : right;
         at = at.clone();
         at.x = Math.max(tl.x + 12 * unit - low * fit,Math.min(br.x - 12 * unit - high * fit,at.x));
         at.y = Math.max(tl.y + 18 * unit - top * fit,Math.min(br.y - 18 * unit - bottom * fit,at.y));
         for each(key in layers)
         {
            c = data.clips[key];
            PlayNineTailsVfxAsset(key,host,at,c.width / c.renderScale * fit,c.height / c.renderScale * fit,delay,scaleX < 0,false,false);
         }
      }
      public function RestoreNineTailsAfterRevival() : void
      {
         TweenUtil.removeTween(this,false);
         TweenUtil.removeTween(FBitmap,false);
         FIsDie = false;
         FWaitDie = false;
         FWaitNextCommand = false;
         FHideFrame = -1;
         FHasFrozen = false;
         FHasGiddy = false;
         FIsAntiColorBlackWhite = false;
         FIsRedAntiColor = false;
         FCallBackDict[TYPE_ACTIVE_DIE] = null;
         FTimeDict[TYPE_ACTIVE_DIE] = 0;
         FSkillId = 0;
         FSkilling = false;
         FNineTailsVfxStarted = false;

         alpha = 1;
         visible = true;
         filters = [];
         FBitmap.alpha = 1;
         FBitmap.visible = true;
         FBitmap.filters = [];
         FShaderBmp.visible = true;
         FHpBar.visible = true;
         FBuffSprite.visible = true;
         FFrozenBitmap.visible = false;
         FGiddyBitmap.visible = false;
         if(FIdlePosition != null)
         {
            x = FIdlePosition[0];
            y = FIdlePosition[1];
         }
         PlayFightIdle();
         var idle:Object = FCurSequence.GetAnimationFrameByIndex(0);
         if(idle != null)
         {
            FBitmap.bitmapData = idle.Surface;
            FBitmap.x = -idle.Pivot.X;
            FBitmap.y = -idle.Pivot.Y;
         }
      }
}
}
