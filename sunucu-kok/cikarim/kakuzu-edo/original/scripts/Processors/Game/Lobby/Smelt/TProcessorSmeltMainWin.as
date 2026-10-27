package Processors.Game.Lobby.Smelt
{
   import Components.Standard.TUIButton;
   import Components.Standard.TUITab;
   import Foundation.Common.THint;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TAnimationFrame;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.Characters.THero;
   import Logics.Characters.THeros;
   import Logics.CustomHero.TCustomHeroExp;
   import Logics.DatebaseVO.VO.TArticle;
   import Logics.DatebaseVO.VO.THeroChangeAttr;
   import Logics.DatebaseVO.VO.TOrnamentValue;
   import Logics.DatebaseVO.VO.TPartnerChange;
   import Logics.HeroChange.THeroChange;
   import Logics.Inventories.TEquipment;
   import Logics.KnifeOfKillSoul.TKnifeOfKillSoulData;
   import Logics.KnifeOfKillSoul.TKnifeOfkillSoulDatas;
   import Logics.KnifeOfKillSoul.VO.TKnifeStrengthenAdd;
   import Logics.RelatedPartner.TRelatedPartnerHeroSkill;
   import Logics.SLogicsCore;
   import Logics.Streamization.Smelt.TUnstreamizerSmelt;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.RelatedPartner.TRelatedPartnerCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_CONFIGVALUE;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_KNIFEOFKILLSOUL;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TProcessorSmeltMainWin extends TProcessorLobbyWindow
   {
      
      protected static const EXPDATABASE:uint = 14500000;
      
      protected var FMainUI:MovieClip;
      
      protected var FTab:TUITab;
      
      protected var FBtnAddHero:TUIButton;
      
      protected var FBtnAddKnifeOfKillSoul:TUIButton;
      
      protected var FResetBtn0:TUIButton;
      
      protected var FResetBtn1:TUIButton;
      
      protected var FHeroSelect:TProcessorHeroSelect;
      
      protected var FTabIndex:uint;
      
      protected var FHero:THero;
      
      protected var FBmpHead:Bitmap;
      
      protected var FBmpKnifeOfKillSoul:Bitmap;
      
      protected var FCurLevel:uint;
      
      protected var FCurArticleCount:uint;
      
      protected var FCurExp:Number;
      
      protected var FGrade:uint;
      
      protected var FUnstreamizer:TUnstreamizerSmelt;
      
      protected var FHeros:THeros;
      
      protected var FHint:THint;
      
      protected var FItemSelect:TProcessorItemSelect;
      
      protected var FSlotID:uint;
      
      protected var FTemplateID:uint;
      
      protected var FPos:uint;
      
      private var FKnifeOfKillSoulData:TKnifeOfKillSoulData;
      
      private var FKnifeOfKillSoulDatas:TKnifeOfkillSoulDatas;
      
      public function TProcessorSmeltMainWin(param1:TUIComponent)
      {
         super(param1);
         this.FHeros = new THeros();
         this.FKnifeOfKillSoulDatas = new TKnifeOfkillSoulDatas();
         this.FUnstreamizer = new TUnstreamizerSmelt();
         this.FHint = new THint();
         this.FTabIndex = 0;
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_SmeltMainWin") as MovieClip;
         addChild(this.FMainUI);
         this.FTab = new TUITab(this);
         this.FTab.SetTabByIndex(this.FMainUI.MC_Tab0,0);
         this.FTab.SetTabByIndex(this.FMainUI.MC_Tab1,1);
         this.FTab.SetTabByIndex(this.FMainUI.MC_Tab2,2);
         this.FTab.SetTabByIndex(this.FMainUI.MC_Tab3,3);
         this.FTab.SetTabByIndex(this.FMainUI.MC_Tab4,4);
         if(this.FMainUI["MC_Tab4"] != null)
         {
            this.FTab.SetTabByIndex(this.FMainUI.MC_Tab5,5);
         }
         this.FTab.OnSwitch = this.OnSwitchFunction;
         this.FTab.Init();
         this.FBtnAddHero = new TUIButton();
         this.FBtnAddHero.Substrate = this.FMainUI.Btn_SelectHero;
         this.FBtnAddHero.OnClick = this.BtnAddHeroOnClick;
         this.FBtnAddKnifeOfKillSoul = new TUIButton();
         this.FBtnAddKnifeOfKillSoul.Substrate = this.FMainUI.Btn_SelectKnifeOfKillSoul;
         this.FBtnAddKnifeOfKillSoul.OnClick = this.BtnAddKnifeOfKillSoulOnClick;
         this.FResetBtn0 = new TUIButton();
         this.FResetBtn0.Tag = 0;
         this.FResetBtn0.Substrate = this.FMainUI.Btn_Reset0;
         this.FResetBtn0.OnClick = this.OnResetBtnClick;
         this.FResetBtn1 = new TUIButton();
         this.FResetBtn1.Tag = 1;
         this.FResetBtn1.Substrate = this.FMainUI.Btn_Reset1;
         this.FResetBtn1.OnClick = this.OnResetBtnClick;
         this.FHeroSelect = new TProcessorHeroSelect(Parent);
         this.FHeroSelect.Visible = false;
         this.FHeroSelect.SelectHero = this.OnSelectHero;
         this.FHeroSelect.SelectKnifeOfKillSoul = this.OnSelectKnifeOfKillSoul;
         this.FHeroSelect.UIDispatch();
         this.FItemSelect = new TProcessorItemSelect(this);
         this.FItemSelect.UIDispatch(this.FMainUI.MC_ItemSelect);
         this.FItemSelect.Visible = false;
         this.FItemSelect.Select = this.OnSelectItem;
         this.ProcessorFilterHeros();
         this.FHero = this.FHeros.Count > 0 ? this.FHeros.GetHeroByIndex(0) : null;
         this.FBmpHead = new Bitmap();
         this.FMainUI.MC_Head.addChild(this.FBmpHead);
         this.FBmpKnifeOfKillSoul = new Bitmap();
         this.FMainUI.MC_KnifeOfKillSoul.addChild(this.FBmpKnifeOfKillSoul);
         this.FMainUI.Btn_Close.addEventListener(MouseEvent.CLICK,this.OnCloseBtnClick);
         this.FMainUI.Btn_Help.addEventListener(MouseEvent.MOUSE_MOVE,this.OnHelpBtnMove);
         this.FMainUI.Btn_Help.addEventListener(MouseEvent.MOUSE_OUT,this.OnHelpBtnOut);
         X = (CONST_COMMON.STAGE_Width - Width) / 2;
         Y = (CONST_COMMON.STAGE_Height - Height) / 2;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UIFinalize() : void
      {
         this.FHint.Content = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELPTIPS_Smelt);
         super.ResourcesPerform_UIFinalize();
      }
      
      protected function GetChangeShred() : uint
      {
         var _loc1_:THeroChangeAttr = null;
         var _loc2_:Vector.<int> = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TPartnerChange = null;
         if(this.FHero == null)
         {
            return 0;
         }
         _loc4_ = 0;
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HeroChangeAttr,this.FHero.Identifier) as THeroChangeAttr;
         _loc2_ = _loc1_.HeroStar;
         _loc3_ = this.FCurLevel;
         _loc5_ = 0;
         while(_loc5_ < _loc3_)
         {
            _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_PartnerChange,_loc2_[_loc5_]) as TPartnerChange;
            _loc4_ += _loc6_.Rewards.Amount[0];
            _loc5_++;
         }
         return _loc4_;
      }
      
      protected function GetExclusiveShred() : uint
      {
         var _loc1_:uint = 0;
         var _loc2_:TCustomHeroExp = null;
         var _loc3_:uint = 0;
         if(this.FCurLevel == 0)
         {
            return 0;
         }
         _loc1_ = 0;
         _loc3_ = 1;
         while(_loc3_ <= this.FCurLevel)
         {
            _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_CustomHeroExp,EXPDATABASE + _loc3_) as TCustomHeroExp;
            _loc1_ += _loc2_.NeedExp;
            _loc3_++;
         }
         return _loc1_;
      }
      
      protected function GetRebirthStone() : uint
      {
         var _loc1_:Vector.<uint> = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc3_ = 0;
         _loc1_ = TUtilityLobby.GetConfigValue(CONST_CONFIGVALUE.Rebirth_RebirthCostCount) as Vector.<uint>;
         _loc2_ = 0;
         while(_loc2_ < this.FCurLevel)
         {
            _loc3_ += _loc1_[_loc2_];
            _loc2_++;
         }
         return _loc3_;
      }
      
      protected function GetSoulOfConquestNum() : uint
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         _loc2_ = 3;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ += this.FKnifeOfKillSoulData.StrengthenAdd[_loc1_].TotalExp;
            _loc1_++;
         }
         return _loc3_;
      }
      
      protected function GetExp() : Number
      {
         var _loc1_:Vector.<Object> = null;
         var _loc2_:uint = 0;
         var _loc3_:Number = NaN;
         _loc3_ = 0;
         _loc1_ = TUtilityLobby.GetConfigValue(CONST_CONFIGVALUE.Rebirth_ReduceLevel) as Vector.<Object>;
         _loc2_ = 0;
         while(_loc2_ < this.FCurLevel)
         {
            _loc3_ += Number(_loc1_[_loc2_]);
            _loc2_++;
         }
         return _loc3_;
      }
      
      protected function GetRelatedItem() : Number
      {
         var _loc1_:Vector.<Object> = null;
         var _loc2_:uint = 0;
         var _loc3_:Number = NaN;
         _loc3_ = 0;
         _loc1_ = TUtilityLobby.GetConfigValue(CONST_CONFIGVALUE.Rebirth_ReduceLevel) as Vector.<Object>;
         _loc2_ = 0;
         while(_loc2_ < this.FCurLevel - 1)
         {
            _loc3_ += Number(_loc1_[_loc2_]);
            _loc2_++;
         }
         return _loc3_;
      }
      
      protected function UpdateInfo(param1:uint) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:Vector.<Object> = null;
         var _loc4_:Object = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         _loc2_ = this.FMainUI["MC_Info" + param1];
         if(this.FTabIndex == 0)
         {
            _loc3_ = TUtilityLobby.GetConfigValue(CONST_CONFIGVALUE.Smelt_ChangeReturnNeed) as Vector.<Object>;
            _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Smelt_08);
            _loc2_.TF_Article1.text = "";
         }
         else if(this.FTabIndex == 1)
         {
            _loc3_ = TUtilityLobby.GetConfigValue(CONST_CONFIGVALUE.Smelt_ExclusiveReturnNeed) as Vector.<Object>;
            _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Smelt_09);
            _loc2_.TF_Article1.text = "";
         }
         else if(this.FTabIndex == 2)
         {
            _loc3_ = TUtilityLobby.GetConfigValue(CONST_CONFIGVALUE.Smelt_RebirthReturnNeed) as Vector.<Object>;
            _loc4_ = _loc3_[param1];
            _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Smelt_10);
            _loc6_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Smelt_11);
            _loc2_.TF_Article1.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Smelt_11),this.GetSuperExpBook(_loc4_["return"]));
         }
         else if(this.FTabIndex == 3)
         {
            _loc3_ = TUtilityLobby.GetConfigValue(CONST_CONFIGVALUE.Smelt_RelatedNeed) as Vector.<Object>;
            _loc4_ = _loc3_[param1];
            _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Smelt_18);
            _loc6_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Smelt_11);
            _loc2_.TF_Article1.text = "";
         }
         else if(this.FTabIndex == 4)
         {
            _loc3_ = TUtilityLobby.GetConfigValue(CONST_CONFIGVALUE.Smelt_OrnamentNeed) as Vector.<Object>;
            _loc4_ = _loc3_[param1];
            _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Smelt_19);
            _loc6_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Smelt_11);
            _loc2_.TF_Article1.text = "";
         }
         else if(this.FTabIndex == 5)
         {
            _loc3_ = TUtilityLobby.GetConfigValue(CONST_CONFIGVALUE.Smelt_12) as Vector.<Object>;
            _loc4_ = _loc3_[param1];
            _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Smelt_22);
            _loc2_.TF_Article1.text = "";
         }
         _loc4_ = _loc3_[param1];
         _loc2_.TF_Cost.text = String(_loc4_.gold);
         _loc2_.TF_Return.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Smelt_14),_loc4_["return"] + "%");
         _loc2_.TF_Article0.text = TUtilityString.Format(_loc5_,Math.ceil(this.FCurArticleCount * _loc4_["return"] / 100));
      }
      
      protected function GetSuperExpBook(param1:uint) : uint
      {
         var _loc2_:TArticle = null;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,int(TUtilityLobby.GetConfigValue(CONST_CONFIGVALUE.Smelt_RebirthReturnExp))) as TArticle;
         return Math.ceil(this.FCurExp * param1 / 100 / _loc2_.FunctionValue);
      }
      
      protected function ProcessorFilterHeros() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:THero = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THeroChange = null;
         var _loc7_:int = 0;
         var _loc8_:uint = 0;
         this.FHeros.Clear();
         _loc2_ = uint(SLogicsCore.Character.Heros.Count);
         _loc1_ = 0;
         for(; _loc1_ < _loc2_; _loc1_++)
         {
            _loc3_ = SLogicsCore.Character.Heros.GetHeroByIndex(_loc1_);
            if(!_loc3_.IsMain && _loc3_.Quality >= int(TUtilityLobby.GetConfigValue(CONST_CONFIGVALUE.Smelt_HeroQualityLimit)))
            {
               if(this.FTabIndex == 0)
               {
                  _loc6_ = SLogicsCore.HeroChangeData.GetHeroChangeByHeroID(_loc3_.Identifier);
                  _loc4_ = uint(_loc6_.Hero.ChangeSchedule);
               }
               else if(this.FTabIndex == 1)
               {
                  _loc4_ = _loc3_.CustomHero == null ? 0 : _loc3_.CustomHero.Level;
               }
               else if(this.FTabIndex == 2)
               {
                  _loc4_ = _loc3_.RebirthNum;
               }
               else if(this.FTabIndex == 3)
               {
                  if(TRelatedPartnerCommon.HeroDatas.GetHeroDataByIdentifier(_loc3_.Identifier) != null)
                  {
                     _loc8_ = TRelatedPartnerCommon.HeroDatas.GetHeroDataByIdentifier(_loc3_.Identifier).HeroSkills.length;
                     _loc4_ = 0;
                     _loc7_ = 0;
                     while(_loc7_ < _loc8_)
                     {
                        if(TRelatedPartnerCommon.HeroDatas.GetHeroDataByIdentifier(_loc3_.Identifier).HeroSkills[_loc7_].CurSkill != null)
                        {
                           if(TRelatedPartnerCommon.HeroDatas.GetHeroDataByIdentifier(_loc3_.Identifier).HeroSkills[_loc7_].CurSkill.Level >= 2)
                           {
                              _loc4_ = 99;
                              break;
                           }
                        }
                        _loc7_++;
                     }
                  }
                  else
                  {
                     _loc4_ = 0;
                  }
               }
               if(_loc4_ > 0)
               {
                  if(this.FTabIndex == 0)
                  {
                     _loc5_ = uint(int(TUtilityLobby.GetConfigValue(CONST_CONFIGVALUE.Smelt_HeroChangeLimit)));
                     if(_loc4_ < _loc5_)
                     {
                        continue;
                     }
                  }
                  this.FHeros.Add(_loc3_);
               }
            }
         }
      }
      
      protected function ProcessorFilterKnifeOfKillSouls() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:TKnifeOfKillSoulData = null;
         var _loc5_:TKnifeOfkillSoulDatas = null;
         var _loc6_:TKnifeStrengthenAdd = null;
         this.FKnifeOfKillSoulDatas.Clear();
         _loc3_ = uint(SLogicsCore.Character.KnifeSoul.ChangedID);
         _loc5_ = SLogicsCore.Character.KnifeOfKillSoul;
         _loc2_ = _loc5_.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = _loc5_.GetByIndex(_loc1_);
            if(_loc4_.CurrentState == CONST_KNIFEOFKILLSOUL.KNIFESTATE_UNLOCK)
            {
               for each(_loc6_ in _loc4_.StrengthenAdd)
               {
                  if(_loc6_.Level > 1)
                  {
                     this.FKnifeOfKillSoulDatas.Add(_loc4_);
                     break;
                  }
               }
            }
            _loc1_++;
         }
         this.FKnifeOfKillSoulDatas.Sort();
      }
      
      protected function Reset() : void
      {
         this.FBmpHead.bitmapData = null;
         this.FBmpKnifeOfKillSoul.bitmapData = null;
         this.FTab.SwithTagManual(0);
      }
      
      protected function OnSwitchFunction(param1:int) : void
      {
         this.FHero = null;
         this.FKnifeOfKillSoulData = null;
         this.FTabIndex = param1;
         if(this.FTabIndex == 4)
         {
            this.FMainUI.MC_ItemSelect.visible = true;
            this.UpdateUI(false);
         }
         else if(this.FTabIndex == 5)
         {
            this.FMainUI.MC_ItemSelect.visible = false;
            this.UpdateUI(false,true);
         }
         else
         {
            this.FMainUI.MC_ItemSelect.visible = false;
            this.UpdateUI(true);
         }
      }
      
      protected function BtnAddHeroOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.ProcessorFilterHeros();
         this.FHeroSelect.Heros = this.FHeros;
         this.FHeroSelect.Visible = true;
      }
      
      protected function BtnAddKnifeOfKillSoulOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.ProcessorFilterKnifeOfKillSouls();
         this.FHeroSelect.KnifeOfKillSoulDatas = this.FKnifeOfKillSoulDatas;
         this.FHeroSelect.Visible = true;
      }
      
      protected function OnResetBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:Vector.<Object> = null;
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         _loc5_ = uint(int(TUtilityLobby.GetConfigValue(CONST_CONFIGVALUE.Smelt_HeroChangeLimit)));
         if(this.FTabIndex == 0)
         {
            if(this.FHero.ChangeSchedule < _loc5_)
            {
               SToolReward.ShowMessage(TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Smelt_13),_loc5_));
               return;
            }
            _loc3_ = TUtilityLobby.GetConfigValue(CONST_CONFIGVALUE.Smelt_ChangeReturnNeed) as Vector.<Object>;
         }
         else if(this.FTabIndex == 1)
         {
            _loc3_ = TUtilityLobby.GetConfigValue(CONST_CONFIGVALUE.Smelt_ExclusiveReturnNeed) as Vector.<Object>;
         }
         else if(this.FTabIndex == 2)
         {
            _loc3_ = TUtilityLobby.GetConfigValue(CONST_CONFIGVALUE.Smelt_RebirthReturnNeed) as Vector.<Object>;
         }
         else if(this.FTabIndex == 3)
         {
            _loc3_ = TUtilityLobby.GetConfigValue(CONST_CONFIGVALUE.Smelt_RelatedNeed) as Vector.<Object>;
         }
         else if(this.FTabIndex == 4)
         {
            _loc3_ = TUtilityLobby.GetConfigValue(CONST_CONFIGVALUE.Smelt_OrnamentNeed) as Vector.<Object>;
         }
         else if(this.FTabIndex == 5)
         {
            _loc3_ = TUtilityLobby.GetConfigValue(CONST_CONFIGVALUE.Smelt_12) as Vector.<Object>;
         }
         this.FGrade = (param1 as TUIButton).Tag;
         _loc4_ = _loc3_[this.FGrade];
         TUtilityLobby.GoldBuy(_loc4_.gold,this.OnResetBtnClickOK);
      }
      
      protected function OnSelectHero(param1:THero) : void
      {
         var _loc2_:THeroChange = null;
         if(this.FTabIndex == 0)
         {
            _loc2_ = SLogicsCore.HeroChangeData.GetHeroChangeByHeroID(param1.Identifier);
            this.FHero = _loc2_.Hero;
         }
         else
         {
            this.FHero = param1;
         }
         this.UpdateUI(false);
      }
      
      protected function OnSelectKnifeOfKillSoul(param1:TKnifeOfKillSoulData) : void
      {
         var _loc2_:THeroChange = null;
         this.FKnifeOfKillSoulData = this.FKnifeOfKillSoulDatas.GetByIndentifier(param1.ID);
         this.UpdateUI(false,false);
      }
      
      protected function OnSelectItem(param1:uint, param2:uint, param3:uint) : void
      {
         var _loc4_:THeroChange = null;
         if(this.FTabIndex == 4)
         {
            this.FSlotID = param1;
            this.FTemplateID = param2;
            this.FPos = param3;
         }
         this.UpdateUI(false);
      }
      
      protected function TextureArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:BitmapData = null;
         var _loc5_:TAnimationFrame = null;
         _loc5_ = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0);
         _loc4_ = _loc5_.Surface;
         if(this.FHero != null && this.FHero.LargeID == param3)
         {
            this.FBmpHead.bitmapData = _loc4_;
         }
         else if(this.FKnifeOfKillSoulData != null && this.FKnifeOfKillSoulData.ID == param3)
         {
            this.FBmpKnifeOfKillSoul.bitmapData = _loc4_;
            this.FBmpKnifeOfKillSoul.x = -_loc5_.Bounds.Width / 2;
            this.FBmpKnifeOfKillSoul.y = -_loc5_.Bounds.Height / 2;
         }
      }
      
      protected function OnCloseBtnClick(param1:MouseEvent) : void
      {
         this.Reset();
         ProcessorWindowClose();
      }
      
      protected function OnResetBtnClickOK(param1:Object) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(this.FHero != null)
         {
            _loc2_ = this.FHero.Identifier;
         }
         if(this.FKnifeOfKillSoulData != null)
         {
            _loc3_ = this.FKnifeOfKillSoulData.ID;
         }
         this.FUnstreamizer.ResetReq(this.FTabIndex,_loc2_,_loc3_,this.FSlotID,this.FTemplateID,this.FGrade);
      }
      
      protected function OnHelpBtnMove(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function OnHelpBtnOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      public function UpdateUI(param1:Boolean, param2:Boolean = false) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc7_:int = 0;
         var _loc8_:uint = 0;
         var _loc9_:Vector.<TRelatedPartnerHeroSkill> = null;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:int = 0;
         var _loc13_:TEquipment = null;
         var _loc14_:TBins = null;
         var _loc15_:TOrnamentValue = null;
         var _loc16_:int = 0;
         var _loc17_:TKnifeStrengthenAdd = null;
         if(param1)
         {
            this.ProcessorFilterHeros();
            this.FHero = this.FHeros.Count > 0 ? this.FHeros.GetHeroByIndex(0) : null;
            this.FBtnAddHero.Visible = true;
            this.FBtnAddKnifeOfKillSoul.Visible = false;
         }
         this.FBmpHead.bitmapData = null;
         if(this.FHero != null)
         {
            SResourcesCore.TexturesLargeIcon.LoadAutoSecondary(this.FHero.LargeID,this.TextureArrive);
         }
         if(param2)
         {
            this.ProcessorFilterKnifeOfKillSouls();
            this.FKnifeOfKillSoulData = this.FKnifeOfKillSoulDatas.Count > 0 ? this.FKnifeOfKillSoulDatas.GetByIndex(0) : null;
            this.FBtnAddHero.Visible = false;
            this.FBtnAddKnifeOfKillSoul.Visible = true;
         }
         this.FBmpKnifeOfKillSoul.bitmapData = null;
         if(this.FKnifeOfKillSoulData != null)
         {
            SResourcesCore.TexturesMiddlePic.LoadAutoSecondary(this.FKnifeOfKillSoulData.ID,this.TextureArrive);
         }
         this.FCurExp = 0;
         this.FMainUI.TF_Level.visible = true;
         if(this.FTabIndex == 0)
         {
            this.FCurLevel = this.FHero == null ? 0 : uint(this.FHero.ChangeSchedule);
            this.FCurArticleCount = this.GetChangeShred();
            this.FMainUI.TF_Level.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Smelt_01),this.FCurLevel);
            this.FMainUI.TF_Consume1.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Smelt_04),this.FCurArticleCount);
            this.FMainUI.TF_Consume2.text = "";
         }
         else if(this.FTabIndex == 1)
         {
            this.FCurLevel = this.FHero == null ? 0 : (this.FHero.CustomHero == null ? 0 : this.FHero.CustomHero.Level);
            this.FCurArticleCount = this.GetExclusiveShred();
            this.FMainUI.TF_Level.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Smelt_02),this.FCurLevel);
            this.FMainUI.TF_Consume1.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Smelt_05),this.FCurArticleCount);
            this.FMainUI.TF_Consume2.text = "";
         }
         else if(this.FTabIndex == 2)
         {
            this.FCurLevel = this.FHero == null ? 0 : this.FHero.RebirthNum;
            this.FCurArticleCount = this.GetRebirthStone();
            this.FCurExp = this.GetExp();
            _loc3_ = this.FCurExp / 100000000;
            if(_loc3_ > Math.floor(_loc3_))
            {
               _loc4_ = _loc3_.toFixed(1);
            }
            else
            {
               _loc4_ = _loc3_.toString();
            }
            this.FMainUI.TF_Level.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Smelt_03),this.FCurLevel);
            this.FMainUI.TF_Consume1.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Smelt_06),this.FCurArticleCount);
            this.FMainUI.TF_Consume2.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Smelt_07),_loc4_);
         }
         else if(this.FTabIndex == 3)
         {
            this.FCurLevel = 0;
            _loc6_ = 0;
            this.FCurArticleCount = 0;
            if(this.FHero != null)
            {
               if(TRelatedPartnerCommon.HeroDatas.GetHeroDataByIdentifier(this.FHero.Identifier) != null)
               {
                  _loc6_ = TRelatedPartnerCommon.HeroDatas.GetHeroDataByIdentifier(this.FHero.Identifier).HeroSkills.length;
               }
               _loc9_ = TRelatedPartnerCommon.HeroDatas.GetHeroDataByIdentifier(this.FHero.Identifier).HeroSkills;
               _loc5_ = 0;
               while(_loc5_ < _loc6_)
               {
                  _loc8_ = _loc9_[_loc5_].Skills.length;
                  _loc7_ = 0;
                  while(_loc7_ < _loc8_)
                  {
                     if(_loc9_[_loc5_].SkillId != 0)
                     {
                        if(_loc9_[_loc5_].Skills[_loc7_].Identifier == _loc9_[_loc5_].SkillId)
                        {
                           break;
                        }
                        this.FCurLevel += _loc9_[_loc5_].Skills[_loc7_].Level;
                        this.FCurArticleCount += _loc9_[_loc5_].Skills[_loc7_].MaterialCount;
                     }
                     _loc7_++;
                  }
                  _loc5_++;
               }
            }
            this.FMainUI.TF_Level.visible = false;
            this.FMainUI.TF_Consume2.visible = false;
            this.FMainUI.TF_Consume1.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Smelt_15),this.FCurArticleCount);
         }
         else if(this.FTabIndex == 4)
         {
            this.FMainUI.TF_Consume2.visible = false;
            this.FItemSelect.Update();
            _loc11_ = uint(SLogicsCore.Character.Ornaments.Count);
            _loc12_ = 0;
            while(_loc12_ < _loc11_)
            {
               if((SLogicsCore.Character.Ornaments.GetInventoryByIndex(_loc12_) as TEquipment).Identifier == this.FSlotID && (SLogicsCore.Character.Ornaments.GetInventoryByIndex(_loc12_) as TEquipment).IDTemplate == this.FTemplateID)
               {
                  _loc13_ = SLogicsCore.Character.Ornaments.GetInventoryByIndex(_loc12_) as TEquipment;
                  break;
               }
               _loc12_++;
            }
            if(_loc13_ != null)
            {
               this.FCurLevel = _loc13_.UpgradingLevel;
               this.FCurArticleCount = 0;
               _loc16_ = -1;
               if(_loc14_ == null)
               {
                  _loc14_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_OrnamentValue);
               }
               _loc11_ = uint(_loc14_.Count);
               _loc12_ = 0;
               while(_loc12_ < _loc11_)
               {
                  _loc15_ = _loc14_.GetDatebaseByIndex(_loc12_) as TOrnamentValue;
                  if(_loc15_.ItemID == _loc13_.IDTemplate && _loc15_.Level == _loc13_.UpgradingLevel)
                  {
                     _loc16_ = _loc12_ + 1;
                     break;
                  }
                  _loc12_++;
               }
               _loc11_ = _loc13_.UpgradingLevel;
               _loc12_ = _loc16_ - _loc11_;
               while(_loc12_ < _loc16_)
               {
                  _loc15_ = _loc14_.GetDatebaseByIndex(_loc12_) as TOrnamentValue;
                  this.FCurArticleCount += _loc15_.CostItems[0].Amount;
                  _loc12_++;
               }
               this.FMainUI.TF_Level.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Smelt_17),_loc13_.UpgradingLevel);
               this.FMainUI.TF_Consume1.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Smelt_16),this.FCurArticleCount);
            }
            else
            {
               this.FMainUI.TF_Level.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Smelt_17),0);
               this.FMainUI.TF_Consume1.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Smelt_16),0);
            }
         }
         else if(this.FTabIndex == 5)
         {
            this.FCurLevel = 0;
            this.FCurArticleCount = 0;
            this.FMainUI.TF_Level.text = "";
            this.FMainUI.TF_Consume1.text = "";
            if(this.FKnifeOfKillSoulData != null)
            {
               for each(_loc17_ in this.FKnifeOfKillSoulData.StrengthenAdd)
               {
                  this.FCurLevel = Math.max(_loc17_.Level,this.FCurLevel);
               }
               this.FCurArticleCount = this.GetSoulOfConquestNum();
               this.FMainUI.TF_Level.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Smelt_20),this.FCurLevel);
               this.FMainUI.TF_Consume1.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Smelt_21),this.FCurArticleCount);
            }
            this.FMainUI.TF_Consume2.text = "";
         }
         if(this.FTabIndex == 4)
         {
            if(this.FCurArticleCount == 0)
            {
               this.FResetBtn0.Enabled = false;
               this.FResetBtn1.Enabled = false;
            }
            else
            {
               this.FResetBtn0.Enabled = true;
               this.FResetBtn1.Enabled = true;
            }
         }
         else if(this.FTabIndex == 5)
         {
            if(this.FCurArticleCount == 0)
            {
               this.FResetBtn0.Enabled = false;
               this.FResetBtn1.Enabled = false;
            }
            else
            {
               this.FResetBtn0.Enabled = true;
               this.FResetBtn1.Enabled = true;
            }
         }
         else if(this.FCurLevel == 0 || this.FHero.Quality < int(TUtilityLobby.GetConfigValue(CONST_CONFIGVALUE.Smelt_HeroQualityLimit)))
         {
            this.FResetBtn0.Enabled = false;
            this.FResetBtn1.Enabled = false;
         }
         else
         {
            this.FResetBtn0.Enabled = true;
            this.FResetBtn1.Enabled = true;
         }
         this.UpdateInfo(0);
         this.UpdateInfo(1);
      }
   }
}

