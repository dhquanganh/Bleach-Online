package Processors.Game.Lobby.KnifeSoul.Component
{
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityFilter;
   import Logics.SpiritSchool.TSpiritSchoolData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.ColorMatrixFilter;
   import flash.text.TextField;
   
   public class TUISchoolItem extends TUIComponent
   {
      
      protected var FTF_Lv:TextField;
      
      protected var FMC_Bar:MovieClip;
      
      protected var FMC_Mask:Sprite;
      
      protected var FSP_AlreadyGet:Sprite;
      
      protected var FTF_Name:TextField;
      
      protected var FTF_AddValue:TextField;
      
      protected var FTF_AddValueNext:TextField;
      
      protected var FIndex:uint;
      
      protected var FData:TSpiritSchoolData;
      
      protected var FTF_BarText:TextField;
      
      protected var FMC_Bg:MovieClip;
      
      protected var FMC_Icon:MovieClip;
      
      protected var FListitem:MovieClip;
      
      protected var FIsInitialization:Boolean;
      
      public function TUISchoolItem(param1:TUIComponent)
      {
         super(param1);
         this.FIsInitialization = false;
      }
      
      protected function Resources_UIDispatch(param1:MovieClip) : void
      {
         this.FListitem = param1;
         this.FTF_Lv = param1["MC_Lv"];
         this.FMC_Bar = param1["MC_Bar"];
         this.FMC_Mask = this.FMC_Bar["RedBarMask"];
         this.FSP_AlreadyGet = param1["MC_AlreadyGet"];
         this.FTF_Name = param1["TF_Name"];
         this.FTF_AddValue = param1["TF_AddValue"];
         this.FTF_AddValueNext = param1["TF_AddValueNext"];
         this.FTF_BarText = param1["TF_BarText"];
         this.FMC_Bg = param1["MC_Bg"];
         this.FMC_Icon = param1["MC_Icon"];
         this.FIsInitialization = true;
      }
      
      protected function Update() : void
      {
         var _loc2_:ColorMatrixFilter = null;
         var _loc1_:Array = new Array();
         var _loc3_:Array = new Array();
         _loc3_.push(TUtilityFilter.GaryColorFiltersTwo);
         this.FMC_Icon.gotoAndStop(this.FIndex + 1);
         this.FTF_Lv.text = "Lv." + this.FData.NowLv.toString();
         this.FSP_AlreadyGet.visible = this.FData.SsItems[this.FIndex].Status == -1 ? true : false;
         this.FTF_Name.text = this.FData.SsItems[this.FIndex].EffectName + ": ";
         this.FTF_AddValue.text = "+" + this.FData.SsItems[this.FIndex].AddValue.toString();
         this.FTF_AddValueNext.text = "+" + this.FData.SsItems[this.FIndex].AddValueNext.toString();
         this.FMC_Mask.scaleX = this.FData.SsItems[this.FIndex].NowExp / this.FData.SsItems[this.FIndex].ExpMax;
         this.FTF_BarText.text = this.FData.SsItems[this.FIndex].NowExp.toString() + "/" + this.FData.SsItems[this.FIndex].ExpMax.toString();
         switch(this.FData.SsItems[this.FIndex].Status)
         {
            case 0:
               this.FListitem.filters = _loc3_;
               this.FMC_Bg.gotoAndStop(2);
               break;
            case 1:
               this.FListitem.filters = [];
               this.FMC_Bg.gotoAndStop(1);
               break;
            case -1:
               this.FListitem.filters = [];
               this.FMC_Bg.gotoAndStop(2);
         }
      }
      
      public function Perform_UIDispatch(param1:MovieClip) : void
      {
         this.Resources_UIDispatch(param1);
      }
      
      public function UpdateUI(param1:uint, param2:TSpiritSchoolData) : void
      {
         this.FIndex = param1;
         this.FData = param2;
         this.Update();
      }
      
      public function Reset() : void
      {
         this.FTF_Lv.text = "";
         this.FTF_Name.text = "";
         this.FTF_AddValue.text = "";
         this.FTF_AddValueNext.text = "";
         this.FTF_BarText.text = "";
      }
   }
}

