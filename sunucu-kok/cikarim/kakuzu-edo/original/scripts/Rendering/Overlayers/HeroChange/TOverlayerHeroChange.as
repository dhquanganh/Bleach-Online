package Rendering.Overlayers.HeroChange
{
   import Foundation.Common.*;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Characters.THero;
   import Logics.DatebaseVO.VO.*;
   import Logics.HeroChange.*;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Rendering.Overlayers.*;
   import Rendering.Texts.*;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.text.*;
   import ghostcat.util.data.Json;
   
   public class TOverlayerHeroChange extends TOverlayer
   {
      
      protected static const COLOR_ContextDefault:uint = 4294967295;
      
      protected static const COLOR_ContextValue:uint = 4294967040;
      
      protected static const COLOR_ContextName:uint = 4294934528;
      
      protected static const COLOR_ContextDesc:uint = 4291335780;
      
      protected static const SIZE_Padding_01:uint = 15;
      
      protected static const SIZE_Padding_02:uint = 10;
      
      protected static const SIZE_Padding_03:uint = 5;
      
      protected static const SIZE_DividingLine_Max_Width:int = 248;
      
      protected static const COLOR_Context_Green:uint = 4285071106;
      
      protected var FPainterTitle:TPainterTextEffect;
      
      protected var FDividingLines:Vector.<Bitmap>;
      
      protected var FPainterCaptions:Vector.<TPainterTextEffect>;
      
      protected var FPainterNames:Vector.<TPainterTextEffect>;
      
      protected var FPainterDescs:Vector.<TPainterTextEffect>;
      
      protected var FBoundsDividLine:Vector.<TBounds>;
      
      protected var FBoundsTalentName:Vector.<TBounds>;
      
      protected var FBoundsCaptions:Vector.<TBounds>;
      
      protected var FBoundsNames:Vector.<TBounds>;
      
      protected var FBoundsDescs:Vector.<TBounds>;
      
      protected var FBoundsTitle:TBounds;
      
      protected var FBoundsOffset:TBounds;
      
      protected var FTextFormat:TextFormat;
      
      protected var FContextResourceID:uint;
      
      protected var FChangeLevelNames:Vector.<String>;
      
      public function TOverlayerHeroChange(param1:TUIComponent)
      {
         super(param1);
         this.FPainterTitle = ConstructPainterTextEffect(COLOR_ContextValue);
         this.FPainterTitle.Font.Size = 14;
         this.FBoundsTitle = new TBounds();
         this.FDividingLines = new Vector.<Bitmap>();
         this.FPainterCaptions = new Vector.<TPainterTextEffect>();
         this.FPainterNames = new Vector.<TPainterTextEffect>();
         this.FPainterDescs = new Vector.<TPainterTextEffect>();
         this.FBoundsDividLine = new Vector.<TBounds>();
         this.FBoundsTalentName = new Vector.<TBounds>();
         this.FBoundsCaptions = new Vector.<TBounds>();
         this.FBoundsNames = new Vector.<TBounds>();
         this.FBoundsDescs = new Vector.<TBounds>();
         FWordWrapWidth = SIZE_DividingLine_Max_Width;
         this.FTextFormat = new TextFormat();
         FMarginLeft = 15;
         FMarginTop = 15;
         FMarginRight = 15;
         FMarginBottom = 15;
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
      }
      
      override protected function ContextVerificate(param1:Object) : Boolean
      {
         return param1 is THeroChange;
      }
      
      override protected function ContextModified() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:THeroChange = null;
         _loc2_ = FContext as THeroChange;
         return this.FContextResourceID != _loc2_.Hero.Identifier;
      }
      
      override protected function ContextSynchronize() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:THeroChange = null;
         var _loc4_:TPainterTextEffect = null;
         _loc3_ = FContext as THeroChange;
         this.ConstructTips(_loc3_);
         this.FContextResourceID = _loc3_.Hero.Identifier;
      }
      
      protected function ConstructTips(param1:THeroChange) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Bitmap = null;
         var _loc5_:TPainterTextEffect = null;
         var _loc6_:TBounds = null;
         _loc3_ = int(param1.PartnerChanges.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(_loc2_ >= this.FPainterDescs.length)
            {
               _loc4_ = new Bitmap();
               addChild(_loc4_);
               _loc4_.bitmapData = FDividingLine;
               this.FDividingLines.push(_loc4_);
               _loc5_ = ConstructPainterTextEffect(COLOR_ContextDefault);
               _loc5_.Font.Bold = true;
               this.FPainterCaptions.push(_loc5_);
               _loc5_ = ConstructPainterTextEffect(COLOR_ContextName);
               this.FPainterNames.push(_loc5_);
               _loc5_ = ConstructPainterTextEffect(COLOR_ContextDesc);
               this.FPainterDescs.push(_loc5_);
               this.FBoundsDividLine.push(new TBounds());
               this.FBoundsTalentName.push(new TBounds());
               this.FBoundsCaptions.push(new TBounds());
               this.FBoundsNames.push(new TBounds());
               this.FBoundsDescs.push(new TBounds());
            }
            this.FDividingLines[_loc2_].visible = true;
            this.FPainterCaptions[_loc2_].Visible = true;
            this.FPainterNames[_loc2_].Visible = true;
            this.FPainterDescs[_loc2_].Visible = true;
            _loc2_++;
         }
         _loc3_ = int(this.FPainterDescs.length);
         _loc2_ = int(param1.PartnerChanges.length);
         while(_loc2_ < _loc3_)
         {
            this.FDividingLines[_loc2_].visible = false;
            this.FPainterCaptions[_loc2_].Visible = false;
            this.FPainterNames[_loc2_].Visible = false;
            this.FPainterDescs[_loc2_].Visible = false;
            _loc2_++;
         }
         if(this.FChangeLevelNames == null)
         {
            this.FChangeLevelNames = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_18);
         }
      }
      
      override protected function EvaluationPerform_Context() : void
      {
         var _loc1_:THeroChange = null;
         _loc1_ = FContext as THeroChange;
         this.EvaluationPerform_Title(_loc1_);
         this.FBoundsOffset = this.FBoundsTitle;
         this.EvaluationPerform_Talents(_loc1_);
      }
      
      protected function EvaluationPerform_Title(param1:THeroChange) : void
      {
         var _loc2_:int = 0;
         BoundsAlignDown(this.FBoundsTitle);
         this.FPainterTitle.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_33);
         this.FPainterTitle.Evaluate(this.FBoundsTitle);
         BoundsContextUnion(this.FBoundsTitle);
      }
      
      protected function EvaluationPerform_Talents(param1:THeroChange) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TPartnerChange = null;
         var _loc5_:TBounds = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Boolean = false;
         var _loc9_:THero = null;
         _loc3_ = int(param1.PartnerChanges.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc8_ = param1.Hero.ChangeSchedule > _loc2_;
            _loc5_ = this.FBoundsDividLine[_loc2_];
            BoundsAlignDown(_loc5_,this.FBoundsOffset,SIZE_Padding_02);
            _loc5_.Width = SIZE_DividingLine_Max_Width;
            _loc5_.X = 0;
            BoundsContextUnion(_loc5_);
            this.FBoundsOffset = _loc5_;
            _loc4_ = param1.PartnerChanges[_loc2_];
            _loc5_ = this.FBoundsCaptions[_loc2_];
            BoundsAlignDown(_loc5_,this.FBoundsOffset,SIZE_Padding_02);
            this.FPainterCaptions[_loc2_].Text = this.FChangeLevelNames[_loc2_];
            if(_loc8_)
            {
               this.FPainterCaptions[_loc2_].Font.Color = COLOR_Context_Green;
            }
            else
            {
               this.FPainterCaptions[_loc2_].Font.Color = COLOR_ContextDefault;
            }
            this.FPainterCaptions[_loc2_].Evaluate(_loc5_);
            BoundsContextUnion(_loc5_);
            this.FBoundsOffset = _loc5_;
            _loc5_ = this.FBoundsNames[_loc2_];
            BoundsAlignRight(_loc5_,this.FBoundsOffset,SIZE_Padding_02);
            this.FPainterNames[_loc2_].Text = _loc4_.Name;
            if(_loc8_)
            {
               this.FPainterNames[_loc2_].Font.Color = COLOR_Context_Green;
               _loc9_ = SLogicsCore.Character.Heros.GetHeroByIdentifier(param1.Hero.Identifier);
               if(_loc9_.AdvanceChanges[_loc2_] != null && _loc9_.AdvanceChanges[_loc2_][0] != 0)
               {
                  this.FPainterNames[_loc2_].Text = this.GetDescByIDValue(_loc9_.AdvanceChanges[_loc2_][0],_loc9_.AdvanceChanges[_loc2_][1]).name;
               }
            }
            else
            {
               this.FPainterNames[_loc2_].Font.Color = COLOR_ContextName;
            }
            this.FPainterNames[_loc2_].Evaluate(_loc5_);
            BoundsContextUnion(_loc5_);
            this.FBoundsOffset = _loc5_;
            _loc5_ = this.FBoundsDescs[_loc2_];
            BoundsAlignDown(_loc5_,this.FBoundsOffset);
            this.FPainterDescs[_loc2_].Text = _loc4_.Desc;
            if(_loc8_)
            {
               this.FPainterDescs[_loc2_].Font.Color = COLOR_Context_Green;
               if(_loc9_.AdvanceChanges[_loc2_] != null && _loc9_.AdvanceChanges[_loc2_][0] != 0)
               {
                  this.FPainterDescs[_loc2_].Text = this.GetDescByIDValue(_loc9_.AdvanceChanges[_loc2_][0],_loc9_.AdvanceChanges[_loc2_][1]).desc;
               }
            }
            else
            {
               this.FPainterDescs[_loc2_].Font.Color = COLOR_ContextDesc;
            }
            this.FPainterDescs[_loc2_].Evaluate(_loc5_);
            _loc5_.X = 0;
            BoundsContextUnion(_loc5_);
            this.FBoundsOffset = _loc5_;
            _loc2_++;
         }
      }
      
      override protected function SketchingPerform_Context() : void
      {
         this.SketchingPerform_Caption();
      }
      
      protected function SketchingPerform_Caption() : void
      {
      }
      
      override protected function RenderingPerform_Context(param1:TCoordinate) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:THeroChange = null;
         _loc4_ = FContext as THeroChange;
         FBoundsRendering.X = FMarginLeft;
         FBoundsRendering.Y = FMarginTop;
         this.FPainterTitle.X = FBoundsRendering.X + this.FBoundsTitle.X;
         this.FPainterTitle.Y = FBoundsRendering.Y + this.FBoundsTitle.Y;
         _loc3_ = int(_loc4_.PartnerChanges.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FDividingLines[_loc2_].x = FBoundsRendering.X + this.FBoundsDividLine[_loc2_].X;
            this.FDividingLines[_loc2_].y = FBoundsRendering.Y + this.FBoundsDividLine[_loc2_].Y;
            this.FDividingLines[_loc2_].width = SIZE_DividingLine_Max_Width;
            this.FPainterCaptions[_loc2_].X = FBoundsRendering.X + this.FBoundsCaptions[_loc2_].X;
            this.FPainterCaptions[_loc2_].Y = FBoundsRendering.Y + this.FBoundsCaptions[_loc2_].Y;
            this.FPainterNames[_loc2_].X = FBoundsRendering.X + this.FBoundsNames[_loc2_].X;
            this.FPainterNames[_loc2_].Y = FBoundsRendering.Y + this.FBoundsNames[_loc2_].Y;
            this.FPainterDescs[_loc2_].X = FBoundsRendering.X + this.FBoundsDescs[_loc2_].X;
            this.FPainterDescs[_loc2_].Y = FBoundsRendering.Y + this.FBoundsDescs[_loc2_].Y;
            _loc2_++;
         }
      }
      
      protected function GetDescByIDValue(param1:uint, param2:uint) : Object
      {
         var _loc3_:TPantnerAdvanceChange = null;
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:Vector.<String> = null;
         _loc4_ = new Object();
         if(param1 == 105)
         {
            _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_AdvanceChange,param1) as TPantnerAdvanceChange;
            _loc4_.name = _loc3_.Desc;
            _loc5_ = uint(_loc3_.Value.indexOf(param2));
            _loc6_ = Vector.<String>(Json.decode(_loc3_.ClientDeec));
            _loc4_.desc = _loc6_[_loc5_];
         }
         else
         {
            _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_AdvanceChange,param1) as TPantnerAdvanceChange;
            _loc4_.name = _loc3_.Desc;
            _loc4_.desc = _loc3_.ClientDeec + param2.toString() + "%";
         }
         return _loc4_;
      }
   }
}

