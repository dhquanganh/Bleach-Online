package Logics.Affairs
{
   import Foundation.Common.TEntity;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TAffair extends TEntity
   {
      
      public static const POSTPROCESS_Remove:int = 0;
      
      public static const POSTPROCESS_Pend:int = 1;
      
      protected var FPostProcess:int;
      
      public function TAffair(param1:uint)
      {
         super(param1);
      }
      
      LogicsSpace function Coerce(param1:uint) : void
      {
         FIdentifier = param1;
         this.FPostProcess = POSTPROCESS_Remove;
      }
      
      public function get PostProcess() : int
      {
         return this.FPostProcess;
      }
      
      public function set PostProcess(param1:int) : void
      {
         this.FPostProcess = param1;
      }
   }
}

