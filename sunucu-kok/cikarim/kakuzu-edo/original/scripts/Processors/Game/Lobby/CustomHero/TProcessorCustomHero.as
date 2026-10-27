package Processors.Game.Lobby.CustomHero
{
   import Foundation.Common.TBounds;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.Characters.THero;
   import Logics.CustomHero.TCurHero;
   import Logics.CustomHero.TCustomHero;
   import Logics.CustomHero.TCustomHeroInfo;
   import Logics.SLogicsCore;
   import Logics.Skills.TSkill;
   import Logics.Spaces.LogicsSpace;
   import Logics.Streamization.CustomHero.TUnstreamizerCustomHero;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NETWORK;
   import flash.utils.ByteArray;
   
   use namespace LogicsSpace;
   
   public class TProcessorCustomHero extends TProcessorLobbyWindows
   {
      
      protected static const WINDOW_WIDTH:int = 812;
      
      protected static const WINDOW_HEIGTH:int = 613;
      
      protected const RESOURCESID_Swf:uint = 788529152;
      
      protected var FMainWin:TProcessorWindowCustomHero;
      
      protected var FBounds:TBounds;
      
      protected var FUnstreamizer:TUnstreamizerCustomHero;
      
      protected var FData:TCustomHero;
      
      protected var FInited:Boolean;
      
      public function TProcessorCustomHero(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FMainWin = new TProcessorWindowCustomHero(this);
         this.FMainWin.OnClose = this.ShutDownWindows;
         this.FMainWin.Visible = false;
         this.FBounds = new TBounds();
         this.FBounds.Width = WINDOW_WIDTH;
         this.FBounds.Height = WINDOW_HEIGTH;
         ComponentBoundsCenter(this.FMainWin,this.FBounds);
         this.FUnstreamizer = new TUnstreamizerCustomHero();
         this.FInited = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(this.RESOURCESID_Swf);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_CustomHero_InitInfoRet,this.PacketPerform_SC_InitInfoRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_CustomHero_UpdateRet,this.PacketPerform_SC_UpdateRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_CustomHero_ChangeSkillRet,this.PacketPerform_SC_ChangeSkillRet);
      }
      
      protected function PacketPerform_SC_InitInfoRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:TCustomHero = null;
         var _loc8_:TCustomHeroInfo = null;
         var _loc9_:TCurHero = null;
         var _loc10_:Vector.<TCustomHero> = null;
         _loc10_ = new Vector.<TCustomHero>();
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = uint(param1.Data.readShort());
         _loc5_ = uint(SLogicsCore.Character.Heros.Count);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc7_ = new TCustomHero();
            _loc7_.Identifier = param1.Data.readUnsignedInt();
            _loc7_.Level = param1.Data.readUnsignedInt();
            if(_loc7_.Level == 0 && SLogicsCore.Character.Heros.GetHeroByIdentifier(_loc7_.Identifier).CustomHero != null)
            {
               SLogicsCore.Character.Heros.GetHeroByIdentifier(_loc7_.Identifier).CustomHero = null;
            }
            _loc7_.SkillSwitch = param1.Data.readUnsignedInt();
            _loc10_[_loc4_] = _loc7_;
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               if(_loc7_.Identifier == SLogicsCore.Character.Heros.GetHeroByIndex(_loc6_).Identifier)
               {
                  _loc9_ = new TCurHero();
                  _loc9_.Identifier = _loc7_.Identifier;
                  _loc9_.Level = _loc7_.Level;
                  _loc9_.HeroCongfig = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_CustomHeros,_loc7_.Identifier) as TCustomHeroInfo;
                  _loc9_.HeroGrowths = _loc9_.HeroCongfig.GrowthLimit;
                  _loc9_.HeroSkills = _loc9_.HeroCongfig.ExclusiveLimit;
                  _loc9_.HeroName = SLogicsCore.Character.Heros.GetHeroByIndex(_loc6_).Name;
                  SLogicsCore.Character.Heros.GetHeroByIndex(_loc6_).CustomHero = _loc9_;
               }
               _loc6_++;
            }
            _loc4_++;
         }
         if(this.FMainWin.Visible)
         {
            this.FInited = true;
            this.FMainWin.UpdateWinHerosBin(_loc10_);
         }
      }
      
      protected function PacketPerform_SC_UpdateRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:TCustomHero = null;
         var _loc8_:TCurHero = null;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = param1.Data.readUnsignedInt();
         _loc4_ = param1.Data.readUnsignedInt();
         _loc5_ = uint(SLogicsCore.Character.Heros.Count);
         _loc7_ = new TCustomHero();
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            if(_loc3_ == SLogicsCore.Character.Heros.GetHeroByIndex(_loc6_).Identifier)
            {
               _loc8_ = new TCurHero();
               _loc8_.Identifier = _loc3_;
               _loc8_.Level = _loc4_;
               _loc8_.HeroCongfig = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_CustomHeros,_loc3_) as TCustomHeroInfo;
               _loc8_.HeroGrowths = _loc8_.HeroCongfig.GrowthLimit;
               _loc8_.HeroSkills = _loc8_.HeroCongfig.ExclusiveLimit;
               _loc8_.HeroName = SLogicsCore.Character.Heros.GetHeroByIndex(_loc6_).Name;
               SLogicsCore.Character.Heros.GetHeroByIndex(_loc6_).CustomHero = _loc8_;
            }
            _loc6_++;
         }
         this.FMainWin.UpdateWinData(_loc3_,_loc4_,-1);
      }
      
      protected function PacketPerform_SC_ChangeSkillRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TSkill = null;
         var _loc7_:THero = null;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = param1.Data.readUnsignedInt();
         _loc4_ = param1.Data.readUnsignedInt();
         this.FMainWin.UpdateWinData(_loc3_,-1,_loc4_);
         _loc5_ = param1.Data.readUnsignedInt();
         _loc7_ = SLogicsCore.Character.Heros.GetHeroByIdentifier(_loc3_);
         if(_loc7_.IsMain && _loc4_ != 0)
         {
            _loc6_ = new TSkill(_loc5_);
            TUtilityLobby.ConstructSkillByID(_loc5_,_loc6_);
            SLogicsCore.Character.MainHero.Skill = _loc6_;
         }
         else
         {
            TUtilityLobby.ConstructSkillByID(_loc5_,_loc7_.Skill);
            _loc7_.Skill.Coerce(_loc5_);
         }
      }
      
      protected function ShutDownWindows(param1:Object) : void
      {
         ProcessorClose();
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FMainWin.Load();
            return;
         }
         this.FUnstreamizer.InitReq();
         this.FMainWin.Visible = true;
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
      }
   }
}

