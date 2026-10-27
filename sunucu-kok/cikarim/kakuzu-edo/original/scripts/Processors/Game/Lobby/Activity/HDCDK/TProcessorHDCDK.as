package Processors.Game.Lobby.Activity.HDCDK
{
   import Components.Standard.TUIButton;
   import Foundation.Common.TBounds;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_NETWORK;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class TProcessorHDCDK extends TProcessorLobbyWindows
   {
      
      protected static const SIZE_WIDTH_CDK:uint = 482;
      
      protected static const SIZE_HIGHT_CDK:uint = 390;
      
      protected static const CDK_LENGTH_24:uint = 24;
      
      protected static const CDK_LENGTH_9:uint = 9;
      
      protected var FMC:Sprite;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FBtn_OK:TUIButton;
      
      protected var FTF_Input:TextField;
      
      protected var FMC_Prompt:Sprite;
      
      protected var FTF_Prompt:TextField;
      
      protected var FBounds:TBounds;
      
      public function TProcessorHDCDK(param1:TUIComponent, param2:TLobbyParameters = null)
      {
         super(param1,param2);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityCDK);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.InitWindow();
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         super.PacketRegisterRoutines();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.OnCloseWindowHandler,false,0,true);
         this.FTF_Input.addEventListener(Event.CHANGE,this.OnTextInput,false,0,true);
      }
      
      protected function InitWindow() : void
      {
         this.FMC = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACTIVITY.RESOURCE_ClassName_Activity_CDK) as Sprite;
         addChild(this.FMC);
         this.FBtn_Close = this.FMC[CONST_ACTIVITY.RESOURCE_Link_BTN_Close];
         this.FTF_Input = this.FMC[CONST_ACTIVITY.RESOURCE_Link_TF_Input];
         this.FTF_Input.restrict = "a-zA-Z0-9\\-";
         this.FTF_Input.maxChars = 30;
         this.FTF_Input.text = "";
         this.FBtn_OK = new TUIButton();
         this.FBtn_OK.Substrate = this.FMC[CONST_ACTIVITY.RESOURCE_Link_BTN_OK];
         this.FBtn_OK.OnClick = this.BtnOKOnClick;
         this.FBtn_OK.Enabled = false;
         this.FMC_Prompt = this.FMC[CONST_ACTIVITY.RESOURCE_Link_MC_Prompt];
         this.FTF_Prompt = this.FMC_Prompt[CONST_ACTIVITY.RESOURCE_Link_TF_Prompt];
         this.FMC_Prompt.visible = false;
         this.FBounds = new TBounds();
         this.FBounds.Width = SIZE_WIDTH_CDK;
         this.FBounds.Height = SIZE_HIGHT_CDK;
         ComponentBoundsCenter(this,this.FBounds);
      }
      
      protected function UpdateUI() : void
      {
         this.FBtn_OK.Enabled = false;
         this.FTF_Input.text = "";
         this.FMC_Prompt.visible = false;
         if(FUICore.UIStage.focus != this.FTF_Input)
         {
            FUICore.UIStage.focus = this.FTF_Input;
         }
      }
      
      protected function CheckCDK() : Boolean
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         _loc1_ = this.FTF_Input.text;
         _loc2_ = _loc1_.length;
         if(_loc2_ == CDK_LENGTH_24)
         {
            _loc5_ = "";
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc5_ = _loc1_.charAt(_loc3_);
               if((_loc3_ + 1) % 5 == 0)
               {
                  if(_loc5_ != "-")
                  {
                     return false;
                  }
               }
               else if(_loc5_ == "-")
               {
                  return false;
               }
               _loc3_++;
            }
            return true;
         }
         if(_loc2_ == CDK_LENGTH_9)
         {
            return true;
         }
         return false;
      }
      
      protected function OnCloseWindowHandler(param1:MouseEvent) : void
      {
         ProcessorClose();
      }
      
      protected function BtnOKOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:String = null;
         if(!this.CheckCDK())
         {
            this.FMC_Prompt.visible = true;
            return;
         }
         if(this.FMC_Prompt.visible)
         {
            this.FMC_Prompt.visible = false;
         }
         this.FBtn_OK.Enabled = false;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Activity_CDKReq);
         _loc4_ = this.FTF_Input.text.toString();
         TUtilityString.FlushUTF(_loc3_.Data,_loc4_);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function OnTextInput(param1:Event) : void
      {
         if(this.FTF_Input.text.length > 0)
         {
            this.FBtn_OK.Enabled = true;
         }
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
         this.UpdateUI();
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
      }
      
      public function CDKRet() : void
      {
         this.UpdateUI();
      }
   }
}

