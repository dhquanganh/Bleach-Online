package Processors.Game.Lobby.Activity.HDChildrenDay.windows
{
   import Components.Pages.TUIPage;
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.Common.THint;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Logics.Agent.SParametersCore;
   import Logics.Characters.TCharacter;
   import Logics.DatebaseVO.VO.TBaseHero;
   import Logics.DatebaseVO.VO.THDChildrenDayCollect;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDChildrenDay.TChildrenDayCollect;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Logics.KnifeOfKillSoul.TKnifeOfKillSoulData;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_KNIFEOFKILLSOUL;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorHDWindowChildrenDayCollect extends TProcessorHDSingleWindowBase
   {
      
      public static const SLOTNUM:int = 9;
      
      public static const NUM:uint = 2;
      
      protected var FPageUI:TUIPage;
      
      protected var FCurrentPage:uint;
      
      protected var FImageList:Vector.<MovieClip>;
      
      protected var FBitmapList:Vector.<Bitmap>;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FItemSlots:Vector.<TUISlot>;
      
      protected var FImageList2:Vector.<MovieClip>;
      
      protected var FBitmapList2:Vector.<Bitmap>;
      
      protected var FSlots2:Vector.<TUISlot>;
      
      protected var FItemSlots2:Vector.<TUISlot>;
      
      protected var FBtnGet:Vector.<TUIButton>;
      
      protected var FBtnRecharge:TUIButton;
      
      protected var FData:TChildrenDayCollect;
      
      protected var FConfig:THDChildrenDayCollect;
      
      public function TProcessorHDWindowChildrenDayCollect(param1:TUIComponent)
      {
         super(param1);
         FHint = new THint();
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.UpdateUIConfig();
         this.FConfig = FHDActivityConfig as THDChildrenDayCollect;
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
         this.FData = param1 as TChildrenDayCollect;
         this.FPageUI.TotalQuantity = this.FConfig.Items.length;
         this.FPageUI.Update();
         this.UpdateCurrentPage();
      }
      
      protected function PageOnSwitch(param1:Object, param2:int) : void
      {
         this.FCurrentPage = param2;
         this.UpdateCurrentPage();
      }
      
      protected function UpdateCurrentPage() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         this.CleanData();
         this.ShowHeroHeadRender();
         this.ShowAwardRender();
         FScene["MC_Block_0"]["MC_Mask"]["TF_Text"].text = this.FData.Config.Items[this.FCurrentPage * NUM].Title;
         if(this.FCurrentPage * NUM + 1 >= this.FConfig.Items.length)
         {
            this.FBtnGet[0].Enabled = this.FData.BagStatus[0 + NUM * this.FCurrentPage] == 1 ? true : false;
            FScene["MC_Block_" + 0]["MC_Already"].visible = this.FData.BagStatus[0 + NUM * this.FCurrentPage] == -1 ? true : false;
            return;
         }
         FScene["MC_Block_1"]["MC_Mask"]["TF_Text"].text = this.FData.Config.Items[this.FCurrentPage * NUM + 1].Title;
         _loc2_ = NUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FBtnGet[_loc1_].Enabled = this.FData.BagStatus[_loc1_ + NUM * this.FCurrentPage] == 1 ? true : false;
            FScene["MC_Block_" + _loc1_]["MC_Already"].visible = this.FData.BagStatus[_loc1_ + NUM * this.FCurrentPage] == -1 ? true : false;
            _loc1_++;
         }
      }
      
      protected function CleanData() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < 9)
         {
            this.FImageList[_loc1_] = null;
            this.FBitmapList[_loc1_].bitmapData = null;
            this.FImageList2[_loc1_] = null;
            this.FBitmapList2[_loc1_].bitmapData = null;
            FScene["MC_Block_0"]["MC_Hero_" + _loc1_].visible = false;
            FScene["MC_Block_1"]["MC_Hero_" + _loc1_].visible = false;
            this.FItemSlots[_loc1_].Context = null;
            this.FItemSlots2[_loc1_].Context = null;
            _loc1_++;
         }
         _loc1_ = 8;
         while(_loc1_ < this.FSlots.length)
         {
            this.FSlots[_loc1_].Context = null;
            this.FSlots2[_loc1_].Context = null;
            _loc1_++;
         }
         FScene["MC_Block_" + 0]["MC_Mask"].visible = true;
         FScene["MC_Block_" + 1]["MC_Mask"].visible = true;
      }
      
      protected function ShowAwardRender() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TInventories = null;
         _loc3_ = new TInventories();
         SToolReward.GetAwardsByAwardID(this.FConfig.Items[this.FCurrentPage * NUM].awardid,_loc3_);
         _loc1_ = 8;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            if(_loc2_ >= _loc3_.Count)
            {
               this.FSlots[_loc2_].Visible = false;
            }
            else
            {
               this.FSlots[_loc2_].Context = _loc3_.GetInventoryByIndex(_loc2_);
               this.FSlots[_loc2_].Visible = true;
            }
            _loc2_++;
         }
         if(this.FCurrentPage * NUM + 1 >= this.FConfig.Items.length)
         {
            FScene["MC_Block_1"].visible = false;
            return;
         }
         FScene["MC_Block_1"].visible = true;
         _loc3_ = new TInventories();
         SToolReward.GetAwardsByAwardID(this.FConfig.Items[this.FCurrentPage * NUM + 1].awardid,_loc3_);
         _loc1_ = 8;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            if(_loc2_ >= _loc3_.Count)
            {
               this.FSlots2[_loc2_].Visible = false;
            }
            else
            {
               this.FSlots2[_loc2_].Context = _loc3_.GetInventoryByIndex(_loc2_);
               this.FSlots2[_loc2_].Visible = true;
            }
            _loc2_++;
         }
      }
      
      protected function ShowHeroHeadRender() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Vector.<uint> = null;
         var _loc8_:TInventories = null;
         _loc4_ = int(this.FConfig.Items[this.FCurrentPage * NUM]["hero"].length);
         _loc1_ = 0;
         _loc2_ = 8;
         _loc2_ = _loc2_ > _loc4_ ? _loc4_ : _loc2_;
         _loc3_ = _loc1_;
         while(_loc3_ < _loc2_)
         {
            FScene["MC_Block_0"]["MC_Hero_" + _loc3_].visible = true;
            SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(this.FConfig.Items[this.FCurrentPage * NUM]["hero"][_loc3_],this.GetBitmapData);
            if(SLogicsCore.Character.Heros.GetHeroByIdentifier(this.FConfig.Items[this.FCurrentPage * NUM]["hero"][_loc3_]) != null && (SLogicsCore.Character.Heros.GetHeroByIdentifier(this.FConfig.Items[this.FCurrentPage * NUM]["hero"][_loc3_]).HeroOverTime == 0 || SLogicsCore.Character.Heros.GetHeroByIdentifier(this.FConfig.Items[this.FCurrentPage * NUM]["hero"][_loc3_]).HeroOverTime - STimingCore.ServerTick > 0))
            {
               FScene["MC_Block_" + 0]["MC_Hero_" + _loc3_]["TF_Text_0"].text = "1/1";
            }
            else
            {
               FScene["MC_Block_" + 0]["MC_Hero_" + _loc3_]["TF_Text_0"].text = "0/1";
            }
            _loc3_++;
         }
         _loc8_ = new TInventories();
         if(this.FConfig.Items[this.FCurrentPage * NUM].item.length > 0)
         {
            SToolReward.GetAwardsByAwardID(this.FConfig.Items[this.FCurrentPage * NUM].item[0],_loc8_);
            _loc4_ = _loc8_.Count;
            _loc5_ = int(this.FConfig.Items[this.FCurrentPage * NUM].knife.length);
            _loc6_ = _loc3_;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               this.FItemSlots[_loc6_].Context = _loc8_.GetInventoryByIndex(_loc3_);
               FScene["MC_Block_0"]["MC_Hero_" + _loc6_].visible = true;
               if(_loc3_ < _loc5_)
               {
                  FScene["MC_Block_" + 0]["MC_Hero_" + _loc6_]["TF_Text_0"].text = this.HaveArticle(this.FConfig.Items[this.FCurrentPage * NUM].knife[_loc3_],null) > 0 ? "1/1" : "0/1";
               }
               else
               {
                  FScene["MC_Block_" + 0]["MC_Hero_" + _loc6_]["TF_Text_0"].text = this.HaveArticle(0,_loc8_.GetInventoryByIndex(_loc3_)) + "/" + this.FConfig.Items[this.FCurrentPage * NUM].itemcount[_loc3_ - _loc5_];
               }
               _loc6_++;
               _loc3_++;
            }
         }
         if(this.FCurrentPage * NUM + 1 >= this.FConfig.Items.length)
         {
            return;
         }
         _loc4_ = int(this.FConfig.Items[this.FCurrentPage * NUM + 1]["hero"].length);
         _loc1_ = 0;
         _loc2_ = 8;
         _loc2_ = _loc2_ > _loc4_ ? _loc4_ : _loc2_;
         _loc3_ = _loc1_;
         while(_loc3_ < _loc2_)
         {
            FScene["MC_Block_1"]["MC_Hero_" + _loc3_].visible = true;
            SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(this.FConfig.Items[this.FCurrentPage * NUM + 1]["hero"][_loc3_],this.GetBitmapData);
            if(SLogicsCore.Character.Heros.GetHeroByIdentifier(this.FConfig.Items[this.FCurrentPage * NUM + 1]["hero"][_loc3_]) != null && (SLogicsCore.Character.Heros.GetHeroByIdentifier(this.FConfig.Items[this.FCurrentPage * NUM + 1]["hero"][_loc3_]).HeroOverTime == 0 || SLogicsCore.Character.Heros.GetHeroByIdentifier(this.FConfig.Items[this.FCurrentPage * NUM + 1]["hero"][_loc3_]).HeroOverTime - STimingCore.ServerTick > 0))
            {
               FScene["MC_Block_" + 1]["MC_Hero_" + _loc3_]["TF_Text_0"].text = "1/1";
            }
            else
            {
               FScene["MC_Block_" + 1]["MC_Hero_" + _loc3_]["TF_Text_0"].text = "0/1";
            }
            _loc3_++;
         }
         _loc8_ = new TInventories();
         if(this.FConfig.Items[this.FCurrentPage * NUM + 1].item.length > 0)
         {
            SToolReward.GetAwardsByAwardID(this.FConfig.Items[this.FCurrentPage * NUM + 1].item[0],_loc8_);
            _loc4_ = _loc8_.Count;
            _loc5_ = int(this.FConfig.Items[this.FCurrentPage * NUM + 1].knife.length);
            _loc6_ = _loc3_;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               this.FItemSlots2[_loc6_].Context = _loc8_.GetInventoryByIndex(_loc3_);
               FScene["MC_Block_1"]["MC_Hero_" + _loc6_].visible = true;
               if(_loc3_ < _loc5_)
               {
                  FScene["MC_Block_" + 1]["MC_Hero_" + _loc6_]["TF_Text_0"].text = this.HaveArticle(this.FConfig.Items[this.FCurrentPage * NUM + 1].knife[_loc3_],null) > 0 ? "1/1" : "0/1";
               }
               else
               {
                  FScene["MC_Block_" + 1]["MC_Hero_" + _loc6_]["TF_Text_0"].text = this.HaveArticle(0,_loc8_.GetInventoryByIndex(_loc3_)) + "/" + this.FConfig.Items[this.FCurrentPage * NUM + 1].itemcount[_loc3_ - _loc5_];
               }
               _loc6_++;
               _loc3_++;
            }
         }
      }
      
      protected function HaveArticle(param1:uint, param2:TInventory) : int
      {
         var _loc3_:TCharacter = null;
         var _loc4_:Boolean = false;
         var _loc5_:TKnifeOfKillSoulData = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         _loc3_ = SLogicsCore.Character;
         if(param2 == null)
         {
            _loc6_ = uint(_loc3_.KnifeOfKillSoul.Count);
            _loc8_ = 0;
            while(_loc8_ < _loc6_)
            {
               _loc5_ = _loc3_.KnifeOfKillSoul.GetByIndex(_loc8_);
               if(_loc5_.RelationID == param1 && _loc5_.CurrentState == CONST_KNIFEOFKILLSOUL.KNIFESTATE_UNLOCK)
               {
                  return 1;
               }
               _loc8_++;
            }
            return 0;
         }
         if(_loc3_.Appliances.GetInventoryByTempletID(param2.IDTemplate) != null)
         {
            _loc7_ = uint(_loc3_.Appliances.GetCountByTempleteID(param2.IDTemplate));
         }
         if(_loc3_.TemporaryInventories.GetInventoryByTempletID(param2.IDTemplate) != null)
         {
            _loc7_ += _loc3_.TemporaryInventories.GetCountByTempleteID(param2.IDTemplate);
         }
         return _loc7_;
      }
      
      protected function GetBitmapData(param1:Object, param2:TTexture, param3:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc5_ = 0;
         _loc6_ = 8;
         _loc6_ = _loc6_ > this.FConfig.Items[this.FCurrentPage * NUM]["hero"].length ? int(this.FConfig.Items[this.FCurrentPage * NUM]["hero"].length) : _loc6_;
         _loc7_ = 0;
         _loc4_ = _loc5_;
         while(_loc4_ < _loc6_)
         {
            if(this.FConfig.Items[this.FCurrentPage * NUM]["hero"][_loc4_] == param3)
            {
               this.FBitmapList[_loc7_].bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
               this.FBitmapList[_loc7_].scaleX = 0.9;
               this.FBitmapList[_loc7_].scaleY = 0.9;
            }
            _loc7_++;
            _loc4_++;
         }
         if(this.FCurrentPage * NUM + 1 >= this.FConfig.Items.length)
         {
            return;
         }
         _loc5_ = 0;
         _loc6_ = 8;
         _loc6_ = _loc6_ > this.FConfig.Items[this.FCurrentPage * NUM + 1]["hero"].length ? int(this.FConfig.Items[this.FCurrentPage * NUM + 1]["hero"].length) : _loc6_;
         _loc7_ = 0;
         _loc4_ = _loc5_;
         while(_loc4_ < _loc6_)
         {
            if(this.FConfig.Items[this.FCurrentPage * NUM + 1]["hero"][_loc4_] == param3)
            {
               this.FBitmapList2[_loc7_].bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
               this.FBitmapList2[_loc7_].scaleX = 0.9;
               this.FBitmapList2[_loc7_].scaleY = 0.9;
            }
            _loc7_++;
            _loc4_++;
         }
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:TUISlot = null;
         super.LogicsPerform();
         if(!Visible)
         {
            return;
         }
         if(this.FSlots != null)
         {
            for each(_loc1_ in this.FSlots)
            {
               _loc1_.Update();
            }
         }
         if(this.FSlots2 != null)
         {
            for each(_loc1_ in this.FSlots2)
            {
               _loc1_.Update();
            }
         }
         if(this.FItemSlots != null)
         {
            for each(_loc1_ in this.FItemSlots)
            {
               _loc1_.Update();
            }
         }
         if(this.FItemSlots2 != null)
         {
            for each(_loc1_ in this.FItemSlots2)
            {
               _loc1_.Update();
            }
         }
      }
      
      protected function ProcessorRecharge(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToRechargeUrl(SParametersCore.PayUrl);
      }
      
      protected function ProcessorGet(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param1.Tag + NUM * this.FCurrentPage);
      }
      
      protected function ProcessorHeroOnOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,FHint);
      }
      
      protected function ProcessorHeroOnMove(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.currentTarget.name;
         var _loc3_:uint = uint(_loc2_.split("_")[2]);
         var _loc4_:uint = uint(param1.currentTarget.parent.name.split("_")[2]);
         var _loc5_:uint = uint(this.FConfig.Items[_loc4_ + this.FCurrentPage * NUM]["hero"][_loc3_]);
         FHint.Caption = this.GetHeroName(_loc5_);
         SUtilityOverLayer.UIComponentsHintOnOver(this,FHint);
      }
      
      protected function ProcessorMask(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.currentTarget.parent.name;
         var _loc3_:uint = uint(_loc2_.split("_")[2]);
         (FScene["MC_Block_" + _loc3_]["MC_Effect"] as MovieClip).play();
         param1.currentTarget.visible = false;
      }
      
      protected function GetHeroName(param1:int) : String
      {
         var _loc2_:String = null;
         var _loc3_:TBins = null;
         var _loc4_:TBaseHero = null;
         _loc3_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BaseHero);
         _loc4_ = _loc3_.GetDatebaseByIdentifier(param1) as TBaseHero;
         if(_loc4_ == null)
         {
            _loc2_ = "";
         }
         else
         {
            _loc2_ = _loc4_.Name;
         }
         return _loc2_;
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Bitmap = null;
         super.InitWindow(param1);
         this.FPageUI = new TUIPage(this);
         this.FPageUI.ButtonNext.Substrate = FScene["MC_PageRight"];
         this.FPageUI.ButtonPrevious.Substrate = FScene["MC_PageLeft"];
         this.FPageUI.PageSize = NUM;
         this.FPageUI.OnChangePage = this.PageOnSwitch;
         this.FPageUI.Init();
         this.FPageUI.Update();
         _loc2_ = 9;
         this.FImageList = new Vector.<MovieClip>(_loc2_);
         this.FBitmapList = new Vector.<Bitmap>(_loc2_);
         this.FItemSlots = new Vector.<TUISlot>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FImageList[_loc3_] = FScene["MC_Block_0"]["MC_Hero_" + _loc3_]["slot"]["MC_Bmp_Icon"];
            FScene["MC_Block_0"]["MC_Hero_" + _loc3_].addEventListener(MouseEvent.MOUSE_MOVE,this.ProcessorHeroOnMove);
            FScene["MC_Block_0"]["MC_Hero_" + _loc3_].addEventListener(MouseEvent.MOUSE_OUT,this.ProcessorHeroOnOut);
            FScene["MC_Block_0"]["MC_Hero_" + _loc3_]["slot"]["TF_Subscript"].visible = false;
            _loc4_ = new Bitmap();
            this.FBitmapList[_loc3_] = _loc4_;
            this.FImageList[_loc3_].addChild(_loc4_);
            this.FItemSlots[_loc3_] = new TUISlot(this);
            this.FItemSlots[_loc3_].Resource = FScene["MC_Block_0"]["MC_Hero_" + _loc3_]["slot"];
            this.FItemSlots[_loc3_].OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FItemSlots[_loc3_].OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(this.FItemSlots[_loc3_]);
            this.FItemSlots[_loc3_].Init();
            _loc3_++;
         }
         _loc2_ = 8;
         this.FSlots = new Vector.<TUISlot>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FSlots[_loc3_] = new TUISlot(this);
            this.FSlots[_loc3_].Resource = FScene["MC_Block_0"]["MC_Award_" + _loc3_];
            this.FSlots[_loc3_].OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FSlots[_loc3_].OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(this.FSlots[_loc3_]);
            this.FSlots[_loc3_].Init();
            _loc3_++;
         }
         _loc2_ = 9;
         this.FImageList2 = new Vector.<MovieClip>(_loc2_);
         this.FBitmapList2 = new Vector.<Bitmap>(_loc2_);
         this.FItemSlots2 = new Vector.<TUISlot>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FImageList2[_loc3_] = FScene["MC_Block_1"]["MC_Hero_" + _loc3_]["slot"]["MC_Bmp_Icon"];
            FScene["MC_Block_1"]["MC_Hero_" + _loc3_].addEventListener(MouseEvent.MOUSE_MOVE,this.ProcessorHeroOnMove);
            FScene["MC_Block_1"]["MC_Hero_" + _loc3_].addEventListener(MouseEvent.MOUSE_OUT,this.ProcessorHeroOnOut);
            FScene["MC_Block_1"]["MC_Hero_" + _loc3_]["slot"]["TF_Subscript"].visible = false;
            _loc4_ = new Bitmap();
            this.FBitmapList2[_loc3_] = _loc4_;
            this.FImageList2[_loc3_].addChild(_loc4_);
            this.FItemSlots2[_loc3_] = new TUISlot(this);
            this.FItemSlots2[_loc3_].Resource = FScene["MC_Block_1"]["MC_Hero_" + _loc3_]["slot"];
            this.FItemSlots2[_loc3_].OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FItemSlots2[_loc3_].OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(this.FItemSlots2[_loc3_]);
            this.FItemSlots2[_loc3_].Init();
            _loc3_++;
         }
         _loc2_ = 8;
         this.FSlots2 = new Vector.<TUISlot>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FSlots2[_loc3_] = new TUISlot(this);
            this.FSlots2[_loc3_].Resource = FScene["MC_Block_1"]["MC_Award_" + _loc3_];
            this.FSlots2[_loc3_].OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FSlots2[_loc3_].OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(this.FSlots2[_loc3_]);
            this.FSlots2[_loc3_].Init();
            _loc3_++;
         }
         _loc2_ = 2;
         this.FBtnGet = new Vector.<TUIButton>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FBtnGet[_loc3_] = new TUIButton();
            this.FBtnGet[_loc3_].Substrate = FScene["MC_Block_" + _loc3_]["Btn_Get"];
            this.FBtnGet[_loc3_].Tag = _loc3_ + 1;
            this.FBtnGet[_loc3_].OnClick = this.ProcessorGet;
            (FScene["MC_Block_" + _loc3_]["MC_Mask"] as Sprite).addEventListener(MouseEvent.CLICK,this.ProcessorMask);
            _loc3_++;
         }
         this.FBtnRecharge = new TUIButton();
         this.FBtnRecharge.Substrate = FScene["MC_Prompt"]["Btn_Recharge"];
         this.FBtnRecharge.OnClick = this.ProcessorRecharge;
         this.CleanData();
      }
   }
}

