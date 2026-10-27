package Logics.ProfessionRefine
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.DatebaseVO.VO.TProfessionRefineAVO;
   import Resources.Constants.CONST_CONFIGVALUE;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_ProfessionRefine;
   
   public class TProfessionRefineList
   {
      
      protected var FProfessionRefineVec:Vector.<TProfessionRefine>;
      
      protected var FProfessionRefineBin:TBins;
      
      protected var FProductVec:Vector.<int>;
      
      protected var FCostVec:Vector.<int>;
      
      public function TProfessionRefineList()
      {
         super();
      }
      
      protected function GetProfessionRefineAVOById(param1:int) : TProfessionRefineAVO
      {
         return this.ProfessionRefineBin.GetDatebaseByIdentifier(param1) as TProfessionRefineAVO;
      }
      
      public function get ProfessionRefineVec() : Vector.<TProfessionRefine>
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TProfessionRefine = null;
         var _loc4_:TProfessionRefineAVO = null;
         if(this.FProfessionRefineVec == null)
         {
            _loc2_ = CONST_ProfessionRefine.ProfessionNum;
            this.FProfessionRefineVec = new Vector.<TProfessionRefine>(_loc2_);
            _loc4_ = this.ProfessionRefineBin.GetDatebaseByIndex(this.ProfessionRefineBin.Count - 1) as TProfessionRefineAVO;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc3_ = new TProfessionRefine();
               _loc3_.HeroType = _loc1_ + 1;
               _loc3_.CurLevel = 0;
               _loc3_.FuncGetAVO = this.GetProfessionRefineAVOById;
               _loc3_.MaxLevel = _loc4_.Identifier;
               this.FProfessionRefineVec[_loc1_] = _loc3_;
               _loc1_++;
            }
         }
         return this.FProfessionRefineVec;
      }
      
      public function get ProfessionRefineBin() : TBins
      {
         if(this.FProfessionRefineBin == null)
         {
            this.FProfessionRefineBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ProfessionRefine);
         }
         return this.FProfessionRefineBin;
      }
      
      public function get ProductVec() : Vector.<int>
      {
         var _loc1_:TConfigValue = null;
         if(this.FProductVec == null)
         {
            _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Professionrefine_Product) as TConfigValue;
            this.FProductVec = Vector.<int>(_loc1_.Value);
         }
         return this.FProductVec;
      }
      
      public function get CostVec() : Vector.<int>
      {
         var _loc1_:TConfigValue = null;
         if(this.FCostVec == null)
         {
            _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Professionrefine_Cost) as TConfigValue;
            this.FCostVec = Vector.<int>(_loc1_.Value);
         }
         return this.FCostVec;
      }
      
      public function GetProfessionRefineById(param1:int) : TProfessionRefine
      {
         if(param1 <= 0 || param1 > this.ProfessionRefineVec.length)
         {
            return null;
         }
         return this.ProfessionRefineVec[param1 - 1];
      }
   }
}

