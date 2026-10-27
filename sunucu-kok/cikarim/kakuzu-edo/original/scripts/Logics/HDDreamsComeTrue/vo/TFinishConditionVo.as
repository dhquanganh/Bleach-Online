package Logics.HDDreamsComeTrue.vo
{
   public class TFinishConditionVo
   {
      
      private var FCondition:int;
      
      private var FFontShowCurFrame:int;
      
      private var FFontIndex:int;
      
      public function TFinishConditionVo()
      {
         super();
      }
      
      public function get Condition() : int
      {
         return this.FCondition;
      }
      
      public function set Condition(param1:int) : void
      {
         this.FCondition = param1;
      }
      
      public function get FontShowCurFrame() : int
      {
         return this.FFontShowCurFrame;
      }
      
      public function set FontShowCurFrame(param1:int) : void
      {
         this.FFontShowCurFrame = param1;
      }
      
      public function get FontIndex() : int
      {
         return this.FFontIndex;
      }
      
      public function set FontIndex(param1:int) : void
      {
         this.FFontIndex = param1;
      }
   }
}

