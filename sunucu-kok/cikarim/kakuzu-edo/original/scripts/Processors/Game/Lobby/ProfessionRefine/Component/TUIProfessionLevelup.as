package Processors.Game.Lobby.ProfessionRefine.Component
{
   import Components.Standard.TUITab;
   import Foundation.UI.TUIComponent;
   import Logics.SLogicsCore;
   import Processors.Game.ComponentNew.TUICustomComponent;
   import Processors.Game.ComponentNew.TUtilityMovieClip;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class TUIProfessionLevelup extends TUICustomComponent
   {
      
      protected static const TAB_NUM:int = 4;
      
      protected var FUITab:TUITab;
      
      protected var FTabIndex:int;
      
      protected var FMCIconVec:Vector.<MovieClip>;
      
      protected var FTFLevelVec:Vector.<TextField>;
      
      protected var FUILevelupInfo:TUILevelupInfo;
      
      public function TUIProfessionLevelup(param1:TUIComponent)
      {
         super();
         FParent = param1;
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:TextField = null;
         this.FUITab = new TUITab(FParent);
         _loc2_ = TAB_NUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FUITab.SetTabByIndex(FResource["Tab_" + _loc1_],_loc1_);
            _loc1_++;
         }
         this.FUITab.OnSwitch = this.TabOnSwitch;
         this.FUITab.Init();
         this.FTabIndex = 0;
         _loc2_ = GetUIComponentsCapacity(FResource,"Tab_");
         this.FMCIconVec = new Vector.<MovieClip>(_loc2_);
         this.FTFLevelVec = new Vector.<TextField>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = FResource["Tab_" + _loc1_]["MC_HeroType"];
            _loc3_.mouseChildren = false;
            _loc3_.mouseEnabled = false;
            TUtilityMovieClip.StopMovieClipAction(_loc3_);
            _loc3_.gotoAndStop(_loc1_ + 1);
            this.FMCIconVec[_loc1_] = _loc3_;
            _loc4_ = FResource["Tab_" + _loc1_]["TF_Level"];
            _loc4_.mouseEnabled = false;
            this.FTFLevelVec[_loc1_] = _loc4_;
            _loc1_++;
         }
         this.FUILevelupInfo = new TUILevelupInfo(FParent);
         this.FUILevelupInfo.Resource = FResource["SP_LevelupInfo"];
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.UpdateUI();
         _loc2_ = int(this.FTFLevelVec.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTFLevelVec[_loc1_].text = SLogicsCore.ProfessionRefineList.GetProfessionRefineById(_loc1_ + 1).CurLevel + "";
            _loc1_++;
         }
         this.UpdateLevelupInfo();
      }
      
      protected function UpdateLevelupInfo() : void
      {
         this.FUILevelupInfo.UserData = SLogicsCore.ProfessionRefineList.GetProfessionRefineById(this.FTabIndex + 1);
         this.FUILevelupInfo.Show();
      }
      
      protected function TabOnSwitch(param1:Object) : void
      {
         this.FTabIndex = param1 as int;
         this.UpdateLevelupInfo();
      }
      
      override public function Reset() : void
      {
         this.FUILevelupInfo.Reset();
         super.Reset();
      }
      
      public function LogicsPerform() : void
      {
         this.FUILevelupInfo.LogicsPerform();
      }
      
      public function LevelupSuccess(param1:int) : void
      {
         this.FTFLevelVec[param1 - 1].text = SLogicsCore.ProfessionRefineList.GetProfessionRefineById(param1).CurLevel + "";
         this.FUILevelupInfo.LevelupSuccess();
      }
   }
}

