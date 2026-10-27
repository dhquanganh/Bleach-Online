package Logics.Streamization.Campaign
{
   import Foundation.Resources.Repositories.*;
   import Foundation.Streamization.*;
   import Logics.Campaign.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Items.*;
   import Logics.Streamization.Items.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TUnstreamizerCampaign extends TUnstreamizerCampaignUnknown
   {
      
      private var FUnstreamizerItem:TUnstreamizerItem;
      
      public function TUnstreamizerCampaign()
      {
         super();
         this.FUnstreamizerItem = new TUnstreamizerItem();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:TCity = null;
         var _loc6_:TCampaign = null;
         var _loc7_:uint = 0;
         var _loc8_:TItem = null;
         var _loc9_:TResourceRepositoryBin = null;
         var _loc10_:TSingle = null;
         var _loc11_:TSinglePointPath = null;
         _loc6_ = param2 as TCampaign;
         _loc9_ = param3 as TResourceRepositoryBin;
         _loc6_.Diffculty = param1.readByte();
         _loc6_.LayerIndex = param1.readByte();
         _loc6_.EnemyIndex = param1.readByte();
         _loc6_.EnterCount = param1.readByte();
         _loc6_.ResetCount = param1.readByte();
         if(!_loc6_.IsInit)
         {
            _loc5_ = _loc9_.GetDatebase(CONST_DATEBASEVO.RESOURCEID_City,_loc6_.Identifier) as TCity;
            _loc10_ = _loc9_.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Single,_loc5_.Start) as TSingle;
            _loc6_.OpenLevel = _loc10_.Level;
            _loc7_ = _loc10_.Awards.length;
            _loc4_ = 0;
            while(_loc4_ < _loc7_)
            {
               if(_loc6_.NormalDropItems.GetItemById(_loc10_.Awards[_loc4_]) == null)
               {
                  _loc8_ = FPoolItem.AcquireItem();
                  _loc8_.Type = 1;
                  _loc8_.ID = _loc10_.Awards[_loc4_];
                  _loc8_.Count = 1;
                  _loc6_.NormalDropItems.Add(_loc8_);
               }
               _loc4_++;
            }
            _loc4_ = int(_loc10_.StartId);
            while(_loc4_ <= _loc10_.EndId)
            {
               _loc11_ = _loc9_.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SinglePointPath,_loc4_) as TSinglePointPath;
               _loc6_.NormalEnemy.push(_loc11_.Armys);
               _loc4_++;
            }
            _loc6_.NormalCampId = _loc5_.Start;
            _loc10_ = _loc9_.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Single,_loc5_.Last) as TSingle;
            _loc7_ = _loc10_.Awards.length;
            _loc4_ = 0;
            while(_loc4_ < _loc7_)
            {
               if(_loc6_.HardDropItems.GetItemById(_loc10_.Awards[_loc4_]) == null)
               {
                  _loc8_ = FPoolItem.AcquireItem();
                  _loc8_.Type = 1;
                  _loc8_.ID = _loc10_.Awards[_loc4_];
                  _loc8_.Count = 1;
                  _loc6_.HardDropItems.Add(_loc8_);
               }
               _loc4_++;
            }
            _loc4_ = int(_loc10_.StartId);
            while(_loc4_ <= _loc10_.EndId)
            {
               _loc11_ = _loc9_.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SinglePointPath,_loc4_) as TSinglePointPath;
               _loc6_.HardEnemy.push(_loc11_.Armys);
               _loc4_++;
            }
            _loc6_.HardCampId = _loc5_.Last;
            _loc6_.IsInit = true;
         }
      }
   }
}

