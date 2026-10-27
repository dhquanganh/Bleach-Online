package Processors.Game.Lobby.Pet.PetTrain.Components
{
   import Components.SelectBox.*;
   import Components.Standard.*;
   import Foundation.Common.THint;
   import Foundation.UI.*;
   import Foundation.Utilities.TUtilityString;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import Utilities.Timing.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TUIPetTrainModelSelect extends TUIComponent
   {
      
      protected var MAX_SelectBoxCount:uint = 4;
      
      protected var FTF_Times:TextField;
      
      protected var FTF_Exp:TextField;
      
      protected var FTF_Silver:TextField;
      
      protected var FBtn_Train:TUIButton;
      
      protected var FSelectItems:Vector.<Sprite>;
      
      protected var FSelectBoxIndex:int;
      
      protected var FUISelectBox:TSelectBoxSingle;
      
      protected var FContext:Object;
      
      protected var FIsInitialization:Boolean;
      
      protected var FHint:THint;
      
      protected var FIsVipLimit:Boolean;
      
      protected var FResource:Sprite;
      
      protected var FOnTrainSelected:Function;
      
      public function TUIPetTrainModelSelect(param1:TUIComponent)
      {
         super(param1);
         this.FUISelectBox = new TSelectBoxSingle();
      }
      
      protected function Initialization() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         this.FTF_Times = this.FResource["TF_Times"];
         this.FTF_Exp = this.FResource["TF_Exp"];
         this.FTF_Silver = this.FResource["TF_Silver"];
         _loc2_ = this.MAX_SelectBoxCount;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FUISelectBox.SetTaskByIndex(_loc1_,this.FResource["MC_Item_" + _loc1_]["MC_SelectBox"]);
            _loc1_++;
         }
         this.FUISelectBox.Init();
         this.FUISelectBox.CallBackOnSelect = this.OnMcSelectBoxSelect;
         this.FUISelectBox.CallBackOnUnselect = this.OnMcSelectBoxUnselect;
         this.FSelectBoxIndex = 0;
         this.FUISelectBox.SetSelectByIndex(this.FSelectBoxIndex);
         this.FBtn_Train = new TUIButton();
         this.FBtn_Train.Substrate = this.FResource["Btn_Train"];
         this.FBtn_Train.OnClick = this.BtnTrainClick;
         this.FBtn_Train.OnMove = this.BtnTrainOver;
         this.FBtn_Train.OnOut = this.BtnTrainOut;
         this.FIsInitialization = true;
         this.FHint = new THint();
      }
      
      public function set Resource(param1:Sprite) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1 != this.FResource)
         {
            this.FResource = param1;
         }
         if(!this.FIsInitialization)
         {
            this.Initialization();
         }
      }
      
      public function get Context() : Object
      {
         return this.FContext;
      }
      
      public function set Context(param1:Object) : void
      {
         this.FContext = param1;
         this.UpdateConext(this.FContext);
      }
      
      protected function BtnTrainClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnTrainSelected != null)
         {
            this.FOnTrainSelected(this,(this.FContext as TVicePetTrain).Identifier);
         }
      }
      
      protected function BtnTrainOver(param1:Object, param2:MouseEvent) : void
      {
         if(this.FIsVipLimit)
         {
            SUtilityOverLayer.UIComponentsHintOnOver(FUICore,this.FHint);
         }
      }
      
      protected function BtnTrainOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(FUICore,this.FHint);
      }
      
      protected function OnMcSelectBoxSelect(param1:int, param2:int) : void
      {
         if(this.FSelectBoxIndex == param2)
         {
            return;
         }
         this.FSelectBoxIndex = param2;
         this.FUISelectBox.SetSelectByIndex(this.FSelectBoxIndex);
      }
      
      protected function OnMcSelectBoxUnselect(param1:int, param2:int) : void
      {
         this.FSelectBoxIndex = param2;
         this.FUISelectBox.SetSelectByIndex(this.FSelectBoxIndex);
      }
      
      protected function UpdateConext(param1:Object) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TVicePetTrain = null;
         var _loc5_:uint = 0;
         var _loc6_:String = null;
         _loc4_ = param1 as TVicePetTrain;
         this.FTF_Times.text = TUtilityTiming.fomatTime(_loc4_.NeedTime);
         this.FTF_Exp.text = _loc4_.GetExp.toString();
         this.FTF_Silver.text = _loc4_.Silver.toString();
         _loc3_ = _loc4_.NeedGold.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FResource["MC_Item_" + _loc2_]["TF_Consume"].text = _loc4_.NeedGold[_loc2_] + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_17) + "(" + _loc4_.NeedExp[_loc2_] + "%" + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Exp) + ")";
            _loc2_++;
         }
         _loc5_ = uint(SLogicsCore.Character.VipLevel);
         if(_loc5_ >= _loc4_.VipLimit)
         {
            this.FBtn_Train.Enabled = true;
            this.FIsVipLimit = false;
         }
         else
         {
            _loc6_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_35),_loc4_.VipLimit);
            this.FBtn_Train.Enabled = false;
            this.FIsVipLimit = true;
            this.FHint.Caption = _loc6_;
         }
      }
      
      public function get OnTrainSelected() : Function
      {
         return this.FOnTrainSelected;
      }
      
      public function set OnTrainSelected(param1:Function) : void
      {
         this.FOnTrainSelected = param1;
      }
      
      public function get SelectBoxIndex() : int
      {
         return this.FSelectBoxIndex;
      }
      
      public function set SelectBoxIndex(param1:int) : void
      {
         this.FSelectBoxIndex = param1;
      }
   }
}

