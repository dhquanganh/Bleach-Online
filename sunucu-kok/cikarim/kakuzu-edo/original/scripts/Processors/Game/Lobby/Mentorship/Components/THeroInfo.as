package Processors.Game.Lobby.Mentorship.Components
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.TRoleModel;
   import Logics.Mentorship.Elements.TDisciple;
   import Logics.Mentorship.TMentorship;
   import Processors.Game.TProcessorGame;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_MENTORSHIP;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class THeroInfo extends TProcessorGame
   {
      
      protected var FMC_Image:Sprite;
      
      protected var FMC_Highlight:Sprite;
      
      protected var FTF_Level:TextField;
      
      protected var FTF_Name:TextField;
      
      protected var FTF_Organization:TextField;
      
      protected var FRoleID:uint;
      
      protected var FLevel:uint;
      
      protected var FName:String;
      
      protected var FGuildName:String;
      
      protected var FObj:Object;
      
      protected var FObject:Object;
      
      protected var FRoleModel:TRoleModel;
      
      protected var FResource:MovieClip;
      
      protected var FImageOnClick:Function;
      
      public function THeroInfo(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         if(!this.Parent.Visible)
         {
            return;
         }
         if(this.Parent.Parent != null)
         {
            if(!this.Parent.Parent.Visible)
            {
               return;
            }
         }
         super.LogicsPerform();
      }
      
      protected function UIDispatch() : void
      {
         var _loc1_:Bitmap = null;
         this.FMC_Image = this.FResource[CONST_MENTORSHIP.RESOURCE_Link_MC_Image];
         this.FMC_Image.buttonMode = true;
         this.FMC_Highlight = this.FResource[CONST_MENTORSHIP.RESOURCE_Link_MC_Highlight];
         this.FMC_Highlight.visible = false;
         this.FTF_Level = this.FResource[CONST_MENTORSHIP.RESOURCE_Link_TF_Level];
         this.FTF_Level.mouseEnabled = false;
         this.FTF_Name = this.FResource[CONST_MENTORSHIP.RESOURCE_Link_TF_Name];
         this.FTF_Organization = this.FResource[CONST_MENTORSHIP.RESOURCE_Link_TF_Organization];
         _loc1_ = new Bitmap();
         this.FMC_Image["bitmap"] = _loc1_;
         this.FMC_Image.addChild(_loc1_);
      }
      
      protected function UILocation() : void
      {
         this.FMC_Image.addEventListener(MouseEvent.MOUSE_OVER,this.MCImageOnOver,false,0,true);
         this.FMC_Image.addEventListener(MouseEvent.MOUSE_OUT,this.MCImageOnOut,false,0,true);
         this.FMC_Image.addEventListener(MouseEvent.CLICK,this.MCImageOnClick,false,0,true);
      }
      
      protected function UpdateUI() : void
      {
         this.FRoleModel = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,this.FRoleID) as TRoleModel;
         SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(this.FRoleModel.RoleHead,this.AutoLoadCallBack);
         this.FTF_Level.text = "Lv." + this.FLevel.toString();
         this.FTF_Name.text = this.FName;
         this.FTF_Organization.text = this.FGuildName;
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         var _loc5_:BitmapData = null;
         switch(param3)
         {
            case this.FRoleModel.RoleHead:
               _loc4_ = param2.GetAnimationSequenceByIndex(0);
               _loc5_ = _loc4_.GetAnimationFrameByIndex(0).Surface;
               this.FMC_Image["bitmap"].bitmapData = _loc5_;
         }
      }
      
      protected function MCImageOnOver(param1:MouseEvent) : void
      {
         this.FMC_Highlight.visible = true;
      }
      
      protected function MCImageOnOut(param1:MouseEvent) : void
      {
         this.FMC_Highlight.visible = false;
      }
      
      protected function MCImageOnClick(param1:MouseEvent) : void
      {
         if(this.FImageOnClick != null)
         {
            this.FImageOnClick(this,this.FObj);
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
      
      public function get ImageOnClick() : Function
      {
         return this.FImageOnClick;
      }
      
      public function set ImageOnClick(param1:Function) : void
      {
         this.FImageOnClick = param1;
      }
      
      public function Init() : void
      {
         this.UIDispatch();
         this.UILocation();
      }
      
      public function Update(param1:Object) : void
      {
         var _loc2_:TMentorship = null;
         var _loc3_:TDisciple = null;
         if(param1 is TMentorship)
         {
            _loc2_ = param1 as TMentorship;
            this.FRoleID = _loc2_.MasterHeroID;
            this.FLevel = _loc2_.MasterLevel;
            this.FName = _loc2_.MasterName;
            this.FGuildName = _loc2_.MasterGuildName;
         }
         else if(param1 is TDisciple)
         {
            _loc3_ = param1 as TDisciple;
            this.FRoleID = _loc3_.DiscipleHeroID;
            this.FLevel = _loc3_.DiscipleLevel;
            this.FName = _loc3_.DiscipleName;
            this.FGuildName = _loc3_.DiscipleGuildName;
         }
         this.UpdateUI();
      }
      
      public function Reset() : void
      {
         this.FMC_Image["bitmap"].bitmapData = null;
      }
   }
}

