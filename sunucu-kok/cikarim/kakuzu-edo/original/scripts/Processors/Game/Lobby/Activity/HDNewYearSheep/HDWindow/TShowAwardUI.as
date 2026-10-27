package Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow
{
   import Components.Standard.TUIButton;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityFilter;
   import Foundation.Utilities.TUtilityTexture;
   import Logics.DatebaseVO.VO.TBaseHero;
   import Logics.HDActivityMode.TGiftBoxTipData;
   import Logics.Inventories.TInventories;
   import Logics.KnifeOfKillSoul.TKnifeOfKillSoulData;
   import Logics.Map.TMoudleInfor;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudle;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_MAP;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TShowAwardUI extends TProcessorLobbyWindow
   {
      
      protected static const Filters:Array = [TUtilityFilter.highLightFilters];
      
      public static const ArticalType_Hero:int = 0;
      
      public static const ArticalType_Knife:int = 1;
      
      public static const ArticalType_Gift:int = 2;
      
      protected var FMoudleMountPoint:Sprite;
      
      protected var FMoudleName:TextField;
      
      protected var FMoudleNameBackGround:Sprite;
      
      protected var FBtnGift:TUIButton;
      
      protected var FSpriteMoudle:TSceneSpriteMoudle;
      
      protected var FQureyMoudleInfor:TMoudleInfor;
      
      protected var FKnifeData:TKnifeOfKillSoulData;
      
      protected var FInventories:TInventories;
      
      protected var FGiftBoxTipData:TGiftBoxTipData;
      
      protected var FAwardType:int;
      
      protected var FAwardID:int;
      
      protected var FShowAwardID:int;
      
      protected var FGiftType:int;
      
      public function TShowAwardUI(param1:TUIComponent)
      {
         super(param1);
      }
      
      public function UIDispatch(param1:Sprite) : void
      {
         this.FMoudleName = param1["TF_HeroName"];
         this.FMoudleNameBackGround = param1["MC_NameBack"];
         this.FMoudleMountPoint = param1["MC_MountPoint"];
         this.FMoudleMountPoint.addEventListener(MouseEvent.MOUSE_MOVE,this.AwardOnMove);
         this.FMoudleMountPoint.addEventListener(MouseEvent.MOUSE_OUT,this.AwardOnOut);
         this.FMoudleMountPoint.addEventListener(MouseEvent.CLICK,this.AwardOnClick);
         this.FQureyMoudleInfor = new TMoudleInfor();
         this.FSpriteMoudle = new TSceneSpriteMoudle();
         this.FMoudleMountPoint.addChild(this.FSpriteMoudle);
         this.FBtnGift = new TUIButton();
         this.FBtnGift.Substrate = param1["MC_Gift"];
         this.FBtnGift.OnMove = this.AwardOnMove;
         this.FBtnGift.OnOut = this.AwardOnOut;
         this.FInventories = new TInventories();
         this.FGiftBoxTipData = new TGiftBoxTipData();
      }
      
      protected function RenderAward() : void
      {
         var _loc1_:TBaseHero = null;
         Visible = true;
         this.FInventories.Clear();
         switch(this.FAwardType)
         {
            case ArticalType_Hero:
               this.FMoudleName.visible = true;
               this.FMoudleNameBackGround.visible = true;
               this.FBtnGift.Visible = false;
               this.FMoudleMountPoint.visible = true;
               _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,this.FShowAwardID) as TBaseHero;
               this.FMoudleName.text = _loc1_.Name;
               TUtilityTexture.QueryTwoDirectionShowCase(CONST_MAP.DIRECTION_RIGHT,this.FShowAwardID,this.FQureyMoudleInfor);
               this.FSpriteMoudle.ChangeRoleMoudle(this.FQureyMoudleInfor.TextureID,this.FQureyMoudleInfor.Scalx);
               break;
            case ArticalType_Knife:
               this.FMoudleName.visible = true;
               this.FMoudleNameBackGround.visible = true;
               this.FBtnGift.Visible = false;
               this.FMoudleMountPoint.visible = true;
               this.FKnifeData = TUtilityLobby.CreateKnifeOfSkillSoulData(this.FShowAwardID);
               TUtilityTexture.QueryTwoDirectionShowCase(CONST_MAP.DIRECTION_RIGHT,this.FKnifeData.RelationID,this.FQureyMoudleInfor);
               this.FSpriteMoudle.ChangeRoleMoudle(this.FQureyMoudleInfor.TextureID,this.FQureyMoudleInfor.Scalx);
               this.FMoudleName.text = this.FKnifeData.Name;
               break;
            case ArticalType_Gift:
               if(this.FMoudleName != null)
               {
                  this.FMoudleName.visible = false;
               }
               if(this.FMoudleNameBackGround != null)
               {
                  this.FMoudleNameBackGround.visible = false;
               }
               this.FBtnGift.Visible = true;
               this.FMoudleMountPoint.visible = false;
               SToolReward.GetAwardsByAwardID(this.FAwardID,this.FInventories);
         }
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!Visible)
         {
            return;
         }
         if(this.FAwardType == ArticalType_Hero || this.FAwardType == ArticalType_Knife)
         {
            this.FSpriteMoudle.UpdateView();
         }
      }
      
      protected function AwardOnMove(param1:Object, param2:MouseEvent = null) : void
      {
         switch(this.FAwardType)
         {
            case ArticalType_Hero:
            case ArticalType_Knife:
               this.FMoudleMountPoint.filters = Filters;
               break;
            case ArticalType_Gift:
               this.FGiftBoxTipData.TipReset();
               this.FGiftBoxTipData.NormalInventories = this.FInventories;
               this.FGiftBoxTipData.AwardType = this.FGiftType;
               this.FGiftBoxTipData.NeedColour = true;
               SUtilityOverLayer.UIComponentsHintOnOver(this,this.FGiftBoxTipData);
         }
      }
      
      protected function AwardOnOut(param1:Object, param2:MouseEvent = null) : void
      {
         switch(this.FAwardType)
         {
            case ArticalType_Hero:
            case ArticalType_Knife:
               this.FMoudleMountPoint.filters = null;
               break;
            case ArticalType_Gift:
               SUtilityOverLayer.UIComponentsHintOnOut(this,this.FGiftBoxTipData);
         }
      }
      
      protected function AwardOnClick(param1:Object, param2:MouseEvent = null) : void
      {
         switch(this.FAwardType)
         {
            case ArticalType_Hero:
               SUtilityOverLayer.WindowShowHero.HeroID = this.FShowAwardID;
               SUtilityOverLayer.WindowShowHero.Show();
               break;
            case ArticalType_Knife:
               SUtilityOverLayer.KnifePop.KnifeData = this.FKnifeData;
               SUtilityOverLayer.KnifePop.Visible = true;
               break;
            case ArticalType_Gift:
         }
      }
      
      public function SetData(param1:int, param2:int, param3:int, param4:int = 0) : void
      {
         this.FAwardType = param1;
         this.FAwardID = param2;
         this.FShowAwardID = param3;
         this.FGiftType = param4;
         this.RenderAward();
      }
      
      public function Hide() : void
      {
         Visible = false;
         this.FSpriteMoudle.Release();
      }
   }
}

