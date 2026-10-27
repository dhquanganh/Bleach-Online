package Processors.Game.Lobby.Pet.PetTrain
{
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Pet.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Pet.PetTrain.Components.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   
   public class TProcessorWindowPetTrainModel extends TProcessorLobbyWindow
   {
      
      protected var FPetData:TPetData;
      
      protected var FMC_PetTrainModel:Sprite;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FBtn_Help:SimpleButton;
      
      protected var FUIPetTrainModelSelects:Vector.<TUIPetTrainModelSelect>;
      
      protected var FInitialization:Boolean;
      
      protected var FHintOnOver:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FOnTrain:Function;
      
      public function TProcessorWindowPetTrainModel(param1:TUIComponent)
      {
         super(param1);
         this.FPetData = SLogicsCore.PetData;
         this.FUIPetTrainModelSelects = new Vector.<TUIPetTrainModelSelect>();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_PET.RESOURCESID_Swf_PetTrain);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:TVicePetTrain = null;
         var _loc2_:TBins = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TUIPetTrainModelSelect = null;
         this.FMC_PetTrainModel = TUtilityReflection.CreateDisplayObjectInstance(CONST_PET.RESOURCE_Link_MC_PetTrainModel) as Sprite;
         addChild(this.FMC_PetTrainModel);
         _loc2_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_VicePetTrain);
         _loc4_ = uint(_loc2_.Count);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = new TUIPetTrainModelSelect(this);
            _loc5_.Resource = this.FMC_PetTrainModel["SP_Model_" + _loc3_];
            this.FUIPetTrainModelSelects[_loc3_] = _loc5_;
            _loc1_ = _loc2_.GetDatebaseByIndex(_loc3_) as TVicePetTrain;
            this.FUIPetTrainModelSelects[_loc3_].Context = _loc1_;
            this.FUIPetTrainModelSelects[_loc3_].OnTrainSelected = this.OnTrainSelected;
            _loc3_++;
         }
         this.FBtn_Close = this.FMC_PetTrainModel[CONST_COMMON.RESOURCE_Link_Btn_Close];
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.Btn_CloseClick,false,0,true);
         this.FInitialization = true;
         this.Reset();
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
      }
      
      protected function Btn_CloseClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function OnTrainSelected(param1:Object, param2:uint) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint((param1 as TUIPetTrainModelSelect).SelectBoxIndex);
         if(this.FOnTrain != null)
         {
            this.FOnTrain(this,param2,_loc3_);
         }
      }
      
      public function set HintOnOver(param1:Function) : void
      {
         this.FHintOnOver = param1;
      }
      
      public function get HintOnOver() : Function
      {
         return this.FHintOnOver;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function get HintOnOut() : Function
      {
         return this.FHintOnOut;
      }
      
      public function get OnTrain() : Function
      {
         return this.FOnTrain;
      }
      
      public function set OnTrain(param1:Function) : void
      {
         this.FOnTrain = param1;
      }
      
      public function Reset() : void
      {
         if(!this.FInitialization)
         {
            return;
         }
      }
      
      public function Update() : void
      {
      }
   }
}

