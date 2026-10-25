package Logics.Rooms.Seat.Player.Hero
{
   import Foundation.Common.TEntity;
   
   public class THero extends TEntity
   {
      
      protected var FPosition:uint;
      
      protected var FName:String;
      
      protected var FHeadIconID:uint;
      
      protected var FCrashJadeOpenLevel:uint;
      
      public function THero(param1:uint)
      {
         super(param1);
         this.FName = "";
      }
      
      public function get Position() : uint
      {
         return this.FPosition;
      }
      
      public function set Position(param1:uint) : void
      {
         this.FPosition = param1;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get HeadIconID() : uint
      {
         return this.FHeadIconID;
      }
      
      public function set HeadIconID(param1:uint) : void
      {
         this.FHeadIconID = param1;
      }
      
      public function get CrashJadeOpenLevel() : uint
      {
         return this.FCrashJadeOpenLevel;
      }
      
      public function set CrashJadeOpenLevel(param1:uint) : void
      {
         this.FCrashJadeOpenLevel = param1;
      }
   }
}

