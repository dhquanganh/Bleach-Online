package Logics.Campaign
{
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Logics.*;
   import Resources.Constants.*;
   
   public class TNodal
   {
      
      protected var FCurMissionID:int;
      
      protected var FMissionStars:TStars;
      
      protected var FCampStars:TStars;
      
      protected var FCampaigns:TCampaigns;
      
      public function TNodal()
      {
         super();
         this.FMissionStars = new TStars();
         this.FCampStars = new TStars();
         this.FCampaigns = new TCampaigns();
      }
      
      public function get CurMissionID() : int
      {
         return this.FCurMissionID;
      }
      
      public function set CurMissionID(param1:int) : void
      {
         this.FCurMissionID = param1;
      }
      
      public function SetMissionStarByID(param1:int, param2:int) : void
      {
         var _loc3_:TStar = null;
         _loc3_ = this.FMissionStars.GetStarById(param1);
         if(_loc3_)
         {
            _loc3_.StarCount = Math.max(_loc3_.StarCount,param2);
         }
         else
         {
            _loc3_ = SLogicsCore.PoolCampaign.AcquireStar(param1);
            _loc3_.StarCount = param2;
            this.FMissionStars.Add(_loc3_);
         }
      }
      
      public function GetMissionStarByID(param1:int) : int
      {
         return this.FMissionStars.GetStarCountById(param1);
      }
      
      public function SetCampStarByID(param1:int, param2:int) : void
      {
         var _loc3_:TStar = null;
         _loc3_ = this.FCampStars.GetStarById(param1);
         if(_loc3_)
         {
            _loc3_.StarCount = Math.max(_loc3_.StarCount,param2);
         }
         else
         {
            _loc3_ = SLogicsCore.PoolCampaign.AcquireStar(param1);
            _loc3_.StarCount = param2;
            this.FCampStars.Add(_loc3_);
         }
      }
      
      public function SetCampFarDataByID(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:TStar = null;
         _loc4_ = this.FCampStars.GetStarById(param1);
         if(_loc4_)
         {
            _loc4_.MaxLayerIndex = Math.max(_loc4_.MaxLayerIndex,param2);
            _loc4_.MaxEnemyIndex = Math.max(_loc4_.MaxEnemyIndex,param3);
         }
         else
         {
            _loc4_ = SLogicsCore.PoolCampaign.AcquireStar(param1);
            _loc4_.MaxLayerIndex = param2;
            _loc4_.MaxEnemyIndex = param3;
            this.FCampStars.Add(_loc4_);
         }
      }
      
      public function GetCampStarByID(param1:int) : int
      {
         return this.FCampStars.GetStarCountById(param1);
      }
      
      public function GetCampMaxLayerIndex(param1:int) : int
      {
         var _loc2_:TStar = null;
         _loc2_ = this.FCampStars.GetStarById(param1);
         return _loc2_ ? int(_loc2_.MaxLayerIndex) : 0;
      }
      
      public function GetCampMaxEnemyIndex(param1:int) : int
      {
         var _loc2_:TStar = null;
         _loc2_ = this.FCampStars.GetStarById(param1);
         return _loc2_ ? int(_loc2_.MaxEnemyIndex) : 0;
      }
      
      public function ResetCampaign(param1:int) : void
      {
         var _loc2_:TCampaign = null;
         _loc2_ = this.FCampaigns.GetCampById(param1);
         if(_loc2_ != null)
         {
            _loc2_.Diffculty = -1;
            _loc2_.ResetCount += 1;
            _loc2_.LayerIndex = 0;
            _loc2_.EnemyIndex = 0;
         }
      }
      
      public function SetCampaignPos(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:TCampaign = null;
         _loc4_ = this.FCampaigns.GetCampById(param1);
         if(_loc4_ != null)
         {
            _loc4_.LayerIndex = param2;
            _loc4_.EnemyIndex = param3;
         }
      }
      
      public function AddCampaignLayerIndex(param1:int) : void
      {
         var _loc2_:TStar = null;
         var _loc3_:TCampaign = null;
         _loc2_ = this.FCampStars.GetStarById(param1);
         _loc3_ = this.FCampaigns.GetCampById(param1);
         if(_loc3_ != null)
         {
            _loc3_.LayerIndex += 1;
            _loc3_.EnemyIndex = 0;
            if(_loc2_ == null)
            {
               _loc2_ = SLogicsCore.PoolCampaign.AcquireStar(param1);
               _loc2_.MaxLayerIndex = 0;
               _loc2_.MaxEnemyIndex = 0;
               this.FCampStars.Add(_loc2_);
            }
            _loc2_.MaxLayerIndex = Math.max(_loc3_.LayerIndex,_loc2_.MaxLayerIndex);
            _loc2_.MaxEnemyIndex = Math.max(_loc3_.EnemyIndex,_loc2_.MaxEnemyIndex);
         }
      }
      
      public function AddCampaignEnemyIndex(param1:int) : void
      {
         var _loc2_:TStar = null;
         var _loc3_:TCampaign = null;
         _loc2_ = this.FCampStars.GetStarById(param1);
         _loc3_ = this.FCampaigns.GetCampById(param1);
         if(_loc3_ != null)
         {
            ++_loc3_.EnemyIndex;
            if(_loc2_ == null)
            {
               _loc2_ = SLogicsCore.PoolCampaign.AcquireStar(param1);
               _loc2_.MaxLayerIndex = 0;
               _loc2_.MaxEnemyIndex = 0;
               this.FCampStars.Add(_loc2_);
            }
            _loc2_.MaxEnemyIndex = Math.max(_loc3_.EnemyIndex,_loc2_.MaxEnemyIndex);
         }
      }
      
      public function AutoAddCampaignIndex(param1:int) : void
      {
         var _loc2_:Vector.<Vector.<uint>> = null;
         var _loc3_:TCampaign = null;
         _loc3_ = this.FCampaigns.GetCampById(param1);
         if(_loc3_ != null)
         {
            if(_loc3_.Diffculty == TCampaign.Type_Noraml)
            {
               _loc2_ = _loc3_.NormalEnemy;
            }
            else if(_loc3_.Diffculty == TCampaign.Type_Hard)
            {
               _loc2_ = _loc3_.HardEnemy;
            }
            ++_loc3_.EnemyIndex;
            if(_loc3_.EnemyIndex >= _loc2_[_loc3_.LayerIndex].length)
            {
               ++_loc3_.LayerIndex;
               _loc3_.EnemyIndex = 0;
            }
         }
      }
      
      public function GetCampaignByIndex(param1:uint) : TCampaign
      {
         if(param1 > this.FCampaigns.Count)
         {
            return null;
         }
         return this.FCampaigns.GetCampByIndex(param1);
      }
      
      public function GetCampaignById(param1:uint) : TCampaign
      {
         return this.FCampaigns.GetCampById(param1);
      }
      
      public function AddCampaign(param1:TCampaign) : void
      {
         this.FCampaigns.Add(param1);
      }
      
      public function GetCampaignMaxId() : uint
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TCampaign = null;
         _loc2_ = 15210001;
         _loc1_ = 0;
         while(_loc1_ < this.FCampaigns.Count)
         {
            _loc3_ = this.FCampaigns.GetCampByIndex(_loc1_);
            _loc2_ = Math.max(_loc2_,_loc3_.Identifier);
            _loc1_++;
         }
         return _loc2_;
      }
      
      public function GetCampMaxPassLayerIndex(param1:int) : int
      {
         var _loc2_:TStar = null;
         var _loc3_:int = 0;
         _loc2_ = this.FCampStars.GetStarById(param1);
         if(_loc2_ == null)
         {
            _loc3_ = 0;
         }
         else
         {
            _loc3_ = int(_loc2_.MaxLayerIndex);
         }
         return _loc3_;
      }
   }
}

