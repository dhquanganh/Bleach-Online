package Processors.Game.Common.Effects.Texts
{
   import Foundation.Common.TCoordinate;
   import Resources.Constants.CONST_EFFECT;
   
   public class TEffectCoordinateParameters
   {
      
      protected static const COORDINATE_TextX:int = 620;
      
      protected static const COORDINATE_TextY:int = 355;
      
      protected var FCoordinateSource:TCoordinate;
      
      protected var FCoordinateDestination:TCoordinate;
      
      protected var FFadeInTicks:int;
      
      protected var FFadeOutTicks:int;
      
      protected var FSustainTicks:int;
      
      protected var FVelocityX:int;
      
      protected var FVelocityY:int;
      
      protected var FPauseTicks:int;
      
      protected var FPauseSustainTicks:int;
      
      protected var FIsShakeEffect:Boolean;
      
      protected var FIsScale:Boolean;
      
      protected var FIsParallelOutput:Boolean;
      
      public function TEffectCoordinateParameters()
      {
         super();
         this.FCoordinateSource = new TCoordinate();
         this.FCoordinateDestination = new TCoordinate();
         this.PropertiesInitialize();
      }
      
      protected function PropertiesInitialize() : void
      {
         this.FCoordinateSource.X = COORDINATE_TextX;
         this.FCoordinateSource.Y = COORDINATE_TextY;
         this.FFadeInTicks = CONST_EFFECT.TEXT_DEFAULT_FadeInTicks;
         this.FFadeOutTicks = CONST_EFFECT.TEXT_DEFAULT_FadeOutTicks;
         this.FSustainTicks = CONST_EFFECT.TEXT_DEFAULT_SustainTicks;
         this.FVelocityX = CONST_EFFECT.TEXT_DEFAULT_VelocityX;
         this.FVelocityY = CONST_EFFECT.TEXT_DEFAULT_VelocityY;
         this.FPauseTicks = CONST_EFFECT.TEXT_DEFAULT_PauseTicks;
         this.FPauseSustainTicks = CONST_EFFECT.TEXT_DEFAULT_PauseSustainTicks;
         this.FIsShakeEffect = CONST_EFFECT.TEXT_DEFAULT_IsShakeEffect;
         this.FIsScale = CONST_EFFECT.TEXT_DEFAULT_IsScale;
         this.FIsParallelOutput = CONST_EFFECT.TEXT_DEFAULT_IsParallelOutput;
      }
      
      public function get CoordinateSource() : TCoordinate
      {
         return this.FCoordinateSource;
      }
      
      public function set CoordinateSource(param1:TCoordinate) : void
      {
         this.FCoordinateSource = param1;
      }
      
      public function get CoordinateDestination() : TCoordinate
      {
         return this.FCoordinateDestination;
      }
      
      public function set CoordinateDestination(param1:TCoordinate) : void
      {
         this.FCoordinateDestination = param1;
      }
      
      public function get X() : int
      {
         return this.FCoordinateSource.X;
      }
      
      public function set X(param1:int) : void
      {
         this.FCoordinateSource.X = param1;
      }
      
      public function get Y() : int
      {
         return this.FCoordinateSource.Y;
      }
      
      public function set Y(param1:int) : void
      {
         this.FCoordinateSource.Y = param1;
      }
      
      public function get FadeInTicks() : int
      {
         return this.FFadeInTicks;
      }
      
      public function set FadeInTicks(param1:int) : void
      {
         this.FFadeInTicks = param1;
      }
      
      public function get FadeOutTicks() : int
      {
         return this.FFadeOutTicks;
      }
      
      public function set FadeOutTicks(param1:int) : void
      {
         this.FFadeOutTicks = param1;
      }
      
      public function get SustainTicks() : int
      {
         return this.FSustainTicks;
      }
      
      public function set SustainTicks(param1:int) : void
      {
         this.FSustainTicks = param1;
      }
      
      public function get VelocityX() : int
      {
         return this.FVelocityX;
      }
      
      public function set VelocityX(param1:int) : void
      {
         this.FVelocityX = param1;
      }
      
      public function get VelocityY() : int
      {
         return this.FVelocityY;
      }
      
      public function set VelocityY(param1:int) : void
      {
         this.FVelocityY = param1;
      }
      
      public function get PauseTicks() : int
      {
         return this.FPauseTicks;
      }
      
      public function set PauseTicks(param1:int) : void
      {
         this.FPauseTicks = param1;
      }
      
      public function get PauseSustainTicks() : int
      {
         return this.FPauseSustainTicks;
      }
      
      public function set PauseSustainTicks(param1:int) : void
      {
         this.FPauseSustainTicks = param1;
      }
      
      public function get IsShakeEffect() : Boolean
      {
         return this.FIsShakeEffect;
      }
      
      public function set IsShakeEffect(param1:Boolean) : void
      {
         this.FIsShakeEffect = param1;
      }
      
      public function get IsScale() : Boolean
      {
         return this.FIsScale;
      }
      
      public function set IsScale(param1:Boolean) : void
      {
         this.FIsScale = param1;
      }
      
      public function get IsParallelOutput() : Boolean
      {
         return this.FIsParallelOutput;
      }
      
      public function set IsParallelOutput(param1:Boolean) : void
      {
         this.FIsParallelOutput = param1;
      }
      
      public function Assign(param1:TEffectCoordinateParameters) : void
      {
         this.FCoordinateSource.Assign(param1.CoordinateSource);
         this.FCoordinateDestination.Assign(param1.CoordinateDestination);
         this.FFadeInTicks = param1.FadeInTicks;
         this.FFadeOutTicks = param1.FadeOutTicks;
         this.FSustainTicks = param1.SustainTicks;
         this.FVelocityX = param1.VelocityX;
         this.FVelocityY = param1.VelocityY;
         this.FPauseTicks = param1.PauseTicks;
         this.FPauseSustainTicks = param1.PauseSustainTicks;
         this.FIsShakeEffect = param1.IsShakeEffect;
         this.FIsScale = param1.IsScale;
         this.FIsParallelOutput = param1.IsParallelOutput;
      }
      
      public function Reset() : void
      {
         this.PropertiesInitialize();
      }
   }
}

