package Processors.Game.Lobby.SevenKing
{
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.SevenKing.*;
   import Logics.Vip.*;
   import Processors.Game.Lobby.SevenKing.Component.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   
   public class TProcessorWindowSevenHeroList extends TUIComponent
   {
      
      protected static const HERO_NUM:uint = 7;
      
      protected static const FRAME_SELECT:uint = 2;
      
      protected static const FRAME_NORMAL:uint = 1;
      
      public static const CONST_SEVENHERO_BASEID:uint = 82000003;
      
      protected static const TEMP_NUM:uint = 82100001;
      
      protected var FScene:MovieClip;
      
      protected var FSevenKingData:TSevenKingData;
      
      protected var FMC_AfterToFront:MovieClip;
      
      protected var FMC_FrontToAfter:MovieClip;
      
      protected var FBT_AfterToFront:MovieClip;
      
      protected var FBT_FrontToAfter:MovieClip;
      
      protected var FAfterToFront_SmallList:Vector.<TPillar>;
      
      protected var FFrontToAfter_SmallList:Vector.<TPillar>;
      
      protected var FAfterToFront_BigList:Vector.<TBigPillar>;
      
      protected var FFrontToAfter_BigList:Vector.<TBigPillar>;
      
      protected var FSevenHeroArmy:TSevenHeroArmy;
      
      protected var FPositionBoo:Boolean;
      
      protected var FCharacter:TCharacter;
      
      protected var FVipData:TVip;
      
      protected var FHint:THint;
      
      protected var FType:uint;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FUIWindowRecharge:TUIWindowRecharge;
      
      protected var FBattleCount:uint;
      
      protected var FSelectHeroFight:Function;
      
      protected var FUIComponentsOnOver:Function;
      
      protected var FUIComponentsOnOut:Function;
      
      protected var FUIHintOnOver:Function;
      
      protected var FUIHintOnOut:Function;
      
      protected var FRespectCount:uint;
      
      protected var FSelectKingIndex:uint;
      
      protected var FOnEffectText:Function;
      
      public function TProcessorWindowSevenHeroList(param1:TUIComponent, param2:MovieClip, param3:TSevenKingData)
      {
         super(param1);
         this.FScene = param2;
         this.FSevenKingData = param3;
         this.FAfterToFront_SmallList = new Vector.<TPillar>(HERO_NUM);
         this.FAfterToFront_BigList = new Vector.<TBigPillar>(HERO_NUM);
         this.FFrontToAfter_SmallList = new Vector.<TPillar>(HERO_NUM);
         this.FFrontToAfter_BigList = new Vector.<TBigPillar>(HERO_NUM);
         this.FPositionBoo = true;
         this.FCharacter = SLogicsCore.Character;
         this.FVipData = this.FCharacter.VipData;
         this.FHint = new THint();
      }
      
      protected function UIDispatch() : void
      {
         var _loc1_:TConfigValue = null;
         this.FBT_AfterToFront = this.FScene["BT_AfterToFront"];
         this.FBT_AfterToFront.addEventListener(MouseEvent.CLICK,this.ChangePersionOnClick,false,0,true);
         this.FBT_AfterToFront.addEventListener(MouseEvent.MOUSE_OVER,this.ChangePersionOnOver,false,0,true);
         this.FBT_AfterToFront.addEventListener(MouseEvent.MOUSE_OUT,this.ChangePersionOnOut,false,0,true);
         this.FBT_FrontToAfter = this.FScene["BT_FrontToAfter"];
         this.FBT_FrontToAfter.addEventListener(MouseEvent.CLICK,this.ChangePersionOnClick,false,0,true);
         this.FBT_FrontToAfter.addEventListener(MouseEvent.MOUSE_OVER,this.ChangePersionOnOver,false,0,true);
         this.FBT_FrontToAfter.addEventListener(MouseEvent.MOUSE_OUT,this.ChangePersionOnOut,false,0,true);
         this.FMC_AfterToFront = this.FScene["MC_AfterToFront"];
         this.SetRole(this.FMC_AfterToFront);
         this.FMC_AfterToFront.visible = false;
         this.FMC_AfterToFront.mouseEnabled = false;
         this.FMC_FrontToAfter = this.FScene["MC_FrontToAfter"];
         this.SetRole(this.FMC_FrontToAfter);
         this.FMC_FrontToAfter.visible = false;
         this.FMC_FrontToAfter.mouseEnabled = false;
         this.FUIWindowConfirmation = new TUIWindowConfirmation(this.Parent);
         this.FUIWindowConfirmation.OnOK = this.WindowConfirmationOnOK;
         TUtilityUIWindow.SetupWindowConfirmation(this.FUIWindowConfirmation);
         this.FUIWindowConfirmation.SetCheckBoxUsable(true);
         this.FUIWindowRecharge = SUtilityOverLayer.UIWindowRecharge;
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.SERVEN_HERO_EVERY_ATTACK_COUNT) as TConfigValue;
         this.FBattleCount = _loc1_.Value as uint;
      }
      
      protected function SetRole(param1:MovieClip) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Vector.<TPillar> = null;
         var _loc5_:Vector.<TBigPillar> = null;
         var _loc6_:TPillar = null;
         var _loc7_:TBigPillar = null;
         switch(param1)
         {
            case this.FMC_AfterToFront:
               _loc4_ = this.FAfterToFront_SmallList;
               _loc5_ = this.FAfterToFront_BigList;
               break;
            case this.FMC_FrontToAfter:
               _loc4_ = this.FFrontToAfter_SmallList;
               _loc5_ = this.FFrontToAfter_BigList;
         }
         _loc3_ = HERO_NUM;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = new TPillar(this);
            _loc6_.Scence = param1["MC_Small_" + _loc2_];
            _loc6_.Tag = _loc2_;
            _loc6_.Init();
            _loc4_[_loc2_] = _loc6_;
            _loc7_ = new TBigPillar(this);
            _loc7_.Scence = param1["MC_Big_" + _loc2_];
            _loc7_.Tag = _loc2_;
            _loc7_.OnPracticeClick = this.PracticeOnClick;
            _loc7_.OnPracticeMove = this.PracticeOnMove;
            _loc7_.OnPracticeOut = this.PracticeOnOut;
            _loc7_.OnPillarMove = this.PillarOnMove;
            _loc7_.OnPillarOut = this.PillarOnOut;
            _loc7_.OnMonsterClick = this.MonsterOnClick;
            _loc7_.Init();
            _loc5_[_loc2_] = _loc7_;
            _loc2_++;
         }
      }
      
      protected function SetHeroID() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TSevenHeroArmy = null;
         _loc2_ = HERO_NUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SevenHeroArmy,CONST_SEVENHERO_BASEID + 3 * _loc1_) as TSevenHeroArmy;
            this.FAfterToFront_SmallList[_loc1_].HeroID = _loc3_.Model;
            this.FAfterToFront_BigList[_loc1_].HeroID = _loc3_.Model;
            this.FFrontToAfter_SmallList[_loc1_].HeroID = _loc3_.Model;
            this.FFrontToAfter_BigList[_loc1_].HeroID = _loc3_.Model;
            _loc1_++;
         }
         this.SetPillarState();
      }
      
      protected function SetPillarState() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TSevenHeroArmy = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         this.FSevenHeroArmy = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SevenHeroArmy,this.FSevenKingData.CurProgressFlag) as TSevenHeroArmy;
         if(this.FSevenHeroArmy == null)
         {
            _loc2_ = HERO_NUM;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FAfterToFront_BigList[_loc1_].PracticeCount = this.FSevenKingData.RespectInfo[_loc1_];
               this.FAfterToFront_BigList[_loc1_].UpdateState(TBigPillar.STATE_PASSED);
               this.FFrontToAfter_BigList[_loc1_].UpdateState(TBigPillar.STATE_PASSED);
               this.FFrontToAfter_BigList[_loc1_].IsPassed(true);
               this.FAfterToFront_BigList[_loc1_].IsPassed(true);
               this.FFrontToAfter_SmallList[_loc1_].IsPassed(true);
               this.FAfterToFront_SmallList[_loc1_].IsPassed(true);
               _loc1_++;
            }
            return;
         }
         _loc4_ = this.FSevenHeroArmy.ServenHero - TEMP_NUM;
         _loc2_ = HERO_NUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc1_ < _loc4_)
            {
               this.FAfterToFront_BigList[_loc1_].PracticeCount = this.FSevenKingData.RespectInfo[_loc1_];
               this.FAfterToFront_BigList[_loc1_].UpdateState(TBigPillar.STATE_PASSED);
               this.FFrontToAfter_BigList[_loc1_].UpdateState(TBigPillar.STATE_PASSED);
               this.FFrontToAfter_BigList[_loc1_].IsPassed(true);
               this.FFrontToAfter_BigList[_loc1_].PlayEffect(false);
               this.FAfterToFront_BigList[_loc1_].IsPassed(true);
               this.FAfterToFront_BigList[_loc1_].PlayEffect(false);
               this.FFrontToAfter_SmallList[_loc1_].IsPassed(true);
               this.FAfterToFront_SmallList[_loc1_].IsPassed(true);
            }
            else if(_loc1_ == _loc4_)
            {
               _loc5_ = uint(this.FSevenHeroArmy.SortNumber);
               this.FAfterToFront_BigList[_loc1_].Progressing = _loc5_;
               this.FFrontToAfter_BigList[_loc1_].Progressing = _loc5_;
               this.FAfterToFront_BigList[_loc1_].UpdateState(TBigPillar.STATE_FRIGHTING);
               this.FFrontToAfter_BigList[_loc1_].UpdateState(TBigPillar.STATE_FRIGHTING);
               this.FFrontToAfter_BigList[_loc1_].IsPassed(false);
               this.FAfterToFront_BigList[_loc1_].IsPassed(false);
               this.FFrontToAfter_SmallList[_loc1_].IsPassed(false);
               this.FAfterToFront_SmallList[_loc1_].IsPassed(false);
               this.FFrontToAfter_BigList[_loc1_].PlayEffect(true);
               this.FAfterToFront_BigList[_loc1_].PlayEffect(true);
            }
            else
            {
               this.FAfterToFront_BigList[_loc1_].UpdateState(TBigPillar.STATE_UNOPENED);
               this.FFrontToAfter_BigList[_loc1_].UpdateState(TBigPillar.STATE_UNOPENED);
               this.FFrontToAfter_BigList[_loc1_].IsPassed(false);
               this.FAfterToFront_BigList[_loc1_].IsPassed(false);
               this.FFrontToAfter_SmallList[_loc1_].IsPassed(false);
               this.FAfterToFront_SmallList[_loc1_].IsPassed(false);
               this.FFrontToAfter_BigList[_loc1_].PlayEffect(false);
               this.FAfterToFront_BigList[_loc1_].PlayEffect(false);
            }
            _loc1_++;
         }
      }
      
      protected function SetButton(param1:Boolean) : void
      {
         if(param1)
         {
            this.FBT_AfterToFront.gotoAndStop(FRAME_SELECT);
            this.FBT_FrontToAfter.gotoAndStop(FRAME_NORMAL);
            this.FMC_FrontToAfter.visible = false;
            this.FMC_AfterToFront.visible = true;
            this.FMC_AfterToFront.play();
         }
         else
         {
            this.FBT_AfterToFront.gotoAndStop(FRAME_NORMAL);
            this.FBT_FrontToAfter.gotoAndStop(FRAME_SELECT);
            this.FMC_FrontToAfter.visible = true;
            this.FMC_AfterToFront.visible = false;
            this.FMC_FrontToAfter.play();
         }
      }
      
      protected function GetRespectCost(param1:uint, param2:uint, param3:Array) : uint
      {
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc5_ = param1;
         while(_loc5_ > 0)
         {
            _loc6_ += parseInt(param3[param2]);
            param2++;
            _loc5_--;
         }
         return _loc6_;
      }
      
      protected function WindowConfirmationOnOK(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_SevenKing_RespectReq);
         _loc3_ = _loc2_.Data;
         _loc3_.writeUnsignedInt(this.FType);
         _loc3_.writeUnsignedInt(this.FRespectCount);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function PracticeOnClick(param1:Object, param2:uint, param3:uint) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:TSevenHeroDailyAward = null;
         var _loc6_:TConfigValue = null;
         var _loc7_:uint = 0;
         var _loc8_:Object = null;
         var _loc9_:uint = 0;
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.SERVEN_HERO_BATCH_WORSHIP_COUTN) as TConfigValue;
         this.FSelectKingIndex = param2;
         this.FType = TEMP_NUM + this.FSelectKingIndex;
         this.FRespectCount = param3;
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SevenHeroDailyAward,this.FType) as TSevenHeroDailyAward;
         _loc4_ = this.FSevenKingData.RespectInfo[this.FSelectKingIndex + 1];
         if(_loc4_ == 0)
         {
            if(this.FRespectCount == 1)
            {
               this.WindowConfirmationOnOK(null);
               return;
            }
         }
         _loc9_ = this.FVipData.SevenHeroCount - _loc4_;
         if(_loc9_ == 0)
         {
            if(this.FOnEffectText != null)
            {
               this.FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SEVENHERO_STRING_05));
            }
            return;
         }
         _loc8_ = _loc5_.RewardVect[_loc4_] as Object;
         _loc7_ = this.GetRespectCost(this.FRespectCount,_loc4_,_loc5_.CostVect);
         if(SLogicsCore.Character.CreditGold + SLogicsCore.Character.CreditGiftCertificate < _loc7_)
         {
            this.FUIWindowRecharge.Visible = true;
            return;
         }
         if(!this.FUIWindowConfirmation.IsSelected)
         {
            this.FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SEVENHERO_STRING_06),_loc7_);
            this.FUIWindowConfirmation.SetCheckBoxUsable(true);
            this.FUIWindowConfirmation.Visible = true;
         }
         else
         {
            this.WindowConfirmationOnOK(null);
         }
      }
      
      protected function PracticeOnMove(param1:Object, param2:uint, param3:uint) : void
      {
         var _loc4_:String = null;
         var _loc5_:TConfigValue = null;
         var _loc6_:TBins = null;
         var _loc7_:TSevenHeroDailyAward = null;
         var _loc8_:Object = null;
         var _loc9_:int = 0;
         var _loc10_:uint = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         if(param3 == TBigPillar.COUNT_ONEPRACTICE)
         {
            if(this.FVipData.SevenHeroOneKey)
            {
               _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.SERVEN_HERO_BATCH_WORSHIP_COUTN) as TConfigValue;
               _loc6_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SevenHeroDailyAward) as TBins;
               _loc7_ = _loc6_.GetDatebaseByIndex(param2) as TSevenHeroDailyAward;
               _loc12_ = _loc5_.Value as int;
               if(this.FSevenKingData.RespectInfo[param2 + 1] >= _loc7_.Cost.length - _loc12_)
               {
                  _loc4_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SEVENHERO_STRING_15),_loc12_);
               }
               else
               {
                  _loc11_ = 0;
                  while(_loc11_ < _loc12_)
                  {
                     _loc13_ += _loc7_.Cost[this.FSevenKingData.RespectInfo[param2 + 1] + _loc11_];
                     _loc11_++;
                  }
                  _loc4_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SEVENHERO_STRING_03),TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRINGS_KINGHERO)[param2],_loc5_.Value,_loc13_);
               }
            }
            else
            {
               _loc4_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SEVENHERO_STRING_04),this.FVipData.VipOpenLevel_SevenHeroOneKey);
            }
         }
         else if(param3 == TBigPillar.COUNT_PRACTICE)
         {
            _loc6_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SevenHeroDailyAward) as TBins;
            _loc7_ = _loc6_.GetDatebaseByIndex(param2) as TSevenHeroDailyAward;
            _loc10_ = this.FSevenKingData.RespectInfo[param2 + 1];
            _loc8_ = _loc7_.RewardVect[_loc10_] as Object;
            if(_loc10_ == 0)
            {
               _loc4_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SEVENHERO_STRING_01),TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRINGS_KINGSOUL)[param2],_loc8_["amount"]);
            }
            else
            {
               _loc9_ = this.FVipData.SevenHeroCount - _loc10_;
               if(_loc9_ > 0)
               {
                  _loc4_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SEVENHERO_STRING_02),_loc9_,_loc7_.Cost[this.FSevenKingData.RespectInfo[param2 + 1]],_loc8_["amount"],TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRINGS_KINGSOUL)[param2]);
               }
               else
               {
                  _loc4_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SEVENHERO_STRING_05);
               }
            }
         }
         this.FHint.Caption = _loc4_;
         if(this.FUIHintOnOver != null)
         {
            this.FUIHintOnOver(this,this.FHint);
         }
      }
      
      protected function PracticeOnOut(param1:Object) : void
      {
         if(this.FUIHintOnOut != null)
         {
            this.FUIHintOnOut(this,this.FHint);
         }
      }
      
      protected function PillarOnMove(param1:Object, param2:int) : void
      {
         var _loc3_:TSevenHeroDailyAward = null;
         var _loc4_:TBins = null;
         _loc4_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SevenHeroDailyAward) as TBins;
         _loc3_ = _loc4_.GetDatebaseByIndex(param2) as TSevenHeroDailyAward;
         if(this.FUIComponentsOnOver != null)
         {
            this.FUIComponentsOnOver(this,_loc3_);
         }
      }
      
      protected function PillarOnOut(param1:Object) : void
      {
         if(this.FUIComponentsOnOut != null)
         {
            this.FUIComponentsOnOut(this);
         }
      }
      
      protected function MonsterOnClick(param1:Object, param2:uint) : void
      {
         if(param2 + 1 != this.FSevenHeroArmy.SortNumber)
         {
            return;
         }
         if(this.FSevenKingData.CurBattleTimes >= this.FBattleCount)
         {
            if(this.FOnEffectText != null)
            {
               this.FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SEVENHERO_STRING_14));
            }
            return;
         }
         if(this.FSelectHeroFight != null)
         {
            this.FSelectHeroFight(this,this.FSevenHeroArmy);
         }
      }
      
      protected function ChangePersionOnClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = param1.currentTarget as MovieClip;
         if(_loc2_.currentFrame == FRAME_SELECT)
         {
            return;
         }
         switch(_loc2_)
         {
            case this.FBT_AfterToFront:
               this.FPositionBoo = true;
               break;
            case this.FBT_FrontToAfter:
               this.FPositionBoo = false;
         }
         _loc2_.buttonMode = false;
         this.SetButton(this.FPositionBoo);
      }
      
      protected function ChangePersionOnOver(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = param1.currentTarget as MovieClip;
         if(_loc2_.currentFrame == FRAME_SELECT)
         {
            return;
         }
         _loc2_.buttonMode = true;
      }
      
      protected function ChangePersionOnOut(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = param1.currentTarget as MovieClip;
         _loc2_.buttonMode = false;
      }
      
      public function get UIComponentsOnOut() : Function
      {
         return this.FUIComponentsOnOut;
      }
      
      public function set UIComponentsOnOut(param1:Function) : void
      {
         this.FUIComponentsOnOut = param1;
      }
      
      public function get SelectHeroFight() : Function
      {
         return this.FSelectHeroFight;
      }
      
      public function set SelectHeroFight(param1:Function) : void
      {
         this.FSelectHeroFight = param1;
      }
      
      public function get UIComponentsOnOver() : Function
      {
         return this.FUIComponentsOnOver;
      }
      
      public function set UIComponentsOnOver(param1:Function) : void
      {
         this.FUIComponentsOnOver = param1;
      }
      
      public function get UIHintOnOver() : Function
      {
         return this.FUIHintOnOver;
      }
      
      public function set UIHintOnOver(param1:Function) : void
      {
         this.FUIHintOnOver = param1;
      }
      
      public function get UIHintOnOut() : Function
      {
         return this.FUIHintOnOut;
      }
      
      public function set UIHintOnOut(param1:Function) : void
      {
         this.FUIHintOnOut = param1;
      }
      
      public function get SelectKingIndex() : uint
      {
         return this.FSelectKingIndex;
      }
      
      public function get RespectCount() : uint
      {
         return this.FRespectCount;
      }
      
      public function get OnEffectText() : Function
      {
         return this.FOnEffectText;
      }
      
      public function set OnEffectText(param1:Function) : void
      {
         this.FOnEffectText = param1;
      }
      
      public function HeroListInit() : void
      {
         this.UIDispatch();
      }
      
      public function UpdateUI() : void
      {
         this.SetButton(this.FPositionBoo);
         this.SetHeroID();
      }
      
      public function UpdatePillarState() : void
      {
         this.SetPillarState();
      }
      
      public function UpdateHero() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc2_ = HERO_NUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FAfterToFront_SmallList[_loc1_].UpdateHero();
            this.FAfterToFront_BigList[_loc1_].UpdateHero();
            this.FFrontToAfter_SmallList[_loc1_].UpdateHero();
            this.FFrontToAfter_BigList[_loc1_].UpdateHero();
            _loc1_++;
         }
      }
      
      public function Reset() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc2_ = HERO_NUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FAfterToFront_SmallList[_loc1_].Reset();
            this.FAfterToFront_BigList[_loc1_].Reset();
            this.FFrontToAfter_SmallList[_loc1_].Reset();
            this.FFrontToAfter_BigList[_loc1_].Reset();
            _loc1_++;
         }
      }
   }
}

