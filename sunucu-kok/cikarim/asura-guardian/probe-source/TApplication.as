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
  private var skills:Array=[13122501, 13122502, 13122503, 13122504, 13122505, 13122506, 13122507, 13122508, 13122509, 13122510];
  private var clipNames:Array=["mystery", "standard", "standard2", "standard3", "chase", "modified", "protection", "dragon", "barrier", "revive"];
  private var metadata:Object={"idle":{"assets":[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31],"loop":true,"duration":40,"sourceAction":"C_idle","hitFrames":[16]},"run":{"assets":[32,33,34,35],"loop":true,"duration":40,"sourceAction":"C_run1_2","hitFrames":[2]},"hit":{"assets":[36,37,38,39,40,41,42,0],"loop":false,"duration":40,"sourceAction":"D_stand_behit1","hitFrames":[3],"returnFrame":7},"dead":{"assets":[43,44,45,46,47,48,49,50,51,52,53,54,54],"loop":false,"duration":40,"sourceAction":"C_dead","hitFrames":[6],"returnFrame":12},"entry":{"assets":[55,56,57,58,59,60,61,62,63,64,65,66,67,68,0],"loop":false,"duration":40,"sourceAction":"C_entry","hitFrames":[7],"returnFrame":14},"mystery":{"assets":[69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,0],"loop":false,"duration":40,"sourceAction":"SP_skill5","hitFrames":[56,82,92,101,114],"returnFrame":158},"standard":{"assets":[227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,0],"loop":false,"duration":40,"sourceAction":"A_1hit","hitFrames":[7,14],"returnFrame":28},"standard2":{"assets":[255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,0],"loop":false,"duration":40,"sourceAction":"A_2hit","hitFrames":[6,11,25],"returnFrame":43},"standard3":{"assets":[298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360,361,362,363,364,365,366,367,368,369,370,371,372,373,374,375,376,377,378,379,380,381,382,383,384,385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,0],"loop":false,"duration":40,"sourceAction":"A_3hit","hitFrames":[6,11,25,56,67],"returnFrame":102},"chase":{"assets":[400,401,402,403,404,405,406,407,408,409,410,411,412,413,414,415,416,417,418,419,420,421,422,423,424,425,426,427,428,429,430,431,432,433,434,435,436,437,438,439,440,441,442,443,444,445,446,447,448,449,450,451,452,453,454,455,456,457,0],"loop":false,"duration":40,"sourceAction":"SP_skill2","hitFrames":[11],"returnFrame":58},"modified":{"assets":[458,459,460,461,462,463,464,465,466,467,468,469,470,471,472,473,474,475,476,477,478,479,480,481,482,483,484,485,486,487,488,489,490,491,492,493,494,495,496,497,498,499,500,501,502,503,504,505,506,507,508,509,510,511,512,513,514,515,516,517,518,519,520,521,522,523,524,0],"loop":false,"duration":40,"sourceAction":"SP_skill3","hitFrames":[19],"returnFrame":67},"protection":{"assets":[525,526,527,528,529,530,531,532,533,534,535,536,537,538,539,540,541,542,543,544,545,546,547,548,549,550,551,552,553,554,555,556,557,558,559,560,561,562,563,564,565,566,567,568,569,570,571,572,573,574,575,576,577,578,579,580,581,582,583,584,585,586,587,588,589,590,591,592,593,594,595,596,597,0],"loop":false,"duration":40,"sourceAction":"SP_skill1","hitFrames":[25],"returnFrame":73},"dragon":{"assets":[598,599,600,601,602,603,604,605,606,607,608,609,610,611,612,613,614,615,616,617,618,619,620,621,622,623,624,625,626,627,628,629,630,631,632,633,634,635,636,637,638,639,640,641,642,643,644,645,646,647,648,649,650,651,652,653,654,655,656,657,658,659,660,661,662,663,664,665,666,667,668,669,670,671,672,673,674,675,676,677,678,679,680,681,682,683,684,685,686,687,688,0],"loop":false,"duration":40,"sourceAction":"SP_skill6","hitFrames":[20],"returnFrame":91},"barrier":{"assets":[689,690,691,692,693,694,695,696,697,698,699,700,701,702,703,704,705,706,707,708,709,710,711,712,713,714,715,716,717,718,719,720,721,722,723,724,725,726,727,728,729,730,731,732,733,734,735,736,737,738,739,740,741,742,743,744,745,746,747,748,749,750,751,752,753,754,755,756,757,758,759,0],"loop":false,"duration":40,"sourceAction":"SP_skill4","hitFrames":[21],"returnFrame":71},"revive":{"assets":[760,761,762,763,764,765,766,767,768,769,770,771,772,773,774,775,776,777,778,779,780,781,782,783,784,785,786,787,788,789,790,791,792,793,794,0],"loop":false,"duration":40,"sourceAction":"SP_skill7","hitFrames":[11],"returnFrame":35}};
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
   loadTexture("00A9B170",["idle"]);
   loadTexture("A9B1700B",["standard","standard2","standard3"]);
   loadTexture("A9B1700C",["mystery","chase","modified","protection","dragon","barrier","revive","entry","dead"]);
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
   var clip:Object=clips[name];if(clip==null)return;index=Math.max(0,Math.min(index,clip.images.length-1));role.actor.bitmapData=clip.images[index];role.actor.x=-clip.meta[index].px;role.actor.y=-clip.meta[index].py;role.AsuraStrikePose({Pivot:{X:clip.meta[index].px,Y:clip.meta[index].py}});
  }
  private function tick(event:Event):void {
   for each(var decoder:TPakDecoder in decoders)if(decoder.Unstreamizing)decoder.Process();if(loaded<13)return;
   if(readyAt<0){clips["clone-idle"]=clips.idle;clips["clone-standard"]=clips.standard;clips["clone-counter"]=clips.counter;readyAt=getTimer()+4000;ProbeRole.PreloadAsuraNative();}if(getTimer()<readyAt)return;
   var age:int=getTimer()-readyAt;var bounds:Array=[0, 7360, 9520, 12280, 17400, 20760, 24480, 28440, 33120, 37000, 39440, 46800, 48960, 51720, 56840, 60200, 63920, 67880, 72560, 76440, 78880];var slot:int=0;while(slot<20 && age>=bounds[slot+1])slot++;
   if(slot>=20){left.FSkillId=0;right.FSkillId=0;left.ClearAsuraVfx();right.ClearAsuraVfx();var remaining:int=0;for(var q:int=0;q<battle.numChildren;q++)if(battle.getChildAt(q).name=="asuraSkillVfx")remaining++;report("DONE Asura Guardian of the Land native component; remaining="+remaining);removeEventListener(Event.ENTER_FRAME,tick);return;}
   var side:int=slot<10?0:1;var index:int=slot%10;var caster:ProbeRole=side==0?left:right;var victim:ProbeRole=side==0?right:left;
   caster.Camp=side;victim.Camp=1-side;
   caster.FTargets=[caster,victim];caster.FResults=[{CMD:0,ResultInfo:{HurtHp:0}},{CMD:1,ResultInfo:{HurtHp:index==6?-300:10}}];
   if(lastSlot!=slot){left.ClearAsuraVfx();right.ClearAsuraVfx();left.FSkillId=0;right.FSkillId=0;++caster.FCombatVfxSerial;caster.FSkillId=skills[index];caster.FId=(index==6||index>=10)?11121008:11121008;caster.FFrameIndex=0;caster.y=440;victim.y=440;lastSlot=slot;label.text="Asura Guardian of the Land | "+clipNames[index]+" | camp "+side;report("CASE "+skills[index]+" camp="+side);}
   var frame:int=int((age-bounds[slot])/40);var name:String=clipNames[index];caster.FFrameIndex=frame;
   if(frame<clips[name].images.length){renderRole(caster,name,frame);caster.UpdateAsuraVfx();}else{caster.FSkillId=0;renderRole(caster,"idle",int(age/100)%clips.idle.images.length);}
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
 public var FId:int=11121008;public var FSkillId:int=0;public var FIndex:int=1;public var FFrameIndex:int=0;public var Camp:int=0;public var Pos:int=1;
 public const TYPE_ACTIVE_ATTACK:int=1;public const TYPE_ACTIVE_SKILL:int=2;
 public static var FAsuraNative:Object={};public static var FAsuraBitmaps:Object={};public var FAsuraVfxStarted:Boolean=false;public var FAsuraLayers:Array=[];public var FCombatVfxSerial:uint=0;
 public var FBattleStage:Sprite;public var FTargets:Array=[];public var FResults:Array=[];public var actor:Bitmap=new Bitmap();public function get FBitmap():Bitmap{return actor;}
 public function ProbeRole(){actor.smoothing=true;addChild(actor);}
      public static function PreloadAsuraNative() : void {
         for each(var effect:String in ["Axiuluo_jiuwei_liudaowuyuaoyi1", "Axiuluo_jiuwei_liudaowuyuaoyi1texie", "Axiuluo_jiuwei_mulongjizhuida1", "Axiuluo_jiuwei_mulongjizhuida2", "Axiuluo_jiuwei_mulongyuchufa1", "Axiuluo_jiuwei_pugong1", "Axiuluo_jiuwei_pugong2", "Axiuluo_jiuwei_pugong3", "Axiuluo_jiuwei_shouhuaoyi2", "Axiuluo_jiuwei_shouhuaoyi2texie", "Axiuluo_jiuwei_shudanchufa2", "DASHEWAN_tongyongfuhuo"])LoadAsuraNative(effect);LoadAsuraNative("AsuraActor");
      }
      public static function LoadAsuraNative(effect:String) : void {
         if(FAsuraNative[effect]!=null)return;
         var state:Object={};FAsuraNative[effect]=state;var loader:Loader=new Loader();state.loader=loader;
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(event:Event):void{state.domain=loader.contentLoaderInfo.applicationDomain;if(loader.content is MovieClip)MovieClip(loader.content).stop();});
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(event:IOErrorEvent):void{delete FAsuraNative[effect];});
         loader.load(new URLRequest("/public/asura-guardian-vfx/native/"+effect+".swf"),new flash.system.LoaderContext(false,new flash.system.ApplicationDomain()));
      }
      public function ClearAsuraVfx() : void {
         for each(var layer:Sprite in FAsuraLayers)if(layer.parent!=null)layer.parent.removeChild(layer);
         FAsuraLayers=[];FAsuraVfxStarted=false;
      }
      public function UpdateAsuraVfx() : void {
         if((FId!=11121008 && FId!=11121008) || FAsuraVfxStarted || (FIndex!=TYPE_ACTIVE_ATTACK && FIndex!=TYPE_ACTIVE_SKILL))return;
         FAsuraVfxStarted=true;PlayAsuraActor();
         if(FSkillId==13122510){PlayAsuraNative("DASHEWAN_tongyongfuhuo","tyfh");return;}
         var mapping:Object=JSON.parse("{\"13122501\":\"Axiuluo_jiuwei_liudaowuyuaoyi1\",\"13122502\":\"Axiuluo_jiuwei_pugong1\",\"13122503\":\"Axiuluo_jiuwei_pugong2\",\"13122504\":\"Axiuluo_jiuwei_pugong3\",\"13122505\":\"Axiuluo_jiuwei_mulongjizhuida1\",\"13122506\":\"Axiuluo_jiuwei_mulongjizhuida2\",\"13122507\":\"Axiuluo_jiuwei_shouhuaoyi2\",\"13122508\":\"Axiuluo_jiuwei_mulongyuchufa1\",\"13122509\":\"Axiuluo_jiuwei_shudanchufa2\"}");var effect:String=mapping[String(FSkillId)];
         if(effect!=null){PlayAsuraNative(effect,"xia");PlayAsuraNative(effect,"shang");}
         if(FSkillId==13122501)PlayAsuraNative("Axiuluo_jiuwei_liudaowuyuaoyi1texie","texie");
         if(FSkillId==13122507)PlayAsuraNative("Axiuluo_jiuwei_shouhuaoyi2texie","texie");
      }
      public function AsuraContactOffset() : Point {
         if(FId!=11121008 || FSkillId<13122502 || FSkillId>13122504 || FTargets==null || FResults==null || (FIndex!=TYPE_ACTIVE_ATTACK && FIndex!=TYPE_ACTIVE_SKILL))return new Point();
         var enemy:ProbeRole=null;
         for(var i:int=0;i<FTargets.length&&i<FResults.length;i++)if(FTargets[i]!=null&&FTargets[i].Camp!=Camp&&FResults[i].CMD==1){enemy=FTargets[i];break;}
         if(enemy==null)return new Point();
         var contact:Point=globalToLocal(enemy.localToGlobal(new Point()));var distance:Number=350*.84;
         var end:Number=Number(JSON.parse("{\"13122501\":158,\"13122502\":28,\"13122503\":43,\"13122504\":102,\"13122505\":58,\"13122506\":67,\"13122507\":73,\"13122508\":91,\"13122509\":71,\"13122510\":35}")[String(FSkillId)]);var phase:Number=Math.min(1,Math.max(0,FFrameIndex/6),Math.max(0,(end-FFrameIndex)/6));phase=phase*phase*(3-2*phase);
         return new Point((contact.x-distance)*phase,contact.y*phase);
      }
      public function AsuraStrikePose(frame:Object) : void {
         if((FId!=11121008 && FId!=11121008) || frame==null || (FIndex!=TYPE_ACTIVE_ATTACK && FIndex!=TYPE_ACTIVE_SKILL))return;
         var offset:Point=AsuraContactOffset();FBitmap.x=-frame.Pivot.X+offset.x;FBitmap.y=-frame.Pivot.Y+offset.y;
      }
      public function PlayAsuraNative(effect:String,symbol:String,target:ProbeRole=null,startFrame:int=0) : void {
         LoadAsuraNative(effect);
         var caster:ProbeRole=this;var host:DisplayObjectContainer=FBattleStage;if(host==null || stage==null)return;
         var layer:Sprite=new Sprite();layer.name="asuraSkillVfx";layer.mouseEnabled=false;layer.mouseChildren=false;
         if(effect!="DASHEWAN_tongyongfuhuo")layer.blendMode="screen";
         if(symbol=="xia" && parent==host)host.addChildAt(layer,host.getChildIndex(this));else host.addChild(layer);
         FAsuraLayers.push(layer);
         var clip:MovieClip=null;var serial:uint=FCombatVfxSerial;var skill:uint=FSkillId;var last:int=-1;var tick:Function;var clear:Function;var cleaned:Boolean=false;
         clear=function(event:Event=null):void{if(cleaned || event!=null && event.target!=layer)return;cleaned=true;layer.removeEventListener(Event.ENTER_FRAME,tick);layer.removeEventListener(Event.REMOVED_FROM_STAGE,clear);if(clip!=null)clip.stop();if(layer.parent!=null)layer.parent.removeChild(layer);};
         tick=function(event:Event=null):void{
            if(host.stage==null || caster.stage==null || caster.FCombatVfxSerial!=serial || caster.FSkillId!=skill || (caster.FIndex!=TYPE_ACTIVE_ATTACK && caster.FIndex!=TYPE_ACTIVE_SKILL)){clear();return;}
            var state:Object=FAsuraNative[effect];if(state==null || state.domain==null){layer.visible=false;return;}
            if(clip==null){if(!state.domain.hasDefinition(symbol)){clear();return;}var type:Class=state.domain.getDefinition(symbol) as Class;clip=new type() as MovieClip;clip.stop();layer.addChild(clip);}
            if(caster.FFrameIndex<startFrame){layer.visible=false;return;}
            var rate:Number=24;var frame:int=Math.round(Math.max(0,caster.FFrameIndex-startFrame)*rate/25)+1;
            if(frame>clip.totalFrames){clear();return;}
            layer.visible=true;if(frame!=last){clip.gotoAndStop(frame);last=frame;}
            var offset:Point=caster.AsuraContactOffset();var originX:Number=70*0.84;
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
      public static function AsuraActorData():Object {return JSON.parse("{\"13122501\":[[{\"start\":0,\"length\":10,\"elements\":[]},{\"start\":10,\"length\":1,\"elements\":[{\"x\":\"-230\",\"y\":\"-116\",\"assetId\":\"203\",\"bitmap\":\"Asset_203\",\"ax\":-1060.0,\"ay\":-1037.0}]},{\"start\":11,\"length\":30,\"elements\":[{\"x\":\"-230\",\"y\":\"-116\",\"assetId\":\"204\",\"bitmap\":\"Asset_204\",\"ax\":-1063.0,\"ay\":-1037.0}]},{\"start\":41,\"length\":1,\"elements\":[{\"x\":\"-230\",\"y\":\"-116\",\"assetId\":\"205\",\"bitmap\":\"Asset_205\",\"ax\":-621.0,\"ay\":-1037.0}]},{\"start\":42,\"length\":2,\"elements\":[{\"x\":\"-230\",\"y\":\"-116\",\"assetId\":\"206\",\"bitmap\":\"Asset_206\",\"ax\":-384.0,\"ay\":-1037.0}]},{\"start\":44,\"length\":3,\"elements\":[{\"x\":\"-230\",\"y\":\"-116\",\"assetId\":\"207\",\"bitmap\":\"Asset_207\",\"ax\":-386.0,\"ay\":-1037.0}]},{\"start\":47,\"length\":1,\"elements\":[{\"x\":\"-230\",\"y\":\"-116\",\"assetId\":\"208\",\"bitmap\":\"Asset_208\",\"ax\":-1057.0,\"ay\":-1037.0}]},{\"start\":48,\"length\":1,\"elements\":[{\"x\":\"-230\",\"y\":\"-116\",\"assetId\":\"209\",\"bitmap\":\"Asset_209\",\"ax\":-1209.0,\"ay\":-776.0}]},{\"start\":49,\"length\":3,\"elements\":[{\"x\":\"-230\",\"y\":\"-116\",\"assetId\":\"210\",\"bitmap\":\"Asset_210\",\"ax\":-970.0,\"ay\":-1037.0}]},{\"start\":52,\"length\":1,\"elements\":[{\"x\":\"-230\",\"y\":\"-116\",\"assetId\":\"211\",\"bitmap\":\"Asset_211\",\"ax\":-1090.0,\"ay\":-1037.0}]},{\"start\":53,\"length\":2,\"elements\":[{\"x\":\"-230\",\"y\":\"-116\",\"assetId\":\"212\",\"bitmap\":\"Asset_212\",\"ax\":-1053.0,\"ay\":-1037.0}]},{\"start\":55,\"length\":1,\"elements\":[{\"x\":\"-230\",\"y\":\"-116\",\"assetId\":\"213\",\"bitmap\":\"Asset_213\",\"ax\":-786.0,\"ay\":-1037.0}]},{\"start\":56,\"length\":1,\"elements\":[{\"x\":\"-230\",\"y\":\"-116\",\"assetId\":\"214\",\"bitmap\":\"Asset_214\",\"ax\":-655.0,\"ay\":-687.0}]},{\"start\":57,\"length\":2,\"elements\":[{\"x\":\"-230\",\"y\":\"-116\",\"assetId\":\"215\",\"bitmap\":\"Asset_215\",\"ax\":-560.0,\"ay\":-673.0}]},{\"start\":59,\"length\":6,\"elements\":[{\"x\":\"-230\",\"y\":\"-116\",\"assetId\":\"216\",\"bitmap\":\"Asset_216\",\"ax\":-397.0,\"ay\":-1037.0}]},{\"start\":65,\"length\":1,\"elements\":[{\"x\":\"-230\",\"y\":\"-116\",\"assetId\":\"217\",\"bitmap\":\"Asset_217\",\"ax\":-703.0,\"ay\":-1037.0}]},{\"start\":66,\"length\":2,\"elements\":[{\"x\":\"-230\",\"y\":\"-116\",\"assetId\":\"218\",\"bitmap\":\"Asset_218\",\"ax\":-1023.0,\"ay\":-1499.0}]},{\"start\":68,\"length\":2,\"elements\":[{\"x\":\"-230\",\"y\":\"-116\",\"assetId\":\"219\",\"bitmap\":\"Asset_219\",\"ax\":-1102.0,\"ay\":-1037.0}]},{\"start\":70,\"length\":62,\"elements\":[]}]],\"13122505\":[[{\"start\":0,\"length\":8,\"elements\":[]},{\"start\":8,\"length\":1,\"elements\":[{\"x\":\"845\",\"y\":\"-433\",\"assetId\":\"148\",\"bitmap\":\"Asset_148\",\"ax\":-374.0,\"ay\":174.0}]},{\"start\":9,\"length\":2,\"elements\":[{\"x\":\"845\",\"y\":\"-433\",\"assetId\":\"149\",\"bitmap\":\"Asset_149\",\"ax\":-371.0,\"ay\":-42.0}]},{\"start\":11,\"length\":1,\"elements\":[{\"x\":\"845\",\"y\":\"-433\",\"assetId\":\"150\",\"bitmap\":\"Asset_150\",\"ax\":-367.0,\"ay\":-181.0}]},{\"start\":12,\"length\":2,\"elements\":[{\"x\":\"845\",\"y\":\"-433\",\"assetId\":\"151\",\"bitmap\":\"Asset_151\",\"ax\":-381.0,\"ay\":-391.0}]},{\"start\":14,\"length\":2,\"elements\":[{\"x\":\"845\",\"y\":\"-433\",\"assetId\":\"152\",\"bitmap\":\"Asset_152\",\"ax\":-370.0,\"ay\":-450.0}]},{\"start\":16,\"length\":1,\"elements\":[{\"x\":\"845\",\"y\":\"-433\",\"assetId\":\"153\",\"bitmap\":\"Asset_153\",\"ax\":-354.0,\"ay\":-450.0}]},{\"start\":17,\"length\":2,\"elements\":[{\"x\":\"845\",\"y\":\"-433\",\"assetId\":\"154\",\"bitmap\":\"Asset_154\",\"ax\":-240.0,\"ay\":-450.0}]},{\"start\":19,\"length\":21,\"elements\":[]}]],\"13122506\":[[{\"start\":0,\"length\":7,\"elements\":[]},{\"start\":7,\"length\":1,\"elements\":[{\"x\":\"562\",\"y\":\"-166\",\"assetId\":\"180\",\"bitmap\":\"Asset_180\",\"ax\":-450.0,\"ay\":-450.0}]},{\"start\":8,\"length\":2,\"elements\":[{\"x\":\"562\",\"y\":\"-166\",\"assetId\":\"181\",\"bitmap\":\"Asset_181\",\"ax\":-140.0,\"ay\":-55.0}]},{\"start\":10,\"length\":1,\"elements\":[{\"x\":\"562\",\"y\":\"-166\",\"assetId\":\"182\",\"bitmap\":\"Asset_182\",\"ax\":-233.0,\"ay\":-254.0}]},{\"start\":11,\"length\":2,\"elements\":[{\"x\":\"562\",\"y\":\"-166\",\"assetId\":\"183\",\"bitmap\":\"Asset_183\",\"ax\":-275.0,\"ay\":-450.0}]},{\"start\":13,\"length\":2,\"elements\":[{\"x\":\"562\",\"y\":\"-166\",\"assetId\":\"184\",\"bitmap\":\"Asset_184\",\"ax\":-251.0,\"ay\":-450.0}]},{\"start\":15,\"length\":1,\"elements\":[{\"x\":\"562\",\"y\":\"-166\",\"assetId\":\"185\",\"bitmap\":\"Asset_185\",\"ax\":-244.0,\"ay\":-450.0}]},{\"start\":16,\"length\":2,\"elements\":[{\"x\":\"562\",\"y\":\"-166\",\"assetId\":\"186\",\"bitmap\":\"Asset_186\",\"ax\":-237.0,\"ay\":-450.0}]},{\"start\":18,\"length\":2,\"elements\":[{\"x\":\"562\",\"y\":\"-166\",\"assetId\":\"187\",\"bitmap\":\"Asset_187\",\"ax\":-223.0,\"ay\":-450.0}]},{\"start\":20,\"length\":29,\"elements\":[]}],[{\"start\":0,\"length\":11,\"elements\":[]},{\"start\":11,\"length\":1,\"elements\":[{\"x\":\"741\",\"y\":\"-323\",\"assetId\":\"174\",\"bitmap\":\"Asset_174\",\"ax\":-322.0,\"ay\":57.0}]},{\"start\":12,\"length\":2,\"elements\":[{\"x\":\"741\",\"y\":\"-323\",\"assetId\":\"175\",\"bitmap\":\"Asset_175\",\"ax\":-321.0,\"ay\":-161.0}]},{\"start\":14,\"length\":2,\"elements\":[{\"x\":\"741\",\"y\":\"-323\",\"assetId\":\"176\",\"bitmap\":\"Asset_176\",\"ax\":-330.0,\"ay\":-347.0}]},{\"start\":16,\"length\":1,\"elements\":[{\"x\":\"741\",\"y\":\"-323\",\"assetId\":\"177\",\"bitmap\":\"Asset_177\",\"ax\":-317.0,\"ay\":-450.0}]},{\"start\":17,\"length\":2,\"elements\":[{\"x\":\"741\",\"y\":\"-323\",\"assetId\":\"178\",\"bitmap\":\"Asset_178\",\"ax\":-242.0,\"ay\":-450.0}]},{\"start\":19,\"length\":2,\"elements\":[{\"x\":\"741\",\"y\":\"-323\",\"assetId\":\"179\",\"bitmap\":\"Asset_179\",\"ax\":-226.0,\"ay\":-450.0}]},{\"start\":21,\"length\":28,\"elements\":[]}],[{\"start\":0,\"length\":18,\"elements\":[]},{\"start\":18,\"length\":1,\"elements\":[{\"x\":\"474\",\"y\":\"-401\",\"assetId\":\"167\",\"bitmap\":\"Asset_167\",\"ax\":-4.0,\"ay\":69.0}]},{\"start\":19,\"length\":2,\"elements\":[{\"x\":\"474\",\"y\":\"-401\",\"assetId\":\"168\",\"bitmap\":\"Asset_168\",\"ax\":-131.0,\"ay\":-161.0}]},{\"start\":21,\"length\":2,\"elements\":[{\"x\":\"474\",\"y\":\"-401\",\"assetId\":\"169\",\"bitmap\":\"Asset_169\",\"ax\":-278.0,\"ay\":-387.0}]},{\"start\":23,\"length\":1,\"elements\":[{\"x\":\"474\",\"y\":\"-401\",\"assetId\":\"170\",\"bitmap\":\"Asset_170\",\"ax\":-309.0,\"ay\":-450.0}]},{\"start\":24,\"length\":2,\"elements\":[{\"x\":\"474\",\"y\":\"-401\",\"assetId\":\"171\",\"bitmap\":\"Asset_171\",\"ax\":-279.0,\"ay\":-450.0}]},{\"start\":26,\"length\":2,\"elements\":[{\"x\":\"474\",\"y\":\"-401\",\"assetId\":\"172\",\"bitmap\":\"Asset_172\",\"ax\":-283.0,\"ay\":-450.0}]},{\"start\":28,\"length\":2,\"elements\":[{\"x\":\"474\",\"y\":\"-401\",\"assetId\":\"173\",\"bitmap\":\"Asset_173\",\"ax\":-284.0,\"ay\":-450.0}]},{\"start\":30,\"length\":19,\"elements\":[]}]],\"13122508\":[[{\"start\":0,\"length\":5,\"elements\":[]},{\"start\":5,\"length\":1,\"elements\":[{\"x\":\"-433\",\"y\":\"-8\",\"assetId\":\"226\",\"bitmap\":\"Asset_226\",\"ax\":-800.0,\"ay\":-221.0}]},{\"start\":6,\"length\":1,\"elements\":[{\"x\":\"-87\",\"y\":\"-167\",\"assetId\":\"226\",\"bitmap\":\"Asset_226\",\"ax\":-800.0,\"ay\":-221.0}]},{\"start\":7,\"length\":1,\"elements\":[{\"x\":\"-87\",\"y\":\"-167\",\"assetId\":\"227\",\"bitmap\":\"Asset_227\",\"ax\":-657.0,\"ay\":-195.0}]},{\"start\":8,\"length\":2,\"elements\":[{\"x\":\"-87\",\"y\":\"-167\",\"assetId\":\"228\",\"bitmap\":\"Asset_228\",\"ax\":-499.0,\"ay\":-185.0}]},{\"start\":10,\"length\":2,\"elements\":[{\"x\":\"-87\",\"y\":\"-167\",\"assetId\":\"229\",\"bitmap\":\"Asset_229\",\"ax\":-400.0,\"ay\":-177.0}]},{\"start\":12,\"length\":1,\"elements\":[{\"x\":\"-87\",\"y\":\"-167\",\"assetId\":\"230\",\"bitmap\":\"Asset_230\",\"ax\":-352.0,\"ay\":-175.0}]},{\"start\":13,\"length\":2,\"elements\":[{\"x\":\"-87\",\"y\":\"-167\",\"assetId\":\"231\",\"bitmap\":\"Asset_231\",\"ax\":-331.0,\"ay\":-270.0}]},{\"start\":15,\"length\":21,\"elements\":[{\"x\":\"-87\",\"y\":\"-167\",\"assetId\":\"232\",\"bitmap\":\"Asset_232\",\"ax\":-324.0,\"ay\":-326.0}]},{\"start\":36,\"length\":33,\"elements\":[]}],[{\"start\":0,\"length\":36,\"elements\":[]},{\"start\":36,\"length\":2,\"elements\":[{\"x\":\"-147\",\"y\":\"-128\",\"assetId\":\"220\",\"bitmap\":\"Asset_220\",\"ax\":-315.0,\"ay\":-338.0}]},{\"start\":38,\"length\":1,\"elements\":[{\"x\":\"-126\",\"y\":\"-108\",\"assetId\":\"221\",\"bitmap\":\"Asset_221\",\"ax\":-296.0,\"ay\":-337.0}]},{\"start\":39,\"length\":2,\"elements\":[{\"x\":\"-126\",\"y\":\"-108\",\"assetId\":\"222\",\"bitmap\":\"Asset_222\",\"ax\":-381.0,\"ay\":-324.0}]},{\"start\":41,\"length\":2,\"elements\":[{\"x\":\"-126\",\"y\":\"-108\",\"assetId\":\"223\",\"bitmap\":\"Asset_223\",\"ax\":-429.0,\"ay\":-494.0}]},{\"start\":43,\"length\":1,\"elements\":[{\"x\":\"-126\",\"y\":\"-108\",\"assetId\":\"224\",\"bitmap\":\"Asset_224\",\"ax\":-613.0,\"ay\":-800.0}]},{\"start\":44,\"length\":2,\"elements\":[{\"x\":\"-126\",\"y\":\"-108\",\"assetId\":\"225\",\"bitmap\":\"Asset_225\",\"ax\":-652.0,\"ay\":-800.0}]},{\"start\":46,\"length\":23,\"elements\":[]}]],\"13122509\":[[{\"start\":0,\"length\":5,\"elements\":[]},{\"start\":5,\"length\":1,\"elements\":[{\"x\":\"-171\",\"y\":\"-148\",\"assetId\":\"193\",\"bitmap\":\"Asset_193\",\"ax\":-764.0,\"ay\":-388.0}]},{\"start\":6,\"length\":1,\"elements\":[{\"x\":\"367\",\"y\":\"-186\",\"assetId\":\"193\",\"bitmap\":\"Asset_193\",\"ax\":-764.0,\"ay\":-388.0}]},{\"start\":7,\"length\":1,\"elements\":[{\"x\":\"349\",\"y\":\"-114\",\"assetId\":\"194\",\"bitmap\":\"Asset_194\",\"ax\":-764.0,\"ay\":-388.0}]},{\"start\":8,\"length\":2,\"elements\":[{\"x\":\"349\",\"y\":\"-114\",\"assetId\":\"195\",\"bitmap\":\"Asset_195\",\"ax\":-764.0,\"ay\":-366.0}]},{\"start\":10,\"length\":1,\"elements\":[{\"x\":\"349\",\"y\":\"-114\",\"assetId\":\"196\",\"bitmap\":\"Asset_196\",\"ax\":-764.0,\"ay\":-356.0}]},{\"start\":11,\"length\":2,\"elements\":[{\"x\":\"349\",\"y\":\"-114\",\"assetId\":\"197\",\"bitmap\":\"Asset_197\",\"ax\":-764.0,\"ay\":-296.0}]},{\"start\":13,\"length\":2,\"elements\":[{\"x\":\"349\",\"y\":\"-114\",\"assetId\":\"198\",\"bitmap\":\"Asset_198\",\"ax\":-522.0,\"ay\":-182.0}]},{\"start\":15,\"length\":38,\"elements\":[]}]]}");}
      public function PlayAsuraActor():void {
         var layers:Array=AsuraActorData()[String(FSkillId)] as Array;if(layers==null)return;
         LoadAsuraNative("AsuraActor");var caster:ProbeRole=this;var host:DisplayObjectContainer=FBattleStage;if(host==null||stage==null)return;
         var layer:Sprite=new Sprite();layer.name="asuraSkillVfx";layer.mouseEnabled=false;layer.mouseChildren=false;host.addChild(layer);FAsuraLayers.push(layer);
         var serial:uint=FCombatVfxSerial;var skill:uint=FSkillId;var last:int=-1;var tick:Function;var clear:Function;var cleaned:Boolean=false;
         clear=function(e:Event=null):void {if(cleaned||e!=null&&e.target!=layer)return;cleaned=true;layer.removeEventListener(Event.ENTER_FRAME,tick);layer.removeEventListener(Event.REMOVED_FROM_STAGE,clear);if(layer.parent)layer.parent.removeChild(layer);};
         tick=function(e:Event=null):void {
            if(host.stage==null||caster.stage==null||caster.FCombatVfxSerial!=serial||caster.FSkillId!=skill||(caster.FIndex!=TYPE_ACTIVE_ATTACK&&caster.FIndex!=TYPE_ACTIVE_SKILL)){clear();return;}
            var state:Object=FAsuraNative["AsuraActor"];if(state==null||state.domain==null)return;
            var frame:int=Math.floor(caster.FFrameIndex*24/25);if(frame==last)return;last=frame;
            while(layer.numChildren)layer.removeChildAt(0);
            for each(var frames:Array in layers)for each(var node:Object in frames)if(frame>=node.start&&frame<node.start+node.length)for each(var part:Object in node.elements){
               var bitmap:BitmapData=FAsuraBitmaps[part.bitmap] as BitmapData;
               if(bitmap==null&&state.domain.hasDefinition(part.bitmap)){var type:Class=state.domain.getDefinition(part.bitmap) as Class;bitmap=new type() as BitmapData;FAsuraBitmaps[part.bitmap]=bitmap;}
               if(bitmap==null)continue;
               var image:Bitmap=new Bitmap(bitmap,"auto",true);var matrix:flash.geom.Matrix=new flash.geom.Matrix();matrix.translate(Number(part.ax),Number(part.ay));matrix.scale(part.scaleX==null?1:Number(part.scaleX),part.scaleY==null?1:Number(part.scaleY));matrix.rotate(Number(part.rotation||0)*Math.PI/180);matrix.translate(Number(part.x||0),Number(part.y||0));image.transform.matrix=matrix;image.alpha=part.alpha==null?1:Number(part.alpha);layer.addChild(image);
            }
            var at:Point=host.globalToLocal(caster.localToGlobal(new Point()));layer.x=at.x;layer.y=at.y;layer.scaleX=caster.scaleX<0?-.84:.84;layer.scaleY=.84;
            if(skill==13122501){var fit:Number=Math.min(host.stage.stageWidth*.56/2483,host.stage.stageHeight*.72/1776);var direction:Number=caster.scaleX<0?-1:1;layer.scaleX=fit*direction;layer.scaleY=fit;layer.x=at.x+197.5*fit*direction;layer.y=at.y-161*fit;}

         };
         layer.addEventListener(Event.ENTER_FRAME,tick);layer.addEventListener(Event.REMOVED_FROM_STAGE,clear);tick();
      }
 }
}