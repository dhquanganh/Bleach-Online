package Processors.Game.Lobby.HerosNew
{
   import Components.Standard.TUIButton;
   import Foundation.Common.Integer.UInt64;
   import Foundation.Common.THint;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.Characters.THero;
   import Logics.CustomHero.TCurHero;
   import Logics.DatebaseVO.VO.TBaseHero;
   import Logics.DatebaseVO.VO.THeroChangeAttr;
   import Logics.DatebaseVO.VO.THeroExp;
   import Logics.DatebaseVO.VO.TTimeHero;
   import Logics.HeroNew.TWakeHeroAttributes;
   import Logics.Inventories.TCollectionInventory;
   import Logics.Inventories.TCrashJade;
   import Logics.Inventories.TEquipment;
   import Logics.Inventories.TInventory;
   import Logics.Rebirth.TRebirthData;
   import Logics.SLogicsCore;
   import Processors.Game.Common.Effects.Display.TEffectBaseGlow;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.HerosNew.Component.THeroPetInfor;
   import Processors.Game.Lobby.HerosNew.Component.THeroWakeLevelItem;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.HyperLink.SUtilityHyperLink;
   import Processors.Game.Utilities.HyperLink.TUtilityHyperLink;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_INVENTORY;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import Utilities.Timing.TUtilityTiming;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class TWindowDecoration extends TProcessorLobbyWindow
   {
      
      public static const ElementType_Level:int = 0;
      
      public static const ElementType_ExpBar:int = 1;
      
      public static const ElementType_Star:int = 2;
      
      public static const ElementType_CrashJade:int = 3;
      
      public static const ElementType_FightPower:int = 4;
      
      public static const ElementType_Talismans:int = 5;
      
      public static const ElementType_Profession:int = 6;
      
      public static const ElementType_ChangeSchdule:int = 7;
      
      public static const ElementType_Unlist:int = 8;
      
      public static const ElementType_HeroRent:int = 9;
      
      public static const ElementType_WakeUp:int = 10;
      
      public static const ElementType_RelatedPartner:int = 11;
      
      public static const ElementType_Pet:int = 12;
      
      public static const ElementType_CustomHero:int = 13;
      
      protected static const MaxStarNum:int = 7;
      
      protected static const CATEGORY_TreasurePower:uint = CONST_INVENTORY.CATEGORYSECOND_TreasurePower;
      
      protected var FElementsUI:Vector.<DisplayObject>;
      
      protected var FRenderFunctions:Vector.<Function>;
      
      protected var FHint:THint;
      
      protected var FTFLevel:TextField;
      
      protected var FTFExp:TextField;
      
      protected var FExpBar:Sprite;
      
      protected var FStar:MovieClip;
      
      protected var FBtnCrashJade:TUIButton;
      
      protected var FTFFightingPower:TextField;
      
      protected var FBtn_Taslisman:TUIButton;
      
      protected var FMCProfession:MovieClip;
      
      protected var FHeroChangeStar:Sprite;
      
      protected var FHeroChangeLightStars:Vector.<Sprite>;
      
      protected var FHeroChangeDarkStars:Vector.<Sprite>;
      
      protected var FChangeLevelNames:Vector.<String>;
      
      protected var FBtnUnlist:TUIButton;
      
      protected var FMCRent:Sprite;
      
      protected var FCountDownTF:TextField;
      
      protected var FBtn_Renew:TUIButton;
      
      protected var FRentBar:Sprite;
      
      protected var FEffect_Renew:TEffectBaseGlow;
      
      protected var FOpenRenewOnClick:Function;
      
      protected var FBtnWake:TUIButton;
      
      protected var FWakeHint:THint;
      
      protected var FWakeItem:THeroWakeLevelItem;
      
      protected var FWakeAttributes:TWakeHeroAttributes;
      
      protected var FBtnRelatedPartner:TUIButton;
      
      protected var FBtnPet:TUIButton;
      
      protected var FPetInforTip:THeroPetInfor;
      
      protected var FBtnCustomHero:TUIButton;
      
      protected var FCustomHero:TCurHero;
      
      protected var FCustomHint:THint;
      
      protected var FRebirthData:TRebirthData;
      
      protected var FHero:THero;
      
      protected var FElements:Vector.<int>;
      
      public function TWindowDecoration(param1:TUIComponent)
      {
         this.FRenderFunctions = Vector.<Function>([this.RenderLevel,this.RenderExpBar,this.RenderStar,this.RenderCrashJade,this.RenderFightPower,this.RenderTalismans,this.RenderProfession,this.RenderChangeSchdule,this.RenderBtnUnlist,this.RenderRent,this.RenderWakeUp,this.RenderRelatedPatner,this.RenderPet,this.RenderCustomHero]);
         super(param1);
         this.FRebirthData = SLogicsCore.RebirthData;
      }
      
      public function UIDispatch(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.FElementsUI = new Vector.<DisplayObject>();
         this.FHint = new THint();
         this.FCustomHint = new THint();
         this.FWakeHint = new THint();
         this.FElementsUI.push(param1["TF_Level"]);
         this.FElementsUI.push(param1["ExpBar"]);
         this.FElementsUI.push(param1["MC_Assess"]);
         this.FElementsUI.push(param1["MC_CrashPower"]);
         this.FElementsUI.push(param1["TF_FightingCapacity"]);
         this.FElementsUI.push(param1["MC_InforPanle"]["Btn_Treasure"]);
         this.FElementsUI.push(param1["MC_Profession"]);
         this.FElementsUI.push(param1["HeroChangLevel"]);
         this.FElementsUI.push(param1["MC_Btn_Dismiss"]);
         this.FElementsUI.push(param1["MCRent"]);
         this.FElementsUI.push(param1["MC_InforPanle"]["MC_Wake"]);
         this.FElementsUI.push(param1["MC_InforPanle"]["RelatedPartner"]);
         this.FElementsUI.push(param1["MC_InforPanle"]["MC_Pet"]);
         this.FElementsUI.push(param1["MC_CustomHero"]);
         this.FTFLevel = param1["TF_Level"];
         this.FTFExp = param1["ExpBar"]["TF_Experience"];
         this.FExpBar = param1["ExpBar"]["MC_ProgressBarExp"];
         this.FStar = param1["MC_Assess"];
         this.FStar.addEventListener(MouseEvent.MOUSE_MOVE,this.OnStarMove);
         this.FStar.addEventListener(MouseEvent.MOUSE_OUT,this.OnStarOut);
         this.FBtnCrashJade = new TUIButton();
         this.FBtnCrashJade.Substrate = param1["MC_CrashPower"];
         this.FBtnCrashJade.OnMove = this.BtnCrashJadeOnMove;
         this.FBtnCrashJade.OnOut = this.HintOnOut;
         this.FTFFightingPower = param1["TF_FightingCapacity"];
         this.FBtn_Taslisman = new TUIButton();
         this.FBtn_Taslisman.Substrate = this.FElementsUI[ElementType_Talismans] as MovieClip;
         this.FBtn_Taslisman.OnMove = this.BtnTaslismanOnMove;
         this.FBtn_Taslisman.OnOut = this.HintOnOut;
         this.FBtn_Taslisman.OnClick = this.BtnTreasureOnClick;
         this.FMCProfession = param1["MC_Profession"];
         this.FHeroChangeStar = param1["HeroChangLevel"];
         if(this.FHeroChangeStar != null)
         {
            this.FHeroChangeStar.visible = false;
            this.FHeroChangeStar.addEventListener(MouseEvent.MOUSE_MOVE,this.StarOnMouseOver);
            this.FHeroChangeStar.addEventListener(MouseEvent.MOUSE_OUT,this.StarOnMouseOut);
         }
         this.FHeroChangeStar.visible = true;
         this.FHeroChangeLightStars = new Vector.<Sprite>();
         this.FHeroChangeDarkStars = new Vector.<Sprite>();
         _loc2_ = 0;
         while(_loc2_ < MaxStarNum)
         {
            this.FHeroChangeLightStars.push(this.FHeroChangeStar["Lightstar" + _loc2_]);
            this.FHeroChangeDarkStars.push(this.FHeroChangeStar["Darkstar" + _loc2_]);
            _loc2_++;
         }
         this.FBtnUnlist = new TUIButton();
         this.FBtnUnlist.Substrate = param1["MC_Btn_Dismiss"];
         this.FBtnUnlist.OnClick = this.BtnUnlistOnClick;
         this.FMCRent = param1["MCRent"];
         this.FMCRent.visible = false;
         this.FCountDownTF = this.FMCRent["Mc_Timer"]["TF_Time"];
         this.FBtn_Renew = new TUIButton();
         this.FBtn_Renew.Substrate = this.FMCRent["Btn_Renew"];
         this.FBtn_Renew.OnClick = this.BtnRenewOnClick;
         this.FRentBar = this.FMCRent["MC_GoldBar"]["MC_GoldBar"];
         this.FEffect_Renew = new TEffectBaseGlow();
         this.FEffect_Renew.SetParameters(this.FBtn_Renew.Substrate,16755236,1);
         this.FBtnWake = new TUIButton();
         this.FBtnWake.Substrate = this.FElementsUI[ElementType_WakeUp] as MovieClip;
         this.FBtnWake.OnMove = this.WakeOnMouseOver;
         this.FBtnWake.OnOut = this.WakeOnMouseOut;
         this.FWakeItem = new THeroWakeLevelItem(param1["MC_WakeMap"]);
         this.FWakeItem.WakeAttributes = this.FWakeAttributes;
         this.FBtnRelatedPartner = new TUIButton();
         this.FBtnRelatedPartner.Substrate = this.FElementsUI[ElementType_RelatedPartner] as MovieClip;
         this.FBtnPet = new TUIButton();
         this.FBtnPet.Substrate = this.FElementsUI[ElementType_Pet] as MovieClip;
         this.FBtnPet.OnOver = this.BtnPetOnOver;
         this.FBtnPet.OnOut = this.BtnPetOnOut;
         this.FPetInforTip = new THeroPetInfor(this.Parent.Parent);
         this.FPetInforTip.UIDispatch();
         this.FElements = new Vector.<int>();
         this.FBtnCustomHero = new TUIButton();
         this.FBtnCustomHero.Substrate = this.FElementsUI[ElementType_CustomHero] as MovieClip;
         this.FBtnCustomHero.OnOver = this.BtnCustomHeroOnOver;
         this.FBtnCustomHero.OnOut = this.BtnCustomHeroOnOut;
      }
      
      protected function RenderSlectors(param1:Vector.<int>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = int(this.FElementsUI.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FElementsUI[_loc2_].visible = false;
            _loc2_++;
         }
         _loc3_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1[_loc2_];
            this.FRenderFunctions[_loc4_]();
            _loc2_++;
         }
      }
      
      protected function RenderLevel() : void
      {
         var _loc1_:String = null;
         this.FElementsUI[ElementType_Level].visible = true;
         _loc1_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_05);
         this.FTFLevel.text = TUtilityString.Format(_loc1_,this.FHero.RebirthLevel);
      }
      
      protected function RenderExpBar() : void
      {
         var _loc1_:String = null;
         var _loc2_:Number = NaN;
         var _loc3_:THeroExp = null;
         var _loc4_:UInt64 = null;
         this.FElementsUI[ElementType_ExpBar].visible = true;
         _loc1_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_03);
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HeroExp,this.FHero.RebirthLevel) as THeroExp;
         _loc4_ = this.FRebirthData.CalNeedExpByUInt64(_loc3_.NeedExp,this.FHero.RebirthNum);
         _loc2_ = this.FHero.Experience.ToNumber() / _loc4_.ToNumber();
         _loc2_ = Math.min(_loc2_,1);
         this.FTFExp.text = TUtilityString.Format(_loc1_,this.FHero.Experience.ToString(),_loc4_.ToString());
         this.FExpBar.scaleX = _loc2_;
      }
      
      protected function RenderStar() : void
      {
         var _loc1_:TBaseHero = null;
         this.FElementsUI[ElementType_Star].visible = true;
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,this.FHero.Identifier) as TBaseHero;
         this.FStar.gotoAndStop(_loc1_.Assess);
      }
      
      protected function RenderCrashJade() : void
      {
         this.FElementsUI[ElementType_CrashJade].visible = true;
      }
      
      protected function RenderFightPower() : void
      {
         this.FElementsUI[ElementType_FightPower].visible = true;
         this.FTFFightingPower.text = this.FHero.BaseAttributeFightingPower.toString();
      }
      
      protected function RenderTalismans() : void
      {
         this.FElementsUI[ElementType_Talismans].visible = true;
      }
      
      protected function RenderProfession() : void
      {
         this.FElementsUI[ElementType_Profession].visible = true;
         this.FMCProfession.gotoAndStop(this.FHero.Profession);
      }
      
      protected function RenderChangeSchdule() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:THeroChangeAttr = null;
         this.FElementsUI[ElementType_ChangeSchdule].visible = true;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HeroChangeAttr,this.FHero.Identifier) as THeroChangeAttr;
         if(_loc3_ == null)
         {
            this.FHeroChangeStar.visible = false;
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < MaxStarNum)
         {
            this.FHeroChangeLightStars[_loc1_].visible = _loc1_ < this.FHero.ChangeSchedule;
            this.FHeroChangeDarkStars[_loc1_].visible = _loc1_ < _loc3_.HeroStar.length;
            _loc1_++;
         }
      }
      
      protected function RenderBtnUnlist() : void
      {
         this.FElementsUI[ElementType_Unlist].visible = SLogicsCore.Character.MainHero != this.FHero;
      }
      
      protected function RenderRent() : void
      {
         var _loc1_:TTimeHero = null;
         var _loc2_:Number = NaN;
         this.FElementsUI[ElementType_HeroRent].visible = true;
         if(this.FHero.HeroOverTime == 0)
         {
            this.FMCRent.visible = false;
            return;
         }
         this.FMCRent.visible = true;
         this.UpdateRent();
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_TimeHero,this.FHero.Identifier) as TTimeHero;
         _loc2_ = this.FHero.HeroCostGold / _loc1_.ForeverCost;
         _loc2_ = _loc2_ > 1 ? 1 : _loc2_;
         this.FRentBar.scaleX = _loc2_;
      }
      
      protected function RenderWakeUp() : void
      {
         this.FBtnWake.Visible = true;
         this.FBtnWake.Enabled = this.FHero != SLogicsCore.Character.MainHero;
         this.FWakeItem.SetData(this.FHero);
      }
      
      protected function RenderRelatedPatner() : void
      {
         this.FBtnRelatedPartner.Visible = true;
         this.FBtnRelatedPartner.Enabled = false;
      }
      
      protected function RenderPet() : void
      {
         this.FElementsUI[ElementType_Pet].visible = true;
         this.FPetInforTip.Hero = this.FHero;
      }
      
      protected function RenderCustomHero() : void
      {
         this.FElementsUI[ElementType_CustomHero].visible = true;
         this.FCustomHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Exclusive_CloseViewTxt);
      }
      
      protected function BackVector(param1:Vector.<int>, param2:Vector.<int>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         param2.length = 0;
         _loc4_ = int(param1.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            param2[_loc3_] = param1[_loc3_];
            _loc3_++;
         }
      }
      
      protected function UpdatePetTip() : void
      {
         if(this.FPetInforTip.Visible)
         {
            this.FPetInforTip.Update();
         }
      }
      
      protected function UpdateRent() : void
      {
         var _loc1_:int = 0;
         this.FEffect_Renew.Run();
         _loc1_ = this.FHero.HeroOverTime - STimingCore.ServerTick;
         _loc1_ = _loc1_ < 0 ? 0 : _loc1_;
         this.FCountDownTF.text = TUtilityTiming.fomatTimeTwo(_loc1_);
      }
      
      protected function IfCollectionInventoryEmpty(param1:TCollectionInventory) : Boolean
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:TInventory = null;
         _loc2_ = uint(param1.Capacity);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.GetInventoryByIndex(_loc3_);
            if(_loc4_ != null)
            {
               return false;
            }
            _loc3_++;
         }
         return true;
      }
      
      protected function CheckIfCanUnlist() : Boolean
      {
         var _loc1_:Boolean = false;
         if(!this.IfCollectionInventoryEmpty(this.FHero.EquipmentsMounted))
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_11));
            return false;
         }
         if(!this.IfCollectionInventoryEmpty(this.FHero.TalismansMounted))
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_12));
            return false;
         }
         if(!this.IfCollectionInventoryEmpty(this.FHero.OrnamentsMounted))
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_31));
            return false;
         }
         return true;
      }
      
      protected function OnStarMove(param1:MouseEvent) : void
      {
         var _loc2_:TBaseHero = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:String = null;
         _loc7_ = "";
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,this.FHero.Identifier) as TBaseHero;
         _loc3_ = _loc2_.PowerGrow;
         _loc5_ = _loc2_.AgileGrow;
         _loc4_ = _loc2_.IntelligenceGrow;
         _loc6_ = _loc2_.LifeGrow;
         if(this.FHero.IsMain)
         {
            _loc3_ = this.FHero.FirstAttributePowerRate;
            _loc4_ = this.FHero.FirstAttributeIntelligenceRate;
            _loc5_ = this.FHero.FirstAttributeAgileRate;
            _loc6_ = this.FHero.FirstAttributeHealthRate;
         }
         if(this.FHero.CustomHero != null)
         {
            _loc7_ += TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_14),_loc3_ + " (+" + this.FHero.CustomHero.CurGrowth[0].toFixed(2) + ")");
            _loc7_ = _loc7_ + TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_15),_loc4_ + " (+" + this.FHero.CustomHero.CurGrowth[2].toFixed(2) + ")");
            _loc7_ = _loc7_ + TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_16),_loc5_ + " (+" + this.FHero.CustomHero.CurGrowth[1].toFixed(2) + ")");
            _loc7_ = _loc7_ + TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_17),_loc6_ + " (+" + this.FHero.CustomHero.CurGrowth[3].toFixed(2) + ")");
         }
         else
         {
            _loc7_ += TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_14),_loc3_ + " (+0.00)");
            _loc7_ = _loc7_ + TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_15),_loc4_ + " (+0.00)");
            _loc7_ = _loc7_ + TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_16),_loc5_ + " (+0.00)");
            _loc7_ = _loc7_ + TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_17),_loc6_ + " (+0.00)");
         }
         this.FHint.Caption = _loc7_;
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function OnStarOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      protected function BtnTaslismanOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:TCollectionInventory = null;
         var _loc7_:TEquipment = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:Boolean = false;
         _loc10_ = true;
         _loc5_ = "";
         _loc6_ = this.FHero.TalismansMounted;
         _loc4_ = _loc6_.Capacity;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc7_ = _loc6_.GetInventoryByIndex(_loc3_) as TEquipment;
            if(_loc7_ != null)
            {
               _loc9_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRINGS_TreasuresAttributeCaption)[_loc7_.CategorySecond % CATEGORY_TreasurePower];
               _loc8_ = this.FHero.GetFirstAttributeByIndex(_loc3_).toFixed();
               _loc5_ += TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_04),_loc7_.Name,_loc9_,_loc8_);
               _loc10_ = false;
            }
            _loc3_++;
         }
         if(!_loc10_)
         {
            this.FHint.Caption = _loc5_;
            SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
         }
      }
      
      protected function BtnCrashJadeOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:TCrashJade = null;
         _loc7_ = 0;
         _loc8_ = "";
         _loc4_ = this.FHero.CrashJadeMounted.Capacity;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc9_ = this.FHero.CrashJadeMounted.GetInventoryByIndex(_loc3_) as TCrashJade;
            if(_loc9_ != null)
            {
               _loc8_ += _loc9_.Name + ":" + "\n";
               _loc6_ = int(_loc9_.AddAttributeType.length);
               _loc5_ = 0;
               while(_loc5_ < _loc6_)
               {
                  _loc8_ += TUtilityString.Format("%0 + %1",TUtilityLobby.GetAttributeName(_loc9_.AddAttributeType[_loc5_]),_loc9_.AddAttributeValue[_loc5_] <= 1 ? Number(_loc9_.AddAttributeValue[_loc5_] * 100).toFixed(2) + "%" : _loc9_.AddAttributeValue[_loc5_]);
                  _loc8_ = _loc8_ + "\n";
                  _loc5_++;
               }
               _loc8_ += "\n";
               _loc7_ += _loc9_.JadePower;
            }
            _loc3_++;
         }
         _loc8_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_11),_loc7_) + "\n" + _loc8_;
         this.FHint.Caption = _loc8_;
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function HintOnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      protected function StarOnMouseOver(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOver(this,SLogicsCore.HeroChangeData.GetHeroChangeByHeroID(this.FHero.Identifier));
      }
      
      protected function StarOnMouseOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,SLogicsCore.HeroChangeData.GetHeroChangeByHeroID(this.FHero.Identifier));
      }
      
      protected function BtnTreasureOnClick(param1:Object, param2:MouseEvent) : void
      {
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Treasure);
      }
      
      protected function BtnRenewOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOpenRenewOnClick != null)
         {
            this.FOpenRenewOnClick(this.FHero);
         }
      }
      
      protected function BtnUnlistOnClick(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_06);
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.DismissOnOk;
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
      }
      
      protected function WakeOnMouseOver(param1:Object, param2:MouseEvent) : void
      {
         if(this.FHero == SLogicsCore.Character.MainHero)
         {
            return;
         }
         this.FWakeHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_52),this.FHero.WakeupLevel);
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FWakeHint);
      }
      
      protected function WakeOnMouseOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FWakeHint);
      }
      
      protected function DismissOnOk(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         if(!this.CheckIfCanUnlist())
         {
            return;
         }
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Heros_DeleteHero);
         _loc2_.Data.writeUnsignedInt(this.FHero.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function BtnPetOnOver(param1:Object, param2:MouseEvent) : void
      {
         if(SLogicsCore.Character.MainHero.MainPetID != 0 || (this.FHero.VicePetHighID | this.FHero.VicePetLowID) != 0)
         {
            this.FPetInforTip.Visible = true;
         }
      }
      
      protected function BtnPetOnOut(param1:Object, param2:MouseEvent) : void
      {
         this.FPetInforTip.Reset();
         this.FPetInforTip.Visible = false;
      }
      
      protected function BtnCustomHeroOnOver(param1:Object, param2:MouseEvent) : void
      {
         if(this.FHero.CustomHero != null)
         {
            SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHero.CustomHero);
         }
         else
         {
            SUtilityOverLayer.UIComponentsHintOnOver(this,this.FCustomHint);
         }
      }
      
      protected function BtnCustomHeroOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FHero.CustomHero != null)
         {
            SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHero.CustomHero);
         }
         else
         {
            SUtilityOverLayer.UIComponentsHintOnOut(this,this.FCustomHint);
         }
      }
      
      public function set WakeAttributes(param1:TWakeHeroAttributes) : void
      {
         this.FWakeAttributes = param1;
      }
      
      public function set OpenRenewOnClick(param1:Function) : void
      {
         this.FOpenRenewOnClick = param1;
      }
      
      public function SwitchDecoration(param1:THero, param2:Vector.<int>) : void
      {
         this.FHero = param1;
         this.BackVector(param2,this.FElements);
         this.RenderSlectors(this.FElements);
         this.FWakeItem.Close();
      }
      
      public function Update() : void
      {
         this.RenderSlectors(this.FElements);
      }
      
      public function Running() : void
      {
         this.UpdateRent();
         this.UpdatePetTip();
         this.FWakeItem.Update();
      }
   }
}

