package Processors.Game.Lobby.KingChallenge
{
   import Components.Pages.TUIPage;
   import Components.Standard.TUIButton;
   import Components.Standard.TUITab;
   import Foundation.Common.THint;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.TRoleModel;
   import Logics.KingChallenge.TFighterInfo;
   import Logics.KingChallenge.TPlayerInfo;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import Logics.KingChallenge.TKingChallenge;
   import Logics.Streamization.KingChallenge.TUnsteamizerKingChallenge;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import Utilities.Timing.TUtilityTiming;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class TProcessorWindowKingChallenge extends TProcessorLobbyWindow
   {
      
      protected const FTabNum:int = 4;
      
      protected var FMainScene:Sprite;
      
      protected var FGamlbeWin:TUIMyGamble;
      
      protected var FDetailWin:TUIDetail;
      
      protected var FPrizeListWin:TUIPrizeList;
      
      protected var FBtn_Teams:Vector.<TUIButton>;
      
      protected var FBtn_Close:TUIButton;
      
      protected var FBtn_Help:TUIButton;
      
      protected var FPlayers:Vector.<Sprite>;
      
      protected var FBtn_Fights:Vector.<TUIButton>;
      
      protected var FBtn_RankList:TUIButton;
      
      protected var FBtn_UpLoad:TUIButton;
      
      protected var FBtn_ShowPrize:TUIButton;
      
      protected var FBtn_ShowGamble:TUIButton;
      
      protected var FMC_ButtonBar:MovieClip;
      
      protected var FCurTeam:uint;
      
      protected var FHeadBitmap:Bitmap;
      
      protected var FHint:THint;
      
      protected var FPageUI:TUIPage;
      
      protected var FCurrentPage:uint;
      
      protected var FUITab:TUITab;
      
      protected var FCurGroup:uint;
      protected var FRegistrationInfo:TextField;
      
      protected var FNextRefresh:int = 0;
      
      protected var FCurFight:uint;
      
      protected var FOnReturn:Function;
      
      protected var FData:TKingChallenge;
      
      protected var FUnstreamizer:TUnsteamizerKingChallenge;
      
      public function TProcessorWindowKingChallenge(param1:TUIComponent)
      {
         super(param1);
         this.FHeadBitmap = new Bitmap();
         this.FHint = new THint();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         this.FMainScene = TUtilityReflection.CreateDisplayObjectInstance("MC_KingChallenge") as Sprite;
         addChild(this.FMainScene);
         this.FBtn_Help = new TUIButton();
         this.FBtn_Help.Substrate = this.FMainScene["MC_HDDesc"];
         this.FBtn_Help.OnMove = this.ProcessorOnMove;
         this.FBtn_Help.OnOut = this.ProcessorOnOut;
         this.FGamlbeWin = new TUIMyGamble(this);
         this.FGamlbeWin.UIDispatch(this.FMainScene["MC_Gamble"]);
         this.FGamlbeWin.Visible = false;
         this.FDetailWin = new TUIDetail(this);
         this.FDetailWin.UIDispatch(this.FMainScene["MC_Detail"]);
         this.FDetailWin.Visible = false;
         this.FPrizeListWin = new TUIPrizeList(this);
         this.FPrizeListWin.UIDispatch(this.FMainScene["MC_PrizeList"]);
         this.FPrizeListWin.Visible = false;
         this.FBtn_Close = new TUIButton();
         this.FBtn_Close.Substrate = this.FMainScene["Title"]["btn_close"];
         this.FBtn_Close.OnClick = this.ReturnToTown;
         this.FBtn_ShowPrize = new TUIButton();
         this.FBtn_ShowPrize.Substrate = this.FMainScene["MC_JackPiont"];
         this.FBtn_ShowPrize.OnClick = this.ProcessorShowPrize;
         this.FBtn_UpLoad = new TUIButton();
         this.FBtn_UpLoad.Substrate = this.FMainScene["MC_ButtonBar"]["Btn_Upload"]["Btn"];
         this.FBtn_UpLoad.OnClick = this.ProcessorUpload;
         this.FBtn_ShowGamble = new TUIButton();
         this.FBtn_ShowGamble.Substrate = this.FMainScene["MC_ButtonBar"]["Btn_Gamble"]["Btn"];
         this.FBtn_ShowGamble.OnClick = this.ProcessorShowGamble;
         this.FBtn_RankList = new TUIButton();
         this.FBtn_RankList.Substrate = this.FMainScene["rankList"]["View"]["MC_btn"]["Btn_Close"];
         this.FBtn_RankList.OnClick = this.ProcessorShowList;
         this.FMC_ButtonBar = this.FMainScene["MC_ButtonBar"];
         this.FRegistrationInfo = new TextField();
         this.FRegistrationInfo.defaultTextFormat = new TextFormat("Tahoma",12,0xffcc66,false,null,null,null,null,"center");
         this.FRegistrationInfo.x = 360; this.FRegistrationInfo.y = 548;
         this.FRegistrationInfo.width = 530; this.FRegistrationInfo.height = 24;
         this.FRegistrationInfo.mouseEnabled = false;
         this.FMainScene.addChild(this.FRegistrationInfo);
         _loc2_ = 7;
         this.FBtn_Fights = new Vector.<TUIButton>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FBtn_Fights[_loc1_] = new TUIButton();
            this.FBtn_Fights[_loc1_].Substrate = this.FMainScene["MC_Table"]["SP_Fight_" + _loc1_];
            this.FBtn_Fights[_loc1_].OnClick = this.ProcessorShowDetail;
            _loc1_++;
         }
         this.FPageUI = new TUIPage(this);
         this.FPageUI.ButtonNext.Substrate = this.FMainScene["rankList"]["View"]["MC_PageRight"];
         this.FPageUI.ButtonPrevious.Substrate = this.FMainScene["rankList"]["View"]["MC_PageLeft"];
         this.FPageUI.PageSize = 5;
         this.FPageUI.LabelPage = this.FMainScene["rankList"]["View"]["TF_Page"];
         this.FPageUI.OnChangePage = this.PageOnSwitch;
         this.FPageUI.Init();
         this.FPageUI.Update();
         this.FUITab = new TUITab(this);
         _loc2_ = uint(this.FTabNum);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FUITab.SetTabByIndex(this.FMainScene["Tab_" + _loc1_],_loc1_);
            _loc1_++;
         }
         this.FUITab.OnSwitch = this.TabOnSwitch;
         this.FUITab.Init();
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      protected function TabOnSwitch(param1:Object) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1 as int;
         this.FCurrentPage = 0;
         this.FDetailWin.Visible = false;
         this.FGamlbeWin.Visible = false;
         this.FCurGroup = (_loc2_ + 1) * 1000;
         this.FUnstreamizer.InitReq(_loc2_ + 1);
         this.FUnstreamizer.RankReq(_loc2_ + 1);
         this.FUnstreamizer.FightReq(_loc2_ + 1);
      }
      
      protected function ProcessorShowGamble(param1:Object, param2:Event) : void
      {
         this.FGamlbeWin.Data = this.FData.BettingsInfo;
         this.FGamlbeWin.Visible = true;
      }
      
      protected function ProcessorShowList(param1:Object, param2:Event) : void
      {
         this.FMainScene["rankList"].play();
      }
      
      protected function ProcessorShowDetail(param1:Object, param2:Event) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:TFighterInfo = null;
         _loc3_ = uint(param2.currentTarget.name.split("_")[2]);
         this.FCurFight = _loc3_ + this.FCurGroup;
         _loc4_ = this.FData.FindFightInfoById(this.FCurFight);
         if(_loc4_ == null)
         {
            return;
         }
         _loc4_.AttUserInfo = this.FData.FindPlayerInfoById(_loc4_.AttUserLowId,_loc4_.AttUserHighId);
         _loc4_.DefUserInfo = this.FData.FindPlayerInfoById(_loc4_.DefUserLowId,_loc4_.DefUserHighId);
         if(_loc4_.AttUserInfo == null && _loc4_.DefUserInfo == null)
         {
            return;
         }
         this.FDetailWin.Data = _loc4_;
         this.FDetailWin.Visible = true;
      }
      
      protected function ProcessorUpload(param1:Object, param2:Event) : void
      {
         var _loc3_:TPacket = null;
         if(TKingChallenge.RequestPending || this.FData.SeasonStatus != 0)
         {
            return;
         }
         TKingChallenge.RequestPending = true;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_KingChallenge_UploadReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function ProcessorShowPrize(param1:Object, param2:Event) : void
      {
         if(this.FData.UserBaseInfo.Group == 0)
         {
            this.FData.UserBaseInfo.Group = this.FCurGroup;
         }
         this.FPrizeListWin.Data = this.FData.UserBaseInfo;
         this.FPrizeListWin.Visible = true;
      }
      
      protected function UpdateUI() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         _loc2_ = 8;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMainScene["MC_Table"]["SP_Player_" + _loc1_]["TF_Name"].text = this.FData.PlayerNames[_loc1_];
            _loc1_++;
         }
         _loc3_ = TUtilityLobby.GetConfigValue(61900006);
         _loc2_ = 3;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMainScene["Tab_" + _loc1_]["TF_0"].text = _loc3_[_loc1_][0];
            this.FMainScene["Tab_" + _loc1_]["TF_1"].text = _loc3_[_loc1_][1];
            _loc1_++;
         }
         this.FMainScene["Tab_3"]["TF_0"].text = _loc3_[2][1] + "+";
         this.FMainScene["MC_JackPiont"]["ReciveFlag"].visible = this.FData.UserBaseInfo.AwardStatus == 1 ? true : false;
         this.FMainScene["MC_JackPiont"]["BoxEffect"].play();
         this.UpdateCurrentPage();
      }
      
      public function UpdateLine() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TRoleModel = null;
         var _loc5_:uint = 0;
         _loc1_ = 7;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this.FBtn_Fights[_loc2_].Enabled = false;
            _loc2_++;
         }
         _loc1_ = 6;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this.FMainScene["MC_Table"]["bar_" + _loc2_ + "_base"].visible = false;
            this.FMainScene["MC_Table"]["bar_" + _loc2_ + "_" + 0].visible = false;
            this.FMainScene["MC_Table"]["bar_" + _loc2_ + "_" + 1].visible = false;
            this.FMainScene["MC_Table"]["bar_" + _loc2_ + "_" + 0 + "_fix"].visible = false;
            this.FMainScene["MC_Table"]["bar_" + _loc2_ + "_" + 1 + "_fix"].visible = false;
            _loc2_++;
         }
         this.FHeadBitmap.bitmapData = null;
         this.FMainScene["KilledFlag"].visible = false;
         this.FMainScene["Name"].text = "Chờ quán quân";
         _loc1_ = this.FData.FightsInfo.length;
         _loc2_ = 0;
         for(; _loc2_ < _loc1_; _loc2_++)
         {
            if(this.FData.FightsInfo[_loc2_].FightNum - this.FCurGroup >= 0 && this.FData.FightsInfo[_loc2_].FightNum - this.FCurGroup < 7)
            {
               this.FBtn_Fights[this.FData.FightsInfo[_loc2_].FightNum - this.FCurGroup].Enabled = true;
               if(this.FData.FightsInfo[_loc2_].Ret != -1)
               {
                  if(this.FData.FightsInfo[_loc2_].FightNum - this.FCurGroup == 6)
                  {
                     if((this.FData.FightsInfo[_loc2_].Ret == 1 && this.FData.FightsInfo[_loc2_].AttUserInfo != null) || (this.FData.FightsInfo[_loc2_].Ret == 0 && this.FData.FightsInfo[_loc2_].DefUserInfo != null))
                     {
                        this.FMainScene["Name"].text = this.FData.FightsInfo[_loc2_].Ret == 1 ? this.FData.FightsInfo[_loc2_].AttUserInfo.UserName : this.FData.FightsInfo[_loc2_].DefUserInfo.UserName;
                        _loc5_ = this.FData.FightsInfo[_loc2_].Ret == 1 ? this.FData.FightsInfo[_loc2_].AttUserInfo.ModelId : this.FData.FightsInfo[_loc2_].DefUserInfo.ModelId;
                        _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,_loc5_) as TRoleModel;
                        if(_loc4_ == null)
                        {
                           continue;
                        }
                        _loc3_ = _loc4_.RoleHead;
                        SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc3_,this.AutoLoadCallBack);
                        this.FMainScene["MC_HeadPoint"].addChild(this.FHeadBitmap);
                        this.FMainScene["KilledFlag"].visible = false;
                        if(this.FData.FightsInfo[_loc2_].Ret == 1)
                        {
                           this.FMainScene["MC_Table"]["bar_4_base"].visible = true;
                           this.FMainScene["MC_Table"]["bar_5_base"].visible = false;
                        }
                        else
                        {
                           this.FMainScene["MC_Table"]["bar_4_base"].visible = false;
                           this.FMainScene["MC_Table"]["bar_5_base"].visible = true;
                        }
                     }
                     continue;
                  }
                  this.FMainScene["MC_Table"]["bar_" + (this.FData.FightsInfo[_loc2_].FightNum - this.FCurGroup) + "_base"].visible = true;
                  if(this.FData.FightsInfo[_loc2_].Ret == 1)
                  {
                     this.FMainScene["MC_Table"]["bar_" + (this.FData.FightsInfo[_loc2_].FightNum - this.FCurGroup) + "_" + 0].visible = true;
                     this.FMainScene["MC_Table"]["bar_" + (this.FData.FightsInfo[_loc2_].FightNum - this.FCurGroup) + "_" + 0 + "_fix"].visible = true;
                  }
                  else
                  {
                     this.FMainScene["MC_Table"]["bar_" + (this.FData.FightsInfo[_loc2_].FightNum - this.FCurGroup) + "_" + 1].visible = true;
                     this.FMainScene["MC_Table"]["bar_" + (this.FData.FightsInfo[_loc2_].FightNum - this.FCurGroup) + "_" + 1 + "_fix"].visible = true;
                  }
               }
               this.FMainScene["MC_Table"]["bar_4_base"].visible = false;
               this.FMainScene["MC_Table"]["bar_5_base"].visible = false;
            }
         }
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(Visible && this.FData != null)
         {
            if(STimingCore.ServerTick >= this.FNextRefresh && !TKingChallenge.RequestPending)
            {
               this.FNextRefresh = STimingCore.ServerTick + 10;
               this.FUnstreamizer.InitReq(this.FCurGroup / 1000);
               this.FUnstreamizer.FightReq(this.FCurGroup / 1000);
               this.FUnstreamizer.RankReq(this.FCurGroup / 1000);
            }
            this.FDetailWin.LogicsPerform();
            this.FPrizeListWin.LogicsPerform();
            if(STimingCore.ServerTick < this.FData.FighterStartTime)
            {
               this.FMainScene["TF_NextFight"].text = TUtilityTiming.fomatTimeTwo(this.FData.FighterStartTime - STimingCore.ServerTick).toString();
            }
         }
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         var _loc5_:BitmapData = null;
         _loc4_ = param2.GetAnimationSequenceByIndex(0);
         _loc5_ = _loc4_.GetAnimationFrameByIndex(0).Surface;
         this.FHeadBitmap.bitmapData = _loc5_;
      }
      
      protected function PageOnSwitch(param1:Object, param2:int) : void
      {
         this.FCurrentPage = param2;
         this.UpdateCurrentPage();
      }
      
      protected function UpdateCurrentPage() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         this.FCurrentPage = Math.max(0,Math.min(this.FCurrentPage,Math.ceil(this.FData.RankData.length / 5) - 1));
         this.FPageUI.PageSize = 5;
         this.FPageUI.TotalQuantity = this.FData.RankData.length;
         this.FPageUI.Update();
         _loc2_ = 5;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(5 * this.FCurrentPage + _loc1_ < this.FPageUI.TotalQuantity)
            {
               this.FMainScene["rankList"]["View"]["RecordTF_" + _loc1_].visible = true;
               this.FMainScene["rankList"]["View"]["RecordTF_" + _loc1_]["r1"].text = this.FData.RankData[5 * this.FCurrentPage + _loc1_].Rank + "";
               this.FMainScene["rankList"]["View"]["RecordTF_" + _loc1_]["r2"].text = this.FData.RankData[5 * this.FCurrentPage + _loc1_].UserName;
               this.FMainScene["rankList"]["View"]["RecordTF_" + _loc1_]["r3"].text = this.FData.RankData[5 * this.FCurrentPage + _loc1_].ServerId + "";
               this.FMainScene["rankList"]["View"]["RecordTF_" + _loc1_]["r4"].text = this.FData.RankData[5 * this.FCurrentPage + _loc1_].Power + "";
            }
            else
            {
               this.FMainScene["rankList"]["View"]["RecordTF_" + _loc1_].visible = false;
            }
            _loc1_++;
         }
      }
      
      protected function ProcessorOnMove(param1:Object, param2:Event) : void
      {
         this.FHint.Caption = "??ng k? ??i h?nh tr??c 21:05 th? Hai, T?, S?u (UTC+7). M?i nh?m t?i ?a 8 ng??i. Khi gi?i b?t ??u, tr?ng ??i th? ???c th?ng mi?n ??u v? ti?p t?c l?n v?ng sau, k? c? v? ??ch. C? ?? hai ng??i s? ??u b?ng ??i h?nh ?? ??ng k?. Ch?t c??c tr??c gi? ??u; nh?n th??ng theo th? h?ng sau khi c? k?t qu?.";
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function ProcessorOnOut(param1:Object, param2:Event) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      protected function ReturnToTown(param1:Object, param2:Event) : void
      {
         if(this.FOnReturn != null)
         {
            this.FOnReturn();
         }
      }
      
      public function set OnReturn(param1:Function) : void
      {
         this.FOnReturn = param1;
      }
      
      public function set Data(param1:TKingChallenge) : void
      {
         this.FData = param1;
         if(this.FMainScene == null)
         {
            return;
         }
         this.FUnstreamizer = new TUnsteamizerKingChallenge(this.FData);
         this.UpdateUI();
         this.UpdateLine();
         this.FBtn_UpLoad.Enabled = this.FData.SeasonStatus == 0 && !TKingChallenge.RequestPending;
         if(this.FDetailWin.Visible && this.FData.FindFightInfoById(this.FCurFight) != null)
         {
            this.FDetailWin.Data = this.FData.FindFightInfoById(this.FCurFight);
         }
         this.FGamlbeWin.Data = this.FData.BettingsInfo;
         this.FPrizeListWin.Data = this.FData.UserBaseInfo;
         this.FMC_ButtonBar.gotoAndStop(this.FMC_ButtonBar.totalFrames);
         this.FBtn_UpLoad.Caption = this.FData.UserBaseInfo.Permission ? "C?p nh?t" : "??ng k?";
         this.FRegistrationInfo.text = (this.FData.UserBaseInfo.Permission ? "?? ??ng k?" : "Ch?a ??ng k?") + " | Nh?m ?ang xem: " + this.FData.PlayersInfo.length + "/8 | Tr?ng ??i th?: th?ng mi?n ??u";
      }
      
      public function get CurGroup() : uint
      {
         return this.FCurGroup;
      }
      
      public function set CurGroup(param1:uint) : void
      {
         this.FCurGroup = param1;
      }
   }
}

