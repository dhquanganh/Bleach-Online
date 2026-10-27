package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDChrismasRecharge extends THDActivityBase
   {
      
      protected var FDayPayIndex:uint;
      
      protected var FDrawLotteryIndex:uint;
      
      protected var FSnowballIndex:uint;
      
      protected var FChallengeInfo:Vector.<Object>;
      
      protected var FText:String;
      
      public function THDChrismasRecharge()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:Object = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FDayPayIndex = param1.readUnsignedInt();
         this.FDrawLotteryIndex = param1.readUnsignedInt();
         this.FSnowballIndex = param1.readUnsignedInt();
         this.FChallengeInfo = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FText = TUtilityString.FetchUTF(param1);
      }
      
      public function get DayPayIndex() : uint
      {
         return this.FDayPayIndex;
      }
      
      public function get DrawLotteryIndex() : uint
      {
         return this.FDrawLotteryIndex;
      }
      
      public function get SnowballIndex() : uint
      {
         return this.FSnowballIndex;
      }
      
      public function get ChallengeInfo() : Vector.<Object>
      {
         return this.FChallengeInfo;
      }
      
      public function get Text() : String
      {
         return this.FText;
      }
   }
}

