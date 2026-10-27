package Logics.DatebaseVO.VO.Json
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   
   use namespace ResourcesSpace;
   
   public class TPostEvent
   {
      
      protected var FIdentifier:uint;
      
      protected var FName:String;
      
      public function TPostEvent(param1:Object)
      {
         var _loc2_:String = null;
         super();
         if(param1 != null)
         {
            for(_loc2_ in param1)
            {
               this.FIdentifier = parseInt(_loc2_);
               this.FName = param1[_loc2_];
            }
         }
         else
         {
            this.FIdentifier = 0;
            this.FName = "";
         }
      }
      
      public function get Identifier() : int
      {
         return this.FIdentifier;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
   }
}

