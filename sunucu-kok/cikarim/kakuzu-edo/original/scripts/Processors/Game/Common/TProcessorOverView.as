package Processors.Game.Common
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.TErrorCode;
   import Processors.Game.Common.Effects.Texts.TEffectCoordinateParameters;
   import Processors.Game.Common.Effects.Texts.TEffectTextParameters;
   import Processors.Game.TProcessorGame;
   import Resources.Constants.CONST_DATEBASEVO;
   
   public class TProcessorOverView extends TProcessorGame
   {
      
      protected static const TYPE_EFFECTTEXT:uint = 1;
      
      protected static const TYPE_DIALOGMSG:uint = 2;
      
      protected var FOnEffectText:Function;
      
      protected var FOnEffectHtmlText:Function;
      
      protected var FOnDialogMsg:Function;
      
      public function TProcessorOverView(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function EffectGenerateText(param1:String, param2:TEffectTextParameters = null, param3:TEffectCoordinateParameters = null) : void
      {
         if(this.FOnEffectText != null)
         {
            this.FOnEffectText(this,param1,param2,param3);
         }
      }
      
      protected function EffectGenerateHtmlText(param1:String) : void
      {
         if(this.FOnEffectHtmlText != null)
         {
            this.FOnEffectHtmlText(this,param1);
         }
      }
      
      protected function DialogMsgGenerateText(param1:String) : void
      {
         if(this.FOnDialogMsg != null)
         {
            this.FOnDialogMsg(this,param1);
         }
      }
      
      protected function EffectGenerateTextByErrorCode(param1:uint) : void
      {
         var _loc2_:TBins = null;
         var _loc3_:TErrorCode = null;
         var _loc4_:String = null;
         _loc4_ = null;
         _loc2_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ErrorCode);
         if(_loc2_ != null)
         {
            _loc3_ = _loc2_.GetDatebaseByIdentifier(param1) as TErrorCode;
            if(_loc3_ != null)
            {
               _loc4_ = _loc3_.Desc;
            }
         }
         if(_loc4_ == null)
         {
            _loc4_ = "Error Code: " + param1.toString();
            this.DialogMsgGenerateText(_loc4_);
         }
         if(_loc3_ != null)
         {
            switch(_loc3_.Type)
            {
               case TYPE_EFFECTTEXT:
                  this.EffectGenerateText(_loc4_);
                  break;
               case TYPE_DIALOGMSG:
                  this.DialogMsgGenerateText(_loc4_);
            }
         }
      }
      
      protected function ProcessorsOnEffectText(param1:Object, param2:String, param3:TEffectTextParameters = null, param4:TEffectCoordinateParameters = null) : void
      {
         this.EffectGenerateText(param2,param3,param4);
      }
      
      protected function ProcessorsOnEffectHtmlText(param1:Object, param2:String) : void
      {
         this.EffectGenerateHtmlText(param2);
      }
      
      protected function ProcessorsOnDialogMsg(param1:Object, param2:String) : void
      {
         this.DialogMsgGenerateText(param2);
      }
      
      public function get OnEffectText() : Function
      {
         return this.FOnEffectText;
      }
      
      public function set OnEffectText(param1:Function) : void
      {
         this.FOnEffectText = param1;
      }
      
      public function get OnEffectHtmlText() : Function
      {
         return this.FOnEffectHtmlText;
      }
      
      public function set OnEffectHtmlText(param1:Function) : void
      {
         this.FOnEffectHtmlText = param1;
      }
      
      public function get OnDialogMsg() : Function
      {
         return this.FOnDialogMsg;
      }
      
      public function set OnDialogMsg(param1:Function) : void
      {
         this.FOnDialogMsg = param1;
      }
   }
}

