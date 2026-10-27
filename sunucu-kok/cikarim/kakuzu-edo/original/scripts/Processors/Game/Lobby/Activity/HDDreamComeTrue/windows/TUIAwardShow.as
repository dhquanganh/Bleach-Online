package Processors.Game.Lobby.Activity.HDDreamComeTrue.windows
{
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Foundation.Queries.Textures.TQueryAnimationSequence;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityFilter;
   import Logics.DatebaseVO.VO.TBaseHero;
   import Logics.DatebaseVO.VO.TKnife;
   import Logics.DatebaseVO.VO.TKnifeExpand;
   import Logics.HDDreamsComeTrue.vo.TAwardExchangeVo;
   import Processors.Game.Lobby.Components.TUIHero;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_DREAMS;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TUIAwardShow extends TUIComponent
   {
      
      protected static const Filters:Array = [TUtilityFilter.highLightFilters];
      
      protected var FScene:Sprite;
      
      protected var FMC_MountPoint:MovieClip;
      
      protected var FSP_AlreadyGet:Sprite;
      
      protected var FTF_HeroName:TextField;
      
      protected var FMC_NameBack:Sprite;
      
      protected var FGift:Sprite;
      
      protected var FUIHero:TUIHero;
      
      protected var FData:TAwardExchangeVo;
      
      protected var FIsInitWindow:Boolean;
      
      protected var FOnBtnOKClick:Function;
      
      protected var FOnShowHeroClick:Function;
      
      protected var FOnQuerySequenceContext:Function;
      
      public function TUIAwardShow(param1:TUIComponent)
      {
         super(param1);
         this.FIsInitWindow = false;
         this.FUIHero = new TUIHero(null);
         this.FUIHero.OnQuerySequenceContext = this.HeroOnQuerySequenceContext;
      }
      
      protected function Resources_UIDispatch(param1:Sprite) : void
      {
         var _loc2_:TBounds = null;
         var _loc3_:TCoordinate = null;
         this.FScene = param1;
         this.FSP_AlreadyGet = this.FScene["MC_Receive"];
         this.FSP_AlreadyGet.mouseChildren = false;
         this.FSP_AlreadyGet.mouseEnabled = false;
         this.FSP_AlreadyGet.visible = false;
         this.FTF_HeroName = this.FScene["TF_HeroName"];
         this.FTF_HeroName.mouseEnabled = false;
         this.FTF_HeroName.text = "";
         this.FMC_NameBack = this.FScene["MC_NameBack"];
         this.FMC_NameBack.visible = false;
         this.FGift = this.FScene["MC_Gift"];
         this.FGift.visible = false;
         this.FMC_MountPoint = this.FScene["MC_MountPoint"];
         this.FMC_MountPoint.addChild(this.FUIHero);
         this.FMC_MountPoint.addEventListener(MouseEvent.CLICK,this.ProcessorBtnShowOnClick);
         this.FMC_MountPoint.addEventListener(MouseEvent.MOUSE_MOVE,this.ProcessorOnMountPointOver);
         this.FMC_MountPoint.addEventListener(MouseEvent.MOUSE_OUT,this.ProcessorOnMountPointOut);
         _loc2_ = new TBounds();
         _loc3_ = new TCoordinate();
         this.FUIHero.SequenceDefaultRole.Evaluate(_loc3_,_loc2_);
         this.FUIHero.X = _loc2_.X;
         this.FUIHero.Y = _loc2_.Y;
         this.FIsInitWindow = true;
      }
      
      protected function ProcessorUpdateUI() : void
      {
         var _loc1_:TBaseHero = null;
         var _loc2_:TKnifeExpand = null;
         var _loc3_:TKnife = null;
         if(this.FData.AwardType == CONST_DREAMS.Type_0)
         {
            _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,this.FData.HeroId) as TBaseHero;
            this.FTF_HeroName.text = _loc1_.Name;
            this.FUIHero.Context = this.FData.HeroId;
            this.FGift.visible = false;
            this.FMC_NameBack.visible = true;
            this.FTF_HeroName.visible = true;
            this.FMC_MountPoint.visible = true;
         }
         if(this.FData.AwardType == CONST_DREAMS.Type_1)
         {
            _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_KnifeExpand,this.FData.HeroId) as TKnifeExpand;
            _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Knife,_loc2_.RelationID) as TKnife;
            this.FTF_HeroName.text = _loc3_.Name;
            this.FUIHero.Context = _loc2_.RelationID;
            this.FGift.visible = false;
            this.FMC_NameBack.visible = true;
            this.FTF_HeroName.visible = true;
            this.FMC_MountPoint.visible = true;
         }
         if(this.FData.AwardType == CONST_DREAMS.Type_2 || this.FData.AwardType == CONST_DREAMS.Type_3 || this.FData.AwardType == CONST_DREAMS.Type_4)
         {
            this.FGift.visible = true;
            this.FMC_NameBack.visible = false;
            this.FTF_HeroName.visible = false;
            this.FMC_MountPoint.visible = false;
         }
         this.FTF_HeroName.width = this.FTF_HeroName.width;
         this.FTF_HeroName.wordWrap = true;
         this.FSP_AlreadyGet.visible = false;
         if(this.FData.Status == CONST_DREAMS.Activity_AlreadyReceive && (this.FData.AwardType == CONST_DREAMS.Type_0 || this.FData.AwardType == CONST_DREAMS.Type_1))
         {
            this.FSP_AlreadyGet.visible = true;
         }
      }
      
      protected function DoReset() : void
      {
         if(!this.FIsInitWindow)
         {
            return;
         }
         if(this.FUIHero != null)
         {
            this.FUIHero.Context = null;
         }
         this.FSP_AlreadyGet.visible = false;
         this.FTF_HeroName.text = "";
      }
      
      protected function ProcessorBtnShowOnClick(param1:MouseEvent) : void
      {
         if(this.FOnShowHeroClick != null)
         {
            this.FOnShowHeroClick(this,this.FData);
         }
      }
      
      protected function ProcessorOnMountPointOver(param1:MouseEvent) : void
      {
         param1.currentTarget.buttonMode = true;
         this.FMC_MountPoint.filters = Filters;
      }
      
      protected function ProcessorOnMountPointOut(param1:MouseEvent) : void
      {
         param1.currentTarget.buttonMode = false;
         this.FMC_MountPoint.filters = null;
      }
      
      protected function HeroOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TBounds = null;
         var _loc6_:TCoordinate = null;
         if(this.FOnQuerySequenceContext != null)
         {
            this.FOnQuerySequenceContext(param1,param2,param3,param4);
            if(param3.Value != null)
            {
               _loc5_ = new TBounds();
               _loc6_ = new TCoordinate();
               param3.Value.Evaluate(_loc6_,_loc5_);
               this.FUIHero.X = _loc5_.X;
               this.FUIHero.Y = _loc5_.Y;
            }
         }
      }
      
      public function get OnShowHeroClick() : Function
      {
         return this.FOnShowHeroClick;
      }
      
      public function set OnShowHeroClick(param1:Function) : void
      {
         this.FOnShowHeroClick = param1;
      }
      
      public function get OnQuerySequenceContext() : Function
      {
         return this.FOnQuerySequenceContext;
      }
      
      public function set OnQuerySequenceContext(param1:Function) : void
      {
         this.FOnQuerySequenceContext = param1;
      }
      
      public function get SequenceDefaultRole() : TAnimationSequence
      {
         return this.FUIHero.SequenceDefaultRole;
      }
      
      public function set SequenceDefaultRole(param1:TAnimationSequence) : void
      {
         if(param1 != null)
         {
            this.FUIHero.SequenceDefaultRole = param1;
         }
      }
      
      override public function set X(param1:int) : void
      {
         if(this.FScene != null)
         {
            this.FScene.x = param1;
         }
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         if(this.FScene != null)
         {
            this.FScene.visible = param1;
         }
      }
      
      public function Perform_UIDispatch(param1:Sprite) : void
      {
         this.Resources_UIDispatch(param1);
      }
      
      public function UpdateUI(param1:TAwardExchangeVo) : void
      {
         this.FData = param1;
         this.ProcessorUpdateUI();
      }
      
      public function Reset() : void
      {
         this.DoReset();
      }
      
      public function UpdateUIHero() : void
      {
         if(!this.FIsInitWindow)
         {
            return;
         }
         if(this.FScene.visible && this.FUIHero.Context != null)
         {
            this.FUIHero.Update();
         }
      }
   }
}

