package Processors.Game.Lobby.RelatedPartner.RelatedAssistance
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.TBaseHero;
   import Logics.RelatedPartner.TRelatedPartnerHero;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.RelatedPartner.TRelatedPartnerCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_RELATEDPARTNER;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.text.TextField;
   import ghostcat.util.data.Json;
   
   public class TAssistanceHeroTip extends TProcessorLobbyWindow
   {
      
      protected static const Hero_Num:int = 4;
      
      protected var FMainUI:Sprite;
      
      protected var FTFName:TextField;
      
      protected var FTFJob:TextField;
      
      protected var FTFPos:TextField;
      
      protected var FHeroMountVec:Vector.<Bitmap>;
      
      protected var FHeroNameVec:Vector.<TextField>;
      
      protected var FHeroPropVec:Vector.<TextField>;
      
      protected var FIsInit:Boolean;
      
      protected var FHeroId:int;
      
      protected var FHeroVec:Vector.<int>;
      
      public function TAssistanceHeroTip(param1:TUIComponent)
      {
         super(param1);
         this.mouseChildren = false;
         this.mouseEnabled = false;
         this.FHeroMountVec = new Vector.<Bitmap>();
         this.FHeroNameVec = new Vector.<TextField>();
         this.FHeroPropVec = new Vector.<TextField>();
         this.FHeroVec = new Vector.<int>();
      }
      
      protected function InitView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Bitmap = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance(CONST_RELATEDPARTNER.ResourceID_AssistanceTip) as Sprite;
         addChild(this.FMainUI);
         this.FHeroMountVec.push(new Bitmap());
         this.FMainUI["MC_Head"]["MC_Pos"].addChild(this.FHeroMountVec[0]);
         this.FTFName = this.FMainUI["TF_Name"];
         this.FTFJob = this.FMainUI["TF_Job"];
         this.FTFPos = this.FMainUI["TF_Position"];
         _loc1_ = 0;
         while(_loc1_ < Hero_Num)
         {
            _loc2_ = new Bitmap();
            this.FMainUI["MC_Item_" + _loc1_]["MC_Head"]["MC_Pos"].addChild(_loc2_);
            this.FHeroMountVec.push(_loc2_);
            this.FHeroNameVec.push(this.FMainUI["MC_Item_" + _loc1_]["TF_Name"]);
            this.FHeroPropVec.push(this.FMainUI["MC_Item_" + _loc1_]["TF_Desc"]);
            _loc1_++;
         }
         this.FIsInit = true;
         this.Render();
      }
      
      protected function PicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:int = 0;
         _loc4_ = this.FHeroVec.indexOf(param3);
         if(_loc4_ < 0)
         {
            return;
         }
         this.FHeroMountVec[_loc4_].bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
      }
      
      protected function Render() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TRelatedPartnerHero = null;
         var _loc4_:TBaseHero = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,this.FHeroId) as TBaseHero;
         SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(this.FHeroId,this.PicArrive);
         this.FHeroVec.length = 0;
         this.FHeroVec.push(this.FHeroId);
         this.FTFName.text = _loc4_.Name;
         _loc5_ = Json.decode(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.COMMON_Professions)) as Array;
         this.FTFJob.text = _loc5_[_loc4_.Profession];
         _loc5_ = Json.decode(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRINGS_TARGETNAME)) as Array;
         _loc6_ = int(TUtilityLobby.GetStandPositionWithProfession(_loc4_.Profession));
         this.FTFPos.text = _loc5_[_loc6_];
         _loc3_ = TRelatedPartnerCommon.HeroDatas.GetHeroDataByIdentifier(this.FHeroId);
         _loc2_ = int(_loc3_.HeroSkills.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc7_ = _loc3_.HeroSkills[_loc1_].Partner.ConnectId;
            _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,_loc7_) as TBaseHero;
            this.FHeroVec.push(_loc7_);
            this.FHeroNameVec[_loc1_].text = _loc4_.Name;
            if(_loc3_.HeroSkills[_loc1_].SkillId == 0)
            {
               this.FHeroPropVec[_loc1_].text = TRelatedPartnerCommon.GetSkillDesc(_loc3_.HeroSkills[_loc1_].Skills[0].Identifier);
            }
            else
            {
               this.FHeroPropVec[_loc1_].text = TRelatedPartnerCommon.GetSkillDesc(_loc3_.HeroSkills[_loc1_].SkillId);
            }
            SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc7_,this.PicArrive);
            this.FHeroMountVec[_loc1_ + 1].bitmapData = null;
            this.FMainUI["MC_Item_" + _loc1_].visible = true;
            _loc1_++;
         }
         while(_loc1_ < Hero_Num)
         {
            this.FMainUI["MC_Item_" + _loc1_].visible = false;
            _loc1_++;
         }
      }
      
      protected function UpdatePosition_Perform() : void
      {
         if(x > CONST_COMMON.STAGE_Width - width)
         {
            x = Math.max(x - width - 40,0);
         }
         else
         {
            x = Math.min(x + 40,CONST_COMMON.STAGE_Width - width);
         }
         if(y > CONST_COMMON.STAGE_Height - height)
         {
            y = Math.max(y - height,0);
         }
         else
         {
            y = Math.min(y,CONST_COMMON.STAGE_Height - height);
         }
      }
      
      public function Show(param1:int) : void
      {
         this.FHeroId = param1;
         if(this.FHeroId == 0)
         {
            return;
         }
         this.UpdatePosition_Perform();
         if(!this.FIsInit)
         {
            this.InitView();
         }
         else
         {
            this.Render();
         }
         this.visible = true;
      }
      
      public function Hide() : void
      {
         this.visible = false;
      }
   }
}

