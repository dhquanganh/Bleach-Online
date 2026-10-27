package Rendering.Overlayers.Inventories
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.TBaseEquip;
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
   
   public class TOverlayerTreasure extends TOverlayerInventory
   {
      
      protected static const SIZE_DividingLine_Max_Width:uint = 280;
      
      protected static const SIZE_DividingLine_Min_Width:uint = 275;
      
      protected static const CAPACITY_SuitEffects:uint = 3;
      
      protected static const SIZE_WordWrapWidth:uint = 130;
      
      protected static const SIZE_TextFormat_leading:uint = 2;
      
      protected static const CATEGORY_TreasurePower:uint = CONST_INVENTORY.CATEGORYSECOND_TreasurePower;
      
      protected static const BASEATTRIBUTENAMES:Vector.<uint> = CONST_COMMON.BASEATTRIBUTENAMES;
      
      protected static const FORMAT_UpgradingLevel:String = STRING_COMMON.FORMAT_01;
      
      protected static const FORMAT_AppendAttributes_01:String = STRING_COMMON.FORMAT_02;
      
      protected static const FORMAT_AppendAttributes_02:String = STRING_COMMON.FORMAT_03;
      
      private var StringLevelVec:Vector.<String>;
      
      private var StringTreasureSuitNameVec:Vector.<String>;
      
      protected var FPainterUpgradingLevel:TPainterTextEffect;
      
      protected var FPainterRequirementLevel:TPainterTextEffect;
      
      protected var FPainterCategorySecond:TPainterTextEffect;
      
      protected var FPainterAppendAttributeCaption:TPainterTextEffect;
      
      protected var FPainterAppendAttributes:TPainterTextEffect;
      
      protected var FPainterDescCaption:TPainterTextEffect;
      
      protected var FPainterSuitCaption:TPainterTextEffect;
      
      protected var FPainterSuitAttributes:Vector.<TPainterTextEffect>;
      
      protected var FBoundsUpgradingLevel:TBounds;
      
      protected var FBoundsRequirementLevel:TBounds;
      
      protected var FBoundsCategorySecond:TBounds;
      
      protected var FBoundsAppendAttributeCaption:TBounds;
      
      protected var FBoundsAppendAttributes:TBounds;
      
      protected var FBoundsDescCaption:TBounds;
      
      protected var FBoundsSuitCaption:TBounds;
      
      protected var FBoundsSuitAttributes:Vector.<TBounds>;
      
      protected var FDividingLinePartCaption:Bitmap;
      
      protected var FDividingLinePartAttribute:Bitmap;
      
      protected var FDividingLinePartDescCaption:Bitmap;
      
      protected var FDividingLinePartSuit:Bitmap;
      
      protected var FBoundsPartCaption:TBounds;
      
      protected var FBoundsPartAttribute:TBounds;
      
      protected var FBoundsPartDescCaption:TBounds;
      
      protected var FBoundsPartSuit:TBounds;
      
      protected var FContextUpgradingLevel:uint;
      
      protected var FContextSuitCount:uint;
      
      public function TOverlayerTreasure(param1:TUIComponent)
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TBounds = null;
         var _loc5_:TPainterTextEffect = null;
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
         this.FPainterAppendAttributeCaption = ConstructPainterTextEffect(COLOR_Context_White);
         this.FBoundsAppendAttributeCaption = new TBounds();
         this.FPainterAppendAttributes = ConstructPainterTextEffect(COLOR_Context_Attributes);
         this.FBoundsAppendAttributes = new TBounds();
         this.FPainterDescCaption = ConstructPainterTextEffect(COLOR_Context_Explanation);
         this.FPainterDescCaption.WordWrapWidth = SIZE_WordWrapWidth;
         this.FBoundsDescCaption = new TBounds();
         this.FPainterSuitCaption = ConstructPainterTextEffect(COLOR_Context_Title);
         this.FBoundsSuitCaption = new TBounds();
         this.FPainterSuitAttributes = new Vector.<TPainterTextEffect>(CAPACITY_SuitEffects);
         this.FBoundsSuitAttributes = new Vector.<TBounds>(CAPACITY_SuitEffects);
         _loc2_ = 0;
         while(_loc2_ < CAPACITY_SuitEffects)
         {
            _loc5_ = ConstructPainterTextEffect(COLOR_Context_White);
            this.FPainterSuitAttributes[_loc2_] = _loc5_;
            _loc4_ = new TBounds();
            this.FBoundsSuitAttributes[_loc2_] = _loc4_;
            _loc2_++;
         }
         this.FDividingLinePartCaption = new Bitmap();
         this.FDividingLinePartAttribute = new Bitmap();
         this.FDividingLinePartDescCaption = new Bitmap();
         this.FDividingLinePartSuit = new Bitmap();
         addChild(this.FDividingLinePartCaption);
         addChild(this.FDividingLinePartAttribute);
         addChild(this.FDividingLinePartDescCaption);
         addChild(this.FDividingLinePartSuit);
         this.FBoundsPartCaption = new TBounds();
         this.FBoundsPartAttribute = new TBounds();
         this.FBoundsPartDescCaption = new TBounds();
         this.FBoundsPartSuit = new TBounds();
         FTextFormatCaptionA = new TextFormat();
         FTextFormatCaptionB = new TextFormat();
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
         this.FDividingLinePartDescCaption.bitmapData = FDividingLine;
         this.FDividingLinePartSuit.bitmapData = FDividingLine;
         this.StringLevelVec = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_33);
         this.StringTreasureSuitNameVec = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_35);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ContextVerificate(param1:Object) : Boolean
      {
         return param1 is TEquipment;
      }
      
      override protected function ContextModified() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:TEquipment = null;
         _loc2_ = FContext as TEquipment;
         return FContextIdentifier != _loc2_.Identifier || FContextIDTemplate != _loc2_.IDTemplate || this.FContextUpgradingLevel != _loc2_.UpgradingLevel || this.FContextSuitCount != _loc2_.SuitCount || FContextTimingTime != _loc2_.TimingTime;
      }
      
      override protected function ContextSynchronize() : void
      {
         var _loc1_:TEquipment = null;
         _loc1_ = FContext as TEquipment;
         FContextIdentifier = _loc1_.Identifier;
         FContextIDTemplate = _loc1_.IDTemplate;
         this.FContextUpgradingLevel = _loc1_.UpgradingLevel;
         this.FContextSuitCount = _loc1_.SuitCount;
         FContextTimingTime = _loc1_.TimingTime;
         this.FDividingLinePartCaption.width = SIZE_DividingLine_Min_Width;
         this.FDividingLinePartAttribute.width = SIZE_DividingLine_Min_Width;
         this.FDividingLinePartDescCaption.width = SIZE_DividingLine_Min_Width;
         this.FDividingLinePartSuit.width = SIZE_DividingLine_Min_Width;
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
         FBoundsImage.Y = -8;
         FBoundsImage.Width = SIZE_Image_Width;
         FBoundsImage.Height = SIZE_Image_Height;
      }
      
      override protected function EvaluationPerform_Context() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TEquipment = null;
         var _loc4_:TSuitEffect = null;
         var _loc5_:TPainterTextEffect = null;
         _loc3_ = FContext as TEquipment;
         EvaluationPerform_Caption(_loc3_);
         FBoundsOffset = FBoundsCaption;
         this.EvaluationPerform_UpgradingLevel(_loc3_);
         FBoundsOffset = FBoundsCaption;
         this.EvaluationPerform_RequirementLevel(_loc3_);
         FBoundsOffset = this.FBoundsRequirementLevel;
         this.EvaluationPerform_CategorySecond(_loc3_);
         FBoundsOffset = this.FBoundsCategorySecond;
         this.EvaluationPerform_PartCaption(null);
         FBoundsOffset = this.FBoundsPartCaption;
         this.EvaluationPerform_AppendAttributeCaption(_loc3_);
         FBoundsOffset = this.FBoundsAppendAttributeCaption;
         this.EvaluationPerform_AppendAttributes(_loc3_);
         FBoundsOffset = this.FBoundsAppendAttributes;
         this.EvaluationPerform_PartAttribute(null);
         FBoundsOffset = this.FBoundsPartAttribute;
         this.EvaluationPerform_DescCaption(_loc3_);
         FBoundsOffset = this.FBoundsDescCaption;
         this.EvaluationPerform_PartDescCaption(null);
         FBoundsOffset = this.FBoundsPartDescCaption;
         if(_loc3_.SuitData.MaxCount != 0)
         {
            this.EvaluationPerform_SuitCaption(_loc3_);
            FBoundsOffset = this.FBoundsSuitCaption;
            this.EvaluationPerform_SuitAttributes(_loc3_);
            this.FPainterSuitCaption.Visible = true;
            _loc1_ = 0;
            while(_loc1_ < CAPACITY_SuitEffects)
            {
               _loc5_ = this.FPainterSuitAttributes[_loc1_];
               _loc4_ = _loc3_.SuitData.SuitEffects.GetSuitEffectByIndex(_loc1_);
               _loc5_.Visible = _loc4_.Value.length > 0;
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
               _loc5_ = this.FPainterSuitAttributes[_loc1_];
               _loc5_.Visible = false;
               _loc1_++;
            }
            this.FDividingLinePartSuit.visible = false;
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
         if(param1.RequirementLevel < 100)
         {
            if(param1.UpgradingLevel > 0)
            {
               _loc3_ = TUtilityString.Format(FORMAT_UpgradingLevel,param1.UpgradingLevel.toString());
            }
            else
            {
               _loc3_ = "";
            }
         }
         else
         {
            _loc3_ = this.GetLevelStringName(param1.UpgradingLevel);
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
         var _loc4_:int = 0;
         BoundsAlignDown(this.FBoundsRequirementLevel,FBoundsOffset,SIZE_Padding_01);
         _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_Talisman_RequirementLevel);
         _loc2_ = _loc3_.length - "%0".length;
         if(param1.RequirementLevel < 100)
         {
            this.FPainterRequirementLevel.Text = TUtilityString.Format(_loc3_,param1.RequirementLevel);
         }
         else
         {
            _loc4_ = param1.RequirementLevel - 100;
            this.FPainterRequirementLevel.Text = TUtilityString.Format(_loc3_,this.StringTreasureSuitNameVec[_loc4_]);
         }
         ResetTextFormat();
         FTextFormat.size = this.FPainterRequirementLevel.Font.Size;
         FTextFormat.color = COLOR_Context_Title;
         this.FBoundsRequirementLevel.Y -= 2;
         this.FPainterRequirementLevel.Evaluate(this.FBoundsRequirementLevel);
         this.FPainterRequirementLevel.SetTextFormat(FTextFormat,0,_loc2_);
         BoundsContextUnion(this.FBoundsRequirementLevel);
      }
      
      protected function EvaluationPerform_CategorySecond(param1:TEquipment) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:TBaseEquip = null;
         BoundsAlignDown(this.FBoundsCategorySecond,FBoundsOffset,SIZE_Padding_01);
         if(param1.RequirementLevel < 100)
         {
            _loc5_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRINGS_TreasuresAttributeCaption)[param1.CategorySecond % CATEGORY_TreasurePower];
         }
         else
         {
            _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseEquip,param1.IDTemplate) as TBaseEquip;
            _loc5_ = "";
            _loc3_ = int(_loc7_.MainType.length);
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               _loc5_ += TUtilityLobby.GetBaseAttributeNameByType(_loc7_.MainType[_loc2_]) + " ";
               _loc2_++;
            }
         }
         _loc6_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_Talisman_CategorySecond);
         this.FPainterCategorySecond.Text = TUtilityString.Format(_loc6_,_loc5_);
         ResetTextFormat();
         FTextFormat.color = COLOR_Context_Title;
         this.FPainterCategorySecond.Evaluate(this.FBoundsCategorySecond);
         _loc4_ = _loc6_.length - "%0".length;
         this.FPainterCategorySecond.SetTextFormat(FTextFormat,0,_loc4_);
         BoundsContextUnion(this.FBoundsCategorySecond);
      }
      
      protected function EvaluationPerform_PartCaption(param1:TEquipment) : void
      {
         this.FBoundsPartCaption.Width = this.FDividingLinePartCaption.width;
         this.FBoundsPartCaption.Height = this.FDividingLinePartCaption.height;
         BoundsAlignDown(this.FBoundsPartCaption,FBoundsOffset,SIZE_Padding_02);
         this.FBoundsPartCaption.X = 0;
         BoundsContextUnion(this.FBoundsPartCaption);
      }
      
      protected function EvaluationPerform_AppendAttributeCaption(param1:TEquipment) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:String = null;
         BoundsAlignDown(this.FBoundsAppendAttributeCaption,FBoundsOffset,SIZE_Padding_02);
         _loc3_ = "";
         _loc4_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_Talisman_AppendAttributeCaption);
         this.FPainterAppendAttributeCaption.Text = TUtilityString.Format(_loc4_,_loc3_);
         ResetTextFormat();
         FTextFormat.color = COLOR_Context_Title;
         this.FPainterAppendAttributeCaption.Evaluate(this.FBoundsAppendAttributeCaption);
         _loc2_ = _loc4_.length - "%0".length;
         this.FPainterAppendAttributeCaption.SetTextFormat(FTextFormat,0,_loc2_);
         BoundsContextUnion(this.FBoundsAppendAttributeCaption);
      }
      
      protected function EvaluationPerform_AppendAttributes(param1:TEquipment) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:TBaseEquip = null;
         var _loc7_:String = null;
         BoundsAlignRight(this.FBoundsAppendAttributes,FBoundsOffset,SIZE_Padding_02);
         if(param1.RequirementLevel < 100)
         {
            if(param1.UpgradingBasisProperty.length > 0 && param1.UpgradingBasisProperty[0] != 0)
            {
               this.FPainterAppendAttributes.Text = this.GetPlusAttrValue(param1.BasisProperty[0],param1.UpgradingBasisProperty[0]);
            }
            else
            {
               this.FPainterAppendAttributes.Text = this.GetBaseAttrValue(param1.BasisProperty[0]);
            }
         }
         else
         {
            _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseEquip,param1.IDTemplate) as TBaseEquip;
            _loc7_ = "";
            _loc3_ = int(_loc6_.MainType.length);
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               if(param1.UpgradingBasisProperty.length > 0 && param1.UpgradingBasisProperty[_loc2_] != 0)
               {
                  _loc7_ += TUtilityLobby.GetBaseAttributeNameByType(_loc6_.MainType[_loc2_]) + this.GetPlusAttrValue(param1.BasisProperty[_loc2_],param1.UpgradingBasisProperty[_loc2_]);
               }
               else
               {
                  _loc7_ += TUtilityLobby.GetBaseAttributeNameByType(_loc6_.MainType[_loc2_]) + this.GetBaseAttrValue(param1.BasisProperty[_loc2_]);
               }
               _loc2_++;
            }
            this.FPainterAppendAttributes.Text = _loc7_;
         }
         this.FPainterAppendAttributes.Evaluate(this.FBoundsAppendAttributes);
         BoundsContextUnion(this.FBoundsAppendAttributes);
      }
      
      protected function EvaluationPerform_PartAttribute(param1:TEquipment) : void
      {
         this.FBoundsPartAttribute.Width = this.FDividingLinePartAttribute.width;
         this.FBoundsPartAttribute.Height = this.FDividingLinePartAttribute.height;
         BoundsAlignDown(this.FBoundsPartAttribute,FBoundsOffset,SIZE_Padding_02);
         this.FBoundsPartAttribute.X = 0;
         BoundsContextUnion(this.FBoundsPartAttribute);
      }
      
      protected function EvaluationPerform_DescCaption(param1:TEquipment) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         BoundsAlignDown(this.FBoundsDescCaption,FBoundsOffset,SIZE_Padding_02);
         ResetTextFormat();
         FTextFormat.color = COLOR_Context_Title;
         FTextFormat.leading = SIZE_TextFormat_leading;
         _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_Talisman_DescCaption);
         this.FPainterDescCaption.Text = TUtilityString.Format(_loc3_,param1.Description);
         this.FPainterDescCaption.Evaluate(this.FBoundsDescCaption);
         _loc2_ = _loc3_.length - "%0".length;
         this.FPainterDescCaption.SetTextFormat(FTextFormat,0,_loc2_);
         BoundsContextUnion(this.FBoundsDescCaption);
      }
      
      protected function EvaluationPerform_PartDescCaption(param1:TEquipment) : void
      {
         var _loc2_:int = 0;
         this.FBoundsPartDescCaption.Width = this.FDividingLinePartDescCaption.width;
         this.FBoundsPartDescCaption.Height = this.FDividingLinePartDescCaption.height;
         _loc2_ = this.FPainterDescCaption.NumLines * SIZE_TextFormat_leading;
         BoundsAlignDown(this.FBoundsPartDescCaption,FBoundsOffset,SIZE_Padding_02);
         BoundsContextUnion(this.FBoundsPartDescCaption);
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
            _loc9_ = param1.SuitData.SuitEffects.GetSuitEffectByIndex(_loc2_);
            if(_loc9_.Value.length > 0)
            {
               _loc7_ = this.FBoundsSuitAttributes[_loc2_];
               BoundsAlignDown(_loc7_,FBoundsOffset);
               FBoundsOffset = _loc7_;
               _loc8_ = this.FPainterSuitAttributes[_loc2_];
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
            }
            _loc2_++;
         }
      }
      
      protected function EvaluationPerform_PartSuit(param1:TEquipment) : void
      {
         this.FBoundsPartSuit.Width = this.FDividingLinePartSuit.width;
         this.FBoundsPartSuit.Height = this.FDividingLinePartSuit.height;
         BoundsAlignDown(this.FBoundsPartSuit,FBoundsOffset,SIZE_Padding_02);
         this.FBoundsPartSuit.X = 0;
         BoundsContextUnion(this.FBoundsPartSuit);
      }
      
      override protected function SketchingPerform_Context() : void
      {
      }
      
      protected function SketchingPerform_Caption() : void
      {
         FPainterCaption.RenderBounds(FBoundsCaption,TAlignment.HORIZONTAL_Left);
      }
      
      protected function SketchingPerform_UpgradingLevel() : void
      {
         this.FPainterUpgradingLevel.RenderBounds(this.FBoundsUpgradingLevel,TAlignment.HORIZONTAL_Left);
      }
      
      protected function SketchingPerform_RequirementLevel() : void
      {
         this.FPainterRequirementLevel.RenderBounds(this.FBoundsRequirementLevel,TAlignment.HORIZONTAL_Left);
      }
      
      protected function SketchingPerform_CategorySecond() : void
      {
         this.FPainterCategorySecond.RenderBounds(this.FBoundsCategorySecond,TAlignment.HORIZONTAL_Left);
      }
      
      protected function SketchingPerform_AppendAttributeCaption() : void
      {
         this.FPainterAppendAttributeCaption.RenderBounds(this.FBoundsAppendAttributeCaption,TAlignment.HORIZONTAL_Left);
      }
      
      protected function SketchingPerform_AppendAttributes() : void
      {
         this.FPainterAppendAttributes.RenderBounds(this.FBoundsAppendAttributes,TAlignment.HORIZONTAL_Left);
      }
      
      protected function SketchingPerform_SalePrice() : void
      {
         FPainterSalePrice.RenderBounds(FBoundsSalePrice,TAlignment.HORIZONTAL_Left);
      }
      
      override protected function RenderingPerform_Context(param1:TCoordinate) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TBounds = null;
         var _loc5_:TEquipment = null;
         var _loc6_:TPainterTextEffect = null;
         _loc5_ = FContext as TEquipment;
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
         this.FDividingLinePartCaption.x = FBoundsRendering.X + this.FBoundsPartCaption.X - FMarginLeft + 2;
         this.FDividingLinePartCaption.y = FBoundsRendering.Y + this.FBoundsPartCaption.Y;
         this.FPainterAppendAttributeCaption.X = FBoundsRendering.X + this.FBoundsAppendAttributeCaption.X;
         this.FPainterAppendAttributeCaption.Y = FBoundsRendering.Y + this.FBoundsAppendAttributeCaption.Y;
         this.FPainterAppendAttributes.X = FBoundsRendering.X + this.FBoundsAppendAttributes.X;
         this.FPainterAppendAttributes.Y = FBoundsRendering.Y + this.FBoundsAppendAttributes.Y;
         this.FDividingLinePartAttribute.x = FBoundsRendering.X + this.FBoundsPartAttribute.X - FMarginLeft + 2;
         this.FDividingLinePartAttribute.y = FBoundsRendering.Y + this.FBoundsPartAttribute.Y;
         this.FPainterDescCaption.X = FBoundsRendering.X + this.FBoundsDescCaption.X;
         this.FPainterDescCaption.Y = FBoundsRendering.Y + this.FBoundsDescCaption.Y;
         this.FDividingLinePartDescCaption.x = FBoundsRendering.X + this.FBoundsPartDescCaption.X - FMarginLeft + 2;
         this.FDividingLinePartDescCaption.y = FBoundsRendering.Y + this.FBoundsPartDescCaption.Y;
         if(_loc5_.SuitData.MaxCount != 0)
         {
            this.FPainterSuitCaption.X = FBoundsRendering.X + this.FBoundsSuitCaption.X;
            this.FPainterSuitCaption.Y = FBoundsRendering.Y + this.FBoundsSuitCaption.Y;
            _loc2_ = 0;
            while(_loc2_ < CAPACITY_SuitEffects)
            {
               _loc6_ = this.FPainterSuitAttributes[_loc2_];
               _loc4_ = this.FBoundsSuitAttributes[_loc2_];
               _loc6_.X = FBoundsRendering.X + _loc4_.X;
               _loc6_.Y = FBoundsRendering.Y + _loc4_.Y;
               _loc2_++;
            }
            this.FDividingLinePartSuit.x = FBoundsRendering.X + this.FBoundsPartSuit.X - FMarginLeft + SIZE_DividingLineOffset;
            this.FDividingLinePartSuit.y = FBoundsRendering.Y + this.FBoundsPartSuit.Y;
         }
         FPainterSalePrice.X = FBoundsRendering.X + FBoundsSalePrice.X;
         FPainterSalePrice.Y = FBoundsRendering.Y + FBoundsSalePrice.Y;
         if(_loc5_.TimingTime > 0)
         {
            FDividingLinePartTimingTime.x = FBoundsRendering.X + FBoundsPartTimingTime.X - FMarginLeft + SIZE_DividingLineOffset;
            FDividingLinePartTimingTime.y = FBoundsRendering.Y + FBoundsPartTimingTime.Y;
            FPainterTimingTime.X = FBoundsRendering.X + FBoundsTimingTime.X;
            FPainterTimingTime.Y = FBoundsRendering.Y + FBoundsTimingTime.Y;
         }
         this.FDividingLinePartCaption.width = SIZE_DividingLine_Max_Width;
         this.FDividingLinePartAttribute.width = SIZE_DividingLine_Max_Width;
         this.FDividingLinePartDescCaption.width = SIZE_DividingLine_Max_Width;
         FDividingLinePartTimingTime.width = SIZE_DividingLine_Max_Width;
      }
      
      private function GetLevelStringName(param1:int) : String
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = Math.floor(param1 / 10);
         _loc3_ = Math.floor(param1 % 10) + 1;
         return this.StringLevelVec[_loc2_] + TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_34),_loc3_);
      }
      
      private function GetBaseAttrValue(param1:int) : String
      {
         return TUtilityString.Format(FORMAT_AppendAttributes_02,param1);
      }
      
      private function GetPlusAttrValue(param1:int, param2:int) : String
      {
         return TUtilityString.Format(FORMAT_AppendAttributes_01,param1,param2);
      }
   }
}

