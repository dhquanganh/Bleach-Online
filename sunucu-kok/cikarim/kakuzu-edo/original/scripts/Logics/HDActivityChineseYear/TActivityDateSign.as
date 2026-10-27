package Logics.HDActivityChineseYear
{
   import Logics.HDActivityMode.TActivityEntity;
   
   public class TActivityDateSign extends TActivityEntity
   {
      
      protected var FAward:Vector.<uint>;
      
      protected var FStatus:int;
      
      protected var FIsCur:Boolean;
      
      protected var FIsPass:Boolean;
      
      public function TActivityDateSign(param1:uint)
      {
         super(param1);
         this.FAward = new Vector.<uint>();
      }
      
      public function get Award() : Vector.<uint>
      {
         return this.FAward;
      }
      
      public function set Award(param1:Vector.<uint>) : void
      {
         this.FAward = param1;
      }
      
      public function get Status() : int
      {
         return this.FStatus;
      }
      
      public function set Status(param1:int) : void
      {
         this.FStatus = param1;
      }
      
      public function get IsCur() : Boolean
      {
         return this.FIsCur;
      }
      
      public function set IsCur(param1:Boolean) : void
      {
         this.FIsCur = param1;
      }
      
      public function get IsPass() : Boolean
      {
         return this.FIsPass;
      }
      
      public function set IsPass(param1:Boolean) : void
      {
         this.FIsPass = param1;
      }
   }
}

