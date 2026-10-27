package Logics.HDPrivilegeLease
{
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class TActivityPrivilegeLeaseData extends TActivityOSBase
   {
      
      protected var FDataList:Vector.<PrivilegeLeaseVO>;
      
      protected var FPromptsList:Array;
      
      public function TActivityPrivilegeLeaseData()
      {
         super();
         this.FDataList = new Vector.<PrivilegeLeaseVO>();
      }
      
      public function set DataList(param1:Vector.<PrivilegeLeaseVO>) : void
      {
         this.FDataList = param1;
      }
      
      public function get DataList() : Vector.<PrivilegeLeaseVO>
      {
         return this.FDataList;
      }
      
      public function set PromptsList(param1:Array) : void
      {
         this.FPromptsList = param1;
      }
      
      public function get PromptsList() : Array
      {
         return this.FPromptsList;
      }
   }
}

