package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDNewYear2017Task extends THDActivityBase
   {
      
      protected var FTasks:Vector.<Object>;
      
      protected var FScoreIndex:uint;
      
      protected var FThreeAward:uint;
      
      protected var FThreeIndex:uint;
      
      protected var FSixIndex:uint;
      
      protected var FSixAward:uint;
      
      protected var FThreeNum:uint;
      
      protected var FSixNum:uint;
      
      public function THDNewYear2017Task()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FTasks = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FScoreIndex = param1.readUnsignedInt();
         this.FThreeIndex = param1.readUnsignedInt();
         this.FSixIndex = param1.readUnsignedInt();
         this.FThreeAward = param1.readUnsignedInt();
         this.FSixAward = param1.readUnsignedInt();
         this.FThreeNum = param1.readUnsignedInt();
         this.FSixNum = param1.readUnsignedInt();
      }
      
      public function get Tasks() : Vector.<Object>
      {
         return this.FTasks;
      }
      
      public function get ScoreIndex() : uint
      {
         return this.FScoreIndex;
      }
      
      public function get ThreeAward() : uint
      {
         return this.FThreeAward;
      }
      
      public function get ThreeIndex() : uint
      {
         return this.FThreeIndex;
      }
      
      public function get SixIndex() : uint
      {
         return this.FSixIndex;
      }
      
      public function get SixAward() : uint
      {
         return this.FSixAward;
      }
      
      public function get ThreeNum() : uint
      {
         return this.FThreeNum;
      }
      
      public function get SixNum() : uint
      {
         return this.FSixNum;
      }
   }
}

