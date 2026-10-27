package Rendering.Overlayers.GeneralStar
{
   import Foundation.Common.*;
   import Foundation.Fonts.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.GeneralStar.*;
   import Processors.Game.Lobby.Utilities.*;
   import Rendering.Overlayers.*;
   import Rendering.Texts.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   
   public class TOverlayerGeneralStar extends TOverlayer
   {
      
      protected static const SIZE_OffsetY:uint = 4;
      
      protected static const COLOR_ContextCaption:uint = 4294967040;
      
      protected static const COLOR_ContextBigDipper:uint = 4294967295;
      
      protected static const COLOR_ContextAppendAttributes:uint = 4284808960;
      
      protected static const COLOR_ContextSkillName:uint = 4294953095;
      
      protected static const COLOR_ContextSkills:Vector.<uint> = Vector.<uint>([4294967295,4294953095,4294967295]);
      
      protected static const COLOR_ContextNeedSouls:Vector.<uint> = Vector.<uint>([4294967295,4294967040,4294967295]);
      
      protected static const CAPACITY_ContextSkills:uint = COLOR_ContextSkills.length;
      
      protected static const CAPACITY_NeedSouls:uint = COLOR_ContextNeedSouls.length;
      
      public static const FORMAT_Caption:String = CONST_COMMON.STRING_ThickSquare;
      
      public static const FORMAT_SkillName:String = CONST_COMMON.STRING_ThinSquare;
      
      protected var FPainterCaption:TPainterTextEffect;
      
      protected var FPainterBigDipper:TPainterTextEffect;
      
      protected var FPainterAppendAttributesCaption:TPainterTextEffect;
      
      protected var FPainterSkillName:TPainterTextEffect;
      
      protected var FPainterSkillDesc:TPainterHtmlTextEffect;
      
      protected var FPainterNeedSouls:Vector.<TPainterTextEffect>;
      
      protected var FBoundsCaption:TBounds;
      
      protected var FBoundsBigDipper:TBounds;
      
      protected var FBoundsAppendAttributesCaption:TBounds;
      
      protected var FBoundsSkillName:TBounds;
      
      protected var FBoundsSkillDesc:TBounds;
      
      protected var FBoundsNeedSoulsCaption:Vector.<TBounds>;
      
      protected var FContextCaption:String;
      
      protected var FContextBigDipper:String;
      
      protected var FContextAppendAttributesCaption:String;
      
      protected var FContextSkillName:String;
      
      protected var FContextSkillDesc:String;
      
      protected var FContextNeedSouls:Vector.<String>;
      
      protected var FBoundsOffsetY:TBounds;
      
      protected var FIsSkill:uint;
      
      public function TOverlayerGeneralStar(param1:TUIComponent)
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TPainterTextEffect = null;
         var _loc5_:TPainterHtmlTextEffect = null;
         var _loc6_:TBounds = null;
         super(param1);
         this.FPainterCaption = ConstructPainterTextEffect(COLOR_ContextCaption);
         this.FBoundsCaption = new TBounds();
         this.FPainterBigDipper = ConstructPainterTextEffect(COLOR_ContextBigDipper);
         this.FBoundsBigDipper = new TBounds();
         this.FPainterAppendAttributesCaption = ConstructPainterTextEffect(COLOR_ContextAppendAttributes);
         this.FBoundsAppendAttributesCaption = new TBounds();
         this.FContextAppendAttributesCaption = "";
         this.FPainterSkillName = ConstructPainterTextEffect(COLOR_ContextSkillName);
         this.FBoundsSkillName = new TBounds();
         this.FContextSkillName = "";
         this.FPainterSkillDesc = this.ConstructPainterHtmlTextEffect();
         this.FBoundsSkillDesc = new TBounds();
         this.FContextSkillDesc = "";
         _loc3_ = int(CAPACITY_NeedSouls);
         this.FPainterNeedSouls = new Vector.<TPainterTextEffect>(_loc3_);
         this.FBoundsNeedSoulsCaption = new Vector.<TBounds>(_loc3_);
         this.FContextNeedSouls = new Vector.<String>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ConstructPainterTextEffect(COLOR_ContextNeedSouls[_loc2_]);
            (_loc4_ as TPainterTextEffect).FontEffect.Outlined = true;
            (_loc4_ as TPainterTextEffect).FontEffect.OutlineSize = 2;
            (_loc4_ as TPainterTextEffect).FontEffect.Shadowed = true;
            _loc6_ = new TBounds();
            this.FContextNeedSouls[_loc2_] = "";
            this.FBoundsNeedSoulsCaption[_loc2_] = _loc6_;
            this.FPainterNeedSouls[_loc2_] = _loc4_;
            _loc2_++;
         }
      }
      
      override protected function ContextVerificate(param1:Object) : Boolean
      {
         return param1 is TEsotericPoint;
      }
      
      override protected function ContextModified() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:TEsotericPoint = null;
         _loc2_ = FContext as TEsotericPoint;
         return this.FContextCaption != _loc2_.PointName;
      }
      
      override protected function ContextSynchronize() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:TEsotericPoint = null;
         var _loc5_:TSkillConfig = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:uint = 0;
         var _loc11_:TStarPointDesc = null;
         var _loc12_:Vector.<String> = null;
         _loc4_ = FContext as TEsotericPoint;
         this.FIsSkill = _loc4_.IsSkill;
         this.FPainterCaption.Text = "";
         this.FContextCaption = "";
         this.FPainterBigDipper.Text = "";
         this.FContextBigDipper = "";
         _loc6_ = "";
         _loc7_ = "";
         _loc8_ = "";
         _loc9_ = "";
         this.FPainterAppendAttributesCaption.Text = "";
         this.FContextAppendAttributesCaption = "";
         this.FContextSkillDesc = "";
         this.FContextSkillName = "";
         _loc2_ = int(CAPACITY_NeedSouls);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FPainterNeedSouls[_loc1_].Text = "";
            this.FContextNeedSouls[_loc1_] = "";
            _loc1_++;
         }
         this.FContextCaption = _loc4_.PointName;
         this.FContextBigDipper = _loc4_.LevelLimit.toString();
         if(this.FIsSkill == 0)
         {
            _loc2_ = int(_loc4_.Type.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc6_ = TUtilityLobby.GetTargetNameByIndex(_loc4_.Target[_loc1_] - 1);
               _loc11_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_StarPointDesc,17500000 + _loc4_.Type[_loc1_]) as TStarPointDesc;
               _loc7_ = _loc11_.Desc;
               _loc8_ = _loc4_.Value[_loc1_].toString();
               if(_loc4_.Type[_loc1_] >= 100)
               {
                  _loc10_ = _loc4_.Value[_loc1_] * 100;
                  _loc8_ = _loc10_.toString() + "%";
               }
               _loc9_ = _loc6_ + _loc7_ + "+" + _loc8_ + "\n";
               this.FContextAppendAttributesCaption += _loc9_;
               _loc1_++;
            }
            this.FContextAppendAttributesCaption += "\n";
         }
         else
         {
            _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SkillConfig,_loc4_.Value[0]) as TSkillConfig;
            this.FContextSkillName = TUtilityString.Format(CONST_COMMON.STRING_ThickSquare,_loc5_.Name);
            this.FContextSkillDesc = _loc5_.Desc.split("%colour%").join("#fffe0000") + "<br><br/>";
         }
         _loc12_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.GENERALSTAR_FORMAT_11);
         _loc2_ = int(CAPACITY_NeedSouls);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc1_ == 1)
            {
               this.FContextNeedSouls[_loc1_] = TUtilityString.Format(_loc12_[_loc1_],_loc4_.NeedFetch);
            }
            else
            {
               this.FContextNeedSouls[_loc1_] = _loc12_[_loc1_];
            }
            _loc1_++;
         }
      }
      
      override protected function EvaluationPerform_Context() : void
      {
         var _loc1_:TEsotericPoint = null;
         _loc1_ = FContext as TEsotericPoint;
         this.EvaluationPerform_Caption(_loc1_);
         this.FBoundsOffsetY = this.FBoundsCaption;
         this.EvaluationPerform_ContextAppendAttributes(_loc1_);
         this.FBoundsOffsetY = this.FBoundsAppendAttributesCaption;
         this.EvaluationPerform_ContextSkill(_loc1_);
         this.EvaluationPerform_ContextNeedSoul(_loc1_);
         this.FBoundsOffsetY = this.FBoundsBigDipper;
      }
      
      protected function EvaluationPerform_Caption(param1:TEsotericPoint) : void
      {
         BoundsAlignDown(this.FBoundsCaption);
         this.FPainterCaption.Text = TUtilityString.Format(FORMAT_Caption,this.FContextCaption);
         this.FPainterCaption.Evaluate(this.FBoundsCaption);
         BoundsContextUnion(this.FBoundsCaption);
      }
      
      protected function EvaluationPerform_BigDipper(param1:TEsotericPoint) : void
      {
         BoundsAlignDown(this.FBoundsBigDipper);
         this.FPainterBigDipper.Evaluate(this.FBoundsBigDipper);
         BoundsContextUnion(this.FBoundsBigDipper);
      }
      
      protected function EvaluationPerform_ContextAppendAttributes(param1:TEsotericPoint) : void
      {
         BoundsAlignDown(this.FBoundsAppendAttributesCaption,this.FBoundsOffsetY,SIZE_OffsetY + 5);
         this.FPainterAppendAttributesCaption.Text = this.FContextAppendAttributesCaption;
         this.FPainterAppendAttributesCaption.Evaluate(this.FBoundsAppendAttributesCaption);
         BoundsContextUnion(this.FBoundsAppendAttributesCaption);
         this.FBoundsOffsetY = this.FBoundsAppendAttributesCaption;
      }
      
      protected function EvaluationPerform_ContextSkill(param1:TEsotericPoint) : void
      {
         BoundsAlignDown(this.FBoundsSkillName);
         this.FPainterSkillName.Text = this.FContextSkillName;
         this.FPainterSkillName.Evaluate(this.FBoundsSkillName);
         BoundsContextUnion(this.FBoundsSkillName);
         this.FBoundsOffsetY = this.FBoundsSkillName;
         BoundsAlignDown(this.FBoundsSkillDesc);
         this.FPainterSkillDesc.Text = this.FContextSkillDesc;
         this.FPainterSkillDesc.Evaluate(this.FBoundsSkillDesc);
         BoundsContextUnion(this.FBoundsSkillDesc);
         this.FBoundsOffsetY = this.FBoundsSkillDesc;
      }
      
      protected function EvaluationPerform_ContextNeedSoul(param1:TEsotericPoint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TBounds = null;
         var _loc5_:TPainterTextEffect = null;
         _loc3_ = int(CAPACITY_NeedSouls);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FBoundsNeedSoulsCaption[_loc2_];
            if(_loc2_ == 0)
            {
               BoundsAlignDown(_loc4_,this.FBoundsOffsetY);
            }
            else
            {
               BoundsAlignRight(_loc4_,this.FBoundsOffsetY);
            }
            _loc5_ = this.FPainterNeedSouls[_loc2_];
            _loc5_.Text = this.FContextNeedSouls[_loc2_];
            _loc5_.Evaluate(_loc4_);
            BoundsContextUnion(_loc4_);
            this.FBoundsOffsetY = _loc4_;
            _loc2_++;
         }
      }
      
      override protected function SketchingPerform_Context() : void
      {
         this.SketchingPerform_Caption();
         if(this.FIsSkill == 0)
         {
            this.SketchingPerform_AppendAttributes();
         }
         else
         {
            this.SketchingPerform_ContextSkill();
         }
         this.SketchingPerform_ContextNeedSoul();
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
      
      protected function SketchingPerform_ContextSkill() : void
      {
         this.FPainterSkillName.RenderBounds(this.FBoundsSkillName,TAlignment.HORIZONTAL_Center);
         this.FPainterSkillDesc.RenderBounds(this.FBoundsSkillDesc,TAlignment.HORIZONTAL_Center);
      }
      
      protected function SketchingPerform_ContextNeedSoul() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TBounds = null;
         var _loc4_:TPainterTextEffect = null;
         _loc2_ = int(CAPACITY_NeedSouls);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FPainterNeedSouls[_loc1_];
            _loc3_ = this.FBoundsNeedSoulsCaption[_loc1_];
            _loc4_.RenderBounds(_loc3_,TAlignment.HORIZONTAL_Center);
            _loc1_++;
         }
      }
      
      protected function SketchingPerform_BigDipper() : void
      {
         this.FPainterBigDipper.RenderBounds(this.FBoundsBigDipper,TAlignment.HORIZONTAL_Center);
      }
      
      override protected function RenderingPerform_Context(param1:TCoordinate) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TBounds = null;
         var _loc7_:TPainterTextEffect = null;
         var _loc8_:TPainterHtmlTextEffect = null;
         _loc6_ = new TBounds();
         FBoundsRendering.X = FMarginLeft;
         FBoundsRendering.Y = FMarginTop;
         this.FPainterCaption.x = FBoundsRendering.X;
         this.FPainterCaption.y = FBoundsRendering.Y;
         if(this.FIsSkill == 0)
         {
            this.FPainterAppendAttributesCaption.x = FBoundsRendering.X;
            this.FPainterAppendAttributesCaption.y = FBoundsRendering.Y + this.FBoundsAppendAttributesCaption.Y;
         }
         else
         {
            this.FPainterSkillName.x = FBoundsRendering.X;
            this.FPainterSkillName.y = FBoundsRendering.Y + this.FBoundsSkillName.Y;
            this.FPainterSkillDesc.x = FBoundsRendering.X;
            this.FPainterSkillDesc.y = FBoundsRendering.Y + this.FBoundsSkillDesc.Y;
         }
         _loc3_ = int(CAPACITY_NeedSouls);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc7_ = this.FPainterNeedSouls[_loc2_];
            _loc6_ = this.FBoundsNeedSoulsCaption[_loc2_];
            _loc7_.x = FBoundsRendering.X + _loc6_.X;
            _loc7_.y = FBoundsRendering.Y + _loc6_.Y;
            _loc2_++;
         }
      }
      
      override protected function ConstructPainterHtmlTextEffect(param1:uint = 4294958161) : TPainterHtmlTextEffect
      {
         var _loc2_:TPainterHtmlTextEffect = null;
         _loc2_ = super.ConstructPainterHtmlTextEffect(param1);
         _loc2_.Font.Color = param1;
         _loc2_.Font.Leading = 5;
         _loc2_.FontEffect.OutlineSize = SIZE_OutlineSize;
         _loc2_.WordWrapWidth = 800;
         _loc2_.Multilineable = true;
         return _loc2_;
      }
   }
}

