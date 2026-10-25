package com.tencent.morefun.naruto.loading
{
   import file.FileAssetManager;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   import flash.utils.getTimer;
   import ui.loading.LoadingContentView;
   
   public class NarutoLoadingView extends MovieClip
   {
      
      public var view:LoadingContentView;
      
      public var topPic:MovieClip;
      
      private var Logo2017:Class = NarutoLoadingView_Logo2017;
      
      private var startLoaded:Boolean;
      
      private var ss:Number;
      
      private var _percent:Number = 0;
      
      private var _record:Number;
      
      public function NarutoLoadingView()
      {
         super();
         addEventListener(Event.REMOVED_FROM_STAGE,this.stageHandler);
         addEventListener(Event.ADDED_TO_STAGE,this.stageHandler);
         this["mc_black"]["btn_black"].addEventListener(MouseEvent.CLICK,this.onHelpClick);
         this["mc_black"]["btn_area"].addEventListener(MouseEvent.CLICK,this.onHelpClick);
      }
      
      public function startLoad() : void
      {
         var urlloader:URLLoader = null;
         if(this.startLoaded)
         {
            return;
         }
         this.startLoaded = true;
         urlloader = new URLLoader();
         urlloader.dataFormat = URLLoaderDataFormat.BINARY;
         urlloader.addEventListener(Event.COMPLETE,function(param1:Event):void
         {
            var bytes:ByteArray;
            var xml:XML;
            var len:int;
            var itemList:Array;
            var curTime:Date;
            var i:int;
            var wsum:int;
            var r:int;
            var itemP:XML = null;
            var beginTime:Date = null;
            var endTime:Date = null;
            var loader:URLLoader = null;
            var e:Event = param1;
            e.currentTarget.removeEventListener(Event.COMPLETE,arguments.callee);
            bytes = urlloader.data;
            try
            {
               bytes.uncompress();
            }
            catch(e:Error)
            {
            }
            e.currentTarget.removeEventListener(Event.COMPLETE,arguments.callee);
            xml = new XML(bytes);
            len = xml.p.length();
            itemList = [];
            curTime = new Date();
            i = 0;
            while(i < len)
            {
               itemP = xml.p[i];
               if(itemP.hasOwnProperty("@beginTime") && itemP.hasOwnProperty("@endTime"))
               {
                  beginTime = parseDate(itemP.@beginTime);
                  endTime = parseDate(itemP.@endTime);
                  if(curTime >= beginTime && curTime <= endTime)
                  {
                     itemList.push(itemP);
                  }
               }
               else if(int(itemP.@w > 0))
               {
                  itemList.push(itemP);
               }
               i++;
            }
            wsum = 0;
            i = 0;
            while(i < itemList.length)
            {
               wsum += int(itemList[i].@w);
               i++;
            }
            r = Math.random() * wsum;
            wsum = 0;
            i = 0;
            while(i < itemList.length)
            {
               wsum += int(itemList[i].@w);
               if(wsum > r)
               {
                  ss = getTimer();
                  loader = new URLLoader();
                  loader.dataFormat = URLLoaderDataFormat.BINARY;
                  loader.addEventListener(Event.COMPLETE,versionCompleteHandler);
                  loader.load(new URLRequest(FileAssetManager.getQualifiedUrl("assets/loading/" + itemList[i].@url)));
                  return;
               }
               i++;
            }
         });
         urlloader.load(new URLRequest(FileAssetManager.getQualifiedUrl("assets/loading/cfg.xml")));
      }
      
      private function parseDate(param1:String) : Date
      {
         var _loc2_:Array = String(param1.split(" ")[0]).split("-");
         var _loc3_:Array = String(param1.split(" ")[1]).split(":");
         return new Date(_loc2_[0],int(_loc2_[1]) - 1,_loc2_[2],_loc3_[0],_loc3_[1],_loc3_[2]);
      }
      
      private function versionCompleteHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:URLLoader = param1.currentTarget as URLLoader;
         var _loc4_:Loader = new Loader();
         _loc4_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.bgCompleteHandler);
         _loc4_.loadBytes(_loc3_.data);
         addChildAt(_loc4_,0);
      }
      
      public function loadBackgroundIcon(param1:String = "http://game.huoying.qq.com", param2:Function = null) : void
      {
         var baseURL:String = param1;
         var completeFun:Function = param2;
         var bytes:ByteArray = new this.Logo2017() as ByteArray;
         var loader:Loader = new Loader();
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(param1:Event):void
         {
            param1.currentTarget.removeEventListener(Event.COMPLETE,arguments.callee);
            completeFun();
         });
         loader.loadBytes(bytes,new LoaderContext(false,ApplicationDomain.currentDomain));
         addChild(loader);
      }
      
      private function bgCompleteHandler(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:Loader = (param1.currentTarget as LoaderInfo).loader;
         _loc3_.x = -_loc3_.width / 2;
         _loc3_.y = -_loc3_.height / 2;
      }
      
      private function stageHandler(param1:Event) : void
      {
         if(param1.type == Event.ADDED_TO_STAGE)
         {
            this.resizeUpdate(null);
            stage.addEventListener(Event.RESIZE,this.resizeUpdate);
         }
         else if(param1.type == Event.REMOVED_FROM_STAGE)
         {
            stage.removeEventListener(Event.RESIZE,this.resizeUpdate);
         }
      }
      
      private function resizeUpdate(param1:Event) : void
      {
         this.x = stage.stageWidth / 2;
         this.y = stage.stageHeight / 2;
         this["mc_black"].x = -stage.stageWidth / 2;
         this["mc_black"].y = stage.stageHeight / 2;
         var _loc2_:Point = globalToLocal(new Point());
         graphics.clear();
         graphics.beginFill(0,1);
         graphics.drawRect(_loc2_.x,_loc2_.y,stage.stageWidth,stage.stageHeight);
         graphics.endFill();
      }
      
      public function dispose() : void
      {
         this.parent && this.parent.removeChild(this);
         this.stopAll(this);
         removeChildren();
         this.view = null;
      }
      
      private function stopAll(param1:DisplayObjectContainer) : void
      {
         var _loc4_:DisplayObject = null;
         if(param1 is MovieClip)
         {
            (param1 as MovieClip).stop();
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.numChildren)
         {
            _loc4_ = param1.getChildAt(_loc3_);
            if(_loc4_ is DisplayObjectContainer)
            {
               arguments.callee(_loc4_ as DisplayObjectContainer);
            }
            _loc3_++;
         }
      }
      
      public function get percent() : Number
      {
         return this._percent;
      }
      
      public function set percent(param1:Number) : void
      {
         this._percent = isNaN(param1) ? 0 : Math.min(100,Math.max(0,param1));
         this.view.percent.text = Math.floor(this._percent + 1 / 10000000).toString();
         this.view.barMask.scaleX = this._percent / 100;
         this.view.anchor.x = this.view.barMask.x + this.view.barMask.width;
         this.view.anchorAnimation.x = this.view.anchor.x - 25;
      }
      
      public function get tips() : String
      {
         return this.view.tips.text;
      }
      
      public function set tips(param1:String) : void
      {
         this.view.tips.text = param1;
      }
      
      public function get record() : Number
      {
         return this._record;
      }
      
      public function set record(param1:Number) : void
      {
         this._record = param1;
      }
      
      public function get errorTips() : String
      {
         return this.view.errorTips.text;
      }
      
      public function set errorTips(param1:String) : void
      {
         this.view.errorTips.text = param1;
      }
      
      private function onHelpClick(param1:MouseEvent) : void
      {
         var _loc2_:Date = new Date();
         navigateToURL(new URLRequest("https://naruto-de.oasgames.com/Naruto.zip?t=" + _loc2_.time),"_blank");
      }
   }
}

