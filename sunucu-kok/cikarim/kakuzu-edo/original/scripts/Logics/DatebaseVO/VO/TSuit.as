package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import flash.utils.ByteArray;
   import ghostcat.util.data.*;
   
   use namespace ResourcesSpace;
   
   public class TSuit extends TDatebaseVO
   {
      
      protected static const KEY_01:String = "2";
      
      protected static const KEY_02:String = "4";
      
      protected static const KEY_03:String = "6";
      
      protected static const KEYS:Vector.<String> = Vector.<String>([KEY_01,KEY_02,KEY_03]);
      
      protected var FName:String;
      
      protected var FMaxCount:uint;
      
      protected var FSuitEffects:Vector.<TSuitEffect>;
      
      protected var FSEffect:String;
      
      public function TSuit()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc8_:TSuitEffect = null;
         this.FName = TUtilityString.FetchUTF(param1);
         this.FMaxCount = param1.readUnsignedInt();
         this.FSEffect = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(this.FSEffect);
         _loc3_ = int(KEYS.length);
         this.FSuitEffects = new Vector.<TSuitEffect>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = KEYS[_loc2_];
            _loc7_ = _loc4_[_loc6_] as Array;
            if(_loc7_ != null)
            {
               _loc8_ = new TSuitEffect(_loc6_,_loc7_);
               this.FSuitEffects[_loc2_] = _loc8_;
            }
            _loc2_++;
         }
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get MaxCount() : uint
      {
         return this.FMaxCount;
      }
      
      public function get SuitEffects() : Vector.<TSuitEffect>
      {
         return this.FSuitEffects;
      }
      
      public function get SEffect() : String
      {
         return this.FSEffect;
      }
   }
}

