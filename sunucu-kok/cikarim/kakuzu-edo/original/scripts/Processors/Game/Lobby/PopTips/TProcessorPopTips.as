package Processors.Game.Lobby.PopTips
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Processors.*;
   import Processors.Game.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import ghostcat.util.easing.*;
   
   public class TProcessorPopTips extends TProcessor
   {
      
      protected static const INIT_SCENE_WIDTH:int = 370;
      
      protected static const POPTIP_LevelSpree:uint = CONST_POPTIPS.POPTIP_LevelSpree;
      
      protected static const BASE_ID_Profession:uint = 11100000;
      
      protected static const BASE_ID_GirlID:uint = 200000;
      
      protected static const SOULSTAR_TabIndex:uint = 1;
      
      protected var FScene:MovieClip;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FBtn_Goto:TUIButton;
      
      protected var FSP_MountPointIcon:Sprite;
      
      protected var FMC_GirlMountPoint:Sprite;
      
      protected var FTF_Title:TextField;
      
      protected var FTF_Desc:TextField;
      
      protected var FTF_BtnCaption:TextField;
      
      protected var FMC_Effect:MovieClip;
      
      protected var FMountPointsBounds:TBounds;
      
      protected var FMountPointsPivot:TCoordinate;
      
      protected var FIdVect:Vector.<uint>;
      
      protected var FPopTipsVect:Vector.<TPopTips>;
      
      protected var FCurPopTipsIndex:int;
      
      protected var FPopTips:TBins;
      
      protected var FPopTipBitmap:Bitmap;
      
      protected var FPopTipIconID:int;
      
      protected var FPopTipSkillPicIDs:Vector.<uint>;
      
      protected var FPopTipSkillPicID:uint;
      
      protected var FPopTipGirlBitmap:Bitmap;
      
      protected var FPopTipGirlPicID:uint;
      
      protected var FPopTipGirlIndex:int;
      
      protected var FInitialization:Boolean;
      
      protected var FMCSceneHeight:uint;
      
      protected var FLevelGiftBagState:Boolean;
      
      protected var FOnOpenPlantWindowByIndex:Function;
      
      public function TProcessorPopTips(param1:TUIComponent)
      {
         super(param1);
         this.FInitialization = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FIdVect = new Vector.<uint>();
         this.FPopTipsVect = new Vector.<TPopTips>();
         this.FPopTips = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_PopTips);
         this.FScene = TUtilityReflection.CreateDisplayObjectInstance(CONST_POPTIPS.RESOURCE_ClassName_MC_PopTips) as MovieClip;
         addChild(this.FScene);
         this.FMCSceneHeight = this.FScene.height;
         this.mouseChildren = false;
         this.mouseEnabled = false;
         this.FSP_MountPointIcon = this.FScene[CONST_POPTIPS.RESOURCE_Link_SP_MountPointIcon];
         this.FPopTipBitmap = new Bitmap();
         this.FSP_MountPointIcon.addChild(this.FPopTipBitmap);
         this.FMC_GirlMountPoint = this.FScene[CONST_POPTIPS.RESOURCE_Link_Girl_MountPointIcon];
         this.FPopTipGirlBitmap = new Bitmap();
         this.FMC_GirlMountPoint.addChild(this.FPopTipGirlBitmap);
         this.FMountPointsBounds = new TBounds();
         this.FMountPointsPivot = new TCoordinate();
         this.FBtn_Close = this.FScene[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtn_Close.addEventListener(MouseEvent.MOUSE_UP,this.BtnOnClose);
         this.FBtn_Goto = new TUIButton();
         this.FBtn_Goto.Substrate = this.FScene[CONST_POPTIPS.RESOURCE_Link_Btn_Goto];
         this.FBtn_Goto.OnClick = this.BtnOnGoto;
         this.FTF_BtnCaption = this.FBtn_Goto.Substrate[CONST_POPTIPS.RESOURCE_Link_TF_BtnCaption];
         this.FTF_BtnCaption.mouseEnabled = false;
         this.FTF_Desc = this.FScene[CONST_POPTIPS.RESOURCE_Link_TF_Desc];
         this.FTF_Desc.mouseEnabled = false;
         this.FTF_Title = this.FScene[CONST_POPTIPS.RESOURCE_Link_TF_Title];
         this.FTF_Title.mouseEnabled = false;
         this.FMC_Effect = this.FScene[CONST_POPTIPS.RESOURCE_Link_MC_Effect];
         this.FMC_Effect.mouseEnabled = false;
         this.FMC_Effect.mouseChildren = false;
         this.FMC_Effect.stop();
         this.FCurPopTipsIndex = -1;
         this.FInitialization = true;
         super.ResourcesPerform_UIDispatch();
      }
      
      protected function LoadPopTipIcon() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         this.FPopTipIconID = this.FPopTipsVect[this.FCurPopTipsIndex].Image;
         this.FPopTipSkillPicIDs = this.FPopTipsVect[this.FCurPopTipsIndex].SkillPicIDs;
         if(this.FPopTipSkillPicIDs.length > 0)
         {
            _loc1_ = uint(SLogicsCore.Character.MainHero.Profession);
            _loc2_ = _loc1_ % BASE_ID_Profession - 1;
            this.FPopTipSkillPicID = this.FPopTipSkillPicIDs[_loc2_];
            SResourcesCore.TexturesSkillIcon.LoadAutoSecondary(this.FPopTipSkillPicID,this.AutoLoadCallBack);
         }
         else
         {
            SResourcesCore.TexturesSmallIcon.LoadAutoSecondary(this.FPopTipIconID,this.AutoLoadCallBack);
         }
         _loc3_ = this.FPopTipsVect[this.FCurPopTipsIndex].GirlPicID;
         this.FPopTipGirlIndex = _loc3_ % BASE_ID_GirlID;
         this.ProcessorShowGirl();
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         _loc4_ = param2.GetAnimationSequenceByIndex(0);
         this.FPopTipBitmap.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
      }
      
      protected function ProcessorShowGirl() : void
      {
         SResourcesCore.TexturesSmallIcon.LoadAutoSecondary(BASE_ID_GirlID,this.AutoLoadGirlPicCallBack);
      }
      
      protected function AutoLoadGirlPicCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         _loc4_ = param2.GetAnimationSequenceByIndex(this.FPopTipGirlIndex);
         _loc4_.Evaluate(this.FMountPointsPivot,this.FMountPointsBounds);
         this.FPopTipGirlBitmap.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
         this.FPopTipGirlBitmap.x = this.FMountPointsBounds.X;
         this.FPopTipGirlBitmap.y = this.FMountPointsBounds.Y;
      }
      
      protected function ProcessorGotoTips(param1:uint) : void
      {
         if(this.FCurPopTipsIndex == param1)
         {
            return;
         }
         this.FCurPopTipsIndex = param1;
         this.LoadPopTipIcon();
         this.UpdataUI();
      }
      
      protected function UpdataUI() : void
      {
         var _loc1_:TPopTips = null;
         _loc1_ = this.FPopTipsVect[this.FCurPopTipsIndex];
         this.FTF_Desc.htmlText = _loc1_.Tips;
         this.FTF_BtnCaption.text = _loc1_.OpenButton;
         this.FTF_Title.text = _loc1_.OpenButton;
      }
      
      protected function GetCurrentStageWidth() : int
      {
         return FUICore.StageWidth;
      }
      
      override protected function ProcessorResize() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(!this.FInitialization || !this.Visible)
         {
            return;
         }
         _loc1_ = FUICore.StageWidth;
         _loc2_ = FUICore.StageHeight;
         this.X = _loc1_ - INIT_SCENE_WIDTH;
         this.Y = _loc2_ - this.FMCSceneHeight - 40;
      }
      
      protected function BtnOnClose(param1:MouseEvent = null) : void
      {
         var _loc2_:int = 0;
         if(!this.Visible)
         {
            return;
         }
         this.FIdVect.length = 0;
         this.FPopTipsVect.length = 0;
         this.FCurPopTipsIndex = -1;
         _loc2_ = this.GetCurrentStageWidth();
         TweenUtil.to(this,500,{
            "x":_loc2_,
            "onComplete":this.ProcessorTweenOnEnd
         });
         this.mouseEnabled = false;
         this.mouseChildren = false;
      }
      
      protected function BtnOnGoto(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         if(this.FCurPopTipsIndex < 0)
         {
            return;
         }
         _loc3_ = uint(this.FPopTipsVect[this.FCurPopTipsIndex].Panel);
         if(this.FOnOpenPlantWindowByIndex != null)
         {
            if(this.FPopTipSkillPicIDs.length > 0)
            {
               this.FOnOpenPlantWindowByIndex(this,_loc3_,SOULSTAR_TabIndex,this.FPopTipSkillPicID);
            }
            else
            {
               this.FOnOpenPlantWindowByIndex(this,_loc3_);
            }
         }
         this.BtnOnClose();
      }
      
      protected function ProcessorTweenOnEnd() : void
      {
         if(this.FMC_Effect.isPlaying)
         {
            this.FMC_Effect.stop();
         }
         if(this.FPopTipBitmap.bitmapData != null)
         {
            this.FPopTipBitmap.bitmapData = null;
         }
         if(this.FPopTipGirlBitmap.bitmapData != null)
         {
            this.FPopTipGirlBitmap.bitmapData = null;
         }
         if(this.Visible)
         {
            this.Visible = false;
         }
      }
      
      public function get LevelGiftBagState() : Boolean
      {
         return this.FLevelGiftBagState;
      }
      
      public function set LevelGiftBagState(param1:Boolean) : void
      {
         this.FLevelGiftBagState = param1;
      }
      
      public function get OnOpenPlantWindowByIndex() : Function
      {
         return this.FOnOpenPlantWindowByIndex;
      }
      
      public function set OnOpenPlantWindowByIndex(param1:Function) : void
      {
         this.FOnOpenPlantWindowByIndex = param1;
      }
      
      public function Hide() : void
      {
         this.BtnOnClose();
      }
      
      public function AddPopTips(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TPopTips = null;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         _loc2_ = this.FIdVect.indexOf(param1);
         if(_loc2_ >= 0)
         {
            this.ProcessorGotoTips(_loc2_);
            return;
         }
         _loc3_ = this.FPopTips.GetDatebaseByIdentifier(param1) as TPopTips;
         if(_loc3_ == null)
         {
            return;
         }
         _loc4_ = uint(SLogicsCore.Character.GetMainLevel());
         if(_loc4_ < _loc3_.DownLevel || _loc4_ > _loc3_.UpLevel)
         {
            return;
         }
         if(this.Visible == false)
         {
            this.FIdVect.push(param1);
            this.FPopTipsVect.push(_loc3_);
            this.ProcessorGotoTips(this.FPopTipsVect.length - 1);
            if(this.FIdVect.length > 0)
            {
               this.X = CONST_COMMON.STAGE_Width;
               this.Visible = true;
               _loc5_ = this.GetCurrentStageWidth();
               TweenUtil.to(this,500,{"x":_loc5_ - INIT_SCENE_WIDTH});
               this.FMC_Effect.play();
            }
            this.mouseEnabled = true;
            this.mouseChildren = true;
            this.ProcessorResize();
         }
      }
      
      public function CheckPopTipsByPanelId(param1:uint) : void
      {
         var _loc2_:* = 0;
         var _loc3_:int = 0;
         var _loc4_:TPopTips = null;
         _loc3_ = this.FPopTipsVect.length - 1;
         _loc2_ = _loc3_;
         while(_loc2_ >= 0)
         {
            _loc4_ = this.FPopTipsVect[_loc2_];
            if(_loc4_.Panel == param1)
            {
               this.FPopTipsVect.splice(_loc2_,1);
               this.FIdVect.splice(_loc2_,1);
               break;
            }
            _loc2_--;
         }
         _loc3_ = int(this.FPopTipsVect.length);
         if(_loc3_ <= 0)
         {
            this.BtnOnClose();
         }
         else
         {
            this.ProcessorGotoTips(_loc3_ - 1);
         }
      }
      
      public function CheckLevelGiftBag() : void
      {
         if(this.FLevelGiftBagState)
         {
            this.AddPopTips(CONST_POPTIPS.POPTIP_LevelSpree);
         }
      }
      
      public function CheckAddFriends() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TConfigValue = null;
         var _loc4_:Vector.<uint> = null;
         _loc2_ = uint(SLogicsCore.Character.GetMainLevel());
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_POPTIPS.CONFIG_AddFriend) as TConfigValue;
         _loc4_ = _loc3_.Value as Vector.<uint>;
         _loc1_ = 0;
         while(_loc1_ < _loc4_.length)
         {
            if(_loc2_ == _loc4_[_loc1_])
            {
               this.AddPopTips(CONST_POPTIPS.CONFIG_AddFriend);
               break;
            }
            _loc1_++;
         }
      }
   }
}

