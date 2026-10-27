package Processors.Game.Lobby.Pet.PetHouse.Components
{
   import Logics.Pet.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.text.*;
   
   public class TUIPetInfo
   {
      
      protected static const CAPACITY_BaseAttribute:uint = CONST_PET.CAPACITY_BaseAttribute;
      
      protected static const CAPACITY_PvpAttribute:uint = CONST_PET.CAPACITY_PvpAttribute;
      
      protected var FMC_BaseAttributes:Vector.<MovieClip>;
      
      protected var FTF_BaseAttributes:Vector.<TextField>;
      
      protected var FInitialization:Boolean;
      
      protected var FResource:Sprite;
      
      public function TUIPetInfo()
      {
         super();
      }
      
      protected function Initialization() : void
      {
         var _loc1_:int = 0;
         this.FMC_BaseAttributes = new Vector.<MovieClip>(CAPACITY_BaseAttribute);
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_BaseAttribute)
         {
            this.FMC_BaseAttributes[_loc1_] = this.FResource[CONST_PET.RESOURCE_Link_MC_BaseAttribute + _loc1_];
            _loc1_++;
         }
         this.FTF_BaseAttributes = new Vector.<TextField>(CAPACITY_PvpAttribute);
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_PvpAttribute)
         {
            this.FTF_BaseAttributes[_loc1_] = this.FResource[CONST_PET.RESOURCE_Link_TF_BaseAttribute + _loc1_];
            _loc1_++;
         }
         this.Reset();
         this.FInitialization = true;
      }
      
      public function get Resource() : Sprite
      {
         return this.FResource;
      }
      
      public function set Resource(param1:Sprite) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1 != this.FResource)
         {
            this.FResource = param1;
         }
         if(!this.FInitialization)
         {
            this.Initialization();
         }
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_BaseAttribute)
         {
            this.FMC_BaseAttributes[_loc1_].gotoAndStop(1);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_PvpAttribute)
         {
            this.FTF_BaseAttributes[_loc1_].text = "";
            _loc1_++;
         }
      }
      
      public function RenderUI(param1:Function, param2:Function) : void
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < CAPACITY_BaseAttribute)
         {
            this.FMC_BaseAttributes[_loc3_].gotoAndStop(param1(_loc3_) + 1);
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < CAPACITY_PvpAttribute)
         {
            this.FTF_BaseAttributes[_loc3_].text = param2(_loc3_);
            _loc3_++;
         }
      }
   }
}

