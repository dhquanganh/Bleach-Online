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
  private var skills:Array=[13122313];
  private var clipNames:Array=["final"];
  private var metadata:Object={"idle":{"assets":[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36],"loop":true,"duration":40,"sourceAction":"C_idle","hitFrames":[18]},"run":{"assets":[37,38,39,40],"loop":true,"duration":40,"sourceAction":"C_run1_2","hitFrames":[2]},"hit":{"assets":[41,42,43,44,45,46,47,0],"loop":false,"duration":40,"sourceAction":"D_stand_behit1","hitFrames":[3],"returnFrame":7},"dead":{"assets":[48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,66],"loop":false,"duration":40,"sourceAction":"C_dead","hitFrames":[9],"returnFrame":19},"entry":{"assets":[67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,0],"loop":false,"duration":40,"sourceAction":"C_entry","hitFrames":[11],"returnFrame":22},"bond1":{"assets":[89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,0],"loop":false,"duration":40,"sourceAction":"SP_skill5_1","hitFrames":[16],"returnFrame":42},"bond2":{"assets":[131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,0],"loop":false,"duration":40,"sourceAction":"SP_skill5_2","hitFrames":[16],"returnFrame":42},"bond3":{"assets":[173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,0],"loop":false,"duration":40,"sourceAction":"SP_skill5_3","hitFrames":[16],"returnFrame":42},"bond4":{"assets":[215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,0],"loop":false,"duration":40,"sourceAction":"SP_skill5_4","hitFrames":[16],"returnFrame":42},"bond5":{"assets":[257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,0],"loop":false,"duration":40,"sourceAction":"SP_skill5_5","hitFrames":[16],"returnFrame":42},"bond6":{"assets":[299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,0],"loop":false,"duration":40,"sourceAction":"SP_skill5_6","hitFrames":[16],"returnFrame":42},"bond7":{"assets":[341,342,343,344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360,361,362,363,364,365,366,367,368,369,370,371,372,373,374,375,376,377,378,379,380,381,382,0],"loop":false,"duration":40,"sourceAction":"SP_skill5_7","hitFrames":[16],"returnFrame":42},"bond8":{"assets":[383,384,385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,400,401,402,403,404,405,406,407,408,409,410,411,412,413,414,415,416,417,418,419,420,421,422,423,424,0],"loop":false,"duration":40,"sourceAction":"SP_skill5_8","hitFrames":[16],"returnFrame":42},"bond9":{"assets":[425,426,427,428,429,430,431,432,433,434,435,436,437,438,439,440,441,442,443,444,445,446,447,448,449,450,451,452,453,454,455,456,457,458,459,460,461,462,463,464,465,466,0],"loop":false,"duration":40,"sourceAction":"SP_skill5_9","hitFrames":[16],"returnFrame":42},"claw":{"assets":[467,468,469,470,471,472,473,474,475,476,477,478,479,480,481,482,483,484,485,486,487,488,489,490,491,492,493,494,495,496,497,498,499,500,501,502,503,504,505,506,507,508,509,510,511,512,513,514,515,516,517,518,519,520,521,522,523,524,0],"loop":false,"duration":40,"sourceAction":"A_2hit","hitFrames":[24],"returnFrame":58},"tail":{"assets":[525,526,527,528,529,530,531,532,533,534,535,536,537,538,539,540,541,542,543,544,545,546,547,548,549,550,551,552,553,554,555,556,557,558,559,560,561,562,563,564,565,566,567,568,569,570,571,572,0],"loop":false,"duration":40,"sourceAction":"A_3hit","hitFrames":[20],"returnFrame":48},"bomb":{"assets":[573,574,575,576,577,578,579,580,581,582,583,584,585,586,587,588,589,590,591,592,593,594,595,596,597,598,599,600,601,602,603,604,605,606,607,608,609,610,611,612,613,614,615,616,617,618,619,620,621,622,623,624,625,626,627,628,629,630,631,632,633,634,635,636,637,638,639,640,641,642,643,644,645,646,647,648,649,650,651,652,653,654,655,656,657,658,659,660,661,662,663,664,665,666,667,668,669,670,671,672,673,674,675,676,677,678,679,680,681,682,683,684,685,686,687,688,689,690,691,692,693,694,695,696,697,698,699,700,701,0],"loop":false,"duration":40,"sourceAction":"A_1hit","hitFrames":[44],"returnFrame":129},"final":{"assets":[702,703,704,705,706,707,708,709,710,711,712,713,714,715,716,717,718,719,720,721,722,723,724,725,726,727,728,729,730,731,732,733,734,735,736,737,738,739,740,741,742,743,744,745,746,747,748,749,750,751,752,753,754,755,756,757,758,759,760,761,762,763,764,765,766,767,768,769,770,771,772,773,774,775,776,777,778,779,780,781,782,783,784,785,786,787,788,789,790,791,792,793,794,795,796,797,798,799,800,801,802,803,804,805,806,807,808,809,810,811,812,813,814,815,816,817,818,819,820,821,822,823,824,825,826,827,828,829,830,831,832,833,834,835,836,837,838,839,840,841,842,843,844,845,846,847,848,849,850,851,852,853,854,855,856,857,858,859,860,861,862,863,864,865,866,867,868,869,870,871,872,873,874,875,876,877,878,879,880,881,882,883,884,885,886,887,888,889,890,891,892,893,894,895,896,897,898,899,900,901,902,903,904,905,906,907,908,909,910,911,912,913,914,915,916,917,918,919,920,921,922,923,924,925,926,927,928,929,930,931,932,933,934,935,936,937,938,939,940,941,942,943,944,945,946,947,948,949,950,951,952,953,954,955,956,957,958,959,960,961,962,963,964,965,966,967,968,969,970,971,972,973,974,975,976,977,978,979,980,981,982,983,984,985,986,987,988,989,990,991,992,0],"loop":false,"duration":40,"sourceAction":"SP_skill2","hitFrames":[175,203,212,246],"returnFrame":291},"harem":{"assets":[993,994,995,996,997,998,999,1000,1001,1002,1003,1004,1005,1006,1007,1008,1009,1010,1011,1012,1013,1014,1015,1016,1017,1018,1019,1020,1021,1022,1023,1024,1025,1026,1027,1028,1029,1030,1031,1032,1033,1034,1035,1036,1037,1038,1039,1040,1041,1042,1043,1044,1045,1046,1047,1048,1049,1050,1051,1052,1053,1054,1055,1056,1057,1058,1059,1060,1061,1062,1063,1064,1065,1066,1067,1068,1069,1070,1071,1072,1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,1083,1084,1085,1086,1087,1088,1089,1090,1091,1092,1093,1094,1095,1096,1097,1098,1099,1100,1101,1102,1103,1104,1105,1106,1107,1108,1109,1110,1111,1112,1113,1114,1115,1116,1117,1118,1119,1120,1121,1122,1123,1124,1125,1126,1127,1128,1129,1130,1131,1132,1133,1134,1135,1136,1137,1138,1139,1140,1141,1142,1143,1144,1145,1146,1147,1148,1149,1150,1151,0],"loop":false,"duration":40,"sourceAction":"SP_skill3","hitFrames":[78],"returnFrame":159},"chase":{"assets":[1152,1153,1154,1155,1156,1157,1158,1159,1160,1161,1162,1163,1164,1165,1166,1167,1168,1169,1170,1171,1172,1173,1174,1175,1176,1177,1178,1179,1180,1181,1182,1183,1184,1185,1186,1187,1188,1189,1190,1191,1192,1193,1194,1195,1196,1197,1198,0],"loop":false,"duration":40,"sourceAction":"SP_skill4","hitFrames":[18],"returnFrame":47},"additional":{"assets":[1199,1200,1201,1202,1203,1204,1205,1206,1207,1208,1209,1210,1211,1212,1213,1214,1215,1216,1217,1218,1219,1220,1221,1222,1223,1224,1225,1226,1227,1228,1229,1230,1231,1232,1233,1234,1235,1236,1237,1238,1239,1240,1241,1242,1243,1244,1245,1246,1247,1248,1249,1250,1251,1252,1253,1254,1255,1256,1257,1258,1259,1260,1261,1262,1263,1264,1265,1266,1267,1268,1269,1270,1271,1272,1273,1274,1275,1276,1277,1278,1279,1280,1281,1282,1283,0],"loop":false,"duration":40,"sourceAction":"SP_skill6","hitFrames":[31,38,45],"returnFrame":85},"recovery":{"assets":[1284,1285,1286,1287,1288,1289,1290,1291,1292,1293,1294,1295,1296,1297,1298,1299,1300,1301,1302,1303,1304,1305,1306,1307,1308,1309,1310,1311,1312,1313,1314,1315,1316,1317,1318,1319,1320,0],"loop":false,"duration":40,"sourceAction":"SP_skill7","hitFrames":[0],"returnFrame":37},"restoration":{"assets":[1321,1322,1323,1324,1325,1326,1327,1328,1329,1330,1331,1332,1333,1334,1335,1336,1337,1338,1339,1340,1341,1342,1343,1344,1345,1346,1347,1348,1349,1350,1351,1352,1353,1354,1355,1356,1357,0],"loop":false,"duration":40,"sourceAction":"SP_skill7","hitFrames":[0],"returnFrame":37}};
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
   loadTexture("00A9B16E",["idle"]);
   loadTexture("A9B16E0B",["claw","tail","bomb"]);
   loadTexture("A9B16E0C",["bond1", "bond2", "bond3", "bond4", "bond5", "bond6", "bond7", "bond8", "bond9", "final", "harem", "chase", "additional", "recovery", "restoration", "entry", "dead"]);
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
   var clip:Object=clips[name];if(clip==null)return;index=Math.max(0,Math.min(index,clip.images.length-1));role.actor.bitmapData=clip.images[index];role.actor.x=-clip.meta[index].px;role.actor.y=-clip.meta[index].py;role.NarutoFinalStrikePose({Pivot:{X:clip.meta[index].px,Y:clip.meta[index].py}});
  }
  private function tick(event:Event):void {
   for each(var decoder:TPakDecoder in decoders)if(decoder.Unstreamizing)decoder.Process();if(loaded<21)return;
   if(readyAt<0){clips["clone-idle"]=clips.idle;clips["clone-standard"]=clips.standard;clips["clone-counter"]=clips.counter;readyAt=getTimer()+4000;ProbeRole.PreloadNarutoFinalNative();}if(getTimer()<readyAt)return;
   var age:int=getTimer()-readyAt;var bounds:Array=[0, 12680, 25360];var slot:int=0;while(slot<2 && age>=bounds[slot+1])slot++;
   if(slot>=2){left.FSkillId=0;right.FSkillId=0;left.ClearNarutoFinalVfx();right.ClearNarutoFinalVfx();var remaining:int=0;for(var q:int=0;q<battle.numChildren;q++)if(battle.getChildAt(q).name=="madaraNarutoFinalSkillVfx")remaining++;report("DONE Naruto Final Battle native component; remaining="+remaining);removeEventListener(Event.ENTER_FRAME,tick);return;}
   var side:int=slot<1?0:1;var index:int=slot%1;var caster:ProbeRole=side==0?left:right;var victim:ProbeRole=side==0?right:left;
   caster.Camp=side;victim.Camp=1-side;
   caster.FTargets=[caster,victim];caster.FResults=[{CMD:0,ResultInfo:{HurtHp:0}},{CMD:1,ResultInfo:{HurtHp:index==6?-300:10}}];
   if(lastSlot!=slot){left.ClearNarutoFinalVfx();right.ClearNarutoFinalVfx();left.FSkillId=0;right.FSkillId=0;++caster.FCombatVfxSerial;caster.FSkillId=skills[index];caster.FId=(index==6||index>=10)?11121006:11121006;caster.FFrameIndex=0;caster.y=440;victim.y=440;lastSlot=slot;label.text="Naruto Final Battle | "+clipNames[index]+" | camp "+side;report("CASE "+skills[index]+" camp="+side);}
   var frame:int=int((age-bounds[slot])/40);var name:String=clipNames[index];caster.FFrameIndex=frame;
   if(frame<clips[name].images.length){renderRole(caster,name,frame);caster.UpdateNarutoFinalVfx();}else{caster.FSkillId=0;renderRole(caster,"idle",int(age/100)%clips.idle.images.length);}
   renderRole(victim,"idle",int(age/100)%clips.idle.images.length);
   var phases:Array=name=="mystery"?[4,16,32,48,60,72,84,100]:[4,40,70,90,116,150,175,204,246];
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
 public var FId:int=11121006;public var FSkillId:int=0;public var FIndex:int=1;public var FFrameIndex:int=0;public var Camp:int=0;public var Pos:int=1;
 public const TYPE_ACTIVE_ATTACK:int=1;public const TYPE_ACTIVE_SKILL:int=2;
 public static var FNarutoFinalNative:Object={};public var FNarutoFinalVfxStarted:Boolean=false;public var FNarutoFinalLayers:Array=[];public var FCombatVfxSerial:uint=0;
 public var FBattleStage:Sprite;public var FTargets:Array=[];public var FResults:Array=[];public var actor:Bitmap=new Bitmap();public function get FBitmap():Bitmap{return actor;}
 public function ProbeRole(){actor.smoothing=true;addChild(actor);}
      public static function PreloadNarutoFinalNative() : void
      {
         for each(var effect:String in ["MIngrenZyzz_Cidunfengyin_BUFF","MIngrenZyzz_Duochongweishouyuluoxuanshoulijian","MIngrenZyzz_Jiulamazhili_shou","MIngrenZyzz_Jiulamazhili_tou","MIngrenZyzz_Jiulamazhili_wei","MIngrenZyzz_Liudaochaodayuluoxuanshoulijan","MIngrenZyzz_Liudaochaodayuluoxuanshoulijan_texie","MIngrenZyzz_SeyoushuNihougongshu","MIngrenZyzz_SeyoushuNihougongshu_texie","MIngrenZyzz_Weishouchakelagongming_1","MIngrenZyzz_Weishouchakelagongming_2","MIngrenZyzz_Weishouchakelagongming_3","MIngrenZyzz_Weishouchakelagongming_4","MIngrenZyzz_Weishouchakelagongming_5","MIngrenZyzz_Weishouchakelagongming_6","MIngrenZyzz_Weishouchakelagongming_7","MIngrenZyzz_Weishouchakelagongming_8","MIngrenZyzz_Weishouchakelagongming_9","MIngrenZyzz_Xianfacidunluoxuanwan"])
         {
            LoadNarutoFinalNative(effect);
         }
      }
      public static function LoadNarutoFinalNative(effect:String) : void
      {
         var state:Object;
         var loader:Loader;
         if(FNarutoFinalNative[effect] != null)
         {
            return;
         }
         state = {};
         FNarutoFinalNative[effect] = state;
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
            delete FNarutoFinalNative[effect];
         });
         loader.load(new URLRequest("/public/naruto-final-vfx/native/" + effect + ".swf"),new LoaderContext(false,new ApplicationDomain()));
      }
      public function ClearNarutoFinalVfx() : void
      {
         for each(var layer:Sprite in FNarutoFinalLayers)
         {
            if(layer.parent != null)
            {
               layer.parent.removeChild(layer);
            }
         }
         FNarutoFinalLayers = [];
         FNarutoFinalVfxStarted = false;
      }
      public function UpdateNarutoFinalVfx() : void
      {
         if(FId != 11121006 && FId != 11121006 || FNarutoFinalVfxStarted || FIndex != TYPE_ACTIVE_ATTACK && FIndex != TYPE_ACTIVE_SKILL)
         {
            return;
         }
         FNarutoFinalVfxStarted = true;
         var mapping:Object = JSON.parse("{\"13122301\":\"MIngrenZyzz_Weishouchakelagongming_1\",\"13122302\":\"MIngrenZyzz_Weishouchakelagongming_2\",\"13122303\":\"MIngrenZyzz_Weishouchakelagongming_3\",\"13122304\":\"MIngrenZyzz_Weishouchakelagongming_4\",\"13122305\":\"MIngrenZyzz_Weishouchakelagongming_5\",\"13122306\":\"MIngrenZyzz_Weishouchakelagongming_6\",\"13122307\":\"MIngrenZyzz_Weishouchakelagongming_7\",\"13122308\":\"MIngrenZyzz_Weishouchakelagongming_8\",\"13122309\":\"MIngrenZyzz_Weishouchakelagongming_9\",\"13122310\":\"MIngrenZyzz_Jiulamazhili_shou\",\"13122311\":\"MIngrenZyzz_Jiulamazhili_wei\",\"13122312\":\"MIngrenZyzz_Jiulamazhili_tou\",\"13122313\":\"MIngrenZyzz_Liudaochaodayuluoxuanshoulijan\",\"13122314\":\"MIngrenZyzz_SeyoushuNihougongshu\",\"13122315\":\"MIngrenZyzz_Xianfacidunluoxuanwan\",\"13122316\":\"MIngrenZyzz_Duochongweishouyuluoxuanshoulijian\"}");
         var effect:String = mapping[String(FSkillId)];
         var cutins:Object = JSON.parse("{\"13122313\":\"MIngrenZyzz_Liudaochaodayuluoxuanshoulijan_texie\",\"13122314\":\"MIngrenZyzz_SeyoushuNihougongshu_texie\"}");
         var cutin:String = cutins[String(FSkillId)];
         if(cutin != null)
         {
            PlayNarutoFinalNative(cutin,"texie");
         }
         if(effect != null)
         {
            PlayNarutoFinalNative(effect,"xia");
            PlayNarutoFinalNative(effect,"shang");
         }
         if(FSkillId == 13122315 && FTargets != null && FResults != null)
         {
            var i:int = 0;
            while(i < FTargets.length && i < FResults.length)
            {
               if(FTargets[i] != null && FTargets[i].Camp != Camp && FResults[i].CMD == 1 && FResults[i].ResultInfo.HurtHp > 0)
               {
                  PlayNarutoFinalNative("MIngrenZyzz_Cidunfengyin_BUFF","shang",FTargets[i],20);
               }
               i++;
            }
         }
      }
      public function NarutoFinalContactOffset() : Point
      {
         if(FId != 11121006 || FTargets == null || FResults == null || FIndex != TYPE_ACTIVE_ATTACK && FIndex != TYPE_ACTIVE_SKILL)
         {
            return new Point();
         }
         var distances:Object = JSON.parse("{\"13122310\":570.0,\"13122311\":480.0,\"13122312\":600.0,\"13122314\":530.0,\"13122315\":610.0}");
         if(distances[String(FSkillId)] == null)
         {
            return new Point();
         }
         var enemy:ProbeRole = null;
         var i:int = 0;
         while(i < FTargets.length && i < FResults.length)
         {
            if(FTargets[i] != null && FTargets[i].Camp != Camp && FResults[i].CMD == 1)
            {
               enemy = FTargets[i];
               break;
            }
            i++;
         }
         if(enemy == null)
         {
            return new Point();
         }
         var contact:Point = globalToLocal(enemy.localToGlobal(new Point()));
         var distance:Number = Number(distances[String(FSkillId)]) * 0.84;
         var end:Number = Number(JSON.parse("{\"13122301\":42,\"13122302\":42,\"13122303\":42,\"13122304\":42,\"13122305\":42,\"13122306\":42,\"13122307\":42,\"13122308\":42,\"13122309\":42,\"13122310\":58,\"13122311\":48,\"13122312\":129,\"13122313\":291,\"13122314\":159,\"13122315\":47,\"13122316\":85,\"13122317\":37,\"13122318\":37}")[String(FSkillId)]);
         var phase:Number = Math.min(1,Math.max(0,FFrameIndex / 9),Math.max(0,(end - FFrameIndex) / 9));
         phase = phase * phase * (3 - 2 * phase);
         return new Point((contact.x - distance) * phase,contact.y * phase);
      }
      public function NarutoFinalStrikePose(frame:Object) : void
      {
         if(FId != 11121006 && FId != 11121006 || frame == null || FIndex != TYPE_ACTIVE_ATTACK && FIndex != TYPE_ACTIVE_SKILL)
         {
            return;
         }
         var offset:Point = NarutoFinalContactOffset();
         FBitmap.x = -frame.Pivot.X + offset.x;
         FBitmap.y = -frame.Pivot.Y + offset.y;
      }
      public function PlayNarutoFinalNative(effect:String,symbol:String,target:ProbeRole=null,startFrame:int=0) : void {
         LoadNarutoFinalNative(effect);
         var caster:ProbeRole=this;var host:DisplayObjectContainer=FBattleStage;if(host==null || stage==null)return;
         var backdrop:Sprite=null;
         if(FSkillId==13122313 && symbol=="texie"){
            backdrop=new Sprite();backdrop.name="narutoFinalCinematicBackdrop";backdrop.mouseEnabled=false;
            var corner:Point=host.globalToLocal(stage.localToGlobal(new Point()));
            var farCorner:Point=host.globalToLocal(stage.localToGlobal(new Point(stage.stageWidth,stage.stageHeight)));
            backdrop.graphics.beginFill(0x101014,1);backdrop.graphics.drawRect(corner.x,corner.y,farCorner.x-corner.x,farCorner.y-corner.y);backdrop.graphics.endFill();host.addChild(backdrop);FNarutoFinalLayers.push(backdrop);
         }
         var layer:Sprite=new Sprite();layer.name="madaraNarutoFinalSkillVfx";layer.mouseEnabled=false;layer.mouseChildren=false;
         // The cinematic light textures use a black matte; composite them transparently.
         if(symbol=="texie" && FSkillId!=13122313)layer.blendMode="screen";
         if(symbol=="xia" && parent==host)host.addChildAt(layer,host.getChildIndex(this));else host.addChild(layer);
         FNarutoFinalLayers.push(layer);
         var clip:MovieClip=null;var serial:uint=FCombatVfxSerial;var skill:uint=FSkillId;var last:int=-1;var tick:Function;var clear:Function;var cleaned:Boolean=false;
         clear=function(event:Event=null):void{if(cleaned || event!=null && event.target!=layer)return;cleaned=true;layer.removeEventListener(Event.ENTER_FRAME,tick);layer.removeEventListener(Event.REMOVED_FROM_STAGE,clear);if(clip!=null)clip.stop();if(backdrop!=null&&backdrop.parent!=null)backdrop.parent.removeChild(backdrop);if(layer.parent!=null)layer.parent.removeChild(layer);};
         tick=function(event:Event=null):void{
            if(host.stage==null || caster.stage==null || caster.FCombatVfxSerial!=serial || caster.FSkillId!=skill || (caster.FIndex!=TYPE_ACTIVE_ATTACK && caster.FIndex!=TYPE_ACTIVE_SKILL)){clear();return;}
            var state:Object=FNarutoFinalNative[effect];if(state==null || state.domain==null){layer.visible=false;return;}
            if(skill==13122313 && symbol!="texie" && caster.FFrameIndex<150){layer.visible=false;return;}
            if(clip==null){if(!state.domain.hasDefinition(symbol)){clear();return;}var type:Class=state.domain.getDefinition(symbol) as Class;clip=new type() as MovieClip;clip.stop();layer.addChild(clip);}
            if(caster.FFrameIndex<startFrame){layer.visible=false;return;}
            var rate:Number=24;var frame:int=Math.round(Math.max(0,caster.FFrameIndex-startFrame)*rate/25)+1;
            if(frame>clip.totalFrames){clear();return;}
            layer.visible=true;if(frame!=last){clip.gotoAndStop(frame);last=frame;}
            var offset:Point=caster.NarutoFinalContactOffset();var originX:Number=70*0.84;
            var at:Point=host.globalToLocal(caster.localToGlobal(new Point(originX+offset.x,offset.y)));
            var facing:Number=caster.scaleX;
            if(target!=null){at=host.globalToLocal(target.localToGlobal(new Point()));facing=target.scaleX;}
            layer.x=at.x;layer.y=at.y;layer.scaleX=facing<0?-0.84:0.84;layer.scaleY=0.84;
            if(symbol=="texie" || skill==13122313){
               var bounds:Rectangle=clip.getBounds(clip);if(bounds.width>1 && bounds.height>1){
                  if(skill==13122313 && symbol=="texie"){
                     var sampleScale:Number=256/Math.max(bounds.width,bounds.height);
                     var sample:BitmapData=new BitmapData(Math.max(1,Math.ceil(bounds.width*sampleScale)),Math.max(1,Math.ceil(bounds.height*sampleScale)),true,0);
                     sample.draw(clip,new Matrix(sampleScale,0,0,sampleScale,-bounds.x*sampleScale,-bounds.y*sampleScale));
                     var left:int=sample.width;var right:int=-1;var top:int=sample.height;var bottom:int=-1;
                     for(var sy:int=0;sy<sample.height;sy++)for(var sx:int=0;sx<sample.width;sx++){
                        var pixel:uint=sample.getPixel32(sx,sy);var red:int=(pixel>>>16)&255;var green:int=(pixel>>>8)&255;var blue:int=pixel&255;
                        if((pixel>>>24)>150 && red>160 && green>90 && blue<green*.85){left=Math.min(left,sx);right=Math.max(right,sx);top=Math.min(top,sy);bottom=Math.max(bottom,sy);}
                     }
                     sample.dispose();
                     if(right>left+3 && bottom>top+3){
                        bounds=new Rectangle(bounds.x+left/sampleScale,bounds.y+top/sampleScale,(right-left+1)/sampleScale,(bottom-top+1)/sampleScale);
                        bounds.inflate(bounds.width*.08,bounds.height*.08);
                     }
                  }
                  // Fit the original cut-in uniformly to the battle viewport.
                  var fit:Number=skill==13122313?(symbol=="texie"?Math.min(host.stage.stageWidth/bounds.width,host.stage.stageHeight/bounds.height):Math.max(host.stage.stageWidth/bounds.width,host.stage.stageHeight/bounds.height)):host.stage.stageWidth/bounds.width;
                  layer.scaleX=fit;layer.scaleY=fit;
                  layer.x=host.stage.stageWidth*.5-(bounds.x+bounds.width*.5)*fit;
                  layer.y=host.stage.stageHeight*(skill==13122313 ? 0.5 : 0.4)-(bounds.y+bounds.height*.5)*fit;
               }
            }
         };
         layer.addEventListener(Event.ENTER_FRAME,tick);layer.addEventListener(Event.REMOVED_FROM_STAGE,clear);tick();
      }
 }
}