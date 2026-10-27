package ghostcat.util
{
   import flash.display.DisplayObjectContainer;
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import ghostcat.debug.Debug;
   
   public class ReflectUtil
   {
      
      private static var describeTypeCache:Dictionary = new Dictionary(true);
      
      public var xml:XML;
      
      public var methods:Array;
      
      public var propertys:Array;
      
      public var propertysAccess:Object;
      
      public var propertysType:Object;
      
      public var metaDatas:Object;
      
      public function ReflectUtil(param1:*)
      {
         var _loc2_:Object = null;
         var _loc3_:XML = null;
         var _loc4_:String = null;
         super();
         param1 = getClass(param1);
         describeTypeCache[param1] = this;
         this.xml = describeType(param1);
         this.metaDatas = {};
         _loc2_ = this.parseMetaData(this.xml.factory[0].metadata);
         if(_loc2_)
         {
            this.metaDatas["this"] = _loc2_;
         }
         this.methods = [];
         for each(_loc3_ in this.xml..method)
         {
            _loc4_ = _loc3_.@name.toString();
            this.methods.push(_loc4_);
         }
         this.propertys = [];
         this.propertysAccess = {};
         this.propertysType = {};
         for each(_loc3_ in this.xml..accessor)
         {
            _loc4_ = _loc3_.@name.toString();
            this.propertys.push(_loc4_);
            this.propertysAccess[_loc4_] = _loc3_.@access.toString();
            this.propertysType[_loc4_] = getDefinitionByName(_loc3_.@type);
            _loc2_ = this.parseMetaData(_loc3_.metadata);
            if(_loc2_)
            {
               this.metaDatas[_loc4_] = _loc2_;
            }
         }
         for each(_loc3_ in this.xml..variable)
         {
            _loc4_ = _loc3_.@name.toString();
            this.propertys.push(_loc4_);
            this.propertysType[_loc4_] = getDefinitionByName(_loc3_.@type);
            _loc2_ = this.parseMetaData(_loc3_.metadata);
            if(_loc2_)
            {
               this.metaDatas[_loc4_] = _loc2_;
            }
         }
      }
      
      public static function cacheDescribeTypes(param1:Array) : void
      {
         var _loc2_:* = undefined;
         for each(_loc2_ in param1)
         {
            getDescribeTypeCache(_loc2_);
         }
      }
      
      public static function getDescribeTypeCache(param1:*) : ReflectUtil
      {
         param1 = getClass(param1);
         var _loc2_:ReflectUtil = describeTypeCache[param1];
         if(!_loc2_)
         {
            _loc2_ = new ReflectUtil(param1);
         }
         return _loc2_;
      }
      
      public static function getDescribeType(param1:*) : XML
      {
         return getDescribeTypeCache(param1).xml;
      }
      
      public static function clearDescribeTypeCache(param1:* = null) : void
      {
         if(param1)
         {
            delete describeTypeCache[param1];
         }
         else
         {
            describeTypeCache = new Dictionary(true);
         }
      }
      
      public static function getMethodList(param1:*) : Object
      {
         var _loc4_:String = null;
         var _loc2_:ReflectUtil = getDescribeTypeCache(param1);
         var _loc3_:Object = {};
         for each(_loc4_ in _loc2_.methods)
         {
            _loc3_[_loc4_] = param1[_loc4_];
         }
         return _loc3_;
      }
      
      public static function getPropertyList(param1:*, param2:Boolean = false) : Object
      {
         var _loc5_:String = null;
         var _loc3_:ReflectUtil = getDescribeTypeCache(param1);
         var _loc4_:Object = {};
         for each(_loc5_ in _loc3_.propertys)
         {
            if(param1.hasOwnProperty(_loc5_))
            {
               if(!param2 || _loc3_.propertysAccess[_loc5_] != "readonly")
               {
                  _loc4_[_loc5_] = param1[_loc5_];
               }
            }
         }
         return _loc4_;
      }
      
      public static function getTypeByProperty(param1:*, param2:String) : Class
      {
         return getDescribeTypeCache(param1).propertysType[param2] as Class;
      }
      
      public static function getPropertyTypeList(param1:*, param2:Boolean = false, param3:Boolean = false) : Object
      {
         var _loc5_:Object = null;
         var _loc6_:* = undefined;
         var _loc4_:ReflectUtil = getDescribeTypeCache(param1);
         if(param2)
         {
            _loc5_ = {};
            for(_loc6_ in _loc4_.propertysType)
            {
               if(_loc4_.propertysAccess[_loc6_] != "readonly")
               {
                  _loc5_[_loc6_] = _loc4_.propertysType[_loc6_];
               }
            }
            return _loc5_;
         }
         if(param3)
         {
            _loc5_ = {};
            for(_loc6_ in _loc4_.propertysType)
            {
               if(_loc4_.propertysAccess[_loc6_] != "writeonly")
               {
                  _loc5_[_loc6_] = _loc4_.propertysType[_loc6_];
               }
            }
            return _loc5_;
         }
         return _loc4_.propertys;
      }
      
      public static function eval(param1:String, param2:Object = null) : *
      {
         var paths:Array;
         var li:int = 0;
         var path:String = null;
         var num:Number = NaN;
         var value:String = param1;
         var root:Object = param2;
         var si:int = value.indexOf("::");
         if(si != -1)
         {
            li = value.indexOf(".",si);
            if(li == -1)
            {
               li = value.length;
            }
            root = getDefinitionByName(value.substr(0,li));
            value = value.substr(li);
         }
         paths = value.split(/\[|\]|\./);
         try
         {
            if(value.charAt(0) > "A" && value.charAt(0) < "Z")
            {
               root = getDefinitionByName(paths.shift());
            }
            for each(path in paths)
            {
               if(!root)
               {
                  return null;
               }
               if(path != "")
               {
                  num = Number(path);
                  if(isNaN(num))
                  {
                     root = root[path];
                  }
                  else
                  {
                     root = root is DisplayObjectContainer ? root.getChildAt(int(num)) : root[num];
                  }
               }
            }
         }
         catch(e:Error)
         {
            Debug.trace("REF","反射失败！ReflectManager.eval() " + e.message);
            return null;
         }
         return root;
      }
      
      public static function getDefinitionByName(param1:String) : Class
      {
         var name:String = param1;
         if(name == "*")
         {
            name = "Object";
         }
         try
         {
            return flash.utils.getDefinitionByName(name) as Class;
         }
         catch(e:ReferenceError)
         {
            Debug.trace("REF","反射类" + name + "失败！");
         }
         return null;
      }
      
      public static function getMetaData(param1:*, param2:String = null, param3:String = null) : XML
      {
         var prop:XML = null;
         var obj:* = param1;
         var property:String = param2;
         var metaName:String = param3;
         var xml:XML = getDescribeType(obj);
         if(property == null)
         {
            prop = xml.factory[0];
         }
         else
         {
            prop = xml..*.(hasOwnProperty("@name") && @name == property)[0];
         }
         if(prop)
         {
            if(metaName)
            {
               return prop.metadata.(@name == metaName)[0];
            }
            return prop.metadata[0];
         }
         return null;
      }
      
      public static function getMetaDataObject(param1:*, param2:String = null, param3:String = null) : Object
      {
         var _loc5_:Object = null;
         var _loc4_:ReflectUtil = getDescribeTypeCache(param1);
         _loc5_ = _loc4_.metaDatas[param2 ? param2 : "this"];
         if(!param3)
         {
            return _loc5_;
         }
         return _loc5_ ? _loc5_[param3] : null;
      }
      
      public static function getClass(param1:*) : Class
      {
         if(param1 == null)
         {
            return null;
         }
         if(param1 is String)
         {
            return getDefinitionByName(param1) as Class;
         }
         if(param1 is Class)
         {
            return param1;
         }
         return param1["constructor"] as Class;
      }
      
      public static function getQName(param1:*) : QName
      {
         var _loc2_:Array = getQualifiedClassName(param1).split("::");
         if(_loc2_.length == 2)
         {
            return new QName(_loc2_[0],_loc2_[1]);
         }
         return new QName(null,_loc2_[0]);
      }
      
      private function parseMetaData(param1:XMLList) : Object
      {
         var _loc2_:Object = null;
         var _loc3_:XML = null;
         var _loc4_:Object = null;
         var _loc5_:XML = null;
         for each(_loc3_ in param1)
         {
            if(!_loc2_)
            {
               _loc2_ = {};
            }
            _loc4_ = {};
            for each(_loc5_ in _loc3_.*)
            {
               _loc4_[_loc5_.@key.toString()] = _loc5_.@value.toString();
            }
            _loc2_[_loc3_.@name.toString()] = _loc4_;
         }
         return _loc2_;
      }
   }
}

