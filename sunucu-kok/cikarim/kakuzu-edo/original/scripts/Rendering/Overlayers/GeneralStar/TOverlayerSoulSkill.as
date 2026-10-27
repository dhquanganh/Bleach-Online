package Rendering.Overlayers.GeneralStar
{
   import Foundation.Common.*;
   import Foundation.Fonts.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Skills.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Rendering.Overlayers.*;
   import Rendering.Texts.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   
   public class TOverlayerSoulSkill extends TOverlayer
   {
      
      protected static const COLOUR_SKILLNAME:uint = 4294953095;
      
      protected static const OFFSIDE_ID:uint = 17200000;
      
      protected var FPainterCaption:TPainterTextEffect;
      
      protected var FPainterSkillGetHtmlTextEffect:TPainterHtmlTextEffect;
      
      protected var FPainterCurLevelHtmlTextEffect:TPainterHtmlTextEffect;
      
      protected var FPainterNextLevelHtmlTextEffect:TPainterHtmlTextEffect;
      
      protected var FPainterMaxLevelHtmlTextEffect:TPainterHtmlTextEffect;
      
      protected var FPainterUpgradeConsumeHtmlTextEffect:TPainterHtmlTextEffect;
      
      protected var FBoundsCaption:TBounds;
      
      protected var FBoundsSkillGet:TBounds;
      
      protected var FBoundsCurLevel:TBounds;
      
      protected var FBoundsNextLevel:TBounds;
      
      protected var FBoundsMaxLevel:TBounds;
      
      protected var FBoundsUpgradeConsume:TBounds;
      
      protected var FContextCaption:String;
      
      protected var FContextSkillGet:String;
      
      protected var FContextCurLevel:String;
      
      protected var FContextNextLevel:String;
      
      protected var FContextMaxLevel:String;
      
      protected var FContextUpgradeConsume:String;
      
      protected var FStarMapBin:TBins;
      
      protected var FSkillConfigBin:TBins;
      
      protected var FStarPointBin:TBins;
      
      protected var FSoulSkillBin:TBins;
      
      protected var FBoundsOffsetY:TBounds;
      
      protected var FLevel:uint;
      
      public function TOverlayerSoulSkill(param1:TUIComponent)
      {
         super(param1);
         this.FPainterCaption = ConstructPainterTextEffect(COLOUR_SKILLNAME);
         this.FBoundsCaption = new TBounds();
         this.FPainterSkillGetHtmlTextEffect = this.ConstructPainterHtmlTextEffect();
         this.FBoundsSkillGet = new TBounds();
         this.FPainterCurLevelHtmlTextEffect = this.ConstructPainterHtmlTextEffect();
         this.FBoundsCurLevel = new TBounds();
         this.FPainterNextLevelHtmlTextEffect = this.ConstructPainterHtmlTextEffect();
         this.FBoundsNextLevel = new TBounds();
         this.FPainterMaxLevelHtmlTextEffect = this.ConstructPainterHtmlTextEffect();
         this.FBoundsMaxLevel = new TBounds();
         this.FPainterUpgradeConsumeHtmlTextEffect = this.ConstructPainterHtmlTextEffect();
         this.FBoundsUpgradeConsume = new TBounds();
      }
      
      override protected function ContextVerificate(param1:Object) : Boolean
      {
         return param1 is TSkill;
      }
      
      override protected function ContextModified() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:TSkill = null;
         _loc2_ = FContext as TSkill;
         return this.FContextCaption != _loc2_.Name || this.FLevel != _loc2_.Level;
      }
      
      override protected function ContextSynchronize() : void
      {
         var _loc1_:TSkill = null;
         var _loc2_:TSkillConfig = null;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc6_:TStarMap = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:TStarPoint = null;
         var _loc10_:TSoulSkill = null;
         _loc1_ = FContext as TSkill;
         _loc3_ = !Boolean(_loc1_.NextID);
         _loc4_ = _loc1_.IsUnlock;
         this.FPainterCaption.Text = "";
         this.FContextCaption = "";
         this.FPainterSkillGetHtmlTextEffect.Text = "";
         this.FContextSkillGet = "";
         this.FPainterCurLevelHtmlTextEffect.Text = "";
         this.FContextCurLevel = "";
         this.FPainterNextLevelHtmlTextEffect.Text = "";
         this.FContextNextLevel = "";
         this.FPainterMaxLevelHtmlTextEffect.Text = "";
         this.FContextMaxLevel = "";
         this.FPainterUpgradeConsumeHtmlTextEffect.Text = "";
         this.FContextUpgradeConsume = "";
         _loc5_ = "";
         if(this.FStarMapBin == null)
         {
            this.FStarMapBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_StarMap);
         }
         if(this.FSkillConfigBin == null)
         {
            this.FSkillConfigBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SkillConfig);
         }
         if(this.FSoulSkillBin == null)
         {
            this.FSoulSkillBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SoulSkill);
         }
         if(this.FStarPointBin == null)
         {
            this.FStarPointBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_StarPoint);
         }
         this.FContextCaption = _loc1_.Name;
         this.FLevel = _loc1_.Level;
         if(_loc3_)
         {
            this.FContextMaxLevel = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_MAXLEVELE);
            this.FContextMaxLevel += TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_CURSKILL).split("%colour%").join("#ffffffff") + this.GetSkill(_loc1_);
            return;
         }
         if(_loc4_)
         {
            _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_CURSKILL).split("%colour%").join("#ffffffff");
            _loc5_ = _loc5_ + _loc1_.Description.split("%colour%").join(CONST_COMMON.TextColor[2]);
            this.FContextCurLevel = _loc5_ + "<br><br/>";
            _loc8_ = this.FSkillConfigBin.Count;
            _loc7_ = 0;
            while(_loc7_ < _loc8_)
            {
               _loc2_ = this.FSkillConfigBin.GetDatebaseByIndex(_loc7_) as TSkillConfig;
               if(_loc2_.Identifier == _loc1_.Identifier)
               {
                  break;
               }
               _loc7_++;
            }
            _loc2_ = this.FSkillConfigBin.GetDatebaseByIndex(_loc7_ + 1) as TSkillConfig;
            _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_NEXTSKILL).split("%colour%").join("#ffffffff");
            _loc5_ = _loc5_ + _loc2_.Desc.split("%colour%").join(CONST_COMMON.TextColor[6]);
            this.FContextNextLevel = _loc5_ + "<br><br/>";
            _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CONSUME).split("%colour%").join(CONST_COMMON.TextColor[2]);
            _loc5_ = _loc5_.split("%count%").join(_loc1_.NeedItem.Amount);
            this.FContextUpgradeConsume = _loc5_;
         }
         else
         {
            _loc2_ = this.FSkillConfigBin.GetDatebaseByIdentifier(_loc1_.Identifier) as TSkillConfig;
            _loc8_ = this.FStarPointBin.Count;
            _loc7_ = 0;
            while(_loc7_ < _loc8_)
            {
               _loc9_ = this.FStarPointBin.GetDatebaseByIndex(_loc7_) as TStarPoint;
               if(_loc9_.StarPointAddType.Value[0] == _loc2_.SkillId)
               {
                  break;
               }
               _loc7_++;
            }
            _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_SKILLGET).split("%colour%").join("#ffffffff");
            _loc5_ = _loc5_ + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_CONDITION);
            _loc5_ = _loc5_.split("%colour%").join(CONST_COMMON.TextColor[6]);
            _loc5_ = _loc5_.split("%index%").join(_loc9_.Name);
            _loc5_ = _loc5_.split("%name%").join(_loc1_.Name);
            _loc6_ = this.FStarMapBin.GetDatebaseByIdentifier(OFFSIDE_ID + _loc9_.MapId) as TStarMap;
            _loc5_ = _loc5_.split("%map%").join(_loc6_.Name);
            _loc5_ = _loc5_ + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_SKILLOPEN).split("%colour%").join("#ffffffff");
            _loc5_ = _loc5_ + this.GetSkill(_loc1_);
            this.FContextSkillGet = _loc5_;
         }
      }
      
      protected function GetSkill(param1:TSkill) : String
      {
         var _loc2_:TStarPoint = null;
         var _loc3_:TStarMap = null;
         var _loc4_:TSoulSkill = null;
         var _loc5_:TSkillConfig = null;
         var _loc6_:String = null;
         _loc6_ = "";
         _loc6_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_SKILLOPEN_DESC).split("%name%").join(param1.Name);
         _loc6_ = _loc6_.split("%level%").join(param1.Level);
         _loc6_ = _loc6_.split("%colour%").join("#ffffffff");
         return _loc6_ + param1.Description.split("%colour%").join(CONST_COMMON.TextColor[6]);
      }
      
      override protected function EvaluationPerform_Context() : void
      {
         var _loc1_:TSkill = null;
         _loc1_ = FContext as TSkill;
         this.EvaluationPerform_Caption(_loc1_);
         this.FBoundsOffsetY = this.FBoundsCaption;
         this.EvaluationPerform_ContextSkillGet(_loc1_);
         this.FBoundsOffsetY = this.FBoundsSkillGet;
         this.EvaluationPerform_ContextCurLevel(_loc1_);
         this.FBoundsOffsetY = this.FBoundsCurLevel;
         this.EvaluationPerform_ContextNextLevel(_loc1_);
         this.FBoundsOffsetY = this.FBoundsNextLevel;
         this.EvaluationPerform_ContextMaxLevel(_loc1_);
         this.FBoundsOffsetY = this.FBoundsMaxLevel;
         this.EvaluationPerform_ContextUpgradeConsume(_loc1_);
         this.FBoundsOffsetY = this.FBoundsUpgradeConsume;
      }
      
      private function EvaluationPerform_ContextUpgradeConsume(param1:TSkill) : void
      {
         BoundsAlignDown(this.FBoundsUpgradeConsume);
         this.FPainterUpgradeConsumeHtmlTextEffect.Text = this.FContextUpgradeConsume;
         this.FPainterUpgradeConsumeHtmlTextEffect.Evaluate(this.FBoundsUpgradeConsume);
         BoundsContextUnion(this.FBoundsUpgradeConsume);
      }
      
      private function EvaluationPerform_ContextMaxLevel(param1:TSkill) : void
      {
         BoundsAlignDown(this.FBoundsMaxLevel);
         this.FPainterMaxLevelHtmlTextEffect.Text = this.FContextMaxLevel;
         this.FPainterMaxLevelHtmlTextEffect.Evaluate(this.FBoundsMaxLevel);
         BoundsContextUnion(this.FBoundsMaxLevel);
      }
      
      private function EvaluationPerform_ContextNextLevel(param1:TSkill) : void
      {
         BoundsAlignDown(this.FBoundsNextLevel);
         this.FPainterNextLevelHtmlTextEffect.Text = this.FContextNextLevel;
         this.FPainterNextLevelHtmlTextEffect.Evaluate(this.FBoundsNextLevel);
         BoundsContextUnion(this.FBoundsNextLevel);
      }
      
      private function EvaluationPerform_ContextCurLevel(param1:TSkill) : void
      {
         BoundsAlignDown(this.FBoundsCurLevel);
         this.FPainterCurLevelHtmlTextEffect.Text = this.FContextCurLevel;
         this.FPainterCurLevelHtmlTextEffect.Evaluate(this.FBoundsCurLevel);
         BoundsContextUnion(this.FBoundsCurLevel);
      }
      
      private function EvaluationPerform_ContextSkillGet(param1:TSkill) : void
      {
         BoundsAlignDown(this.FBoundsSkillGet);
         this.FPainterSkillGetHtmlTextEffect.Text = this.FContextSkillGet;
         this.FPainterSkillGetHtmlTextEffect.Evaluate(this.FBoundsSkillGet);
         BoundsContextUnion(this.FBoundsSkillGet);
      }
      
      protected function EvaluationPerform_Caption(param1:TSkill) : void
      {
         BoundsAlignDown(this.FBoundsCaption);
         this.FPainterCaption.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SKILLNAME),this.FContextCaption,param1.Level);
         this.FPainterCaption.Evaluate(this.FBoundsCaption);
         BoundsContextUnion(this.FBoundsCaption);
      }
      
      override protected function SketchingPerform_Context() : void
      {
         var _loc1_:TSkill = null;
         _loc1_ = FContext as TSkill;
         this.SketchingPerform_Caption();
         if(!Boolean(_loc1_.NextID))
         {
            this.SketchingPerform_MaxLevel();
            return;
         }
         if(_loc1_.IsUnlock)
         {
            this.SketchingPerform_CurSkill();
            this.SketchingPerform_NextSkill();
            this.SketchingPerform_UpgradeConsume();
         }
         else
         {
            this.SketchingPerform_SkillGet();
         }
      }
      
      private function SketchingPerform_SkillGet() : void
      {
         this.FPainterSkillGetHtmlTextEffect.RenderBounds(this.FBoundsSkillGet,TAlignment.HORIZONTAL_Center);
      }
      
      private function SketchingPerform_CurSkill() : void
      {
         this.FPainterCurLevelHtmlTextEffect.RenderBounds(FBoundsContext,TAlignment.HORIZONTAL_Center);
      }
      
      private function SketchingPerform_UpgradeConsume() : void
      {
         this.FPainterUpgradeConsumeHtmlTextEffect.RenderBounds(this.FBoundsUpgradeConsume,TAlignment.HORIZONTAL_Center);
      }
      
      private function SketchingPerform_NextSkill() : void
      {
         this.FPainterNextLevelHtmlTextEffect.RenderBounds(this.FBoundsNextLevel,TAlignment.HORIZONTAL_Center);
      }
      
      private function SketchingPerform_MaxLevel() : void
      {
         this.FPainterMaxLevelHtmlTextEffect.RenderBounds(this.FBoundsMaxLevel,TAlignment.HORIZONTAL_Center);
      }
      
      protected function SketchingPerform_Caption() : void
      {
         this.FBoundsCaption.Width = FBoundsContext.Width;
         this.FPainterCaption.RenderBounds(this.FBoundsCaption,TAlignment.HORIZONTAL_Center);
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
         var _loc9_:TSkill = null;
         _loc9_ = FContext as TSkill;
         _loc6_ = new TBounds();
         FBoundsRendering.X = FMarginLeft;
         FBoundsRendering.Y = FMarginTop;
         this.FPainterCaption.x = FBoundsRendering.X;
         this.FPainterCaption.y = FBoundsRendering.Y;
         if(!Boolean(_loc9_.NextID))
         {
            this.FPainterMaxLevelHtmlTextEffect.x = FBoundsRendering.X + this.FBoundsMaxLevel.X;
            this.FPainterMaxLevelHtmlTextEffect.y = FBoundsRendering.Y + this.FBoundsMaxLevel.Y;
            return;
         }
         if(_loc9_.IsUnlock)
         {
            this.FPainterCurLevelHtmlTextEffect.x = FBoundsRendering.X + this.FBoundsCurLevel.X;
            this.FPainterCurLevelHtmlTextEffect.y = FBoundsRendering.Y + this.FBoundsCurLevel.Y;
            this.FPainterNextLevelHtmlTextEffect.x = FBoundsRendering.X + this.FBoundsNextLevel.X;
            this.FPainterNextLevelHtmlTextEffect.y = FBoundsRendering.Y + this.FBoundsNextLevel.Y;
            this.FPainterUpgradeConsumeHtmlTextEffect.x = FBoundsRendering.X + this.FBoundsUpgradeConsume.X;
            this.FPainterUpgradeConsumeHtmlTextEffect.y = FBoundsRendering.Y + this.FBoundsUpgradeConsume.Y;
         }
         else
         {
            this.FPainterSkillGetHtmlTextEffect.x = FBoundsRendering.X + this.FBoundsSkillGet.X;
            this.FPainterSkillGetHtmlTextEffect.y = FBoundsRendering.Y + this.FBoundsSkillGet.Y;
         }
      }
      
      override protected function ConstructPainterHtmlTextEffect(param1:uint = 4294958161) : TPainterHtmlTextEffect
      {
         var _loc2_:TPainterHtmlTextEffect = null;
         _loc2_ = super.ConstructPainterHtmlTextEffect(param1);
         _loc2_.Font.Color = param1;
         _loc2_.Font.Leading = 5;
         _loc2_.Font.LetterSpacing = 2;
         _loc2_.WordWrapWidth = 444;
         _loc2_.Multilineable = true;
         return _loc2_;
      }
   }
}

