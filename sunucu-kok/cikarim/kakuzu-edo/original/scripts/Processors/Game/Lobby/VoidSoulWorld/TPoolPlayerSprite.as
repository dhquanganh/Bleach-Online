package Processors.Game.Lobby.VoidSoulWorld
{
   import flash.utils.Dictionary;
   
   public class TPoolPlayerSprite
   {
      
      protected static var FPlayers:Dictionary;
      
      public function TPoolPlayerSprite()
      {
         super();
      }
      
      protected static function CreatePool() : void
      {
         FPlayers = new Dictionary();
         FPlayers["4_1_up"] = new Vector.<TPlayerSprite>();
         FPlayers["4_1_down"] = new Vector.<TPlayerSprite>();
         FPlayers["4_0_up"] = new Vector.<TPlayerSprite>();
         FPlayers["4_0_down"] = new Vector.<TPlayerSprite>();
         FPlayers["1_1_up"] = new Vector.<TPlayerSprite>();
         FPlayers["1_1_down"] = new Vector.<TPlayerSprite>();
         FPlayers["1_0_up"] = new Vector.<TPlayerSprite>();
         FPlayers["1_0_down"] = new Vector.<TPlayerSprite>();
         FPlayers["3_1_up"] = new Vector.<TPlayerSprite>();
         FPlayers["3_1_down"] = new Vector.<TPlayerSprite>();
         FPlayers["3_0_up"] = new Vector.<TPlayerSprite>();
         FPlayers["3_0_down"] = new Vector.<TPlayerSprite>();
      }
      
      public static function Get(param1:String) : TPlayerSprite
      {
         var _loc2_:Vector.<TPlayerSprite> = null;
         var _loc3_:TPlayerSprite = null;
         if(FPlayers == null)
         {
            CreatePool();
         }
         _loc2_ = FPlayers[param1];
         if(FPlayers.length > 0)
         {
            return FPlayers.pop();
         }
         _loc3_ = new TPlayerSprite(param1);
         _loc3_.UIDispatch();
         return _loc3_;
      }
      
      public static function Recover(param1:TPlayerSprite) : void
      {
         var _loc2_:Vector.<TPlayerSprite> = null;
         if(FPlayers == null)
         {
            CreatePool();
         }
         param1.Reset();
         _loc2_ = FPlayers[param1.Key];
         _loc2_.push(param1);
      }
   }
}

