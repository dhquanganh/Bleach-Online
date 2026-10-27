package Processors.Game.Lobby.TreasureMap
{
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.TreasureMap.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   
   public class TProcessorWindowHeros extends TUIComponent
   {
      
      protected static const MAX_COUNT:uint = 25;
      
      protected static const MySelfFrame:uint = 6;
      
      protected static const INIT_TreasureQuality:uint = 101;
      
      protected var FScene:MovieClip;
      
      protected var FCharacter:TCharacter;
      
      protected var FTreasureMapData:TTreasureMapData;
      
      protected var FDiggingBins:TBins;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FTreasureMapHero:TTreasureMapHero;
      
      protected var FSelectHero:TTreasureMapHero;
      
      protected var FGameWinLessTimes:uint;
      
      protected var FMaxRobberyTimes:int;
      
      protected var FIsFirstShow:Boolean;
      
      protected var FIsInit:Boolean;
      
      protected var FFirstShowIndex:int;
      
      protected var FFirstShowHerosVect:Vector.<MovieClip>;
      
      protected var FOnHeroRollOver:Function;
      
      protected var FOnHeroRollOut:Function;
      
      protected var FOnEffectText:Function;
      
      public function TProcessorWindowHeros(param1:TUIComponent, param2:MovieClip)
      {
         var _loc3_:TConfigValue = null;
         super(param1);
         this.FScene = param2;
         this.FCharacter = SLogicsCore.Character;
         this.FDiggingBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Digging);
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.TreasureMap_ColdTime) as TConfigValue;
         this.FGameWinLessTimes = int(_loc3_.Value);
         this.InitWindowHeros();
         this.FIsFirstShow = false;
         this.FIsInit = false;
         this.FFirstShowHerosVect = new Vector.<MovieClip>();
         this.FFirstShowIndex = 0;
      }
      
      protected function InitWindowHeros() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TConfigValue = null;
         _loc1_ = 0;
         while(_loc1_ < MAX_COUNT)
         {
            this.FScene["mc_hero_" + _loc1_].addEventListener(MouseEvent.MOUSE_MOVE,this.OnHeroRoll);
            this.FScene["mc_hero_" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,this.OnHeroRoll);
            this.FScene["mc_hero_" + _loc1_].addEventListener(MouseEvent.MOUSE_DOWN,this.OnHeroClick);
            this.FScene["mc_hero_" + _loc1_].addEventListener(MouseEvent.MOUSE_UP,this.OnHeroClick);
            this.FScene["mc_hero_" + _loc1_].visible = false;
            _loc1_++;
         }
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.TreasureMap_Plunder) as TConfigValue;
         this.FMaxRobberyTimes = int(_loc2_.Value);
      }
      
      protected function UpdataHeroUI() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TTreasureMapHero = null;
         var _loc3_:MovieClip = null;
         var _loc4_:TDigging = null;
         _loc1_ = 0;
         while(_loc1_ < MAX_COUNT)
         {
            _loc3_ = this.FScene["mc_hero_" + _loc1_];
            _loc3_.visible = false;
            _loc1_++;
         }
         this.FFirstShowHerosVect.length = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FTreasureMapData.FightHeroList.Count)
         {
            _loc2_ = this.FTreasureMapData.FightHeroList.GetMapHeroByIndex(_loc1_);
            if(_loc2_.LastTime > 0)
            {
               _loc3_ = this.FScene["mc_hero_" + _loc2_.UserIndex];
               if(_loc3_ == null)
               {
                  break;
               }
               this.FFirstShowHerosVect.push(_loc3_);
               _loc4_ = this.FDiggingBins.GetDatebaseByIdentifier(_loc2_.CurQuality) as TDigging;
               _loc3_.mc_mapType.gotoAndStop(_loc4_.Rate);
               _loc3_.mc_mapType.MC_Monster.play();
               if(_loc2_.Identifier0 == this.FCharacter.Identifier0 && _loc2_.Identifier1 == this.FCharacter.Identifier1)
               {
                  _loc3_.MC_CurStatus.gotoAndStop(1);
               }
               else if(_loc2_.BeRobberyTimes >= _loc4_.Robbery)
               {
                  _loc3_.MC_CurStatus.gotoAndStop(2);
               }
               else
               {
                  _loc3_.MC_CurStatus.gotoAndStop(3);
               }
               if(!this.FIsInit)
               {
                  _loc3_.visible = false;
               }
               else
               {
                  _loc3_.visible = true;
               }
            }
            _loc1_++;
         }
      }
      
      protected function OnFightHeroSure(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TreasureMap_FightReq);
         _loc3_ = _loc2_.Data;
         _loc3_.writeInt(this.FSelectHero.Identifier0);
         _loc3_.writeInt(this.FSelectHero.Identifier1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function GetSelfTreasureMapHero() : TTreasureMapHero
      {
         var _loc1_:TTreasureMapHero = null;
         return this.FTreasureMapData.FightHeroList.GetMapHeroById(this.FCharacter.Identifier0,this.FCharacter.Identifier1) as TTreasureMapHero;
      }
      
      override public function get Cursor() : uint
      {
         return CONST_CURSOR.CURSORID_Enemy;
      }
      
      override public function get CursorDisplayObject() : TUIComponent
      {
         return FParent;
      }
      
      protected function OnHeroRoll(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:TTreasureMapHero = null;
         if(this.FTreasureMapData == null)
         {
            return;
         }
         if(param1.type == MouseEvent.MOUSE_MOVE)
         {
            param1.currentTarget.gotoAndStop(2);
            _loc2_ = uint(int(String(param1.currentTarget.name).slice(8)));
            _loc3_ = this.FTreasureMapData.FightHeroList.GetMapHeroByUserIndex(_loc2_);
            if(this.FOnHeroRollOver != null)
            {
               this.FOnHeroRollOver(this,_loc3_);
            }
         }
         else if(param1.type == MouseEvent.MOUSE_OUT)
         {
            param1.currentTarget.gotoAndStop(1);
            _loc2_ = uint(int(String(param1.currentTarget.name).slice(8)));
            _loc3_ = this.FTreasureMapData.FightHeroList.GetMapHeroByUserIndex(_loc2_);
            if(this.FOnHeroRollOut != null)
            {
               this.FOnHeroRollOut(this,_loc3_);
            }
         }
      }
      
      protected function OnHeroClick(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:TDigging = null;
         var _loc4_:uint = 0;
         if(param1.type == MouseEvent.MOUSE_DOWN)
         {
            param1.currentTarget.gotoAndStop(3);
         }
         else if(param1.type == MouseEvent.MOUSE_UP)
         {
            param1.currentTarget.gotoAndStop(1);
            _loc4_ = uint(int(String(param1.currentTarget.name).slice(8)));
            this.FSelectHero = this.FTreasureMapData.FightHeroList.GetMapHeroByUserIndex(_loc4_);
            _loc3_ = this.FDiggingBins.GetDatebaseByIdentifier(this.FSelectHero.CurQuality) as TDigging;
            if(this.FSelectHero.Identifier0 == this.FCharacter.Identifier0 && this.FSelectHero.Identifier1 == this.FCharacter.Identifier1)
            {
               if(this.FOnEffectText != null)
               {
                  this.FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_36));
               }
               return;
            }
            if(this.FTreasureMapData.RobberyTimes >= this.FMaxRobberyTimes)
            {
               if(this.FOnEffectText != null)
               {
                  this.FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_38));
               }
               return;
            }
            if(this.FSelectHero.BeRobberyTimes >= _loc3_.Robbery)
            {
               if(this.FOnEffectText != null)
               {
                  this.FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_37));
               }
               return;
            }
            _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_39);
            _loc2_ = _loc2_.split("%name%").join(this.FSelectHero.PlayerNick);
            this.FUIWindowConfirmation.Text = _loc2_;
            this.FUIWindowConfirmation.OnOK = this.OnFightHeroSure;
            this.FUIWindowConfirmation.Visible = true;
         }
      }
      
      protected function ShowHeros() : void
      {
         if(this.FFirstShowHerosVect.length <= 0)
         {
            this.FIsFirstShow = false;
            return;
         }
         if(this.FFirstShowHerosVect[this.FFirstShowIndex] != null)
         {
            this.FFirstShowHerosVect[this.FFirstShowIndex].visible = true;
         }
         ++this.FFirstShowIndex;
         if(this.FFirstShowIndex >= this.FFirstShowHerosVect.length)
         {
            this.FIsFirstShow = false;
            this.FFirstShowIndex = 0;
         }
      }
      
      public function get OnHeroRollOver() : Function
      {
         return this.FOnHeroRollOver;
      }
      
      public function set OnHeroRollOver(param1:Function) : void
      {
         this.FOnHeroRollOver = param1;
      }
      
      public function get OnHeroRollOut() : Function
      {
         return this.FOnHeroRollOut;
      }
      
      public function set OnHeroRollOut(param1:Function) : void
      {
         this.FOnHeroRollOut = param1;
      }
      
      public function get OnEffectText() : Function
      {
         return this.FOnEffectText;
      }
      
      public function set OnEffectText(param1:Function) : void
      {
         this.FOnEffectText = param1;
      }
      
      public function SetTreasureMapData(param1:TTreasureMapData) : Boolean
      {
         var _loc2_:Boolean = false;
         this.FTreasureMapData = param1;
         this.FTreasureMapHero = this.GetSelfTreasureMapHero();
         if(!this.FTreasureMapData.TreasureStatus && Boolean(this.FTreasureMapHero))
         {
            this.FTreasureMapHero.LastTime = 0;
         }
         if(this.FTreasureMapData.TreasureStatus && this.FTreasureMapHero == null)
         {
            this.FTreasureMapData.CurQuality = INIT_TreasureQuality;
            this.FTreasureMapData.TreasureStatus = false;
            this.FTreasureMapData.CurRefreshTimes = 0;
            _loc2_ = true;
         }
         else
         {
            _loc2_ = false;
         }
         this.UpdataHeroUI();
         return _loc2_;
      }
      
      public function UpdataTimeLine() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TDigging = null;
         var _loc3_:TTreasureMapHero = null;
         var _loc4_:MovieClip = null;
         var _loc5_:Number = NaN;
         var _loc6_:uint = 0;
         if(this.FTreasureMapData == null)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < this.FTreasureMapData.FightHeroList.Count)
         {
            _loc3_ = this.FTreasureMapData.FightHeroList.GetMapHeroByIndex(_loc1_);
            if(_loc3_.LastTime > 0)
            {
               _loc4_ = this.FScene["mc_hero_" + _loc3_.UserIndex];
               if(_loc4_ == null)
               {
                  break;
               }
               _loc2_ = this.FDiggingBins.GetDatebaseByIdentifier(_loc3_.CurQuality) as TDigging;
               _loc6_ = _loc2_.Digtime - (_loc3_.IsGameWin ? this.FGameWinLessTimes : 0);
               _loc5_ = (STimingCore.ServerTick - _loc3_.LastTime) / _loc6_;
               _loc4_.mc_timeBar.mc_timeLine.scaleX = Math.max(0,Math.min(1,_loc5_));
            }
            _loc1_++;
         }
      }
      
      public function FirstShowHeros() : void
      {
         this.FIsFirstShow = true;
         this.FIsInit = true;
      }
      
      public function LogicsPerform() : void
      {
         if(this.FIsFirstShow)
         {
            this.ShowHeros();
         }
      }
      
      public function Unmount() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FFirstShowIndex = 0;
         this.FIsFirstShow = false;
         this.FIsInit = false;
         _loc2_ = int(this.FFirstShowHerosVect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FFirstShowHerosVect[_loc1_].mc_mapType.MC_Monster.stop();
            this.FFirstShowHerosVect[_loc1_].visible = false;
            _loc1_++;
         }
      }
   }
}

