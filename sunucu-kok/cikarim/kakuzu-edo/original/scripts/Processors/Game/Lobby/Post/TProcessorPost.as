package Processors.Game.Lobby.Post
{
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HyperStrings.*;
   import Logics.HyperStrings.Elements.*;
   import Logics.Streamization.Post.*;
   import Processors.Game.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TProcessorPost extends TProcessorGame
   {
      
      protected static const TIME_Expired:uint = CONST_POST.TIME_Expired / 1000;
      
      protected var FPoolHyperString:TPoolHyperString;
      
      protected var FUnstreamizerPost:TUnstreamizerPost;
      
      protected var FPostBins:Vector.<TPost>;
      
      protected var FPost:TPost;
      
      protected var FServerDate:Date;
      
      protected var FRunTimes:Boolean;
      
      protected var FStartTime:uint;
      
      protected var FOnPost:Function;
      
      public function TProcessorPost(param1:TUIComponent)
      {
         super(param1);
         this.FPoolHyperString = SLogicsCore.PoolHyperString;
         this.FUnstreamizerPost = new TUnstreamizerPost();
         this.FPostBins = new Vector.<TPost>();
         this.FServerDate = new Date();
         this.FRunTimes = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.ResourceBin.LoadPackagePrimary(CONST_DATEBASEVO.RESOURCE_PACKAGEID);
         SResourcesCore.ResourceBin.LoadPackagePrimary(CONST_DATEBASEVO.RESOURCE_PACKAGEID_Activity);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TPost = null;
         var _loc4_:TBins = null;
         _loc4_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Post);
         _loc2_ = uint(_loc4_.Count);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = _loc4_.GetDatebaseByIndex(_loc1_) as TPost;
            if(_loc3_.Delay.length != 0)
            {
               this.FPostBins.push(_loc3_);
            }
            _loc1_++;
         }
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Post_PostNtf,this.PerformPacket_SC_PostNtf);
      }
      
      protected function PerformPacket_SC_PostNtf(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:TPost = null;
         var _loc5_:THyperString = null;
         _loc2_ = param1.Data;
         _loc5_ = SLogicsCore.PoolHyperString.AcquireHyperString();
         _loc3_ = _loc2_.readUnsignedInt();
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Post,_loc3_) as TPost;
         this.FUnstreamizerPost.Unstreamize(_loc2_,_loc5_,_loc4_);
         if(this.FOnPost != null)
         {
            this.FOnPost(this,_loc5_,_loc4_);
         }
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         this.LogicsPerfom_ActivityNotice();
      }
      
      protected function LogicsPerfom_ActivityNotice() : void
      {
         var _loc1_:Date = null;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:TPost = null;
         var _loc5_:uint = 0;
         this.FServerDate.time = STimingCore.ServerTime * 1000;
         if(this.FRunTimes)
         {
            _loc5_ = STimingCore.ServerTick - this.FStartTime;
            if(_loc5_ > TIME_Expired)
            {
               this.FPost = null;
               this.FRunTimes = false;
            }
            return;
         }
         this.FStartTime = STimingCore.ServerTick;
         _loc3_ = this.FPostBins.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FPostBins[_loc2_];
            if(_loc4_.Delay[0] == this.FServerDate.hours && _loc4_.Delay[1] == this.FServerDate.minutes)
            {
               this.SendSystemMsg(_loc4_);
               this.FRunTimes = true;
               break;
            }
            _loc2_++;
         }
      }
      
      protected function SendSystemMsg(param1:TPost) : void
      {
         var _loc2_:THyperStringElementText = null;
         var _loc3_:THyperString = null;
         if(this.FPost == param1)
         {
            return;
         }
         this.FPost = param1;
         _loc3_ = this.FPoolHyperString.AcquireHyperString();
         _loc2_ = this.FPoolHyperString.AcquireElementText();
         _loc2_.Text = param1.TemplateTaskFront;
         _loc2_.Color = param1.TextColor;
         _loc3_.Add(_loc2_);
         if(this.FOnPost != null)
         {
            this.FOnPost(this,_loc3_,param1);
         }
      }
      
      public function get OnPost() : Function
      {
         return this.FOnPost;
      }
      
      public function set OnPost(param1:Function) : void
      {
         this.FOnPost = param1;
      }
      
      public function test() : void
      {
      }
   }
}

