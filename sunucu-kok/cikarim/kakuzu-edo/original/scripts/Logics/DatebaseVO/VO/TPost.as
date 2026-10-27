package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import flash.utils.*;
   import ghostcat.util.data.*;
   
   use namespace ResourcesSpace;
   
   public class TPost extends TDatebaseVO
   {
      
      protected var FChannel:uint;
      
      protected var FShowChannels:Vector.<uint>;
      
      protected var FTemplateTaskFront:String;
      
      protected var FTextColor:uint;
      
      protected var FTextSize:uint;
      
      protected var FEvent:TPostEvent;
      
      protected var FDelay:Vector.<uint>;
      
      public function TPost()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:Object = null;
         this.FChannel = param1.readUnsignedInt();
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = _loc4_.split(",");
         _loc3_ = int(_loc5_.length);
         this.FShowChannels = new Vector.<uint>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FShowChannels[_loc2_] = _loc5_[_loc2_];
            _loc2_++;
         }
         this.FTemplateTaskFront = TUtilityString.FetchUTF(param1);
         this.FTextColor = parseInt(TUtilityString.FetchUTF(param1));
         this.FTextSize = param1.readUnsignedInt();
         _loc4_ = TUtilityString.FetchUTF(param1);
         if(!TUtilityString.Empty(_loc4_))
         {
            _loc6_ = Json.decode(_loc4_) as Object;
         }
         this.FEvent = new TPostEvent(_loc6_);
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_) as Array;
         _loc3_ = int(_loc5_.length);
         this.FDelay = new Vector.<uint>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FDelay[_loc2_] = _loc5_[_loc2_];
            _loc2_++;
         }
      }
      
      public function get Channel() : uint
      {
         return this.FChannel;
      }
      
      public function get ShowChannels() : Vector.<uint>
      {
         return this.FShowChannels;
      }
      
      public function get TemplateTaskFront() : String
      {
         return this.FTemplateTaskFront;
      }
      
      public function get TextColor() : uint
      {
         return this.FTextColor;
      }
      
      public function get TextSize() : uint
      {
         return this.FTextSize;
      }
      
      public function get Event() : TPostEvent
      {
         return this.FEvent;
      }
      
      public function get Delay() : Vector.<uint>
      {
         return this.FDelay;
      }
   }
}

