package Processors.Game.Lobby.HeroCompanion.Components.PropertyScroll
{
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.Json.TCompanionProperty;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_HEROCOMPANION;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class TCompanionScrollPropertyRender extends Sprite
   {
      
      protected const Table:Vector.<int> = CONST_HEROCOMPANION.PositionTable;
      
      protected const SPACE:int = 10;
      
      protected var FMainUI:Sprite;
      
      protected var FMCPosition:MovieClip;
      
      protected var FTFDesc:TextField;
      
      public function TCompanionScrollPropertyRender()
      {
         super();
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance(CONST_HEROCOMPANION.ResourceID_PosRender) as Sprite;
         addChild(this.FMainUI);
         this.FMCPosition = this.FMainUI["MC_Pos"];
         this.FTFDesc = this.FMainUI["TF_Desc"];
         this.FTFDesc.autoSize = TextFieldAutoSize.LEFT;
      }
      
      public function SetData(param1:Vector.<TCompanionProperty>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Vector.<int> = null;
         var _loc6_:Vector.<Number> = null;
         var _loc7_:Vector.<int> = null;
         var _loc8_:int = 0;
         var _loc9_:TCompanionProperty = null;
         var _loc10_:TCompanionProperty = null;
         _loc2_ = this.Table.indexOf(param1[0].Pos);
         if(_loc2_ != -1)
         {
            this.FMCPosition.gotoAndStop(_loc2_ + 1);
         }
         _loc5_ = new Vector.<int>();
         _loc6_ = new Vector.<Number>();
         _loc7_ = new Vector.<int>();
         _loc3_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc9_ = param1[_loc2_];
            _loc8_ = _loc5_.indexOf(_loc9_.Type);
            if(_loc8_ == -1)
            {
               _loc5_.push(_loc9_.Type);
               _loc6_.push(_loc9_.Value);
               _loc7_.push(_loc9_.Oper);
            }
            else
            {
               _loc6_[_loc8_] += _loc9_.Value;
            }
            _loc2_++;
         }
         _loc4_ = "";
         _loc3_ = int(_loc6_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ += TUtilityLobby.GetAttributeName(_loc5_[_loc2_]) + " +";
            if(_loc7_[_loc2_] == CONST_HEROCOMPANION.Oper_Type_Add)
            {
               _loc4_ += _loc6_[_loc2_] + "\n";
            }
            else
            {
               _loc4_ += Number(_loc6_[_loc2_] * 100).toFixed(2) + "%\n";
            }
            _loc2_++;
         }
         this.FTFDesc.text = _loc4_;
      }
   }
}

