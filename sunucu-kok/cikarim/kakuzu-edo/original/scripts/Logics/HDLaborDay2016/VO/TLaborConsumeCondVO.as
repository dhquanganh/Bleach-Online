package Logics.HDLaborDay2016.VO
{
   import Logics.Inventories.TInventories;
   
   public class TLaborConsumeCondVO
   {
      
      protected var FInvs:TInventories;
      
      protected var FCostVec:Vector.<uint>;
      
      protected var FTypeVec:Vector.<uint>;
      
      protected var FCodeVec:Vector.<uint>;
      
      protected var FReachedVec:Vector.<Boolean>;
      
      public function TLaborConsumeCondVO()
      {
         super();
         this.FInvs = new TInventories();
         this.FCostVec = new Vector.<uint>();
         this.FTypeVec = new Vector.<uint>();
         this.FCodeVec = new Vector.<uint>();
         this.FReachedVec = new Vector.<Boolean>();
      }
      
      public function get Invs() : TInventories
      {
         return this.FInvs;
      }
      
      public function get CostVec() : Vector.<uint>
      {
         return this.FCostVec;
      }
      
      public function get TypeVec() : Vector.<uint>
      {
         return this.FTypeVec;
      }
      
      public function get CodeVec() : Vector.<uint>
      {
         return this.FCodeVec;
      }
      
      public function get ReachedVec() : Vector.<Boolean>
      {
         return this.FReachedVec;
      }
   }
}

