package Logics.GongFuFight
{
   import Logics.Inventories.TInventories;
   
   public class TGongFuFightPlayerGroup
   {
      
      protected var FPlayersInfor:Vector.<TGongFuFightPlayerInfor>;
      
      protected var FRewards:TInventories;
      
      protected var FRewardID:uint;
      
      public function TGongFuFightPlayerGroup()
      {
         super();
         this.FPlayersInfor = new Vector.<TGongFuFightPlayerInfor>();
         this.FRewards = new TInventories();
      }
      
      public function get PlayersInfor() : Vector.<TGongFuFightPlayerInfor>
      {
         return this.FPlayersInfor;
      }
      
      public function get Rewards() : TInventories
      {
         return this.FRewards;
      }
      
      public function set Rewards(param1:TInventories) : void
      {
         this.FRewards = param1;
      }
      
      public function get RewardID() : uint
      {
         return this.FRewardID;
      }
      
      public function set RewardID(param1:uint) : void
      {
         this.FRewardID = param1;
      }
   }
}

