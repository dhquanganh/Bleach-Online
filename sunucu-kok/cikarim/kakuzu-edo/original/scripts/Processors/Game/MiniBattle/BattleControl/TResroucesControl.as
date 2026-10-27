package Processors.Game.MiniBattle.BattleControl
{
   import Foundation.Resources.Repositories.TResourceRepositoryTexture;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Resources.Constants.CONST_COMMON;
   
   public class TResroucesControl
   {
      
      public static const TextureLoader:Vector.<TResourceRepositoryTexture> = Vector.<TResourceRepositoryTexture>([SResourcesCore.TexturesModel,SResourcesCore.TexturesSkill]);
      
      protected var FResourceID:Vector.<uint>;
      
      protected var FResourceType:Vector.<int>;
      
      protected var FResourceRoleMoudle:Vector.<uint>;
      
      public function TResroucesControl()
      {
         super();
         this.FResourceID = new Vector.<uint>();
         this.FResourceType = new Vector.<int>();
         this.FResourceRoleMoudle = new Vector.<uint>();
      }
      
      protected function CallBack_ResourceArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:int = 0;
         var _loc5_:TResourceRepositoryTexture = null;
         _loc4_ = this.FResourceID.indexOf(param3);
         if(_loc4_ == -1)
         {
            return;
         }
         _loc5_ = TextureLoader[this.FResourceType[_loc4_]];
         if(param1 == _loc5_)
         {
            this.FResourceID.splice(_loc4_,1);
            this.FResourceType.splice(_loc4_,1);
         }
      }
      
      public function get Count() : int
      {
         return this.FResourceID.length;
      }
      
      public function ResourceRequest(param1:uint, param2:int) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FResourceID.indexOf(param1);
         if(_loc3_ != -1)
         {
            if(this.FResourceType[_loc3_] == param2)
            {
               return;
            }
         }
         this.FResourceID.push(param1);
         this.FResourceType.push(param2);
         TextureLoader[param2].LoadAutoSecondary(param1,this.CallBack_ResourceArrive);
         if(param2 == CONST_COMMON.ResourceType_Model)
         {
            _loc3_ = this.FResourceRoleMoudle.indexOf(param1);
            if(_loc3_ == -1)
            {
               this.FResourceRoleMoudle.push(param1);
            }
         }
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FResourceRoleMoudle.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            SResourcesCore.TexturesModel.DeleteByIdentifier(this.FResourceRoleMoudle[_loc1_],true);
            _loc1_++;
         }
         this.FResourceRoleMoudle.length = 0;
         this.FResourceID.length = 0;
         this.FResourceType.length = 0;
      }
   }
}

