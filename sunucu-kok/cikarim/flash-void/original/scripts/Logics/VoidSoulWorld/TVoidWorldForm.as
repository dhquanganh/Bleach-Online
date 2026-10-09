package Logics.VoidSoulWorld
{
   import Logics.VoidSoulWorld.VO.TFormHeroVO;
   
   public class TVoidWorldForm
   {
      
      protected var FHeros:Vector.<TFormHeroVO>;
      
      protected var FSpecialHeroID:Vector.<uint>;
      
      public function TVoidWorldForm()
      {
         super();
         this.FHeros = new Vector.<TFormHeroVO>();
         this.FSpecialHeroID = new Vector.<uint>();
      }
      
      public function get Heros() : Vector.<TFormHeroVO>
      {
         return this.FHeros;
      }
      
      public function get SpecialHeroID() : Vector.<uint>
      {
         return this.FSpecialHeroID;
      }
      
      public function GetHeroByID(param1:uint) : TFormHeroVO
      {
         var _loc2_:TFormHeroVO = null;
         for each(_loc2_ in this.FHeros)
         {
            if(_loc2_.HeroID == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
   }
}

