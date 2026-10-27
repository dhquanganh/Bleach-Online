package Rendering.Overlayers.Inventories
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Rendering.Overlayers.*;
   import Rendering.Texts.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TOverlayerEquipment extends TOverlayerInventory
   {
      
      protected static const SIZE_WordWrapWidth:uint = 130;
      
      protected static const CAPACITY_AppendAttributes:uint = 3;
      
      protected static const CAPACITY_GiftedStoneItems:uint = 8;
      
      protected static const CAPACITY_SuitEffects:uint = 3;
      
      protected static const SIZE_DividingLine_Max_Width:uint = 250;
      
      protected static const SIZE_DividingLine_Min_Width:uint = 245;
      
      protected static const SIZE_TextFormat_leading:uint = 4;
      
      protected static const BASEATTRIBUTENAMES:Vector.<uint> = CONST_COMMON.BASEATTRIBUTENAMES;
      
      protected static const BASEATTRIBUTENAME_HitRate:uint = CONST_COMMON.BASEATTRIBUTENAME_HitRate;
      
      protected static const BASEATTRIBUTENAME_DodgeRate:uint = CONST_COMMON.BASEATTRIBUTENAME_DodgeRate;
      
      protected static const BASEATTRIBUTENAME_CritRate:uint = CONST_COMMON.BASEATTRIBUTENAME_CritRate;
      
      protected static const BASEATTRIBUTENAME_BlockRate:uint = CONST_COMMON.BASEATTRIBUTENAME_BlockRate;
      
      protected static const FORMAT_UpgradingLevel:String = STRING_COMMON.FORMAT_01;
      
      protected var FPainterUpgradingLevel:TPainterTextEffect;
      
      protected var FPainterRequirementLevel:TPainterTextEffect;
      
      protected var FPainterCategorySecond:TPainterTextEffect;
      
      protected var FPainterRequirementCareer:TPainterTextEffect;
      
      protected var FPainterBasisProperty:TPainterTextEffect;
      
      protected var FPainterFlushSpiritLevel:TPainterTextEffect;
      
      protected var FPainterFlushSpiritAppendAttribute:TPainterTextEffect;
      
      protected var FPainterTotalBasisProperty:TPainterTextEffect;
      
      protected var FPainterAppendAttributeCaption:TPainterTextEffect;
      
      protected var FPainterAppendAttributes:Vector.<TPainterTextEffect>;
      
      protected var FPainterWeaponSkillCaption:TPainterTextEffect;
      
      protected var FPainterGiftedStoneItemCaption:TPainterTextEffect;
      
      protected var FPainterGiftedStoneItemAdd:TPainterTextEffect;
      
      protected var FPainterGiftedStoneItems:Vector.<TPainterHtmlTextEffect>;
      
      protected var FPainterSuitCaption:TPainterTextEffect;
      
      protected var FPainterSuitAttributes:Vector.<TPainterTextEffect>;
      
      protected var FPainterGrowthRate:TPainterTextEffect;
      
      protected var FBoundsUpgradingLevel:TBounds;
      
      protected var FBoundsRequirementLevel:TBounds;
      
      protected var FBoundsCategorySecond:TBounds;
      
      protected var FBoundsRequirementCareer:TBounds;
      
      protected var FBoundsBasisProperty:TBounds;
      
      protected var FBoundsFlushSpiritLevel:TBounds;
      
      protected var FBoundsFlushSpiritAppendAttribute:TBounds;
      
      protected var FBoundsTotleBasisProperty:TBounds;
      
      protected var FBoundsAppendAttributeCaption:TBounds;
      
      protected var FBoundsAppendAttributes:Vector.<TBounds>;
      
      protected var FBoundsWeaponSkillCaption:TBounds;
      
      protected var FBoundsGiftedStoneItemCaption:TBounds;
      
      protected var FBoundsGiftedStoneItemAdd:TBounds;
      
      protected var FBoundsGiftedStoneItems:Vector.<TBounds>;
      
      protected var FBoundsSuitCaption:TBounds;
      
      protected var FBoundsSuitAttributes:Vector.<TBounds>;
      
      protected var FBoundsGrowthrate:TBounds;
      
      protected var FDividingLinePartCaption:Bitmap;
      
      protected var FDividingLinePartAttribute:Bitmap;
      
      protected var FDividingLinePartGiftedStone:Bitmap;
      
      protected var FDividingLinePartSuit:Bitmap;
      
      protected var FDividingLinePartGrowthRate:Bitmap;
      
      protected var FBoundsPartCaption:TBounds;
      
      protected var FBoundsPartAttribute:TBounds;
      
      protected var FBoundsPartGiftedStone:TBounds;
      
      protected var FBoundsPartSuit:TBounds;
      
      protected var FBoundsPartGrowthRate:TBounds;
      
      protected var FContextUpgradingLevel:uint;
      
      protected var FContextAttributeCount:uint;
      
      protected var FAppendAttributes:Vector.<uint>;
      
      protected var FContextGiftedStoneCount:uint;
      
      protected var FContextGiftedStoneIDTemplate:Vector.<uint>;
      
      protected var FContextWeaponSkillID:uint;
      
      protected var FContextSuitCount:uint;
      
      protected var FAddHoleCount:uint;
      
      public function TOverlayerEquipment(param1:TUIComponent)
      {
         var _loc2_:int = 0;
         var _loc3_:TBounds = null;
         var _loc4_:TPainterTextEffect = null;
         var _loc5_:TPainterHtmlTextEffect = null;
         super(param1);
         FInventoryIcon = new TUIImage(this);
         FInventoryIcon.mouseEnabled = false;
         FInventoryIcon.mouseChildren = false;
         FBoundsImage = new TBounds();
         this.FPainterUpgradingLevel = ConstructPainterTextEffect(COLOR_Context_00);
         this.FBoundsUpgradingLevel = new TBounds();
         this.FPainterRequirementLevel = ConstructPainterTextEffect(COLOR_Context_White);
         this.FBoundsRequirementLevel = new TBounds();
         this.FPainterCategorySecond = ConstructPainterTextEffect(COLOR_Context_White);
         this.FBoundsCategorySecond = new TBounds();
         this.FPainterRequirementCareer = ConstructPainterTextEffect(COLOR_Context_White);
         this.FBoundsRequirementCareer = new TBounds();
         this.FPainterBasisProperty = ConstructPainterTextEffect(COLOR_Context_Attributes);
         this.FBoundsBasisProperty = new TBounds();
         this.FPainterFlushSpiritLevel = ConstructPainterTextEffect(COLOR_Context_Attributes);
         this.FBoundsFlushSpiritLevel = new TBounds();
         this.FPainterFlushSpiritAppendAttribute = ConstructPainterTextEffect(COLOR_Context_Attributes);
         this.FBoundsFlushSpiritAppendAttribute = new TBounds();
         this.FPainterTotalBasisProperty = ConstructPainterTextEffect(COLOR_Context_Attributes);
         this.FBoundsTotleBasisProperty = new TBounds();
         this.FPainterAppendAttributeCaption = ConstructPainterTextEffect(COLOR_Context_Title);
         this.FBoundsAppendAttributeCaption = new TBounds();
         this.FPainterAppendAttributes = new Vector.<TPainterTextEffect>(CAPACITY_AppendAttributes);
         this.FBoundsAppendAttributes = new Vector.<TBounds>(CAPACITY_AppendAttributes);
         _loc2_ = 0;
         while(_loc2_ < CAPACITY_AppendAttributes)
         {
            _loc4_ = ConstructPainterTextEffect(COLOR_Context_Attributes);
            this.FPainterAppendAttributes[_loc2_] = _loc4_;
            _loc3_ = new TBounds();
            this.FBoundsAppendAttributes[_loc2_] = _loc3_;
            _loc2_++;
         }
         this.FPainterWeaponSkillCaption = ConstructPainterTextEffect(COLOR_Context_Attributes);
         this.FPainterWeaponSkillCaption.WordWrapWidth = SIZE_WordWrapWidth;
         this.FBoundsWeaponSkillCaption = new TBounds();
         this.FPainterGiftedStoneItemCaption = ConstructPainterTextEffect(COLOR_Context_Title);
         this.FBoundsGiftedStoneItemCaption = new TBounds();
         this.FPainterGiftedStoneItemAdd = ConstructPainterTextEffect(COLOR_Context_Title);
         this.FBoundsGiftedStoneItemAdd = new TBounds();
         this.FPainterGiftedStoneItems = new Vector.<TPainterHtmlTextEffect>(CAPACITY_GiftedStoneItems);
         this.FBoundsGiftedStoneItems = new Vector.<TBounds>(CAPACITY_GiftedStoneItems);
         _loc2_ = 0;
         while(_loc2_ < CAPACITY_GiftedStoneItems)
         {
            _loc5_ = this.ConstructPainterHtmlTextEffect();
            this.FPainterGiftedStoneItems[_loc2_] = _loc5_;
            _loc3_ = new TBounds();
            this.FBoundsGiftedStoneItems[_loc2_] = _loc3_;
            _loc2_++;
         }
         this.FPainterSuitCaption = ConstructPainterTextEffect(COLOR_Context_Title);
         this.FBoundsSuitCaption = new TBounds();
         this.FPainterSuitAttributes = new Vector.<TPainterTextEffect>(CAPACITY_SuitEffects);
         this.FBoundsSuitAttributes = new Vector.<TBounds>(CAPACITY_SuitEffects);
         _loc2_ = 0;
         while(_loc2_ < CAPACITY_SuitEffects)
         {
            _loc4_ = ConstructPainterTextEffect(COLOR_Context_White);
            this.FPainterSuitAttributes[_loc2_] = _loc4_;
            _loc3_ = new TBounds();
            this.FBoundsSuitAttributes[_loc2_] = _loc3_;
            _loc2_++;
         }
         FPainterTimingTime = ConstructPainterTextEffect(COLOR_Context_White);
         FBoundsTimingTime = new TBounds();
         this.FPainterGrowthRate = ConstructPainterTextEffect(COLOR_Context_Attributes);
         this.FBoundsGrowthrate = new TBounds();
         this.FDividingLinePartCaption = new Bitmap();
         this.FDividingLinePartAttribute = new Bitmap();
         this.FDividingLinePartGiftedStone = new Bitmap();
         this.FDividingLinePartSuit = new Bitmap();
         this.FDividingLinePartGrowthRate = new Bitmap();
         addChild(this.FDividingLinePartCaption);
         addChild(this.FDividingLinePartAttribute);
         addChild(this.FDividingLinePartGiftedStone);
         addChild(this.FDividingLinePartSuit);
         addChild(this.FDividingLinePartGrowthRate);
         this.FBoundsPartCaption = new TBounds();
         this.FBoundsPartAttribute = new TBounds();
         this.FBoundsPartGiftedStone = new TBounds();
         this.FBoundsPartSuit = new TBounds();
         this.FBoundsPartGrowthRate = new TBounds();
         FTextFormatCaptionA = new TextFormat();
         FTextFormatCaptionB = new TextFormat();
         this.FAppendAttributes = new Vector.<uint>(CAPACITY_AppendAttributes);
         this.FContextGiftedStoneIDTemplate = new Vector.<uint>(CAPACITY_GiftedStoneItems);
         FQuerySequenceTimer = new Timer(500,1);
         FQuerySequenceTimer.addEventListener(TimerEvent.TIMER_COMPLETE,TimeQuerySequence);
         FMarginLeft = 10;
         FMarginTop = 15;
         FMarginRight = 1;
         FMarginBottom = 5;
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FDividingLinePartCaption.bitmapData = FDividingLine;
         this.FDividingLinePartAttribute.bitmapData = FDividingLine;
         this.FDividingLinePartGiftedStone.bitmapData = FDividingLine;
         this.FDividingLinePartSuit.bitmapData = FDividingLine;
         this.FDividingLinePartGrowthRate.bitmapData = FDividingLine;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ConstructPainterHtmlTextEffect(param1:uint = 4294958161) : TPainterHtmlTextEffect
      {
         var _loc2_:TPainterHtmlTextEffect = null;
         return super.ConstructPainterHtmlTextEffect(param1);
      }
      
      override protected function ContextVerificate(param1:Object) : Boolean
      {
         return param1 is TEquipment;
      }
      
      override protected function ContextModified() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:TAppliance = null;
         var _loc5_:TEquipment = null;
         var _loc6_:uint = 0;
         _loc5_ = FContext as TEquipment;
         _loc3_ = FContextIdentifier != _loc5_.Identifier || FContextIDTemplate != _loc5_.IDTemplate || this.FContextUpgradingLevel != _loc5_.UpgradingLevel || this.FContextAttributeCount != _loc5_.AppendAttributes.Count || this.FContextWeaponSkillID != _loc5_.WeaponSkillID || this.FContextGiftedStoneCount != _loc5_.GiftedStoneItems.Count || this.FContextSuitCount != _loc5_.SuitCount || FContextTimingTime != _loc5_.TimingTime || this.FAddHoleCount != _loc5_.HoleAdditionalQuantity;
         if(!_loc3_)
         {
            _loc2_ = int(this.FContextAttributeCount);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc6_ = _loc5_.AppendAttributes.GetAttributeByIndex(_loc1_).Value;
               if(this.FAppendAttributes[_loc1_] != _loc6_)
               {
                  _loc3_ = true;
                  break;
               }
               _loc1_++;
            }
         }
         if(!_loc3_)
         {
            _loc2_ = int(this.FContextGiftedStoneCount);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc4_ = _loc5_.GiftedStoneItems.GetGiftedStoneByIndex(_loc1_);
               if(_loc4_.IDTemplate != this.FContextGiftedStoneIDTemplate[_loc1_])
               {
                  _loc3_ = true;
                  break;
               }
               _loc1_++;
            }
         }
         return _loc3_;
      }
      
      override protected function ContextSynchronize() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TAppliance = null;
         var _loc4_:TEquipment = null;
         var _loc5_:uint = 0;
         _loc4_ = FContext as TEquipment;
         FContextIdentifier = _loc4_.Identifier;
         FContextIDTemplate = _loc4_.IDTemplate;
         this.FContextUpgradingLevel = _loc4_.UpgradingLevel;
         this.FContextAttributeCount = _loc4_.AppendAttributes.Count;
         this.FContextWeaponSkillID = _loc4_.WeaponSkillID;
         this.FContextGiftedStoneCount = _loc4_.GiftedStoneItems.Count;
         this.FContextSuitCount = _loc4_.SuitCount;
         FContextTimingTime = _loc4_.TimingTime;
         _loc2_ = _loc4_.AppendAttributes.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = _loc4_.AppendAttributes.GetAttributeByIndex(_loc1_).Value;
            this.FAppendAttributes[_loc1_] = _loc5_;
            _loc1_++;
         }
         _loc2_ = int(this.FContextGiftedStoneCount);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = _loc4_.GiftedStoneItems.GetGiftedStoneByIndex(_loc1_);
            this.FContextGiftedStoneIDTemplate[_loc1_] = _loc3_.IDTemplate;
            _loc1_++;
         }
         this.FDividingLinePartCaption.width = SIZE_DividingLine_Min_Width;
         this.FDividingLinePartAttribute.width = SIZE_DividingLine_Min_Width;
         this.FDividingLinePartGiftedStone.width = SIZE_DividingLine_Min_Width;
         this.FDividingLinePartSuit.width = SIZE_DividingLine_Min_Width;
         this.FDividingLinePartGrowthRate.width = SIZE_DividingLine_Min_Width;
         FDividingLinePartTimingTime.width = SIZE_DividingLine_Min_Width;
         super.ContextSynchronize();
      }
      
      override protected function EvaluationPerform_Icon() : void
      {
         var _loc1_:TEquipment = null;
         var _loc2_:TAnimationSequence = null;
         FInventoryIcon.Sequence = null;
         _loc1_ = FContext as TEquipment;
         _loc2_ = SResourcesCore.TexturesInventory.GetAnimationSequenceByIdentifiers(_loc1_.IDTemplate,0);
         if(_loc2_ != null)
         {
            FInventoryIcon.Sequence = _loc2_;
         }
         else
         {
            FInventoryIcon.Sequence = null;
            if(!FQuerySequenceTimer.running)
            {
               FQuerySequenceTimer.start();
            }
         }
         FBoundsImage.X = SIZE_DividingLine_Max_Width - SIZE_Image_Width - SIZE_Padding_03;
         if(false)
         {
            FBoundsImage.X = SIZE_DividingLine_Max_Width - SIZE_Image_Width + 20;
         }
         FBoundsImage.Y = 15;
         FBoundsImage.Width = SIZE_Image_Width;
         FBoundsImage.Height = SIZE_Image_Height;
      }
      
      override protected function EvaluationPerform_Context() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TEquipment = null;
         var _loc4_:TPainterTextEffect = null;
         var _loc5_:TPainterHtmlTextEffect = null;
         _loc3_ = FContext as TEquipment;
         EvaluationPerform_Caption(_loc3_);
         FBoundsOffset = FBoundsCaption;
         this.EvaluationPerform_UpgradingLevel(_loc3_);
         FBoundsOffset = FBoundsCaption;
         this.EvaluationPerform_RequirementLevel(_loc3_);
         FBoundsOffset = this.FBoundsRequirementLevel;
         this.EvaluationPerform_CategorySecond(_loc3_);
         FBoundsOffset = this.FBoundsCategorySecond;
         this.EvaluationPerform_RequirementCareer(_loc3_);
         FBoundsOffset = this.FBoundsRequirementCareer;
         this.EvaluationPerform_PartCaption(null);
         FBoundsOffset = this.FBoundsPartCaption;
         this.EvaluationPerform_BasisProperty(_loc3_);
         FBoundsOffset = this.FBoundsBasisProperty;
         if(_loc3_.FlushSpiritCoefficient != 0)
         {
            this.EvaluationPerform_FlushSpiritLevel(_loc3_);
            FBoundsOffset = this.FBoundsFlushSpiritLevel;
            this.EvaluationPerform_FlushSpiritAppendAttribute(_loc3_);
            FBoundsOffset = this.FBoundsFlushSpiritAppendAttribute;
            this.FPainterFlushSpiritLevel.Visible = true;
            this.FPainterFlushSpiritAppendAttribute.Visible = true;
         }
         else
         {
            this.FPainterFlushSpiritLevel.Visible = false;
            this.FPainterFlushSpiritAppendAttribute.Visible = false;
         }
         this.EvaluationPerform_TotalBasisProperty(_loc3_);
         FBoundsOffset = this.FBoundsTotleBasisProperty;
         if(_loc3_.MaxAdditionalCount != 0)
         {
            this.FPainterAppendAttributeCaption.Visible = true;
            this.EvaluationPerform_AppendAttributeCaption(_loc3_);
            FBoundsOffset = this.FBoundsAppendAttributeCaption;
            this.EvaluationPerform_AppendAttributes(_loc3_);
            _loc2_ = int(_loc3_.MaxAdditionalCount);
            _loc1_ = 0;
            while(_loc1_ < CAPACITY_AppendAttributes)
            {
               _loc4_ = this.FPainterAppendAttributes[_loc1_];
               if(_loc1_ < _loc2_)
               {
                  _loc4_.Visible = true;
               }
               else
               {
                  _loc4_.Visible = false;
               }
               _loc1_++;
            }
         }
         else
         {
            this.FPainterAppendAttributeCaption.Visible = false;
            _loc2_ = int(CAPACITY_AppendAttributes);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc4_ = this.FPainterAppendAttributes[_loc1_];
               _loc4_.Visible = false;
               _loc1_++;
            }
         }
         if(_loc3_.WeaponSkillID > 0)
         {
            this.EvaluationPerform_WeaponSkillCaption(_loc3_);
            FBoundsOffset = this.FBoundsWeaponSkillCaption;
            this.FPainterWeaponSkillCaption.Visible = true;
         }
         else
         {
            this.FPainterWeaponSkillCaption.Visible = false;
         }
         if(_loc3_.HoleQuantity != 0)
         {
            this.EvaluationPerform_PartAttribute(null);
            FBoundsOffset = this.FBoundsPartAttribute;
            this.EvaluationPerform_GiftedStoneItemCaption(_loc3_);
            FBoundsOffset = this.FBoundsGiftedStoneItemCaption;
            this.EvaluationPerform_GiftedStoneItems(_loc3_);
            this.EvaluationPerform_GiftedStoneItemAdd(_loc3_);
            FBoundsOffset = this.FBoundsGiftedStoneItemAdd;
            this.FDividingLinePartAttribute.visible = true;
            this.FPainterGiftedStoneItemCaption.Visible = true;
            this.FPainterGiftedStoneItemAdd.Visible = true;
            _loc2_ = _loc3_.HoleQuantity + _loc3_.HoleAdditionalQuantity;
            _loc1_ = 0;
            while(_loc1_ < CAPACITY_GiftedStoneItems)
            {
               _loc5_ = this.FPainterGiftedStoneItems[_loc1_];
               if(_loc1_ < _loc2_)
               {
                  _loc5_.Visible = true;
               }
               else
               {
                  _loc5_.Visible = false;
               }
               _loc1_++;
            }
         }
         else
         {
            this.FDividingLinePartAttribute.visible = false;
            this.FPainterGiftedStoneItemCaption.Visible = false;
            this.FPainterGiftedStoneItemAdd.Visible = false;
            _loc2_ = int(CAPACITY_GiftedStoneItems);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc5_ = this.FPainterGiftedStoneItems[_loc1_];
               _loc5_.Visible = false;
               _loc1_++;
            }
         }
         this.FDividingLinePartGiftedStone.visible = true;
         this.EvaluationPerform_PartGiftedStone(null);
         FBoundsOffset = this.FBoundsPartGiftedStone;
         if(_loc3_.SuitData.MaxCount != 0)
         {
            this.EvaluationPerform_SuitCaption(_loc3_);
            FBoundsOffset = this.FBoundsSuitCaption;
            this.EvaluationPerform_SuitAttributes(_loc3_);
            this.FPainterSuitCaption.Visible = true;
            _loc1_ = 0;
            while(_loc1_ < CAPACITY_SuitEffects)
            {
               _loc4_ = this.FPainterSuitAttributes[_loc1_];
               _loc4_.Visible = true;
               _loc1_++;
            }
            this.FDividingLinePartSuit.visible = true;
            this.EvaluationPerform_PartSuit(null);
            FBoundsOffset = this.FBoundsPartSuit;
         }
         else
         {
            this.FPainterSuitCaption.Visible = false;
            _loc2_ = int(CAPACITY_SuitEffects);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc4_ = this.FPainterSuitAttributes[_loc1_];
               _loc4_.Visible = false;
               _loc1_++;
            }
            this.FDividingLinePartSuit.visible = false;
         }
         if(_loc3_.GrowthRate != 0)
         {
            this.EvaluationPerform_GrowthRate(_loc3_);
            FBoundsOffset = this.FBoundsGrowthrate;
            this.EvaluationPerform_PartGrowthRate(null);
            FBoundsOffset = this.FBoundsPartGrowthRate;
            this.FPainterGrowthRate.Visible = true;
            this.FDividingLinePartGrowthRate.visible = true;
         }
         else
         {
            this.FPainterGrowthRate.Visible = false;
            this.FDividingLinePartGrowthRate.visible = false;
         }
         EvaluationPerform_SalePrice(_loc3_);
         FBoundsOffset = FBoundsSalePrice;
         if(_loc3_.TimingTime > 0)
         {
            FPainterTimingTime.Visible = true;
            FDividingLinePartTimingTime.visible = true;
            EvaluationPerform_PartTimingTime(null);
            FBoundsOffset = FBoundsPartTimingTime;
            EvaluationPerform_TimingTime(_loc3_);
            FBoundsOffset = FBoundsTimingTime;
         }
         else
         {
            FPainterTimingTime.Visible = false;
            FDividingLinePartTimingTime.visible = false;
         }
      }
      
      protected function EvaluationPerform_UpgradingLevel(param1:TEquipment) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         if(FIsEquiped)
         {
            _loc2_ = int(SIZE_Padding_04);
         }
         else
         {
            _loc2_ = int(SIZE_Padding_01);
         }
         BoundsAlignRight(this.FBoundsUpgradingLevel,FBoundsOffset,_loc2_);
         if(param1.UpgradingLevel > 0)
         {
            _loc3_ = TUtilityString.Format(FORMAT_UpgradingLevel,param1.UpgradingLevel);
         }
         else
         {
            _loc3_ = "";
         }
         this.FPainterUpgradingLevel.Text = _loc3_;
         this.FPainterUpgradingLevel.Font.Size = SIZE_Context_00;
         this.FBoundsUpgradingLevel.Y += 1;
         this.FPainterUpgradingLevel.Evaluate(this.FBoundsUpgradingLevel);
         BoundsContextUnion(this.FBoundsUpgradingLevel);
      }
      
      protected function EvaluationPerform_RequirementLevel(param1:TEquipment) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         BoundsAlignDown(this.FBoundsRequirementLevel,FBoundsOffset,SIZE_Padding_02);
         _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_INVENTORY_RequirementLevel);
         _loc2_ = _loc3_.length - "%0".length;
         this.FPainterRequirementLevel.Text = TUtilityString.Format(_loc3_,param1.RequirementLevel);
         ResetTextFormat();
         FTextFormat.size = this.FPainterRequirementLevel.Font.Size;
         FTextFormat.color = COLOR_Context_Title;
         this.FBoundsRequirementLevel.Y -= 3;
         this.FPainterRequirementLevel.Evaluate(this.FBoundsRequirementLevel);
         this.FPainterRequirementLevel.SetTextFormat(FTextFormat,0,_loc2_);
         BoundsContextUnion(this.FBoundsRequirementLevel);
      }
      
      protected function EvaluationPerform_CategorySecond(param1:TEquipment) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:String = null;
         BoundsAlignDown(this.FBoundsCategorySecond,FBoundsOffset);
         _loc3_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRINGS_EquipmensCaption)[param1.CategorySecond - 1];
         _loc4_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_INVENTORY_CategorySecond);
         _loc2_ = _loc4_.length - "%0".length;
         this.FPainterCategorySecond.Text = TUtilityString.Format(_loc4_,_loc3_);
         ResetTextFormat();
         FTextFormat.size = this.FPainterCategorySecond.Font.Size;
         FTextFormat.color = COLOR_Context_Title;
         --this.FBoundsCategorySecond.Y;
         this.FPainterCategorySecond.Evaluate(this.FBoundsCategorySecond);
         this.FPainterCategorySecond.SetTextFormat(FTextFormat,0,_loc2_);
         BoundsContextUnion(this.FBoundsCategorySecond);
      }
      
      protected function EvaluationPerform_RequirementCareer(param1:TEquipment) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Vector.<uint> = null;
         var _loc8_:uint = 0;
         BoundsAlignDown(this.FBoundsRequirementCareer,FBoundsOffset);
         _loc7_ = param1.RequirementCareer;
         _loc3_ = int(_loc7_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc8_ = _loc7_[_loc2_];
            _loc5_ = TUtilityLobby.GetProfessionByIndex(_loc8_) + "  ";
            _loc2_++;
         }
         _loc6_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_INVENTORY_RequirementCareer);
         _loc4_ = _loc6_.length - "%0".length;
         this.FPainterRequirementCareer.Text = TUtilityString.Format(_loc6_,_loc5_);
         ResetTextFormat();
         FTextFormat.size = this.FPainterRequirementCareer.Font.Size;
         FTextFormat.color = COLOR_Context_Title;
         --this.FBoundsRequirementCareer.Y;
         this.FPainterRequirementCareer.Evaluate(this.FBoundsRequirementCareer);
         this.FPainterRequirementCareer.SetTextFormat(FTextFormat,0,_loc4_);
         BoundsContextUnion(this.FBoundsRequirementCareer);
      }
      
      protected function EvaluationPerform_PartCaption(param1:TEquipment) : void
      {
         this.FBoundsPartCaption.Width = this.FDividingLinePartCaption.width;
         this.FBoundsPartCaption.Height = this.FDividingLinePartCaption.height;
         BoundsAlignDown(this.FBoundsPartCaption,FBoundsOffset,SIZE_Padding_02);
         this.FBoundsPartCaption.X = 0;
         BoundsContextUnion(this.FBoundsPartCaption);
      }
      
      protected function EvaluationPerform_BasisProperty(param1:TEquipment) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         BoundsAlignDown(this.FBoundsBasisProperty,FBoundsOffset,SIZE_Padding_02);
         _loc2_ = BASEATTRIBUTENAMES.indexOf(param1.BasisPropertyCategory[0]);
         _loc4_ = TUtilityLobby.GetBaseAttributeNameByIndex(_loc2_);
         _loc4_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_INVENTORY_01) + _loc4_;
         _loc5_ = param1.BasisProperty[0].toString();
         _loc6_ = param1.UpgradingBasisProperty.length > 0 ? param1.UpgradingBasisProperty[0].toString() : "0";
         _loc3_ = _loc4_.length + 1;
         if(param1.UpgradingBasisProperty.length > 0 && param1.UpgradingBasisProperty[0] != 0)
         {
            this.FPainterBasisProperty.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_INVENTORY_BasisProperty_01),_loc4_,_loc5_,_loc6_);
         }
         else
         {
            this.FPainterBasisProperty.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_INVENTORY_BasisProperty_02),_loc4_,_loc5_);
         }
         ResetTextFormat();
         FTextFormat.size = this.FPainterBasisProperty.Font.Size;
         FTextFormat.color = COLOR_Context_Title;
         this.FPainterBasisProperty.Evaluate(this.FBoundsBasisProperty);
         this.FPainterBasisProperty.SetTextFormat(FTextFormat,0,_loc3_);
         BoundsContextUnion(this.FBoundsBasisProperty);
      }
      
      protected function EvaluationPerform_FlushSpiritLevel(param1:TEquipment) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         BoundsAlignDown(this.FBoundsFlushSpiritLevel,FBoundsOffset,SIZE_Padding_01);
         _loc4_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_INVENTORY_02);
         _loc3_ = _loc4_.length - "%0".length - 1;
         this.FPainterFlushSpiritLevel.Text = TUtilityString.Format(_loc4_,param1.FlushSpiritLevel);
         ResetTextFormat();
         FTextFormat.size = this.FPainterFlushSpiritLevel.Font.Size;
         FTextFormat.color = COLOR_Context_Title;
         this.FPainterFlushSpiritLevel.Evaluate(this.FBoundsFlushSpiritLevel);
         this.FPainterFlushSpiritLevel.SetTextFormat(FTextFormat,0,_loc3_);
         BoundsContextUnion(this.FBoundsFlushSpiritLevel);
      }
      
      protected function EvaluationPerform_FlushSpiritAppendAttribute(param1:TEquipment) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         BoundsAlignDown(this.FBoundsFlushSpiritAppendAttribute,FBoundsOffset,SIZE_Padding_01);
         _loc4_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_INVENTORY_03);
         _loc3_ = _loc4_.length - "%0".length - 1;
         this.FPainterFlushSpiritAppendAttribute.Text = TUtilityString.Format(_loc4_,param1.UpgradingFlushSpiritBasisProperty);
         ResetTextFormat();
         FTextFormat.size = this.FPainterFlushSpiritAppendAttribute.Font.Size;
         FTextFormat.color = COLOR_Context_Title;
         this.FPainterFlushSpiritAppendAttribute.Evaluate(this.FBoundsFlushSpiritAppendAttribute);
         this.FPainterFlushSpiritAppendAttribute.SetTextFormat(FTextFormat,0,_loc3_);
         BoundsContextUnion(this.FBoundsFlushSpiritAppendAttribute);
      }
      
      protected function EvaluationPerform_TotalBasisProperty(param1:TEquipment) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:uint = 0;
         BoundsAlignDown(this.FBoundsTotleBasisProperty,FBoundsOffset,SIZE_Padding_01);
         _loc2_ = BASEATTRIBUTENAMES.indexOf(param1.BasisPropertyCategory[0]);
         _loc4_ = TUtilityLobby.GetBaseAttributeNameByIndex(_loc2_);
         _loc4_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_INVENTORY_04) + _loc4_;
         _loc5_ = param1.BasisProperty[0] + (param1.UpgradingBasisProperty.length > 0 ? param1.UpgradingBasisProperty[0] : 0) + param1.UpgradingFlushSpiritBasisProperty;
         _loc3_ = _loc4_.length + 1;
         this.FPainterTotalBasisProperty.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_INVENTORY_BasisProperty_02),_loc4_,_loc5_);
         ResetTextFormat();
         FTextFormat.size = this.FPainterTotalBasisProperty.Font.Size;
         FTextFormat.color = COLOR_Context_Title;
         this.FPainterTotalBasisProperty.Evaluate(this.FBoundsTotleBasisProperty);
         this.FPainterTotalBasisProperty.SetTextFormat(FTextFormat,0,_loc3_);
         BoundsContextUnion(this.FBoundsTotleBasisProperty);
      }
      
      protected function EvaluationPerform_AppendAttributeCaption(param1:TEquipment) : void
      {
         BoundsAlignDown(this.FBoundsAppendAttributeCaption,FBoundsOffset,SIZE_Padding_01);
         this.FPainterAppendAttributeCaption.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_INVENTORY_AppendAttributeCaption);
         this.FPainterAppendAttributeCaption.Evaluate(this.FBoundsAppendAttributeCaption);
         BoundsContextUnion(this.FBoundsAppendAttributeCaption);
      }
      
      protected function EvaluationPerform_AppendAttributes(param1:TEquipment) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TBounds = null;
         var _loc6_:TPainterTextEffect = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:uint = 0;
         var _loc10_:TEquipmentAppendAttribute = null;
         var _loc11_:int = 0;
         _loc3_ = int(param1.MaxAdditionalCount);
         _loc4_ = param1.AppendAttributes.Count;
         _loc2_ = 0;
         while(_loc2_ < CAPACITY_AppendAttributes)
         {
            if(_loc2_ >= _loc3_)
            {
               break;
            }
            _loc5_ = this.FBoundsAppendAttributes[_loc2_];
            if(_loc2_ == 0)
            {
               BoundsAlignRight(_loc5_,FBoundsOffset,SIZE_Padding_01);
            }
            else
            {
               BoundsAlignDown(_loc5_,FBoundsOffset);
            }
            FBoundsOffset = _loc5_;
            _loc6_ = this.FPainterAppendAttributes[_loc2_];
            if(_loc2_ < _loc4_)
            {
               _loc10_ = param1.AppendAttributes.GetAttributeByIndex(_loc2_);
               _loc9_ = _loc10_.Category;
               _loc11_ = BASEATTRIBUTENAMES.indexOf(_loc9_);
               _loc7_ = TUtilityLobby.GetBaseAttributeNameByIndex(_loc11_);
               if(_loc10_.Percentage == 1)
               {
                  _loc8_ = Number(_loc10_.Value / (_loc10_.Divisor / 100)).toFixed(1);
               }
               else
               {
                  _loc8_ = _loc10_.Value.toString();
               }
               if(_loc10_.Percentage == 1)
               {
                  _loc6_.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_INVENTORY_AppendAttributesPercentage),_loc7_,_loc8_);
               }
               else
               {
                  _loc6_.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_INVENTORY_AppendAttributes),_loc7_,_loc8_);
               }
               _loc6_.Font.Color = COLOR_Context_Attributes;
               _loc6_.Evaluate(_loc5_);
               BoundsContextUnion(_loc5_);
            }
            else
            {
               _loc6_.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_INVENTORY_AppendAttributesUnknown);
               _loc6_.Font.Color = COLOR_Context_Unknown;
               _loc6_.Evaluate(_loc5_);
               BoundsContextUnion(_loc5_);
            }
            _loc2_++;
         }
      }
      
      protected function EvaluationPerform_WeaponSkillCaption(param1:TEquipment) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         BoundsAlignDown(this.FBoundsWeaponSkillCaption,FBoundsOffset,SIZE_Padding_02);
         _loc6_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_INVENTORY_WeaponSkillCaption);
         _loc5_ = _loc6_.length - " %0\n%1".length;
         _loc4_ = TUtilityString.Format(_loc6_,param1.WeaponSkillName,param1.WeaponSkillDesc);
         this.FPainterWeaponSkillCaption.Text = _loc4_;
         this.FBoundsWeaponSkillCaption.X = 0;
         ResetTextFormat();
         FTextFormat.color = COLOR_Context_Title;
         this.FPainterWeaponSkillCaption.Evaluate(this.FBoundsWeaponSkillCaption);
         _loc2_ = 0;
         _loc3_ = _loc5_;
         this.FPainterWeaponSkillCaption.SetTextFormat(FTextFormat,_loc2_,_loc3_);
         _loc2_ = _loc4_.indexOf(param1.WeaponSkillDesc);
         _loc3_ = _loc2_ + param1.WeaponSkillDesc.length;
         ResetTextFormat();
         FTextFormat.color = COLOR_Context_Explanation;
         this.FPainterWeaponSkillCaption.SetTextFormat(FTextFormat,_loc2_,_loc3_);
         BoundsContextUnion(this.FBoundsWeaponSkillCaption);
      }
      
      protected function EvaluationPerform_PartAttribute(param1:TEquipment) : void
      {
         this.FBoundsPartAttribute.Width = this.FDividingLinePartAttribute.width;
         this.FBoundsPartAttribute.Height = this.FDividingLinePartAttribute.height;
         BoundsAlignDown(this.FBoundsPartAttribute,FBoundsOffset,SIZE_Padding_02);
         this.FBoundsPartAttribute.X = 0;
         BoundsContextUnion(this.FBoundsPartAttribute);
      }
      
      protected function EvaluationPerform_GiftedStoneItemCaption(param1:TEquipment) : void
      {
         BoundsAlignDown(this.FBoundsGiftedStoneItemCaption,FBoundsOffset,SIZE_Padding_02);
         this.FPainterGiftedStoneItemCaption.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_INVENTORY_GiftedStoneItemCaption);
         this.FPainterGiftedStoneItemCaption.Evaluate(this.FBoundsGiftedStoneItemCaption);
         BoundsContextUnion(this.FBoundsGiftedStoneItemCaption);
      }
      
      protected function EvaluationPerform_GiftedStoneItems(param1:TEquipment) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TBounds = null;
         var _loc5_:TPainterTextEffect = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:uint = 0;
         var _loc9_:TInventory = null;
         var _loc10_:TGiftedStoneItems = null;
         var _loc11_:TPainterHtmlTextEffect = null;
         _loc10_ = param1.GiftedStoneItems;
         _loc8_ = param1.HoleQuantity;
         this.FAddHoleCount = param1.HoleAdditionalQuantity;
         _loc3_ = _loc10_.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc8_ + this.FAddHoleCount)
         {
            if(_loc2_ >= _loc8_ + this.FAddHoleCount)
            {
               break;
            }
            _loc4_ = this.FBoundsGiftedStoneItems[_loc2_];
            BoundsAlignDown(_loc4_,FBoundsOffset);
            FBoundsOffset = _loc4_;
            _loc11_ = this.FPainterGiftedStoneItems[_loc2_];
            if(_loc2_ < _loc8_ + this.FAddHoleCount && _loc2_ < _loc3_)
            {
               _loc9_ = _loc10_.GetGiftedStoneByIndex(_loc2_);
               _loc6_ = _loc9_.Name;
               _loc7_ = _loc9_.Description;
               _loc11_.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_INVENTORY_GiftedStoneItems),_loc6_,_loc7_);
               _loc11_.Evaluate(_loc4_);
               BoundsContextUnion(_loc4_);
            }
            else
            {
               _loc11_.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_INVENTORY_GiftedStoneItemNull);
               _loc11_.Evaluate(_loc4_);
               BoundsContextUnion(_loc4_);
            }
            _loc2_++;
         }
      }
      
      protected function EvaluationPerform_GiftedStoneItemAdd(param1:TEquipment) : void
      {
         BoundsAlignDown(this.FBoundsGiftedStoneItemAdd,FBoundsOffset,SIZE_Padding_02);
         if(param1.HoleAdditionalMax == 0)
         {
            this.FPainterGiftedStoneItemAdd.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_50);
         }
         else
         {
            this.FPainterGiftedStoneItemAdd.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_51),param1.HoleAdditionalQuantity,param1.HoleAdditionalMax);
         }
         this.FPainterGiftedStoneItemAdd.Evaluate(this.FBoundsGiftedStoneItemAdd);
         BoundsContextUnion(this.FBoundsGiftedStoneItemAdd);
      }
      
      protected function EvaluationPerform_PartGiftedStone(param1:TEquipment) : void
      {
         this.FBoundsPartGiftedStone.Width = this.FDividingLinePartGiftedStone.width;
         this.FBoundsPartGiftedStone.Height = this.FDividingLinePartGiftedStone.height;
         BoundsAlignDown(this.FBoundsPartGiftedStone,FBoundsOffset,SIZE_Padding_02);
         this.FBoundsPartGiftedStone.X = 0;
         BoundsContextUnion(this.FBoundsPartGiftedStone);
      }
      
      protected function EvaluationPerform_PartSuit(param1:TEquipment) : void
      {
         this.FBoundsPartSuit.Width = this.FDividingLinePartSuit.width;
         this.FBoundsPartSuit.Height = this.FDividingLinePartSuit.height;
         BoundsAlignDown(this.FBoundsPartSuit,FBoundsOffset,SIZE_Padding_02);
         this.FBoundsPartSuit.X = 0;
         BoundsContextUnion(this.FBoundsPartSuit);
      }
      
      protected function EvaluationPerform_SuitCaption(param1:TEquipment) : void
      {
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         BoundsAlignDown(this.FBoundsSuitCaption,FBoundsOffset,SIZE_Padding_02);
         _loc2_ = param1.SuitData.Name;
         _loc3_ = param1.SuitData.MaxCount;
         this.FPainterSuitCaption.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_INVENTORY_SuitCaption),_loc2_,param1.SuitCount,_loc3_);
         this.FPainterSuitCaption.Evaluate(this.FBoundsSuitCaption);
         BoundsContextUnion(this.FBoundsSuitCaption);
      }
      
      protected function EvaluationPerform_SuitAttributes(param1:TEquipment) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TBounds = null;
         var _loc8_:TPainterTextEffect = null;
         var _loc9_:TSuitEffect = null;
         var _loc10_:uint = 0;
         var _loc11_:String = null;
         var _loc12_:String = null;
         _loc2_ = 0;
         while(_loc2_ < CAPACITY_SuitEffects)
         {
            _loc7_ = this.FBoundsSuitAttributes[_loc2_];
            BoundsAlignDown(_loc7_,FBoundsOffset);
            FBoundsOffset = _loc7_;
            _loc8_ = this.FPainterSuitAttributes[_loc2_];
            _loc9_ = param1.SuitData.SuitEffects.GetSuitEffectByIndex(_loc2_);
            _loc10_ = _loc9_.SuitQuantity;
            _loc11_ = "";
            _loc5_ = int(_loc9_.Category.length);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               if(_loc9_.Percentage[_loc4_] == 1)
               {
                  _loc12_ = String((parseFloat(_loc9_.Value[_loc4_]) * 100).toFixed(0)) + "%";
               }
               else
               {
                  _loc12_ = _loc9_.Value[_loc4_];
               }
               _loc6_ = BASEATTRIBUTENAMES.indexOf(_loc9_.Category[_loc4_]);
               _loc11_ += TUtilityLobby.GetBaseAttributeNameByIndex(_loc6_) + "+" + _loc12_ + "   ";
               _loc4_++;
            }
            _loc8_.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_INVENTORY_Suit_01),_loc10_,_loc11_);
            if(param1.SuitCount >= (_loc2_ + 1) * 2)
            {
               _loc8_.Font.Color = COLOR_Context_White;
            }
            else
            {
               _loc8_.Font.Color = COLOR_Context_Invalid;
            }
            _loc8_.Evaluate(_loc7_);
            BoundsContextUnion(_loc7_);
            _loc2_++;
         }
      }
      
      protected function EvaluationPerform_PartGrowthRate(param1:TEquipment) : void
      {
         this.FBoundsPartGrowthRate.Width = this.FDividingLinePartGrowthRate.width;
         this.FBoundsPartGrowthRate.Height = this.FDividingLinePartGrowthRate.height;
         BoundsAlignDown(this.FBoundsPartGrowthRate,FBoundsOffset);
         this.FBoundsPartGrowthRate.X = 0;
         BoundsContextUnion(this.FBoundsPartGrowthRate);
      }
      
      protected function EvaluationPerform_GrowthRate(param1:TEquipment) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         BoundsAlignDown(this.FBoundsGrowthrate,FBoundsOffset,SIZE_Padding_03);
         _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_INVENTORY_GrowthRate);
         _loc2_ = _loc3_.length - "%0".length;
         this.FPainterGrowthRate.Text = TUtilityString.Format(_loc3_,param1.GrowthRate);
         ResetTextFormat();
         FTextFormat.size = this.FPainterGrowthRate.Font.Size;
         FTextFormat.color = COLOR_Context_Title;
         this.FPainterGrowthRate.Evaluate(this.FBoundsGrowthrate);
         this.FPainterGrowthRate.SetTextFormat(FTextFormat,0,_loc2_);
         BoundsContextUnion(this.FBoundsGrowthrate);
      }
      
      override protected function SketchingPerform_Context() : void
      {
         var _loc1_:TEquipment = null;
         _loc1_ = FContext as TEquipment;
      }
      
      override protected function RenderingPerform_Context(param1:TCoordinate) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TBounds = null;
         var _loc5_:TPainterTextEffect = null;
         var _loc6_:TPainterHtmlTextEffect = null;
         var _loc7_:TEquipment = null;
         _loc7_ = FContext as TEquipment;
         FBoundsRendering.X = FMarginLeft;
         FBoundsRendering.Y = FMarginTop;
         FInventoryIcon.X = FBoundsRendering.X + FBoundsImage.X;
         FInventoryIcon.Y = FBoundsRendering.Y + FBoundsImage.Y;
         FPainterCaption.X = FBoundsRendering.X + FBoundsCaption.X;
         FPainterCaption.Y = FBoundsRendering.Y + FBoundsCaption.Y;
         this.FPainterUpgradingLevel.X = FBoundsRendering.X + this.FBoundsUpgradingLevel.X;
         this.FPainterUpgradingLevel.Y = FBoundsRendering.Y + this.FBoundsUpgradingLevel.Y;
         this.FPainterRequirementLevel.X = FBoundsRendering.X + this.FBoundsRequirementLevel.X;
         this.FPainterRequirementLevel.Y = FBoundsRendering.Y + this.FBoundsRequirementLevel.Y;
         this.FPainterCategorySecond.X = FBoundsRendering.X + this.FBoundsCategorySecond.X;
         this.FPainterCategorySecond.Y = FBoundsRendering.Y + this.FBoundsCategorySecond.Y;
         this.FPainterRequirementCareer.X = FBoundsRendering.X + this.FBoundsRequirementCareer.X;
         this.FPainterRequirementCareer.Y = FBoundsRendering.Y + this.FBoundsRequirementCareer.Y;
         this.FDividingLinePartCaption.x = FBoundsRendering.X + this.FBoundsPartCaption.X - FMarginLeft + SIZE_DividingLineOffset;
         this.FDividingLinePartCaption.y = FBoundsRendering.Y + this.FBoundsPartCaption.Y;
         this.FPainterBasisProperty.X = FBoundsRendering.X + this.FBoundsBasisProperty.X;
         this.FPainterBasisProperty.Y = FBoundsRendering.Y + this.FBoundsBasisProperty.Y;
         if(_loc7_.FlushSpiritCoefficient != 0)
         {
            this.FPainterFlushSpiritLevel.X = FBoundsRendering.X + this.FBoundsFlushSpiritLevel.X;
            this.FPainterFlushSpiritLevel.Y = FBoundsRendering.Y + this.FBoundsFlushSpiritLevel.Y;
            this.FPainterFlushSpiritAppendAttribute.X = FBoundsRendering.X + this.FBoundsFlushSpiritAppendAttribute.X;
            this.FPainterFlushSpiritAppendAttribute.Y = FBoundsRendering.Y + this.FBoundsFlushSpiritAppendAttribute.Y;
         }
         this.FPainterTotalBasisProperty.X = FBoundsRendering.X + this.FBoundsTotleBasisProperty.X;
         this.FPainterTotalBasisProperty.Y = FBoundsRendering.Y + this.FBoundsTotleBasisProperty.Y;
         if(_loc7_.MaxAdditionalCount != 0)
         {
            this.FPainterAppendAttributeCaption.X = FBoundsRendering.X + this.FBoundsAppendAttributeCaption.X;
            this.FPainterAppendAttributeCaption.Y = FBoundsRendering.Y + this.FBoundsAppendAttributeCaption.Y;
            _loc3_ = int(_loc7_.MaxAdditionalCount);
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               if(_loc2_ >= _loc3_)
               {
                  break;
               }
               _loc5_ = this.FPainterAppendAttributes[_loc2_];
               _loc4_ = this.FBoundsAppendAttributes[_loc2_];
               _loc5_.X = FBoundsRendering.X + _loc4_.X;
               _loc5_.Y = FBoundsRendering.Y + _loc4_.Y;
               _loc2_++;
            }
         }
         if(_loc7_.WeaponSkillID > 0)
         {
            this.FPainterWeaponSkillCaption.X = FBoundsRendering.X + this.FBoundsWeaponSkillCaption.X;
            this.FPainterWeaponSkillCaption.Y = FBoundsRendering.Y + this.FBoundsWeaponSkillCaption.Y;
         }
         if(_loc7_.HoleQuantity != 0)
         {
            this.FDividingLinePartAttribute.x = FBoundsRendering.X + this.FBoundsPartAttribute.X - FMarginLeft + SIZE_DividingLineOffset;
            this.FDividingLinePartAttribute.y = FBoundsRendering.Y + this.FBoundsPartAttribute.Y;
            this.FPainterGiftedStoneItemCaption.X = FBoundsRendering.X + this.FBoundsGiftedStoneItemCaption.X;
            this.FPainterGiftedStoneItemCaption.Y = FBoundsRendering.Y + this.FBoundsGiftedStoneItemCaption.Y;
            this.FPainterGiftedStoneItemAdd.X = FBoundsRendering.X + this.FBoundsGiftedStoneItemAdd.X;
            this.FPainterGiftedStoneItemAdd.Y = FBoundsRendering.Y + this.FBoundsGiftedStoneItemAdd.Y;
            _loc3_ = _loc7_.HoleQuantity + _loc7_.HoleAdditionalQuantity;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               _loc6_ = this.FPainterGiftedStoneItems[_loc2_];
               _loc4_ = this.FBoundsGiftedStoneItems[_loc2_];
               _loc6_.X = FBoundsRendering.X + _loc4_.X;
               _loc6_.Y = FBoundsRendering.Y + _loc4_.Y;
               _loc2_++;
            }
         }
         this.FDividingLinePartGiftedStone.x = FBoundsRendering.X + this.FBoundsPartGiftedStone.X - FMarginLeft + SIZE_DividingLineOffset;
         this.FDividingLinePartGiftedStone.y = FBoundsRendering.Y + this.FBoundsPartGiftedStone.Y;
         if(_loc7_.SuitData.MaxCount != 0)
         {
            this.FPainterSuitCaption.X = FBoundsRendering.X + this.FBoundsSuitCaption.X;
            this.FPainterSuitCaption.Y = FBoundsRendering.Y + this.FBoundsSuitCaption.Y;
            _loc2_ = 0;
            while(_loc2_ < CAPACITY_SuitEffects)
            {
               _loc5_ = this.FPainterSuitAttributes[_loc2_];
               _loc4_ = this.FBoundsSuitAttributes[_loc2_];
               _loc5_.X = FBoundsRendering.X + _loc4_.X;
               _loc5_.Y = FBoundsRendering.Y + _loc4_.Y;
               _loc2_++;
            }
            this.FDividingLinePartSuit.x = FBoundsRendering.X + this.FBoundsPartSuit.X - FMarginLeft + SIZE_DividingLineOffset;
            this.FDividingLinePartSuit.y = FBoundsRendering.Y + this.FBoundsPartSuit.Y;
         }
         if(_loc7_.GrowthRate != 0)
         {
            this.FPainterGrowthRate.X = FBoundsRendering.X + this.FBoundsGrowthrate.X;
            this.FPainterGrowthRate.Y = FBoundsRendering.X + this.FBoundsGrowthrate.Y;
            this.FDividingLinePartGrowthRate.x = FBoundsRendering.X + this.FBoundsPartGrowthRate.X - FMarginLeft + SIZE_DividingLineOffset;
            this.FDividingLinePartGrowthRate.y = FBoundsRendering.Y + this.FBoundsPartGrowthRate.Y;
         }
         FPainterSalePrice.X = FBoundsRendering.X + FBoundsSalePrice.X;
         FPainterSalePrice.Y = FBoundsRendering.Y + FBoundsSalePrice.Y;
         if(_loc7_.TimingTime > 0)
         {
            FDividingLinePartTimingTime.x = FBoundsRendering.X + FBoundsPartTimingTime.X - FMarginLeft + SIZE_DividingLineOffset;
            FDividingLinePartTimingTime.y = FBoundsRendering.Y + FBoundsPartTimingTime.Y;
            FPainterTimingTime.X = FBoundsRendering.X + FBoundsTimingTime.X;
            FPainterTimingTime.Y = FBoundsRendering.Y + FBoundsTimingTime.Y;
         }
         this.FDividingLinePartCaption.width = SIZE_DividingLine_Max_Width;
         this.FDividingLinePartAttribute.width = SIZE_DividingLine_Max_Width;
         this.FDividingLinePartGiftedStone.width = SIZE_DividingLine_Max_Width;
         this.FDividingLinePartGrowthRate.width = SIZE_DividingLine_Max_Width;
         FDividingLinePartTimingTime.width = SIZE_DividingLine_Max_Width;
      }
   }
}

