package Logics.HeroNew
{
   import Logics.DatebaseVO.VO.Json.TAddOther;
   
   public class TWakeProperties
   {
      
      protected var FPropTypes:Vector.<int>;
      
      protected var FPropValues:Vector.<Number>;
      
      public function TWakeProperties()
      {
         super();
         this.FPropTypes = new Vector.<int>();
         this.FPropValues = new Vector.<Number>();
      }
      
      public function AddProperty(param1:TAddOther) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         _loc2_ = this.FPropTypes.indexOf(param1.Type);
         _loc3_ = Number(param1.Value);
         if(_loc2_ == -1)
         {
            this.FPropTypes.push(param1.Type);
            this.FPropValues.push(_loc3_);
         }
         else
         {
            this.FPropValues[_loc2_] += _loc3_;
         }
      }
      
      public function ClearData() : void
      {
         this.FPropTypes.length = 0;
         this.FPropValues.length = 0;
      }
      
      public function GetValueByType(param1:int) : Number
      {
         var _loc2_:int = 0;
         _loc2_ = this.FPropTypes.indexOf(param1);
         if(_loc2_ == -1)
         {
            return 0;
         }
         return this.FPropValues[_loc2_];
      }
      
      public function Clone() : TWakeProperties
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TAddOther = null;
         var _loc4_:Object = null;
         var _loc5_:TWakeProperties = null;
         _loc5_ = new TWakeProperties();
         _loc2_ = int(this.FPropTypes.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = new Object();
            _loc4_.type = this.FPropTypes[_loc1_];
            _loc4_.value = this.FPropValues[_loc1_] + "";
            _loc3_ = new TAddOther(_loc4_);
            _loc5_.AddProperty(_loc3_);
            _loc1_++;
         }
         return _loc5_;
      }
   }
}

