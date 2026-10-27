package ghostcat.util.core
{
   import flash.errors.IllegalOperationError;
   import flash.utils.describeType;
   import flash.utils.getQualifiedClassName;
   
   public final class AbstractUtil
   {
      
      public function AbstractUtil()
      {
         super();
      }
      
      public static function preventConstructor(param1:*, param2:Class, param3:String = null) : void
      {
         var _loc4_:String = null;
         if(param1["constructor"] == param2)
         {
            if(!param3)
            {
               _loc4_ = getQualifiedClassName(param1);
               param3 = _loc4_ + " 类为抽象类，不允许实例化!";
            }
            throw new IllegalOperationError(param3);
         }
      }
      
      public static function mustBeOverridden(param1:*, param2:Class, param3:Array) : void
      {
         var typeName:String = null;
         var concreteTypeName:String = null;
         var des:XML = null;
         var item:XML = null;
         var methods:XMLList = null;
         var accessors:XMLList = null;
         var obj:* = param1;
         var abstractType:Class = param2;
         var unimplemented:Array = param3;
         typeName = getQualifiedClassName(abstractType);
         concreteTypeName = getQualifiedClassName(obj);
         des = describeType(obj);
         methods = des..method.(@declaredBy == typeName && unimplemented.indexOf(@name.toString()) != -1);
         var _loc5_:int = 0;
         var _loc6_:* = methods;
         for each(item in _loc6_)
         {
            throw new IllegalOperationError("虚方法 " + item.@name + " (位于命名空间 " + typeName + " 中)未由类 " + concreteTypeName + " 实现。");
         }
         accessors = des..accessor.(@declaredBy == typeName && unimplemented.indexOf(@name.toString()) != -1);
         _loc5_ = 0;
         _loc6_ = accessors;
         for each(item in _loc6_)
         {
            throw new IllegalOperationError("存取器 " + item.@name + " (位于命名空间 " + typeName + " 中)未由类 " + concreteTypeName + " 实现。");
         }
      }
   }
}

