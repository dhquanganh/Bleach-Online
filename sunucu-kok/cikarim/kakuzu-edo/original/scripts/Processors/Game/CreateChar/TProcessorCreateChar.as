package Processors.Game.CreateChar
{
   import Components.Standard.*;
   import Externals.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.ChatOptions.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.GeneralStar.*;
   import Logics.Spaces.*;
   import Logics.Streamization.Characters.*;
   import Processors.Game.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Rendering.Overlayers.Hints.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.UI.Overlayers.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;
   
   use namespace LogicsSpace;
   
   public class TProcessorCreateChar extends TProcessorGame
   {
      
      protected static const CAPACITY_VirtualNames:int = 60;
      
      protected static const MAX_Heros:int = 6;
      
      protected static const EffectMulti_DelayTicks:int = 500;
      
      protected static const GENDER_Female:uint = CONST_CHARACTER.GENDER_Female;
      
      protected static const GENDER_Male:uint = CONST_CHARACTER.GENDER_Male;
      
      protected static const PROFESSIONS_TYPE:Vector.<uint> = Vector.<uint>([1,2,3,4,5,6]);
      
      protected static const PROFESSION_IDS:Vector.<uint> = Vector.<uint>([11100001,11100002,11100003,11100004,11100005,11100006]);
      
      protected static const PROFESSIONS_CONFIGVALUEID:Vector.<uint> = Vector.<uint>([70210001,70210002,70210003,70210004,70210005,70210006]);
      
      protected var FHint:THint;
      
      protected var FMC_Account:Sprite;
      
      protected var FBtn_CreateRole:TUIButton;
      
      protected var FBtn_RandomName:TUIButton;
      
      protected var FTF_UserName:TextField;
      
      protected var FTF_VirtualName:TextField;
      
      protected var FMC_UserBigPic:Sprite;
      
      protected var FBmpHero:Bitmap;
      
      protected var FLastNames:Vector.<String>;
      
      protected var FMaleNames:Vector.<String>;
      
      protected var FFemaleNames:Vector.<String>;
      
      protected var FVirtualNames:Vector.<String>;
      
      protected var FTempVirtualNamesA:Vector.<String>;
      
      protected var FUserHeroVect:Vector.<MovieClip>;
      
      protected var FSelectIndex:int;
      
      protected var FProfession:int;
      
      protected var FGender:int;
      
      protected var FHeroImageID:int;
      
      protected var FNextTick:int;
      
      protected var FStringVirtualnames:String;
      
      protected var FInitialization:Boolean;
      
      protected var FOnEffectText:Function;
      
      protected var FOnCharCreated:Function;
      
      public function TProcessorCreateChar(param1:TUIComponent)
      {
         super(param1);
         this.FHint = new THint();
         this.FProfession = CONST_CHARACTER.PROFESSION_Strength;
         this.FGender = GENDER_Male;
         this.FInitialization = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.ResourceBin.LoadPrimary(CONST_DATEBASEVO.RESOURCEID_BaseHero);
         SResourcesCore.ResourceBin.LoadPrimary(CONST_DATEBASEVO.RESOURCEID_RandomName);
         SResourcesCore.TexturesSwfCommon.LoadPrimary(CONST_COMMON.RESOURCESID_SwfCommon_Common);
         SResourcesCore.TexturesSwfCreateChar.LoadPrimary(CONST_ACCOUNT.RESOURCESID_Swf_Account);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIWait() : void
      {
         if(!SResourcesCore.ResourceBin.Loading && !SResourcesCore.TexturesSwfCommon.Loading && !SResourcesCore.TexturesSwfCreateChar.Loading)
         {
            FResourcesState = RESOURCESSTATE_UIDispatch;
         }
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TBins = null;
         var _loc4_:TRandomName = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:MovieClip = null;
         var _loc9_:String = null;
         _loc3_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_RandomName);
         _loc4_ = _loc3_.GetDatebaseByIndex(0) as TRandomName;
         _loc2_ = int(_loc4_.LastNames.length);
         this.FLastNames = new Vector.<String>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FLastNames[_loc1_] = _loc4_.LastNames[_loc1_];
            _loc1_++;
         }
         _loc2_ = int(_loc4_.MaleNames.length);
         this.FMaleNames = new Vector.<String>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMaleNames[_loc1_] = _loc4_.MaleNames[_loc1_];
            _loc1_++;
         }
         _loc2_ = int(_loc4_.FemaleNames.length);
         this.FFemaleNames = new Vector.<String>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FFemaleNames[_loc1_] = _loc4_.FemaleNames[_loc1_];
            _loc1_++;
         }
         SResourcesCore.ResourceBin.DeleteByIdentifier(CONST_DATEBASEVO.RESOURCEID_RandomName);
         this.FMC_Account = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACCOUNT.RESOURCE_ClassName_MC_Account) as Sprite;
         addChild(this.FMC_Account);
         this.FBtn_CreateRole = new TUIButton();
         this.FBtn_CreateRole.Substrate = this.FMC_Account[CONST_ACCOUNT.RESOURCE_Link_Btn_CreateRole];
         this.FBtn_CreateRole.OnClick = this.ButtonCreateRoleOnClick;
         this.FBtn_RandomName = new TUIButton();
         this.FBtn_RandomName.Substrate = this.FMC_Account[CONST_ACCOUNT.RESOURCE_Link_Btn_RandomName];
         this.FBtn_RandomName.OnClick = this.ButtonRandomNameOnClick;
         this.FTF_UserName = this.FMC_Account[CONST_ACCOUNT.RESOURCE_Link_TF_UserName];
         this.FTF_UserName.maxChars = 12;
         if(false == true || false == true || false == true)
         {
            this.FTF_UserName.restrict = "[a-zA-Z0-9#一-龥]";
            this.FTF_UserName.maxChars = 6;
         }
         if(false == true || false == true)
         {
            this.FTF_UserName.maxChars = 16;
         }
         if(false == true)
         {
            this.FTF_UserName.restrict = "[a-zA-Z0-9Ё-ө]";
            this.FTF_UserName.maxChars = 16;
         }
         this.FMC_UserBigPic = this.FMC_Account[CONST_ACCOUNT.RESOURCE_Link_MC_UserBigPic];
         this.FBmpHero = new Bitmap();
         this.FMC_UserBigPic.addChild(this.FBmpHero);
         this.FTF_VirtualName = this.FMC_Account[CONST_ACCOUNT.RESOURCE_Link_TF_VirtualName];
         this.FStringVirtualnames = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.CREATECHAR_STRING_01);
         this.FVirtualNames = new Vector.<String>(CAPACITY_VirtualNames);
         this.FTempVirtualNamesA = new Vector.<String>(CAPACITY_VirtualNames);
         _loc2_ = CAPACITY_VirtualNames;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc9_ = this.CreatVirtualNames();
            this.FVirtualNames[_loc1_] = TUtilityString.Format(this.FStringVirtualnames,_loc9_);
            this.FTempVirtualNamesA[_loc1_] = _loc9_;
            _loc1_++;
         }
         this.FUserHeroVect = new Vector.<MovieClip>(MAX_Heros);
         _loc2_ = MAX_Heros;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc8_ = this.FMC_Account[CONST_ACCOUNT.RESOURCE_Link_MC_Hero + _loc1_];
            _loc8_.buttonMode = true;
            _loc8_.addEventListener(MouseEvent.CLICK,this.MC_HeroOnClick,false,0,true);
            _loc8_.addEventListener(MouseEvent.MOUSE_OVER,this.MC_HeroOnOver,false,0,true);
            _loc8_.addEventListener(MouseEvent.MOUSE_MOVE,this.MC_HeroOnMove,false,0,true);
            _loc8_.addEventListener(MouseEvent.MOUSE_OUT,this.MC_HeroOnOut,false,0,true);
            this.FUserHeroVect[_loc1_] = _loc8_;
            _loc1_++;
         }
         this.ProcessorHeroRandom();
         this.FInitialization = true;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_CREATECHAR_CreateCharRet,this.PacketPerform_SC_CreateCharRet);
      }
      
      protected function PacketPerform_SC_CreateCharRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ByteArray = null;
         _loc3_ = param1.Data;
         _loc2_ = _loc3_.readUnsignedInt();
         if(_loc2_ != 0)
         {
            this.EffectGenerateTextByErrorCode(_loc2_);
            this.FTF_UserName.setSelection(0,this.FTF_UserName.text.length);
            if(FUICore.UIStage.focus != this.FTF_UserName)
            {
               FUICore.UIStage.focus = this.FTF_UserName;
            }
            return;
         }
         SExternalCore.PushPlayerInfo(this.FTF_UserName.text,1);
         SExternalCore.CreateRole(this.FTF_UserName.text);
         if(this.FOnCharCreated != null)
         {
            this.FOnCharCreated(this);
         }
         this.Visible = false;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(!this.FInitialization)
         {
            return;
         }
         this.LogicsPerform_VirtualName();
      }
      
      protected function LogicsPerform_VirtualName() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         _loc1_ = int(STimingCore.TickCount);
         if(_loc1_ < this.FNextTick)
         {
            return;
         }
         _loc4_ = "";
         this.FVirtualNames.shift();
         _loc4_ = this.CreatVirtualNames();
         this.FStringVirtualnames = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.CREATECHAR_STRING_01);
         this.FVirtualNames.push(TUtilityString.Format(this.FStringVirtualnames,_loc4_));
         _loc4_ = "";
         _loc3_ = this.FVirtualNames.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(_loc2_ >= 6)
            {
               break;
            }
            _loc4_ += this.FVirtualNames[_loc2_];
            _loc2_++;
         }
         this.FTF_VirtualName.htmlText = _loc4_;
         this.FNextTick = STimingCore.TickCount + TUtilityMath.RandomRange(1500,5000);
      }
      
      protected function LoadHeroImage() : void
      {
         this.FHeroImageID = PROFESSION_IDS[this.FSelectIndex];
         SResourcesCore.TexturesVital.LoadAutoSecondary(this.FHeroImageID,this.AutoLoadCallBack);
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         var _loc5_:BitmapData = null;
         _loc4_ = param2.GetAnimationSequenceByIndex(0);
         this.FBmpHero.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
      }
      
      protected function CreatVirtualNames() : String
      {
         var _loc1_:uint = 0;
         var _loc2_:Vector.<String> = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         _loc1_ = TUtilityMath.RandomRange(0,this.FLastNames.length - 1);
         _loc3_ = this.FLastNames[_loc1_];
         _loc1_ = TUtilityMath.RandomRange(0,1);
         switch(_loc1_)
         {
            case GENDER_Female:
               _loc2_ = this.FFemaleNames;
               break;
            case GENDER_Male:
               _loc2_ = this.FMaleNames;
         }
         _loc1_ = TUtilityMath.RandomRange(0,_loc2_.length - 1);
         _loc4_ = _loc2_[_loc1_];
         return _loc3_ + _loc4_;
      }
      
      protected function EffectGenerateTextByErrorCode(param1:uint) : void
      {
         var _loc2_:TBins = null;
         var _loc3_:TErrorCode = null;
         var _loc4_:String = null;
         _loc4_ = null;
         _loc2_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ErrorCode);
         if(_loc2_ != null)
         {
            _loc3_ = _loc2_.GetDatebaseByIdentifier(param1) as TErrorCode;
            if(_loc3_ != null)
            {
               _loc4_ = _loc3_.Desc;
            }
         }
         if(_loc4_ != null)
         {
            if(this.FOnEffectText != null)
            {
               this.FOnEffectText(this,_loc4_);
            }
         }
      }
      
      protected function ProcessorHeroRandom() : void
      {
         var _loc1_:int = 0;
         _loc1_ = TUtilityMath.RandomRange(1,MAX_Heros);
         switch(_loc1_)
         {
            case PROFESSIONS_TYPE[0]:
            case PROFESSIONS_TYPE[1]:
               this.FProfession = CONST_CHARACTER.PROFESSION_Strength;
               break;
            case PROFESSIONS_TYPE[2]:
            case PROFESSIONS_TYPE[3]:
               this.FProfession = CONST_CHARACTER.PROFESSION_Agility;
               break;
            case PROFESSIONS_TYPE[4]:
            case PROFESSIONS_TYPE[5]:
               this.FProfession = CONST_CHARACTER.PROFESSION_Intellect;
         }
         this.ButtonRandomNameOnClick(this,null);
         this.FSelectIndex = _loc1_ - 1;
         this.FGender = _loc1_ % 2;
         this.FUserHeroVect[_loc1_ - 1].gotoAndStop(2);
         this.LoadHeroImage();
      }
      
      protected function ButtonRandomNameOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:Vector.<String> = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         _loc3_ = TUtilityMath.RandomRange(0,this.FLastNames.length - 1);
         _loc5_ = this.FLastNames[_loc3_];
         switch(this.FGender)
         {
            case GENDER_Female:
               _loc4_ = this.FFemaleNames;
               break;
            case GENDER_Male:
               _loc4_ = this.FMaleNames;
         }
         _loc3_ = TUtilityMath.RandomRange(0,_loc4_.length - 1);
         _loc6_ = _loc4_[_loc3_];
         this.FTF_UserName.text = _loc5_ + _loc6_;
      }
      
      protected function ButtonCreateRoleOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         var _loc5_:String = null;
         var _loc6_:uint = 0;
         var _loc7_:int = 0;
         var _loc8_:uint = 0;
         _loc5_ = this.FTF_UserName.text;
         _loc6_ = uint(this.FProfession);
         if(TUtilityString.Empty(_loc5_))
         {
            if(this.FOnEffectText != null)
            {
               this.FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NameNull),null,null);
            }
            return;
         }
         _loc8_ = this.FTempVirtualNamesA.length;
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            if(this.FTempVirtualNamesA[_loc7_] == _loc5_)
            {
               if(this.FOnEffectText != null)
               {
                  this.FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NameExists),null,null);
               }
               return;
            }
            _loc7_++;
         }
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CREATECHAR_CreateChar);
         _loc4_ = _loc3_.Data;
         TUtilityString.FlushUTF(_loc4_,_loc5_);
         _loc4_.writeByte(_loc6_);
         _loc4_.writeByte(this.FGender);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function MC_HeroOnClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:MovieClip = null;
         var _loc6_:int = 0;
         _loc5_ = param1.currentTarget as MovieClip;
         _loc6_ = parseInt(_loc5_.name.split("_")[2]);
         if(_loc6_ == this.FSelectIndex)
         {
            return;
         }
         this.FSelectIndex = _loc6_;
         _loc3_ = MAX_Heros;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FUserHeroVect[_loc2_].gotoAndStop(1);
            _loc2_++;
         }
         _loc5_.gotoAndStop(2);
         _loc6_ += 1;
         switch(_loc6_)
         {
            case PROFESSIONS_TYPE[0]:
            case PROFESSIONS_TYPE[1]:
               this.FProfession = CONST_CHARACTER.PROFESSION_Strength;
               break;
            case PROFESSIONS_TYPE[2]:
            case PROFESSIONS_TYPE[3]:
               this.FProfession = CONST_CHARACTER.PROFESSION_Agility;
               break;
            case PROFESSIONS_TYPE[4]:
            case PROFESSIONS_TYPE[5]:
               this.FProfession = CONST_CHARACTER.PROFESSION_Intellect;
         }
         this.FGender = _loc6_ % 2;
         if(this.FTF_UserName != null)
         {
            if(TUtilityString.Empty(this.FTF_UserName.text))
            {
               this.ButtonRandomNameOnClick(this,null);
            }
         }
         this.LoadHeroImage();
      }
      
      protected function MC_HeroOnOver(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         var _loc4_:TSystemLanguage = null;
         _loc2_ = param1.currentTarget as MovieClip;
         _loc3_ = parseInt(_loc2_.name.split("_")[2]);
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SystemLanguage,PROFESSIONS_CONFIGVALUEID[_loc3_]) as TSystemLanguage;
         this.FHint.Caption = _loc4_.Desc;
         if(_loc3_ == this.FSelectIndex)
         {
            return;
         }
         _loc2_.gotoAndStop(2);
      }
      
      protected function MC_HeroOnMove(param1:MouseEvent) : void
      {
         if(!TUtilityString.Empty(this.FHint.Caption))
         {
            if(SUtilityOverLayer.Initialization)
            {
               SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
            }
         }
      }
      
      protected function MC_HeroOnOut(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:String = null;
         _loc3_ = param1.currentTarget as MovieClip;
         if(SUtilityOverLayer.Initialization)
         {
            SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
         }
         _loc2_ = parseInt(_loc3_.name.split("_")[2]);
         if(_loc2_ == this.FSelectIndex)
         {
            return;
         }
         _loc3_.gotoAndStop(1);
         this.FHint.Caption = "";
      }
      
      public function get OnEffectText() : Function
      {
         return this.FOnEffectText;
      }
      
      public function set OnEffectText(param1:Function) : void
      {
         this.FOnEffectText = param1;
      }
      
      public function get OnCharCreated() : Function
      {
         return this.FOnCharCreated;
      }
      
      public function set OnCharCreated(param1:Function) : void
      {
         this.FOnCharCreated = param1;
      }
      
      override public function Dispose() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         this.FHint = null;
         this.FBtn_CreateRole.OnClick = null;
         this.FBtn_CreateRole.Dispose();
         this.FBtn_CreateRole = null;
         this.FBtn_RandomName.OnClick = null;
         this.FBtn_RandomName.Dispose();
         this.FBtn_RandomName = null;
         this.FBmpHero.bitmapData.dispose();
         this.FBmpHero.bitmapData = null;
         this.FMC_UserBigPic.removeChild(this.FBmpHero);
         this.FBmpHero = null;
         this.FMC_Account.removeChild(this.FMC_UserBigPic);
         this.FMC_UserBigPic = null;
         this.removeChild(this.FMC_Account);
         _loc2_ = int(this.FUserHeroVect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FUserHeroVect[_loc1_];
            _loc3_.removeEventListener(MouseEvent.CLICK,this.MC_HeroOnClick);
            _loc3_.removeEventListener(MouseEvent.MOUSE_OVER,this.MC_HeroOnOver);
            _loc3_.removeEventListener(MouseEvent.MOUSE_MOVE,this.MC_HeroOnMove);
            _loc3_.removeEventListener(MouseEvent.MOUSE_OUT,this.MC_HeroOnOut);
            _loc1_++;
         }
         this.FTF_UserName = null;
         this.FTF_VirtualName = null;
         this.FLastNames.length = 0;
         this.FMaleNames.length = 0;
         this.FFemaleNames.length = 0;
         this.FVirtualNames.length = 0;
         this.FTempVirtualNamesA.length = 0;
         this.FUserHeroVect.length = 0;
         this.FLastNames = null;
         this.FMaleNames = null;
         this.FFemaleNames = null;
         this.FVirtualNames = null;
         this.FTempVirtualNamesA = null;
         this.FUserHeroVect = null;
         this.FStringVirtualnames = null;
         this.FMC_Account = null;
      }
      
      public function SubmitGameStatistical() : void
      {
         SExternalCore.GameStatistical(CONST_ACCOUNT.STATISTICALSETP_AccountMount);
      }
   }
}

