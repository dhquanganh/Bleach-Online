package Logics.TeamBattle
{
   public class TModels
   {
      
      protected var FModels:Vector.<TModel>;
      
      public function TModels()
      {
         super();
         this.FModels = new Vector.<TModel>();
      }
      
      protected function SortModel(param1:TModel, param2:TModel) : int
      {
         if(param1.Identifier < param2.Identifier)
         {
            return -1;
         }
         return 1;
      }
      
      public function get Count() : int
      {
         return this.FModels.length;
      }
      
      public function GetModelByIndex(param1:int) : TModel
      {
         return this.FModels[param1];
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TModel = null;
         _loc1_ = int(this.FModels.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FModels[_loc2_];
            _loc2_++;
         }
         this.FModels.length = 0;
      }
      
      public function Add(param1:TModel) : void
      {
         this.FModels.push(param1);
      }
      
      public function GetModelByIdentifier(param1:uint) : TModel
      {
         var _loc2_:int = 0;
         var _loc3_:TModel = null;
         var _loc4_:TModel = null;
         _loc2_ = 0;
         while(_loc2_ < this.Count)
         {
            _loc3_ = this.FModels[_loc2_];
            if(_loc3_.Identifier == param1)
            {
               _loc4_ = _loc3_;
               break;
            }
            _loc2_++;
         }
         return _loc4_;
      }
      
      public function DeleteByIdentifier(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TModel = null;
         _loc2_ = 0;
         while(_loc2_ < this.Count)
         {
            _loc3_ = this.FModels[_loc2_];
            if(_loc3_.Identifier == param1)
            {
               this.FModels.splice(_loc2_,1);
            }
            _loc2_++;
         }
      }
      
      public function SortModels() : void
      {
         this.FModels.sort(this.SortModel);
      }
   }
}

