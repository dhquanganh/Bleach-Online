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
  private var skills:Array=[13122601, 13122602, 13122603, 13122604, 13122605, 13122606, 13122607, 13122608, 13122609, 13122610, 13122611];
  private var clipNames:Array=["manda", "standard", "standard2", "standard3", "chase", "seal", "additionalSeal", "serpent", "additionalSerpent", "evade", "revive"];
  private var metadata:Object={"idle":{"assets":[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37],"loop":true,"duration":40,"sourceAction":"C_idle","hitFrames":[19]},"run":{"assets":[38,39,40,41],"loop":true,"duration":40,"sourceAction":"C_run1_2","hitFrames":[2]},"hit":{"assets":[42,43,44,45,46,47,48,0],"loop":false,"duration":40,"sourceAction":"D_stand_behit1","hitFrames":[3],"returnFrame":7},"dead":{"assets":[49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,76],"loop":false,"duration":40,"sourceAction":"C_dead","hitFrames":[14],"returnFrame":28},"entry":{"assets":[77,78,79,80,81,82,83,84,85,86,87,88,89,90,0],"loop":false,"duration":40,"sourceAction":"C_entry","hitFrames":[7],"returnFrame":14},"manda":{"assets":[91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,0],"loop":false,"duration":40,"sourceAction":"SP_skill1","hitFrames":[135,145,151],"returnFrame":253},"standard":{"assets":[344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360,361,362,363,364,365,366,367,368,369,370,371,372,373,374,375,376,377,378,379,380,381,382,383,384,385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,400,401,402,403,404,405,406,407,408,409,410,411,0],"loop":false,"duration":40,"sourceAction":"A_1hit","hitFrames":[9,16,32],"returnFrame":68},"standard2":{"assets":[412,413,414,415,416,417,418,419,420,421,422,423,424,425,426,427,428,429,430,431,432,433,434,435,436,437,438,439,440,441,442,443,444,445,446,447,448,449,450,451,452,453,454,455,456,457,458,459,460,461,462,463,464,465,466,467,468,469,470,471,472,473,474,475,476,477,478,479,480,481,482,483,484,485,0],"loop":false,"duration":40,"sourceAction":"A_2hit","hitFrames":[9,16,32,51],"returnFrame":74},"standard3":{"assets":[486,487,488,489,490,491,492,493,494,495,496,497,498,499,500,501,502,503,504,505,506,507,508,509,510,511,512,513,514,515,516,517,518,519,520,521,522,523,524,525,526,527,528,529,530,531,532,533,534,535,536,537,538,539,540,541,542,543,544,545,546,547,548,549,550,551,552,553,554,555,556,557,558,559,560,561,562,563,564,565,566,567,568,569,570,571,572,573,574,575,576,577,578,579,580,581,582,583,584,585,586,587,588,589,590,591,592,593,594,595,596,597,598,0],"loop":false,"duration":40,"sourceAction":"A_3hit","hitFrames":[9,16,32,51,77,79],"returnFrame":113},"chase":{"assets":[599,600,601,602,603,604,605,606,607,608,609,610,611,612,613,614,615,616,617,618,619,620,621,622,623,624,625,626,627,628,629,630,631,632,633,634,635,636,637,638,639,640,641,642,643,644,645,646,647,648,649,650,651,652,653,654,655,656,657,658,659,660,0],"loop":false,"duration":40,"sourceAction":"SP_skill3","hitFrames":[31,34,38,41],"returnFrame":62},"seal":{"assets":[661,662,663,664,665,666,667,668,669,670,671,672,673,674,675,676,677,678,679,680,681,682,683,684,685,686,687,688,689,690,691,692,693,694,695,696,697,0],"loop":false,"duration":40,"sourceAction":"SP_skill4","hitFrames":[8],"returnFrame":37},"additionalSeal":{"assets":[698,699,700,701,702,703,704,705,706,707,708,709,710,711,712,713,714,715,716,717,718,719,720,721,722,723,724,725,726,727,728,729,730,731,732,733,734,0],"loop":false,"duration":40,"sourceAction":"SP_skill4","hitFrames":[8],"returnFrame":37},"serpent":{"assets":[735,736,737,738,739,740,741,742,743,744,745,746,747,748,749,750,751,752,753,754,755,756,757,758,759,760,761,762,763,764,765,766,767,768,769,770,771,772,773,774,775,776,777,778,779,780,781,782,783,784,785,786,787,788,789,790,791,792,793,794,795,796,797,798,799,800,801,802,803,804,805,806,807,808,809,810,811,812,813,814,815,816,817,818,819,820,821,822,823,824,825,826,827,828,829,830,831,832,833,834,835,836,837,838,839,840,841,842,843,844,845,846,847,848,849,850,851,852,853,854,855,856,857,858,859,860,861,862,863,864,865,866,867,868,869,870,871,872,873,874,875,876,877,878,879,880,881,882,883,884,885,886,887,888,889,890,891,892,893,894,895,896,897,898,899,900,901,902,903,904,905,906,907,908,0],"loop":false,"duration":40,"sourceAction":"SP_skill2","hitFrames":[114,119,124],"returnFrame":174},"additionalSerpent":{"assets":[909,910,911,912,913,914,915,916,917,918,919,920,921,922,923,924,925,926,927,928,929,930,931,932,933,934,935,936,937,938,939,940,941,942,943,944,945,946,947,948,949,950,951,952,953,954,955,956,957,958,959,960,961,962,963,964,965,966,967,968,969,970,971,972,973,974,975,976,977,978,979,980,981,982,983,984,985,986,987,988,989,990,991,992,993,994,995,996,997,998,999,1000,1001,1002,1003,1004,1005,1006,1007,1008,1009,1010,1011,1012,1013,1014,1015,1016,1017,1018,1019,1020,1021,1022,1023,1024,1025,1026,1027,1028,1029,1030,1031,1032,1033,1034,1035,1036,1037,1038,1039,1040,1041,1042,1043,1044,1045,1046,1047,1048,1049,1050,1051,1052,1053,1054,1055,1056,1057,1058,1059,1060,1061,1062,1063,1064,1065,1066,1067,1068,1069,1070,1071,1072,1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,0],"loop":false,"duration":40,"sourceAction":"SP_skill2","hitFrames":[114,119,124],"returnFrame":174},"evade":{"assets":[1083,1084,1085,1086,1087,1088,1089,1090,1091,1092,1093,1094,1095,1096,1097,1098,1099,1100,1101,1102,1103,1104,1105,1106,1107,1108,1109,1110,1111,1112,1113,1114,1115,1116,1117,1118,1119,1120,1121,1122,1123,1124,1125,0],"loop":false,"duration":40,"sourceAction":"SP_skill5","hitFrames":[15],"returnFrame":43},"revive":{"assets":[1126,1127,1128,1129,1130,1131,1132,1133,1134,1135,1136,1137,1138,1139,1140,1141,1142,1143,1144,1145,1146,1147,1148,1149,1150,1151,1152,1153,1154,1155,1156,1157,1158,1159,1160,1161,1162,1163,0],"loop":false,"duration":40,"sourceAction":"SP_skill6","hitFrames":[0],"returnFrame":38}};
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
   loadTexture("00A9B171",["idle"]);
   loadTexture("A9B1710B",["standard","standard2","standard3"]);
   loadTexture("A9B1710C",["manda","chase","seal","additionalSeal","serpent","additionalSerpent","evade","revive","entry","dead"]);
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
   var clip:Object=clips[name];if(clip==null)return;index=Math.max(0,Math.min(index,clip.images.length-1));role.actor.bitmapData=clip.images[index];role.actor.x=-clip.meta[index].px;role.actor.y=-clip.meta[index].py;role.OrochimaruStrikePose({Pivot:{X:clip.meta[index].px,Y:clip.meta[index].py}});
  }
  private function tick(event:Event):void {
   for each(var decoder:TPakDecoder in decoders)if(decoder.Unstreamizing)decoder.Process();if(loaded<14)return;
   if(readyAt<0){clips["clone-idle"]=clips.idle;clips["clone-standard"]=clips.standard;clips["clone-counter"]=clips.counter;readyAt=getTimer()+4000;ProbeRole.PreloadOrochimaruNative();}if(getTimer()<readyAt)return;
   var age:int=getTimer()-readyAt;var bounds:Array=[0, 11160, 14920, 18920, 24480, 28000, 30520, 33040, 41040, 49040, 51800, 54360, 65520, 69280, 73280, 78840, 82360, 84880, 87400, 95400, 103400, 106160, 108720];var slot:int=0;while(slot<22 && age>=bounds[slot+1])slot++;
   if(slot>=22){left.FSkillId=0;right.FSkillId=0;left.ClearOrochimaruVfx();right.ClearOrochimaruVfx();var remaining:int=0;for(var q:int=0;q<battle.numChildren;q++)if(battle.getChildAt(q).name=="orochimaruSkillVfx")remaining++;report("DONE Orochimaru New Year native component; remaining="+remaining);removeEventListener(Event.ENTER_FRAME,tick);return;}
   var side:int=slot<11?0:1;var index:int=slot%11;var caster:ProbeRole=side==0?left:right;var victim:ProbeRole=side==0?right:left;
   caster.Camp=side;victim.Camp=1-side;
   caster.FTargets=[caster,victim];caster.FResults=[{CMD:0,ResultInfo:{HurtHp:0}},{CMD:1,ResultInfo:{HurtHp:index==6?-300:10}}];
   if(lastSlot!=slot){left.ClearOrochimaruVfx();right.ClearOrochimaruVfx();left.FSkillId=0;right.FSkillId=0;++caster.FCombatVfxSerial;caster.FSkillId=skills[index];caster.FId=(index==6||index>=10)?11121009:11121009;caster.FFrameIndex=0;caster.y=440;victim.y=440;lastSlot=slot;label.text="Orochimaru New Year | "+clipNames[index]+" | camp "+side;report("CASE "+skills[index]+" camp="+side);}
   var frame:int=int((age-bounds[slot])/40);var name:String=clipNames[index];caster.FFrameIndex=frame;
   if(frame<clips[name].images.length){renderRole(caster,name,frame);caster.UpdateOrochimaruVfx();}else{caster.FSkillId=0;renderRole(caster,"idle",int(age/100)%clips.idle.images.length);}
   renderRole(victim,"idle",int(age/100)%clips.idle.images.length);
   var phases:Array=name=="manda"||name=="serpent"?[4,16,32,48,60,72,84,100,114,135,145,155]:[4,int(clips[name].images.length*.4),int(clips[name].images.length*.7)];
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
 public var FId:int=11121009;public var FSkillId:int=0;public var FIndex:int=1;public var FFrameIndex:int=0;public var Camp:int=0;public var Pos:int=1;
 public const TYPE_ACTIVE_ATTACK:int=1;public const TYPE_ACTIVE_SKILL:int=2;
 public static var FOrochimaruNative:Object={};public var FOrochimaruVfxStarted:Boolean=false;public var FOrochimaruLayers:Array=[];public var FCombatVfxSerial:uint=0;
 public var FBattleStage:Sprite;public var FTargets:Array=[];public var FResults:Array=[];public var actor:Bitmap=new Bitmap();public function get FBitmap():Bitmap{return actor;}
 public function ProbeRole(){actor.smoothing=true;addChild(actor);}
      public static function PreloadOrochimaruNative() : void {
         for each(var effect:String in ["Dashewanxinchun_baqizhishu", "Dashewanxinchun_baqizhishu_texie", "Dashewanxinchun_fengdundatupo", "Dashewanxinchun_qianyingduosheshou1", "Dashewanxinchun_qianyingduosheshou2", "Dashewanxinchun_qianyingduosheshou3", "Dashewanxinchun_tonglingzhishujushe", "Dashewanxinchun_tonglingzhishujushe_texie", "Dashewanxinchun_tutishenshu", "Dashewanxinchun_wuxingfengyin", "Dashewanxinchun_wuxingfengyin_BUFF", "DASHEWAN_tongyongfuhuo"])LoadOrochimaruNative(effect);
      }
      public static function LoadOrochimaruNative(effect:String) : void {
         if(FOrochimaruNative[effect]!=null)return;
         var state:Object={};FOrochimaruNative[effect]=state;var loader:Loader=new Loader();state.loader=loader;
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(event:Event):void{state.domain=loader.contentLoaderInfo.applicationDomain;if(loader.content is MovieClip)MovieClip(loader.content).stop();});
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(event:IOErrorEvent):void{delete FOrochimaruNative[effect];});
         loader.load(new URLRequest("/public/orochimaru-new-year-vfx/native/"+effect+".swf"),new flash.system.LoaderContext(false,new flash.system.ApplicationDomain()));
      }
      public function ClearOrochimaruVfx() : void {
         for each(var layer:Sprite in FOrochimaruLayers)if(layer.parent!=null)layer.parent.removeChild(layer);
         FOrochimaruLayers=[];FOrochimaruVfxStarted=false;
      }
      public function UpdateOrochimaruVfx() : void {
         if((FId!=11121009 && FId!=11121009) || FOrochimaruVfxStarted || (FIndex!=TYPE_ACTIVE_ATTACK && FIndex!=TYPE_ACTIVE_SKILL))return;
         FOrochimaruVfxStarted=true;
         if(FSkillId==13122611){PlayOrochimaruNative("DASHEWAN_tongyongfuhuo","tyfh");return;}
         var mapping:Object=JSON.parse("{\"13122601\":\"Dashewanxinchun_tonglingzhishujushe\",\"13122602\":\"Dashewanxinchun_qianyingduosheshou1\",\"13122603\":\"Dashewanxinchun_qianyingduosheshou2\",\"13122604\":\"Dashewanxinchun_qianyingduosheshou3\",\"13122605\":\"Dashewanxinchun_fengdundatupo\",\"13122606\":\"Dashewanxinchun_wuxingfengyin\",\"13122607\":\"Dashewanxinchun_wuxingfengyin\",\"13122608\":\"Dashewanxinchun_baqizhishu\",\"13122609\":\"Dashewanxinchun_baqizhishu\",\"13122610\":\"Dashewanxinchun_tutishenshu\"}");var effect:String=mapping[String(FSkillId)];
         if(effect!=null){PlayOrochimaruNative(effect,"xia");PlayOrochimaruNative(effect,"shang");}
         if(FSkillId==13122601)PlayOrochimaruNative("Dashewanxinchun_tonglingzhishujushe_texie","texie");
         if(FSkillId==13122608||FSkillId==13122609)PlayOrochimaruNative("Dashewanxinchun_baqizhishu_texie","texie");
      }
      public function OrochimaruContactOffset() : Point {
         return new Point();
      }
      public function OrochimaruStrikePose(frame:Object) : void {
         if((FId!=11121009 && FId!=11121009) || frame==null || (FIndex!=TYPE_ACTIVE_ATTACK && FIndex!=TYPE_ACTIVE_SKILL))return;
         var offset:Point=OrochimaruContactOffset();FBitmap.x=-frame.Pivot.X+offset.x;FBitmap.y=-frame.Pivot.Y+offset.y;
      }
      public function PlayOrochimaruNative(effect:String,symbol:String,target:ProbeRole=null,startFrame:int=0) : void {
         LoadOrochimaruNative(effect);
         var caster:ProbeRole=this;var host:DisplayObjectContainer=FBattleStage;if(host==null || stage==null)return;
         var layer:Sprite=new Sprite();layer.name="orochimaruSkillVfx";layer.mouseEnabled=false;layer.mouseChildren=false;
         layer.blendMode=symbol=="texie"?"screen":"normal";
         if(symbol=="xia" && parent==host)host.addChildAt(layer,host.getChildIndex(this));else host.addChild(layer);
         FOrochimaruLayers.push(layer);
         var clip:MovieClip=null;var serial:uint=FCombatVfxSerial;var skill:uint=FSkillId;var last:int=-1;var tick:Function;var clear:Function;var cleaned:Boolean=false;
         clear=function(event:Event=null):void{if(cleaned || event!=null && event.target!=layer)return;cleaned=true;layer.removeEventListener(Event.ENTER_FRAME,tick);layer.removeEventListener(Event.REMOVED_FROM_STAGE,clear);if(clip!=null)clip.stop();if(layer.parent!=null)layer.parent.removeChild(layer);};
         tick=function(event:Event=null):void{
            if(host.stage==null || caster.stage==null || caster.FCombatVfxSerial!=serial || caster.FSkillId!=skill || (caster.FIndex!=TYPE_ACTIVE_ATTACK && caster.FIndex!=TYPE_ACTIVE_SKILL)){clear();return;}
            var state:Object=FOrochimaruNative[effect];if(state==null || state.domain==null){layer.visible=false;return;}
            if(clip==null){if(!state.domain.hasDefinition(symbol)){clear();return;}var type:Class=state.domain.getDefinition(symbol) as Class;clip=new type() as MovieClip;clip.stop();layer.addChild(clip);}
            if(caster.FFrameIndex<startFrame){layer.visible=false;return;}
            var rate:Number=24;var frame:int=Math.round(Math.max(0,caster.FFrameIndex-startFrame)*rate/25)+1;
            if(frame>clip.totalFrames){clear();return;}
            layer.visible=true;if(frame!=last){clip.gotoAndStop(frame);last=frame;}
            var offset:Point=caster.OrochimaruContactOffset();var originX:Number=70*0.84;
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