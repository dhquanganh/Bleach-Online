package {
 import Foundation.Decoder.Pak.TPakDecoder;import Logics.Battle.model.*;import ghostcat.util.easing.TweenUtil;
 import flash.display.*;import flash.events.*;import flash.net.*;import flash.geom.*;import flash.utils.*;import flash.text.*;import flash.filters.*;import flash.system.*;import flash.external.ExternalInterface;
 public class TApplication extends MovieClip {
  private var clips:Object={};private var decoders:Array=[];private var loaded:int=0;private var readyAt:int=-1;private var lastSlot:int=-1;private var captured:Object={};private var cancelled:Object={};
  private var battle:Sprite=new Sprite();private var left:ProbeRole;private var right:ProbeRole;private var label:TextField=new TextField();
  private var metadata:Object={"idle":{"assets":[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39],"duration":40,"loop":true,"sourceAction":"C_idle","sourceFrames":38},"run":{"assets":[40,41,42,43],"duration":40,"loop":true,"sourceAction":"C_run1_2","sourceFrames":3},"hit":{"assets":[44,45,46,47,48,49,50,0],"duration":40,"loop":false,"sourceAction":"D_stand_behit1","sourceFrames":6,"returnFrame":7},"dead":{"assets":[51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,0],"duration":40,"loop":false,"sourceAction":"C_dead","sourceFrames":26,"returnFrame":28},"mystery":{"assets":[79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,0],"duration":40,"loop":false,"sourceAction":"SP_skill1","sourceFrames":125,"returnFrame":131,"hitFrames":[69,74,80,86,91]},"blazeMystery":{"assets":[210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,0],"duration":40,"loop":false,"sourceAction":"SP_skill1_yan","sourceFrames":125,"returnFrame":131,"hitFrames":[69,74,80,86,91]},"standard":{"assets":[341,342,343,344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360,361,362,363,364,365,366,367,368,369,370,371,372,373,374,375,376,377,378,379,380,381,382,383,384,385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,400,401,402,403,404,405,406,407,408,409,410,411,412,413,414,415,416,417,418,419,420,421,422,423,424,425,0],"duration":40,"loop":false,"sourceAction":"A_3hit","sourceFrames":81,"returnFrame":85,"hitFrames":[6,18,31,44,56]},"blazeStandard":{"assets":[426,427,428,429,430,431,432,433,434,435,436,437,438,439,440,441,442,443,444,445,446,447,448,449,450,451,452,453,454,455,456,457,458,459,460,461,462,463,464,465,466,467,468,469,470,471,472,473,474,475,476,477,478,479,480,481,482,483,484,485,486,487,488,489,490,491,492,493,494,495,496,497,498,499,500,501,502,503,504,505,506,507,508,509,510,0],"duration":40,"loop":false,"sourceAction":"A_3hit_yan","sourceFrames":81,"returnFrame":85,"hitFrames":[6,18,31,44,56]},"dragon":{"assets":[511,512,513,514,515,516,517,518,519,520,521,522,523,524,525,526,527,528,529,530,531,532,533,534,535,536,537,538,539,540,541,542,543,544,545,546,547,548,549,550,551,552,553,554,555,556,557,558,559,560,561,562,563,564,565,566,567,568,569,570,571,572,573,574,575,576,577,578,579,580,581,582,583,584,585,586,587,588,589,590,591,592,593,594,595,596,0],"duration":40,"loop":false,"sourceAction":"SP_skill2","sourceFrames":82,"returnFrame":86,"hitFrames":[24,32,41,49]},"blazeDragon":{"assets":[597,598,599,600,601,602,603,604,605,606,607,608,609,610,611,612,613,614,615,616,617,618,619,620,621,622,623,624,625,626,627,628,629,630,631,632,633,634,635,636,637,638,639,640,641,642,643,644,645,646,647,648,649,650,651,652,653,654,655,656,657,658,659,660,661,662,663,664,665,666,667,668,669,670,671,672,673,674,675,676,677,678,679,680,681,682,0],"duration":40,"loop":false,"sourceAction":"SP_skill2_yan","sourceFrames":82,"returnFrame":86,"hitFrames":[24,32,41,49]},"mangekyo":{"assets":[683,684,685,686,687,688,689,690,691,692,693,694,695,696,697,698,699,700,701,702,703,704,705,706,707,708,709,710,711,712,713,714,715,716,717,718,719,720,721,722,723,724,725,726,727,728,729,730,731,732,733,734,735,736,737,738,739,0],"duration":40,"loop":false,"sourceAction":"SP_skill3","sourceFrames":54,"returnFrame":57,"hitFrames":[27]},"rinnegan":{"assets":[740,741,742,743,744,745,746,747,748,749,750,751,752,753,754,755,756,757,758,759,760,761,762,763,764,765,766,767,768,769,770,771,772,773,774,775,776,777,778,779,780,781,782,783,784,785,786,787,788,789,790,791,792,793,794,795,796,797,798,799,800,801,802,0],"duration":40,"loop":false,"sourceAction":"SP_skill4","sourceFrames":60,"returnFrame":63,"hitFrames":[29]},"susanoo":{"assets":[803,804,805,806,807,808,809,810,811,812,813,814,815,816,817,818,819,820,821,822,823,824,825,826,827,828,829,830,831,832,833,834,835,836,837,838,839,840,841,842,0],"duration":40,"loop":false,"sourceAction":"SP_skill5","sourceFrames":38,"returnFrame":40}};private var plan:Array=[{"skill": 0, "name": "idle"}, {"skill": 13121301, "name": "mystery"}, {"skill": 13121302, "name": "blazeMystery"}, {"skill": 13121303, "name": "standard"}, {"skill": 13121304, "name": "blazeStandard"}, {"skill": 13121305, "name": "dragon"}, {"skill": 13121306, "name": "blazeDragon"}, {"skill": 13121307, "name": "mangekyo"}, {"skill": 13121308, "name": "rinnegan"}, {"skill": 13121309, "name": "susanoo"}, {"skill": 13121301, "name": "mystery", "cancel": true}, {"skill": 13121301, "name": "mystery"}];private var bounds:Array=[0, 1900, 7880, 13860, 18000, 22140, 26320, 30500, 33520, 36780, 39120, 41620, 47600, 49500, 55480, 61460, 65600, 69740, 73920, 78100, 81120, 84380, 86720, 89220, 95200];
  public function TApplication(){if(stage)boot();else addEventListener(Event.ADDED_TO_STAGE,boot);}
  private function report(s:String):void{ExternalInterface.call("vfxProbe",s);}
  private function boot(event:Event=null):void {
   removeEventListener(Event.ADDED_TO_STAGE,boot);stage.scaleMode=StageScaleMode.NO_SCALE;stage.align=StageAlign.TOP_LEFT;stage.frameRate=25;
   loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,function(e:UncaughtErrorEvent):void{report("ERROR "+e.error+(e.error is Error?" "+Error(e.error).getStackTrace():""));});
   addChild(battle);battle.graphics.beginFill(0x344b38);battle.graphics.drawRect(0,0,1250,650);battle.graphics.endFill();
   battle.graphics.lineStyle(1,0x59734a,.5);for(var i:int=0;i<12;i++){battle.graphics.moveTo(0,300+i*30);battle.graphics.lineTo(1250,300+i*30);}
   left=new ProbeRole();right=new ProbeRole();left.x=320;right.x=900;left.y=450;right.y=450;right.scaleX=-1;left.Camp=0;right.Camp=1;
   left.FBattleStage=battle;right.FBattleStage=battle;battle.addChild(left);battle.addChild(right);
   label.defaultTextFormat=new TextFormat("_sans",20,0xffffff,true);label.width=1240;label.height=35;label.x=15;label.y=12;addChild(label);
   loadTexture("A9B14A0A",["idle"]);
   loadTexture("A9B14A0B",["standard", "blazeStandard"]);
   loadTexture("A9B14A0C",["mystery", "blazeMystery", "dragon", "blazeDragon", "mangekyo", "rinnegan", "susanoo"]);
   addEventListener(Event.ENTER_FRAME,tick);
  }
  private function idleTexture():Object{var idle:Object=clips.idle;return {GetAnimationSequenceByIndex:function(i:int):Object{return {GetAnimationFrameByIndex:function(j:int):Object{j=j%idle.images.length;return {Surface:idle.images[j],Pivot:{X:idle.meta[j].px,Y:idle.meta[j].py}};}};}};}
  private function clear(role:ProbeRole):void {
   role.FSkillId=0;role.FCombatVfxSerial++;
   for each(var layer:Sprite in role.FSasukeActiveVfx)if(layer.parent!=null)layer.parent.removeChild(layer);
   role.FSasukeActiveVfx=[];

  }
  private function renderRole(role:ProbeRole,name:String,index:int):void {
   var clip:Object=clips[name];if(clip==null)clip=clips.idle;index=Math.max(0,Math.min(index,clip.images.length-1));role.actor.bitmapData=clip.images[index];role.actor.x=-clip.meta[index].px;role.actor.y=-clip.meta[index].py;
   if(role.FSkillId>0){role.FitSasukePose();}
  }
  private function tick(event:Event):void {
   for each(var decoder:TPakDecoder in decoders)if(decoder.Unstreamizing)decoder.Process();if(loaded<10)return;
   if(readyAt<0){left.FTextureFightIdle=idleTexture();right.FTextureFightIdle=idleTexture();readyAt=getTimer()+3500;ProbeRole.PreloadSasukeVfx();}if(getTimer()<readyAt)return;
   var speed:Number=Number(loaderInfo.parameters.speed);if(speed!=2)speed=1;
   var age:int=(getTimer()-readyAt)*speed;var slot:int=0;while(slot<plan.length*2 && age>=bounds[slot+1])slot++;
   if(slot>=plan.length*2){clear(left);clear(right);var remaining:int=0;for(var q:int=0;q<battle.numChildren;q++)if(battle.getChildAt(q).name.indexOf("SkillVfx")>=0||battle.getChildAt(q).name=="itachiCrowClone")remaining++;report("DONE sasuke; remaining="+remaining);removeEventListener(Event.ENTER_FRAME,tick);return;}
   var side:int=slot<plan.length?0:1;var index:int=slot%plan.length;var entry:Object=plan[index];var caster:ProbeRole=side==0?left:right;var victim:ProbeRole=side==0?right:left;
   if(lastSlot!=slot){clear(left);clear(right);caster.FSkillId=entry.skill;caster.FFrameIndex=0;caster.FSasukeVfxStarted=false;caster.Pos=1+index%3*5;caster.y=350+index%3*75;victim.y=390+index%2*80;
    caster.FTargets=[caster,victim,caster];caster.FResults=[{CMD:0,ResultInfo:{HurtHp:0}},{CMD:1,ResultInfo:{HurtHp:10}},{CMD:8,ResultInfo:{HurtHp:0}}];
    if(entry.skill==0)caster.FMechaBeast=false;else if(entry.skill>=13121109&&entry.skill<=13121113)caster.FMechaBeast=true;
    lastSlot=slot;label.text="sasuke native | "+entry.name+" | camp "+side+" | x"+speed+(entry.cancel?" | interrupt":"");report("CASE "+slot+" skill="+entry.skill+" camp="+side);
   }
   var frame:int=int((age-bounds[slot])/40);caster.FFrameIndex=frame;
   if(entry.cancel && frame>=24){if(!cancelled[slot]){cancelled[slot]=true;clear(caster);report("CANCEL_OK "+slot);}renderRole(caster,"idle",frame%clips.idle.images.length);}
   else if(entry.skill>0 && frame<clips[entry.name].images.length){renderRole(caster,entry.name,frame);caster.UpdateSasukeVfx();}
   else {caster.FSkillId=0;renderRole(caster,caster.FMechaBeast&&clips["beast-idle"]!=null?"beast-idle":"idle",frame%clips.idle.images.length);}
   renderRole(victim,"idle",frame%clips.idle.images.length);
   var hit:int=metadata[entry.name].hitFrames!=null?int(metadata[entry.name].hitFrames[0]):12;
   var phases:Array=[Math.max(4,hit),int(metadata[entry.name].assets.length*.5),int(metadata[entry.name].assets.length*.78)];
   if(entry.skill==0)phases=[8,20];if(entry.cancel)phases=[12,30];
   for each(var phase:int in phases){var key:String="CASE-"+slot+"-skill-"+entry.skill+"-camp-"+side+"-frame-"+phase;if(frame>=phase&&!captured[key]){captured[key]=true;var started:int=getTimer();
    for(var flush:int=battle.numChildren-1;flush>=0;flush--)if(flush<battle.numChildren&&battle.getChildAt(flush).name.indexOf("SkillVfx")>=0)battle.getChildAt(flush).dispatchEvent(new Event(Event.ENTER_FRAME));
    saveFrame(key);readyAt+=getTimer()-started;}}
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

 public static var FFourNinjaNativeCache:Object={};public static var FFourNinjaNativeManifest:Object;
 public var FId:int=11120970;public var FSkillId:int=0;public var FIndex:int=1;public var FFrameIndex:int=0;
 public const TYPE_ACTIVE_ATTACK:int=1;public const TYPE_ACTIVE_SKILL:int=2;
 public var FCombatVfxSerial:uint=0;public var FBattleStage:Sprite;public var FTargets:Array=[];public var FResults:Array=[];public var Camp:int=0;public var Pos:int=1;
 public var actor:Bitmap=new Bitmap();public function get FBitmap():Bitmap{return actor;}
 public static var FSasukeFxLoading:Object={};public static var FSasukeFxCache:Object={};public var FSasukeActiveVfx:Array=[];public var FSasukeVfxStarted:Boolean=false;
 public var FMechaBeast:Boolean=false;public var FIsDie:Boolean=false;public var CurHealth:Number=1000;public var FTextureFightIdle:Object;
 public var FItachiCrowClone:Sprite;public var FItachiCrowCloneTick:Function;public var FItachiCrowCloneRemoved:Function;
 public function ProbeRole(){actor.smoothing=true;addChild(actor);}

      public static function PreloadSasukeVfx() : void {
         var data:Object=SasukeVfxManifest();for(var cinematic:String in data.cinematics)LoadSasukeCinematic(cinematic,data.cinematics[cinematic]);
         PreloadFourNinjaNative("sasuke");
      }
      public static function SasukeVfxManifest() : Object
      {
         if(FSasukeFxLoading["_manifest"] != null)
         {
            return FSasukeFxLoading["_manifest"];
         }
         var manifest:Object = JSON.parse("{\"version\":7,\"frameMs\":40,\"frameRate\":25,\"atlases\":{\"ZuozhuZZZZ_haolonghuo-31-trim-0\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_haolonghuo-31-trim-0.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_haolonghuo-31-trim-1\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_haolonghuo-31-trim-1.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_haolonghuo-31-trim-2\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_haolonghuo-31-trim-2.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_haolonghuo-31-trim-3\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_haolonghuo-31-trim-3.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_haolonghuo-31-trim-4\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_haolonghuo-31-trim-4.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_haolonghuo-31-trim-5\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_haolonghuo-31-trim-5.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_haolonghuo-664-trim-0\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_haolonghuo-664-trim-0.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_haolonghuo-664-trim-1\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_haolonghuo-664-trim-1.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_haolonghuo-664-trim-2\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_haolonghuo-664-trim-2.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_haolonghuoyan-31-trim-0.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_haolonghuoyan-31-trim-1\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_haolonghuoyan-31-trim-1.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_haolonghuoyan-31-trim-2\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_haolonghuoyan-31-trim-2.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_haolonghuoyan-31-trim-3\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_haolonghuoyan-31-trim-3.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_haolonghuoyan-31-trim-4\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_haolonghuoyan-31-trim-4.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_haolonghuoyan-31-trim-5\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_haolonghuoyan-31-trim-5.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_haolonghuoyan-891-trim-0.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_haolonghuoyan-891-trim-1.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_haolonghuoyan-891-trim-2.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao1-258-trim-0\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao1-258-trim-0.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao1-258-trim-1\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao1-258-trim-1.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao1-69-trim-0\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao1-69-trim-0.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao2-285-trim-0\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao2-285-trim-0.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao2-285-trim-1\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao2-285-trim-1.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao2-90-trim-0\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao2-90-trim-0.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao3-112-trim-0\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao3-112-trim-0.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao3-684-trim-0\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao3-684-trim-0.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao3-684-trim-1\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao3-684-trim-1.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao3-684-trim-2\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao3-684-trim-2.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao3-684-trim-3\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao3-684-trim-3.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao3-684-trim-4\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao3-684-trim-4.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao3-684-trim-5\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao3-684-trim-5.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao3-684-trim-6\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao3-684-trim-6.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao3-684-trim-7\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao3-684-trim-7.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao3-684-trim-8\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao3-684-trim-8.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao3-684-trim-9\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao3-684-trim-9.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao3-684-trim-10\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao3-684-trim-10.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_qianniaodao3-684-trim-11\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_qianniaodao3-684-trim-11.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_xuzuobati-106-trim-0\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_xuzuobati-106-trim-0.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_xuzuobati-107-trim-0\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_xuzuobati-107-trim-0.png\",\"columns\":1,\"rows\":1,\"frameCount\":0},\"ZuozhuZZZZ_xuzuobati-108-trim-0\":{\"url\":\"/public/sasuke-vfx/compact-v6/ZuozhuZZZZ_xuzuobati-108-trim-0.png\",\"columns\":1,\"rows\":1,\"frameCount\":0}},\"clips\":{\"ZuozhuZZZZ_haolonghuo-31\":{\"atlas\":\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"frameAtlases\":[\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-1\",\"ZuozhuZZZZ_haolonghuo-31-trim-1\",\"ZuozhuZZZZ_haolonghuo-31-trim-1\",\"ZuozhuZZZZ_haolonghuo-31-trim-1\",\"ZuozhuZZZZ_haolonghuo-31-trim-1\",\"ZuozhuZZZZ_haolonghuo-31-trim-1\",\"ZuozhuZZZZ_haolonghuo-31-trim-2\",\"ZuozhuZZZZ_haolonghuo-31-trim-2\",\"ZuozhuZZZZ_haolonghuo-31-trim-2\",\"ZuozhuZZZZ_haolonghuo-31-trim-2\",\"ZuozhuZZZZ_haolonghuo-31-trim-2\",\"ZuozhuZZZZ_haolonghuo-31-trim-2\",\"ZuozhuZZZZ_haolonghuo-31-trim-2\",\"ZuozhuZZZZ_haolonghuo-31-trim-3\",\"ZuozhuZZZZ_haolonghuo-31-trim-3\",\"ZuozhuZZZZ_haolonghuo-31-trim-3\",\"ZuozhuZZZZ_haolonghuo-31-trim-3\",\"ZuozhuZZZZ_haolonghuo-31-trim-3\",\"ZuozhuZZZZ_haolonghuo-31-trim-3\",\"ZuozhuZZZZ_haolonghuo-31-trim-4\",\"ZuozhuZZZZ_haolonghuo-31-trim-4\",\"ZuozhuZZZZ_haolonghuo-31-trim-4\",\"ZuozhuZZZZ_haolonghuo-31-trim-4\",\"ZuozhuZZZZ_haolonghuo-31-trim-4\",\"ZuozhuZZZZ_haolonghuo-31-trim-4\",\"ZuozhuZZZZ_haolonghuo-31-trim-5\",\"ZuozhuZZZZ_haolonghuo-31-trim-5\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\",\"ZuozhuZZZZ_haolonghuo-31-trim-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,0,0,0,0,0,0,0,0],\"width\":1193,\"height\":332,\"pivot\":[0.13896689019279126,0.5171536144578314],\"renderScale\":0.65,\"sourceFrames\":82,\"sourceCrop\":[83,30,1276,362],\"sourceZoom\":0.65,\"frameRects\":[[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[1,0,659,187,264,79],[660,0,940,261,119,39],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,593,1193,332,0,0],[0,925,1193,332,0,0],[0,1257,1193,332,0,0],[0,1589,1193,332,0,0],[0,0,1193,332,0,0],[0,332,1193,332,0,0],[0,664,1193,332,0,0],[0,996,1193,332,0,0],[0,1328,1193,332,0,0],[0,1660,1193,332,0,0],[0,0,1193,332,0,0],[0,332,1193,332,0,0],[0,664,1193,332,0,0],[0,996,1193,332,0,0],[0,1328,1193,332,0,0],[0,1660,1193,332,0,0],[0,1660,1193,332,0,0],[0,0,1193,332,0,0],[0,332,1193,332,0,0],[0,664,1193,332,0,0],[0,996,1193,332,0,0],[0,1328,1193,332,0,0],[0,1660,1193,332,0,0],[0,0,1193,332,0,0],[0,332,1193,332,0,0],[0,664,1184,331,1,1],[0,995,1184,331,1,1],[0,1326,1182,328,3,2],[0,1654,1176,328,3,2],[0,0,1143,320,34,6],[0,320,1119,315,50,9],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0]],\"bufferWidth\":1193,\"bufferHeight\":332},\"ZuozhuZZZZ_haolonghuo-664\":{\"atlas\":\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"frameAtlases\":[\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-1\",\"ZuozhuZZZZ_haolonghuo-664-trim-2\",\"ZuozhuZZZZ_haolonghuo-664-trim-2\",\"ZuozhuZZZZ_haolonghuo-664-trim-2\",\"ZuozhuZZZZ_haolonghuo-664-trim-2\",\"ZuozhuZZZZ_haolonghuo-664-trim-2\",\"ZuozhuZZZZ_haolonghuo-664-trim-2\",\"ZuozhuZZZZ_haolonghuo-664-trim-2\",\"ZuozhuZZZZ_haolonghuo-664-trim-2\",\"ZuozhuZZZZ_haolonghuo-664-trim-2\",\"ZuozhuZZZZ_haolonghuo-664-trim-2\",\"ZuozhuZZZZ_haolonghuo-664-trim-2\",\"ZuozhuZZZZ_haolonghuo-664-trim-2\",\"ZuozhuZZZZ_haolonghuo-664-trim-2\",\"ZuozhuZZZZ_haolonghuo-664-trim-2\",\"ZuozhuZZZZ_haolonghuo-664-trim-2\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\",\"ZuozhuZZZZ_haolonghuo-664-trim-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,1,2,3,4,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,52,53,54,55,56,57,58,59,60,61,62,63,64,0,0,0,0,0,0,0,0,0,0],\"width\":999,\"height\":940,\"pivot\":[0.3489232435033686,0.5132544757033248],\"renderScale\":0.31248796920115496,\"sourceFrames\":82,\"sourceCrop\":[436,287,2514,2242],\"sourceZoom\":0.65,\"frameRects\":[[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[1,0,22,17,365,437],[23,0,40,37,364,434],[63,0,127,59,291,428],[190,0,166,68,268,423],[190,0,166,68,268,423],[356,0,185,75,260,416],[541,0,196,87,258,406],[737,0,203,95,258,399],[940,0,225,99,257,396],[1165,0,247,101,257,393],[1412,0,268,104,257,391],[1680,0,292,106,254,394],[0,106,314,102,252,398],[314,106,337,103,250,397],[651,106,516,341,248,278],[1167,106,488,300,246,302],[0,447,537,459,245,230],[537,447,677,628,185,149],[0,1075,851,789,86,72],[851,1075,999,940,0,0],[0,0,462,241,243,324],[462,0,463,242,243,324],[925,0,463,246,244,322],[1388,0,466,248,243,321],[0,248,468,252,243,319],[468,248,470,256,243,317],[938,248,471,259,243,316],[1409,248,349,262,368,314],[0,510,352,280,369,298],[0,510,352,280,369,298],[352,510,339,298,381,282],[691,510,351,312,371,269],[1042,510,361,321,363,262],[1403,510,365,327,360,258],[0,837,318,295,409,292],[318,837,317,309,412,279],[635,837,326,315,405,275],[961,837,333,318,400,273],[1294,837,308,322,426,271],[1602,837,311,326,425,269],[0,1163,315,333,422,263],[315,1163,319,336,420,262],[634,1163,323,338,418,262],[957,1163,328,338,415,263],[1285,1163,329,341,415,262],[1614,1163,332,343,413,261],[0,1506,336,346,411,260],[336,1506,339,347,410,260],[675,1506,340,344,410,265],[1015,1506,339,352,412,258],[1354,1506,340,357,412,254],[1694,1506,343,362,411,251],[0,0,344,366,411,247],[344,0,344,370,411,244],[344,0,344,370,411,244],[688,0,342,372,412,241],[1030,0,338,373,414,237],[1368,0,314,361,426,238],[1682,0,176,243,480,260],[1858,0,183,244,473,259],[0,373,186,245,470,258],[186,373,164,246,491,257],[350,373,167,244,487,259],[517,373,151,52,492,451],[668,373,150,52,492,451],[818,373,148,50,493,452],[966,373,69,40,518,451],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0]],\"bufferWidth\":999,\"bufferHeight\":940},\"ZuozhuZZZZ_haolonghuoyan-31\":{\"atlas\":\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"frameAtlases\":[\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-3\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-3\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-3\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-3\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-3\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-3\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-4\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-4\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-4\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-4\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-4\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-4\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-5\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-5\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-31-trim-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,0,0,0,0,0,0,0,0],\"width\":1193,\"height\":332,\"pivot\":[0.13896689019279126,0.5171536144578314],\"renderScale\":0.65,\"sourceFrames\":82,\"sourceCrop\":[83,30,1276,362],\"sourceZoom\":0.65,\"frameRects\":[[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[1,0,659,187,264,79],[660,0,940,261,119,39],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,261,1193,332,0,0],[0,593,1193,332,0,0],[0,925,1193,332,0,0],[0,1257,1193,332,0,0],[0,1589,1193,332,0,0],[0,0,1193,332,0,0],[0,332,1193,332,0,0],[0,664,1193,332,0,0],[0,996,1193,332,0,0],[0,1328,1193,332,0,0],[0,1660,1193,332,0,0],[0,0,1193,332,0,0],[0,332,1193,332,0,0],[0,664,1193,332,0,0],[0,996,1193,332,0,0],[0,1328,1193,332,0,0],[0,1660,1193,332,0,0],[0,1660,1193,332,0,0],[0,0,1193,332,0,0],[0,332,1193,332,0,0],[0,664,1193,332,0,0],[0,996,1193,332,0,0],[0,1328,1193,332,0,0],[0,1660,1193,332,0,0],[0,0,1193,332,0,0],[0,332,1193,332,0,0],[0,664,1184,331,1,1],[0,995,1184,331,1,1],[0,1326,1182,328,3,2],[0,1654,1176,328,3,2],[0,0,1143,320,34,6],[0,320,1119,315,50,9],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0]],\"bufferWidth\":1193,\"bufferHeight\":332},\"ZuozhuZZZZ_haolonghuoyan-891\":{\"atlas\":\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"frameAtlases\":[\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-1\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-2\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\",\"ZuozhuZZZZ_haolonghuoyan-891-trim-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,1,2,3,4,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,71,0,0],\"width\":999,\"height\":940,\"pivot\":[0.3489232435033686,0.5132544757033248],\"renderScale\":0.31248796920115496,\"sourceFrames\":82,\"sourceCrop\":[436,287,2514,2242],\"sourceZoom\":0.65,\"frameRects\":[[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[1,0,28,19,359,435],[29,0,53,40,351,431],[82,0,127,65,291,422],[209,0,166,78,268,413],[209,0,166,78,268,413],[375,0,185,85,260,406],[560,0,196,94,258,399],[756,0,211,102,258,392],[967,0,277,99,257,396],[1244,0,278,104,257,393],[1522,0,279,112,257,391],[0,112,303,115,254,394],[303,112,330,113,252,398],[633,112,360,140,250,397],[993,112,516,341,248,278],[1509,112,488,300,246,302],[0,453,537,459,245,230],[537,453,677,628,185,149],[0,1081,851,789,86,72],[851,1081,999,940,0,0],[0,0,475,241,243,324],[475,0,475,242,243,324],[950,0,475,246,244,322],[1425,0,476,248,243,321],[0,248,476,252,243,319],[476,248,476,256,243,317],[952,248,476,259,243,316],[1428,248,351,262,368,314],[0,510,353,280,369,298],[0,510,353,280,369,298],[353,510,341,298,381,282],[694,510,351,312,371,269],[1045,510,361,321,363,262],[1406,510,365,327,360,258],[0,837,318,295,409,292],[318,837,317,309,412,279],[635,837,326,315,405,275],[961,837,333,318,400,273],[1294,837,308,322,426,271],[1602,837,311,326,425,269],[0,1163,315,333,422,263],[315,1163,319,336,420,262],[634,1163,323,338,418,262],[957,1163,328,338,415,263],[1285,1163,329,341,415,262],[1614,1163,332,343,413,261],[0,1506,336,346,411,260],[336,1506,339,347,410,260],[675,1506,340,344,410,265],[1015,1506,339,352,412,258],[1354,1506,340,357,412,254],[1694,1506,343,362,411,251],[0,0,344,366,411,247],[344,0,344,370,411,244],[344,0,344,370,411,244],[688,0,342,372,412,241],[1030,0,338,373,414,237],[1368,0,314,361,426,238],[1682,0,267,253,455,260],[0,373,271,251,451,259],[271,373,270,249,451,258],[541,373,267,250,454,257],[808,373,265,248,454,259],[1073,373,265,108,454,399],[1338,373,264,102,454,401],[1602,373,264,102,454,401],[0,624,261,103,454,398],[261,624,262,103,453,398],[523,624,262,96,453,404],[785,624,260,96,455,404],[1045,624,154,91,455,408],[1199,624,152,86,457,413],[1351,624,27,25,457,413],[1378,624,22,23,457,415],[1378,624,22,23,457,415],[0,0,1,1,0,0],[0,0,1,1,0,0]],\"bufferWidth\":999,\"bufferHeight\":940},\"ZuozhuZZZZ_qianniaodao1-258\":{\"atlas\":\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"frameAtlases\":[\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-1\",\"ZuozhuZZZZ_qianniaodao1-258-trim-1\",\"ZuozhuZZZZ_qianniaodao1-258-trim-1\",\"ZuozhuZZZZ_qianniaodao1-258-trim-1\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\",\"ZuozhuZZZZ_qianniaodao1-258-trim-0\"],\"timeline\":[0,0,0,0,1,2,3,4,5,6,7,8,9,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,0,0,0,0,0,0,0,0,0,0,0,0,0,0],\"width\":469,\"height\":445,\"pivot\":[0.2868710021321962,0.676438202247191],\"renderScale\":0.85,\"sourceFrames\":45,\"sourceCrop\":[248,95,717,540],\"sourceZoom\":0.85,\"frameRects\":[[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[1,0,269,271,85,91],[270,0,316,318,76,70],[586,0,363,366,67,49],[949,0,411,414,58,27],[1360,0,411,414,58,27],[0,414,411,414,58,27],[411,414,411,414,58,0],[822,414,409,411,59,2],[1231,414,407,410,60,3],[1231,414,407,410,60,3],[1638,414,407,410,60,3],[0,828,465,407,0,4],[465,828,391,395,68,10],[856,828,277,204,115,114],[1133,828,313,207,97,112],[1446,828,313,208,97,111],[0,1235,313,208,97,111],[313,1235,313,220,78,95],[626,1235,312,314,78,78],[938,1235,335,334,79,70],[1273,1235,383,353,56,63],[0,1588,433,390,32,55],[433,1588,433,390,32,55],[866,1588,433,390,5,51],[1299,1588,431,387,6,52],[0,0,429,386,7,53],[429,0,422,379,11,56],[851,0,270,325,84,96],[1121,0,50,88,230,137],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0]],\"bufferWidth\":465,\"bufferHeight\":414},\"ZuozhuZZZZ_qianniaodao1-69\":{\"atlas\":\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"frameAtlases\":[\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\",\"ZuozhuZZZZ_qianniaodao1-69-trim-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,2,2,3,4,5,6,7,8,9,9,10,10,11,11,11,12,13,14,14,15,16,17,17,17,18,0,0,0,0,0,0,0],\"width\":288,\"height\":139,\"pivot\":[0.4671614583333334,1.197068345323741],\"renderScale\":0.85,\"sourceFrames\":45,\"sourceCrop\":[248,217,536,356],\"sourceZoom\":0.85,\"frameRects\":[[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[1,0,24,13,80,74],[1,0,24,13,80,74],[1,0,24,13,80,74],[25,0,31,30,194,73],[25,0,31,30,194,73],[56,0,163,79,125,44],[219,0,183,76,104,41],[402,0,183,58,90,40],[585,0,149,50,77,41],[734,0,271,114,0,24],[1005,0,65,48,95,90],[1070,0,60,43,95,90],[1070,0,60,43,95,90],[1130,0,35,65,100,74],[1130,0,35,65,100,74],[1165,0,54,16,93,69],[1165,0,54,16,93,69],[1165,0,54,16,93,69],[1219,0,53,14,88,73],[1272,0,49,41,66,69],[1321,0,40,56,60,64],[1321,0,40,56,60,64],[1361,0,41,21,127,58],[1402,0,11,81,156,5],[1413,0,63,49,148,0],[1413,0,63,49,148,0],[1413,0,63,49,148,0],[1476,0,49,63,155,2],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0]],\"bufferWidth\":271,\"bufferHeight\":114},\"ZuozhuZZZZ_qianniaodao2-285\":{\"atlas\":\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"frameAtlases\":[\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-1\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\",\"ZuozhuZZZZ_qianniaodao2-285-trim-0\"],\"timeline\":[0,0,1,2,3,4,5,6,7,8,9,10,11,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,35,36,37,38,39,40,41,42,43,0,0,0,0,0,0,0,0,0],\"width\":470,\"height\":485,\"pivot\":[0.2881914893617021,0.7027422680412371],\"renderScale\":0.85,\"sourceFrames\":53,\"sourceCrop\":[83,67,553,552],\"sourceZoom\":0.85,\"frameRects\":[[0,0,1,1,0,0],[0,0,1,1,0,0],[1,0,269,271,86,131],[270,0,316,318,77,110],[586,0,363,366,68,89],[949,0,411,414,58,67],[1360,0,411,414,58,67],[0,414,411,414,58,67],[411,414,411,414,59,40],[822,414,409,411,60,41],[1231,414,407,410,61,42],[1638,414,407,410,61,42],[0,828,403,407,63,43],[0,828,403,407,63,43],[403,828,391,395,69,49],[794,828,359,168,0,187],[1153,828,307,201,70,156],[1460,828,277,204,116,154],[0,1235,313,207,98,152],[313,1235,313,208,98,151],[626,1235,313,223,98,135],[939,1235,313,315,79,117],[1252,1235,336,334,79,110],[1588,1235,383,353,57,103],[0,1588,433,390,33,95],[433,1588,433,390,33,95],[866,1588,433,390,6,91],[1299,1588,430,387,7,92],[0,0,429,386,7,93],[429,0,422,379,11,96],[851,0,270,325,85,136],[1121,0,50,87,231,177],[1171,0,149,347,129,83],[1320,0,242,392,113,42],[1562,0,275,417,91,27],[0,417,314,442,64,17],[314,417,355,464,34,11],[669,417,355,462,58,0],[669,417,355,462,58,0],[1024,417,355,460,58,0],[1379,417,355,460,58,0],[0,881,353,458,59,1],[353,881,353,458,59,1],[706,881,351,456,60,2],[1057,881,350,454,60,3],[1407,881,344,447,63,7],[0,1339,331,429,70,16],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0]],\"bufferWidth\":433,\"bufferHeight\":464},\"ZuozhuZZZZ_qianniaodao2-90\":{\"atlas\":\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"frameAtlases\":[\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\",\"ZuozhuZZZZ_qianniaodao2-90-trim-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,0,1,1,1,1,2,3,3,4,5,6,7,8,8,9,9,9,10,11,12,12,12,13,14,14,15,16,16,17,17,17,18,18,19,20,20,21,22,22,23,0,0,0,0,0,0,0],\"width\":289,\"height\":193,\"pivot\":[0.46658304498269887,1.1315673575129532],\"renderScale\":0.85,\"sourceFrames\":53,\"sourceCrop\":[331,165,620,358],\"sourceZoom\":0.85,\"frameRects\":[[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[1,0,24,13,80,126],[1,0,24,13,80,126],[1,0,24,13,80,126],[1,0,24,13,80,126],[25,0,10,19,111,134],[35,0,32,25,194,127],[35,0,32,25,194,127],[67,0,164,79,125,96],[231,0,183,76,104,93],[414,0,184,47,90,92],[598,0,271,92,0,75],[869,0,65,47,95,143],[869,0,65,47,95,143],[934,0,35,66,99,127],[934,0,35,66,99,127],[934,0,35,66,99,127],[969,0,62,10,117,116],[1031,0,69,20,113,115],[1100,0,18,8,106,143],[1100,0,18,8,106,143],[1100,0,18,8,106,143],[1118,0,60,15,107,135],[1178,0,73,26,98,9],[1178,0,73,26,98,9],[1251,0,50,55,70,0],[1301,0,70,22,20,67],[1301,0,70,22,20,67],[1371,0,63,27,23,87],[1371,0,63,27,23,87],[1371,0,63,27,23,87],[1434,0,60,32,20,89],[1434,0,60,32,20,89],[1494,0,61,29,13,92],[1555,0,27,26,12,153],[1555,0,27,26,12,153],[1582,0,67,22,46,89],[1649,0,66,52,59,53],[1649,0,66,52,59,53],[1715,0,23,69,83,65],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0]],\"bufferWidth\":271,\"bufferHeight\":92},\"ZuozhuZZZZ_qianniaodao3-112\":{\"atlas\":\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"frameAtlases\":[\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\",\"ZuozhuZZZZ_qianniaodao3-112-trim-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,1,2,2,2,3,4,5,6,7,8,9,10,10,11,12,13,13,14,15,15,16,17,17,18,18,19,20,20,21,21,22,22,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,23,23,24,0,0,0,0,0,0,0,0,0,0,0,0],\"width\":776,\"height\":396,\"pivot\":[0.3469072164948453,1.1593434343434343],\"renderScale\":1.7,\"sourceFrames\":81,\"sourceCrop\":[659,328,1435,724],\"sourceZoom\":1.7,\"frameRects\":[[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[1,0,27,37,196,264],[28,0,68,59,383,274],[28,0,68,59,383,274],[28,0,68,59,383,274],[96,0,327,160,250,213],[423,0,366,152,208,208],[789,0,369,104,179,207],[1158,0,299,103,154,208],[1457,0,90,80,302,252],[0,160,542,183,0,173],[542,160,404,220,143,176],[946,160,121,88,189,308],[946,160,121,88,189,308],[1067,160,136,31,230,250],[1203,160,133,41,218,262],[1336,160,65,25,196,303],[1336,160,65,25,196,303],[1401,160,144,71,283,82],[1545,160,136,85,169,0],[1545,160,136,85,169,0],[1681,160,114,114,130,15],[1795,160,132,68,35,126],[1795,160,132,68,35,126],[1927,160,60,17,55,243],[1927,160,60,17,55,243],[0,380,136,49,24,257],[136,380,149,65,468,97],[136,380,149,65,468,97],[285,380,151,71,602,31],[285,380,151,71,602,31],[436,380,151,73,625,21],[436,380,151,73,625,21],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[587,380,140,80,279,128],[587,380,140,80,279,128],[727,380,15,119,336,174],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0]],\"bufferWidth\":542,\"bufferHeight\":220},\"ZuozhuZZZZ_qianniaodao3-684\":{\"atlas\":\"ZuozhuZZZZ_qianniaodao3-684-trim-0\",\"frameAtlases\":[\"ZuozhuZZZZ_qianniaodao3-684-trim-0\",\"ZuozhuZZZZ_qianniaodao3-684-trim-0\",\"ZuozhuZZZZ_qianniaodao3-684-trim-0\",\"ZuozhuZZZZ_qianniaodao3-684-trim-0\",\"ZuozhuZZZZ_qianniaodao3-684-trim-0\",\"ZuozhuZZZZ_qianniaodao3-684-trim-0\",\"ZuozhuZZZZ_qianniaodao3-684-trim-0\",\"ZuozhuZZZZ_qianniaodao3-684-trim-0\",\"ZuozhuZZZZ_qianniaodao3-684-trim-0\",\"ZuozhuZZZZ_qianniaodao3-684-trim-0\",\"ZuozhuZZZZ_qianniaodao3-684-trim-0\",\"ZuozhuZZZZ_qianniaodao3-684-trim-0\",\"ZuozhuZZZZ_qianniaodao3-684-trim-0\",\"ZuozhuZZZZ_qianniaodao3-684-trim-0\",\"ZuozhuZZZZ_qianniaodao3-684-trim-0\",\"ZuozhuZZZZ_qianniaodao3-684-trim-1\",\"ZuozhuZZZZ_qianniaodao3-684-trim-1\",\"ZuozhuZZZZ_qianniaodao3-684-trim-1\",\"ZuozhuZZZZ_qianniaodao3-684-trim-1\",\"ZuozhuZZZZ_qianniaodao3-684-trim-1\",\"ZuozhuZZZZ_qianniaodao3-684-trim-1\",\"ZuozhuZZZZ_qianniaodao3-684-trim-1\",\"ZuozhuZZZZ_qianniaodao3-684-trim-1\",\"ZuozhuZZZZ_qianniaodao3-684-trim-1\",\"ZuozhuZZZZ_qianniaodao3-684-trim-1\",\"ZuozhuZZZZ_qianniaodao3-684-trim-1\",\"ZuozhuZZZZ_qianniaodao3-684-trim-2\",\"ZuozhuZZZZ_qianniaodao3-684-trim-2\",\"ZuozhuZZZZ_qianniaodao3-684-trim-2\",\"ZuozhuZZZZ_qianniaodao3-684-trim-2\",\"ZuozhuZZZZ_qianniaodao3-684-trim-2\",\"ZuozhuZZZZ_qianniaodao3-684-trim-2\",\"ZuozhuZZZZ_qianniaodao3-684-trim-2\",\"ZuozhuZZZZ_qianniaodao3-684-trim-2\",\"ZuozhuZZZZ_qianniaodao3-684-trim-2\",\"ZuozhuZZZZ_qianniaodao3-684-trim-2\",\"ZuozhuZZZZ_qianniaodao3-684-trim-3\",\"ZuozhuZZZZ_qianniaodao3-684-trim-3\",\"ZuozhuZZZZ_qianniaodao3-684-trim-3\",\"ZuozhuZZZZ_qianniaodao3-684-trim-3\",\"ZuozhuZZZZ_qianniaodao3-684-trim-3\",\"ZuozhuZZZZ_qianniaodao3-684-trim-3\",\"ZuozhuZZZZ_qianniaodao3-684-trim-3\",\"ZuozhuZZZZ_qianniaodao3-684-trim-4\",\"ZuozhuZZZZ_qianniaodao3-684-trim-4\",\"ZuozhuZZZZ_qianniaodao3-684-trim-4\",\"ZuozhuZZZZ_qianniaodao3-684-trim-4\",\"ZuozhuZZZZ_qianniaodao3-684-trim-4\",\"ZuozhuZZZZ_qianniaodao3-684-trim-4\",\"ZuozhuZZZZ_qianniaodao3-684-trim-5\",\"ZuozhuZZZZ_qianniaodao3-684-trim-5\",\"ZuozhuZZZZ_qianniaodao3-684-trim-5\",\"ZuozhuZZZZ_qianniaodao3-684-trim-5\",\"ZuozhuZZZZ_qianniaodao3-684-trim-5\",\"ZuozhuZZZZ_qianniaodao3-684-trim-5\",\"ZuozhuZZZZ_qianniaodao3-684-trim-6\",\"ZuozhuZZZZ_qianniaodao3-684-trim-6\",\"ZuozhuZZZZ_qianniaodao3-684-trim-7\",\"ZuozhuZZZZ_qianniaodao3-684-trim-7\",\"ZuozhuZZZZ_qianniaodao3-684-trim-8\",\"ZuozhuZZZZ_qianniaodao3-684-trim-8\",\"ZuozhuZZZZ_qianniaodao3-684-trim-8\",\"ZuozhuZZZZ_qianniaodao3-684-trim-8\",\"ZuozhuZZZZ_qianniaodao3-684-trim-8\",\"ZuozhuZZZZ_qianniaodao3-684-trim-9\",\"ZuozhuZZZZ_qianniaodao3-684-trim-9\",\"ZuozhuZZZZ_qianniaodao3-684-trim-9\",\"ZuozhuZZZZ_qianniaodao3-684-trim-9\",\"ZuozhuZZZZ_qianniaodao3-684-trim-10\",\"ZuozhuZZZZ_qianniaodao3-684-trim-10\",\"ZuozhuZZZZ_qianniaodao3-684-trim-10\",\"ZuozhuZZZZ_qianniaodao3-684-trim-10\",\"ZuozhuZZZZ_qianniaodao3-684-trim-10\",\"ZuozhuZZZZ_qianniaodao3-684-trim-10\",\"ZuozhuZZZZ_qianniaodao3-684-trim-10\",\"ZuozhuZZZZ_qianniaodao3-684-trim-10\",\"ZuozhuZZZZ_qianniaodao3-684-trim-10\",\"ZuozhuZZZZ_qianniaodao3-684-trim-11\",\"ZuozhuZZZZ_qianniaodao3-684-trim-11\",\"ZuozhuZZZZ_qianniaodao3-684-trim-11\",\"ZuozhuZZZZ_qianniaodao3-684-trim-11\",\"ZuozhuZZZZ_qianniaodao3-684-trim-11\",\"ZuozhuZZZZ_qianniaodao3-684-trim-0\",\"ZuozhuZZZZ_qianniaodao3-684-trim-0\",\"ZuozhuZZZZ_qianniaodao3-684-trim-0\"],\"timeline\":[0,0,0,0,1,2,3,4,5,6,7,8,9,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,0,0,0],\"width\":1150,\"height\":806,\"pivot\":[0.3828328173374613,0.6200353356890458],\"renderScale\":1.2105263157894737,\"sourceFrames\":81,\"sourceCrop\":[267,482,1882,1614],\"sourceZoom\":1.7,\"frameRects\":[[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[1,0,383,387,369,200],[384,0,450,453,357,171],[834,0,518,521,344,141],[1352,0,585,589,331,110],[0,589,585,589,331,110],[585,589,585,589,331,110],[1170,589,585,590,331,71],[0,1179,582,586,333,73],[582,1179,666,584,248,74],[582,1179,666,584,248,74],[1248,1179,580,584,334,74],[0,0,575,579,336,77],[575,0,558,562,345,85],[1133,0,446,296,386,230],[1579,0,446,295,386,230],[0,579,446,294,360,226],[446,579,445,314,360,206],[891,579,442,447,362,182],[1333,579,475,474,363,172],[0,1053,544,502,330,161],[544,1053,618,555,293,150],[1162,1053,618,555,293,150],[0,0,617,555,255,144],[617,0,614,553,257,145],[1231,0,638,613,231,83],[0,613,601,619,263,73],[601,613,447,619,338,52],[1048,613,506,658,295,31],[0,1271,506,658,295,31],[506,1271,506,665,295,24],[1012,1271,506,675,295,14],[1518,1271,506,658,295,31],[0,0,558,659,243,30],[558,0,753,668,48,24],[558,0,753,668,48,24],[0,668,766,657,69,14],[766,668,738,655,105,15],[0,1325,861,655,0,15],[861,1325,863,653,0,16],[0,0,861,653,0,16],[861,0,899,650,0,18],[0,653,899,647,0,19],[899,653,899,637,0,24],[0,1300,899,612,0,37],[899,1300,987,516,1,119],[0,0,904,605,136,13],[904,0,909,591,137,26],[0,605,903,595,138,21],[903,605,1008,591,142,21],[0,1200,999,603,151,0],[999,1200,942,529,208,21],[0,0,1088,785,62,21],[0,785,1082,796,68,1],[0,0,1075,786,75,2],[0,786,1069,777,81,2],[0,0,1062,775,81,4],[1062,0,959,774,83,4],[0,775,958,772,83,5],[958,775,953,767,87,6],[958,775,953,767,87,6],[0,0,943,759,93,9],[943,0,918,733,110,19],[0,759,697,673,270,68],[697,759,747,671,218,69],[0,0,653,671,288,69],[653,0,637,603,286,77],[1290,0,636,603,284,77],[0,671,630,603,290,77],[630,671,622,603,298,77],[1252,671,584,603,298,81],[0,1274,575,599,305,83],[575,1274,575,599,305,83],[1150,1274,566,597,313,84],[0,0,571,597,308,84],[571,0,567,595,310,85],[1138,0,566,593,311,86],[0,597,552,583,320,91],[552,597,530,560,331,103],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0]],\"bufferWidth\":1088,\"bufferHeight\":796},\"ZuozhuZZZZ_xuzuobati-106\":{\"atlas\":\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"frameAtlases\":[\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\",\"ZuozhuZZZZ_xuzuobati-106-trim-0\"],\"timeline\":[0,1,2,3,4,5,6,7,8,9,9,0,1,2,3,4,5,6,7,8,9,9,0,1,2,3,4,5,6,7,8,9,9,0,1,2,3,4,5,6,7],\"width\":244,\"height\":361,\"pivot\":[0.6557991803278688,1.0593905817174516],\"renderScale\":1.7,\"sourceFrames\":10,\"sourceCrop\":[15,14,259,375],\"sourceZoom\":1.7,\"frameRects\":[[0,0,1,1,0,0],[1,0,204,123,7,117],[205,0,209,176,11,65],[414,0,229,279,0,18],[643,0,231,342,3,17],[874,0,233,346,11,14],[1107,0,221,354,18,7],[1328,0,221,352,18,9],[1549,0,222,360,18,1],[1771,0,221,361,18,0],[1771,0,221,361,18,0],[0,0,1,1,0,0],[1,0,204,123,7,117],[205,0,209,176,11,65],[414,0,229,279,0,18],[643,0,231,342,3,17],[874,0,233,346,11,14],[1107,0,221,354,18,7],[1328,0,221,352,18,9],[1549,0,222,360,18,1],[1771,0,221,361,18,0],[1771,0,221,361,18,0],[0,0,1,1,0,0],[1,0,204,123,7,117],[205,0,209,176,11,65],[414,0,229,279,0,18],[643,0,231,342,3,17],[874,0,233,346,11,14],[1107,0,221,354,18,7],[1328,0,221,352,18,9],[1549,0,222,360,18,1],[1771,0,221,361,18,0],[1771,0,221,361,18,0],[0,0,1,1,0,0],[1,0,204,123,7,117],[205,0,209,176,11,65],[414,0,229,279,0,18],[643,0,231,342,3,17],[874,0,233,346,11,14],[1107,0,221,354,18,7],[1328,0,221,352,18,9]],\"bufferWidth\":233,\"bufferHeight\":361},\"ZuozhuZZZZ_xuzuobati-107\":{\"atlas\":\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"frameAtlases\":[\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\",\"ZuozhuZZZZ_xuzuobati-107-trim-0\"],\"timeline\":[0,1,2,3,4,5,6,7,8,9,9,0,1,2,3,4,5,6,7,8,9,9,0,1,2,3,4,5,6,7,8,9,9,0,1,2,3,4,5,6,7],\"width\":242,\"height\":367,\"pivot\":[0.662107438016529,1.0590463215258854],\"renderScale\":1.7,\"sourceFrames\":10,\"sourceCrop\":[13,11,255,378],\"sourceZoom\":1.7,\"frameRects\":[[0,0,221,361,18,6],[221,0,224,367,18,0],[445,0,222,334,18,33],[667,0,223,336,18,31],[890,0,230,342,12,24],[1120,0,230,343,4,23],[1350,0,229,283,0,20],[1579,0,204,190,16,57],[1783,0,204,147,7,99],[1987,0,1,1,0,0],[1987,0,1,1,0,0],[0,0,221,361,18,6],[221,0,224,367,18,0],[445,0,222,334,18,33],[667,0,223,336,18,31],[890,0,230,342,12,24],[1120,0,230,343,4,23],[1350,0,229,283,0,20],[1579,0,204,190,16,57],[1783,0,204,147,7,99],[1987,0,1,1,0,0],[1987,0,1,1,0,0],[0,0,221,361,18,6],[221,0,224,367,18,0],[445,0,222,334,18,33],[667,0,223,336,18,31],[890,0,230,342,12,24],[1120,0,230,343,4,23],[1350,0,229,283,0,20],[1579,0,204,190,16,57],[1783,0,204,147,7,99],[1987,0,1,1,0,0],[1987,0,1,1,0,0],[0,0,221,361,18,6],[221,0,224,367,18,0],[445,0,222,334,18,33],[667,0,223,336,18,31],[890,0,230,342,12,24],[1120,0,230,343,4,23],[1350,0,229,283,0,20],[1579,0,204,190,16,57]],\"bufferWidth\":230,\"bufferHeight\":367},\"ZuozhuZZZZ_xuzuobati-108\":{\"atlas\":\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"frameAtlases\":[\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\",\"ZuozhuZZZZ_xuzuobati-108-trim-0\"],\"timeline\":[0,1,2,3,4,5,6,7,8,9,9,0,1,2,3,4,5,6,7,8,9,9,0,1,2,3,4,5,6,7,8,9,9,0,1,2,3,4,5,6,7],\"width\":225,\"height\":367,\"pivot\":[0.6281555555555555,1.0590463215258854],\"renderScale\":1.7,\"sourceFrames\":10,\"sourceCrop\":[16,11,241,378],\"sourceZoom\":1.7,\"frameRects\":[[0,0,220,361,0,6],[220,0,223,367,0,0],[443,0,222,334,0,33],[665,0,222,336,0,31],[887,0,223,343,0,24],[1110,0,225,343,0,24],[1335,0,225,347,0,20],[1560,0,221,353,0,14],[1781,0,221,351,0,16],[0,367,221,360,0,7],[0,367,221,360,0,7],[0,0,220,361,0,6],[220,0,223,367,0,0],[443,0,222,334,0,33],[665,0,222,336,0,31],[887,0,223,343,0,24],[1110,0,225,343,0,24],[1335,0,225,347,0,20],[1560,0,221,353,0,14],[1781,0,221,351,0,16],[0,367,221,360,0,7],[0,367,221,360,0,7],[0,0,220,361,0,6],[220,0,223,367,0,0],[443,0,222,334,0,33],[665,0,222,336,0,31],[887,0,223,343,0,24],[1110,0,225,343,0,24],[1335,0,225,347,0,20],[1560,0,221,353,0,14],[1781,0,221,351,0,16],[0,367,221,360,0,7],[0,367,221,360,0,7],[0,0,220,361,0,6],[220,0,223,367,0,0],[443,0,222,334,0,33],[665,0,222,336,0,31],[887,0,223,343,0,24],[1110,0,225,343,0,24],[1335,0,225,347,0,20],[1560,0,221,353,0,14]],\"bufferWidth\":225,\"bufferHeight\":367}},\"effects\":{\"ZuozhuZZZZ_haolonghuo\":[\"ZuozhuZZZZ_haolonghuo-31\",\"ZuozhuZZZZ_haolonghuo-664\"],\"ZuozhuZZZZ_haolonghuoyan\":[\"ZuozhuZZZZ_haolonghuoyan-31\",\"ZuozhuZZZZ_haolonghuoyan-891\"],\"ZuozhuZZZZ_qianniaodao1\":[\"ZuozhuZZZZ_qianniaodao1-69\",\"ZuozhuZZZZ_qianniaodao1-258\"],\"ZuozhuZZZZ_qianniaodao2\":[\"ZuozhuZZZZ_qianniaodao2-90\",\"ZuozhuZZZZ_qianniaodao2-285\"],\"ZuozhuZZZZ_qianniaodao3\":[\"ZuozhuZZZZ_qianniaodao3-112\",\"ZuozhuZZZZ_qianniaodao3-684\"],\"ZuozhuZZZZ_qilin\":[],\"ZuozhuZZZZ_qilin_texie\":[],\"ZuozhuZZZZ_qilin_yan\":[],\"ZuozhuZZZZ_qilin_yantexie\":[],\"ZuozhuZZZZ_xuzuobati\":[\"ZuozhuZZZZ_xuzuobati-106\",\"ZuozhuZZZZ_xuzuobati-107\",\"ZuozhuZZZZ_xuzuobati-108\"]},\"screenFlashes\":{\"ZuozhuZZZZ_qilin\":[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.01434,0.03834,0.05231,0.05231,0.05231,0.03797,0.01397,0.0,0.024,0.02878,0.02878,0.05278,0.05756,0.03356,0.02878,0.02878,0.00478,0.024,0.02878,0.03356,0.03356,0.05756,0.03834,0.03356,0.02878,0.02878,0.00478,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0],\"ZuozhuZZZZ_qilin_yan\":[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.01434,0.03834,0.05231,0.05231,0.05231,0.03797,0.01397,0.0,0.024,0.02878,0.02878,0.05278,0.05756,0.03356,0.02878,0.02878,0.00478,0.024,0.02878,0.03356,0.03356,0.05756,0.03834,0.03356,0.02878,0.02878,0.00478,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]},\"trimmedFrames\":true,\"moves\":{\"13121301\":\"mystery\",\"13121302\":\"blazeMystery\",\"13121303\":\"standard\",\"13121304\":\"blazeStandard\",\"13121305\":\"dragon\",\"13121306\":\"blazeDragon\",\"13121307\":\"mangekyo\",\"13121308\":\"rinnegan\",\"13121309\":\"susanoo\"},\"actions\":{\"mystery\":[\"ZuozhuZZZZ_qilin\",\"ZuozhuZZZZ_qilin_texie\"],\"blazeMystery\":[\"ZuozhuZZZZ_qilin_yan\",\"ZuozhuZZZZ_qilin_yantexie\"],\"standard\":[\"ZuozhuZZZZ_qianniaodao3\"],\"blazeStandard\":[\"ZuozhuZZZZ_qianniaodao3\"],\"dragon\":[\"ZuozhuZZZZ_haolonghuo\"],\"blazeDragon\":[\"ZuozhuZZZZ_haolonghuoyan\"],\"susanoo\":[\"ZuozhuZZZZ_xuzuobati\"],\"mangekyo\":[],\"rinnegan\":[]},\"presentation\":{\"ZuozhuZZZZ_qilin\":{\"coreWidth\":2108.3252142857145,\"sharpScale\":0.3562069053252932,\"displayWidth\":1800,\"heightAboveGround\":8,\"anchorX\":486.26888565849595,\"anchorY\":45.18550161743125},\"ZuozhuZZZZ_qilin_yan\":{\"coreWidth\":2108.3252142857145,\"sharpScale\":0.3562069053252932,\"displayWidth\":1800,\"heightAboveGround\":8,\"anchorX\":443.827173513118,\"anchorY\":92.15362321888044},\"ZuozhuZZZZ_haolonghuo\":{\"coreWidth\":1835.3846153846152,\"sharpScale\":0.65,\"displayWidth\":1280,\"heightAboveGround\":85,\"anchorX\":646.6441401451926,\"anchorY\":-0.18294502609732122},\"ZuozhuZZZZ_haolonghuoyan\":{\"coreWidth\":1835.3846153846152,\"sharpScale\":0.65,\"displayWidth\":1280,\"heightAboveGround\":85,\"anchorX\":646.6441401451926,\"anchorY\":-0.18294502609732122},\"ZuozhuZZZZ_qianniaodao3\":{\"coreWidth\":950.0,\"sharpScale\":1.2105263157894737,\"displayWidth\":1600,\"heightAboveGround\":85,\"anchorX\":155.94951996166486,\"anchorY\":-115.03627205330208},\"ZuozhuZZZZ_xuzuobati\":{\"coreWidth\":143.52941176470588,\"displayWidth\":180,\"heightAboveGround\":0,\"anchorX\":0,\"anchorY\":0}},\"cinematics\":{\"ZuozhuZZZZ_qilin_texie\":{\"url\":\"/public/sasuke-vfx/cinematic-v1/ZuozhuZZZZ_qilin_texie.swf\",\"symbol\":\"texie\",\"plateName\":\"sasukeCinematicPlate\",\"referenceFrame\":38,\"frames\":79,\"frameRate\":24,\"bitmapWidth\":1572,\"bitmapHeight\":846,\"sha256\":\"f16173521e0d952c8b7fffc304ff7a61726fe0d69242926e0dec33319f1f1f33\"},\"ZuozhuZZZZ_qilin_yantexie\":{\"url\":\"/public/sasuke-vfx/cinematic-v1/ZuozhuZZZZ_qilin_yantexie.swf\",\"symbol\":\"texie\",\"plateName\":\"sasukeCinematicPlate\",\"referenceFrame\":38,\"frames\":79,\"frameRate\":24,\"bitmapWidth\":1572,\"bitmapHeight\":846,\"sha256\":\"1a4e99260234b2ba494e545a0b2707dbbf963ffb737197109c835fa31b358fd6\"},\"ZuozhuZZZZ_qilin\":{\"url\":\"/public/sasuke-vfx/cinematic-v1/ZuozhuZZZZ_qilin.swf\",\"impact\":true,\"symbols\":[\"xia\",\"shang\"],\"frames\":125,\"frameRate\":24,\"sha256\":\"d2ec9eed5f3be47cac0a1ce907d784029f7687452152748b83236a6e5693c533\"},\"ZuozhuZZZZ_qilin_yan\":{\"url\":\"/public/sasuke-vfx/cinematic-v1/ZuozhuZZZZ_qilin_yan.swf\",\"impact\":true,\"symbols\":[\"xia\",\"shang\"],\"frames\":125,\"frameRate\":24,\"sha256\":\"c472a9161d1979764f94bcad99ff15640c55e65d5f2fc0d554d81d234f8f18af\"}}}");
         manifest.firstAtlases = {};
         for(var key:String in manifest.clips)
         {
            var clip:Object = manifest.clips[key];
            var head:int = 0;
            while(head < Math.min(5,clip.timeline.length))
            {
               manifest.firstAtlases[String(clip.frameAtlases[head])] = true;
               head++;
            }
            clip.aheadPages = [];
            var tick:int = 0;
            while(tick < clip.timeline.length)
            {
               var pages:Array = [];
               var seen:Object = {};
               var j:int = tick;
               while(j < Math.min(tick + 40,clip.timeline.length))
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
         FSasukeFxLoading["_manifest"] = manifest;
         return manifest;
      }
      public function PlaySasukeVfxAsset(name:String,host:DisplayObjectContainer,point:Point,width:Number,height:Number,delay:int=0,mirrored:Boolean=false,follow:Boolean=false,behind:Boolean=false,angle:Number=0) : void {
         PlayFourNinjaNative("sasuke",name,host,point,width,height,delay,mirrored,follow,behind,angle,FSasukeActiveVfx);
      }
      public function UpdateSasukeVfx() : void
      {
         if(FId != 11120970 || FSkillId < 13121301 || FSkillId > 13121309 || FIndex != TYPE_ACTIVE_ATTACK && FIndex != TYPE_ACTIVE_SKILL || FSasukeVfxStarted)
         {
            return;
         }
         for each(var old:Sprite in FSasukeActiveVfx)
         {
            if(old.parent != null)
            {
               old.parent.removeChild(old);
            }
         }
         FSasukeActiveVfx = [];
         FSasukeVfxStarted = true;
         ShowSasukeVfx(FSkillId);
      }
      public function ShowSasukeVfx(skill:int) : void
      {
         var host:DisplayObjectContainer = FBattleStage;
         if(host == null || host.stage == null)
         {
            return;
         }
         var origin:Point = host.globalToLocal(localToGlobal(new Point()));
         var center:Point = new Point();
         var count:int = 0;
         var seen:Object = {};
         if(FTargets != null && FResults != null)
         {
            var i:int = 0;
            while(i < FTargets.length && i < FResults.length)
            {
               var enemy:ProbeRole = FTargets[i];
               if(!(enemy == null || enemy == this || enemy.Camp == Camp || FResults[i].CMD != TTargetInfo.CMD_ATTACK))
               {
                  var key:String = enemy.Camp + "_" + enemy.Pos;
                  if(!seen[key])
                  {
                     seen[key] = true;
                     var pt:Point = host.globalToLocal(enemy.localToGlobal(new Point()));
                     center.x += pt.x;
                     center.y += pt.y;
                     count++;
                  }
               }
               i++;
            }
         }
         if(count)
         {
            center.x /= count;
            center.y /= count;
         }
         else
         {
            center = origin.clone();
         }
         if(skill == 13121307 || skill == 13121308)
         {
            ShowSasukeGenjutsu(host,center,skill == 13121308);
            return;
         }
         var tl:Point = host.globalToLocal(stage.localToGlobal(new Point()));
         var br:Point = host.globalToLocal(stage.localToGlobal(new Point(stage.stageWidth,stage.stageHeight)));
         var unit:Number = Math.abs(br.x - tl.x) / 1250;
         var data:Object = SasukeVfxManifest();
         var effects:Array = data.actions[String(data.moves[skill])] as Array;
         if(skill <= 13121302)
         {
            SasukeBackdrop(host);
            ShowSasukeScreenFlash(host,skill);
         }
         if(effects != null)
         {
            for each(var effect:String in effects)
            {
               if(data.cinematics[effect] != null && data.cinematics[effect].impact)
               {
                  PlaySasukeNativeImpact(effect,host,center,unit);
               }
               else
               {
                  var cutin:Boolean = effect.indexOf("texie") >= 0;
                  if(cutin)
                  {
                     PlaySasukeCinematic(effect,host);
                  }
                  else
                  {
                     var at:Point = cutin ? new Point((tl.x + br.x) / 2,(tl.y + br.y) / 2) : (skill == 13121309 ? origin.clone() : center.clone());
                     PlaySasukeEffect(effect,host,at,cutin ? 1220 : (skill == 13121309 ? 340 : (skill <= 13121302 ? 1000 : 880)),unit,0,cutin);
                  }
               }
            }
         }
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
      public function PlaySasukeEffect(effect:String, host:DisplayObjectContainer, at:Point, limit:Number, unit:Number, delay:int, cutin:Boolean = false) : void
      {
         var data:Object = SasukeVfxManifest();
         var layers:Array = data.effects[effect] as Array;
         if(layers == null)
         {
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
         var fit:Number = Math.min(limit * unit / Math.max(width,height),(br.x - tl.x - 24 * unit) / width,(br.y - tl.y - 24 * unit) / height);
         if(!cutin)
         {
            var lightning:Boolean = effect.indexOf("qilin") >= 0;
            var dragon:Boolean = effect.indexOf("haolonghuo") >= 0;
            var sword:Boolean = effect.indexOf("qianniaodao") >= 0;
            var gain:Number = lightning ? 1.55 : (dragon ? 1.7 : (sword ? 1.35 : 1.25));
            fit *= gain;
            fit = Math.min(fit,(br.x - tl.x) * 1.15 / width,(br.y - tl.y) * 1.55 / height);
         }
         if(cutin)
         {
            fit = Math.max((br.x - tl.x) / width,(br.y - tl.y) / height);
            var camera:Point = new Point((tl.x + br.x) / 2 - (left + right) / 2 * fit * (scaleX < 0 ? -1 : 1),(tl.y + br.y) / 2 - (top + bottom) / 2 * fit);
            for each(var cameraKey:String in layers)
            {
               var cameraClip:Object = data.clips[cameraKey];
               PlaySasukeVfxAsset(cameraKey,host,camera,cameraClip.width / cameraClip.renderScale * fit,cameraClip.height / cameraClip.renderScale * fit,delay,scaleX < 0,false,false);
            }
            return;
         }
         var profile:Object = data.presentation[effect];
         if(profile != null)
         {
            fit = Number(profile.displayWidth) * unit / Number(profile.coreWidth);
            if(profile.sharpScale != null)
            {
               fit = Math.min(fit,Number(profile.sharpScale) * 1.4 * unit);
            }
            else
            {
               for each(var sharpKey:String in layers)
               {
                  var sharp:Object = data.clips[sharpKey];
                  fit = Math.min(fit,Number(sharp.renderScale) * 1.55 * unit);
               }
            }
            var impact:Point = at.clone();
            var facing:Number = scaleX < 0 ? -1 : 1;
            impact.x -= Number(profile.anchorX) * fit * facing;
            impact.y -= Number(profile.heightAboveGround) * unit + Number(profile.anchorY) * fit;
            for each(var placedKey:String in layers)
            {
               var placed:Object = data.clips[placedKey];
               PlaySasukeVfxAsset(placedKey,host,impact,placed.width / placed.renderScale * fit,placed.height / placed.renderScale * fit,delay,scaleX < 0,false,false);
            }
            return;
         }
         at = at.clone();
         var mirror:Boolean = scaleX < 0;
         var cx:Number = (left + right) / 2;
         var cy:Number = (top + bottom) / 2;
         var desiredY:Number = at.y - Math.min(height * fit * 0.28,150 * unit);
         at.x -= cx * fit * (mirror ? -1 : 1);
         at.y = desiredY - cy * fit;
         var low:Number = mirror ? -right : left;
         var high:Number = mirror ? -left : right;
         if(width * fit < br.x - tl.x - 24 * unit)
         {
            at.x = Math.max(tl.x + 12 * unit - low * fit,Math.min(br.x - 12 * unit - high * fit,at.x));
         }
         else
         {
            at.x = (tl.x + br.x) / 2 - cx * fit * (mirror ? -1 : 1);
         }
         if(height * fit < br.y - tl.y - 24 * unit)
         {
            at.y = Math.max(tl.y + 12 * unit - top * fit,Math.min(br.y - 12 * unit - bottom * fit,at.y));
         }
         else
         {
            at.y = (tl.y + br.y) / 2 - cy * fit;
         }
         for each(key in layers)
         {
            c = data.clips[key];
            PlaySasukeVfxAsset(key,host,at,c.width / c.renderScale * fit,c.height / c.renderScale * fit,delay,mirror,false,false);
         }
      }
      public static function LoadSasukeCinematic(name:String, meta:Object) : void
      {
         var entry:Object;
         var loader:Loader;
         var complete:Function;
         var failed:Function;
         var detach:Function;
         var key:String = "_cinema_" + name;
         if(FSasukeFxLoading[key] != null)
         {
            return;
         }
         entry = {
            "ready":false,
            "failed":false
         };
         FSasukeFxLoading[key] = entry;
         loader = new Loader();
         entry.loader = loader;
         detach = function():void
         {
            loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,complete);
            loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,failed);
            loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,failed);
         };
         failed = function(event:Event):void
         {
            detach();
            entry.failed = true;
         };
         complete = function(event:Event):void
         {
            var symbol:String;
            var klass:Class;
            var movie:MovieClip;
            var plane:DisplayObject;
            detach();
            try
            {
               if(meta.impact)
               {
                  entry.klasses = [];
                  entry.pool = [];
                  for each(symbol in meta.symbols)
                  {
                     entry.klasses.push(loader.contentLoaderInfo.applicationDomain.getDefinition(symbol) as Class);
                  }
                  entry.ready = true;
                  return;
               }
               klass = loader.contentLoaderInfo.applicationDomain.getDefinition(String(meta.symbol)) as Class;
               movie = new klass() as MovieClip;
               movie.stop();
               movie.gotoAndStop(int(meta.referenceFrame));
               plane = movie.getChildByName(String(meta.plateName));
               if(plane == null)
               {
                  throw new Error("Missing cinematic camera plane");
               }
               entry.bounds = plane.getBounds(movie);
               entry.klass = klass;
               movie.gotoAndStop(1);
               entry.spare = movie;
               entry.ready = true;
            }
            catch(error:Error)
            {
               entry.failed = true;
            }
         };
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,complete);
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,failed);
         loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,failed);
         loader.load(new URLRequest(String(meta.url)),new LoaderContext(false,new ApplicationDomain(ApplicationDomain.currentDomain)));
      }
      public function PlaySasukeCinematic(name:String, host:DisplayObjectContainer) : void
      {
         var tl:Point;
         var br:Point;
         var width:Number;
         var height:Number;
         var layer:Sprite;
         var backdrop:Sprite;
         var caster:ProbeRole;
         var serial:uint;
         var skill:int;
         var started:int;
         var movie:MovieClip;
         var entry:Object;
         var cleaned:Boolean;
         var last:int;
         var tick:Function;
         var cleanup:Function;
         var meta:Object = SasukeVfxManifest().cinematics[name];
         if(meta == null || host == null || host.stage == null)
         {
            return;
         }
         LoadSasukeCinematic(name,meta);
         tl = host.globalToLocal(stage.localToGlobal(new Point()));
         br = host.globalToLocal(stage.localToGlobal(new Point(stage.stageWidth,stage.stageHeight)));
         width = br.x - tl.x;
         height = br.y - tl.y;
         layer = new Sprite();
         layer.name = "sasukeSkillVfx";
         layer.mouseEnabled = false;
         layer.mouseChildren = false;
         layer.x = tl.x;
         layer.y = tl.y;
         layer.scrollRect = new Rectangle(0,0,width,height);
         layer.visible = false;
         backdrop = new Sprite();
         backdrop.graphics.beginFill(0);
         backdrop.graphics.drawRect(0,0,width,height);
         backdrop.graphics.endFill();
         layer.addChild(backdrop);
         host.addChild(layer);
         FSasukeActiveVfx.push(layer);
         caster = this;
         serial = FCombatVfxSerial;
         skill = FSkillId;
         started = Math.max(0,FFrameIndex);
         cleaned = false;
         last = -1;
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
            layer.removeEventListener(Event.ENTER_FRAME,tick);
            layer.removeEventListener(Event.REMOVED_FROM_STAGE,cleanup);
            if(event!=null && event.type==Event.REMOVED_FROM_STAGE){
               if(movie!=null)movie.stop();movie=null;return;
            }
            if(movie != null)
            {
               movie.stop();
               if(movie.parent != null)
               {
                  movie.parent.removeChild(movie);
               }
               movie.gotoAndStop(1);
               if(entry != null && entry.spare == null)
               {
                  entry.spare = movie;
               }
               movie = null;
            }
            if(layer.parent != null)
            {
               layer.parent.removeChild(layer);
            }
         };
         tick = function(event:Event):void
         {
            var age:int = Math.max(0,caster.FFrameIndex) - started;
            if(layer.stage == null || caster.FCombatVfxSerial != serial || caster.FSkillId != skill || age >= Math.ceil(Number(meta.frames) * 25 / Number(meta.frameRate)))
            {
               cleanup();
               return;
            }
            entry = FSasukeFxLoading["_cinema_" + name];
            if(entry == null || entry.failed)
            {
               cleanup();
               return;
            }
            if(!entry.ready)
            {
               return;
            }
            if(movie == null)
            {
               if(entry.spare != null)
               {
                  movie = entry.spare as MovieClip;
                  entry.spare = null;
               }
               else
               {
                  var klass:Class = entry.klass as Class;
                  movie = new klass() as MovieClip;
               }
               movie.stop();
               layer.addChild(movie);
               var bounds:Rectangle = entry.bounds as Rectangle;
               var fit:Number = Math.max(width / bounds.width,height / bounds.height);
               movie.scaleX = movie.scaleY = fit;
               movie.x = width / 2 - (bounds.left + bounds.right) / 2 * fit;
               movie.y = height / 2 - (bounds.top + bounds.bottom) / 2 * fit;
            }
            var frame:int = Math.min(int(meta.frames),Math.max(1,Math.round(age * Number(meta.frameRate) / 25) + 1));
            if(frame == last)
            {
               return;
            }
            last = frame;
            movie.gotoAndStop(frame);
            backdrop.visible = movie.getChildByName(String(meta.plateName)) != null;
            layer.visible = movie.numChildren > 0;
         };
         layer.addEventListener(Event.ENTER_FRAME,tick);
         layer.addEventListener(Event.REMOVED_FROM_STAGE,cleanup);
         tick(null);
      }
      public function PlaySasukeNativeImpact(name:String, host:DisplayObjectContainer, at:Point, unit:Number) : void
      {
         var profile:Object;
         var fit:Number;
         var layer:Sprite;
         var facing:Number;
         var caster:ProbeRole;
         var serial:uint;
         var skill:int;
         var started:int;
         var entry:Object;
         var movies:Array;
         var last:int;
         var cleaned:Boolean;
         var tick:Function;
         var cleanup:Function;
         var data:Object = SasukeVfxManifest();
         var meta:Object = data.cinematics[name];
         LoadSasukeCinematic(name,meta);
         profile = data.presentation[name];
         fit = Number(profile.displayWidth) * unit / Number(profile.coreWidth);
         layer = new Sprite();
         layer.name = "sasukeSkillVfx";
         layer.mouseEnabled = false;
         layer.mouseChildren = false;
         facing = scaleX < 0 ? -1 : 1;
         layer.x = at.x - Number(profile.anchorX) * fit * facing;
         layer.y = at.y - Number(profile.heightAboveGround) * unit - Number(profile.anchorY) * fit;
         layer.scaleX = fit * facing;
         layer.scaleY = fit;
         host.addChild(layer);
         FSasukeActiveVfx.push(layer);
         caster = this;
         serial = FCombatVfxSerial;
         skill = FSkillId;
         started = Math.max(0,FFrameIndex);
         last = -1;
         cleaned = false;
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
            layer.removeEventListener(Event.ENTER_FRAME,tick);
            layer.removeEventListener(Event.REMOVED_FROM_STAGE,cleanup);
            if(event!=null && event.type==Event.REMOVED_FROM_STAGE){
               if(movies!=null)for each(var aborted:MovieClip in movies)aborted.stop();
               movies=null;return;
            }
            if(movies != null)
            {
               for each(var movie:MovieClip in movies)
               {
                  movie.stop();
                  if(movie.parent != null)
                  {
                     movie.parent.removeChild(movie);
                  }
                  movie.gotoAndStop(1);
               }
               entry.pool.push(movies);
               movies = null;
            }
            if(layer.parent != null)
            {
               layer.parent.removeChild(layer);
            }
         };
         tick = function(event:Event):void
         {
            var age:int = Math.max(0,caster.FFrameIndex) - started;
            if(layer.stage == null || caster.FCombatVfxSerial != serial || caster.FSkillId != skill || age >= Math.ceil(Number(meta.frames) * 25 / 24))
            {
               cleanup();
               return;
            }
            entry = FSasukeFxLoading["_cinema_" + name];
            if(entry == null || entry.failed)
            {
               cleanup();
               return;
            }
            if(!entry.ready)
            {
               return;
            }
            if(movies == null)
            {
               movies = entry.pool.length ? entry.pool.pop() : [];
               if(!movies.length)
               {
                  for each(var klass:Class in entry.klasses)
                  {
                     movies.push(new klass() as MovieClip);
                  }
               }
               for each(var clip:MovieClip in movies)
               {
                  clip.stop();
                  layer.addChild(clip);
               }
            }
            var frame:int = Math.min(int(meta.frames),Math.max(1,Math.round(age * 24 / 25) + 1));
            if(frame == last)
            {
               return;
            }
            last = frame;
            for each(var active:MovieClip in movies)
            {
               active.gotoAndStop(Math.min(frame,active.totalFrames));
            }
         };
         layer.addEventListener(Event.ENTER_FRAME,tick);
         layer.addEventListener(Event.REMOVED_FROM_STAGE,cleanup);
         tick(null);
      }
      public function ShowSasukeScreenFlash(host:DisplayObjectContainer, skill:int) : void
      {
         var tl:Point;
         var br:Point;
         var layer:Sprite;
         var caster:ProbeRole;
         var serial:uint;
         var castSkill:int;
         var started:int;
         var tick:Function;
         var cleanup:Function;
         var data:Object = SasukeVfxManifest();
         var frames:Array = data.screenFlashes[skill == 13121301 ? "ZuozhuZZZZ_qilin" : "ZuozhuZZZZ_qilin_yan"] as Array;
         if(frames == null)
         {
            return;
         }
         tl = host.globalToLocal(stage.localToGlobal(new Point()));
         br = host.globalToLocal(stage.localToGlobal(new Point(stage.stageWidth,stage.stageHeight)));
         layer = new Sprite();
         layer.name = "sasukeSkillVfx";
         layer.mouseEnabled = false;
         layer.mouseChildren = false;
         layer.graphics.beginFill(16777215);
         layer.graphics.drawRect(tl.x,tl.y,br.x - tl.x,br.y - tl.y);
         layer.graphics.endFill();
         layer.alpha = 0;
         host.addChild(layer);
         FSasukeActiveVfx.push(layer);
         caster = this;
         serial = FCombatVfxSerial;
         castSkill = FSkillId;
         started = Math.max(0,FFrameIndex);
         cleanup = function(event:Event = null):void
         {
            layer.removeEventListener(Event.ENTER_FRAME,tick);
            layer.removeEventListener(Event.REMOVED_FROM_STAGE,cleanup);
            if(layer.parent != null && (event == null || event.type != Event.REMOVED_FROM_STAGE))
            {
               layer.parent.removeChild(layer);
            }
         };
         tick = function(event:Event):void
         {
            var age:int = Math.max(0,caster.FFrameIndex) - started;
            if(layer.stage == null || caster.FCombatVfxSerial != serial || caster.FSkillId != castSkill || age >= frames.length)
            {
               cleanup();
               return;
            }
            layer.alpha = Number(frames[Math.max(0,age)]);
         };
         layer.addEventListener(Event.ENTER_FRAME,tick);
         layer.addEventListener(Event.REMOVED_FROM_STAGE,cleanup);
      }
      public function ShowSasukeGenjutsu(host:DisplayObjectContainer, at:Point, rinnegan:Boolean) : void
      {
         var color:uint;
         var ring:int;
         var n:int;
         var angle:Number;
         var x:Number;
         var y:Number;
         var caster:ProbeRole;
         var serial:uint;
         var started:int;
         var tick:Function;
         var layer:Sprite = new Sprite();
         layer.name = "sasukeSkillVfx";
         layer.mouseEnabled = false;
         layer.mouseChildren = false;
         color = uint(rinnegan ? 10778623 : 15021128);
         layer.graphics.beginFill(1444653,0.5);
         layer.graphics.drawCircle(0,0,100);
         layer.graphics.endFill();
         ring = 0;
         while(ring < 5)
         {
            layer.graphics.lineStyle(2,color,0.85);
            layer.graphics.drawCircle(0,0,18 + ring * 17);
            ring++;
         }
         layer.graphics.beginFill(color,0.95);
         layer.graphics.drawCircle(0,0,12);
         layer.graphics.endFill();
         if(!rinnegan)
         {
            n = 0;
            while(n < 3)
            {
               angle = n * Math.PI * 2 / 3;
               x = Math.cos(angle) * 48;
               y = Math.sin(angle) * 48;
               layer.graphics.beginFill(1051424,1);
               layer.graphics.drawCircle(x,y,13);
               layer.graphics.endFill();
               n++;
            }
         }
         layer.filters = [new GlowFilter(color,0.9,18,18,2,1)];
         layer.x = at.x;
         layer.y = at.y - 85;
         host.addChild(layer);
         FSasukeActiveVfx.push(layer);
         caster = this;
         serial = FCombatVfxSerial;
         started = FFrameIndex;
         tick = function(event:Event):void
         {
            var age:int = Math.max(0,caster.FFrameIndex - started);
            if(layer.stage == null || caster.FCombatVfxSerial != serial || age > 44)
            {
               layer.removeEventListener(Event.ENTER_FRAME,tick);
               if(layer.parent != null)
               {
                  layer.parent.removeChild(layer);
               }
               return;
            }
            layer.rotation = age * (rinnegan ? -5 : 7);
            var size:Number = 0.35 + Math.min(1,age / 10) * 1.2;
            layer.scaleX = layer.scaleY = size;
            layer.alpha = Math.min(1,age / 5) * Math.min(1,(44 - age) / 12);
         };
         layer.addEventListener(Event.ENTER_FRAME,tick);
      }
      public static function FourNinjaNativeManifest() : Object {
         if(FFourNinjaNativeManifest==null)FFourNinjaNativeManifest=JSON.parse("{\n  \"sasuke\": {\n    \"clips\": {\n      \"ZuozhuZZZZ_haolonghuo-31\": {\n        \"url\": \"/public/ninja-native-lite/v1/sasuke/ZuozhuZZZZ_haolonghuo.swf\",\n        \"symbol\": \"xia\",\n        \"width\": 1835.3846153846152,\n        \"height\": 510.7692307692308,\n        \"pivot\": [\n          0.13896689019279126,\n          0.5171536144578314\n        ],\n        \"duration\": 3440,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"ZuozhuZZZZ_haolonghuo-664\": {\n        \"url\": \"/public/ninja-native-lite/v1/sasuke/ZuozhuZZZZ_haolonghuo.swf\",\n        \"symbol\": \"shang\",\n        \"width\": 3196.923076923077,\n        \"height\": 3008.1158081158082,\n        \"pivot\": [\n          0.3489232435033686,\n          0.5132544757033248\n        ],\n        \"duration\": 3440,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"ZuozhuZZZZ_haolonghuoyan-31\": {\n        \"url\": \"/public/ninja-native-lite/v1/sasuke/ZuozhuZZZZ_haolonghuoyan.swf\",\n        \"symbol\": \"xia\",\n        \"width\": 1835.3846153846152,\n        \"height\": 510.7692307692308,\n        \"pivot\": [\n          0.13896689019279126,\n          0.5171536144578314\n        ],\n        \"duration\": 3440,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"ZuozhuZZZZ_haolonghuoyan-891\": {\n        \"url\": \"/public/ninja-native-lite/v1/sasuke/ZuozhuZZZZ_haolonghuoyan.swf\",\n        \"symbol\": \"shang\",\n        \"width\": 3196.923076923077,\n        \"height\": 3008.1158081158082,\n        \"pivot\": [\n          0.3489232435033686,\n          0.5132544757033248\n        ],\n        \"duration\": 3440,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"ZuozhuZZZZ_qianniaodao1-258\": {\n        \"url\": \"/public/ninja-native-lite/v1/sasuke/ZuozhuZZZZ_qianniaodao1.swf\",\n        \"symbol\": \"shang\",\n        \"width\": 551.7647058823529,\n        \"height\": 523.5294117647059,\n        \"pivot\": [\n          0.2868710021321962,\n          0.676438202247191\n        ],\n        \"duration\": 1880,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"ZuozhuZZZZ_qianniaodao1-69\": {\n        \"url\": \"/public/ninja-native-lite/v1/sasuke/ZuozhuZZZZ_qianniaodao1.swf\",\n        \"symbol\": \"xia\",\n        \"width\": 338.8235294117647,\n        \"height\": 163.52941176470588,\n        \"pivot\": [\n          0.4671614583333334,\n          1.197068345323741\n        ],\n        \"duration\": 1880,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"ZuozhuZZZZ_qianniaodao2-285\": {\n        \"url\": \"/public/ninja-native-lite/v1/sasuke/ZuozhuZZZZ_qianniaodao2.swf\",\n        \"symbol\": \"shang\",\n        \"width\": 552.9411764705883,\n        \"height\": 570.5882352941177,\n        \"pivot\": [\n          0.2881914893617021,\n          0.7027422680412371\n        ],\n        \"duration\": 2240,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"ZuozhuZZZZ_qianniaodao2-90\": {\n        \"url\": \"/public/ninja-native-lite/v1/sasuke/ZuozhuZZZZ_qianniaodao2.swf\",\n        \"symbol\": \"xia\",\n        \"width\": 340.0,\n        \"height\": 227.05882352941177,\n        \"pivot\": [\n          0.46658304498269887,\n          1.1315673575129532\n        ],\n        \"duration\": 2240,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"ZuozhuZZZZ_qianniaodao3-112\": {\n        \"url\": \"/public/ninja-native-lite/v1/sasuke/ZuozhuZZZZ_qianniaodao3.swf\",\n        \"symbol\": \"xia\",\n        \"width\": 456.47058823529414,\n        \"height\": 232.94117647058823,\n        \"pivot\": [\n          0.3469072164948453,\n          1.1593434343434343\n        ],\n        \"duration\": 3400,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"ZuozhuZZZZ_qianniaodao3-684\": {\n        \"url\": \"/public/ninja-native-lite/v1/sasuke/ZuozhuZZZZ_qianniaodao3.swf\",\n        \"symbol\": \"shang\",\n        \"width\": 950.0,\n        \"height\": 665.8260869565217,\n        \"pivot\": [\n          0.3828328173374613,\n          0.6200353356890458\n        ],\n        \"duration\": 3400,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"ZuozhuZZZZ_xuzuobati-106\": {\n        \"url\": \"/public/ninja-native-lite/v1/sasuke/ZuozhuZZZZ_xuzuobati.swf\",\n        \"symbol\": \"b1\",\n        \"width\": 143.52941176470588,\n        \"height\": 212.35294117647058,\n        \"pivot\": [\n          0.6557991803278688,\n          1.0593905817174516\n        ],\n        \"duration\": 1640,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"ZuozhuZZZZ_xuzuobati-107\": {\n        \"url\": \"/public/ninja-native-lite/v1/sasuke/ZuozhuZZZZ_xuzuobati.swf\",\n        \"symbol\": \"b3\",\n        \"width\": 142.35294117647058,\n        \"height\": 215.88235294117646,\n        \"pivot\": [\n          0.662107438016529,\n          1.0590463215258854\n        ],\n        \"duration\": 1640,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"ZuozhuZZZZ_xuzuobati-108\": {\n        \"url\": \"/public/ninja-native-lite/v1/sasuke/ZuozhuZZZZ_xuzuobati.swf\",\n        \"symbol\": \"b2\",\n        \"width\": 132.35294117647058,\n        \"height\": 215.88235294117646,\n        \"pivot\": [\n          0.6281555555555555,\n          1.0590463215258854\n        ],\n        \"duration\": 1640,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      }\n    },\n    \"urls\": [\n      \"/public/ninja-native-lite/v1/sasuke/ZuozhuZZZZ_haolonghuo.swf\",\n      \"/public/ninja-native-lite/v1/sasuke/ZuozhuZZZZ_haolonghuoyan.swf\",\n      \"/public/ninja-native-lite/v1/sasuke/ZuozhuZZZZ_qianniaodao1.swf\",\n      \"/public/ninja-native-lite/v1/sasuke/ZuozhuZZZZ_qianniaodao2.swf\",\n      \"/public/ninja-native-lite/v1/sasuke/ZuozhuZZZZ_qianniaodao3.swf\",\n      \"/public/ninja-native-lite/v1/sasuke/ZuozhuZZZZ_xuzuobati.swf\"\n    ]\n  },\n  \"mecha\": {\n    \"clips\": {\n      \"Jijiamingren_aoyi-1343\": {\n        \"url\": \"/public/ninja-native-lite/v1/mecha/Jijiamingren_aoyi.swf\",\n        \"symbol\": \"shang\",\n        \"width\": 1800.0,\n        \"height\": 1199.53125,\n        \"pivot\": [\n          0.49989542483660127,\n          0.5001617647058824\n        ],\n        \"duration\": 6400,\n        \"rate\": 24,\n        \"soft\": true,\n        \"additive\": false\n      },\n      \"Jijiamingren_aoyi-139\": {\n        \"url\": \"/public/ninja-native-lite/v1/mecha/Jijiamingren_aoyi.swf\",\n        \"symbol\": \"xia\",\n        \"width\": 1800.0,\n        \"height\": 1199.53125,\n        \"pivot\": [\n          0.5002483660130718,\n          0.5004338235294118\n        ],\n        \"duration\": 6400,\n        \"rate\": 24,\n        \"soft\": true,\n        \"additive\": true\n      },\n      \"Jijiamingren_ji_aoyi-245\": {\n        \"url\": \"/public/ninja-native-lite/v1/mecha/Jijiamingren_ji_aoyi.swf\",\n        \"symbol\": \"xia\",\n        \"width\": 2025.8823529411764,\n        \"height\": 1460.972850678733,\n        \"pivot\": [\n          0.45411149825783975,\n          0.7395933977455716\n        ],\n        \"duration\": 2920,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"Jijiamingren_ji_aoyi-440\": {\n        \"url\": \"/public/ninja-native-lite/v1/mecha/Jijiamingren_ji_aoyi.swf\",\n        \"symbol\": \"shang\",\n        \"width\": 1754.1176470588234,\n        \"height\": 2192.6470588235293,\n        \"pivot\": [\n          0.4887206572769953,\n          0.6312674356223177\n        ],\n        \"duration\": 2920,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"Jijiamingren_liandan_pugong3-529\": {\n        \"url\": \"/public/ninja-native-lite/v1/mecha/Jijiamingren_liandan_pugong3.swf\",\n        \"symbol\": \"shang\",\n        \"width\": 840.0,\n        \"height\": 611.7647058823529,\n        \"pivot\": [\n          0.5355217086834734,\n          0.6485624999999999\n        ],\n        \"duration\": 3920,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"Jijiamingren_luoxuanwan_zhuida-626\": {\n        \"url\": \"/public/ninja-native-lite/v1/mecha/Jijiamingren_luoxuanwan_zhuida.swf\",\n        \"symbol\": \"shang\",\n        \"width\": 1000.0,\n        \"height\": 800.0,\n        \"pivot\": [\n          -0.11905882352941181,\n          0.7178897058823529\n        ],\n        \"duration\": 3240,\n        \"rate\": 24,\n        \"soft\": true,\n        \"additive\": false\n      },\n      \"Jijiamingren_qianghua_pugong-250\": {\n        \"url\": \"/public/ninja-native-lite/v1/mecha/Jijiamingren_qianghua_pugong.swf\",\n        \"symbol\": \"shang\",\n        \"width\": 982.3529411764706,\n        \"height\": 430.5882352941177,\n        \"pivot\": [\n          0.1380329341317365,\n          0.7177800546448087\n        ],\n        \"duration\": 2200,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"Jijiamingren_shanbi-154\": {\n        \"url\": \"/public/ninja-native-lite/v1/mecha/Jijiamingren_shanbi.swf\",\n        \"symbol\": \"shang\",\n        \"width\": 407.0588235294118,\n        \"height\": 201.17647058823533,\n        \"pivot\": [\n          0.5182008670520232,\n          0.7446929824561404\n        ],\n        \"duration\": 1680,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"Jijiamingren_shanbi-90\": {\n        \"url\": \"/public/ninja-native-lite/v1/mecha/Jijiamingren_shanbi.swf\",\n        \"symbol\": \"xia\",\n        \"width\": 408.2352941176471,\n        \"height\": 334.11764705882354,\n        \"pivot\": [\n          0.5035878962536023,\n          0.7393309859154928\n        ],\n        \"duration\": 1680,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"Jijiamingren_jiuweilama_weisouyu-609\": {\n        \"url\": \"/public/ninja-native-lite/v1/mecha/Jijiamingren_jiuweilama_weisouyu.swf\",\n        \"symbol\": \"shang\",\n        \"width\": 1800.575294117647,\n        \"height\": 1199.110588235294,\n        \"pivot\": [\n          0.5001587727843846,\n          0.5001059608886586\n        ],\n        \"duration\": 4480,\n        \"rate\": 24,\n        \"soft\": true,\n        \"additive\": false\n      },\n      \"Jijiamingren_jiuweilama_weisouyu-67\": {\n        \"url\": \"/public/ninja-native-lite/v1/mecha/Jijiamingren_jiuweilama_weisouyu.swf\",\n        \"symbol\": \"xia\",\n        \"width\": 1798.6658823529413,\n        \"height\": 1199.110588235294,\n        \"pivot\": [\n          0.499922164532405,\n          0.49994898179434955\n        ],\n        \"duration\": 4480,\n        \"rate\": 24,\n        \"soft\": true,\n        \"additive\": true\n      },\n      \"Jijiamingren_jiuweilama_zhuaji-12\": {\n        \"url\": \"/public/ninja-native-lite/v1/mecha/Jijiamingren_jiuweilama_zhuaji.swf\",\n        \"symbol\": \"xia\",\n        \"width\": 1097.6920588235294,\n        \"height\": 252.17249999999999,\n        \"pivot\": [\n          0.44418910478750473,\n          0.22828152764243437\n        ],\n        \"duration\": 3560,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"Jijiamingren_jiuweilama_zhuaji-379\": {\n        \"url\": \"/public/ninja-native-lite/v1/mecha/Jijiamingren_jiuweilama_zhuaji.swf\",\n        \"symbol\": \"shang\",\n        \"width\": 3129.905735294117,\n        \"height\": 3112.613438414039,\n        \"pivot\": [\n          0.4388882318810674,\n          0.4921450138808531\n        ],\n        \"duration\": 3560,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"Jijiamingren_jiuweilama_hengsao-256\": {\n        \"url\": \"/public/ninja-native-lite/v1/mecha/Jijiamingren_jiuweilama_hengsao.swf\",\n        \"symbol\": \"shang\",\n        \"width\": 2762.160088235294,\n        \"height\": 3115.2181446262716,\n        \"pivot\": [\n          0.49661891322629925,\n          0.4919143719713732\n        ],\n        \"duration\": 4400,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"Jijiamingren_jiuweilama_hengsao-58\": {\n        \"url\": \"/public/ninja-native-lite/v1/mecha/Jijiamingren_jiuweilama_hengsao.swf\",\n        \"symbol\": \"xia\",\n        \"width\": 1144.1957647058823,\n        \"height\": 420.1343823529412,\n        \"pivot\": [\n          0.47832970581751527,\n          0.5081309068548024\n        ],\n        \"duration\": 4400,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      }\n    },\n    \"urls\": [\n      \"/public/ninja-native-lite/v1/mecha/Jijiamingren_aoyi.swf\",\n      \"/public/ninja-native-lite/v1/mecha/Jijiamingren_ji_aoyi.swf\",\n      \"/public/ninja-native-lite/v1/mecha/Jijiamingren_liandan_pugong3.swf\",\n      \"/public/ninja-native-lite/v1/mecha/Jijiamingren_luoxuanwan_zhuida.swf\",\n      \"/public/ninja-native-lite/v1/mecha/Jijiamingren_qianghua_pugong.swf\",\n      \"/public/ninja-native-lite/v1/mecha/Jijiamingren_shanbi.swf\",\n      \"/public/ninja-native-lite/v1/mecha/Jijiamingren_jiuweilama_weisouyu.swf\",\n      \"/public/ninja-native-lite/v1/mecha/Jijiamingren_jiuweilama_zhuaji.swf\",\n      \"/public/ninja-native-lite/v1/mecha/Jijiamingren_jiuweilama_hengsao.swf\"\n    ]\n  },\n  \"itachi\": {\n    \"clips\": {\n      \"YuzhiboyoRZZL_Huanshuxielunyan-27\": {\n        \"url\": \"/public/ninja-native-lite/v1/itachi/YuzhiboyoRZZL_Huanshuxielunyan.swf\",\n        \"symbol\": \"shang\",\n        \"width\": 274.11764705882354,\n        \"height\": 285.88235294117646,\n        \"pivot\": [\n          0.5190236051502145,\n          1.1208744855967079\n        ],\n        \"duration\": 2360,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239\": {\n        \"url\": \"/public/ninja-native-lite/v1/itachi/YuzhiboyoRZZL_Huanshuxielunyan_shouji.swf\",\n        \"symbol\": \"shang\",\n        \"width\": 464.7058823529412,\n        \"height\": 409.4117647058824,\n        \"pivot\": [\n          0.4781012658227848,\n          0.6919899425287356\n        ],\n        \"duration\": 1600,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"YuzhiboyoRZZL_Yafenshenzhishu-40\": {\n        \"url\": \"/public/ninja-native-lite/v1/itachi/YuzhiboyoRZZL_Yafenshenzhishu.swf\",\n        \"symbol\": \"shang\",\n        \"width\": 375.29411764705884,\n        \"height\": 254.11764705882354,\n        \"pivot\": [\n          0.5348432601880878,\n          0.9090972222222222\n        ],\n        \"duration\": 2320,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"YuzhiboyoRZZL_Yongbingjituan_QY-1257\": {\n        \"url\": \"/public/ninja-native-lite/v1/itachi/YuzhiboyoRZZL_Yongbingjituan_QY.swf\",\n        \"symbol\": \"shang\",\n        \"width\": 1250.0,\n        \"height\": 650.0,\n        \"pivot\": [\n          0.26,\n          0.6923076923076923\n        ],\n        \"duration\": 7240,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"YuzhiboyoRZZL_Yongbingjituan_QY-227\": {\n        \"url\": \"/public/ninja-native-lite/v1/itachi/YuzhiboyoRZZL_Yongbingjituan_QY.swf\",\n        \"symbol\": \"xia\",\n        \"width\": 1250.0,\n        \"height\": 650.0,\n        \"pivot\": [\n          0.26,\n          0.6923076923076923\n        ],\n        \"duration\": 7240,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"YuzhiboyoRZZL_Yongbingjituan_NZ-213\": {\n        \"url\": \"/public/ninja-native-lite/v1/itachi/YuzhiboyoRZZL_Yongbingjituan_NZ.swf\",\n        \"symbol\": \"xia\",\n        \"width\": 1250.0,\n        \"height\": 650.0,\n        \"pivot\": [\n          0.26,\n          0.6923076923076923\n        ],\n        \"duration\": 5600,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"YuzhiboyoRZZL_Yongbingjituan_NZ-879\": {\n        \"url\": \"/public/ninja-native-lite/v1/itachi/YuzhiboyoRZZL_Yongbingjituan_NZ.swf\",\n        \"symbol\": \"shang\",\n        \"width\": 1250.0,\n        \"height\": 650.0,\n        \"pivot\": [\n          0.26,\n          0.6923076923076923\n        ],\n        \"duration\": 5600,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"YuzhiboyoRZZL_Yongbingjituan_LB-1640\": {\n        \"url\": \"/public/ninja-native-lite/v1/itachi/YuzhiboyoRZZL_Yongbingjituan_LB.swf\",\n        \"symbol\": \"shang\",\n        \"width\": 1250.0,\n        \"height\": 650.0,\n        \"pivot\": [\n          0.26,\n          0.6923076923076923\n        ],\n        \"duration\": 7760,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"YuzhiboyoRZZL_Yongbingjituan_LB-266\": {\n        \"url\": \"/public/ninja-native-lite/v1/itachi/YuzhiboyoRZZL_Yongbingjituan_LB.swf\",\n        \"symbol\": \"xia\",\n        \"width\": 1250.0,\n        \"height\": 650.0,\n        \"pivot\": [\n          0.26,\n          0.6923076923076923\n        ],\n        \"duration\": 7760,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"YuzhiboyoRZZL_Yongbingjituan_SB-1795\": {\n        \"url\": \"/public/ninja-native-lite/v1/itachi/YuzhiboyoRZZL_Yongbingjituan_SB.swf\",\n        \"symbol\": \"shang\",\n        \"width\": 1250.0,\n        \"height\": 650.0,\n        \"pivot\": [\n          0.26,\n          0.6923076923076923\n        ],\n        \"duration\": 5840,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"YuzhiboyoRZZL_Yongbingjituan_SB-348\": {\n        \"url\": \"/public/ninja-native-lite/v1/itachi/YuzhiboyoRZZL_Yongbingjituan_SB.swf\",\n        \"symbol\": \"xia\",\n        \"width\": 1250.0,\n        \"height\": 650.0,\n        \"pivot\": [\n          0.26,\n          0.6923076923076923\n        ],\n        \"duration\": 5840,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"YuzhiboyoRZZL_Yongbingjituan_SB_zhen-4\": {\n        \"url\": \"/public/ninja-native-lite/v1/itachi/YuzhiboyoRZZL_Yongbingjituan_SB_zhen.swf\",\n        \"symbol\": \"shang\",\n        \"width\": 131.76470588235296,\n        \"height\": 125.88235294117648,\n        \"pivot\": [\n          0.5031696428571428,\n          1.1498831775700935\n        ],\n        \"duration\": 960,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293\": {\n        \"url\": \"/public/ninja-native-lite/v1/itachi/YuzhiboyoRZZL_Yongbingjituan_SB_shouji.swf\",\n        \"symbol\": \"shang\",\n        \"width\": 1751.6346470588235,\n        \"height\": 2195.6423152547927,\n        \"pivot\": [\n          0.5022490756449379,\n          0.6336523421604101\n        ],\n        \"duration\": 2000,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91\": {\n        \"url\": \"/public/ninja-native-lite/v1/itachi/YuzhiboyoRZZL_Yongbingjituan_SB_shouji.swf\",\n        \"symbol\": \"xia\",\n        \"width\": 1976.148882352941,\n        \"height\": 1508.057882352941,\n        \"pivot\": [\n          0.4928413199160304,\n          0.7170646125924953\n        ],\n        \"duration\": 2000,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      }\n    },\n    \"urls\": [\n      \"/public/ninja-native-lite/v1/itachi/YuzhiboyoRZZL_Huanshuxielunyan.swf\",\n      \"/public/ninja-native-lite/v1/itachi/YuzhiboyoRZZL_Huanshuxielunyan_shouji.swf\",\n      \"/public/ninja-native-lite/v1/itachi/YuzhiboyoRZZL_Yafenshenzhishu.swf\",\n      \"/public/ninja-native-lite/v1/itachi/YuzhiboyoRZZL_Yongbingjituan_QY.swf\",\n      \"/public/ninja-native-lite/v1/itachi/YuzhiboyoRZZL_Yongbingjituan_NZ.swf\",\n      \"/public/ninja-native-lite/v1/itachi/YuzhiboyoRZZL_Yongbingjituan_LB.swf\",\n      \"/public/ninja-native-lite/v1/itachi/YuzhiboyoRZZL_Yongbingjituan_SB.swf\",\n      \"/public/ninja-native-lite/v1/itachi/YuzhiboyoRZZL_Yongbingjituan_SB_zhen.swf\",\n      \"/public/ninja-native-lite/v1/itachi/YuzhiboyoRZZL_Yongbingjituan_SB_shouji.swf\"\n    ]\n  },\n  \"gaara\": {\n    \"clips\": {\n      \"Yzwoailuo_pugong-424\": {\n        \"url\": \"/public/ninja-native-lite/v1/gaara/Yzwoailuo_pugong.swf\",\n        \"symbol\": \"shang\",\n        \"width\": 3448.2081176470588,\n        \"height\": 2039.2918320772058,\n        \"pivot\": [\n          0.43379413873920336,\n          0.5327624018214182\n        ],\n        \"duration\": 2240,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"Yzwoailuo_pugong-81\": {\n        \"url\": \"/public/ninja-native-lite/v1/gaara/Yzwoailuo_pugong.swf\",\n        \"symbol\": \"xia\",\n        \"width\": 1252.2790588235293,\n        \"height\": 566.1899999999999,\n        \"pivot\": [\n          0.5830309200016686,\n          0.4272745690232857\n        ],\n        \"duration\": 2240,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"Yzwoailuo_beidong2-124\": {\n        \"url\": \"/public/ninja-native-lite/v1/gaara/Yzwoailuo_beidong2.swf\",\n        \"symbol\": \"shang\",\n        \"width\": 1058.8235294117646,\n        \"height\": 682.3529411764706,\n        \"pivot\": [\n          0.04237777777777778,\n          0.5167241379310344\n        ],\n        \"duration\": 1760,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"Yzwoailuo_beidong2-38\": {\n        \"url\": \"/public/ninja-native-lite/v1/gaara/Yzwoailuo_beidong2.swf\",\n        \"symbol\": \"xia\",\n        \"width\": 916.4705882352941,\n        \"height\": 382.3529411764706,\n        \"pivot\": [\n          -0.011784338896020539,\n          0.5076384615384615\n        ],\n        \"duration\": 1760,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"Woailuoyongzhuang_shazhikai-23\": {\n        \"url\": \"/public/ninja-native-lite/v1/gaara/Woailuoyongzhuang_shazhikai.swf\",\n        \"symbol\": \"b1\",\n        \"width\": 348.2352941176471,\n        \"height\": 300.0,\n        \"pivot\": [\n          0.47402027027027027,\n          0.8938333333333331\n        ],\n        \"duration\": 680,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"Woailuoyongzhuang_shazhikai-34\": {\n        \"url\": \"/public/ninja-native-lite/v1/gaara/Woailuoyongzhuang_shazhikai.swf\",\n        \"symbol\": \"b3\",\n        \"width\": 252.94117647058823,\n        \"height\": 257.6470588235294,\n        \"pivot\": [\n          0.4299883720930232,\n          0.8374429223744293\n        ],\n        \"duration\": 640,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"Woailuoyongzhuang_shazhikai-35\": {\n        \"url\": \"/public/ninja-native-lite/v1/gaara/Woailuoyongzhuang_shazhikai.swf\",\n        \"symbol\": \"b2\",\n        \"width\": 230.58823529411765,\n        \"height\": 248.23529411764707,\n        \"pivot\": [\n          0.47167091836734687,\n          0.8691943127962085\n        ],\n        \"duration\": 600,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"GAR_shazhidun-36\": {\n        \"url\": \"/public/ninja-native-lite/v1/gaara/GAR_shazhidun.swf\",\n        \"symbol\": \"bt\",\n        \"width\": 344.70588235294116,\n        \"height\": 309.4117647058824,\n        \"pivot\": [\n          0.479684300341297,\n          0.8604182509505702\n        ],\n        \"duration\": 1120,\n        \"rate\": 24,\n        \"soft\": false,\n        \"additive\": false\n      },\n      \"Yzwoailuo_aoyi-159\": {\n        \"url\": \"/public/ninja-native-lite/v1/gaara/Yzwoailuo_aoyi.swf\",\n        \"symbol\": \"xia\",\n        \"width\": 2233.0,\n        \"height\": 1030.36376953125,\n        \"pivot\": [\n          0.45776981639050607,\n          0.5589320388349515\n        ],\n        \"duration\": 4240,\n        \"rate\": 24,\n        \"soft\": true,\n        \"additive\": false\n      },\n      \"Yzwoailuo_aoyi-432\": {\n        \"url\": \"/public/ninja-native-lite/v1/gaara/Yzwoailuo_aoyi.swf\",\n        \"symbol\": \"shang\",\n        \"width\": 3463.5,\n        \"height\": 2039.54150390625,\n        \"pivot\": [\n          0.4793417063663924,\n          0.5322794117647058\n        ],\n        \"duration\": 4240,\n        \"rate\": 24,\n        \"soft\": true,\n        \"additive\": false\n      }\n    },\n    \"urls\": [\n      \"/public/ninja-native-lite/v1/gaara/Yzwoailuo_pugong.swf\",\n      \"/public/ninja-native-lite/v1/gaara/Yzwoailuo_beidong2.swf\",\n      \"/public/ninja-native-lite/v1/gaara/Woailuoyongzhuang_shazhikai.swf\",\n      \"/public/ninja-native-lite/v1/gaara/GAR_shazhidun.swf\",\n      \"/public/ninja-native-lite/v1/gaara/Yzwoailuo_aoyi.swf\"\n    ]\n  }\n}\n");
         return FFourNinjaNativeManifest;
      }
      public static function PreloadFourNinjaNative(character:String) : void {
         for each(var url:String in FourNinjaNativeManifest()[character].urls)LoadFourNinjaNative(url);
      }
      public static function LoadFourNinjaNative(url:String) : void {
         if(FFourNinjaNativeCache[url]!=null)return;
         var entry:Object={};var loader:Loader=new Loader();entry.loader=loader;FFourNinjaNativeCache[url]=entry;
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(event:Event):void {
            entry.domain=loader.contentLoaderInfo.applicationDomain;
            if(loader.content is MovieClip)MovieClip(loader.content).stop();
         });
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(event:IOErrorEvent):void {delete FFourNinjaNativeCache[url];});
         loader.load(new URLRequest(url),new flash.system.LoaderContext(false,new flash.system.ApplicationDomain()));
      }
      public function PlayFourNinjaNative(character:String,name:String,host:DisplayObjectContainer,point:Point,width:Number,height:Number,delay:int,mirrored:Boolean,follow:Boolean,behind:Boolean,angle:Number,layers:Array) : void {
         var meta:Object=FourNinjaNativeManifest()[character].clips[name];
         if(meta==null || host==null || host.stage==null)return;
         LoadFourNinjaNative(meta.url);
         var caster:ProbeRole=this;var layer:Sprite=new Sprite();layer.name=character+"SkillVfx";layer.mouseEnabled=false;layer.mouseChildren=false;
         layers.push(layer);
         if(behind && host.parent!=null){var field:DisplayObject=host;var outer:DisplayObjectContainer=host.parent;point=outer.globalToLocal(host.localToGlobal(point));host=outer;host.addChildAt(layer,host.getChildIndex(field));}
         else host.addChild(layer);
         var view:Sprite=new Sprite();layer.addChild(view);
         // Match the original cropped raster rectangle in source coordinates.
         // scrollRect moves its top-left to zero, so restore the old pivot once.
         view.scrollRect=new Rectangle(-Number(meta.width)*Number(meta.pivot[0]),-Number(meta.height)*Number(meta.pivot[1]),Number(meta.width),Number(meta.height));
         view.scaleX=width/Number(meta.width);view.scaleY=height/Number(meta.height);
         view.x=-width*Number(meta.pivot[0]);view.y=-height*Number(meta.pivot[1]);
         if(meta.additive)view.blendMode="add";
         if(meta.tint!=null)view.transform.colorTransform=new ColorTransform(meta.tint[0],meta.tint[1],meta.tint[2],1);
         if(meta.soft){
            var maskShape:Sprite=new Sprite();var gradient:Matrix=new Matrix();
            gradient.createGradientBox(width,height,0,-width*Number(meta.pivot[0]),-height*Number(meta.pivot[1]));
            maskShape.graphics.beginGradientFill(GradientType.RADIAL,[16777215,16777215],[1,0],[175,255],gradient);
            maskShape.graphics.drawRect(-width*Number(meta.pivot[0]),-height*Number(meta.pivot[1]),width,height);maskShape.graphics.endFill();
            view.cacheAsBitmap=true;maskShape.cacheAsBitmap=true;layer.addChild(maskShape);view.mask=maskShape;
         }
         var movie:MovieClip=null;var serial:uint=FCombatVfxSerial;var skill:int=FSkillId;var start:int=Math.max(0,FFrameIndex);var last:int=-1;
         var tick:Function;var cleanup:Function;var cleaned:Boolean=false;
         cleanup=function(event:Event=null):void {
            if(cleaned || event!=null && event.target!=layer)return;cleaned=true;
            layer.removeEventListener(Event.ENTER_FRAME,tick);layer.removeEventListener(Event.REMOVED_FROM_STAGE,cleanup);
            if(movie!=null)movie.stop();view.mask=null;view.scrollRect=null;
            if(layer.parent!=null && (event==null || event.type!=Event.REMOVED_FROM_STAGE))layer.parent.removeChild(layer);
         };
         tick=function(event:Event=null):void {
            if(host.stage==null || caster.stage==null || caster.FCombatVfxSerial!=serial || caster.FSkillId!=skill){cleanup();return;}
            var elapsed:int=(Math.max(0,caster.FFrameIndex)-start)*40-delay;
            if(elapsed>=Number(meta.duration)){cleanup();return;}
            if(elapsed<0){layer.visible=false;return;}
            var entry:Object=FFourNinjaNativeCache[meta.url];
            if(entry==null || entry.domain==null){layer.visible=false;return;}
            if(movie==null){
               if(!entry.domain.hasDefinition(meta.symbol)){cleanup();return;}
               var type:Class=entry.domain.getDefinition(meta.symbol) as Class;movie=new type() as MovieClip;if(ExternalInterface.available)ExternalInterface.call("vfxProbe","NATIVE_LAYER "+character+" "+name);movie.stop();view.addChild(movie);
            }
            var frame:int=Math.min(movie.totalFrames,Math.round(elapsed*Number(meta.rate)/1000)+1);
            if(frame!=last){movie.gotoAndStop(frame);last=frame;}
            layer.visible=true;
            if(follow){
               var offset:Point=character=="gaara"?caster.GaaraStrikeOffset():new Point();
               point=host.globalToLocal(caster.localToGlobal(new Point(character=="gaara"?offset.x+70:0,offset.y)));
            }
            layer.x=point.x;layer.y=point.y;layer.scaleX=mirrored?-1:1;layer.rotation=angle;
            var duration:Number=Number(meta.duration);var fade:Number=Math.min(80,duration/4);
            layer.alpha=Math.min(1,(elapsed+40)/fade,Math.max(0,(duration-elapsed)/Math.min(120,duration/4)));
         };
         layer.addEventListener(Event.ENTER_FRAME,tick);layer.addEventListener(Event.REMOVED_FROM_STAGE,cleanup);tick();
      }
 public function GaaraStrikeOffset():Point{return new Point();}

 }
}