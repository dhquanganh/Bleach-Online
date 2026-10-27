package Processors.Game.Lobby.Home.GirlFriend
{
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Home.GirlFriend.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.text.*;
   
   public class TProcessorWindowGirlFriendBaseInfor extends TProcessorLobbyWindow
   {
      
      protected var FGirlFriend:TGirlFriend;
      
      protected var FTF_GirlDescription:TextField;
      
      protected var FTF_GirlAdded:TextField;
      
      public function TProcessorWindowGirlFriendBaseInfor(param1:TUIComponent)
      {
         super(param1);
         this.FGirlFriend = SLogicsCore.Home.GirlFriend;
      }
      
      protected function UIDispatch_Peform(param1:MovieClip) : void
      {
         addChild(param1);
         this.FTF_GirlDescription = param1["GirlDescription"];
         this.FTF_GirlAdded = param1["GirlAdded"];
      }
      
      protected function UILocation_Peform() : void
      {
      }
      
      public function Update_Perform() : void
      {
         this.FTF_GirlDescription.htmlText = this.FGirlFriend.GirlDescrption;
         this.FTF_GirlAdded.htmlText = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_0),this.FGirlFriend.CanCommunicateTime.toString(),this.FGirlFriend.CanMakeTofuTime.toString(),this.FGirlFriend.MakeTofuAwardNum);
      }
      
      public function UIDispatch(param1:MovieClip) : void
      {
         this.UIDispatch_Peform(param1);
      }
      
      public function UILocation() : void
      {
         this.UILocation_Peform();
      }
      
      public function Update() : void
      {
         this.Update_Perform();
      }
   }
}

