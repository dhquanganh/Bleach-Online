package Processors.Game.Lobby.SevenKing
{
   import Components.Pages.TUIPage;
   import Components.Slots.TUISlot;
   import Externals.*;
   import Foundation.Network.*;
   import Foundation.Queries.Textures.TQueryAnimationSequence;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.Repositories.TResourceRepositoryTexture;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Agent.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.SevenKing.*;
   import Processors.Game.Lobby.SevenKing.Component.TSevenHeroTip;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.TextField;
   import flash.utils.*;
   
   public class TProcessorWindowHeroSelect extends TUIComponent
   {
      
      public static const CONST_HERO:uint = 6;
      
      protected const CAPACITY_HeroHead:uint = 11;
      
      protected var Bg_Sp:Shape;
      
      protected var FScene:MovieClip;
      
      protected var FCharacter:TCharacter;
      
      protected var FSevenKingData:TSevenKingData;
      
      protected var FTotlePage:uint;
      
      protected var FCurPage:uint;
      
      protected var FSelectHero:THero;
      
      protected var FHeroInfoTip:TSevenHeroTip;
      
      protected var FHeroHeadList:Vector.<TUISlot>;
      
      protected var FMilitaryTypeList:Vector.<MovieClip>;
      
      protected var FUIPage:TUIPage;
      
      protected var FPageIndex:int;
      
      protected var FHeros:THeros;
      
      protected var FSPMyHead:Sprite;
      
      protected var FSPNpcHead:Sprite;
      
      protected var FBmpMyHead:Bitmap;
      
      protected var FBmpNpcHead:Bitmap;
      
      protected var FMyID:uint;
      
      protected var FNpcID:uint;
      
      protected var FTF_BestSingleName:TextField;
      
      protected var FTF_BestAllName:TextField;
      
      protected var FTF_FirstSingleName:TextField;
      
      protected var FTF_FirstAllName:TextField;
      
      protected var FMC_MyName:Sprite;
      
      protected var FMC_NpcName:Sprite;
      
      protected var FTF_MyName:TextField;
      
      protected var FTF_NpcName:TextField;
      
      public function TProcessorWindowHeroSelect(param1:TUIComponent, param2:TSevenKingData)
      {
         var _loc3_:uint = 0;
         var _loc4_:Bitmap = null;
         var _loc5_:uint = 0;
         var _loc6_:TUISlot = null;
         var _loc7_:MovieClip = null;
         super(param1);
         this.Bg_Sp = new Shape();
         this.Bg_Sp.graphics.beginFill(0,0.1);
         this.Bg_Sp.graphics.drawRect(0,0,CONST_COMMON.STAGE_Max_Width,CONST_COMMON.STAGE_Max_Height);
         this.Bg_Sp.graphics.endFill();
         addChild(this.Bg_Sp);
         this.FScene = TUtilityReflection.CreateDisplayObjectInstance(CONST_SEVENKING.RESOURCESID_CLASSNAME_FightSelect) as MovieClip;
         addChild(this.FScene);
         this.FScene.x = (CONST_COMMON.STAGE_Width - this.FScene.width) / 2;
         this.FScene.y = (CONST_COMMON.STAGE_Height - this.FScene.height) / 2;
         this.FSevenKingData = param2;
         this.FCharacter = SLogicsCore.Character;
         this.FHeros = SLogicsCore.Character.Heros;
         this.FUIPage = new TUIPage(this);
         _loc7_ = this.FScene[CONST_NIJIASTAR.RESOURCE_Link_MC_PageLeft];
         this.FUIPage.ButtonPrevious.Substrate = _loc7_;
         _loc7_ = this.FScene[CONST_NIJIASTAR.RESOURCE_Link_MC_PageRight];
         this.FUIPage.ButtonNext.Substrate = _loc7_;
         this.FUIPage.PageSize = this.CAPACITY_HeroHead;
         this.FUIPage.Init();
         this.FUIPage.OnChangePage = this.PageOnChange;
         this.FTF_BestSingleName = this.FScene["mc_Report"]["tf_bestSingleName"];
         this.FTF_BestAllName = this.FScene["mc_Report"]["tf_bestAllName"];
         this.FTF_FirstSingleName = this.FScene["mc_Report"]["tf_firstSingleName"];
         this.FTF_FirstAllName = this.FScene["mc_Report"]["tf_firstAllName"];
         this.FTF_BestSingleName.selectable = false;
         this.FTF_BestAllName.selectable = false;
         this.FTF_FirstSingleName.selectable = false;
         this.FTF_FirstAllName.selectable = false;
         this.FTF_BestSingleName.addEventListener(TextEvent.LINK,this.OnReportView);
         this.FTF_BestAllName.addEventListener(TextEvent.LINK,this.OnReportView);
         this.FTF_FirstSingleName.addEventListener(TextEvent.LINK,this.OnReportView);
         this.FTF_FirstAllName.addEventListener(TextEvent.LINK,this.OnReportView);
         this.FHeroHeadList = new Vector.<TUISlot>(this.CAPACITY_HeroHead);
         this.FMilitaryTypeList = new Vector.<MovieClip>(this.CAPACITY_HeroHead);
         _loc5_ = this.CAPACITY_HeroHead;
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            _loc6_ = new TUISlot(this);
            _loc6_.Resource = this.FScene["mc_Hero_" + _loc3_]["MC_Slot"];
            _loc6_.OnClick = this.OnHeroSelect;
            _loc6_.OnOut = this.HideHeroInfoTip;
            _loc6_.OnOver = this.ShowHeroInfoTip;
            _loc6_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
            _loc6_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
            _loc6_.Init();
            this.FHeroHeadList[_loc3_] = _loc6_;
            this.FMilitaryTypeList[_loc3_] = this.FScene["mc_Hero_" + _loc3_]["mc_militaryType"];
            _loc3_++;
         }
         this.FBmpMyHead = new Bitmap();
         this.FBmpNpcHead = new Bitmap();
         this.FSPMyHead = this.FScene["MC_MyHead"]["MC_Icon"];
         this.FSPNpcHead = this.FScene["MC_NpcHead"]["MC_Icon"];
         this.FSPMyHead.addChild(this.FBmpMyHead);
         this.FSPNpcHead.addChild(this.FBmpNpcHead);
         this.FScene.btn_start.addEventListener(MouseEvent.CLICK,this.OnFightReq,false,0,true);
         this.FScene.btn_close.addEventListener(MouseEvent.CLICK,this.OnClose,false,0,true);
         this.FHeroInfoTip = new TSevenHeroTip(this.Parent);
         this.FHeroInfoTip.Visible = false;
         this.FMC_MyName = this.FScene["MC_MyName"];
         this.FMC_NpcName = this.FScene["MC_NpcName"];
         this.FTF_MyName = this.FMC_MyName["TF_Name"];
         this.FTF_NpcName = this.FMC_NpcName["TF_Name"];
         this.FMC_MyName.visible = false;
      }
      
      protected function PageOnChange(param1:Object, param2:int) : void
      {
         this.FPageIndex = param2;
         this.UpdateHeroHead();
      }
      
      protected function UpdatePageInfo() : void
      {
         this.FPageIndex = 0;
         this.FUIPage.TotalQuantity = this.FHeros.Count;
         this.FUIPage.PageIndex = this.FPageIndex;
         this.FUIPage.Update();
      }
      
      protected function UpdateHeroHead() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TUISlot = null;
         var _loc4_:uint = 0;
         var _loc5_:MovieClip = null;
         var _loc6_:THero = null;
         this.FHeros.Sort();
         _loc2_ = this.CAPACITY_HeroHead;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FHeroHeadList[_loc1_];
            _loc3_.Resource.visible = false;
            this.FMilitaryTypeList[_loc1_].visible = false;
            _loc1_++;
         }
         _loc2_ = this.CAPACITY_HeroHead;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = _loc1_ + this.FPageIndex * this.CAPACITY_HeroHead;
            if(_loc4_ >= this.FHeros.Count)
            {
               break;
            }
            _loc3_ = this.FHeroHeadList[_loc1_];
            _loc6_ = this.FHeros.GetHeroByIndex(_loc4_);
            _loc3_.Context = _loc6_;
            _loc3_.Resource.visible = true;
            _loc5_ = this.FMilitaryTypeList[_loc1_];
            _loc5_.gotoAndStop(_loc6_.StandPositionWithProfession);
            _loc5_.visible = true;
            _loc1_++;
         }
      }
      
      protected function UpdataUI(param1:TSevenHeroArmy = null) : void
      {
         var _loc2_:TRoleModel = null;
         if(param1 != null)
         {
            _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,param1.Image) as TRoleModel;
            this.FNpcID = _loc2_.RoleStyle;
            this.FTF_NpcName.text = param1.Name;
            SResourcesCore.TexturesLargeIcon.LoadAutoSecondary(this.FNpcID,this.AutoLoadCallBack);
         }
         this.FMyID = this.FSelectHero.Identifier;
         SResourcesCore.TexturesLargeIcon.LoadAutoSecondary(this.FMyID,this.AutoLoadCallBack);
         this.FTF_MyName.text = this.FSelectHero.Name;
         this.FMC_MyName.visible = true;
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         var _loc5_:BitmapData = null;
         _loc4_ = param2.GetAnimationSequenceByIndex(0);
         _loc5_ = _loc4_.GetAnimationFrameByIndex(0).Surface;
         switch(param3)
         {
            case this.FMyID:
               this.FBmpMyHead.bitmapData = _loc5_;
               break;
            case this.FNpcID:
               this.FBmpNpcHead.bitmapData = _loc5_;
         }
      }
      
      protected function SlotsOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:THero = null;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         _loc5_ = param2 as THero;
         _loc6_ = SResourcesCore.TexturesHeadIcon;
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc5_.SmallID);
         if(_loc7_ != null)
         {
            param3.Value = _loc7_.GetAnimationSequenceByIdentifier(param4);
         }
         else
         {
            _loc6_.LoadSecondary(_loc5_.SmallID);
         }
      }
      
      protected function OnReportView(param1:TextEvent) : void
      {
         var _loc2_:uint = 0;
         switch(param1.currentTarget)
         {
            case this.FTF_FirstSingleName:
               _loc2_ = 0;
               break;
            case this.FTF_BestSingleName:
               _loc2_ = 1;
               break;
            case this.FTF_FirstAllName:
               _loc2_ = 2;
               break;
            case this.FTF_BestAllName:
               _loc2_ = 3;
         }
         SExternalCore.NavigateToBattleReportUrl(this.FSevenKingData.ReportID[_loc2_]);
      }
      
      protected function OnFightReq(param1:MouseEvent) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_SevenKing_FightReq);
         _loc3_ = _loc2_.Data;
         _loc3_.writeByte(1);
         _loc3_.writeUnsignedInt(this.FSelectHero.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
         Visible = false;
      }
      
      protected function OnHeroSelect(param1:Object, param2:Object) : void
      {
         var _loc3_:THero = null;
         _loc3_ = param2 as THero;
         if(this.FSelectHero == _loc3_)
         {
            return;
         }
         this.FSelectHero = _loc3_;
         this.UpdataUI();
      }
      
      protected function OnClose(param1:MouseEvent) : void
      {
         this.FBmpMyHead.bitmapData = null;
         this.FBmpNpcHead.bitmapData = null;
         this.FSelectHero = null;
         this.FTF_MyName.text = "";
         this.FTF_NpcName.text = "";
         this.FMC_MyName.visible = false;
         Visible = false;
      }
      
      protected function ShowHeroInfoTip(param1:Object, param2:Object) : void
      {
         var _loc3_:THero = null;
         _loc3_ = param2 as THero;
         if(_loc3_ != null)
         {
            this.FHeroInfoTip.SetHeroData(_loc3_);
            this.FHeroInfoTip.Visible = true;
         }
      }
      
      protected function HideHeroInfoTip(param1:Object, param2:Object) : void
      {
         this.FHeroInfoTip.Visible = false;
      }
      
      protected function ShowEnemyInfoTip(param1:MouseEvent) : void
      {
         var _loc2_:TBins = null;
         var _loc3_:TBins = null;
         var _loc4_:THeroTalent = null;
         var _loc5_:TSkillConfig = null;
         _loc2_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SkillConfig);
         _loc3_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_HeroTalent);
      }
      
      protected function HideEnamyInfoTip(param1:MouseEvent) : void
      {
      }
      
      public function ReportReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_SevenKing_ReportReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      public function UpdataReport() : void
      {
         if(this.FSevenKingData.ReportID[0] == "" || this.FSevenKingData.ReportID[0] == null)
         {
            this.FTF_FirstSingleName.htmlText = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SEVENHERO_STRING_13),TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.COMMON_NONE));
            this.FTF_FirstSingleName.mouseEnabled = false;
         }
         else
         {
            this.FTF_FirstSingleName.htmlText = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SEVENHERO_STRING_13),this.FSevenKingData.ReportUserName[0]);
            this.FTF_FirstSingleName.mouseEnabled = true;
         }
         if(this.FSevenKingData.ReportID[1] == "" || this.FSevenKingData.ReportID[1] == null)
         {
            this.FTF_BestSingleName.htmlText = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SEVENHERO_STRING_13),TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.COMMON_NONE));
            this.FTF_BestSingleName.mouseEnabled = false;
         }
         else
         {
            this.FTF_BestSingleName.htmlText = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SEVENHERO_STRING_13),this.FSevenKingData.ReportUserName[1]);
            this.FTF_BestSingleName.mouseEnabled = true;
         }
         if(this.FSevenKingData.ReportID[2] == "" || this.FSevenKingData.ReportID[2] == null)
         {
            this.FTF_FirstAllName.htmlText = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SEVENHERO_STRING_13),TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.COMMON_NONE));
            this.FTF_FirstAllName.mouseEnabled = false;
         }
         else
         {
            this.FTF_FirstAllName.htmlText = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SEVENHERO_STRING_13),this.FSevenKingData.ReportUserName[2]);
            this.FTF_FirstAllName.mouseEnabled = true;
         }
         if(this.FSevenKingData.ReportID[3] == "" || this.FSevenKingData.ReportID[3] == null)
         {
            this.FTF_BestAllName.htmlText = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SEVENHERO_STRING_13),TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.COMMON_NONE));
            this.FTF_BestAllName.mouseEnabled = false;
         }
         else
         {
            this.FTF_BestAllName.htmlText = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SEVENHERO_STRING_13),this.FSevenKingData.ReportUserName[3]);
            this.FTF_BestAllName.mouseEnabled = true;
         }
      }
      
      public function SetHeroFight(param1:TSevenHeroArmy) : void
      {
         this.FCharacter.Heros.Sort();
         if(this.FSelectHero == null)
         {
            this.FSelectHero = this.FCharacter.GetMainHero();
         }
         this.UpdatePageInfo();
         this.UpdateHeroHead();
         this.UpdataUI(param1);
      }
      
      public function ShowHeroHead() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < this.CAPACITY_HeroHead)
         {
            this.FHeroHeadList[_loc1_].Update();
            _loc1_++;
         }
      }
      
      public function Reset() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < this.CAPACITY_HeroHead)
         {
            this.FHeroHeadList[_loc1_].Context = null;
            _loc1_++;
         }
         this.FBmpMyHead.bitmapData = null;
         this.FBmpNpcHead.bitmapData = null;
         this.FHeroInfoTip.Reset();
      }
   }
}

