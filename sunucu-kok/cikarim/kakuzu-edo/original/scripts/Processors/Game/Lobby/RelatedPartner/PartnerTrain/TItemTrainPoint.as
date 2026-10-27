package Processors.Game.Lobby.RelatedPartner.PartnerTrain
{
   import Resources.Constants.CONST_RELATEDPARTNER;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TItemTrainPoint
   {
      
      public static const Star_Num:int = 3;
      
      protected static const FrameIndex_WaitCross:int = CONST_RELATEDPARTNER.FrameIndex_WaitCross;
      
      protected static const FrameIndex_Selected:int = CONST_RELATEDPARTNER.FrameIndex_Selected;
      
      protected static const FrameIndex_AlreadyCross:int = CONST_RELATEDPARTNER.FrameIndex_AlreadyCross;
      
      protected var FMainUI:Sprite;
      
      protected var FMCPoint:MovieClip;
      
      protected var FMCStar:Sprite;
      
      protected var FLightStars:Vector.<Sprite>;
      
      protected var FFightable:Boolean;
      
      protected var FOnClick:Function;
      
      protected var FOnMove:Function;
      
      protected var FOnOut:Function;
      
      protected var FPveId:int;
      
      public function TItemTrainPoint(param1:Sprite)
      {
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         super();
         this.FMainUI = param1;
         this.FMCPoint = this.FMainUI["MC_Point"];
         this.FMCPoint.gotoAndStop(1);
         this.FMCPoint.buttonMode = true;
         this.FMCStar = this.FMainUI["MC_Star"];
         this.FLightStars = new Vector.<Sprite>();
         _loc2_ = 0;
         while(_loc2_ < Star_Num)
         {
            _loc3_ = this.FMCStar["Lightstar" + _loc2_];
            _loc3_.visible = false;
            this.FLightStars.push(_loc3_);
            _loc2_++;
         }
         this.FMCPoint.addEventListener(MouseEvent.CLICK,this.PointOnClick);
         this.FMCPoint.addEventListener(MouseEvent.MOUSE_MOVE,this.PointOnMove);
         this.FMCPoint.addEventListener(MouseEvent.MOUSE_OUT,this.PointOnOut);
      }
      
      protected function PointOnClick(param1:MouseEvent) : void
      {
         if(this.FOnClick != null)
         {
            if(!this.FFightable)
            {
               this.FOnClick(this,0);
               return;
            }
            this.FOnClick(this,this.FPveId);
         }
      }
      
      protected function PointOnMove(param1:MouseEvent) : void
      {
         if(this.FOnMove != null)
         {
            this.FOnMove(this.FPveId);
         }
      }
      
      protected function PointOnOut(param1:MouseEvent) : void
      {
         if(this.FOnOut != null)
         {
            this.FOnOut(this.FPveId);
         }
      }
      
      public function SetStar(param1:int) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < Star_Num)
         {
            this.FLightStars[_loc2_].visible = _loc2_ < param1;
            _loc2_++;
         }
      }
      
      public function SetPointStatus(param1:int) : void
      {
         this.FMCPoint.gotoAndStop(param1);
         switch(param1)
         {
            case FrameIndex_WaitCross:
               this.FFightable = false;
               break;
            case FrameIndex_Selected:
            case FrameIndex_AlreadyCross:
               this.FFightable = true;
         }
      }
      
      public function Reset() : void
      {
         this.SetPointStatus(1);
         this.SetStar(0);
      }
      
      public function get OnClick() : Function
      {
         return this.FOnClick;
      }
      
      public function set OnClick(param1:Function) : void
      {
         this.FOnClick = param1;
      }
      
      public function get PveId() : int
      {
         return this.FPveId;
      }
      
      public function set PveId(param1:int) : void
      {
         this.FPveId = param1;
      }
      
      public function get OnMove() : Function
      {
         return this.FOnMove;
      }
      
      public function set OnMove(param1:Function) : void
      {
         this.FOnMove = param1;
      }
      
      public function get OnOut() : Function
      {
         return this.FOnOut;
      }
      
      public function set OnOut(param1:Function) : void
      {
         this.FOnOut = param1;
      }
   }
}

