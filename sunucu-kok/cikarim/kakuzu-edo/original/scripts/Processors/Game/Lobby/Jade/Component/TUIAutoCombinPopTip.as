package Processors.Game.Lobby.Jade.Component
{
   import Components.ComboBox.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   
   public class TUIAutoCombinPopTip extends TUIComponent
   {
      
      protected static const LEVEL_NUM:uint = 9;
      
      protected var FScene:MovieClip;
      
      protected var FModalLayer:Sprite;
      
      protected var FPopParent:TUIComponent;
      
      protected var FBT_Ok:MovieClip;
      
      protected var FBT_Back:MovieClip;
      
      protected var FJadeLevelComboBox:TComboBox;
      
      protected var FJadeLevelComboBoxSelectIndex:int;
      
      protected var FMaxLevel:uint;
      
      protected var FJadeLevelNames:Vector.<String>;
      
      protected var FOnOk:Function;
      
      protected var FOnBack:Function;
      
      public function TUIAutoCombinPopTip(param1:TUIComponent)
      {
         super(param1);
         this.FModalLayer = new Sprite();
         this.SetLayer();
         this.AutoCombinPopTipInit();
         this.FMaxLevel = 4;
      }
      
      private function AutoCombinPopTipInit() : void
      {
         var _loc1_:Vector.<DisplayObject> = null;
         var _loc2_:DisplayObject = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         this.FScene = TUtilityReflection.CreateDisplayObjectInstance(CONST_JADE.RESOURCE_ClassName_AutoCombin) as MovieClip;
         this.FScene.x = (CONST_COMMON.STAGE_Width - this.FScene.width) / 2;
         this.FScene.y = (CONST_COMMON.STAGE_Height - this.FScene.height) / 2;
         this.FModalLayer.addChild(this.FScene);
         _loc1_ = new Vector.<DisplayObject>();
         this.FJadeLevelNames = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.Jade_STRING_0);
         _loc4_ = int(LEVEL_NUM);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = this.MakeComboItem(this.FJadeLevelNames[_loc3_ + 4]);
            _loc1_.push(_loc2_);
            _loc3_++;
         }
         this.FJadeLevelComboBox = new TComboBox(this,this.FScene["mc_list_level"],_loc1_,CONST_JADE.MAX_ComboboxHeight,this.OnLevelSelect);
         this.FBT_Ok = this.FScene["btn_stop"];
         TGameUtil.setButtonMode(this.FBT_Ok,true);
         this.FBT_Ok.addEventListener(MouseEvent.CLICK,this.OkOnClick);
         this.FBT_Back = this.FScene["btn_back"];
         TGameUtil.setButtonMode(this.FBT_Back,true);
         this.FBT_Back.addEventListener(MouseEvent.CLICK,this.BackOnClick);
      }
      
      protected function OnLevelSelect(param1:Object, param2:int) : void
      {
         this.FJadeLevelComboBoxSelectIndex = param2;
         this.FMaxLevel = this.FJadeLevelComboBoxSelectIndex + 4;
      }
      
      protected function MakeComboItem(param1:String) : DisplayObject
      {
         var _loc2_:MovieClip = null;
         _loc2_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_JADE.RESOURCE_ClassName_ComboBoxItem) as MovieClip;
         _loc2_.tf_into.text = param1;
         return _loc2_;
      }
      
      protected function SetLayer() : void
      {
         this.FModalLayer.addChild(new Bitmap(SUtilityResource.BtmDataFullScreen));
         this.FModalLayer.x = -250;
         this.FModalLayer.y = -100;
         this.FModalLayer.visible = false;
         addChild(this.FModalLayer);
      }
      
      private function BackOnClick(param1:MouseEvent) : void
      {
         this.PopTipVisible = false;
         this.FJadeLevelComboBox.HideComboBoxList();
         if(this.FOnBack != null)
         {
            this.FOnBack();
         }
      }
      
      private function OkOnClick(param1:MouseEvent) : void
      {
         if(this.FOnOk != null)
         {
            this.FOnOk(this,this.FMaxLevel);
         }
         this.PopTipVisible = false;
         this.FJadeLevelComboBox.HideComboBoxList();
      }
      
      public function get OnOk() : Function
      {
         return this.FOnOk;
      }
      
      public function set OnOk(param1:Function) : void
      {
         this.FOnOk = param1;
      }
      
      public function get OnBack() : Function
      {
         return this.FOnBack;
      }
      
      public function set OnBack(param1:Function) : void
      {
         this.FOnBack = param1;
      }
      
      public function set PopTipVisible(param1:Boolean) : void
      {
         this.visible = param1;
         this.FModalLayer.visible = param1;
      }
   }
}

