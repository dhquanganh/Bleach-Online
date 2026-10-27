package Logics.HDActivityMode
{
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TActivityInitRetData
   {
      
      protected var FAllBox:Vector.<THDBoxStateData>;
      
      protected var FBuyStates:Vector.<THDBoxStateData>;
      
      protected var FAwardStates:Vector.<THDBoxStateData>;
      
      protected var FMailStates:Vector.<THDBoxStateData>;
      
      protected var FShowOnlyStates:Vector.<THDBoxStateData>;
      
      protected var FParameterVec:Vector.<int>;
      
      protected var FAddtionalVecs:Vector.<Vector.<Object>>;
      
      public function TActivityInitRetData()
      {
         super();
         this.FAllBox = new Vector.<THDBoxStateData>();
         this.FBuyStates = new Vector.<THDBoxStateData>();
         this.FAwardStates = new Vector.<THDBoxStateData>();
         this.FMailStates = new Vector.<THDBoxStateData>();
         this.FShowOnlyStates = new Vector.<THDBoxStateData>();
         this.FParameterVec = new Vector.<int>();
         this.FAddtionalVecs = new Vector.<Vector.<Object>>();
      }
      
      protected function SortByIndex(param1:THDBoxStateData, param2:THDBoxStateData) : int
      {
         if(param1.BoxIndex < param2.BoxIndex)
         {
            return -1;
         }
         return 1;
      }
      
      protected function ClearInner(param1:Vector.<Object>) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Object = null;
         _loc3_ = param1.length;
         while(_loc3_ > 0)
         {
            _loc4_ = param1[_loc3_ - 1];
            _loc4_ = null;
            param1.pop();
            _loc3_--;
         }
      }
      
      public function get BuyStates() : Vector.<THDBoxStateData>
      {
         return this.FBuyStates;
      }
      
      public function set BuyStates(param1:Vector.<THDBoxStateData>) : void
      {
         this.FBuyStates = param1;
      }
      
      public function get AwardStates() : Vector.<THDBoxStateData>
      {
         return this.FAwardStates;
      }
      
      public function set AwardStates(param1:Vector.<THDBoxStateData>) : void
      {
         this.FAwardStates = param1;
      }
      
      public function get MailStates() : Vector.<THDBoxStateData>
      {
         return this.FMailStates;
      }
      
      public function set MailStates(param1:Vector.<THDBoxStateData>) : void
      {
         this.FMailStates = param1;
      }
      
      public function get ParameterVec() : Vector.<int>
      {
         return this.FParameterVec;
      }
      
      public function set ParameterVec(param1:Vector.<int>) : void
      {
         this.FParameterVec = param1;
      }
      
      public function get AddtionalVecs() : Vector.<Vector.<Object>>
      {
         return this.FAddtionalVecs;
      }
      
      public function set AddtionalVecs(param1:Vector.<Vector.<Object>>) : void
      {
         this.FAddtionalVecs = param1;
      }
      
      public function get AllBox() : Vector.<THDBoxStateData>
      {
         return this.FAllBox;
      }
      
      public function set AllBox(param1:Vector.<THDBoxStateData>) : void
      {
         this.FAllBox = param1;
      }
      
      public function get ShowOnlyStates() : Vector.<THDBoxStateData>
      {
         return this.FShowOnlyStates;
      }
      
      public function set ShowOnlyStates(param1:Vector.<THDBoxStateData>) : void
      {
         this.FShowOnlyStates = param1;
      }
      
      public function AddAllBox(param1:THDBoxStateData) : void
      {
         this.FAllBox.push(param1);
      }
      
      public function ClearAllBox() : void
      {
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         var _loc3_:THDBoxStateData = null;
         var _loc4_:int = 0;
         var _loc5_:Vector.<Object> = null;
         _loc1_ = int(this.FAllBox.length);
         while(_loc1_ > 0)
         {
            _loc3_ = this.FAllBox[_loc1_ - 1];
            _loc3_ = null;
            this.FAllBox.pop();
            _loc1_--;
         }
         _loc1_ = int(this.FMailStates.length);
         while(_loc1_ > 0)
         {
            _loc3_ = this.FMailStates[_loc1_ - 1];
            _loc3_ = null;
            this.FMailStates.pop();
            _loc1_--;
         }
         _loc1_ = int(this.FShowOnlyStates.length);
         while(_loc1_ > 0)
         {
            _loc3_ = this.FShowOnlyStates[_loc1_ - 1];
            _loc3_ = null;
            this.FShowOnlyStates.pop();
            _loc1_--;
         }
         _loc1_ = int(this.FBuyStates.length);
         while(_loc1_ > 0)
         {
            _loc3_ = this.FBuyStates[_loc1_ - 1];
            _loc3_ = null;
            this.FBuyStates.pop();
            _loc1_--;
         }
         _loc1_ = int(this.FAwardStates.length);
         while(_loc1_ > 0)
         {
            _loc3_ = this.FAwardStates[_loc1_ - 1];
            _loc3_ = null;
            this.FAwardStates.pop();
            _loc1_--;
         }
         _loc1_ = int(this.FParameterVec.length);
         while(_loc1_ > 0)
         {
            _loc4_ = this.FParameterVec[_loc1_ - 1];
            this.FParameterVec.pop();
            _loc1_--;
         }
         _loc1_ = int(this.FAddtionalVecs.length);
         while(_loc1_ > 0)
         {
            _loc5_ = this.FAddtionalVecs[_loc1_ - 1];
            this.ClearInner(_loc5_);
            this.FAddtionalVecs.pop();
            _loc1_--;
         }
      }
      
      public function AddParameter(param1:int) : void
      {
         this.FParameterVec.push(param1);
      }
      
      public function BoxClassification() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc2_ = this.FAllBox.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            switch(this.FAllBox[_loc1_].TypeAcquire)
            {
               case CONST_ACTIVITY_MODE.TYPE_Operate_Mail:
                  this.FMailStates.push(this.FAllBox[_loc1_]);
                  break;
               case CONST_ACTIVITY_MODE.TYPE_Operate_Award:
                  this.FAwardStates.push(this.FAllBox[_loc1_]);
                  break;
               case CONST_ACTIVITY_MODE.TYPE_Operate_Buy:
                  this.FBuyStates.push(this.FAllBox[_loc1_]);
                  break;
               case CONST_ACTIVITY_MODE.TYPE_Operate_ShowOnly:
                  this.FShowOnlyStates.push(this.FAllBox[_loc1_]);
            }
            _loc1_++;
         }
         this.FBuyStates.sort(this.SortByIndex);
         this.FMailStates.sort(this.SortByIndex);
         this.FAwardStates.sort(this.SortByIndex);
         this.FShowOnlyStates.sort(this.SortByIndex);
      }
      
      public function AddAddtional(param1:Vector.<Object>) : void
      {
         this.FAddtionalVecs.push(param1);
      }
      
      public function AllBoxSortByIndex() : void
      {
         this.FAllBox.sort(this.SortByIndex);
      }
   }
}

