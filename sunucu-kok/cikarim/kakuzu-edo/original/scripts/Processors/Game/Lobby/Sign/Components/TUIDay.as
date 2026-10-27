package Processors.Game.Lobby.Sign.Components
{
   import Foundation.Common.THint;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_DAILYSIGN;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TUIDay extends TUIComponent
   {
      
      protected static const AwardBase:uint = CONST_DAILYSIGN.AwardBase;
      
      protected static const Multiple:uint = CONST_DAILYSIGN.Multiple;
      
      protected static const IndicesLog:Number = CONST_DAILYSIGN.IndicesLog;
      
      protected static const FRAME_UnSign:uint = 1;
      
      protected static const FRAME_TemporarilyUnsign:uint = 2;
      
      protected static const FRAME_PastSign:uint = 3;
      
      protected static const FRAME_DaySign:uint = 4;
      
      protected var FMC_Day:MovieClip;
      
      protected var FMC_SelectBox:Sprite;
      
      protected var FTF_Day:TextField;
      
      protected var FMC_Hook:Sprite;
      
      protected var FBTN_Compensate:SimpleButton;
      
      protected var FIsSign:Boolean;
      
      protected var FIsShowBTNCompensate:Boolean;
      
      protected var FHintReward:THint;
      
      protected var FDay:uint;
      
      protected var FResource:Sprite;
      
      protected var FOnCompensate:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FHintOnMove:Function;
      
      public function TUIDay(param1:TUIComponent)
      {
         super(param1);
         this.FIsSign = false;
         this.FIsShowBTNCompensate = false;
         this.FHintReward = new THint();
      }
      
      protected function UIDispatch() : void
      {
         this.FMC_Day = this.FResource as MovieClip;
         this.FMC_SelectBox = this.FMC_Day[CONST_DAILYSIGN.RESOURCE_Link_MC_SelectBox];
         this.FTF_Day = this.FMC_Day[CONST_DAILYSIGN.RESOURCE_Link_TF_Day];
         this.FMC_Hook = this.FMC_Day[CONST_DAILYSIGN.RESOURCE_Link_MC_Hook];
         this.FBTN_Compensate = this.FMC_Day[CONST_DAILYSIGN.RESOURCE_Link_BTN_Compensate];
      }
      
      protected function UILocations() : void
      {
         this.FMC_Day.addEventListener(MouseEvent.MOUSE_MOVE,this.MCOnOver,false,0,true);
         this.FMC_Day.addEventListener(MouseEvent.ROLL_OUT,this.MCOnOut,false,0,true);
         this.FBTN_Compensate.addEventListener(MouseEvent.CLICK,this.CompensateOnClick,false,0,true);
      }
      
      protected function UpdateUIInfo(param1:uint) : void
      {
         this.FMC_Day.gotoAndStop(param1);
         switch(param1)
         {
            case FRAME_UnSign:
               this.SetChildrenState(false,false,false);
               this.FIsShowBTNCompensate = false;
               break;
            case FRAME_TemporarilyUnsign:
               this.SetChildrenState(false,false,false);
               this.FIsShowBTNCompensate = false;
               break;
            case FRAME_PastSign:
               this.SetChildrenState(false,false,this.FIsSign);
               this.FIsShowBTNCompensate = !this.FIsSign;
               break;
            case FRAME_DaySign:
               this.SetChildrenState(!this.FIsSign,false,this.FIsSign);
               this.FIsShowBTNCompensate = false;
         }
      }
      
      protected function SetChildrenState(param1:Boolean, param2:Boolean, param3:Boolean) : void
      {
         this.FMC_SelectBox.visible = param1;
         this.FBTN_Compensate.visible = param2;
         this.FMC_Hook.visible = param3;
      }
      
      protected function SetHintData() : String
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         _loc1_ = uint(SLogicsCore.Character.GetMainRebirthLevel() * IndicesLog * AwardBase) * Multiple;
         _loc2_ = CONST_DAILYSIGN.GetGiftCertificateByDay(this.FDay);
         _loc3_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYSIGN_STRING_07),_loc1_);
         _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYSIGN_STRING_06) + _loc3_;
         if(_loc2_ != 0)
         {
            _loc4_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYSIGN_STRING_08),_loc2_);
            _loc5_ += _loc4_;
         }
         return _loc5_;
      }
      
      protected function CompensateOnClick(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         _loc2_ = this.SetHintData();
         if(this.FOnCompensate != null)
         {
            this.FOnCompensate(this,this.FDay,_loc2_);
         }
      }
      
      protected function MCOnOver(param1:MouseEvent) : void
      {
         if(this.FIsShowBTNCompensate)
         {
            this.FBTN_Compensate.visible = this.FIsShowBTNCompensate;
         }
         this.FHintReward.Caption = this.SetHintData();
         if(this.FHintOnMove != null)
         {
            this.FHintOnMove(this,this.FHintReward);
         }
      }
      
      protected function MCOnOut(param1:MouseEvent) : void
      {
         this.FBTN_Compensate.visible = false;
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHintReward);
         }
      }
      
      public function get Resource() : Sprite
      {
         return this.FResource;
      }
      
      public function set Resource(param1:Sprite) : void
      {
         this.FResource = param1;
      }
      
      public function get IsSign() : Boolean
      {
         return this.FIsSign;
      }
      
      public function set IsSign(param1:Boolean) : void
      {
         this.FIsSign = param1;
      }
      
      public function get OnCompensate() : Function
      {
         return this.FOnCompensate;
      }
      
      public function set OnCompensate(param1:Function) : void
      {
         this.FOnCompensate = param1;
      }
      
      public function get HintOnOut() : Function
      {
         return this.FHintOnOut;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function get HintOnMove() : Function
      {
         return this.FHintOnMove;
      }
      
      public function set HintOnMove(param1:Function) : void
      {
         this.FHintOnMove = param1;
      }
      
      public function get Day() : uint
      {
         return this.FDay;
      }
      
      public function set Day(param1:uint) : void
      {
         this.FDay = param1;
      }
      
      public function Init() : void
      {
         this.UIDispatch();
         this.UILocations();
      }
      
      public function SetTextInfo(param1:uint) : void
      {
         this.FTF_Day.text = param1.toString();
      }
      
      public function SetUIInfo(param1:uint) : void
      {
         this.UpdateUIInfo(param1);
      }
   }
}

