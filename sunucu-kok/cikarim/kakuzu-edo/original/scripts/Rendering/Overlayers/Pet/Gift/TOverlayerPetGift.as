package Rendering.Overlayers.Pet.Gift
{
   import Foundation.Common.*;
   import Foundation.UI.*;
   import Foundation.Utilities.TUtilityString;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Logics.Pet.Gift.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Rendering.Overlayers.*;
   import Rendering.Texts.*;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   
   public class TOverlayerPetGift extends TOverlayer
   {
      
      protected static const SIZE_WordWrapWidth:uint = 150;
      
      protected static const CAPACITY_INVENTORIES:uint = 10;
      
      protected static const CAPACITY_CONDITION:uint = 3;
      
      protected static const COLOR_Default:uint = 4290559164;
      
      protected static const SPECIAL_OFFSISE:uint = 8;
      
      protected static const SPECIAL_Text_OFFSISE:uint = 2;
      
      protected var FPainterCaption:TPainterTextEffect;
      
      protected var FPainterNameA:TPainterTextEffect;
      
      protected var FPainterInventories:Vector.<TPainterTextEffect>;
      
      protected var FPainterNameB:TPainterTextEffect;
      
      protected var FPainterConditions:Vector.<TPainterTextEffect>;
      
      protected var FBoundsCaption:TBounds;
      
      protected var FBoundsNameA:TBounds;
      
      protected var FBoundsInventories:Vector.<TBounds>;
      
      protected var FBoundsNameB:TBounds;
      
      protected var FBoundsConditions:Vector.<TBounds>;
      
      protected var FBoundsOffset:TBounds;
      
      protected var FContextIDTemplate:uint;
      
      public function TOverlayerPetGift(param1:TUIComponent)
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TPainterTextEffect = null;
         var _loc5_:TBounds = null;
         super(param1);
         FWordWrapWidth = SIZE_WordWrapWidth;
         this.FPainterCaption = ConstructPainterTextEffect();
         this.FBoundsCaption = new TBounds();
         this.FPainterNameA = ConstructPainterTextEffect();
         this.FBoundsNameA = new TBounds();
         this.FPainterInventories = new Vector.<TPainterTextEffect>(CAPACITY_INVENTORIES);
         this.FBoundsInventories = new Vector.<TBounds>(CAPACITY_INVENTORIES);
         _loc3_ = CAPACITY_INVENTORIES;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ConstructPainterTextEffect(COLOR_Default);
            _loc5_ = new TBounds();
            this.FPainterInventories[_loc2_] = _loc4_;
            this.FBoundsInventories[_loc2_] = _loc5_;
            _loc2_++;
         }
         this.FPainterNameB = ConstructPainterTextEffect();
         this.FBoundsNameB = new TBounds();
         this.FPainterConditions = new Vector.<TPainterTextEffect>(CAPACITY_CONDITION);
         this.FBoundsConditions = new Vector.<TBounds>(CAPACITY_CONDITION);
         _loc3_ = CAPACITY_CONDITION;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ConstructPainterTextEffect(COLOR_Default);
            _loc5_ = new TBounds();
            this.FPainterConditions[_loc2_] = _loc4_;
            this.FBoundsConditions[_loc2_] = _loc5_;
            _loc2_++;
         }
      }
      
      override protected function ContextVerificate(param1:Object) : Boolean
      {
         return param1 is TGift;
      }
      
      override protected function ContextModified() : Boolean
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TGift = null;
         var _loc4_:Boolean = false;
         _loc3_ = FContext as TGift;
         return this.FContextIDTemplate != _loc3_.Identifier;
      }
      
      override protected function ContextSynchronize() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TGift = null;
         _loc3_ = FContext as TGift;
         this.FContextIDTemplate = _loc3_.Identifier;
      }
      
      override protected function EvaluationPerform_Context() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TGift = null;
         _loc3_ = FContext as TGift;
         this.EvaluationPerform_Caption(_loc3_);
         this.FBoundsOffset = this.FBoundsCaption;
         this.EvaluationPerform_NameA(_loc3_);
         this.FBoundsOffset = this.FBoundsNameA;
         this.EvaluationPerform_Inventories(_loc3_);
         if(_loc3_.UserLevel == 0 && _loc3_.MainPetStage == 0 && _loc3_.VicePetNum == 0)
         {
            this.FPainterNameB.Visible = false;
         }
         else
         {
            this.EvaluationPerform_NameB(_loc3_);
            this.FBoundsOffset = this.FBoundsNameB;
            this.FPainterNameB.Visible = true;
         }
         this.EvaluationPerform_Conditions(_loc3_);
      }
      
      protected function EvaluationPerform_Caption(param1:TGift) : void
      {
         BoundsAlignRight(this.FBoundsCaption,null,20);
         this.FPainterCaption.Font.Size = 13;
         this.FPainterCaption.Font.Bold = true;
         this.FPainterCaption.Text = param1.Name;
         this.FPainterCaption.Evaluate(this.FBoundsCaption);
         BoundsContextUnion(this.FBoundsCaption);
      }
      
      protected function EvaluationPerform_NameA(param1:TGift) : void
      {
         BoundsAlignDown(this.FBoundsNameA,this.FBoundsOffset,10);
         this.FPainterNameA.Font.Bold = true;
         this.FPainterNameA.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_01);
         this.FPainterNameA.Evaluate(this.FBoundsNameA);
         BoundsContextUnion(this.FBoundsNameA);
         this.FBoundsNameA.X = 0;
      }
      
      protected function EvaluationPerform_Inventories(param1:TGift) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TInventory = null;
         var _loc5_:TInventories = null;
         var _loc6_:TBounds = null;
         var _loc7_:TBounds = null;
         var _loc8_:TPainterTextEffect = null;
         _loc7_ = this.FBoundsOffset;
         _loc2_ = int(CAPACITY_INVENTORIES);
         _loc5_ = param1.Inventories;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc8_ = this.FPainterInventories[_loc3_];
            _loc6_ = this.FBoundsInventories[_loc3_];
            if(_loc3_ < _loc5_.Count)
            {
               _loc4_ = _loc5_.GetInventoryByIndex(_loc3_);
               if(_loc3_ == 0)
               {
                  BoundsAlignRight(_loc6_,_loc7_);
               }
               else
               {
                  BoundsAlignDown(_loc6_,_loc7_);
               }
               _loc8_.Font.Color = CONST_COMMON.QUALITYCOLOR_INDEX[_loc4_.Quality];
               _loc8_.Text = TUtilityString.Format(CONST_COMMON.STRING_Quantity,_loc4_.Name,_loc4_.Quantity);
               _loc8_.Evaluate(_loc6_);
               BoundsContextUnion(_loc6_);
               _loc7_ = _loc6_;
               _loc8_.Visible = true;
            }
            else
            {
               _loc8_.Text = "";
               _loc8_.Visible = false;
            }
            _loc3_++;
         }
         this.FBoundsOffset = _loc7_;
      }
      
      protected function EvaluationPerform_NameB(param1:TGift) : void
      {
         BoundsAlignDown(this.FBoundsNameB,this.FBoundsOffset,10);
         this.FBoundsNameB.X = 0;
         this.FPainterNameB.Font.Bold = true;
         this.FPainterNameB.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_02);
         this.FPainterNameB.Evaluate(this.FBoundsNameB);
         BoundsContextUnion(this.FBoundsNameB);
      }
      
      protected function EvaluationPerform_Conditions(param1:TGift) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TBounds = null;
         var _loc5_:TBounds = null;
         var _loc6_:TPainterTextEffect = null;
         _loc5_ = this.FBoundsOffset;
         _loc2_ = int(CAPACITY_CONDITION);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc6_ = this.FPainterConditions[_loc3_];
            _loc4_ = this.FBoundsConditions[_loc3_];
            if(param1.Conditions[_loc3_] > 0)
            {
               if(_loc3_ == 0)
               {
                  BoundsAlignDown(_loc4_,_loc5_,5);
                  _loc4_.X += 5;
               }
               else
               {
                  BoundsAlignDown(_loc4_,_loc5_);
               }
               _loc6_.Text = TUtilityString.Format(TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_03)[_loc3_],param1.Conditions[_loc3_]);
               _loc6_.Evaluate(_loc4_);
               BoundsContextUnion(_loc4_);
               _loc5_ = _loc4_;
               _loc6_.Visible = true;
            }
            else
            {
               _loc6_.Text = "";
               _loc6_.Visible = false;
            }
            _loc3_++;
         }
         this.FBoundsOffset = _loc5_;
      }
      
      override protected function RenderingPerform_Context(param1:TCoordinate) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TBounds = null;
         var _loc5_:TPainterTextEffect = null;
         FBoundsRendering.X = FMarginLeft;
         FBoundsRendering.Y = FMarginTop;
         this.FPainterCaption.X = (FBoundsRendering.Width - this.FBoundsCaption.Width) / 2;
         this.FPainterCaption.Y = FBoundsRendering.Y + this.FBoundsCaption.Y;
         this.FPainterNameA.X = FBoundsRendering.X + this.FBoundsNameA.X;
         this.FPainterNameA.Y = FBoundsRendering.Y + this.FBoundsNameA.Y;
         _loc3_ = int(CAPACITY_INVENTORIES);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = this.FPainterInventories[_loc2_];
            _loc4_ = this.FBoundsInventories[_loc2_];
            _loc5_.X = FBoundsRendering.X + _loc4_.X;
            _loc5_.Y = FBoundsRendering.Y + _loc4_.Y;
            _loc2_++;
         }
         this.FPainterNameB.X = FBoundsRendering.X + this.FBoundsNameB.X;
         this.FPainterNameB.Y = FBoundsRendering.Y + this.FBoundsNameB.Y;
         _loc3_ = int(CAPACITY_CONDITION);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = this.FPainterConditions[_loc2_];
            _loc4_ = this.FBoundsConditions[_loc2_];
            _loc5_.X = FBoundsRendering.X + _loc4_.X;
            _loc5_.Y = FBoundsRendering.Y + _loc4_.Y;
            _loc2_++;
         }
      }
   }
}

