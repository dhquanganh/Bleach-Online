package Processors.Game.Lobby.Activity.HDChristmas2015.Components
{
   public class TSledModelPool
   {
      
      private static const FPool:Vector.<TSledModel> = new Vector.<TSledModel>();
      
      public function TSledModelPool()
      {
         super();
      }
      
      public static function GetObj() : TSledModel
      {
         var _loc1_:TSledModel = null;
         if(FPool.length > 0)
         {
            _loc1_ = FPool.pop();
         }
         else
         {
            _loc1_ = new TSledModel();
            _loc1_.UIDispatch();
         }
         _loc1_.playEffect();
         return _loc1_;
      }
      
      public static function RelObj(param1:TSledModel) : void
      {
         param1.stopEffect();
         FPool.push(param1);
      }
   }
}

