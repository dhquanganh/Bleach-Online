package {
 import Foundation.Decoder.Pak.TPakDecoder;
 import ghostcat.util.easing.TweenUtil;
 import Logics.Battle.model.*;
 import flash.display.*;
 import flash.events.*;
 import flash.net.*;
 import flash.geom.*;
 import flash.filters.GlowFilter;
 import flash.utils.*;
 import flash.text.*;
 import flash.external.ExternalInterface;
 public class TApplication extends MovieClip {
  private var FId:int=11120992;
  private var FSkillId:int=0;
  private var FIndex:int=1;
  private const TYPE_ACTIVE_ATTACK:int=1;
  private const TYPE_ACTIVE_SKILL:int=2;
  private var FFrameIndex:int=0;
  private var FTsunadeVfxStarted:Boolean=false;
  private var FTsunadeVfxHit:Boolean=false;
  private static var FTsunadeFxCache:Object={};
  private static var FTsunadeFxLoading:Object={};
  private var FTsunadeActiveVfx:Array=[];
  private var FCombatVfxSerial:uint=0;
  private var FTsunadeCrowClone:Sprite;
  private var FTsunadeCrowCloneTick:Function;
  private var FTsunadeCrowCloneRemoved:Function;
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
  private var skills:Array=[13122801, 13122802, 13122803, 13122804];
  private var clipNames:Array=["mystery", "standard", "courage", "chase"];
  private var metadata:Object={"idle":{"assets":[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47],"loop":true,"duration":40,"sourceAction":"C_idle","hitFrames":[24]},"run":{"assets":[48,49,50,51],"loop":true,"duration":40,"sourceAction":"C_run1_2","hitFrames":[2]},"hit":{"assets":[52,53,54,55,56,57,58,0],"loop":false,"duration":40,"sourceAction":"D_stand_behit1","hitFrames":[3],"returnFrame":7},"dead":{"assets":[59,60,61,62,63,64,65,66,67,68,69,70,71,71],"loop":false,"duration":40,"sourceAction":"C_dead","hitFrames":[6],"returnFrame":13},"courage":{"assets":[72,73,74,75,76,77,78,79,80,81,82,83,84,84,84,84,84,84,84,84,84,84,84,84,84,84,84,84,84,84,84,84,84,84,0],"loop":false,"duration":40,"sourceAction":"C_entry","hitFrames":[6],"returnFrame":34},"standard":{"assets":[85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,126,126,126,126,126,126,126,126,0],"loop":false,"duration":40,"sourceAction":"A_1hit","hitFrames":[14],"returnFrame":50},"mystery":{"assets":[127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,198,0],"loop":false,"duration":40,"sourceAction":"SP_skill_3","hitFrames":[8,11,15,18,21,24,27,47],"returnFrame":73},"chase":{"assets":[199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,235,0],"loop":false,"duration":40,"sourceAction":"SP_skill_1","hitFrames":[34],"returnFrame":87}};
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
   loadTexture("00A9B173",["idle"]);
   loadTexture("A9B1730B",["standard"]);
   loadTexture("A9B1730C",["mystery","courage","chase"]);
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
   var clip:Object=clips[name];if(clip==null)return;index=Math.max(0,Math.min(index,clip.images.length-1));role.actor.bitmapData=clip.images[index];role.actor.x=-clip.meta[index].px;role.actor.y=-clip.meta[index].py;role.AsumaWindStrikePose({Pivot:{X:clip.meta[index].px,Y:clip.meta[index].py}});
  }
  private function tick(event:Event):void {
   for each(var decoder:TPakDecoder in decoders)if(decoder.Unstreamizing)decoder.Process();if(loaded<5)return;
   if(readyAt<0){readyAt=getTimer()+2000;ProbeRole.PreloadAsumaWindNative();}if(getTimer()<readyAt)return;
   var age:int=getTimer()-readyAt;var bounds:Array=[0, 3460, 6000, 7900, 11920, 15380, 17920, 19820, 23840];var slot:int=0;while(slot<8 && age>=bounds[slot+1])slot++;
   if(slot>=8){left.FSkillId=0;right.FSkillId=0;left.ClearAsumaWindVfx();right.ClearAsumaWindVfx();var remaining:int=0;for(var q:int=0;q<battle.numChildren;q++)if(battle.getChildAt(q).name=="asumaWindSkillVfx")remaining++;report("DONE Asuma native component; remaining="+remaining);removeEventListener(Event.ENTER_FRAME,tick);return;}
   var side:int=slot<4?0:1;var index:int=slot%4;var caster:ProbeRole=side==0?left:right;var victim:ProbeRole=side==0?right:left;caster.Camp=side;victim.Camp=1-side;
   caster.FTargets=index==2?[caster]:[victim];caster.FResults=[{CMD:index==2?0:1,ResultInfo:{HurtHp:10}}];
   if(lastSlot!=slot){left.ClearAsumaWindVfx();right.ClearAsumaWindVfx();left.FSkillId=0;right.FSkillId=0;++caster.FCombatVfxSerial;caster.FSkillId=skills[index];caster.FFrameIndex=0;caster.y=440;victim.y=440;lastSlot=slot;label.text="Asuma Wind Blade | "+clipNames[index]+" | camp "+side;report("CASE "+skills[index]+" camp="+side);}
   var frame:int=int((age-bounds[slot])/40);var name:String=clipNames[index];caster.FFrameIndex=frame;
   if(frame<clips[name].images.length){renderRole(caster,name,frame);caster.UpdateAsumaWindVfx();}else{caster.FSkillId=0;renderRole(caster,"idle",int(age/100)%clips.idle.images.length);}
   renderRole(victim,"idle",int(age/100)%clips.idle.images.length);
   for each(var phase:int in [4,int(clips[name].images.length*.4),int(clips[name].images.length*.7)]){var key:String="CASE-"+name+"-camp-"+side+"-frame-"+phase;if(frame>=phase&&!captured[key]){captured[key]=true;var started:int=getTimer();saveFrame(key);readyAt+=getTimer()-started;}}
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
 public var FId:int=11121011;public var FSkillId:int=0;public var FIndex:int=1;public var FFrameIndex:int=0;public var Camp:int=0;public var Pos:int=1;
 public const TYPE_ACTIVE_ATTACK:int=1;public const TYPE_ACTIVE_SKILL:int=2;
 public static var FAsumaWindNative:Object={};public var FAsumaWindStarted:Boolean=false;public var FAsumaWindLayers:Array=[];public var FCombatVfxSerial:uint=0;
 public var FBattleStage:Sprite;public var FTargets:Array=[];public var FResults:Array=[];public var actor:Bitmap=new Bitmap();public function get FBitmap():Bitmap{return actor;}
 public function ProbeRole(){actor.smoothing=true;addChild(actor);}
      public static function PreloadAsumaWindNative():void {
         for each(var effect:String in ["asima-fykc","ASIMA2hit","ASM_huijishao","ASIMAentry"])LoadAsumaWindNative(effect);
      }
      public static function LoadAsumaWindNative(effect:String):void {
         if(FAsumaWindNative[effect]!=null)return;
         var state:Object={};FAsumaWindNative[effect]=state;var loader:Loader=new Loader();state.loader=loader;
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(event:Event):void{state.domain=loader.contentLoaderInfo.applicationDomain;if(loader.content is MovieClip)MovieClip(loader.content).stop();});
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(event:IOErrorEvent):void{delete FAsumaWindNative[effect];});
         loader.load(new URLRequest("/public/asuma-wind-vfx/native/"+effect+".swf"),new flash.system.LoaderContext(false,new flash.system.ApplicationDomain()));
      }
      public function ClearAsumaWindVfx():void {
         for each(var layer:Sprite in FAsumaWindLayers)if(layer.parent!=null)layer.parent.removeChild(layer);
         FAsumaWindLayers=[];FAsumaWindStarted=false;
      }
      public function UpdateAsumaWindVfx():void {
         if(FId!=11121011 || FAsumaWindStarted || (FIndex!=TYPE_ACTIVE_ATTACK && FIndex!=TYPE_ACTIVE_SKILL))return;
         FAsumaWindStarted=true;
         if(FSkillId==13122801)PlayAsumaWindNative("asima-fykc","feiyankc",0);
         else if(FSkillId==13122802)PlayAsumaWindNative("ASIMA2hit","erdaoliu",0);
         else if(FSkillId==13122803)PlayAsumaWindNative("ASIMAentry","rc",0);
         else if(FSkillId==13122804)PlayAsumaWindNative("ASM_huijishao","feiyan",12);
      }
      public function AsumaWindContactOffset():Point {
         if(FId!=11121011 || FSkillId<13122801 || FSkillId>13122804 || FTargets==null || FResults==null || FSkillId==13122803)return new Point();
         var enemy:ProbeRole=null;
         for(var i:int=0;i<FTargets.length && i<FResults.length;i++)if(FTargets[i]!=null && FTargets[i].Camp!=Camp && FResults[i].CMD==1){enemy=FTargets[i];break;}
         if(enemy==null)return new Point();
         var contact:Point=globalToLocal(enemy.localToGlobal(new Point()));
         var distance:Number=(FSkillId==13122801?220:FSkillId==13122804?327:338)*.84;
         var end:Number=Number(JSON.parse('{"13122801":73,"13122802":50,"13122803":34,"13122804":87}')[String(FSkillId)]);
         var phase:Number=Math.min(1,Math.max(0,FFrameIndex/6),Math.max(0,(end-FFrameIndex)/8));phase=phase*phase*(3-2*phase);
         return new Point((contact.x-distance)*phase,contact.y*phase);
      }
      public function AsumaWindStrikePose(frame:Object):void {
         if(FId!=11121011 || FSkillId<13122801 || FSkillId>13122804 || frame==null || (FIndex!=TYPE_ACTIVE_ATTACK && FIndex!=TYPE_ACTIVE_SKILL))return;
         var offset:Point=AsumaWindContactOffset();FBitmap.x=-frame.Pivot.X+offset.x;FBitmap.y=-frame.Pivot.Y+offset.y;
      }
      public function PlayAsumaWindNative(effect:String,symbol:String,startFrame:int):void {
         LoadAsumaWindNative(effect);var caster:ProbeRole=this;var host:DisplayObjectContainer=FBattleStage;if(host==null || stage==null)return;
         var layer:Sprite=new Sprite();layer.name="asumaWindSkillVfx";layer.mouseEnabled=false;layer.mouseChildren=false;host.addChild(layer);FAsumaWindLayers.push(layer);
         var clip:MovieClip=null;var serial:uint=FCombatVfxSerial;var skill:uint=FSkillId;var last:int=-1;var tick:Function;var clear:Function;var cleaned:Boolean=false;
         clear=function(event:Event=null):void{if(cleaned || event!=null && event.target!=layer)return;cleaned=true;layer.removeEventListener(Event.ENTER_FRAME,tick);layer.removeEventListener(Event.REMOVED_FROM_STAGE,clear);if(clip!=null)clip.stop();if(layer.parent!=null)layer.parent.removeChild(layer);};
         tick=function(event:Event=null):void{
            if(host.stage==null || caster.stage==null || caster.FCombatVfxSerial!=serial || caster.FSkillId!=skill || (caster.FIndex!=TYPE_ACTIVE_ATTACK && caster.FIndex!=TYPE_ACTIVE_SKILL)){clear();return;}
            var state:Object=FAsumaWindNative[effect];if(state==null || state.domain==null){layer.visible=false;return;}
            if(clip==null){if(!state.domain.hasDefinition(symbol)){clear();return;}var type:Class=state.domain.getDefinition(symbol) as Class;clip=new type() as MovieClip;clip.stop();layer.addChild(clip);}
            if(caster.FFrameIndex<startFrame){layer.visible=false;return;}
            var frame:int=Math.round((caster.FFrameIndex-startFrame)*24/25)+1;if(frame>clip.totalFrames){clear();return;}
            if(frame!=last){clip.gotoAndStop(frame);last=frame;}layer.visible=true;
            var offset:Point=caster.AsumaWindContactOffset();var at:Point=host.globalToLocal(caster.localToGlobal(new Point(70*.84+offset.x,offset.y)));
            layer.x=at.x;layer.y=at.y;layer.scaleX=caster.scaleX<0?-.84:.84;layer.scaleY=.84;
         };
         layer.addEventListener(Event.ENTER_FRAME,tick);layer.addEventListener(Event.REMOVED_FROM_STAGE,clear);tick();
      }

 }
}