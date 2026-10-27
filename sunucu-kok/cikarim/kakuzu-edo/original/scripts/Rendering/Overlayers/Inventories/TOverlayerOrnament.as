package Rendering.Overlayers.Inventories
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.TArticle;
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
   
   public class TOverlayerOrnament extends TOverlayerInventory
   {
      
      protected static const SIZE_WordWrapWidth:uint = 130;
      
      protected static const CAPACITY_AppendAttributes:uint = 3;
      
      protected static const CAPACITY_SuitEffects:uint = 3;
      
      protected static const SIZE_DividingLine_Max_Width:uint = 250;
      
      protected static const SIZE_DividingLine_Min_Width:uint = 245;
      
      protected static const SIZE_TextFormat_leading:uint = 4;
      
      protected static const BASEATTRIBUTENAMES:Vector.<uint> = CONST_COMMON.BASEATTRIBUTENAMES;
      
      protected static const FORMAT_UpgradingLevel:String = STRING_COMMON.FORMAT_01;
      
      protected var FPainterUpgradingLevel:TPainterTextEffect;
      
      protected var FPainterRequirementLevel:TPainterTextEffect;
      
      protected var FPainterCategorySecond:TPainterTextEffect;
      
      protected var FPainterRequirementCareer:TPainterTextEffect;
      
      protected var FPainterBasisProperty:TPainterTextEffect;
      
      protected var FPainterSuitCaption:TPainterTextEffect;
      
      protected var FPainterSuitAttributes:Vector.<TPainterTextEffect>;
      
      protected var FBoundsUpgradingLevel:TBounds;
      
      protected var FBoundsRequirementLevel:TBounds;
      
      protected var FBoundsCategorySecond:TBounds;
      
      protected var FBoundsRequirementCareer:TBounds;
      
      protected var FBoundsBasisProperty:TBounds;
      
      protected var FBoundsSuitCaption:TBounds;
      
      protected var FBoundsSuitAttributes:Vector.<TBounds>;
      
      protected var FDividingLinePartCaption:Bitmap;
      
      protected var FDividingLinePartAttribute:Bitmap;
      
      protected var FDividingLinePartSuit:Bitmap;
      
      protected var FBoundsPartCaption:TBounds;
      
      protected var FBoundsPartAttribute:TBounds;
      
      protected var FBoundsPartSuit:TBounds;
      
      protected var FContextUpgradingLevel:uint;
      
      protected var FContextAttributeCount:uint;
      
      protected var FAppendAttributes:Vector.<uint>;
      
      protected var FContextSuitCount:uint;
      
      public function TOverlayerOrnament(param1:TUIComponent)
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
         this.FDividingLinePartCaption = new Bitmap();
         this.FDividingLinePartAttribute = new Bitmap();
         this.FDividingLinePartSuit = new Bitmap();
         addChild(this.FDividingLinePartCaption);
         addChild(this.FDividingLinePartAttribute);
         addChild(this.FDividingLinePartSuit);
         this.FBoundsPartCaption = new TBounds();
         this.FBoundsPartAttribute = new TBounds();
         this.FBoundsPartSuit = new TBounds();
         FTextFormatCaptionA = new TextFormat();
         FTextFormatCaptionB = new TextFormat();
         this.FAppendAttributes = new Vector.<uint>(CAPACITY_AppendAttributes);
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
         this.FDividingLinePartSuit.bitmapData = FDividingLine;
         super.ResourcesPerform_UIDispatch();
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
         _loc3_ = FContextIdentifier != _loc5_.Identifier || FContextIDTemplate != _loc5_.IDTemplate || this.FContextUpgradingLevel != _loc5_.UpgradingLevel || this.FContextAttributeCount != _loc5_.AppendAttributes.Count || this.FContextSuitCount != _loc5_.SuitCount || FContextTimingTime != _loc5_.TimingTime;
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
         this.FDividingLinePartCaption.width = SIZE_DividingLine_Min_Width;
         this.FDividingLinePartAttribute.width = SIZE_DividingLine_Min_Width;
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
         _loc3_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRINGS_OrnamentsCaption)[param1.CategorySecond - 11];
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
         this.FPainterSuitCaption.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_INVENTORY_BasisProperty_02),_loc2_,param1.SuitCount,2);
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
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:TBounds = null;
         var _loc10_:TPainterTextEffect = null;
         var _loc11_:TSuitEffect = null;
         var _loc12_:uint = 0;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:TArticle = null;
         var _loc16_:Vector.<uint> = null;
         var _loc17_:Vector.<String> = null;
         _loc16_ = this.GetSuiInventoriesID(param1);
         _loc7_ = int(_loc16_.length);
         _loc17_ = new Vector.<String>(_loc7_);
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc15_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc16_[_loc6_]) as TArticle;
            _loc17_[_loc6_] = _loc15_.Name;
            _loc6_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 3)
         {
            _loc9_ = this.FBoundsSuitAttributes[_loc2_];
            BoundsAlignDown(_loc9_,FBoundsOffset);
            FBoundsOffset = _loc9_;
            _loc10_ = this.FPainterSuitAttributes[_loc2_];
            if(_loc2_ == 2)
            {
               _loc11_ = param1.SuitData.SuitEffects.GetSuitEffectByIndex(0);
               _loc12_ = _loc11_.SuitQuantity;
               _loc13_ = "";
               _loc5_ = int(_loc11_.Category.length);
               _loc4_ = 0;
               while(_loc4_ < _loc5_)
               {
                  if(_loc11_.Percentage[_loc4_] == 1)
                  {
                     _loc14_ = String((parseFloat(_loc11_.Value[_loc4_]) * 100).toFixed(0)) + "%";
                  }
                  else
                  {
                     _loc14_ = _loc11_.Value[_loc4_];
                  }
                  _loc8_ = BASEATTRIBUTENAMES.indexOf(_loc11_.Category[_loc4_]);
                  _loc13_ += TUtilityLobby.GetBaseAttributeNameByIndex(_loc8_) + "+" + _loc14_ + "   ";
                  _loc4_++;
               }
               _loc10_.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_INVENTORY_Suit_01),_loc12_,_loc13_);
               if(param1.SuitCount >= 2)
               {
                  _loc10_.Font.Color = COLOR_Context_White;
               }
               else
               {
                  _loc10_.Font.Color = COLOR_Context_Invalid;
               }
            }
            else
            {
               _loc10_.Text = _loc17_[_loc2_];
            }
            _loc10_.Evaluate(_loc9_);
            BoundsContextUnion(_loc9_);
            _loc2_++;
         }
      }
      
      protected function GetSuiInventoriesID(param1:TEquipment) : Vector.<uint>
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:TEquipment = null;
         var _loc6_:TBins = null;
         var _loc7_:TBaseEquip = null;
         var _loc8_:Vector.<uint> = null;
         _loc8_ = new Vector.<uint>();
         _loc6_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BaseEquip);
         _loc3_ = _loc6_.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc7_ = _loc6_.GetDatebaseByIndex(_loc2_) as TBaseEquip;
            if(_loc7_.SuitId == param1.SuitID)
            {
               _loc8_.push(_loc7_.Identifier);
            }
            _loc2_++;
         }
         return _loc8_;
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
         FDividingLinePartTimingTime.width = SIZE_DividingLine_Max_Width;
      }
   }
}

