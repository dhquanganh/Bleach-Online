package Foundation.Display
{
   import flash.display.*;
   import flash.geom.*;
   
   public class TZoom9Grid
   {
      
      protected var FData:*;
      
      protected var FWidth:int;
      
      protected var FHeight:int;
      
      protected var FScaleX:Number;
      
      protected var FScaleY:Number;
      
      protected var FGridRect:Rectangle;
      
      protected var FIsNeedUpdate:Boolean;
      
      protected var FImageData:BitmapData;
      
      public function TZoom9Grid(param1:IBitmapDrawable, param2:Rectangle = null)
      {
         super();
         this.FData = param1;
         this.FGridRect = param2;
         this.FWidth = this.FData.width;
         this.FHeight = this.FData.height;
         this.FScaleX = 1;
         this.FScaleY = 1;
         this.FIsNeedUpdate = true;
      }
      
      public function get ImageBitmap() : Bitmap
      {
         if(this.FIsNeedUpdate)
         {
            this.Update();
         }
         return new Bitmap(this.FImageData);
      }
      
      public function get ImageData() : BitmapData
      {
         if(this.FIsNeedUpdate)
         {
            this.Update();
         }
         return this.FImageData;
      }
      
      public function set GridRect(param1:Rectangle) : void
      {
         this.FIsNeedUpdate = true;
         if(!param1)
         {
            param1 = new Rectangle();
         }
         this.FGridRect = param1;
      }
      
      public function get GridRect() : Rectangle
      {
         return this.FGridRect;
      }
      
      public function set Width(param1:int) : void
      {
         if(param1 == this.FWidth)
         {
            return;
         }
         this.FIsNeedUpdate = true;
         this.FWidth = param1;
      }
      
      public function get Width() : int
      {
         return this.FWidth;
      }
      
      public function set Height(param1:int) : void
      {
         if(param1 == this.FHeight)
         {
            return;
         }
         this.FIsNeedUpdate = true;
         this.FHeight = param1;
      }
      
      public function get Height() : int
      {
         return this.FHeight;
      }
      
      public function set ScaleX(param1:Number) : void
      {
         if(param1 == this.FScaleX)
         {
            return;
         }
         this.FIsNeedUpdate = true;
         this.FScaleX = param1;
      }
      
      public function get ScaleX() : Number
      {
         return this.FScaleX;
      }
      
      public function set ScaleY(param1:Number) : void
      {
         if(param1 == this.FScaleY)
         {
            return;
         }
         this.FIsNeedUpdate = true;
         this.FScaleY = param1;
      }
      
      public function get ScaleY() : Number
      {
         return this.FScaleY;
      }
      
      public function set Source(param1:IBitmapDrawable) : void
      {
         this.FData = param1;
         this.FWidth = this.FData.width;
         this.FHeight = this.FData.height;
      }
      
      public function Update() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:Rectangle = null;
         var _loc8_:Matrix = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         this.FIsNeedUpdate = false;
         _loc1_ = this.FWidth * this.FScaleX;
         _loc2_ = this.FHeight * this.FScaleY;
         this.FImageData = new BitmapData(_loc1_,_loc2_,true,0);
         if(this.FData.width == _loc1_ && this.FData.height == _loc2_)
         {
            this.FImageData.draw(this.FData);
         }
         else
         {
            _loc3_ = [0,this.FGridRect.top,this.FGridRect.bottom,this.FData.height];
            _loc4_ = [0,this.FGridRect.left,this.FGridRect.right,this.FData.width];
            _loc5_ = [0,this.FGridRect.top,_loc2_ - this.FData.height + this.FGridRect.bottom,_loc2_];
            _loc6_ = [0,this.FGridRect.left,_loc1_ - this.FData.width + this.FGridRect.right,_loc1_];
            _loc10_ = 0;
            while(_loc10_ < 3)
            {
               _loc9_ = 0;
               while(_loc9_ < 3)
               {
                  _loc13_ = int(_loc3_[_loc9_]);
                  _loc14_ = int(_loc3_[_loc9_ + 1]);
                  _loc15_ = int(_loc4_[_loc10_]);
                  _loc16_ = int(_loc4_[_loc10_ + 1]);
                  _loc17_ = int(_loc5_[_loc9_]);
                  _loc18_ = int(_loc5_[_loc9_ + 1]);
                  _loc19_ = int(_loc6_[_loc10_]);
                  _loc20_ = int(_loc6_[_loc10_ + 1]);
                  _loc7_ = new Rectangle(_loc19_,_loc17_,_loc20_ - _loc19_,_loc18_ - _loc17_);
                  _loc11_ = _loc10_ == 1 ? _loc7_.width / (_loc16_ - _loc15_) : 1;
                  _loc12_ = _loc9_ == 1 ? _loc7_.height / (_loc14_ - _loc13_) : 1;
                  _loc8_ = new Matrix(_loc11_,0,0,_loc12_,_loc19_ - _loc15_ * _loc11_,_loc17_ - _loc13_ * _loc12_);
                  this.FImageData.draw(this.FData,_loc8_,null,null,_loc7_,true);
                  _loc9_++;
               }
               _loc10_++;
            }
         }
      }
      
      public function Dispose() : void
      {
         if(this.FData != null)
         {
            (this.FData as BitmapData).dispose();
            this.FData = null;
         }
         if(this.FImageData != null)
         {
            this.FImageData.dispose();
            this.FImageData = null;
         }
      }
      
      public function Reset() : void
      {
         if(this.FImageData != null)
         {
            this.FImageData.dispose();
            this.FImageData = null;
         }
      }
   }
}

