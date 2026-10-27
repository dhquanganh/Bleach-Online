package Processors.Game.Lobby.Activity.HDWorldCup.Component
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.THDWorldCup;
   import Logics.HDWorldCup.TActivityWorldCup;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TUITeamSelector extends TUIComponent
   {
      
      protected var FBtn_Cancel:TUIButton;
      
      protected var FBtn_OK:TUIButton;
      
      protected var FBtn_Select:TUIButton;
      
      protected var FBtn_Open:TUIButton;
      
      protected var FTF_Name:TextField;
      
      protected var FTF_AlreadyPay:TextField;
      
      protected var FTF_Return:TextField;
      
      protected var FSP_Opts:Vector.<Sprite>;
      
      protected var FTF_Costs:Vector.<TextField>;
      
      protected var FMC_SelectBoxs:Vector.<TUIButton>;
      
      protected var FMC_UnSelectBoxs:Vector.<TUIButton>;
      
      protected var FMC_Flags:MovieClip;
      
      protected var FMC_Listitem:MovieClip;
      
      protected var FMC_CanPay:Sprite;
      
      protected var FMC_CanNotPay:Sprite;
      
      protected var FIndex:uint;
      
      protected var FData:TActivityWorldCup;
      
      protected var FConfig:THDWorldCup;
      
      protected var FStatus:int;
      
      protected var FFlag:uint;
      
      protected var FOnBtnOkClick:Function;
      
      protected var FOnBtnOpenClick:Function;
      
      protected var FOnBtnSelectClick:Function;
      
      protected var FOnBtnOkOut:Function;
      
      protected var FOnBtnOkMove:Function;
      
      protected var FOnHintOver:Function;
      
      protected var FOnHintOut:Function;
      
      protected var FOnEffectText:Function;
      
      public function TUITeamSelector(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function Resources_UIDispatch(param1:MovieClip) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this.FMC_CanPay = param1["MC_CanPay"];
         this.FMC_CanNotPay = param1["MC_CanNotPay"];
         this.FBtn_Cancel = new TUIButton();
         this.FBtn_Cancel.Substrate = this.FMC_CanPay["Btn_Cancel"];
         this.FBtn_Cancel.OnClick = this.ProcessorOnCancel;
         this.FBtn_OK = new TUIButton();
         this.FBtn_OK.Substrate = this.FMC_CanPay["Btn_OK"];
         this.FBtn_OK.OnClick = this.BtnOkOnClick;
         this.FBtn_OK.OnMove = this.ProecssorOnBtnOkMove;
         this.FBtn_OK.OnOut = this.ProecssorOnBtnOkOut;
         this.FBtn_Select = new TUIButton();
         this.FBtn_Select.Substrate = this.FMC_CanPay["Btn_Select"];
         this.FBtn_Select.OnClick = this.TeamsSelectorOnClick;
         this.FTF_Name = this.FMC_CanPay["TF_Name"];
         this.FTF_AlreadyPay = this.FMC_CanPay["TF_AlreadyPay"];
         this.FTF_Return = this.FMC_CanPay["TF_Return"];
         _loc3_ = 4;
         this.FSP_Opts = new Vector.<Sprite>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FSP_Opts[_loc2_] = this.FMC_CanPay["MC_Opt_" + _loc2_];
            _loc2_++;
         }
         this.FTF_Costs = new Vector.<TextField>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FTF_Costs[_loc2_] = this.FSP_Opts[_loc2_]["TF_Cost"];
            _loc2_++;
         }
         this.FMC_SelectBoxs = new Vector.<TUIButton>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FMC_SelectBoxs[_loc2_] = new TUIButton();
            this.FMC_SelectBoxs[_loc2_].Substrate = this.FSP_Opts[_loc2_]["MC_SelectBox"]["MC_Selected"];
            this.FMC_SelectBoxs[_loc2_].Visible = false;
            this.FMC_SelectBoxs[_loc2_].OnClick = this.ProcessorSelect;
            _loc2_++;
         }
         this.FMC_SelectBoxs[0].Visible = true;
         this.FMC_UnSelectBoxs = new Vector.<TUIButton>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FMC_UnSelectBoxs[_loc2_] = new TUIButton();
            this.FMC_UnSelectBoxs[_loc2_].Substrate = this.FSP_Opts[_loc2_]["MC_SelectBox"]["MC_Unselected"];
            this.FMC_UnSelectBoxs[_loc2_].OnClick = this.ProcessorSelect;
            _loc2_++;
         }
         this.FMC_Flags = this.FMC_CanPay["MC_Flags"]["MC_Flags"];
         this.FMC_CanPay["MC_Flags"]["TF_Prompt"].visible = false;
         this.FBtn_Open = new TUIButton();
         this.FBtn_Open.Substrate = this.FMC_CanNotPay["Btn_Open"];
         this.FBtn_Open.OnClick = this.ProcessorBtnOpenOnClick;
         this.FBtn_Open.OnMove = this.ProecssorOnBtnOkMove;
         this.FBtn_Open.OnOut = this.ProecssorOnBtnOkOut;
      }
      
      protected function ProcessorBtnOpenOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:Vector.<int> = null;
         _loc3_ = new Vector.<int>(1);
         _loc3_[0] = -1;
         _loc3_[1] = 0;
         if(this.FConfig.Selector2Cost > SLogicsCore.Character.CreditGold)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Gold));
            return;
         }
         if(this.FOnBtnOpenClick != null)
         {
            this.FOnBtnOpenClick(_loc3_);
         }
      }
      
      protected function ProecssorOnBtnOkOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnBtnOkOut != null)
         {
            this.FOnBtnOkOut();
         }
      }
      
      protected function ProecssorOnBtnOkMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc3_ = -1;
         _loc4_ = 4;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            if(this.FMC_SelectBoxs[_loc5_].Visible)
            {
               _loc3_ = int(_loc5_);
            }
            _loc5_++;
         }
         if(this.FOnBtnOkMove != null)
         {
            this.FOnBtnOkMove(this,param2,_loc3_);
         }
      }
      
      protected function BtnOkOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc3_ = -1;
         _loc4_ = 4;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            if(this.FMC_SelectBoxs[_loc5_].Visible)
            {
               _loc3_ = int(_loc5_);
            }
            _loc5_++;
         }
         if(this.FConfig.OptsCost[_loc3_] >= SLogicsCore.Character.CreditGold)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Gold));
            return;
         }
         if(this.FOnBtnOkClick != null)
         {
            this.FOnBtnOkClick(this,param2,_loc3_);
         }
      }
      
      protected function ProcessorOnCancel(param1:Object, param2:MouseEvent) : void
      {
         this.FBtn_Select.Visible = true;
         this.FBtn_Cancel.Visible = false;
         this.FBtn_OK.Enabled = false;
         this.FTF_Name.text = "";
      }
      
      protected function Update() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         if(this.FStatus == -1)
         {
            this.FMC_CanNotPay.visible = true;
            this.FMC_CanPay.visible = false;
         }
         if(this.FStatus == 0)
         {
            this.FMC_CanNotPay.visible = false;
            if(this.FBtn_Select.Visible)
            {
               this.FBtn_Cancel.Visible = false;
               this.FBtn_OK.Enabled = false;
            }
            this.FMC_CanPay.visible = true;
            this.FTF_AlreadyPay.text = "0";
            this.FTF_Return.text = "0";
            _loc1_ = 4;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               this.FTF_Costs[_loc2_].text = this.FConfig.OptsCost[_loc2_].toString();
               _loc2_++;
            }
            if(this.FFlag + 1 == this.FData.Flags[1 - this.FIndex])
            {
               this.FBtn_Select.Visible = true;
            }
         }
         if(this.FStatus > 0)
         {
            this.FMC_CanNotPay.visible = false;
            this.FMC_CanPay.visible = true;
            this.FBtn_Cancel.Visible = false;
            this.FBtn_Select.Visible = false;
            this.FMC_Flags.gotoAndStop(this.FData.Flags[this.FIndex] + 1);
            this.FTF_Name.text = this.FConfig.Teams[this.FData.Flags[this.FIndex] - 1];
            this.FTF_AlreadyPay.text = this.FData.HadMoney[this.FIndex].toString();
            this.FTF_Return.text = this.GetReturnMoney(this.FData.HadMoney[this.FIndex]);
            _loc1_ = 4;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               this.FTF_Costs[_loc2_].text = this.FConfig.OptsCost[_loc2_].toString();
               _loc2_++;
            }
         }
      }
      
      protected function GetReturnMoney(param1:uint) : String
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc4_ = 0;
         _loc5_ = 0;
         _loc2_ = this.FData.HadMoney.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ += this.FData.HadMoney[_loc3_];
            _loc3_++;
         }
         _loc2_ = this.FConfig.ReturnLevel.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.FData.HadMoney[this.FIndex] > this.FConfig.ReturnKey[_loc3_])
            {
               _loc5_ = Math.round(param1 * (this.FConfig.ReturnRate[_loc3_] / 100));
               return _loc5_.toString();
            }
            _loc3_++;
         }
         return "";
      }
      
      protected function ProcessorSelect(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         _loc5_ = uint(param2.currentTarget.parent.parent.name.split("_")[2]);
         _loc3_ = 4;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            this.FMC_SelectBoxs[_loc4_].Visible = false;
            _loc4_++;
         }
         this.FMC_SelectBoxs[_loc5_].Visible = true;
      }
      
      protected function TeamsSelectorOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnBtnSelectClick != null)
         {
            this.FOnBtnSelectClick(this,param2);
         }
      }
      
      public function get OnBtnOkClick() : Function
      {
         return this.FOnBtnOkClick;
      }
      
      public function set OnBtnOkClick(param1:Function) : void
      {
         this.FOnBtnOkClick = param1;
      }
      
      public function get OnBtnOkOut() : Function
      {
         return this.FOnBtnOkOut;
      }
      
      public function set OnBtnOkOut(param1:Function) : void
      {
         this.FOnBtnOkOut = param1;
      }
      
      public function get OnBtnOkMove() : Function
      {
         return this.FOnBtnOkMove;
      }
      
      public function set OnBtnOkMove(param1:Function) : void
      {
         this.FOnBtnOkMove = param1;
      }
      
      public function get OnEffectText() : Function
      {
         return this.FOnEffectText;
      }
      
      public function set OnEffectText(param1:Function) : void
      {
         this.FOnEffectText = param1;
      }
      
      public function get OnBtnSelectClick() : Function
      {
         return this.FOnBtnSelectClick;
      }
      
      public function set OnBtnSelectClick(param1:Function) : void
      {
         this.FOnBtnSelectClick = param1;
      }
      
      public function get OnBtnOpenClick() : Function
      {
         return this.FOnBtnOpenClick;
      }
      
      public function set OnBtnOpenClick(param1:Function) : void
      {
         this.FOnBtnOpenClick = param1;
      }
      
      public function Perform_UIDispatch(param1:MovieClip) : void
      {
         this.Resources_UIDispatch(param1);
      }
      
      public function UpdateUI(param1:uint, param2:TActivityWorldCup, param3:THDWorldCup) : void
      {
         this.FIndex = param1;
         this.FData = param2;
         this.FConfig = param3;
         this.FStatus = param2.Flags[param1];
         this.Update();
      }
      
      public function UpdateTempFlag(param1:uint, param2:uint) : void
      {
         this.FFlag = param2;
         this.FMC_Flags.gotoAndStop(param2 + 2);
         this.FTF_Name.text = this.FConfig.Teams[param2];
         this.FBtn_Select.Visible = false;
         this.FBtn_OK.Enabled = true;
         this.FBtn_Cancel.Visible = true;
      }
      
      public function UpdateBtnOver() : void
      {
         this.FBtn_OK.Visible = false;
         this.FBtn_Open.Visible = false;
      }
      
      public function Reset() : void
      {
         this.FTF_AlreadyPay.text = "0";
         this.FTF_Return.text = "0";
      }
   }
}

