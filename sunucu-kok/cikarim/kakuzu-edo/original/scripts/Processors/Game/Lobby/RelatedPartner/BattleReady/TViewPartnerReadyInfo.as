package Processors.Game.Lobby.RelatedPartner.BattleReady
{
   import Components.Pages.TUIPage;
   import Components.Standard.*;
   import Foundation.Network.*;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.SLogicsCore;
   import Logics.Streamization.RelatedPartner.VO.TPartnerTrainEnemyVO;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.RelatedPartner.PartnerTrain.TItemTrainPoint;
   import Processors.Game.Lobby.TacticalDeployment.Components.TDeploymentTip;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Lobby.WorldMapBleach.MonsterMap.Components.TArmyTip;
   import Processors.Game.Utilities.HyperLink.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TViewPartnerReadyInfo extends TProcessorLobbyWindow
   {
      
      protected static const CAMPSLOTNUM:int = 7;
      
      protected static const PAGESIZE:int = 9;
      
      protected static const INDEX_Station_Front:int = 1;
      
      protected static const INDEX_Station_Middle:int = 2;
      
      protected static const INDEX_Station_After:int = 3;
      
      protected static const SOULSTAR_TabIndex:uint = 1;
      
      protected static const SOULSTAR_BaseID:uint = 0;
      
      protected static const DeployPositionLookTable:Vector.<int> = Vector.<int>([1,7,6,8,12,11,13]);
      
      protected static const DeployClassLookTable:Vector.<int> = Vector.<int>([1,2,2,2,3,3,3]);
      
      protected static const LevelFormat:String = "Lv.%0";
      
      protected var FMainUI:Sprite;
      
      protected var FBtnFight:TUIButton;
      
      protected var FBtnEquip:TUIButton;
      
      protected var FBtnSkill:TUIButton;
      
      protected var FTFCondition:TextField;
      
      protected var FSlots_My:Vector.<IRelatedReadySlot>;
      
      protected var FHerosFighting:THeros;
      
      protected var FMyCampAnimationSequence:Vector.<TAnimationSequence>;
      
      protected var FSelectedUnloadHero:THero;
      
      protected var FUnloadingHero:Boolean;
      
      protected var FIfCanUnload:Boolean;
      
      protected var FSlots_Enemy:Vector.<IRelatedReadySlot>;
      
      protected var FUIPage:TUIPage;
      
      protected var FSlots_Backup:Vector.<IRelatedReadySlot>;
      
      protected var FMountPointsAnimationSequence:Vector.<TAnimationSequence>;
      
      protected var FCurrentPage:int;
      
      protected var FHerosBackup:THeros;
      
      protected var FUIImage:TUIImage;
      
      protected var FSwitchingDeployment:Boolean;
      
      protected var FSelectedHero:THero;
      
      protected var FSelectedSlot:TItemReadyCampSlot;
      
      protected var FEnemyVO:TPartnerTrainEnemyVO;
      
      protected var FArmyTip:TArmyTip;
      
      protected var FHeroInfoTip:TDeploymentTip;
      
      protected var FPveId:int;
      
      protected var FOnSetBattleStatus:Function;
      
      protected var FSwitchFunction:Function;
      
      public function TViewPartnerReadyInfo(param1:TUIComponent, param2:Sprite)
      {
         this.FMainUI = param2;
         super(param1);
         this.UIDispatchBtns();
         this.UIDispatchMyCamp();
         this.UIDispatchEnemyCamp();
         this.UIDispatchBackup();
         this.FHeroInfoTip = new TDeploymentTip(this.Parent);
         this.FHeroInfoTip.Visible = false;
      }
      
      protected function UIDispatchBtns() : void
      {
         this.FBtnFight = new TUIButton();
         this.FBtnFight.Substrate = this.FMainUI["btn_Fight"];
         this.FBtnFight.OnClick = this.BtnOnClick;
         this.FBtnEquip = new TUIButton();
         this.FBtnEquip.Substrate = this.FMainUI["btn_Equip"];
         this.FBtnEquip.OnClick = this.BtnOnClick;
         this.FBtnSkill = new TUIButton();
         this.FBtnSkill.Substrate = this.FMainUI["btn_Skill"];
         this.FBtnSkill.OnClick = this.BtnOnClick;
         this.FTFCondition = this.FMainUI["TF_Condition"];
         this.FTFCondition.text = "";
      }
      
      protected function UIDispatchMyCamp() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:TItemReadyCampSlot = null;
         var _loc3_:int = 0;
         _loc1_ = this.FMainUI["MyCampInfo"];
         this.FSlots_My = new Vector.<IRelatedReadySlot>();
         this.FMyCampAnimationSequence = new Vector.<TAnimationSequence>(PAGESIZE);
         this.FHerosFighting = new THeros();
         _loc3_ = 0;
         while(_loc3_ < CAMPSLOTNUM)
         {
            _loc2_ = new TItemReadyCampSlot(this,_loc1_["Slot" + _loc3_]);
            _loc2_.IsOperatable = true;
            _loc2_.SlotIndex = _loc3_;
            _loc2_.SlotOnDown = this.MyCampSlotOnDown;
            _loc2_.SlotOnOut = this.MyCampSlotOnOut;
            _loc2_.SlotOnOver = this.MyCampSlotOnOver;
            _loc2_.Init();
            this.FSlots_My.push(_loc2_);
            _loc3_++;
         }
      }
      
      protected function UIDispatchEnemyCamp() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:TItemReadyCampSlot = null;
         var _loc3_:int = 0;
         _loc1_ = this.FMainUI["EnemyCampInfo"];
         this.FSlots_Enemy = new Vector.<IRelatedReadySlot>();
         _loc3_ = 0;
         while(_loc3_ < CAMPSLOTNUM)
         {
            _loc2_ = new TItemReadyCampSlot(this,_loc1_["Slot" + _loc3_]);
            _loc2_.SlotIndex = _loc3_;
            _loc2_.SlotOnOut = this.EnemyCampSlotOnOut;
            _loc2_.SlotOnMove = this.EnemyCampSlotOnOver;
            _loc2_.Init();
            this.FSlots_Enemy.push(_loc2_);
            _loc3_++;
         }
         this.FEnemyVO = new TPartnerTrainEnemyVO();
         this.FArmyTip = new TArmyTip(this);
         this.FArmyTip.Visible = false;
      }
      
      protected function UIDispatchBackup() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:TItemReadyBackupSlot = null;
         var _loc3_:int = 0;
         this.FUIPage = new TUIPage(this);
         this.FUIPage.ButtonPrevious.Substrate = this.FMainUI["MC_PageLeft"];
         this.FUIPage.ButtonNext.Substrate = this.FMainUI["MC_PageRight"];
         this.FUIPage.PageSize = PAGESIZE;
         this.FUIPage.OnChangePage = this.PageOnChange;
         this.FUIPage.Init();
         this.FMountPointsAnimationSequence = new Vector.<TAnimationSequence>(PAGESIZE);
         this.FSlots_Backup = new Vector.<IRelatedReadySlot>();
         _loc3_ = 0;
         while(_loc3_ < PAGESIZE)
         {
            _loc2_ = new TItemReadyBackupSlot(this,this.FMainUI["Slot" + _loc3_]);
            _loc2_.SlotIndex = _loc3_;
            _loc2_.SlotOnDown = this.SlotsOnDragBegin;
            _loc2_.SlotOnOver = this.SlotsOnOver;
            _loc2_.SlotOnOut = this.SlotsOnOut;
            _loc2_.Init();
            this.FSlots_Backup.push(_loc2_);
            _loc3_++;
         }
         this.FHerosBackup = new THeros();
         this.FUIImage = new TUIImage(FParent);
         this.FUIImage.mouseEnabled = false;
         this.FUIImage.alpha = 0.6;
         this.FUIImage.SetRegistrationPoint(-24,-24);
         FUICore.UIStage.addEventListener(MouseEvent.MOUSE_UP,this.SlotsOnDragEnd);
         FUICore.UIStage.addEventListener(MouseEvent.MOUSE_UP,this.UnloadOnEnd);
      }
      
      protected function ResetCamps(param1:Vector.<IRelatedReadySlot>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:IRelatedReadySlot = null;
         _loc3_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1[_loc2_];
            _loc4_.Visible = false;
            _loc4_.MountPoint.bitmapData = null;
            _loc4_.Level = 0;
            _loc2_++;
         }
      }
      
      protected function RenderUI() : void
      {
         this.FHerosFighting.Clear();
         this.FHerosBackup.Clear();
         this.SelectHeros(this.FHerosFighting,this.FHerosBackup);
         this.RenderMyCampInfo();
         this.RenderEnemyCampInfo();
         this.RenderBackupCampInfo();
      }
      
      protected function RenderMyCampInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Vector.<int> = null;
         var _loc6_:THero = null;
         this.ClearAnimationSequnce(this.FMyCampAnimationSequence);
         _loc5_ = DeployPositionLookTable;
         this.ResetCamps(this.FSlots_My);
         _loc2_ = this.FHerosFighting.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc6_ = this.FHerosFighting.GetHeroByIndex(_loc1_);
            _loc3_ = _loc5_.indexOf(_loc6_.FightPosition);
            this.FSlots_My[_loc3_].Visible = true;
            TItemReadyCampSlot(this.FSlots_My[_loc3_]).SetMask(false);
            SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc6_.SmallID,this.MyCampPicArrive);
            this.FSlots_My[_loc3_].Level = _loc6_.RebirthLevel;
            _loc1_++;
         }
      }
      
      protected function RenderEnemyCampInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Vector.<int> = null;
         var _loc6_:TRoleModel = null;
         _loc5_ = DeployPositionLookTable;
         this.ResetCamps(this.FSlots_Enemy);
         _loc2_ = int(this.FEnemyVO.TemplateIds.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = _loc5_.indexOf(this.FEnemyVO.FightPoses[_loc1_]);
            this.FSlots_Enemy[_loc3_].Visible = true;
            TItemReadyCampSlot(this.FSlots_Enemy[_loc3_]).SetMask(false);
            this.FSlots_Enemy[_loc3_].Level = 0;
            _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,this.FEnemyVO.TemplateIds[_loc1_]) as TRoleModel;
            SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc6_.RoleHead,this.EnemeyCampPicArrive);
            _loc1_++;
         }
      }
      
      protected function RenderBackupCampInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THero = null;
         _loc2_ = this.FCurrentPage * PAGESIZE;
         _loc3_ = _loc2_ + PAGESIZE;
         _loc3_ = _loc3_ > this.FHerosBackup.Count ? this.FHerosBackup.Count : _loc3_;
         this.ClearAnimationSequnce(this.FMountPointsAnimationSequence);
         _loc4_ = 0;
         this.ResetCamps(this.FSlots_Backup);
         this.SetupPage(this.FHerosBackup.Count,this.FCurrentPage,this.FUIPage);
         _loc1_ = _loc2_;
         while(_loc1_ < _loc3_)
         {
            _loc5_ = this.FHerosBackup.GetHeroByIndex(_loc1_);
            this.FSlots_Backup[_loc4_].Visible = true;
            SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc5_.SmallID,this.BackupCampPicArrive);
            this.FSlots_Backup[_loc4_].Level = _loc5_.RebirthLevel;
            _loc1_++;
            _loc4_++;
         }
      }
      
      protected function MyCampPicArrive(param1:Object, param2:TTexture, param3:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:THero = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Vector.<int> = null;
         _loc9_ = DeployPositionLookTable;
         _loc5_ = this.FHerosFighting.Count;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = this.FHerosFighting.GetHeroByIndex(_loc4_);
            _loc7_ = _loc9_.indexOf(_loc6_.FightPosition);
            if(param3 == _loc6_.SmallID)
            {
               this.FSlots_My[_loc7_].MountPoint.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
               this.FMyCampAnimationSequence[_loc7_] = param2.GetAnimationSequenceByIndex(0);
               break;
            }
            _loc4_++;
         }
      }
      
      protected function EnemeyCampPicArrive(param1:Object, param2:TTexture, param3:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Vector.<int> = null;
         var _loc9_:TRoleModel = null;
         _loc8_ = DeployPositionLookTable;
         _loc5_ = int(this.FEnemyVO.TemplateIds.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc8_.indexOf(this.FEnemyVO.FightPoses[_loc4_]);
            _loc9_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,this.FEnemyVO.TemplateIds[_loc4_]) as TRoleModel;
            SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc9_.RoleHead,this.EnemeyCampPicArrive);
            if(_loc9_.RoleHead == param3)
            {
               this.FSlots_Enemy[_loc6_].MountPoint.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
            }
            _loc4_++;
         }
      }
      
      protected function BackupCampPicArrive(param1:Object, param2:TTexture, param3:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:THero = null;
         _loc5_ = this.FCurrentPage * PAGESIZE;
         _loc6_ = _loc5_ + PAGESIZE;
         _loc6_ = _loc6_ > this.FHerosBackup.Count ? this.FHerosBackup.Count : _loc6_;
         _loc7_ = 0;
         _loc4_ = _loc5_;
         while(_loc4_ < _loc6_)
         {
            _loc8_ = this.FHerosBackup.GetHeroByIndex(_loc4_);
            if(_loc8_.Identifier == param3)
            {
               this.FMountPointsAnimationSequence[_loc7_] = param2.GetAnimationSequenceByIndex(0);
               this.FSlots_Backup[_loc7_].MountPoint.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
            }
            _loc4_++;
            _loc7_++;
         }
      }
      
      protected function ClearAnimationSequnce(param1:Vector.<TAnimationSequence>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            param1[_loc2_] = null;
            _loc2_++;
         }
      }
      
      protected function SetupPage(param1:int, param2:int, param3:TUIPage) : void
      {
         param3.TotalQuantity = param1;
         param3.Update();
         param3.PageIndex = param2;
      }
      
      protected function SelectHeros(param1:THeros, param2:THeros) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THeros = null;
         var _loc6_:THero = null;
         _loc5_ = SLogicsCore.Character.Heros;
         _loc4_ = _loc5_.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = _loc5_.GetHeroByIndex(_loc3_);
            if(_loc6_.FightPosition != 0)
            {
               param1.Add(_loc6_);
            }
            else
            {
               param2.Add(_loc6_);
            }
            _loc3_++;
         }
      }
      
      protected function GetMyCampHeroBySlotIndex(param1:int) : THero
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Vector.<int> = null;
         var _loc5_:int = 0;
         var _loc6_:THero = null;
         _loc4_ = DeployPositionLookTable;
         _loc5_ = DeployPositionLookTable[param1];
         _loc3_ = this.FHerosFighting.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = this.FHerosFighting.GetHeroByIndex(_loc2_);
            if(_loc6_.FightPosition == _loc5_)
            {
               return _loc6_;
            }
            _loc2_++;
         }
         return null;
      }
      
      protected function ShowHeroInfoTip(param1:THero) : void
      {
         this.FHeroInfoTip.Visible = true;
         if(param1 == null || this.FSwitchingDeployment)
         {
            return;
         }
         this.FHeroInfoTip.SetHeroData(param1);
      }
      
      protected function HideHeroInfoTip() : void
      {
         this.FHeroInfoTip.Visible = false;
      }
      
      protected function BtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         var _loc4_:TPacket = null;
         _loc3_ = param1 as TUIButton;
         this.Reset();
         switch(_loc3_)
         {
            case this.FBtnEquip:
               SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Heros);
               this.FSwitchFunction();
               break;
            case this.FBtnSkill:
               SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Star,SOULSTAR_TabIndex,SOULSTAR_BaseID);
               this.FSwitchFunction();
               break;
            case this.FBtnFight:
               _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Related_FightReq);
               _loc4_.Data.writeUnsignedInt(this.FPveId);
               SNetworkCore.Transceiver.PacketTransmit(_loc4_);
               if(this.FOnSetBattleStatus != null)
               {
                  this.FOnSetBattleStatus(this,CONST_BATTLE.BattleType_RelatedPartner,0);
               }
         }
      }
      
      protected function MyCampSlotOnDown(param1:int) : void
      {
         var _loc2_:THero = null;
         _loc2_ = this.GetMyCampHeroBySlotIndex(param1);
         if(_loc2_ != null)
         {
            this.FSelectedUnloadHero = _loc2_;
            this.FUIImage.Sequence = this.FMyCampAnimationSequence[param1];
            FUICore.MouseStartDrag(this.FUIImage,true);
         }
         this.FUnloadingHero = true;
      }
      
      protected function MyCampSlotOnOver(param1:int) : void
      {
         var _loc2_:THero = null;
         this.FSelectedSlot = TItemReadyCampSlot(this.FSlots_My[param1]);
         _loc2_ = this.GetMyCampHeroBySlotIndex(param1);
         if(this.FSelectedUnloadHero != null)
         {
            if(_loc2_ == this.FSelectedUnloadHero)
            {
               this.FIfCanUnload = false;
            }
         }
         else
         {
            this.ShowHeroInfoTip(_loc2_);
         }
      }
      
      protected function MyCampSlotOnOut(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:THero = null;
         if(this.FSelectedSlot == this.FSlots_My[param1])
         {
            this.FSelectedSlot = null;
         }
         if(this.FSelectedUnloadHero != null)
         {
            _loc3_ = this.GetMyCampHeroBySlotIndex(param1);
            if(_loc3_ == this.FSelectedUnloadHero)
            {
               this.FIfCanUnload = true;
            }
         }
         this.HideHeroInfoTip();
      }
      
      protected function EnemyCampSlotOnOver(param1:int) : void
      {
         var _loc2_:TEnemy = null;
         var _loc3_:int = 0;
         _loc3_ = this.FEnemyVO.FightPoses.indexOf(DeployPositionLookTable[param1]);
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Enemy,this.FEnemyVO.TemplateIds[_loc3_]) as TEnemy;
         this.FArmyTip.SetHeroData(null,_loc2_);
         this.FArmyTip.Visible = true;
      }
      
      protected function EnemyCampSlotOnOut(param1:int) : void
      {
         this.FArmyTip.Visible = false;
      }
      
      protected function SlotsOnOver(param1:int) : void
      {
         var _loc2_:THero = null;
         _loc2_ = this.FHerosBackup.GetHeroByIndex(param1 + this.FCurrentPage * PAGESIZE);
         this.ShowHeroInfoTip(_loc2_);
      }
      
      protected function SlotsOnOut(param1:int) : void
      {
         this.HideHeroInfoTip();
      }
      
      protected function SlotsOnDragBegin(param1:int) : void
      {
         var _loc2_:int = 0;
         _loc2_ += this.FCurrentPage * PAGESIZE + param1;
         if(this.FMountPointsAnimationSequence[param1] == null)
         {
            return;
         }
         this.FUIImage.Sequence = this.FMountPointsAnimationSequence[param1];
         FUICore.MouseStartDrag(this.FUIImage,true);
         this.FSwitchingDeployment = true;
         this.FSelectedHero = this.FHerosBackup.GetHeroByIndex(_loc2_);
         this.SwitchDeploySlotReady(this.FSelectedHero);
      }
      
      protected function SwitchDeploySlotReady(param1:THero) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = int(TUtilityLobby.GetStandPositionWithProfession(param1.Profession));
         _loc3_ = CAMPSLOTNUM;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FSlots_My[_loc2_].Visible = true;
            TItemReadyCampSlot(this.FSlots_My[_loc2_]).SetMask(DeployClassLookTable[_loc2_] != _loc4_);
            _loc2_++;
         }
      }
      
      protected function SlotsOnDragEnd(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TPacket = null;
         if(!this.FSwitchingDeployment)
         {
            return;
         }
         this.FSwitchingDeployment = false;
         FUICore.MouseStopDrag(this.FUIImage);
         this.RenderMyCampInfo();
         if(this.FSelectedSlot != null)
         {
            _loc2_ = this.FSlots_My.indexOf(this.FSelectedSlot);
            _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TacticalDeployment_ChangePositionReq);
            _loc3_.Data.writeUnsignedInt(this.FSelectedHero.Identifier);
            _loc3_.Data.writeByte(DeployPositionLookTable[_loc2_]);
            SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         }
      }
      
      protected function PageOnChange(param1:Object, param2:int) : void
      {
         this.FCurrentPage = param2;
         this.RenderBackupCampInfo();
      }
      
      protected function UnloadOnEnd(param1:MouseEvent) : void
      {
         var _loc2_:TPacket = null;
         if(this.FIfCanUnload)
         {
            this.FIfCanUnload = false;
            _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TacticalDeployment_ChangePositionReq);
            _loc2_.Data.writeUnsignedInt(this.FSelectedUnloadHero.Identifier);
            _loc2_.Data.writeByte(0);
            SNetworkCore.Transceiver.PacketTransmit(_loc2_);
            this.FSelectedUnloadHero = null;
         }
         if(this.FUnloadingHero)
         {
            FUICore.MouseStopDrag(this.FUIImage);
         }
      }
      
      override public function get Visible() : Boolean
      {
         return super.Visible;
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         this.FMainUI.visible = param1;
      }
      
      public function get OnSetBattleStatus() : Function
      {
         return this.FOnSetBattleStatus;
      }
      
      public function set OnSetBattleStatus(param1:Function) : void
      {
         this.FOnSetBattleStatus = param1;
      }
      
      public function get SwitchFunction() : Function
      {
         return this.FSwitchFunction;
      }
      
      public function set SwitchFunction(param1:Function) : void
      {
         this.FSwitchFunction = param1;
      }
      
      public function Show(param1:int, param2:int) : void
      {
         var _loc3_:TRelatedPartnerPoint = null;
         var _loc4_:TRelatedCondition = null;
         var _loc5_:Vector.<int> = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         this.FPveId = param1;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RelatedPartnerPoint,this.FPveId) as TRelatedPartnerPoint;
         if(param2 == TItemTrainPoint.Star_Num)
         {
            TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Related_12);
            this.FTFCondition.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.WORLDMAP_STRING_02);
            return;
         }
         _loc5_ = _loc3_.GetStarConditionsByIndex(param2);
         _loc8_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Related_02),param2 + 1) + "\n";
         _loc7_ = int(_loc5_.length);
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RelatedCondition,_loc5_[_loc6_]) as TRelatedCondition;
            _loc8_ += _loc4_.CondtionHtml;
            _loc6_++;
         }
         this.FTFCondition.htmlText = _loc8_;
      }
      
      public function SetEnemy(param1:int) : void
      {
         var _loc2_:TPartnerTrainEnemyVO = null;
         var _loc3_:TEnemyArmy = null;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_EnemyArmy,param1) as TEnemyArmy;
         this.FEnemyVO.TemplateIds = _loc3_.EnemyIdVect;
         this.FEnemyVO.FightPoses = _loc3_.EnemyPosVect;
      }
      
      public function Reset() : void
      {
         this.FCurrentPage = 0;
      }
      
      public function ProcessorChangePosition() : void
      {
         this.RenderUI();
      }
      
      public function BattleResultNotify() : void
      {
         this.RenderUI();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FHeroInfoTip != null && this.FHeroInfoTip.visible == true)
         {
            this.FHeroInfoTip.UpdataBitmap();
         }
      }
   }
}

