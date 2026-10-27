package Logics.Streamization.Inventories
{
   import Foundation.Resources.SResourcesCore;
   import Logics.Characters.THero;
   import Logics.DatebaseVO.VO.Json.TAddOther;
   import Logics.DatebaseVO.VO.TArticle;
   import Logics.DatebaseVO.VO.TWakeUpEquip;
   import Logics.HeroNew.TWakeHeroAttributes;
   import Logics.Inventories.TInventoryProperty;
   import Logics.Inventories.TInventoryWake;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerWakeEquip extends TUnstreamizerInventory
   {
      
      public function TUnstreamizerWakeEquip()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         super.UnstreamizationPerform(param1,param2,param3);
         this.UnstreamizationPerform_InventoryWakeByDatabase(param2,param3);
      }
      
      protected function UnstreamizationPerform_InventoryWakeByDatabase(param1:Object, param2:Object) : void
      {
         var _loc3_:TArticle = null;
         var _loc4_:TWakeUpEquip = null;
         var _loc5_:TInventoryWake = null;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:TAddOther = null;
         var _loc11_:TInventoryProperty = null;
         var _loc12_:String = null;
         _loc5_ = param1 as TInventoryWake;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc5_.IDTemplate) as TArticle;
         _loc5_.StackableQuantityMax = _loc3_.OverlayNumber;
         if(_loc5_.StackableQuantityMax <= 1)
         {
            _loc6_ = false;
         }
         else
         {
            _loc6_ = true;
         }
         _loc5_.Stackable = _loc6_;
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_WakeUpEquip,_loc5_.IDTemplate) as TWakeUpEquip;
         _loc5_.HeroLevel = _loc4_.NeedLevel;
         _loc5_.WakeProperties.length = 0;
         _loc9_ = _loc4_.PropertyCount;
         _loc7_ = 0;
         while(_loc7_ < _loc9_)
         {
            _loc11_ = new TInventoryProperty();
            _loc10_ = _loc4_.GetPropertyByIndex(_loc7_);
            _loc11_.Identifier = _loc10_.Type;
            _loc11_.Value = Number(_loc10_.Value);
            _loc12_ = TUtilityLobby.GetAttributeName(_loc10_.Type);
            _loc11_.Name = _loc12_;
            _loc5_.WakeProperties.push(_loc11_);
            _loc7_++;
         }
      }
      
      protected function UnstreamizationPerform_WakeAttributes(param1:Object, param2:Object) : void
      {
         var _loc3_:TWakeHeroAttributes = null;
         var _loc4_:THero = null;
         _loc3_ = param1 as TWakeHeroAttributes;
         _loc4_ = param2 as THero;
         if(_loc4_ == SLogicsCore.Character.MainHero)
         {
            return;
         }
         _loc3_.SetProperties(_loc4_);
      }
      
      override public function UnstreamizeGenerateInventory(param1:ByteArray, param2:Object, param3:Object) : void
      {
         super.UnstreamizeGenerateInventory(param1,param2,param3);
         this.UnstreamizationPerform_InventoryWakeByDatabase(param2,param3);
      }
      
      public function UnstreamizationWakeEquip(param1:Object) : void
      {
         super.UnstreamizationPerform_InventoryByDatabase(param1);
      }
      
      public function UnstreamizationWakeAttribute(param1:Object, param2:Object) : void
      {
         this.UnstreamizationPerform_WakeAttributes(param1,param2);
      }
   }
}

