package Processors.Game.Lobby.VoidSoulWorld
{
   import Components.Standard.TUIButton;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.TEnemy;
   import Logics.DatebaseVO.VO.TEnemyArmy;
   import Logics.DatebaseVO.VO.TRoleModel;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.WorldMapBleach.MonsterMap.Components.TArmyTip;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TProcessorMonsterHead extends TProcessorLobbyWindow
   {
      
      protected const SlotCount:uint = 7;
      
      protected const ArmySlotNameVect:Vector.<String> = Vector.<String>(["MC_Slot_1","MC_Slot_6","MC_Slot_7","MC_Slot_8","MC_Slot_11","MC_Slot_12","MC_Slot_13"]);
      
      protected var FBtms:Vector.<Bitmap>;
      
      protected var FCloseBtn:TUIButton;
      
      protected var FEnemyBins:TBins;
      
      protected var FRoleModel:TBins;
      
      protected var FEnemyArmy:TEnemyArmy;
      
      protected var FSingleEnemy:uint = 0;
      
      protected var FArmyTip:TArmyTip;
      
      protected var FMainUI:MovieClip;
      
      public function TProcessorMonsterHead(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function EnemyArmyPicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         if(this.FSingleEnemy != 0)
         {
            var enemy:TEnemy = this.FEnemyBins.GetDatebaseByIdentifier(this.FSingleEnemy) as TEnemy;
            var role:TRoleModel = this.FRoleModel.GetDatebaseByIdentifier(enemy != null ? enemy.HeroIcon : this.FSingleEnemy) as TRoleModel;
            if(role != null && param2 != null && role.RoleHead == param3)
            {
               this.FBtms[1].bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
            }
            return;
         }
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TEnemy = null;
         var _loc7_:TRoleModel = null;
         var _loc8_:uint = 0;
         var _loc9_:Vector.<uint> = null;
         var _loc10_:Vector.<uint> = null;
         _loc9_ = this.FEnemyArmy.EnemyIdVect;
         _loc10_ = this.FEnemyArmy.EnemyPosVect;
         _loc4_ = _loc9_.length;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            if(_loc10_[_loc5_] > 0)
            {
               _loc6_ = this.FEnemyBins.GetDatebaseByIdentifier(_loc9_[_loc5_]) as TEnemy;
               _loc7_ = this.FRoleModel.GetDatebaseByIdentifier(_loc6_.HeroIcon) as TRoleModel;
               if(_loc7_.RoleHead == param3)
               {
                  _loc8_ = this.ArmySlotNameVect.indexOf("MC_Slot_" + _loc10_[_loc5_]);
                  this.FBtms[_loc8_].bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
               }
            }
            _loc5_++;
         }
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(Boolean(this.FArmyTip) && this.FArmyTip.Visible == true)
         {
            this.FArmyTip.UpdataBitmap();
         }
      }
      
      protected function onCloseBtnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function OnArmyOver(param1:MouseEvent) : void
      {
         var _loc2_:TEnemy = null;
         _loc2_ = param1.currentTarget.Enemy;
         if(_loc2_ != null)
         {
            this.FArmyTip.SetHeroData(null,_loc2_);
            this.FArmyTip.Visible = true;
         }
      }
      
      protected function OnArmyOut(param1:MouseEvent) : void
      {
         if(Boolean(this.FArmyTip) && this.FArmyTip.Visible == true)
         {
            this.FArmyTip.Visible = false;
         }
      }
      
      public function UIDispatch() : void
      {
         var _loc1_:Bitmap = null;
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         this.FEnemyBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Enemy);
         this.FRoleModel = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_RoleModel);
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_VoidSoulWorldMonsterHead") as MovieClip;
         addChild(this.FMainUI);
         this.FBtms = new Vector.<Bitmap>(this.SlotCount);
         _loc2_ = 0;
         while(_loc2_ < this.SlotCount)
         {
            _loc1_ = new Bitmap();
            this.FBtms[_loc2_] = _loc1_;
            _loc3_ = this.FMainUI[this.ArmySlotNameVect[_loc2_]];
            _loc3_.MountPoint.addChild(_loc1_);
            _loc3_.addEventListener(MouseEvent.MOUSE_MOVE,this.OnArmyOver);
            _loc3_.addEventListener(MouseEvent.ROLL_OUT,this.OnArmyOut);
            _loc2_++;
         }
         this.FCloseBtn = new TUIButton();
         this.FCloseBtn.OnClick = this.onCloseBtnClick;
         this.FCloseBtn.Substrate = this.FMainUI.Btn_Close;
         X = (CONST_COMMON.STAGE_Width - Width) / 2;
         Y = (CONST_COMMON.STAGE_Height - Height) / 2;
         this.FArmyTip = new TArmyTip(this.Parent);
         this.FArmyTip.Visible = false;
      }
      
      public function UpdateBoss(enemyId:uint) : void
      {
         this.FSingleEnemy = enemyId;
         this.FEnemyArmy = null;
         var i:int = 0;
         while(i < this.SlotCount)
         {
            this.FBtms[i].bitmapData = null;
            this.FMainUI[this.ArmySlotNameVect[i]].Enemy = null;
            i++;
         }
         var enemy:TEnemy = this.FEnemyBins.GetDatebaseByIdentifier(enemyId) as TEnemy;
         var role:TRoleModel = this.FRoleModel.GetDatebaseByIdentifier(enemy != null ? enemy.HeroIcon : enemyId) as TRoleModel;
         if(role == null)
         {
            return;
         }
         this.FMainUI.MC_Slot_6.Enemy = enemy;
         SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(role.RoleHead,this.EnemyArmyPicArrive);
      }
      
      public function Update(param1:TEnemyArmy) : void
      {
         this.FSingleEnemy = 0;
         var _loc2_:Vector.<uint> = null;
         var _loc3_:Vector.<uint> = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TEnemy = null;
         var _loc7_:TRoleModel = null;
         var _loc8_:MovieClip = null;
         this.FEnemyArmy = param1;
         _loc2_ = param1.EnemyIdVect;
         _loc3_ = param1.EnemyPosVect;
         _loc5_ = 0;
         while(_loc5_ < this.SlotCount)
         {
            this.FBtms[_loc5_].bitmapData = null;
            _loc8_ = this.FMainUI[this.ArmySlotNameVect[_loc5_]];
            _loc8_.Enemy = null;
            _loc5_++;
         }
         _loc4_ = _loc2_.length;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            if(_loc3_[_loc5_] > 0)
            {
               _loc6_ = this.FEnemyBins.GetDatebaseByIdentifier(_loc2_[_loc5_]) as TEnemy;
               _loc7_ = this.FRoleModel.GetDatebaseByIdentifier(_loc6_.HeroIcon) as TRoleModel;
               _loc8_ = this.FMainUI["MC_Slot_" + _loc3_[_loc5_]];
               _loc8_.Enemy = _loc6_;
               SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc7_.RoleHead,this.EnemyArmyPicArrive);
            }
            _loc5_++;
         }
      }
   }
}

