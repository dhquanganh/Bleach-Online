package Processors.Game.Lobby.FightPet
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.FightPet.*;
   import Logics.TimeCoolDown.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.Timing.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TLayerOver extends TProcessorLobbyWindow
   {
      
      protected static const RankNum:uint = 10;
      
      protected static const TYPE_MORALE:uint = 0;
      
      protected static const TYPE_RESURRECTION:uint = 1;
      
      protected static const STATE_HP_BAR0:uint = 1;
      
      protected static const STATE_HP_BAR1:uint = 2;
      
      protected static const STATE_HP_BAR2:uint = 3;
      
      protected static const STATE_HP_BAR3:uint = 4;
      
      protected static const STATE_HP_BAR4:uint = 5;
      
      protected static const OFFSIDE_ID:uint = 12500010;
      
      protected var FTF_Sliver:TextField;
      
      protected var FTF_Gold:TextField;
      
      protected var FTF_Coupons:TextField;
      
      protected var FTF_MyDamage:TextField;
      
      protected var FTF_AllPlayer:TextField;
      
      protected var FTF_MonsterName:TextField;
      
      protected var FTF_HP:TextField;
      
      protected var FTF_CDNumber:TextField;
      
      protected var FTF_CDTime:TextField;
      
      protected var FMC_Morale:Sprite;
      
      protected var FMC_Description:Sprite;
      
      protected var FMC_Bar:Sprite;
      
      protected var FMC_FightCD:Sprite;
      
      protected var FMC_EnterTownCD:Sprite;
      
      protected var FMC_ResurrectionCD:Sprite;
      
      protected var FMC_Light:Sprite;
      
      protected var FBT_MoraleUp:TUIButton;
      
      protected var FMC_ColourBar:MovieClip;
      
      protected var FMC_ColourBarGround:MovieClip;
      
      protected var FMC_BossHead:MovieClip;
      
      protected var FBT_Resurrection:SimpleButton;
      
      protected var FRankList:Vector.<Sprite>;
      
      protected var FCDNumbers:Vector.<MovieClip>;
      
      protected var FEnterTownCDNumbers:Vector.<MovieClip>;
      
      protected var FCharacter:TCharacter;
      
      protected var FTotalHP:uint;
      
      protected var FConfigValue:TBins;
      
      protected var FType:uint;
      
      protected var FCost:uint;
      
      protected var FTime:uint;
      
      protected var FEasterTime:uint;
      
      protected var FModalLayer:Sprite;
      
      protected var FTimeCoolDown:TTimeCoolDown;
      
      protected var FFightPetCoolDown:TTimeCoolDown;
      
      protected var FIsDie:Boolean;
      
      protected var FFightPetData:TFightPet;
      
      protected var FHint:THint;
      
      protected var FHelpTips:THint;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FUIWindowRecharge:TUIWindowRecharge;
      
      protected var FCostVect:Vector.<uint>;
      
      protected var FOnResurrection:Function;
      
      protected var FSetResurrectionStatue:Function;
      
      protected var FOnMoraleUp:Function;
      
      protected var FIsInitialization:Boolean;
      
      protected var FOnMoraleUpOver:Function;
      
      protected var FOnMoraleUpOut:Function;
      
      protected var FOnHelpOver:Function;
      
      protected var FOnHelpOut:Function;
      
      protected var FStarRun:Function;
      
      public function TLayerOver(param1:TUIComponent)
      {
         super(param1);
         this.FRankList = new Vector.<Sprite>(RankNum);
         this.FCDNumbers = new Vector.<MovieClip>(2);
         this.FEnterTownCDNumbers = new Vector.<MovieClip>(2);
         this.FCharacter = SLogicsCore.Character;
         this.FTimeCoolDown = new TTimeCoolDown(CONST_COMMON.TIME_COOLDOWN_FightPet_DieCD);
         SLogicsCore.TimeCoolDowns.Add(this.FTimeCoolDown);
         this.FFightPetCoolDown = new TTimeCoolDown(CONST_COMMON.TIME_COOLDOWN_FightPet_INIT);
         SLogicsCore.TimeCoolDowns.Add(this.FFightPetCoolDown);
         this.FHint = new THint();
         this.FHelpTips = new THint();
      }
      
      public function UIDispatch(param1:Sprite) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:MovieClip = null;
         super.ResourcesPerform_UIDispatch();
         addChild(param1);
         this.FTF_Sliver = param1[CONST_FIGHTPET.RESOURCE_TF_Sliver];
         this.FTF_Gold = param1[CONST_FIGHTPET.RESOURCE_TF_Gold];
         this.FTF_Coupons = param1[CONST_FIGHTPET.RESOURCE_TF_Coupons];
         this.FTF_MyDamage = param1[CONST_FIGHTPET.RESOURCE_TF_MyDamage];
         _loc4_ = RankNum;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = param1[CONST_FIGHTPET.RESOURCE_MC_Rank_ + _loc3_];
            switch(_loc3_)
            {
               case 0:
                  _loc2_["TF_Name"].textColor = CONST_COMMON.QUALITYCOLOR_INDEX[6];
                  _loc2_["TF_Damage"].textColor = CONST_COMMON.QUALITYCOLOR_INDEX[6];
                  break;
               case 1:
                  _loc2_["TF_Name"].textColor = CONST_COMMON.QUALITYCOLOR_INDEX[4];
                  _loc2_["TF_Damage"].textColor = CONST_COMMON.QUALITYCOLOR_INDEX[4];
                  break;
               case 2:
                  _loc2_["TF_Name"].textColor = CONST_COMMON.QUALITYCOLOR_INDEX[3];
                  _loc2_["TF_Damage"].textColor = CONST_COMMON.QUALITYCOLOR_INDEX[3];
                  break;
               default:
                  _loc2_["TF_Name"].textColor = 4294967142;
                  _loc2_["TF_Damage"].textColor = 4294967142;
            }
            this.FRankList[_loc3_] = _loc2_;
            _loc3_++;
         }
         this.FTF_AllPlayer = param1[CONST_FIGHTPET.RESOURCE_TF_AllPlayer];
         this.FMC_Morale = param1[CONST_FIGHTPET.RESOURCE_MC_Morale];
         this.FBT_MoraleUp = new TUIButton();
         this.FBT_MoraleUp.Substrate = param1[CONST_FIGHTPET.RESOURCE_BT_MoraleUp];
         this.FBT_MoraleUp.OnClick = this.MoraleUpOnClick;
         this.FMC_Description = param1[CONST_FIGHTPET.RESOURCE_MC_Description];
         _loc2_ = param1[CONST_FIGHTPET.RESOURCE_MC_Head];
         this.FTF_MonsterName = _loc2_[CONST_FIGHTPET.RESOURCE_TF_MonsterName];
         this.FTF_HP = _loc2_[CONST_FIGHTPET.RESOURCE_TF_HP];
         this.FMC_Bar = _loc2_[CONST_FIGHTPET.RESOURCE_MC_Bar];
         this.FMC_ColourBar = _loc2_[CONST_FIGHTPET.RESOURCE_MC_ColourBar];
         this.FMC_ColourBarGround = _loc2_[CONST_FIGHTPET.RESOURCE_MC_ColourBarGround];
         this.FMC_BossHead = _loc2_[CONST_FIGHTPET.RESOURCE_MC_BossHead];
         this.FMC_Light = _loc2_[CONST_FIGHTPET.RESOURCE_MC_Light];
         this.FTF_CDTime = param1[CONST_FIGHTPET.RESOURCE_TF_CDTime];
         this.FTF_CDTime.mouseEnabled = false;
         this.FModalLayer = new Sprite();
         addChild(this.FModalLayer);
         this.FModalLayer.addChild(new Bitmap(SUtilityResource.BtmDataFullScreen));
         this.FModalLayer.visible = false;
         this.FMC_FightCD = TUtilityReflection.CreateDisplayObjectInstance(CONST_FIGHTPET.RESOURCE_ClassName_MC_FightCD) as Sprite;
         addChild(this.FMC_FightCD);
         this.FMC_FightCD.x = (CONST_COMMON.STAGE_Width - this.FMC_FightCD.width) / 2;
         this.FMC_FightCD.y = (CONST_COMMON.STAGE_Height - this.FMC_FightCD.height) / 2;
         _loc4_ = 2;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this.FMC_FightCD[CONST_FIGHTPET.RESOURCE_MC_Number_ + _loc3_];
            this.FCDNumbers[_loc3_] = _loc5_;
            _loc3_++;
         }
         this.FMC_EnterTownCD = TUtilityReflection.CreateDisplayObjectInstance(CONST_FIGHTPET.RESOURCE_ClassName_MC_EnterTownCD) as Sprite;
         addChild(this.FMC_EnterTownCD);
         this.FMC_EnterTownCD.x = (CONST_COMMON.STAGE_Width - this.FMC_EnterTownCD.width) / 2;
         this.FMC_EnterTownCD.y = (CONST_COMMON.STAGE_Height - this.FMC_EnterTownCD.height) / 2;
         _loc4_ = 2;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this.FMC_EnterTownCD[CONST_FIGHTPET.RESOURCE_MC_Number_ + _loc3_];
            this.FEnterTownCDNumbers[_loc3_] = _loc5_;
            _loc3_++;
         }
         this.FMC_ResurrectionCD = TUtilityReflection.CreateDisplayObjectInstance(CONST_FIGHTPET.RESOURCE_ClassName_MC_ResurrectionCD) as Sprite;
         addChild(this.FMC_ResurrectionCD);
         this.FMC_ResurrectionCD.x = (CONST_COMMON.STAGE_Width - this.FMC_ResurrectionCD.width) / 2;
         this.FMC_ResurrectionCD.y = (CONST_COMMON.STAGE_Height - this.FMC_ResurrectionCD.height) / 2;
         this.FTF_CDNumber = this.FMC_ResurrectionCD[CONST_FIGHTPET.RESOURCE_TF_CDNumber];
         this.FBT_Resurrection = this.FMC_ResurrectionCD[CONST_FIGHTPET.RESOURCE_BT_Resurrection];
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         this.FUIWindowRecharge = SUtilityOverLayer.UIWindowRecharge;
         this.FIsInitialization = true;
      }
      
      public function UILocation() : void
      {
         var _loc1_:TConfigValue = null;
         super.ResourcesPerform_UILocations();
         this.FBT_Resurrection.addEventListener(MouseEvent.CLICK,this.ResurrectionOnClick);
         this.FMC_Morale.addEventListener(MouseEvent.MOUSE_MOVE,this.MoraleOnMove);
         this.FMC_Description.addEventListener(MouseEvent.MOUSE_MOVE,this.DescriptionOnMove);
         this.FBT_Resurrection.addEventListener(MouseEvent.MOUSE_MOVE,this.ResurrectionOnMove);
         this.FMC_Morale.addEventListener(MouseEvent.MOUSE_OUT,this.MoraleOnOut);
         this.FMC_Description.addEventListener(MouseEvent.MOUSE_OUT,this.DescriptionOnOut);
         this.FBT_Resurrection.addEventListener(MouseEvent.MOUSE_OUT,this.ResurrectionOnOut);
         this.FConfigValue = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         _loc1_ = this.FConfigValue.GetDatebaseByIdentifier(CONST_CONFIGVALUE.FIGHTPET_REVIVECOST) as TConfigValue;
         this.FCostVect = _loc1_.Value as Vector.<uint>;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(!this.FIsInitialization)
         {
            return;
         }
         this.FTF_Sliver.text = this.FCharacter.CreditSilverCoin.ToString();
         if(this.FCharacter.CreditSilverCoin.ToNumber() / 10000 > 1)
         {
            this.FTF_Sliver.text = Math.floor(this.FCharacter.CreditSilverCoin.ToNumber() / 10000).toString() + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Thousand);
         }
         this.FTF_Gold.text = this.FCharacter.CreditGold.toString();
         this.FTF_Coupons.text = this.FCharacter.CreditGiftCertificate.toString();
         if(!this.FFightPetData.GameOver && SLogicsCore.Character.RoleSencePosition == CONST_COMMON.SCENEPOSITION_FIGHTPET)
         {
            this.UpdateActivityColdTime();
         }
         if(this.FIsDie)
         {
            this.FTF_CDNumber.text = this.FTimeCoolDown.TimingTime.toString();
            if(this.FTimeCoolDown.TimingTime == 0)
            {
               this.FIsDie = false;
               this.FMC_ResurrectionCD.visible = false;
               this.FModalLayer.visible = false;
               if(this.FSetResurrectionStatue != null)
               {
                  this.FSetResurrectionStatue();
               }
            }
         }
      }
      
      protected function GetReviveCost() : int
      {
         if(this.FFightPetData.ReviveTimes < this.FCostVect.length)
         {
            return this.FCostVect[this.FFightPetData.ReviveTimes];
         }
         return this.FCostVect[this.FCostVect.length - 1];
      }
      
      private function WindowInformationOnOK(param1:Object) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = this.FCharacter.CreditGold + this.FCharacter.CreditGiftCertificate;
         if(_loc2_ < this.FCost)
         {
            this.FUIWindowRecharge.visible = true;
            return;
         }
         if(this.FType == TYPE_MORALE)
         {
            if(this.FOnMoraleUp != null)
            {
               this.FOnMoraleUp();
            }
         }
      }
      
      private function UpdateMonterInfo(param1:TFightPet) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc5_ = param1.MonsterHP;
         _loc4_ = param1.MonsterTotaleHP;
         this.FTF_MonsterName.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FIGHTPET_STRING_02),param1.MonsterLV,param1.MonsterName);
         this.FTF_HP.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FIGHTPET_STRING_01),_loc5_,_loc4_);
         if(_loc5_ > _loc4_ * 0.8)
         {
            this.FMC_ColourBar.gotoAndStop(STATE_HP_BAR0);
            this.FMC_ColourBarGround.gotoAndStop(STATE_HP_BAR0);
            _loc5_ -= _loc4_ * 0.8;
            _loc3_ = _loc4_ - _loc4_ * 0.8;
         }
         else if(_loc5_ > _loc4_ * 0.6 && _loc5_ <= _loc4_ * 0.8)
         {
            this.FMC_ColourBar.gotoAndStop(STATE_HP_BAR1);
            this.FMC_ColourBarGround.gotoAndStop(STATE_HP_BAR1);
            _loc5_ -= _loc4_ * 0.6;
            _loc3_ = _loc4_ * 0.8 - _loc4_ * 0.6;
         }
         else if(_loc5_ > _loc4_ * 0.4 && _loc5_ <= _loc4_ * 0.6)
         {
            this.FMC_ColourBar.gotoAndStop(STATE_HP_BAR2);
            this.FMC_ColourBarGround.gotoAndStop(STATE_HP_BAR2);
            _loc5_ -= _loc4_ * 0.4;
            _loc3_ = _loc4_ * 0.6 - _loc4_ * 0.4;
         }
         else if(_loc5_ > _loc4_ * 0.2 && _loc5_ <= _loc4_ * 0.4)
         {
            this.FMC_ColourBar.gotoAndStop(STATE_HP_BAR3);
            this.FMC_ColourBarGround.gotoAndStop(STATE_HP_BAR3);
            _loc5_ -= _loc4_ * 0.2;
            _loc3_ = _loc4_ * 0.4 - _loc4_ * 0.2;
         }
         else
         {
            this.FMC_ColourBar.gotoAndStop(STATE_HP_BAR4);
            this.FMC_ColourBarGround.gotoAndStop(STATE_HP_BAR4);
            _loc5_ = _loc5_;
            _loc3_ = _loc4_ * 0.2;
         }
         _loc2_ = _loc5_ / _loc3_;
         if(_loc2_ > 1)
         {
            _loc2_ = 1;
         }
         this.FMC_Bar.scaleX = _loc2_;
         this.FMC_Light.x = this.FMC_Bar.x + this.FMC_Bar.width;
         _loc6_ = this.FFightPetData.MonsterModleID - OFFSIDE_ID;
         this.FMC_BossHead.gotoAndStop(_loc6_ + 1);
      }
      
      private function ResetRankList() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc2_ = RankNum;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FRankList[_loc1_].visible = false;
            _loc1_++;
         }
         this.FTF_MyDamage.visible = false;
      }
      
      private function UpdateRank(param1:TFightPet) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Number = NaN;
         var _loc6_:String = null;
         this.ResetRankList();
         _loc5_ = param1.MainPlayerDamage.ToNumber() / param1.MonsterTotaleHP * 100;
         this.FTF_MyDamage.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FIGHTPET_STRING_04),param1.MainPlayerDamage.ToString(),_loc5_.toFixed(2));
         this.FTF_MyDamage.visible = true;
         _loc3_ = param1.TopTenRank.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = param1.TopTenRank[_loc2_].Name;
            _loc4_ = param1.TopTenRank[_loc2_].Damage.ToNumber();
            _loc5_ = _loc4_ / param1.MonsterTotaleHP * 100;
            this.FRankList[_loc2_]["TF_Name"].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FIGHTPET_STRING_05),_loc2_ + 1,_loc6_);
            this.FRankList[_loc2_]["TF_Damage"].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FIGHTPET_STRING_04),_loc4_,_loc5_.toFixed(2));
            this.FRankList[_loc2_].visible = true;
            _loc2_++;
         }
      }
      
      private function updateCDTime(param1:uint) : void
      {
         this.FMC_FightCD.visible = true;
         this.FModalLayer.visible = true;
      }
      
      protected function UpdateActivityColdTime() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = 1800;
         if(this.FFightPetCoolDown.TimingTime <= 30 * 60)
         {
            _loc1_ = this.FFightPetCoolDown.TimingTime;
            if(this.FStarRun != null)
            {
               this.FStarRun();
            }
         }
         this.FTF_CDTime.text = TUtilityTiming.fomatTime(_loc1_);
      }
      
      private function ResurrectionOnClick(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc2_ = this.FTimeCoolDown.TimingTime;
         _loc3_ = Math.ceil(_loc2_ / 10) * this.GetReviveCost();
         if(_loc3_ > this.FCharacter.CreditGold + this.FCharacter.CreditGiftCertificate)
         {
            this.FUIWindowRecharge.visible = true;
            return;
         }
         if(this.FTimeCoolDown.TimingTime == 0)
         {
            return;
         }
         if(this.FOnResurrection != null)
         {
            this.FOnResurrection();
         }
      }
      
      private function ResurrectionOnMove(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc2_ = this.FTimeCoolDown.TimingTime;
         _loc3_ = Math.ceil(_loc2_ / 10) * this.GetReviveCost();
         this.FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FIGHTPET_STRING_07),_loc3_);
         if(this.FOnMoraleUpOver != null)
         {
            this.FOnMoraleUpOver(this,this.FHint);
         }
      }
      
      private function ResurrectionOnOut(param1:MouseEvent) : void
      {
         if(this.FOnMoraleUpOut != null)
         {
            this.FOnMoraleUpOut(this,this.FHint);
         }
      }
      
      private function MoraleUpOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TConfigValue = null;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc6_:Vector.<Object> = null;
         var _loc7_:Vector.<Object> = null;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         _loc3_ = this.FConfigValue.GetDatebaseByIdentifier(CONST_CONFIGVALUE.FIGHTPET_MORALENUMBER) as TConfigValue;
         _loc4_ = uint(_loc3_.Value[this.FFightPetData.InspireCount]);
         _loc5_ = "";
         _loc8_ = 0;
         _loc3_ = this.FConfigValue.GetDatebaseByIdentifier(CONST_CONFIGVALUE.FIGHTPET_MORALEUP_PROPERTY) as TConfigValue;
         _loc6_ = _loc3_.Value as Vector.<Object>;
         _loc3_ = this.FConfigValue.GetDatebaseByIdentifier(CONST_CONFIGVALUE.FIGHTPET_MORALEUP_POINT) as TConfigValue;
         _loc7_ = _loc3_.Value as Vector.<Object>;
         _loc10_ = _loc6_.length;
         _loc9_ = 0;
         while(_loc9_ < _loc10_)
         {
            _loc8_ = uint(_loc7_[this.FFightPetData.InspireCount][_loc9_]);
            _loc5_ += _loc6_[_loc9_] + "+" + _loc8_.toString() + "% ";
            _loc9_++;
         }
         this.FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FIGHTPET_STRING_06),_loc4_,_loc5_);
         this.FUIWindowConfirmation.OnOK = this.WindowInformationOnOK;
         this.FUIWindowConfirmation.Visible = true;
         this.FType = TYPE_MORALE;
         this.FCost = _loc4_;
      }
      
      private function DescriptionOnMove(param1:MouseEvent) : void
      {
         if(TUtilityString.Empty(this.FHelpTips.Content))
         {
            this.FHelpTips.Content = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELPTIPS_FIGHTPET);
         }
         if(this.FOnHelpOver != null)
         {
            this.FOnHelpOver(this,this.FHelpTips);
         }
      }
      
      private function DescriptionOnOut(param1:MouseEvent) : void
      {
         if(this.FOnHelpOut != null)
         {
            this.FOnHelpOut(this,this.FHelpTips);
         }
      }
      
      private function MoraleOnOut(param1:MouseEvent) : void
      {
         if(this.FOnMoraleUpOut != null)
         {
            this.FOnMoraleUpOut(this,this.FHint);
         }
      }
      
      private function MoraleOnMove(param1:MouseEvent) : void
      {
         var _loc2_:TConfigValue = null;
         var _loc3_:String = null;
         var _loc4_:Vector.<Object> = null;
         var _loc5_:Vector.<Object> = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         _loc3_ = "";
         _loc6_ = 0;
         _loc2_ = this.FConfigValue.GetDatebaseByIdentifier(CONST_CONFIGVALUE.FIGHTPET_MORALEUP_PROPERTY) as TConfigValue;
         _loc4_ = _loc2_.Value as Vector.<Object>;
         _loc2_ = this.FConfigValue.GetDatebaseByIdentifier(CONST_CONFIGVALUE.FIGHTPET_MORALEUP_POINT) as TConfigValue;
         _loc5_ = _loc2_.Value as Vector.<Object>;
         _loc8_ = _loc4_.length;
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            if(this.FFightPetData.InspireCount == 0)
            {
               _loc6_ = 0;
            }
            else
            {
               _loc6_ = uint(_loc5_[this.FFightPetData.InspireCount - 1][_loc7_]);
            }
            _loc3_ += _loc4_[_loc7_] + "+" + _loc6_.toString() + "%\n";
            _loc7_++;
         }
         this.FHint.Caption = _loc3_;
         if(this.FOnMoraleUpOver != null)
         {
            this.FOnMoraleUpOver(this,this.FHint);
         }
      }
      
      public function get TotalHP() : uint
      {
         return this.FTotalHP;
      }
      
      public function set TotalHP(param1:uint) : void
      {
         this.FTotalHP = param1;
      }
      
      public function get OnResurrection() : Function
      {
         return this.FOnResurrection;
      }
      
      public function set OnResurrection(param1:Function) : void
      {
         this.FOnResurrection = param1;
      }
      
      public function get OnMoraleUp() : Function
      {
         return this.FOnMoraleUp;
      }
      
      public function set OnMoraleUp(param1:Function) : void
      {
         this.FOnMoraleUp = param1;
      }
      
      public function get IsInitialization() : Boolean
      {
         return this.FIsInitialization;
      }
      
      public function set FightPetData(param1:TFightPet) : void
      {
         this.FFightPetData = param1;
      }
      
      public function get OnMoraleUpOver() : Function
      {
         return this.FOnMoraleUpOver;
      }
      
      public function set OnMoraleUpOver(param1:Function) : void
      {
         this.FOnMoraleUpOver = param1;
      }
      
      public function get OnMoraleUpOut() : Function
      {
         return this.FOnMoraleUpOut;
      }
      
      public function set OnMoraleUpOut(param1:Function) : void
      {
         this.FOnMoraleUpOut = param1;
      }
      
      public function get SetResurrectionStatue() : Function
      {
         return this.FSetResurrectionStatue;
      }
      
      public function set SetResurrectionStatue(param1:Function) : void
      {
         this.FSetResurrectionStatue = param1;
      }
      
      public function set FightPetCoolDown(param1:uint) : void
      {
         this.FFightPetCoolDown.TimingTime = param1;
      }
      
      public function get OnHelpOver() : Function
      {
         return this.FOnHelpOver;
      }
      
      public function set OnHelpOver(param1:Function) : void
      {
         this.FOnHelpOver = param1;
      }
      
      public function get OnHelpOut() : Function
      {
         return this.FOnHelpOut;
      }
      
      public function set OnHelpOut(param1:Function) : void
      {
         this.FOnHelpOut = param1;
      }
      
      public function set StarRun(param1:Function) : void
      {
         this.FStarRun = param1;
      }
      
      public function get IsCoolDown() : Boolean
      {
         return this.FMC_EnterTownCD.visible || this.FMC_FightCD.visible || this.FMC_ResurrectionCD.visible || this.FTimeCoolDown.TimingTime > 0;
      }
      
      public function UpdateMonster(param1:TFightPet) : void
      {
         this.UpdateMonterInfo(param1);
      }
      
      public function UpdatePlayerNum(param1:uint) : void
      {
         this.FTF_AllPlayer.text = param1.toString();
      }
      
      public function Init(param1:TFightPet) : void
      {
         this.FMC_ResurrectionCD.visible = false;
         this.FMC_FightCD.visible = false;
         this.FMC_EnterTownCD.visible = false;
         this.UpdateMonterInfo(param1);
         this.UpdateRank(param1);
         this.FTF_AllPlayer.text = param1.AllplayerCount.toString();
         this.UpdateInspire();
      }
      
      public function RankUpdate(param1:TFightPet) : void
      {
         this.UpdateRank(param1);
      }
      
      public function DieCDUpdate(param1:uint) : void
      {
         this.FTimeCoolDown.TimingTime = param1;
         this.FIsDie = true;
      }
      
      public function BattleBackUpdate() : void
      {
         if(this.FTimeCoolDown.TimingTime > 0)
         {
            this.FMC_ResurrectionCD.visible = true;
            this.FModalLayer.visible = true;
         }
         else
         {
            this.FMC_ResurrectionCD.visible = false;
            this.FModalLayer.visible = false;
         }
         if(this.FFightPetData.GameOver)
         {
            this.FMC_ResurrectionCD.visible = false;
            this.FModalLayer.visible = false;
         }
      }
      
      public function InfoCDUpdate(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(param1 == 0)
         {
            this.FMC_FightCD.visible = false;
            this.FModalLayer.visible = false;
         }
         else
         {
            this.FMC_FightCD.visible = true;
            this.FModalLayer.visible = true;
            _loc2_ = Math.floor(param1 / 10);
            this.FCDNumbers[0].gotoAndStop(_loc2_ + 1);
            _loc2_ = param1 % 10;
            this.FCDNumbers[1].gotoAndStop(_loc2_ + 1);
         }
      }
      
      public function BackTownCDUpdate(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(param1 == 0)
         {
            this.FMC_EnterTownCD.visible = false;
            this.FModalLayer.visible = false;
         }
         else
         {
            this.FMC_EnterTownCD.visible = true;
            this.FMC_FightCD.visible = false;
            this.FModalLayer.visible = false;
            _loc2_ = Math.floor(param1 / 10);
            this.FEnterTownCDNumbers[0].gotoAndStop(_loc2_ + 1);
            _loc2_ = param1 % 10;
            this.FEnterTownCDNumbers[1].gotoAndStop(_loc2_ + 1);
         }
      }
      
      public function Resurrection() : void
      {
         this.FTimeCoolDown.TimingTime = 0;
      }
      
      public function UpdateInspire() : void
      {
         var _loc1_:TConfigValue = null;
         _loc1_ = this.FConfigValue.GetDatebaseByIdentifier(CONST_CONFIGVALUE.FIGHTPET_MORALENUMBER) as TConfigValue;
         if(this.FFightPetData.InspireCount == _loc1_.Value.length)
         {
            this.FBT_MoraleUp.Enabled = false;
         }
         else
         {
            this.FBT_MoraleUp.Enabled = true;
         }
      }
   }
}

