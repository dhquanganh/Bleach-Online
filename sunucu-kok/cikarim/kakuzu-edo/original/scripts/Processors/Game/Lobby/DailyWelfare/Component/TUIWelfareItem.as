package Processors.Game.Lobby.DailyWelfare.Component
{
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.Agent.SParametersCore;
   import Logics.Dailywelfare.TDailyWelfare;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.DatebaseVO.VO.TDailyWelfareReward;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_CONFIGVALUE;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TUIWelfareItem extends TUIComponent
   {
      
      public static const CANRECEIVE:int = 0;
      
      public static const ALREADYRECEIVE:int = 1;
      
      public static const CANNOTRECEIVE:int = 0;
      
      public static const REWARDBASE:int = 10000000;
      
      protected var FMC_Listitem:MovieClip;
      
      protected var FSP_VipLimit:Sprite;
      
      protected var FSP_Cost:Sprite;
      
      protected var FMC_CostFrame:MovieClip;
      
      protected var FMC_boxes:MovieClip;
      
      protected var FTF_Price:TextField;
      
      protected var FBtn_Ok:TUIButton;
      
      protected var FSP_AlreadyGet:Sprite;
      
      protected var FSP_Opt_0:Sprite;
      
      protected var FSP_Opt_1:Sprite;
      
      protected var FTF_Prompt_0:TextField;
      
      protected var FTF_Prompt_1:TextField;
      
      protected var FIsInitialization:Boolean;
      
      protected var FID:uint;
      
      protected var FStatus:int;
      
      protected var FVipLevel:uint;
      
      protected var FRoleLevel:uint;
      
      protected var FMC_CheckBox_0:MovieClip;
      
      protected var FMC_CheckBox_1:MovieClip;
      
      protected var FFlag:uint;
      
      protected var FData:TDailyWelfare;
      
      protected var FReward:TDailyWelfareReward;
      
      protected var FCurStr:String;
      
      protected var FAcquire:Vector.<Object>;
      
      protected var FBtnOkOnClick:Function;
      
      public function TUIWelfareItem(param1:TUIComponent)
      {
         super(param1);
         this.FIsInitialization = false;
      }
      
      protected function Resources_UIDispatch(param1:MovieClip) : void
      {
         this.FMC_Listitem = param1;
         this.FSP_VipLimit = this.FMC_Listitem["MC_VipLimit"];
         this.FSP_Cost = this.FMC_Listitem["MC_Cost"];
         this.FMC_CostFrame = this.FSP_Cost["MC_CostFrame"];
         this.FMC_boxes = this.FMC_Listitem["MC_boxes"];
         this.FTF_Price = this.FSP_Cost["TF_Price"];
         this.FSP_AlreadyGet = this.FMC_Listitem["MC_AlreadyGet"];
         this.FSP_Opt_0 = this.FMC_Listitem["MC_Opt_0"];
         this.FSP_Opt_1 = this.FMC_Listitem["MC_Opt_1"];
         this.FTF_Prompt_0 = this.FSP_Opt_0["TF_Prompt_0"];
         this.FTF_Prompt_1 = this.FSP_Opt_1["TF_Prompt_1"];
         this.FBtn_Ok = new TUIButton();
         this.FBtn_Ok.Substrate = this.FMC_Listitem["Btn_Ok"];
         this.FBtn_Ok.OnClick = this.BtnOnClick;
         this.FMC_CheckBox_0 = this.FMC_Listitem["MC_Opt_0"]["Btn_Check"];
         this.FMC_CheckBox_1 = this.FMC_Listitem["MC_Opt_1"]["Btn_Check"];
         this.FIsInitialization = true;
         this.UILocation();
      }
      
      protected function UILocation() : void
      {
         this.FMC_CheckBox_0.addEventListener(MouseEvent.CLICK,this.CheckBoxOnClick);
         this.FMC_CheckBox_1.addEventListener(MouseEvent.CLICK,this.CheckBoxOnClick);
         this.FMC_CheckBox_0.gotoAndStop(2);
      }
      
      protected function CheckBoxOnClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         this.FMC_CheckBox_0.gotoAndStop(3 - this.FMC_CheckBox_0.currentFrame);
         this.FMC_CheckBox_1.gotoAndStop(3 - this.FMC_CheckBox_1.currentFrame);
         if(this.FMC_CheckBox_0.currentFrameLabel == "ok")
         {
            this.FFlag = 0;
         }
         if(this.FMC_CheckBox_1.currentFrameLabel == "ok")
         {
            this.FFlag = 1;
         }
         this.Update();
      }
      
      protected function BtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         if(this.FBtnOkOnClick != null)
         {
            this.FBtnOkOnClick(this,this.FID + "_" + this.FFlag,this.FCurStr);
         }
      }
      
      protected function BtnGotoLinkOnClcik(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToRechargeUrl(SParametersCore.PayUrl);
      }
      
      protected function Update() : void
      {
         var _loc1_:TConfigValue = null;
         this.FMC_boxes.gotoAndStop(this.FID + 1);
         if(this.FStatus == ALREADYRECEIVE)
         {
            this.FSP_AlreadyGet.visible = true;
            this.FSP_VipLimit.visible = false;
            this.FBtn_Ok.Enabled = false;
            this.FBtn_Ok.Visible = false;
         }
         if(this.FStatus == CANRECEIVE)
         {
            this.FSP_AlreadyGet.visible = false;
            this.FSP_VipLimit.visible = false;
            this.FBtn_Ok.Enabled = true;
            this.FBtn_Ok.Visible = true;
         }
         if(!SLogicsCore.Character.VipData.DailyWelfare && this.FID == 2)
         {
            this.FSP_AlreadyGet.visible = false;
            this.FSP_VipLimit.visible = true;
            this.FBtn_Ok.Enabled = true;
            this.FBtn_Ok.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_DailyWelfare_07);
            this.FBtn_Ok.OnClick = this.BtnGotoLinkOnClcik;
         }
         if(this.FID == 0)
         {
            this.FMC_CheckBox_0.removeEventListener(MouseEvent.CLICK,this.CheckBoxOnClick);
            this.FSP_Opt_1.visible = false;
            this.FMC_CheckBox_0.enabled = false;
            this.FTF_Prompt_0.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_DailyWelfare_03),100);
         }
         this.FReward = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_DailyWelfareReward,REWARDBASE + SLogicsCore.Character.GetMainRebirthLevel()) as TDailyWelfareReward;
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.WelFare_acquire) as TConfigValue;
         if(this.FID == 1)
         {
            this.FTF_Prompt_0.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_DailyWelfare_03),this.FAcquire[1][1] * 100);
            this.FTF_Prompt_1.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_DailyWelfare_04),this.FAcquire[3][0],this.FAcquire[3][1] * 100);
         }
         if(this.FID == 2)
         {
            this.FTF_Prompt_0.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_DailyWelfare_03),this.FAcquire[2][1] * 100);
            this.FTF_Prompt_1.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_DailyWelfare_04),this.FAcquire[4][0],this.FAcquire[4][1] * 100);
         }
         if(SLogicsCore.Character.GetMainLevel() < this.FData.WorldBossLv)
         {
            this.FTF_Price.text = this.FReward.Exp.toString();
            if(this.FID == 1)
            {
               this.FTF_Price.text = uint(this.FReward.Exp * this.FAcquire[1][1]).toString();
               if(this.FFlag == 1)
               {
                  this.FTF_Price.text = uint(this.FReward.Exp * this.FAcquire[3][1]).toString();
               }
            }
            if(this.FID == 2)
            {
               this.FTF_Price.text = uint(this.FReward.Exp * this.FAcquire[2][1]).toString();
               if(this.FFlag == 1)
               {
                  this.FTF_Price.text = uint(this.FReward.Exp * this.FAcquire[4][1]).toString();
               }
            }
            this.FMC_CostFrame.gotoAndStop(2);
            this.FCurStr = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_DailyWelfare_06),this.FTF_Price.text);
         }
         else
         {
            this.FTF_Price.text = this.FReward.Gold.toString();
            if(this.FID == 1)
            {
               this.FTF_Price.text = (this.FReward.Gold * this.FAcquire[1][1]).toString();
               if(this.FFlag == 1)
               {
                  this.FTF_Price.text = (this.FReward.Gold * this.FAcquire[3][1]).toString();
               }
            }
            if(this.FID == 2)
            {
               this.FTF_Price.text = (this.FReward.Gold * this.FAcquire[2][1]).toString();
               if(this.FFlag == 1)
               {
                  this.FTF_Price.text = (this.FReward.Gold * this.FAcquire[4][1]).toString();
               }
            }
            this.FMC_CostFrame.gotoAndStop(1);
            this.FCurStr = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_DailyWelfare_05),this.FTF_Price.text);
         }
      }
      
      public function get BtnOkOnClick() : Function
      {
         return this.FBtnOkOnClick;
      }
      
      public function set BtnOkOnClick(param1:Function) : void
      {
         this.FBtnOkOnClick = param1;
      }
      
      public function Perform_UIDispatch(param1:MovieClip) : void
      {
         this.Resources_UIDispatch(param1);
      }
      
      public function UpdateUI(param1:uint, param2:TDailyWelfare, param3:Vector.<Object>) : void
      {
         this.FID = param1;
         this.FStatus = param2.WelfareItems[param1].Status;
         this.FData = param2;
         this.FAcquire = param3;
         this.Update();
      }
      
      public function Reset() : void
      {
         this.FTF_Price.text = "";
         this.FTF_Prompt_0.text = "";
         this.FTF_Prompt_1.text = "";
      }
   }
}

