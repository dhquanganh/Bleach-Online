package Logics.HDNewYear
{
   import Logics.Characters.TFriendDigest;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   import Logics.SLogicsCore;
   
   public class TActivityNewYearFlyData extends TActivityOSBase
   {
      
      protected static const Good_Gift_Num:int = 4;
      
      protected static const Charm_Gift_Num:int = 4;
      
      protected var FCurDay:int;
      
      protected var FCharmCount:int;
      
      protected var FGoodCount:int;
      
      protected var FGoodStatusVec:Vector.<int>;
      
      protected var FCharmStatusVec:Vector.<int>;
      
      protected var FActInventories:Vector.<TInventories>;
      
      protected var FNextActInventories:Vector.<TInventories>;
      
      protected var FFriend:TFriendDigest;
      
      public function TActivityNewYearFlyData()
      {
         super();
         this.FGoodStatusVec = new Vector.<int>(Good_Gift_Num);
         this.FCharmStatusVec = new Vector.<int>(Charm_Gift_Num);
         this.FActInventories = new Vector.<TInventories>();
         this.FNextActInventories = new Vector.<TInventories>();
      }
      
      public function get CurDay() : int
      {
         return this.FCurDay;
      }
      
      public function set CurDay(param1:int) : void
      {
         this.FCurDay = param1;
      }
      
      public function get Friend() : TFriendDigest
      {
         return this.FFriend;
      }
      
      public function get GoodStatusVec() : Vector.<int>
      {
         return this.FGoodStatusVec;
      }
      
      public function get CharmStatusVec() : Vector.<int>
      {
         return this.FCharmStatusVec;
      }
      
      public function get CharmCount() : int
      {
         return this.FCharmCount;
      }
      
      public function set CharmCount(param1:int) : void
      {
         this.FCharmCount = param1;
      }
      
      public function get GoodCount() : int
      {
         return this.FGoodCount;
      }
      
      public function set GoodCount(param1:int) : void
      {
         this.FGoodCount = param1;
      }
      
      public function get ActInventories() : Vector.<TInventories>
      {
         return this.FActInventories;
      }
      
      public function get NextActInventories() : Vector.<TInventories>
      {
         return this.FNextActInventories;
      }
      
      public function SetFriend(param1:int, param2:int) : void
      {
         this.FFriend = SLogicsCore.Friends.GetDigestByIdentifier(param1,param2);
      }
   }
}

