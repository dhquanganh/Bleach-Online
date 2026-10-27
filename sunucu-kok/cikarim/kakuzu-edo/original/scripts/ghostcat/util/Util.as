package ghostcat.util
{
   import flash.net.registerClassAlias;
   import flash.utils.ByteArray;
   import flash.utils.getQualifiedClassName;
   
   public final class Util
   {
      
      public function Util()
      {
         super();
      }
      
      public static function isIn(param1:*, param2:Array) : Boolean
      {
         if(param2 == null)
         {
            return false;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            if(param1 is param2[_loc3_])
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public static function remove(param1:*, param2:*) : void
      {
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         if(param1 is Array)
         {
            _loc3_ = (param1 as Array).indexOf(param2);
            if(_loc3_ != -1)
            {
               (param1 as Array).splice(_loc3_,1);
            }
         }
         else
         {
            for(_loc4_ in param1)
            {
               if(param1[_loc4_] == param2)
               {
                  delete param1[_loc4_];
                  return;
               }
            }
         }
      }
      
      public static function removeXMLNote(param1:XML) : void
      {
         delete param1.parent().*[param1.childIndex()];
      }
      
      public static function unionObject(param1:Object, param2:Object) : Object
      {
         var _loc4_:* = undefined;
         var _loc3_:Object = new Object();
         for(_loc4_ in param1)
         {
            _loc3_[_loc4_] = param1[_loc4_];
         }
         for(_loc4_ in param2)
         {
            _loc3_[_loc4_] = param2[_loc4_];
         }
         return _loc3_;
      }
      
      public static function doAll(param1:Function, param2:Array) : Array
      {
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            _loc3_.push(param1(param2[_loc4_]));
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function createObject(param1:*, param2:Object) : *
      {
         var _loc3_:* = undefined;
         if(param1 is Class)
         {
            param1 = new param1();
         }
         for(_loc3_ in param2)
         {
            param1[_loc3_] = param2[_loc3_];
         }
         return param1;
      }
      
      public static function isEmpty(param1:*) : Boolean
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         var _loc4_:* = param1;
         for(_loc2_ in _loc4_)
         {
            return false;
         }
         return true;
      }
      
      public static function clone(param1:*, param2:Boolean = false, param3:Array = null) : *
      {
         var _loc5_:Class = null;
         if(param2)
         {
            registerClassAlias(getQualifiedClassName(param1),param1["constructor"]);
         }
         if(param3)
         {
            for each(_loc5_ in param3)
            {
               registerClassAlias(getQualifiedClassName(_loc5_),_loc5_);
            }
         }
         var _loc4_:ByteArray = new ByteArray();
         _loc4_.writeObject(param1);
         _loc4_.position = 0;
         return _loc4_.readObject();
      }
      
      public static function copy(param1:*, param2:* = null) : *
      {
         var _loc3_:* = undefined;
         if(!param2)
         {
            param2 = new Object();
         }
         for(_loc3_ in param1)
         {
            param2[_loc3_] = param1[_loc3_];
         }
         return param2;
      }
      
      public static function equal(param1:*, param2:*) : Boolean
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeObject(param1);
         _loc3_.position = 0;
         var _loc4_:ByteArray = new ByteArray();
         _loc4_.writeObject(param2);
         _loc4_.position = 0;
         if(_loc3_.length == _loc4_.length)
         {
            while(_loc3_.bytesAvailable)
            {
               if(_loc3_.readByte() != _loc4_.readByte())
               {
                  return false;
               }
            }
            return true;
         }
         return false;
      }
   }
}

