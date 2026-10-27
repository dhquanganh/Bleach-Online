package Components.Shortcuts
{
   import Foundation.Display.TZoom9Grid;
   import Foundation.Resources.Textures.TAnimationFrame;
   import Foundation.UI.TUIComponent;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.SimpleButton;
   import flash.geom.Rectangle;
   
   public class TUIShortcut9Grid extends TUIShortcut
   {
      
      protected const MarginLeft:int = 10;
      
      protected const MarginTop:int = 10;
      
      protected const ColSpace:int = 20;
      
      protected const RowSpace:int = 20;
      
      protected var FUI9Grid:TZoom9Grid;
      
      protected var FUI9GridBtm:Bitmap;
      
      protected var FFilterBtns:Vector.<SimpleButton>;
      
      protected var FFilterEffects:Vector.<Bitmap>;
      
      protected var FIconWidth:uint;
      
      protected var FIconHeight:uint;
      
      public function TUIShortcut9Grid(param1:TUIComponent)
      {
         super(param1);
         this.FUI9Grid = new TZoom9Grid(new BitmapData(1,1));
         this.FUI9Grid.GridRect = new Rectangle(25,25,25,25);
         this.FUI9GridBtm = new Bitmap();
         FSubstrate.addChild(this.FUI9GridBtm);
         this.FFilterBtns = new Vector.<SimpleButton>();
         this.FFilterEffects = new Vector.<Bitmap>();
         this.FIconWidth = 70;
         this.FIconHeight = 74;
      }
      
      protected function UpdateGrid(param1:int, param2:int) : void
      {
         this.FUI9Grid.Width = param1;
         this.FUI9Grid.Height = param2;
         if(this.FUI9GridBtm.bitmapData != this.FUI9Grid.ImageData)
         {
            if(this.FUI9GridBtm.bitmapData != null)
            {
               this.FUI9GridBtm.bitmapData.dispose();
            }
            this.FUI9GridBtm.bitmapData = this.FUI9Grid.ImageData;
         }
      }
      
      override protected function Resources_UILocations() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Bitmap = null;
         var _loc4_:SimpleButton = null;
         _loc2_ = int(FCapacity);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new Bitmap();
            FSubstrate.addChild(_loc3_);
            FLayerEffects[_loc1_] = _loc3_;
            FIsEffects[_loc1_] = false;
            _loc4_ = FButtons[_loc1_];
            if(_loc4_ != null)
            {
               _loc4_.tabIndex = _loc1_;
               FSubstrate.addChild(_loc4_);
               addEventListenerPlayer(_loc4_);
            }
            _loc1_++;
         }
      }
      
      override protected function UpdateLocation() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:SimpleButton = null;
         var _loc7_:Bitmap = null;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:TAnimationFrame = null;
         if(FEffects != null)
         {
            _loc14_ = FEffects.GetAnimationFrameByIndex(0);
            _loc10_ = _loc14_.Surface.width;
            _loc11_ = _loc14_.Surface.height;
         }
         this.FilterIcon();
         _loc1_ = 0;
         _loc2_ = 0;
         _loc8_ = this.FFilterBtns.length;
         if(_loc8_ == 0)
         {
            return;
         }
         do
         {
            _loc1_++;
            _loc2_ = Math.ceil(_loc8_ / _loc1_);
            _loc3_ = 0;
            while(_loc3_ < _loc1_)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc2_)
               {
                  _loc9_ = _loc3_ * _loc2_ + _loc4_;
                  if(_loc9_ < _loc8_)
                  {
                     _loc6_ = this.FFilterBtns[_loc9_];
                     _loc7_ = this.FFilterEffects[_loc9_];
                     _loc6_.x = this.MarginLeft + _loc4_ * (this.FIconWidth + this.ColSpace);
                     _loc6_.y = this.MarginTop + _loc3_ * (this.FIconHeight + this.RowSpace);
                     _loc7_.x = _loc6_.x + (_loc10_ - _loc6_.width) / 2;
                     _loc7_.y = _loc6_.y + (_loc11_ - _loc6_.height) / 2;
                  }
                  _loc4_++;
               }
               _loc3_++;
            }
            _loc12_ = this.MarginLeft * 2 + _loc2_ * this.FIconWidth + Math.max(_loc2_ - 1,0) * this.ColSpace;
            _loc13_ = this.MarginTop * 2 + _loc1_ * this.FIconHeight + Math.max(_loc1_ - 1,0) * this.RowSpace;
            this.UpdateGrid(_loc12_,_loc13_);
            FBounds.Width = _loc12_;
            FBounds.Height = _loc13_;
         }
         while(this.FUI9GridBtm.width > FUICore.StageWidth && _loc2_ > 1);
      }
      
      protected function FilterIcon() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:SimpleButton = null;
         var _loc3_:Bitmap = null;
         var _loc4_:Boolean = false;
         this.FFilterBtns.length = 0;
         this.FFilterEffects.length = 0;
         _loc4_ = false;
         _loc1_ = 0;
         while(_loc1_ < FCapacity)
         {
            _loc2_ = FButtons[_loc1_];
            _loc3_ = FLayerEffects[_loc1_];
            if(_loc2_.visible)
            {
               this.FFilterBtns.push(_loc2_);
               this.FFilterEffects.push(_loc3_);
               _loc4_ = true;
            }
            else
            {
               _loc2_.x = 0;
               _loc2_.y = 0;
               _loc3_.x = 0;
               _loc3_.y = 0;
               _loc3_.visible = false;
            }
            _loc1_++;
         }
         this.FUI9GridBtm.visible = _loc4_;
      }
      
      public function set UI9GridSource(param1:BitmapData) : void
      {
         this.FUI9Grid.Source = param1.clone();
      }
      
      public function set IconWidth(param1:uint) : void
      {
         this.FIconWidth = param1;
      }
      
      public function set IconHeight(param1:uint) : void
      {
         this.FIconHeight = param1;
      }
   }
}

