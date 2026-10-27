package Processors.Game.Lobby.WorldMapBleach.MonsterMap
{
   import Components.Slots.TUISlot;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Queries.TQueryString;
   import Foundation.Queries.Textures.TQueryAnimationSequence;
   import Foundation.Resources.Repositories.TResourceRepositoryTexture;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TAnimationFrame;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.Characters.TCharacter;
   import Logics.Characters.THero;
   import Logics.DatebaseVO.VO.Json.TFixedAward;
   import Logics.DatebaseVO.VO.TArticle;
   import Logics.DatebaseVO.VO.TAward;
   import Logics.DatebaseVO.VO.TBlockPoint;
   import Logics.DatebaseVO.VO.TEnemyArmy;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Logics.Items.TItems;
   import Logics.SLogicsCore;
   import Logics.Streamization.Inventories.TUnstreamizerInventoryReference;
   import Logics.Streamization.Items.TUnstreamizerRewards;
   import Logics.Vip.TVip;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.Hints.TOverlayerHint;
   import Rendering.Overlayers.Inventories.TOverlayerAppliance;
   import Rendering.Overlayers.TOverlayer;
   import Resources.Constants.CONST_BATTLE;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_FRESHGUIDE;
   import Resources.Constants.CONST_INVENTORY;
   import Resources.Constants.CONST_LOBBY;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_WORLDMAP;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   
   public class TProcessorWindowPassBoss extends TProcessorLobbyWindow
   {
      
      protected static const BOX_COUNT:int = 3;
      
      public static const CATEGORY_Normal:uint = CONST_INVENTORY.CATEGORY_Normal;
      
      public static const CATEGORY_Equipment:uint = CONST_INVENTORY.CATEGORY_Equipment;
      
      public static const CATEGORY_Gem:uint = CONST_INVENTORY.CATEGORY_Gem;
      
      public static const CATEGORY_Treasure:uint = CONST_INVENTORY.CATEGORY_Treasure;
      
      public static const CATEGORY_Material:uint = CONST_INVENTORY.CATEGORY_Material;
      
      public static const Status_Init:uint = 0;
      
      public static const Status_CanGet:uint = 1;
      
      public static const Status_CanReturn:uint = 2;
      
      public static const Status_BoxInit:uint = 0;
      
      public static const Status_BoxLookAt:uint = 1;
      
      public static const Status_BoxGet:uint = 2;
      
      public static const PASSTYPE_NODAL:int = CONST_BATTLE.BattleType_Nodal;
      
      public static const MAX_AWARDBOX_COUNT:uint = 3;
      
      public static const MAX_BASEAWARD_COUNT:uint = 3;
      
      protected var FScene:MovieClip;
      
      protected var FMC_MoveMan:MovieClip;
      
      protected var FMC_FirstMan:MovieClip;
      
      protected var FMC_SecondMan:MovieClip;
      
      protected var FMC_Main:MovieClip;
      
      protected var FMC_ReturnPrompt:MovieClip;
      
      protected var FMC_Star:MovieClip;
      
      protected var FMC_BaseAward:MovieClip;
      
      protected var FMC_Award:MovieClip;
      
      protected var FBtn_LookAt:MovieClip;
      
      protected var FMC_TopClip:MovieClip;
      
      protected var FMC_BottomClip:MovieClip;
      
      protected var FMC_Effect:MovieClip;
      
      protected var FBaseAwardVect:Vector.<MovieClip>;
      
      protected var FAwardBoxVect:Vector.<MovieClip>;
      
      protected var FPassNodalId:uint;
      
      protected var FReturnCityFun:Function;
      
      protected var FPassType:int;
      
      protected var FStarCount:int;
      
      protected var FLookCost:uint;
      
      protected var FCharacter:TCharacter;
      
      protected var FVipData:TVip;
      
      protected var FRewards:Vector.<TItems>;
      
      protected var UnstreamizerRewards:TUnstreamizerRewards;
      
      protected var FSelectIndex:int;
      
      protected var FIsInWorldMap:Boolean;
      
      protected var FStatus:uint;
      
      protected var FBoxStatus:uint;
      
      protected var FIDTemplates:Vector.<uint>;
      
      protected var FQualityTemplates:Vector.<uint>;
      
      protected var FInventories:TInventories;
      
      protected var FUISlots:Vector.<TUISlot>;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FOverlayerAppliance:TOverlayerAppliance;
      
      protected var FOverlayerHint:TOverlayerHint;
      
      protected var FPlayerRoleID:int;
      
      protected var FOnOverLayOver:Function;
      
      protected var FOnOverLayOut:Function;
      
      public function TProcessorWindowPassBoss(param1:TUIComponent, param2:Boolean)
      {
         super(param1);
         this.FIsInWorldMap = param2;
         this.FAwardBoxVect = new Vector.<MovieClip>();
         this.FBaseAwardVect = new Vector.<MovieClip>();
         this.FRewards = new Vector.<TItems>(BOX_COUNT);
         this.UnstreamizerRewards = new TUnstreamizerRewards();
         this.FIDTemplates = new Vector.<uint>(BOX_COUNT);
         this.FQualityTemplates = new Vector.<uint>(BOX_COUNT);
         this.FInventories = new TInventories();
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         this.FStatus = Status_Init;
         this.FBoxStatus = Status_BoxInit;
      }
      
      protected static function SlotsOnQuerySubscript(param1:Object, param2:Object, param3:TQueryString) : void
      {
         var _loc4_:TInventory = null;
         if(param2 is TInventory)
         {
            _loc4_ = param2 as TInventory;
            param3.Value = _loc4_.Quantity.toString();
         }
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_LOBBY_Hurdle_QueryChestRet,this.PacketPerform_SC_LookBoxInfo);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_LOBBY_Hurdle_ReceiveChestRet,this.PacketPerform_SC_GetBoxInfo);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_LOBBY_WorldMap_QueryChestRet,this.PacketPerform_SC_LookBoxInfo);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_LOBBY_WorldMap_ReceiveChestRet,this.PacketPerform_SC_GetBoxInfo);
         super.PacketRegisterRoutines();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ProcessorResize() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc1_ = FUICore.StageWidth;
         _loc2_ = FUICore.StageHeight;
      }
      
      protected function PacketPerform_SC_LookBoxInfo(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TItems = null;
         _loc3_ = 0;
         while(_loc3_ < BOX_COUNT)
         {
            _loc5_ = this.FRewards[_loc3_];
            if(_loc5_ == null)
            {
               _loc5_ = new TItems();
               this.FRewards[_loc3_] = _loc5_;
            }
            else
            {
               _loc5_.Clear();
            }
            _loc3_++;
         }
         _loc2_ = param1.Data;
         _loc4_ = _loc2_.readShort();
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this.FRewards[_loc3_];
            this.UnstreamizerRewards.Unstreamize(_loc2_,_loc5_,null);
            this.FRewards[_loc3_] = _loc5_;
            _loc3_++;
         }
         this.ShowReward(true);
      }
      
      protected function PacketPerform_SC_GetBoxInfo(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TItems = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         _loc3_ = 0;
         while(_loc3_ < BOX_COUNT)
         {
            _loc5_ = this.FRewards[_loc3_];
            if(_loc5_ == null)
            {
               _loc5_ = new TItems();
               this.FRewards[_loc3_] = _loc5_;
            }
            else
            {
               _loc5_.Clear();
            }
            _loc3_++;
         }
         _loc2_ = param1.Data;
         _loc6_ = uint(_loc2_.readInt());
         if(_loc6_ != 0)
         {
            return;
         }
         _loc7_ = uint(_loc2_.readByte());
         _loc4_ = _loc2_.readShort();
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this.FRewards[_loc3_];
            this.UnstreamizerRewards.Unstreamize(_loc2_,_loc5_,null);
            this.FRewards[_loc3_] = _loc5_;
            _loc3_++;
         }
         this.ShowReward(false);
         if(!hasEventListener(MouseEvent.MOUSE_DOWN))
         {
            addEventListener(MouseEvent.MOUSE_DOWN,this.OnReturnMonsterMap);
         }
      }
      
      protected function InitPassBossWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:Bitmap = null;
         if(this.FScene == null)
         {
            this.FScene = TUtilityReflection.CreateDisplayObjectInstance(CONST_WORLDMAP.RESOURCE_ClassName_PassBoss) as MovieClip;
            addChild(this.FScene);
            this.FMC_MoveMan = this.FScene[CONST_WORLDMAP.RESOURCE_Link_MC_MoveMan];
            this.FMC_FirstMan = this.FMC_MoveMan["MC_FirstMan"];
            _loc4_ = new Bitmap();
            this.FMC_FirstMan["FirstMan_Bitmap"] = _loc4_;
            this.FMC_FirstMan.addChild(_loc4_);
            _loc4_ = null;
            this.FMC_SecondMan = this.FMC_MoveMan["MC_SecondMan"];
            _loc4_ = new Bitmap();
            this.FMC_SecondMan["SecondMan_Bitmap"] = _loc4_;
            this.FMC_SecondMan.addChild(_loc4_);
            this.FMC_TopClip = this.FScene["MC_TopClip"];
            this.FMC_BottomClip = this.FScene["MC_BottomClip"];
            this.FMC_Main = this.FScene[CONST_WORLDMAP.RESOURCE_Link_MC_Main];
            this.FMC_Effect = this.FScene[CONST_WORLDMAP.RESOURCE_Link_FMC_Effect];
            this.FMC_Effect.stop();
            this.FMC_Effect.mouseChildren = false;
            this.FMC_Effect.mouseEnabled = false;
            this.FMC_ReturnPrompt = this.FMC_Main[CONST_WORLDMAP.RESOURCE_Link_MC_ReturnPrompt];
            this.FMC_Star = this.FMC_Main[CONST_WORLDMAP.RESOURCE_Link_MC_Star];
            this.FMC_BaseAward = this.FMC_Main[CONST_WORLDMAP.RESOURCE_Link_MC_BaseAward];
            this.FMC_Award = this.FMC_Main[CONST_WORLDMAP.RESOURCE_Link_MC_Award];
            this.FBtn_LookAt = this.FMC_Main[CONST_WORLDMAP.RESOURCE_Link_Btn_LookAt];
            _loc1_ = 0;
            while(_loc1_ < MAX_AWARDBOX_COUNT)
            {
               _loc3_ = this.FMC_Award[CONST_WORLDMAP.RESOURCE_Link_MC_Box + _loc1_];
               if(_loc3_)
               {
                  _loc3_.addEventListener(MouseEvent.MOUSE_DOWN,this.OnGetReward);
                  _loc3_.addEventListener(MouseEvent.MOUSE_MOVE,this.OnBoxOver);
                  _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this.OnBoxOut);
                  this.FAwardBoxVect.push(_loc3_);
               }
               _loc1_++;
            }
            _loc1_ = 0;
            while(_loc1_ < MAX_BASEAWARD_COUNT)
            {
               _loc3_ = this.FMC_BaseAward[CONST_WORLDMAP.RESOURCE_Link_MC_BaseAward_Element + _loc1_];
               if(_loc3_)
               {
                  _loc3_.visible = false;
                  this.FBaseAwardVect.push(_loc3_);
               }
               _loc1_++;
            }
         }
         this.FBtn_LookAt.visible = false;
         this.FMC_ReturnPrompt.visible = false;
         this.InitSlot();
         _loc1_ = 0;
         while(_loc1_ < this.FAwardBoxVect.length)
         {
            this.FAwardBoxVect[_loc1_].gotoAndStop(1);
            this.FAwardBoxVect[_loc1_].buttonMode = true;
            this.FAwardBoxVect[_loc1_].MC_AwardSlot.visible = false;
            this.FAwardBoxVect[_loc1_].TF_Name.visible = false;
            _loc1_++;
         }
         this.FStatus = Status_CanGet;
         this.FBoxStatus = Status_BoxInit;
         addEventListener(MouseEvent.CLICK,this.OnClick);
      }
      
      protected function InitBaseAward() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TBlockPoint = null;
         var _loc4_:TEnemyArmy = null;
         var _loc5_:TAward = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Vector.<TFixedAward> = null;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BlockPoint,this.FPassNodalId) as TBlockPoint;
         _loc6_ = int(_loc3_.Armys[0]);
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_EnemyArmy,_loc6_) as TEnemyArmy;
         _loc7_ = _loc4_.AwardId;
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Award,_loc7_) as TAward;
         _loc8_ = _loc5_.FixedAwards;
         _loc2_ = int(this.FBaseAwardVect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc1_ < _loc8_.length)
            {
               this.FBaseAwardVect[_loc1_].TF_AwardName.text = TUtilityLobby.GetItemName(_loc8_[_loc1_].Type,_loc8_[_loc1_].Code);
               this.FBaseAwardVect[_loc1_].TF_Value.text = _loc8_[_loc1_].Amount.toString();
            }
            else
            {
               this.FBaseAwardVect[_loc1_].visible = false;
            }
            _loc1_++;
         }
      }
      
      protected function InitSlot() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TUISlot = null;
         if(this.FUISlots != null)
         {
            return;
         }
         this.FUISlots = new Vector.<TUISlot>(BOX_COUNT);
         _loc1_ = 0;
         while(_loc1_ < BOX_COUNT)
         {
            _loc2_ = this.GetSlot();
            _loc2_.Resource = this.FAwardBoxVect[_loc1_].MC_AwardSlot;
            _loc2_.OnOver = this.OnSlotOver;
            _loc2_.OnOut = this.OnSlotOut;
            _loc2_.Init();
            this.FUISlots[_loc1_] = _loc2_;
            _loc1_++;
         }
      }
      
      protected function GetSlot() : TUISlot
      {
         var _loc1_:TUISlot = null;
         _loc1_ = new TUISlot(this);
         _loc1_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         _loc1_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
         _loc1_.OnQuerySubscript = SlotsOnQuerySubscript;
         return _loc1_;
      }
      
      protected function PlayMovie() : void
      {
         this.FScene.play();
         this.FMC_Main.play();
         this.FMC_MoveMan.play();
         this.PlayStarMovie();
         this.FMC_TopClip.gotoAndPlay(1);
         this.FMC_BottomClip.gotoAndPlay(1);
         this.FMC_Effect.play();
      }
      
      protected function PlayStarMovie() : void
      {
         this.FMC_Star.gotoAndStop(this.FStarCount);
         this.FMC_Star.star.play();
      }
      
      protected function ShowReward(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:TArticle = null;
         var _loc6_:MovieClip = null;
         var _loc7_:TInventory = null;
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_OpenCard);
         _loc4_ = "";
         this.FIDTemplates.length = 0;
         this.FQualityTemplates.length = 0;
         _loc2_ = 0;
         while(_loc2_ < MAX_AWARDBOX_COUNT)
         {
            _loc6_ = this.FAwardBoxVect[_loc2_];
            _loc6_.buttonMode = param1;
            if(!param1)
            {
               if(_loc2_ == this.FSelectIndex)
               {
                  _loc6_.gotoAndStop(3);
               }
               else
               {
                  _loc6_.gotoAndStop(4);
               }
            }
            this.FIDTemplates.push(this.FRewards[_loc2_].ItemIDs[0].ID);
            this.FQualityTemplates.push(this.FRewards[_loc2_].ItemIDs[0].Count);
            this.FAwardBoxVect[_loc2_].MC_AwardSlot.visible = true;
            this.FAwardBoxVect[_loc2_].TF_Name.visible = true;
            _loc2_++;
         }
         this.FInventories.Clear();
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,this.FInventories,this.FIDTemplates);
         _loc2_ = 0;
         while(_loc2_ < this.FInventories.Count)
         {
            _loc7_ = this.FInventories.GetInventoryByIndex(_loc2_);
            _loc7_.Quantity = this.FQualityTemplates[_loc2_];
            this.FUISlots[_loc2_].Context = _loc7_;
            this.FAwardBoxVect[_loc2_].TF_Name.text = _loc7_.Name;
            _loc2_++;
         }
      }
      
      protected function UIComponentsApplianceOnOver(param1:Object, param2:Object) : void
      {
         var _loc3_:TInventory = null;
         var _loc4_:TOverlayer = null;
         _loc3_ = param2 as TInventory;
         switch(_loc3_.Category)
         {
            case CATEGORY_Equipment:
            case CATEGORY_Treasure:
               break;
            default:
               _loc4_ = this.FOverlayerAppliance;
         }
         if(_loc4_ != null)
         {
            _loc4_.Context = _loc3_;
            _loc4_.Render(FUICore.MouseCoordinate);
            _loc4_.Show();
         }
      }
      
      protected function UIComponentsApplianceOnOut(param1:Object, param2:Object) : void
      {
         var _loc3_:TInventory = null;
         var _loc4_:TOverlayer = null;
         _loc3_ = param2 as TInventory;
         switch(_loc3_.Category)
         {
            case CATEGORY_Equipment:
            case CATEGORY_Treasure:
               break;
            default:
               _loc4_ = this.FOverlayerAppliance;
         }
         if(_loc4_ != null)
         {
            _loc4_.Hide();
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
      
      protected function OnGetReward(param1:MouseEvent = null) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         if(this.FStatus != Status_CanGet)
         {
            return;
         }
         this.FStatus = Status_CanReturn;
         if(Boolean(param1) && Boolean(param1.currentTarget))
         {
            this.FSelectIndex = int(String(param1.currentTarget.name).slice(7));
         }
         else
         {
            this.FSelectIndex = int(Math.random() * 3);
         }
         if(this.FIsInWorldMap)
         {
            _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_LOBBY_WorldMap_ReceiveChest);
         }
         else
         {
            _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_LOBBY_Hurdle_ReceiveChest);
         }
         _loc3_ = _loc2_.Data;
         _loc3_.writeByte(this.FSelectIndex);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
         this.FMC_ReturnPrompt.visible = true;
         this.FBoxStatus = Status_BoxGet;
      }
      
      protected function OnReturnMonsterMap(param1:MouseEvent) : void
      {
         if(this.FStatus != Status_CanReturn)
         {
            return;
         }
         this.FStatus = Status_Init;
         this.FBoxStatus = Status_BoxInit;
         this.FReturnCityFun(this);
         SUtilityOverLayer.HideTip();
         if(hasEventListener(MouseEvent.MOUSE_DOWN))
         {
            removeEventListener(MouseEvent.MOUSE_DOWN,this.OnReturnMonsterMap);
         }
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClickAnyWhere);
         param1.stopImmediatePropagation();
         this.FMC_Effect.stop();
      }
      
      protected function OnSlotOver(param1:Object, param2:TInventory) : void
      {
         if(this.FOnOverLayOver != null)
         {
            this.FOnOverLayOver(param1,param2);
         }
      }
      
      protected function OnSlotOut(param1:Object, param2:TInventory) : void
      {
         if(this.FOnOverLayOut != null)
         {
            this.FOnOverLayOut(param1,param2);
         }
      }
      
      protected function OnBoxOver(param1:MouseEvent) : void
      {
         if(this.FBoxStatus == Status_BoxInit)
         {
            MovieClip(param1.currentTarget).gotoAndStop(2);
            return;
         }
      }
      
      protected function OnBoxOut(param1:MouseEvent) : void
      {
         if(this.FBoxStatus == Status_BoxInit)
         {
            MovieClip(param1.currentTarget).gotoAndStop(1);
            return;
         }
      }
      
      public function get OnOverLayOver() : Function
      {
         return this.FOnOverLayOver;
      }
      
      public function set OnOverLayOver(param1:Function) : void
      {
         this.FOnOverLayOver = param1;
      }
      
      public function get OnOverLayOut() : Function
      {
         return this.FOnOverLayOut;
      }
      
      public function set OnOverLayOut(param1:Function) : void
      {
         this.FOnOverLayOut = param1;
      }
      
      public function SetPassBossWindow(param1:int, param2:uint, param3:int, param4:Function = null) : void
      {
         this.FCharacter = SLogicsCore.Character;
         this.FPlayerRoleID = THero(this.FCharacter.Heros.GetHeroByIndex(0)).Identifier;
         this.FPassType = param1;
         this.FPassNodalId = param2;
         this.FStarCount = param3;
         this.FReturnCityFun = param4;
         this.FSelectIndex = -1;
         this.InitPassBossWindow();
      }
      
      public function ShowWindows() : void
      {
         this.InitBaseAward();
         this.PlayMovie();
         if(hasEventListener(MouseEvent.MOUSE_DOWN))
         {
            removeEventListener(MouseEvent.MOUSE_DOWN,this.OnReturnMonsterMap);
         }
      }
      
      public function HideBaseReward() : void
      {
         if(this.FMC_BaseAward)
         {
            this.FMC_BaseAward.visible = false;
         }
      }
      
      public function UpdataSlot() : void
      {
         var _loc1_:uint = 0;
         if(visible == false)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < this.FUISlots.length)
         {
            this.FUISlots[_loc1_].Update();
            _loc1_++;
         }
      }
      
      public function OnClick(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
      }
      
      public function LogicsPerform_PlayerRole() : void
      {
         var _loc1_:TResourceRepositoryTexture = null;
         var _loc2_:TTexture = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         if(this.FMC_FirstMan["FirstMan_Bitmap"] != null && this.FMC_FirstMan["FirstMan_Bitmap"].bitmapData == null && this.FMC_SecondMan["SecondMan_Bitmap"] != null && this.FMC_SecondMan["SecondMan_Bitmap"].bitmapData == null)
         {
            _loc4_ = this.FPlayerRoleID.toString();
            _loc3_ = int(_loc4_.slice(_loc4_.length - 1,_loc4_.length));
            _loc1_ = SResourcesCore.TexturesLargeIcon;
            _loc2_ = _loc1_.GetTextureByIdentifier(_loc3_);
            if(_loc2_ != null)
            {
               this.FMC_FirstMan.FirstMan_Bitmap.bitmapData = ((_loc2_.GetAnimationSequenceByIdentifier(0) as TAnimationSequence).GetAnimationFrameByIndex(0) as TAnimationFrame).Surface;
               this.FMC_SecondMan.SecondMan_Bitmap.bitmapData = ((_loc2_.GetAnimationSequenceByIdentifier(0) as TAnimationSequence).GetAnimationFrameByIndex(0) as TAnimationFrame).Surface;
            }
            else
            {
               _loc1_.LoadPrimary(_loc3_);
            }
         }
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         if(this.FMC_FirstMan != null && this.FMC_FirstMan.FirstMan_Bitmap != null)
         {
            this.FMC_FirstMan.FirstMan_Bitmap.bitmapData = null;
         }
         if(this.FMC_SecondMan != null && this.FMC_SecondMan.SecondMan_Bitmap != null)
         {
            this.FMC_SecondMan.SecondMan_Bitmap.bitmapData = null;
         }
         if(this.FUISlots != null)
         {
            _loc1_ = 0;
            while(_loc1_ < this.FUISlots.length)
            {
               this.FUISlots[_loc1_].Context = null;
               _loc1_++;
            }
         }
         if(this.FMC_Effect != null)
         {
            this.FMC_Effect.stop();
         }
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         this.Reset();
      }
   }
}

