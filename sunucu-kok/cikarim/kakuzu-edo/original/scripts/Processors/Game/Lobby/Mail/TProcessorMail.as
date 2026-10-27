package Processors.Game.Lobby.Mail
{
   import Debugging.*;
   import Foundation.Common.*;
   import Foundation.Common.Integer.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.Mail.*;
   import Logics.Streamization.Mail.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.*;
   import Rendering.Overlayers.HelpTips.*;
   import Rendering.Overlayers.Inventories.*;
   import Resources.Constants.*;
   import Utilities.UI.Overlayers.*;
   import flash.utils.*;
   
   public class TProcessorMail extends TProcessorLobbyWindows
   {
      
      public static const SIZE_WindowMail_Width:uint = 466;
      
      public static const SIZE_WindowMail_Height:uint = 435;
      
      public static const SIZE_WindowMail_PosX:uint = 369;
      
      public static const CATEGORY_Equipment:uint = CONST_INVENTORY.CATEGORY_Equipment;
      
      public static const CATEGORY_Treasure:uint = CONST_INVENTORY.CATEGORY_Treasure;
      
      protected var FProcessorWindowMail:TProcessorWindowMail;
      
      protected var FProcessorWindowMailDetail:TProcessorWindowMailDetail;
      
      protected var FBoundsMail:TBounds;
      
      protected var FBWindowMailDetailFadeOut:Boolean;
      
      protected var FMails:TMails;
      
      protected var FIndexList:Vector.<UInt64>;
      
      protected var FUnstreamizerMails:TUnstreamizerMails;
      
      protected var FUnstreamizerMail:TUnstreamizerMail;
      
      protected var FDigest:TDigest;
      
      protected var FOnEffectNewMail:Function;
      
      public function TProcessorMail(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FProcessorWindowMail = new TProcessorWindowMail(this);
         this.FProcessorWindowMail.OnClose = this.ProcessorWindowMailOnClose;
         this.FProcessorWindowMail.OnHelpTipsOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowMail.OnHelpTipsOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowMail.OnOpenMailDetail = this.ProcessorOnOpenMailDetail;
         this.FProcessorWindowMail.OnDelete = this.ProcessorOnDeleteMail;
         this.FProcessorWindowMail.OnReceiveAccessory = this.ProcessorOnReceiveAccessory;
         this.FProcessorWindowMail.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowMail.Visible = false;
         this.FBoundsMail = new TBounds();
         this.FBoundsMail.X = this.FProcessorWindowMail.x;
         this.FBoundsMail.Y = this.FProcessorWindowMail.y;
         this.FBoundsMail.Width = SIZE_WindowMail_Width;
         this.FBoundsMail.Height = SIZE_WindowMail_Height;
         ComponentBoundsCenter(this.FProcessorWindowMail,this.FBoundsMail);
         this.FProcessorWindowMailDetail = new TProcessorWindowMailDetail(this);
         this.FProcessorWindowMailDetail.OnClose = this.ProcessorWindowMailDetailOnClose;
         this.FProcessorWindowMailDetail.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowMailDetail.OnInventoryOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowMailDetail.OnInventoryOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowMailDetail.OnDelete = this.ProcessorOnDeleteMail;
         this.FProcessorWindowMailDetail.OnSendMail = this.ProcessorOnSendMail;
         this.FProcessorWindowMailDetail.OnReceiveAccessory = this.ProcessorOnReceiveAccessory;
         this.FProcessorWindowMailDetail.Visible = false;
         this.FProcessorWindowMailDetail.Y = this.FProcessorWindowMail.Y + 17;
         this.FMails = SLogicsCore.Mails;
         this.FIndexList = new Vector.<UInt64>();
         this.FUnstreamizerMails = new TUnstreamizerMails();
         this.FUnstreamizerMail = new TUnstreamizerMail();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_MAIL.RESOURCESID_SWF_MAIL);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Mail_InitDataRep,this.PerformPacket_SC_Mail_InitDataRep);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Mail_SendMailRep,this.PerformPacket_SC_Mail_SendMailRep);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Mail_DelMailRep,this.PerformPacket_SC_Mail_DelMailRep);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Mail_GetAttachmentRep,this.PerformPacket_SC_Mail_GetAttachmentRep);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Mail_MailRecNtf,this.PerformPacket_SC_Mail_MailRecNtf);
         super.PacketRegisterRoutines();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FBWindowMailDetailFadeOut)
         {
            this.FProcessorWindowMailDetail.alpha += 0.1;
            if(this.FProcessorWindowMailDetail.alpha >= 1)
            {
               this.FBWindowMailDetailFadeOut = false;
            }
         }
      }
      
      protected function PlayNewMailEffect() : void
      {
         if(this.FOnEffectNewMail != null)
         {
            this.FOnEffectNewMail(CONST_SHORTCUTS.POSITION_MainFunction,CONST_SHORTCUTS.TYPE_MainFunction_Mail,this.CheckMailHasRead());
         }
      }
      
      protected function CheckMailHasRead() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TMail = null;
         _loc2_ = uint(this.FMails.Count);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = this.FMails.GetMailByIndex(_loc4_);
            if(_loc3_.Type == TMail.TYPE_Inbox && _loc3_.HasRead == 0)
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      protected function PerformPacket_SC_Mail_InitDataRep(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         _loc2_ = param1.Data;
         _loc3_ = int(_loc2_.readUnsignedInt());
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FUnstreamizerMails.Unstreamize(_loc2_,this.FMails,null);
         this.PlayNewMailEffect();
         if(this.FProcessorWindowMail.Visible)
         {
            this.FProcessorWindowMail.Update();
            this.FProcessorWindowMailDetail.Update();
         }
      }
      
      protected function PerformPacket_SC_Mail_SendMailRep(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         var _loc4_:TMail = null;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         _loc2_ = param1.Data;
         this.FProcessorWindowMail.SetBtnLock(true);
         _loc3_ = int(_loc2_.readUnsignedInt());
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc4_ = SLogicsCore.PoolMail.AcquireMail();
         _loc4_.Type = TMail.TYPE_Sentbox;
         this.FUnstreamizerMail.Unstreamize(_loc2_,_loc4_,null);
         this.FMails.Add(_loc4_);
         if(this.FProcessorWindowMail.Visible)
         {
            this.FProcessorWindowMail.Update();
            this.FProcessorWindowMailDetail.Update();
         }
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MAIL_STRING_10));
      }
      
      protected function PerformPacket_SC_Mail_DelMailRep(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TMail = null;
         var _loc8_:UInt64 = null;
         var _loc9_:uint = 0;
         var _loc10_:int = 0;
         _loc8_ = new UInt64();
         _loc2_ = param1.Data;
         this.FProcessorWindowMail.SetBtnLock(true);
         _loc3_ = int(_loc2_.readUnsignedInt());
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc9_ = uint(_loc2_.readByte());
         _loc5_ = int(_loc2_.readUnsignedShort());
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc8_.High = _loc2_.readUnsignedInt();
            _loc8_.Low = _loc2_.readUnsignedInt();
            _loc10_ = 0;
            while(_loc10_ < this.FMails.Count)
            {
               _loc7_ = this.FMails.GetMailByIndex(_loc10_);
               if(_loc7_ != null && _loc7_.Type == _loc9_ && _loc7_.SortIndex.High == _loc8_.High && _loc7_.SortIndex.Low == _loc8_.Low)
               {
                  this.FMails.Delete(_loc7_);
               }
               _loc10_++;
            }
            _loc4_++;
         }
         this.PlayNewMailEffect();
         if(this.FProcessorWindowMail.Visible)
         {
            this.FProcessorWindowMail.Update();
            this.FProcessorWindowMailDetail.Update();
         }
      }
      
      protected function PerformPacket_SC_Mail_GetAttachmentRep(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:TMail = null;
         var _loc9_:TSystemLanguage = null;
         var _loc10_:uint = 0;
         var _loc11_:int = 0;
         _loc2_ = param1.Data;
         this.FProcessorWindowMail.SetBtnLock(true);
         _loc3_ = int(_loc2_.readUnsignedInt());
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc10_ = CONST_SYSTEMLANGUAGE.Mail_Get_Success;
         _loc9_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SystemLanguage,_loc10_) as TSystemLanguage;
         EffectGenerateText(_loc9_.Desc);
         _loc5_ = uint(this.FMails.Count);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc8_ = this.FMails.GetMailByIndex(_loc4_);
            _loc6_ = this.FIndexList.length;
            _loc11_ = 0;
            while(_loc11_ < _loc6_)
            {
               if(_loc8_ != null && _loc8_.Type == TMail.TYPE_Inbox && _loc8_.SortIndex.High == this.FIndexList[_loc11_].High && _loc8_.SortIndex.Low == this.FIndexList[_loc11_].Low)
               {
                  _loc8_.AccessoryInventories.Clear();
               }
               _loc11_++;
            }
            _loc4_++;
         }
         this.FProcessorWindowMail.Update();
      }
      
      protected function PerformPacket_SC_Mail_MailRecNtf(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:TMail = null;
         _loc2_ = param1.Data;
         _loc3_ = int(_loc2_.readUnsignedInt());
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc6_ = SLogicsCore.PoolMail.AcquireMail();
         _loc6_.Type = TMail.TYPE_Inbox;
         this.FUnstreamizerMail.Unstreamize(_loc2_,_loc6_,null);
         this.FMails.Add(_loc6_);
         if(this.FProcessorWindowMail.Visible)
         {
            this.FProcessorWindowMail.Update();
            this.FProcessorWindowMailDetail.Update();
         }
         this.PlayNewMailEffect();
      }
      
      protected function PerformPacket_CS_Mail_FirstReadMailReq() : void
      {
      }
      
      protected function WindowsReset() : void
      {
         ComponentBoundsCenter(this.FProcessorWindowMail,this.FBoundsMail);
         this.FProcessorWindowMail.Visible = true;
         this.FProcessorWindowMailDetail.Visible = false;
         this.FProcessorWindowMailDetail.alpha = 0;
      }
      
      protected function ProcessorWindowMailOnClose(param1:Object) : void
      {
         ProcessorClose();
         this.FProcessorWindowMailDetail.CloseComboBox();
      }
      
      protected function ProcessorWindowMailDetailOnClose(param1:Object) : void
      {
         this.WindowsReset();
      }
      
      protected function ProcessorOnOpenMailDetail(param1:Object, param2:int, param3:UInt64) : void
      {
         var _loc4_:TPacket = null;
         var _loc5_:ByteArray = null;
         var _loc6_:TMail = null;
         if(this.FProcessorWindowMailDetail.alpha < 1)
         {
            this.FProcessorWindowMail.X = SIZE_WindowMail_PosX - 150;
            this.FProcessorWindowMailDetail.X = this.FProcessorWindowMail.X + 465;
            this.FProcessorWindowMailDetail.Visible = true;
         }
         this.FBWindowMailDetailFadeOut = true;
         this.FProcessorWindowMailDetail.UIUpdate(param2,param3);
         _loc6_ = this.FMails.GetMailByTypeBySortIndex(TMail.TYPE_Inbox,param3);
         switch(param2)
         {
            case 0:
               if(_loc6_.HasRead == 0)
               {
                  _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Mail_FirstReadMailReq);
                  _loc5_ = _loc4_.Data;
                  _loc5_.writeByte(TMail.TYPE_Inbox);
                  _loc5_.writeUnsignedInt(param3.High);
                  _loc5_.writeUnsignedInt(param3.Low);
                  SNetworkCore.Transceiver.PacketTransmit(_loc4_);
                  _loc6_.HasRead = 1;
               }
         }
         this.PlayNewMailEffect();
      }
      
      protected function ProcessorOnDeleteMail(param1:Object, param2:Vector.<UInt64>, param3:uint) : void
      {
         var _loc4_:TPacket = null;
         var _loc5_:ByteArray = null;
         var _loc6_:uint = 0;
         var _loc7_:int = 0;
         var _loc8_:UInt64 = null;
         this.FIndexList = param2;
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Mail_DelMailReq);
         _loc6_ = param2.length;
         _loc5_ = _loc4_.Data;
         _loc5_.writeByte(param3);
         _loc5_.writeShort(_loc6_);
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = param2[_loc7_];
            if(_loc8_ != null)
            {
               _loc5_.writeUnsignedInt(_loc8_.High);
               _loc5_.writeUnsignedInt(_loc8_.Low);
            }
            _loc7_++;
         }
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
      }
      
      protected function ProcessorOnReceiveAccessory(param1:Object, param2:Vector.<UInt64>) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         var _loc7_:UInt64 = null;
         this.WindowsReset();
         _loc7_ = new UInt64();
         this.FIndexList = param2;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Mail_GetAttachmentReq);
         _loc5_ = param2.length;
         _loc4_ = _loc3_.Data;
         _loc4_.writeShort(_loc5_);
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_.High = param2[_loc6_].High;
            _loc7_.Low = param2[_loc6_].Low;
            _loc4_.writeUnsignedInt(_loc7_.High);
            _loc4_.writeUnsignedInt(_loc7_.Low);
            _loc6_++;
         }
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function ProcessorOnSendMail(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         var _loc4_:TMail = null;
         _loc4_ = param1 as TMail;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Mail_SendMailReq);
         _loc3_ = _loc2_.Data;
         TUtilityString.FlushUTF(_loc3_,_loc4_.Name);
         TUtilityString.FlushUTF(_loc3_,_loc4_.Subject);
         TUtilityString.FlushUTF(_loc3_,_loc4_.Detail);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      public function get OnEffectNewMail() : Function
      {
         return this.FOnEffectNewMail;
      }
      
      public function set OnEffectNewMail(param1:Function) : void
      {
         this.FOnEffectNewMail = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:TMail = null;
         super.Mount();
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowMail.Load();
            this.FProcessorWindowMailDetail.Load();
            return;
         }
         this.WindowsReset();
         if(this.FDigest != null)
         {
            this.OpenWriteMail(this.FDigest);
            this.FDigest = null;
         }
         this.FProcessorWindowMail.Update();
         this.FProcessorWindowMail.Visible = true;
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.PlayNewMailEffect();
         this.FProcessorWindowMail.ResetMail();
         this.FProcessorWindowMailDetail.Reset();
      }
      
      public function OpenWriteMail(param1:TDigest) : void
      {
         this.ProcessorOnOpenMailDetail(null,2,UInt64.FromNumber(0));
         this.FProcessorWindowMailDetail.OpenWriteMail(param1);
      }
      
      public function SetWriteMail(param1:Object) : void
      {
         this.FDigest = param1 as TDigest;
      }
   }
}

