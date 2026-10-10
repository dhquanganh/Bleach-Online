package Processors.Game.Lobby.Common
{
   import Foundation.Common.TBounds;
   import Foundation.Queries.TQueryBoolean;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.Affairs.TAffair;
   import Logics.DatebaseVO.VO.TErrorCode;
   import Logics.SLogicsCore;
   import Processors.Game.Common.Effects.Texts.TEffectCoordinateParameters;
   import Processors.Game.Common.Effects.Texts.TEffectTextParameters;
   import Processors.Game.TProcessorGame;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_FRESHGUIDE;
   import Resources.Constants.CONST_SIGNAL;
   import flash.utils.ByteArray;
   
   public class TProcessorLobbyModule extends TProcessorGame
   {
      
      protected static const AFFAIRID_TimingWaitBattleActive:uint = 256;
      
      protected static const AFFAIRID_TimingWaitBattleLoading:uint = 257;
      
      protected static const AFFAIRID_TimingWaitResourcesLoading:uint = 4026531841;
      
      protected static const TYPE_EFFECTTEXT:uint = 1;
      
      protected static const TYPE_DIALOGMSG:uint = 2;
      
      protected var FParameters:TLobbyParameters;
      
      protected var FQueryBooleanBattle:TQueryBoolean;
      
      protected var FOnQueryBattleActive:Function;
      
      protected var FOnQueryBattleLoading:Function;
      
      protected var FOnEffectText:Function;
      
      protected var FOnEffectHtmlText:Function;
      
      protected var FOnDialogMsg:Function;
      
      protected var FOnChatSystemText:Function;
      
      protected var FOnEffectTransition:Function;
      
      protected var FOnQueryResourcesLoading:Function;
      
      public function TProcessorLobbyModule(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1);
         this.FParameters = param2;
         this.FQueryBooleanBattle = new TQueryBoolean();
      }
      
      protected function ComponentBoundsCenter(param1:TUIComponent, param2:TBounds) : void
      {
         param1.x = (CONST_COMMON.STAGE_Width - param2.Width) / 2;
         param1.y = (CONST_COMMON.STAGE_Height - param2.Height) / 2;
      }
      
      protected function BarrierActuate(param1:Object) : void
      {
         this.FParameters.ActuatorBarrier.Actuate(param1);
      }
      
      protected function BarrierDeactuate(param1:Object) : void
      {
         this.FParameters.ActuatorBarrier.Deactuate(param1);
      }
      
      protected function BarrierActuateWindows(param1:Object) : void
      {
         this.FParameters.ActuatorBarrier.ActuateAddition(param1);
      }
      
      protected function BarrierDeactuateWindows(param1:Object) : void
      {
         this.FParameters.ActuatorBarrier.DeactuateAddition(param1);
      }
      
      protected function BattleQueryActive() : Boolean
      {
         this.FQueryBooleanBattle.Value = false;
         if(this.FOnQueryBattleActive != null)
         {
            this.FOnQueryBattleActive(this,this.FQueryBooleanBattle);
         }
         return this.FQueryBooleanBattle.Value;
      }
      
      protected function BattleQueryLoading() : Boolean
      {
         this.FQueryBooleanBattle.Value = false;
         if(this.FOnQueryBattleLoading != null)
         {
            this.FOnQueryBattleLoading(this,this.FQueryBooleanBattle);
         }
         return this.FQueryBooleanBattle.Value;
      }
      
      protected function TimingWaitResourcesLoading() : Boolean
      {
         if(FIsResourcesLoadCompleted)
         {
            this.Mount();
            return false;
         }
         return true;
      }
      
      override protected function AffairRegisterRoutines() : void
      {
         super.AffairRegisterRoutines();
         FAffairRoutines.Register(AFFAIRID_TimingWaitBattleActive,this.AffairPerform_TimingWaitBattleActive);
         FAffairRoutines.Register(AFFAIRID_TimingWaitBattleLoading,this.AffairPerform_TimingWaitBattleLoading);
         FAffairRoutines.Register(AFFAIRID_TimingWaitResourcesLoading,this.AffairPerform_TimingWaitResourcesLoading);
      }
      
      protected function AffairPerform_TimingWaitBattleActive(param1:TAffair) : void
      {
         var _loc2_:Boolean = false;
         _loc2_ = this.BattleQueryActive();
         if(_loc2_)
         {
            param1.PostProcess = TAffair.POSTPROCESS_Pend;
         }
         else
         {
            param1.PostProcess = TAffair.POSTPROCESS_Remove;
         }
      }
      
      protected function AffairPerform_TimingWaitBattleLoading(param1:TAffair) : void
      {
         var _loc2_:Boolean = false;
         _loc2_ = this.BattleQueryLoading();
         if(_loc2_)
         {
            param1.PostProcess = TAffair.POSTPROCESS_Pend;
         }
         else
         {
            param1.PostProcess = TAffair.POSTPROCESS_Remove;
         }
      }
      
      protected function AffairPerform_TimingWaitResourcesLoading(param1:TAffair) : void
      {
         var _loc2_:Boolean = false;
         _loc2_ = this.TimingWaitResourcesLoading();
         if(_loc2_)
         {
            param1.PostProcess = TAffair.POSTPROCESS_Pend;
         }
         else
         {
            param1.PostProcess = TAffair.POSTPROCESS_Remove;
         }
      }
      
      protected function EffectGenerateText(param1:String, param2:TEffectTextParameters = null, param3:TEffectCoordinateParameters = null) : void
      {
         if(this.FOnEffectText != null)
         {
            this.FOnEffectText(this,param1,param2,param3);
         }
      }
      
      protected function EffectGenerateHtmlText(param1:String) : void
      {
         if(this.FOnEffectHtmlText != null)
         {
            this.FOnEffectHtmlText(this,param1);
         }
      }
      
      protected function DialogMsgGenerateText(param1:String) : void
      {
         if(this.FOnDialogMsg != null)
         {
            this.FOnDialogMsg(this,param1);
         }
      }
      
      protected function EffectGenerateTextByErrorCode(param1:uint) : void
      {
         var _loc2_:TBins = null;
         var _loc3_:TErrorCode = null;
         var _loc4_:String = null;
         _loc4_ = null;
         _loc2_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ErrorCode);
         if(_loc2_ != null)
         {
            _loc3_ = _loc2_.GetDatebaseByIdentifier(param1) as TErrorCode;
            if(_loc3_ != null)
            {
               _loc4_ = _loc3_.Desc;
            }
         }
         if(_loc4_ == null)
         {
            _loc4_ = "Error Code: " + param1.toString();
            this.DialogMsgGenerateText(_loc4_);
         }
         if(_loc3_ != null)
         {
            switch(_loc3_.Type)
            {
               case TYPE_EFFECTTEXT:
                  this.EffectGenerateText(_loc4_);
                  break;
               case TYPE_DIALOGMSG:
                  this.DialogMsgGenerateText(_loc4_);
            }
         }
      }
      
      protected function TutorialNextStep(param1:Object) : void
      {
         SLogicsCore.SinalPostFreshGuide(param1);
      }
      
      protected function TutorialSendComponent(param1:uint, param2:Object) : void
      {
         SLogicsCore.SignalPost(CONST_SIGNAL.SIGNALDESTINATION_LobbyTutorial,CONST_FRESHGUIDE.ObjectID_Component,param1,param2);
      }
      
      protected function TutorialSendArrowParent(param1:uint, param2:Object) : void
      {
         SLogicsCore.SignalPost(CONST_SIGNAL.SIGNALDESTINATION_LobbyTutorial,CONST_FRESHGUIDE.ObjectID_ArrowParent,param1,param2);
      }
      
      protected function MusicPlayNext(param1:uint, param2:uint, param3:uint, param4:Boolean = false) : void
      {
         SLogicsCore.SignalPost(param1,param2,param3,param4);
      }
      
      protected function ChatSystemGenerateText(param1:String) : void
      {
         if(this.FOnChatSystemText != null)
         {
            this.FOnChatSystemText(this,param1);
         }
      }
      
      protected function ProcessorsOnEffectText(param1:Object, param2:String, param3:TEffectTextParameters = null, param4:TEffectCoordinateParameters = null) : void
      {
         this.EffectGenerateText(param2,param3,param4);
      }
      
      protected function ProcessorsOnEffectHtmlText(param1:Object, param2:String) : void
      {
         this.EffectGenerateHtmlText(param2);
      }
      
      protected function ProcessorsOnDialogMsg(param1:Object, param2:String) : void
      {
         this.DialogMsgGenerateText(param2);
      }
      
      protected function ProcessorsOnSystemText(param1:Object, param2:String) : void
      {
         this.ChatSystemGenerateText(param2);
      }
      
      protected function ProcessorOnEffectTransition(param1:Object) : void
      {
         if(this.FOnEffectTransition != null)
         {
            this.FOnEffectTransition(param1);
         }
      }
      
      public function get OnQueryBattleActive() : Function
      {
         return this.FOnQueryBattleActive;
      }
      
      public function set OnQueryBattleActive(param1:Function) : void
      {
         this.FOnQueryBattleActive = param1;
      }
      
      public function get OnQueryBattleLoading() : Function
      {
         return this.FOnQueryBattleLoading;
      }
      
      public function set OnQueryBattleLoading(param1:Function) : void
      {
         this.FOnQueryBattleLoading = param1;
      }
      
      public function get OnEffectText() : Function
      {
         return this.FOnEffectText;
      }
      
      public function set OnEffectText(param1:Function) : void
      {
         this.FOnEffectText = param1;
      }
      
      public function get OnEffectHtmlText() : Function
      {
         return this.FOnEffectHtmlText;
      }
      
      public function set OnEffectHtmlText(param1:Function) : void
      {
         this.FOnEffectHtmlText = param1;
      }
      
      public function get OnDialogMsg() : Function
      {
         return this.FOnDialogMsg;
      }
      
      public function set OnDialogMsg(param1:Function) : void
      {
         this.FOnDialogMsg = param1;
      }
      
      public function get OnChatSystemText() : Function
      {
         return this.FOnChatSystemText;
      }
      
      public function set OnChatSystemText(param1:Function) : void
      {
         this.FOnChatSystemText = param1;
      }
      
      public function get OnEffectTransition() : Function
      {
         return this.FOnEffectTransition;
      }
      
      public function set OnEffectTransition(param1:Function) : void
      {
         this.FOnEffectTransition = param1;
      }
      
      public function get OnQueryResourcesLoading() : Function
      {
         return this.FOnQueryResourcesLoading;
      }
      
      public function set OnQueryResourcesLoading(param1:Function) : void
      {
         this.FOnQueryResourcesLoading = param1;
      }
      
      public function Mount(param1:ByteArray = null) : void
      {
         if(!FIsResourcesLoadCompleted)
         {
            FAffairGenerator.Generate(AFFAIRID_TimingWaitResourcesLoading);
            FResourcesState = RESOURCESSTATE_UIRequest;
            return;
         }
         if(this.FOnEffectTransition != null)
         {
            this.FOnEffectTransition(this);
         }
      }
      
      public function Unmount() : void
      {
      }
   }
}

