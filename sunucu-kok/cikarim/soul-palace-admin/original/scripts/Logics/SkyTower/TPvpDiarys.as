package Logics.SkyTower
{
   public class TPvpDiarys
   {
      
      protected var FPvpDiarys:Vector.<TPvpDiary>;
      
      public function TPvpDiarys()
      {
         super();
         this.FPvpDiarys = new Vector.<TPvpDiary>();
      }
      
      protected function SortPvpDiary(param1:TPvpDiary, param2:TPvpDiary) : int
      {
         if(param1.Time > param2.Time)
         {
            return -1;
         }
         return 1;
      }
      
      public function get Count() : int
      {
         return this.FPvpDiarys.length;
      }
      
      public function GetPvpDiaryByIndex(param1:int) : TPvpDiary
      {
         return this.FPvpDiarys[param1];
      }
      
      public function Clear() : void
      {
         this.FPvpDiarys.length = 0;
      }
      
      public function Add(param1:TPvpDiary) : void
      {
         this.FPvpDiarys.push(param1);
      }
      
      public function DeleteByIndex(param1:uint) : void
      {
         this.FPvpDiarys.splice(param1,1);
      }
      
      public function SortPvpDiarys() : void
      {
         this.FPvpDiarys.sort(this.SortPvpDiary);
      }
   }
}

