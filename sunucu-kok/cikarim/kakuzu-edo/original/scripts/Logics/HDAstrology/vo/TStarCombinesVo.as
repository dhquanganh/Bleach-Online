package Logics.HDAstrology.vo
{
   public class TStarCombinesVo
   {
      
      private var FCombineIndex:int;
      
      private var FCombineTypeVec:Vector.<TSingleCombineVo>;
      
      private var FIsExchange:Boolean;
      
      private var FSoulAmount:int;
      
      public function TStarCombinesVo()
      {
         super();
         this.FCombineTypeVec = new Vector.<TSingleCombineVo>();
      }
      
      public function get CombineIndex() : int
      {
         return this.FCombineIndex;
      }
      
      public function set CombineIndex(param1:int) : void
      {
         this.FCombineIndex = param1;
      }
      
      public function get IsExchange() : Boolean
      {
         return this.FIsExchange;
      }
      
      public function set IsExchange(param1:Boolean) : void
      {
         this.FIsExchange = param1;
      }
      
      public function get SoulAmount() : int
      {
         return this.FSoulAmount;
      }
      
      public function set SoulAmount(param1:int) : void
      {
         this.FSoulAmount = param1;
      }
      
      public function get CombineTypeVec() : Vector.<TSingleCombineVo>
      {
         return this.FCombineTypeVec;
      }
      
      public function set CombineTypeVec(param1:Vector.<TSingleCombineVo>) : void
      {
         this.FCombineTypeVec = param1;
      }
   }
}

