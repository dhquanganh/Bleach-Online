package Foundation.Sound
{
   import flash.events.*;
   import flash.media.*;
   import flash.net.*;
   import ghostcat.util.easing.*;
   
   public class TSoundPlayer
   {
      
      protected static const TIME_BufferTime:Number = 100;
      
      protected var FSound:Sound;
      
      protected var FChannel:SoundChannel;
      
      protected var FSoundList:Vector.<Sound>;
      
      protected var FChannelList:Vector.<SoundChannel>;
      
      protected var FVolume:Number;
      
      protected var FCurVolume:Number;
      
      protected var FUrl:String;
      
      protected var FMute:Boolean;
      
      protected var FLoops:int;
      
      protected var FLoopStart:int;
      
      public function TSoundPlayer()
      {
         super();
         this.FSoundList = new Vector.<Sound>();
         this.FChannelList = new Vector.<SoundChannel>();
      }
      
      protected function SoundOnCompleteListener(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Sound = null;
         var _loc4_:SoundChannel = null;
         _loc4_ = param1.target as SoundChannel;
         if(_loc4_)
         {
            _loc4_.removeEventListener(Event.SOUND_COMPLETE,this.SoundOnCompleteListener);
         }
         _loc2_ = this.FChannelList.indexOf(_loc4_);
         if(_loc2_ >= 0)
         {
            this.FChannelList.splice(_loc2_,1);
            _loc3_ = this.FSoundList[_loc2_];
         }
         if(_loc3_)
         {
            _loc3_.removeEventListener(IOErrorEvent.IO_ERROR,this.SoundOnIOErrorListener);
            this.FSoundList.splice(_loc2_,1);
         }
      }
      
      protected function SoundOnIOErrorListener(param1:IOErrorEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Sound = null;
         var _loc4_:SoundChannel = null;
         _loc3_ = param1.target as Sound;
         if(_loc3_)
         {
            _loc3_.removeEventListener(IOErrorEvent.IO_ERROR,this.SoundOnIOErrorListener);
         }
         _loc2_ = this.FSoundList.indexOf(_loc3_);
         if(_loc2_ >= 0)
         {
            this.FSoundList.splice(_loc2_,1);
            _loc4_ = this.FChannelList[_loc2_];
         }
         if(_loc4_)
         {
            _loc4_.removeEventListener(Event.SOUND_COMPLETE,this.SoundOnCompleteListener);
            this.FChannelList.splice(_loc2_,1);
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
               this.Stop();
            }
            return;
         }
      }
      
      public function SetVolume(param1:Number, param2:Number = 500) : void
      {
         this.FVolume = param1;
         TweenUtil.removeTween(this,false);
         TweenUtil.to(this,param2,{"CurVolume":param1});
      }
      
      public function PlaySound(param1:String, param2:int = 1, param3:Number = 0.7, param4:int = 0) : void
      {
         this.FLoops = param2;
         this.FVolume = param3;
         this.FLoopStart = param4;
         this.FUrl = param1;
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
            this.FCurVolume = 0.5;
            TweenUtil.removeTween(this,false);
            TweenUtil.to(this,100,{"CurVolume":this.FVolume});
            this.FSoundList.push(this.FSound);
            this.FChannelList.push(this.FChannel);
         }
      }
      
      public function Stop(param1:int = 50) : void
      {
         var Index:int = 0;
         var Count:int = 0;
         var SoundInstance:Sound = null;
         var ChannelInstance:SoundChannel = null;
         var Duration:int = param1;
         Count = this.FSoundList.length - 1;
         Index = Count;
         while(Index >= 0)
         {
            SoundInstance = this.FSoundList[Index];
            if(SoundInstance)
            {
               try
               {
                  SoundInstance.close();
               }
               catch(error:Error)
               {
               }
            }
            ChannelInstance = this.FChannelList[Index];
            if(ChannelInstance)
            {
               ChannelInstance.removeEventListener(Event.SOUND_COMPLETE,this.SoundOnCompleteListener);
               TweenUtil.removeTween(ChannelInstance,false);
               TweenUtil.to(ChannelInstance,Duration,{"onComplete":ChannelInstance.stop});
            }
            Index--;
         }
      }
   }
}

