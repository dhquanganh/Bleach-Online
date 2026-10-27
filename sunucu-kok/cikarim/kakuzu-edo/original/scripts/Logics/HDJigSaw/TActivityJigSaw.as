package Logics.HDJigSaw
{
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class TActivityJigSaw extends TActivityOSBase
   {
      
      protected var FScore:TActivityJSScore;
      
      protected var FAwards:Vector.<TActivityJSAward>;
      
      protected var FBuys:Vector.<TActivityJSBuy>;
      
      public function TActivityJigSaw()
      {
         super();
      }
      
      public function get Score() : TActivityJSScore
      {
         return this.FScore;
      }
      
      public function set Score(param1:TActivityJSScore) : void
      {
         this.FScore = param1;
      }
      
      public function get Awards() : Vector.<TActivityJSAward>
      {
         return this.FAwards;
      }
      
      public function set Awards(param1:Vector.<TActivityJSAward>) : void
      {
         this.FAwards = param1;
      }
      
      public function get Buys() : Vector.<TActivityJSBuy>
      {
         return this.FBuys;
      }
      
      public function set Buys(param1:Vector.<TActivityJSBuy>) : void
      {
         this.FBuys = param1;
      }
      
      public function GetAwardByIndex(param1:int) : TActivityJSAward
      {
         if(this.FAwards != null && this.FAwards.length > 0)
         {
            return this.FAwards[param1];
         }
         return null;
      }
      
      public function GetAwardByUniqueIndex(param1:uint) : TActivityJSAward
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.FAwards == null)
         {
            return null;
         }
         _loc3_ = int(this.FAwards.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FAwards[_loc2_].Index == param1)
            {
               return this.FAwards[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function SetDataByUIndex(param1:uint, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param1 == this.FScore.Index)
         {
            this.FScore.Score = param2;
            return;
         }
         _loc4_ = int(this.FAwards.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(param1 == this.FAwards[_loc3_].Index)
            {
               this.FAwards[_loc3_].Status = param2;
               return;
            }
            _loc3_++;
         }
      }
   }
}

