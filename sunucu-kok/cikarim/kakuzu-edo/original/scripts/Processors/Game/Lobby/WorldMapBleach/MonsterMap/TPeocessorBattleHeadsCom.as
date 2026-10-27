package Processors.Game.Lobby.WorldMapBleach.MonsterMap
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Logics.Characters.TCharacter;
   import Logics.Characters.THero;
   import Logics.Characters.THeros;
   import Logics.DatebaseVO.VO.TEnemy;
   import Logics.DatebaseVO.VO.TEnemyArmy;
   import Logics.DatebaseVO.VO.TRoleModel;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.WorldMapBleach.MonsterMap.Components.TArmyTip;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_WORLDMAP;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TPeocessorBattleHeadsCom extends TUIComponent
   {
      
      protected static const MAX_ARMYCOUNT:uint = 7;
      
      protected var FMC_Info:MovieClip;
      
      protected var FMC_SelfArmy:MovieClip;
      
      protected var FMC_OpponentArmy:MovieClip;
      
      protected var FArmyTip:TArmyTip;
      
      protected var FCharacter:TCharacter;
      
      protected var FHeros:THeros;
      
      protected var FEnemyArmy:TEnemyArmy;
      
      protected var FRoleModel:TBins;
      
      protected var FEnemyBins:TBins;
      
      protected var FArmySlotNameVect:Vector.<String> = Vector.<String>(["MC_Slot_1","MC_Slot_6","MC_Slot_7","MC_Slot_8","MC_Slot_11","MC_Slot_12","MC_Slot_13"]);
      
      public function TPeocessorBattleHeadsCom(param1:TUIComponent)
      {
         super(param1);
         this.FCharacter = SLogicsCore.Character;
      }
      
      protected function OnArmyOver(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         var _loc4_:THero = null;
         var _loc5_:TEnemy = null;
         _loc2_ = param1.currentTarget.parent.name;
         if(_loc2_ == "MC_Teammate")
         {
            _loc4_ = param1.currentTarget.Hero;
            this.FArmyTip.SetHeroData(_loc4_);
         }
         else if(_loc2_ == "MC_Opponent")
         {
            _loc5_ = param1.currentTarget.Enemy;
            this.FArmyTip.SetHeroData(null,_loc5_);
         }
         this.FArmyTip.Visible = true;
      }
      
      protected function OnArmyOut(param1:MouseEvent) : void
      {
         if(Boolean(this.FArmyTip) && this.FArmyTip.Visible == true)
         {
            this.FArmyTip.Visible = false;
         }
      }
      
      protected function SelfArmyPicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:THero = null;
         var _loc7_:TRoleModel = null;
         var _loc8_:MovieClip = null;
         this.FHeros = this.FCharacter.Heros;
         _loc5_ = this.FHeros.Count;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = null;
            _loc6_ = this.FHeros.GetHeroByIndex(_loc4_);
            if(_loc6_.FightPosition > 0)
            {
               _loc7_ = this.FRoleModel.GetDatebaseByIdentifier(_loc6_.Identifier) as TRoleModel;
               if(_loc7_.RoleHead == param3)
               {
                  _loc8_ = this.FMC_SelfArmy["MC_Slot_" + _loc6_.FightPosition];
                  _loc8_["MC_Bmp_Icon"].bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
                  _loc8_.visible = true;
               }
            }
            _loc4_++;
         }
      }
      
      protected function EnemyArmyPicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:THero = null;
         var _loc7_:TRoleModel = null;
         var _loc8_:MovieClip = null;
         var _loc9_:Vector.<uint> = null;
         var _loc10_:Vector.<uint> = null;
         var _loc11_:TEnemy = null;
         _loc9_ = this.FEnemyArmy.EnemyIdVect;
         _loc10_ = this.FEnemyArmy.EnemyPosVect;
         _loc5_ = int(_loc9_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(_loc10_[_loc4_] > 0)
            {
               _loc11_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Enemy,_loc9_[_loc4_]) as TEnemy;
               _loc7_ = this.FRoleModel.GetDatebaseByIdentifier(_loc11_.HeroIcon) as TRoleModel;
               if(_loc7_.RoleHead == param3)
               {
                  _loc8_ = this.FMC_OpponentArmy["MC_Slot_" + _loc10_[_loc4_]];
                  _loc8_["MC_Bmp_Icon"].bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
                  _loc8_.visible = true;
               }
            }
            _loc4_++;
         }
      }
      
      public function UIDispatch(param1:MovieClip) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Bitmap = null;
         this.FRoleModel = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_RoleModel);
         this.FEnemyBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Enemy);
         this.FMC_Info = param1;
         this.FMC_SelfArmy = this.FMC_Info[CONST_WORLDMAP.RESOURCE_Link_MC_Teammate];
         this.FMC_OpponentArmy = this.FMC_Info[CONST_WORLDMAP.RESOURCE_Link_MC_Opponent];
         _loc2_ = 0;
         while(_loc2_ < MAX_ARMYCOUNT)
         {
            _loc3_ = new Bitmap();
            this.FMC_SelfArmy[this.FArmySlotNameVect[_loc2_]].HeroID = _loc2_;
            this.FMC_SelfArmy[this.FArmySlotNameVect[_loc2_]]["MC_Bmp_Icon"] = _loc3_;
            this.FMC_SelfArmy[this.FArmySlotNameVect[_loc2_]].addChild(_loc3_);
            this.FMC_SelfArmy[this.FArmySlotNameVect[_loc2_]].addEventListener(MouseEvent.MOUSE_MOVE,this.OnArmyOver,false,0,true);
            this.FMC_SelfArmy[this.FArmySlotNameVect[_loc2_]].addEventListener(MouseEvent.MOUSE_OUT,this.OnArmyOut,false,0,true);
            this.FMC_SelfArmy[this.FArmySlotNameVect[_loc2_]].visible = false;
            _loc2_++;
         }
         _loc3_ = null;
         _loc2_ = 0;
         while(_loc2_ < MAX_ARMYCOUNT)
         {
            _loc3_ = new Bitmap();
            this.FMC_OpponentArmy[this.FArmySlotNameVect[_loc2_]].HeroID = _loc2_;
            this.FMC_OpponentArmy[this.FArmySlotNameVect[_loc2_]]["MC_Bmp_Icon"] = _loc3_;
            this.FMC_OpponentArmy[this.FArmySlotNameVect[_loc2_]].addChild(_loc3_);
            this.FMC_OpponentArmy[this.FArmySlotNameVect[_loc2_]].addEventListener(MouseEvent.MOUSE_MOVE,this.OnArmyOver,false,0,true);
            this.FMC_OpponentArmy[this.FArmySlotNameVect[_loc2_]].addEventListener(MouseEvent.MOUSE_OUT,this.OnArmyOut,false,0,true);
            this.FMC_OpponentArmy[this.FArmySlotNameVect[_loc2_]].visible = false;
            _loc2_++;
         }
         this.FArmyTip = new TArmyTip(this);
         this.FArmyTip.Visible = false;
      }
      
      public function UpdateArmyHead(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:THero = null;
         var _loc5_:TRoleModel = null;
         var _loc6_:MovieClip = null;
         var _loc7_:Vector.<uint> = null;
         var _loc8_:Vector.<uint> = null;
         var _loc9_:TEnemy = null;
         _loc3_ = int(MAX_ARMYCOUNT);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = this.FMC_SelfArmy[this.FArmySlotNameVect[_loc2_]];
            Bitmap(_loc6_["MC_Bmp_Icon"]).bitmapData = null;
            _loc6_.visible = false;
            _loc2_++;
         }
         this.FHeros = this.FCharacter.Heros;
         _loc3_ = this.FHeros.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = null;
            _loc4_ = this.FHeros.GetHeroByIndex(_loc2_);
            if(_loc4_.FightPosition > 0)
            {
               _loc5_ = this.FRoleModel.GetDatebaseByIdentifier(_loc4_.Identifier) as TRoleModel;
               _loc6_ = this.FMC_SelfArmy["MC_Slot_" + _loc4_.FightPosition];
               _loc6_.Hero = _loc4_;
               SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc5_.RoleHead,this.SelfArmyPicArrive);
               _loc6_["MC_Bmp_Icon"].x = 3;
               _loc6_["MC_Bmp_Icon"].y = 3;
            }
            _loc2_++;
         }
         this.FEnemyArmy = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_EnemyArmy,param1) as TEnemyArmy;
         _loc7_ = this.FEnemyArmy.EnemyIdVect;
         _loc8_ = this.FEnemyArmy.EnemyPosVect;
         _loc3_ = int(MAX_ARMYCOUNT);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = this.FMC_OpponentArmy[this.FArmySlotNameVect[_loc2_]];
            _loc6_.visible = false;
            Bitmap(_loc6_["MC_Bmp_Icon"]).bitmapData = null;
            _loc2_++;
         }
         _loc3_ = int(_loc7_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(_loc8_[_loc2_] > 0)
            {
               _loc6_ = this.FMC_OpponentArmy["MC_Slot_" + _loc8_[_loc2_]];
               _loc9_ = null;
               _loc5_ = null;
               _loc9_ = this.FEnemyBins.GetDatebaseByIdentifier(_loc7_[_loc2_]) as TEnemy;
               _loc6_.Enemy = _loc9_;
               _loc5_ = this.FRoleModel.GetDatebaseByIdentifier(_loc9_.HeroIcon) as TRoleModel;
               SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc5_.RoleHead,this.EnemyArmyPicArrive);
               _loc6_["MC_Bmp_Icon"].x = 3;
               _loc6_["MC_Bmp_Icon"].y = 3;
            }
            _loc2_++;
         }
      }
      
      public function LogicsPerform() : void
      {
         if(Boolean(this.FArmyTip) && this.FArmyTip.Visible == true)
         {
            this.FArmyTip.UpdataBitmap();
         }
      }
   }
}

