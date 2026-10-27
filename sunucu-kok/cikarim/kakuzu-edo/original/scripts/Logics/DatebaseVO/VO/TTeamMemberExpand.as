package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TTeamMemberExpand extends TDatebaseVO
   {
      
      protected var FCost:int;
      
      public function TTeamMemberExpand()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FCost = param1.readInt();
      }
      
      public function get Cost() : int
      {
         return this.FCost;
      }
   }
}

