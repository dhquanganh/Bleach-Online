package Foundation.Common
{
   import Debugging.*;
   
   public class TEntityList
   {
      
      protected var FEntities:Vector.<TEntity>;
      
      public function TEntityList()
      {
         super();
         this.FEntities = new Vector.<TEntity>();
      }
      
      public function get Count() : int
      {
         return this.FEntities.length;
      }
      
      public function GetEntityByIndex(param1:int) : TEntity
      {
         return this.FEntities[param1];
      }
      
      public function GetEntityByIdentifier(param1:uint) : TEntity
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TEntity = null;
         _loc2_ = int(this.FEntities.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.FEntities[_loc3_];
            if(_loc4_.Identifier == param1)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function DeleteByIdentifier(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TEntity = null;
         _loc2_ = int(this.FEntities.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.FEntities[_loc3_];
            if(_loc4_.Identifier == param1)
            {
               this.FEntities.splice(_loc3_,1);
            }
            _loc3_++;
         }
      }
      
      public function Clear() : void
      {
         this.FEntities.length = 0;
      }
      
      public function Add(param1:TEntity) : void
      {
         this.FEntities.push(param1);
      }
      
      public function Delete(param1:int) : TEntity
      {
         var _loc2_:TEntity = null;
         return this.FEntities.splice(param1,1)[0];
      }
      
      public function IndexOf(param1:TEntity) : int
      {
         return this.FEntities.indexOf(param1);
      }
   }
}

