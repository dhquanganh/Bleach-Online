package Processors.Game.Lobby.Shortcuts.Window
{
   import Foundation.UI.TUIComponent;
   import Resources.Constants.CONST_SHORTCUTS;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class TWindowSecondaryFunctionPopupB extends TWindowPopupBase
   {
      
      protected var GoldLabel:TextField;
      public function TWindowSecondaryFunctionPopupB(param1:TUIComponent)
      {
         super(param1);
         FShortcutsPosition = CONST_SHORTCUTS.POSITION_SecondaryFunctionB;
         FShortcutsTypes = CONST_SHORTCUTS.TYPE_SecondaryFunctionBs.concat(Vector.<uint>([10]));
      }
      
      override protected function Resources_UIDispatch() : void
      {
         FResourceClassNameBtns = CONST_SHORTCUTS.RESOURCE_ClassName_SecondaryFunctionB_Btns.concat(Vector.<String>(["Btn_KillHeros"]));
         super.Resources_UIDispatch();
      }
      override public function UpdateShortcutsState(param1:Object) : void
      {
         super.UpdateShortcutsState(param1);
         this.UpdateShortcuts();
      }
      override protected function UpdateShortcuts() : void
      {
         if(FUIShortcut == null || !FUIShortcut.IsInitialization || FUIShortcut.Capacity < 11)return;
         FUIShortcut.GetButtonByIndex(10).visible=FUIShortcut.GetButtonByIndex(2).visible;
         super.UpdateShortcuts();
         var positions:Array=[];var order:Array=[];
         for(var i:int=0;i<11;i++)
         {
            var btn:SimpleButton=FUIShortcut.GetButtonByIndex(i);
            if(btn.visible)positions.push({x:btn.x,y:btn.y});
         }
         for(i=0;i<10;i++){if(FUIShortcut.GetButtonByIndex(i).visible)order.push(i);if(i==2 && FUIShortcut.GetButtonByIndex(10).visible)order.push(10);}
         for(i=0;i<order.length;i++){btn=FUIShortcut.GetButtonByIndex(order[i]);btn.x=positions[i].x;btn.y=positions[i].y;}
         if(this.GoldLabel==null){this.GoldLabel=new TextField();this.GoldLabel.defaultTextFormat=new TextFormat("Arial",10,0xFFE380,true);this.GoldLabel.text="Tower of Gold";this.GoldLabel.width=75;this.GoldLabel.height=18;this.GoldLabel.background=true;this.GoldLabel.backgroundColor=0x201608;this.GoldLabel.mouseEnabled=false;addChild(this.GoldLabel);}
         btn=FUIShortcut.GetButtonByIndex(10);this.GoldLabel.x=btn.x;this.GoldLabel.y=btn.y+btn.height-18;this.GoldLabel.visible=btn.visible;
      }
   }
}

