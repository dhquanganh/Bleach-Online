package Logics.GirlGame
{
   public class TGirlTextureInfor
   {
      
      protected var FTextureID:uint;
      
      protected var FSequnceIndex:uint;
      
      public function TGirlTextureInfor()
      {
         super();
      }
      
      public function get TextureID() : uint
      {
         return this.FTextureID;
      }
      
      public function set TextureID(param1:uint) : void
      {
         this.FTextureID = param1;
      }
      
      public function get SequnceIndex() : uint
      {
         return this.FSequnceIndex;
      }
      
      public function set SequnceIndex(param1:uint) : void
      {
         this.FSequnceIndex = param1;
      }
      
      public function Reset() : void
      {
         this.FTextureID = 0;
         this.FSequnceIndex = 0;
      }
   }
}

