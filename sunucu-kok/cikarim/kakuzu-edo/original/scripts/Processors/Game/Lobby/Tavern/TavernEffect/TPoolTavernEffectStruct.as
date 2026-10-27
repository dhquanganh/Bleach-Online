package Processors.Game.Lobby.Tavern.TavernEffect
{
   public class TPoolTavernEffectStruct
   {
      
      protected static var FTavernEffectStructVect:Vector.<TTavernEffectStruct> = new Vector.<TTavernEffectStruct>();
      
      public function TPoolTavernEffectStruct()
      {
         super();
      }
      
      public static function GetTavernEffectStruct() : TTavernEffectStruct
      {
         var _loc1_:TTavernEffectStruct = null;
         if(FTavernEffectStructVect.length > 0)
         {
            _loc1_ = FTavernEffectStructVect.pop();
         }
         else
         {
            _loc1_ = new TTavernEffectStruct();
         }
         return _loc1_;
      }
      
      public static function SaveTavernEffectStruct(param1:TTavernEffectStruct) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(FTavernEffectStructVect.indexOf(param1) >= 0)
         {
            return;
         }
         FTavernEffectStructVect.push(param1);
      }
   }
}

