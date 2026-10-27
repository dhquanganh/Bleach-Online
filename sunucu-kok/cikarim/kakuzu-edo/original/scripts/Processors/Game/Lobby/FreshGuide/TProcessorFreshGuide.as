package Processors.Game.Lobby.FreshGuide
{
   import Components.Controls.*;
   import Components.Standard.TUIButton;
   import Foundation.Network.*;
   import Foundation.Registries.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.FreshGuide.*;
   import Logics.Quests.*;
   import Logics.Signals.*;
   import Logics.Streamization.FreshGuide.*;
   import Processors.Game.Common.*;
   import Processors.Game.Lobby.Common.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorFreshGuide extends TProcessorLobbyWindows
   {
      
      protected static const SpecialHandle_1:int = 1;
      
      protected static const SpecialHandle_2:int = 2;
      
      protected static const SpecialHandle_3:int = 3;
      
      protected static const SpecialHandle_4:int = 4;
      
      protected static const SpecialHandle_5:int = 5;
      
      protected static const SpecialHandle_6:int = 6;
      
      protected static const SpecialHandle_7:int = 7;
      
      protected static const SpecialHandle_8:int = 8;
      
      protected static const SpecialHandle_9:int = 9;
      
      protected static const SpecialHandle_10:int = 10;
      
      protected static const SpecialHandle_11:int = 11;
      
      protected static const SpecialHandle_12:int = 12;
      
      protected static const SpecialHandle_13:int = 13;
      
      protected static const SpecialHandle_14:int = 14;
      
      protected static const SpecialHandle_15:int = 15;
      
      protected static const SpecialHandle_16:int = 16;
      
      protected static const DefaultID:int = 0;
      
      protected var FUIArrow:TUIArrow;
      
      protected var FOnShowWindowWelcome:Function;
      
      protected var FWindowFamily:TWindowFamily;
      
      protected var FRegistryComponents:TRegistryInstance = new TRegistryInstance();
      
      protected var FRegistryArrowParents:TRegistryInstance = new TRegistryInstance();
      
      protected var FRegisterFreshGuide:TRegistryInstance;
      
      protected var FUnstreamizerFreshGuide:TUnstreamizerFreshGuide;
      
      protected var FRegistryRoutines:TRegistryRoutine;
      
      protected var FCurrentFreshGuide:TRegistryInstance;
      
      protected var FCurrentFreshGuideStep:TFreshStep;
      
      protected var FCurrentIndexInSingleFreshGuideTask:int;
      
      protected var FPassKeyNode:Boolean;
      
      protected var FIfWaitResource:Boolean;
      
      protected var FFreshGuideProgressPre:int;
      
      protected var FJudgeStrPre:String;
      
      protected var FFreshGuideProgressPreStore:int;
      
      protected var FNeedCrease:Boolean;
      
      protected var FFreshGuiding:Boolean;
      
      protected var FQuestGuide:DisplayObjectContainer;
      
      protected var FAutoSetDeployment:Function;
      
      protected var FOnActivatingChannel:Function;
      
      protected var FOnPromotFreshGuide:Function;
      
      protected var FOnPromotDeplymentFreshGuide:Function;
      
      protected var FOnPromotKnifeOfKillSoulFreshGuide:Function;
      
      protected var FOnPromotTraven:Function;
      
      public function TProcessorFreshGuide(param1:TProcessorMountPoint, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.ConstructComponent();
      }
      
      protected function ConstructComponent() : void
      {
         this.ConstructArrow();
         this.ConstructWelcomeView();
         this.ConstructFamilyView();
         this.ConstructSpecialHandle();
      }
      
      protected function ConstructArrow() : void
      {
         this.FUIArrow = new TUIArrow(this);
         this.FUIArrow.Load();
         this.FUIArrow.Visible = false;
      }
      
      protected function ConstructWelcomeView() : void
      {
      }
      
      protected function ConstructFamilyView() : void
      {
         this.FWindowFamily = new TWindowFamily(this);
         this.FWindowFamily.OnClickBtn = this.DeleteBarrier;
         this.FWindowFamily.OnEffectText = ProcessorsOnEffectText;
         this.FWindowFamily.visible = false;
      }
      
      protected function ConstructFreshGuideStep() : void
      {
         this.FUnstreamizerFreshGuide = new TUnstreamizerFreshGuide();
         this.FRegisterFreshGuide = new TRegistryInstance();
         this.FUnstreamizerFreshGuide.Unstreamize(null,this.FRegisterFreshGuide,null);
      }
      
      protected function ConstructSpecialHandle() : void
      {
         this.FRegistryRoutines = new TRegistryRoutine();
         this.FRegistryRoutines.Register(SpecialHandle_1,this.Special_ShowWelcomeView);
         this.FRegistryRoutines.Register(SpecialHandle_2,this.Special_AutoSearchWay);
         this.FRegistryRoutines.Register(SpecialHandle_3,this.Special_AutoSetDeployment);
         this.FRegistryRoutines.Register(SpecialHandle_4,this.SetGeneralStarCantClose);
         this.FRegistryRoutines.Register(SpecialHandle_5,this.SetGeneralStarCanClose);
         this.FRegistryRoutines.Register(SpecialHandle_6,this.ShowLeftArrow);
         this.FRegistryRoutines.Register(SpecialHandle_7,this.ShowRightArrow);
         this.FRegistryRoutines.Register(SpecialHandle_8,this.Special_ShowFamilyView);
         this.FRegistryRoutines.Register(SpecialHandle_10,this.SetDeploymentCantClose);
         this.FRegistryRoutines.Register(SpecialHandle_11,this.SetDeploymentCanClose);
         this.FRegistryRoutines.Register(SpecialHandle_12,this.SetKnifeOfKillSoulCantClose);
         this.FRegistryRoutines.Register(SpecialHandle_13,this.SetKnifeOfKillSoulCanClose);
         this.FRegistryRoutines.Register(SpecialHandle_14,this.CheckIfCrease);
         this.FRegistryRoutines.Register(SpecialHandle_15,this.SetTravenCantClose);
         this.FRegistryRoutines.Register(SpecialHandle_16,this.SetTravenCanClose);
      }
      
      protected function Special_ShowWelcomeView(param1:TFreshStep) : Boolean
      {
         if(this.FOnShowWindowWelcome != null)
         {
            this.FOnShowWindowWelcome(this);
         }
         return true;
      }
      
      protected function Special_AutoSearchWay(param1:TFreshStep) : Boolean
      {
         var _loc2_:TQuest = null;
         if(SLogicsCore.Character.MainQuestsCanAccept.Count <= 0)
         {
            return true;
         }
         _loc2_ = SLogicsCore.Character.MainQuestsCanAccept.GetQuestByIndex(0);
         SLogicsCore.QuestAutoSearchWay.AutoSearyWay(_loc2_);
         return true;
      }
      
      protected function Special_AutoSetDeployment(param1:TFreshStep) : Boolean
      {
         if(this.FAutoSetDeployment != null)
         {
            this.FAutoSetDeployment(this,11100101,1,null);
         }
         return true;
      }
      
      protected function SetGeneralStarCantClose(param1:TFreshStep) : Boolean
      {
         if(this.FOnPromotFreshGuide != null)
         {
            this.FOnPromotFreshGuide(this,true);
         }
         return true;
      }
      
      protected function SetGeneralStarCanClose(param1:TFreshStep) : Boolean
      {
         if(this.FOnPromotFreshGuide != null)
         {
            this.FOnPromotFreshGuide(this,false);
         }
         return true;
      }
      
      protected function ShowLeftArrow(param1:TFreshStep) : Boolean
      {
         this.FUIArrow.ShowLeftArrow();
         return true;
      }
      
      protected function ShowRightArrow(param1:TFreshStep) : Boolean
      {
         this.FUIArrow.ShowRightArrow();
         return true;
      }
      
      protected function SetDeploymentCantClose(param1:TFreshStep) : Boolean
      {
         if(this.FOnPromotDeplymentFreshGuide != null)
         {
            this.FOnPromotDeplymentFreshGuide(this,true);
         }
         return true;
      }
      
      protected function SetDeploymentCanClose(param1:TFreshStep) : Boolean
      {
         if(this.FOnPromotDeplymentFreshGuide != null)
         {
            this.FOnPromotDeplymentFreshGuide(this,false);
         }
         return true;
      }
      
      protected function SetKnifeOfKillSoulCantClose(param1:TFreshStep) : Boolean
      {
         if(this.FOnPromotKnifeOfKillSoulFreshGuide != null)
         {
            this.FOnPromotKnifeOfKillSoulFreshGuide(this,true);
         }
         return true;
      }
      
      protected function SetKnifeOfKillSoulCanClose(param1:TFreshStep) : Boolean
      {
         if(this.FOnPromotKnifeOfKillSoulFreshGuide != null)
         {
            this.FOnPromotKnifeOfKillSoulFreshGuide(this,false);
         }
         return true;
      }
      
      protected function CheckIfCrease(param1:TFreshStep) : Boolean
      {
         if(this.FFreshGuideProgressPreStore != 0 && this.FNeedCrease)
         {
            this.FNeedCrease = false;
            this.FFreshGuideProgressPre = this.FFreshGuideProgressPreStore;
            this.EventHandle(this.FFreshGuideProgressPre);
            return false;
         }
         return true;
      }
      
      protected function SetTravenCantClose(param1:TFreshStep) : Boolean
      {
         if(this.FOnPromotTraven != null)
         {
            this.FOnPromotTraven(this,true);
         }
         return true;
      }
      
      protected function SetTravenCanClose(param1:TFreshStep) : Boolean
      {
         if(this.FOnPromotTraven != null)
         {
            this.FOnPromotTraven(this,false);
         }
         return true;
      }
      
      protected function Special_ShowFamilyView(param1:TFreshStep) : Boolean
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_FreshGuide_RecommandFamilyReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
         BarrierActuate(this.FWindowFamily);
         this.FWindowFamily.Load();
         this.FWindowFamily.visible = true;
         return true;
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.ConstructFreshGuideStep();
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:DisplayObject = null;
         super.LogicsPerform();
         if(this.FIfWaitResource && this.FCurrentFreshGuideStep != null)
         {
            _loc1_ = this.FRegistryComponents.GetInstanceByIdentifier(this.FCurrentFreshGuideStep.MC_ID) as DisplayObject;
            if(_loc1_ != null)
            {
               this.FIfWaitResource = false;
               this.FUIArrow.SetArrowInfor(_loc1_,this.FCurrentFreshGuideStep,this.FRegistryArrowParents.GetInstanceByIdentifier(this.FCurrentFreshGuideStep.MC_ID) as DisplayObjectContainer);
            }
         }
         this.LogicsPerform_Signals();
      }
      
      protected function LogicsPerform_Signals() : void
      {
         var _loc1_:TSignal = null;
         while(true)
         {
            _loc1_ = SLogicsCore.SignalRetrieve(CONST_SIGNAL.SIGNALDESTINATION_LobbyTutorial);
            if(_loc1_ == null)
            {
               break;
            }
            switch(_loc1_.Identifier)
            {
               case CONST_FRESHGUIDE.ObjectID_Event:
                  break;
               case CONST_FRESHGUIDE.ObjectID_Component:
                  this.ComponentArrive(_loc1_);
                  break;
               case CONST_FRESHGUIDE.ObjectID_ArrowParent:
                  this.ArrowParentArrive(_loc1_);
            }
         }
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_CS_FreshGuide_RecommandFamilyRet,this.PerformPacket_SC_FamilyCommandRet);
      }
      
      protected function PerformPacket_SC_FamilyCommandRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(param1.Data.readUnsignedInt());
         _loc2_ = int(param1.Data.readUnsignedByte());
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FWindowFamily.SetRecommandFaimly(_loc2_);
      }
      
      protected function ComponentArrive(param1:TSignal) : void
      {
         var _loc2_:Object = null;
         var _loc3_:TUIButton = null;
         if(param1.UserData is TUIButton)
         {
            _loc3_ = param1.UserData as TUIButton;
            param1.UserData = _loc3_.Substrate;
         }
         _loc2_ = this.FRegistryComponents.GetInstanceByIdentifier(param1.Value);
         if(_loc2_ != null)
         {
            this.FRegistryComponents.DeleteInstanceByIdentifier(param1.Value);
         }
         this.FRegistryComponents.Register(param1.Value,param1.UserData);
      }
      
      protected function ArrowParentArrive(param1:TSignal) : void
      {
         var _loc2_:Object = null;
         var _loc3_:TUIButton = null;
         if(param1.UserData is TUIButton)
         {
            _loc3_ = param1.UserData as TUIButton;
            param1.UserData = _loc3_.Substrate;
         }
         _loc2_ = this.FRegistryArrowParents.GetInstanceByIdentifier(param1.Value);
         if(_loc2_ != null)
         {
            this.FRegistryArrowParents.DeleteInstanceByIdentifier(param1.Value);
         }
         this.FRegistryArrowParents.Register(param1.Value,param1.UserData);
      }
      
      protected function EventHandle(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Vector.<int> = null;
         var _loc4_:Boolean = false;
         if(this.FCurrentFreshGuideStep != null)
         {
            if(this.FCurrentFreshGuideStep.CompleteCondition == param1)
            {
               if(this.FCurrentFreshGuideStep.GenerateServerID != DefaultID)
               {
                  if(!this.FNeedCrease)
                  {
                     this.SendCompleteMessageToServer(this.FCurrentFreshGuideStep.GenerateServerID,this.FJudgeStrPre);
                  }
               }
               param1 = this.FCurrentFreshGuideStep.GenerateLocalID;
               this.FCurrentFreshGuideStep = null;
               if(this.FCurrentFreshGuide.Count == this.FCurrentIndexInSingleFreshGuideTask + 1)
               {
                  this.FCurrentFreshGuide = null;
                  this.FCurrentIndexInSingleFreshGuideTask = -1;
               }
               this.FUIArrow.Hide();
               this.EventHandle(param1);
               return;
            }
            if(this.FCurrentFreshGuideStep.JmpTriggerID == param1)
            {
               param1 = this.FCurrentFreshGuideStep.JmpGenerateCode;
               this.FCurrentFreshGuideStep = null;
               this.FCurrentFreshGuide = null;
               this.FUIArrow.Hide();
               this.FCurrentIndexInSingleFreshGuideTask = -1;
               this.EventHandle(param1);
               return;
            }
         }
         _loc4_ = this.CheckIfTriggerFreshGuideTask(param1);
         if(!_loc4_)
         {
            _loc3_ = CONST_FRESHGUIDE.QuestCanTriggerFreshGuide;
            _loc2_ = _loc3_.indexOf(param1);
            if(_loc2_ >= 0)
            {
               this.EventHandle(CONST_FRESHGUIDE.QuestTriggerFreshGuideID[_loc2_]);
            }
         }
         else if(this.FCurrentFreshGuideStep.CompleteCondition == 0)
         {
            this.EventHandle(0);
         }
      }
      
      protected function CheckIfTriggerFreshGuideTask(param1:int) : Boolean
      {
         var _loc2_:TRegistryInstance = null;
         var _loc3_:TFreshStep = null;
         var _loc4_:int = 0;
         if(this.FCurrentFreshGuide != null && this.FCurrentFreshGuideStep == null)
         {
            _loc4_ = this.FCurrentIndexInSingleFreshGuideTask + 1;
            _loc3_ = this.FCurrentFreshGuide.GetInstanceByIndex(_loc4_) as TFreshStep;
            if(_loc3_.TriggerEventID == param1)
            {
               return this.TriggerOneStep(this.FCurrentFreshGuide,_loc4_);
            }
         }
         _loc2_ = this.FRegisterFreshGuide.GetInstanceByIdentifier(param1) as TRegistryInstance;
         if(_loc2_ != null)
         {
            return this.TriggerOneStep(_loc2_,0);
         }
         return false;
      }
      
      protected function TriggerOneStep(param1:TRegistryInstance, param2:int) : Boolean
      {
         var _loc3_:TFreshStep = null;
         var _loc4_:Function = null;
         var _loc5_:Boolean = false;
         var _loc6_:DisplayObject = null;
         _loc3_ = param1.GetInstanceByIndex(param2) as TFreshStep;
         _loc4_ = this.FRegistryRoutines.GetRoutineByIndentifier(_loc3_.SpecialHandle);
         _loc5_ = true;
         this.FUIArrow.ShowRightArrow();
         if(_loc4_ != null)
         {
            _loc5_ = _loc4_(_loc3_);
         }
         if(_loc5_)
         {
            this.FCurrentFreshGuide = param1;
            this.FCurrentFreshGuideStep = _loc3_;
            this.FCurrentIndexInSingleFreshGuideTask = param2;
            _loc6_ = this.FRegistryComponents.GetInstanceByIdentifier(_loc3_.MC_ID) as DisplayObject;
            if(_loc6_ != null)
            {
               this.FUIArrow.SetArrowInfor(_loc6_,_loc3_,this.FRegistryArrowParents.GetInstanceByIdentifier(_loc3_.MC_ID) as DisplayObjectContainer);
               this.FIfWaitResource = false;
            }
            else
            {
               this.FIfWaitResource = true;
            }
         }
         return _loc5_;
      }
      
      protected function StartFreshGuide_Perform() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         if(SLogicsCore.Character.FreshGuideProgress == "0")
         {
            SLogicsCore.Character.FreshGuideProgress = CONST_FRESHGUIDE.InitString;
         }
         _loc2_ = int(SLogicsCore.Character.FreshGuideProgress.indexOf(CONST_FRESHGUIDE.FreshGuideSeparationChar));
         _loc1_ = SLogicsCore.Character.FreshGuideProgress.substring(0,_loc2_);
         this.FFreshGuideProgressPre = parseInt(_loc1_);
         this.FFreshGuideProgressPreStore = this.FFreshGuideProgressPre;
         this.FJudgeStrPre = SLogicsCore.Character.FreshGuideProgress.substring(_loc2_ + 1);
         this.FFreshGuiding = true;
         this.CheckIfNeedNip();
         this.EventHandle(this.FFreshGuideProgressPre);
         this.FUIArrow.ShowRightArrow();
      }
      
      protected function SendCompleteMessageToServer(param1:int, param2:String) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:String = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_FreshGuide_CompleteStepReq);
         _loc4_ = TUtilityString.Format(CONST_FRESHGUIDE.FormatString_FreshGuide,param1.toString(),param2);
         TUtilityString.FlushUTF(_loc3_.Data,_loc4_);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         this.FFreshGuideProgressPre = param1;
         this.FJudgeStrPre = param2;
      }
      
      protected function CheckIfNeedNip() : Boolean
      {
         this.FNeedCrease = SLogicsCore.Character.GirlClothesID == 0 && this.FFreshGuideProgressPre != 0;
         if(this.FNeedCrease)
         {
            this.FFreshGuideProgressPre = 0;
            return true;
         }
         return false;
      }
      
      protected function DeleteBarrier(param1:Object) : void
      {
         BarrierDeactuate(param1);
      }
      
      public function set AutoSetDeployment(param1:Function) : void
      {
         this.FAutoSetDeployment = param1;
      }
      
      public function set OnActivatingChannel(param1:Function) : void
      {
         this.FOnActivatingChannel = param1;
      }
      
      public function set OnPromotFreshGuide(param1:Function) : void
      {
         this.FOnPromotFreshGuide = param1;
      }
      
      public function set OnPromotDeplymentFreshGuide(param1:Function) : void
      {
         this.FOnPromotDeplymentFreshGuide = param1;
      }
      
      public function set OnPromotKnifeOfKillSoulFreshGuide(param1:Function) : void
      {
         this.FOnPromotKnifeOfKillSoulFreshGuide = param1;
      }
      
      public function set OnShowWindowWelcome(param1:Function) : void
      {
         this.FOnShowWindowWelcome = param1;
      }
      
      public function set OnPromotTraven(param1:Function) : void
      {
         this.FOnPromotTraven = param1;
      }
      
      public function UpdateFamily() : void
      {
         this.FWindowFamily.UpdateFamily();
         this.FOnActivatingChannel(this,CONST_CHAT.CHANNEL_TYPE_Country,true);
      }
      
      public function StartFreshGuide() : void
      {
         this.StartFreshGuide_Perform();
      }
      
      public function EventNotify(param1:Object) : void
      {
         this.EventHandle(param1 as int);
      }
      
      public function ChangeProgress(param1:int) : void
      {
         this.SendCompleteMessageToServer(param1,this.FJudgeStrPre);
      }
   }
}

