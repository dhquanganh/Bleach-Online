package Processors.Game.Lobby.Activity.HDHerosMarket
{
   import Components.Pages.*;
   import Components.Slots.*;
   import Components.Standard.*;
   import Externals.*;
   import Foundation.Common.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HDActivityOS.*;
   import Logics.HDHerosMarket.*;
   import Logics.HDIceHeros.*;
   import Logics.Inventories.*;
   import Logics.KnifeOfKillSoul.*;
   import Processors.Game.Common.Effects.Display.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Activity.HDChineseYear.Component.*;
   import Processors.Game.Lobby.Activity.HDGeneralSell.Compoent.*;
   import Processors.Game.Lobby.Activity.HDHerosMarket.Component.*;
   import Processors.Game.Lobby.Common.Hero.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.TUIWindowConfirmation;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowHerosMarkets extends TProcessorHDSingleWindowBase
   {
      
      protected static const CONST_HEROLIST_MAX:uint = 4;
      
      protected static const KNIFE_WIDTH:uint = 254;
      
      protected static const KNIFE_HEIGHT:uint = 435;
      
      protected var UIIceHeroPlayer:TUIIceHeroPlayer;
      
      protected var FWindowShowHero:TProcessorWindowHeroDescription;
      
      protected var FRoleModelIDs:Vector.<uint>;
      
      protected var FHeroData:TActivityIHAward;
      
      protected var FKnifePop:TKnifePop;
      
      protected var FMC_KnifeInfo:Sprite;
      
      protected var FKnifeOfKillSoulData:TKnifeOfKillSoulData;
      
      protected var FUITab:TUITab;
      
      protected var FHD_HerosMarket:THDHerosMarket;
      
      protected var FData_HerosMarket:TActivityHerosMarkets;
      
      protected var FGeneralList:Vector.<TUIHeroItem>;
      
      protected var FCurHerosList:Vector.<uint>;
      
      protected var FRoldModelBins:TBins;
      
      protected var FCurHeroId:uint;
      
      protected var FMC_Effect:MovieClip;
      
      protected var FMC_TitleEffect:MovieClip;
      
      protected var FSP_Shop:Sprite;
      
      protected var FBtn_ShopBuy:TUIButton;
      
      protected var FBtn_ShopGet:TUIButton;
      
      protected var FTF_SlotName:TextField;
      
      protected var FTF_FreeNum:TextField;
      
      protected var FTF_SlotPrice:TextField;
      
      protected var FSlot:TUISlot;
      
      protected var FHeroSlotAward:TInventory;
      
      protected var FKnifeSlotAward:TInventory;
      
      protected var FBtn_FightReport:TUIButton;
      
      protected var FBtn_Achieve:TUIButton;
      
      protected var FAwardInventories:Vector.<TInventories>;
      
      protected var FIsInitWindow:Boolean;
      
      protected var FIsInitData:Boolean;
      
      protected var FFreeFlag:Vector.<int>;
      
      protected var FKindFlag:Vector.<int>;
      
      protected var FBuyIndex:int;
      
      protected var FBattleReportID:String;
      
      protected var FGlowTwo:TEffectBaseGlowTwo;
      
      protected var FWindowConfirmation:TUIWindowConfirmation;
      
      protected var FOnCreateKnifeOfKillSoulData:Function;
      
      protected var FOnAchieveShow:Function;
      
      public function TProcessorWindowHerosMarkets(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = "MC_HerosMarkets";
         FActivityID = CONST_ACTIVITY_MODE.Activity_HerosMarkets;
         this.FRoleModelIDs = new Vector.<uint>();
         this.FHeroData = new TActivityIHAward(0);
         FHint = new THint();
         this.FFreeFlag = new Vector.<int>(1);
         this.FKindFlag = new Vector.<int>(1);
         this.FIsInitWindow = false;
         this.FIsInitData = false;
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:TUIHeroItem = null;
         super.InitWindow(param1);
         this.UIIceHeroPlayer = new TUIIceHeroPlayer(this);
         this.UIIceHeroPlayer.OnBtnOKClick = this.ProcessorHeroBtnOKOnClick;
         this.UIIceHeroPlayer.OnShowHeroClick = this.ProcessorShowHeroOnClick;
         this.UIIceHeroPlayer.SequenceDefaultRole = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCEID_Textures_DefaultRole,0);
         this.UIIceHeroPlayer.OnQuerySequenceContext = this.HeroOnQuerySequenceContext;
         this.UIIceHeroPlayer.Perform_UIDispatch(FScene["MC_Hero"]);
         this.FKnifePop = new TKnifePop(this);
         this.FKnifePop.OnPopColse = this.KnifePopOnClose;
         this.FKnifePop.UIDispatch();
         this.FKnifePop.X = (this.Width - KNIFE_WIDTH) / 2;
         this.FKnifePop.Y = (this.Height - KNIFE_HEIGHT) / 2;
         this.FKnifePop.Visible = false;
         this.FWindowShowHero = new TProcessorWindowHeroDescription(FParent);
         this.FWindowShowHero.Perform_UIDispatch();
         this.FWindowShowHero.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FWindowShowHero.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FWindowShowHero.OnClose = this.BtnCloseLukiaWindowOnMouseClick;
         this.FRoldModelBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_RoleModel);
         this.FGeneralList = new Vector.<TUIHeroItem>(CONST_HEROLIST_MAX);
         _loc2_ = 0;
         while(_loc2_ < CONST_HEROLIST_MAX)
         {
            _loc4_ = FScene["MC_Hero_" + _loc2_];
            _loc5_ = new TUIHeroItem(this,_loc4_,this.FRoldModelBins);
            _loc5_.OnClick = this.GeneralOnClick;
            this.FGeneralList[_loc2_] = _loc5_;
            _loc2_++;
         }
         this.FUITab = new TUITab(this);
         this.FUITab.SetTabByIndex(FScene["Tab_0"],0);
         this.FUITab.SetTabByIndex(FScene["Tab_1"],1);
         this.FUITab.OnSwitch = this.TabOnSwitch;
         this.FUITab.Init();
         FMC_PageLeft = FScene["btn_left"];
         FMC_PageRight = FScene["btn_right"];
         FUIPage = new TUIPage(this);
         FUIPage.ButtonPrevious.Substrate = FMC_PageLeft;
         FUIPage.ButtonNext.Substrate = FMC_PageRight;
         FUIPage.PageSize = CONST_HEROLIST_MAX;
         FUIPage.OnChangePage = ProcessorPageOnChange;
         FUIPage.Init();
         this.FBtn_FightReport = new TUIButton();
         this.FBtn_FightReport.Substrate = FScene["Btn_FightReport"];
         this.FBtn_FightReport.OnClick = this.BtnShowBattleInfoClick;
         this.FBtn_FightReport.Visible = false;
         this.FBtn_Achieve = new TUIButton();
         this.FBtn_Achieve.Substrate = FScene["Btn_Achieve"];
         this.FBtn_Achieve.OnClick = this.ProcessorOnAchieveShow;
         this.FBtn_Achieve.Visible = false;
         this.FSP_Shop = FScene["MC_Shop"];
         this.FBtn_ShopBuy = new TUIButton();
         this.FBtn_ShopBuy.Substrate = this.FSP_Shop["Btn_Ok"];
         this.FBtn_ShopBuy.OnMove = this.BuyItemOnMove;
         this.FBtn_ShopBuy.OnOut = this.ProcessorOnHintOut;
         this.FBtn_ShopBuy.OnClick = this.SlotBuyOnClick;
         this.FBtn_ShopGet = new TUIButton();
         this.FBtn_ShopGet.Substrate = this.FSP_Shop["Btn_Get"];
         this.FBtn_ShopGet.OnClick = this.SlotGetOnClick;
         this.FTF_SlotName = this.FSP_Shop["TF_SlotName"];
         this.FTF_FreeNum = this.FSP_Shop["TF_FreeNum"];
         this.FTF_SlotPrice = this.FSP_Shop["TF_SlotPrice"];
         this.FSlot = new TUISlot(this);
         this.FSlot.Resource = this.FSP_Shop["MC_Slot_0"];
         this.FSlot.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         this.FSlot.OnQuerySequenceContext = SlotsOnQuerySequenceContext;
         this.FSlot.OnOver = ProcessorOnSlotOver;
         this.FSlot.OnOut = ProcessorOnSlotOut;
         this.FSlot.OnQuerySubscript = SlotsOnQuerySubscript;
         this.FSlot.Init();
         this.FMC_Effect = FScene["MC_Effect"];
         this.FMC_Effect.play();
         this.FMC_TitleEffect = FScene["MC_TitleEffect"];
         this.FMC_TitleEffect.play();
         this.FIsInitWindow = true;
         this.FWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
      }
      
      private function WindowOk(param1:Object) : void
      {
         this.FFreeFlag[0] = 0;
         if(this.FUITab.TabIndex == 0)
         {
            if(this.FData_HerosMarket.HeroExpStatus < 2)
            {
               this.FFreeFlag[0] = 0;
            }
            else
            {
               this.FFreeFlag[0] = 1;
            }
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FHD_HerosMarket.HeroExpIndex,0,this.FFreeFlag);
         }
         else
         {
            if(this.FData_HerosMarket.KnifeExpStatus < 2)
            {
               this.FFreeFlag[0] = 0;
            }
            else
            {
               this.FFreeFlag[0] = 1;
            }
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FHD_HerosMarket.KnifeExpIndex,0,this.FFreeFlag);
         }
      }
      
      protected function SlotBuyOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         if(this.FUITab.TabIndex == 0)
         {
            _loc3_ = this.FHD_HerosMarket.HeroExpCost;
         }
         else
         {
            _loc3_ = this.FHD_HerosMarket.KnifeExpCost;
         }
         this.FWindowConfirmation.visible = true;
         this.FWindowConfirmation.OnOK = this.WindowOk;
         this.FWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),_loc3_);
      }
      
      protected function SlotGetOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FFreeFlag[0] = 0;
         if(this.FUITab.TabIndex == 0)
         {
            if(this.FData_HerosMarket.HeroExpStatus < 2)
            {
               this.FFreeFlag[0] = 0;
            }
            else
            {
               this.FFreeFlag[0] = 1;
            }
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FHD_HerosMarket.HeroExpIndex,0,this.FFreeFlag);
         }
         else
         {
            if(this.FData_HerosMarket.KnifeExpStatus < 2)
            {
               this.FFreeFlag[0] = 0;
            }
            else
            {
               this.FFreeFlag[0] = 1;
            }
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FHD_HerosMarket.KnifeExpIndex,0,this.FFreeFlag);
         }
      }
      
      protected function ProcessorOnHintOut(param1:Object, param2:MouseEvent) : void
      {
         if(FOnHintOut != null)
         {
            FOnHintOut(this,FHint);
         }
      }
      
      protected function BuyItemOnMove(param1:Object, param2:MouseEvent) : void
      {
         if(this.FUITab.TabIndex == 0)
         {
            FHint.Caption = TUtilityString.Format(this.FHD_HerosMarket.HeroExpTip,this.FHD_HerosMarket.HeroExpCost);
         }
         else
         {
            FHint.Caption = TUtilityString.Format(this.FHD_HerosMarket.KnifeExpTip,this.FHD_HerosMarket.KnifeExpCost);
         }
         if(FOnHintOver != null)
         {
            FOnHintOver(this,FHint);
         }
      }
      
      protected function ProcessorOnAchieveShow(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnAchieveShow != null)
         {
            this.FOnAchieveShow(this.FUITab.TabIndex);
         }
      }
      
      protected function ProcessorOnShowKnifeClick(param1:Object) : void
      {
         this.FKnifePop.KnifeData = this.FKnifeOfKillSoulData;
         this.FKnifePop.Visible = true;
      }
      
      protected function KnifePopOnClose(param1:Object) : void
      {
         FScene.mouseChildren = true;
         FScene.mouseEnabled = true;
         this.FKnifePop.Visible = false;
      }
      
      protected function TabOnSwitch(param1:uint) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = this.FGeneralList.length;
         param1 = 0;
         while(param1 < _loc2_)
         {
            this.FGeneralList[param1].ResetBox();
            param1++;
         }
         FPageIndex = 0;
         this.UpdateCurSlot();
         this.InitHerosList();
         if(this.FUITab.TabIndex == 0)
         {
            if(this.FHD_HerosMarket.HerosHotId.length == 0)
            {
               this.FBtn_Achieve.Enabled = false;
            }
            else
            {
               this.FBtn_Achieve.Enabled = true;
            }
         }
         else if(this.FHD_HerosMarket.KnifeHotId.length == 0)
         {
            this.FBtn_Achieve.Enabled = false;
         }
         else
         {
            this.FBtn_Achieve.Enabled = true;
         }
      }
      
      protected function GeneralOnClick(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc4_ = uint(param1.currentTarget.parent.name.split("_")[2]);
         _loc3_ = this.FGeneralList.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FGeneralList[_loc2_].ResetBox();
            _loc2_++;
         }
         this.FBuyIndex = _loc4_ + FPageIndex * CONST_HEROLIST_MAX;
         this.UpdateCurHero();
      }
      
      protected function BtnShowBattleInfoClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:String = null;
         SExternalCore.NavigateToLinkUrl(this.FBattleReportID);
      }
      
      protected function CheckAlreadyGet(param1:uint) : int
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TInventories = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:THero = null;
         var _loc9_:TKnifeOfKillSoulData = null;
         var _loc10_:int = 0;
         _loc10_ = 0;
         if(this.FUITab.TabIndex == 0)
         {
            _loc5_ = this.FHD_HerosMarket.HerosItemId[param1];
         }
         else
         {
            _loc5_ = this.FHD_HerosMarket.KnifeItemId[param1];
         }
         _loc4_ = SLogicsCore.Character.Appliances;
         _loc10_ = _loc4_.GetCountByTempleteID(_loc5_);
         if(this.FUITab.TabIndex == 0)
         {
            _loc6_ = this.FHD_HerosMarket.HerosId[param1];
            _loc8_ = SLogicsCore.Character.Heros.GetHeroByIdentifier(_loc6_);
            if(_loc8_ != null)
            {
               _loc10_ += 1;
            }
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < 4)
            {
               _loc7_ = this.FHD_HerosMarket.ExpandIds[param1][_loc3_];
               _loc9_ = SLogicsCore.Character.KnifeOfKillSoul.GetByIndentifier(_loc7_);
               if(_loc9_ != null && _loc9_.CurrentState == CONST_KNIFEOFKILLSOUL.KNIFESTATE_UNLOCK)
               {
                  _loc10_ += 1;
               }
               _loc3_++;
            }
         }
         if(_loc10_ > 0)
         {
            _loc10_ = -1;
         }
         else
         {
            _loc10_ = 1;
         }
         return _loc10_;
      }
      
      public function UpdateCurHero() : void
      {
         var _loc1_:int = 0;
         _loc1_ = this.FBuyIndex;
         this.FHeroData.HeroType = this.FUITab.TabIndex + 1;
         if(this.FUITab.TabIndex == 0)
         {
            this.FHeroData.HeroID = this.FHD_HerosMarket.HerosId[_loc1_];
            this.FHeroData.Condition = this.FHD_HerosMarket.HerosCost[_loc1_];
            this.FBattleReportID = this.FHD_HerosMarket.HerosReportId[_loc1_];
         }
         else
         {
            this.FHeroData.HeroID = this.FHD_HerosMarket.ExpandIds[_loc1_][3];
            this.FHeroData.Condition = this.FHD_HerosMarket.KnifeCost[_loc1_];
            this.FBattleReportID = this.FHD_HerosMarket.KnifeReportId[_loc1_];
         }
         this.FHeroData.Status = this.CheckAlreadyGet(_loc1_);
         this.UIIceHeroPlayer.UpdateUI(this.FHeroData,SLogicsCore.Character.CreditGold,TUIIceHeroPlayer.BuyType_Gold);
      }
      
      protected function InitHerosList() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         FUIPage.Reset();
         this.FCurHerosList = new Vector.<uint>();
         if(this.FUITab.TabIndex == 0)
         {
            FUIPage.TotalQuantity = this.FHD_HerosMarket.HerosId.length;
            this.FCurHerosList = this.FHD_HerosMarket.HerosId;
         }
         else
         {
            FUIPage.TotalQuantity = this.FHD_HerosMarket.KnifeId.length;
            this.FCurHerosList = this.FHD_HerosMarket.KnifeId;
         }
         this.UpdateUIPage();
         _loc1_ = this.FGeneralList.length;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            if(_loc2_ <= this.FCurHerosList.length - 1)
            {
               this.FGeneralList[_loc2_].UpdateIcon(this.FCurHerosList[_loc2_],this.FUITab.TabIndex,this.FHD_HerosMarket.HerosPosition[_loc2_]);
               this.FGeneralList[_loc2_].BackGroundVisible = true;
            }
            else
            {
               this.FGeneralList[_loc2_].BackGroundVisible = false;
            }
            _loc2_++;
         }
      }
      
      protected function UpdateHerosList() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc1_ = this.FGeneralList.length;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            if(_loc2_ + FPageIndex * this.FGeneralList.length <= this.FCurHerosList.length - 1)
            {
               if(this.FUITab.TabIndex == 0)
               {
                  _loc3_ = this.FHD_HerosMarket.HerosPosition[_loc2_ + FPageIndex * this.FGeneralList.length];
               }
               else
               {
                  _loc3_ = 0;
               }
               this.FGeneralList[_loc2_].UpdateIcon(this.FCurHerosList[_loc2_ + FPageIndex * this.FGeneralList.length],this.FUITab.TabIndex,_loc3_);
               this.FGeneralList[_loc2_].BackGroundVisible = true;
            }
            else
            {
               this.FGeneralList[_loc2_].BackGroundVisible = false;
            }
            _loc2_++;
         }
      }
      
      protected function UpdateCurSlot() : void
      {
         var _loc1_:TInventory = null;
         var _loc2_:uint = 0;
         if(this.FUITab.TabIndex == 0)
         {
            _loc1_ = this.FHeroSlotAward;
            _loc2_ = this.FHD_HerosMarket.HeroExpCost;
            this.FTF_FreeNum.text = TUtilityString.Format(this.FHD_HerosMarket.ItemTip,2 - this.FData_HerosMarket.HeroExpStatus);
            if(this.FData_HerosMarket.HeroExpStatus == 2)
            {
               this.FBtn_ShopGet.Visible = false;
            }
            else
            {
               this.FBtn_ShopGet.Visible = true;
            }
         }
         else
         {
            _loc1_ = this.FKnifeSlotAward;
            _loc2_ = this.FHD_HerosMarket.KnifeExpCost;
            this.FTF_FreeNum.text = TUtilityString.Format(this.FHD_HerosMarket.ItemTip,2 - this.FData_HerosMarket.KnifeExpStatus);
            if(this.FData_HerosMarket.KnifeExpStatus == 2)
            {
               this.FBtn_ShopGet.Visible = false;
            }
            else
            {
               this.FBtn_ShopGet.Visible = true;
            }
         }
         this.FSlot.Context = _loc1_;
         this.FSlot.Update();
         this.FTF_SlotName.text = _loc1_.Name;
         this.FTF_SlotPrice.text = _loc2_.toString();
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.LogicsPerform();
         if(!this.FIsInitWindow)
         {
            return;
         }
         this.UIIceHeroPlayer.UpdateUIHero();
         this.FSlot.Update();
         if(this.FGlowTwo != null)
         {
            this.FGlowTwo.Run();
         }
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         super.UpdateDataBase(param1);
         this.FData_HerosMarket = param1 as TActivityHerosMarkets;
         if(!this.FIsInitData)
         {
            if(this.FHD_HerosMarket.TabSwitch == 3)
            {
               this.FUITab.SwithTagManual(1);
            }
            else
            {
               this.FUITab.SwithTagManual(0);
            }
         }
         this.FIsInitData = true;
         this.UpdateCurSlot();
         this.UpdateCurHero();
         this.ShowBtn();
      }
      
      protected function ShowBtn() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc1_ = false;
         if(this.FUITab.TabIndex == 0)
         {
            _loc3_ = int(this.FData_HerosMarket.HerosAchieveStatus.length);
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               if(this.FData_HerosMarket.HerosAchieveStatus[_loc2_] == 1)
               {
                  _loc1_ = true;
               }
               _loc2_++;
            }
         }
         else
         {
            _loc3_ = int(this.FData_HerosMarket.KnifesAchieveStatus.length);
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               if(this.FData_HerosMarket.KnifesAchieveStatus[_loc2_] == 1)
               {
                  _loc1_ = true;
               }
               _loc2_++;
            }
         }
         if(_loc1_ == false)
         {
            if(this.FGlowTwo != null)
            {
               this.FGlowTwo.Stop();
               this.FGlowTwo = null;
            }
         }
         else
         {
            this.FGlowTwo = new TEffectBaseGlowTwo();
            this.FGlowTwo.SetParameters(FScene["Btn_Achieve"],16776960,20,2);
         }
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:Vector.<uint> = null;
         super.UpdateUIConfig();
         this.FHD_HerosMarket = FHDActivityConfig as THDHerosMarket;
         ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
         ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         _loc3_ = new Vector.<uint>(2);
         _loc3_[0] = this.FHD_HerosMarket.HeroExpAward;
         _loc3_[1] = this.FHD_HerosMarket.KnifeExpAward;
         this.FAwardInventories = ProcessorGetInventoriesVectByAwardID(_loc3_);
         this.FHeroSlotAward = this.FAwardInventories[0].GetInventoryByIndex(0);
         this.FKnifeSlotAward = this.FAwardInventories[1].GetInventoryByIndex(0);
         if(this.FHD_HerosMarket.TabSwitch == 2)
         {
            this.FUITab.SetTabEnabledByIndex(1,false);
         }
         if(this.FHD_HerosMarket.TabSwitch == 3)
         {
            this.FUITab.SetTabEnabledByIndex(0,false);
         }
      }
      
      override protected function UpdateUI() : void
      {
         this.UpdateUIPage();
      }
      
      protected function UpdateUIPage() : void
      {
         FUIPage.Update();
         FUIPage.PageIndex = FPageIndex;
         this.UpdateHerosList();
      }
      
      protected function ProcessorShowHeroOnClick(param1:Object, param2:TActivityIHAward) : void
      {
         FScene.mouseChildren = false;
         FScene.mouseEnabled = false;
         if(param2.HeroType == 1)
         {
            this.FWindowShowHero.HeroID = param2.HeroID;
            this.FWindowShowHero.Show();
         }
         if(param2.HeroType == 2)
         {
            this.FKnifeOfKillSoulData = this.FOnCreateKnifeOfKillSoulData(param2.HeroID);
            this.FKnifePop.KnifeData = this.FKnifeOfKillSoulData;
            this.FKnifePop.Visible = true;
         }
      }
      
      protected function ProcessorHeroBtnOKOnClick(param1:Object, param2:uint) : void
      {
         this.FKindFlag[0] = this.FBuyIndex;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,100 + this.FUITab.TabIndex,0,this.FKindFlag);
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         super.BtnCloseOnClick(param1,param2);
         if(FOnBtnCloseClick != null)
         {
            FOnBtnCloseClick();
         }
      }
      
      protected function HeroOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         var _loc8_:TRoleModel = null;
         var _loc9_:uint = 0;
         _loc5_ = param2 as uint;
         _loc6_ = SResourcesCore.TexturesModel;
         _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,_loc5_) as TRoleModel;
         if(_loc8_ == null)
         {
            return;
         }
         _loc9_ = (_loc8_.Model << 8) + CONST_ROLE.ROLE_SEQUENCEINDEX_Showcase;
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc9_);
         if(_loc7_ != null)
         {
            param3.Value = _loc7_.GetAnimationSequenceByIndex(0);
         }
         else
         {
            _loc6_.LoadSecondary(_loc9_);
         }
         this.SetRoleModelID(_loc9_);
      }
      
      protected function SetRoleModelID(param1:uint) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FRoleModelIDs.indexOf(param1);
         if(_loc2_ < 0)
         {
            this.FRoleModelIDs.push(param1);
         }
      }
      
      protected function BtnCloseLukiaWindowOnMouseClick(param1:Object) : void
      {
         FScene.mouseChildren = true;
         FScene.mouseEnabled = true;
         this.FWindowShowHero.Hide();
      }
      
      protected function BtnShowKnifeInfoClick(param1:Object, param2:MouseEvent) : void
      {
         this.FMC_KnifeInfo.visible = true;
      }
      
      protected function BtnHideKnifeInfoClick(param1:Object, param2:MouseEvent) : void
      {
         FScene.mouseChildren = true;
         FScene.mouseEnabled = true;
         this.FMC_KnifeInfo.visible = false;
      }
      
      public function get OnAchieveShow() : Function
      {
         return this.FOnAchieveShow;
      }
      
      public function set OnAchieveShow(param1:Function) : void
      {
         this.FOnAchieveShow = param1;
      }
      
      public function set OnCreateKnifeOfKillSoulData(param1:Function) : void
      {
         this.FOnCreateKnifeOfKillSoulData = param1;
      }
   }
}

