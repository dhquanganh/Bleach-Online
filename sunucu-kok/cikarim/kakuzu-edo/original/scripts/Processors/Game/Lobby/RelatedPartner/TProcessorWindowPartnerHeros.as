package Processors.Game.Lobby.RelatedPartner
{
   import Components.ScrollBar.TScrollBar;
   import Components.Standard.TUIButton;
   import Components.Standard.TUITab;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityTexture;
   import Logics.Characters.THero;
   import Logics.Characters.THeros;
   import Logics.DatebaseVO.VO.TArticle;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.Map.TMoudleInfor;
   import Logics.RelatedPartner.TRelatedPartnerHero;
   import Logics.RelatedPartner.TRelatedPartnerHeroSkill;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudle;
   import Processors.Game.Lobby.RelatedPartner.Component.TRenderHeroSkill;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_CONFIGVALUE;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_MAP;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorWindowPartnerHeros extends TProcessorWindowPartnerBase
   {
      
      protected static const Tab_Num:int = 5;
      
      protected var FMainUI:Sprite;
      
      protected var FHeroTab:TUITab;
      
      protected var FBtnDetail:TUIButton;
      
      protected var FTFChip:TextField;
      
      protected var FChipMount:Bitmap;
      
      protected var FHeros:THeros;
      
      protected var FRelatedHeros:THeros;
      
      protected var FDisableStr:String;
      
      protected var FChipCount:int;
      
      protected var FChipId:int;
      
      protected var FSpriteMoudle:TSceneSpriteMoudle;
      
      protected var FQureyMoudleInfor:TMoudleInfor;
      
      protected var FCurHeroIndex:int;
      
      protected var FTFDesc:TextField;
      
      protected var FOnDetail:Function;
      
      public function TProcessorWindowPartnerHeros(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function RenderHeroMoudle(param1:THero) : void
      {
         TUtilityTexture.QueryTwoDirectionShowCase(CONST_MAP.DIRECTION_RIGHT,param1.ModelID,this.FQureyMoudleInfor);
         this.FSpriteMoudle.ChangeRoleMoudle(this.FQureyMoudleInfor.TextureID,this.FQureyMoudleInfor.Scalx);
         this.FSpriteMoudle.OpenRebirthEffect(param1.IsMain,param1.RebirthNum);
         this.FSpriteMoudle.mouseChildren = false;
         this.FSpriteMoudle.mouseEnabled = false;
      }
      
      protected function UpdateRoleMoudle() : void
      {
         this.FSpriteMoudle.UpdateView();
      }
      
      protected function PicArrive(param1:Object, param2:TTexture, param3:int) : void
      {
         this.FChipMount.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
      }
      
      protected function OnDetailClick(param1:Object, param2:MouseEvent) : void
      {
         this.FOnDetail();
      }
      
      protected function OnHeroSwitch(param1:int) : void
      {
         var _loc2_:THero = null;
         var _loc3_:TRelatedPartnerHero = null;
         var _loc4_:int = 0;
         var _loc5_:TRenderHeroSkill = null;
         var _loc6_:THero = null;
         var _loc7_:MovieClip = null;
         if(this.FCurHeroIndex > 0 && this.FCurHeroIndex == param1)
         {
            return;
         }
         this.FCurHeroIndex = param1;
         this.FRelatedHeros = TRelatedPartnerCommon.GetMountedHeros(false);
         _loc2_ = this.FHeros.GetHeroByIndex(param1);
         this.RenderHeroMoudle(_loc2_);
         FScrollBar.Clear();
         if(TRelatedPartnerCommon.HeroDatas == null)
         {
            return;
         }
         _loc3_ = TRelatedPartnerCommon.HeroDatas.GetHeroDataByIdentifier(_loc2_.Identifier);
         if(_loc3_ == null)
         {
            FMCAlert.visible = true;
            return;
         }
         FMCAlert.visible = false;
         if(_loc2_.IsMain && this.FRelatedHeros.Count > 0)
         {
            _loc3_.HeroSkills.sort(this.SortHero);
         }
         _loc4_ = int(_loc3_.HeroSkills.length);
         param1 = 0;
         while(param1 < _loc4_)
         {
            _loc5_ = new TRenderHeroSkill();
            _loc5_.GotoAssistance = OnGotoAssistance;
            _loc5_.GotoPosition = OnGotoPosition;
            _loc5_.GotoTrain = OnGotoTrain;
            _loc5_.GotoUpgrade = OnGotoUpgrade;
            _loc5_.GotoLink = OnGotoLink;
            _loc5_.HintOver = OnHintOver;
            _loc5_.HintOut = OnHintOut;
            _loc5_.BgType = BG_Hero;
            _loc5_.Init();
            FScrollBar.AddItem(_loc5_);
            if(_loc2_.IsMain)
            {
               _loc6_ = this.FRelatedHeros.GetHeroByIdentifier(_loc3_.HeroSkills[param1].Partner.ConnectId);
               _loc5_.RenderMainHero(_loc3_.HeroSkills[param1],_loc6_);
            }
            else
            {
               _loc5_.Render(_loc3_.HeroSkills[param1]);
            }
            param1++;
         }
         this.FHeroTab.SetTabToTopByIndex(this.FCurHeroIndex);
      }
      
      protected function SortHero(param1:TRelatedPartnerHeroSkill, param2:TRelatedPartnerHeroSkill) : int
      {
         var _loc3_:THero = null;
         var _loc4_:THero = null;
         _loc3_ = this.FRelatedHeros.GetHeroByIdentifier(param1.Partner.ConnectId);
         _loc4_ = this.FRelatedHeros.GetHeroByIdentifier(param2.Partner.ConnectId);
         if(_loc3_ != null)
         {
            return -1;
         }
         if(_loc4_ != null)
         {
            return 1;
         }
         return 0;
      }
      
      public function get OnDetail() : Function
      {
         return this.FOnDetail;
      }
      
      public function set OnDetail(param1:Function) : void
      {
         this.FOnDetail = param1;
      }
      
      override public function get Visible() : Boolean
      {
         return super.Visible;
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         if(this.FMainUI != null)
         {
            this.FMainUI.visible = param1;
         }
      }
      
      public function InitView(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TArticle = null;
         var _loc4_:TConfigValue = null;
         this.FMainUI = param1;
         this.FHeroTab = new TUITab(this);
         this.FHeroTab.OnSwitch = this.OnHeroSwitch;
         _loc2_ = 0;
         while(_loc2_ < Tab_Num)
         {
            this.FHeroTab.SetTabByIndex(this.FMainUI["MC_Tabs"]["Tab_Hero_" + _loc2_],_loc2_);
            this.FHeroTab.SetTabCaptionByIndex("",_loc2_);
            _loc2_++;
         }
         this.FHeroTab.Init();
         this.FBtnDetail = new TUIButton();
         this.FBtnDetail.Substrate = this.FMainUI["Btn_All"];
         this.FBtnDetail.OnClick = this.OnDetailClick;
         this.FSpriteMoudle = new TSceneSpriteMoudle();
         this.FQureyMoudleInfor = new TMoudleInfor();
         this.FTFChip = this.FMainUI["MC_Chip"]["TF_Count"];
         this.FMainUI["MC_Hero"]["MC_MountPoint"].addChild(this.FSpriteMoudle);
         this.FChipMount = new Bitmap();
         this.FMainUI["MC_Chip"]["MountPoint"].addChild(this.FChipMount);
         this.FDisableStr = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Related_19);
         FScrollBar = new TScrollBar(this.FMainUI["MC_Scroll"],220,false,9,30);
         TRelatedPartnerCommon.SkillInfoReq();
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Related_Material) as TConfigValue;
         this.FChipId = int(_loc4_.Value);
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,this.FChipId) as TArticle;
         SResourcesCore.TexturesInventory.LoadAutoSecondary(_loc3_.Picture,this.PicArrive);
         this.FTFDesc = this.FMainUI["TF_Desc"];
         FMCAlert = this.FMainUI["MC_Alert"];
         FMCAlert.visible = false;
      }
      
      public function Render() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:THero = null;
         this.FHeros = TRelatedPartnerCommon.GetMountedHeros();
         _loc2_ = this.FHeros.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FHeros.GetHeroByIndex(_loc1_);
            this.FHeroTab.SetTabCaptionByIndex(_loc3_.Name,_loc1_,CONST_COMMON.QUALITYCOLOR_INDEX[_loc3_.Quality]);
            this.FHeroTab.SetTabEnabledByIndex(_loc1_,true);
            _loc1_++;
         }
         while(_loc1_ < Tab_Num)
         {
            this.FHeroTab.SetTabCaptionByIndex(this.FDisableStr,_loc1_,CONST_COMMON.QUALITYCOLOR_INDEX[0]);
            this.FHeroTab.SetTabEnabledByIndex(_loc1_,false);
            _loc1_++;
         }
         this.UpdateHero();
      }
      
      public function UpdateHero() : void
      {
         if(Boolean(this.FRelatedHeros) && this.FRelatedHeros.Count > this.FCurHeroIndex)
         {
            this.FHeroTab.SwithTagManual(this.FCurHeroIndex);
         }
         else
         {
            this.FHeroTab.SwithTagManual(0);
         }
         this.FChipCount = SLogicsCore.Character.Appliances.GetCountByTempleteID(this.FChipId);
         this.FTFChip.text = this.FChipCount + "";
      }
      
      public function UpdateHeroInfo(param1:TRelatedPartnerHeroSkill) : void
      {
         UpdateHeroRender(param1);
         this.FChipCount = SLogicsCore.Character.Appliances.GetCountByTempleteID(this.FChipId);
         this.FTFChip.text = this.FChipCount + "";
      }
      
      public function ResetHeroIndex() : void
      {
         this.FCurHeroIndex = 0;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         this.UpdateRoleMoudle();
      }
   }
}

