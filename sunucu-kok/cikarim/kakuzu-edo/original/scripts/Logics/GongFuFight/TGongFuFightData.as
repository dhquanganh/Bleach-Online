package Logics.GongFuFight
{
   public class TGongFuFightData
   {
      
      protected var FPlayerNormalGroups:Vector.<TGongFuFightPlayerGroup>;
      
      protected var FPlayerSuperLevelGroups:Vector.<TGongFuFightPlayerGroup>;
      
      protected var FGongFuFightBaseInfor:TGongFuFightBaseInfor;
      
      protected var FGongFuFightRankInfors:Vector.<TGongFuFightRankInfor>;
      
      protected var FGongFuFightRankEffectNum:int;
      
      protected var FGongFuFightPayInfors:Vector.<TGongFuFightPay>;
      
      protected var FGongFuPayRecord:Vector.<TGongFuFightPayRecord>;
      
      protected var FGongFuPayEffectNum:int;
      
      protected var FGongFuFightRecords:Vector.<TGongFuFightRecord>;
      
      protected var FGongFuRecordEffectNum:int;
      
      protected var FInited:Boolean;
      
      public function TGongFuFightData()
      {
         super();
         this.FPlayerNormalGroups = new Vector.<TGongFuFightPlayerGroup>();
         this.FPlayerSuperLevelGroups = new Vector.<TGongFuFightPlayerGroup>();
         this.FGongFuFightBaseInfor = new TGongFuFightBaseInfor();
         this.FGongFuFightRankInfors = new Vector.<TGongFuFightRankInfor>();
         this.FGongFuFightPayInfors = new Vector.<TGongFuFightPay>();
         this.FGongFuPayRecord = new Vector.<TGongFuFightPayRecord>();
         this.FGongFuFightRecords = new Vector.<TGongFuFightRecord>();
      }
      
      public function get PlayerNormalGroups() : Vector.<TGongFuFightPlayerGroup>
      {
         return this.FPlayerNormalGroups;
      }
      
      public function get PlayerSuperLevelGroups() : Vector.<TGongFuFightPlayerGroup>
      {
         return this.FPlayerSuperLevelGroups;
      }
      
      public function get GongFuFightBaseInfor() : TGongFuFightBaseInfor
      {
         return this.FGongFuFightBaseInfor;
      }
      
      public function get GongFuFightRankInfors() : Vector.<TGongFuFightRankInfor>
      {
         return this.FGongFuFightRankInfors;
      }
      
      public function get GongFuFightRankEffectNum() : int
      {
         return this.FGongFuFightRankEffectNum;
      }
      
      public function set GongFuFightRankEffectNum(param1:int) : void
      {
         this.FGongFuFightRankEffectNum = param1;
      }
      
      public function get GongFuFightPayInfors() : Vector.<TGongFuFightPay>
      {
         return this.FGongFuFightPayInfors;
      }
      
      public function get GongFuPayRecord() : Vector.<TGongFuFightPayRecord>
      {
         return this.FGongFuPayRecord;
      }
      
      public function set GongFuPayRecord(param1:Vector.<TGongFuFightPayRecord>) : void
      {
         this.FGongFuPayRecord = param1;
      }
      
      public function get GongFuPayEffectNum() : int
      {
         return this.FGongFuPayEffectNum;
      }
      
      public function set GongFuPayEffectNum(param1:int) : void
      {
         this.FGongFuPayEffectNum = param1;
      }
      
      public function get GongFuFightRecords() : Vector.<TGongFuFightRecord>
      {
         return this.FGongFuFightRecords;
      }
      
      public function get GongFuRecordEffectNum() : int
      {
         return this.FGongFuRecordEffectNum;
      }
      
      public function set GongFuRecordEffectNum(param1:int) : void
      {
         this.FGongFuRecordEffectNum = param1;
      }
      
      public function get Inited() : Boolean
      {
         return this.FInited;
      }
      
      public function set Inited(param1:Boolean) : void
      {
         this.FInited = param1;
      }
   }
}

