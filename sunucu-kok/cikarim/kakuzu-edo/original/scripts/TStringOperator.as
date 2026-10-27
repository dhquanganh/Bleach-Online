package
{
   import Foundation.Utilities.TUtilityString;
   import Localization.Strings.TStringOperation;
   
   public class TStringOperator
   {
      
      public function TStringOperator()
      {
         super();
      }
      
      public static function IndexLeft(param1:TStringOperation) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1.Index;
         if(_loc2_ > 0)
         {
            _loc2_--;
         }
         else
         {
            _loc2_ = 0;
         }
         param1.Index = _loc2_;
      }
      
      public static function IndexRight(param1:TStringOperation) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         _loc3_ = param1.Index;
         _loc4_ = param1.Text;
         if(TUtilityString.Empty(_loc4_))
         {
            return;
         }
         _loc2_ = _loc4_.length;
         if(_loc3_ < _loc2_)
         {
            _loc3_ += 1;
         }
         else
         {
            _loc3_ = _loc2_;
         }
         param1.Index = _loc3_;
      }
      
      public static function StringDelete(param1:TStringOperation) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         _loc5_ = param1.Index;
         _loc6_ = param1.Text;
         if(TUtilityString.Empty(_loc6_))
         {
            return;
         }
         _loc2_ = _loc6_.length;
         if(_loc5_ < _loc2_)
         {
            _loc3_ = _loc6_.substr(0,_loc5_);
            _loc4_ = _loc6_.substr(_loc5_ + 1,_loc2_);
            _loc6_ = _loc3_ + _loc4_;
         }
         param1.Text = _loc6_;
      }
      
      public static function StringBackspace(param1:TStringOperation) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         _loc5_ = param1.Index;
         _loc6_ = param1.Text;
         if(TUtilityString.Empty(_loc6_))
         {
            return;
         }
         _loc2_ = _loc6_.length;
         if(_loc5_ > 0)
         {
            _loc3_ = _loc6_.substr(0,_loc5_ - 1);
            _loc4_ = _loc6_.substr(_loc5_,_loc2_);
            _loc6_ = _loc3_ + _loc4_;
            _loc5_--;
         }
         param1.Text = _loc6_;
         param1.Index = _loc5_;
      }
      
      public static function StringInsert(param1:TStringOperation, param2:String, param3:int = 0) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(TUtilityString.Empty(param2))
         {
            return;
         }
         _loc5_ = param1.Text;
         _loc6_ = param1.Index;
         _loc7_ = _loc5_.length;
         if(param3 > 0)
         {
            param2 = param2.substr(0,param3);
         }
         if(_loc6_ >= _loc7_)
         {
            _loc6_ = _loc7_;
            _loc4_ = _loc5_ + param2;
         }
         else
         {
            _loc4_ = _loc5_.substr(0,_loc6_) + param2 + _loc5_.substr(_loc6_);
         }
         param1.Text = _loc4_;
         param1.Index = _loc6_ + param2.length;
      }
   }
}

