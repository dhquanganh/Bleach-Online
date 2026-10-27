package Processors.Game.Lobby.Activity.HDRushInSeireitei.components
{
   import Components.Standard.TUIButton;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudle;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TItemRushInSeireitei
   {
      
      protected static const Can_Get:int = 1;
      
      protected static const CanNot_Get:int = 0;
      
      protected static const Has_Get:int = -1;
      
      protected var FMainUI:Sprite;
      
      protected var FIcon:Sprite;
      
      protected var FGiftBtn:TUIButton;
      
      protected var FFlagBtn:TUIButton;
      
      protected var FRoleMoudle:TSceneSpriteMoudle;
      
      protected var FGiftStatus:int;
      
      protected var FRole:int;
      
      protected var FHp:int;
      
      protected var FTargetIndex:int;
      
      protected var FVisible:Boolean;
      
      protected var FOnOver:Function;
      
      protected var FOnOut:Function;
      
      protected var FOnClick:Function;
      
      protected var FRoleOnOver:Function;
      
      protected var FRoleOnOut:Function;
      
      protected var FRoleOnClick:Function;
      
      protected var FRoleEnabled:Boolean;
      
      public function TItemRushInSeireitei()
      {
         super();
      }
      
      protected function GiftOnMove(param1:Object, param2:MouseEvent) : void
      {
         this.FOnOver(param1,this.FTargetIndex);
      }
      
      protected function GiftOnOut(param1:Object, param2:MouseEvent) : void
      {
         this.FOnOut(param1);
      }
      
      protected function GiftOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FOnClick(param1,this.FTargetIndex);
      }
      
      protected function FlagOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.RoleMoudleOnClick(param2);
      }
      
      protected function FlagOnMove(param1:Object, param2:MouseEvent) : void
      {
         this.FRoleOnOver(this);
      }
      
      protected function FlagOnOut(param1:Object, param2:MouseEvent) : void
      {
         this.FRoleOnOut(this);
      }
      
      protected function RoleMoudleOnOver(param1:MouseEvent) : void
      {
         this.FOnOver(this,this.FTargetIndex);
      }
      
      protected function RoleMoudleOnOut(param1:MouseEvent) : void
      {
         this.FOnOut(this);
      }
      
      protected function RoleMoudleOnClick(param1:MouseEvent) : void
      {
         if(this.FFlagBtn.Visible)
         {
            this.FRoleOnClick(this);
         }
      }
      
      protected function InvisibleAll() : void
      {
         this.FIcon.visible = false;
         this.FGiftBtn.Visible = false;
         this.FFlagBtn.Visible = false;
         this.FRoleMoudle.visible = false;
      }
      
      public function get GiftStatus() : int
      {
         return this.FGiftStatus;
      }
      
      public function set GiftStatus(param1:int) : void
      {
         this.FGiftStatus = param1;
         if(this.FGiftStatus == Has_Get)
         {
            this.InvisibleAll();
            this.FGiftBtn.Visible = true;
            this.FIcon.visible = true;
         }
         else if(this.FGiftStatus != CanNot_Get)
         {
            this.InvisibleAll();
            this.FGiftBtn.Visible = true;
         }
      }
      
      public function get Role() : int
      {
         return this.FRole;
      }
      
      public function set Role(param1:int) : void
      {
         this.FRole = param1;
         this.FRoleMoudle.ChangeRoleMoudle(this.FRole,1);
         this.InvisibleAll();
         this.FRoleMoudle.visible = true;
         this.FFlagBtn.Visible = true;
      }
      
      public function get OnOver() : Function
      {
         return this.FOnOver;
      }
      
      public function set OnOver(param1:Function) : void
      {
         this.FOnOver = param1;
      }
      
      public function get OnOut() : Function
      {
         return this.FOnOut;
      }
      
      public function set OnOut(param1:Function) : void
      {
         this.FOnOut = param1;
      }
      
      public function get OnClick() : Function
      {
         return this.FOnClick;
      }
      
      public function set OnClick(param1:Function) : void
      {
         this.FOnClick = param1;
      }
      
      public function get TargetIndex() : int
      {
         return this.FTargetIndex;
      }
      
      public function set TargetIndex(param1:int) : void
      {
         this.FTargetIndex = param1;
      }
      
      public function get RoleOnOver() : Function
      {
         return this.FRoleOnOver;
      }
      
      public function set RoleOnOver(param1:Function) : void
      {
         this.FRoleOnOver = param1;
      }
      
      public function get RoleOnOut() : Function
      {
         return this.FRoleOnOut;
      }
      
      public function set RoleOnOut(param1:Function) : void
      {
         this.FRoleOnOut = param1;
      }
      
      public function get RoleOnClick() : Function
      {
         return this.FRoleOnClick;
      }
      
      public function set RoleOnClick(param1:Function) : void
      {
         this.FRoleOnClick = param1;
      }
      
      public function get Hp() : int
      {
         return this.FHp;
      }
      
      public function set Hp(param1:int) : void
      {
         this.FHp = param1;
      }
      
      public function get Visible() : Boolean
      {
         return this.FVisible;
      }
      
      public function set Visible(param1:Boolean) : void
      {
         this.FVisible = param1;
         this.FMainUI.visible = this.FVisible;
      }
      
      public function get Context() : Sprite
      {
         return this.FMainUI;
      }
      
      public function get RoleEnabled() : Boolean
      {
         return this.FRoleEnabled;
      }
      
      public function set RoleEnabled(param1:Boolean) : void
      {
         this.FRoleEnabled = param1;
         this.FRoleMoudle.mouseChildren = this.FRoleEnabled;
         this.FRoleMoudle.mouseEnabled = this.FRoleEnabled;
      }
      
      public function get ShowFlag() : Boolean
      {
         return this.FFlagBtn.Visible;
      }
      
      public function set ShowFlag(param1:Boolean) : void
      {
         this.FFlagBtn.Visible = param1;
      }
      
      public function InitView(param1:Sprite) : void
      {
         var _loc2_:Sprite = null;
         this.FMainUI = param1;
         _loc2_ = this.FMainUI["MC_Enemy"];
         this.FIcon = _loc2_["MC_Icon"];
         this.FIcon.mouseChildren = false;
         this.FIcon.mouseEnabled = false;
         this.FGiftBtn = new TUIButton();
         this.FGiftBtn.Substrate = _loc2_["MC_Gift"];
         this.FGiftBtn.OnMove = this.GiftOnMove;
         this.FGiftBtn.OnOut = this.GiftOnOut;
         this.FGiftBtn.OnClick = this.GiftOnClick;
         this.FFlagBtn = new TUIButton();
         this.FFlagBtn.Substrate = _loc2_["MC_Flag"];
         this.FFlagBtn.OnClick = this.FlagOnClick;
         this.FFlagBtn.OnMove = this.FlagOnMove;
         this.FFlagBtn.OnOut = this.FlagOnOut;
         this.FRoleMoudle = new TSceneSpriteMoudle();
         _loc2_["MC_Head"].addChild(this.FRoleMoudle);
         this.FRoleMoudle.buttonMode = true;
         this.FRoleMoudle.addEventListener(MouseEvent.MOUSE_MOVE,this.RoleMoudleOnOver);
         this.FRoleMoudle.addEventListener(MouseEvent.MOUSE_OUT,this.RoleMoudleOnOut);
         this.FRoleMoudle.addEventListener(MouseEvent.CLICK,this.RoleMoudleOnClick);
         this.FIcon.visible = false;
         this.FGiftBtn.Visible = false;
      }
      
      public function Update() : void
      {
         if(this.FRoleMoudle.TextrueID != 0)
         {
            this.FRoleMoudle.UpdateView();
         }
      }
   }
}

