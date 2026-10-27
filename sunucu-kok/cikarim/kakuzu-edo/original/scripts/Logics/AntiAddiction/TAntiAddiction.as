package Logics.AntiAddiction
{
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TAntiAddiction
   {
      
      protected var FData:Object;
      
      protected var FState:int;
      
      public function TAntiAddiction()
      {
         super();
      }
      
      LogicsSpace function Coerce(param1:Object) : void
      {
         if(param1 != null)
         {
            this.FData = param1;
         }
      }
      
      public function get Data() : Object
      {
         return this.FData;
      }
      
      public function get Identifier0() : int
      {
         return this.FData.Identifier0;
      }
      
      public function set Identifier0(param1:int) : void
      {
         this.FData.Identifier0 = param1;
      }
      
      public function get Identifier1() : int
      {
         return this.FData.Identifier1;
      }
      
      public function set Identifier1(param1:int) : void
      {
         this.FData.Identifier1 = param1;
      }
      
      public function get LastOnlineDate() : int
      {
         return this.FData.LastOnlineDate;
      }
      
      public function set LastOnlineDate(param1:int) : void
      {
         this.FData.LastOnlineDate = param1;
      }
      
      public function get OnlineTime() : int
      {
         return this.FData.OnlineTime;
      }
      
      public function set OnlineTime(param1:int) : void
      {
         this.FData.OnlineTime = param1;
      }
      
      public function get SoundEffectMute() : Boolean
      {
         return this.FData.SoundEffectMute;
      }
      
      public function set SoundEffectMute(param1:Boolean) : void
      {
         this.FData.SoundEffectMute = param1;
      }
      
      public function get SoundMute() : Boolean
      {
         return this.FData.SoundMute;
      }
      
      public function set SoundMute(param1:Boolean) : void
      {
         this.FData.SoundMute = param1;
      }
      
      public function get SwitchDisplay() : Boolean
      {
         return this.FData.SwitchDisplay;
      }
      
      public function set SwitchDisplay(param1:Boolean) : void
      {
         this.FData.SwitchDisplay = param1;
      }
      
      public function get State() : int
      {
         return this.FState;
      }
      
      public function set State(param1:int) : void
      {
         this.FState = param1;
      }
   }
}

