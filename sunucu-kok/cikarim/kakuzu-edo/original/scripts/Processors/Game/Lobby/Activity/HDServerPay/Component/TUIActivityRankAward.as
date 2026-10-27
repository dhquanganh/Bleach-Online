package Processors.Game.Lobby.Activity.HDServerPay.Component
{
   import Foundation.UI.TUIComponent;
   import Logics.Inventories.TInventories;
   import Resources.Constants.CONST_ACTIVITY;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TUIActivityRankAward extends TUIComponent
   {
      
      protected var FMC_Main:Sprite;
      
      protected var FTF_Prompts:Vector.<TextField>;
      
      protected var FMC_Prompts:Vector.<MovieClip>;
      
      protected var FBitmap_Prompts:Vector.<Bitmap>;
      
      protected var FCount_TF:uint;
      
      protected var FCount_MC:uint;
      
      protected var FCount_Bitmap:uint;
      
      protected var FIsInitWindow:Boolean;
      
      protected var FIndex:int;
      
      protected var FOnGiftOver:Function;
      
      protected var FOnGiftOut:Function;
      
      public function TUIActivityRankAward(param1:TUIComponent)
      {
         super(param1);
         this.FIsInitWindow = false;
      }
      
      protected function Resources_UIDispatch(param1:Sprite, param2:Boolean) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Sprite = null;
         var _loc6_:MovieClip = null;
         this.FMC_Main = param1;
         if(param2)
         {
            addChild(this.FMC_Main);
         }
         _loc4_ = int(this.FCount_TF);
         this.FTF_Prompts = new Vector.<TextField>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.FTF_Prompts[_loc3_] = this.FMC_Main[CONST_ACTIVITY.RESOURCE_Link_TF_Prompt + _loc3_];
            this.FTF_Prompts[_loc3_].mouseEnabled = false;
            _loc3_++;
         }
         _loc4_ = int(this.FCount_MC);
         this.FMC_Prompts = new Vector.<MovieClip>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.FMC_Prompts[_loc3_] = this.FMC_Main[CONST_ACTIVITY.RESOURCE_Link_MC_PromptVect + _loc3_];
            this.FMC_Prompts[_loc3_].addEventListener(MouseEvent.MOUSE_MOVE,this.MCPromptOnOver);
            this.FMC_Prompts[_loc3_].addEventListener(MouseEvent.MOUSE_OUT,this.MCPromptOnOut);
            _loc3_++;
         }
         this.ResetTextField();
         this.FIsInitWindow = true;
      }
      
      protected function ProcessorUpdateUI(param1:Vector.<TInventories> = null, param2:Vector.<String> = null) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = int(this.FTF_Prompts.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.FTF_Prompts[_loc3_].text = param2[_loc3_];
            _loc3_++;
         }
      }
      
      protected function ResetTextField() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FCount_TF);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTF_Prompts[_loc1_].text = "";
            _loc1_++;
         }
      }
      
      protected function MCPromptOnOver(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         _loc3_ = param1.currentTarget.name;
         _loc2_ = int(name.split("_")[2]);
         if(this.FOnGiftOver != null)
         {
            this.FOnGiftOver(this,_loc2_,this.FIndex);
         }
      }
      
      protected function MCPromptOnOut(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         _loc3_ = param1.currentTarget.name;
         _loc2_ = int(name.split("_")[2]);
         if(this.FOnGiftOut != null)
         {
            this.FOnGiftOut(this,_loc2_,this.FIndex);
         }
      }
      
      public function get OnGiftOver() : Function
      {
         return this.FOnGiftOver;
      }
      
      public function set OnGiftOver(param1:Function) : void
      {
         this.FOnGiftOver = param1;
      }
      
      public function get OnGiftOut() : Function
      {
         return this.FOnGiftOut;
      }
      
      public function set OnGiftOut(param1:Function) : void
      {
         this.FOnGiftOut = param1;
      }
      
      public function Perform_UIDispatch(param1:Sprite, param2:uint, param3:uint, param4:uint, param5:Boolean = true) : void
      {
         this.FCount_TF = param2;
         this.FCount_MC = param3;
         this.Resources_UIDispatch(param1,param5);
      }
      
      public function UpdateUI(param1:int, param2:Vector.<TInventories> = null, param3:Vector.<String> = null) : void
      {
         this.FIndex = param1;
         this.ProcessorUpdateUI(param2,param3);
      }
      
      public function Reset() : void
      {
         if(!this.FIsInitWindow)
         {
            return;
         }
      }
   }
}

