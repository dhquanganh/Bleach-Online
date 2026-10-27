package Processors.Game.Lobby.TeamBattle.HonorShop.Component
{
   import Foundation.UI.TUIComponent;
   import Resources.Constants.CONST_HONORSHOP;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class TUIHonorShopOpenCondition extends TUIComponent
   {
      
      protected static const COUNT_TF_Condition:uint = 2;
      
      protected var FScene:Sprite;
      
      protected var FConditions:Vector.<TextField>;
      
      protected var FShowVect:Vector.<String>;
      
      public function TUIHonorShopOpenCondition(param1:TUIComponent)
      {
         super(param1);
         this.FShowVect = new Vector.<String>();
      }
      
      protected function Resources_UIDispatch(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TextField = null;
         this.FScene = param1;
         this.FScene.mouseEnabled = false;
         this.FScene.mouseChildren = false;
         _loc3_ = int(COUNT_TF_Condition);
         this.FConditions = new Vector.<TextField>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FScene[CONST_HONORSHOP.RESOURCE_Link_TF_Condition + _loc2_];
            _loc4_.text = "";
            _loc4_.mouseEnabled = false;
            this.FConditions[_loc2_] = _loc4_;
            _loc2_++;
         }
      }
      
      protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(COUNT_TF_Condition);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FConditions[_loc1_].text = this.FShowVect[_loc1_];
            _loc1_++;
         }
      }
      
      protected function DoClear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.FConditions != null && this.FConditions.length > 0)
         {
            _loc2_ = int(this.FConditions.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FConditions[_loc1_].text = "";
               _loc1_++;
            }
         }
      }
      
      public function Perform_UIDispatch(param1:Sprite) : void
      {
         this.Resources_UIDispatch(param1);
      }
      
      public function ProcessorUpdateUI(param1:Vector.<String>) : void
      {
         this.FShowVect = param1;
         this.UpdateUI();
      }
      
      public function Show() : void
      {
         this.FScene.visible = true;
      }
      
      public function Hide() : void
      {
         this.FScene.visible = false;
      }
      
      public function Clear() : void
      {
         this.DoClear();
      }
   }
}

