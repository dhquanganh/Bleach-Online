package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDRushInSeireitei extends THDActivityBase
   {
      
      protected var FGiftIndexVec:Vector.<int>;
      
      protected var FAwardIdsVec:Vector.<Vector.<int>>;
      
      protected var FBossHpVec:Vector.<int>;
      
      protected var FPicVec:Vector.<int>;
      
      protected var FAttackIndexVec:Vector.<int>;
      
      protected var FNomalMilitary:int;
      
      protected var FNomalHurt:int;
      
      protected var FSpecialMilitary:int;
      
      protected var FSpecialHurt:int;
      
      protected var FMilitaryVec:Vector.<int>;
      
      protected var FHurtVec:Vector.<int>;
      
      protected var FRefreshIndex:int;
      
      protected var FAttackIndex:int;
      
      protected var FShopIndexVec:Vector.<int>;
      
      protected var FShopAwardIdVec:Vector.<int>;
      
      protected var FShopScoreVec:Vector.<int>;
      
      protected var FScoreIndex:int;
      
      protected var FTotalScoreIndex:int;
      
      protected var FRankNum:int;
      
      protected var FStrVec:Vector.<String>;
      
      protected var FRankKeyVec:Vector.<int>;
      
      protected var FRankAwardVec:Vector.<int>;
      
      protected var FRankTitleVec:Vector.<int>;
      
      protected var FRankPromptVec:Vector.<String>;
      
      protected var FPetId:int;
      
      public function THDRushInSeireitei()
      {
         super();
         this.FGiftIndexVec = new Vector.<int>();
         this.FAwardIdsVec = new Vector.<Vector.<int>>();
         this.FBossHpVec = new Vector.<int>();
         this.FPicVec = new Vector.<int>();
         this.FShopIndexVec = new Vector.<int>();
         this.FShopAwardIdVec = new Vector.<int>();
         this.FShopScoreVec = new Vector.<int>();
         this.FStrVec = new Vector.<String>();
         this.FRankKeyVec = new Vector.<int>();
         this.FRankAwardVec = new Vector.<int>();
         this.FRankTitleVec = new Vector.<int>();
         this.FRankPromptVec = new Vector.<String>();
         this.FAttackIndexVec = new Vector.<int>();
         this.FMilitaryVec = new Vector.<int>();
         this.FHurtVec = new Vector.<int>();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = _loc4_[_loc2_];
            this.FGiftIndexVec.push(_loc6_.index);
            this.FBossHpVec.push(_loc6_.hp);
            this.FAwardIdsVec.push(Vector.<int>(_loc6_.awardIds));
            this.FPicVec.push(_loc6_.pic);
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FAttackIndexVec.push(_loc6_.index);
         this.FNomalMilitary = _loc6_.military;
         this.FNomalHurt = _loc6_.hurt;
         this.FAttackIndexVec.push(param1.readUnsignedInt());
         this.FMilitaryVec.push(this.FNomalMilitary);
         this.FMilitaryVec.push(this.FNomalMilitary * 10);
         this.FHurtVec.push(this.FNomalHurt);
         this.FHurtVec.push(this.FNomalHurt * 10);
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FAttackIndexVec.push(_loc6_.index);
         this.FSpecialMilitary = _loc6_.military;
         this.FSpecialHurt = _loc6_.hurt;
         this.FAttackIndexVec.push(param1.readUnsignedInt());
         this.FMilitaryVec.push(this.FSpecialMilitary);
         this.FMilitaryVec.push(this.FSpecialMilitary * 10);
         this.FHurtVec.push(this.FSpecialHurt);
         this.FHurtVec.push(this.FSpecialHurt * 10);
         this.FRefreshIndex = param1.readUnsignedInt();
         this.FAttackIndex = param1.readUnsignedInt();
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = _loc4_[_loc2_];
            this.FShopIndexVec.push(_loc6_.index);
            this.FShopAwardIdVec.push(_loc6_.awardId);
            this.FShopScoreVec.push(_loc6_.score);
            _loc2_++;
         }
         this.FScoreIndex = param1.readUnsignedInt();
         this.FTotalScoreIndex = param1.readUnsignedInt();
         this.FRankNum = param1.readUnsignedInt();
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = _loc4_[_loc2_];
            this.FRankKeyVec.push(_loc6_.key);
            this.FRankAwardVec.push(_loc6_.value);
            this.FRankTitleVec.push(_loc6_.title);
            this.FRankPromptVec.push(_loc6_.prompt);
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FPetId = _loc6_.showID;
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FStrVec.push(_loc4_[_loc2_]);
            _loc2_++;
         }
      }
      
      public function get GiftIndexVec() : Vector.<int>
      {
         return this.FGiftIndexVec;
      }
      
      public function get AwardIdsVec() : Vector.<Vector.<int>>
      {
         return this.FAwardIdsVec;
      }
      
      public function get BossHpVec() : Vector.<int>
      {
         return this.FBossHpVec;
      }
      
      public function get NomalMilitary() : int
      {
         return this.FNomalMilitary;
      }
      
      public function get NomalHurt() : int
      {
         return this.FNomalHurt;
      }
      
      public function get SpecialMilitary() : int
      {
         return this.FSpecialMilitary;
      }
      
      public function get SpecialHurt() : int
      {
         return this.FSpecialHurt;
      }
      
      public function get RefreshIndex() : int
      {
         return this.FRefreshIndex;
      }
      
      public function get AttackIndex() : int
      {
         return this.FAttackIndex;
      }
      
      public function get ShopIndexVec() : Vector.<int>
      {
         return this.FShopIndexVec;
      }
      
      public function get ShopAwardIdVec() : Vector.<int>
      {
         return this.FShopAwardIdVec;
      }
      
      public function get ShopScoreVec() : Vector.<int>
      {
         return this.FShopScoreVec;
      }
      
      public function get ScoreIndex() : int
      {
         return this.FScoreIndex;
      }
      
      public function get TotalScoreIndex() : int
      {
         return this.FTotalScoreIndex;
      }
      
      public function get RankNum() : int
      {
         return this.FRankNum;
      }
      
      public function get RankKeyVec() : Vector.<int>
      {
         return this.FRankKeyVec;
      }
      
      public function get RankAwardVec() : Vector.<int>
      {
         return this.FRankAwardVec;
      }
      
      public function get RankTitleVec() : Vector.<int>
      {
         return this.FRankTitleVec;
      }
      
      public function get RankPromptVec() : Vector.<String>
      {
         return this.FRankPromptVec;
      }
      
      public function get StrVec() : Vector.<String>
      {
         return this.FStrVec;
      }
      
      public function get AttackIndexVec() : Vector.<int>
      {
         return this.FAttackIndexVec;
      }
      
      public function get PicVec() : Vector.<int>
      {
         return this.FPicVec;
      }
      
      public function get MilitaryVec() : Vector.<int>
      {
         return this.FMilitaryVec;
      }
      
      public function get HurtVec() : Vector.<int>
      {
         return this.FHurtVec;
      }
      
      public function get PetId() : int
      {
         return this.FPetId;
      }
      
      public function set PetId(param1:int) : void
      {
         this.FPetId = param1;
      }
   }
}

