package Processors_Mini.Accessories
{
   import Logics.Agent.*;
   import Logics.Agent.Spaces.*;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.system.*;
   import flash.text.*;
   import flash.utils.*;
   import Ǹ.*;
   import Ǻ.ǹ;
   import ǽ.Ǽ;
   
   use namespace ParametersSpace;
   
   public class TProcessorMiniLoad extends Sprite
   {
      
      protected static const STRING_LoadXMLUrl:String = "version.swf";
      
      protected static const STRING_LoadMainUrl:String = "TApplication.swf";
      
      protected static const RESOURCE_ClassName_MC_Loading:String = "MC_Loading";
      
      protected static const RESOURCE_Link_MC_Effect1:String = "MC_Effect1";
      
      protected static const RESOURCE_Link_MC_Effect2:String = "MC_Effect2";
      
      protected static const RESOURCE_Link_SP_ProgressBigBar:String = "SP_ProgressBigBar";
      
      protected static const RESOURCE_Link_TF_ProgressText:String = "TF_ProgressText";
      
      protected static const RESOURCE_Link_TF_LoadingTips:String = "TF_LoadingTips";
      
      private var Data_Cls:Class = ǻ;
      
      protected var FLoader:Loader;
      
      protected var FUrlLoader:URLLoader;
      
      protected var FMC_Loading:Sprite;
      
      protected var FMC_Effect1:MovieClip;
      
      protected var FMC_Effect2:MovieClip;
      
      protected var FMC_HappyBear:MovieClip;
      
      protected var FSP_ProgressBigBar:Sprite;
      
      protected var FTF_ProgressText:TextField;
      
      protected var FTF_LoadingTips:TextField;
      
      protected var FTF_LoadingTipsExtra:TextField;
      
      protected var FKeys:ByteArray;
      
      protected var FMainSwfData:ByteArray;
      
      protected var FOnLoadingCompleted:Function;
      
      public function TProcessorMiniLoad()
      {
         super();
         this.FMC_Loading = new Ƕ();
         this.addChild(this.FMC_Loading);
         this.ResourcesPerform_UIDispatch();
         this.LoadResourceXml();
      }
      
      protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:Sprite = null;
         _loc1_ = this.FMC_Loading["SP_Background"];
         this.FMC_Effect1 = this.FMC_Loading[RESOURCE_Link_MC_Effect1];
         this.FMC_Effect2 = this.FMC_Loading[RESOURCE_Link_MC_Effect2];
         this.FMC_HappyBear = this.FMC_Loading["HappyBear"];
         this.FSP_ProgressBigBar = this.FMC_Loading[RESOURCE_Link_SP_ProgressBigBar];
         this.FTF_ProgressText = this.FMC_Loading[RESOURCE_Link_TF_ProgressText];
         this.FTF_LoadingTips = this.FMC_Loading[RESOURCE_Link_TF_LoadingTips];
         this.FTF_LoadingTips.text = ǹ.ȫ[Ƿ.Ȥ(0,ǹ.ȫ.length - 1)];
         this.FSP_ProgressBigBar.scaleX = 0;
         this.PlayHappyBrea(true);
      }
      
      protected function LoadResourceXml() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         this.FUrlLoader = new URLLoader();
         this.FUrlLoader.dataFormat = URLLoaderDataFormat.BINARY;
         this.FUrlLoader.addEventListener(Event.COMPLETE,this.XMLLoadOnCompleted);
         this.FUrlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.URLLoaderOnError);
         _loc2_ = this.GetClientVersion();
         if(_loc2_.length > 0)
         {
            _loc1_ = SParametersCore.CdnRoot + _loc2_ + "/" + STRING_LoadXMLUrl;
         }
         else
         {
            _loc1_ = SParametersCore.CdnRoot + STRING_LoadXMLUrl;
         }
         this.FUrlLoader.load(new URLRequest(_loc1_));
      }
      
      protected function LoadMainSwfFile() : void
      {
         var _loc1_:String = null;
         var _loc2_:Dictionary = null;
         var _loc3_:String = null;
         _loc1_ = "";
         this.FUrlLoader.dataFormat = URLLoaderDataFormat.BINARY;
         this.FUrlLoader.addEventListener(Event.COMPLETE,this.MainSwfFileLoadOnCompleted);
         this.FUrlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.URLLoaderOnError);
         this.FUrlLoader.addEventListener(ProgressEvent.PROGRESS,this.LoadOnProgress);
         _loc2_ = SParametersCore.ResourceConfig;
         if(_loc2_)
         {
            _loc3_ = _loc2_[STRING_LoadMainUrl];
            if(Boolean(_loc3_) && _loc3_.length > 0)
            {
               _loc1_ = _loc2_[STRING_LoadMainUrl] + "/" + STRING_LoadMainUrl;
            }
            else
            {
               _loc1_ = STRING_LoadMainUrl;
            }
         }
         _loc1_ = SParametersCore.CdnRoot + _loc1_;
         this.FUrlLoader.load(new URLRequest(_loc1_));
      }
      
      protected function DecryptMainSwfFile() : void
      {
         this.FKeys = new this.Data_Cls() as ByteArray;
         Ǽ.Ȭ(this.FMainSwfData,this.FKeys);
         this.FLoader = new Loader();
         this.FLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.LoadOnCompleted);
         this.FLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.LoadOnError);
         this.FLoader.loadBytes(this.FMainSwfData);
      }
      
      protected function GetClientVersion() : String
      {
         var _loc1_:String = null;
         return SParametersCore.ClientVersion.toString();
      }
      
      protected function PlayHappyBrea(param1:Boolean = true) : void
      {
         if(param1)
         {
            this.FMC_HappyBear.play();
         }
         else
         {
            this.FMC_HappyBear.stop();
         }
      }
      
      protected function XMLRemoveEventListeners() : void
      {
         if(this.FUrlLoader != null)
         {
            this.FUrlLoader.removeEventListener(Event.COMPLETE,this.XMLLoadOnCompleted);
            this.FUrlLoader.removeEventListener(Event.COMPLETE,this.MainSwfFileLoadOnCompleted);
            this.FUrlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.URLLoaderOnError);
         }
      }
      
      protected function RemoveEventListeners() : void
      {
         if(this.FLoader != null)
         {
            this.FLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.LoadOnCompleted);
            this.FLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.LoadOnError);
            this.FLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.LoadOnProgress);
         }
      }
      
      protected function SetResource(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Dictionary = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         _loc5_ = new Dictionary();
         param1.endian = Endian.LITTLE_ENDIAN;
         param1.uncompress();
         param1.position = 0;
         _loc3_ = param1.readUnsignedShort();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readUnsignedShort();
            _loc6_ = param1.readUTFBytes(_loc4_);
            _loc4_ = param1.readUnsignedShort();
            _loc7_ = param1.readUTFBytes(_loc4_);
            _loc5_[_loc6_] = _loc7_;
            _loc2_++;
         }
         SParametersCore.CoerceResourceConfig(_loc5_);
      }
      
      protected function XMLLoadOnCompleted(param1:Event) : void
      {
         this.XMLRemoveEventListeners();
         this.SetResource(param1.target.data as ByteArray);
         this.LoadMainSwfFile();
      }
      
      protected function MainSwfFileLoadOnCompleted(param1:Event) : void
      {
         var _loc2_:URLLoader = null;
         this.XMLRemoveEventListeners();
         _loc2_ = param1.target as URLLoader;
         this.FMainSwfData = _loc2_.data;
         this.DecryptMainSwfFile();
      }
      
      protected function URLLoaderOnError(param1:IOErrorEvent) : void
      {
         var _loc2_:uint = 0;
         this.XMLRemoveEventListeners();
         _loc2_ = uint(SParametersCore.ClientVersion);
         if(param1 != null && (_loc2_ == 0 || _loc2_ == 2013070522))
         {
            this.FTF_ProgressText.text = ǹ.Ȩ + "\r" + param1.text;
            this.FTF_ProgressText.width = this.FTF_ProgressText.textWidth + 5;
            this.FTF_ProgressText.height = this.FTF_ProgressText.textHeight + 5;
            return;
         }
         this.FTF_ProgressText.text = ǹ.Ȩ;
      }
      
      protected function LoadOnCompleted(param1:Event) : void
      {
         this.RemoveEventListeners();
         if(this.FOnLoadingCompleted != null)
         {
            this.FOnLoadingCompleted(this,this.FLoader.contentLoaderInfo.content);
         }
      }
      
      protected function LoadOnError(param1:IOErrorEvent) : void
      {
         this.FTF_ProgressText.text = ǹ.Ȩ;
         this.RemoveEventListeners();
      }
      
      protected function LoadOnProgress(param1:ProgressEvent) : void
      {
         var _loc2_:Number = NaN;
         _loc2_ = 10 + Math.floor(param1.bytesLoaded * 90 / param1.bytesTotal);
         this.FSP_ProgressBigBar.scaleX = _loc2_ / 100;
         this.FTF_ProgressText.text = Ǿ.Ȳ(ǹ.ȧ,_loc2_);
      }
      
      public function get OnLoadingCompleted() : Function
      {
         return this.FOnLoadingCompleted;
      }
      
      public function set OnLoadingCompleted(param1:Function) : void
      {
         this.FOnLoadingCompleted = param1;
      }
      
      public function Dispose() : void
      {
         this.FLoader.unload();
         this.FLoader = null;
         this.FUrlLoader.close();
         this.FUrlLoader = null;
         this.PlayHappyBrea(false);
         if(this.FMC_Loading.parent != null)
         {
            this.FMC_Loading.parent.removeChild(this.FMC_Loading);
         }
         this.FMC_Effect1 = null;
         this.FMC_Effect2 = null;
         this.FMC_HappyBear = null;
         this.FSP_ProgressBigBar = null;
         this.FTF_ProgressText = null;
         this.FTF_LoadingTips = null;
         this.FMC_Loading = null;
      }
   }
}

