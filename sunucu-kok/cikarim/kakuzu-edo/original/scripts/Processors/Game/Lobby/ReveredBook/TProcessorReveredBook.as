package Processors.Game.Lobby.ReveredBook
{
   import Foundation.Common.TBounds;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_FRESHGUIDE;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_REVEREDBOOK;
   import Resources.Constants.CONST_SHORTCUTS;
   import flash.utils.ByteArray;
   
   public class TProcessorReveredBook extends TProcessorLobbyWindows
   {
      
      protected static const WINDOW_WIDTH:int = 673;
      
      protected static const WINDOW_HEIGHT:int = 537;
      
      protected var FWindowReveredBook:TWindowReveredBook;
      
      protected var FBoundsReveredBook:TBounds;
      
      protected var FOnShowEffectNotification:Function;
      
      public function TProcessorReveredBook(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FWindowReveredBook = new TWindowReveredBook(this);
         this.FWindowReveredBook.OnClose = this.SubWindowClose;
         this.FBoundsReveredBook = new TBounds();
         this.FBoundsReveredBook.Width = WINDOW_WIDTH;
         this.FBoundsReveredBook.Height = WINDOW_HEIGHT;
         ComponentBoundsCenter(this.FWindowReveredBook,this.FBoundsReveredBook);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_REVEREDBOOK.RESOURCESID_ReveredBook);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         super.PacketRegisterRoutines();
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_ReveredBook_BaseInfor,this.PerformPacket_SC_ReveredBook_BaseInfor);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_ReveredBook_QuestionRet,this.PerformPacket_SC_AnswerQustionNotify);
      }
      
      protected function PerformPacket_SC_ReveredBook_BaseInfor(param1:TPacket) : void
      {
         SLogicsCore.Character.GirlClothesID = param1.Data.readUnsignedInt();
         this.FWindowReveredBook.QustionID = param1.Data.readUnsignedInt();
         this.CheckIfFlashIcon();
      }
      
      protected function PerformPacket_SC_AnswerQustionNotify(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         _loc2_ = int(param1.Data.readUnsignedInt());
         param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FWindowReveredBook.AnswerQustionNotify();
         SToolReward.ShowReward(param1.Data);
         this.CheckIfFlashIcon();
      }
      
      protected function CheckIfFlashIcon() : void
      {
         var _loc1_:Boolean = false;
         _loc1_ = this.FWindowReveredBook.IfHaveQuestionCanAnswer();
         if(this.FOnShowEffectNotification != null)
         {
            this.FOnShowEffectNotification(CONST_SHORTCUTS.POSITION_MainFunction,CONST_SHORTCUTS.TYPE_MainFunction_ReveredBook,_loc1_);
         }
      }
      
      protected function SubWindowClose(param1:Object) : void
      {
         ProcessorClose();
      }
      
      public function set OnShowEffectNotification(param1:Function) : void
      {
         this.FOnShowEffectNotification = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FWindowReveredBook.Load();
            return;
         }
         if(this.FWindowReveredBook.IfHaveQuestionCanAnswer())
         {
            this.FWindowReveredBook.ShowTabByIndex(2);
         }
         else
         {
            this.FWindowReveredBook.ShowTabByIndex(0);
         }
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_OpenReveredBook);
         this.FWindowReveredBook.Visible = true;
      }
      
      override public function Unmount() : void
      {
         this.FWindowReveredBook.Reset();
         this.CheckIfFlashIcon();
         super.Unmount();
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_CloseReveredBook);
      }
      
      public function RoleLevelUpNotify() : void
      {
         this.CheckIfFlashIcon();
      }
   }
}

