package Logics.Campaign
{
   public class TCampaigns
   {
      
      protected var FCampaigns:Vector.<TCampaign>;
      
      public function TCampaigns()
      {
         super();
         this.FCampaigns = new Vector.<TCampaign>();
      }
      
      public function get Count() : int
      {
         return this.FCampaigns.length;
      }
      
      public function GetCampByIndex(param1:int) : TCampaign
      {
         return this.FCampaigns[param1];
      }
      
      public function GetCampById(param1:int) : TCampaign
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TCampaign = null;
         _loc2_ = int(this.FCampaigns.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.FCampaigns[_loc3_];
            if(_loc4_.Identifier == param1)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TCampaign = null;
         _loc1_ = int(this.FCampaigns.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FCampaigns[_loc2_];
            _loc3_.StubReferences.Dereference(this);
            _loc2_++;
         }
         this.FCampaigns.length = 0;
      }
      
      public function Add(param1:TCampaign) : void
      {
         param1.StubReferences.Reference(this);
         this.FCampaigns.push(param1);
      }
   }
}

