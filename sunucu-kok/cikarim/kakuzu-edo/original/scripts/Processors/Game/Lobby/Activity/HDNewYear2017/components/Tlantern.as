package Processors.Game.Lobby.Activity.HDNewYear2017.components
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class Tlantern extends TUIComponent
   {
      
      protected var FBtn_PerView:TUIButton;
      
      protected var FBtn_Reflesh:TUIButton;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FMain:Sprite;
      
      protected var FObjects:Vector.<Object>;
      
      protected var FFlag:int;
      
      protected var FIndex:int;
      
      protected var FOnPerview:Function;
      
      protected var FOnReflesh:Function;
      
      protected var FOnUpdatePrice:Function;
      
      public function Tlantern(param1:TUIComponent, param2:int)
      {
         super(param1);
         this.FFlag = -1;
         this.FIndex = param2;
      }
      
      protected function ProcessorClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = 3;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FMain["MC_RandomItem_" + _loc2_]["MC_SelectBox"].gotoAndStop(2);
            _loc2_++;
         }
         this.FMain["MC_RandomItem_" + param1.currentTarget.name.split("_")[2]]["MC_SelectBox"].gotoAndStop(1);
         this.FFlag = param1.currentTarget.name.split("_")[2];
         if(this.FOnUpdatePrice != null)
         {
            this.FOnUpdatePrice();
         }
      }
      
      protected function PrecessorPerview(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnPerview != null)
         {
            this.FOnPerview(this.FIndex);
         }
      }
      
      protected function PrecessorReflesh(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnReflesh != null)
         {
            this.FOnReflesh(this.FIndex);
         }
      }
      
      public function Init(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.FMain = param1;
         _loc3_ = 3;
         this.FSlots = new Vector.<TUISlot>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FSlots[_loc2_] = new TUISlot(this);
            this.FSlots[_loc2_].Resource = this.FMain["MC_RandomItem_" + _loc2_]["slot"];
            this.FSlots[_loc2_].OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FSlots[_loc2_].OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(this.FSlots[_loc2_]);
            this.FSlots[_loc2_].Init();
            (this.FMain["MC_RandomItem_" + _loc2_] as Sprite).addEventListener(MouseEvent.CLICK,this.ProcessorClick);
            _loc2_++;
         }
         _loc3_ = 3;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FMain["MC_RandomItem_" + _loc2_]["MC_SelectBox"].gotoAndStop(2);
            _loc2_++;
         }
         this.FBtn_PerView = new TUIButton();
         this.FBtn_PerView.Substrate = this.FMain["Btn_Perview"];
         this.FBtn_PerView.OnClick = this.PrecessorPerview;
         this.FBtn_Reflesh = new TUIButton();
         this.FBtn_Reflesh.Substrate = this.FMain["Btn_Refresh"];
         this.FBtn_Reflesh.OnClick = this.PrecessorReflesh;
      }
      
      public function SetData(param1:Vector.<Object>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.FObjects = param1;
         _loc3_ = 3;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FSlots[_loc2_].Context = this.FObjects[_loc2_].inv;
            this.FMain["MC_RandomItem_" + _loc2_]["TF_Cost"].text = this.FObjects[_loc2_].cost;
            _loc2_++;
         }
      }
      
      public function Update() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = 3;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSlots[_loc1_].Update();
            _loc1_++;
         }
      }
      
      public function get Flag() : int
      {
         return this.FFlag;
      }
      
      public function set OnPerview(param1:Function) : void
      {
         this.FOnPerview = param1;
      }
      
      public function set OnReflesh(param1:Function) : void
      {
         this.FOnReflesh = param1;
      }
      
      public function get Index() : int
      {
         return this.FIndex;
      }
      
      public function set OnUpdatePrice(param1:Function) : void
      {
         this.FOnUpdatePrice = param1;
      }
   }
}

