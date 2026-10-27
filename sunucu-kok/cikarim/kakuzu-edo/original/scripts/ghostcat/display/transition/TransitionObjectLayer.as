package ghostcat.display.transition
{
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import ghostcat.display.IGBase;
   import ghostcat.events.GEvent;
   import ghostcat.operation.DelayOper;
   import ghostcat.operation.Oper;
   import ghostcat.operation.TweenOper;
   
   public class TransitionObjectLayer extends TransitionLayerBase
   {
      
      public var transfer:DisplayObject;
      
      public var hideObject:DisplayObject;
      
      public function TransitionObjectLayer(param1:*, param2:DisplayObject, param3:DisplayObject = null, param4:int = 1000, param5:int = 1000, param6:Boolean = false, param7:Function = null, param8:Function = null)
      {
         var _loc9_:Oper = null;
         var _loc10_:Oper = null;
         var _loc11_:Oper = null;
         this.transfer = param2;
         this.hideObject = param3;
         param2.alpha = 0;
         if(param4)
         {
            _loc9_ = new TweenOper(param2,param4,{
               "alpha":1,
               "ease":param7
            });
         }
         if(param5)
         {
            _loc10_ = new TweenOper(param2,param5,{
               "alpha":0,
               "ease":param8
            });
         }
         if(param6)
         {
            _loc11_ = new DelayOper(-1);
         }
         super(param1,_loc9_,_loc10_,_loc11_);
      }
      
      override public function createTo(param1:DisplayObjectContainer) : TransitionLayerBase
      {
         param1.addChild(this.transfer);
         return super.createTo(param1);
      }
      
      override public function set state(param1:String) : void
      {
         if(state == param1)
         {
            return;
         }
         if(this.hideObject)
         {
            switch(param1)
            {
               case FADE_IN:
                  this.hideObject.visible = false;
                  break;
               case FADE_OUT:
                  this.hideObject.dispatchEvent(new GEvent(GEvent.UPDATE_COMPLETE));
                  break;
               case END:
                  this.hideObject.visible = true;
            }
         }
         super.state = param1;
      }
      
      override public function destory() : void
      {
         if(this.transfer is IGBase)
         {
            (this.transfer as IGBase).destory();
         }
         if(this.transfer.parent)
         {
            this.transfer.parent.removeChild(this.transfer);
         }
         if(this.transfer is Bitmap && Boolean((this.transfer as Bitmap).bitmapData))
         {
            (this.transfer as Bitmap).bitmapData.dispose();
         }
         super.destory();
      }
   }
}

