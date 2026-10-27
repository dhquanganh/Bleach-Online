package Processors.Game.Lobby.Mentorship
{
   import Components.Standard.TUIButton;
   import Components.Standard.TUITab;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.TSlaveMessage;
   import Logics.Mentorship.Elements.TDisciple;
   import Logics.Mentorship.TMentorship;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Mentorship.Components.THeroInfo;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_MENTORSHIP;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorWindowInteraction extends TProcessorLobbyWindow
   {
      
      protected const IDENTITY_Freedom:uint = 0;
      
      protected const IDENTITY_Master:uint = 1;
      
      protected const IDENTITY_Disciple:uint = 2;
      
      protected var FMC_Interaction:Sprite;
      
      protected var FBTN_Close:SimpleButton;
      
      protected var FUITab:TUITab;
      
      protected var FTabIndex:int;
      
      protected var FHeroInfo:THeroInfo;
      
      protected var FMCInteractionList:Vector.<TUIButton>;
      
      protected var FIdentity:uint;
      
      protected var FBins:Vector.<TSlaveMessage>;
      
      protected var FDisciple:TDisciple;
      
      protected var FMentorship:TMentorship;
      
      protected var FInitialized:Boolean;
      
      protected var FOnInteraction:Function;
      
      public function TProcessorWindowInteraction(param1:TUIComponent)
      {
         super(param1);
         this.FMCInteractionList = new Vector.<TUIButton>();
         this.FBins = new Vector.<TSlaveMessage>();
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
         var _loc4_:MovieClip = null;
         var _loc5_:TUIButton = null;
         this.FMC_Interaction = TUtilityReflection.CreateDisplayObjectInstance(CONST_MENTORSHIP.RESOURCE_ClassName_MC_Interaction) as Sprite;
         addChild(this.FMC_Interaction);
         this.FBTN_Close = this.FMC_Interaction[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FUITab = new TUITab(this);
         _loc2_ = 2;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_Interaction[CONST_COMMON.RESOURCE_Link_MC_Tab + _loc1_];
            this.FUITab.SetTabByIndex(_loc3_,_loc1_);
            _loc1_++;
         }
         this.FUITab.OnSwitch = this.TabOnSwitch;
         this.FUITab.Init();
         this.FHeroInfo = new THeroInfo(this);
         this.FHeroInfo.Resource = this.FMC_Interaction[CONST_MENTORSHIP.RESOURCE_Link_MC_Hero];
         this.FHeroInfo.Init();
         _loc2_ = CONST_MENTORSHIP.Capacity_InteractionItems;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = new TUIButton();
            _loc5_.Substrate = this.FMC_Interaction[CONST_MENTORSHIP.RESOURCE_Link_MC_Interaction + _loc1_];
            _loc5_.OnClick = this.BTNInteractionOnClick;
            this.FMCInteractionList[_loc1_] = _loc5_;
            _loc1_++;
         }
         this.FInitialized = true;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FBTN_Close.addEventListener(MouseEvent.CLICK,this.BTNCloseOnClick,false,0,true);
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
      }
      
      protected function UpdateInteractionUI() : void
      {
         var _loc1_:TBins = null;
         var _loc2_:TSlaveMessage = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc5_ = this.FBins.length;
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            this.FBins.pop();
            _loc3_++;
         }
         _loc1_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SlaveMessage) as TBins;
         _loc6_ = this.FMCInteractionList.length;
         _loc4_ = 0;
         while(_loc4_ < _loc6_)
         {
            this.FMCInteractionList[_loc4_].Visible = false;
            _loc4_++;
         }
         _loc5_ = uint(_loc1_.Count);
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            _loc2_ = _loc1_.GetDatebaseByIndex(_loc3_) as TSlaveMessage;
            if(this.FIdentity == this.IDENTITY_Master)
            {
               if(_loc2_.Type == this.FTabIndex + 1)
               {
                  this.FBins.push(_loc2_);
               }
            }
            else if(this.FIdentity == this.IDENTITY_Disciple)
            {
               if(_loc2_.Type == this.FTabIndex + 3)
               {
                  this.FBins.push(_loc2_);
               }
            }
            _loc3_++;
         }
         _loc6_ = this.FBins.length;
         _loc4_ = 0;
         while(_loc4_ < _loc6_)
         {
            this.FMCInteractionList[_loc4_].Visible = true;
            this.FMCInteractionList[_loc4_].Substrate["TF_Interaction"].text = this.FBins[_loc4_].EventName;
            _loc4_++;
         }
      }
      
      protected function BTNCloseOnClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function TabOnSwitch(param1:Object) : void
      {
         if(param1 is int)
         {
            this.FTabIndex = param1 as int;
         }
         this.UpdateInteractionUI();
      }
      
      protected function BTNInteractionOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:TSlaveMessage = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:TUIButton = null;
         _loc7_ = param1 as TUIButton;
         _loc3_ = this.FMCInteractionList.indexOf(_loc7_);
         _loc4_ = this.FBins[_loc3_];
         if(_loc4_ != null)
         {
            if(this.FOnInteraction != null)
            {
               if(this.FIdentity == this.IDENTITY_Master)
               {
                  _loc5_ = this.FDisciple.DiscipleID0;
                  _loc6_ = this.FDisciple.DiscipleID1;
               }
               else
               {
                  _loc5_ = uint(SLogicsCore.Character.Identifier0);
                  _loc6_ = uint(SLogicsCore.Character.Identifier1);
               }
               this.FOnInteraction(this,CONST_MENTORSHIP.COMMAND_Interaction,_loc4_.Identifier,_loc5_,_loc6_);
            }
         }
         this.BTNCloseOnClick(null);
      }
      
      public function get OnInteraction() : Function
      {
         return this.FOnInteraction;
      }
      
      public function set OnInteraction(param1:Function) : void
      {
         this.FOnInteraction = param1;
      }
      
      public function UpdateUI(param1:Object) : void
      {
         this.FHeroInfo.Update(param1);
         if(param1 is TMentorship)
         {
            this.FMentorship = param1 as TMentorship;
            this.FIdentity = this.FMentorship.Identity;
         }
         else if(param1 is TDisciple)
         {
            this.FIdentity = this.IDENTITY_Master;
            this.FDisciple = param1 as TDisciple;
         }
         this.FTabIndex = 0;
         this.FUITab.SwithTagManual(this.FTabIndex);
         this.UpdateInteractionUI();
      }
      
      public function Reset() : void
      {
         this.FHeroInfo.Reset();
      }
   }
}

