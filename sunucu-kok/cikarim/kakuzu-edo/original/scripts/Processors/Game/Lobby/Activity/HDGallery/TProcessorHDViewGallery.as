package Processors.Game.Lobby.Activity.HDGallery
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDGallery;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDGallery.THDGalleryData;
   import Logics.SLogicsCore;
   import Processors.Game.Common.Effects.TWheelEffect;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDGallery.components.TGalleryDisplay;
   import Processors.Game.Lobby.Activity.HDGallery.components.TGalleryItem;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TShowAwardUI;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.setTimeout;
   
   public class TProcessorHDViewGallery extends TProcessorHDSingleWindowBase
   {
      
      protected static const Item_Num:int = 16;
      
      protected static const Display_Num:int = 4;
      
      protected static const Color_Num:int = 4;
      
      protected static const Gallery_Speed:int = 70;
      
      protected static const Ten_Count:int = 10;
      
      protected static const Fifty_Count:int = 50;
      
      protected var FTFScore:TextField;
      
      protected var FTFHeroName:TextField;
      
      protected var FIconBuy:Sprite;
      
      protected var FBtnGain:TUIButton;
      
      protected var FMountPoint:Sprite;
      
      protected var FBtnOne:TUIButton;
      
      protected var FBtnTen:TUIButton;
      
      protected var FBtnFifty:TUIButton;
      
      protected var FBtnRemove:TUIButton;
      
      protected var FBtnRefresh:TUIButton;
      
      protected var FTFree:TextField;
      
      protected var FTFTen:TextField;
      
      protected var FTFFifty:TextField;
      
      protected var FTFRemove:TextField;
      
      protected var FTFRefresh:TextField;
      
      protected var FTFRemoveTitle:TextField;
      
      protected var FCheckBox:MovieClip;
      
      protected var FAwardVec:Vector.<TGalleryItem>;
      
      protected var FDisplaysVec:Vector.<Vector.<TGalleryDisplay>>;
      
      protected var FDisableAnimation:Boolean;
      
      protected var FWheelEffect:TWheelEffect;
      
      protected var FConfigData:THDGallery;
      
      protected var FActivityData:THDGalleryData;
      
      protected var FNeedPlay:Boolean;
      
      protected var FNeedRefreshMask:Boolean;
      
      protected var FShowAwardUI:TShowAwardUI;
      
      protected var FFindRewardIndex:int;
      
      protected var FFlag:uint;
      
      public function TProcessorHDViewGallery(param1:TUIComponent)
      {
         super(param1);
         this.FAwardVec = new Vector.<TGalleryItem>();
         this.FDisplaysVec = new Vector.<Vector.<TGalleryDisplay>>();
      }
      
      override protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:uint = 0;
         super.UpdateUI();
         _loc9_ = 0;
         _loc2_ = int(this.FConfigData.AwardIndexVec.length);
         this.FTFree.text = this.FActivityData.FreeCount + "";
         this.FTFScore.text = this.FActivityData.CurScore + "";
         if(this.FActivityData.CurIndex == 0 || this.FActivityData.RemoveStatus > 0 || this.FNeedRefreshMask)
         {
            this.AwardSetMask();
            if(this.FActivityData.RemoveStatus <= 0)
            {
               this.FNeedRefreshMask = false;
            }
         }
         _loc7_ = this.FActivityData.RemoveStatus + 1;
         if(_loc7_ < Color_Num)
         {
            this.FTFRemoveTitle.text = this.FConfigData.RemoveWords[this.FActivityData.RemoveStatus];
            this.FBtnRemove.Enabled = true;
            this.FTFRemove.text = this.FConfigData.RemoveCostVec[_loc7_] + "";
         }
         else
         {
            this.FTFRemoveTitle.text = this.FConfigData.RemoveWords[2];
            this.FBtnRemove.Enabled = false;
            this.FTFRemove.text = "0";
         }
         _loc5_ = this.FConfigData.ExtractOneCost + this.FConfigData.RemoveCostVec[this.FActivityData.RemoveStatus];
         _loc6_ = Fifty_Count * this.FConfigData.DisCount * 0.01;
         _loc1_ = 1;
         while(_loc1_ < _loc7_)
         {
            _loc9_ += this.FConfigData.RemoveCostVec[_loc1_ - 1];
            _loc1_++;
         }
         this.FTFTen.text = (this.FConfigData.ExtractOneCost * Ten_Count + (Ten_Count - 1) * (this.FConfigData.RemoveCostVec[_loc7_ - 1] + _loc9_)).toString();
         this.FTFFifty.text = (this.FConfigData.ExtractOneCost * _loc6_ + (Fifty_Count - 1) * (this.FConfigData.RemoveCostVec[_loc7_ - 1] + _loc9_)).toString();
         this.FTFRefresh.text = this.FConfigData.RefreshItemCost + "";
         if(this.FActivityData.IsInit == 0)
         {
            this.ReflashWheel();
         }
         if(this.FActivityData.CurIndex == this.FConfigData.ExtractTenIndex || this.FActivityData.CurIndex == this.FConfigData.ExtractFiftyIndex || this.FDisableAnimation && this.FActivityData.CurIndex == this.FConfigData.ExtractOneIndex)
         {
            this.FNeedRefreshMask = true;
            this.WheelStop(true);
            this.FFlag = 1;
         }
         else if(this.FNeedPlay)
         {
            this.FNeedPlay = false;
            setTimeout(this.WheelStop,3000);
         }
         this.FBtnGain.Enabled = this.FActivityData.LoginCanGet;
         this.FIconBuy.visible = !this.FActivityData.LoginCanGet;
         this.FBtnRefresh.Enabled = this.FActivityData.RemoveStatus <= 0;
      }
      
      protected function AwardSetMask() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < Color_Num)
         {
            _loc2_ = 0;
            while(_loc2_ < Color_Num)
            {
               this.FAwardVec[_loc1_ + _loc2_ * Color_Num].SetMask(_loc1_ < this.FActivityData.RemoveStatus);
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      protected function WheelStop(param1:Boolean = false) : void
      {
         if(this.FFindRewardIndex >= 0 && this.FFindRewardIndex < Item_Num)
         {
            this.FWheelEffect.Stop(this.FFindRewardIndex);
            this.FAwardVec[this.FFindRewardIndex].PlayEffect();
         }
         else
         {
            this.FWheelEffect.ForcedStop(0);
         }
         if(param1)
         {
            this.GalleryStopByIndex(this.FFindRewardIndex);
            this.FAwardVec[this.FFindRewardIndex].PlayEffect();
         }
         setTimeout(this.ReflashWheel,1500);
      }
      
      protected function ReflashWheel() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc2_ = int(this.FActivityData.CurInventories.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = int(this.FActivityData.CurInventories[_loc1_].length);
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc5_ = this.FActivityData.CurInventories[_loc1_][_loc3_];
               this.FAwardVec[_loc1_ + _loc3_ * Color_Num].SetData(this.FConfigData.RewardIdsVec[_loc1_][_loc5_]);
               _loc3_++;
            }
            _loc1_++;
         }
         if(this.FActivityData.IsInit == 0)
         {
            return;
         }
         this.FFlag = 0;
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         super.UpdateDataBase(param1);
         this.FActivityData = param1 as THDGalleryData;
         ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
         ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         if(this.FActivityData.CurIndex == 80)
         {
            _loc2_ = this.FConfigData.AwardIndexVec.indexOf(this.FActivityData.Results[0]);
            _loc3_ = this.FActivityData.CurInventories[_loc2_].indexOf(this.FActivityData.Results[1]);
            this.FFindRewardIndex = _loc2_ + _loc3_ * Color_Num;
         }
         this.UpdateUI();
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         super.UpdateUIConfig();
         this.FTFRefresh.text = this.FConfigData.RefreshItemCost + "";
         _loc2_ = int(this.FDisplaysVec.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = 0;
            while(_loc3_ < Display_Num)
            {
               this.FDisplaysVec[_loc1_][_loc3_].SetData(this.FConfigData.RewardIdsVec[_loc1_ + 1][_loc3_]);
               _loc3_++;
            }
            _loc1_++;
         }
      }
      
      protected function SendServerData(param1:int) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param1);
      }
      
      protected function GalleryStopByIndex(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(this.FAwardVec.length);
         _loc2_ = 0;
         while(_loc2_ < Item_Num)
         {
            this.FAwardVec[_loc2_].SetLight(false);
            _loc2_++;
         }
         if(!this.FAwardVec[param1].IsMask)
         {
            this.FAwardVec[param1].SetLight(true);
         }
      }
      
      protected function OnCheckBox(param1:MouseEvent) : void
      {
         this.FDisableAnimation = !this.FDisableAnimation;
         if(this.FDisableAnimation)
         {
            this.FCheckBox.gotoAndStop(1);
         }
         else
         {
            this.FCheckBox.gotoAndStop(2);
         }
      }
      
      protected function OnGalleryStop(param1:int) : void
      {
         this.AwardSetMask();
         FParent.mouseEnabled = true;
         FParent.mouseChildren = true;
      }
      
      protected function OnGalleryChange(param1:int, param2:int) : void
      {
         this.GalleryStopByIndex(param2);
      }
      
      protected function OnLoginGift(param1:Object, param2:MouseEvent) : void
      {
         this.SendServerData(this.FConfigData.LoginIndex);
      }
      
      override protected function WindowInformationOnOK(param1:Object) : void
      {
         var _loc2_:int = 0;
         super.WindowInformationOnOK(param1);
         _loc2_ = int(param1.Context);
         switch(_loc2_)
         {
            case this.FConfigData.ExtractOneIndex:
               this.SendServerData(this.FConfigData.ExtractOneIndex);
               this.FNeedPlay = !this.FDisableAnimation;
               if(this.FNeedPlay)
               {
                  this.FWheelEffect.Play();
                  FParent.mouseEnabled = false;
                  FParent.mouseChildren = false;
                  this.FFlag = 1;
               }
               break;
            case this.FConfigData.ExtractTenIndex:
               this.SendServerData(this.FConfigData.ExtractTenIndex);
               this.FNeedRefreshMask = true;
               break;
            case this.FConfigData.ExtractFiftyIndex:
               this.SendServerData(this.FConfigData.ExtractFiftyIndex);
               this.FNeedRefreshMask = true;
               break;
            case this.FConfigData.RemoveIndex:
               this.SendServerData(this.FConfigData.RemoveIndex);
               break;
            case this.FConfigData.RefreshItemIndex:
               this.SendServerData(this.FConfigData.RefreshItemIndex);
         }
      }
      
      protected function OnOneClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FActivityData.FreeCount <= 0)
         {
            if(SLogicsCore.Character.CreditGold < this.FConfigData.ExtractOneCost)
            {
               FUIWindowRecharge.Visible = true;
               return;
            }
            FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),this.FConfigData.ExtractOneCost);
            FUIWindowConfirmation.OnOK = this.WindowInformationOnOK;
            FUIWindowConfirmation.Context = this.FConfigData.ExtractOneIndex;
            FUIWindowConfirmation.Visible = true;
            return;
         }
         this.WindowInformationOnOK({"Context":this.FConfigData.ExtractOneIndex});
      }
      
      protected function OnTenClick(param1:Object, param2:MouseEvent) : void
      {
         if(SLogicsCore.Character.CreditGold < int(this.FTFTen.text))
         {
            FUIWindowRecharge.Visible = true;
            return;
         }
         FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),this.FTFTen.text);
         FUIWindowConfirmation.OnOK = this.WindowInformationOnOK;
         FUIWindowConfirmation.Context = this.FConfigData.ExtractTenIndex;
         FUIWindowConfirmation.Visible = true;
      }
      
      protected function OnFiftyClick(param1:Object, param2:MouseEvent) : void
      {
         if(SLogicsCore.Character.CreditGold < int(this.FTFFifty.text))
         {
            FUIWindowRecharge.Visible = true;
            return;
         }
         FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),this.FTFFifty.text);
         FUIWindowConfirmation.OnOK = this.WindowInformationOnOK;
         FUIWindowConfirmation.Context = this.FConfigData.ExtractFiftyIndex;
         FUIWindowConfirmation.Visible = true;
      }
      
      protected function OnRemoveClick(param1:Object, param2:MouseEvent) : void
      {
         if(SLogicsCore.Character.CreditGold < int(this.FTFRemove.text))
         {
            FUIWindowRecharge.Visible = true;
            return;
         }
         FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),this.FTFRemove.text);
         FUIWindowConfirmation.OnOK = this.WindowInformationOnOK;
         FUIWindowConfirmation.Context = this.FConfigData.RemoveIndex;
         FUIWindowConfirmation.Visible = true;
      }
      
      protected function OnRemoveOut(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < Color_Num)
         {
            _loc4_ = 0;
            while(_loc4_ < Color_Num)
            {
               this.FAwardVec[_loc3_ + _loc4_ * Color_Num].SetMask(_loc3_ < this.FActivityData.RemoveStatus);
               _loc4_++;
            }
            _loc3_++;
         }
      }
      
      protected function OnRefreshClick(param1:Object, param2:MouseEvent) : void
      {
         if(SLogicsCore.Character.CreditGold < int(this.FTFRefresh.text))
         {
            FUIWindowRecharge.Visible = true;
            return;
         }
         FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),this.FTFRefresh.text);
         FUIWindowConfirmation.OnOK = this.WindowInformationOnOK;
         FUIWindowConfirmation.Context = this.FConfigData.RefreshItemIndex;
         FUIWindowConfirmation.Visible = true;
      }
      
      protected function OnRemoveMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.FActivityData.RemoveStatus > 2)
         {
            return;
         }
         _loc3_ = 0;
         while(_loc3_ < Color_Num)
         {
            _loc4_ = 0;
            while(_loc4_ < Color_Num)
            {
               this.FAwardVec[_loc3_ + _loc4_ * Color_Num].SetMask(_loc3_ < this.FActivityData.RemoveStatus + 1);
               _loc4_++;
            }
            _loc3_++;
         }
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TGalleryItem = null;
         var _loc5_:TGalleryDisplay = null;
         var _loc6_:Sprite = null;
         var _loc7_:Sprite = null;
         super.InitWindow(param1);
         this.FTFScore = FScene["TF_Value"];
         _loc6_ = FScene["MC_Hero"];
         this.FTFHeroName = _loc6_["TF_HeroName"];
         this.FIconBuy = _loc6_["MC_Exchangeed"];
         this.FIconBuy.mouseChildren = false;
         this.FIconBuy.mouseEnabled = false;
         this.FBtnGain = new TUIButton();
         this.FBtnGain.Substrate = _loc6_["Btn_Get"];
         this.FBtnGain.OnClick = this.OnLoginGift;
         this.FMountPoint = _loc6_["MC_MountPoint"];
         _loc7_ = FScene["MC_Gallery"];
         _loc2_ = 0;
         while(_loc2_ < Item_Num)
         {
            _loc4_ = new TGalleryItem(FParent);
            _loc4_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc4_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            _loc4_.Init(_loc7_["MC_Slot_" + _loc2_]);
            this.FAwardVec.push(_loc4_);
            _loc2_++;
         }
         _loc2_ = 1;
         while(_loc2_ < Color_Num)
         {
            this.FDisplaysVec.push(new Vector.<TGalleryDisplay>());
            _loc3_ = 0;
            while(_loc3_ < Display_Num)
            {
               _loc5_ = new TGalleryDisplay(FParent);
               _loc5_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
               _loc5_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
               _loc5_.Init(FScene["MC_Item_" + _loc2_]["MC_Slot_" + _loc3_]);
               this.FDisplaysVec[_loc2_ - 1].push(_loc5_);
               _loc3_++;
            }
            _loc2_++;
         }
         this.FTFree = _loc7_["TF_Free"];
         this.FTFTen = _loc7_["TF_Ten"];
         this.FTFFifty = _loc7_["TF_Fifty"];
         this.FTFRemove = _loc7_["TF_Remove"];
         this.FTFRefresh = _loc7_["TF_Refresh"];
         this.FBtnOne = new TUIButton();
         this.FBtnOne.OnClick = this.OnOneClick;
         this.FBtnOne.Substrate = _loc7_["MC_OneKey"];
         this.FBtnTen = new TUIButton();
         this.FBtnTen.OnClick = this.OnTenClick;
         this.FBtnTen.Substrate = _loc7_["Btn_Ten"];
         this.FBtnFifty = new TUIButton();
         this.FBtnFifty.OnClick = this.OnFiftyClick;
         this.FBtnFifty.Substrate = _loc7_["Btn_Fifty"];
         this.FBtnRemove = new TUIButton();
         this.FBtnRemove.OnClick = this.OnRemoveClick;
         this.FBtnRemove.OnMove = this.OnRemoveMove;
         this.FBtnRemove.OnOut = this.OnRemoveOut;
         this.FBtnRemove.Substrate = _loc7_["Btn_Remove"];
         this.FBtnRefresh = new TUIButton();
         this.FBtnRefresh.OnClick = this.OnRefreshClick;
         this.FBtnRefresh.Substrate = _loc7_["Btn_Refresh"];
         this.FCheckBox = _loc7_["MC_Check"]["MC_Button"];
         this.FCheckBox.gotoAndStop(2);
         this.FCheckBox.addEventListener(MouseEvent.CLICK,this.OnCheckBox);
         this.FWheelEffect = new TWheelEffect();
         this.FWheelEffect.Init(Item_Num,Gallery_Speed,1,2,3);
         this.FWheelEffect.ChangeCall = this.OnGalleryChange;
         this.FWheelEffect.StopToTargetCall = this.OnGalleryStop;
         this.FTFRemoveTitle = _loc7_["Btn_Remove"]["TF_Title"];
         this.FShowAwardUI = new TShowAwardUI(this);
         this.FShowAwardUI.UIDispatch(FScene["MC_Hero"]);
      }
      
      override public function Show(param1:TActivityAtoms = null, param2:THDActivityBase = null, param3:TActivityOSBase = null) : void
      {
         this.FConfigData = param2 as THDGallery;
         this.FActivityData = param3 as THDGalleryData;
         super.Show(param1,param2,param3);
         this.UpdateUI();
         this.FShowAwardUI.SetData(TShowAwardUI.ArticalType_Gift,this.FConfigData.LoginAwardIdVec[this.FActivityData.CurDay],0);
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TGalleryDisplay = null;
         var _loc4_:TGalleryItem = null;
         super.LogicsPerform();
         if(this.FBtnRefresh != null && this.FActivityData != null)
         {
            if(this.FFlag == 1)
            {
               this.FBtnRefresh.Enabled = false;
            }
            else
            {
               this.FBtnRefresh.Enabled = this.FActivityData.RemoveStatus <= 0;
            }
         }
         if(this.FWheelEffect == null)
         {
            return;
         }
         this.FWheelEffect.Loop();
         _loc1_ = 0;
         loop0:
         while(_loc1_ < Color_Num - 1)
         {
            _loc2_ = 0;
            while(true)
            {
               if(_loc2_ >= Display_Num)
               {
                  _loc1_++;
                  continue loop0;
               }
               _loc3_ = this.FDisplaysVec[_loc1_][_loc2_];
               if(_loc3_ == null)
               {
                  break;
               }
               _loc3_.Update();
               _loc2_++;
            }
            return;
         }
         _loc1_ = 0;
         loop2:
         while(_loc1_ < Color_Num)
         {
            _loc2_ = 0;
            while(true)
            {
               if(_loc2_ >= Color_Num)
               {
                  _loc1_++;
                  continue loop2;
               }
               _loc4_ = this.FAwardVec[_loc1_ * Color_Num + _loc2_];
               if(_loc4_ == null)
               {
                  break;
               }
               _loc4_.Update();
               _loc2_++;
            }
            return;
         }
      }
      
      public function set FindRewardIndex(param1:int) : void
      {
         this.FFindRewardIndex = param1;
      }
   }
}

