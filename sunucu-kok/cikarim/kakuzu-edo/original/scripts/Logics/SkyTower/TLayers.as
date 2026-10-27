package Logics.SkyTower
{
   public class TLayers
   {
      
      protected var FLayers:Vector.<TLayer>;
      
      protected var FMaxLayer:uint;
      
      public function TLayers()
      {
         super();
         this.FLayers = new Vector.<TLayer>();
      }
      
      protected function SortLayer(param1:TLayer, param2:TLayer) : int
      {
         if(param1.Identifier < param2.Identifier)
         {
            return -1;
         }
         return 1;
      }
      
      public function get Count() : int
      {
         return this.FLayers.length;
      }
      
      public function get MaxLayer() : uint
      {
         return this.FMaxLayer;
      }
      
      public function set MaxLayer(param1:uint) : void
      {
         this.FMaxLayer = param1;
      }
      
      public function GetLayerByIndex(param1:int) : TLayer
      {
         return this.FLayers[param1];
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TLayer = null;
         _loc1_ = int(this.FLayers.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FLayers[_loc2_];
            _loc2_++;
         }
         this.FLayers.length = 0;
      }
      
      public function Add(param1:TLayer) : void
      {
         this.FLayers.push(param1);
      }
      
      public function GetLayerByIdentifier(param1:uint) : TLayer
      {
         var _loc2_:int = 0;
         var _loc3_:TLayer = null;
         var _loc4_:TLayer = null;
         _loc2_ = 0;
         while(_loc2_ < this.Count)
         {
            _loc3_ = this.FLayers[_loc2_];
            if(_loc3_.Identifier == param1)
            {
               _loc4_ = _loc3_;
               break;
            }
            _loc2_++;
         }
         return _loc4_;
      }
      
      public function DeleteByIdentifier(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TLayer = null;
         _loc2_ = 0;
         while(_loc2_ < this.Count)
         {
            _loc3_ = this.FLayers[_loc2_];
            if(_loc3_.Identifier == param1)
            {
               this.FLayers.splice(_loc2_,1);
            }
            _loc2_++;
         }
      }
      
      public function SortLayers() : void
      {
         this.FLayers.sort(this.SortLayer);
      }
   }
}

