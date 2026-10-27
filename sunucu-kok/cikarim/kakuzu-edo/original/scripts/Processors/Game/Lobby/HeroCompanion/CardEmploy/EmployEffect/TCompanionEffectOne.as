package Processors.Game.Lobby.HeroCompanion.CardEmploy.EmployEffect
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.TCompanionCard;
   import Logics.HeroCompanion.THeroCompanionChipData;
   import Processors.Game.Lobby.HeroCompanion.CardEmploy.EmployEffect.EffectMove.*;
   import Processors.Game.Lobby.HeroCompanion.Components.TCompanionEmployItem;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_HEROCOMPANION;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   
   public class TCompanionEffectOne extends TCompanionBaseEffect
   {
      
      protected var FItem:TCompanionEmployItem;
      
      protected var FChipMove:TCompanionMoveChip;
      
      protected var FCardMove:TCompanionMoveCard;
      
      protected var FCurMove:TCompanionMoveBase;
      
      public function TCompanionEffectOne()
      {
         super();
      }
      
      override public function UIDispatch(param1:MovieClip) : void
      {
         super.UIDispatch(param1);
         this.FItem = new TCompanionEmployItem(FRewardUI["MC_Card_0"]);
         this.FItem.ItemOnOver = OnOver;
         this.FItem.ItemOnOut = OnOut;
         this.FChipMove = new TCompanionMoveChip();
         this.FChipMove.Display = this.FItem.Substrate;
         this.FCardMove = new TCompanionMoveCard();
         this.FCardMove.Display = FCardItem.Substrate;
         this.FCardMove.Effect = FEffect;
      }
      
      override public function SetData(param1:Vector.<TCompanionCard>, param2:Vector.<THeroCompanionChipData>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TCompanionCard = null;
         super.SetData(param1,param2);
         if(FCardVec.length > 0)
         {
            this.FItem.SetData(FCardVec[0]);
            this.FCurMove = this.FCardMove;
            this.FCurMove.SetMove(this.FItem.Substrate.x + FCardOffsetX + FBigCardOffsetX,this.FItem.Substrate.y + FCardOffsetY + FBigCardOffsetY + CONST_HEROCOMPANION.LittleCard_OffsetY,FCardSourceX + FCardOffsetX,FCardSourceY + FCardOffsetY,FCardOriginX + FCardOffsetX,FCardOriginY + FCardOffsetY,CONST_HEROCOMPANION.Animation_Duration);
            FCardItem.SetCardData(FCardVec[0].Identifier);
         }
         else
         {
            this.FItem.SetData(param2[0]);
            if(param2[0].TypeId > 0)
            {
               _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_CompanionCard,param2[0].TypeId) as TCompanionCard;
               FTFDesc.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_COMPANION_21),_loc4_.Name);
               this.FCurMove = this.FCardMove;
               this.FCurMove.SetMove(this.FItem.Substrate.x + FCardOffsetX + FBigCardOffsetX,this.FItem.Substrate.y + FCardOffsetY + FBigCardOffsetY + CONST_HEROCOMPANION.LittleCard_OffsetY,FCardSourceX + FCardOffsetX,FCardSourceY + FCardOffsetY,FCardOriginX + FCardOffsetX,FCardOriginY + FCardOffsetY,CONST_HEROCOMPANION.Animation_Duration);
               FCardItem.SetCardData(param2[0].TypeId);
            }
            else
            {
               FTFDesc.text = "";
               this.FCurMove = this.FChipMove;
               this.FCurMove.SetMove(this.FItem.Substrate.x,this.FItem.Substrate.y,FCardSourceX,FCardSourceY,CONST_HEROCOMPANION.Animation_Duration);
            }
         }
         this.FItem.Substrate.alpha = 0;
         FCardItem.Substrate.alpha = 0;
         this.FCurMove.StartToAction();
      }
      
      override public function LogicsPerform() : void
      {
         super.LogicsPerform();
         this.FCurMove.Action();
         if(this.FCurMove.MoveOver)
         {
            this.FItem.Substrate.alpha = 1;
         }
      }
   }
}

