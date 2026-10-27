package Processors.Game.Lobby.BleachDailyRecord
{
   import Components.ScrollBar.TScrollBar;
   import Components.Standard.TUIButton;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.BleachDailyRecord.TBleachDailyRecord;
   import Logics.BleachDailyRecord.TBleachDailyRecords;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Utilities.HyperLink.SUtilityHyperLink;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TWindowBleachDailyRecord extends TProcessorLobbyWindow
   {
      
      protected static const ItemFrameIndex_Complete:int = 1;
      
      protected static const ItemFrameIndex_NotComplete:int = 2;
      
      protected static const ItemFrameIndex_NotOpen:int = 3;
      
      protected var FMainScene:Sprite;
      
      protected var FBtnClose:TUIButton;
      
      protected var FTFDailyRecordContext:TextField;
      
      protected var FTFDailyRecordReward:TextField;
      
      protected var FScroolBar:TScrollBar;
      
      protected var FDailyRecordItems:Vector.<MovieClip>;
      
      protected var FDailyRecordIcomMountPoint:Vector.<Bitmap>;
      
      protected var FDailyRecordBtnJmp:Vector.<TUIButton>;
      
      protected var FDailyRecordName:Vector.<TextField>;
      
      protected var FDailyRecordDescription:Vector.<TextField>;
      
      protected var FDailyRecordSelectBox:Vector.<Sprite>;
      
      protected var FCurrentSelectBoxIndex:int;
      
      protected var FBleachDailyRecords:TBleachDailyRecords;
      
      public function TWindowBleachDailyRecord(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FMainScene = TUtilityReflection.CreateDisplayObjectInstance("ExpertiseUI") as Sprite;
         addChild(this.FMainScene);
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainScene["BT_Close"];
         this.FBtnClose.OnClick = this.BtnCloseOnClick;
         this.FTFDailyRecordContext = this.FMainScene["Context"];
         this.FTFDailyRecordReward = this.FMainScene["RewardContext"];
         this.FDailyRecordItems = new Vector.<MovieClip>();
         this.FDailyRecordIcomMountPoint = new Vector.<Bitmap>();
         this.FDailyRecordBtnJmp = new Vector.<TUIButton>();
         this.FDailyRecordName = new Vector.<TextField>();
         this.FDailyRecordDescription = new Vector.<TextField>();
         this.FDailyRecordSelectBox = new Vector.<Sprite>();
         this.FScroolBar = new TScrollBar(this.FMainScene["mc_list"],369,false,0);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FCurrentSelectBoxIndex = 0;
         super.ResourcesPerform_UILocations();
      }
      
      protected function CreateRecordItem() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:MovieClip = null;
         var _loc5_:Bitmap = null;
         var _loc6_:TUIButton = null;
         this.FScroolBar.Clear();
         _loc2_ = this.FBleachDailyRecords.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = TUtilityReflection.CreateDisplayObjectInstance("ExpertiseItem") as MovieClip;
            _loc4_.addEventListener(MouseEvent.CLICK,this.DailyRecordItemOnClick);
            _loc4_.buttonMode = true;
            this.FScroolBar.AddItem(_loc4_);
            this.FDailyRecordItems.push(_loc4_);
            _loc5_ = new Bitmap();
            _loc4_["MountPoint"].addChild(_loc5_);
            this.FDailyRecordIcomMountPoint.push(_loc5_);
            _loc6_ = new TUIButton();
            _loc6_.Substrate = _loc4_["MC_DoTaskBT"];
            _loc6_.OnClick = this.BtnJmpOnClick;
            this.FDailyRecordBtnJmp.push(_loc6_);
            this.FDailyRecordName.push(_loc4_["Name"]);
            this.FDailyRecordDescription.push(_loc4_["Description"]);
            this.FDailyRecordSelectBox.push(_loc4_["SelectBox"]);
            _loc4_["SelectBox"].visible = false;
            _loc1_++;
         }
         this.FScroolBar.ScrollToUp();
      }
      
      protected function RenderingDailyRecordItem() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TBleachDailyRecord = null;
         _loc2_ = int(this.FDailyRecordItems.length);
         this.FBleachDailyRecords.BleachDailyRecords.sort(this.SortMethod);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FBleachDailyRecords.BleachDailyRecords[_loc1_];
            this.FDailyRecordName[_loc1_].text = _loc3_.GrowRoadDayTask.Name;
            if(_loc3_.IfOpen)
            {
               this.FDailyRecordDescription[_loc1_].text = TUtilityString.Format(_loc3_.GrowRoadDayTask.Description,_loc3_.RecordValue);
            }
            else
            {
               this.FDailyRecordDescription[_loc1_].text = _loc3_.UnlockDescription;
            }
            SResourcesCore.TexturesInventory.LoadAutoSecondary(_loc3_.GrowRoadDayTask.Picture,this.CallBack_PicArrive);
            if(!_loc3_.IfOpen)
            {
               this.FDailyRecordItems[_loc1_].gotoAndStop(ItemFrameIndex_NotOpen);
            }
            else if(_loc3_.RecordValue == 0)
            {
               this.FDailyRecordItems[_loc1_].gotoAndStop(ItemFrameIndex_Complete);
            }
            else
            {
               this.FDailyRecordItems[_loc1_].gotoAndStop(ItemFrameIndex_NotComplete);
            }
            _loc1_++;
         }
      }
      
      protected function ItemSelectedByIndex(param1:int) : void
      {
         var _loc2_:TBleachDailyRecord = null;
         this.FDailyRecordSelectBox[this.FCurrentSelectBoxIndex].visible = false;
         this.FDailyRecordSelectBox[param1].visible = true;
         this.FCurrentSelectBoxIndex = param1;
         _loc2_ = this.FBleachDailyRecords.BleachDailyRecords[param1];
         this.FTFDailyRecordContext.htmlText = _loc2_.GrowRoadDayTask.DescribeText;
         this.FTFDailyRecordReward.htmlText = _loc2_.GrowRoadDayTask.DropOutText;
      }
      
      protected function CallBack_PicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TBleachDailyRecord = null;
         _loc5_ = int(this.FDailyRecordItems.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = this.FBleachDailyRecords.BleachDailyRecords[_loc4_];
            if(_loc6_.GrowRoadDayTask.Picture == param3)
            {
               this.FDailyRecordIcomMountPoint[_loc4_].bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
            }
            _loc4_++;
         }
      }
      
      protected function SortMethod(param1:TBleachDailyRecord, param2:TBleachDailyRecord) : int
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         if(param1.IfOpen && param1.RecordValue == 0)
         {
            _loc3_ += 1000;
         }
         else if(!param1.IfOpen)
         {
            _loc3_ += 10000;
         }
         if(param2.IfOpen && param2.RecordValue == 0)
         {
            _loc4_ += 1000;
         }
         else if(!param2.IfOpen)
         {
            _loc4_ += 10000;
         }
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      protected function BtnJmpOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FDailyRecordBtnJmp.indexOf(param1 as TUIButton);
         ProcessorWindowClose();
         SUtilityHyperLink.ShortcutHyperlink(this.FBleachDailyRecords.BleachDailyRecords[_loc3_].GrowRoadDayTask.IsGoto);
      }
      
      protected function DailyRecordItemOnClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FDailyRecordItems.indexOf(param1.currentTarget as Sprite);
         this.ItemSelectedByIndex(_loc2_);
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      public function set BleachDailyRecords(param1:TBleachDailyRecords) : void
      {
         this.FBleachDailyRecords = param1;
      }
      
      public function InitView() : void
      {
         this.CreateRecordItem();
         this.RenderingDailyRecordItem();
         this.ItemSelectedByIndex(0);
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
         _loc2_ = int(this.FDailyRecordBtnJmp.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FDailyRecordBtnJmp[_loc1_].Dispose();
            this.FDailyRecordIcomMountPoint[_loc1_].bitmapData = null;
            this.FDailyRecordItems[_loc1_].removeEventListener(MouseEvent.CLICK,this.DailyRecordItemOnClick);
            _loc1_++;
         }
         this.FDailyRecordItems.length = 0;
         this.FDailyRecordIcomMountPoint.length = 0;
         this.FDailyRecordBtnJmp.length = 0;
         this.FDailyRecordName.length = 0;
         this.FDailyRecordDescription.length = 0;
         this.FDailyRecordSelectBox.length = 0;
         this.FCurrentSelectBoxIndex = 0;
      }
   }
}

