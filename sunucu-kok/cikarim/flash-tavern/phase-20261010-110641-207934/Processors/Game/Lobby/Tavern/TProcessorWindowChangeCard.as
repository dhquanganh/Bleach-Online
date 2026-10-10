package Processors.Game.Lobby.Tavern
{
   import Components.Slots.*;
   import Components.Standard.TUIButton;
   import Foundation.Network.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.Streamization.Inventories.*;
   import Processors.Game.Lobby.Common.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   
   public class TProcessorWindowChangeCard extends TProcessorLobbyWindow
   {
      
      protected static const MAX_COUNT:uint = 1;
      
      protected static const QUALITY_BULE:uint = 3;
      
      protected static const QUALITY_PURPLE:uint = 4;
      
      protected static const QUALITY_GOLD:uint = 5;
      
      protected static const QUALITY_ORANGE:uint = 6;
      
      protected var FScene:MovieClip;
      
      protected var FUISlot:TUISlot;
      
      protected var FIsCanChangeCard:Boolean;
      
      protected var FExchangeExpCard:TExchangeExpCard;
      
      protected var FBuyCount:uint;
      
      protected var FArticleBins:TBins;
      
      protected var FCharacter:TCharacter;
      
      protected var FIDTemplates:Vector.<uint>;
      
      protected var FInventories:TInventories;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FBT_Close:TUIButton;
      
      protected var FBT_OK:TUIButton;
      
      protected var FBarrierDeactuate:Function;
      
      protected var FSlotsOnMove:Function;
      
      protected var FSlotsOnOut:Function;
      
      public function TProcessorWindowChangeCard(param1:TUIComponent)
      {
         super(param1);
         this.InitChangeCard();
      }
      
      protected function InitChangeCard() : void
      {
         this.FCharacter = SLogicsCore.Character;
         this.FIDTemplates = new Vector.<uint>(MAX_COUNT);
         this.FInventories = new TInventories();
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         this.FArticleBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Article);
         this.FScene = TUtilityReflection.CreateDisplayObjectInstance(CONST_TAVERN.RESOURCESID_CLASSNAME_ChangeCard) as MovieClip;
         addChild(this.FScene);
         this.FBT_Close = new TUIButton();
         this.FBT_Close.Substrate = this.FScene.btn_close;
         this.FBT_Close.OnClick = this.OnCloseChangeCard;
         this.FBT_OK = new TUIButton();
         this.FBT_OK.Substrate = this.FScene.btn_ok;
         this.FBT_OK.OnClick = this.OnChangeCard;
         this.FScene.btn_max.addEventListener(MouseEvent.CLICK,this.OnMaxCount);
         this.FScene.tf_Num.maxChars = 3;
         this.FScene.tf_Num.restrict = "0-9";
         this.FScene.tf_Num.addEventListener(Event.CHANGE,this.OnChangeCount);
         this.FUISlot = new TUISlot(this);
         this.FUISlot.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         this.FUISlot.OnOver = this.FSlotsOnMove;
         this.FUISlot.OnOut = this.FSlotsOnOut;
         this.FUISlot.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
         this.FUISlot.Resource = this.FScene.mc_slot;
         this.FUISlot.Init();
      }
      
      protected function UpdataUI() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TArticle = null;
         _loc2_ = this.FArticleBins.GetDatebaseByIdentifier(this.FExchangeExpCard.Item) as TArticle;
         this.FScene.tf_Num.text = "1";
         this.OnChangeCount();
         this.FScene.tf_name.text = _loc2_.Name;
         this.FScene.mc_soul.gotoAndStop(this.FExchangeExpCard.Quality);
         this.FIDTemplates[0] = this.FExchangeExpCard.Item;
         this.FInventories.Clear();
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,this.FInventories,this.FIDTemplates);
         _loc1_ = 0;
         while(_loc1_ < this.FInventories.Count)
         {
            this.FUISlot.Context = this.FInventories.GetInventoryByIndex(_loc1_);
            _loc1_++;
         }
         this.FScene.tf_price.text = String(this.FBuyCount * this.FExchangeExpCard.Value);
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
      
      protected function GetSoulWithQuality(param1:uint) : uint
      {
         switch(param1)
         {
            case QUALITY_BULE:
               return this.FCharacter.HeroSoulBlueSoul;
            case QUALITY_PURPLE:
               return this.FCharacter.HeroSoulPurpleSoul;
            case QUALITY_GOLD:
               return this.FCharacter.HeroSoulGoldSoul;
            case QUALITY_ORANGE:
               return this.FCharacter.HeroSoulOrangeSoul;
            default:
               return 0;
         }
      }
      
      protected function OnChangeCard(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         if(Boolean(param2) && Boolean(param2.currentTarget) && !param2.currentTarget.buttonMode)
         {
            return;
         }
         if(this.FBuyCount == 0)
         {
            return;
         }
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TavernChangeCardReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeInt(this.FExchangeExpCard.Item);
         _loc4_.writeShort(this.FBuyCount);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         this.OnCloseChangeCard();
      }
      
      protected function OnMaxCount(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = int(this.GetSoulWithQuality(this.FExchangeExpCard.Quality));
         this.FBuyCount = int(_loc2_ / this.FExchangeExpCard.Value);
         this.FBuyCount = Math.min(32767,this.FBuyCount);
         this.CheckCount();
      }
      
      protected function OnChangeCount(param1:Event = null) : void
      {
         var _loc2_:int = 0;
         this.FBuyCount = int(this.FScene.tf_Num.text);
         _loc2_ = int(this.GetSoulWithQuality(this.FExchangeExpCard.Quality));
         if(this.FBuyCount > _loc2_ / this.FExchangeExpCard.Value)
         {
            this.FBuyCount = int(_loc2_ / this.FExchangeExpCard.Value);
         }
         if(this.FBuyCount < 0)
         {
            this.FBuyCount = 0;
         }
         this.FBuyCount = Math.min(32767,this.FBuyCount);
         this.CheckCount();
      }
      
      protected function CheckCount() : void
      {
         this.FScene.tf_Num.text = String(this.FBuyCount);
         this.FScene.tf_price.text = String(this.FBuyCount * this.FExchangeExpCard.Value);
         this.FBT_OK.Enabled = this.FIsCanChangeCard && this.FBuyCount > 0;
      }
      
      protected function OnCloseChangeCard(param1:Object = null, param2:MouseEvent = null) : void
      {
         Visible = false;
         if(this.FBarrierDeactuate != null)
         {
            this.FBarrierDeactuate(this);
         }
      }
      
      public function get BarrierDeactuat() : Function
      {
         return this.FBarrierDeactuate;
      }
      
      public function set BarrierDeactuate(param1:Function) : void
      {
         this.FBarrierDeactuate = param1;
      }
      
      public function get SlotsOnMove() : Function
      {
         return this.FSlotsOnMove;
      }
      
      public function set SlotsOnMove(param1:Function) : void
      {
         this.FSlotsOnMove = param1;
      }
      
      public function get SlotsOnOut() : Function
      {
         return this.FSlotsOnOut;
      }
      
      public function set SlotsOnOut(param1:Function) : void
      {
         this.FSlotsOnOut = param1;
      }
      
      public function SetChangeCardData(param1:TExchangeExpCard, param2:Boolean) : void
      {
         this.FExchangeExpCard = param1;
         this.FIsCanChangeCard = param2;
         this.FBuyCount = 1;
         this.UpdataUI();
         this.FBuyCount = Math.min(32767,this.FBuyCount);
         this.CheckCount();
         Visible = true;
      }
      
      public function UpdataBitmap() : void
      {
         this.FUISlot.Update();
      }
      
      public function GetExchangeExpCard() : TExchangeExpCard
      {
         return this.FExchangeExpCard;
      }
      
      public function GetBuyCount() : uint
      {
         return this.FBuyCount;
      }
      
      public function Reset() : void
      {
         this.FUISlot.Context = null;
      }
   }
}

