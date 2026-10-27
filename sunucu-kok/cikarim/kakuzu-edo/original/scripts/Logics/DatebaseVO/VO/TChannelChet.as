package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TChannelChet extends TDatebaseVO
   {
      
      protected var FName:String;
      
      protected var FAllowSend:int;
      
      protected var FHasCooldown:int;
      
      protected var FCoolTime:int;
      
      protected var FTargetType:int;
      
      protected var FAllowShow:Boolean;
      
      protected var FTextColor:String;
      
      protected var FIsChannel:Boolean;
      
      protected var FCanUseIds:Vector.<uint>;
      
      protected var FNeedAuth:Boolean;
      
      protected var FLevelAnalog:int;
      
      protected var FCanUseId:String;
      
      public function TChannelChet()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         this.FName = TUtilityString.FetchUTF(param1);
         this.FAllowSend = param1.readUnsignedInt();
         this.FHasCooldown = param1.readUnsignedInt();
         this.FCoolTime = param1.readUnsignedInt();
         this.FTargetType = param1.readUnsignedInt();
         this.FAllowShow = param1.readInt() != 0;
         this.FTextColor = TUtilityString.FetchUTF(param1);
         this.FIsChannel = param1.readBoolean();
         this.FCanUseId = TUtilityString.FetchUTF(param1);
         _loc3_ = 0;
         if(!TUtilityString.Empty(this.FCanUseId))
         {
            _loc4_ = this.FCanUseId.split("|");
            _loc3_ = int(_loc4_.length);
         }
         this.FCanUseIds = new Vector.<uint>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FCanUseIds[_loc2_] = _loc4_[_loc2_];
            _loc2_++;
         }
         this.FNeedAuth = param1.readInt() != 0;
         this.FLevelAnalog = param1.readUnsignedInt();
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get AllowSend() : int
      {
         return this.FAllowSend;
      }
      
      public function get HasCooldown() : int
      {
         return this.FHasCooldown;
      }
      
      public function get CoolTime() : int
      {
         return this.FCoolTime;
      }
      
      public function get TargetType() : int
      {
         return this.FTargetType;
      }
      
      public function get AllowShow() : Boolean
      {
         return this.FAllowShow;
      }
      
      public function get TextColor() : String
      {
         return this.FTextColor;
      }
      
      public function get IsChannel() : Boolean
      {
         return this.FIsChannel;
      }
      
      public function get CanUseIds() : Vector.<uint>
      {
         return this.FCanUseIds;
      }
      
      public function get NeedAuth() : Boolean
      {
         return this.FNeedAuth;
      }
      
      public function get LevelAnalog() : int
      {
         return this.FLevelAnalog;
      }
      
      public function get CanUseId() : String
      {
         return this.FCanUseId;
      }
   }
}

