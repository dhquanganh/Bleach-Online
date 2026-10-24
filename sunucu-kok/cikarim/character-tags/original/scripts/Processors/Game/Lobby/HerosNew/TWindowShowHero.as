package Processors.Game.Lobby.HerosNew
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Common.THint;
   import Foundation.Container.THashMap;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Queries.TQueryUInt;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityTexture;
   import Logics.Agent.SParametersCore;
   import Logics.Characters.MainRoleWake.THeroWakeData;
   import Logics.Characters.MainRoleWake.THeroWakeEquipment;
   import Logics.Characters.THero;
   import Logics.DatebaseVO.VO.Json.TRewards;
   import Logics.DatebaseVO.VO.TWakeUp;
   import Logics.DatebaseVO.VO.TWakeUpEquip;
   import Logics.Inventories.TCollectionInventory;
   import Logics.Inventories.TEquipment;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Logics.Inventories.TInventoryWake;
   import Logics.Map.TMoudleInfor;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudle;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.HeroChange.TProcessorWindowHeroChangeMainUI;
   import Processors.Game.Lobby.HerosNew.Component.THeroWakeSlot;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_LOBBY;
   import Resources.Constants.CONST_MAP;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.ByteArray;
   
   public class TWindowShowHero extends TProcessorLobbyWindow
   {
      
      protected static const ShowType_Equipment:int = 0;
      
      protected static const ShowType_Decoration:int = 1;
      
      protected static const ShowType_WakeUp:int = 2;
      
      protected static const DecorationSlotNum:int = 8;
      
      protected static const EquipmentSlotNum:int = 6;
      
      protected static const WakeUpSlotNum:int = 8;
      
      protected var FHint:THint;
      
      protected var StarBadge:TextField;
      
      protected var StarMarker:Sprite;
      
      protected var StarIcon:Bitmap;
      
      protected var StarIconLoader:Loader;
      
      protected var FHero:THero;
      
      protected var FShowType:int;
      
      protected var FSpriteMoudle:TSceneSpriteMoudle;
      
      protected var FQureyMoudleInfor:TMoudleInfor;
      
      protected var FBtnUnload:TUIButton;
      
      protected var FBtnWake:TUIButton;
      
      protected var FCategorySeconds:Vector.<int>;
      
      protected var FEquipmentSlotPanle:Sprite;
      
      protected var FEquipmentSlots:Vector.<TUISlot>;
      
      protected var FDecorationSlotPanle:Sprite;
      
      protected var FDecorationSlots:Vector.<TUISlot>;
      
      protected var FWakeUpSlotPanle:Sprite;
      
      protected var FWakeUpSlots:Vector.<THeroWakeSlot>;
      
      protected var FWakeUpSlotOnClick:Function;
      
      protected var FHeroWakeSlotPanle:Sprite;
      
      protected var FHeroWakeSlots:Vector.<TUISlot>;
      
      protected var FHeroSlotOnClick:Function;
      
      protected var FWakeUpBackInventories:THashMap;
      
      protected var FHeroWakeData:THeroWakeData;
      
      public function TWindowShowHero(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(Visible)
         {
            if(this.FHero != null && this.StarBadge != null && !TProcessorWindowHeroChangeMainUI.StarRequested)
            {
               TProcessorWindowHeroChangeMainUI.RequestStarInfo();
            }
            if(this.StarBadge != null && this.FHero != null)
            {
               var stars:int = int(TProcessorWindowHeroChangeMainUI.StarCounts[String(this.FHero.Identifier)]);
               this.StarBadge.text = "x " + stars;
               this.StarBadge.visible = true;
               this.StarMarker.visible = true;
            }
            this.UpdateSlot();
            this.UpdateRoleMoudle();
         }
      }
      
      public function UIDispatch(param1:Sprite) : void
      {
         this.StarMarker = new Sprite();
         this.StarMarker.mouseEnabled = false;
         this.StarMarker.mouseChildren = false;
         this.StarMarker.visible = false;
         param1.addChild(this.StarMarker);
         this.StarIcon = new Bitmap();
         this.StarMarker.addChild(this.StarIcon);
         this.StarBadge = new TextField();
         this.StarBadge.defaultTextFormat = new TextFormat("Arial",15,16765275,true);
         this.StarBadge.x = 20;
         this.StarBadge.y = -1;
         this.StarBadge.width = 34;
         this.StarBadge.height = 24;
         this.StarBadge.mouseEnabled = false;
         this.StarMarker.addChild(this.StarBadge);
         this.StarIconLoader = new Loader();
         this.StarIconLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.StarPNGReady,false,0,true);
         this.StarIconLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.StarPNGFailed,false,0,true);
         this.StarIconLoader.load(new URLRequest(SParametersCore.CdnRoot + "../gorsel/hero-star.png"));
         this.FHint = new THint();
         this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_38);
         this.FSpriteMoudle = new TSceneSpriteMoudle();
         this.FQureyMoudleInfor = new TMoudleInfor();
         param1["MC_HeroPosition"].addChild(this.FSpriteMoudle);
         this.FBtnUnload = new TUIButton();
         this.FBtnUnload.Substrate = param1["MC_Btn_AllUnload"];
         this.FBtnUnload.OnClick = this.BtnUnloadOnClick;
         this.FBtnWake = new TUIButton();
         this.FBtnWake.Substrate = param1["MC_Btn_Wake"];
         this.FBtnWake.OnClick = this.BtnUnloadOnClick;
         this.UIDispatchEquipmentSlot(param1);
         this.UILocationEquipmentSlot();
         var weaponBounds:Rectangle = this.FEquipmentSlotPanle["MC_SlotEquipment_0"].getBounds(param1);
         var leftBottom:Number = weaponBounds.bottom;
         var slotIndex:int = 0;
         while(slotIndex < EquipmentSlotNum)
         {
            var slotBounds:Rectangle = this.FEquipmentSlotPanle["MC_SlotEquipment_" + slotIndex].getBounds(param1);
            if(Math.abs(slotBounds.x - weaponBounds.x) < 10)
            {
               leftBottom = Math.max(leftBottom,slotBounds.bottom);
            }
            slotIndex++;
         }
         this.StarMarker.x = weaponBounds.x;
         this.StarMarker.y = leftBottom + 6;
         param1.setChildIndex(this.StarMarker,param1.numChildren - 1);
         this.UIDispatchDecorationSlot(param1);
         this.UILocationDecorationSlot();
         this.UIDispatchWakeUpSlot(param1);
         this.UILocationWakeUpSlot();
         this.UIDispatchHeroWake(param1);
         this.FCategorySeconds = new Vector.<int>();
         this.FShowType = ShowType_Equipment;
         this.FWakeUpBackInventories = new THashMap();
      }
      
      protected function StarPNGReady(e:Event) : void
      {
         var bitmap:Bitmap = this.StarIconLoader.content as Bitmap;
         if(bitmap != null)
         {
            var icon:BitmapData = new BitmapData(18,18,true,0);
            var matrix:Matrix = new Matrix();
            matrix.scale(18 / bitmap.bitmapData.width,18 / bitmap.bitmapData.height);
            icon.draw(bitmap.bitmapData,matrix,null,null,null,true);
            this.StarIcon.scaleX = 1;
            this.StarIcon.scaleY = 1;
            this.StarIcon.bitmapData = icon;
            this.StarIcon.smoothing = true;
         }
      }
      
      protected function StarPNGFailed(e:IOErrorEvent) : void
      {
         this.StarIcon.visible = false;
      }
      
      protected function UIDispatchEquipmentSlot(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TUISlot = null;
         this.FEquipmentSlotPanle = param1["MC_Equipment"];
         this.FEquipmentSlots = new Vector.<TUISlot>();
         _loc3_ = EquipmentSlotNum;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = new TUISlot(this);
            _loc4_.TextureAdvancedEffect = SResourcesCore.TexturesLobby.GetTextureByIdentifier(CONST_LOBBY.RESOURCESID_Texture_SlotAdvancedEffect);
            _loc4_.Resource = this.FEquipmentSlotPanle["MC_SlotEquipment_" + _loc2_];
            _loc4_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc4_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            _loc4_.OnClick = this.InventorySlotOnClick;
            _loc4_.OnQueryEdgeColor = this.SlotsOnQueryEdgeColor;
            TJadeCommon.InitSlot(_loc4_);
            _loc4_.OnQuerySubscript = null;
            _loc4_.Init();
            this.FEquipmentSlots.push(_loc4_);
            _loc2_++;
         }
      }
      
      protected function UILocationEquipmentSlot() : void
      {
      }
      
      protected function UIDispatchDecorationSlot(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TUISlot = null;
         this.FDecorationSlotPanle = param1["MC_Ornament"];
         this.FDecorationSlots = new Vector.<TUISlot>();
         _loc3_ = DecorationSlotNum;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = new TUISlot(this);
            _loc4_.Resource = this.FDecorationSlotPanle["MC_SlotOrnament_" + _loc2_];
            _loc4_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc4_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            _loc4_.OnClick = this.InventorySlotOnClick;
            TJadeCommon.InitSlot(_loc4_);
            _loc4_.OnQuerySubscript = null;
            _loc4_.Init();
            this.FDecorationSlots.push(_loc4_);
            _loc2_++;
         }
      }
      
      protected function UILocationDecorationSlot() : void
      {
      }
      
      protected function UIDispatchWakeUpSlot(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:THeroWakeSlot = null;
         this.FWakeUpSlotPanle = param1["MC_WakeSlots"];
         this.FWakeUpSlots = new Vector.<THeroWakeSlot>();
         _loc3_ = WakeUpSlotNum;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = new THeroWakeSlot(this);
            _loc4_.Substrate = this.FWakeUpSlotPanle["MC_SlotWake_" + _loc2_];
            _loc4_.OnMove = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc4_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            _loc4_.OnClick = this.WakeSlotOnClick;
            this.FWakeUpSlots.push(_loc4_);
            _loc2_++;
         }
      }
      
      protected function UIDispatchHeroWake(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TUISlot = null;
         var _loc4_:TMainHeroWakeSlot = null;
         var _loc5_:MovieClip = null;
         this.FHeroWakeSlotPanle = param1["MC_MainWakeSlots"];
         this.FHeroWakeSlots = new Vector.<TUISlot>(THeroWakeData.EquipsCount);
         _loc2_ = 0;
         while(_loc2_ < THeroWakeData.EquipsCount)
         {
            if(_loc2_ == THeroWakeData.AllPos)
            {
               _loc3_ = new TUISlot(this);
            }
            else
            {
               _loc3_ = new TMainHeroWakeSlot(this);
               _loc3_.OnClick = this.OnMainWakeSlotClick;
               (_loc3_ as TMainHeroWakeSlot).Hint = this.FHint;
               this.FHeroWakeSlotPanle["MC_Slot_" + _loc2_]["Slot"].buttonMode = true;
               _loc5_ = this.FHeroWakeSlotPanle["MC_State_" + _loc2_];
               _loc5_.play();
            }
            _loc3_.Resource = this.FHeroWakeSlotPanle["MC_Slot_" + _loc2_]["Slot"];
            _loc3_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc3_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            _loc3_.Tag = _loc2_;
            TJadeCommon.InitSlot(_loc3_);
            _loc3_.OnQuerySubscript = null;
            _loc3_.Init();
            this.FHeroWakeSlots[_loc2_] = _loc3_;
            _loc2_++;
         }
      }
      
      protected function UILocationWakeUpSlot() : void
      {
      }
      
      protected function RenderSelector() : void
      {
         this.FEquipmentSlotPanle.visible = false;
         this.FDecorationSlotPanle.visible = false;
         this.FWakeUpSlotPanle.visible = false;
         this.FHeroWakeSlotPanle.visible = false;
         this.RenderHeroMoudle();
         switch(this.FShowType)
         {
            case ShowType_Equipment:
               this.RenderEquipmentSlot();
               this.FBtnUnload.Visible = true;
               this.FBtnWake.Visible = false;
               this.FEquipmentSlotPanle.visible = true;
               break;
            case ShowType_Decoration:
               this.RenderDecorationSlot();
               this.FBtnUnload.Visible = true;
               this.FBtnWake.Visible = false;
               this.FDecorationSlotPanle.visible = true;
               break;
            case ShowType_WakeUp:
               if(!this.FHero.IsMain)
               {
                  this.RenderWakeUpSlot();
                  this.FBtnUnload.Visible = false;
                  this.FBtnWake.Visible = this.FHero.WakeupEquipCount == WakeUpSlotNum;
                  this.FWakeUpSlotPanle.visible = true;
               }
               else
               {
                  this.RenderHeroWakeSlot();
                  this.FBtnUnload.Visible = false;
                  this.FBtnWake.Visible = false;
                  this.FHeroWakeSlotPanle.visible = true;
               }
         }
      }
      
      protected function RenderEquipmentSlot() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = this.FHero.EquipmentsMounted.Capacity;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FEquipmentSlots[_loc1_].Context = this.FHero.EquipmentsMounted.GetInventoryByIndex(_loc1_);
            _loc1_++;
         }
      }
      
      protected function RenderDecorationSlot() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = this.FHero.OrnamentsMounted.Capacity;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FDecorationSlots[_loc1_].Context = this.FHero.OrnamentsMounted.GetInventoryByIndex(_loc1_);
            _loc1_++;
         }
      }
      
      protected function RenderWakeUpSlot() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TWakeUp = null;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:TInventoryWake = null;
         var _loc6_:int = 0;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_WakeUp,this.FHero.Identifier) as TWakeUp;
         if(_loc2_ == null)
         {
            _loc1_ = 0;
            while(_loc1_ < WakeUpSlotNum)
            {
               this.FWakeUpSlots[_loc1_].Clear();
               _loc1_++;
            }
            return;
         }
         _loc3_ = this.FHero.WakeupStatus;
         _loc1_ = 0;
         while(_loc1_ < WakeUpSlotNum)
         {
            if(this.FHero == SLogicsCore.Character.MainHero)
            {
               this.FWakeUpSlots[_loc1_].Clear();
            }
            else
            {
               _loc4_ = (_loc3_ & 1 << _loc1_) != 0;
               _loc5_ = this.FHero.WakeEquipsNeed.GetInventoryByIndex(_loc1_) as TInventoryWake;
               if(_loc5_ == null)
               {
                  this.FWakeUpSlots[_loc1_].CanLit = false;
                  this.FWakeUpSlots[_loc1_].Context = null;
                  this.FWakeUpSlots[_loc1_].WakeEquipId = 0;
               }
               else
               {
                  _loc6_ = int(SLogicsCore.Character.WakeEquip.GetCountByTempleteID(_loc5_.IDTemplate));
                  this.FWakeUpSlots[_loc1_].Context = _loc5_;
                  this.FWakeUpSlots[_loc1_].WakeEquipId = _loc5_.IDTemplate;
                  this.FWakeUpSlots[_loc1_].Status = _loc4_;
                  this.FWakeUpSlots[_loc1_].CanLit = _loc6_ > 0 && !_loc4_;
                  if(this.FWakeUpSlots[_loc1_].CanLit)
                  {
                     this.FWakeUpSlots[_loc1_].CanCompose = false;
                  }
                  else
                  {
                     this.FWakeUpBackInventories.Clear();
                     this.FWakeUpSlots[_loc1_].CanCompose = !_loc4_ && this.SearchWakeEquip(_loc5_.IDTemplate);
                  }
               }
            }
            _loc1_++;
         }
      }
      
      protected function RenderHeroWakeSlot() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TUISlot = null;
         var _loc3_:THeroWakeEquipment = null;
         _loc1_ = 0;
         while(_loc1_ < THeroWakeData.EquipsCount)
         {
            _loc2_ = this.FHeroWakeSlots[_loc1_];
            _loc2_.Context = null;
            _loc3_ = this.FHeroWakeData.Equips[_loc1_];
            _loc2_.Context = _loc3_;
            if(!THeroWakeData.IsAll(_loc3_))
            {
               this.HeroWakeSoltStateUpdate(this.FHeroWakeSlotPanle["MC_State_" + _loc1_],this.FHeroWakeData.Equips[_loc1_]);
            }
            _loc1_++;
         }
      }
      
      protected function HeroWakeSoltStateUpdate(param1:MovieClip, param2:THeroWakeEquipment) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         _loc3_ = true;
         _loc4_ = true;
         if(param2.WakeUpConfig.NextID == 0)
         {
            _loc3_ = false;
         }
         else if(SLogicsCore.Character.GetMainLevel() < param2.WakeUpConfig.UpLevel)
         {
            _loc3_ = false;
         }
         else if(THeroWakeData.IsEquips(param2) && param2.CurStreng < param2.WakeUpConfig.MaxStr)
         {
            _loc3_ = false;
         }
         else if(!this.AdvancedEnough(param2))
         {
            _loc3_ = false;
         }
         if(_loc3_)
         {
            param1.visible = true;
            return;
         }
         if(!THeroWakeData.IsStone(param2))
         {
            if(param2.WakeUpConfig.WakeStage == 0)
            {
               _loc4_ = false;
            }
            else if(param2.CurStreng == param2.WakeUpConfig.MaxStr)
            {
               _loc4_ = false;
            }
            else if(!this.StrengEnough(param2))
            {
               _loc4_ = false;
            }
            if(_loc4_)
            {
               param1.visible = true;
               return;
            }
         }
         param1.visible = false;
      }
      
      protected function AdvancedEnough(param1:THeroWakeEquipment) : Boolean
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TInventories = null;
         var _loc5_:TRewards = null;
         var _loc6_:TInventory = null;
         _loc4_ = new TInventories();
         _loc5_ = new TRewards(param1.WakeUpConfig.UpLevelPriceStr);
         SToolReward.CreateRewardInventoryByRewardInfor(_loc5_,_loc4_);
         _loc6_ = _loc4_.GetInventoryByIndex(0);
         _loc3_ = _loc6_.Quantity;
         _loc2_ = TUtilityLobby.GetArticleQuantity(_loc6_.IDTemplate,_loc6_.Category);
         return _loc2_ >= _loc3_;
      }
      
      protected function StrengEnough(param1:THeroWakeEquipment) : Boolean
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TInventories = null;
         var _loc7_:TInventory = null;
         var _loc8_:TInventory = null;
         var _loc9_:TRewards = null;
         _loc6_ = new TInventories();
         _loc9_ = new TRewards(param1.WakeUpConfig.StrengthenPriceStr);
         SToolReward.CreateRewardInventoryByRewardInfor(_loc9_,_loc6_);
         _loc7_ = _loc6_.GetInventoryByIndex(0);
         _loc8_ = _loc6_.GetInventoryByIndex(1);
         _loc2_ = TUtilityLobby.GetArticleQuantity(_loc7_.IDTemplate,_loc7_.Category);
         _loc3_ = TUtilityLobby.GetArticleQuantity(_loc8_.IDTemplate,_loc8_.Category);
         _loc4_ = _loc7_.Quantity;
         _loc5_ = _loc8_.Quantity;
         return _loc2_ >= _loc4_ && _loc3_ >= _loc5_;
      }
      
      protected function RenderHeroMoudle() : void
      {
         TUtilityTexture.QueryTwoDirectionShowCase(CONST_MAP.DIRECTION_RIGHT,this.FHero.ModelID,this.FQureyMoudleInfor);
         this.FSpriteMoudle.ChangeRoleMoudle(this.FQureyMoudleInfor.TextureID,this.FQureyMoudleInfor.Scalx);
         this.FSpriteMoudle.OpenRebirthEffect(this.FHero.IsMain,this.FHero.RebirthNum);
      }
      
      protected function SearchWakeEquip(param1:int, param2:int = 1, param3:THashMap = null) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TWakeUpEquip = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         if(param3 == null)
         {
            param3 = new THashMap();
         }
         _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_WakeUpEquip,param1) as TWakeUpEquip;
         if(_loc7_ == null)
         {
            return false;
         }
         _loc10_ = _loc7_.ComposeItemsCount;
         if(_loc10_ == 0 && _loc6_ < param2)
         {
            return false;
         }
         _loc8_ = 0;
         while(_loc8_ < _loc10_)
         {
            _loc9_ = _loc7_.GetComposeByIndex(_loc8_).Code;
            _loc4_ = int(SLogicsCore.Character.WakeEquip.GetCountByTempleteID(_loc9_));
            if(!param3.ContainsKey(_loc9_))
            {
               param3.Put(_loc9_,0);
            }
            _loc5_ = _loc7_.GetComposeByIndex(_loc8_).Amount * param2;
            _loc6_ = _loc4_ - param3.GetValue(_loc9_);
            if(_loc6_ >= _loc5_)
            {
               param3.Put(_loc9_,param3.GetValue(_loc9_) + _loc5_);
            }
            else
            {
               param3.Put(_loc9_,param3.GetValue(_loc9_) + _loc6_);
               if(!this.SearchWakeEquip(_loc9_,_loc5_ - _loc6_,param3))
               {
                  return false;
               }
            }
            _loc8_++;
         }
         return true;
      }
      
      protected function UpdateSlot() : void
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         switch(this.FShowType)
         {
            case ShowType_Equipment:
               _loc1_ = this.FEquipmentSlots as Object;
               break;
            case ShowType_Decoration:
               _loc1_ = this.FDecorationSlots as Object;
               break;
            case ShowType_WakeUp:
               if(!this.FHero.IsMain)
               {
                  _loc1_ = this.FWakeUpSlots as Object;
               }
               else
               {
                  _loc1_ = this.FHeroWakeSlots as Object;
               }
         }
         _loc3_ = int(_loc1_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_[_loc2_].Update();
            _loc2_++;
         }
      }
      
      protected function UpdateRoleMoudle() : void
      {
         this.FSpriteMoudle.UpdateView();
      }
      
      protected function Perform_CS_WakeUp() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_WakeUp_DoneReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeUnsignedInt(this.FHero.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function Perform_CS_DismountEquipment(param1:Vector.<int>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TPacket = null;
         var _loc5_:ByteArray = null;
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Heros_Dismount);
         _loc5_ = _loc4_.Data;
         _loc5_.writeUnsignedInt(this.FHero.Identifier);
         _loc5_.writeShort(param1.length);
         _loc3_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_.writeByte(param1[_loc2_]);
            _loc2_++;
         }
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
      }
      
      protected function SlotsOnQueryEdgeColor(param1:Object, param2:Object, param3:TQueryUInt) : void
      {
         var _loc4_:TEquipment = null;
         if(param2 is TEquipment)
         {
            _loc4_ = param2 as TEquipment;
            param3.Value = _loc4_.IsEdgeColor;
         }
      }
      
      protected function OnMainWakeSlotClick(param1:Object, param2:Object) : void
      {
         this.FHeroSlotOnClick(param2 as THeroWakeEquipment);
      }
      
      protected function InventorySlotOnClick(param1:Object, param2:Object) : void
      {
         var _loc3_:TInventory = null;
         _loc3_ = param2 as TInventory;
         this.FCategorySeconds.length = 0;
         this.FCategorySeconds.push(_loc3_.CategorySecond);
         this.Perform_CS_DismountEquipment(this.FCategorySeconds);
      }
      
      protected function WakeSlotOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:THeroWakeSlot = param1 as THeroWakeSlot;
         if(this.FHero.Identifier == SLogicsCore.Character.MainHero.Identifier)
         {
            return;
         }
         if(_loc3_.WakeEquipId == 0)
         {
            return;
         }
         if(this.FWakeUpSlotOnClick != null)
         {
            this.FWakeUpSlotOnClick(this.FHero.Identifier,_loc3_.WakeEquipId,this.SearchWakeEquip(_loc3_.WakeEquipId,1));
         }
      }
      
      protected function BtnUnloadOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TInventory = null;
         var _loc4_:TCollectionInventory = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         switch(this.FShowType)
         {
            case ShowType_Equipment:
               _loc4_ = this.FHero.EquipmentsMounted;
               break;
            case ShowType_Decoration:
               _loc4_ = this.FHero.OrnamentsMounted;
               break;
            case ShowType_WakeUp:
               this.Perform_CS_WakeUp();
               return;
         }
         this.FCategorySeconds.length = 0;
         _loc5_ = _loc4_.Capacity;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc3_ = _loc4_.GetInventoryByIndex(_loc6_);
            if(_loc3_ != null)
            {
               this.FCategorySeconds.push(_loc3_.CategorySecond);
            }
            _loc6_++;
         }
         this.Perform_CS_DismountEquipment(this.FCategorySeconds);
      }
      
      public function SwitchHero(param1:THero, param2:int) : void
      {
         this.FHero = param1;
         this.FShowType = param2;
         this.RenderSelector();
         Visible = true;
      }
      
      public function SwitchShowType(param1:int) : void
      {
         this.FShowType = param1;
      }
      
      public function Reset() : void
      {
         Visible = false;
      }
      
      public function Update() : void
      {
         this.RenderSelector();
      }
      
      public function CanCompose(param1:int) : Boolean
      {
         var _loc2_:Boolean = false;
         return this.SearchWakeEquip(param1,1);
      }
      
      public function get WakeUpSlotOnClick() : Function
      {
         return this.FWakeUpSlotOnClick;
      }
      
      public function set WakeUpSlotOnClick(param1:Function) : void
      {
         this.FWakeUpSlotOnClick = param1;
      }
      
      public function set HeroWakeData(param1:THeroWakeData) : void
      {
         this.FHeroWakeData = param1;
      }
      
      public function set HeroSlotOnClick(param1:Function) : void
      {
         this.FHeroSlotOnClick = param1;
      }
   }
}

