package Processors.Game.Lobby.Common.Inventory
{
   import Foundation.Common.TCoordinate;
   import Foundation.UI.TUIComponent;
   import Logics.Inventories.TInventory;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Rendering.Overlayers.Inventories.TOverlayerAppliance;
   import Rendering.Overlayers.Inventories.TOverlayerEquipment;
   import Rendering.Overlayers.Inventories.TOverlayerOrnament;
   import Rendering.Overlayers.Inventories.TOverlayerTreasure;
   import Rendering.Overlayers.TOverlayer;
   import Resources.Constants.CONST_INVENTORY;
   import Utilities.UI.Overlayers.TUtilityUIOverlayer;
   
   public class TProcessorWindowInventoryInfor extends TProcessorLobbyWindow
   {
      
      public static const CATEGORY_Equipment:uint = CONST_INVENTORY.CATEGORY_Equipment;
      
      public static const CATEGORY_Ornament:uint = CONST_INVENTORY.CATEGORY_Ornament;
      
      public static const CATEGORY_Treasure:uint = CONST_INVENTORY.CATEGORY_Treasure;
      
      protected static const Tip_X:int = 281;
      
      protected static const Tip_Y:int = 619;
      
      protected var FOverlayerEquipment:TOverlayerEquipment;
      
      protected var FOverlayerOrnament:TOverlayerOrnament;
      
      protected var FOverlayerAppliance:TOverlayerAppliance;
      
      protected var FOverlayerTreasure:TOverlayerTreasure;
      
      protected var FInventory:TInventory;
      
      protected var FCoordinate:TCoordinate;
      
      public function TProcessorWindowInventoryInfor(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function Resources_UIDispatch() : void
      {
         this.FOverlayerEquipment = new TOverlayerEquipment(this);
         this.FOverlayerEquipment.Visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerEquipment);
         this.FOverlayerOrnament = new TOverlayerOrnament(this);
         this.FOverlayerOrnament.Visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerOrnament);
         this.FOverlayerAppliance = new TOverlayerAppliance(this);
         this.FOverlayerAppliance.Visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerAppliance);
         this.FOverlayerTreasure = new TOverlayerTreasure(this);
         this.FOverlayerTreasure.Visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerTreasure);
         this.FCoordinate = new TCoordinate();
         this.FCoordinate.X = 0;
         this.FCoordinate.Y = 0;
      }
      
      protected function Resources_UILocations() : void
      {
      }
      
      protected function UIComponentsOverlayerOnOver(param1:Object) : void
      {
         var _loc2_:TInventory = null;
         var _loc3_:TInventory = null;
         var _loc4_:TOverlayer = null;
         _loc2_ = param1 as TInventory;
         switch(_loc2_.Category)
         {
            case CATEGORY_Equipment:
               _loc4_ = this.FOverlayerEquipment;
               break;
            case CATEGORY_Ornament:
               _loc4_ = this.FOverlayerOrnament;
               break;
            case CATEGORY_Treasure:
               _loc4_ = this.FOverlayerTreasure;
               break;
            default:
               _loc4_ = this.FOverlayerAppliance;
         }
         if(_loc4_ != null)
         {
            _loc4_.Context = _loc2_;
            _loc4_.Render(this.FCoordinate);
            _loc4_.Show();
         }
         this.x = Tip_X;
         this.y = Tip_Y - _loc4_.Height;
      }
      
      protected function UIComponentsOverlayerOnOut(param1:TInventory) : void
      {
         var _loc2_:TInventory = null;
         var _loc3_:TOverlayer = null;
         _loc2_ = param1 as TInventory;
         switch(_loc2_.Category)
         {
            case CATEGORY_Equipment:
               _loc3_ = this.FOverlayerEquipment;
               break;
            case CATEGORY_Ornament:
               _loc3_ = this.FOverlayerOrnament;
               break;
            case CATEGORY_Treasure:
               _loc3_ = this.FOverlayerTreasure;
               break;
            default:
               _loc3_ = this.FOverlayerAppliance;
         }
         if(_loc3_ != null)
         {
            _loc3_.Hide();
         }
      }
      
      public function get Inventory() : TInventory
      {
         return this.FInventory;
      }
      
      public function set Inventory(param1:TInventory) : void
      {
         this.FInventory = param1;
         this.FInventory.StubReferences.Reference(this);
      }
      
      public function Perform_UIDispatch() : void
      {
         this.Resources_UIDispatch();
         this.Resources_UILocations();
      }
      
      public function Show() : void
      {
         this.UIComponentsOverlayerOnOver(this.FInventory);
         this.Visible = true;
      }
      
      public function Hide() : void
      {
         this.UIComponentsOverlayerOnOut(this.FInventory);
         this.Reset();
         this.Visible = false;
      }
      
      public function Reset() : void
      {
         this.FInventory.StubReferences.Dereference(this);
         this.FInventory = null;
      }
   }
}

