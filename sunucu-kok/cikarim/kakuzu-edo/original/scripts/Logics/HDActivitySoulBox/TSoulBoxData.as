package Logics.HDActivitySoulBox
{
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class TSoulBoxData extends TActivityOSBase
   {
      
      protected var FBoxList:Vector.<THDBoxStateData>;
      
      public function TSoulBoxData()
      {
         super();
         this.FBoxList = new Vector.<THDBoxStateData>();
      }
      
      public function get BoxListCount() : uint
      {
         return this.FBoxList.length;
      }
      
      public function get BoxList() : Vector.<THDBoxStateData>
      {
         return this.FBoxList;
      }
      
      public function set BoxList(param1:Vector.<THDBoxStateData>) : void
      {
         this.FBoxList = param1;
      }
      
      public function AddAward(param1:THDBoxStateData) : void
      {
         this.FBoxList.push(param1);
      }
      
      public function GetAwardByIndex(param1:uint) : THDBoxStateData
      {
         return this.FBoxList[param1];
      }
      
      public function ClearAward() : void
      {
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         var _loc3_:THDBoxStateData = null;
         _loc1_ = int(this.FBoxList.length);
         while(_loc1_ > 0)
         {
            _loc3_ = this.FBoxList[_loc1_ - 1];
            _loc3_ = null;
            this.FBoxList.pop();
            _loc1_--;
         }
      }
   }
}

