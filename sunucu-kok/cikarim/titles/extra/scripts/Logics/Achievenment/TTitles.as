package Logics.Achievenment
{
   public class TTitles
   {
      
      protected var FTitles:Vector.<TTitle>;
      
      public function TTitles()
      {
         super();
         this.FTitles = new Vector.<TTitle>();
      }
      
      public function SortFunction(param1:TTitle, param2:TTitle) : int
      {
         if(param1.ID > param2.ID)
         {
            return 1;
         }
         if(param1.ID < param2.ID)
         {
            return -1;
         }
         return 0;
      }
      
      public function get Count() : int
      {
         return this.FTitles.length;
      }
      
      public function GetTitleByIndex(param1:int) : TTitle
      {
         return this.FTitles[param1];
      }
      
      public function Add(param1:TTitle) : void
      {
         this.FTitles.push(param1);
      }
      
      public function Sort() : void
      {
         this.FTitles.sort(this.SortFunction);
      }
      
      public function Clear() : void
      {
         this.FTitles.length = 0;
      }
      
      public function DeleteByIndex(param1:int) : void
      {
         this.FTitles.splice(param1,1);
      }
      
      public function GetTitleByID(param1:int) : TTitle
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TTitle = null;
         _loc3_ = int(this.FTitles.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FTitles[_loc2_];
            if(_loc4_.ID == param1)
            {
               return _loc4_;
            }
            _loc2_++;
         }
         return null;
      }
   }
}

