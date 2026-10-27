package Logics.HDFeedback
{
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDFeedback.VO.TFeedbackPageVO;
   
   public class TFeedbackData extends TActivityOSBase
   {
      
      protected var FPageVO1:TFeedbackPageVO;
      
      protected var FPageVO2:TFeedbackPageVO;
      
      protected var FPageVO3:TFeedbackPageVO;
      
      protected var FPageVO4:TFeedbackPageVO;
      
      public function TFeedbackData()
      {
         super();
         this.FPageVO1 = new TFeedbackPageVO();
         this.FPageVO2 = new TFeedbackPageVO();
         this.FPageVO3 = new TFeedbackPageVO();
         this.FPageVO4 = new TFeedbackPageVO();
      }
      
      public function get PageVO1() : TFeedbackPageVO
      {
         return this.FPageVO1;
      }
      
      public function set PageVO1(param1:TFeedbackPageVO) : void
      {
         this.FPageVO1 = param1;
      }
      
      public function get PageVO2() : TFeedbackPageVO
      {
         return this.FPageVO2;
      }
      
      public function set PageVO2(param1:TFeedbackPageVO) : void
      {
         this.FPageVO2 = param1;
      }
      
      public function get PageVO3() : TFeedbackPageVO
      {
         return this.FPageVO3;
      }
      
      public function set PageVO3(param1:TFeedbackPageVO) : void
      {
         this.FPageVO3 = param1;
      }
      
      public function get PageVO4() : TFeedbackPageVO
      {
         return this.FPageVO4;
      }
      
      public function set PageVO4(param1:TFeedbackPageVO) : void
      {
         this.FPageVO4 = param1;
      }
   }
}

