package Processors.Game.Lobby.Common.Map.SceneSprite
{
   import Processors.Game.Lobby.Common.Map.HeadDecoration.TDecorationBleachAgentIcon;
   import Processors.Game.Lobby.Common.Map.HeadDecoration.TDecorationMilitaryName;
   import Processors.Game.Lobby.Common.Map.HeadDecoration.TDecorationNamePlayer;
   import Processors.Game.Lobby.Common.Map.HeadDecoration.TDecorationShadow;
   import Processors.Game.Lobby.Common.Map.HeadDecoration.TDecorationTitle;
   import Processors.Game.Lobby.Common.Map.SpriteMoudleContorl.TSpriteActionContorlMainSceneSprite;
   import Processors.Game.Lobby.Common.Map.SpriteMoudleContorl.TSpriteMoudleContorlEightDirection;
   
   public class TSceneSpriteMoudleInMapCanRunPlayer extends TSceneSpriteMoudleInMapCanRun
   {
      
      protected var FName:String;
      
      protected var FMilitaryRank:uint;
      
      protected var FLevel:int;
      
      protected var FFamilyID:int;
      
      protected var FPetIsFight:Boolean;
      
      protected var FQuality:int;
      
      protected var FUserIDHigh:uint;
      
      protected var FUserIDLow:uint;
      
      protected var FBirthID:uint;
      
      protected var FKnifeOfKillSoul:TSceneSpriteMoudleInMapCanRunPlayer;
      
      protected var FPet:TSceneSpriteMoudleInMapCanRunPlayer;
      
      protected var FYellowDiamondLevel:int;
      
      protected var FIFYearYellowDiamondUser:Boolean;
      
      protected var FTitlesID:Vector.<int>;
      
      protected var FOpenBleachAgent:Boolean;
      
      protected var FRebirthNum:uint;
      
      public function TSceneSpriteMoudleInMapCanRunPlayer()
      {
         super();
         this.FTitlesID = new Vector.<int>();
      }
      
      override protected function CreateDecoration() : void
      {
         var _loc1_:TDecorationNamePlayer = null;
         var _loc2_:TDecorationMilitaryName = null;
         var _loc3_:TDecorationShadow = null;
         var _loc4_:TDecorationTitle = null;
         var _loc5_:TDecorationBleachAgentIcon = null;
         _loc1_ = new TDecorationNamePlayer();
         _loc2_ = new TDecorationMilitaryName();
         _loc4_ = new TDecorationTitle();
         _loc3_ = new TDecorationShadow();
         _loc5_ = new TDecorationBleachAgentIcon();
         AddHeadDecoration(_loc1_);
         AddHeadDecoration(_loc2_);
         AddHeadDecoration(_loc4_);
         AddHeadDecoration(_loc3_);
         AddHeadDecoration(_loc5_);
         addChild(_loc1_);
         addChild(_loc2_);
         addChild(_loc4_);
         addChildAt(_loc3_,0);
         addChild(_loc5_);
      }
      
      override protected function CreateSpriteMoudleContorl() : void
      {
         FSpriteMoudleContorl = new TSpriteMoudleContorlEightDirection();
      }
      
      override protected function CreateSpriteActionQuery() : void
      {
         FActionQuery = new TSpriteActionContorlMainSceneSprite();
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get MilitaryRank() : uint
      {
         return this.FMilitaryRank;
      }
      
      public function set MilitaryRank(param1:uint) : void
      {
         this.FMilitaryRank = param1;
      }
      
      public function get Level() : int
      {
         return this.FLevel;
      }
      
      public function set Level(param1:int) : void
      {
         this.FLevel = param1;
      }
      
      public function get FamilyID() : int
      {
         return this.FFamilyID;
      }
      
      public function set FamilyID(param1:int) : void
      {
         this.FFamilyID = param1;
      }
      
      public function get Quality() : int
      {
         return this.FQuality;
      }
      
      public function set Quality(param1:int) : void
      {
         this.FQuality = param1;
      }
      
      public function get UserIDHigh() : uint
      {
         return this.FUserIDHigh;
      }
      
      public function set UserIDHigh(param1:uint) : void
      {
         this.FUserIDHigh = param1;
      }
      
      public function get UserIDLow() : uint
      {
         return this.FUserIDLow;
      }
      
      public function set UserIDLow(param1:uint) : void
      {
         this.FUserIDLow = param1;
      }
      
      public function get KnifeOfKillSoul() : TSceneSpriteMoudleInMapCanRunPlayer
      {
         return this.FKnifeOfKillSoul;
      }
      
      public function set KnifeOfKillSoul(param1:TSceneSpriteMoudleInMapCanRunPlayer) : void
      {
         this.FKnifeOfKillSoul = param1;
      }
      
      public function get BirthID() : uint
      {
         return this.FBirthID;
      }
      
      public function set BirthID(param1:uint) : void
      {
         this.FBirthID = param1;
      }
      
      public function get YellowDiamondLevel() : int
      {
         return this.FYellowDiamondLevel;
      }
      
      public function set YellowDiamondLevel(param1:int) : void
      {
         this.FYellowDiamondLevel = param1;
      }
      
      public function get IFYearYellowDiamondUser() : Boolean
      {
         return this.FIFYearYellowDiamondUser;
      }
      
      public function set IFYearYellowDiamondUser(param1:Boolean) : void
      {
         this.FIFYearYellowDiamondUser = param1;
      }
      
      public function get TitlesID() : Vector.<int>
      {
         return this.FTitlesID;
      }
      
      public function get Pet() : TSceneSpriteMoudleInMapCanRunPlayer
      {
         return this.FPet;
      }
      
      public function set Pet(param1:TSceneSpriteMoudleInMapCanRunPlayer) : void
      {
         this.FPet = param1;
      }
      
      public function get OpenBleachAgent() : Boolean
      {
         return this.FOpenBleachAgent;
      }
      
      public function set OpenBleachAgent(param1:Boolean) : void
      {
         this.FOpenBleachAgent = param1;
      }
      
      public function get RebirthNum() : uint
      {
         return this.FRebirthNum;
      }
      
      public function set RebirthNum(param1:uint) : void
      {
         this.FRebirthNum = param1;
      }
      
      override public function UpdateData() : void
      {
         OpenRebirthEffect(true,this.FRebirthNum);
         super.UpdateData();
      }
      
      override public function UpdateView() : void
      {
         super.UpdateView();
      }
      
      override public function Release() : void
      {
         super.Release();
         this.FName = "";
         this.FMilitaryRank = 0;
         this.FLevel = 0;
         this.FFamilyID = 0;
         this.FPetIsFight = false;
         this.FQuality = 0;
         this.FUserIDHigh = 0;
         this.FUserIDLow = 0;
         this.FBirthID = 0;
         this.FKnifeOfKillSoul = null;
         this.FPet = null;
         this.FYellowDiamondLevel = 0;
         this.FIFYearYellowDiamondUser = false;
         this.FTitlesID.length = 0;
         this.FOpenBleachAgent = false;
         this.FRebirthNum = 0;
      }
   }
}

