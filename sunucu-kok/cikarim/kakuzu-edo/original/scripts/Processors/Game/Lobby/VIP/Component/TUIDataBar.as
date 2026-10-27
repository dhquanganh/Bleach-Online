package Processors.Game.Lobby.VIP.Component
{
   import Foundation.UI.TUIComponent;
   import Resources.Constants.CONST_VIP;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class TUIDataBar extends TUIComponent
   {
      
      protected static const RENDERINGSTATE_Substrate:int = 1;
      
      protected static const RENDERINGSTATE_Alternation:int = 2;
      
      protected static const TYPE_Number:int = 0;
      
      protected static const TYPE_Boolean:int = 1;
      
      protected var FResource:MovieClip;
      
      protected var FMC_Marks:Vector.<MovieClip>;
      
      protected var FTF_Numerical:TextField;
      
      protected var FMC_HeightLights:Vector.<Sprite>;
      
      protected var FTF_Caption:TextField;
      
      protected var FColumnsCount:int;
      
      protected var FActivationIndex:int;
      
      protected var FInitialization:Boolean;
      
      public function TUIDataBar(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function Initialization() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:Sprite = null;
         var _loc4_:uint = 0;
         addChild(this.FResource);
         this.FTF_Caption = this.FResource[CONST_VIP.RESOURCE_Link_TF_Caption];
         this.FMC_Marks = new Vector.<MovieClip>(this.FColumnsCount);
         this.FMC_HeightLights = new Vector.<Sprite>(this.FColumnsCount);
         _loc1_ = 0;
         while(_loc1_ < this.FColumnsCount)
         {
            _loc2_ = this.FResource[CONST_VIP.RESOURCE_Link_MC_Marks + _loc1_];
            _loc3_ = this.FResource[CONST_VIP.RESOURCE_Link_MC_HeightLights + _loc1_];
            _loc3_.visible = false;
            this.FMC_Marks[_loc1_] = _loc2_;
            this.FMC_HeightLights[_loc1_] = _loc3_;
            _loc1_++;
         }
         if(FTag % 2 == 0)
         {
            _loc4_ = uint(RENDERINGSTATE_Substrate);
         }
         else
         {
            _loc4_ = uint(RENDERINGSTATE_Alternation);
         }
         this.FResource.gotoAndStop(_loc4_);
         this.FInitialization = true;
      }
      
      protected function UpdateRenderingState() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         _loc3_ = this.FActivationIndex;
         _loc1_ = 0;
         while(_loc1_ < this.FColumnsCount)
         {
            if(_loc3_ == _loc1_)
            {
               _loc4_ = true;
            }
            else
            {
               _loc4_ = false;
            }
            _loc2_ = this.FMC_HeightLights[_loc1_];
            _loc2_.visible = _loc4_;
            _loc1_++;
         }
      }
      
      public function get Resource() : MovieClip
      {
         return this.FResource;
      }
      
      public function set Resource(param1:MovieClip) : void
      {
         this.FResource = param1;
      }
      
      public function get ColumnsCount() : int
      {
         return this.FColumnsCount;
      }
      
      public function set ColumnsCount(param1:int) : void
      {
         this.FColumnsCount = param1;
      }
      
      public function get Caption() : String
      {
         return this.FTF_Caption.text;
      }
      
      public function set Caption(param1:String) : void
      {
         this.FTF_Caption.text = param1;
      }
      
      public function get ActivationIndex() : int
      {
         return this.FActivationIndex;
      }
      
      public function set ActivationIndex(param1:int) : void
      {
         this.FActivationIndex = param1;
      }
      
      public function Init() : void
      {
         if(this.FInitialization)
         {
            return;
         }
         this.Initialization();
      }
      
      public function Update() : void
      {
         this.UpdateRenderingState();
      }
      
      public function SetItem(param1:int, param2:uint, param3:uint = 0) : void
      {
         var _loc4_:MovieClip = null;
         var _loc5_:TextField = null;
         _loc4_ = this.FMC_Marks[param2];
         switch(param1)
         {
            case TYPE_Number:
               _loc4_.gotoAndStop(3);
               _loc5_ = _loc4_[CONST_VIP.RESOURCE_Link_TF_Numerical];
               _loc5_.text = param3.toString();
               break;
            case TYPE_Boolean:
               if(Boolean(param3))
               {
                  _loc4_.gotoAndStop(1);
               }
               else
               {
                  _loc4_.gotoAndStop(2);
               }
         }
      }
   }
}

