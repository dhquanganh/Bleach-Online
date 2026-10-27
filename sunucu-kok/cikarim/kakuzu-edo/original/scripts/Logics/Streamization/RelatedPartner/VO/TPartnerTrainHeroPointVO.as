package Logics.Streamization.RelatedPartner.VO
{
   import Resources.Constants.CONST_RELATEDPARTNER;
   
   public class TPartnerTrainHeroPointVO
   {
      
      public var HeroId:int;
      
      public var FreeCount:int;
      
      public var GoldCount:int;
      
      public var StarRewardStatus:int;
      
      public var SkillId:int;
      
      protected var FStars:Vector.<int>;
      
      protected var FPveIds:Vector.<int>;
      
      protected var FStarCount:int;
      
      public function TPartnerTrainHeroPointVO()
      {
         super();
         this.FStars = new Vector.<int>(CONST_RELATEDPARTNER.PartnerTrain_Point_Num);
         this.FPveIds = new Vector.<int>(CONST_RELATEDPARTNER.PartnerTrain_Point_Num);
      }
      
      public function get Stars() : Vector.<int>
      {
         return this.FStars;
      }
      
      public function get PveIds() : Vector.<int>
      {
         return this.FPveIds;
      }
      
      public function GetStarCount() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FStarCount = 0;
         _loc2_ = int(this.FStars.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FStarCount += this.FStars[_loc1_];
            _loc1_++;
         }
         return this.FStarCount;
      }
      
      public function SetPointData(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FPveIds.indexOf(param1);
         if(_loc3_ != -1)
         {
            this.FStars[_loc3_] = param2;
         }
      }
      
      public function Reset() : void
      {
         this.FStars.length = 0;
         this.FPveIds.length = 0;
      }
   }
}

