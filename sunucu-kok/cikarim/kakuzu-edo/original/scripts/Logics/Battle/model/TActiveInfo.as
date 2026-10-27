package Logics.Battle.model
{
   import Debugging.*;
   import flash.utils.*;
   
   public class TActiveInfo
   {
      
      protected var FIndex:int;
      
      protected var FActiveCamp:int;
      
      protected var FActivePos:int;
      
      protected var FSkillEffectId:int;
      
      protected var FActiveType:int;
      
      protected var FTargetCount:int;
      
      protected var FTargetInfos:Vector.<TTargetInfo>;
      
      public function TActiveInfo(param1:int)
      {
         super();
         this.FIndex = param1;
         this.FTargetInfos = new Vector.<TTargetInfo>();
      }
      
      public function get Index() : int
      {
         return this.FIndex;
      }
      
      public function get ActiveCamp() : int
      {
         return this.FActiveCamp;
      }
      
      public function set ActiveCamp(param1:int) : void
      {
         this.FActiveCamp = param1;
      }
      
      public function get ActivePos() : int
      {
         return this.FActivePos;
      }
      
      public function set ActivePos(param1:int) : void
      {
         this.FActivePos = param1;
      }
      
      public function get SkillEffectId() : int
      {
         return this.FSkillEffectId;
      }
      
      public function set SkillEffectId(param1:int) : void
      {
         this.FSkillEffectId = param1;
      }
      
      public function get ActiveType() : int
      {
         return this.FActiveType;
      }
      
      public function set ActiveType(param1:int) : void
      {
         this.FActiveType = param1;
      }
      
      public function get TargetCount() : int
      {
         return this.FTargetCount;
      }
      
      public function set TargetCount(param1:int) : void
      {
         this.FTargetCount = param1;
      }
      
      public function get TargetInfos() : Vector.<TTargetInfo>
      {
         return this.FTargetInfos;
      }
      
      public function FillData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TTargetInfo = null;
         _loc2_ = int(this.FTargetInfos.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FTargetInfos[_loc1_];
            _loc3_.FillData();
            _loc1_++;
         }
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TTargetInfo = null;
         this.FIndex = 0;
         this.FActiveCamp = 0;
         this.FActivePos = 0;
         this.FSkillEffectId = 0;
         this.FTargetCount = 0;
         _loc2_ = int(this.FTargetInfos.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FTargetInfos[_loc1_];
            _loc3_.Reset();
            _loc3_ = null;
            _loc1_++;
         }
         this.FTargetInfos.length = 0;
      }
      
      public function SetDataByObj(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TTargetInfo = null;
         this.FActiveCamp = param1.ActiveCamp;
         this.FActivePos = param1.ActivePos;
         this.FSkillEffectId = param1.SkillId;
         this.FTargetCount = param1.TargetCount;
         this.FActiveType = param1.ActiveType;
         _loc2_ = 0;
         while(_loc2_ < this.FTargetCount)
         {
            _loc3_ = new TTargetInfo(_loc2_);
            _loc3_.SetDataByObj(param1.Target["Target" + _loc2_]);
            this.FTargetInfos.push(_loc3_);
            _loc2_++;
         }
      }
      
      public function toString() : String
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         _loc2_ = "{";
         _loc1_ = 0;
         while(_loc1_ < this.TargetInfos.length)
         {
            _loc2_ += "\n\t\t" + "\"Target" + _loc1_ + "\":" + this.TargetInfos[_loc1_].toString();
            if(_loc1_ != this.TargetInfos.length - 1)
            {
               _loc2_ += ",";
            }
            _loc1_++;
         }
         _loc2_ += "}";
         return "{ \"ActiveCamp\":" + this.FActiveCamp + ", \"ActivePos\":" + this.FActivePos + ", \"SkillId\":" + this.FSkillEffectId + ", \"ActiveType\":" + this.FActiveType + ", \"TargetCount\":" + this.FTargetCount + ", \"Target\":" + _loc2_ + "}";
      }
   }
}

