package Processors.Game.Lobby.Activity.HDMaskFright.Component
{
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class TMaskItem extends TUIComponent
   {
      
      protected var FScene:MovieClip;
      
      protected var FTF_Pay:TextField;
      
      protected var FTF_Income:TextField;
      
      public function TMaskItem(param1:TUIComponent, param2:MovieClip)
      {
         super(param1);
         this.FScene = param2;
      }
      
      protected function MaskItemInit() : void
      {
         this.FTF_Pay = this.FScene[CONST_ACTIVITY.RESOURCE_Link_TF_Pay];
         this.FTF_Income = this.FScene[CONST_ACTIVITY.RESOURCE_Link_TF_Income];
      }
      
      public function Init() : void
      {
         this.MaskItemInit();
      }
      
      public function UpdateItem(param1:String, param2:uint) : void
      {
         this.FTF_Pay.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_16),param1);
         this.FTF_Income.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_17),param2);
      }
      
      public function UpdateState(param1:int) : void
      {
         switch(param1)
         {
            case CONST_ACTIVITY_MODE.Activity_CanNotReceive:
               this.FScene.gotoAndStop(1);
               break;
            case CONST_ACTIVITY_MODE.Activity_AlreadyReceive:
               this.FScene.gotoAndStop(2);
         }
      }
   }
}

