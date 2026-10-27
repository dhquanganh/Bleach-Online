package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import Logics.DatebaseVO.VO.Json.TRewards;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TPartnerChange extends TDatebaseVO
   {
      
      protected var FName:String;
      
      protected var FEffect:Vector.<Object>;
      
      protected var FHeroLevel:int;
      
      protected var FRewards:TRewards;
      
      protected var FDesc:String;
      
      public function TPartnerChange()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FName = TUtilityString.FetchUTF(param1);
         this.FEffect = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FHeroLevel = param1.readUnsignedInt();
         this.FRewards = new TRewards(TUtilityString.FetchUTF(param1));
         this.FDesc = TUtilityString.FetchUTF(param1);
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get HeroLevel() : int
      {
         return this.FHeroLevel;
      }
      
      public function get Desc() : String
      {
         return this.FDesc;
      }
      
      public function get Rewards() : TRewards
      {
         return this.FRewards;
      }
      
      public function get Effect() : Vector.<Object>
      {
         return this.FEffect;
      }
   }
}

