package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TDigging extends TDatebaseVO
   {
      
      protected var FMapid:uint;
      
      protected var FName:String;
      
      protected var FDescription:String;
      
      protected var FRate:uint;
      
      protected var FCostMoney:Vector.<Object>;
      
      protected var FSilverNum1:uint;
      
      protected var FAward1Vect:Vector.<Object>;
      
      protected var FAward2Vect:Vector.<Object>;
      
      protected var FDigtime:uint;
      
      protected var FRobbery:uint;
      
      protected var FRobberyaward:uint;
      
      protected var FDigmark:uint;
      
      protected var FOpenCost:Vector.<Object>;
      
      protected var FOpenReward:Vector.<Object>;
      
      protected var FIsgold:Boolean;
      
      protected var FViplevel:uint;
      
      protected var FSilverNum2:uint;
      
      protected var FRobGetReward:Vector.<Object>;
      
      protected var FMoney:String;
      
      protected var FAward1:String;
      
      protected var FAward2:String;
      
      protected var FGold:String;
      
      protected var FGoldItemReward:String;
      
      protected var FRobGet:String;
      
      public function TDigging()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:Array = null;
         this.FMapid = param1.readUnsignedInt();
         this.FName = TUtilityString.FetchUTF(param1);
         this.FDescription = TUtilityString.FetchUTF(param1);
         this.FRate = param1.readUnsignedInt();
         this.FMoney = TUtilityString.FetchUTF(param1);
         _loc2_ = Json.decode(this.FMoney);
         this.FCostMoney = Vector.<Object>(_loc2_);
         this.FSilverNum1 = param1.readUnsignedInt();
         this.FAward1 = TUtilityString.FetchUTF(param1);
         _loc2_ = Json.decode(this.FAward1);
         this.FAward1Vect = Vector.<Object>(_loc2_);
         this.FAward2 = TUtilityString.FetchUTF(param1);
         _loc2_ = Json.decode(this.FAward2);
         this.FAward2Vect = Vector.<Object>(_loc2_);
         this.FDigtime = param1.readUnsignedInt();
         this.FRobbery = param1.readUnsignedInt();
         this.FRobberyaward = param1.readUnsignedInt();
         this.FDigmark = param1.readUnsignedInt();
         this.FGold = TUtilityString.FetchUTF(param1);
         _loc2_ = Json.decode(this.FGold);
         this.FOpenCost = Vector.<Object>(_loc2_);
         this.FGoldItemReward = TUtilityString.FetchUTF(param1);
         _loc2_ = Json.decode(this.FGoldItemReward);
         this.FOpenReward = Vector.<Object>(_loc2_);
         this.FIsgold = param1.readInt() != 0;
         this.FViplevel = param1.readUnsignedInt();
         this.FSilverNum2 = param1.readUnsignedInt();
         this.FRobGet = TUtilityString.FetchUTF(param1);
         _loc2_ = Json.decode(this.FRobGet);
         this.FRobGetReward = Vector.<Object>(_loc2_);
      }
      
      public function get Mapid() : uint
      {
         return this.FMapid;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get Description() : String
      {
         return this.FDescription;
      }
      
      public function get Rate() : uint
      {
         return this.FRate;
      }
      
      public function get Award1Vect() : Vector.<Object>
      {
         return this.FAward1Vect;
      }
      
      public function get Award2Vect() : Vector.<Object>
      {
         return this.FAward2Vect;
      }
      
      public function get Digtime() : uint
      {
         return this.FDigtime;
      }
      
      public function get Robbery() : uint
      {
         return this.FRobbery;
      }
      
      public function get Robberyaward() : uint
      {
         return this.FRobberyaward;
      }
      
      public function get Digmark() : uint
      {
         return this.FDigmark;
      }
      
      public function get OpenCost() : Vector.<Object>
      {
         return this.FOpenCost;
      }
      
      public function get Isgold() : Boolean
      {
         return this.FIsgold;
      }
      
      public function get Viplevel() : uint
      {
         return this.FViplevel;
      }
      
      public function get Money() : String
      {
         return this.FMoney;
      }
      
      public function get Award1() : String
      {
         return this.FAward1;
      }
      
      public function get Award2() : String
      {
         return this.FAward2;
      }
      
      public function get Gold() : String
      {
         return this.FGold;
      }
      
      public function get OpenReward() : Vector.<Object>
      {
         return this.FOpenReward;
      }
      
      public function get GoldItemReward() : String
      {
         return this.FGoldItemReward;
      }
      
      public function get RobGetReward() : Vector.<Object>
      {
         return this.FRobGetReward;
      }
      
      public function get RobGet() : String
      {
         return this.FRobGet;
      }
      
      public function get SilverNum2() : uint
      {
         return this.FSilverNum2;
      }
      
      public function set SilverNum2(param1:uint) : void
      {
         this.FSilverNum2 = param1;
      }
      
      public function get SilverNum1() : uint
      {
         return this.FSilverNum1;
      }
      
      public function set SilverNum1(param1:uint) : void
      {
         this.FSilverNum1 = param1;
      }
   }
}

