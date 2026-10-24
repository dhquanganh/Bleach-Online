package Processors.Game.Battle.Character
{
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Battle.*;
   import Logics.Battle.model.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.SLogicsCore;
   import Processors.Game.Battle.*;
   import Processors.Game.Battle.Effect.*;
   import Processors.Game.Battle.GoneWord.TGoneWord;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.*;
   import ghostcat.util.easing.Expo;
   import ghostcat.util.easing.TweenUtil;
   
   public class TRole extends TBaseRole
   {
      
      protected static const SIZE_FrameRatePerSecond:int = CONST_COMMON.SIZE_FrameRatePerSecond;
      
      public static const CONST_BUFF_Const:int = 7;
      
      public static const CONST_BUFF_Width:Number = 22;
      
      public static const CONST_BUFF_Height:Number = 22;
      
      public static const CONST_BUFF_StampX_Left:int = -50;
      
      public static const CONST_BUFF_StampX_Right:int = 50;
      
      public static const CONST_BUFF_StampY:Number = -130;
      
      private static var FSkillBattleShake:Object = null;
      
      private static var FJiraiyaShake:Object = null;
      
      private static var FObitoFxCache:Object = {};
      
      private static var FObitoFxLoading:Object = {};
      
      private static var FPainFxCache:Object = {};
      
      private static var FPainFxLoading:Object = {};
      
      private static var FHashiramaFxCache:Object = {};
      
      private static var FHashiramaFxLoading:Object = {};
      
      private static var FMechaFxCache:Object = {};
      
      private static var FMechaFxLoading:Object = {};
      
      private static var FItachiFxCache:Object = {};
      
      private static var FItachiFxLoading:Object = {};
      
      private static var FSasukeFxCache:Object = {};
      
      private static var FSasukeFxLoading:Object = {};
      
      private static var FNagatoFxCache:Object = {};
      
      private static var FNagatoFxLoading:Object = {};
      
      private static var FGaaraFxCache:Object = {};
      
      private static var FGaaraFxLoading:Object = {};
      
      private var FJiraiyaVfxStarted:Boolean = false;
      
      private var FJiraiyaVfxHit:Boolean = false;
      
      private var FItachiCrowClone:Sprite;
      
      private var FItachiCrowCloneTick:Function;
      
      private var FItachiCrowCloneRemoved:Function;
      
      private var FSasukeVfxStarted:Boolean = false;
      
      private var FSasukeActiveVfx:Array = [];
      
      private var FItachiVfxStarted:Boolean = false;
      
      private var FItachiActiveVfx:Array = [];
      
      private var FNagatoVfxStarted:Boolean = false;
      
      private var FNagatoActiveVfx:Array = [];
      
      private var FGaaraVfxStarted:Boolean = false;
      
      private var FGaaraActiveVfx:Array = [];
      
      private var FMechaVfxStarted:Boolean = false;
      
      private var FMechaActiveVfx:Array = [];
      
      private var FCombatVfxSerial:uint = 0;
      
      private var FHashiramaVfxStarted:Boolean = false;
      
      private var FPainActiveVfx:Array = [];
      
      private var FHashiramaActiveVfx:Array = [];
      
      private var FPainVfxStarted:Boolean = false;
      
      private var FPainTechnique:TextField;
      
      private var FObitoVfxStarted:Boolean = false;
      
      protected var FWaitNextCommand:Boolean;
      
      protected var FStatusGridFile:Boolean;
      
      protected var FSkillBins:TBins;
      
      protected var FBuffBins:TBins;
      
      protected var FHideFrame:int;
      
      protected var FBattleStage:TBattleStage;
      
      protected var FBuffIdVect:Vector.<uint>;
      
      protected var FBuffTurnVect:Vector.<uint>;
      
      protected var FBuffSpriteVect:Vector.<Sprite>;
      
      protected var FIsNewBuffVect:Vector.<Boolean>;
      
      protected var FStatusGoneWordDict:Dictionary;
      
      protected var FHasGiddy:Boolean;
      
      protected var FGiddySequence:TAnimationSequence;
      
      protected var FGiddyBitmap:Bitmap;
      
      protected var FShieldBlood:Number;
      
      protected var FShieldBitmap:Bitmap;
      
      protected var FShieldSequence:TAnimationSequence;
      
      protected var FHasFrozen:Boolean;
      
      protected var FFrozenBitmap:Bitmap;
      
      protected var FFrozenSequence:TAnimationSequence;
      
      protected var FOnEffectEnd:Function;
      
      protected var FTextFunction:Function;
      
      protected var FActiveCallBack:Function;
      
      protected var FActiveTime:uint;
      
      protected var FOnBuffMouseMove:Function;
      
      protected var FOnBuffMouseRollOut:Function;
      
      protected var FOnBigSkill:Function;
      
      public function TRole(param1:TUIComponent, param2:TRoleBattleInfo, param3:TBattleStage, param4:Function = null)
      {
         super(param1,param2);
         this.FBattleStage = param3;
         this.FTextFunction = param4;
         this.FStatusGoneWordDict = new Dictionary();
         this.FSkillBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SkillConfig);
         this.FBuffBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BuffEffect);
         this.FBuffIdVect = new Vector.<uint>();
         this.FBuffTurnVect = new Vector.<uint>();
         this.FBuffSpriteVect = new Vector.<Sprite>();
         this.FIsNewBuffVect = new Vector.<Boolean>();
         this.FGiddyBitmap = new Bitmap();
         addChild(this.FGiddyBitmap);
         this.FShieldBitmap = new Bitmap();
         this.FShieldBitmap.visible = false;
         addChild(this.FShieldBitmap);
         this.FFrozenBitmap = new Bitmap();
         addChild(this.FFrozenBitmap);
         this.InitCharacter();
         this.LoadResources(CONST_BATTLE.Public_Effect_Giddy);
         this.LoadResources(CONST_BATTLE.Public_Effect_Shield);
         this.CheckDirection();
         this.FShieldBlood = 0;
      }
      
      private static function SetJiraiyaBarrier(host:DisplayObjectContainer, enabled:Boolean) : void
      {
         var existing:DisplayObject;
         var backdrop:Sprite;
         var loader:Loader;
         var completed:Function;
         var failed:Function;
         var removed:Function;
         var release:Function;
         if(host == null)
         {
            return;
         }
         existing = host.getChildByName("jiraiyaEsophagusBackdrop");
         if(!enabled)
         {
            if(existing != null)
            {
               host.removeChild(existing);
            }
            return;
         }
         if(existing != null)
         {
            return;
         }
         backdrop = new Sprite();
         backdrop.name = "jiraiyaEsophagusBackdrop";
         backdrop.mouseEnabled = false;
         backdrop.mouseChildren = false;
         backdrop.graphics.beginFill(8007725);
         backdrop.graphics.drawRect(0,0,1250,650);
         backdrop.graphics.endFill();
         host.addChildAt(backdrop,0);
         loader = new Loader();
         release = function():void
         {
            loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,completed);
            loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,failed);
            loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,failed);
         };
         completed = function(event:Event):void
         {
            release();
            if(backdrop.parent == null)
            {
               return;
            }
            loader.width = 1250;
            loader.height = 650;
            if(loader.content is Bitmap)
            {
               Bitmap(loader.content).smoothing = true;
            }
            backdrop.addChild(loader);
         };
         failed = function(event:Event):void
         {
            release();
         };
         removed = function(event:Event):void
         {
            if(event.target != backdrop)
            {
               return;
            }
            release();
            backdrop.removeEventListener(Event.REMOVED_FROM_STAGE,removed);
            try
            {
               loader.close();
            }
            catch(error:Error)
            {
            }
            loader.unload();
         };
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,completed);
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,failed);
         loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,failed);
         backdrop.addEventListener(Event.REMOVED_FROM_STAGE,removed);
         loader.load(new URLRequest("/public/jiraiya-vfx/toad-esophagus-v1.jpg"));
      }
      
      private static function ShakeJiraiyaBattle(host:DisplayObjectContainer, strength:Number, duration:int) : void
      {
      }
      
      private static function ObitoVfxManifest() : Object
      {
         return JSON.parse("{\"version\":4,\"frameRate\":25,\"frameMs\":40,\"atlases\":{\"DT1shenwei-128\":{\"url\":\"/public/obito-vfx/extracted/DT1shenwei-128.png\",\"columns\":19,\"rows\":2,\"frameCount\":27},\"DTaoyi-29\":{\"url\":\"/public/obito-vfx/extracted/DTaoyi-29.png\",\"columns\":12,\"rows\":5,\"frameCount\":51},\"DTaoyi-594\":{\"url\":\"/public/obito-vfx/extracted/DTaoyi-594.png\",\"columns\":11,\"rows\":8,\"frameCount\":81},\"DTbaozou-346\":{\"url\":\"/public/obito-vfx/extracted/DTbaozou-346.png\",\"columns\":11,\"rows\":5,\"frameCount\":45},\"DTbaozou-46\":{\"url\":\"/public/obito-vfx/extracted/DTbaozou-46.png\",\"columns\":10,\"rows\":3,\"frameCount\":23},\"dtpg-260\":{\"url\":\"/public/obito-vfx/extracted/dtpg-260.png\",\"columns\":9,\"rows\":5,\"frameCount\":37},\"dtpg-4\":{\"url\":\"/public/obito-vfx/extracted/dtpg-4.png\",\"columns\":28,\"rows\":1,\"frameCount\":8},\"DTpugong-25\":{\"url\":\"/public/obito-vfx/extracted/DTpugong-25.png\",\"columns\":15,\"rows\":2,\"frameCount\":27},\"DTpugong-426\":{\"url\":\"/public/obito-vfx/extracted/DTpugong-426.png\",\"columns\":12,\"rows\":4,\"frameCount\":37},\"DTzhuida-404\":{\"url\":\"/public/obito-vfx/extracted/DTzhuida-404.png\",\"columns\":9,\"rows\":9,\"frameCount\":74},\"DTzhuida-7\":{\"url\":\"/public/obito-vfx/extracted/DTzhuida-7.png\",\"columns\":41,\"rows\":1,\"frameCount\":11}},\"clips\":{\"DT1shenwei-128\":{\"atlas\":\"DT1shenwei-128\",\"timeline\":[0,1,2,3,4,5,6,7,8,9,10,11,12,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,0,0,0,0,0,0,0,0,0,0],\"pivot\":[0.5,0.5],\"renderScale\":0.35,\"width\":211,\"height\":213,\"source\":\"battle\\\\effect\\\\DT1shenwei.swf\",\"sourceFrames\":36,\"uniqueFrames\":27,\"offsetY\":-70},\"DTaoyi-29\":{\"atlas\":\"DTaoyi-29\",\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,2,2,3,3,4,4,5,6,7,8,9,10,11,12,4,5,5,5,13,14,15,16,17,18,3,4,4,5,5,13,19,20,21,22,23,0,0,0,0,0,0,0,0,0,0,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,45,46,47,48,49,50,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],\"pivot\":[0.5,0.5],\"renderScale\":0.35,\"width\":337,\"height\":130,\"source\":\"battle\\\\effect\\\\DTaoyi.swf\",\"sourceFrames\":105,\"uniqueFrames\":51,\"offsetY\":-65},\"DTaoyi-594\":{\"atlas\":\"DTaoyi-594\",\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,43,44,0,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,0,0,0,0,0,0,0],\"pivot\":[0.5,0.5],\"renderScale\":0.35,\"width\":353,\"height\":215,\"source\":\"battle\\\\effect\\\\DTaoyi.swf\",\"sourceFrames\":105,\"uniqueFrames\":81,\"offsetY\":-65},\"DTbaozou-346\":{\"atlas\":\"DTbaozou-346\",\"timeline\":[0,1,2,3,4,5,6,7,8,9,10,11,12,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,36,37,38,39,40,41,42,43,44],\"pivot\":[0.5,0.78],\"renderScale\":0.30355450236966824,\"width\":366,\"height\":360,\"source\":\"battle\\\\effect\\\\DTbaozou.swf\",\"sourceFrames\":45,\"uniqueFrames\":45,\"offsetY\":0},\"DTbaozou-46\":{\"atlas\":\"DTbaozou-46\",\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,22,0,0,0,0,0,0,0,0],\"pivot\":[0.5,0.5],\"renderScale\":0.35,\"width\":393,\"height\":121,\"source\":\"battle\\\\effect\\\\DTbaozou.swf\",\"sourceFrames\":45,\"uniqueFrames\":23,\"offsetY\":-4},\"dtpg-260\":{\"atlas\":\"dtpg-260\",\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,1,2,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,26,27,28,29,30,31,32,33,34,35,36,0,0,0,0,0,0,0,0,0,0],\"pivot\":[0.5,0.82],\"renderScale\":0.35,\"width\":447,\"height\":289,\"source\":\"battle\\\\effect\\\\dtpg.swf\",\"sourceFrames\":56,\"uniqueFrames\":37,\"offsetY\":8},\"dtpg-4\":{\"atlas\":\"dtpg-4\",\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,3,4,5,6,7,0,0,0,0,0,0,0,0,0,0,0,0,0],\"pivot\":[0.5,0.8],\"renderScale\":0.35,\"width\":143,\"height\":48,\"source\":\"battle\\\\effect\\\\dtpg.swf\",\"sourceFrames\":56,\"uniqueFrames\":8,\"offsetY\":4},\"DTpugong-25\":{\"atlas\":\"DTpugong-25\",\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,16,17,18,19,20,21,22,23,24,25,26],\"pivot\":[0.5,0.65],\"renderScale\":0.35,\"width\":271,\"height\":122,\"source\":\"battle\\\\effect\\\\DTpugong.swf\",\"sourceFrames\":47,\"uniqueFrames\":27,\"offsetY\":5},\"DTpugong-426\":{\"atlas\":\"DTpugong-426\",\"timeline\":[0,0,0,0,1,2,3,4,5,6,7,8,9,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,33,34,35,36,0,0,0,0,0,0,0],\"pivot\":[0.5,0.65],\"renderScale\":0.35,\"width\":322,\"height\":233,\"source\":\"battle\\\\effect\\\\DTpugong.swf\",\"sourceFrames\":47,\"uniqueFrames\":37,\"offsetY\":-35},\"DTzhuida-404\":{\"atlas\":\"DTzhuida-404\",\"timeline\":[0,0,0,0,0,0,0,0,0,0,1,2,3,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,0,0,0,0,0],\"pivot\":[0.5,0.65],\"renderScale\":0.3499999999999999,\"width\":424,\"height\":230,\"source\":\"battle\\\\effect\\\\DTzhuida.swf\",\"sourceFrames\":87,\"uniqueFrames\":74,\"offsetY\":-40},\"DTzhuida-7\":{\"atlas\":\"DTzhuida-7\",\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,4,5,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,7,7,8,9,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],\"pivot\":[0.5,0.5],\"renderScale\":0.35,\"width\":98,\"height\":69,\"source\":\"battle\\\\effect\\\\DTzhuida.swf\",\"sourceFrames\":87,\"uniqueFrames\":11,\"offsetY\":-65}},\"effects\":{\"DT1shenwei\":[\"DT1shenwei-128\"],\"DTaoyi\":[\"DTaoyi-29\",\"DTaoyi-594\"],\"DTbaozou\":[\"DTbaozou-346\",\"DTbaozou-46\"],\"dtpg\":[\"dtpg-260\",\"dtpg-4\"],\"DTpugong\":[\"DTpugong-25\",\"DTpugong-426\"],\"DTzhuida\":[\"DTzhuida-404\",\"DTzhuida-7\"]},\"layout\":{\"DT1shenwei\":{\"width\":340},\"DTaoyi\":{\"width\":660},\"DTbaozou\":{\"width\":540},\"dtpg\":{\"width\":580},\"DTpugong\":{\"width\":520},\"DTzhuida\":{\"width\":600}}}");
      }
      
      private static function PreloadObitoVfx() : void
      {
         var manifest:Object = ObitoVfxManifest();
         for(var name:String in manifest.atlases)
         {
            LoadObitoVfxAtlas(name,manifest.atlases[name]);
         }
      }
      
      private static function LoadObitoVfxAtlas(name:String, meta:Object) : void
      {
         var loader:Loader;
         var complete:Function;
         var failed:Function;
         var release:Function;
         if(FObitoFxCache[name] != null || FObitoFxLoading[name])
         {
            return;
         }
         FObitoFxLoading[name] = true;
         loader = new Loader();
         release = function():void
         {
            loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,complete);
            loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,failed);
            loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,failed);
            delete FObitoFxLoading[name];
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
            FObitoFxCache[name] = frames;
            loader.unload();
         };
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,complete);
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,failed);
         loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,failed);
         loader.load(new URLRequest(String(meta.url)));
      }
      
      private static function PainVfxManifest() : Object
      {
         return JSON.parse("{\"version\":6,\"frameRate\":25,\"frameMs\":40,\"atlases\":{\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-DASHEWAN_tongyongfuhuo-213-00.png\",\"columns\":11,\"rows\":4,\"frameCount\":42},\"quality-v1-PEaoyi1-195-00\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEaoyi1-195-00.png\",\"columns\":3,\"rows\":3,\"frameCount\":9},\"quality-v1-PEaoyi1-195-01\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEaoyi1-195-01.png\",\"columns\":3,\"rows\":3,\"frameCount\":9},\"quality-v1-PEaoyi1-195-02\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEaoyi1-195-02.png\",\"columns\":3,\"rows\":3,\"frameCount\":9},\"quality-v1-PEaoyi1-195-03\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEaoyi1-195-03.png\",\"columns\":3,\"rows\":3,\"frameCount\":9},\"quality-v1-PEaoyi1-195-04\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEaoyi1-195-04.png\",\"columns\":3,\"rows\":3,\"frameCount\":9},\"quality-v1-PEaoyi1-195-05\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEaoyi1-195-05.png\",\"columns\":3,\"rows\":3,\"frameCount\":9},\"quality-v1-PEaoyi2-12-00\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEaoyi2-12-00.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-PEaoyi2-12-01\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEaoyi2-12-01.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-PEaoyi2-12-02\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEaoyi2-12-02.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-PEaoyi2-12-03\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEaoyi2-12-03.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-PEaoyi2-12-04\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEaoyi2-12-04.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-PEaoyi2-12-05\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEaoyi2-12-05.png\",\"columns\":2,\"rows\":1,\"frameCount\":1},\"quality-v1-PEaoyi2-414-00\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEaoyi2-414-00.png\",\"columns\":2,\"rows\":5,\"frameCount\":10},\"quality-v1-PEaoyi2-414-01\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEaoyi2-414-01.png\",\"columns\":2,\"rows\":5,\"frameCount\":10},\"quality-v1-PEaoyi2-414-02\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEaoyi2-414-02.png\",\"columns\":2,\"rows\":5,\"frameCount\":10},\"quality-v1-PEaoyi2-414-03\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEaoyi2-414-03.png\",\"columns\":2,\"rows\":5,\"frameCount\":10},\"quality-v1-PEaoyi2-414-04\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEaoyi2-414-04.png\",\"columns\":2,\"rows\":5,\"frameCount\":10},\"quality-v1-PEaoyi2-414-05\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEaoyi2-414-05.png\",\"columns\":2,\"rows\":5,\"frameCount\":9},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-01\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-01.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-02\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-02.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-03\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-03.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-04\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-04.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00.png\",\"columns\":3,\"rows\":12,\"frameCount\":34},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-01\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-01.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-02\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-02.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-03\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-03.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-04\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-04.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-05\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-05.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-06\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-06.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-07\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-07.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-08\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-08.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-09\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-09.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-10\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-10.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-11\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-11.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-12\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-12.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-13\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-13.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-14\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-14.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-15\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-15.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-16\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-16.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-17\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-17.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-18\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-18.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-19\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-19.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-20\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-20.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-21\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-21.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-22\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-22.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-23\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-23.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-24\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-24.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-25\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-25.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-26\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-26.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-27\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-27.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-28\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-28.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-29\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-29.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-30\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-30.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-31\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-31.png\",\"columns\":2,\"rows\":1,\"frameCount\":1},\"quality-v1-PEpugong1-154-00\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEpugong1-154-00.png\",\"columns\":2,\"rows\":5,\"frameCount\":10},\"quality-v1-PEpugong1-154-01\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEpugong1-154-01.png\",\"columns\":2,\"rows\":5,\"frameCount\":10},\"quality-v1-PEpugong1-154-02\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEpugong1-154-02.png\",\"columns\":2,\"rows\":5,\"frameCount\":10},\"quality-v1-PEpugong1-154-03\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEpugong1-154-03.png\",\"columns\":2,\"rows\":3,\"frameCount\":5},\"quality-v1-PEpugong1-682-00\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEpugong1-682-00.png\",\"columns\":3,\"rows\":3,\"frameCount\":9},\"quality-v1-PEpugong1-682-01\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEpugong1-682-01.png\",\"columns\":3,\"rows\":3,\"frameCount\":9},\"quality-v1-PEpugong1-682-02\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEpugong1-682-02.png\",\"columns\":3,\"rows\":3,\"frameCount\":9},\"quality-v1-PEpugong1-682-03\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEpugong1-682-03.png\",\"columns\":3,\"rows\":3,\"frameCount\":9},\"quality-v1-PEpugong1-682-04\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEpugong1-682-04.png\",\"columns\":3,\"rows\":3,\"frameCount\":9},\"quality-v1-PEpugong1-682-05\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEpugong1-682-05.png\",\"columns\":3,\"rows\":2,\"frameCount\":4},\"quality-v1-PEzhuida-308-00\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEzhuida-308-00.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-PEzhuida-308-01\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEzhuida-308-01.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-PEzhuida-308-02\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEzhuida-308-02.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-PEzhuida-308-03\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEzhuida-308-03.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-PEzhuida-308-04\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEzhuida-308-04.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-PEzhuida-308-05\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEzhuida-308-05.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-PEzhuida-308-06\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEzhuida-308-06.png\",\"columns\":2,\"rows\":2,\"frameCount\":3},\"quality-v1-PEzhuida-81-00\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEzhuida-81-00.png\",\"columns\":2,\"rows\":7,\"frameCount\":14},\"quality-v1-PEzhuida-81-01\":{\"url\":\"/public/pain-vfx/extracted/quality-v1-PEzhuida-81-01.png\",\"columns\":2,\"rows\":7,\"frameCount\":14}},\"clips\":{\"DASHEWAN_tongyongfuhuo-213\":{\"atlas\":\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"timeline\":[0,1,2,3,4,5,6,7,8,9,10,11,12,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,36,37,38,39,40,41,41,41,41,41,41,41,41,41,41,41],\"pivot\":[0.48292349726775957,0.8089999999999998],\"renderScale\":0.7,\"width\":183,\"height\":390,\"source\":\"battle\\\\effect\\\\DASHEWAN_tongyongfuhuo.swf\",\"sourceFrames\":51,\"uniqueFrames\":42,\"frameAtlases\":[\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\",\"quality-v1-DASHEWAN_tongyongfuhuo-213-00\"],\"qualitySourceZoom\":0.7,\"action\":\"tyfh\"},\"PEaoyi1-195\":{\"atlas\":\"quality-v1-PEaoyi1-195-00\",\"timeline\":[0,0,0,0,0,1,2,3,4,5,6,7,8,8,0,1,2,3,4,5,6,7,8,0,1,2,3,4,5,6,7,8,0,1,2,3,4,5,5,6,7,8,0,1,2,3,4,5,6,7,8,0,1,2,3,4,5,6,7,8,0,0],\"pivot\":[0.5,0.8265879478827362],\"renderScale\":0.7,\"width\":652,\"height\":614,\"source\":\"battle\\\\effect\\\\PEaoyi1.swf\",\"sourceFrames\":59,\"uniqueFrames\":54,\"frameAtlases\":[\"quality-v1-PEaoyi1-195-00\",\"quality-v1-PEaoyi1-195-00\",\"quality-v1-PEaoyi1-195-00\",\"quality-v1-PEaoyi1-195-00\",\"quality-v1-PEaoyi1-195-00\",\"quality-v1-PEaoyi1-195-00\",\"quality-v1-PEaoyi1-195-00\",\"quality-v1-PEaoyi1-195-00\",\"quality-v1-PEaoyi1-195-00\",\"quality-v1-PEaoyi1-195-00\",\"quality-v1-PEaoyi1-195-00\",\"quality-v1-PEaoyi1-195-00\",\"quality-v1-PEaoyi1-195-00\",\"quality-v1-PEaoyi1-195-00\",\"quality-v1-PEaoyi1-195-01\",\"quality-v1-PEaoyi1-195-01\",\"quality-v1-PEaoyi1-195-01\",\"quality-v1-PEaoyi1-195-01\",\"quality-v1-PEaoyi1-195-01\",\"quality-v1-PEaoyi1-195-01\",\"quality-v1-PEaoyi1-195-01\",\"quality-v1-PEaoyi1-195-01\",\"quality-v1-PEaoyi1-195-01\",\"quality-v1-PEaoyi1-195-02\",\"quality-v1-PEaoyi1-195-02\",\"quality-v1-PEaoyi1-195-02\",\"quality-v1-PEaoyi1-195-02\",\"quality-v1-PEaoyi1-195-02\",\"quality-v1-PEaoyi1-195-02\",\"quality-v1-PEaoyi1-195-02\",\"quality-v1-PEaoyi1-195-02\",\"quality-v1-PEaoyi1-195-02\",\"quality-v1-PEaoyi1-195-03\",\"quality-v1-PEaoyi1-195-03\",\"quality-v1-PEaoyi1-195-03\",\"quality-v1-PEaoyi1-195-03\",\"quality-v1-PEaoyi1-195-03\",\"quality-v1-PEaoyi1-195-03\",\"quality-v1-PEaoyi1-195-03\",\"quality-v1-PEaoyi1-195-03\",\"quality-v1-PEaoyi1-195-03\",\"quality-v1-PEaoyi1-195-03\",\"quality-v1-PEaoyi1-195-04\",\"quality-v1-PEaoyi1-195-04\",\"quality-v1-PEaoyi1-195-04\",\"quality-v1-PEaoyi1-195-04\",\"quality-v1-PEaoyi1-195-04\",\"quality-v1-PEaoyi1-195-04\",\"quality-v1-PEaoyi1-195-04\",\"quality-v1-PEaoyi1-195-04\",\"quality-v1-PEaoyi1-195-04\",\"quality-v1-PEaoyi1-195-05\",\"quality-v1-PEaoyi1-195-05\",\"quality-v1-PEaoyi1-195-05\",\"quality-v1-PEaoyi1-195-05\",\"quality-v1-PEaoyi1-195-05\",\"quality-v1-PEaoyi1-195-05\",\"quality-v1-PEaoyi1-195-05\",\"quality-v1-PEaoyi1-195-05\",\"quality-v1-PEaoyi1-195-05\",\"quality-v1-PEaoyi1-195-00\",\"quality-v1-PEaoyi1-195-00\"],\"qualitySourceZoom\":0.7,\"action\":\"shang\"},\"PEaoyi2-12\":{\"atlas\":\"quality-v1-PEaoyi2-12-00\",\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,2,3,4,5,5,5,5,5,5,0,1,2,3,4,5,0,1,2,3,4,5,1,2,0,1,1,2,3,4,5,0,1,2,3,4,5,1,0,0,0,0,0,0,0,0,0],\"pivot\":[0.5,0.5],\"renderScale\":0.24199864956110734,\"width\":1024,\"height\":651,\"source\":\"battle\\\\effect\\\\PEaoyi2.swf\",\"sourceFrames\":80,\"uniqueFrames\":31,\"frameAtlases\":[\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-01\",\"quality-v1-PEaoyi2-12-01\",\"quality-v1-PEaoyi2-12-01\",\"quality-v1-PEaoyi2-12-01\",\"quality-v1-PEaoyi2-12-01\",\"quality-v1-PEaoyi2-12-01\",\"quality-v1-PEaoyi2-12-02\",\"quality-v1-PEaoyi2-12-02\",\"quality-v1-PEaoyi2-12-02\",\"quality-v1-PEaoyi2-12-02\",\"quality-v1-PEaoyi2-12-02\",\"quality-v1-PEaoyi2-12-02\",\"quality-v1-PEaoyi2-12-02\",\"quality-v1-PEaoyi2-12-02\",\"quality-v1-PEaoyi2-12-03\",\"quality-v1-PEaoyi2-12-03\",\"quality-v1-PEaoyi2-12-03\",\"quality-v1-PEaoyi2-12-03\",\"quality-v1-PEaoyi2-12-03\",\"quality-v1-PEaoyi2-12-03\",\"quality-v1-PEaoyi2-12-03\",\"quality-v1-PEaoyi2-12-04\",\"quality-v1-PEaoyi2-12-04\",\"quality-v1-PEaoyi2-12-04\",\"quality-v1-PEaoyi2-12-04\",\"quality-v1-PEaoyi2-12-04\",\"quality-v1-PEaoyi2-12-04\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-05\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\",\"quality-v1-PEaoyi2-12-00\"],\"qualitySourceZoom\":0.35,\"action\":\"xia\",\"screen\":true},\"PEaoyi2-414\":{\"atlas\":\"quality-v1-PEaoyi2-414-00\",\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,0,0,0,0,0,5,6,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,0,0],\"pivot\":[0.25,0.6],\"renderScale\":0.47946488294314377,\"width\":1024,\"height\":387,\"source\":\"battle\\\\effect\\\\PEaoyi2.swf\",\"sourceFrames\":80,\"uniqueFrames\":59,\"frameAtlases\":[\"quality-v1-PEaoyi2-414-00\",\"quality-v1-PEaoyi2-414-00\",\"quality-v1-PEaoyi2-414-00\",\"quality-v1-PEaoyi2-414-00\",\"quality-v1-PEaoyi2-414-00\",\"quality-v1-PEaoyi2-414-00\",\"quality-v1-PEaoyi2-414-00\",\"quality-v1-PEaoyi2-414-00\",\"quality-v1-PEaoyi2-414-00\",\"quality-v1-PEaoyi2-414-00\",\"quality-v1-PEaoyi2-414-00\",\"quality-v1-PEaoyi2-414-00\",\"quality-v1-PEaoyi2-414-00\",\"quality-v1-PEaoyi2-414-00\",\"quality-v1-PEaoyi2-414-00\",\"quality-v1-PEaoyi2-414-00\",\"quality-v1-PEaoyi2-414-00\",\"quality-v1-PEaoyi2-414-00\",\"quality-v1-PEaoyi2-414-00\",\"quality-v1-PEaoyi2-414-00\",\"quality-v1-PEaoyi2-414-00\",\"quality-v1-PEaoyi2-414-00\",\"quality-v1-PEaoyi2-414-00\",\"quality-v1-PEaoyi2-414-00\",\"quality-v1-PEaoyi2-414-00\",\"quality-v1-PEaoyi2-414-00\",\"quality-v1-PEaoyi2-414-01\",\"quality-v1-PEaoyi2-414-01\",\"quality-v1-PEaoyi2-414-01\",\"quality-v1-PEaoyi2-414-01\",\"quality-v1-PEaoyi2-414-01\",\"quality-v1-PEaoyi2-414-00\",\"quality-v1-PEaoyi2-414-00\",\"quality-v1-PEaoyi2-414-00\",\"quality-v1-PEaoyi2-414-00\",\"quality-v1-PEaoyi2-414-00\",\"quality-v1-PEaoyi2-414-01\",\"quality-v1-PEaoyi2-414-01\",\"quality-v1-PEaoyi2-414-01\",\"quality-v1-PEaoyi2-414-01\",\"quality-v1-PEaoyi2-414-01\",\"quality-v1-PEaoyi2-414-01\",\"quality-v1-PEaoyi2-414-02\",\"quality-v1-PEaoyi2-414-02\",\"quality-v1-PEaoyi2-414-02\",\"quality-v1-PEaoyi2-414-02\",\"quality-v1-PEaoyi2-414-02\",\"quality-v1-PEaoyi2-414-02\",\"quality-v1-PEaoyi2-414-02\",\"quality-v1-PEaoyi2-414-02\",\"quality-v1-PEaoyi2-414-02\",\"quality-v1-PEaoyi2-414-02\",\"quality-v1-PEaoyi2-414-03\",\"quality-v1-PEaoyi2-414-03\",\"quality-v1-PEaoyi2-414-03\",\"quality-v1-PEaoyi2-414-03\",\"quality-v1-PEaoyi2-414-03\",\"quality-v1-PEaoyi2-414-03\",\"quality-v1-PEaoyi2-414-03\",\"quality-v1-PEaoyi2-414-03\",\"quality-v1-PEaoyi2-414-03\",\"quality-v1-PEaoyi2-414-03\",\"quality-v1-PEaoyi2-414-04\",\"quality-v1-PEaoyi2-414-04\",\"quality-v1-PEaoyi2-414-04\",\"quality-v1-PEaoyi2-414-04\",\"quality-v1-PEaoyi2-414-04\",\"quality-v1-PEaoyi2-414-04\",\"quality-v1-PEaoyi2-414-04\",\"quality-v1-PEaoyi2-414-04\",\"quality-v1-PEaoyi2-414-04\",\"quality-v1-PEaoyi2-414-04\",\"quality-v1-PEaoyi2-414-04\",\"quality-v1-PEaoyi2-414-05\",\"quality-v1-PEaoyi2-414-05\",\"quality-v1-PEaoyi2-414-05\",\"quality-v1-PEaoyi2-414-05\",\"quality-v1-PEaoyi2-414-05\",\"quality-v1-PEaoyi2-414-05\",\"quality-v1-PEaoyi2-414-05\",\"quality-v1-PEaoyi2-414-05\",\"quality-v1-PEaoyi2-414-05\",\"quality-v1-PEaoyi2-414-00\",\"quality-v1-PEaoyi2-414-00\"],\"qualitySourceZoom\":0.7,\"action\":\"shang\",\"additive\":true},\"Peienchaoshenshenluotianzheng_aoyi-115\":{\"atlas\":\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,4,5,0,1,2,3,4,5,0,1,2,3,4,4,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],\"pivot\":[0.5,0.5],\"renderScale\":0.35,\"width\":817,\"height\":525,\"source\":\"battle\\\\effect\\\\Peienchaoshenshenluotianzheng_aoyi.swf\",\"sourceFrames\":163,\"uniqueFrames\":30,\"frameAtlases\":[\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-01\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-01\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-01\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-01\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-01\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-01\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-02\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-02\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-02\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-02\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-02\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-02\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-02\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-03\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-03\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-03\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-03\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-03\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-03\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-04\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-04\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-04\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-04\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-04\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-04\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-04\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-115-00\"],\"qualitySourceZoom\":0.35,\"action\":\"texie\",\"additive\":true},\"Peienchaoshenshenluotianzheng_aoyi-134\":{\"atlas\":\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,0,0,0,0,0,0,0,0,0,0,0,0,0],\"pivot\":[0.3513022813688213,1.5366346153846153],\"renderScale\":0.35,\"width\":526,\"height\":52,\"source\":\"battle\\\\effect\\\\Peienchaoshenshenluotianzheng_aoyi.swf\",\"sourceFrames\":163,\"uniqueFrames\":34,\"frameAtlases\":[\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-134-00\"],\"qualitySourceZoom\":0.35,\"action\":\"xia\"},\"Peienchaoshenshenluotianzheng_aoyi-686\":{\"atlas\":\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"timeline\":[0,0,0,0,0,0,0,0,1,2,3,0,1,1,2,3,0,1,2,3,0,1,2,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,0,1,2,3,0,1,2,3,0,1,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,0,0,0,0,0,0,0,0],\"pivot\":[0.4840825242718446,0.5833732452518579],\"renderScale\":0.22200647249190938,\"width\":980,\"height\":768,\"source\":\"battle\\\\effect\\\\Peienchaoshenshenluotianzheng_aoyi.swf\",\"sourceFrames\":163,\"uniqueFrames\":125,\"frameAtlases\":[\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-01\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-01\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-01\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-01\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-01\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-02\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-02\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-02\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-02\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-03\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-03\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-03\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-03\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-04\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-04\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-04\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-04\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-05\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-05\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-05\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-05\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-06\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-06\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-06\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-06\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-07\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-07\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-07\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-07\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-07\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-08\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-08\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-08\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-08\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-09\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-09\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-09\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-09\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-10\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-10\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-10\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-10\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-11\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-11\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-11\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-11\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-12\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-12\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-12\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-12\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-13\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-13\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-13\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-13\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-13\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-14\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-14\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-14\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-14\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-15\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-15\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-15\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-15\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-16\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-16\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-16\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-16\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-17\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-17\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-17\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-17\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-18\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-18\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-18\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-18\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-19\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-19\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-19\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-19\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-19\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-20\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-20\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-20\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-20\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-21\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-21\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-21\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-21\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-22\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-22\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-22\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-22\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-23\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-23\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-23\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-23\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-24\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-24\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-24\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-24\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-25\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-25\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-25\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-25\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-25\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-26\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-26\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-26\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-26\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-27\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-27\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-27\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-27\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-28\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-28\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-28\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-28\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-29\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-29\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-29\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-29\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-30\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-30\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-30\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-30\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-31\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\",\"quality-v1-Peienchaoshenshenluotianzheng_aoyi-686-00\"],\"qualitySourceZoom\":0.35,\"action\":\"shang\",\"additive\":true},\"PEpugong1-154\":{\"atlas\":\"quality-v1-PEpugong1-154-00\",\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,1,2,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,6,7,8,9,0,1,2,3,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],\"pivot\":[0.5,0.8443017456359101],\"renderScale\":0.7,\"width\":741,\"height\":401,\"source\":\"battle\\\\effect\\\\PEpugong1.swf\",\"sourceFrames\":65,\"uniqueFrames\":35,\"frameAtlases\":[\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-01\",\"quality-v1-PEpugong1-154-01\",\"quality-v1-PEpugong1-154-01\",\"quality-v1-PEpugong1-154-01\",\"quality-v1-PEpugong1-154-01\",\"quality-v1-PEpugong1-154-01\",\"quality-v1-PEpugong1-154-01\",\"quality-v1-PEpugong1-154-01\",\"quality-v1-PEpugong1-154-01\",\"quality-v1-PEpugong1-154-01\",\"quality-v1-PEpugong1-154-02\",\"quality-v1-PEpugong1-154-02\",\"quality-v1-PEpugong1-154-02\",\"quality-v1-PEpugong1-154-02\",\"quality-v1-PEpugong1-154-02\",\"quality-v1-PEpugong1-154-02\",\"quality-v1-PEpugong1-154-02\",\"quality-v1-PEpugong1-154-02\",\"quality-v1-PEpugong1-154-02\",\"quality-v1-PEpugong1-154-02\",\"quality-v1-PEpugong1-154-02\",\"quality-v1-PEpugong1-154-03\",\"quality-v1-PEpugong1-154-03\",\"quality-v1-PEpugong1-154-03\",\"quality-v1-PEpugong1-154-03\",\"quality-v1-PEpugong1-154-03\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\",\"quality-v1-PEpugong1-154-00\"],\"qualitySourceZoom\":0.7,\"action\":\"xia\"},\"PEpugong1-682\":{\"atlas\":\"quality-v1-PEpugong1-682-00\",\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,1,2,2,3,4,5,6,7,8,0,1,2,3,4,5,6,7,8,0,1,2,3,4,5,6,7,8,8,0,1,2,3,4,5,6,7,8,0,1,2,3,4,5,6,7,8,0,1,2,3,0,0,0,0,0,0,0],\"pivot\":[0.5,0.5674999999999999],\"renderScale\":0.7,\"width\":659,\"height\":532,\"source\":\"battle\\\\effect\\\\PEpugong1.swf\",\"sourceFrames\":65,\"uniqueFrames\":49,\"frameAtlases\":[\"quality-v1-PEpugong1-682-00\",\"quality-v1-PEpugong1-682-00\",\"quality-v1-PEpugong1-682-00\",\"quality-v1-PEpugong1-682-00\",\"quality-v1-PEpugong1-682-00\",\"quality-v1-PEpugong1-682-00\",\"quality-v1-PEpugong1-682-00\",\"quality-v1-PEpugong1-682-00\",\"quality-v1-PEpugong1-682-00\",\"quality-v1-PEpugong1-682-00\",\"quality-v1-PEpugong1-682-00\",\"quality-v1-PEpugong1-682-00\",\"quality-v1-PEpugong1-682-00\",\"quality-v1-PEpugong1-682-00\",\"quality-v1-PEpugong1-682-00\",\"quality-v1-PEpugong1-682-00\",\"quality-v1-PEpugong1-682-00\",\"quality-v1-PEpugong1-682-00\",\"quality-v1-PEpugong1-682-00\",\"quality-v1-PEpugong1-682-00\",\"quality-v1-PEpugong1-682-01\",\"quality-v1-PEpugong1-682-01\",\"quality-v1-PEpugong1-682-01\",\"quality-v1-PEpugong1-682-01\",\"quality-v1-PEpugong1-682-01\",\"quality-v1-PEpugong1-682-01\",\"quality-v1-PEpugong1-682-01\",\"quality-v1-PEpugong1-682-01\",\"quality-v1-PEpugong1-682-01\",\"quality-v1-PEpugong1-682-02\",\"quality-v1-PEpugong1-682-02\",\"quality-v1-PEpugong1-682-02\",\"quality-v1-PEpugong1-682-02\",\"quality-v1-PEpugong1-682-02\",\"quality-v1-PEpugong1-682-02\",\"quality-v1-PEpugong1-682-02\",\"quality-v1-PEpugong1-682-02\",\"quality-v1-PEpugong1-682-02\",\"quality-v1-PEpugong1-682-02\",\"quality-v1-PEpugong1-682-03\",\"quality-v1-PEpugong1-682-03\",\"quality-v1-PEpugong1-682-03\",\"quality-v1-PEpugong1-682-03\",\"quality-v1-PEpugong1-682-03\",\"quality-v1-PEpugong1-682-03\",\"quality-v1-PEpugong1-682-03\",\"quality-v1-PEpugong1-682-03\",\"quality-v1-PEpugong1-682-03\",\"quality-v1-PEpugong1-682-04\",\"quality-v1-PEpugong1-682-04\",\"quality-v1-PEpugong1-682-04\",\"quality-v1-PEpugong1-682-04\",\"quality-v1-PEpugong1-682-04\",\"quality-v1-PEpugong1-682-04\",\"quality-v1-PEpugong1-682-04\",\"quality-v1-PEpugong1-682-04\",\"quality-v1-PEpugong1-682-04\",\"quality-v1-PEpugong1-682-05\",\"quality-v1-PEpugong1-682-05\",\"quality-v1-PEpugong1-682-05\",\"quality-v1-PEpugong1-682-05\",\"quality-v1-PEpugong1-682-00\",\"quality-v1-PEpugong1-682-00\",\"quality-v1-PEpugong1-682-00\",\"quality-v1-PEpugong1-682-00\",\"quality-v1-PEpugong1-682-00\",\"quality-v1-PEpugong1-682-00\",\"quality-v1-PEpugong1-682-00\"],\"qualitySourceZoom\":0.7,\"action\":\"shang\"},\"PEzhuida-308\":{\"atlas\":\"quality-v1-PEzhuida-308-00\",\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,1,2,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,2,3,4,5,0,1,2,3,4,5,0,1,2,0,0,0],\"pivot\":[0.5,0.8559379615952734],\"renderScale\":0.6309859154929577,\"width\":1024,\"height\":610,\"source\":\"battle\\\\effect\\\\PEzhuida.swf\",\"sourceFrames\":51,\"uniqueFrames\":39,\"frameAtlases\":[\"quality-v1-PEzhuida-308-00\",\"quality-v1-PEzhuida-308-00\",\"quality-v1-PEzhuida-308-00\",\"quality-v1-PEzhuida-308-00\",\"quality-v1-PEzhuida-308-00\",\"quality-v1-PEzhuida-308-00\",\"quality-v1-PEzhuida-308-00\",\"quality-v1-PEzhuida-308-00\",\"quality-v1-PEzhuida-308-00\",\"quality-v1-PEzhuida-308-00\",\"quality-v1-PEzhuida-308-00\",\"quality-v1-PEzhuida-308-00\",\"quality-v1-PEzhuida-308-00\",\"quality-v1-PEzhuida-308-00\",\"quality-v1-PEzhuida-308-00\",\"quality-v1-PEzhuida-308-00\",\"quality-v1-PEzhuida-308-00\",\"quality-v1-PEzhuida-308-01\",\"quality-v1-PEzhuida-308-01\",\"quality-v1-PEzhuida-308-01\",\"quality-v1-PEzhuida-308-01\",\"quality-v1-PEzhuida-308-01\",\"quality-v1-PEzhuida-308-01\",\"quality-v1-PEzhuida-308-02\",\"quality-v1-PEzhuida-308-02\",\"quality-v1-PEzhuida-308-02\",\"quality-v1-PEzhuida-308-02\",\"quality-v1-PEzhuida-308-02\",\"quality-v1-PEzhuida-308-02\",\"quality-v1-PEzhuida-308-03\",\"quality-v1-PEzhuida-308-03\",\"quality-v1-PEzhuida-308-03\",\"quality-v1-PEzhuida-308-03\",\"quality-v1-PEzhuida-308-03\",\"quality-v1-PEzhuida-308-03\",\"quality-v1-PEzhuida-308-04\",\"quality-v1-PEzhuida-308-04\",\"quality-v1-PEzhuida-308-04\",\"quality-v1-PEzhuida-308-04\",\"quality-v1-PEzhuida-308-04\",\"quality-v1-PEzhuida-308-04\",\"quality-v1-PEzhuida-308-04\",\"quality-v1-PEzhuida-308-05\",\"quality-v1-PEzhuida-308-05\",\"quality-v1-PEzhuida-308-05\",\"quality-v1-PEzhuida-308-05\",\"quality-v1-PEzhuida-308-05\",\"quality-v1-PEzhuida-308-05\",\"quality-v1-PEzhuida-308-06\",\"quality-v1-PEzhuida-308-06\",\"quality-v1-PEzhuida-308-06\",\"quality-v1-PEzhuida-308-00\",\"quality-v1-PEzhuida-308-00\",\"quality-v1-PEzhuida-308-00\"],\"qualitySourceZoom\":0.7,\"action\":\"shang\"},\"PEzhuida-81\":{\"atlas\":\"quality-v1-PEzhuida-81-00\",\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,4,5,6,7,8,9,10,11,12,13,0,1,2,3,4,5,6,7,7,8,9,10,11,12,13,0,0,0,0,0,0,0,0,0],\"pivot\":[0.5,0.5156037735849056],\"renderScale\":0.7,\"width\":824,\"height\":265,\"source\":\"battle\\\\effect\\\\PEzhuida.swf\",\"sourceFrames\":51,\"uniqueFrames\":28,\"frameAtlases\":[\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-01\",\"quality-v1-PEzhuida-81-01\",\"quality-v1-PEzhuida-81-01\",\"quality-v1-PEzhuida-81-01\",\"quality-v1-PEzhuida-81-01\",\"quality-v1-PEzhuida-81-01\",\"quality-v1-PEzhuida-81-01\",\"quality-v1-PEzhuida-81-01\",\"quality-v1-PEzhuida-81-01\",\"quality-v1-PEzhuida-81-01\",\"quality-v1-PEzhuida-81-01\",\"quality-v1-PEzhuida-81-01\",\"quality-v1-PEzhuida-81-01\",\"quality-v1-PEzhuida-81-01\",\"quality-v1-PEzhuida-81-01\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\",\"quality-v1-PEzhuida-81-00\"],\"qualitySourceZoom\":0.7,\"action\":\"xia\"}},\"effects\":{\"DASHEWAN_tongyongfuhuo\":[\"DASHEWAN_tongyongfuhuo-213\"],\"PEaoyi1\":[\"PEaoyi1-195\"],\"PEaoyi2\":[\"PEaoyi2-12\",\"PEaoyi2-414\"],\"Peienchaoshenshenluotianzheng_aoyi\":[\"Peienchaoshenshenluotianzheng_aoyi-115\",\"Peienchaoshenshenluotianzheng_aoyi-134\",\"Peienchaoshenshenluotianzheng_aoyi-686\"],\"PEpugong1\":[\"PEpugong1-154\",\"PEpugong1-682\"],\"PEzhuida\":[\"PEzhuida-308\",\"PEzhuida-81\"]}}");
      }
      
      private static function PreloadPainVfx() : void
      {
         var manifest:Object = PainVfxManifest();
         for each(var effect:String in ["DASHEWAN_tongyongfuhuo","PEaoyi1","PEaoyi2"])
         {
            for each(var name:String in manifest.effects[effect])
            {
               var clip:Object = manifest.clips[name];
               LoadPainVfxAtlas(String(clip.atlas),manifest.atlases[clip.atlas]);
            }
         }
      }
      
      private static function TrimPainVfxCache(keep:String) : void
      {
         var pixels:Number = 0;
         var entries:int = 0;
         for(var key:String in FPainFxCache)
         {
            var frames:Array = FPainFxCache[key] as Array;
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
            for(key in FPainFxCache)
            {
               if(key != keep && Number(FPainFxLoading["_age_" + key]) < age)
               {
                  oldest = key;
                  age = Number(FPainFxLoading["_age_" + key]);
               }
            }
            if(oldest == null)
            {
               break;
            }
            frames = FPainFxCache[oldest] as Array;
            pixels -= frames.length * BitmapData(frames[0]).width * BitmapData(frames[0]).height;
            delete FPainFxCache[oldest];
            delete FPainFxLoading["_age_" + oldest];
            entries--;
         }
      }
      
      private static function LoadPainVfxAtlas(name:String, meta:Object) : void
      {
         var loader:Loader;
         var complete:Function;
         var failed:Function;
         var release:Function;
         FPainFxLoading["_age_" + name] = getTimer();
         if(FPainFxCache[name] != null || FPainFxLoading[name])
         {
            return;
         }
         FPainFxLoading[name] = true;
         loader = new Loader();
         release = function():void
         {
            loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,complete);
            loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,failed);
            loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,failed);
            delete FPainFxLoading[name];
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
            FPainFxCache[name] = frames;
            TrimPainVfxCache(name);
            loader.unload();
         };
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,complete);
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,failed);
         loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,failed);
         loader.load(new URLRequest(String(meta.url)));
      }
      
      private static function HashiramaVfxManifest() : Object
      {
         return JSON.parse("{\"version\":6,\"frameRate\":25,\"frameMs\":40,\"atlases\":{\"thousand-hands-hq-v2-00\":{\"url\":\"/public/hashirama-vfx/extracted/thousand-hands-hq-v2-00.png\",\"columns\":4,\"rows\":7,\"frameCount\":28},\"thousand-hands-hq-v2-01\":{\"url\":\"/public/hashirama-vfx/extracted/thousand-hands-hq-v2-01.png\",\"columns\":4,\"rows\":7,\"frameCount\":28},\"thousand-hands-hq-v2-02\":{\"url\":\"/public/hashirama-vfx/extracted/thousand-hands-hq-v2-02.png\",\"columns\":4,\"rows\":7,\"frameCount\":28},\"thousand-hands-hq-v2-03\":{\"url\":\"/public/hashirama-vfx/extracted/thousand-hands-hq-v2-03.png\",\"columns\":4,\"rows\":7,\"frameCount\":28},\"thousand-hands-hq-v2-04\":{\"url\":\"/public/hashirama-vfx/extracted/thousand-hands-hq-v2-04.png\",\"columns\":4,\"rows\":7,\"frameCount\":28},\"thousand-hands-hq-v2-05\":{\"url\":\"/public/hashirama-vfx/extracted/thousand-hands-hq-v2-05.png\",\"columns\":4,\"rows\":7,\"frameCount\":28},\"thousand-hands-hq-v2-06\":{\"url\":\"/public/hashirama-vfx/extracted/thousand-hands-hq-v2-06.png\",\"columns\":4,\"rows\":5,\"frameCount\":19},\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanbangpaizhishu-364-00.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanbangpaizhishu-364-01\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanbangpaizhishu-364-01.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanbangpaizhishu-364-02\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanbangpaizhishu-364-02.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanbangpaizhishu-364-03\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanbangpaizhishu-364-03.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanbangpaizhishu-364-04\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanbangpaizhishu-364-04.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanbangpaizhishu-364-05\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanbangpaizhishu-364-05.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanbangpaizhishu-364-06\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanbangpaizhishu-364-06.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanbangpaizhishu-364-07\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanbangpaizhishu-364-07.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanbangpaizhishu-364-08\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanbangpaizhishu-364-08.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanbangpaizhishu-364-09\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanbangpaizhishu-364-09.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanbangpaizhishu-364-10\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanbangpaizhishu-364-10.png\",\"columns\":2,\"rows\":1,\"frameCount\":1},\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanbangpaizhishu-54-00.png\",\"columns\":2,\"rows\":5,\"frameCount\":10},\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanbangpaizhishu-54-01.png\",\"columns\":2,\"rows\":5,\"frameCount\":10},\"quality-v1-Zhujianzhongyanbangpaizhishu-54-02\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanbangpaizhishu-54-02.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-128-00.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-01\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-128-01.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-02\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-128-02.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-03\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-128-03.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-04\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-128-04.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-05\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-128-05.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-06\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-128-06.png\",\"columns\":2,\"rows\":3,\"frameCount\":5},\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-281-00.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-01\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-281-01.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-02\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-281-02.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-03\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-281-03.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-04\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-281-04.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-05\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-281-05.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-06\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-281-06.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-07\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-281-07.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-08\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-281-08.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-09\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-281-09.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-10\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-281-10.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-11\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanhuashujiejianglin-281-11.png\",\"columns\":2,\"rows\":1,\"frameCount\":2},\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-170-00.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-170-01\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-170-01.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-170-02\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-170-02.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-170-03\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-170-03.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-170-04\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-170-04.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-170-05\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-170-05.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-170-06\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-170-06.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-170-07\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-170-07.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-170-08\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-170-08.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-170-09\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-170-09.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-170-10\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-170-10.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-170-11\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-170-11.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-170-12\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-170-12.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-00.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-01\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-01.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-02\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-02.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-03\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-03.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-04\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-04.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-05\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-05.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-06\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-06.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-07\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-07.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-08\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-08.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-09\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-09.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-10\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-10.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-11\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-11.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-12\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-12.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-13\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-13.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-14\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-14.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-15\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-15.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-16\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-16.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-17\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-17.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-18\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-18.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-19\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-19.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanmingshenfenglong-688-20\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong-688-20.png\",\"columns\":2,\"rows\":2,\"frameCount\":3},\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-01\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-01.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanshujiejiangdan-139-00.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanshujiejiangdan-139-01\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanshujiejiangdan-139-01.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanshujiejiangdan-139-02\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanshujiejiangdan-139-02.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanshujiejiangdan-139-03\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanshujiejiangdan-139-03.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanshujiejiangdan-139-04\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanshujiejiangdan-139-04.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanshujiejiangdan-139-05\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanshujiejiangdan-139-05.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanshujiejiangdan-139-06\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanshujiejiangdan-139-06.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanshujiejiangdan-139-07\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanshujiejiangdan-139-07.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanshujiejiangdan-139-08\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanshujiejiangdan-139-08.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanshujiejiangdan-139-09\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanshujiejiangdan-139-09.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanshujiejiangdan-139-10\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanshujiejiangdan-139-10.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanshujiejiangdan-80-00.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanshujiejiangdan-80-01\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanshujiejiangdan-80-01.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanshujiejiangdan-80-02\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanshujiejiangdan-80-02.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanshujiejiangdan-80-03\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanshujiejiangdan-80-03.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanshujiejiangdan-80-04\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanshujiejiangdan-80-04.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanshujiejiangdan-80-05\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanshujiejiangdan-80-05.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"quality-v1-Zhujianzhongyanshujiejiangdan-80-06\":{\"url\":\"/public/hashirama-vfx/extracted/quality-v1-Zhujianzhongyanshujiejiangdan-80-06.png\",\"columns\":2,\"rows\":3,\"frameCount\":6}},\"clips\":{\"Zhujianzhongyanbangpaizhishu-364\":{\"atlas\":\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\",\"timeline\":[0,0,0,0,0,0,0,0,0,0,1,2,3,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,3,4,5,0,1,2,3,4,5,0,0],\"pivot\":[0.4364342774146695,0.7023794808405438],\"renderScale\":0.5205519244734931,\"width\":1024,\"height\":602,\"source\":\"battle\\\\effect\\\\Zhujianzhongyanbangpaizhishu.swf\",\"sourceFrames\":71,\"uniqueFrames\":61,\"frameAtlases\":[\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-02\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-02\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-02\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-02\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-02\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-02\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-03\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-03\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-03\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-03\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-03\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-03\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-04\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-04\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-04\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-04\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-04\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-04\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-04\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-05\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-05\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-05\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-05\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-05\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-05\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-06\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-06\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-06\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-06\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-06\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-06\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-07\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-07\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-07\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-07\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-07\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-07\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-08\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-08\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-08\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-08\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-08\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-08\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-08\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-09\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-09\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-09\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-09\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-09\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-09\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-10\",\"quality-v1-Zhujianzhongyanbangpaizhishu-364-00\"],\"qualitySourceZoom\":0.7},\"Zhujianzhongyanbangpaizhishu-54\":{\"atlas\":\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"timeline\":[0,0,0,0,0,0,0,0,0,0,1,2,3,3,4,5,6,7,8,9,0,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6,7,8,8,9,0,1,2,3,0,0,0,0,0],\"pivot\":[0.5346039035591275,0.49717213114754105],\"renderScale\":0.7,\"width\":871,\"height\":366,\"source\":\"battle\\\\effect\\\\Zhujianzhongyanbangpaizhishu.swf\",\"sourceFrames\":71,\"uniqueFrames\":24,\"frameAtlases\":[\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-01\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-02\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-02\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-02\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-02\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\",\"quality-v1-Zhujianzhongyanbangpaizhishu-54-00\"],\"qualitySourceZoom\":0.7},\"Zhujianzhongyanhuashujiejianglin-128\":{\"atlas\":\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,3,4,5,0,1,2,3,4,5,0,1,2,3,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],\"pivot\":[0.3562900188323917,0.47578518518518514],\"renderScale\":0.3374764595103578,\"width\":1024,\"height\":651,\"source\":\"battle\\\\effect\\\\Zhujianzhongyanhuashujiejianglin.swf\",\"sourceFrames\":101,\"uniqueFrames\":41,\"frameAtlases\":[\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-01\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-01\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-01\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-01\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-01\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-01\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-02\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-02\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-02\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-02\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-02\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-02\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-03\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-03\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-03\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-03\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-03\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-03\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-04\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-04\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-04\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-04\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-04\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-04\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-04\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-05\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-05\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-05\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-05\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-05\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-05\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-06\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-06\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-06\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-06\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-06\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-128-00\"],\"qualitySourceZoom\":0.35},\"Zhujianzhongyanhuashujiejianglin-281\":{\"atlas\":\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,4,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,0,0],\"pivot\":[0.5783964646464645,0.41012128325508596],\"renderScale\":0.35,\"width\":990,\"height\":639,\"source\":\"battle\\\\effect\\\\Zhujianzhongyanhuashujiejianglin.swf\",\"sourceFrames\":101,\"uniqueFrames\":68,\"frameAtlases\":[\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-01\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-01\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-01\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-01\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-01\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-01\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-02\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-02\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-02\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-02\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-02\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-02\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-03\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-03\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-03\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-03\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-03\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-03\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-04\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-04\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-04\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-04\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-04\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-04\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-04\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-05\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-05\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-05\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-05\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-05\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-05\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-06\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-06\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-06\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-06\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-06\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-06\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-07\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-07\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-07\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-07\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-07\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-07\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-08\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-08\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-08\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-08\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-08\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-08\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-08\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-09\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-09\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-09\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-09\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-09\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-09\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-10\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-10\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-10\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-10\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-10\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-10\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-11\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-11\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\",\"quality-v1-Zhujianzhongyanhuashujiejianglin-281-00\"],\"qualitySourceZoom\":0.35},\"Zhujianzhongyanmingshenfenglong-170\":{\"atlas\":\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,0,1,2,3,0,1,2,3,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,3,0,1,2,3,3,3,3,3,0,1,2,3,0,1,2,3,0,1,2,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],\"pivot\":[0.007564858490566036,0.8143455497382198],\"renderScale\":0.6999999999999998,\"width\":848,\"height\":764,\"source\":\"battle\\\\effect\\\\Zhujianzhongyanmingshenfenglong.swf\",\"sourceFrames\":131,\"uniqueFrames\":52,\"frameAtlases\":[\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-02\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-02\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-02\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-02\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-02\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-03\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-03\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-03\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-03\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-04\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-04\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-04\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-04\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-05\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-05\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-05\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-05\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-06\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-06\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-06\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-06\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-07\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-07\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-07\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-07\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-08\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-08\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-08\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-08\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-08\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-09\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-09\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-09\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-09\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-09\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-09\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-09\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-09\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-10\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-10\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-10\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-10\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-11\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-11\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-11\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-11\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-12\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-12\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-12\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-12\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-170-00\"],\"qualitySourceZoom\":0.7},\"Zhujianzhongyanmingshenfenglong-688\":{\"atlas\":\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"timeline\":[0,0,0,0,0,0,0,0,1,2,3,0,1,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,1,2,3,0,1,2,3,0,1,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],\"pivot\":[0.20673220338983048,0.6171563088512241],\"renderScale\":0.4859661016949152,\"width\":1024,\"height\":737,\"source\":\"battle\\\\effect\\\\Zhujianzhongyanmingshenfenglong.swf\",\"sourceFrames\":131,\"uniqueFrames\":83,\"frameAtlases\":[\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-02\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-02\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-02\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-02\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-03\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-03\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-03\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-03\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-04\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-04\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-04\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-04\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-02\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-02\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-02\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-02\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-03\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-03\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-03\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-03\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-03\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-04\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-04\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-04\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-04\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-05\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-05\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-05\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-05\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-06\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-06\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-06\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-06\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-07\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-07\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-07\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-07\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-08\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-08\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-08\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-08\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-08\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-09\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-09\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-09\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-09\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-10\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-10\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-10\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-10\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-11\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-11\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-11\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-11\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-12\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-12\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-12\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-12\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-13\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-13\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-13\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-13\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-14\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-14\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-14\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-14\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-14\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-15\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-15\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-15\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-15\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-16\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-16\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-16\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-16\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-17\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-17\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-17\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-17\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-18\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-18\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-18\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-18\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-19\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-19\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-19\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-19\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-20\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-20\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-20\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong-688-00\"],\"qualitySourceZoom\":0.7},\"Zhujianzhongyanmingshenfenglong_texie-272\":{\"atlas\":\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"timeline\":[0,0,0,0,0,0,0,0,0,1,2,3,3,3,4,5,5,0,1,2,2,3,5,5,0,1,2,2,3,5,5,0,1,2,2,3,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],\"pivot\":[0.5,0.5],\"renderScale\":1,\"width\":1024,\"height\":576,\"source\":\"battle\\\\effect\\\\Zhujianzhongyanmingshenfenglong_texie.swf\",\"sourceFrames\":62,\"uniqueFrames\":10,\"frameAtlases\":[\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-01\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\",\"quality-v1-Zhujianzhongyanmingshenfenglong_texie-272-00\"],\"qualitySourceZoom\":0.35,\"cinematic\":true,\"portraitSourceResolution\":[1920,1080]},\"Zhujianzhongyanshujiejiangdan-139\":{\"atlas\":\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,0,1,2,3,0,1,2,3,0,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,0,1,2,3,0,1,2,3,0],\"pivot\":[0.4461380772855796,0.4423536960985627],\"renderScale\":0.2761074458058435,\"width\":837,\"height\":768,\"source\":\"battle\\\\effect\\\\Zhujianzhongyanshujiejiangdan.swf\",\"sourceFrames\":69,\"uniqueFrames\":44,\"frameAtlases\":[\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-01\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-01\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-01\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-01\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-02\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-02\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-02\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-02\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-03\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-03\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-03\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-03\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-03\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-04\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-04\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-04\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-04\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-05\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-05\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-05\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-05\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-06\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-06\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-06\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-06\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-07\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-07\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-07\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-07\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-08\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-08\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-08\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-08\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-09\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-09\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-09\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-09\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-09\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-10\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-10\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-10\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-10\",\"quality-v1-Zhujianzhongyanshujiejiangdan-139-00\"],\"qualitySourceZoom\":0.35},\"Zhujianzhongyanshujiejiangdan-80\":{\"atlas\":\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,4,5,0,1,2,3,4,5,0,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,0,1,2,3,4,5,0,0,0],\"pivot\":[0.31678175403225806,0.5209835355285962],\"renderScale\":0.35,\"width\":992,\"height\":577,\"source\":\"battle\\\\effect\\\\Zhujianzhongyanshujiejiangdan.swf\",\"sourceFrames\":69,\"uniqueFrames\":42,\"frameAtlases\":[\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-01\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-01\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-01\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-01\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-01\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-01\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-02\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-02\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-02\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-02\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-02\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-02\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-02\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-03\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-03\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-03\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-03\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-03\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-03\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-04\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-04\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-04\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-04\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-04\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-04\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-05\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-05\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-05\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-05\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-05\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-05\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-06\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-06\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-06\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-06\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-06\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-06\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-06\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\",\"quality-v1-Zhujianzhongyanshujiejiangdan-80-00\"],\"qualitySourceZoom\":0.35},\"Hashirama-thousand-hands-cinematic\":{\"atlas\":\"thousand-hands-hq-v2-00\",\"frameAtlases\":[\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-01\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-02\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-03\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-04\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-05\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-06\",\"thousand-hands-hq-v2-00\",\"thousand-hands-hq-v2-00\"],\"timeline\":[0,0,0,0,0,0,0,0,0,1,2,3,4,4,5,6,7,8,8,9,10,7,8,9,9,10,7,7,8,9,9,10,7,8,8,9,10,7,7,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,0,1,2,3,4,5,6,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,0,1,2,2,3,4,0,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,25,26,27,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,21,22,23,24,25,26,27,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,17,18,19,20,21,22,23,24,25,26,27,0,1,2,3,4,5,6,7,8,9,10,11,12,13,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,0,1,2,3,4,5,6,7,8,9,9,10,11,12,13,14,15,16,17,18,0,0],\"pivot\":[0.5,0.5],\"width\":1024,\"height\":576,\"renderScale\":1,\"sourceFrames\":216,\"uniqueFrames\":187,\"cinematic\":true,\"source\":\"Original dingshanghuafo + texie SWF timelines\",\"camera\":[-170,-245,350,47.5],\"closeupCamera\":[240,40,1680,850],\"portraitSourceResolution\":[1920,1080],\"portraitFrames\":{\"1\":null,\"2\":null,\"3\":null,\"4\":null,\"5\":null,\"6\":null,\"7\":null,\"8\":null,\"9\":null,\"10\":null,\"11\":null,\"12\":\"3\",\"13\":\"41\",\"14\":\"61\",\"15\":\"81\",\"16\":\"100\",\"17\":\"117\",\"18\":\"117\",\"19\":\"146\",\"20\":\"162\",\"21\":\"100\",\"22\":\"117\",\"23\":\"146\",\"24\":\"146\",\"25\":\"162\",\"26\":\"100\",\"27\":\"100\",\"28\":\"117\",\"29\":\"146\",\"30\":\"146\",\"31\":\"162\",\"32\":\"100\",\"33\":\"117\",\"34\":\"117\",\"35\":\"146\",\"36\":\"162\",\"37\":\"100\",\"38\":null,\"39\":null,\"40\":null,\"41\":null,\"42\":null,\"43\":null,\"44\":null,\"45\":null,\"46\":null,\"47\":null,\"48\":null,\"49\":null,\"50\":null,\"51\":null,\"52\":null,\"53\":null,\"54\":null,\"55\":null,\"56\":null,\"57\":null,\"58\":null,\"59\":null,\"60\":null,\"61\":null,\"62\":null,\"63\":null,\"64\":null,\"65\":null,\"66\":null,\"67\":null,\"68\":null,\"69\":null,\"70\":null,\"71\":null,\"72\":null,\"73\":null,\"74\":null,\"75\":null,\"76\":null,\"77\":null,\"78\":null,\"79\":null,\"80\":null,\"81\":null,\"82\":null,\"83\":null,\"84\":null,\"85\":null,\"86\":null,\"87\":null,\"88\":null,\"89\":null,\"90\":null,\"91\":null,\"92\":null,\"93\":null,\"94\":null,\"95\":null,\"96\":null,\"97\":null,\"98\":null,\"99\":null,\"100\":null}}},\"effects\":{\"Zhujianzhongyanbangpaizhishu\":[\"Zhujianzhongyanbangpaizhishu-364\",\"Zhujianzhongyanbangpaizhishu-54\"],\"Zhujianzhongyanhuashujiejianglin\":[\"Zhujianzhongyanhuashujiejianglin-128\",\"Zhujianzhongyanhuashujiejianglin-281\"],\"Zhujianzhongyanmingshenfenglong\":[\"Zhujianzhongyanmingshenfenglong-170\",\"Zhujianzhongyanmingshenfenglong-688\"],\"Zhujianzhongyanmingshenfenglong_texie\":[\"Zhujianzhongyanmingshenfenglong_texie-272\"],\"Zhujianzhongyanshujiejiangdan\":[\"Zhujianzhongyanshujiejiangdan-139\",\"Zhujianzhongyanshujiejiangdan-80\"],\"Hashirama-thousand-hands-cinematic\":[\"Hashirama-thousand-hands-cinematic\"]},\"effectAnchors\":{\"Zhujianzhongyanmingshenfenglong\":[652.9390066964287,214.32729569692464],\"Zhujianzhongyanbangpaizhishu\":[-5.728571428571419,95.59285714285714],\"Zhujianzhongyanshujiejiangdan\":[347.98927291346683,1156.3337615343178],\"Zhujianzhongyanhuashujiejianglin\":[310.7473214285716,960.8487801339287]}}");
      }
      
      private static function PreloadHashiramaVfx() : void
      {
         var manifest:Object = HashiramaVfxManifest();
         for each(var effect:String in ["Zhujianzhongyanhuashujiejianglin","Zhujianzhongyanmingshenfenglong","Zhujianzhongyanmingshenfenglong_texie"])
         {
            for each(var name:String in manifest.effects[effect])
            {
               var clip:Object = manifest.clips[name];
               LoadHashiramaVfxAtlas(String(clip.atlas),manifest.atlases[clip.atlas]);
            }
         }
      }
      
      private static function TrimHashiramaVfxCache(keep:String) : void
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
      
      private static function LoadHashiramaVfxAtlas(name:String, meta:Object) : void
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
            FHashiramaFxCache[name] = frames;
            TrimHashiramaVfxCache(name);
            loader.unload();
         };
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,complete);
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,failed);
         loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,failed);
         loader.load(new URLRequest(String(meta.url)));
      }
      
      private static function PreloadMechaVfx() : void
      {
         var manifest:Object = MechaVfxManifest();
         for each(var effect:String in ["Jijiamingren_aoyi","Jijiamingren_ji_aoyi","Jijiamingren_jiuweilama_hengsao","Jijiamingren_jiuweilama_weisouyu","Jijiamingren_jiuweilama_zhuaji","Jijiamingren_liandan_pugong3","Jijiamingren_luoxuanwan_zhuida","Jijiamingren_qianghua_pugong","Jijiamingren_shanbi"])
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
                     LoadMechaVfxAtlas(page,manifest.atlases[page]);
                  }
                  head++;
               }
            }
         }
      }
      
      private static function MechaPinPages(previous:Array, current:Array) : void
      {
         var pins:Object = FMechaFxLoading["_pins"];
         if(pins == null)
         {
            pins = {};
            FMechaFxLoading["_pins"] = pins;
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
         var queue:Array = FMechaFxLoading["_queue"] as Array;
         if(queue != null)
         {
            var i:int = queue.length - 1;
            while(i >= 0)
            {
               var queued:String = String(queue[i].name);
               if(int(pins[queued]) == 0 && !MechaFirstAtlas(queued))
               {
                  queue.splice(i,1);
                  delete FMechaFxLoading[queued];
               }
               i--;
            }
         }
      }
      
      private static function PumpMechaVfxQueue() : void
      {
         var job:Object;
         var name:String;
         var meta:Object;
         var loader:URLLoader;
         var complete:Function;
         var failed:Function;
         var release:Function;
         var queue:Array = FMechaFxLoading["_queue"] as Array;
         if(queue == null || queue.length == 0 || int(FMechaFxLoading["_inflight"]) >= 6)
         {
            return;
         }
         queue.sortOn("deadline",Array.NUMERIC);
         job = queue.shift();
         name = String(job.name);
         meta = job.meta;
         FMechaFxLoading["_inflight"] = int(FMechaFxLoading["_inflight"]) + 1;
         loader = new URLLoader();
         loader.dataFormat = URLLoaderDataFormat.BINARY;
         release = function():void
         {
            loader.removeEventListener(Event.COMPLETE,complete);
            loader.removeEventListener(IOErrorEvent.IO_ERROR,failed);
            loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,failed);
            delete FMechaFxLoading[name];
            FMechaFxLoading["_inflight"] = Math.max(0,int(FMechaFxLoading["_inflight"]) - 1);
            loader.data = null;
            PumpMechaVfxQueue();
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
                  FMechaFxCache[name] = frames;
                  TrimMechaVfxCache(name);
               }
            }
            catch(error:Error)
            {
               if(data != null)
               {
                  data.clear();
               }
               if(source != null && FMechaFxCache[name] == null)
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
         PumpMechaVfxQueue();
      }
      
      private static function LoadMechaVfxAtlas(name:String, meta:Object, urgent:Boolean = false, lead:int = 0) : void
      {
         if(meta == null)
         {
            return;
         }
         FMechaFxLoading["_age_" + name] = getTimer();
         if(FMechaFxCache[name] != null)
         {
            return;
         }
         var queue:Array = FMechaFxLoading["_queue"] as Array;
         if(queue == null)
         {
            queue = [];
            FMechaFxLoading["_queue"] = queue;
         }
         if(FMechaFxLoading[name])
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
         FMechaFxLoading[name] = true;
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
         PumpMechaVfxQueue();
      }
      
      private static function TrimMechaVfxCache(keep:String) : void
      {
         var pixels:Number = 0;
         var pins:Object = FMechaFxLoading["_pins"];
         for(var key:String in FMechaFxCache)
         {
            var frames:Array = FMechaFxCache[key] as Array;
            if(frames != null && frames.length > 0)
            {
               pixels += BitmapData(frames[0]).width * BitmapData(frames[0]).height;
            }
         }
         while(pixels > 40000000)
         {
            var oldest:String = null;
            var age:Number = Number.MAX_VALUE;
            for(key in FMechaFxCache)
            {
               if(key != keep && !MechaFirstAtlas(key) && (pins == null || int(pins[key]) == 0) && Number(FMechaFxLoading["_age_" + key]) < age)
               {
                  oldest = key;
                  age = Number(FMechaFxLoading["_age_" + key]);
               }
            }
            if(oldest == null)
            {
               break;
            }
            frames = FMechaFxCache[oldest] as Array;
            var atlas:BitmapData = BitmapData(frames[0]);
            pixels -= atlas.width * atlas.height;
            delete FMechaFxCache[oldest];
            delete FMechaFxLoading["_age_" + oldest];
            atlas.dispose();
         }
      }
      
      private static function MechaFirstAtlas(key:String) : Boolean
      {
         return MechaVfxManifest().firstAtlases[key] === true;
      }
      
      private static function MechaVfxManifest() : Object
      {
         if(FMechaFxLoading["_manifest"] != null)
         {
            return FMechaFxLoading["_manifest"];
         }
         var manifest:Object = JSON.parse("{\"version\":6,\"frameMs\":40,\"frameRate\":25,\"atlases\":{\"Jijiamingren_aoyi-1343-pages-v3-0\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-0.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-1\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-1.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-2\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-2.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-3\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-3.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-4\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-4.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-5\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-5.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-6\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-6.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-7\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-7.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-8\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-8.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-9\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-9.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-10\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-10.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-11\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-11.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-12\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-12.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-13\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-13.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-14\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-14.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-15\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-15.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-16\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-16.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-17\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-17.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-18\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-18.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-19\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-19.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-20\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-20.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-21\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-21.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-22\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-22.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-23\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-23.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-24\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-24.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-25\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-25.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-26\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-26.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-27\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-27.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-28\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-28.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-29\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-29.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-30\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-30.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-31\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-31.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-32\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-32.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-33\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-33.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-34\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-34.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-35\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-35.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-36\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-36.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-37\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-37.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-38\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-38.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-39\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-39.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-40\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-40.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-41\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-41.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-42\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-42.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-43\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-43.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-44\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-44.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-45\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-45.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-46\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-46.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-47\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-47.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-48\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-48.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-49\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-49.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-50\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-50.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-51\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-51.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-52\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-52.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-53\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-53.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-54\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-54.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-55\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-55.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-56\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-56.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-57\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-57.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-58\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-58.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-59\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-59.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-60\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-60.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-61\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-61.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-62\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-62.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-63\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-63.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-64\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-64.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-65\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-65.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-66\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-66.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-67\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-67.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-68\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-68.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-69\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-69.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-70\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-70.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-71\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-71.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-72\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-72.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-73\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-73.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-74\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-74.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-1343-pages-v3-75\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-1343-pages-v3-75.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-0\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-0.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-1\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-1.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-2\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-2.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-3\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-3.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-4\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-4.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-5\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-5.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-6\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-6.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-7\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-7.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-8\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-8.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-9\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-9.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-10\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-10.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-11\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-11.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-12\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-12.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-13\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-13.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-14\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-14.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-15\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-15.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-16\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-16.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-17\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-17.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-18\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-18.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-19\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-19.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-20\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-20.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-21\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-21.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-22\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-22.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-23\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-23.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-24\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-24.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-25\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-25.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-26\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-26.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-27\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-27.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-28\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-28.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-29\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-29.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-30\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-30.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-31\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-31.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-32\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-32.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-33\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-33.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-34\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-34.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-35\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-35.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-36\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-36.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-37\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-37.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-38\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-38.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-39\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-39.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-40\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-40.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-41\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-41.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-42\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-42.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-43\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-43.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-44\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-44.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-45\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-45.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-46\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-46.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-47\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-47.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-48\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-48.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-49\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-49.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-50\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-50.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-51\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-51.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-52\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-52.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-53\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-53.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-54\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-54.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-55\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-55.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-56\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-56.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-57\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-57.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-58\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-58.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-59\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-59.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_aoyi-139-pages-v3-60\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_aoyi-139-pages-v3-60.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_ji_aoyi-245-pages-v3-0\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-245-pages-v3-0.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_ji_aoyi-245-pages-v3-1\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-245-pages-v3-1.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_ji_aoyi-245-pages-v3-2\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-245-pages-v3-2.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_ji_aoyi-245-pages-v3-3\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-245-pages-v3-3.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_ji_aoyi-245-pages-v3-4\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-245-pages-v3-4.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_ji_aoyi-245-pages-v3-5\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-245-pages-v3-5.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_ji_aoyi-245-pages-v3-6\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-245-pages-v3-6.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_ji_aoyi-245-pages-v3-7\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-245-pages-v3-7.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_ji_aoyi-245-pages-v3-8\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-245-pages-v3-8.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_ji_aoyi-245-pages-v3-9\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-245-pages-v3-9.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_ji_aoyi-245-pages-v3-10\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-245-pages-v3-10.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_ji_aoyi-245-pages-v3-11\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-245-pages-v3-11.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_ji_aoyi-245-pages-v3-12\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-245-pages-v3-12.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_ji_aoyi-245-pages-v3-13\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-245-pages-v3-13.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_ji_aoyi-245-pages-v3-14\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-245-pages-v3-14.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_ji_aoyi-245-pages-v3-15\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-245-pages-v3-15.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_ji_aoyi-245-pages-v3-16\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-245-pages-v3-16.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_ji_aoyi-245-pages-v3-17\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-245-pages-v3-17.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_ji_aoyi-245-pages-v3-18\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-245-pages-v3-18.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_ji_aoyi-245-pages-v3-19\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-245-pages-v3-19.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_ji_aoyi-245-pages-v3-20\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-245-pages-v3-20.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_ji_aoyi-245-pages-v3-21\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-245-pages-v3-21.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_ji_aoyi-245-pages-v3-22\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-245-pages-v3-22.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_ji_aoyi-245-pages-v3-23\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-245-pages-v3-23.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_ji_aoyi-245-pages-v3-24\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-245-pages-v3-24.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_ji_aoyi-245-pages-v3-25\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-245-pages-v3-25.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_ji_aoyi-245-pages-v3-26\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-245-pages-v3-26.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_ji_aoyi-245-pages-v3-27\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-245-pages-v3-27.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_ji_aoyi-245-pages-v3-28\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-245-pages-v3-28.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_ji_aoyi-245-pages-v3-29\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-245-pages-v3-29.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_ji_aoyi-245-pages-v3-30\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-245-pages-v3-30.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_ji_aoyi-245-pages-v3-31\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-245-pages-v3-31.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Jijiamingren_ji_aoyi-440-pages-v3-0\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-440-pages-v3-0.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_ji_aoyi-440-pages-v3-1\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-440-pages-v3-1.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_ji_aoyi-440-pages-v3-2\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-440-pages-v3-2.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_ji_aoyi-440-pages-v3-3\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-440-pages-v3-3.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_ji_aoyi-440-pages-v3-4\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-440-pages-v3-4.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_ji_aoyi-440-pages-v3-5\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-440-pages-v3-5.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_ji_aoyi-440-pages-v3-6\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-440-pages-v3-6.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_ji_aoyi-440-pages-v3-7\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-440-pages-v3-7.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_ji_aoyi-440-pages-v3-8\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-440-pages-v3-8.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_ji_aoyi-440-pages-v3-9\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-440-pages-v3-9.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_ji_aoyi-440-pages-v3-10\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-440-pages-v3-10.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_ji_aoyi-440-pages-v3-11\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-440-pages-v3-11.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_ji_aoyi-440-pages-v3-12\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-440-pages-v3-12.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_ji_aoyi-440-pages-v3-13\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-440-pages-v3-13.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_ji_aoyi-440-pages-v3-14\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-440-pages-v3-14.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_ji_aoyi-440-pages-v3-15\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_ji_aoyi-440-pages-v3-15.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_liandan_pugong3-529-pages-v3-0\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_liandan_pugong3-529-pages-v3-0.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_liandan_pugong3-529-pages-v3-1\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_liandan_pugong3-529-pages-v3-1.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_liandan_pugong3-529-pages-v3-2\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_liandan_pugong3-529-pages-v3-2.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_liandan_pugong3-529-pages-v3-3\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_liandan_pugong3-529-pages-v3-3.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_liandan_pugong3-529-pages-v3-4\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_liandan_pugong3-529-pages-v3-4.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_liandan_pugong3-529-pages-v3-5\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_liandan_pugong3-529-pages-v3-5.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_liandan_pugong3-529-pages-v3-6\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_liandan_pugong3-529-pages-v3-6.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_liandan_pugong3-529-pages-v3-7\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_liandan_pugong3-529-pages-v3-7.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_liandan_pugong3-529-pages-v3-8\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_liandan_pugong3-529-pages-v3-8.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_liandan_pugong3-529-pages-v3-9\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_liandan_pugong3-529-pages-v3-9.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_liandan_pugong3-529-pages-v3-10\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_liandan_pugong3-529-pages-v3-10.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_liandan_pugong3-529-pages-v3-11\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_liandan_pugong3-529-pages-v3-11.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_liandan_pugong3-529-pages-v3-12\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_liandan_pugong3-529-pages-v3-12.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_liandan_pugong3-529-pages-v3-13\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_liandan_pugong3-529-pages-v3-13.png\",\"columns\":2,\"rows\":2,\"frameCount\":3},\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-0\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_luoxuanwan_zhuida-626-pages-v3-0.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-1\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_luoxuanwan_zhuida-626-pages-v3-1.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-2\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_luoxuanwan_zhuida-626-pages-v3-2.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-3\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_luoxuanwan_zhuida-626-pages-v3-3.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-4\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_luoxuanwan_zhuida-626-pages-v3-4.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-5\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_luoxuanwan_zhuida-626-pages-v3-5.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-6\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_luoxuanwan_zhuida-626-pages-v3-6.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-7\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_luoxuanwan_zhuida-626-pages-v3-7.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-8\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_luoxuanwan_zhuida-626-pages-v3-8.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-9\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_luoxuanwan_zhuida-626-pages-v3-9.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-10\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_luoxuanwan_zhuida-626-pages-v3-10.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-11\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_luoxuanwan_zhuida-626-pages-v3-11.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-12\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_luoxuanwan_zhuida-626-pages-v3-12.png\",\"columns\":2,\"rows\":1,\"frameCount\":2},\"Jijiamingren_qianghua_pugong-250-pages-v3-0\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_qianghua_pugong-250-pages-v3-0.png\",\"columns\":2,\"rows\":5,\"frameCount\":10},\"Jijiamingren_qianghua_pugong-250-pages-v3-1\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_qianghua_pugong-250-pages-v3-1.png\",\"columns\":2,\"rows\":5,\"frameCount\":10},\"Jijiamingren_qianghua_pugong-250-pages-v3-2\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_qianghua_pugong-250-pages-v3-2.png\",\"columns\":2,\"rows\":5,\"frameCount\":10},\"Jijiamingren_qianghua_pugong-250-pages-v3-3\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_qianghua_pugong-250-pages-v3-3.png\",\"columns\":2,\"rows\":4,\"frameCount\":8},\"Jijiamingren_shanbi-154-pages-v3-0\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_shanbi-154-pages-v3-0.png\",\"columns\":5,\"rows\":6,\"frameCount\":28},\"Jijiamingren_shanbi-90-pages-v3-0\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_shanbi-90-pages-v3-0.png\",\"columns\":5,\"rows\":7,\"frameCount\":35},\"Jijiamingren_shanbi-90-pages-v3-1\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_shanbi-90-pages-v3-1.png\",\"columns\":5,\"rows\":1,\"frameCount\":1},\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-0\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_weisouyu-609-pages-v3-0.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-1\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_weisouyu-609-pages-v3-1.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-2\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_weisouyu-609-pages-v3-2.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-3\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_weisouyu-609-pages-v3-3.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-4\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_weisouyu-609-pages-v3-4.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-5\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_weisouyu-609-pages-v3-5.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-6\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_weisouyu-609-pages-v3-6.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-7\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_weisouyu-609-pages-v3-7.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-8\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_weisouyu-609-pages-v3-8.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-9\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_weisouyu-609-pages-v3-9.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-10\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_weisouyu-609-pages-v3-10.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-11\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_weisouyu-609-pages-v3-11.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-12\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_weisouyu-609-pages-v3-12.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-13\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_weisouyu-609-pages-v3-13.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-14\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_weisouyu-609-pages-v3-14.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-15\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_weisouyu-609-pages-v3-15.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-0\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_weisouyu-67-pages-v3-0.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-1\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_weisouyu-67-pages-v3-1.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-2\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_weisouyu-67-pages-v3-2.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-3\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_weisouyu-67-pages-v3-3.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-4\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_weisouyu-67-pages-v3-4.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-5\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_weisouyu-67-pages-v3-5.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-6\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_weisouyu-67-pages-v3-6.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-7\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_weisouyu-67-pages-v3-7.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-8\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_weisouyu-67-pages-v3-8.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-9\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_weisouyu-67-pages-v3-9.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0.png\",\"columns\":5,\"rows\":4,\"frameCount\":17},\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-0\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_zhuaji-379-pages-v3-0.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-1\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_zhuaji-379-pages-v3-1.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-2\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_zhuaji-379-pages-v3-2.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-3\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_zhuaji-379-pages-v3-3.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-4\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_zhuaji-379-pages-v3-4.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-5\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_zhuaji-379-pages-v3-5.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-6\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_zhuaji-379-pages-v3-6.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-7\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_zhuaji-379-pages-v3-7.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-8\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_zhuaji-379-pages-v3-8.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-9\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_zhuaji-379-pages-v3-9.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-10\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_zhuaji-379-pages-v3-10.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-11\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_zhuaji-379-pages-v3-11.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-12\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_zhuaji-379-pages-v3-12.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-13\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_zhuaji-379-pages-v3-13.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-14\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_zhuaji-379-pages-v3-14.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-15\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_zhuaji-379-pages-v3-15.png\",\"columns\":2,\"rows\":1,\"frameCount\":1},\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_hengsao-256-pages-v3-0.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-1\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_hengsao-256-pages-v3-1.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-2\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_hengsao-256-pages-v3-2.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-3\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_hengsao-256-pages-v3-3.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-4\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_hengsao-256-pages-v3-4.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-5\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_hengsao-256-pages-v3-5.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-6\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_hengsao-256-pages-v3-6.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-7\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_hengsao-256-pages-v3-7.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-8\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_hengsao-256-pages-v3-8.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-9\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_hengsao-256-pages-v3-9.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-10\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_hengsao-256-pages-v3-10.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-11\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_hengsao-256-pages-v3-11.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-12\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_hengsao-256-pages-v3-12.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-13\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_hengsao-256-pages-v3-13.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-14\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_hengsao-256-pages-v3-14.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-15\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_hengsao-256-pages-v3-15.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\":{\"url\":\"/public/mecha-vfx/extracted/Jijiamingren_jiuweilama_hengsao-58-pages-v3-0.png\",\"columns\":5,\"rows\":7,\"frameCount\":35}},\"clips\":{\"Jijiamingren_aoyi-1343\":{\"atlas\":\"Jijiamingren_aoyi-1343-pages-v3-0\",\"frameAtlases\":[\"Jijiamingren_aoyi-1343-pages-v3-0\",\"Jijiamingren_aoyi-1343-pages-v3-0\",\"Jijiamingren_aoyi-1343-pages-v3-1\",\"Jijiamingren_aoyi-1343-pages-v3-1\",\"Jijiamingren_aoyi-1343-pages-v3-2\",\"Jijiamingren_aoyi-1343-pages-v3-2\",\"Jijiamingren_aoyi-1343-pages-v3-3\",\"Jijiamingren_aoyi-1343-pages-v3-3\",\"Jijiamingren_aoyi-1343-pages-v3-4\",\"Jijiamingren_aoyi-1343-pages-v3-4\",\"Jijiamingren_aoyi-1343-pages-v3-5\",\"Jijiamingren_aoyi-1343-pages-v3-5\",\"Jijiamingren_aoyi-1343-pages-v3-6\",\"Jijiamingren_aoyi-1343-pages-v3-6\",\"Jijiamingren_aoyi-1343-pages-v3-6\",\"Jijiamingren_aoyi-1343-pages-v3-7\",\"Jijiamingren_aoyi-1343-pages-v3-7\",\"Jijiamingren_aoyi-1343-pages-v3-8\",\"Jijiamingren_aoyi-1343-pages-v3-8\",\"Jijiamingren_aoyi-1343-pages-v3-9\",\"Jijiamingren_aoyi-1343-pages-v3-9\",\"Jijiamingren_aoyi-1343-pages-v3-10\",\"Jijiamingren_aoyi-1343-pages-v3-10\",\"Jijiamingren_aoyi-1343-pages-v3-11\",\"Jijiamingren_aoyi-1343-pages-v3-11\",\"Jijiamingren_aoyi-1343-pages-v3-12\",\"Jijiamingren_aoyi-1343-pages-v3-12\",\"Jijiamingren_aoyi-1343-pages-v3-13\",\"Jijiamingren_aoyi-1343-pages-v3-13\",\"Jijiamingren_aoyi-1343-pages-v3-14\",\"Jijiamingren_aoyi-1343-pages-v3-14\",\"Jijiamingren_aoyi-1343-pages-v3-15\",\"Jijiamingren_aoyi-1343-pages-v3-15\",\"Jijiamingren_aoyi-1343-pages-v3-16\",\"Jijiamingren_aoyi-1343-pages-v3-16\",\"Jijiamingren_aoyi-1343-pages-v3-17\",\"Jijiamingren_aoyi-1343-pages-v3-17\",\"Jijiamingren_aoyi-1343-pages-v3-18\",\"Jijiamingren_aoyi-1343-pages-v3-18\",\"Jijiamingren_aoyi-1343-pages-v3-18\",\"Jijiamingren_aoyi-1343-pages-v3-19\",\"Jijiamingren_aoyi-1343-pages-v3-19\",\"Jijiamingren_aoyi-1343-pages-v3-20\",\"Jijiamingren_aoyi-1343-pages-v3-20\",\"Jijiamingren_aoyi-1343-pages-v3-21\",\"Jijiamingren_aoyi-1343-pages-v3-21\",\"Jijiamingren_aoyi-1343-pages-v3-22\",\"Jijiamingren_aoyi-1343-pages-v3-22\",\"Jijiamingren_aoyi-1343-pages-v3-23\",\"Jijiamingren_aoyi-1343-pages-v3-23\",\"Jijiamingren_aoyi-1343-pages-v3-24\",\"Jijiamingren_aoyi-1343-pages-v3-24\",\"Jijiamingren_aoyi-1343-pages-v3-25\",\"Jijiamingren_aoyi-1343-pages-v3-25\",\"Jijiamingren_aoyi-1343-pages-v3-26\",\"Jijiamingren_aoyi-1343-pages-v3-26\",\"Jijiamingren_aoyi-1343-pages-v3-27\",\"Jijiamingren_aoyi-1343-pages-v3-27\",\"Jijiamingren_aoyi-1343-pages-v3-28\",\"Jijiamingren_aoyi-1343-pages-v3-28\",\"Jijiamingren_aoyi-1343-pages-v3-29\",\"Jijiamingren_aoyi-1343-pages-v3-29\",\"Jijiamingren_aoyi-1343-pages-v3-30\",\"Jijiamingren_aoyi-1343-pages-v3-30\",\"Jijiamingren_aoyi-1343-pages-v3-30\",\"Jijiamingren_aoyi-1343-pages-v3-31\",\"Jijiamingren_aoyi-1343-pages-v3-31\",\"Jijiamingren_aoyi-1343-pages-v3-32\",\"Jijiamingren_aoyi-1343-pages-v3-32\",\"Jijiamingren_aoyi-1343-pages-v3-33\",\"Jijiamingren_aoyi-1343-pages-v3-33\",\"Jijiamingren_aoyi-1343-pages-v3-34\",\"Jijiamingren_aoyi-1343-pages-v3-34\",\"Jijiamingren_aoyi-1343-pages-v3-35\",\"Jijiamingren_aoyi-1343-pages-v3-35\",\"Jijiamingren_aoyi-1343-pages-v3-36\",\"Jijiamingren_aoyi-1343-pages-v3-36\",\"Jijiamingren_aoyi-1343-pages-v3-37\",\"Jijiamingren_aoyi-1343-pages-v3-37\",\"Jijiamingren_aoyi-1343-pages-v3-38\",\"Jijiamingren_aoyi-1343-pages-v3-38\",\"Jijiamingren_aoyi-1343-pages-v3-39\",\"Jijiamingren_aoyi-1343-pages-v3-39\",\"Jijiamingren_aoyi-1343-pages-v3-40\",\"Jijiamingren_aoyi-1343-pages-v3-40\",\"Jijiamingren_aoyi-1343-pages-v3-41\",\"Jijiamingren_aoyi-1343-pages-v3-41\",\"Jijiamingren_aoyi-1343-pages-v3-42\",\"Jijiamingren_aoyi-1343-pages-v3-42\",\"Jijiamingren_aoyi-1343-pages-v3-42\",\"Jijiamingren_aoyi-1343-pages-v3-43\",\"Jijiamingren_aoyi-1343-pages-v3-43\",\"Jijiamingren_aoyi-1343-pages-v3-44\",\"Jijiamingren_aoyi-1343-pages-v3-44\",\"Jijiamingren_aoyi-1343-pages-v3-45\",\"Jijiamingren_aoyi-1343-pages-v3-45\",\"Jijiamingren_aoyi-1343-pages-v3-46\",\"Jijiamingren_aoyi-1343-pages-v3-46\",\"Jijiamingren_aoyi-1343-pages-v3-47\",\"Jijiamingren_aoyi-1343-pages-v3-47\",\"Jijiamingren_aoyi-1343-pages-v3-48\",\"Jijiamingren_aoyi-1343-pages-v3-48\",\"Jijiamingren_aoyi-1343-pages-v3-49\",\"Jijiamingren_aoyi-1343-pages-v3-49\",\"Jijiamingren_aoyi-1343-pages-v3-50\",\"Jijiamingren_aoyi-1343-pages-v3-50\",\"Jijiamingren_aoyi-1343-pages-v3-51\",\"Jijiamingren_aoyi-1343-pages-v3-51\",\"Jijiamingren_aoyi-1343-pages-v3-52\",\"Jijiamingren_aoyi-1343-pages-v3-52\",\"Jijiamingren_aoyi-1343-pages-v3-53\",\"Jijiamingren_aoyi-1343-pages-v3-53\",\"Jijiamingren_aoyi-1343-pages-v3-54\",\"Jijiamingren_aoyi-1343-pages-v3-54\",\"Jijiamingren_aoyi-1343-pages-v3-54\",\"Jijiamingren_aoyi-1343-pages-v3-55\",\"Jijiamingren_aoyi-1343-pages-v3-55\",\"Jijiamingren_aoyi-1343-pages-v3-56\",\"Jijiamingren_aoyi-1343-pages-v3-56\",\"Jijiamingren_aoyi-1343-pages-v3-57\",\"Jijiamingren_aoyi-1343-pages-v3-57\",\"Jijiamingren_aoyi-1343-pages-v3-58\",\"Jijiamingren_aoyi-1343-pages-v3-58\",\"Jijiamingren_aoyi-1343-pages-v3-59\",\"Jijiamingren_aoyi-1343-pages-v3-59\",\"Jijiamingren_aoyi-1343-pages-v3-60\",\"Jijiamingren_aoyi-1343-pages-v3-60\",\"Jijiamingren_aoyi-1343-pages-v3-61\",\"Jijiamingren_aoyi-1343-pages-v3-61\",\"Jijiamingren_aoyi-1343-pages-v3-62\",\"Jijiamingren_aoyi-1343-pages-v3-62\",\"Jijiamingren_aoyi-1343-pages-v3-63\",\"Jijiamingren_aoyi-1343-pages-v3-63\",\"Jijiamingren_aoyi-1343-pages-v3-64\",\"Jijiamingren_aoyi-1343-pages-v3-64\",\"Jijiamingren_aoyi-1343-pages-v3-65\",\"Jijiamingren_aoyi-1343-pages-v3-65\",\"Jijiamingren_aoyi-1343-pages-v3-66\",\"Jijiamingren_aoyi-1343-pages-v3-66\",\"Jijiamingren_aoyi-1343-pages-v3-66\",\"Jijiamingren_aoyi-1343-pages-v3-67\",\"Jijiamingren_aoyi-1343-pages-v3-67\",\"Jijiamingren_aoyi-1343-pages-v3-68\",\"Jijiamingren_aoyi-1343-pages-v3-68\",\"Jijiamingren_aoyi-1343-pages-v3-69\",\"Jijiamingren_aoyi-1343-pages-v3-69\",\"Jijiamingren_aoyi-1343-pages-v3-70\",\"Jijiamingren_aoyi-1343-pages-v3-70\",\"Jijiamingren_aoyi-1343-pages-v3-71\",\"Jijiamingren_aoyi-1343-pages-v3-71\",\"Jijiamingren_aoyi-1343-pages-v3-72\",\"Jijiamingren_aoyi-1343-pages-v3-72\",\"Jijiamingren_aoyi-1343-pages-v3-73\",\"Jijiamingren_aoyi-1343-pages-v3-73\",\"Jijiamingren_aoyi-1343-pages-v3-74\",\"Jijiamingren_aoyi-1343-pages-v3-74\",\"Jijiamingren_aoyi-1343-pages-v3-75\",\"Jijiamingren_aoyi-1343-pages-v3-75\",\"Jijiamingren_aoyi-1343-pages-v3-0\",\"Jijiamingren_aoyi-1343-pages-v3-0\"],\"timeline\":[0,1,0,1,0,1,0,1,0,1,0,1,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0],\"width\":1280,\"height\":853,\"pivot\":[0.49989542483660127,0.5001617647058824],\"renderScale\":0.7111111111111111,\"sourceFrames\":153,\"sourceCrop\":[1182,1755,2712,2775],\"sourceZoom\":0.85,\"contactCamera\":true,\"softEdges\":true},\"Jijiamingren_aoyi-139\":{\"atlas\":\"Jijiamingren_aoyi-139-pages-v3-0\",\"frameAtlases\":[\"Jijiamingren_aoyi-139-pages-v3-0\",\"Jijiamingren_aoyi-139-pages-v3-0\",\"Jijiamingren_aoyi-139-pages-v3-0\",\"Jijiamingren_aoyi-139-pages-v3-0\",\"Jijiamingren_aoyi-139-pages-v3-0\",\"Jijiamingren_aoyi-139-pages-v3-0\",\"Jijiamingren_aoyi-139-pages-v3-0\",\"Jijiamingren_aoyi-139-pages-v3-0\",\"Jijiamingren_aoyi-139-pages-v3-1\",\"Jijiamingren_aoyi-139-pages-v3-1\",\"Jijiamingren_aoyi-139-pages-v3-2\",\"Jijiamingren_aoyi-139-pages-v3-2\",\"Jijiamingren_aoyi-139-pages-v3-3\",\"Jijiamingren_aoyi-139-pages-v3-3\",\"Jijiamingren_aoyi-139-pages-v3-3\",\"Jijiamingren_aoyi-139-pages-v3-4\",\"Jijiamingren_aoyi-139-pages-v3-4\",\"Jijiamingren_aoyi-139-pages-v3-5\",\"Jijiamingren_aoyi-139-pages-v3-5\",\"Jijiamingren_aoyi-139-pages-v3-6\",\"Jijiamingren_aoyi-139-pages-v3-6\",\"Jijiamingren_aoyi-139-pages-v3-7\",\"Jijiamingren_aoyi-139-pages-v3-7\",\"Jijiamingren_aoyi-139-pages-v3-8\",\"Jijiamingren_aoyi-139-pages-v3-8\",\"Jijiamingren_aoyi-139-pages-v3-9\",\"Jijiamingren_aoyi-139-pages-v3-9\",\"Jijiamingren_aoyi-139-pages-v3-10\",\"Jijiamingren_aoyi-139-pages-v3-10\",\"Jijiamingren_aoyi-139-pages-v3-11\",\"Jijiamingren_aoyi-139-pages-v3-11\",\"Jijiamingren_aoyi-139-pages-v3-0\",\"Jijiamingren_aoyi-139-pages-v3-0\",\"Jijiamingren_aoyi-139-pages-v3-0\",\"Jijiamingren_aoyi-139-pages-v3-0\",\"Jijiamingren_aoyi-139-pages-v3-0\",\"Jijiamingren_aoyi-139-pages-v3-0\",\"Jijiamingren_aoyi-139-pages-v3-0\",\"Jijiamingren_aoyi-139-pages-v3-0\",\"Jijiamingren_aoyi-139-pages-v3-0\",\"Jijiamingren_aoyi-139-pages-v3-0\",\"Jijiamingren_aoyi-139-pages-v3-0\",\"Jijiamingren_aoyi-139-pages-v3-0\",\"Jijiamingren_aoyi-139-pages-v3-0\",\"Jijiamingren_aoyi-139-pages-v3-0\",\"Jijiamingren_aoyi-139-pages-v3-0\",\"Jijiamingren_aoyi-139-pages-v3-0\",\"Jijiamingren_aoyi-139-pages-v3-0\",\"Jijiamingren_aoyi-139-pages-v3-0\",\"Jijiamingren_aoyi-139-pages-v3-0\",\"Jijiamingren_aoyi-139-pages-v3-0\",\"Jijiamingren_aoyi-139-pages-v3-0\",\"Jijiamingren_aoyi-139-pages-v3-0\",\"Jijiamingren_aoyi-139-pages-v3-12\",\"Jijiamingren_aoyi-139-pages-v3-12\",\"Jijiamingren_aoyi-139-pages-v3-13\",\"Jijiamingren_aoyi-139-pages-v3-13\",\"Jijiamingren_aoyi-139-pages-v3-14\",\"Jijiamingren_aoyi-139-pages-v3-14\",\"Jijiamingren_aoyi-139-pages-v3-15\",\"Jijiamingren_aoyi-139-pages-v3-15\",\"Jijiamingren_aoyi-139-pages-v3-16\",\"Jijiamingren_aoyi-139-pages-v3-16\",\"Jijiamingren_aoyi-139-pages-v3-16\",\"Jijiamingren_aoyi-139-pages-v3-17\",\"Jijiamingren_aoyi-139-pages-v3-17\",\"Jijiamingren_aoyi-139-pages-v3-18\",\"Jijiamingren_aoyi-139-pages-v3-18\",\"Jijiamingren_aoyi-139-pages-v3-19\",\"Jijiamingren_aoyi-139-pages-v3-19\",\"Jijiamingren_aoyi-139-pages-v3-20\",\"Jijiamingren_aoyi-139-pages-v3-20\",\"Jijiamingren_aoyi-139-pages-v3-21\",\"Jijiamingren_aoyi-139-pages-v3-21\",\"Jijiamingren_aoyi-139-pages-v3-22\",\"Jijiamingren_aoyi-139-pages-v3-22\",\"Jijiamingren_aoyi-139-pages-v3-23\",\"Jijiamingren_aoyi-139-pages-v3-23\",\"Jijiamingren_aoyi-139-pages-v3-24\",\"Jijiamingren_aoyi-139-pages-v3-24\",\"Jijiamingren_aoyi-139-pages-v3-25\",\"Jijiamingren_aoyi-139-pages-v3-25\",\"Jijiamingren_aoyi-139-pages-v3-26\",\"Jijiamingren_aoyi-139-pages-v3-26\",\"Jijiamingren_aoyi-139-pages-v3-27\",\"Jijiamingren_aoyi-139-pages-v3-27\",\"Jijiamingren_aoyi-139-pages-v3-28\",\"Jijiamingren_aoyi-139-pages-v3-28\",\"Jijiamingren_aoyi-139-pages-v3-28\",\"Jijiamingren_aoyi-139-pages-v3-29\",\"Jijiamingren_aoyi-139-pages-v3-29\",\"Jijiamingren_aoyi-139-pages-v3-30\",\"Jijiamingren_aoyi-139-pages-v3-30\",\"Jijiamingren_aoyi-139-pages-v3-31\",\"Jijiamingren_aoyi-139-pages-v3-31\",\"Jijiamingren_aoyi-139-pages-v3-32\",\"Jijiamingren_aoyi-139-pages-v3-32\",\"Jijiamingren_aoyi-139-pages-v3-33\",\"Jijiamingren_aoyi-139-pages-v3-33\",\"Jijiamingren_aoyi-139-pages-v3-34\",\"Jijiamingren_aoyi-139-pages-v3-34\",\"Jijiamingren_aoyi-139-pages-v3-35\",\"Jijiamingren_aoyi-139-pages-v3-35\",\"Jijiamingren_aoyi-139-pages-v3-36\",\"Jijiamingren_aoyi-139-pages-v3-36\",\"Jijiamingren_aoyi-139-pages-v3-37\",\"Jijiamingren_aoyi-139-pages-v3-37\",\"Jijiamingren_aoyi-139-pages-v3-38\",\"Jijiamingren_aoyi-139-pages-v3-38\",\"Jijiamingren_aoyi-139-pages-v3-39\",\"Jijiamingren_aoyi-139-pages-v3-39\",\"Jijiamingren_aoyi-139-pages-v3-40\",\"Jijiamingren_aoyi-139-pages-v3-40\",\"Jijiamingren_aoyi-139-pages-v3-40\",\"Jijiamingren_aoyi-139-pages-v3-41\",\"Jijiamingren_aoyi-139-pages-v3-41\",\"Jijiamingren_aoyi-139-pages-v3-42\",\"Jijiamingren_aoyi-139-pages-v3-42\",\"Jijiamingren_aoyi-139-pages-v3-43\",\"Jijiamingren_aoyi-139-pages-v3-43\",\"Jijiamingren_aoyi-139-pages-v3-44\",\"Jijiamingren_aoyi-139-pages-v3-44\",\"Jijiamingren_aoyi-139-pages-v3-45\",\"Jijiamingren_aoyi-139-pages-v3-45\",\"Jijiamingren_aoyi-139-pages-v3-46\",\"Jijiamingren_aoyi-139-pages-v3-46\",\"Jijiamingren_aoyi-139-pages-v3-47\",\"Jijiamingren_aoyi-139-pages-v3-47\",\"Jijiamingren_aoyi-139-pages-v3-48\",\"Jijiamingren_aoyi-139-pages-v3-48\",\"Jijiamingren_aoyi-139-pages-v3-49\",\"Jijiamingren_aoyi-139-pages-v3-49\",\"Jijiamingren_aoyi-139-pages-v3-50\",\"Jijiamingren_aoyi-139-pages-v3-50\",\"Jijiamingren_aoyi-139-pages-v3-51\",\"Jijiamingren_aoyi-139-pages-v3-51\",\"Jijiamingren_aoyi-139-pages-v3-52\",\"Jijiamingren_aoyi-139-pages-v3-52\",\"Jijiamingren_aoyi-139-pages-v3-52\",\"Jijiamingren_aoyi-139-pages-v3-53\",\"Jijiamingren_aoyi-139-pages-v3-53\",\"Jijiamingren_aoyi-139-pages-v3-54\",\"Jijiamingren_aoyi-139-pages-v3-54\",\"Jijiamingren_aoyi-139-pages-v3-55\",\"Jijiamingren_aoyi-139-pages-v3-55\",\"Jijiamingren_aoyi-139-pages-v3-56\",\"Jijiamingren_aoyi-139-pages-v3-56\",\"Jijiamingren_aoyi-139-pages-v3-57\",\"Jijiamingren_aoyi-139-pages-v3-57\",\"Jijiamingren_aoyi-139-pages-v3-58\",\"Jijiamingren_aoyi-139-pages-v3-58\",\"Jijiamingren_aoyi-139-pages-v3-59\",\"Jijiamingren_aoyi-139-pages-v3-59\",\"Jijiamingren_aoyi-139-pages-v3-60\",\"Jijiamingren_aoyi-139-pages-v3-60\",\"Jijiamingren_aoyi-139-pages-v3-0\",\"Jijiamingren_aoyi-139-pages-v3-0\",\"Jijiamingren_aoyi-139-pages-v3-0\",\"Jijiamingren_aoyi-139-pages-v3-0\",\"Jijiamingren_aoyi-139-pages-v3-0\"],\"timeline\":[0,0,0,0,0,0,0,1,0,1,0,1,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0,0,0],\"width\":1280,\"height\":853,\"pivot\":[0.5002483660130718,0.5004338235294118],\"renderScale\":0.7111111111111111,\"sourceFrames\":153,\"sourceCrop\":[240,122,1770,1142],\"sourceZoom\":0.85,\"contactCamera\":true,\"additive\":true,\"softEdges\":true},\"Jijiamingren_ji_aoyi-245\":{\"atlas\":\"Jijiamingren_ji_aoyi-245-pages-v3-0\",\"frameAtlases\":[\"Jijiamingren_ji_aoyi-245-pages-v3-0\",\"Jijiamingren_ji_aoyi-245-pages-v3-0\",\"Jijiamingren_ji_aoyi-245-pages-v3-0\",\"Jijiamingren_ji_aoyi-245-pages-v3-0\",\"Jijiamingren_ji_aoyi-245-pages-v3-0\",\"Jijiamingren_ji_aoyi-245-pages-v3-0\",\"Jijiamingren_ji_aoyi-245-pages-v3-0\",\"Jijiamingren_ji_aoyi-245-pages-v3-1\",\"Jijiamingren_ji_aoyi-245-pages-v3-1\",\"Jijiamingren_ji_aoyi-245-pages-v3-2\",\"Jijiamingren_ji_aoyi-245-pages-v3-2\",\"Jijiamingren_ji_aoyi-245-pages-v3-3\",\"Jijiamingren_ji_aoyi-245-pages-v3-3\",\"Jijiamingren_ji_aoyi-245-pages-v3-3\",\"Jijiamingren_ji_aoyi-245-pages-v3-4\",\"Jijiamingren_ji_aoyi-245-pages-v3-4\",\"Jijiamingren_ji_aoyi-245-pages-v3-5\",\"Jijiamingren_ji_aoyi-245-pages-v3-5\",\"Jijiamingren_ji_aoyi-245-pages-v3-6\",\"Jijiamingren_ji_aoyi-245-pages-v3-6\",\"Jijiamingren_ji_aoyi-245-pages-v3-7\",\"Jijiamingren_ji_aoyi-245-pages-v3-7\",\"Jijiamingren_ji_aoyi-245-pages-v3-8\",\"Jijiamingren_ji_aoyi-245-pages-v3-8\",\"Jijiamingren_ji_aoyi-245-pages-v3-9\",\"Jijiamingren_ji_aoyi-245-pages-v3-9\",\"Jijiamingren_ji_aoyi-245-pages-v3-10\",\"Jijiamingren_ji_aoyi-245-pages-v3-10\",\"Jijiamingren_ji_aoyi-245-pages-v3-11\",\"Jijiamingren_ji_aoyi-245-pages-v3-11\",\"Jijiamingren_ji_aoyi-245-pages-v3-12\",\"Jijiamingren_ji_aoyi-245-pages-v3-12\",\"Jijiamingren_ji_aoyi-245-pages-v3-13\",\"Jijiamingren_ji_aoyi-245-pages-v3-13\",\"Jijiamingren_ji_aoyi-245-pages-v3-14\",\"Jijiamingren_ji_aoyi-245-pages-v3-14\",\"Jijiamingren_ji_aoyi-245-pages-v3-15\",\"Jijiamingren_ji_aoyi-245-pages-v3-15\",\"Jijiamingren_ji_aoyi-245-pages-v3-15\",\"Jijiamingren_ji_aoyi-245-pages-v3-16\",\"Jijiamingren_ji_aoyi-245-pages-v3-16\",\"Jijiamingren_ji_aoyi-245-pages-v3-17\",\"Jijiamingren_ji_aoyi-245-pages-v3-17\",\"Jijiamingren_ji_aoyi-245-pages-v3-18\",\"Jijiamingren_ji_aoyi-245-pages-v3-18\",\"Jijiamingren_ji_aoyi-245-pages-v3-19\",\"Jijiamingren_ji_aoyi-245-pages-v3-19\",\"Jijiamingren_ji_aoyi-245-pages-v3-20\",\"Jijiamingren_ji_aoyi-245-pages-v3-20\",\"Jijiamingren_ji_aoyi-245-pages-v3-21\",\"Jijiamingren_ji_aoyi-245-pages-v3-21\",\"Jijiamingren_ji_aoyi-245-pages-v3-22\",\"Jijiamingren_ji_aoyi-245-pages-v3-22\",\"Jijiamingren_ji_aoyi-245-pages-v3-23\",\"Jijiamingren_ji_aoyi-245-pages-v3-23\",\"Jijiamingren_ji_aoyi-245-pages-v3-24\",\"Jijiamingren_ji_aoyi-245-pages-v3-24\",\"Jijiamingren_ji_aoyi-245-pages-v3-25\",\"Jijiamingren_ji_aoyi-245-pages-v3-25\",\"Jijiamingren_ji_aoyi-245-pages-v3-26\",\"Jijiamingren_ji_aoyi-245-pages-v3-26\",\"Jijiamingren_ji_aoyi-245-pages-v3-27\",\"Jijiamingren_ji_aoyi-245-pages-v3-27\",\"Jijiamingren_ji_aoyi-245-pages-v3-27\",\"Jijiamingren_ji_aoyi-245-pages-v3-28\",\"Jijiamingren_ji_aoyi-245-pages-v3-28\",\"Jijiamingren_ji_aoyi-245-pages-v3-29\",\"Jijiamingren_ji_aoyi-245-pages-v3-29\",\"Jijiamingren_ji_aoyi-245-pages-v3-30\",\"Jijiamingren_ji_aoyi-245-pages-v3-30\",\"Jijiamingren_ji_aoyi-245-pages-v3-31\",\"Jijiamingren_ji_aoyi-245-pages-v3-31\",\"Jijiamingren_ji_aoyi-245-pages-v3-0\"],\"timeline\":[0,0,0,0,0,0,1,0,1,0,1,0,1,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,1,0,1,0,1,0,1,0,1,0],\"width\":1248,\"height\":900,\"pivot\":[0.45411149825783975,0.7395933977455716],\"renderScale\":0.61602787456446,\"sourceFrames\":70,\"sourceCrop\":[917,33,2639,1275],\"sourceZoom\":0.85},\"Jijiamingren_ji_aoyi-440\":{\"atlas\":\"Jijiamingren_ji_aoyi-440-pages-v3-0\",\"frameAtlases\":[\"Jijiamingren_ji_aoyi-440-pages-v3-0\",\"Jijiamingren_ji_aoyi-440-pages-v3-0\",\"Jijiamingren_ji_aoyi-440-pages-v3-0\",\"Jijiamingren_ji_aoyi-440-pages-v3-0\",\"Jijiamingren_ji_aoyi-440-pages-v3-0\",\"Jijiamingren_ji_aoyi-440-pages-v3-0\",\"Jijiamingren_ji_aoyi-440-pages-v3-0\",\"Jijiamingren_ji_aoyi-440-pages-v3-0\",\"Jijiamingren_ji_aoyi-440-pages-v3-0\",\"Jijiamingren_ji_aoyi-440-pages-v3-1\",\"Jijiamingren_ji_aoyi-440-pages-v3-1\",\"Jijiamingren_ji_aoyi-440-pages-v3-1\",\"Jijiamingren_ji_aoyi-440-pages-v3-1\",\"Jijiamingren_ji_aoyi-440-pages-v3-1\",\"Jijiamingren_ji_aoyi-440-pages-v3-2\",\"Jijiamingren_ji_aoyi-440-pages-v3-2\",\"Jijiamingren_ji_aoyi-440-pages-v3-2\",\"Jijiamingren_ji_aoyi-440-pages-v3-2\",\"Jijiamingren_ji_aoyi-440-pages-v3-3\",\"Jijiamingren_ji_aoyi-440-pages-v3-3\",\"Jijiamingren_ji_aoyi-440-pages-v3-3\",\"Jijiamingren_ji_aoyi-440-pages-v3-3\",\"Jijiamingren_ji_aoyi-440-pages-v3-4\",\"Jijiamingren_ji_aoyi-440-pages-v3-4\",\"Jijiamingren_ji_aoyi-440-pages-v3-4\",\"Jijiamingren_ji_aoyi-440-pages-v3-4\",\"Jijiamingren_ji_aoyi-440-pages-v3-5\",\"Jijiamingren_ji_aoyi-440-pages-v3-5\",\"Jijiamingren_ji_aoyi-440-pages-v3-5\",\"Jijiamingren_ji_aoyi-440-pages-v3-5\",\"Jijiamingren_ji_aoyi-440-pages-v3-6\",\"Jijiamingren_ji_aoyi-440-pages-v3-6\",\"Jijiamingren_ji_aoyi-440-pages-v3-6\",\"Jijiamingren_ji_aoyi-440-pages-v3-6\",\"Jijiamingren_ji_aoyi-440-pages-v3-7\",\"Jijiamingren_ji_aoyi-440-pages-v3-7\",\"Jijiamingren_ji_aoyi-440-pages-v3-7\",\"Jijiamingren_ji_aoyi-440-pages-v3-7\",\"Jijiamingren_ji_aoyi-440-pages-v3-7\",\"Jijiamingren_ji_aoyi-440-pages-v3-8\",\"Jijiamingren_ji_aoyi-440-pages-v3-8\",\"Jijiamingren_ji_aoyi-440-pages-v3-8\",\"Jijiamingren_ji_aoyi-440-pages-v3-8\",\"Jijiamingren_ji_aoyi-440-pages-v3-9\",\"Jijiamingren_ji_aoyi-440-pages-v3-9\",\"Jijiamingren_ji_aoyi-440-pages-v3-9\",\"Jijiamingren_ji_aoyi-440-pages-v3-9\",\"Jijiamingren_ji_aoyi-440-pages-v3-10\",\"Jijiamingren_ji_aoyi-440-pages-v3-10\",\"Jijiamingren_ji_aoyi-440-pages-v3-10\",\"Jijiamingren_ji_aoyi-440-pages-v3-10\",\"Jijiamingren_ji_aoyi-440-pages-v3-11\",\"Jijiamingren_ji_aoyi-440-pages-v3-11\",\"Jijiamingren_ji_aoyi-440-pages-v3-11\",\"Jijiamingren_ji_aoyi-440-pages-v3-11\",\"Jijiamingren_ji_aoyi-440-pages-v3-12\",\"Jijiamingren_ji_aoyi-440-pages-v3-12\",\"Jijiamingren_ji_aoyi-440-pages-v3-12\",\"Jijiamingren_ji_aoyi-440-pages-v3-12\",\"Jijiamingren_ji_aoyi-440-pages-v3-13\",\"Jijiamingren_ji_aoyi-440-pages-v3-13\",\"Jijiamingren_ji_aoyi-440-pages-v3-13\",\"Jijiamingren_ji_aoyi-440-pages-v3-13\",\"Jijiamingren_ji_aoyi-440-pages-v3-13\",\"Jijiamingren_ji_aoyi-440-pages-v3-14\",\"Jijiamingren_ji_aoyi-440-pages-v3-14\",\"Jijiamingren_ji_aoyi-440-pages-v3-14\",\"Jijiamingren_ji_aoyi-440-pages-v3-14\",\"Jijiamingren_ji_aoyi-440-pages-v3-15\",\"Jijiamingren_ji_aoyi-440-pages-v3-15\",\"Jijiamingren_ji_aoyi-440-pages-v3-15\",\"Jijiamingren_ji_aoyi-440-pages-v3-15\",\"Jijiamingren_ji_aoyi-440-pages-v3-0\"],\"timeline\":[0,0,0,0,0,0,1,2,3,0,1,2,3,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,3,0,1,2,3,0,1,2,3,0],\"width\":720,\"height\":900,\"pivot\":[0.4887206572769953,0.6312674356223177],\"renderScale\":0.4104627766599598,\"sourceFrames\":70,\"sourceCrop\":[35,97,1526,1961],\"sourceZoom\":0.85},\"Jijiamingren_liandan_pugong3-529\":{\"atlas\":\"Jijiamingren_liandan_pugong3-529-pages-v3-0\",\"frameAtlases\":[\"Jijiamingren_liandan_pugong3-529-pages-v3-0\",\"Jijiamingren_liandan_pugong3-529-pages-v3-0\",\"Jijiamingren_liandan_pugong3-529-pages-v3-0\",\"Jijiamingren_liandan_pugong3-529-pages-v3-0\",\"Jijiamingren_liandan_pugong3-529-pages-v3-0\",\"Jijiamingren_liandan_pugong3-529-pages-v3-0\",\"Jijiamingren_liandan_pugong3-529-pages-v3-0\",\"Jijiamingren_liandan_pugong3-529-pages-v3-0\",\"Jijiamingren_liandan_pugong3-529-pages-v3-0\",\"Jijiamingren_liandan_pugong3-529-pages-v3-0\",\"Jijiamingren_liandan_pugong3-529-pages-v3-1\",\"Jijiamingren_liandan_pugong3-529-pages-v3-1\",\"Jijiamingren_liandan_pugong3-529-pages-v3-1\",\"Jijiamingren_liandan_pugong3-529-pages-v3-1\",\"Jijiamingren_liandan_pugong3-529-pages-v3-1\",\"Jijiamingren_liandan_pugong3-529-pages-v3-1\",\"Jijiamingren_liandan_pugong3-529-pages-v3-1\",\"Jijiamingren_liandan_pugong3-529-pages-v3-2\",\"Jijiamingren_liandan_pugong3-529-pages-v3-2\",\"Jijiamingren_liandan_pugong3-529-pages-v3-2\",\"Jijiamingren_liandan_pugong3-529-pages-v3-2\",\"Jijiamingren_liandan_pugong3-529-pages-v3-2\",\"Jijiamingren_liandan_pugong3-529-pages-v3-2\",\"Jijiamingren_liandan_pugong3-529-pages-v3-3\",\"Jijiamingren_liandan_pugong3-529-pages-v3-3\",\"Jijiamingren_liandan_pugong3-529-pages-v3-3\",\"Jijiamingren_liandan_pugong3-529-pages-v3-3\",\"Jijiamingren_liandan_pugong3-529-pages-v3-3\",\"Jijiamingren_liandan_pugong3-529-pages-v3-3\",\"Jijiamingren_liandan_pugong3-529-pages-v3-4\",\"Jijiamingren_liandan_pugong3-529-pages-v3-4\",\"Jijiamingren_liandan_pugong3-529-pages-v3-4\",\"Jijiamingren_liandan_pugong3-529-pages-v3-4\",\"Jijiamingren_liandan_pugong3-529-pages-v3-4\",\"Jijiamingren_liandan_pugong3-529-pages-v3-4\",\"Jijiamingren_liandan_pugong3-529-pages-v3-5\",\"Jijiamingren_liandan_pugong3-529-pages-v3-5\",\"Jijiamingren_liandan_pugong3-529-pages-v3-5\",\"Jijiamingren_liandan_pugong3-529-pages-v3-5\",\"Jijiamingren_liandan_pugong3-529-pages-v3-5\",\"Jijiamingren_liandan_pugong3-529-pages-v3-5\",\"Jijiamingren_liandan_pugong3-529-pages-v3-5\",\"Jijiamingren_liandan_pugong3-529-pages-v3-6\",\"Jijiamingren_liandan_pugong3-529-pages-v3-6\",\"Jijiamingren_liandan_pugong3-529-pages-v3-6\",\"Jijiamingren_liandan_pugong3-529-pages-v3-6\",\"Jijiamingren_liandan_pugong3-529-pages-v3-6\",\"Jijiamingren_liandan_pugong3-529-pages-v3-6\",\"Jijiamingren_liandan_pugong3-529-pages-v3-7\",\"Jijiamingren_liandan_pugong3-529-pages-v3-7\",\"Jijiamingren_liandan_pugong3-529-pages-v3-0\",\"Jijiamingren_liandan_pugong3-529-pages-v3-0\",\"Jijiamingren_liandan_pugong3-529-pages-v3-0\",\"Jijiamingren_liandan_pugong3-529-pages-v3-0\",\"Jijiamingren_liandan_pugong3-529-pages-v3-0\",\"Jijiamingren_liandan_pugong3-529-pages-v3-0\",\"Jijiamingren_liandan_pugong3-529-pages-v3-0\",\"Jijiamingren_liandan_pugong3-529-pages-v3-0\",\"Jijiamingren_liandan_pugong3-529-pages-v3-7\",\"Jijiamingren_liandan_pugong3-529-pages-v3-7\",\"Jijiamingren_liandan_pugong3-529-pages-v3-7\",\"Jijiamingren_liandan_pugong3-529-pages-v3-7\",\"Jijiamingren_liandan_pugong3-529-pages-v3-8\",\"Jijiamingren_liandan_pugong3-529-pages-v3-8\",\"Jijiamingren_liandan_pugong3-529-pages-v3-8\",\"Jijiamingren_liandan_pugong3-529-pages-v3-8\",\"Jijiamingren_liandan_pugong3-529-pages-v3-8\",\"Jijiamingren_liandan_pugong3-529-pages-v3-8\",\"Jijiamingren_liandan_pugong3-529-pages-v3-8\",\"Jijiamingren_liandan_pugong3-529-pages-v3-9\",\"Jijiamingren_liandan_pugong3-529-pages-v3-9\",\"Jijiamingren_liandan_pugong3-529-pages-v3-9\",\"Jijiamingren_liandan_pugong3-529-pages-v3-9\",\"Jijiamingren_liandan_pugong3-529-pages-v3-9\",\"Jijiamingren_liandan_pugong3-529-pages-v3-9\",\"Jijiamingren_liandan_pugong3-529-pages-v3-10\",\"Jijiamingren_liandan_pugong3-529-pages-v3-10\",\"Jijiamingren_liandan_pugong3-529-pages-v3-10\",\"Jijiamingren_liandan_pugong3-529-pages-v3-10\",\"Jijiamingren_liandan_pugong3-529-pages-v3-10\",\"Jijiamingren_liandan_pugong3-529-pages-v3-10\",\"Jijiamingren_liandan_pugong3-529-pages-v3-11\",\"Jijiamingren_liandan_pugong3-529-pages-v3-11\",\"Jijiamingren_liandan_pugong3-529-pages-v3-11\",\"Jijiamingren_liandan_pugong3-529-pages-v3-11\",\"Jijiamingren_liandan_pugong3-529-pages-v3-11\",\"Jijiamingren_liandan_pugong3-529-pages-v3-11\",\"Jijiamingren_liandan_pugong3-529-pages-v3-12\",\"Jijiamingren_liandan_pugong3-529-pages-v3-12\",\"Jijiamingren_liandan_pugong3-529-pages-v3-12\",\"Jijiamingren_liandan_pugong3-529-pages-v3-12\",\"Jijiamingren_liandan_pugong3-529-pages-v3-12\",\"Jijiamingren_liandan_pugong3-529-pages-v3-12\",\"Jijiamingren_liandan_pugong3-529-pages-v3-12\",\"Jijiamingren_liandan_pugong3-529-pages-v3-13\",\"Jijiamingren_liandan_pugong3-529-pages-v3-13\",\"Jijiamingren_liandan_pugong3-529-pages-v3-13\",\"Jijiamingren_liandan_pugong3-529-pages-v3-0\"],\"timeline\":[0,0,0,0,1,1,2,3,4,5,0,1,2,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,2,3,4,5,0,1,2,3,4,5,0,1,0,0,0,0,0,0,0,0,2,3,4,5,0,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,0,1,2,3,4,5,0,1,2,0],\"width\":714,\"height\":520,\"pivot\":[0.5355217086834734,0.6485624999999999],\"renderScale\":0.85,\"sourceFrames\":94,\"sourceCrop\":[25,141,739,661],\"sourceZoom\":0.85},\"Jijiamingren_luoxuanwan_zhuida-626\":{\"atlas\":\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-0\",\"frameAtlases\":[\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-0\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-0\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-0\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-0\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-0\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-0\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-0\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-0\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-0\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-1\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-1\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-1\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-1\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-1\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-1\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-1\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-2\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-2\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-2\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-2\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-2\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-2\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-3\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-3\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-3\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-3\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-3\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-3\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-4\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-4\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-4\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-4\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-4\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-4\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-5\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-5\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-5\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-5\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-5\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-5\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-5\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-6\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-6\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-6\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-6\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-6\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-6\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-7\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-7\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-7\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-7\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-7\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-7\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-8\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-8\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-8\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-8\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-8\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-8\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-9\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-9\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-9\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-9\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-9\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-9\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-9\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-10\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-10\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-10\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-10\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-10\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-10\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-11\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-11\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-11\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-11\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-11\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-11\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-12\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-12\",\"Jijiamingren_luoxuanwan_zhuida-626-pages-v3-12\"],\"timeline\":[0,0,0,0,1,2,3,4,5,0,1,2,3,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,1],\"width\":850,\"height\":680,\"pivot\":[-0.11905882352941181,0.7178897058823529],\"renderScale\":0.85,\"sourceFrames\":77,\"sourceCrop\":[1672,1777,2522,2457],\"sourceZoom\":0.85,\"contactCamera\":true,\"softEdges\":true},\"Jijiamingren_qianghua_pugong-250\":{\"atlas\":\"Jijiamingren_qianghua_pugong-250-pages-v3-0\",\"frameAtlases\":[\"Jijiamingren_qianghua_pugong-250-pages-v3-0\",\"Jijiamingren_qianghua_pugong-250-pages-v3-0\",\"Jijiamingren_qianghua_pugong-250-pages-v3-0\",\"Jijiamingren_qianghua_pugong-250-pages-v3-0\",\"Jijiamingren_qianghua_pugong-250-pages-v3-0\",\"Jijiamingren_qianghua_pugong-250-pages-v3-0\",\"Jijiamingren_qianghua_pugong-250-pages-v3-0\",\"Jijiamingren_qianghua_pugong-250-pages-v3-0\",\"Jijiamingren_qianghua_pugong-250-pages-v3-0\",\"Jijiamingren_qianghua_pugong-250-pages-v3-0\",\"Jijiamingren_qianghua_pugong-250-pages-v3-0\",\"Jijiamingren_qianghua_pugong-250-pages-v3-0\",\"Jijiamingren_qianghua_pugong-250-pages-v3-0\",\"Jijiamingren_qianghua_pugong-250-pages-v3-0\",\"Jijiamingren_qianghua_pugong-250-pages-v3-0\",\"Jijiamingren_qianghua_pugong-250-pages-v3-0\",\"Jijiamingren_qianghua_pugong-250-pages-v3-0\",\"Jijiamingren_qianghua_pugong-250-pages-v3-0\",\"Jijiamingren_qianghua_pugong-250-pages-v3-0\",\"Jijiamingren_qianghua_pugong-250-pages-v3-0\",\"Jijiamingren_qianghua_pugong-250-pages-v3-0\",\"Jijiamingren_qianghua_pugong-250-pages-v3-0\",\"Jijiamingren_qianghua_pugong-250-pages-v3-1\",\"Jijiamingren_qianghua_pugong-250-pages-v3-1\",\"Jijiamingren_qianghua_pugong-250-pages-v3-1\",\"Jijiamingren_qianghua_pugong-250-pages-v3-1\",\"Jijiamingren_qianghua_pugong-250-pages-v3-1\",\"Jijiamingren_qianghua_pugong-250-pages-v3-1\",\"Jijiamingren_qianghua_pugong-250-pages-v3-1\",\"Jijiamingren_qianghua_pugong-250-pages-v3-1\",\"Jijiamingren_qianghua_pugong-250-pages-v3-1\",\"Jijiamingren_qianghua_pugong-250-pages-v3-1\",\"Jijiamingren_qianghua_pugong-250-pages-v3-2\",\"Jijiamingren_qianghua_pugong-250-pages-v3-2\",\"Jijiamingren_qianghua_pugong-250-pages-v3-2\",\"Jijiamingren_qianghua_pugong-250-pages-v3-2\",\"Jijiamingren_qianghua_pugong-250-pages-v3-2\",\"Jijiamingren_qianghua_pugong-250-pages-v3-2\",\"Jijiamingren_qianghua_pugong-250-pages-v3-2\",\"Jijiamingren_qianghua_pugong-250-pages-v3-2\",\"Jijiamingren_qianghua_pugong-250-pages-v3-2\",\"Jijiamingren_qianghua_pugong-250-pages-v3-2\",\"Jijiamingren_qianghua_pugong-250-pages-v3-2\",\"Jijiamingren_qianghua_pugong-250-pages-v3-3\",\"Jijiamingren_qianghua_pugong-250-pages-v3-3\",\"Jijiamingren_qianghua_pugong-250-pages-v3-3\",\"Jijiamingren_qianghua_pugong-250-pages-v3-3\",\"Jijiamingren_qianghua_pugong-250-pages-v3-3\",\"Jijiamingren_qianghua_pugong-250-pages-v3-3\",\"Jijiamingren_qianghua_pugong-250-pages-v3-3\",\"Jijiamingren_qianghua_pugong-250-pages-v3-3\",\"Jijiamingren_qianghua_pugong-250-pages-v3-0\",\"Jijiamingren_qianghua_pugong-250-pages-v3-0\",\"Jijiamingren_qianghua_pugong-250-pages-v3-0\",\"Jijiamingren_qianghua_pugong-250-pages-v3-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,1,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,5,6,7,8,9,0,1,2,3,4,5,6,7,0,0,0,0],\"width\":835,\"height\":366,\"pivot\":[0.1380329341317365,0.7177800546448087],\"renderScale\":0.85,\"sourceFrames\":52,\"sourceCrop\":[53,56,888,422],\"sourceZoom\":0.85},\"Jijiamingren_shanbi-154\":{\"atlas\":\"Jijiamingren_shanbi-154-pages-v3-0\",\"frameAtlases\":[\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\",\"Jijiamingren_shanbi-154-pages-v3-0\"],\"timeline\":[0,0,0,0,0,1,2,3,4,5,6,7,8,8,9,10,11,12,13,14,0,0,0,0,0,0,0,15,16,17,18,19,20,21,22,23,24,25,25,26,27,0],\"width\":346,\"height\":171,\"pivot\":[0.5182008670520232,0.7446929824561404],\"renderScale\":0.8499999999999999,\"sourceFrames\":40,\"sourceCrop\":[59,58,405,229],\"sourceZoom\":0.85},\"Jijiamingren_shanbi-90\":{\"atlas\":\"Jijiamingren_shanbi-90-pages-v3-0\",\"frameAtlases\":[\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-0\",\"Jijiamingren_shanbi-90-pages-v3-1\"],\"timeline\":[0,0,0,0,0,1,2,3,4,5,6,7,8,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,32,33,34,0],\"width\":347,\"height\":284,\"pivot\":[0.5035878962536023,0.7393309859154928],\"renderScale\":0.85,\"sourceFrames\":40,\"sourceCrop\":[97,18,444,302],\"sourceZoom\":0.85},\"Jijiamingren_jiuweilama_weisouyu-609\":{\"atlas\":\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-0\",\"frameAtlases\":[\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-1\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-1\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-1\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-1\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-1\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-1\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-2\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-2\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-2\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-2\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-2\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-2\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-3\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-3\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-3\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-3\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-3\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-3\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-4\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-4\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-4\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-4\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-4\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-4\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-4\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-5\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-5\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-5\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-5\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-5\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-5\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-6\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-6\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-6\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-6\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-6\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-6\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-7\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-7\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-7\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-7\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-7\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-7\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-8\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-8\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-8\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-8\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-8\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-8\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-8\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-9\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-9\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-9\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-9\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-9\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-9\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-10\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-10\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-10\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-10\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-10\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-10\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-11\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-11\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-11\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-11\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-11\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-11\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-12\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-12\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-12\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-12\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-12\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-12\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-12\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-13\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-13\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-13\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-13\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-13\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-13\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-14\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-14\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-14\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-14\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-14\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-14\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-15\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-15\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-15\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-15\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-15\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-15\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-609-pages-v3-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,1,2,2,3,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,0,0],\"width\":943,\"height\":628,\"pivot\":[0.5001587727843846,0.5001059608886586],\"renderScale\":0.5237215033887862,\"sourceFrames\":107,\"sourceCrop\":[40,310,983,938],\"sourceZoom\":0.5237215033887862,\"contactCamera\":true,\"softEdges\":true},\"Jijiamingren_jiuweilama_weisouyu-67\":{\"atlas\":\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-0\",\"frameAtlases\":[\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-1\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-1\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-1\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-1\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-1\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-1\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-2\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-2\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-2\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-2\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-2\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-2\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-2\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-2\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-2\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-2\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-2\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-2\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-2\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-2\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-2\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-2\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-2\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-2\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-2\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-3\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-3\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-3\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-3\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-3\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-3\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-4\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-4\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-4\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-4\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-4\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-4\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-5\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-5\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-5\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-5\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-5\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-5\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-5\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-5\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-5\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-5\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-5\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-5\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-5\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-5\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-5\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-5\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-5\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-5\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-5\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-5\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-6\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-6\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-6\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-6\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-6\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-6\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-7\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-7\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-7\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-7\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-7\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-7\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-7\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-8\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-8\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-8\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-8\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-8\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-8\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-9\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-9\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-9\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-9\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-9\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-9\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-0\",\"Jijiamingren_jiuweilama_weisouyu-67-pages-v3-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,4,5,0,1,2,3,4,5,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,2,3,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,0,1,2,3,4,5,0,1,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,0,0,0,0,0,0],\"width\":942,\"height\":628,\"pivot\":[0.499922164532405,0.49994898179434955],\"renderScale\":0.5237215033887862,\"sourceFrames\":107,\"sourceCrop\":[192,245,1134,873],\"sourceZoom\":0.5237215033887862,\"contactCamera\":true,\"additive\":true,\"softEdges\":true},\"Jijiamingren_jiuweilama_zhuaji-12\":{\"atlas\":\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"frameAtlases\":[\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-12-pages-v3-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,0,0,0,0,0,0,0,0,0],\"width\":370,\"height\":85,\"pivot\":[0.44418910478750473,0.22828152764243437],\"renderScale\":0.33707085427633865,\"sourceFrames\":85,\"sourceCrop\":[7,5,377,90],\"sourceZoom\":0.33707085427633865},\"Jijiamingren_jiuweilama_zhuaji-379\":{\"atlas\":\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-0\",\"frameAtlases\":[\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-1\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-1\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-1\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-1\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-2\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-2\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-2\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-2\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-3\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-3\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-3\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-3\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-4\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-4\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-4\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-4\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-5\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-5\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-5\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-5\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-6\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-6\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-6\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-6\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-6\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-7\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-7\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-7\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-7\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-8\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-8\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-8\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-8\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-9\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-9\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-9\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-9\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-10\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-10\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-10\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-10\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-11\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-11\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-11\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-11\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-12\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-12\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-12\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-12\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-12\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-13\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-13\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-13\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-13\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-14\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-14\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-14\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-14\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-15\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-0\",\"Jijiamingren_jiuweilama_zhuaji-379-pages-v3-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,1,1,2,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,0,1,2,3,0,1,2,3,0,1,2,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0],\"width\":905,\"height\":900,\"pivot\":[0.4388882318810674,0.4921450138808531],\"renderScale\":0.2891460882654848,\"sourceFrames\":85,\"sourceCrop\":[309,382,1364,1431],\"sourceZoom\":0.33707085427633865},\"Jijiamingren_jiuweilama_hengsao-256\":{\"atlas\":\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"frameAtlases\":[\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-1\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-1\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-1\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-1\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-2\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-2\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-2\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-2\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-3\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-3\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-3\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-3\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-4\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-4\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-4\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-4\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-4\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-5\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-5\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-5\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-5\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-6\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-6\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-6\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-6\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-7\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-7\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-7\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-7\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-8\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-8\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-8\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-8\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-9\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-9\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-9\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-9\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-9\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-10\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-10\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-10\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-10\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-11\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-11\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-11\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-11\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-11\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-12\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-12\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-12\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-12\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-13\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-13\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-13\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-13\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-14\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-14\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-14\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-14\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-14\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-15\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-15\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-15\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-15\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-256-pages-v3-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,1,2,3,0,1,0,0,0,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,2,3,0,1,2,0,0,3,0,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,3,0,1,2,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],\"width\":798,\"height\":900,\"pivot\":[0.49661891322629925,0.4919143719713732],\"renderScale\":0.28890432650839987,\"sourceFrames\":105,\"sourceCrop\":[312,384,1239,1429],\"sourceZoom\":0.3356069056056224},\"Jijiamingren_jiuweilama_hengsao-58\":{\"atlas\":\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"frameAtlases\":[\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\",\"Jijiamingren_jiuweilama_hengsao-58-pages-v3-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],\"width\":384,\"height\":141,\"pivot\":[0.47832970581751527,0.5081309068548024],\"renderScale\":0.3356069056056224,\"sourceFrames\":105,\"sourceCrop\":[256,41,640,182],\"sourceZoom\":0.3356069056056224}},\"effects\":{\"Jijiamingren_aoyi\":[\"Jijiamingren_aoyi-1343\",\"Jijiamingren_aoyi-139\"],\"Jijiamingren_ji_aoyi\":[\"Jijiamingren_ji_aoyi-245\",\"Jijiamingren_ji_aoyi-440\"],\"Jijiamingren_liandan_pugong3\":[\"Jijiamingren_liandan_pugong3-529\"],\"Jijiamingren_luoxuanwan_zhuida\":[\"Jijiamingren_luoxuanwan_zhuida-626\"],\"Jijiamingren_qianghua_pugong\":[\"Jijiamingren_qianghua_pugong-250\"],\"Jijiamingren_shanbi\":[\"Jijiamingren_shanbi-154\",\"Jijiamingren_shanbi-90\"],\"Jijiamingren_jiuweilama_weisouyu\":[\"Jijiamingren_jiuweilama_weisouyu-609\",\"Jijiamingren_jiuweilama_weisouyu-67\"],\"Jijiamingren_jiuweilama_zhuaji\":[\"Jijiamingren_jiuweilama_zhuaji-12\",\"Jijiamingren_jiuweilama_zhuaji-379\"],\"Jijiamingren_jiuweilama_hengsao\":[\"Jijiamingren_jiuweilama_hengsao-256\",\"Jijiamingren_jiuweilama_hengsao-58\"]},\"effectAnchors\":{\"Jijiamingren_aoyi\":[246.20065571085627,18.791136854334667],\"Jijiamingren_liandan_pugong3\":[96.05904538169939,-104.51751866301369],\"Jijiamingren_luoxuanwan_zhuida\":[618.5432939914635,-174.53523734424024],\"Jijiamingren_qianghua_pugong\":[293.9061087047697,-101.02931854894682],\"Jijiamingren_shanbi\":[-43.70516058621769,-5.010697630068837],\"Jijiamingren_jiuweilama_weisouyu\":[535.3651692306987,-164.22107210216055],\"Jijiamingren_jiuweilama_zhuaji\":[0,0],\"Jijiamingren_jiuweilama_hengsao\":[0,0]},\"moves\":{\"13121101\":\"bomb\",\"13121102\":\"combo\",\"13121103\":\"beam\",\"13121104\":\"rasengan\",\"13121105\":\"modified\",\"13121106\":\"extreme\",\"13121107\":\"high-bomb\",\"13121108\":\"jet\",\"13121109\":\"transform\",\"13121110\":\"recovery\",\"13121111\":\"beast-bomb\",\"13121112\":\"claw\",\"13121113\":\"sweep\"},\"actions\":{\"bomb\":[\"Jijiamingren_aoyi\"],\"high-bomb\":[\"Jijiamingren_aoyi\"],\"combo\":[\"Jijiamingren_liandan_pugong3\"],\"beam\":[\"Jijiamingren_qianghua_pugong\"],\"extreme\":[\"Jijiamingren_qianghua_pugong\"],\"rasengan\":[\"Jijiamingren_luoxuanwan_zhuida\"],\"modified\":[\"Jijiamingren_luoxuanwan_zhuida\"],\"jet\":[\"Jijiamingren_shanbi\"],\"transform\":[],\"recovery\":[\"Jijiamingren_ji_aoyi\"],\"beast-bomb\":[\"Jijiamingren_jiuweilama_weisouyu\"],\"claw\":[\"Jijiamingren_jiuweilama_zhuaji\"],\"sweep\":[\"Jijiamingren_jiuweilama_hengsao\"]}}");
         manifest.firstAtlases = {};
         for each(var clip:Object in manifest.clips)
         {
            manifest.firstAtlases[String(clip.atlas)] = true;
            if(clip.frameAtlases != null)
            {
               clip.nextAtlases = [];
               var next:String = null;
               var i:int = clip.frameAtlases.length - 1;
               while(i >= 0)
               {
                  if(i + 1 < clip.frameAtlases.length && String(clip.frameAtlases[i]) != String(clip.frameAtlases[i + 1]))
                  {
                     next = String(clip.frameAtlases[i + 1]);
                  }
                  clip.nextAtlases[i] = next;
                  i--;
               }
            }
         }
         for each(var windowClip:Object in manifest.clips)
         {
            windowClip.aheadPages = [];
            var tick:int = 0;
            while(tick < windowClip.timeline.length)
            {
               var pages:Array = [];
               var seen:Object = {};
               var j:int = tick;
               while(j < Math.min(tick + 21,windowClip.timeline.length))
               {
                  var page:String = windowClip.frameAtlases != null ? String(windowClip.frameAtlases[j]) : String(windowClip.atlas);
                  if(!seen[page])
                  {
                     seen[page] = true;
                     pages.push(page);
                  }
                  j++;
               }
               windowClip.aheadPages[tick] = pages;
               tick++;
            }
         }
         manifest.firstAtlases = {};
         for each(var warmName:String in ["Jijiamingren_aoyi-1343","Jijiamingren_aoyi-139","Jijiamingren_shanbi-154","Jijiamingren_shanbi-90"])
         {
            var warm:Object = manifest.clips[warmName];
            if(warm != null)
            {
               var head:int = 0;
               while(head < Math.min(5,warm.timeline.length))
               {
                  manifest.firstAtlases[String(warm.frameAtlases[head])] = true;
                  head++;
               }
            }
         }
         FMechaFxLoading["_manifest"] = manifest;
         return manifest;
      }
      
      private static function PreloadItachiVfx() : void
      {
         var manifest:Object = ItachiVfxManifest();
         for each(var effect:String in ["YuzhiboyoRZZL_Huanshuxielunyan","YuzhiboyoRZZL_Yafenshenzhishu","YuzhiboyoRZZL_Yongbingjituan_LB","YuzhiboyoRZZL_Yongbingjituan_NZ","YuzhiboyoRZZL_Yongbingjituan_QY","YuzhiboyoRZZL_Yongbingjituan_SB"])
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
                     LoadItachiVfxAtlas(page,manifest.atlases[page]);
                  }
                  head++;
               }
            }
         }
      }
      
      private static function ItachiPinPages(previous:Array, current:Array) : void
      {
         var pins:Object = FItachiFxLoading["_pins"];
         if(pins == null)
         {
            pins = {};
            FItachiFxLoading["_pins"] = pins;
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
         var queue:Array = FItachiFxLoading["_queue"] as Array;
         if(queue != null)
         {
            var i:int = queue.length - 1;
            while(i >= 0)
            {
               var queued:String = String(queue[i].name);
               if(int(pins[queued]) == 0 && !ItachiFirstAtlas(queued))
               {
                  queue.splice(i,1);
                  delete FItachiFxLoading[queued];
               }
               i--;
            }
         }
      }
      
      private static function PumpItachiVfxQueue() : void
      {
         var job:Object;
         var name:String;
         var meta:Object;
         var loader:URLLoader;
         var complete:Function;
         var failed:Function;
         var release:Function;
         var queue:Array = FItachiFxLoading["_queue"] as Array;
         if(queue == null || queue.length == 0 || int(FItachiFxLoading["_inflight"]) >= 6)
         {
            return;
         }
         queue.sortOn("deadline",Array.NUMERIC);
         job = queue.shift();
         name = String(job.name);
         meta = job.meta;
         FItachiFxLoading["_inflight"] = int(FItachiFxLoading["_inflight"]) + 1;
         loader = new URLLoader();
         loader.dataFormat = URLLoaderDataFormat.BINARY;
         release = function():void
         {
            loader.removeEventListener(Event.COMPLETE,complete);
            loader.removeEventListener(IOErrorEvent.IO_ERROR,failed);
            loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,failed);
            delete FItachiFxLoading[name];
            FItachiFxLoading["_inflight"] = Math.max(0,int(FItachiFxLoading["_inflight"]) - 1);
            loader.data = null;
            PumpItachiVfxQueue();
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
                  FItachiFxCache[name] = frames;
                  TrimItachiVfxCache(name);
               }
            }
            catch(error:Error)
            {
               if(data != null)
               {
                  data.clear();
               }
               if(source != null && FItachiFxCache[name] == null)
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
         PumpItachiVfxQueue();
      }
      
      private static function LoadItachiVfxAtlas(name:String, meta:Object, urgent:Boolean = false, lead:int = 0) : void
      {
         if(meta == null)
         {
            return;
         }
         FItachiFxLoading["_age_" + name] = getTimer();
         if(FItachiFxCache[name] != null)
         {
            return;
         }
         var queue:Array = FItachiFxLoading["_queue"] as Array;
         if(queue == null)
         {
            queue = [];
            FItachiFxLoading["_queue"] = queue;
         }
         if(FItachiFxLoading[name])
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
         FItachiFxLoading[name] = true;
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
         PumpItachiVfxQueue();
      }
      
      private static function TrimItachiVfxCache(keep:String) : void
      {
         var pixels:Number = 0;
         var pins:Object = FItachiFxLoading["_pins"];
         for(var key:String in FItachiFxCache)
         {
            var frames:Array = FItachiFxCache[key] as Array;
            if(frames != null && frames.length > 0)
            {
               pixels += BitmapData(frames[0]).width * BitmapData(frames[0]).height;
            }
         }
         while(pixels > 40000000)
         {
            var oldest:String = null;
            var age:Number = Number.MAX_VALUE;
            for(key in FItachiFxCache)
            {
               if(key != keep && !ItachiFirstAtlas(key) && (pins == null || int(pins[key]) == 0) && Number(FItachiFxLoading["_age_" + key]) < age)
               {
                  oldest = key;
                  age = Number(FItachiFxLoading["_age_" + key]);
               }
            }
            if(oldest == null)
            {
               break;
            }
            frames = FItachiFxCache[oldest] as Array;
            var atlas:BitmapData = BitmapData(frames[0]);
            pixels -= atlas.width * atlas.height;
            delete FItachiFxCache[oldest];
            delete FItachiFxLoading["_age_" + oldest];
            atlas.dispose();
         }
      }
      
      private static function ItachiFirstAtlas(key:String) : Boolean
      {
         return ItachiVfxManifest().firstAtlases[key] === true;
      }
      
      private static function ItachiVfxManifest() : Object
      {
         if(FItachiFxLoading["_manifest"] != null)
         {
            return FItachiFxLoading["_manifest"];
         }
         var manifest:Object = JSON.parse("{\"version\":6,\"frameMs\":40,\"frameRate\":25,\"atlases\":{\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0.png\",\"columns\":8,\"rows\":3,\"frameCount\":20},\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-0\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-0.png\",\"columns\":5,\"rows\":5,\"frameCount\":25},\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-1\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-1.png\",\"columns\":5,\"rows\":3,\"frameCount\":12},\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0.png\",\"columns\":6,\"rows\":9,\"frameCount\":54},\"YuzhiboyoRZZL_Yongbingjituan_SB_zhen-4-pages-v3-0\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB_zhen-4-pages-v3-0.png\",\"columns\":18,\"rows\":1,\"frameCount\":8},\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-0\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-0.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-1\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-1.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-2\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-2.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-3\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-3.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-4\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-4.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-5\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-5.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-6\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-6.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-7\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-7.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-8\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-8.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-9\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-9.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-10\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-10.png\",\"columns\":2,\"rows\":1,\"frameCount\":2},\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-0\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-0.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-1\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-1.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-2\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-2.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-3\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-3.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-4\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-4.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-5\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-5.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-6\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-6.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-7\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-7.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-8\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-8.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-9\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-9.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-10\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-10.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-11\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-11.png\",\"columns\":2,\"rows\":2,\"frameCount\":4},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-0\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-0.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-1\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-1.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-2\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-2.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-3\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-3.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-4\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-4.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-5\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-5.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-6\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-6.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-7\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-7.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-8\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-8.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-9\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-9.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-10\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-10.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-11\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-11.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-12\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-12.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-13\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-13.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-14\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-14.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-15\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-15.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-16\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-16.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-17\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-17.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-18\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-18.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-19\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-19.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-20\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-20.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-21\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-21.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-22\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-22.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-23\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-23.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-24\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-24.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-25\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-25.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-26\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-26.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-27\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-27.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-28\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-28.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-29\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-29.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-30\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-30.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-31\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-31.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-32\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-32.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-33\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-33.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-34\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-34.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-35\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-35.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-36\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-36.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-37\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-37.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-38\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-38.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-39\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-39.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-40\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-40.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-41\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-41.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-42\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-42.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-43\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-43.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-44\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-44.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-45\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-45.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-46\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-46.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-47\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-47.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-48\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-48.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-49\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-49.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-50\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-50.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-51\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-51.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-52\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-52.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-53\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-53.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-0\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-0.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-1\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-1.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-2\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-2.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-3\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-3.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-4\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-4.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-5\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-5.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-6\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-6.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-7\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-7.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-8\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-8.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-9\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-9.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-10\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-10.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-11\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-11.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-12\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-12.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-13\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-13.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-14\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-14.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-15\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-15.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-16\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-16.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-17\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-17.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-18\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-18.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-19\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-19.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-20\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-20.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-21\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-21.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-22\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-22.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-23\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-23.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-24\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-24.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-25\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-25.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-26\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-26.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-27\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-27.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-28\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-28.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-29\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-29.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-30\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-30.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-31\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-31.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-32\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-32.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-33\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-33.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-34\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-34.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-35\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-35.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-36\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-36.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-37\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-37.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-38\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-38.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-39\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-39.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-40\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-40.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-41\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-41.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-42\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-42.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-43\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-43.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-1\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-1.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-2\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-2.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-3\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-3.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-4\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-4.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-5\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-5.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-6\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-6.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-7\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-7.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-8\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-8.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-9\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-9.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-10\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-10.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-11\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-11.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-12\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-12.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-13\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-13.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-14\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-14.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-15\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-15.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-16\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-16.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-17\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-17.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-18\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-18.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-19\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-19.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-20\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-20.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-21\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-21.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-22\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-22.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-23\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-23.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-24\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-24.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-25\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-25.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-26\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-26.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-27\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-27.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-28\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-28.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-29\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-29.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-30\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-30.png\",\"columns\":1,\"rows\":1,\"frameCount\":1},\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-0\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-0.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-1\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-1.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-2\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-2.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-3\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-3.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-4\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-4.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-5\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-5.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-6\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-6.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-7\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-7.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-8\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-8.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-9\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-9.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-10\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-10.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-11\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-11.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-12\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-12.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-13\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-13.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-14\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-14.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-15\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-15.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-16\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-16.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-17\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-17.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-18\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-18.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-19\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-19.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-20\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-20.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-21\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-21.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-22\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-22.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-23\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-23.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-24\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-24.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-25\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-25.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-26\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-26.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-27\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-27.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-28\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-28.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-29\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-29.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-30\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-30.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-31\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-31.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-32\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-32.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-33\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-33.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-34\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-34.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-0\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-0.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-1\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-1.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-2\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-2.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-3\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-3.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-4\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-4.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-5\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-5.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-6\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-6.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-7\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-7.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-8\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-8.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-9\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-9.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-10\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-10.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-11\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-11.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-12\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-12.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-13\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-13.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-14\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-14.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-15\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-15.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-16\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-16.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-17\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-17.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-18\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-18.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-19\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-19.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-20\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-20.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-21\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-21.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-22\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-22.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-23\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-23.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-24\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-24.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-25\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-25.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-26\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-26.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-27\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-27.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-28\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-28.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-29\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-29.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-30\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-30.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-31\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-31.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-32\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-32.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-33\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-33.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-34\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-34.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-35\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-35.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-36\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-36.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-37\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-37.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-38\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-38.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-39\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-39.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-40\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-40.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-41\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-41.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-42\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-42.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-43\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-43.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-44\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-44.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-45\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-45.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-46\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-46.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-47\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-47.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-48\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-48.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-49\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-49.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-50\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-50.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-51\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-51.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-52\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-52.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-53\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-53.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-54\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-54.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-55\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-55.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-56\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-56.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-57\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-57.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-58\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-58.png\",\"columns\":1,\"rows\":1,\"frameCount\":1},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-1\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-1.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-2\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-2.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-3\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-3.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-4\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-4.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-5\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-5.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-6\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-6.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-7\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-7.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-8\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-8.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-9\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-9.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-10\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-10.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-11\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-11.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-12\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-12.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-13\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-13.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-14\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-14.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-15\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-15.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-16\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-16.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-17\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-17.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-18\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-18.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-19\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-19.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-20\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-20.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-21\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-21.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-22\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-22.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-23\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-23.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-24\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-24.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-25\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-25.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-26\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-26.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-27\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-27.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-28\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-28.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-29\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-29.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-30\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-30.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-31\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-31.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-32\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-32.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-33\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-33.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-34\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-34.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-35\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-35.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-36\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-36.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-37\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-37.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-0\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-0.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-1\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-1.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-2\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-2.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-3\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-3.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-4\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-4.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-5\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-5.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-6\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-6.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-7\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-7.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-8\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-8.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-9\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-9.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-10\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-10.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-11\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-11.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-12\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-12.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-13\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-13.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-14\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-14.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-15\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-15.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-16\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-16.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-17\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-17.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-18\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-18.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-19\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-19.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-20\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-20.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-21\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-21.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-22\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-22.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-23\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-23.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-24\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-24.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-25\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-25.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-26\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-26.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-27\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-27.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-28\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-28.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-29\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-29.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-30\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-30.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-31\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-31.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-32\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-32.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-33\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-33.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-34\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-34.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-35\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-35.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-36\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-36.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-37\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-37.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-38\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-38.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-39\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-39.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-40\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-40.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-41\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-41.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-42\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-42.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-43\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-43.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-44\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-44.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-45\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-45.png\",\"columns\":1,\"rows\":1,\"frameCount\":1},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-0\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-0.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-1\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-1.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-2\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-2.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-3\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-3.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-4\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-4.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-5\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-5.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-6\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-6.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-7\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-7.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-8\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-8.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-9\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-9.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-10\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-10.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-11\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-11.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-12\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-12.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-13\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-13.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-14\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-14.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-15\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-15.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-16\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-16.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-17\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-17.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-18\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-18.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-19\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-19.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-20\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-20.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-21\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-21.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-22\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-22.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-23\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-23.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-24\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-24.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-25\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-25.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-26\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-26.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-27\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-27.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-28\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-28.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-29\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-29.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-30\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-30.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-31\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-31.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-32\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-32.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-33\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-33.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-34\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-34.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-35\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-35.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-36\":{\"url\":\"/public/itachi-vfx/extracted/YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-36.png\",\"columns\":1,\"rows\":3,\"frameCount\":3}},\"clips\":{\"YuzhiboyoRZZL_Huanshuxielunyan-27\":{\"atlas\":\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"frameAtlases\":[\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan-27-pages-v3-0\"],\"timeline\":[0,0,0,0,0,0,0,0,1,2,3,4,5,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],\"width\":233,\"height\":243,\"pivot\":[0.5190236051502145,1.1208744855967079],\"renderScale\":0.85,\"sourceFrames\":56,\"sourceCrop\":[52,59,285,302],\"sourceZoom\":0.85},\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239\":{\"atlas\":\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-0\",\"frameAtlases\":[\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-0\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-1\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-1\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-1\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-1\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-1\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-1\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-1\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-1\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-1\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-1\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-1\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-1\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-1\",\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239-pages-v3-1\"],\"timeline\":[0,1,2,3,4,5,6,7,8,9,10,11,12,12,13,14,15,16,17,18,19,20,21,22,23,24,0,1,2,3,4,5,6,7,8,9,10,11,11,11],\"width\":395,\"height\":348,\"pivot\":[0.4781012658227848,0.6919899425287356],\"renderScale\":0.85,\"sourceFrames\":38,\"sourceCrop\":[50,11,445,359],\"sourceZoom\":0.85},\"YuzhiboyoRZZL_Yafenshenzhishu-40\":{\"atlas\":\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"frameAtlases\":[\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\",\"YuzhiboyoRZZL_Yafenshenzhishu-40-pages-v3-0\"],\"timeline\":[0,1,2,3,4,5,6,7,8,9,10,11,12,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,25,25],\"width\":319,\"height\":216,\"pivot\":[0.5348432601880878,0.9090972222222222],\"renderScale\":0.85,\"sourceFrames\":55,\"sourceCrop\":[18,5,337,221],\"sourceZoom\":0.85},\"YuzhiboyoRZZL_Yongbingjituan_QY-1257\":{\"atlas\":\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-0\",\"frameAtlases\":[\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-1\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-1\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-1\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-2\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-2\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-2\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-3\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-3\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-3\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-4\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-4\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-4\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-5\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-5\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-5\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-6\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-6\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-6\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-7\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-7\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-7\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-8\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-8\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-8\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-8\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-9\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-9\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-9\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-10\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-10\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-10\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-11\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-11\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-11\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-12\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-12\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-12\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-13\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-13\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-13\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-14\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-14\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-14\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-15\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-15\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-15\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-16\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-16\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-16\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-16\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-17\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-17\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-17\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-18\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-18\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-18\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-19\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-19\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-19\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-20\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-20\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-20\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-21\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-21\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-21\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-22\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-22\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-22\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-23\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-23\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-23\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-24\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-24\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-24\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-24\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-25\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-25\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-25\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-26\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-26\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-26\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-27\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-27\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-27\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-28\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-28\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-28\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-29\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-29\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-29\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-30\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-30\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-30\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-31\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-31\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-31\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-32\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-32\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-32\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-32\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-33\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-33\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-33\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-34\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-34\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-34\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-35\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-35\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-35\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-36\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-36\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-36\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-37\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-37\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-37\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-38\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-38\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-38\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-39\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-39\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-39\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-40\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-40\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-40\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-40\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-41\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-41\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-41\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-42\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-42\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-42\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-43\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-43\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-43\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-44\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-44\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-44\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-45\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-45\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-45\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-46\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-46\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-46\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-47\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-47\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-47\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-48\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-48\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-48\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-48\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-49\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-49\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-49\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-50\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-50\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-50\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-51\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-51\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-51\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-52\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-52\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-52\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-53\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-53\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-53\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257-camera-v1-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,1,2,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,0],\"width\":1250,\"height\":650,\"pivot\":[0.26,0.6923076923076923],\"renderScale\":1,\"sourceFrames\":173,\"cameraClip\":true,\"camera\":[-325,-450,925,200]},\"YuzhiboyoRZZL_Yongbingjituan_QY-227\":{\"atlas\":\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-0\",\"frameAtlases\":[\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-1\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-1\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-1\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-1\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-1\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-2\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-2\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-2\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-2\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-2\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-3\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-3\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-3\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-3\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-3\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-3\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-4\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-4\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-4\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-4\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-5\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-5\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-5\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-5\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-6\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-6\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-6\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-7\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-7\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-7\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-8\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-8\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-8\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-8\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-8\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-9\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-9\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-9\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-9\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-10\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-10\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-10\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-10\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-10\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-10\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-11\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-11\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-11\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-11\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-11\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-11\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-12\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-12\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-12\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-13\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-13\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-13\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-14\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-14\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-14\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-15\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-15\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-15\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-16\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-16\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-16\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-17\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-17\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-17\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-18\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-18\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-18\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-18\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-18\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-19\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-19\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-19\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-19\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-20\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-20\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-20\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-20\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-21\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-21\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-21\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-21\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-22\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-22\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-22\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-22\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-22\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-23\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-23\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-23\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-23\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-24\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-24\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-24\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-24\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-25\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-25\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-25\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-26\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-26\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-26\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-27\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-27\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-27\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-28\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-28\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-28\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-29\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-29\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-29\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-30\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-30\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-30\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-31\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-31\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-31\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-32\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-32\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-32\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-32\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-33\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-33\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-33\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-34\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-34\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-34\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-35\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-35\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-35\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-36\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-36\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-36\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-37\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-37\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-37\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-38\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-38\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-38\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-39\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-39\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-39\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-40\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-40\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-40\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-40\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-41\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-41\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-41\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-42\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-42\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-42\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-43\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-43\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-43\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_QY-227-camera-v1-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,1,1,2,0,1,1,2,2,0,0,1,2,2,0,1,2,2,2,2,0,0,1,2,0,1,2,2,0,1,2,0,1,2,0,1,1,2,2,0,0,1,2,0,0,1,1,2,2,0,0,0,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,2,2,0,0,1,2,0,0,1,2,0,1,2,2,0,0,1,1,2,0,1,1,2,0,1,2,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,2,0,1,2,0,1,2,0,1,2,0,0,0,0,0,0,0,0],\"width\":1250,\"height\":650,\"pivot\":[0.26,0.6923076923076923],\"renderScale\":1,\"sourceFrames\":173,\"cameraClip\":true,\"camera\":[-325,-450,925,200]},\"YuzhiboyoRZZL_Yongbingjituan_NZ-213\":{\"atlas\":\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"frameAtlases\":[\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-1\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-1\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-1\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-2\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-2\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-2\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-3\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-3\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-3\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-4\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-4\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-4\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-4\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-5\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-5\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-5\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-6\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-6\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-6\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-7\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-7\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-7\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-8\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-8\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-8\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-9\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-9\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-9\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-10\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-10\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-10\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-11\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-11\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-11\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-12\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-12\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-12\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-12\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-13\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-13\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-13\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-14\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-14\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-14\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-15\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-15\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-15\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-16\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-16\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-16\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-17\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-17\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-17\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-18\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-18\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-18\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-19\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-19\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-19\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-20\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-20\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-20\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-20\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-21\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-21\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-21\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-22\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-22\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-22\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-23\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-23\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-23\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-24\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-24\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-24\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-25\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-25\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-25\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-26\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-26\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-26\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-27\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-27\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-27\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-28\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-28\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-28\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-28\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-29\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-29\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-29\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-30\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-213-camera-v1-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,0,1,2,0,1,2,0,1,2,0,1,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,1,2,0,1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],\"width\":1250,\"height\":650,\"pivot\":[0.26,0.6923076923076923],\"renderScale\":1,\"sourceFrames\":134,\"cameraClip\":true,\"camera\":[-325,-450,925,200]},\"YuzhiboyoRZZL_Yongbingjituan_NZ-879\":{\"atlas\":\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-0\",\"frameAtlases\":[\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-1\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-1\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-1\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-2\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-2\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-2\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-3\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-3\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-3\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-4\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-4\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-4\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-4\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-5\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-5\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-5\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-6\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-6\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-6\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-7\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-7\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-7\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-8\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-8\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-8\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-9\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-9\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-9\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-10\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-10\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-10\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-10\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-10\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-10\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-11\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-11\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-11\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-11\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-11\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-11\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-12\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-12\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-12\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-13\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-13\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-13\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-14\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-14\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-14\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-15\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-15\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-15\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-16\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-16\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-16\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-17\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-17\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-17\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-18\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-18\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-18\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-18\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-19\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-19\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-19\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-20\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-20\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-20\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-21\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-21\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-21\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-22\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-22\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-22\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-23\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-23\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-23\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-24\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-24\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-24\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-25\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-25\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-25\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-26\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-26\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-26\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-26\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-27\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-27\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-27\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-28\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-28\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-28\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-29\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-29\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-29\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-30\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-30\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-30\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-31\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-31\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-31\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-32\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-32\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-32\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-33\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-33\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-33\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-34\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-34\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-34\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-34\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879-camera-v1-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,0,1,2,0,1,2,0,1,2,0,1,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,1,2,2,2,0,0,0,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,2,0],\"width\":1250,\"height\":650,\"pivot\":[0.26,0.6923076923076923],\"renderScale\":1,\"sourceFrames\":134,\"cameraClip\":true,\"camera\":[-325,-450,925,200]},\"YuzhiboyoRZZL_Yongbingjituan_LB-1640\":{\"atlas\":\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-0\",\"frameAtlases\":[\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-1\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-1\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-1\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-2\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-2\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-2\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-3\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-3\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-3\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-4\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-4\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-4\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-5\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-5\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-5\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-6\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-6\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-6\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-7\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-7\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-7\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-8\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-8\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-8\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-8\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-9\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-9\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-9\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-10\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-10\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-10\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-11\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-11\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-11\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-12\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-12\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-12\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-13\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-13\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-13\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-14\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-14\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-14\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-15\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-15\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-15\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-16\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-16\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-16\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-16\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-17\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-17\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-17\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-18\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-18\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-18\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-19\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-19\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-19\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-20\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-20\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-20\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-21\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-21\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-21\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-22\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-22\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-22\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-23\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-23\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-23\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-24\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-24\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-24\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-24\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-25\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-25\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-25\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-26\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-26\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-26\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-27\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-27\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-27\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-28\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-28\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-28\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-29\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-29\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-29\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-30\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-30\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-30\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-31\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-31\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-31\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-32\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-32\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-32\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-32\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-33\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-33\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-33\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-34\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-34\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-34\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-35\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-35\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-35\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-36\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-36\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-36\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-37\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-37\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-37\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-38\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-38\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-38\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-39\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-39\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-39\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-40\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-40\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-40\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-40\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-41\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-41\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-41\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-42\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-42\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-42\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-43\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-43\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-43\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-44\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-44\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-44\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-45\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-45\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-45\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-46\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-46\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-46\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-47\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-47\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-47\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-48\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-48\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-48\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-48\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-49\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-49\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-49\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-50\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-50\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-50\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-51\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-51\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-51\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-52\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-52\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-52\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-53\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-53\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-53\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-54\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-54\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-54\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-55\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-55\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-55\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-56\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-56\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-56\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-56\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-57\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-57\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-57\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-58\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640-camera-v1-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,1,2,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,2,0,1,2,0,0],\"width\":1250,\"height\":650,\"pivot\":[0.26,0.6923076923076923],\"renderScale\":1,\"sourceFrames\":186,\"cameraClip\":true,\"camera\":[-325,-450,925,200]},\"YuzhiboyoRZZL_Yongbingjituan_LB-266\":{\"atlas\":\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"frameAtlases\":[\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-1\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-1\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-1\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-2\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-2\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-2\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-3\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-3\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-3\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-4\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-4\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-4\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-5\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-5\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-5\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-6\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-6\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-6\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-7\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-7\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-7\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-7\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-8\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-8\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-8\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-9\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-9\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-9\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-10\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-10\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-10\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-11\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-11\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-11\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-12\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-12\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-12\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-13\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-13\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-13\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-14\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-14\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-14\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-15\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-15\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-15\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-15\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-16\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-16\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-16\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-17\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-17\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-17\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-18\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-18\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-18\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-19\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-19\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-19\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-20\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-20\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-20\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-21\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-21\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-21\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-22\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-22\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-22\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-23\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-23\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-23\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-23\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-24\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-24\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-24\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-25\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-25\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-25\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-26\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-26\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-26\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-27\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-27\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-27\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-28\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-28\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-28\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-29\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-29\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-29\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-30\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-30\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-30\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-31\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-31\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-31\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-31\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-32\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-32\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-32\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-33\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-33\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-33\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-34\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-34\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-34\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-35\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-35\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-35\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-36\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-36\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-36\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-37\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-37\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-37\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_LB-266-camera-v1-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,0,0,0,0,0,0,0,0,0],\"width\":1250,\"height\":650,\"pivot\":[0.26,0.6923076923076923],\"renderScale\":1,\"sourceFrames\":186,\"cameraClip\":true,\"camera\":[-325,-450,925,200]},\"YuzhiboyoRZZL_Yongbingjituan_SB-1795\":{\"atlas\":\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-0\",\"frameAtlases\":[\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-1\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-1\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-1\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-2\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-2\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-2\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-2\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-3\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-3\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-3\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-4\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-4\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-4\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-5\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-5\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-5\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-6\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-6\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-6\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-7\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-7\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-7\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-8\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-8\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-8\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-9\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-9\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-9\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-10\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-10\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-10\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-10\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-11\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-11\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-11\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-12\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-12\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-12\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-13\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-13\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-13\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-14\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-14\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-14\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-15\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-15\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-15\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-16\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-16\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-16\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-17\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-17\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-17\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-18\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-18\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-18\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-18\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-19\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-19\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-19\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-20\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-20\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-20\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-21\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-21\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-21\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-22\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-22\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-22\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-23\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-23\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-23\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-24\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-24\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-24\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-25\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-25\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-25\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-26\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-26\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-26\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-26\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-27\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-27\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-27\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-28\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-28\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-28\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-29\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-29\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-29\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-30\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-30\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-30\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-31\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-31\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-31\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-32\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-32\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-32\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-33\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-33\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-33\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-34\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-34\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-34\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-34\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-35\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-35\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-35\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-36\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-36\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-36\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-37\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-37\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-37\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-38\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-38\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-38\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-39\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-39\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-39\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-40\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-40\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-40\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-41\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-41\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-41\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-42\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-42\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-42\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-42\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-43\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-43\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-43\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-44\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-44\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-44\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795-camera-v1-45\"],\"timeline\":[0,0,0,0,1,1,2,0,1,2,0,1,2,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,2,0,1,2,0,1,2,0],\"width\":1250,\"height\":650,\"pivot\":[0.26,0.6923076923076923],\"renderScale\":1,\"sourceFrames\":140,\"cameraClip\":true,\"camera\":[-325,-450,925,200]},\"YuzhiboyoRZZL_Yongbingjituan_SB-348\":{\"atlas\":\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-0\",\"frameAtlases\":[\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-1\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-1\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-1\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-1\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-2\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-2\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-2\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-3\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-3\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-3\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-4\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-4\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-4\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-5\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-5\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-5\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-6\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-6\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-6\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-7\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-7\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-7\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-8\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-8\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-8\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-9\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-9\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-9\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-9\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-10\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-10\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-10\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-11\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-11\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-11\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-12\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-12\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-12\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-13\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-13\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-13\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-14\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-14\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-14\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-15\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-15\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-15\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-16\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-16\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-16\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-17\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-17\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-17\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-17\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-18\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-18\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-18\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-19\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-19\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-19\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-20\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-20\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-20\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-21\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-21\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-21\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-22\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-22\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-22\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-23\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-23\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-23\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-24\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-24\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-24\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-25\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-25\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-25\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-25\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-26\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-26\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-26\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-27\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-27\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-27\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-28\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-28\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-28\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-29\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-29\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-29\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-30\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-30\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-30\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-31\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-31\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-31\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-32\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-32\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-32\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-33\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-33\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-33\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-33\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-34\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-34\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-34\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-35\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-35\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-35\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-36\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-36\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-36\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB-348-camera-v1-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,0,1,2,0,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,0,1,2,0,1,2,0,1,2,0,1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],\"width\":1250,\"height\":650,\"pivot\":[0.26,0.6923076923076923],\"renderScale\":1,\"sourceFrames\":140,\"cameraClip\":true,\"camera\":[-325,-450,925,200]},\"YuzhiboyoRZZL_Yongbingjituan_SB_zhen-4\":{\"atlas\":\"YuzhiboyoRZZL_Yongbingjituan_SB_zhen-4-pages-v3-0\",\"frameAtlases\":[\"YuzhiboyoRZZL_Yongbingjituan_SB_zhen-4-pages-v3-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB_zhen-4-pages-v3-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB_zhen-4-pages-v3-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB_zhen-4-pages-v3-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB_zhen-4-pages-v3-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB_zhen-4-pages-v3-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB_zhen-4-pages-v3-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB_zhen-4-pages-v3-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB_zhen-4-pages-v3-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB_zhen-4-pages-v3-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB_zhen-4-pages-v3-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB_zhen-4-pages-v3-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB_zhen-4-pages-v3-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB_zhen-4-pages-v3-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB_zhen-4-pages-v3-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB_zhen-4-pages-v3-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB_zhen-4-pages-v3-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB_zhen-4-pages-v3-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB_zhen-4-pages-v3-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB_zhen-4-pages-v3-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB_zhen-4-pages-v3-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB_zhen-4-pages-v3-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB_zhen-4-pages-v3-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB_zhen-4-pages-v3-0\"],\"timeline\":[0,1,2,3,4,5,6,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,0],\"width\":112,\"height\":107,\"pivot\":[0.5031696428571428,1.1498831775700935],\"renderScale\":0.85,\"sourceFrames\":23,\"sourceCrop\":[0,0,112,107],\"sourceZoom\":0.85},\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293\":{\"atlas\":\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-0\",\"frameAtlases\":[\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-1\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-1\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-1\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-1\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-2\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-2\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-2\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-2\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-3\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-3\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-3\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-3\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-3\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-4\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-4\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-4\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-4\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-5\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-5\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-5\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-5\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-6\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-6\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-6\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-6\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-7\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-7\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-7\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-7\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-8\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-8\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-8\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-8\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-9\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-9\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-9\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-9\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-9\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-10\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-10\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-10\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-10\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-10\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-10\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-10\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293-pages-v3-10\"],\"timeline\":[0,1,2,3,0,1,2,3,0,1,2,3,0,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,0,1,2,3,0,1,1,1,1,1,1,1],\"width\":718,\"height\":900,\"pivot\":[0.5022490756449379,0.6336523421604101],\"renderScale\":0.4099028305963213,\"sourceFrames\":48,\"sourceCrop\":[19,51,846,1087],\"sourceZoom\":0.4721304190851779},\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91\":{\"atlas\":\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-0\",\"frameAtlases\":[\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-0\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-1\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-1\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-1\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-1\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-2\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-2\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-2\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-2\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-3\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-3\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-3\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-3\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-3\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-4\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-4\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-4\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-4\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-5\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-5\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-5\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-5\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-6\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-6\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-6\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-6\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-7\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-7\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-7\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-7\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-8\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-8\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-8\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-8\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-9\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-9\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-9\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-9\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-9\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-10\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-10\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-10\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-10\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-11\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-11\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-11\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91-pages-v3-11\"],\"timeline\":[0,1,2,3,0,1,2,3,0,1,2,3,0,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,0,0,1,2,3,0,1,2,3,0,1,2,3],\"width\":933,\"height\":712,\"pivot\":[0.4928413199160304,0.7170646125924953],\"renderScale\":0.47213041908517794,\"sourceFrames\":48,\"sourceCrop\":[411,18,1344,730],\"sourceZoom\":0.4721304190851779}},\"effects\":{\"YuzhiboyoRZZL_Huanshuxielunyan\":[\"YuzhiboyoRZZL_Huanshuxielunyan-27\"],\"YuzhiboyoRZZL_Huanshuxielunyan_shouji\":[\"YuzhiboyoRZZL_Huanshuxielunyan_shouji-239\"],\"YuzhiboyoRZZL_Yafenshenzhishu\":[\"YuzhiboyoRZZL_Yafenshenzhishu-40\"],\"YuzhiboyoRZZL_Yongbingjituan_QY\":[\"YuzhiboyoRZZL_Yongbingjituan_QY-227\",\"YuzhiboyoRZZL_Yongbingjituan_QY-1257\"],\"YuzhiboyoRZZL_Yongbingjituan_NZ\":[\"YuzhiboyoRZZL_Yongbingjituan_NZ-213\",\"YuzhiboyoRZZL_Yongbingjituan_NZ-879\"],\"YuzhiboyoRZZL_Yongbingjituan_LB\":[\"YuzhiboyoRZZL_Yongbingjituan_LB-266\",\"YuzhiboyoRZZL_Yongbingjituan_LB-1640\"],\"YuzhiboyoRZZL_Yongbingjituan_SB\":[\"YuzhiboyoRZZL_Yongbingjituan_SB-348\",\"YuzhiboyoRZZL_Yongbingjituan_SB-1795\"],\"YuzhiboyoRZZL_Yongbingjituan_SB_zhen\":[\"YuzhiboyoRZZL_Yongbingjituan_SB_zhen-4\"],\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji\":[\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-91\",\"YuzhiboyoRZZL_Yongbingjituan_SB_shouji-293\"]},\"moves\":{\"13121201\":\"mystery\",\"13121202\":\"modified\",\"13121203\":\"standard\",\"13121204\":\"deidara\",\"13121205\":\"pain\",\"13121206\":\"hidan\",\"13121207\":\"crow\"},\"actions\":{\"standard\":[\"YuzhiboyoRZZL_Huanshuxielunyan\"],\"mystery\":[\"YuzhiboyoRZZL_Yongbingjituan_NZ\"],\"modified\":[\"YuzhiboyoRZZL_Yongbingjituan_NZ\"],\"deidara\":[\"YuzhiboyoRZZL_Yongbingjituan_QY\"],\"pain\":[\"YuzhiboyoRZZL_Yongbingjituan_LB\"],\"hidan\":[\"YuzhiboyoRZZL_Yongbingjituan_SB\"],\"crow\":[\"YuzhiboyoRZZL_Yafenshenzhishu\"]}}");
         manifest.firstAtlases = {};
         for(var name:String in manifest.clips)
         {
            var clip:Object = manifest.clips[name];
            if(clip.width * clip.height < 150000 && (name.indexOf("Yafenshen") >= 0 || name.indexOf("Huanshuxielunyan-") >= 0))
            {
               manifest.firstAtlases[clip.atlas] = true;
            }
            clip.nextAtlases = [];
            var next:String = null;
            var i:int = clip.frameAtlases.length - 1;
            while(i >= 0)
            {
               if(i + 1 < clip.frameAtlases.length && String(clip.frameAtlases[i]) != String(clip.frameAtlases[i + 1]))
               {
                  next = String(clip.frameAtlases[i + 1]);
               }
               clip.nextAtlases[i] = next;
               i--;
            }
            clip.aheadPages = [];
            var tick:int = 0;
            while(tick < clip.timeline.length)
            {
               var pages:Array = [];
               var seen:Object = {};
               var j:int = tick;
               while(j < Math.min(tick + 21,clip.timeline.length))
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
         FItachiFxLoading["_manifest"] = manifest;
         return manifest;
      }
      
      private static function PreloadSasukeVfx() : void
      {
         var manifest:Object = SasukeVfxManifest();
         for(var cinematic:String in manifest.cinematics)
         {
            LoadSasukeCinematic(cinematic,manifest.cinematics[cinematic]);
         }
         for each(var effect:String in ["ZuozhuZZZZ_haolonghuo","ZuozhuZZZZ_haolonghuoyan","ZuozhuZZZZ_qianniaodao3","ZuozhuZZZZ_qilin","ZuozhuZZZZ_qilin_texie","ZuozhuZZZZ_qilin_yan","ZuozhuZZZZ_qilin_yantexie","ZuozhuZZZZ_xuzuobati"])
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
      
      private static function SasukePinPages(previous:Array, current:Array) : void
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
      
      private static function PumpSasukeVfxQueue() : void
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
      
      private static function LoadSasukeVfxAtlas(name:String, meta:Object, urgent:Boolean = false, lead:int = 0) : void
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
      
      private static function TrimSasukeVfxCache(keep:String) : void
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
      
      private static function SasukeFirstAtlas(key:String) : Boolean
      {
         return SasukeVfxManifest().firstAtlases[key] === true;
      }
      
      private static function SasukeVfxManifest() : Object
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
      
      private static function LoadSasukeCinematic(name:String, meta:Object) : void
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
      
      private static function PreloadNagatoVfx() : void
      {
         var manifest:Object = NagatoVfxManifest();
         for each(var effect:String in ["QWCMaoyi","QWCMpg1","QWCMpg2","QWCMpg3","QWCMzhuida"])
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
                     LoadNagatoVfxAtlas(page,manifest.atlases[page]);
                  }
                  head++;
               }
            }
         }
      }
      
      private static function NagatoPinPages(previous:Array, current:Array) : void
      {
         var pins:Object = FNagatoFxLoading["_pins"];
         if(pins == null)
         {
            pins = {};
            FNagatoFxLoading["_pins"] = pins;
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
         var queue:Array = FNagatoFxLoading["_queue"] as Array;
         if(queue != null)
         {
            var i:int = queue.length - 1;
            while(i >= 0)
            {
               var queued:String = String(queue[i].name);
               if(int(pins[queued]) == 0 && !NagatoFirstAtlas(queued))
               {
                  queue.splice(i,1);
                  delete FNagatoFxLoading[queued];
               }
               i--;
            }
         }
      }
      
      private static function PumpNagatoVfxQueue() : void
      {
         var job:Object;
         var name:String;
         var meta:Object;
         var loader:URLLoader;
         var complete:Function;
         var failed:Function;
         var release:Function;
         var queue:Array = FNagatoFxLoading["_queue"] as Array;
         if(queue == null || queue.length == 0 || int(FNagatoFxLoading["_inflight"]) >= 6)
         {
            return;
         }
         queue.sortOn("deadline",Array.NUMERIC);
         job = queue.shift();
         name = String(job.name);
         meta = job.meta;
         FNagatoFxLoading["_inflight"] = int(FNagatoFxLoading["_inflight"]) + 1;
         loader = new URLLoader();
         loader.dataFormat = URLLoaderDataFormat.BINARY;
         release = function():void
         {
            loader.removeEventListener(Event.COMPLETE,complete);
            loader.removeEventListener(IOErrorEvent.IO_ERROR,failed);
            loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,failed);
            delete FNagatoFxLoading[name];
            FNagatoFxLoading["_inflight"] = Math.max(0,int(FNagatoFxLoading["_inflight"]) - 1);
            loader.data = null;
            PumpNagatoVfxQueue();
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
                  FNagatoFxCache[name] = frames;
                  TrimNagatoVfxCache(name);
               }
            }
            catch(error:Error)
            {
               if(data != null)
               {
                  data.clear();
               }
               if(source != null && FNagatoFxCache[name] == null)
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
         PumpNagatoVfxQueue();
      }
      
      private static function LoadNagatoVfxAtlas(name:String, meta:Object, urgent:Boolean = false, lead:int = 0) : void
      {
         if(meta == null)
         {
            return;
         }
         FNagatoFxLoading["_age_" + name] = getTimer();
         if(FNagatoFxCache[name] != null)
         {
            return;
         }
         var queue:Array = FNagatoFxLoading["_queue"] as Array;
         if(queue == null)
         {
            queue = [];
            FNagatoFxLoading["_queue"] = queue;
         }
         if(FNagatoFxLoading[name])
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
         FNagatoFxLoading[name] = true;
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
         PumpNagatoVfxQueue();
      }
      
      private static function TrimNagatoVfxCache(keep:String) : void
      {
         var pixels:Number = 0;
         var pins:Object = FNagatoFxLoading["_pins"];
         for(var key:String in FNagatoFxCache)
         {
            var frames:Array = FNagatoFxCache[key] as Array;
            if(frames != null && frames.length > 0)
            {
               pixels += BitmapData(frames[0]).width * BitmapData(frames[0]).height;
            }
         }
         while(pixels > 40000000)
         {
            var oldest:String = null;
            var age:Number = Number.MAX_VALUE;
            for(key in FNagatoFxCache)
            {
               if(key != keep && !NagatoFirstAtlas(key) && (pins == null || int(pins[key]) == 0) && Number(FNagatoFxLoading["_age_" + key]) < age)
               {
                  oldest = key;
                  age = Number(FNagatoFxLoading["_age_" + key]);
               }
            }
            if(oldest == null)
            {
               break;
            }
            frames = FNagatoFxCache[oldest] as Array;
            var atlas:BitmapData = BitmapData(frames[0]);
            pixels -= atlas.width * atlas.height;
            delete FNagatoFxCache[oldest];
            delete FNagatoFxLoading["_age_" + oldest];
            atlas.dispose();
         }
      }
      
      private static function NagatoFirstAtlas(key:String) : Boolean
      {
         return NagatoVfxManifest().firstAtlases[key] === true;
      }
      
      private static function NagatoVfxManifest() : Object
      {
         if(FNagatoFxLoading["_manifest"] != null)
         {
            return FNagatoFxLoading["_manifest"];
         }
         var manifest:Object = JSON.parse("{\"version\":6,\"frameMs\":40,\"frameRate\":25,\"atlases\":{\"QWCMpg1-165-pages-v3-0\":{\"url\":\"/public/nagato-vfx/extracted/QWCMpg1-165-pages-v3-0.png\",\"columns\":2,\"rows\":4,\"frameCount\":8},\"QWCMpg1-165-pages-v3-1\":{\"url\":\"/public/nagato-vfx/extracted/QWCMpg1-165-pages-v3-1.png\",\"columns\":2,\"rows\":4,\"frameCount\":8},\"QWCMpg1-165-pages-v3-2\":{\"url\":\"/public/nagato-vfx/extracted/QWCMpg1-165-pages-v3-2.png\",\"columns\":2,\"rows\":1,\"frameCount\":2},\"QWCMpg1-63-pages-v3-0\":{\"url\":\"/public/nagato-vfx/extracted/QWCMpg1-63-pages-v3-0.png\",\"columns\":5,\"rows\":4,\"frameCount\":16},\"QWCMpg2-215-pages-v3-0\":{\"url\":\"/public/nagato-vfx/extracted/QWCMpg2-215-pages-v3-0.png\",\"columns\":2,\"rows\":4,\"frameCount\":8},\"QWCMpg2-215-pages-v3-1\":{\"url\":\"/public/nagato-vfx/extracted/QWCMpg2-215-pages-v3-1.png\",\"columns\":2,\"rows\":4,\"frameCount\":8},\"QWCMpg2-215-pages-v3-2\":{\"url\":\"/public/nagato-vfx/extracted/QWCMpg2-215-pages-v3-2.png\",\"columns\":2,\"rows\":4,\"frameCount\":8},\"QWCMpg2-215-pages-v3-3\":{\"url\":\"/public/nagato-vfx/extracted/QWCMpg2-215-pages-v3-3.png\",\"columns\":2,\"rows\":4,\"frameCount\":8},\"QWCMpg2-215-pages-v3-4\":{\"url\":\"/public/nagato-vfx/extracted/QWCMpg2-215-pages-v3-4.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"QWCMpg2-63-pages-v3-0\":{\"url\":\"/public/nagato-vfx/extracted/QWCMpg2-63-pages-v3-0.png\",\"columns\":5,\"rows\":4,\"frameCount\":16},\"QWCMpg3-103-pages-v3-0\":{\"url\":\"/public/nagato-vfx/extracted/QWCMpg3-103-pages-v3-0.png\",\"columns\":3,\"rows\":8,\"frameCount\":24},\"QWCMpg3-103-pages-v3-1\":{\"url\":\"/public/nagato-vfx/extracted/QWCMpg3-103-pages-v3-1.png\",\"columns\":3,\"rows\":5,\"frameCount\":15},\"QWCMpg3-286-pages-v3-0\":{\"url\":\"/public/nagato-vfx/extracted/QWCMpg3-286-pages-v3-0.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"QWCMpg3-286-pages-v3-1\":{\"url\":\"/public/nagato-vfx/extracted/QWCMpg3-286-pages-v3-1.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"QWCMpg3-286-pages-v3-2\":{\"url\":\"/public/nagato-vfx/extracted/QWCMpg3-286-pages-v3-2.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"QWCMpg3-286-pages-v3-3\":{\"url\":\"/public/nagato-vfx/extracted/QWCMpg3-286-pages-v3-3.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"QWCMpg3-286-pages-v3-4\":{\"url\":\"/public/nagato-vfx/extracted/QWCMpg3-286-pages-v3-4.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"QWCMpg3-286-pages-v3-5\":{\"url\":\"/public/nagato-vfx/extracted/QWCMpg3-286-pages-v3-5.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"QWCMpg3-286-pages-v3-6\":{\"url\":\"/public/nagato-vfx/extracted/QWCMpg3-286-pages-v3-6.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"QWCMpg3-286-pages-v3-7\":{\"url\":\"/public/nagato-vfx/extracted/QWCMpg3-286-pages-v3-7.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"QWCMpg3-286-pages-v3-8\":{\"url\":\"/public/nagato-vfx/extracted/QWCMpg3-286-pages-v3-8.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"QWCMzhuida-15-pages-v3-0\":{\"url\":\"/public/nagato-vfx/extracted/QWCMzhuida-15-pages-v3-0.png\",\"columns\":6,\"rows\":2,\"frameCount\":8},\"QWCMzhuida-163-pages-v3-0\":{\"url\":\"/public/nagato-vfx/extracted/QWCMzhuida-163-pages-v3-0.png\",\"columns\":5,\"rows\":5,\"frameCount\":22},\"QWCMaoyi-140-large-v2-0\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-140-large-v2-0.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"QWCMaoyi-140-large-v2-1\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-140-large-v2-1.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"QWCMaoyi-140-large-v2-2\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-140-large-v2-2.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"QWCMaoyi-140-large-v2-3\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-140-large-v2-3.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"QWCMaoyi-140-large-v2-4\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-140-large-v2-4.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"QWCMaoyi-140-large-v2-5\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-140-large-v2-5.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"QWCMaoyi-140-large-v2-6\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-140-large-v2-6.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"QWCMaoyi-140-large-v2-7\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-140-large-v2-7.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"QWCMaoyi-140-large-v2-8\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-140-large-v2-8.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"QWCMaoyi-140-large-v2-9\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-140-large-v2-9.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"QWCMaoyi-140-large-v2-10\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-140-large-v2-10.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"QWCMaoyi-140-large-v2-11\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-140-large-v2-11.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"QWCMaoyi-140-large-v2-12\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-140-large-v2-12.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"QWCMaoyi-140-large-v2-13\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-140-large-v2-13.png\",\"columns\":1,\"rows\":3,\"frameCount\":3},\"QWCMaoyi-140-large-v2-14\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-140-large-v2-14.png\",\"columns\":1,\"rows\":1,\"frameCount\":1},\"QWCMaoyi-337-large-v2-0\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-337-large-v2-0.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"QWCMaoyi-337-large-v2-1\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-337-large-v2-1.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"QWCMaoyi-337-large-v2-2\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-337-large-v2-2.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"QWCMaoyi-337-large-v2-3\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-337-large-v2-3.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"QWCMaoyi-337-large-v2-4\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-337-large-v2-4.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"QWCMaoyi-337-large-v2-5\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-337-large-v2-5.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"QWCMaoyi-337-large-v2-6\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-337-large-v2-6.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"QWCMaoyi-337-large-v2-7\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-337-large-v2-7.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"QWCMaoyi-337-large-v2-8\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-337-large-v2-8.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"QWCMaoyi-337-large-v2-9\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-337-large-v2-9.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"QWCMaoyi-337-large-v2-10\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-337-large-v2-10.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"QWCMaoyi-337-large-v2-11\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-337-large-v2-11.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"QWCMaoyi-337-large-v2-12\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-337-large-v2-12.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"QWCMaoyi-337-large-v2-13\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-337-large-v2-13.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"QWCMaoyi-337-large-v2-14\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-337-large-v2-14.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"QWCMaoyi-337-large-v2-15\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-337-large-v2-15.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"QWCMaoyi-337-large-v2-16\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-337-large-v2-16.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"QWCMaoyi-337-large-v2-17\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-337-large-v2-17.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"QWCMaoyi-337-large-v2-18\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-337-large-v2-18.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"QWCMaoyi-337-large-v2-19\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-337-large-v2-19.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"QWCMaoyi-337-large-v2-20\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-337-large-v2-20.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"QWCMaoyi-337-large-v2-21\":{\"url\":\"/public/nagato-vfx/extracted/QWCMaoyi-337-large-v2-21.png\",\"columns\":1,\"rows\":2,\"frameCount\":2}},\"clips\":{\"QWCMpg1-165\":{\"atlas\":\"QWCMpg1-165-pages-v3-0\",\"frameAtlases\":[\"QWCMpg1-165-pages-v3-0\",\"QWCMpg1-165-pages-v3-0\",\"QWCMpg1-165-pages-v3-0\",\"QWCMpg1-165-pages-v3-0\",\"QWCMpg1-165-pages-v3-0\",\"QWCMpg1-165-pages-v3-0\",\"QWCMpg1-165-pages-v3-0\",\"QWCMpg1-165-pages-v3-0\",\"QWCMpg1-165-pages-v3-0\",\"QWCMpg1-165-pages-v3-0\",\"QWCMpg1-165-pages-v3-0\",\"QWCMpg1-165-pages-v3-0\",\"QWCMpg1-165-pages-v3-0\",\"QWCMpg1-165-pages-v3-0\",\"QWCMpg1-165-pages-v3-0\",\"QWCMpg1-165-pages-v3-0\",\"QWCMpg1-165-pages-v3-0\",\"QWCMpg1-165-pages-v3-0\",\"QWCMpg1-165-pages-v3-0\",\"QWCMpg1-165-pages-v3-0\",\"QWCMpg1-165-pages-v3-1\",\"QWCMpg1-165-pages-v3-1\",\"QWCMpg1-165-pages-v3-1\",\"QWCMpg1-165-pages-v3-1\",\"QWCMpg1-165-pages-v3-1\",\"QWCMpg1-165-pages-v3-1\",\"QWCMpg1-165-pages-v3-1\",\"QWCMpg1-165-pages-v3-1\",\"QWCMpg1-165-pages-v3-2\",\"QWCMpg1-165-pages-v3-2\",\"QWCMpg1-165-pages-v3-0\",\"QWCMpg1-165-pages-v3-0\",\"QWCMpg1-165-pages-v3-0\",\"QWCMpg1-165-pages-v3-0\",\"QWCMpg1-165-pages-v3-0\",\"QWCMpg1-165-pages-v3-0\",\"QWCMpg1-165-pages-v3-0\",\"QWCMpg1-165-pages-v3-0\",\"QWCMpg1-165-pages-v3-0\",\"QWCMpg1-165-pages-v3-0\",\"QWCMpg1-165-pages-v3-0\",\"QWCMpg1-165-pages-v3-0\",\"QWCMpg1-165-pages-v3-0\",\"QWCMpg1-165-pages-v3-0\",\"QWCMpg1-165-pages-v3-0\",\"QWCMpg1-165-pages-v3-0\",\"QWCMpg1-165-pages-v3-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,1,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],\"width\":710,\"height\":444,\"pivot\":[0.19193309859154933,0.6569876126126126],\"renderScale\":0.85,\"sourceFrames\":45,\"sourceCrop\":[122,48,832,492],\"sourceZoom\":0.85},\"QWCMpg1-63\":{\"atlas\":\"QWCMpg1-63-pages-v3-0\",\"frameAtlases\":[\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\",\"QWCMpg1-63-pages-v3-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],\"width\":362,\"height\":98,\"pivot\":[0.061367403314917135,0.8076785714285715],\"renderScale\":0.85,\"sourceFrames\":45,\"sourceCrop\":[78,20,440,118],\"sourceZoom\":0.85},\"QWCMpg2-215\":{\"atlas\":\"QWCMpg2-215-pages-v3-0\",\"frameAtlases\":[\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-1\",\"QWCMpg2-215-pages-v3-1\",\"QWCMpg2-215-pages-v3-1\",\"QWCMpg2-215-pages-v3-1\",\"QWCMpg2-215-pages-v3-1\",\"QWCMpg2-215-pages-v3-1\",\"QWCMpg2-215-pages-v3-1\",\"QWCMpg2-215-pages-v3-1\",\"QWCMpg2-215-pages-v3-2\",\"QWCMpg2-215-pages-v3-2\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-2\",\"QWCMpg2-215-pages-v3-2\",\"QWCMpg2-215-pages-v3-2\",\"QWCMpg2-215-pages-v3-2\",\"QWCMpg2-215-pages-v3-2\",\"QWCMpg2-215-pages-v3-2\",\"QWCMpg2-215-pages-v3-3\",\"QWCMpg2-215-pages-v3-3\",\"QWCMpg2-215-pages-v3-3\",\"QWCMpg2-215-pages-v3-3\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-3\",\"QWCMpg2-215-pages-v3-3\",\"QWCMpg2-215-pages-v3-3\",\"QWCMpg2-215-pages-v3-3\",\"QWCMpg2-215-pages-v3-3\",\"QWCMpg2-215-pages-v3-4\",\"QWCMpg2-215-pages-v3-4\",\"QWCMpg2-215-pages-v3-4\",\"QWCMpg2-215-pages-v3-4\",\"QWCMpg2-215-pages-v3-4\",\"QWCMpg2-215-pages-v3-4\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\",\"QWCMpg2-215-pages-v3-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,1,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,3,4,5,6,7,0,1,2,3,0,0,4,5,6,6,7,0,1,2,3,4,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],\"width\":710,\"height\":444,\"pivot\":[0.1917218309859155,0.6559346846846847],\"renderScale\":0.85,\"sourceFrames\":82,\"sourceCrop\":[191,133,901,577],\"sourceZoom\":0.85},\"QWCMpg2-63\":{\"atlas\":\"QWCMpg2-63-pages-v3-0\",\"frameAtlases\":[\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\",\"QWCMpg2-63-pages-v3-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],\"width\":362,\"height\":98,\"pivot\":[0.061367403314917135,0.8076785714285715],\"renderScale\":0.85,\"sourceFrames\":82,\"sourceCrop\":[78,20,440,118],\"sourceZoom\":0.85},\"QWCMpg3-103\":{\"atlas\":\"QWCMpg3-103-pages-v3-0\",\"frameAtlases\":[\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-1\",\"QWCMpg3-103-pages-v3-1\",\"QWCMpg3-103-pages-v3-1\",\"QWCMpg3-103-pages-v3-1\",\"QWCMpg3-103-pages-v3-1\",\"QWCMpg3-103-pages-v3-1\",\"QWCMpg3-103-pages-v3-1\",\"QWCMpg3-103-pages-v3-1\",\"QWCMpg3-103-pages-v3-1\",\"QWCMpg3-103-pages-v3-1\",\"QWCMpg3-103-pages-v3-1\",\"QWCMpg3-103-pages-v3-1\",\"QWCMpg3-103-pages-v3-1\",\"QWCMpg3-103-pages-v3-1\",\"QWCMpg3-103-pages-v3-1\",\"QWCMpg3-103-pages-v3-1\",\"QWCMpg3-103-pages-v3-1\",\"QWCMpg3-103-pages-v3-1\",\"QWCMpg3-103-pages-v3-1\",\"QWCMpg3-103-pages-v3-1\",\"QWCMpg3-103-pages-v3-1\",\"QWCMpg3-103-pages-v3-1\",\"QWCMpg3-103-pages-v3-1\",\"QWCMpg3-103-pages-v3-1\",\"QWCMpg3-103-pages-v3-1\",\"QWCMpg3-103-pages-v3-1\",\"QWCMpg3-103-pages-v3-1\",\"QWCMpg3-103-pages-v3-1\",\"QWCMpg3-103-pages-v3-1\",\"QWCMpg3-103-pages-v3-1\",\"QWCMpg3-103-pages-v3-1\",\"QWCMpg3-103-pages-v3-1\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\",\"QWCMpg3-103-pages-v3-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,12,13,13,14,14,0,0,0,0,0,0,0,0,0,0],\"width\":557,\"height\":240,\"pivot\":[0.04167863554757631,0.6152604166666666],\"renderScale\":0.85,\"sourceFrames\":123,\"sourceCrop\":[77,88,634,328],\"sourceZoom\":0.85},\"QWCMpg3-286\":{\"atlas\":\"QWCMpg3-286-pages-v3-0\",\"frameAtlases\":[\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-1\",\"QWCMpg3-286-pages-v3-1\",\"QWCMpg3-286-pages-v3-1\",\"QWCMpg3-286-pages-v3-1\",\"QWCMpg3-286-pages-v3-1\",\"QWCMpg3-286-pages-v3-1\",\"QWCMpg3-286-pages-v3-2\",\"QWCMpg3-286-pages-v3-2\",\"QWCMpg3-286-pages-v3-2\",\"QWCMpg3-286-pages-v3-2\",\"QWCMpg3-286-pages-v3-2\",\"QWCMpg3-286-pages-v3-2\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-3\",\"QWCMpg3-286-pages-v3-3\",\"QWCMpg3-286-pages-v3-3\",\"QWCMpg3-286-pages-v3-3\",\"QWCMpg3-286-pages-v3-3\",\"QWCMpg3-286-pages-v3-3\",\"QWCMpg3-286-pages-v3-4\",\"QWCMpg3-286-pages-v3-4\",\"QWCMpg3-286-pages-v3-4\",\"QWCMpg3-286-pages-v3-4\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-4\",\"QWCMpg3-286-pages-v3-4\",\"QWCMpg3-286-pages-v3-5\",\"QWCMpg3-286-pages-v3-5\",\"QWCMpg3-286-pages-v3-5\",\"QWCMpg3-286-pages-v3-5\",\"QWCMpg3-286-pages-v3-5\",\"QWCMpg3-286-pages-v3-5\",\"QWCMpg3-286-pages-v3-5\",\"QWCMpg3-286-pages-v3-6\",\"QWCMpg3-286-pages-v3-6\",\"QWCMpg3-286-pages-v3-6\",\"QWCMpg3-286-pages-v3-6\",\"QWCMpg3-286-pages-v3-6\",\"QWCMpg3-286-pages-v3-6\",\"QWCMpg3-286-pages-v3-7\",\"QWCMpg3-286-pages-v3-7\",\"QWCMpg3-286-pages-v3-7\",\"QWCMpg3-286-pages-v3-7\",\"QWCMpg3-286-pages-v3-7\",\"QWCMpg3-286-pages-v3-7\",\"QWCMpg3-286-pages-v3-8\",\"QWCMpg3-286-pages-v3-8\",\"QWCMpg3-286-pages-v3-8\",\"QWCMpg3-286-pages-v3-8\",\"QWCMpg3-286-pages-v3-8\",\"QWCMpg3-286-pages-v3-8\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\",\"QWCMpg3-286-pages-v3-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,1,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,4,5,0,1,2,3,0,0,4,5,0,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],\"width\":710,\"height\":528,\"pivot\":[0.1917218309859155,0.7118087121212122],\"renderScale\":0.85,\"sourceFrames\":123,\"sourceCrop\":[191,232,901,760],\"sourceZoom\":0.85},\"QWCMzhuida-15\":{\"atlas\":\"QWCMzhuida-15-pages-v3-0\",\"frameAtlases\":[\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\",\"QWCMzhuida-15-pages-v3-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0],\"width\":324,\"height\":113,\"pivot\":[-0.06855709876543209,0.3843584070796461],\"renderScale\":0.85,\"sourceFrames\":45,\"sourceCrop\":[5,2,329,115],\"sourceZoom\":0.85},\"QWCMzhuida-163\":{\"atlas\":\"QWCMzhuida-163-pages-v3-0\",\"frameAtlases\":[\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\",\"QWCMzhuida-163-pages-v3-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,17,18,18,18,19,19,20,20,21,21,0],\"width\":408,\"height\":342,\"pivot\":[0.0967095588235294,0.720906432748538],\"renderScale\":0.85,\"sourceFrames\":45,\"sourceCrop\":[54,45,462,387],\"sourceZoom\":0.85},\"QWCMaoyi-140\":{\"atlas\":\"QWCMaoyi-140-large-v2-0\",\"frameAtlases\":[\"QWCMaoyi-140-large-v2-0\",\"QWCMaoyi-140-large-v2-0\",\"QWCMaoyi-140-large-v2-0\",\"QWCMaoyi-140-large-v2-0\",\"QWCMaoyi-140-large-v2-0\",\"QWCMaoyi-140-large-v2-0\",\"QWCMaoyi-140-large-v2-0\",\"QWCMaoyi-140-large-v2-0\",\"QWCMaoyi-140-large-v2-0\",\"QWCMaoyi-140-large-v2-0\",\"QWCMaoyi-140-large-v2-0\",\"QWCMaoyi-140-large-v2-0\",\"QWCMaoyi-140-large-v2-0\",\"QWCMaoyi-140-large-v2-0\",\"QWCMaoyi-140-large-v2-0\",\"QWCMaoyi-140-large-v2-0\",\"QWCMaoyi-140-large-v2-0\",\"QWCMaoyi-140-large-v2-0\",\"QWCMaoyi-140-large-v2-0\",\"QWCMaoyi-140-large-v2-0\",\"QWCMaoyi-140-large-v2-0\",\"QWCMaoyi-140-large-v2-0\",\"QWCMaoyi-140-large-v2-0\",\"QWCMaoyi-140-large-v2-1\",\"QWCMaoyi-140-large-v2-1\",\"QWCMaoyi-140-large-v2-1\",\"QWCMaoyi-140-large-v2-2\",\"QWCMaoyi-140-large-v2-2\",\"QWCMaoyi-140-large-v2-2\",\"QWCMaoyi-140-large-v2-3\",\"QWCMaoyi-140-large-v2-3\",\"QWCMaoyi-140-large-v2-3\",\"QWCMaoyi-140-large-v2-4\",\"QWCMaoyi-140-large-v2-4\",\"QWCMaoyi-140-large-v2-4\",\"QWCMaoyi-140-large-v2-5\",\"QWCMaoyi-140-large-v2-5\",\"QWCMaoyi-140-large-v2-5\",\"QWCMaoyi-140-large-v2-5\",\"QWCMaoyi-140-large-v2-6\",\"QWCMaoyi-140-large-v2-6\",\"QWCMaoyi-140-large-v2-6\",\"QWCMaoyi-140-large-v2-7\",\"QWCMaoyi-140-large-v2-7\",\"QWCMaoyi-140-large-v2-7\",\"QWCMaoyi-140-large-v2-8\",\"QWCMaoyi-140-large-v2-8\",\"QWCMaoyi-140-large-v2-8\",\"QWCMaoyi-140-large-v2-9\",\"QWCMaoyi-140-large-v2-9\",\"QWCMaoyi-140-large-v2-9\",\"QWCMaoyi-140-large-v2-10\",\"QWCMaoyi-140-large-v2-10\",\"QWCMaoyi-140-large-v2-10\",\"QWCMaoyi-140-large-v2-11\",\"QWCMaoyi-140-large-v2-11\",\"QWCMaoyi-140-large-v2-11\",\"QWCMaoyi-140-large-v2-12\",\"QWCMaoyi-140-large-v2-12\",\"QWCMaoyi-140-large-v2-12\",\"QWCMaoyi-140-large-v2-13\",\"QWCMaoyi-140-large-v2-13\",\"QWCMaoyi-140-large-v2-13\",\"QWCMaoyi-140-large-v2-13\",\"QWCMaoyi-140-large-v2-14\",\"QWCMaoyi-140-large-v2-14\",\"QWCMaoyi-140-large-v2-0\",\"QWCMaoyi-140-large-v2-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,2,0,0,0,0],\"width\":2048,\"height\":595,\"pivot\":[0.5024287222808871,0.6496062992125984],\"renderScale\":0.7208729320661739,\"sourceFrames\":65,\"sourceCrop\":[358,88,6040,1739],\"sourceZoom\":2},\"QWCMaoyi-337\":{\"atlas\":\"QWCMaoyi-337-large-v2-0\",\"frameAtlases\":[\"QWCMaoyi-337-large-v2-0\",\"QWCMaoyi-337-large-v2-0\",\"QWCMaoyi-337-large-v2-0\",\"QWCMaoyi-337-large-v2-0\",\"QWCMaoyi-337-large-v2-0\",\"QWCMaoyi-337-large-v2-0\",\"QWCMaoyi-337-large-v2-0\",\"QWCMaoyi-337-large-v2-0\",\"QWCMaoyi-337-large-v2-0\",\"QWCMaoyi-337-large-v2-0\",\"QWCMaoyi-337-large-v2-0\",\"QWCMaoyi-337-large-v2-0\",\"QWCMaoyi-337-large-v2-0\",\"QWCMaoyi-337-large-v2-0\",\"QWCMaoyi-337-large-v2-0\",\"QWCMaoyi-337-large-v2-0\",\"QWCMaoyi-337-large-v2-0\",\"QWCMaoyi-337-large-v2-0\",\"QWCMaoyi-337-large-v2-0\",\"QWCMaoyi-337-large-v2-0\",\"QWCMaoyi-337-large-v2-0\",\"QWCMaoyi-337-large-v2-1\",\"QWCMaoyi-337-large-v2-1\",\"QWCMaoyi-337-large-v2-2\",\"QWCMaoyi-337-large-v2-2\",\"QWCMaoyi-337-large-v2-3\",\"QWCMaoyi-337-large-v2-3\",\"QWCMaoyi-337-large-v2-4\",\"QWCMaoyi-337-large-v2-4\",\"QWCMaoyi-337-large-v2-5\",\"QWCMaoyi-337-large-v2-5\",\"QWCMaoyi-337-large-v2-6\",\"QWCMaoyi-337-large-v2-6\",\"QWCMaoyi-337-large-v2-7\",\"QWCMaoyi-337-large-v2-7\",\"QWCMaoyi-337-large-v2-8\",\"QWCMaoyi-337-large-v2-8\",\"QWCMaoyi-337-large-v2-9\",\"QWCMaoyi-337-large-v2-9\",\"QWCMaoyi-337-large-v2-9\",\"QWCMaoyi-337-large-v2-10\",\"QWCMaoyi-337-large-v2-10\",\"QWCMaoyi-337-large-v2-11\",\"QWCMaoyi-337-large-v2-11\",\"QWCMaoyi-337-large-v2-12\",\"QWCMaoyi-337-large-v2-12\",\"QWCMaoyi-337-large-v2-13\",\"QWCMaoyi-337-large-v2-13\",\"QWCMaoyi-337-large-v2-14\",\"QWCMaoyi-337-large-v2-14\",\"QWCMaoyi-337-large-v2-15\",\"QWCMaoyi-337-large-v2-15\",\"QWCMaoyi-337-large-v2-16\",\"QWCMaoyi-337-large-v2-16\",\"QWCMaoyi-337-large-v2-17\",\"QWCMaoyi-337-large-v2-17\",\"QWCMaoyi-337-large-v2-18\",\"QWCMaoyi-337-large-v2-18\",\"QWCMaoyi-337-large-v2-19\",\"QWCMaoyi-337-large-v2-19\",\"QWCMaoyi-337-large-v2-20\",\"QWCMaoyi-337-large-v2-20\",\"QWCMaoyi-337-large-v2-21\",\"QWCMaoyi-337-large-v2-21\",\"QWCMaoyi-337-large-v2-21\",\"QWCMaoyi-337-large-v2-21\",\"QWCMaoyi-337-large-v2-0\",\"QWCMaoyi-337-large-v2-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,1,1,0,0],\"width\":2048,\"height\":698,\"pivot\":[0.26399557888919595,0.6299270072992701],\"renderScale\":1.131804365846919,\"sourceFrames\":65,\"sourceCrop\":[74,170,3693,1403],\"sourceZoom\":2}},\"effects\":{\"QWCMaoyi\":[\"QWCMaoyi-140\",\"QWCMaoyi-337\"],\"QWCMpg1\":[\"QWCMpg1-165\",\"QWCMpg1-63\"],\"QWCMpg2\":[\"QWCMpg2-215\",\"QWCMpg2-63\"],\"QWCMpg3\":[\"QWCMpg3-103\",\"QWCMpg3-286\"],\"QWCMzhuida\":[\"QWCMzhuida-15\",\"QWCMzhuida-163\"]},\"moves\":{\"13121401\":\"mystery\",\"13121402\":\"standard\",\"13121403\":\"chase\",\"13121406\":\"standard2\",\"13121407\":\"combo\"},\"actions\":{\"standard\":[\"QWCMpg1\"],\"standard2\":[\"QWCMpg2\"],\"combo\":[\"QWCMpg3\"],\"mystery\":[\"QWCMaoyi\"],\"chase\":[\"QWCMzhuida\"]}}");
         manifest.firstAtlases = {};
         manifest.poseTiming = JSON.parse("{\"13121401\":{\"end\":68,\"distance\":300},\"13121402\":{\"end\":47,\"distance\":360},\"13121403\":{\"end\":47,\"distance\":240},\"13121406\":{\"end\":86,\"distance\":360},\"13121407\":{\"end\":129,\"distance\":360}}");
         for(var name:String in manifest.clips)
         {
            var clip:Object = manifest.clips[name];
            if(clip.width * clip.height < 150000 && (name.indexOf("Yafenshen") >= 0 || name.indexOf("Huanshuxielunyan-") >= 0))
            {
               manifest.firstAtlases[clip.atlas] = true;
            }
            clip.nextAtlases = [];
            var next:String = null;
            var i:int = clip.frameAtlases.length - 1;
            while(i >= 0)
            {
               if(i + 1 < clip.frameAtlases.length && String(clip.frameAtlases[i]) != String(clip.frameAtlases[i + 1]))
               {
                  next = String(clip.frameAtlases[i + 1]);
               }
               clip.nextAtlases[i] = next;
               i--;
            }
            clip.aheadPages = [];
            var tick:int = 0;
            while(tick < clip.timeline.length)
            {
               var pages:Array = [];
               var seen:Object = {};
               var j:int = tick;
               while(j < Math.min(tick + 21,clip.timeline.length))
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
         FNagatoFxLoading["_manifest"] = manifest;
         return manifest;
      }
      
      private static function PreloadGaaraVfx() : void
      {
         var manifest:Object = GaaraVfxManifest();
         for each(var effect:String in ["Yzwoailuo_aoyi","Yzwoailuo_beidong2","Yzwoailuo_pugong"])
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
                     LoadGaaraVfxAtlas(page,manifest.atlases[page]);
                  }
                  head++;
               }
            }
         }
      }
      
      private static function GaaraPinPages(previous:Array, current:Array) : void
      {
         var pins:Object = FGaaraFxLoading["_pins"];
         if(pins == null)
         {
            pins = {};
            FGaaraFxLoading["_pins"] = pins;
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
         var queue:Array = FGaaraFxLoading["_queue"] as Array;
         if(queue != null)
         {
            var i:int = queue.length - 1;
            while(i >= 0)
            {
               var queued:String = String(queue[i].name);
               if(int(pins[queued]) == 0 && !GaaraFirstAtlas(queued))
               {
                  queue.splice(i,1);
                  delete FGaaraFxLoading[queued];
               }
               i--;
            }
         }
      }
      
      private static function PumpGaaraVfxQueue() : void
      {
         var job:Object;
         var name:String;
         var meta:Object;
         var loader:URLLoader;
         var complete:Function;
         var failed:Function;
         var release:Function;
         var queue:Array = FGaaraFxLoading["_queue"] as Array;
         if(queue == null || queue.length == 0 || int(FGaaraFxLoading["_inflight"]) >= 6)
         {
            return;
         }
         queue.sortOn("deadline",Array.NUMERIC);
         job = queue.shift();
         name = String(job.name);
         meta = job.meta;
         FGaaraFxLoading["_inflight"] = int(FGaaraFxLoading["_inflight"]) + 1;
         loader = new URLLoader();
         loader.dataFormat = URLLoaderDataFormat.BINARY;
         release = function():void
         {
            loader.removeEventListener(Event.COMPLETE,complete);
            loader.removeEventListener(IOErrorEvent.IO_ERROR,failed);
            loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,failed);
            delete FGaaraFxLoading[name];
            FGaaraFxLoading["_inflight"] = Math.max(0,int(FGaaraFxLoading["_inflight"]) - 1);
            loader.data = null;
            PumpGaaraVfxQueue();
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
                  FGaaraFxCache[name] = frames;
                  TrimGaaraVfxCache(name);
               }
            }
            catch(error:Error)
            {
               if(data != null)
               {
                  data.clear();
               }
               if(source != null && FGaaraFxCache[name] == null)
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
         PumpGaaraVfxQueue();
      }
      
      private static function LoadGaaraVfxAtlas(name:String, meta:Object, urgent:Boolean = false, lead:int = 0) : void
      {
         if(meta == null)
         {
            return;
         }
         FGaaraFxLoading["_age_" + name] = getTimer();
         if(FGaaraFxCache[name] != null)
         {
            return;
         }
         var queue:Array = FGaaraFxLoading["_queue"] as Array;
         if(queue == null)
         {
            queue = [];
            FGaaraFxLoading["_queue"] = queue;
         }
         if(FGaaraFxLoading[name])
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
         FGaaraFxLoading[name] = true;
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
         PumpGaaraVfxQueue();
      }
      
      private static function TrimGaaraVfxCache(keep:String) : void
      {
         var pixels:Number = 0;
         var pins:Object = FGaaraFxLoading["_pins"];
         for(var key:String in FGaaraFxCache)
         {
            var frames:Array = FGaaraFxCache[key] as Array;
            if(frames != null && frames.length > 0)
            {
               pixels += BitmapData(frames[0]).width * BitmapData(frames[0]).height;
            }
         }
         while(pixels > 40000000)
         {
            var oldest:String = null;
            var age:Number = Number.MAX_VALUE;
            for(key in FGaaraFxCache)
            {
               if(key != keep && !GaaraFirstAtlas(key) && (pins == null || int(pins[key]) == 0) && Number(FGaaraFxLoading["_age_" + key]) < age)
               {
                  oldest = key;
                  age = Number(FGaaraFxLoading["_age_" + key]);
               }
            }
            if(oldest == null)
            {
               break;
            }
            frames = FGaaraFxCache[oldest] as Array;
            var atlas:BitmapData = BitmapData(frames[0]);
            pixels -= atlas.width * atlas.height;
            delete FGaaraFxCache[oldest];
            delete FGaaraFxLoading["_age_" + oldest];
            atlas.dispose();
         }
      }
      
      private static function GaaraFirstAtlas(key:String) : Boolean
      {
         return GaaraVfxManifest().firstAtlases[key] === true;
      }
      
      private static function GaaraVfxManifest() : Object
      {
         if(FGaaraFxLoading["_manifest"] != null)
         {
            return FGaaraFxLoading["_manifest"];
         }
         var manifest:Object = JSON.parse("{\"version\":6,\"frameMs\":40,\"frameRate\":25,\"atlases\":{\"Yzwoailuo_aoyi-159-pages-v3-0\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-159-pages-v3-0.png\",\"columns\":2,\"rows\":4,\"frameCount\":8},\"Yzwoailuo_aoyi-159-pages-v3-1\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-159-pages-v3-1.png\",\"columns\":2,\"rows\":4,\"frameCount\":8},\"Yzwoailuo_aoyi-159-pages-v3-2\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-159-pages-v3-2.png\",\"columns\":2,\"rows\":4,\"frameCount\":8},\"Yzwoailuo_aoyi-159-pages-v3-3\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-159-pages-v3-3.png\",\"columns\":2,\"rows\":4,\"frameCount\":8},\"Yzwoailuo_aoyi-159-pages-v3-4\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-159-pages-v3-4.png\",\"columns\":2,\"rows\":4,\"frameCount\":8},\"Yzwoailuo_aoyi-159-pages-v3-5\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-159-pages-v3-5.png\",\"columns\":2,\"rows\":4,\"frameCount\":8},\"Yzwoailuo_aoyi-159-pages-v3-6\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-159-pages-v3-6.png\",\"columns\":2,\"rows\":4,\"frameCount\":8},\"Yzwoailuo_aoyi-159-pages-v3-7\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-159-pages-v3-7.png\",\"columns\":2,\"rows\":4,\"frameCount\":8},\"Yzwoailuo_aoyi-159-pages-v3-8\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-159-pages-v3-8.png\",\"columns\":2,\"rows\":4,\"frameCount\":8},\"Yzwoailuo_aoyi-159-pages-v3-9\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-159-pages-v3-9.png\",\"columns\":2,\"rows\":4,\"frameCount\":7},\"Yzwoailuo_aoyi-432-pages-v3-0\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-0.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-1\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-1.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-2\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-2.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-3\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-3.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-4\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-4.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-5\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-5.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-6\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-6.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-7\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-7.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-8\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-8.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-9\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-9.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-10\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-10.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-11\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-11.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-12\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-12.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-13\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-13.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-14\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-14.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-15\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-15.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-16\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-16.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-17\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-17.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-18\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-18.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-19\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-19.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-20\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-20.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-21\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-21.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-22\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-22.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-23\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-23.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-24\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-24.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-25\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-25.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-26\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-26.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-27\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-27.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-28\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-28.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-29\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-29.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-30\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-30.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-31\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-31.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-32\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-32.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-33\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-33.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-34\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-34.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-35\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-35.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-36\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-36.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-37\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-37.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-38\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-38.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-39\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-39.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-40\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-40.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-41\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-41.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-42\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-42.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-43\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-43.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-44\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-44.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-45\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-45.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-46\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-46.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_aoyi-432-pages-v3-47\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_aoyi-432-pages-v3-47.png\",\"columns\":1,\"rows\":1,\"frameCount\":1},\"Yzwoailuo_pugong-424-pages-v3-0\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_pugong-424-pages-v3-0.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_pugong-424-pages-v3-1\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_pugong-424-pages-v3-1.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_pugong-424-pages-v3-2\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_pugong-424-pages-v3-2.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_pugong-424-pages-v3-3\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_pugong-424-pages-v3-3.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_pugong-424-pages-v3-4\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_pugong-424-pages-v3-4.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_pugong-424-pages-v3-5\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_pugong-424-pages-v3-5.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_pugong-424-pages-v3-6\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_pugong-424-pages-v3-6.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_pugong-424-pages-v3-7\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_pugong-424-pages-v3-7.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_pugong-424-pages-v3-8\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_pugong-424-pages-v3-8.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_pugong-424-pages-v3-9\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_pugong-424-pages-v3-9.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_pugong-424-pages-v3-10\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_pugong-424-pages-v3-10.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_pugong-424-pages-v3-11\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_pugong-424-pages-v3-11.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_pugong-424-pages-v3-12\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_pugong-424-pages-v3-12.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_pugong-424-pages-v3-13\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_pugong-424-pages-v3-13.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_pugong-424-pages-v3-14\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_pugong-424-pages-v3-14.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_pugong-424-pages-v3-15\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_pugong-424-pages-v3-15.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_pugong-424-pages-v3-16\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_pugong-424-pages-v3-16.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_pugong-424-pages-v3-17\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_pugong-424-pages-v3-17.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_pugong-424-pages-v3-18\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_pugong-424-pages-v3-18.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_pugong-424-pages-v3-19\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_pugong-424-pages-v3-19.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_pugong-424-pages-v3-20\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_pugong-424-pages-v3-20.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_pugong-424-pages-v3-21\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_pugong-424-pages-v3-21.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_pugong-424-pages-v3-22\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_pugong-424-pages-v3-22.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_pugong-424-pages-v3-23\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_pugong-424-pages-v3-23.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_pugong-424-pages-v3-24\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_pugong-424-pages-v3-24.png\",\"columns\":1,\"rows\":2,\"frameCount\":2},\"Yzwoailuo_pugong-424-pages-v3-25\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_pugong-424-pages-v3-25.png\",\"columns\":1,\"rows\":1,\"frameCount\":1},\"Yzwoailuo_pugong-81-pages-v3-0\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_pugong-81-pages-v3-0.png\",\"columns\":3,\"rows\":8,\"frameCount\":24},\"Yzwoailuo_pugong-81-pages-v3-1\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_pugong-81-pages-v3-1.png\",\"columns\":3,\"rows\":6,\"frameCount\":18},\"Yzwoailuo_beidong2-124-pages-v3-0\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_beidong2-124-pages-v3-0.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Yzwoailuo_beidong2-124-pages-v3-1\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_beidong2-124-pages-v3-1.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Yzwoailuo_beidong2-124-pages-v3-2\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_beidong2-124-pages-v3-2.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Yzwoailuo_beidong2-124-pages-v3-3\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_beidong2-124-pages-v3-3.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Yzwoailuo_beidong2-124-pages-v3-4\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_beidong2-124-pages-v3-4.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Yzwoailuo_beidong2-124-pages-v3-5\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_beidong2-124-pages-v3-5.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Yzwoailuo_beidong2-124-pages-v3-6\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_beidong2-124-pages-v3-6.png\",\"columns\":2,\"rows\":1,\"frameCount\":2},\"Yzwoailuo_beidong2-38-pages-v3-0\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_beidong2-38-pages-v3-0.png\",\"columns\":2,\"rows\":6,\"frameCount\":12},\"Yzwoailuo_beidong2-38-pages-v3-1\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_beidong2-38-pages-v3-1.png\",\"columns\":2,\"rows\":6,\"frameCount\":12},\"Yzwoailuo_beidong2-38-pages-v3-2\":{\"url\":\"/public/gaara-vfx/extracted/Yzwoailuo_beidong2-38-pages-v3-2.png\",\"columns\":2,\"rows\":3,\"frameCount\":6},\"Woailuoyongzhuang_shazhikai-23-pages-v3-0\":{\"url\":\"/public/gaara-vfx/extracted/Woailuoyongzhuang_shazhikai-23-pages-v3-0.png\",\"columns\":6,\"rows\":3,\"frameCount\":16},\"Woailuoyongzhuang_shazhikai-34-pages-v3-0\":{\"url\":\"/public/gaara-vfx/extracted/Woailuoyongzhuang_shazhikai-34-pages-v3-0.png\",\"columns\":9,\"rows\":1,\"frameCount\":7},\"Woailuoyongzhuang_shazhikai-35-pages-v3-0\":{\"url\":\"/public/gaara-vfx/extracted/Woailuoyongzhuang_shazhikai-35-pages-v3-0.png\",\"columns\":10,\"rows\":1,\"frameCount\":1},\"GAR_shazhidun-36-pages-v3-0\":{\"url\":\"/public/gaara-vfx/extracted/GAR_shazhidun-36-pages-v3-0.png\",\"columns\":6,\"rows\":4,\"frameCount\":22}},\"clips\":{\"Yzwoailuo_aoyi-159\":{\"atlas\":\"Yzwoailuo_aoyi-159-pages-v3-0\",\"frameAtlases\":[\"Yzwoailuo_aoyi-159-pages-v3-0\",\"Yzwoailuo_aoyi-159-pages-v3-0\",\"Yzwoailuo_aoyi-159-pages-v3-0\",\"Yzwoailuo_aoyi-159-pages-v3-0\",\"Yzwoailuo_aoyi-159-pages-v3-0\",\"Yzwoailuo_aoyi-159-pages-v3-0\",\"Yzwoailuo_aoyi-159-pages-v3-0\",\"Yzwoailuo_aoyi-159-pages-v3-0\",\"Yzwoailuo_aoyi-159-pages-v3-0\",\"Yzwoailuo_aoyi-159-pages-v3-0\",\"Yzwoailuo_aoyi-159-pages-v3-0\",\"Yzwoailuo_aoyi-159-pages-v3-0\",\"Yzwoailuo_aoyi-159-pages-v3-0\",\"Yzwoailuo_aoyi-159-pages-v3-0\",\"Yzwoailuo_aoyi-159-pages-v3-0\",\"Yzwoailuo_aoyi-159-pages-v3-1\",\"Yzwoailuo_aoyi-159-pages-v3-1\",\"Yzwoailuo_aoyi-159-pages-v3-1\",\"Yzwoailuo_aoyi-159-pages-v3-1\",\"Yzwoailuo_aoyi-159-pages-v3-1\",\"Yzwoailuo_aoyi-159-pages-v3-1\",\"Yzwoailuo_aoyi-159-pages-v3-1\",\"Yzwoailuo_aoyi-159-pages-v3-1\",\"Yzwoailuo_aoyi-159-pages-v3-2\",\"Yzwoailuo_aoyi-159-pages-v3-2\",\"Yzwoailuo_aoyi-159-pages-v3-2\",\"Yzwoailuo_aoyi-159-pages-v3-2\",\"Yzwoailuo_aoyi-159-pages-v3-2\",\"Yzwoailuo_aoyi-159-pages-v3-2\",\"Yzwoailuo_aoyi-159-pages-v3-2\",\"Yzwoailuo_aoyi-159-pages-v3-2\",\"Yzwoailuo_aoyi-159-pages-v3-3\",\"Yzwoailuo_aoyi-159-pages-v3-3\",\"Yzwoailuo_aoyi-159-pages-v3-3\",\"Yzwoailuo_aoyi-159-pages-v3-3\",\"Yzwoailuo_aoyi-159-pages-v3-3\",\"Yzwoailuo_aoyi-159-pages-v3-3\",\"Yzwoailuo_aoyi-159-pages-v3-3\",\"Yzwoailuo_aoyi-159-pages-v3-3\",\"Yzwoailuo_aoyi-159-pages-v3-3\",\"Yzwoailuo_aoyi-159-pages-v3-4\",\"Yzwoailuo_aoyi-159-pages-v3-4\",\"Yzwoailuo_aoyi-159-pages-v3-4\",\"Yzwoailuo_aoyi-159-pages-v3-4\",\"Yzwoailuo_aoyi-159-pages-v3-4\",\"Yzwoailuo_aoyi-159-pages-v3-4\",\"Yzwoailuo_aoyi-159-pages-v3-4\",\"Yzwoailuo_aoyi-159-pages-v3-4\",\"Yzwoailuo_aoyi-159-pages-v3-5\",\"Yzwoailuo_aoyi-159-pages-v3-5\",\"Yzwoailuo_aoyi-159-pages-v3-5\",\"Yzwoailuo_aoyi-159-pages-v3-5\",\"Yzwoailuo_aoyi-159-pages-v3-5\",\"Yzwoailuo_aoyi-159-pages-v3-5\",\"Yzwoailuo_aoyi-159-pages-v3-5\",\"Yzwoailuo_aoyi-159-pages-v3-5\",\"Yzwoailuo_aoyi-159-pages-v3-6\",\"Yzwoailuo_aoyi-159-pages-v3-6\",\"Yzwoailuo_aoyi-159-pages-v3-6\",\"Yzwoailuo_aoyi-159-pages-v3-6\",\"Yzwoailuo_aoyi-159-pages-v3-6\",\"Yzwoailuo_aoyi-159-pages-v3-6\",\"Yzwoailuo_aoyi-159-pages-v3-6\",\"Yzwoailuo_aoyi-159-pages-v3-6\",\"Yzwoailuo_aoyi-159-pages-v3-6\",\"Yzwoailuo_aoyi-159-pages-v3-7\",\"Yzwoailuo_aoyi-159-pages-v3-7\",\"Yzwoailuo_aoyi-159-pages-v3-7\",\"Yzwoailuo_aoyi-159-pages-v3-7\",\"Yzwoailuo_aoyi-159-pages-v3-7\",\"Yzwoailuo_aoyi-159-pages-v3-7\",\"Yzwoailuo_aoyi-159-pages-v3-7\",\"Yzwoailuo_aoyi-159-pages-v3-7\",\"Yzwoailuo_aoyi-159-pages-v3-8\",\"Yzwoailuo_aoyi-159-pages-v3-8\",\"Yzwoailuo_aoyi-159-pages-v3-8\",\"Yzwoailuo_aoyi-159-pages-v3-8\",\"Yzwoailuo_aoyi-159-pages-v3-8\",\"Yzwoailuo_aoyi-159-pages-v3-8\",\"Yzwoailuo_aoyi-159-pages-v3-8\",\"Yzwoailuo_aoyi-159-pages-v3-8\",\"Yzwoailuo_aoyi-159-pages-v3-9\",\"Yzwoailuo_aoyi-159-pages-v3-9\",\"Yzwoailuo_aoyi-159-pages-v3-9\",\"Yzwoailuo_aoyi-159-pages-v3-9\",\"Yzwoailuo_aoyi-159-pages-v3-9\",\"Yzwoailuo_aoyi-159-pages-v3-9\",\"Yzwoailuo_aoyi-159-pages-v3-9\",\"Yzwoailuo_aoyi-159-pages-v3-9\",\"Yzwoailuo_aoyi-159-pages-v3-0\",\"Yzwoailuo_aoyi-159-pages-v3-0\",\"Yzwoailuo_aoyi-159-pages-v3-0\",\"Yzwoailuo_aoyi-159-pages-v3-0\",\"Yzwoailuo_aoyi-159-pages-v3-0\",\"Yzwoailuo_aoyi-159-pages-v3-0\",\"Yzwoailuo_aoyi-159-pages-v3-0\",\"Yzwoailuo_aoyi-159-pages-v3-0\",\"Yzwoailuo_aoyi-159-pages-v3-0\",\"Yzwoailuo_aoyi-159-pages-v3-0\",\"Yzwoailuo_aoyi-159-pages-v3-0\",\"Yzwoailuo_aoyi-159-pages-v3-0\",\"Yzwoailuo_aoyi-159-pages-v3-0\",\"Yzwoailuo_aoyi-159-pages-v3-0\",\"Yzwoailuo_aoyi-159-pages-v3-0\",\"Yzwoailuo_aoyi-159-pages-v3-0\",\"Yzwoailuo_aoyi-159-pages-v3-0\"],\"timeline\":[0,0,0,0,0,0,0,1,2,3,4,5,6,6,7,0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,6,7,0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,6,7,0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],\"width\":994,\"height\":459,\"pivot\":[0.4578621522033159,0.5582768966887571],\"renderScale\":0.4456561631625859,\"sourceFrames\":101,\"sourceCrop\":[4,7,998,466],\"sourceZoom\":0.4456561631625859,\"softEdges\":true},\"Yzwoailuo_aoyi-432\":{\"atlas\":\"Yzwoailuo_aoyi-432-pages-v3-0\",\"frameAtlases\":[\"Yzwoailuo_aoyi-432-pages-v3-0\",\"Yzwoailuo_aoyi-432-pages-v3-0\",\"Yzwoailuo_aoyi-432-pages-v3-0\",\"Yzwoailuo_aoyi-432-pages-v3-0\",\"Yzwoailuo_aoyi-432-pages-v3-0\",\"Yzwoailuo_aoyi-432-pages-v3-0\",\"Yzwoailuo_aoyi-432-pages-v3-0\",\"Yzwoailuo_aoyi-432-pages-v3-1\",\"Yzwoailuo_aoyi-432-pages-v3-1\",\"Yzwoailuo_aoyi-432-pages-v3-2\",\"Yzwoailuo_aoyi-432-pages-v3-2\",\"Yzwoailuo_aoyi-432-pages-v3-3\",\"Yzwoailuo_aoyi-432-pages-v3-3\",\"Yzwoailuo_aoyi-432-pages-v3-3\",\"Yzwoailuo_aoyi-432-pages-v3-4\",\"Yzwoailuo_aoyi-432-pages-v3-4\",\"Yzwoailuo_aoyi-432-pages-v3-5\",\"Yzwoailuo_aoyi-432-pages-v3-5\",\"Yzwoailuo_aoyi-432-pages-v3-6\",\"Yzwoailuo_aoyi-432-pages-v3-6\",\"Yzwoailuo_aoyi-432-pages-v3-7\",\"Yzwoailuo_aoyi-432-pages-v3-7\",\"Yzwoailuo_aoyi-432-pages-v3-8\",\"Yzwoailuo_aoyi-432-pages-v3-8\",\"Yzwoailuo_aoyi-432-pages-v3-9\",\"Yzwoailuo_aoyi-432-pages-v3-9\",\"Yzwoailuo_aoyi-432-pages-v3-10\",\"Yzwoailuo_aoyi-432-pages-v3-10\",\"Yzwoailuo_aoyi-432-pages-v3-11\",\"Yzwoailuo_aoyi-432-pages-v3-11\",\"Yzwoailuo_aoyi-432-pages-v3-12\",\"Yzwoailuo_aoyi-432-pages-v3-12\",\"Yzwoailuo_aoyi-432-pages-v3-13\",\"Yzwoailuo_aoyi-432-pages-v3-13\",\"Yzwoailuo_aoyi-432-pages-v3-14\",\"Yzwoailuo_aoyi-432-pages-v3-14\",\"Yzwoailuo_aoyi-432-pages-v3-15\",\"Yzwoailuo_aoyi-432-pages-v3-15\",\"Yzwoailuo_aoyi-432-pages-v3-15\",\"Yzwoailuo_aoyi-432-pages-v3-16\",\"Yzwoailuo_aoyi-432-pages-v3-16\",\"Yzwoailuo_aoyi-432-pages-v3-17\",\"Yzwoailuo_aoyi-432-pages-v3-17\",\"Yzwoailuo_aoyi-432-pages-v3-18\",\"Yzwoailuo_aoyi-432-pages-v3-18\",\"Yzwoailuo_aoyi-432-pages-v3-19\",\"Yzwoailuo_aoyi-432-pages-v3-19\",\"Yzwoailuo_aoyi-432-pages-v3-20\",\"Yzwoailuo_aoyi-432-pages-v3-20\",\"Yzwoailuo_aoyi-432-pages-v3-21\",\"Yzwoailuo_aoyi-432-pages-v3-21\",\"Yzwoailuo_aoyi-432-pages-v3-22\",\"Yzwoailuo_aoyi-432-pages-v3-22\",\"Yzwoailuo_aoyi-432-pages-v3-23\",\"Yzwoailuo_aoyi-432-pages-v3-23\",\"Yzwoailuo_aoyi-432-pages-v3-24\",\"Yzwoailuo_aoyi-432-pages-v3-24\",\"Yzwoailuo_aoyi-432-pages-v3-25\",\"Yzwoailuo_aoyi-432-pages-v3-25\",\"Yzwoailuo_aoyi-432-pages-v3-26\",\"Yzwoailuo_aoyi-432-pages-v3-26\",\"Yzwoailuo_aoyi-432-pages-v3-27\",\"Yzwoailuo_aoyi-432-pages-v3-27\",\"Yzwoailuo_aoyi-432-pages-v3-27\",\"Yzwoailuo_aoyi-432-pages-v3-28\",\"Yzwoailuo_aoyi-432-pages-v3-28\",\"Yzwoailuo_aoyi-432-pages-v3-29\",\"Yzwoailuo_aoyi-432-pages-v3-29\",\"Yzwoailuo_aoyi-432-pages-v3-30\",\"Yzwoailuo_aoyi-432-pages-v3-30\",\"Yzwoailuo_aoyi-432-pages-v3-31\",\"Yzwoailuo_aoyi-432-pages-v3-31\",\"Yzwoailuo_aoyi-432-pages-v3-32\",\"Yzwoailuo_aoyi-432-pages-v3-32\",\"Yzwoailuo_aoyi-432-pages-v3-33\",\"Yzwoailuo_aoyi-432-pages-v3-33\",\"Yzwoailuo_aoyi-432-pages-v3-34\",\"Yzwoailuo_aoyi-432-pages-v3-34\",\"Yzwoailuo_aoyi-432-pages-v3-35\",\"Yzwoailuo_aoyi-432-pages-v3-35\",\"Yzwoailuo_aoyi-432-pages-v3-36\",\"Yzwoailuo_aoyi-432-pages-v3-36\",\"Yzwoailuo_aoyi-432-pages-v3-37\",\"Yzwoailuo_aoyi-432-pages-v3-37\",\"Yzwoailuo_aoyi-432-pages-v3-38\",\"Yzwoailuo_aoyi-432-pages-v3-38\",\"Yzwoailuo_aoyi-432-pages-v3-39\",\"Yzwoailuo_aoyi-432-pages-v3-39\",\"Yzwoailuo_aoyi-432-pages-v3-39\",\"Yzwoailuo_aoyi-432-pages-v3-40\",\"Yzwoailuo_aoyi-432-pages-v3-40\",\"Yzwoailuo_aoyi-432-pages-v3-41\",\"Yzwoailuo_aoyi-432-pages-v3-41\",\"Yzwoailuo_aoyi-432-pages-v3-42\",\"Yzwoailuo_aoyi-432-pages-v3-42\",\"Yzwoailuo_aoyi-432-pages-v3-43\",\"Yzwoailuo_aoyi-432-pages-v3-43\",\"Yzwoailuo_aoyi-432-pages-v3-44\",\"Yzwoailuo_aoyi-432-pages-v3-44\",\"Yzwoailuo_aoyi-432-pages-v3-45\",\"Yzwoailuo_aoyi-432-pages-v3-45\",\"Yzwoailuo_aoyi-432-pages-v3-46\",\"Yzwoailuo_aoyi-432-pages-v3-46\",\"Yzwoailuo_aoyi-432-pages-v3-47\",\"Yzwoailuo_aoyi-432-pages-v3-0\",\"Yzwoailuo_aoyi-432-pages-v3-0\"],\"timeline\":[0,0,0,0,0,0,1,0,1,0,1,0,1,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0],\"width\":1280,\"height\":755,\"pivot\":[0.4792814142232598,0.5320983059304246],\"renderScale\":0.3696953265379844,\"sourceFrames\":101,\"sourceCrop\":[77,26,1620,936],\"sourceZoom\":0.4456561631625859,\"softEdges\":true},\"Yzwoailuo_pugong-424\":{\"atlas\":\"Yzwoailuo_pugong-424-pages-v3-0\",\"frameAtlases\":[\"Yzwoailuo_pugong-424-pages-v3-0\",\"Yzwoailuo_pugong-424-pages-v3-0\",\"Yzwoailuo_pugong-424-pages-v3-0\",\"Yzwoailuo_pugong-424-pages-v3-1\",\"Yzwoailuo_pugong-424-pages-v3-1\",\"Yzwoailuo_pugong-424-pages-v3-2\",\"Yzwoailuo_pugong-424-pages-v3-2\",\"Yzwoailuo_pugong-424-pages-v3-3\",\"Yzwoailuo_pugong-424-pages-v3-3\",\"Yzwoailuo_pugong-424-pages-v3-4\",\"Yzwoailuo_pugong-424-pages-v3-4\",\"Yzwoailuo_pugong-424-pages-v3-5\",\"Yzwoailuo_pugong-424-pages-v3-5\",\"Yzwoailuo_pugong-424-pages-v3-5\",\"Yzwoailuo_pugong-424-pages-v3-6\",\"Yzwoailuo_pugong-424-pages-v3-6\",\"Yzwoailuo_pugong-424-pages-v3-7\",\"Yzwoailuo_pugong-424-pages-v3-7\",\"Yzwoailuo_pugong-424-pages-v3-8\",\"Yzwoailuo_pugong-424-pages-v3-8\",\"Yzwoailuo_pugong-424-pages-v3-9\",\"Yzwoailuo_pugong-424-pages-v3-9\",\"Yzwoailuo_pugong-424-pages-v3-10\",\"Yzwoailuo_pugong-424-pages-v3-10\",\"Yzwoailuo_pugong-424-pages-v3-11\",\"Yzwoailuo_pugong-424-pages-v3-11\",\"Yzwoailuo_pugong-424-pages-v3-12\",\"Yzwoailuo_pugong-424-pages-v3-12\",\"Yzwoailuo_pugong-424-pages-v3-13\",\"Yzwoailuo_pugong-424-pages-v3-13\",\"Yzwoailuo_pugong-424-pages-v3-14\",\"Yzwoailuo_pugong-424-pages-v3-14\",\"Yzwoailuo_pugong-424-pages-v3-15\",\"Yzwoailuo_pugong-424-pages-v3-15\",\"Yzwoailuo_pugong-424-pages-v3-16\",\"Yzwoailuo_pugong-424-pages-v3-16\",\"Yzwoailuo_pugong-424-pages-v3-17\",\"Yzwoailuo_pugong-424-pages-v3-17\",\"Yzwoailuo_pugong-424-pages-v3-17\",\"Yzwoailuo_pugong-424-pages-v3-18\",\"Yzwoailuo_pugong-424-pages-v3-18\",\"Yzwoailuo_pugong-424-pages-v3-19\",\"Yzwoailuo_pugong-424-pages-v3-19\",\"Yzwoailuo_pugong-424-pages-v3-20\",\"Yzwoailuo_pugong-424-pages-v3-20\",\"Yzwoailuo_pugong-424-pages-v3-21\",\"Yzwoailuo_pugong-424-pages-v3-21\",\"Yzwoailuo_pugong-424-pages-v3-22\",\"Yzwoailuo_pugong-424-pages-v3-22\",\"Yzwoailuo_pugong-424-pages-v3-23\",\"Yzwoailuo_pugong-424-pages-v3-23\",\"Yzwoailuo_pugong-424-pages-v3-24\",\"Yzwoailuo_pugong-424-pages-v3-24\",\"Yzwoailuo_pugong-424-pages-v3-25\",\"Yzwoailuo_pugong-424-pages-v3-0\",\"Yzwoailuo_pugong-424-pages-v3-0\"],\"timeline\":[0,0,1,0,1,0,1,0,1,0,1,0,1,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0],\"width\":1280,\"height\":757,\"pivot\":[0.43379413873920336,0.5327624018214182],\"renderScale\":0.37120729269480085,\"sourceFrames\":53,\"sourceCrop\":[78,17,1631,936],\"sourceZoom\":0.45037884808986384},\"Yzwoailuo_pugong-81\":{\"atlas\":\"Yzwoailuo_pugong-81-pages-v3-0\",\"frameAtlases\":[\"Yzwoailuo_pugong-81-pages-v3-0\",\"Yzwoailuo_pugong-81-pages-v3-0\",\"Yzwoailuo_pugong-81-pages-v3-0\",\"Yzwoailuo_pugong-81-pages-v3-0\",\"Yzwoailuo_pugong-81-pages-v3-0\",\"Yzwoailuo_pugong-81-pages-v3-0\",\"Yzwoailuo_pugong-81-pages-v3-0\",\"Yzwoailuo_pugong-81-pages-v3-0\",\"Yzwoailuo_pugong-81-pages-v3-0\",\"Yzwoailuo_pugong-81-pages-v3-0\",\"Yzwoailuo_pugong-81-pages-v3-0\",\"Yzwoailuo_pugong-81-pages-v3-0\",\"Yzwoailuo_pugong-81-pages-v3-0\",\"Yzwoailuo_pugong-81-pages-v3-0\",\"Yzwoailuo_pugong-81-pages-v3-0\",\"Yzwoailuo_pugong-81-pages-v3-0\",\"Yzwoailuo_pugong-81-pages-v3-0\",\"Yzwoailuo_pugong-81-pages-v3-0\",\"Yzwoailuo_pugong-81-pages-v3-0\",\"Yzwoailuo_pugong-81-pages-v3-0\",\"Yzwoailuo_pugong-81-pages-v3-0\",\"Yzwoailuo_pugong-81-pages-v3-0\",\"Yzwoailuo_pugong-81-pages-v3-0\",\"Yzwoailuo_pugong-81-pages-v3-0\",\"Yzwoailuo_pugong-81-pages-v3-0\",\"Yzwoailuo_pugong-81-pages-v3-0\",\"Yzwoailuo_pugong-81-pages-v3-0\",\"Yzwoailuo_pugong-81-pages-v3-0\",\"Yzwoailuo_pugong-81-pages-v3-0\",\"Yzwoailuo_pugong-81-pages-v3-0\",\"Yzwoailuo_pugong-81-pages-v3-1\",\"Yzwoailuo_pugong-81-pages-v3-1\",\"Yzwoailuo_pugong-81-pages-v3-1\",\"Yzwoailuo_pugong-81-pages-v3-1\",\"Yzwoailuo_pugong-81-pages-v3-1\",\"Yzwoailuo_pugong-81-pages-v3-1\",\"Yzwoailuo_pugong-81-pages-v3-1\",\"Yzwoailuo_pugong-81-pages-v3-1\",\"Yzwoailuo_pugong-81-pages-v3-1\",\"Yzwoailuo_pugong-81-pages-v3-1\",\"Yzwoailuo_pugong-81-pages-v3-1\",\"Yzwoailuo_pugong-81-pages-v3-1\",\"Yzwoailuo_pugong-81-pages-v3-1\",\"Yzwoailuo_pugong-81-pages-v3-1\",\"Yzwoailuo_pugong-81-pages-v3-1\",\"Yzwoailuo_pugong-81-pages-v3-1\",\"Yzwoailuo_pugong-81-pages-v3-1\",\"Yzwoailuo_pugong-81-pages-v3-1\",\"Yzwoailuo_pugong-81-pages-v3-1\",\"Yzwoailuo_pugong-81-pages-v3-0\",\"Yzwoailuo_pugong-81-pages-v3-0\",\"Yzwoailuo_pugong-81-pages-v3-0\",\"Yzwoailuo_pugong-81-pages-v3-0\",\"Yzwoailuo_pugong-81-pages-v3-0\",\"Yzwoailuo_pugong-81-pages-v3-0\",\"Yzwoailuo_pugong-81-pages-v3-0\"],\"timeline\":[0,0,0,0,0,0,1,2,3,4,5,6,7,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,0,1,2,3,4,5,6,7,7,8,9,10,11,12,13,14,15,16,17,0,0,0,0,0,0,0],\"width\":564,\"height\":255,\"pivot\":[0.5830309200016686,0.4272745690232857],\"renderScale\":0.45037884808986384,\"sourceFrames\":53,\"sourceCrop\":[149,4,713,259],\"sourceZoom\":0.45037884808986384},\"Yzwoailuo_beidong2-124\":{\"atlas\":\"Yzwoailuo_beidong2-124-pages-v3-0\",\"frameAtlases\":[\"Yzwoailuo_beidong2-124-pages-v3-0\",\"Yzwoailuo_beidong2-124-pages-v3-0\",\"Yzwoailuo_beidong2-124-pages-v3-0\",\"Yzwoailuo_beidong2-124-pages-v3-0\",\"Yzwoailuo_beidong2-124-pages-v3-0\",\"Yzwoailuo_beidong2-124-pages-v3-0\",\"Yzwoailuo_beidong2-124-pages-v3-0\",\"Yzwoailuo_beidong2-124-pages-v3-0\",\"Yzwoailuo_beidong2-124-pages-v3-0\",\"Yzwoailuo_beidong2-124-pages-v3-0\",\"Yzwoailuo_beidong2-124-pages-v3-1\",\"Yzwoailuo_beidong2-124-pages-v3-1\",\"Yzwoailuo_beidong2-124-pages-v3-1\",\"Yzwoailuo_beidong2-124-pages-v3-1\",\"Yzwoailuo_beidong2-124-pages-v3-1\",\"Yzwoailuo_beidong2-124-pages-v3-1\",\"Yzwoailuo_beidong2-124-pages-v3-1\",\"Yzwoailuo_beidong2-124-pages-v3-2\",\"Yzwoailuo_beidong2-124-pages-v3-2\",\"Yzwoailuo_beidong2-124-pages-v3-2\",\"Yzwoailuo_beidong2-124-pages-v3-2\",\"Yzwoailuo_beidong2-124-pages-v3-2\",\"Yzwoailuo_beidong2-124-pages-v3-2\",\"Yzwoailuo_beidong2-124-pages-v3-3\",\"Yzwoailuo_beidong2-124-pages-v3-3\",\"Yzwoailuo_beidong2-124-pages-v3-3\",\"Yzwoailuo_beidong2-124-pages-v3-3\",\"Yzwoailuo_beidong2-124-pages-v3-3\",\"Yzwoailuo_beidong2-124-pages-v3-3\",\"Yzwoailuo_beidong2-124-pages-v3-4\",\"Yzwoailuo_beidong2-124-pages-v3-4\",\"Yzwoailuo_beidong2-124-pages-v3-4\",\"Yzwoailuo_beidong2-124-pages-v3-4\",\"Yzwoailuo_beidong2-124-pages-v3-4\",\"Yzwoailuo_beidong2-124-pages-v3-4\",\"Yzwoailuo_beidong2-124-pages-v3-5\",\"Yzwoailuo_beidong2-124-pages-v3-5\",\"Yzwoailuo_beidong2-124-pages-v3-5\",\"Yzwoailuo_beidong2-124-pages-v3-5\",\"Yzwoailuo_beidong2-124-pages-v3-5\",\"Yzwoailuo_beidong2-124-pages-v3-5\",\"Yzwoailuo_beidong2-124-pages-v3-5\",\"Yzwoailuo_beidong2-124-pages-v3-6\",\"Yzwoailuo_beidong2-124-pages-v3-6\"],\"timeline\":[0,0,0,0,0,1,2,3,4,5,0,1,2,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,2,3,4,5,0,1],\"width\":900,\"height\":580,\"pivot\":[0.04237777777777778,0.5167241379310344],\"renderScale\":0.85,\"sourceFrames\":42,\"sourceCrop\":[71,25,971,605],\"sourceZoom\":0.85},\"Yzwoailuo_beidong2-38\":{\"atlas\":\"Yzwoailuo_beidong2-38-pages-v3-0\",\"frameAtlases\":[\"Yzwoailuo_beidong2-38-pages-v3-0\",\"Yzwoailuo_beidong2-38-pages-v3-0\",\"Yzwoailuo_beidong2-38-pages-v3-0\",\"Yzwoailuo_beidong2-38-pages-v3-0\",\"Yzwoailuo_beidong2-38-pages-v3-0\",\"Yzwoailuo_beidong2-38-pages-v3-0\",\"Yzwoailuo_beidong2-38-pages-v3-0\",\"Yzwoailuo_beidong2-38-pages-v3-0\",\"Yzwoailuo_beidong2-38-pages-v3-0\",\"Yzwoailuo_beidong2-38-pages-v3-0\",\"Yzwoailuo_beidong2-38-pages-v3-0\",\"Yzwoailuo_beidong2-38-pages-v3-0\",\"Yzwoailuo_beidong2-38-pages-v3-0\",\"Yzwoailuo_beidong2-38-pages-v3-0\",\"Yzwoailuo_beidong2-38-pages-v3-0\",\"Yzwoailuo_beidong2-38-pages-v3-0\",\"Yzwoailuo_beidong2-38-pages-v3-0\",\"Yzwoailuo_beidong2-38-pages-v3-1\",\"Yzwoailuo_beidong2-38-pages-v3-1\",\"Yzwoailuo_beidong2-38-pages-v3-1\",\"Yzwoailuo_beidong2-38-pages-v3-1\",\"Yzwoailuo_beidong2-38-pages-v3-1\",\"Yzwoailuo_beidong2-38-pages-v3-1\",\"Yzwoailuo_beidong2-38-pages-v3-1\",\"Yzwoailuo_beidong2-38-pages-v3-1\",\"Yzwoailuo_beidong2-38-pages-v3-1\",\"Yzwoailuo_beidong2-38-pages-v3-1\",\"Yzwoailuo_beidong2-38-pages-v3-1\",\"Yzwoailuo_beidong2-38-pages-v3-1\",\"Yzwoailuo_beidong2-38-pages-v3-2\",\"Yzwoailuo_beidong2-38-pages-v3-2\",\"Yzwoailuo_beidong2-38-pages-v3-2\",\"Yzwoailuo_beidong2-38-pages-v3-2\",\"Yzwoailuo_beidong2-38-pages-v3-2\",\"Yzwoailuo_beidong2-38-pages-v3-2\",\"Yzwoailuo_beidong2-38-pages-v3-0\",\"Yzwoailuo_beidong2-38-pages-v3-0\",\"Yzwoailuo_beidong2-38-pages-v3-0\",\"Yzwoailuo_beidong2-38-pages-v3-0\",\"Yzwoailuo_beidong2-38-pages-v3-0\",\"Yzwoailuo_beidong2-38-pages-v3-0\",\"Yzwoailuo_beidong2-38-pages-v3-0\",\"Yzwoailuo_beidong2-38-pages-v3-0\",\"Yzwoailuo_beidong2-38-pages-v3-0\"],\"timeline\":[0,0,0,0,0,1,2,3,4,5,6,7,8,8,9,10,11,0,1,2,3,4,5,6,7,8,9,10,11,0,1,2,3,4,5,0,0,0,0,0,0,0,0,0],\"width\":779,\"height\":325,\"pivot\":[-0.011784338896020539,0.5076384615384615],\"renderScale\":0.85,\"sourceFrames\":42,\"sourceCrop\":[68,19,847,344],\"sourceZoom\":0.85},\"Woailuoyongzhuang_shazhikai-23\":{\"atlas\":\"Woailuoyongzhuang_shazhikai-23-pages-v3-0\",\"frameAtlases\":[\"Woailuoyongzhuang_shazhikai-23-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-23-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-23-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-23-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-23-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-23-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-23-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-23-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-23-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-23-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-23-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-23-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-23-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-23-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-23-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-23-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-23-pages-v3-0\"],\"timeline\":[0,1,2,3,4,5,6,7,8,9,10,11,12,12,13,14,15],\"width\":296,\"height\":255,\"pivot\":[0.47402027027027027,0.8938333333333331],\"renderScale\":0.85,\"sourceFrames\":16,\"sourceCrop\":[37,51,333,306],\"sourceZoom\":0.85},\"Woailuoyongzhuang_shazhikai-34\":{\"atlas\":\"Woailuoyongzhuang_shazhikai-34-pages-v3-0\",\"frameAtlases\":[\"Woailuoyongzhuang_shazhikai-34-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-34-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-34-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-34-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-34-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-34-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-34-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-34-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-34-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-34-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-34-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-34-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-34-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-34-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-34-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-34-pages-v3-0\"],\"timeline\":[0,0,1,1,2,2,3,3,4,4,5,5,6,6,6,6],\"width\":215,\"height\":219,\"pivot\":[0.4299883720930232,0.8374429223744293],\"renderScale\":0.85,\"sourceFrames\":15,\"sourceCrop\":[9,7,224,226],\"sourceZoom\":0.85},\"Woailuoyongzhuang_shazhikai-35\":{\"atlas\":\"Woailuoyongzhuang_shazhikai-35-pages-v3-0\",\"frameAtlases\":[\"Woailuoyongzhuang_shazhikai-35-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-35-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-35-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-35-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-35-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-35-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-35-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-35-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-35-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-35-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-35-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-35-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-35-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-35-pages-v3-0\",\"Woailuoyongzhuang_shazhikai-35-pages-v3-0\"],\"timeline\":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],\"width\":196,\"height\":211,\"pivot\":[0.47167091836734687,0.8691943127962085],\"renderScale\":0.85,\"sourceFrames\":14,\"sourceCrop\":[9,7,205,218],\"sourceZoom\":0.85},\"GAR_shazhidun-36\":{\"atlas\":\"GAR_shazhidun-36-pages-v3-0\",\"frameAtlases\":[\"GAR_shazhidun-36-pages-v3-0\",\"GAR_shazhidun-36-pages-v3-0\",\"GAR_shazhidun-36-pages-v3-0\",\"GAR_shazhidun-36-pages-v3-0\",\"GAR_shazhidun-36-pages-v3-0\",\"GAR_shazhidun-36-pages-v3-0\",\"GAR_shazhidun-36-pages-v3-0\",\"GAR_shazhidun-36-pages-v3-0\",\"GAR_shazhidun-36-pages-v3-0\",\"GAR_shazhidun-36-pages-v3-0\",\"GAR_shazhidun-36-pages-v3-0\",\"GAR_shazhidun-36-pages-v3-0\",\"GAR_shazhidun-36-pages-v3-0\",\"GAR_shazhidun-36-pages-v3-0\",\"GAR_shazhidun-36-pages-v3-0\",\"GAR_shazhidun-36-pages-v3-0\",\"GAR_shazhidun-36-pages-v3-0\",\"GAR_shazhidun-36-pages-v3-0\",\"GAR_shazhidun-36-pages-v3-0\",\"GAR_shazhidun-36-pages-v3-0\",\"GAR_shazhidun-36-pages-v3-0\",\"GAR_shazhidun-36-pages-v3-0\",\"GAR_shazhidun-36-pages-v3-0\",\"GAR_shazhidun-36-pages-v3-0\",\"GAR_shazhidun-36-pages-v3-0\",\"GAR_shazhidun-36-pages-v3-0\",\"GAR_shazhidun-36-pages-v3-0\",\"GAR_shazhidun-36-pages-v3-0\"],\"timeline\":[0,1,2,3,4,5,6,7,8,9,10,11,12,12,13,14,15,16,17,17,18,18,19,19,20,20,21,21],\"width\":293,\"height\":263,\"pivot\":[0.479684300341297,0.8604182509505702],\"renderScale\":0.85,\"sourceFrames\":26,\"sourceCrop\":[85,86,378,349],\"sourceZoom\":0.85}},\"effects\":{\"Yzwoailuo_aoyi\":[\"Yzwoailuo_aoyi-159\",\"Yzwoailuo_aoyi-432\"],\"Yzwoailuo_pugong\":[\"Yzwoailuo_pugong-424\",\"Yzwoailuo_pugong-81\"],\"Yzwoailuo_beidong2\":[\"Yzwoailuo_beidong2-124\",\"Yzwoailuo_beidong2-38\"],\"Woailuoyongzhuang_shazhikai\":[\"Woailuoyongzhuang_shazhikai-23\",\"Woailuoyongzhuang_shazhikai-34\",\"Woailuoyongzhuang_shazhikai-35\"],\"GAR_shazhidun\":[\"GAR_shazhidun-36\"]},\"moves\":{\"13121501\":\"mystery\",\"13121502\":\"standard\",\"13121503\":\"storm\",\"13121504\":\"surf\"},\"actions\":{\"standard\":[\"Yzwoailuo_pugong\"],\"mystery\":[\"Yzwoailuo_aoyi\"],\"storm\":[\"Yzwoailuo_beidong2\"],\"surf\":[\"Yzwoailuo_aoyi\"]},\"poseTiming\":{\"13121501\":{\"end\":106,\"distance\":300},\"13121502\":{\"end\":56,\"distance\":360},\"13121503\":{\"end\":44,\"distance\":240},\"13121504\":{\"end\":106,\"distance\":360}}}");
         manifest.firstAtlases = {};
         for(var name:String in manifest.clips)
         {
            var clip:Object = manifest.clips[name];
            if(clip.width * clip.height < 150000 && (name.indexOf("Yafenshen") >= 0 || name.indexOf("Huanshuxielunyan-") >= 0))
            {
               manifest.firstAtlases[clip.atlas] = true;
            }
            clip.nextAtlases = [];
            var next:String = null;
            var i:int = clip.frameAtlases.length - 1;
            while(i >= 0)
            {
               if(i + 1 < clip.frameAtlases.length && String(clip.frameAtlases[i]) != String(clip.frameAtlases[i + 1]))
               {
                  next = String(clip.frameAtlases[i + 1]);
               }
               clip.nextAtlases[i] = next;
               i--;
            }
            clip.aheadPages = [];
            var tick:int = 0;
            while(tick < clip.timeline.length)
            {
               var pages:Array = [];
               var seen:Object = {};
               var j:int = tick;
               while(j < Math.min(tick + 21,clip.timeline.length))
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
         FGaaraFxLoading["_manifest"] = manifest;
         return manifest;
      }
      
      protected function InitCharacter() : void
      {
         this.FWaitNextCommand = false;
         FIsAntiColorBlackWhite = false;
         FIsRedAntiColor = false;
         this.FStatusGridFile = false;
         this.FHideFrame = -1;
         if(FResourcesType != TYPE_KNIFE)
         {
            this.SetPosition(SBattleConfig.GetPostionByCamyPos(Camp,Pos,SBattleConfig.Type_PostionX),SBattleConfig.GetPostionByCamyPos(Camp,Pos,SBattleConfig.Type_PostionY));
         }
      }
      
      override protected function LoadResources(param1:uint) : void
      {
         super.LoadResources(param1);
         switch(param1)
         {
            case CONST_BATTLE.Public_Effect_Giddy:
               SResourcesCore.TexturesSkill.LoadAutoSecondary(CONST_BATTLE.Public_Effect_Giddy,this.AutoLoadCallBack);
               break;
            case CONST_BATTLE.Public_Effect_Shield:
               SResourcesCore.TexturesSkill.LoadAutoSecondary(CONST_BATTLE.Public_Effect_Shield,this.AutoLoadCallBack);
               break;
            case CONST_BATTLE.Public_Effect_Frozen:
               SResourcesCore.TexturesSkill.LoadAutoSecondary(CONST_BATTLE.Public_Effect_Frozen,this.AutoLoadCallBack);
         }
      }
      
      override protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         var _loc5_:TBounds = null;
         var _loc6_:TCoordinate = null;
         super.AutoLoadCallBack(param1,param2,param3);
         _loc5_ = new TBounds();
         _loc6_ = new TCoordinate();
         switch(param3)
         {
            case CONST_BATTLE.Public_Effect_Giddy:
               _loc4_ = param2.GetAnimationSequenceByIndex(0);
               _loc4_.Evaluate(_loc6_,_loc5_);
               this.FGiddyBitmap.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
               this.FGiddyBitmap.x = _loc5_.X;
               this.FGiddyBitmap.y = _loc5_.Y;
               this.FGiddySequence = _loc4_;
               break;
            case CONST_BATTLE.Public_Effect_Shield:
               _loc4_ = param2.GetAnimationSequenceByIndex(0);
               _loc4_.Evaluate(_loc6_,_loc5_);
               this.FShieldBitmap.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
               this.FShieldBitmap.x = _loc5_.X;
               this.FShieldBitmap.y = _loc5_.Y;
               this.FShieldSequence = _loc4_;
               break;
            case CONST_BATTLE.Public_Effect_Frozen:
               _loc4_ = param2.GetAnimationSequenceByIndex(0);
               _loc4_.Evaluate(_loc6_,_loc5_);
               this.FFrozenBitmap.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
               this.FFrozenBitmap.x = _loc5_.X;
               this.FFrozenBitmap.y = _loc5_.Y;
               this.FFrozenSequence = _loc4_;
         }
         _loc5_ = null;
         _loc6_ = null;
      }
      
      protected function PlayShowUI(param1:int) : void
      {
         var SkillName:String;
         var Skill:TSkillConfig = null;
         var ShowUIEnd:Function = null;
         var ExpandFilter:Function = null;
         var SkillId:int = param1;
         ShowUIEnd = function():void
         {
            DelStatus(CONST_BATTLE.TEXT_FIGHT_STATUS_OtherTurn,CONST_BATTLE.TEXT_FIGHT_STATUS_Punch);
            FSkillId = Skill.SkillId;
            PlaySkill();
         };
         ExpandFilter = function():void
         {
            FBitmap.filters = [];
         };
         if(stage == null)
         {
            return;
         }
         SkillName = "";
         if(FEnemy != null)
         {
            Skill = this.FSkillBins.GetDatebaseByIdentifier(SkillId) as TSkillConfig;
            if(!FEnemy.IsBoss)
            {
               ShowUIEnd();
               return;
            }
         }
         else
         {
            if(FHero == null)
            {
               Skill = this.FSkillBins.GetDatebaseByIdentifier(SkillId) as TSkillConfig;
               ShowUIEnd();
               return;
            }
            Skill = this.FSkillBins.GetDatebaseByIdentifier(SkillId) as TSkillConfig;
         }
         if(FId == 11120903 && SkillId != 13120911)
         {
            ShowUIEnd();
            return;
         }
         if(FId >= 11120980 && FId <= 11120984 && SkillId != 13121401)
         {
            ShowUIEnd();
            return;
         }
         if(FId == 11120920 && SkillId != 13120951 && SkillId != 13120952)
         {
            ShowUIEnd();
            return;
         }
         SkillName = Skill.Name;
         FBitmap.filters = TUtilityFilter.SKILL_FILTERS;
         TBattleHandle.PlaybackTimeout(ExpandFilter,100);
         TEffectControl.ShowEffect(this,CONST_BATTLE.Public_Effect_Effect);
         if(this.FOnBigSkill != null)
         {
            this.FOnBigSkill(this,FResourcesId,Camp,SkillName,ShowUIEnd);
         }
      }
      
      protected function ShowGridFile() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < FTargets.length)
         {
            if(FResults[_loc1_].CMD != 0)
            {
               TEffectControl.ShowPublicEffect(FTargets[_loc1_],CONST_BATTLE.Public_Effect_Daoguang,0,0,this.EndGridFile);
               FTargets[_loc1_].ActivePlay(TYPE_ACTIVE_ATTACKED);
               FTargets[_loc1_].ChangeHP(FResults[_loc1_].ResultInfo.HurtHp);
               if(this.FTextFunction != null)
               {
                  this.FTextFunction(TBattleStage.TYPETEXT_Float,FTargets[_loc1_].Camp == 0 ? -1 : 1,FTargets[_loc1_].x,FTargets[_loc1_].y - FTargets[_loc1_].RoleHeight,FResults[_loc1_].ResultInfo.HurtHp);
               }
            }
            _loc1_++;
         }
      }
      
      protected function EndGridFile() : void
      {
         var _loc1_:Function = null;
         var _loc2_:uint = 0;
         this.FStatusGridFile = false;
         FBitmap.visible = true;
         _loc1_ = FCallBackDict[TYPE_ACTIVE_GRIDFILE];
         _loc2_ = uint(FTimeDict[TYPE_ACTIVE_GRIDFILE]);
         if(_loc1_ != null)
         {
            _loc1_(_loc2_);
         }
      }
      
      protected function GetSameBuffIndex(param1:Vector.<uint>, param2:int) : Vector.<int>
      {
         var _loc3_:int = 0;
         var _loc4_:Vector.<int> = null;
         var _loc5_:TBuffEffect = null;
         var _loc6_:TBuffEffect = null;
         _loc4_ = new Vector.<int>();
         _loc6_ = this.FBuffBins.GetDatebaseByIdentifier(param2) as TBuffEffect;
         _loc4_.push(_loc6_.Weight);
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc5_ = this.FBuffBins.GetDatebaseByIdentifier(param1[_loc3_]) as TBuffEffect;
            if(_loc5_.BuffType == _loc6_.BuffType && this.GetAlterSame(_loc5_.AlterVect,_loc6_.AlterVect) && _loc5_.Buffkey == _loc6_.Buffkey)
            {
               _loc4_.push(_loc3_);
               _loc4_.push(_loc5_.Weight);
            }
            _loc3_++;
         }
         return _loc4_;
      }
      
      protected function DelSameTypeBuffIndex(param1:uint) : void
      {
         var _loc2_:* = 0;
         var _loc3_:TBuffEffect = null;
         _loc2_ = 0;
         while(_loc2_ < this.FBuffIdVect.length)
         {
            _loc3_ = this.FBuffBins.GetDatebaseByIdentifier(this.FBuffIdVect[_loc2_]) as TBuffEffect;
            if(_loc3_ != null)
            {
               if(param1 == _loc3_.BuffType)
               {
                  this.DelBuffs(_loc3_.Identifier);
                  _loc2_--;
               }
            }
            _loc2_++;
         }
      }
      
      protected function GetAlterSame(param1:Vector.<uint>, param2:Vector.<uint>) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc5_ = param2.indexOf(param1[_loc3_]);
            if(_loc5_ >= 0)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      protected function DelBuffs(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         _loc2_ = this.FBuffIdVect.indexOf(param1);
         if(_loc2_ >= 0)
         {
            this.FBuffIdVect.splice(_loc2_,1);
            this.FBuffTurnVect.splice(_loc2_,1);
            _loc3_ = this.FBuffSpriteVect[_loc2_];
            this.FBuffSpriteVect.splice(_loc2_,1);
            this.FIsNewBuffVect.splice(_loc2_,1);
            this.SaveBitmapSprite(_loc3_);
         }
      }
      
      protected function DelBuffByIndex(param1:int) : void
      {
         var _loc2_:Sprite = null;
         if(param1 >= 0 && param1 < this.FBuffIdVect.length)
         {
            this.FBuffIdVect.splice(param1,1);
            this.FBuffTurnVect.splice(param1,1);
            _loc2_ = this.FBuffSpriteVect[param1];
            this.FBuffSpriteVect.splice(param1,1);
            this.FIsNewBuffVect.splice(param1,1);
            this.SaveBitmapSprite(_loc2_);
         }
      }
      
      protected function CheckBuffContinued(param1:uint, param2:int) : Boolean
      {
         var _loc3_:TBuffEffect = null;
         _loc3_ = this.FBuffBins.GetDatebaseByIdentifier(param1) as TBuffEffect;
         if(_loc3_ != null)
         {
            if(_loc3_.Continued == param2)
            {
               return true;
            }
         }
         return false;
      }
      
      protected function SaveBitmapSprite(param1:Sprite) : void
      {
         if(param1)
         {
            if(param1.hasEventListener(MouseEvent.MOUSE_MOVE))
            {
               param1.removeEventListener(MouseEvent.MOUSE_MOVE,this.OnMouseMove);
            }
            if(param1.hasEventListener(MouseEvent.ROLL_OUT))
            {
               param1.removeEventListener(MouseEvent.ROLL_OUT,this.OnRollOut);
            }
         }
         TPoolBitmap.SaveBitmapSprite(param1);
      }
      
      public function PrepareBattleRole() : void
      {
         if(FId == 11120991)
         {
            PreloadGaaraVfx();
         }
         if(FId == 11120990)
         {
            PreloadNagatoVfx();
         }
         if(FId == 11120970)
         {
            PreloadSasukeVfx();
         }
         ClearItachiCrowClone();
         if(FId == 11120960)
         {
            PreloadItachiVfx();
         }
         if(FId == 11120950)
         {
            PreloadMechaVfx();
         }
         if(FId == 11120940)
         {
            FHashiramaVfxStarted = false;
            PreloadHashiramaVfx();
         }
         if(FPainTechnique != null)
         {
            FPainTechnique.visible = FId == 11120930;
         }
         if(FId == 11120930)
         {
            PreloadPainVfx();
            FPainFinal = false;
            if(FPainTechnique == null)
            {
               FPainTechnique = new TextField();
               FPainTechnique.mouseEnabled = false;
               FPainTechnique.selectable = false;
               addChild(FPainTechnique);
            }
            FPainTechnique.defaultTextFormat = new TextFormat("Arial",13,14400511,true,null,null,null,null,"center");
            FPainTechnique.width = 150;
            FPainTechnique.height = 25;
            FPainTechnique.y = -195;
            FPainTechnique.scaleX = scaleX < 0 ? -1 : 1;
            FPainTechnique.x = scaleX < 0 ? 75 : -75;
            FPainTechnique.filters = [new GlowFilter(1048608,1,4,4,4)];
            FPainTechnique.text = "TP 0 / 5";
         }
         if(FId == 11120920)
         {
            PreloadObitoVfx();
         }
      }
      
      public function ChangeHP(param1:Number) : void
      {
         if(param1 < 0)
         {
            if(FId == 11120930 && (CurHealth <= 0 || FIsDie || FWaitDie))
            {
               CurHealth -= param1;
               if(CurHealth > 0)
               {
                  RestorePainAfterRevival();
               }
               return;
            }
            if((FId == 11120902 || FId == 11120903) && FIsDie)
            {
               TweenUtil.removeTween(this,false);
               FIsDie = false;
               this.alpha = 1;
               this.visible = true;
               this.filters = [];
               FBitmap.filters = [];
               FShaderBmp.visible = true;
               FHpBar.visible = true;
               FBuffSprite.visible = true;
               if(FIdlePosition != null)
               {
                  this.x = FIdlePosition[0];
                  this.y = FIdlePosition[1];
               }
               PlayFightIdle();
            }
            CurHealth -= param1;
         }
         else
         {
            this.FShieldBlood -= param1;
            if(this.FShieldBlood < 0)
            {
               CurHealth += this.FShieldBlood;
               this.FShieldBlood = 0;
               if(this.FShieldBitmap.visible != false)
               {
                  this.FShieldBitmap.visible = false;
               }
            }
         }
      }
      
      protected function OnMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TBuffEffect = null;
         _loc4_ = this.FBuffSpriteVect.indexOf(param1.target);
         if(_loc4_ < 0)
         {
            return;
         }
         _loc2_ = int(this.FBuffIdVect[_loc4_]);
         _loc3_ = int(this.FBuffTurnVect[_loc4_]);
         _loc5_ = this.FBuffBins.GetDatebaseByIdentifier(_loc2_) as TBuffEffect;
         if(this.FOnBuffMouseMove != null)
         {
            this.FOnBuffMouseMove(this,_loc5_.Name,_loc3_,_loc5_.Description);
         }
      }
      
      protected function OnRollOut(param1:MouseEvent) : void
      {
         if(this.FOnBuffMouseRollOut != null)
         {
            this.FOnBuffMouseRollOut(this);
         }
      }
      
      public function get BattleStage() : TBattleStage
      {
         return this.FBattleStage;
      }
      
      public function get OnEffectEnd() : Function
      {
         return this.FOnEffectEnd;
      }
      
      public function set OnEffectEnd(param1:Function) : void
      {
         this.FOnEffectEnd = param1;
      }
      
      public function get OnBuffMouseMove() : Function
      {
         return this.FOnBuffMouseMove;
      }
      
      public function set OnBuffMouseMove(param1:Function) : void
      {
         this.FOnBuffMouseMove = param1;
      }
      
      public function get OnBuffMouseRollOut() : Function
      {
         return this.FOnBuffMouseRollOut;
      }
      
      public function set OnBuffMouseRollOut(param1:Function) : void
      {
         this.FOnBuffMouseRollOut = param1;
      }
      
      public function get OnBigSkill() : Function
      {
         return this.FOnBigSkill;
      }
      
      public function set OnBigSkill(param1:Function) : void
      {
         this.FOnBigSkill = param1;
      }
      
      public function get SoundId() : uint
      {
         if(FEnemy != null)
         {
            return FEnemy.Sound;
         }
         if(FHero != null)
         {
            return FHero.Sound;
         }
         return 0;
      }
      
      override public function Reset() : void
      {
         ClearItachiCrowClone();
         var _loc1_:Sprite = null;
         super.Reset();
         while(this.FBuffSpriteVect.length)
         {
            _loc1_ = this.FBuffSpriteVect.pop();
            this.SaveBitmapSprite(_loc1_);
         }
         this.FBuffIdVect.length = 0;
         this.FBuffTurnVect.length = 0;
         this.FBuffSpriteVect.length = 0;
         this.FIsNewBuffVect.length = 0;
         this.FBuffIdVect.length = 0;
         this.FBuffTurnVect.length = 0;
         this.FBuffSpriteVect.length = 0;
         this.FIsNewBuffVect.length = 0;
         this.FBattleStage = null;
         this.FTextFunction = null;
         FShaderBmp.visible = true;
         FHpBar.visible = true;
         FBuffSprite.visible = true;
         this.alpha = 1;
         FBitmap.filters = [];
         this.filters = [];
         FSkillId = 0;
         AntiColorBlackWhite = false;
         FBitmap.visible = true;
         TweenUtil.removeTween(this,false);
         this.DelStatus(CONST_BATTLE.TEXT_FIGHT_STATUS_OtherTurn);
      }
      
      override public function ActivePlay(param1:int, param2:int = 0, param3:Vector.<TRole> = null, param4:Vector.<TTargetInfo> = null, param5:Function = null, param6:uint = 0, param7:Boolean = false) : void
      {
         var EndShake:Function;
         var EndDie:Function;
         var Index:uint = 0;
         var DeadSkillEffectId:uint = 0;
         var StampAnger:int = 0;
         var Type:int = param1;
         var SkillId:int = param2;
         var Target:Vector.<TRole> = param3;
         var Results:Vector.<TTargetInfo> = param4;
         var Callback:Function = param5;
         var Time:uint = param6;
         var NoTextEffect:Boolean = param7;
         super.ActivePlay(Type,SkillId,Target,Results,Callback,Time);
         if(Type == TYPE_ACTIVE_DEADSKILL && Target != null)
         {
            if(this.FTextFunction != null)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,Camp == 0 ? -1 : 1,x,y - RoleHeight,0,false,CONST_BATTLE.TEXT_FIGHT_STATUS_DeadSkill);
            }
            Index = 0;
            while(Index < Target.length)
            {
               if(Results[Index].CMD != TTargetInfo.CMD_NONE)
               {
                  if(Target[Index].Camp == Camp)
                  {
                     DeadSkillEffectId = uint(CONST_BATTLE.Public_Effect_DeadSkillEffect_Friend);
                  }
                  else
                  {
                     DeadSkillEffectId = uint(CONST_BATTLE.Public_Effect_DeadSkillEffect_Enemy);
                  }
                  Target[Index].AddEffect({
                     "target":2,
                     "effectId":DeadSkillEffectId,
                     "anmyhp":{
                        "1":100,
                        "checkDie":1
                     },
                     "friendhp":{"1":100}
                  },this,Vector.<TRole>([Target[Index]]),Vector.<TTargetInfo>([Results[Index]]));
               }
               if(Results[Index].ResultInfo.CMD == TTargetInfo.CMD_ATTACKEX)
               {
                  if(Results[Index].ResultInfo.HurtAnger > 0)
                  {
                     StampAnger = Math.min(Results[Index].ResultInfo.HurtAnger,Target[Index].CurAnger);
                  }
                  else
                  {
                     StampAnger = Results[Index].ResultInfo.HurtAnger;
                  }
                  Target[Index].AddAngerTextEffect(-StampAnger);
               }
               Target[Index].CurAnger -= Results[Index].ResultInfo.HurtAnger;
               Index++;
            }
            if(Callback != null)
            {
               Callback(Time);
            }
            return;
         }
         if(FIsDie)
         {
            if(Callback != null)
            {
               Callback(0);
            }
            return;
         }
         FSkillId = SkillId;
         FTargets = Target;
         FResults = Results;
         FSkilling = IsSkill(FSkillId);
         ++FCombatVfxSerial;
         if(FId == 11120991)
         {
            FGaaraVfxStarted = false;
         }
         if(FId == 11120990)
         {
            FNagatoVfxStarted = false;
         }
         if(FId == 11120970)
         {
            FSasukeVfxStarted = false;
         }
         if(FId == 11120960)
         {
            FItachiVfxStarted = false;
         }
         if(FId == 11120950)
         {
            FMechaVfxStarted = false;
            if(FSkillId == 13121109)
            {
               FMechaBeast = true;
            }
         }
         if(FId == 11120940)
         {
            FHashiramaVfxStarted = false;
         }
         if(FId == 11120930)
         {
            FPainVfxStarted = false;
         }
         if(FId == 11120920)
         {
            FObitoVfxStarted = false;
         }
         if(FId == 11120903 && (Type == TYPE_ACTIVE_ATTACK || Type == TYPE_ACTIVE_SKILL))
         {
            FJiraiyaVfxStarted = false;
            FJiraiyaVfxHit = false;
         }
         if(Type == TYPE_ACTIVE_FIGHT_IDLE)
         {
            PlayFightIdle();
            this.CheckDirection();
         }
         else if(Type == TYPE_ACTIVE_ATTACK)
         {
            this.DelStatus(CONST_BATTLE.TEXT_FIGHT_STATUS_OtherTurn,CONST_BATTLE.TEXT_FIGHT_STATUS_Punch);
            GetAttackEffect();
            FCallBackDict[TYPE_ACTIVE_ATTACK] = Callback;
            FTimeDict[TYPE_ACTIVE_ATTACK] = Time;
            PlayAttack();
         }
         else if(Type == TYPE_ACTIVE_ATTACKED)
         {
            FCallBackDict[TYPE_ACTIVE_ATTACKED] = Callback;
            FTimeDict[TYPE_ACTIVE_ATTACKED] = Time;
            PlayAttacked();
         }
         else if(Type == TYPE_ACTIVE_SKILL)
         {
            GetAttackEffect();
            FCallBackDict[TYPE_ACTIVE_SKILL] = Callback;
            FTimeDict[TYPE_ACTIVE_SKILL] = Time;
            FSkillId = 0;
            this.PlayShowUI(SkillId);
         }
         else if(Type == TYPE_ACTIVE_DODGE)
         {
            EndShake = function():void
            {
               if(Callback != null)
               {
                  Callback(Time);
               }
            };
            if(!NoTextEffect)
            {
               TEffectControl.Retreat(this);
               FCallBackDict[TYPE_ACTIVE_DODGE] = Callback;
               FTimeDict[TYPE_ACTIVE_DODGE] = Time;
               if(this.FTextFunction != null)
               {
                  this.FTextFunction(TBattleStage.TYPETEXT_Float,Camp == 0 ? -1 : 1,x,y - RoleHeight,0,false,CONST_BATTLE.TEXT_FIGHT_STATUS_Miss);
               }
            }
            else
            {
               EndShake();
            }
         }
         else if(Type == TYPE_ACTIVE_GRIDFILE)
         {
            if(this.FStatusGridFile)
            {
               return;
            }
            this.FStatusGridFile = true;
            FCallBackDict[TYPE_ACTIVE_GRIDFILE] = Callback;
            FTimeDict[TYPE_ACTIVE_GRIDFILE] = Time;
            if(this.FTextFunction != null)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,Camp == 0 ? -1 : 1,x,y - RoleHeight,0,false,CONST_BATTLE.TEXT_FIGHT_STATUS_Counterattack);
            }
            TEffectControl.ShowPublicEffect(FEffectSprite,CONST_BATTLE.Public_Effect_Stakes,0,0,this.ShowGridFile);
         }
         else if(Type == TYPE_ACTIVE_DIE)
         {
            EndDie = function():void
            {
               if(!FIsDie)
               {
                  return;
               }
               if(Callback != null)
               {
                  Callback(Time);
               }
            };
            FIsDie = true;
            FShaderBmp.visible = false;
            FHpBar.visible = false;
            FBuffSprite.visible = false;
            this.FHideFrame = 0;
            FBitmap.bitmapData = FBitmap.bitmapData.clone();
            FBitmap.filters = [TUtilityFilter.rBlackFilters];
            FCallBackDict[TYPE_ACTIVE_DIE] = Callback;
            FTimeDict[TYPE_ACTIVE_DIE] = Time;
            if(Camp == 0)
            {
               TweenUtil.to(this,1000 / TBattleHandle.PlaybackRate,{
                  "x":this.x - 20,
                  "filters":[TUtilityFilter.ActiveDie],
                  "alpha":0,
                  "ease":Expo.easeOut,
                  "onComplete":EndDie
               });
            }
            else
            {
               TweenUtil.to(this,1000 / TBattleHandle.PlaybackRate,{
                  "x":this.x + 20,
                  "filters":[TUtilityFilter.ActiveDie],
                  "alpha":0,
                  "ease":Expo.easeOut,
                  "onComplete":EndDie
               });
            }
         }
      }
      
      public function SetPosition(param1:Number, param2:Number) : void
      {
         FIdlePosition[0] = param1;
         FIdlePosition[1] = param2;
         this.x = param1;
         this.y = param2;
      }
      
      public function OnNextCommand(param1:int = 0) : void
      {
         if(this.FOnEffectEnd != null)
         {
            if(param1 > 0)
            {
               TBattleHandle.PlaybackTimeout(this.FOnEffectEnd,param1);
            }
            else
            {
               this.FOnEffectEnd();
            }
         }
      }
      
      public function CheckTextEffect(param1:TTargetInfo) : void
      {
         if(param1.TargetStatus & CONST_BATTLE.ActiveType_NoAddAnger)
         {
            param1.TargetStatus -= CONST_BATTLE.ActiveType_NoAddAnger;
            this.AddTextEffect(CONST_BATTLE.ActiveType_NoAddAnger);
         }
         if(param1.TargetStatus & CONST_BATTLE.ActiveType_NoSkill)
         {
            param1.TargetStatus -= CONST_BATTLE.ActiveType_NoSkill;
            this.AddTextEffect(CONST_BATTLE.ActiveType_NoSkill);
         }
         if(param1.TargetStatus & CONST_BATTLE.ActiveType_NoAddHp)
         {
            param1.TargetStatus -= CONST_BATTLE.ActiveType_NoAddHp;
            this.AddTextEffect(CONST_BATTLE.ActiveType_NoAddHp);
         }
         if(param1.TargetStatus & CONST_BATTLE.ActiveType_NoAttack)
         {
            param1.TargetStatus -= CONST_BATTLE.ActiveType_NoAttack;
            this.AddTextEffect(CONST_BATTLE.ActiveType_NoAttack);
         }
         if(param1.TargetStatus & CONST_BATTLE.ActiveType_BeStone)
         {
            param1.TargetStatus -= CONST_BATTLE.ActiveType_BeStone;
            this.AddTextEffect(CONST_BATTLE.ActiveType_BeStone);
         }
         if(param1.TargetStatus & CONST_BATTLE.ActiveType_Nothingness)
         {
            param1.TargetStatus -= CONST_BATTLE.ActiveType_Nothingness;
            this.AddTextEffect(CONST_BATTLE.ActiveType_Nothingness);
         }
         if(param1.TargetStatus & CONST_BATTLE.ActiveType_AllMiss)
         {
            param1.TargetStatus -= CONST_BATTLE.ActiveType_AllMiss;
            this.AddTextEffect(CONST_BATTLE.ActiveType_AllMiss);
         }
         if(param1.TargetStatus & CONST_BATTLE.ActiveType_Confusion)
         {
            param1.TargetStatus -= CONST_BATTLE.ActiveType_Confusion;
            this.AddTextEffect(CONST_BATTLE.ActiveType_Confusion);
         }
         if(param1.TargetStatus & CONST_BATTLE.ActiveType_ImmNoAnger)
         {
            param1.TargetStatus -= CONST_BATTLE.ActiveType_ImmNoAnger;
            this.AddTextEffect(CONST_BATTLE.ActiveType_ImmNoAnger);
         }
         if(param1.TargetStatus & CONST_BATTLE.ActiveType_ImmNoSkill)
         {
            param1.TargetStatus -= CONST_BATTLE.ActiveType_ImmNoSkill;
            this.AddTextEffect(CONST_BATTLE.ActiveType_ImmNoSkill);
         }
         if(param1.TargetStatus & CONST_BATTLE.ActiveType_ImmNoHeal)
         {
            param1.TargetStatus -= CONST_BATTLE.ActiveType_ImmNoHeal;
            this.AddTextEffect(CONST_BATTLE.ActiveType_ImmNoHeal);
         }
         if(param1.TargetStatus & CONST_BATTLE.ActiveType_ImmStone)
         {
            param1.TargetStatus -= CONST_BATTLE.ActiveType_ImmStone;
            this.AddTextEffect(CONST_BATTLE.ActiveType_ImmStone);
         }
         if(param1.TargetStatus & CONST_BATTLE.ActiveType_ImmFake)
         {
            param1.TargetStatus -= CONST_BATTLE.ActiveType_ImmFake;
            this.AddTextEffect(CONST_BATTLE.ActiveType_ImmFake);
         }
         if(param1.TargetStatus & CONST_BATTLE.ActiveType_ImmNoAttack)
         {
            param1.TargetStatus -= CONST_BATTLE.ActiveType_ImmNoAttack;
            this.AddTextEffect(CONST_BATTLE.ActiveType_ImmNoAttack);
         }
         if(param1.TargetStatus & CONST_BATTLE.ActiveType_ImmConfusion)
         {
            param1.TargetStatus -= CONST_BATTLE.ActiveType_ImmConfusion;
            this.AddTextEffect(CONST_BATTLE.ActiveType_ImmConfusion);
         }
         if(param1.TargetStatus & CONST_BATTLE.ActiveType_ImmAllMiss)
         {
            param1.TargetStatus -= CONST_BATTLE.ActiveType_ImmAllMiss;
            this.AddTextEffect(CONST_BATTLE.ActiveType_ImmAllMiss);
         }
         if(param1.TargetStatus & CONST_BATTLE.ActiveType_ImmMutilate)
         {
            param1.TargetStatus -= CONST_BATTLE.ActiveType_ImmMutilate;
            this.AddTextEffect(CONST_BATTLE.ActiveType_ImmMutilate);
         }
      }
      
      public function PassiveSkillPlay(param1:Vector.<TRole>, param2:Vector.<TTargetInfo>, param3:uint) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:TTargetInfo = null;
         var _loc6_:TRole = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            _loc6_ = param1[_loc4_];
            _loc5_ = param2[_loc4_];
            if(_loc5_.CMD == TTargetInfo.CMD_FLOAT)
            {
               _loc6_.AddTextEffectByCMD(_loc5_);
               _loc4_++;
            }
            else
            {
               _loc6_.CheckTextEffect(_loc5_);
               if(_loc5_.CMD == TTargetInfo.CMD_ATTRBUFF || _loc5_.CMD == TTargetInfo.CMD_HURTBUFF || _loc5_.CMD == TTargetInfo.CMD_CONTROLBUFF)
               {
                  this.AddBuffs(this,param2);
               }
               else
               {
                  _loc7_ = _loc5_.ResultInfo.HurtHp;
                  _loc8_ = _loc5_.ResultInfo.HurtAnger;
                  if(_loc6_.Camp == Camp || _loc7_ < 0)
                  {
                     _loc6_.ChangeHP(_loc7_);
                     if(_loc7_ > 0)
                     {
                        _loc6_.CheckDie();
                     }
                     if(this.FTextFunction != null)
                     {
                        this.FTextFunction(TBattleStage.TYPETEXT_Float,_loc6_.Camp == 0 ? -1 : 1,_loc6_.x,_loc6_.y - _loc6_.RoleHeight,_loc7_ > 0 ? String(_loc7_) : "+" + int(Math.abs(_loc7_)),false);
                     }
                  }
                  else if(_loc7_ != 0)
                  {
                     _loc6_.ChangeHP(_loc7_);
                     if(_loc7_ > 0)
                     {
                        _loc6_.CheckDie();
                     }
                     _loc6_.ActivePlay(TActive.TYPE_ACTIVE_ATTACKED,0,null,Vector.<TTargetInfo>([_loc5_]));
                     if(this.FTextFunction != null)
                     {
                        this.FTextFunction(TBattleStage.TYPETEXT_Float,_loc6_.Camp == 0 ? -1 : 1,_loc6_.x,_loc6_.y - _loc6_.RoleHeight,String(_loc7_),false);
                     }
                  }
                  if(_loc8_ != 0)
                  {
                     if(_loc5_.CMD == TTargetInfo.CMD_ATTACKEX)
                     {
                        if(_loc8_ > 0)
                        {
                           _loc9_ = Math.min(_loc8_,_loc6_.CurAnger);
                        }
                        else
                        {
                           _loc9_ = _loc8_;
                        }
                        _loc6_.AddAngerTextEffect(-_loc9_);
                     }
                     _loc6_.CurAnger -= _loc8_;
                  }
               }
               _loc4_++;
            }
         }
         this.OnNextCommand(param3);
      }
      
      public function RoundSkill(param1:Vector.<TTargetInfo>, param2:Vector.<TRole>) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:TRole = null;
         var _loc5_:int = 0;
         if(param1 != null)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               _loc4_ = param2[_loc3_];
               _loc5_ = param1[_loc3_].ResultInfo.HurtHp;
               _loc4_.CurHealth -= _loc5_;
               if(this.FTextFunction != null)
               {
                  if(_loc5_ < 0)
                  {
                     this.FTextFunction(TBattleStage.TYPETEXT_Float,_loc4_.Camp == 0 ? -1 : 1,_loc4_.x,_loc4_.y - _loc4_.RoleHeight,"+" + int(Math.abs(_loc5_)),false);
                  }
                  else
                  {
                     this.FTextFunction(TBattleStage.TYPETEXT_Float,_loc4_.Camp == 0 ? -1 : 1,_loc4_.x,_loc4_.y - _loc4_.RoleHeight,String(_loc5_));
                  }
               }
               if(_loc4_.CurHealth < 0)
               {
                  _loc4_.CheckDie();
               }
               _loc3_++;
            }
         }
      }
      
      public function CommandPlay(param1:int, param2:Vector.<TRole>, param3:Vector.<TTargetInfo>, param4:uint) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         if(param1 == 0)
         {
            _loc6_ = param3.length;
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               param2[_loc5_].CheckTextEffect(param3[_loc5_]);
               _loc5_++;
            }
            this.OnNextCommand(param4);
         }
         else
         {
            this.ActivePlay(ActiveType(param1),param1,param2,param3,this.OnNextCommand,param4);
         }
      }
      
      public function AddTextEffect(param1:int) : void
      {
         var _loc2_:TGoneWord = null;
         if(this.FTextFunction != null)
         {
            if(param1 & CONST_BATTLE.ActiveType_Help)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Stand,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_Help);
            }
            if(param1 & CONST_BATTLE.ActiveType_Punch)
            {
               if(param1 & CONST_BATTLE.ActiveType_Hit)
               {
                  _loc2_ = this.FTextFunction(TBattleStage.TYPETEXT_Hold,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_OtherTurn);
                  this.DelStatus(CONST_BATTLE.TEXT_FIGHT_STATUS_OtherTurn);
                  this.FStatusGoneWordDict[CONST_BATTLE.TEXT_FIGHT_STATUS_OtherTurn] = _loc2_;
               }
               else
               {
                  this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_OtherTurnLost);
               }
            }
            if(param1 & CONST_BATTLE.ActiveType_ImmCtrl)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Stand,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_Lost);
            }
            if(param1 & CONST_BATTLE.ActiveType_ImmCalm)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Stand,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_Lost);
            }
            if(param1 & CONST_BATTLE.ActiveType_NoAddAnger)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_NoAddAnger);
            }
            if(param1 & CONST_BATTLE.ActiveType_NoSkill)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_NoSkill);
            }
            if(param1 & CONST_BATTLE.ActiveType_NoAddHp)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_NoAddHp);
            }
            if(param1 & CONST_BATTLE.ActiveType_NoAttack)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_NoAttack);
            }
            if(param1 & CONST_BATTLE.ActiveType_BeStone)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_BeStone);
            }
            if(param1 & CONST_BATTLE.ActiveType_Nothingness)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_Nothingness);
            }
            if(param1 & CONST_BATTLE.ActiveType_AllMiss)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_AllMiss);
            }
            if(param1 & CONST_BATTLE.ActiveType_Confusion)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_Confusion);
            }
            if(param1 & CONST_BATTLE.ActiveType_ImmNoAnger)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_ImmNoAnger);
            }
            if(param1 & CONST_BATTLE.ActiveType_ImmNoSkill)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_ImmNoSkill);
            }
            if(param1 & CONST_BATTLE.ActiveType_ImmNoHeal)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_ImmNoHeal);
            }
            if(param1 & CONST_BATTLE.ActiveType_ImmStone)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_ImmStone);
            }
            if(param1 & CONST_BATTLE.ActiveType_ImmFake)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_ImmFake);
            }
            if(param1 & CONST_BATTLE.ActiveType_ImmNoAttack)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_ImmNoAttack);
            }
            if(param1 & CONST_BATTLE.ActiveType_ImmConfusion)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_ImmConfusion);
            }
            if(param1 & CONST_BATTLE.ActiveType_ImmAllMiss)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_ImmConfusion);
            }
            if(param1 & CONST_BATTLE.ActiveType_ImmMutilate)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_ImmMutilate);
            }
            if(param1 & CONST_BATTLE.ActiveType_Ice)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_Ice);
            }
            if(param1 & CONST_BATTLE.ActiveType_Invincible)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - Math.min(this.RoleHeight,180),"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_Invincible);
            }
            if(param1 & CONST_BATTLE.ActiveType_BeatBack)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - Math.min(this.RoleHeight,180),"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_BeatBack);
            }
         }
      }
      
      public function AddAngerTextEffect(param1:int) : void
      {
         if(this.FTextFunction != null)
         {
            this.FTextFunction(TBattleStage.TYPETEXT_UpNumber,Camp == 0 ? -1 : 1,x - 50,y - RoleHeight - 50,(param1 > 0 ? "+" : "") + param1,false,0,param1 > 0 ? 4278309631 : 4290728191,param1 > 0 ? 4278265408 : 4281008199);
         }
      }
      
      public function AddEffect(param1:Object, param2:TRole, param3:Vector.<TRole> = null, param4:Vector.<TTargetInfo> = null, param5:Number = 0, param6:Number = 0) : void
      {
         TEffectControl.ShowEffect(this,param1.effectId,param1,param2,this,param3,param4,param5,param6,0,0,this.FTextFunction);
      }
      
      private function JiraiyaRasenganPose() : Object
      {
         var hands:Array = [[40,-65],[32.5,-66.85],[25,-68.7],[17.5,-70.55],[10,-72.4],[6.48,-97.84],[2.96,-123.28],[-0.56,-148.72],[-4.08,-174.16],[-7.6,-199.6],[-8.114,-196.229],[-8.629,-192.857],[-9.143,-189.486],[-9.657,-186.114],[-10.171,-182.743],[-10.686,-179.371],[-11.2,-176],[-11.2,-176],[-11.2,-176],[-11.2,-176],[-11.2,-176],[-11.2,-176],[-11.2,-176],[4.72,-145.28],[20.64,-114.56],[36.56,-83.84],[52.48,-53.12],[68.4,-22.4],[45.733,-15.2],[23.067,-8],[0.4,-0.8],[1.36,-2.56],[2.32,-4.32],[3.28,-6.08],[4.24,-7.84],[5.2,-9.6],[5.829,-15.829],[6.457,-22.057],[7.086,-28.286],[7.714,-34.514],[8.343,-40.743],[8.971,-46.971],[9.6,-53.2],[14.667,-55.167],[19.733,-57.133],[24.8,-59.1],[29.867,-61.067],[34.933,-63.033],[40,-65]];
         var frame:int = Math.max(0,Math.min(48,FFrameIndex));
         var palm:Array = hands[frame];
         var contact:Point = new Point(90,-25);
         if(FTargets != null)
         {
            var i:int = 0;
            while(i < FTargets.length)
            {
               if(FTargets[i] != null && FTargets[i] != this && FTargets[i].Camp != Camp)
               {
                  contact = globalToLocal(FTargets[i].localToGlobal(new Point(0,-25)));
                  break;
               }
               i++;
            }
         }
         var travel:Number = frame <= 22 ? 0 : (frame <= 30 ? Math.pow((frame - 22) / 8,1.4) : (frame <= 38 ? 1 : Math.max(0,1 - (frame - 38) / 10)));
         var rise:Number = frame <= 4 ? 0 : (frame < 16 ? Math.sin((frame - 4) / 12 * Math.PI / 2) : (frame <= 22 ? 1 : (frame < 30 ? 1 - Math.pow((frame - 22) / 8,2) : 0)));
         var ground:Point = FBattleStage.globalToLocal(localToGlobal(new Point(0,0)));
         var lift:Number = Math.min(145,Math.max(0,ground.y + Number(palm[1]) - 160)) * rise;
         return {
            "x":(contact.x - Number(hands[30][0])) * travel,
            "y":(contact.y - Number(hands[30][1])) * travel - lift,
            "handX":Number(palm[0]),
            "handY":Number(palm[1])
         };
      }
      
      private function UpdateJiraiyaVfx() : void
      {
         if(FId != 11120903 || FSkillId < 13120911 || FSkillId > 13120916 || FIndex != TYPE_ACTIVE_ATTACK && FIndex != TYPE_ACTIVE_SKILL)
         {
            return;
         }
         if(!FJiraiyaVfxStarted)
         {
            FJiraiyaVfxStarted = true;
            this.ShowJiraiyaVfx(FSkillId,false);
         }
         var hits:Object = {
            "13120911":24,
            "13120912":32,
            "13120913":30,
            "13120914":27,
            "13120915":8,
            "13120916":24
         };
         if(!FJiraiyaVfxHit && FFrameIndex >= int(hits[FSkillId]))
         {
            FJiraiyaVfxHit = true;
            this.ShowJiraiyaVfx(FSkillId,true);
         }
      }
      
      private function ShowJiraiyaVfx(skill:int, impact:Boolean) : void
      {
         var caster:TRole;
         var origin:Point;
         var targets:Array;
         var seen:Object;
         var key:String;
         var n:int;
         var direction:Number;
         var color:uint;
         var layer:Sprite;
         var shade:Sprite;
         var started:int;
         var lifetime:int;
         var strength:Number;
         var markers:Object;
         var animate:Function;
         var cleanup:Function;
         var host:DisplayObjectContainer = this.FBattleStage;
         if(host == null || host.stage == null)
         {
            return;
         }
         caster = this;
         origin = host.globalToLocal(localToGlobal(new Point(0,-48)));
         targets = [];
         seen = {};
         if(FTargets != null)
         {
            n = 0;
            while(n < FTargets.length)
            {
               if(!(FTargets[n] == null || FTargets[n] == this || FResults == null || n >= FResults.length))
               {
                  if(!(FResults[n].CMD != TTargetInfo.CMD_ATTACK && FResults[n].CMD != TTargetInfo.CMD_ATTACKEX))
                  {
                     if(FResults[n].ResultInfo.HurtHp >= 0)
                     {
                        key = FTargets[n].Camp + "_" + FTargets[n].Pos;
                        if(!seen[key])
                        {
                           seen[key] = true;
                           targets.push(host.globalToLocal(FTargets[n].localToGlobal(new Point(0,-60))));
                        }
                     }
                  }
               }
               n++;
            }
         }
         if(targets.length == 0)
         {
            targets.push(new Point(origin.x + (Camp == 0 ? 340 : -340),origin.y));
         }
         direction = targets[0].x >= origin.x ? 1 : -1;
         color = uint(skill == 13120913 ? 4382719 : (skill == 13120912 ? 16766042 : (skill == 13120911 ? 14578524 : (skill == 13120914 ? 14939903 : 16770698))));
         if(skill == 13120911 && impact)
         {
            SetJiraiyaBarrier(host,true);
         }
         layer = new Sprite();
         layer.name = "jiraiyaSkillVfx";
         layer.mouseEnabled = false;
         layer.mouseChildren = false;
         layer.blendMode = skill == 13120911 ? BlendMode.NORMAL : BlendMode.ADD;
         if(skill != 13120911)
         {
            layer.filters = [new GlowFilter(color,0.8,12,12,1.6,1)];
         }
         host.addChild(layer);
         shade = null;
         if(skill == 13120913 || skill == 13120912)
         {
            shade = new Sprite();
            shade.name = "jiraiyaCinematicShade";
            shade.mouseEnabled = false;
            shade.mouseChildren = false;
            shade.graphics.beginFill(skill == 13120913 ? 267305 : 2364422,0.65);
            shade.graphics.drawRect(0,0,1250,650);
            shade.graphics.endFill();
            host.addChildAt(shade,host.getChildByName("jiraiyaEsophagusBackdrop") == null ? 0 : 1);
         }
         started = TBattleHandle.PlaybackTime;
         lifetime = skill == 13120913 ? 1050 : (skill == 13120912 ? 900 : (skill == 13120911 ? 560 : 720));
         strength = impact ? (skill == 13120913 ? 12 : (skill == 13120911 ? 9 : (skill == 13120912 ? 8 : 4))) : 1;
         ShakeJiraiyaBattle(host,strength,impact ? 440 : 180);
         markers = {
            "13120911":24,
            "13120912":32,
            "13120913":30,
            "13120914":27,
            "13120915":8,
            "13120916":24
         };
         cleanup = function(event:Event = null):void
         {
            if(event != null && event.target != layer)
            {
               return;
            }
            layer.removeEventListener(Event.ENTER_FRAME,animate);
            layer.removeEventListener(Event.REMOVED_FROM_STAGE,cleanup);
            if(shade != null && shade.parent != null)
            {
               shade.parent.removeChild(shade);
            }
            if(layer.parent != null)
            {
               layer.parent.removeChild(layer);
            }
         };
         animate = function(event:Event):void
         {
            var elapsed:Number = TBattleHandle.PlaybackTime - started;
            var t:Number = impact ? elapsed / lifetime : Math.min(0.999,Math.max(0,caster.FFrameIndex) / Math.max(1,int(markers[skill])));
            if(host.stage == null || caster.stage == null || impact && t >= 1 || !impact && (caster.FSkillId != skill || caster.FJiraiyaVfxHit || elapsed > 8000))
            {
               cleanup();
               return;
            }
            if(!impact)
            {
               origin = host.globalToLocal(caster.localToGlobal(new Point(0,-48)));
            }
            var g:Graphics = layer.graphics;
            g.clear();
            layer.alpha = impact ? Math.min(1,(1 - t) * 2) : Math.min(1,elapsed / 130);
            if(shade != null)
            {
               shade.alpha = impact ? (1 - t) * 0.8 : Math.min(0.85,t * 2);
            }
            var mat:Matrix = new Matrix();
            if(skill == 13120911)
            {
               var close:Number = impact ? Math.max(0,1 - t * 2.7) : Math.max(0,(t - 0.45) / 0.55);
               var lip:Number = 335 * close;
               var i:int = 0;
               while(i < 2)
               {
                  g.lineStyle(5,5514026,1);
                  g.beginFill(10897987,1);
                  g.moveTo(0,i == 0 ? 0 : 650);
                  var j:int = 0;
                  while(j <= 20)
                  {
                     var px:Number = j * 62.5;
                     var py:Number = lip + (Math.sin(j * 1.9) * 17 + Math.sin(j * 0.7) * 12) * close;
                     g.lineTo(px,i == 0 ? py : 650 - py);
                     j++;
                  }
                  g.lineTo(1250,i == 0 ? 0 : 650);
                  g.endFill();
                  j = 0;
                  while(j < 25)
                  {
                     px = j * 53;
                     g.lineStyle(3,14516582,0.7);
                     g.moveTo(px,i == 0 ? 0 : 650);
                     g.curveTo(px - 24,i == 0 ? lip * 0.5 : 650 - lip * 0.5,px + Math.sin(j) * 18,i == 0 ? lip - 15 : 665 - lip);
                     j++;
                  }
                  i++;
               }
               if(impact && t < 0.26)
               {
                  g.lineStyle();
                  g.beginFill(16773835,Math.sin(t / 0.26 * Math.PI) * 0.85);
                  g.drawRect(0,0,1250,650);
                  g.endFill();
               }
               return;
            }
            if(skill == 13120913)
            {
               var point:Point = targets[0];
               if(!impact)
               {
                  var growth:Number = Math.sin(t * Math.PI / 2);
                  var radius:Number = 20 + growth * 46;
                  var pose:Object = caster.JiraiyaRasenganPose();
                  var hand:Point = host.globalToLocal(caster.localToGlobal(new Point(Number(pose.x) + Number(pose.handX),Number(pose.y) + Number(pose.handY))));
                  var swing:Number = -Math.PI / 2 + Math.max(0,Math.min(1,(caster.FFrameIndex - 22) / 8)) * Math.PI;
                  px = hand.x + direction * Math.cos(swing) * radius * 0.75;
                  py = hand.y + Math.sin(swing) * radius * 0.75;
               }
               else
               {
                  growth = Math.sin(Math.min(1,t * 2.4) * Math.PI / 2);
                  px = point.x;
                  py = point.y + 35;
                  radius = 48 + growth * 140;
                  g.lineStyle(7,14023423,0.85 * (1 - t));
                  g.drawEllipse(px - radius * 1.5,py - radius * 0.25,radius * 3,radius * 0.5);
                  if(t < 0.5)
                  {
                     g.lineStyle(32,6545151,0.35 * (1 - t * 2));
                     g.moveTo(px,py);
                     g.lineTo(px,py - 270);
                     g.lineStyle(10,16777215,0.8 * (1 - t * 2));
                     g.moveTo(px,py);
                     g.lineTo(px,py - 300);
                  }
                  i = 0;
                  while(i < 18)
                  {
                     var a:Number = i * 2.399;
                     var spread:Number = 40 + t * (100 + i % 4 * 35);
                     var dx:Number = px + Math.cos(a) * spread;
                     var dy:Number = py + Math.sin(a) * spread * 0.32 - Math.sin(t * Math.PI) * (25 + i % 5 * 12);
                     g.lineStyle(1,14218751,0.7);
                     g.beginFill(i % 2 == 0 ? 7900571 : 14218751,0.8);
                     g.moveTo(dx,dy - 5);
                     g.lineTo(dx + 6,dy + 3);
                     g.lineTo(dx - 4,dy + 5);
                     g.lineTo(dx,dy - 5);
                     g.endFill();
                     i++;
                  }
                  py -= radius * 0.6;
               }
               mat.createGradientBox(radius * 2,radius * 2,0,px - radius,py - radius);
               g.lineStyle(3,15531519,0.95);
               g.beginGradientFill(GradientType.RADIAL,[16777215,9827583,1477352],[0.95,0.6,0.12],[0,100,255],mat);
               g.drawCircle(px,py,radius);
               g.endFill();
               i = 0;
               while(i < 7)
               {
                  g.lineStyle(i % 2 == 0 ? 3.5 : 2,i % 2 == 0 ? 16777215 : 7532543,0.9);
                  j = 0;
                  while(j < 24)
                  {
                     a = i * Math.PI * 2 / 7 + j * 0.18 + elapsed * 0.012;
                     var r:Number = radius * (0.08 + j * 0.038);
                     var sx:Number = px + Math.cos(a) * r;
                     var sy:Number = py + Math.sin(a) * r;
                     if(j == 0)
                     {
                        g.moveTo(sx,sy);
                     }
                     else
                     {
                        g.lineTo(sx,sy);
                     }
                     j++;
                  }
                  i++;
               }
               g.lineStyle(5,15728639,0.9);
               g.drawEllipse(px - radius * 1.12,py - radius * 0.34,radius * 2.24,radius * 0.68);
               return;
            }
            if(skill == 13120912)
            {
               var reach:Number = impact ? 160 + t * 560 : 45 + t * 95;
               var front:Number = origin.x + direction * reach;
               var breadth:Number = impact ? 65 + t * 100 : 30 + t * 22;
               g.lineStyle();
               g.beginFill(16757798,impact ? 0.12 : 0.08);
               g.moveTo(origin.x,origin.y - 15);
               g.lineTo(front,origin.y - breadth);
               g.lineTo(front,origin.y + breadth);
               g.lineTo(origin.x,origin.y + 15);
               g.endFill();
               i = 0;
               while(i < 7)
               {
                  px = origin.x + direction * (30 + (elapsed * 0.45 + i * 61) % Math.max(60,reach));
                  radius = 20 + Math.abs(px - origin.x) * 0.15;
                  g.lineStyle(i % 2 == 0 ? 4 : 2,i % 2 == 0 ? 16774320 : 16758829,0.9 - i * 0.07);
                  g.drawEllipse(px - radius * 0.18,origin.y - radius,radius * 0.36,radius * 2);
                  g.lineStyle(3,16769137,0.8);
                  g.moveTo(px - direction * 35,origin.y + Math.sin(i * 2.3 + elapsed * 0.008) * radius);
                  g.lineTo(px + direction * 25,origin.y + Math.sin(i * 2.3 + elapsed * 0.008) * radius);
                  i++;
               }
               if(impact)
               {
                  i = 0;
                  while(i < targets.length)
                  {
                     point = targets[i];
                     radius = 24 + t * 70;
                     g.lineStyle(4,16771977,0.9 * (1 - t));
                     g.drawEllipse(point.x - radius * 0.5,point.y - radius,radius,radius * 2);
                     j = 0;
                     while(j < 8)
                     {
                        a = j * Math.PI / 4;
                        g.moveTo(point.x + Math.cos(a) * radius,point.y + Math.sin(a) * radius);
                        g.lineTo(point.x + Math.cos(a) * (radius + 35),point.y + Math.sin(a) * (radius + 35));
                        j++;
                     }
                     i++;
                  }
               }
               return;
            }
            if(skill == 13120914 && impact)
            {
               i = 0;
               while(i < targets.length)
               {
                  point = targets[i];
                  j = 0;
                  while(j < 9)
                  {
                     g.lineStyle(2 + j % 3,j % 2 == 0 ? 16777215 : 12177128,0.85);
                     g.moveTo(origin.x,origin.y - 20 + j * 5);
                     g.curveTo((origin.x + point.x) / 2,Math.min(origin.y,point.y) - 65 - j * 8,point.x + Math.sin(t * 20 + j) * 12,point.y - 20 + j * 6);
                     j++;
                  }
                  i++;
               }
               return;
            }
            g.lineStyle(3,color,0.8);
            g.drawEllipse(origin.x - 52 - 30 * t,origin.y + 34,104 + 60 * t,28);
            i = 0;
            while(i < 20)
            {
               a = i * 2.399;
               px = origin.x + Math.cos(a) * (18 + i % 4 * 9);
               py = origin.y + 45 - (elapsed * 0.15 + i * 11) % 165;
               g.lineStyle(1.5,color,0.8);
               g.moveTo(px,py + 12);
               g.lineTo(px,py);
               i++;
            }
         };
         layer.addEventListener(Event.ENTER_FRAME,animate);
         layer.addEventListener(Event.REMOVED_FROM_STAGE,cleanup);
         animate(null);
      }
      
      private function PlayObitoVfxAsset(name:String, host:DisplayObjectContainer, point:Point, width:Number, height:Number, delay:int = 0, mirrored:Boolean = false, follow:Boolean = false, behind:Boolean = false) : void
      {
         var caster:TRole;
         var layer:Sprite;
         var image:Bitmap;
         var edgeMask:Sprite;
         var gradient:Matrix;
         var field:DisplayObject;
         var outer:DisplayObjectContainer;
         var started:int;
         var lastFrame:int;
         var animate:Function;
         var cleanup:Function;
         var manifest:Object = ObitoVfxManifest();
         var clip:Object = manifest.clips[name];
         if(clip == null || host == null || host.stage == null)
         {
            return;
         }
         LoadObitoVfxAtlas(String(clip.atlas),manifest.atlases[clip.atlas]);
         caster = this;
         layer = new Sprite();
         layer.name = "obitoSkillVfx";
         layer.mouseEnabled = false;
         layer.mouseChildren = false;
         image = new Bitmap();
         image.smoothing = true;
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
         if(behind && host.parent != null)
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
         started = TBattleHandle.PlaybackTime + delay;
         lastFrame = -1;
         cleanup = function(event:Event = null):void
         {
            if(event != null && event.target != layer)
            {
               return;
            }
            layer.removeEventListener(Event.ENTER_FRAME,animate);
            layer.removeEventListener(Event.REMOVED_FROM_STAGE,cleanup);
            image.bitmapData = null;
            if(layer.parent != null)
            {
               layer.parent.removeChild(layer);
            }
         };
         animate = function(event:Event):void
         {
            var elapsed:int = TBattleHandle.PlaybackTime - started;
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
            var frames:Array = FObitoFxCache[clip.atlas] as Array;
            if(frames == null)
            {
               layer.visible = false;
               return;
            }
            layer.visible = true;
            var frame:int = int(elapsed / 40);
            if(frame != lastFrame)
            {
               image.bitmapData = frames[int(clip.timeline[frame])];
               image.width = width;
               image.height = height;
               image.x = -width * Number(clip.pivot[0]);
               image.y = -height * Number(clip.pivot[1]);
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
            var duration:Number = clip.timeline.length * 40;
            var fade:Number = Math.min(80,duration / 4);
            layer.alpha = Math.min(1,(elapsed + 40) / fade,Math.max(0,(duration - elapsed) / Math.min(120,duration / 4)));
         };
         layer.addEventListener(Event.ENTER_FRAME,animate);
         layer.addEventListener(Event.REMOVED_FROM_STAGE,cleanup);
         animate(null);
      }
      
      private function PlayObitoPowerFx(skill:int, at:Point, delay:int, charge:Boolean, intensity:Number = 1) : void
      {
         var layer:Sprite;
         var wood:Boolean;
         var spear:Boolean;
         var kamui:Boolean;
         var rage:Boolean;
         var color:uint;
         var bright:uint;
         var glow:Sprite;
         var debris:Sprite;
         var sparks:Sprite;
         var started:int;
         var duration:int;
         var animate:Function;
         var cleanup:Function;
         var host:DisplayObjectContainer = parent;
         if(host == null || host.stage == null)
         {
            return;
         }
         layer = new Sprite();
         layer.name = "obitoSkillVfx";
         layer.mouseEnabled = false;
         layer.mouseChildren = false;
         layer.x = at.x;
         layer.y = at.y;
         layer.scaleX = (scaleX < 0 ? -1 : 1) * intensity;
         layer.scaleY = intensity;
         host.addChild(layer);
         wood = skill == 13120952 || skill == 13120955 || skill == 13120957;
         spear = skill == 13120956 || skill == 13120958;
         kamui = skill == 13120951;
         rage = skill == 13120959;
         color = uint(kamui ? 9600255 : (wood ? 15055976 : (spear ? 16765557 : 16728124)));
         bright = uint(wood ? 16773557 : (kamui ? 14472959 : 16771277));
         glow = new Sprite();
         glow.blendMode = BlendMode.ADD;
         debris = new Sprite();
         sparks = new Sprite();
         sparks.blendMode = BlendMode.ADD;
         layer.addChild(debris);
         layer.addChild(glow);
         layer.addChild(sparks);
         sparks.filters = [new GlowFilter(color,0.65,5,5,1.5,1)];
         started = TBattleHandle.PlaybackTime + delay;
         duration = charge ? 560 : (rage ? 1250 : (wood ? 1050 : 820));
         cleanup = function(event:Event = null):void
         {
            if(event != null && event.target != layer)
            {
               return;
            }
            layer.removeEventListener(Event.ENTER_FRAME,animate);
            layer.removeEventListener(Event.REMOVED_FROM_STAGE,cleanup);
            if(layer.parent != null)
            {
               layer.parent.removeChild(layer);
            }
         };
         animate = function(event:Event):void
         {
            var elapsed:int = TBattleHandle.PlaybackTime - started;
            if(host.stage == null || elapsed >= duration)
            {
               cleanup();
               return;
            }
            if(elapsed < 0)
            {
               layer.visible = false;
               return;
            }
            layer.visible = true;
            var t:Number = elapsed / duration;
            var fade:Number = Math.pow(1 - t,1.4);
            var g:Graphics = glow.graphics;
            var d:Graphics = debris.graphics;
            var s:Graphics = sparks.graphics;
            g.clear();
            d.clear();
            s.clear();
            if(charge)
            {
               g.lineStyle(2,color,0.55 * Math.sin(Math.PI * t));
               var radius:Number = 62 - 22 * t;
               g.drawEllipse(-radius,-radius * 0.24,radius * 2,radius * 0.48);
               var i:int = 0;
               while(i < 3)
               {
                  var angle:Number = t * 5 + i * Math.PI * 2 / 3;
                  var j:int = 0;
                  while(j < 14)
                  {
                     radius = 78 - j * 3 - t * 18;
                     var x1:Number = Math.cos(angle - j * 0.13) * radius;
                     var y1:Number = -65 + Math.sin(angle - j * 0.13) * radius * 0.7;
                     g.lineStyle(1.8,color,(1 - j / 14) * 0.55 * Math.sin(Math.PI * t));
                     if(j == 0)
                     {
                        g.moveTo(x1,y1);
                     }
                     else
                     {
                        g.lineTo(x1,y1);
                     }
                     j++;
                  }
                  i++;
               }
               i = 0;
               while(i < 10)
               {
                  angle = i * 2.399;
                  radius = 90 * (1 - t) + 12;
                  s.beginFill(bright,Math.sin(Math.PI * t) * 0.7);
                  s.drawCircle(Math.cos(angle) * radius,-65 + Math.sin(angle) * radius * 0.65,1.4);
                  s.endFill();
                  i++;
               }
               return;
            }
            if(elapsed < 190)
            {
               var flashAlpha:Number = (1 - elapsed / 190) * 0.8;
               var gradient:Matrix = new Matrix();
               gradient.createGradientBox(200,200,0,-100,-165);
               g.beginGradientFill(GradientType.RADIAL,[bright,color,color],[flashAlpha,0.22 * flashAlpha,0],[0,90,255],gradient);
               g.drawCircle(0,-65,100);
               g.endFill();
               i = 0;
               while(i < 8)
               {
                  angle = i * Math.PI / 4 + 0.22;
                  radius = 30 + elapsed * 0.25;
                  s.lineStyle(i % 2 == 0 ? 3 : 1.2,bright,flashAlpha);
                  s.moveTo(Math.cos(angle) * 8,-65 + Math.sin(angle) * 8);
                  s.lineTo(Math.cos(angle) * radius,-65 + Math.sin(angle) * radius);
                  i++;
               }
            }
            radius = 28 + Math.sqrt(t) * (rage ? 205 : (wood ? 180 : 140));
            g.lineStyle(3 * (1 - t) + 0.4,color,fade * 0.7);
            g.drawEllipse(-radius,-radius * 0.25,radius * 2,radius * 0.5);
            g.lineStyle(1.2,bright,fade * 0.45);
            g.drawEllipse(-radius * 0.8,-radius * 0.2,radius * 1.6,radius * 0.4);
            if(kamui || rage)
            {
               i = 0;
               while(i < 3)
               {
                  j = 0;
                  while(j < 20)
                  {
                     angle = i * Math.PI * 2 / 3 + j * 0.105 + t * (kamui ? 5 : 2);
                     radius = (kamui ? 70 * (1 - t) : 50 + 110 * t) + j * 0.8;
                     g.lineStyle(2.5,color,fade * (1 - j / 24) * 0.7);
                     x1 = Math.cos(angle) * radius;
                     y1 = -70 + Math.sin(angle) * radius;
                     if(j == 0)
                     {
                        g.moveTo(x1,y1);
                     }
                     else
                     {
                        g.lineTo(x1,y1);
                     }
                     j++;
                  }
                  i++;
               }
            }
            if(!kamui)
            {
               i = 0;
               while(i < (wood ? 12 : 8))
               {
                  angle = i * 2.399 + 0.35;
                  radius = 28 + 95 * t;
                  var x0:Number = Math.cos(angle) * radius;
                  var y0:Number = Math.sin(angle) * radius * 0.24;
                  d.lineStyle(1,3679275,fade * 0.65);
                  d.moveTo(x0 * 0.3,y0 * 0.3);
                  d.lineTo(x0 * 0.66 + 5,y0 * 0.65);
                  d.lineTo(x0,y0);
                  x1 = Math.cos(angle) * (20 + 120 * t);
                  y1 = -8 - (wood ? 130 : 85) * Math.sin(Math.PI * t) + Math.sin(angle) * 30 + 65 * t * t;
                  var size:Number = (3 + i % 4) * fade;
                  d.lineStyle(1,15520411,fade * 0.6);
                  d.beginFill(i % 2 == 0 ? 7885118 : 11501908,fade);
                  d.moveTo(x1 - size,y1 + size);
                  d.lineTo(x1 + size * 0.4,y1 - size * 2.6);
                  d.lineTo(x1 + size,y1 + size);
                  d.lineTo(x1 - size,y1 + size);
                  d.endFill();
                  i++;
               }
            }
            if(spear || !wood && !kamui && !rage)
            {
               i = 0;
               while(i < (spear ? 3 : 2))
               {
                  var length:Number = (spear ? 120 : 90) * (1 - t * 0.4);
                  x0 = -length + 210 * t - i * 18;
                  y0 = -105 + i * 25;
                  s.lineStyle(3 - i * 0.7,i == 0 ? bright : color,fade * 0.85);
                  s.moveTo(x0,y0 + 45);
                  s.curveTo(x0 + length * 0.6,y0 - 20,x0 + length * 1.6,y0 - 8);
                  i++;
               }
            }
            i = 0;
            while(i < (rage ? 26 : 18))
            {
               angle = i * 2.399;
               radius = 20 + (65 + i % 7 * 14) * t;
               x1 = Math.cos(angle) * radius;
               y1 = -65 + Math.sin(angle) * radius * 0.65 - 20 * t + 60 * t * t;
               s.lineStyle(1.5,i % 3 == 0 ? bright : color,fade * 0.8);
               s.moveTo(x1,y1);
               s.lineTo(x1 - Math.cos(angle) * (6 + 8 * t),y1 - Math.sin(angle) * (6 + 8 * t));
               i++;
            }
         };
         layer.addEventListener(Event.ENTER_FRAME,animate);
         layer.addEventListener(Event.REMOVED_FROM_STAGE,cleanup);
         animate(null);
      }
      
      private function ObitoStandardPose(frame:TAnimationFrame) : void
      {
         if(FId != 11120920 || FSkillId != 13120953 && FSkillId != 13120954 || FIndex != TYPE_ACTIVE_ATTACK)
         {
            return;
         }
         if(FFrameIndex < 14 || FFrameIndex >= 50 || frame.Surface.width <= 1 || FTargets == null || FResults == null)
         {
            return;
         }
         var i:int = 0;
         while(i < FTargets.length && i < FResults.length)
         {
            var enemy:TRole = FTargets[i];
            if(!(enemy == null || enemy == this || enemy.Camp == Camp || FResults[i].CMD != TTargetInfo.CMD_ATTACK))
            {
               var point:Point = globalToLocal(enemy.localToGlobal(new Point()));
               FBitmap.x = point.x - 70 - frame.Surface.width / 2;
               FBitmap.y = point.y - frame.Pivot.Y;
               return;
            }
            i++;
         }
      }
      
      private function UpdateObitoVfx() : void
      {
         if(FId != 11120920 || FSkillId < 13120951 || FSkillId > 13120959 || FIndex != TYPE_ACTIVE_ATTACK && FIndex != TYPE_ACTIVE_SKILL || FObitoVfxStarted)
         {
            return;
         }
         FObitoVfxStarted = true;
         ShowObitoVfx(FSkillId);
      }
      
      private function ShowObitoVfx(skill:int) : void
      {
         var host:DisplayObjectContainer = parent;
         if(host == null || host.stage == null)
         {
            return;
         }
         var origin:Point = host.globalToLocal(localToGlobal(new Point()));
         var points:Array = [];
         var seen:Object = {};
         if(FTargets != null && FResults != null)
         {
            var n:int = 0;
            while(n < FTargets.length && n < FResults.length)
            {
               if(!(FTargets[n] == null || FTargets[n] == this || FResults[n].CMD != TTargetInfo.CMD_ATTACK || FResults[n].ResultInfo.HurtHp < 0))
               {
                  var key:String = FTargets[n].Camp + "_" + FTargets[n].Pos;
                  if(!seen[key])
                  {
                     seen[key] = true;
                     points.push(host.globalToLocal(FTargets[n].localToGlobal(new Point())));
                  }
               }
               n++;
            }
         }
         var effect:String = skill == 13120951 ? "DT1shenwei" : (skill == 13120952 ? "DTaoyi" : (skill == 13120953 || skill == 13120954 ? "DTpugong" : (skill == 13120955 || skill == 13120957 ? "dtpg" : (skill == 13120956 || skill == 13120958 ? "DTzhuida" : "DTbaozou"))));
         var manifest:Object = ObitoVfxManifest();
         var layers:Array = manifest.effects[effect] as Array;
         if(layers == null)
         {
            return;
         }
         var locations:Array = skill == 13120951 || skill == 13120959 || points.length == 0 ? [origin] : points;
         var impactTimes:Object = {
            "13120951":400,
            "13120952":800,
            "13120953":920,
            "13120954":920,
            "13120955":600,
            "13120956":760,
            "13120957":600,
            "13120958":760,
            "13120959":400
         };
         var impactDelay:int = int(impactTimes[skill]);
         PlayObitoPowerFx(skill,origin,0,true,0.85);
         for each(var impactPoint:Point in locations)
         {
            PlayObitoPowerFx(skill,impactPoint,impactDelay,false,locations.length > 1 ? 0.72 : 1);
         }
         var extent:Number = 1;
         for each(var layerName:String in layers)
         {
            var meta:Object = manifest.clips[layerName];
            extent = Math.max(extent,Number(meta.width) / Number(meta.renderScale));
         }
         var limit:Number = Number(manifest.layout[effect].width) * (locations.length > 1 ? 0.82 : 1);
         var factor:Number = limit / extent;
         for each(var point:Point in locations)
         {
            for each(var name:String in layers)
            {
               var clip:Object = manifest.clips[name];
               var w:Number = Number(clip.width) / Number(clip.renderScale) * factor;
               var h:Number = w * Number(clip.height) / Number(clip.width);
               var anchored:Point = new Point(point.x,point.y + Number(clip.offsetY));
               PlayObitoVfxAsset(name,host,anchored,w,h,0,scaleX < 0,false,false);
            }
         }
      }
      
      private function ShowObitoStatusText(message:String, color:uint = 12186746) : void
      {
         var owner:TRole;
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
         key = "obitoStatus_" + Camp + "_" + Pos + "_" + message;
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
            var prefix:String = "obitoStatus_" + owner.Camp + "_" + owner.Pos + "_";
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
      
      private function PlayPainVfxAsset(name:String, host:DisplayObjectContainer, point:Point, width:Number, height:Number, delay:int = 0, mirrored:Boolean = false, follow:Boolean = false, behind:Boolean = false, angle:Number = 0) : void
      {
         var caster:TRole;
         var layer:Sprite;
         var image:Bitmap;
         var edgeMask:Sprite;
         var gradient:Matrix;
         var field:DisplayObject;
         var outer:DisplayObjectContainer;
         var started:int;
         var rodSerial:uint;
         var rodSkill:int;
         var rodFrame:int;
         var lastFrame:int;
         var animate:Function;
         var cleanup:Function;
         var manifest:Object = PainVfxManifest();
         var clip:Object = manifest.clips[name];
         if(clip == null || host == null || host.stage == null)
         {
            return;
         }
         LoadPainVfxAtlas(String(clip.atlas),manifest.atlases[clip.atlas]);
         caster = this;
         layer = new Sprite();
         layer.name = "painSkillVfx";
         FPainActiveVfx.push(layer);
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
         if(behind && host.parent != null)
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
         rodSerial = FCombatVfxSerial;
         rodSkill = FSkillId;
         rodFrame = Math.max(0,FFrameIndex);
         started = TBattleHandle.PlaybackTime + delay;
         lastFrame = -1;
         cleanup = function(event:Event = null):void
         {
            if(event != null && event.target != layer)
            {
               return;
            }
            layer.removeEventListener(Event.ENTER_FRAME,animate);
            layer.removeEventListener(Event.REMOVED_FROM_STAGE,cleanup);
            image.bitmapData = null;
            if(layer.parent != null && (event == null || event.type != Event.REMOVED_FROM_STAGE))
            {
               layer.parent.removeChild(layer);
            }
         };
         animate = function(event:Event):void
         {
            if(caster.FCombatVfxSerial != rodSerial || caster.FSkillId != rodSkill)
            {
               cleanup();
               return;
            }
            var elapsed:int = (Math.max(0,caster.FFrameIndex) - rodFrame) * 40 - delay;
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
            var frameAtlas:String = clip.frameAtlases != null ? String(clip.frameAtlases[frame]) : String(clip.atlas);
            LoadPainVfxAtlas(frameAtlas,manifest.atlases[frameAtlas]);
            var frames:Array = FPainFxCache[frameAtlas] as Array;
            if(clip.frameAtlases != null)
            {
               var ahead:int = frame + 1;
               while(ahead < clip.frameAtlases.length)
               {
                  var nextAtlas:String = String(clip.frameAtlases[ahead]);
                  if(nextAtlas != frameAtlas)
                  {
                     LoadPainVfxAtlas(nextAtlas,manifest.atlases[nextAtlas]);
                     break;
                  }
                  ahead++;
               }
            }
            if(frames == null)
            {
               layer.visible = false;
               return;
            }
            layer.visible = true;
            if(frame != lastFrame)
            {
               image.bitmapData = frames[int(clip.timeline[frame])];
               image.width = width;
               image.height = height;
               image.x = -width * Number(clip.pivot[0]);
               image.y = -height * Number(clip.pivot[1]);
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
      
      private function UpdatePainVfx() : void
      {
         if(FId != 11120930 || FSkillId < 13120971 || FSkillId > 13120979 || FIndex != TYPE_ACTIVE_ATTACK && FIndex != TYPE_ACTIVE_SKILL || FPainVfxStarted)
         {
            return;
         }
         FPainVfxStarted = true;
         ShowPainVfx(FSkillId);
      }
      
      private function ShowPainLaserImpact(point:Point, width:Number, height:Number, delay:int) : void
      {
         var layer:Sprite;
         var started:int;
         var animate:Function;
         var cleanup:Function;
         var host:DisplayObjectContainer = FBattleStage;
         if(host == null || host.stage == null)
         {
            return;
         }
         layer = new Sprite();
         layer.name = "painSkillVfx";
         FPainActiveVfx.push(layer);
         layer.mouseEnabled = false;
         layer.mouseChildren = false;
         layer.x = point.x;
         layer.y = point.y;
         host.addChild(layer);
         started = TBattleHandle.PlaybackTime + delay;
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
            var elapsed:int = TBattleHandle.PlaybackTime - started;
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
               g.lineStyle(9 - ring * 2,ring == 0 ? 14942207 : 3522559,0.85 - ring * 0.15);
               g.beginFill(2793215,ring == 0 ? 0.12 : 0);
               g.drawEllipse(-rw / 2,-rh / 2,rw,rh);
               g.endFill();
               ring++;
            }
            var ray:int = 0;
            while(ray < 16)
            {
               var a:Number = ray * Math.PI / 8;
               g.lineStyle(ray % 3 == 0 ? 5 : 2,ray % 2 == 0 ? 15335423 : 5294847,0.9);
               g.moveTo(Math.cos(a) * width * 0.15,Math.sin(a) * height * 0.15);
               g.lineTo(Math.cos(a + 0.035) * width * (0.38 + t * 0.16),Math.sin(a + 0.035) * height * (0.38 + t * 0.16));
               g.lineTo(Math.cos(a) * width * (0.55 + t * 0.2),Math.sin(a) * height * (0.55 + t * 0.2));
               ray++;
            }
         };
         layer.addEventListener(Event.ENTER_FRAME,animate);
         layer.addEventListener(Event.REMOVED_FROM_STAGE,cleanup);
      }
      
      private function ShowPainVfx(skill:int) : void
      {
         for each(var prior:Sprite in FPainActiveVfx)
         {
            if(prior.parent != null)
            {
               prior.parent.removeChild(prior);
            }
         }
         FPainActiveVfx = [];
         var host:DisplayObjectContainer = FBattleStage;
         if(host == null || host.stage == null)
         {
            return;
         }
         var viewportTL:Point = host.globalToLocal(stage.localToGlobal(new Point(0,0)));
         var viewportBR:Point = host.globalToLocal(stage.localToGlobal(new Point(stage.stageWidth,stage.stageHeight)));
         var unit:Number = Math.abs(viewportBR.x - viewportTL.x) / 1250;
         var origin:Point = host.globalToLocal(localToGlobal(new Point()));
         var center:Point = new Point();
         var victims:Array = [];
         var count:int = 0;
         var seen:Object = {};
         if(FTargets != null && FResults != null)
         {
            var n:int = 0;
            while(n < FTargets.length && n < FResults.length)
            {
               if(!(FTargets[n] == null || FTargets[n] == this || FTargets[n].Camp == Camp || FResults[n].CMD != TTargetInfo.CMD_ATTACK || FResults[n].ResultInfo.HurtHp < 0))
               {
                  var key:String = FTargets[n].Camp + "_" + FTargets[n].Pos;
                  if(!seen[key])
                  {
                     seen[key] = true;
                     var p:Point = host.globalToLocal(FTargets[n].localToGlobal(new Point()));
                     victims.push(FBattleStage.globalToLocal(host.localToGlobal(new Point(p.x,p.y - 80))));
                     if(primary == null)
                     {
                        var primary:Point = p.clone();
                     }
                     center.x += p.x;
                     center.y += p.y;
                     count++;
                  }
               }
               n++;
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
         if(skill == 13120975 && primary != null)
         {
            center = primary.clone();
         }
         var effect:String = skill == 13120971 ? "PEaoyi1" : (skill == 13120974 ? "PEpugong1" : (skill == 13120975 ? "PEzhuida" : (skill == 13120976 ? "PEaoyi2" : (skill == 13120977 || skill == 13120978 ? "DASHEWAN_tongyongfuhuo" : "Peienchaoshenshenluotianzheng_aoyi"))));
         var manifest:Object = PainVfxManifest();
         var layers:Array = manifest.effects[effect] as Array;
         if(layers == null)
         {
            return;
         }
         var at:Point = skill == 13120976 || skill == 13120977 || skill == 13120978 ? origin : center;
         var limit:Number = (skill == 13120974 ? 1250 : (skill == 13120975 ? 1150 : (skill == 13120976 ? 1250 : (skill == 13120977 || skill == 13120978 ? 260 : (skill == 13120971 ? 1000 : 1400))))) * unit;
         var extent:Number = 1;
         for each(var layerName:String in layers)
         {
            var meta:Object = manifest.clips[layerName];
            if(meta.action != "texie")
            {
               extent = Math.max(extent,Number(meta.width) / Number(meta.renderScale));
            }
         }
         var factor:Number = limit / extent;
         for each(var name:String in layers)
         {
            var clip:Object = manifest.clips[name];
            var cutin:Boolean = clip.action == "texie";
            var screen:Boolean = cutin || clip.screen == true;
            var w:Number = screen ? Math.abs(viewportBR.x - viewportTL.x) : Number(clip.width) / Number(clip.renderScale) * factor;
            var h:Number = screen ? Math.abs(viewportBR.y - viewportTL.y) : w * Number(clip.height) / Number(clip.width);
            var location:Point = screen ? new Point((viewportTL.x + viewportBR.x) / 2,(viewportTL.y + viewportBR.y) / 2) : at.clone();
            if(skill == 13120974 && !screen)
            {
               location.y -= 40;
            }
            var paintHost:DisplayObjectContainer = screen ? FBattleStage : host;
            if(skill == 13120975 && !screen)
            {
               paintHost = FBattleStage;
               location = FBattleStage.globalToLocal(host.localToGlobal(at));
            }
            if(skill == 13120976 && !screen)
            {
               if(primary != null)
               {
                  var muzzle:Point = FBattleStage.globalToLocal(localToGlobal(new Point(330,-65)));
                  var aim:Point = FBattleStage.globalToLocal(host.localToGlobal(new Point(center.x,center.y - 90)));
                  var dx:Number = aim.x - muzzle.x;
                  var dy:Number = aim.y - muzzle.y;
                  var length:Number = Math.sqrt(dx * dx + dy * dy);
                  if(length >= 1)
                  {
                     var left:Number = aim.x;
                     var right:Number = aim.x;
                     var top:Number = aim.y;
                     var bottom:Number = aim.y;
                     var reach:Number = length;
                     for each(var enemyPoint:Point in victims)
                     {
                        left = Math.min(left,enemyPoint.x);
                        right = Math.max(right,enemyPoint.x);
                        top = Math.min(top,enemyPoint.y - 100);
                        bottom = Math.max(bottom,enemyPoint.y + 100);
                        var vx:Number = enemyPoint.x - muzzle.x;
                        var vy:Number = enemyPoint.y - muzzle.y;
                        reach = Math.max(reach,Math.sqrt(vx * vx + vy * vy));
                     }
                     location = muzzle;
                     paintHost = FBattleStage;
                     w = Math.max(1500 * unit,(reach + 220 * unit) / 0.42);
                     h = Math.max(850 * unit,(bottom - top + 160 * unit) * 2.2);
                     PlayPainVfxAsset(name,paintHost,location,w,h,0,false,false,false,Math.atan2(dy,dx) * 180 / Math.PI);
                     ShowPainLaserImpact(new Point((left + right) / 2,(top + bottom) / 2),Math.max(500,right - left + 320),Math.max(380,bottom - top + 180),1960);
                  }
               }
            }
            else
            {
               PlayPainVfxAsset(name,paintHost,location,w,h,0,screen ? false : (clip.flipFacing ? scaleX >= 0 : scaleX < 0),false,false);
            }
         }
      }
      
      private function PainFlightPose(frame:TAnimationFrame) : void
      {
         if(FId != 11120930 || FSkillId != 13120972 && FSkillId != 13120973 && FSkillId != 13120979 || FIndex != TYPE_ACTIVE_ATTACK && FIndex != TYPE_ACTIVE_SKILL || frame == null)
         {
            return;
         }
         var f:Number = FFrameIndex;
         if(f < 5 || f >= 145)
         {
            return;
         }
         var altitude:Number = 0;
         if(f < 50)
         {
            var t:Number = Math.max(0,(f - 5) / 45);
            altitude = 130 * t * t * (3 - 2 * t);
         }
         else if(f < 110)
         {
            t = Math.sin((f - 50) * Math.PI / 30);
            altitude = 130 + 6 * t * t;
         }
         else
         {
            t = Math.min(1,(f - 110) / 28);
            altitude = 130 * (1 - t * t * (3 - 2 * t));
         }
         FBitmap.x = -frame.Pivot.X;
         FBitmap.y = 5 - frame.Surface.height - altitude;
      }
      
      private function PainStrikePose(frame:TAnimationFrame) : void
      {
         if(FId != 11120930 || FSkillId != 13120971 && FSkillId != 13120975 || frame == null || FIndex != TYPE_ACTIVE_ATTACK && FIndex != TYPE_ACTIVE_SKILL)
         {
            return;
         }
         FBitmap.x = -frame.Pivot.X;
         FBitmap.y = -frame.Pivot.Y;
         if(FTargets == null || FResults == null || FSkillId == 13120975 && FFrameIndex < 14)
         {
            return;
         }
         var i:int = 0;
         while(i < FTargets.length && i < FResults.length)
         {
            var enemy:TRole = FTargets[i];
            if(!(enemy == null || enemy == this || enemy.Camp == Camp || FResults[i].CMD != TTargetInfo.CMD_ATTACK))
            {
               var point:Point = globalToLocal(enemy.localToGlobal(new Point()));
               var travel:Number = Math.min(1,Math.max(0,FFrameIndex / 10));
               var retreat:Number = Math.min(1,Math.max(0,(50 - FFrameIndex) / 15));
               travel = travel * travel * (3 - 2 * travel);
               retreat = retreat * retreat * (3 - 2 * retreat);
               var weight:Number = travel * retreat;
               var strikeX:Number = point.x - frame.Surface.width / 2 - (FSkillId == 13120971 ? 145 : 0);
               FBitmap.x += (strikeX - FBitmap.x) * weight;
               FBitmap.y += point.y * weight;
               return;
            }
            i++;
         }
      }
      
      private function RestorePainAfterRevival() : void
      {
         TweenUtil.removeTween(this,false);
         TweenUtil.removeTween(FBitmap,false);
         FIsDie = false;
         FWaitDie = false;
         FWaitNextCommand = false;
         FHideFrame = -1;
         FHasFrozen = false;
         FHasGiddy = false;
         FIsAntiColorBlackWhite = false;
         FIsRedAntiColor = false;
         FCallBackDict[TYPE_ACTIVE_DIE] = null;
         FTimeDict[TYPE_ACTIVE_DIE] = 0;
         FSkillId = 0;
         FSkilling = false;
         FPainVfxStarted = false;
         FPainFinal = true;
         alpha = 1;
         visible = true;
         filters = [];
         FBitmap.alpha = 1;
         FBitmap.visible = true;
         FBitmap.filters = [];
         FShaderBmp.visible = true;
         FHpBar.visible = true;
         FBuffSprite.visible = true;
         FFrozenBitmap.visible = false;
         FGiddyBitmap.visible = false;
         if(FIdlePosition != null)
         {
            x = FIdlePosition[0];
            y = FIdlePosition[1];
         }
         PlayFightIdle();
         var idle:TAnimationFrame = FCurSequence.GetAnimationFrameByIndex(0);
         if(idle != null)
         {
            FBitmap.bitmapData = idle.Surface;
            FBitmap.x = -idle.Pivot.X;
            FBitmap.y = -idle.Pivot.Y;
         }
      }
      
      private function ShowPainStatusText(message:String, color:uint = 12186746) : void
      {
         var owner:TRole;
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
         key = "painStatus_" + Camp + "_" + Pos + "_" + message;
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
            var prefix:String = "painStatus_" + owner.Camp + "_" + owner.Pos + "_";
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
      
      private function PlayHashiramaVfxAsset(name:String, host:DisplayObjectContainer, point:Point, width:Number, height:Number, delay:int = 0, mirrored:Boolean = false, follow:Boolean = false, behind:Boolean = false, angle:Number = 0) : void
      {
         var caster:TRole;
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
         var animate:Function;
         var cleanup:Function;
         var manifest:Object = HashiramaVfxManifest();
         var clip:Object = manifest.clips[name];
         if(clip == null || host == null || host.stage == null)
         {
            return;
         }
         LoadHashiramaVfxAtlas(String(clip.atlas),manifest.atlases[clip.atlas]);
         caster = this;
         layer = new Sprite();
         layer.name = "hashiramaSkillVfx";
         FHashiramaActiveVfx.push(layer);
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
         if(FSkillId == 13121009)
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
         started = TBattleHandle.PlaybackTime + delay;
         lastFrame = -1;
         cleanup = function(event:Event = null):void
         {
            if(event != null && event.target != layer)
            {
               return;
            }
            layer.removeEventListener(Event.ENTER_FRAME,animate);
            layer.removeEventListener(Event.REMOVED_FROM_STAGE,cleanup);
            image.bitmapData = null;
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
            var frameAtlas:String = clip.frameAtlases != null ? String(clip.frameAtlases[frame]) : String(clip.atlas);
            LoadHashiramaVfxAtlas(frameAtlas,manifest.atlases[frameAtlas]);
            var frames:Array = FHashiramaFxCache[frameAtlas] as Array;
            if(clip.frameAtlases != null)
            {
               var ahead:int = frame + 1;
               while(ahead < clip.frameAtlases.length)
               {
                  var nextAtlas:String = String(clip.frameAtlases[ahead]);
                  if(nextAtlas != frameAtlas)
                  {
                     LoadHashiramaVfxAtlas(nextAtlas,manifest.atlases[nextAtlas]);
                     break;
                  }
                  ahead++;
               }
            }
            if(frames == null)
            {
               layer.visible = false;
               return;
            }
            layer.visible = true;
            if(frame != lastFrame)
            {
               image.bitmapData = frames[int(clip.timeline[frame])];
               image.width = width;
               image.height = height;
               image.x = -width * Number(clip.pivot[0]);
               image.y = -height * Number(clip.pivot[1]);
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
      
      private function ShowHashiramaStatusText(message:String, color:uint = 12186746) : void
      {
         var owner:TRole;
         var key:String;
         var old:DisplayObject;
         var label:TextField;
         var started:int;
         var animate:Function;
         var cleanup:Function;
         var cleaned:Boolean = false;
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
            if(cleaned)
            {
               return;
            }
            cleaned = true;
            label.removeEventListener(Event.ENTER_FRAME,animate);
            label.removeEventListener(Event.REMOVED_FROM_STAGE,cleanup);
            if(label.parent != null && (event == null || event.type != Event.REMOVED_FROM_STAGE))
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
      
      private function ShowHashiramaImpact(point:Point, width:Number, height:Number, delay:int) : void
      {
         var layer:Sprite;
         var started:int;
         var caster:TRole;
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
         started = TBattleHandle.PlaybackTime + delay;
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
      
      private function UpdateHashiramaVfx() : void
      {
         if(FId != 11120940 || FSkillId < 13121001 || FSkillId > 13121010 || FIndex != TYPE_ACTIVE_ATTACK && FIndex != TYPE_ACTIVE_SKILL || FHashiramaVfxStarted)
         {
            return;
         }
         FHashiramaVfxStarted = true;
         ShowHashiramaVfx(FSkillId);
      }
      
      private function ShowHashiramaVfx(skill:int) : void
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
               var enemy:TRole = FTargets[i];
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
      
      private function HashiramaStrikePose(frame:TAnimationFrame) : void
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
            var enemy:TRole = FTargets[i];
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
      
      private function PlayMechaVfxAsset(name:String, host:DisplayObjectContainer, point:Point, width:Number, height:Number, delay:int = 0, mirrored:Boolean = false, follow:Boolean = false, behind:Boolean = false, angle:Number = 0) : void
      {
         var caster:TRole;
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
         var manifest:Object = MechaVfxManifest();
         var clip:Object = manifest.clips[name];
         if(clip == null || host == null || host.stage == null)
         {
            return;
         }
         pinned = clip.aheadPages[0];
         MechaPinPages([],pinned);
         pre = 0;
         while(pre < pinned.length)
         {
            preload = String(pinned[pre]);
            LoadMechaVfxAtlas(preload,manifest.atlases[preload],pre == 0,pre * 2);
            pre++;
         }
         caster = this;
         layer = new Sprite();
         layer.name = "mechaSkillVfx";
         FMechaActiveVfx.push(layer);
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
         started = TBattleHandle.PlaybackTime + delay;
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
            MechaPinPages(pinned,[]);
            pinned = [];
            layer.removeEventListener(Event.ENTER_FRAME,animate);
            layer.removeEventListener(Event.REMOVED_FROM_STAGE,cleanup);
            image.bitmapData = null;
            if(buffer != null)
            {
               buffer.dispose();
               buffer = null;
            }
            TrimMechaVfxCache("");
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
            var frameAtlas:String = clip.frameAtlases != null ? String(clip.frameAtlases[frame]) : String(clip.atlas);
            var wanted:Array = clip.aheadPages[frame];
            if(pinned != wanted)
            {
               MechaPinPages(pinned,wanted);
               pinned = wanted;
            }
            var ahead:int = 0;
            while(ahead < wanted.length)
            {
               var page:String = String(wanted[ahead]);
               LoadMechaVfxAtlas(page,manifest.atlases[page],ahead == 0,ahead * 2);
               ahead++;
            }
            var frames:Array = FMechaFxCache[frameAtlas] as Array;
            if(frames == null)
            {
               layer.visible = buffer != null;
               return;
            }
            layer.visible = true;
            if(frame != lastFrame)
            {
               var atlas:BitmapData = BitmapData(frames[0]);
               var meta:Object = manifest.atlases[frameAtlas];
               var cellW:int = int(atlas.width / int(meta.columns));
               var cellH:int = int(atlas.height / int(meta.rows));
               if(buffer == null)
               {
                  buffer = new BitmapData(cellW,cellH,true,0);
                  image.bitmapData = buffer;
               }
               var cell:int = int(clip.timeline[frame]);
               copyRect.x = cell % int(meta.columns) * cellW;
               copyRect.y = int(cell / int(meta.columns)) * cellH;
               copyRect.width = cellW;
               copyRect.height = cellH;
               buffer.copyPixels(atlas,copyRect,copyOrigin);
               image.width = width;
               image.height = height;
               image.x = -width * Number(clip.pivot[0]);
               image.y = -height * Number(clip.pivot[1]);
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
      
      private function UpdateMechaVfx() : void
      {
         if(FId != 11120950 || FSkillId < 13121101 || FSkillId > 13121113 || FIndex != TYPE_ACTIVE_ATTACK && FIndex != TYPE_ACTIVE_SKILL || FMechaVfxStarted)
         {
            return;
         }
         for each(var prior:Sprite in FMechaActiveVfx)
         {
            if(prior.parent != null)
            {
               prior.parent.removeChild(prior);
            }
         }
         FMechaActiveVfx = [];
         FMechaVfxStarted = true;
         ShowMechaVfx(FSkillId);
      }
      
      private function ShowMechaVfx(skill:int) : void
      {
         var host:DisplayObjectContainer = FBattleStage;
         if(host == null || host.stage == null)
         {
            return;
         }
         var origin:Point = host.globalToLocal(localToGlobal(new Point()));
         var center:Point = new Point();
         var seen:Object = {};
         var count:int = 0;
         if(FTargets != null && FResults != null)
         {
            var i:int = 0;
            while(i < FTargets.length && i < FResults.length)
            {
               var enemy:TRole = FTargets[i];
               if(!(enemy == null || enemy == this || enemy.Camp == Camp || FResults[i].CMD != TTargetInfo.CMD_ATTACK))
               {
                  var key:String = enemy.Camp + "_" + enemy.Pos;
                  if(!seen[key])
                  {
                     seen[key] = true;
                     var pt:Point = host.globalToLocal(enemy.localToGlobal(new Point()));
                     if(primary == null)
                     {
                        var primary:Point = pt.clone();
                     }
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
         var close:Boolean = skill == 13121102 || skill == 13121104 || skill == 13121105;
         if(close && primary != null)
         {
            center = primary.clone();
         }
         if(skill == 13121101 || skill == 13121107 || skill == 13121111)
         {
            MechaBackdrop(host);
         }
         var data:Object = MechaVfxManifest();
         var clipName:String = String(data.moves[skill]);
         var effects:Array = data.actions[clipName] as Array;
         if(effects == null)
         {
            return;
         }
         var viewTL:Point = host.globalToLocal(stage.localToGlobal(new Point()));
         var viewBR:Point = host.globalToLocal(stage.localToGlobal(new Point(stage.stageWidth,stage.stageHeight)));
         var unit:Number = Math.abs(viewBR.x - viewTL.x) / 1250;
         for each(var effect:String in effects)
         {
            var layers:Array = data.effects[effect] as Array;
            if(layers != null)
            {
               var left:Number = 100000;
               var right:Number = -100000;
               var top:Number = 100000;
               var bottom:Number = -100000;
               for each(var name:String in layers)
               {
                  var c:Object = data.clips[name];
                  var bw:Number = c.width / c.renderScale;
                  var bh:Number = c.height / c.renderScale;
                  left = Math.min(left,-c.pivot[0] * bw);
                  right = Math.max(right,(1 - c.pivot[0]) * bw);
                  top = Math.min(top,-c.pivot[1] * bh);
                  bottom = Math.max(bottom,(1 - c.pivot[1]) * bh);
               }
               var jet:Boolean = skill == 13121108;
               var recovery:Boolean = skill == 13121110;
               var kurama:Boolean = skill == 13121112 || skill == 13121113;
               var beam:Boolean = skill == 13121103 || skill == 13121106;
               var limit:Number = (recovery ? 650 : (jet ? 330 : (close ? 650 : (kurama ? 1050 : (beam ? 1100 : 1250))))) * unit;
               var fit:Number = limit / Math.max(1,right - left,bottom - top);
               var at:Point = jet || recovery ? origin.clone() : center.clone();
               at.y -= (recovery ? 0 : (jet ? 60 : (close ? 70 : 85))) * unit;
               var anchor:Array = data.effectAnchors[effect] as Array;
               if(anchor == null)
               {
                  anchor = [0,0];
               }
               var mirrored:Boolean = scaleX < 0;
               at.x -= Number(anchor[0]) * fit * (mirrored ? -1 : 1);
               at.y -= Number(anchor[1]) * fit;
               for each(name in layers)
               {
                  c = data.clips[name];
                  PlayMechaVfxAsset(name,host,at,c.width / c.renderScale * fit,c.height / c.renderScale * fit,0,mirrored,false,false);
               }
            }
         }
      }
      
      private function MechaStrikePose(frame:TAnimationFrame) : void
      {
         if(FId != 11120950 || frame == null || FIndex != TYPE_ACTIVE_ATTACK && FIndex != TYPE_ACTIVE_SKILL)
         {
            return;
         }
         FBitmap.x = -frame.Pivot.X;
         FBitmap.y = -frame.Pivot.Y;
         if(FSkillId != 13121102 && FSkillId != 13121104 && FSkillId != 13121105 || FTargets == null || FResults == null)
         {
            return;
         }
         var i:int = 0;
         while(i < FTargets.length && i < FResults.length)
         {
            var enemy:TRole = FTargets[i];
            if(!(enemy == null || enemy == this || enemy.Camp == Camp || FResults[i].CMD != TTargetInfo.CMD_ATTACK))
            {
               var point:Point = globalToLocal(enemy.localToGlobal(new Point()));
               var chase:Boolean = FSkillId != 13121102;
               var hit:Number = chase ? 36 : 7;
               var duration:Number = chase ? 81 : 98;
               var t:Number = Math.min(1,Math.max(0,FFrameIndex / Math.max(5,hit - 3)));
               var back:Number = Math.min(1,Math.max(0,(duration - FFrameIndex) / 14));
               var weight:Number = t * t * (3 - 2 * t) * back * back * (3 - 2 * back);
               FBitmap.x += (point.x - 105) * weight;
               FBitmap.y += point.y * weight;
               return;
            }
            i++;
         }
      }
      
      private function FitMechaPose() : void
      {
         if(FId != 11120950 || stage == null || FBitmap.bitmapData == null)
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
      
      private function MechaBackdrop(host:DisplayObjectContainer) : void
      {
         var tl:Point;
         var br:Point;
         var caster:TRole;
         var serial:uint;
         var skill:uint;
         var cleanup:Function;
         var dim:Sprite = new Sprite();
         dim.name = "mechaSkillVfx";
         dim.mouseEnabled = false;
         tl = host.globalToLocal(stage.localToGlobal(new Point()));
         br = host.globalToLocal(stage.localToGlobal(new Point(stage.stageWidth,stage.stageHeight)));
         dim.graphics.beginFill(329241,0.55);
         dim.graphics.drawRect(tl.x,tl.y,br.x - tl.x,br.y - tl.y);
         dim.graphics.endFill();
         host.addChildAt(dim,0);
         FMechaActiveVfx.push(dim);
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
      
      private function PlayItachiVfxAsset(name:String, host:DisplayObjectContainer, point:Point, width:Number, height:Number, delay:int = 0, mirrored:Boolean = false, follow:Boolean = false, behind:Boolean = false, angle:Number = 0) : void
      {
         var caster:TRole;
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
         var manifest:Object = ItachiVfxManifest();
         var clip:Object = manifest.clips[name];
         if(clip == null || host == null || host.stage == null)
         {
            return;
         }
         pinned = clip.aheadPages[0];
         ItachiPinPages([],pinned);
         pre = 0;
         while(pre < pinned.length)
         {
            preload = String(pinned[pre]);
            LoadItachiVfxAtlas(preload,manifest.atlases[preload],pre == 0,pre * 2);
            pre++;
         }
         caster = this;
         layer = new Sprite();
         layer.name = "itachiSkillVfx";
         FItachiActiveVfx.push(layer);
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
         started = TBattleHandle.PlaybackTime + delay;
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
            ItachiPinPages(pinned,[]);
            pinned = [];
            layer.removeEventListener(Event.ENTER_FRAME,animate);
            layer.removeEventListener(Event.REMOVED_FROM_STAGE,cleanup);
            image.bitmapData = null;
            if(buffer != null)
            {
               buffer.dispose();
               buffer = null;
            }
            TrimItachiVfxCache("");
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
            var frameAtlas:String = clip.frameAtlases != null ? String(clip.frameAtlases[frame]) : String(clip.atlas);
            var wanted:Array = clip.aheadPages[frame];
            if(pinned != wanted)
            {
               ItachiPinPages(pinned,wanted);
               pinned = wanted;
            }
            var ahead:int = 0;
            while(ahead < wanted.length)
            {
               var page:String = String(wanted[ahead]);
               LoadItachiVfxAtlas(page,manifest.atlases[page],ahead == 0,ahead * 2);
               ahead++;
            }
            var frames:Array = FItachiFxCache[frameAtlas] as Array;
            if(frames == null)
            {
               layer.visible = buffer != null;
               return;
            }
            layer.visible = true;
            if(frame != lastFrame)
            {
               var atlas:BitmapData = BitmapData(frames[0]);
               var meta:Object = manifest.atlases[frameAtlas];
               var cellW:int = int(atlas.width / int(meta.columns));
               var cellH:int = int(atlas.height / int(meta.rows));
               if(buffer == null)
               {
                  buffer = new BitmapData(cellW,cellH,true,0);
                  image.bitmapData = buffer;
               }
               var cell:int = int(clip.timeline[frame]);
               copyRect.x = cell % int(meta.columns) * cellW;
               copyRect.y = int(cell / int(meta.columns)) * cellH;
               copyRect.width = cellW;
               copyRect.height = cellH;
               buffer.copyPixels(atlas,copyRect,copyOrigin);
               image.width = width;
               image.height = height;
               image.x = -width * Number(clip.pivot[0]);
               image.y = -height * Number(clip.pivot[1]);
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
      
      private function FitItachiPose() : void
      {
         if(FId != 11120960 || stage == null || FBitmap.bitmapData == null)
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
      
      private function ItachiBackdrop(host:DisplayObjectContainer) : void
      {
         var tl:Point;
         var br:Point;
         var caster:TRole;
         var serial:uint;
         var skill:uint;
         var cleanup:Function;
         var dim:Sprite = new Sprite();
         dim.name = "itachiSkillVfx";
         dim.mouseEnabled = false;
         tl = host.globalToLocal(stage.localToGlobal(new Point()));
         br = host.globalToLocal(stage.localToGlobal(new Point(stage.stageWidth,stage.stageHeight)));
         dim.graphics.beginFill(329241,0.55);
         dim.graphics.drawRect(tl.x,tl.y,br.x - tl.x,br.y - tl.y);
         dim.graphics.endFill();
         host.addChildAt(dim,0);
         FItachiActiveVfx.push(dim);
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
      
      private function UpdateItachiVfx() : void
      {
         if(FId != 11120960 || FSkillId < 13121201 || FSkillId > 13121207 || FIndex != TYPE_ACTIVE_ATTACK && FIndex != TYPE_ACTIVE_SKILL || FItachiVfxStarted)
         {
            return;
         }
         for each(var old:Sprite in FItachiActiveVfx)
         {
            if(old.parent != null)
            {
               old.parent.removeChild(old);
            }
         }
         FItachiActiveVfx = [];
         FItachiVfxStarted = true;
         ShowItachiVfx(FSkillId);
      }
      
      public function ClearItachiCrowClone(detach:Boolean = true) : void
      {
         var layer:Sprite = FItachiCrowClone;
         if(layer == null)
         {
            return;
         }
         FItachiCrowClone = null;
         layer.removeEventListener(Event.ENTER_FRAME,FItachiCrowCloneTick);
         layer.removeEventListener(Event.REMOVED_FROM_STAGE,FItachiCrowCloneRemoved);
         FItachiCrowCloneTick = null;
         FItachiCrowCloneRemoved = null;
         if(layer.numChildren > 1 && layer.getChildAt(1) is Bitmap)
         {
            Bitmap(layer.getChildAt(1)).bitmapData = null;
         }
         if(detach && layer.parent != null)
         {
            layer.parent.removeChild(layer);
         }
      }
      
      private function ShowItachiCrowClone() : void
      {
         var caster:TRole;
         var host:DisplayObjectContainer;
         var layer:Sprite;
         var shadow:Shape;
         var bitmap:Bitmap;
         var started:int;
         var at:Point;
         var tl:Point;
         var br:Point;
         if(FId != 11120960 || FIsDie || CurHealth <= 0 || parent == null || stage == null || FTextureFightIdle == null)
         {
            return;
         }
         if(FItachiCrowClone != null && FItachiCrowClone.parent != null)
         {
            return;
         }
         ClearItachiCrowClone();
         caster = this;
         host = parent;
         layer = new Sprite();
         layer.name = "itachiCrowClone";
         layer.mouseEnabled = false;
         layer.mouseChildren = false;
         shadow = new Shape();
         shadow.graphics.beginFill(0,0.18);
         shadow.graphics.drawEllipse(-30,-5,60,12);
         shadow.graphics.endFill();
         layer.addChild(shadow);
         bitmap = new Bitmap(null,PixelSnapping.AUTO,true);
         layer.addChild(bitmap);
         host.addChild(layer);
         FItachiCrowClone = layer;
         started = TBattleHandle.PlaybackTime;
         FItachiCrowCloneTick = function(event:Event = null):void
         {
            if(caster.stage == null || caster.parent != host || caster.FIsDie || caster.CurHealth <= 0 || layer.parent == null)
            {
               caster.ClearItachiCrowClone();
               return;
            }
            var age:int = Math.max(0,TBattleHandle.PlaybackTime - started);
            var sequence:Object = caster.FTextureFightIdle.GetAnimationSequenceByIndex(0);
            var frame:Object = sequence.GetAnimationFrameByIndex(int(age / 40) % 37);
            if(frame == null)
            {
               frame = sequence.GetAnimationFrameByIndex(0);
            }
            if(frame == null || frame.Surface == null)
            {
               return;
            }
            bitmap.bitmapData = frame.Surface;
            bitmap.x = -frame.Pivot.X;
            bitmap.y = -frame.Pivot.Y;
            layer.scaleX = caster.scaleX;
            layer.scaleY = caster.scaleY;
            layer.x = caster.x + (caster.scaleX < 0 ? 100 : -100) * Math.abs(caster.scaleX);
            layer.y = caster.y + 8 * Math.abs(caster.scaleY);
            layer.alpha = Math.min(0.92,age / 240);
            var bounds:Rectangle = layer.getBounds(caster.stage);
            var shiftX:Number = bounds.left < 12 ? 12 - bounds.left : (bounds.right > caster.stage.stageWidth - 12 ? caster.stage.stageWidth - 12 - bounds.right : 0);
            var shiftY:Number = bounds.top < 12 ? 12 - bounds.top : (bounds.bottom > caster.stage.stageHeight - 12 ? caster.stage.stageHeight - 12 - bounds.bottom : 0);
            if(shiftX || shiftY)
            {
               var zero:Point = host.globalToLocal(caster.stage.localToGlobal(new Point()));
               var moved:Point = host.globalToLocal(caster.stage.localToGlobal(new Point(shiftX,shiftY)));
               layer.x += moved.x - zero.x;
               layer.y += moved.y - zero.y;
            }
         };
         FItachiCrowCloneRemoved = function(event:Event):void
         {
            if(event.target == layer)
            {
               caster.ClearItachiCrowClone(false);
            }
         };
         layer.addEventListener(Event.ENTER_FRAME,FItachiCrowCloneTick);
         layer.addEventListener(Event.REMOVED_FROM_STAGE,FItachiCrowCloneRemoved);
         FItachiCrowCloneTick();
         if(FBattleStage != null)
         {
            at = FBattleStage.globalToLocal(layer.localToGlobal(new Point()));
            tl = FBattleStage.globalToLocal(stage.localToGlobal(new Point()));
            br = FBattleStage.globalToLocal(stage.localToGlobal(new Point(stage.stageWidth,stage.stageHeight)));
            PlayItachiEffect("YuzhiboyoRZZL_Yafenshenzhishu",FBattleStage,at,360,Math.abs(br.x - tl.x) / 1250,0);
         }
      }
      
      private function ShowItachiVfx(skill:int) : void
      {
         if(skill == 13121207)
         {
            ShowItachiCrowClone();
         }
         var host:DisplayObjectContainer = FBattleStage;
         if(host == null || host.stage == null)
         {
            return;
         }
         var origin:Point = host.globalToLocal(localToGlobal(new Point()));
         var center:Point = new Point();
         var count:int = 0;
         var targets:Array = [];
         var seen:Object = {};
         if(FTargets != null && FResults != null)
         {
            var i:int = 0;
            while(i < FTargets.length && i < FResults.length)
            {
               var enemy:TRole = FTargets[i];
               if(!(enemy == null || enemy == this || enemy.Camp == Camp || FResults[i].CMD != TTargetInfo.CMD_ATTACK))
               {
                  var key:String = enemy.Camp + "_" + enemy.Pos;
                  if(!seen[key])
                  {
                     seen[key] = true;
                     var pt:Point = host.globalToLocal(enemy.localToGlobal(new Point()));
                     targets.push(pt);
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
         var tl:Point = host.globalToLocal(stage.localToGlobal(new Point()));
         var br:Point = host.globalToLocal(stage.localToGlobal(new Point(stage.stageWidth,stage.stageHeight)));
         var unit:Number = Math.abs(br.x - tl.x) / 1250;
         if(skill == 13121201 || skill == 13121202)
         {
            ItachiBackdrop(host);
         }
         var data:Object = ItachiVfxManifest();
         var clipName:String = String(data.moves[skill]);
         var effects:Array = data.actions[clipName] as Array;
         if(effects != null)
         {
            for each(var effect:String in effects)
            {
               PlayItachiEffect(effect,host,skill == 13121203 || skill == 13121207 ? origin : center,skill == 13121207 ? 360 : (skill == 13121203 ? 450 : 1150),unit,0);
            }
         }
         if(skill == 13121203)
         {
            for each(pt in targets)
            {
               PlayItachiEffect("YuzhiboyoRZZL_Huanshuxielunyan_shouji",host,pt,360,unit,1250);
            }
         }
         if(skill == 13121206)
         {
            for each(pt in targets)
            {
               PlayItachiEffect("YuzhiboyoRZZL_Yongbingjituan_SB_zhen",host,pt,240,unit,500);
               PlayItachiEffect("YuzhiboyoRZZL_Yongbingjituan_SB_shouji",host,pt,500,unit,3250);
            }
         }
      }
      
      private function PlayItachiEffect(effect:String, host:DisplayObjectContainer, at:Point, limit:Number, unit:Number, delay:int) : void
      {
         var data:Object = ItachiVfxManifest();
         var layers:Array = data.effects[effect] as Array;
         if(layers == null)
         {
            return;
         }
         if(layers.length > 0 && data.clips[String(layers[0])].cameraClip)
         {
            var screenTL:Point = host.globalToLocal(stage.localToGlobal(new Point()));
            var screenBR:Point = host.globalToLocal(stage.localToGlobal(new Point(stage.stageWidth,stage.stageHeight)));
            var sw:Number = screenBR.x - screenTL.x;
            var sh:Number = screenBR.y - screenTL.y;
            var scale:Number = Math.min(sw / 1250,sh / 650);
            var px:Number = scaleX < 0 ? 925 : 325;
            var cameraAt:Point = new Point(screenTL.x + (sw - 1250 * scale) / 2 + px * scale,screenTL.y + (sh - 650 * scale) / 2 + 450 * scale);
            for each(var cameraKey:String in layers)
            {
               PlayItachiVfxAsset(cameraKey,host,cameraAt,1250 * scale,650 * scale,delay,scaleX < 0,false,false);
            }
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
         var fit:Number = Math.min(1.5 * unit,limit * unit / Math.max(width,height),(br.x - tl.x - 24 * unit) / width,(br.y - tl.y - 36 * unit) / height);
         var mirrored:Boolean = scaleX < 0;
         var low:Number = mirrored ? -right : left;
         var high:Number = mirrored ? -left : right;
         at = at.clone();
         at.x = Math.max(tl.x + 12 * unit - low * fit,Math.min(br.x - 12 * unit - high * fit,at.x));
         at.y = Math.max(tl.y + 18 * unit - top * fit,Math.min(br.y - 18 * unit - bottom * fit,at.y));
         for each(key in layers)
         {
            c = data.clips[key];
            PlayItachiVfxAsset(key,host,at,c.width / c.renderScale * fit,c.height / c.renderScale * fit,delay,scaleX < 0,false,false);
         }
      }
      
      private function PlaySasukeVfxAsset(name:String, host:DisplayObjectContainer, point:Point, width:Number, height:Number, delay:int = 0, mirrored:Boolean = false, follow:Boolean = false, behind:Boolean = false, angle:Number = 0) : void
      {
         var caster:TRole;
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
         layer.name = "sasukeSkillVfx";
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
         started = TBattleHandle.PlaybackTime + delay;
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
            if(frame == lastFrame)
            {
               return;
            }
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
               buffer.lock();
               buffer.fillRect(buffer.rect,0);
               copyRect.x = int(rect[0]);
               copyRect.y = int(rect[1]);
               copyRect.width = int(rect[2]);
               copyRect.height = int(rect[3]);
               buffer.copyPixels(atlas,copyRect,copyOrigin);
               buffer.unlock();
               image.scaleX = width / Number(clip.width);
               image.scaleY = height / Number(clip.height);
               image.x = (Number(rect[4]) - Number(clip.pivot[0]) * Number(clip.width)) * image.scaleX;
               image.y = (Number(rect[5]) - Number(clip.pivot[1]) * Number(clip.height)) * image.scaleY;
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
      
      private function FitSasukePose() : void
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
      
      private function SasukeBackdrop(host:DisplayObjectContainer) : void
      {
         var tl:Point;
         var br:Point;
         var caster:TRole;
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
      
      private function UpdateSasukeVfx() : void
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
      
      private function ShowSasukeVfx(skill:int) : void
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
               var enemy:TRole = FTargets[i];
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
      
      private function PlaySasukeEffect(effect:String, host:DisplayObjectContainer, at:Point, limit:Number, unit:Number, delay:int, cutin:Boolean = false) : void
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
      
      private function ShowSasukeScreenFlash(host:DisplayObjectContainer, skill:int) : void
      {
         var tl:Point;
         var br:Point;
         var layer:Sprite;
         var caster:TRole;
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
            if(layer.parent != null)
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
      
      private function ShowSasukeGenjutsu(host:DisplayObjectContainer, at:Point, rinnegan:Boolean) : void
      {
         var color:uint;
         var ring:int;
         var n:int;
         var angle:Number;
         var x:Number;
         var y:Number;
         var caster:TRole;
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
      
      private function PlaySasukeNativeImpact(name:String, host:DisplayObjectContainer, at:Point, unit:Number) : void
      {
         var profile:Object;
         var fit:Number;
         var layer:Sprite;
         var facing:Number;
         var caster:TRole;
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
      
      private function PlaySasukeCinematic(name:String, host:DisplayObjectContainer) : void
      {
         var tl:Point;
         var br:Point;
         var width:Number;
         var height:Number;
         var layer:Sprite;
         var backdrop:Sprite;
         var caster:TRole;
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
      
      private function PlayNagatoVfxAsset(name:String, host:DisplayObjectContainer, point:Point, width:Number, height:Number, delay:int = 0, mirrored:Boolean = false, follow:Boolean = false, behind:Boolean = false, angle:Number = 0) : void
      {
         var caster:TRole;
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
         var manifest:Object = NagatoVfxManifest();
         var clip:Object = manifest.clips[name];
         if(clip == null || host == null || host.stage == null)
         {
            return;
         }
         pinned = clip.aheadPages[0];
         NagatoPinPages([],pinned);
         pre = 0;
         while(pre < pinned.length)
         {
            preload = String(pinned[pre]);
            LoadNagatoVfxAtlas(preload,manifest.atlases[preload],pre == 0,pre * 2);
            pre++;
         }
         caster = this;
         layer = new Sprite();
         layer.name = "nagatoSkillVfx";
         FNagatoActiveVfx.push(layer);
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
         started = TBattleHandle.PlaybackTime + delay;
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
            NagatoPinPages(pinned,[]);
            pinned = [];
            layer.removeEventListener(Event.ENTER_FRAME,animate);
            layer.removeEventListener(Event.REMOVED_FROM_STAGE,cleanup);
            image.bitmapData = null;
            if(buffer != null)
            {
               buffer.dispose();
               buffer = null;
            }
            TrimNagatoVfxCache("");
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
            var frameAtlas:String = clip.frameAtlases != null ? String(clip.frameAtlases[frame]) : String(clip.atlas);
            var wanted:Array = clip.aheadPages[frame];
            if(pinned != wanted)
            {
               NagatoPinPages(pinned,wanted);
               pinned = wanted;
            }
            var ahead:int = 0;
            while(ahead < wanted.length)
            {
               var page:String = String(wanted[ahead]);
               LoadNagatoVfxAtlas(page,manifest.atlases[page],ahead == 0,ahead * 2);
               ahead++;
            }
            var frames:Array = FNagatoFxCache[frameAtlas] as Array;
            if(frames == null)
            {
               layer.visible = buffer != null;
               return;
            }
            layer.visible = true;
            if(frame != lastFrame)
            {
               var atlas:BitmapData = BitmapData(frames[0]);
               var meta:Object = manifest.atlases[frameAtlas];
               var cellW:int = int(atlas.width / int(meta.columns));
               var cellH:int = int(atlas.height / int(meta.rows));
               if(buffer == null)
               {
                  buffer = new BitmapData(cellW,cellH,true,0);
                  image.bitmapData = buffer;
               }
               var cell:int = int(clip.timeline[frame]);
               copyRect.x = cell % int(meta.columns) * cellW;
               copyRect.y = int(cell / int(meta.columns)) * cellH;
               copyRect.width = cellW;
               copyRect.height = cellH;
               buffer.copyPixels(atlas,copyRect,copyOrigin);
               image.width = width;
               image.height = height;
               image.x = -width * Number(clip.pivot[0]);
               image.y = -height * Number(clip.pivot[1]);
               if(clip.tint != null)
               {
                  image.transform.colorTransform = new ColorTransform(Number(clip.tint[0]),Number(clip.tint[1]),Number(clip.tint[2]),1);
               }
               lastFrame = frame;
            }
            if(follow && caster.stage != null)
            {
               var strikeOffset:Point = caster.NagatoStrikeOffset();
               point = host.globalToLocal(caster.localToGlobal(new Point(strikeOffset.x + 70,strikeOffset.y)));
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
      
      private function FitNagatoPose() : void
      {
         if(FId != 11120990 || stage == null || FBitmap.bitmapData == null)
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
      
      private function NagatoBackdrop(host:DisplayObjectContainer) : void
      {
         var tl:Point;
         var br:Point;
         var caster:TRole;
         var serial:uint;
         var skill:uint;
         var cleanup:Function;
         var dim:Sprite = new Sprite();
         dim.name = "nagatoSkillVfx";
         dim.mouseEnabled = false;
         tl = host.globalToLocal(stage.localToGlobal(new Point()));
         br = host.globalToLocal(stage.localToGlobal(new Point(stage.stageWidth,stage.stageHeight)));
         dim.graphics.beginFill(329241,0.55);
         dim.graphics.drawRect(tl.x,tl.y,br.x - tl.x,br.y - tl.y);
         dim.graphics.endFill();
         host.addChildAt(dim,0);
         FNagatoActiveVfx.push(dim);
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
      
      private function UpdateNagatoVfx() : void
      {
         if(FId != 11120990 || FSkillId < 13121401 || FSkillId > 13121407 || FIndex != TYPE_ACTIVE_ATTACK && FIndex != TYPE_ACTIVE_SKILL || FNagatoVfxStarted)
         {
            return;
         }
         for each(var old:Sprite in FNagatoActiveVfx)
         {
            if(old.parent != null)
            {
               old.parent.removeChild(old);
            }
         }
         FNagatoActiveVfx = [];
         FNagatoVfxStarted = true;
         ShowNagatoVfx(FSkillId);
      }
      
      private function ShowNagatoVfx(skill:int) : void
      {
         var host:DisplayObjectContainer = FBattleStage;
         if(host == null || host.stage == null)
         {
            return;
         }
         var offset:Point = NagatoStrikeOffset();
         var origin:Point = host.globalToLocal(localToGlobal(new Point(offset.x + 70,offset.y)));
         var zero:Point = host.globalToLocal(localToGlobal(new Point()));
         var one:Point = host.globalToLocal(localToGlobal(new Point(1,0)));
         var scale:Number = Point.distance(zero,one);
         var data:Object = NagatoVfxManifest();
         var clip:String = String(data.moves[skill]);
         var effects:Array = data.actions[clip] as Array;
         if(skill == 13121401)
         {
            NagatoBackdrop(host);
         }
         if(effects != null)
         {
            for each(var effect:String in effects)
            {
               PlayNagatoEffect(effect,host,origin,skill == 13121401 ? 2475 : 650,scale,0);
            }
         }
      }
      
      private function PlayNagatoEffect(effect:String, host:DisplayObjectContainer, at:Point, limit:Number, unit:Number, delay:int) : void
      {
         var data:Object = NagatoVfxManifest();
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
         var width:Number = Math.max(1,right - left);
         var height:Number = Math.max(1,bottom - top);
         var fit:Number = Math.min(unit * (effect == "QWCMaoyi" ? 2.25 : 1),limit * unit / Math.max(width,height));
         for each(key in layers)
         {
            c = data.clips[key];
            PlayNagatoVfxAsset(key,host,at,c.width / c.renderScale * fit,c.height / c.renderScale * fit,delay,scaleX < 0,true,false);
         }
      }
      
      private function NagatoStrikeOffset() : Point
      {
         if(FId != 11120990 || FIndex != TYPE_ACTIVE_ATTACK && FIndex != TYPE_ACTIVE_SKILL || FTargets == null || FResults == null)
         {
            return new Point();
         }
         var timing:Object = NagatoVfxManifest().poseTiming[String(FSkillId)];
         if(timing == null)
         {
            return new Point();
         }
         var t:Number = Math.min(1,Math.max(0,FFrameIndex / 10));
         var back:Number = Math.min(1,Math.max(0,(Number(timing.end) - FFrameIndex) / 10));
         var weight:Number = t * t * (3 - 2 * t) * back * back * (3 - 2 * back);
         var i:int = 0;
         while(i < FTargets.length && i < FResults.length)
         {
            var enemy:TRole = FTargets[i];
            if(!(enemy == null || enemy == this || enemy.Camp == Camp || FResults[i].CMD != TTargetInfo.CMD_ATTACK))
            {
               var target:Point = globalToLocal(enemy.localToGlobal(new Point()));
               return new Point(Math.max(0,target.x - Number(timing.distance)) * weight,target.y * weight);
            }
            i++;
         }
         return new Point();
      }
      
      private function NagatoStrikePose(frame:TAnimationFrame) : void
      {
         if(FId != 11120990 || frame == null || FIndex != TYPE_ACTIVE_ATTACK && FIndex != TYPE_ACTIVE_SKILL)
         {
            return;
         }
         var offset:Point = NagatoStrikeOffset();
         FBitmap.x = -frame.Pivot.X + offset.x;
         FBitmap.y = -frame.Pivot.Y + offset.y;
      }
      
      private function PlayGaaraVfxAsset(name:String, host:DisplayObjectContainer, point:Point, width:Number, height:Number, delay:int = 0, mirrored:Boolean = false, follow:Boolean = false, behind:Boolean = false, angle:Number = 0) : void
      {
         var caster:TRole;
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
         var manifest:Object = GaaraVfxManifest();
         var clip:Object = manifest.clips[name];
         if(clip == null || host == null || host.stage == null)
         {
            return;
         }
         pinned = clip.aheadPages[0];
         GaaraPinPages([],pinned);
         pre = 0;
         while(pre < pinned.length)
         {
            preload = String(pinned[pre]);
            LoadGaaraVfxAtlas(preload,manifest.atlases[preload],pre == 0,pre * 2);
            pre++;
         }
         caster = this;
         layer = new Sprite();
         layer.name = "gaaraSkillVfx";
         FGaaraActiveVfx.push(layer);
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
         started = TBattleHandle.PlaybackTime + delay;
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
            GaaraPinPages(pinned,[]);
            pinned = [];
            layer.removeEventListener(Event.ENTER_FRAME,animate);
            layer.removeEventListener(Event.REMOVED_FROM_STAGE,cleanup);
            image.bitmapData = null;
            if(buffer != null)
            {
               buffer.dispose();
               buffer = null;
            }
            TrimGaaraVfxCache("");
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
            var frameAtlas:String = clip.frameAtlases != null ? String(clip.frameAtlases[frame]) : String(clip.atlas);
            var wanted:Array = clip.aheadPages[frame];
            if(pinned != wanted)
            {
               GaaraPinPages(pinned,wanted);
               pinned = wanted;
            }
            var ahead:int = 0;
            while(ahead < wanted.length)
            {
               var page:String = String(wanted[ahead]);
               LoadGaaraVfxAtlas(page,manifest.atlases[page],ahead == 0,ahead * 2);
               ahead++;
            }
            var frames:Array = FGaaraFxCache[frameAtlas] as Array;
            if(frames == null)
            {
               layer.visible = buffer != null;
               return;
            }
            layer.visible = true;
            if(frame != lastFrame)
            {
               var atlas:BitmapData = BitmapData(frames[0]);
               var meta:Object = manifest.atlases[frameAtlas];
               var cellW:int = int(atlas.width / int(meta.columns));
               var cellH:int = int(atlas.height / int(meta.rows));
               if(buffer == null)
               {
                  buffer = new BitmapData(cellW,cellH,true,0);
                  image.bitmapData = buffer;
               }
               var cell:int = int(clip.timeline[frame]);
               copyRect.x = cell % int(meta.columns) * cellW;
               copyRect.y = int(cell / int(meta.columns)) * cellH;
               copyRect.width = cellW;
               copyRect.height = cellH;
               buffer.copyPixels(atlas,copyRect,copyOrigin);
               image.width = width;
               image.height = height;
               image.x = -width * Number(clip.pivot[0]);
               image.y = -height * Number(clip.pivot[1]);
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
      
      private function FitGaaraPose() : void
      {
         if(FId != 11120991 || stage == null || FBitmap.bitmapData == null)
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
      
      private function GaaraBackdrop(host:DisplayObjectContainer) : void
      {
         var tl:Point;
         var br:Point;
         var caster:TRole;
         var serial:uint;
         var skill:uint;
         var cleanup:Function;
         var dim:Sprite = new Sprite();
         dim.name = "gaaraSkillVfx";
         dim.mouseEnabled = false;
         tl = host.globalToLocal(stage.localToGlobal(new Point()));
         br = host.globalToLocal(stage.localToGlobal(new Point(stage.stageWidth,stage.stageHeight)));
         dim.graphics.beginFill(329241,0.55);
         dim.graphics.drawRect(tl.x,tl.y,br.x - tl.x,br.y - tl.y);
         dim.graphics.endFill();
         host.addChildAt(dim,0);
         FGaaraActiveVfx.push(dim);
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
      
      private function UpdateGaaraVfx() : void
      {
         if(FId != 11120991 || FSkillId < 13121501 || FSkillId > 13121504 || FIndex != TYPE_ACTIVE_ATTACK && FIndex != TYPE_ACTIVE_SKILL || FGaaraVfxStarted)
         {
            return;
         }
         for each(var old:Sprite in FGaaraActiveVfx)
         {
            if(old.parent != null)
            {
               old.parent.removeChild(old);
            }
         }
         FGaaraActiveVfx = [];
         FGaaraVfxStarted = true;
         ShowGaaraVfx(FSkillId);
      }
      
      private function ShowGaaraVfx(skill:int) : void
      {
         var host:DisplayObjectContainer = FBattleStage;
         if(host == null || host.stage == null)
         {
            return;
         }
         var origin:Point = host.globalToLocal(localToGlobal(new Point()));
         var center:Point = new Point();
         var count:int = 0;
         var targets:Array = [];
         var seen:Object = {};
         if(FTargets != null && FResults != null)
         {
            var i:int = 0;
            while(i < FTargets.length && i < FResults.length)
            {
               var enemy:TRole = FTargets[i];
               if(!(enemy == null || enemy == this || enemy.Camp == Camp || FResults[i].CMD != TTargetInfo.CMD_ATTACK))
               {
                  var key:String = enemy.Camp + "_" + enemy.Pos;
                  if(!seen[key])
                  {
                     seen[key] = true;
                     var pt:Point = host.globalToLocal(enemy.localToGlobal(new Point()));
                     targets.push(pt);
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
         var tl:Point = host.globalToLocal(stage.localToGlobal(new Point()));
         var br:Point = host.globalToLocal(stage.localToGlobal(new Point(stage.stageWidth,stage.stageHeight)));
         var unit:Number = Math.abs(br.x - tl.x) / 1250;
         var data:Object = GaaraVfxManifest();
         var clipName:String = String(data.moves[skill]);
         var effects:Array = data.actions[clipName] as Array;
         if(skill == 13121501)
         {
            GaaraBackdrop(host);
         }
         if(effects != null)
         {
            for each(var effect:String in effects)
            {
               PlayGaaraEffect(effect,host,skill == 13121502 ? origin : center,skill == 13121501 ? 1200 : 850,unit,0);
            }
         }
         if(skill == 13121502 && FTargets != null && FResults != null)
         {
            var shieldIndex:int = 0;
            while(shieldIndex < FTargets.length && shieldIndex < FResults.length)
            {
               if(FTargets[shieldIndex] != null && FResults[shieldIndex].CMD == 8)
               {
                  var allyPoint:Point = host.globalToLocal(FTargets[shieldIndex].localToGlobal(new Point()));
                  PlayGaaraEffect("GAR_shazhidun",host,allyPoint,280,unit,0);
               }
               shieldIndex++;
            }
         }
      }
      
      private function PlayGaaraEffect(effect:String, host:DisplayObjectContainer, at:Point, limit:Number, unit:Number, delay:int) : void
      {
         var data:Object = GaaraVfxManifest();
         var layers:Array = data.effects[effect] as Array;
         if(layers == null)
         {
            return;
         }
         if(layers.length > 0 && data.clips[String(layers[0])].cameraClip)
         {
            var screenTL:Point = host.globalToLocal(stage.localToGlobal(new Point()));
            var screenBR:Point = host.globalToLocal(stage.localToGlobal(new Point(stage.stageWidth,stage.stageHeight)));
            var sw:Number = screenBR.x - screenTL.x;
            var sh:Number = screenBR.y - screenTL.y;
            var scale:Number = Math.min(sw / 1250,sh / 650);
            var px:Number = scaleX < 0 ? 925 : 325;
            var cameraAt:Point = new Point(screenTL.x + (sw - 1250 * scale) / 2 + px * scale,screenTL.y + (sh - 650 * scale) / 2 + 450 * scale);
            for each(var cameraKey:String in layers)
            {
               PlayGaaraVfxAsset(cameraKey,host,cameraAt,1250 * scale,650 * scale,delay,scaleX < 0,false,false);
            }
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
         var fit:Number = Math.min(1.5 * unit,limit * unit / Math.max(width,height),(br.x - tl.x - 24 * unit) / width,(br.y - tl.y - 36 * unit) / height);
         var mirrored:Boolean = scaleX < 0;
         var low:Number = mirrored ? -right : left;
         var high:Number = mirrored ? -left : right;
         at = at.clone();
         at.x = Math.max(tl.x + 12 * unit - low * fit,Math.min(br.x - 12 * unit - high * fit,at.x));
         at.y = Math.max(tl.y + 18 * unit - top * fit,Math.min(br.y - 18 * unit - bottom * fit,at.y));
         for each(key in layers)
         {
            c = data.clips[key];
            PlayGaaraVfxAsset(key,host,at,c.width / c.renderScale * fit,c.height / c.renderScale * fit,delay,scaleX < 0,false,false);
         }
      }
      
      override public function UpdateActive() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:TAnimationFrame = null;
         var _loc5_:BitmapData = null;
         var _loc6_:TRole = null;
         var _loc7_:Number = Number(NaN);
         var _loc8_:Boolean = false;
         var _loc9_:Number = Number(NaN);
         var _loc10_:Boolean = false;
         var _loc11_:Vector.<TRole> = null;
         var _loc12_:Vector.<TTargetInfo> = null;
         var _loc13_:int = 0;
         if(stage == null)
         {
            return;
         }
         if(FIsDie)
         {
            return;
         }
         if(FIsAntiColorBlackWhite || FIsRedAntiColor)
         {
            return;
         }
         if(FShaderBmp.bitmapData == null)
         {
            this.LoadResources(CONST_BATTLE.Public_Effect_Shadow);
         }
         _loc4_ = FCurSequence.GetAnimationFrameByTick(FTickReference);
         if(FDefaultRoleTexture.GetAnimationSequenceByIndex(0) == FCurSequence)
         {
            ++FFrameIndex;
            _loc10_ = true;
            FShaderBmp.visible = false;
         }
         else
         {
            FFrameIndex = FCurSequence.Index;
            _loc10_ = false;
            FShaderBmp.visible = true;
         }
         this.UpdateJiraiyaVfx();
         this.UpdateObitoVfx();
         this.UpdatePainVfx();
         this.UpdateHashiramaVfx();
         this.UpdateMechaVfx();
         this.UpdateGaaraVfx();
         this.UpdateNagatoVfx();
         this.UpdateItachiVfx();
         this.UpdateSasukeVfx();
         _loc1_ = FAttackEffect[FSkillId];
         if(_loc1_ != null)
         {
            if(_loc1_.appendEffect != null)
            {
               _loc2_ = _loc1_.appendEffect[FFrameIndex];
               if(_loc2_ != null)
               {
                  if(_loc2_.target == 1)
                  {
                     this.AddEffect(_loc2_,this,FTargets,FResults,FBitmap.x,FBitmap.y);
                  }
                  else if(_loc2_.target == 2)
                  {
                     if(FTargets != null)
                     {
                        _loc3_ = 0;
                        for(; _loc3_ < FTargets.length; _loc3_++)
                        {
                           if(this == FTargets[_loc3_])
                           {
                              if(FSkilling)
                              {
                                 if(FResults[_loc3_].ResultInfo.HurtAnger > 0)
                                 {
                                    continue;
                                 }
                              }
                              else if(FResults[_loc3_].ResultInfo.HurtAnger < 0)
                              {
                                 continue;
                              }
                           }
                           if(CONST_BATTLE.HasEnemy(FTargets,Camp))
                           {
                              if(FTargets[_loc3_].Camp != Camp)
                              {
                                 FTargets[_loc3_].AddEffect(TEffectControl.CopyObject(_loc2_),this,Vector.<TRole>([FTargets[_loc3_]]),Vector.<TTargetInfo>([FResults[_loc3_]]),FBitmap.x,FBitmap.y);
                                 if(FResults[_loc3_].ResultInfo.HurtAnger > 0)
                                 {
                                    FTargets[_loc3_].AddEffect({
                                       "target":2,
                                       "effectId":CONST_BATTLE.Public_Effect_DecAngle
                                    },this,Vector.<TRole>([FTargets[_loc3_]]),Vector.<TTargetInfo>([FResults[_loc3_]]),FBitmap.x,FBitmap.y);
                                 }
                              }
                              else
                              {
                                 if(FResults[_loc3_].ResultInfo.HurtHp > 0)
                                 {
                                    FTargets[_loc3_].AddEffect(TEffectControl.CopyObject(_loc2_),this,Vector.<TRole>([FTargets[_loc3_]]),Vector.<TTargetInfo>([FResults[_loc3_]]),FBitmap.x,FBitmap.y);
                                 }
                                 if(FResults[_loc3_].ResultInfo.HurtAnger < 0 && FResults[_loc3_].AngerGaining < 100)
                                 {
                                    FTargets[_loc3_].AddEffect({
                                       "target":2,
                                       "effectId":CONST_BATTLE.Public_Effect_AddAngle
                                    },this,Vector.<TRole>([FTargets[_loc3_]]),Vector.<TTargetInfo>([FResults[_loc3_]]),FBitmap.x,FBitmap.y);
                                    FResults[_loc3_].AngerGaining = 100;
                                 }
                              }
                           }
                           else
                           {
                              FTargets[_loc3_].AddEffect(TEffectControl.CopyObject(_loc2_),this,Vector.<TRole>([FTargets[_loc3_]]),Vector.<TTargetInfo>([FResults[_loc3_]]),FBitmap.x,FBitmap.y);
                           }
                        }
                     }
                  }
                  else if(_loc2_.target == 3)
                  {
                     TEffectControl.ShowEffect(Parent,_loc2_.effectId,_loc2_,this,this,FTargets,FResults,0,0,this.x,this.y,null,0,0,0,Camp == 0 ? 1 : -1,Parent.getChildIndex(this));
                  }
                  else if(_loc2_.target == 4)
                  {
                     if(Camp == 0)
                     {
                        TEffectControl.ShowEffect(this.FBattleStage,_loc2_.effectId,_loc2_,this,this,FTargets,FResults,0,0,CONST_COMMON.STAGE_Width,0,this.FTextFunction,0,0,0,-1);
                     }
                     else
                     {
                        TEffectControl.ShowEffect(this.FBattleStage,_loc2_.effectId,_loc2_,this,this,FTargets,FResults,0,0,0,0,this.FTextFunction,0,0,0,1);
                     }
                  }
                  else if(_loc2_.target == 5)
                  {
                     if(Camp == 0)
                     {
                        TEffectControl.ShowEffect(this.FBattleStage,_loc2_.effectId,_loc2_,this,this,FTargets,FResults,0,0,SBattleConfig.GetPostionByCamyPos(0,6,SBattleConfig.Type_PostionX),SBattleConfig.GetPostionByCamyPos(0,6,SBattleConfig.Type_PostionY),this.FTextFunction);
                     }
                     else
                     {
                        TEffectControl.ShowEffect(this.FBattleStage,_loc2_.effectId,_loc2_,this,this,FTargets,FResults,0,0,SBattleConfig.GetPostionByCamyPos(1,6,SBattleConfig.Type_PostionX),SBattleConfig.GetPostionByCamyPos(1,6,SBattleConfig.Type_PostionY),this.FTextFunction);
                     }
                  }
                  else if(_loc2_.target == 7)
                  {
                     if(FTargets != null)
                     {
                        _loc3_ = 0;
                        for(; _loc3_ < FTargets.length; _loc3_++)
                        {
                           if(this == FTargets[_loc3_])
                           {
                              if(FResults[_loc3_].ResultInfo.HurtHp == 0)
                              {
                                 continue;
                              }
                           }
                           if(FTargets[_loc3_].Camp == Camp)
                           {
                              FTargets[_loc3_].AddEffect(_loc2_,this,FTargets,FResults,FBitmap.x,FBitmap.y);
                           }
                        }
                     }
                  }
                  else if(_loc2_.target == 8)
                  {
                     this.BattleStage.ShowWhiteSprite();
                  }
                  else if(_loc2_.target == 9)
                  {
                     if(Camp == 0)
                     {
                        TEffectControl.ShowEffect(this.FBattleStage,_loc2_.effectId,_loc2_,this,this,FTargets,FResults,0,0,CONST_COMMON.STAGE_Width / 2,CONST_COMMON.STAGE_Height / 3 * 2,this.FTextFunction,40,0,600);
                     }
                     else
                     {
                        TEffectControl.ShowEffect(this.FBattleStage,_loc2_.effectId,_loc2_,this,this,FTargets,FResults,0,0,CONST_COMMON.STAGE_Width / 2,CONST_COMMON.STAGE_Height / 3 * 2,this.FTextFunction,-40,0,600);
                     }
                  }
                  else if(_loc2_.target == 10)
                  {
                     TEffectControl.ShowEffect(this.FBattleStage,_loc2_.effectId,_loc2_,this,this,FTargets,FResults,0,0,this.x,this.y,this.FTextFunction,0,0,0,this.Camp == 0 ? 1 : -1);
                  }
                  else if(_loc2_.target == 11)
                  {
                     if(Camp == 0)
                     {
                        TEffectControl.ShowEffect(this.FBattleStage,_loc2_.effectId,_loc2_,this,this,FTargets,FResults,0,0,SBattleConfig.GetPostionByCamyPos(1,6,SBattleConfig.Type_PostionX),SBattleConfig.GetPostionByCamyPos(1,6,SBattleConfig.Type_PostionY),this.FTextFunction,0,0,0,-1);
                     }
                     else
                     {
                        TEffectControl.ShowEffect(this.FBattleStage,_loc2_.effectId,_loc2_,this,this,FTargets,FResults,0,0,SBattleConfig.GetPostionByCamyPos(0,6,SBattleConfig.Type_PostionX),SBattleConfig.GetPostionByCamyPos(0,6,SBattleConfig.Type_PostionY),this.FTextFunction,0,0,0,1);
                     }
                  }
                  else if(_loc2_.target == 12)
                  {
                     if(FTargets != null)
                     {
                        _loc11_ = new Vector.<TRole>();
                        _loc12_ = new Vector.<TTargetInfo>();
                        _loc11_.push(this);
                        _loc3_ = 0;
                        while(_loc3_ < FTargets.length)
                        {
                           if(FResults[_loc3_].TargetStatus & CONST_BATTLE.ActiveType_TargetEffect)
                           {
                              FResults[_loc3_].TargetStatus -= CONST_BATTLE.ActiveType_TargetEffect;
                              _loc11_.push(FTargets[_loc3_]);
                              _loc12_.push(FResults[_loc3_]);
                           }
                           _loc3_++;
                        }
                        if(_loc11_.length >= 2)
                        {
                           TEffectControl.ShowSpecialChainEffect(this.FBattleStage,_loc2_.effectId,_loc2_,_loc11_,_loc12_,this.FTextFunction);
                        }
                     }
                  }
                  FAttackEffect[FSkillId].appendEffect[FFrameIndex] = null;
               }
            }
            if(_loc1_.blackwhite)
            {
               if(_loc1_.blackwhite[FFrameIndex] != null)
               {
                  this.FBattleStage.AntiColorBlackWhite(this,Boolean(_loc1_.blackwhite[FFrameIndex]));
               }
            }
            if(_loc1_.red)
            {
               if(_loc1_.red[FFrameIndex] != null)
               {
                  this.FBattleStage.RedAntiColor(this,Boolean(_loc1_.red[FFrameIndex]));
               }
            }
            if(_loc1_.ChgBg)
            {
               if(_loc1_.ChgBg[FFrameIndex] != null)
               {
                  this.FBattleStage.ChangeBg(this,_loc1_.ChgBg[FFrameIndex]);
               }
            }
            if(_loc1_.FullScreenGradient)
            {
               if(_loc1_.FullScreenGradient[FFrameIndex] != null)
               {
                  this.FBattleStage.FSG(this,uint(_loc1_.FullScreenGradient[FFrameIndex].color),_loc1_.FullScreenGradient[FFrameIndex].time,_loc1_.FullScreenGradient[FFrameIndex].alpha);
                  _loc1_.FullScreenGradient[FFrameIndex] = null;
               }
            }
            if(_loc1_.voice != null)
            {
               if(_loc1_.voice[FFrameIndex] != null)
               {
                  SLogicsCore.SignalPost(CONST_SIGNAL.SIGNALDESTINATION_SOUND,CONST_MUSIC.PLAY_SOUND_EFFECT,_loc1_.voice[FFrameIndex],true);
                  _loc1_.voice[FFrameIndex] = null;
               }
            }
            if(FTargets != null)
            {
               _loc3_ = 0;
               while(_loc3_ < FTargets.length)
               {
                  _loc6_ = FTargets[_loc3_];
                  _loc8_ = (FResults[_loc3_].TargetStatus & CONST_BATTLE.ActiveType_Crit) != 0;
                  _loc6_.CheckTextEffect(FResults[_loc3_]);
                  if(_loc6_.Camp == Camp)
                  {
                     if(Boolean(_loc1_.friendhp) && _loc1_.friendhp[FFrameIndex] != null && FResults[_loc3_].HealthGaining < 100)
                     {
                        _loc7_ = FResults[_loc3_].ResultInfo.HurtHp * _loc1_.friendhp[FFrameIndex] / 100;
                        _loc6_.ChangeHP(_loc7_);
                        if(_loc7_ != 0)
                        {
                           FResults[_loc3_].HealthGaining += _loc1_.friendhp[FFrameIndex];
                        }
                        if(this.FTextFunction != null)
                        {
                           this.FTextFunction(TBattleStage.TYPETEXT_Float,_loc6_.Camp == 0 ? -1 : 1,_loc6_.x,_loc6_.y - _loc6_.RoleHeight,"+" + int(Math.abs(_loc7_)),_loc8_);
                        }
                     }
                  }
                  else if(Boolean(_loc1_.anmyhp) && _loc1_.anmyhp[FFrameIndex] != null)
                  {
                     _loc7_ = FResults[_loc3_].ResultInfo.HurtHp * _loc1_.anmyhp[FFrameIndex] / 100;
                     if(FResults[_loc3_].TargetStatus & CONST_BATTLE.ActiveType_Hit)
                     {
                        if(FResults[_loc3_].TargetStatus & CONST_BATTLE.ActiveType_Help)
                        {
                           FResults[_loc3_].TargetStatus -= CONST_BATTLE.ActiveType_Help;
                           _loc6_.AddTextEffect(CONST_BATTLE.ActiveType_Help);
                        }
                        if(FResults[_loc3_].TargetStatus & CONST_BATTLE.ActiveType_ImmCtrl)
                        {
                           FResults[_loc3_].TargetStatus -= CONST_BATTLE.ActiveType_ImmCtrl;
                           _loc6_.AddTextEffect(CONST_BATTLE.ActiveType_ImmCtrl);
                        }
                        if(FResults[_loc3_].TargetStatus & CONST_BATTLE.ActiveType_ImmCalm)
                        {
                           FResults[_loc3_].TargetStatus -= CONST_BATTLE.ActiveType_ImmCalm;
                           _loc6_.AddTextEffect(CONST_BATTLE.ActiveType_ImmCalm);
                        }
                        if(_loc7_ != 0)
                        {
                           _loc6_.ChangeHP(_loc7_);
                           _loc6_.ActivePlay(TActive.TYPE_ACTIVE_ATTACKED,0,null,Vector.<TTargetInfo>([FResults[_loc3_]]));
                           if(FResults[_loc3_].TargetStatus & CONST_BATTLE.ActiveType_Block)
                           {
                              TEffectControl.ShowPublicEffect(_loc6_,CONST_BATTLE.Public_Effect_Smoke,0,0);
                           }
                           if(this.FTextFunction != null)
                           {
                              this.FTextFunction(TBattleStage.TYPETEXT_Float,_loc6_.Camp == 0 ? -1 : 1,_loc6_.x,_loc6_.y - _loc6_.RoleHeight,String(int(_loc7_)),_loc8_,FResults[_loc3_].TargetStatus & CONST_BATTLE.ActiveType_Block ? CONST_BATTLE.TEXT_FIGHT_STATUS_Block : 0);
                           }
                        }
                        if(Boolean(_loc1_.anmyhp.checkDie) && !(FResults[_loc3_].TargetStatus & CONST_BATTLE.ActiveType_Block))
                        {
                           _loc6_.CheckDie();
                        }
                     }
                     else if(Boolean(FResults[_loc3_].TargetStatus & CONST_BATTLE.ActiveType_ImmCtrl) || Boolean(FResults[_loc3_].TargetStatus & CONST_BATTLE.ActiveType_ImmCalm))
                     {
                        if(this.FTextFunction != null)
                        {
                           this.FTextFunction(TBattleStage.TYPETEXT_Float,_loc6_.Camp == 0 ? -1 : 1,_loc6_.x,_loc6_.y - _loc6_.RoleHeight,0,false,CONST_BATTLE.TEXT_FIGHT_STATUS_Lost);
                        }
                     }
                     else if(!(FResults[_loc3_].TargetStatus & CONST_BATTLE.ActiveType_Punch))
                     {
                        _loc6_.ActivePlay(TActive.TYPE_ACTIVE_DODGE,0,null,null,null,0,FResults[_loc3_].CMD == 0);
                     }
                     if(this.FBattleStage.IsCrit)
                     {
                        this.FBattleStage.IsCrit = false;
                        this.FBattleStage.CriticalUI();
                     }
                  }
                  _loc3_++;
               }
            }
            if(Boolean(_loc1_.anmyhp) && _loc1_.anmyhp[FFrameIndex] != null)
            {
               _loc1_.anmyhp[FFrameIndex] = null;
            }
            if(Boolean(_loc1_.friendhp) && _loc1_.friendhp[FFrameIndex] != null)
            {
               _loc1_.friendhp[FFrameIndex] = null;
            }
         }
         if(_loc4_ == null || _loc10_ && FFrameIndex > 40)
         {
            this.FActiveCallBack = FCallBackDict[FIndex];
            this.FActiveTime = FTimeDict[FIndex];
            PlayFightIdle();
            if(FTargets != null)
            {
               _loc3_ = 0;
               for(; _loc3_ < FTargets.length; _loc3_++)
               {
                  if(this == FTargets[_loc3_])
                  {
                     if(FSkilling)
                     {
                        if(FResults[_loc3_].ResultInfo.HurtAnger > 0)
                        {
                           continue;
                        }
                     }
                     else if(FResults[_loc3_].ResultInfo.HurtAnger < 0)
                     {
                        continue;
                     }
                  }
                  if(CONST_BATTLE.HasEnemy(FTargets,Camp))
                  {
                     if(FTargets[_loc3_].Camp == Camp)
                     {
                        if(FResults[_loc3_].ResultInfo.HurtHp < 0 && FResults[_loc3_].HealthGaining < 100)
                        {
                           FTargets[_loc3_].AddEffect({
                              "target":2,
                              "effectId":CONST_BATTLE.Public_Effect_AddHp,
                              "friendhp":{"0":100}
                           },this,Vector.<TRole>([FTargets[_loc3_]]),Vector.<TTargetInfo>([FResults[_loc3_]]),FBitmap.x,FBitmap.y);
                        }
                     }
                  }
               }
            }
            if(FIdlePosition != null)
            {
               this.x = FIdlePosition[0];
               this.y = FIdlePosition[1];
            }
            FSkillId = 0;
            this.FWaitNextCommand = true;
         }
         else
         {
            if(FId == 11120930 && FPainFinal && FSkillId == 13120973 && FFrameIndex == 170 && FTextureFightIdle.Count > 1)
            {
               _loc4_ = FTextureFightIdle.GetAnimationSequenceByIndex(1).GetAnimationFrameByIndex(0);
            }
            _loc5_ = _loc4_.Surface;
            if(FBitmap.bitmapData != _loc5_ && !this.FHasFrozen)
            {
               FBitmap.bitmapData = _loc5_;
               FBitmap.x = -_loc4_.Pivot.X;
               FBitmap.y = -_loc4_.Pivot.Y;
               this.ObitoStandardPose(_loc4_);
               if(FId == 11120903 && FSkillId == 13120913 && (FIndex == TYPE_ACTIVE_ATTACK || FIndex == TYPE_ACTIVE_SKILL))
               {
                  var jiraiyaPose:Object = this.JiraiyaRasenganPose();
                  FBitmap.x += Number(jiraiyaPose.x);
                  FBitmap.y += Number(jiraiyaPose.y);
               }
               if(!FInitHpBarHeight && FIndex == TYPE_ACTIVE_FIGHT_IDLE)
               {
                  FInitHpBarHeight = true;
                  FHpBar.y = -(this.Height * 0.85 - (this.Height - this.FCurSequence.GetAnimationFrameByIndex(0).Pivot.Y) / 3);
               }
               if(this.FHideFrame >= 0 && this.FHideFrame != FFrameIndex)
               {
                  this.FHideFrame = -1;
                  FShaderBmp.visible = true;
                  FHpBar.visible = true;
                  FBuffSprite.visible = true;
               }
               if(FAttackEffect[FSkillId] != null && FAttackEffect[FSkillId].newPoint != null)
               {
                  _loc2_ = FAttackEffect[FSkillId].newPoint[FFrameIndex];
                  if(_loc2_ != null)
                  {
                     if(_loc2_.target == 2)
                     {
                        _loc9_ = Camp == 0 ? -100 : 100;
                        this.x = _loc2_.newPointX ? Number(_loc2_.newPointX) : CONST_BATTLE.AverageX(FTargets,Camp) + _loc9_;
                        this.y = _loc2_.newPointY ? Number(_loc2_.newPointY) : CONST_BATTLE.AverageY(FTargets,Camp);
                        this.FHideFrame = FFrameIndex;
                        FShaderBmp.visible = false;
                        FHpBar.visible = false;
                        FBuffSprite.visible = false;
                        FAttackEffect[FSkillId].newPoint[FFrameIndex] = null;
                     }
                  }
               }
               if(FAttackEffect[FSkillId] != null && FAttackEffect[FSkillId].runPoint != null)
               {
                  _loc2_ = FAttackEffect[FSkillId].runPoint[FFrameIndex];
                  if(_loc2_ != null)
                  {
                     _loc9_ = Camp == 0 ? -100 : 100;
                     TweenUtil.to(this,200 / TBattleHandle.PlaybackRate,{
                        "PosX":CONST_BATTLE.AverageX(FTargets,Camp) + _loc9_,
                        "PosY":CONST_BATTLE.AverageY(FTargets,Camp)
                     });
                     FAttackEffect[FSkillId].runPoint[FFrameIndex] = null;
                  }
               }
               if(FAttackEffect[FSkillId] != null && FAttackEffect[FSkillId].backPoint != null)
               {
                  _loc2_ = FAttackEffect[FSkillId].backPoint[FFrameIndex];
                  if(_loc2_ != null)
                  {
                     this.FightMoveBack();
                     FAttackEffect[FSkillId].backPoint[FFrameIndex] = null;
                  }
               }
            }
         }
         if(!this.FHasFrozen)
         {
            this.PainFlightPose(_loc4_);
         }
         if(!this.FHasFrozen)
         {
            this.HashiramaStrikePose(_loc4_);
            this.MechaStrikePose(_loc4_);
            this.FitMechaPose();
            this.FitGaaraPose();
            this.NagatoStrikePose(_loc4_);
            this.FitNagatoPose();
            this.FitItachiPose();
            this.FitSasukePose();
         }
         if(!this.FHasFrozen)
         {
            this.PainStrikePose(_loc4_);
         }
         if(FCurrentRebirthSequence != null)
         {
            FCurrentRebirthFrame = FCurrentRebirthSequence.GetAnimationFrameByTick(FTickReference);
            if(FCurrentRebirthFrame != null)
            {
               if(FRoleRebirthBitMap.bitmapData != FCurrentRebirthFrame.Surface)
               {
                  FRoleRebirthBitMap.bitmapData = FCurrentRebirthFrame.Surface;
                  FRoleRebirthBitMap.x = -FCurrentRebirthFrame.Pivot.X;
                  FRoleRebirthBitMap.y = -FCurrentRebirthFrame.Pivot.Y;
               }
            }
         }
         if(FWaitDie)
         {
            if(FIndex == TYPE_ACTIVE_ATTACKED && (_loc4_ == null || _loc10_ && FFrameIndex > 10) || FIndex != TYPE_ACTIVE_ATTACKED)
            {
               FWaitDie = false;
               this.ActivePlay(TActive.TYPE_ACTIVE_DIE);
            }
         }
         if(this.FWaitNextCommand)
         {
            if(TEffectControl.EffectCount <= 0)
            {
               this.FWaitNextCommand = false;
               if(FTargets != null)
               {
                  _loc3_ = 0;
                  while(_loc3_ < FTargets.length)
                  {
                     if(FResults[_loc3_].ResultInfo.CMD == TTargetInfo.CMD_ATTACKEX)
                     {
                        if(FResults[_loc3_].ResultInfo.HurtAnger > 0)
                        {
                           _loc13_ = Math.min(FResults[_loc3_].ResultInfo.HurtAnger,FTargets[_loc3_].CurAnger);
                        }
                        else
                        {
                           _loc13_ = FResults[_loc3_].ResultInfo.HurtAnger;
                        }
                        FTargets[_loc3_].AddAngerTextEffect(-_loc13_);
                     }
                     FTargets[_loc3_].CurAnger -= FResults[_loc3_].ResultInfo.HurtAnger;
                     _loc3_++;
                  }
               }
               if(this.FActiveCallBack != null)
               {
                  this.FActiveCallBack(this.FActiveTime);
               }
            }
         }
         FTickReference += SIZE_FrameRatePerSecond;
         if(this.FHasGiddy)
         {
            if(this.FGiddySequence == null)
            {
               this.LoadResources(CONST_BATTLE.Public_Effect_Giddy);
               return;
            }
            if(!this.FGiddyBitmap.visible)
            {
               this.FGiddyBitmap.visible = true;
            }
            if(this.FGiddySequence != null)
            {
               _loc4_ = this.FGiddySequence.GetAnimationFrameByTick(FTickReference);
            }
            if(_loc4_ != null)
            {
               if(FId == 11120930 && FPainFinal && FSkillId == 13120973 && FFrameIndex == 170 && FTextureFightIdle.Count > 1)
               {
                  _loc4_ = FTextureFightIdle.GetAnimationSequenceByIndex(1).GetAnimationFrameByIndex(0);
               }
               _loc5_ = _loc4_.Surface;
               if(this.FGiddyBitmap.bitmapData != _loc5_)
               {
                  this.FGiddyBitmap.bitmapData = _loc5_;
                  this.FGiddyBitmap.y = -RoleHeight;
               }
            }
         }
         else
         {
            this.FGiddyBitmap.visible = false;
         }
         if(this.FShieldBitmap.visible)
         {
            if(this.FShieldSequence != null)
            {
               _loc4_ = this.FShieldSequence.GetAnimationFrameByTick(FTickReference);
               this.FShieldBitmap.bitmapData = _loc4_.Surface;
            }
         }
         if(this.FHasFrozen)
         {
            if(this.FFrozenSequence == null)
            {
               this.LoadResources(CONST_BATTLE.Public_Effect_Frozen);
               return;
            }
            if(!this.FFrozenBitmap.visible)
            {
               this.FFrozenBitmap.visible = true;
            }
            if(this.FFrozenSequence != null)
            {
               _loc4_ = this.FFrozenSequence.GetAnimationFrameByTick(FTickReference);
            }
            if(_loc4_ != null)
            {
               if(FId == 11120930 && FPainFinal && FSkillId == 13120973 && FFrameIndex == 170 && FTextureFightIdle.Count > 1)
               {
                  _loc4_ = FTextureFightIdle.GetAnimationSequenceByIndex(1).GetAnimationFrameByIndex(0);
               }
               _loc5_ = _loc4_.Surface;
               if(this.FFrozenBitmap.bitmapData != _loc5_)
               {
                  this.FFrozenBitmap.bitmapData = _loc5_;
               }
            }
         }
         else
         {
            this.FFrozenBitmap.visible = false;
         }
      }
      
      public function AddBuffs(param1:TRole, param2:Vector.<TTargetInfo>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Vector.<int> = null;
         var _loc7_:int = 0;
         var _loc8_:uint = 0;
         var _loc9_:Sprite = null;
         var _loc10_:int = 0;
         var _loc11_:Boolean = false;
         var _loc12_:Vector.<int> = null;
         if(param2 == null)
         {
            return;
         }
         _loc12_ = new Vector.<int>();
         _loc3_ = 0;
         for(; _loc3_ < param2.length; _loc3_++)
         {
            if(param2[_loc3_].TargetCamp == Camp && param2[_loc3_].TargetPos == Pos)
            {
               _loc7_ = param2[_loc3_].ResultInfo.BuffId;
               _loc8_ = uint(param2[_loc3_].ResultInfo.BuffTurn);
               if(FId == 11120920 && _loc7_ > 0)
               {
                  var obitoBuff:TBuffEffect = this.FBuffBins.GetDatebaseByIdentifier(_loc7_) as TBuffEffect;
                  if(obitoBuff != null)
                  {
                     ShowObitoStatusText(obitoBuff.Name + (_loc8_ == 0 ? " / ENDED" : ""),obitoBuff.BuffType == 8 ? 16755336 : 12186746);
                  }
               }
               _loc11_ = false;
               if(_loc7_ > 0 && _loc8_ != 0)
               {
                  if(this.FBuffBins.GetDatebaseByIdentifier(_loc7_) != null)
                  {
                     _loc6_ = this.GetSameBuffIndex(this.FBuffIdVect,_loc7_);
                     if(_loc6_.length <= 1)
                     {
                        this.FBuffIdVect.push(_loc7_);
                        this.FBuffTurnVect.push(_loc8_);
                        _loc9_ = TPoolBitmap.GetBitmapSprite();
                        _loc9_.addEventListener(MouseEvent.MOUSE_MOVE,this.OnMouseMove);
                        _loc9_.addEventListener(MouseEvent.ROLL_OUT,this.OnRollOut);
                        _loc9_.mouseEnabled = true;
                        FBuffSprite.addChild(_loc9_);
                        this.FBuffSpriteVect.push(_loc9_);
                        this.FIsNewBuffVect.push(param1 == this);
                        continue;
                     }
                     _loc10_ = _loc6_[0];
                     _loc4_ = 0;
                     while(_loc4_ < _loc6_.length - 1)
                     {
                        _loc5_ = _loc6_[1 + _loc4_];
                        if(_loc10_ >= _loc6_[1 + _loc4_ + 1])
                        {
                           if(!_loc11_)
                           {
                              _loc11_ = true;
                              this.FBuffIdVect[_loc5_] = _loc7_;
                              this.FBuffTurnVect[_loc5_] = _loc8_;
                              this.FIsNewBuffVect[_loc5_] = param1 == this;
                           }
                           else
                           {
                              _loc12_.push(_loc5_);
                           }
                        }
                        _loc4_ += 2;
                     }
                  }
               }
               else
               {
                  this.DelSameTypeBuffIndex(_loc8_);
               }
            }
            this.CheckTextEffect(param2[_loc3_]);
         }
         _loc3_ = 0;
         while(_loc3_ < _loc12_.length)
         {
            _loc5_ = _loc12_[_loc3_];
            this.DelBuffs(this.FBuffIdVect[_loc5_]);
            _loc3_++;
         }
      }
      
      public function CheckBuffsHurt(param1:Vector.<TTargetInfo>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TTargetInfo = null;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc4_ = param1[_loc2_];
            _loc3_ = this.FBuffIdVect.indexOf(_loc4_.ResultInfo.BuffId);
            if(_loc3_ >= 0)
            {
               if(_loc4_.ResultInfo.HurtHp != 0)
               {
                  this.ChangeHP(_loc4_.ResultInfo.HurtHp);
                  if(this.FTextFunction != null)
                  {
                     if(_loc4_.ResultInfo.HurtHp < 0)
                     {
                        this.FTextFunction(TBattleStage.TYPETEXT_Float,Camp == 0 ? -1 : 1,this.x,this.y - this.RoleHeight,"+" + int(Math.abs(_loc4_.ResultInfo.HurtHp)),false,CONST_BATTLE.GetBuffSkillIndex(_loc4_.ResultInfo.BuffId));
                     }
                     else
                     {
                        this.FTextFunction(TBattleStage.TYPETEXT_Float,Camp == 0 ? -1 : 1,this.x,this.y - this.RoleHeight,_loc4_.ResultInfo.HurtHp,false,CONST_BATTLE.GetBuffSkillIndex(_loc4_.ResultInfo.BuffId));
                     }
                  }
                  this.CheckDie();
               }
               if(_loc4_.ResultInfo.HurtAnger != 0)
               {
                  CurAnger -= _loc4_.ResultInfo.HurtAnger;
               }
            }
            _loc2_++;
         }
      }
      
      public function CheckBuffs(param1:int = 0) : void
      {
         var _loc2_:* = 0;
         var _loc3_:Boolean = false;
         _loc2_ = 0;
         while(_loc2_ < this.FBuffTurnVect.length)
         {
            if(this.CheckBuffContinued(this.FBuffIdVect[_loc2_],param1))
            {
               _loc3_ = this.FIsNewBuffVect[_loc2_];
               if(_loc3_)
               {
                  this.FIsNewBuffVect[_loc2_] = false;
               }
               else
               {
                  --this.FBuffTurnVect[_loc2_];
                  if(this.FBuffTurnVect[_loc2_] <= 0)
                  {
                     this.DelBuffByIndex(_loc2_);
                     _loc2_--;
                  }
               }
            }
            _loc2_++;
         }
      }
      
      public function ChgNewBuffs() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Boolean = false;
         _loc1_ = 0;
         while(_loc1_ < this.FBuffTurnVect.length)
         {
            this.FIsNewBuffVect[_loc1_] = false;
            _loc1_++;
         }
      }
      
      public function CheckBuffUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:Bitmap = null;
         var _loc5_:Number = Number(NaN);
         var _loc6_:Number = Number(NaN);
         var _loc7_:TBuffEffect = null;
         var _loc8_:TTexture = null;
         var _loc9_:TAnimationSequence = null;
         this.FHasGiddy = false;
         this.FHasFrozen = false;
         _loc1_ = 0;
         while(_loc1_ < this.FBuffIdVect.length)
         {
            _loc2_ = int(this.FBuffIdVect[_loc1_]);
            _loc3_ = this.FBuffSpriteVect[_loc1_];
            if(Camp == 0)
            {
               _loc5_ = CONST_BUFF_StampX_Left + int(_loc1_ / CONST_BUFF_Const) * CONST_BUFF_Width;
               _loc6_ = CONST_BUFF_StampY + int(_loc1_ % CONST_BUFF_Const) * CONST_BUFF_Height;
            }
            else
            {
               _loc5_ = CONST_BUFF_StampX_Right + int(_loc1_ / CONST_BUFF_Const) * CONST_BUFF_Width - CONST_BUFF_Width;
               _loc6_ = CONST_BUFF_StampY + int(_loc1_ % CONST_BUFF_Const) * CONST_BUFF_Height;
            }
            _loc7_ = this.FBuffBins.GetDatebaseByIdentifier(_loc2_) as TBuffEffect;
            _loc3_.x = _loc5_;
            _loc3_.y = _loc6_;
            _loc4_ = _loc3_.getChildAt(0) as Bitmap;
            _loc8_ = SResourcesCore.TexturesBuffIcon.GetTextureByIdentifier(_loc7_.IconUrl);
            if(_loc8_ != null)
            {
               _loc9_ = SResourcesCore.TexturesBuffIcon.GetAnimationSequenceByIdentifiers(_loc7_.IconUrl,0);
               _loc4_.bitmapData = _loc9_.GetAnimationFrameByIndex(0).Surface;
            }
            else
            {
               SResourcesCore.TexturesBuffIcon.LoadSecondary(_loc7_.IconUrl);
            }
            if(_loc7_.IconUrl == 13500031)
            {
               this.FHasGiddy = true;
            }
            if(_loc7_.IconUrl == 13500050)
            {
               this.FHasFrozen = true;
            }
            _loc1_++;
         }
      }
      
      public function CheckDie() : void
      {
         if(CurHealth < 1)
         {
            FWaitDie = true;
         }
      }
      
      public function ChgPosition(param1:Vector.<TTargetInfo>) : void
      {
         var _loc2_:TTargetInfo = null;
         var _loc3_:uint = 0;
         _loc2_ = param1[0];
         _loc3_ = uint(_loc2_.ResultInfo.BuffTurn);
         this.SetPosition(SBattleConfig.GetPostionByCamyPos(Camp,_loc3_,SBattleConfig.Type_PostionX),SBattleConfig.GetPostionByCamyPos(Camp,_loc3_,SBattleConfig.Type_PostionY));
         Pos = _loc3_;
      }
      
      public function AddStatus(param1:TTargetInfo) : void
      {
         var _loc2_:int = 0;
         if(param1 != null)
         {
            if(param1.TargetStatus & CONST_BATTLE.ActiveType_Punch)
            {
               this.AddTextEffect(param1.TargetStatus);
            }
         }
      }
      
      public function DelStatus(param1:int, param2:int = -1) : Boolean
      {
         var _loc3_:TGoneWord = null;
         _loc3_ = this.FStatusGoneWordDict[param1];
         if(_loc3_ != null)
         {
            if(param2 >= 0)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,param2);
            }
            _loc3_.SaveSelf();
            this.FStatusGoneWordDict[param1] = null;
            return true;
         }
         return false;
      }
      
      public function FightMoveBack() : void
      {
         TweenUtil.to(this,200 / TBattleHandle.PlaybackRate,{
            "x":FIdlePosition[0],
            "y":FIdlePosition[1]
         });
      }
      
      public function ShieldOP(param1:TTargetInfo) : void
      {
         if(FId == 11120920)
         {
            ShowObitoStatusText(param1.ResultInfo.BuffTurn > 0 ? "SHIELD " + param1.ResultInfo.BuffTurn : "SHIELD ENDED",8773119);
         }
         var _loc2_:Boolean = false;
         this.FShieldBlood = param1.ResultInfo.BuffTurn;
         _loc2_ = this.FShieldBlood > 0;
         if(this.FShieldBitmap.visible != _loc2_)
         {
            this.FShieldBitmap.visible = _loc2_;
         }
      }
      
      override public function CheckDirection() : void
      {
         super.CheckDirection();
      }
      
      public function ResetRole(param1:TUIComponent, param2:TRoleBattleInfo, param3:TBattleStage, param4:Function = null) : void
      {
         ResetBaseRole(param1,param2);
         this.FBattleStage = param3;
         this.FTextFunction = param4;
         this.FShieldBlood = 0;
         this.FShieldBitmap.visible = false;
         this.FShieldBitmap.bitmapData = null;
         this.FHasGiddy = false;
         this.FHasFrozen = false;
         this.InitCharacter();
      }
      
      public function AddTextEffectByCMD(param1:TTargetInfo) : void
      {
         var notices:Array;
         var mechaNames:Array;
         var mechaMessage:String;
         var hashValue:int;
         var hashNames:Array;
         var hashMessage:String;
         var painNames:Array;
         var painMessage:String;
         var painValue:int;
         var obitoNames:Array;
         var obitoText:TextField;
         var previousToad:DisplayObject;
         var _loc2_:int;
         var barrierUI:TextField;
         var stateIndex:int;
         var stateNames:Array;
         var stateColors:Array;
         var labelName:String;
         var oldLabel:DisplayObject;
         var chaseLabel:TextField;
         var startY:Number;
         var started:int;
         var animate:Function;
         var removed:Function;
         var marker:uint;
         var isJiraiyaLabel:Boolean;
         var isChase:Boolean;
         var obitoNoticeNames:Array;
         var obitoMessage:String;
         var sourceChase:Boolean;
         var sourceStates:Array;
         var obitoChase:Boolean;
         var obitoStates:Array;
         var obitoMarker:uint;
         var painMarker:uint;
         var hashMarker:uint;
         var mechaMarker:uint;
         var itachiMarker:uint;
         var sasukeMarker:uint;
         var gaaraMarker:uint = uint(param1.ResultInfo.BuffId);
         if(param1.CMD == TTargetInfo.CMD_FLOAT && gaaraMarker > 19001600 && gaaraMarker < 19001610)
         {
            notices = ["","DISCOURAGEMENT II","BLINDNESS II","STANDARD -50% / HEALING -40%","SAND GUARD / CLEANSE","SUPPRESS SUPER ARMOR","CRITICAL RATE -" + param1.ResultInfo.BuffTurn + "%","SUPER ARMOR II"];
            ShowHashiramaStatusText(String(notices[gaaraMarker - 19001600]),15125635);
            return;
         }
         sasukeMarker = uint(param1.ResultInfo.BuffId);
         if(param1.CMD == TTargetInfo.CMD_FLOAT && sasukeMarker > 19001400 && sasukeMarker < 19001410)
         {
            notices = ["","AMATERASU BLAZE","ELECTROCUTION","STATIC","DISORDER","EXTREME FEAR","LEVEL 2 IGNITION","VISUAL JUTSU"];
            ShowHashiramaStatusText(String(notices[sasukeMarker - 19001400]),11831551);
            return;
         }
         itachiMarker = uint(param1.ResultInfo.BuffId);
         if(param1.CMD == TTargetInfo.CMD_FLOAT && itachiMarker > 19001200 && itachiMarker < 19001220)
         {
            notices = ["","SUPPRESS IMMUNITY","SUPPRESS SUPER ARMOR","CRITICAL GROWTH / HP +15%","CHAKRA DRAIN / LIMIT " + param1.ResultInfo.BuffTurn,"EXTREME CHAOS","MYSTERY CHAKRA COST +" + param1.ResultInfo.BuffTurn,"LEVEL 2 IGNITION / PARALYSIS","DEBUFF CANCELLED / HIDING"];
            ShowHashiramaStatusText(String(notices[itachiMarker - 19001200]),16764006);
            return;
         }
         mechaMarker = uint(param1.ResultInfo.BuffId);
         if(param1.CMD == TTargetInfo.CMD_FLOAT && mechaMarker >= 19001001 && mechaMarker <= 19001015)
         {
            mechaNames = ["","CHAKRA BOMB / INTERRUPTION","SUPPRESS SUPER ARMOR","MYSTERY COOLDOWN +1","TEAM MYSTERY COST REDUCED","IMMOBILE / MODIFIED RASENGAN","SUPPRESS IMMUNITY","STOLEN STANDARD ATTACKS","ADVANCE TECHNOLOGY","JET / CHAKRA +20","TAILED BEAST MODE","ENERGY RECOVERY / ADVANCED IMMUNITY","MYSTERY LOCKED AT 1","KURAMA ATK GROWTH","LEVEL 2 IGNITION","INFLAMMATION"];
            mechaMessage = mechaNames[mechaMarker - 19001000];
            if(mechaMarker == 19001007)
            {
               mechaMessage += " +" + param1.ResultInfo.BuffTurn;
            }
            if(mechaMarker == 19001008)
            {
               mechaMessage += " ATK +" + param1.ResultInfo.BuffTurn * 15 + "% CRIT +" + param1.ResultInfo.BuffTurn * 8 + "%";
            }
            ShowHashiramaStatusText(mechaMessage,16765803);
            return;
         }
         hashMarker = uint(param1.ResultInfo.BuffId);
         if(param1.CMD == TTargetInfo.CMD_FLOAT && hashMarker >= 19000901 && hashMarker <= 19000917)
         {
            hashValue = param1.ResultInfo.BuffTurn;
            hashNames = ["","TECHNIQUE POINTS","EXCITED MODE","DEEP FOREST / EXPLOSIVE 2 ROUNDS","MYSTERY DAMAGE","DEITY GATE SEAL II","WEAKNESS II","IRREMOVABLE ENFEEBLE","ROOT BINDING II","INTERRUPTION","SENJUTSU GROWTH","LIFE STEAL / HEAL","CHAKRA ABSORBED","STANDARD ATTEMPTS -1","EXTRA STANDARD","SUPPRESS IMMUNITY","EVASION CAP 20%","DEEP FOREST ENDED"];
            hashMessage = hashNames[hashMarker - 19000900];
            if(hashMarker == 19000901)
            {
               hashMessage = "TP " + hashValue / 10 + " / 2";
            }
            if(hashMarker == 19000904)
            {
               hashMessage += " +" + hashValue + "%";
            }
            if(hashMarker == 19000910)
            {
               hashMessage += " +3%";
            }
            if(hashMarker == 19000911)
            {
               hashMessage += " +" + hashValue + " HP";
            }
            if(hashMarker == 19000912)
            {
               hashMessage += " +" + hashValue;
            }
            ShowHashiramaStatusText(hashMessage,hashMarker >= 19000905 && hashMarker <= 19000909 ? 16756098 : 12054922);
            return;
         }
         painMarker = uint(param1.ResultInfo.BuffId);
         if(param1.CMD == TTargetInfo.CMD_FLOAT && painMarker >= 19000801 && painMarker <= 19000814)
         {
            painNames = ["TECHNIQUE POINTS","HORROR II / FEAR","CHAKRA DISRUPTION II","PAIN II","MYSTERY CHAKRA COST","INTERRUPTION","INITIATIVE","ATTACK GROWTH","LIFE STEAL","CHAKRA LIMIT","CHAKRA REMOVED","IMMUNE TO INTERRUPTION / RINNEGAN MYSTERIES UNAVOIDABLE","FINAL FORM / REVIVE 100%","FINAL REVIVE 40% / SUPER PUSH"];
            painMessage = painNames[painMarker - 19000801];
            painValue = param1.ResultInfo.BuffTurn;
            if(painMarker == 19000801)
            {
               painMessage = "TP " + painValue / 10 + " / 5";
               if(FPainTechnique != null)
               {
                  FPainTechnique.text = (FPainFinal ? "FINAL / " : "") + painMessage;
               }
            }
            if(painMarker == 19000805 || painMarker == 19000810 || painMarker == 19000811)
            {
               painMessage += " " + painValue;
            }
            if(painMarker == 19000807 || painMarker == 19000808)
            {
               painMessage += " +" + painValue + "%";
            }
            if(painMarker == 19000809)
            {
               painMessage += " +" + painValue + " HP";
            }
            if(painMarker == 19000813)
            {
               FPainFinal = true;
               if(FPainTechnique != null)
               {
                  FPainTechnique.text = "FINAL / " + FPainTechnique.text;
               }
            }
            ShowPainStatusText(painMessage,painMarker >= 19000802 && painMarker <= 19000806 ? 16755353 : 13743871);
            return;
         }
         obitoMarker = uint(param1.ResultInfo.BuffId);
         if(param1.CMD == TTargetInfo.CMD_FLOAT && obitoMarker >= 19000501 && obitoMarker <= 19000512)
         {
            obitoNoticeNames = ["RAGE MODE","KAMUI","KAMUI TAG II","SUPPRESS IMMUNITY","CHAKRA ABSORB","IMMOBILE","CHASE DAMAGE +40%","LIFE STEAL","EXTRA STANDARD +1","ROOTS CHAKRA COST","KAMUI DODGE","KAMUI FATAL GUARD"];
            obitoMessage = obitoNoticeNames[obitoMarker - 19000501];
            if(obitoMarker == 19000508)
            {
               obitoMessage += " +" + param1.ResultInfo.BuffTurn + " HP";
            }
            if(obitoMarker == 19000510)
            {
               obitoMessage += " " + param1.ResultInfo.BuffTurn;
            }
            ShowObitoStatusText(obitoMessage,obitoMarker == 19000501 ? 16733525 : 12186746);
            return;
         }
         if(param1.CMD == TTargetInfo.CMD_FLOAT && (obitoMarker >= 19000600 && obitoMarker <= 19000605 || obitoMarker >= 19000700 && obitoMarker <= 19000705))
         {
            sourceChase = obitoMarker >= 19000700;
            sourceStates = ["COMBO","LOW FLOAT","HIGH FLOAT","KNOCKDOWN","REPULSE","IMMOBILE"];
            ShowObitoStatusText((sourceChase ? "CHASE / " : "") + sourceStates[obitoMarker - (sourceChase ? 19000700 : 19000600)] + " / " + param1.ResultInfo.BuffTurn + " COMBO",16769689);
            return;
         }
         if(FId == 11120920 && param1.CMD == TTargetInfo.CMD_FLOAT)
         {
            if(obitoMarker >= 19000100 && obitoMarker <= 19000105 || obitoMarker >= 19000200 && obitoMarker <= 19000205)
            {
               obitoChase = obitoMarker >= 19000200;
               obitoStates = ["COMBO","LOW FLOAT","HIGH FLOAT","KNOCKDOWN","REPULSE","IMMOBILE"];
               ShowObitoStatusText((obitoChase ? "CHASE / " : "") + obitoStates[obitoMarker - (obitoChase ? 19000200 : 19000100)] + " / " + param1.ResultInfo.BuffTurn + " COMBO",16769689);
               return;
            }
         }
         marker = uint(param1.ResultInfo.BuffId);
         isJiraiyaLabel = marker >= 19000301 && marker <= 19000309;
         isChase = marker >= 19000200 && marker <= 19000205;
         if(isJiraiyaLabel || isChase || marker >= 19000100 && marker <= 19000105)
         {
            if(parent == null)
            {
               return;
            }
            if(marker == 19000301 || marker == 19000309)
            {
               SetJiraiyaBarrier(this.FBattleStage,marker == 19000301);
               barrierUI = parent.getChildByName("jiraiyaBarrierStatus") as TextField;
               if(barrierUI != null)
               {
                  parent.removeChild(barrierUI);
               }
               if(marker == 19000301)
               {
                  barrierUI = new TextField();
                  barrierUI.name = "jiraiyaBarrierStatus";
                  barrierUI.defaultTextFormat = new TextFormat("_sans",16,16756912,true,null,null,null,null,"center");
                  barrierUI.text = "TOAD ESOPHAGUS | Barrier Mysteries sealed (2 rounds)";
                  barrierUI.width = 560;
                  barrierUI.height = 30;
                  barrierUI.x = 340;
                  barrierUI.y = 70;
                  barrierUI.mouseEnabled = false;
                  barrierUI.selectable = false;
                  barrierUI.filters = [new GlowFilter(528416,1,4,4,5)];
                  parent.addChild(barrierUI);
               }
            }
            stateIndex = marker - (isJiraiyaLabel ? 19000300 : (isChase ? 19000200 : 19000100));
            stateNames = isJiraiyaLabel ? ["","TOAD ESOPHAGUS","EXTREME CHAOS","CHAOS / IMMUNITY SUPPRESSED","SENJUTSU POWER","CHAKRA","RESISTANCE DOWN","REVIVE 30% HP","CHASE LIMIT +1","TOAD ESOPHAGUS ENDED"] : ["","Low Float","High Float","Knockdown","Repulse","Immobile"];
            stateColors = isJiraiyaLabel ? [16777215,16752293,14392319,14392319,16769901,7858175,16757852,9043885,16769901,16752293] : [16769901,7858175,8826367,16757852,16745861,14392319];
            labelName = "chaseFloat_" + Camp + "_" + Pos;
            oldLabel = parent.getChildByName(labelName);
            if(oldLabel != null)
            {
               parent.removeChild(oldLabel);
            }
            chaseLabel = new TextField();
            chaseLabel.name = labelName;
            chaseLabel.defaultTextFormat = new TextFormat("_sans",16,stateColors[stateIndex],true,null,null,null,null,"center");
            chaseLabel.text = isJiraiyaLabel ? String(stateNames[stateIndex]) : (isChase ? "CHASE  " : "") + stateNames[stateIndex] + "\n" + String(param1.ResultInfo.BuffTurn) + " COMBO";
            if(FId == 11120920)
            {
               ShowObitoStatusText(chaseLabel.text.replace("\n"," / "),stateColors[stateIndex]);
               return;
            }
            chaseLabel.width = 300;
            chaseLabel.height = 62;
            chaseLabel.x = x - 150;
            startY = y - RoleHeight - 66;
            chaseLabel.y = startY;
            chaseLabel.mouseEnabled = false;
            chaseLabel.selectable = false;
            chaseLabel.filters = [new GlowFilter(528416,1,4,4,5)];
            parent.addChild(chaseLabel);
            started = TBattleHandle.PlaybackTime;
            animate = function(event:Event):void
            {
               var progress:Number = Math.min(1,(TBattleHandle.PlaybackTime - started) / 1400);
               chaseLabel.y = startY - 58 * progress;
               chaseLabel.alpha = progress < 0.65 ? 1 : (1 - progress) / 0.35;
               if(progress >= 1 && chaseLabel.parent != null)
               {
                  chaseLabel.parent.removeChild(chaseLabel);
               }
            };
            removed = function(event:Event):void
            {
               chaseLabel.removeEventListener(Event.ENTER_FRAME,animate);
               chaseLabel.removeEventListener(Event.REMOVED_FROM_STAGE,removed);
            };
            chaseLabel.addEventListener(Event.ENTER_FRAME,animate);
            chaseLabel.addEventListener(Event.REMOVED_FROM_STAGE,removed);
            return;
         }
         _loc2_ = 0;
         if(this.FTextFunction != null)
         {
            _loc2_ = CONST_BATTLE.TEXT_TYPES.indexOf(param1.ResultInfo.BuffId);
            if(_loc2_ != -1)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,Camp == 0 ? -1 : 1,x,y - RoleHeight,0,false,CONST_BATTLE.TEXT_TYPES_TO_TEXTSTATUS[_loc2_]);
            }
         }
      }
      
      private function StartSkillBattleShake() : void
      {
      }
   }
}

