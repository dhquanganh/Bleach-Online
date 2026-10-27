package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDDuanwujieBoat extends THDActivityBase
   {
      
      protected var FGameCount:Object;
      
      protected var FCheer:Object;
      
      protected var FStart:uint;
      
      protected var FOver:Object;
      
      protected var FEvaluation:Object;
      
      protected var FScore:uint;
      
      protected var FMall:Vector.<Object>;
      
      protected var FBigAward:Object;
      
      protected var FMorale:Object;
      
      protected var FCheerAwards:Vector.<Object>;
      
      protected var FEvents:Vector.<Object>;
      
      protected var FLength:uint;
      
      protected var FSpeed:uint;
      
      protected var FNpcSpeed:uint;
      
      protected var FBlockLength:uint;
      
      protected var FTexts:Vector.<Object>;
      
      public function THDDuanwujieBoat()
      {
         super();
         this.FMall = new Vector.<Object>();
         this.FCheerAwards = new Vector.<Object>();
         this.FEvents = new Vector.<Object>();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:Object = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FGameCount = Json.decode(TUtilityString.FetchUTF(param1));
         this.FCheer = Json.decode(TUtilityString.FetchUTF(param1));
         this.FStart = param1.readUnsignedInt();
         this.FOver = Json.decode(TUtilityString.FetchUTF(param1));
         this.FEvaluation = Json.decode(TUtilityString.FetchUTF(param1));
         this.FScore = param1.readUnsignedInt();
         this.FMall = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FBigAward = Json.decode(TUtilityString.FetchUTF(param1));
         this.FMorale = Json.decode(TUtilityString.FetchUTF(param1));
         this.FCheerAwards = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FEvents = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FLength = param1.readUnsignedInt();
         this.FSpeed = param1.readUnsignedInt();
         this.FNpcSpeed = param1.readUnsignedInt();
         this.FBlockLength = param1.readUnsignedInt();
         this.FTexts = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
      }
      
      public function get GameCount() : Object
      {
         return this.FGameCount;
      }
      
      public function get Cheer() : Object
      {
         return this.FCheer;
      }
      
      public function get Start() : uint
      {
         return this.FStart;
      }
      
      public function get Over() : Object
      {
         return this.FOver;
      }
      
      public function get Evaluation() : Object
      {
         return this.FEvaluation;
      }
      
      public function get Score() : uint
      {
         return this.FScore;
      }
      
      public function get Mall() : Vector.<Object>
      {
         return this.FMall;
      }
      
      public function get BigAward() : Object
      {
         return this.FBigAward;
      }
      
      public function get Morale() : Object
      {
         return this.FMorale;
      }
      
      public function get CheerAwards() : Vector.<Object>
      {
         return this.FCheerAwards;
      }
      
      public function get Events() : Vector.<Object>
      {
         return this.FEvents;
      }
      
      public function get Length() : uint
      {
         return this.FLength;
      }
      
      public function get Speed() : uint
      {
         return this.FSpeed;
      }
      
      public function get NpcSpeed() : uint
      {
         return this.FNpcSpeed;
      }
      
      public function set NpcSpeed(param1:uint) : void
      {
         this.FNpcSpeed = param1;
      }
      
      public function get BlockLength() : uint
      {
         return this.FBlockLength;
      }
      
      public function set BlockLength(param1:uint) : void
      {
         this.FBlockLength = param1;
      }
      
      public function get Texts() : Vector.<Object>
      {
         return this.FTexts;
      }
      
      public function set Texts(param1:Vector.<Object>) : void
      {
         this.FTexts = param1;
      }
   }
}

