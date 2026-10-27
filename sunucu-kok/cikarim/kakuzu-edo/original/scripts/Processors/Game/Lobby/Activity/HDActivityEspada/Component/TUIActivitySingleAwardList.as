package Processors.Game.Lobby.Activity.HDActivityEspada.Component
{
   import Components.Pages.TUIPage;
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_CURSOR;
   import Resources.Constants.CONST_LOBBY;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class TUIActivitySingleAwardList extends TUIComponent
   {
      
      protected static const Activity_CanNotReceive:int = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
      
      protected static const Activity_AlreadyReceive:int = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
      
      protected static const Activity_CanReceive:int = CONST_ACTIVITY_MODE.Activity_CanReceive;
      
      public static const MOUSECURSOR_AUTO:String = CONST_CURSOR.MOUSECURSOR_AUTO;
      
      public static const MOUSECURSOR_BUTTON:String = CONST_CURSOR.MOUSECURSOR_BUTTON;
      
      protected var FMC:Sprite;
      
      protected var FMC_BtnOK:MovieClip;
      
      protected var FMC_AlreadyGet:MovieClip;
      
      protected var FMC_Link:Sprite;
      
      protected var FMC_Lock:Sprite;
      
      protected var FBtn_OK:TUIButton;
      
      protected var FTextFieldVect:Vector.<TextField>;
      
      protected var FSlotVect:Vector.<TUISlot>;
      
      protected var FMC_ProgressBar:Sprite;
      
      protected var FTF_ProgressBar:TextField;
      
      protected var FTextFieldCount:int;
      
      protected var FSlotCount:int;
      
      protected var FAwardBoxStatus:int;
      
      protected var FBoxIndex:uint;
      
      protected var FTextFormat:TextFormat;
      
      protected var FHyperLinksPosition:uint;
      
      protected var FHyperLinksLocaltion:uint;
      
      protected var FInitMcLink:Boolean;
      
      protected var FInventories:TInventories;
      
      protected var FTextList:Vector.<String>;
      
      protected var FUIPage:TUIPage;
      
      protected var FPageIndex:int;
      
      protected var FWidthProgressBar:Number;
      
      protected var FOnSlotOver:Function;
      
      protected var FOnSlotOut:Function;
      
      protected var FOnQuerySequenceContext:Function;
      
      protected var FOnQuerySubscript:Function;
      
      protected var FOnBtnOkClick:Function;
      
      protected var FOnTextClick:Function;
      
      public function TUIActivitySingleAwardList(param1:TUIComponent)
      {
         super(param1);
         this.FTextFormat = new TextFormat();
         this.FTextFormat.underline = true;
         this.FInitMcLink = false;
         this.FUIPage = new TUIPage(this);
      }
      
      protected function Resources_UIDispatch(param1:Sprite, param2:Boolean = true) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TUISlot = null;
         var _loc6_:TextField = null;
         var _loc7_:MovieClip = null;
         var _loc8_:MovieClip = null;
         this.FMC = param1;
         if(param2)
         {
            addChild(this.FMC);
         }
         _loc4_ = this.FTextFieldCount;
         this.FTextFieldVect = new Vector.<TextField>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = this.FMC[CONST_ACTIVITY.RESOURCE_Link_TF_Prompt + _loc3_];
            _loc6_.text = _loc3_.toString();
            this.FTextFieldVect[_loc3_] = _loc6_;
            _loc3_++;
         }
         _loc4_ = this.FSlotCount;
         this.FSlotVect = new Vector.<TUISlot>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = new TUISlot(this);
            _loc5_.Resource = this.FMC[CONST_ACTIVITY.RESOURCE_Link_MC_Slot + _loc3_];
            _loc5_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
            _loc5_.OnQuerySequenceContext = this.FOnQuerySequenceContext;
            _loc5_.OnOver = this.FOnSlotOver;
            _loc5_.OnOut = this.FOnSlotOut;
            _loc5_.OnQuerySubscript = this.FOnQuerySubscript;
            _loc5_.Init();
            this.FSlotVect[_loc3_] = _loc5_;
            this.FSlotVect[_loc3_].Visible = true;
            _loc3_++;
         }
         this.FMC_BtnOK = this.FMC[CONST_ACTIVITY.RESOURCE_Link_BTN_OK];
         this.FMC_AlreadyGet = this.FMC[CONST_ACTIVITY.RESOURCE_Link_MC_AlreadyGet];
         if(this.FMC_BtnOK != null)
         {
            this.FBtn_OK = new TUIButton();
            this.FBtn_OK.Substrate = this.FMC_BtnOK;
            this.FBtn_OK.OnClick = this.BtnOKOnClick;
            this.FBtn_OK.Visible = false;
         }
         if(this.FMC_AlreadyGet != null)
         {
            this.FMC_AlreadyGet.visible = false;
         }
         this.FMC_Link = this.FMC[CONST_ACTIVITY.RESOURCE_Link_MC_Link];
         if(this.FMC_Link != null)
         {
            this.FMC_Link.visible = false;
         }
         this.FMC_Lock = this.FMC[CONST_ACTIVITY.RESOURCE_Link_MC_Lock];
         if(this.FMC_Lock != null)
         {
            this.FMC_Lock.visible = false;
         }
         _loc7_ = this.FMC[CONST_ACTIVITY.RESOURCE_Link_BTN_Left];
         _loc8_ = this.FMC[CONST_ACTIVITY.RESOURCE_Link_BTN_Right];
         if(_loc7_ != null && _loc8_ != null)
         {
            this.FUIPage.ButtonNext.Substrate = _loc8_;
            this.FUIPage.ButtonPrevious.Substrate = _loc7_;
            this.FUIPage.PageSize = this.FSlotCount;
            this.FUIPage.OnChangePage = this.TabPageOnChange;
            this.FUIPage.Init();
         }
         this.FMC_ProgressBar = this.FMC[CONST_ACTIVITY.RESOURCE_Link_MC_Bar];
         this.FTF_ProgressBar = this.FMC[CONST_ACTIVITY.RESOURCE_Link_TF_Bar];
         if(this.FMC_ProgressBar != null)
         {
            this.FMC_ProgressBar.mouseChildren = false;
            this.FMC_ProgressBar.mouseEnabled = false;
            this.FWidthProgressBar = this.FMC_ProgressBar.width;
            if(this.FTF_ProgressBar != null)
            {
               this.FTF_ProgressBar.mouseEnabled = false;
               this.FTF_ProgressBar.text = "";
            }
         }
      }
      
      protected function UpdateUI(param1:Vector.<String> = null, param2:TInventories = null) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:TUISlot = null;
         var _loc7_:TInventory = null;
         _loc4_ = this.FTextFieldCount;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(param1 == null)
            {
               this.FTextFieldVect[_loc3_].htmlText = "";
            }
            else
            {
               this.FTextFieldVect[_loc3_].htmlText = param1[_loc3_];
            }
            _loc3_++;
         }
         if(param2 != null)
         {
            _loc4_ = this.FSlotCount;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc6_ = this.FSlotVect[_loc3_];
               _loc6_.Context = null;
               _loc3_++;
            }
            _loc4_ = param2.Count;
            if(_loc4_ <= 0)
            {
               return;
            }
            _loc5_ = this.FPageIndex * this.FSlotCount;
            _loc3_ = 0;
            while(_loc3_ < this.FSlotCount)
            {
               if(_loc3_ + _loc5_ >= _loc4_)
               {
                  break;
               }
               _loc6_ = this.FSlotVect[_loc3_];
               _loc7_ = param2.GetInventoryByIndex(_loc3_ + _loc5_);
               _loc6_.Context = _loc7_;
               _loc3_++;
            }
         }
         if(this.FMC_Link != null && !this.FInitMcLink)
         {
            if(this.FBoxIndex == 0)
            {
               this.FMC_Link.visible = false;
            }
            else
            {
               this.FMC_Link.visible = true;
            }
         }
         if(this.FMC_Lock != null)
         {
            if(this.FBoxIndex == 0)
            {
               this.FMC_Lock.visible = false;
            }
            else
            {
               this.FMC_Lock.visible = true;
            }
         }
      }
      
      protected function UpdateBtn() : void
      {
         if(this.FBtn_OK == null)
         {
            return;
         }
         if(this.FAwardBoxStatus == Activity_CanNotReceive)
         {
            this.FBtn_OK.Visible = true;
            this.FBtn_OK.Enabled = false;
            if(this.FMC_AlreadyGet != null)
            {
               this.FMC_AlreadyGet.visible = false;
            }
         }
         else if(this.FAwardBoxStatus >= Activity_CanReceive)
         {
            this.FBtn_OK.Visible = true;
            this.FBtn_OK.Enabled = true;
            if(this.FMC_AlreadyGet != null)
            {
               this.FMC_AlreadyGet.visible = false;
            }
         }
         else if(this.FAwardBoxStatus == Activity_AlreadyReceive)
         {
            this.FBtn_OK.Visible = false;
            if(this.FMC_AlreadyGet != null)
            {
               this.FMC_AlreadyGet.visible = true;
            }
         }
      }
      
      protected function ProcessorUpdateUIPrograssBar(param1:uint, param2:uint) : void
      {
         if(this.FTF_ProgressBar != null)
         {
            this.FTF_ProgressBar.text = param1.toString() + "/" + param2.toString();
         }
         if(this.FMC_ProgressBar != null)
         {
            if(param1 >= param2)
            {
               this.FMC_ProgressBar.width = this.FWidthProgressBar;
            }
            else
            {
               this.FMC_ProgressBar.width = Math.floor(param1 * this.FWidthProgressBar / param2);
            }
         }
      }
      
      protected function DoClear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FSlotVect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSlotVect[_loc1_].Context = null;
            _loc1_++;
         }
      }
      
      protected function TabPageOnChange(param1:Object, param2:int) : void
      {
         this.FPageIndex = param2;
         this.UpdateUI(this.FTextList,this.FInventories);
      }
      
      protected function BtnOKOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnBtnOkClick != null)
         {
            this.FOnBtnOkClick(this,this.FBoxIndex);
         }
      }
      
      protected function TextOnClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         _loc3_ = param1.currentTarget.name;
         _loc2_ = int(_loc3_.match("_")[2]);
         if(this.FOnTextClick != null)
         {
            this.FOnTextClick(this,_loc2_);
         }
      }
      
      protected function TextOnOver(param1:MouseEvent) : void
      {
         FUICore.MouseSetCursor(MOUSECURSOR_BUTTON);
      }
      
      protected function TextOnOut(param1:MouseEvent) : void
      {
         FUICore.MouseSetCursor(MOUSECURSOR_AUTO);
      }
      
      public function get OnQuerySequenceContext() : Function
      {
         return this.FOnQuerySequenceContext;
      }
      
      public function set OnQuerySequenceContext(param1:Function) : void
      {
         this.FOnQuerySequenceContext = param1;
      }
      
      public function get OnSlotOver() : Function
      {
         return this.FOnSlotOver;
      }
      
      public function set OnSlotOver(param1:Function) : void
      {
         this.FOnSlotOver = param1;
      }
      
      public function get OnSlotOut() : Function
      {
         return this.FOnSlotOut;
      }
      
      public function set OnSlotOut(param1:Function) : void
      {
         this.FOnSlotOut = param1;
      }
      
      public function get OnQuerySubscript() : Function
      {
         return this.FOnQuerySubscript;
      }
      
      public function set OnQuerySubscript(param1:Function) : void
      {
         this.FOnQuerySubscript = param1;
      }
      
      public function get OnBtnOkClick() : Function
      {
         return this.FOnBtnOkClick;
      }
      
      public function set OnBtnOkClick(param1:Function) : void
      {
         this.FOnBtnOkClick = param1;
      }
      
      public function get OnTextClick() : Function
      {
         return this.FOnTextClick;
      }
      
      public function set OnTextClick(param1:Function) : void
      {
         this.FOnTextClick = param1;
      }
      
      public function Perform_UIDispatch(param1:Sprite, param2:int, param3:int, param4:Boolean = true) : void
      {
         this.FTextFieldCount = param2;
         this.FSlotCount = param3;
         this.Resources_UIDispatch(param1,param4);
      }
      
      public function SetShortcutHyperlinks(param1:uint) : void
      {
         this.FTextFieldVect[param1].setTextFormat(this.FTextFormat);
         if(!this.FTextFieldVect[param1].hasEventListener(MouseEvent.CLICK))
         {
            this.FTextFieldVect[param1].addEventListener(MouseEvent.CLICK,this.TextOnClick);
         }
         if(!this.FTextFieldVect[param1].hasEventListener(MouseEvent.MOUSE_MOVE))
         {
            this.FTextFieldVect[param1].addEventListener(MouseEvent.MOUSE_MOVE,this.TextOnOver);
         }
         if(!this.FTextFieldVect[param1].hasEventListener(MouseEvent.MOUSE_OUT))
         {
            this.FTextFieldVect[param1].addEventListener(MouseEvent.MOUSE_OUT,this.TextOnOut);
         }
      }
      
      public function UpDateUI(param1:uint, param2:TInventories = null, param3:Vector.<String> = null) : void
      {
         this.FInventories = param2;
         this.FTextList = param3;
         this.FBoxIndex = param1;
         this.UpdateUI(param3,this.FInventories);
      }
      
      public function UpDatePrompt(param1:Vector.<String>) : void
      {
         this.UpdateUI(param1,null);
      }
      
      public function UpDateBtn(param1:int) : void
      {
         this.FAwardBoxStatus = param1;
         this.UpdateBtn();
      }
      
      public function UpDateSlot() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FSlotVect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSlotVect[_loc1_].Update();
            _loc1_++;
         }
      }
      
      public function Clear() : void
      {
         this.DoClear();
         this.FInventories = null;
         this.FTextList = null;
         this.FPageIndex = 0;
      }
      
      public function UpdateUIPage() : void
      {
         this.FPageIndex = 0;
         this.FUIPage.TotalQuantity = this.FInventories.Count;
         this.FUIPage.PageIndex = this.FPageIndex;
         this.FUIPage.Update();
      }
      
      public function UpdateUIProgressBar(param1:uint, param2:uint) : void
      {
         this.ProcessorUpdateUIPrograssBar(param1,param2);
      }
   }
}

