package Rendering.Overlayers.Home
{
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Foundation.UI.TUIComponent;
   import Logics.Home.HomeSoul.THomeSoul;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Rendering.Overlayers.TOverlayer;
   import Rendering.Texts.TPainterTextEffect;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.text.TextFormat;
   
   public class TOverlayerHomeMonsterSoul extends TOverlayer
   {
      
      protected static const SIZE_WordWrapWidth:uint = 150;
      
      protected static const COLOR_Context_White:uint = 4294967295;
      
      protected static const QUALITYCOLOR_Green:uint = CONST_COMMON.QUALITYCOLOR_Green;
      
      protected static const QUALITYCOLOR_INDEX:Vector.<uint> = CONST_COMMON.QUALITYCOLOR_INDEX;
      
      protected static const MAXCOUNT_AWARD:uint = 4;
      
      protected var FPainterFixedAwardTitle:TPainterTextEffect;
      
      protected var FPainterFixedAward:Vector.<TPainterTextEffect>;
      
      protected var FPainterAwardTitle:TPainterTextEffect;
      
      protected var FPainterAward:Vector.<TPainterTextEffect>;
      
      protected var FPainterDesc:TPainterTextEffect;
      
      protected var FPainterPrompt:TPainterTextEffect;
      
      protected var FBoundsOffset:TBounds;
      
      protected var FBoundsFixedAwardTitle:TBounds;
      
      protected var FBoundsFixedAward:Vector.<TBounds>;
      
      protected var FBoundsAwardTitle:TBounds;
      
      protected var FBoundsAward:Vector.<TBounds>;
      
      protected var FBoundsDesc:TBounds;
      
      protected var FBoundsPrompt:TBounds;
      
      protected var FTextFormat:TextFormat;
      
      protected var FFixedIDVect:Vector.<uint>;
      
      protected var FFixedInventories:TInventories;
      
      protected var FAwardIDVect:Vector.<uint>;
      
      protected var FInventories:TInventories;
      
      protected var FDesc:String;
      
      protected var FPrompt:String;
      
      public function TOverlayerHomeMonsterSoul(param1:TUIComponent)
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TPainterTextEffect = null;
         var _loc5_:TBounds = null;
         super(param1);
         FWordWrapWidth = SIZE_WordWrapWidth;
         this.FPainterFixedAwardTitle = ConstructPainterTextEffect(COLOR_Context_White);
         this.FBoundsFixedAwardTitle = new TBounds();
         this.FPainterFixedAward = new Vector.<TPainterTextEffect>(MAXCOUNT_AWARD);
         this.FBoundsFixedAward = new Vector.<TBounds>(MAXCOUNT_AWARD);
         _loc3_ = int(MAXCOUNT_AWARD);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ConstructPainterTextEffect(COLOR_Context_White);
            _loc5_ = new TBounds();
            this.FPainterFixedAward[_loc2_] = _loc4_;
            this.FBoundsFixedAward[_loc2_] = _loc5_;
            _loc2_++;
         }
         this.FPainterAwardTitle = ConstructPainterTextEffect(COLOR_Context_White);
         this.FBoundsAwardTitle = new TBounds();
         this.FPainterAward = new Vector.<TPainterTextEffect>(MAXCOUNT_AWARD);
         this.FBoundsAward = new Vector.<TBounds>(MAXCOUNT_AWARD);
         _loc3_ = int(MAXCOUNT_AWARD);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ConstructPainterTextEffect(COLOR_Context_White);
            _loc5_ = new TBounds();
            this.FPainterAward[_loc2_] = _loc4_;
            this.FBoundsAward[_loc2_] = _loc5_;
            _loc2_++;
         }
         this.FPainterDesc = ConstructPainterTextEffect();
         this.FBoundsDesc = new TBounds();
         this.FPainterPrompt = ConstructPainterTextEffect(COLOR_Context_White);
         this.FBoundsPrompt = new TBounds();
         this.FFixedIDVect = new Vector.<uint>();
         this.FFixedInventories = new TInventories();
         this.FAwardIDVect = new Vector.<uint>();
         this.FInventories = new TInventories();
         this.FDesc = "";
         this.FPrompt = "";
         this.FTextFormat = new TextFormat();
         FMarginLeft = 15;
         FMarginTop = 15;
         FMarginRight = 1;
         FMarginBottom = 15;
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ContextVerificate(param1:Object) : Boolean
      {
         return param1 is THomeSoul;
      }
      
      override protected function ContextModified() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:THomeSoul = null;
         _loc4_ = FContext as THomeSoul;
         _loc1_ = true;
         _loc3_ = int(_loc4_.FixedIDVect.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FFixedIDVect[_loc2_] != _loc4_.FixedIDVect[_loc2_])
            {
               _loc1_ = false;
               break;
            }
            _loc2_++;
         }
         _loc3_ = int(_loc4_.AwardIDVect.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FAwardIDVect[_loc2_] != _loc4_.AwardIDVect[_loc2_])
            {
               _loc1_ = false;
               break;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      override protected function ContextSynchronize() : void
      {
         var _loc1_:THomeSoul = null;
         _loc1_ = FContext as THomeSoul;
         this.FFixedIDVect = _loc1_.FixedIDVect;
         this.FFixedInventories = _loc1_.FixedInventories;
         this.FAwardIDVect = _loc1_.AwardIDVect;
         this.FInventories = _loc1_.Inventories;
         this.FDesc = _loc1_.Recommend;
         this.FPrompt = _loc1_.Prompt;
      }
      
      override protected function EvaluationPerform_Context() : void
      {
         this.EvaluationPerform_FixedTitle();
         this.FBoundsOffset = this.FBoundsFixedAwardTitle;
         this.EvaluationPerform_Fixed();
         this.FBoundsOffset = this.FBoundsFixedAward[this.FFixedIDVect.length - 1];
         this.EvaluationPerform_AwardTitle();
         this.FBoundsOffset = this.FBoundsAwardTitle;
         this.EvaluationPerform_Award();
         this.FBoundsOffset = this.FBoundsAward[this.FAwardIDVect.length - 1];
         this.EvaluationPerform_Desc();
         this.FBoundsOffset = this.FBoundsDesc;
         this.EvaluationPerform_Prompt();
         this.FBoundsOffset = this.FBoundsPrompt;
      }
      
      protected function EvaluationPerform_FixedTitle() : void
      {
         BoundsAlignDown(this.FBoundsFixedAwardTitle,null);
         this.FPainterFixedAwardTitle.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SoulMonster_STRING_04);
         this.FPainterFixedAwardTitle.Evaluate(this.FBoundsFixedAwardTitle);
         BoundsContextUnion(this.FBoundsFixedAwardTitle);
      }
      
      protected function EvaluationPerform_Fixed() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TInventory = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:String = null;
         var _loc7_:TBounds = null;
         var _loc8_:TBounds = null;
         var _loc9_:TPainterTextEffect = null;
         _loc8_ = this.FBoundsOffset;
         _loc1_ = int(this.FPainterFixedAward.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc9_ = this.FPainterFixedAward[_loc2_];
            _loc9_.Text = "";
            _loc2_++;
         }
         _loc1_ = this.FFixedInventories.Count;
         _loc2_ = 0;
         while(_loc2_ < MAXCOUNT_AWARD)
         {
            _loc9_ = this.FPainterFixedAward[_loc2_];
            _loc7_ = this.FBoundsFixedAward[_loc2_];
            if(_loc2_ + 1 <= _loc1_)
            {
               _loc9_.Visible = true;
               BoundsAlignDown(_loc7_,_loc8_);
               _loc3_ = this.FFixedInventories.GetInventoryByIndex(_loc2_);
               _loc9_.Text += "    " + _loc3_.Name + "*" + _loc3_.Quantity;
               _loc6_ = _loc3_.Name;
               this.FTextFormat.color = QUALITYCOLOR_INDEX[_loc3_.Quality];
               _loc4_ = uint(_loc9_.Text.lastIndexOf(_loc6_));
               _loc5_ = _loc4_ + _loc6_.length;
               _loc9_.Evaluate(_loc7_);
               _loc9_.SetTextFormat(this.FTextFormat,_loc4_,_loc5_);
               BoundsContextUnion(_loc7_);
               _loc8_ = _loc7_;
            }
            else
            {
               _loc9_.Visible = false;
            }
            _loc2_++;
         }
      }
      
      protected function EvaluationPerform_AwardTitle() : void
      {
         BoundsAlignDown(this.FBoundsAwardTitle,this.FBoundsOffset);
         this.FPainterAwardTitle.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SoulMonster_STRING_02);
         this.FPainterAwardTitle.Evaluate(this.FBoundsAwardTitle);
         BoundsContextUnion(this.FBoundsAwardTitle);
      }
      
      protected function EvaluationPerform_Award() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TInventory = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:String = null;
         var _loc7_:TBounds = null;
         var _loc8_:TBounds = null;
         var _loc9_:TPainterTextEffect = null;
         _loc8_ = this.FBoundsOffset;
         _loc1_ = int(this.FPainterAward.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc9_ = this.FPainterAward[_loc2_];
            _loc9_.Text = "";
            _loc2_++;
         }
         _loc1_ = this.FInventories.Count;
         _loc2_ = 0;
         while(_loc2_ < MAXCOUNT_AWARD)
         {
            _loc9_ = this.FPainterAward[_loc2_];
            _loc7_ = this.FBoundsAward[_loc2_];
            if(_loc2_ + 1 <= _loc1_)
            {
               _loc9_.Visible = true;
               BoundsAlignDown(_loc7_,_loc8_);
               _loc3_ = this.FInventories.GetInventoryByIndex(_loc2_);
               _loc9_.Text += "    " + _loc3_.Name + "*" + _loc3_.Quantity;
               _loc6_ = _loc3_.Name;
               this.FTextFormat.color = QUALITYCOLOR_INDEX[_loc3_.Quality];
               _loc4_ = uint(_loc9_.Text.lastIndexOf(_loc6_));
               _loc5_ = _loc4_ + _loc6_.length;
               _loc9_.Evaluate(_loc7_);
               _loc9_.SetTextFormat(this.FTextFormat,_loc4_,_loc5_);
               BoundsContextUnion(_loc7_);
               _loc8_ = _loc7_;
            }
            else
            {
               _loc9_.Visible = false;
            }
            _loc2_++;
         }
      }
      
      protected function EvaluationPerform_Desc() : void
      {
         BoundsAlignDown(this.FBoundsDesc,this.FBoundsOffset);
         this.FPainterDesc.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SoulMonster_STRING_03) + this.FDesc;
         this.FPainterDesc.Evaluate(this.FBoundsDesc);
         BoundsContextUnion(this.FBoundsDesc);
      }
      
      protected function EvaluationPerform_Prompt() : void
      {
         BoundsAlignDown(this.FBoundsPrompt,this.FBoundsOffset);
         this.FPainterPrompt.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SoulMonster_STRING_01);
         this.FPainterPrompt.Evaluate(this.FBoundsPrompt);
         BoundsContextUnion(this.FBoundsPrompt);
      }
      
      override protected function SketchingPerform_Context() : void
      {
      }
      
      override protected function RenderingPerform_Context(param1:TCoordinate) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TBounds = null;
         var _loc5_:TPainterTextEffect = null;
         var _loc6_:TBounds = null;
         var _loc7_:TPainterTextEffect = null;
         FBoundsRendering.X = FMarginLeft;
         FBoundsRendering.Y = FMarginTop;
         this.FPainterFixedAwardTitle.X = FBoundsRendering.X + this.FBoundsFixedAwardTitle.X;
         this.FPainterFixedAwardTitle.Y = FBoundsRendering.Y + this.FBoundsFixedAwardTitle.Y;
         _loc3_ = int(this.FFixedIDVect.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc7_ = this.FPainterFixedAward[_loc2_];
            _loc6_ = this.FBoundsFixedAward[_loc2_];
            _loc7_.X = FBoundsRendering.X + _loc6_.X;
            _loc7_.Y = FBoundsRendering.Y + _loc6_.Y;
            _loc2_++;
         }
         this.FPainterAwardTitle.X = FBoundsRendering.X + this.FBoundsAwardTitle.X;
         this.FPainterAwardTitle.Y = FBoundsRendering.Y + this.FBoundsAwardTitle.Y;
         _loc3_ = int(this.FAwardIDVect.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = this.FPainterAward[_loc2_];
            _loc4_ = this.FBoundsAward[_loc2_];
            _loc5_.X = FBoundsRendering.X + _loc4_.X;
            _loc5_.Y = FBoundsRendering.Y + _loc4_.Y;
            _loc2_++;
         }
         this.FPainterDesc.x = FBoundsRendering.X + this.FBoundsDesc.X;
         this.FPainterDesc.y = FBoundsRendering.Y + this.FBoundsDesc.Y;
         this.FPainterPrompt.x = FBoundsRendering.X + this.FBoundsPrompt.X;
         this.FPainterPrompt.y = FBoundsRendering.Y + this.FBoundsPrompt.Y;
      }
   }
}

