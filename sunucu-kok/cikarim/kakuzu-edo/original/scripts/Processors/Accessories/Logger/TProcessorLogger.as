package Processors.Accessories.Logger
{
   import Foundation.Crypto.TAES;
   import Foundation.UI.TUIComponent;
   import Logging.Digests.TPoolDigest;
   import Logging.Publisher.TMultiPublisher;
   import Logging.Publisher.TTextFieldPublisher;
   import Logging.Requests.TPoolRequest;
   import Logging.SLogger;
   import Logging.TLogger;
   import Logging.TState;
   import Logics.Agent.SParametersCore;
   import Processors.TProcessor;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_KEYCODE;
   import flash.desktop.Clipboard;
   import flash.desktop.ClipboardFormats;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   
   public class TProcessorLogger extends TProcessor
   {
      
      protected static const KEY_SEMICOLON:uint = CONST_KEYCODE.KEY_SEMICOLON;
      
      protected static const KEY_E:uint = CONST_KEYCODE.KEY_E;
      
      protected static const KEY_R:uint = CONST_KEYCODE.KEY_R;
      
      protected static const KEY_C:uint = CONST_KEYCODE.KEY_C;
      
      protected static const KEY_D:uint = CONST_KEYCODE.KEY_D;
      
      protected static const KEY_ENTER:uint = CONST_KEYCODE.KEY_ENTER;
      
      private static const SIZE_Width:uint = CONST_COMMON.STAGE_Width;
      
      private static const SIZE_Height:uint = CONST_COMMON.STAGE_Height;
      
      private static const CAPACITY_MAXCHARS:uint = 5000000;
      
      private static const KEY_CHEATS:String = "bleach888";
      
      protected var FPoolRequest:TPoolRequest;
      
      protected var FPoolDigest:TPoolDigest;
      
      protected var FState:TState;
      
      protected var FBackground:Sprite;
      
      protected var FTFConsole:TextField;
      
      protected var FTFNetwork:TextField;
      
      protected var FTFConsolePublisher:TTextFieldPublisher;
      
      protected var FTFNetworkPublisher:TTextFieldPublisher;
      
      protected var FTFState:TextField;
      
      protected var FClientVersion:String;
      
      protected var FIsCheatsEnabled:Boolean;
      
      protected var FIsDecrypted:Boolean;
      
      protected var FCheats:String;
      
      protected var FIsInitialization:Boolean;
      
      public function TProcessorLogger(param1:TUIComponent)
      {
         super(param1);
         this.FIsInitialization = false;
         this.FPoolRequest = new TPoolRequest();
         SLogger.PoolRequest = this.FPoolRequest;
         this.FPoolDigest = new TPoolDigest();
         SLogger.PoolDigest = this.FPoolDigest;
         this.FState = new TState();
         this.ConstructBackground();
         this.FTFConsole = TTextFieldPublisher.GetLoggerField(SIZE_Width - 300,SIZE_Height - 40 - 420);
         this.addChild(this.FTFConsole);
         this.FTFNetwork = TTextFieldPublisher.GetLoggerField(330,SIZE_Height - 40 - 420);
         this.addChild(this.FTFNetwork);
         this.FTFNetwork.x = SIZE_Width - 330;
         this.FTFConsolePublisher = new TTextFieldPublisher(this.FTFConsole);
         this.FTFConsolePublisher.OutputType = TLogger.TYPE_Normal;
         this.FTFNetworkPublisher = new TTextFieldPublisher(this.FTFNetwork);
         this.FTFNetworkPublisher.OutputType = TLogger.TYPE_Network;
         SLogger.AddPublisher(new TMultiPublisher([this.FTFConsolePublisher,this.FTFNetworkPublisher]));
         this.FTFState = TTextFieldPublisher.GetLoggerField(SIZE_Width,30);
         this.FTFState.textColor = 4294967040;
         this.addChild(this.FTFState);
         this.FTFState.y = this.FTFConsole.height - 9;
         SLogger.OnState = this.ProcessorOnState;
         FUICore.UIStage.addEventListener(KeyboardEvent.KEY_DOWN,this.UIStageOnKeyDown);
         SLogger.Enabled = false;
         this.FClientVersion = SParametersCore.ClientVersion.toString().toLowerCase();
         this.FCheats = "";
         this.FIsCheatsEnabled = false;
         this.FIsDecrypted = false;
         this.mouseEnabled = false;
         this.FIsInitialization = true;
      }
      
      protected function ConstructBackground() : void
      {
         var _loc1_:Graphics = null;
         this.FBackground = new Sprite();
         _loc1_ = this.FBackground.graphics;
         _loc1_.beginFill(4278190080,0.7);
         _loc1_.drawRect(0,0,SIZE_Width,SIZE_Height - 450);
         _loc1_.endFill();
         this.FBackground.mouseEnabled = false;
         this.FBackground.mouseChildren = false;
         this.addChild(this.FBackground);
      }
      
      override protected function LogicsPerform() : void
      {
         this.FPoolRequest.Update();
         this.FPoolDigest.Update();
         SLogger.Update();
      }
      
      protected function CheckCheats() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Boolean = false;
         if(this.FCheats.length == 0)
         {
            return;
         }
         _loc5_ = KEY_CHEATS + this.FClientVersion;
         if(this.FCheats.length != _loc5_.length)
         {
            this.FCheats = "";
            return;
         }
         _loc7_ = false;
         _loc6_ = this.FCheats.toLowerCase();
         _loc2_ = KEY_CHEATS.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = _loc6_.charCodeAt(_loc1_);
            _loc4_ = _loc5_.charCodeAt(_loc1_);
            if(_loc3_ != _loc4_)
            {
               _loc7_ = true;
               break;
            }
            _loc1_++;
         }
         if(!_loc7_)
         {
            this.FIsDecrypted = true;
            this.visible = true;
         }
         this.FCheats = "";
      }
      
      protected function ProcessorCopyDebugInfo() : void
      {
         var _loc1_:String = null;
         _loc1_ = "********************【Console】***********************\r" + this.FTFConsolePublisher.ContextCached + "\r******************【Network】***********************\r" + this.FTFNetworkPublisher.ContextCached + "\r******************【State】*************************\r" + this.FTFState.text;
         _loc1_ = TAES.Encrypt(_loc1_,KEY_CHEATS,TAES.BIT_KEY_256);
         Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT,_loc1_);
      }
      
      protected function ProcessorOnState(param1:Object, param2:TState) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:String = null;
         _loc3_ = param2.Flush(this.FState);
         if(_loc3_)
         {
            _loc4_ = Number(this.FState.BytesLoaded / 1048576).toFixed(2);
            this.FTFState.text = "Loading:" + this.FState.Loading + "\t\tSuccess:" + this.FState.Success + "\t\tTimeOut:" + this.FState.TimeOut + "\t\tBlock:" + this.FState.Block + "\t\tRetry:" + this.FState.Retry + "\t\tFail:" + this.FState.Fail + "\t\tBytesLoaded:" + _loc4_ + "MB\t\tOnlinePlayer:" + this.FState.OnlinePlayer + "                                                                             Transmit:" + param2.Transmit + "\t\t\t\tReceived:" + this.FState.Received;
         }
      }
      
      protected function UIStageOnKeyDown(param1:KeyboardEvent) : void
      {
         var _loc2_:uint = 0;
         if(param1.ctrlKey && param1.altKey && param1.keyCode == KEY_SEMICOLON)
         {
            if(!this.FIsDecrypted)
            {
               this.FIsCheatsEnabled = true;
            }
            else
            {
               this.Visible = !this.Visible;
            }
            return;
         }
         if(param1.ctrlKey && param1.altKey && param1.keyCode == KEY_E)
         {
            if(this.FIsInitialization)
            {
               SLogger.Enabled = !SLogger.Enabled;
            }
            return;
         }
         if(param1.ctrlKey && param1.altKey && param1.keyCode == KEY_R)
         {
            this.FTFConsolePublisher.AutoScrollV = !this.FTFConsolePublisher.AutoScrollV;
            this.FTFConsole.mouseEnabled = !this.FTFConsolePublisher.AutoScrollV;
            this.FTFConsole.selectable = !this.FTFConsolePublisher.AutoScrollV;
            this.FTFNetworkPublisher.AutoScrollV = !this.FTFNetworkPublisher.AutoScrollV;
            this.FTFNetwork.mouseEnabled = !this.FTFNetworkPublisher.AutoScrollV;
            this.FTFNetwork.selectable = !this.FTFNetworkPublisher.AutoScrollV;
            return;
         }
         if(param1.ctrlKey && param1.altKey && param1.keyCode == KEY_C)
         {
            this.ProcessorCopyDebugInfo();
            return;
         }
         if(param1.ctrlKey && param1.altKey && param1.keyCode == KEY_D)
         {
            SLogger.IsShowDetail = !SLogger.IsShowDetail;
            return;
         }
         if(param1.ctrlKey && param1.altKey && param1.keyCode == KEY_ENTER)
         {
            if(this.FIsDecrypted)
            {
               return;
            }
            if(this.FIsCheatsEnabled)
            {
               this.FIsCheatsEnabled = false;
               this.CheckCheats();
            }
         }
         if(this.FIsCheatsEnabled)
         {
            _loc2_ = param1.keyCode;
            if(_loc2_ >= 48 && _loc2_ <= 57 || _loc2_ >= 65 && _loc2_ <= 90 || _loc2_ >= 97 && _loc2_ <= 122)
            {
               this.FCheats += String.fromCharCode(param1.keyCode);
            }
         }
      }
      
      public function set IsEnabled(param1:Boolean) : void
      {
         SLogger.Enabled = param1;
      }
      
      public function CopyDebugInfo() : void
      {
         this.ProcessorCopyDebugInfo();
      }
   }
}

