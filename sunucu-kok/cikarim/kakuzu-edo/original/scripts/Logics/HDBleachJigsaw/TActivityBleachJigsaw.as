package Logics.HDBleachJigsaw
{
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class TActivityBleachJigsaw extends TActivityOSBase
   {
      
      protected var FJigSawItemsVec:Vector.<TActivityBJItem>;
      
      protected var FJigSawNeedsVec:Vector.<Vector.<TActivityBJNeed>>;
      
      protected var FJigSawNeedsBVec:Vector.<TActivityBJNeed>;
      
      protected var FJigSawBtnVec:Vector.<TActivityBJBtnAward>;
      
      protected var FJigSawFinalAwardVec:Vector.<TActivityBJFinalAward>;
      
      protected var FJigSawFinalStatus:int;
      
      protected var FJigSawCoolDown:int;
      
      public function TActivityBleachJigsaw()
      {
         super();
      }
      
      public function get JigSawItemsVec() : Vector.<TActivityBJItem>
      {
         return this.FJigSawItemsVec;
      }
      
      public function get JigSawNeedsVec() : Vector.<Vector.<TActivityBJNeed>>
      {
         return this.FJigSawNeedsVec;
      }
      
      public function get JigSawFinalAwardVec() : Vector.<TActivityBJFinalAward>
      {
         return this.FJigSawFinalAwardVec;
      }
      
      public function get JigSawBtnVec() : Vector.<TActivityBJBtnAward>
      {
         return this.FJigSawBtnVec;
      }
      
      public function set JigSawItemsVec(param1:Vector.<TActivityBJItem>) : void
      {
         this.FJigSawItemsVec = param1;
      }
      
      public function set JigSawNeedsVec(param1:Vector.<Vector.<TActivityBJNeed>>) : void
      {
         this.FJigSawNeedsVec = param1;
      }
      
      public function set JigSawBtnVec(param1:Vector.<TActivityBJBtnAward>) : void
      {
         this.FJigSawBtnVec = param1;
      }
      
      public function set JigSawFinalAwardVec(param1:Vector.<TActivityBJFinalAward>) : void
      {
         this.FJigSawFinalAwardVec = param1;
      }
      
      public function get JigSawFinalStatus() : int
      {
         return this.FJigSawFinalStatus;
      }
      
      public function set JigSawFinalStatus(param1:int) : void
      {
         this.FJigSawFinalStatus = param1;
      }
      
      public function get JigSawCoolDown() : int
      {
         return this.FJigSawCoolDown;
      }
      
      public function set JigSawCoolDown(param1:int) : void
      {
         this.FJigSawCoolDown = param1;
      }
      
      public function SetNumByUIndex(param1:uint, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = int(this.FJigSawItemsVec.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(param1 == this.FJigSawItemsVec[_loc3_].Index)
            {
               this.FJigSawItemsVec[_loc3_].Num = param2;
               return;
            }
            _loc3_++;
         }
      }
      
      public function SetStatusByUIndex(param1:uint, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = int(this.FJigSawItemsVec.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(param1 == this.FJigSawItemsVec[_loc3_].Index)
            {
               this.FJigSawItemsVec[_loc3_].IsHad = param2;
               return;
            }
            _loc3_++;
         }
      }
   }
}

