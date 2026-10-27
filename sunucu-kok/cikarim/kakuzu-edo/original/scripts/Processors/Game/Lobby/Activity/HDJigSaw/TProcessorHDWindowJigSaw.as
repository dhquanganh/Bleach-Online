package Processors.Game.Lobby.Activity.HDJigSaw
{
   import Components.Standard.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HDActivityOS.*;
   import Logics.HDJigSaw.*;
   import Logics.Inventories.*;
   import Processors.Game.Common.Effects.Display.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Activity.HDActivityOS.Component.TUIActivityOSAwardList;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   
   public class TProcessorHDWindowJigSaw extends TProcessorHDSingleWindowBase
   {
      
      protected static const COUNT_JIGSAW:uint = 9;
      
      protected static const TITLE_HEIGHT:uint = 60;
      
      protected var FData_JigSaw:TActivityJigSaw;
      
      protected var FHD_JigSaw:THDJigSaw;
      
      protected var FMC_HDDesc:Sprite;
      
      protected var FMC_Effect:MovieClip;
      
      protected var FTF_Income:TextField;
      
      protected var FMC_Jigsaw:MovieClip;
      
      protected var FMC_Property:Sprite;
      
      protected var FMC_Achievement:MovieClip;
      
      protected var FBM_Achievement:Bitmap;
      
      protected var FTitleAnimationSequence:TAnimationSequence;
      
      protected var FMC_JigsawSmall:Vector.<Sprite>;
      
      protected var FMC_JigsawSmallPos:Vector.<Sprite>;
      
      protected var FMC_FunctionBar:Sprite;
      
      protected var FMC_JigsawBig:Vector.<Sprite>;
      
      protected var FBtn_ScoreShop:TUIButton;
      
      protected var FMC_Fun:Sprite;
      
      protected var FMC_Flash:MovieClip;
      
      protected var FMC_Progress:MovieClip;
      
      protected var FAwardListVect:Vector.<TUIActivityOSAwardList>;
      
      protected var FGlowFilter:TEffectBaseGlowTwo;
      
      protected var FTEffectMove:TEffectBaseMove;
      
      protected var CurIndex:int;
      
      protected var FAwardInventories:Vector.<TInventories>;
      
      protected var FScroes:Vector.<int>;
      
      protected var FTimeStore:int;
      
      protected var FIsInitWindow:Boolean;
      
      protected var FOnScoreShop:Function;
      
      public function TProcessorHDWindowJigSaw(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = CONST_ACTIVITY.RESOURCE_ClassName_JigSaw;
         FActivityID = CONST_ACTIVITY_MODE.Activity_JigSaw;
         this.FIsInitWindow = false;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FBM_Achievement != null)
         {
            this.UpdateAchievementTitle();
         }
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:TUIActivityOSAwardList = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:MovieClip = null;
         this.FMC_JigsawSmall = new Vector.<Sprite>(_loc3_);
         this.FMC_JigsawSmallPos = new Vector.<Sprite>(_loc3_);
         _loc3_ = COUNT_JIGSAW;
         super.InitWindow(param1);
         this.FMC_Effect = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_List_MC_SingleEffect];
         this.FMC_HDDesc = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_HDDesc];
         this.FMC_Jigsaw = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_Jigsaw];
         this.FTF_Income = FScene[CONST_ACTIVITY.RESOURCE_Link_TF_Income];
         this.FMC_Property = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_Property];
         this.FMC_FunctionBar = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_FunctionBar];
         this.FMC_Flash = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_Flash];
         this.FMC_Progress = this.FMC_FunctionBar[CONST_ACTIVITY.RESOURCE_Link_MC_ProgressBar];
         this.FMC_Fun = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_Fun];
         this.FMC_Effect.stop();
         this.FMC_Flash.stop();
         this.FMC_Effect.mouseChildren = false;
         this.FMC_Effect.mouseEnabled = false;
         this.FGlowFilter = new TEffectBaseGlowTwo();
         this.FAwardListVect = new Vector.<TUIActivityOSAwardList>(_loc3_);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            this.FAwardListVect[_loc4_] = new TUIActivityOSAwardList(this);
            this.FAwardListVect[_loc4_].OnQuerySequenceContext = SlotsOnQuerySequenceContext;
            this.FAwardListVect[_loc4_].OnQuerySubscript = SlotsOnQuerySubscript;
            this.FAwardListVect[_loc4_].OnBtnOkClick = this.BtnOKOnClick;
            this.FAwardListVect[_loc4_].Perform_UIDispatch(this.FMC_FunctionBar[CONST_ACTIVITY.RESOURCE_Link_MC_Fun + _loc4_],1,0,false);
            this.FMC_JigsawSmall[_loc4_] = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_JigsawSmall + _loc4_];
            this.FMC_JigsawSmallPos[_loc4_] = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_JigsawSmallPos + _loc4_];
            this.FMC_JigsawSmallPos[_loc4_].addEventListener(MouseEvent.MOUSE_MOVE,this.ShowTipOnMove);
            this.FMC_JigsawSmallPos[_loc4_].addEventListener(MouseEvent.MOUSE_OUT,this.HideTipOnOut);
            _loc4_++;
         }
         this.FBtn_ScoreShop = new TUIButton();
         this.FBtn_ScoreShop.OnClick = this.FOnScoreShop;
         this.FBtn_ScoreShop.Substrate = FScene["Btn_ScoreShop"];
         _loc5_ = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_Title];
         this.FMC_Achievement = _loc5_[CONST_ACTIVITY.RESOURCE_Link_MC_Point];
         this.FBM_Achievement = new Bitmap();
         this.FMC_Achievement.addChild(this.FBM_Achievement);
         this.FMC_HDDesc.addEventListener(MouseEvent.MOUSE_MOVE,this.OnDescOnOver);
         this.FMC_HDDesc.addEventListener(MouseEvent.MOUSE_OUT,this.OnDescOut);
         this.FIsInitWindow = true;
      }
      
      protected function ShowTipOnMove(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = uint(param1.currentTarget.name.split("_")[2]);
         if(FOnGiftBoxMove != null)
         {
            FOnGiftBoxMove(this,this.FAwardInventories[_loc2_]);
         }
      }
      
      protected function HideTipOnOut(param1:MouseEvent) : void
      {
         if(FOnGiftBoxOut != null)
         {
            FOnGiftBoxOut(this);
         }
      }
      
      override protected function BtnOKOnClick(param1:Object, param2:uint) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param2);
         this.SmallJigSawOnShow(this.CurIndex);
         this.UpdateUI();
      }
      
      protected function SmallJigSawOnShow(param1:uint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc2_ = COUNT_JIGSAW;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FMC_JigsawSmall[_loc3_].x = this.FMC_JigsawSmallPos[_loc3_].x;
            this.FMC_JigsawSmall[_loc3_].y = this.FMC_JigsawSmallPos[_loc3_].y;
            _loc3_++;
         }
         this.FTEffectMove = new TEffectBaseMove(this.FMC_JigsawSmall[param1],new Point(this.FMC_JigsawSmallPos[param1].x,this.FMC_JigsawSmallPos[param1].y),new Point(this.FMC_Jigsaw.x + 100,this.FMC_Jigsaw.y + 100),30,this.BigJigSawOnShow);
         this.addEventListener(Event.ENTER_FRAME,this.SmallJigSawOnMove);
      }
      
      protected function SmallJigSawOnMove(param1:Event) : void
      {
         this.FTEffectMove.Run();
      }
      
      protected function BigJigSawOnShow() : void
      {
         this.FTEffectMove.Reset();
         this.removeEventListener(Event.ENTER_FRAME,this.SmallJigSawOnMove);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:Vector.<uint> = null;
         super.UpdateUIConfig();
         this.FHD_JigSaw = FHDActivityConfig as THDJigSaw;
         _loc1_ = this.FHD_JigSaw.AwardsList.length;
         _loc3_ = new Vector.<uint>(_loc1_);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_[_loc2_] = this.FHD_JigSaw.AwardsList[_loc2_].Award;
            _loc2_++;
         }
         this.FAwardInventories = ProcessorGetInventoriesVectByAwardID(_loc3_);
         ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
         ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.UpdateDataBase(param1);
         this.FData_JigSaw = param1 as TActivityJigSaw;
         _loc2_ = this.FData_JigSaw.Awards.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.FData_JigSaw.Awards[_loc3_].Status == -1)
            {
               this.CurIndex = _loc3_;
            }
            _loc3_++;
         }
         _loc2_ = this.FData_JigSaw.Awards.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.SetAwardDayStatus(_loc3_,this.FData_JigSaw.Awards[_loc3_].Status);
            _loc3_++;
         }
         this.UpdateUI();
      }
      
      override protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<String> = null;
         var _loc4_:Vector.<int> = null;
         var _loc5_:Vector.<int> = null;
         super.UpdateUI();
         this.FTF_Income.text = this.FData_JigSaw.Score.Score.toString();
         if(this.FAwardListVect == null)
         {
            return;
         }
         _loc2_ = int(this.FData_JigSaw.Awards.length);
         _loc3_ = new Vector.<String>(_loc2_);
         _loc4_ = new Vector.<int>(_loc2_);
         _loc5_ = new Vector.<int>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_[_loc1_] = this.FData_JigSaw.Awards[_loc1_].Status;
            _loc1_++;
         }
         if(_loc5_.indexOf(0) != -1 && this.FData_JigSaw.Score.Score >= this.FHD_JigSaw.AwardsList[_loc5_.indexOf(0)].Value)
         {
            _loc5_[_loc5_.indexOf(0)] = 1;
            this.CurIndex = _loc5_.indexOf(1);
         }
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_[0] = this.FHD_JigSaw.AwardsList[_loc1_].Value.toString();
            this.FAwardListVect[_loc1_].UpDateUI(this.FData_JigSaw.Awards[_loc1_].Index,null,_loc3_);
            this.FAwardListVect[_loc1_].UpDateBtn(_loc5_[_loc1_]);
            _loc1_++;
         }
         this.UpdateUIAchievement();
         this.FMC_Effect.play();
         this.FMC_Flash.play();
      }
      
      protected function UpdateUIAchievement() : void
      {
         SResourcesCore.TexturesAchievementTitle.LoadAutoSecondary(this.FHD_JigSaw.TitleID,this.CallBack_PicArrive);
      }
      
      protected function CallBack_PicArrive(param1:Object, param2:TTexture, param3:int) : void
      {
         var _loc4_:TAnimationFrame = null;
         if(param3 == this.FHD_JigSaw.TitleID)
         {
            this.FTitleAnimationSequence = param2.GetAnimationSequenceByIndex(0);
            _loc4_ = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0);
            this.FBM_Achievement.y = (TITLE_HEIGHT - _loc4_.Bounds.Height) / 2;
         }
      }
      
      protected function UpdateAchievementTitle() : void
      {
         if(this.FTitleAnimationSequence != null)
         {
            this.FBM_Achievement.bitmapData = this.FTitleAnimationSequence.GetAnimationFrameByTick(this.FTimeStore).Surface;
            this.FTimeStore += CONST_COMMON.SIZE_FrameRatePerSecond;
         }
      }
      
      protected function SetAwardDayStatus(param1:uint, param2:int) : void
      {
         switch(param2)
         {
            case Activity_CanReceive:
               this.FMC_FunctionBar[CONST_ACTIVITY.RESOURCE_Link_MC_Fun + param1]["MC_AlreadyGet"].visible = false;
               break;
            case Activity_CanNotReceive:
               this.FMC_FunctionBar[CONST_ACTIVITY.RESOURCE_Link_MC_Fun + param1]["MC_AlreadyGet"].visible = false;
               break;
            case Activity_AlreadyReceive:
               this.FMC_Jigsaw.gotoAndStop(this.CurIndex + 2);
               this.FMC_Progress.gotoAndStop(this.CurIndex + 2);
               this.FMC_FunctionBar[CONST_ACTIVITY.RESOURCE_Link_MC_Fun + param1]["MC_AlreadyGet"].visible = true;
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
         this.FBM_Achievement.bitmapData = null;
         this.FMC_Flash.stop();
         _loc2_ = int(this.FAwardListVect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FAwardListVect[_loc1_].Clear();
            _loc1_++;
         }
         this.FMC_Effect.stop();
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         super.BtnCloseOnClick(param1,param2);
         if(FOnBtnCloseClick != null)
         {
            FOnBtnCloseClick(this);
         }
      }
      
      protected function OnDescOnOver(param1:MouseEvent) : void
      {
         FHint.Caption = this.FHD_JigSaw.Desc;
         if(FOnHintOver != null)
         {
            FOnHintOver(this,FHint);
         }
      }
      
      protected function OnDescOut(param1:MouseEvent) : void
      {
         if(FOnHintOut != null)
         {
            FOnHintOut(this,FHint);
         }
      }
      
      public function get OnScoreShop() : Function
      {
         return this.FOnScoreShop;
      }
      
      public function set OnScoreShop(param1:Function) : void
      {
         this.FOnScoreShop = param1;
      }
   }
}

