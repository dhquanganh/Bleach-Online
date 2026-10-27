package Logics.HDChristmas2015.VO
{
   public class TSledVOPool
   {
      
      private static const FPool:Vector.<TSledVO> = new Vector.<TSledVO>();
      
      public function TSledVOPool()
      {
         super();
      }
      
      public static function GetObj() : TSledVO
      {
         var _loc1_:TSledVO = null;
         if(FPool.length > 0)
         {
            return FPool.pop();
         }
         return new TSledVO();
      }
      
      public static function RelObj(param1:TSledVO) : void
      {
         FPool.push(param1);
      }
   }
}

