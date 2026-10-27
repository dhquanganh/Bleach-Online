package Logics.HeroChange
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Logics.Characters.THero;
   import Logics.DatebaseVO.VO.TChangeHeroPoint;
   import Logics.DatebaseVO.VO.THeroChangeAttr;
   import Logics.DatebaseVO.VO.TPartnerChange;
   import Resources.Constants.CONST_DATEBASEVO;
   
   public class THeroChange
   {
      
      protected var FHero:THero;
      
      protected var FHeroChangeAttr:THeroChangeAttr;
      
      protected var FPartnerChanges:Vector.<TPartnerChange>;
      
      protected var FChangeHeroPoints:Vector.<TChangeHeroPoint>;
      
      protected var FAdvanceChanges:TBins;
      
      protected var FHeroChipNum:int;
      
      protected var FCurrentDieTime:int;
      
      protected var FCurrentResetTime:int;
      
      protected var FCurrentMonsterNum:int;
      
      protected var FCurrentReliveTime:int;
      
      protected var FHighestRecord:int;
      
      public function THeroChange()
      {
         super();
         this.FPartnerChanges = new Vector.<TPartnerChange>();
         this.FChangeHeroPoints = new Vector.<TChangeHeroPoint>();
      }
      
      public function get Hero() : THero
      {
         return this.FHero;
      }
      
      public function set Hero(param1:THero) : void
      {
         this.FHero = param1;
      }
      
      public function get PartnerChanges() : Vector.<TPartnerChange>
      {
         return this.FPartnerChanges;
      }
      
      public function get HeroChangeAttr() : THeroChangeAttr
      {
         return this.FHeroChangeAttr;
      }
      
      public function set HeroChangeAttr(param1:THeroChangeAttr) : void
      {
         this.FHeroChangeAttr = param1;
      }
      
      public function get HeroChipNum() : int
      {
         return this.FHeroChipNum;
      }
      
      public function set HeroChipNum(param1:int) : void
      {
         this.FHeroChipNum = param1;
      }
      
      public function get CurrentDieTime() : int
      {
         return this.FCurrentDieTime;
      }
      
      public function set CurrentDieTime(param1:int) : void
      {
         this.FCurrentDieTime = param1;
      }
      
      public function get CurrentResetTime() : int
      {
         return this.FCurrentResetTime;
      }
      
      public function set CurrentResetTime(param1:int) : void
      {
         this.FCurrentResetTime = param1;
      }
      
      public function get CurrentMonsterNum() : int
      {
         return this.FCurrentMonsterNum;
      }
      
      public function set CurrentMonsterNum(param1:int) : void
      {
         this.FCurrentMonsterNum = param1;
      }
      
      public function get CurrentReliveTime() : int
      {
         return this.FCurrentReliveTime;
      }
      
      public function set CurrentReliveTime(param1:int) : void
      {
         this.FCurrentReliveTime = param1;
      }
      
      public function get HighestRecord() : int
      {
         return this.FHighestRecord;
      }
      
      public function set HighestRecord(param1:int) : void
      {
         this.FHighestRecord = param1;
      }
      
      public function get ChangeHeroPoints() : Vector.<TChangeHeroPoint>
      {
         return this.FChangeHeroPoints;
      }
      
      public function get AdvanceChanges() : TBins
      {
         return SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_AdvanceChange);
      }
   }
}

