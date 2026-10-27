package Processors.Game.Lobby.TeamBattle.Room.Components
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.Textures.*;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Rooms.Seat.Player.*;
   import Processors.Game.Lobby.Components.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TUIPlayer extends TUIComponent
   {
      
      protected static const TIME_INTERVAL_CHAT_POP_PERIOD:int = 5000;
      
      protected static const CAPACITY_POPMENUS:uint = CONST_TEAMBATTLE.CAPACITY_POPMENUS;
      
      protected static const FRAME_TARGET_ONESELF:uint = 1;
      
      protected static const FRAME_TARGET_OTHER:uint = 2;
      
      protected static const INDEX_POPMENU_APPLY:uint = 0;
      
      protected static const INDEX_POPMENU_TRANSFER:uint = 1;
      
      protected static const INDEX_POPMENU_ADDFRIEND:uint = 2;
      
      protected static const INDEX_POPMENU_KICK:uint = 3;
      
      protected var FUIHero:TUIHero;
      
      protected var FSP_Chat:Sprite;
      
      protected var FTF_Chat:TextField;
      
      protected var FMC_TeamLeader:MovieClip;
      
      protected var FTF_Level:TextField;
      
      protected var FTF_Nickname:TextField;
      
      protected var FTF_FightingPower:TextField;
      
      protected var FMC_Tag:MovieClip;
      
      protected var FSP_Ready:Sprite;
      
      protected var FSP_HeroPosition:Sprite;
      
      protected var FMC_HighLight:MovieClip;
      
      protected var FSP_PopMenus:Vector.<Sprite>;
      
      protected var FBtn_Apply:TUIButton;
      
      protected var FBtn_Transfer:TUIButton;
      
      protected var FBtn_AddFriend:TUIButton;
      
      protected var FBtn_Kick:TUIButton;
      
      protected var FTickChatPop:int;
      
      protected var FResource:Sprite;
      
      protected var FContext:TPlayerRoomDigest;
      
      protected var FOnQuerySequenceContext:Function;
      
      protected var FOnApply:Function;
      
      protected var FOnTransfer:Function;
      
      protected var FOnAddFriend:Function;
      
      protected var FOnKick:Function;
      
      protected var FOnMove:Function;
      
      protected var FOnOut:Function;
      
      public function TUIPlayer(param1:TUIComponent)
      {
         super(param1);
         this.FUIHero = new TUIHero(null);
         this.FUIHero.OnQuerySequenceContext = this.HeroOnQuerySequenceContext;
      }
      
      protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:TBounds = null;
         var _loc4_:TCoordinate = null;
         if(this.FResource == null)
         {
            return;
         }
         this.FResource.mouseEnabled = false;
         this.FSP_Chat = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_SP_Chat];
         this.FTF_Chat = this.FSP_Chat[CONST_TEAMBATTLE.RESOURCE_Link_TF_Chat];
         this.FMC_TeamLeader = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_MC_TeamLeader];
         this.FMC_TeamLeader.stop();
         _loc2_ = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_SP_PlayerInfo];
         _loc2_.mouseEnabled = false;
         _loc2_.mouseChildren = false;
         this.FTF_Level = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_TF_Level];
         this.FTF_Nickname = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_TF_Nickname];
         this.FTF_FightingPower = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_TF_FightingPower];
         this.FMC_Tag = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_MC_Tag];
         this.FSP_Ready = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_SP_Ready];
         this.FSP_Ready.mouseEnabled = false;
         this.FSP_Ready.mouseChildren = false;
         _loc2_ = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_SP_HeroPosition];
         this.FSP_HeroPosition = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_SP_HeroPosition];
         this.FSP_HeroPosition.mouseChildren = false;
         this.FSP_HeroPosition.addChild(this.FUIHero);
         _loc3_ = new TBounds();
         _loc4_ = new TCoordinate();
         this.FUIHero.SequenceDefaultRole.Evaluate(_loc4_,_loc3_);
         this.FUIHero.X = _loc3_.X;
         this.FUIHero.Y = _loc3_.Y;
         this.FMC_HighLight = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_MC_HighLight];
         this.FSP_PopMenus = new Vector.<Sprite>(CAPACITY_POPMENUS);
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_POPMENUS)
         {
            _loc2_ = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_SP_PopMenu + _loc1_];
            _loc2_.mouseEnabled = false;
            switch(_loc1_)
            {
               case 0:
                  this.FBtn_Apply = new TUIButton();
                  this.FBtn_Apply.Substrate = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_Btn_Apply];
                  break;
               case 1:
                  this.FBtn_Transfer = new TUIButton();
                  this.FBtn_Transfer.Substrate = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_Btn_Transfer];
                  break;
               case 2:
                  this.FBtn_AddFriend = new TUIButton();
                  this.FBtn_AddFriend.Substrate = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_Btn_AddFriend];
                  break;
               case 3:
                  this.FBtn_Kick = new TUIButton();
                  this.FBtn_Kick.Substrate = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_Btn_Kick];
            }
            this.FSP_PopMenus[_loc1_] = _loc2_;
            _loc1_++;
         }
         this.Reset();
      }
      
      protected function addEventListenerPlayer() : void
      {
         if(this.FResource == null)
         {
            return;
         }
         this.FResource.mouseEnabled = true;
         this.FResource.mouseChildren = true;
         this.FResource.addEventListener(MouseEvent.MOUSE_MOVE,this.UIPlayerOnMove,false,0,true);
         this.FResource.addEventListener(MouseEvent.MOUSE_OUT,this.UIPlayerOnOut,false,0,true);
         this.FSP_HeroPosition.addEventListener(MouseEvent.CLICK,this.SP_HeroPositionOnClick,false,0,true);
         this.FSP_HeroPosition.addEventListener(MouseEvent.MOUSE_OVER,this.SP_HeroPositionOnOver,false,0,true);
         this.FSP_HeroPosition.addEventListener(MouseEvent.MOUSE_OUT,this.SP_HeroPositionOnOut,false,0,true);
         this.FBtn_Apply.OnClick = this.Btn_ApplyOnClick;
         this.FBtn_Transfer.OnClick = this.Btn_TransferOnClick;
         this.FBtn_AddFriend.OnClick = this.Btn_AddFriendOnClick;
         this.FBtn_Kick.OnClick = this.Btn_KickOnClick;
      }
      
      protected function RemoveEventListenerPlayer() : void
      {
         if(this.FResource == null)
         {
            return;
         }
         this.FResource.mouseEnabled = false;
         this.FResource.mouseChildren = false;
         this.FSP_HeroPosition.removeEventListener(MouseEvent.CLICK,this.SP_HeroPositionOnClick);
         this.FSP_HeroPosition.removeEventListener(MouseEvent.MOUSE_OVER,this.SP_HeroPositionOnOver);
         this.FSP_HeroPosition.removeEventListener(MouseEvent.MOUSE_OUT,this.SP_HeroPositionOnOut);
         this.FBtn_Apply.OnClick = this.Btn_ApplyOnClick;
         this.FBtn_Transfer.OnClick = this.Btn_TransferOnClick;
         this.FBtn_AddFriend.OnClick = this.Btn_AddFriendOnClick;
         this.FBtn_Kick.OnClick = this.Btn_KickOnClick;
      }
      
      protected function UpdateUIPlayer() : void
      {
         var _loc1_:MovieClip = null;
         if(this.FResource == null)
         {
            return;
         }
         this.FMC_Tag.visible = true;
         this.FMC_HighLight.visible = true;
         if(this.FContext.SeatIndex == this.FContext.OneselfSeatIndex)
         {
            this.FMC_Tag.gotoAndStop(FRAME_TARGET_ONESELF);
            this.FMC_HighLight.gotoAndStop(FRAME_TARGET_ONESELF);
         }
         else
         {
            this.FMC_Tag.gotoAndStop(FRAME_TARGET_OTHER);
            _loc1_ = this.FMC_HighLight[CONST_TEAMBATTLE.RESOURCE_Link_MC_SeatType];
            _loc1_.gotoAndStop(FRAME_TARGET_OTHER);
         }
         if(this.FContext.SeatIndex == this.FContext.RoomOwnerIndex)
         {
            if(!this.FMC_TeamLeader.isPlaying)
            {
               this.FMC_TeamLeader.play();
            }
            this.FMC_TeamLeader.visible = true;
         }
         this.FTF_Level.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_14),this.FContext.Level);
         this.FTF_Nickname.text = this.FContext.Nickname;
         this.FTF_FightingPower.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_15),this.FContext.FightingPower);
         this.FSP_Ready.visible = this.FContext.Ready;
      }
      
      protected function SP_HeroPositionOnOver(param1:MouseEvent) : void
      {
         this.FMC_HighLight.gotoAndStop(2);
      }
      
      protected function SP_HeroPositionOnOut(param1:MouseEvent) : void
      {
         this.FMC_HighLight.gotoAndStop(1);
      }
      
      protected function UIPlayerOnMove(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(this.FContext.OneselfSeatIndex == this.FContext.SeatIndex)
         {
            return;
         }
         _loc2_ = 0;
         while(_loc2_ < CAPACITY_POPMENUS)
         {
            if(this.FSP_PopMenus[_loc2_].visible)
            {
               return;
            }
            _loc2_++;
         }
         if(this.FOnMove != null)
         {
            this.FOnMove(this,this.FContext);
         }
      }
      
      protected function UIPlayerOnOut(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(this.FContext == null)
         {
            return;
         }
         if(this.FContext.OneselfSeatIndex == this.FContext.SeatIndex)
         {
            return;
         }
         if(this.FOnOut != null)
         {
            this.FOnOut(this,this.FContext);
         }
      }
      
      protected function SP_HeroPositionOnClick(param1:MouseEvent) : void
      {
         if(this.FContext.OneselfSeatIndex == this.FContext.RoomOwnerIndex)
         {
            if(this.FContext.SeatIndex != this.FContext.OneselfSeatIndex)
            {
               this.FSP_PopMenus[INDEX_POPMENU_TRANSFER].visible = !this.FSP_PopMenus[INDEX_POPMENU_TRANSFER].visible;
               this.FSP_PopMenus[INDEX_POPMENU_ADDFRIEND].visible = !this.FSP_PopMenus[INDEX_POPMENU_ADDFRIEND].visible;
               this.FSP_PopMenus[INDEX_POPMENU_KICK].visible = !this.FSP_PopMenus[INDEX_POPMENU_KICK].visible;
            }
         }
         else if(this.FContext.SeatIndex == this.FContext.RoomOwnerIndex)
         {
            this.FSP_PopMenus[INDEX_POPMENU_APPLY].visible = !this.FSP_PopMenus[INDEX_POPMENU_APPLY].visible;
            this.FSP_PopMenus[INDEX_POPMENU_ADDFRIEND].visible = !this.FSP_PopMenus[INDEX_POPMENU_ADDFRIEND].visible;
         }
         else if(this.FContext.SeatIndex != this.FContext.OneselfSeatIndex)
         {
            this.FSP_PopMenus[INDEX_POPMENU_ADDFRIEND].visible = !this.FSP_PopMenus[INDEX_POPMENU_ADDFRIEND].visible;
         }
         this.UIPlayerOnOut(null);
      }
      
      protected function Btn_ApplyOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnApply != null)
         {
            this.FOnApply(this,this.FContext);
         }
      }
      
      protected function Btn_TransferOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnTransfer != null)
         {
            this.FOnTransfer(this,this.FContext);
         }
      }
      
      protected function Btn_AddFriendOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnAddFriend != null)
         {
            this.FOnAddFriend(this,this.FContext);
         }
      }
      
      protected function Btn_KickOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnKick != null)
         {
            this.FOnKick(this,this.FContext);
         }
      }
      
      protected function HeroOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TBounds = null;
         var _loc6_:TCoordinate = null;
         if(this.FOnQuerySequenceContext != null)
         {
            this.FOnQuerySequenceContext(param1,param2,param3,param4);
            if(param3.Value != null)
            {
               _loc5_ = new TBounds();
               _loc6_ = new TCoordinate();
               param3.Value.Evaluate(_loc6_,_loc5_);
               this.FUIHero.X = _loc5_.X;
               this.FUIHero.Y = _loc5_.Y;
            }
         }
      }
      
      public function get Resource() : Sprite
      {
         return this.FResource;
      }
      
      public function set Resource(param1:Sprite) : void
      {
         this.FResource = param1;
      }
      
      public function get Context() : TPlayerRoomDigest
      {
         return this.FContext;
      }
      
      public function set Context(param1:TPlayerRoomDigest) : void
      {
         this.Reset();
         if(this.FContext == null && param1 != null)
         {
            this.addEventListenerPlayer();
         }
         else if(param1 == null)
         {
            this.RemoveEventListenerPlayer();
         }
         this.FContext = param1;
         this.FUIHero.Context = param1;
         if(param1 != null)
         {
            this.UpdateUIPlayer();
         }
      }
      
      public function get OnQuerySequenceContext() : Function
      {
         return this.FOnQuerySequenceContext;
      }
      
      public function set OnQuerySequenceContext(param1:Function) : void
      {
         this.FOnQuerySequenceContext = param1;
      }
      
      public function get SequenceDefaultRole() : TAnimationSequence
      {
         return this.FUIHero.SequenceDefaultRole;
      }
      
      public function set SequenceDefaultRole(param1:TAnimationSequence) : void
      {
         if(param1 != null)
         {
            this.FUIHero.SequenceDefaultRole = param1;
         }
      }
      
      public function get OnApply() : Function
      {
         return this.FOnApply;
      }
      
      public function set OnApply(param1:Function) : void
      {
         this.FOnApply = param1;
      }
      
      public function get OnTransfer() : Function
      {
         return this.FOnTransfer;
      }
      
      public function set OnTransfer(param1:Function) : void
      {
         this.FOnTransfer = param1;
      }
      
      public function get OnAddFriend() : Function
      {
         return this.FOnAddFriend;
      }
      
      public function set OnAddFriend(param1:Function) : void
      {
         this.FOnAddFriend = param1;
      }
      
      public function get OnKick() : Function
      {
         return this.FOnKick;
      }
      
      public function set OnKick(param1:Function) : void
      {
         this.FOnKick = param1;
      }
      
      public function get OnMove() : Function
      {
         return this.FOnMove;
      }
      
      public function set OnMove(param1:Function) : void
      {
         this.FOnMove = param1;
      }
      
      public function get OnOut() : Function
      {
         return this.FOnOut;
      }
      
      public function set OnOut(param1:Function) : void
      {
         this.FOnOut = param1;
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         if(this.FResource != null)
         {
            this.FResource.visible = param1;
         }
      }
      
      public function Perform_UIDispatch() : void
      {
         this.ResourcesPerform_UIDispatch();
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         if(this.FResource == null)
         {
            return;
         }
         this.FTickChatPop = 0;
         this.FTF_Level.text = "";
         this.FTF_Nickname.text = "";
         this.FTF_FightingPower.text = "";
         this.FTF_Chat.text = "";
         this.FSP_Ready.visible = false;
         this.FMC_Tag.visible = false;
         this.FMC_HighLight.visible = false;
         this.FSP_Chat.visible = false;
         if(this.FMC_TeamLeader.isPlaying)
         {
            this.FMC_TeamLeader.stop();
         }
         this.FMC_TeamLeader.visible = false;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_POPMENUS)
         {
            this.FSP_PopMenus[_loc1_].visible = false;
            _loc1_++;
         }
      }
      
      public function Update() : void
      {
         var _loc1_:int = 0;
         if(this.FSP_Chat.visible)
         {
            _loc1_ = int(STimingCore.TickCount);
            if(_loc1_ - this.FTickChatPop >= TIME_INTERVAL_CHAT_POP_PERIOD)
            {
               this.SetChatPop("");
               this.FTickChatPop = _loc1_;
            }
         }
         this.FUIHero.Update();
      }
      
      public function SetChatPop(param1:String) : void
      {
         if(!TUtilityString.Empty(param1))
         {
            this.FTickChatPop = STimingCore.TickCount;
            this.FTF_Chat.text = param1;
            this.FSP_Chat.visible = true;
         }
         else
         {
            this.FTickChatPop = 0;
            this.FTF_Chat.text = param1;
            this.FSP_Chat.visible = false;
         }
      }
   }
}

