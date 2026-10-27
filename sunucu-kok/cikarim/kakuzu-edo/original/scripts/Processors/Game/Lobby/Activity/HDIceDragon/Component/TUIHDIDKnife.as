package Processors.Game.Lobby.Activity.HDIceDragon.Component
{
   import Components.Standard.TUIButton;
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Foundation.Queries.Textures.TQueryAnimationSequence;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityFilter;
   import Logics.DatebaseVO.VO.TKnifeExpand;
   import Logics.HDActivityChineseYear.ActivityLukia.TActivityLukia;
   import Logics.HDActivityChineseYear.ActivityLukia.TActivityLukiaChip;
   import Processors.Game.Lobby.Components.TUIHero;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TUIHDIDKnife extends TUIComponent
   {
      
      protected static const Filters:Array = [TUtilityFilter.highLightFilters];
      
      protected var FSP_Scene:Sprite;
      
      protected var FMC_MountPoint:MovieClip;
      
      protected var FUIHero:TUIHero;
      
      protected var FBtn_OK:TUIButton;
      
      protected var FTF_Condition:TextField;
      
      protected var FSP_AlreadyGet:Sprite;
      
      protected var FData_Knife:TActivityLukia;
      
      protected var FData_Chip:TActivityLukiaChip;
      
      protected var FIsInitWindow:Boolean;
      
      protected var FKnifeExpandBin:TBins;
      
      protected var FKnifeExpand:TKnifeExpand;
      
      protected var FOnExchangeClick:Function;
      
      protected var FOnShowKnifeClick:Function;
      
      protected var FOnQuerySequenceContext:Function;
      
      public function TUIHDIDKnife(param1:TUIComponent)
      {
         super(param1);
         this.FIsInitWindow = false;
         this.FUIHero = new TUIHero(null);
         this.FUIHero.OnQuerySequenceContext = this.HeroOnQuerySequenceContext;
      }
      
      protected function Resources_UIDispatch(param1:Sprite) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:TBounds = null;
         var _loc4_:TCoordinate = null;
         this.FSP_Scene = param1;
         this.FSP_AlreadyGet = this.FSP_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_AlreadyGet];
         this.FSP_AlreadyGet.mouseEnabled = false;
         this.FSP_AlreadyGet.mouseChildren = false;
         _loc2_ = this.FSP_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_OpenCondition];
         _loc2_.mouseChildren = false;
         _loc2_.mouseEnabled = false;
         this.FTF_Condition = _loc2_[CONST_ACTIVITY.RESOURCE_Link_TF_OpenCondition];
         this.FTF_Condition.mouseEnabled = false;
         this.FTF_Condition.text = "";
         this.FBtn_OK = new TUIButton();
         this.FBtn_OK.Substrate = this.FSP_Scene[CONST_ACTIVITY.RESOURCE_Link_BTN_OK];
         this.FBtn_OK.OnClick = this.ProcessorBtnOKOnClick;
         _loc3_ = new TBounds();
         _loc4_ = new TCoordinate();
         this.FUIHero.SequenceDefaultRole.Evaluate(_loc4_,_loc3_);
         this.FUIHero.X = _loc3_.X;
         this.FUIHero.Y = _loc3_.Y;
         this.FMC_MountPoint = this.FSP_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_MountPoint];
         this.FMC_MountPoint.addChild(this.FUIHero);
         this.FMC_MountPoint.addEventListener(MouseEvent.CLICK,this.ProcessorBtnShowOnClick);
         this.FMC_MountPoint.addEventListener(MouseEvent.MOUSE_MOVE,this.ProcessorOnMountPointOver);
         this.FMC_MountPoint.addEventListener(MouseEvent.MOUSE_OUT,this.ProcessorOnMountPointOut);
         this.FIsInitWindow = true;
         this.FKnifeExpandBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_KnifeExpand);
      }
      
      protected function ProcessorUpdateUI() : void
      {
         if(this.FData_Knife.IfEnlist)
         {
            this.FSP_AlreadyGet.visible = true;
            this.FBtn_OK.Enabled = false;
         }
         else
         {
            this.FSP_AlreadyGet.visible = false;
            if(this.FData_Chip.ChipNum >= this.FData_Knife.EnlistNeed)
            {
               this.FBtn_OK.Enabled = true;
            }
            else
            {
               this.FBtn_OK.Enabled = false;
            }
         }
         this.FTF_Condition.text = this.FData_Knife.EnlistNeed.toString();
         this.FKnifeExpand = this.FKnifeExpandBin.GetDatebaseByIdentifier(this.FData_Knife.LukiaID) as TKnifeExpand;
         this.FUIHero.Context = this.FKnifeExpand.RelationID;
      }
      
      protected function DoReset() : void
      {
         if(!this.FIsInitWindow)
         {
            return;
         }
         this.FTF_Condition.text = "";
         this.FUIHero.Context = null;
         this.FBtn_OK.Enabled = false;
         this.FSP_AlreadyGet.visible = false;
      }
      
      protected function ProcessorBtnShowOnClick(param1:MouseEvent) : void
      {
         if(this.FOnShowKnifeClick != null)
         {
            this.FOnShowKnifeClick(this);
         }
      }
      
      protected function ProcessorBtnOKOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnExchangeClick != null)
         {
            this.FOnExchangeClick(this,this.FData_Knife);
         }
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
      
      public function get OnExchangeClick() : Function
      {
         return this.FOnExchangeClick;
      }
      
      public function set OnExchangeClick(param1:Function) : void
      {
         this.FOnExchangeClick = param1;
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
      
      public function get OnShowKnifeClick() : Function
      {
         return this.FOnShowKnifeClick;
      }
      
      public function set OnShowKnifeClick(param1:Function) : void
      {
         this.FOnShowKnifeClick = param1;
      }
      
      public function Perform_UIDispatch(param1:Sprite) : void
      {
         this.Resources_UIDispatch(param1);
      }
      
      public function UpdateUI(param1:TActivityLukia, param2:TActivityLukiaChip) : void
      {
         this.FData_Knife = param1;
         this.FData_Chip = param2;
         this.ProcessorUpdateUI();
      }
      
      public function Reset() : void
      {
         this.DoReset();
      }
      
      public function UpdateHero() : void
      {
         if(!this.FIsInitWindow)
         {
            return;
         }
         this.FUIHero.Update();
      }
   }
}

