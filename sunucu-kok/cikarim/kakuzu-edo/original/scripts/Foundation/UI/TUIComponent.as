package Foundation.UI
{
   import Foundation.Common.*;
   import Foundation.Registries.*;
   import Foundation.Resources.*;
   import Foundation.UI.Spaces.*;
   import Foundation.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.geom.*;
   import flash.utils.*;
   
   use namespace UISpace;
   
   public class TUIComponent extends Sprite
   {
      
      protected static const NOTIFICATIONID_Add:uint = 0;
      
      protected static const NOTIFICATIONID_Remove:uint = 1;
      
      protected static const NOTIFICATIONID_Show:uint = 2;
      
      protected static const NOTIFICATIONID_Hide:uint = 3;
      
      protected static const NOTIFICATIONID_Enable:uint = 4;
      
      protected static const NOTIFICATIONID_Disable:uint = 5;
      
      protected static const NOTIFICATIONID_DragQuery:uint = 6;
      
      protected static const NOTIFICATIONID_DragDrop:uint = 7;
      
      protected static const NOTIFICATIONMASK_Parent:uint = 2147483648;
      
      protected static const NOTIFICATIONMASK_Singlecast:uint = 1073741824;
      
      protected static const NOTIFICATIONMASK_Identifier:uint = 65535;
      
      protected static const NOTIFICATION_Add:uint = NOTIFICATIONID_Add;
      
      protected static const NOTIFICATION_Remove:uint = NOTIFICATIONID_Remove;
      
      protected static const NOTIFICATION_Show:uint = NOTIFICATIONID_Show;
      
      protected static const NOTIFICATION_Hide:uint = NOTIFICATIONID_Hide;
      
      protected static const NOTIFICATION_Enable:uint = NOTIFICATIONID_Enable;
      
      protected static const NOTIFICATION_Disable:uint = NOTIFICATIONID_Disable;
      
      protected static const NOTIFICATION_DragQuery:uint = NOTIFICATIONID_DragQuery | NOTIFICATIONMASK_Singlecast;
      
      protected static const NOTIFICATION_DragDrop:uint = NOTIFICATIONID_DragDrop | NOTIFICATIONMASK_Singlecast;
      
      protected var FNotificationRoutines:TRegistryRoutine;
      
      protected var FUIMessageRoutines:TRegistryRoutine;
      
      protected var FPosition:TCoordinate;
      
      protected var FBoundsScreen:TBounds;
      
      protected var FBoundsClient:TBounds;
      
      protected var FComponents:Vector.<TUIComponent>;
      
      protected var FComponentsCompacted:Boolean;
      
      protected var FComponentsTraversing:Boolean;
      
      protected var FUICore:TUICore;
      
      protected var FBacktrackedEnabled:Boolean;
      
      protected var FBacktrackedVisible:Boolean;
      
      protected var FParent:TUIComponent;
      
      protected var FEnabled:Boolean;
      
      protected var FTag:int;
      
      public function TUIComponent(param1:TUIComponent)
      {
         super();
         this.FParent = param1;
         if(param1 != null)
         {
            param1.addChild(this);
         }
         this.FNotificationRoutines = new TRegistryRoutine();
         this.NotificationRegisterRoutines();
         this.FUIMessageRoutines = new TRegistryRoutine();
         this.FPosition = new TCoordinate();
         this.FBoundsScreen = new TBounds();
         this.FBoundsClient = new TBounds();
         this.FComponents = new Vector.<TUIComponent>();
         this.FComponentsTraversing = false;
         this.FComponentsCompacted = true;
         this.Enabled = true;
         this.Visible = true;
         if(this.FParent != null)
         {
            this.FParent.ComponentAdd(this);
         }
      }
      
      UISpace function ComponentAdd(param1:TUIComponent) : void
      {
         this.FComponents.push(param1);
         param1.NotificationProcess(NOTIFICATION_Add);
      }
      
      UISpace function ComponentRemove(param1:TUIComponent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FComponents.indexOf(param1);
         if(_loc2_ < 0)
         {
            return;
         }
         param1.NotificationProcess(NOTIFICATION_Remove);
         if(this.FComponentsTraversing)
         {
            this.FComponents[_loc2_] = null;
            this.FComponentsCompacted = false;
         }
         else
         {
            this.FComponents.splice(_loc2_,1);
         }
      }
      
      UISpace function ComponentsCompact() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = 0;
         if(!this.FComponentsCompacted)
         {
            _loc1_ = int(this.FComponents.length);
            _loc2_ = int(_loc1_ - 1);
            while(_loc2_ >= 0)
            {
               if(this.FComponents[_loc2_] == null)
               {
                  this.FComponents.splice(_loc2_,1);
               }
               _loc2_--;
            }
            this.FComponentsCompacted = true;
         }
      }
      
      UISpace function NotificationProcess(param1:uint) : void
      {
         this.NotificationPerform(param1);
         if((param1 & NOTIFICATIONMASK_Singlecast) == 0)
         {
            param1 |= NOTIFICATIONMASK_Parent;
            this.NotificationTraverse(param1);
         }
      }
      
      UISpace function NotificationTraverse(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = 0;
         var _loc4_:TUIComponent = null;
         if(this.FComponents != null)
         {
            this.FComponentsTraversing = true;
            _loc2_ = int(this.FComponents.length);
            _loc3_ = int(_loc2_ - 1);
            while(_loc3_ >= 0)
            {
               _loc4_ = this.FComponents[_loc3_];
               _loc4_.NotificationProcess(param1);
               _loc3_--;
            }
            this.FComponentsTraversing = false;
            this.ComponentsCompact();
         }
      }
      
      protected function ProcessorResize() : void
      {
      }
      
      UISpace function ComponentsTraverse() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIComponent = null;
         if(this.FComponents != null)
         {
            _loc1_ = int(this.FComponents.length);
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc3_ = this.FComponents[_loc2_];
               if(_loc3_ != null)
               {
                  _loc3_.ProcessorResize();
               }
               _loc2_++;
            }
         }
         this.ProcessorResize();
      }
      
      protected function BacktrackCores() : void
      {
         this.BacktrackCores_UI();
      }
      
      protected function BacktrackCores_UI() : void
      {
         if(this.FParent != null)
         {
            this.FUICore = this.FParent.FUICore;
         }
      }
      
      protected function RevokeCores() : void
      {
         this.RevokeCores_UI();
      }
      
      protected function RevokeCores_UI() : void
      {
         this.FUICore = null;
      }
      
      protected function BacktrackEnabled() : void
      {
         var _loc1_:TUIComponent = null;
         if(this.FEnabled)
         {
            _loc1_ = this.FParent;
            while(_loc1_ != null)
            {
               if(!_loc1_.FEnabled)
               {
                  this.FBacktrackedEnabled = false;
                  return;
               }
               _loc1_ = _loc1_.FParent;
            }
         }
         this.FBacktrackedEnabled = this.FEnabled;
      }
      
      protected function BacktrackVisible() : void
      {
         var _loc1_:TUIComponent = null;
         if(this.Visible)
         {
            _loc1_ = this.FParent;
            while(_loc1_ != null)
            {
               if(!_loc1_.Visible)
               {
                  this.FBacktrackedVisible = false;
                  return;
               }
               _loc1_ = _loc1_.FParent;
            }
         }
         this.FBacktrackedVisible = this.Visible;
      }
      
      protected function RevokeInteraction() : void
      {
         if(this.FUICore != null)
         {
            this.FUICore.MouseCaptureRelease(this);
         }
      }
      
      protected function CoordinateHitTest(param1:TCoordinate) : Boolean
      {
         return TUtilityCartisian.BoundsContainsCoordinate(this.FBoundsScreen,param1);
      }
      
      protected function NotificationRegisterRoutines() : void
      {
         this.FNotificationRoutines.Register(NOTIFICATIONID_Add,this.NotificationPerform_Add);
         this.FNotificationRoutines.Register(NOTIFICATIONID_Remove,this.NotificationPerform_Remove);
         this.FNotificationRoutines.Register(NOTIFICATIONID_Show,this.NotificationPerform_Show);
         this.FNotificationRoutines.Register(NOTIFICATIONID_Hide,this.NotificationPerform_Hide);
         this.FNotificationRoutines.Register(NOTIFICATIONID_Enable,this.NotificationPerform_Enable);
         this.FNotificationRoutines.Register(NOTIFICATIONID_Disable,this.NotificationPerform_Disable);
         this.FNotificationRoutines.Register(NOTIFICATIONID_DragQuery,this.NotificationPerform_DragQuery);
         this.FNotificationRoutines.Register(NOTIFICATIONID_DragDrop,this.NotificationPerform_DragDrop);
      }
      
      protected function NotificationPerform(param1:uint) : void
      {
         var _loc2_:Function = null;
         _loc2_ = this.FNotificationRoutines.GetRoutineByIndentifier(param1 & NOTIFICATIONMASK_Identifier);
         if(_loc2_ != null)
         {
            _loc2_();
         }
      }
      
      protected function NotificationPerform_Add() : void
      {
         this.BacktrackCores();
         this.BacktrackEnabled();
         this.BacktrackVisible();
      }
      
      protected function NotificationPerform_Remove() : void
      {
         this.RevokeInteraction();
         this.RevokeCores();
      }
      
      protected function NotificationPerform_Show() : void
      {
         this.BacktrackVisible();
      }
      
      protected function NotificationPerform_Hide() : void
      {
         this.RevokeInteraction();
         this.BacktrackVisible();
      }
      
      protected function NotificationPerform_Enable() : void
      {
         this.BacktrackEnabled();
      }
      
      protected function NotificationPerform_Disable() : void
      {
         this.RevokeInteraction();
         this.BacktrackEnabled();
      }
      
      protected function NotificationPerform_DragQuery() : void
      {
      }
      
      protected function NotificationPerform_DragDrop() : void
      {
      }
      
      public function get Parent() : TUIComponent
      {
         return this.FParent;
      }
      
      public function set Parent(param1:TUIComponent) : void
      {
         if(param1 == this.FParent)
         {
            return;
         }
         if(this.FParent != null)
         {
            this.FParent.ComponentRemove(this);
         }
         this.FParent = param1;
         if(this.FParent != null)
         {
            this.FParent.ComponentAdd(this);
         }
      }
      
      public function get Position() : TCoordinate
      {
         this.FPosition.X = this.FBoundsClient.X;
         this.FPosition.Y = this.FBoundsClient.Y;
         return this.FPosition;
      }
      
      public function get X() : int
      {
         return this.x;
      }
      
      public function set X(param1:int) : void
      {
         this.FBoundsClient.X = param1;
         this.x = param1;
      }
      
      public function get Y() : int
      {
         return this.y;
      }
      
      public function set Y(param1:int) : void
      {
         this.FBoundsClient.Y = param1;
         this.y = param1;
      }
      
      public function get Width() : int
      {
         return this.width;
      }
      
      public function set Width(param1:int) : void
      {
         this.FBoundsClient.Width = param1;
         this.width = param1;
      }
      
      public function get Height() : int
      {
         return this.height;
      }
      
      public function set Height(param1:int) : void
      {
         this.FBoundsClient.Height = param1;
         this.height = param1;
      }
      
      public function get Enabled() : Boolean
      {
         return this.FEnabled;
      }
      
      public function set Enabled(param1:Boolean) : void
      {
         if(param1)
         {
            this.NotificationProcess(NOTIFICATION_Enable);
         }
         else
         {
            this.NotificationProcess(NOTIFICATION_Disable);
         }
         this.FEnabled = param1;
      }
      
      public function get Visible() : Boolean
      {
         return this.visible;
      }
      
      public function set Visible(param1:Boolean) : void
      {
         if(param1 == visible)
         {
            return;
         }
         visible = param1;
      }
      
      public function get Cursor() : uint
      {
         return CONST_CURSOR.CURSORID_Default;
      }
      
      public function get CursorDisplayObject() : TUIComponent
      {
         return null;
      }
      
      public function get Tag() : int
      {
         return this.FTag;
      }
      
      public function set Tag(param1:int) : void
      {
         this.FTag = param1;
      }
      
      public function get UICore() : TUICore
      {
         return this.FUICore;
      }
      
      public function set UICore(param1:TUICore) : void
      {
         this.FUICore = param1;
      }
      
      public function BoundsClientSet(param1:int, param2:int, param3:int, param4:int) : void
      {
         TUtilityCartisian.BoundsSet(this.FBoundsClient,param1,param2,param3,param4);
      }
      
      public function BoundsClientAssign(param1:TBounds) : void
      {
         this.FBoundsClient.Assign(param1);
      }
      
      public function IsParentOf(param1:TUIComponent) : Boolean
      {
         var _loc2_:TUIComponent = null;
         _loc2_ = param1.FParent;
         while(_loc2_ != null)
         {
            if(_loc2_ == this)
            {
               return true;
            }
            _loc2_ = _loc2_.FParent;
         }
         return false;
      }
      
      public function ComponentsResize() : void
      {
         this.ComponentsTraverse();
      }
      
      public function Dispose() : void
      {
      }
   }
}

