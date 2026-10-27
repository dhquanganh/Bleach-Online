package Processors.Game.Lobby.OrganizationPointMap.Windows
{
   import Components.ScrollBar.TScrollBar;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.Organization.NewFeatures.TNewOrgData;
   import Logics.Organization.VO.TOrgDamageRankBarVO;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TPointMapInfoDamageRank extends TProcessorLobbyWindow
   {
      
      protected const MinScrollDistance:Number = 226.95;
      
      protected const ItemStamp:Number = 1;
      
      protected const SingleItemStamp:Number = 23;
      
      protected var FMainUI:MovieClip;
      
      protected var FData:TNewOrgData;
      
      protected var FScrollBar:TScrollBar;
      
      public function TPointMapInfoDamageRank(param1:TUIComponent)
      {
         super(param1);
         this.FData = SLogicsCore.NewOrgData;
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         this.Update();
      }
      
      protected function OnCloseCall(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function CreateItem() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:Vector.<TOrgDamageRankBarVO> = null;
         var _loc4_:TOrgDamageRankBarVO = null;
         var _loc5_:MovieClip = null;
         _loc3_ = this.FData.DamageRankVOs;
         _loc2_ = _loc3_.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = _loc3_[_loc1_];
            _loc5_ = TUtilityReflection.CreateDisplayObjectInstance("MC_MapInfoDamageRankBar") as MovieClip;
            _loc5_.TF_Rank.text = _loc4_.Rank.toString();
            _loc5_.TF_Name.text = _loc4_.Name.toString();
            _loc5_.TF_Damage.text = _loc4_.Damage.toString();
            this.FScrollBar.AddItem(_loc5_);
            _loc1_++;
         }
      }
      
      public function UIDispatch() : void
      {
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_PointMapInfoDamageRank") as MovieClip;
         addChild(this.FMainUI);
         this.FMainUI.Btn_Close.addEventListener(MouseEvent.CLICK,this.OnCloseCall);
         this.FScrollBar = new TScrollBar(this.FMainUI["MC_Scene"],this.MinScrollDistance,false,this.ItemStamp,this.SingleItemStamp);
      }
      
      public function Update() : void
      {
         if(Visible && this.FData != null)
         {
            this.FScrollBar.Clear();
            this.CreateItem();
            this.FScrollBar.ScrollToUp();
            this.FScrollBar.Visible = true;
         }
      }
   }
}

