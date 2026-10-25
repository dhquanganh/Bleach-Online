package Foundation.Resources.Textures
{
   import Foundation.Common.TEntityList;
   import Foundation.Resources.Common.TResource;
   import Foundation.Resources.Spaces.ResourcesSpace;
   import flash.display.BitmapData;
   
   use namespace ResourcesSpace;
   
   public class TTexture extends TResource
   {
      
      protected static const MAX_REFERENCES:uint = 3;
      
      protected var FAnimationSequences:TEntityList;
      
      protected var FSurface:BitmapData;
      
      protected var FReference:int;
      
      public function TTexture(param1:uint)
      {
         super(param1);
         this.FAnimationSequences = new TEntityList();
      }
      
      ResourcesSpace function Coerce(param1:uint) : void
      {
         FIdentifier = param1;
      }
      
      ResourcesSpace function CoerceProperties(param1:BitmapData) : void
      {
         this.FSurface = param1;
      }
      
      ResourcesSpace function SequenceAppend(param1:TAnimationSequence) : void
      {
         this.FAnimationSequences.Add(param1);
      }
      
      public function get Surface() : BitmapData
      {
         return this.FSurface;
      }
      
      public function get Count() : int
      {
         return this.FAnimationSequences.Count;
      }
      
      public function get Reference() : int
      {
         return this.FReference;
      }
      
      public function set Reference(param1:int) : void
      {
         if(param1 > MAX_REFERENCES)
         {
            param1 = int(MAX_REFERENCES);
         }
         else if(param1 < 0)
         {
            param1 = 0;
         }
         this.FReference = param1;
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TAnimationSequence = null;
         this.FAnimationSequences.Clear();
         this.FReference = 0;
      }
      
      public function GetAnimationSequenceByIndex(param1:int) : TAnimationSequence
      {
         return this.FAnimationSequences.GetEntityByIndex(param1) as TAnimationSequence;
      }
      
      public function GetAnimationSequenceByIdentifier(param1:uint) : TAnimationSequence
      {
         return this.FAnimationSequences.GetEntityByIdentifier(param1) as TAnimationSequence;
      }
   }
}

