package Logics.Streamization.Mentorship
{
   import Foundation.Streamization.TUnstreamizer;
   import Foundation.Utilities.TUtilityString;
   import Logics.Mentorship.Elements.TDisciple;
   import Logics.Mentorship.TMentorship;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerMentorship extends TUnstreamizer
   {
      
      protected var FUnstreamizerDisciple:TUnstreamizerDisciple;
      
      public function TUnstreamizerMentorship()
      {
         super();
         this.FUnstreamizerDisciple = new TUnstreamizerDisciple();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:TMentorship = null;
         var _loc7_:TDisciple = null;
         _loc6_ = param2 as TMentorship;
         _loc5_ = _loc6_.DiscipleList.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_.DiscipleList.pop();
            _loc4_++;
         }
         _loc6_.Identity = param1.readUnsignedByte();
         _loc6_.TodayArrestCount = param1.readUnsignedInt();
         _loc6_.TodayRescueCount = param1.readUnsignedInt();
         _loc6_.TodayGetExp = param1.readUnsignedInt();
         _loc6_.TodayInteractionCount = param1.readUnsignedInt();
         _loc6_.TodaySOSCount = param1.readUnsignedInt();
         _loc6_.TodayResistCount = param1.readUnsignedInt();
         _loc6_.MasterID0 = param1.readUnsignedInt();
         _loc6_.MasterID1 = param1.readUnsignedInt();
         _loc6_.MasterName = TUtilityString.FetchUTF(param1);
         _loc6_.MasterLevel = param1.readUnsignedInt();
         _loc6_.MasterHeroID = param1.readUnsignedInt();
         _loc6_.MasterGuildName = TUtilityString.FetchUTF(param1);
         _loc6_.InteractionCDTime = param1.readUnsignedInt();
         _loc5_ = uint(param1.readShort());
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_ = new TDisciple();
            this.FUnstreamizerDisciple.Unstreamize(param1,_loc7_,null);
            _loc6_.DiscipleList[_loc4_] = _loc7_;
            _loc4_++;
         }
      }
   }
}

