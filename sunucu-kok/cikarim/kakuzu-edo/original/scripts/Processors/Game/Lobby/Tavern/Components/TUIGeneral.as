package Processors.Game.Lobby.Tavern.Components
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.TRoleModel;
   import Logics.DatebaseVO.VO.TTavernWarrior;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TUIGeneral extends TUIComponent
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
      
      protected var FHeadId:uint;
      
      protected var FIsSelect:Boolean;
      
      protected var FOnClick:Function;
      
      protected var FRecruitedTagVisible:Boolean;
      
      public function TUIGeneral(param1:TUIComponent, param2:MovieClip, param3:TBins)
      {
         super(param1);
         this.FBackGround = param2;
         this.FRoldModelBins = param3;
         this.FBitMap = new Bitmap();
         this.GeneralInit();
      }
      
      private function GeneralInit() : void
      {
         this.FMC_RecruitedTag = this.FBackGround["mc_recruited"];
         this.FMC_SelectBox = this.FBackGround["MC_SelectBox"];
         this.FMC_HeadBox = this.FBackGround["MC_HeadBox"];
         this.FTF_GeneralName = this.FMC_HeadBox["tf_generalName"];
         this.FTF_GeneralSoul = this.FMC_HeadBox["tf_generalSoul"];
         this.FMC_Soul = this.FMC_HeadBox["mc_soul"];
         this.FMC_HeadIcon = this.FMC_HeadBox["mc_HeadIcon"];
         this.FMC_Bg = this.FMC_HeadBox["MC_Bg"];
         this.FMC_MilitaryType = this.FMC_HeadBox["mc_militaryType"];
         this.FMC_HeadIcon.addChild(this.FBitMap);
         this.FMC_Bg.gotoAndStop(STATUS_NORMAL);
         this.FMC_SelectBox.visible = false;
         this.FMC_RecruitedTag.visible = false;
         this.FMC_HeadBox.addEventListener(MouseEvent.MOUSE_OVER,this.HeadBoxOnOver);
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
            this.FOnClick();
         }
         this.FIsSelect = true;
         this.FMC_RecruitedTag.y = RECRUITED_OVER;
         this.FMC_MilitaryType.y = MILITARY_OVER;
         this.FMC_HeadBox.y = HEADBOX_OVER;
         this.FMC_Bg.gotoAndStop(STATUS_OVER);
         this.FMC_SelectBox.visible = true;
      }
      
      private function HeadBoxOnOut(param1:MouseEvent) : void
      {
         if(this.FIsSelect)
         {
            return;
         }
         this.FMC_RecruitedTag.y = RECRUITED_NORMAL;
         this.FMC_MilitaryType.y = MILITARY_NORMAL;
         this.FMC_HeadBox.y = HEADBOX_NORMAL;
         this.FMC_Bg.gotoAndStop(STATUS_NORMAL);
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
         this.FMC_RecruitedTag.y = RECRUITED_OVER;
         this.FMC_MilitaryType.y = MILITARY_OVER;
         this.FMC_HeadBox.y = HEADBOX_OVER;
         this.FMC_Bg.gotoAndStop(STATUS_OVER);
      }
      
      public function set BackGroundVisible(param1:Boolean) : void
      {
         this.FBackGround.visible = param1;
      }
      
      public function set RecruitedVisible(param1:Boolean) : void
      {
         this.FMC_RecruitedTag.visible = param1;
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
      
      public function get RecruitedTagVisible() : Boolean
      {
         return this.FMC_RecruitedTag.visible;
      }
      
      public function UpdateBox(param1:TTavernWarrior, param2:uint) : void
      {
         this.FTF_GeneralName.text = param1.RecruitName;
         this.FTF_GeneralSoul.text = param1.RecruitSoul.toString();
         this.FMC_Soul.gotoAndStop(param1.Awardsouls.Type);
         this.FMC_HeadBox.gotoAndStop(param1.Awardsouls.Type);
         this.FMC_Bg = this.FMC_HeadBox["MC_Bg"];
         this.FMC_Bg.gotoAndStop(STATUS_NORMAL);
         this.FMC_MilitaryType.gotoAndStop(param2);
      }
      
      public function ResetBox() : void
      {
         this.FMC_RecruitedTag.y = RECRUITED_NORMAL;
         this.FMC_MilitaryType.y = MILITARY_NORMAL;
         this.FMC_HeadBox.y = HEADBOX_NORMAL;
         this.FMC_Bg.gotoAndStop(STATUS_NORMAL);
         this.FIsSelect = false;
         this.FMC_SelectBox.visible = false;
      }
      
      public function UpdateIcon(param1:TTavernWarrior) : void
      {
         var _loc2_:TRoleModel = null;
         _loc2_ = this.FRoldModelBins.GetDatebaseByIdentifier(param1.AwardId) as TRoleModel;
         this.FHeadId = _loc2_.RoleHead;
         SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(this.FHeadId,this.AutoLoadCallBack);
      }
      
      public function UpdateRank(param1:Boolean) : void
      {
         if(param1)
         {
            this.FMC_RecruitedTag.y = RECRUITED_OVER;
            this.FMC_MilitaryType.y = MILITARY_OVER;
            this.FMC_HeadBox.y = HEADBOX_OVER;
            this.FMC_Bg.gotoAndStop(STATUS_OVER);
            this.FMC_SelectBox.visible = param1;
         }
         else
         {
            this.FMC_RecruitedTag.y = RECRUITED_NORMAL;
            this.FMC_MilitaryType.y = MILITARY_NORMAL;
            this.FMC_HeadBox.y = HEADBOX_NORMAL;
            this.FMC_Bg.gotoAndStop(STATUS_NORMAL);
            this.FMC_SelectBox.visible = param1;
         }
      }
      
      public function ResetBmp() : void
      {
         this.FBitMap.bitmapData = null;
      }
   }
}

