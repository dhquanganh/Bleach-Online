package Processors.Game.Lobby.Activity.HDAstrology.windows
{
   import Components.Standard.TUIButton;
   import Foundation.Common.THint;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.HDAstrology.TActivityAstrologyData;
   import Logics.HDAstrology.vo.TSingleCombineVo;
   import Logics.HDAstrology.vo.TStarCombinesVo;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TSoulCombineView extends TUIComponent
   {
      
      public static const Combine_Num:int = 6;
      
      public static const Max_Combine:int = 6;
      
      private var FMC_Scene:Sprite;
      
      private var FSoulTF:TextField;
      
      private var FSoulShopBtn:TUIButton;
      
      private var FSoulEffectMc:MovieClip;
      
      private var FCombineSoulTFVec:Vector.<TextField>;
      
      private var FCombineExchangeBtnVec:Vector.<TUIButton>;
      
      private var FCombineSoulEffectMcVec:Vector.<MovieClip>;
      
      private var FCombineConditionSpVec:Vector.<Vector.<Sprite>>;
      
      private var FCombineConditionStarBlackMCVec:Vector.<Vector.<MovieClip>>;
      
      private var FCombineConditionStarLightMCVec:Vector.<Vector.<MovieClip>>;
      
      private var FCombineConditionPolishingBtnVec:Vector.<Vector.<TUIButton>>;
      
      private var FCombineConditionTFVec:Vector.<Vector.<TextField>>;
      
      private var FSendIndexVec:Vector.<int>;
      
      private var FHint:THint;
      
      protected var FSendData:Function;
      
      protected var FData:TActivityAstrologyData;
      
      protected var FOpenShopFun:Function;
      
      public function TSoulCombineView(param1:TUIComponent, param2:Sprite)
      {
         super(param1);
         this.FMC_Scene = param2;
         this.InitWindow();
      }
      
      protected function InitWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Sprite = null;
         var _loc6_:TextField = null;
         var _loc7_:TUIButton = null;
         var _loc8_:Sprite = null;
         var _loc9_:Vector.<Sprite> = null;
         var _loc10_:Vector.<MovieClip> = null;
         var _loc11_:Vector.<MovieClip> = null;
         var _loc12_:Vector.<TUIButton> = null;
         var _loc13_:Vector.<TextField> = null;
         var _loc14_:MovieClip = null;
         var _loc15_:MovieClip = null;
         var _loc16_:TUIButton = null;
         var _loc17_:TextField = null;
         this.FSoulTF = this.FMC_Scene["TF_SoulValue"];
         this.FSoulShopBtn = new TUIButton();
         this.FSoulShopBtn.Substrate = this.FMC_Scene["Btn_SoulShop"];
         this.FSoulShopBtn.OnClick = this.OpenSoulShop;
         this.FSoulEffectMc = this.FMC_Scene["MC_SoulEffect"]["MC_Effect"];
         this.FSoulEffectMc.play();
         this.FCombineSoulTFVec = new Vector.<TextField>();
         this.FCombineExchangeBtnVec = new Vector.<TUIButton>();
         this.FCombineSoulEffectMcVec = new Vector.<MovieClip>();
         this.FCombineConditionSpVec = new Vector.<Vector.<Sprite>>();
         this.FCombineConditionStarBlackMCVec = new Vector.<Vector.<MovieClip>>();
         this.FCombineConditionStarLightMCVec = new Vector.<Vector.<MovieClip>>();
         this.FCombineConditionPolishingBtnVec = new Vector.<Vector.<TUIButton>>();
         this.FCombineConditionTFVec = new Vector.<Vector.<TextField>>();
         _loc2_ = Combine_Num;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = this.FMC_Scene["MC_Combine_" + _loc1_];
            _loc6_ = _loc5_["TF_SoulValue"];
            this.FCombineSoulTFVec[_loc1_] = _loc6_;
            _loc7_ = new TUIButton();
            _loc7_.Substrate = _loc5_["Btn_Exchange"];
            _loc7_.OnClick = this.OnExchangeSoul;
            this.FCombineExchangeBtnVec[_loc1_] = _loc7_;
            this.FCombineSoulEffectMcVec[_loc1_] = _loc5_["Item_Effect"]["MC_Effect"];
            this.FCombineSoulEffectMcVec[_loc1_].play();
            _loc9_ = new Vector.<Sprite>();
            _loc10_ = new Vector.<MovieClip>();
            _loc11_ = new Vector.<MovieClip>();
            _loc12_ = new Vector.<TUIButton>();
            _loc13_ = new Vector.<TextField>();
            _loc4_ = Max_Combine;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc8_ = _loc5_["Item_" + _loc3_];
               if(_loc8_ == null)
               {
                  break;
               }
               _loc15_ = _loc8_["MC_SlotBlack"];
               _loc10_[_loc3_] = _loc15_;
               _loc14_ = _loc8_["MC_SlotLight"];
               _loc11_[_loc3_] = _loc14_;
               _loc8_.addEventListener(MouseEvent.MOUSE_MOVE,this.OnResourceTipsMove);
               _loc8_.addEventListener(MouseEvent.MOUSE_OUT,this.OnResourceTipsOut);
               _loc16_ = new TUIButton();
               _loc16_.Substrate = _loc8_["Btn_Polishing"];
               _loc16_.OnClick = this.OnPolishing;
               _loc12_[_loc3_] = _loc16_;
               _loc17_ = _loc8_["TF_Condition"];
               _loc13_[_loc3_] = _loc17_;
               _loc9_[_loc3_] = _loc8_;
               _loc3_++;
            }
            this.FCombineConditionSpVec[_loc1_] = _loc9_;
            this.FCombineConditionStarLightMCVec[_loc1_] = _loc11_;
            this.FCombineConditionStarBlackMCVec[_loc1_] = _loc10_;
            this.FCombineConditionPolishingBtnVec[_loc1_] = _loc12_;
            this.FCombineConditionTFVec[_loc1_] = _loc13_;
            this.FHint = new THint();
            _loc1_++;
         }
      }
      
      protected function SendServiceData(param1:int, param2:int, param3:Vector.<int>) : void
      {
         if(this.FSendData != null)
         {
            this.FSendData(param1,param2,param3);
         }
      }
      
      protected function RefreshStarPictureInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TStarCombinesVo = null;
         var _loc6_:TSingleCombineVo = null;
         var _loc7_:String = null;
         this.FSoulTF.text = this.FData.SoulVal.toString();
         _loc2_ = int(this.FData.StarCombineVec.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = this.FData.StarCombineVec[_loc1_];
            this.FCombineExchangeBtnVec[_loc1_].Enabled = _loc5_.IsExchange;
            this.FCombineSoulTFVec[_loc1_].text = _loc5_.SoulAmount.toString();
            _loc4_ = int(_loc5_.CombineTypeVec.length);
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc6_ = _loc5_.CombineTypeVec[_loc3_];
               if(_loc6_.IsOpen)
               {
                  this.FCombineConditionStarBlackMCVec[_loc1_][_loc3_].visible = false;
                  this.FCombineConditionStarLightMCVec[_loc1_][_loc3_].gotoAndStop(_loc6_.StarType);
                  this.FCombineConditionStarLightMCVec[_loc1_][_loc3_].visible = true;
               }
               else
               {
                  this.FCombineConditionStarLightMCVec[_loc1_][_loc3_].visible = false;
                  this.FCombineConditionStarBlackMCVec[_loc1_][_loc3_].gotoAndStop(_loc6_.StarType);
                  this.FCombineConditionStarBlackMCVec[_loc1_][_loc3_].visible = true;
               }
               _loc7_ = _loc6_.IsOpen ? "<font color=\'#00ff00\'>%0/%1</font>" : "<font color=\'#FF0000\'>%0/%1</font>";
               this.FCombineConditionTFVec[_loc1_][_loc3_].htmlText = TUtilityString.Format(_loc7_,_loc6_.StarAmount,_loc6_.StarCondition);
               this.FCombineConditionPolishingBtnVec[_loc1_][_loc3_].Enabled = !_loc6_.IsOpen;
               _loc3_++;
            }
            _loc1_++;
         }
      }
      
      private function UpdateUI() : void
      {
         this.RefreshStarPictureInfo();
      }
      
      protected function OpenSoulShop(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOpenShopFun != null)
         {
            this.FOpenShopFun(1);
         }
      }
      
      protected function OnExchangeSoul(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FCombineExchangeBtnVec.indexOf(param1);
         this.FSendData(this.FData.StarCombineVec[_loc3_].CombineIndex);
      }
      
      protected function OnPolishing(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Vector.<int> = null;
         var _loc6_:TSingleCombineVo = null;
         var _loc7_:int = 0;
         _loc3_ = int((param1 as TUIButton).Substrate.parent.parent.name.split("_")[2]);
         _loc4_ = this.FCombineConditionPolishingBtnVec[_loc3_].indexOf(param1);
         _loc6_ = this.FData.StarCombineVec[_loc3_].CombineTypeVec[_loc4_];
         _loc7_ = (_loc6_.StarCondition - _loc6_.StarAmount) * _loc6_.StarCardPrice;
         SUtilityOverLayer.UIWindowConfirmation.visible = true;
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),_loc7_);
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.WindowOk;
         SUtilityOverLayer.UIWindowConfirmation.Tag = _loc6_.StarIndex;
         _loc5_ = new Vector.<int>();
         _loc5_.push(this.FData.StarCombineVec[_loc3_].CombineIndex);
         this.FSendIndexVec = _loc5_;
      }
      
      private function WindowOk(param1:Object) : void
      {
         this.FSendData(SUtilityOverLayer.UIWindowConfirmation.Tag,0,this.FSendIndexVec);
      }
      
      protected function OnResourceTipsMove(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = int((param1.currentTarget as Sprite).parent.name.split("_")[2]);
         _loc3_ = int((param1.currentTarget as Sprite).name.split("_")[1]);
         this.FHint.Caption = this.FData.StarCombineVec[_loc2_].CombineTypeVec[_loc3_].Desc;
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function OnResourceTipsOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      public function set SendData(param1:Function) : void
      {
         this.FSendData = param1;
      }
      
      public function set Data(param1:TActivityAstrologyData) : void
      {
         this.FData = param1;
      }
      
      public function set OpenShopFun(param1:Function) : void
      {
         this.FOpenShopFun = param1;
      }
      
      public function ShowView() : void
      {
         this.UpdateUI();
      }
      
      public function LogicsPerform_EnterFrame() : void
      {
      }
   }
}

