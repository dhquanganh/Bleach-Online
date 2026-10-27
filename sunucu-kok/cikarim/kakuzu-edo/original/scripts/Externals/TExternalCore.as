package Externals
{
   import Foundation.Utilities.TUtilityString;
   import Logics.Agent.SParametersCore;
   import Logics.SLogicsCore;
   import Resources.Constants.CONST_PLATFORM;
   import Resources.Strings.STRING_COMMON;
   import flash.external.ExternalInterface;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class TExternalCore
   {
      
      private static const PLATFORM_ID_SINA:uint = CONST_PLATFORM.PLATFORM_ID_SINA;
      
      private static const PLATFORM_ID_360:uint = CONST_PLATFORM.PLATFORM_ID_360;
      
      private static const PLATFORM_ID_91Wan:uint = CONST_PLATFORM.PLATFORM_ID_91Wan;
      
      private static const PLATFORM_ID_BaiDuGame:uint = CONST_PLATFORM.PLATFORM_ID_BaiDuGame;
      
      private static const PLATFORM_ID_Vietnam:uint = CONST_PLATFORM.PLATFORM_ID_Vietnam;
      
      private static const PLATFORM_ID_HK_TW_Macao_Joyfun:uint = CONST_PLATFORM.PLATFORM_ID_HK_TW_Macao_Joyfun;
      
      private static const PLATFORM_ID_Brazil:uint = CONST_PLATFORM.PLATFORM_ID_Brazil;
      
      private static const PLATFORM_ID_Microsoft:uint = CONST_PLATFORM.PLATFORM_ID_Microsoft;
      
      protected var FOnYellowVipBuyGold:Function;
      
      public function TExternalCore()
      {
         super();
      }
      
      protected function FetchParameterInt(param1:String) : int
      {
         var Result:int = 0;
         var ParameterFunction:String = param1;
         if(ExternalInterface.available)
         {
            try
            {
               Result = ExternalInterface.call(ParameterFunction);
            }
            catch(CurrentError:Error)
            {
               Result = 0;
            }
         }
         else
         {
            Result = 0;
         }
         return Result;
      }
      
      protected function FetchParameterUInt(param1:String) : uint
      {
         var Result:uint = 0;
         var ParameterFunction:String = param1;
         if(ExternalInterface.available)
         {
            try
            {
               Result = ExternalInterface.call(ParameterFunction);
            }
            catch(CurrentError:Error)
            {
               Result = 0;
            }
         }
         else
         {
            Result = 0;
         }
         return Result;
      }
      
      protected function FetchParameterString(param1:String) : String
      {
         var Result:String = null;
         var ParameterFunction:String = param1;
         if(ExternalInterface.available)
         {
            try
            {
               Result = ExternalInterface.call(ParameterFunction);
               if(TUtilityString.Empty(Result))
               {
                  Result = null;
               }
            }
            catch(CurrentError:Error)
            {
               Result = null;
            }
         }
         else
         {
            Result = null;
         }
         return Result;
      }
      
      protected function NavigateToUrl(param1:String, param2:String = "_blank") : void
      {
         var _loc3_:URLRequest = null;
         if(TUtilityString.Empty(param1))
         {
            return;
         }
         _loc3_ = new URLRequest(param1);
         navigateToURL(_loc3_,param2);
      }
      
      public function set OnYellowVipBuyGold(param1:Function) : void
      {
         this.FOnYellowVipBuyGold = param1;
      }
      
      public function NavigateToLinkUrl(param1:String) : void
      {
         this.NavigateToUrl(param1);
      }
      
      public function NavigateToRechargeUrl(param1:String) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 1;
         if(SParametersCore.IfTXGame)
         {
            if(ExternalInterface.available)
            {
               _loc2_ = ExternalInterface.call("temporaryClose");
            }
            if(Boolean(_loc2_))
            {
               if(this.FOnYellowVipBuyGold != null)
               {
                  this.FOnYellowVipBuyGold(this);
               }
            }
            return;
         }
         if(false)
         {
            if(ExternalInterface.available)
            {
               ExternalInterface.call("playxpPay");
            }
            return;
         }
         if(SParametersCore.AgentID == PLATFORM_ID_HK_TW_Macao_Joyfun || SParametersCore.AgentID == PLATFORM_ID_Vietnam)
         {
            if(ExternalInterface.available)
            {
               ExternalInterface.call("gamePay");
            }
            return;
         }
         if(SParametersCore.AgentID == PLATFORM_ID_Brazil)
         {
            if(ExternalInterface.available)
            {
               ExternalInterface.call("pay");
            }
            return;
         }
         if(SParametersCore.AgentID == PLATFORM_ID_Microsoft)
         {
            if(ExternalInterface.available)
            {
               ExternalInterface.call("winPay");
            }
            return;
         }
         this.NavigateToUrl(param1);
      }
      
      public function NavigateToBattleReportUrl(param1:String) : void
      {
         var _loc2_:String = null;
         _loc2_ = TUtilityString.Format(STRING_COMMON.COMMON_BATTLEREPORTURL,SParametersCore.BattleReportUrl,param1,SLogicsCore.MainServerID,STRING_COMMON.BATTLEREPORT_FOLDERNAME);
         this.NavigateToUrl(_loc2_);
      }
      
      public function NavigatePayBox(param1:int) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("myRecharge",param1);
         }
      }
      
      public function GameURLNavigate(param1:String) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("ClientURLNavigate",param1);
         }
      }
      
      public function GameStatistical(param1:uint) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("analyUser",SParametersCore.AgentID,param1,int(SParametersCore.IsNewUser),SParametersCore.OperatorUserID,SParametersCore.ServerID);
         }
      }
      
      public function ReloadGame() : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("reloadgame");
         }
      }
      
      public function GameDropLog(param1:String) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("flash_log",param1);
         }
      }
      
      public function CollectGame(param1:String, param2:String) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("addBookmark",param1,param2);
         }
      }
      
      public function FilterMsg(param1:String, param2:uint, param3:String, param4:String, param5:String, param6:int) : void
      {
         var _loc7_:uint = 0;
         _loc7_ = uint(SParametersCore.AgentID);
         if(_loc7_ == PLATFORM_ID_360)
         {
            if(ExternalInterface.available)
            {
               ExternalInterface.call("filterMsg",SParametersCore.ServerID,param1,param2,param3,param4,param5,param6);
            }
         }
         else if(_loc7_ == PLATFORM_ID_91Wan)
         {
            if(ExternalInterface.available)
            {
               ExternalInterface.call("filterMsg",SParametersCore.ServerID,param1,param2,param5,param6);
            }
         }
      }
      
      public function PushPlayerInfo(param1:String, param2:uint) : void
      {
         var _loc3_:int = 0;
         if(SParametersCore.AgentID == PLATFORM_ID_HK_TW_Macao_Joyfun)
         {
            switch(param2)
            {
               case 13:
                  _loc3_ = 2;
                  break;
               case 40:
                  _loc3_ = 3;
                  break;
               case 55:
                  _loc3_ = 4;
            }
            if(_loc3_ != 0 && ExternalInterface.available)
            {
               ExternalInterface.call("collection",_loc3_.toString(),SParametersCore.ServerID);
            }
            return;
         }
         if(SParametersCore.AgentID == PLATFORM_ID_Vietnam)
         {
            if(ExternalInterface.available)
            {
               ExternalInterface.call("collection",SParametersCore.OperatorUserID,SParametersCore.ServerID,param2);
            }
            return;
         }
         if(ExternalInterface.available)
         {
            ExternalInterface.call("pushPlayer",SParametersCore.ServerID,param1,param2);
         }
      }
      
      public function GetRolePost() : void
      {
         if(SParametersCore.AgentID == PLATFORM_ID_BaiDuGame)
         {
            if(ExternalInterface.available)
            {
               ExternalInterface.call("gameRolePost",SParametersCore.ServerID,SParametersCore.OperatorUserID);
            }
         }
      }
      
      public function onMemberIcon() : void
      {
         if(SParametersCore.AgentID == PLATFORM_ID_BaiDuGame)
         {
            if(ExternalInterface.available)
            {
               ExternalInterface.call("member_icon",SParametersCore.OperatorUserID);
            }
         }
      }
      
      public function onOpenButton() : void
      {
         if(SParametersCore.AgentID == PLATFORM_ID_BaiDuGame)
         {
            if(ExternalInterface.available)
            {
               ExternalInterface.call("open_button",SParametersCore.OperatorUserID);
            }
         }
      }
      
      public function CreateRole(param1:String) : void
      {
         if(SParametersCore.AgentID == PLATFORM_ID_SINA)
         {
            if(ExternalInterface.available)
            {
               ExternalInterface.call("createRole",param1);
            }
         }
         else if(SParametersCore.AgentID == PLATFORM_ID_BaiDuGame)
         {
            if(ExternalInterface.available)
            {
               ExternalInterface.call("gameRolePost",SParametersCore.ServerID,SParametersCore.OperatorUserID);
            }
         }
         else if(SParametersCore.AgentID == PLATFORM_ID_Vietnam)
         {
            if(ExternalInterface.available)
            {
               ExternalInterface.call("collection",SParametersCore.OperatorUserID,SParametersCore.ServerID,"1");
            }
         }
         else if(SParametersCore.AgentID == PLATFORM_ID_HK_TW_Macao_Joyfun)
         {
            if(ExternalInterface.available)
            {
               ExternalInterface.call("collection","1",SParametersCore.ServerID);
            }
         }
      }
      
      public function OpenAnnouncement() : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("notice");
         }
      }
      
      public function OpenAnnouncementForcibly() : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("gameNotice");
         }
      }
      
      public function FBBuyGoldRequest(param1:int) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("fb_pay",param1);
         }
      }
      
      public function FBLevel30Notify() : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("checkReg");
         }
      }
      
      public function FBInvitableRequest() : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("fb_invitable");
         }
      }
      
      public function FBUserRegister() : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("pushad");
         }
      }
      
      public function OpenADURL() : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("showAd");
         }
      }
      
      public function OpenGoodAssess() : void
      {
         if(ExternalInterface.available)
         {
         }
      }
      
      public function OpenShareFriend() : void
      {
         if(ExternalInterface.available)
         {
         }
      }
      
      public function OpenPlatformSync() : void
      {
         if(ExternalInterface.available)
         {
         }
      }
      
      public function ExportPlayer() : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("exportPlayer");
         }
      }
   }
}

