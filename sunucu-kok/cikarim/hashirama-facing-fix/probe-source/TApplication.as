package {
 import Foundation.Decoder.Pak.TPakDecoder;
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
  private var FId:int=11120940;
  private var FSkillId:int=0;
  private var FIndex:int=1;
  private const TYPE_ACTIVE_ATTACK:int=1;
  private const TYPE_ACTIVE_SKILL:int=2;
  private var FFrameIndex:int=0;
  private var FHashiramaVfxStarted:Boolean=false;
  private var FHashiramaVfxHit:Boolean=false;
  private static var FHashiramaFxCache:Object={};
  private static var FHashiramaFxLoading:Object={};
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
  private var skills:Array=[13121002, 13121002];
  private var clipNames:Array=["rumbling", "rumbling"];
  private var metadata:Object={"idle":{"assets":[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34],"duration":40,"loop":true,"sourceAction":"C_idle","sourceFrames":33,"recoveredFrames":0},"run":{"assets":[35,36,37,38],"duration":40,"loop":true,"sourceAction":"C_run1_2","sourceFrames":3,"recoveredFrames":0},"hit":{"assets":[39,40,41,42,43,44,45,0],"duration":40,"loop":false,"sourceAction":"D_stand_behit1","sourceFrames":6,"recoveredFrames":0,"returnFrame":7},"dead":{"assets":[46,47,48,49,50,51,52,53,54,55,55],"duration":40,"loop":false,"sourceAction":"C_dead","sourceFrames":9,"recoveredFrames":0,"returnFrame":10},"taijutsu":{"assets":[56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,0],"duration":40,"loop":false,"sourceAction":"A_1hit","sourceFrames":33,"recoveredFrames":0,"hitFrames":[9,13,17,21],"returnFrame":35},"sword":{"assets":[91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,0],"duration":40,"loop":false,"sourceAction":"A_4hit","sourceFrames":49,"recoveredFrames":0,"hitFrames":[20,26,32,38],"returnFrame":52},"deity":{"assets":[143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,0],"duration":40,"loop":false,"sourceAction":"SP_skill6","sourceFrames":109,"recoveredFrames":0,"hitFrames":[51,63,75,87,99],"returnFrame":137},"rumbling":{"assets":[257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360,361,362,363,364,365,366,367,368,369,370,371,372,373,374,375,376,377,378,379,380,381,382,383,384,385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,400,401,402,403,404,405,406,407,408,409,410,411,412,413,414,415,416,417,418,419,420,421,422,423,424,425,426,427,428,429,430,431,432,433,434,435,436,437,438,439,440,441,442,443,444,445,446,447,448,449,450,451,452,453,454,455,456,457,458,459,460,461,462,463,464,465,466,467,468,469,470,471,472,473,474,475,476,477,478,479,480,481,0],"duration":40,"loop":false,"sourceAction":"SP_skill5","sourceFrames":216,"recoveredFrames":152,"hitFrames":[93,114,135,156,177],"returnFrame":225},"adamantine":{"assets":[482,483,484,485,486,487,488,489,490,491,492,493,494,495,496,497,498,499,500,501,502,503,504,505,506,507,508,509,510,511,512,513,514,515,516,517,518,519,520,521,522,523,524,525,526,527,528,529,530,531,532,533,534,0],"duration":40,"loop":false,"sourceAction":"SP_skill_2","sourceFrames":50,"recoveredFrames":0,"hitFrames":[20,26,32,38],"returnFrame":53},"severe":{"assets":[535,536,537,538,539,540,541,542,543,544,545,546,547,548,549,550,551,552,553,554,555,556,557,558,559,560,561,562,563,564,565,566,567,568,569,570,571,572,573,574,575,576,577,578,579,580,581,582,583,584,585,586,587,588,589,590,591,592,593,594,595,596,597,598,599,600,601,602,603,604,605,606,607,608,609,610,611,612,613,614,615,616,617,618,619,620,621,0],"duration":40,"loop":false,"sourceAction":"SP_skill_22","sourceFrames":83,"recoveredFrames":0,"hitFrames":[20,31,42,53,64],"returnFrame":87},"burst-severe":{"assets":[622,623,624,625,626,627,628,629,630,631,632,633,634,635,636,637,638,639,640,641,642,643,644,645,646,647,648,649,650,651,652,653,654,655,656,657,658,659,660,661,662,663,664,665,666,667,668,669,670,671,672,673,674,675,676,677,678,679,680,681,682,683,684,685,686,687,688,689,690,691,692,693,694,695,696,697,698,699,700,701,702,703,704,705,706,707,708,0],"duration":40,"loop":false,"sourceAction":"SP_skill_22","sourceFrames":83,"recoveredFrames":0,"hitFrames":[20,31,42,53,64],"returnFrame":87},"golem":{"assets":[709,710,711,712,713,714,715,716,717,718,719,720,721,722,723,724,725,726,727,728,729,730,731,732,733,734,735,736,737,738,739,740,741,742,743,744,745,746,747,748,749,750,751,752,753,754,755,756,757,758,759,760,761,0],"duration":40,"loop":false,"sourceAction":"SP_skill_44","sourceFrames":50,"recoveredFrames":0,"hitFrames":[19,25,31,37,43],"returnFrame":53},"forest":{"assets":[762,763,764,765,766,767,768,769,770,771,772,773,774,775,776,777,778,779,780,781,782,783,784,785,786,787,788,789,790,791,792,793,794,795,796,797,798,799,800,801,802,803,804,805,806,807,808,809,810,811,812,813,814,815,816,817,818,819,820,821,822,823,824,825,826,827,828,829,830,831,832,833,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,0,0],"duration":40,"loop":false,"sourceAction":"SP_skill8","sourceFrames":69,"recoveredFrames":0,"returnFrame":106},"burst":{"assets":[834,835,836,837,838,839,840,841,842,843,844,845,846,847,0],"duration":40,"loop":false,"sourceAction":"C_skillIdle_1","sourceFrames":13,"recoveredFrames":0,"returnFrame":14}};
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
   var actors:Sprite=new Sprite();battle.addChild(actors);actors.x=35;actors.scaleX=.94;actors.scaleY=.94;
   left=new ProbeRole();right=new ProbeRole();ProbeRole.PreloadHashiramaNative();
   left.FBattleStage=battle;right.FBattleStage=battle;
   left.x=350;left.y=470;right.x=900;right.y=420;right.scaleX=-1;
   right.Camp=1;left.FTargets=[left,right,right];right.FTargets=[right,left,left];
   var results:Array=[{CMD:0,ResultInfo:{HurtHp:0}},{CMD:1,ResultInfo:{HurtHp:10}},{CMD:9,ResultInfo:{HurtHp:0}}];
   left.FResults=results;right.FResults=results;
   actors.addChild(left);actors.addChild(right);
   label=new TextField();label.defaultTextFormat=new TextFormat("_sans",20,0xffffff,true);label.width=1200;label.height=30;label.x=25;label.y=20;addChild(label);
   loadTexture("00A9B12C",["idle"]);
   loadTexture("A9B12C0B",["taijutsu","sword"]);
   loadTexture("A9B12C0C",["deity","rumbling","adamantine","severe","burst-severe","golem","forest","burst"]);
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
  private function renderRole(role:ProbeRole,name:String,index:int,leap:Boolean=false):void {
   var clip:Object=clips[name];if(clip==null)return;
   index=Math.max(0,Math.min(index,clip.images.length-1));
   role.actor.bitmapData=clip.images[index];role.actor.x=-clip.meta[index].px;role.actor.y=-clip.meta[index].py;
   role.HashiramaStrikePose({Surface:clip.images[index],Pivot:{X:clip.meta[index].px,Y:clip.meta[index].py}});
  }
  private function tick(event:Event):void {
   for each(var decoder:TPakDecoder in decoders)if(decoder.Unstreamizing)decoder.Process();
   if(loaded<11)return;
   if(readyAt<0)readyAt=getTimer();
   var age:int=getTimer()-readyAt;var slots:Array=[0, 10040, 20080, 30120, 40160];var slot:int=0;while(slot<4 && age>=slots[slot+1])slot++;
   if(slot>=4){
    var remaining:int=0;var hosts:Array=[battle];while(hosts.length){var host:DisplayObjectContainer=hosts.pop() as DisplayObjectContainer;for(var q:int=0;q<host.numChildren;q++){var child:DisplayObject=host.getChildAt(q);if(child.name=="hashiramaSkillVfx")remaining++;if(child is DisplayObjectContainer)hosts.push(child);}}report("DONE Hashirama native component; remaining="+remaining);
    removeEventListener(Event.ENTER_FRAME,tick);return;
   }
   var side:int=slot<2?0:1;var index:int=slot%2;var caster:ProbeRole=side==0?left:right;var victim:ProbeRole=side==0?right:left;
   if(lastSlot!=slot){

    left.FSkillId=0;right.FSkillId=0;
    ++caster.FCombatVfxSerial;caster.FSkillId=skills[index];caster.FFrameIndex=0;caster.FHashiramaVfxStarted=false;caster.FHashiramaVfxHit=false;
    lastSlot=slot;label.text="Hashirama video reconstruction | "+clipNames[index]+" | camp "+side;
    report("CASE "+skills[index]+" camp="+side);
   }
   var frame:int=int((age-slots[slot])/40);var name:String=clipNames[index];
   caster.FFrameIndex=frame;
   if(frame<clips[name].images.length){renderRole(caster,name,frame,index==2);caster.UpdateHashiramaVfx();}
   else {caster.FSkillId=0;renderRole(caster,"idle",int(age/100)%clips.idle.images.length);}
   renderRole(victim,"idle",int(age/100)%clips.idle.images.length);
   var layerKey:String="LAYER-CHECK-"+slot;
   if(frame>=3 && !captured[layerKey]){
    captured[layerKey]=true;var fxCount:int=0;var fxHosts:Array=[battle];
    while(fxHosts.length){var fxHost:DisplayObjectContainer=fxHosts.pop() as DisplayObjectContainer;for(var fi:int=0;fi<fxHost.numChildren;fi++){var fx:DisplayObject=fxHost.getChildAt(fi);if(fx.name=="hashiramaSkillVfx")fxCount++;if(fx is DisplayObjectContainer)fxHosts.push(fx);}}
    var bound:int=(skills[index]==13121001 || skills[index]==13121002)?4:(skills[index]==13121004 || skills[index]==13121005 || skills[index]==13121008)?3:skills[index]==13121009?2:1;
    report((fxCount>bound?"ERROR overlapping layers ":"LAYERS_OK ")+"slot="+slot+" skill="+skills[index]+" count="+fxCount+" bound="+bound);
   }
   var hit:int=metadata[name].hitFrames!=null?int(metadata[name].hitFrames[0]):8;
   var hitKey:String="HIT-"+skills[index]+"-camp-"+side;if(frame>=hit && !captured[hitKey]){captured[hitKey]=true;saveFrame(hitKey);}
   var pose:String=frame>=hit+6?"impact":(frame>=int(hit*0.55)&&frame<hit?"cast":"");
   var captureKey:String="CASE-"+skills[index]+"-camp-"+side+"-"+pose;
   if(pose!=""&&!captured[captureKey]){captured[captureKey]=true;var captureStarted:int=getTimer();saveFrame(captureKey);readyAt+=getTimer()-captureStarted;}
   if(skills[index]==13121008){
    var phases:Array=[6,16,19,30,42];
    for each(var phase:int in phases){
     var phaseKey:String="SLAM-camp-"+side+"-frame-"+phase;
     if(frame>=phase&&!captured[phaseKey]){captured[phaseKey]=true;var poseStarted:int=getTimer();saveFrame(phaseKey);readyAt+=getTimer()-poseStarted;}
    }
   }
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
  public var FId:int=11120940;
  public var FSkillId:int=0;
  public var FIndex:int=1;
  public const TYPE_ACTIVE_ATTACK:int=1;
  public const TYPE_ACTIVE_SKILL:int=2;
  public var FFrameIndex:int=0;
  public var FHashiramaVfxStarted:Boolean=false;
  public var FHashiramaVfxHit:Boolean=false;
  public static var FHashiramaFxCache:Object={};
  public static var FHashiramaFxLoading:Object={};
  public var FBattleStage:Sprite;
  public var FTargets:Array=[];
  public var FResults:Array=[];
  public var Camp:int=0;
  public var Pos:int=6;
  public var actor:Bitmap=new Bitmap();

 public var FBitmap:Bitmap=actor;
 public var FCombatVfxSerial:uint=0;
 public var FHashiramaActiveVfx:Array=[];
 public static var FHashiramaNative:Object={};
 public function ProbeRole(){actor.smoothing=true;addChild(actor);}
 public function report(text:String):void{if(ExternalInterface.available)ExternalInterface.call("vfxProbe",text);}
      public static function HashiramaVfxManifest() : Object
      {
         return JSON.parse("{\"version\":6,\"frameRate\":25,\"frameMs\":40,\"atlases\":{\"thousand-hands-hq-v2-00\":{\"url\":\"/public/hashirama-vfx/extracted/thousand-hands-hq-v2-00.png\",\"columns\":4,\"rows\":7,\"frameCount\":28},\"thousand-hands-hq-v2-01\":{\"url\":\"/public/hashirama-vfx/extracted/thousand-hands-hq-v2-01.png\",\"columns\":4,\"rows\":7,\"frameCount\":28},\"thousand-hands-hq-v2-02\":{\"url\":\"/public/hashirama-vfx/extracted/thousand-hands-hq-v2-02.png\",\"columns\":4,\"rows\":7,\"frameCount\":28},\"thousand-hands-hq-v2-03\":{\"url\":\"/public/hashirama-vfx/extracted/thousand-hands-hq-v2-03.png\",\"columns\":4,\"rows\":7,\"frameCount\":28},\"thousand-hands-hq-v2-04\":{\"url\":\"/public/hashirama-vfx/extracted/thousand-hands-hq-v2-04.png\",\"columns\":4,\"rows\":7,\"frameCount\":28},\"thousand-hands-hq-v2-05\":{\"url\":\"/public/hashirama-vfx/extracted/thousand-hands-hq-v2-05.png\",\"columns\":4,\"rows\":7,\"frameCount\":28},\"thousand-hands-hq-v2-06\":{\"url\":\"/public/hashirama-vfx/extracted/thousand-hands-hq-v2-06.png\",\"columns\":4,\"rows\":5,\"frameCount\":19},\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanbangpaizhishu-364-00.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanbangpaizhishu-364-01\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanbangpaizhishu-364-01.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanbangpaizhishu-364-02\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanbangpaizhishu-364-02.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanbangpaizhishu-364-03\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanbangpaizhishu-364-03.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanbangpaizhishu-364-04\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanbangpaizhishu-364-04.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanbangpaizhishu-364-05\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanbangpaizhishu-364-05.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanbangpaizhishu-364-06\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanbangpaizhishu-364-06.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanbangpaizhishu-364-07\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanbangpaizhishu-364-07.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanbangpaizhishu-364-08\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanbangpaizhishu-364-08.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanbangpaizhishu-364-09\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanbangpaizhishu-364-09.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanbangpaizhishu-364-10\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanbangpaizhishu-364-10.png\",\"columns\":2,\"rows\":1,\"frameCount\":1},\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanbangpaizhishu-54-00.png\",\"columns\":2,\"rows\":5,\"frameCount\":10},\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanbangpaizhishu-54-01.png\",\"columns\":2,\"rows\":5,\"frameCount\":10},\"quality-v1-Zhujianzhongyanbangpaizhishu-54-02\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanbangpaizhishu-54-02.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-128-00.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-01\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-128-01.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-02\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-128-02.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-03\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-128-03.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-04\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-128-04.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-05\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-128-05.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-06\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-128-06.png\",\"columns\":2,\"rows\":3,\"frameCount\":5},\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-281-00.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-01\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-281-01.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-02\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-281-02.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-03\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-281-03.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-04\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-281-04.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-05\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-281-05.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-06\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-281-06.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-07\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-281-07.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-08\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-281-08.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-09\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-281-09.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-10\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-281-10.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-11\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-281-11.png\",\"columns\":2,\"rows\":1,\"frameCount\":2},\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-170-00.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-170-01\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-170-01.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-170-02\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-170-02.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-170-03\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-170-03.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-170-04\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-170-04.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-170-05\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-170-05.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-170-06\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-170-06.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-170-07\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-170-07.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-170-08\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-170-08.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-170-09\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-170-09.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-170-10\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-170-10.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-170-11\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-170-11.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-170-12\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-170-12.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-00.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-01\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-01.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-02\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-02.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-03\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-03.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-04\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-04.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-05\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-05.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-06\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-06.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-07\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-07.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-08\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-08.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-09\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-09.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-10\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-10.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-11\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-11.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-12\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-12.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-13\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-13.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-14\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-14.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-15\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-15.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-16\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-16.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-17\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-17.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-18\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-18.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-19\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-19.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-20\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-20.png\",\"columns\":2,\"rows\":2,\"frameCount\":3},\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-01\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-01.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanshujiejiangdan-139-00.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanshujiejiangdan-139-01\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanshujiejiangdan-139-01.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanshujiejiangdan-139-02\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanshujiejiangdan-139-02.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanshujiejiangdan-139-03\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanshujiejiangdan-139-03.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanshujiejiangdan-139-04\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanshujiejiangdan-139-04.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanshujiejiangdan-139-05\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanshujiejiangdan-139-05.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanshujiejiangdan-139-06\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanshujiejiangdan-139-06.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanshujiejiangdan-139-07\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanshujiejiangdan-139-07.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanshujiejiangdan-139-08\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanshujiejiangdan-139-08.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanshujiejiangdan-139-09\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanshujiejiangdan-139-09.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanshujiejiangdan-139-10\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanshujiejiangdan-139-10.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanshujiejiangdan-80-00.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanshujiejiangdan-80-01\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanshujiejiangdan-80-01.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanshujiejiangdan-80-02\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanshujiejiangdan-80-02.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanshujiejiangdan-80-03\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanshujiejiangdan-80-03.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanshujiejiangdan-80-04\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanshujiejiangdan-80-04.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanshujiejiangdan-80-05\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanshujiejiangdan-80-05.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanshujiejiangdan-80-06\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanshujiejiangdan-80-06.png\",\"columns\":2,\"rows\":3,\"frameCount\":6}},\"clips\":{\"Zhujianzhongyanbangpaizhishu-364\":{\"atlas\":\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\",\"timeline\":[0,0,0,0,0,0,0,0,0,0,1,2,3,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,3,4,5,0,1,2,3,4,5,0,0],\"pivot\":[0.4364342774146695,0.7023794808405438],\"renderScale\":0.5205519244734931,\"width\":1024,\"height\":602,\"source\":\"battle\\\\effect\\\\Zhujianzhongyanbangpaizhishu.swf\",\"sourceFrames\":71,\"uniqueFrames\":61,\"frameAtlases\":[\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-02\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-02\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-02\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-02\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-02\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-02\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-03\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-03\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-03\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-03\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-03\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-03\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-04\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-04\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-04\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-04\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-04\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-04\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-04\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-05\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-05\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-05\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-05\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-05\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-05\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-06\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-06\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-06\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-06\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-06\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-06\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-07\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-07\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-07\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-07\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-07\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-07\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-08\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-08\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-08\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-08\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-08\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-08\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-08\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-09\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-09\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-09\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-09\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-09\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-09\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-10\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\"],\"qualitySourceZoom\":0.7},\"Zhujianzhongyanbangpaizhishu-54\":{\"atlas\":\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"timeline\":[0,0,0,0,0,0,0,0,0,0,1,2,3,3,4,5,6,7,8,9,0,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6,7,8,8,9,0,1,2,3,0,0,0,0,0],\"pivot\":[0.5346039035591275,0.49717213114754105],\"renderScale\":0.7,\"width\":871,\"height\":366,\"source\":\"battle\\\\effect\\\\Zhujianzhongyanbangpaizhishu.swf\",\"sourceFrames\":71,\"uniqueFrames\":24,\"frameAtlases\":[\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-02\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-02\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-02\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-02\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\"],\"qualitySourceZoom\":0.7},\"Zhujianzhongyanhuashujiejianglin-128\":{\"atlas\":\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,3,4,5,0,1,2,3,4,5,0,1,2,3,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],\"pivot\":[0.3562900188323917,0.47578518518518514],\"renderScale\":0.3374764595103578,\"width\":1024,\"height\":651,\"source\":\"battle\\\\effect\\\\Zhujianzhongyanhuashujiejianglin.swf\",\"sourceFrames\":101,\"uniqueFrames\":41,\"frameAtlases\":[\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-01\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-01\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-01\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-01\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-01\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-01\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-02\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-02\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-02\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-02\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-02\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-02\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-03\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-03\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-03\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-03\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-03\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-03\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-04\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-04\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-04\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-04\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-04\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-04\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-04\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-05\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-05\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-05\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-05\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-05\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-05\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-06\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-06\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-06\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-06\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-06\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\"],\"qualitySourceZoom\":0.35},\"Zhujianzhongyanhuashujiejianglin-281\":{\"atlas\":\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,4,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,0,0],\"pivot\":[0.5783964646464645,0.41012128325508596],\"renderScale\":0.35,\"width\":990,\"height\":639,\"source\":\"battle\\\\effect\\\\Zhujianzhongyanhuashujiejianglin.swf\",\"sourceFrames\":101,\"uniqueFrames\":68,\"frameAtlases\":[\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-01\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-01\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-01\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-01\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-01\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-01\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-02\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-02\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-02\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-02\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-02\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-02\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-03\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-03\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-03\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-03\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-03\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-03\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-04\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-04\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-04\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-04\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-04\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-04\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-04\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-05\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-05\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-05\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-05\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-05\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-05\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-06\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-06\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-06\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-06\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-06\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-06\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-07\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-07\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-07\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-07\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-07\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-07\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-08\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-08\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-08\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-08\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-08\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-08\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-08\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-09\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-09\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-09\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-09\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-09\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-09\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-10\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-10\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-10\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-10\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-10\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-10\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-11\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-11\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\"],\"qualitySourceZoom\":0.35},\"Zhujianzhongyanmingshenfenglong-170\":{\"atlas\":\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,0,1,2,3,0,1,2,3,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,3,0,1,2,3,3,3,3,3,0,1,2,3,0,1,2,3,0,1,2,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],\"pivot\":[0.007564858490566036,0.8143455497382198],\"renderScale\":0.6999999999999998,\"width\":848,\"height\":764,\"source\":\"battle\\\\effect\\\\Zhujianzhongyanmingshenfenglong.swf\",\"sourceFrames\":131,\"uniqueFrames\":52,\"frameAtlases\":[\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-02\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-02\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-02\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-02\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-02\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-03\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-03\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-03\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-03\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-04\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-04\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-04\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-04\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-05\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-05\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-05\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-05\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-06\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-06\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-06\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-06\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-07\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-07\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-07\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-07\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-08\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-08\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-08\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-08\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-08\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-09\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-09\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-09\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-09\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-09\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-09\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-09\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-09\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-10\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-10\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-10\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-10\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-11\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-11\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-11\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-11\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-12\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-12\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-12\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-12\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\"],\"qualitySourceZoom\":0.7},\"Zhujianzhongyanmingshenfenglong-688\":{\"atlas\":\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"timeline\":[0,0,0,0,0,0,0,0,1,2,3,0,1,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,1,2,3,0,1,2,3,0,1,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],\"pivot\":[0.20673220338983048,0.6171563088512241],\"renderScale\":0.4859661016949152,\"width\":1024,\"height\":737,\"source\":\"battle\\\\effect\\\\Zhujianzhongyanmingshenfenglong.swf\",\"sourceFrames\":131,\"uniqueFrames\":83,\"frameAtlases\":[\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-02\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-02\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-02\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-02\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-03\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-03\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-03\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-03\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-04\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-04\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-04\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-04\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-02\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-02\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-02\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-02\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-03\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-03\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-03\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-03\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-03\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-04\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-04\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-04\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-04\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-05\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-05\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-05\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-05\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-06\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-06\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-06\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-06\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-07\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-07\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-07\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-07\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-08\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-08\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-08\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-08\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-08\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-09\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-09\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-09\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-09\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-10\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-10\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-10\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-10\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-11\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-11\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-11\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-11\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-12\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-12\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-12\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-12\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-13\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-13\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-13\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-13\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-14\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-14\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-14\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-14\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-14\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-15\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-15\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-15\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-15\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-16\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-16\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-16\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-16\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-17\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-17\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-17\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-17\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-18\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-18\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-18\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-18\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-19\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-19\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-19\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-19\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-20\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-20\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-20\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\"],\"qualitySourceZoom\":0.7},\"Zhujianzhongyanmingshenfenglong_texie-272\":{\"atlas\":\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"timeline\":[0,0,0,0,0,0,0,0,0,1,2,3,3,3,4,5,5,0,1,2,2,3,5,5,0,1,2,2,3,5,5,0,1,2,2,3,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],\"pivot\":[0.5,0.5],\"renderScale\":1,\"width\":1024,\"height\":576,\"source\":\"battle\\\\effect\\\\Zhujianzhongyanmingshenfenglong_texie.swf\",\"sourceFrames\":62,\"uniqueFrames\":10,\"frameAtlases\":[\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\"],\"qualitySourceZoom\":0.35,\"cinematic\":true,\"portraitSourceResolution\":[1920,1080]},\"Zhujianzhongyanshujiejiangdan-139\":{\"atlas\":\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,0,1,2,3,0,1,2,3,0,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,0,1,2,3,0,1,2,3,0],\"pivot\":[0.4461380772855796,0.4423536960985627],\"renderScale\":0.2761074458058435,\"width\":837,\"height\":768,\"source\":\"battle\\\\effect\\\\Zhujianzhongyanshujiejiangdan.swf\",\"sourceFrames\":69,\"uniqueFrames\":44,\"frameAtlases\":[\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-01\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-01\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-01\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-01\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-02\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-02\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-02\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-02\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-03\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-03\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-03\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-03\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-03\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-04\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-04\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-04\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-04\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-05\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-05\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-05\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-05\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-06\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-06\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-06\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-06\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-07\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-07\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-07\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-07\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-08\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-08\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-08\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-08\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-09\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-09\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-09\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-09\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-09\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-10\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-10\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-10\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-10\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\"],\"qualitySourceZoom\":0.35},\"Zhujianzhongyanshujiejiangdan-80\":{\"atlas\":\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,4,5,0,1,2,3,4,5,0,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,0,1,2,3,4,5,0,0,0],\"pivot\":[0.31678175403225806,0.5209835355285962],\"renderScale\":0.35,\"width\":992,\"height\":577,\"source\":\"battle\\\\effect\\\\Zhujianzhongyanshujiejiangdan.swf\",\"sourceFrames\":69,\"uniqueFrames\":42,\"frameAtlases\":[\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-01\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-01\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-01\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-01\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-01\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-01\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-02\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-02\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-02\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-02\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-02\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-02\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-02\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-03\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-03\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-03\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-03\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-03\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-03\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-04\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-04\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-04\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-04\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-04\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-04\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-05\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-05\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-05\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-05\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-05\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-05\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-06\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-06\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-06\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-06\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-06\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-06\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-06\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\"],\"qualitySourceZoom\":0.35},\"Hashirama-thousand-hands-cinematic\":{\"atlas\":\"thousand-hands-hq-v2-00\",\"frameAtlases\":[\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\"],\"timeline\":[0,0,0,0,0,0,0,0,0,1,2,3,4,4,5,6,7,8,8,9,10,7,8,9,9,10,7,7,8,9,9,10,7,8,8,9,10,7,7,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,0,1,2,3,4,5,6,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,0,1,2,2,3,4,0,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,25,26,27,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,21,22,23,24,25,26,27,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,17,18,19,20,21,22,23,24,25,26,27,0,1,2,3,4,5,6,7,8,9,10,11,12,13,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,0,1,2,3,4,5,6,7,8,9,9,10,11,12,13,14,15,16,17,18,0,0],\"pivot\":[0.5,0.5],\"width\":1024,\"height\":576,\"renderScale\":1,\"sourceFrames\":216,\"uniqueFrames\":187,\"cinematic\":true,\"source\":\"Original dingshanghuafo + texie SWF timelines\",\"camera\":[-170,-245,350,47.5],\"closeupCamera\":[240,40,1680,850],\"portraitSourceResolution\":[1920,1080],\"portraitFrames\":{\"1\":null,\"2\":null,\"3\":null,\"4\":null,\"5\":null,\"6\":null,\"7\":null,\"8\":null,\"9\":null,\"10\":null,\"11\":null,\"12\":\"3\",\"13\":\"41\",\"14\":\"61\",\"15\":\"81\",\"16\":\"100\",\"17\":\"117\",\"18\":\"117\",\"19\":\"146\",\"20\":\"162\",\"21\":\"100\",\"22\":\"117\",\"23\":\"146\",\"24\":\"146\",\"25\":\"162\",\"26\":\"100\",\"27\":\"100\",\"28\":\"117\",\"29\":\"146\",\"30\":\"146\",\"31\":\"162\",\"32\":\"100\",\"33\":\"117\",\"34\":\"117\",\"35\":\"146\",\"36\":\"162\",\"37\":\"100\",\"38\":null,\"39\":null,\"40\":null,\"41\":null,\"42\":null,\"43\":null,\"44\":null,\"45\":null,\"46\":null,\"47\":null,\"48\":null,\"49\":null,\"50\":null,\"51\":null,\"52\":null,\"53\":null,\"54\":null,\"55\":null,\"56\":null,\"57\":null,\"58\":null,\"59\":null,\"60\":null,\"61\":null,\"62\":null,\"63\":null,\"64\":null,\"65\":null,\"66\":null,\"67\":null,\"68\":null,\"69\":null,\"70\":null,\"71\":null,\"72\":null,\"73\":null,\"74\":null,\"75\":null,\"76\":null,\"77\":null,\"78\":null,\"79\":null,\"80\":null,\"81\":null,\"82\":null,\"83\":null,\"84\":null,\"85\":null,\"86\":null,\"87\":null,\"88\":null,\"89\":null,\"90\":null,\"91\":null,\"92\":null,\"93\":null,\"94\":null,\"95\":null,\"96\":null,\"97\":null,\"98\":null,\"99\":null,\"100\":null}}},\"effects\":{\"Zhujianzhongyanbangpaizhishu\":[\"Zhujianzhongyanbangpaizhishu-364\",\"Zhujianzhongyanbangpaizhishu-54\"],\"Zhujianzhongyanhuashujiejianglin\":[\"Zhujianzhongyanhuashujiejianglin-128\",\"Zhujianzhongyanhuashujiejianglin-281\"],\"Zhujianzhongyanmingshenfenglong\":[\"Zhujianzhongyanmingshenfenglong-170\",\"Zhujianzhongyanmingshenfenglong-688\"],\"Zhujianzhongyanmingshenfenglong_texie\":[\"Zhujianzhongyanmingshenfenglong_texie-272\"],\"Zhujianzhongyanshujiejiangdan\":[\"Zhujianzhongyanshujiejiangdan-139\",\"Zhujianzhongyanshujiejiangdan-80\"],\"Hashirama-thousand-hands-cinematic\":[\"Hashirama-thousand-hands-cinematic\"]},\"effectAnchors\":{\"Zhujianzhongyanmingshenfenglong\":[652.9390066964287,214.32729569692464],\"Zhujianzhongyanbangpaizhishu\":[-5.728571428571419,95.59285714285714],\"Zhujianzhongyanshujiejiangdan\":[347.98927291346683,1156.3337615343178],\"Zhujianzhongyanhuashujiejianglin\":[310.7473214285716,960.8487801339287]}}");
      }
      public static function PreloadHashiramaNative() : void
      {
         for each(var effect:String in ["Zhujianzhongyanmingshenfenglong","Zhujianzhongyanmingshenfenglong_texie","Zhujianzhongyandingshanghuafo","Zhujianzhongyandingshanghuafo_texie","Zhujianzhongyanbangpaizhishu","Zhujianzhongyanhuashujiejianglin"])
         {
            LoadHashiramaNative(effect);
         }
      }
      public static function LoadHashiramaNative(effect:String) : void
      {
         var state:Object;
         var loader:Loader;
         if(FHashiramaNative[effect] != null)
         {
            return;
         }
         state = {};
         FHashiramaNative[effect] = state;
         loader = new Loader();
         state.loader = loader;
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(event:Event):void
         {
            state.domain = loader.contentLoaderInfo.applicationDomain;
            if(loader.content is MovieClip)
            {
               MovieClip(loader.content).stop();
            }
         });
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(event:IOErrorEvent):void
         {
            delete FHashiramaNative[effect];
         });
         loader.load(new URLRequest("/public/hashirama-vfx/native/" + effect + ".swf"),new LoaderContext(false,new ApplicationDomain()));
      }
      public function HashiramaNativeLayer(effect:String,symbol:String,host:DisplayObjectContainer,point:Point,width:Number,height:Number,delay:int,mirrored:Boolean,screen:Boolean,behind:Boolean=false) : void {
         LoadHashiramaNative(effect);
         var caster:ProbeRole=this;var layer:Sprite=new Sprite();layer.name="hashiramaSkillVfx";layer.mouseEnabled=false;layer.mouseChildren=false;
         var sourceKey:String=effect+"-"+(symbol=="shang"?(effect=="Zhujianzhongyanbangpaizhishu"?"364":effect=="Zhujianzhongyanhuashujiejianglin"?"281":"688"):(effect=="Zhujianzhongyanbangpaizhishu"?"54":effect=="Zhujianzhongyanhuashujiejianglin"?"128":"170"));
         var meta:Object=screen?null:HashiramaVfxManifest().clips[sourceKey];var sourceWidth:Number=meta!=null?Number(meta.width)/Number(meta.renderScale):0;
         if(behind)host.addChildAt(layer,0);else host.addChild(layer);
         FHashiramaActiveVfx.push(layer);
         var clip:MovieClip=null;var serial:uint=FCombatVfxSerial;var skill:uint=FSkillId;var start:int=Math.max(0,FFrameIndex);var tick:Function;var clear:Function;var cleaned:Boolean=false;var bounds:Rectangle=null;
         clear=function(event:Event=null):void{if(cleaned || event!=null&&event.target!=layer)return;cleaned=true;layer.removeEventListener(Event.ENTER_FRAME,tick);layer.removeEventListener(Event.REMOVED_FROM_STAGE,clear);if(clip!=null)clip.stop();if(layer.parent!=null)layer.parent.removeChild(layer);};
         tick=function(event:Event=null):void{
            if(host.stage==null || caster.stage==null || caster.FCombatVfxSerial!=serial || caster.FSkillId!=skill || (caster.FIndex!=TYPE_ACTIVE_ATTACK&&caster.FIndex!=TYPE_ACTIVE_SKILL)){clear();return;}
            var state:Object=FHashiramaNative[effect];if(state==null || state.domain==null){layer.visible=false;return;}
            if(clip==null){if(!state.domain.hasDefinition(symbol)){clear();return;}var type:Class=state.domain.getDefinition(symbol) as Class;clip=new type() as MovieClip;clip.stop();layer.addChild(clip);}
            var elapsed:int=(Math.max(0,caster.FFrameIndex)-start)*40-delay;
            if(elapsed<0){layer.visible=false;return;}
            var frame:int=Math.round(elapsed*24/1000)+1;
            if(frame>clip.totalFrames){clear();return;}
            clip.gotoAndStop(frame);layer.visible=true;
            var field:Boolean=effect=="Zhujianzhongyanhuashujiejianglin";
            if(screen || field){
               if(bounds==null || bounds.width<=1 || bounds.height<=1){var at:int=Math.min(clip.totalFrames,Math.max(8,int(clip.totalFrames*(field ? 0.5 : 0.25))));var previous:int=frame;clip.gotoAndStop(at);bounds=clip.getBounds(clip);clip.gotoAndStop(previous);}
               if(bounds==null || bounds.width<=1 || bounds.height<=1)bounds=new Rectangle(-500,-300,1000,600);
               var tl:Point=host.globalToLocal(stage.localToGlobal(new Point()));var br:Point=host.globalToLocal(stage.localToGlobal(new Point(stage.stageWidth,stage.stageHeight)));
               var fit:Number=field?Math.min((br.x-tl.x-48)/bounds.width,((br.y-tl.y)*.68)/bounds.height):Math.max((br.x-tl.x)/bounds.width,(br.y-tl.y)/bounds.height);
               if(effect=="Zhujianzhongyanmingshenfenglong_texie")fit*=1.65;
               var facing:Number=effect.indexOf("Zhujianzhongyandingshanghuafo")==0&&caster.scaleX<0?-1:1;
               clip.scaleY=fit;clip.scaleX=fit*facing;clip.x=(field?(tl.x+br.x)*.5:point.x)-(bounds.x+bounds.width*.5)*fit*facing;clip.y=(field?tl.y+(br.y-tl.y)*.90:point.y)-(field?bounds.y+bounds.height:bounds.y+bounds.height*.5)*fit;
               layer.scrollRect=new Rectangle(tl.x,tl.y,br.x-tl.x,br.y-tl.y);
            }else{
               var scale:Number=Math.min(1.6,Math.max(.15,width/Math.max(1,sourceWidth>0?sourceWidth:clip.width)));
               clip.scaleX=clip.scaleY=scale;clip.x=0;clip.y=0;layer.x=point.x;layer.y=point.y+(effect=="Zhujianzhongyanmingshenfenglong"?95:0);layer.scaleX=mirrored?-1:1;
            }
         };
         layer.addEventListener(Event.ENTER_FRAME,tick);layer.addEventListener(Event.REMOVED_FROM_STAGE,clear);tick();
      }
      public static function PreloadHashiramaVfx() : void
      {
         var manifest:Object = HashiramaVfxManifest();
         for each(var effect:String in ["Zhujianzhongyanhuashujiejianglin","Zhujianzhongyanmingshenfenglong","Zhujianzhongyanmingshenfenglong_texie"])
         {
            for each(var name:String in manifest.effects[effect])
            {
               var clip:Object = manifest.clips[name];
               LoadHashiramaVfxAtlas(String(clip.atlas),manifest.atlases[clip.atlas]);if(ExternalInterface.available)ExternalInterface.call("vfxProbe","VFX_ASSET "+name);
            }
         }
      }
      public static function LoadHashiramaVfxAtlas(name:String, meta:Object) : void
      {
         var loader:Loader;
         var complete:Function;
         var failed:Function;
         var release:Function;
         FHashiramaFxLoading["_age_" + name] = getTimer();
         if(FHashiramaFxCache[name] != null || FHashiramaFxLoading[name])
         {
            return;
         }
         FHashiramaFxLoading[name] = true;
         loader = new Loader();
         release = function():void
         {
            loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,complete);
            loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,failed);
            loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,failed);
            delete FHashiramaFxLoading[name];
         };
         failed = function(event:Event):void
         {
            release();
            loader.unload();
         };
         complete = function(event:Event):void
         {
            release();
            var source:Bitmap = loader.content as Bitmap;
            if(source == null)
            {
               loader.unload();
               return;
            }
            var frames:Array = [];
            var w:int = int(source.bitmapData.width / int(meta.columns));
            var h:int = int(source.bitmapData.height / int(meta.rows));
            var i:int = 0;
            while(i < (meta.frameCount != null ? int(meta.frameCount) : int(meta.columns) * int(meta.rows)))
            {
               var cell:BitmapData = new BitmapData(w,h,true,0);
               cell.copyPixels(source.bitmapData,new Rectangle(i % int(meta.columns) * w,int(i / int(meta.columns)) * h,w,h),new Point());
               frames.push(cell);
               i++;
            }
            FHashiramaFxCache[name] = frames;if(ExternalInterface.available)ExternalInterface.call("vfxProbe","ATLAS "+name);
            TrimHashiramaVfxCache(name);
            loader.unload();
         };
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,complete);
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,failed);
         loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,failed);
         loader.load(new URLRequest(String(meta.url)));
      }
      public static function TrimHashiramaVfxCache(keep:String) : void
      {
         var pixels:Number = 0;
         var entries:int = 0;
         for(var key:String in FHashiramaFxCache)
         {
            var frames:Array = FHashiramaFxCache[key] as Array;
            if(frames != null && frames.length > 0)
            {
               pixels += frames.length * BitmapData(frames[0]).width * BitmapData(frames[0]).height;
               entries++;
            }
         }
         while(pixels > 40000000 && entries > 2)
         {
            var oldest:String = null;
            var age:Number = Number.MAX_VALUE;
            for(key in FHashiramaFxCache)
            {
               if(key != keep && Number(FHashiramaFxLoading["_age_" + key]) < age)
               {
                  oldest = key;
                  age = Number(FHashiramaFxLoading["_age_" + key]);
               }
            }
            if(oldest == null)
            {
               break;
            }
            frames = FHashiramaFxCache[oldest] as Array;
            pixels -= frames.length * BitmapData(frames[0]).width * BitmapData(frames[0]).height;
            delete FHashiramaFxCache[oldest];
            delete FHashiramaFxLoading["_age_" + oldest];
            entries--;
         }
      }
      public function PlayHashiramaVfxAsset(name:String, host:DisplayObjectContainer, point:Point, width:Number, height:Number, delay:int = 0, mirrored:Boolean = false, follow:Boolean = false, behind:Boolean = false, angle:Number = 0) : void
      {
         if(host == null || host.stage == null)
         {
            return;
         }
         if(name == "Hashirama-thousand-hands-cinematic")
         {
            HashiramaNativeLayer("Zhujianzhongyandingshanghuafo","xia",host,point,width,height,delay,false,true,true);
            HashiramaNativeLayer("Zhujianzhongyandingshanghuafo","shang",host,point,width,height,delay,false,true);
            HashiramaNativeLayer("Zhujianzhongyandingshanghuafo_texie","texie",host,point,width,height,delay,false,true);
            return;
         }
         var cut:int = name.lastIndexOf("-");
         if(cut < 0)
         {
            return;
         }
         var effect:String = name.substring(0,cut);
         var sprite:int = int(name.substring(cut + 1));
         var symbol:String = effect.indexOf("_texie") >= 0 ? "texie" : (sprite == 364 || sprite == 281 || sprite == 688 ? "shang" : "xia");
         HashiramaNativeLayer(effect,symbol,host,point,width,height,delay,mirrored,effect.indexOf("_texie") >= 0,behind && FSkillId != 13121009);
      }
      public function UpdateHashiramaVfx() : void
      {
         if(FId != 11120940 || FSkillId < 13121001 || FSkillId > 13121010 || FIndex != TYPE_ACTIVE_ATTACK && FIndex != TYPE_ACTIVE_SKILL || FHashiramaVfxStarted)
         {
            return;
         }
         FHashiramaVfxStarted = true;
         ShowHashiramaVfx(FSkillId);
      }
      public function ShowHashiramaVfx(skill:int) : void
      {
         for each(var prior:Sprite in FHashiramaActiveVfx)
         {
            if(prior.parent != null)
            {
               prior.parent.removeChild(prior);
            }
         }
         FHashiramaActiveVfx = [];
         var host:DisplayObjectContainer = FBattleStage;
         if(host == null || host.stage == null)
         {
            return;
         }
         var origin:Point = host.globalToLocal(localToGlobal(new Point()));
         var viewportTL:Point = host.globalToLocal(stage.localToGlobal(new Point(0,0)));
         var viewportBR:Point = host.globalToLocal(stage.localToGlobal(new Point(stage.stageWidth,stage.stageHeight)));
         var unit:Number = Math.abs(viewportBR.x - viewportTL.x) / 1250;
         var center:Point = new Point();
         var count:int = 0;
         var minX:Number = 100000;
         var maxX:Number = -100000;
         var minY:Number = 100000;
         var maxY:Number = -100000;
         var seen:Object = {};
         if(FTargets != null && FResults != null)
         {
            var i:int = 0;
            while(i < FTargets.length && i < FResults.length)
            {
               var enemy:ProbeRole = FTargets[i];
               if(!(enemy == null || enemy == this || enemy.Camp == Camp || FResults[i].CMD != TTargetInfo.CMD_ATTACK || FResults[i].ResultInfo.HurtHp < 0))
               {
                  var key:String = enemy.Camp + "_" + enemy.Pos;
                  if(!seen[key])
                  {
                     seen[key] = true;
                     var point:Point = host.globalToLocal(enemy.localToGlobal(new Point()));
                     if(primary == null)
                     {
                        var primary:Point = point.clone();
                     }
                     center.x += point.x;
                     center.y += point.y;
                     count++;
                     minX = Math.min(minX,point.x);
                     maxX = Math.max(maxX,point.x);
                     minY = Math.min(minY,point.y);
                     maxY = Math.max(maxY,point.y);
                  }
               }
               i++;
            }
         }
         if(count > 0)
         {
            center.x /= count;
            center.y /= count;
         }
         else
         {
            center = origin.clone();
         }
         var close:Boolean = skill == 13121003 || skill == 13121004 || skill == 13121005 || skill == 13121006 || skill == 13121007;
         if(close && primary != null)
         {
            center = primary.clone();
         }
         var effects:Array = skill == 13121001 ? ["Zhujianzhongyanmingshenfenglong_texie","Zhujianzhongyanmingshenfenglong"] : (skill == 13121002 ? ["Hashirama-thousand-hands-cinematic"] : (skill == 13121004 || skill == 13121005 ? ["Zhujianzhongyanbangpaizhishu"] : (skill == 13121009 ? ["Zhujianzhongyanhuashujiejianglin"] : [])));
         var manifest:Object = HashiramaVfxManifest();
         for each(var effect:String in effects)
         {
            var layers:Array = manifest.effects[effect] as Array;
            if(layers != null)
            {
               var left:Number = 100000;
               var right:Number = -100000;
               var top:Number = 100000;
               var bottom:Number = -100000;
               for each(var name:String in layers)
               {
                  var bounds:Object = manifest.clips[name];
                  var bw:Number = bounds.width / bounds.renderScale;
                  var bh:Number = bounds.height / bounds.renderScale;
                  left = Math.min(left,-bounds.pivot[0] * bw);
                  right = Math.max(right,(1 - bounds.pivot[0]) * bw);
                  top = Math.min(top,-bounds.pivot[1] * bh);
                  bottom = Math.max(bottom,(1 - bounds.pivot[1]) * bh);
               }
               var cinematic:Boolean = effect == "Hashirama-thousand-hands-cinematic" || manifest.clips[String(layers[0])].cinematic == true;
               var screen:Boolean = effect.indexOf("texie") >= 0 || cinematic;
               var limit:Number = (screen ? 1250 : (skill == 13121002 ? 1400 : (skill == 13121001 ? 1300 : (skill == 13121009 ? 1450 : (skill == 13121008 ? 1250 : 1000))))) * unit;
               if(count > 1 && !screen)
               {
                  limit = Math.max(limit,maxX - minX + 750,maxY - minY + 700);
               }
               var fit:Number = limit / Math.max(1,right - left,bottom - top);
               if(skill == 13121009)
               {
                  var viewTop:Point = host.globalToLocal(stage.localToGlobal(new Point(24,stage.stageHeight * 0.22)));
                  var viewBottom:Point = host.globalToLocal(stage.localToGlobal(new Point(stage.stageWidth - 24,stage.stageHeight * 0.9)));
                  var forestBase:Point = new Point((viewTop.x + viewBottom.x) / 2,viewBottom.y);
                  fit = Math.min(Math.abs(viewBottom.x - viewTop.x) / Math.max(1,right - left),Math.abs(viewBottom.y - viewTop.y) / Math.max(1,bottom - top));
               }
               for each(name in layers)
               {
                  var clip:Object = manifest.clips[name];
                  var at:Point = screen ? host.globalToLocal(stage.localToGlobal(new Point(stage.stageWidth / 2,stage.stageHeight / 2))) : (skill == 13121009 ? forestBase.clone() : center.clone());
                  var w:Number = clip.width / clip.renderScale * fit;
                  var h:Number = clip.height / clip.renderScale * fit;
                  if(cinematic)
                  {
                     var screenTL:Point = host.globalToLocal(stage.localToGlobal(new Point(0,0)));
                     var screenBR:Point = host.globalToLocal(stage.localToGlobal(new Point(stage.stageWidth,stage.stageHeight)));
                     w = Math.abs(screenBR.x - screenTL.x);
                     h = Math.abs(screenBR.y - screenTL.y);
                  }
                  else if(screen)
                  {
                     w = 1250 * unit;
                     h = clip.height / clip.width * w;
                  }
                  else
                  {
                     var anchor:Array = skill == 13121009 ? [(left + right) / 2,bottom] : manifest.effectAnchors[effect] as Array;
                     at.x -= Number(anchor[0]) * fit * (scaleX < 0 ? -1 : 1);
                     at.y -= Number(anchor[1]) * fit;
                  }
                  PlayHashiramaVfxAsset(name,host,at,w,h,0,screen ? false : scaleX < 0,false,false);
               }
            }
         }
         var hit:Object = {
            "13121001":51,
            "13121002":93,
            "13121003":20,
            "13121004":20,
            "13121005":20,
            "13121006":9,
            "13121007":20,
            "13121008":19
         };
         if(hit[skill] != null && skill != 13121002)
         {
            ShowHashiramaImpact(new Point(center.x,center.y - 15 * unit),close ? 560 * unit : Math.max(1000 * unit,maxX - minX + 450 * unit),close ? 300 * unit : Math.max(440 * unit,maxY - minY + 260 * unit),int(hit[skill]) * 40);
         }
         if(skill == 13121010)
         {
            ShowHashiramaImpact(new Point(origin.x,origin.y - 10 * unit),560 * unit,280 * unit,0);
         }
      }
      public function HashiramaStrikePose(frame:Object) : void
      {
         if(FId != 11120940 || frame == null || FIndex != TYPE_ACTIVE_ATTACK && FIndex != TYPE_ACTIVE_SKILL)
         {
            return;
         }
         FBitmap.x = -frame.Pivot.X;
         FBitmap.y = -frame.Pivot.Y;
         if(FSkillId < 13121003 || FSkillId > 13121008 || FTargets == null || FResults == null)
         {
            return;
         }
         var i:int = 0;
         while(i < FTargets.length && i < FResults.length)
         {
            var enemy:ProbeRole = FTargets[i];
            if(!(enemy == null || enemy == this || enemy.Camp == Camp || FResults[i].CMD != TTargetInfo.CMD_ATTACK))
            {
               var point:Point = globalToLocal(enemy.localToGlobal(new Point()));
               var hit:Number = FSkillId == 13121006 ? 9 : 20;
               var duration:Number = FSkillId == 13121004 || FSkillId == 13121005 ? 86 : (FSkillId == 13121006 ? 35 : 53);
               var t:Number = Math.min(1,Math.max(0,FFrameIndex / Math.max(5,hit - 3)));
               var back:Number = Math.min(1,Math.max(0,(duration - FFrameIndex) / 15));
               var weight:Number = t * t * (3 - 2 * t) * back * back * (3 - 2 * back);
               var gap:Number = FSkillId == 13121008 ? 190 : (FSkillId == 13121004 || FSkillId == 13121005 ? 185 : (FSkillId == 13121007 ? 130 : 105));
               FBitmap.x += (point.x - gap) * weight;
               FBitmap.y += point.y * weight;
               return;
            }
            i++;
         }
      }
      public function ShowHashiramaImpact(point:Point, width:Number, height:Number, delay:int) : void
      {
         var layer:Sprite;
         var started:int;
         var caster:ProbeRole;
         var castSerial:uint;
         var castSkill:int;
         var castFrame:int;
         var animate:Function;
         var cleanup:Function;
         var host:DisplayObjectContainer = FBattleStage;
         if(host == null || host.stage == null)
         {
            return;
         }
         layer = new Sprite();
         layer.name = "hashiramaSkillVfx";
         FHashiramaActiveVfx.push(layer);
         layer.mouseEnabled = false;
         layer.mouseChildren = false;
         layer.x = point.x;
         layer.y = point.y;
         host.addChild(layer);
         caster = this;
         castSerial = FCombatVfxSerial;
         castSkill = FSkillId;
         castFrame = Math.max(0,FFrameIndex);
         started = getTimer() + delay;
         cleanup = function(event:Event = null):void
         {
            if(event != null && event.target != layer)
            {
               return;
            }
            layer.removeEventListener(Event.ENTER_FRAME,animate);
            layer.removeEventListener(Event.REMOVED_FROM_STAGE,cleanup);
            layer.graphics.clear();
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
            if(host.stage == null || elapsed >= 1200)
            {
               cleanup();
               return;
            }
            layer.visible = elapsed >= 0;
            if(elapsed < 0)
            {
               return;
            }
            var t:Number = elapsed / 1200;
            var g:Graphics = layer.graphics;
            g.clear();
            layer.alpha = Math.min(1,(elapsed + 40) / 100) * (1 - t);
            var ring:int = 0;
            while(ring < 3)
            {
               var scale:Number = 0.6 + t * 0.7 + ring * 0.13;
               var rw:Number = width * scale;
               var rh:Number = height * scale;
               g.lineStyle(9 - ring * 2,ring == 0 ? 14548898 : 6403380,0.85 - ring * 0.15);
               g.beginFill(4879649,ring == 0 ? 0.12 : 0);
               g.drawEllipse(-rw / 2,-rh / 2,rw,rh);
               g.endFill();
               ring++;
            }
            var ray:int = 0;
            while(ray < 16)
            {
               var a:Number = ray * Math.PI / 8;
               g.lineStyle(ray % 3 == 0 ? 5 : 2,ray % 2 == 0 ? 15914958 : 11523712,0.9);
               g.moveTo(Math.cos(a) * width * 0.15,Math.sin(a) * height * 0.15);
               g.lineTo(Math.cos(a + 0.035) * width * (0.38 + t * 0.16),Math.sin(a + 0.035) * height * (0.38 + t * 0.16));
               g.lineTo(Math.cos(a) * width * (0.55 + t * 0.2),Math.sin(a) * height * (0.55 + t * 0.2));
               ray++;
            }
         };
         layer.addEventListener(Event.ENTER_FRAME,animate);
         layer.addEventListener(Event.REMOVED_FROM_STAGE,cleanup);
      }
      public function ShowHashiramaStatusText(message:String, color:uint = 12186746) : void
      {
         var owner:ProbeRole;
         var key:String;
         var old:DisplayObject;
         var label:TextField;
         var started:int;
         var animate:Function;
         var cleanup:Function;
         var host:DisplayObjectContainer = parent;
         if(host == null || host.stage == null)
         {
            return;
         }
         owner = this;
         key = "hashiramaStatus_" + Camp + "_" + Pos + "_" + message;
         old = host.getChildByName(key);
         if(old != null)
         {
            host.removeChild(old);
         }
         label = new TextField();
         label.name = key;
         label.mouseEnabled = false;
         label.selectable = false;
         label.defaultTextFormat = new TextFormat("Arial",15,color,true,null,null,null,null,"center");
         label.width = 340;
         label.height = 30;
         label.text = message;
         label.filters = [new GlowFilter(526352,1,5,5,5)];
         host.addChild(label);
         started = int(getTimer());
         cleanup = function(event:Event = null):void
         {
            if(event != null && event.target != label)
            {
               return;
            }
            label.removeEventListener(Event.ENTER_FRAME,animate);
            label.removeEventListener(Event.REMOVED_FROM_STAGE,cleanup);
            if(label.parent != null)
            {
               label.parent.removeChild(label);
            }
         };
         animate = function(event:Event):void
         {
            var age:int = getTimer() - started;
            if(owner.parent != host || host.stage == null || age >= 3200)
            {
               cleanup();
               return;
            }
            var prefix:String = "hashiramaStatus_" + owner.Camp + "_" + owner.Pos + "_";
            var row:int = 0;
            var i:int = host.getChildIndex(label) + 1;
            while(i < host.numChildren)
            {
               if(host.getChildAt(i).name.indexOf(prefix) == 0)
               {
                  row++;
               }
               i++;
            }
            var anchor:Point = host.globalToLocal(owner.localToGlobal(new Point(0,-155)));
            label.x = anchor.x - 170;
            label.y = anchor.y - row * 27 - Math.min(12,age / 200);
            label.alpha = age < 2600 ? 1 : (3200 - age) / 600;
         };
         label.addEventListener(Event.ENTER_FRAME,animate);
         label.addEventListener(Event.REMOVED_FROM_STAGE,cleanup);
         animate(null);
      }
}
}
