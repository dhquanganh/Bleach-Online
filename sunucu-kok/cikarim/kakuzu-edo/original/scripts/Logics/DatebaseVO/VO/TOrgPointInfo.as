package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TOrgPointInfo extends TDatebaseVO
   {
      
      protected var FName:String;
      
      protected var FActionEexertion:uint;
      
      protected var FRemainingNumber:uint;
      
      protected var FArmy:Object;
      
      protected var FRoleModel:uint;
      
      protected var FShowRateAward:uint;
      
      protected var FGuildRateAward:uint;
      
      protected var FNextPoint:uint;
      
      protected var FCoordinate:Object;
      
      protected var FBattleScene:uint;
      
      protected var FToTarget:Array;
      
      public function TOrgPointInfo()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FName = TUtilityString.FetchUTF(param1);
         this.FActionEexertion = param1.readUnsignedInt();
         this.FRemainingNumber = param1.readUnsignedInt();
         this.FArmy = Json.decode(TUtilityString.FetchUTF(param1));
         this.FRoleModel = param1.readUnsignedInt();
         this.FShowRateAward = param1.readUnsignedInt();
         this.FGuildRateAward = param1.readUnsignedInt();
         this.FNextPoint = param1.readUnsignedInt();
         this.FCoordinate = Json.decode(TUtilityString.FetchUTF(param1));
         this.FBattleScene = param1.readUnsignedInt();
         this.FToTarget = Json.decode(TUtilityString.FetchUTF(param1));
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get Army() : Object
      {
         return this.FArmy;
      }
      
      public function get RoleModel() : uint
      {
         return this.FRoleModel;
      }
      
      public function get ShowRateAward() : uint
      {
         return this.FShowRateAward;
      }
      
      public function get GuildRateAward() : uint
      {
         return this.FGuildRateAward;
      }
      
      public function get NextPoint() : uint
      {
         return this.FNextPoint;
      }
      
      public function get Coordinate() : Object
      {
         return this.FCoordinate;
      }
      
      public function get BattleScene() : uint
      {
         return this.FBattleScene;
      }
      
      public function get ToTarget() : Array
      {
         return this.FToTarget;
      }
      
      public function get ActionEexertion() : uint
      {
         return this.FActionEexertion;
      }
      
      public function get RemainingNumber() : uint
      {
         return this.FRemainingNumber;
      }
   }
}

