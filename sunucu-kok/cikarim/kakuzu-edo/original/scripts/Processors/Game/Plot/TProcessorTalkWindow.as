package Processors.Game.Plot
{
   import Components.Standard.TUIButton;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Processors.Game.Lobby.Common.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.TextField;
   
   public class TProcessorTalkWindow extends TProcessorLobbyWindow
   {
      
      public static const TYPE_NONE:int = 0;
      
      public static const TYPE_HERO:int = 1;
      
      public static const TYPE_ENEMY:int = 2;
      
      public static const TYPE_KNIFE:int = 3;
      
      public static const TYPE_NPC:int = 4;
      
      public static const NPCConfig_StartId:uint = 22100000;
      
      public static const EnemyConfig_StartId:uint = 12101000;
      
      public static const HeroConfig_StartId:uint = 11100000;
      
      public static const KnifeConfig_StartId:uint = 2000000;
      
      protected var FScene:MovieClip;
      
      protected var FPrinterEffect:TPrinterEffect;
      
      protected var FLeftBitmap:Bitmap;
      
      protected var FRightBitmap:Bitmap;
      
      protected var FLeftResourceID:uint;
      
      protected var FRightResourceID:uint;
      
      protected var FTalkIndex:int;
      
      protected var FTalkBins:TBins;
      
      protected var FRoleModelBins:TBins;
      
      protected var FNPCBins:TBins;
      
      protected var FKnifeBin:TBins;
      
      protected var FBaseHeroBin:TBins;
      
      protected var FEnemyBin:TBins;
      
      protected var FTalkVect:Vector.<Object>;
      
      protected var FPlayerName:String;
      
      protected var FBackSprite:Sprite;
      
      protected var FReleaseResourceIDs:Vector.<uint>;
      
      protected var FSkipPlot:TUIButton;
      
      protected var FMC_LeftDialog:MovieClip;
      
      protected var FMC_RightDialog:MovieClip;
      
      protected var FMC_LeftTalk:MovieClip;
      
      protected var FMC_RightTalk:MovieClip;
      
      protected var FTF_LeftTalk:TextField;
      
      protected var FTF_RightTalk:TextField;
      
      protected var FTF_LeftName:TextField;
      
      protected var FTF_RightName:TextField;
      
      protected var FMC_LeftHead:MovieClip;
      
      protected var FMC_RightHead:MovieClip;
      
      protected var FOnEndTalk:Function;
      
      public function TProcessorTalkWindow(param1:TUIComponent)
      {
         super(param1);
         this.InitTalkWindow();
         this.FReleaseResourceIDs = new Vector.<uint>();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(this.FPrinterEffect != null)
         {
            this.FPrinterEffect.CheckTimingByFrame();
         }
      }
      
      protected function InitTalkWindow() : void
      {
         this.FPlayerName = SLogicsCore.Character.NickName;
         this.FBackSprite = new Sprite();
         this.FBackSprite.graphics.beginFill(0);
         this.FBackSprite.graphics.drawRect(0,0,1250,650);
         this.FBackSprite.graphics.endFill();
         addChild(this.FBackSprite);
         this.FBackSprite.alpha = 0;
         this.FScene = TUtilityReflection.CreateDisplayObjectInstance(CONST_PLOT.RESOURCE_ClassName_PlotDialogt) as MovieClip;
         addChild(this.FScene);
         this.FScene.visible = false;
         this.FPrinterEffect = new TPrinterEffect(this);
         this.FMC_LeftDialog = this.FScene[CONST_PLOT.RESOURCES_Link_MC_LeftDialog];
         this.FMC_RightDialog = this.FScene[CONST_PLOT.RESOURCES_Link_MC_RightDialog];
         this.FMC_LeftTalk = this.FMC_LeftDialog[CONST_PLOT.RESOURCES_Link_MC_Talk];
         this.FMC_RightTalk = this.FMC_RightDialog[CONST_PLOT.RESOURCES_Link_MC_Talk];
         this.FTF_LeftTalk = this.FMC_LeftTalk[CONST_PLOT.RESOURCES_Link_TF_Talk];
         this.FTF_RightTalk = this.FMC_RightTalk[CONST_PLOT.RESOURCES_Link_TF_Talk];
         this.FTF_LeftName = this.FMC_LeftDialog[CONST_PLOT.RESOURCES_Link_TF_Name];
         this.FTF_RightName = this.FMC_RightDialog[CONST_PLOT.RESOURCES_Link_TF_Name];
         this.FMC_LeftHead = this.FMC_LeftDialog[CONST_PLOT.RESOURCES_Link_MC_Head];
         this.FMC_RightHead = this.FMC_RightDialog[CONST_PLOT.RESOURCES_Link_MC_Head];
         this.FLeftBitmap = new Bitmap();
         this.FMC_LeftHead.addChild(this.FLeftBitmap);
         this.FRightBitmap = new Bitmap();
         this.FMC_RightHead.addChild(this.FRightBitmap);
         this.FTalkVect = new Vector.<Object>();
         this.FTalkBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_TaskDramaDialogue);
         this.FRoleModelBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_RoleModel);
         this.FNPCBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_NPC);
         this.FKnifeBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Knife);
         this.FBaseHeroBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BaseHero);
         this.FEnemyBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Enemy);
         this.addEventListener(MouseEvent.MOUSE_UP,this.OnChgStatus);
         this.FSkipPlot = new TUIButton();
         this.FSkipPlot.Substrate = this.FScene[CONST_PLOT.RESOURCES_Link_BTN_Skip];
         this.FSkipPlot.OnClick = this.ButtonSkipOnClick;
         this.FSkipPlot.Visible = false;
      }
      
      protected function NextTalk(param1:Object = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:TNPC = null;
         var _loc9_:TKnife = null;
         var _loc10_:TBaseHero = null;
         var _loc11_:THero = null;
         var _loc12_:TEnemy = null;
         var _loc13_:String = null;
         var _loc14_:String = null;
         if(this.FTalkIndex >= this.FTalkVect.length)
         {
            this.FScene.visible = false;
            this.FPrinterEffect.Clear();
            if(this.FOnEndTalk != null)
            {
               this.FOnEndTalk(this);
            }
            return;
         }
         this.FLeftResourceID = 0;
         this.FRightResourceID = 0;
         _loc3_ = this.FTalkVect[this.FTalkIndex];
         _loc7_ = int(_loc3_.direction);
         _loc4_ = int(_loc3_.leftIcon);
         if(_loc4_ >= 0)
         {
            if(_loc4_ > 0)
            {
               _loc5_ = int((this.FRoleModelBins.GetDatebaseByIdentifier(_loc4_) as TRoleModel).RoleHead);
            }
            else
            {
               _loc11_ = SLogicsCore.Character.GetMainHero();
               _loc5_ = int(_loc11_.LargeID);
            }
            _loc6_ = _loc4_ > NPCConfig_StartId ? TYPE_NPC : (_loc4_ > EnemyConfig_StartId ? TYPE_ENEMY : (_loc4_ > HeroConfig_StartId ? TYPE_HERO : (_loc4_ > KnifeConfig_StartId ? TYPE_KNIFE : TYPE_NONE)));
            this.FLeftBitmap.bitmapData = null;
            this.FLeftResourceID = _loc5_;
            _loc2_ = this.FReleaseResourceIDs.indexOf(_loc5_);
            if(_loc2_ < 0)
            {
               this.FReleaseResourceIDs.push(_loc5_);
            }
            this.FLeftBitmap.filters = _loc7_ == 1 ? [] : [TUtilityFilter.darkFilters];
            if(_loc4_ == 0)
            {
               _loc13_ = _loc11_.Name;
            }
            else if(_loc6_ == TYPE_NPC)
            {
               _loc8_ = this.FNPCBins.GetDatebaseByIdentifier(_loc4_) as TNPC;
               _loc13_ = _loc8_.Name;
            }
            else if(_loc6_ == TYPE_KNIFE)
            {
               _loc9_ = this.FKnifeBin.GetDatebaseByIdentifier(_loc4_) as TKnife;
               _loc13_ = _loc9_.Name;
            }
            else if(_loc6_ == TYPE_ENEMY)
            {
               _loc12_ = this.FEnemyBin.GetDatebaseByIdentifier(_loc4_) as TEnemy;
               _loc13_ = _loc12_.Name;
            }
            else if(_loc6_ == TYPE_HERO)
            {
               _loc10_ = this.FBaseHeroBin.GetDatebaseByIdentifier(_loc4_) as TBaseHero;
               _loc13_ = _loc10_.Name;
            }
            else
            {
               _loc13_ = "";
            }
            this.FTF_LeftName.text = _loc13_;
            this.FMC_LeftDialog.visible = true;
         }
         else
         {
            this.FLeftBitmap.bitmapData = null;
            this.FTF_LeftName.text = "";
            this.FTF_LeftTalk.text = "";
            this.FMC_LeftDialog.visible = false;
         }
         _loc4_ = int(_loc3_.rightIcon);
         if(_loc4_ >= 0)
         {
            if(_loc4_ > 0)
            {
               _loc5_ = int((this.FRoleModelBins.GetDatebaseByIdentifier(_loc4_) as TRoleModel).RoleHead);
            }
            else
            {
               _loc11_ = SLogicsCore.Character.GetMainHero();
               _loc5_ = int(_loc11_.LargeID);
            }
            _loc6_ = _loc4_ > NPCConfig_StartId ? TYPE_NPC : (_loc4_ > EnemyConfig_StartId ? TYPE_ENEMY : (_loc4_ > HeroConfig_StartId ? TYPE_HERO : (_loc4_ > KnifeConfig_StartId ? TYPE_KNIFE : TYPE_NONE)));
            this.FRightBitmap.bitmapData = null;
            this.FRightResourceID = _loc5_;
            _loc2_ = this.FReleaseResourceIDs.indexOf(_loc5_);
            if(_loc2_ < 0)
            {
               this.FReleaseResourceIDs.push(_loc5_);
            }
            this.FRightBitmap.filters = _loc7_ == 2 ? [] : [TUtilityFilter.darkFilters];
            if(_loc4_ == 0)
            {
               _loc13_ = _loc11_.Name;
            }
            else if(_loc6_ == TYPE_NPC)
            {
               _loc8_ = this.FNPCBins.GetDatebaseByIdentifier(_loc4_) as TNPC;
               _loc13_ = _loc8_.Name;
            }
            else if(_loc6_ == TYPE_KNIFE)
            {
               _loc9_ = this.FKnifeBin.GetDatebaseByIdentifier(_loc4_) as TKnife;
               _loc13_ = _loc9_.Name;
            }
            else if(_loc6_ == TYPE_ENEMY)
            {
               _loc12_ = this.FEnemyBin.GetDatebaseByIdentifier(_loc4_) as TEnemy;
               _loc13_ = _loc12_.Name;
            }
            else if(_loc6_ == TYPE_HERO)
            {
               _loc10_ = this.FBaseHeroBin.GetDatebaseByIdentifier(_loc4_) as TBaseHero;
               _loc13_ = _loc10_.Name;
            }
            else
            {
               _loc13_ = "";
            }
            this.FTF_RightName.text = _loc13_;
            this.FMC_RightDialog.visible = true;
         }
         else
         {
            this.FRightBitmap.bitmapData = null;
            this.FTF_RightName.text = "";
            this.FTF_RightTalk.text = "";
            this.FMC_RightDialog.visible = false;
         }
         _loc14_ = this.GetTalkStr(_loc3_.info);
         _loc14_ = _loc14_.split("#playername#").join(this.FPlayerName);
         if(_loc7_ == 1)
         {
            this.FPrinterEffect.SetTextContains(this.FTF_LeftTalk);
            this.FMC_LeftDialog.gotoAndStop(1);
            this.FMC_RightDialog.gotoAndStop(2);
         }
         else
         {
            this.FPrinterEffect.SetTextContains(this.FTF_RightTalk);
            this.FMC_LeftDialog.gotoAndStop(2);
            this.FMC_RightDialog.gotoAndStop(1);
         }
         this.FPrinterEffect.SetTextInfo(_loc14_);
         ++this.FTalkIndex;
         this.LoadHomeSubstrate();
      }
      
      protected function GetTalkStr(param1:uint) : String
      {
         var _loc2_:TTaskDramaDialogue = null;
         _loc2_ = this.FTalkBins.GetDatebaseByIdentifier(param1) as TTaskDramaDialogue;
         return _loc2_ ? _loc2_.Conversations : "";
      }
      
      protected function LoadHomeSubstrate() : void
      {
         if(this.FLeftResourceID != 0)
         {
            SResourcesCore.TexturesLargeIcon.LoadAutoPrimary(this.FLeftResourceID,this.AutoLoadCallBack);
         }
         if(this.FRightResourceID != 0)
         {
            SResourcesCore.TexturesLargeIcon.LoadAutoPrimary(this.FRightResourceID,this.AutoLoadCallBack);
         }
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         switch(param3)
         {
            case this.FLeftResourceID:
               _loc4_ = param2.GetAnimationSequenceByIndex(0);
               this.FLeftBitmap.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
               break;
            case this.FRightResourceID:
               _loc4_ = param2.GetAnimationSequenceByIndex(0);
               this.FRightBitmap.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
         }
      }
      
      protected function OnChgStatus(param1:MouseEvent) : void
      {
         if(this.FScene.visible == false)
         {
            return;
         }
         if(this.FPrinterEffect.IsPrinterEnd)
         {
            this.NextTalk(this);
         }
         else
         {
            this.FPrinterEffect.OnShowAllText();
         }
      }
      
      protected function ButtonSkipOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FScene.visible = false;
         this.FPrinterEffect.Clear();
         if(this.FOnEndTalk != null)
         {
            this.FOnEndTalk(this);
         }
      }
      
      public function get OnEndTalk() : Function
      {
         return this.FOnEndTalk;
      }
      
      public function set OnEndTalk(param1:Function) : void
      {
         this.FOnEndTalk = param1;
      }
      
      public function SetTalkInfo(param1:Vector.<Object>) : void
      {
         this.FTalkVect = param1;
         this.FTalkIndex = 0;
         this.FScene.visible = true;
         this.FTF_LeftTalk.text = "";
         this.FTF_RightTalk.text = "";
         this.NextTalk();
         this.LoadHomeSubstrate();
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.FLeftBitmap.bitmapData != null)
         {
            this.FLeftBitmap.bitmapData = null;
         }
         if(this.FRightBitmap.bitmapData != null)
         {
            this.FRightBitmap.bitmapData = null;
         }
         _loc2_ = int(this.FReleaseResourceIDs.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            SResourcesCore.TexturesLargeIcon.DeleteByIdentifier(this.FReleaseResourceIDs[_loc1_],true);
            _loc1_++;
         }
         this.FReleaseResourceIDs.length = 0;
      }
   }
}

