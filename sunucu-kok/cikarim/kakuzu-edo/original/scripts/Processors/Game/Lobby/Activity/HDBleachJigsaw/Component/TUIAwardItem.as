package Processors.Game.Lobby.Activity.HDBleachJigsaw.Component
{
   import Components.Standard.TUIButton;
   import Foundation.Common.THint;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityFilter;
   import Foundation.Utilities.TUtilityString;
   import Logics.HDBleachJigsaw.TActivityBJItem;
   import Logics.HDBleachJigsaw.TActivityBJNeed;
   import Logics.Inventories.TInventory;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.text.TextField;
   
   public class TUIAwardItem extends TUIComponent
   {
      
      protected var FIsInitialization:Boolean;
      
      protected var FBtn_Ok:TUIButton;
      
      protected var FMC_SlotAward:Sprite;
      
      protected var FJigsawVec:Vector.<Sprite>;
      
      protected var FData:Vector.<TActivityBJNeed>;
      
      protected var FCurData:Vector.<TActivityBJItem>;
      
      protected var FTF_NeedVec:Vector.<TextField>;
      
      protected var FAward:TInventory;
      
      protected var FBoxIndex:uint;
      
      protected var FIndex:uint;
      
      protected var FHint:THint;
      
      protected var FCostNum:uint;
      
      protected var FOnSlotOver:Function;
      
      protected var FOnSlotOut:Function;
      
      protected var FOnQuerySequenceContext:Function;
      
      protected var FOnQuerySubscript:Function;
      
      protected var FOnBtnOkClick:Function;
      
      protected var FOnBtnOkOut:Function;
      
      protected var FOnBtnOkMove:Function;
      
      protected var FOnHintOver:Function;
      
      protected var FOnHintOut:Function;
      
      protected var FOnEffectText:Function;
      
      public function TUIAwardItem(param1:TUIComponent)
      {
         super(param1);
         this.FHint = new THint();
         this.FIsInitialization = false;
      }
      
      protected function Resources_UIDispatch(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         addChild(param1);
         this.FBtn_Ok = new TUIButton();
         this.FBtn_Ok.Substrate = param1["Btn_OK"];
         this.FBtn_Ok.OnClick = this.BtnOKOnClick;
         this.FBtn_Ok.OnOver = this.BtnOKOnMove;
         this.FBtn_Ok.OnOut = this.BtnOKOnOut;
         this.FMC_SlotAward = param1["MC_SlotAward"];
         this.FMC_SlotAward.addEventListener(MouseEvent.MOUSE_MOVE,this.AwardOnMove);
         this.FMC_SlotAward.addEventListener(MouseEvent.MOUSE_OUT,this.AwardOnOut);
         _loc3_ = 5;
         this.FJigsawVec = new Vector.<Sprite>(_loc3_);
         this.FTF_NeedVec = new Vector.<TextField>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FJigsawVec[_loc2_] = param1["MC_Slot_" + _loc2_];
            this.FTF_NeedVec[_loc2_] = param1["MC_Slot_" + _loc2_]["TF_Prompt"];
            this.FJigsawVec[_loc2_]["MC_Frame"].gotoAndStop(_loc2_);
            this.FJigsawVec[_loc2_]["TF_Prompt"].text = _loc2_.toString();
            _loc2_++;
         }
         this.FIsInitialization = true;
      }
      
      protected function Update() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:Boolean = false;
         var _loc8_:ColorMatrixFilter = null;
         var _loc7_:Array = new Array();
         var _loc9_:Array = new Array();
         _loc9_.push(TUtilityFilter.GaryColorFiltersTwo);
         _loc6_ = true;
         this.FCostNum = 0;
         if(this.FCurData == null)
         {
            return;
         }
         _loc2_ = this.FData.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FJigsawVec[_loc1_]["MC_Frame"].gotoAndStop(this.FData[_loc1_].Index + 1);
            this.FJigsawVec[_loc1_]["TF_Prompt"].text = this.GetCurNumByIndex(this.FData[_loc1_].Index).toString() + "/" + this.FData[_loc1_].NeedNum.toString();
            if(this.GetCurNumByIndex(this.FData[_loc1_].Index) < this.FData[_loc1_].NeedNum)
            {
               _loc6_ = false;
               this.FJigsawVec[_loc1_]["MC_Frame"].filters = _loc9_;
               this.FCostNum += this.FData[_loc1_].NeedNum - this.GetCurNumByIndex(this.FData[_loc1_].Index);
            }
            else
            {
               this.FJigsawVec[_loc1_]["MC_Frame"].filters = [];
            }
            _loc1_++;
         }
         if(!_loc6_)
         {
            this.FBtn_Ok.Caption = this.FData[0].Prompt3;
            this.FHint.Caption = TUtilityString.Format(this.FData[0].Prompt,this.FCostNum * this.FData[0].Cost);
            this.FBtn_Ok.OnOver = this.BtnOKOnMove;
            this.FBtn_Ok.OnOut = this.BtnOKOnOut;
         }
         else
         {
            this.FBtn_Ok.Caption = this.FData[0].Prompt2;
            this.FBtn_Ok.OnOver = null;
            this.FBtn_Ok.OnOut = null;
         }
      }
      
      protected function GetCurNumByIndex(param1:uint) : uint
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         _loc3_ = this.FCurData.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FCurData[_loc2_].Index == param1)
            {
               return this.FCurData[_loc2_].Num;
            }
            _loc2_++;
         }
         return 0;
      }
      
      protected function RedeemRequest(param1:Object) : void
      {
         if(SLogicsCore.Character.CreditGold < this.FCostNum * this.FData[0].Cost)
         {
            if(this.FOnEffectText != null)
            {
               this.FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_59));
            }
            return;
         }
         if(this.FOnBtnOkClick != null)
         {
            this.FOnBtnOkClick(this,this.FBoxIndex);
         }
      }
      
      protected function BtnOKOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FCostNum * this.FData[0].Cost;
         if(_loc3_ <= 0)
         {
            this.RedeemRequest(this);
            return;
         }
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),this.FCostNum * this.FData[0].Cost);
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.RedeemRequest;
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
      }
      
      protected function BtnOKOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnBtnOkOut != null)
         {
            this.FOnBtnOkOut(this,this.FHint);
         }
      }
      
      protected function BtnOKOnMove(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnBtnOkMove != null)
         {
            this.FOnBtnOkMove(this,this.FHint);
         }
      }
      
      protected function AwardOnMove(param1:MouseEvent) : void
      {
         if(this.FOnSlotOver != null)
         {
            this.FOnSlotOver(this,this.FIndex);
         }
      }
      
      protected function AwardOnOut(param1:MouseEvent) : void
      {
         if(this.FOnSlotOut != null)
         {
            this.FOnSlotOut(this);
         }
      }
      
      public function get OnQuerySequenceContext() : Function
      {
         return this.FOnQuerySequenceContext;
      }
      
      public function set OnQuerySequenceContext(param1:Function) : void
      {
         this.FOnQuerySequenceContext = param1;
      }
      
      public function get OnSlotOver() : Function
      {
         return this.FOnSlotOver;
      }
      
      public function set OnSlotOver(param1:Function) : void
      {
         this.FOnSlotOver = param1;
      }
      
      public function get OnSlotOut() : Function
      {
         return this.FOnSlotOut;
      }
      
      public function set OnSlotOut(param1:Function) : void
      {
         this.FOnSlotOut = param1;
      }
      
      public function get OnQuerySubscript() : Function
      {
         return this.FOnQuerySubscript;
      }
      
      public function set OnQuerySubscript(param1:Function) : void
      {
         this.FOnQuerySubscript = param1;
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
      
      public function Perform_UIDispatch(param1:Sprite) : void
      {
         this.Resources_UIDispatch(param1);
      }
      
      public function UpdateUI(param1:uint, param2:TInventory, param3:Vector.<TActivityBJNeed>) : void
      {
         this.FAward = param2;
         this.FData = param3;
         this.FIndex = param1;
         this.FBoxIndex = param3[0].BtnIndex;
      }
      
      public function UpdateNum(param1:Vector.<TActivityBJItem>) : void
      {
         this.FCurData = param1;
         this.Update();
      }
      
      public function Reset() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         this.FHint.Caption = "";
         _loc2_ = this.FData.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FJigsawVec[_loc1_]["MC_Frame"].gotoAndStop(0);
            this.FJigsawVec[_loc1_]["TF_Prompt"].text = "";
            _loc1_++;
         }
      }
   }
}

