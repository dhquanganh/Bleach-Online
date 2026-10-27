package Processors.Game.Lobby.SevenKing
{
   import Components.Standard.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   
   public class TProcessorWindowFightResult extends TUIComponent
   {
      
      protected static const TYPE_WIN:uint = 2;
      
      protected static const TYPE_LOSE:uint = 1;
      
      protected var Bg_Sp:Shape;
      
      protected var FScene:MovieClip;
      
      protected var FBT_Change:TUIButton;
      
      protected var FBT_Goon:TUIButton;
      
      protected var FBT_OK:TUIButton;
      
      protected var FChangeHero:Function;
      
      public function TProcessorWindowFightResult(param1:TUIComponent)
      {
         super(param1);
         this.Bg_Sp = new Shape();
         this.Bg_Sp.graphics.beginFill(0,0.1);
         this.Bg_Sp.graphics.drawRect(0,0,CONST_COMMON.STAGE_Max_Width,CONST_COMMON.STAGE_Max_Height);
         this.Bg_Sp.graphics.endFill();
         addChild(this.Bg_Sp);
         this.FScene = TUtilityReflection.CreateDisplayObjectInstance(CONST_SEVENKING.RESOURCESID_CLASSNAME_FightResult) as MovieClip;
         addChild(this.FScene);
         this.FScene.x = (CONST_COMMON.STAGE_Width - this.FScene.width) / 2;
         this.FScene.y = (CONST_COMMON.STAGE_Height - this.FScene.height) / 2;
         this.FBT_Change = new TUIButton();
         this.FBT_Change.Substrate = this.FScene.btn_change;
         this.FBT_Change.OnClick = this.OnChangeHero;
         this.FBT_Goon = new TUIButton();
         this.FBT_Goon.Substrate = this.FScene.btn_goon;
         this.FBT_Goon.OnClick = this.OnGoOn;
         this.FBT_OK = new TUIButton();
         this.FBT_OK.Substrate = this.FScene.btn_ok;
         this.FBT_OK.OnClick = this.OnCancel;
      }
      
      protected function OnChangeHero(param1:Object, param2:MouseEvent) : void
      {
         Visible = false;
         if(this.FChangeHero != null)
         {
            this.FChangeHero(this);
         }
      }
      
      protected function OnGoOn(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_SevenKing_FightReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeByte(0);
         _loc4_.writeUnsignedInt(0);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function OnCancel(param1:Object, param2:MouseEvent) : void
      {
         Visible = false;
      }
      
      public function get ChangeHero() : Function
      {
         return this.FChangeHero;
      }
      
      public function set ChangeHero(param1:Function) : void
      {
         this.FChangeHero = param1;
      }
      
      public function SetResult(param1:Boolean, param2:Boolean, param3:TSevenHeroArmy) : void
      {
         var _loc4_:TSystemLanguage = null;
         var _loc5_:String = null;
         var _loc6_:TSevenHeroArmy = null;
         var _loc7_:uint = 0;
         _loc7_ = param3.Identifier + 1;
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SevenHeroArmy,_loc7_) as TSevenHeroArmy;
         if(param1)
         {
            this.FScene.mc_title.gotoAndStop(TYPE_WIN);
         }
         else
         {
            this.FScene.mc_title.gotoAndStop(TYPE_LOSE);
         }
         if(param2)
         {
            this.FBT_Change.Visible = true;
            this.FBT_Goon.Visible = true;
            this.FBT_OK.Visible = false;
         }
         else
         {
            this.FBT_Change.Visible = false;
            this.FBT_Goon.Visible = false;
            this.FBT_OK.Visible = true;
         }
         if(param2)
         {
            if(param1)
            {
               _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SystemLanguage,CONST_SYSTEMLANGUAGE.SEVENHERO_SINGLE_WIN) as TSystemLanguage;
               _loc5_ = _loc4_.Desc;
               this.FScene.mc_info.tf_info.text = _loc5_;
            }
            else
            {
               _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SystemLanguage,CONST_SYSTEMLANGUAGE.SEVENHERO_SINGLE_LOSE) as TSystemLanguage;
               _loc5_ = _loc4_.Desc;
               this.FScene.mc_info.tf_info.text = _loc5_;
            }
         }
         else if(param1)
         {
            if(param3.SortNumber != 3)
            {
               _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SystemLanguage,CONST_SYSTEMLANGUAGE.SEVENHERO_TEAM_WIN) as TSystemLanguage;
               _loc5_ = _loc4_.Desc;
               this.FScene.mc_info.tf_info.text = TUtilityString.Format(_loc5_,_loc6_.Name);
            }
            else
            {
               _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SystemLanguage,CONST_SYSTEMLANGUAGE.SEVENHERO_TEAM_WIN_BOSS) as TSystemLanguage;
               _loc5_ = _loc4_.Desc;
               if(_loc6_ == null)
               {
                  this.FScene.mc_info.tf_info.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SEVENHERO_STRING_12);
               }
               else
               {
                  this.FScene.mc_info.tf_info.text = TUtilityString.Format(_loc5_,_loc6_.Name);
               }
            }
         }
         else
         {
            _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SystemLanguage,CONST_SYSTEMLANGUAGE.SEVENHERO_TEAM_LOSE) as TSystemLanguage;
            _loc5_ = _loc4_.Desc;
            this.FScene.mc_info.tf_info.text = _loc5_;
         }
         this.FScene.gotoAndPlay(1);
      }
   }
}

