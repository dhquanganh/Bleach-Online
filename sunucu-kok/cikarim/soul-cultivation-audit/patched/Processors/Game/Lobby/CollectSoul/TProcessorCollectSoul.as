package Processors.Game.Lobby.CollectSoul
{
   import Foundation.Common.TBounds;
   import Foundation.Network.TPacket;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.SoulCollection.TCollectSoul;
   import Logics.SoulCollection.TSoulCollectionShop;
   import Logics.Streamization.CollectSoul.TUnstreamizerCollectSoul;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NETWORK;
   import flash.utils.ByteArray;
   
   public class TProcessorCollectSoul extends TProcessorLobbyWindows
   {
      
      protected static const WINDOW_WIDTH:int = 774;
      
      protected static const WINDOW_HEIGTH:int = 547;
      
      protected static const SHOPBASE:int = 12000001;
      
      protected static const DAYNUMMAX:uint = 61600007;
      
      protected const RESOURCESID_Swf:uint = 989855744;
      
      protected var FMainWin:TProcessorWindowCollectionSoul;
      
      protected var FBounds:TBounds;
      
      protected var FInited:Boolean;
      
      protected var FUnstreamizer:TUnstreamizerCollectSoul;
      
      protected var FData:TCollectSoul;
      
      protected var FDayMax:uint;
      
      protected var FVipCount:uint;
      
      protected var FShopID:Vector.<uint>;
      
      protected var FShopTime:Vector.<uint>;
      
      public function TProcessorCollectSoul(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FMainWin = new TProcessorWindowCollectionSoul(this);
         this.FMainWin.OnClose = this.ShutDownWindows;
         this.FMainWin.Visible = false;
         this.FBounds = new TBounds();
         this.FBounds.Width = WINDOW_WIDTH;
         this.FBounds.Height = WINDOW_HEIGTH;
         ComponentBoundsCenter(this.FMainWin,this.FBounds);
         this.FUnstreamizer = new TUnstreamizerCollectSoul();
         this.FData = new TCollectSoul();
         this.FInited = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(this.RESOURCESID_Swf);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_CollectSoul_InitRet,this.PacketPerform_SC_InitInfoRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_CollectSoul_MallRet,this.PACKETID_SC_CollectSoul_MallRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_CollectSoul_OperatorRet,this.PACKETID_SC_CollectSoul_OperatorRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_CollectSoul_VipBuyRet,this.PACKETID_SC_CollectSoul_VipBuyRet);
      }
      
      protected function PacketPerform_SC_InitInfoRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:TBins = null;
         var _loc8_:TSoulCollectionShop = null;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc15_:uint = 0;
         var _loc16_:Vector.<uint> = null;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FData.SuperInvs.Clear();
         _loc9_ = param1.Data.readUnsignedInt();
         _loc10_ = param1.Data.readUnsignedInt();
         this.FVipCount = param1.Data.readUnsignedInt();
         _loc11_ = param1.Data.readUnsignedInt();
         _loc12_ = param1.Data.readUnsignedInt();
         _loc13_ = param1.Data.readUnsignedInt();
         _loc14_ = param1.Data.readUnsignedInt();
         _loc15_ = param1.Data.readUnsignedInt();
         _loc3_ = uint(param1.Data.readShort());
         _loc16_ = new Vector.<uint>(_loc3_);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc16_[_loc4_] = param1.Data.readUnsignedInt();
            this.FUnstreamizer.GetInventoryByCongfigID(_loc16_[_loc4_],this.FData.SuperInvs);
            _loc4_++;
         }
         _loc3_ = uint(param1.Data.readShort());
         this.FShopID = new Vector.<uint>(_loc3_);
         this.FShopTime = new Vector.<uint>(_loc3_);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            this.FShopID[_loc4_] = param1.Data.readUnsignedInt();
            this.FShopTime[_loc4_] = param1.Data.readUnsignedInt();
            _loc4_++;
         }
         _loc7_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SoulCollectionShop) as TBins;
         _loc3_ = uint(_loc7_.Count);
         this.FData.CargoStatus = new Vector.<int>(_loc3_);
         _loc5_ = this.FShopID.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc8_ = _loc7_.GetDatebaseByIndex(_loc4_) as TSoulCollectionShop;
            if(_loc8_.Frequency == 1)
            {
               _loc6_ = 0;
               while(_loc6_ < _loc5_)
               {
                  if(this.FShopID[_loc6_] - SHOPBASE == _loc4_)
                  {
                     this.FData.CargoStatus[_loc4_] = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
                  }
                  _loc6_++;
               }
            }
            else
            {
               this.FData.CargoStatus[_loc4_] = 0;
            }
            _loc4_++;
         }
         this.FData.DayNum = _loc10_ - _loc9_;
         this.FData.VipCount = this.FVipCount;
         this.FData.Energy = _loc11_;
         this.FData.JuniorTimer = _loc13_;
         this.FData.SeniorTimer_0 = _loc14_;
         this.FData.SeniorTimer_1 = _loc15_;
         this.FData.SilverFreeCount = _loc12_;
         this.FMainWin.UpdateDataBase(this.FData);
         this.FMainWin.Visible = true;
      }
      
      protected function PACKETID_SC_CollectSoul_MallRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:TBins = null;
         var _loc10_:TSoulCollectionShop = null;
         var _loc11_:uint = 0;
         var _loc12_:String = null;
         var _loc13_:uint = 0;
         var _loc14_:Object = null;
         _loc6_ = param1.Data.readUnsignedInt();
         if(_loc6_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc6_);
            return;
         }
         _loc7_ = param1.Data.readUnsignedInt();
         _loc8_ = param1.Data.readUnsignedInt();
         _loc11_ = param1.Data.readUnsignedInt();
         this.FData.Energy = _loc11_;
         this.RememberSoulClaim(_loc7_,_loc8_);
         _loc9_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SoulCollectionShop) as TBins;
         _loc2_ = uint(_loc9_.Count);
         _loc4_ = this.FShopID.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc10_ = _loc9_.GetDatebaseByIndex(_loc3_) as TSoulCollectionShop;
            if(_loc10_.Frequency == 1)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  if(this.FShopID[_loc5_] - SHOPBASE == _loc3_)
                  {
                     this.FData.CargoStatus[_loc3_] = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
                  }
                  _loc5_++;
               }
            }
            else
            {
               this.FData.CargoStatus[_loc3_] = 0;
            }
            _loc3_++;
         }
         _loc14_ = (_loc9_.GetDatebaseByIdentifier(_loc7_) as TSoulCollectionShop).ExchangeReward;
         _loc12_ = SToolReward.GetNameByTypeCode(_loc14_.type,_loc14_.code);
         _loc13_ = uint(_loc14_.amount);
         SToolReward.ShowMessage(_loc12_ + "*" + _loc13_);
         this.FMainWin.UpdateDataBase(this.FData);
      }
      
      protected function PACKETID_SC_CollectSoul_OperatorRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:Vector.<uint> = null;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = param1.Data.readUnsignedInt();
         _loc6_ = param1.Data.readUnsignedInt();
         _loc7_ = param1.Data.readUnsignedInt();
         _loc8_ = param1.Data.readUnsignedInt();
         _loc9_ = param1.Data.readUnsignedInt();
         _loc10_ = param1.Data.readUnsignedInt();
         this.FData.RetInvs.Clear();
         _loc5_ = uint(param1.Data.readShort());
         _loc11_ = new Vector.<uint>(_loc5_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc11_[_loc4_] = param1.Data.readUnsignedInt();
            this.FUnstreamizer.GetInventoryByCongfigID(_loc11_[_loc4_],this.FData.RetInvs);
            _loc4_++;
         }
         this.FData.DayNum = _loc7_ - _loc6_;
         this.FData.Energy = _loc9_;
         switch(_loc3_)
         {
            case 0:
               this.FData.JuniorTimer = _loc8_;
               break;
            case 2:
               this.FData.SeniorTimer_0 = _loc8_;
               break;
            case 3:
               this.FData.SeniorTimer_1 = _loc8_;
         }
         this.FData.SilverFreeCount = _loc10_;
         this.FMainWin.UpdateDataBase(this.FData);
         this.FMainWin.ShowRet(this.FData.RetInvs);
      }
      
      protected function PACKETID_SC_CollectSoul_VipBuyRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FVipCount = param1.Data.readUnsignedInt();
         this.FData.VipCount = this.FVipCount;
         _loc3_ = param1.Data.readUnsignedInt();
         _loc4_ = param1.Data.readUnsignedInt();
         this.FData.DayNum = _loc4_ - _loc3_;
         this.FMainWin.UpdateDataBase(this.FData);
      }
      
      protected function ShutDownWindows(param1:Object) : void
      {
         ProcessorClose();
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         var _loc2_:TConfigValue = null;
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FMainWin.Load();
            return;
         }
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,DAYNUMMAX) as TConfigValue;
         this.FDayMax = _loc2_.Value as uint;
         this.FUnstreamizer.InitReq();
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
      }
      public function RememberSoulClaim(id:uint,time:uint) : void
      {
         if(this.FShopID == null)this.FShopID = new Vector.<uint>();
         if(this.FShopTime == null)this.FShopTime = new Vector.<uint>();
         var claimIndex:int = this.FShopID.indexOf(id);
         if(claimIndex >= 0)
         {
            this.FShopTime[claimIndex] = time;
         }
         else
         {
            this.FShopID.push(id);
            this.FShopTime.push(time);
         }
      }
   }
}

