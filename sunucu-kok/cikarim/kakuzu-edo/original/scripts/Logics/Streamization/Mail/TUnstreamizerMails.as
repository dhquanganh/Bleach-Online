package Logics.Streamization.Mail
{
   import Logics.Mail.TMail;
   import Logics.Mail.TMails;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerMails extends TUnstreamizerMailUnknown
   {
      
      protected var FUnstreamizerMail:TUnstreamizerMail;
      
      public function TUnstreamizerMails()
      {
         super();
         this.FUnstreamizerMail = new TUnstreamizerMail();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:TMail = null;
         var _loc7_:TMails = null;
         _loc7_ = param2 as TMails;
         _loc7_.Clear();
         _loc5_ = param1.readUnsignedShort();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = FPoolMail.AcquireMail();
            _loc6_.Type = TMail.TYPE_Inbox;
            this.FUnstreamizerMail.Unstreamize(param1,_loc6_,param3);
            _loc7_.Add(_loc6_);
            _loc4_++;
         }
         _loc5_ = param1.readUnsignedShort();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = FPoolMail.AcquireMail();
            _loc6_.Type = TMail.TYPE_Sentbox;
            this.FUnstreamizerMail.Unstreamize(param1,_loc6_,param3);
            _loc7_.Add(_loc6_);
            _loc4_++;
         }
      }
   }
}

