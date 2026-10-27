package Logics.Streamization.HellButterfly
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.TUnstreamizer;
   import Logics.Characters.TCharacter;
   import Logics.Characters.TFriendDigest;
   import Logics.Characters.TFriendDigests;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.HellButterfly.THellButterfly;
   import Logics.SLogicsCore;
   import Resources.Constants.CONST_CONFIGVALUE;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerHellButterfly extends TUnstreamizer
   {
      
      protected var FCharacter:TCharacter;
      
      public function TUnstreamizerHellButterfly()
      {
         super();
         this.FCharacter = SLogicsCore.Character;
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:THellButterfly = null;
         var _loc5_:TFriendDigests = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         _loc4_ = param2 as THellButterfly;
         _loc5_ = param3 as TFriendDigests;
         _loc4_.Reset();
         _loc4_.NowIdentifier0 = param1.readUnsignedInt();
         _loc4_.NowIdentifier1 = param1.readUnsignedInt();
         _loc4_.Level = param1.readUnsignedByte();
         _loc4_.CurExp = param1.readUnsignedInt();
         _loc4_.CollectionLevel = param1.readUnsignedByte();
         this.SetName(_loc5_,_loc4_);
         if(!_loc4_.IsMyself)
         {
            return;
         }
         this.Counter(param1,_loc4_);
         _loc7_ = uint(param1.readShort());
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc8_ = param1.readUnsignedInt();
            _loc9_ = param1.readUnsignedInt();
            this.SetEatStates(_loc8_,_loc9_,_loc5_);
            _loc6_++;
         }
      }
      
      protected function Counter(param1:ByteArray, param2:THellButterfly) : void
      {
         var _loc3_:TConfigValue = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.HELLBUTTERFLY_FEEDING_NUM) as TConfigValue;
         _loc4_ = _loc3_.Value as uint;
         param2.EatCount = _loc4_ - param1.readUnsignedByte();
         param2.EatCD = param1.readUnsignedInt();
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.HELLBUTTERFLY_NoVipCount) as TConfigValue;
         _loc4_ = _loc3_.Value as uint;
         _loc5_ = param1.readUnsignedByte();
         if(this.FCharacter.VipData.VipLevel == 0)
         {
            param2.CurCommunicationCount = _loc4_ - _loc5_;
         }
         else
         {
            param2.CurCommunicationCount = this.FCharacter.VipData.DailyChangeNum - _loc5_;
         }
      }
      
      private function SetName(param1:TFriendDigests, param2:THellButterfly) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TFriendDigest = null;
         if(param2.NowIdentifier0 == SLogicsCore.Character.Identifier0 && param2.NowIdentifier1 == SLogicsCore.Character.Identifier1)
         {
            param2.Name = SLogicsCore.Character.NickName;
            param2.IsMyself = true;
         }
         else
         {
            _loc4_ = uint(param1.Count);
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc5_ = param1.GetDigestByIndex(_loc3_);
               if(_loc5_.Identifier0 == param2.NowIdentifier0 && _loc5_.Identifier1 == param2.NowIdentifier1)
               {
                  param2.Name = _loc5_.Name;
                  param2.IsMyself = false;
               }
               _loc3_++;
            }
         }
      }
      
      private function SetEatStates(param1:uint, param2:uint, param3:TFriendDigests) : void
      {
         var _loc4_:TFriendDigest = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc6_ = uint(param3.Count);
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = param3.GetDigestByIndex(_loc5_);
            if(_loc4_.Identifier0 == param1 && _loc4_.Identifier1 == param2)
            {
               _loc4_.SendGoodOrNot = true;
               break;
            }
            _loc5_++;
         }
      }
   }
}

