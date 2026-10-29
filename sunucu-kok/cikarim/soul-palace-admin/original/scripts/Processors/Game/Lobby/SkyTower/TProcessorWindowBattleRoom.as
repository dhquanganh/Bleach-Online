package Processors.Game.Lobby.SkyTower
{
   import Components.Standard.*;
   import Externals.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.SkyTower.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Components.*;
   import Processors.Game.Lobby.SkyTower.Components.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorWindowBattleRoom extends TProcessorLobbyWindow
   {
      
      protected static const CAPACITY_Pvp_Roles:uint = CONST_SKYTOWER.CAPACITY_Pvp_Roles;
      
      protected static const MODE_SKYTOWER_PVE:uint = CONST_SKYTOWER.MODE_SKYTOWER_PVE;
      
      protected static const MODE_SKYTOWER_PVP:uint = CONST_SKYTOWER.MODE_SKYTOWER_PVP;
      
      protected var FSkyTower:TSkyTower;
      
      protected var FTower:TTower;
      
      protected var FHintPveAuto:THint;
      
      protected var FHintBuy:THint;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FSP_BattleRoom:Sprite;
      
      protected var FBtn_Close:TUIButton;
      
      protected var FTF_Title:TextField;
      
      protected var FUITabs:TUITab;
      
      protected var FSP_RoomPve:Sprite;
      
      protected var FSP_Pass:Sprite;
      
      protected var FTF_ProgressPve:TextField;
      
      protected var FTF_CountPve:TextField;
      
      protected var FBtn_BuyPve:TUIButton;
      
      protected var FBtn_AKeyPve:TUIButton;
      
      protected var FBtn_ViewReward:TUIButton;
      
      protected var FBtn_Pve:TUIButton;
      
      protected var FBtn_PveAuto:TUIButton;
      
      protected var FSP_Reward:Sprite;
      
      protected var FTF_Reward:TextField;
      
      protected var FMC_TowerIDs:MovieClip;
      
      protected var FUIPlayerSelfPve:TUIPlayer;
      
      protected var FUIPlayerEnemyPve:TUIPlayer;
      
      protected var FUIPlayerPveBak0:TUIPlayer;
      
      protected var FUIPlayerPveBak1:TUIPlayer;
      
      protected var FSP_RoomPvp:Sprite;
      
      protected var FTF_CountPvp:TextField;
      
      protected var FBtn_BuyPvp:TUIButton;
      
      protected var FBtn_ViewPvpDiary:TUIButton;
      
      protected var FSP_PvpDiary:Sprite;
      
      protected var FTF_PvpDiary:TextField;
      
      protected var FUIHeros:Vector.<TUIHero>;
      
      protected var FSP_LightBeams:Vector.<Sprite>;
      
      protected var FUIStates:Vector.<TUIState>;
      
      protected var FRolesModelID:Vector.<int>;
      
      protected var FTabIndex:int;
      
      protected var FInitialization:Boolean;
      
      protected var FOnOpenYeYi:Function;
      
      protected var FHintOnOver:Function;
      
      protected var FHintOnOut:Function;
      
      public function TProcessorWindowBattleRoom(param1:TUIComponent)
      {
         super(param1);
         this.FSkyTower = SLogicsCore.SkyTower;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_SKYTOWER.RESOURCESID_Swf_SkyTower);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:MovieClip = null;
         var _loc4_:TUIHero = null;
         var _loc5_:TUIState = null;
         var _loc6_:TBounds = null;
         var _loc7_:TCoordinate = null;
         this.FHintPveAuto = new THint();
         this.FHintBuy = new THint();
         this.FRolesModelID = new Vector.<int>();
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         this.FUIWindowConfirmation.OnOK = this.WindowConfirmationOnOK;
         this.FUIWindowConfirmation.SetCheckBoxUsable(false);
         this.FSP_BattleRoom = TUtilityReflection.CreateDisplayObjectInstance(CONST_SKYTOWER.RESOURCE_ClassName_SP_BattleRoom) as Sprite;
         addChild(this.FSP_BattleRoom);
         _loc2_ = this.FSP_BattleRoom[CONST_SKYTOWER.RESOURCE_Link_SP_Background];
         this.FBtn_Close = new TUIButton();
         this.FBtn_Close.Substrate = _loc2_[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtn_Close.OnClick = this.ButtonCloseOnClick;
         this.FTF_Title = _loc2_[CONST_SKYTOWER.RESOURCE_Link_TF_Title];
         this.FUITabs = new TUITab(null);
         _loc1_ = 0;
         while(_loc1_ < CONST_SKYTOWER.CAPACITY_Tabs)
         {
            _loc3_ = this.FSP_BattleRoom[CONST_SKYTOWER.RESOURCE_Link_Tab + _loc1_];
            (_loc3_.getChildAt(1) as TextField).mouseEnabled = false;
            this.FUITabs.SetTabByIndex(_loc3_,_loc1_);
            _loc1_++;
         }
         this.FUITabs.OnSwitch = this.TabsOnSwitch;
         this.FUITabs.Init();
         this.FSP_RoomPve = this.FSP_BattleRoom[CONST_SKYTOWER.RESOURCE_Link_SP_Room_Pve];
         this.FSP_Pass = this.FSP_RoomPve[CONST_SKYTOWER.RESOURCE_Link_SP_Pass];
         this.FTF_ProgressPve = this.FSP_RoomPve[CONST_SKYTOWER.RESOURCE_Link_TF_PveProgress];
         this.FTF_CountPve = this.FSP_RoomPve[CONST_SKYTOWER.RESOURCE_Link_TF_PveCount];
         this.FBtn_BuyPve = new TUIButton();
         this.FBtn_BuyPve.Substrate = this.FSP_RoomPve[CONST_SKYTOWER.RESOURCE_Link_Btn_BuyPve];
         this.FBtn_BuyPve.OnClick = this.Btn_BuyOnClick;
         this.FBtn_BuyPve.OnMove = this.Btn_BuyOnMove;
         this.FBtn_BuyPve.OnOut = this.Btn_BuyOnOut;
         this.FBtn_AKeyPve = new TUIButton();
         this.FBtn_AKeyPve.Substrate = this.FSP_RoomPve[CONST_SKYTOWER.RESOURCE_Link_Btn_AKeyPve];
         this.FBtn_AKeyPve.OnClick = this.Btn_AKeyPveOnClick;
         this.FBtn_ViewReward = new TUIButton();
         this.FBtn_ViewReward.Substrate = this.FSP_RoomPve[CONST_SKYTOWER.RESOURCE_Link_Btn_ViewReward];
         this.FBtn_ViewReward.OnClick = this.Btn_ViewRewardOnClick;
         this.FBtn_Pve = new TUIButton();
         this.FBtn_Pve.Substrate = this.FSP_RoomPve[CONST_SKYTOWER.RESOURCE_Link_Btn_Pve];
         this.FBtn_Pve.OnClick = this.Btn_PveOnClick;
         this.FBtn_PveAuto = new TUIButton();
         this.FBtn_PveAuto.Substrate = this.FSP_RoomPve[CONST_SKYTOWER.RESOURCE_Link_Btn_PveAuto];
         this.FBtn_PveAuto.OnClick = this.Btn_PveAutoOnClick;
         this.FBtn_PveAuto.OnMove = this.Btn_PveAutoOnMove;
         this.FBtn_PveAuto.OnOut = this.Btn_PveAutoOnOut;
         this.FSP_Reward = this.FSP_RoomPve[CONST_SKYTOWER.RESOURCE_Link_SP_Reward];
         this.FTF_Reward = this.FSP_Reward[CONST_SKYTOWER.RESOURCE_Link_TF_Reward];
         this.FMC_TowerIDs = this.FSP_RoomPve[CONST_SKYTOWER.RESOURCE_Link_MC_TowerIDs];
         _loc2_ = this.FSP_BattleRoom[CONST_SKYTOWER.RESOURCE_Link_SP_Room_Pve];
         this.FUIPlayerSelfPve = this.ConstructorUIPlayerPve(_loc2_,CONST_SKYTOWER.RESOURCE_Link_SP_Role_Self_Pve,CONST_SKYTOWER.TAG_SKYTOWER_SELF);
         this.FUIPlayerEnemyPve = this.ConstructorUIPlayerPve(_loc2_,CONST_SKYTOWER.RESOURCE_Link_SP_Role_Enemy_Pve,CONST_SKYTOWER.TAG_SKYTOWER_ENEMY);
         this.FUIPlayerPveBak0 = this.ConstructorUIPlayerPve(_loc2_,CONST_SKYTOWER.RESOURCE_Link_SP_Role_Pve_Bak_0,CONST_SKYTOWER.TAG_SKYTOWER_ENEMY);
         this.FUIPlayerPveBak1 = this.ConstructorUIPlayerPve(_loc2_,CONST_SKYTOWER.RESOURCE_Link_SP_Role_Pve_Bak_1,CONST_SKYTOWER.TAG_SKYTOWER_ENEMY);
         this.FSP_RoomPvp = this.FSP_BattleRoom[CONST_SKYTOWER.RESOURCE_Link_SP_Room_Pvp];
         this.FTF_CountPvp = this.FSP_RoomPvp[CONST_SKYTOWER.RESOURCE_Link_TF_PvpCount];
         this.FBtn_BuyPvp = new TUIButton();
         this.FBtn_BuyPvp.Substrate = this.FSP_RoomPvp[CONST_SKYTOWER.RESOURCE_Link_Btn_BuyPvp];
         this.FBtn_BuyPvp.OnClick = this.Btn_BuyOnClick;
         this.FBtn_BuyPvp.OnMove = this.Btn_BuyOnMove;
         this.FBtn_BuyPvp.OnOut = this.Btn_BuyOnOut;
         this.FBtn_ViewPvpDiary = new TUIButton();
         this.FBtn_ViewPvpDiary.Substrate = this.FSP_RoomPvp[CONST_SKYTOWER.RESOURCE_Link_Btn_ViewPvpDiary];
         this.FBtn_ViewPvpDiary.OnClick = this.Btn_ViewPvpDiaryOnClick;
         this.FSP_PvpDiary = this.FSP_RoomPvp[CONST_SKYTOWER.RESOURCE_Link_SP_PvpDiary];
         this.FTF_PvpDiary = this.FSP_PvpDiary[CONST_SKYTOWER.RESOURCE_Link_TF_PvpDiary];
         this.FTF_PvpDiary.addEventListener(TextEvent.LINK,this.TF_PvpDiaryOnCLick,false,0,true);
         this.FUIHeros = new Vector.<TUIHero>(CAPACITY_Pvp_Roles);
         this.FSP_LightBeams = new Vector.<Sprite>(CAPACITY_Pvp_Roles);
         this.FUIStates = new Vector.<TUIState>(CAPACITY_Pvp_Roles);
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Pvp_Roles)
         {
            _loc2_ = this.FSP_RoomPvp[CONST_SKYTOWER.RESOURCE_Link_SP_Role + _loc1_];
            _loc2_.mouseEnabled = false;
            _loc2_.mouseChildren = false;
            _loc2_ = _loc2_[CONST_SKYTOWER.RESOURCE_Link_SP_MountPoint];
            _loc4_ = new TUIHero(this);
            _loc2_.addChild(_loc4_);
            _loc4_.OnQuerySequenceContext = this.PvpHeroOnQuerySequenceContext;
            _loc4_.SequenceDefaultRole = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCEID_Textures_DefaultRole,0);
            _loc6_ = new TBounds();
            _loc7_ = new TCoordinate();
            _loc4_.SequenceDefaultRole.Evaluate(_loc7_,_loc6_);
            _loc4_.X = _loc6_.X;
            _loc4_.Y = _loc6_.Y;
            this.FUIHeros[_loc1_] = _loc4_;
            _loc2_ = this.FSP_RoomPvp[CONST_SKYTOWER.RESOURCE_Link_SP_LightBeams];
            _loc2_.mouseChildren = false;
            _loc2_.mouseEnabled = false;
            this.FSP_LightBeams[_loc1_] = _loc2_[CONST_SKYTOWER.RESOURCE_Link_SP_LightBeam + _loc1_];
            _loc5_ = new TUIState(null);
            _loc5_.Resource = this.FSP_RoomPvp[CONST_SKYTOWER.RESOURCE_Link_SP_RoleState + _loc1_];
            _loc5_.OnChallenge = this.UIStateOnChallenge;
            _loc5_.OnOccupy = this.UIStateOnOccupy;
            _loc5_.OnReceiving = this.UIStateOnReceiving;
            _loc5_.OnEffectText = this.UIStateOnEffectText;
            _loc5_.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc5_.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            _loc5_.Perform_UIDispatch();
            this.FUIStates[_loc1_] = _loc5_;
            _loc1_++;
         }
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FInitialization = true;
         this.Reset();
         super.ResourcesPerform_UILocations();
      }
      
      protected function ConstructorUIPlayerPve(param1:Sprite, param2:String, param3:uint) : TUIPlayer
      {
         var _loc4_:TUIPlayer = null;
         _loc4_ = new TUIPlayer(null);
         _loc4_.Resource = param1[param2];
         _loc4_.OnQuerySequenceContext = this.HeroOnQuerySequenceContext;
         _loc4_.SequenceDefaultRole = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCEID_Textures_DefaultRole,0);
         _loc4_.Tag = param3;
         _loc4_.Perform_UIDispatch();
         return _loc4_;
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         super.LogicsPerform();
         if(this.Visible)
         {
            if(this.FInitialization)
            {
               if(this.FSP_RoomPve.visible)
               {
                  this.FUIPlayerSelfPve.Update();
                  this.FUIPlayerEnemyPve.Update();
                  this.FUIPlayerPveBak0.Update();
                  this.FUIPlayerPveBak1.Update();
               }
               if(this.FSP_RoomPvp.visible)
               {
                  _loc1_ = 0;
                  while(_loc1_ < CAPACITY_Pvp_Roles)
                  {
                     this.FUIHeros[_loc1_].Update();
                     this.FUIStates[_loc1_].Update();
                     _loc1_++;
                  }
               }
            }
         }
      }
      
      protected function PvpHeroOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TUIHero = null;
         var _loc6_:TBounds = null;
         var _loc7_:TCoordinate = null;
         this.HeroOnQuerySequenceContext(param1,param2,param3,param4);
         if(param3.Value != null)
         {
            _loc5_ = param1 as TUIHero;
            _loc6_ = new TBounds();
            _loc7_ = new TCoordinate();
            param3.Value.Evaluate(_loc7_,_loc6_);
            _loc5_.X = _loc6_.X;
            _loc5_.Y = _loc6_.Y;
         }
      }
      
      protected function HeroOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TLayer = null;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         var _loc8_:TRoleModel = null;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         _loc5_ = param2 as TLayer;
         _loc6_ = SResourcesCore.TexturesModel;
         if(this.FSkyTower.SelectMode == MODE_SKYTOWER_PVE)
         {
            _loc10_ = _loc5_.PveRoleTempleteID;
         }
         else if(this.FSkyTower.SelectMode == MODE_SKYTOWER_PVP)
         {
            _loc10_ = _loc5_.PvpRoleTempleteID;
         }
         if(_loc10_ == 0)
         {
            return;
         }
         _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,_loc10_) as TRoleModel;
         _loc9_ = CONST_ROLE.GetModelIDByIndex(_loc8_.Model,CONST_ROLE.ROLE_SEQUENCEINDEX_Showcase);
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc9_);
         if(_loc7_ != null)
         {
            param3.Value = _loc7_.GetAnimationSequenceByIndex(0);
         }
         else
         {
            _loc6_.LoadSecondary(_loc9_);
         }
         this.SetRoleModelID(_loc9_);
      }
      
      protected function SetRoleModelID(param1:uint) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FRolesModelID.indexOf(param1);
         if(_loc2_ < 0)
         {
            this.FRolesModelID.push(param1);
         }
      }
      
      protected function ProcessorUpdateCommon() : void
      {
         this.FTF_Title.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_05),this.FTower.Name);
         if(this.FSkyTower.SelectMode == MODE_SKYTOWER_PVP)
         {
            this.FTabIndex = MODE_SKYTOWER_PVP - 1;
         }
         else
         {
            this.FTabIndex = MODE_SKYTOWER_PVE - 1;
         }
         this.FUITabs.SwithTagManual(this.FTabIndex);
      }
      
      protected function ProcessorUpdateUIPve() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TTowers = null;
         var _loc8_:TTower = null;
         var _loc9_:TLayer = null;
         var _loc10_:TLayers = null;
         var _loc11_:String = null;
         var _loc12_:Array = null;
         _loc7_ = this.FSkyTower.Towers;
         _loc6_ = _loc7_.Count;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc8_ = _loc7_.GetTowerByIndex(_loc5_);
            if(_loc8_.Identifier == this.FTower.Identifier)
            {
               break;
            }
            _loc5_++;
         }
         _loc10_ = this.FTower.Layers;
         _loc4_ = _loc10_.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc9_ = _loc10_.GetLayerByIndex(_loc3_);
            if(!_loc9_.IsClear)
            {
               _loc3_++;
               break;
            }
            _loc3_++;
         }
         this.FSkyTower.SelectLayerID = _loc9_.Identifier;
         this.FTF_ProgressPve.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_03),_loc3_,_loc4_);
         this.ProcessorUpdateButtonBuy();
         this.FMC_TowerIDs.gotoAndStop(this.FTower.Tag);
         this.FBtn_PveAuto.Enabled = Boolean(_loc3_ < _loc10_.MaxLayer && _loc3_ < this.FTower.Layers.Count);
         this.FBtn_Pve.Enabled = false;
         if(_loc3_ <= _loc4_)
         {
            if(this.FSkyTower.PveMax + this.FSkyTower.PVEBuyCount - this.FSkyTower.PVECount > 0)
            {
               this.FBtn_Pve.Enabled = true;
            }
         }
         if(_loc9_.IsClear)
         {
            this.FBtn_Pve.Enabled = false;
            this.FSP_Pass.visible = true;
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_18));
         }
         if(!SLogicsCore.Character.VipData.AKeyBableTower)
         {
            this.FBtn_PveAuto.Enabled = false;
         }
         _loc11_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_07)[_loc5_];
         _loc12_ = _loc11_.split("#");
         _loc11_ = "";
         _loc2_ = int(_loc12_.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc1_ != 0)
            {
               _loc11_ += "\n";
            }
            _loc11_ += String(_loc12_[_loc1_]);
            _loc1_++;
         }
         this.FTF_Reward.text = _loc11_;
         this.FUIPlayerSelfPve.Context = _loc9_;
         if(!_loc9_.IsClear)
         {
            this.FUIPlayerEnemyPve.Context = _loc9_;
         }
         if(_loc3_ <= _loc4_ - 2)
         {
            _loc9_ = _loc10_.GetLayerByIndex(_loc3_);
            this.FUIPlayerPveBak1.Context = _loc9_;
            this.FUIPlayerPveBak1.HideRoleTitle();
            _loc3_++;
         }
         if(_loc3_ <= _loc4_ - 1)
         {
            _loc9_ = _loc10_.GetLayerByIndex(_loc3_);
            this.FUIPlayerPveBak0.Context = _loc9_;
            this.FUIPlayerPveBak0.HideRoleTitle();
         }
      }
      
      protected function ProcessorUpdateUIPvp() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TLayer = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         this.ProcessorUpdateButtonBuy();
         _loc2_ = this.FTower.Layers.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FTower.Layers.GetLayerByIndex(_loc1_);
            if(_loc3_.IsPvpMode)
            {
               _loc4_ = CAPACITY_Pvp_Roles - _loc5_ - 1;
               this.FUIHeros[_loc4_].Context = null;
               this.FUIHeros[_loc4_].Visible = false;
               this.FUIStates[_loc4_].Context = null;
               this.FUIStates[_loc4_].Tag = 0;
               this.FSP_LightBeams[_loc4_].visible = false;
               if(_loc3_.PvpRoleHighID == SLogicsCore.Character.Identifier0 && _loc3_.PvpRoleLowID == SLogicsCore.Character.Identifier1)
               {
                  this.FUIHeros[_loc4_].Context = _loc3_;
                  this.FUIHeros[_loc4_].Visible = true;
                  _loc6_ = true;
                  this.FUIStates[_loc4_].Tag = CONST_SKYTOWER.TAG_SKYTOWER_SELF;
               }
               else if(_loc3_.PvpRoleHighID != 0 || _loc3_.PvpRoleLowID != 0)
               {
                  this.FUIHeros[_loc4_].Context = _loc3_;
                  this.FUIHeros[_loc4_].Visible = true;
                  _loc6_ = false;
                  this.FUIStates[_loc4_].Tag = CONST_SKYTOWER.TAG_SKYTOWER_ENEMY;
               }
               else
               {
                  _loc6_ = false;
                  this.FUIStates[_loc4_].Tag = CONST_SKYTOWER.TAG_SKYTOWER_NONE;
               }
               this.FSP_LightBeams[_loc4_].visible = _loc6_;
               this.FUIStates[_loc4_].Context = _loc3_;
               _loc5_++;
            }
            _loc1_++;
         }
         this.ProcessorUpdatePvpDiarys();
      }
      
      protected function ProcessorUpdatePvpDiarys() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TPvpDiary = null;
         this.FTF_PvpDiary.htmlText = "";
         _loc2_ = this.FSkyTower.PvpDiarys.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FSkyTower.PvpDiarys.GetPvpDiaryByIndex(_loc1_);
            this.FTF_PvpDiary.htmlText += this.MakeHtmlTextInfo(_loc3_);
            _loc1_++;
         }
      }
      
      protected function MakeHtmlTextInfo(param1:TPvpDiary) : String
      {
         var _loc2_:String = null;
         _loc2_ = "";
         if(param1.IsInitiativeFight)
         {
            _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_21);
         }
         else
         {
            _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_20);
         }
         if(param1.IsWin)
         {
            _loc2_ += TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_22);
         }
         else
         {
            _loc2_ += TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_23);
         }
         return TUtilityString.Format(_loc2_,CONST_POST.EVENT_TYPE_EVENT,param1.BattleReportID,param1.Nickname);
      }
      
      protected function ProcessorChallengeReq(param1:uint, param2:uint, param3:uint, param4:uint) : void
      {
         var _loc5_:TPacket = null;
         var _loc6_:ByteArray = null;
         var _loc7_:uint = 0;
         _loc5_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_SkyTower_Challenge_Req);
         _loc6_ = _loc5_.Data;
         _loc6_.writeByte(param1);
         _loc6_.writeByte(param2);
         _loc6_.writeUnsignedInt(param3);
         _loc6_.writeUnsignedInt(param4);
         SNetworkCore.Transceiver.PacketTransmit(_loc5_);
      }
      
      protected function ProcessorUpdateButtonBuy() : void
      {
         if(this.FSkyTower.SelectMode == MODE_SKYTOWER_PVE)
         {
            this.FTF_CountPve.text = (this.FSkyTower.PveMax + this.FSkyTower.PVEBuyCount - this.FSkyTower.PVECount).toString();
            this.FBtn_BuyPve.Enabled = Boolean(this.FSkyTower.PveMax + this.FSkyTower.PVEBuyCount - this.FSkyTower.PVECount <= 0);
         }
         else if(this.FSkyTower.SelectMode == MODE_SKYTOWER_PVP)
         {
            this.FTF_CountPvp.text = (this.FSkyTower.PvpMax + this.FSkyTower.PVPBuyCount - this.FSkyTower.PVPCount).toString();
            this.FBtn_BuyPvp.Enabled = Boolean(this.FSkyTower.PvpMax + this.FSkyTower.PVPBuyCount - this.FSkyTower.PVPCount <= 0);
         }
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
         this.X = (_loc1_ - this.Width) / 2 + 50;
         this.Y = (_loc2_ - this.Height) / 2;
      }
      
      protected function ButtonCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function TabsOnSwitch(param1:Object) : void
      {
         this.FTabIndex = param1 as int;
         if(this.FTabIndex == 0)
         {
            this.FSkyTower.SelectMode = MODE_SKYTOWER_PVE;
            this.UpdateUIPve();
            this.FSP_RoomPve.visible = true;
            this.FSP_RoomPvp.visible = false;
         }
         else
         {
            this.FSkyTower.SelectMode = MODE_SKYTOWER_PVP;
            this.UpdateUIPvp();
            this.FSP_RoomPve.visible = false;
            this.FSP_RoomPvp.visible = true;
         }
      }
      
      protected function WindowConfirmationOnOK(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         var _loc4_:uint = 0;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_SkyTower_BuyChallengeCount_Req);
         _loc3_ = _loc2_.Data;
         if(this.FSkyTower.SelectMode == MODE_SKYTOWER_PVE)
         {
            _loc4_ = MODE_SKYTOWER_PVE;
         }
         else
         {
            _loc4_ = MODE_SKYTOWER_PVP;
         }
         _loc3_.writeByte(_loc4_);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function Btn_BuyOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         var _loc5_:TConfigValue = null;
         var _loc6_:Vector.<uint> = null;
         var _loc7_:uint = 0;
         if(this.FSkyTower.SelectMode == MODE_SKYTOWER_PVE)
         {
            _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.SkyTower_BuyPvePrice) as TConfigValue;
            _loc6_ = _loc5_.Value as Vector.<uint>;
            _loc7_ = this.FSkyTower.PVEBuyCount;
            _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_16);
         }
         else if(this.FSkyTower.SelectMode == MODE_SKYTOWER_PVP)
         {
            _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.SkyTower_BuyPvpPrice) as TConfigValue;
            _loc6_ = _loc5_.Value as Vector.<uint>;
            _loc7_ = this.FSkyTower.PVPBuyCount;
            _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_17);
         }
         if(_loc7_ >= _loc6_.length)
         {
            return;
         }
         _loc4_ = _loc6_[_loc7_];
         this.FUIWindowConfirmation.Text = TUtilityString.Format(_loc3_,_loc4_);
         this.FUIWindowConfirmation.Visible = true;
      }
      
      protected function Btn_BuyOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:String = null;
         _loc3_ = "";
         if(this.FSkyTower.SelectMode == MODE_SKYTOWER_PVE)
         {
            if(this.FSkyTower.PVEBuyMax - this.FSkyTower.PVEBuyCount > 0)
            {
               _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_27);
            }
            else
            {
               _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_28);
            }
         }
         else if(this.FSkyTower.SelectMode == MODE_SKYTOWER_PVP)
         {
            if(this.FSkyTower.PVPBuyMax - this.FSkyTower.PVPBuyCount > 0)
            {
               _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_27);
            }
            else
            {
               _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_28);
            }
         }
         if(TUtilityString.Empty(this.FHintBuy.Caption))
         {
            this.FHintBuy.Caption = _loc3_;
         }
         if(this.FHintOnOver != null)
         {
            this.FHintOnOver(this,this.FHintBuy);
         }
      }
      
      protected function Btn_BuyOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHintBuy);
            this.FHintBuy.Caption = "";
         }
      }
      
      protected function Btn_AKeyPveOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(!this.FSkyTower.IsAKeyPve)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_26));
            return;
         }
         if(this.FOnOpenYeYi != null)
         {
            this.FOnOpenYeYi(this);
         }
      }
      
      protected function Btn_PveAutoOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         _loc3_ = "";
         if(!SLogicsCore.Character.VipData.AKeyBableTower)
         {
            _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_08);
            _loc4_ = uint(SLogicsCore.Character.VipData.VipOpenLevel_AKeyBableTower);
            _loc3_ = TUtilityString.Format(_loc3_,_loc4_);
         }
         else
         {
            _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_29);
         }
         if(TUtilityString.Empty(this.FHintPveAuto.Caption))
         {
            this.FHintPveAuto.Caption = _loc3_;
         }
         if(this.FHintOnOver != null)
         {
            this.FHintOnOver(this,this.FHintPveAuto);
         }
      }
      
      protected function Btn_PveAutoOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHintPveAuto);
            this.FHintPveAuto.Caption = "";
         }
      }
      
      protected function Btn_ViewRewardOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FSP_Reward.visible = !this.FSP_Reward.visible;
      }
      
      protected function Btn_PveOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.ProcessorChallengeReq(this.FSkyTower.SelectMode,0,this.FSkyTower.SelectTowerID,this.FSkyTower.SelectLayerID);
      }
      
      protected function Btn_PveAutoOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_SkyTower_AutoBattle_Req);
         _loc4_ = _loc3_.Data;
         _loc4_.writeUnsignedInt(this.FTower.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function Btn_ViewPvpDiaryOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FSP_PvpDiary.visible = !this.FSP_PvpDiary.visible;
      }
      
      protected function UIStateOnChallenge(param1:Object, param2:TLayer) : void
      {
         this.ProcessorChallengeReq(this.FSkyTower.SelectMode,CONST_SKYTOWER.TYPE_SKYTOWER_PVP_Challenge,this.FSkyTower.SelectTowerID,param2.PvpID);
      }
      
      protected function UIStateOnOccupy(param1:Object, param2:TLayer) : void
      {
         this.ProcessorChallengeReq(this.FSkyTower.SelectMode,CONST_SKYTOWER.TYPE_SKYTOWER_PVP_Occupy,this.FSkyTower.SelectTowerID,param2.PvpID);
      }
      
      protected function UIStateOnReceiving(param1:Object, param2:TLayer) : void
      {
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_SkyTower_PvpReceiving_Req);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function UIStateOnEffectText(param1:Object, param2:String) : void
      {
         EffectGenerateText(param2);
      }
      
      protected function TF_PvpDiaryOnCLick(param1:TextEvent) : void
      {
         var _loc2_:Array = null;
         _loc2_ = param1.text.split("_");
         switch(_loc2_[0])
         {
            case CONST_POST.EVENT_TYPE_EVENT:
               SExternalCore.NavigateToBattleReportUrl(_loc2_[1]);
         }
      }
      
      public function get OnOpenYeYi() : Function
      {
         return this.FOnOpenYeYi;
      }
      
      public function set OnOpenYeYi(param1:Function) : void
      {
         this.FOnOpenYeYi = param1;
      }
      
      public function set HintOnOver(param1:Function) : void
      {
         this.FHintOnOver = param1;
      }
      
      public function get HintOnOver() : Function
      {
         return this.FHintOnOver;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function get HintOnOut() : Function
      {
         return this.FHintOnOut;
      }
      
      override public function Dispose() : void
      {
         var _loc1_:int = 0;
         this.Reset();
         if(!this.FInitialization)
         {
            return;
         }
         this.FBtn_Close.Dispose();
         this.FBtn_Close = null;
         this.FTF_Title = null;
         this.FUITabs.Dispose();
         this.FUITabs = null;
         this.FSP_RoomPve = null;
         this.FSP_Pass = null;
         this.FTF_ProgressPve = null;
         this.FTF_CountPve = null;
         this.FBtn_BuyPve.Dispose();
         this.FBtn_BuyPve = null;
         this.FBtn_AKeyPve.Dispose();
         this.FBtn_AKeyPve = null;
         this.FBtn_ViewReward.Dispose();
         this.FBtn_ViewReward = null;
         this.FBtn_Pve.Dispose();
         this.FBtn_Pve = null;
         this.FBtn_PveAuto.Dispose();
         this.FBtn_PveAuto = null;
         this.FSP_Reward = null;
         this.FTF_Reward = null;
         this.FMC_TowerIDs = null;
         this.FUIPlayerSelfPve.Dispose();
         this.FUIPlayerSelfPve = null;
         this.FUIPlayerEnemyPve.Dispose();
         this.FUIPlayerEnemyPve = null;
         this.FUIPlayerPveBak0.Dispose();
         this.FUIPlayerPveBak0 = null;
         this.FUIPlayerPveBak1.Dispose();
         this.FUIPlayerPveBak1 = null;
         this.FSP_RoomPvp = null;
         this.FTF_CountPvp = null;
         this.FBtn_BuyPvp.Dispose();
         this.FBtn_BuyPvp = null;
         this.FBtn_ViewPvpDiary.Dispose();
         this.FBtn_ViewPvpDiary = null;
         this.FSP_PvpDiary = null;
         this.FTF_PvpDiary = null;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Pvp_Roles)
         {
            this.FUIHeros[_loc1_].Dispose();
            this.FUIHeros[_loc1_] = null;
            this.FSP_LightBeams[_loc1_] = null;
            this.FUIStates[_loc1_].Dispose();
            this.FUIStates[_loc1_] = null;
            _loc1_++;
         }
         this.FUIHeros.length = 0;
         this.FUIHeros = null;
         this.FSP_LightBeams.length = 0;
         this.FSP_LightBeams = null;
         this.FUIStates.length = 0;
         this.FUIStates = null;
         this.FRolesModelID.length = 0;
         if(this.FSP_BattleRoom.parent != null)
         {
            this.FSP_BattleRoom.parent.removeChild(this.FSP_BattleRoom);
         }
         this.FSP_BattleRoom = null;
         this.FInitialization = false;
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         if(!this.FInitialization)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Pvp_Roles)
         {
            this.FUIHeros[_loc1_].Context = null;
            this.FUIHeros[_loc1_].Visible = false;
            this.FUIStates[_loc1_].Context = null;
            this.FUIStates[_loc1_].Tag = 0;
            this.FSP_LightBeams[_loc1_].visible = false;
            _loc1_++;
         }
         _loc2_ = int(this.FRolesModelID.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = uint(this.FRolesModelID[_loc1_]);
            SResourcesCore.TexturesModel.DeleteByIdentifier(_loc3_,true);
            _loc1_++;
         }
         this.FTF_PvpDiary.text = "";
         this.FTF_Title.text = "";
         this.FTF_ProgressPve.text = "";
         this.FTF_CountPve.text = "";
         this.FTF_Reward.text = "";
         this.FTF_CountPvp.text = "";
         this.FTower = null;
         this.FTabIndex = 0;
         this.FSP_Pass.visible = false;
         this.FSP_RoomPve.visible = false;
         this.FSP_RoomPvp.visible = false;
         this.FSP_Reward.visible = false;
         this.FSP_PvpDiary.visible = false;
         this.FUIPlayerSelfPve.Context = null;
         this.FUIPlayerEnemyPve.Context = null;
         this.FUIPlayerPveBak0.Context = null;
         this.FUIPlayerPveBak1.Context = null;
      }
      
      public function Update() : void
      {
         this.FTower = this.FSkyTower.Towers.GetTowerByIdentifier(this.FSkyTower.SelectTowerID);
         this.ProcessorUpdateCommon();
         this.ProcessorResize();
      }
      
      public function UpdateUIPve() : void
      {
         this.ProcessorUpdateUIPve();
      }
      
      public function UpdateUIPvp() : void
      {
         if(this.FSkyTower.SelectMode == MODE_SKYTOWER_PVP)
         {
            this.ProcessorUpdateUIPvp();
         }
      }
      
      public function UpdateBattleResult(param1:Boolean) : void
      {
         var _loc2_:TLayer = null;
         if(this.FSkyTower.SelectMode == MODE_SKYTOWER_PVE)
         {
            if(!param1)
            {
               ++this.FSkyTower.PVECount;
            }
         }
         else if(this.FSkyTower.SelectMode == MODE_SKYTOWER_PVP)
         {
         }
         _loc2_ = this.FSkyTower.Towers.GetTowerByIdentifier(this.FSkyTower.SelectTowerID).Layers.GetLayerByIdentifier(this.FSkyTower.SelectLayerID);
         _loc2_.IsClear = param1;
         this.FSkyTower.UpdateTowerMaxLayers();
      }
      
      public function UpdatePvpDiarys() : void
      {
         this.ProcessorUpdatePvpDiarys();
      }
   }
}

