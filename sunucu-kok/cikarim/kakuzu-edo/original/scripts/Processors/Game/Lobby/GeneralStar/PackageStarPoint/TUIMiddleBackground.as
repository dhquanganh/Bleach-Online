package Processors.Game.Lobby.GeneralStar.PackageStarPoint
{
   import Foundation.UI.TUIComponent;
   import Logics.Characters.TCharacter;
   import Logics.GeneralStar.TEsotericPoint;
   import Logics.GeneralStar.TEsotericPoints;
   import Logics.SLogicsCore;
   import Resources.Constants.CONST_GENERAL_STAR;
   import flash.display.MovieClip;
   
   public class TUIMiddleBackground extends TUIComponent
   {
      
      protected var FPoints:Vector.<TPoint>;
      
      protected var FPointCount:uint;
      
      protected var FSeals:Vector.<MovieClip>;
      
      protected var FWords:Vector.<MovieClip>;
      
      protected var FScene:MovieClip;
      
      protected var FCharacter:TCharacter;
      
      protected var FEsotericPoints:TEsotericPoints;
      
      protected var FOnGeneralStarMove:Function;
      
      protected var FOnGeneralStarOut:Function;
      
      protected var FOnGeneralStarClick:Function;
      
      protected var FOnSetColour:Function;
      
      public function TUIMiddleBackground(param1:TUIComponent)
      {
         super(param1);
         this.FSeals = new Vector.<MovieClip>();
         this.FWords = new Vector.<MovieClip>();
         this.FCharacter = SLogicsCore.Character;
      }
      
      protected function UIDispatch(param1:MovieClip, param2:uint, param3:uint) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:TPoint = null;
         var _loc6_:MovieClip = null;
         this.FPoints = new Vector.<TPoint>(this.FPointCount);
         _loc4_ = 0;
         while(_loc4_ < param2)
         {
            _loc5_ = new TPoint(this);
            _loc5_.Substrate = param1[CONST_GENERAL_STAR.RESOURCESID_POINT + _loc4_];
            _loc5_.OnGeneralStarMove = this.FOnGeneralStarMove;
            _loc5_.OnGeneralStarOut = this.FOnGeneralStarOut;
            _loc5_.OnClickPoint = this.FOnGeneralStarClick;
            _loc5_.Init();
            this.FPoints[_loc4_] = _loc5_;
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < param3)
         {
            _loc6_ = param1[CONST_GENERAL_STAR.RESPIRCESID_MC_Seal_ + _loc4_];
            this.FSeals.push(_loc6_);
            _loc4_++;
         }
      }
      
      protected function UpdatePoint(param1:uint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TEsotericPoint = null;
         _loc3_ = this.FPoints.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FPoints[_loc2_].Context = this.FEsotericPoints.GetEsotericPointByIndex(_loc2_);
            if(_loc2_ < param1)
            {
               this.FPoints[_loc2_].SetPointState(TPoint.RENDERINGSTATE_Pointed);
               if(_loc2_ < this.FSeals.length)
               {
                  this.FSeals[_loc2_].play();
               }
            }
            else if(_loc2_ > param1)
            {
               this.FPoints[_loc2_].SetPointState(TPoint.RENDERINGSTATE_Disabled);
            }
            else
            {
               if(this.FCharacter.StarMapIndex == 0)
               {
                  _loc4_ = this.FCharacter.EsotericPoints.GetEsotericPointByIndex(0) as TEsotericPoint;
               }
               else
               {
                  _loc4_ = this.FEsotericPoints.GetEsotericPointByIndex(_loc2_) as TEsotericPoint;
               }
               if(this.FCharacter.GeneralsSoul >= _loc4_.NeedFetch)
               {
                  if(this.FCharacter.EsotericPoints.GetEsotericPointByIdentifier(this.FCharacter.StarMapIndex) == this.FCharacter.EsotericPoints.GetEsotericPointByIndex(74))
                  {
                     this.FPoints[_loc2_].SetPointState(TPoint.RENDERINGSTATE_Pointed);
                     this.PlayWordsAndCo();
                     return;
                  }
                  this.FPoints[_loc2_].SetPointState(TPoint.RENDERINGSTATE_CanPoint);
                  if(this.FOnSetColour != null)
                  {
                     this.FOnSetColour(true);
                  }
               }
               else
               {
                  this.FPoints[_loc2_].SetPointState(TPoint.RENDERINGSTATE_Disabled);
                  if(this.FOnSetColour != null)
                  {
                     this.FOnSetColour(false);
                  }
               }
            }
            _loc2_++;
         }
      }
      
      protected function PlayWordsAndCo() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FSeals.length)
         {
            this.FSeals[_loc1_].play();
            _loc1_++;
         }
      }
      
      public function get Scene() : MovieClip
      {
         return this.FScene;
      }
      
      public function set Scene(param1:MovieClip) : void
      {
         this.FScene = param1;
      }
      
      public function get OnGeneralStarMove() : Function
      {
         return this.FOnGeneralStarMove;
      }
      
      public function set OnGeneralStarMove(param1:Function) : void
      {
         this.FOnGeneralStarMove = param1;
      }
      
      public function get OnGeneralStarOut() : Function
      {
         return this.FOnGeneralStarOut;
      }
      
      public function set OnGeneralStarOut(param1:Function) : void
      {
         this.FOnGeneralStarOut = param1;
      }
      
      public function get OnGeneralStarClick() : Function
      {
         return this.FOnGeneralStarClick;
      }
      
      public function set OnGeneralStarClick(param1:Function) : void
      {
         this.FOnGeneralStarClick = param1;
      }
      
      public function get OnSetColour() : Function
      {
         return this.FOnSetColour;
      }
      
      public function set OnSetColour(param1:Function) : void
      {
         this.FOnSetColour = param1;
      }
      
      public function Init(param1:MovieClip, param2:uint, param3:uint) : void
      {
         this.FScene = param1;
         this.FPointCount = param2;
         this.UIDispatch(param1,param2,param3);
      }
      
      public function UpdateGround(param1:uint, param2:TEsotericPoints) : void
      {
         this.FEsotericPoints = param2;
         this.UpdatePoint(param1);
      }
      
      public function AllLight(param1:TEsotericPoints) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TEsotericPoint = null;
         this.FEsotericPoints = param1;
         _loc3_ = this.FPoints.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FPoints[_loc2_].SetPointState(TPoint.RENDERINGSTATE_Pointed);
            this.FPoints[_loc2_].Context = this.FEsotericPoints.GetEsotericPointByIndex(_loc2_);
            _loc2_++;
         }
         this.PlayWordsAndCo();
      }
      
      public function UpdatePointStar(param1:TEsotericPoint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:TEsotericPoint = null;
         _loc2_ = param1.PointIndex - 1;
         this.FPoints[_loc2_].SetPointState(TPoint.RENDERINGSTATE_Pointed);
         this.FSeals[_loc2_].play();
         _loc3_ = this.FEsotericPoints.GetEsotericPointByIndex(_loc2_ + 1) as TEsotericPoint;
         if(this.FCharacter.GeneralsSoul >= _loc3_.NeedFetch)
         {
            this.FPoints[_loc2_ + 1].SetPointState(TPoint.RENDERINGSTATE_CanPoint);
            if(this.FOnSetColour != null)
            {
               this.FOnSetColour(true);
            }
         }
         else if(this.FOnSetColour != null)
         {
            this.FOnSetColour(false);
         }
      }
      
      public function GetPointByIndex(param1:uint) : TPoint
      {
         return this.FPoints[param1];
      }
   }
}

