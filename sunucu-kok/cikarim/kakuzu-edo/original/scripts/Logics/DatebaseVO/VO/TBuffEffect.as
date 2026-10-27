package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TBuffEffect extends TDatebaseVO
   {
      
      protected var FBuffType:int;
      
      protected var FAlterVect:Vector.<uint>;
      
      protected var FBuffkey:int;
      
      protected var FWeight:int;
      
      protected var FContinued:int;
      
      protected var FName:String;
      
      protected var FDescription:String;
      
      protected var FIconUrl:int;
      
      protected var FAlter:String;
      
      public function TBuffEffect()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         this; //unpopped
         this.FBuffType = param1.readUnsignedInt();
         this.FAlter = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(this.FAlter);
         _loc5_ = _loc4_.alter;
         _loc3_ = int(_loc5_.length);
         this.FAlterVect = new Vector.<uint>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FAlterVect[_loc2_] = _loc5_[_loc2_];
            _loc2_++;
         }
         this.FBuffkey = param1.readUnsignedInt();
         this.FWeight = param1.readUnsignedInt();
         this.FContinued = param1.readUnsignedInt();
         this.FName = TUtilityString.FetchUTF(param1);
         this.FDescription = TUtilityString.FetchUTF(param1);
         this.FIconUrl = param1.readUnsignedInt();
      }
      
      public function get BuffType() : int
      {
         return this.FBuffType;
      }
      
      public function get AlterVect() : Vector.<uint>
      {
         return this.FAlterVect;
      }
      
      public function get Buffkey() : int
      {
         return this.FBuffkey;
      }
      
      public function get Weight() : int
      {
         return this.FWeight;
      }
      
      public function get Continued() : int
      {
         return this.FContinued;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get Description() : String
      {
         return this.FDescription;
      }
      
      public function get IconUrl() : int
      {
         return this.FIconUrl;
      }
      
      public function get Alter() : String
      {
         return this.FAlter;
      }
   }
}

