package Logics.Streamization.GeneralStar
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.DatebaseVO.VO.TStarPoint;
   import Logics.GeneralStar.TEsotericPoint;
   import Logics.Spaces.LogicsSpace;
   import Resources.Constants.CONST_DATEBASEVO;
   
   use namespace LogicsSpace;
   
   public class TUnstreamizationEsotericPoint extends TUnstreamizer
   {
      
      protected var FConfigValue:TBins;
      
      public function TUnstreamizationEsotericPoint()
      {
         super();
      }
      
      public function UnstreamizationEsotericPoint(param1:TStarPoint, param2:TEsotericPoint) : void
      {
         var _loc3_:TConfigValue = null;
         var _loc4_:int = 0;
         if(this.FConfigValue == null)
         {
            this.FConfigValue = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         }
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,60103012) as TConfigValue;
         _loc4_ = _loc3_.Value as int;
         param2.Coerce(param1.Identifier);
         param2.IsSkill = param1.IsSkill;
         param2.LevelLimit = param1.ServenStarLevelLimit + _loc4_;
         param2.NeedFetch = param1.NeedFetch;
         param2.PointName = param1.Name;
         param2.Target = param1.StarPointAddType.Target;
         param2.Type = param1.StarPointAddType.Type;
         param2.Value = param1.StarPointAddType.Value;
         param2.MapNum = param1.MapId;
         param2.PointIndex = param1.Index;
         param2.Desc = param1.Desc;
      }
   }
}

