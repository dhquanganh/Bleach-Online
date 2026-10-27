package Processors.Game.Lobby.HerosNew.Component
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.Characters.THero;
   import Logics.Pet.TPetBase;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_PET;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class THeroPetInfor extends TProcessorLobbyWindow
   {
      
      protected static const NoMainPet:String = "没有装备主宠";
      
      protected var NoSubPet:String = "没有装备副宠";
      
      protected var FMainUI:Sprite;
      
      protected var FMainPet:TPetBase;
      
      protected var FMainPetName:TextField;
      
      protected var FMainPetLevel:TextField;
      
      protected var FMainPetAttributeValues:Vector.<TextField>;
      
      protected var FMainPetIconMountPoint:Bitmap;
      
      protected var FSubPet:TPetBase;
      
      protected var FSubPetName:TextField;
      
      protected var FSubPetLevel:TextField;
      
      protected var FSubPetAttributeValues:Vector.<TextField>;
      
      protected var FSubPetIconMountPoint:Bitmap;
      
      protected var FSubPetBigIconMountPoint:Bitmap;
      
      protected var FSubPetPreViewMountPoint:Bitmap;
      
      protected var FHero:THero;
      
      public function THeroPetInfor(param1:TUIComponent)
      {
         super(param1);
      }
      
      public function UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("SP_MainSubPetTips") as Sprite;
         addChild(this.FMainUI);
         this.NoSubPet = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_61);
         this.FMainPetName = this.FMainUI["MainPetInforPanle"]["TF_Name"];
         this.FMainPetLevel = this.FMainUI["MainPetInforPanle"]["TF_Level"];
         this.FMainPetIconMountPoint = new Bitmap();
         this.FMainUI["MainPetInforPanle"]["MC_Icon"]["SP_Bmp_Icon"].addChild(this.FMainPetIconMountPoint);
         this.FMainPetAttributeValues = new Vector.<TextField>();
         _loc1_ = 0;
         while(_loc1_ < CONST_PET.CAPACITY_PVPATTRIBUTE)
         {
            this.FMainPetAttributeValues.push(this.FMainUI["MainPetInforPanle"]["TF_BaseAttribute_" + _loc1_]);
            _loc1_++;
         }
         this.FSubPetName = this.FMainUI["SubPetInforPanle"]["TF_Name"];
         this.FSubPetLevel = this.FMainUI["SubPetInforPanle"]["TF_Level"];
         this.FSubPetIconMountPoint = new Bitmap();
         this.FMainUI["SubPetInforPanle"]["MC_Icon"]["SP_Bmp_Icon"].addChild(this.FSubPetIconMountPoint);
         this.FSubPetAttributeValues = new Vector.<TextField>();
         _loc1_ = 0;
         while(_loc1_ < CONST_PET.CAPACITY_PVPATTRIBUTE)
         {
            this.FSubPetAttributeValues.push(this.FMainUI["SubPetInforPanle"]["TF_BaseAttribute_" + _loc1_]);
            _loc1_++;
         }
         this.FSubPetBigIconMountPoint = new Bitmap();
         this.FMainUI["LargerIcon"].addChild(this.FSubPetBigIconMountPoint);
      }
      
      protected function InitPetInfor() : void
      {
         this.FMainPet = null;
         this.FSubPet = null;
         if(SLogicsCore.Character.MainHero.MainPetID != 0)
         {
            this.FMainPet = SLogicsCore.PetData.OwnMainPets.GetPetByIdentifier(SLogicsCore.Character.MainHero.MainPetID,0);
         }
         if(this.FHero.VicePetHighID != 0 || this.FHero.VicePetLowID != 0)
         {
            this.FSubPet = SLogicsCore.PetData.OwnVicePets.GetPetByIdentifier(this.FHero.VicePetHighID,this.FHero.VicePetLowID);
         }
      }
      
      protected function RenderMainPet() : void
      {
         this.RenderName(this.FMainPet,this.FMainPetName,NoMainPet);
         this.RenderLevel(this.FMainPet,this.FMainPetLevel);
         this.RenderAttribute(this.FMainPet,this.FMainPetAttributeValues);
         this.RenderMainPetIcon(this.FMainPet);
      }
      
      protected function RenderSubPet() : void
      {
         this.RenderName(this.FSubPet,this.FSubPetName,this.NoSubPet);
         this.RenderLevel(this.FSubPet,this.FSubPetLevel);
         this.RenderAttribute(this.FSubPet,this.FSubPetAttributeValues);
         this.RenderSubPetIcon(this.FSubPet);
         this.RenderSubPetBigIcon(this.FSubPet);
      }
      
      protected function RenderName(param1:TPetBase, param2:TextField, param3:String) : void
      {
         if(param1 == null)
         {
            param2.text = param3;
         }
         else
         {
            param2.text = param1.Name;
         }
      }
      
      protected function RenderLevel(param1:TPetBase, param2:TextField) : void
      {
         if(param1 == null)
         {
            param2.text = "";
         }
         else
         {
            param2.text = "LV." + param1.Level.toString();
         }
      }
      
      protected function RenderAttribute(param1:TPetBase, param2:Vector.<TextField>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param1 == null)
         {
            _loc4_ = CONST_PET.CAPACITY_PVPATTRIBUTE;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               param2[_loc3_].text = "";
               _loc3_++;
            }
         }
         else
         {
            _loc4_ = param1.PvPAttributesCount;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               param2[_loc3_].text = param1.GetPvPAttributeByIndex(_loc3_).toString();
               _loc3_++;
            }
         }
      }
      
      protected function RenderMainPetIcon(param1:TPetBase) : void
      {
         this.FMainPetIconMountPoint.bitmapData = null;
         if(param1 == null)
         {
            return;
         }
         SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(param1.HeadIconID,this.MainPetIconArrive);
      }
      
      protected function RenderSubPetIcon(param1:TPetBase) : void
      {
         this.FSubPetIconMountPoint.bitmapData = null;
         if(param1 == null)
         {
            return;
         }
         SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(param1.HeadIconID,this.SubPetIconArrive);
      }
      
      protected function MainPetIconArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         if(this.FMainPet != null && this.FMainPet.HeadIconID == param3)
         {
            this.FMainPetIconMountPoint.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
         }
      }
      
      protected function SubPetIconArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         if(this.FSubPet != null && this.FSubPet.HeadIconID == param3)
         {
            this.FSubPetIconMountPoint.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
         }
      }
      
      protected function RenderSubPetBigIcon(param1:TPetBase) : void
      {
         this.FSubPetBigIconMountPoint.bitmapData = null;
         if(param1 == null)
         {
            return;
         }
         SResourcesCore.TexturesLargeIcon.LoadAutoSecondary(param1.LargeIconID,this.SubPetBigIconArrive);
      }
      
      protected function SubPetBigIconArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         if(this.FSubPet != null && this.FSubPet.LargeIconID == param3)
         {
            this.FSubPetBigIconMountPoint.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
            this.FSubPetBigIconMountPoint.x = -(this.FSubPetBigIconMountPoint.bitmapData.width / 2);
            this.FSubPetBigIconMountPoint.y = -this.FSubPetBigIconMountPoint.bitmapData.height;
         }
      }
      
      protected function UpdatePosition_Perform() : void
      {
         if(FUICore.MouseCoordinate.X > CONST_COMMON.STAGE_Width - width)
         {
            x = Math.max(FUICore.MouseCoordinate.X - width - 40,0);
         }
         else
         {
            x = Math.min(FUICore.MouseCoordinate.X + 40,CONST_COMMON.STAGE_Width - width);
         }
         if(FUICore.MouseCoordinate.Y > CONST_COMMON.STAGE_Height - height)
         {
            y = Math.max(FUICore.MouseCoordinate.Y - height,0);
         }
         else
         {
            y = Math.min(FUICore.MouseCoordinate.Y,CONST_COMMON.STAGE_Height - height);
         }
      }
      
      public function set Hero(param1:THero) : void
      {
         this.FHero = param1;
         this.InitPetInfor();
         this.RenderMainPet();
         this.RenderSubPet();
      }
      
      public function Update() : void
      {
         this.UpdatePosition_Perform();
      }
      
      public function Reset() : void
      {
         this.FHero = null;
         this.FMainPet = null;
         this.FSubPet = null;
      }
   }
}

