package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TTreasureLevelup extends TDatebaseVO
   {
      
      protected var FLevel:uint;
      
      protected var FNeedGold:uint;
      
      protected var FUpItem:uint;
      
      protected var FUpLevel:uint;
      
      public function TTreasureLevelup()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FLevel = param1.readUnsignedInt();
         this.FNeedGold = param1.readUnsignedInt();
         this.FUpItem = param1.readUnsignedInt();
         this.FUpLevel = param1.readUnsignedInt();
      }
      
      public function get Level() : uint
      {
         return this.FLevel;
      }
      
      public function set Level(param1:uint) : void
      {
         this.FLevel = param1;
      }
      
      public function get NeedGold() : uint
      {
         return this.FNeedGold;
      }
      
      public function set NeedGold(param1:uint) : void
      {
         this.FNeedGold = param1;
      }
      
      public function get UpItem() : uint
      {
         return this.FUpItem;
      }
      
      public function set UpItem(param1:uint) : void
      {
         this.FUpItem = param1;
      }
      
      public function get UpLevel() : uint
      {
         return this.FUpLevel;
      }
      
      public function set UpLevel(param1:uint) : void
      {
         this.FUpLevel = param1;
      }
   }
}

