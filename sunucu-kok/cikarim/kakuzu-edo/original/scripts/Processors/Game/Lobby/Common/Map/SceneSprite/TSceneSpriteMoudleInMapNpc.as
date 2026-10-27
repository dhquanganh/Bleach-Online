package Processors.Game.Lobby.Common.Map.SceneSprite
{
   import Logics.Quests.TQuests;
   import Processors.Game.Lobby.Common.Map.HeadDecoration.TDecorationIconNpc;
   import Processors.Game.Lobby.Common.Map.HeadDecoration.TDecorationNameNpc;
   import Processors.Game.Lobby.Common.Map.HeadDecoration.TDecorationShadow;
   import Processors.Game.Lobby.Common.Map.SpriteMoudleContorl.TSpriteActionContorlMainSceneSprite;
   import Processors.Game.Lobby.Common.Map.SpriteMoudleContorl.TSpriteMoudleContorlNpc;
   import flash.filters.GlowFilter;
   
   public class TSceneSpriteMoudleInMapNpc extends TSceneSpriteMoudleInMap
   {
      
      protected static const NameFilters:Array = [new GlowFilter(0,1,2,2,12,1,false,false)];
      
      protected var FNpcCityID:uint;
      
      protected var FNpcQuestMin:uint;
      
      protected var FNpcQuestMax:uint;
      
      protected var FUserType:uint;
      
      protected var FNormalTalkText:String;
      
      protected var FNpcStartTextureID:uint;
      
      protected var FNpcStyleTextureID:uint;
      
      protected var FName:String;
      
      protected var FNpcFunctionOpenConditionType:int;
      
      protected var FNpcFunctionOpenCondition:int;
      
      protected var FNpcFunctionCloseCondition:int;
      
      protected var FIfOpenUserFunction:Boolean;
      
      protected var FQuestes:TQuests;
      
      public function TSceneSpriteMoudleInMapNpc()
      {
         super();
         this.FQuestes = new TQuests();
      }
      
      override protected function CreateDecoration() : void
      {
         var _loc1_:TDecorationNameNpc = null;
         var _loc2_:TDecorationIconNpc = null;
         var _loc3_:TDecorationShadow = null;
         _loc1_ = new TDecorationNameNpc();
         AddHeadDecoration(_loc1_);
         _loc2_ = new TDecorationIconNpc();
         AddHeadDecoration(_loc2_);
         _loc3_ = new TDecorationShadow();
         AddHeadDecoration(_loc3_);
         addChild(_loc1_);
         addChild(_loc2_);
         addChildAt(_loc3_,0);
      }
      
      override protected function CreateSpriteMoudleContorl() : void
      {
         FSpriteMoudleContorl = new TSpriteMoudleContorlNpc();
      }
      
      override protected function CreateSpriteActionQuery() : void
      {
         FActionQuery = new TSpriteActionContorlMainSceneSprite();
      }
      
      public function get NpcCityID() : uint
      {
         return this.FNpcCityID;
      }
      
      public function set NpcCityID(param1:uint) : void
      {
         this.FNpcCityID = param1;
      }
      
      public function get NpcQuestMin() : uint
      {
         return this.FNpcQuestMin;
      }
      
      public function set NpcQuestMin(param1:uint) : void
      {
         this.FNpcQuestMin = param1;
      }
      
      public function get NpcQuestMax() : uint
      {
         return this.FNpcQuestMax;
      }
      
      public function set NpcQuestMax(param1:uint) : void
      {
         this.FNpcQuestMax = param1;
      }
      
      public function get UserType() : uint
      {
         return this.FUserType;
      }
      
      public function set UserType(param1:uint) : void
      {
         this.FUserType = param1;
      }
      
      public function get NormalTalkText() : String
      {
         return this.FNormalTalkText;
      }
      
      public function set NormalTalkText(param1:String) : void
      {
         this.FNormalTalkText = param1;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get NpcStartTextureID() : uint
      {
         return this.FNpcStartTextureID;
      }
      
      public function set NpcStartTextureID(param1:uint) : void
      {
         this.FNpcStartTextureID = param1;
      }
      
      public function get Questes() : TQuests
      {
         return this.FQuestes;
      }
      
      public function set Questes(param1:TQuests) : void
      {
         this.FQuestes = param1;
      }
      
      public function set NpcStyleTextureID(param1:uint) : void
      {
         this.FNpcStyleTextureID = param1;
      }
      
      public function get NpcStyleTextureID() : uint
      {
         return this.FNpcStyleTextureID;
      }
      
      public function get NpcFunctionOpenConditionType() : int
      {
         return this.FNpcFunctionOpenConditionType;
      }
      
      public function set NpcFunctionOpenConditionType(param1:int) : void
      {
         this.FNpcFunctionOpenConditionType = param1;
      }
      
      public function get NpcFunctionOpenCondition() : int
      {
         return this.FNpcFunctionOpenCondition;
      }
      
      public function set NpcFunctionOpenCondition(param1:int) : void
      {
         this.FNpcFunctionOpenCondition = param1;
      }
      
      public function get NpcFunctionCloseCondition() : int
      {
         return this.FNpcFunctionCloseCondition;
      }
      
      public function set NpcFunctionCloseCondition(param1:int) : void
      {
         this.FNpcFunctionCloseCondition = param1;
      }
      
      public function get IfOpenUserFunction() : Boolean
      {
         return this.FIfOpenUserFunction;
      }
      
      public function set IfOpenUserFunction(param1:Boolean) : void
      {
         this.FIfOpenUserFunction = param1;
      }
      
      override public function UpdateData() : void
      {
         super.UpdateData();
      }
      
      override public function UpdateView() : void
      {
         super.UpdateView();
      }
      
      public function ShowRoleMoudle() : void
      {
         ChangeRoleMoudle(this.FNpcStartTextureID,1);
      }
   }
}

