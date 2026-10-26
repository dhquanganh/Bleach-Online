package Processors.Game.Lobby.KnifeOfKillSoul
{
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.KnifeOfKillSoul.*;
   import Logics.KnifeOfKillSoul.VO.TKnifeStrengthenAdd;
   import Logics.KnifeOfKillSoul.VO.TKnifeStrengthenPhase;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.GeneralStar.*;
   import Rendering.Overlayers.Hints.*;
   import Resources.Constants.*;
   import Utilities.UI.Overlayers.*;
   import flash.utils.*;
   
   public class TProcessorKnifeOfKillSoul extends TProcessorLobbyWindows
   {
      
      protected static const WINDOW_WIDHT:int = 706;
      
      protected static const WINDOW_HEIGHT:int = 513;
      
      protected var FWindowKnifeOfkillSoul:TProcessorWindowKnifeOfkillSoul;
      
      protected var FKnifeOfkillSoulDatas:TKnifeOfkillSoulDatas;
      
      protected var FKnifeLanguage:TKnifeLanguage;
      
      protected var FKnifeOwn:Vector.<uint>;
      
      protected var FKnifeExp:Vector.<uint>;
      
      protected var FBounds:TBounds;
      
      protected var FOnChangeShape:Function;
      
      protected var FUpdateHeroPower:Function;
      
      public function TProcessorKnifeOfKillSoul(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FKnifeOfkillSoulDatas = SLogicsCore.Character.KnifeOfKillSoul;
         this.FKnifeLanguage = new TKnifeLanguage();
         this.FKnifeOwn = new Vector.<uint>();
         this.FKnifeExp = new Vector.<uint>();
         this.FWindowKnifeOfkillSoul = new TProcessorWindowKnifeOfkillSoul(this);
         this.FWindowKnifeOfkillSoul.OnEffectText = ProcessorsOnEffectText;
         this.FWindowKnifeOfkillSoul.KnifeLanguage = this.FKnifeLanguage;
         this.FBounds = new TBounds();
         this.FBounds.Width = WINDOW_WIDHT;
         this.FBounds.Height = WINDOW_HEIGHT;
         ComponentBoundsCenter(this.FWindowKnifeOfkillSoul,this.FBounds);
         this.FBounds = null;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_KNIFEOFKILLSOUL.KNIFE_RESOURCEID);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FKnifeLanguage.initStr();
         this.FWindowKnifeOfkillSoul.KnifeOfkillSoulDatas = this.FKnifeOfkillSoulDatas;
         this.FWindowKnifeOfkillSoul.UIDispatch();
         this.FWindowKnifeOfkillSoul.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FWindowKnifeOfkillSoul.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FWindowKnifeOfkillSoul.UILocation();
         super.ResourcesPerform_UILocations();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         super.PacketRegisterRoutines();
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_KnifeInforResponse,this.PerformPacket_SC_KnifeInfor);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_OpenKnifeResponse,this.PerformPacket_SC_OpenKnife);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TrainKnifeResponse,this.PerformPacket_SC_TrainKnife);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_ChangeKnifeResponse,this.PerformPacket_SC_ChangeShape);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_KnifeStrengRet,this.PerformPacket_SC_KnifeStrengRet);
      }
      
      protected function PerformPacket_SC_KnifeInfor(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         if(this.FKnifeOfkillSoulDatas.Count == 0)
         {
            this.CreateBaseKnife();
         }
         _loc2_ = param1.Data;
         this.FKnifeOwn.length = 0;
         this.FKnifeExp.length = 0;
         _loc3_ = int(_loc2_.readUnsignedShort());
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            this.FKnifeOwn.push(_loc2_.readUnsignedInt());
            this.FKnifeExp.push(_loc2_.readUnsignedInt());
            _loc4_++;
         }
         this.ReAssignKnifeInforByArray(this.FKnifeOwn,CONST_KNIFEOFKILLSOUL.KNIFESTATE_UNLOCK,this.FKnifeExp);
         _loc3_ = param1.Data.readShort();
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            param1.Data.readInt();
            _loc5_ = param1.Data.readInt();
            _loc6_ = param1.Data.readInt();
            _loc7_ = param1.Data.readInt();
            _loc8_ = param1.Data.readInt();
            _loc9_ = param1.Data.readInt();
            _loc10_ = param1.Data.readInt();
            _loc11_ = param1.Data.readInt();
            this.UpdateStrengthenAttribute(_loc5_,0,_loc6_,_loc9_);
            this.UpdateStrengthenAttribute(_loc5_,1,_loc7_,_loc10_);
            this.UpdateStrengthenAttribute(_loc5_,2,_loc8_,_loc11_);
            this.UpdateStrengthenAdvance(_loc5_);
            _loc4_++;
         }
         if(visible)
         {
            this.FWindowKnifeOfkillSoul.Update();
            this.FWindowKnifeOfkillSoul.visible = true;
         }
      }
      
      protected function PerformPacket_SC_OpenKnife(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:TKnifeOfKillSoulData = null;
         var _loc5_:String = null;
         _loc2_ = int(param1.Data.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = param1.Data.readUnsignedInt();
         this.FKnifeOwn.length = 0;
         this.FKnifeOwn.push(_loc3_);
         this.ReAssignKnifeInforByArray(this.FKnifeOwn,CONST_KNIFEOFKILLSOUL.KNIFESTATE_UNLOCK);
         _loc4_ = this.FKnifeOfkillSoulDatas.GetByIndentifier(_loc3_);
         _loc5_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_0),_loc4_.Name);
         EffectGenerateText(_loc5_);
         this.FWindowKnifeOfkillSoul.Update();
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_OpenOneKnifeOfKillSoul);
      }
      
      protected function PerformPacket_SC_TrainKnife(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:TKnifeOfKillSoulData = null;
         var _loc7_:String = null;
         var _loc8_:uint = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         _loc2_ = int(param1.Data.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = param1.Data.readUnsignedInt();
         _loc5_ = param1.Data.readUnsignedInt();
         _loc11_ = this.GetRelationID(_loc3_);
         _loc12_ = this.GetRelationID(SLogicsCore.Character.KnifeSoul.ChangedID);
         if(_loc11_ == _loc12_)
         {
            SLogicsCore.Character.KnifeSoul.ChangedID = _loc3_;
         }
         _loc6_ = this.FKnifeOfkillSoulDatas.GetByIndentifier(_loc3_);
         if(_loc6_ == null)
         {
            this.FKnifeOwn.length = 0;
            this.FKnifeOwn.push(_loc3_);
            this.ReAssignKnifeInforByArray(this.FKnifeOwn,CONST_KNIFEOFKILLSOUL.KNIFESTATE_UNLOCK);
            _loc6_ = this.FKnifeOfkillSoulDatas.GetByIndentifier(_loc3_);
         }
         _loc6_.CurrentExp = _loc5_;
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_2));
         this.FWindowKnifeOfkillSoul.Update();
      }
      
      protected function PerformPacket_SC_ChangeShape(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TCharacter = null;
         _loc2_ = param1.Data;
         _loc6_ = SLogicsCore.Character;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc4_ = _loc2_.readByte();
         _loc5_ = int(_loc2_.readUnsignedInt());
         switch(_loc4_)
         {
            case CONST_KNIFEOFKILLSOUL.KnifeChangeShpae:
               _loc6_.KnifeSoul.ChangedID = _loc5_;
               _loc6_.KnifeSoul.CurrentModuleID = _loc6_.KnifeOfKillSoul.GetByIndentifier(_loc5_).RelationID;
               EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_28));
               break;
            case CONST_KNIFEOFKILLSOUL.KnifeCancleChangeShpae:
               _loc6_.KnifeSoul.ChangedID = 0;
               _loc6_.KnifeSoul.CurrentModuleID = 0;
               EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_29));
         }
         this.FWindowKnifeOfkillSoul.SetupForcePromptFreshGuide(false);
         if(Visible)
         {
            this.FWindowKnifeOfkillSoul.Update();
         }
         if(this.FOnChangeShape != null)
         {
            this.FOnChangeShape(this);
         }
      }
      
      protected function PerformPacket_SC_KnifeStrengRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc2_ = int(param1.Data.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = uint(param1.Data.readInt());
         _loc4_ = uint(param1.Data.readInt());
         _loc5_ = uint(param1.Data.readInt());
         _loc6_ = uint(param1.Data.readInt());
         this.UpdateStrengthenAttribute(_loc3_,_loc4_,_loc5_,_loc6_);
         this.UpdateStrengthenAdvance(_loc3_);
         this.FWindowKnifeOfkillSoul.StrengthenUpdate();
         if(this.FUpdateHeroPower != null) { this.FUpdateHeroPower(this); }
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_38));
      }
      
      protected function UpdateStrengthenAttribute(param1:int, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:TKnifeOfKillSoulData = null;
         var _loc6_:TKnifeStrengthenAdd = null;
         var _loc7_:TKnifeStrengthenPhase = null;
         var _loc8_:TKnifeStrengExp = null;
         var _loc9_:TKnifeStrengExp = null;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         _loc5_ = this.FKnifeOfkillSoulDatas.GetByIndentifier(param1);
         _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_KnifeStrengExp,_loc5_.Quality * 1000 + param3) as TKnifeStrengExp;
         _loc6_ = _loc5_.StrengthenAdd[param2];
         _loc6_.Exp = param4;
         _loc6_.Level = param3;
         _loc6_.UpExp = _loc8_.Exp;
         _loc6_.TotalExp = _loc8_.Accumulation;
         _loc6_.Value = _loc6_.BaseValue + param3 * _loc6_.UpAddValue;
         _loc9_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_KnifeStrengExp,_loc5_.Quality * 1000 + param3 + 1) as TKnifeStrengExp;
         _loc6_.IsMax = _loc9_ == null;
         _loc11_ = _loc5_.StrengthenAdd.length;
         _loc10_ = 0;
         while(_loc10_ < _loc11_)
         {
            _loc6_ = _loc5_.StrengthenAdd[_loc10_];
            this.UpdateStrengLevelNode(_loc6_,_loc5_);
            _loc10_++;
         }
      }
      
      protected function UpdateStrengthenAdvance(param1:int) : void
      {
         var _loc2_:TKnifeOfKillSoulData = null;
         var _loc3_:TKnifeStrengthenAdd = null;
         var _loc4_:TKnifeStrengthenPhase = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:TBins = null;
         var _loc9_:Vector.<int> = null;
         var _loc10_:int = 0;
         var _loc11_:TConfigValue = null;
         _loc2_ = this.FKnifeOfkillSoulDatas.GetByIndentifier(param1);
         _loc8_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         _loc11_ = _loc8_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Knife_StrongNodeLevel) as TConfigValue;
         _loc9_ = Vector.<int>(_loc11_.Value);
         _loc7_ = uint.MAX_VALUE;
         _loc6_ = _loc2_.StrengthenAdd.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc3_ = _loc2_.StrengthenAdd[_loc5_];
            if(_loc3_.Level < _loc7_)
            {
               _loc7_ = _loc3_.Level;
            }
            _loc5_++;
         }
         _loc6_ = _loc9_.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc10_ = _loc9_[_loc5_];
            _loc4_ = _loc2_.StrengthenPhase[_loc5_];
            _loc4_.Activate = _loc7_ >= _loc10_;
            _loc5_++;
         }
      }
      
      protected function UpdateStrengLevelNode(param1:TKnifeStrengthenAdd, param2:TKnifeOfKillSoulData) : void
      {
         var _loc3_:TKnifeStrengthenAdd = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TBins = null;
         var _loc7_:Vector.<int> = null;
         var _loc8_:int = 0;
         var _loc9_:TConfigValue = null;
         var _loc10_:uint = 0;
         _loc6_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         _loc9_ = _loc6_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Knife_StrongNodeLevel) as TConfigValue;
         _loc7_ = Vector.<int>(_loc9_.Value);
         param1.IsNodeLevel = false;
         _loc8_ = _loc7_.indexOf(param1.Level);
         if(_loc8_ != -1)
         {
            _loc5_ = param2.StrengthenAdd.length;
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc3_ = param2.StrengthenAdd[_loc4_];
               if(_loc3_.Level < param1.Level)
               {
                  param1.IsNodeLevel = true;
                  break;
               }
               _loc4_++;
            }
         }
         _loc5_ = _loc7_.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc10_ = uint(_loc7_[_loc4_]);
            if(_loc10_ == param1.Level && param1.IsNodeLevel)
            {
               break;
            }
            if(_loc10_ > param1.Level)
            {
               break;
            }
            _loc4_++;
         }
         param1.NextNodeLevel = _loc10_;
      }
      
      protected function RequestBaseInfor() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_KnifeOfKillSoulRequest);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function CreateBaseKnife() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:TKnifeStrengthenAdd = null;
         var _loc5_:TKnifeStrengthenPhase = null;
         var _loc6_:TBins = null;
         var _loc7_:TBins = null;
         var _loc8_:TBins = null;
         var _loc9_:TBins = null;
         var _loc10_:TKnifeExpand = null;
         var _loc11_:TKnife = null;
         var _loc12_:TKnifeStrengExp = null;
         var _loc13_:TKnifeStrengthen = null;
         var _loc14_:TKnifeOfKillSoulData = null;
         var _loc15_:TBins = null;
         var _loc16_:TConfigValue = null;
         var _loc17_:Vector.<int> = null;
         _loc6_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_KnifeExpand);
         _loc7_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Knife);
         _loc8_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_KnifeStrengExp);
         _loc9_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_KnifeStrengthen);
         _loc15_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         _loc16_ = _loc15_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Knife_StrongNodeLevel) as TConfigValue;
         _loc17_ = Vector.<int>(_loc16_.Value);
         _loc1_ = 0;
         while(_loc1_ < _loc6_.Count)
         {
            _loc10_ = _loc6_.GetDatebaseByIndex(_loc1_) as TKnifeExpand;
            if(_loc10_.Level == CONST_KNIFEOFKILLSOUL.KNIFELEVEL_BASE)
            {
               _loc11_ = _loc7_.GetDatebaseByIdentifier(_loc10_.RelationID) as TKnife;
               _loc12_ = _loc8_.GetDatebaseByIdentifier(_loc10_.Quality * 1000 + 1) as TKnifeStrengExp;
               _loc14_ = new TKnifeOfKillSoulData();
               _loc14_.ID = _loc10_.Identifier;
               _loc14_.CurrentState = CONST_KNIFEOFKILLSOUL.KNIFESTATE_LackHandBook;
               _loc14_.StrengthenType = _loc11_.Direction;
               _loc3_ = _loc11_.AttributeType.length;
               _loc2_ = 0;
               while(_loc2_ < _loc3_)
               {
                  _loc4_ = new TKnifeStrengthenAdd();
                  _loc4_.BaseValue = _loc11_.BaseValue[_loc2_];
                  _loc4_.Exp = 0;
                  _loc4_.IsMax = false;
                  _loc4_.Level = 1;
                  _loc4_.Type = _loc11_.AttributeType[_loc2_];
                  _loc4_.UpAddValue = _loc11_.GrowthValue[_loc2_];
                  _loc4_.UpExp = _loc12_.Exp;
                  _loc4_.TotalExp = _loc12_.Accumulation;
                  _loc4_.Value = _loc4_.BaseValue + _loc4_.Level * _loc4_.UpAddValue;
                  _loc4_.IsNodeLevel = false;
                  _loc4_.NextNodeLevel = _loc17_[0];
                  _loc14_.StrengthenAdd.push(_loc4_);
                  _loc2_++;
               }
               _loc3_ = _loc11_.ActiveEffects.length;
               _loc2_ = 0;
               while(_loc2_ < _loc3_)
               {
                  _loc13_ = _loc9_.GetDatebaseByIdentifier(_loc11_.ActiveEffects[_loc2_]) as TKnifeStrengthen;
                  _loc5_ = new TKnifeStrengthenPhase();
                  _loc5_.Activate = false;
                  _loc5_.IconID = _loc13_.EffectID;
                  _loc5_.Attribute = _loc13_.Attribute;
                  _loc5_.HeroID = _loc13_.Heros;
                  _loc14_.StrengthenPhase.push(_loc5_);
                  _loc2_++;
               }
               this.AssignKnifeData(_loc14_);
               this.FKnifeOfkillSoulDatas.Add(_loc14_);
            }
            _loc1_++;
         }
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
      
      protected function ReAssignKnifeInforByArray(param1:Vector.<uint>, param2:int, param3:Vector.<uint> = null) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:TKnifeOfKillSoulData = null;
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            _loc7_ = int(param1[_loc4_]);
            _loc6_ = this.GetRelationID(_loc7_);
            _loc5_ = 0;
            while(_loc5_ < this.FKnifeOfkillSoulDatas.Count)
            {
               _loc8_ = this.FKnifeOfkillSoulDatas.GetByIndex(_loc5_);
               if(_loc8_.RelationID == _loc6_)
               {
                  if(_loc8_.ID != _loc7_)
                  {
                     _loc8_.ID = _loc7_;
                     this.AssignKnifeData(_loc8_);
                  }
                  _loc8_.CurrentState = param2;
                  if(param3 != null)
                  {
                     _loc8_.CurrentExp = param3[_loc4_];
                  }
                  break;
               }
               _loc5_++;
            }
            _loc4_++;
         }
      }
      
      protected function GetRelationID(param1:int) : int
      {
         var _loc2_:TKnifeExpand = null;
         if(param1 == 0)
         {
            return 0;
         }
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_KnifeExpand,param1) as TKnifeExpand;
         return _loc2_.RelationID;
      }
      
      override public function set OnClose(param1:Function) : void
      {
         super.OnClose = param1;
         this.FWindowKnifeOfkillSoul.OnClose = param1;
      }
      
      public function set OnChangeShape(param1:Function) : void
      {
         this.FOnChangeShape = param1;
      }
      
      public function set IfGoBackToDeployment(param1:Boolean) : void
      {
         this.FWindowKnifeOfkillSoul.IfGoBackToDeployment = param1;
      }
      
      public function set UpdateHeroPower(param1:Function) : void
      {
         this.FUpdateHeroPower = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
         this.RequestBaseInfor();
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_OpenKnifeOfKillSoul);
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_CloseKnifeOfKillSoul);
         this.FWindowKnifeOfkillSoul.Reset();
      }
      
      public function SetupForcePromptFreshGuide(param1:Boolean) : void
      {
         this.FWindowKnifeOfkillSoul.SetupForcePromptFreshGuide(param1);
      }
      
      public function CreateKnifeOfSkillSoulData(param1:uint) : TKnifeOfKillSoulData
      {
         var _loc2_:TKnifeOfKillSoulData = null;
         _loc2_ = new TKnifeOfKillSoulData();
         _loc2_.ID = param1;
         this.AssignKnifeData(_loc2_);
         return _loc2_;
      }
   }
}

