package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TKnife extends TDatebaseVO
   {
      
      protected var FName:String;
      
      protected var FBindSkillID:int;
      
      protected var FTypeID:int;
      
      protected var FHandBookID:uint;
      
      protected var FAppraise:String;
      
      protected var FGetRoad:String;
      
      protected var FAttackAttr:int;
      
      protected var FDefenseAttr:int;
      
      protected var FRecoveryAttr:int;
      
      protected var FResistanceAttr:int;
      
      protected var FSpeedAttr:int;
      
      protected var FDirection:int;
      
      protected var FAttributeType:Vector.<int>;
      
      protected var FBaseValue:Vector.<int>;
      
      protected var FGrowthValue:Vector.<int>;
      
      protected var FActiveEffects:Vector.<int>;
      
      public function TKnife()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FName = TUtilityString.FetchUTF(param1);
         this.FBindSkillID = param1.readInt();
         this.FTypeID = param1.readInt();
         this.FHandBookID = param1.readInt();
         this.FAppraise = TUtilityString.FetchUTF(param1);
         this.FGetRoad = TUtilityString.FetchUTF(param1);
         this.FAttackAttr = param1.readInt();
         this.FDefenseAttr = param1.readInt();
         this.FRecoveryAttr = param1.readInt();
         this.FResistanceAttr = param1.readInt();
         this.FSpeedAttr = param1.readInt();
         this.FDirection = param1.readInt();
         this.FAttributeType = Vector.<int>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FBaseValue = Vector.<int>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FGrowthValue = Vector.<int>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FActiveEffects = Vector.<int>(Json.decode(TUtilityString.FetchUTF(param1)));
      }
      
      public function get BindSkillID() : int
      {
         return this.FBindSkillID;
      }
      
      public function get TypeID() : int
      {
         return this.FTypeID;
      }
      
      public function get HandBookID() : uint
      {
         return this.FHandBookID;
      }
      
      public function get Appraise() : String
      {
         return this.FAppraise;
      }
      
      public function get GetRoad() : String
      {
         return this.FGetRoad;
      }
      
      public function get AttackAttr() : int
      {
         return this.FAttackAttr;
      }
      
      public function get DefenseAttr() : int
      {
         return this.FDefenseAttr;
      }
      
      public function get RecoveryAttr() : int
      {
         return this.FRecoveryAttr;
      }
      
      public function get ResistanceAttr() : int
      {
         return this.FResistanceAttr;
      }
      
      public function get SpeedAttr() : int
      {
         return this.FSpeedAttr;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get AttributeType() : Vector.<int>
      {
         return this.FAttributeType;
      }
      
      public function get BaseValue() : Vector.<int>
      {
         return this.FBaseValue;
      }
      
      public function get GrowthValue() : Vector.<int>
      {
         return this.FGrowthValue;
      }
      
      public function get ActiveEffects() : Vector.<int>
      {
         return this.FActiveEffects;
      }
      
      public function get Direction() : int
      {
         return this.FDirection;
      }
   }
}

