package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.*;
   import flash.utils.*;
   import ghostcat.util.data.*;
   
   use namespace ResourcesSpace;
   
   public class TTemplePoint extends TDatebaseVO
   {
      
      protected var FName:String;
      
      protected var FNextPointID:uint;
      
      protected var FArmyID:Vector.<uint>;
      
      protected var FBattleScene:uint;
      
      protected var FAkeyPrice:uint;
      
      public function TTemplePoint()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Object = null;
         this.FName = TUtilityString.FetchUTF(param1);
         this.FNextPointID = param1.readUnsignedInt();
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_);
         _loc3_ = int(_loc5_.army.length);
         this.FArmyID = new Vector.<uint>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FArmyID[_loc2_] = _loc5_.army[_loc2_];
            _loc2_++;
         }
         this.FBattleScene = param1.readUnsignedInt();
         this.FAkeyPrice = param1.readUnsignedInt();
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get NextPointID() : uint
      {
         return this.FNextPointID;
      }
      
      public function get ArmyID() : Vector.<uint>
      {
         return this.FArmyID;
      }
      
      public function get BattleScene() : uint
      {
         return this.FBattleScene;
      }
      
      public function get AkeyPrice() : uint
      {
         return this.FAkeyPrice;
      }
   }
}

