package Processors.Game.Lobby.HeroCompanion.CardEmploy
{
   import Logics.DatebaseVO.VO.TCompanionCard;
   import Logics.HeroCompanion.THeroCompanionData;
   import Processors.Game.Common.Effects.ListAutoScroll.TListAutoScroll;
   import Processors.Game.Lobby.HeroCompanion.Components.TCompanionCardItem;
   import Resources.Constants.CONST_HEROCOMPANION;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TCompanionEmployCardScroll
   {
      
      protected static const Card_Num:int = CONST_HEROCOMPANION.Scroll_Card_Num;
      
      protected static const Card_Space:int = CONST_HEROCOMPANION.Scroll_Card_Space;
      
      protected var FCardVec:Vector.<TCompanionCardItem>;
      
      protected var FMainUI:Sprite;
      
      protected var FAutoScroll:TListAutoScroll;
      
      protected var FIsMouseOver:Boolean;
      
      protected var FScrollOnOver:Function;
      
      protected var FScrollOnOut:Function;
      
      public function TCompanionEmployCardScroll(param1:Sprite)
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TCompanionCardItem = null;
         super();
         this.FMainUI = param1;
         this.FCardVec = new Vector.<TCompanionCardItem>();
         _loc2_ = 0;
         while(_loc2_ < Card_Num)
         {
            _loc4_ = new TCompanionCardItem(this.FMainUI["MC_Card_" + _loc2_]);
            _loc4_.ItemOnMove = this.ItemOnMove;
            _loc4_.ItemOnOut = this.ItemOnOut;
            this.FCardVec.push(_loc4_);
            _loc2_++;
         }
         this.FMainUI.addEventListener(MouseEvent.MOUSE_OVER,this.CardOnOver);
         this.FMainUI.addEventListener(MouseEvent.MOUSE_OUT,this.CardOnOut);
      }
      
      private function CardOnOver(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         if(!this.FIsMouseOver)
         {
            this.FAutoScroll.IsPause = true;
         }
         this.FIsMouseOver = true;
      }
      
      private function CardOnOut(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         if(this.FIsMouseOver)
         {
            this.FAutoScroll.IsPause = false;
         }
         this.FIsMouseOver = false;
      }
      
      protected function ItemOnMove(param1:Object, param2:MouseEvent) : void
      {
         if(this.FScrollOnOver != null)
         {
            this.FScrollOnOver(param1,param2);
         }
      }
      
      protected function ItemOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FScrollOnOut != null)
         {
            this.FScrollOnOut(param1,param2);
         }
      }
      
      public function get ScrollOnOver() : Function
      {
         return this.FScrollOnOver;
      }
      
      public function set ScrollOnOver(param1:Function) : void
      {
         this.FScrollOnOver = param1;
      }
      
      public function get ScrollOnOut() : Function
      {
         return this.FScrollOnOut;
      }
      
      public function set ScrollOnOut(param1:Function) : void
      {
         this.FScrollOnOut = param1;
      }
      
      public function InitScroll(param1:THeroCompanionData) : void
      {
         var _loc2_:Vector.<TCompanionCard> = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc2_ = new Vector.<TCompanionCard>();
         _loc4_ = param1.CardDatas.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_.push(param1.CardDatas.GetCardByIndex(_loc3_).GetDisplayCard());
            _loc3_++;
         }
         this.FAutoScroll = new TListAutoScroll();
         this.FAutoScroll.ListCount = Card_Num;
         this.FAutoScroll.ListSpace = Card_Space;
         this.FAutoScroll.SetListData(this.FCardVec,_loc2_);
         this.FAutoScroll.Init();
      }
      
      public function StartScroll() : void
      {
         if(this.FAutoScroll != null)
         {
            if(!this.FAutoScroll.IsPause)
            {
               this.FAutoScroll.StartMove();
            }
         }
      }
   }
}

