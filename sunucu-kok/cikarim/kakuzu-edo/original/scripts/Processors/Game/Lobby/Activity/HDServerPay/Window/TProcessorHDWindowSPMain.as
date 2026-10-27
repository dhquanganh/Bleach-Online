package Processors.Game.Lobby.Activity.HDServerPay.Window
{
   import Components.ScrollBar.*;
   import Components.Standard.*;
   import Externals.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Agent.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HDActivityOS.*;
   import Logics.HDIceHeros.*;
   import Logics.HDServerPay.*;
   import Logics.Inventories.*;
   import Logics.KnifeOfKillSoul.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Activity.HDChineseYear.Component.*;
   import Processors.Game.Lobby.Activity.HDGeneralSell.Compoent.*;
   import Processors.Game.Lobby.Activity.HDServerPay.Component.*;
   import Processors.Game.Lobby.Common.Hero.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorHDWindowSPMain extends TProcessorHDSingleWindowBase
   {
      
      protected static const COUNT_TF_RankAward:uint = 2;
      
      protected static const COUNT_MC_RankAward:uint = 1;
      
      protected static const COUNT_MC_Rank:uint = 3;
      
      protected static const COUNT_MC_Heros:uint = 1;
      
      protected static const KNIFE_WIDTH:uint = 254;
      
      protected static const KNIFE_HEIGHT:uint = 435;
      
      protected var FTF_RankNames:Vector.<TextField>;
      
      protected var FTF_RankScores:Vector.<TextField>;
      
      protected var FBtn_ShowRank:TUIButton;
      
      protected var FUIScrollBar:TScrollBar;
      
      protected var FBtn_ShowShop:TUIButton;
      
      protected var FUI_RankAwards:Vector.<TUIActivityRankAward>;
      
      protected var FUI_Heros:Vector.<TUIIceHeroPlayer>;
      
      protected var FMC_KnifeInfo:Sprite;
      
      protected var FTF_CurScore:TextField;
      
      protected var FMC_Effect:MovieClip;
      
      protected var FIsInitWindow:Boolean;
      
      protected var FIsInitData:Boolean;
      
      protected var FData_ServerPay:TActivityServerPay;
      
      protected var FHD_ServerPay:THDServerPay;
      
      protected var FRoleModelIDs:Vector.<uint>;
      
      protected var FKnifePop:TKnifePop;
      
      protected var FWindowShowHero:TProcessorWindowHeroDescription;
      
      protected var FKnifeOfKillSoulData:TKnifeOfKillSoulData;
      
      protected var FOnCreateKnifeOfKillSoulData:Function;
      
      protected var FOnLinkWindow:Function;
      
      public function TProcessorHDWindowSPMain(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = CONST_ACTIVITY.RESOURCE_ClassName_ActivitySingleServerPayMain;
         this.FIsInitWindow = false;
         FActivityID = CONST_ACTIVITY_MODE.Activity_ServerPay;
         this.FUI_RankAwards = new Vector.<TUIActivityRankAward>();
         this.FRoleModelIDs = new Vector.<uint>();
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
         _loc2_ = int(COUNT_MC_Heros);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FUI_Heros[_loc1_].UpdateUIHero();
            _loc1_++;
         }
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Sprite = null;
         var _loc5_:MovieClip = null;
         var _loc6_:TUIIceHeroPlayer = null;
         super.InitWindow(param1);
         _loc3_ = int(COUNT_MC_Rank);
         this.FTF_RankNames = new Vector.<TextField>(_loc3_);
         this.FTF_RankScores = new Vector.<TextField>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_Ranks + _loc2_];
            _loc4_.mouseChildren = false;
            _loc4_.mouseEnabled = false;
            this.FTF_RankNames[_loc2_] = _loc4_[CONST_ACTIVITY.RESOURCE_Link_TF_Name];
            this.FTF_RankNames[_loc2_].mouseEnabled = false;
            this.FTF_RankScores[_loc2_] = _loc4_[CONST_ACTIVITY.RESOURCE_Link_TF_Score];
            this.FTF_RankScores[_loc2_].mouseEnabled = false;
            _loc2_++;
         }
         this.FBtn_ShowRank = new TUIButton();
         this.FBtn_ShowRank.Substrate = FScene[CONST_ACTIVITY.RESOURCE_Link_Btn_ShowRank];
         this.FBtn_ShowRank.OnClick = this.BtnShowRankOnClick;
         this.FBtn_ShowShop = new TUIButton();
         this.FBtn_ShowShop.Substrate = FScene[CONST_ACTIVITY.RESOURCE_Link_Btn_ShowShop];
         this.FBtn_ShowShop.OnClick = this.BtnShowShopOnClick;
         _loc5_ = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_List];
         this.FUIScrollBar = new TScrollBar(_loc5_,205,false,-5,73);
         this.FUIScrollBar.Visible = false;
         _loc3_ = int(COUNT_MC_Heros);
         this.FUI_Heros = new Vector.<TUIIceHeroPlayer>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = new TUIIceHeroPlayer(this);
            _loc6_.OnBtnOKClick = this.BtnExchangeHeroOnClick;
            _loc6_.OnShowHeroClick = this.ProcessorShowHeroOnClick;
            _loc6_.SequenceDefaultRole = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCEID_Textures_DefaultRole,0);
            _loc6_.OnQuerySequenceContext = this.HeroOnQuerySequenceContext;
            _loc6_.Perform_UIDispatch(FScene[CONST_ACTIVITY.RESOURCE_Link_MC_Heros + _loc2_]);
            this.FUI_Heros[_loc2_] = _loc6_;
            _loc2_++;
         }
         this.FWindowShowHero = new TProcessorWindowHeroDescription(FParent);
         this.FWindowShowHero.Perform_UIDispatch();
         this.FWindowShowHero.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FWindowShowHero.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FWindowShowHero.OnClose = this.BtnCloseLukiaWindowOnMouseClick;
         this.FWindowShowHero.Hide();
         this.FKnifePop = new TKnifePop(this);
         this.FKnifePop.OnPopColse = this.KnifePopOnClose;
         this.FKnifePop.UIDispatch();
         this.FKnifePop.X = (this.Width - KNIFE_WIDTH) / 2;
         this.FKnifePop.Y = (this.Height - KNIFE_HEIGHT) / 2;
         this.FKnifePop.Visible = false;
         this.FTF_CurScore = FScene["TF_CurScore"];
         this.FMC_Effect = FScene["MC_Effect"];
         this.FIsInitWindow = true;
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIActivityRankAward = null;
         var _loc4_:Vector.<uint> = null;
         var _loc5_:Sprite = null;
         var _loc6_:Vector.<String> = null;
         var _loc7_:Vector.<TInventories> = null;
         super.UpdateUIConfig();
         this.FHD_ServerPay = FHDActivityConfig as THDServerPay;
         _loc2_ = int(this.FHD_ServerPay.RankAwards.length);
         _loc4_ = new Vector.<uint>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_[_loc1_] = this.FHD_ServerPay.RankAwards[_loc1_].Value;
            _loc1_++;
         }
         FInventoriesVect = ProcessorGetInventoriesVectByAwardID(_loc4_);
         ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
         ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         _loc2_ = int(this.FUI_RankAwards.length);
         this.FUIScrollBar.Clear();
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FUI_RankAwards[_loc1_] = null;
            _loc1_++;
         }
         this.FUI_RankAwards.length = 0;
         _loc2_ = int(this.FHD_ServerPay.RankAwards.length);
         _loc6_ = new Vector.<String>(COUNT_TF_RankAward);
         _loc7_ = new Vector.<TInventories>(COUNT_MC_RankAward);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACTIVITY.RESOURCE_Link_MC_SPAwardElement) as Sprite;
            _loc3_ = new TUIActivityRankAward(this);
            _loc3_.OnGiftOver = this.OnRankAwardOver;
            _loc3_.OnGiftOut = this.OnRankAwardOut;
            _loc3_.Perform_UIDispatch(_loc5_,COUNT_TF_RankAward,COUNT_MC_RankAward,0);
            this.FUI_RankAwards.push(_loc3_);
            _loc6_[0] = this.FHD_ServerPay.RankAwards[_loc1_].Prompt;
            _loc6_[1] = this.FHD_ServerPay.RankAwards[_loc1_].AwardDesc;
            _loc7_[0] = FInventoriesVect[_loc1_];
            _loc3_.UpdateUI(_loc1_,_loc7_,_loc6_);
            this.FUIScrollBar.AddItem(_loc3_);
            _loc1_++;
         }
         this.FUIScrollBar.ScrollToUp();
         this.FUIScrollBar.Visible = true;
         if(this.FHD_ServerPay.IsOpenRank)
         {
            this.FBtn_ShowRank.Visible = true;
         }
         else
         {
            this.FBtn_ShowRank.Visible = false;
         }
         if(this.FMC_Effect != null)
         {
            this.FMC_Effect.play();
         }
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         super.UpdateDataBase(param1);
         this.FData_ServerPay = param1 as TActivityServerPay;
         this.UpdateUI();
         this.FIsInitData = true;
      }
      
      override protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.UpdateUI();
         _loc2_ = int(this.FTF_RankNames.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc1_ < this.FData_ServerPay.Ranks.length)
            {
               this.FTF_RankNames[_loc1_].text = this.FData_ServerPay.Ranks[_loc1_].Name;
               this.FTF_RankScores[_loc1_].text = this.FData_ServerPay.Ranks[_loc1_].Value.toString();
            }
            _loc1_++;
         }
         _loc2_ = int(this.FUI_Heros.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FUI_Heros[_loc1_].UpdateUI(this.FData_ServerPay.HerosData[_loc1_],this.FData_ServerPay.CurScore,TUIIceHeroPlayer.BuyType_Score);
            _loc1_++;
         }
         if(this.FTF_CurScore != null)
         {
            this.FTF_CurScore.text = this.FData_ServerPay.CurScore.toString();
         }
      }
      
      override protected function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.Reset();
         if(!this.FIsInitWindow)
         {
            return;
         }
         _loc2_ = int(this.FUI_Heros.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FUI_Heros[_loc1_].Reset();
            _loc1_++;
         }
         this.ResetTextField();
         this.FUIScrollBar.Clear();
      }
      
      protected function ResetTextField() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FTF_RankNames.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTF_RankNames[_loc1_].text = "";
            this.FTF_RankScores[_loc1_].text = "";
            _loc1_++;
         }
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
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         super.BtnCloseOnClick(param1,param2);
         if(FOnBtnCloseClick != null)
         {
            FOnBtnCloseClick(this);
         }
      }
      
      protected function BtnShowRankOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnLinkWindow != null)
         {
            this.FOnLinkWindow(CONST_ACTIVITY_MODE.WINDOWTYPE_SP_Rank);
         }
      }
      
      protected function BtnShowShopOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnLinkWindow != null)
         {
            this.FOnLinkWindow(CONST_ACTIVITY_MODE.WINDOWTYPE_SP_Shop);
         }
      }
      
      protected function BtnExchangeHeroOnClick(param1:Object, param2:uint) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param2);
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
      
      override protected function BtnGotoLinkOnClcik(param1:Object, param2:MouseEvent) : void
      {
         super.BtnGotoLinkOnClcik(param1,param2);
         SExternalCore.NavigateToRechargeUrl(SParametersCore.PayUrl);
      }
      
      protected function OnRankAwardOver(param1:Object, param2:int, param3:int) : void
      {
         ProcessorOnGiftBoxMove(param1,FInventoriesVect[param3]);
      }
      
      protected function OnRankAwardOut(param1:Object, param2:int, param3:int) : void
      {
         ProcessorOnGiftBoxOut(param1);
      }
      
      public function get OnCreateKnifeOfKillSoulData() : Function
      {
         return this.FOnCreateKnifeOfKillSoulData;
      }
      
      public function set OnCreateKnifeOfKillSoulData(param1:Function) : void
      {
         this.FOnCreateKnifeOfKillSoulData = param1;
      }
      
      public function get OnLinkWindow() : Function
      {
         return this.FOnLinkWindow;
      }
      
      public function set OnLinkWindow(param1:Function) : void
      {
         this.FOnLinkWindow = param1;
      }
   }
}

