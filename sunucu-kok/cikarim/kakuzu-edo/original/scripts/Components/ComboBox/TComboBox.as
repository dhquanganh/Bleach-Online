package Components.ComboBox
{
   import Components.ScrollBar.TScrollBar;
   import Foundation.Utilities.TGameUtil;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   
   public class TComboBox
   {
      
      protected var FListScrol:TScrollBar;
      
      protected var FParent:DisplayObjectContainer;
      
      protected var FScene:MovieClip;
      
      protected var FShowList:Vector.<DisplayObject>;
      
      protected var FMinScrollDistance:Number;
      
      protected var FIsSelectFirstItem:Boolean;
      
      protected var FCurSelectBtn:MovieClip;
      
      protected var FSelectCallBack:Function;
      
      protected var FOnDropBarMove:Function;
      
      protected var FOnDropListMove:Function;
      
      protected var FOnDropListOut:Function;
      
      public function TComboBox(param1:DisplayObjectContainer, param2:DisplayObjectContainer, param3:Vector.<DisplayObject>, param4:Number, param5:Function, param6:Boolean = true)
      {
         super();
         this.FParent = param1;
         this.FScene = param2 as MovieClip;
         this.FShowList = param3 ? param3 : new Vector.<DisplayObject>();
         this.FMinScrollDistance = param4;
         this.FSelectCallBack = param5;
         this.FIsSelectFirstItem = param6;
         this.InitComboBox();
      }
      
      protected function InitComboBox() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         TGameUtil.setButtonMode(this.FScene.mc_bar.btn_showlist,true);
         this.FScene.mc_bar.addEventListener(MouseEvent.MOUSE_UP,this.OnShowListClick);
         this.FScene.mc_bar.addEventListener(MouseEvent.MOUSE_MOVE,this.DropBarOnMove);
         this.FScene.mc_bar.addEventListener(MouseEvent.MOUSE_OUT,this.DropListOnOut);
         this.FScene.mc_bar.buttonMode = true;
         this.FScene.mc_bar.tf_curInfo.mouseEnabled = false;
         this.FListScrol = new TScrollBar(this.FScene.mc_list,this.FMinScrollDistance,false);
         this.FListScrol.Visible = false;
         _loc1_ = 0;
         while(_loc1_ < this.FShowList.length)
         {
            _loc2_ = this.FShowList[_loc1_] as MovieClip;
            this.FListScrol.AddItem(_loc2_);
            TGameUtil.setButtonMode(_loc2_,true);
            _loc2_.addEventListener(MouseEvent.MOUSE_UP,this.OnSelectItem);
            this.FShowList[_loc1_]["listIndex"] = _loc1_;
            _loc1_++;
         }
         if(this.FShowList.length > 0 && this.FIsSelectFirstItem)
         {
            this.FShowList[0].dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
         }
         if(this.FParent != null)
         {
            this.FParent.addEventListener(MouseEvent.CLICK,this.OnHideComboBoxList);
         }
      }
      
      protected function OnShowListClick(param1:MouseEvent) : void
      {
         if(this.FListScrol != null)
         {
            this.FListScrol.Visible = !this.FListScrol.Visible;
         }
      }
      
      protected function OnSelectItem(param1:MouseEvent) : void
      {
         var _loc2_:TextField = null;
         var _loc3_:int = 0;
         if(Boolean(param1.currentTarget) && !param1.currentTarget.buttonMode)
         {
            return;
         }
         if(this.FCurSelectBtn != null)
         {
            TGameUtil.setButtonMode(this.FCurSelectBtn,true);
         }
         this.FCurSelectBtn = param1.currentTarget as MovieClip;
         TGameUtil.setButtonMode(this.FCurSelectBtn,false);
         _loc2_ = (param1.currentTarget as DisplayObject)["tf_into"] as TextField;
         if(_loc2_ != null)
         {
            this.FScene.mc_bar.tf_curInfo.text = _loc2_.text ? _loc2_.text : "";
         }
         this.FListScrol.Visible = false;
         _loc3_ = int((param1.currentTarget as DisplayObject)["listIndex"]);
         if(this.FSelectCallBack != null)
         {
            this.FSelectCallBack(this,_loc3_);
         }
      }
      
      protected function DropBarOnMove(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = -1;
         if(this.FOnDropBarMove != null)
         {
            this.FOnDropBarMove(this,_loc2_);
         }
      }
      
      protected function DropListOnMove(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:DisplayObject = null;
         _loc3_ = param1.currentTarget as DisplayObject;
         _loc2_ = this.FShowList.indexOf(_loc3_);
         if(this.FOnDropListMove != null)
         {
            this.FOnDropListMove(this,_loc2_);
         }
      }
      
      protected function DropListOnOut(param1:MouseEvent) : void
      {
         if(this.FOnDropListOut != null)
         {
            this.FOnDropListOut(this);
         }
      }
      
      protected function CloseList() : void
      {
         if(this.FListScrol != null)
         {
            this.FListScrol.Visible = false;
         }
      }
      
      protected function CheckInBox(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:Point = this.FScene.globalToLocal(new Point(param1,param2));
         if(!this.FScene.hitTestPoint(param1,param2))
         {
            return false;
         }
         return true;
      }
      
      protected function OnHideComboBoxList(param1:MouseEvent) : void
      {
         if(!this.CheckInBox(param1.stageX,param1.stageY))
         {
            this.CloseList();
         }
      }
      
      public function set SelectCallBack(param1:Function) : void
      {
         this.FSelectCallBack = param1;
      }
      
      public function get SelectCallBack() : Function
      {
         return this.FSelectCallBack;
      }
      
      public function get OnDropBarMove() : Function
      {
         return this.FOnDropBarMove;
      }
      
      public function set OnDropBarMove(param1:Function) : void
      {
         this.FOnDropBarMove = param1;
      }
      
      public function get OnDropListMove() : Function
      {
         return this.FOnDropListMove;
      }
      
      public function set OnDropListMove(param1:Function) : void
      {
         this.FOnDropListMove = param1;
      }
      
      public function get OnDropListOut() : Function
      {
         return this.FOnDropListOut;
      }
      
      public function set OnDropListOut(param1:Function) : void
      {
         this.FOnDropListOut = param1;
      }
      
      public function AddItem(param1:DisplayObject) : void
      {
         this.FShowList.push(param1);
         this.FListScrol.AddItem(param1);
         TGameUtil.setButtonMode(param1 as MovieClip,true);
         param1.addEventListener(MouseEvent.MOUSE_UP,this.OnSelectItem);
         param1["listIndex"] = this.FShowList.length - 1;
      }
      
      public function ResetList(param1:Vector.<DisplayObject>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         _loc2_ = 0;
         while(_loc2_ < this.FShowList.length)
         {
            _loc3_ = this.FShowList[_loc2_] as MovieClip;
            if(_loc3_.hasEventListener(MouseEvent.MOUSE_UP))
            {
               _loc3_.removeEventListener(MouseEvent.MOUSE_UP,this.OnSelectItem);
            }
            if(_loc3_.hasEventListener(MouseEvent.MOUSE_MOVE))
            {
               _loc3_.removeEventListener(MouseEvent.MOUSE_MOVE,this.DropListOnMove);
            }
            if(_loc3_.hasEventListener(MouseEvent.MOUSE_OUT))
            {
               _loc3_.removeEventListener(MouseEvent.MOUSE_OUT,this.DropListOnOut);
            }
            _loc2_++;
         }
         this.FListScrol.Clear();
         this.FShowList = param1;
         _loc2_ = 0;
         while(_loc2_ < this.FShowList.length)
         {
            _loc3_ = this.FShowList[_loc2_] as MovieClip;
            this.FListScrol.AddItem(_loc3_);
            TGameUtil.setButtonMode(_loc3_,true);
            _loc3_.addEventListener(MouseEvent.MOUSE_UP,this.OnSelectItem);
            _loc3_.addEventListener(MouseEvent.MOUSE_MOVE,this.DropListOnMove);
            _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this.DropListOnOut);
            this.FShowList[_loc2_]["listIndex"] = _loc2_;
            _loc2_++;
         }
         if(this.FShowList.length > 0 && this.FIsSelectFirstItem)
         {
            this.FShowList[0].dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
         }
      }
      
      public function SetChildSelectByDisplayObject(param1:DisplayObject) : void
      {
         if(param1 == null)
         {
            return;
         }
         param1.dispatchEvent(new Event(MouseEvent.MOUSE_UP));
      }
      
      public function SetChildSelectByIndex(param1:uint) : void
      {
         if(param1 >= this.FShowList.length)
         {
            return;
         }
         this.FShowList[param1].dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
      }
      
      public function SetInfo(param1:String) : void
      {
         this.FScene.mc_bar.tf_curInfo.text = param1;
      }
      
      public function SetCurInfoInput() : void
      {
         this.FScene.mc_bar.removeEventListener(MouseEvent.MOUSE_UP,this.OnShowListClick);
         this.FScene.mc_bar.btn_showlist.addEventListener(MouseEvent.MOUSE_UP,this.OnShowListClick);
         this.FScene.mc_bar.buttonMode = false;
         this.FScene.mc_bar.tf_curInfo.mouseEnabled = true;
      }
      
      public function HideComboBoxList() : void
      {
         this.CloseList();
      }
      
      public function SetBtnShowList(param1:Boolean) : void
      {
         if(param1)
         {
            TGameUtil.setButtonMode(this.FScene.mc_bar.btn_showlist,true);
            if(!this.FScene.mc_bar.hasEventListener(MouseEvent.MOUSE_UP))
            {
               this.FScene.mc_bar.addEventListener(MouseEvent.MOUSE_UP,this.OnShowListClick);
            }
         }
         else
         {
            TGameUtil.setButtonMode(this.FScene.mc_bar.btn_showlist,false);
            this.FScene.mc_bar.removeEventListener(MouseEvent.MOUSE_UP,this.OnShowListClick);
         }
      }
   }
}

