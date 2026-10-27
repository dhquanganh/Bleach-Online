package Processors.Game.Lobby.RelatedPartner.RelatedAssistance
{
   import Components.Pages.TUIPage;
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.Characters.THero;
   import Logics.Characters.THeros;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_RELATEDPARTNER;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   
   public class TWindowAssistanceList extends TProcessorLobbyWindow
   {
      
      protected static const Head_Num:int = 12;
      
      protected var FMainUI:Sprite;
      
      protected var FBtnClose:TUIButton;
      
      protected var FPage:TUIPage;
      
      protected var FPos:int;
      
      protected var FHeadVec:Vector.<THeadAssistance>;
      
      protected var FHeros:THeros;
      
      protected var FOnItemOver:Function;
      
      protected var FOnItemOut:Function;
      
      public function TWindowAssistanceList(param1:TUIComponent)
      {
         super(param1);
         this.FHeadVec = new Vector.<THeadAssistance>();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:THeadAssistance = null;
         super.ResourcesPerform_UIDispatch();
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance(CONST_RELATEDPARTNER.ResourceID_AssistanceList) as Sprite;
         addChild(this.FMainUI);
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainUI[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtnClose.OnClick = this.BtnOnClose;
         _loc1_ = 0;
         while(_loc1_ < Head_Num)
         {
            _loc2_ = new THeadAssistance(this.FMainUI["MCHead_" + _loc1_]);
            _loc2_.OnOver = this.OnRenderOver;
            _loc2_.OnOut = this.OnRenderOut;
            _loc2_.OnClick = this.OnRenderClick;
            this.FHeadVec.push(_loc2_);
            _loc1_++;
         }
         this.FPage = new TUIPage(this);
         this.FPage.ButtonNext.Substrate = this.FMainUI["MC_PageRight"];
         this.FPage.ButtonPrevious.Substrate = this.FMainUI["MC_PageLeft"];
         this.FPage.LabelPage = this.FMainUI["TF_Page"];
         this.FPage.PageSize = Head_Num;
         this.FPage.OnChangePage = this.OnSwitchPage;
         this.FPage.Init();
         this.FHeros = new THeros();
      }
      
      protected function OnSwitchPage(param1:Object, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THero = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         _loc8_ = 0;
         _loc6_ = param2 * Head_Num;
         _loc7_ = _loc6_ + Head_Num;
         _loc4_ = this.FHeros.Count;
         _loc3_ = _loc6_;
         while(_loc3_ < _loc4_ && _loc8_ < Head_Num)
         {
            _loc5_ = this.FHeros.GetHeroByIndex(_loc3_);
            this.FHeadVec[_loc8_].Render(_loc5_);
            _loc3_++;
            _loc8_++;
         }
         while(_loc8_ < Head_Num)
         {
            this.FHeadVec[_loc8_].Render();
            _loc8_++;
         }
      }
      
      protected function Render() : void
      {
         var _loc1_:THero = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:THeros = null;
         this.FHeros.Clear();
         _loc4_ = SLogicsCore.Character.Heros;
         _loc3_ = _loc4_.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = _loc4_.GetHeroByIndex(_loc2_);
            if(!_loc1_.IsMain)
            {
               if(_loc1_.RelatedPartnerPos == 0)
               {
                  if(_loc1_.FightPosition == 0)
                  {
                     this.FHeros.Add(_loc1_);
                  }
               }
            }
            _loc2_++;
         }
         this.FPage.SetupPage(this.FHeros.Count,0);
         this.OnSwitchPage(this.FPage,0);
      }
      
      protected function BtnOnClose(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function OnRenderClick(param1:int) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Related_HeroHelpReq);
         _loc3_ = _loc2_.Data;
         _loc3_.writeUnsignedInt(param1);
         _loc3_.writeUnsignedInt(this.FPos);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
         ProcessorWindowClose();
      }
      
      protected function OnRenderOver(param1:Object, param2:THero) : void
      {
         this.FOnItemOver(param1,param2);
      }
      
      protected function OnRenderOut(param1:Object) : void
      {
         this.FOnItemOut(param1);
      }
      
      public function Show(param1:int) : void
      {
         if(!Visible)
         {
            this.Render();
         }
         this.Visible = true;
         this.FPos = param1;
      }
      
      public function get OnItemOver() : Function
      {
         return this.FOnItemOver;
      }
      
      public function set OnItemOver(param1:Function) : void
      {
         this.FOnItemOver = param1;
      }
      
      public function get OnItemOut() : Function
      {
         return this.FOnItemOut;
      }
      
      public function set OnItemOut(param1:Function) : void
      {
         this.FOnItemOut = param1;
      }
   }
}

