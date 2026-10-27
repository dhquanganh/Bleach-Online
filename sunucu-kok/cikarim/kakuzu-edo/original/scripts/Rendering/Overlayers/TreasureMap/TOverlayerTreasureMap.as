package Rendering.Overlayers.TreasureMap
{
   import Foundation.Common.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.Streamization.Inventories.*;
   import Processors.Game.Lobby.Utilities.*;
   import Rendering.Overlayers.*;
   import Rendering.Texts.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.text.*;
   
   public class TOverlayerTreasureMap extends TOverlayer
   {
      
      protected static const COLOR_ContextOddsAward:uint = 4294967295;
      
      protected static const COLOR_ContextRobbed:uint = 4284900966;
      
      protected static const QUALITYCOLOR_None:uint = 4294967295;
      
      protected static const QUALITYCOLOR_White:uint = 4294967295;
      
      protected static const QUALITYCOLOR_Green:uint = 4285071106;
      
      protected static const QUALITYCOLOR_Blue:uint = 4278228735;
      
      protected static const QUALITYCOLOR_Purple:uint = 4288217295;
      
      protected static const QUALITYCOLOR_Yellow:uint = 4294967040;
      
      protected static const QUALITYCOLOR_Red:uint = 4294836224;
      
      protected static const QUALITYCOLOR_Orange:uint = 4294901888;
      
      public static const QUALITYCOLOR_INDEX:Vector.<uint> = Vector.<uint>([QUALITYCOLOR_None,QUALITYCOLOR_White,QUALITYCOLOR_Green,QUALITYCOLOR_Blue,QUALITYCOLOR_Purple,QUALITYCOLOR_Yellow,QUALITYCOLOR_Red,QUALITYCOLOR_Orange]);
      
      protected var FPainterCaption:TPainterTextEffect;
      
      protected var FPainterTime:TPainterTextEffect;
      
      protected var FPainterOddsReward:TPainterTextEffect;
      
      protected var FPainterExplain:TPainterTextEffect;
      
      protected var FPainterRobbed:TPainterTextEffect;
      
      protected var FBoundsCaption:TBounds;
      
      protected var FBoundsTime:TBounds;
      
      protected var FBoundsOddsReward:TBounds;
      
      protected var FBoundsExplain:TBounds;
      
      protected var FBoundsRobbed:TBounds;
      
      protected var FContextCaption:String;
      
      protected var FContextTime:String;
      
      protected var FContextOddsReward:String;
      
      protected var FContextExplain:String;
      
      protected var FContextRobbed:String;
      
      protected var FBoundsOffsetY:TBounds;
      
      protected var FExplainTextFormat:TextFormat;
      
      protected var FIDTemplates:Vector.<uint>;
      
      protected var FInventories:TInventories;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      public function TOverlayerTreasureMap(param1:TUIComponent)
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TPainterTextEffect = null;
         var _loc5_:TBounds = null;
         super(param1);
         this.FPainterCaption = ConstructPainterTextEffect(COLOR_ContextDefault);
         this.FBoundsCaption = new TBounds();
         this.FPainterTime = ConstructPainterTextEffect(COLOR_ContextDefault);
         this.FBoundsTime = new TBounds();
         this.FPainterOddsReward = ConstructPainterTextEffect(COLOR_ContextOddsAward);
         this.FBoundsOddsReward = new TBounds();
         this.FPainterExplain = ConstructPainterTextEffect(COLOR_ContextDefault);
         this.FBoundsExplain = new TBounds();
         this.FPainterRobbed = ConstructPainterTextEffect(COLOR_ContextRobbed);
         this.FBoundsRobbed = new TBounds();
         this.FExplainTextFormat = new TextFormat();
         this.FIDTemplates = new Vector.<uint>();
         this.FInventories = new TInventories();
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
      }
      
      override protected function ContextVerificate(param1:Object) : Boolean
      {
         return param1 is TDigging;
      }
      
      override protected function ContextSynchronize() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FPainterCaption.Text = "";
         this.FContextCaption = "";
         this.FPainterOddsReward.Text = "";
         this.FContextOddsReward = "";
         this.FPainterTime.Text = "";
         this.FContextTime = "";
         this.FPainterExplain.Text = "";
         this.FContextExplain = "";
         this.FPainterRobbed.Text = "";
         this.FContextRobbed = "";
      }
      
      override protected function EvaluationPerform_Context() : void
      {
         this.EvaluationPerform_Caption();
         this.FBoundsOffsetY = this.FBoundsCaption;
         this.EvaluationPerform_ContextTime();
         this.FBoundsOffsetY = this.FBoundsTime;
         this.EvaluationPerform_ContextOddsReward();
         this.FBoundsOffsetY = this.FBoundsOddsReward;
         this.EvaluationPerform_Explain();
         this.FBoundsOffsetY = this.FBoundsExplain;
         this.EvaluationPerform_ContextRobbed();
         this.FBoundsOffsetY = this.FBoundsRobbed;
      }
      
      protected function EvaluationPerform_Caption() : void
      {
         var _loc1_:TDigging = null;
         _loc1_ = FContext as TDigging;
         BoundsAlignDown(this.FBoundsCaption);
         this.FContextCaption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_19);
         this.FPainterCaption.Text = this.FContextCaption + "\n";
         this.FPainterCaption.Text += this.MakeRobRewardStr(_loc1_.Award1Vect) + "\n";
         this.FPainterCaption.Evaluate(this.FBoundsCaption);
         BoundsContextUnion(this.FBoundsCaption);
      }
      
      protected function MakeRobRewardStr(param1:Vector.<Object>) : String
      {
         var _loc2_:TDigging = null;
         var _loc3_:Vector.<Object> = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         _loc3_ = param1;
         _loc6_ = "";
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(_loc4_ != 0)
            {
               _loc6_ += ",";
            }
            _loc5_ = int(_loc3_[_loc4_].amount);
            _loc6_ += _loc5_ + TUtilityLobby.GetItemName(_loc3_[_loc4_].type,_loc3_[_loc4_].code);
            _loc4_++;
         }
         return _loc6_;
      }
      
      protected function EvaluationPerform_ContextTime() : void
      {
         var _loc1_:TDigging = null;
         BoundsAlignDown(this.FBoundsTime);
         _loc1_ = FContext as TDigging;
         this.FContextTime = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_20),_loc1_.Digtime / 60);
         this.FPainterTime.Text = this.FContextTime + "\n";
         this.FPainterTime.Evaluate(this.FBoundsTime);
         BoundsContextUnion(this.FBoundsTime);
      }
      
      protected function EvaluationPerform_ContextOddsReward() : void
      {
         BoundsAlignDown(this.FBoundsOddsReward);
         this.FContextOddsReward = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_21);
         this.FPainterOddsReward.Text = this.FContextOddsReward + "\n";
         this.FPainterOddsReward.Evaluate(this.FBoundsOddsReward);
         BoundsContextUnion(this.FBoundsOddsReward);
      }
      
      protected function EvaluationPerform_Explain() : void
      {
         var _loc1_:TDigging = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TInventory = null;
         _loc1_ = FContext as TDigging;
         this.FContextExplain = "";
         this.FIDTemplates.length = 0;
         _loc3_ = int(_loc1_.Award2Vect.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FIDTemplates.push(_loc1_.Award2Vect[_loc2_].code);
            _loc2_++;
         }
         this.FInventories.Clear();
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,this.FInventories,this.FIDTemplates);
         _loc2_ = 0;
         while(_loc2_ < this.FInventories.Count)
         {
            _loc4_ = this.FInventories.GetInventoryByIndex(_loc2_);
            this.FContextExplain += _loc4_.Name + "x" + _loc1_.Award2Vect[_loc2_].amount + ",\n";
            _loc2_++;
         }
         BoundsAlignDown(this.FBoundsExplain);
         this.FPainterExplain.Text = this.FContextExplain;
         this.FPainterExplain.Evaluate(this.FBoundsExplain);
         BoundsContextUnion(this.FBoundsExplain);
      }
      
      protected function EvaluationPerform_ContextRobbed() : void
      {
         var _loc1_:TDigging = null;
         _loc1_ = FContext as TDigging;
         BoundsAlignDown(this.FBoundsRobbed);
         this.FContextRobbed = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_22) + "\n";
         this.FPainterRobbed.Text = this.FContextRobbed;
         this.FPainterRobbed.Text += this.MakeRobRewardStr(_loc1_.RobGetReward);
         this.FPainterRobbed.Evaluate(this.FBoundsRobbed);
         BoundsContextUnion(this.FBoundsRobbed);
      }
      
      override protected function SketchingPerform_Context() : void
      {
         this.SketchingPerform_Caption();
         this.SketchingPerform_AppendAttributes();
         this.SketchingPerform_AppendNextAttributes();
         this.SketchingPerform_Explain();
         this.SketchingPerform_Robbed();
      }
      
      protected function SketchingPerform_Caption() : void
      {
         this.FBoundsCaption.Width = FBoundsContext.Width;
         this.FPainterCaption.RenderBounds(this.FBoundsCaption,TAlignment.HORIZONTAL_Center);
      }
      
      protected function SketchingPerform_AppendAttributes() : void
      {
         this.FPainterOddsReward.RenderBounds(this.FBoundsOddsReward,TAlignment.HORIZONTAL_Center);
      }
      
      protected function SketchingPerform_AppendNextAttributes() : void
      {
         this.FPainterTime.RenderBounds(this.FBoundsTime,TAlignment.HORIZONTAL_Center);
      }
      
      protected function SketchingPerform_Explain() : void
      {
         var _loc1_:TInventory = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         this.FPainterExplain.RenderBounds(this.FBoundsExplain,TAlignment.HORIZONTAL_Center);
         _loc4_ = 0;
         while(_loc4_ < this.FInventories.Count)
         {
            _loc1_ = this.FInventories.GetInventoryByIndex(_loc4_);
            this.FExplainTextFormat.color = QUALITYCOLOR_INDEX[_loc1_.Quality];
            _loc3_ = this.FContextExplain.indexOf(",",_loc2_ + 1);
            this.FPainterExplain.SetTextFormat(this.FExplainTextFormat,_loc2_,_loc3_);
            _loc2_ = _loc3_;
            _loc4_++;
         }
      }
      
      protected function SketchingPerform_Robbed() : void
      {
         this.FPainterRobbed.RenderBounds(this.FBoundsRobbed,TAlignment.HORIZONTAL_Center);
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
         this.FPainterTime.x = FBoundsRendering.X;
         this.FPainterTime.y = FBoundsRendering.Y + this.FBoundsTime.Y;
         this.FPainterOddsReward.x = FBoundsRendering.X;
         this.FPainterOddsReward.y = FBoundsRendering.Y + this.FBoundsOddsReward.Y;
         this.FPainterExplain.x = FBoundsRendering.X;
         this.FPainterExplain.y = FBoundsRendering.Y + this.FBoundsExplain.Y;
         this.FPainterRobbed.x = FBoundsRendering.X;
         this.FPainterRobbed.y = FBoundsRendering.Y + this.FBoundsRobbed.Y;
      }
   }
}

