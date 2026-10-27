package Processors.Game.Lobby.Activity.HDActivityOS.Component
{
   import Foundation.UI.TUIComponent;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_CURSOR;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class TUIActivityOSDARankList extends TUIComponent
   {
      
      public static const MOUSECURSOR_AUTO:String = CONST_CURSOR.MOUSECURSOR_AUTO;
      
      public static const MOUSECURSOR_BUTTON:String = CONST_CURSOR.MOUSECURSOR_BUTTON;
      
      protected var FMC_Main:Sprite;
      
      protected var FTextCount:int;
      
      protected var FTextVect:Vector.<TextField>;
      
      protected var FMC_Prompt:MovieClip;
      
      protected var FTextFormat:TextFormat;
      
      protected var FListIndex:int;
      
      protected var FLinkIndex:int;
      
      protected var FOnLookInfo:Function;
      
      public function TUIActivityOSDARankList(param1:TUIComponent)
      {
         super(param1);
         this.FListIndex = -1;
         this.FLinkIndex = -1;
         this.FTextFormat = new TextFormat();
         this.FTextFormat.underline = true;
      }
      
      protected function Resources_UIDispatch(param1:Sprite, param2:Boolean = false, param3:int = -1) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TextField = null;
         this.FMC_Main = param1;
         this.FLinkIndex = param3;
         _loc5_ = this.FTextCount;
         this.FTextVect = new Vector.<TextField>(_loc5_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = this.FMC_Main[CONST_ACTIVITY.RESOURCE_Link_TF_Prompt + _loc4_];
            _loc6_.text = "";
            if(_loc4_ != param3)
            {
               _loc6_.mouseEnabled = false;
            }
            this.FTextVect[_loc4_] = _loc6_;
            _loc4_++;
         }
         this.FMC_Prompt = this.FMC_Main[CONST_ACTIVITY.RESOURCE_Link_MC_Prompt];
         if(this.FMC_Prompt != null)
         {
            this.FMC_Prompt.mouseEnabled = false;
            this.FMC_Prompt.mouseChildren = false;
            this.FMC_Prompt.gotoAndStop(0);
            this.FMC_Prompt.visible = false;
         }
         if(param3 != -1)
         {
            this.FTextVect[param3].addEventListener(MouseEvent.CLICK,this.SceneOnClick);
            this.FTextVect[param3].addEventListener(MouseEvent.MOUSE_MOVE,this.SceneOnMove);
            this.FTextVect[param3].addEventListener(MouseEvent.MOUSE_OUT,this.SceneOnOut);
         }
      }
      
      protected function UpdateUI(param1:Vector.<String>, param2:int = -1) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param2 != 0 && this.FMC_Prompt != null)
         {
            this.FMC_Prompt.gotoAndStop(param2);
            this.FMC_Prompt.visible = true;
         }
         else
         {
            this.FMC_Prompt.visible = false;
         }
         _loc4_ = int(param1.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(param1[_loc3_] == null || param1[_loc3_] == "")
            {
               this.FTextVect[_loc3_].text = "";
            }
            else
            {
               this.FTextVect[_loc3_].text = param1[_loc3_];
               if(_loc3_ == this.FLinkIndex)
               {
                  this.FTextVect[_loc3_].setTextFormat(this.FTextFormat);
               }
            }
            _loc3_++;
         }
      }
      
      protected function UpdateTF(param1:String, param2:int) : void
      {
         this.FTextVect[param2].text = param1;
      }
      
      protected function DoClear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.FTextVect == null)
         {
            return;
         }
         _loc2_ = int(this.FTextVect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTextVect[_loc1_].text = "";
            _loc1_++;
         }
         if(this.FMC_Prompt != null)
         {
            this.FMC_Prompt.visible = false;
         }
      }
      
      protected function SceneOnClick(param1:MouseEvent) : void
      {
         if(this.FTextVect[this.FLinkIndex].text == "")
         {
            return;
         }
         if(this.FOnLookInfo != null)
         {
            this.FOnLookInfo(this,this.FListIndex);
         }
      }
      
      protected function SceneOnMove(param1:MouseEvent) : void
      {
         if(this.FTextVect[this.FLinkIndex].text == "")
         {
            return;
         }
         FUICore.MouseSetCursor(MOUSECURSOR_BUTTON);
      }
      
      protected function SceneOnOut(param1:MouseEvent) : void
      {
         if(this.FTextVect[this.FLinkIndex].text == "")
         {
            return;
         }
         FUICore.MouseSetCursor(MOUSECURSOR_AUTO);
      }
      
      public function get OnLookInfo() : Function
      {
         return this.FOnLookInfo;
      }
      
      public function set OnLookInfo(param1:Function) : void
      {
         this.FOnLookInfo = param1;
      }
      
      public function Perform_UIDispatch(param1:int, param2:Sprite, param3:int, param4:int = -1, param5:Boolean = false) : void
      {
         this.FListIndex = param1;
         this.FTextCount = param3;
         this.Resources_UIDispatch(param2,param5,param4);
      }
      
      public function ProcessorUpdateUI(param1:Vector.<String>, param2:int = -1) : void
      {
         this.UpdateUI(param1,param2);
      }
      
      public function ProcessorUpdateTF(param1:String, param2:int) : void
      {
         this.UpdateTF(param1,param2);
      }
      
      public function Clear() : void
      {
         this.DoClear();
      }
   }
}

