package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TLeagueAction extends TDatebaseVO
   {
      
      protected var FScriptAction:Vector.<int>;
      
      public function TLeagueAction()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FScriptAction = Vector.<int>(_loc3_);
      }
      
      public function get ScriptAction() : Vector.<int>
      {
         return this.FScriptAction;
      }
   }
}

