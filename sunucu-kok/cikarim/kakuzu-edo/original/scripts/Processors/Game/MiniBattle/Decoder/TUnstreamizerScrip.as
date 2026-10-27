package Processors.Game.MiniBattle.Decoder
{
   import Foundation.Resources.*;
   import Foundation.Streamization.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Processors.Game.MiniBattle.Mode.*;
   import Processors.Game.MiniBattle.ScriptAction.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TUnstreamizerScrip extends TUnstreamizer
   {
      
      public static var TestString:String = "";
      
      protected var FFileScriptAction:TFileScriptAction;
      
      public function TUnstreamizerScrip()
      {
         super();
         this.FFileScriptAction = new TFileScriptAction();
      }
      
      protected function GetAttrackScript(param1:uint, param2:TFileScriptAction) : void
      {
         var _loc3_:TLeagueAction = null;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_LeagueAction,param1) as TLeagueAction;
         if(_loc3_ == null)
         {
            _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_LeagueAction,11100005) as TLeagueAction;
         }
         param2.ScriptAction = _loc3_.ScriptAction;
      }
      
      public function UnstreamizationScrip(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TBattleSoldierInfor = null;
         var _loc5_:Vector.<TScriptAction> = null;
         var _loc6_:TScriptAction = null;
         var _loc7_:int = 0;
         _loc4_ = param3 as TBattleSoldierInfor;
         _loc5_ = param2 as Vector.<TScriptAction>;
         this.FFileScriptAction.Reset();
         this.GetAttrackScript(_loc4_.TemplateID,this.FFileScriptAction);
         while(this.FFileScriptAction.HaveNext())
         {
            _loc7_ = this.FFileScriptAction.Next();
            _loc6_ = SLogicsCore.PoolScript.AcquireScript(_loc7_);
            _loc6_.Init(this.FFileScriptAction);
            _loc5_.push(_loc6_);
         }
      }
   }
}

