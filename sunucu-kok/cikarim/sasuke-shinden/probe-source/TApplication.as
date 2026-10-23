package {
 import Foundation.Decoder.Pak.TPakDecoder;
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
  private var FId:int=11120970;
  private var FSkillId:int=0;
  private var FIndex:int=1;
  private const TYPE_ACTIVE_ATTACK:int=1;
  private const TYPE_ACTIVE_SKILL:int=2;
  private var FFrameIndex:int=0;
  private var FSasukeVfxStarted:Boolean=false;
  private var FSasukeVfxHit:Boolean=false;
  private static var FSasukeFxCache:Object={};
  private static var FSasukeFxLoading:Object={};
  private var FSasukeActiveVfx:Array=[];
  private var FCombatVfxSerial:uint=0;
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
  private var skills:Array=[13121301, 13121302, 13121303, 13121304, 13121305, 13121306, 13121307, 13121308, 13121309];
  private var clipNames:Array=["mystery", "blazeMystery", "standard", "blazeStandard", "dragon", "blazeDragon", "mangekyo", "rinnegan", "susanoo"];
  private var metadata:Object={"idle":{"assets":[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39],"duration":40,"loop":true,"sourceAction":"C_idle","sourceFrames":38},"run":{"assets":[40,41,42,43],"duration":40,"loop":true,"sourceAction":"C_run1_2","sourceFrames":3},"hit":{"assets":[44,45,46,47,48,49,50,0],"duration":40,"loop":false,"sourceAction":"D_stand_behit1","sourceFrames":6,"returnFrame":7},"dead":{"assets":[51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,0],"duration":40,"loop":false,"sourceAction":"C_dead","sourceFrames":26,"returnFrame":28},"mystery":{"assets":[79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,0],"duration":40,"loop":false,"sourceAction":"SP_skill1","sourceFrames":125,"returnFrame":131,"hitFrames":[69,74,80,86,91]},"blazeMystery":{"assets":[210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,0],"duration":40,"loop":false,"sourceAction":"SP_skill1_yan","sourceFrames":125,"returnFrame":131,"hitFrames":[69,74,80,86,91]},"standard":{"assets":[341,342,343,344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360,361,362,363,364,365,366,367,368,369,370,371,372,373,374,375,376,377,378,379,380,381,382,383,384,385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,400,401,402,403,404,405,406,407,408,409,410,411,412,413,414,415,416,417,418,419,420,421,422,423,424,425,0],"duration":40,"loop":false,"sourceAction":"A_3hit","sourceFrames":81,"returnFrame":85,"hitFrames":[6,18,31,44,56]},"blazeStandard":{"assets":[426,427,428,429,430,431,432,433,434,435,436,437,438,439,440,441,442,443,444,445,446,447,448,449,450,451,452,453,454,455,456,457,458,459,460,461,462,463,464,465,466,467,468,469,470,471,472,473,474,475,476,477,478,479,480,481,482,483,484,485,486,487,488,489,490,491,492,493,494,495,496,497,498,499,500,501,502,503,504,505,506,507,508,509,510,0],"duration":40,"loop":false,"sourceAction":"A_3hit_yan","sourceFrames":81,"returnFrame":85,"hitFrames":[6,18,31,44,56]},"dragon":{"assets":[511,512,513,514,515,516,517,518,519,520,521,522,523,524,525,526,527,528,529,530,531,532,533,534,535,536,537,538,539,540,541,542,543,544,545,546,547,548,549,550,551,552,553,554,555,556,557,558,559,560,561,562,563,564,565,566,567,568,569,570,571,572,573,574,575,576,577,578,579,580,581,582,583,584,585,586,587,588,589,590,591,592,593,594,595,596,0],"duration":40,"loop":false,"sourceAction":"SP_skill2","sourceFrames":82,"returnFrame":86,"hitFrames":[24,32,41,49]},"blazeDragon":{"assets":[597,598,599,600,601,602,603,604,605,606,607,608,609,610,611,612,613,614,615,616,617,618,619,620,621,622,623,624,625,626,627,628,629,630,631,632,633,634,635,636,637,638,639,640,641,642,643,644,645,646,647,648,649,650,651,652,653,654,655,656,657,658,659,660,661,662,663,664,665,666,667,668,669,670,671,672,673,674,675,676,677,678,679,680,681,682,0],"duration":40,"loop":false,"sourceAction":"SP_skill2_yan","sourceFrames":82,"returnFrame":86,"hitFrames":[24,32,41,49]},"mangekyo":{"assets":[683,684,685,686,687,688,689,690,691,692,693,694,695,696,697,698,699,700,701,702,703,704,705,706,707,708,709,710,711,712,713,714,715,716,717,718,719,720,721,722,723,724,725,726,727,728,729,730,731,732,733,734,735,736,737,738,739,0],"duration":40,"loop":false,"sourceAction":"SP_skill3","sourceFrames":54,"returnFrame":57,"hitFrames":[27]},"rinnegan":{"assets":[740,741,742,743,744,745,746,747,748,749,750,751,752,753,754,755,756,757,758,759,760,761,762,763,764,765,766,767,768,769,770,771,772,773,774,775,776,777,778,779,780,781,782,783,784,785,786,787,788,789,790,791,792,793,794,795,796,797,798,799,800,801,802,0],"duration":40,"loop":false,"sourceAction":"SP_skill4","sourceFrames":60,"returnFrame":63,"hitFrames":[29]},"susanoo":{"assets":[803,804,805,806,807,808,809,810,811,812,813,814,815,816,817,818,819,820,821,822,823,824,825,826,827,828,829,830,831,832,833,834,835,836,837,838,839,840,841,842,0],"duration":40,"loop":false,"sourceAction":"SP_skill5","sourceFrames":38,"returnFrame":40}};
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
   loadTexture("00A9B14A",["idle"]);
   loadTexture("A9B14A0B",["standard","blazeStandard"]);
   loadTexture("A9B14A0C",["mystery", "blazeMystery", "dragon", "blazeDragon", "mangekyo", "rinnegan", "susanoo"]);
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
  private function renderRole(role:ProbeRole,name:String,index:int):void {
   var clip:Object=clips[name];if(clip==null)return;index=Math.max(0,Math.min(index,clip.images.length-1));role.actor.bitmapData=clip.images[index];role.actor.x=-clip.meta[index].px;role.actor.y=-clip.meta[index].py;role.FitSasukePose();
  }
  private function tick(event:Event):void {
   for each(var decoder:TPakDecoder in decoders)if(decoder.Unstreamizing)decoder.Process();if(loaded<10)return;
   if(readyAt<0){readyAt=getTimer()+3000;ProbeRole.PreloadSasukeVfx();}if(getTimer()<readyAt)return;
   var playback:Number=Number(loaderInfo.parameters.speed);if(playback!=1)playback=2;
   var age:int=(getTimer()-readyAt)*playback;var bounds:Array=[0, 6780, 13560, 18500, 23440, 28420, 33400, 37220, 41280, 44420, 51200, 57980, 62920, 67860, 72840, 77820, 81640, 85700, 88840];var slot:int=0;while(slot<18 && age>=bounds[slot+1])slot++;
   if(slot>=18){left.FSkillId=0;right.FSkillId=0;var remaining:int=0;for(var q:int=0;q<battle.numChildren;q++)if(battle.getChildAt(q).name=="sasukeSkillVfx")remaining++;report("DONE Sasuke native component; remaining="+remaining);removeEventListener(Event.ENTER_FRAME,tick);return;}
   var side:int=slot<9?0:1;var index:int=slot%9;var caster:ProbeRole=side==0?left:right;var victim:ProbeRole=side==0?right:left;
   if(lastSlot!=slot){left.FSkillId=0;right.FSkillId=0;++caster.FCombatVfxSerial;caster.FSkillId=skills[index];caster.FFrameIndex=0;caster.FSasukeVfxStarted=false;caster.Pos=1+(index%3)*5;caster.y=340+(index%3)*90;victim.y=390+(index%2)*100;lastSlot=slot;label.text="Sasuke Shinden | "+clipNames[index]+" | camp "+side;report("CASE "+skills[index]+" camp="+side);}
   var frame:int=int((age-bounds[slot])/40);var name:String=clipNames[index];caster.FFrameIndex=frame;
   if(frame<clips[name].images.length){renderRole(caster,name,frame);caster.UpdateSasukeVfx();}else{caster.FSkillId=0;renderRole(caster,"idle",int(age/100)%clips.idle.images.length);}
   renderRole(victim,"idle",int(age/100)%clips.idle.images.length);
   var hit:int=metadata[name].hitFrames!=null?int(metadata[name].hitFrames[0]):12;
   var phases:Array=[Math.max(3,hit-4),hit+4,Math.max(hit+8,int(clips[name].images.length*.72))];
   if(skills[index]<=13121302)phases=[40,60,69,74,80,86,91,104,125];
   if(skills[index]==13121305 || skills[index]==13121306)phases=[20,28,41,60];
   for each(var phase:int in phases){var key:String="CASE-"+skills[index]+"-camp-"+side+"-frame-"+phase;if(frame>=phase&&!captured[key]){captured[key]=true;var started:int=getTimer();
    // The parent tick runs before child ENTER_FRAME handlers. Flush effect
    // layers before drawing the screenshot, just as the screen compositor does
    // after ENTER_FRAME delivery; otherwise captures can show the previous pose.
    for(var flush:int=battle.numChildren-1;flush>=0;flush--)if(flush<battle.numChildren && battle.getChildAt(flush).name=="sasukeSkillVfx")battle.getChildAt(flush).dispatchEvent(new Event(Event.ENTER_FRAME));
    saveFrame(key);readyAt+=getTimer()-started;}}
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

 internal class ProbeRole extends Sprite {
  public var FId:int=11120970;
  public var FSkillId:int=0;
  public var FIndex:int=1;
  public const TYPE_ACTIVE_ATTACK:int=1;
  public const TYPE_ACTIVE_SKILL:int=2;
  public var FFrameIndex:int=0;
  public var FSasukeVfxStarted:Boolean=false;
  public var FSasukeVfxHit:Boolean=false;
  public static var FSasukeFxCache:Object={};
  public static var FSasukeFxLoading:Object={};
  public var FSasukeActiveVfx:Array=[];
  public var FCombatVfxSerial:uint=0;
  public function get FBitmap():Bitmap{return actor;}
  public var FBattleStage:Sprite;
  public var FTargets:Array=[];
  public var FResults:Array=[];
  public var Camp:int=0;
  public var Pos:int=6;
  public var actor:Bitmap=new Bitmap();

 public function ProbeRole(){actor.smoothing=true;addChild(actor); }
      public static function PreloadSasukeVfx() : void
      {
         var manifest:Object = SasukeVfxManifest();
         for(var cinematic:String in manifest.cinematics)LoadSasukeCinematic(cinematic,manifest.cinematics[cinematic]);
         for each(var effect:String in ["ZuozhuZZZZ_haolonghuo", "ZuozhuZZZZ_haolonghuoyan", "ZuozhuZZZZ_qianniaodao3", "ZuozhuZZZZ_qilin", "ZuozhuZZZZ_qilin_texie", "ZuozhuZZZZ_qilin_yan", "ZuozhuZZZZ_qilin_yantexie", "ZuozhuZZZZ_xuzuobati"])
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
                     LoadSasukeVfxAtlas(page,manifest.atlases[page]);
                  }
                  head++;
               }
            }
         }
      }
      public static function SasukePinPages(previous:Array, current:Array) : void
      {
         var pins:Object = FSasukeFxLoading["_pins"];
         if(pins == null)
         {
            pins = {};
            FSasukeFxLoading["_pins"] = pins;
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
         var queue:Array = FSasukeFxLoading["_queue"] as Array;
         if(queue != null)
         {
            var i:int = queue.length - 1;
            while(i >= 0)
            {
               var queued:String = String(queue[i].name);
               if(int(pins[queued]) == 0 && !SasukeFirstAtlas(queued))
               {
                  queue.splice(i,1);
                  delete FSasukeFxLoading[queued];
               }
               i--;
            }
         }
      }
      public static function PumpSasukeVfxQueue() : void
      {
         var job:Object;
         var name:String;
         var meta:Object;
         var loader:URLLoader;
         var complete:Function;
         var failed:Function;
         var release:Function;
         var queue:Array = FSasukeFxLoading["_queue"] as Array;
         if(queue == null || queue.length == 0 || int(FSasukeFxLoading["_inflight"]) >= 2)
         {
            return;
         }
         queue.sortOn("deadline",Array.NUMERIC);
         job = queue.shift();
         name = String(job.name);
         meta = job.meta;
         FSasukeFxLoading["_inflight"] = int(FSasukeFxLoading["_inflight"]) + 1;
         loader = new URLLoader();
         loader.dataFormat = URLLoaderDataFormat.BINARY;
         release = function():void
         {
            loader.removeEventListener(Event.COMPLETE,complete);
            loader.removeEventListener(IOErrorEvent.IO_ERROR,failed);
            loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,failed);
            delete FSasukeFxLoading[name];
            FSasukeFxLoading["_inflight"] = Math.max(0,int(FSasukeFxLoading["_inflight"]) - 1);
            loader.data = null;
            PumpSasukeVfxQueue();
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
                  FSasukeFxCache[name] = frames;
                  TrimSasukeVfxCache(name);
               }
            }
            catch(error:Error)
            {
               if(data != null)
               {
                  data.clear();
               }
               if(source != null && FSasukeFxCache[name] == null)
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
         PumpSasukeVfxQueue();
      }
      public static function LoadSasukeVfxAtlas(name:String, meta:Object, urgent:Boolean = false, lead:int = 0) : void
      {
         if(meta == null)
         {
            return;
         }
         FSasukeFxLoading["_age_" + name] = getTimer();
         if(FSasukeFxCache[name] != null)
         {
            return;
         }
         var queue:Array = FSasukeFxLoading["_queue"] as Array;
         if(queue == null)
         {
            queue = [];
            FSasukeFxLoading["_queue"] = queue;
         }
         if(FSasukeFxLoading[name])
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
         FSasukeFxLoading[name] = true;
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
         PumpSasukeVfxQueue();
      }
      public static function TrimSasukeVfxCache(keep:String) : void
      {
         var pixels:Number = 0;
         var pins:Object = FSasukeFxLoading["_pins"];
         for(var key:String in FSasukeFxCache)
         {
            var frames:Array = FSasukeFxCache[key] as Array;
            if(frames != null && frames.length > 0)
            {
               pixels += BitmapData(frames[0]).width * BitmapData(frames[0]).height;
            }
         }
         while(pixels > 32000000)
         {
            var oldest:String = null;
            var age:Number = Number.MAX_VALUE;
            for(key in FSasukeFxCache)
            {
               if(key != keep && !SasukeFirstAtlas(key) && (pins == null || int(pins[key]) == 0) && Number(FSasukeFxLoading["_age_" + key]) < age)
               {
                  oldest = key;
                  age = Number(FSasukeFxLoading["_age_" + key]);
               }
            }
            if(oldest == null)
            {
               break;
            }
            frames = FSasukeFxCache[oldest] as Array;
            var atlas:BitmapData = BitmapData(frames[0]);
            pixels -= atlas.width * atlas.height;
            delete FSasukeFxCache[oldest];
            delete FSasukeFxLoading["_age_" + oldest];
            atlas.dispose();
         }
      }
      public static function SasukeFirstAtlas(key:String) : Boolean
      {
         return SasukeVfxManifest().firstAtlases[key] === true;
      }
      public function PlaySasukeVfxAsset(name:String, host:DisplayObjectContainer, point:Point, width:Number, height:Number, delay:int = 0, mirrored:Boolean = false, follow:Boolean = false, behind:Boolean = false, angle:Number = 0) : void
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
         var manifest:Object = SasukeVfxManifest();
         var clip:Object = manifest.clips[name];
         if(clip == null || host == null || host.stage == null)
         {
            return;
         }
         pinned = clip.aheadPages[0];
         SasukePinPages([],pinned);
         pre = 0;
         while(pre < pinned.length)
         {
            preload = String(pinned[pre]);
            LoadSasukeVfxAtlas(preload,manifest.atlases[preload],pre == 0,pre * 2);
            pre++;
         }
         caster = this;
         layer = new Sprite();
         layer.name = "sasukeSkillVfx";if(ExternalInterface.available)ExternalInterface.call("vfxProbe","VFX_ASSET "+name);
         FSasukeActiveVfx.push(layer);
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
            SasukePinPages(pinned,[]);
            pinned = [];
            layer.removeEventListener(Event.ENTER_FRAME,animate);
            layer.removeEventListener(Event.REMOVED_FROM_STAGE,cleanup);
            image.bitmapData = null;
            if(buffer != null)
            {
               buffer.dispose();
               buffer = null;
            }
            TrimSasukeVfxCache("");
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
            if(frame == lastFrame)return;
            var frameAtlas:String = clip.frameAtlases != null ? String(clip.frameAtlases[frame]) : String(clip.atlas);
            var wanted:Array = clip.aheadPages[frame];
            if(pinned != wanted)
            {
               SasukePinPages(pinned,wanted);
               pinned = wanted;
            }
            var ahead:int = 0;
            while(ahead < wanted.length)
            {
               var page:String = String(wanted[ahead]);
               LoadSasukeVfxAtlas(page,manifest.atlases[page],ahead == 0,ahead * 2);
               ahead++;
            }
            var frames:Array = FSasukeFxCache[frameAtlas] as Array;
            if(frames == null)
            {
               if(ExternalInterface.available)ExternalInterface.call("vfxProbe","MISSING_FRAME "+name+" frame="+frame);
               layer.visible = buffer != null;
               return;
            }
            layer.visible = true;
            if(frame != lastFrame)
            {
               var atlas:BitmapData = BitmapData(frames[0]);
               var meta:Object = manifest.atlases[frameAtlas];
               var rect:Array = clip.frameRects[frame];
               if(buffer == null)
               {
                  buffer = new BitmapData(int(clip.bufferWidth),int(clip.bufferHeight),true,0);
                  image.bitmapData = buffer;
               }
               // Clear the reusable trimmed surface atomically so smaller
               // frames cannot retain pixels from preceding larger frames.
               buffer.lock();buffer.fillRect(buffer.rect,0);
               copyRect.x = int(rect[0]);copyRect.y = int(rect[1]);
               copyRect.width = int(rect[2]);copyRect.height = int(rect[3]);
               buffer.copyPixels(atlas,copyRect,copyOrigin);
               buffer.unlock();
               image.scaleX = width / Number(clip.width);
               image.scaleY = height / Number(clip.height);
               image.x = (Number(rect[4])-Number(clip.pivot[0])*Number(clip.width))*image.scaleX;
               image.y = (Number(rect[5])-Number(clip.pivot[1])*Number(clip.height))*image.scaleY;
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
      public function FitSasukePose() : void
      {
         if(FId != 11120970 || stage == null || FBitmap.bitmapData == null)
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
      public function SasukeBackdrop(host:DisplayObjectContainer) : void
      {
         var tl:Point;
         var br:Point;
         var caster:ProbeRole;
         var serial:uint;
         var skill:uint;
         var cleanup:Function;
         var dim:Sprite = new Sprite();
         dim.name = "sasukeSkillVfx";
         dim.mouseEnabled = false;
         tl = host.globalToLocal(stage.localToGlobal(new Point()));
         br = host.globalToLocal(stage.localToGlobal(new Point(stage.stageWidth,stage.stageHeight)));
         dim.graphics.beginFill(329241,0.55);
         dim.graphics.drawRect(tl.x,tl.y,br.x - tl.x,br.y - tl.y);
         dim.graphics.endFill();
         host.addChildAt(dim,0);
         FSasukeActiveVfx.push(dim);
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
      public static function SasukeVfxManifest():Object {
         if(FSasukeFxLoading["_manifest"]!=null)return FSasukeFxLoading["_manifest"];
         var manifest:Object=JSON.parse("{\"version\":7,\"frameMs\":40,\"frameRate\":25,\"atlases\":{\"ZuozhuZZZZ_haolonghuo-31-trim-0\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_haolonghuo-31-trim-0.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_haolonghuo-31-trim-1\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_haolonghuo-31-trim-1.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_haolonghuo-31-trim-2\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_haolonghuo-31-trim-2.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_haolonghuo-31-trim-3\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_haolonghuo-31-trim-3.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_haolonghuo-31-trim-4\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_haolonghuo-31-trim-4.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_haolonghuo-31-trim-5\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_haolonghuo-31-trim-5.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_haolonghuo-664-trim-0\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_haolonghuo-664-trim-0.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_haolonghuo-664-trim-1\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_haolonghuo-664-trim-1.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_haolonghuo-664-trim-2\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_haolonghuo-664-trim-2.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_haolonghuoyan-31-trim-0.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_haolonghuoyan-31-trim-1\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_haolonghuoyan-31-trim-1.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_haolonghuoyan-31-trim-2\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_haolonghuoyan-31-trim-2.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_haolonghuoyan-31-trim-3\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_haolonghuoyan-31-trim-3.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_haolonghuoyan-31-trim-4\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_haolonghuoyan-31-trim-4.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_haolonghuoyan-31-trim-5\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_haolonghuoyan-31-trim-5.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_haolonghuoyan-891-trim-0.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_haolonghuoyan-891-trim-1.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_haolonghuoyan-891-trim-2.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao1-258-trim-0\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao1-258-trim-0.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao1-258-trim-1\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao1-258-trim-1.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao1-69-trim-0\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao1-69-trim-0.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao2-285-trim-0\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao2-285-trim-0.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao2-285-trim-1\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao2-285-trim-1.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao2-90-trim-0\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao2-90-trim-0.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao3-112-trim-0\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao3-112-trim-0.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao3-684-trim-0\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao3-684-trim-0.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao3-684-trim-1\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao3-684-trim-1.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao3-684-trim-2\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao3-684-trim-2.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao3-684-trim-3\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao3-684-trim-3.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao3-684-trim-4\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao3-684-trim-4.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao3-684-trim-5\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao3-684-trim-5.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao3-684-trim-6\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao3-684-trim-6.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao3-684-trim-7\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao3-684-trim-7.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao3-684-trim-8\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao3-684-trim-8.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao3-684-trim-9\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao3-684-trim-9.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao3-684-trim-10\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao3-684-trim-10.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao3-684-trim-11\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao3-684-trim-11.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_xuzuobati-106-trim-0\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_xuzuobati-106-trim-0.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_xuzuobati-107-trim-0\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_xuzuobati-107-trim-0.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_xuzuobati-108-trim-0\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_xuzuobati-108-trim-0.png\",\"columns\":1,\"rows\":1,\"frameCount\":0}},\"clips\":{\"ZuozhuZZZZ_haolonghuo-31\":{\"atlas\":\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"frameAtlases\":[\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-1\",\"ZuozhuZZZZ_haolonghuo-31-trim-1\",\"ZuozhuZZZZ_haolonghuo-31-trim-1\",\"ZuozhuZZZZ_haolonghuo-31-trim-1\",\"ZuozhuZZZZ_haolonghuo-31-trim-1\",\"ZuozhuZZZZ_haolonghuo-31-trim-1\",\"ZuozhuZZZZ_haolonghuo-31-trim-2\",\"ZuozhuZZZZ_haolonghuo-31-trim-2\",\"ZuozhuZZZZ_haolonghuo-31-trim-2\",\"ZuozhuZZZZ_haolonghuo-31-trim-2\",\"ZuozhuZZZZ_haolonghuo-31-trim-2\",\"ZuozhuZZZZ_haolonghuo-31-trim-2\",\"ZuozhuZZZZ_haolonghuo-31-trim-2\",\"ZuozhuZZZZ_haolonghuo-31-trim-3\",\"ZuozhuZZZZ_haolonghuo-31-trim-3\",\"ZuozhuZZZZ_haolonghuo-31-trim-3\",\"ZuozhuZZZZ_haolonghuo-31-trim-3\",\"ZuozhuZZZZ_haolonghuo-31-trim-3\",\"ZuozhuZZZZ_haolonghuo-31-trim-3\",\"ZuozhuZZZZ_haolonghuo-31-trim-4\",\"ZuozhuZZZZ_haolonghuo-31-trim-4\",\"ZuozhuZZZZ_haolonghuo-31-trim-4\",\"ZuozhuZZZZ_haolonghuo-31-trim-4\",\"ZuozhuZZZZ_haolonghuo-31-trim-4\",\"ZuozhuZZZZ_haolonghuo-31-trim-4\",\"ZuozhuZZZZ_haolonghuo-31-trim-5\",\"ZuozhuZZZZ_haolonghuo-31-trim-5\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,0,0,0,0,0,0,0,0],\"width\":1193,\"height\":332,\"pivot\":[0.13896689019279126,0.5171536144578314],\"renderScale\":0.65,\"sourceFrames\":82,\"sourceCrop\":[83,30,1276,362],\"sourceZoom\":0.65,\"frameRects\":[[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[1,0,659,187,264,79],[660,0,940,261,119,39],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,593,1193,332,0,0],[0,925,1193,332,0,0],[0,1257,1193,332,0,0],[0,1589,1193,332,0,0],[0,0,1193,332,0,0],[0,332,1193,332,0,0],[0,664,1193,332,0,0],[0,996,1193,332,0,0],[0,1328,1193,332,0,0],[0,1660,1193,332,0,0],[0,0,1193,332,0,0],[0,332,1193,332,0,0],[0,664,1193,332,0,0],[0,996,1193,332,0,0],[0,1328,1193,332,0,0],[0,1660,1193,332,0,0],[0,1660,1193,332,0,0],[0,0,1193,332,0,0],[0,332,1193,332,0,0],[0,664,1193,332,0,0],[0,996,1193,332,0,0],[0,1328,1193,332,0,0],[0,1660,1193,332,0,0],[0,0,1193,332,0,0],[0,332,1193,332,0,0],[0,664,1184,331,1,1],[0,995,1184,331,1,1],[0,1326,1182,328,3,2],[0,1654,1176,328,3,2],[0,0,1143,320,34,6],[0,320,1119,315,50,9],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0]],\"bufferWidth\":1193,\"bufferHeight\":332},\"ZuozhuZZZZ_haolonghuo-664\":{\"atlas\":\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"frameAtlases\":[\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-2\",\"ZuozhuZZZZ_haolonghuo-664-trim-2\",\"ZuozhuZZZZ_haolonghuo-664-trim-2\",\"ZuozhuZZZZ_haolonghuo-664-trim-2\",\"ZuozhuZZZZ_haolonghuo-664-trim-2\",\"ZuozhuZZZZ_haolonghuo-664-trim-2\",\"ZuozhuZZZZ_haolonghuo-664-trim-2\",\"ZuozhuZZZZ_haolonghuo-664-trim-2\",\"ZuozhuZZZZ_haolonghuo-664-trim-2\",\"ZuozhuZZZZ_haolonghuo-664-trim-2\",\"ZuozhuZZZZ_haolonghuo-664-trim-2\",\"ZuozhuZZZZ_haolonghuo-664-trim-2\",\"ZuozhuZZZZ_haolonghuo-664-trim-2\",\"ZuozhuZZZZ_haolonghuo-664-trim-2\",\"ZuozhuZZZZ_haolonghuo-664-trim-2\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,1,2,3,4,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,52,53,54,55,56,57,58,59,60,61,62,63,64,0,0,0,0,0,0,0,0,0,0],\"width\":999,\"height\":940,\"pivot\":[0.3489232435033686,0.5132544757033248],\"renderScale\":0.31248796920115496,\"sourceFrames\":82,\"sourceCrop\":[436,287,2514,2242],\"sourceZoom\":0.65,\"frameRects\":[[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[1,0,22,17,365,437],[23,0,40,37,364,434],[63,0,127,59,291,428],[190,0,166,68,268,423],[190,0,166,68,268,423],[356,0,185,75,260,416],[541,0,196,87,258,406],[737,0,203,95,258,399],[940,0,225,99,257,396],[1165,0,247,101,257,393],[1412,0,268,104,257,391],[1680,0,292,106,254,394],[0,106,314,102,252,398],[314,106,337,103,250,397],[651,106,516,341,248,278],[1167,106,488,300,246,302],[0,447,537,459,245,230],[537,447,677,628,185,149],[0,1075,851,789,86,72],[851,1075,999,940,0,0],[0,0,462,241,243,324],[462,0,463,242,243,324],[925,0,463,246,244,322],[1388,0,466,248,243,321],[0,248,468,252,243,319],[468,248,470,256,243,317],[938,248,471,259,243,316],[1409,248,349,262,368,314],[0,510,352,280,369,298],[0,510,352,280,369,298],[352,510,339,298,381,282],[691,510,351,312,371,269],[1042,510,361,321,363,262],[1403,510,365,327,360,258],[0,837,318,295,409,292],[318,837,317,309,412,279],[635,837,326,315,405,275],[961,837,333,318,400,273],[1294,837,308,322,426,271],[1602,837,311,326,425,269],[0,1163,315,333,422,263],[315,1163,319,336,420,262],[634,1163,323,338,418,262],[957,1163,328,338,415,263],[1285,1163,329,341,415,262],[1614,1163,332,343,413,261],[0,1506,336,346,411,260],[336,1506,339,347,410,260],[675,1506,340,344,410,265],[1015,1506,339,352,412,258],[1354,1506,340,357,412,254],[1694,1506,343,362,411,251],[0,0,344,366,411,247],[344,0,344,370,411,244],[344,0,344,370,411,244],[688,0,342,372,412,241],[1030,0,338,373,414,237],[1368,0,314,361,426,238],[1682,0,176,243,480,260],[1858,0,183,244,473,259],[0,373,186,245,470,258],[186,373,164,246,491,257],[350,373,167,244,487,259],[517,373,151,52,492,451],[668,373,150,52,492,451],[818,373,148,50,493,452],[966,373,69,40,518,451],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0]],\"bufferWidth\":999,\"bufferHeight\":940},\"ZuozhuZZZZ_haolonghuoyan-31\":{\"atlas\":\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"frameAtlases\":[\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-3\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-3\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-3\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-3\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-3\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-3\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-4\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-4\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-4\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-4\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-4\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-4\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-5\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-5\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,0,0,0,0,0,0,0,0],\"width\":1193,\"height\":332,\"pivot\":[0.13896689019279126,0.5171536144578314],\"renderScale\":0.65,\"sourceFrames\":82,\"sourceCrop\":[83,30,1276,362],\"sourceZoom\":0.65,\"frameRects\":[[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[1,0,659,187,264,79],[660,0,940,261,119,39],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,593,1193,332,0,0],[0,925,1193,332,0,0],[0,1257,1193,332,0,0],[0,1589,1193,332,0,0],[0,0,1193,332,0,0],[0,332,1193,332,0,0],[0,664,1193,332,0,0],[0,996,1193,332,0,0],[0,1328,1193,332,0,0],[0,1660,1193,332,0,0],[0,0,1193,332,0,0],[0,332,1193,332,0,0],[0,664,1193,332,0,0],[0,996,1193,332,0,0],[0,1328,1193,332,0,0],[0,1660,1193,332,0,0],[0,1660,1193,332,0,0],[0,0,1193,332,0,0],[0,332,1193,332,0,0],[0,664,1193,332,0,0],[0,996,1193,332,0,0],[0,1328,1193,332,0,0],[0,1660,1193,332,0,0],[0,0,1193,332,0,0],[0,332,1193,332,0,0],[0,664,1184,331,1,1],[0,995,1184,331,1,1],[0,1326,1182,328,3,2],[0,1654,1176,328,3,2],[0,0,1143,320,34,6],[0,320,1119,315,50,9],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0]],\"bufferWidth\":1193,\"bufferHeight\":332},\"ZuozhuZZZZ_haolonghuoyan-891\":{\"atlas\":\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"frameAtlases\":[\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,1,2,3,4,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,71,0,0],\"width\":999,\"height\":940,\"pivot\":[0.3489232435033686,0.5132544757033248],\"renderScale\":0.31248796920115496,\"sourceFrames\":82,\"sourceCrop\":[436,287,2514,2242],\"sourceZoom\":0.65,\"frameRects\":[[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[1,0,28,19,359,435],[29,0,53,40,351,431],[82,0,127,65,291,422],[209,0,166,78,268,413],[209,0,166,78,268,413],[375,0,185,85,260,406],[560,0,196,94,258,399],[756,0,211,102,258,392],[967,0,277,99,257,396],[1244,0,278,104,257,393],[1522,0,279,112,257,391],[0,112,303,115,254,394],[303,112,330,113,252,398],[633,112,360,140,250,397],[993,112,516,341,248,278],[1509,112,488,300,246,302],[0,453,537,459,245,230],[537,453,677,628,185,149],[0,1081,851,789,86,72],[851,1081,999,940,0,0],[0,0,475,241,243,324],[475,0,475,242,243,324],[950,0,475,246,244,322],[1425,0,476,248,243,321],[0,248,476,252,243,319],[476,248,476,256,243,317],[952,248,476,259,243,316],[1428,248,351,262,368,314],[0,510,353,280,369,298],[0,510,353,280,369,298],[353,510,341,298,381,282],[694,510,351,312,371,269],[1045,510,361,321,363,262],[1406,510,365,327,360,258],[0,837,318,295,409,292],[318,837,317,309,412,279],[635,837,326,315,405,275],[961,837,333,318,400,273],[1294,837,308,322,426,271],[1602,837,311,326,425,269],[0,1163,315,333,422,263],[315,1163,319,336,420,262],[634,1163,323,338,418,262],[957,1163,328,338,415,263],[1285,1163,329,341,415,262],[1614,1163,332,343,413,261],[0,1506,336,346,411,260],[336,1506,339,347,410,260],[675,1506,340,344,410,265],[1015,1506,339,352,412,258],[1354,1506,340,357,412,254],[1694,1506,343,362,411,251],[0,0,344,366,411,247],[344,0,344,370,411,244],[344,0,344,370,411,244],[688,0,342,372,412,241],[1030,0,338,373,414,237],[1368,0,314,361,426,238],[1682,0,267,253,455,260],[0,373,271,251,451,259],[271,373,270,249,451,258],[541,373,267,250,454,257],[808,373,265,248,454,259],[1073,373,265,108,454,399],[1338,373,264,102,454,401],[1602,373,264,102,454,401],[0,624,261,103,454,398],[261,624,262,103,453,398],[523,624,262,96,453,404],[785,624,260,96,455,404],[1045,624,154,91,455,408],[1199,624,152,86,457,413],[1351,624,27,25,457,413],[1378,624,22,23,457,415],[1378,624,22,23,457,415],[0,0,1,1,0,0],[0,0,1,1,0,0]],\"bufferWidth\":999,\"bufferHeight\":940},\"ZuozhuZZZZ_qianniaodao1-258\":{\"atlas\":\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"frameAtlases\":[\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-1\",\"ZuozhuZZZZ_qianniaodao1-258-trim-1\",\"ZuozhuZZZZ_qianniaodao1-258-trim-1\",\"ZuozhuZZZZ_qianniaodao1-258-trim-1\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\"],\"timeline\":[0,0,0,0,1,2,3,4,5,6,7,8,9,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,0,0,0,0,0,0,0,0,0,0,0,0,0,0],\"width\":469,\"height\":445,\"pivot\":[0.2868710021321962,0.676438202247191],\"renderScale\":0.85,\"sourceFrames\":45,\"sourceCrop\":[248,95,717,540],\"sourceZoom\":0.85,\"frameRects\":[[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[1,0,269,271,85,91],[270,0,316,318,76,70],[586,0,363,366,67,49],[949,0,411,414,58,27],[1360,0,411,414,58,27],[0,414,411,414,58,27],[411,414,411,414,58,0],[822,414,409,411,59,2],[1231,414,407,410,60,3],[1231,414,407,410,60,3],[1638,414,407,410,60,3],[0,828,465,407,0,4],[465,828,391,395,68,10],[856,828,277,204,115,114],[1133,828,313,207,97,112],[1446,828,313,208,97,111],[0,1235,313,208,97,111],[313,1235,313,220,78,95],[626,1235,312,314,78,78],[938,1235,335,334,79,70],[1273,1235,383,353,56,63],[0,1588,433,390,32,55],[433,1588,433,390,32,55],[866,1588,433,390,5,51],[1299,1588,431,387,6,52],[0,0,429,386,7,53],[429,0,422,379,11,56],[851,0,270,325,84,96],[1121,0,50,88,230,137],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0]],\"bufferWidth\":465,\"bufferHeight\":414},\"ZuozhuZZZZ_qianniaodao1-69\":{\"atlas\":\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"frameAtlases\":[\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,2,2,3,4,5,6,7,8,9,9,10,10,11,11,11,12,13,14,14,15,16,17,17,17,18,0,0,0,0,0,0,0],\"width\":288,\"height\":139,\"pivot\":[0.4671614583333334,1.197068345323741],\"renderScale\":0.85,\"sourceFrames\":45,\"sourceCrop\":[248,217,536,356],\"sourceZoom\":0.85,\"frameRects\":[[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[1,0,24,13,80,74],[1,0,24,13,80,74],[1,0,24,13,80,74],[25,0,31,30,194,73],[25,0,31,30,194,73],[56,0,163,79,125,44],[219,0,183,76,104,41],[402,0,183,58,90,40],[585,0,149,50,77,41],[734,0,271,114,0,24],[1005,0,65,48,95,90],[1070,0,60,43,95,90],[1070,0,60,43,95,90],[1130,0,35,65,100,74],[1130,0,35,65,100,74],[1165,0,54,16,93,69],[1165,0,54,16,93,69],[1165,0,54,16,93,69],[1219,0,53,14,88,73],[1272,0,49,41,66,69],[1321,0,40,56,60,64],[1321,0,40,56,60,64],[1361,0,41,21,127,58],[1402,0,11,81,156,5],[1413,0,63,49,148,0],[1413,0,63,49,148,0],[1413,0,63,49,148,0],[1476,0,49,63,155,2],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0]],\"bufferWidth\":271,\"bufferHeight\":114},\"ZuozhuZZZZ_qianniaodao2-285\":{\"atlas\":\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"frameAtlases\":[\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\"],\"timeline\":[0,0,1,2,3,4,5,6,7,8,9,10,11,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,35,36,37,38,39,40,41,42,43,0,0,0,0,0,0,0,0,0],\"width\":470,\"height\":485,\"pivot\":[0.2881914893617021,0.7027422680412371],\"renderScale\":0.85,\"sourceFrames\":53,\"sourceCrop\":[83,67,553,552],\"sourceZoom\":0.85,\"frameRects\":[[0,0,1,1,0,0],[0,0,1,1,0,0],[1,0,269,271,86,131],[270,0,316,318,77,110],[586,0,363,366,68,89],[949,0,411,414,58,67],[1360,0,411,414,58,67],[0,414,411,414,58,67],[411,414,411,414,59,40],[822,414,409,411,60,41],[1231,414,407,410,61,42],[1638,414,407,410,61,42],[0,828,403,407,63,43],[0,828,403,407,63,43],[403,828,391,395,69,49],[794,828,359,168,0,187],[1153,828,307,201,70,156],[1460,828,277,204,116,154],[0,1235,313,207,98,152],[313,1235,313,208,98,151],[626,1235,313,223,98,135],[939,1235,313,315,79,117],[1252,1235,336,334,79,110],[1588,1235,383,353,57,103],[0,1588,433,390,33,95],[433,1588,433,390,33,95],[866,1588,433,390,6,91],[1299,1588,430,387,7,92],[0,0,429,386,7,93],[429,0,422,379,11,96],[851,0,270,325,85,136],[1121,0,50,87,231,177],[1171,0,149,347,129,83],[1320,0,242,392,113,42],[1562,0,275,417,91,27],[0,417,314,442,64,17],[314,417,355,464,34,11],[669,417,355,462,58,0],[669,417,355,462,58,0],[1024,417,355,460,58,0],[1379,417,355,460,58,0],[0,881,353,458,59,1],[353,881,353,458,59,1],[706,881,351,456,60,2],[1057,881,350,454,60,3],[1407,881,344,447,63,7],[0,1339,331,429,70,16],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0]],\"bufferWidth\":433,\"bufferHeight\":464},\"ZuozhuZZZZ_qianniaodao2-90\":{\"atlas\":\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"frameAtlases\":[\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,0,1,1,1,1,2,3,3,4,5,6,7,8,8,9,9,9,10,11,12,12,12,13,14,14,15,16,16,17,17,17,18,18,19,20,20,21,22,22,23,0,0,0,0,0,0,0],\"width\":289,\"height\":193,\"pivot\":[0.46658304498269887,1.1315673575129532],\"renderScale\":0.85,\"sourceFrames\":53,\"sourceCrop\":[331,165,620,358],\"sourceZoom\":0.85,\"frameRects\":[[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[1,0,24,13,80,126],[1,0,24,13,80,126],[1,0,24,13,80,126],[1,0,24,13,80,126],[25,0,10,19,111,134],[35,0,32,25,194,127],[35,0,32,25,194,127],[67,0,164,79,125,96],[231,0,183,76,104,93],[414,0,184,47,90,92],[598,0,271,92,0,75],[869,0,65,47,95,143],[869,0,65,47,95,143],[934,0,35,66,99,127],[934,0,35,66,99,127],[934,0,35,66,99,127],[969,0,62,10,117,116],[1031,0,69,20,113,115],[1100,0,18,8,106,143],[1100,0,18,8,106,143],[1100,0,18,8,106,143],[1118,0,60,15,107,135],[1178,0,73,26,98,9],[1178,0,73,26,98,9],[1251,0,50,55,70,0],[1301,0,70,22,20,67],[1301,0,70,22,20,67],[1371,0,63,27,23,87],[1371,0,63,27,23,87],[1371,0,63,27,23,87],[1434,0,60,32,20,89],[1434,0,60,32,20,89],[1494,0,61,29,13,92],[1555,0,27,26,12,153],[1555,0,27,26,12,153],[1582,0,67,22,46,89],[1649,0,66,52,59,53],[1649,0,66,52,59,53],[1715,0,23,69,83,65],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0]],\"bufferWidth\":271,\"bufferHeight\":92},\"ZuozhuZZZZ_qianniaodao3-112\":{\"atlas\":\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"frameAtlases\":[\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,1,2,2,2,3,4,5,6,7,8,9,10,10,11,12,13,13,14,15,15,16,17,17,18,18,19,20,20,21,21,22,22,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,23,23,24,0,0,0,0,0,0,0,0,0,0,0,0],\"width\":776,\"height\":396,\"pivot\":[0.3469072164948453,1.1593434343434343],\"renderScale\":1.7,\"sourceFrames\":81,\"sourceCrop\":[659,328,1435,724],\"sourceZoom\":1.7,\"frameRects\":[[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[1,0,27,37,196,264],[28,0,68,59,383,274],[28,0,68,59,383,274],[28,0,68,59,383,274],[96,0,327,160,250,213],[423,0,366,152,208,208],[789,0,369,104,179,207],[1158,0,299,103,154,208],[1457,0,90,80,302,252],[0,160,542,183,0,173],[542,160,404,220,143,176],[946,160,121,88,189,308],[946,160,121,88,189,308],[1067,160,136,31,230,250],[1203,160,133,41,218,262],[1336,160,65,25,196,303],[1336,160,65,25,196,303],[1401,160,144,71,283,82],[1545,160,136,85,169,0],[1545,160,136,85,169,0],[1681,160,114,114,130,15],[1795,160,132,68,35,126],[1795,160,132,68,35,126],[1927,160,60,17,55,243],[1927,160,60,17,55,243],[0,380,136,49,24,257],[136,380,149,65,468,97],[136,380,149,65,468,97],[285,380,151,71,602,31],[285,380,151,71,602,31],[436,380,151,73,625,21],[436,380,151,73,625,21],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[587,380,140,80,279,128],[587,380,140,80,279,128],[727,380,15,119,336,174],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0]],\"bufferWidth\":542,\"bufferHeight\":220},\"ZuozhuZZZZ_qianniaodao3-684\":{\"atlas\":\"ZuozhuZZZZ_qianniaodao3-684-trim-0\",\"frameAtlases\":[\"ZuozhuZZZZ_qianniaodao3-684-trim-0\",\"ZuozhuZZZZ_qianniaodao3-684-trim-0\",\"ZuozhuZZZZ_qianniaodao3-684-trim-0\",\"ZuozhuZZZZ_qianniaodao3-684-trim-0\",\"ZuozhuZZZZ_qianniaodao3-684-trim-0\",\"ZuozhuZZZZ_qianniaodao3-684-trim-0\",\"ZuozhuZZZZ_qianniaodao3-684-trim-0\",\"ZuozhuZZZZ_qianniaodao3-684-trim-0\",\"ZuozhuZZZZ_qianniaodao3-684-trim-0\",\"ZuozhuZZZZ_qianniaodao3-684-trim-0\",\"ZuozhuZZZZ_qianniaodao3-684-trim-0\",\"ZuozhuZZZZ_qianniaodao3-684-trim-0\",\"ZuozhuZZZZ_qianniaodao3-684-trim-0\",\"ZuozhuZZZZ_qianniaodao3-684-trim-0\",\"ZuozhuZZZZ_qianniaodao3-684-trim-0\",\"ZuozhuZZZZ_qianniaodao3-684-trim-1\",\"ZuozhuZZZZ_qianniaodao3-684-trim-1\",\"ZuozhuZZZZ_qianniaodao3-684-trim-1\",\"ZuozhuZZZZ_qianniaodao3-684-trim-1\",\"ZuozhuZZZZ_qianniaodao3-684-trim-1\",\"ZuozhuZZZZ_qianniaodao3-684-trim-1\",\"ZuozhuZZZZ_qianniaodao3-684-trim-1\",\"ZuozhuZZZZ_qianniaodao3-684-trim-1\",\"ZuozhuZZZZ_qianniaodao3-684-trim-1\",\"ZuozhuZZZZ_qianniaodao3-684-trim-1\",\"ZuozhuZZZZ_qianniaodao3-684-trim-1\",\"ZuozhuZZZZ_qianniaodao3-684-trim-2\",\"ZuozhuZZZZ_qianniaodao3-684-trim-2\",\"ZuozhuZZZZ_qianniaodao3-684-trim-2\",\"ZuozhuZZZZ_qianniaodao3-684-trim-2\",\"ZuozhuZZZZ_qianniaodao3-684-trim-2\",\"ZuozhuZZZZ_qianniaodao3-684-trim-2\",\"ZuozhuZZZZ_qianniaodao3-684-trim-2\",\"ZuozhuZZZZ_qianniaodao3-684-trim-2\",\"ZuozhuZZZZ_qianniaodao3-684-trim-2\",\"ZuozhuZZZZ_qianniaodao3-684-trim-2\",\"ZuozhuZZZZ_qianniaodao3-684-trim-3\",\"ZuozhuZZZZ_qianniaodao3-684-trim-3\",\"ZuozhuZZZZ_qianniaodao3-684-trim-3\",\"ZuozhuZZZZ_qianniaodao3-684-trim-3\",\"ZuozhuZZZZ_qianniaodao3-684-trim-3\",\"ZuozhuZZZZ_qianniaodao3-684-trim-3\",\"ZuozhuZZZZ_qianniaodao3-684-trim-3\",\"ZuozhuZZZZ_qianniaodao3-684-trim-4\",\"ZuozhuZZZZ_qianniaodao3-684-trim-4\",\"ZuozhuZZZZ_qianniaodao3-684-trim-4\",\"ZuozhuZZZZ_qianniaodao3-684-trim-4\",\"ZuozhuZZZZ_qianniaodao3-684-trim-4\",\"ZuozhuZZZZ_qianniaodao3-684-trim-4\",\"ZuozhuZZZZ_qianniaodao3-684-trim-5\",\"ZuozhuZZZZ_qianniaodao3-684-trim-5\",\"ZuozhuZZZZ_qianniaodao3-684-trim-5\",\"ZuozhuZZZZ_qianniaodao3-684-trim-5\",\"ZuozhuZZZZ_qianniaodao3-684-trim-5\",\"ZuozhuZZZZ_qianniaodao3-684-trim-5\",\"ZuozhuZZZZ_qianniaodao3-684-trim-6\",\"ZuozhuZZZZ_qianniaodao3-684-trim-6\",\"ZuozhuZZZZ_qianniaodao3-684-trim-7\",\"ZuozhuZZZZ_qianniaodao3-684-trim-7\",\"ZuozhuZZZZ_qianniaodao3-684-trim-8\",\"ZuozhuZZZZ_qianniaodao3-684-trim-8\",\"ZuozhuZZZZ_qianniaodao3-684-trim-8\",\"ZuozhuZZZZ_qianniaodao3-684-trim-8\",\"ZuozhuZZZZ_qianniaodao3-684-trim-8\",\"ZuozhuZZZZ_qianniaodao3-684-trim-9\",\"ZuozhuZZZZ_qianniaodao3-684-trim-9\",\"ZuozhuZZZZ_qianniaodao3-684-trim-9\",\"ZuozhuZZZZ_qianniaodao3-684-trim-9\",\"ZuozhuZZZZ_qianniaodao3-684-trim-10\",\"ZuozhuZZZZ_qianniaodao3-684-trim-10\",\"ZuozhuZZZZ_qianniaodao3-684-trim-10\",\"ZuozhuZZZZ_qianniaodao3-684-trim-10\",\"ZuozhuZZZZ_qianniaodao3-684-trim-10\",\"ZuozhuZZZZ_qianniaodao3-684-trim-10\",\"ZuozhuZZZZ_qianniaodao3-684-trim-10\",\"ZuozhuZZZZ_qianniaodao3-684-trim-10\",\"ZuozhuZZZZ_qianniaodao3-684-trim-10\",\"ZuozhuZZZZ_qianniaodao3-684-trim-11\",\"ZuozhuZZZZ_qianniaodao3-684-trim-11\",\"ZuozhuZZZZ_qianniaodao3-684-trim-11\",\"ZuozhuZZZZ_qianniaodao3-684-trim-11\",\"ZuozhuZZZZ_qianniaodao3-684-trim-11\",\"ZuozhuZZZZ_qianniaodao3-684-trim-0\",\"ZuozhuZZZZ_qianniaodao3-684-trim-0\",\"ZuozhuZZZZ_qianniaodao3-684-trim-0\"],\"timeline\":[0,0,0,0,1,2,3,4,5,6,7,8,9,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,0,0,0],\"width\":1150,\"height\":806,\"pivot\":[0.3828328173374613,0.6200353356890458],\"renderScale\":1.2105263157894737,\"sourceFrames\":81,\"sourceCrop\":[267,482,1882,1614],\"sourceZoom\":1.7,\"frameRects\":[[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[1,0,383,387,369,200],[384,0,450,453,357,171],[834,0,518,521,344,141],[1352,0,585,589,331,110],[0,589,585,589,331,110],[585,589,585,589,331,110],[1170,589,585,590,331,71],[0,1179,582,586,333,73],[582,1179,666,584,248,74],[582,1179,666,584,248,74],[1248,1179,580,584,334,74],[0,0,575,579,336,77],[575,0,558,562,345,85],[1133,0,446,296,386,230],[1579,0,446,295,386,230],[0,579,446,294,360,226],[446,579,445,314,360,206],[891,579,442,447,362,182],[1333,579,475,474,363,172],[0,1053,544,502,330,161],[544,1053,618,555,293,150],[1162,1053,618,555,293,150],[0,0,617,555,255,144],[617,0,614,553,257,145],[1231,0,638,613,231,83],[0,613,601,619,263,73],[601,613,447,619,338,52],[1048,613,506,658,295,31],[0,1271,506,658,295,31],[506,1271,506,665,295,24],[1012,1271,506,675,295,14],[1518,1271,506,658,295,31],[0,0,558,659,243,30],[558,0,753,668,48,24],[558,0,753,668,48,24],[0,668,766,657,69,14],[766,668,738,655,105,15],[0,1325,861,655,0,15],[861,1325,863,653,0,16],[0,0,861,653,0,16],[861,0,899,650,0,18],[0,653,899,647,0,19],[899,653,899,637,0,24],[0,1300,899,612,0,37],[899,1300,987,516,1,119],[0,0,904,605,136,13],[904,0,909,591,137,26],[0,605,903,595,138,21],[903,605,1008,591,142,21],[0,1200,999,603,151,0],[999,1200,942,529,208,21],[0,0,1088,785,62,21],[0,785,1082,796,68,1],[0,0,1075,786,75,2],[0,786,1069,777,81,2],[0,0,1062,775,81,4],[1062,0,959,774,83,4],[0,775,958,772,83,5],[958,775,953,767,87,6],[958,775,953,767,87,6],[0,0,943,759,93,9],[943,0,918,733,110,19],[0,759,697,673,270,68],[697,759,747,671,218,69],[0,0,653,671,288,69],[653,0,637,603,286,77],[1290,0,636,603,284,77],[0,671,630,603,290,77],[630,671,622,603,298,77],[1252,671,584,603,298,81],[0,1274,575,599,305,83],[575,1274,575,599,305,83],[1150,1274,566,597,313,84],[0,0,571,597,308,84],[571,0,567,595,310,85],[1138,0,566,593,311,86],[0,597,552,583,320,91],[552,597,530,560,331,103],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0]],\"bufferWidth\":1088,\"bufferHeight\":796},\"ZuozhuZZZZ_xuzuobati-106\":{\"atlas\":\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"frameAtlases\":[\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\"],\"timeline\":[0,1,2,3,4,5,6,7,8,9,9,0,1,2,3,4,5,6,7,8,9,9,0,1,2,3,4,5,6,7,8,9,9,0,1,2,3,4,5,6,7],\"width\":244,\"height\":361,\"pivot\":[0.6557991803278688,1.0593905817174516],\"renderScale\":1.7,\"sourceFrames\":10,\"sourceCrop\":[15,14,259,375],\"sourceZoom\":1.7,\"frameRects\":[[0,0,1,1,0,0],[1,0,204,123,7,117],[205,0,209,176,11,65],[414,0,229,279,0,18],[643,0,231,342,3,17],[874,0,233,346,11,14],[1107,0,221,354,18,7],[1328,0,221,352,18,9],[1549,0,222,360,18,1],[1771,0,221,361,18,0],[1771,0,221,361,18,0],[0,0,1,1,0,0],[1,0,204,123,7,117],[205,0,209,176,11,65],[414,0,229,279,0,18],[643,0,231,342,3,17],[874,0,233,346,11,14],[1107,0,221,354,18,7],[1328,0,221,352,18,9],[1549,0,222,360,18,1],[1771,0,221,361,18,0],[1771,0,221,361,18,0],[0,0,1,1,0,0],[1,0,204,123,7,117],[205,0,209,176,11,65],[414,0,229,279,0,18],[643,0,231,342,3,17],[874,0,233,346,11,14],[1107,0,221,354,18,7],[1328,0,221,352,18,9],[1549,0,222,360,18,1],[1771,0,221,361,18,0],[1771,0,221,361,18,0],[0,0,1,1,0,0],[1,0,204,123,7,117],[205,0,209,176,11,65],[414,0,229,279,0,18],[643,0,231,342,3,17],[874,0,233,346,11,14],[1107,0,221,354,18,7],[1328,0,221,352,18,9]],\"bufferWidth\":233,\"bufferHeight\":361},\"ZuozhuZZZZ_xuzuobati-107\":{\"atlas\":\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"frameAtlases\":[\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\"],\"timeline\":[0,1,2,3,4,5,6,7,8,9,9,0,1,2,3,4,5,6,7,8,9,9,0,1,2,3,4,5,6,7,8,9,9,0,1,2,3,4,5,6,7],\"width\":242,\"height\":367,\"pivot\":[0.662107438016529,1.0590463215258854],\"renderScale\":1.7,\"sourceFrames\":10,\"sourceCrop\":[13,11,255,378],\"sourceZoom\":1.7,\"frameRects\":[[0,0,221,361,18,6],[221,0,224,367,18,0],[445,0,222,334,18,33],[667,0,223,336,18,31],[890,0,230,342,12,24],[1120,0,230,343,4,23],[1350,0,229,283,0,20],[1579,0,204,190,16,57],[1783,0,204,147,7,99],[1987,0,1,1,0,0],[1987,0,1,1,0,0],[0,0,221,361,18,6],[221,0,224,367,18,0],[445,0,222,334,18,33],[667,0,223,336,18,31],[890,0,230,342,12,24],[1120,0,230,343,4,23],[1350,0,229,283,0,20],[1579,0,204,190,16,57],[1783,0,204,147,7,99],[1987,0,1,1,0,0],[1987,0,1,1,0,0],[0,0,221,361,18,6],[221,0,224,367,18,0],[445,0,222,334,18,33],[667,0,223,336,18,31],[890,0,230,342,12,24],[1120,0,230,343,4,23],[1350,0,229,283,0,20],[1579,0,204,190,16,57],[1783,0,204,147,7,99],[1987,0,1,1,0,0],[1987,0,1,1,0,0],[0,0,221,361,18,6],[221,0,224,367,18,0],[445,0,222,334,18,33],[667,0,223,336,18,31],[890,0,230,342,12,24],[1120,0,230,343,4,23],[1350,0,229,283,0,20],[1579,0,204,190,16,57]],\"bufferWidth\":230,\"bufferHeight\":367},\"ZuozhuZZZZ_xuzuobati-108\":{\"atlas\":\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"frameAtlases\":[\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\"],\"timeline\":[0,1,2,3,4,5,6,7,8,9,9,0,1,2,3,4,5,6,7,8,9,9,0,1,2,3,4,5,6,7,8,9,9,0,1,2,3,4,5,6,7],\"width\":225,\"height\":367,\"pivot\":[0.6281555555555555,1.0590463215258854],\"renderScale\":1.7,\"sourceFrames\":10,\"sourceCrop\":[16,11,241,378],\"sourceZoom\":1.7,\"frameRects\":[[0,0,220,361,0,6],[220,0,223,367,0,0],[443,0,222,334,0,33],[665,0,222,336,0,31],[887,0,223,343,0,24],[1110,0,225,343,0,24],[1335,0,225,347,0,20],[1560,0,221,353,0,14],[1781,0,221,351,0,16],[0,367,221,360,0,7],[0,367,221,360,0,7],[0,0,220,361,0,6],[220,0,223,367,0,0],[443,0,222,334,0,33],[665,0,222,336,0,31],[887,0,223,343,0,24],[1110,0,225,343,0,24],[1335,0,225,347,0,20],[1560,0,221,353,0,14],[1781,0,221,351,0,16],[0,367,221,360,0,7],[0,367,221,360,0,7],[0,0,220,361,0,6],[220,0,223,367,0,0],[443,0,222,334,0,33],[665,0,222,336,0,31],[887,0,223,343,0,24],[1110,0,225,343,0,24],[1335,0,225,347,0,20],[1560,0,221,353,0,14],[1781,0,221,351,0,16],[0,367,221,360,0,7],[0,367,221,360,0,7],[0,0,220,361,0,6],[220,0,223,367,0,0],[443,0,222,334,0,33],[665,0,222,336,0,31],[887,0,223,343,0,24],[1110,0,225,343,0,24],[1335,0,225,347,0,20],[1560,0,221,353,0,14]],\"bufferWidth\":225,\"bufferHeight\":367}},\"effects\":{\"ZuozhuZZZZ_haolonghuo\":[\"ZuozhuZZZZ_haolonghuo-31\",\"ZuozhuZZZZ_haolonghuo-664\"],\"ZuozhuZZZZ_haolonghuoyan\":[\"ZuozhuZZZZ_haolonghuoyan-31\",\"ZuozhuZZZZ_haolonghuoyan-891\"],\"ZuozhuZZZZ_qianniaodao1\":[\"ZuozhuZZZZ_qianniaodao1-69\",\"ZuozhuZZZZ_qianniaodao1-258\"],\"ZuozhuZZZZ_qianniaodao2\":[\"ZuozhuZZZZ_qianniaodao2-90\",\"ZuozhuZZZZ_qianniaodao2-285\"],\"ZuozhuZZZZ_qianniaodao3\":[\"ZuozhuZZZZ_qianniaodao3-112\",\"ZuozhuZZZZ_qianniaodao3-684\"],\"ZuozhuZZZZ_qilin\":[],\"ZuozhuZZZZ_qilin_texie\":[],\"ZuozhuZZZZ_qilin_yan\":[],\"ZuozhuZZZZ_qilin_yantexie\":[],\"ZuozhuZZZZ_xuzuobati\":[\"ZuozhuZZZZ_xuzuobati-106\",\"ZuozhuZZZZ_xuzuobati-107\",\"ZuozhuZZZZ_xuzuobati-108\"]},\"screenFlashes\":{\"ZuozhuZZZZ_qilin\":[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.01434,0.03834,0.05231,0.05231,0.05231,0.03797,0.01397,0.0,0.024,0.02878,0.02878,0.05278,0.05756,0.03356,0.02878,0.02878,0.00478,0.024,0.02878,0.03356,0.03356,0.05756,0.03834,0.03356,0.02878,0.02878,0.00478,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0],\"ZuozhuZZZZ_qilin_yan\":[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.01434,0.03834,0.05231,0.05231,0.05231,0.03797,0.01397,0.0,0.024,0.02878,0.02878,0.05278,0.05756,0.03356,0.02878,0.02878,0.00478,0.024,0.02878,0.03356,0.03356,0.05756,0.03834,0.03356,0.02878,0.02878,0.00478,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]},\"trimmedFrames\":true,\"moves\":{\"13121301\":\"mystery\",\"13121302\":\"blazeMystery\",\"13121303\":\"standard\",\"13121304\":\"blazeStandard\",\"13121305\":\"dragon\",\"13121306\":\"blazeDragon\",\"13121307\":\"mangekyo\",\"13121308\":\"rinnegan\",\"13121309\":\"susanoo\"},\"actions\":{\"mystery\":[\"ZuozhuZZZZ_qilin\",\"ZuozhuZZZZ_qilin_texie\"],\"blazeMystery\":[\"ZuozhuZZZZ_qilin_yan\",\"ZuozhuZZZZ_qilin_yantexie\"],\"standard\":[\"ZuozhuZZZZ_qianniaodao3\"],\"blazeStandard\":[\"ZuozhuZZZZ_qianniaodao3\"],\"dragon\":[\"ZuozhuZZZZ_haolonghuo\"],\"blazeDragon\":[\"ZuozhuZZZZ_haolonghuoyan\"],\"susanoo\":[\"ZuozhuZZZZ_xuzuobati\"],\"mangekyo\":[],\"rinnegan\":[]},\"presentation\":{\"ZuozhuZZZZ_qilin\":{\"coreWidth\":2108.3252142857145,\"sharpScale\":0.3562069053252932,\"displayWidth\":1800,\"heightAboveGround\":8,\"anchorX\":486.26888565849595,\"anchorY\":45.18550161743125},\"ZuozhuZZZZ_qilin_yan\":{\"coreWidth\":2108.3252142857145,\"sharpScale\":0.3562069053252932,\"displayWidth\":1800,\"heightAboveGround\":8,\"anchorX\":443.827173513118,\"anchorY\":92.15362321888044},\"ZuozhuZZZZ_haolonghuo\":{\"coreWidth\":1835.3846153846152,\"sharpScale\":0.65,\"displayWidth\":1280,\"heightAboveGround\":85,\"anchorX\":646.6441401451926,\"anchorY\":-0.18294502609732122},\"ZuozhuZZZZ_haolonghuoyan\":{\"coreWidth\":1835.3846153846152,\"sharpScale\":0.65,\"displayWidth\":1280,\"heightAboveGround\":85,\"anchorX\":646.6441401451926,\"anchorY\":-0.18294502609732122},\"ZuozhuZZZZ_qianniaodao3\":{\"coreWidth\":950.0,\"sharpScale\":1.2105263157894737,\"displayWidth\":1600,\"heightAboveGround\":85,\"anchorX\":155.94951996166486,\"anchorY\":-115.03627205330208},\"ZuozhuZZZZ_xuzuobati\":{\"coreWidth\":143.52941176470588,\"displayWidth\":180,\"heightAboveGround\":0,\"anchorX\":0,\"anchorY\":0}},\"cinematics\":{\"ZuozhuZZZZ_qilin_texie\":{\"url\":\"/public/sasuke-vfx/cinematic-v1/ZuozhuZZZZ_qilin_texie.swf\",\"symbol\":\"texie\",\"plateName\":\"sasukeCinematicPlate\",\"referenceFrame\":38,\"frames\":79,\"frameRate\":24,\"bitmapWidth\":1572,\"bitmapHeight\":846,\"sha256\":\"f16173521e0d952c8b7fffc304ff7a61726fe0d69242926e0dec33319f1f1f33\"},\"ZuozhuZZZZ_qilin_yantexie\":{\"url\":\"/public/sasuke-vfx/cinematic-v1/ZuozhuZZZZ_qilin_yantexie.swf\",\"symbol\":\"texie\",\"plateName\":\"sasukeCinematicPlate\",\"referenceFrame\":38,\"frames\":79,\"frameRate\":24,\"bitmapWidth\":1572,\"bitmapHeight\":846,\"sha256\":\"1a4e99260234b2ba494e545a0b2707dbbf963ffb737197109c835fa31b358fd6\"},\"ZuozhuZZZZ_qilin\":{\"url\":\"/public/sasuke-vfx/cinematic-v1/ZuozhuZZZZ_qilin.swf\",\"impact\":true,\"symbols\":[\"xia\",\"shang\"],\"frames\":125,\"frameRate\":24,\"sha256\":\"d2ec9eed5f3be47cac0a1ce907d784029f7687452152748b83236a6e5693c533\"},\"ZuozhuZZZZ_qilin_yan\":{\"url\":\"/public/sasuke-vfx/cinematic-v1/ZuozhuZZZZ_qilin_yan.swf\",\"impact\":true,\"symbols\":[\"xia\",\"shang\"],\"frames\":125,\"frameRate\":24,\"sha256\":\"c472a9161d1979764f94bcad99ff15640c55e65d5f2fc0d554d81d234f8f18af\"}}}");manifest.firstAtlases={};
         for(var key:String in manifest.clips){var clip:Object=manifest.clips[key];
            // Keep exactly the preloaded five opening frames resident. Evicting
            // these between casts caused visible cold-start gaps at x2.
            for(var head:int=0;head<Math.min(5,clip.timeline.length);head++)manifest.firstAtlases[String(clip.frameAtlases[head])]=true;
            clip.aheadPages=[];
            for(var tick:int=0;tick<clip.timeline.length;tick++){var pages:Array=[];var seen:Object={};for(var j:int=tick;j<Math.min(tick+40,clip.timeline.length);j++){var page:String=String(clip.frameAtlases[j]);if(!seen[page]){seen[page]=true;pages.push(page);}}clip.aheadPages[tick]=pages;}
         }
         FSasukeFxLoading["_manifest"]=manifest;return manifest;
      }
      public function UpdateSasukeVfx():void {
         if(FId!=11120970 || FSkillId<13121301 || FSkillId>13121309 || (FIndex!=TYPE_ACTIVE_ATTACK && FIndex!=TYPE_ACTIVE_SKILL) || FSasukeVfxStarted)return;
         for each(var old:Sprite in FSasukeActiveVfx)if(old.parent!=null)old.parent.removeChild(old);
         FSasukeActiveVfx=[];FSasukeVfxStarted=true;ShowSasukeVfx(FSkillId);
      }
      public function ShowSasukeVfx(skill:int):void {
         var host:DisplayObjectContainer=FBattleStage;if(host==null || host.stage==null)return;
         var origin:Point=host.globalToLocal(localToGlobal(new Point()));var center:Point=new Point();var count:int=0;var seen:Object={};
         if(FTargets!=null && FResults!=null)for(var i:int=0;i<FTargets.length && i<FResults.length;i++){var enemy:ProbeRole=FTargets[i];if(enemy==null || enemy==this || enemy.Camp==Camp || FResults[i].CMD!=TTargetInfo.CMD_ATTACK)continue;var key:String=enemy.Camp+"_"+enemy.Pos;if(seen[key])continue;seen[key]=true;var pt:Point=host.globalToLocal(enemy.localToGlobal(new Point()));center.x+=pt.x;center.y+=pt.y;count++;}
         if(count){center.x/=count;center.y/=count;}else center=origin.clone();
         if(skill==13121307 || skill==13121308){ShowSasukeGenjutsu(host,center,skill==13121308);return;}
         var tl:Point=host.globalToLocal(stage.localToGlobal(new Point()));var br:Point=host.globalToLocal(stage.localToGlobal(new Point(stage.stageWidth,stage.stageHeight)));var unit:Number=Math.abs(br.x-tl.x)/1250;
         var data:Object=SasukeVfxManifest();var effects:Array=data.actions[String(data.moves[skill])] as Array;
         if(skill<=13121302){SasukeBackdrop(host);ShowSasukeScreenFlash(host,skill);}
         if(effects!=null)for each(var effect:String in effects){
            if(data.cinematics[effect]!=null && data.cinematics[effect].impact){PlaySasukeNativeImpact(effect,host,center,unit);continue;}
            var cutin:Boolean=effect.indexOf("texie")>=0;
            if(cutin){PlaySasukeCinematic(effect,host);continue;}
            var at:Point=cutin?new Point((tl.x+br.x)/2,(tl.y+br.y)/2):(skill==13121309?origin.clone():center.clone());
            PlaySasukeEffect(effect,host,at,cutin?1220:skill==13121309?340:skill<=13121302?1000:880,unit,0,cutin);
         }
      }
      public function PlaySasukeEffect(effect:String,host:DisplayObjectContainer,at:Point,limit:Number,unit:Number,delay:int,cutin:Boolean=false):void {
         var data:Object=SasukeVfxManifest();var layers:Array=data.effects[effect] as Array;if(layers==null)return;
         var left:Number=0;var right:Number=0;var top:Number=0;var bottom:Number=0;
         for each(var key:String in layers){var c:Object=data.clips[key];var w:Number=c.width/c.renderScale;var h:Number=c.height/c.renderScale;left=Math.min(left,-Number(c.pivot[0])*w);right=Math.max(right,(1-Number(c.pivot[0]))*w);top=Math.min(top,-Number(c.pivot[1])*h);bottom=Math.max(bottom,(1-Number(c.pivot[1]))*h);}
         var tl:Point=host.globalToLocal(stage.localToGlobal(new Point()));var br:Point=host.globalToLocal(stage.localToGlobal(new Point(stage.stageWidth,stage.stageHeight)));
         var width:Number=Math.max(1,right-left);var height:Number=Math.max(1,bottom-top);
         var fit:Number=Math.min(limit*unit/Math.max(width,height),(br.x-tl.x-24*unit)/width,(br.y-tl.y-24*unit)/height);
         if(!cutin){
            var lightning:Boolean=effect.indexOf("qilin")>=0;
            var dragon:Boolean=effect.indexOf("haolonghuo")>=0;
            var sword:Boolean=effect.indexOf("qianniaodao")>=0;
            var gain:Number=lightning?1.55:dragon?1.7:sword?1.35:1.25;
            fit*=gain;
            // Bright central action remains prominent; only distant particles
            // may reach the viewport edge. Cap size without the old shrink-to-fit.
            fit=Math.min(fit,(br.x-tl.x)*1.15/width,(br.y-tl.y)*1.55/height);
         }
         if(cutin){
            fit=Math.max((br.x-tl.x)/width,(br.y-tl.y)/height);
            var camera:Point=new Point((tl.x+br.x)/2-(left+right)/2*fit*(scaleX<0?-1:1),(tl.y+br.y)/2-(top+bottom)/2*fit);
            for each(var cameraKey:String in layers){var cameraClip:Object=data.clips[cameraKey];PlaySasukeVfxAsset(cameraKey,host,camera,cameraClip.width/cameraClip.renderScale*fit,cameraClip.height/cameraClip.renderScale*fit,delay,scaleX<0,false,false);}
            return;
         }
         // Source hit anchors keep the visible strike on the victim. Smoke and
         // distant sparks must neither shrink nor recenter the main artwork.
         var profile:Object=data.presentation[effect];
         if(profile!=null){
            fit=Number(profile.displayWidth)*unit/Number(profile.coreWidth);
            // Avoid magnifying a raster layer beyond 1.55 screen pixels per
            // source pixel at the game's native 1250-wide presentation.
            if(profile.sharpScale!=null)fit=Math.min(fit,Number(profile.sharpScale)*1.4*unit);
            else for each(var sharpKey:String in layers){var sharp:Object=data.clips[sharpKey];fit=Math.min(fit,Number(sharp.renderScale)*1.55*unit);}
            var impact:Point=at.clone();var facing:Number=scaleX<0?-1:1;
            impact.x-=Number(profile.anchorX)*fit*facing;
            impact.y-=Number(profile.heightAboveGround)*unit+Number(profile.anchorY)*fit;
            for each(var placedKey:String in layers){var placed:Object=data.clips[placedKey];PlaySasukeVfxAsset(placedKey,host,impact,placed.width/placed.renderScale*fit,placed.height/placed.renderScale*fit,delay,scaleX<0,false,false);}
            return;
         }
         // Center visible source bounds on the enemy field; arbitrary SWF origins
         // must not displace the rendered dragon or slash beyond the battlefield.
         at=at.clone();var mirror:Boolean=scaleX<0;
         var cx:Number=(left+right)/2;var cy:Number=(top+bottom)/2;
         var desiredY:Number=at.y-Math.min(height*fit*.28,150*unit);
         at.x-=cx*fit*(mirror?-1:1);at.y=desiredY-cy*fit;
         var low:Number=mirror?-right:left;var high:Number=mirror?-left:right;
         if(width*fit<br.x-tl.x-24*unit)at.x=Math.max(tl.x+12*unit-low*fit,Math.min(br.x-12*unit-high*fit,at.x));
         else at.x=(tl.x+br.x)/2-cx*fit*(mirror?-1:1);
         if(height*fit<br.y-tl.y-24*unit)at.y=Math.max(tl.y+12*unit-top*fit,Math.min(br.y-12*unit-bottom*fit,at.y));
         else at.y=(tl.y+br.y)/2-cy*fit;
         for each(key in layers){c=data.clips[key];PlaySasukeVfxAsset(key,host,at,c.width/c.renderScale*fit,c.height/c.renderScale*fit,delay,mirror,false,false);}
      }
      public function ShowSasukeScreenFlash(host:DisplayObjectContainer,skill:int):void {
         var data:Object=SasukeVfxManifest();var frames:Array=data.screenFlashes[skill==13121301?"ZuozhuZZZZ_qilin":"ZuozhuZZZZ_qilin_yan"] as Array;
         if(frames==null)return;
         var tl:Point=host.globalToLocal(stage.localToGlobal(new Point()));var br:Point=host.globalToLocal(stage.localToGlobal(new Point(stage.stageWidth,stage.stageHeight)));
         var layer:Sprite=new Sprite();layer.name="sasukeSkillVfx";layer.mouseEnabled=false;layer.mouseChildren=false;
         layer.graphics.beginFill(0xFFFFFF);layer.graphics.drawRect(tl.x,tl.y,br.x-tl.x,br.y-tl.y);layer.graphics.endFill();layer.alpha=0;host.addChild(layer);FSasukeActiveVfx.push(layer);
         var caster:ProbeRole=this;var serial:uint=FCombatVfxSerial;var castSkill:int=FSkillId;var started:int=Math.max(0,FFrameIndex);var tick:Function;var cleanup:Function;
         cleanup=function(event:Event=null):void{layer.removeEventListener(Event.ENTER_FRAME,tick);layer.removeEventListener(Event.REMOVED_FROM_STAGE,cleanup);if(layer.parent!=null)layer.parent.removeChild(layer);};
         tick=function(event:Event):void{var age:int=Math.max(0,caster.FFrameIndex)-started;if(layer.stage==null || caster.FCombatVfxSerial!=serial || caster.FSkillId!=castSkill || age>=frames.length){cleanup();return;}layer.alpha=Number(frames[Math.max(0,age)]);};
         layer.addEventListener(Event.ENTER_FRAME,tick);layer.addEventListener(Event.REMOVED_FROM_STAGE,cleanup);
      }
      public function ShowSasukeGenjutsu(host:DisplayObjectContainer,at:Point,rinnegan:Boolean):void {
         var layer:Sprite=new Sprite();layer.name="sasukeSkillVfx";layer.mouseEnabled=false;layer.mouseChildren=false;
         var color:uint=rinnegan?0xA477FF:0xE53448;
         layer.graphics.beginFill(0x160B2D,.5);layer.graphics.drawCircle(0,0,100);layer.graphics.endFill();
         for(var ring:int=0;ring<5;ring++){layer.graphics.lineStyle(2,color,.85);layer.graphics.drawCircle(0,0,18+ring*17);}
         layer.graphics.beginFill(color,.95);layer.graphics.drawCircle(0,0,12);layer.graphics.endFill();
         if(!rinnegan)for(var n:int=0;n<3;n++){var angle:Number=n*Math.PI*2/3;var x:Number=Math.cos(angle)*48;var y:Number=Math.sin(angle)*48;layer.graphics.beginFill(0x100B20,1);layer.graphics.drawCircle(x,y,13);layer.graphics.endFill();}
         layer.filters=[new GlowFilter(color,.9,18,18,2,1)];layer.x=at.x;layer.y=at.y-85;host.addChild(layer);FSasukeActiveVfx.push(layer);
         var caster:ProbeRole=this;var serial:uint=FCombatVfxSerial;var started:int=FFrameIndex;var tick:Function;
         tick=function(event:Event):void{var age:int=Math.max(0,caster.FFrameIndex-started);if(layer.stage==null || caster.FCombatVfxSerial!=serial || age>44){layer.removeEventListener(Event.ENTER_FRAME,tick);if(layer.parent!=null)layer.parent.removeChild(layer);return;}layer.rotation=age*(rinnegan?-5:7);var size:Number=.35+Math.min(1,age/10)*1.2;layer.scaleX=layer.scaleY=size;layer.alpha=Math.min(1,age/5)*Math.min(1,(44-age)/12);};
         layer.addEventListener(Event.ENTER_FRAME,tick);
      }
      public static function LoadSasukeCinematic(name:String,meta:Object):void {
         var key:String="_cinema_"+name;if(FSasukeFxLoading[key]!=null)return;
         var entry:Object={ready:false,failed:false};FSasukeFxLoading[key]=entry;
         var loader:Loader=new Loader();entry.loader=loader;
         var complete:Function;var failed:Function;var detach:Function;
         detach=function():void{loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,complete);loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,failed);loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,failed);};
         failed=function(event:Event):void{detach();entry.failed=true;};
         complete=function(event:Event):void{
            detach();
            try{
               if(meta.impact){entry.klasses=[];entry.pool=[];for each(var symbol:String in meta.symbols){entry.klasses.push(loader.contentLoaderInfo.applicationDomain.getDefinition(symbol) as Class);}entry.ready=true;return;}
               var klass:Class=loader.contentLoaderInfo.applicationDomain.getDefinition(String(meta.symbol)) as Class;
               var movie:MovieClip=new klass() as MovieClip;movie.stop();movie.gotoAndStop(int(meta.referenceFrame));
               var plane:DisplayObject=movie.getChildByName(String(meta.plateName));
               if(plane==null)throw new Error("Missing cinematic camera plane");
               entry.bounds=plane.getBounds(movie);entry.klass=klass;movie.gotoAndStop(1);entry.spare=movie;entry.ready=true;
            }catch(error:Error){entry.failed=true;}
         };
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,complete);loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,failed);loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,failed);
         loader.load(new URLRequest(String(meta.url)),new flash.system.LoaderContext(false,new flash.system.ApplicationDomain(flash.system.ApplicationDomain.currentDomain)));
      }
      public function PlaySasukeCinematic(name:String,host:DisplayObjectContainer):void {
         var meta:Object=SasukeVfxManifest().cinematics[name];if(meta==null || host==null || host.stage==null)return;
         LoadSasukeCinematic(name,meta);
         var tl:Point=host.globalToLocal(stage.localToGlobal(new Point()));var br:Point=host.globalToLocal(stage.localToGlobal(new Point(stage.stageWidth,stage.stageHeight)));
         var width:Number=br.x-tl.x;var height:Number=br.y-tl.y;
         var layer:Sprite=new Sprite();layer.name="sasukeSkillVfx";layer.mouseEnabled=false;layer.mouseChildren=false;layer.x=tl.x;layer.y=tl.y;
         layer.scrollRect=new Rectangle(0,0,width,height);layer.visible=false;
         var backdrop:Sprite=new Sprite();backdrop.graphics.beginFill(0);backdrop.graphics.drawRect(0,0,width,height);backdrop.graphics.endFill();layer.addChild(backdrop);
         host.addChild(layer);FSasukeActiveVfx.push(layer);
         var caster:ProbeRole=this;var serial:uint=FCombatVfxSerial;var skill:int=FSkillId;var started:int=Math.max(0,FFrameIndex);
         var movie:MovieClip;var entry:Object;var cleaned:Boolean=false;var last:int=-1;var tick:Function;var cleanup:Function;
         cleanup=function(event:Event=null):void{
            if(event!=null && event.target!=layer)return;if(cleaned)return;cleaned=true;
            layer.removeEventListener(Event.ENTER_FRAME,tick);layer.removeEventListener(Event.REMOVED_FROM_STAGE,cleanup);
            if(movie!=null){movie.stop();if(movie.parent!=null)movie.parent.removeChild(movie);movie.gotoAndStop(1);if(entry!=null && entry.spare==null)entry.spare=movie;movie=null;}
            if(layer.parent!=null)layer.parent.removeChild(layer);
         };
         tick=function(event:Event):void{
            var age:int=Math.max(0,caster.FFrameIndex)-started;
            if(layer.stage==null || caster.FCombatVfxSerial!=serial || caster.FSkillId!=skill || age>=Math.ceil(Number(meta.frames)*25/Number(meta.frameRate))){cleanup();return;}
            entry=FSasukeFxLoading["_cinema_"+name];if(entry==null || entry.failed){cleanup();return;}
            if(!entry.ready){if(ExternalInterface.available)ExternalInterface.call("vfxProbe","ERROR cinematic not ready "+name);return;}
            if(movie==null){
               if(entry.spare!=null){movie=entry.spare as MovieClip;entry.spare=null;}else{var klass:Class=entry.klass as Class;movie=new klass() as MovieClip;}
               movie.stop();layer.addChild(movie);if(ExternalInterface.available)ExternalInterface.call("vfxProbe","CINEMATIC "+name);
               var bounds:Rectangle=entry.bounds as Rectangle;var fit:Number=Math.max(width/bounds.width,height/bounds.height);
               // One authored camera plane fills the viewport in both camps;
               // no stretching and no mirrored lettering in the cinematic.
               movie.scaleX=movie.scaleY=fit;movie.x=width/2-(bounds.left+bounds.right)/2*fit;movie.y=height/2-(bounds.top+bounds.bottom)/2*fit;
            }
            var frame:int=Math.min(int(meta.frames),Math.max(1,Math.round(age*Number(meta.frameRate)/25)+1));if(frame==last)return;last=frame;
            movie.gotoAndStop(frame);
            backdrop.visible=movie.getChildByName(String(meta.plateName))!=null;
            if(backdrop.visible){var plane:DisplayObject=movie.getChildByName(String(meta.plateName));var covered:Rectangle=plane.getBounds(layer);if(covered.left>.5 || covered.top>.5 || covered.right<width-.5 || covered.bottom<height-.5){if(ExternalInterface.available)ExternalInterface.call("vfxProbe","ERROR cinematic coverage "+covered);}}
            layer.visible=movie.numChildren>0;
         };
         layer.addEventListener(Event.ENTER_FRAME,tick);layer.addEventListener(Event.REMOVED_FROM_STAGE,cleanup);tick(null);
      }
      public function PlaySasukeNativeImpact(name:String,host:DisplayObjectContainer,at:Point,unit:Number):void {
         var data:Object=SasukeVfxManifest();var meta:Object=data.cinematics[name];LoadSasukeCinematic(name,meta);
         var profile:Object=data.presentation[name];var fit:Number=Number(profile.displayWidth)*unit/Number(profile.coreWidth);
         var layer:Sprite=new Sprite();layer.name="sasukeSkillVfx";layer.mouseEnabled=false;layer.mouseChildren=false;
         var facing:Number=scaleX<0?-1:1;
         layer.x=at.x-Number(profile.anchorX)*fit*facing;
         layer.y=at.y-Number(profile.heightAboveGround)*unit-Number(profile.anchorY)*fit;
         layer.scaleX=fit*facing;layer.scaleY=fit;host.addChild(layer);FSasukeActiveVfx.push(layer);
         var caster:ProbeRole=this;var serial:uint=FCombatVfxSerial;var skill:int=FSkillId;var started:int=Math.max(0,FFrameIndex);
         var entry:Object;var movies:Array;var last:int=-1;var cleaned:Boolean=false;var tick:Function;var cleanup:Function;
         cleanup=function(event:Event=null):void{
            if(event!=null && event.target!=layer)return;if(cleaned)return;cleaned=true;
            layer.removeEventListener(Event.ENTER_FRAME,tick);layer.removeEventListener(Event.REMOVED_FROM_STAGE,cleanup);
            if(movies!=null){for each(var movie:MovieClip in movies){movie.stop();if(movie.parent!=null)movie.parent.removeChild(movie);movie.gotoAndStop(1);}entry.pool.push(movies);movies=null;}
            if(layer.parent!=null)layer.parent.removeChild(layer);
         };
         tick=function(event:Event):void{
            var age:int=Math.max(0,caster.FFrameIndex)-started;
            if(layer.stage==null || caster.FCombatVfxSerial!=serial || caster.FSkillId!=skill || age>=Math.ceil(Number(meta.frames)*25/24)){cleanup();return;}
            entry=FSasukeFxLoading["_cinema_"+name];if(entry==null || entry.failed){cleanup();return;}if(!entry.ready){if(ExternalInterface.available)ExternalInterface.call("vfxProbe","ERROR native impact not ready "+name);return;}
            if(movies==null){if(ExternalInterface.available)ExternalInterface.call("vfxProbe","NATIVE_IMPACT "+name);movies=entry.pool.length?entry.pool.pop():[];if(!movies.length)for each(var klass:Class in entry.klasses){movies.push(new klass() as MovieClip);}for each(var clip:MovieClip in movies){clip.stop();layer.addChild(clip);}}
            var frame:int=Math.min(int(meta.frames),Math.max(1,Math.round(age*24/25)+1));if(frame==last)return;last=frame;
            for each(var active:MovieClip in movies)active.gotoAndStop(Math.min(frame,active.totalFrames));
         };
         layer.addEventListener(Event.ENTER_FRAME,tick);layer.addEventListener(Event.REMOVED_FROM_STAGE,cleanup);tick(null);
      }
}
}
