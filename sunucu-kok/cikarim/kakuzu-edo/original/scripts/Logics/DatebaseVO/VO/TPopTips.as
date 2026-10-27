package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TPopTips extends TDatebaseVO
   {
      
      protected var FImage:uint;
      
      protected var FTitle:String;
      
      protected var FTips:String;
      
      protected var FPanel:int;
      
      protected var FOpenButton:String;
      
      protected var FDownLevel:int;
      
      protected var FUpLevel:int;
      
      protected var FGirlPicID:uint;
      
      protected var FSkillPicIDs:Vector.<uint>;
      
      public function TPopTips()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         this.FImage = param1.readUnsignedInt();
         this.FTitle = TUtilityString.FetchUTF(param1);
         this.FTips = TUtilityString.FetchUTF(param1);
         this.FPanel = param1.readUnsignedInt();
         this.FOpenButton = TUtilityString.FetchUTF(param1);
         this.FDownLevel = param1.readUnsignedInt();
         this.FUpLevel = param1.readUnsignedInt();
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_) as Array;
         _loc3_ = int(_loc4_.length);
         this.FSkillPicIDs = new Vector.<uint>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FSkillPicIDs[_loc2_] = _loc4_[_loc2_];
            _loc2_++;
         }
         this.FGirlPicID = param1.readUnsignedInt();
      }
      
      public function get Image() : uint
      {
         return this.FImage;
      }
      
      public function get Title() : String
      {
         return this.FTitle;
      }
      
      public function get Tips() : String
      {
         return this.FTips;
      }
      
      public function get Panel() : int
      {
         return this.FPanel;
      }
      
      public function get OpenButton() : String
      {
         return this.FOpenButton;
      }
      
      public function get DownLevel() : int
      {
         return this.FDownLevel;
      }
      
      public function get UpLevel() : int
      {
         return this.FUpLevel;
      }
      
      public function get GirlPicID() : uint
      {
         return this.FGirlPicID;
      }
      
      public function get SkillPicIDs() : Vector.<uint>
      {
         return this.FSkillPicIDs;
      }
   }
}

