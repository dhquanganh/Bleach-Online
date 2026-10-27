package Components.Standard
{
   import Foundation.Common.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.geom.*;
   
   public class TUIBarrier extends TUIComponent
   {
      
      protected var FPanelSubstrate:Sprite;
      
      protected var FOrifices:Vector.<TBounds>;
      
      protected var FOrificeCount:int;
      
      protected var FModified:Boolean;
      
      protected var FOnClick:Function;
      
      protected var FColor:uint;
      
      public function TUIBarrier(param1:TUIComponent)
      {
         super(param1);
         this.FOrifices = new Vector.<TBounds>();
         Visible = false;
      }
      
      protected function Initialization() : void
      {
         this.FPanelSubstrate = new Sprite();
         addChild(this.FPanelSubstrate);
         this.FPanelSubstrate.graphics.beginFill(this.FColor,0.2);
         this.FPanelSubstrate.graphics.drawRect(0,0,FBoundsClient.Width,FBoundsClient.Height);
         this.FPanelSubstrate.graphics.endFill();
      }
      
      override public function set Width(param1:int) : void
      {
         if(param1 != FBoundsClient.Width)
         {
            FBoundsClient.Width = param1;
            this.FModified = true;
         }
      }
      
      override public function set Height(param1:int) : void
      {
         if(param1 != FBoundsClient.Height)
         {
            FBoundsClient.Height = param1;
            this.FModified = true;
         }
      }
      
      public function get Count() : int
      {
         return this.FOrificeCount;
      }
      
      public function get Color() : uint
      {
         return this.FColor;
      }
      
      public function set Color(param1:uint) : void
      {
         if(param1 != this.FColor)
         {
            this.FColor = param1;
            this.FModified = true;
         }
      }
      
      public function Init() : void
      {
         this.Initialization();
      }
      
      public function OrificesClear() : void
      {
         if(this.FOrificeCount != 0)
         {
            this.FOrificeCount = 0;
            this.FModified = true;
         }
      }
      
      public function OrificeAdd(param1:TBounds) : void
      {
         var _loc2_:TBounds = null;
         if(this.FOrifices.length <= this.FOrificeCount)
         {
            _loc2_ = new TBounds();
            this.FOrifices.push(_loc2_);
         }
         else
         {
            _loc2_ = this.FOrifices[this.FOrificeCount];
         }
         _loc2_.Assign(param1);
         ++this.FOrificeCount;
         this.FModified = true;
      }
   }
}

