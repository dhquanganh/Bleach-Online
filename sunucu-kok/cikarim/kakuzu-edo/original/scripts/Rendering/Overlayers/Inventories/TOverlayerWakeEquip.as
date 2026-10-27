package Rendering.Overlayers.Inventories
{
   import Components.Standard.TUIImage;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.Inventories.TInventoryProperty;
   import Logics.Inventories.TInventoryWake;
   import Rendering.Overlayers.TOverlayer;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class TOverlayerWakeEquip extends TOverlayer
   {
      
      protected const Property_Count:int = 7;
      
      protected const Tip_Interval:int = 12;
      
      protected const Txt_Height:int = 16;
      
      protected const Other_Height:int = 51;
      
      protected var FMainUI:Sprite;
      
      protected var FTxtName:TextField;
      
      protected var FTxtLevel:TextField;
      
      protected var FTxtPropNames:Vector.<TextField>;
      
      protected var FTxtPropValues:Vector.<TextField>;
      
      protected var FTxtCost:TextField;
      
      protected var FInventoryIcon:TUIImage;
      
      protected var FBackGround:Sprite;
      
      protected var FOther:Sprite;
      
      public function TOverlayerWakeEquip(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TextField = null;
         var _loc3_:TextField = null;
         super.ResourcesPerform_UIDispatch();
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("WakeEquipTip") as Sprite;
         addChild(this.FMainUI);
         this.FInventoryIcon = new TUIImage(this);
         this.FInventoryIcon.mouseEnabled = false;
         this.FInventoryIcon.mouseChildren = false;
         this.FMainUI["MC_Slot"]["MC_Bmp_Icon"].addChild(this.FInventoryIcon);
         this.FBackGround = this.FMainUI["MC_Bg"];
         this.FOther = this.FMainUI["MC_Other"];
         this.FTxtName = this.FMainUI["Txt_Name"];
         this.FTxtLevel = this.FMainUI["Txt_Level"];
         this.FTxtCost = this.FOther["Txt_Cost"];
         this.FMainUI["Txt_EquipLeft"].visible = false;
         this.FTxtPropNames = new Vector.<TextField>();
         this.FTxtPropValues = new Vector.<TextField>();
         _loc1_ = 0;
         while(_loc1_ < this.Property_Count)
         {
            _loc2_ = this.FMainUI["Txt_PropName_" + _loc1_];
            _loc3_ = this.FMainUI["Txt_PropValue_" + _loc1_];
            _loc2_.visible = false;
            _loc3_.visible = false;
            this.FTxtPropNames.push(_loc2_);
            this.FTxtPropValues.push(_loc3_);
            _loc1_++;
         }
      }
      
      override protected function ContextVerificate(param1:Object) : Boolean
      {
         return param1 is TInventoryWake;
      }
      
      override protected function EvaluationPerform_Context() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TextField = null;
         var _loc4_:TextField = null;
         var _loc5_:TInventoryProperty = null;
         var _loc6_:TInventoryWake = null;
         var _loc7_:TAnimationSequence = null;
         var _loc8_:String = null;
         _loc6_ = FContext as TInventoryWake;
         this.FTxtName.text = _loc6_.Name;
         this.FTxtLevel.text = _loc6_.HeroLevel + "";
         this.FTxtCost.text = _loc6_.SellValue + "";
         _loc2_ = int(_loc6_.WakeProperties.length);
         _loc1_ = 0;
         while(_loc1_ < this.Property_Count)
         {
            _loc3_ = this.FTxtPropNames[_loc1_];
            _loc4_ = this.FTxtPropValues[_loc1_];
            if(_loc1_ < _loc2_)
            {
               _loc3_.visible = true;
               _loc4_.visible = true;
               _loc5_ = _loc6_.WakeProperties[_loc1_];
               _loc3_.text = _loc5_.Name;
               if(_loc5_.Value < 1)
               {
                  _loc8_ = Number(_loc5_.Value * 100).toFixed(2) + "%";
               }
               else
               {
                  _loc8_ = _loc5_.Value + "";
               }
               _loc4_.text = _loc8_;
               this.FBackGround.height = _loc3_.y + this.Txt_Height + this.Other_Height + this.Tip_Interval * 2;
               this.FOther.y = _loc3_.y + this.Txt_Height + this.Tip_Interval;
            }
            else
            {
               _loc3_.visible = false;
               _loc4_.visible = false;
            }
            _loc1_++;
         }
         _loc7_ = SResourcesCore.TexturesInventory.GetAnimationSequenceByIdentifiers(_loc6_.IDTemplate,0);
         if(_loc7_ != null)
         {
            this.FInventoryIcon.Sequence = _loc7_;
         }
         else
         {
            this.FInventoryIcon.Sequence = null;
         }
      }
   }
}

