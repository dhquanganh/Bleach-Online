package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TOrganizationBase extends TDatebaseVO
   {
      
      protected var FOrgLevel:uint;
      
      protected var FDayMaxActivity:uint;
      
      protected var FGuildMaxActivity:uint;
      
      protected var FOrgMaxNumber:uint;
      
      protected var FGetMoreSiv:uint;
      
      protected var FGetMoreExp:uint;
      
      protected var FCampUpgradeMoney:uint;
      
      protected var FMuyebattleUpgradeMoney:uint;
      
      protected var FMuyebattleUpgradeAddition:uint;
      
      protected var FMuyeguardUpgradeMoney:uint;
      
      protected var FMuyeguardUpgradeAddition:uint;
      
      protected var FMuyebattleUpgradeAdditionVect:Vector.<uint>;
      
      protected var FMuyeguardUpgradeAdditionVect:Vector.<uint>;
      
      public function TOrganizationBase()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FOrgLevel = param1.readUnsignedInt();
         this.FDayMaxActivity = param1.readUnsignedInt();
         this.FGuildMaxActivity = param1.readUnsignedInt();
         this.FOrgMaxNumber = param1.readUnsignedInt();
         this.FGetMoreSiv = param1.readUnsignedInt();
         this.FGetMoreExp = param1.readUnsignedInt();
         this.FCampUpgradeMoney = param1.readUnsignedInt();
         this.FMuyebattleUpgradeMoney = param1.readUnsignedInt();
         this.FMuyebattleUpgradeAddition = param1.readUnsignedInt();
         this.FMuyeguardUpgradeMoney = param1.readUnsignedInt();
         this.FMuyeguardUpgradeAddition = param1.readUnsignedInt();
      }
      
      public function get OrgLevel() : uint
      {
         return this.FOrgLevel;
      }
      
      public function get OrgMaxNumber() : uint
      {
         return this.FOrgMaxNumber;
      }
      
      public function get GetMoreSiv() : uint
      {
         return this.FGetMoreSiv;
      }
      
      public function get GetMoreExp() : uint
      {
         return this.FGetMoreExp;
      }
      
      public function get CampUpgradeMoney() : uint
      {
         return this.FCampUpgradeMoney;
      }
      
      public function get MuyebattleUpgradeMoney() : uint
      {
         return this.FMuyebattleUpgradeMoney;
      }
      
      public function get MuyebattleUpgradeAddition() : uint
      {
         return this.FMuyebattleUpgradeAddition;
      }
      
      public function get MuyeguardUpgradeMoney() : uint
      {
         return this.FMuyeguardUpgradeMoney;
      }
      
      public function get MuyeguardUpgradeAddition() : uint
      {
         return this.FMuyeguardUpgradeAddition;
      }
      
      public function get MuyebattleUpgradeAdditionVect() : Vector.<uint>
      {
         return this.FMuyebattleUpgradeAdditionVect;
      }
      
      public function get MuyeguardUpgradeAdditionVect() : Vector.<uint>
      {
         return this.FMuyeguardUpgradeAdditionVect;
      }
      
      public function get DayMaxActivity() : uint
      {
         return this.FDayMaxActivity;
      }
      
      public function get GuildMaxActivity() : uint
      {
         return this.FGuildMaxActivity;
      }
   }
}

