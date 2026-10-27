package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.Json.TPayAgent;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDPay extends THDActivityBase
   {
      
      protected var FAgentList:Vector.<TPayAgent>;
      
      protected var FFrameList:Vector.<uint>;
      
      public function THDPay()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:TPayAgent = null;
         var _loc6_:Array = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc4_) as Array;
         _loc3_ = int(_loc6_.length);
         this.FAgentList = new Vector.<TPayAgent>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TPayAgent(_loc6_[_loc2_]);
            this.FAgentList[_loc2_] = _loc5_;
            _loc2_++;
         }
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc4_) as Array;
         _loc3_ = int(_loc6_.length);
         this.FFrameList = new Vector.<uint>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FFrameList[_loc2_] = _loc6_[_loc2_];
            _loc2_++;
         }
      }
      
      public function get AgentList() : Vector.<TPayAgent>
      {
         return this.FAgentList;
      }
      
      public function set AgentList(param1:Vector.<TPayAgent>) : void
      {
         this.FAgentList = param1;
      }
      
      public function get FrameList() : Vector.<uint>
      {
         return this.FFrameList;
      }
      
      public function set FrameList(param1:Vector.<uint>) : void
      {
         this.FFrameList = param1;
      }
      
      public function GetAddressByAgent(param1:uint) : String
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc3_ = this.FAgentList.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FAgentList[_loc2_].AgentId == param1)
            {
               return this.FAgentList[_loc2_].Link;
            }
            _loc2_++;
         }
         return "";
      }
   }
}

