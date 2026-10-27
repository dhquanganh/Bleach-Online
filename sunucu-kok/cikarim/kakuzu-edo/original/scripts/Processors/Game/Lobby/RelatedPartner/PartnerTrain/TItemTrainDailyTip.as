package Processors.Game.Lobby.RelatedPartner.PartnerTrain
{
   import Resources.Constants.CONST_RELATEDPARTNER;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class TItemTrainDailyTip
   {
      
      protected static const Daily_Num:int = CONST_RELATEDPARTNER.PartnerTrain_DailyReward_Num;
      
      protected var FMainUI:Sprite;
      
      protected var FTFLevels:Vector.<TextField>;
      
      protected var FTFAwards:Vector.<TextField>;
      
      protected var FLevels:Vector.<int>;
      
      protected var FAwardNames:Vector.<String>;
      
      public function TItemTrainDailyTip(param1:Sprite)
      {
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         super();
         this.FMainUI = param1;
         this.FTFLevels = new Vector.<TextField>();
         this.FTFAwards = new Vector.<TextField>();
         _loc2_ = 0;
         while(_loc2_ < Daily_Num)
         {
            _loc3_ = this.FMainUI["MC_Item_" + _loc2_];
            this.FTFLevels.push(_loc3_["TF_Count"]);
            this.FTFAwards.push(_loc3_["TF_Name"]);
            _loc2_++;
         }
         this.FLevels = new Vector.<int>(Daily_Num);
         this.FAwardNames = new Vector.<String>(Daily_Num);
         this.FMainUI.mouseEnabled = false;
      }
      
      public function get Levels() : Vector.<int>
      {
         return this.FLevels;
      }
      
      public function get AwardNames() : Vector.<String>
      {
         return this.FAwardNames;
      }
      
      public function get Visible() : Boolean
      {
         return this.FMainUI.visible;
      }
      
      public function set Visible(param1:Boolean) : void
      {
         this.FMainUI.visible = param1;
      }
      
      public function Render() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < Daily_Num)
         {
            this.FTFLevels[_loc1_].text = this.FLevels[_loc1_] + "";
            if(this.FAwardNames[_loc1_] != null)
            {
               this.FTFAwards[_loc1_].text = this.FAwardNames[_loc1_];
            }
            _loc1_++;
         }
      }
   }
}

