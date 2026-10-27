package Processors.Game.Lobby.Mentorship.Components
{
   import Components.Standard.TUIButton;
   import Foundation.Resources.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Mentorship.Elements.*;
   import Processors.Game.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Utilities.Timing.TUtilityTiming;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TDiscipleStatus extends TProcessorGame
   {
      
      public static const STAGE_Width:Number = CONST_COMMON.STAGE_Width;
      
      public static const STAGE_Height:Number = CONST_COMMON.STAGE_Height;
      
      protected var FHeroInfo:THeroInfo;
      
      protected var FMC_InteractionCDTime:Sprite;
      
      protected var FTF_InteractionCDTime:TextField;
      
      protected var FBTN_Interaction:TUIButton;
      
      protected var FMC_Bg:MovieClip;
      
      protected var FMC_Operation:Sprite;
      
      protected var FMC_WorkExp:Sprite;
      
      protected var FTF_WorkTime:TextField;
      
      protected var FTF_GetEXP:TextField;
      
      protected var FBTN_Draw:TUIButton;
      
      protected var FBTN_Squeeze:TUIButton;
      
      protected var FBTN_DrawAll:TUIButton;
      
      protected var FBTN_Release:TUIButton;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FDisciple:TDisciple;
      
      protected var FInitialized:Boolean;
      
      protected var FDrawTime:uint;
      
      protected var FCommandType:uint;
      
      protected var FResource:MovieClip;
      
      protected var FOnInteraction:Function;
      
      protected var FOnDrawExp:Function;
      
      protected var FOnRelease:Function;
      
      protected var FOnEffectGenerateText:Function;
      
      protected var FOnWatchOhterPlayerInfo:Function;
      
      public function TDiscipleStatus(param1:TUIComponent)
      {
         super(param1);
         this.FInitialized = false;
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TSlaveGainExp = null;
         var _loc5_:int = 0;
         var _loc6_:TConfigValue = null;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         if(!this.Parent.Visible)
         {
            return;
         }
         if(this.FDisciple == null)
         {
            return;
         }
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Slave_InteractionCDTime) as TConfigValue;
         _loc3_ = uint(STimingCore.ServerTick);
         _loc1_ = this.FDisciple.InteractionCDTime + uint(_loc6_.Value) * 60;
         _loc2_ = this.FDisciple.StartWorkTime;
         if(this.FInitialized)
         {
            _loc5_ = _loc1_ - _loc3_;
            if(_loc5_ < 0)
            {
               if(this.FMC_InteractionCDTime.visible)
               {
                  this.FMC_InteractionCDTime.visible = false;
                  this.FBTN_Interaction.Visible = true;
               }
            }
            else
            {
               if(!this.FMC_InteractionCDTime.visible)
               {
                  this.FMC_InteractionCDTime.visible = true;
                  this.FBTN_Interaction.Visible = false;
               }
               this.FTF_InteractionCDTime.text = TUtilityTiming.fomatTime(_loc5_).toString();
            }
            if(_loc2_ != 0)
            {
               this.FTF_WorkTime.text = TUtilityTiming.fomatTime(_loc3_ - _loc2_);
            }
            _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SlaveGainExp,this.FDisciple.DiscipleLevel) as TSlaveGainExp;
            _loc7_ = _loc3_ - this.FDisciple.DrawTime;
            _loc8_ = _loc4_.Pressible / 24 / 60 / 60;
            if(_loc7_ < 0)
            {
               _loc7_ = 0;
            }
            this.FTF_GetEXP.text = "" + (uint(_loc7_ * _loc8_) + this.FDisciple.AddUpExp);
         }
         super.LogicsPerform();
      }
      
      protected function UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         this.FHeroInfo = new THeroInfo(this);
         this.FHeroInfo.Resource = this.FResource[CONST_MENTORSHIP.RESOURCE_Link_MC_Hero];
         this.FHeroInfo.ImageOnClick = this.ProcessorOnWatchHeroInfo;
         this.FHeroInfo.Init();
         this.FMC_Bg = this.FResource[CONST_MENTORSHIP.RESOURCE_Link_MC_Bg];
         this.FMC_InteractionCDTime = this.FResource[CONST_MENTORSHIP.RESOURCE_Link_MC_InteractionCDTime];
         this.FTF_InteractionCDTime = this.FMC_InteractionCDTime[CONST_MENTORSHIP.RESOURCE_Link_TF_InteractionCDTime];
         this.FBTN_Interaction = new TUIButton();
         this.FBTN_Interaction.Substrate = this.FResource[CONST_MENTORSHIP.RESOURCE_Link_BTN_Interaction];
         this.FBTN_Interaction.OnClick = this.BTNInteractionOnClick;
         this.FMC_Operation = this.FResource[CONST_MENTORSHIP.RESOURCE_Link_MC_Operation];
         this.FMC_WorkExp = this.FMC_Operation[CONST_MENTORSHIP.RESOURCE_Link_MC_WorkExp];
         this.FTF_WorkTime = this.FMC_WorkExp[CONST_MENTORSHIP.RESOURCE_Link_TF_WorkTime];
         this.FTF_GetEXP = this.FMC_WorkExp[CONST_MENTORSHIP.RESOURCE_Link_TF_GetEXP];
         this.FBTN_Draw = new TUIButton();
         this.FBTN_Draw.Substrate = this.FMC_Operation[CONST_MENTORSHIP.RESOURCE_Link_BTN_Draw];
         this.FBTN_Draw.OnClick = this.BTNDrawOnClick;
         this.FBTN_Squeeze = new TUIButton();
         this.FBTN_Squeeze.Substrate = this.FMC_Operation[CONST_MENTORSHIP.RESOURCE_Link_BTN_Squeeze];
         this.FBTN_Squeeze.OnClick = this.BTNSqueezeOnClick;
         this.FBTN_DrawAll = new TUIButton();
         this.FBTN_DrawAll.Substrate = this.FMC_Operation[CONST_MENTORSHIP.RESOURCE_Link_BTN_DrawAll];
         this.FBTN_DrawAll.OnClick = this.BTNDrawAllOnClick;
         this.FBTN_Release = new TUIButton();
         this.FBTN_Release.Substrate = this.FMC_Operation[CONST_MENTORSHIP.RESOURCE_Link_BTN_Release];
         this.FBTN_Release.OnClick = this.BTNReleaseOnClick;
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         this.ShowUI(false);
         this.FInitialized = true;
      }
      
      protected function ShowUI(param1:Boolean) : void
      {
         this.FHeroInfo.Resource.visible = param1;
         this.FBTN_Interaction.Visible = param1;
         this.FMC_InteractionCDTime.visible = param1;
         this.FMC_Operation.visible = param1;
         this.FMC_Bg.visible = param1;
      }
      
      protected function UpdateUI(param1:Boolean) : void
      {
         if(!param1)
         {
            return;
         }
         if(this.FDisciple == null)
         {
            return;
         }
         this.FHeroInfo.Update(this.FDisciple);
         if(this.FDisciple.InteractionCDTime != 0)
         {
            this.FBTN_Interaction.Visible = !param1;
            this.FMC_InteractionCDTime.visible = param1;
         }
         else
         {
            this.FBTN_Interaction.Visible = param1;
            this.FMC_InteractionCDTime.visible = !param1;
         }
      }
      
      protected function BTNInteractionOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnInteraction != null)
         {
            this.FOnInteraction(this,this.FDisciple);
         }
      }
      
      protected function BTNDrawOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FDrawTime = STimingCore.ServerTick;
         if(this.FOnDrawExp != null)
         {
            this.FOnDrawExp(this,CONST_MENTORSHIP.COMMAND_Draw,0,this.FDisciple);
         }
      }
      
      protected function BTNSqueezeOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TSlaveBleed = null;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SlaveBleed,1) as TSlaveBleed;
         this.FCommandType = CONST_MENTORSHIP.COMMAND_Squeeze;
         this.FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MENTORSHIP_STRING_11),_loc3_.Cost);
         this.FUIWindowConfirmation.OnOK = this.WindowInformationOnOK;
         this.FUIWindowConfirmation.Visible = true;
      }
      
      protected function BTNDrawAllOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TSlaveBleed = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc4_ = this.FDisciple.StartWorkTime + TUtilityTiming.CONST_DAY - this.FDisciple.DrawTime;
         _loc5_ = Math.ceil(_loc4_ / 60 / 60);
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SlaveBleed,_loc5_) as TSlaveBleed;
         _loc6_ = _loc3_.Cost;
         this.FCommandType = CONST_MENTORSHIP.COMMAND_DrawAll;
         this.FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MENTORSHIP_STRING_12),_loc6_);
         this.FUIWindowConfirmation.OnOK = this.WindowInformationOnOK;
         this.FUIWindowConfirmation.Visible = true;
      }
      
      protected function BTNReleaseOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TConfigValue = null;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Slave_InteractionCDTime) as TConfigValue;
         if(STimingCore.ServerTick - this.FDisciple.InteractionCDTime > uint(_loc3_.Value) * 60)
         {
            this.FOnEffectGenerateText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MENTORSHIP_STRING_20));
         }
         this.FCommandType = CONST_MENTORSHIP.COMMAND_Release;
         this.FUIWindowConfirmation.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MENTORSHIP_STRING_13);
         this.FUIWindowConfirmation.OnOK = this.WindowInformationOnOK;
         this.FUIWindowConfirmation.Visible = true;
      }
      
      protected function WindowInformationOnOK(param1:Object) : void
      {
         if(this.FOnDrawExp != null)
         {
            this.FOnDrawExp(this,this.FCommandType,0,this.FDisciple);
         }
      }
      
      protected function ProcessorOnWatchHeroInfo(param1:Object, param2:Object) : void
      {
         var _loc3_:TDisciple = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         if(param2 is TDisciple)
         {
            _loc3_ = param2 as TDisciple;
            _loc4_ = _loc3_.DiscipleID0;
            _loc5_ = _loc3_.DiscipleID1;
         }
         if(this.FOnWatchOhterPlayerInfo != null)
         {
            this.FOnWatchOhterPlayerInfo(this,_loc4_,_loc5_);
         }
      }
      
      public function get Resource() : MovieClip
      {
         return this.FResource;
      }
      
      public function set Resource(param1:MovieClip) : void
      {
         this.FResource = param1;
      }
      
      public function get OnInteraction() : Function
      {
         return this.FOnInteraction;
      }
      
      public function set OnInteraction(param1:Function) : void
      {
         this.FOnInteraction = param1;
      }
      
      public function get OnDrawExp() : Function
      {
         return this.FOnDrawExp;
      }
      
      public function set OnDrawExp(param1:Function) : void
      {
         this.FOnDrawExp = param1;
      }
      
      public function get OnRelease() : Function
      {
         return this.FOnRelease;
      }
      
      public function set OnRelease(param1:Function) : void
      {
         this.FOnRelease = param1;
      }
      
      public function get OnEffectGenerateText() : Function
      {
         return this.FOnEffectGenerateText;
      }
      
      public function set OnEffectGenerateText(param1:Function) : void
      {
         this.FOnEffectGenerateText = param1;
      }
      
      public function get OnWatchOhterPlayerInfo() : Function
      {
         return this.FOnWatchOhterPlayerInfo;
      }
      
      public function set OnWatchOhterPlayerInfo(param1:Function) : void
      {
         this.FOnWatchOhterPlayerInfo = param1;
      }
      
      public function Init() : void
      {
         this.UIDispatch();
      }
      
      public function Update(param1:TDisciple, param2:Boolean = false) : void
      {
         this.FDisciple = param1;
         this.ShowUI(param2);
         this.UpdateUI(param2);
      }
      
      public function Reset() : void
      {
         this.FHeroInfo.Reset();
      }
   }
}

