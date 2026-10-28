package {
 import Foundation.Decoder.Pak.TPakDecoder;
 import flash.display.*;import flash.events.*;import flash.net.*;import flash.geom.*;import flash.utils.*;import flash.text.*;import flash.external.ExternalInterface;
 public class TApplication extends MovieClip {
  private var clips:Object={};private var decoders:Array=[];private var loaded:int=0;
  private var actors:Array=[];private var effects:Array=[];private var readyAt:int=-1;private var phase:int=-1;private var captured:Object={};private var deathCallbacks:int=0;private var staleCallbacks:int=0;
  private var label:TextField=new TextField();
  public function TApplication(){if(stage)boot();else addEventListener(Event.ADDED_TO_STAGE,boot);}
  private function report(t:String):void {if(ExternalInterface.available)ExternalInterface.call("vfxProbe",t);}
  private function check(ok:Boolean,message:String):void {if(!ok)throw new Error(message);}
  private function boot(e:Event=null):void {
   removeEventListener(Event.ADDED_TO_STAGE,boot);stage.scaleMode=StageScaleMode.NO_SCALE;stage.align=StageAlign.TOP_LEFT;stage.frameRate=25;
   loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,function(e:UncaughtErrorEvent):void{report("ERROR "+e.error);});
   graphics.beginFill(0x18252b);graphics.drawRect(0,0,1250,650);graphics.endFill();
   label.defaultTextFormat=new TextFormat("_sans",22,0xffffff,true);label.width=1200;label.height=40;label.x=20;label.y=20;addChild(label);
   loadTexture("Model/00A9B16B",["idle"]);loadTexture("Model/A9B16B0B",["standard","standard-2","standard-3"]);loadTexture("Model/A9B16B0C",["mystery","enhanced-mystery","counter","summon","prowess","evade","entry","dead"]);loadTexture("Model/A9B16B0D",["hit"]);loadTexture("Model/A9B16B0F",["run"]);
   addEventListener(Event.ENTER_FRAME,tick);
  }
  private function sequence(name:String):Object {return {GetAnimationFrameByIndex:function(i:int):Object {var a:Object=clips[name];return {Surface:a.images[i],Pivot:{X:a.meta[i].px,Y:a.meta[i].py}};}};}
  private function pose(actor:SmallActor,name:String,frame:int):void {var a:Object=clips[name];frame=Math.max(0,Math.min(frame,a.images.length-1));actor.FBitmap.bitmapData=a.images[frame];actor.FBitmap.x=-a.meta[frame].px;actor.FBitmap.y=-a.meta[frame].py;}
  private function spawn(actor:SmallActor):void {actor.FIsDie=false;actor.visible=true;actor.alpha=1;actor.FHpBar.visible=true;actor.FShaderBmp.visible=true;actor.FBuffSprite.visible=true;actor.PlayMinatoClonePose(false);}
  private function tick(e:Event):void {
   try {
    for each(var decoder:TPakDecoder in decoders)if(decoder.Unstreamizing)decoder.Process();if(loaded<14)return;
    if(readyAt<0){
     for(var i:int=0;i<6;i++){var a:SmallActor=new SmallActor();a.x=180+(i%3)*170+(i>=3?550:0);a.y=440;a.scaleX=i>=3?-1:1;
      a.FTextureSkill={Count:8,GetAnimationSequenceByIndex:function(index:int):Object{return sequence(index==6?"entry":"dead");}};addChild(a);actors.push(a);var fx:Bitmap=new Bitmap();fx.smoothing=true;addChild(fx);effects.push(fx);
     }readyAt=getTimer();report("CASE six original Yellow Flash Clone, both camps");
    }
    var age:int=getTimer()-readyAt;var current:int=int(age/1800);var local:int=age%1800;
    if(current!=phase){phase=current;label.text="Small Yellow Flash Clone native asset | phase "+phase+" | three summons per camp";
     for each(a in actors){
      if(phase==0||phase==5)spawn(a);
      if(phase==0){a.FTextureSkill=null;}
      if(phase==4)a.PlayMinatoClonePose(true,function(t:uint):void{deathCallbacks++;},7);
      if(phase==6){a.PlayMinatoClonePose(true,function(t:uint):void{staleCallbacks++;},8);}
     }
     if(phase==0)setTimeout(function():void{for each(var a:SmallActor in actors){check(a.FMinatoCloneStarted>=0,"entry waits for delayed texture");a.FTextureSkill={Count:8,GetAnimationSequenceByIndex:function(index:int):Object{return sequence(index==6?"entry":"dead");}};}report("LATE_TEXTURE_OK six pending entries");},200);
     if(phase==6)setTimeout(function():void{for each(var a:SmallActor in actors)spawn(a);},200);
     if(phase==7){check(deathCallbacks==6,"death callbacks exactly once");check(staleCallbacks==0,"respawn cancelled old death callbacks");for each(a in actors)check(a.visible&&a.alpha==1&&!a.FIsDie,"respawn visibility");report("RESTORE_OK six summons; cancelled death callback; source entry/idle restored");}
     if(phase==8){a=actors[0];a.PlayMinatoClonePose(true,function(t:uint):void{staleCallbacks++;},9);removeChild(a);addChild(a);spawn(a);}
     if(phase==9){check(staleCallbacks==0,"removed-from-stage callback cleanup");var remaining:int=0;for each(a in actors)if(a.FMinatoCloneStarted>=0)remaining++;check(remaining==0,"no stale pose listeners");report("DONE Yellow Flash Clone native lifecycle; remaining="+remaining);removeEventListener(Event.ENTER_FRAME,tick);return;}
    }
    for(i=0;i<actors.length;i++){
     a=actors[i];if(a.FMinatoCloneStarted<0&&!a.FIsDie)pose(a,phase==2?"standard":phase==3?"hit":phase==7?"run":"idle",int(local/40)%clips[phase==2?"standard":phase==3?"hit":phase==7?"run":"idle"].images.length);
     fx=effects[i];fx.visible=false;
     if(fx.visible){var h:Object=clips.healing;var k:int=Math.min(h.images.length-1,int(local/40));fx.bitmapData=h.images[k];fx.x=a.x-h.meta[k].px;fx.y=a.y-h.meta[k].py;}
    }
    if(local>=600&&!captured[phase]){captured[phase]=true;saveFrame("katsuyu-phase-"+phase);}
   }catch(error:Error){report("ERROR "+error+" "+error.getStackTrace());removeEventListener(Event.ENTER_FRAME,tick);}
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
   loader.load(new URLRequest("/public/2026090619/Resources/Textures/"+path+".TexClient"));
  }
private function decodeTexture(pak:ByteArray,name:String,meta:Array):void {
   var decoder:TPakDecoder=new TPakDecoder();decoders.push(decoder);
   decoder.OnResourceUnstreamized=function(sender:Object,images:Vector.<BitmapData>,index:uint):void {
    clips[name]={images:images,meta:meta};loaded++;report("TEXTURE "+name+" frames="+images.length);
   };
   decoder.Unstreamize(pak,new Vector.<BitmapData>(),0);
  }
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
 internal class SmallActor extends Sprite {
  public var FId:int=11121004;public var FTextureSkill:Object;public var FDefaultRoleTexture:Object=null;public var FIsDie:Boolean=false;public var FWaitDie:Boolean=false;public var FHideFrame:int=-1;
  public var FBitmap:Bitmap=new Bitmap();public var FShaderBmp:Sprite=new Sprite();public var FHpBar:Sprite=new Sprite();public var FBuffSprite:Sprite=new Sprite();
  public function SmallActor(){FBitmap.smoothing=true;addChild(FBitmap);}
      public var FMinatoCloneSequence:Object;
      public var FMinatoCloneStarted:Number=-1;
      public var FMinatoCloneFrames:int=0;
      public var FMinatoCloneDying:Boolean=false;
      public var FMinatoCloneSpawned:Boolean=false;
      public var FMinatoCloneCallback:Function;
      public var FMinatoCloneTime:uint=0;

      public function ClearMinatoClonePose(event:Event=null) : void {
         removeEventListener(Event.ENTER_FRAME,UpdateMinatoClonePose);
         removeEventListener(Event.REMOVED_FROM_STAGE,ClearMinatoClonePose);
         FMinatoCloneSequence=null;FMinatoCloneStarted=-1;FMinatoCloneCallback=null;
      }
      public function PlayMinatoClonePose(dying:Boolean,callback:Function=null,time:uint=0) : void {
         if(FId!=11121004)return;
         ClearMinatoClonePose();
         if(dying && !FMinatoCloneSpawned){FIsDie=true;visible=false;if(callback!=null)callback(time);return;}
         FMinatoCloneDying=dying;
         FMinatoCloneSpawned=true;
         FMinatoCloneCallback=callback;FMinatoCloneTime=time;
         FMinatoCloneFrames=dying?15:40;
         FMinatoCloneStarted=getTimer();
         if(FTextureSkill!=null && FTextureSkill!=FDefaultRoleTexture && FTextureSkill.Count>=8)FMinatoCloneSequence=FTextureSkill.GetAnimationSequenceByIndex(dying?7:6);
         FIsDie=dying;FWaitDie=false;FHideFrame=-1;
         visible=true;alpha=1;FBitmap.visible=true;FBitmap.alpha=1;FBitmap.filters=[];filters=[];
         if(dying){FShaderBmp.visible=false;FHpBar.visible=false;FBuffSprite.visible=false;}
         addEventListener(Event.ENTER_FRAME,UpdateMinatoClonePose);
         addEventListener(Event.REMOVED_FROM_STAGE,ClearMinatoClonePose);
         UpdateMinatoClonePose();
      }
      public function UpdateMinatoClonePose(event:Event=null) : void {
         if(FId!=11121004 || FMinatoCloneStarted<0)return;
         // Textures can arrive after the summon HP event. Resolve on subsequent
         // ticks instead of silently consuming the entire pose with no frames.
         if(FMinatoCloneSequence==null && FTextureSkill!=null && FTextureSkill!=FDefaultRoleTexture && FTextureSkill.Count>=8){
            FMinatoCloneSequence=FTextureSkill.GetAnimationSequenceByIndex(FMinatoCloneDying?7:6);
            FMinatoCloneStarted=getTimer();
         }
         if(FMinatoCloneSequence==null && getTimer()-FMinatoCloneStarted<2000)return;
         var index:int=Math.max(0,int((getTimer()-FMinatoCloneStarted)/40));
         if(index>=FMinatoCloneFrames){
            var callback:Function=FMinatoCloneCallback;var time:uint=FMinatoCloneTime;var dying:Boolean=FMinatoCloneDying;
            ClearMinatoClonePose();
            if(dying){visible=false;alpha=0;if(callback!=null)callback(time);}
            return;
         }
         if(FMinatoCloneSequence!=null){var frame:Object=FMinatoCloneSequence.GetAnimationFrameByIndex(index);if(frame!=null){FBitmap.bitmapData=frame.Surface;FBitmap.x=-frame.Pivot.X;FBitmap.y=-frame.Pivot.Y;}}
      }

 }
}