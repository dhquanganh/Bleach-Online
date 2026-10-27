package Processors.Game.Lobby.Activity
{
   import flash.display.Sprite;
   import flash.utils.setTimeout;
   import ghostcat.util.easing.TweenUtil;
   
   public class TPlayAnimaEffect extends Sprite
   {
      
      public static const AddSpeedState:int = 1;
      
      public static const SlowState:int = 2;
      
      public static const TargetState:int = 3;
      
      private var FSpeed:Number;
      
      private var Index:int;
      
      private var FSelectBoxVec:Vector.<Sprite>;
      
      private var FCurrentState:int;
      
      private var FcurrentSelectIndex:int;
      
      private var FCurrentRotationTurns:int;
      
      public var FMax_ax:int = 10;
      
      public var FMix_ax:int = 2;
      
      private var FAcceleration:Number = 2;
      
      public var Fax:Number = 10;
      
      public var FRotationTurns:int = 3;
      
      private var FDataISArriveBol:Boolean = false;
      
      public var FDelayTime:int = 800;
      
      public var FDelayInterval:int = 100;
      
      public function TPlayAnimaEffect()
      {
         super();
      }
      
      public function update() : void
      {
         switch(this.FCurrentState)
         {
            case AddSpeedState:
               this.FSpeed += this.FAcceleration;
               if(this.FSpeed % this.Fax == 0)
               {
                  this.FSelectBoxVec[this.FcurrentSelectIndex].visible = false;
                  this.Fax /= this.FAcceleration;
                  if(this.Fax <= this.FMix_ax)
                  {
                     this.Fax = this.FMix_ax;
                  }
                  ++this.FcurrentSelectIndex;
                  if(this.FcurrentSelectIndex >= this.FSelectBoxVec.length)
                  {
                     this.FcurrentSelectIndex = 0;
                     ++this.FCurrentRotationTurns;
                  }
                  this.FSelectBoxVec[this.FcurrentSelectIndex].visible = true;
                  if(this.FCurrentRotationTurns >= this.FRotationTurns && this.FDataISArriveBol)
                  {
                     this.FCurrentState = SlowState;
                  }
               }
               break;
            case SlowState:
               this.FSpeed += this.FAcceleration;
               if(this.FSpeed % this.Fax == 0)
               {
                  this.FSelectBoxVec[this.FcurrentSelectIndex].visible = false;
                  this.Fax *= this.FAcceleration;
                  if(this.Fax >= this.FMax_ax)
                  {
                     this.Fax = this.FMax_ax;
                     this.FCurrentState = TargetState;
                  }
                  ++this.FcurrentSelectIndex;
                  this.FcurrentSelectIndex = this.FcurrentSelectIndex >= this.FSelectBoxVec.length ? 0 : this.FcurrentSelectIndex;
                  this.FSelectBoxVec[this.FcurrentSelectIndex].visible = true;
               }
               break;
            case TargetState:
               this.FSpeed += this.FAcceleration;
               if(this.FSpeed % this.Fax == 0)
               {
                  this.FSelectBoxVec[this.FcurrentSelectIndex].visible = false;
                  ++this.FcurrentSelectIndex;
                  this.FcurrentSelectIndex = this.FcurrentSelectIndex >= this.FSelectBoxVec.length ? 0 : this.FcurrentSelectIndex;
                  this.FSelectBoxVec[this.FcurrentSelectIndex].visible = true;
                  if(this.FcurrentSelectIndex == this.Index)
                  {
                     this.FCurrentState = 0;
                     this.FCurrentRotationTurns = 0;
                     this.FDataISArriveBol = false;
                  }
               }
         }
      }
      
      public function startPlay() : void
      {
         if(this.FCurrentState != 0)
         {
            return;
         }
         this.FSpeed = 0;
         this.FcurrentSelectIndex = 0;
         this.FCurrentState = AddSpeedState;
         this.SetSelectBox();
      }
      
      public function get SelectVec() : Vector.<Sprite>
      {
         return this.FSelectBoxVec;
      }
      
      public function set SelectVec(param1:Vector.<Sprite>) : void
      {
         this.FSelectBoxVec = param1;
      }
      
      public function get CurrentState() : int
      {
         return this.FCurrentState;
      }
      
      public function FindRewardPos(param1:int) : void
      {
         this.FDataISArriveBol = true;
         if(this.FCurrentRotationTurns >= this.FRotationTurns)
         {
            this.FCurrentState = SlowState;
         }
         this.Index = param1;
      }
      
      public function ClearSelectBox() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FDataISArriveBol = true;
         this.FCurrentState = 0;
         _loc2_ = int(this.FSelectBoxVec.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSelectBoxVec[_loc1_].visible = true;
            this.FSelectBoxVec[_loc1_].alpha = 1;
            TweenUtil.to(this.FSelectBoxVec[_loc1_],this.FDelayTime,{"alpha":0});
            _loc1_++;
         }
         setTimeout(this.SetSelectBox,this.FDelayTime + this.FDelayInterval);
      }
      
      private function SetSelectBox() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FSelectBoxVec.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSelectBoxVec[_loc1_].visible = false;
            this.FSelectBoxVec[_loc1_].alpha = 1;
            _loc1_++;
         }
      }
   }
}

