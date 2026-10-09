package Logics.ProfessionRefine
{
   import Logics.DatebaseVO.VO.TProfessionRefineAVO;
   
   public class TProfessionRefine
   {
      
      private var FHeroType:int;
      
      private var FCurLevel:int;
      
      private var FFuncGetAVO:Function;
      
      private var FMaxLevel:int;
      
      public function TProfessionRefine()
      {
         super();
      }
      
      public function get HeroType() : int
      {
         return this.FHeroType;
      }
      
      public function set HeroType(param1:int) : void
      {
         this.FHeroType = param1;
      }
      
      public function get CurLevel() : int
      {
         return this.FCurLevel;
      }
      
      public function set CurLevel(param1:int) : void
      {
         this.FCurLevel = param1;
      }
      
      public function set FuncGetAVO(param1:Function) : void
      {
         this.FFuncGetAVO = param1;
      }
      
      public function set MaxLevel(param1:int) : void
      {
         this.FMaxLevel = param1;
      }
      
      public function get CurLevelAVO() : TProfessionRefineAVO
      {
         if(this.FCurLevel == 0)
         {
            return null;
         }
         return this.FFuncGetAVO(this.FCurLevel);
      }
      
      public function get NextLevelAVO() : TProfessionRefineAVO
      {
         if(this.FCurLevel == this.FMaxLevel)
         {
            return null;
         }
         return this.FFuncGetAVO(this.FCurLevel + 1);
      }
      
      public function get IsMax() : Boolean
      {
         return this.FCurLevel == this.FMaxLevel;
      }
   }
}

