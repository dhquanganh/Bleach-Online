package Processors.Game.Lobby.VoidSoulWorld
{
   import Components.Pages.TUIPage;
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.Common.THint;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Foundation.Utilities.TUtilityTexture;
   import Logics.DatebaseVO.VO.TEnemy;
   import Logics.DatebaseVO.VO.TEnemyArmy;
   import Logics.DatebaseVO.VO.TRoleModel;
   import Logics.HDActivityMode.TGiftBoxTipData;
   import Logics.Inventories.TInventories;
   import Logics.Map.TMoudleInfor;
   import Logics.SLogicsCore;
   import Logics.Streamization.VoidSoulWorld.TUnstreamizerVoidSoulWorld;
   import Logics.VoidSoulWorld.TVoidSoulWorldData;
   import Logics.VoidSoulWorld.VO.TFrontVO;
   import Logics.VoidSoulWorld.VO.TPlayerHurtVO;
   import Logics.VoidSoulWorld.VO.TRankRewardVO;
   import Processors.Game.Battle.GoneWord.TGoneWord;
   import Processors.Game.Battle.GoneWord.TPoolEffectGoneWord;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudle;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.CONST_BATTLE;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_CONFIGVALUE;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_FONTLIBRARY;
   import Resources.Constants.CONST_MAP;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import Resources.Constants.CONST_VOIDSOULWORLD;
   import flash.display.Bitmap;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class TProcessorVoidSoulWorldMainWin extends TProcessorLobbyWindow
   {
      
      protected const RankRewardCount:uint = 5;
      
      protected const FrontDirection:Vector.<String> = Vector.<String>([TFrontController.Direction_Down,TFrontController.Direction_Down,TFrontController.Direction_Up,TFrontController.Direction_Up]);
      
      protected var FMainUI:MovieClip;
      
      protected var FGoldRebirth:TProcessorGoldRebirth;
      
      protected var FMonsterHead:TProcessorMonsterHead;
      
      protected var FFrontControllerList:Vector.<TFrontController>;
      
      protected var FData:TVoidSoulWorldData;
      
      protected var FUnstreamizer:TUnstreamizerVoidSoulWorld;
      
      protected var FSpriteMoudle:TSceneSpriteMoudle;
      
      protected var FQureyMoudleInfor:TMoudleInfor;
      
      protected var FBossTotalHP:Number;
      
      protected var FServerBoss:Object;
      
      protected var FRenderedBossRevision:int = 0;
      
      protected var FEntryPending:Boolean = false;
      
      protected var FBossHPText:TextField;
      
      protected var FReportBtn:Vector.<TUIButton>;
      
      protected var FBossHead:Bitmap;
      
      protected var FGiftBoxTipData:TGiftBoxTipData;
      
      protected var FBoxInvs:Vector.<TInventories>;
      
      protected var FSeeFormBtn:TUIButton;
      
      protected var FHint:THint;
      
      protected var FSubmitFormBtn:TUIButton;
      
      protected var FJoinAwardBtn:TUIButton;
      
      protected var FJoinAwardInvs:TInventories;
      
      protected var FAllPlayerList:Vector.<Sprite>;
      
      protected var FRankReward:Vector.<TRankRewardVO>;
      
      protected var FRankPage:TUIPage;
      
      protected var FRankPageIndex:uint;
      
      protected var FRndAwardInvs:TInventories;
      
      protected var FEffectSprite:Sprite;
      
      public function TProcessorVoidSoulWorldMainWin(param1:TUIComponent)
      {
         var _loc2_:uint = 0;
         super(param1);
         this.FData = SLogicsCore.VoidSoulWorldData;
         this.FUnstreamizer = new TUnstreamizerVoidSoulWorld(this.FData);
         this.FHint = new THint();
         this.FGiftBoxTipData = new TGiftBoxTipData();
         this.FJoinAwardInvs = new TInventories();
         this.FRndAwardInvs = new TInventories();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TUIButton = null;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         var _loc5_:TFrontController = null;
         var _loc6_:Point = null;
         var _loc7_:Point = null;
         var _loc8_:MovieClip = null;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_VoidSoulWorld") as MovieClip;
         addChild(this.FMainUI);
         this.FBossHPText = new TextField();
         this.FBossHPText.width = this.FMainUI.MC_HP.width;
         this.FBossHPText.height = this.FMainUI.MC_HP.height;
         this.FBossHPText.defaultTextFormat = new TextFormat("_sans",12,16777215,true,null,null,null,null,"center");
         this.FBossHPText.selectable = false;
         this.FBossHPText.mouseEnabled = false;
         this.FBossHPText.multiline = false;
         this.FBossHPText.wordWrap = false;
         this.FMainUI.MC_HP.addChild(this.FBossHPText);
         this.FQureyMoudleInfor = new TMoudleInfor();
         this.FSpriteMoudle = new TSceneSpriteMoudle();
         this.FMainUI.MC_PlayerLayer.MC_BossMount.addChild(this.FSpriteMoudle);
         this.FReportBtn = new Vector.<TUIButton>(CONST_VOIDSOULWORLD.COUNT_ReportId);
         _loc1_ = 0;
         while(_loc1_ < CONST_VOIDSOULWORLD.COUNT_ReportId)
         {
            _loc2_ = new TUIButton();
            _loc2_.Tag = _loc1_;
            _loc2_.Substrate = this.FMainUI.MC_Report["MC_Report_" + _loc1_].Btn_See;
            _loc2_.OnClick = this.OnReportBtnClick;
            this.FReportBtn.push(_loc2_);
            _loc1_++;
         }
         this.FBossHead = new Bitmap();
         this.FMainUI.MC_BossHead.MC_Bmp_Icon.addChild(this.FBossHead);
         this.FMainUI.MC_BossHead.addEventListener(MouseEvent.CLICK,this.OnBossHeadClick);
         this.FMainUI.MC_BossHead.buttonMode = true;
         _loc1_ = 0;
         while(_loc1_ < CONST_VOIDSOULWORLD.COUNT_Box)
         {
            _loc3_ = this.FMainUI.MC_Box["MC_Box_" + _loc1_];
            _loc3_.Tag = _loc1_;
            _loc3_.addEventListener(MouseEvent.MOUSE_MOVE,this.OnBoxOver);
            _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this.OnBoxOut);
            _loc1_++;
         }
         this.FFrontControllerList = new Vector.<TFrontController>(CONST_VOIDSOULWORLD.COUNT_Front);
         _loc9_ = uint(TUtilityLobby.GetObjectByIdentifier(CONST_CONFIGVALUE.VoidSoulWorld_Duration));
         _loc10_ = uint(TUtilityLobby.GetObjectByIdentifier(CONST_CONFIGVALUE.VoidSoulWorld_PlayerInterval));
         this.FAllPlayerList = new Vector.<Sprite>();
         this.FAllPlayerList.push(this.FMainUI.MC_PlayerLayer.MC_BossMount);
         _loc1_ = 0;
         while(_loc1_ < CONST_VOIDSOULWORLD.COUNT_Front)
         {
            _loc3_ = this.FMainUI["MC_StartPos_" + _loc1_];
            _loc8_ = _loc3_;
            _loc6_ = new Point(_loc3_.x,_loc3_.y);
            _loc3_ = this.FMainUI["MC_EndPos_" + _loc1_];
            _loc7_ = new Point(_loc3_.x,_loc3_.y);
            _loc5_ = new TFrontController();
            _loc5_.Play = this.Play;
            _loc5_.AddPlayer = this.AddPlayer;
            _loc5_.RemovePlayer = this.RemovePlayer;
            _loc5_.FrontVO = this.FData.Front[_loc1_];
            _loc5_.SetCore(_loc6_,_loc7_,_loc8_,this.FMainUI.MC_PlayerLayer,_loc9_,_loc10_,this.FrontDirection[_loc1_]);
            this.FFrontControllerList[_loc1_] = _loc5_;
            _loc1_++;
         }
         this.FSeeFormBtn = new TUIButton();
         this.FSeeFormBtn.Substrate = this.FMainUI.Btn_SeeForm;
         this.FSeeFormBtn.OnMove = this.OnSeeFormBtnMove;
         this.FSeeFormBtn.OnOut = this.OnSeeFormBtnOut;
         this.FSubmitFormBtn = new TUIButton();
         this.FSubmitFormBtn.Substrate = this.FMainUI.Btn_SubmitForm;
         this.FSubmitFormBtn.OnClick = this.OnSubmitFormBtnClick;
         this.FJoinAwardBtn = new TUIButton();
         this.FJoinAwardBtn.Substrate = this.FMainUI.MC_JoinAward.MC_Award;
         this.FJoinAwardBtn.OnClick = this.OnJoinAwardBtnClick;
         this.FJoinAwardBtn.OnMove = this.OnJoinAwardBtnMove;
         this.FJoinAwardBtn.OnOut = this.OnJoinAwardBtnOut;
         SUtilityOverLayer.OverlayerVoidWorldForm.UIDispatch();
         this.FGoldRebirth = new TProcessorGoldRebirth(this);
         this.FGoldRebirth.OnRebirth = this.OnRebirth;
         this.FGoldRebirth.XCost = int(TUtilityLobby.GetObjectByIdentifier(CONST_CONFIGVALUE.VoidSoulWorld_RebirthCost));
         this.FGoldRebirth.XSecond = 3;
         this.FGoldRebirth.UIDispatch();
         this.FMonsterHead = new TProcessorMonsterHead(this);
         this.FMonsterHead.UIDispatch();
         this.FEffectSprite = new Sprite();
         addChild(this.FEffectSprite);
         this.StructureRankReward();
         _loc3_ = this.FMainUI.MC_RankReward;
         this.FRankPage = new TUIPage(this);
         this.FRankPage.ButtonNext.Substrate = _loc3_.MC_PageRight;
         this.FRankPage.ButtonPrevious.Substrate = _loc3_.MC_PageLeft;
         this.FRankPage.LabelPage = _loc3_.TF_Page;
         this.FRankPage.PageSize = this.RankRewardCount;
         this.FRankPage.TotalQuantity = this.FRankReward.length;
         this.FRankPage.OnChangePage = this.RankPageOnSwitch;
         this.FRankPage.Init();
         this.FRankPage.Update();
         this.FRankPageIndex = 0;
         this.UpdateRankPage();
         _loc1_ = 0;
         while(_loc1_ < this.RankRewardCount)
         {
            _loc4_ = _loc3_["MC_Reward_" + _loc1_];
            _loc4_.MC_Box.addEventListener(MouseEvent.MOUSE_MOVE,this.OnRankRewardBoxMove);
            _loc4_.MC_Box.addEventListener(MouseEvent.MOUSE_OUT,this.OnRankRewardBoxOut);
            _loc4_.TF_Count.mouseEnabled = false;
            _loc1_++;
         }
         this.FMainUI.MC_JoinAward.MC_Received.mouseEnabled = false;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UIFinalize() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TInventories = null;
         var _loc3_:Vector.<uint> = null;
         _loc3_ = TUtilityLobby.GetObjectByIdentifier(CONST_CONFIGVALUE.VoidSoulWorld_GradeReward) as Vector.<uint>;
         this.FBoxInvs = new Vector.<TInventories>(CONST_VOIDSOULWORLD.COUNT_Box);
         _loc1_ = 0;
         while(_loc1_ < CONST_VOIDSOULWORLD.COUNT_Box)
         {
            _loc2_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc3_[_loc1_],_loc2_);
            this.AdjustVoidRewards(_loc2_);
            this.FBoxInvs[_loc1_] = _loc2_;
            _loc1_++;
         }
         this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_VoidSoulWorld_07);
         super.ResourcesPerform_UIFinalize();
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:TFrontController = null;
         if(Visible)
         {
            for each(_loc1_ in this.FFrontControllerList)
            {
               _loc1_.LogicsPerform();
            }
            this.FSpriteMoudle.UpdateView();
            this.DepthSorting();
         }
         super.LogicsPerform();
      }
      
      protected function UpdateRebirthCD() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         _loc1_ = uint(int(TUtilityLobby.GetObjectByIdentifier(CONST_CONFIGVALUE.VoidSoulWorld_DeadTime)));
         _loc2_ = STimingCore.ServerTick - this.FData.DeadTime;
         if(_loc2_ < 0)
         {
            this.FGoldRebirth.Visible = false;
            return;
         }
         _loc3_ = Math.max(0,_loc1_ - _loc2_);
         if(_loc3_ == 0)
         {
            this.FGoldRebirth.Visible = false;
         }
         else
         {
            this.FGoldRebirth.TotalTime = _loc3_;
            this.FGoldRebirth.Start();
         }
      }
      
      protected function UpdatePlayGuide() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:uint = 0;
         _loc2_ = 0;
         while(_loc2_ < CONST_VOIDSOULWORLD.COUNT_Front)
         {
            _loc1_ = this.FMainUI["MC_Pointer_" + _loc2_];
            _loc1_.mouseEnabled = true;
            _loc1_.mouseChildren = false;
            _loc1_.buttonMode = true;
            _loc1_.addEventListener(MouseEvent.CLICK,this.OnBattlePointerClick,false,0,true);
            if(this.FData.GameStart())
            {
               _loc1_.play();
               _loc1_.visible = true;
            }
            else
            {
               _loc1_.stop();
               _loc1_.visible = false;
            }
            _loc2_++;
         }
      }
      
      public function ApplyBossConfig(value:Object) : void
      {
         this.FServerBoss = value;
         this.FEntryPending = false;
      }
      
      public function set EntryPending(value:Boolean) : void
      {
         this.FEntryPending = value;
      }
      
      protected function SetServerBossName(node:DisplayObjectContainer) : void
      {
         var i:int = 0;
         while(i < node.numChildren)
         {
            var text:TextField = node.getChildAt(i) as TextField;
            if(text != null)
            {
               text.text = String(this.FServerBoss.name);
            }
            else if(node.getChildAt(i) is DisplayObjectContainer)
            {
               this.SetServerBossName(node.getChildAt(i) as DisplayObjectContainer);
            }
            i++;
         }
      }
      
      protected function OnBattlePointerClick(event:MouseEvent) : void
      {
         event.stopImmediatePropagation();
         var i:int = 0;
         while(i < this.FFrontControllerList.length)
         {
            if(event.currentTarget == this.FMainUI["MC_Pointer_" + i])
            {
               this.FFrontControllerList[i].RequestFight();
               return;
            }
            i++;
         }
      }
      
      protected function UpdateBossModel() : void
      {
         if(this.FServerBoss != null)
         {
            this.FBossTotalHP = Number(this.FServerBoss.hp);
            if(this.FRenderedBossRevision == int(this.FServerBoss.revision))
            {
               return;
            }
            var role:TRoleModel = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,uint(this.FServerBoss.roleId)) as TRoleModel;
            if(role == null)
            {
               return;
            }
            TUtilityTexture.QueryTwoDirectionShowCase(CONST_MAP.DIRECTION_RIGHT,role.Model,this.FQureyMoudleInfor);
            this.FSpriteMoudle.ChangeRoleMoudle(this.FQureyMoudleInfor.TextureID,this.FQureyMoudleInfor.Scalx);
            this.FBossHead.bitmapData = null;
            SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(role.RoleHead,this.BossHeadLoadOK);
            this.FMonsterHead.UpdateBoss(uint(this.FServerBoss.enemyId));
            this.SetServerBossName(this.FMainUI.MC_BossHead);
            this.FRenderedBossRevision = int(this.FServerBoss.revision);
            return;
         }
         var _loc1_:uint = 0;
         var _loc2_:Date = null;
         var _loc3_:Vector.<uint> = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:int = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:TEnemyArmy = null;
         var _loc11_:TRoleModel = null;
         var _loc12_:TEnemy = null;
         _loc1_ = uint(int(TUtilityLobby.GetObjectByIdentifier(CONST_CONFIGVALUE.VoidSoulWorld_BossModel)));
         _loc3_ = TUtilityLobby.GetObjectByIdentifier(CONST_CONFIGVALUE.VoidSoulWorld_OpenDate) as Vector.<uint>;
         _loc2_ = new Date();
         _loc2_.time = STimingCore.ServerTickM;
         _loc5_ = _loc3_.length;
         _loc7_ = -1;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc3_[_loc4_];
            if(_loc2_.date <= _loc6_)
            {
               _loc7_ = int(_loc6_);
               break;
            }
            _loc4_++;
         }
         if(_loc7_ == -1)
         {
            _loc7_ = int(_loc3_[0]);
         }
         _loc8_ = _loc1_ + _loc7_;
         _loc10_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_EnemyArmy,_loc8_) as TEnemyArmy;
         _loc9_ = _loc10_.LeaderID;
         _loc11_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,_loc9_) as TRoleModel;
         TUtilityTexture.QueryTwoDirectionShowCase(CONST_MAP.DIRECTION_RIGHT,_loc11_.Model,this.FQureyMoudleInfor);
         this.FSpriteMoudle.ChangeRoleMoudle(this.FQureyMoudleInfor.TextureID,this.FQureyMoudleInfor.Scalx);
         this.FBossTotalHP = this.GetEnemyArmyHP(_loc10_.FrontVect) + this.GetEnemyArmyHP(_loc10_.MiddleVect) + this.GetEnemyArmyHP(_loc10_.BackVect);
         SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc11_.RoleHead,this.BossHeadLoadOK);
         this.FMonsterHead.Update(_loc10_);
      }
      
      protected function GetEnemyArmyHP(param1:Vector.<uint>) : Number
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TEnemy = null;
         var _loc6_:Number = Number(NaN);
         _loc6_ = 0;
         if(param1 == null)
         {
            return _loc6_;
         }
         _loc3_ = param1.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1[_loc2_];
            _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Enemy,_loc4_) as TEnemy;
            _loc6_ += _loc5_.Hp;
            _loc2_++;
         }
         return _loc6_;
      }
      
      protected function UpdateBossHD() : void
      {
         var _loc1_:Number = Number(NaN);
         if(this.FData.BossHP < 0)
         {
            this.FData.BossHP = this.FBossTotalHP;
         }
         _loc1_ = this.FData.BossHP / this.FBossTotalHP;
         if(_loc1_ < 0)
         {
            _loc1_ = 0;
         }
         else if(_loc1_ > 1)
         {
            _loc1_ = 1;
         }
         this.FMainUI.MC_HP.MC_Bar.scaleX = _loc1_;
         if(this.FBossHPText != null)
         {
            this.FBossHPText.text = this.FormatBossHP(this.FData.BossHP) + " / " + this.FormatBossHP(this.FBossTotalHP);
         }
      }
      
      protected function FormatBossHP(param1:Number) : String
      {
         var _loc2_:String = Math.max(0,Math.floor(param1)).toString();
         var _loc3_:String = "";
         while(_loc2_.length > 3)
         {
            _loc3_ = "," + _loc2_.substr(_loc2_.length - 3) + _loc3_;
            _loc2_ = _loc2_.substr(0,_loc2_.length - 3);
         }
         return _loc2_ + _loc3_;
      }
      
      protected function UpdateReportId() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:MovieClip = null;
         var _loc3_:uint = 0;
         _loc1_ = this.FMainUI.MC_Report;
         _loc3_ = 0;
         while(_loc3_ < CONST_VOIDSOULWORLD.COUNT_ReportId)
         {
            _loc2_ = _loc1_["MC_Report_" + _loc3_];
            if(_loc3_ < this.FData.ReportId.length)
            {
               _loc2_.visible = true;
            }
            else
            {
               _loc2_.visible = false;
            }
            _loc3_++;
         }
      }
      
      protected function UpdateRank() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:MovieClip = null;
         var _loc3_:uint = 0;
         var _loc4_:TPlayerHurtVO = null;
         var _loc5_:String = null;
         _loc1_ = this.FMainUI.MC_RankInfo;
         _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_VoidSoulWorld_05);
         _loc3_ = 0;
         while(_loc3_ < CONST_VOIDSOULWORLD.COUNT_HurlRank)
         {
            _loc2_ = _loc1_["MC_RankInfo_" + _loc3_];
            if(_loc3_ < this.FData.HurtRank.length)
            {
               _loc4_ = this.FData.HurtRank[_loc3_];
               _loc2_.visible = true;
               _loc2_.TF_Rank.text = String(_loc3_ + 1);
               _loc2_.TF_Name.text = _loc4_.PlayerName;
               _loc2_.TF_Name.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[_loc4_.Quality];
               _loc2_.TF_Platform.text = TUtilityString.Format(_loc5_,_loc4_.ServerName,_loc4_.ServerID);
               _loc2_.TF_Hurt.text = _loc4_.Hurt.toFixed();
            }
            else
            {
               _loc2_.visible = false;
            }
            _loc3_++;
         }
      }
      
      protected function StructureRankReward() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TRankRewardVO = null;
         var _loc4_:TRankRewardVO = null;
         var _loc5_:Vector.<uint> = null;
         this.FRankReward = new Vector.<TRankRewardVO>();
         _loc5_ = TUtilityLobby.GetObjectByIdentifier(CONST_CONFIGVALUE.VoidSoulWorld_Ranking) as Vector.<uint>;
         _loc3_ = new TRankRewardVO();
         _loc3_.BoxCount = _loc5_.pop();
         _loc3_.StartRank = _loc5_.length + 1;
         _loc3_.EndRank = 100;
         while(_loc1_ < _loc5_.length)
         {
            _loc4_ = new TRankRewardVO();
            _loc4_.BoxCount = _loc5_[_loc1_];
            _loc4_.StartRank = _loc1_ + 1;
            while(_loc2_ < _loc5_.length)
            {
               if(_loc5_[_loc1_] != _loc5_[_loc2_])
               {
                  break;
               }
               _loc4_.EndRank = _loc2_ + 1;
               _loc2_++;
            }
            this.FRankReward.push(_loc4_);
            _loc1_ = _loc2_;
         }
         this.FRankReward.push(_loc3_);
      }
      
      protected function GetGlobalIndex(param1:uint) : uint
      {
         return this.FRankPageIndex * this.RankRewardCount + param1;
      }
      
      protected function UpdateRankPage() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TRankRewardVO = null;
         var _loc4_:MovieClip = null;
         var _loc5_:uint = 0;
         _loc2_ = this.FRankReward.length;
         _loc1_ = 0;
         while(_loc1_ < this.RankRewardCount)
         {
            _loc4_ = this.FMainUI.MC_RankReward["MC_Reward_" + _loc1_];
            _loc5_ = this.GetGlobalIndex(_loc1_);
            if(_loc5_ < _loc2_)
            {
               _loc3_ = this.FRankReward[_loc5_];
               _loc4_.TF_Count.text = _loc3_.BoxCount;
               if(_loc3_.StartRank == _loc3_.EndRank)
               {
                  _loc4_.TF_Desc.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_VoidSoulWorld_14),_loc3_.StartRank);
               }
               else
               {
                  _loc4_.TF_Desc.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_VoidSoulWorld_15),_loc3_.StartRank,_loc3_.EndRank);
               }
               _loc4_.visible = true;
               _loc4_.MC_Box.gotoAndStop(_loc5_ + 1);
            }
            else
            {
               _loc4_.visible = false;
            }
            _loc1_++;
         }
      }
      
      protected function RankPageOnSwitch(param1:Object, param2:int) : void
      {
         this.FRankPageIndex = param2;
         this.UpdateRankPage();
      }
      
      protected function Play(param1:TFrontController) : void
      {
         if(this.FEntryPending)
         {
            return;
         }
         var _loc2_:TFrontVO = null;
         var _loc3_:uint = 0;
         if(this.FGoldRebirth.Visible)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_VoidSoulWorld_16));
            return;
         }
         for each(_loc2_ in this.FData.Front)
         {
            if(_loc2_.GetPlayerByOnlyID(SLogicsCore.Character.Identifier0,SLogicsCore.Character.Identifier1) != null)
            {
               SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_VoidSoulWorld_04));
               return;
            }
         }
         _loc3_ = this.FFrontControllerList.indexOf(param1);
         this.FEntryPending = true;
         this.FUnstreamizer.FightEnterReq(_loc3_);
      }
      
      protected function AddPlayer(param1:Sprite) : void
      {
         this.FAllPlayerList.push(param1);
      }
      
      protected function RemovePlayer(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FAllPlayerList.indexOf(param1);
         this.FAllPlayerList.splice(_loc2_,1);
      }
      
      protected function OnRebirth() : void
      {
         this.FUnstreamizer.ReviveReq();
      }
      
      protected function OnReportBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         _loc4_ = uint((param1 as TUIButton).Tag);
         _loc3_ = this.FData.ReportId[_loc4_];
         SExternalCore.NavigateToBattleReportUrl(_loc3_);
      }
      
      protected function BossHeadLoadOK(param1:Object, param2:TTexture, param3:uint) : void
      {
         if(param2 == null)
         {
            return;
         }
         if(this.FServerBoss != null)
         {
            var role:TRoleModel = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,uint(this.FServerBoss.roleId)) as TRoleModel;
            if(role == null || role.RoleHead != param3)
            {
               return;
            }
         }
         this.FBossHead.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
      }
      
      protected function OnBoxOver(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:TInventories = null;
         _loc2_ = uint(param1.currentTarget.Tag);
         this.FGiftBoxTipData.TipReset();
         this.FGiftBoxTipData.NormalInventories = this.FBoxInvs[_loc2_];
         this.FGiftBoxTipData.AwardType = TOverlayerGiftBox.TYPE_ALL;
         this.FGiftBoxTipData.NeedColour = true;
         this.FGiftBoxTipData.CustomizeCaption = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRING_VoidSoulWorld_13)[_loc2_];
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FGiftBoxTipData);
      }
      
      protected function OnBoxOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FGiftBoxTipData);
      }
      
      protected function OnSeeFormBtnMove(param1:Object, param2:MouseEvent) : void
      {
         if(this.FSeeFormBtn.Enabled)
         {
            SUtilityOverLayer.UIComponentsHintOnOver(this,this.FData.Form);
         }
         else
         {
            SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
         }
      }
      
      protected function OnSeeFormBtnOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FSeeFormBtn.Enabled)
         {
            SUtilityOverLayer.UIComponentsHintOnOut(this,this.FData.Form);
         }
         else
         {
            SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
         }
      }
      
      protected function OnSubmitFormBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:String = null;
         _loc4_ = uint(TUtilityLobby.GetObjectByIdentifier(CONST_CONFIGVALUE.VoidSoulWorld_BattleInterval));
         _loc3_ = STimingCore.ServerTick - this.FData.SubmitTime;
         _loc5_ = Math.max(0,_loc4_ - _loc3_);
         if(_loc5_ != 0)
         {
            _loc6_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_VoidSoulWorld_08);
            _loc6_ = TUtilityString.Format(_loc6_,_loc5_);
            SToolReward.ShowMessage(_loc6_);
         }
         else
         {
            this.FUnstreamizer.InfoSubmitReq();
         }
      }
      
      protected function OnJoinAwardBtnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FUnstreamizer.JoinAwardReq();
      }
      
      protected function OnJoinAwardBtnMove(param1:Object, param2:MouseEvent) : void
      {
         this.FGiftBoxTipData.TipReset();
         this.FGiftBoxTipData.NormalInventories = this.FJoinAwardInvs;
         this.FGiftBoxTipData.AwardType = TOverlayerGiftBox.TYPE_ALL;
         this.FGiftBoxTipData.NeedColour = true;
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FGiftBoxTipData);
      }
      
      protected function OnJoinAwardBtnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FGiftBoxTipData);
      }
      
      protected function OnRankRewardBoxMove(param1:MouseEvent) : void
      {
         this.FGiftBoxTipData.TipReset();
         this.FGiftBoxTipData.NormalInventories = this.FRndAwardInvs;
         this.FGiftBoxTipData.AwardType = TOverlayerGiftBox.TYPE_ALL;
         this.FGiftBoxTipData.NeedColour = true;
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FGiftBoxTipData);
      }
      
      protected function OnRankRewardBoxOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FGiftBoxTipData);
      }
      
      protected function OnBossHeadClick(param1:MouseEvent) : void
      {
         this.FMonsterHead.Visible = true;
      }
      
      protected function DepthSorting() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:Sprite = null;
         this.FAllPlayerList.sort(this.DepthCompare);
         _loc2_ = this.FAllPlayerList.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FAllPlayerList[_loc1_];
            this.FMainUI.MC_PlayerLayer.setChildIndex(_loc3_,_loc1_);
            _loc1_++;
         }
      }
      
      protected function DepthCompare(param1:Sprite, param2:Sprite) : int
      {
         if(param1.y < param2.y)
         {
            return -1;
         }
         if(param1.y == param2.y)
         {
            return 0;
         }
         return 1;
      }
      
      public function UpdateUI() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:Vector.<uint> = null;
         this.UpdateRank();
         this.UpdateReportId();
         this.UpdateBossModel();
         this.UpdateBossHD();
         this.UpdateRebirthCD();
         this.UpdatePlayGuide();
         this.FJoinAwardInvs.Clear();
         _loc2_ = TUtilityLobby.GetObjectByIdentifier(CONST_CONFIGVALUE.VoidSoulWorld_JoinAward) as Vector.<uint>;
         _loc1_ = _loc2_[this.FData.JoinAwardIndex];
         SToolReward.GetAwardsByAwardID(_loc1_,this.FJoinAwardInvs);
         this.AdjustVoidRewards(this.FJoinAwardInvs);
         this.FRndAwardInvs.Clear();
         _loc2_ = TUtilityLobby.GetObjectByIdentifier(CONST_CONFIGVALUE.VoidSoulWorld_RndAward) as Vector.<uint>;
         _loc1_ = _loc2_[this.FData.JoinAwardIndex];
         SToolReward.GetAwardsByAwardID(_loc1_,this.FRndAwardInvs);
         this.AdjustVoidRewards(this.FRndAwardInvs);
         this.FMainUI.TF_MyHurt.text = this.FData.MyHurt.toString();
         this.FSeeFormBtn.Enabled = this.FData.HaveForm();
         if(this.FData.JoinAwardState == 1)
         {
            this.FMainUI.MC_JoinAward.MC_Received.visible = true;
            this.FJoinAwardBtn.Enabled = false;
         }
         else
         {
            this.FMainUI.MC_JoinAward.MC_Received.visible = false;
            if(this.FData.GameStart())
            {
               this.FJoinAwardBtn.Enabled = true;
            }
            else
            {
               this.FJoinAwardBtn.Enabled = false;
            }
         }
      }

      protected function AdjustVoidRewards(rewards:TInventories) : void
      {
         var i:int = 0;
         var item:Object = null;
         if(rewards == null)return;
         for(i=0;i<rewards.Count;i++)
         {
            item = rewards.GetInventoryByIndex(i);
            if(item == null)continue;
            if(uint(item.IDTemplate) == 14100024 || uint(item.IDTemplate) == 14100023)
            {
               item.IDTemplate = 14900001;
               item.IDTexture = 14900001;
               item.Name = "Nguyên thạch";
            }
            item.Quantity = Math.min(65535,uint(item.Quantity) * 2);
         }
      }
      
      public function UpdateAllPlayers() : void
      {
         var _loc1_:TFrontController = null;
         for each(_loc1_ in this.FFrontControllerList)
         {
            _loc1_.UpdateAllPlayers();
         }
      }
      
      public function AddLast(param1:uint) : void
      {
         this.FFrontControllerList[param1].AddLast();
      }
      
      public function Death(param1:uint, param2:uint) : void
      {
         this.FFrontControllerList[param1].Death(param2);
      }
      
      public function GoneBossHurt(param1:Number) : void
      {
         var _loc2_:TGoneWord = null;
         _loc2_ = TPoolEffectGoneWord.GetGoneWord();
         this.FEffectSprite.addChild(_loc2_);
         _loc2_.SetGoneWord(this.FMainUI.MC_PlayerLayer.MC_BossMount.x,this.FMainUI.MC_PlayerLayer.MC_BossMount.y - 210,param1.toString(),0,-5,36,CONST_BATTLE.TEXT_Dec_Color,CONST_BATTLE.TEXT_Dec_FilterColor,CONST_FONTLIBRARY.FONT_NAME_Bleach_UI_01);
         _loc2_.x -= _loc2_.EffectWidth / 2;
         _loc2_.StartFloat();
      }
   }
}

