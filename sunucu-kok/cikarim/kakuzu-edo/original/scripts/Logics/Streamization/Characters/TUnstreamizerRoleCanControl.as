package Logics.Streamization.Characters
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.TUnstreamizer;
   import Foundation.Utilities.TUtilityString;
   import Logics.Characters.MoveRole.TRoleCanControl;
   import Logics.DatebaseVO.VO.TBaseHero;
   import Logics.DatebaseVO.VO.TKnifeExpand;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerRoleCanControl extends TUnstreamizer
   {
      
      public function TUnstreamizerRoleCanControl()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_Properties(param1,param2,param3);
      }
      
      protected function UnstreamizationPerform_Properties(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TRoleCanControl = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TKnifeExpand = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         _loc4_ = param2 as TRoleCanControl;
         _loc4_.RoleTemplateID = param1.readUnsignedInt();
         _loc4_.RoleName = TUtilityString.FetchUTF(param1);
         _loc4_.MilitaryRank = param1.readUnsignedInt();
         _loc4_.Level = param1.readUnsignedInt();
         _loc4_.FamilyID = param1.readUnsignedInt();
         _loc4_.RelexBoo = param1.readByte() == 0;
         _loc4_.TextureID = param1.readUnsignedInt();
         if(_loc4_.TextureID != 0)
         {
            _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_KnifeExpand,_loc4_.TextureID) as TKnifeExpand;
            _loc4_.TextureID = _loc7_.RelationID;
         }
         _loc4_.MapX = param1.readUnsignedShort();
         _loc4_.MapY = param1.readUnsignedShort();
         _loc4_.Quality = param1.readByte();
         _loc4_.NewShapeBaseHeroID = param1.readUnsignedInt();
         _loc4_.ChangeShape = _loc4_.NewShapeBaseHeroID != 0;
         param1.readUnsignedByte();
         param1.readUnsignedByte();
         param1.readInt();
         _loc8_ = int(param1.readUnsignedShort());
         _loc9_ = 0;
         while(_loc9_ < _loc8_)
         {
            param1.readUnsignedInt();
            _loc9_++;
         }
         param1.readInt();
         _loc4_.RebirthNum = param1.readByte();
      }
      
      protected function GetTemplateIDByProfessionGender(param1:int, param2:int) : int
      {
         var _loc3_:TBaseHero = null;
         var _loc4_:TBins = null;
         var _loc5_:int = 0;
         _loc4_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BaseHero);
         _loc5_ = 0;
         while(_loc5_ < _loc4_.Count)
         {
            _loc3_ = _loc4_.GetDatebaseByIndex(_loc5_) as TBaseHero;
            if(_loc3_.Profession == param1 && _loc3_.Sex == param2)
            {
               return _loc3_.Identifier;
            }
            _loc5_++;
         }
         return 0;
      }
   }
}

