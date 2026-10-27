package Processors.Game.Lobby.Activity.HDKingLegend.windows
{
   import Components.Standard.TUIButton;
   import Components.Standard.TUITab;
   import Foundation.Common.TCoordinate;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityCartisian;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Foundation.Utilities.TUtilityTexture;
   import Logics.DatebaseVO.TDatebaseVO;
   import Logics.DatebaseVO.VO.TArticle;
   import Logics.DatebaseVO.VO.TAward;
   import Logics.DatebaseVO.VO.TBaseHero;
   import Logics.DatebaseVO.VO.THDKingGuard;
   import Logics.DatebaseVO.VO.TKnife;
   import Logics.DatebaseVO.VO.TKnifeExpand;
   import Logics.HDActivityMode.TGiftBoxTipData;
   import Logics.HDKingLegend.TActivityKLAward;
   import Logics.HDKingLegend.TActivityKingGuardData;
   import Logics.Inventories.TInventories;
   import Logics.KnifeOfKillSoul.TKnifeOfKillSoulData;
   import Logics.Map.TMoudleInfor;
   import Processors.Game.Lobby.Common.Hero.TProcessorWindowHeroDescription;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudle;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.TacticalDeployment.Components.TKnifeInforTip;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_MAP;
   import Utilities.UI.Overlayers.TUtilityUIOverlayer;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TKingGuardExchangeView extends TProcessorLobbyWindow
   {
      
      protected static const Tab_Count:int = 2;
      
      protected static const Type_Hero:int = 1;
      
      protected static const Type_Knife:int = 2;
      
      protected static const Type_Gift:int = 3;
      
      protected static const Type_SuperGift:int = 4;
      
      protected static const King_Type_2:int = 2;
      
      protected var FMainUI:Sprite;
      
      protected var FTabs:TUITab;
      
      protected var FActivityData:TActivityKingGuardData;
      
      protected var FData:THDKingGuard;
      
      protected var FCurIndex:int;
      
      protected var FTFCardName:TextField;
      
      protected var FTFOwn:TextField;
      
      protected var FTFName:TextField;
      
      protected var FTFNeed:TextField;
      
      protected var FBtnExchange:TUIButton;
      
      protected var FMCIcon:Sprite;
      
      protected var FMCGift:Sprite;
      
      protected var FTFDesc:TextField;
      
      protected var MCNameBack:Sprite;
      
      protected var FContain:Sprite;
      
      protected var FHeroId:int;
      
      protected var FAwardId:int;
      
      protected var FKnifeId:int;
      
      protected var FHeroName:String;
      
      protected var FSpriteMoudle:TSceneSpriteMoudle;
      
      protected var FQureyMoudleInfor:TMoudleInfor;
      
      protected var FDayAwards:Vector.<TActivityKLAward>;
      
      protected var FSendData:Function;
      
      protected var FOwnChip:int;
      
      protected var FNeedChip:int;
      
      protected var FClose:TUIButton;
      
      protected var FBackSp:Sprite;
      
      protected var FIsInit:Boolean;
      
      protected var FType:int;
      
      protected var FGiftBoxTipData:TGiftBoxTipData;
      
      protected var FGiftOverLayer:TOverlayerGiftBox;
      
      protected var FWindowShowHero:TProcessorWindowHeroDescription;
      
      protected var FKnifePop:TKnifeInforTip;
      
      protected var FKnifeOfKillSoulData:TKnifeOfKillSoulData;
      
      protected var FOnCreateKnifeOfKillSoulData:Function;
      
      public function TKingGuardExchangeView(param1:TUIComponent)
      {
         super(param1);
         this.Visible = false;
         this.FGiftBoxTipData = new TGiftBoxTipData();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FGiftOverLayer = new TOverlayerGiftBox(FParent.Parent.Parent);
         this.FGiftOverLayer.visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FGiftOverLayer);
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_KingGuardExchange") as Sprite;
         addChild(this.FMainUI);
         this.FContain = this.FMainUI["MC_Hero"];
         this.FSpriteMoudle = new TSceneSpriteMoudle();
         this.FQureyMoudleInfor = new TMoudleInfor();
         this.FContain["Pos_Mount"].addChild(this.FSpriteMoudle);
         this.FTabs = new TUITab(this);
         _loc1_ = Tab_Count;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this.FTabs.SetTabByIndex(this.FMainUI["Tab_" + _loc2_],_loc2_);
            _loc2_++;
         }
         this.FTabs.OnSwitch = this.TabOnSwitch;
         this.FTabs.Init();
         this.FTFCardName = this.FContain["TF_KingName"];
         this.FTFOwn = this.FContain["TF_Own"];
         this.FTFName = this.FContain["TF_Name"];
         this.FTFNeed = this.FContain["TF_Need"];
         this.FTFDesc = this.FMainUI["TF_Desc"];
         this.FBtnExchange = new TUIButton();
         this.FBtnExchange.Substrate = this.FContain["Btn_Exchange"];
         this.FBtnExchange.OnClick = this.ExchangeOnClick;
         this.FMCGift = this.FContain["MC_Gift"];
         this.FMCIcon = this.FContain["MC_Icon"];
         this.FMCIcon.visible = false;
         this.FMCGift.visible = false;
         this.FTFName.text = "";
         this.MCNameBack = this.FContain["MC_NameBack"];
         this.FClose = new TUIButton();
         this.FClose.Substrate = this.FMainUI["btn_close"];
         this.FClose.OnClick = this.CloseOnClick;
         this.FMainUI.x = (FUICore.StageWidth - this.FMainUI.width >> 1) - FParent.Parent.X;
         this.FMainUI.y = (FUICore.StageHeight - this.FMainUI.height >> 1) - FParent.Parent.Y;
         this.FBackSp = new Sprite();
         this.FBackSp.addChild(new Bitmap(SUtilityResource.BtmDataFullScreen));
         this.FBackSp.x = -FParent.Parent.X;
         this.FBackSp.y = -FParent.Parent.Y;
         this.addChildAt(this.FBackSp,0);
         this.FWindowShowHero = new TProcessorWindowHeroDescription(this);
         this.FWindowShowHero.Perform_UIDispatch();
         this.FWindowShowHero.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FWindowShowHero.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FWindowShowHero.Visible = false;
         this.FKnifePop = new TKnifeInforTip(FParent.Parent.Parent);
         this.FKnifePop.UIDispatch();
         this.FKnifePop.Visible = false;
         this.FMCGift.addEventListener(MouseEvent.MOUSE_OVER,this.GiftOnOver);
         this.FMCGift.addEventListener(MouseEvent.MOUSE_OUT,this.GiftOnOut);
         this.FSpriteMoudle.addEventListener(MouseEvent.CLICK,this.HeroOnClick);
         this.FSpriteMoudle.addEventListener(MouseEvent.MOUSE_OUT,this.KnifeOnOut);
         this.FSpriteMoudle.addEventListener(MouseEvent.MOUSE_OVER,this.KnifeOnOver);
      }
      
      protected function RenderHeroMoudle() : void
      {
         TUtilityTexture.QueryTwoDirectionShowCase(CONST_MAP.DIRECTION_RIGHT,this.FHeroId,this.FQureyMoudleInfor);
         this.FSpriteMoudle.ChangeRoleMoudle(this.FQureyMoudleInfor.TextureID,this.FQureyMoudleInfor.Scalx);
      }
      
      protected function SendServiceData(param1:int) : void
      {
         if(this.FSendData != null)
         {
            this.FSendData(param1);
         }
      }
      
      protected function ExchangeOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc5_ = this.FData.GetGuardType(this.FCurIndex);
         _loc3_ = this.FActivityData.GetExchangeStatus(_loc5_);
         _loc4_ = this.FData.GetAwardsByGuard(this.FCurIndex)[this.FActivityData.CurDay].MaxGetCount;
         if(_loc3_ >= _loc4_)
         {
            SToolReward.ShowMessage(this.FData.GetString(7));
            return;
         }
         if(this.FOwnChip < this.FNeedChip)
         {
            SToolReward.ShowMessage(this.FData.GetString(8));
            return;
         }
         this.SendServiceData(this.FCurIndex);
      }
      
      protected function CloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.Hide();
      }
      
      protected function TabOnSwitch(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = this.FData.GetGuardType(this.FCurIndex);
         _loc2_ = this.FActivityData.GetExchangeStatus(_loc4_);
         _loc3_ = this.FData.GetAwardsByGuard(this.FCurIndex)[this.FActivityData.CurDay].MaxGetCount;
         this.FOwnChip = this.FActivityData.GetChip(this.FData.GetGuardType(this.FCurIndex));
         this.FTFOwn.text = this.FOwnChip + "";
         switch(param1)
         {
            case 0:
               this.UpdateAwardByDay(this.FActivityData.CurDay);
               this.FBtnExchange.Visible = true;
               this.FMCIcon.visible = _loc2_ >= _loc3_;
               break;
            case 1:
               this.UpdateAwardByDay(this.FActivityData.CurDay + 1);
               this.FBtnExchange.Visible = false;
               this.FMCIcon.visible = false;
         }
      }
      
      protected function GiftOnOver(param1:MouseEvent) : void
      {
         var _loc2_:TInventories = null;
         _loc2_ = new TInventories();
         SToolReward.GetAwardsByAwardID(this.FAwardId,_loc2_);
         this.FGiftBoxTipData.TipReset();
         this.FGiftBoxTipData.NormalInventories = _loc2_;
         this.FGiftBoxTipData.AwardType = TOverlayerGiftBox.TYPE_ALL;
         this.FGiftBoxTipData.NeedColour = true;
         this.FGiftOverLayer.Context = this.FGiftBoxTipData;
         this.FGiftOverLayer.Render(FUICore.MouseCoordinate);
         this.FGiftOverLayer.Show();
      }
      
      protected function GiftOnOut(param1:MouseEvent) : void
      {
         this.FGiftOverLayer.Hide();
      }
      
      protected function KnifeOnOut(param1:MouseEvent) : void
      {
         this.FKnifePop.Visible = false;
      }
      
      protected function KnifeOnOver(param1:MouseEvent) : void
      {
         if(this.FKnifeOfKillSoulData != null)
         {
            this.FKnifePop.Visible = true;
            this.FKnifePop.UpdatePosition();
         }
      }
      
      protected function HeroOnClick(param1:MouseEvent) : void
      {
         if(this.FType == Type_Hero)
         {
            this.ProcessorShowHero(this.FSpriteMoudle,this.FHeroId);
         }
      }
      
      protected function ProcessorShowHero(param1:Object, param2:uint) : void
      {
         var _loc3_:TCoordinate = null;
         if(!this.FWindowShowHero.Visible)
         {
            this.FWindowShowHero.HeroID = param2;
            this.FWindowShowHero.Show();
            _loc3_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(this);
            this.FWindowShowHero.X = -_loc3_.X;
            this.FWindowShowHero.Y = -_loc3_.Y;
         }
      }
      
      protected function ProcessorShowKnifeOfKillSoul(param1:Object, param2:uint) : void
      {
         if(!this.FKnifePop.Visible)
         {
            if(this.FOnCreateKnifeOfKillSoulData != null && this.FKnifeOfKillSoulData == null)
            {
               this.FKnifeOfKillSoulData = this.FOnCreateKnifeOfKillSoulData(param2);
            }
            this.FKnifePop.KnifeData = this.FKnifeOfKillSoulData;
         }
      }
      
      protected function UpdateAwardByDay(param1:int) : void
      {
         var _loc2_:TActivityKLAward = null;
         var _loc3_:int = 0;
         var _loc4_:TDatebaseVO = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         this.ClearView();
         _loc2_ = this.FDayAwards[param1];
         this.FAwardId = _loc2_.AwardId;
         _loc7_ = _loc2_.DisplayId == 0 ? this.FAwardId : _loc2_.DisplayId;
         _loc3_ = this.CheckAwardType(_loc7_);
         this.FType = _loc3_;
         this.FNeedChip = _loc2_.CostCard;
         this.FTFNeed.text = this.FNeedChip + "";
         this.FTFName.text = this.FHeroName;
         switch(_loc3_)
         {
            case Type_Hero:
               this.FSpriteMoudle.visible = true;
               this.MCNameBack.visible = true;
               this.RenderHeroMoudle();
               break;
            case Type_Knife:
               this.FSpriteMoudle.visible = true;
               this.MCNameBack.visible = true;
               this.RenderHeroMoudle();
               break;
            case Type_Gift:
            case Type_SuperGift:
               this.FMCGift.visible = true;
               this.MCNameBack.visible = King_Type_2 == this.FCurIndex;
         }
      }
      
      protected function ClearView() : void
      {
         this.FMCGift.visible = false;
         this.FSpriteMoudle.visible = false;
         this.FKnifeOfKillSoulData = null;
      }
      
      protected function CheckAwardType(param1:int) : int
      {
         var _loc2_:TDatebaseVO = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,param1);
         if(_loc2_ != null)
         {
            this.FHeroId = param1;
            this.FHeroName = (_loc2_ as TBaseHero).Name;
            return Type_Hero;
         }
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_KnifeExpand,param1);
         if(_loc2_ != null)
         {
            this.FKnifeId = param1;
            this.FHeroId = (_loc2_ as TKnifeExpand).RelationID;
            _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Knife,this.FHeroId);
            this.FHeroName = (_loc2_ as TKnife).Name;
            this.ProcessorShowKnifeOfKillSoul(this.FSpriteMoudle,this.FKnifeId);
            return Type_Knife;
         }
         if(this.FCurIndex == King_Type_2)
         {
            _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Award,param1);
            _loc3_ = int((_loc2_ as TAward).FixedAwards[0].Code);
            _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc3_);
            _loc4_ = (_loc2_ as TArticle).Level;
            this.FHeroName = TUtilityString.Format(this.FData.GetString(11),_loc4_);
            return Type_SuperGift;
         }
         this.FHeroName = "";
         return Type_Gift;
      }
      
      public function set ActivityData(param1:TActivityKingGuardData) : void
      {
         this.FActivityData = param1;
      }
      
      public function get Data() : THDKingGuard
      {
         return this.FData;
      }
      
      public function set Data(param1:THDKingGuard) : void
      {
         this.FData = param1;
      }
      
      public function get SendData() : Function
      {
         return this.FSendData;
      }
      
      public function set SendData(param1:Function) : void
      {
         this.FSendData = param1;
      }
      
      public function set OnCreateKnifeOfKillSoulData(param1:Function) : void
      {
         this.FOnCreateKnifeOfKillSoulData = param1;
      }
      
      public function Show(param1:int) : void
      {
         if(!this.FIsInit)
         {
            this.ResourcesPerform_UIDispatch();
            this.FIsInit = true;
         }
         this.FCurIndex = param1;
         this.FDayAwards = this.FData.GetAwardsByGuard(this.FCurIndex);
         this.FTabs.GetTabByIndex(1).visible = this.FActivityData.CurDay < this.FDayAwards.length - 1;
         this.FTFDesc.text = TUtilityString.Format(this.FData.GetString(9),this.FData.GetString(this.FCurIndex));
         this.FTFCardName.text = TUtilityString.Format(this.FData.GetString(10),this.FData.GetString(this.FCurIndex));
         this.TabOnSwitch(0);
         this.Visible = true;
      }
      
      public function Hide() : void
      {
         this.Visible = false;
         this.FWindowShowHero.Visible = false;
      }
      
      public function UpdateAwardData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = this.FData.GetGuardType(this.FCurIndex);
         _loc1_ = this.FActivityData.GetExchangeStatus(_loc3_);
         _loc2_ = this.FData.GetAwardsByGuard(this.FCurIndex)[this.FActivityData.CurDay].MaxGetCount;
         this.FMCIcon.visible = _loc1_ >= _loc2_;
         this.FOwnChip = this.FActivityData.GetChip(this.FData.GetGuardType(this.FCurIndex));
         this.FTFOwn.text = this.FOwnChip + "";
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(Visible)
         {
            this.UpdateMovie();
         }
      }
      
      public function UpdateMovie() : void
      {
         this.FSpriteMoudle.UpdateView();
      }
   }
}

