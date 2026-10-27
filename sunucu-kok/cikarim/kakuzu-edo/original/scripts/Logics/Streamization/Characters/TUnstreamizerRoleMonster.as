package Logics.Streamization.Characters
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.TDatebaseVO;
   import Logics.DatebaseVO.VO.TBlockPoint;
   import Logics.DatebaseVO.VO.TSinglePointPath;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudleInMap;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudleInMapGuide;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudleInMapMonster;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerRoleMonster extends TUnstreamizer
   {
      
      protected var FBin_BlockPoint:TBins;
      
      protected var FBin_SinglePointPath:TBins;
      
      public function TUnstreamizerRoleMonster()
      {
         super();
      }
      
      protected function LoadResource() : void
      {
         if(this.FBin_BlockPoint == null)
         {
            this.FBin_BlockPoint = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BlockPoint);
         }
         if(this.FBin_SinglePointPath == null)
         {
            this.FBin_SinglePointPath = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SinglePointPath);
         }
      }
      
      protected function UnstreamizationRouting(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:Vector.<int> = null;
         var _loc5_:TDatebaseVO = null;
         _loc4_ = param3 as Vector.<int>;
         if(_loc4_.length == 0)
         {
            return;
         }
         _loc5_ = this.FBin_BlockPoint.GetDatebaseByIdentifier(_loc4_[0]);
         if(_loc5_ != null)
         {
            this.UnstreamizationMonsterOfBlockPoint(param1,param2,param3);
            return;
         }
         _loc5_ = this.FBin_SinglePointPath.GetDatebaseByIdentifier(_loc4_[0]);
         if(_loc5_ != null)
         {
            this.UnstreamizationMonsterOfSinglePointPath(param1,param2,param3);
            return;
         }
      }
      
      protected function UnstreamizationMonsterOfSinglePointPath(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Vector.<int> = null;
         var _loc6_:TSceneSpriteMoudleInMapMonster = null;
         var _loc7_:Vector.<TSceneSpriteMoudleInMap> = null;
         var _loc8_:TSinglePointPath = null;
         _loc5_ = param3 as Vector.<int>;
         _loc7_ = param2 as Vector.<TSceneSpriteMoudleInMap>;
         _loc4_ = 0;
         while(_loc4_ < _loc5_.length)
         {
            _loc8_ = this.FBin_SinglePointPath.GetDatebaseByIdentifier(_loc5_[_loc4_]) as TSinglePointPath;
            _loc6_ = SLogicsCore.PoolMap.AcquireMonster();
            _loc6_.MapCoordinate.X = _loc8_.CoordinateVect[0];
            _loc6_.MapCoordinate.Y = _loc8_.CoordinateVect[1];
            _loc6_.RoleTempleteID = _loc5_[_loc4_];
            _loc6_.IsBoss = false;
            _loc6_.HeroLevelNeed = SLogicsCore.Character.GetMainLevel();
            _loc6_.MouduleID = _loc8_.RoleModel;
            _loc6_.Name = _loc8_.Name;
            this.CreateGuideElement(_loc6_,_loc8_.GuidePoint,_loc7_);
            _loc7_.push(_loc6_);
            _loc4_++;
         }
      }
      
      protected function UnstreamizationMonsterOfBlockPoint(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Vector.<int> = null;
         var _loc6_:TSceneSpriteMoudleInMapMonster = null;
         var _loc7_:Vector.<TSceneSpriteMoudleInMap> = null;
         var _loc8_:TBlockPoint = null;
         _loc5_ = param3 as Vector.<int>;
         _loc7_ = param2 as Vector.<TSceneSpriteMoudleInMap>;
         _loc4_ = 0;
         while(_loc4_ < _loc5_.length)
         {
            _loc8_ = this.FBin_BlockPoint.GetDatebaseByIdentifier(_loc5_[_loc4_]) as TBlockPoint;
            _loc6_ = SLogicsCore.PoolMap.AcquireMonster();
            _loc6_.MapCoordinate.X = _loc8_.CoordinateVect[0];
            _loc6_.MapCoordinate.Y = _loc8_.CoordinateVect[1];
            _loc6_.RoleTempleteID = _loc5_[_loc4_];
            _loc6_.MouduleID = _loc8_.RoleModel;
            _loc6_.IsBoss = _loc8_.IsBoss != 0;
            _loc6_.HeroLevelNeed = _loc8_.Level;
            _loc6_.Name = _loc8_.Name;
            this.CreateGuideElement(_loc6_,_loc8_.GuidePoint,_loc7_);
            _loc7_.push(_loc6_);
            _loc4_++;
         }
      }
      
      protected function CreateGuideElement(param1:TSceneSpriteMoudleInMapMonster, param2:Vector.<Array>, param3:Vector.<TSceneSpriteMoudleInMap>) : void
      {
         var _loc4_:int = 0;
         var _loc5_:TSceneSpriteMoudleInMapGuide = null;
         var _loc6_:Array = null;
         _loc4_ = 0;
         while(_loc4_ < param2.length)
         {
            _loc5_ = SLogicsCore.PoolMap.AcquireMonsterGuidePoint();
            _loc5_.GuideMonsterID = param1.RoleTempleteID;
            _loc6_ = param2[_loc4_];
            _loc5_.MapCoordinate.X = _loc6_[0];
            _loc5_.MapCoordinate.Y = _loc6_[1];
            param3.push(_loc5_);
            _loc4_++;
         }
         _loc5_ = SLogicsCore.PoolMap.AcquireMonsterGuideBomb();
         _loc5_.MapCoordinate.Assign(param1.MapCoordinate);
         _loc5_.GuideMonsterID = param1.RoleTempleteID;
         param3.push(_loc5_);
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.LoadResource();
         this.UnstreamizationRouting(param1,param2,param3);
      }
   }
}

