package Rendering.Overlayers.Inventories
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Rendering.Overlayers.*;
   import Rendering.Texts.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.text.*;
   
   public class TOverlayerCrashJade extends TOverlayerInventory
   {
      
      protected static const SIZE_DividingLine_Max_Width:uint = 293;
      
      protected static const SIZE_DividingLine_Min_Width:uint = 270;
      
      protected static const SIZE_TextFormat_leading:uint = 2;
      
      protected static const SIZE_WordWrapWidth:uint = 100;
      
      protected static const SIZE_Padding_01:uint = 5;
      
      protected static const SIZE_Padding_03:uint = 10;
      
      protected static const LevelFormat:String = "LV.%0";
      
      protected static const AttributeFormat:String = "%0 +%1";
      
      protected var FPainterRequirementLevel:TPainterTextEffect;
      
      protected var FPainterDescCaption:TPainterTextEffect;
      
      protected var FPainterJadeTypeText:TPainterTextEffect;
      
      protected var FPainterDesc:TPainterHtmlTextEffect;
      
      protected var FBoundsRequirementLevel:TBounds;
      
      protected var FBoundsJadeTypeText:TBounds;
      
      protected var FBoundsDescCaption:TBounds;
      
      protected var FBoundsDesc:TBounds;
      
      protected var FPainterLevel:TPainterTextEffect;
      
      protected var FPainterAddAttribute:Vector.<TPainterTextEffect>;
      
      protected var FPainterNextAddAttribute:Vector.<TPainterTextEffect>;
      
      protected var FPainterExp:TPainterTextEffect;
      
      protected var FBoundsLevel:TBounds;
      
      protected var FBoundsAddAttribute:Vector.<TBounds>;
      
      protected var FBoundsNextAddAttribute:Vector.<TBounds>;
      
      protected var FBoundsExp:TBounds;
      
      protected var FContextLevel:int;
      
      protected var FContextExp:int;
      
      public function TOverlayerCrashJade(param1:TUIComponent)
      {
         super(param1);
         this.FPainterRequirementLevel = ConstructPainterTextEffect(COLOR_Context_White);
         this.FBoundsRequirementLevel = new TBounds();
         this.FPainterJadeTypeText = ConstructPainterTextEffect();
         this.FBoundsJadeTypeText = new TBounds();
         this.FPainterDescCaption = ConstructPainterTextEffect(COLOR_Context_Title);
         this.FBoundsDescCaption = new TBounds();
         this.FPainterDesc = this.ConstructPainterHtmlTextEffect(COLOR_Context_Explanation);
         this.FBoundsDesc = new TBounds();
         this.FPainterLevel = ConstructPainterTextEffect(COLOR_Context_White);
         this.FBoundsLevel = new TBounds();
         this.FPainterAddAttribute = new Vector.<TPainterTextEffect>();
         this.FPainterNextAddAttribute = new Vector.<TPainterTextEffect>();
         this.FBoundsAddAttribute = new Vector.<TBounds>();
         this.FBoundsNextAddAttribute = new Vector.<TBounds>();
         this.FPainterExp = ConstructPainterTextEffect(COLOR_Context_00);
         this.FBoundsExp = new TBounds();
         FMarginLeft = 15;
         FMarginTop = 15;
         FMarginRight = 15;
         FMarginBottom = 15;
      }
      
      override protected function ConstructPainterHtmlTextEffect(param1:uint = 4294958161) : TPainterHtmlTextEffect
      {
         var _loc2_:TPainterHtmlTextEffect = null;
         _loc2_ = super.ConstructPainterHtmlTextEffect(param1);
         _loc2_.Multilineable = true;
         return _loc2_;
      }
      
      override protected function ContextVerificate(param1:Object) : Boolean
      {
         return param1 is TCrashJade;
      }
      
      override protected function ContextModified() : Boolean
      {
         return true;
      }
      
      override protected function ContextSynchronize() : void
      {
         var _loc1_:TCrashJade = null;
         _loc1_ = FContext as TCrashJade;
         this.ConstructTips(_loc1_);
         FContextIdentifier = _loc1_.Identifier;
         FContextIDTemplate = _loc1_.IDTemplate;
         FContextTimingTime = _loc1_.TimingTime;
         this.FContextLevel = _loc1_.Level;
         this.FContextExp = _loc1_.Exp;
         FDividingLinePartTimingTime.width = SIZE_DividingLine_Min_Width;
         super.ContextSynchronize();
      }
      
      protected function ConstructTips(param1:TCrashJade) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TPainterTextEffect = null;
         var _loc5_:TBounds = null;
         _loc3_ = int(param1.AddAttributeType.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(_loc2_ >= this.FPainterAddAttribute.length)
            {
               _loc4_ = ConstructPainterTextEffect(COLOR_Context_Title);
               _loc5_ = new TBounds();
               this.FPainterAddAttribute.push(_loc4_);
               this.FBoundsAddAttribute.push(_loc5_);
               _loc4_ = ConstructPainterTextEffect(COLOR_Context_Title);
               _loc5_ = new TBounds();
               this.FPainterNextAddAttribute.push(_loc4_);
               this.FBoundsNextAddAttribute.push(_loc5_);
            }
            this.FPainterAddAttribute[_loc2_].Visible = true;
            this.FPainterNextAddAttribute[_loc2_].Visible = true;
            _loc2_++;
         }
         _loc3_ = int(this.FPainterAddAttribute.length);
         _loc2_ = int(param1.AddAttributeType.length);
         while(_loc2_ < _loc3_)
         {
            this.FPainterAddAttribute[_loc2_].Visible = false;
            this.FPainterNextAddAttribute[_loc2_].Visible = false;
            _loc2_++;
         }
      }
      
      override protected function EvaluationPerform_Context() : void
      {
         var _loc1_:TCrashJade = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc1_ = FContext as TCrashJade;
         this.EvaluationPerform_Caption(_loc1_);
         FBoundsOffset = FBoundsCaption;
         this.EvaluationPerform_Level(_loc1_);
         FBoundsOffset = this.FBoundsLevel;
         this.EvaluationPerform_JadeTypeText(_loc1_);
         FBoundsOffset = this.FBoundsJadeTypeText;
         _loc3_ = _loc1_.AddAttributeType.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.EvaluationPerform_Attribute(_loc1_.AddAttributeType[_loc2_],_loc1_.AddAttributeValue[_loc2_],_loc2_);
            if(_loc1_.NextLevelID != 0)
            {
               this.EvaluationPerform_NextAddAttribute(_loc1_.AddAttributeType[_loc2_],_loc1_.AddValueTxt[_loc2_],_loc2_);
            }
            _loc2_++;
         }
         this.EvaluationPerform_EXP(_loc1_);
         FBoundsOffset = this.FBoundsExp;
         this.EvaluationPerform_SalePrice(_loc1_);
         FBoundsOffset = FBoundsSalePrice;
         if(_loc1_.TimingTime > 0)
         {
            FPainterTimingTime.Visible = true;
            FDividingLinePartTimingTime.visible = true;
            EvaluationPerform_PartTimingTime(null);
            FBoundsOffset = FBoundsPartTimingTime;
            EvaluationPerform_TimingTime(_loc1_);
            FBoundsOffset = FBoundsTimingTime;
         }
         else
         {
            FPainterTimingTime.Visible = false;
            FDividingLinePartTimingTime.visible = false;
         }
      }
      
      override protected function EvaluationPerform_Caption(param1:TInventory) : void
      {
         var _loc2_:String = null;
         BoundsAlignDown(FBoundsCaption,null,SIZE_Padding_01);
         _loc2_ = param1.Name;
         FPainterCaption.Text = _loc2_;
         FPainterCaption.Font.Size = SIZE_Context_00;
         FPainterCaption.Font.Color = QUALITYCOLOR_INVENTORY_INDEX[param1.Quality];
         FBoundsCaption.Y -= 5;
         FPainterCaption.Evaluate(FBoundsCaption);
         BoundsContextUnion(FBoundsCaption);
      }
      
      protected function EvaluationPerform_Level(param1:TInventory) : void
      {
         var _loc2_:String = null;
         var _loc3_:TCrashJade = null;
         _loc3_ = param1 as TCrashJade;
         BoundsAlignRight(this.FBoundsLevel,null,SIZE_Padding_01);
         _loc2_ = TUtilityString.Format(LevelFormat,_loc3_.Level);
         this.FPainterLevel.Text = _loc2_;
         this.FPainterLevel.Font.Size = SIZE_Context_00;
         this.FPainterLevel.Font.Color = COLOR_Context_Attributes;
         this.FBoundsLevel.Y = 0;
         this.FPainterLevel.Evaluate(this.FBoundsLevel);
         BoundsContextUnion(this.FBoundsLevel);
      }
      
      protected function EvaluationPerform_JadeTypeText(param1:TInventory) : void
      {
         var _loc2_:TCrashJade = null;
         _loc2_ = param1 as TCrashJade;
         BoundsAlignDown(this.FBoundsJadeTypeText,FBoundsOffset,SIZE_Padding_01);
         this.FPainterJadeTypeText.Text = _loc2_.JadeTypeText;
         ResetTextFormat();
         FTextFormat.size = this.FPainterRequirementLevel.Font.Size;
         FTextFormat.color = CONST_COMMON.QUALITYCOLOR_INDEX[_loc2_.Quality];
         this.FBoundsJadeTypeText.X = 0;
         this.FPainterJadeTypeText.Evaluate(this.FBoundsJadeTypeText);
         this.FPainterJadeTypeText.SetTextFormat(FTextFormat);
         BoundsContextUnion(this.FBoundsJadeTypeText);
         FBoundsOffset = this.FBoundsJadeTypeText;
      }
      
      protected function EvaluationPerform_Attribute(param1:int, param2:Number, param3:int) : void
      {
         var _loc4_:TBounds = null;
         var _loc5_:TPainterTextEffect = null;
         _loc4_ = this.FBoundsAddAttribute[param3];
         _loc5_ = this.FPainterAddAttribute[param3];
         BoundsAlignDown(_loc4_,FBoundsOffset,SIZE_Padding_01);
         if(param1 == 0)
         {
            _loc5_.Text = "";
         }
         else
         {
            _loc5_.Text = TUtilityString.Format(AttributeFormat,TUtilityLobby.GetAttributeName(param1),param2 <= 1 ? Number(param2 * 100).toFixed(2) + "%" : param2);
         }
         ResetTextFormat();
         FTextFormat.size = this.FPainterRequirementLevel.Font.Size;
         FTextFormat.color = COLOR_Context_Attributes;
         _loc4_.X = 0;
         _loc5_.Evaluate(_loc4_);
         _loc5_.SetTextFormat(FTextFormat);
         BoundsContextUnion(_loc4_);
         FBoundsOffset = _loc4_;
      }
      
      protected function EvaluationPerform_NextAddAttribute(param1:int, param2:Number, param3:uint) : void
      {
         var _loc4_:TBounds = null;
         var _loc5_:TPainterTextEffect = null;
         _loc4_ = this.FBoundsNextAddAttribute[param3];
         _loc5_ = this.FPainterNextAddAttribute[param3];
         BoundsAlignDown(_loc4_,FBoundsOffset,SIZE_Padding_01);
         if(param1 == 0)
         {
            _loc5_.Text = "";
         }
         else
         {
            _loc5_.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_41),param2 <= 1 ? Number(param2 * 100).toFixed(2) + "%" : param2);
         }
         ResetTextFormat();
         FTextFormat.size = this.FPainterRequirementLevel.Font.Size;
         FTextFormat.color = COLOR_Context_Attributes;
         _loc4_.X = 0;
         _loc5_.Evaluate(_loc4_);
         _loc5_.SetTextFormat(FTextFormat);
         BoundsContextUnion(_loc4_);
         FBoundsOffset = _loc4_;
      }
      
      protected function EvaluationPerform_EXP(param1:TCrashJade) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:String = null;
         BoundsAlignDown(this.FBoundsExp,FBoundsOffset,SIZE_Padding_01);
         if(param1.NextLevelID != 0)
         {
            _loc4_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_39),param1.Exp,param1.LevelUpExp);
         }
         else if(param1.AddAttributeType.length == 0)
         {
            _loc4_ = "";
         }
         else
         {
            _loc4_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_40);
         }
         this.FPainterExp.Text = _loc4_;
         ResetTextFormat();
         FTextFormat.size = this.FPainterExp.Font.Size;
         FTextFormat.color = COLOR_Context_Title;
         this.FBoundsExp.X = 0;
         this.FPainterExp.Evaluate(this.FBoundsExp);
         if(param1.NextLevelID != 0)
         {
            _loc2_ = _loc4_.indexOf(":") + 1;
            this.FPainterExp.SetTextFormat(FTextFormat,0,_loc2_);
         }
         else
         {
            this.FPainterExp.SetTextFormat(FTextFormat);
         }
         BoundsContextUnion(this.FBoundsExp);
      }
      
      protected function EvaluationPerform_RequirementLevel(param1:TCrashJade) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         BoundsAlignDown(this.FBoundsRequirementLevel,FBoundsOffset,SIZE_Padding_01);
         _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_APPLIANCE_RequirementLevel);
         _loc2_ = _loc3_.length - TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_APPLIANCE_01).length;
         this.FPainterRequirementLevel.Text = TUtilityString.Format(_loc3_,param1.RequirementLevel);
         ResetTextFormat();
         FTextFormat.size = this.FPainterRequirementLevel.Font.Size;
         FTextFormat.color = COLOR_Context_Title;
         this.FPainterRequirementLevel.Evaluate(this.FBoundsRequirementLevel);
         this.FPainterRequirementLevel.SetTextFormat(FTextFormat,0,_loc2_);
         BoundsContextUnion(this.FBoundsRequirementLevel);
      }
      
      protected function EvaluationPerform_DescCaption(param1:TCrashJade) : void
      {
         BoundsAlignDown(this.FBoundsDescCaption,FBoundsOffset,SIZE_Padding_01);
         this.FPainterDescCaption.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_APPLIANCE_DescCaption);
         this.FPainterDescCaption.Evaluate(this.FBoundsDescCaption);
         BoundsContextUnion(this.FBoundsDescCaption);
      }
      
      protected function EvaluationPerform_Desc(param1:TAppliance) : void
      {
         BoundsAlignRight(this.FBoundsDesc,FBoundsOffset);
         ResetTextFormat();
         FTextFormat.leading = SIZE_TextFormat_leading;
         this.FPainterDesc.Text = param1.Description;
         this.FPainterDesc.Evaluate(this.FBoundsDesc);
         BoundsContextUnion(this.FBoundsDesc);
      }
      
      override protected function EvaluationPerform_SalePrice(param1:TInventory) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         BoundsAlignDown(FBoundsSalePrice,FBoundsOffset,SIZE_Padding_01);
         _loc3_ = int(param1.SellValue);
         _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_INVENTORY_SalePrice);
         _loc4_ = _loc5_.length - "%0".length;
         FPainterSalePrice.Text = TUtilityString.Format(_loc5_,_loc3_);
         ResetTextFormat();
         FTextFormat.color = COLOR_Context_Title;
         FBoundsSalePrice.X = 0;
         FPainterSalePrice.Evaluate(FBoundsSalePrice);
         FPainterSalePrice.SetTextFormat(FTextFormat,0,_loc4_);
         BoundsContextUnion(FBoundsSalePrice);
      }
      
      override protected function SketchingPerform_Context() : void
      {
         var _loc1_:TCrashJade = null;
         _loc1_ = FContext as TCrashJade;
      }
      
      protected function SketchingPerform_Caption() : void
      {
         FPainterCaption.RenderBounds(FBoundsCaption,TAlignment.HORIZONTAL_Left);
      }
      
      protected function SketchingPerform_RequirementLevel() : void
      {
         this.FPainterRequirementLevel.RenderBounds(this.FBoundsRequirementLevel,TAlignment.HORIZONTAL_Left);
      }
      
      protected function SketchingPerform_DescCaption() : void
      {
         this.FPainterDescCaption.RenderBounds(this.FBoundsDescCaption,TAlignment.HORIZONTAL_Left);
      }
      
      protected function SketchingPerform_Desc() : void
      {
         this.FPainterDesc.RenderBounds(this.FBoundsDesc,TAlignment.HORIZONTAL_Left);
      }
      
      protected function SketchingPerform_SalePrice() : void
      {
         FPainterSalePrice.RenderBounds(FBoundsSalePrice,TAlignment.HORIZONTAL_Left);
      }
      
      override protected function RenderingPerform_Context(param1:TCoordinate) : void
      {
         var _loc2_:TCrashJade = null;
         var _loc3_:TPainterTextEffect = null;
         var _loc4_:TBounds = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc2_ = FContext as TCrashJade;
         FBoundsRendering.X = FMarginLeft;
         FBoundsRendering.Y = FMarginTop;
         FPainterCaption.X = FBoundsRendering.X + FBoundsCaption.X;
         FPainterCaption.Y = FBoundsRendering.Y + FBoundsCaption.Y;
         this.FPainterLevel.X = FBoundsRendering.X + this.FBoundsLevel.X;
         this.FPainterLevel.Y = FBoundsRendering.Y + this.FBoundsLevel.Y;
         this.FPainterJadeTypeText.X = FBoundsRendering.X + this.FBoundsJadeTypeText.X;
         this.FPainterJadeTypeText.Y = FBoundsRendering.Y + this.FBoundsJadeTypeText.Y;
         _loc6_ = _loc2_.AddAttributeType.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = this.FBoundsAddAttribute[_loc5_];
            _loc3_ = this.FPainterAddAttribute[_loc5_];
            _loc3_.X = FBoundsRendering.X + _loc4_.X;
            _loc3_.Y = FBoundsRendering.Y + _loc4_.Y;
            _loc4_ = this.FBoundsNextAddAttribute[_loc5_];
            _loc3_ = this.FPainterNextAddAttribute[_loc5_];
            _loc3_.X = FBoundsRendering.X + _loc4_.X;
            _loc3_.Y = FBoundsRendering.Y + _loc4_.Y;
            if(_loc2_.NextLevelID != 0)
            {
               _loc3_.Visible = true;
            }
            else
            {
               _loc3_.Visible = false;
            }
            _loc5_++;
         }
         this.FPainterExp.X = FBoundsRendering.X + this.FBoundsExp.X;
         this.FPainterExp.Y = FBoundsRendering.Y + this.FBoundsExp.Y;
         FPainterSalePrice.X = FBoundsRendering.X + FBoundsSalePrice.X;
         FPainterSalePrice.Y = FBoundsRendering.Y + FBoundsSalePrice.Y;
         if(_loc2_.TimingTime > 0)
         {
            FDividingLinePartTimingTime.x = FBoundsRendering.X + FBoundsPartTimingTime.X - FMarginLeft + SIZE_DividingLineOffset;
            FDividingLinePartTimingTime.y = FBoundsRendering.Y + FBoundsPartTimingTime.Y;
            FPainterTimingTime.X = FBoundsRendering.X + FBoundsTimingTime.X;
            FPainterTimingTime.Y = FBoundsRendering.Y + FBoundsTimingTime.Y;
         }
         FDividingLinePartTimingTime.width = SIZE_DividingLine_Max_Width;
      }
   }
}

