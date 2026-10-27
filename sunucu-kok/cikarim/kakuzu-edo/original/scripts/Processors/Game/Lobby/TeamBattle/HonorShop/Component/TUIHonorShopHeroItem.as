package Processors.Game.Lobby.TeamBattle.HonorShop.Component
{
   import Components.Standard.TUIButton;
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Foundation.Queries.Textures.TQueryAnimationSequence;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.UI.TUIComponent;
   import Logics.Characters.TCharacter;
   import Logics.DatebaseVO.VO.TBaseHero;
   import Logics.DatebaseVO.VO.TRoleModel;
   import Logics.HonorShop.THonorShopItem;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Components.TUIHero;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_HONORSHOP;
   import Resources.Constants.CONST_ROLE;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TUIHonorShopHeroItem extends TUIComponent
   {
      
      protected static const ROLE_SEQUENCEINDEX_Showcase:uint = CONST_ROLE.ROLE_SEQUENCEINDEX_Showcase;
      
      protected static const STATUS_FRAME_Normal:uint = 1;
      
      protected static const STATUS_FRAME_MouseOver:uint = 2;
      
      protected var FScene:MovieClip;
      
      protected var FMC_AlreadyRecruit:Sprite;
      
      protected var FUIOpenCondition:TUIHonorShopOpenCondition;
      
      protected var FTF_NeedCount:TextField;
      
      protected var FTF_HeroName:TextField;
      
      protected var FMC_HeroBG:Sprite;
      
      protected var FBtn_OK:TUIButton;
      
      protected var FMC_MountPoint:MovieClip;
      
      protected var FUIHero:TUIHero;
      
      protected var FData:THonorShopItem;
      
      protected var FHonorCount:uint;
      
      protected var FCharacter:TCharacter;
      
      protected var FHeroBins:TBins;
      
      protected var FBaseHero:TBaseHero;
      
      protected var FModelId:uint;
      
      protected var FRoleModel:TBins;
      
      protected var FOnBtnOKClick:Function;
      
      protected var FOnHeroClick:Function;
      
      protected var FOnQuerySequenceContext:Function;
      
      public function TUIHonorShopHeroItem(param1:TUIComponent)
      {
         super(param1);
         this.FCharacter = SLogicsCore.Character;
         this.FUIHero = new TUIHero(null);
         this.FUIHero.OnQuerySequenceContext = this.HeroOnQuerySequenceContext;
      }
      
      protected function Resources_UIDispatch(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TBounds = null;
         var _loc5_:TCoordinate = null;
         this.FScene = param1;
         this.FScene.gotoAndStop(STATUS_FRAME_Normal);
         this.FMC_AlreadyRecruit = this.FScene[CONST_HONORSHOP.RESOURCE_Link_MC_AlreadyRecruit];
         this.FMC_AlreadyRecruit.mouseChildren = false;
         this.FMC_AlreadyRecruit.mouseEnabled = false;
         this.FMC_HeroBG = this.FScene[CONST_HONORSHOP.RESOURCE_Link_MC_HeroBG];
         this.FMC_HeroBG.mouseChildren = false;
         this.FMC_HeroBG.mouseEnabled = false;
         this.FMC_MountPoint = this.FScene[CONST_HONORSHOP.RESOURCE_Link_MC_MountPoint];
         this.FMC_MountPoint.buttonMode = true;
         this.FTF_NeedCount = this.FScene[CONST_HONORSHOP.RESOURCE_Link_TF_NeedCount];
         this.FTF_NeedCount.mouseEnabled = false;
         this.FTF_NeedCount.text = "";
         this.FTF_HeroName = this.FScene[CONST_HONORSHOP.RESOURCE_Link_TF_HeroName];
         this.FTF_HeroName.mouseEnabled = false;
         this.FTF_HeroName.text = "";
         this.FUIOpenCondition = new TUIHonorShopOpenCondition(this);
         this.FUIOpenCondition.Perform_UIDispatch(this.FScene[CONST_HONORSHOP.RESOURCE_Link_MC_OpenCondition]);
         this.FUIOpenCondition.Visible = false;
         this.FUIOpenCondition.mouseChildren = false;
         this.FUIOpenCondition.mouseEnabled = false;
         this.FMC_MountPoint.addChild(this.FUIHero);
         _loc4_ = new TBounds();
         _loc5_ = new TCoordinate();
         this.FUIHero.SequenceDefaultRole.Evaluate(_loc5_,_loc4_);
         this.FUIHero.X = _loc4_.X;
         this.FUIHero.Y = _loc4_.Y;
         this.FMC_MountPoint.visible = false;
         this.FMC_MountPoint.addEventListener(MouseEvent.MOUSE_MOVE,this.HeroOnOver);
         this.FMC_MountPoint.addEventListener(MouseEvent.MOUSE_OUT,this.HeroOnOut);
         this.FMC_MountPoint.addEventListener(MouseEvent.CLICK,this.HeroOnClick);
         this.FBtn_OK = new TUIButton();
         this.FBtn_OK.OnClick = this.BtnOKOnClick;
         this.FBtn_OK.Substrate = this.FScene[CONST_HONORSHOP.RESOURCE_Link_Btn_OK];
         this.FBtn_OK.Visible = false;
         this.FHeroBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BaseHero);
         if(this.FRoleModel == null)
         {
            this.FRoleModel = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_RoleModel);
         }
      }
      
      protected function UpdateUI() : void
      {
         var _loc1_:Vector.<String> = null;
         var _loc2_:Vector.<uint> = null;
         var _loc3_:TRoleModel = null;
         if(this.FHonorCount < this.FData.Mall.Honour || this.FCharacter.GetMainLevel() < this.FData.Mall.Level)
         {
            _loc1_ = new Vector.<String>(2);
            _loc1_[0] = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_53) + this.FData.Mall.Honour.toString();
            _loc1_[1] = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_54) + this.FData.Mall.Level.toString();
            this.FUIOpenCondition.ProcessorUpdateUI(_loc1_);
            this.FUIOpenCondition.Show();
            this.FBtn_OK.Enabled = false;
         }
         else
         {
            this.FUIOpenCondition.Clear();
            this.FUIOpenCondition.Hide();
            this.FBtn_OK.Enabled = true;
         }
         if(this.FData.BoughtCount > 0)
         {
            this.FMC_AlreadyRecruit.visible = true;
            this.FBtn_OK.Visible = false;
         }
         else
         {
            this.FMC_AlreadyRecruit.visible = false;
            this.FBtn_OK.Visible = true;
         }
         if(this.FData.Mall.ItemID != 0)
         {
            this.FMC_HeroBG.visible = false;
            this.FBaseHero = this.FHeroBins.GetDatebaseByIdentifier(this.FData.Mall.ItemID) as TBaseHero;
            this.FUIHero.Context = this.FBaseHero.Identifier;
            this.FMC_MountPoint.visible = true;
            this.FTF_NeedCount.text = this.FData.Mall.Items.Amount.toString();
            this.FTF_HeroName.text = this.FBaseHero.Name;
            this.FTF_HeroName.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[this.FBaseHero.Quality];
         }
         else
         {
            this.FMC_HeroBG.visible = true;
            this.FMC_MountPoint.visible = false;
            this.FTF_NeedCount.text = "";
            this.FTF_HeroName.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_55);
            this.FUIOpenCondition.Hide();
            this.FMC_AlreadyRecruit.visible = false;
            this.FBtn_OK.Visible = false;
         }
      }
      
      protected function DoClear() : void
      {
         if(this.FScene != null)
         {
            this.FTF_HeroName.text = "";
            this.FTF_NeedCount.text = "";
         }
         if(this.FUIHero != null)
         {
            this.FUIHero.Context = null;
         }
         if(false)
         {
            Visible = false;
         }
      }
      
      protected function BtnOKOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnBtnOKClick != null)
         {
            this.FOnBtnOKClick(this,this.FData);
         }
      }
      
      protected function HeroOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TBounds = null;
         var _loc6_:TCoordinate = null;
         if(this.FOnQuerySequenceContext != null)
         {
            this.FOnQuerySequenceContext(param1,param2,param3,param4);
            if(param3.Value != null)
            {
               _loc5_ = new TBounds();
               _loc6_ = new TCoordinate();
               param3.Value.Evaluate(_loc6_,_loc5_);
               this.FUIHero.X = _loc5_.X;
               this.FUIHero.Y = _loc5_.Y;
            }
         }
      }
      
      protected function HeroOnOver(param1:MouseEvent) : void
      {
         this.FScene.gotoAndStop(STATUS_FRAME_MouseOver);
      }
      
      protected function HeroOnOut(param1:MouseEvent) : void
      {
         this.FScene.gotoAndStop(STATUS_FRAME_Normal);
      }
      
      protected function HeroOnClick(param1:MouseEvent) : void
      {
         if(this.FOnHeroClick != null)
         {
            this.FOnHeroClick(this.FBaseHero);
         }
      }
      
      public function get OnBtnOKClick() : Function
      {
         return this.FOnBtnOKClick;
      }
      
      public function set OnBtnOKClick(param1:Function) : void
      {
         this.FOnBtnOKClick = param1;
      }
      
      public function get OnHeroClick() : Function
      {
         return this.FOnHeroClick;
      }
      
      public function set OnHeroClick(param1:Function) : void
      {
         this.FOnHeroClick = param1;
      }
      
      public function get OnQuerySequenceContext() : Function
      {
         return this.FOnQuerySequenceContext;
      }
      
      public function set OnQuerySequenceContext(param1:Function) : void
      {
         this.FOnQuerySequenceContext = param1;
      }
      
      public function get SequenceDefaultRole() : TAnimationSequence
      {
         return this.FUIHero.SequenceDefaultRole;
      }
      
      public function set SequenceDefaultRole(param1:TAnimationSequence) : void
      {
         if(param1 != null)
         {
            this.FUIHero.SequenceDefaultRole = param1;
         }
      }
      
      public function Perform_UIDispatch(param1:MovieClip) : void
      {
         this.Resources_UIDispatch(param1);
      }
      
      public function ProcessorUpdateUI(param1:uint, param2:THonorShopItem) : void
      {
         this.FHonorCount = param1;
         this.FData = param2;
         if(this.Visible)
         {
            this.UpdateUI();
         }
      }
      
      public function ProcessorUpdateHero() : void
      {
         if(this.FScene.visible && this.FUIHero.Context != null)
         {
            this.FUIHero.Update();
         }
      }
      
      public function Clear() : void
      {
         this.DoClear();
      }
      
      public function Show() : void
      {
         if(this.FScene != null)
         {
            this.FScene.visible = true;
         }
      }
      
      public function Hide() : void
      {
         if(this.FScene != null)
         {
            this.FScene.visible = false;
         }
      }
   }
}

