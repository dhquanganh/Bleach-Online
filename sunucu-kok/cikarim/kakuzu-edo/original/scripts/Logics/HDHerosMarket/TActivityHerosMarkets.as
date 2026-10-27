package Logics.HDHerosMarket
{
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class TActivityHerosMarkets extends TActivityOSBase
   {
      
      protected var FHeroExpStatus:uint;
      
      protected var FKnifeExpStatus:uint;
      
      protected var FHerosHotStatus:Vector.<int>;
      
      protected var FHerosAchieveStatus:Vector.<int>;
      
      protected var FKnifesHotStatus:Vector.<int>;
      
      protected var FKnifesAchieveStatus:Vector.<int>;
      
      public function TActivityHerosMarkets()
      {
         super();
      }
      
      public function get HeroExpStatus() : uint
      {
         return this.FHeroExpStatus;
      }
      
      public function set HeroExpStatus(param1:uint) : void
      {
         this.FHeroExpStatus = param1;
      }
      
      public function get KnifeExpStatus() : uint
      {
         return this.FKnifeExpStatus;
      }
      
      public function set KnifeExpStatus(param1:uint) : void
      {
         this.FKnifeExpStatus = param1;
      }
      
      public function get HerosHotStatus() : Vector.<int>
      {
         return this.FHerosHotStatus;
      }
      
      public function set HerosHotStatus(param1:Vector.<int>) : void
      {
         this.FHerosHotStatus = param1;
      }
      
      public function get HerosAchieveStatus() : Vector.<int>
      {
         return this.FHerosAchieveStatus;
      }
      
      public function set HerosAchieveStatus(param1:Vector.<int>) : void
      {
         this.FHerosAchieveStatus = param1;
      }
      
      public function get KnifesHotStatus() : Vector.<int>
      {
         return this.FKnifesHotStatus;
      }
      
      public function set KnifesHotStatus(param1:Vector.<int>) : void
      {
         this.FKnifesHotStatus = param1;
      }
      
      public function get KnifesAchieveStatus() : Vector.<int>
      {
         return this.FKnifesAchieveStatus;
      }
      
      public function set KnifesAchieveStatus(param1:Vector.<int>) : void
      {
         this.FKnifesAchieveStatus = param1;
      }
   }
}

