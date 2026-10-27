package Foundation.Sound
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundLoaderContext;
   import flash.media.SoundTransform;
   import flash.net.URLRequest;
   import ghostcat.util.easing.TweenUtil;
   
   public class TMusicPlayer
   {
      
      protected static const TIME_BufferTime:Number = 3000;
      
      protected var FSound:Sound;
      
      protected var FChannel:SoundChannel;
      
      protected var FVolume:Number;
      
      protected var FCurVolume:Number;
      
      protected var FUrl:String;
      
      protected var FMute:Boolean;
      
      protected var FLoops:int;
      
      protected var FLoopStart:int;
      
      public function TMusicPlayer()
      {
         super();
      }
      
      protected function SoundOnCompleteListener(param1:Event) : void
      {
         if(this.FChannel)
         {
            this.FChannel.removeEventListener(Event.SOUND_COMPLETE,this.SoundOnCompleteListener);
            this.FChannel = this.FSound.play(this.FLoopStart,this.FLoops,this.FChannel.soundTransform);
            this.FChannel.addEventListener(Event.SOUND_COMPLETE,this.SoundOnCompleteListener);
         }
      }
      
      protected function SoundOnIOErrorListener(param1:IOErrorEvent) : void
      {
         if(this.FChannel)
         {
            this.FChannel.removeEventListener(Event.SOUND_COMPLETE,this.SoundOnCompleteListener);
         }
         if(this.FSound)
         {
            this.FSound.removeEventListener(IOErrorEvent.IO_ERROR,this.SoundOnIOErrorListener);
         }
      }
      
      public function get Volume() : Number
      {
         return this.FVolume;
      }
      
      public function set Volume(param1:Number) : void
      {
         this.FVolume = param1;
         this.SetVolume(param1);
      }
      
      public function get CurVolume() : Number
      {
         return this.FCurVolume;
      }
      
      public function set CurVolume(param1:Number) : void
      {
         this.FCurVolume = param1;
         if(this.FChannel)
         {
            this.FChannel.soundTransform = new SoundTransform(param1);
         }
      }
      
      public function get Mute() : Boolean
      {
         return this.FMute;
      }
      
      public function set Mute(param1:Boolean) : void
      {
         if(this.FMute != param1)
         {
            this.FMute = param1;
            if(param1)
            {
               this.SetVolume(0);
            }
            else
            {
               this.SetVolume(1);
               if(this.FChannel == null)
               {
                  this.Start();
               }
            }
            return;
         }
      }
      
      public function SetVolume(param1:Number, param2:Number = 1000) : void
      {
         this.FVolume = param1;
         TweenUtil.removeTween(this,false);
         TweenUtil.to(this,param2,{"CurVolume":param1});
      }
      
      public function PlayBgSound(param1:String, param2:int = 0, param3:Number = 0.5, param4:int = 0) : void
      {
         if(this.FSound != null && this.FUrl == param1)
         {
            this.SetVolume(param3);
            return;
         }
         this.FLoops = param2;
         this.FVolume = param3;
         this.FLoopStart = param4;
         this.FUrl = param1;
         this.Stop();
         if(!this.FMute)
         {
            this.Start();
         }
      }
      
      public function Start() : void
      {
         if(this.FUrl)
         {
            this.FSound = new Sound(new URLRequest(this.FUrl),new SoundLoaderContext(TIME_BufferTime,true));
            this.FChannel = this.FSound.play(0,this.FLoops);
            if(!this.FChannel)
            {
               return;
            }
            this.FChannel.addEventListener(Event.SOUND_COMPLETE,this.SoundOnCompleteListener);
            this.FSound.addEventListener(IOErrorEvent.IO_ERROR,this.SoundOnIOErrorListener);
            this.FCurVolume = 0;
            TweenUtil.removeTween(this,false);
            TweenUtil.to(this,2000,{"CurVolume":this.FVolume});
         }
      }
      
      public function Stop(param1:int = 1000) : void
      {
         var Duration:int = param1;
         if(this.FSound != null)
         {
            try
            {
               this.FSound.close();
            }
            catch(error:Error)
            {
            }
            this.FSound = null;
         }
         if(this.FChannel)
         {
            this.FChannel.removeEventListener(Event.SOUND_COMPLETE,this.SoundOnCompleteListener);
            TweenUtil.removeTween(this.FChannel,false);
            TweenUtil.to(this.FChannel,Duration,{
               "volume":0,
               "onComplete":this.FChannel.stop
            });
            this.FChannel = null;
         }
      }
   }
}

