package Processors.Game.Lobby.Common.Map.HeadDecoration
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudleInMapCanRunPlayer;
   import Resources.Constants.CONST_CONFIGVALUE;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.display.Bitmap;
   
   public class TDecorationBleachAgentIcon extends TDecoration
   {
      
      protected var FBitMap:Bitmap;
      
      protected var FID:int;
      
      public function TDecorationBleachAgentIcon()
      {
         super();
         this.FBitMap = new Bitmap();
         addChild(this.FBitMap);
         this.FID = -1;
      }
      
      protected function CallBack_TextureArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         this.FBitMap.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
      }
      
      override public function get Position() : int
      {
         return POSITION_TOP;
      }
      
      protected function get ID() : int
      {
         var _loc1_:TBins = null;
         var _loc2_:TConfigValue = null;
         if(this.FID == -1)
         {
            _loc1_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
            _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.BleachAgent_IconID) as TConfigValue;
            this.FID = int(_loc2_.Value);
         }
         return this.FID;
      }
      
      override public function Update(param1:Object) : void
      {
         var _loc2_:TSceneSpriteMoudleInMapCanRunPlayer = null;
         _loc2_ = param1 as TSceneSpriteMoudleInMapCanRunPlayer;
         this.FBitMap.bitmapData = null;
         if(_loc2_.OpenBleachAgent)
         {
            SResourcesCore.TexturesLobby.LoadAutoSecondary(this.ID,this.CallBack_TextureArrive);
         }
      }
   }
}

