package Processors.Game.Lobby.Activity.HDSoulCarnival.windows
{
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.THDSoulRecharge;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDSoulCarnival.TSoulRecharge;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDSoulCarnival.TUIComponent.TUIBar;
   import flash.display.Sprite;
   
   public class TProcessorHDWindowSoulRecharge extends TProcessorHDSingleWindowBase
   {
      
      protected var FBars:Vector.<TUIBar>;
      
      protected var FData:TSoulRecharge;
      
      public function TProcessorHDWindowSoulRecharge(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:THDSoulRecharge = null;
         super.UpdateUIConfig();
         _loc3_ = FHDActivityConfig as THDSoulRecharge;
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this.FData = param1 as TSoulRecharge;
         _loc3_ = 5;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FBars[_loc2_].Update(this.FData.Config.Recharge[_loc2_].gold,this.FData.Count[_loc2_],this.FData.InvsVect[_loc2_],FActivityAtoms.Identifier);
            _loc2_++;
         }
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.LogicsPerform();
         _loc2_ = 5;
         if(Visible && this.FData != null)
         {
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FBars[_loc1_].LogicsPerform();
               _loc1_++;
            }
         }
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.InitWindow(param1);
         _loc2_ = 5;
         this.FBars = new Vector.<TUIBar>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FBars[_loc3_] = new TUIBar(this);
            this.FBars[_loc3_].UIDispatch(FScene["MC_Item_" + _loc3_],_loc3_);
            _loc3_++;
         }
      }
   }
}

