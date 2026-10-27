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
  private var skills:Array=[13121901, 13121902, 13121904, 13121905, 13121906, 13121907, 13121908, 13121909, 13121903, 0, 0];
  private var clipNames:Array=["mystery", "standard", "pressure", "darkness", "migraine", "summon", "reattach", "reincarnation", "clone-standard", "entry", "dead"];
  private var metadata:Object={"idle":{"assets":[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82],"loop":true,"duration":40,"sourceAction":"C_idle","hitFrames":[41]},"run":{"assets":[83,84,85,86],"loop":true,"duration":40,"sourceAction":"C_run1_2","hitFrames":[2]},"hit":{"assets":[87,88,89,90,91,92,93,0],"loop":false,"duration":40,"sourceAction":"D_stand_behit1","hitFrames":[3],"returnFrame":7},"dead":{"assets":[94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,115],"loop":false,"duration":40,"sourceAction":"C_dead","hitFrames":[11],"returnFrame":22},"entry":{"assets":[116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,0],"loop":false,"duration":40,"sourceAction":"C_entry","hitFrames":[18],"returnFrame":36},"standard":{"assets":[152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,0],"loop":false,"duration":40,"sourceAction":"A_3hit","hitFrames":[11,19,28,39,49,61],"returnFrame":94},"mystery":{"assets":[246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,348,349,0],"loop":false,"duration":40,"sourceAction":"SP_skill1","hitFrames":[19,29,56],"returnFrame":104},"reattach":{"assets":[350,351,352,353,354,355,356,357,358,359,360,361,362,363,364,365,366,367,368,369,370,371,372,373,374,375,376,377,378,379,380,381,382,383,384,385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,400,401,402,403,404,405,406,407,408,409,410,411,412,413,414,415,416,417,418,419,420,421,422,423,424,425,426,427,428,429,430,431,432,433,434,435,436,437,0],"loop":false,"duration":40,"sourceAction":"SP_skill2","hitFrames":[38],"returnFrame":88},"pressure":{"assets":[438,439,440,441,442,443,444,445,446,447,448,449,450,451,452,453,454,455,456,457,458,459,460,461,462,463,464,465,466,467,468,469,470,471,472,473,474,475,476,477,478,479,480,481,482,483,484,485,486,487,488,489,490,491,492,493,494,495,496,497,498,499,500,501,502,503,504,505,506,507,508,509,510,511,512,513,514,515,516,517,518,519,520,521,522,523,524,525,526,527,528,529,530,531,532,533,534,535,536,0],"loop":false,"duration":40,"sourceAction":"SP_skill3","hitFrames":[47,49],"returnFrame":99},"darkness":{"assets":[537,538,539,540,541,542,543,544,545,546,547,548,549,550,551,552,553,554,555,556,557,558,559,560,561,562,563,564,565,566,567,568,569,570,571,572,573,574,575,576,577,578,579,580,581,582,583,584,585,586,587,588,589,590,591,592,593,594,595,596,597,598,599,600,601,602,603,604,605,606,607,608,609,610,611,612,613,614,615,616,617,618,619,620,621,622,623,624,625,626,627,628,629,630,631,632,633,634,635,636,637,638,639,640,641,642,643,0],"loop":false,"duration":40,"sourceAction":"SP_skill4","hitFrames":[49,52,56,65],"returnFrame":107},"migraine":{"assets":[644,645,646,647,648,649,650,651,652,653,654,655,656,657,658,659,660,661,662,663,664,665,666,667,668,669,670,671,672,673,674,675,676,677,678,679,680,681,682,683,684,685,686,687,688,689,690,691,692,693,694,695,696,697,698,699,700,701,702,703,704,705,706,707,708,709,710,711,712,713,714,715,716,717,718,719,720,721,722,723,724,725,726,727,728,729,730,731,732,733,734,735,736,737,738,739,740,741,0],"loop":false,"duration":40,"sourceAction":"SP_skill5","hitFrames":[45,50],"returnFrame":98},"summon":{"assets":[742,743,744,745,746,747,748,749,750,751,752,753,754,755,756,757,758,759,760,761,762,763,764,765,766,767,768,769,770,771,772,773,774,775,776,777,778,779,780,781,782,783,784,785,786,787,788,789,790,791,792,793,794,795,796,797,798,799,800,801,802,803,804,805,806,807,808,809,810,811,812,813,814,815,816,817,818,819,820,821,822,823,824,825,826,827,828,829,830,831,832,0],"loop":false,"duration":40,"sourceAction":"SP_skill6","hitFrames":[55],"returnFrame":91},"water-hiding":{"assets":[833,834,835,836,837,838,839,840,841,842,843,844,845,846,847,848,849,850,851,852,853,854,855,856,857,858,859,860,861,862,863,864,865,866,867,868,869,870,871,872,873,874,875,876,877,878,879,880,881,882,883,884,885,886,887,888,889,890,891,892,893,894,895,896,897,0],"loop":false,"duration":40,"sourceAction":"SP_skill9","hitFrames":[8],"returnFrame":65},"reincarnation":{"assets":[898,899,900,901,902,903,904,905,906,907,908,909,910,911,912,913,914,915,916,917,918,919,920,921,922,923,924,925,926,927,928,929,930,931,932,933,934,935,936,937,0],"loop":false,"duration":40,"sourceAction":"SP_skill10","hitFrames":[0],"returnFrame":40},"clone-standard":{"assets":[152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,0],"loop":false,"duration":40,"sourceAction":"A_3hit","hitFrames":[11,19,28,39,49,61],"returnFrame":94}};
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
   loadTexture("00A9B165",["idle"]);
   loadTexture("A9B1650B",["standard"]);
   loadTexture("A9B1650C",["mystery","pressure","darkness","migraine","summon","reattach","reincarnation","entry","dead"]);
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
   var clip:Object=clips[name];if(clip==null)return;index=Math.max(0,Math.min(index,clip.images.length-1));role.actor.bitmapData=clip.images[index];role.actor.x=-clip.meta[index].px;role.actor.y=-clip.meta[index].py;role.KakuzuStrikePose({Pivot:{X:clip.meta[index].px,Y:clip.meta[index].py}});
  }
  private function tick(event:Event):void {
   for each(var decoder:TPakDecoder in decoders)if(decoder.Unstreamizing)decoder.Process();if(loaded<11)return;
   if(readyAt<0){clips["clone-idle"]=clips.idle;clips["clone-standard"]=clips.standard;readyAt=getTimer()+4000;ProbeRole.PreloadKakuzuNative();}if(getTimer()<readyAt)return;
   var age:int=getTimer()-readyAt;var bounds:Array=[0, 5200, 10000, 15000, 20320, 25280, 29960, 34520, 37160, 41960, 44440, 46360, 51560, 56360, 61360, 66680, 71640, 76320, 80880, 83520, 88320, 90800, 92720];var slot:int=0;while(slot<22 && age>=bounds[slot+1])slot++;
   if(slot>=22){left.FSkillId=0;right.FSkillId=0;left.ClearKakuzuVfx();right.ClearKakuzuVfx();var remaining:int=0;for(var q:int=0;q<battle.numChildren;q++)if(battle.getChildAt(q).name=="kakuzuEdoSkillVfx")remaining++;report("DONE Kakuzu/Water Clone native component; remaining="+remaining);removeEventListener(Event.ENTER_FRAME,tick);return;}
   var side:int=slot<11?0:1;var index:int=slot%11;var caster:ProbeRole=side==0?left:right;var victim:ProbeRole=side==0?right:left;
   if(lastSlot!=slot){left.ClearKakuzuVfx();right.ClearKakuzuVfx();left.FSkillId=0;right.FSkillId=0;++caster.FCombatVfxSerial;caster.FSkillId=skills[index];caster.FId=index>=8?11120998:11120997;caster.FFrameIndex=0;caster.y=440;victim.y=440;lastSlot=slot;label.text="Kakuzu / Water Clone | "+clipNames[index]+" | camp "+side;report("CASE "+skills[index]+" camp="+side);}
   var frame:int=int((age-bounds[slot])/40);var name:String=clipNames[index];caster.FFrameIndex=frame;
   if(frame<clips[name].images.length){renderRole(caster,name,frame);caster.UpdateKakuzuVfx();}else{caster.FSkillId=0;renderRole(caster,index>=8?"clone-idle":"idle",int(age/100)%clips.idle.images.length);}
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
 public var FId:int=11120997;public var FSkillId:int=0;public var FIndex:int=1;public var FFrameIndex:int=0;public var Camp:int=0;public var Pos:int=1;
 public const TYPE_ACTIVE_ATTACK:int=1;public const TYPE_ACTIVE_SKILL:int=2;
 public static var FKakuzuNative:Object={};public var FKakuzuVfxStarted:Boolean=false;public var FKakuzuLayers:Array=[];public var FCombatVfxSerial:uint=0;
 public var FBattleStage:Sprite;public var FTargets:Array=[];public var FResults:Array=[];public var actor:Bitmap=new Bitmap();public function get FBitmap():Bitmap{return actor;}
 public function ProbeRole(){actor.smoothing=true;addChild(actor);}
      public static function PreloadKakuzuNative() : void {
         for each(var effect:String in ["HuituJiaodu_xinzangduoqu","HuituJiaodu_tishugongji3","HuituJiaodu_fengdunyahai","HuituJiaodu_leidunweian","HuituJiaodu_huoduntoukeku","HuituJiaodu_shuifenshenzhishu","HuituJiaodu_diyuanyufenghe","HuituJiaodu_diyuanyufenghe_shouji"])LoadKakuzuNative(effect);
      }
      public static function LoadKakuzuNative(effect:String) : void {
         if(FKakuzuNative[effect]!=null)return;
         var state:Object={};FKakuzuNative[effect]=state;var loader:Loader=new Loader();state.loader=loader;
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(event:Event):void{state.domain=loader.contentLoaderInfo.applicationDomain;if(loader.content is MovieClip)MovieClip(loader.content).stop();});
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(event:IOErrorEvent):void{delete FKakuzuNative[effect];});
         loader.load(new URLRequest("/public/kakuzu-edo-vfx/native/"+effect+".swf"),new flash.system.LoaderContext(false,new flash.system.ApplicationDomain()));
      }
      public function ClearKakuzuVfx() : void {
         for each(var layer:Sprite in FKakuzuLayers)if(layer.parent!=null)layer.parent.removeChild(layer);
         FKakuzuLayers=[];FKakuzuVfxStarted=false;
      }
      public function UpdateKakuzuVfx() : void {
         if((FId!=11120997 && FId!=11120998) || FKakuzuVfxStarted || (FIndex!=TYPE_ACTIVE_ATTACK && FIndex!=TYPE_ACTIVE_SKILL))return;
         FKakuzuVfxStarted=true;
         var effect:String=FSkillId==13121901?"HuituJiaodu_xinzangduoqu":FSkillId==13121902||FSkillId==13121903?"HuituJiaodu_tishugongji3":FSkillId==13121904?"HuituJiaodu_fengdunyahai":FSkillId==13121905?"HuituJiaodu_leidunweian":FSkillId==13121906?"HuituJiaodu_huoduntoukeku":FSkillId==13121907?"HuituJiaodu_shuifenshenzhishu":FSkillId==13121908?"HuituJiaodu_diyuanyufenghe_shouji":FSkillId==13121909?"HuituJiaodu_diyuanyufenghe":"";
         if(effect!=""){PlayKakuzuNative(effect,"xia");PlayKakuzuNative(effect,"shang");}
      }
      public function KakuzuContactOffset() : Point {
         if((FId!=11120997 && FId!=11120998) || FTargets==null || FResults==null || (FIndex!=TYPE_ACTIVE_ATTACK && FIndex!=TYPE_ACTIVE_SKILL))return new Point();
         var enemy:ProbeRole=null;
         for(var i:int=0;i<FTargets.length && i<FResults.length;i++)if(FTargets[i]!=null && FTargets[i].Camp!=Camp && FResults[i].CMD==1){enemy=FTargets[i];break;}
         if(enemy==null)return new Point();
         var contact:Point=globalToLocal(enemy.localToGlobal(new Point()));
         var distance:Number=FSkillId==13121901?180:75;
         var end:Number=Number(JSON.parse("{\"13121901\":104,\"13121902\":94,\"13121903\":94,\"13121904\":99,\"13121905\":107,\"13121906\":98,\"13121907\":91,\"13121908\":88,\"13121909\":40}")[String(FSkillId)]);var phase:Number=Math.min(1,Math.max(0,FFrameIndex/9),Math.max(0,(end-FFrameIndex)/9));phase=phase*phase*(3-2*phase);
         return new Point((contact.x-distance)*phase,contact.y*phase);
      }
      public function KakuzuStrikePose(frame:Object) : void {
         if((FId!=11120997 && FId!=11120998) || frame==null || (FIndex!=TYPE_ACTIVE_ATTACK && FIndex!=TYPE_ACTIVE_SKILL))return;
         var offset:Point=KakuzuContactOffset();FBitmap.x=-frame.Pivot.X+offset.x;FBitmap.y=-frame.Pivot.Y+offset.y;
      }
      public function PlayKakuzuNative(effect:String,symbol:String) : void {
         LoadKakuzuNative(effect);
         var caster:ProbeRole=this;var host:DisplayObjectContainer=FBattleStage;if(host==null || stage==null)return;
         var layer:Sprite=new Sprite();layer.name="kakuzuEdoSkillVfx";layer.mouseEnabled=false;layer.mouseChildren=false;
         if(symbol=="xia" && parent==host)host.addChildAt(layer,host.getChildIndex(this));else host.addChild(layer);
         FKakuzuLayers.push(layer);
         var clip:MovieClip=null;var serial:uint=FCombatVfxSerial;var skill:uint=FSkillId;var last:int=-1;var tick:Function;var clear:Function;var cleaned:Boolean=false;
         clear=function(event:Event=null):void{if(cleaned || event!=null && event.target!=layer)return;cleaned=true;layer.removeEventListener(Event.ENTER_FRAME,tick);layer.removeEventListener(Event.REMOVED_FROM_STAGE,clear);if(clip!=null)clip.stop();if(layer.parent!=null)layer.parent.removeChild(layer);};
         tick=function(event:Event=null):void{
            if(host.stage==null || caster.stage==null || caster.FCombatVfxSerial!=serial || caster.FSkillId!=skill || (caster.FIndex!=TYPE_ACTIVE_ATTACK && caster.FIndex!=TYPE_ACTIVE_SKILL)){clear();return;}
            var state:Object=FKakuzuNative[effect];if(state==null || state.domain==null){layer.visible=false;return;}
            if(clip==null){if(!state.domain.hasDefinition(symbol)){clear();return;}var type:Class=state.domain.getDefinition(symbol) as Class;clip=new type() as MovieClip;clip.stop();layer.addChild(clip);}
            var rate:Number=24;var frame:int=Math.round(Math.max(0,caster.FFrameIndex)*rate/25)+1;
            if(frame>clip.totalFrames){clear();return;}
            layer.visible=true;if(frame!=last){clip.gotoAndStop(frame);last=frame;}
            var offset:Point=caster.KakuzuContactOffset();var at:Point=host.globalToLocal(caster.localToGlobal(new Point(45+offset.x,offset.y)));
            layer.x=at.x;layer.y=at.y;layer.scaleX=caster.scaleX<0?-0.82:0.82;layer.scaleY=0.82;
         };
         layer.addEventListener(Event.ENTER_FRAME,tick);layer.addEventListener(Event.REMOVED_FROM_STAGE,clear);tick();
      }
 }
}