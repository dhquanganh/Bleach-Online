package Logics.Home.GirlFriend
{
   import Logics.Inventories.TInventories;
   
   public class TGirlFriend
   {
      
      protected var FID:uint;
      
      protected var FLevel:int;
      
      protected var FImageID:int;
      
      protected var FName:String;
      
      protected var FLoadComplete:Boolean;
      
      protected var FGirlFriendTopLevelID:uint;
      
      protected var FCurrentChangeShapeGirlID:uint;
      
      protected var FCurrentChangeShapeGirlImageID:uint;
      
      protected var FCanMakeTofuTime:uint;
      
      protected var FCurrentCostMakeTofuTime:uint;
      
      protected var FMakeTofuCDTime:uint;
      
      protected var FMakeTofuAwardNum:uint;
      
      protected var FCanCommunicateTime:uint;
      
      protected var FCurrentSpriteCommunicateTime:uint;
      
      protected var FSpriteCommunicateCDTime:uint;
      
      protected var FGirlMood:int;
      
      protected var FSpriteCommunicateAwardName:String;
      
      protected var FSpriteCommunicateAwardID:uint;
      
      protected var FSpriteCommunicateAwardNum:uint;
      
      protected var FTeaseScore:uint;
      
      protected var FMyTeaseTime:uint;
      
      protected var FCurrentTeaseTime:uint;
      
      protected var FFriendTeaseType:int;
      
      protected var FFriendTeaseTime:uint;
      
      protected var FHomeLevelLimit:int;
      
      protected var FHomeLevelLimitName:String;
      
      protected var FUpgradeInventories:TInventories;
      
      protected var FUpgradeInventoryNum:int;
      
      protected var FUpgradeArticalID:uint;
      
      protected var FGirlDescrption:String;
      
      protected var FTitleName:String;
      
      protected var FTitleQuality:int;
      
      protected var FTitleAdded:Number;
      
      protected var FNeedPlayMakeTofuEffect:Boolean;
      
      protected var FNomalSpriteCommunicateCost:int;
      
      protected var FGoldSpriteCommunicateCost:int;
      
      public function TGirlFriend()
      {
         super();
         this.FUpgradeInventories = new TInventories();
      }
      
      public function get LoadComplete() : Boolean
      {
         return this.FLoadComplete;
      }
      
      public function set LoadComplete(param1:Boolean) : void
      {
         this.FLoadComplete = param1;
      }
      
      public function get GirlFriendTopLevelID() : uint
      {
         return this.FGirlFriendTopLevelID;
      }
      
      public function set GirlFriendTopLevelID(param1:uint) : void
      {
         this.FGirlFriendTopLevelID = param1;
      }
      
      public function get CurrentChangeShapeGirlID() : uint
      {
         return this.FCurrentChangeShapeGirlID;
      }
      
      public function set CurrentChangeShapeGirlID(param1:uint) : void
      {
         this.FCurrentChangeShapeGirlID = param1;
      }
      
      public function get CurrentCostMakeTofuTime() : uint
      {
         return this.FCurrentCostMakeTofuTime;
      }
      
      public function set CurrentCostMakeTofuTime(param1:uint) : void
      {
         this.FCurrentCostMakeTofuTime = param1;
      }
      
      public function get MakeTofuCDTime() : uint
      {
         return this.FMakeTofuCDTime;
      }
      
      public function set MakeTofuCDTime(param1:uint) : void
      {
         this.FMakeTofuCDTime = param1;
      }
      
      public function get TeaseScore() : uint
      {
         return this.FTeaseScore;
      }
      
      public function set TeaseScore(param1:uint) : void
      {
         this.FTeaseScore = param1;
      }
      
      public function get MyTeaseTime() : uint
      {
         return this.FMyTeaseTime;
      }
      
      public function set MyTeaseTime(param1:uint) : void
      {
         this.FMyTeaseTime = param1;
      }
      
      public function get FriendTeaseType() : int
      {
         return this.FFriendTeaseType;
      }
      
      public function set FriendTeaseType(param1:int) : void
      {
         this.FFriendTeaseType = param1;
      }
      
      public function get FriendTeaseTime() : uint
      {
         return this.FFriendTeaseTime;
      }
      
      public function set FriendTeaseTime(param1:uint) : void
      {
         this.FFriendTeaseTime = param1;
      }
      
      public function get CurrentSpriteCommunicateTime() : uint
      {
         return this.FCurrentSpriteCommunicateTime;
      }
      
      public function set CurrentSpriteCommunicateTime(param1:uint) : void
      {
         this.FCurrentSpriteCommunicateTime = param1;
      }
      
      public function get SpriteCommunicateCDTime() : uint
      {
         return this.FSpriteCommunicateCDTime;
      }
      
      public function set SpriteCommunicateCDTime(param1:uint) : void
      {
         this.FSpriteCommunicateCDTime = param1;
      }
      
      public function get CanMakeTofuTime() : uint
      {
         return this.FCanMakeTofuTime;
      }
      
      public function set CanMakeTofuTime(param1:uint) : void
      {
         this.FCanMakeTofuTime = param1;
      }
      
      public function get CanCommunicateTime() : uint
      {
         return this.FCanCommunicateTime;
      }
      
      public function set CanCommunicateTime(param1:uint) : void
      {
         this.FCanCommunicateTime = param1;
      }
      
      public function get GirlDescrption() : String
      {
         return this.FGirlDescrption;
      }
      
      public function set GirlDescrption(param1:String) : void
      {
         this.FGirlDescrption = param1;
      }
      
      public function get TitleName() : String
      {
         return this.FTitleName;
      }
      
      public function set TitleName(param1:String) : void
      {
         this.FTitleName = param1;
      }
      
      public function get TitleQuality() : int
      {
         return this.FTitleQuality;
      }
      
      public function set TitleQuality(param1:int) : void
      {
         this.FTitleQuality = param1;
      }
      
      public function get TitleAdded() : Number
      {
         return this.FTitleAdded;
      }
      
      public function set TitleAdded(param1:Number) : void
      {
         this.FTitleAdded = param1;
      }
      
      public function get HomeLevelLimit() : int
      {
         return this.FHomeLevelLimit;
      }
      
      public function set HomeLevelLimit(param1:int) : void
      {
         this.FHomeLevelLimit = param1;
      }
      
      public function get HomeLevelLimitName() : String
      {
         return this.FHomeLevelLimitName;
      }
      
      public function set HomeLevelLimitName(param1:String) : void
      {
         this.FHomeLevelLimitName = param1;
      }
      
      public function get UpgradeInventories() : TInventories
      {
         return this.FUpgradeInventories;
      }
      
      public function get UpgradeInventoryNum() : int
      {
         return this.FUpgradeInventoryNum;
      }
      
      public function set UpgradeInventoryNum(param1:int) : void
      {
         this.FUpgradeInventoryNum = param1;
      }
      
      public function get UpgradeArticalID() : uint
      {
         return this.FUpgradeArticalID;
      }
      
      public function set UpgradeArticalID(param1:uint) : void
      {
         this.FUpgradeArticalID = param1;
      }
      
      public function get ID() : uint
      {
         return this.FID;
      }
      
      public function set ID(param1:uint) : void
      {
         this.FID = param1;
      }
      
      public function get Level() : int
      {
         return this.FLevel;
      }
      
      public function set Level(param1:int) : void
      {
         this.FLevel = param1;
      }
      
      public function get NomalSpriteCommunicateCost() : int
      {
         return this.FNomalSpriteCommunicateCost;
      }
      
      public function set NomalSpriteCommunicateCost(param1:int) : void
      {
         this.FNomalSpriteCommunicateCost = param1;
      }
      
      public function get GoldSpriteCommunicateCost() : int
      {
         return this.FGoldSpriteCommunicateCost;
      }
      
      public function set GoldSpriteCommunicateCost(param1:int) : void
      {
         this.FGoldSpriteCommunicateCost = param1;
      }
      
      public function get CurrentTeaseTime() : uint
      {
         return this.FCurrentTeaseTime;
      }
      
      public function set CurrentTeaseTime(param1:uint) : void
      {
         this.FCurrentTeaseTime = param1;
      }
      
      public function get ImageID() : int
      {
         return this.FImageID;
      }
      
      public function set ImageID(param1:int) : void
      {
         this.FImageID = param1;
      }
      
      public function get CurrentChangeShapeGirlImageID() : uint
      {
         return this.FCurrentChangeShapeGirlImageID;
      }
      
      public function set CurrentChangeShapeGirlImageID(param1:uint) : void
      {
         this.FCurrentChangeShapeGirlImageID = param1;
      }
      
      public function get GirlMood() : int
      {
         return this.FGirlMood;
      }
      
      public function set GirlMood(param1:int) : void
      {
         this.FGirlMood = param1;
      }
      
      public function get NeedPlayMakeTofuEffect() : Boolean
      {
         return this.FNeedPlayMakeTofuEffect;
      }
      
      public function set NeedPlayMakeTofuEffect(param1:Boolean) : void
      {
         this.FNeedPlayMakeTofuEffect = param1;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get SpriteCommunicateAwardName() : String
      {
         return this.FSpriteCommunicateAwardName;
      }
      
      public function set SpriteCommunicateAwardName(param1:String) : void
      {
         this.FSpriteCommunicateAwardName = param1;
      }
      
      public function get SpriteCommunicateAwardID() : uint
      {
         return this.FSpriteCommunicateAwardID;
      }
      
      public function set SpriteCommunicateAwardID(param1:uint) : void
      {
         this.FSpriteCommunicateAwardID = param1;
      }
      
      public function get SpriteCommunicateAwardNum() : uint
      {
         return this.FSpriteCommunicateAwardNum;
      }
      
      public function set SpriteCommunicateAwardNum(param1:uint) : void
      {
         this.FSpriteCommunicateAwardNum = param1;
      }
      
      public function get MakeTofuAwardNum() : uint
      {
         return this.FMakeTofuAwardNum;
      }
      
      public function set MakeTofuAwardNum(param1:uint) : void
      {
         this.FMakeTofuAwardNum = param1;
      }
   }
}

