package Processors.Game.Lobby.Home.GirlFriend
{
   import Components.Standard.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Home.GirlFriend.*;
   import Logics.Streamization.Home.*;
   import Processors.Game.Lobby.Common.*;
   import Rendering.Overlayers.Home.*;
   import Resources.Constants.*;
   import Utilities.UI.Overlayers.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowShowAllGirl extends TProcessorLobbyWindow
   {
      
      public static const WINDOW_WIDTH:int = 508;
      
      public static const WINDOW_HEIGHT:int = 419;
      
      protected static const Tab_Num:int = 5;
      
      protected var FGirlFriend:TGirlFriend;
      
      protected var FMainUI:MovieClip;
      
      protected var FTF_CurrentGirlLevel:TextField;
      
      protected var FMC_CurrentGirlPic:MovieClip;
      
      protected var FBitMapCurrentGirlPic:Bitmap;
      
      protected var FMC_CurrentGirlFlg:MovieClip;
      
      protected var FBtn_CurrentGirlChangeShape:TUIButton;
      
      protected var FTF_NextGirlLevel:TextField;
      
      protected var FMC_NextGirlPic:MovieClip;
      
      protected var FBitMapNextGirlPic:Bitmap;
      
      protected var FMC_NextGirlFlg:MovieClip;
      
      protected var FBtn_NextGirlChangeShape:TUIButton;
      
      protected var FUITab:TUITab;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FUnstreamizerGirlFriend:TUnstreamizerGirlFriend;
      
      protected var FGirlFriends:Vector.<TGirlFriend>;
      
      protected var FLeftGirlFriends:TGirlFriend;
      
      protected var FRightGirlFriends:TGirlFriend;
      
      protected var FOverlayerGirlFriend:TOverlayerGirlFriend;
      
      public function TProcessorWindowShowAllGirl(param1:TUIComponent)
      {
         super(param1);
         this.FGirlFriend = SLogicsCore.Home.GirlFriend;
         this.FGirlFriends = new Vector.<TGirlFriend>();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("UIGirlFriend") as MovieClip;
         this.CurrentGirlUIDispatch();
         this.NextGirlUIDispatch();
         this.StuffUIDispatch();
         this.InitGirlFriend();
         addChild(this.FMainUI);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.CurrentGirlUILocation();
         this.NextGirlUILocation();
         this.StuffUILocation();
         super.ResourcesPerform_UILocations();
      }
      
      protected function CurrentGirlUIDispatch() : void
      {
         this.FMC_CurrentGirlPic = this.FMainUI["CurrentGirlPic"];
         this.FTF_CurrentGirlLevel = this.FMC_CurrentGirlPic["MCLevel"]["Name"];
         this.FMC_CurrentGirlFlg = this.FMC_CurrentGirlPic["CurrentGirlFlag"];
         this.FBitMapCurrentGirlPic = new Bitmap();
         this.FMC_CurrentGirlPic["MC_Image"].addChild(this.FBitMapCurrentGirlPic);
         this.FBtn_CurrentGirlChangeShape = new TUIButton();
         this.FBtn_CurrentGirlChangeShape.Substrate = this.FMC_CurrentGirlPic["BtnChangeShape"];
      }
      
      protected function CurrentGirlUILocation() : void
      {
         this.FBtn_CurrentGirlChangeShape.OnClick = this.CurrentGirlChangeShapeClick;
         this.FMC_CurrentGirlPic.addEventListener(MouseEvent.MOUSE_MOVE,this.LeftGirlOnMouseOver);
         this.FMC_CurrentGirlPic.addEventListener(MouseEvent.MOUSE_OUT,this.GirlOnMouseOut);
      }
      
      protected function NextGirlUIDispatch() : void
      {
         this.FMC_NextGirlPic = this.FMainUI["NextGirlPic"];
         this.FTF_NextGirlLevel = this.FMC_NextGirlPic["MCLevel"]["Name"];
         this.FMC_NextGirlFlg = this.FMC_NextGirlPic["CurrentGirlFlag"];
         this.FBitMapNextGirlPic = new Bitmap();
         this.FMC_NextGirlPic["MC_Image"].addChild(this.FBitMapNextGirlPic);
         this.FBtn_NextGirlChangeShape = new TUIButton();
         this.FBtn_NextGirlChangeShape.Substrate = this.FMC_NextGirlPic["BtnChangeShape"];
      }
      
      protected function NextGirlUILocation() : void
      {
         this.FBtn_NextGirlChangeShape.OnClick = this.NextGirlChangeShapeClick;
         this.FMC_NextGirlPic.addEventListener(MouseEvent.MOUSE_MOVE,this.RightGirlOnMouseOver);
         this.FMC_NextGirlPic.addEventListener(MouseEvent.MOUSE_OUT,this.GirlOnMouseOut);
      }
      
      protected function StuffUIDispatch() : void
      {
         var _loc1_:int = 0;
         this.FUITab = new TUITab(this);
         this.FUITab.OnSwitch = this.TabSwitch;
         _loc1_ = 0;
         while(_loc1_ < Tab_Num)
         {
            this.FUITab.SetTabByIndex(this.FMainUI["Tab" + _loc1_],_loc1_);
            _loc1_++;
         }
         this.FUITab.Init();
         this.FBtn_Close = this.FMainUI["BTN_Close"];
         this.FUnstreamizerGirlFriend = new TUnstreamizerGirlFriend();
         this.FOverlayerGirlFriend = new TOverlayerGirlFriend(FParent.Parent);
         this.FOverlayerGirlFriend.Visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerGirlFriend);
      }
      
      protected function StuffUILocation() : void
      {
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.OnBtnCloseClick);
      }
      
      protected function Update_Perform() : void
      {
         this.Update_CurrentGirl();
         this.Update_NextGirl();
         this.Update_Stuff();
      }
      
      protected function Update_CurrentGirl() : void
      {
         if(this.FLeftGirlFriends.ID > this.FGirlFriend.ID)
         {
            this.FBitMapCurrentGirlPic.filters = [TUtilityFilter.GaryColorFiltersThree];
            this.FBtn_CurrentGirlChangeShape.Visible = false;
         }
         else
         {
            this.FBitMapCurrentGirlPic.filters = null;
            this.FBtn_CurrentGirlChangeShape.Visible = true;
         }
         if(this.FGirlFriend.CurrentChangeShapeGirlID == this.FLeftGirlFriends.ID)
         {
            this.FBtn_CurrentGirlChangeShape.Visible = false;
         }
         this.FTF_CurrentGirlLevel.text = this.FLeftGirlFriends.Name;
         this.FMC_CurrentGirlFlg.visible = this.FGirlFriend.CurrentChangeShapeGirlID == this.FLeftGirlFriends.ID;
         this.FBitMapCurrentGirlPic.bitmapData = null;
         SResourcesCore.TexturesMiddlePic.LoadAutoSecondary(this.FLeftGirlFriends.ImageID,this.ResourceSendInterface);
      }
      
      protected function Update_NextGirl() : void
      {
         if(this.FRightGirlFriends.ID > this.FGirlFriend.ID)
         {
            this.FBitMapNextGirlPic.filters = [TUtilityFilter.GaryColorFiltersThree];
            this.FBtn_NextGirlChangeShape.Visible = false;
         }
         else
         {
            this.FBitMapNextGirlPic.filters = null;
            this.FBtn_NextGirlChangeShape.Visible = true;
         }
         if(this.FGirlFriend.CurrentChangeShapeGirlID == this.FRightGirlFriends.ID)
         {
            this.FBtn_NextGirlChangeShape.Visible = false;
         }
         this.FTF_NextGirlLevel.text = this.FRightGirlFriends.Name;
         this.FMC_NextGirlFlg.visible = this.FGirlFriend.CurrentChangeShapeGirlID == this.FRightGirlFriends.ID;
         this.FBitMapNextGirlPic.bitmapData = null;
         SResourcesCore.TexturesMiddlePic.LoadAutoSecondary(this.FRightGirlFriends.ImageID,this.ResourceSendInterface);
      }
      
      protected function Update_Stuff() : void
      {
      }
      
      protected function InitGirlFriend() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TBins = null;
         var _loc3_:TGirlFriend = null;
         this.FGirlFriends = new Vector.<TGirlFriend>();
         _loc2_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_HomeGirlFriend);
         _loc1_ = 0;
         while(_loc1_ < _loc2_.Count)
         {
            _loc3_ = new TGirlFriend();
            _loc3_.ID = _loc2_.GetDatebaseByIndex(_loc1_).Identifier;
            this.FUnstreamizerGirlFriend.Unstreamization_GirlFriendByDatabase(_loc3_,null);
            this.FGirlFriends.push(_loc3_);
            _loc1_++;
         }
      }
      
      protected function ResourceSendInterface(param1:Object, param2:TTexture, param3:uint) : void
      {
         if(param3 == this.FLeftGirlFriends.ImageID)
         {
            this.FBitMapCurrentGirlPic.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
         }
         else if(param3 == this.FRightGirlFriends.ImageID)
         {
            this.FBitMapNextGirlPic.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
         }
      }
      
      protected function TabSwitch(param1:int) : void
      {
         this.FLeftGirlFriends = this.FGirlFriends[param1 * 2 + 0];
         this.FRightGirlFriends = this.FGirlFriends[param1 * 2 + 1];
         this.Update();
      }
      
      protected function OnBtnCloseClick(param1:MouseEvent) : void
      {
         this.visible = false;
         this.FUITab.SwithTagManual(0);
      }
      
      protected function CurrentGirlChangeShapeClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Home_GirlFriendChangeShapeReq);
         _loc3_.Data.writeUnsignedInt(this.FLeftGirlFriends.ID);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function NextGirlChangeShapeClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Home_GirlFriendChangeShapeReq);
         _loc3_.Data.writeUnsignedInt(this.FRightGirlFriends.ID);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function LeftGirlOnMouseOver(param1:MouseEvent) : void
      {
         this.UIComponentsHintOnOver(this,this.FLeftGirlFriends);
      }
      
      protected function RightGirlOnMouseOver(param1:MouseEvent) : void
      {
         this.UIComponentsHintOnOver(this,this.FRightGirlFriends);
      }
      
      protected function GirlOnMouseOut(param1:MouseEvent) : void
      {
         this.UIComponentsHintOnOut(this);
      }
      
      protected function UIComponentsHintOnOver(param1:Object, param2:TGirlFriend) : void
      {
         this.FOverlayerGirlFriend.Context = param2;
         this.FOverlayerGirlFriend.Render(FUICore.MouseCoordinate);
         this.FOverlayerGirlFriend.Show();
      }
      
      protected function UIComponentsHintOnOut(param1:Object) : void
      {
         this.FOverlayerGirlFriend.Hide();
      }
      
      public function set GirlFriend(param1:TGirlFriend) : void
      {
         this.FGirlFriend = param1;
      }
      
      public function Update() : void
      {
         if(this.FLeftGirlFriends == null)
         {
            this.FUITab.SwithTagManual(0);
            return;
         }
         this.Update_Perform();
      }
      
      public function Reset() : void
      {
         if(this.FBitMapCurrentGirlPic != null)
         {
            this.FBitMapCurrentGirlPic.bitmapData = null;
            this.FBitMapNextGirlPic.bitmapData = null;
         }
      }
   }
}

