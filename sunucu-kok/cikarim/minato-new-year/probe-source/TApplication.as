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
  private var skills:Array=[13122101, 13122102, 13122103, 13122104, 13122105, 13122106, 13122107, 13122108, 13122109, 13122110, 0, 0];
  private var clipNames:Array=["mystery", "standard", "standard-2", "standard-3", "enhanced-mystery", "counter", "clone-counter", "summon", "prowess", "evade", "entry", "dead"];
  private var metadata:Object={"idle":{"assets":[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38],"loop":true,"duration":40,"sourceAction":"C_idle","hitFrames":[19]},"run":{"assets":[39,40,41,42],"loop":true,"duration":40,"sourceAction":"C_run1_2","hitFrames":[2]},"hit":{"assets":[43,44,45,46,47,48,49,0],"loop":false,"duration":40,"sourceAction":"D_stand_behit1","hitFrames":[3],"returnFrame":7},"dead":{"assets":[50,51,52,53,54,55,56,57,58,59,60,61,62,63,63],"loop":false,"duration":40,"sourceAction":"C_dead","hitFrames":[7],"returnFrame":14},"entry":{"assets":[64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,0],"loop":false,"duration":40,"sourceAction":"C_entry","hitFrames":[19],"returnFrame":39},"standard":{"assets":[103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,0],"loop":false,"duration":40,"sourceAction":"A_4hit","hitFrames":[14,54,67],"returnFrame":99},"standard-2":{"assets":[202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,0],"loop":false,"duration":40,"sourceAction":"A_5hit","hitFrames":[14,54,67],"returnFrame":99},"standard-3":{"assets":[301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360,361,362,363,364,365,366,367,368,369,370,371,372,373,374,375,376,377,378,379,380,381,382,383,384,385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,0],"loop":false,"duration":40,"sourceAction":"A_6hit","hitFrames":[14,54,67],"returnFrame":99},"mystery":{"assets":[400,401,402,403,404,405,406,407,408,409,410,411,412,413,414,415,416,417,418,419,420,421,422,423,424,425,426,427,428,429,430,431,432,433,434,435,436,437,438,439,440,441,442,443,444,445,446,447,448,449,450,451,452,453,454,455,456,457,458,459,460,461,462,463,464,465,466,467,468,469,470,471,472,473,474,475,476,477,478,479,480,481,482,483,484,485,486,487,488,489,490,491,492,493,494,495,496,497,498,499,500,501,502,503,504,505,506,507,508,509,510,511,512,513,514,0],"loop":false,"duration":40,"sourceAction":"SP_skill1","hitFrames":[38,46,64,72,85],"returnFrame":115},"enhanced-mystery":{"assets":[515,516,517,518,519,520,521,522,523,524,525,526,527,528,529,530,531,532,533,534,535,536,537,538,539,540,541,542,543,544,545,546,547,548,549,550,551,552,553,554,555,556,557,558,559,560,561,562,563,564,565,566,567,568,569,570,571,572,573,574,575,576,577,578,579,580,581,582,583,584,585,586,587,588,589,590,591,592,593,594,595,596,597,598,599,600,601,602,603,604,605,606,607,608,609,610,611,612,613,614,615,616,617,618,619,620,621,622,623,0],"loop":false,"duration":40,"sourceAction":"SP_skill2","hitFrames":[38,46,64,71],"returnFrame":109},"counter":{"assets":[624,625,626,627,628,629,630,631,632,633,634,635,636,637,638,639,640,641,642,643,644,645,646,647,648,649,650,651,652,653,654,655,656,657,658,659,660,661,662,663,664,665,666,667,668,669,670,671,672,673,674,675,676,677,678,679,680,681,682,683,684,685,686,687,688,689,690,691,692,693,694,695,696,697,698,699,700,701,702,703,704,705,706,707,708,709,710,711,712,713,714,0],"loop":false,"duration":40,"sourceAction":"SP_skill4","hitFrames":[15,31,39,47,55,68],"returnFrame":91},"evade":{"assets":[715,716,717,718,719,720,721,722,723,724,725,726,727,728,729,730,731,732,733,734,735,736,737,738,739,740,741,742,743,744,745,746,747,748,749,750,751,752,753,754,755,0],"loop":false,"duration":40,"sourceAction":"SP_skill5","hitFrames":[2],"returnFrame":41},"summon":{"assets":[756,757,758,759,760,761,762,763,764,765,766,767,768,769,770,771,772,773,774,775,776,777,778,779,780,781,782,783,784,785,786,787,0],"loop":false,"duration":40,"sourceAction":"SP_skill3","hitFrames":[9],"returnFrame":32},"prowess":{"assets":[788,789,790,791,792,793,794,795,796,797,798,799,800,801,802,803,804,805,806,807,808,809,810,811,812,813,814,0],"loop":false,"duration":40,"sourceAction":"SP_skill6","hitFrames":[0],"returnFrame":27},"clone-counter":{"assets":[624,625,626,627,628,629,630,631,632,633,634,635,636,637,638,639,640,641,642,643,644,645,646,647,648,649,650,651,652,653,654,655,656,657,658,659,660,661,662,663,664,665,666,667,668,669,670,671,672,673,674,675,676,677,678,679,680,681,682,683,684,685,686,687,688,689,690,691,692,693,694,695,696,697,698,699,700,701,702,703,704,705,706,707,708,709,710,711,712,713,714,0],"loop":false,"duration":40,"sourceAction":"SP_skill4","hitFrames":[15,31,39,47,55,68],"returnFrame":91}};
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
   loadTexture("00A9B16B",["idle"]);
   loadTexture("A9B16B0B",["standard","standard-2","standard-3"]);
   loadTexture("A9B16B0C",["mystery","enhanced-mystery","counter","summon","prowess","evade","entry","dead"]);
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
   var clip:Object=clips[name];if(clip==null)return;index=Math.max(0,Math.min(index,clip.images.length-1));role.actor.bitmapData=clip.images[index];role.actor.x=-clip.meta[index].px;role.actor.y=-clip.meta[index].py;role.MinatoStrikePose({Pivot:{X:clip.meta[index].px,Y:clip.meta[index].py}});
  }
  private function tick(event:Event):void {
   for each(var decoder:TPakDecoder in decoders)if(decoder.Unstreamizing)decoder.Process();if(loaded<12)return;
   if(readyAt<0){clips["clone-idle"]=clips.idle;clips["clone-standard"]=clips.standard;clips["clone-counter"]=clips.counter;readyAt=getTimer()+4000;ProbeRole.PreloadMinatoNative();}if(getTimer()<readyAt)return;
   var age:int=getTimer()-readyAt;var bounds:Array=[0, 5640, 10640, 15640, 20640, 26040, 30720, 35400, 37720, 39840, 42520, 45120, 46720, 52360, 57360, 62360, 67360, 72760, 77440, 82120, 84440, 86560, 89240, 91840, 93440];var slot:int=0;while(slot<24 && age>=bounds[slot+1])slot++;
   if(slot>=24){left.FSkillId=0;right.FSkillId=0;left.ClearMinatoVfx();right.ClearMinatoVfx();var remaining:int=0;for(var q:int=0;q<battle.numChildren;q++)if(battle.getChildAt(q).name=="minatoNewYearSkillVfx")remaining++;report("DONE Minato/Yellow Flash Clone native component; remaining="+remaining);removeEventListener(Event.ENTER_FRAME,tick);return;}
   var side:int=slot<12?0:1;var index:int=slot%12;var caster:ProbeRole=side==0?left:right;var victim:ProbeRole=side==0?right:left;
   caster.Camp=side;victim.Camp=1-side;
   caster.FTargets=[caster,victim];caster.FResults=[{CMD:0,ResultInfo:{HurtHp:0}},{CMD:1,ResultInfo:{HurtHp:index==6?-300:10}}];
   if(lastSlot!=slot){left.ClearMinatoVfx();right.ClearMinatoVfx();left.FSkillId=0;right.FSkillId=0;++caster.FCombatVfxSerial;caster.FSkillId=skills[index];caster.FId=(index==6||index>=10)?11121004:11121003;caster.FFrameIndex=0;caster.y=440;victim.y=440;lastSlot=slot;label.text="Minato / Yellow Flash Clone | "+clipNames[index]+" | camp "+side;report("CASE "+skills[index]+" camp="+side);}
   var frame:int=int((age-bounds[slot])/40);var name:String=clipNames[index];caster.FFrameIndex=frame;
   if(frame<clips[name].images.length){renderRole(caster,name,frame);caster.UpdateMinatoVfx();}else{caster.FSkillId=0;renderRole(caster,index>=8?"clone-idle":"idle",int(age/100)%clips.idle.images.length);}
   renderRole(victim,"idle",int(age/100)%clips.idle.images.length);
   var phases:Array=name=="mystery"?[4,16,32,48,60,72,84,100]:[4,int(clips[name].images.length*.4),int(clips[name].images.length*.7)];
   for each(var phase:int in phases){var key:String="CASE-"+name+"-camp-"+side+"-frame-"+phase;if(frame>=phase&&!captured[key]){captured[key]=true;var started:int=getTimer();saveFrame(key);readyAt+=getTimer()-started;}}
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
 public var FId:int=11121003;public var FSkillId:int=0;public var FIndex:int=1;public var FFrameIndex:int=0;public var Camp:int=0;public var Pos:int=1;
 public const TYPE_ACTIVE_ATTACK:int=1;public const TYPE_ACTIVE_SKILL:int=2;
 public static var FMinatoNative:Object={};public var FMinatoVfxStarted:Boolean=false;public var FMinatoLayers:Array=[];public var FCombatVfxSerial:uint=0;
 public var FBattleStage:Sprite;public var FTargets:Array=[];public var FResults:Array=[];public var actor:Bitmap=new Bitmap();public function get FBitmap():Bitmap{return actor;}
 public function ProbeRole(){actor.smoothing=true;addChild(actor);}
      public static function PreloadMinatoNative() : void {
         for each(var effect:String in ["BofengshuimenXinchun_Feileishenyinji", "BofengshuimenXinchun_Shikongjianlianduan_1", "BofengshuimenXinchun_Shikongjianlianduan_2", "BofengshuimenXinchun_Shikongjianlianduan_2teixie", "BofengshuimenXinchun_ShikongjianLuoxuanlianwan", "BofengshuimenXinchun_ShikongjianLuoxuanlianwan_shouji", "BofengshuimenXinchun_Shikongjianniji_luoxuanwan", "BofengshuimenXinchun_Shikongjianniji_shanbi", "BofengshuimenXinchun_Shikongjianniji_shouji", "BofengshuimenXinchun_Yingfenshenzhishu", "DASHEWAN_tongyongfuhuo"])LoadMinatoNative(effect);
      }
      public static function LoadMinatoNative(effect:String) : void {
         if(FMinatoNative[effect]!=null)return;
         var state:Object={};FMinatoNative[effect]=state;var loader:Loader=new Loader();state.loader=loader;
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(event:Event):void{state.domain=loader.contentLoaderInfo.applicationDomain;if(loader.content is MovieClip)MovieClip(loader.content).stop();});
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(event:IOErrorEvent):void{delete FMinatoNative[effect];});
         loader.load(new URLRequest("/public/minato-new-year-vfx/native/"+effect+".swf"),new flash.system.LoaderContext(false,new flash.system.ApplicationDomain()));
      }
      public function ClearMinatoVfx() : void {
         for each(var layer:Sprite in FMinatoLayers)if(layer.parent!=null)layer.parent.removeChild(layer);
         FMinatoLayers=[];FMinatoVfxStarted=false;
      }
      public function UpdateMinatoVfx() : void {
         if((FId!=11121003 && FId!=11121004) || FMinatoVfxStarted || (FIndex!=TYPE_ACTIVE_ATTACK && FIndex!=TYPE_ACTIVE_SKILL))return;
         FMinatoVfxStarted=true;
         if(FSkillId==13122109){PlayMinatoNative("DASHEWAN_tongyongfuhuo","tyfh");return;}
         var mapping:Object=JSON.parse("{\"13122101\":\"BofengshuimenXinchun_Shikongjianlianduan_1\",\"13122105\":\"BofengshuimenXinchun_Shikongjianlianduan_2\",\"13122102\":\"BofengshuimenXinchun_ShikongjianLuoxuanlianwan\",\"13122103\":\"BofengshuimenXinchun_ShikongjianLuoxuanlianwan\",\"13122104\":\"BofengshuimenXinchun_ShikongjianLuoxuanlianwan\",\"13122106\":\"BofengshuimenXinchun_Shikongjianniji_luoxuanwan\",\"13122107\":\"BofengshuimenXinchun_Shikongjianniji_luoxuanwan\",\"13122108\":\"BofengshuimenXinchun_Yingfenshenzhishu\",\"13122110\":\"BofengshuimenXinchun_Shikongjianniji_shanbi\"}");var effect:String=mapping[String(FSkillId)];
         if(FSkillId==13122105)PlayMinatoNative("BofengshuimenXinchun_Shikongjianlianduan_2teixie","texie");
         if(effect!=null){PlayMinatoNative(effect,"xia");PlayMinatoNative(effect,"shang");}
         if(FTargets!=null && FResults!=null && ((FSkillId>=13122102 && FSkillId<=13122104)||FSkillId==13122106||FSkillId==13122107)){
            var standard:Boolean=FSkillId>=13122102&&FSkillId<=13122104;
            for(var i:int=0;i<FTargets.length&&i<FResults.length;i++)if(FTargets[i]!=null&&FTargets[i].Camp!=Camp&&FResults[i].CMD==1&&FResults[i].ResultInfo.HurtHp>0){
               PlayMinatoNative(standard?"BofengshuimenXinchun_ShikongjianLuoxuanlianwan_shouji":"BofengshuimenXinchun_Shikongjianniji_shouji","shang",FTargets[i],standard?14:15);
               if(standard)PlayMinatoNative("BofengshuimenXinchun_Feileishenyinji","shang",FTargets[i],14);
            }
         }
      }
      public function MinatoContactOffset() : Point {
         if((FId!=11121003 && FId!=11121004) || FSkillId<13122101 || FSkillId>13122110 || FTargets==null || FResults==null || (FIndex!=TYPE_ACTIVE_ATTACK && FIndex!=TYPE_ACTIVE_SKILL))return new Point();
         var enemy:ProbeRole=null;
         for(var i:int=0;i<FTargets.length && i<FResults.length;i++)if(FTargets[i]!=null && FTargets[i].Camp!=Camp && FResults[i].CMD==1){enemy=FTargets[i];break;}
         if(enemy==null || FSkillId==13122101 || FSkillId==13122105 || FSkillId>=13122108)return new Point();
         var contact:Point=globalToLocal(enemy.localToGlobal(new Point()));
         // Source SkillAction distances, using the same 0.84 scale as the actor.
         var distance:Number=(FSkillId>=13122102&&FSkillId<=13122104?600:510)*0.84;
         var end:Number=Number(JSON.parse("{\"13122101\":115,\"13122102\":99,\"13122103\":99,\"13122104\":99,\"13122105\":109,\"13122106\":91,\"13122107\":91,\"13122108\":32,\"13122109\":27,\"13122110\":41}")[String(FSkillId)]);var phase:Number=Math.min(1,Math.max(0,FFrameIndex/9),Math.max(0,(end-FFrameIndex)/9));phase=phase*phase*(3-2*phase);
         return new Point((contact.x-distance)*phase,contact.y*phase);
      }
      public function MinatoStrikePose(frame:Object) : void {
         if((FId!=11121003 && FId!=11121004) || frame==null || (FIndex!=TYPE_ACTIVE_ATTACK && FIndex!=TYPE_ACTIVE_SKILL))return;
         var offset:Point=MinatoContactOffset();FBitmap.x=-frame.Pivot.X+offset.x;FBitmap.y=-frame.Pivot.Y+offset.y;
      }
      public function PlayMinatoNative(effect:String,symbol:String,target:ProbeRole=null,startFrame:int=0) : void {
         LoadMinatoNative(effect);
         var caster:ProbeRole=this;var host:DisplayObjectContainer=FBattleStage;if(host==null || stage==null)return;
         var layer:Sprite=new Sprite();layer.name="minatoNewYearSkillVfx";layer.mouseEnabled=false;layer.mouseChildren=false;
         if(symbol=="xia" && parent==host)host.addChildAt(layer,host.getChildIndex(this));else host.addChild(layer);
         FMinatoLayers.push(layer);
         var clip:MovieClip=null;var serial:uint=FCombatVfxSerial;var skill:uint=FSkillId;var last:int=-1;var tick:Function;var clear:Function;var cleaned:Boolean=false;
         clear=function(event:Event=null):void{if(cleaned || event!=null && event.target!=layer)return;cleaned=true;layer.removeEventListener(Event.ENTER_FRAME,tick);layer.removeEventListener(Event.REMOVED_FROM_STAGE,clear);if(clip!=null)clip.stop();if(layer.parent!=null)layer.parent.removeChild(layer);};
         tick=function(event:Event=null):void{
            if(host.stage==null || caster.stage==null || caster.FCombatVfxSerial!=serial || caster.FSkillId!=skill || (caster.FIndex!=TYPE_ACTIVE_ATTACK && caster.FIndex!=TYPE_ACTIVE_SKILL)){clear();return;}
            var state:Object=FMinatoNative[effect];if(state==null || state.domain==null){layer.visible=false;return;}
            if(clip==null){if(!state.domain.hasDefinition(symbol)){clear();return;}var type:Class=state.domain.getDefinition(symbol) as Class;clip=new type() as MovieClip;clip.stop();layer.addChild(clip);}
            if(caster.FFrameIndex<startFrame){layer.visible=false;return;}
            var rate:Number=24;var frame:int=Math.round(Math.max(0,caster.FFrameIndex-startFrame)*rate/25)+1;
            if(frame>clip.totalFrames){clear();return;}
            layer.visible=true;if(frame!=last){clip.gotoAndStop(frame);last=frame;}
            var offset:Point=caster.MinatoContactOffset();var originX:Number=70*0.84;
            var at:Point=host.globalToLocal(caster.localToGlobal(new Point(originX+offset.x,offset.y)));
            var facing:Number=caster.scaleX;
            if(target!=null){at=host.globalToLocal(target.localToGlobal(new Point()));facing=target.scaleX;}
            layer.x=at.x;layer.y=at.y;layer.scaleX=facing<0?-0.84:0.84;layer.scaleY=0.84;
            if(symbol=="texie"){
               var bounds:Rectangle=clip.getBounds(clip);if(bounds.width>1 && bounds.height>1){
                  // Fit the original cut-in uniformly to the battle viewport.
                  var fit:Number=host.stage.stageWidth/bounds.width;
                  layer.scaleX=fit;layer.scaleY=fit;
                  layer.x=host.stage.stageWidth*.5-(bounds.x+bounds.width*.5)*fit;
                  layer.y=host.stage.stageHeight*.4-(bounds.y+bounds.height*.5)*fit;
               }
            }
         };
         layer.addEventListener(Event.ENTER_FRAME,tick);layer.addEventListener(Event.REMOVED_FROM_STAGE,clear);tick();
      }
 }
}