package Logics.DatebaseVO.VO.Json
{
   public class TPayAgent
   {
      
      protected var FAgentId:uint;
      
      protected var FLink:String;
      
      public function TPayAgent(param1:Object)
      {
         super();
         this.FAgentId = param1.agent;
         this.FLink = param1.link;
      }
      
      public function get AgentId() : uint
      {
         return this.FAgentId;
      }
      
      public function set AgentId(param1:uint) : void
      {
         this.FAgentId = param1;
      }
      
      public function get Link() : String
      {
         return this.FLink;
      }
      
      public function set Link(param1:String) : void
      {
         this.FLink = param1;
      }
   }
}

