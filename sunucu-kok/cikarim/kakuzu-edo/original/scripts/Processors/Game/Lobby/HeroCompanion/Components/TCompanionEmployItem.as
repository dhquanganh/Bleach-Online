package Processors.Game.Lobby.HeroCompanion.Components
{
   import Logics.DatebaseVO.VO.TCompanionCard;
   import Logics.HeroCompanion.THeroCompanionChipData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TCompanionEmployItem
   {
      
      protected var FMainUI:Sprite;
      
      protected var FTFName:TextField;
      
      protected var FCardItem:TCompanionCardItem;
      
      protected var FChipItem:TCompanionChipItem;
      
      protected var FCardData:TCompanionCard;
      
      protected var FChipData:THeroCompanionChipData;
      
      protected var FItemOnOver:Function;
      
      protected var FItemOnOut:Function;
      
      protected var FType:int;
      
      public function TCompanionEmployItem(param1:Sprite)
      {
         super();
         this.FMainUI = param1;
         this.FTFName = this.FMainUI["TF_Name"];
         this.FCardItem = new TCompanionCardItem(this.FMainUI["MC_Card"]);
         this.FCardItem.ItemOnMove = this.OnOver;
         this.FCardItem.ItemOnOut = this.OnOut;
         this.FChipItem = new TCompanionChipItem(this.FMainUI["MC_Chip"]);
         this.FChipItem.ItemOnMove = this.OnOver;
         this.FChipItem.ItemOnOut = this.OnOut;
      }
      
      protected function OnOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FItemOnOut != null)
         {
            this.FItemOnOut();
         }
      }
      
      protected function OnOver(param1:Object, param2:MouseEvent) : void
      {
         if(this.FCardData != null)
         {
            this.FItemOnOver(this.FCardData);
         }
         else
         {
            this.FItemOnOver(this.FChipData);
         }
      }
      
      public function get ItemOnOver() : Function
      {
         return this.FItemOnOver;
      }
      
      public function set ItemOnOver(param1:Function) : void
      {
         this.FItemOnOver = param1;
      }
      
      public function get ItemOnOut() : Function
      {
         return this.FItemOnOut;
      }
      
      public function set ItemOnOut(param1:Function) : void
      {
         this.FItemOnOut = param1;
      }
      
      public function get Substrate() : Sprite
      {
         return this.FMainUI;
      }
      
      public function get Type() : int
      {
         return this.FType;
      }
      
      public function set Type(param1:int) : void
      {
         this.FType = param1;
      }
      
      public function SetData(param1:Object) : void
      {
         if(param1 is TCompanionCard)
         {
            this.FCardData = param1 as TCompanionCard;
            this.FCardItem.Visible = true;
            this.FChipItem.Visible = false;
            this.FCardItem.SetData(this.FCardData);
            this.FTFName.text = this.FCardData.Name;
            this.FType = this.FCardData.Identifier;
         }
         else
         {
            this.FChipData = param1 as THeroCompanionChipData;
            this.FCardItem.Visible = false;
            this.FChipItem.Visible = true;
            this.FChipItem.SetChipData(this.FChipData);
            this.FTFName.text = this.FChipData.ChipData.Name;
            this.FType = this.FChipData.TypeId;
         }
      }
   }
}

