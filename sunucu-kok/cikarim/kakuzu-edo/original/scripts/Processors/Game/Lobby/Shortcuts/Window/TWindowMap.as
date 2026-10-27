package Processors.Game.Lobby.Shortcuts.Window
{
   import Components.Shortcuts.*;
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Sound.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import LocalStorages.*;
   import Logics.*;
   import Logics.AntiAddiction.*;
   import Processors.Game.Common.Effects.Display.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.text.*;
   import ghostcat.operation.*;
   import ghostcat.util.easing.*;
   
   public class TWindowMap extends TUIComponent
   {
      
      protected static const POSITION_Map:uint = CONST_SHORTCUTS.POSITION_Map;
      
      protected static const MAP_TYPE:Vector.<uint> = CONST_SHORTCUTS.TYPE_MAPS;
      
      protected static const CAPACITY_MovieClip:uint = 3;
      
      protected static const CAPACITY_Maps:uint = CONST_SHORTCUTS.CAPACITY_Maps;
      
      protected static const TYPE_Map:uint = CONST_SHORTCUTS.TYPE_Map;
      
      protected static const TYPE_ReturnHome:uint = CONST_SHORTCUTS.TYPE_ReturnHome;
      
      protected static const TYPE_Map_Friend:uint = CONST_SHORTCUTS.TYPE_Map_Friend;
      
      protected static const INDEX_DisplayRole:uint = 0;
      
      protected static const INDEX_SoundEffectMute:uint = 1;
      
      protected static const INDEX_SoundMute:uint = 2;
      
      protected var FAntiAddiction:TAntiAddiction;
      
      protected var FRepeatOper:RepeatOper;
      
      protected var FTweenOperIn:TweenOper;
      
      protected var FTweenOperOut:TweenOper;
      
      protected var FMCEnterMap:Sprite;
      
      protected var FMCReturnHome:Sprite;
      
      protected var FBtn_EnterMap:SimpleButton;
      
      protected var FBtn_ReturnHome:SimpleButton;
      
      protected var FButtonsEnter:Vector.<SimpleButton>;
      
      protected var FMovieClipsEnter:Vector.<MovieClip>;
      
      protected var FButtonsReturn:Vector.<SimpleButton>;
      
      protected var FMovieClipsReturn:Vector.<MovieClip>;
      
      protected var FMC_EExpandGroup:Sprite;
      
      protected var FBtn_EMail:SimpleButton;
      
      protected var FBtn_EQuest:SimpleButton;
      
      protected var FBtn_EFriend:SimpleButton;
      
      protected var FBtn_ESystem:SimpleButton;
      
      protected var FMC_ESwitchDisplay:MovieClip;
      
      protected var FMC_ESwitchSoundEffect:MovieClip;
      
      protected var FMC_ESwitchSound:MovieClip;
      
      protected var FBtn_ECDK:SimpleButton;
      
      protected var FMC_RExpandGroup:Sprite;
      
      protected var FBtn_RMail:SimpleButton;
      
      protected var FBtn_RQuest:SimpleButton;
      
      protected var FBtn_RFriend:SimpleButton;
      
      protected var FBtn_RSystem:SimpleButton;
      
      protected var FMC_RSwitchDisplay:MovieClip;
      
      protected var FMC_RSwitchSoundEffect:MovieClip;
      
      protected var FMC_RSwitchSound:MovieClip;
      
      protected var FBtn_RCDK:SimpleButton;
      
      protected var FHintBtn:THint;
      
      protected var FShortcutCapacity:int;
      
      protected var FIsExpand:Boolean;
      
      protected var FIsDisplayRole:Boolean;
      
      protected var FIsSoundMute:Boolean;
      
      protected var FIsSoundEffectMute:Boolean;
      
      protected var FIsInitialization:Boolean;
      
      protected var FEffectBaseGlowEnterMap:TEffectBaseGlow;
      
      protected var FEffectBaseGlowReturnHome:TEffectBaseGlow;
      
      protected var FWidth:int;
      
      protected var FBT_Show:TUIButton;
      
      protected var FBT_Hide:TUIButton;
      
      protected var FMC_BlueEffect:MovieClip;
      
      protected var FMC_ShowPlay:Sprite;
      
      protected var FMC_HidePlay:Sprite;
      
      protected var FMC_ShowToHide:MovieClip;
      
      protected var FMC_HideToShow:MovieClip;
      
      protected var FNeedShrinkEffect:Boolean;
      
      protected var FOnWorldMap:Function;
      
      protected var FOnReturnHome:Function;
      
      protected var FOnViewRaiders:Function;
      
      protected var FOnMail:Function;
      
      protected var FOnQuest:Function;
      
      protected var FOnFriend:Function;
      
      protected var FOnSwitchDisplay:Function;
      
      protected var FHintOnMove:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FOffestWidth:int;
      
      protected var FOnHideIcon:Function;
      
      protected var FOnShowIcon:Function;
      
      public function TWindowMap(param1:TUIComponent)
      {
         super(param1);
         this.FAntiAddiction = SLogicsCore.AntiAddiction;
         this.FHintBtn = new THint();
         this.FButtonsEnter = new Vector.<SimpleButton>(CAPACITY_Maps);
         this.FMovieClipsEnter = new Vector.<MovieClip>(CAPACITY_MovieClip);
         this.FButtonsReturn = new Vector.<SimpleButton>(CAPACITY_Maps);
         this.FMovieClipsReturn = new Vector.<MovieClip>(CAPACITY_MovieClip);
         this.FWidth = 0;
         this.FShortcutCapacity = MAP_TYPE.length;
         this.ConstructTween();
         this.FIsDisplayRole = true;
         this.FIsSoundMute = false;
         this.FIsSoundEffectMute = false;
         this.FIsInitialization = false;
         this.FNeedShrinkEffect = false;
      }
      
      protected function ConstructTween() : void
      {
         this.FRepeatOper = new RepeatOper();
         this.FTweenOperIn = new TweenOper();
         this.FTweenOperOut = new TweenOper();
         this.FTweenOperIn.duration = 250;
         this.FTweenOperIn.params = {
            "alpha":1,
            "y":42,
            "ease":Cubic.easeInOut
         };
         this.FTweenOperOut.duration = 350;
         this.FTweenOperOut.params = {
            "alpha":1,
            "y":102,
            "ease":Cubic.easeInOut
         };
         this.FRepeatOper.loop = 1;
         this.FRepeatOper.children = [this.FTweenOperIn,this.FTweenOperOut];
      }
      
      protected function Resources_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:Sprite = null;
         this.FMCEnterMap = TUtilityReflection.CreateDisplayObjectInstance(CONST_SHORTCUTS.RESOURCE_ClassName_EnterMap) as Sprite;
         addChild(this.FMCEnterMap);
         this.FMCEnterMap.visible = false;
         this.FBtn_EnterMap = this.FMCEnterMap[CONST_SHORTCUTS.RESOURCE_Link_Btn_EnterMap];
         this.FBtn_EMail = this.FMCEnterMap[CONST_SHORTCUTS.RESOURCE_Link_Btn_Mail];
         this.FBtn_EQuest = this.FMCEnterMap[CONST_SHORTCUTS.RESOURCE_Link_Btn_Quest];
         this.FBtn_EFriend = this.FMCEnterMap[CONST_SHORTCUTS.RESOURCE_Link_Btn_Friend];
         this.FBtn_ESystem = this.FMCEnterMap[CONST_SHORTCUTS.RESOURCE_Link_Btn_System];
         _loc4_ = this.FMCEnterMap[CONST_SHORTCUTS.RESOURCE_Link_MC_Shrink];
         this.FMC_BlueEffect = _loc4_[CONST_SHORTCUTS.RESOURCE_Link_MC_BlueEffect];
         this.FMC_BlueEffect.stop();
         this.FMC_BlueEffect.visible = false;
         this.FMC_ShowPlay = _loc4_[CONST_SHORTCUTS.RESOURCE_Link_MC_ShowPlay];
         this.FMC_ShowToHide = this.FMC_ShowPlay[CONST_SHORTCUTS.RESOURCE_Link_MC_ShowToHide];
         this.FMC_ShowPlay.visible = false;
         this.FBT_Show = new TUIButton();
         this.FBT_Show.Substrate = _loc4_[CONST_SHORTCUTS.RESOURCE_Link_BT_Show];
         this.FBT_Show.OnClick = this.ProcessorShowOnClick;
         this.FBT_Show.Visible = false;
         this.FMC_HidePlay = _loc4_[CONST_SHORTCUTS.RESOURCE_Link_MC_HidePlay];
         this.FMC_HideToShow = this.FMC_HidePlay[CONST_SHORTCUTS.RESOURCE_Link_MC_HideToShow];
         this.FMC_HidePlay.visible = false;
         this.FBT_Hide = new TUIButton();
         this.FBT_Hide.Substrate = _loc4_[CONST_SHORTCUTS.RESOURCE_Link_BT_Hide];
         this.FBT_Hide.OnClick = this.ProcessorHideOnClick;
         this.FButtonsEnter[0] = this.FBtn_EnterMap;
         this.FButtonsEnter[1] = this.FBtn_EMail;
         this.FButtonsEnter[2] = this.FBtn_EQuest;
         this.FButtonsEnter[3] = this.FBtn_EFriend;
         this.FButtonsEnter[4] = this.FBtn_ESystem;
         this.FMC_EExpandGroup = this.FMCEnterMap[CONST_SHORTCUTS.RESOURCE_Link_MC_ExpandGroup];
         this.FMC_ESwitchDisplay = this.FMC_EExpandGroup[CONST_SHORTCUTS.RESOURCE_Link_Btn_SwitchDisplay];
         this.FMC_ESwitchSoundEffect = this.FMC_EExpandGroup[CONST_SHORTCUTS.RESOURCE_Link_Btn_SwitchSoundEffect];
         this.FMC_ESwitchSound = this.FMC_EExpandGroup[CONST_SHORTCUTS.RESOURCE_Link_Btn_SwitchSound];
         this.FMC_EExpandGroup.y = 42;
         this.FMovieClipsEnter[0] = this.FMC_ESwitchDisplay;
         this.FMovieClipsEnter[1] = this.FMC_ESwitchSoundEffect;
         this.FMovieClipsEnter[2] = this.FMC_ESwitchSound;
         this.FMCReturnHome = TUtilityReflection.CreateDisplayObjectInstance(CONST_SHORTCUTS.RESOURCE_ClassName_ReturnHome) as Sprite;
         addChild(this.FMCReturnHome);
         this.FMCReturnHome.visible = false;
         this.FBtn_ReturnHome = this.FMCReturnHome[CONST_SHORTCUTS.RESOURCE_Link_Btn_ReturnHome];
         this.FBtn_RMail = this.FMCReturnHome[CONST_SHORTCUTS.RESOURCE_Link_Btn_Mail];
         this.FBtn_RQuest = this.FMCReturnHome[CONST_SHORTCUTS.RESOURCE_Link_Btn_Quest];
         this.FBtn_RFriend = this.FMCReturnHome[CONST_SHORTCUTS.RESOURCE_Link_Btn_Friend];
         this.FBtn_RSystem = this.FMCReturnHome[CONST_SHORTCUTS.RESOURCE_Link_Btn_System];
         this.FButtonsReturn[0] = this.FBtn_EnterMap;
         this.FButtonsReturn[1] = this.FBtn_RMail;
         this.FButtonsReturn[2] = this.FBtn_RQuest;
         this.FButtonsReturn[3] = this.FBtn_RFriend;
         this.FButtonsReturn[4] = this.FBtn_RSystem;
         this.FMC_RExpandGroup = this.FMCReturnHome[CONST_SHORTCUTS.RESOURCE_Link_MC_ExpandGroup];
         this.FMC_RSwitchDisplay = this.FMC_RExpandGroup[CONST_SHORTCUTS.RESOURCE_Link_Btn_SwitchDisplay];
         this.FMC_RSwitchSoundEffect = this.FMC_RExpandGroup[CONST_SHORTCUTS.RESOURCE_Link_Btn_SwitchSoundEffect];
         this.FMC_RSwitchSound = this.FMC_RExpandGroup[CONST_SHORTCUTS.RESOURCE_Link_Btn_SwitchSound];
         this.FMC_RExpandGroup.y = 42;
         this.FMovieClipsReturn[0] = this.FMC_RSwitchDisplay;
         this.FMovieClipsReturn[1] = this.FMC_RSwitchSoundEffect;
         this.FMovieClipsReturn[2] = this.FMC_RSwitchSound;
         this.FTweenOperIn.target = this.FMC_EExpandGroup;
         this.FTweenOperOut.target = this.FMC_EExpandGroup;
         SLogicsCore.SignalPost(CONST_SIGNAL.SIGNALDESTINATION_LobbyTutorial,CONST_FRESHGUIDE.ObjectID_Component,POSITION_Map * 10000 + TYPE_Map_Friend,this.FBtn_EFriend);
         SLogicsCore.SignalPost(CONST_SIGNAL.SIGNALDESTINATION_LobbyTutorial,CONST_FRESHGUIDE.ObjectID_ArrowParent,POSITION_Map * 10000 + TYPE_Map_Friend,FParent);
      }
      
      protected function Resources_UILocations() : void
      {
         this.FBtn_EnterMap.addEventListener(MouseEvent.CLICK,this.BtnEnterMapOnClick,false,0,true);
         this.FBtn_ReturnHome.addEventListener(MouseEvent.CLICK,this.BtnReturnHomeOnClick,false,0,true);
         this.FBtn_EMail.addEventListener(MouseEvent.CLICK,this.BtnMailOnClick,false,0,true);
         this.FBtn_EMail.addEventListener(MouseEvent.MOUSE_MOVE,this.BtnOnOver,false,0,true);
         this.FBtn_EMail.addEventListener(MouseEvent.MOUSE_OUT,this.BtnOnOut,false,0,true);
         this.FBtn_EQuest.addEventListener(MouseEvent.CLICK,this.BtnQuestOnClick,false,0,true);
         this.FBtn_EQuest.addEventListener(MouseEvent.MOUSE_MOVE,this.BtnOnOver,false,0,true);
         this.FBtn_EQuest.addEventListener(MouseEvent.MOUSE_OUT,this.BtnOnOut,false,0,true);
         this.FBtn_EFriend.addEventListener(MouseEvent.CLICK,this.BtnFriendOnClick,false,0,true);
         this.FBtn_EFriend.addEventListener(MouseEvent.MOUSE_MOVE,this.BtnOnOver,false,0,true);
         this.FBtn_EFriend.addEventListener(MouseEvent.MOUSE_OUT,this.BtnOnOut,false,0,true);
         this.FBtn_ESystem.addEventListener(MouseEvent.CLICK,this.BtnSystemOnClick,false,0,true);
         this.FBtn_ESystem.addEventListener(MouseEvent.MOUSE_MOVE,this.BtnOnOver,false,0,true);
         this.FBtn_ESystem.addEventListener(MouseEvent.MOUSE_OUT,this.BtnOnOut,false,0,true);
         this.FMC_ESwitchSoundEffect.addEventListener(MouseEvent.CLICK,this.BtnSwitchSoundEffectOnClick,false,0,true);
         this.FMC_ESwitchSoundEffect.addEventListener(MouseEvent.MOUSE_MOVE,this.BtnOnOver,false,0,true);
         this.FMC_ESwitchSoundEffect.addEventListener(MouseEvent.MOUSE_OUT,this.BtnOnOut,false,0,true);
         this.FMC_ESwitchSound.addEventListener(MouseEvent.CLICK,this.BtnSwitchSoundOnClick,false,0,true);
         this.FMC_ESwitchSound.addEventListener(MouseEvent.MOUSE_MOVE,this.BtnOnOver,false,0,true);
         this.FMC_ESwitchSound.addEventListener(MouseEvent.MOUSE_OUT,this.BtnOnOut,false,0,true);
         this.FMC_ESwitchDisplay.addEventListener(MouseEvent.CLICK,this.BtnSwitchDisplayOnClick,false,0,true);
         this.FMC_ESwitchDisplay.addEventListener(MouseEvent.MOUSE_MOVE,this.BtnOnOver,false,0,true);
         this.FMC_ESwitchDisplay.addEventListener(MouseEvent.MOUSE_OUT,this.BtnOnOut,false,0,true);
         this.FBtn_RMail.addEventListener(MouseEvent.CLICK,this.BtnMailOnClick,false,0,true);
         this.FBtn_RMail.addEventListener(MouseEvent.MOUSE_MOVE,this.BtnOnOver,false,0,true);
         this.FBtn_RMail.addEventListener(MouseEvent.MOUSE_OUT,this.BtnOnOut,false,0,true);
         this.FBtn_RQuest.addEventListener(MouseEvent.CLICK,this.BtnQuestOnClick,false,0,true);
         this.FBtn_RQuest.addEventListener(MouseEvent.MOUSE_MOVE,this.BtnOnOver,false,0,true);
         this.FBtn_RQuest.addEventListener(MouseEvent.MOUSE_OUT,this.BtnOnOut,false,0,true);
         this.FBtn_RFriend.addEventListener(MouseEvent.CLICK,this.BtnFriendOnClick,false,0,true);
         this.FBtn_RFriend.addEventListener(MouseEvent.MOUSE_MOVE,this.BtnOnOver,false,0,true);
         this.FBtn_RFriend.addEventListener(MouseEvent.MOUSE_OUT,this.BtnOnOut,false,0,true);
         this.FBtn_RSystem.addEventListener(MouseEvent.CLICK,this.BtnSystemOnClick,false,0,true);
         this.FBtn_RSystem.addEventListener(MouseEvent.MOUSE_MOVE,this.BtnOnOver,false,0,true);
         this.FBtn_RSystem.addEventListener(MouseEvent.MOUSE_OUT,this.BtnOnOut,false,0,true);
         this.FMC_RSwitchDisplay.addEventListener(MouseEvent.CLICK,this.BtnSwitchDisplayOnClick,false,0,true);
         this.FMC_RSwitchDisplay.addEventListener(MouseEvent.MOUSE_MOVE,this.BtnOnOver,false,0,true);
         this.FMC_RSwitchDisplay.addEventListener(MouseEvent.MOUSE_OUT,this.BtnOnOut,false,0,true);
         this.FMC_RSwitchSoundEffect.addEventListener(MouseEvent.CLICK,this.BtnSwitchSoundEffectOnClick,false,0,true);
         this.FMC_RSwitchSoundEffect.addEventListener(MouseEvent.MOUSE_MOVE,this.BtnOnOver,false,0,true);
         this.FMC_RSwitchSoundEffect.addEventListener(MouseEvent.MOUSE_OUT,this.BtnOnOut,false,0,true);
         this.FMC_RSwitchSound.addEventListener(MouseEvent.CLICK,this.BtnSwitchSoundOnClick,false,0,true);
         this.FMC_RSwitchSound.addEventListener(MouseEvent.MOUSE_MOVE,this.BtnOnOver,false,0,true);
         this.FMC_RSwitchSound.addEventListener(MouseEvent.MOUSE_OUT,this.BtnOnOut,false,0,true);
         this.FIsInitialization = true;
      }
      
      protected function UpdateBounds() : void
      {
         if(!this.FIsInitialization)
         {
            return;
         }
         if(this.FMCEnterMap.visible)
         {
            this.FOffestWidth = 0;
            this.FWidth = this.FMCEnterMap.width;
         }
         else if(this.FMCReturnHome.visible)
         {
            this.FOffestWidth = 0;
            this.FWidth = this.FMCReturnHome.width;
         }
         else
         {
            this.FWidth = 0;
         }
      }
      
      protected function UpdateEffectsGlow() : void
      {
         if(this.FEffectBaseGlowEnterMap != null && this.FEffectBaseGlowEnterMap.IsRunOver)
         {
            this.FEffectBaseGlowEnterMap.Run();
         }
         if(this.FEffectBaseGlowReturnHome != null && this.FEffectBaseGlowReturnHome.IsRunOver)
         {
            this.FEffectBaseGlowReturnHome.Run();
         }
      }
      
      protected function ProcessorShortcutShowEffect(param1:uint, param2:Boolean) : void
      {
         if(param2)
         {
            this.OpenButtonEffect(param1);
         }
         else
         {
            this.TerminationButtonEffect(param1);
         }
      }
      
      protected function OpenButtonEffect(param1:int) : void
      {
         if(this.FEffectBaseGlowEnterMap == null)
         {
            this.FEffectBaseGlowEnterMap = new TEffectBaseGlow();
            if(!this.FEffectBaseGlowEnterMap.IsRunOver)
            {
               this.FEffectBaseGlowEnterMap.SetParameters(this.FBtn_EMail,16724787,1);
               this.FEffectBaseGlowEnterMap.Run();
            }
         }
         if(this.FEffectBaseGlowReturnHome == null)
         {
            this.FEffectBaseGlowReturnHome = new TEffectBaseGlow();
            if(!this.FEffectBaseGlowReturnHome.IsRunOver)
            {
               this.FEffectBaseGlowReturnHome.SetParameters(this.FBtn_RMail,16724787,1);
               this.FEffectBaseGlowReturnHome.Run();
            }
         }
      }
      
      protected function TerminationButtonEffect(param1:int) : void
      {
         var _loc2_:SimpleButton = null;
         _loc2_ = this.FButtonsEnter[param1];
         if(_loc2_ != null)
         {
            if(this.FEffectBaseGlowEnterMap != null)
            {
               if(_loc2_ == this.FEffectBaseGlowEnterMap.Source)
               {
                  this.FEffectBaseGlowEnterMap.Stop();
                  this.FEffectBaseGlowEnterMap.Dispose();
                  this.FEffectBaseGlowEnterMap = null;
               }
            }
         }
         _loc2_ = this.FButtonsReturn[param1];
         if(_loc2_ != null)
         {
            if(this.FEffectBaseGlowReturnHome != null)
            {
               if(_loc2_ == this.FEffectBaseGlowReturnHome.Source)
               {
                  this.FEffectBaseGlowReturnHome.Stop();
                  this.FEffectBaseGlowReturnHome.Dispose();
                  this.FEffectBaseGlowReturnHome = null;
               }
            }
         }
      }
      
      protected function ProcessorShowOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnShowIcon != null)
         {
            this.FOnShowIcon(this);
         }
         this.FMC_ShowPlay.visible = true;
         this.FMC_ShowToHide.gotoAndPlay(2);
      }
      
      protected function ProcessorHideOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnHideIcon != null)
         {
            this.FOnHideIcon(this);
         }
         this.FMC_HidePlay.visible = true;
         this.FMC_HideToShow.gotoAndPlay(2);
      }
      
      protected function BtnEnterMapOnClick(param1:MouseEvent) : void
      {
         var _loc2_:SimpleButton = null;
         _loc2_ = param1.currentTarget as SimpleButton;
         if(this.FOnWorldMap != null)
         {
            this.FOnWorldMap(this);
         }
      }
      
      protected function BtnReturnHomeOnClick(param1:MouseEvent) : void
      {
         if(this.FOnReturnHome != null)
         {
            this.FOnReturnHome(this);
         }
      }
      
      protected function BtnViewRaidersOnClick(param1:MouseEvent) : void
      {
         if(this.FOnViewRaiders != null)
         {
            this.FOnViewRaiders(this);
         }
      }
      
      protected function BtnMailOnClick(param1:MouseEvent) : void
      {
         if(this.FOnMail != null)
         {
            this.FOnMail(this);
         }
      }
      
      protected function BtnQuestOnClick(param1:MouseEvent) : void
      {
         if(this.FOnQuest != null)
         {
            this.FOnQuest(this);
         }
      }
      
      protected function BtnFriendOnClick(param1:MouseEvent) : void
      {
         SLogicsCore.SinalPostFreshGuide(POSITION_Map * 10000 + TYPE_Map_Friend);
         if(this.FOnFriend != null)
         {
            this.FOnFriend(this);
         }
      }
      
      protected function BtnSystemOnClick(param1:MouseEvent) : void
      {
         var _loc2_:SimpleButton = null;
         if(param1 != null && param1.target is SimpleButton)
         {
            _loc2_ = param1.target as SimpleButton;
         }
         switch(_loc2_)
         {
            case this.FBtn_ESystem:
               this.FTweenOperIn.target = this.FMC_EExpandGroup;
               this.FTweenOperOut.target = this.FMC_EExpandGroup;
               break;
            case this.FBtn_RSystem:
               this.FTweenOperIn.target = this.FMC_RExpandGroup;
               this.FTweenOperOut.target = this.FMC_RExpandGroup;
         }
         if(this.FIsExpand)
         {
            this.FRepeatOper.children = [this.FTweenOperOut,this.FTweenOperIn];
         }
         else
         {
            this.FMC_EExpandGroup.y = 42;
            this.FRepeatOper.children = [this.FTweenOperIn,this.FTweenOperOut];
         }
         this.FIsExpand = !this.FIsExpand;
         this.FRepeatOper.execute();
         this.BtnOnOut(null);
      }
      
      protected function BtnSwitchSoundEffectOnClick(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Boolean = false;
         _loc2_ = 3 - this.FMC_ESwitchSoundEffect.currentFrame;
         this.FMC_ESwitchSoundEffect.gotoAndStop(_loc2_);
         this.FMC_RSwitchSoundEffect.gotoAndStop(_loc2_);
         _loc3_ = !SSoundPlayer.Mute;
         SSoundPlayer.Mute = _loc3_;
         this.FIsSoundEffectMute = _loc3_;
         SLogicsCore.AntiAddiction.SoundEffectMute = _loc3_;
         SLocalStoragelCore.Flush(SLocalStoragelCore.StoragelPath,SLogicsCore.AntiAddiction.Data);
         this.BtnSystemOnClick(null);
      }
      
      protected function BtnSwitchSoundOnClick(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Boolean = false;
         _loc2_ = 3 - this.FMC_ESwitchSound.currentFrame;
         this.FMC_ESwitchSound.gotoAndStop(_loc2_);
         this.FMC_RSwitchSound.gotoAndStop(_loc2_);
         _loc3_ = !SMusicPlayer.Mute;
         SMusicPlayer.Mute = _loc3_;
         this.FIsSoundMute = _loc3_;
         SLogicsCore.AntiAddiction.SoundMute = _loc3_;
         SLocalStoragelCore.Flush(SLocalStoragelCore.StoragelPath,SLogicsCore.AntiAddiction.Data);
         this.BtnSystemOnClick(null);
      }
      
      protected function BtnSwitchDisplayOnClick(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:uint = 0;
         _loc2_ = !this.FIsDisplayRole;
         if(_loc2_)
         {
            _loc3_ = 1;
         }
         else
         {
            _loc3_ = 2;
         }
         this.FMC_ESwitchDisplay.gotoAndStop(_loc3_);
         this.FMC_RSwitchDisplay.gotoAndStop(_loc3_);
         if(this.FOnSwitchDisplay != null)
         {
            this.FOnSwitchDisplay(this,_loc2_);
         }
         this.BtnSystemOnClick(null);
         this.FIsDisplayRole = _loc2_;
      }
      
      protected function BtnOnOver(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:SimpleButton = null;
         var _loc4_:MovieClip = null;
         var _loc5_:Vector.<String> = null;
         var _loc6_:Vector.<String> = null;
         var _loc7_:Vector.<String> = null;
         if(param1 == null)
         {
            return;
         }
         _loc5_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_21);
         _loc6_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_22);
         if(param1.currentTarget is SimpleButton)
         {
            _loc3_ = param1.currentTarget as SimpleButton;
            _loc2_ = this.FButtonsEnter.indexOf(_loc3_);
            if(_loc2_ < 0)
            {
               _loc2_ = this.FButtonsReturn.indexOf(_loc3_);
            }
            _loc7_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_20);
         }
         else if(param1.currentTarget is MovieClip)
         {
            _loc4_ = param1.currentTarget as MovieClip;
            _loc2_ = this.FMovieClipsEnter.indexOf(_loc4_);
            if(_loc2_ < 0)
            {
               _loc2_ = this.FMovieClipsReturn.indexOf(_loc4_);
            }
            switch(_loc2_)
            {
               case INDEX_DisplayRole:
                  if(this.FIsDisplayRole)
                  {
                     _loc7_ = _loc6_;
                  }
                  else
                  {
                     _loc7_ = _loc5_;
                  }
                  break;
               case INDEX_SoundEffectMute:
                  if(this.FIsSoundEffectMute)
                  {
                     _loc7_ = _loc5_;
                  }
                  else
                  {
                     _loc7_ = _loc6_;
                  }
                  break;
               case INDEX_SoundMute:
                  if(this.FIsSoundMute)
                  {
                     _loc7_ = _loc5_;
                  }
                  else
                  {
                     _loc7_ = _loc6_;
                  }
            }
         }
         this.FHintBtn.Caption = _loc7_[_loc2_];
         if(this.FHintOnMove != null)
         {
            this.FHintOnMove(this,this.FHintBtn);
         }
      }
      
      protected function BtnOnOut(param1:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHintBtn);
         }
      }
      
      public function get ShortcutWidth() : int
      {
         this.UpdateBounds();
         return this.FWidth;
      }
      
      public function get IsMainScene() : Boolean
      {
         if(!this.FIsInitialization)
         {
            return false;
         }
         return this.FMCEnterMap.visible;
      }
      
      public function get OffestWidth() : int
      {
         return this.FOffestWidth;
      }
      
      public function get OnWorldMap() : Function
      {
         return this.FOnWorldMap;
      }
      
      public function set OnWorldMap(param1:Function) : void
      {
         this.FOnWorldMap = param1;
      }
      
      public function get OnReturnHome() : Function
      {
         return this.FOnReturnHome;
      }
      
      public function set OnReturnHome(param1:Function) : void
      {
         this.FOnReturnHome = param1;
      }
      
      public function get OnViewRaiders() : Function
      {
         return this.FOnViewRaiders;
      }
      
      public function set OnViewRaiders(param1:Function) : void
      {
         this.FOnViewRaiders = param1;
      }
      
      public function get OnMail() : Function
      {
         return this.FOnMail;
      }
      
      public function set OnMail(param1:Function) : void
      {
         this.FOnMail = param1;
      }
      
      public function get OnQuest() : Function
      {
         return this.FOnQuest;
      }
      
      public function set OnQuest(param1:Function) : void
      {
         this.FOnQuest = param1;
      }
      
      public function get OnFriend() : Function
      {
         return this.FOnFriend;
      }
      
      public function set OnFriend(param1:Function) : void
      {
         this.FOnFriend = param1;
      }
      
      public function get OnSwitchDisplay() : Function
      {
         return this.FOnSwitchDisplay;
      }
      
      public function set OnSwitchDisplay(param1:Function) : void
      {
         this.FOnSwitchDisplay = param1;
      }
      
      public function get HintOnMove() : Function
      {
         return this.FHintOnMove;
      }
      
      public function set HintOnMove(param1:Function) : void
      {
         this.FHintOnMove = param1;
      }
      
      public function get HintOnOut() : Function
      {
         return this.FHintOnOut;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function get OnHideIcon() : Function
      {
         return this.FOnHideIcon;
      }
      
      public function set OnHideIcon(param1:Function) : void
      {
         this.FOnHideIcon = param1;
      }
      
      public function get OnShowIcon() : Function
      {
         return this.FOnShowIcon;
      }
      
      public function set OnShowIcon(param1:Function) : void
      {
         this.FOnShowIcon = param1;
      }
      
      public function Perform_UIDispatch() : void
      {
         this.Resources_UIDispatch();
         this.Resources_UILocations();
      }
      
      public function InitSystemSetup() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:uint = 0;
         var _loc3_:Boolean = false;
         _loc3_ = Boolean(SLogicsCore.AntiAddiction.SoundEffectMute);
         if(_loc3_)
         {
            this.FMC_ESwitchSoundEffect.gotoAndStop(2);
            this.FMC_RSwitchSoundEffect.gotoAndStop(2);
            SSoundPlayer.Mute = _loc3_;
         }
         this.FIsSoundEffectMute = _loc3_;
         _loc3_ = Boolean(SLogicsCore.AntiAddiction.SoundMute);
         if(_loc3_)
         {
            this.FMC_ESwitchSound.gotoAndStop(2);
            this.FMC_RSwitchSound.gotoAndStop(2);
            SMusicPlayer.Mute = _loc3_;
         }
         this.FIsSoundMute = _loc3_;
      }
      
      public function Update() : void
      {
         this.UpdateEffectsGlow();
         if(!this.Visible)
         {
            return;
         }
         if(this.FMC_ShowToHide.currentFrame == this.FMC_ShowToHide.totalFrames)
         {
            this.FMC_ShowToHide.gotoAndStop(1);
            this.FMC_HidePlay.visible = false;
            this.FMC_ShowPlay.visible = false;
            this.FBT_Hide.Visible = true;
            this.FBT_Show.Visible = false;
         }
         if(this.FMC_HideToShow.currentFrame == this.FMC_HideToShow.totalFrames)
         {
            this.FMC_HideToShow.gotoAndStop(1);
            this.FMC_HidePlay.visible = false;
            this.FMC_ShowPlay.visible = false;
            this.FBT_Hide.Visible = false;
            this.FBT_Show.Visible = true;
         }
      }
      
      public function ShowEffectNotification(param1:uint, param2:Boolean) : void
      {
         this.ProcessorShortcutShowEffect(param1,param2);
      }
      
      public function SetShrinkEffect(param1:Boolean) : void
      {
         if(this.FNeedShrinkEffect != param1)
         {
            if(param1)
            {
               this.FMC_BlueEffect.play();
               this.FMC_BlueEffect.visible = true;
            }
            else
            {
               this.FMC_BlueEffect.stop();
               this.FMC_BlueEffect.visible = false;
            }
            this.FNeedShrinkEffect = param1;
         }
      }
      
      public function SetupShortcutsShow(param1:int, param2:int) : void
      {
         if(!this.FIsInitialization)
         {
            return;
         }
         switch(param2)
         {
            case TYPE_Map:
               this.FMCEnterMap.visible = true;
               break;
            case TYPE_ReturnHome:
               this.FMCReturnHome.visible = true;
         }
         if(this.FIsExpand)
         {
            this.BtnSystemOnClick(null);
         }
      }
      
      public function HideAllShortcuts() : void
      {
         if(!this.FIsInitialization)
         {
            return;
         }
         this.FMCEnterMap.visible = false;
         this.FMCReturnHome.visible = false;
         if(this.FIsExpand)
         {
            this.BtnSystemOnClick(null);
         }
      }
   }
}

