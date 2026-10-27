package Processors.Game.Lobby.TacticalDeployment.Components
{
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.KnifeOfKillSoul.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.text.*;
   
   public class TKnifeInforTip extends TUIComponent
   {
      
      public static const TYPE_TIPS_NORMAL:uint = 0;
      
      public static const TYPE_TIPS_BATTLE:uint = 1;
      
      protected static const RESOURCE_Link_MC_KnifeInforTip:String = "KnifeInforTip";
      
      protected static const RESOURCE_Link_MC_BattleKnifeInforTip:String = "MC_BattleKnifeInforTip";
      
      protected var FMainUI:MovieClip;
      
      protected var FTF_Name:TextField;
      
      protected var FMC_StarLevel:MovieClip;
      
      protected var FTF_LevelName:TextField;
      
      protected var FTF_KnifeSoulAdded:TextField;
      
      protected var FTF_SkillDescription:TextField;
      
      protected var FTF_AddedFrontValues:Vector.<TextField>;
      
      protected var FTF_AddedMiddleValues:Vector.<TextField>;
      
      protected var FTF_AddedBackValues:Vector.<TextField>;
      
      protected var FTF_SkillName:TextField;
      
      protected var FKnifeLevelName:Vector.<String>;
      
      protected var FKnifeData:TKnifeOfKillSoulData;
      
      protected var FType:int;
      
      public function TKnifeInforTip(param1:TUIComponent)
      {
         super(param1);
         this.FType = TYPE_TIPS_NORMAL;
      }
      
      protected function UIDispatch_Perform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         if(this.Type == TYPE_TIPS_NORMAL)
         {
            _loc2_ = RESOURCE_Link_MC_KnifeInforTip;
         }
         else
         {
            _loc2_ = RESOURCE_Link_MC_BattleKnifeInforTip;
         }
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance(_loc2_) as MovieClip;
         this.addChild(this.FMainUI);
         this.FMC_StarLevel = this.FMainUI["StarLevel"];
         if(this.FType == TYPE_TIPS_NORMAL)
         {
            this.FTF_Name = this.FMainUI["Name"];
            this.FTF_LevelName = this.FMainUI["LevelName"];
            this.FTF_KnifeSoulAdded = this.FMainUI["KnifeSoulAdd"];
         }
         this.FTF_SkillName = this.FMainUI["SkillName"];
         this.FTF_SkillDescription = this.FMainUI["Description"];
         this.FTF_AddedFrontValues = new Vector.<TextField>();
         this.FTF_AddedMiddleValues = new Vector.<TextField>();
         this.FTF_AddedBackValues = new Vector.<TextField>();
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            this.FTF_AddedFrontValues.push(this.FMainUI["FrontAddValue" + _loc1_]);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 2)
         {
            this.FTF_AddedMiddleValues.push(this.FMainUI["MiddleAddValue" + _loc1_]);
            this.FTF_AddedBackValues.push(this.FMainUI["BackAddValue" + _loc1_]);
            _loc1_++;
         }
         this.FKnifeLevelName = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_3);
      }
      
      protected function UILocation_Perform() : void
      {
         this.mouseEnabled = false;
         this.mouseChildren = false;
      }
      
      protected function FlushAttributeAdded(param1:Vector.<TextField>, param2:Vector.<TKnifeAdd>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:TKnifeAdd = null;
         _loc3_ = 0;
         while(_loc3_ < param2.length)
         {
            _loc5_ = param2[_loc3_];
            if(_loc5_.Value < 0)
            {
               _loc4_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_9),int(_loc5_.Value * -1 * 100) + "");
               param1[_loc3_].textColor = 16711680;
            }
            else
            {
               _loc4_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_8),int(_loc5_.Value * 100) + "");
               param1[_loc3_].textColor = _loc5_.Value == 0 ? 13421772 : 65280;
            }
            param1[_loc3_].text = _loc4_;
            _loc3_++;
         }
      }
      
      protected function Update() : void
      {
         var _loc1_:TSkillConfig = null;
         if(this.FType == TYPE_TIPS_NORMAL)
         {
            this.FTF_Name.text = this.FKnifeData.Name;
            this.FTF_LevelName.text = this.FKnifeLevelName[this.FKnifeData.Level - 1];
            this.FTF_KnifeSoulAdded.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_8),this.FKnifeData.KnifeSoulAdded);
         }
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SkillConfig,this.FKnifeData.SkillID) as TSkillConfig;
         this.FTF_SkillName.text = _loc1_.Name;
         this.FTF_SkillDescription.text = _loc1_.Desc;
         this.FlushAttributeAdded(this.FTF_AddedFrontValues,this.FKnifeData.AddedFront);
         this.FlushAttributeAdded(this.FTF_AddedMiddleValues,this.FKnifeData.AddedMiddle);
         this.FlushAttributeAdded(this.FTF_AddedBackValues,this.FKnifeData.AddedBack);
      }
      
      protected function UpdatePosition_Perform() : void
      {
         if(FUICore.MouseCoordinate.X > CONST_COMMON.STAGE_Width - width)
         {
            x = Math.max(FUICore.MouseCoordinate.X - width - 40,0);
         }
         else
         {
            x = Math.min(FUICore.MouseCoordinate.X + 40,CONST_COMMON.STAGE_Width - width);
         }
         if(FUICore.MouseCoordinate.Y > CONST_COMMON.STAGE_Height - height)
         {
            y = Math.max(FUICore.MouseCoordinate.Y - height,0);
         }
         else
         {
            y = Math.min(FUICore.MouseCoordinate.Y,CONST_COMMON.STAGE_Height - height);
         }
      }
      
      public function set KnifeData(param1:TKnifeOfKillSoulData) : void
      {
         this.FKnifeData = param1;
         if(this.FKnifeData != null)
         {
            this.Update();
         }
      }
      
      public function get Type() : int
      {
         return this.FType;
      }
      
      public function set Type(param1:int) : void
      {
         this.FType = param1;
      }
      
      public function UIDispatch() : void
      {
         this.UIDispatch_Perform();
      }
      
      public function UILocation() : void
      {
         this.UILocation_Perform();
      }
      
      public function UpdatePosition() : void
      {
         this.UpdatePosition_Perform();
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FTF_Name.text = "";
         this.FTF_SkillName.text = "";
         this.FTF_LevelName.text = "";
         this.FTF_KnifeSoulAdded.text = "";
         this.FTF_SkillDescription.text = "";
         _loc2_ = int(this.FTF_AddedFrontValues.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTF_AddedFrontValues[_loc1_].text = "";
            _loc1_++;
         }
         _loc2_ = int(this.FTF_AddedMiddleValues.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTF_AddedMiddleValues[_loc1_].text = "";
            _loc1_++;
         }
         _loc2_ = int(this.FTF_AddedBackValues.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTF_AddedBackValues[_loc1_].text = "";
            _loc1_++;
         }
         this.FKnifeData.Reset();
         this.FKnifeData = null;
      }
   }
}

