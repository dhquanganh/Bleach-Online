package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TOrganizationAddition extends TDatebaseVO
   {
      
      protected var FOrgLevel:uint;
      
      protected var FAtkAddition:uint;
      
      protected var FAtkConsume:uint;
      
      protected var FPhysDefAddition:uint;
      
      protected var FPhysDefConsume:uint;
      
      protected var FMagDefAddition:uint;
      
      protected var FMagDefConsume:uint;
      
      protected var FLifeAddition:uint;
      
      protected var FLifeConsume:uint;
      
      protected var FSpeedAddition:uint;
      
      protected var FSpeedConsume:uint;
      
      public function TOrganizationAddition()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FOrgLevel = param1.readUnsignedInt();
         this.FAtkAddition = param1.readUnsignedInt();
         this.FAtkConsume = param1.readUnsignedInt();
         this.FPhysDefAddition = param1.readUnsignedInt();
         this.FPhysDefConsume = param1.readUnsignedInt();
         this.FMagDefAddition = param1.readUnsignedInt();
         this.FMagDefConsume = param1.readUnsignedInt();
         this.FLifeAddition = param1.readUnsignedInt();
         this.FLifeConsume = param1.readUnsignedInt();
         this.FSpeedAddition = param1.readUnsignedInt();
         this.FSpeedConsume = param1.readUnsignedInt();
      }
      
      public function get OrgLevel() : uint
      {
         return this.FOrgLevel;
      }
      
      public function get AtkAddition() : uint
      {
         return this.FAtkAddition;
      }
      
      public function get AtkConsume() : uint
      {
         return this.FAtkConsume;
      }
      
      public function get PhysDefAddition() : uint
      {
         return this.FPhysDefAddition;
      }
      
      public function get MagDefAddition() : uint
      {
         return this.FMagDefAddition;
      }
      
      public function get MagDefConsume() : uint
      {
         return this.FMagDefConsume;
      }
      
      public function get LifeAddition() : uint
      {
         return this.FLifeAddition;
      }
      
      public function get LifeConsume() : uint
      {
         return this.FLifeConsume;
      }
      
      public function get SpeedAddition() : uint
      {
         return this.FSpeedAddition;
      }
      
      public function get SpeedConsume() : uint
      {
         return this.FSpeedConsume;
      }
      
      public function get PhysDefConsume() : uint
      {
         return this.FPhysDefConsume;
      }
   }
}

