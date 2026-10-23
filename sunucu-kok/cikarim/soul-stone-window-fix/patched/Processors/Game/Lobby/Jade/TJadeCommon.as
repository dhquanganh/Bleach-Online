package Processors.Game.Lobby.Jade
{
   import Components.Slots.*;
   import Foundation.Queries.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.Utilities.*;
   import Logics.Inventories.*;
   import Logics.SLogicsCore;
   import Logics.DatebaseVO.VO.TBaseStone;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import flash.display.*;
   
   public class TJadeCommon
   {
      
      public function TJadeCommon()
      {
         super();
      }
      
      public static function SlotsOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         if(param2 == null)return;
         var _loc5_:TInventory = null;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         _loc5_ = param2 as TInventory;
         _loc6_ = SResourcesCore.TexturesInventory;
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc5_.IDTexture);
         if(_loc7_ != null)
         {
            param3.Value = _loc7_.GetAnimationSequenceByIdentifier(param4);
         }
         else
         {
            _loc6_.LoadSecondary(_loc5_.IDTexture);
         }
      }
      
      public static function SlotsOnQuerySubscript(param1:Object, param2:Object, param3:TQueryString) : void
      {
         var _loc4_:TInventory = null;
         if(param2 is TInventory)
         {
            _loc4_ = param2 as TInventory;
            param3.Value = _loc4_.Quantity.toString();
         }
      }
      
      public static function ProcessorUpdateSlotsRenderingState(param1:Vector.<TUISlot>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TUISlot = null;
         _loc3_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1[_loc2_];
            _loc4_.Update();
            _loc2_++;
         }
      }
      
      public static function InitSlot(param1:TUISlot) : void
      {
         param1.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         param1.OnQuerySequenceContext = SlotsOnQuerySequenceContext;
         param1.OnQuerySubscript = SlotsOnQuerySubscript;
         param1.OnQueryEuqipLevel = SlotsOnQueryEuqipLevel;
      }
      
      protected static function SlotsOnQueryEuqipLevel(param1:Object, param2:Object, param3:TQueryString) : void
      {
         var _loc4_:TEquipment = null;
         if(param2 is TEquipment)
         {
            _loc4_ = param2 as TEquipment;
            if(_loc4_.UpgradingLevel > 0)
            {
               param3.Value = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_05),_loc4_.UpgradingLevel);
            }
         }
      }
      
      public static function GemSignature():String {
         var gems:TInventories = SLogicsCore.Character.Gems;var result:String = "";
         if(gems == null)return result;
         for(var i:int=0;i<gems.Count;i++){var gem:TInventory = gems.GetInventoryByIndex(i);if(gem != null)result += gem.IDTemplate+":"+gem.Quantity+";";}
         return result;
      }
      public static function GetSpecialJade(param1:TInventories, param2:TInventories, param3:int, param4:int) : void
      {
         if(param1 == null || param2 == null)return;
         var _loc5_:TInventory = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc7_ = param1.Count;
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc5_ = param1.GetInventoryByIndex(_loc6_);
            if(_loc5_ == null || _loc5_.Quantity == 0 || SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseStone,_loc5_.IDTemplate) == null){_loc6_++;continue;}
            if(!(param3 != -1 && _loc5_.RequirementLevel != param3))
            {
               if(!(param4 != -1 && param4 != _loc5_.CategorySecond))
               {
                  param2.Add(_loc5_);
               }
            }
            _loc6_++;
         }
      }
   }
}

