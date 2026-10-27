package Logics.HDActivityOS
{
   public class TActivityOSPetSoulDefence extends TActivityOSBase
   {
      
      protected static const MAX_COUNT:uint = 7;
      
      protected var FInfos:Vector.<THDDailyActivityInfo>;
      
      public function TActivityOSPetSoulDefence()
      {
         super();
         this.FInfos = new Vector.<THDDailyActivityInfo>(MAX_COUNT);
      }
      
      public function get Infos() : Vector.<THDDailyActivityInfo>
      {
         return this.FInfos;
      }
      
      public function set Infos(param1:Vector.<THDDailyActivityInfo>) : void
      {
         this.FInfos = param1;
      }
      
      public function Add(param1:THDDailyActivityInfo) : void
      {
         this.FInfos.push(param1);
      }
   }
}

