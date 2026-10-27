package Processors.Game.Lobby.Activity.HDDreamComeTrue.windows
{
   import Components.ScrollBar.TScrollBar;
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.Common.THint;
   import Foundation.Queries.Textures.TQueryAnimationSequence;
   import Foundation.Resources.Repositories.TResourceRepositoryTexture;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.TRoleModel;
   import Logics.HDDreamsComeTrue.TActivityDreamsData;
   import Logics.HDDreamsComeTrue.vo.TAwardExchangeVo;
   import Logics.HDDreamsComeTrue.vo.TFinishConditionVo;
   import Logics.HDDreamsComeTrue.vo.TFontIMGVo;
   import Logics.KnifeOfKillSoul.TKnifeOfKillSoulData;
   import Processors.Game.Lobby.Activity.HDChineseYear.Component.TKnifePop;
   import Processors.Game.Lobby.Common.Hero.TProcessorWindowHeroDescription;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_DREAMS;
   import Resources.Constants.CONST_LOBBY;
   import Resources.Constants.CONST_ROLE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.setTimeout;
   import ghostcat.util.easing.TweenUtil;
   
   public class TProcessorExchangeView extends TUIComponent
   {
      
      public static const Award_Type_Count:int = 5;
      
      private const FRecordListSkinPosY:Number = 188;
      
      private const FResource_Count:int = 11;
      
      private const Tween_Time_0:int = 0;
      
      private const DelayOperateTime:int = 10;
      
      private const Tween_Time_2:int = 100;
      
      private const Gap:int = 5;
      
      private var FMC_Scene:Sprite;
      
      private var FAwardMCVec:Vector.<MovieClip>;
      
      private var FAwardDescVec:Vector.<TextField>;
      
      private var FBgMcVec:Vector.<MovieClip>;
      
      private var FMC_ExchangView:Sprite;
      
      private var FAwardListSkin:MovieClip;
      
      private var FUIScrollBarAward:TScrollBar;
      
      private var FResourceVec:Vector.<MovieClip>;
      
      private var FTFNeedVec:Vector.<TextField>;
      
      private var FMaxBtn:TUIButton;
      
      private var FGiftBox:Sprite;
      
      private var FGiftBoxBtn:TUIButton;
      
      private var FUIPageLeft:TUIButton;
      
      private var FUIPageRight:TUIButton;
      
      private var FTFPage:TextField;
      
      private var FExchangeBtn:TUIButton;
      
      private var FHasSp:Sprite;
      
      private var FWindowShowHero:TProcessorWindowHeroDescription;
      
      private var FRoleModelIDs:Vector.<uint>;
      
      private var FKnifePop:TKnifePop;
      
      private var FMC_KnifeInfo:Sprite;
      
      private var FKnifeOfKillSoulData:TKnifeOfKillSoulData;
      
      protected var FUIExchange:TUIAwardShow;
      
      protected var FGetCurExchangeVec:Vector.<TAwardExchangeVo>;
      
      protected var FRecordSelectIndex:int;
      
      protected var FRecordSelectType:int;
      
      protected var FRecordCurExchangeAmount:int;
      
      private var FRenderItemVec:Vector.<Sprite>;
      
      private var FRenderBgVec:Vector.<MovieClip>;
      
      protected var FHint:THint;
      
      protected var FRecordMcPositionY:Vector.<Number>;
      
      protected var FListHight:Number;
      
      protected var FListMCVec:Vector.<Sprite>;
      
      protected var FBtn_FightReport:TUIButton;
      
      protected var FGetCurFightReportUrl:String;
      
      protected var FOnCreateKnifeOfKillSoulData:Function;
      
      protected var FActivityDreamsData:TActivityDreamsData;
      
      protected var FOnMoveGiftTips:Function;
      
      protected var FOnOutGiftTips:Function;
      
      protected var FSendData:Function;
      
      public function TProcessorExchangeView(param1:TUIComponent, param2:Sprite)
      {
         super(param1);
         this.FMC_Scene = param2;
         this.InitWindow();
      }
      
      protected function InitWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         this.FAwardMCVec = new Vector.<MovieClip>();
         this.FAwardDescVec = new Vector.<TextField>();
         this.FBgMcVec = new Vector.<MovieClip>();
         this.FRecordSelectType = -1;
         this.FRecordSelectIndex = -1;
         this.FRecordMcPositionY = new Vector.<Number>();
         this.FListMCVec = new Vector.<Sprite>();
         _loc2_ = Award_Type_Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_Scene["MC_Award_" + _loc1_];
            this.FListMCVec[_loc1_] = _loc3_;
            _loc4_ = _loc3_["MC_TaskLable"]["Btn_TaskHide"];
            this.FAwardMCVec[_loc1_] = _loc4_;
            _loc4_.gotoAndStop(2);
            _loc4_.addEventListener(MouseEvent.CLICK,this.OnSelectHandler);
            this.FAwardDescVec[_loc1_] = _loc3_["MC_TaskLable"]["TF_TaskType"];
            _loc5_ = _loc3_["MC_TaskLable"]["Mc_Bg"];
            this.FBgMcVec[_loc1_] = _loc5_;
            _loc5_.gotoAndStop(1);
            _loc3_.addEventListener(MouseEvent.MOUSE_OVER,this.OnOverShowBg);
            _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this.OnOutHideBg);
            this.FRecordMcPositionY[_loc1_] = _loc3_.y;
            this.FListHight = _loc3_.height;
            _loc1_++;
         }
         this.FMC_ExchangView = this.FMC_Scene["MC_ExchangView"];
         this.FMC_ExchangView.visible = false;
         this.ShowNeedResourceArea();
         this.FAwardListSkin = this.FMC_Scene["MC_AwardList"];
         this.FUIScrollBarAward = new TScrollBar(this.FAwardListSkin,122,false,2,24);
         this.FUIScrollBarAward.Visible = false;
         this.FHint = new THint();
         this.FBtn_FightReport = new TUIButton();
         this.FBtn_FightReport.Substrate = this.FMC_Scene["MC_ExchangView"]["Btn_FightReport"];
         this.FBtn_FightReport.OnClick = this.BtnShowBattleInfoClick;
         this.FBtn_FightReport.Visible = false;
      }
      
      protected function SendServiceData(param1:int, param2:int = 0, param3:Vector.<int> = null) : void
      {
         if(this.FSendData != null)
         {
            this.FSendData(param1,param2,param3);
         }
      }
      
      protected function ShowExchangeTypeList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = Award_Type_Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FAwardDescVec[_loc1_].text = this.FActivityDreamsData.ActivityConfig.AwardTypeDescVec[_loc1_];
            _loc1_++;
         }
      }
      
      private function SelectExchangeType(param1:int) : void
      {
         var Index:int = 0;
         var Count:int = 0;
         var MC:MovieClip = null;
         var Type:int = param1;
         Count = Award_Type_Count;
         Index = 0;
         while(Index < Count)
         {
            if(Type != Index)
            {
               MC = this.FAwardMCVec[Index];
               MC.gotoAndStop(2);
            }
            Index++;
         }
         MC = this.FAwardMCVec[Type];
         this.SetMCPosition(0,false,this.Tween_Time_0);
         setTimeout(function DelayOperate():void
         {
            if(MC != null)
            {
               if(MC.currentFrame == 1)
               {
                  MC.gotoAndStop(2);
                  FUIScrollBarAward.Visible = false;
               }
               else
               {
                  MC.gotoAndStop(1);
                  TweenUtil.to(FAwardListSkin,Tween_Time_2,{"y":FRecordMcPositionY[Type] + FListHight + Gap});
                  UpdateAwardRankBar(Type);
                  SetMCPosition(Type,true,Tween_Time_2);
               }
            }
         },this.DelayOperateTime);
      }
      
      private function SetMCPosition(param1:int, param2:Boolean, param3:Number) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc5_ = int(this.FListMCVec.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(_loc4_ > param1)
            {
               if(param2)
               {
                  TweenUtil.to(this.FListMCVec[_loc4_],param3,{"y":this.FRecordMcPositionY[_loc4_] + this.FUIScrollBarAward.getCurHight()});
               }
               else
               {
                  TweenUtil.to(this.FListMCVec[_loc4_],param3,{"y":this.FRecordMcPositionY[_loc4_]});
               }
            }
            _loc4_++;
         }
      }
      
      protected function UpdateAwardRankBar(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Sprite = null;
         var _loc5_:MovieClip = null;
         var _loc6_:TextField = null;
         var _loc7_:TAwardExchangeVo = null;
         this.FRenderItemVec = new Vector.<Sprite>();
         this.FRenderBgVec = new Vector.<MovieClip>();
         this.FGetCurExchangeVec = this.FActivityDreamsData.GetCurTypeExchangeList(param1);
         this.FUIScrollBarAward.Clear();
         _loc3_ = int(this.FGetCurExchangeVec.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = TUtilityReflection.CreateDisplayObjectInstance("ItemRender") as Sprite;
            _loc4_["TF_AwardName"].text = this.FGetCurExchangeVec[_loc2_].AwardName;
            _loc4_.name = "ItemRender_" + _loc2_;
            this.FRenderItemVec[_loc2_] = _loc4_;
            _loc5_ = _loc4_["MC_Bg"];
            this.FRenderBgVec[_loc2_] = _loc5_;
            _loc4_.addEventListener(MouseEvent.CLICK,this.OnShowFinishCondition);
            _loc4_.addEventListener(MouseEvent.MOUSE_OVER,this.OnShowFinishShowBg);
            _loc4_.addEventListener(MouseEvent.MOUSE_OUT,this.OnShowFinishHideBg);
            this.FUIScrollBarAward.AddItem(_loc4_);
            _loc2_++;
         }
         this.FRenderItemVec[0].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         this.FUIScrollBarAward.ScrollToUp();
         this.FUIScrollBarAward.Visible = true;
      }
      
      protected function ShowNeedResourceArea() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         this.FResourceVec = new Vector.<MovieClip>();
         this.FTFNeedVec = new Vector.<TextField>();
         _loc2_ = this.FResource_Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_ExchangView["MC_Gift_" + _loc1_];
            this.FResourceVec[_loc1_] = _loc3_;
            _loc3_.addEventListener(MouseEvent.MOUSE_MOVE,this.OnResourceTipsMove);
            _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this.OnResourceTipsOut);
            this.FTFNeedVec[_loc1_] = _loc3_["TF_Value"];
            _loc1_++;
         }
         this.FUIPageLeft = new TUIButton();
         this.FUIPageLeft.Substrate = this.FMC_ExchangView["MC_Page"]["MC_PageLeft"];
         this.FUIPageLeft.OnClick = this.OnSlowValueClick;
         this.FUIPageRight = new TUIButton();
         this.FUIPageRight.Substrate = this.FMC_ExchangView["MC_Page"]["MC_PageRight"];
         this.FUIPageRight.OnClick = this.OnAddValueClick;
         this.FTFPage = this.FMC_ExchangView["MC_Page"]["TF_Page"];
         this.FRecordCurExchangeAmount = 1;
         this.FMaxBtn = new TUIButton();
         this.FMaxBtn.Substrate = this.FMC_ExchangView["Btn_Max"];
         this.FMaxBtn.OnClick = this.OnSelectMaxHandler;
         this.FGiftBoxBtn = new TUIButton();
         this.FGiftBoxBtn.Substrate = this.FMC_ExchangView["MC_AwardContainer"]["MC_Gift"];
         this.FGiftBoxBtn.OnMove = this.OnGiftMove;
         this.FGiftBoxBtn.OnOut = this.OnGiftOut;
         this.FExchangeBtn = new TUIButton();
         this.FExchangeBtn.Substrate = this.FMC_ExchangView["Btn_Exchange"];
         this.FExchangeBtn.OnClick = this.ExchangeGiftHandler;
         this.FHasSp = this.FMC_ExchangView["MC_AwardContainer"]["MC_Receive"];
         this.FUIExchange = new TUIAwardShow(this);
         this.FUIExchange.OnShowHeroClick = this.ProcessorShowHeroOnClick;
         this.FUIExchange.SequenceDefaultRole = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCEID_Textures_DefaultRole,0);
         this.FUIExchange.OnQuerySequenceContext = this.HeroOnQuerySequenceContext;
         this.FUIExchange.Perform_UIDispatch(this.FMC_ExchangView["MC_AwardContainer"]);
         this.FWindowShowHero = new TProcessorWindowHeroDescription(FParent);
         this.FWindowShowHero.Perform_UIDispatch();
         this.FWindowShowHero.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FWindowShowHero.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FWindowShowHero.OnClose = this.CloseWindowOnMouseClick;
         this.FWindowShowHero.x = -(this.parent.x >> 1);
         this.FRoleModelIDs = new Vector.<uint>();
         this.FKnifePop = new TKnifePop(this);
         this.FKnifePop.OnPopColse = this.KnifePopOnClose;
         this.FKnifePop.UIDispatch();
         this.FKnifePop.X = (this.Width - 200) / 2;
         this.FKnifePop.Y = (this.Height - 300) / 2;
         this.FKnifePop.Visible = false;
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
      
      protected function UpdateConditionInfo(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Vector.<TFinishConditionVo> = null;
         var _loc5_:TFontIMGVo = null;
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:MovieClip = null;
         _loc4_ = this.FGetCurExchangeVec[param1].FinishConditionVec;
         _loc6_ = int(_loc4_.length);
         _loc7_ = this.FActivityDreamsData.ActivityConfig.ResourcePosArr[_loc6_ - 1];
         _loc3_ = _loc6_;
         this.HideResource();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc8_ = this.FResourceVec[_loc7_[_loc2_]];
            _loc8_.visible = true;
            _loc8_.gotoAndStop(_loc4_[_loc2_].FontShowCurFrame);
            _loc5_ = this.FActivityDreamsData.GetCurFontVo(_loc4_[_loc2_].FontIndex);
            if(_loc5_.FontCount >= _loc4_[_loc2_].Condition)
            {
               this.FTFNeedVec[_loc7_[_loc2_]].htmlText = TUtilityString.Format("<font color=\'#00ff00\'>%0/%1</font>",_loc5_.FontCount,_loc4_[_loc2_].Condition);
            }
            else
            {
               this.FTFNeedVec[_loc7_[_loc2_]].htmlText = TUtilityString.Format("<font color=\'#FF0000\'>%0/%1</font>",_loc5_.FontCount,_loc4_[_loc2_].Condition);
            }
            _loc2_++;
         }
         this.RefreshAwardHeroOrGift();
      }
      
      protected function RefreshAwardHeroOrGift() : void
      {
         var _loc1_:TAwardExchangeVo = null;
         _loc1_ = this.FGetCurExchangeVec[this.FRecordSelectIndex];
         this.FUIExchange.UpdateUI(_loc1_);
      }
      
      private function HideResource() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         _loc2_ = int(this.FResourceVec.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FResourceVec[_loc1_];
            _loc3_.visible = false;
            _loc1_++;
         }
      }
      
      private function UpdateUI() : void
      {
         this.ShowExchangeTypeList();
         if(this.FRecordSelectType == -1)
         {
            return;
         }
      }
      
      private function OnSelectHandler(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = int(param1.currentTarget.parent.parent.name.split("_")[2]);
         this.FRecordSelectType = _loc2_;
         this.SelectExchangeType(_loc2_);
      }
      
      private function OnOverShowBg(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = int(param1.currentTarget.name.split("_")[2]);
         this.FBgMcVec[_loc2_].gotoAndStop(2);
      }
      
      private function OnOutHideBg(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = int(param1.currentTarget.name.split("_")[2]);
         this.FBgMcVec[_loc2_].gotoAndStop(1);
      }
      
      private function OnShowFinishCondition(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.SetRenderBg();
         _loc2_ = int(param1.currentTarget.name.split("_")[1]);
         this.FRecordSelectIndex = _loc2_;
         this.FMC_ExchangView.visible = true;
         this.FRecordCurExchangeAmount = 1;
         this.FTFPage.text = this.FRecordCurExchangeAmount.toString();
         this.FRenderBgVec[_loc2_].gotoAndStop(2);
         this.RefreshConditionView(_loc2_);
      }
      
      private function OnShowFinishShowBg(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = int(param1.currentTarget.name.split("_")[1]);
         if(this.FRecordSelectIndex == _loc2_)
         {
            return;
         }
         this.FRenderBgVec[_loc2_].gotoAndStop(3);
      }
      
      private function OnShowFinishHideBg(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = int(param1.currentTarget.name.split("_")[1]);
         if(this.FRecordSelectIndex == _loc2_)
         {
            return;
         }
         this.FRenderBgVec[_loc2_].gotoAndStop(1);
      }
      
      private function SetRenderBg() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FRenderBgVec.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FRenderBgVec[_loc1_].gotoAndStop(1);
            _loc1_++;
         }
      }
      
      private function RefreshConditionView(param1:int) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         this.UpdateConditionInfo(param1);
         if(this.FGetCurExchangeVec[param1].Status == CONST_DREAMS.Activity_AlreadyReceive || this.FGetCurExchangeVec[param1].MaxValue <= 0)
         {
            _loc2_ = false;
         }
         else
         {
            _loc2_ = true;
         }
         this.FExchangeBtn.Enabled = _loc2_;
         if(this.FRecordSelectType == CONST_DREAMS.Type_0)
         {
            this.FBtn_FightReport.Visible = true;
            this.FGetCurFightReportUrl = this.FActivityDreamsData.ActivityConfig.FightReportUrlVec[this.FRecordSelectIndex];
         }
         else
         {
            this.FBtn_FightReport.Visible = false;
         }
         if(this.FGetCurFightReportUrl == "")
         {
            this.FBtn_FightReport.Visible = false;
         }
      }
      
      private function OnSlowValueClick(param1:Object, param2:MouseEvent) : void
      {
         --this.FRecordCurExchangeAmount;
         this.FRecordCurExchangeAmount = this.FRecordCurExchangeAmount <= 0 ? 1 : this.FRecordCurExchangeAmount;
         this.FTFPage.text = this.FRecordCurExchangeAmount.toString();
      }
      
      private function OnAddValueClick(param1:Object, param2:MouseEvent) : void
      {
         ++this.FRecordCurExchangeAmount;
         this.FRecordCurExchangeAmount = this.FRecordCurExchangeAmount >= this.FGetCurExchangeVec[this.FRecordSelectIndex].MaxValue ? this.FGetCurExchangeVec[this.FRecordSelectIndex].MaxValue : this.FRecordCurExchangeAmount;
         if(this.FRecordCurExchangeAmount <= 0)
         {
            this.FRecordCurExchangeAmount = 1;
         }
         this.FTFPage.text = this.FRecordCurExchangeAmount.toString();
      }
      
      protected function OnSelectMaxHandler(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         if(this.FGetCurExchangeVec[this.FRecordSelectIndex].MaxValue <= 0)
         {
            _loc3_ = 1;
         }
         else
         {
            _loc3_ = this.FGetCurExchangeVec[this.FRecordSelectIndex].MaxValue;
         }
         this.FTFPage.text = _loc3_.toString();
         this.FRecordCurExchangeAmount = _loc3_;
      }
      
      protected function ProcessorShowHeroOnClick(param1:Object, param2:TAwardExchangeVo) : void
      {
         this.FMC_Scene.mouseChildren = false;
         this.FMC_Scene.mouseEnabled = false;
         if(param2.AwardType == CONST_DREAMS.Type_0)
         {
            this.FWindowShowHero.HeroID = param2.HeroId;
            this.FWindowShowHero.Show();
         }
         else if(param2.AwardType == CONST_DREAMS.Type_1)
         {
            this.FKnifeOfKillSoulData = this.FOnCreateKnifeOfKillSoulData(param2.HeroId);
            this.FKnifePop.KnifeData = this.FKnifeOfKillSoulData;
            this.FKnifePop.Visible = true;
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
      
      protected function ExchangeGiftHandler(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:Vector.<int> = null;
         _loc3_ = new Vector.<int>();
         _loc3_.push(this.FGetCurExchangeVec[this.FRecordSelectIndex].Index);
         _loc3_.push(this.FRecordCurExchangeAmount);
         this.SendServiceData(this.FActivityDreamsData.ActivityConfig.ExchangeIndex,0,_loc3_);
      }
      
      protected function CloseWindowOnMouseClick(param1:Object) : void
      {
         this.FMC_Scene.mouseChildren = true;
         this.FMC_Scene.mouseEnabled = true;
         this.FWindowShowHero.Hide();
      }
      
      protected function KnifePopOnClose(param1:Object) : void
      {
         this.FMC_Scene.mouseChildren = true;
         this.FMC_Scene.mouseEnabled = true;
         this.FKnifePop.Visible = false;
      }
      
      protected function OnGiftMove(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnMoveGiftTips != null)
         {
            this.FOnMoveGiftTips(this.FGetCurExchangeVec[this.FRecordSelectIndex].Inventories);
         }
      }
      
      protected function OnGiftOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnOutGiftTips != null)
         {
            this.FOnOutGiftTips(this);
         }
      }
      
      protected function OnResourceTipsMove(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TFontIMGVo = null;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         _loc2_ = int(param1.currentTarget.name.split("_")[2]);
         _loc5_ = int(this.FGetCurExchangeVec[this.FRecordSelectIndex].FinishConditionVec.length);
         _loc6_ = this.FActivityDreamsData.ActivityConfig.ResourcePosArr[_loc5_ - 1];
         _loc8_ = int(_loc6_.length);
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            if(_loc6_[_loc7_] == _loc2_)
            {
               break;
            }
            _loc7_++;
         }
         _loc3_ = this.FGetCurExchangeVec[this.FRecordSelectIndex].FinishConditionVec[_loc7_].FontIndex;
         _loc4_ = this.FActivityDreamsData.GetCurFontVo(_loc3_);
         this.FHint.Caption = _loc4_.TipsName;
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function OnResourceTipsOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      protected function BtnShowBattleInfoClick(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToLinkUrl(this.FGetCurFightReportUrl);
      }
      
      public function set OnCreateKnifeOfKillSoulData(param1:Function) : void
      {
         this.FOnCreateKnifeOfKillSoulData = param1;
      }
      
      public function set ActivityDreamsData(param1:TActivityDreamsData) : void
      {
         this.FActivityDreamsData = param1;
      }
      
      public function set OnMoveGiftTips(param1:Function) : void
      {
         this.FOnMoveGiftTips = param1;
      }
      
      public function get OnMoveGiftTips() : Function
      {
         return this.FOnMoveGiftTips;
      }
      
      public function set OnOutGiftTips(param1:Function) : void
      {
         this.FOnOutGiftTips = param1;
      }
      
      public function set SendData(param1:Function) : void
      {
         this.FSendData = param1;
      }
      
      public function ShowView() : void
      {
         this.UpdateUI();
      }
      
      public function RefreshView() : void
      {
         if(this.FRecordSelectIndex == -1)
         {
            return;
         }
         this.RefreshConditionView(this.FRecordSelectIndex);
      }
      
      public function LogicsPerform_EnterFrame() : void
      {
         if(this.visible)
         {
            this.FUIExchange.UpdateUIHero();
         }
      }
   }
}

