package Processors.Game.Battle
{
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.KnifeOfKillSoul.TKnifeOfKillSoulData;
   import Processors.Game.Battle.GoneWord.TGoneWord;
   import Processors.Game.Battle.GoneWord.TPoolEffectGoneWord;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Rendering.Texts.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.MouseEvent;
   import flash.text.*;
   import ghostcat.util.easing.TweenUtil;
   
   public class TChain extends TUIComponent
   {
      
      protected static const REMAIN_NUMBER:uint = 20;
      
      protected static const MAX_TURN:uint = 10000;
      
      protected static const MIN_KNIFESOUL_LEVEL:int = CONST_BATTLE.MIN_KNIFESOUL_LEVEL;
      
      protected static const MAX_KNIFESOUL_LEVEL:int = CONST_BATTLE.MAX_KNIFESOUL_LEVEL;
      
      protected static const STAMP_WIDTH:uint = 181;
      
      protected var FKnifeOfKillSoulDataLeft:TKnifeOfKillSoulData;
      
      protected var FKnifeOfKillSoulDataRight:TKnifeOfKillSoulData;
      
      protected var FHint:THint;
      
      protected var FScene:Sprite;
      
      protected var FMC_TotleTurn:Sprite;
      
      protected var FTF_RemainTurnNumber:TextField;
      
      protected var FLeftBitmap:Bitmap;
      
      protected var FRightBitmap:Bitmap;
      
      protected var FSP_KnifeLeft:Sprite;
      
      protected var FMC_KnifeLeftHead:Sprite;
      
      protected var FMC_KnifeLeftNormalEffect:MovieClip;
      
      protected var FMC_KnifeLeftSkillEffect:MovieClip;
      
      protected var FMC_KnifeLeftTurn:MovieClip;
      
      protected var FMC_KnifeLeftSkillName:MovieClip;
      
      protected var FTF_KnifeLeftTurn:TextField;
      
      protected var FTF_KnifeLeftSkillName:TextField;
      
      protected var FTF_KnifeLeftName:TextField;
      
      protected var FTF_KnifeLeftType:TextField;
      
      protected var FSP_KnifeRight:Sprite;
      
      protected var FMC_KnifeRightHead:Sprite;
      
      protected var FMC_KnifeRightNormalEffect:MovieClip;
      
      protected var FMC_KnifeRightSkillEffect:MovieClip;
      
      protected var FMC_KnifeRightTurn:MovieClip;
      
      protected var FMC_KnifeRightSkillName:MovieClip;
      
      protected var FTF_KnifeRightTurn:TextField;
      
      protected var FTF_KnifeRightSkillName:TextField;
      
      protected var FTF_KnifeRightName:TextField;
      
      protected var FTF_KnifeRightType:TextField;
      
      protected var FKnifeLeftId:uint;
      
      protected var FKnifeRightId:uint;
      
      protected var FLeftKniftTurns:Vector.<int>;
      
      protected var FRightKniftTurns:Vector.<int>;
      
      protected var FLeftKnifeHeadId:uint;
      
      protected var FRightKnifeHeadId:uint;
      
      protected var FSP_KnifeSoul_Left:Sprite;
      
      protected var FSP_KnifeSoul_Right:Sprite;
      
      protected var FTF_Level_Left:TextField;
      
      protected var FTF_Level_Right:TextField;
      
      protected var FMC_KnifeSoul_Left:MovieClip;
      
      protected var FMC_KnifeSoul_Right:MovieClip;
      
      protected var FMC_KnifeSoulEffect_Left:MovieClip;
      
      protected var FMC_KnifeSoulEffect_Right:MovieClip;
      
      protected var FKnifeBins:TBins;
      
      protected var FKnifeSoulBins:TBins;
      
      protected var FKnifeExpandBins:TBins;
      
      protected var FSkillConfigBins:TBins;
      
      protected var FLeftSkillNameBounds:TBounds;
      
      protected var FLeftKnifeNameBounds:TBounds;
      
      protected var FLeftKnifeTypeBounds:TBounds;
      
      protected var FRightSkillNameBounds:TBounds;
      
      protected var FRightKnifeNameBounds:TBounds;
      
      protected var FRightKnifeTypeBounds:TBounds;
      
      protected var FMC_LeftTotleHarm:MovieClip;
      
      protected var FMC_RightTotleHarm:MovieClip;
      
      protected var FLeftGoneWord:TGoneWord;
      
      protected var FRightGoneWord:TGoneWord;
      
      protected var FOnHintMove:Function;
      
      protected var FOnHintOut:Function;
      
      protected var FKnifeOfKillSoulOnMove:Function;
      
      protected var FKnifeOfKillSoulOnOut:Function;
      
      public function TChain(param1:TUIComponent)
      {
         super(param1);
         this.FHint = new THint();
         this.FKnifeOfKillSoulDataLeft = new TKnifeOfKillSoulData();
         this.FKnifeOfKillSoulDataRight = new TKnifeOfKillSoulData();
         this.ChainInit();
      }
      
      protected function ChainInit() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(this.FScene == null)
         {
            this.FScene = TUtilityReflection.CreateDisplayObjectInstance(CONST_BATTLE.RESOURCE_ClassName_MC_Chain) as Sprite;
            addChild(this.FScene);
            this.FMC_TotleTurn = this.FScene[CONST_BATTLE.RESOURCE_Link_MC_TotleTurn];
            this.FTF_RemainTurnNumber = this.FMC_TotleTurn[CONST_BATTLE.RESOURCE_Link_TF_RemainTurnNumber];
            this.FTF_RemainTurnNumber.text = REMAIN_NUMBER.toString();
            this.FSP_KnifeLeft = this.FScene[CONST_BATTLE.RESOURCE_Link_MC_KnifeLeft];
            this.FSP_KnifeLeft.mouseChildren = false;
            this.FMC_KnifeLeftHead = this.FSP_KnifeLeft[CONST_BATTLE.RESOURCE_Link_MC_Head][CONST_BATTLE.RESOURCE_Link_MC_KnifeHead];
            this.FMC_KnifeLeftNormalEffect = this.FSP_KnifeLeft[CONST_BATTLE.RESOURCE_Link_MC_Head][CONST_BATTLE.RESOURCE_Link_MC_KnifeNormalEffect];
            this.FMC_KnifeLeftSkillEffect = this.FSP_KnifeLeft[CONST_BATTLE.RESOURCE_Link_MC_Head][CONST_BATTLE.RESOURCE_Link_MC_KnifeSkillEffect];
            this.FMC_KnifeLeftSkillEffect.visible = false;
            this.FMC_KnifeLeftSkillName = this.FSP_KnifeLeft[CONST_BATTLE.RESOURCE_Link_MC_KnifeSkillName][CONST_BATTLE.RESOURCE_Link_MC_MovieSkillName];
            this.FTF_KnifeLeftSkillName = this.FMC_KnifeLeftSkillName[CONST_BATTLE.RESOURCE_Link_TF_KnifeSkillName];
            this.FMC_KnifeLeftTurn = this.FSP_KnifeLeft[CONST_BATTLE.RESOURCE_Link_MC_SkillTurn];
            this.FMC_KnifeLeftTurn.visible = false;
            this.FTF_KnifeLeftTurn = this.FMC_KnifeLeftTurn[CONST_BATTLE.RESOURCE_Link_TF_KnifeTurn];
            this.FTF_KnifeLeftName = this.FSP_KnifeLeft[CONST_BATTLE.RESOURCE_Link_TF_KnifeName];
            this.FTF_KnifeLeftType = this.FSP_KnifeLeft[CONST_BATTLE.RESOURCE_Link_TF_KnifeType];
            this.FSP_KnifeRight = this.FScene[CONST_BATTLE.RESOURCE_Link_MC_KnifeRight];
            this.FSP_KnifeRight.mouseChildren = false;
            this.FMC_KnifeRightHead = this.FSP_KnifeRight[CONST_BATTLE.RESOURCE_Link_MC_Head][CONST_BATTLE.RESOURCE_Link_MC_KnifeHead];
            this.FMC_KnifeRightNormalEffect = this.FSP_KnifeRight[CONST_BATTLE.RESOURCE_Link_MC_Head][CONST_BATTLE.RESOURCE_Link_MC_KnifeNormalEffect];
            this.FMC_KnifeRightSkillEffect = this.FSP_KnifeRight[CONST_BATTLE.RESOURCE_Link_MC_Head][CONST_BATTLE.RESOURCE_Link_MC_KnifeSkillEffect];
            this.FMC_KnifeRightSkillEffect.visible = false;
            this.FMC_KnifeRightSkillName = this.FSP_KnifeRight[CONST_BATTLE.RESOURCE_Link_MC_KnifeSkillName][CONST_BATTLE.RESOURCE_Link_MC_MovieSkillName];
            this.FTF_KnifeRightSkillName = this.FMC_KnifeRightSkillName[CONST_BATTLE.RESOURCE_Link_TF_KnifeSkillName];
            this.FMC_KnifeRightTurn = this.FSP_KnifeRight[CONST_BATTLE.RESOURCE_Link_MC_SkillTurn];
            this.FMC_KnifeRightTurn.visible = false;
            this.FTF_KnifeRightTurn = this.FMC_KnifeRightTurn[CONST_BATTLE.RESOURCE_Link_TF_KnifeTurn];
            this.FTF_KnifeRightName = this.FSP_KnifeRight[CONST_BATTLE.RESOURCE_Link_TF_KnifeName];
            this.FTF_KnifeRightType = this.FSP_KnifeRight[CONST_BATTLE.RESOURCE_Link_TF_KnifeType];
            this.FLeftBitmap = new Bitmap();
            this.FMC_KnifeLeftHead.addChild(this.FLeftBitmap);
            this.FRightBitmap = new Bitmap();
            this.FMC_KnifeRightHead.addChild(this.FRightBitmap);
            this.FSP_KnifeSoul_Left = this.FScene[CONST_BATTLE.RESOURCE_Link_SP_KnifeSoul_Left];
            this.FSP_KnifeSoul_Left.mouseChildren = false;
            this.FSP_KnifeSoul_Left.visible = false;
            this.FTF_Level_Left = this.FSP_KnifeSoul_Left[CONST_BATTLE.RESOURCE_Link_TF_Level];
            this.FMC_KnifeSoul_Left = this.FSP_KnifeSoul_Left[CONST_BATTLE.RESOURCE_Link_MC_KnifeSoul];
            this.FSP_KnifeSoul_Right = this.FScene[CONST_BATTLE.RESOURCE_Link_SP_KnifeSoul_Right];
            this.FSP_KnifeSoul_Right.mouseChildren = false;
            this.FSP_KnifeSoul_Right.visible = false;
            this.FTF_Level_Right = this.FSP_KnifeSoul_Right[CONST_BATTLE.RESOURCE_Link_TF_Level];
            this.FMC_KnifeSoul_Right = this.FSP_KnifeSoul_Right[CONST_BATTLE.RESOURCE_Link_MC_KnifeSoul];
            this.FMC_LeftTotleHarm = this.FScene[CONST_BATTLE.RESOURCE_Link_MC_LeftHarm];
            this.FMC_RightTotleHarm = this.FScene[CONST_BATTLE.RESOURCE_Link_MC_RightHarm];
            this.FMC_LeftTotleHarm.x = -this.FMC_LeftTotleHarm.width;
            this.FMC_RightTotleHarm.x = CONST_COMMON.STAGE_Width + this.FMC_RightTotleHarm.width;
         }
         if(this.FKnifeBins == null)
         {
            this.FKnifeBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Knife);
         }
         if(this.FKnifeSoulBins == null)
         {
            this.FKnifeSoulBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_KnifeSoul);
         }
         if(this.FKnifeExpandBins == null)
         {
            this.FKnifeExpandBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_KnifeExpand);
         }
         if(this.FSkillConfigBins == null)
         {
            this.FSkillConfigBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SkillConfig);
         }
         if(this.FLeftGoneWord == null)
         {
            this.FLeftGoneWord = TPoolEffectGoneWord.GetGoneWordWithBg();
            this.FMC_LeftTotleHarm.addChild(this.FLeftGoneWord);
         }
         if(this.FRightGoneWord == null)
         {
            this.FRightGoneWord = TPoolEffectGoneWord.GetGoneWordWithBg();
            this.FMC_RightTotleHarm.addChild(this.FRightGoneWord);
         }
      }
      
      protected function AddSP_KnifeSoulEventListener(param1:Sprite, param2:Function, param3:Function) : void
      {
         param1.addEventListener(MouseEvent.MOUSE_MOVE,param2,false,0,true);
         param1.addEventListener(MouseEvent.MOUSE_OUT,param3,false,0,true);
      }
      
      protected function RemoveSP_KnifeSoulEventListener(param1:Sprite, param2:Function, param3:Function) : void
      {
         param1.removeEventListener(MouseEvent.MOUSE_MOVE,param2);
         param1.removeEventListener(MouseEvent.MOUSE_OUT,param3);
      }
      
      protected function GetLeftTurn(param1:uint, param2:Vector.<int>) : int
      {
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         _loc5_ = int(MAX_TURN);
         _loc3_ = 0;
         while(_loc3_ < param2.length)
         {
            if(param2[_loc3_] >= param1)
            {
               _loc5_ = Math.min(_loc5_,param2[_loc3_]);
            }
            _loc3_++;
         }
         return _loc5_ - param1;
      }
      
      protected function AssignKnifeData(param1:TKnifeOfKillSoulData) : void
      {
         var _loc2_:TKnifeExpand = null;
         var _loc3_:TKnife = null;
         var _loc4_:TArticle = null;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_KnifeExpand,param1.ID) as TKnifeExpand;
         param1.Level = _loc2_.Level;
         param1.SkillID = _loc2_.SkillID;
         param1.NeedKnifeSoulLevel = _loc2_.KnifeSoulLevelNeed;
         param1.Quality = _loc2_.Quality;
         param1.KnifeSoulAdded = _loc2_.KnifeSoulAdded;
         param1.AddedFront = _loc2_.AddedFront;
         param1.AddedMiddle = _loc2_.AddedMiddle;
         param1.AddedBack = _loc2_.AddedBack;
         param1.NormalTrainExp = _loc2_.NormalExp;
         param1.GoldTrainExp = _loc2_.GoldExp;
         param1.NeedExp = _loc2_.NeedExp;
         param1.RelationID = _loc2_.RelationID;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Knife,param1.RelationID) as TKnife;
         param1.Type = _loc3_.TypeID;
         param1.Name = _loc3_.Name;
         param1.HandBook = _loc3_.HandBookID;
         param1.Appraise = _loc3_.Appraise;
         param1.GetRoad = _loc3_.GetRoad;
         param1.AttackAttr = _loc3_.AttackAttr;
         param1.DefenseAttr = _loc3_.DefenseAttr;
         param1.RecoveryAttr = _loc3_.RecoveryAttr;
         param1.ResistanceAttr = _loc3_.ResistanceAttr;
         param1.SpeedAttr = _loc3_.SpeedAttr;
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,param1.HandBook) as TArticle;
         param1.HandBookName = _loc4_.Name;
      }
      
      protected function SP_KnifeOfKillSoulOnMove(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:TKnifeOfKillSoulData = null;
         _loc2_ = param1.currentTarget as Sprite;
         switch(_loc2_)
         {
            case this.FSP_KnifeLeft:
               _loc3_ = this.FKnifeOfKillSoulDataLeft;
               break;
            case this.FSP_KnifeRight:
               _loc3_ = this.FKnifeOfKillSoulDataRight;
         }
         if(this.FKnifeOfKillSoulOnMove != null)
         {
            this.FKnifeOfKillSoulOnMove(this,_loc3_);
         }
      }
      
      protected function SP_KnifeOfKillSoulOnOut(param1:MouseEvent) : void
      {
         if(this.FKnifeOfKillSoulOnOut != null)
         {
            this.FKnifeOfKillSoulOnOut(this);
         }
      }
      
      protected function SP_KnifeSoulOnMove(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:TKnifeExpand = null;
         var _loc4_:Sprite = null;
         _loc4_ = param1.currentTarget as Sprite;
         if(_loc4_ == this.FSP_KnifeSoul_Left)
         {
            _loc2_ = this.FKnifeLeftId;
         }
         else if(_loc4_ == this.FSP_KnifeSoul_Right)
         {
            _loc2_ = this.FKnifeRightId;
         }
         _loc3_ = this.FKnifeExpandBins.GetDatebaseByIdentifier(_loc2_) as TKnifeExpand;
         if(_loc3_ == null)
         {
            return;
         }
         this.FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BATTLE_08),_loc3_.KnifeSoulAdded);
         if(this.FOnHintMove != null)
         {
            this.FOnHintMove(this,this.FHint);
         }
      }
      
      protected function SP_KnifeSoulOnOut(param1:MouseEvent) : void
      {
         if(this.FOnHintOut != null)
         {
            this.FOnHintOut(this,this.FHint);
         }
      }
      
      public function get OnHintMove() : Function
      {
         return this.FOnHintMove;
      }
      
      public function set OnHintMove(param1:Function) : void
      {
         this.FOnHintMove = param1;
      }
      
      public function get OnHintOut() : Function
      {
         return this.FOnHintOut;
      }
      
      public function set OnHintOut(param1:Function) : void
      {
         this.FOnHintOut = param1;
      }
      
      public function get KnifeOfKillSoulOnMove() : Function
      {
         return this.FKnifeOfKillSoulOnMove;
      }
      
      public function set KnifeOfKillSoulOnMove(param1:Function) : void
      {
         this.FKnifeOfKillSoulOnMove = param1;
      }
      
      public function get KnifeOfKillSoulOnOut() : Function
      {
         return this.FKnifeOfKillSoulOnOut;
      }
      
      public function set KnifeOfKillSoulOnOut(param1:Function) : void
      {
         this.FKnifeOfKillSoulOnOut = param1;
      }
      
      public function UpdateRemainNum(param1:uint) : void
      {
         var _loc2_:uint = 0;
         this.FTF_RemainTurnNumber.text = String(REMAIN_NUMBER - param1);
         param1 += 1;
         if(this.FKnifeLeftId != 0)
         {
            _loc2_ = uint(this.GetLeftTurn(param1,this.FLeftKniftTurns));
            this.FMC_KnifeLeftSkillEffect.visible = false;
            if(_loc2_ <= 0)
            {
               this.FMC_KnifeLeftTurn.visible = false;
               this.FMC_KnifeLeftSkillName.visible = true;
               this.FMC_KnifeLeftSkillEffect.visible = true;
            }
            else if(_loc2_ >= REMAIN_NUMBER)
            {
               this.FMC_KnifeLeftTurn.visible = false;
               this.FMC_KnifeLeftSkillName.visible = true;
               this.FTF_KnifeLeftSkillName.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BATTLE_12);
            }
            else
            {
               this.FMC_KnifeLeftTurn.visible = true;
               this.FMC_KnifeLeftSkillName.visible = false;
               this.FTF_KnifeLeftTurn.text = _loc2_.toString();
            }
            this.FMC_KnifeLeftNormalEffect.play();
            this.FMC_KnifeLeftSkillEffect.play();
         }
         if(this.FKnifeRightId != 0)
         {
            _loc2_ = uint(this.GetLeftTurn(param1,this.FRightKniftTurns));
            this.FMC_KnifeRightSkillEffect.visible = false;
            if(_loc2_ <= 0)
            {
               this.FMC_KnifeRightTurn.visible = false;
               this.FMC_KnifeRightSkillName.visible = true;
               this.FMC_KnifeRightSkillEffect.visible = true;
            }
            else if(_loc2_ >= REMAIN_NUMBER)
            {
               this.FMC_KnifeRightTurn.visible = false;
               this.FMC_KnifeRightSkillName.visible = true;
               this.FTF_KnifeRightSkillName.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BATTLE_12);
            }
            else
            {
               this.FMC_KnifeRightTurn.visible = true;
               this.FMC_KnifeRightSkillName.visible = false;
               this.FTF_KnifeRightTurn.text = _loc2_.toString();
            }
            this.FMC_KnifeRightNormalEffect.play();
            this.FMC_KnifeRightSkillEffect.play();
         }
      }
      
      public function SetKnifeOfKillSoulData(param1:uint, param2:uint) : void
      {
         var _loc3_:TKnife = null;
         var _loc4_:TKnifeExpand = null;
         var _loc5_:TSkillConfig = null;
         this.FKnifeLeftId = param1;
         this.FKnifeRightId = param2;
         if(this.FKnifeLeftId == 0)
         {
            this.FLeftBitmap.bitmapData = null;
            this.FTF_KnifeLeftName.text = "";
            this.FTF_KnifeLeftType.text = "";
            this.FTF_KnifeLeftSkillName.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BATTLE_07);
            this.FMC_KnifeLeftTurn.visible = false;
            this.FMC_KnifeLeftSkillName.visible = true;
         }
         else
         {
            _loc4_ = this.FKnifeExpandBins.GetDatebaseByIdentifier(this.FKnifeLeftId) as TKnifeExpand;
            this.FLeftKnifeHeadId = _loc4_.RelationID;
            this.FKnifeOfKillSoulDataLeft.ID = _loc4_.Identifier;
            this.FKnifeOfKillSoulDataLeft.CurrentState = CONST_KNIFEOFKILLSOUL.KNIFESTATE_LackHandBook;
            this.AssignKnifeData(this.FKnifeOfKillSoulDataLeft);
            _loc3_ = this.FKnifeBins.GetDatebaseByIdentifier(_loc4_.RelationID) as TKnife;
            this.FTF_KnifeLeftName.text = _loc3_.Name;
            this.FTF_KnifeLeftName.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[_loc4_.Level + 2];
            this.FTF_KnifeLeftType.text = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BATTLE_11)[_loc4_.Level];
            this.FLeftKniftTurns = _loc4_.KnifeTurns;
            _loc5_ = this.FSkillConfigBins.GetDatebaseByIdentifier(_loc4_.SkillID) as TSkillConfig;
            this.FTF_KnifeLeftSkillName.text = _loc5_.Name;
            this.AddSP_KnifeSoulEventListener(this.FSP_KnifeLeft,this.SP_KnifeOfKillSoulOnMove,this.SP_KnifeOfKillSoulOnOut);
            SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(this.FLeftKnifeHeadId,this.AutoLoadLeftCallBack);
         }
         if(this.FKnifeRightId == 0)
         {
            this.FRightBitmap.bitmapData = null;
            this.FTF_KnifeRightName.text = "";
            this.FTF_KnifeRightType.text = "";
            this.FTF_KnifeRightSkillName.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BATTLE_07);
            this.FMC_KnifeRightTurn.visible = false;
            this.FMC_KnifeRightSkillName.visible = true;
         }
         else
         {
            _loc4_ = this.FKnifeExpandBins.GetDatebaseByIdentifier(this.FKnifeRightId) as TKnifeExpand;
            this.FKnifeOfKillSoulDataRight.ID = _loc4_.Identifier;
            this.FKnifeOfKillSoulDataRight.CurrentState = CONST_KNIFEOFKILLSOUL.KNIFESTATE_LackHandBook;
            this.AssignKnifeData(this.FKnifeOfKillSoulDataRight);
            this.FRightKnifeHeadId = _loc4_.RelationID;
            _loc3_ = this.FKnifeBins.GetDatebaseByIdentifier(_loc4_.RelationID) as TKnife;
            this.FTF_KnifeRightName.text = _loc3_.Name;
            this.FTF_KnifeRightName.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[_loc4_.Level + 2];
            this.FTF_KnifeRightType.text = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BATTLE_11)[_loc4_.Level];
            this.FRightKniftTurns = _loc4_.KnifeTurns;
            _loc5_ = this.FSkillConfigBins.GetDatebaseByIdentifier(_loc4_.SkillID) as TSkillConfig;
            this.FTF_KnifeRightSkillName.text = _loc5_.Name;
            this.AddSP_KnifeSoulEventListener(this.FSP_KnifeRight,this.SP_KnifeOfKillSoulOnMove,this.SP_KnifeOfKillSoulOnOut);
            SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(this.FRightKnifeHeadId,this.AutoLoadRightCallBack);
         }
      }
      
      protected function AutoLoadLeftCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         if(param3 == this.FLeftKnifeHeadId)
         {
            _loc4_ = param2.GetAnimationSequenceByIndex(0);
            this.FLeftBitmap.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
         }
      }
      
      protected function AutoLoadRightCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         if(param3 == this.FRightKnifeHeadId)
         {
            _loc4_ = param2.GetAnimationSequenceByIndex(0);
            this.FRightBitmap.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
         }
      }
      
      public function SetKnifeSoulData(param1:uint, param2:uint) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TKnifeSoul = null;
         if(param1 != 0)
         {
            _loc4_ = this.FKnifeSoulBins.GetDatebaseByIdentifier(param1) as TKnifeSoul;
            this.FTF_Level_Left.text = _loc4_.Level.toString();
            if(_loc4_.Level < 10)
            {
               _loc3_ = MIN_KNIFESOUL_LEVEL;
            }
            else if(_loc4_.Level <= 70)
            {
               _loc3_ = int(Math.ceil(_loc4_.Level / 10));
            }
            else
            {
               _loc3_ = MAX_KNIFESOUL_LEVEL;
            }
            this.FMC_KnifeSoul_Left.gotoAndStop(_loc3_);
            this.FMC_KnifeSoulEffect_Left = this.FMC_KnifeSoul_Left[CONST_BATTLE.RESOURCE_Link_MC_KnifeSoulEffect];
            this.FMC_KnifeSoulEffect_Left.play();
            this.AddSP_KnifeSoulEventListener(this.FSP_KnifeSoul_Left,this.SP_KnifeSoulOnMove,this.SP_KnifeSoulOnOut);
            this.FSP_KnifeSoul_Left.visible = true;
         }
         if(param2 != 0)
         {
            _loc4_ = this.FKnifeSoulBins.GetDatebaseByIdentifier(param2) as TKnifeSoul;
            this.FTF_Level_Right.text = _loc4_.Level.toString();
            if(_loc4_.Level < 10)
            {
               _loc3_ = MIN_KNIFESOUL_LEVEL;
            }
            else if(_loc4_.Level <= 70)
            {
               _loc3_ = int(Math.ceil(_loc4_.Level / 10));
            }
            else
            {
               _loc3_ = MAX_KNIFESOUL_LEVEL;
            }
            this.FMC_KnifeSoul_Right.gotoAndStop(_loc3_);
            this.FMC_KnifeSoulEffect_Right = this.FMC_KnifeSoul_Right[CONST_BATTLE.RESOURCE_Link_MC_KnifeSoulEffect];
            this.FMC_KnifeSoulEffect_Right.play();
            this.AddSP_KnifeSoulEventListener(this.FSP_KnifeSoul_Right,this.SP_KnifeSoulOnMove,this.SP_KnifeSoulOnOut);
            this.FSP_KnifeSoul_Right.visible = true;
         }
      }
      
      public function ShowLeftHarm(param1:String) : void
      {
         this.FMC_LeftTotleHarm.x = -STAMP_WIDTH;
         TweenUtil.to(this.FMC_LeftTotleHarm,100 / TBattleHandle.PlaybackRate,{"x":0});
         TBattleHandle.PlaybackTimeout(this.HideLeftHarm,2000);
         this.FLeftGoneWord.SetGoneWordWithBg(1,18,param1,0,0,26);
      }
      
      public function HideLeftHarm() : void
      {
         TweenUtil.to(this.FMC_LeftTotleHarm,100 / TBattleHandle.PlaybackRate,{"x":-STAMP_WIDTH});
      }
      
      public function ShowRightHarm(param1:String) : void
      {
         this.FMC_RightTotleHarm.x = CONST_COMMON.STAGE_Width;
         TweenUtil.to(this.FMC_RightTotleHarm,100 / TBattleHandle.PlaybackRate,{"x":CONST_COMMON.STAGE_Width - STAMP_WIDTH});
         TBattleHandle.PlaybackTimeout(this.HideRightHarm,2000);
         this.FRightGoneWord.SetGoneWordWithBg(STAMP_WIDTH - param1.length * 12 - 8,18,param1,0,0,26);
      }
      
      public function HideRightHarm() : void
      {
         TweenUtil.to(this.FMC_RightTotleHarm,100 / TBattleHandle.PlaybackRate,{"x":CONST_COMMON.STAGE_Width});
      }
      
      public function Reset() : void
      {
         this.FLeftBitmap.bitmapData = null;
         this.FRightBitmap.bitmapData = null;
         this.FKnifeOfKillSoulDataLeft.Reset();
         this.FKnifeOfKillSoulDataRight.Reset();
         this.FMC_KnifeLeftNormalEffect.stop();
         this.FMC_KnifeLeftSkillEffect.stop();
         this.FMC_KnifeRightNormalEffect.stop();
         this.FMC_KnifeRightSkillEffect.stop();
         if(this.FMC_KnifeSoulEffect_Left != null)
         {
            this.FMC_KnifeSoulEffect_Left.stop();
            this.FMC_KnifeSoulEffect_Left = null;
         }
         if(this.FMC_KnifeSoulEffect_Right != null)
         {
            this.FMC_KnifeSoulEffect_Right.stop();
            this.FMC_KnifeSoulEffect_Right = null;
         }
         this.SP_KnifeOfKillSoulOnOut(null);
         this.RemoveSP_KnifeSoulEventListener(this.FSP_KnifeLeft,this.SP_KnifeOfKillSoulOnMove,this.SP_KnifeOfKillSoulOnOut);
         this.RemoveSP_KnifeSoulEventListener(this.FSP_KnifeRight,this.SP_KnifeOfKillSoulOnMove,this.SP_KnifeOfKillSoulOnOut);
         this.RemoveSP_KnifeSoulEventListener(this.FSP_KnifeSoul_Left,this.SP_KnifeSoulOnMove,this.SP_KnifeSoulOnOut);
         this.RemoveSP_KnifeSoulEventListener(this.FSP_KnifeSoul_Right,this.SP_KnifeSoulOnMove,this.SP_KnifeSoulOnOut);
         this.FSP_KnifeSoul_Left.visible = false;
         this.FSP_KnifeSoul_Right.visible = false;
         this.FMC_KnifeLeftTurn.visible = false;
         this.FMC_KnifeRightTurn.visible = false;
         this.FTF_RemainTurnNumber.text = String(REMAIN_NUMBER);
      }
   }
}

