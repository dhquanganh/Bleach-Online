package Logics.HDActivityBigTurnTable
{
   public class TScorePoint
   {
      
      protected var FIndex:int;
      
      protected var FValue:int;
      
      protected var FDes:String;
      
      protected var FKnifeAndHeroID:Vector.<int>;
      
      public function TScorePoint(param1:Object)
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         super();
         this.FIndex = param1.index;
         this.FDes = param1.des;
         this.FKnifeAndHeroID = new Vector.<int>();
         _loc3_ = int(param1.special.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FKnifeAndHeroID.push(param1.special[_loc2_]);
            _loc2_++;
         }
      }
      
      public function get Index() : int
      {
         return this.FIndex;
      }
      
      public function get Value() : int
      {
         return this.FValue;
      }
      
      public function set Value(param1:int) : void
      {
         this.FValue = param1;
      }
      
      public function get Des() : String
      {
         return this.FDes;
      }
      
      public function get KnifeAndHeroID() : Vector.<int>
      {
         return this.FKnifeAndHeroID;
      }
      
      public function ActivityDataInit(param1:int, param2:int) : void
      {
         if(this.FIndex != param1)
         {
            return;
         }
         this.FValue = param2;
      }
      
      public function ActivityDataUpdate(param1:int, param2:int) : void
      {
         if(this.FIndex != param1)
         {
            return;
         }
         this.FValue = param2;
      }
   }
}

