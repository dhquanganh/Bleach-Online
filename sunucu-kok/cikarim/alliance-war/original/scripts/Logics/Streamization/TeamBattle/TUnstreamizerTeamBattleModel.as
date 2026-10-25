package Logics.Streamization.TeamBattle
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.TLeagueMapPve;
   import Logics.DatebaseVO.VO.TLeagueMapPvp;
   import Logics.TeamBattle.TModel;
   import Logics.TeamBattle.TModels;
   import Logics.TeamBattle.TTeamBattle;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerTeamBattleModel extends TUnstreamizer
   {
      
      public function TUnstreamizerTeamBattleModel()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_Properties(param1,param2,param3);
      }
      
      protected function UnstreamizationPerform_Properties(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc7_:TTeamBattle = null;
         var _loc8_:TModels = null;
         var _loc9_:TModel = null;
         var _loc10_:TLeagueMapPve = null;
         var _loc11_:TBins = null;
         _loc7_ = param2 as TTeamBattle;
         _loc8_ = _loc7_.PVEModels;
         _loc11_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_LeagueMapPve);
         _loc8_.Clear();
         _loc5_ = int(param1.readUnsignedShort());
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param1.readUnsignedInt();
            _loc9_ = new TModel(_loc6_);
            _loc10_ = _loc11_.GetDatebaseByIdentifier(_loc6_) as TLeagueMapPve;
            _loc9_.IsUnlock = true;
            _loc8_.Add(_loc9_);
            _loc4_++;
         }
         _loc5_ = _loc11_.Count;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc10_ = _loc11_.GetDatebaseByIndex(_loc4_) as TLeagueMapPve;
            _loc9_ = _loc8_.GetModelByIdentifier(_loc10_.Identifier);
            if(_loc9_ == null)
            {
               _loc9_ = new TModel(_loc10_.Identifier);
               _loc9_.IsUnlock = false;
               _loc8_.Add(_loc9_);
            }
            _loc4_++;
         }
         _loc8_.SortModels();
      }
      
      protected function UnstreamizationPerform_TeamBattlePVPModels(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TTeamBattle = null;
         var _loc7_:TModels = null;
         var _loc8_:TModel = null;
         var _loc9_:TLeagueMapPvp = null;
         var _loc10_:TBins = null;
         var _loc11_:uint = 0;
         var _loc12_:Boolean = false;
         _loc11_ = param3 as uint;
         _loc6_ = param2 as TTeamBattle;
         _loc7_ = _loc6_.PVPModels;
         _loc10_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_LeagueMapPvp);
         _loc7_.Clear();
         _loc5_ = _loc10_.Count;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc9_ = _loc10_.GetDatebaseByIndex(_loc4_) as TLeagueMapPvp;
            _loc12_ = false;
            if(_loc9_.OpenLevel <= _loc11_)
            {
               _loc12_ = true;
            }
            _loc8_ = new TModel(_loc9_.Identifier);
            _loc8_.IsUnlock = _loc12_;
            _loc7_.Add(_loc8_);
            _loc4_++;
         }
         _loc7_.SortModels();
      }
      
      public function UnstreamizeTeamBattlePVPModels(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_TeamBattlePVPModels(param1,param2,param3);
      }
   }
}

