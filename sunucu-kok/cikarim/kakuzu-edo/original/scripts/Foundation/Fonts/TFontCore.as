package Foundation.Fonts
{
   import Debugging.*;
   import flash.text.*;
   
   public class TFontCore
   {
      
      protected var FFontsName:Vector.<String>;
      
      protected var FFontsEmbedded:Vector.<Boolean>;
      
      public function TFontCore()
      {
         super();
         this.FFontsName = new Vector.<String>();
         this.FFontsEmbedded = new Vector.<Boolean>();
         this.FontsEnumerate();
      }
      
      protected static function FontSortRoutine(param1:Font, param2:Font) : int
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         _loc3_ = param1.fontName;
         _loc4_ = param2.fontName;
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      protected function FontsEnumerate() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Font = null;
         _loc1_ = Font.enumerateFonts(true);
         _loc1_.sort(FontSortRoutine);
         this.FFontsName.length = 0;
         _loc2_ = int(_loc1_.length);
         this.FFontsName.length = _loc2_;
         this.FFontsEmbedded.length = _loc2_;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = _loc1_[_loc3_];
            this.FFontsName[_loc3_] = _loc4_.fontName;
            this.FFontsEmbedded[_loc3_] = _loc4_.fontType != FontType.DEVICE;
            _loc3_++;
         }
      }
      
      public function InitFont() : void
      {
         this.FontsEnumerate();
      }
      
      public function FontAvailable(param1:String) : Boolean
      {
         var _loc2_:int = 0;
         _loc2_ = this.FFontsName.indexOf(param1);
         return _loc2_ >= 0;
      }
      
      public function FontEmbedded(param1:String) : Boolean
      {
         var _loc2_:int = 0;
         _loc2_ = this.FFontsName.indexOf(param1);
         if(_loc2_ < 0)
         {
            return false;
         }
         return this.FFontsEmbedded[_loc2_];
      }
      
      public function FontSelect(param1:TFont, param2:Array, param3:Array = null, param4:Array = null) : int
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:Boolean = false;
         _loc5_ = int(param2.length);
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = param2[_loc6_];
            if(this.FontAvailable(_loc7_))
            {
               break;
            }
            _loc6_++;
         }
         if(_loc6_ >= _loc5_)
         {
            return -1;
         }
         param1.Name = _loc7_;
         if(param3 != null)
         {
            _loc8_ = int(param3[_loc6_]);
            if(_loc8_ > 0)
            {
               param1.Size = _loc8_;
            }
         }
         if(param4 != null)
         {
            _loc9_ = Boolean(param4[_loc6_]);
            param1.Bold = _loc9_;
         }
         return _loc6_;
      }
   }
}

