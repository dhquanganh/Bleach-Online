package Logics.HDActivityMode
{
   import Logics.Inventories.TInventories;
   
   public class TGiftBoxTipData
   {
      
      protected var FNormalInventories:TInventories;
      
      protected var FNeedColour:Boolean;
      
      protected var FAwardType:uint;
      
      protected var FAdditionInventories:TInventories;
      
      protected var FAdditionItemVec:Vector.<String>;
      
      protected var FSpecialIndex:int;
      
      protected var FCustomizeCaption:String;
      
      public function TGiftBoxTipData()
      {
         super();
         this.FAdditionInventories = new TInventories();
         this.FAdditionItemVec = new Vector.<String>();
         this.FCustomizeCaption = "";
      }
      
      protected function ResetItemVec() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc2_ = this.FAdditionItemVec.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FAdditionItemVec[_loc1_] = "";
            _loc1_++;
         }
         this.FAdditionItemVec.length = 0;
      }
      
      public function get NormalInventories() : TInventories
      {
         return this.FNormalInventories;
      }
      
      public function set NormalInventories(param1:TInventories) : void
      {
         this.FNormalInventories = param1;
      }
      
      public function get NeedColour() : Boolean
      {
         return this.FNeedColour;
      }
      
      public function set NeedColour(param1:Boolean) : void
      {
         this.FNeedColour = param1;
      }
      
      public function get AwardType() : uint
      {
         return this.FAwardType;
      }
      
      public function set AwardType(param1:uint) : void
      {
         this.FAwardType = param1;
      }
      
      public function get AdditionInventories() : TInventories
      {
         return this.FAdditionInventories;
      }
      
      public function set AdditionInventories(param1:TInventories) : void
      {
         this.FAdditionInventories = param1;
      }
      
      public function get AdditionItemVec() : Vector.<String>
      {
         return this.FAdditionItemVec;
      }
      
      public function set AdditionItemVec(param1:Vector.<String>) : void
      {
         this.FAdditionItemVec = param1;
      }
      
      public function get SpecialIndex() : int
      {
         return this.FSpecialIndex;
      }
      
      public function set SpecialIndex(param1:int) : void
      {
         this.FSpecialIndex = param1;
      }
      
      public function get CustomizeCaption() : String
      {
         return this.FCustomizeCaption;
      }
      
      public function set CustomizeCaption(param1:String) : void
      {
         this.FCustomizeCaption = param1;
      }
      
      public function TipReset() : void
      {
         this.FNormalInventories = null;
         this.FNeedColour = false;
         this.FAwardType = 0;
         this.FSpecialIndex = -1;
         this.FAdditionInventories = null;
         this.FCustomizeCaption = "";
         if(this.FAdditionItemVec != null)
         {
            this.ResetItemVec();
         }
      }
   }
}

