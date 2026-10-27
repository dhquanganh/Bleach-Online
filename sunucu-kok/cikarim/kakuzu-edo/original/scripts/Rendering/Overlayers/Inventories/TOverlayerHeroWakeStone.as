package Rendering.Overlayers.Inventories
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.Characters.MainRoleWake.THeroWakeData;
   import Logics.Characters.MainRoleWake.THeroWakeEquipment;
   import Logics.DatebaseVO.VO.TLeaderWakeUp;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Rendering.Overlayers.TOverlayer;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   
   public class TOverlayerHeroWakeStone extends TOverlayer
   {
      
      protected var FMainUI:MovieClip;
      
      protected var ID:uint;
      
      protected var StrLevel:uint;
      
      public function TOverlayerHeroWakeStone(param1:TUIComponent)
      {
         super(param1);
         FOvarlaySubstrate.visible = false;
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_HeroWakeStoneTip") as MovieClip;
         addChild(this.FMainUI);
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
            return THeroWakeData.IsStone(_loc2_);
         }
         return false;
      }
      
      override protected function EvaluationPerform_Context() : void
      {
         var _loc1_:THeroWakeEquipment = null;
         var _loc2_:TLeaderWakeUp = null;
         var _loc3_:Vector.<Object> = null;
         var _loc4_:Object = null;
         var _loc5_:String = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         _loc1_ = Context as THeroWakeEquipment;
         this.FMainUI.TF_Name.text = _loc1_.Name;
         this.FMainUI.TF_Phase.text = _loc1_.WakeUpConfig.WakeStage.toString();
         _loc3_ = new Vector.<Object>();
         _loc7_ = _loc1_.WakeUpConfig.EquipAttr.length;
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc4_ = _loc1_.WakeUpConfig.EquipAttr[_loc6_];
            _loc3_[0] = _loc4_;
            _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_LeaderWakeUp,_loc1_.WakeUpConfig.NextID) as TLeaderWakeUp;
            if(_loc2_ != null)
            {
               _loc5_ = Number((_loc2_.EquipAttr[_loc6_].value - _loc4_.value) * 100).toFixed(2) + "%";
               this.FMainUI["TF_Attribute_" + _loc6_].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_46),TUtilityTool.GetPropertyDesc(_loc3_),_loc5_);
            }
            else
            {
               this.FMainUI["TF_Attribute_" + _loc6_].text = TUtilityTool.GetPropertyDesc(_loc3_);
            }
            _loc6_++;
         }
         this.FMainUI.TF_NeedArticle.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_47);
      }
   }
}

