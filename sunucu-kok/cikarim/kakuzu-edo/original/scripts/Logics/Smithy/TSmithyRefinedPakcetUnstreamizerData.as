package Logics.Smithy
{
   public class TSmithyRefinedPakcetUnstreamizerData
   {
      
      protected var FResultCode:uint;
      
      protected var FSkillID:uint;
      
      protected var FSmithyAttributeList:TSmithyAttributeList;
      
      public function TSmithyRefinedPakcetUnstreamizerData(param1:int)
      {
         super();
         this.FSmithyAttributeList = new TSmithyAttributeList(param1);
      }
      
      public function get SmithyAttributeList() : TSmithyAttributeList
      {
         return this.FSmithyAttributeList;
      }
      
      public function set SmithyAttributeList(param1:TSmithyAttributeList) : void
      {
         this.FSmithyAttributeList = param1;
      }
      
      public function get SkillID() : uint
      {
         return this.FSkillID;
      }
      
      public function set SkillID(param1:uint) : void
      {
         this.FSkillID = param1;
      }
      
      public function get ResultCode() : uint
      {
         return this.FResultCode;
      }
      
      public function set ResultCode(param1:uint) : void
      {
         this.FResultCode = param1;
      }
   }
}

