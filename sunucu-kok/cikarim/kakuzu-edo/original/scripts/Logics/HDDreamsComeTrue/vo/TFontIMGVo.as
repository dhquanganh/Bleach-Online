package Logics.HDDreamsComeTrue.vo
{
   public class TFontIMGVo
   {
      
      private var FFontIndex:int;
      
      private var FFontCount:int;
      
      private var FTipsName:String;
      
      private var FCurFrame:int;
      
      public function TFontIMGVo()
      {
         super();
      }
      
      public function set FontIndex(param1:int) : void
      {
         this.FFontIndex = param1;
      }
      
      public function get FontIndex() : int
      {
         return this.FFontIndex;
      }
      
      public function set FontCount(param1:int) : void
      {
         this.FFontCount = param1;
      }
      
      public function get FontCount() : int
      {
         return this.FFontCount;
      }
      
      public function set TipsName(param1:String) : void
      {
         this.FTipsName = param1;
      }
      
      public function get TipsName() : String
      {
         return this.FTipsName;
      }
      
      public function set CurFrame(param1:int) : void
      {
         this.FCurFrame = param1;
      }
      
      public function get CurFrame() : int
      {
         return this.FCurFrame;
      }
   }
}

