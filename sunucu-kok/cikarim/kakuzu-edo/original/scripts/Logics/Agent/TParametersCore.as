package Logics.Agent
{
   import Foundation.Utilities.TUtilityString;
   import Logics.Agent.Spaces.ParametersSpace;
   import flash.utils.Dictionary;
   
   use namespace ParametersSpace;
   
   public class TParametersCore
   {
      
      public static const TYPE_ANTIADDICTION_ADULTHOOD:uint = 1;
      
      protected var FADUrl:String;
      
      protected var FServerHost:String;
      
      protected var FServerPort:uint;
      
      protected var FOperatorUserID:String;
      
      protected var FAgentID:uint;
      
      protected var FServerID:uint;
      
      protected var FClientVersion:uint;
      
      protected var FLoginStringToken:String;
      
      protected var FCdnRoot:String;
      
      protected var FLoginTime:String;
      
      protected var FAntiAddictionState:int;
      
      protected var FPayUrl:String;
      
      protected var FBattleReportUrl:String;
      
      protected var FSupportUrl:String;
      
      protected var FOfficeUrl:String;
      
      protected var FIsNewUser:Boolean;
      
      protected var FIsDebug:Boolean;
      
      protected var FIsCombine:Boolean;
      
      protected var FVersionDir:String;
      
      protected var FShowOW:Boolean;
      
      protected var FResourceConfig:Dictionary;
      
      protected var FIsInitialization:Boolean;
      
      protected var FYellowVipUrl:String;
      
      protected var FYearYellowVipUrl:String;
      
      protected var FIfBaiDuGame:Boolean;
      
      protected var FIfTXGame:Boolean;
      
      public function TParametersCore()
      {
         super();
         this.FADUrl = "";
         this.FServerHost = "";
         this.FServerPort = 0;
         this.FOperatorUserID = "";
         this.FAgentID = 0;
         this.FServerID = 0;
         this.FClientVersion = 0;
         this.FLoginStringToken = "";
         this.FCdnRoot = "";
         this.FLoginTime = "";
         this.FAntiAddictionState = 0;
         this.FPayUrl = "";
         this.FBattleReportUrl = "";
         this.FSupportUrl = "";
         this.FOfficeUrl = "";
         this.FIsNewUser = false;
         this.FIsDebug = false;
         this.FIsCombine = false;
         this.FVersionDir = "";
         this.FShowOW = false;
         this.FYellowVipUrl = "";
         this.FYearYellowVipUrl = "";
         this.FIfBaiDuGame = false;
         this.FIfTXGame = false;
         this.FIsInitialization = false;
      }
      
      ParametersSpace function CoerceProperties(param1:Object) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         this.FServerHost = param1.gatewayIP;
         this.FServerPort = parseInt(param1.gatewayPort);
         this.FOperatorUserID = param1.username;
         this.FAgentID = parseInt(param1.agent);
         this.FServerID = parseInt(param1.server);
         this.FClientVersion = parseInt(param1.version);
         this.FLoginStringToken = param1.token;
         this.FCdnRoot = param1.cdnRoot;
         this.FLoginTime = param1.time;
         this.FAntiAddictionState = parseInt(param1.isAdult);
         this.FPayUrl = param1.payurl;
         this.FBattleReportUrl = param1.fightreporturl;
         this.FSupportUrl = param1.support;
         this.FOfficeUrl = param1.officeurl;
         _loc2_ = uint(param1.isNew);
         this.FIsNewUser = Boolean(_loc2_);
         _loc3_ = uint(param1.isdebug);
         this.FIsDebug = Boolean(_loc3_);
         _loc4_ = uint(param1.isCombin);
         this.FIsCombine = Boolean(_loc4_);
         this.FVersionDir = param1.versiondir == null ? "" : param1.versiondir;
         _loc5_ = uint(param1.showOW);
         this.FShowOW = Boolean(_loc5_);
         this.FYellowVipUrl = param1.yellow_vip_pay;
         this.FYearYellowVipUrl = param1.yellow_year_vip_pay;
         this.FIfBaiDuGame = Boolean(param1.baidu);
         this.FIfTXGame = Boolean(param1.tx);
         this.FADUrl = param1.adUrl;
         if(TUtilityString.Empty(this.FServerHost))
         {
            this.FServerHost = "";
         }
         if(TUtilityString.Empty(this.FOperatorUserID))
         {
            this.FOperatorUserID = "";
         }
         if(TUtilityString.Empty(this.FLoginStringToken))
         {
            this.FLoginStringToken = "";
         }
         if(TUtilityString.Empty(this.FCdnRoot))
         {
            this.FCdnRoot = "";
         }
         if(TUtilityString.Empty(this.FLoginTime))
         {
            this.FLoginTime = "";
         }
         if(TUtilityString.Empty(this.FPayUrl))
         {
            this.FPayUrl = "#";
         }
         if(TUtilityString.Empty(this.FBattleReportUrl))
         {
            this.FBattleReportUrl = "#";
         }
         if(TUtilityString.Empty(this.FSupportUrl))
         {
            this.FSupportUrl = "#";
         }
         if(TUtilityString.Empty(this.FOfficeUrl))
         {
            this.FOfficeUrl = "#";
         }
         if(TUtilityString.Empty(this.FADUrl))
         {
            this.FADUrl = "";
         }
         if(TUtilityString.Empty(this.FVersionDir))
         {
            this.FVersionDir = "";
         }
         this.FIsInitialization = true;
      }
      
      ParametersSpace function CoerceResourceConfig(param1:Dictionary) : void
      {
         this.FResourceConfig = param1;
      }
      
      ParametersSpace function CoerceAntiAddictionState(param1:int) : void
      {
         this.FAntiAddictionState = param1;
      }
      
      public function get OperatorUserID() : String
      {
         return this.FOperatorUserID;
      }
      
      public function get AgentID() : uint
      {
         return this.FAgentID;
      }
      
      public function get ServerID() : uint
      {
         return this.FServerID;
      }
      
      public function get ClientVersion() : uint
      {
         return this.FClientVersion;
      }
      
      public function get LoginStringToken() : String
      {
         return this.FLoginStringToken;
      }
      
      public function get ServerHost() : String
      {
         return this.FServerHost;
      }
      
      public function get ServerPort() : uint
      {
         return this.FServerPort;
      }
      
      public function get CdnRoot() : String
      {
         return this.FCdnRoot;
      }
      
      public function get IsInitialization() : Boolean
      {
         return this.FIsInitialization;
      }
      
      public function get LoginTime() : String
      {
         return this.FLoginTime;
      }
      
      public function get AntiAddictionState() : int
      {
         return this.FAntiAddictionState;
      }
      
      public function get PayUrl() : String
      {
         return this.FPayUrl;
      }
      
      public function get BattleReportUrl() : String
      {
         return this.FBattleReportUrl;
      }
      
      public function get SupportUrl() : String
      {
         return this.FSupportUrl;
      }
      
      public function get OfficeUrl() : String
      {
         return this.FOfficeUrl;
      }
      
      public function get IsNewUser() : Boolean
      {
         return this.FIsNewUser;
      }
      
      public function get IsDebug() : Boolean
      {
         return this.FIsDebug;
      }
      
      public function get IsCombine() : Boolean
      {
         return this.FIsCombine;
      }
      
      public function set IsCombine(param1:Boolean) : void
      {
         this.FIsCombine = param1;
      }
      
      public function get ResourceConfig() : Dictionary
      {
         return this.FResourceConfig;
      }
      
      public function get VersionDir() : String
      {
         return this.FVersionDir;
      }
      
      public function get YellowVipUrl() : String
      {
         return this.FYellowVipUrl;
      }
      
      public function get YearYellowVipUrl() : String
      {
         return this.FYearYellowVipUrl;
      }
      
      public function get IfBaiDuGame() : Boolean
      {
         return this.FIfBaiDuGame;
      }
      
      public function get ADUrl() : String
      {
         return this.FADUrl;
      }
      
      public function get ShowOW() : Boolean
      {
         return this.FShowOW;
      }
      
      public function get IfTXGame() : Boolean
      {
         return this.FIfTXGame;
      }
   }
}

