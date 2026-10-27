package Processors.Game.Lobby.WorldMapBleach.LargeWorldMap
{
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Campaign.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.Items.*;
   import Logics.Streamization.Inventories.*;
   import Logics.Vip.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Rendering.Texts.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   
   public class TProcessorWindowInstanceChoose extends TProcessorLobbyWindow
   {
      
      protected static const SELECTSTATUS_NONE:int = -1;
      
      protected static const SELECTSTATUS_NORMAL:int = 0;
      
      protected static const SELECTSTATUS_HARD:int = 1;
      
      protected static const MAX_STAR_COUNT:int = 5;
      
      protected static const MAX_SLOT_LENGTH:int = 16;
      
      protected const MinTextNameLevel:uint = 110;
      
      protected var FHelpTips:THint;
      
      protected var FScene:MovieClip;
      
      protected var FBtn_Reset:TUIButton;
      
      protected var FBtn_Enter:TUIButton;
      
      protected var FBtn_Auto:TUIButton;
      
      protected var FCampaignModel:TCampaign;
      
      protected var FCityid:int;
      
      protected var FCurMissionID:int;
      
      protected var FSelectStatus:int;
      
      protected var FMaxStatus:int;
      
      protected var FNormalCityID:int;
      
      protected var FHardCityID:int;
      
      protected var FBackgroundBitmap:Bitmap;
      
      protected var FUISlots:Vector.<TUISlot>;
      
      protected var FIDTemplates:Vector.<uint>;
      
      protected var FSingleBins:TBins;
      
      protected var FInventories:TInventories;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FHintBtnReset:THint;
      
      protected var FHintBtnResetVipOpen:THint;
      
      protected var FNeedCost:int;
      
      protected var FCharacter:TCharacter;
      
      protected var FVipData:TVip;
      
      protected var FSingleResetChargeBins:TBins;
      
      protected var FInitSlot:Boolean;
      
      protected var FNodalModel:TNodal;
      
      protected var FMaxResetCount:uint;
      
      protected var FIsInit:Boolean;
      
      protected var FIsInitStatus:Boolean;
      
      protected var FUIWindowRecharge:TUIWindowRecharge;
      
      protected var FSlotsOnMove:Function;
      
      protected var FSlotsOnOut:Function;
      
      protected var FHintOnMove:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FOnHelpTipsOver:Function;
      
      protected var FOnHelpTipsOut:Function;
      
      protected var FOnEnterBattle:Function;
      
      protected var FOnEnterAutoBattle:Function;
      
      public function TProcessorWindowInstanceChoose(param1:TUIComponent, param2:TNodal)
      {
         super(param1);
         this.FHelpTips = new THint();
         this.FNodalModel = param2;
         this.FIsInit = false;
         this.FIsInitStatus = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_CAMPAIGN.RESOURCESID_Campaign);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIWait() : void
      {
         if(SResourcesCore.LoadingPrimary)
         {
            return;
         }
         this.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FSingleBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Single);
         this.FSingleResetChargeBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SingleResetCharge);
         this.FUIWindowRecharge = SUtilityOverLayer.UIWindowRecharge;
         this.InitCampChoose();
         this.FIsInit = true;
         this.UpdataUI();
         super.ResourcesPerform_UIDispatch();
      }
      
      protected function InitCampChoose() : void
      {
         this.FInitSlot = false;
         this.FHintBtnReset = new THint();
         this.FHintBtnResetVipOpen = new THint();
         this.FNeedCost = 0;
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         this.FInventories = new TInventories();
         this.SelectStatus = SELECTSTATUS_NONE;
         this.FUISlots = new Vector.<TUISlot>();
         this.FIDTemplates = new Vector.<uint>();
         this.FScene = TUtilityReflection.CreateDisplayObjectInstance(CONST_CAMPAIGN.RESOURCE_ClassName_NodalFB) as MovieClip;
         addChild(this.FScene);
         this.FScene.Btn_Close.addEventListener(MouseEvent.CLICK,this.OnCloseView);
         this.FScene.Btn_Help.addEventListener(MouseEvent.MOUSE_MOVE,this.ButtonHelpOnOver,false,0,true);
         this.FScene.Btn_Help.addEventListener(MouseEvent.MOUSE_OUT,this.ButtonHelpOnOut,false,0,true);
         this.FBtn_Reset = new TUIButton();
         this.FBtn_Reset.Substrate = this.FScene.mc_nodalContrl.btn_reset;
         this.FBtn_Reset.OnClick = this.OnReset;
         this.FBtn_Reset.OnMove = this.Btn_ResetOnMove;
         this.FBtn_Reset.OnOut = this.Btn_ResetOnOut;
         this.FBtn_Enter = new TUIButton();
         this.FBtn_Enter.Substrate = this.FScene.mc_nodalContrl.btn_enter;
         this.FBtn_Enter.OnClick = this.OnEnterBattleClick;
         this.FBtn_Auto = new TUIButton();
         this.FBtn_Auto.Substrate = this.FScene.mc_nodalContrl.btn_auto;
         this.FBtn_Auto.OnClick = this.OnAutoBattle;
         this.FScene.mc_nodalContrl.mc_bg_normal.mc_select_0.addEventListener(MouseEvent.CLICK,this.OnSelectNormal);
         this.FScene.mc_nodalContrl.mc_bg_hard.mc_select_1.addEventListener(MouseEvent.CLICK,this.OnSelectHard);
         this.FBackgroundBitmap = new Bitmap();
         this.FScene.mc_bg.addChild(this.FBackgroundBitmap);
         this.FCharacter = SLogicsCore.Character;
         this.FVipData = this.FCharacter.VipData;
      }
      
      protected function InitSlot() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TUISlot = null;
         _loc1_ = 0;
         while(_loc1_ < MAX_SLOT_LENGTH)
         {
            _loc2_ = this.GetSlot();
            _loc2_.Resource = this.FScene["MC_Slot_" + _loc1_];
            _loc2_.Init();
            this.FUISlots[_loc1_] = _loc2_;
            _loc1_++;
         }
      }
      
      protected function set SelectStatus(param1:int) : void
      {
         if(this.FScene == null)
         {
            return;
         }
         this.FSelectStatus = param1;
         if(this.FSelectStatus == SELECTSTATUS_NONE)
         {
            this.FScene.mc_nodalContrl.mc_bg_normal.mc_select_0.gotoAndStop("cancle");
            this.FScene.mc_nodalContrl.mc_bg_hard.mc_select_1.gotoAndStop("cancle");
         }
         else if(this.FSelectStatus == SELECTSTATUS_NORMAL)
         {
            this.FScene.mc_nodalContrl.mc_bg_normal.mc_select_0.gotoAndStop("ok");
            this.FScene.mc_nodalContrl.mc_bg_hard.mc_select_1.gotoAndStop("cancle");
         }
         else if(this.FSelectStatus == SELECTSTATUS_HARD)
         {
            this.FScene.mc_nodalContrl.mc_bg_normal.mc_select_0.gotoAndStop("cancle");
            this.FScene.mc_nodalContrl.mc_bg_hard.mc_select_1.gotoAndStop("ok");
         }
         if(this.FMaxStatus < SELECTSTATUS_HARD)
         {
            this.FScene.mc_nodalContrl.mc_bg_hard.mc_select_1.gotoAndStop("cancle");
         }
      }
      
      protected function get SelectStatus() : int
      {
         return this.FSelectStatus;
      }
      
      protected function GetSlot() : TUISlot
      {
         var _loc1_:TUISlot = null;
         _loc1_ = new TUISlot(this);
         _loc1_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         _loc1_.OnOver = this.FSlotsOnMove;
         _loc1_.OnOut = this.FSlotsOnOut;
         _loc1_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
         return _loc1_;
      }
      
      protected function SlotsOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TInventory = null;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         _loc5_ = param2 as TInventory;
         _loc6_ = SResourcesCore.TexturesInventory;
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc5_.IDTexture);
         if(_loc7_ != null)
         {
            param3.Value = _loc7_.GetAnimationSequenceByIdentifier(param4);
         }
         else
         {
            _loc6_.LoadSecondary(_loc5_.IDTexture);
         }
      }
      
      protected function SetSlot() : void
      {
         var _loc1_:TUISlot = null;
         var _loc2_:int = 0;
         var _loc3_:TItem = null;
         var _loc4_:Sprite = null;
         var _loc5_:String = null;
         var _loc6_:TSingleResetCharge = null;
         var _loc7_:TItems = null;
         if(this.FCampaignModel == null)
         {
            return;
         }
         if(!this.FInitSlot)
         {
            this.FInitSlot = true;
            this.InitSlot();
         }
         this.FIDTemplates.length = 0;
         if(this.FCurMissionID == this.FNormalCityID)
         {
            _loc7_ = this.FCampaignModel.NormalDropItems;
         }
         else
         {
            _loc7_ = this.FCampaignModel.HardDropItems;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc7_.Count)
         {
            _loc3_ = _loc7_.RewardByIndex(_loc2_);
            this.FIDTemplates[_loc2_] = _loc3_.ID;
            _loc2_++;
         }
         this.FInventories.Clear();
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,this.FInventories,this.FIDTemplates);
         _loc2_ = 0;
         while(_loc2_ < this.FInventories.Count)
         {
            this.FUISlots[_loc2_].Context = this.FInventories.GetInventoryByIndex(_loc2_);
            this.FScene["MC_Slot_" + _loc2_].visible = true;
            _loc2_++;
         }
         while(_loc2_ < MAX_SLOT_LENGTH)
         {
            this.FScene["MC_Slot_" + _loc2_].visible = false;
            _loc2_++;
         }
         if(this.FCampaignModel.ResetCount != 0)
         {
            _loc6_ = this.FSingleResetChargeBins.GetDatebaseByIdentifier(this.FCampaignModel.ResetCount) as TSingleResetCharge;
            this.FNeedCost = _loc6_.Value;
            _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.WORLDMAP_STRING_05);
            _loc5_ = _loc5_.split("%count%").join(this.FNeedCost);
         }
         else
         {
            _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.WORLDMAP_STRING_04);
         }
         this.FHintBtnReset.Caption = _loc5_;
      }
      
      protected function CheckGoldIsEnough() : Boolean
      {
         if(this.FNeedCost > this.FCharacter.CreditGold + this.FCharacter.CreditGiftCertificate)
         {
            this.FUIWindowRecharge.SetGoldNum(this.FNeedCost);
            this.FUIWindowRecharge.Visible = true;
            return false;
         }
         return true;
      }
      
      protected function UpdataUI() : void
      {
         var _loc1_:TCity = null;
         var _loc2_:TSingle = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         if(!this.FIsInit || this.FNodalModel == null || this.FCampaignModel == null)
         {
            return;
         }
         if(this.FNodalModel.GetCampStarByID(this.FCampaignModel.NormalCampId) > 0)
         {
            this.FMaxStatus = SELECTSTATUS_HARD;
         }
         if(this.FCurMissionID == this.FNormalCityID)
         {
            this.SelectStatus = SELECTSTATUS_NORMAL;
            _loc5_ = uint(this.FNodalModel.GetCampStarByID(this.FCampaignModel.NormalCampId));
         }
         else if(this.FCurMissionID == this.FHardCityID)
         {
            this.SelectStatus = SELECTSTATUS_HARD;
            _loc5_ = uint(this.FNodalModel.GetCampStarByID(this.FCampaignModel.HardCampId));
         }
         else
         {
            this.SelectStatus = SELECTSTATUS_NONE;
            _loc5_ = 0;
         }
         _loc2_ = this.FSingleBins.GetDatebaseByIdentifier(this.FCurMissionID) as TSingle;
         if(this.FScene.TF_MapName != null)
         {
            this.FScene.TF_MapName.text = _loc2_.Name;
            this.FScene.TF_MapName.visible = true;
         }
         this.FScene.tf_desc.text = _loc2_.Desc;
         _loc3_ = _loc2_.Name;
         this.FScene.TF_Title.text = _loc3_.toString();
         this.FScene.mc_nodalContrl.tf_enterTimes.text = this.FCampaignModel.EnterCount + "/" + (this.FVipData.DailySingleReset + 1);
         this.FBtn_Enter.Enabled = !(this.FCampaignModel.EnterCount > this.FVipData.DailySingleReset + 1 && this.FCampaignModel.IsPass());
         SResourcesCore.TexturesBackgroundIcon.LoadAutoSecondary(_loc2_.BigImage,this.BackGroundPicArrive);
         if(_loc5_ == 0)
         {
            this.FScene.mc_nodalContrl.mc_star.visible = false;
         }
         else
         {
            this.FScene.mc_nodalContrl.mc_star.visible = true;
            this.FScene.mc_nodalContrl.mc_star.gotoAndStop(_loc5_);
         }
         if(this.FCampaignModel.Diffculty < 0)
         {
            this.FScene.mc_nodalContrl.mc_info.visible = false;
            this.FScene.mc_nodalContrl.mc_bg_normal.mc_select_0.visible = true;
            this.FScene.mc_nodalContrl.mc_bg_hard.mc_select_1.visible = true;
            this.FScene.mc_nodalContrl.mc_bg_normal.visible = true;
            if(this.FNodalModel.GetCampStarByID(this.FNormalCityID) > 0)
            {
               this.FScene.mc_nodalContrl.mc_bg_hard.visible = true;
               if(!this.FIsInitStatus)
               {
                  this.SelectStatus = SELECTSTATUS_HARD;
                  this.FCurMissionID = this.FHardCityID;
                  this.FIsInitStatus = true;
               }
            }
            else
            {
               this.FScene.mc_nodalContrl.mc_bg_hard.visible = false;
               this.FCurMissionID = this.FNormalCityID;
            }
            this.FBtn_Reset.Visible = false;
            this.FBtn_Auto.Visible = Boolean(this.FNodalModel.GetCampaignById(this.FCityid).LayerIndex + 1 <= this.FNodalModel.GetCampMaxLayerIndex(this.FCurMissionID));
            this.FBtn_Enter.Visible = true;
         }
         else if(this.FCampaignModel.IsPass())
         {
            this.FScene.mc_nodalContrl.mc_info.visible = true;
            this.FScene.mc_nodalContrl.mc_bg_normal.mc_select_0.visible = false;
            this.FScene.mc_nodalContrl.mc_bg_hard.mc_select_1.visible = false;
            this.FScene.mc_nodalContrl.mc_bg_normal.visible = false;
            this.FScene.mc_nodalContrl.mc_bg_hard.visible = false;
            this.FBtn_Reset.Visible = Boolean(this.FCampaignModel.ResetCount < this.FVipData.DailySingleReset + 1);
            this.FBtn_Auto.Visible = false;
            this.FBtn_Enter.Visible = false;
            this.FScene.mc_nodalContrl.mc_info.tf_hard.text = _loc2_.Hard;
            this.FScene.mc_nodalContrl.mc_info.tf_pos.text = this.FCampaignModel.GetMaxEnemyCount(this.FSelectStatus) + "/" + this.FCampaignModel.GetMaxEnemyCount(this.FSelectStatus);
         }
         else
         {
            this.FScene.mc_nodalContrl.mc_info.visible = true;
            this.FScene.mc_nodalContrl.mc_bg_normal.mc_select_0.visible = false;
            this.FScene.mc_nodalContrl.mc_bg_hard.mc_select_1.visible = false;
            this.FScene.mc_nodalContrl.mc_bg_normal.visible = false;
            this.FScene.mc_nodalContrl.mc_bg_hard.visible = false;
            this.FBtn_Reset.Visible = Boolean(this.FCampaignModel.ResetCount < this.FVipData.DailySingleReset + 1);
            this.FBtn_Auto.Visible = Boolean(this.FNodalModel.GetCampaignById(this.FCityid).LayerIndex + 1 <= this.FNodalModel.GetCampMaxLayerIndex(this.FCurMissionID));
            this.FBtn_Enter.Visible = true;
            this.FScene.mc_nodalContrl.mc_info.tf_hard.text = _loc2_.Hard;
            this.FScene.mc_nodalContrl.mc_info.tf_pos.text = this.FCampaignModel.GetCurEnemyCount(this.FSelectStatus) + "/" + this.FCampaignModel.GetMaxEnemyCount(this.FSelectStatus);
         }
         this.SetSlot();
         if(!this.FBtn_Reset.Visible)
         {
            if(this.FVipData.VipLevel < this.FVipData.VipOpenLevel_DailySingleReset)
            {
               this.FBtn_Reset.Visible = true;
               this.FBtn_Reset.Enabled = false;
            }
            else
            {
               this.FBtn_Reset.Enabled = true;
            }
         }
      }
      
      protected function OnCloseView(param1:MouseEvent) : void
      {
         Visible = false;
         this.Reset();
      }
      
      protected function ButtonHelpOnOver(param1:MouseEvent) : void
      {
         if(TUtilityString.Empty(this.FHelpTips.Content))
         {
            this.FHelpTips.Content = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELPTIPS_Campaign);
         }
         if(this.FOnHelpTipsOver != null)
         {
            this.FOnHelpTipsOver(this,this.FHelpTips);
         }
      }
      
      protected function ButtonHelpOnOut(param1:MouseEvent) : void
      {
         if(this.FOnHelpTipsOut != null)
         {
            this.FOnHelpTipsOut(this,this.FHelpTips);
         }
      }
      
      protected function OnReset(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:ByteArray = null;
         var _loc4_:TPacket = null;
         if(Boolean(param2.currentTarget) && !param2.currentTarget.buttonMode)
         {
            return;
         }
         if(!this.CheckGoldIsEnough())
         {
            return;
         }
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_LOBBY_WorldMap_ResetFB);
         _loc3_ = _loc4_.Data;
         _loc3_.writeInt(this.FCityid);
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
         this.FIsInitStatus = false;
      }
      
      protected function OnEnterBattleClick(param1:Object, param2:MouseEvent) : void
      {
         Visible = false;
         if(this.FCampaignModel.Diffculty < 0)
         {
            this.FCampaignModel.EnterCount += 1;
         }
         if(this.FCurMissionID == this.FHardCityID)
         {
            this.FCampaignModel.Diffculty = TCampaign.Type_Hard;
         }
         else if(this.FCurMissionID == this.FNormalCityID)
         {
            this.FCampaignModel.Diffculty = TCampaign.Type_Noraml;
         }
         if(this.FOnEnterBattle != null)
         {
            this.FOnEnterBattle(this,this.FCityid,CONST_BATTLE.BattleType_Camp,this.FCurMissionID);
         }
      }
      
      protected function OnAutoBattle(param1:Object, param2:MouseEvent) : void
      {
         Visible = false;
         if(this.FCampaignModel.Diffculty < 0)
         {
            this.FCampaignModel.EnterCount += 1;
         }
         if(this.FCurMissionID == this.FHardCityID)
         {
            this.FCampaignModel.Diffculty = TCampaign.Type_Hard;
         }
         else if(this.FCurMissionID == this.FNormalCityID)
         {
            this.FCampaignModel.Diffculty = TCampaign.Type_Noraml;
         }
         if(this.FOnEnterAutoBattle != null)
         {
            this.FOnEnterAutoBattle(this,this.FCityid,this.FCurMissionID);
         }
      }
      
      protected function OnSelectNormal(param1:MouseEvent) : void
      {
         if(this.SelectStatus == SELECTSTATUS_NORMAL)
         {
            return;
         }
         this.SelectStatus = SELECTSTATUS_NORMAL;
         this.FCurMissionID = this.FNormalCityID;
         this.Updata();
      }
      
      protected function OnSelectHard(param1:MouseEvent) : void
      {
         if(this.FMaxStatus < SELECTSTATUS_HARD)
         {
            return;
         }
         if(this.SelectStatus == SELECTSTATUS_HARD)
         {
            return;
         }
         this.SelectStatus = SELECTSTATUS_HARD;
         this.FCurMissionID = this.FHardCityID;
         this.Updata();
      }
      
      protected function Btn_ResetOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:String = null;
         if(Boolean(param2.currentTarget) && Boolean(param2.currentTarget.buttonMode))
         {
            if(this.FHintOnMove != null)
            {
               this.FHintOnMove(param2,this.FHintBtnReset);
            }
         }
         else
         {
            _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.COMMON_OPENVIPTIP);
            this.FHintBtnResetVipOpen.Caption = TUtilityString.Format(_loc3_,this.FVipData.VipOpenLevel_DailySingleReset);
            if(this.FHintOnMove != null)
            {
               this.FHintOnMove(param2,this.FHintBtnResetVipOpen);
            }
         }
      }
      
      protected function Btn_ResetOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(param2,this.FHintBtnReset);
         }
      }
      
      protected function BackGroundPicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         this.FBackgroundBitmap.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
      }
      
      public function set SlotsOnMove(param1:Function) : void
      {
         this.FSlotsOnMove = param1;
      }
      
      public function get SlotsOnMove() : Function
      {
         return this.FSlotsOnMove;
      }
      
      public function set SlotsOnOut(param1:Function) : void
      {
         this.FSlotsOnOut = param1;
      }
      
      public function get SlotsOnOut() : Function
      {
         return this.FSlotsOnOut;
      }
      
      public function get HintOnMove() : Function
      {
         return this.FHintOnMove;
      }
      
      public function set HintOnMove(param1:Function) : void
      {
         this.FHintOnMove = param1;
      }
      
      public function get HintOnOut() : Function
      {
         return this.FHintOnOut;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function get OnHelpTipsOver() : Function
      {
         return this.FOnHelpTipsOver;
      }
      
      public function set OnHelpTipsOver(param1:Function) : void
      {
         this.FOnHelpTipsOver = param1;
      }
      
      public function get OnHelpTipsOut() : Function
      {
         return this.FOnHelpTipsOut;
      }
      
      public function set OnHelpTipsOut(param1:Function) : void
      {
         this.FOnHelpTipsOut = param1;
      }
      
      public function get OnEnterBattle() : Function
      {
         return this.FOnEnterBattle;
      }
      
      public function set OnEnterBattle(param1:Function) : void
      {
         this.FOnEnterBattle = param1;
      }
      
      public function get OnEnterAutoBattle() : Function
      {
         return this.FOnEnterAutoBattle;
      }
      
      public function set OnEnterAutoBattle(param1:Function) : void
      {
         this.FOnEnterAutoBattle = param1;
      }
      
      public function SetCityID(param1:int) : void
      {
         if(!this.FIsInit)
         {
            Load();
         }
         this.FCityid = param1;
         this.FCampaignModel = this.FNodalModel.GetCampaignById(param1);
         this.FNormalCityID = this.FCampaignModel.NormalCampId;
         this.FHardCityID = this.FCampaignModel.HardCampId;
         if(this.FCampaignModel != null)
         {
            if(this.FCampaignModel.Diffculty == TCampaign.Type_Hard)
            {
               this.FMaxStatus = SELECTSTATUS_HARD;
               this.FCurMissionID = this.FHardCityID;
            }
            else if(this.FCampaignModel.Diffculty == TCampaign.Type_Noraml)
            {
               this.FMaxStatus = SELECTSTATUS_NORMAL;
               this.FCurMissionID = this.FNormalCityID;
            }
            else if(this.FNodalModel.GetCampStarByID(this.FCampaignModel.NormalCampId) > 0)
            {
               this.FMaxStatus = SELECTSTATUS_HARD;
               this.FCurMissionID = this.FHardCityID;
            }
            else
            {
               this.FMaxStatus = SELECTSTATUS_NORMAL;
               this.FCurMissionID = this.FNormalCityID;
            }
            this.FIsInitStatus = false;
            this.UpdataUI();
            return;
         }
         this.FMaxStatus = SELECTSTATUS_NONE;
         this.SelectStatus = SELECTSTATUS_NONE;
         this.FCurMissionID = 0;
         this.FCampaignModel = null;
      }
      
      public function Updata() : void
      {
         this.UpdataUI();
      }
      
      public function UpdataBitmap() : void
      {
         var _loc1_:int = 0;
         if(this.FCampaignModel == null || this.FSingleBins == null || this.FUISlots == null)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < this.FUISlots.length)
         {
            this.FUISlots[_loc1_].Update();
            _loc1_++;
         }
      }
      
      public function UpDataNodalModel(param1:TNodal) : void
      {
         this.FNodalModel = param1;
         this.UpdataUI();
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.FBackgroundBitmap != null)
         {
            this.FBackgroundBitmap.bitmapData = null;
         }
         if(this.FUISlots != null)
         {
            _loc2_ = int(this.FUISlots.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FUISlots[_loc1_].Context = null;
               _loc1_++;
            }
         }
      }
   }
}

