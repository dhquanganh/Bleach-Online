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
  private var skills:Array=[13122001, 13122002, 13122003, 13122004, 13122005, 13122006, 13122007, 13122008, 13122009, 13122010, 13122011, 13122012, 0, 0];
  private var clipNames:Array=["mystery", "standard", "chase", "complete", "burst-mystery", "burst-standard", "burst-chase", "summon", "clone-counter", "reflection", "burst", "clone-counter", "entry", "dead"];
  private var metadata:Object={"idle":{"assets":[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51],"loop":true,"duration":40,"sourceAction":"C_idle","hitFrames":[26]},"run":{"assets":[52,53,54,55],"loop":true,"duration":40,"sourceAction":"C_run1_2","hitFrames":[2]},"hit":{"assets":[56,57,58,59,60,61,62,0],"loop":false,"duration":40,"sourceAction":"D_stand_behit1","hitFrames":[3],"returnFrame":7},"dead":{"assets":[63,64,65,66,67,68,69,70,71,72,73,73],"loop":false,"duration":40,"sourceAction":"C_dead","hitFrames":[5],"returnFrame":11},"entry":{"assets":[74,75,76,77,78,79,80,81,82,83,84,0],"loop":false,"duration":40,"sourceAction":"C_entry","hitFrames":[5],"returnFrame":11},"standard":{"assets":[85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,0],"loop":false,"duration":40,"sourceAction":"A_1hit","hitFrames":[14],"returnFrame":42},"burst-standard":{"assets":[127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,0],"loop":false,"duration":40,"sourceAction":"A_2hit","hitFrames":[17],"returnFrame":52},"mystery":{"assets":[179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,0],"loop":false,"duration":40,"sourceAction":"SP_skill11","hitFrames":[70,77,98,114],"returnFrame":164},"burst-mystery":{"assets":[343,344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360,361,362,363,364,365,366,367,368,369,370,371,372,373,374,375,376,377,378,379,380,381,382,383,384,385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,400,401,402,403,404,405,406,407,408,409,410,411,412,413,414,415,416,417,418,419,420,421,422,423,424,425,426,427,428,429,430,431,432,433,434,435,436,437,438,439,440,441,442,443,444,445,446,447,448,449,450,451,452,453,454,455,456,457,458,459,460,461,462,463,464,465,466,467,468,469,470,471,472,473,474,0],"loop":false,"duration":40,"sourceAction":"SP_skill7","hitFrames":[44,54,67,93],"returnFrame":132},"chase":{"assets":[475,476,477,478,479,480,481,482,483,484,485,486,487,488,489,490,491,492,493,494,495,496,497,498,499,500,501,502,503,504,505,506,507,508,509,510,511,512,513,514,515,516,517,518,519,520,521,0],"loop":false,"duration":40,"sourceAction":"SP_skill2","hitFrames":[17],"returnFrame":47},"burst-chase":{"assets":[522,523,524,525,526,527,528,529,530,531,532,533,534,535,536,537,538,539,540,541,542,543,544,545,546,547,548,549,550,551,552,553,554,555,556,557,558,559,560,561,562,563,564,565,566,567,568,0],"loop":false,"duration":40,"sourceAction":"SP_skill3","hitFrames":[17],"returnFrame":47},"complete":{"assets":[569,570,571,572,573,574,575,576,577,578,579,580,581,582,583,584,585,586,587,588,589,590,591,592,593,594,595,596,597,598,599,600,601,602,603,604,605,606,607,608,609,610,611,612,613,614,615,616,617,618,619,620,621,622,623,624,625,626,627,0],"loop":false,"duration":40,"sourceAction":"SP_skill6","hitFrames":[19,33],"returnFrame":59},"summon":{"assets":[628,629,630,631,632,633,634,635,636,637,638,639,640,641,642,643,644,645,646,647,648,649,650,651,0],"loop":false,"duration":40,"sourceAction":"SP_skill12","hitFrames":[6],"returnFrame":24},"clone-counter":{"assets":[652,653,654,655,656,657,658,659,660,661,662,663,664,665,666,667,668,669,670,671,672,673,674,675,676,677,678,679,680,681,682,683,684,685,686,687,688,689,690,691,692,693,694,695,696,697,698,699,700,701,702,703,704,705,706,707,708,0],"loop":false,"duration":40,"sourceAction":"SP_skill9","hitFrames":[17],"returnFrame":57},"reflection":{"assets":[709,710,711,712,713,714,715,716,717,718,719,720,721,722,723,724,725,726,727,728,729,730,731,732,733,734,735,736,737,738,739,740,741,742,743,744,745,0],"loop":false,"duration":40,"sourceAction":"SP_skill1","hitFrames":[8],"returnFrame":37},"burst":{"assets":[746,747,748,749,750,751,752,753,754,755,756,757,758,759,760,761,762,763,764,765,766,767,768,769,770,771,772,773,774,775,776,777,778,779,780,781,782,0],"loop":false,"duration":40,"sourceAction":"SP_skill5","hitFrames":[9],"returnFrame":37}};
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
   loadTexture("00A9B169",["idle"]);
   loadTexture("A9B1690B",["standard","burst-standard"]);
   loadTexture("A9B1690C",["mystery","chase","complete","burst-mystery","burst-chase","summon","clone-counter","reflection","burst","entry","dead"]);
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
   var clip:Object=clips[name];if(clip==null)return;index=Math.max(0,Math.min(index,clip.images.length-1));role.actor.bitmapData=clip.images[index];role.actor.x=-clip.meta[index].px;role.actor.y=-clip.meta[index].py;role.MadaraStrikePose({Pivot:{X:clip.meta[index].px,Y:clip.meta[index].py}});
  }
  private function tick(event:Event):void {
   for each(var decoder:TPakDecoder in decoders)if(decoder.Unstreamizing)decoder.Process();if(loaded<14)return;
   if(readyAt<0){clips["clone-idle"]=clips.idle;clips["clone-standard"]=clips.standard;readyAt=getTimer()+4000;ProbeRole.PreloadMadaraNative();}if(getTimer()<readyAt)return;
   var age:int=getTimer()-readyAt;var bounds:Array=[0, 7600, 10320, 13240, 16640, 22960, 26080, 29000, 31000, 34320, 36840, 39360, 42680, 44160, 45640, 53240, 55960, 58880, 62280, 68600, 71720, 74640, 76640, 79960, 82480, 85000, 88320, 89800, 91280];var slot:int=0;while(slot<28 && age>=bounds[slot+1])slot++;
   if(slot>=28){left.FSkillId=0;right.FSkillId=0;left.ClearMadaraVfx();right.ClearMadaraVfx();var remaining:int=0;for(var q:int=0;q<battle.numChildren;q++)if(battle.getChildAt(q).name=="madaraFinalSkillVfx")remaining++;report("DONE Madara/Water Clone native component; remaining="+remaining);removeEventListener(Event.ENTER_FRAME,tick);return;}
   var side:int=slot<14?0:1;var index:int=slot%14;var caster:ProbeRole=side==0?left:right;var victim:ProbeRole=side==0?right:left;
   caster.Camp=side;victim.Camp=1-side;
   caster.FTargets=[caster,victim];caster.FResults=[{CMD:0,ResultInfo:{HurtHp:0}},{CMD:1,ResultInfo:{HurtHp:index==6?-300:10}}];
   if(lastSlot!=slot){left.ClearMadaraVfx();right.ClearMadaraVfx();left.FSkillId=0;right.FSkillId=0;++caster.FCombatVfxSerial;caster.FSkillId=skills[index];caster.FId=(index==8||index==11||index>=12)?11121002:11121001;caster.FFrameIndex=0;caster.y=440;victim.y=440;lastSlot=slot;label.text="Madara / Water Clone | "+clipNames[index]+" | camp "+side;report("CASE "+skills[index]+" camp="+side);}
   var frame:int=int((age-bounds[slot])/40);var name:String=clipNames[index];caster.FFrameIndex=frame;
   if(frame<clips[name].images.length){renderRole(caster,name,frame);caster.UpdateMadaraVfx();}else{caster.FSkillId=0;renderRole(caster,index>=8?"clone-idle":"idle",int(age/100)%clips.idle.images.length);}
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
 public var FId:int=11121001;public var FSkillId:int=0;public var FIndex:int=1;public var FFrameIndex:int=0;public var Camp:int=0;public var Pos:int=1;
 public const TYPE_ACTIVE_ATTACK:int=1;public const TYPE_ACTIVE_SKILL:int=2;
 public static var FMadaraNative:Object={};public var FMadaraVfxStarted:Boolean=false;public var FMadaraLayers:Array=[];public var FCombatVfxSerial:uint=0;
 public var FBattleStage:Sprite;public var FTargets:Array=[];public var FResults:Array=[];public var actor:Bitmap=new Bitmap();public function get FBitmap():Bitmap{return actor;}
 public function ProbeRole(){actor.smoothing=true;addChild(actor);}
      public static function PreloadMadaraNative() : void {
         for each(var effect:String in ["Banzhongyanzhizhan_aoyi1", "Banzhongyanzhizhan_aoyi2", "Banzhongyanzhizhan_beidong", "Banzhongyanzhizhan_pugong1", "Banzhongyanzhizhan_pugong2", "Banzhongyanzhizhan_shanbi", "Banzhongyanzhizhan_zhuida1", "Banzhongyanzhizhan_zhuida2", "YuzhibobanZhongyanzhizhan_Haohuomieshi", "YuzhibobanZhongyanzhizhan_Haohuomieshi_texie", "YuzhibobanZhongyanzhizhan_Wanhtongxielunyan", "YuzhibobanZhongyanzhizhan_Wanhtongxielunyan_bao", "YuzhibobanZhongyanzhizhan_yingfenshen_bao"])LoadMadaraNative(effect);
      }
      public static function LoadMadaraNative(effect:String) : void {
         if(FMadaraNative[effect]!=null)return;
         var state:Object={};FMadaraNative[effect]=state;var loader:Loader=new Loader();state.loader=loader;
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(event:Event):void{state.domain=loader.contentLoaderInfo.applicationDomain;if(loader.content is MovieClip)MovieClip(loader.content).stop();});
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(event:IOErrorEvent):void{delete FMadaraNative[effect];});
         loader.load(new URLRequest("/public/madara-final-vfx/native/"+effect+".swf"),new flash.system.LoaderContext(false,new flash.system.ApplicationDomain()));
      }
      public function ClearMadaraVfx() : void {
         for each(var layer:Sprite in FMadaraLayers)if(layer.parent!=null)layer.parent.removeChild(layer);
         FMadaraLayers=[];FMadaraVfxStarted=false;
      }
      public function UpdateMadaraVfx() : void {
         if((FId!=11121001 && FId!=11121002) || FMadaraVfxStarted || (FIndex!=TYPE_ACTIVE_ATTACK && FIndex!=TYPE_ACTIVE_SKILL))return;
         FMadaraVfxStarted=true;
         var mapping:Object=JSON.parse("{\"13122001\":\"YuzhibobanZhongyanzhizhan_Haohuomieshi\",\"13122002\":\"Banzhongyanzhizhan_pugong1\",\"13122003\":\"Banzhongyanzhizhan_zhuida1\",\"13122004\":\"Banzhongyanzhizhan_aoyi1\",\"13122005\":\"Banzhongyanzhizhan_aoyi2\",\"13122006\":\"Banzhongyanzhizhan_pugong2\",\"13122007\":\"Banzhongyanzhizhan_zhuida2\",\"13122008\":\"YuzhibobanZhongyanzhizhan_yingfenshen_bao\",\"13122009\":\"YuzhibobanZhongyanzhizhan_Wanhtongxielunyan\",\"13122010\":\"Banzhongyanzhizhan_shanbi\",\"13122011\":\"Banzhongyanzhizhan_beidong\",\"13122012\":\"YuzhibobanZhongyanzhizhan_Wanhtongxielunyan_bao\"}");var effect:String=mapping[String(FSkillId)];
         if(FSkillId==13122001)PlayMadaraNative("YuzhibobanZhongyanzhizhan_Haohuomieshi_texie","texie");
         if(effect!=null){PlayMadaraNative(effect,"xia");PlayMadaraNative(effect,"shang");}
      }
      public function MadaraContactOffset() : Point {
         if((FId!=11121001 && FId!=11121002) || FSkillId<13122001 || FSkillId>13122012 || FTargets==null || FResults==null || (FIndex!=TYPE_ACTIVE_ATTACK && FIndex!=TYPE_ACTIVE_SKILL))return new Point();
         var enemy:ProbeRole=null;
         for(var i:int=0;i<FTargets.length && i<FResults.length;i++)if(FTargets[i]!=null && FTargets[i].Camp!=Camp && FResults[i].CMD==1){enemy=FTargets[i];break;}
         if(enemy==null || FSkillId==13122001 || FSkillId==13122004 || FSkillId>=13122008)return new Point();
         var contact:Point=globalToLocal(enemy.localToGlobal(new Point()));
         // Source SkillAction distances, using the same 0.84 scale as the actor.
         var distance:Number=(FSkillId==13122002 || FSkillId==13122003?430:FSkillId==13122006?680:FSkillId==13122005?520:FSkillId==13122007?500:0)*0.84;
         var end:Number=Number(JSON.parse("{\"13122001\":164,\"13122002\":42,\"13122003\":47,\"13122004\":59,\"13122005\":132,\"13122006\":52,\"13122007\":47,\"13122008\":24,\"13122009\":57,\"13122010\":37,\"13122011\":37,\"13122012\":57}")[String(FSkillId)]);var phase:Number=Math.min(1,Math.max(0,FFrameIndex/9),Math.max(0,(end-FFrameIndex)/9));phase=phase*phase*(3-2*phase);
         return new Point((contact.x-distance)*phase,contact.y*phase);
      }
      public function MadaraStrikePose(frame:Object) : void {
         if((FId!=11121001 && FId!=11121002) || frame==null || (FIndex!=TYPE_ACTIVE_ATTACK && FIndex!=TYPE_ACTIVE_SKILL))return;
         var offset:Point=MadaraContactOffset();FBitmap.x=-frame.Pivot.X+offset.x;FBitmap.y=-frame.Pivot.Y+offset.y;
      }
      public function PlayMadaraNative(effect:String,symbol:String,target:ProbeRole=null,startFrame:int=0) : void {
         LoadMadaraNative(effect);
         var caster:ProbeRole=this;var host:DisplayObjectContainer=FBattleStage;if(host==null || stage==null)return;
         var layer:Sprite=new Sprite();layer.name="madaraFinalSkillVfx";layer.mouseEnabled=false;layer.mouseChildren=false;
         if(symbol=="xia" && parent==host)host.addChildAt(layer,host.getChildIndex(this));else host.addChild(layer);
         FMadaraLayers.push(layer);
         var clip:MovieClip=null;var serial:uint=FCombatVfxSerial;var skill:uint=FSkillId;var last:int=-1;var tick:Function;var clear:Function;var cleaned:Boolean=false;
         clear=function(event:Event=null):void{if(cleaned || event!=null && event.target!=layer)return;cleaned=true;layer.removeEventListener(Event.ENTER_FRAME,tick);layer.removeEventListener(Event.REMOVED_FROM_STAGE,clear);if(clip!=null)clip.stop();if(layer.parent!=null)layer.parent.removeChild(layer);};
         tick=function(event:Event=null):void{
            if(host.stage==null || caster.stage==null || caster.FCombatVfxSerial!=serial || caster.FSkillId!=skill || (caster.FIndex!=TYPE_ACTIVE_ATTACK && caster.FIndex!=TYPE_ACTIVE_SKILL)){clear();return;}
            var state:Object=FMadaraNative[effect];if(state==null || state.domain==null){layer.visible=false;return;}
            if(clip==null){if(!state.domain.hasDefinition(symbol)){clear();return;}var type:Class=state.domain.getDefinition(symbol) as Class;clip=new type() as MovieClip;clip.stop();layer.addChild(clip);}
            if(caster.FFrameIndex<startFrame){layer.visible=false;return;}
            var rate:Number=24;var frame:int=Math.round(Math.max(0,caster.FFrameIndex-startFrame)*rate/25)+1;
            if(frame>clip.totalFrames){clear();return;}
            layer.visible=true;if(frame!=last){clip.gotoAndStop(frame);last=frame;}
            var offset:Point=caster.MadaraContactOffset();var originX:Number=70*0.84;
            var at:Point=host.globalToLocal(caster.localToGlobal(new Point(originX+offset.x,offset.y)));
            var facing:Number=caster.scaleX;
            if(target!=null){at=host.globalToLocal(target.localToGlobal(new Point()));facing=target.scaleX;}
            layer.x=at.x;layer.y=at.y;layer.scaleX=facing<0?-0.84:0.84;layer.scaleY=0.84;
            if(symbol=="texie"){
               var bounds:Rectangle=clip.getBounds(clip);if(bounds.width>1 && bounds.height>1){
                  var fit:Number=Math.min(host.stage.stageWidth/bounds.width,host.stage.stageHeight*.75/bounds.height);
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