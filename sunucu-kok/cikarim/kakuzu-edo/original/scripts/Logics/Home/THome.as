package Logics.Home
{
   import Foundation.Common.TEntity64;
   import Logics.Home.GirlFriend.TGirlFriend;
   import Logics.Home.GirlFriend.TGirlFriendInteractives;
   import Logics.Home.HomeSoul.THomeSoul;
   import Logics.Home.LuckyCat.TLuckyCat;
   import Logics.InteractionLog.TInteractionLogs;
   import Logics.Inventories.TAppliance;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class THome extends TEntity64
   {
      
      protected var FLevel:uint;
      
      protected var FMyMonsterBeBeatenCount:uint;
      
      protected var FMyMonsterCount:uint;
      
      protected var FFriendMonsterCount:uint;
      
      protected var FLuckyCatCount:uint;
      
      protected var FLuckyCatCD:uint;
      
      protected var FLuckyCatCDLimit:Boolean;
      
      protected var FChangeShapeGirlID:uint;
      
      protected var FInteractiveScore:uint;
      
      protected var FName:String;
      
      protected var FQuality:uint;
      
      protected var FViewImageID:uint;
      
      protected var FMainImgID:uint;
      
      protected var FFloatingIslandPointLeftID:uint;
      
      protected var FFloatingIslandPointRightID:uint;
      
      protected var FInteractiveTitle:String;
      
      protected var FInteractiveQuality:uint;
      
      protected var FAppliance:TAppliance;
      
      protected var FDesc:String;
      
      protected var FMaxGirlFriendLevel:uint;
      
      protected var FMaxMyMonsterCount:uint;
      
      protected var FMaxFriendMonsterCount:uint;
      
      protected var FQualityMonster:uint;
      
      protected var FMaxLuckyCatCount:uint;
      
      protected var FMaxGambleCount:uint;
      
      protected var FChangeShapeGirlImageID:uint;
      
      protected var FMaxMyGirlfriendInteractive:uint;
      
      protected var FMaxGirlfriendInteractiveCount:uint;
      
      protected var FMaxGirlfriendBeInteractiveCount:uint;
      
      protected var FMaxMyMonsterBeBeatenCount:uint;
      
      protected var FGirlFriend:TGirlFriend;
      
      protected var FGirlFriendInteractives:TGirlFriendInteractives;
      
      protected var FLuckyCat:TLuckyCat;
      
      protected var FHomeSoul:THomeSoul;
      
      protected var FInteractionLogMonster:TInteractionLogs;
      
      protected var FInteractionLogGirlFriend:TInteractionLogs;
      
      public function THome(param1:uint = 0, param2:uint = 0)
      {
         super(param1,param2);
         this.FName = "";
         this.FDesc = "";
         this.FInteractiveTitle = "";
         this.FChangeShapeGirlID = 1;
         this.FGirlFriend = new TGirlFriend();
         this.FGirlFriendInteractives = new TGirlFriendInteractives();
         this.FLuckyCat = new TLuckyCat();
         this.FHomeSoul = new THomeSoul();
         this.FInteractionLogMonster = new TInteractionLogs();
         this.FInteractionLogGirlFriend = new TInteractionLogs();
      }
      
      LogicsSpace function Coerce(param1:uint, param2:uint) : void
      {
         FIdentifier0 = param1;
         FIdentifier1 = param2;
      }
      
      public function get Level() : uint
      {
         return this.FLevel;
      }
      
      public function set Level(param1:uint) : void
      {
         this.FLevel = param1;
      }
      
      public function get MyMonsterBeBeatenCount() : uint
      {
         return this.FMyMonsterBeBeatenCount;
      }
      
      public function set MyMonsterBeBeatenCount(param1:uint) : void
      {
         this.FMyMonsterBeBeatenCount = param1;
      }
      
      public function get MyMonsterCount() : uint
      {
         return this.FMyMonsterCount;
      }
      
      public function set MyMonsterCount(param1:uint) : void
      {
         this.FMyMonsterCount = param1;
      }
      
      public function get FriendMonsterCount() : uint
      {
         return this.FFriendMonsterCount;
      }
      
      public function set FriendMonsterCount(param1:uint) : void
      {
         this.FFriendMonsterCount = param1;
      }
      
      public function get LuckyCatCount() : uint
      {
         return this.FLuckyCatCount;
      }
      
      public function set LuckyCatCount(param1:uint) : void
      {
         this.FLuckyCatCount = param1;
      }
      
      public function get LuckyCatCD() : uint
      {
         return this.FLuckyCatCD;
      }
      
      public function set LuckyCatCD(param1:uint) : void
      {
         this.FLuckyCatCD = param1;
      }
      
      public function get LuckyCatCDLimit() : Boolean
      {
         return this.FLuckyCatCDLimit;
      }
      
      public function set LuckyCatCDLimit(param1:Boolean) : void
      {
         this.FLuckyCatCDLimit = param1;
      }
      
      public function get ChangeShapeGirlID() : uint
      {
         return this.FChangeShapeGirlID;
      }
      
      public function set ChangeShapeGirlID(param1:uint) : void
      {
         this.FChangeShapeGirlID = param1;
      }
      
      public function get InteractiveScore() : uint
      {
         return this.FInteractiveScore;
      }
      
      public function set InteractiveScore(param1:uint) : void
      {
         this.FInteractiveScore = param1;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get Quality() : uint
      {
         return this.FQuality;
      }
      
      public function set Quality(param1:uint) : void
      {
         this.FQuality = param1;
      }
      
      public function get ViewImageID() : uint
      {
         return this.FViewImageID;
      }
      
      public function set ViewImageID(param1:uint) : void
      {
         this.FViewImageID = param1;
      }
      
      public function get MainImgID() : uint
      {
         return this.FMainImgID;
      }
      
      public function set MainImgID(param1:uint) : void
      {
         this.FMainImgID = param1;
      }
      
      public function get FloatingIslandPointLeftID() : uint
      {
         return this.FFloatingIslandPointLeftID;
      }
      
      public function set FloatingIslandPointLeftID(param1:uint) : void
      {
         this.FFloatingIslandPointLeftID = param1;
      }
      
      public function get FloatingIslandPointRightID() : uint
      {
         return this.FFloatingIslandPointRightID;
      }
      
      public function set FloatingIslandPointRightID(param1:uint) : void
      {
         this.FFloatingIslandPointRightID = param1;
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
      
      public function get Appliance() : TAppliance
      {
         return this.FAppliance;
      }
      
      public function set Appliance(param1:TAppliance) : void
      {
         if(this.FAppliance != null && this.FAppliance != param1)
         {
            this.FAppliance.StubReferences.Dereference(this);
            this.FAppliance = null;
         }
         if(param1 != null)
         {
            this.FAppliance = param1;
            this.FAppliance.StubReferences.Reference(this);
         }
      }
      
      public function get Desc() : String
      {
         return this.FDesc;
      }
      
      public function set Desc(param1:String) : void
      {
         this.FDesc = param1;
      }
      
      public function get MaxGirlFriendLevel() : uint
      {
         return this.FMaxGirlFriendLevel;
      }
      
      public function set MaxGirlFriendLevel(param1:uint) : void
      {
         this.FMaxGirlFriendLevel = param1;
      }
      
      public function get MaxMyMonsterCount() : uint
      {
         return this.FMaxMyMonsterCount;
      }
      
      public function set MaxMyMonsterCount(param1:uint) : void
      {
         this.FMaxMyMonsterCount = param1;
      }
      
      public function get MaxFriendMonsterCount() : uint
      {
         return this.FMaxFriendMonsterCount;
      }
      
      public function set MaxFriendMonsterCount(param1:uint) : void
      {
         this.FMaxFriendMonsterCount = param1;
      }
      
      public function get QualityMonster() : uint
      {
         return this.FQualityMonster;
      }
      
      public function set QualityMonster(param1:uint) : void
      {
         this.FQualityMonster = param1;
      }
      
      public function get MaxLuckyCatCount() : uint
      {
         return this.FMaxLuckyCatCount;
      }
      
      public function set MaxLuckyCatCount(param1:uint) : void
      {
         this.FMaxLuckyCatCount = param1;
      }
      
      public function get MaxGambleCount() : uint
      {
         return this.FMaxGambleCount;
      }
      
      public function set MaxGambleCount(param1:uint) : void
      {
         this.FMaxGambleCount = param1;
      }
      
      public function get ChangeShapeGirlImageID() : uint
      {
         return this.FChangeShapeGirlImageID;
      }
      
      public function set ChangeShapeGirlImageID(param1:uint) : void
      {
         this.FChangeShapeGirlImageID = param1;
      }
      
      public function get MaxMyGirlfriendInteractive() : uint
      {
         return this.FMaxMyGirlfriendInteractive;
      }
      
      public function set MaxMyGirlfriendInteractive(param1:uint) : void
      {
         this.FMaxMyGirlfriendInteractive = param1;
      }
      
      public function get MaxGirlfriendInteractiveCount() : uint
      {
         return this.FMaxGirlfriendInteractiveCount;
      }
      
      public function set MaxGirlfriendInteractiveCount(param1:uint) : void
      {
         this.FMaxGirlfriendInteractiveCount = param1;
      }
      
      public function get MaxGirlfriendBeInteractiveCount() : uint
      {
         return this.FMaxGirlfriendBeInteractiveCount;
      }
      
      public function set MaxGirlfriendBeInteractiveCount(param1:uint) : void
      {
         this.FMaxGirlfriendBeInteractiveCount = param1;
      }
      
      public function get GirlFriend() : TGirlFriend
      {
         return this.FGirlFriend;
      }
      
      public function get GirlFriendInteractives() : TGirlFriendInteractives
      {
         return this.FGirlFriendInteractives;
      }
      
      public function get LuckyCat() : TLuckyCat
      {
         return this.FLuckyCat;
      }
      
      public function get HomeSoul() : THomeSoul
      {
         return this.FHomeSoul;
      }
      
      public function get InteractionLogMonster() : TInteractionLogs
      {
         return this.FInteractionLogMonster;
      }
      
      public function get InteractionLogGirlFriend() : TInteractionLogs
      {
         return this.FInteractionLogGirlFriend;
      }
      
      public function get MaxMyMonsterBeBeatenCount() : uint
      {
         return this.FMaxMyMonsterBeBeatenCount;
      }
      
      public function set MaxMyMonsterBeBeatenCount(param1:uint) : void
      {
         this.FMaxMyMonsterBeBeatenCount = param1;
      }
      
      public function Reset() : void
      {
         FIdentifier0 = 0;
         FIdentifier1 = 0;
         this.FLevel = 1;
         this.FMyMonsterBeBeatenCount = 0;
         this.FMyMonsterCount = 0;
         this.FFriendMonsterCount = 0;
         this.FLuckyCatCount = 0;
         this.FLuckyCatCD = 0;
         this.FChangeShapeGirlID = 1;
         this.FInteractiveScore = 0;
         this.FName = "";
         this.FQuality = 0;
         this.FViewImageID = 0;
         this.FInteractiveTitle = "";
         this.FDesc = "";
         this.FMaxGirlFriendLevel = 0;
         this.FMaxMyMonsterCount = 0;
         this.FMaxFriendMonsterCount = 0;
         this.FQualityMonster = 0;
         this.FMaxLuckyCatCount = 0;
         this.FMaxGambleCount = 0;
         this.FChangeShapeGirlImageID = 0;
         this.FMaxMyGirlfriendInteractive = 0;
         this.FMaxGirlfriendInteractiveCount = 0;
         this.FMaxGirlfriendBeInteractiveCount = 0;
         if(this.FAppliance != null)
         {
            this.FAppliance.StubReferences.Dereference(this);
            this.FAppliance = null;
         }
      }
   }
}

