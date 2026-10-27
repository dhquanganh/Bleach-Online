package Rendering.Overlayers.Title
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.Achievenment.TTitle;
   import Logics.DatebaseVO.VO.TStarPointDesc;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Rendering.Overlayers.TOverlayer;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class TOverlayerTitle extends TOverlayer
   {
      
      protected static const ATTRIBUTENUM:int = 4;
      
      protected var FAttributeNames:Vector.<TextField>;
      
      protected var FAttributeValues:Vector.<TextField>;
      
      protected var FDeploymentName:TextField;
      
      protected var FDeploymentValue:TextField;
      
      protected var FTiteName:TextField;
      
      protected var FTitleID:int;
      
      protected var FDeploymentNames:Vector.<String>;
      
      public function TOverlayerTitle(param1:TUIComponent)
      {
         super(param1);
         FOvarlaySubstrate.visible = false;
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         _loc2_ = TUtilityReflection.CreateDisplayObjectInstance("TitleTip") as Sprite;
         this.addChild(_loc2_);
         this.FAttributeNames = new Vector.<TextField>();
         this.FAttributeValues = new Vector.<TextField>();
         _loc1_ = 0;
         while(_loc1_ < ATTRIBUTENUM)
         {
            this.FAttributeNames.push(_loc2_["Attribute" + _loc1_]);
            this.FAttributeValues.push(_loc2_["Value" + _loc1_]);
            _loc1_++;
         }
         this.FTiteName = _loc2_["TitleName"];
         this.FDeploymentName = _loc2_["Deployment"];
         this.FDeploymentValue = _loc2_["DeploymentValue"];
         this.FDeploymentNames = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.Achievement_String_09);
      }
      
      override protected function ContextVerificate(param1:Object) : Boolean
      {
         return param1 is TTitle;
      }
      
      override protected function ContextModified() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:TTitle = null;
         _loc2_ = FContext as TTitle;
         return this.FTitleID != _loc2_.ID;
      }
      
      override protected function ContextSynchronize() : void
      {
         var _loc1_:TTitle = null;
         _loc1_ = FContext as TTitle;
         this.FTitleID = _loc1_.ID;
      }
      
      override protected function EvaluationPerform_Context() : void
      {
         var _loc1_:TTitle = null;
         _loc1_ = FContext as TTitle;
         this.EvaluationPerform_Title(_loc1_);
      }
      
      protected function EvaluationPerform_Title(param1:TTitle) : void
      {
         var _loc2_:int = 0;
         this.FTiteName.text = param1.Name;
         _loc2_ = 0;
         while(_loc2_ < ATTRIBUTENUM)
         {
            this.FAttributeNames[_loc2_].text = this.CreateAddAttributeName(param1.TitleAttributeType[_loc2_]);
            this.FAttributeValues[_loc2_].text = this.CreateAddAttributeValue(param1.TitleAttributeValue[_loc2_]);
            _loc2_++;
         }
         this.FDeploymentValue.text = this.FDeploymentNames[param1.DepPosition - 1];
      }
      
      protected function CreateAddAttributeName(param1:int) : String
      {
         var _loc2_:TStarPointDesc = null;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_StarPointDesc,17500000 + param1) as TStarPointDesc;
         return _loc2_.Desc;
      }
      
      protected function CreateAddAttributeValue(param1:Number) : String
      {
         var _loc2_:int = 0;
         if(param1 < 1)
         {
            _loc2_ = param1 * 100;
            return "+" + TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Protagonist_STRING_0),_loc2_.toString());
         }
         return "+" + int(param1);
      }
   }
}

