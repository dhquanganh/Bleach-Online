package Logics.ChatOptions
{
   import Resources.Constants.CONST_CHAT;
   
   public class TChatOptions
   {
      
      protected static const MODE_None:uint = CONST_CHAT.MODE_None;
      
      protected static const MODE_Hidden:uint = CONST_CHAT.MODE_Hidden;
      
      protected var FChatStatus:uint;
      
      public function TChatOptions()
      {
         super();
         this.ConstructChatOptions();
      }
      
      protected function ConstructChatOptions() : void
      {
         this.ChatOptionsReset();
      }
      
      public function get ChatStatus() : uint
      {
         return this.FChatStatus;
      }
      
      public function set ChatStatus(param1:uint) : void
      {
         this.FChatStatus = param1;
      }
      
      public function ChatOptionsReset() : void
      {
         this.FChatStatus = MODE_None;
      }
   }
}

