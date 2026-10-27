package Processors.Game.Lobby.Organization.Part
{
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.*;
   import Logics.Organization.*;
   import Logics.Organization.Elements.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   
   public class TComponentOrganizationMuyeGuardRank extends TUIComponent
   {
      
      protected static const MAX_COUNT:uint = 9;
      
      protected static const TYPE_MC_EXP:uint = 1;
      
      protected static const TYPE_MC_MONEY:uint = 0;
      
      protected var FScene:MovieClip;
      
      protected var FHint:THint;
      
      protected var FHeadBitmap:Bitmap;
      
      protected var FMuyeGuardRank:TMuyeGuardRank;
      
      protected var FInitialized:Boolean;
      
      protected var FHintOnMove:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FOnClose:Function;
      
      public function TComponentOrganizationMuyeGuardRank(param1:TUIComponent)
      {
         super(param1);
         this.FHint = new THint();
         this.FInitialized = false;
         this.FMuyeGuardRank = new TMuyeGuardRank();
      }
      
      protected function Resources_UIDispatch(param1:MovieClip) : void
      {
         this.FScene = param1;
         addChild(this.FScene);
         this.FScene.mc_buff_0.gotoAndStop(1);
         this.FScene.mc_buff_0.addEventListener(MouseEvent.MOUSE_MOVE,this.OnMouseMove);
         this.FScene.mc_buff_0.addEventListener(MouseEvent.ROLL_OUT,this.OnMouseOut);
         this.FScene.mc_buff_0.gotoAndStop(2);
         this.FScene.mc_buff_1.addEventListener(MouseEvent.MOUSE_MOVE,this.OnMouseMove);
         this.FScene.mc_buff_1.addEventListener(MouseEvent.ROLL_OUT,this.OnMouseOut);
         this.FScene.tf_desc.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_13);
         this.FScene.Btn_Close.addEventListener(MouseEvent.CLICK,this.OnCloseClick);
         this.FHeadBitmap = new Bitmap();
         this.FScene.S_HeroHeadPic.addChild(this.FHeadBitmap);
         this.FInitialized = true;
      }
      
      protected function HideMCS() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         _loc1_ = 0;
         while(_loc1_ < MAX_COUNT)
         {
            _loc2_ = this.FScene["mc_list_" + _loc1_];
            _loc2_.visible = false;
            _loc1_++;
         }
         this.FScene["mc_curOrgFamily"].visible = false;
         this.FScene["tf_curOrgName"].text = "";
         this.FScene["tf_beferOrgName"].text = "";
         this.FScene["mc_beferOrgFamily"].visible = false;
         this.FScene["tf_bestFightValue"].text = "";
         this.FScene["tf_bestName"].text = "";
         this.FScene["mc_winStatus"].visible = false;
         this.FScene["MC_First"].visible = false;
         this.FScene["tf_defendDay"].text = "";
      }
      
      protected function UpdateUI() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:TBaseRankList = null;
         if(this.FMuyeGuardRank.WinStatus)
         {
            this.FScene.mc_winStatus.gotoAndStop(1);
            this.FScene.mc_winStatus.visible = true;
            this.FScene.MC_First.gotoAndStop(1);
            this.FScene.MC_First.visible = true;
         }
         else
         {
            this.FScene.mc_winStatus.gotoAndStop(2);
            this.FScene.MC_First.gotoAndStop(2);
            this.FScene.MC_First.visible = true;
            this.FScene.mc_winStatus.visible = true;
         }
         if(this.FMuyeGuardRank.CurTurnOrgName.length > 0)
         {
            this.FScene.tf_curOrgName.text = this.FMuyeGuardRank.CurTurnOrgName;
         }
         else
         {
            this.FScene.tf_curOrgName.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.COMMON_NONE);
         }
         if(this.FMuyeGuardRank.CurTurnOrgFamily <= 0)
         {
            this.FScene.mc_curOrgFamily.visible = false;
         }
         else
         {
            this.FScene.mc_curOrgFamily.visible = true;
            this.FScene.mc_curOrgFamily.gotoAndStop(this.FMuyeGuardRank.CurTurnOrgFamily);
         }
         if(this.FMuyeGuardRank.BeferTurnOrgName.length > 0)
         {
            this.FScene.tf_beferOrgName.text = this.FMuyeGuardRank.BeferTurnOrgName;
         }
         else
         {
            this.FScene.tf_beferOrgName.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.COMMON_NONE);
         }
         if(this.FMuyeGuardRank.BeferTurnOrgFamily <= 0)
         {
            this.FScene.mc_beferOrgFamily.visible = false;
         }
         else
         {
            this.FScene.mc_beferOrgFamily.visible = true;
            this.FScene.mc_beferOrgFamily.gotoAndStop(this.FMuyeGuardRank.BeferTurnOrgFamily);
         }
         this.FScene.tf_defendDay.text = this.FMuyeGuardRank.DefendDay;
         _loc1_ = 0;
         while(_loc1_ < MAX_COUNT)
         {
            _loc2_ = this.FScene["mc_list_" + _loc1_];
            if(_loc1_ < this.FMuyeGuardRank.OrgRankList.length)
            {
               _loc3_ = this.FMuyeGuardRank.OrgRankList[_loc1_];
               _loc2_.visible = true;
               _loc2_.tf_ranking.text = _loc1_ + 1;
               if(_loc3_.RankFamily <= 0)
               {
                  _loc2_.mc_familyIcon.visible = false;
               }
               else
               {
                  _loc2_.mc_familyIcon.visible = true;
                  _loc2_.mc_familyIcon.gotoAndStop(_loc3_.RankFamily);
               }
               _loc2_.tf_orgName.text = _loc3_.RankName;
               _loc2_.tf_score.text = _loc3_.RankScore;
            }
            else
            {
               _loc2_.visible = false;
            }
            _loc1_++;
         }
         this.FScene.tf_bestName.text = this.FMuyeGuardRank.DefendUserName;
         this.FScene.tf_bestFightValue.text = this.FMuyeGuardRank.DefendFightValue;
         if(this.FMuyeGuardRank.DefendHeroId > 0)
         {
            SResourcesCore.TexturesMiddlePic.LoadAutoSecondary(this.FMuyeGuardRank.DefendHeroId,this.AutoLoadCallBack);
         }
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         var _loc5_:BitmapData = null;
         switch(param3)
         {
            case this.FMuyeGuardRank.DefendHeroId:
               _loc4_ = param2.GetAnimationSequenceByIndex(0);
               _loc5_ = _loc4_.GetAnimationFrameByIndex(0).Surface;
               this.FHeadBitmap.bitmapData = _loc5_;
         }
      }
      
      protected function OnMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = uint(int(String(param1.currentTarget.name).slice(8)));
         if(_loc2_ == TYPE_MC_EXP)
         {
            this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_11);
         }
         else
         {
            if(_loc2_ != TYPE_MC_MONEY)
            {
               return;
            }
            this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_12);
         }
         if(this.FHintOnMove != null)
         {
            this.FHintOnMove(param1,this.FHint);
         }
      }
      
      protected function OnMouseOut(param1:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(param1,this.FHint);
         }
      }
      
      protected function OnCloseClick(param1:MouseEvent) : void
      {
         if(this.FOnClose != null)
         {
            this.FOnClose(this);
         }
      }
      
      public function get HintOnMove() : Function
      {
         return this.FHintOnMove;
      }
      
      public function set HintOnMove(param1:Function) : void
      {
         this.FHintOnMove = param1;
      }
      
      public function get HintOnOut() : Function
      {
         return this.FHintOnOut;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function get Initialized() : Boolean
      {
         return this.FInitialized;
      }
      
      public function get OnClose() : Function
      {
         return this.FOnClose;
      }
      
      public function set OnClose(param1:Function) : void
      {
         this.FOnClose = param1;
      }
      
      public function Perform_UIDispatch(param1:MovieClip) : void
      {
         this.Resources_UIDispatch(param1);
         this.HideMCS();
         this.FScene.mc_winStatus.gotoAndStop(1);
         this.FScene.MC_First.gotoAndStop(1);
         this.FInitialized = true;
      }
      
      public function MuyeGuardRankReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Organization_CityDefendInfoReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      public function SetData(param1:TMuyeGuardRank) : void
      {
         this.FMuyeGuardRank = param1;
         this.UpdateUI();
      }
      
      public function Reset() : void
      {
         this.FHeadBitmap.bitmapData = null;
      }
   }
}

