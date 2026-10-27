package Processors.Game.Utilities.OverLayer
{
   import Foundation.Common.TCoordinate;
   import Foundation.Common.THint;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.Achievenment.TTitle;
   import Logics.CustomHero.TCurHero;
   import Logics.CustomHero.TCustomHero;
   import Logics.HDActivityMode.TGiftBoxTipData;
   import Logics.HeroChange.THeroChange;
   import Logics.Inventories.TInventory;
   import Logics.Pet.TPetBase;
   import Logics.Skills.TSkill;
   import Logics.VoidSoulWorld.TVoidWorldForm;
   import Rendering.Overlayers.GeneralStar.TOverlayerSoulSkill;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Rendering.Overlayers.HelpTips.TOverlayerHelpTips;
   import Rendering.Overlayers.HeroChange.TOverlayerHeroChange;
   import Rendering.Overlayers.Hints.TOverlayerHint;
   import Rendering.Overlayers.Inventories.TOverlayerAppliance;
   import Rendering.Overlayers.Inventories.TOverlayerCrashJade;
   import Rendering.Overlayers.Inventories.TOverlayerEquipment;
   import Rendering.Overlayers.Inventories.TOverlayerHeroWakeAll;
   import Rendering.Overlayers.Inventories.TOverlayerHeroWakeEqui;
   import Rendering.Overlayers.Inventories.TOverlayerHeroWakeStone;
   import Rendering.Overlayers.Inventories.TOverlayerOrnament;
   import Rendering.Overlayers.Inventories.TOverlayerTreasure;
   import Rendering.Overlayers.Inventories.TOverlayerWakeEquip;
   import Rendering.Overlayers.Pet.TOverlayerPet;
   import Rendering.Overlayers.TOverlayer;
   import Rendering.Overlayers.TOverlayerCustomHero.TOverlayerCurHero;
   import Rendering.Overlayers.TOverlayerCustomHero.TOverlayerCustomHero;
   import Rendering.Overlayers.Title.TOverlayerTitle;
   import Rendering.Overlayers.VoidSoulWorldFormation.TOverlayerVoidWorldForm;
   import Resources.Constants.CONST_INVENTORY;
   import Utilities.UI.Overlayers.TUtilityUIOverlayer;
   
   public class TUIOverLayerTip extends TUIComponent
   {
      
      public static const CATEGORY_Equipment:uint = CONST_INVENTORY.CATEGORY_Equipment;
      
      public static const CATEGORY_Treasure:uint = CONST_INVENTORY.CATEGORY_Treasure;
      
      public static const CATEGORY_Ornament:uint = CONST_INVENTORY.CATEGORY_Ornament;
      
      public static const CATEGORY_CrashJade:uint = CONST_INVENTORY.CATEGORY_CrashJade;
      
      public static const CATEGORY_WakeEquip:uint = CONST_INVENTORY.CATEGORY_WakeEquip;
      
      protected static const SecondType_WakeEquip:int = 1;
      
      protected static const SecondType_WakeChip:int = 2;
      
      protected static const SecondType_HeroWakeEquip:int = 3;
      
      protected static const SecondType_HeroWakeStone:int = 4;
      
      protected static const SecondType_HeroWakeAll:int = 5;
      
      protected var FOverlayerEquipment:TOverlayerEquipment;
      
      protected var FOverlayerEquipmentMounted:TOverlayerEquipment;
      
      protected var FOverlayerOrnament:TOverlayerOrnament;
      
      protected var FOverlayerOrnamentMounted:TOverlayerOrnament;
      
      protected var FOverlayerTreasure:TOverlayerTreasure;
      
      protected var FOverlayerCrashJade:TOverlayerCrashJade;
      
      protected var FOverlayerAppliance:TOverlayerAppliance;
      
      protected var FOverlayerSoulSkill:TOverlayerSoulSkill;
      
      protected var FOverlayerHitTips:TOverlayerHint;
      
      protected var FOverlayerHelpTips:TOverlayerHelpTips;
      
      protected var FOverlayerHeroChange:TOverlayerHeroChange;
      
      protected var FOverlayerTitle:TOverlayerTitle;
      
      protected var FOverlayerGift:TOverlayerGiftBox;
      
      protected var FOverlayerPet:TOverlayerPet;
      
      protected var FOverlayerWakeEquip:TOverlayerWakeEquip;
      
      protected var FOverlayerHeroWakeEqui:TOverlayerHeroWakeEqui;
      
      protected var FOverlayerHeroWakeStone:TOverlayerHeroWakeStone;
      
      protected var FOverlayerHeroWakeAll:TOverlayerHeroWakeAll;
      
      protected var FOverlayerCustomHero:TOverlayerCustomHero;
      
      protected var FOverlayerCurHero:TOverlayerCurHero;
      
      protected var FCoordinateOverlayerMounted:TCoordinate;
      
      protected var FOverlayerVoidWorldForm:TOverlayerVoidWorldForm;
      
      public function TUIOverLayerTip(param1:TUIComponent)
      {
         super(param1);
         this.FCoordinateOverlayerMounted = new TCoordinate();
         this.mouseEnabled = false;
         this.mouseChildren = false;
      }
      
      protected function LoadResource_Pefrorm() : void
      {
         this.FOverlayerEquipment = new TOverlayerEquipment(this);
         this.FOverlayerEquipment.Visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerEquipment);
         this.FOverlayerEquipmentMounted = new TOverlayerEquipment(this);
         this.FOverlayerEquipmentMounted.IsEquiped = true;
         this.FOverlayerEquipmentMounted.Visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerEquipmentMounted);
         this.FOverlayerOrnament = new TOverlayerOrnament(this);
         this.FOverlayerOrnament.Visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerOrnament);
         this.FOverlayerOrnamentMounted = new TOverlayerOrnament(this);
         this.FOverlayerOrnamentMounted.IsEquiped = true;
         this.FOverlayerOrnamentMounted.Visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerOrnamentMounted);
         this.FOverlayerTreasure = new TOverlayerTreasure(this);
         this.FOverlayerTreasure.Visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerTreasure);
         this.FOverlayerAppliance = new TOverlayerAppliance(this);
         this.FOverlayerAppliance.Visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerAppliance);
         this.FOverlayerCrashJade = new TOverlayerCrashJade(this);
         this.FOverlayerCrashJade.Visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerCrashJade);
         this.FOverlayerSoulSkill = new TOverlayerSoulSkill(this);
         this.FOverlayerSoulSkill.Visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerSoulSkill);
         this.FOverlayerHitTips = new TOverlayerHint(this);
         this.FOverlayerHitTips.Visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerHitTips);
         this.FOverlayerHelpTips = new TOverlayerHelpTips(this);
         this.FOverlayerHelpTips.Visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerHelpTips);
         this.FOverlayerHeroChange = new TOverlayerHeroChange(this);
         this.FOverlayerHeroChange.Visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerHeroChange);
         this.FOverlayerTitle = new TOverlayerTitle(this);
         this.FOverlayerTitle.Visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerTitle);
         this.FOverlayerPet = new TOverlayerPet(this);
         this.FOverlayerPet.Visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerPet);
         this.FOverlayerGift = new TOverlayerGiftBox(this);
         this.FOverlayerGift.visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerGift);
         this.FOverlayerWakeEquip = new TOverlayerWakeEquip(this);
         this.FOverlayerWakeEquip.Visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerWakeEquip);
         this.FOverlayerHeroWakeEqui = new TOverlayerHeroWakeEqui(this);
         this.FOverlayerHeroWakeEqui.Visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerHeroWakeEqui);
         this.FOverlayerHeroWakeStone = new TOverlayerHeroWakeStone(this);
         this.FOverlayerHeroWakeStone.Visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerHeroWakeStone);
         this.FOverlayerHeroWakeAll = new TOverlayerHeroWakeAll(this);
         this.FOverlayerHeroWakeAll.Visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerHeroWakeAll);
         this.FOverlayerCustomHero = new TOverlayerCustomHero(this);
         this.FOverlayerCustomHero.Visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerCustomHero);
         this.FOverlayerCurHero = new TOverlayerCurHero(this);
         this.FOverlayerCurHero.Visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerCurHero);
         this.FOverlayerVoidWorldForm = new TOverlayerVoidWorldForm(this);
         this.FOverlayerVoidWorldForm.Visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerVoidWorldForm);
      }
      
      protected function GetOverLayerByContext(param1:Object) : TOverlayer
      {
         var _loc2_:TInventory = null;
         var _loc3_:THint = null;
         var _loc4_:TOverlayer = null;
         if(param1 is TInventory)
         {
            _loc2_ = param1 as TInventory;
            switch(_loc2_.Category)
            {
               case CATEGORY_Equipment:
                  _loc4_ = this.FOverlayerEquipment;
                  break;
               case CATEGORY_Treasure:
                  _loc4_ = this.FOverlayerTreasure;
                  break;
               case CATEGORY_Ornament:
                  _loc4_ = this.FOverlayerOrnament;
                  break;
               case CATEGORY_CrashJade:
                  _loc4_ = this.FOverlayerCrashJade;
                  break;
               case CATEGORY_WakeEquip:
                  if(_loc2_.CategorySecond == SecondType_WakeChip)
                  {
                     _loc4_ = this.FOverlayerAppliance;
                  }
                  else if(_loc2_.CategorySecond == SecondType_WakeEquip)
                  {
                     _loc4_ = this.FOverlayerWakeEquip;
                  }
                  else if(_loc2_.CategorySecond == SecondType_HeroWakeEquip)
                  {
                     _loc4_ = this.FOverlayerHeroWakeEqui;
                  }
                  else if(_loc2_.CategorySecond == SecondType_HeroWakeStone)
                  {
                     _loc4_ = this.FOverlayerHeroWakeStone;
                  }
                  else
                  {
                     _loc4_ = this.FOverlayerHeroWakeAll;
                  }
                  break;
               default:
                  _loc4_ = this.FOverlayerAppliance;
            }
         }
         else if(param1 is THint)
         {
            _loc3_ = param1 as THint;
            if(!TUtilityString.Empty(_loc3_.Caption))
            {
               _loc4_ = this.FOverlayerHitTips;
            }
            else if(!TUtilityString.Empty(_loc3_.Content))
            {
               _loc4_ = this.FOverlayerHelpTips;
            }
         }
         else if(param1 is TSkill)
         {
            _loc4_ = this.FOverlayerSoulSkill;
         }
         else if(param1 is THeroChange)
         {
            _loc4_ = this.FOverlayerHeroChange;
         }
         else if(param1 is TTitle)
         {
            _loc4_ = this.FOverlayerTitle;
         }
         else if(param1 is TGiftBoxTipData)
         {
            _loc4_ = this.FOverlayerGift;
         }
         else if(param1 is TPetBase)
         {
            _loc4_ = this.FOverlayerPet;
         }
         else if(param1 is TCustomHero)
         {
            _loc4_ = this.FOverlayerCustomHero;
         }
         else if(param1 is TCurHero)
         {
            _loc4_ = this.FOverlayerCurHero;
         }
         else if(param1 is TVoidWorldForm)
         {
            _loc4_ = this.FOverlayerVoidWorldForm;
         }
         return _loc4_;
      }
      
      protected function GetOverLayerMountedByContext(param1:Object) : TOverlayer
      {
         var _loc2_:TInventory = null;
         var _loc3_:TOverlayer = null;
         if(param1 is TInventory)
         {
            _loc2_ = param1 as TInventory;
            switch(_loc2_.Category)
            {
               case CATEGORY_Equipment:
                  _loc3_ = this.FOverlayerEquipmentMounted;
                  break;
               case CATEGORY_Ornament:
                  _loc3_ = this.FOverlayerOrnamentMounted;
                  break;
               case CATEGORY_WakeEquip:
                  _loc3_ = this.FOverlayerWakeEquip;
            }
         }
         return _loc3_;
      }
      
      public function get OverlayerVoidWorldForm() : TOverlayerVoidWorldForm
      {
         return this.FOverlayerVoidWorldForm;
      }
      
      public function LoadResource() : void
      {
         this.LoadResource_Pefrorm();
      }
      
      public function UIComponentsOnOver(param1:Object, param2:Object, param3:Object = null) : void
      {
         var _loc4_:TOverlayer = null;
         var _loc5_:TCoordinate = null;
         _loc4_ = this.GetOverLayerByContext(param2);
         if(_loc4_ != null)
         {
            _loc4_.Context = param2;
            _loc4_.Render(FUICore.MouseCoordinate);
            _loc4_.Show();
         }
         if(param3 != null)
         {
            this.FCoordinateOverlayerMounted.Assign(_loc4_.CoordinateOverlay);
            this.FCoordinateOverlayerMounted.X -= _loc4_.BoundsSubstrate.Width + 65;
            _loc4_ = this.GetOverLayerMountedByContext(param3);
            _loc4_.Context = param3;
            _loc4_.Render(this.FCoordinateOverlayerMounted);
            _loc4_.Show();
         }
      }
      
      public function UIComponentsOnOut(param1:Object, param2:Object, param3:Object = null) : void
      {
         var _loc4_:TOverlayer = null;
         var _loc5_:TOverlayer = null;
         _loc4_ = this.GetOverLayerByContext(param2);
         if(_loc4_ != null)
         {
            _loc4_.Hide();
         }
         if(param3 != null)
         {
            _loc5_ = this.GetOverLayerMountedByContext(param3);
         }
         if(_loc5_ != null)
         {
            _loc5_.Hide();
         }
         if(_loc4_ == null || _loc5_ == null)
         {
            this.Hide();
         }
      }
      
      public function Hide() : void
      {
         if(this.FOverlayerEquipment != null)
         {
            this.FOverlayerEquipment.Context = null;
            this.FOverlayerEquipment.Hide();
         }
         if(this.FOverlayerEquipmentMounted != null)
         {
            this.FOverlayerEquipmentMounted.Context = null;
            this.FOverlayerEquipmentMounted.Hide();
         }
         if(this.FOverlayerOrnament != null)
         {
            this.FOverlayerOrnament.Context = null;
            this.FOverlayerOrnament.Hide();
         }
         if(this.FOverlayerOrnamentMounted != null)
         {
            this.FOverlayerOrnamentMounted.Context = null;
            this.FOverlayerOrnamentMounted.Hide();
         }
         if(this.FOverlayerTreasure != null)
         {
            this.FOverlayerTreasure.Context = null;
            this.FOverlayerTreasure.Hide();
         }
         if(this.FOverlayerAppliance != null)
         {
            this.FOverlayerAppliance.Context = null;
            this.FOverlayerAppliance.Hide();
         }
         if(this.FOverlayerSoulSkill != null)
         {
            this.FOverlayerSoulSkill.Context = null;
            this.FOverlayerSoulSkill.Hide();
         }
         if(this.FOverlayerHitTips != null)
         {
            this.FOverlayerHitTips.Context = null;
            this.FOverlayerHitTips.Hide();
         }
         if(this.FOverlayerHeroChange != null)
         {
            this.FOverlayerHeroChange.Context = null;
            this.FOverlayerHeroChange.Hide();
         }
         if(this.FOverlayerTitle != null)
         {
            this.FOverlayerTitle.Context = null;
            this.FOverlayerTitle.Hide();
         }
         if(this.FOverlayerGift != null)
         {
            this.FOverlayerGift.Context = null;
            this.FOverlayerGift.Hide();
         }
         if(this.FOverlayerPet != null)
         {
            this.FOverlayerPet.Context = null;
            this.FOverlayerPet.Hide();
         }
         if(this.FOverlayerWakeEquip != null)
         {
            this.FOverlayerWakeEquip.Context = null;
            this.FOverlayerWakeEquip.Hide();
         }
         if(this.FOverlayerHeroWakeEqui != null)
         {
            this.FOverlayerHeroWakeEqui.Context = null;
            this.FOverlayerHeroWakeEqui.Hide();
         }
         if(this.FOverlayerHeroWakeStone != null)
         {
            this.FOverlayerHeroWakeStone.Context = null;
            this.FOverlayerHeroWakeStone.Hide();
         }
         if(this.FOverlayerHeroWakeAll != null)
         {
            this.FOverlayerHeroWakeAll.Context = null;
            this.FOverlayerHeroWakeAll.Hide();
         }
         if(this.FOverlayerCustomHero != null)
         {
            this.FOverlayerCustomHero.Context = null;
            this.FOverlayerCustomHero.Hide();
         }
         if(this.FOverlayerCurHero != null)
         {
            this.FOverlayerCurHero.Context = null;
            this.FOverlayerCurHero.Hide();
         }
         if(this.FOverlayerVoidWorldForm != null)
         {
            this.FOverlayerVoidWorldForm.Context = null;
            this.FOverlayerVoidWorldForm.Hide();
         }
      }
   }
}

