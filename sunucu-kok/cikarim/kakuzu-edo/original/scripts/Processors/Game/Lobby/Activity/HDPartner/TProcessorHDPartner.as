package Processors.Game.Lobby.Activity.HDPartner
{
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityMode.*;
   import Logics.HDPartner.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowsBase;
   import Processors.Game.Lobby.Activity.HDPartner.Decoder.TUnstreamizerActivityPartner;
   import Processors.Game.Lobby.Common.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TProcessorHDPartner extends TProcessorHDSingleWindowsBase
   {
      
      protected static const WINDOW_WIDTH:int = 763;
      
      protected static const WINDOW_HEIGHT:int = 567;
      
      protected var FBounds:TBounds;
      
      protected var FProcessorHDWindowPartner:TProcessorHDWindowPartner;
      
      protected var FActivityPartnerData:TActivityPartnerData;
      
      protected var FUnstreamizerActivityPartner:TUnstreamizerActivityPartner;
      
      protected var FInited:Boolean;
      
      public function TProcessorHDPartner(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         FActivityID = CONST_ACTIVITY_MODE.Activity_Partner;
         this.FActivityPartnerData = new TActivityPartnerData();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityPartner);
      }
      
      override protected function InitWindows() : void
      {
         super.InitWindows();
         this.FBounds = new TBounds();
         this.FBounds.Width = WINDOW_WIDTH;
         this.FBounds.Height = WINDOW_HEIGHT;
         this.FProcessorHDWindowPartner = new TProcessorHDWindowPartner(this);
         this.FProcessorHDWindowPartner.OnClose = this.ShutDownWindow;
         this.FProcessorHDWindowPartner.OnGiftBoxMove = this.ProcessorOnGiftBoxMove;
         this.FProcessorHDWindowPartner.OnGiftBoxOut = this.ProcessorOnGiftBoxOut;
         ComponentBoundsCenter(this.FProcessorHDWindowPartner,this.FBounds);
      }
      
      override protected function ProcessorSCInitWindow(param1:TActivityAtoms, param2:ByteArray) : void
      {
         super.ProcessorSCInitWindow(param1,param2);
         this.FUnstreamizerActivityPartner = new TUnstreamizerActivityPartner();
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param2,null);
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_Partner);
         FCurAtoms = GetAtomsByActivityID(FActivityID);
         if(FMemoryID != FCurAtoms.Identifier)
         {
            if(FHDActivityConfig == null)
            {
               GetActivityConfigByActivityAtoms(FCurAtoms);
            }
            this.FUnstreamizerActivityPartner.CoreConfigValue(null,this.FActivityPartnerData,FHDActivityConfig);
            FMemoryID = FCurAtoms.Identifier;
         }
         this.FUnstreamizerActivityPartner.UnstreamizationPerform_InitData(null,this.FActivityPartnerData,FActivityInitRetData);
         this.CheckTaskSchedule();
         this.CheckRoseOpenNum();
         this.FInited = true;
         if(!this.Visible)
         {
            return;
         }
         this.FProcessorHDWindowPartner.Show(FCurAtoms,FHDActivityConfig,this.FActivityPartnerData);
      }
      
      override protected function ProcessorSCAwardStatusChangeNotify(param1:TActAwardStatusInfo) : void
      {
         super.ProcessorSCAwardStatusChangeNotify(param1);
         this.FUnstreamizerActivityPartner.FillBoxState(param1.Index,param1.Status,this.FActivityPartnerData);
         this.CheckTaskSchedule();
         this.CheckRoseOpenNum();
         this.FProcessorHDWindowPartner.Show(FCurAtoms,FHDActivityConfig,this.FActivityPartnerData);
      }
      
      protected function CheckTaskSchedule() : void
      {
         var _loc1_:TInventories = null;
         var _loc2_:TInventory = null;
         var _loc3_:TEquipment = null;
         var _loc4_:Vector.<int> = null;
         var _loc5_:TArticle = null;
         var _loc6_:int = 0;
         var _loc7_:THeros = null;
         var _loc8_:THero = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         _loc9_ = 0;
         while(_loc9_ < TActivityPartnerData.TASKNUM)
         {
            this.FActivityPartnerData.TaskSchedule[_loc9_] = 0;
            _loc9_++;
         }
         _loc4_ = new Vector.<int>();
         _loc10_ = int(this.FActivityPartnerData.TaskConditions[TActivityPartnerData.TASKINDEX1].length);
         _loc9_ = 0;
         while(_loc9_ < _loc10_)
         {
            _loc4_.push(this.FActivityPartnerData.TaskConditions[TActivityPartnerData.TASKINDEX1][_loc9_]);
            _loc9_++;
         }
         _loc1_ = SLogicsCore.Character.Equipments;
         _loc10_ = _loc1_.Count;
         _loc9_ = 0;
         while(_loc9_ < _loc10_)
         {
            _loc2_ = _loc1_.GetInventoryByIndex(_loc9_);
            _loc11_ = _loc4_.indexOf(_loc2_.IDTemplate);
            if(_loc11_ != -1)
            {
               _loc4_.splice(_loc11_,1);
            }
            _loc9_++;
         }
         _loc7_ = SLogicsCore.Character.Heros;
         _loc10_ = _loc7_.Count;
         _loc9_ = 0;
         while(_loc9_ < _loc10_)
         {
            _loc8_ = _loc7_.GetHeroByIndex(_loc9_);
            _loc12_ = _loc8_.EquipmentsMounted.Capacity;
            _loc11_ = 0;
            while(_loc11_ < _loc12_)
            {
               _loc2_ = _loc8_.EquipmentsMounted.GetInventoryByIndex(_loc11_);
               if(_loc2_ != null)
               {
                  _loc13_ = _loc4_.indexOf(_loc2_.IDTemplate);
                  if(_loc13_ != -1)
                  {
                     _loc4_.splice(_loc13_,1);
                  }
               }
               _loc11_++;
            }
            _loc9_++;
         }
         this.FActivityPartnerData.TaskSchedule[TActivityPartnerData.TASKINDEX1] = this.FActivityPartnerData.TaskConditions[TActivityPartnerData.TASKINDEX1].length - _loc4_.length;
         _loc1_ = SLogicsCore.Character.Gems;
         _loc10_ = _loc1_.Count;
         _loc6_ = this.FActivityPartnerData.TaskConditions[TActivityPartnerData.TASKINDEX2][0];
         _loc9_ = 0;
         while(_loc9_ < _loc10_)
         {
            _loc2_ = _loc1_.GetInventoryByIndex(_loc9_);
            _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc2_.IDTemplate) as TArticle;
            if(_loc5_.Level >= _loc6_)
            {
               this.FActivityPartnerData.TaskSchedule[TActivityPartnerData.TASKINDEX2] += _loc2_.Quantity;
            }
            _loc9_++;
         }
         _loc7_ = SLogicsCore.Character.Heros;
         _loc10_ = _loc7_.Count;
         _loc9_ = 0;
         while(_loc9_ < _loc10_)
         {
            _loc8_ = _loc7_.GetHeroByIndex(_loc9_);
            _loc12_ = _loc8_.EquipmentsMounted.Capacity;
            _loc11_ = 0;
            while(_loc11_ < _loc12_)
            {
               _loc3_ = _loc8_.EquipmentsMounted.GetInventoryByIndex(_loc11_) as TEquipment;
               if(_loc3_ != null)
               {
                  _loc14_ = _loc3_.GiftedStoneItems.Count;
                  _loc13_ = 0;
                  while(_loc13_ < _loc14_)
                  {
                     _loc2_ = _loc3_.GiftedStoneItems.GetGiftedStoneByIndex(_loc13_);
                     if(_loc2_ != null)
                     {
                        _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc2_.IDTemplate) as TArticle;
                        if(_loc5_.Level >= _loc6_)
                        {
                           ++this.FActivityPartnerData.TaskSchedule[TActivityPartnerData.TASKINDEX2];
                        }
                     }
                     _loc13_++;
                  }
               }
               _loc11_++;
            }
            _loc9_++;
         }
         _loc1_ = SLogicsCore.Character.Treasures;
         _loc10_ = _loc1_.Count;
         _loc6_ = this.FActivityPartnerData.TaskConditions[TActivityPartnerData.TASKINDEX3][0];
         _loc9_ = 0;
         while(_loc9_ < _loc10_)
         {
            _loc2_ = _loc1_.GetInventoryByIndex(_loc9_);
            _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc2_.IDTemplate) as TArticle;
            if(_loc5_.Level == _loc6_)
            {
               ++this.FActivityPartnerData.TaskSchedule[TActivityPartnerData.TASKINDEX3];
            }
            _loc9_++;
         }
         _loc7_ = SLogicsCore.Character.Heros;
         _loc10_ = _loc7_.Count;
         _loc9_ = 0;
         while(_loc9_ < _loc10_)
         {
            _loc8_ = _loc7_.GetHeroByIndex(_loc9_);
            _loc12_ = _loc8_.TalismansMounted.Capacity;
            _loc11_ = 0;
            while(_loc11_ < _loc12_)
            {
               _loc2_ = _loc8_.TalismansMounted.GetInventoryByIndex(_loc11_);
               if(_loc2_ != null)
               {
                  _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc2_.IDTemplate) as TArticle;
                  if(_loc5_.Level == _loc6_)
                  {
                     ++this.FActivityPartnerData.TaskSchedule[TActivityPartnerData.TASKINDEX3];
                  }
               }
               _loc11_++;
            }
            _loc9_++;
         }
      }
      
      protected function CheckRoseOpenNum() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FActivityPartnerData.TaskReciveRecored.length);
         this.FActivityPartnerData.RoseOpenNum = 0;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FActivityPartnerData.TaskReciveRecored[_loc1_])
            {
               ++this.FActivityPartnerData.RoseOpenNum;
            }
            _loc1_++;
         }
      }
      
      override protected function ProcessorOnGiftBoxOut(param1:Object) : void
      {
         FGiftOverLayer.Hide();
      }
      
      override protected function ProcessorOnGiftBoxMove(param1:Object, param2:Object, param3:Object = null) : void
      {
         var _loc4_:TInventories = null;
         var _loc5_:int = 0;
         super.ProcessorOnGiftBoxMove(param1,param2,param3);
         if(param3 != null)
         {
            _loc5_ = param3 as int;
         }
         _loc4_ = param2 as TInventories;
         FGiftBoxTipData.TipReset();
         FGiftBoxTipData.NormalInventories = _loc4_;
         FGiftBoxTipData.AwardType = _loc5_;
         FGiftBoxTipData.NeedColour = true;
         FGiftOverLayer.Context = FGiftBoxTipData;
         FGiftOverLayer.Render(FUICore.MouseCoordinate);
         FGiftOverLayer.Show();
      }
      
      protected function ShutDownWindow(param1:Object) : void
      {
         ProcessorClose();
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorHDWindowPartner.Load();
            return;
         }
         if(this.FInited)
         {
            this.CheckTaskSchedule();
            this.FProcessorHDWindowPartner.Show(FCurAtoms,FHDActivityConfig,this.FActivityPartnerData);
         }
         else
         {
            FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_Partner);
            FCurAtoms = GetAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_Partner);
            Perform_CS_ActivityInitReq(FCurAtoms.Identifier);
         }
      }
   }
}

