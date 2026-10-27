package Processors.Game.Lobby.MainScene.Role
{
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityFilter;
   import Logics.SLogicsCore;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_MainScene;
   
   public class TUIRoleCanMoveMonster extends TUIRoleCanMove
   {
      
      protected static const Filters:Array = [TUtilityFilter.highLightFilters];
      
      protected var FMonsterParent:TUIComponent;
      
      protected var FCursorHoveringMonster:Boolean;
      
      public function TUIRoleCanMoveMonster(param1:TUIComponent)
      {
         super(param1);
         this.FMonsterParent = param1;
      }
      
      public function TextFieldName(param1:String, param2:uint) : void
      {
         FTextFiledName.text = param1;
         FTextFiledNameFormat.font = "宋体";
         FTextFiledName.setTextFormat(FTextFiledNameFormat);
         FTextFiledName.y = -FTextFiledName.height;
         FTextFiledName.textColor = param2;
         UpdateDisplayObjectPosition(FTextFiledName);
      }
      
      public function CheckIfInScreen(param1:TUIRoleCanMove) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(param1.Direction == CONST_MainScene.DIRECTION_Left)
         {
            _loc3_ = param1.MapX + param1.CurrentFrame.Pivot.X;
            _loc2_ = param1.MapX - param1.CurrentFrame.Surface.width + param1.CurrentFrame.Pivot.X;
         }
         else
         {
            _loc3_ = param1.MapX + param1.CurrentFrame.Surface.width - param1.CurrentFrame.Pivot.X;
            _loc2_ = param1.MapX - param1.CurrentFrame.Pivot.X;
         }
         if(_loc2_ > CONST_COMMON.STAGE_Width + SLogicsCore.ScreenMapX || _loc3_ < SLogicsCore.ScreenMapX)
         {
            return false;
         }
         return true;
      }
      
      override public function ChangeDirection(param1:int) : void
      {
         super.ChangeDirection(param1);
         UpdateDisplayObjectPosition(FTextFiledName);
      }
      
      override public function UpdateView() : void
      {
         super.UpdateView();
         UpdateDisplayObjectPosition(FTextFiledName);
      }
      
      override public function Release() : void
      {
         super.Release();
         parent.removeChild(this);
      }
   }
}

