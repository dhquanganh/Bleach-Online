package Processors.Game.Lobby.Achievement
{
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Achievenment.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Streamization.Achievement.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TProcessorAchievement extends TProcessorLobbyWindows
   {
      
      public static const CATEGORY_Equipment:uint = CONST_INVENTORY.CATEGORY_Equipment;
      
      public static const CATEGORY_Treasure:uint = CONST_INVENTORY.CATEGORY_Treasure;
      
      protected var WINDOW_WIDTH:int = 913;
      
      protected var WINDOW_HEIGHT:int = 575;
      
      protected var FilterID:int = 60330001;
      
      protected var FProcessorWindowAchievement:TProcessorWindowAchievement;
      
      protected var FBounds:TBounds;
      
      protected var FUnstreamizerAchievement:TUnstreamizerAchievement;
      
      protected var FAchievementClassInfors:Vector.<TAchievementClassInfor>;
      
      protected var FAchievementTitles:Vector.<TTitles>;
      
      protected var FAchievementDataOtherUser:TAchievementInfors;
      
      protected var FAchievementClassInforsOtherUser:Vector.<TAchievementClassInfor>;
      
      protected var FShowOther:Boolean;
      
      protected var FOtherInforLoadOver:Boolean;
      
      protected var FIfAlreadyInitTitle:Boolean;
      private var FTitleTimer:Timer;
      private var FTitleReady:Boolean=false;
      
      protected var FOnUpdateAchievementState:Function;
      
      protected var FOnCompleteNewAchievement:Function;
      
      protected var FOnAchievmentCanGetRewardNotify:Function;
      
      protected var FOnChangeTitle:Function;
      
      protected var FUpdateHeroPower:Function;
      
      protected var FOnFollowAchievement:Function;
      
      public function TProcessorAchievement(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FTitleTimer=new Timer(5000);
         this.FTitleTimer.addEventListener("timer",this.PollTitles);
         this.FTitleTimer.start();
         this.FUnstreamizerAchievement = new TUnstreamizerAchievement();
         this.FAchievementClassInfors = new Vector.<TAchievementClassInfor>();
         this.FAchievementTitles = SLogicsCore.Character.AchievementTitles;
         this.FAchievementClassInforsOtherUser = new Vector.<TAchievementClassInfor>();
         this.FAchievementDataOtherUser = new TAchievementInfors();
         this.FProcessorWindowAchievement = new TProcessorWindowAchievement(this);
         this.FProcessorWindowAchievement.OnClose = this.ProcessorWindowAchievementOnClose;
         this.FProcessorWindowAchievement.AchievementClassInfors = this.FAchievementClassInfors;
         this.FProcessorWindowAchievement.OnHintOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowAchievement.OnHintOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowAchievement.InventoryMouseOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowAchievement.InventoryMouseOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowAchievement.AchievementTitles = this.FAchievementTitles;
         this.FBounds = new TBounds();
         this.FBounds.Width = this.WINDOW_WIDTH;
         this.FBounds.Height = this.WINDOW_HEIGHT;
         ComponentBoundsCenter(this.FProcessorWindowAchievement,this.FBounds);
         this.FBounds = null;
      }
      
      private function PollTitles(event:Object):void
      {
         if(!this.FTitleReady)return;
         try{var packet:TPacket=SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_AchievenmentTitleInforReq);SNetworkCore.Transceiver.PacketTransmit(packet);if(Visible&&!this.FShowOther){packet=SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_AchievementInforReq);SNetworkCore.Transceiver.PacketTransmit(packet);}}catch(error:Error){}
      }
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACHIEVEMENT.RESOURCESID_Achievement);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FIfAlreadyInitTitle = false;
         super.ResourcesPerform_UILocations();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_AchievementInforRet,this.PacketPerform_SC_AchievementInforRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_AchievementRewardRet,this.PacketPerform_SC_AchievementRewardRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_AchievementInforUpdate,this.PacketPerform_SC_AchievementInforUpdate);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_AchievenmentTitleInforRet,this.PacketPerform_SC_AchievementTitleInforRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_EquipAchievenmentTitleRet,this.PacketPerform_SC_EquipAchievenmentTitleRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_AchievenmentTitleUpdate,this.PacketPerform_SC_AchievenmentTitleUpdate);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_OtherUserAchievenmentRet,this.PacketPerform_SC_OtherAchievenmentInforRet);
      }
      
      protected function PacketPerform_SC_AchievementInforRet(param1:TPacket) : void
      {
         var _loc2_:TAchievementInfor = null;
         this.FUnstreamizerAchievement.UnstreamizationServerInfor(param1.Data,SLogicsCore.Character.AchievementData,null);
         _loc2_ = SLogicsCore.Character.AchievementData.GetAchievementByID(CONST_OFFICELADY.OfficeLadyAchievementID);
         if(_loc2_ != null)
         {
            this.NotifyListener(_loc2_);
         }
         this.CheckIfCanGetReward();
         if(Visible&&!this.FShowOther)this.FProcessorWindowAchievement.Update();
      }
      
      protected function PacketPerform_SC_AchievementRewardRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TAchievementInfor = null;
         var _loc5_:String = null;
         _loc2_ = param1.Data.readUnsignedInt();
         _loc3_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc4_ = SLogicsCore.Character.AchievementData.GetAchievementByID(_loc3_);
         _loc4_.IfGotReward = true;
         if(_loc4_.Title != null)
         {
            _loc4_.Title.IfNew = true;
         }
         EffectGenerateText(_loc4_.FlyText);
         this.NotifyListener(_loc4_);
         if(_loc4_.ID == CONST_OFFICELADY.OfficeLadyAchievementID)
         {
            _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Achievement_String_04);
            EffectGenerateText(_loc5_);
         }
         if(Visible)
         {
            this.FProcessorWindowAchievement.Update();
         }
      }
      
      protected function PacketPerform_SC_AchievementInforUpdate(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:TAchievementInfor = null;
         var _loc4_:Boolean = false;
         _loc2_ = param1.Data.readUnsignedInt();
         _loc3_ = SLogicsCore.Character.AchievementData.GetAchievementByID(_loc2_);
         if(_loc3_ == null)
         {
            return;
         }
         _loc4_ = _loc3_.IfComplete;
         this.FUnstreamizerAchievement.UnstreamizationAchievementInforUpdate(param1.Data,SLogicsCore.Character.AchievementData,_loc2_);
         this.NotifyListener(_loc3_);
         if(!_loc4_ && _loc3_.IfComplete && _loc3_.AchievementGroupInfor != null)
         {
            this.NewAchievementComplete(_loc3_);
         }
         if(_loc3_ == SLogicsCore.Character.CurrentFollowAchievement && this.FOnFollowAchievement != null)
         {
            this.FOnFollowAchievement(_loc3_);
         }
      }
      
      protected function PacketPerform_SC_AchievementTitleInforRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         this.FTitleReady=true;
         for(var index:int=0;index<SLogicsCore.Character.AchievementData.Count;index++){
            var achievement:TAchievementInfor=SLogicsCore.Character.AchievementData.GetAchievementByIndex(index);
            if(achievement.Title!=null){achievement.Title.IfGetTitle=false;achievement.Title.IfOverTime=false;achievement.Title.TargetTime=0;}
         }
         this.ChangeCurrentEquipTitle(param1.Data);
         _loc2_ = int(param1.Data.readUnsignedShort());
         this.AddAlreadyGetAchievementTitle(param1.Data,_loc2_);
         if(Visible)this.FProcessorWindowAchievement.Update();
         if(this.FOnChangeTitle != null)
         {
            this.FOnChangeTitle(this);
         }
      }
      
      protected function PacketPerform_SC_EquipAchievenmentTitleRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc2_ = param1.Data;
         _loc4_ = _loc2_.readUnsignedInt();
         if(_loc4_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc4_);
            return;
         }
         this.ChangeCurrentEquipTitle(param1.Data);
         if(this.FUpdateHeroPower != null)
         {
            this.FUpdateHeroPower(this);
         }
         if(Visible)
         {
            this.FProcessorWindowAchievement.Update();
         }
         if(this.FOnChangeTitle != null)
         {
            this.FOnChangeTitle(this);
         }
      }
      
      protected function PacketPerform_SC_AchievenmentTitleUpdate(param1:TPacket) : void
      {
         this.AddAlreadyGetAchievementTitle(param1.Data,1);
         if(Visible)
         {
            this.FProcessorWindowAchievement.Update();
         }
      }
      
      protected function PacketPerform_SC_OtherAchievenmentInforRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FProcessorWindowAchievement.AchievementClassInfors = this.FAchievementClassInforsOtherUser;
         this.FProcessorWindowAchievement.Mode = CONST_ACHIEVEMENT.WINDOWMODE_SHOWOTHER;
         this.ResetAchievementInfor(this.FAchievementDataOtherUser);
         this.ResetAchievementDirectory(this.FAchievementClassInforsOtherUser);
         this.FProcessorWindowAchievement.UserName = TUtilityString.FetchUTF(param1.Data);
         this.FUnstreamizerAchievement.UnstreamizationServerInfor(param1.Data,this.FAchievementDataOtherUser,null);
         this.FOtherInforLoadOver = true;
         if(FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowAchievement.Update();
            this.FProcessorWindowAchievement.visible = true;
         }
      }
      
      protected function ChangeCurrentEquipTitle(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         SLogicsCore.Character.CurrentEquipTitles.Clear();
         _loc3_ = int(param1.readUnsignedShort());
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readUnsignedInt();
            if(_loc4_ != 0)
            {
               if(this.GotTitleByID(_loc4_)!=null)SLogicsCore.Character.CurrentEquipTitles.Add(this.GotTitleByID(_loc4_));
            }
            _loc2_++;
         }
      }
      
      protected function AddAlreadyGetAchievementTitle(param1:ByteArray, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TAchievementSchedule = null;
         var _loc7_:int = 0;
         var _loc8_:TTitle = null;
         var _loc9_:uint = 0;
         _loc3_ = 0;
         while(_loc3_ < param2)
         {
            _loc9_ = param1.readUnsignedInt();
            var expired:Boolean=param1.readByte()==1;
            var expires:uint=param1.readUnsignedInt();
            _loc8_ = this.GotTitleByID(_loc9_);
            if(_loc8_ == null){_loc3_++;continue;}
            _loc7_=0;
            _loc8_.IfOverTime = expired;
            _loc8_.TargetTime = expires;
            _loc8_.IfGetTitle = true;
            _loc5_ = int(_loc8_.AchievementInfor.AchievementSchedules.length);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc6_ = _loc8_.AchievementInfor.AchievementSchedules[_loc4_];
               _loc6_.CurrentSchedule = _loc6_.Value;
               _loc6_.Complete = true;
               _loc7_ += _loc6_.Value;
               _loc4_++;
            }
            _loc8_.AchievementInfor.CurrentSchedule = _loc7_;
            _loc8_.AchievementInfor.IfComplete = true;
            if(_loc8_.AchievementInfor.Rewards.Count == 0)
            {
               _loc8_.AchievementInfor.IfGotReward = true;
            }
            _loc3_++;
         }
      }
      
      protected function GotTitleByID(param1:uint) : TTitle
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:TAchievementInfor = null;
         _loc3_ = int(SLogicsCore.Character.AchievementData.Count);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = SLogicsCore.Character.AchievementData.GetAchievementByIndex(_loc2_);
            if(_loc5_.Title != null && _loc5_.Title.ID == param1)
            {
               return _loc5_.Title;
            }
            _loc2_++;
         }
         return null;
      }
      
      protected function NotifyListener(param1:TAchievementInfor) : void
      {
         if(this.FOnUpdateAchievementState != null)
         {
            this.FOnUpdateAchievementState(this,param1);
         }
      }
      
      protected function NewAchievementComplete(param1:TAchievementInfor) : void
      {
         if(this.FOnCompleteNewAchievement != null)
         {
            this.FOnCompleteNewAchievement(this,param1);
         }
         this.SetAchievementFlash(true);
      }
      
      protected function SetAchievementFlash(param1:Boolean) : void
      {
         if(this.FOnAchievmentCanGetRewardNotify != null)
         {
            this.FOnAchievmentCanGetRewardNotify(this,param1);
         }
      }
      
      protected function CheckIfCanGetReward() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TAchievementInfor = null;
         var _loc4_:TAchievementInfors = null;
         _loc4_ = SLogicsCore.Character.AchievementData;
         _loc2_ = _loc4_.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = _loc4_.GetAchievementByIndex(_loc1_);
            if(_loc3_.IfComplete && !_loc3_.IfGotReward && _loc3_.AchievementGroupInfor != null)
            {
               this.SetAchievementFlash(true);
               return;
            }
            _loc1_++;
         }
         this.SetAchievementFlash(false);
      }
      
      protected function ProcessorWindowAchievementOnClose(param1:Object) : void
      {
         ProcessorClose();
      }
      
      protected function LoadOtherUserAchievmentInfor(param1:ByteArray) : void
      {
         this.FProcessorWindowAchievement.UserName = TUtilityString.FetchUTF(param1);
         this.ResetAchievementInfor(this.FAchievementDataOtherUser);
         this.ResetAchievementDirectory(this.FAchievementClassInforsOtherUser);
      }
      
      protected function ResetAchievementInfor(param1:TAchievementInfors) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TAchievementInfor = null;
         _loc3_ = param1.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.GetAchievementByIndex(_loc2_);
            _loc4_.IfFollow = false;
            _loc4_.IfGotReward = false;
            _loc4_.IfComplete = false;
            _loc4_.IfNew = false;
            _loc4_.CurrentSchedule = 0;
            _loc2_++;
         }
      }
      
      protected function ResetAchievementDirectory(param1:Vector.<TAchievementClassInfor>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TAchievementClassInfor = null;
         var _loc7_:TAchievementGroupInfor = null;
         _loc4_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc6_ = param1[_loc2_];
            _loc5_ = int(_loc6_.AchivementGroups.length);
            _loc3_ = 0;
            while(_loc3_ < _loc5_)
            {
               _loc7_ = _loc6_.AchivementGroups[_loc3_];
               _loc7_.CurrentSchedule = 0;
               _loc3_++;
            }
            _loc2_++;
         }
      }
      
      protected function FilterAchievements(param1:Vector.<TAchievementClassInfor>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Vector.<uint> = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TConfigValue = null;
         _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,this.FilterID) as TConfigValue;
         _loc4_ = Vector.<uint>(_loc7_.Value);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = int(param1.length);
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               param1[_loc5_].DeleteAchievementByID(_loc4_[_loc2_]);
               _loc5_++;
            }
            _loc2_++;
         }
      }
      
      public function set OnUpdateAchievementState(param1:Function) : void
      {
         this.FOnUpdateAchievementState = param1;
      }
      
      public function set OnCompleteNewAchievement(param1:Function) : void
      {
         this.FOnCompleteNewAchievement = param1;
      }
      
      public function set OnFollowAchievement(param1:Function) : void
      {
         this.FOnFollowAchievement = param1;
         this.FProcessorWindowAchievement.OnFollowAchievement = param1;
      }
      
      public function set OnChangeTitle(param1:Function) : void
      {
         this.FOnChangeTitle = param1;
      }
      
      public function set ShowOther(param1:Boolean) : void
      {
         this.FShowOther = param1;
      }
      
      public function set UpdateHeroPower(param1:Function) : void
      {
         this.FUpdateHeroPower = param1;
      }
      
      public function set OnAchievmentCanGetRewardNotify(param1:Function) : void
      {
         this.FOnAchievmentCanGetRewardNotify = param1;
      }
      
      public function LoadAchivementInfor() : void
      {
         this.FUnstreamizerAchievement.UnstreamizationByDataBase(null,SLogicsCore.Character.AchievementData,this.FAchievementClassInfors);
         this.FUnstreamizerAchievement.UnstreamizationByDataBase(null,this.FAchievementDataOtherUser,this.FAchievementClassInforsOtherUser);
         this.FilterAchievements(this.FAchievementClassInforsOtherUser);
         this.FUnstreamizerAchievement.UnstreamizationTitleByDataBase(null,this.FAchievementTitles,this.FAchievementClassInfors);
      }
      
      public function ProcessorOnLoadAchievementServerData() : void
      {
         var _loc1_:TPacket = null;
         var _loc2_:ByteArray = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_AchievementInforReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowAchievement.Load();
            return;
         }
         if(!this.FShowOther)
         {
            this.FProcessorWindowAchievement.AchievementClassInfors = this.FAchievementClassInfors;
            this.FProcessorWindowAchievement.Mode = CONST_ACHIEVEMENT.WINDOWMODE_SHOWME;
            this.FProcessorWindowAchievement.Update();
            this.FProcessorWindowAchievement.visible = true;
         }
         else if(this.FOtherInforLoadOver)
         {
            this.FProcessorWindowAchievement.AchievementClassInfors = this.FAchievementClassInforsOtherUser;
            this.FProcessorWindowAchievement.Mode = CONST_ACHIEVEMENT.WINDOWMODE_SHOWOTHER;
            this.FProcessorWindowAchievement.Update();
            this.FProcessorWindowAchievement.visible = true;
         }
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.FProcessorWindowAchievement.Reset();
         this.FShowOther = false;
         this.FOtherInforLoadOver = false;
         this.CheckIfCanGetReward();
      }
      
      public function RequestShowAchievement(param1:uint, param2:uint) : void
      {
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_OtherUserAchievenmentReq);
         _loc3_.Data.writeUnsignedInt(param1);
         _loc3_.Data.writeUnsignedInt(param2);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         this.FOtherInforLoadOver = false;
      }
      
      public function ShowAchievementInfor(param1:TAchievementInfor) : void
      {
         this.FProcessorWindowAchievement.ShowAchievementInfor(param1);
      }
   }
}

