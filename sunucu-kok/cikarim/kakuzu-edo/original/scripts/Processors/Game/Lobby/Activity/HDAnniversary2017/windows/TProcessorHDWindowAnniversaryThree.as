package Processors.Game.Lobby.Activity.HDAnniversary2017.windows
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.THDAnniversaryThree;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDAnniversary.TAnniversaryThree;
   import Logics.Log.TLog;
   import Processors.Game.Lobby.Activity.HDActivity.Common.THDScoreExchangeShop;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.CONST_LOG;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import ghostcat.util.data.Json;
   
   public class TProcessorHDWindowAnniversaryThree extends TProcessorHDSingleWindowBase
   {
      
      protected var FBag:TUIButton;
      
      protected var FBtn_Join:TUIButton;
      
      protected var FBtn_Get:TUIButton;
      
      protected var FBtn_Private:TUIButton;
      
      protected var FBtn_ClosePrivate:TUIButton;
      
      protected var FBtn_Shop:TUIButton;
      
      protected var FScoreExchangeShop:THDScoreExchangeShop;
      
      protected var FIsinit:Boolean;
      
      protected var FData:TAnniversaryThree;
      
      protected var FConfig:THDAnniversaryThree;
      
      protected var FOnLoadLog:Function;
      
      public function TProcessorHDWindowAnniversaryThree(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.UpdateUIConfig();
         this.FConfig = FHDActivityConfig as THDAnniversaryThree;
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this.FData = param1 as TAnniversaryThree;
         FScene["TF_Already"].text = this.FData.Already + "";
         FScene["TF_Cost_0"].text = this.FData.Config.OnceNum + "";
         FScene["TF_Score"].text = this.FData.Config.Cost + "";
         this.FBtn_Join.Enabled = this.FData.JoinStatus == 1 ? true : false;
         this.FScoreExchangeShop.Update(this.FData.Score,this.FData.MailStatus);
         if(!this.FIsinit)
         {
            this.SetupScoreShop();
            this.FIsinit = true;
         }
         if(this.FOnLoadLog != null)
         {
            this.FOnLoadLog(CONST_LOG.LOGTYPE_Anniversary,this.LogArrive);
         }
         _loc3_ = 9;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(_loc2_ >= this.FData.RankVec.length)
            {
               FScene["Btn_ServerLog"]["TF_Text_" + _loc2_].visible = FScene["Btn_ServerLog"]["TF_Name_" + _loc2_].visible = FScene["Btn_ServerLog"]["TF_Cost_" + _loc2_].visible = false;
            }
            else
            {
               FScene["Btn_ServerLog"]["TF_Text_" + _loc2_].visible = FScene["Btn_ServerLog"]["TF_Name_" + _loc2_].visible = FScene["Btn_ServerLog"]["TF_Cost_" + _loc2_].visible = true;
               FScene["Btn_ServerLog"]["TF_Text_" + _loc2_].text = TUtilityString.Format(this.FData.Config.Tips[0],this.FData.RankVec[_loc2_].HighID);
               FScene["Btn_ServerLog"]["TF_Name_" + _loc2_].text = this.FData.RankVec[_loc2_].Name;
            }
            _loc2_++;
         }
      }
      
      protected function LogArrive(param1:Vector.<TLog>) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Object = null;
         _loc3_ = 9;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(_loc2_ >= param1.length)
            {
               FScene["MC_Perview"]["TF_Text_" + _loc2_].text = "";
            }
            else
            {
               _loc4_ = Json.decode(param1[_loc2_].Data)[0];
               if(_loc4_.isWin == "1")
               {
                  FScene["MC_Perview"]["TF_Text_" + _loc2_].text = TUtilityString.Format(this.FData.Config.Tips[0],_loc4_.SerialNumber) + this.FData.Config.Tips[1];
               }
               else
               {
                  FScene["MC_Perview"]["TF_Text_" + _loc2_].text = TUtilityString.Format(this.FData.Config.Tips[0],_loc4_.SerialNumber) + this.FData.Config.Tips[2];
               }
            }
            _loc2_++;
         }
      }
      
      protected function ProcessorShop(param1:Object, param2:MouseEvent) : void
      {
         this.FScoreExchangeShop.Visible = true;
         this.FScoreExchangeShop.Update(this.FData.Score,this.FData.MailStatus);
      }
      
      protected function SetupScoreShop() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Vector.<uint> = null;
         var _loc3_:Vector.<Boolean> = null;
         _loc2_ = new Vector.<uint>();
         _loc3_ = new Vector.<Boolean>();
         for each(_loc1_ in this.FData.Config.Mall)
         {
            _loc2_.push(_loc1_.cost);
            _loc3_.push(_loc1_.numLimit == 0);
         }
         this.FScoreExchangeShop.SetupBasicInfo(this.FData.MailInvs,_loc2_,_loc3_);
      }
      
      protected function ExchangeCall(param1:uint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         _loc3_ = this.FData.Config.Mall[param1];
         _loc2_ = uint(_loc3_.cost);
         if(this.FData.Score >= _loc2_)
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc3_.index);
         }
      }
      
      protected function ProcessorShowPrivate(param1:Object, param2:MouseEvent) : void
      {
         FScene["MC_Perview"].visible = !FScene["MC_Perview"].visible;
         if(this.FOnLoadLog != null)
         {
            this.FOnLoadLog(CONST_LOG.LOGTYPE_Anniversary,this.LogArrive);
         }
      }
      
      protected function ProcessorGetAward(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.AwardIndex);
         FScene["MC_Effect2"].play();
      }
      
      protected function ProcessorJoin(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.FData.Config.Cost,this.ProcessorGoldJoin);
      }
      
      protected function ProcessorGoldJoin(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.StartIndex);
      }
      
      protected function ProcessorGiftOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint((param1 as TUIButton).Tag);
         ProcessorOnGiftBoxMove(this,this.FData.Bag,TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function ProcessorGiftOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      public function get OnLoadLog() : Function
      {
         return this.FOnLoadLog;
      }
      
      public function set OnLoadLog(param1:Function) : void
      {
         this.FOnLoadLog = param1;
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.InitWindow(param1);
         this.FBag = new TUIButton();
         this.FBag.Substrate = FScene["MC_Bag"];
         this.FBag.OnMove = this.ProcessorGiftOnMove;
         this.FBag.OnOut = this.ProcessorGiftOnOut;
         this.FBtn_Join = new TUIButton();
         this.FBtn_Join.Substrate = FScene["Btn_Join"];
         this.FBtn_Join.OnClick = this.ProcessorJoin;
         this.FBtn_Get = new TUIButton();
         this.FBtn_Get.Substrate = FScene["Btn_Get"];
         this.FBtn_Get.OnClick = this.ProcessorGetAward;
         this.FBtn_Private = new TUIButton();
         this.FBtn_Private.Substrate = FScene["Btn_PrivateLog"];
         this.FBtn_Private.OnClick = this.ProcessorShowPrivate;
         this.FBtn_ClosePrivate = new TUIButton();
         this.FBtn_ClosePrivate.Substrate = FScene["MC_Perview"]["Btn_ClosePerview"];
         this.FBtn_ClosePrivate.OnClick = this.ProcessorShowPrivate;
         FScene["MC_Perview"].visible = false;
         this.FBtn_Shop = new TUIButton();
         this.FBtn_Shop.Substrate = FScene["Btn_Shop"];
         this.FBtn_Shop.OnClick = this.ProcessorShop;
         this.FScoreExchangeShop = new THDScoreExchangeShop(this);
         this.FScoreExchangeShop.ExchangeCall = this.ExchangeCall;
         this.FScoreExchangeShop.UIDispatch(TUtilityReflection.CreateDisplayObjectInstance("MC_CDGoldShop") as MovieClip);
         FScene["MC_Effect1"].play();
         (FScene["MC_Effect1"] as Sprite).mouseEnabled = false;
         (FScene["MC_Effect1"] as Sprite).mouseChildren = false;
         (FScene["MC_Effect2"] as Sprite).mouseEnabled = false;
         (FScene["MC_Effect2"] as Sprite).mouseChildren = false;
      }
   }
}

