package Processors.Game.Lobby.Protagonist
{
   import Foundation.Common.Integer.*;
   import Foundation.Common.TBounds;
   import Foundation.Common.THint;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TAnimationFrame;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.Military.*;
   import Processors.Game.Common.Effects.Display.TEffectBaseGlowTwo;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.TacticalDeployment.Components.TDeploymentTip;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowProtagonist extends TProcessorLobbyWindow
   {
      
      protected static const ATTRIBUTE_NUM:int = 6;
      
      protected static const MILITARYVIEW_WIDTH:int = 611;
      
      protected static const MILITARYVIEW_HEIGHT:int = 466;
      
      protected static const TYPE_Avatar_Military:uint = CONST_SHORTCUTS.TYPE_Avatar_Military;
      
      protected static const QUALITYCOLOR_INDEX:Vector.<uint> = CONST_COMMON.QUALITYCOLOR_INDEX;
      
      public static const FFilterColor:int = 16777113;
      
      public static const FilterGlowWidth:int = 4;
      
      public static const FilterGlowStrength:int = 20;
      
      protected var FHelpTips:THint;
      
      protected var FTF_Level:TextField;
      
      protected var FTF_Name:TextField;
      
      protected var FMC_JobName:MovieClip;
      
      protected var FTF_EXP:TextField;
      
      protected var FTF_Organize:TextField;
      
      protected var FTF_Country:TextField;
      
      protected var FTF_BattlePower:TextField;
      
      protected var FSHeroHead:Sprite;
      
      protected var FBmpHeroHead:Bitmap;
      
      protected var FHeroHeadId:uint;
      
      protected var FMC_HeroHead:MovieClip;
      
      protected var FMC_ProgressBarExp:Sprite;
      
      protected var FTF_Prestige:TextField;
      
      protected var FCurrentPrestige:uint;
      
      protected var FTF_SiliverCoin:TextField;
      
      protected var FTF_Spirit:TextField;
      
      protected var FTF_MilitaryName:TextField;
      
      protected var FBTN_GetSalary:MovieClip;
      
      protected var FBTN_MilitaryList:MovieClip;
      
      protected var FBTN_Close:SimpleButton;
      
      protected var FBTN_Infor:SimpleButton;
      
      protected var FBattlePowerAnimation:MovieClip;
      
      protected var FPendantLeft:MovieClip;
      
      protected var FPendantRight:MovieClip;
      
      protected var FMC_Friends:Vector.<MovieClip>;
      
      protected var FTF_FriendsLevel:Vector.<TextField>;
      
      protected var FTF_FriendsName:Vector.<TextField>;
      
      protected var FMC_FriendsMilitary:Vector.<MovieClip>;
      
      protected var FMC_FriendsIconMountPoint:Vector.<MovieClip>;
      
      protected var FMC_FriendsBitMap:Vector.<Bitmap>;
      
      protected var FNeedUpdateFriend:Boolean;
      
      protected var FMilitaryView:TMilitaryView;
      
      protected var FBoundsMilitary:TBounds;
      
      protected var FUIDispatchRoutines:Vector.<Function>;
      
      protected var FUILocationRoutines:Vector.<Function>;
      
      protected var FHint_Prestige:THint;
      
      protected var FHint_Salary:THint;
      
      protected var FHint_Job:THint;
      
      protected var FJobDescriptionID:uint;
      
      protected var MountedFriend:THeros;
      
      protected var FHeroInfoTip:TDeploymentTip;
      
      protected var FGlowsFilter:TEffectBaseGlowTwo;
      
      protected var FUpgradeGlowsFilter:TEffectBaseGlowTwo;
      
      protected var FOnGetIncome:Function;
      
      protected var FOnUpgradeMilitary:Function;
      
      protected var FMilitaryData:TMilitaryData;
      
      protected var FOnMilitaryListClick:Function;
      
      protected var FHintOnOver:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FOnHelpTipsOver:Function;
      
      protected var FOnHelpTipsOut:Function;
      
      protected var FCanUpgrade:Boolean;
      
      protected var FOnCloseList:Function;
      
      public function TProcessorWindowProtagonist(param1:TUIComponent)
      {
         super(param1);
         this.FHelpTips = new THint();
         this.FGlowsFilter = new TEffectBaseGlowTwo();
         this.FUpgradeGlowsFilter = new TEffectBaseGlowTwo();
         this.FMilitaryView = new TMilitaryView(param1);
         this.FMilitaryView.OnBack = this.BackBtnClickInMilitaryView;
         this.FMilitaryView.OnCloseList = this.OnCloseClickList;
         this.FBmpHeroHead = new Bitmap();
         this.FMilitaryView.x = (CONST_COMMON.STAGE_Width - MILITARYVIEW_WIDTH) / 2;
         this.FMilitaryView.y = (CONST_COMMON.STAGE_Height - MILITARYVIEW_HEIGHT) / 2;
         this.ConstructDispath();
         this.ConstructLocation();
      }
      
      protected function ConstructDispath() : void
      {
         this.FUIDispatchRoutines = new Vector.<Function>();
         this.FUIDispatchRoutines.push(this.DispatchUIOtherModuleInfor);
         this.FUIDispatchRoutines.push(this.DispatchUINetWork);
         this.FUIDispatchRoutines.push(this.DispatchUISalary);
         this.FUIDispatchRoutines.push(this.DispatchUIBtns);
         this.FUIDispatchRoutines.push(this.DispatchUIFriends);
      }
      
      protected function ConstructLocation() : void
      {
         this.FUILocationRoutines = new Vector.<Function>();
         this.FUILocationRoutines.push(this.LocationOtherModuleInfor);
         this.FUILocationRoutines.push(this.LocationNetWork);
         this.FUILocationRoutines.push(this.LocationSalary);
         this.FUILocationRoutines.push(this.LocationBtns);
         this.FUILocationRoutines.push(this.LocationFriends);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_PROTAGONIST.RESOURCESID_Swf_Protagonist);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Function = null;
         var _loc3_:MovieClip = null;
         _loc3_ = TUtilityReflection.CreateDisplayObjectInstance("MC_Protagonist") as MovieClip;
         addChild(_loc3_);
         _loc1_ = 0;
         while(_loc1_ < this.FUIDispatchRoutines.length)
         {
            _loc2_ = this.FUIDispatchRoutines[_loc1_];
            _loc2_(_loc3_);
            _loc1_++;
         }
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Function = null;
         _loc1_ = 0;
         while(_loc1_ < this.FUIDispatchRoutines.length)
         {
            _loc2_ = this.FUILocationRoutines[_loc1_];
            _loc2_();
            _loc1_++;
         }
         super.ResourcesPerform_UILocations();
      }
      
      public function Location() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Function = null;
         _loc1_ = 0;
         while(_loc1_ < this.FUIDispatchRoutines.length)
         {
            _loc2_ = this.FUILocationRoutines[_loc1_];
            _loc2_();
            _loc1_++;
         }
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         this.UpdateFriendsPic();
         if(this.FBTN_GetSalary != null)
         {
            if(this.FBTN_GetSalary.currentFrameLabel == "Enable")
            {
               this.FGlowsFilter.Run();
            }
            else if(this.FBTN_GetSalary.currentFrameLabel == "Disable")
            {
               this.FGlowsFilter.Stop();
            }
         }
         if(this.FBTN_MilitaryList != null)
         {
            if(this.FCanUpgrade)
            {
               this.FUpgradeGlowsFilter.Run();
            }
            else
            {
               this.FUpgradeGlowsFilter.Stop();
            }
         }
         if(this.FHeroInfoTip != null && this.FHeroInfoTip.visible == true)
         {
            this.FHeroInfoTip.UpdataBitmap();
         }
      }
      
      protected function GetHeroHeadPic(param1:int) : BitmapData
      {
         var _loc2_:TAnimationFrame = null;
         var _loc3_:TAnimationSequence = null;
         var _loc4_:TTexture = null;
         if(_loc4_ == null)
         {
            _loc4_ = SResourcesCore.TexturesHeadIcon.GetTextureByIdentifier(param1);
         }
         if(_loc4_ != null)
         {
            _loc3_ = _loc4_.GetAnimationSequenceByIndex(0);
            if(_loc3_ != null)
            {
               _loc2_ = _loc3_.GetAnimationFrameByTick(0);
               if(_loc2_ != null)
               {
                  return _loc2_.Surface;
               }
            }
         }
         else
         {
            SResourcesCore.TexturesHeadIcon.LoadSecondary(param1);
         }
         return null;
      }
      
      protected function DispatchUIOtherModuleInfor(param1:MovieClip) : void
      {
         var _loc2_:MovieClip = null;
         this.FTF_Name = param1["TF_Name"];
         this.FMC_JobName = param1["MC_JobName"];
         this.FTF_Organize = param1["TF_Organize"];
         this.FTF_Country = param1["TF_Country"];
         this.FSHeroHead = param1["S_HeroHeadPic"];
         this.FSHeroHead.addChild(this.FBmpHeroHead);
         this.FMC_HeroHead = param1["MC_EffectBG"];
         _loc2_ = param1["BattlePower"];
         this.FTF_BattlePower = _loc2_["TF_BattlePower"];
         this.FTF_Level = param1["TF_Level"];
         _loc2_ = param1["RoleExperience"];
         this.FMC_ProgressBarExp = _loc2_["BarExp"];
         _loc2_ = _loc2_["RoleExperienceInner"];
         this.FTF_EXP = _loc2_["TF_EXP"];
         this.FHint_Job = new THint();
      }
      
      protected function LocationOtherModuleInfor() : void
      {
         this.FHint_Job.Caption = TUtilityLobby.GetStringByIdentifier(SLogicsCore.Character.Profession - 1 + CONST_SYSTEMLANGUAGE.Protagonist_STRING_10);
         this.FMC_JobName.addEventListener(MouseEvent.MOUSE_MOVE,this.OnJobNameMouseMove);
         this.FMC_JobName.addEventListener(MouseEvent.MOUSE_OUT,this.OnJobNameMouseOut);
      }
      
      protected function UpdateOtherModule() : void
      {
         var _loc1_:THero = null;
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         this.FTF_Level.text = this.FMilitaryData.Level.toString();
         this.FTF_Name.text = this.FMilitaryData.RoleName;
         _loc2_ = this.GetFrameIDJobID(this.FMilitaryData.JobID);
         this.FMC_JobName.gotoAndStop(_loc2_);
         this.FMC_HeroHead.gotoAndStop(_loc2_);
         this.FTF_EXP.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Protagonist_STRING_1),this.FMilitaryData.Experience.ToString(),this.FMilitaryData.UpgradeNeedExperience.ToString());
         this.FTF_Organize.text = this.FMilitaryData.OrganizationName;
         this.FTF_Country.text = this.FMilitaryData.CountryName;
         this.FTF_BattlePower.text = this.FMilitaryData.BattleValue.toString();
         _loc1_ = SLogicsCore.Character.Heros.GetHeroByIndex(0);
         this.FHeroHeadId = _loc1_.Identifier;
         SResourcesCore.TexturesMiddlePic.LoadAutoSecondary(this.FHeroHeadId,this.AutoLoadCallBack);
         _loc3_ = this.FMilitaryData.Experience.ToNumber() / this.FMilitaryData.UpgradeNeedExperience.ToNumber();
         if(_loc3_ > 1)
         {
            _loc3_ = 1;
         }
         this.FMC_ProgressBarExp.scaleX = _loc3_;
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         var _loc5_:BitmapData = null;
         switch(param3)
         {
            case this.FHeroHeadId:
               _loc4_ = param2.GetAnimationSequenceByIndex(0);
               _loc5_ = _loc4_.GetAnimationFrameByIndex(0).Surface;
               this.FBmpHeroHead.bitmapData = _loc5_;
         }
      }
      
      protected function GetFrameIDByHeroID(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc3_:Vector.<int> = null;
         var _loc4_:Vector.<int> = null;
         _loc3_ = CONST_PROTAGONIST.HeroTemplateID;
         _loc4_ = CONST_PROTAGONIST.HeroHeadFrameID;
         _loc2_ = 0;
         while(_loc2_ < _loc3_.length)
         {
            if(_loc3_[_loc2_] == param1)
            {
               return _loc4_[_loc2_];
            }
            _loc2_++;
         }
         return 1;
      }
      
      protected function GetFrameIDJobID(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc3_:Vector.<int> = null;
         var _loc4_:Vector.<int> = null;
         _loc4_ = CONST_PROTAGONIST.HeroJobId;
         _loc3_ = CONST_PROTAGONIST.HeroJobFrames;
         _loc2_ = 0;
         while(_loc2_ < _loc3_.length)
         {
            if(_loc4_[_loc2_] == param1)
            {
               return _loc3_[_loc2_];
            }
            _loc2_++;
         }
         return 0;
      }
      
      protected function OnJobNameMouseMove(param1:MouseEvent) : void
      {
         if(this.FHintOnOver != null)
         {
            this.FHintOnOver(this,this.FHint_Job);
         }
      }
      
      protected function OnJobNameMouseOut(param1:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHint_Job);
         }
      }
      
      protected function DispatchUINetWork(param1:MovieClip) : void
      {
         this.FTF_Prestige = param1["TF_Prestige"];
         this.FTF_Prestige.addEventListener(MouseEvent.MOUSE_MOVE,this.PrestigeOnMouseMove);
         this.FTF_Prestige.addEventListener(MouseEvent.MOUSE_OUT,this.PrestigeOnMouseOut);
      }
      
      protected function LocationNetWork() : void
      {
         this.FHint_Prestige = new THint();
         this.FHint_Prestige.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Protagonist_STRING_2);
         this.FHint_Salary = new THint();
         this.FHint_Salary.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Protagonist_STRING_3);
      }
      
      protected function UpdateNetWork() : void
      {
         this.FTF_Prestige.text = this.FMilitaryData.CurrentCredit.toString();
      }
      
      protected function DispatchUISalary(param1:MovieClip) : void
      {
         this.FTF_SiliverCoin = param1["TF_Silivercoin"];
         this.FTF_Spirit = param1["TF_Sprite"];
         this.FBTN_GetSalary = param1["MC_GetIncome"];
         this.FTF_MilitaryName = param1["MilitaryName"];
         this.FGlowsFilter.SetParameters(this.FBTN_GetSalary,FFilterColor,FilterGlowWidth,FilterGlowStrength);
      }
      
      protected function LocationSalary() : void
      {
         TUtilityStandardBTN.SetBtnEventListener(this.FBTN_GetSalary,this.OnGetIncomeBtnClick);
         this.FBTN_GetSalary.addEventListener(MouseEvent.MOUSE_MOVE,this.BtnSalaryOnMouseMove);
         this.FBTN_GetSalary.addEventListener(MouseEvent.MOUSE_OUT,this.BtnSalaryOnMouseOut);
         this.FBTN_GetSalary.buttonMode = true;
      }
      
      protected function UpdateSalary() : void
      {
         if(this.FMilitaryData.SalaryState)
         {
            this.FBTN_GetSalary.gotoAndStop("Enable");
         }
         else
         {
            this.FBTN_GetSalary.gotoAndStop("Disable");
         }
         this.UpdateSalaryValue();
      }
      
      protected function UpdateSalaryValue() : void
      {
         var _loc1_:TMilitaryLocalData = null;
         _loc1_ = this.GetMilitaryLocalInforByMilitaryRank(this.FMilitaryData.MilitaryRank);
         this.FTF_SiliverCoin.text = _loc1_.AnyMilitarySalarySilvercoin.toString();
         this.FTF_Spirit.text = _loc1_.AnyMilitarySalarySpirit.toString();
         this.FTF_MilitaryName.text = _loc1_.AnyMilitaryName;
      }
      
      protected function GetMilitaryLocalInforByMilitaryRank(param1:int) : TMilitaryLocalData
      {
         var _loc2_:int = 0;
         var _loc3_:TMilitaryLocalData = null;
         _loc2_ = param1 - CONST_PROTAGONIST.MilitaryInforMinID;
         return this.FMilitaryData.GetMilitaryInforByIndex(_loc2_);
      }
      
      protected function DispatchUIBtns(param1:MovieClip) : void
      {
         this.FBTN_MilitaryList = param1["MC_MilitaryList"];
         this.FUpgradeGlowsFilter.SetParameters(this.FBTN_MilitaryList,FFilterColor,FilterGlowWidth,FilterGlowStrength);
         this.FBTN_Close = param1["BTN_Close"];
         this.FBTN_Infor = param1["BTN_Infor"];
         this.FBattlePowerAnimation = param1["BattlePower"]["BattleRound"];
         this.FPendantLeft = param1["MC_PendantLeft"];
         this.FPendantRight = param1["MC_PendantRight"];
      }
      
      protected function LocationBtns() : void
      {
         this.FBTN_Close.addEventListener(MouseEvent.CLICK,this.OnCloseClick);
         this.FBTN_Infor.addEventListener(MouseEvent.MOUSE_MOVE,this.ButtonHelpOnOver,false,0,true);
         this.FBTN_Infor.addEventListener(MouseEvent.MOUSE_OUT,this.ButtonHelpOnOut,false,0,true);
         TUtilityStandardBTN.SetBtnEventListener(this.FBTN_MilitaryList,this.HandleOnMilitaryListClick);
         this.FBTN_MilitaryList.buttonMode = true;
      }
      
      protected function UpdateBtns() : void
      {
      }
      
      protected function PlayAnimation() : void
      {
         this.FBattlePowerAnimation.gotoAndPlay(1);
      }
      
      protected function StopAnimation() : void
      {
         this.FBattlePowerAnimation.gotoAndStop(1);
         this.FGlowsFilter.Stop();
         this.FUpgradeGlowsFilter.Stop();
      }
      
      protected function DispatchUIFriends(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         this.FMC_Friends = new Vector.<MovieClip>();
         this.FTF_FriendsLevel = new Vector.<TextField>();
         this.FTF_FriendsName = new Vector.<TextField>();
         this.FMC_FriendsIconMountPoint = new Vector.<MovieClip>();
         this.FMC_FriendsMilitary = new Vector.<MovieClip>();
         _loc2_ = 0;
         while(_loc2_ < CONST_PROTAGONIST.MAXFRIENDSNUM)
         {
            _loc3_ = param1["Friend_" + _loc2_];
            this.FMC_Friends.push(_loc3_);
            this.FTF_FriendsLevel.push(_loc3_["Level"]);
            this.FTF_FriendsName.push(_loc3_["RoleName"]);
            this.FMC_FriendsIconMountPoint.push(_loc3_["IconMountPoint"]);
            this.FMC_FriendsMilitary.push(_loc3_["Military"]);
            _loc2_++;
         }
         this.FHeroInfoTip = new TDeploymentTip(this.Parent);
         this.FHeroInfoTip.Visible = false;
         this.MountedFriend = new THeros();
      }
      
      protected function LocationFriends() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:Bitmap = null;
         _loc1_ = 0;
         while(_loc1_ < CONST_PROTAGONIST.MAXFRIENDSNUM)
         {
            _loc2_ = this.FMC_Friends[_loc1_];
            _loc2_.addEventListener(MouseEvent.MOUSE_MOVE,this.FriendsOnMouseOver);
            _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.FriendsOnMouseOut);
            _loc1_++;
         }
         this.FMC_FriendsBitMap = new Vector.<Bitmap>();
         _loc1_ = 0;
         while(_loc1_ < CONST_PROTAGONIST.MAXFRIENDSNUM)
         {
            _loc3_ = new Bitmap();
            this.FMC_FriendsIconMountPoint[_loc1_].addChild(_loc3_);
            this.FMC_FriendsBitMap.push(_loc3_);
            _loc1_++;
         }
      }
      
      protected function ShowHeroInfoTip(param1:THero) : void
      {
         this.FHeroInfoTip.Visible = true;
         this.FHeroInfoTip.SetHeroData(param1);
      }
      
      protected function HideHeroInfoTip() : void
      {
         this.FHeroInfoTip.Visible = false;
      }
      
      protected function UpdateFriendsInfor() : void
      {
         var _loc1_:THero = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         _loc4_ = int(SLogicsCore.Character.Heros.Count);
         _loc3_ = 0;
         this.MountedFriend.Clear();
         _loc2_ = 1;
         while(_loc2_ < _loc4_)
         {
            _loc1_ = SLogicsCore.Character.Heros.GetHeroByIndex(_loc2_);
            if(_loc1_.Mounted)
            {
               this.FMC_Friends[_loc3_].visible = true;
               this.FTF_FriendsLevel[_loc3_].text = "LV." + _loc1_.RebirthLevel.toString();
               this.FTF_FriendsLevel[_loc3_].textColor = QUALITYCOLOR_INDEX[_loc1_.Quality];
               this.FTF_FriendsName[_loc3_].text = _loc1_.Name;
               this.FTF_FriendsName[_loc3_].textColor = QUALITYCOLOR_INDEX[_loc1_.Quality];
               this.FMC_FriendsMilitary[_loc3_].gotoAndStop(_loc1_.StandPositionWithProfession);
               _loc3_++;
               this.MountedFriend.Add(_loc1_);
            }
            _loc2_++;
         }
         while(_loc3_ < CONST_PROTAGONIST.MAXFRIENDSNUM)
         {
            this.FMC_Friends[_loc3_].visible = false;
            _loc3_++;
         }
      }
      
      protected function UpdateFriendsPic() : void
      {
         var _loc1_:THero = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:BitmapData = null;
         if(visible == false)
         {
            return;
         }
         _loc3_ = 0;
         _loc4_ = int(SLogicsCore.Character.Heros.Count);
         _loc2_ = 1;
         while(_loc2_ < _loc4_)
         {
            _loc1_ = SLogicsCore.Character.Heros.GetHeroByIndex(_loc2_);
            if(_loc1_.Mounted)
            {
               if(this.FNeedUpdateFriend)
               {
                  _loc5_ = this.GetHeroHeadPic(_loc1_.SmallID);
                  if(_loc5_ != null)
                  {
                     this.FMC_FriendsBitMap[_loc3_].bitmapData = _loc5_;
                  }
                  else
                  {
                     this.FNeedUpdateFriend = true;
                  }
               }
               _loc3_++;
            }
            _loc2_++;
         }
      }
      
      protected function OnCloseClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
         this.visible = true;
         this.FMilitaryView.visible = false;
      }
      
      protected function ButtonHelpOnOver(param1:MouseEvent) : void
      {
         if(TUtilityString.Empty(this.FHelpTips.Content))
         {
            this.FHelpTips.Content = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELPTIPS_Hero);
         }
         if(this.FOnHelpTipsOver != null)
         {
            this.FOnHelpTipsOver(this,this.FHelpTips);
         }
      }
      
      protected function ButtonHelpOnOut(param1:MouseEvent) : void
      {
         if(this.FOnHelpTipsOut != null)
         {
            this.FOnHelpTipsOut(this,this.FHelpTips);
         }
      }
      
      protected function OnGetIncomeBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = param1.currentTarget as MovieClip;
         if(_loc2_.currentLabel != "Disable")
         {
            if(this.FOnGetIncome != null)
            {
               this.FOnGetIncome();
            }
            _loc2_.gotoAndStop("Disable");
            this.FMilitaryData.SalaryState = false;
         }
      }
      
      protected function HandleOnMilitaryListClick(param1:MouseEvent) : void
      {
         this.FMilitaryView.visible = true;
         this.visible = false;
         this.FMilitaryView.Update();
      }
      
      protected function BackBtnClickInMilitaryView() : void
      {
         this.FMilitaryView.visible = false;
         this.visible = true;
         this.Update();
      }
      
      private function OnCloseClickList() : void
      {
         if(this.FOnCloseList != null)
         {
            this.FOnCloseList();
         }
      }
      
      protected function PrestigeOnMouseMove(param1:MouseEvent) : void
      {
         if(this.FHintOnOver != null)
         {
            this.FHintOnOver(this,this.FHint_Prestige);
         }
      }
      
      protected function PrestigeOnMouseOut(param1:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHint_Prestige);
         }
      }
      
      protected function BtnSalaryOnMouseMove(param1:MouseEvent) : void
      {
         if(this.FHintOnOver != null)
         {
            this.FHintOnOver(this,this.FHint_Salary);
         }
      }
      
      protected function BtnSalaryOnMouseOut(param1:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHint_Salary);
         }
      }
      
      protected function FriendsOnMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         _loc2_ = param1.currentTarget as MovieClip;
         _loc2_.gotoAndStop(2);
         _loc3_ = this.FMC_Friends.indexOf(_loc2_);
         if(_loc3_ >= this.MountedFriend.Count)
         {
            return;
         }
         this.ShowHeroInfoTip(this.MountedFriend.GetHeroByIndex(_loc3_));
      }
      
      protected function FriendsOnMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = param1.currentTarget as MovieClip;
         _loc2_.gotoAndStop(1);
         this.HideHeroInfoTip();
      }
      
      public function set OnGetIncome(param1:Function) : void
      {
         this.FOnGetIncome = param1;
      }
      
      public function set OnUpgradeMilitary(param1:Function) : void
      {
         this.FOnUpgradeMilitary = param1;
         this.FMilitaryView.OnUpgradeMilitary = this.FOnUpgradeMilitary;
      }
      
      public function set CurrentPrestige(param1:uint) : void
      {
         this.FCurrentPrestige = param1;
      }
      
      public function set OnMilitaryListClick(param1:Function) : void
      {
         this.FOnMilitaryListClick = param1;
      }
      
      public function set MilitaryData(param1:TMilitaryData) : void
      {
         this.FMilitaryData = param1;
         this.FMilitaryView.MilitaryData = param1;
      }
      
      public function set HintOnOver(param1:Function) : void
      {
         this.FHintOnOver = param1;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function get OnHelpTipsOver() : Function
      {
         return this.FOnHelpTipsOver;
      }
      
      public function set OnHelpTipsOver(param1:Function) : void
      {
         this.FOnHelpTipsOver = param1;
      }
      
      public function get OnHelpTipsOut() : Function
      {
         return this.FOnHelpTipsOut;
      }
      
      public function set OnHelpTipsOut(param1:Function) : void
      {
         this.FOnHelpTipsOut = param1;
      }
      
      public function set CanUpgrade(param1:Boolean) : void
      {
         this.FCanUpgrade = param1;
      }
      
      public function get OnCloseList() : Function
      {
         return this.FOnCloseList;
      }
      
      public function set OnCloseList(param1:Function) : void
      {
         this.FOnCloseList = param1;
      }
      
      override public function Load() : void
      {
         super.Load();
         this.FMilitaryView.Load();
      }
      
      public function Show() : void
      {
         this.PlayAnimation();
      }
      
      public function Update() : void
      {
         if(this.FMilitaryData == null)
         {
            return;
         }
         this.FNeedUpdateFriend = true;
         this.UpdateOtherModule();
         this.UpdateSalary();
         this.UpdateNetWork();
         this.UpdateBtns();
         this.UpdateFriendsInfor();
         this.FMilitaryView.Update();
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.StopAnimation();
         _loc1_ = 0;
         while(_loc1_ < CONST_PROTAGONIST.MAXFRIENDSNUM)
         {
            this.FMC_FriendsBitMap[_loc1_].bitmapData = null;
            this.FNeedUpdateFriend = true;
            _loc1_++;
         }
         this.FBmpHeroHead.bitmapData = null;
         _loc2_ = int(this.FMC_FriendsBitMap.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_FriendsBitMap[_loc1_].bitmapData = null;
            _loc1_++;
         }
      }
      
      public function PerformPosition(param1:uint) : void
      {
         switch(param1)
         {
            case TYPE_Avatar_Military:
               this.HandleOnMilitaryListClick(null);
               break;
            default:
               this.BackBtnClickInMilitaryView();
         }
      }
   }
}

