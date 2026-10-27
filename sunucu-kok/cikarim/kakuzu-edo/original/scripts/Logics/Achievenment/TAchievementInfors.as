package Logics.Achievenment
{
   public class TAchievementInfors
   {
      
      protected var FAchievementInfors:Vector.<TAchievementInfor>;
      
      public function TAchievementInfors()
      {
         super();
         this.FAchievementInfors = new Vector.<TAchievementInfor>();
      }
      
      public function get Count() : int
      {
         return this.FAchievementInfors.length;
      }
      
      public function Add(param1:TAchievementInfor) : void
      {
         this.FAchievementInfors.push(param1);
      }
      
      public function GetAchievementByID(param1:uint) : TAchievementInfor
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.FAchievementInfors.length)
         {
            if(this.FAchievementInfors[_loc2_].ID == param1)
            {
               return this.FAchievementInfors[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function DeleteAchievementByID(param1:uint) : void
      {
         var _loc2_:* = 0;
         _loc2_ = int(this.FAchievementInfors.length - 1);
         while(_loc2_ >= 0)
         {
            if(this.FAchievementInfors[_loc2_].ID == param1)
            {
               this.FAchievementInfors.splice(_loc2_,1);
            }
            _loc2_--;
         }
      }
      
      public function GetAchievementByIndex(param1:int) : TAchievementInfor
      {
         return this.FAchievementInfors[param1];
      }
      
      public function DeleteAchievementByIndex(param1:int) : void
      {
         this.FAchievementInfors.splice(param1,1);
      }
      
      public function Clear() : void
      {
         this.FAchievementInfors.length = 0;
      }
   }
}

