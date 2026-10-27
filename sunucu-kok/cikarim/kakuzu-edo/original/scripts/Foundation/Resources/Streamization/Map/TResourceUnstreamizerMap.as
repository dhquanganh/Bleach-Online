package Foundation.Resources.Streamization.Map
{
   import Foundation.Resources.Maps.TMaps;
   import Foundation.Resources.Streamization.TResourceUnstreamizer;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   
   public class TResourceUnstreamizerMap extends TResourceUnstreamizer
   {
      
      public function TResourceUnstreamizerMap()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_Traversal(param1,param2,param3);
      }
      
      protected function UnstreamizationPerform_Traversal(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:TMaps = null;
         var _loc6_:String = null;
         _loc5_ = param2 as TMaps;
         _loc4_ = _loc5_.Identifier;
         param1.uncompress();
         param1.readUnsignedInt();
         _loc5_.Name = TUtilityString.FetchUTF(param1);
         _loc5_.Mode = param1.readUnsignedByte();
         _loc5_.Type = param1.readUnsignedByte();
         _loc5_.Width = param1.readUnsignedInt();
         _loc5_.Height = param1.readUnsignedInt();
         _loc5_.CellWidth = param1.readUnsignedShort();
         _loc5_.CellHeight = param1.readUnsignedShort();
         _loc5_.PreRows = param1.readUnsignedByte();
         _loc5_.PreColumns = param1.readUnsignedByte();
         _loc5_.TileWidth = param1.readUnsignedShort();
         _loc5_.TileHeight = param1.readUnsignedShort();
         _loc5_.Rows = param1.readUnsignedShort();
         _loc5_.Columns = param1.readUnsignedShort();
         _loc5_.StartPointX = param1.readUnsignedInt();
         _loc5_.StartPointY = param1.readUnsignedInt();
         _loc6_ = TUtilityString.FetchUTF(param1);
         _loc5_.MapData = _loc6_.split(",");
         ResourceNotifyUnstreamized(_loc5_);
      }
   }
}

