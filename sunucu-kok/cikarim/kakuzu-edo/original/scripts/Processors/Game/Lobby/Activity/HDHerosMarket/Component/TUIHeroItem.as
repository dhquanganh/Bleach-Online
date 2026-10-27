package Processors.Game.Lobby.Activity.HDHerosMarket.Component
{
   import Foundation.Common.THint;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.TBaseHero;
   import Logics.DatebaseVO.VO.TKnife;
   import Logics.DatebaseVO.VO.TKnifeExpand;
   import Logics.DatebaseVO.VO.TRoleModel;
   import Logics.DatebaseVO.VO.TTavernWarrior;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TUIHeroItem extends TUIComponent
   {
      
      protected static const STATUS_NORMAL:uint = 1;
      
      protected static const STATUS_OVER:uint = 2;
      
      protected static const RECRUITED_NORMAL:int = -8;
      
      protected static const MILITARY_NORMAL:int = 50;
      
      protected static const HEADBOX_NORMAL:int = 0;
      
      protected static const RECRUITED_OVER:int = -13;
      
      protected static const MILITARY_OVER:int = 45;
      
      protected static const HEADBOX_OVER:int = -5;
      
      protected static const POS_Y:uint = 5;
      
      protected var FBackGround:MovieClip;
      
      protected var FMC_RecruitedTag:Sprite;
      
      protected var FMC_MilitaryType:MovieClip;
      
      protected var FMC_HeadBox:MovieClip;
      
      protected var FMC_Soul:MovieClip;
      
      protected var FMC_Bg:MovieClip;
      
      protected var FMC_HeadIcon:Sprite;
      
      protected var FMC_SelectBox:Sprite;
      
      protected var FTF_GeneralName:TextField;
      
      protected var FTF_GeneralSoul:TextField;
      
      protected var FBitMap:Bitmap;
      
      protected var FRoldModelBins:TBins;
      
      protected var FHint:THint;
      
      protected var FHeadId:uint;
      
      protected var FHeadName:String;
      
      protected var FIsSelect:Boolean;
      
      protected var FOnClick:Function;
      
      protected var FRecruitedTagVisible:Boolean;
      
      public function TUIHeroItem(param1:TUIComponent, param2:MovieClip, param3:TBins)
      {
         super(param1);
         this.FBackGround = param2;
         this.FRoldModelBins = param3;
         this.FBitMap = new Bitmap();
         this.FHint = new THint();
         this.GeneralInit();
      }
      
      private function GeneralInit() : void
      {
         this.FMC_SelectBox = this.FBackGround["MC_SelectBox"];
         this.FMC_HeadBox = this.FBackGround["MC_HeadBox"];
         this.FTF_GeneralName = this.FMC_HeadBox["tf_generalName"];
         this.FTF_GeneralSoul = this.FMC_HeadBox["tf_generalSoul"];
         this.FMC_Soul = this.FMC_HeadBox["mc_soul"];
         this.FMC_HeadIcon = this.FMC_HeadBox["mc_HeadIcon"];
         this.FMC_MilitaryType = this.FMC_HeadBox["mc_militaryType"];
         this.FMC_Bg = this.FBackGround["MC_Bg"];
         this.FMC_HeadIcon.addChild(this.FBitMap);
         this.FMC_SelectBox.visible = false;
         this.FMC_HeadBox.addEventListener(MouseEvent.MOUSE_MOVE,this.HeadBoxOnOver);
         this.FMC_HeadBox.addEventListener(MouseEvent.MOUSE_OUT,this.HeadBoxOnOut);
         this.FMC_HeadBox.addEventListener(MouseEvent.CLICK,this.HeadBoxOnClick);
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         var _loc5_:BitmapData = null;
         switch(param3)
         {
            case this.FHeadId:
               _loc4_ = param2.GetAnimationSequenceByIndex(0);
               _loc5_ = _loc4_.GetAnimationFrameByIndex(0).Surface;
               this.FBitMap.bitmapData = _loc5_;
         }
      }
      
      private function HeadBoxOnClick(param1:MouseEvent) : void
      {
         if(this.FIsSelect)
         {
            return;
         }
         if(this.FOnClick != null)
         {
            this.FOnClick(param1);
         }
         this.FIsSelect = true;
         this.FMC_SelectBox.visible = true;
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      private function HeadBoxOnOut(param1:MouseEvent) : void
      {
         if(this.FIsSelect)
         {
            return;
         }
         this.FMC_Bg.gotoAndStop(STATUS_NORMAL);
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      private function HeadBoxOnOver(param1:MouseEvent) : void
      {
         if(this.FIsSelect)
         {
            return;
         }
         if(this.FBackGround.mouseY >= this.FMC_HeadBox.height - POS_Y)
         {
            return;
         }
         this.FMC_Bg.gotoAndStop(STATUS_OVER);
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      public function set BackGroundVisible(param1:Boolean) : void
      {
         this.FBackGround.visible = param1;
      }
      
      public function set RecruitedVisible(param1:Boolean) : void
      {
      }
      
      public function get IsSelect() : Boolean
      {
         return this.FIsSelect;
      }
      
      public function set IsSelect(param1:Boolean) : void
      {
         this.FIsSelect = param1;
      }
      
      public function get OnClick() : Function
      {
         return this.FOnClick;
      }
      
      public function set OnClick(param1:Function) : void
      {
         this.FOnClick = param1;
      }
      
      public function UpdateBox(param1:TTavernWarrior, param2:uint) : void
      {
         this.FMC_MilitaryType.gotoAndStop(param2);
      }
      
      public function ResetBox() : void
      {
         this.FIsSelect = false;
         this.FMC_SelectBox.visible = false;
         this.FMC_Bg.gotoAndStop(STATUS_NORMAL);
      }
      
      public function UpdateIcon(param1:uint, param2:uint, param3:uint) : void
      {
         var _loc4_:TRoleModel = null;
         var _loc5_:TBaseHero = null;
         var _loc6_:TKnifeExpand = null;
         var _loc7_:TKnife = null;
         _loc4_ = this.FRoldModelBins.GetDatebaseByIdentifier(param1) as TRoleModel;
         this.FHeadId = _loc4_.RoleHead;
         SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(this.FHeadId,this.AutoLoadCallBack);
         if(param2 == 0)
         {
            _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,param1) as TBaseHero;
            this.FHint.Caption = _loc5_.Name;
            this.FMC_MilitaryType.visible = true;
            this.FMC_MilitaryType.gotoAndStop(param3);
         }
         if(param2 == 1)
         {
            _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Knife,param1) as TKnife;
            this.FHint.Caption = _loc7_.Name;
            this.FMC_MilitaryType.visible = false;
         }
      }
      
      public function UpdateRank(param1:Boolean) : void
      {
         if(param1)
         {
            this.FMC_SelectBox.visible = param1;
         }
         else
         {
            this.FMC_SelectBox.visible = param1;
         }
      }
      
      public function ResetBmp() : void
      {
         this.FBitMap.bitmapData = null;
      }
   }
}

