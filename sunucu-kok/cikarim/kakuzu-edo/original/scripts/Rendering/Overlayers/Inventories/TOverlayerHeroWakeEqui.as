package Rendering.Overlayers.Inventories
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.Characters.MainRoleWake.THeroWakeData;
   import Logics.Characters.MainRoleWake.THeroWakeEquipment;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.DatebaseVO.VO.TLeaderWakeUp;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Rendering.Overlayers.TOverlayer;
   import Resources.Constants.CONST_CONFIGVALUE;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   
   public class TOverlayerHeroWakeEqui extends TOverlayer
   {
      
      protected var FMainUI:MovieClip;
      
      protected var FPhaseSwitch:Vector.<uint>;
      
      protected var ID:uint;
      
      protected var StrLevel:uint;
      
      protected var FColor1:uint;
      
      protected var FColor2:uint;
      
      protected var FColor3:uint;
      
      public function TOverlayerHeroWakeEqui(param1:TUIComponent)
      {
         super(param1);
         FOvarlaySubstrate.visible = false;
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:TBins = null;
         var _loc2_:TConfigValue = null;
         super.ResourcesPerform_UIDispatch();
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_HeroWakeEquiTip") as MovieClip;
         addChild(this.FMainUI);
         _loc1_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.HeroWake_PhaseSwitch) as TConfigValue;
         this.FPhaseSwitch = _loc2_.Value as Vector.<uint>;
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.HeroWake_Color1) as TConfigValue;
         this.FColor1 = uint(_loc2_.Value);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.HeroWake_Color2) as TConfigValue;
         this.FColor2 = uint(_loc2_.Value);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.HeroWake_Color3) as TConfigValue;
         this.FColor3 = uint(_loc2_.Value);
      }
      
      override protected function ContextModified() : Boolean
      {
         var _loc1_:THeroWakeEquipment = null;
         _loc1_ = Context as THeroWakeEquipment;
         return _loc1_.IDTemplate != this.ID || _loc1_.CurStreng != this.StrLevel;
      }
      
      override protected function ContextSynchronize() : void
      {
         var _loc1_:THeroWakeEquipment = null;
         _loc1_ = Context as THeroWakeEquipment;
         this.ID = _loc1_.IDTemplate;
         this.StrLevel = _loc1_.CurStreng;
      }
      
      override protected function ContextVerificate(param1:Object) : Boolean
      {
         var _loc2_:THeroWakeEquipment = null;
         if(param1 is THeroWakeEquipment)
         {
            _loc2_ = param1 as THeroWakeEquipment;
            return THeroWakeData.IsEquips(_loc2_);
         }
         return false;
      }
      
      override protected function EvaluationPerform_Context() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:THeroWakeEquipment = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TLeaderWakeUp = null;
         var _loc7_:Vector.<Object> = null;
         var _loc8_:uint = 0;
         _loc2_ = Context as THeroWakeEquipment;
         this.FMainUI.TF_Name.text = _loc2_.Name;
         this.FMainUI.TF_Str.text = "+" + _loc2_.CurStreng;
         this.FMainUI.TF_Quality.text = _loc2_.WakeUpConfig.Quality.toString();
         this.FMainUI.TF_Phase.text = _loc2_.WakeUpConfig.WakeStage.toString();
         this.FMainUI.TF_StrMax.text = "+" + _loc2_.WakeUpConfig.MaxStr;
         _loc7_ = new Vector.<Object>();
         _loc3_ = this.FPhaseSwitch.length;
         _loc1_ = 0;
         while(_loc1_ < _loc3_)
         {
            _loc4_ = this.FPhaseSwitch[_loc1_];
            if(_loc2_.WakeUpConfig.WakeStage >= _loc4_)
            {
               _loc7_[0] = _loc2_.WakeUpConfig.EquipAttr[_loc1_];
               if(_loc1_ == 0)
               {
                  _loc8_ = this.FColor1;
                  if(_loc2_.CurStreng > 0)
                  {
                     this.FMainUI["TF_Attribute_" + _loc1_].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_46),TUtilityTool.GetPropertyDesc(_loc7_),_loc2_.CurStreng * _loc2_.WakeUpConfig.ValueStr);
                  }
                  else
                  {
                     this.FMainUI["TF_Attribute_" + _loc1_].text = TUtilityTool.GetPropertyDesc(_loc7_);
                  }
               }
               else
               {
                  _loc8_ = this.FColor2;
                  this.FMainUI["TF_Attribute_" + _loc1_].text = TUtilityTool.GetPropertyDesc(_loc7_);
               }
            }
            else
            {
               _loc5_ = 14152000 + _loc2_.WakeUpConfig.PosEquip * 100 + _loc4_;
               _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_LeaderWakeUp,_loc5_) as TLeaderWakeUp;
               _loc7_[0] = _loc6_.EquipAttr[_loc6_.EquipAttr.length - 1];
               _loc8_ = this.FColor3;
               this.FMainUI["TF_Attribute_" + _loc1_].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_45),TUtilityTool.GetPropertyDesc(_loc7_),_loc4_);
            }
            this.FMainUI["TF_Attribute_" + _loc1_].textColor = _loc8_;
            _loc1_++;
         }
         this.FMainUI.TF_NeedArticle.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_47);
      }
   }
}

