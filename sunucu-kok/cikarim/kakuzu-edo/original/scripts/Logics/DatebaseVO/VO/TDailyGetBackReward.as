package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TDailyGetBackReward extends TDatebaseVO
   {
      
      protected var FMonster_Gold:uint;
      
      protected var FMonster_Exp:uint;
      
      protected var FOrgBattle_Gold:uint;
      
      protected var FOrgBattle_Exp:uint;
      
      protected var FOrgDefence_Gold:uint;
      
      protected var FOrgDefence_Exp:uint;
      
      protected var FTraitor_Gold:uint;
      
      protected var FTraitor_Exp:uint;
      
      protected var FReward_Gold:Vector.<uint>;
      
      protected var FReward_Exp:Vector.<uint>;
      
      public function TDailyGetBackReward()
      {
         super();
         this.FReward_Gold = new Vector.<uint>();
         this.FReward_Exp = new Vector.<uint>();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FMonster_Gold = param1.readUnsignedInt();
         this.FMonster_Exp = param1.readUnsignedInt();
         this.FOrgBattle_Gold = param1.readUnsignedInt();
         this.FOrgBattle_Exp = param1.readUnsignedInt();
         this.FOrgDefence_Gold = param1.readUnsignedInt();
         this.FOrgDefence_Exp = param1.readUnsignedInt();
         this.FTraitor_Gold = param1.readUnsignedInt();
         this.FTraitor_Exp = param1.readUnsignedInt();
      }
      
      public function get Monster_Gold() : uint
      {
         return this.FMonster_Gold;
      }
      
      public function get Monster_Exp() : uint
      {
         return this.FMonster_Exp;
      }
      
      public function get OrgBattle_Gold() : uint
      {
         return this.FOrgBattle_Gold;
      }
      
      public function get OrgBattle_Exp() : uint
      {
         return this.FOrgBattle_Exp;
      }
      
      public function get OrgDefence_Gold() : uint
      {
         return this.FOrgDefence_Gold;
      }
      
      public function get OrgDefence_Exp() : uint
      {
         return this.FOrgDefence_Exp;
      }
      
      public function get Traitor_Gold() : uint
      {
         return this.FTraitor_Gold;
      }
      
      public function get Traitor_Exp() : uint
      {
         return this.FTraitor_Exp;
      }
      
      public function get Reward_Gold() : Vector.<uint>
      {
         this.FReward_Gold.push(this.FMonster_Gold);
         this.FReward_Gold.push(this.FOrgBattle_Gold);
         this.FReward_Gold.push(this.FOrgDefence_Gold);
         this.FReward_Gold.push(this.FTraitor_Gold);
         return this.FReward_Gold;
      }
      
      public function get Reward_Exp() : Vector.<uint>
      {
         this.FReward_Exp.push(this.FMonster_Exp);
         this.FReward_Exp.push(this.FOrgBattle_Exp);
         this.FReward_Exp.push(this.FOrgDefence_Exp);
         this.FReward_Exp.push(this.FTraitor_Exp);
         return this.FReward_Exp;
      }
   }
}

