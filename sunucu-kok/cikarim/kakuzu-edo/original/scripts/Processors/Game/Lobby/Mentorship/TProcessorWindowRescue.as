package Processors.Game.Lobby.Mentorship
{
   import Components.Pages.*;
   import Components.Standard.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Mentorship.*;
   import Logics.Mentorship.Elements.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Mentorship.Components.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowRescue extends TProcessorLobbyWindow
   {
      
      protected static const Tab_Count:uint = 2;
      
      protected static const STATUS_Friends:uint = 0;
      
      protected static const STATUS_Org:uint = 1;
      
      protected const Capacity_RescueItems:uint = 10;
      
      protected var FMC_Rescue:Sprite;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FMC_RescuePlayers:Sprite;
      
      protected var FTF_Tittle:TextField;
      
      protected var FTF_DynamicTittle:TextField;
      
      protected var FMC_Nobody:Sprite;
      
      protected var FTF_Nobody:TextField;
      
      protected var FTF_Explanation:TextField;
      
      protected var FUIPage:TUIPage;
      
      protected var FPageIndex:int;
      
      protected var FUITab:TUITab;
      
      protected var FTabIndex:int;
      
      protected var FUIItems:Vector.<TUIArrestItem>;
      
      protected var FObj:Object;
      
      protected var FCurrentList:Vector.<Object>;
      
      protected var FOrgList:Vector.<Object>;
      
      protected var FListStatus:int;
      
      protected var FOnRescuePlayer:Function;
      
      public function TProcessorWindowRescue(param1:TUIComponent)
      {
         super(param1);
         this.FUIItems = new Vector.<TUIArrestItem>();
         this.FTabIndex = 0;
         this.FListStatus = STATUS_Org;
         this.FCurrentList = new Vector.<Object>();
         this.FOrgList = new Vector.<Object>();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_MENTORSHIP.RESOURCESID_Swf_Mentorship);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:TextField = null;
         var _loc5_:TUIArrestItem = null;
         var _loc6_:MovieClip = null;
         this.FMC_Rescue = TUtilityReflection.CreateDisplayObjectInstance(CONST_MENTORSHIP.RESOURCE_ClassName_MC_Rescue) as Sprite;
         addChild(this.FMC_Rescue);
         this.FBtn_Close = this.FMC_Rescue[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FTF_Tittle = this.FMC_Rescue[CONST_MENTORSHIP.RESOURCE_Link_TF_Tittle];
         this.FMC_RescuePlayers = this.FMC_Rescue[CONST_MENTORSHIP.RESOURCE_Link_MC_RescuePlayers];
         this.FTF_DynamicTittle = this.FMC_RescuePlayers[CONST_MENTORSHIP.RESOURCE_Link_TF_DynamicTittle];
         this.FMC_Nobody = this.FMC_Rescue[CONST_MENTORSHIP.RESOURCE_Link_MC_Nobody];
         this.FTF_Nobody = this.FMC_Nobody[CONST_MENTORSHIP.RESOURCE_Link_TF_Nobody];
         this.FTF_Explanation = this.FMC_Rescue[CONST_MENTORSHIP.RESOURCE_Link_TF_Explanation];
         this.FUITab = new TUITab(this);
         _loc2_ = Tab_Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc6_ = this.FMC_Rescue[CONST_COMMON.RESOURCE_Link_MC_Tab + _loc1_];
            this.FUITab.SetTabByIndex(_loc6_,_loc1_);
            _loc1_++;
         }
         this.FUITab.OnSwitch = this.TabOnSwitch;
         this.FUITab.Init();
         _loc2_ = this.Capacity_RescueItems;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = new TUIArrestItem(this);
            _loc5_.Resource = this.FMC_RescuePlayers[CONST_MENTORSHIP.RESOURCE_Link_MC_Disciple + _loc1_];
            _loc5_.OnDynamicFunction = this.ProcessorOnRescuePlayer;
            _loc5_.Init();
            this.FUIItems[_loc1_] = _loc5_;
            _loc1_++;
         }
         this.FUIPage = new TUIPage(this);
         _loc3_ = this.FMC_Rescue[CONST_MENTORSHIP.RESOURCE_Link_MC_PageLeft];
         this.FUIPage.ButtonPrevious.Substrate = _loc3_;
         _loc3_ = this.FMC_Rescue[CONST_MENTORSHIP.RESOURCE_Link_MC_PageRight];
         this.FUIPage.ButtonNext.Substrate = _loc3_;
         _loc4_ = this.FMC_Rescue[CONST_MENTORSHIP.RESOURCE_Link_TF_Page];
         this.FUIPage.LabelPage = _loc4_;
         _loc4_.text = "0/0";
         this.FUIPage.PageSize = this.Capacity_RescueItems;
         this.FUIPage.Init();
         this.FUIPage.OnChangePage = this.PageOnChange;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.BTNCloseOnClick,false,0,true);
         super.ResourcesPerform_UILocations();
      }
      
      protected function FilterRescue() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TRescuePlayer = null;
         var _loc4_:TRescue = null;
         var _loc5_:TSOSPlayer = null;
         var _loc6_:TSOS = null;
         var _loc7_:TSystemLanguage = null;
         _loc2_ = this.FCurrentList.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FCurrentList.pop();
            _loc1_++;
         }
         _loc2_ = this.FOrgList.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FOrgList.pop();
            _loc1_++;
         }
         this.FMC_Nobody.visible = false;
         if(this.FObj is TRescue)
         {
            _loc4_ = this.FObj as TRescue;
            _loc2_ = _loc4_.RescueList.length;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc3_ = _loc4_.RescueList[_loc1_];
               this.FCurrentList.push(_loc3_);
               if(_loc3_.From == STATUS_Org)
               {
                  this.FOrgList.push(_loc3_);
               }
               _loc1_++;
            }
            this.FTF_DynamicTittle.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MENTORSHIP_STRING_07);
         }
         else if(this.FObj is TSOS)
         {
            _loc6_ = this.FObj as TSOS;
            _loc2_ = _loc6_.SOSList.length;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc5_ = _loc6_.SOSList[_loc1_];
               this.FCurrentList.push(_loc5_);
               if(_loc5_.From == STATUS_Org)
               {
                  this.FOrgList.push(_loc3_);
               }
               _loc1_++;
            }
            this.FTF_DynamicTittle.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MENTORSHIP_STRING_08);
         }
         if(this.FCurrentList.length == 0)
         {
            this.FMC_Nobody.visible = true;
            if(this.FObj is TRescue)
            {
               _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SystemLanguage,CONST_SYSTEMLANGUAGE.NO_MEMBERSLAVE) as TSystemLanguage;
               if(_loc7_ == null)
               {
                  this.FTF_Nobody.text = "";
               }
               else
               {
                  this.FTF_Nobody.text = _loc7_.Desc;
               }
            }
            else if(this.FObj is TSOS)
            {
               _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SystemLanguage,CONST_SYSTEMLANGUAGE.NO_HELPER) as TSystemLanguage;
               if(_loc7_ == null)
               {
                  this.FTF_Nobody.text = "";
               }
               else
               {
                  this.FTF_Nobody.text = _loc7_.Desc;
               }
            }
         }
         if(this.FObj is TRescue)
         {
            this.FUITab.SetTabShowByIndex(1);
            this.FUITab.Reset();
            this.TabOnSwitch(1);
         }
         else
         {
            this.FUITab.SetTabHideByIndex(1);
            this.FUITab.Reset();
         }
      }
      
      protected function UpdateTittle() : void
      {
         if(this.FObj is TRescue)
         {
            this.FTF_Tittle.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MENTORSHIP_STRING_04);
         }
         else
         {
            this.FTF_Tittle.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MENTORSHIP_STRING_06);
         }
      }
      
      protected function UpdatePageInfo() : void
      {
         this.FPageIndex = 0;
         if(this.FListStatus == STATUS_Friends)
         {
            this.FUIPage.TotalQuantity = this.FCurrentList.length;
         }
         else if(this.FListStatus == STATUS_Org)
         {
            this.FUIPage.TotalQuantity = this.FOrgList.length;
         }
         this.FUIPage.PageIndex = this.FPageIndex;
         this.FUIPage.Update();
      }
      
      protected function UpdateRescueItemsInfo(param1:Vector.<Object>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TUIArrestItem = null;
         if(this.FListStatus == STATUS_Friends)
         {
            _loc3_ = this.FCurrentList.length;
         }
         else if(this.FListStatus == STATUS_Org)
         {
            _loc3_ = this.FOrgList.length;
         }
         _loc4_ = this.Capacity_RescueItems;
         _loc5_ = _loc3_ - this.FPageIndex * _loc4_;
         if(_loc3_ <= 0)
         {
            this.FMC_RescuePlayers.visible = false;
            this.FMC_Nobody.visible = true;
            return;
         }
         this.FMC_RescuePlayers.visible = true;
         this.FMC_Nobody.visible = false;
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc6_ = this.FUIItems[_loc2_];
            _loc6_.Resource.visible = false;
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            if(_loc2_ + this.FPageIndex * _loc4_ >= _loc3_)
            {
               break;
            }
            _loc6_ = this.FUIItems[_loc2_];
            if(this.FListStatus == STATUS_Friends)
            {
               _loc6_.Update(this.FCurrentList[_loc2_ + this.FPageIndex * _loc4_]);
            }
            else if(this.FListStatus == STATUS_Org)
            {
               _loc6_.Update(this.FOrgList[_loc2_ + this.FPageIndex * _loc4_]);
            }
            _loc6_.Resource.visible = true;
            _loc2_++;
         }
      }
      
      protected function UpdateExplanation() : void
      {
         if(this.FObj is TRescue)
         {
            this.FTF_Explanation.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MENTORSHIP_STRING_18);
         }
         else
         {
            this.FTF_Explanation.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.MENTORSHIP_STRING_19);
         }
      }
      
      protected function BTNCloseOnClick(param1:MouseEvent) : void
      {
         this.FListStatus = STATUS_Friends;
         this.FPageIndex = 0;
         this.FTabIndex = 0;
         this.FUITab.TabIndex = this.FTabIndex;
         this.FUITab.Reset();
         ProcessorWindowClose();
      }
      
      protected function ProcessorOnRescuePlayer(param1:Object, param2:Object) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:TRescuePlayer = null;
         var _loc5_:TSOSPlayer = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         if(param2 is TRescuePlayer)
         {
            _loc3_ = CONST_MENTORSHIP.COMMAND_Rescue;
            _loc4_ = param2 as TRescuePlayer;
            _loc6_ = _loc4_.Identifier0;
            _loc7_ = _loc4_.Identifier1;
         }
         else if(param2 is TSOSPlayer)
         {
            _loc3_ = CONST_MENTORSHIP.COMMAND_SOS;
            _loc5_ = param2 as TSOSPlayer;
            _loc6_ = _loc5_.Identifier0;
            _loc7_ = _loc5_.Identifier1;
         }
         if(this.FOnRescuePlayer != null)
         {
            this.FOnRescuePlayer(this,_loc3_,0,_loc6_,_loc7_);
         }
      }
      
      protected function PageOnChange(param1:Object, param2:int) : void
      {
         this.FPageIndex = param2;
         if(this.FListStatus == STATUS_Friends)
         {
            this.UpdateRescueItemsInfo(this.FCurrentList);
         }
         else if(this.FListStatus == STATUS_Org)
         {
            this.UpdateRescueItemsInfo(this.FOrgList);
         }
      }
      
      protected function TabOnSwitch(param1:Object) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1 as int;
         if(_loc2_ == this.FTabIndex)
         {
            return;
         }
         this.FTabIndex = _loc2_;
         if(this.FTabIndex == 0)
         {
            this.FListStatus = STATUS_Friends;
            this.UpdateRescueItemsInfo(this.FCurrentList);
         }
         else if(this.FTabIndex == 1)
         {
            this.FListStatus = STATUS_Org;
            this.UpdateRescueItemsInfo(this.FOrgList);
         }
         this.UpdatePageInfo();
      }
      
      public function get OnRescuePlayer() : Function
      {
         return this.FOnRescuePlayer;
      }
      
      public function set OnRescuePlayer(param1:Function) : void
      {
         this.FOnRescuePlayer = param1;
      }
      
      public function UpdateUI(param1:Object) : void
      {
         this.FObj = param1;
         this.FilterRescue();
         this.UpdatePageInfo();
         this.UpdateTittle();
         this.UpdateRescueItemsInfo(this.FCurrentList);
         this.UpdateExplanation();
      }
   }
}

