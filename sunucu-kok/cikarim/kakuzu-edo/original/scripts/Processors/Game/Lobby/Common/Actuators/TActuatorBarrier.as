package Processors.Game.Lobby.Common.Actuators
{
   import Debugging.*;
   import Foundation.Utilities.*;
   
   public class TActuatorBarrier
   {
      
      protected var FActuators:Vector.<Object>;
      
      protected var FActuatorsAddition:Vector.<Object>;
      
      protected var FOnUpdate:Function;
      
      protected var FOnUpdateAddition:Function;
      
      public function TActuatorBarrier()
      {
         super();
         this.FActuators = new Vector.<Object>();
         this.FActuatorsAddition = new Vector.<Object>();
      }
      
      protected function Update() : void
      {
         if(this.FOnUpdate != null)
         {
            this.FOnUpdate(this);
         }
      }
      
      protected function UpdateAddition() : void
      {
         if(this.FOnUpdateAddition != null)
         {
            this.FOnUpdateAddition(this);
         }
      }
      
      public function get Count() : int
      {
         return this.FActuators.length;
      }
      
      public function get CountAddition() : int
      {
         return this.FActuatorsAddition.length;
      }
      
      public function get OnUpdate() : Function
      {
         return this.FOnUpdate;
      }
      
      public function set OnUpdate(param1:Function) : void
      {
         this.FOnUpdate = param1;
      }
      
      public function get OnUpdateAddition() : Function
      {
         return this.FOnUpdateAddition;
      }
      
      public function set OnUpdateAddition(param1:Function) : void
      {
         this.FOnUpdateAddition = param1;
      }
      
      public function Actuate(param1:Object) : void
      {
         this.FActuators.push(param1);
         this.Update();
      }
      
      public function Deactuate(param1:Object) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FActuators.indexOf(param1);
         if(_loc2_ < 0)
         {
            return;
         }
         this.FActuators.splice(_loc2_,1);
         this.Update();
      }
      
      public function ActuateAddition(param1:Object) : void
      {
         this.FActuatorsAddition.push(param1);
         this.UpdateAddition();
      }
      
      public function DeactuateAddition(param1:Object) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FActuatorsAddition.indexOf(param1);
         if(_loc2_ < 0)
         {
            return;
         }
         this.FActuatorsAddition.splice(_loc2_,1);
         this.UpdateAddition();
      }
   }
}

