package Processors.Game.Lobby.Mentorship.Components
{
   import Components.Standard.TUIButton;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Mentorship.Elements.*;
   import Processors.Game.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import Utilities.Timing.TUtilityTiming;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TUIArrestItem extends TProcessorGame
   {
      
      protected const IDENTITY_Freedom:uint = 0;
      
      protected const IDENTITY_Master:uint = 1;
      
      protected const IDENTITY_Disciple:uint = 2;
      
      protected const FRAME_Normal:uint = 1;
      
      protected const FRAME_Over:uint = 2;
      
      protected var FTF_Name:TextField;
      
      protected var FTF_Level:TextField;
      
      protected var FTF_CurStatus:TextField;
      
      protected var FTF_DynamicText:TextField;
      
      protected var FTF_InteractionCDTime:TextField;
      
      protected var FMC_DynamicButton:TUIButton;
      
      protected var FTF_Command:TextField;
      
      protected var FName:String;
      
      protected var FLevel:uint;
      
      protected var FCurStatus:uint;
      
      protected var FDynamicText:String;
      
      protected var FInteractionCDTime:uint;
      
      protected var FCommand:String;
      
      protected var FDiscipleCount:uint;
      
      protected var FHasSOS:uint;
      
      protected var FObj:Object;
      
      protected var FResource:MovieClip;
      
      protected var FOnDynamicFunction:Function;
      
      public function TUIArrestItem(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         if(!this.Parent.Visible)
         {
            return;
         }
         if(this.Parent.Parent != null)
         {
            if(!this.Parent.Parent.Visible)
            {
               return;
            }
         }
         _loc1_ = uint(STimingCore.ServerTick);
         _loc2_ = this.FInteractionCDTime - _loc1_;
         if(this.FInteractionCDTime != 0)
         {
            if(_loc2_ >= 0)
            {
               this.FMC_DynamicButton.Visible = false;
               this.FTF_InteractionCDTime.visible = true;
               this.FTF_InteractionCDTime.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MENTORSHIP_STRING_03) + " " + TUtilityTiming.fomatTime(_loc2_);
            }
            else
            {
               this.FTF_InteractionCDTime.visible = false;
               this.FMC_DynamicButton.Visible = true;
            }
         }
         super.LogicsPerform();
      }
      
      protected function UIDispatch() : void
      {
         this.FTF_Name = this.FResource[CONST_MENTORSHIP.RESOURCE_Link_TF_Name];
         this.FTF_Level = this.FResource[CONST_MENTORSHIP.RESOURCE_Link_TF_Level];
         this.FTF_CurStatus = this.FResource[CONST_MENTORSHIP.RESOURCE_Link_TF_CurStatus];
         this.FTF_DynamicText = this.FResource[CONST_MENTORSHIP.RESOURCE_Link_TF_DynamicText];
         this.FTF_InteractionCDTime = this.FResource[CONST_MENTORSHIP.RESOURCE_Link_TF_InteractionCDTime];
         this.FMC_DynamicButton = new TUIButton();
         this.FMC_DynamicButton.Substrate = this.FResource[CONST_MENTORSHIP.RESOURCE_Link_MC_DynamicButton];
         this.FMC_DynamicButton.OnClick = this.MCDynamicButtonOnClick;
         this.FTF_Command = this.FMC_DynamicButton.Substrate[CONST_MENTORSHIP.RESOURCE_Link_TF_Command];
      }
      
      protected function UILocation() : void
      {
         this.FResource.addEventListener(MouseEvent.MOUSE_OVER,this.MCOnOver,false,0,true);
         this.FResource.addEventListener(MouseEvent.MOUSE_OUT,this.MCOnOut,false,0,true);
      }
      
      protected function UpdateInfo() : void
      {
         this.FTF_Name.text = this.FName;
         this.FTF_Level.text = this.FLevel.toString();
         this.FTF_DynamicText.text = this.FDynamicText;
         switch(this.FCurStatus)
         {
            case this.IDENTITY_Freedom:
               this.FTF_CurStatus.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MENTORSHIP_STRING_28);
               break;
            case this.IDENTITY_Master:
               this.FTF_CurStatus.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MENTORSHIP_STRING_01) + TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MENTORSHIP_STRING_21),this.FDiscipleCount);
               break;
            case this.IDENTITY_Disciple:
               this.FTF_CurStatus.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MENTORSHIP_STRING_02);
         }
         if(this.FInteractionCDTime == 0)
         {
            if(this.FObj is TSOSPlayer)
            {
               if(uint(this.FHasSOS))
               {
                  this.FTF_InteractionCDTime.visible = true;
                  this.FMC_DynamicButton.Visible = false;
                  this.FTF_InteractionCDTime.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MENTORSHIP_STRING_09);
               }
               else
               {
                  this.FTF_InteractionCDTime.visible = false;
                  this.FMC_DynamicButton.Visible = true;
               }
            }
            else
            {
               this.FTF_InteractionCDTime.visible = false;
               this.FMC_DynamicButton.Visible = true;
            }
         }
      }
      
      protected function MCDynamicButtonOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnDynamicFunction != null)
         {
            this.FOnDynamicFunction(this,this.FObj);
         }
      }
      
      protected function MCOnOver(param1:MouseEvent) : void
      {
         this.FResource.gotoAndStop(this.FRAME_Over);
      }
      
      protected function MCOnOut(param1:MouseEvent) : void
      {
         this.FResource.gotoAndStop(this.FRAME_Normal);
      }
      
      public function get Resource() : MovieClip
      {
         return this.FResource;
      }
      
      public function set Resource(param1:MovieClip) : void
      {
         this.FResource = param1;
      }
      
      public function get OnDynamicFunction() : Function
      {
         return this.FOnDynamicFunction;
      }
      
      public function set OnDynamicFunction(param1:Function) : void
      {
         this.FOnDynamicFunction = param1;
      }
      
      public function Init() : void
      {
         this.UIDispatch();
         this.UILocation();
      }
      
      public function Update(param1:Object) : void
      {
         var _loc2_:TArrestPlayer = null;
         var _loc3_:TRescuePlayer = null;
         var _loc4_:TSOSPlayer = null;
         if(param1 is TArrestPlayer)
         {
            _loc2_ = param1 as TArrestPlayer;
            this.FObj = param1 as TArrestPlayer;
            this.FName = _loc2_.Name;
            this.FLevel = _loc2_.Level;
            this.FCurStatus = _loc2_.Identity;
            this.FDynamicText = _loc2_.GuildName;
            this.FInteractionCDTime = _loc2_.InteractionCDTime;
            this.FDiscipleCount = _loc2_.DiscipleCount;
         }
         else if(param1 is TRescuePlayer)
         {
            _loc3_ = param1 as TRescuePlayer;
            this.FObj = param1 as TRescuePlayer;
            this.FName = _loc3_.Name;
            this.FLevel = _loc3_.Level;
            this.FCurStatus = this.IDENTITY_Disciple;
            this.FDynamicText = _loc3_.MasterName;
            this.FInteractionCDTime = _loc3_.InteractionCDTime;
            this.FTF_Command.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MENTORSHIP_STRING_05);
         }
         else if(param1 is TSOSPlayer)
         {
            _loc4_ = param1 as TSOSPlayer;
            this.FObj = param1 as TSOSPlayer;
            this.FName = _loc4_.Name;
            this.FLevel = _loc4_.Level;
            this.FCurStatus = _loc4_.Identity;
            this.FDynamicText = _loc4_.GuildName;
            this.FDiscipleCount = _loc4_.DiscipleCount;
            this.FHasSOS = _loc4_.HasSOS;
            this.FTF_Command.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MENTORSHIP_STRING_06);
         }
         this.UpdateInfo();
      }
   }
}

