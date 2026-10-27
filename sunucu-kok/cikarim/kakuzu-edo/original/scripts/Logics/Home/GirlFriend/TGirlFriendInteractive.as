package Logics.Home.GirlFriend
{
   public class TGirlFriendInteractive
   {
      
      protected var FInteractiveScore:uint;
      
      protected var FInteractiveTitle:String;
      
      protected var FInteractiveQuality:uint;
      
      protected var FInteractiveAdditional:String;
      
      protected var FInteractiveReward:String;
      
      public function TGirlFriendInteractive()
      {
         super();
         this.FInteractiveTitle = "";
         this.FInteractiveAdditional = "";
         this.FInteractiveReward = "";
      }
      
      public function get InteractiveScore() : uint
      {
         return this.FInteractiveScore;
      }
      
      public function set InteractiveScore(param1:uint) : void
      {
         this.FInteractiveScore = param1;
      }
      
      public function get InteractiveTitle() : String
      {
         return this.FInteractiveTitle;
      }
      
      public function set InteractiveTitle(param1:String) : void
      {
         this.FInteractiveTitle = param1;
      }
      
      public function get InteractiveQuality() : uint
      {
         return this.FInteractiveQuality;
      }
      
      public function set InteractiveQuality(param1:uint) : void
      {
         this.FInteractiveQuality = param1;
      }
      
      public function get InteractiveAdditional() : String
      {
         return this.FInteractiveAdditional;
      }
      
      public function set InteractiveAdditional(param1:String) : void
      {
         this.FInteractiveAdditional = param1;
      }
      
      public function get InteractiveReward() : String
      {
         return this.FInteractiveReward;
      }
      
      public function set InteractiveReward(param1:String) : void
      {
         this.FInteractiveReward = param1;
      }
   }
}

