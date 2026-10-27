package Processors.Game.Lobby.HellButterfly
{
   import Components.Pages.*;
   import Components.Standard.*;
   import Foundation.UI.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.Organization.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.HellButterfly.Component.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorButterflyFriend extends TProcessorLobbyWindow
   {
      
      protected static const FRIEND_NUM:uint = 10;
      
      protected static const EAT_ONCE:uint = 0;
      
      protected static const EAT_FRIEND:uint = 1;
      
      protected static const EAT_FAMILY:uint = 2;
      
      protected static const SELECT_FRIEND:uint = 1;
      
      protected static const SELECT_FAMILY:uint = 2;
      
      protected var FScence:Sprite;
      
      protected var FMC_Clan:MovieClip;
      
      protected var FTF_Limit:TextField;
      
      protected var FMC_BatchSend:TUIButton;
      
      protected var FFriendList:Vector.<TUIFriendList>;
      
      protected var FUIPage:TUIPage;
      
      protected var FPageIndex:uint;
      
      protected var FAllFriendDigests:TFriendDigests;
      
      protected var FSameOrganizationFriendDigests:TFriendDigests;
      
      protected var FCharacter:TCharacter;
      
      protected var FIsSameCountry:Boolean;
      
      protected var FOnEnterFriend:Function;
      
      protected var FOnBatchEat:Function;
      
      protected var FOnBatchMove:Function;
      
      protected var FOnBatchOut:Function;
      
      public function TProcessorButterflyFriend(param1:TUIComponent)
      {
         super(param1);
         this.FFriendList = new Vector.<TUIFriendList>(FRIEND_NUM);
         this.FSameOrganizationFriendDigests = new TFriendDigests();
         this.FCharacter = SLogicsCore.Character;
      }
      
      private function ButterflyFriendInit() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:TextField = null;
         var _loc3_:TUIFriendList = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:MovieClip = null;
         this.FUIPage = new TUIPage(this);
         _loc1_ = this.FScence["MC_PageLeft"];
         this.FUIPage.ButtonPrevious.Substrate = _loc1_;
         _loc1_ = this.FScence["MC_PageRight"];
         this.FUIPage.ButtonNext.Substrate = _loc1_;
         _loc2_ = this.FScence["TF_Page"];
         this.FUIPage.LabelPage = _loc2_;
         this.FUIPage.PageSize = FRIEND_NUM;
         this.FUIPage.OnChangePage = this.PageOnChange;
         this.FUIPage.Init();
         this.FMC_BatchSend = new TUIButton();
         this.FMC_BatchSend.Substrate = this.FScence["MC_BatchSend"];
         this.FMC_BatchSend.Hint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_22);
         this.FMC_BatchSend.OnMove = this.FOnBatchMove;
         this.FMC_BatchSend.OnOut = this.FOnBatchOut;
         this.FMC_BatchSend.OnClick = this.ClickOnBatchSend;
         _loc5_ = FRIEND_NUM;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc3_ = new TUIFriendList(this);
            _loc6_ = this.FScence["MC_Friend_" + _loc4_];
            _loc3_.Tag = _loc4_;
            _loc3_.Perform_UIDispatch(_loc6_);
            _loc3_.EnterFriend = this.EnterFriend;
            _loc3_.Init();
            this.FFriendList[_loc4_] = _loc3_;
            _loc4_++;
         }
         this.FMC_Clan = this.FScence["MC_Clan"];
         this.FTF_Limit = this.FScence["TF_Limit"];
         this.FTF_Limit.mouseEnabled = false;
         this.FMC_Clan.addEventListener(MouseEvent.CLICK,this.ClickOnSameCountry);
      }
      
      private function EnterFriend(param1:TFriendDigest, param2:Object) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = 0;
         while(_loc3_ < FRIEND_NUM)
         {
            this.FFriendList[_loc3_].FListitem.gotoAndStop(TUIFriendList.FRAME_NORMAL);
            this.FFriendList[_loc3_].FBClick = false;
            _loc3_++;
         }
         if(this.FOnEnterFriend != null)
         {
            this.FOnEnterFriend(param1.Identifier0,param1.Identifier1);
         }
      }
      
      protected function PageOnChange(param1:Object, param2:int) : void
      {
         this.FPageIndex = param2;
         if(this.FIsSameCountry)
         {
            this.UpdateListItemFriendDigests(this.FSameOrganizationFriendDigests,this.FFriendList);
         }
         else
         {
            this.UpdateListItemFriendDigests(this.FAllFriendDigests,this.FFriendList);
         }
      }
      
      protected function UpdateListFriends(param1:TFriendDigests) : void
      {
         this.FUIPage.TotalQuantity = param1.Count;
         this.FUIPage.PageIndex = this.FPageIndex;
         this.FUIPage.Update();
         this.UpdateListItemFriendDigests(param1,this.FFriendList);
      }
      
      protected function UpdateListItemFriendDigests(param1:TFriendDigests, param2:Vector.<TUIFriendList>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TUIFriendList = null;
         var _loc8_:TFriendDigest = null;
         _loc5_ = int(this.FPageIndex);
         _loc4_ = int(FRIEND_NUM);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc7_ = param2[_loc3_];
            _loc7_.SetVisible(false);
            _loc7_.FBClick = false;
            _loc7_.HightLight = TUIFriendList.FRAME_NORMAL;
            _loc3_++;
         }
         _loc4_ = param1.Count;
         if(_loc4_ <= 0)
         {
            return;
         }
         _loc6_ = _loc5_ * FRIEND_NUM;
         _loc3_ = 0;
         while(_loc3_ < FRIEND_NUM)
         {
            if(_loc3_ + _loc6_ >= _loc4_)
            {
               break;
            }
            _loc7_ = param2[_loc3_];
            _loc8_ = param1.GetDigestByIndex(_loc3_ + _loc6_);
            _loc7_.Context = _loc8_;
            _loc7_.SetSendGood(!_loc8_.SendGoodOrNot);
            _loc7_.SetVisible(true);
            if(!SLogicsCore.HellButterfly.IsMyself)
            {
               if(_loc8_.Identifier0 == SLogicsCore.HellButterfly.NowIdentifier0 && _loc8_.Identifier1 == SLogicsCore.HellButterfly.NowIdentifier1)
               {
                  _loc7_.FBClick = true;
                  _loc7_.HightLight = TUIFriendList.FRAME_SELECT;
               }
            }
            _loc3_++;
         }
      }
      
      private function SetSameOrganizationFriends() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TFriendDigest = null;
         var _loc4_:TBaseOrganizationMember = null;
         this.FSameOrganizationFriendDigests.Clear();
         if(SLogicsCore.Organization.OrgId == 0)
         {
            return;
         }
         _loc2_ = uint(this.FAllFriendDigests.Count);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FAllFriendDigests.GetDigestByIndex(_loc1_);
            _loc4_ = SLogicsCore.Organization.OrgMemberList.GetOrgMemberByIdentifier(_loc3_.Identifier0,_loc3_.Identifier1);
            if(_loc4_ != null)
            {
               this.FSameOrganizationFriendDigests.Add(_loc3_);
            }
            _loc1_++;
         }
         this.FSameOrganizationFriendDigests.SortLevel();
      }
      
      private function SetBatchBT() : void
      {
         if(this.FCharacter.VipData.OneWater)
         {
            this.FMC_BatchSend.Enabled = true;
            this.FTF_Limit.visible = false;
         }
         else
         {
            this.FMC_BatchSend.Enabled = false;
            this.FTF_Limit.visible = true;
         }
         this.FIsSameCountry = false;
         this.FMC_Clan.gotoAndStop(SELECT_FRIEND);
      }
      
      private function UpdateListEat(param1:uint) : void
      {
         switch(param1)
         {
            case EAT_ONCE:
            case EAT_FRIEND:
               if(this.FIsSameCountry)
               {
                  this.UpdateListFriends(this.FSameOrganizationFriendDigests);
               }
               else
               {
                  this.UpdateListFriends(this.FAllFriendDigests);
               }
               break;
            case EAT_FAMILY:
               this.UpdateListFriends(this.FSameOrganizationFriendDigests);
         }
      }
      
      private function CanBatch(param1:TFriendDigests) : Boolean
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TFriendDigest = null;
         _loc3_ = uint(param1.Count);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.GetDigestByIndex(_loc2_);
            if(!_loc4_.SendGoodOrNot)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function ClickOnBatchSend(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         if(this.FIsSameCountry)
         {
            if(this.FSameOrganizationFriendDigests.Count == 0)
            {
               EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_18));
               return;
            }
            if(!this.CanBatch(this.FSameOrganizationFriendDigests))
            {
               EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_20));
               return;
            }
            _loc3_ = EAT_FAMILY;
         }
         else
         {
            if(this.FAllFriendDigests.Count == 0)
            {
               EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_19));
               return;
            }
            if(!this.CanBatch(this.FAllFriendDigests))
            {
               EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_20));
               return;
            }
            _loc3_ = EAT_FRIEND;
         }
         if(this.FOnBatchEat != null)
         {
            this.FOnBatchEat(_loc3_,0,0);
         }
      }
      
      private function ClickOnSameCountry(param1:MouseEvent) : void
      {
         this.FIsSameCountry = !this.FIsSameCountry;
         this.FPageIndex = 0;
         if(this.FIsSameCountry)
         {
            this.FMC_Clan.gotoAndStop(SELECT_FAMILY);
            this.UpdateListFriends(this.FSameOrganizationFriendDigests);
         }
         else
         {
            this.FMC_Clan.gotoAndStop(SELECT_FRIEND);
            this.UpdateListFriends(this.FAllFriendDigests);
         }
      }
      
      public function get OnEnterFriend() : Function
      {
         return this.FOnEnterFriend;
      }
      
      public function set OnEnterFriend(param1:Function) : void
      {
         this.FOnEnterFriend = param1;
      }
      
      public function get OnBatchEat() : Function
      {
         return this.FOnBatchEat;
      }
      
      public function set OnBatchEat(param1:Function) : void
      {
         this.FOnBatchEat = param1;
      }
      
      public function get Scence() : Sprite
      {
         return this.FScence;
      }
      
      public function set Scence(param1:Sprite) : void
      {
         this.FScence = param1;
      }
      
      public function get SameOrganizationFriendDigests() : TFriendDigests
      {
         return this.FSameOrganizationFriendDigests;
      }
      
      public function get OnBatchMove() : Function
      {
         return this.FOnBatchMove;
      }
      
      public function set OnBatchMove(param1:Function) : void
      {
         this.FOnBatchMove = param1;
      }
      
      public function get OnBatchOut() : Function
      {
         return this.FOnBatchOut;
      }
      
      public function set OnBatchOut(param1:Function) : void
      {
         this.FOnBatchOut = param1;
      }
      
      public function FriendInit(param1:Sprite) : void
      {
         this.FScence = param1;
         this.ButterflyFriendInit();
         this.FriendReset();
      }
      
      public function FriendReset() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         this.FSameOrganizationFriendDigests.Clear();
         _loc2_ = FRIEND_NUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FFriendList[_loc1_].SetVisible(false);
            _loc1_++;
         }
      }
      
      public function FriendUpdate(param1:TFriendDigests) : void
      {
         this.FAllFriendDigests = param1;
         if(param1.Count != 0)
         {
            this.SetSameOrganizationFriends();
         }
         this.FPageIndex = 0;
         this.UpdateListFriends(param1);
         this.SetBatchBT();
      }
      
      public function ResetList() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < FRIEND_NUM)
         {
            this.FFriendList[_loc1_].FListitem.gotoAndStop(TUIFriendList.FRAME_NORMAL);
            this.FFriendList[_loc1_].FBClick = false;
            _loc1_++;
         }
      }
      
      public function UpdateEat(param1:uint) : void
      {
         this.UpdateListEat(param1);
      }
   }
}

