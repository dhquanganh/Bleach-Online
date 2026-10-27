package Logics.BleachTrain
{
   public class TBleachTrainDatas
   {
      
      protected var FBleachTrainDatas:Vector.<Vector.<TBleachTrainData>>;
      
      protected var FLevelNeed:Vector.<int>;
      
      protected var FTabNames:Vector.<String>;
      
      protected var FBagGroupID:Vector.<uint>;
      
      protected var FVipBags:Vector.<Vector.<TBleachTrainVipBag>>;
      
      public function TBleachTrainDatas()
      {
         super();
         this.FBleachTrainDatas = new Vector.<Vector.<TBleachTrainData>>();
         this.FTabNames = new Vector.<String>();
         this.FVipBags = new Vector.<Vector.<TBleachTrainVipBag>>();
         this.FBagGroupID = new Vector.<uint>();
      }
      
      public function get BleachTrainDatas() : Vector.<Vector.<TBleachTrainData>>
      {
         return this.FBleachTrainDatas;
      }
      
      public function get TabNames() : Vector.<String>
      {
         return this.FTabNames;
      }
      
      public function get VipBags() : Vector.<Vector.<TBleachTrainVipBag>>
      {
         return this.FVipBags;
      }
      
      public function get LevelNeed() : Vector.<int>
      {
         return this.FLevelNeed;
      }
      
      public function set LevelNeed(param1:Vector.<int>) : void
      {
         this.FLevelNeed = param1;
      }
      
      public function get BagGroupID() : Vector.<uint>
      {
         return this.FBagGroupID;
      }
      
      public function GetBleachTrainByID(param1:uint) : TBleachTrainData
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TBleachTrainData = null;
         var _loc7_:Vector.<TBleachTrainData> = null;
         _loc3_ = int(this.FBleachTrainDatas.length);
         _loc2_ = 0;
         loop0:
         while(_loc2_ < _loc3_)
         {
            _loc7_ = this.FBleachTrainDatas[_loc2_];
            _loc5_ = int(_loc7_.length);
            _loc4_ = 0;
            while(true)
            {
               if(_loc4_ >= _loc5_)
               {
                  _loc2_++;
                  continue loop0;
               }
               _loc6_ = _loc7_[_loc4_];
               if(_loc6_.GrowRoadTask.Identifier == param1)
               {
                  break;
               }
               _loc4_++;
            }
            return _loc6_;
         }
         return null;
      }
      
      public function GetVipBag(param1:uint, param2:uint) : TBleachTrainVipBag
      {
         var _loc3_:int = 0;
         _loc3_ = this.FBagGroupID.indexOf(param1);
         return this.FVipBags[_loc3_][param2];
      }
   }
}

