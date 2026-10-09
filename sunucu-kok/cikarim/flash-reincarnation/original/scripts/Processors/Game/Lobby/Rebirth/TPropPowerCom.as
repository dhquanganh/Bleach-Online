package Processors.Game.Lobby.Rebirth
{
   import Foundation.Common.THint;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityFilter;
   import Foundation.Utilities.TUtilityString;
   import Logics.Rebirth.TRebirthData;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TPropPowerCom extends TUIComponent
   {
      
      protected const ID_EmptySoulPower:uint = 4;
      
      protected var FMainUI:MovieClip;
      
      protected var FIcon:Bitmap;
      
      protected var FData:TRebirthData;
      
      protected var FHint:THint;
      
      protected var FID:uint;
      
      public function TPropPowerCom(param1:TUIComponent)
      {
         super(param1);
         this.FData = SLogicsCore.RebirthData;
         this.FHint = new THint();
      }
      
      protected function PicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         this.FIcon.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
      }
      
      protected function OnMove(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function OnOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      public function get ID() : uint
      {
         return this.FID;
      }
      
      public function UIDispatch(param1:MovieClip) : void
      {
         this.FMainUI = param1;
         this.FIcon = new Bitmap();
         this.FMainUI.MC_Bmp_Icon.addChild(this.FIcon);
         this.FMainUI.MC_Bmp_Icon.addEventListener(MouseEvent.MOUSE_MOVE,this.OnMove);
         this.FMainUI.MC_Bmp_Icon.addEventListener(MouseEvent.MOUSE_OUT,this.OnOut);
      }
      
      public function UpdateUI(param1:uint, param2:uint = 1) : void
      {
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         var _loc5_:Vector.<String> = null;
         var _loc6_:uint = 0;
         this.FID = param1;
         this.FIcon.bitmapData = null;
         if(param1 != 0)
         {
            SResourcesCore.TexturesBuffIcon.LoadAutoSecondary(this.FData.ConfigValueVO.PropPowerBaseID[param1 - 1] + param2,this.PicArrive);
            _loc4_ = param1 == this.ID_EmptySoulPower ? CONST_SYSTEMLANGUAGE.STRING_Rebirth_20 : CONST_SYSTEMLANGUAGE.STRING_Rebirth_13;
            _loc3_ = TUtilityLobby.GetStringByIdentifier(_loc4_);
            _loc5_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Rebirth_14);
            _loc6_ = (0.1 + param2 * 0.06) * 100;
            this.FHint.Caption = TUtilityString.Format(_loc3_,param2,_loc5_[param1 - 1],_loc6_);
         }
      }
      
      public function SetBlackFilters(param1:Boolean) : void
      {
         if(param1)
         {
            this.FMainUI.filters = [TUtilityFilter.gBlackFilters];
         }
         else
         {
            this.FMainUI.filters = [];
         }
      }
   }
}

