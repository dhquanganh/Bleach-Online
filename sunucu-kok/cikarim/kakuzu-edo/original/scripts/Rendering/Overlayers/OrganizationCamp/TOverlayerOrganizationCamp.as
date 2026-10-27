package Rendering.Overlayers.OrganizationCamp
{
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Processors.Game.Lobby.Utilities.*;
   import Rendering.Overlayers.*;
   import Rendering.Texts.*;
   import Resources.Constants.*;
   
   public class TOverlayerOrganizationCamp extends TOverlayer
   {
      
      protected static const PHYS_ATK_ADDITION:int = CONST_ORGANIZATION.PHYS_ATK_ADDITION;
      
      protected static const PHYS_DEF_ADDITION:int = CONST_ORGANIZATION.PHYS_DEF_ADDITION;
      
      protected static const MAG_DEF_ADDITION:int = CONST_ORGANIZATION.MAG_DEF_ADDITION;
      
      protected static const LIFE_ADDITION:int = CONST_ORGANIZATION.LIFE_ADDITION;
      
      protected static const SPEED_ADDITION:int = CONST_ORGANIZATION.SPEED_ADDITION;
      
      protected static const SIZE_OffsetY:uint = 4;
      
      protected static const COLOR_ContextCaption:uint = 4294967040;
      
      protected static const COLOR_ContextExplain:uint = 4284900966;
      
      protected static const COLOR_ContextAppendAttributes:uint = 4294967295;
      
      protected static const COLOR_ContextAppendNextAttributes:uint = 4278255360;
      
      public static const FORMAT_Caption:String = CONST_COMMON.STRING_ThickSquare;
      
      protected var FPainterCaption:TPainterTextEffect;
      
      protected var FPainterExplain:TPainterTextEffect;
      
      protected var FPainterAppendAttributesCaption:TPainterTextEffect;
      
      protected var FPainterAppendNextAttributesCaption:TPainterTextEffect;
      
      protected var FBoundsCaption:TBounds;
      
      protected var FBoundsExplain:TBounds;
      
      protected var FBoundsAppendAttributesCaption:TBounds;
      
      protected var FBoundsAppendNextAttributesCaption:TBounds;
      
      protected var FContextCaption:String;
      
      protected var FContextExplain:String;
      
      protected var FContextAppendAttributesCaption:String;
      
      protected var FContextAppendNextAttributesCaption:String;
      
      protected var FBoundsOffsetY:TBounds;
      
      protected var FSkillIndex:int;
      
      protected var FSkillLevel:int;
      
      protected var FSkillName:Vector.<String>;
      
      public function TOverlayerOrganizationCamp(param1:TUIComponent)
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TPainterTextEffect = null;
         var _loc5_:TBounds = null;
         super(param1);
         this.FPainterCaption = ConstructPainterTextEffect(COLOR_ContextCaption);
         this.FBoundsCaption = new TBounds();
         this.FPainterAppendAttributesCaption = ConstructPainterTextEffect(COLOR_ContextAppendAttributes);
         this.FBoundsAppendAttributesCaption = new TBounds();
         this.FPainterAppendNextAttributesCaption = ConstructPainterTextEffect(COLOR_ContextAppendNextAttributes);
         this.FBoundsAppendNextAttributesCaption = new TBounds();
         this.FPainterExplain = ConstructPainterTextEffect(COLOR_ContextExplain);
         this.FBoundsExplain = new TBounds();
      }
      
      override protected function ContextVerificate(param1:Object) : Boolean
      {
         return param1 is TOrganizationAddition;
      }
      
      override protected function ContextSynchronize() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:TOrganizationAddition = null;
         var _loc5_:TSkillConfig = null;
         var _loc6_:TResourceRepositoryBin = null;
         _loc4_ = FContext as TOrganizationAddition;
         this.FPainterCaption.Text = "";
         this.FContextCaption = "";
         this.FPainterAppendAttributesCaption.Text = "";
         this.FContextAppendAttributesCaption = "";
         this.FPainterAppendNextAttributesCaption.Text = "";
         this.FContextAppendNextAttributesCaption = "";
         this.FPainterExplain.Text = "";
         this.FContextExplain = "";
         this.FSkillName = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_05);
         this.FContextCaption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_06),this.FSkillLevel) + this.FSkillName[this.FSkillIndex];
         this.FContextExplain = "";
      }
      
      override protected function EvaluationPerform_Context() : void
      {
         this.EvaluationPerform_Caption();
         this.FBoundsOffsetY = this.FBoundsCaption;
         this.EvaluationPerform_ContextAppendAttributes();
         this.FBoundsOffsetY = this.FBoundsAppendAttributesCaption;
         this.EvaluationPerform_ContextAppendNextAttributes();
         this.FBoundsOffsetY = this.FBoundsAppendNextAttributesCaption;
         this.EvaluationPerform_Explain();
         this.FBoundsOffsetY = this.FBoundsExplain;
      }
      
      protected function EvaluationPerform_Caption() : void
      {
         BoundsAlignDown(this.FBoundsCaption);
         this.FPainterCaption.Text = TUtilityString.Format(FORMAT_Caption,this.FContextCaption);
         this.FPainterCaption.Evaluate(this.FBoundsCaption);
         BoundsContextUnion(this.FBoundsCaption);
      }
      
      protected function EvaluationPerform_ContextAppendAttributes() : void
      {
         BoundsAlignDown(this.FBoundsAppendAttributesCaption);
         this.FPainterAppendAttributesCaption.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_07),this.FSkillName[this.FSkillIndex],this.GetSkillAddValue(this.FSkillLevel)) + "\n";
         this.FPainterAppendAttributesCaption.Evaluate(this.FBoundsAppendAttributesCaption);
         BoundsContextUnion(this.FBoundsAppendAttributesCaption);
      }
      
      protected function EvaluationPerform_ContextAppendNextAttributes() : void
      {
         BoundsAlignDown(this.FBoundsAppendNextAttributesCaption);
         var _loc1_:TBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_OrganizationAddition);
         if(this.FSkillLevel + 1 >= _loc1_.Count)
         {
            this.FPainterAppendNextAttributesCaption.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_03) + "\n";
         }
         else
         {
            this.FPainterAppendNextAttributesCaption.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_08),this.FSkillName[this.FSkillIndex],this.GetSkillAddValue(this.FSkillLevel + 1)) + "\n";
         }
         this.FPainterAppendNextAttributesCaption.Evaluate(this.FBoundsAppendNextAttributesCaption);
         BoundsContextUnion(this.FBoundsAppendNextAttributesCaption);
      }
      
      protected function EvaluationPerform_Explain() : void
      {
         var _loc1_:TSystemLanguage = null;
         var _loc2_:uint = 0;
         var _loc3_:Vector.<uint> = Vector.<uint>([70180004,70180005,70180006,70180007,70180008]);
         var _loc4_:Vector.<uint> = Vector.<uint>([6,11,21,31,51]);
         if(this.FSkillLevel >= 0 && this.FSkillLevel < _loc4_[0])
         {
            _loc2_ = _loc3_[0];
         }
         else if(this.FSkillLevel >= _loc4_[0] && this.FSkillLevel < _loc4_[1])
         {
            _loc2_ = _loc3_[1];
         }
         else if(this.FSkillLevel >= _loc4_[1] && this.FSkillLevel < _loc4_[2])
         {
            _loc2_ = _loc3_[2];
         }
         else if(this.FSkillLevel >= _loc4_[2] && this.FSkillLevel < _loc4_[3])
         {
            _loc2_ = _loc3_[3];
         }
         else if(this.FSkillLevel >= _loc4_[3] && this.FSkillLevel <= _loc4_[4])
         {
            _loc2_ = _loc3_[4];
         }
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SystemLanguage,_loc2_) as TSystemLanguage;
         BoundsAlignDown(this.FBoundsExplain);
         this.FPainterExplain.Text = _loc1_.Desc;
         this.FPainterExplain.Evaluate(this.FBoundsExplain);
         BoundsContextUnion(this.FBoundsExplain);
      }
      
      override protected function SketchingPerform_Context() : void
      {
         this.SketchingPerform_Caption();
         this.SketchingPerform_AppendAttributes();
         this.SketchingPerform_AppendNextAttributes();
         this.SketchingPerform_Explain();
      }
      
      protected function SketchingPerform_Caption() : void
      {
         this.FBoundsCaption.Width = FBoundsContext.Width;
         this.FPainterCaption.RenderBounds(this.FBoundsCaption,TAlignment.HORIZONTAL_Center);
      }
      
      protected function SketchingPerform_AppendAttributes() : void
      {
         this.FPainterAppendAttributesCaption.RenderBounds(this.FBoundsAppendAttributesCaption,TAlignment.HORIZONTAL_Center);
      }
      
      protected function SketchingPerform_AppendNextAttributes() : void
      {
         this.FPainterAppendNextAttributesCaption.RenderBounds(this.FBoundsAppendNextAttributesCaption,TAlignment.HORIZONTAL_Center);
      }
      
      protected function SketchingPerform_Explain() : void
      {
         this.FPainterExplain.RenderBounds(this.FBoundsExplain,TAlignment.HORIZONTAL_Center);
      }
      
      override protected function RenderingPerform_Context(param1:TCoordinate) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TBounds = null;
         var _loc7_:TPainterTextEffect = null;
         _loc6_ = new TBounds();
         FBoundsRendering.X = FMarginLeft;
         FBoundsRendering.Y = FMarginTop;
         this.FPainterCaption.x = FBoundsRendering.X;
         this.FPainterCaption.y = FBoundsRendering.Y;
         this.FPainterAppendAttributesCaption.x = FBoundsRendering.X;
         this.FPainterAppendAttributesCaption.y = FBoundsRendering.Y + this.FBoundsAppendAttributesCaption.Y;
         this.FPainterAppendNextAttributesCaption.x = FBoundsRendering.X;
         this.FPainterAppendNextAttributesCaption.y = FBoundsRendering.Y + this.FBoundsAppendNextAttributesCaption.Y;
         this.FPainterExplain.x = FBoundsRendering.X;
         this.FPainterExplain.y = FBoundsRendering.Y + this.FBoundsExplain.Y;
      }
      
      public function get SkillIndex() : int
      {
         return this.FSkillIndex;
      }
      
      public function set SkillIndex(param1:int) : void
      {
         this.FSkillIndex = param1;
      }
      
      public function get SkillLevel() : int
      {
         return this.FSkillLevel;
      }
      
      public function set SkillLevel(param1:int) : void
      {
         this.FSkillLevel = param1;
      }
      
      public function GetSkillAddValue(param1:int) : int
      {
         var _loc4_:int = 0;
         var _loc2_:TBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_OrganizationAddition);
         var _loc3_:TOrganizationAddition = _loc2_.GetDatebaseByIdentifier(CONST_ORGANIZATION.Organization_Addition_Base + param1) as TOrganizationAddition;
         switch(this.FSkillIndex + 1)
         {
            case PHYS_ATK_ADDITION:
               _loc4_ = int(_loc3_.AtkAddition);
               break;
            case PHYS_DEF_ADDITION:
               _loc4_ = int(_loc3_.PhysDefAddition);
               break;
            case MAG_DEF_ADDITION:
               _loc4_ = int(_loc3_.MagDefAddition);
               break;
            case LIFE_ADDITION:
               _loc4_ = int(_loc3_.LifeAddition);
               break;
            case SPEED_ADDITION:
               _loc4_ = int(_loc3_.SpeedAddition);
         }
         return _loc4_;
      }
   }
}

