package
{
   import com.tencent.morefun.framework.log.log;
   import com.tencent.morefun.naruto.storage.Cookie;
   import flash.display.Stage;
   import flash.events.SampleDataEvent;
   import flash.events.ThrottleEvent;
   import flash.events.ThrottleType;
   import flash.external.ExternalInterface;
   import flash.media.Sound;
   import sound.commands.ChangeAudioStatusCommand;
   import sound.commands.ChangeMusicStatusCommand;
   
   public class CheckThrottle
   {
      
      private var _stage:Stage;
      
      private var _sound:Sound;
      
      private var _index:int;
      
      public function CheckThrottle(param1:Stage)
      {
         super();
         this._stage = param1;
         this.init();
         param1.stageWidth;
      }
      
      private function init() : void
      {
         this._stage.addEventListener(ThrottleEvent.THROTTLE,this.throttleHandler);
      }
      
      private function throttleHandler(param1:ThrottleEvent) : void
      {
         var _loc2_:String = null;
         if(param1.state == ThrottleType.THROTTLE)
         {
            this.activeSound();
         }
         else if(param1.state == ThrottleType.RESUME)
         {
            this.deactiveSound();
         }
         else if(param1.state == ThrottleType.PAUSE)
         {
            this.deactiveSound();
         }
         if(this.checkChrome())
         {
            try
            {
               _loc2_ = "var swfObj = jQuery(\'#resizeTarget\'); var tmpWidth = swfObj.width(); swfObj.width(tmpWidth-1); swfObj.width(tmpWidth); console.log(\'tmpWidth\'+tmpWidth);";
               if(ExternalInterface.available)
               {
                  ExternalInterface.call("eval",_loc2_);
                  log("entry","ThrottleType.RESUME state: " + param1.state + "index: " + this._index);
                  ++this._index;
               }
            }
            catch(e:*)
            {
            }
         }
      }
      
      private function checkChrome() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:String = null;
         if(ExternalInterface.available)
         {
            try
            {
               _loc2_ = ExternalInterface.call("eval","navigator.userAgent");
               _loc2_ = _loc2_.toLowerCase();
               if(_loc2_.indexOf("chrome") != -1)
               {
                  _loc1_ = true;
               }
            }
            catch(e:*)
            {
            }
         }
         return _loc1_;
      }
      
      private function activeSound() : void
      {
         this._sound = this._sound || new Sound();
         this._sound.addEventListener(SampleDataEvent.SAMPLE_DATA,this.sampleDataHandler);
         this._sound.play();
         new ChangeAudioStatusCommand(false).call();
         new ChangeMusicStatusCommand(false).call();
      }
      
      private function deactiveSound() : void
      {
         if(this._sound)
         {
            this._sound.removeEventListener(SampleDataEvent.SAMPLE_DATA,this.sampleDataHandler);
         }
         var _loc1_:Boolean = Boolean(Cookie.getValue("AUDIO_ENABLED"));
         new ChangeAudioStatusCommand(_loc1_).call();
         var _loc2_:Boolean = Boolean(Cookie.getValue("MUSIC_ENABLED"));
         new ChangeMusicStatusCommand(_loc2_).call();
      }
      
      private function sampleDataHandler(param1:SampleDataEvent) : void
      {
         param1.data.position = param1.data.length = 4096 * 4;
      }
   }
}

