package Foundation.Utilities
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.system.ApplicationDomain;
   import flash.utils.getQualifiedClassName;
   
   public class TUtilityReflection
   {
      
      public function TUtilityReflection()
      {
         super();
         throw new Error("TUtilityReflection Class Is Static Container Only");
      }
      
      protected static function SetMcAction(param1:DisplayObject) : void
      {
         var _loc3_:MovieClip = null;
         var _loc2_:* = 0;
         if(param1 == null)
         {
            return;
         }
         if(param1 is MovieClip)
         {
            _loc3_ = param1 as MovieClip;
            _loc3_.tabEnabled = false;
            _loc3_.stop();
            while(_loc2_ < _loc3_.numChildren)
            {
               SetMcAction(_loc3_.getChildAt(_loc2_++));
            }
            return;
         }
      }
      
      public static function CreateDisplayObjectInstance(param1:String, param2:ApplicationDomain = null) : DisplayObject
      {
         var _loc3_:DisplayObject = null;
         _loc3_ = CreateInstance(param1,param2) as DisplayObject;
         SetMcAction(_loc3_);
         return _loc3_;
      }
      
      public static function CreateBitmapByDisplayObject(param1:String) : Bitmap
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:BitmapData = null;
         var _loc4_:Bitmap = null;
         _loc2_ = CreateDisplayObjectInstance(param1);
         _loc3_ = new BitmapData(_loc2_.width,_loc2_.height,true,16777215);
         _loc3_.draw(_loc2_);
         return new Bitmap(_loc3_);
      }
      
      public static function CreateBitmapDataByDisplayObject(param1:String) : BitmapData
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:BitmapData = null;
         var _loc4_:Bitmap = null;
         _loc2_ = CreateDisplayObjectInstance(param1);
         _loc3_ = new BitmapData(_loc2_.width,_loc2_.height,true,16777215);
         _loc3_.draw(_loc2_);
         return _loc3_;
      }
      
      public static function CreateSimpleButtonByDisplayObject(param1:String) : SimpleButton
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:DisplayObject = null;
         var _loc5_:MovieClip = null;
         var _loc6_:SimpleButton = null;
         _loc4_ = CreateDisplayObjectInstance(param1);
         if(_loc4_ is MovieClip)
         {
            _loc5_ = _loc4_ as MovieClip;
            _loc3_ = _loc5_.numChildren;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               if(_loc5_.getChildAt(_loc2_) is SimpleButton)
               {
                  _loc6_ = _loc5_.getChildAt(_loc2_) as SimpleButton;
                  _loc6_.tabEnabled = false;
                  break;
               }
               _loc2_++;
            }
         }
         _loc4_ = null;
         return _loc6_;
      }
      
      public static function CreateInstance(param1:String, param2:ApplicationDomain = null) : *
      {
         var _loc3_:Class = null;
         _loc3_ = GetClass(param1,param2);
         if(_loc3_ != null)
         {
            return new _loc3_();
         }
         return null;
      }
      
      public static function GetClass(param1:String, param2:ApplicationDomain = null) : Class
      {
         var AssetClass:Class = null;
         var FullClassName:String = param1;
         var AppDomain:ApplicationDomain = param2;
         if(AppDomain == null)
         {
            AppDomain = ApplicationDomain.currentDomain;
         }
         try
         {
            AssetClass = AppDomain.getDefinition(FullClassName) as Class;
         }
         catch(e:Error)
         {
         }
         return AssetClass;
      }
      
      public static function GetFullClassName(param1:*) : String
      {
         return getQualifiedClassName(param1);
      }
      
      public static function GetClassName(param1:*) : String
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         _loc2_ = GetFullClassName(param1);
         _loc3_ = _loc2_.lastIndexOf(".");
         if(_loc3_ >= 0)
         {
            _loc2_ = _loc2_.substr(_loc3_ + 1);
         }
         return _loc2_;
      }
      
      public static function GetPackageName(param1:*) : String
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         _loc2_ = GetFullClassName(param1);
         _loc3_ = _loc2_.lastIndexOf(".");
         if(_loc3_ >= 0)
         {
            return _loc2_.substring(0,_loc3_);
         }
         return "";
      }
   }
}

