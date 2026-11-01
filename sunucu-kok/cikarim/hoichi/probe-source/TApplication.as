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
  private var skills:Array=[13122901, 13122902, 13122903, 13122904];
  private var clipNames:Array=["mystery", "standard", "pillars", "barrage"];
  private var metadata:Object={"idle":{"assets":[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21],"loop":true,"duration":40,"sourceAction":"C_idle","hitFrames":[11]},"run":{"assets":[22,23,24,25],"loop":true,"duration":40,"sourceAction":"C_run1_2","hitFrames":[2]},"hit":{"assets":[26,27,28,29,30,31,32,0],"loop":false,"duration":40,"sourceAction":"D_stand_behit1","hitFrames":[3],"returnFrame":7},"dead":{"assets":[33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,53],"loop":false,"duration":40,"sourceAction":"C_dead","hitFrames":[10],"returnFrame":21},"pillars":{"assets":[54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,0],"loop":false,"duration":40,"sourceAction":"SP_skill3","hitFrames":[29],"returnFrame":89},"standard":{"assets":[143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,0],"loop":false,"duration":40,"sourceAction":"A_1hit","hitFrames":[34,40],"returnFrame":69},"mystery":{"assets":[212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,0],"loop":false,"duration":40,"sourceAction":"SP_skill1","hitFrames":[41,49],"returnFrame":81},"barrage":{"assets":[293,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360,361,362,363,364,365,366,367,368,369,370,371,372,373,374,375,376,377,378,379,380,381,382,383,384,385,386,387,388,389,390,391,392,393,394,395,0],"loop":false,"duration":40,"sourceAction":"SP_skill2","hitFrames":[45,53,60,69],"returnFrame":103}};
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
   loadTexture("00A9B174",["idle"]);
   loadTexture("A9B1740B",["standard"]);
   loadTexture("A9B1740C",["mystery","pillars","barrage"]);
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
   var clip:Object=clips[name];if(clip==null)return;index=Math.max(0,Math.min(index,clip.images.length-1));role.actor.bitmapData=clip.images[index];role.actor.x=-clip.meta[index].px;role.actor.y=-clip.meta[index].py;role.HoichiStrikePose({Pivot:{X:clip.meta[index].px,Y:clip.meta[index].py}});
  }
  private function tick(event:Event):void {
   for each(var decoder:TPakDecoder in decoders)if(decoder.Unstreamizing)decoder.Process();if(loaded<5)return;
   if(readyAt<0){readyAt=getTimer()+2000;ProbeRole.PreloadHoichiNative();}if(getTimer()<readyAt)return;
   var age:int=getTimer()-readyAt;var bounds:Array=[0, 3780, 7080, 11180, 15840, 19620, 22920, 27020, 31680];var slot:int=0;while(slot<8 && age>=bounds[slot+1])slot++;
   if(slot>=8){left.FSkillId=0;right.FSkillId=0;left.ClearHoichiVfx();right.ClearHoichiVfx();var remaining:int=0;for(var q:int=0;q<battle.numChildren;q++)if(battle.getChildAt(q).name=="hoichiSkillVfx")remaining++;report("DONE Hoichi native component; remaining="+remaining);removeEventListener(Event.ENTER_FRAME,tick);return;}
   var side:int=slot<4?0:1;var index:int=slot%4;var caster:ProbeRole=side==0?left:right;var victim:ProbeRole=side==0?right:left;caster.Camp=side;victim.Camp=1-side;
   caster.FTargets=index==2?[caster]:[victim];caster.FResults=[{CMD:index==2?0:1,ResultInfo:{HurtHp:10}}];
   if(lastSlot!=slot){left.ClearHoichiVfx();right.ClearHoichiVfx();left.FSkillId=0;right.FSkillId=0;++caster.FCombatVfxSerial;caster.FSkillId=skills[index];caster.FFrameIndex=0;caster.y=440;victim.y=440;lastSlot=slot;label.text="Hoichi | "+clipNames[index]+" | camp "+side;report("CASE "+skills[index]+" camp="+side);}
   var frame:int=int((age-bounds[slot])/40);var name:String=clipNames[index];caster.FFrameIndex=frame;
   if(frame<clips[name].images.length){renderRole(caster,name,frame);caster.UpdateHoichiVfx();}else{caster.FSkillId=0;renderRole(caster,"idle",int(age/100)%clips.idle.images.length);}
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
 public var FId:int=11121012;public var FSkillId:int=0;public var FIndex:int=1;public var FFrameIndex:int=0;public var Camp:int=0;public var Pos:int=1;
 public const TYPE_ACTIVE_ATTACK:int=1;public const TYPE_ACTIVE_SKILL:int=2;
 public static var FHoichiNative:Object={};public var FHoichiStarted:Boolean=false;public var FHoichiLayers:Array=[];public var FCombatVfxSerial:uint=0;
 public var FBattleStage:Sprite;public var FTargets:Array=[];public var FResults:Array=[];public var actor:Bitmap=new Bitmap();public function get FBitmap():Bitmap{return actor;}
 public function ProbeRole(){actor.smoothing=true;addChild(actor);}
      public static function PreloadHoichiNative():void {
         for each(var effect:String in ["fayi_faliaoyi","fayi_faliliansuopugong","fayi_jiejieyu","fayi_jiejiezhi"])LoadHoichiNative(effect);
      }
      public static function LoadHoichiNative(effect:String):void {
         if(FHoichiNative[effect]!=null)return;
         var state:Object={};FHoichiNative[effect]=state;var loader:Loader=new Loader();state.loader=loader;
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(event:Event):void{state.domain=loader.contentLoaderInfo.applicationDomain;if(loader.content is MovieClip)MovieClip(loader.content).stop();});
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(event:IOErrorEvent):void{delete FHoichiNative[effect];});
         loader.load(new URLRequest("/public/hoichi-vfx/native/"+effect+".swf"),new flash.system.LoaderContext(false,new flash.system.ApplicationDomain()));
      }
      public function ClearHoichiVfx():void {
         for each(var layer:Sprite in FHoichiLayers)if(layer.parent!=null)layer.parent.removeChild(layer);
         FHoichiLayers=[];FHoichiStarted=false;
      }
      public function UpdateHoichiVfx():void {
         if(FId!=11121012 || FSkillId<13122901 || FSkillId>13122904 || FHoichiStarted || (FIndex!=TYPE_ACTIVE_ATTACK && FIndex!=TYPE_ACTIVE_SKILL))return;
         FHoichiStarted=true;
         var effect:String=FSkillId==13122901?"fayi_faliaoyi":FSkillId==13122902?"fayi_faliliansuopugong":FSkillId==13122903?"fayi_jiejieyu":"fayi_jiejiezhi";
         PlayHoichiNative(effect,"xia",0);PlayHoichiNative(effect,"shang",0);
      }
      public function HoichiContactOffset():Point {
         if(FId!=11121012 || FSkillId<13122901 || FSkillId>13122904 || FTargets==null || FResults==null || FSkillId==13122903)return new Point();
         var enemy:ProbeRole=null;
         for(var i:int=0;i<FTargets.length && i<FResults.length;i++)if(FTargets[i]!=null && FTargets[i].Camp!=Camp && FResults[i].CMD==1){enemy=FTargets[i];break;}
         if(enemy==null)return new Point();
         var contact:Point=globalToLocal(enemy.localToGlobal(new Point()));
         var distance:Number=(FSkillId==13122901?550:FSkillId==13122904?550:450)*.84;
         var end:Number=Number(JSON.parse('{"13122901":81,"13122902":69,"13122903":89,"13122904":103}')[String(FSkillId)]);
         var phase:Number=Math.min(1,Math.max(0,FFrameIndex/6),Math.max(0,(end-FFrameIndex)/8));phase=phase*phase*(3-2*phase);
         return new Point((contact.x-distance)*phase,contact.y*phase);
      }
      public function HoichiStrikePose(frame:Object):void {
         if(FId!=11121012 || FSkillId<13122901 || FSkillId>13122904 || frame==null || (FIndex!=TYPE_ACTIVE_ATTACK && FIndex!=TYPE_ACTIVE_SKILL))return;
         var offset:Point=HoichiContactOffset();FBitmap.x=-frame.Pivot.X+offset.x;FBitmap.y=-frame.Pivot.Y+offset.y;
      }
      public function PlayHoichiNative(effect:String,symbol:String,startFrame:int):void {
         LoadHoichiNative(effect);var caster:ProbeRole=this;var host:DisplayObjectContainer=FBattleStage;if(host==null || stage==null)return;
         var layer:Sprite=new Sprite();layer.name="hoichiSkillVfx";layer.mouseEnabled=false;layer.mouseChildren=false;if(symbol=="xia" && parent==host)host.addChildAt(layer,host.getChildIndex(this));else host.addChild(layer);FHoichiLayers.push(layer);
         var clip:MovieClip=null;var serial:uint=FCombatVfxSerial;var skill:uint=FSkillId;var last:int=-1;var tick:Function;var clear:Function;var cleaned:Boolean=false;
         clear=function(event:Event=null):void{if(cleaned || event!=null && event.target!=layer)return;cleaned=true;layer.removeEventListener(Event.ENTER_FRAME,tick);layer.removeEventListener(Event.REMOVED_FROM_STAGE,clear);if(clip!=null)clip.stop();if(layer.parent!=null)layer.parent.removeChild(layer);};
         tick=function(event:Event=null):void{
            if(host.stage==null || caster.stage==null || caster.FCombatVfxSerial!=serial || caster.FSkillId!=skill || (caster.FIndex!=TYPE_ACTIVE_ATTACK && caster.FIndex!=TYPE_ACTIVE_SKILL)){clear();return;}
            var state:Object=FHoichiNative[effect];if(state==null || state.domain==null){layer.visible=false;return;}
            if(clip==null){if(!state.domain.hasDefinition(symbol)){clear();return;}var type:Class=state.domain.getDefinition(symbol) as Class;clip=new type() as MovieClip;clip.stop();layer.addChild(clip);}
            if(caster.FFrameIndex<startFrame){layer.visible=false;return;}
            var frame:int=Math.round((caster.FFrameIndex-startFrame)*24/25)+1;if(frame>clip.totalFrames){clear();return;}
            if(frame!=last){clip.gotoAndStop(frame);last=frame;}layer.visible=true;
            var offset:Point=caster.HoichiContactOffset();var at:Point=host.globalToLocal(caster.localToGlobal(new Point(70*.84+offset.x,offset.y)));
            layer.x=at.x;layer.y=at.y;layer.scaleX=caster.scaleX<0?-.84:.84;layer.scaleY=.84;
         };
         layer.addEventListener(Event.ENTER_FRAME,tick);layer.addEventListener(Event.REMOVED_FROM_STAGE,clear);tick();
      }

 }
}