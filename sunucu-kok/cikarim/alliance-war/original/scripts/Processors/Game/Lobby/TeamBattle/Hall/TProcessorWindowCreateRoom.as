package Processors.Game.Lobby.TeamBattle.Hall
{
   import Components.Pages.*;
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Common.THint;
   import Foundation.Network.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.TCharacter;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.Streamization.Inventories.*;
   import Logics.TeamBattle.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.TeamBattle.Hall.Components.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorWindowCreateRoom extends TProcessorLobbyWindow
   {
      
      protected static const CAPACITY_MapList:uint = CONST_TEAMBATTLE.CAPACITY_MapList;
      
      protected static const CAPACITY_Reward_Slots:uint = CONST_TEAMBATTLE.CAPACITY_Reward_Slots;
      
      protected static const FRAME_PVE_Normal:uint = CONST_TEAMBATTLE.FRAME_PVE_Normal;
      
      protected static const FRAME_PVE_Hard:uint = CONST_TEAMBATTLE.FRAME_PVE_Hard;
      
      protected static const TYPE_EnterCreateRoom_Hall:uint = CONST_TEAMBATTLE.TYPE_EnterCreateRoom_Hall;
      
      protected static const TYPE_EnterCreateRoom_Room:uint = CONST_TEAMBATTLE.TYPE_EnterCreateRoom_Room;
      
      protected var FCharacter:TCharacter;
      
      protected var FTeamBattle:TTeamBattle;
      
      protected var FLeagueMapPves:TBins;
      
      protected var FHint:THint;
      
      protected var FInventories:TInventories;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FMC_TeamBattleCreateRoom:MovieClip;
      
      protected var FSP_Map:Sprite;
      
      protected var FTF_Title:TextField;
      
      protected var FTF_Level:TextField;
      
      protected var FMC_Background:MovieClip;
      
      protected var FSP_ImagePoint:Sprite;
      
      protected var FBmpIcon:Bitmap;
      
      protected var FSP_Reward:Sprite;
      
      protected var FMC_Reward:MovieClip;
      
      protected var FSP_UnlockLevel:Sprite;
      
      protected var FTF_Count:TextField;
      
      protected var FTF_RecommendLevel:TextField;
      
      protected var FBtn_Create:TUIButton;
      
      protected var FBtn_ReturnHall:TUIButton;
      
      protected var FUISlots:Vector.<TUISlot>;
      
      protected var FMC_MapList:MovieClip;
      
      protected var FMC_EffectLeft:MovieClip;
      
      protected var FMC_EffectRight:MovieClip;
      
      protected var FMC_EffectLeftTop:MovieClip;
      
      protected var FMC_EffectRightTop:MovieClip;
      
      protected var FUIPage:TUIPage;
      
      protected var FUIMaps:Vector.<TUIMap>;
      
      protected var FPageIndex:int;
      
      protected var FMapIndex:int;
      
      protected var FTypeEnterCreateRoom:uint;
      
      protected var FInitialization:Boolean;
      
      protected var FHintOnOver:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FOnAgainChoose:Function;
      
      protected var FOnReturnHall:Function;
      
      public function TProcessorWindowCreateRoom(param1:TUIComponent)
      {
         super(param1);
         this.FCharacter = SLogicsCore.Character;
         this.FTeamBattle = SLogicsCore.TeamBattle;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_TEAMBATTLE.RESOURCESID_Swf_TeamBattleCreateRoom);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:MovieClip = null;
         var _loc4_:TUIMap = null;
         var _loc5_:TUISlot = null;
         this.FMC_TeamBattleCreateRoom = TUtilityReflection.CreateDisplayObjectInstance(CONST_TEAMBATTLE.RESOURCE_ClassName_MC_TeamBattleCreateRoom) as MovieClip;
         this.FMC_TeamBattleCreateRoom.gotoAndStop(1);
         addChild(this.FMC_TeamBattleCreateRoom);
         this.FSP_Map = this.FMC_TeamBattleCreateRoom[CONST_TEAMBATTLE.RESOURCE_Link_SP_Map];
         this.FMC_EffectLeft = this.FSP_Map[CONST_TEAMBATTLE.RESOURCE_Link_MC_EffectLeft];
         this.FMC_EffectRight = this.FSP_Map[CONST_TEAMBATTLE.RESOURCE_Link_MC_EffectRight];
         this.FMC_EffectLeft.stop();
         this.FMC_EffectRight.stop();
         _loc2_ = this.FSP_Map[CONST_TEAMBATTLE.RESOURCE_Link_SP_TitlePVE];
         this.FTF_Title = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_TF_Title];
         this.FTF_Level = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_TF_Level];
         this.FTF_Title.text = "";
         this.FTF_Level.text = "";
         this.FMC_Background = this.FSP_Map[CONST_TEAMBATTLE.RESOURCE_Link_MC_Background];
         this.FSP_ImagePoint = this.FSP_Map[CONST_TEAMBATTLE.RESOURCE_Link_SP_ImagePoint];
         this.FBmpIcon = new Bitmap();
         this.FSP_ImagePoint.addChild(this.FBmpIcon);
         this.FSP_Reward = this.FMC_TeamBattleCreateRoom[CONST_TEAMBATTLE.RESOURCE_Link_SP_Reward];
         this.FMC_Reward = this.FSP_Reward[CONST_TEAMBATTLE.RESOURCE_Link_MC_Reward];
         this.FSP_UnlockLevel = this.FSP_Reward[CONST_TEAMBATTLE.RESOURCE_Link_SP_UnlockLevel];
         this.FSP_UnlockLevel.visible = false;
         _loc2_ = this.FSP_Reward[CONST_TEAMBATTLE.RESOURCE_Link_SP_Texts];
         this.FTF_Count = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_TF_Count];
         this.FTF_RecommendLevel = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_TF_Level];
         _loc2_ = this.FSP_Reward[CONST_TEAMBATTLE.RESOURCE_Link_SP_Create];
         this.FBtn_Create = new TUIButton();
         this.FBtn_Create.Substrate = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_Btn_Create];
         this.FBtn_Create.OnClick = this.Btn_CreateOnClick;
         this.FBtn_ReturnHall = new TUIButton();
         this.FBtn_ReturnHall.Substrate = this.FSP_Reward[CONST_TEAMBATTLE.RESOURCE_Link_Btn_ReturnHall];
         this.FBtn_ReturnHall.OnClick = this.Btn_ReturnHallOnClick;
         this.FUISlots = new Vector.<TUISlot>(CAPACITY_Reward_Slots);
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Reward_Slots)
         {
            _loc5_ = new TUISlot(this);
            _loc5_.Resource = this.FMC_Reward[CONST_TEAMBATTLE.RESOURCE_Link_MC_Slot + _loc1_];
            _loc5_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
            _loc5_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc5_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            _loc5_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
            _loc5_.Init();
            this.FUISlots[_loc1_] = _loc5_;
            _loc1_++;
         }
         this.FMC_MapList = this.FMC_TeamBattleCreateRoom[CONST_TEAMBATTLE.RESOURCE_Link_MC_MapList];
         this.FMC_MapList.gotoAndStop(1);
         this.FUIPage = new TUIPage(null);
         this.FUIPage.OnChangePage = this.PageOnChange;
         this.FUIPage.ButtonPrevious.Substrate = this.FMC_MapList[CONST_COMMON.RESOURCE_Link_MC_PageLeft];
         this.FUIPage.ButtonNext.Substrate = this.FMC_MapList[CONST_COMMON.RESOURCE_Link_MC_PageRight];
         _loc2_ = this.FMC_MapList[CONST_TEAMBATTLE.RESOURCE_Link_SP_Page];
         this.FUIPage.LabelPage = _loc2_[CONST_COMMON.RESOURCE_Link_TF_Page];
         this.FUIPage.LabelPage.text = "0/0";
         this.FUIPage.PageSize = CAPACITY_MapList;
         this.FUIPage.Init();
         this.FUIPage.ButtonPrevious.Visible = false;
         this.FUIPage.ButtonNext.Visible = false;
         this.FUIMaps = new Vector.<TUIMap>(CAPACITY_MapList);
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_MapList)
         {
            _loc4_ = new TUIMap(null);
            _loc4_.Resource = this.FMC_MapList[CONST_TEAMBATTLE.RESOURCE_Link_SP_Map_Item + _loc1_];
            _loc4_.Perform_UIDispatch();
            _loc4_.Visible = false;
            _loc4_.OnClick = this.UIMapOnClick;
            _loc4_.OnOver = this.UIMapOnOver;
            _loc4_.OnOut = this.UIMapOnOut;
            this.FUIMaps[_loc1_] = _loc4_;
            _loc1_++;
         }
         this.FLeagueMapPves = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_LeagueMapPve);
         this.FHint = new THint();
         this.FInventories = new TInventories();
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FInitialization = true;
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         super.LogicsPerform();
         if(this.Visible)
         {
            if(this.FInitialization)
            {
               if(this.FMC_TeamBattleCreateRoom.isPlaying)
               {
                  this.LogicsPerform_EffectStart();
               }
               if(this.FMC_MapList.isPlaying)
               {
                  this.LogicsPerform_EffectMapList();
               }
               if(this.FMC_EffectLeft.isPlaying)
               {
                  this.LogicsPerform_EffectLeft();
               }
               if(this.FMC_EffectRight.isPlaying)
               {
                  this.LogicsPerform_EffectRight();
               }
               if(this.FMC_EffectLeftTop == null)
               {
                  this.FMC_EffectLeftTop = this.FMC_EffectLeft[CONST_TEAMBATTLE.RESOURCE_Link_MC_EffectTop];
                  if(this.FMC_EffectLeftTop != null && !this.FMC_EffectLeftTop.isPlaying)
                  {
                     this.FMC_EffectLeftTop.play();
                  }
               }
               if(this.FMC_EffectRightTop == null)
               {
                  this.FMC_EffectRightTop = this.FMC_EffectRight[CONST_TEAMBATTLE.RESOURCE_Link_MC_EffectTop];
                  if(this.FMC_EffectRightTop != null && !this.FMC_EffectRightTop.isPlaying)
                  {
                     this.FMC_EffectRightTop.play();
                  }
               }
               _loc1_ = 0;
               while(_loc1_ < CAPACITY_Reward_Slots)
               {
                  this.FUISlots[_loc1_].Update();
                  _loc1_++;
               }
            }
         }
      }
      
      protected function LogicsPerform_EffectStart() : void
      {
         if(this.FMC_TeamBattleCreateRoom.currentFrame == this.FMC_TeamBattleCreateRoom.totalFrames)
         {
            this.FMC_TeamBattleCreateRoom.stop();
            this.FMC_MapList.play();
         }
      }
      
      protected function LogicsPerform_EffectMapList() : void
      {
         if(this.FMC_MapList.currentFrame == this.FMC_MapList.totalFrames)
         {
            this.FMC_MapList.stop();
            this.FUIMaps[this.FMapIndex].ShowHighLight();
            this.FUIPage.ButtonPrevious.Visible = true;
            this.FUIPage.ButtonNext.Visible = true;
         }
      }
      
      protected function LogicsPerform_EffectLeft() : void
      {
         if(this.FMC_EffectLeft.currentFrame == this.FMC_EffectLeft.totalFrames)
         {
            this.FMC_EffectLeft.stop();
         }
      }
      
      protected function LogicsPerform_EffectRight() : void
      {
         if(this.FMC_EffectRight.currentFrame == this.FMC_EffectRight.totalFrames)
         {
            this.FMC_EffectRight.stop();
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
         this.X = (_loc1_ - this.FMC_TeamBattleCreateRoom.width) / 2 + 30;
         this.Y = (_loc2_ - this.FMC_TeamBattleCreateRoom.height) / 2;
      }
      
      protected function ProcessorSetMapPosition() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TLeagueMapPve = null;
         _loc2_ = this.FLeagueMapPves.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = this.FLeagueMapPves.GetDatebaseByIndex(_loc1_) as TLeagueMapPve;
            if(this.FTeamBattle.CurPveModelID == _loc5_.Identifier)
            {
               break;
            }
            _loc1_++;
         }
         _loc3_ = _loc1_ / CAPACITY_MapList;
         this.FUIPage.PageIndex = _loc3_;
         this.PageOnChange(this,_loc3_);
         this.FPageIndex = _loc3_;
         _loc4_ = _loc1_ % CAPACITY_MapList;
         this.FUIMaps[_loc4_].ShowHighLight();
         this.FMapIndex = _loc4_;
      }
      
      protected function ProcessorUpdateUIMap() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         var _loc5_:TLeagueMapPve = null;
         var _loc6_:Vector.<uint> = null;
         _loc5_ = this.FLeagueMapPves.GetDatebaseByIdentifier(this.FTeamBattle.SelectModelID) as TLeagueMapPve;
         _loc4_ = uint(_loc5_.Identifier);
         if(_loc4_ % 2 == 0)
         {
            this.FMC_Background.gotoAndStop(FRAME_PVE_Hard);
            this.FMC_Reward.gotoAndStop(FRAME_PVE_Hard);
            _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_03);
            _loc2_ = CONST_TEAMBATTLE.COLOR_PVE_HARD;
         }
         else
         {
            this.FMC_Background.gotoAndStop(FRAME_PVE_Normal);
            this.FMC_Reward.gotoAndStop(FRAME_PVE_Normal);
            _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_02);
            _loc2_ = CONST_TEAMBATTLE.COLOR_PVE_NORMAL;
         }
         this.FTF_Title.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_11),_loc5_.Name,_loc3_);
         this.FTF_Title.textColor = _loc2_;
         this.FTF_Level.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_10),_loc5_.SuitableLevel);
         this.FTF_Count.text = this.FTeamBattle.PVERewardCount.toString();
         this.FTF_RecommendLevel.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_14),_loc5_.RecommendLevel);
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Reward_Slots)
         {
            this.FUISlots[_loc1_].Context = null;
            _loc1_++;
         }
         _loc6_ = _loc5_.Awards;
         this.FInventories.Clear();
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,this.FInventories,_loc6_);
         _loc1_ = 0;
         while(_loc1_ < this.FInventories.Count)
         {
            this.FUISlots[_loc1_].Context = this.FInventories.GetInventoryByIndex(_loc1_);
            _loc1_++;
         }
         this.FBmpIcon.bitmapData = null;
         SResourcesCore.TexturesMiddlePic.LoadAutoSecondary(_loc5_.ImageID,this.AutoLoadCallBack);
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         _loc4_ = param2.GetAnimationSequenceByIndex(1);
         this.FBmpIcon.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
      }
      
      protected function UpdateMapsUIPage() : void
      {
         this.FUIPage.TotalQuantity = this.FLeagueMapPves.Count;
         this.FUIPage.PageIndex = this.FPageIndex;
         this.FUIPage.Update();
      }
      
      protected function ProcessorUpdateUIMapList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TUIMap = null;
         var _loc6_:TBins = null;
         var _loc7_:TLeagueMapPve = null;
         _loc4_ = this.FPageIndex;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_MapList)
         {
            _loc5_ = this.FUIMaps[_loc1_];
            _loc5_.Context = null;
            _loc5_.Visible = false;
            _loc1_++;
         }
         _loc2_ = this.FLeagueMapPves.Count;
         if(_loc2_ <= 0)
         {
            return;
         }
         _loc3_ = _loc4_ * CAPACITY_MapList;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_MapList)
         {
            if(_loc1_ + _loc3_ >= _loc2_)
            {
               break;
            }
            _loc5_ = this.FUIMaps[_loc1_];
            _loc7_ = this.FLeagueMapPves.GetDatebaseByIndex(_loc1_ + _loc3_) as TLeagueMapPve;
            _loc5_.Context = _loc7_;
            _loc5_.Visible = true;
            _loc1_++;
         }
      }
      
      protected function PageOnChange(param1:Object, param2:int) : void
      {
         this.FPageIndex = param2;
         this.ProcessorUpdateUIMapList();
      }
      
      protected function UIMapOnClick(param1:Object, param2:TLeagueMapPve) : void
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < CAPACITY_MapList)
         {
            this.FUIMaps[_loc3_].HideHighLight();
            _loc3_++;
         }
         this.FTeamBattle.SelectModelID = param2.Identifier;
         this.ProcessorUpdateUIMap();
      }
      
      protected function UIMapOnOver(param1:Object, param2:TLeagueMapPve) : void
      {
         var _loc3_:String = null;
         var _loc4_:TModel = null;
         _loc4_ = this.FTeamBattle.PVEModels.GetModelByIdentifier(param2.Identifier);
         if(_loc4_.IsUnlock)
         {
            return;
         }
         if(param2.Identifier % 2 == 0)
         {
            _loc3_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_61),param2.Name);
         }
         else
         {
            _loc3_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_62),param2.Name,param2.OpenLevel);
         }
         this.FHint.Caption = _loc3_;
         if(this.FHintOnOver != null)
         {
            this.FHintOnOver(this,this.FHint);
         }
      }
      
      protected function UIMapOnOut(param1:Object, param2:TLeagueMapPve) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHint);
         }
      }
      
      protected function Btn_CreateOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         var _loc5_:String = null;
         if(this.FTypeEnterCreateRoom == TYPE_EnterCreateRoom_Hall)
         {
            _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TeamBattleHall_CreatePlayerRoom);
            _loc4_ = _loc3_.Data;
            _loc4_.writeByte(this.FTeamBattle.ModeType);
            _loc4_.writeUnsignedInt(this.FTeamBattle.SelectModelID);
            _loc5_ = "";
            if(this.FTeamBattle.IsCreatePassword)
            {
               _loc5_ = this.FTeamBattle.Password;
            }
            TUtilityString.FlushUTF(_loc4_,_loc5_);
            SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         }
         else if(this.FTypeEnterCreateRoom == TYPE_EnterCreateRoom_Room)
         {
            this.FTeamBattle.AgainModelID = this.FTeamBattle.SelectModelID;
            this.FTeamBattle.SelectModelID = this.FTeamBattle.BakModelID;
            this.FTeamBattle.BakModelID = 0;
            if(this.FOnAgainChoose != null)
            {
               this.FOnAgainChoose(this);
            }
         }
      }
      
      protected function Btn_ReturnHallOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnReturnHall != null)
         {
            this.FOnReturnHall(this,this.FTypeEnterCreateRoom);
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
      
      public function get OnAgainChoose() : Function
      {
         return this.FOnAgainChoose;
      }
      
      public function set OnAgainChoose(param1:Function) : void
      {
         this.FOnAgainChoose = param1;
      }
      
      public function get OnReturnHall() : Function
      {
         return this.FOnReturnHall;
      }
      
      public function set OnReturnHall(param1:Function) : void
      {
         this.FOnReturnHall = param1;
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         if(!this.FInitialization)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Reward_Slots)
         {
            this.FUISlots[_loc1_].Context = null;
            _loc1_++;
         }
         this.FMC_TeamBattleCreateRoom.gotoAndStop(1);
         this.FMC_EffectLeft.gotoAndStop(1);
         this.FMC_EffectRight.gotoAndStop(1);
         if(this.FMC_EffectLeftTop != null)
         {
            this.FMC_EffectLeftTop.gotoAndStop(1);
            this.FMC_EffectLeftTop = null;
         }
         if(this.FMC_EffectRightTop != null)
         {
            this.FMC_EffectRightTop.gotoAndStop(1);
            this.FMC_EffectRightTop = null;
         }
         if(this.FBmpIcon != null && this.FBmpIcon.bitmapData != null)
         {
            this.FBmpIcon.bitmapData = null;
         }
         this.FInventories.Clear();
         this.FMC_MapList.gotoAndStop(1);
         this.FPageIndex = 0;
         this.FMapIndex = 0;
         this.FTypeEnterCreateRoom = 0;
         this.FUIPage.ButtonPrevious.Visible = false;
         this.FUIPage.ButtonNext.Visible = false;
      }
      
      public function Update(param1:uint) : void
      {
         this.FMC_TeamBattleCreateRoom.play();
         this.FMC_EffectLeft.play();
         this.FMC_EffectRight.play();
         if(param1 == TYPE_EnterCreateRoom_Room)
         {
            this.FTeamBattle.BakModelID = this.FTeamBattle.SelectModelID;
            this.FTeamBattle.SelectModelID = this.FTeamBattle.CurPveModelID;
         }
         else if(param1 == TYPE_EnterCreateRoom_Hall)
         {
            this.FTeamBattle.SelectModelID = this.FTeamBattle.CurPveModelID;
         }
         this.FTypeEnterCreateRoom = param1;
         this.UpdateMapsUIPage();
         this.ProcessorSetMapPosition();
         this.ProcessorUpdateUIMapList();
         this.ProcessorUpdateUIMap();
      }
   }
}

