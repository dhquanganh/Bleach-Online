package Logics.Streamization.InteractionLog
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.TPost;
   import Logics.InteractionLog.TInteractionLog;
   import Logics.Spaces.LogicsSpace;
   import Logics.Streamization.Post.TUnstreamizerPost;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.utils.ByteArray;
   
   use namespace LogicsSpace;
   
   public class TUnstreamizerInteractionLog extends TUnstreamizer
   {
      
      protected var FUnstreamizerPost:TUnstreamizerPost;
      
      public function TUnstreamizerInteractionLog()
      {
         super();
         this.FUnstreamizerPost = new TUnstreamizerPost();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TInteractionLog = null;
         var _loc7_:TPost = null;
         var _loc8_:uint = 0;
         _loc6_ = param2 as TInteractionLog;
         _loc8_ = param1.readUnsignedInt();
         _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Post,_loc8_) as TPost;
         this.FUnstreamizerPost.UnstreamizeHtmlByPost(param1,_loc6_,_loc7_);
         _loc4_ = param1.readUnsignedInt();
         _loc5_ = param1.readUnsignedInt();
         _loc6_.Coerce(_loc4_,_loc5_);
         _loc6_.Time = param1.readUnsignedInt();
      }
   }
}

