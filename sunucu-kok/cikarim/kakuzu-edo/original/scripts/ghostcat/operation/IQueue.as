package ghostcat.operation
{
   public interface IQueue extends IOper
   {
      
      function commitChild(param1:Oper) : void;
      
      function haltChild(param1:Oper) : void;
   }
}

