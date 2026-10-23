package
{
   import Foundation.Decoder.Pak.TPakDecoder;
   import Logics.Battle.model.*;
   import flash.display.*;
   import flash.events.*;
   import flash.external.ExternalInterface;
   import flash.geom.*;
   import flash.net.*;
   import flash.text.*;
   import flash.utils.*;
   
   [SWF(width="1250", height="650", backgroundColor="#000000", frameRate="30")]
   public class TApplication extends MovieClip
   {
      
      private static var FSasukeFxCache:Object = {};
      
      private static var FSasukeFxLoading:Object = {};
      
      private var FId:int = 11120970;
      
      private var FSkillId:int = 0;
      
      private var FIndex:int = 1;
      
      private const TYPE_ACTIVE_ATTACK:int = 1;
      
      private const TYPE_ACTIVE_SKILL:int = 2;
      
      private var FFrameIndex:int = 0;
      
      private var FSasukeVfxStarted:Boolean = false;
      
      private var FSasukeVfxHit:Boolean = false;
      
      private var FSasukeActiveVfx:Array = [];
      
      private var FCombatVfxSerial:uint = 0;
      
      private var FBattleStage:Sprite;
      
      private var FTargets:Array = [];
      
      private var FResults:Array = [];
      
      public var Camp:int = 0;
      
      public var Pos:int = 6;
      
      private var actor:Bitmap = new Bitmap();
      
      private var clips:Object = {};
      
      private var decoders:Array = [];
      
      private var loaded:int = 0;
      
      private var readyAt:int = -1;
      
      private var lastSlot:int = -1;
      
      private var captured:Object = {};
      
      private var battle:Sprite;
      
      private var left:ProbeRole;
      
      private var right:ProbeRole;
      
      private var label:TextField;
      
      private var skills:Array = [13121301,13121302,13121303,13121304,13121305,13121306,13121307,13121308,13121309];
      
      private var clipNames:Array = ["mystery","blazeMystery","standard","blazeStandard","dragon","blazeDragon","mangekyo","rinnegan","susanoo"];
      
      private var metadata:Object = {
         "idle":{
            "assets":[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39],
            "duration":40,
            "loop":true,
            "sourceAction":"C_idle",
            "sourceFrames":38
         },
         "run":{
            "assets":[40,41,42,43],
            "duration":40,
            "loop":true,
            "sourceAction":"C_run1_2",
            "sourceFrames":3
         },
         "hit":{
            "assets":[44,45,46,47,48,49,50,0],
            "duration":40,
            "loop":false,
            "sourceAction":"D_stand_behit1",
            "sourceFrames":6,
            "returnFrame":7
         },
         "dead":{
            "assets":[51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,0],
            "duration":40,
            "loop":false,
            "sourceAction":"C_dead",
            "sourceFrames":26,
            "returnFrame":28
         },
         "mystery":{
            "assets":[79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,0],
            "duration":40,
            "loop":false,
            "sourceAction":"SP_skill1",
            "sourceFrames":125,
            "returnFrame":131,
            "hitFrames":[69,74,80,86,91]
         },
         "blazeMystery":{
            "assets":[210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,0],
            "duration":40,
            "loop":false,
            "sourceAction":"SP_skill1_yan",
            "sourceFrames":125,
            "returnFrame":131,
            "hitFrames":[69,74,80,86,91]
         },
         "standard":{
            "assets":[341,342,343,344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360,361,362,363,364,365,366,367,368,369,370,371,372,373,374,375,376,377,378,379,380,381,382,383,384,385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,400,401,402,403,404,405,406,407,408,409,410,411,412,413,414,415,416,417,418,419,420,421,422,423,424,425,0],
            "duration":40,
            "loop":false,
            "sourceAction":"A_3hit",
            "sourceFrames":81,
            "returnFrame":85,
            "hitFrames":[6,18,31,44,56]
         },
         "blazeStandard":{
            "assets":[426,427,428,429,430,431,432,433,434,435,436,437,438,439,440,441,442,443,444,445,446,447,448,449,450,451,452,453,454,455,456,457,458,459,460,461,462,463,464,465,466,467,468,469,470,471,472,473,474,475,476,477,478,479,480,481,482,483,484,485,486,487,488,489,490,491,492,493,494,495,496,497,498,499,500,501,502,503,504,505,506,507,508,509,510,0],
            "duration":40,
            "loop":false,
            "sourceAction":"A_3hit_yan",
            "sourceFrames":81,
            "returnFrame":85,
            "hitFrames":[6,18,31,44,56]
         },
         "dragon":{
            "assets":[511,512,513,514,515,516,517,518,519,520,521,522,523,524,525,526,527,528,529,530,531,532,533,534,535,536,537,538,539,540,541,542,543,544,545,546,547,548,549,550,551,552,553,554,555,556,557,558,559,560,561,562,563,564,565,566,567,568,569,570,571,572,573,574,575,576,577,578,579,580,581,582,583,584,585,586,587,588,589,590,591,592,593,594,595,596,0],
            "duration":40,
            "loop":false,
            "sourceAction":"SP_skill2",
            "sourceFrames":82,
            "returnFrame":86,
            "hitFrames":[24,32,41,49]
         },
         "blazeDragon":{
            "assets":[597,598,599,600,601,602,603,604,605,606,607,608,609,610,611,612,613,614,615,616,617,618,619,620,621,622,623,624,625,626,627,628,629,630,631,632,633,634,635,636,637,638,639,640,641,642,643,644,645,646,647,648,649,650,651,652,653,654,655,656,657,658,659,660,661,662,663,664,665,666,667,668,669,670,671,672,673,674,675,676,677,678,679,680,681,682,0],
            "duration":40,
            "loop":false,
            "sourceAction":"SP_skill2_yan",
            "sourceFrames":82,
            "returnFrame":86,
            "hitFrames":[24,32,41,49]
         },
         "mangekyo":{
            "assets":[683,684,685,686,687,688,689,690,691,692,693,694,695,696,697,698,699,700,701,702,703,704,705,706,707,708,709,710,711,712,713,714,715,716,717,718,719,720,721,722,723,724,725,726,727,728,729,730,731,732,733,734,735,736,737,738,739,0],
            "duration":40,
            "loop":false,
            "sourceAction":"SP_skill3",
            "sourceFrames":54,
            "returnFrame":57,
            "hitFrames":[27]
         },
         "rinnegan":{
            "assets":[740,741,742,743,744,745,746,747,748,749,750,751,752,753,754,755,756,757,758,759,760,761,762,763,764,765,766,767,768,769,770,771,772,773,774,775,776,777,778,779,780,781,782,783,784,785,786,787,788,789,790,791,792,793,794,795,796,797,798,799,800,801,802,0],
            "duration":40,
            "loop":false,
            "sourceAction":"SP_skill4",
            "sourceFrames":60,
            "returnFrame":63,
            "hitFrames":[29]
         },
         "susanoo":{
            "assets":[803,804,805,806,807,808,809,810,811,812,813,814,815,816,817,818,819,820,821,822,823,824,825,826,827,828,829,830,831,832,833,834,835,836,837,838,839,840,841,842,0],
            "duration":40,
            "loop":false,
            "sourceAction":"SP_skill5",
            "sourceFrames":38,
            "returnFrame":40
         }
      };
      
      public function TApplication(root:Boolean = true)
      {
         super();
         if(!root)
         {
            actor.smoothing = true;
            addChild(actor);
            return;
         }
         addEventListener(Event.ADDED_TO_STAGE,boot);
         if(stage != null)
         {
            boot();
         }
      }
      
      private function get FBitmap() : Bitmap
      {
         return actor;
      }
      
      private function report(text:String) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("vfxProbe",text);
         }
      }
      
      private function boot(event:Event = null) : void
      {
         var i:int;
         var actors:Sprite;
         var results:Array;
         removeEventListener(Event.ADDED_TO_STAGE,boot);
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;
         stage.frameRate = 25;
         loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,function(e:UncaughtErrorEvent):void
         {
            report("ERROR " + e.error);
         });
         battle = new Sprite();
         addChild(battle);
         battle.graphics.beginFill(3427128);
         battle.graphics.drawRect(0,0,1250,650);
         battle.graphics.endFill();
         battle.graphics.lineStyle(1,5862218,0.5);
         i = 0;
         while(i < 12)
         {
            battle.graphics.moveTo(0,300 + i * 30);
            battle.graphics.lineTo(1250,300 + i * 30);
            i++;
         }
         actors = new Sprite();
         battle.addChild(actors);
         left = new ProbeRole();
         right = new ProbeRole();
         left.FBattleStage = battle;
         right.FBattleStage = battle;
         left.x = 350;
         left.y = 470;
         right.x = 900;
         right.y = 470;
         right.scaleX = -1;
         right.Camp = 1;
         left.FTargets = [left,right,right];
         right.FTargets = [right,left,left];
         results = [{
            "CMD":0,
            "ResultInfo":{"HurtHp":0}
         },{
            "CMD":1,
            "ResultInfo":{"HurtHp":10}
         },{
            "CMD":9,
            "ResultInfo":{"HurtHp":0}
         }];
         left.FResults = results;
         right.FResults = results;
         actors.addChild(left);
         actors.addChild(right);
         label = new TextField();
         label.defaultTextFormat = new TextFormat("_sans",20,16777215,true);
         label.width = 1200;
         label.height = 30;
         label.x = 25;
         label.y = 20;
         addChild(label);
         loadTexture("00A9B14A",["idle"]);
         loadTexture("A9B14A0B",["standard","blazeStandard"]);
         loadTexture("A9B14A0C",["mystery","blazeMystery","dragon","blazeDragon","mangekyo","rinnegan","susanoo"]);
         addEventListener(Event.ENTER_FRAME,tick);
         report("BOOT native Flash shared VFX component probe");
      }
      
      private function loadTexture(path:String, names:Array) : void
      {
         var loader:URLLoader = new URLLoader();
         loader.dataFormat = URLLoaderDataFormat.BINARY;
         loader.addEventListener(IOErrorEvent.IO_ERROR,function(e:IOErrorEvent):void
         {
            report("ERROR texture " + path + " " + e.text);
         });
         loader.addEventListener(Event.COMPLETE,function(e:Event):void
         {
            var bytes:ByteArray = loader.data as ByteArray;
            bytes.endian = Endian.LITTLE_ENDIAN;
            bytes.readUnsignedInt();
            var count:uint = bytes.readUnsignedInt();
            var seq:ByteArray = new ByteArray();
            seq.endian = Endian.LITTLE_ENDIAN;
            bytes.readBytes(seq,0,count);
            var total:uint = bytes.readUnsignedShort();
            var all:Array = [];
            var j:int = 0;
            while(j < total)
            {
               seq.readUnsignedInt();
               seq.readUnsignedByte();
               count = seq.readUnsignedShort();
               var meta:Array = [];
               var k:int = 0;
               while(k < count)
               {
                  seq.readShort();
                  seq.readShort();
                  seq.readUnsignedShort();
                  seq.readUnsignedShort();
                  meta.push({
                     "px":seq.readShort(),
                     "py":seq.readShort(),
                     "duration":seq.readUnsignedShort()
                  });
                  k++;
               }
               all.push(meta);
               j++;
            }
            j = 0;
            while(j < total)
            {
               count = bytes.readUnsignedInt();
               var pak:ByteArray = new ByteArray();
               bytes.readBytes(pak,0,count);
               decodeTexture(pak,String(names[j]),all[j]);
               j++;
            }
         });
         loader.load(new URLRequest("/public/2026090619/Resources/Textures/Model/" + path + ".TexClient"));
      }
      
      private function decodeTexture(pak:ByteArray, name:String, meta:Array) : void
      {
         var decoder:TPakDecoder = new TPakDecoder();
         decoders.push(decoder);
         decoder.OnResourceUnstreamized = function(sender:Object, images:Vector.<BitmapData>, index:uint):void
         {
            clips[name] = {
               "images":images,
               "meta":meta
            };
            ++loaded;
            report("TEXTURE " + name + " frames=" + images.length);
         };
         decoder.Unstreamize(pak,new Vector.<BitmapData>(),0);
      }
      
      private function renderRole(role:ProbeRole, name:String, index:int) : void
      {
         var clip:Object = clips[name];
         if(clip == null)
         {
            return;
         }
         index = Math.max(0,Math.min(index,clip.images.length - 1));
         role.actor.bitmapData = clip.images[index];
         role.actor.x = -clip.meta[index].px;
         role.actor.y = -clip.meta[index].py;
         role.FitSasukePose();
      }
      
      private function tick(event:Event) : void
      {
         for each(var decoder:TPakDecoder in decoders)
         {
            if(decoder.Unstreamizing)
            {
               decoder.Process();
            }
         }
         if(loaded < 10)
         {
            return;
         }
         if(readyAt < 0)
         {
            readyAt = getTimer() + 3000;
            ProbeRole.PreloadSasukeVfx();
         }
         if(getTimer() < readyAt)
         {
            return;
         }
         var playback:Number = Number(loaderInfo.parameters.speed);
         if(playback != 1)
         {
            playback = 2;
         }
         var age:int = (getTimer() - readyAt) * playback;
         var bounds:Array = [0,6780,13560,18500,23440,28420,33400,37220,41280,44420,51200,57980,62920,67860,72840,77820,81640,85700,88840];
         var slot:int = 0;
         while(slot < 18 && age >= bounds[slot + 1])
         {
            slot++;
         }
         if(slot >= 18)
         {
            left.FSkillId = 0;
            right.FSkillId = 0;
            var remaining:int = 0;
            var q:int = 0;
            while(q < battle.numChildren)
            {
               if(battle.getChildAt(q).name == "sasukeSkillVfx")
               {
                  remaining++;
               }
               q++;
            }
            report("DONE Sasuke native component; remaining=" + remaining);
            removeEventListener(Event.ENTER_FRAME,tick);
            return;
         }
         var side:int = slot < 9 ? 0 : 1;
         var index:int = slot % 9;
         var caster:ProbeRole = side == 0 ? left : right;
         var victim:ProbeRole = side == 0 ? right : left;
         if(lastSlot != slot)
         {
            left.FSkillId = 0;
            right.FSkillId = 0;
            ++caster.FCombatVfxSerial;
            caster.FSkillId = skills[index];
            caster.FFrameIndex = 0;
            caster.FSasukeVfxStarted = false;
            caster.Pos = 1 + index % 3 * 5;
            caster.y = 340 + index % 3 * 90;
            victim.y = 390 + index % 2 * 100;
            lastSlot = slot;
            label.text = "Sasuke Shinden | " + clipNames[index] + " | camp " + side;
            report("CASE " + skills[index] + " camp=" + side);
         }
         var frame:int = int((age - bounds[slot]) / 40);
         var name:String = clipNames[index];
         caster.FFrameIndex = frame;
         if(frame < clips[name].images.length)
         {
            renderRole(caster,name,frame);
            caster.UpdateSasukeVfx();
         }
         else
         {
            caster.FSkillId = 0;
            renderRole(caster,"idle",int(age / 100) % clips.idle.images.length);
         }
         renderRole(victim,"idle",int(age / 100) % clips.idle.images.length);
         var hit:int = metadata[name].hitFrames != null ? int(metadata[name].hitFrames[0]) : 12;
         var phases:Array = [Math.max(3,hit - 4),hit + 4,Math.max(hit + 8,int(clips[name].images.length * 0.72))];
         if(skills[index] <= 13121302)
         {
            phases = [40,60,69,74,80,86,91,104,125];
         }
         if(skills[index] == 13121305 || skills[index] == 13121306)
         {
            phases = [20,28,41,60];
         }
         for each(var phase:int in phases)
         {
            var key:String = "CASE-" + skills[index] + "-camp-" + side + "-frame-" + phase;
            if(frame >= phase && !captured[key])
            {
               captured[key] = true;
               var started:int = int(getTimer());
               var flush:int = battle.numChildren - 1;
               while(flush >= 0)
               {
                  if(flush < battle.numChildren && battle.getChildAt(flush).name == "sasukeSkillVfx")
                  {
                     battle.getChildAt(flush).dispatchEvent(new Event(Event.ENTER_FRAME));
                  }
                  flush--;
               }
               saveFrame(key);
               readyAt += getTimer() - started;
            }
         }
      }
      
      private function saveFrame(name:String) : void
      {
         var snapshot:BitmapData = new BitmapData(1250,650,false,0);
         snapshot.draw(this);
         var png:ByteArray = snapshot.encode(snapshot.rect,new JPEGEncoderOptions(88));
         var hex:String = "";
         png.position = 0;
         while(png.bytesAvailable)
         {
            var value:String = png.readUnsignedByte().toString(16);
            hex += value.length < 2 ? "0" + value : value;
         }
         if(ExternalInterface.available)
         {
            ExternalInterface.call("vfxSnapshot",name,hex);
         }
         snapshot.dispose();
      }
   }
}

