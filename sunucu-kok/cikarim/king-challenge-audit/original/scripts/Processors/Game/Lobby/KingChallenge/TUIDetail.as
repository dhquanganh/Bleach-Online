package Processors.Game.Lobby.KingChallenge
{
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityTexture;
   import Logics.Characters.THero;
   import Logics.KingChallenge.TFighterInfo;
   import Logics.KingChallenge.TKingChallenge;
   import Logics.Map.TMoudleInfor;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudle;
   import Resources.Constants.CONST_MAP;
   import Resources.Constants.CONST_NETWORK;
   import Utilities.Timing.TUtilityTiming;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TUIDetail extends TUIComponent
   {
      
      protected var FMain:Sprite;
      
      protected var FTF_Power:TextField;
      
      protected var FTF_Name:TextField;
      
      protected var FTF_Score:TextField;
      
      protected var FBtn_Ok:TUIButton;
      
      protected var FTF_Power1:TextField;
      
      protected var FTF_Name1:TextField;
      
      protected var FTF_Score1:TextField;
      
      protected var FBtn_Ok1:TUIButton;
      
      protected var FBtn_CheckReport:TUIButton;
      
      protected var FTime:TextField;
      
      protected var FSpriteMoudle_0:TSceneSpriteMoudle;
      
      protected var FMoudleMountPoint_0:Sprite;
      
      protected var FQureyMoudleInfor_0:TMoudleInfor;
      
      protected var FSpriteMoudle_1:TSceneSpriteMoudle;
      
      protected var FMoudleMountPoint_1:Sprite;
      
      protected var FQureyMoudleInfor_1:TMoudleInfor;
      
      protected var Btn_Close:TUIButton;
      
      protected var FData:TFighterInfo;
      
      public function TUIDetail(param1:TUIComponent)
      {
         super(param1);
         this.FQureyMoudleInfor_0 = new TMoudleInfor();
         this.FQureyMoudleInfor_1 = new TMoudleInfor();
      }
      
      protected function UpdateUI() : void
      {
         var _loc1_:THero = null;
         var _loc2_:THero = null;
         this.Reset();
         if(this.FData == null)
         {
            return;
         }
         if(this.FData.AttUserInfo == null || this.FData.DefUserInfo == null)
         {
            this.FBtn_CheckReport.Enabled = false;
            this.FBtn_Ok.Enabled = false;
            this.FBtn_Ok1.Enabled = false;
            this.FMain["TF_Time"].visible = false;
            this.FMain["MC_Hero_0"]["MC_Lose"].visible = false;
            this.FMain["MC_Hero_1"]["MC_Lose"].visible = false;
            this.FMain["MC_Hero_0"]["TF_Name"].text = this.FData.AttUserInfo == null ? "Tr?ng" : this.FData.AttUserInfo.UserName;
            this.FMain["MC_Hero_1"]["TF_Name"].text = this.FData.DefUserInfo == null ? "Tr?ng" : this.FData.DefUserInfo.UserName;
            this.FMain["TF_CurScore_0"].text = this.FData.Ret == 1 ? "1" : "0";
            this.FMain["TF_CurScore_1"].text = this.FData.Ret == 0 ? "1" : "0";
            if(this.FData.AttUserInfo != null)
            {
               this.FMain["MC_Hero_0"]["TF_Power"].text = this.FData.AttUserInfo.Power + "";
               TUtilityTexture.QueryTwoDirectionShowCase(CONST_MAP.DIRECTION_RIGHT,this.FData.AttUserInfo.ModelId,this.FQureyMoudleInfor_0);
               this.FSpriteMoudle_0.ChangeRoleMoudle(this.FQureyMoudleInfor_0.TextureID,this.FQureyMoudleInfor_0.Scalx);
            }
            if(this.FData.DefUserInfo != null)
            {
               this.FMain["MC_Hero_1"]["TF_Power"].text = this.FData.DefUserInfo.Power + "";
               TUtilityTexture.QueryTwoDirectionShowCase(CONST_MAP.DIRECTION_RIGHT,this.FData.DefUserInfo.ModelId,this.FQureyMoudleInfor_1);
               this.FSpriteMoudle_1.ChangeRoleMoudle(this.FQureyMoudleInfor_1.TextureID,this.FQureyMoudleInfor_1.Scalx);
            }
            return;
         }
         this.FMain["MC_Hero_0"]["TF_Power"].text = this.FData.AttUserInfo.Power + "";
         this.FMain["MC_Hero_0"]["TF_Name"].text = this.FData.AttUserInfo.UserName;
         TUtilityTexture.QueryTwoDirectionShowCase(CONST_MAP.DIRECTION_RIGHT,this.FData.AttUserInfo.ModelId,this.FQureyMoudleInfor_0);
         this.FSpriteMoudle_0.ChangeRoleMoudle(this.FQureyMoudleInfor_0.TextureID,this.FQureyMoudleInfor_0.Scalx);
         if(this.FData.AttUserInfo != null && this.FData.FightNum >= 4000)
         {
            this.FSpriteMoudle_0.OpenRebirthEffect(true,3);
         }
         else
         {
            this.FSpriteMoudle_0.OpenRebirthEffect(false,0);
         }
         if(this.FData.DefUserInfo != null)
         {
            this.FMain["MC_Hero_1"]["TF_Power"].text = this.FData.DefUserInfo.Power + "";
            this.FMain["MC_Hero_1"]["TF_Name"].text = this.FData.DefUserInfo.UserName;
            TUtilityTexture.QueryTwoDirectionShowCase(CONST_MAP.DIRECTION_RIGHT,this.FData.DefUserInfo.ModelId,this.FQureyMoudleInfor_1);
            this.FSpriteMoudle_1.ChangeRoleMoudle(this.FQureyMoudleInfor_1.TextureID,this.FQureyMoudleInfor_1.Scalx);
            if(this.FData.DefUserInfo != null && this.FData.FightNum >= 4000)
            {
               this.FSpriteMoudle_1.OpenRebirthEffect(true,3);
            }
            else
            {
               this.FSpriteMoudle_1.OpenRebirthEffect(false,0);
            }
         }
         if(this.FData.Ret == -1)
         {
            this.FMain["MC_Hero_0"]["MC_Lose"].visible = false;
            this.FMain["MC_Hero_1"]["MC_Lose"].visible = false;
            this.FMain["TF_CurScore_0"].text = "0";
            this.FMain["TF_CurScore_1"].text = "0";
            this.FBtn_CheckReport.Enabled = false;
            this.FBtn_Ok.Enabled = STimingCore.ServerTick < this.FData.GambleTimeEnd && !TKingChallenge.RequestPending;
            this.FBtn_Ok1.Enabled = STimingCore.ServerTick < this.FData.GambleTimeEnd && !TKingChallenge.RequestPending;
         }
         if(this.FData.Ret == 1)
         {
            this.FMain["MC_Hero_0"]["MC_Lose"].visible = false;
            this.FMain["MC_Hero_1"]["MC_Lose"].visible = true;
            this.FMain["TF_CurScore_0"].text = "1";
            this.FMain["TF_CurScore_1"].text = "0";
            this.FBtn_CheckReport.Enabled = this.FData.Report.length > 0;
            this.FBtn_Ok.Enabled = false;
            this.FBtn_Ok1.Enabled = false;
         }
         if(this.FData.Ret == 0)
         {
            this.FMain["MC_Hero_0"]["MC_Lose"].visible = true;
            this.FMain["MC_Hero_1"]["MC_Lose"].visible = false;
            this.FMain["TF_CurScore_0"].text = "0";
            this.FMain["TF_CurScore_1"].text = "1";
            this.FBtn_CheckReport.Enabled = this.FData.Report.length > 0;
            this.FBtn_Ok.Enabled = false;
            this.FBtn_Ok1.Enabled = false;
         }
         if(this.FData.DefUserInfo == null || this.FData.AttUserInfo == null)
         {
            this.FBtn_CheckReport.Enabled = false;
         }
      }
      
      public function LogicsPerform() : void
      {
         if(Visible && this.FMain != null)
         {
            this.FSpriteMoudle_0.UpdateView();
            this.FSpriteMoudle_1.UpdateView();
            if(STimingCore.ServerTick < this.FData.GambleTimeEnd)
            {
               this.FMain["TF_Time"].visible = true;
               this.FMain["TF_Time"]["TF_Elapse"].text = TUtilityTiming.fomatTimeTwo(this.FData.GambleTimeEnd - STimingCore.ServerTick).toString();
            }
            else
            {
               this.FMain["TF_Time"].visible = false;
            }
         }
      }
      
      protected function ProcessorAttGamble(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         if(TKingChallenge.RequestPending || this.FData.Ret != -1 || STimingCore.ServerTick >= this.FData.GambleTimeEnd)
         {
            return;
         }
         TKingChallenge.RequestPending = true;
         this.FBtn_Ok.Enabled = false;
         this.FBtn_Ok1.Enabled = false;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_KingChallenge_BettingReq);
         _loc3_.Data.writeInt(this.FData.FightNum);
         _loc3_.Data.writeUnsignedInt(0);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function ProcessorDefGamble(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         if(TKingChallenge.RequestPending || this.FData.Ret != -1 || STimingCore.ServerTick >= this.FData.GambleTimeEnd)
         {
            return;
         }
         TKingChallenge.RequestPending = true;
         this.FBtn_Ok.Enabled = false;
         this.FBtn_Ok1.Enabled = false;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_KingChallenge_BettingReq);
         _loc3_.Data.writeInt(this.FData.FightNum);
         _loc3_.Data.writeUnsignedInt(1);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function ProcessorHide(param1:Object, param2:MouseEvent) : void
      {
         this.Visible = false;
      }
      
      protected function ProcessorFightReport(param1:Object, param2:MouseEvent) : void
      {
         if(TKingChallenge.RequestPending || this.FData.Report.length == 0)
         {
            return;
         }
         TKingChallenge.RequestPending = true;
         var packet:TPacket = SNetworkCore.PacketAcquire(25266697);
         packet.Data.writeUTF(this.FData.Report);
         SNetworkCore.Transceiver.PacketTransmit(packet);
      }
      
      protected function Reset() : void
      {
         this.FMain["MC_Hero_0"]["TF_Power"].text = "";
         this.FMain["MC_Hero_0"]["TF_Name"].text = "";
         this.FMain["MC_Hero_1"]["TF_Power"].text = "";
         this.FMain["MC_Hero_1"]["TF_Name"].text = "";
         this.FSpriteMoudle_0.Release();
         this.FSpriteMoudle_1.Release();
      }
      
      public function UIDispatch(param1:Sprite) : void
      {
         this.FMain = param1;
         addChild(this.FMain);
         this.Btn_Close = new TUIButton();
         this.Btn_Close.Substrate = this.FMain["Btn_Close"];
         this.Btn_Close.OnClick = this.ProcessorHide;
         this.FBtn_CheckReport = new TUIButton();
         this.FBtn_CheckReport.Substrate = this.FMain["FBtn_CheckReport"];
         this.FBtn_CheckReport.OnClick = this.ProcessorFightReport;
         this.FBtn_Ok = new TUIButton();
         this.FBtn_Ok.Substrate = this.FMain["MC_Hero_0"]["Btn_OK"];
         this.FBtn_Ok.OnClick = this.ProcessorAttGamble;
         this.FBtn_Ok1 = new TUIButton();
         this.FBtn_Ok1.Substrate = this.FMain["MC_Hero_1"]["Btn_OK"];
         this.FBtn_Ok1.OnClick = this.ProcessorDefGamble;
         this.FMoudleMountPoint_0 = this.FMain["MC_Hero_0"]["MC_MountPoint"];
         this.FMoudleMountPoint_0.mouseEnabled = false;
         this.FMoudleMountPoint_0.mouseChildren = false;
         this.FSpriteMoudle_0 = new TSceneSpriteMoudle();
         this.FMoudleMountPoint_0.addChild(this.FSpriteMoudle_0);
         this.FMoudleMountPoint_1 = this.FMain["MC_Hero_1"]["MC_MountPoint"];
         this.FMoudleMountPoint_1.mouseEnabled = false;
         this.FMoudleMountPoint_1.mouseChildren = false;
         this.FSpriteMoudle_1 = new TSceneSpriteMoudle();
         this.FMoudleMountPoint_1.addChild(this.FSpriteMoudle_1);
      }
      
      public function set Data(param1:TFighterInfo) : void
      {
         if(param1 == null)
         {
            return;
         }
         this.FData = param1;
         this.UpdateUI();
      }
   }
}

