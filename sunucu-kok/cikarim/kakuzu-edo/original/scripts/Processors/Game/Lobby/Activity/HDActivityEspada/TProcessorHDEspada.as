package Processors.Game.Lobby.Activity.HDActivityEspada
{
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityMode.*;
   import Logics.HDActivitySingle.*;
   import Logics.Streamization.HDActivitySingle.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Common.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TProcessorHDEspada extends TProcessorHDSingleWindowsBase
   {
      
      protected static const WINDOW_WIDTH_Espada:uint = 638;
      
      protected static const WINDOW_HEIGHT_Espada:uint = 553;
      
      protected var FDataEspada:TActivitySingleEspada;
      
      protected var FHDEspada:THDActivityEspada;
      
      protected var FProcessorWindowEspada:TProcessorHDWindowEspada;
      
      protected var FUnstreamizerActivitySingle:TUnstreamizerActivitySingle;
      
      protected var FBounds:TBounds;
      
      public function TProcessorHDEspada(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         FActivityID = CONST_ACTIVITY_MODE.Activity_Espada;
         this.FDataEspada = new TActivitySingleEspada();
         this.FUnstreamizerActivitySingle = new TUnstreamizerActivitySingle();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityEspada);
      }
      
      override protected function InitWindows() : void
      {
         super.InitWindows();
         this.FProcessorWindowEspada = new TProcessorHDWindowEspada(this);
         this.FProcessorWindowEspada.OnSlotOver = UIComponentsHintOnOver;
         this.FProcessorWindowEspada.OnSlotOut = UIComponentsHintOnOut;
         this.FProcessorWindowEspada.OnBtnCloseClick = this.BtnOnCloseClick;
         this.FProcessorWindowEspada.UpdateStatus = this.UpdateEffectNotify;
         this.FProcessorWindowEspada.Hide();
         this.FBounds = new TBounds();
         this.FBounds.Width = WINDOW_WIDTH_Espada;
         this.FBounds.Height = WINDOW_HEIGHT_Espada;
         ComponentBoundsCenter(this.FProcessorWindowEspada,this.FBounds);
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         this.FHDEspada = FHDActivityConfig as THDActivityEspada;
      }
      
      override protected function ProcessorSCInitWindow(param1:TActivityAtoms, param2:ByteArray) : void
      {
         super.ProcessorSCInitWindow(param1,param2);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param2,null);
         this.FUnstreamizerActivitySingle.UnstreamizeUpdateEspada(FActivityInitRetData,this.FDataEspada,this.FHDEspada);
         this.FProcessorWindowEspada.Show(FCurAtoms,this.FHDEspada,this.FDataEspada);
      }
      
      override protected function ProcessorSCAwardStatusChangeNotify(param1:TActAwardStatusInfo) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:Vector.<TConditionStyleD> = null;
         super.ProcessorSCAwardStatusChangeNotify(param1);
         if(!this.Visible)
         {
            return;
         }
         this.SetData(this.FDataEspada,param1);
         if(this.FProcessorWindowEspada.Visible)
         {
            this.FProcessorWindowEspada.Show(FCurAtoms,null,this.FDataEspada);
         }
      }
      
      private function SetData(param1:TActivitySingleEspada, param2:TActAwardStatusInfo) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Vector.<TConditionStyleD> = null;
         var _loc6_:Vector.<TConditionStyleD> = null;
         var _loc7_:uint = 0;
         var _loc8_:TConditionStyleD = null;
         var _loc9_:uint = 0;
         _loc6_ = this.FHDEspada.Conditions;
         _loc4_ = _loc6_.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(param2.Index == _loc6_[_loc3_].Index)
            {
               _loc8_ = _loc6_[_loc3_];
               switch(_loc8_.Type)
               {
                  case CONST_ACTIVITY_MODE.TYPE_Operate_Award:
                     _loc5_ = this.FHDEspada.AwardsConditions;
                     _loc9_ = _loc5_.indexOf(_loc8_);
                     param1.AwardStatus[_loc9_] = param2.Status;
                     break;
                  case CONST_ACTIVITY_MODE.TYPE_Operate_Buy:
                     _loc5_ = this.FHDEspada.BuyConditions;
                     _loc9_ = _loc5_.indexOf(_loc8_);
                     param1.BuyStatus[_loc9_] = param2.Status;
               }
               break;
            }
            _loc3_++;
         }
      }
      
      protected function UpdateEffectNotify(param1:Object, param2:uint) : void
      {
         if(FEffectNotification != null)
         {
            FEffectNotification(param1,param2);
         }
      }
      
      protected function BtnOnCloseClick(param1:Object) : void
      {
         ProcessorClose();
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowEspada.Load();
            return;
         }
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_Espada);
         FCurAtoms = GetAtomsByActivityID(FActivityID);
         if(FMemoryID != FCurAtoms.Identifier)
         {
            if(this.FHDEspada == null)
            {
               GetActivityConfigByActivityAtoms(FCurAtoms);
            }
            FMemoryID = FCurAtoms.Identifier;
         }
         Perform_CS_ActivityInitReq(FCurAtoms.Identifier);
         this.Visible = true;
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         if(this.FProcessorWindowEspada != null)
         {
            this.FProcessorWindowEspada.Hide();
         }
      }
      
      public function ProcessorEffectNotify() : void
      {
         this.UpdateEffectNotify(this,CONST_SHORTCUTS.TYPE_ActiveList_Espada);
      }
      
      override public function ValuesChange(param1:TActivityAtoms, param2:Vector.<int>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         super.ValuesChange(param1,param2);
         if(!this.Visible)
         {
            return;
         }
         this.FDataEspada.TotalPay = param2[0];
         _loc4_ = 10;
         _loc5_ = -1;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(this.FDataEspada.TotalPay < this.FHDEspada.AwardsConditions[_loc3_].Key)
            {
               break;
            }
            _loc5_ = _loc3_;
            _loc3_++;
         }
         this.FDataEspada.CurIndex = _loc5_;
         if(this.FProcessorWindowEspada.Visible)
         {
            this.FProcessorWindowEspada.Show(FCurAtoms,null,this.FDataEspada);
         }
      }
   }
}

