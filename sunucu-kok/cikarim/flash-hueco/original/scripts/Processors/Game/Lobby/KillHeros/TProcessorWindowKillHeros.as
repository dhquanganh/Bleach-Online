package Processors.Game.Lobby.KillHeros
{
   import Components.Slots.*;
   import Components.Standard.*;
   import Externals.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Agent.*;
   import Logics.Campaign.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.KillHero.*;
   import Logics.Streamization.Inventories.*;
   import Logics.Vip.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Components.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.HyperLink.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Rendering.Texts.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorWindowKillHeros extends TProcessorLobbyWindow
   {
      
      protected static const CAPACITY_INVENTORYS:int = CONST_KILLHERO.CAPACITY_INVENTORYS;
      
      protected static const CAPACITY_CHECKPOINT:int = CONST_KILLHERO.CAPACITY_CHECKPOINT;
      
      protected static const CAPACITY_HEROS:int = CONST_KILLHERO.CAPACITY_HEROS;
      
      protected static const TYPE_RESET_SINGLE:int = CONST_KILLHERO.TYPE_RESET_SINGLE;
      
      protected static const TYPE_RESET_ALL:int = CONST_KILLHERO.TYPE_RESET_ALL;
      
      protected static const RAIDERS_ID:Vector.<uint> = CONST_KILLHERO.RAIDERS_ID;
      
      protected static const KILLHERO_CITYSTART_ID:int = 15120000;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FUIWindowRecharge:TUIWindowRecharge;
      
      protected var FRoleModel:TBins;
      
      protected var FRaidersDailyConfigBins:TBins;
      
      protected var FEnemyBins:TBins;
      
      protected var FCityBins:TBins;
      
      protected var FHelpTips:THint;
      
      protected var FHintBtnReset:THint;
      
      protected var FInventories:TInventories;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FUIHeros:Vector.<TUIHero>;
      
      protected var FRolesModelID:Vector.<int>;
      
      protected var FSP_HeroNames:Vector.<Sprite>;
      
      protected var FTF_HeroNames:Vector.<TextField>;
      
      protected var FMC_KillHero:MovieClip;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FBtn_Help:SimpleButton;
      
      protected var FBtn_Talisman:SimpleButton;
      
      protected var FSP_Best:Sprite;
      
      protected var FSP_First:Sprite;
      
      protected var FTF_BestName:TextField;
      
      protected var FTF_FirstName:TextField;
      
      protected var FBtnChallenge:TUIButton;
      
      protected var FBtnReset:TUIButton;
      
      protected var FBtnResetAll:TUIButton;
      
      protected var FSP_Backgroud:Sprite;
      
      protected var FBackgroundBitmap:Bitmap;
      
      protected var FMC_List:MovieClip;
      
      protected var FSP_List:MovieClip;
      
      protected var FSP_CheckPoints:Vector.<Sprite>;
      
      protected var FBmp_Icons:Vector.<Bitmap>;
      
      protected var FSP_HighLights:Vector.<Sprite>;
      
      protected var FSP_Locks:Vector.<Sprite>;
      
      protected var FSP_Passs:Vector.<Sprite>;
      
      protected var FSP_Selects:Vector.<Sprite>;
      
      protected var FMC_TowerLayers:Vector.<MovieClip>;
      
      protected var FBtn_TowerLayersA:Vector.<TUIButton>;
      
      protected var FBtn_TowerLayersB:Vector.<TUIButton>;
      
      protected var FBtnChangeUp:TUIButton;
      
      protected var FBtnChangeDown:TUIButton;
      
      protected var FStartTowerIndex:int;
      
      protected var FUISlots:Vector.<TUISlot>;
      
      protected var FSP_CurTowerLayer:Sprite;
      
      protected var FCharacter:TCharacter;
      
      protected var FVipData:TVip;
      
      protected var FNodalModel:TNodal;
      
      protected var FKillHeroInfo:TKillHero;
      
      protected var FCurKillHeroInfo:TSingleKillHero;
      
      protected var FCurRaidersID:int;
      
      protected var FCostResetGold:uint;
      
      protected var FCurPage:int;
      
      protected var FTotlePage:int;
      
      protected var FMaxPage:int;
      
      protected var FCurKillHeroId:int;
      
      protected var FBackgroundId:int;
      
      protected var FBtnStatus:uint;
      
      protected var FHintOnMove:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FOnHelpTipsOver:Function;
      
      protected var FOnHelpTipsOut:Function;
      
      protected var FOnInventoryOver:Function;
      
      protected var FOnInventoryOut:Function;
      
      protected var FOnAddPopTips:Function;
      
      protected var FOnFight:Function;
      
      protected var FOnUpdateCityID:Function;
      
      public function TProcessorWindowKillHeros(param1:TUIComponent)
      {
         super(param1);
         this.FHelpTips = new THint();
         this.FHintBtnReset = new THint();
         this.FNodalModel = SLogicsCore.Nodal;
         this.FCharacter = SLogicsCore.Character;
         this.FInventories = new TInventories();
         this.FVipData = this.FCharacter.VipData;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_KILLHERO.RESOURCESID_KillHero);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIButton = null;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         var _loc6_:Sprite = null;
         var _loc7_:Sprite = null;
         var _loc8_:Sprite = null;
         var _loc9_:TextField = null;
         var _loc10_:Bitmap = null;
         var _loc11_:TUISlot = null;
         var _loc12_:TUIHero = null;
         var _loc13_:TConfigValue = null;
         var _loc14_:TextFormat = null;
         var _loc15_:TBounds = null;
         var _loc16_:TCoordinate = null;
         this.FMC_KillHero = TUtilityReflection.CreateDisplayObjectInstance(CONST_KILLHERO.RESOURCE_ClassName_KillHero) as MovieClip;
         addChild(this.FMC_KillHero);
         this.FBtn_Close = this.FMC_KillHero[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtn_Help = this.FMC_KillHero[CONST_COMMON.RESOURCE_Link_Btn_Help];
         this.FBtn_Talisman = this.FMC_KillHero[CONST_KILLHERO.RESOURCE_Link_Btn_Talisman];
         _loc2_ = int(CONST_KILLHERO.CAPACITY_MC_TOWERLAYER);
         this.FMC_TowerLayers = new Vector.<MovieClip>(_loc2_);
         this.FBtn_TowerLayersA = new Vector.<TUIButton>(_loc2_);
         this.FBtn_TowerLayersB = new Vector.<TUIButton>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FMC_KillHero[CONST_KILLHERO.RESOURCE_Link_MC_TowerLayer + _loc1_];
            _loc3_ = new TUIButton();
            _loc3_.Substrate = _loc4_[CONST_KILLHERO.RESOURCE_Link_Btn_Tower];
            this.FBtn_TowerLayersA[_loc1_] = _loc3_;
            _loc3_ = new TUIButton();
            _loc3_.Substrate = _loc4_[CONST_KILLHERO.RESOURCE_Link_Btn_NoLevel];
            _loc3_.Enabled = false;
            _loc3_.Visible = false;
            this.FBtn_TowerLayersB[_loc1_] = _loc3_;
            this.FMC_TowerLayers[_loc1_] = _loc4_;
            _loc1_++;
         }
         this.FBtnChangeUp = new TUIButton();
         this.FBtnChangeUp.Substrate = this.FMC_KillHero["MCChange"]["Btn_Up"];
         this.FBtnChangeUp.OnClick = this.BtnChangeUpOnClick;
         this.FBtnChangeDown = new TUIButton();
         this.FBtnChangeDown.Substrate = this.FMC_KillHero["MCChange"]["Btn_Down"];
         this.FBtnChangeDown.OnClick = this.BtnChangeDownOnClick;
         _loc4_ = this.FMC_KillHero[CONST_KILLHERO.RESOURCE_Link_MC_BestShow];
         this.FSP_Best = _loc4_[CONST_KILLHERO.RESOURCE_Link_MC_Best];
         this.FSP_First = _loc4_[CONST_KILLHERO.RESOURCE_Link_MC_First];
         this.FSP_Best.mouseChildren = false;
         this.FSP_Best.buttonMode = true;
         this.FSP_First.mouseChildren = false;
         this.FSP_First.buttonMode = true;
         this.FTF_BestName = this.FSP_Best[CONST_KILLHERO.RESOURCE_Link_TF_BestName];
         this.FTF_FirstName = this.FSP_First[CONST_KILLHERO.RESOURCE_Link_TF_FirstName];
         _loc14_ = new TextFormat();
         _loc14_.underline = true;
         this.FTF_BestName.defaultTextFormat = _loc14_;
         this.FTF_FirstName.defaultTextFormat = _loc14_;
         this.FBtnChallenge = new TUIButton();
         this.FBtnChallenge.Substrate = this.FMC_KillHero[CONST_KILLHERO.RESOURCE_Link_Btn_Challenge];
         this.FBtnChallenge.OnClick = this.BtnChallengeOnClick;
         this.FBtnReset = new TUIButton();
         this.FBtnReset.Substrate = this.FMC_KillHero[CONST_KILLHERO.RESOURCE_Link_Btn_Reset];
         this.FBtnReset.OnClick = this.BtnResetOnClick;
         this.FBtnReset.OnMove = this.BtnResetOnMove;
         this.FBtnReset.OnOut = this.BtnResetOnOut;
         this.FBtnResetAll = new TUIButton();
         this.FBtnResetAll.Substrate = this.FMC_KillHero[CONST_KILLHERO.RESOURCE_Link_Btn_ResetAll];
         this.FBtnResetAll.OnClick = this.BtnResetAllOnClick;
         this.FBtnResetAll.OnMove = this.BtnResetOnMove;
         this.FBtnResetAll.OnOut = this.BtnResetOnOut;
         this.FSP_Backgroud = this.FMC_KillHero[CONST_KILLHERO.RESOURCE_Link_SP_Backgroud];
         this.FSP_Backgroud.mouseChildren = false;
         this.FSP_Backgroud.mouseEnabled = false;
         this.FBackgroundBitmap = new Bitmap();
         this.FSP_Backgroud.addChild(this.FBackgroundBitmap);
         this.FMC_List = this.FMC_KillHero[CONST_KILLHERO.RESOURCE_Link_MC_List];
         this.FSP_List = this.FMC_List[CONST_KILLHERO.RESOURCE_Link_SP_List];
         _loc2_ = CAPACITY_CHECKPOINT;
         this.FSP_CheckPoints = new Vector.<Sprite>(_loc2_);
         this.FBmp_Icons = new Vector.<Bitmap>(_loc2_);
         this.FSP_HighLights = new Vector.<Sprite>(_loc2_);
         this.FSP_Locks = new Vector.<Sprite>(_loc2_);
         this.FSP_Passs = new Vector.<Sprite>(_loc2_);
         this.FSP_Selects = new Vector.<Sprite>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc8_ = this.FSP_List[CONST_KILLHERO.RESOURCE_Link_SP_CheckPoint + _loc1_];
            _loc8_.buttonMode = false;
            _loc9_ = _loc8_[CONST_KILLHERO.RESOURCE_Link_TF_Num];
            _loc9_.text = String(_loc1_ + 1);
            _loc6_ = _loc8_[CONST_KILLHERO.RESOURCE_Link_SP_HighLight];
            _loc6_.visible = false;
            this.FSP_HighLights[_loc1_] = _loc6_;
            _loc7_ = _loc8_[CONST_KILLHERO.RESOURCE_Link_SP_Icon];
            _loc10_ = new Bitmap();
            _loc7_.addChild(_loc10_);
            _loc7_ = _loc8_[CONST_KILLHERO.RESOURCE_Link_SP_Lock];
            this.FSP_Locks[_loc1_] = _loc7_;
            _loc7_ = _loc8_[CONST_KILLHERO.RESOURCE_Link_MC_Pass];
            this.FSP_Passs[_loc1_] = _loc7_;
            _loc7_ = _loc8_[CONST_KILLHERO.RESOURCE_Link_MC_Select];
            this.FSP_Selects[_loc1_] = _loc7_;
            this.FBmp_Icons[_loc1_] = _loc10_;
            this.FSP_CheckPoints[_loc1_] = _loc8_;
            _loc1_++;
         }
         _loc2_ = int(CONST_KILLHERO.CAPACITY_SLOTS);
         this.FUISlots = new Vector.<TUISlot>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc11_ = new TUISlot(this);
            _loc11_.Resource = this.FMC_KillHero[CONST_KILLHERO.RESOURCE_Link_MC_Slot + _loc1_];
            _loc11_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
            _loc11_.OnOver = this.SlotsOnMove;
            _loc11_.OnOut = this.SlotsOnOut;
            _loc11_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
            this.FUISlots[_loc1_] = _loc11_;
            this.FUISlots[_loc1_].Init();
            _loc1_++;
         }
         _loc2_ = CAPACITY_HEROS;
         this.FUIHeros = new Vector.<TUIHero>(_loc2_);
         this.FSP_HeroNames = new Vector.<Sprite>(_loc2_);
         this.FTF_HeroNames = new Vector.<TextField>(_loc2_);
         this.FRolesModelID = new Vector.<int>();
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FMC_KillHero[CONST_KILLHERO.RESOURCE_Link_MC_Role + _loc1_];
            _loc4_.mouseEnabled = false;
            _loc4_.mouseChildren = false;
            _loc6_ = _loc4_[CONST_KILLHERO.RESOURCE_Link_MC_Name];
            _loc6_.visible = false;
            _loc9_ = _loc6_[CONST_KILLHERO.RESOURCE_Link_TF_Name];
            this.FTF_HeroNames[_loc1_] = _loc9_;
            this.FSP_HeroNames[_loc1_] = _loc6_;
            _loc12_ = new TUIHero(this);
            _loc5_ = _loc4_[CONST_KILLHERO.RESOURCE_Link_MC_MountPoint];
            _loc5_.addChild(_loc12_);
            _loc12_.SequenceDefaultRole = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCEID_Textures_DefaultRole,0);
            _loc12_.OnQuerySequenceContext = this.HeroOnQuerySequenceContext;
            _loc15_ = new TBounds();
            _loc16_ = new TCoordinate();
            _loc12_.SequenceDefaultRole.Evaluate(_loc16_,_loc15_);
            _loc12_.X = _loc15_.X;
            _loc12_.Y = _loc15_.Y;
            this.FUIHeros[_loc1_] = _loc12_;
            _loc1_++;
         }
         this.FSP_CurTowerLayer = this.FMC_KillHero[CONST_KILLHERO.RESOURCE_Link_SP_CurTower];
         this.FSP_CurTowerLayer.mouseChildren = false;
         this.FSP_CurTowerLayer.mouseEnabled = false;
         _loc13_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.KILL_RESET_GOLD) as TConfigValue;
         this.FCostResetGold = _loc13_.Value as uint;
         this.FUIWindowRecharge = SUtilityOverLayer.UIWindowRecharge;
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         this.FCityBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_City);
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         TutorialSendComponent(CONST_FRESHGUIDE.MCID_KillHeroView,this);
         TutorialSendArrowParent(CONST_FRESHGUIDE.MCID_KillHeroView,FParent);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIButton = null;
         var _loc4_:Sprite = null;
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.ButtonCloseOnClick,false,0,true);
         this.FBtn_Help.addEventListener(MouseEvent.MOUSE_MOVE,this.ButtonHelpOnOver,false,0,true);
         this.FBtn_Help.addEventListener(MouseEvent.MOUSE_OUT,this.ButtonHelpOnOut,false,0,true);
         this.FBtn_Talisman.addEventListener(MouseEvent.CLICK,this.BtnSeeTreasureOnClick,false,0,true);
         this.FSP_Best.addEventListener(MouseEvent.CLICK,this.SP_BestOnClick,false,0,true);
         this.FSP_First.addEventListener(MouseEvent.CLICK,this.SP_FirstOnClick,false,0,true);
         _loc2_ = int(CONST_KILLHERO.CAPACITY_MC_TOWERLAYER);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FBtn_TowerLayersA[_loc1_];
            _loc3_.OnClick = this.Btn_TowerLayerOnClick;
            _loc1_++;
         }
         _loc2_ = CAPACITY_CHECKPOINT;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FSP_CheckPoints[_loc1_];
            _loc4_.addEventListener(MouseEvent.CLICK,this.SP_SelectHeroOnClick,false,0,true);
            _loc4_.addEventListener(MouseEvent.ROLL_OVER,this.SP_HeroOnRoll,false,0,true);
            _loc4_.addEventListener(MouseEvent.ROLL_OUT,this.SP_HeroOnRoll,false,0,true);
            _loc1_++;
         }
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.Visible)
         {
            this.UpdataUIHeros();
            this.UpdataUISlots();
         }
      }
      
      protected function UpdataUIHeros() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FUIHeros.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FUIHeros[_loc1_].Update();
            _loc1_++;
         }
      }
      
      protected function UpdataUISlots() : void
      {
         var _loc1_:int = 0;
         if(this.FKillHeroInfo == null)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_INVENTORYS)
         {
            this.FUISlots[_loc1_].Update();
            _loc1_++;
         }
      }
      
      protected function SlotsOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TInventory = null;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         _loc5_ = param2 as TInventory;
         _loc6_ = SResourcesCore.TexturesInventory;
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc5_.IDTexture);
         if(_loc7_ != null)
         {
            param3.Value = _loc7_.GetAnimationSequenceByIdentifier(param4);
         }
         else
         {
            _loc6_.LoadSecondary(_loc5_.IDTexture);
         }
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:int = 0;
         var _loc5_:MovieClip = null;
         var _loc6_:int = 0;
         var _loc7_:TSingleKillHero = null;
         var _loc8_:TRaidersDailyConfig = null;
         var _loc9_:TRoleModel = null;
         if(param3 == this.FBackgroundId)
         {
            this.FBackgroundBitmap.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
            return;
         }
         _loc4_ = 0;
         while(_loc4_ < CAPACITY_CHECKPOINT)
         {
            _loc6_ = (this.FCurPage - 1) * CAPACITY_CHECKPOINT + _loc4_;
            _loc7_ = this.FKillHeroInfo.KillHeroInfo[_loc6_];
            _loc8_ = this.FRaidersDailyConfigBins.GetDatebaseByIdentifier(_loc7_.KillHeroId) as TRaidersDailyConfig;
            _loc9_ = this.FRoleModel.GetDatebaseByIdentifier(_loc8_.HeroVect[0]) as TRoleModel;
            if(param3 == _loc9_.RoleHead)
            {
               this.FBmp_Icons[_loc4_].bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
            }
            _loc4_++;
         }
      }
      
      protected function UpdataKillHerosUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:MovieClip = null;
         var _loc6_:Sprite = null;
         var _loc7_:Sprite = null;
         var _loc8_:Sprite = null;
         var _loc9_:Sprite = null;
         var _loc10_:Bitmap = null;
         var _loc11_:TextField = null;
         var _loc12_:TUIHero = null;
         var _loc13_:TSingleKillHero = null;
         var _loc14_:int = 0;
         var _loc15_:String = null;
         var _loc16_:String = null;
         var _loc17_:TRaidersDailyConfig = null;
         var _loc18_:TEnemy = null;
         var _loc19_:Vector.<uint> = null;
         var _loc20_:TRoleModel = null;
         var _loc21_:Vector.<uint> = null;
         var _loc22_:int = 0;
         if(this.FRaidersDailyConfigBins == null)
         {
            this.FRaidersDailyConfigBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_RaidersDailyConfig);
         }
         if(this.FRoleModel == null)
         {
            this.FRoleModel = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_RoleModel);
         }
         if(this.FEnemyBins == null)
         {
            this.FEnemyBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Enemy);
         }
         if(this.FCurKillHeroInfo == null)
         {
            return;
         }
         _loc17_ = this.FRaidersDailyConfigBins.GetDatebaseByIdentifier(this.FCurKillHeroInfo.KillHeroId) as TRaidersDailyConfig;
         if(this.FBackgroundId != _loc17_.BgPath)
         {
            this.FBackgroundId = _loc17_.BgPath;
            SResourcesCore.TexturesBackgroundIcon.LoadAutoSecondary(this.FBackgroundId,this.AutoLoadCallBack);
         }
         this.FTF_BestName.text = this.FCurKillHeroInfo.BestName;
         this.FTF_FirstName.text = this.FCurKillHeroInfo.FirstName;
         _loc3_ = CAPACITY_HEROS;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc11_ = this.FTF_HeroNames[_loc2_];
            _loc11_.text = "";
            _loc6_ = this.FSP_HeroNames[_loc2_];
            _loc6_.visible = false;
            _loc12_ = this.FUIHeros[_loc2_];
            _loc12_.Context = null;
            _loc2_++;
         }
         _loc3_ = int(_loc17_.HeroVect.length);
         _loc2_ = 0;
         while(_loc2_ < CAPACITY_HEROS)
         {
            if(_loc2_ < _loc3_)
            {
               _loc18_ = this.FEnemyBins.GetDatebaseByIdentifier(_loc17_.HeroVect[_loc2_]) as TEnemy;
               _loc20_ = this.FRoleModel.GetDatebaseByIdentifier(_loc18_.Identifier) as TRoleModel;
               if(_loc3_ == 1)
               {
                  _loc6_ = this.FSP_HeroNames[_loc3_];
                  _loc11_ = this.FTF_HeroNames[_loc3_];
                  _loc12_ = this.FUIHeros[_loc3_];
               }
               else
               {
                  _loc6_ = this.FSP_HeroNames[_loc2_];
                  _loc11_ = this.FTF_HeroNames[_loc2_];
                  _loc12_ = this.FUIHeros[_loc2_];
               }
               _loc6_.visible = true;
               _loc11_.text = _loc18_.Name;
               _loc12_.Context = _loc20_.Model;
            }
            _loc2_++;
         }
         if(!this.FCurKillHeroInfo.IsTodayPass)
         {
            this.FBtnChallenge.Visible = true;
            this.FBtnReset.Visible = false;
         }
         else if(this.FCurKillHeroInfo.ResetCount < this.FVipData.DailyChaReset)
         {
            this.FBtnChallenge.Visible = false;
            this.FBtnReset.Visible = true;
         }
         else
         {
            this.FBtnChallenge.Visible = false;
            this.FBtnReset.Visible = this.FVipData.VipLevel < this.FVipData.VipOpenLevel_DailyChaReset;
         }
         _loc2_ = 0;
         while(_loc2_ < CAPACITY_CHECKPOINT)
         {
            _loc14_ = (this.FCurPage - 1) * CAPACITY_CHECKPOINT + _loc2_;
            _loc13_ = this.FKillHeroInfo.KillHeroInfo[_loc14_];
            _loc9_ = this.FSP_CheckPoints[_loc2_];
            _loc6_ = this.FSP_Locks[_loc2_];
            _loc7_ = this.FSP_Passs[_loc2_];
            _loc8_ = this.FSP_Selects[_loc2_];
            _loc10_ = this.FBmp_Icons[_loc2_];
            if(_loc14_ <= this.FKillHeroInfo.NewKillHeroIndex)
            {
               _loc6_.visible = false;
               _loc9_.buttonMode = true;
               _loc7_.visible = _loc13_.IsPassed;
               _loc8_.visible = _loc13_.KillHeroId == this.FCurKillHeroId;
               if(_loc13_.IsTodayPass)
               {
                  _loc10_.filters = [TUtilityFilter.rBlackFilters];
               }
               else
               {
                  _loc10_.filters = [];
               }
            }
            else
            {
               _loc6_.visible = true;
               _loc9_.buttonMode = false;
               _loc7_.visible = false;
               _loc8_.visible = false;
               _loc10_.filters = [TUtilityFilter.rBlackFilters];
            }
            _loc2_++;
         }
         _loc21_ = _loc17_.RaiderAwards;
         this.FInventories.Clear();
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,this.FInventories,_loc21_);
         _loc14_ = 0;
         while(_loc14_ < this.FInventories.Count)
         {
            this.FUISlots[_loc14_].Context = this.FInventories.GetInventoryByIndex(_loc14_);
            _loc14_++;
         }
         this.FBtnResetAll.Enabled = this.FVipData.VipLevel >= this.FVipData.VipOpenLevel_DailyChaReset;
         _loc19_ = this.GetCanResetKillHeroIds();
         this.FBtnResetAll.Enabled = _loc19_.length > 0;
         _loc22_ = this.TowerIndexToUIIndex(this.FCurPage - 1);
         if(_loc22_ > this.FMC_TowerLayers.length - 1 || _loc22_ < 0)
         {
            this.FSP_CurTowerLayer.visible = false;
         }
         else
         {
            this.FSP_CurTowerLayer.x = this.FMC_TowerLayers[_loc22_].x - 12;
            this.FSP_CurTowerLayer.y = this.FMC_TowerLayers[_loc22_].y - 12;
            this.FSP_CurTowerLayer.mouseEnabled = false;
            this.FSP_CurTowerLayer.visible = true;
         }
         _loc2_ = 0;
         while(_loc2_ < CAPACITY_CHECKPOINT)
         {
            _loc10_ = this.FBmp_Icons[_loc2_];
            _loc10_.bitmapData = null;
            _loc4_ = (this.FCurPage - 1) * CAPACITY_CHECKPOINT + _loc2_;
            _loc13_ = this.FKillHeroInfo.KillHeroInfo[_loc4_];
            _loc17_ = this.FRaidersDailyConfigBins.GetDatebaseByIdentifier(_loc13_.KillHeroId) as TRaidersDailyConfig;
            _loc20_ = this.FRoleModel.GetDatebaseByIdentifier(_loc17_.HeroVect[0]) as TRoleModel;
            SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc20_.RoleHead,this.AutoLoadCallBack);
            _loc2_++;
         }
      }
      
      protected function CheckBtn() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TCity = null;
         var _loc7_:TUIButton = null;
         var _loc8_:TSingleKillHero = null;
         var _loc9_:TRaidersDailyConfig = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         if(this.FMC_KillHero == null)
         {
            return;
         }
         _loc2_ = int(this.FMC_TowerLayers.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc10_ = this.UIIndexToTowerIndex(_loc1_);
            if(_loc10_ < this.FTotlePage)
            {
               this.FBtn_TowerLayersA[_loc1_].Visible = true;
               this.FBtn_TowerLayersB[_loc1_].Visible = false;
               if(this.FCityBins == null)
               {
                  this.FCityBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_City);
               }
               _loc3_ = this.FMC_TowerLayers[_loc1_].name;
               _loc4_ = int(RAIDERS_ID[_loc10_]);
               _loc6_ = this.FCityBins.GetDatebaseByIdentifier(_loc4_) as TCity;
               if(_loc6_ != null)
               {
                  this.FMC_TowerLayers[_loc1_].Btn_Tower.TF_Name.text = _loc6_.Name;
               }
               _loc7_ = this.FBtn_TowerLayersA[_loc1_];
               _loc7_.Enabled = true;
            }
            else
            {
               _loc7_ = this.FBtn_TowerLayersA[_loc1_];
               _loc7_.Enabled = false;
               this.FBtn_TowerLayersA[_loc1_].Visible = false;
               this.FBtn_TowerLayersB[_loc1_].Visible = true;
               _loc3_ = this.FMC_TowerLayers[_loc1_].name;
               _loc4_ = int(RAIDERS_ID[_loc10_]);
               if(this.FCityBins == null)
               {
                  this.FCityBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_City);
               }
               _loc6_ = this.FCityBins.GetDatebaseByIdentifier(_loc4_) as TCity;
               _loc9_ = this.FRaidersDailyConfigBins.GetDatebaseByIdentifier(_loc6_.Start) as TRaidersDailyConfig;
               _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KILLHERO_STRING_04);
               if(_loc9_.Level == 999)
               {
                  _loc3_ = _loc6_.Name.toString();
               }
               else
               {
                  _loc3_ = _loc3_.split("%level%").join(_loc9_.Level);
               }
               this.FMC_TowerLayers[_loc1_].Btn_NoLevel.TF_OpenLevel.text = _loc3_;
            }
            _loc1_++;
         }
      }
      
      protected function GetCanResetKillHeroIds() : Vector.<uint>
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TSingleKillHero = null;
         var _loc4_:Vector.<uint> = null;
         _loc4_ = new Vector.<uint>();
         _loc2_ = int(this.FCurKillHeroId / 10) * 10 + 1;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_CHECKPOINT)
         {
            _loc3_ = this.FKillHeroInfo.KillHeroInfo[(this.FCurPage - 1) * CAPACITY_CHECKPOINT + _loc1_];
            if(_loc3_.IsTodayPass && _loc3_.ResetCount < this.FVipData.DailyChaReset)
            {
               _loc4_.push(_loc3_.KillHeroId);
            }
            _loc1_++;
         }
         return _loc4_;
      }
      
      protected function UIIndexToTowerIndex(param1:int) : int
      {
         return param1 + this.FStartTowerIndex;
      }
      
      protected function TowerIndexToUIIndex(param1:int) : int
      {
         return param1 - this.FStartTowerIndex;
      }
      
      protected function ButtonCloseOnClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function ButtonHelpOnOver(param1:MouseEvent) : void
      {
         if(TUtilityString.Empty(this.FHelpTips.Content))
         {
            this.FHelpTips.Content = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELPTIPS_KillHeros);
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
      
      protected function SP_BestOnClick(param1:MouseEvent) : void
      {
         if(this.FCurKillHeroInfo == null)
         {
            return;
         }
         if(TUtilityString.Empty(this.FTF_BestName.text) || TUtilityString.Empty(this.FCurKillHeroInfo.BestId))
         {
            return;
         }
         SExternalCore.NavigateToBattleReportUrl(this.FCurKillHeroInfo.BestId);
      }
      
      protected function SP_FirstOnClick(param1:MouseEvent) : void
      {
         if(this.FCurKillHeroInfo == null)
         {
            return;
         }
         if(TUtilityString.Empty(this.FTF_FirstName.text) || TUtilityString.Empty(this.FCurKillHeroInfo.FirstId))
         {
            return;
         }
         SExternalCore.NavigateToBattleReportUrl(this.FCurKillHeroInfo.FirstId);
      }
      
      protected function BtnChallengeOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         if(SLogicsCore.Character.CreditMilitaryOrders < this.FKillHeroInfo.NeedMilitaryOrder)
         {
            if(this.FOnAddPopTips != null)
            {
               this.FOnAddPopTips(this,CONST_POPTIPS.POPTIP_InsufficientMobility);
            }
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Military));
            return;
         }
         if(this.FOnUpdateCityID != null)
         {
            this.FOnUpdateCityID(this,KILLHERO_CITYSTART_ID + this.FCurPage);
         }
         if(this.FOnFight != null)
         {
            this.FOnFight(this,this.FNodalModel,CONST_BATTLE.BattleType_KillHero,KILLHERO_CITYSTART_ID + this.FCurPage,this.FCurKillHeroId);
         }
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_StartChallenge);
      }
      
      protected function BtnResetOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:String = null;
         if(Boolean(param2.currentTarget) && !param2.currentTarget.buttonMode)
         {
            return;
         }
         _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KILLHERO_STRING_05);
         _loc3_ = _loc3_.split("%count%").join(this.FCostResetGold);
         this.FUIWindowConfirmation.Text = _loc3_;
         this.FUIWindowConfirmation.OnOK = this.ResetSureOnOk;
         this.FUIWindowConfirmation.Visible = true;
         this.FBtnStatus = TYPE_RESET_SINGLE;
      }
      
      protected function ResetSureOnOk(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         var _loc4_:int = 0;
         var _loc5_:Vector.<uint> = null;
         if(this.FBtnStatus == TYPE_RESET_SINGLE)
         {
            if(this.FCharacter.CreditGold + this.FCharacter.CreditGiftCertificate < this.FCostResetGold)
            {
               this.FUIWindowRecharge.Visible = true;
               return;
            }
            _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_LOBBY_KillHeros_ResetReq);
            _loc3_ = _loc2_.Data;
            _loc3_.writeByte(TYPE_RESET_SINGLE);
            _loc3_.writeInt(this.FCurKillHeroId);
            SNetworkCore.Transceiver.PacketTransmit(_loc2_);
         }
         else if(this.FBtnStatus == TYPE_RESET_ALL)
         {
            _loc5_ = this.GetCanResetKillHeroIds();
            if(this.FCharacter.CreditGold + this.FCharacter.CreditGiftCertificate < this.FCostResetGold * _loc5_.length)
            {
               this.FUIWindowRecharge.Visible = true;
               return;
            }
            _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_LOBBY_KillHeros_ResetReq);
            _loc3_ = _loc2_.Data;
            _loc3_.writeByte(TYPE_RESET_ALL);
            _loc3_.writeInt(KILLHERO_CITYSTART_ID + this.FCurPage);
            SNetworkCore.Transceiver.PacketTransmit(_loc2_);
         }
      }
      
      protected function Btn_TowerLayerOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:MovieClip = null;
         var _loc6_:TUIButton = null;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         _loc6_ = param1 as TUIButton;
         if(!_loc6_.Enabled)
         {
            return;
         }
         _loc3_ = this.FBtn_TowerLayersA.indexOf(_loc6_);
         _loc10_ = this.UIIndexToTowerIndex(_loc3_);
         _loc9_ = int(RAIDERS_ID[_loc10_]);
         if(this.FCurRaidersID == _loc9_)
         {
            return;
         }
         this.FCurRaidersID = _loc9_;
         this.FCurPage = _loc10_ + 1;
         this.FMC_List.play();
         if(this.FCurPage < 1)
         {
            this.FCurPage = 1;
         }
         _loc7_ = (this.FCurPage - 1) * CAPACITY_CHECKPOINT - 1 + CAPACITY_CHECKPOINT;
         this.FCurKillHeroInfo = this.FKillHeroInfo.KillHeroInfo[_loc7_];
         if(!this.FCurKillHeroInfo.IsPassed)
         {
            _loc3_ = (this.FCurPage - 1) * CAPACITY_CHECKPOINT;
            while(_loc3_ < this.FCurPage * CAPACITY_CHECKPOINT + 5)
            {
               if(!this.FKillHeroInfo.KillHeroInfo[_loc3_].IsPassed)
               {
                  this.FCurKillHeroInfo = this.FKillHeroInfo.KillHeroInfo[_loc3_];
                  break;
               }
               _loc3_++;
            }
         }
         this.FCurKillHeroId = this.FCurKillHeroInfo.KillHeroId;
         this.UpdataKillHerosUI();
         this.CheckBtn();
      }
      
      protected function BtnSeeTreasureOnClick(param1:MouseEvent) : void
      {
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Treasure);
      }
      
      protected function BtnResetAllOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:Vector.<uint> = null;
         if(Boolean(param2.currentTarget) && !param2.currentTarget.buttonMode)
         {
            return;
         }
         _loc4_ = this.GetCanResetKillHeroIds();
         _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KILLHERO_STRING_05);
         _loc3_ = _loc3_.split("%count%").join(this.FCostResetGold * _loc4_.length);
         this.FUIWindowConfirmation.Text = _loc3_;
         this.FUIWindowConfirmation.OnOK = this.ResetSureOnOk;
         this.FUIWindowConfirmation.Visible = true;
         this.FBtnStatus = TYPE_RESET_ALL;
      }
      
      protected function SP_SelectHeroOnClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Sprite = null;
         _loc4_ = param1.currentTarget as Sprite;
         _loc2_ = this.FSP_CheckPoints.indexOf(_loc4_);
         _loc3_ = (this.FCurPage - 1) * CAPACITY_CHECKPOINT + _loc2_;
         if(_loc3_ > this.FKillHeroInfo.NewKillHeroIndex)
         {
            return;
         }
         this.FCurKillHeroInfo = this.FKillHeroInfo.KillHeroInfo[_loc3_];
         this.FCurKillHeroId = this.FCurKillHeroInfo.KillHeroId;
         this.UpdataKillHerosUI();
      }
      
      protected function SP_HeroOnRoll(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:Sprite = null;
         _loc3_ = param1.currentTarget as Sprite;
         _loc2_ = this.FSP_CheckPoints.indexOf(_loc3_);
         _loc4_ = this.FSP_HighLights[_loc2_];
         if(param1.type == MouseEvent.ROLL_OVER)
         {
            _loc4_.visible = true;
         }
         else if(param1.type == MouseEvent.ROLL_OUT)
         {
            _loc4_.visible = false;
         }
      }
      
      protected function BtnResetOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:TUIButton = null;
         var _loc5_:Vector.<uint> = null;
         _loc4_ = param1 as TUIButton;
         if(_loc4_ == this.FBtnReset)
         {
            if(_loc4_.Enabled)
            {
               _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KILLHERO_STRING_01);
               _loc3_ = _loc3_.split("%count%").join(this.FCostResetGold);
            }
            else
            {
               _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.COMMON_OPENVIPTIP);
               _loc3_ = TUtilityString.Format(_loc3_,this.FVipData.VipOpenLevel_DailyChaReset);
            }
         }
         else if(_loc4_ == this.FBtnResetAll)
         {
            if(_loc4_.Enabled)
            {
               _loc5_ = this.GetCanResetKillHeroIds();
               _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KILLHERO_STRING_02);
               _loc3_ = _loc3_.split("%count%").join(this.FCostResetGold * _loc5_.length);
            }
            else
            {
               _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.COMMON_OPENVIPTIP);
               _loc3_ = TUtilityString.Format(_loc3_,this.FVipData.VipOpenLevel_DailyChaReset);
               _loc5_ = this.GetCanResetKillHeroIds();
               if(_loc5_.length <= 0)
               {
                  _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KILLHERO_STRING_03);
               }
            }
         }
         if(!TUtilityString.Empty(_loc3_))
         {
            this.FHintBtnReset.Caption = _loc3_;
            if(this.FHintOnMove != null)
            {
               this.FHintOnMove(this,this.FHintBtnReset);
            }
         }
      }
      
      protected function BtnResetOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHintBtnReset);
         }
      }
      
      protected function SlotsOnMove(param1:Object, param2:Object) : void
      {
         if(this.FOnInventoryOver != null)
         {
            this.FOnInventoryOver(param1,param2);
         }
      }
      
      protected function SlotsOnOut(param1:Object, param2:Object) : void
      {
         if(this.FOnInventoryOut != null)
         {
            this.FOnInventoryOut(param1,param2);
         }
      }
      
      protected function HeroOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         var _loc8_:TBounds = null;
         var _loc9_:TCoordinate = null;
         var _loc10_:TRoleModel = null;
         var _loc11_:uint = 0;
         var _loc12_:int = 0;
         var _loc13_:uint = 0;
         var _loc14_:TUIHero = null;
         _loc5_ = param2 as uint;
         _loc13_ = this.FUIHeros.length;
         _loc12_ = 0;
         while(_loc12_ < _loc13_)
         {
            if(uint(this.FUIHeros[_loc12_].Context) == _loc5_)
            {
               _loc14_ = this.FUIHeros[_loc12_];
               break;
            }
            _loc12_++;
         }
         _loc6_ = SResourcesCore.TexturesModel;
         _loc10_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,_loc5_) as TRoleModel;
         _loc11_ = CONST_ROLE.GetModelIDByIndex(_loc10_.Model,CONST_ROLE.ROLE_SEQUENCEINDEX_FIGHTING_Standby);
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc11_);
         if(_loc7_ != null)
         {
            _loc8_ = new TBounds();
            _loc9_ = new TCoordinate();
            param3.Value = _loc7_.GetAnimationSequenceByIndex(param4);
            param3.Value.Evaluate(_loc9_,_loc8_);
            _loc14_.X = _loc8_.X;
            _loc14_.Y = _loc8_.Y;
         }
         else
         {
            _loc6_.LoadSecondary(_loc11_);
         }
         this.SetRoleModelID(_loc11_);
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
      
      protected function BtnChangeUpOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FBtnChangeUp.Visible = false;
         this.FStartTowerIndex = RAIDERS_ID.length - CONST_KILLHERO.CAPACITY_MC_TOWERLAYER;
         this.UpdataKillHerosUI();
         this.CheckBtn();
      }
      
      protected function BtnChangeDownOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FBtnChangeUp.Visible = true;
         this.FStartTowerIndex = 0;
         this.UpdataKillHerosUI();
         this.CheckBtn();
      }
      
      public function get OnInventoryOver() : Function
      {
         return this.FOnInventoryOver;
      }
      
      public function set OnInventoryOver(param1:Function) : void
      {
         this.FOnInventoryOver = param1;
      }
      
      public function get OnInventoryOut() : Function
      {
         return this.FOnInventoryOut;
      }
      
      public function set OnInventoryOut(param1:Function) : void
      {
         this.FOnInventoryOut = param1;
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
      
      public function get OnAddPopTips() : Function
      {
         return this.FOnAddPopTips;
      }
      
      public function set OnAddPopTips(param1:Function) : void
      {
         this.FOnAddPopTips = param1;
      }
      
      public function get OnFight() : Function
      {
         return this.FOnFight;
      }
      
      public function set OnFight(param1:Function) : void
      {
         this.FOnFight = param1;
      }
      
      public function get OnUpdateCityID() : Function
      {
         return this.FOnUpdateCityID;
      }
      
      public function set OnUpdateCityID(param1:Function) : void
      {
         this.FOnUpdateCityID = param1;
      }
      
      public function SetKillHeroData(param1:TKillHero, param2:Boolean = false, param3:uint = 0) : void
      {
         var _loc4_:int = 0;
         this.FKillHeroInfo = param1;
         _loc4_ = this.FKillHeroInfo.NewKillHeroIndex;
         this.FMaxPage = this.FKillHeroInfo.KillHeroInfo.length / CAPACITY_CHECKPOINT;
         this.FTotlePage = int(_loc4_ / CAPACITY_CHECKPOINT) + 1;
         if(!param2)
         {
            this.FCurPage = this.FTotlePage;
         }
         if(param3 != 0)
         {
            this.FCurKillHeroInfo = this.FKillHeroInfo.GetSingleKillHeroById(param3);
            this.FCurKillHeroId = param3;
            this.FCurPage = int(this.FKillHeroInfo.GetIndexById(param3) / CAPACITY_CHECKPOINT) + 1;
         }
         else if(!param2)
         {
            this.FCurKillHeroInfo = this.FKillHeroInfo.KillHeroInfo[_loc4_];
            this.FCurKillHeroId = this.FCurKillHeroInfo.KillHeroId;
         }
         this.FCurRaidersID = RAIDERS_ID[this.FCurPage - 1];
         if(this.Visible)
         {
            this.Updata();
         }
      }
      
      public function Updata() : void
      {
         if(this.FCurPage > CONST_KILLHERO.CAPACITY_MC_TOWERLAYER)
         {
            this.FBtnChangeUp.Visible = false;
            this.FStartTowerIndex = RAIDERS_ID.length - CONST_KILLHERO.CAPACITY_MC_TOWERLAYER;
         }
         this.UpdataKillHerosUI();
         this.CheckBtn();
      }
      
      public function ResetKillHeroData(param1:Vector.<uint>) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            this.FKillHeroInfo.ResetHero(param1[_loc2_]);
            _loc2_++;
         }
         this.SetKillHeroData(this.FKillHeroInfo,true);
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Bitmap = null;
         var _loc4_:uint = 0;
         this.FInventories.Clear();
         this.FBackgroundId = 0;
         if(this.FBackgroundBitmap != null)
         {
            this.FBackgroundBitmap.bitmapData = null;
         }
         if(this.FUIHeros != null)
         {
            _loc2_ = int(this.FUIHeros.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FUIHeros[_loc1_].Context = null;
               _loc1_++;
            }
         }
         if(this.FUISlots != null)
         {
            _loc2_ = int(this.FUISlots.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FUISlots[_loc1_].Context = null;
               _loc1_++;
            }
         }
         if(this.FBmp_Icons != null)
         {
            _loc2_ = CAPACITY_CHECKPOINT;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc3_ = this.FBmp_Icons[_loc1_];
               if(_loc3_ != null)
               {
                  _loc3_.bitmapData = null;
                  _loc3_.filters = [];
               }
               _loc1_++;
            }
         }
         _loc2_ = int(this.FRolesModelID.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = uint(this.FRolesModelID[_loc1_]);
            SResourcesCore.TexturesModel.DeleteByIdentifier(_loc4_,true);
            _loc1_++;
         }
         this.FRolesModelID.length = 0;
         this.FStartTowerIndex = 0;
         this.FBtnChangeUp.Visible = true;
      }
   }
}

