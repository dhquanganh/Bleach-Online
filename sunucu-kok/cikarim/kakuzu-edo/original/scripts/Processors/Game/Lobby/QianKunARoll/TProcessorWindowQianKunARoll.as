package Processors.Game.Lobby.QianKunARoll
{
   import Components.ComboBox.*;
   import Components.SelectBox.*;
   import Components.Standard.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.InteractionLog.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.QianKunARoll.Component.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.UI.Overlayers.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowQianKunARoll extends TProcessorLobbyWindow
   {
      
      protected static const MAX_SelectBoxCount:int = 2;
      
      protected static const MAX_ComboBoxCount:int = 2;
      
      protected static const MAX_RewardBoxCount:int = 3;
      
      protected static const MAX_BarInitWidth:int = 518;
      
      protected static const GAMBLEREWARD_LevelVect:Vector.<int> = CONST_QIANKUNAROLL.GAMBLEREWARD_LevelVect;
      
      protected static const GAMBLEREWARD_IDVect:Vector.<int> = CONST_QIANKUNAROLL.GAMBLEREWARD_IDVect;
      
      protected static const TYPE_Silver:uint = 0;
      
      protected static const TYPE_Gold:uint = 1;
      
      protected var FMC:MovieClip;
      
      protected var FMC_ARoll:MovieClip;
      
      protected var FTF_Log:TextField;
      
      protected var FBtn_Start:TUIButton;
      
      protected var FMC_ScoreLoadingBar:MovieClip;
      
      protected var FMC_Result:MovieClip;
      
      protected var FMC_MyDiceContainer:MovieClip;
      
      protected var FMC_OppoDiceContainer:MovieClip;
      
      protected var FMC_MyDice:MovieClip;
      
      protected var FMC_OppoDice:MovieClip;
      
      protected var FTF_GambleTimes:TextField;
      
      protected var FBoxVect:Vector.<MovieClip>;
      
      protected var FSelectBoxVect:Vector.<TSelectBoxSingle>;
      
      protected var FComboBoxSilver:TComboBox;
      
      protected var FComboBoxGold:TComboBox;
      
      protected var FUISelectBox:TSelectBoxSingle;
      
      protected var FCostID:int;
      
      protected var FSilverCostVect:Vector.<String>;
      
      protected var FGoldCostVect:Vector.<String>;
      
      protected var FSilverWinRewardVect:Vector.<Object>;
      
      protected var FGoldWinRewardVect:Vector.<Object>;
      
      protected var FCostType:int;
      
      protected var FBoxStatusVect:Vector.<int>;
      
      protected var FLogVect:Vector.<String>;
      
      protected var FBoxScoreVect:Vector.<int>;
      
      protected var FBoxRewardIDVect:Vector.<int>;
      
      protected var FSelectBoxIndex:int;
      
      protected var FComboBoxSilverIndex:uint;
      
      protected var FComboBoxGoldIndex:uint;
      
      protected var FIsWin:Boolean;
      
      protected var FIsStartRoll:Boolean;
      
      protected var FIsShow:Boolean;
      
      protected var FMyDicePoint:int;
      
      protected var FOppoDicePoint:int;
      
      protected var FCurScore:int;
      
      protected var FMaxScore:int;
      
      protected var FCurGambleTimes:int;
      
      protected var FTotalGambleTimes:int;
      
      protected var FHomeGambleBin:TBins;
      
      protected var FHomeGambleCostBin:TBins;
      
      protected var FHomeGambleBoxBin:TBins;
      
      protected var FCharacter:TCharacter;
      
      protected var FLevel:uint;
      
      protected var FOverlayerGambleBox:TOverlayerGambleBox;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FOnStartRoll:Function;
      
      protected var FOnGetBoxReward:Function;
      
      public function TProcessorWindowQianKunARoll(param1:TUIComponent)
      {
         super(param1);
         this.FBoxVect = new Vector.<MovieClip>();
         this.FSelectBoxVect = new Vector.<TSelectBoxSingle>();
         this.FSilverCostVect = new Vector.<String>();
         this.FGoldCostVect = new Vector.<String>();
         this.FSilverWinRewardVect = new Vector.<Object>();
         this.FGoldWinRewardVect = new Vector.<Object>();
         this.FLogVect = new Vector.<String>();
         this.FUISelectBox = new TSelectBoxSingle();
         this.FBtn_Start = new TUIButton();
         this.FBoxStatusVect = new Vector.<int>();
         this.FBoxScoreVect = new Vector.<int>();
         this.FBoxRewardIDVect = new Vector.<int>();
         this.FSelectBoxIndex = 0;
         this.FMyDicePoint = -1;
         this.FOppoDicePoint = -1;
         this.FIsWin = false;
         this.FIsStartRoll = false;
         this.FIsShow = false;
         this.FComboBoxGoldIndex = 0;
         this.FComboBoxSilverIndex = 0;
         this.FCharacter = SLogicsCore.Character;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_QIANKUNAROLL.RESOURCESID_Swf_QianKunARoll);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FHomeGambleBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_HomeGamble) as TBins;
         this.FHomeGambleCostBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_HomeGambleCost) as TBins;
         this.FHomeGambleBoxBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_HomeGambleBox) as TBins;
         this.InitQianKunARoll();
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      override protected function ResourcesPerform_UIFinalize() : void
      {
         super.ResourcesPerform_UIFinalize();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(this.FIsStartRoll)
         {
            if(this.FMC_MyDiceContainer.currentFrame == 30 && this.FMC_OppoDiceContainer.currentFrame == 30 && this.FIsShow)
            {
               this.ShowDiceContainer();
            }
            if(this.FMC_MyDiceContainer.currentFrame == this.FMC_MyDiceContainer.totalFrames && this.FMC_OppoDiceContainer.currentFrame == this.FMC_OppoDiceContainer.totalFrames)
            {
               this.FIsStartRoll = false;
               this.FIsShow = false;
               this.UpdateUI();
            }
            else
            {
               this.FBtn_Start.Enabled = false;
            }
         }
         if(this.FMC_MyDiceContainer != null && this.FMC_OppoDiceContainer != null)
         {
            if(this.FMC_MyDiceContainer.currentFrame == 48 && this.FMC_OppoDiceContainer.currentFrame == 48)
            {
               this.FMC_Result.visible = true;
               this.FMC_Result.gotoAndPlay(1);
            }
         }
      }
      
      protected function InitQianKunARoll() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:Vector.<DisplayObject> = null;
         var _loc5_:DisplayObject = null;
         var _loc6_:THomeGambleBox = null;
         var _loc7_:String = null;
         var _loc8_:TextField = null;
         if(this.FMC == null)
         {
            return;
         }
         this.FOverlayerGambleBox = new TOverlayerGambleBox(this.Parent);
         this.FOverlayerGambleBox.Visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerGambleBox);
         this.SetBinsData();
         this.FMC_ARoll = this.FMC[CONST_QIANKUNAROLL.RESOURCE_Link_MC_ARoll];
         this.FMC_MyDiceContainer = this.FMC_ARoll[CONST_QIANKUNAROLL.RESOURCE_Link_MC_MyDiceContainer];
         this.FMC_MyDiceContainer.gotoAndStop(1);
         this.FMC_OppoDiceContainer = this.FMC_ARoll[CONST_QIANKUNAROLL.RESOURCE_Link_MC_OppoDiceContainer];
         this.FMC_OppoDiceContainer.gotoAndStop(1);
         this.FMC_MyDice = this.FMC_ARoll[CONST_QIANKUNAROLL.RESOURCE_Link_MC_MyDice];
         this.FMC_OppoDice = this.FMC_ARoll[CONST_QIANKUNAROLL.RESOURCE_Link_MC_OppoDice];
         this.FBtn_Start.Substrate = this.FMC[CONST_QIANKUNAROLL.RESOURCE_Link_Btn_Start];
         this.FBtn_Start.OnClick = this.BtnExpandOnClick;
         this.FMC_ScoreLoadingBar = this.FMC[CONST_QIANKUNAROLL.RESOURCE_Link_MC_ScoreLoadingBar];
         this.FMC_ScoreLoadingBar.width = 0;
         this.FMC_Result = this.FMC[CONST_QIANKUNAROLL.RESOURCE_Link_MC_Result];
         this.FMC_Result.visible = false;
         this.FMC_Result.gotoAndStop(1);
         this.FTF_GambleTimes = this.FMC[CONST_QIANKUNAROLL.RESOURCE_Link_TF_GambleTimes];
         this.FTF_Log = this.FMC[CONST_QIANKUNAROLL.RESOURCE_Link_TF_Log];
         this.FTF_Log.text = "";
         this.FUIWindowConfirmation = new TUIWindowConfirmation(this.Parent);
         this.FUIWindowConfirmation.OnOK = this.ProcessorOnWindowCofirmOk;
         TUtilityUIWindow.SetupWindowConfirmation(this.FUIWindowConfirmation);
         this.FUIWindowConfirmation.SetCheckBoxUsable(true);
         this.FUIWindowConfirmation.Visible = false;
         _loc4_ = new Vector.<DisplayObject>();
         _loc2_ = this.FSilverCostVect.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = this.MakeComboItem(String(int(this.FSilverCostVect[_loc1_]) / 10000));
            _loc4_.push(_loc5_);
            _loc1_++;
         }
         this.FComboBoxSilver = new TComboBox(this,this.FMC[CONST_QIANKUNAROLL.RESOURCE_Link_MC_ComboBox + 0],_loc4_,80,this.OnSilverCostSelect,true);
         _loc4_.length = 0;
         _loc2_ = this.FGoldCostVect.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = this.MakeComboItem(this.FGoldCostVect[_loc1_]);
            _loc4_.push(_loc5_);
            _loc1_++;
         }
         this.FComboBoxGold = new TComboBox(this,this.FMC[CONST_QIANKUNAROLL.RESOURCE_Link_MC_ComboBox + 1],_loc4_,80,this.OnGoldCostSelect,true);
         _loc2_ = uint(MAX_SelectBoxCount);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FUISelectBox.SetTaskByIndex(_loc1_,this.FMC[CONST_QIANKUNAROLL.RESOURCE_Link_MC_SelectBox + _loc1_]);
            _loc1_++;
         }
         this.FUISelectBox.CallBackOnSelect = this.OnMcSelectBoxSelect;
         this.FUISelectBox.CallBackOnUnselect = this.OnMcSelectBoxUnselect;
         this.FUISelectBox.Init();
         this.FUISelectBox.UnselectAll();
         this.FUISelectBox.SetSelectByIndex(this.FSelectBoxIndex);
         this.FComboBoxSilver.SetBtnShowList(true);
         this.FComboBoxGold.SetBtnShowList(false);
         _loc2_ = uint(MAX_RewardBoxCount);
         _loc1_ = 1;
         while(_loc1_ <= _loc2_)
         {
            _loc3_ = this.FMC[CONST_QIANKUNAROLL.RESOURCE_Link_MC_Box + _loc1_];
            _loc3_.gotoAndStop(1);
            _loc3_.mouseChildren = false;
            _loc3_.addEventListener(MouseEvent.CLICK,this.OnRewardBoxClick);
            _loc3_.addEventListener(MouseEvent.MOUSE_MOVE,this.OnRewardBoxOver);
            _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this.OnRewardBoxOut);
            this.FBoxVect.push(_loc3_);
            _loc6_ = this.FHomeGambleBoxBin.GetDatebaseByIdentifier(_loc1_) as THomeGambleBox;
            _loc7_ = _loc6_.NeedScore + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Integral);
            this.FBoxScoreVect[_loc1_ - 1] = _loc6_.NeedScore;
            _loc8_ = this.FMC[CONST_QIANKUNAROLL.RESOURCE_Link_TF_BoxScore + _loc1_];
            _loc8_.mouseEnabled = false;
            _loc8_.text = _loc7_;
            if(_loc1_ == _loc2_)
            {
               this.FMaxScore = _loc6_.NeedScore;
            }
            _loc1_++;
         }
         this.GetCurBoxRewardVect();
      }
      
      protected function UpdateUI() : void
      {
         this.FTotalGambleTimes = SLogicsCore.Home.MaxGambleCount;
         this.FTF_GambleTimes.text = this.FCurGambleTimes + "/" + this.FTotalGambleTimes;
         if(this.FCurScore < this.FMaxScore)
         {
            this.FMC_ScoreLoadingBar.width = Math.floor(this.FCurScore * MAX_BarInitWidth / this.FMaxScore);
         }
         else
         {
            this.FMC_ScoreLoadingBar.width = MAX_BarInitWidth;
         }
         this.UpdateButtonUI();
      }
      
      protected function UpdateButtonUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.FTotalGambleTimes - this.FCurGambleTimes > 0)
         {
            this.FBtn_Start.Enabled = true;
         }
         else
         {
            this.FBtn_Start.Enabled = false;
         }
         _loc2_ = int(this.FBoxStatusVect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FBoxStatusVect[_loc1_] == 0)
            {
               this.FBoxVect[_loc1_].gotoAndStop(1);
            }
            else if(this.FBoxStatusVect[_loc1_] == 1)
            {
               this.FBoxVect[_loc1_].gotoAndStop(3);
            }
            else if(this.FBoxStatusVect[_loc1_] == 2)
            {
               this.FBoxVect[_loc1_].gotoAndStop(5);
            }
            _loc1_++;
         }
      }
      
      protected function SetBinsData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THomeGamble = null;
         var _loc6_:THomeGambleCost = null;
         _loc2_ = this.FHomeGambleCostBin.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc6_ = this.FHomeGambleCostBin.GetDatebaseByIndex(_loc1_) as THomeGambleCost;
            if(_loc6_ == null)
            {
               break;
            }
            this.FSilverCostVect.push(_loc6_.CostSilver.toString());
            this.FGoldCostVect.push(_loc6_.CostGold.toString());
            _loc4_ = int(_loc6_.WinGoldVect.length);
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               this.FGoldWinRewardVect.push(_loc6_.WinGoldVect[_loc3_]);
               _loc3_++;
            }
            _loc4_ = int(_loc6_.WinSilverVect.length);
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               this.FSilverWinRewardVect.push(_loc6_.WinSilverVect[_loc3_]);
               _loc3_++;
            }
            _loc1_++;
         }
      }
      
      protected function MakeComboItem(param1:String) : DisplayObject
      {
         var _loc2_:MovieClip = null;
         _loc2_ = TUtilityReflection.CreateDisplayObjectInstance("MC_TalismanList") as MovieClip;
         _loc2_.tf_into.text = param1;
         return _loc2_;
      }
      
      protected function StartPlayDiceContainer() : void
      {
         this.FMC_MyDiceContainer.gotoAndPlay(2);
         this.FMC_OppoDiceContainer.gotoAndPlay(2);
      }
      
      protected function ShowDiceContainer() : void
      {
         this.FMC_MyDiceContainer.gotoAndPlay(30);
         this.FMC_OppoDiceContainer.gotoAndPlay(30);
      }
      
      protected function SetDicePoint() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         if(this.FIsWin)
         {
            this.FOppoDicePoint = Math.floor(Math.random() * 5 + 1);
            this.FMyDicePoint = Math.floor(Math.random() * 6 + (this.FOppoDicePoint + 1));
         }
         else
         {
            this.FOppoDicePoint = Math.floor(Math.random() * 6 + 2);
            this.FMyDicePoint = Math.floor(Math.random() * (this.FOppoDicePoint - 1) + 1);
         }
         this.FMC_MyDice.gotoAndStop(this.FMyDicePoint);
         this.FMC_OppoDice.gotoAndStop(this.FOppoDicePoint);
      }
      
      protected function SetBoxStatus(param1:Vector.<int>) : Vector.<int>
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Vector.<int> = null;
         _loc4_ = new Vector.<int>();
         _loc3_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(param1[_loc2_] == 0)
            {
               if(this.FCurScore >= this.FBoxScoreVect[_loc2_])
               {
                  _loc4_[_loc2_] = 1;
               }
               else
               {
                  _loc4_[_loc2_] = 0;
               }
            }
            else if(param1[_loc2_] == 1)
            {
               _loc4_[_loc2_] = 2;
            }
            _loc2_++;
         }
         return _loc4_;
      }
      
      protected function GetCurBoxRewardVect() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THomeGamble = null;
         this.FLevel = this.FCharacter.GetMainLevel();
         this.FBoxRewardIDVect.length = 0;
         _loc1_ = this.GetSeverDay();
         _loc2_ = int(GAMBLEREWARD_LevelVect.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.FLevel <= GAMBLEREWARD_LevelVect[_loc3_])
            {
               _loc4_ = _loc3_;
               break;
            }
            _loc3_++;
         }
         _loc2_ = GAMBLEREWARD_IDVect[_loc4_ + 1];
         _loc3_ = GAMBLEREWARD_IDVect[_loc4_];
         while(_loc3_ < _loc2_)
         {
            _loc5_ = this.FHomeGambleBin.GetDatebaseByIdentifier(_loc3_) as THomeGamble;
            if(_loc5_ != null)
            {
               if(_loc5_.WeekDay == _loc1_)
               {
                  this.FBoxRewardIDVect.push(_loc3_);
               }
            }
            _loc3_++;
         }
      }
      
      protected function GetSeverDay() : Number
      {
         var _loc1_:uint = 0;
         var _loc2_:Date = null;
         var _loc3_:Number = NaN;
         _loc1_ = uint(STimingCore.ServerTick);
         _loc2_ = new Date(_loc1_ * 1000);
         return _loc2_.getDay();
      }
      
      protected function ProcessorOnWindowCofirmOk(param1:Object) : void
      {
         this.FBtn_Start.Enabled = false;
         this.FMC_Result.visible = false;
         this.FMC_Result.gotoAndStop(1);
         if(this.FOnStartRoll != null)
         {
            if(this.FCostType == TYPE_Silver)
            {
               this.FCostID = this.FComboBoxSilverIndex + 1;
            }
            else
            {
               this.FCostID = this.FComboBoxGoldIndex + 1;
            }
            this.FOnStartRoll(this,this.FCostID,this.FCostType);
         }
         this.FIsStartRoll = true;
         this.StartPlayDiceContainer();
      }
      
      protected function BtnExpandOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FCurGambleTimes >= this.FTotalGambleTimes)
         {
            return;
         }
         this.FCostType = this.FSelectBoxIndex;
         if(this.FCostType == 0)
         {
            if(this.FCharacter.CreditSilverCoin.ToNumber() < int(this.FSilverCostVect[this.FComboBoxSilverIndex]))
            {
               if(FOnEffectText != null)
               {
                  FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Coin));
               }
               return;
            }
            this.ProcessorOnWindowCofirmOk(this);
         }
         else if(this.FCostType == 1)
         {
            if(this.FCharacter.CreditGold < int(this.FGoldCostVect[this.FComboBoxGoldIndex]))
            {
               if(FOnEffectText != null)
               {
                  FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Gold));
               }
               return;
            }
            if(this.FUIWindowConfirmation.IsSelected)
            {
               this.ProcessorOnWindowCofirmOk(this);
            }
            else
            {
               this.FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.QIANKUNAROLL_STRING_01),int(this.FGoldCostVect[this.FComboBoxGoldIndex]));
               this.FUIWindowConfirmation.Visible = true;
            }
         }
      }
      
      protected function OnRewardBoxClick(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         _loc2_ = param1.currentTarget.name;
         _loc3_ = _loc2_.split("_");
         _loc4_ = int(_loc3_[_loc3_.length - 1]);
         if(this.FBoxStatusVect[_loc4_ - 1] == 0 || this.FBoxStatusVect[_loc4_ - 1] == 2)
         {
            return;
         }
         if(this.FOnGetBoxReward != null)
         {
            this.FOnGetBoxReward(this,_loc4_);
         }
      }
      
      protected function OnRewardBoxOver(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         param1.currentTarget.buttonMode = true;
         _loc2_ = param1.currentTarget.name;
         _loc3_ = int(_loc2_.slice(-1));
         this.FOverlayerGambleBox.Context = this.FHomeGambleBin.GetDatebaseByIdentifier(this.FBoxRewardIDVect[_loc3_ - 1]);
         this.FOverlayerGambleBox.Render(FUICore.MouseCoordinate);
         this.FOverlayerGambleBox.Show();
      }
      
      protected function OnRewardBoxOut(param1:MouseEvent) : void
      {
         param1.currentTarget.buttonMode = false;
         this.FOverlayerGambleBox.Hide();
      }
      
      protected function OnSilverCostSelect(param1:Object, param2:uint) : void
      {
         this.FComboBoxSilverIndex = param2;
      }
      
      protected function OnGoldCostSelect(param1:Object, param2:uint) : void
      {
         this.FComboBoxGoldIndex = param2;
      }
      
      protected function OnMcSelectBoxSelect(param1:int, param2:int) : void
      {
         if(this.FSelectBoxIndex == param2)
         {
            return;
         }
         this.FSelectBoxIndex = param2;
         this.FUISelectBox.SetSelectByIndex(this.FSelectBoxIndex);
         if(this.FSelectBoxIndex == TYPE_Silver)
         {
            this.FComboBoxSilver.SetBtnShowList(true);
            this.FComboBoxGold.SetBtnShowList(false);
         }
         else
         {
            this.FComboBoxSilver.SetBtnShowList(false);
            this.FComboBoxGold.SetBtnShowList(true);
         }
      }
      
      protected function OnMcSelectBoxUnselect(param1:int, param2:int) : void
      {
         this.FSelectBoxIndex = param2;
         this.FUISelectBox.SetSelectByIndex(this.FSelectBoxIndex);
         if(this.FSelectBoxIndex == TYPE_Silver)
         {
            this.FComboBoxSilver.SetBtnShowList(true);
            this.FComboBoxGold.SetBtnShowList(false);
         }
         else
         {
            this.FComboBoxSilver.SetBtnShowList(false);
            this.FComboBoxGold.SetBtnShowList(true);
         }
      }
      
      public function get OnStartRoll() : Function
      {
         return this.FOnStartRoll;
      }
      
      public function set OnStartRoll(param1:Function) : void
      {
         this.FOnStartRoll = param1;
      }
      
      public function get OnGetBoxReward() : Function
      {
         return this.FOnGetBoxReward;
      }
      
      public function set OnGetBoxReward(param1:Function) : void
      {
         this.FOnGetBoxReward = param1;
      }
      
      public function SetUI(param1:MovieClip) : void
      {
         this.FMC = param1;
      }
      
      public function GambleInit(param1:int, param2:int, param3:Vector.<int>) : void
      {
         this.FCurScore = param1;
         this.FCurGambleTimes = param2;
         this.FBoxStatusVect = this.SetBoxStatus(param3);
         this.UpdateUI();
      }
      
      public function UpDataUI(param1:int, param2:Vector.<int>) : void
      {
         this.FCurGambleTimes = param1;
         this.FBoxStatusVect = this.SetBoxStatus(param2);
         this.UpdateUI();
      }
      
      public function AddScore() : void
      {
         if(this.FCostType == 1)
         {
            this.FCurScore += int(this.FGoldCostVect[this.FCostID - 1]);
         }
      }
      
      public function ShowDiceMc(param1:Boolean) : void
      {
         this.FIsWin = param1;
         if(this.FIsWin)
         {
            this.FMC_Result.mc_resultInner.gotoAndStop(1);
         }
         else
         {
            this.FMC_Result.mc_resultInner.gotoAndStop(2);
         }
         this.SetDicePoint();
         this.FIsShow = true;
      }
      
      public function UpdataLog(param1:TInteractionLogs) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         _loc4_ = "";
         _loc2_ = param1.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ += param1.GetInteractionLogByIndex(_loc3_).HtmlText + "\n";
            _loc3_++;
         }
         this.FTF_Log.htmlText = _loc4_;
      }
      
      public function Mount() : void
      {
         this.SetBinsData();
         this.FMC_Result.visible = false;
         this.UpdateUI();
      }
      
      public function ResetData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = int(this.FBoxStatusVect.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this.FBoxStatusVect[_loc2_] = 0;
            _loc2_++;
         }
         this.FCurGambleTimes = 0;
         this.FCurScore = 0;
      }
   }
}

