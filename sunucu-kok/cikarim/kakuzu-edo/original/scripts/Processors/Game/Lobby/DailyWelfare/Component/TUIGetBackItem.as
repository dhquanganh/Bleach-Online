package Processors.Game.Lobby.DailyWelfare.Component
{
   import Components.Standard.*;
   import Foundation.Common.THint;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.TUtilityString;
   import Logics.*;
   import Logics.Dailywelfare.*;
   import Logics.DatebaseVO.VO.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TUIGetBackItem extends TUIComponent
   {
      
      public static const CANRECEIVE:int = 1;
      
      public static const ALREADYRECEIVE:int = 0;
      
      public static const CANNOTRECEIVE:int = -1;
      
      protected var FMC_Listitem:MovieClip;
      
      protected var FSP_AlreadyGet:Sprite;
      
      protected var FTF_Title:TextField;
      
      protected var FTF_Times:TextField;
      
      protected var FTF_Gold_0:TextField;
      
      protected var FTF_Exp_0:TextField;
      
      protected var FTF_Gold_1:TextField;
      
      protected var FTF_Exp_1:TextField;
      
      protected var FBtn_Ok_0:TUIButton;
      
      protected var FBtn_Ok_1:TUIButton;
      
      protected var FMC_IconFrame:MovieClip;
      
      protected var FIsInitialization:Boolean;
      
      protected var FID:uint;
      
      protected var FStatus:int;
      
      protected var FRoleLevel:uint;
      
      protected var FData:TDailyWelfare;
      
      protected var FCurStr:String;
      
      protected var FReward:TDailyGetBackReward;
      
      protected var FFreeRate:Number;
      
      protected var FGetBackCost:uint;
      
      protected var FHit:THint;
      
      protected var FBtnOkOnClick:Function;
      
      public function TUIGetBackItem(param1:TUIComponent)
      {
         super(param1);
         this.FIsInitialization = false;
      }
      
      protected function Resources_UIDispatch(param1:MovieClip) : void
      {
         this.FMC_Listitem = param1;
         this.FSP_AlreadyGet = this.FMC_Listitem["MC_AlreadyGet"];
         this.FTF_Title = this.FMC_Listitem["TF_Title"];
         this.FTF_Times = this.FMC_Listitem["TF_Times"];
         this.FTF_Gold_0 = this.FMC_Listitem["MC_Opt_0"]["TF_Gold"];
         this.FTF_Exp_0 = this.FMC_Listitem["MC_Opt_0"]["MC_Exp"];
         this.FBtn_Ok_0 = new TUIButton();
         this.FBtn_Ok_0.Substrate = this.FMC_Listitem["MC_Opt_0"]["Btn_Ok"];
         this.FBtn_Ok_0.OnClick = this.BtnOnClick;
         this.FTF_Gold_1 = this.FMC_Listitem["MC_Opt_1"]["TF_Gold"];
         this.FTF_Exp_1 = this.FMC_Listitem["MC_Opt_1"]["MC_Exp"];
         this.FBtn_Ok_1 = new TUIButton();
         this.FBtn_Ok_1.Substrate = this.FMC_Listitem["MC_Opt_1"]["Btn_Ok"];
         this.FBtn_Ok_1.OnClick = this.BtnOnClick;
         this.FBtn_Ok_1.OnMove = this.BtnOkOnMove;
         this.FBtn_Ok_1.OnOut = this.BtnOnOut;
         this.FMC_IconFrame = this.FMC_Listitem["MC_IconFrame"];
         this.FHit = new THint();
         this.FIsInitialization = true;
      }
      
      protected function BtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:Vector.<uint> = null;
         _loc3_ = new Vector.<uint>(2);
         _loc3_[0] = this.FReward.Reward_Gold[this.FID];
         _loc3_[1] = this.FReward.Reward_Exp[this.FID];
         if(this.FBtnOkOnClick != null)
         {
            this.FBtnOkOnClick(this,this.FID + "_" + param2.currentTarget.parent.name.split("_")[2],_loc3_);
         }
      }
      
      protected function Update() : void
      {
         var _loc1_:Vector.<String> = null;
         this.FMC_IconFrame.gotoAndStop(this.FID + 1);
         _loc1_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRING_DailyWelfare_10);
         this.FTF_Title.text = _loc1_[this.FID];
         if(this.FStatus == ALREADYRECEIVE)
         {
            this.FSP_AlreadyGet.visible = true;
            this.FBtn_Ok_0.Enabled = false;
            this.FBtn_Ok_0.Visible = false;
            this.FBtn_Ok_1.Enabled = false;
            this.FBtn_Ok_1.Visible = false;
            this.FTF_Times.text = this.FStatus.toString();
         }
         if(this.FStatus == CANRECEIVE)
         {
            this.FSP_AlreadyGet.visible = false;
            this.FBtn_Ok_0.Enabled = true;
            this.FBtn_Ok_0.Visible = true;
            this.FBtn_Ok_1.Enabled = true;
            this.FBtn_Ok_1.Visible = true;
            this.FTF_Times.text = this.FStatus.toString();
         }
         if(this.FStatus == CANNOTRECEIVE)
         {
            this.FSP_AlreadyGet.visible = false;
            this.FBtn_Ok_0.Enabled = false;
            this.FBtn_Ok_0.Visible = true;
            this.FBtn_Ok_1.Enabled = false;
            this.FBtn_Ok_1.Visible = true;
            this.FTF_Times.text = (this.FStatus + 1).toString();
         }
         this.FReward = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_DailyGetBackReward,SLogicsCore.Character.GetMainRebirthLevel()) as TDailyGetBackReward;
         this.FTF_Gold_0.text = uint(this.FReward.Reward_Gold[this.FID] * this.FFreeRate).toString();
         this.FTF_Exp_0.text = uint(this.FReward.Reward_Exp[this.FID] * this.FFreeRate).toString();
         this.FTF_Gold_1.text = this.FReward.Reward_Gold[this.FID].toString();
         this.FTF_Exp_1.text = this.FReward.Reward_Exp[this.FID].toString();
      }
      
      protected function BtnOkOnMove(param1:Object, param2:MouseEvent) : void
      {
         this.FHit.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_DailyWelfare_08),this.FGetBackCost);
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHit);
      }
      
      protected function BtnOnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHit);
      }
      
      public function get BtnOkOnClick() : Function
      {
         return this.FBtnOkOnClick;
      }
      
      public function set BtnOkOnClick(param1:Function) : void
      {
         this.FBtnOkOnClick = param1;
      }
      
      public function get CurStr() : String
      {
         return this.FCurStr;
      }
      
      public function Perform_UIDispatch(param1:MovieClip) : void
      {
         this.Resources_UIDispatch(param1);
      }
      
      public function UpdateUI(param1:uint, param2:TDailyWelfare, param3:Number, param4:uint) : void
      {
         this.FID = param1;
         this.FStatus = param2.GetBackItems[param1].Status;
         this.FData = param2;
         this.FFreeRate = param3;
         this.FGetBackCost = param4;
         this.Update();
      }
      
      public function Reset() : void
      {
         this.FTF_Title.text = "";
         this.FTF_Times.text = "";
         this.FTF_Gold_0.text = "";
         this.FTF_Exp_0.text = "";
         this.FTF_Gold_1.text = "";
         this.FTF_Exp_1.text = "";
      }
   }
}

