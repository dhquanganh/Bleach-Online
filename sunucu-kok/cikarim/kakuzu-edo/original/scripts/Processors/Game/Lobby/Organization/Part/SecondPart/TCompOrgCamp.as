package Processors.Game.Lobby.Organization.Part.SecondPart
{
   import Components.Pages.TUIPage;
   import Components.ScrollBar.TScrollBar;
   import Components.ScrollBar.TScrollBarSimple;
   import Components.ScrollBar.TScrollTextField;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.TSystemLanguage;
   import Logics.Organization.TBaseOrganization;
   import Processors.Game.Lobby.Organization.Component.TUIOrgActivitySlot;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_ORGANIZATION;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class TCompOrgCamp extends TUIComponent
   {
      
      protected static const TYPE_ORGACTIVITY_CAMP:uint = CONST_ORGANIZATION.TYPE_ORGACTIVITY_CAMP;
      
      protected static const TYPE_ORGACTIVITY_MUYEGUARD:uint = CONST_ORGANIZATION.TYPE_ORGACTIVITY_MUYEGUARD;
      
      protected static const TYPE_ORGACTIVITY_PETBATTLE:uint = CONST_ORGANIZATION.TYPE_ORGACTIVITY_PETBATTLE;
      
      protected static const TYPE_ORGACTIVITY_MUYEBATTLE:uint = CONST_ORGANIZATION.TYPE_ORGACTIVITY_MUYEBATTLE;
      
      protected static const MAX_ORGACTIVITY_COUNT:uint = 3;
      
      protected var FIsInitialization:Boolean;
      
      protected var FMC:MovieClip;
      
      protected var FMC_PageLeft:MovieClip;
      
      protected var FMC_PageRight:MovieClip;
      
      protected var FMC_OrgActivitySlot:MovieClip;
      
      protected var FMC_OrgActivityInfo:MovieClip;
      
      protected var FMC_OrgActivityPic:MovieClip;
      
      protected var FTF_OrgActivityInfo:TextField;
      
      protected var FMC_Select:MovieClip;
      
      protected var FMC_List:MovieClip;
      
      protected var FScrollBar:TScrollBar;
      
      protected var FScrollTextField:TScrollTextField;
      
      protected var FScorll:TScrollBarSimple;
      
      protected var FSelectMc_OriginalX:Number = 32;
      
      protected var FSelectMc_OriginalY:Number = 7;
      
      protected var FActivityMc_Width:Number = 171;
      
      protected var FActivityMc_Spacing:Number = 4.5;
      
      protected var FActivityVect:Vector.<uint>;
      
      protected var FActivityMcVect:Vector.<TUIOrgActivitySlot>;
      
      protected var FActivityCount:uint;
      
      protected var FUIPage:TUIPage;
      
      protected var FPageIndex:uint;
      
      protected var FData_OrgBaseInfo:TBaseOrganization;
      
      protected var FData_OrgActivity:Vector.<Object>;
      
      protected var FClickActivityOk:Function;
      
      protected var FClickActivityUpLv:Function;
      
      protected var FOnActivityOver:Function;
      
      protected var FOnActivityOut:Function;
      
      public function TCompOrgCamp(param1:TUIComponent)
      {
         super(param1);
         this.FActivityVect = new Vector.<uint>();
         this.FActivityVect.push(1);
         this.FActivityVect.push(4);
         this.FActivityVect.push(2);
         this.FActivityCount = this.FActivityVect.length;
         this.FActivityMcVect = new Vector.<TUIOrgActivitySlot>();
      }
      
      protected function Resources_UIDispatch(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TUIOrgActivitySlot = null;
         var _loc5_:TSystemLanguage = null;
         this.FMC = param1;
         addChild(this.FMC);
         this.FMC_PageLeft = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_MC_PageLeft];
         this.FMC_PageRight = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_MC_PageRight];
         this.FUIPage = new TUIPage(this);
         this.FUIPage.ButtonPrevious.Substrate = this.FMC_PageLeft;
         this.FUIPage.ButtonNext.Substrate = this.FMC_PageRight;
         this.FUIPage.PageSize = MAX_ORGACTIVITY_COUNT;
         this.FUIPage.Init();
         this.FUIPage.OnChangePage = this.PageOnChange;
         this.FMC_OrgActivityInfo = this.FMC["MC_OrgActivityInfo"];
         this.FMC_OrgActivityPic = this.FMC_OrgActivityInfo["MC_OrgActivityPic"];
         this.FTF_OrgActivityInfo = this.FMC_OrgActivityInfo["TF_OrgActivityInfo"];
         this.FMC_List = this.FMC_OrgActivityInfo["mc_list"];
         _loc3_ = int(MAX_ORGACTIVITY_COUNT);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = new TUIOrgActivitySlot(this);
            _loc4_.Perform_UIDispatch(this.FMC[CONST_ORGANIZATION.RESOURCE_Link_MC_SlotActivity + _loc2_]);
            _loc4_.MC.visible = false;
            _loc4_.ClickActivityOk = this.OnOrgActivityOkClick;
            _loc4_.ClickUpLevel = this.OnOrgActivityUpLvClick;
            _loc4_.ClickSelectMc = this.OnOrgActivitySelectMc;
            _loc4_.OnMCOver = this.OnActivityMCOver;
            _loc4_.OnMCOut = this.OnActivityMCOut;
            this.FActivityMcVect[_loc2_] = _loc4_;
            _loc2_++;
         }
         this.FMC_Select = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_MC_Select];
         this.FMC_Select.x = this.FSelectMc_OriginalX;
         this.FMC_Select.y = this.FSelectMc_OriginalY;
         this.FMC_Select.play();
         this.FMC_Select.mouseChildren = this.FMC_Select.mouseEnabled = false;
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SystemLanguage,70180001) as TSystemLanguage;
         if(_loc5_ != null)
         {
            this.FTF_OrgActivityInfo.htmlText = this.FormatText(_loc5_.Desc);
            this.FScrollTextField = new TScrollTextField(this.FTF_OrgActivityInfo);
         }
         this.FMC_OrgActivityInfo.addChild(this.FScrollTextField);
         this.FScorll = new TScrollBarSimple(this,this.FMC_OrgActivityInfo.mc_bar,this.FMC_OrgActivityInfo.btn_up,this.FMC_OrgActivityInfo.btn_down,55,this.FScrollTextField);
         this.FMC_OrgActivityInfo.addChild(this.FScorll);
      }
      
      protected function FormatText(param1:String) : String
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         _loc4_ = "";
         _loc5_ = param1.split("%n");
         _loc3_ = int(_loc5_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc4_ + _loc5_[_loc2_] + "\n";
            _loc2_++;
         }
         return _loc4_;
      }
      
      protected function PageOnChange(param1:Object, param2:int) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TUIOrgActivitySlot = null;
         var _loc7_:uint = 0;
         if(param2 == this.FPageIndex)
         {
            return;
         }
         this.FPageIndex = param2;
         _loc5_ = int(MAX_ORGACTIVITY_COUNT);
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            this.FActivityMcVect[_loc3_].Clear();
            _loc3_++;
         }
         _loc5_ = int(this.FActivityCount);
         _loc4_ = MAX_ORGACTIVITY_COUNT * this.FPageIndex;
         _loc3_ = 0;
         while(_loc3_ < MAX_ORGACTIVITY_COUNT)
         {
            _loc6_ = this.FActivityMcVect[_loc3_];
            if(_loc4_ + _loc3_ < _loc5_)
            {
               _loc7_ = this.FActivityVect[_loc4_ + _loc3_];
               _loc6_.UpDateUI(this.FData_OrgBaseInfo,_loc7_);
               _loc6_.UpDataUI_BtnOk(this.FData_OrgBaseInfo.GetOrgActivityStatusByType(_loc7_));
               _loc6_.MC.visible = true;
            }
            else
            {
               _loc6_.MC.visible = false;
            }
            _loc3_++;
         }
         this.FMC_Select.x = this.FSelectMc_OriginalX;
      }
      
      protected function OnOrgActivityOkClick(param1:Object, param2:uint, param3:uint) : void
      {
         if(this.FClickActivityOk == null)
         {
            return;
         }
         this.FClickActivityOk(param1,param2,param3);
      }
      
      protected function OnOrgActivityUpLvClick(param1:Object, param2:uint) : void
      {
         if(this.FClickActivityUpLv == null)
         {
            return;
         }
         this.FClickActivityUpLv(param1,param2);
      }
      
      protected function OnOrgActivitySelectMc(param1:Object, param2:uint) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:uint = 0;
         var _loc5_:TSystemLanguage = null;
         var _loc6_:uint = 0;
         _loc6_ = this.FActivityVect.indexOf(param2);
         _loc6_ = _loc6_ % MAX_ORGACTIVITY_COUNT;
         _loc3_ = this.FSelectMc_OriginalX + _loc6_ * this.FActivityMc_Width + _loc6_ * this.FActivityMc_Spacing;
         this.FMC_Select.x = _loc3_;
         this.FMC_OrgActivityPic.gotoAndStop(param2);
         switch(param2)
         {
            case TYPE_ORGACTIVITY_CAMP:
               _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SystemLanguage,70180001) as TSystemLanguage;
               this.FTF_OrgActivityInfo.htmlText = this.FormatText(_loc5_.Desc);
               break;
            case TYPE_ORGACTIVITY_MUYEGUARD:
               _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SystemLanguage,70180003) as TSystemLanguage;
               this.FTF_OrgActivityInfo.htmlText = this.FormatText(_loc5_.Desc);
               break;
            case TYPE_ORGACTIVITY_PETBATTLE:
               break;
            case TYPE_ORGACTIVITY_MUYEBATTLE:
               _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SystemLanguage,70180002) as TSystemLanguage;
               this.FTF_OrgActivityInfo.htmlText = this.FormatText(_loc5_.Desc);
         }
      }
      
      protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIOrgActivitySlot = null;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         _loc2_ = int(this.FActivityCount);
         _loc5_ = MAX_ORGACTIVITY_COUNT * this.FPageIndex;
         _loc1_ = 0;
         while(_loc1_ < MAX_ORGACTIVITY_COUNT)
         {
            _loc3_ = this.FActivityMcVect[_loc1_];
            if(_loc5_ + _loc1_ < _loc2_)
            {
               _loc4_ = this.FActivityVect[_loc5_ + _loc1_];
               _loc3_.UpDateUI(this.FData_OrgBaseInfo,_loc4_);
               _loc3_.UpDataUI_BtnOk(this.FData_OrgBaseInfo.GetOrgActivityStatusByType(_loc4_));
               _loc3_.MC.visible = true;
            }
            else
            {
               _loc3_.MC.visible = false;
            }
            _loc1_++;
         }
         this.FUIPage.TotalQuantity = this.FActivityCount;
         this.FUIPage.PageIndex = this.FPageIndex;
         this.FUIPage.Update();
      }
      
      protected function OnActivityMCOver(param1:Object, param2:uint) : void
      {
         if(this.FOnActivityOver != null)
         {
            this.FOnActivityOver(param1,param2);
         }
      }
      
      protected function OnActivityMCOut(param1:Object) : void
      {
         if(this.FOnActivityOut != null)
         {
            this.FOnActivityOut(param1);
         }
      }
      
      public function get ClickActivityOk() : Function
      {
         return this.FClickActivityOk;
      }
      
      public function set ClickActivityOk(param1:Function) : void
      {
         this.FClickActivityOk = param1;
      }
      
      public function get ClickActivityUpLv() : Function
      {
         return this.FClickActivityUpLv;
      }
      
      public function set ClickActivityUpLv(param1:Function) : void
      {
         this.FClickActivityUpLv = param1;
      }
      
      public function get OnActivityOver() : Function
      {
         return this.FOnActivityOver;
      }
      
      public function set OnActivityOver(param1:Function) : void
      {
         this.FOnActivityOver = param1;
      }
      
      public function get OnActivityOut() : Function
      {
         return this.FOnActivityOut;
      }
      
      public function set OnActivityOut(param1:Function) : void
      {
         this.FOnActivityOut = param1;
      }
      
      public function Perform_UIDispatch(param1:MovieClip) : void
      {
         this.Resources_UIDispatch(param1);
         this.FIsInitialization = true;
      }
      
      public function UpData(param1:TBaseOrganization) : void
      {
         this.FData_OrgBaseInfo = param1;
         this.FData_OrgActivity = param1.OrgCampData;
      }
      
      public function UpDateUI() : void
      {
         this.FPageIndex = 0;
         this.UpdateUI();
      }
      
      public function UpDataUI_BtnActivity(param1:uint, param2:uint) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FActivityVect.indexOf(param1);
         if(_loc3_ != -1)
         {
            this.FActivityMcVect[_loc3_].UpDataUI_BtnOk(param2);
         }
      }
      
      public function LogicsPerform() : void
      {
         if(this.FScorll != null)
         {
            this.FScorll.LogicsProcess();
         }
      }
      
      public function Unmount() : void
      {
         this.FPageIndex = 0;
      }
   }
}

