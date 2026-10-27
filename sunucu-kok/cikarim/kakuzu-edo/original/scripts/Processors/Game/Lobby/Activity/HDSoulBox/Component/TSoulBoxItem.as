package Processors.Game.Lobby.Activity.HDSoulBox.Component
{
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Processors.Game.Lobby.Activity.HDActivityOS.Component.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.text.*;
   
   public class TSoulBoxItem extends TUIActivityOSAwardList
   {
      
      protected var FTF_StateDesc:TextField;
      
      protected var FTF_RemainlCount:TextField;
      
      protected var FTimer:int;
      
      protected var FIsPassed:Boolean;
      
      protected var FCanGet:Boolean;
      
      public function TSoulBoxItem(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function Resources_UIDispatch(param1:Sprite, param2:Boolean = true) : void
      {
         super.Resources_UIDispatch(param1,param2);
         this.FTF_StateDesc = FMC[CONST_ACTIVITY.RESOURCE_Link_TF_StateDesc];
         this.FTF_RemainlCount = FMC[CONST_ACTIVITY.RESOURCE_Link_TF_RemainCount];
      }
      
      protected function UpdateBoxItemState() : void
      {
         if(FBtn_OK == null)
         {
            return;
         }
         if(FAwardBoxStatus == Activity_CanNotReceive)
         {
            if(this.FIsPassed)
            {
               FBtn_OK.Visible = false;
               this.FTF_StateDesc.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_23);
               this.FTF_StateDesc.visible = true;
               this.FTF_RemainlCount.visible = false;
            }
            else
            {
               FBtn_OK.Visible = true;
               FBtn_OK.Enabled = false;
               this.FTF_StateDesc.visible = false;
               this.FTF_RemainlCount.visible = false;
            }
         }
         else if(FAwardBoxStatus >= Activity_CanReceive)
         {
            if(this.FCanGet)
            {
               FBtn_OK.Visible = true;
               FBtn_OK.Enabled = true;
               this.FTF_StateDesc.visible = false;
               this.FTF_RemainlCount.visible = false;
            }
            else
            {
               FBtn_OK.Visible = false;
               this.FTF_StateDesc.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_25);
               this.FTF_StateDesc.visible = true;
               this.FTF_RemainlCount.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_28),FAwardBoxStatus);
               this.FTF_RemainlCount.visible = true;
            }
         }
         else if(FAwardBoxStatus == Activity_AlreadyReceive)
         {
            FBtn_OK.Visible = false;
            this.FTF_StateDesc.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_24);
            this.FTF_StateDesc.visible = true;
            this.FTF_RemainlCount.visible = false;
         }
      }
      
      public function get IsPassed() : Boolean
      {
         return this.FIsPassed;
      }
      
      public function set IsPassed(param1:Boolean) : void
      {
         this.FIsPassed = param1;
      }
      
      public function get CanGet() : Boolean
      {
         return this.FCanGet;
      }
      
      public function set CanGet(param1:Boolean) : void
      {
         this.FCanGet = param1;
      }
      
      public function UpdateItemState(param1:int) : void
      {
         FAwardBoxStatus = param1;
         this.UpdateBoxItemState();
      }
   }
}

