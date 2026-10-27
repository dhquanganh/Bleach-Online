package Processors.Game.Lobby.Shortcuts.Window
{
   import Foundation.Common.*;
   import Foundation.Fonts.*;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.THD_OrderReward;
   import Logics.HDActivityMode.*;
   import Logics.TimeCoolDown.*;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Texts.*;
   import Resources.Constants.*;
   import Utilities.Timing.*;
   import flash.display.*;
   import flash.events.MouseEvent;
   
   public class TWindowActiveListPopup extends TWindowPopupBase
   {
      
      protected static const TYPE_ActiveListSecondary_OnLineGiftBag:uint = CONST_SHORTCUTS.TYPE_ActiveListSecondary_OnLineGiftBag;
      
      protected static const TYPE_ActiveListSecondary_OrderGiftBag:uint = CONST_SHORTCUTS.TYPE_ActiveListSecondary_OrderGiftBag;
      
      protected static const RESOURCE_ClassName_ActiveListSecondary_Btns:Vector.<String> = CONST_SHORTCUTS.RESOURCE_ClassName_ActiveListSecondary_Btns;
      
      protected static const TYPE_ActiveList_ReceivePacks:uint = CONST_SHORTCUTS.TYPE_ActiveList_ReceivePacks;
      
      protected static const COORDINATE_ActivityBtn:Vector.<int> = Vector.<int>([1,5]);
      
      protected static const COLOR_ContextDefault:uint = 4294967295;
      
      protected var FActivityModes:TActivityModes;
      
      protected var FActivityAtoms:Vector.<TActivityAtoms>;
      
      protected var FTimeCoolDowns:TTimeCoolDowns;
      
      protected var FPainterTime:TPainterText;
      
      protected var FPainterTimeOrder:TPainterText;
      
      protected var FHint:THint;
      
      public function TWindowActiveListPopup(param1:TUIComponent)
      {
         super(param1);
         this.FActivityModes = SLogicsCore.ActivityModes;
         this.FTimeCoolDowns = SLogicsCore.TimeCoolDowns;
         this.FPainterTime = this.ConstructPainterTextEffect();
         this.FPainterTime.Visible = false;
         this.FPainterTimeOrder = this.ConstructPainterTextEffect();
         this.FPainterTimeOrder.Visible = false;
         FShortcutsPosition = CONST_SHORTCUTS.POSITION_ActiveListSecondary;
         FShortcutsTypes = CONST_SHORTCUTS.TYPE_ActiveListSecondarys;
         FBtnCoordinates = COORDINATE_ActivityBtn;
      }
      
      protected function ConstructPainterTextEffect(param1:uint = 4294967295) : TPainterTextEffect
      {
         var _loc2_:TPainterTextEffect = null;
         _loc2_ = new TPainterTextEffect(this);
         SFontCore.FontSelect(_loc2_.Font,CONST_OVERLAYER.TEXT_ANTIALIAS_FontSetName,CONST_OVERLAYER.TEXT_ANTIALIAS_FontSetSize,CONST_OVERLAYER.TEXT_ANTIALIAS_FontSetBold);
         _loc2_.Font.Color = param1;
         _loc2_.FontEffect.AntiAliased = true;
         _loc2_.FontEffect.Outlined = true;
         _loc2_.FontEffect.Shadowed = true;
         return _loc2_;
      }
      
      override protected function Resources_UIDispatch() : void
      {
         FResourceClassNameBtns = CONST_SHORTCUTS.RESOURCE_ClassName_ActiveListSecondary_Btns;
         super.Resources_UIDispatch();
         FBounds.Width = FUIShortcut.BmpData_Middle.width;
         FBounds.Height = FUIShortcut.BmpData_Middle.height / 2;
      }
      
      override protected function Resources_UILocations() : void
      {
         var _loc1_:SimpleButton = null;
         var _loc2_:THD_OrderReward = null;
         var _loc3_:TBins = null;
         super.Resources_UILocations();
         _loc1_ = FUIShortcut.GetButtonByIndex(TYPE_ActiveListSecondary_OrderGiftBag);
         _loc1_.addEventListener(MouseEvent.MOUSE_MOVE,this.BtnOrderGiftOnMouseMove);
         _loc1_.addEventListener(MouseEvent.MOUSE_OUT,this.BtnOrderGiftOnMouseOut);
         _loc3_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_HDOrder);
         _loc2_ = _loc3_.GetDatebaseByIndex(0) as THD_OrderReward;
         this.FHint = new THint();
         this.FHint.Caption = _loc2_.Prompt;
      }
      
      protected function ProcessorOpenStatusNotification() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:SimpleButton = null;
         if(!FInitialization)
         {
            return;
         }
         if(!FUIShortcut.IsInitialization)
         {
            return;
         }
         _loc2_ = int(FUIShortcut.Capacity);
         this.FActivityAtoms = this.FActivityModes.GetActivityAtomsByMainType(TYPE_ActiveList_ReceivePacks);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = false;
            _loc4_ = int(this.FActivityAtoms.length);
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               if(FShortcutsTypes[_loc1_] == this.FActivityAtoms[_loc3_].SecondType)
               {
                  _loc5_ = true;
                  break;
               }
               _loc3_++;
            }
            _loc6_ = FUIShortcut.GetButtonByIndex(_loc1_);
            if(_loc6_.visible != _loc5_)
            {
               _loc6_.visible = _loc5_;
            }
            _loc1_++;
         }
         UpdateShortcuts();
      }
      
      protected function UpdateOderGiftCoolDown() : void
      {
         var _loc1_:SimpleButton = null;
         var _loc2_:TTimeCoolDown = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         _loc2_ = SLogicsCore.TimeCoolDowns.GetTimeByIdentifier(CONST_COMMON.TIME_COOLDOWN_Activity_OrderGiftBag);
         if(_loc2_ != null)
         {
            if(_loc2_.TimingTime > 0)
            {
               _loc3_ = int(_loc2_.TimingTime);
               _loc4_ = TUtilityTiming.FormatDHMSBySeconds(_loc3_);
               this.FPainterTimeOrder.Text = _loc4_;
               _loc1_ = FUIShortcut.GetButtonByIndex(TYPE_ActiveListSecondary_OrderGiftBag);
               FBounds.X = _loc1_.x;
               FBounds.Y = _loc1_.y;
               this.FPainterTimeOrder.RenderBounds(FBounds,TAlignment.HORIZONTAL_Center,TAlignment.VERTICAL_Center);
               if(!this.FPainterTimeOrder.Visible)
               {
                  this.FPainterTimeOrder.Visible = true;
               }
            }
            else if(this.FPainterTimeOrder.Visible)
            {
               this.FPainterTimeOrder.Visible = false;
            }
         }
      }
      
      protected function UpdateTimeCoolDown() : void
      {
         var _loc1_:SimpleButton = null;
         var _loc2_:TTimeCoolDown = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         _loc2_ = this.FTimeCoolDowns.GetTimeByIdentifier(CONST_COMMON.TIME_COOLDOWN_Activity_OnlineGiftBag);
         if(_loc2_ != null)
         {
            if(_loc2_.TimingTime > 0)
            {
               _loc3_ = int(_loc2_.TimingTime);
               _loc4_ = TUtilityTiming.FormatDHMSBySeconds(_loc3_);
               this.FPainterTime.Text = _loc4_;
               _loc1_ = FUIShortcut.GetButtonByIndex(TYPE_ActiveListSecondary_OnLineGiftBag);
               FBounds.X = _loc1_.x;
               FBounds.Y = _loc1_.y;
               this.FPainterTime.RenderBounds(FBounds,TAlignment.HORIZONTAL_Center,TAlignment.VERTICAL_Center);
               if(!this.FPainterTime.Visible)
               {
                  this.FPainterTime.Visible = true;
               }
            }
            else if(this.FPainterTime.Visible)
            {
               this.FPainterTime.Visible = false;
            }
         }
      }
      
      protected function BtnOrderGiftOnMouseMove(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function BtnOrderGiftOnMouseOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      override public function Update() : void
      {
         this.UpdateTimeCoolDown();
         this.UpdateOderGiftCoolDown();
         super.Update();
      }
      
      public function OpenStatusNotification() : void
      {
         this.ProcessorOpenStatusNotification();
      }
   }
}

