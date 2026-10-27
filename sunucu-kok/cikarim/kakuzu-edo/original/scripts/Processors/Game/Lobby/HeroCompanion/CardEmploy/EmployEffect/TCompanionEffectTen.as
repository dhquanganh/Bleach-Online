package Processors.Game.Lobby.HeroCompanion.CardEmploy.EmployEffect
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.TCompanionCard;
   import Logics.HeroCompanion.THeroCompanionChipData;
   import Processors.Game.Lobby.HeroCompanion.CardEmploy.EmployEffect.EffectMove.*;
   import Processors.Game.Lobby.HeroCompanion.Components.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import flash.display.MovieClip;
   
   public class TCompanionEffectTen extends TCompanionBaseEffect
   {
      
      protected static const Animation_Duration:int = CONST_HEROCOMPANION.Animation_Duration;
      
      protected var FRewardVec:Vector.<TCompanionEmployItem>;
      
      protected var FOwnCard:Vector.<int>;
      
      protected var FIsPlay:Boolean;
      
      protected var FRandoms:Vector.<int>;
      
      protected var FCardsX:Vector.<int>;
      
      protected var FCardsY:Vector.<int>;
      
      protected var FCardBackMoves:Vector.<TCompanionMoveBase>;
      
      protected var FChipBackMoves:Vector.<TCompanionMoveBase>;
      
      protected var FMovements:Vector.<TCompanionMoveBase>;
      
      protected var FCurrentAppearCardNum:int;
      
      public function TCompanionEffectTen()
      {
         super();
         this.FRewardVec = new Vector.<TCompanionEmployItem>();
         this.FOwnCard = new Vector.<int>();
         this.FRandoms = new Vector.<int>();
         this.FCardsX = new Vector.<int>();
         this.FCardsY = new Vector.<int>();
         this.FMovements = new Vector.<TCompanionMoveBase>();
         this.FCardBackMoves = new Vector.<TCompanionMoveBase>();
         this.FChipBackMoves = new Vector.<TCompanionMoveBase>();
      }
      
      protected function GetCardMove() : TCompanionMoveBase
      {
         var _loc1_:TCompanionMoveCard = null;
         if(this.FCardBackMoves.length <= 0)
         {
            _loc1_ = new TCompanionMoveCard();
            _loc1_.OnSpecialShowEnd = this.OnCardShowEnd;
            _loc1_.Effect = FEffect;
            return _loc1_;
         }
         return this.FCardBackMoves.pop();
      }
      
      protected function GetChipMove() : TCompanionMoveBase
      {
         var _loc1_:TCompanionMoveChip = null;
         if(this.FChipBackMoves.length <= 0)
         {
            _loc1_ = new TCompanionMoveChip();
            _loc1_.OnSpecialShowEnd = this.OnCardShowEnd;
            return _loc1_;
         }
         return this.FChipBackMoves.pop();
      }
      
      protected function ClearMoves() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FMovements.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FMovements[_loc1_] is TCompanionMoveCard)
            {
               this.FCardBackMoves.push(this.FMovements[_loc1_]);
            }
            else
            {
               this.FChipBackMoves.push(this.FMovements[_loc1_]);
            }
            _loc1_++;
         }
         this.FMovements.length = 0;
         this.FMovements.length = CONST_HEROCOMPANION.Employ_Count;
      }
      
      protected function OnCardShowEnd(param1:Object) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FMovements.indexOf(param1 as TCompanionMoveBase);
         this.FRewardVec[_loc2_].Substrate.alpha = 1;
         if(_loc2_ + 1 == this.FMovements.length)
         {
            return;
         }
         if(this.FRewardVec[this.FCurrentAppearCardNum].Type > 0)
         {
            this.FRewardVec[this.FCurrentAppearCardNum].Substrate.x = this.FCardsX[this.FCurrentAppearCardNum];
            this.FRewardVec[this.FCurrentAppearCardNum].Substrate.y = this.FCardsY[this.FCurrentAppearCardNum];
            FCardItem.SetCardData(this.FRewardVec[this.FCurrentAppearCardNum].Type);
         }
         this.FMovements[this.FCurrentAppearCardNum].StartToAction();
         ++this.FCurrentAppearCardNum;
      }
      
      override public function UIDispatch(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TCompanionEmployItem = null;
         var _loc5_:Vector.<int> = null;
         var _loc6_:int = 0;
         super.UIDispatch(param1);
         _loc5_ = new Vector.<int>();
         _loc3_ = CONST_HEROCOMPANION.Employ_Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = new TCompanionEmployItem(FRewardUI["MC_Card_" + _loc2_]);
            _loc4_.ItemOnOver = OnOver;
            _loc4_.ItemOnOut = OnOut;
            this.FRewardVec.push(_loc4_);
            _loc5_.push(_loc2_);
            this.FCardsX.push(_loc4_.Substrate.x);
            this.FCardsY.push(_loc4_.Substrate.y);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = Math.random() * (_loc3_ - _loc2_);
            this.FRandoms.push(_loc5_[_loc6_]);
            _loc5_.splice(_loc6_,1);
            _loc2_++;
         }
      }
      
      override public function SetData(param1:Vector.<TCompanionCard>, param2:Vector.<THeroCompanionChipData>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:TCompanionCard = null;
         var _loc7_:TCompanionEmployItem = null;
         var _loc8_:TCompanionMoveBase = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         super.SetData(param1,param2);
         _loc5_ = "";
         this.ClearMoves();
         _loc4_ = int(FCardVec.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc7_ = this.FRewardVec[this.FRandoms[_loc3_]];
            _loc7_.SetData(FCardVec[_loc3_]);
            _loc7_.Substrate.alpha = 0;
            _loc8_ = this.GetCardMove();
            _loc8_.Display = FCardItem.Substrate;
            _loc8_.SetMove(this.FCardsX[this.FRandoms[_loc3_]] + FBigCardOffsetX,this.FCardsY[this.FRandoms[_loc3_]] + FBigCardOffsetY + CONST_HEROCOMPANION.LittleCard_OffsetY,FCardSourceX,FCardSourceY,FCardOriginX,FCardOriginY,Animation_Duration);
            this.FMovements[this.FRandoms[_loc3_]] = _loc8_;
            _loc3_++;
         }
         this.FOwnCard.length = 0;
         _loc4_ = int(FChipVec.length);
         _loc3_ = 0;
         for(; _loc3_ < _loc4_; _loc3_++)
         {
            _loc10_ = this.FRandoms[FCardVec.length + _loc3_];
            _loc7_ = this.FRewardVec[_loc10_];
            _loc7_.SetData(FChipVec[_loc3_]);
            if(FChipVec[_loc3_].TypeId > 0)
            {
               _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_CompanionCard,FChipVec[_loc3_].TypeId) as TCompanionCard;
               if(_loc6_ == null)
               {
                  continue;
               }
               _loc9_ = this.FOwnCard.indexOf(FChipVec[_loc3_].LastId);
               if(_loc9_ == -1)
               {
                  _loc5_ += " " + _loc6_.Name;
                  this.FOwnCard.push(FChipVec[_loc3_].LastId);
               }
               _loc7_.Substrate.alpha = 0;
               _loc8_ = this.GetCardMove();
               _loc8_.Display = FCardItem.Substrate;
               _loc8_.SetMove(this.FCardsX[_loc10_] + FBigCardOffsetX,this.FCardsY[_loc10_] + FBigCardOffsetY + CONST_HEROCOMPANION.LittleCard_OffsetY,FCardSourceX,FCardSourceY,FCardOriginX,FCardOriginY,Animation_Duration);
            }
            else
            {
               _loc8_ = this.GetChipMove();
               _loc8_.Display = _loc7_.Substrate;
               _loc8_.SetMove(this.FCardsX[_loc10_],this.FCardsY[_loc10_],FCardSourceX,FCardSourceY,Animation_Duration);
            }
            this.FMovements[this.FRandoms[FCardVec.length + _loc3_]] = _loc8_;
         }
         if(this.FOwnCard.length > 0)
         {
            FTFDesc.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_COMPANION_21),_loc5_);
         }
         else
         {
            FTFDesc.text = "";
         }
         FCardItem.Substrate.alpha = 0;
         if(this.FRewardVec[0].Type > 0)
         {
            FCardItem.SetCardData(this.FRewardVec[0].Type);
         }
         this.FCurrentAppearCardNum = 1;
         this.FMovements[0].StartToAction();
         this.FIsPlay = true;
      }
      
      override public function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         super.LogicsPerform();
         if(!this.FIsPlay)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < this.FCurrentAppearCardNum)
         {
            this.FMovements[_loc1_].Action();
            _loc1_++;
         }
         this.FIsPlay = !this.FMovements[CONST_HEROCOMPANION.Employ_Count - 1].MoveOver;
      }
   }
}

