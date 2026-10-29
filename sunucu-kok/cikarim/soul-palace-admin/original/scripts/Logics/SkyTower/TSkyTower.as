package Logics.SkyTower
{
   public class TSkyTower
   {
      
      protected var FPVECount:uint;
      
      protected var FPveMax:uint;
      
      protected var FPVPCount:uint;
      
      protected var FPvpMax:uint;
      
      protected var FPVEBuyCount:uint;
      
      protected var FPVEBuyMax:uint;
      
      protected var FPVPBuyCount:uint;
      
      protected var FPVPBuyMax:uint;
      
      protected var FIsAKeyPve:Boolean;
      
      protected var FAKeyPvePrice:uint;
      
      protected var FTowers:TTowers;
      
      protected var FPvpDiarys:TPvpDiarys;
      
      protected var FCurIntrgral:uint;
      
      protected var FReceiveChestID:uint;
      
      protected var FLockedTowerID:uint;
      
      protected var FSelectTowerID:uint;
      
      protected var FSelectLayerID:uint;
      
      protected var FSelectMode:uint;
      
      public function TSkyTower()
      {
         super();
         this.FTowers = new TTowers();
         this.FPvpDiarys = new TPvpDiarys();
      }
      
      public function get PVECount() : uint
      {
         return this.FPVECount;
      }
      
      public function set PVECount(param1:uint) : void
      {
         this.FPVECount = param1;
      }
      
      public function get PveMax() : uint
      {
         return this.FPveMax;
      }
      
      public function set PveMax(param1:uint) : void
      {
         this.FPveMax = param1;
      }
      
      public function get PVPCount() : uint
      {
         return this.FPVPCount;
      }
      
      public function set PVPCount(param1:uint) : void
      {
         this.FPVPCount = param1;
      }
      
      public function get PvpMax() : uint
      {
         return this.FPvpMax;
      }
      
      public function set PvpMax(param1:uint) : void
      {
         this.FPvpMax = param1;
      }
      
      public function get PVEBuyCount() : uint
      {
         return this.FPVEBuyCount;
      }
      
      public function set PVEBuyCount(param1:uint) : void
      {
         this.FPVEBuyCount = param1;
      }
      
      public function get PVEBuyMax() : uint
      {
         return this.FPVEBuyMax;
      }
      
      public function set PVEBuyMax(param1:uint) : void
      {
         this.FPVEBuyMax = param1;
      }
      
      public function get PVPBuyCount() : uint
      {
         return this.FPVPBuyCount;
      }
      
      public function set PVPBuyCount(param1:uint) : void
      {
         this.FPVPBuyCount = param1;
      }
      
      public function get PVPBuyMax() : uint
      {
         return this.FPVPBuyMax;
      }
      
      public function set PVPBuyMax(param1:uint) : void
      {
         this.FPVPBuyMax = param1;
      }
      
      public function get IsAKeyPve() : Boolean
      {
         return this.FIsAKeyPve;
      }
      
      public function set IsAKeyPve(param1:Boolean) : void
      {
         this.FIsAKeyPve = param1;
      }
      
      public function get AKeyPvePrice() : uint
      {
         return this.FAKeyPvePrice;
      }
      
      public function set AKeyPvePrice(param1:uint) : void
      {
         this.FAKeyPvePrice = param1;
      }
      
      public function get Towers() : TTowers
      {
         return this.FTowers;
      }
      
      public function get PvpDiarys() : TPvpDiarys
      {
         return this.FPvpDiarys;
      }
      
      public function get CurIntrgral() : uint
      {
         return this.FCurIntrgral;
      }
      
      public function set CurIntrgral(param1:uint) : void
      {
         this.FCurIntrgral = param1;
      }
      
      public function get ReceiveChestID() : uint
      {
         return this.FReceiveChestID;
      }
      
      public function set ReceiveChestID(param1:uint) : void
      {
         this.FReceiveChestID = param1;
      }
      
      public function get LockedTowerID() : uint
      {
         return this.FLockedTowerID;
      }
      
      public function set LockedTowerID(param1:uint) : void
      {
         this.FLockedTowerID = param1;
      }
      
      public function get SelectTowerID() : uint
      {
         return this.FSelectTowerID;
      }
      
      public function set SelectTowerID(param1:uint) : void
      {
         this.FSelectTowerID = param1;
      }
      
      public function get SelectLayerID() : uint
      {
         return this.FSelectLayerID;
      }
      
      public function set SelectLayerID(param1:uint) : void
      {
         this.FSelectLayerID = param1;
      }
      
      public function get SelectMode() : uint
      {
         return this.FSelectMode;
      }
      
      public function set SelectMode(param1:uint) : void
      {
         this.FSelectMode = param1;
      }
      
      public function GetCharacterPvpTower(param1:uint, param2:uint) : TTower
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TTower = null;
         var _loc8_:TLayer = null;
         var _loc9_:TLayers = null;
         _loc4_ = this.FTowers.Count;
         _loc3_ = 0;
         loop0:
         while(_loc3_ < _loc4_)
         {
            _loc7_ = this.FTowers.GetTowerByIndex(_loc3_);
            _loc9_ = _loc7_.Layers;
            _loc6_ = _loc9_.Count;
            _loc5_ = 0;
            while(true)
            {
               if(_loc5_ >= _loc6_)
               {
                  _loc3_++;
                  continue loop0;
               }
               _loc8_ = _loc9_.GetLayerByIndex(_loc5_);
               if(_loc8_.IsPvpMode)
               {
                  if(_loc8_.PvpRoleHighID == param1 && _loc8_.PvpRoleLowID == param2)
                  {
                     break;
                  }
               }
               _loc5_++;
            }
            return _loc7_;
         }
         return null;
      }
      
      public function GetCharacterPvpLayer(param1:uint, param2:uint) : TLayer
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TLayers = null;
         var _loc8_:TLayer = null;
         _loc4_ = this.FTowers.Count;
         _loc3_ = 0;
         loop0:
         while(_loc3_ < _loc4_)
         {
            _loc7_ = this.FTowers.GetTowerByIndex(_loc3_).Layers;
            _loc6_ = _loc7_.Count;
            _loc5_ = 0;
            while(true)
            {
               if(_loc5_ >= _loc6_)
               {
                  _loc3_++;
                  continue loop0;
               }
               _loc8_ = _loc7_.GetLayerByIndex(_loc5_);
               if(_loc8_.IsPvpMode)
               {
                  if(_loc8_.PvpRoleHighID == param1 && _loc8_.PvpRoleLowID == param2)
                  {
                     break;
                  }
               }
               _loc5_++;
            }
            return _loc8_;
         }
         return null;
      }
      
      public function UpdateTowerMaxLayers() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TTower = null;
         var _loc4_:TLayers = null;
         var _loc5_:TLayer = null;
         if(this.FLockedTowerID == 0)
         {
            return;
         }
         _loc3_ = this.FTowers.GetTowerByIdentifier(this.FLockedTowerID);
         _loc4_ = _loc3_.Layers;
         _loc2_ = _loc4_.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = _loc4_.GetLayerByIndex(_loc1_);
            if(!_loc5_.IsClear)
            {
               break;
            }
            if(_loc4_.MaxLayer < _loc1_ + 1)
            {
               _loc4_.MaxLayer = _loc1_ + 1;
            }
            _loc1_++;
         }
      }
   }
}

