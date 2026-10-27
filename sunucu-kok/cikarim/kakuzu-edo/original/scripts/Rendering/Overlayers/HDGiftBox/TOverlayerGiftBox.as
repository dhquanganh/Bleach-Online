package Rendering.Overlayers.HDGiftBox
{
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.HDActivityMode.TGiftBoxTipData;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Rendering.Overlayers.TOverlayer;
   import Rendering.Texts.TPainterHtmlTextEffect;
   import Rendering.Texts.TPainterTextEffect;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   
   public class TOverlayerGiftBox extends TOverlayer
   {
      
      public static const TYPE_ALL:uint = 1;
      
      public static const TYPE_ONEOFALL:uint = 2;
      
      public static const TYPE_ONEOFALL_ADDITION:uint = 3;
      
      protected static const SIZE_WordWrapWidth:uint = 150;
      
      protected static const MAX_NUM:uint = 20;
      
      protected static const COLOR_Default:uint = 4290559164;
      
      protected static const SPECIAL_OFFSISE:uint = 8;
      
      protected static const SPECIAL_Text_OFFSISE:uint = 2;
      
      protected var FPainterCaption:TPainterTextEffect;
      
      protected var FPainterAdditionCaption:TPainterTextEffect;
      
      protected var FPainterInventories:Vector.<TPainterTextEffect>;
      
      protected var FPainterAdditionItems:Vector.<TPainterHtmlTextEffect>;
      
      protected var FBoundsAdditionCaption:TBounds;
      
      protected var FBoundsCaption:TBounds;
      
      protected var FBoundsInventories:Vector.<TBounds>;
      
      protected var FBoundsAdditionItems:Vector.<TBounds>;
      
      protected var FBoundsOffset:TBounds;
      
      protected var FOldItemQuantity:uint;
      
      protected var FOldType:uint;
      
      protected var FOldNormalCount:uint;
      
      protected var FOldAdditionItemCount:uint;
      
      protected var FOldSpecialIndex:int;
      
      protected var FOldNormalIDs:Vector.<uint>;
      
      protected var FOldAdditionIDs:Vector.<uint>;
      
      protected var FOldAdditionItemVec:Vector.<String>;
      
      public function TOverlayerGiftBox(param1:TUIComponent)
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TPainterTextEffect = null;
         var _loc5_:TPainterHtmlTextEffect = null;
         var _loc6_:TBounds = null;
         var _loc7_:TBounds = null;
         super(param1);
         FWordWrapWidth = SIZE_WordWrapWidth;
         this.FPainterCaption = ConstructPainterTextEffect();
         this.FBoundsCaption = new TBounds();
         this.FPainterAdditionCaption = ConstructPainterTextEffect();
         this.FBoundsAdditionCaption = new TBounds();
         this.FPainterInventories = new Vector.<TPainterTextEffect>(MAX_NUM);
         this.FBoundsInventories = new Vector.<TBounds>(MAX_NUM);
         this.FPainterAdditionItems = new Vector.<TPainterHtmlTextEffect>(MAX_NUM);
         this.FBoundsAdditionItems = new Vector.<TBounds>(MAX_NUM);
         this.FOldNormalIDs = new Vector.<uint>(MAX_NUM);
         this.FOldAdditionIDs = new Vector.<uint>(MAX_NUM);
         this.FOldAdditionItemVec = new Vector.<String>(MAX_NUM);
         _loc3_ = MAX_NUM;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ConstructPainterTextEffect(COLOR_Default);
            _loc6_ = new TBounds();
            this.FPainterInventories[_loc2_] = _loc4_;
            this.FBoundsInventories[_loc2_] = _loc6_;
            _loc5_ = this.ConstructPainterHtmlTextEffect(COLOR_Default);
            this.FPainterAdditionItems[_loc2_] = _loc5_;
            _loc7_ = new TBounds();
            this.FBoundsAdditionItems[_loc2_] = _loc7_;
            _loc2_++;
         }
      }
      
      override protected function ConstructPainterHtmlTextEffect(param1:uint = 4294958161) : TPainterHtmlTextEffect
      {
         var _loc2_:TPainterHtmlTextEffect = null;
         _loc2_ = super.ConstructPainterHtmlTextEffect(param1);
         _loc2_.WordWrapWidth = SIZE_WordWrapWidth;
         _loc2_.Multilineable = true;
         return _loc2_;
      }
      
      override protected function ContextVerificate(param1:Object) : Boolean
      {
         return param1 is TGiftBoxTipData;
      }
      
      override protected function ContextModified() : Boolean
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TGiftBoxTipData = null;
         var _loc4_:Boolean = false;
         var _loc5_:uint = 0;
         var _loc6_:String = null;
         return true;
      }
      
      override protected function ContextSynchronize() : void
      {
         var _loc1_:TGiftBoxTipData = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc1_ = FContext as TGiftBoxTipData;
         this.FOldNormalCount = _loc1_.NormalInventories.Count;
         if(_loc1_.AdditionInventories != null)
         {
            this.FOldAdditionItemCount = _loc1_.AdditionInventories.Count;
         }
         else if(_loc1_.AdditionItemVec.length != 0)
         {
            this.FOldAdditionItemCount = _loc1_.AdditionItemVec.length;
         }
         this.FOldType = _loc1_.AwardType;
         this.FOldSpecialIndex = _loc1_.SpecialIndex;
         _loc3_ = uint(_loc1_.NormalInventories.Count);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FOldNormalIDs[_loc2_] = _loc1_.NormalInventories.GetInventoryByIndex(_loc2_).IDTemplate;
            _loc2_++;
         }
         if(_loc1_.AdditionInventories != null)
         {
            _loc3_ = uint(_loc1_.AdditionInventories.Count);
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               this.FOldAdditionIDs[_loc2_] = _loc1_.AdditionInventories.GetInventoryByIndex(_loc2_).IDTemplate;
               _loc2_++;
            }
         }
         _loc3_ = _loc1_.AdditionItemVec.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FOldAdditionItemVec[_loc2_] = _loc1_.AdditionItemVec[_loc2_];
            _loc2_++;
         }
      }
      
      override protected function EvaluationPerform_Context() : void
      {
         var _loc1_:TGiftBoxTipData = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc1_ = FContext as TGiftBoxTipData;
         this.EvaluationPerform_Caption();
         this.FBoundsOffset = this.FBoundsCaption;
         this.EvaluationPerform_Inventories();
         this.FBoundsOffset = this.FBoundsInventories[MAX_NUM - this.FOldNormalCount];
         if(_loc1_.AwardType == TYPE_ONEOFALL_ADDITION)
         {
            this.EvaluationPerform_AdditionCaption();
            this.FBoundsOffset = this.FBoundsAdditionCaption;
            this.EvaluationPerform_AdditionInventories();
            this.FBoundsOffset = this.FBoundsAdditionItems[MAX_NUM - this.FOldAdditionItemCount];
            this.FPainterAdditionCaption.Visible = true;
         }
         else
         {
            this.FPainterAdditionCaption.Visible = false;
            _loc3_ = MAX_NUM;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               this.FPainterAdditionItems[_loc2_].Visible = false;
               _loc2_++;
            }
         }
      }
      
      protected function EvaluationPerform_Caption() : void
      {
         var _loc1_:TGiftBoxTipData = null;
         _loc1_ = FContext as TGiftBoxTipData;
         BoundsAlignDown(this.FBoundsCaption,null);
         if(_loc1_.CustomizeCaption != "")
         {
            this.FPainterCaption.Text = _loc1_.CustomizeCaption;
         }
         else
         {
            switch(this.FOldType)
            {
               case TYPE_ALL:
                  this.FPainterCaption.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_09);
                  break;
               case TYPE_ONEOFALL:
                  this.FPainterCaption.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_10);
                  break;
               case TYPE_ONEOFALL_ADDITION:
                  this.FPainterCaption.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_10);
            }
         }
         this.FPainterCaption.Evaluate(this.FBoundsCaption);
         BoundsContextUnion(this.FBoundsCaption);
      }
      
      protected function EvaluationPerform_Inventories() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TInventory = null;
         var _loc4_:TInventories = null;
         var _loc5_:TBounds = null;
         var _loc6_:TBounds = null;
         var _loc7_:TPainterTextEffect = null;
         var _loc8_:TGiftBoxTipData = null;
         _loc8_ = FContext as TGiftBoxTipData;
         _loc6_ = this.FBoundsOffset;
         _loc1_ = int(MAX_NUM);
         _loc4_ = _loc8_.NormalInventories;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc7_ = this.FPainterInventories[_loc2_];
            _loc5_ = this.FBoundsInventories[_loc2_];
            if(_loc2_ < _loc4_.Count)
            {
               _loc3_ = _loc4_.GetInventoryByIndex(_loc2_);
               BoundsAlignDown(_loc5_,_loc6_);
               if(_loc8_.SpecialIndex != -1)
               {
                  if(_loc2_ == _loc8_.SpecialIndex)
                  {
                     BoundsAlignDown(_loc5_,_loc6_,SPECIAL_OFFSISE);
                  }
                  if(_loc2_ >= _loc8_.SpecialIndex)
                  {
                     _loc7_.Font.Color = CONST_COMMON.QUALITYCOLOR_INDEX[_loc3_.Quality];
                  }
               }
               _loc7_.Text = _loc3_.Name + "*" + _loc3_.Quantity;
               if(_loc8_.NeedColour)
               {
                  _loc7_.Font.Color = CONST_COMMON.QUALITYCOLOR_INDEX[_loc3_.Quality];
               }
               _loc7_.Evaluate(_loc5_);
               BoundsContextUnion(_loc5_);
               _loc6_ = _loc5_;
               _loc7_.Visible = true;
            }
            else
            {
               _loc7_.Text = "";
               _loc7_.Visible = false;
            }
            _loc2_++;
         }
      }
      
      protected function EvaluationPerform_AdditionCaption() : void
      {
         BoundsAlignDown(this.FBoundsAdditionCaption,this.FBoundsInventories[this.FOldNormalCount - 1],SPECIAL_OFFSISE);
         this.FPainterAdditionCaption.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_11);
         this.FPainterAdditionCaption.Evaluate(this.FBoundsAdditionCaption);
         BoundsContextUnion(this.FBoundsAdditionCaption);
      }
      
      protected function EvaluationPerform_AdditionInventories() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TInventory = null;
         var _loc4_:TInventories = null;
         var _loc5_:TBounds = null;
         var _loc6_:TBounds = null;
         var _loc7_:TPainterHtmlTextEffect = null;
         var _loc8_:TGiftBoxTipData = null;
         var _loc9_:Vector.<String> = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         _loc8_ = FContext as TGiftBoxTipData;
         _loc6_ = this.FBoundsOffset;
         _loc1_ = int(MAX_NUM);
         if(_loc8_.AdditionItemVec.length != 0)
         {
            _loc9_ = _loc8_.AdditionItemVec;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc7_ = this.FPainterAdditionItems[_loc2_];
               _loc5_ = this.FBoundsAdditionItems[_loc2_];
               if(_loc2_ < _loc9_.length)
               {
                  BoundsAlignDown(_loc5_,_loc6_);
                  _loc10_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_03),CONST_COMMON.TextColor[1],_loc9_[_loc2_]);
                  _loc7_.Text = _loc10_;
                  _loc7_.Evaluate(_loc5_);
                  BoundsContextUnion(_loc5_);
                  _loc6_ = _loc5_;
                  _loc7_.Visible = true;
               }
               else
               {
                  _loc7_.Text = "";
                  _loc7_.Visible = false;
               }
               _loc2_++;
            }
         }
         else if(_loc8_.AdditionInventories != null)
         {
            _loc4_ = _loc8_.AdditionInventories;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc7_ = this.FPainterAdditionItems[_loc2_];
               _loc5_ = this.FBoundsAdditionItems[_loc2_];
               if(_loc2_ < _loc4_.Count)
               {
                  _loc3_ = _loc4_.GetInventoryByIndex(_loc2_);
                  BoundsAlignDown(_loc5_,_loc6_);
                  _loc11_ = _loc3_.Name + "*" + _loc3_.Quantity.toString();
                  _loc10_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_03),CONST_COMMON.TextColor[_loc3_.Quality],_loc11_);
                  _loc7_.Text = _loc10_;
                  _loc7_.Evaluate(_loc5_);
                  BoundsContextUnion(_loc5_);
                  _loc6_ = _loc5_;
                  _loc7_.Visible = true;
               }
               else
               {
                  _loc7_.Text = "";
                  _loc7_.Visible = false;
               }
               _loc2_++;
            }
         }
      }
      
      override protected function RenderingPerform_Context(param1:TCoordinate) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TBounds = null;
         var _loc5_:TPainterTextEffect = null;
         var _loc6_:TPainterHtmlTextEffect = null;
         FBoundsRendering.X = FMarginLeft;
         FBoundsRendering.Y = FMarginTop;
         this.FPainterCaption.X = FBoundsRendering.X + this.FBoundsCaption.X;
         this.FPainterCaption.Y = FBoundsRendering.Y + this.FBoundsCaption.Y;
         _loc3_ = int(this.FOldNormalCount);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = this.FPainterInventories[_loc2_];
            _loc4_ = this.FBoundsInventories[_loc2_];
            _loc5_.X = FBoundsRendering.X + _loc4_.X;
            _loc5_.Y = FBoundsRendering.Y + _loc4_.Y;
            _loc2_++;
         }
         if(this.FOldType == TYPE_ONEOFALL_ADDITION)
         {
            this.FPainterAdditionCaption.X = FBoundsRendering.X + this.FBoundsAdditionCaption.X;
            this.FPainterAdditionCaption.Y = FBoundsRendering.Y + this.FBoundsAdditionCaption.Y;
            _loc3_ = int(this.FOldAdditionItemCount);
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               _loc6_ = this.FPainterAdditionItems[_loc2_];
               _loc4_ = this.FBoundsAdditionItems[_loc2_];
               _loc6_.X = FBoundsRendering.X + _loc4_.X;
               _loc6_.Y = FBoundsRendering.Y + _loc4_.Y;
               _loc2_++;
            }
         }
      }
   }
}

