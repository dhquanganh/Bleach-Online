package Logics.Characters
{
   import Resources.Constants.CONST_FRIEND;
   
   public class TFriendDigest extends TDigest
   {
      
      public static const TYPE_White:uint = CONST_FRIEND.TYPE_White;
      
      public static const TYPE_Black:uint = CONST_FRIEND.TYPE_Black;
      
      public static const TYPE_Recommend:uint = CONST_FRIEND.TYPE_Recommend;
      
      protected var FCountry:uint;
      
      protected var FHomeLevel:uint;
      
      protected var FIsOnline:Boolean;
      
      protected var FTag:uint;
      
      protected var FSendGoodOrNot:Boolean;
      
      protected var FIfYearYellowDiamond:Boolean;
      
      protected var FYellowDiamondLevel:int;
      
      public function TFriendDigest(param1:uint, param2:uint)
      {
         super(param1,param2);
      }
      
      public function get Country() : uint
      {
         return this.FCountry;
      }
      
      public function set Country(param1:uint) : void
      {
         this.FCountry = param1;
      }
      
      public function get HomeLevel() : uint
      {
         return this.FHomeLevel;
      }
      
      public function set HomeLevel(param1:uint) : void
      {
         this.FHomeLevel = param1;
      }
      
      public function get IsOnline() : Boolean
      {
         return this.FIsOnline;
      }
      
      public function set IsOnline(param1:Boolean) : void
      {
         this.FIsOnline = param1;
      }
      
      public function get Tag() : uint
      {
         return this.FTag;
      }
      
      public function set Tag(param1:uint) : void
      {
         this.FTag = param1;
      }
      
      public function get SendGoodOrNot() : Boolean
      {
         return this.FSendGoodOrNot;
      }
      
      public function set SendGoodOrNot(param1:Boolean) : void
      {
         this.FSendGoodOrNot = param1;
      }
      
      public function get IfYearYellowDiamond() : Boolean
      {
         return this.FIfYearYellowDiamond;
      }
      
      public function set IfYearYellowDiamond(param1:Boolean) : void
      {
         this.FIfYearYellowDiamond = param1;
      }
      
      public function get YellowDiamondLevel() : int
      {
         return this.FYellowDiamondLevel;
      }
      
      public function set YellowDiamondLevel(param1:int) : void
      {
         this.FYellowDiamondLevel = param1;
      }
      
      override public function Reset() : void
      {
         super.Reset();
         this.FCountry = 0;
         this.FIsOnline = false;
         this.FTag = 0;
         this.FSendGoodOrNot = false;
      }
   }
}

