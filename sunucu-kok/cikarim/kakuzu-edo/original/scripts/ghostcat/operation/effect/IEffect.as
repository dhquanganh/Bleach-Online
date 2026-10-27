package ghostcat.operation.effect
{
   import ghostcat.operation.IOper;
   
   public interface IEffect extends IOper
   {
      
      function get target() : *;
      
      function set target(param1:*) : void;
   }
}

