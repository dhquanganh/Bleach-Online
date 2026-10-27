package Processors.Game.Battle.GoneWord
{
   public class TPoolEffectGoneWord
   {
      
      protected static var FPoolGoneWord:Vector.<TGoneWord> = new Vector.<TGoneWord>();
      
      protected static var FPoolGoneWordWithBg:Vector.<TGoneWord> = new Vector.<TGoneWord>();
      
      public function TPoolEffectGoneWord()
      {
         super();
      }
      
      public static function GetGoneWord() : TGoneWord
      {
         var _loc1_:TGoneWord = null;
         if(FPoolGoneWord.length > 0)
         {
            _loc1_ = FPoolGoneWord.pop();
         }
         else
         {
            _loc1_ = new TGoneWord(null);
            _loc1_.mouseChildren = false;
            _loc1_.mouseEnabled = false;
         }
         return _loc1_;
      }
      
      public static function SaveGoneWord(param1:TGoneWord) : void
      {
         var _loc2_:int = 0;
         if(param1 == null)
         {
            return;
         }
         if(param1.parent)
         {
            param1.parent.removeChild(param1);
         }
         param1.ResetGoneWord();
         _loc2_ = FPoolGoneWord.indexOf(param1);
         if(_loc2_ >= 0)
         {
            return;
         }
         FPoolGoneWord.push(param1);
      }
      
      public static function GetGoneWordWithBg() : TGoneWord
      {
         var _loc1_:TGoneWord = null;
         if(FPoolGoneWordWithBg.length > 0)
         {
            _loc1_ = FPoolGoneWordWithBg.pop();
         }
         else
         {
            _loc1_ = new TGoneWord(null);
            _loc1_.mouseChildren = false;
            _loc1_.mouseEnabled = false;
         }
         return _loc1_;
      }
      
      public static function SaveGoneWordWithBg(param1:TGoneWord) : void
      {
         var _loc2_:int = 0;
         if(param1 == null)
         {
            return;
         }
         if(param1.parent)
         {
            param1.parent.removeChild(param1);
         }
         param1.ResetGoneWord();
         _loc2_ = FPoolGoneWordWithBg.indexOf(param1);
         if(_loc2_ >= 0)
         {
            return;
         }
         FPoolGoneWordWithBg.push(param1);
      }
   }
}

