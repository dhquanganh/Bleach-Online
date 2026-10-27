package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDNewYear2016Check extends THDActivityBase
   {
      
      protected var FPreferentialGifts:Vector.<Object>;
      
      protected var FSignIn:Object;
      
      protected var FOffSet:uint;
      
      protected var FSignInGifts:Vector.<Object>;
      
      public function THDNewYear2016Check()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FPreferentialGifts = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FSignIn = Json.decode(TUtilityString.FetchUTF(param1));
         this.FOffSet = param1.readUnsignedInt();
         this.FSignInGifts = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
      }
      
      public function get PreferentialGifts() : Vector.<Object>
      {
         return this.FPreferentialGifts;
      }
      
      public function get SignIn() : Object
      {
         return this.FSignIn;
      }
      
      public function get OffSet() : uint
      {
         return this.FOffSet;
      }
      
      public function get SignInGifts() : Vector.<Object>
      {
         return this.FSignInGifts;
      }
   }
}

