package Logics.HeroNew
{
   import Foundation.Resources.SResourcesCore;
   import Logics.Characters.THero;
   import Logics.DatebaseVO.VO.Json.TAddOther;
   import Logics.DatebaseVO.VO.TWakeUp;
   import Logics.DatebaseVO.VO.TWakeUpEquip;
   import Resources.Constants.CONST_DATEBASEVO;
   
   public class TWakeHeroAttributes
   {
      
      protected static const WakeUpSlotNum:int = 8;
      
      protected var FHeroIds:Vector.<int>;
      
      protected var FAttributes:Vector.<TWakeProperties>;
      
      protected var FLevelAttributes:Vector.<Vector.<TWakeProperties>>;
      
      protected var FWakeLevels:Vector.<int>;
      
      protected var FWakeStatus:Vector.<int>;
      
      public function TWakeHeroAttributes()
      {
         super();
         this.FHeroIds = new Vector.<int>();
         this.FAttributes = new Vector.<TWakeProperties>();
         this.FWakeLevels = new Vector.<int>();
         this.FWakeStatus = new Vector.<int>();
         this.FLevelAttributes = new Vector.<Vector.<TWakeProperties>>();
      }
      
      protected function AddPropertiesByLevel(param1:TWakeProperties, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Vector.<int> = null;
         var _loc12_:TWakeUp = null;
         var _loc13_:TWakeUpEquip = null;
         var _loc14_:TAddOther = null;
         _loc12_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_WakeUp,param2) as TWakeUp;
         if(_loc12_ == null)
         {
            return;
         }
         _loc6_ = param4 - param3;
         _loc5_ = param3 + 1;
         while(_loc5_ < _loc6_)
         {
            _loc11_ = _loc12_.GetIndexsByWakeLevel(_loc5_);
            _loc8_ = int(_loc11_.length);
            _loc7_ = 0;
            while(_loc7_ < _loc8_)
            {
               _loc13_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_WakeUpEquip,_loc11_[_loc7_]) as TWakeUpEquip;
               _loc10_ = _loc13_.PropertyCount;
               _loc9_ = 0;
               while(_loc9_ < _loc10_)
               {
                  _loc14_ = _loc13_.GetPropertyByIndex(_loc9_);
                  param1.AddProperty(_loc14_);
                  _loc9_++;
               }
               _loc7_++;
            }
            _loc5_++;
         }
      }
      
      protected function AddPropertiesByEquip(param1:TWakeProperties, param2:int, param3:int, param4:int, param5:int) : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Vector.<int> = null;
         var _loc11_:TWakeUp = null;
         var _loc12_:TWakeUpEquip = null;
         var _loc13_:TAddOther = null;
         var _loc14_:int = 0;
         var _loc15_:Vector.<int> = null;
         _loc11_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_WakeUp,param2) as TWakeUp;
         if(_loc11_ == null)
         {
            return;
         }
         _loc10_ = _loc11_.GetIndexsByWakeLevel(param3);
         _loc14_ = param5 - param4;
         _loc15_ = new Vector.<int>();
         _loc6_ = 0;
         while(_loc6_ < WakeUpSlotNum)
         {
            if((_loc14_ & 1 << _loc6_) != 0)
            {
               _loc15_.push(_loc6_);
            }
            _loc6_++;
         }
         _loc7_ = int(_loc15_.length);
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc12_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_WakeUpEquip,_loc10_[_loc15_[_loc6_]]) as TWakeUpEquip;
            _loc9_ = _loc12_.PropertyCount;
            _loc8_ = 0;
            while(_loc8_ < _loc9_)
            {
               _loc13_ = _loc12_.GetPropertyByIndex(_loc8_);
               param1.AddProperty(_loc13_);
               _loc8_++;
            }
            _loc6_++;
         }
      }
      
      public function SetProperties(param1:THero) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TWakeProperties = null;
         var _loc4_:int = 0;
         _loc4_ = int(param1.Identifier);
         _loc2_ = this.FHeroIds.indexOf(_loc4_);
         if(_loc2_ == -1)
         {
            this.FHeroIds.push(_loc4_);
            ++this.FLevelAttributes.length;
            _loc3_ = new TWakeProperties();
            this.AddPropertiesByEquip(_loc3_,_loc4_,param1.WakeupLevel,0,param1.WakeupStatus);
            this.FAttributes.push(_loc3_);
            this.FWakeStatus.push(param1.WakeupStatus);
            this.FWakeLevels.push(param1.WakeupLevel);
         }
         else
         {
            _loc3_ = this.FAttributes[_loc2_];
            this.AddPropertiesByEquip(_loc3_,_loc4_,param1.WakeupLevel,this.FWakeStatus[_loc2_],param1.WakeupStatus);
            this.FWakeLevels[_loc2_] = param1.WakeupLevel;
            this.FWakeStatus[_loc2_] = param1.WakeupStatus;
         }
      }
      
      public function DeletePropertiesByHeroId(param1:int) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FHeroIds.indexOf(param1);
         if(_loc2_ != -1)
         {
            this.FHeroIds.splice(_loc2_,1);
            this.FAttributes.splice(_loc2_,1);
            this.FWakeStatus.splice(_loc2_,1);
            this.FWakeLevels.splice(_loc2_,1);
            this.FLevelAttributes.splice(_loc2_,1);
         }
      }
      
      public function GetPropertyByHeroId(param1:int) : TWakeProperties
      {
         var _loc2_:int = 0;
         _loc2_ = this.FHeroIds.indexOf(param1);
         if(_loc2_ == -1)
         {
            return null;
         }
         return this.FAttributes[_loc2_];
      }
      
      public function ClearHeroProperty(param1:int) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FHeroIds.indexOf(param1);
         if(_loc2_ == -1)
         {
            return;
         }
         this.FAttributes[_loc2_].ClearData();
         this.FWakeStatus[_loc2_] = 0;
      }
      
      public function GetProperty(param1:int, param2:int, param3:int) : TWakeProperties
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TWakeProperties = null;
         if(param2 < 0)
         {
            return null;
         }
         _loc4_ = this.FHeroIds.indexOf(param1);
         if(_loc4_ < 0)
         {
            return null;
         }
         if(this.FLevelAttributes[_loc4_] != null && this.FLevelAttributes[_loc4_].length > param2)
         {
            return this.FLevelAttributes[_loc4_][param2];
         }
         _loc6_ = new TWakeProperties();
         this.FLevelAttributes[_loc4_] = new Vector.<TWakeProperties>();
         _loc5_ = 0;
         while(_loc5_ < param3)
         {
            this.AddPropsByLevel(_loc6_,param1,_loc5_);
            this.FLevelAttributes[_loc4_].push(_loc6_.Clone());
            _loc5_++;
         }
         return this.FLevelAttributes[_loc4_][param2];
      }
      
      protected function AddPropsByLevel(param1:TWakeProperties, param2:int, param3:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:TWakeUp = null;
         var _loc9_:TWakeUpEquip = null;
         var _loc10_:TAddOther = null;
         var _loc11_:Vector.<int> = null;
         _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_WakeUp,param2) as TWakeUp;
         if(_loc8_ == null)
         {
            return;
         }
         _loc11_ = _loc8_.GetIndexsByWakeLevel(param3);
         _loc5_ = int(_loc11_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc9_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_WakeUpEquip,_loc11_[_loc4_]) as TWakeUpEquip;
            _loc7_ = _loc9_.PropertyCount;
            _loc6_ = 0;
            while(_loc6_ < _loc7_)
            {
               _loc10_ = _loc9_.GetPropertyByIndex(_loc6_);
               param1.AddProperty(_loc10_);
               _loc6_++;
            }
            _loc4_++;
         }
      }
   }
}

