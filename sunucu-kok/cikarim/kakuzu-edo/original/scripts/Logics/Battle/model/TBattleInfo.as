package Logics.Battle.model
{
   import ghostcat.util.data.Json;
   
   public class TBattleInfo
   {
      
      protected var FPlayerInfo_1:TGroupRoleInfo;
      
      protected var FPlayerInfo_2:TGroupRoleInfo;
      
      protected var FTotleTurn:int;
      
      protected var FTurnInfos:Vector.<TTurnInfo>;
      
      public function TBattleInfo()
      {
         super();
         this.FPlayerInfo_1 = new TGroupRoleInfo(0);
         this.FPlayerInfo_2 = new TGroupRoleInfo(1);
         this.FTurnInfos = new Vector.<TTurnInfo>();
      }
      
      public function get PlayerInfo_1() : TGroupRoleInfo
      {
         return this.FPlayerInfo_1;
      }
      
      public function set PlayerInfo_1(param1:TGroupRoleInfo) : void
      {
         this.FPlayerInfo_1 = param1;
      }
      
      public function get PlayerInfo_2() : TGroupRoleInfo
      {
         return this.FPlayerInfo_2;
      }
      
      public function set PlayerInfo_2(param1:TGroupRoleInfo) : void
      {
         this.FPlayerInfo_2 = param1;
      }
      
      public function get TotleTurn() : int
      {
         return this.FTotleTurn;
      }
      
      public function set TotleTurn(param1:int) : void
      {
         this.FTotleTurn = param1;
      }
      
      public function get TurnInfos() : Vector.<TTurnInfo>
      {
         return this.FTurnInfos;
      }
      
      public function set TurnInfos(param1:Vector.<TTurnInfo>) : void
      {
         this.FTurnInfos = param1;
      }
      
      public function FillData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TTurnInfo = null;
         _loc2_ = int(this.FTurnInfos.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FTurnInfos[_loc1_];
            _loc3_.FillData();
            _loc1_++;
         }
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TTurnInfo = null;
         this.FTotleTurn = 0;
         this.FPlayerInfo_1.Reset();
         this.FPlayerInfo_2.Reset();
         _loc2_ = int(this.FTurnInfos.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FTurnInfos[_loc1_];
            _loc3_.Reset();
            _loc3_ = null;
            _loc1_++;
         }
         this.FTurnInfos.length = 0;
      }
      
      public function GetRole1SkillById(param1:int) : int
      {
         return this.FPlayerInfo_1.GetSkillById(param1);
      }
      
      public function GetRole2SkillById(param1:int) : int
      {
         return this.FPlayerInfo_2.GetSkillById(param1);
      }
      
      public function SetDataByStr(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:TTurnInfo = null;
         _loc3_ = Json.decode(param1);
         this.FPlayerInfo_1.SetDataByObj(_loc3_.play1);
         this.FPlayerInfo_2.SetDataByObj(_loc3_.play2);
         this.FTotleTurn = _loc3_.TotleTurn;
         _loc2_ = 0;
         while(_loc2_ < this.FTotleTurn)
         {
            _loc4_ = new TTurnInfo();
            _loc4_.SetDataByObj(_loc3_.TurnInfo["Turn" + _loc2_]);
            this.FTurnInfos.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function toString() : String
      {
         var _loc1_:int = 0;
         var _loc2_:TTurnInfo = null;
         var _loc3_:String = null;
         _loc3_ = "{";
         _loc1_ = 0;
         while(_loc1_ < this.FTurnInfos.length)
         {
            _loc2_ = this.FTurnInfos[_loc1_];
            _loc3_ += " \n\"Turn" + _loc1_ + "\":" + _loc2_.toString();
            if(_loc1_ != this.FTurnInfos.length - 1)
            {
               _loc3_ += ",";
            }
            _loc1_++;
         }
         _loc3_ += "}";
         return "{ \"play1\":" + this.FPlayerInfo_1.toString() + ",\n" + " \"play2\":" + this.FPlayerInfo_2.toString() + ",\n" + " \"TotleTurn\":" + this.FTotleTurn + ", \"TurnInfo\":\n " + _loc3_ + "\n}";
      }
   }
}

