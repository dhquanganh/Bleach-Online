package Processors
{
   import Debugging.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Registries.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   
   public class TProcessor extends TUIComponent
   {
      
      protected static const RESOURCESSTATE_Ready:int = -1;
      
      protected static const RESOURCESSTATE_Idle:int = 256;
      
      protected static const RESOURCESSTATE_UIRequest:int = 0;
      
      protected static const RESOURCESSTATE_UIWait:int = 1;
      
      protected static const RESOURCESSTATE_UIDispatch:int = 2;
      
      protected static const RESOURCESSTATE_UILocations:int = 3;
      
      protected static const RESOURCESSTATE_UIFinalize:int = 4;
      
      protected var FResourcesRoutines:TRegistryRoutine;
      
      protected var FResourcesState:int;
      
      public function TProcessor(param1:TUIComponent)
      {
         super(param1);
         this.FResourcesRoutines = new TRegistryRoutine();
         this.ResourcesRegisterRoutines();
      }
      
      protected function ResourcesRegisterRoutines() : void
      {
         this.FResourcesRoutines.Register(RESOURCESSTATE_Idle,this.ResourcesPerform_Idle);
         this.FResourcesRoutines.Register(RESOURCESSTATE_UIRequest,this.ResourcesPerform_UIRequest);
         this.FResourcesRoutines.Register(RESOURCESSTATE_UIWait,this.ResourcesPerform_UIWait);
         this.FResourcesRoutines.Register(RESOURCESSTATE_UIDispatch,this.ResourcesPerform_UIDispatch);
         this.FResourcesRoutines.Register(RESOURCESSTATE_UILocations,this.ResourcesPerform_UILocations);
         this.FResourcesRoutines.Register(RESOURCESSTATE_UIFinalize,this.ResourcesPerform_UIFinalize);
      }
      
      protected function ResourcesPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Function = null;
         while(this.FResourcesState != RESOURCESSTATE_Ready)
         {
            _loc1_ = this.FResourcesState;
            _loc2_ = this.FResourcesRoutines.GetRoutineByIndentifier(this.FResourcesState);
            if(_loc2_ != null)
            {
               _loc2_();
            }
            if(_loc1_ == this.FResourcesState)
            {
               return;
            }
         }
      }
      
      protected function ResourcesPerform_Idle() : void
      {
      }
      
      protected function ResourcesPerform_UIRequest() : void
      {
         this.FResourcesState = RESOURCESSTATE_UIWait;
      }
      
      protected function ResourcesPerform_UIWait() : void
      {
         if(SResourcesCore.LoadingPrimary)
         {
            return;
         }
         this.FResourcesState = RESOURCESSTATE_UIDispatch;
      }
      
      protected function ResourcesPerform_UIDispatch() : void
      {
         this.FResourcesState = RESOURCESSTATE_UILocations;
      }
      
      protected function ResourcesPerform_UILocations() : void
      {
         this.FResourcesState = RESOURCESSTATE_UIFinalize;
      }
      
      protected function ResourcesPerform_UIFinalize() : void
      {
         this.FResourcesState = RESOURCESSTATE_Ready;
      }
      
      protected function ResourcesTraverse() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIComponent = null;
         _loc1_ = int(FComponents.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = FComponents[_loc2_];
            if(_loc3_ is TProcessor)
            {
               (_loc3_ as TProcessor).ResourcesProcess();
            }
            _loc2_++;
         }
      }
      
      protected function LogicsPerform() : void
      {
      }
      
      protected function LogicsTraverse() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIComponent = null;
         _loc1_ = int(FComponents.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = FComponents[_loc2_];
            if(_loc3_ is TProcessor)
            {
               (_loc3_ as TProcessor).LogicsProcess();
            }
            _loc2_++;
         }
      }
      
      protected function ProcessorsTraverse() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIComponent = null;
         _loc1_ = int(FComponents.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = FComponents[_loc2_];
            if(_loc3_ is TProcessor)
            {
               (_loc3_ as TProcessor).ProcessorsResize();
            }
            if(_loc3_ is TUIComponent)
            {
               (_loc3_ as TUIComponent).ComponentsResize();
            }
            _loc2_++;
         }
         ProcessorResize();
      }
      
      public function get ResourcesReady() : Boolean
      {
         return this.FResourcesState == RESOURCESSTATE_Ready;
      }
      
      public function Load() : void
      {
         this.FResourcesState = RESOURCESSTATE_UIRequest;
      }
      
      public function UnLoad() : void
      {
         this.FResourcesState = RESOURCESSTATE_Idle;
      }
      
      public function ResourcesProcess() : void
      {
         this.ResourcesPerform();
         this.ResourcesTraverse();
      }
      
      public function LogicsProcess() : void
      {
         this.LogicsPerform();
         this.LogicsTraverse();
      }
      
      public function ProcessorsResize() : void
      {
         this.ProcessorsTraverse();
      }
   }
}

