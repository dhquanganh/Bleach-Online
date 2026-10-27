package Processors.Game.Lobby.HellButterfly
{
   import Components.Standard.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.BleachAgent.TBleachAgentData;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HellButterfly.*;
   import Logics.Vip.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.HellButterfly.Component.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Utilities.Timing.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorMainButterfly extends TProcessorLobbyWindow
   {
      
      protected static const MAX_LEVEL:uint = 150;
      
      protected static const TF_POSX:uint = 130;
      
      protected static const EAT_ONCE:uint = 0;
      
      protected static const EAT_FRIEND:uint = 1;
      
      protected static const EAT_FAMILY:uint = 2;
      
      protected static const COMMUNICATION_ONCE:uint = 0;
      
      protected static const COMMUNICATION_BATCH:uint = 1;
      
      protected var FScence:Sprite;
      
      protected var FTF_Name:TextField;
      
      protected var FTF_Level:TextField;
      
      protected var FTF_CDTime:TextField;
      
      protected var FTF_Limit:TextField;
      
      protected var FTF_ExpNum:TextField;
      
      protected var FTF_TF:TextField;
      
      protected var FTF_NowCount:TextField;
      
      protected var FTF_VIP:TextField;
      
      protected var FTF_NextCount:TextField;
      
      protected var FTF_CostGold:TextField;
      
      protected var FTF_GainSilver:TextField;
      
      protected var FTF_NextLevel:TextField;
      
      protected var FTF_NextGainSilver:TextField;
      
      protected var FMC_Effect:MovieClip;
      
      protected var FMC_EffectBG:MovieClip;
      
      protected var FMC_EffectBG1:MovieClip;
      
      protected var FMC_ExpBar:Sprite;
      
      protected var FMC_Count:Sprite;
      
      protected var FMC_MC:Sprite;
      
      protected var FMC_Communications:Sprite;
      
      protected var FMC_InMine:Sprite;
      
      protected var FBT_Eat:TUIButton;
      
      protected var FBT_Collection:TUIButton;
      
      protected var FBT_CommunicationBatch:TUIButton;
      
      protected var FBT_CommunicationOnce:TUIButton;
      
      protected var FBT_Back:TUIButton;
      
      protected var FHellButterflyData:THellButterfly;
      
      protected var FCharacter:TCharacter;
      
      protected var FVipData:TVip;
      
      protected var FBuyMoney:TBins;
      
      protected var FButterfly:TBins;
      
      protected var FConfigValue:TBins;
      
      protected var FCurFriendDigest:TFriendDigest;
      
      protected var FCommunicationType:int;
      
      protected var FNoVipCount:uint;
      
      protected var FUIWindowConfirmationMakeRamen:TUIWindowConfirmation;
      
      protected var FUIWindowRecharge:TUIWindowRecharge;
      
      protected var FUIWindowCollection:TCollection;
      
      protected var FIsInCD:Boolean;
      
      protected var FEatCD:uint;
      
      protected var FSameOrganization:TFriendDigests;
      
      protected var FBatchCount:uint;
      
      protected var FBAData:TBleachAgentData;
      
      protected var FOnCommuincation:Function;
      
      protected var FOnEat:Function;
      
      protected var FOnFeedCollection:Function;
      
      protected var FOnBackMyself:Function;
      
      protected var FResetFriendList:Function;
      
      protected var FOnEatMove:Function;
      
      protected var FOnEatOut:Function;
      
      public function TProcessorMainButterfly(param1:TUIComponent)
      {
         super(param1);
         this.FHellButterflyData = SLogicsCore.HellButterfly;
         this.FCharacter = SLogicsCore.Character;
         this.FVipData = this.FCharacter.VipData;
         this.FBAData = SLogicsCore.BleachAgentData;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FIsInCD)
         {
            this.LogicsPerform_Timer();
         }
      }
      
      private function LogicsPerform_Timer() : void
      {
         var _loc1_:int = 0;
         _loc1_ = this.FHellButterflyData.EatCD - STimingCore.ServerTick;
         if(_loc1_ < 0 || this.FHellButterflyData.EatCount <= 0)
         {
            this.FIsInCD = false;
            this.FTF_CDTime.visible = false;
            return;
         }
         if(!this.FHellButterflyData.IsMyself)
         {
            this.FTF_CDTime.visible = false;
            return;
         }
         this.FTF_CDTime.visible = true;
         this.FTF_CDTime.text = TUtilityTiming.fomatTime(_loc1_);
      }
      
      private function MainButterflyInit() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:TConfigValue = null;
         this.FTF_Name = this.FScence["TF_ShopName"];
         this.FTF_Level = this.FScence["TF_Level"];
         this.FTF_CDTime = this.FScence["tf_time"];
         this.FTF_Limit = this.FScence["TF_Limit"];
         this.FTF_Limit.mouseEnabled = false;
         this.FTF_CDTime.mouseEnabled = false;
         _loc1_ = this.FScence["MC_Bar"];
         this.FTF_ExpNum = _loc1_["TF_ExpNum"];
         this.FTF_ExpNum.mouseEnabled = false;
         this.FMC_ExpBar = _loc1_["MC_ExpBar"];
         this.FMC_Count = this.FScence["MC_Count"];
         this.FTF_TF = this.FMC_Count["TF_tf"];
         this.FTF_NowCount = this.FMC_Count["TF_NowCount"];
         this.FTF_VIP = this.FMC_Count["TF_VIP"];
         this.FTF_NextCount = this.FMC_Count["TF_NextCount"];
         this.FMC_MC = this.FScence["MC_mc"];
         this.FTF_CostGold = this.FMC_MC["TF_CostGold"];
         this.FTF_GainSilver = this.FMC_MC["TF_GainSilver"];
         this.FTF_NextLevel = this.FMC_MC["TF_NextLevel"];
         this.FTF_NextGainSilver = this.FMC_MC["TF_NextGainSilver"];
         this.FMC_Effect = this.FScence["MC_Effect"];
         this.FMC_EffectBG = this.FScence["MC_EffectBG"];
         this.FMC_EffectBG1 = this.FScence["MC_EffectBG1"];
         this.FBT_Eat = new TUIButton();
         this.FBT_Eat.Substrate = this.FScence["BT_Eat"];
         this.FBT_Eat.OnMove = this.FOnEatMove;
         this.FBT_Eat.OnOut = this.FOnEatOut;
         this.FBT_Eat.OnClick = this.EatOnClick;
         this.FBT_Collection = new TUIButton();
         this.FBT_Collection.Substrate = this.FScence["BT_Collection"];
         this.FBT_Collection.Hint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_26);
         this.FBT_Collection.OnClick = this.CollectionOnClick;
         this.FBT_Collection.OnMove = this.FOnEatMove;
         this.FBT_Collection.OnOut = this.FOnEatOut;
         this.FMC_Communications = this.FScence["MC_Communications"];
         this.FMC_InMine = this.FMC_Communications["MC_InMine"];
         this.FBT_Back = new TUIButton();
         this.FBT_Back.Substrate = this.FMC_Communications["BT_Back"];
         this.FBT_Back.OnClick = this.BackOnClick;
         this.FBT_CommunicationBatch = new TUIButton();
         this.FBT_CommunicationBatch.Substrate = this.FMC_InMine["BT_CommunicationBatch"];
         this.FBT_CommunicationBatch.OnClick = this.CommunicationOnClick;
         this.FBT_CommunicationOnce = new TUIButton();
         this.FBT_CommunicationOnce.Substrate = this.FMC_InMine["BT_CommunicationOnce"];
         this.FBT_CommunicationOnce.OnClick = this.CommunicationOnClick;
         this.FUIWindowConfirmationMakeRamen = new TUIWindowConfirmation(this.Parent.Parent);
         this.FUIWindowConfirmationMakeRamen.OnOK = this.WindowConfirmationMakeRamenOnOK;
         TUtilityUIWindow.SetupWindowConfirmation(this.FUIWindowConfirmationMakeRamen);
         this.FUIWindowConfirmationMakeRamen.SetCheckBoxUsable(true);
         this.FUIWindowRecharge = SUtilityOverLayer.UIWindowRecharge;
         this.FUIWindowCollection = new TCollection(this.Parent.Parent);
         this.FUIWindowCollection.Resource = TUtilityReflection.CreateDisplayObjectInstance(CONST_HELLBUTTERFLY.RESOURCE_ClassName_COLLECTION) as Sprite;
         this.FUIWindowCollection.OnCollection = this.OnCollection;
         this.FUIWindowCollection.Init();
         this.FBuyMoney = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BuyMoney);
         this.FConfigValue = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         this.FButterfly = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Butterfly);
         _loc2_ = this.FConfigValue.GetDatebaseByIdentifier(CONST_CONFIGVALUE.HELLBUTTERFLY_EAT_CD) as TConfigValue;
         this.FEatCD = _loc2_.Value as uint;
         _loc2_ = this.FConfigValue.GetDatebaseByIdentifier(CONST_CONFIGVALUE.HELLBUTTERFLY_BatchCount) as TConfigValue;
         this.FBatchCount = _loc2_.Value as uint;
         _loc2_ = this.FConfigValue.GetDatebaseByIdentifier(CONST_CONFIGVALUE.HELLBUTTERFLY_NoVipCount) as TConfigValue;
         this.FNoVipCount = _loc2_.Value as uint;
         TutorialSendComponent(CONST_FRESHGUIDE.MCID_BufferFlyView,this);
         TutorialSendArrowParent(CONST_FRESHGUIDE.MCID_BufferFlyView,FParent);
         TutorialSendComponent(CONST_FRESHGUIDE.MCID_BufferFlyCiteSecondView,this.FUIWindowConfirmationMakeRamen);
         TutorialSendArrowParent(CONST_FRESHGUIDE.MCID_BufferFlyCiteSecondView,FParent.parent);
         TutorialSendComponent(CONST_FRESHGUIDE.MCID_BufferFlyFeedSecondView,this.FUIWindowCollection);
         TutorialSendArrowParent(CONST_FRESHGUIDE.MCID_BufferFlyFeedSecondView,FParent.parent);
      }
      
      private function OnCollection() : void
      {
         if(this.FOnFeedCollection != null)
         {
            this.FOnFeedCollection();
         }
      }
      
      private function UpdateCommon() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TButterfly = null;
         this.FTF_Name.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_27),this.FHellButterflyData.Name);
         this.FTF_Level.text = this.FHellButterflyData.Level.toString();
         _loc2_ = this.FHellButterflyData.CurExp;
         _loc4_ = this.FButterfly.GetDatebaseByIdentifier(this.FHellButterflyData.Level) as TButterfly;
         _loc3_ = _loc4_.UpgradeExp;
         this.FTF_ExpNum.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_01),_loc2_,_loc3_);
         _loc1_ = _loc2_ / _loc3_;
         if(_loc1_ > 1)
         {
            _loc1_ = 1;
         }
         this.FMC_ExpBar.scaleX = _loc1_;
         this.FMC_Effect.gotoAndStop(_loc4_.ModelId);
         this.FMC_EffectBG.gotoAndStop(_loc4_.ModelId);
         this.FMC_Effect.MC_EffectButterfly.play();
         this.FMC_Effect.MC_EffectButterfly.MC_ButtetflyIner.play();
         this.FCommunicationType = -1;
      }
      
      private function UpdateFriend() : void
      {
         this.FTF_CDTime.visible = false;
         this.FBT_Collection.Visible = false;
         this.FMC_Count.visible = false;
         this.FMC_MC.visible = false;
         this.FTF_Limit.visible = false;
         if(this.FCurFriendDigest.SendGoodOrNot)
         {
            this.FBT_Eat.Visible = false;
         }
         else
         {
            this.FBT_Eat.Visible = true;
         }
         this.FBT_Eat.Hint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_25);
         this.FBT_Back.Visible = true;
         this.FMC_InMine.visible = false;
      }
      
      private function UpdateMyself() : void
      {
         if(this.FHellButterflyData.CollectionLevel < this.FHellButterflyData.Level)
         {
            this.FBT_Collection.Visible = true;
         }
         else
         {
            this.FBT_Collection.Visible = false;
         }
         this.FBT_Back.Visible = false;
         this.FMC_InMine.visible = true;
         if(this.FVipData.MoreChange)
         {
            this.FBT_CommunicationBatch.Enabled = true;
            this.FTF_Limit.visible = false;
         }
         else
         {
            this.FBT_CommunicationBatch.Enabled = false;
            this.FTF_Limit.visible = true;
         }
      }
      
      private function UpdateCommuincationText(param1:uint) : void
      {
         var _loc2_:TBuyMoney = null;
         var _loc3_:TBuyMoney = null;
         var _loc4_:TVipConfig = null;
         if(param1 < MAX_LEVEL)
         {
            _loc2_ = this.FBuyMoney.GetDatebaseByIdentifier(param1 + 1) as TBuyMoney;
         }
         else
         {
            _loc2_ = this.FBuyMoney.GetDatebaseByIdentifier(param1) as TBuyMoney;
         }
         _loc3_ = this.FBuyMoney.GetDatebaseByIdentifier(this.FCharacter.GetMainRebirthLevel()) as TBuyMoney;
         if(this.FBAData.GetWelfareCountByType(this.FBAData.WelfareType_DayHellButterflyCount) > 0)
         {
            this.FTF_CostGold.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_02),0);
         }
         else
         {
            this.FTF_CostGold.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_02),_loc2_.CostGold);
         }
         this.FTF_GainSilver.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_03),_loc3_.Money);
         if(this.FCharacter.GetMainRebirthLevel() < MAX_LEVEL)
         {
            this.FTF_NextLevel.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_06),this.FCharacter.GetMainRebirthLevel() + 1);
            _loc3_ = this.FBuyMoney.GetDatebaseByIdentifier(this.FCharacter.GetMainRebirthLevel() + 1) as TBuyMoney;
            this.FTF_NextGainSilver.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_03),_loc3_.Money);
         }
         else
         {
            this.FTF_NextLevel.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_06),this.FCharacter.GetMainRebirthLevel());
            this.FTF_NextGainSilver.text = this.FTF_GainSilver.text;
         }
         if(this.FVipData.VipLevel == this.FVipData.VipLevelUpperLimit)
         {
            this.FTF_NowCount.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_04),this.FHellButterflyData.CurCommunicationCount);
            this.FTF_VIP.visible = this.FTF_NextCount.visible = false;
            this.FTF_TF.x = TF_POSX;
            this.FTF_NowCount.x = this.FTF_TF.x + this.FTF_TF.width;
         }
         else
         {
            this.FTF_VIP.visible = this.FTF_NextCount.visible = true;
            _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_VipConfig,this.FVipData.VipLevel + 1) as TVipConfig;
            this.FTF_NowCount.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_04),this.FHellButterflyData.CurCommunicationCount);
            this.FTF_VIP.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_05),this.FVipData.VipLevel + 1);
            this.FTF_NextCount.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_04),_loc4_.DailyChangeNum);
         }
         this.FMC_Count.visible = true;
         this.FMC_MC.visible = true;
      }
      
      protected function WindowConfirmationMakeRamenOnOK(param1:Object) : void
      {
         if(this.FOnCommuincation != null)
         {
            this.FOnCommuincation(this.FCommunicationType);
         }
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClickBufferFlySecondViewOkBtn);
      }
      
      private function UpdataEatBT(param1:uint, param2:Boolean) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TFriendDigest = null;
         if(this.FHellButterflyData.IsMyself)
         {
            this.SetEatBT();
            if(this.FHellButterflyData.EatCount != 0)
            {
               if(param2)
               {
                  this.FHellButterflyData.EatCD = STimingCore.ServerTick + this.FEatCD;
                  this.FIsInCD = true;
               }
            }
            else
            {
               this.FTF_CDTime.text = "";
               this.FIsInCD = false;
            }
            if(this.FHellButterflyData.Level > this.FHellButterflyData.CollectionLevel)
            {
               this.FBT_Collection.Visible = true;
            }
         }
         else
         {
            switch(param1)
            {
               case EAT_ONCE:
               case EAT_FRIEND:
                  this.FBT_Eat.Visible = false;
                  break;
               case EAT_FAMILY:
                  _loc4_ = uint(this.FSameOrganization.Count);
                  _loc3_ = 0;
                  while(_loc3_ < _loc4_)
                  {
                     _loc5_ = this.FSameOrganization.GetDigestByIndex(_loc3_);
                     if(this.FCurFriendDigest.Identifier0 == _loc5_.Identifier0 && this.FCurFriendDigest.Identifier1 == _loc5_.Identifier1)
                     {
                        this.FBT_Eat.Visible = false;
                        break;
                     }
                     _loc3_++;
                  }
            }
         }
      }
      
      private function CollectionOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FUIWindowCollection.UpdateCollection(this.FHellButterflyData.CollectionLevel);
         this.FUIWindowCollection.Visible = true;
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClickCollectionBtn);
      }
      
      private function EatOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:TButterfly = null;
         var _loc3_:uint = EAT_ONCE;
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_FeedBufferFly);
         if(this.FHellButterflyData.IsMyself && this.FIsInCD)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_17));
            return;
         }
         _loc5_ = this.FHellButterflyData.CurExp;
         _loc7_ = this.FButterfly.GetDatebaseByIdentifier(this.FHellButterflyData.Level) as TButterfly;
         _loc6_ = _loc7_.UpgradeExp;
         if(this.FHellButterflyData.IsMyself)
         {
            _loc4_ = this.FCharacter.GetMainRebirthLevel();
            if(this.FHellButterflyData.Level == _loc4_ && _loc5_ == _loc6_ - 1)
            {
               EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_21));
               return;
            }
         }
         else
         {
            _loc4_ = this.FCurFriendDigest.Level;
         }
         if(this.FOnEat != null)
         {
            this.FOnEat(_loc3_,this.FHellButterflyData.NowIdentifier0,this.FHellButterflyData.NowIdentifier1);
         }
      }
      
      private function CommunicationOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TBuyMoney = null;
         var _loc4_:TBuyMoney = null;
         var _loc5_:TBuyMoney = null;
         var _loc6_:TConfigValue = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:int = 0;
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_CiteBufferFly);
         if(this.FVipData.VipLevel == 0)
         {
            _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BuyMoney,this.FNoVipCount - this.FHellButterflyData.CurCommunicationCount + 1) as TBuyMoney;
         }
         else
         {
            _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BuyMoney,this.FVipData.DailyChangeNum - this.FHellButterflyData.CurCommunicationCount + 1) as TBuyMoney;
         }
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BuyMoney,this.FCharacter.GetMainRebirthLevel()) as TBuyMoney;
         if(this.FHellButterflyData.CurCommunicationCount <= 0)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_07));
            return;
         }
         switch(param2.currentTarget.name)
         {
            case "BT_CommunicationOnce":
               this.FCommunicationType = COMMUNICATION_ONCE;
               if(this.FBAData.GetWelfareCountByType(this.FBAData.WelfareType_DayHellButterflyCount) > 0)
               {
                  if(this.FOnCommuincation != null)
                  {
                     this.FOnCommuincation(this.FCommunicationType);
                  }
               }
               else
               {
                  if(this.FCharacter.CreditGold + this.FCharacter.CreditGiftCertificate < _loc3_.CostGold)
                  {
                     this.FUIWindowRecharge.SetGoldNum(_loc3_.CostGold);
                     this.FUIWindowRecharge.Visible = true;
                     return;
                  }
                  if(!this.FUIWindowConfirmationMakeRamen.IsSelected)
                  {
                     this.FUIWindowConfirmationMakeRamen.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_08),_loc3_.CostGold);
                     this.FUIWindowConfirmationMakeRamen.SetCheckBoxUsable(true);
                     this.FUIWindowConfirmationMakeRamen.Visible = true;
                  }
                  else if(this.FOnCommuincation != null)
                  {
                     this.FOnCommuincation(this.FCommunicationType);
                  }
               }
               break;
            case "BT_CommunicationBatch":
               this.FCommunicationType = COMMUNICATION_BATCH;
               _loc9_ = 0;
               while(_loc9_ < this.FBuyMoney.Count)
               {
                  _loc5_ = this.FBuyMoney.GetDatebaseByIndex(_loc9_) as TBuyMoney;
                  if(_loc5_.Identifier == this.FVipData.DailyChangeNum - this.FHellButterflyData.CurCommunicationCount + 1)
                  {
                     _loc10_ = 0;
                     if(this.FHellButterflyData.CurCommunicationCount < this.FBatchCount)
                     {
                        _loc11_ = _loc9_ + this.FHellButterflyData.CurCommunicationCount;
                     }
                     else
                     {
                        _loc11_ = _loc9_ + this.FBatchCount;
                     }
                     _loc11_ -= this.FBAData.GetWelfareCountByType(this.FBAData.WelfareType_DayHellButterflyCount);
                     _loc8_ = _loc9_;
                     while(_loc8_ < _loc11_)
                     {
                        _loc5_ = this.FBuyMoney.GetDatebaseByIndex(_loc8_) as TBuyMoney;
                        _loc10_ += _loc5_.CostGold;
                        _loc8_++;
                     }
                     break;
                  }
                  _loc9_++;
               }
               if(this.FCharacter.CreditGold + this.FCharacter.CreditGiftCertificate < _loc10_)
               {
                  this.FUIWindowRecharge.SetGoldNum(_loc10_);
                  this.FUIWindowRecharge.visible = true;
                  return;
               }
               if(this.FHellButterflyData.CurCommunicationCount < this.FBatchCount)
               {
                  _loc7_ = uint(this.FHellButterflyData.CurCommunicationCount);
               }
               else
               {
                  _loc7_ = this.FBatchCount;
               }
               this.FUIWindowConfirmationMakeRamen.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_09),_loc10_,_loc7_,_loc4_.Money * this.FBatchCount);
               this.FUIWindowConfirmationMakeRamen.SetCheckBoxUsable(false);
               this.FUIWindowConfirmationMakeRamen.Visible = true;
         }
      }
      
      private function BackOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnBackMyself != null)
         {
            this.FOnBackMyself(this.FCharacter.Identifier0,this.FCharacter.Identifier1);
         }
      }
      
      public function get OnCommuincation() : Function
      {
         return this.FOnCommuincation;
      }
      
      public function set OnCommuincation(param1:Function) : void
      {
         this.FOnCommuincation = param1;
      }
      
      public function get OnEat() : Function
      {
         return this.FOnEat;
      }
      
      public function set OnEat(param1:Function) : void
      {
         this.FOnEat = param1;
      }
      
      public function get OnFeedCollection() : Function
      {
         return this.FOnFeedCollection;
      }
      
      public function set OnFeedCollection(param1:Function) : void
      {
         this.FOnFeedCollection = param1;
      }
      
      public function get OnBackMyself() : Function
      {
         return this.FOnBackMyself;
      }
      
      public function set OnBackMyself(param1:Function) : void
      {
         this.FOnBackMyself = param1;
      }
      
      public function get ResetFriendList() : Function
      {
         return this.FResetFriendList;
      }
      
      public function set ResetFriendList(param1:Function) : void
      {
         this.FResetFriendList = param1;
      }
      
      public function set SameOrganization(param1:TFriendDigests) : void
      {
         this.FSameOrganization = param1;
      }
      
      public function get OnEatMove() : Function
      {
         return this.FOnEatMove;
      }
      
      public function set OnEatMove(param1:Function) : void
      {
         this.FOnEatMove = param1;
      }
      
      public function get OnEatOut() : Function
      {
         return this.FOnEatOut;
      }
      
      public function set OnEatOut(param1:Function) : void
      {
         this.FOnEatOut = param1;
      }
      
      public function MainInit(param1:Sprite) : void
      {
         this.FScence = param1;
         this.MainButterflyInit();
      }
      
      public function MainReset() : void
      {
         this.FTF_Name.text = "";
         this.FTF_Level.text = "";
         this.FTF_CDTime.text = "";
         this.FTF_ExpNum.text = "";
         this.FTF_NowCount.text = "";
         this.FTF_VIP.text = "";
         this.FTF_NextCount.text = "";
         this.FTF_CostGold.text = "";
         this.FTF_GainSilver.text = "";
         this.FTF_NextLevel.text = "";
         this.FTF_NextGainSilver.text = "";
         this.FMC_Communications.visible = false;
         this.FMC_ExpBar.width = 0;
         this.FMC_Effect.MC_EffectButterfly.stop();
         this.FMC_Effect.MC_EffectButterfly.MC_ButtetflyIner.stop();
      }
      
      public function MainUpdate(param1:TFriendDigests) : void
      {
         var _loc2_:uint = 0;
         this.UpdateCommon();
         this.FMC_Communications.visible = true;
         if(this.FHellButterflyData.IsMyself)
         {
            this.UpdateMyself();
            if(this.FResetFriendList != null)
            {
               this.FResetFriendList();
            }
            if(this.FCharacter.VipData.VipLevel == 0)
            {
               _loc2_ = this.FNoVipCount - this.FHellButterflyData.CurCommunicationCount;
            }
            else
            {
               _loc2_ = this.FCharacter.VipData.DailyChangeNum - this.FHellButterflyData.CurCommunicationCount;
            }
            this.UpdateCommuincationCount(_loc2_);
            this.SetEatBT();
            this.UpdateCD();
         }
         else
         {
            this.FCurFriendDigest = param1.GetDigestByIdentifier(this.FHellButterflyData.NowIdentifier0,this.FHellButterflyData.NowIdentifier1);
            this.UpdateFriend();
         }
      }
      
      public function UpdateCommuincationCount(param1:uint) : void
      {
         this.UpdateCommuincationText(param1);
      }
      
      public function SetEatBT() : void
      {
         if(this.FHellButterflyData.EatCount != 0)
         {
            this.FBT_Eat.Visible = true;
         }
         else
         {
            this.FBT_Eat.Visible = false;
         }
         this.FBT_Eat.Hint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_24);
      }
      
      public function UpdateCurCount(param1:uint) : void
      {
         if(param1 == 0)
         {
            --this.FHellButterflyData.CurCommunicationCount;
         }
         else
         {
            this.FHellButterflyData.CurCommunicationCount -= this.FBatchCount;
         }
         if(this.FHellButterflyData.CurCommunicationCount <= 0)
         {
            this.FHellButterflyData.CurCommunicationCount = 0;
         }
         if(this.FVipData.VipLevel == 0)
         {
            this.UpdateCommuincationText(this.FNoVipCount - this.FHellButterflyData.CurCommunicationCount);
         }
         else
         {
            this.UpdateCommuincationText(this.FVipData.DailyChangeNum - this.FHellButterflyData.CurCommunicationCount);
         }
      }
      
      public function UpdateEat(param1:uint, param2:Boolean) : void
      {
         this.UpdateCommon();
         this.UpdataEatBT(param1,param2);
      }
      
      public function UpdateFeeding(param1:uint) : void
      {
         if(param1 >= this.FHellButterflyData.Level)
         {
            this.FUIWindowCollection.Visible = false;
            this.FBT_Collection.Visible = false;
            return;
         }
         this.FUIWindowCollection.UpdateCollection(param1);
      }
      
      public function UpdateCD() : void
      {
         if(this.FHellButterflyData.EatCD - STimingCore.ServerTick >= 0)
         {
            this.FIsInCD = true;
         }
         else
         {
            this.FIsInCD = false;
         }
      }
      
      public function PlayEffect(param1:Boolean) : void
      {
         if(param1)
         {
            this.FMC_EffectBG1.play();
         }
         else
         {
            this.FMC_EffectBG1.stop();
         }
      }
   }
}

