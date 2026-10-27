package Processors.Game.Lobby.StoneShop.Components
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Queries.Textures.TQueryAnimationSequence;
   import Foundation.Resources.Textures.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Components.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TUIHeroItem
   {
      
      protected static const FRAMEINDEX_Normal:uint = 1;
      
      protected static const FRAMEINDEX_Over:uint = 2;
      
      protected var FTF_NeedCount:TextField;
      
      protected var FTF_HeroName:TextField;
      
      protected var FMC_HeroBG:Sprite;
      
      protected var FBtn_Exchange:TUIButton;
      
      protected var FSP_MountPoint:Sprite;
      
      protected var FSP_OpenCondition:Sprite;
      
      protected var FTF_Condition:TextField;
      
      protected var FSP_AlreadyRecruit:Sprite;
      
      protected var FUIHero:TUIHero;
      
      protected var FResource:MovieClip;
      
      protected var FContext:TInventorySample;
      
      protected var FOnExchange:Function;
      
      protected var FOnHeroClick:Function;
      
      protected var FOnQuerySequenceContext:Function;
      
      public function TUIHeroItem()
      {
         super();
         this.FUIHero = new TUIHero(null);
         this.FUIHero.OnQuerySequenceContext = this.HeroOnQuerySequenceContext;
      }
      
      protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TBounds = null;
         var _loc4_:TCoordinate = null;
         this.FResource.mouseEnabled = false;
         this.FMC_HeroBG = this.FResource["SP_HeroBG"];
         this.FMC_HeroBG.mouseChildren = false;
         this.FMC_HeroBG.mouseEnabled = false;
         this.FSP_MountPoint = this.FResource["SP_MountPoint"];
         this.FSP_MountPoint.buttonMode = true;
         this.FTF_NeedCount = this.FResource["TF_NeedCount"];
         this.FTF_NeedCount.mouseEnabled = false;
         this.FTF_HeroName = this.FResource["TF_HeroName"];
         this.FTF_HeroName.mouseEnabled = false;
         this.FSP_OpenCondition = this.FResource["SP_OpenCondition"];
         this.FTF_Condition = this.FSP_OpenCondition["TF_Condition"];
         this.FSP_AlreadyRecruit = this.FResource["SP_AlreadyRecruit"];
         this.FSP_MountPoint.addChild(this.FUIHero);
         _loc3_ = new TBounds();
         _loc4_ = new TCoordinate();
         this.FUIHero.SequenceDefaultRole.Evaluate(_loc4_,_loc3_);
         this.FUIHero.X = _loc3_.X;
         this.FUIHero.Y = _loc3_.Y;
         this.FBtn_Exchange = new TUIButton();
         this.FBtn_Exchange.Substrate = this.FResource["Btn_Exchange"];
         this.Reset();
      }
      
      protected function addEventListenerPlayer() : void
      {
         if(this.FResource == null)
         {
            return;
         }
         this.FSP_MountPoint.addEventListener(MouseEvent.CLICK,this.UIHeroOnClick,false,0,true);
         this.FSP_MountPoint.addEventListener(MouseEvent.MOUSE_MOVE,this.UIHeroOnOver,false,0,true);
         this.FSP_MountPoint.addEventListener(MouseEvent.MOUSE_OUT,this.UIHeroOnOut,false,0,true);
         this.FBtn_Exchange.OnClick = this.BtnOKOnClick;
      }
      
      protected function RemoveEventListenerPlayer() : void
      {
         if(this.FResource == null)
         {
            return;
         }
         this.FSP_MountPoint.removeEventListener(MouseEvent.CLICK,this.UIHeroOnClick);
         this.FSP_MountPoint.removeEventListener(MouseEvent.MOUSE_MOVE,this.UIHeroOnOver);
         this.FSP_MountPoint.removeEventListener(MouseEvent.MOUSE_OUT,this.UIHeroOnOut);
         this.FBtn_Exchange.OnClick = null;
      }
      
      protected function UpdateUI() : void
      {
         var _loc1_:THeros = null;
         var _loc2_:THero = null;
         var _loc3_:String = null;
         _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_29);
         if(SLogicsCore.Character.GetMainLevel() < this.FContext.UnlockLevel)
         {
            this.FTF_Condition.text = TUtilityString.Format(_loc3_,this.FContext.UnlockLevel);
            this.FSP_OpenCondition.visible = true;
         }
         _loc2_ = SLogicsCore.Character.Heros.GetHeroByIdentifier(this.FContext.TemplateID);
         if(_loc2_ != null)
         {
            this.FSP_AlreadyRecruit.visible = true;
         }
         else
         {
            this.FBtn_Exchange.Enabled = true;
         }
         this.FTF_HeroName.text = this.FContext.HeroName;
         this.FTF_HeroName.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[this.FContext.HeroQuality];
         this.FTF_NeedCount.text = this.FContext.Integration.toString();
         this.FMC_HeroBG.visible = false;
      }
      
      protected function BtnOKOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnExchange != null)
         {
            this.FOnExchange(this,this.FContext);
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
      
      protected function UIHeroOnOver(param1:MouseEvent) : void
      {
         this.FResource.gotoAndStop(FRAMEINDEX_Over);
      }
      
      protected function UIHeroOnOut(param1:MouseEvent) : void
      {
         this.FResource.gotoAndStop(FRAMEINDEX_Normal);
      }
      
      protected function UIHeroOnClick(param1:MouseEvent) : void
      {
         if(this.FOnHeroClick != null)
         {
            this.FOnHeroClick(this,this.FContext);
         }
      }
      
      public function get Resource() : MovieClip
      {
         return this.FResource;
      }
      
      public function set Resource(param1:MovieClip) : void
      {
         this.FResource = param1;
      }
      
      public function get Context() : TInventorySample
      {
         return this.FContext;
      }
      
      public function set Context(param1:TInventorySample) : void
      {
         this.Reset();
         if(this.FContext == null && param1 != null)
         {
            this.addEventListenerPlayer();
         }
         else if(param1 == null)
         {
            this.RemoveEventListenerPlayer();
         }
         this.FContext = param1;
         this.FUIHero.Context = param1;
         if(param1 != null)
         {
            this.UpdateUI();
         }
      }
      
      public function get OnExchange() : Function
      {
         return this.FOnExchange;
      }
      
      public function set OnExchange(param1:Function) : void
      {
         this.FOnExchange = param1;
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
      
      public function set Visible(param1:Boolean) : void
      {
         if(this.FResource != null)
         {
            this.FResource.visible = param1;
         }
      }
      
      public function Perform_UIDispatch() : void
      {
         this.ResourcesPerform_UIDispatch();
      }
      
      public function Dispose() : void
      {
         this.FUIHero.Dispose();
         this.FUIHero = null;
         this.FTF_NeedCount = null;
         this.FTF_HeroName = null;
         this.FMC_HeroBG = null;
         this.FBtn_Exchange.Dispose();
         this.FBtn_Exchange = null;
         this.FSP_MountPoint = null;
         this.FSP_OpenCondition = null;
         this.FTF_Condition = null;
         this.FSP_AlreadyRecruit = null;
         this.FContext = null;
         this.FOnExchange = null;
         this.FOnHeroClick = null;
         this.FOnQuerySequenceContext = null;
         this.FResource = null;
      }
      
      public function Reset() : void
      {
         if(this.FResource == null)
         {
            return;
         }
         this.FResource.gotoAndStop(FRAMEINDEX_Normal);
         this.FUIHero.Context = null;
         this.FTF_HeroName.text = "";
         this.FTF_NeedCount.text = "";
         this.FTF_Condition.text = "";
         this.FBtn_Exchange.Enabled = false;
         this.FMC_HeroBG.visible = true;
         this.FSP_OpenCondition.visible = false;
         this.FSP_AlreadyRecruit.visible = false;
      }
      
      public function Update() : void
      {
         if(this.FResource != null)
         {
            this.FUIHero.Update();
         }
      }
   }
}

