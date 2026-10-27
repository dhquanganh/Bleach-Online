package Logics.Map
{
   public class TMoudleInfor
   {
      
      protected var FTextureID:uint;
      
      protected var FScalx:int;
      
      public function TMoudleInfor()
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
      
      public function get Scalx() : int
      {
         return this.FScalx;
      }
      
      public function set Scalx(param1:int) : void
      {
         this.FScalx = param1;
      }
   }
}

