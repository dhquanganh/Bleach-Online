package Processors.Game.Lobby.HellButterfly
{
   import Components.Standard.TUIButton;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.Characters.TCharacter;
   import Logics.Characters.TFriendDigests;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.HellButterfly.THellButterfly;
   import Logics.SLogicsCore;
   import Logics.Vip.TVip;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Resources.Constants.CONST_CONFIGVALUE;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_HELLBUTTERFLY;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorWindowHellButterfly extends TProcessorLobbyWindow
   {
      
      protected var FSP:Sprite;
      
      protected var FBT_Close:SimpleButton;
      
      protected var FBT_OpenFriends:TUIButton;
      
      protected var FBT_CloseFriends:TUIButton;
      
      protected var FMainWindow:TProcessorMainButterfly;
      
      protected var FFriendWindow:TProcessorButterflyFriend;
      
      protected var FConfigValue:TBins;
      
      protected var FNoVipCount:uint;
      
      protected var FHellButterflyData:THellButterfly;
      
      protected var FCharacter:TCharacter;
      
      protected var FIsInitialization:Boolean;
      
      protected var FVipData:TVip;
      
      protected var FIsOpenFriend:Boolean;
      
      protected var FOnSetScence:Function;
      
      public function TProcessorWindowHellButterfly(param1:TUIComponent)
      {
         super(param1);
         this.FHellButterflyData = SLogicsCore.HellButterfly;
         this.FCharacter = SLogicsCore.Character;
         this.FVipData = this.FCharacter.VipData;
         this.FMainWindow = new TProcessorMainButterfly(this);
         this.FFriendWindow = new TProcessorButterflyFriend(this);
         this.FIsInitialization = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_HELLBUTTERFLY.RESOURCESID_HELLBUTTERFLY);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:TConfigValue = null;
         this.FSP = TUtilityReflection.CreateDisplayObjectInstance(CONST_HELLBUTTERFLY.RESOURCE_ClassName_HELLBUTTERFLY) as Sprite;
         this.addChild(this.FSP);
         this.FBT_Close = this.FSP["BTN_Close"];
         this.FBT_OpenFriends = new TUIButton();
         this.FBT_OpenFriends.Substrate = this.FSP["MC_FriendsOpenOrClose"]["MC_OpenFriend"];
         this.FBT_OpenFriends.OnClick = this.OpenFriendsOnClick;
         this.FBT_CloseFriends = new TUIButton();
         this.FBT_CloseFriends.Substrate = this.FSP["MC_FriendsOpenOrClose"]["MC_CloseFriend"];
         this.FBT_CloseFriends.OnClick = this.CloseFriendsOnClick;
         this.FMainWindow.MainInit(this.FSP["MC_Main"]);
         this.FMainWindow.MainReset();
         this.FFriendWindow.FriendInit(this.FSP["MC_SendGoods"]);
         this.FFriendWindow.FriendReset();
         this.FMainWindow.ResetFriendList = this.FFriendWindow.ResetList;
         this.FMainWindow.SameOrganization = this.FFriendWindow.SameOrganizationFriendDigests;
         this.FConfigValue = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         _loc1_ = this.FConfigValue.GetDatebaseByIdentifier(CONST_CONFIGVALUE.HELLBUTTERFLY_NoVipCount) as TConfigValue;
         this.FNoVipCount = _loc1_.Value as uint;
         this.FIsInitialization = true;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FBT_Close.addEventListener(MouseEvent.CLICK,this.CloseOnClick);
         super.ResourcesPerform_UILocations();
      }
      
      override public function set OnEffectText(param1:Function) : void
      {
         super.OnEffectText = param1;
         this.FMainWindow.OnEffectText = param1;
         this.FFriendWindow.OnEffectText = param1;
      }
      
      private function CloseFriendsOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FBT_OpenFriends.Visible = true;
         this.FBT_CloseFriends.Visible = false;
         this.FIsOpenFriend = false;
         this.FFriendWindow.Scence.visible = false;
         if(this.FOnSetScence != null)
         {
            this.FOnSetScence(this.FIsOpenFriend);
         }
      }
      
      private function OpenFriendsOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FBT_CloseFriends.Visible = true;
         this.FBT_OpenFriends.Visible = false;
         this.FIsOpenFriend = true;
         this.FFriendWindow.Scence.visible = true;
         if(this.FOnSetScence != null)
         {
            this.FOnSetScence(this.FIsOpenFriend);
         }
      }
      
      private function CloseOnClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      public function set OnCommunication(param1:Function) : void
      {
         this.FMainWindow.OnCommuincation = param1;
      }
      
      public function set OnEat(param1:Function) : void
      {
         this.FMainWindow.OnEat = param1;
         this.FFriendWindow.OnBatchEat = param1;
      }
      
      public function set OnCollection(param1:Function) : void
      {
         this.FMainWindow.OnFeedCollection = param1;
      }
      
      public function set OnEnterFriend(param1:Function) : void
      {
         this.FFriendWindow.OnEnterFriend = param1;
      }
      
      public function set OnBackMyself(param1:Function) : void
      {
         this.FMainWindow.OnBackMyself = param1;
      }
      
      public function get OnSetScence() : Function
      {
         return this.FOnSetScence;
      }
      
      public function set OnSetScence(param1:Function) : void
      {
         this.FOnSetScence = param1;
      }
      
      public function get SameOrganizationFriendDigests() : TFriendDigests
      {
         return this.FFriendWindow.SameOrganizationFriendDigests;
      }
      
      public function set OnBTMove(param1:Function) : void
      {
         this.FFriendWindow.OnBatchMove = param1;
         this.FMainWindow.OnEatMove = param1;
      }
      
      public function set OnBTOut(param1:Function) : void
      {
         this.FFriendWindow.OnBatchOut = param1;
         this.FMainWindow.OnEatOut = param1;
      }
      
      public function Init(param1:TFriendDigests) : void
      {
         this.FMainWindow.MainUpdate(param1);
         if(this.FHellButterflyData.IsMyself)
         {
            this.FFriendWindow.FriendUpdate(param1);
         }
         this.OpenFriendsOnClick(this,null);
      }
      
      public function UpdateCurCount(param1:uint) : void
      {
         this.FMainWindow.UpdateCurCount(param1);
      }
      
      public function UpdateEat(param1:uint, param2:Boolean) : void
      {
         this.FMainWindow.UpdateEat(param1,param2);
         this.FFriendWindow.UpdateEat(param1);
      }
      
      public function UpdateFeeding() : void
      {
         ++this.FHellButterflyData.CollectionLevel;
         this.FMainWindow.UpdateFeeding(this.FHellButterflyData.CollectionLevel);
      }
      
      public function Reset() : void
      {
         this.FFriendWindow.FriendReset();
         this.FMainWindow.MainReset();
      }
      
      public function SetBTState(param1:Boolean) : void
      {
         this.FSP.mouseEnabled = param1;
         this.FSP.mouseChildren = param1;
      }
      
      public function PlayEffect(param1:Boolean) : void
      {
         this.FMainWindow.PlayEffect(param1);
      }
   }
}

