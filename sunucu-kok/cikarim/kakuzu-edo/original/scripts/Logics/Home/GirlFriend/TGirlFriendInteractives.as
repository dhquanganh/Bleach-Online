package Logics.Home.GirlFriend
{
   public class TGirlFriendInteractives
   {
      
      protected var FGirlFriendInteractives:Vector.<TGirlFriendInteractive>;
      
      public function TGirlFriendInteractives()
      {
         super();
         this.FGirlFriendInteractives = new Vector.<TGirlFriendInteractive>();
      }
      
      public function get Count() : int
      {
         return this.FGirlFriendInteractives.length;
      }
      
      public function GetGirlFriendInteractiveByIndex(param1:int) : TGirlFriendInteractive
      {
         return this.FGirlFriendInteractives[param1];
      }
      
      protected function SortMount(param1:TGirlFriendInteractive, param2:TGirlFriendInteractive) : int
      {
         if(param1.InteractiveQuality < param2.InteractiveQuality)
         {
            return -1;
         }
         return 1;
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TGirlFriendInteractive = null;
         _loc1_ = int(this.FGirlFriendInteractives.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FGirlFriendInteractives[_loc2_];
            _loc3_ = null;
            _loc2_++;
         }
         this.FGirlFriendInteractives.length = 0;
      }
      
      public function Add(param1:TGirlFriendInteractive) : void
      {
         this.FGirlFriendInteractives.push(param1);
      }
      
      public function Sort() : void
      {
         this.FGirlFriendInteractives.sort(this.SortMount);
      }
   }
}

