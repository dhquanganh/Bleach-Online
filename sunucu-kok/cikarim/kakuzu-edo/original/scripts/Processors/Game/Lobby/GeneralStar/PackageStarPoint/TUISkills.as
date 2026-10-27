package Processors.Game.Lobby.GeneralStar.PackageStarPoint
{
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.Skills.*;
   import Resources.Constants.*;
   import flash.display.*;
   
   public class TUISkills extends TUIComponent
   {
      
      protected static const SKILL_NUM:uint = 10;
      
      protected var FScence:MovieClip;
      
      protected var FConfigValue:TBins;
      
      protected var FSkillList:Vector.<TUISkillBox>;
      
      protected var FContext:Object;
      
      protected var FOnSkillUpgrade:Function;
      
      protected var FOnBoxClick:Function;
      
      protected var FOnBoxOut:Function;
      
      protected var FOnBoxOver:Function;
      
      public function TUISkills(param1:TUIComponent, param2:MovieClip)
      {
         super(param1);
         this.FScence = param2;
         this.FSkillList = new Vector.<TUISkillBox>(SKILL_NUM);
      }
      
      private function SkillsInit() : void
      {
         var _loc1_:TUISkillBox = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:MovieClip = null;
         _loc3_ = SKILL_NUM;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FScence["skill_" + _loc2_];
            _loc1_ = new TUISkillBox(this,_loc4_);
            _loc1_.OnClickUpgrade = this.FOnSkillUpgrade;
            _loc1_.OnOver = this.FOnBoxOver;
            _loc1_.OnOut = this.FOnBoxOut;
            _loc1_.OnClick = this.FOnBoxClick;
            _loc1_.Init();
            this.FSkillList[_loc2_] = _loc1_;
            _loc2_++;
         }
         this.FConfigValue = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
      }
      
      private function UpdateLight(param1:TUISkillBox, param2:TSkill) : void
      {
         var _loc3_:TInventories = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:TInventory = null;
         var _loc8_:TConfigValue = null;
         _loc8_ = this.FConfigValue.GetDatebaseByIdentifier(CONST_CONFIGVALUE.SoulSkill_NeedItem) as TConfigValue;
         _loc3_ = SLogicsCore.Character.Appliances;
         _loc5_ = uint(_loc3_.Count);
         _loc6_ = 0;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_ = _loc3_.GetInventoryByIndex(_loc4_);
            if(_loc7_.IDTemplate == _loc8_.Value)
            {
               _loc6_ += _loc7_.Quantity;
            }
            _loc4_++;
         }
         if(_loc6_ >= param2.NeedItem.Amount)
         {
            param1.SetLight(true);
         }
         else
         {
            param1.SetLight(false);
         }
      }
      
      public function get Context() : Object
      {
         return this.FContext;
      }
      
      public function set Context(param1:Object) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TSkill = null;
         if(param1 is TSkills)
         {
            this.FContext = param1 as TSkills;
         }
         if(this.FContext == null)
         {
            return;
         }
         _loc3_ = SKILL_NUM;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FContext.GetSkillByIndex(_loc2_) as TSkill;
            this.FSkillList[_loc2_].Context = _loc4_;
            _loc2_++;
         }
      }
      
      public function get OnSkillUpgrade() : Function
      {
         return this.FOnSkillUpgrade;
      }
      
      public function set OnSkillUpgrade(param1:Function) : void
      {
         this.FOnSkillUpgrade = param1;
      }
      
      public function get OnBoxClick() : Function
      {
         return this.FOnBoxClick;
      }
      
      public function set OnBoxClick(param1:Function) : void
      {
         this.FOnBoxClick = param1;
      }
      
      public function get OnBoxOut() : Function
      {
         return this.FOnBoxOut;
      }
      
      public function set OnBoxOut(param1:Function) : void
      {
         this.FOnBoxOut = param1;
      }
      
      public function get OnBoxOver() : Function
      {
         return this.FOnBoxOver;
      }
      
      public function set OnBoxOver(param1:Function) : void
      {
         this.FOnBoxOver = param1;
      }
      
      public function Init() : void
      {
         this.SkillsInit();
      }
      
      public function UpdateSkills() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TSkill = null;
         if(this.FContext == null)
         {
            return;
         }
         _loc2_ = SKILL_NUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSkillList[_loc1_].UpdateSkill();
            _loc3_ = this.FSkillList[_loc1_].Context as TSkill;
            this.UpdateLight(this.FSkillList[_loc1_],_loc3_);
            _loc1_++;
         }
      }
      
      public function UpdateCurEffect(param1:int, param2:Boolean) : void
      {
         this.FSkillList[param1].SetCurEffect(param2);
      }
      
      public function Reset() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc2_ = SKILL_NUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSkillList[_loc1_].Reset();
            _loc1_++;
         }
         this.FContext = null;
      }
   }
}

