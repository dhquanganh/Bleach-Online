package Logics.Streamization.Campaign
{
   import Foundation.Resources.Repositories.TResourceRepositoryBin;
   import Logics.Campaign.TCampaign;
   import Logics.Campaign.TNodal;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerNodal extends TUnstreamizerCampaignUnknown
   {
      
      private var FUnstreamizerCampaign:TUnstreamizerCampaign;
      
      public function TUnstreamizerNodal()
      {
         super();
         this.FUnstreamizerCampaign = new TUnstreamizerCampaign();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.Unstreamization_Mission(param1,param2,param3);
         this.Unstreamization_Campaign(param1,param2,param3);
      }
      
      protected function Unstreamization_Mission(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:TNodal = null;
         var _loc6_:TResourceRepositoryBin = null;
         var _loc7_:uint = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:uint = 0;
         _loc5_ = param2 as TNodal;
         _loc6_ = param3 as TResourceRepositoryBin;
         _loc12_ = 15101001;
         _loc7_ = uint(param1.readShort());
         _loc4_ = 0;
         while(_loc4_ < _loc7_)
         {
            _loc8_ = param1.readInt();
            _loc9_ = param1.readByte();
            _loc5_.SetMissionStarByID(_loc8_,_loc9_);
            _loc12_ = Math.max(_loc12_,_loc8_);
            _loc4_++;
         }
         _loc5_.CurMissionID = _loc12_;
         _loc7_ = uint(param1.readShort());
         _loc4_ = 0;
         while(_loc4_ < _loc7_)
         {
            _loc8_ = param1.readInt();
            _loc10_ = param1.readByte();
            _loc11_ = param1.readByte();
            _loc9_ = param1.readByte();
            _loc5_.SetCampStarByID(_loc8_,_loc9_);
            _loc5_.SetCampFarDataByID(_loc8_,_loc10_,_loc11_);
            _loc4_++;
         }
      }
      
      protected function Unstreamization_Campaign(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:TNodal = null;
         var _loc6_:TResourceRepositoryBin = null;
         var _loc7_:uint = 0;
         var _loc8_:TCampaign = null;
         var _loc9_:int = 0;
         _loc5_ = param2 as TNodal;
         _loc6_ = param3 as TResourceRepositoryBin;
         _loc7_ = uint(param1.readShort());
         _loc4_ = 0;
         while(_loc4_ < _loc7_)
         {
            _loc9_ = param1.readInt();
            _loc8_ = _loc5_.GetCampaignById(_loc9_);
            if(_loc8_ == null)
            {
               _loc8_ = FPoolCampaign.AcquireCampaign(_loc9_);
               _loc5_.AddCampaign(_loc8_);
            }
            this.FUnstreamizerCampaign.Unstreamize(param1,_loc8_,param3);
            _loc4_++;
         }
      }
      
      public function UnstreamizationCampaign(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.Unstreamization_Campaign(param1,param2,param3);
      }
   }
}

