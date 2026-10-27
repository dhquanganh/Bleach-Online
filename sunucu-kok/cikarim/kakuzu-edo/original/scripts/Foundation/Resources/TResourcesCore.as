package Foundation.Resources
{
   import Foundation.Resources.Common.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Utilities.TUtilityString;
   import Logics.Agent.SParametersCore;
   
   public class TResourcesCore
   {
      
      protected var FRepositories:Vector.<TResourceRepository>;
      
      protected var FTexturesSwfVital:TResourceRepositorySwf;
      
      protected var FTexturesSwfCommon:TResourceRepositorySwf;
      
      protected var FTexturesSwfCreateChar:TResourceRepositorySwf;
      
      protected var FTexturesSwfChat:TResourceRepositorySwf;
      
      protected var FTexturesSwfBattle:TResourceRepositorySwf;
      
      protected var FTexturesSwfLobby:TResourceRepositorySwf;
      
      protected var FTexturesSwfFont:TResourceRepositorySwf;
      
      protected var FTexturesSwfPlot:TResourceRepositorySwf;
      
      protected var FTexturesVital:TResourceRepositoryTexture;
      
      protected var FTexturesLobby:TResourceRepositoryTexture;
      
      protected var FTexturesModel:TResourceRepositoryTexture;
      
      protected var FTexturesSkill:TResourceRepositoryTexture;
      
      protected var FTexturesSkillIcon:TResourceRepositoryTexture;
      
      protected var FTexturesLargeIcon:TResourceRepositoryTexture;
      
      protected var FTexturesSmallIcon:TResourceRepositoryTexture;
      
      protected var FTexturesHeadIcon:TResourceRepositoryTexture;
      
      protected var FTexturesBackgroundIcon:TResourceRepositoryTexture;
      
      protected var FTexturesMiddlePic:TResourceRepositoryTexture;
      
      protected var FTexturesInventory:TResourceRepositoryTexture;
      
      protected var FTexturesBuffIcon:TResourceRepositoryTexture;
      
      protected var FTexturesDailytaskPicture:TResourceRepositoryTexture;
      
      protected var FTexturesPreview:TResourceRepositoryTexture;
      
      protected var FTexturesMap:TResourceRepositoryTexture;
      
      protected var FTexturesActivityBanner:TResourceRepositoryTexture;
      
      protected var FTexturesAchievementIcon:TResourceRepositoryTexture;
      
      protected var FTexturesAchievementTitle:TResourceRepositoryTexture;
      
      protected var FResourceBin:TResourceRepositoryBin;
      
      protected var FResourceMap:TResourceRepositoryMap;
      
      public function TResourcesCore()
      {
         super();
         this.FRepositories = new Vector.<TResourceRepository>();
         this.ConstructRepositories();
      }
      
      protected function ConstructRepositoryBin(param1:String, param2:uint) : TResourceRepositoryBin
      {
         var _loc3_:TResourceRepositoryBin = null;
         _loc3_ = new TResourceRepositoryBin(param1,param2);
         _loc3_.InstanceType = param1;
         this.FRepositories.push(_loc3_);
         return _loc3_;
      }
      
      protected function ConstructRepositoryMap(param1:String, param2:uint) : TResourceRepositoryMap
      {
         var _loc3_:TResourceRepositoryMap = null;
         _loc3_ = new TResourceRepositoryMap(param1,param2);
         _loc3_.InstanceType = param1;
         this.FRepositories.push(_loc3_);
         return _loc3_;
      }
      
      protected function ConstructRepositoryXML(param1:String, param2:uint) : TResourceRepositoryXml
      {
         var _loc3_:TResourceRepositoryXml = null;
         _loc3_ = new TResourceRepositoryXml(param1,param2);
         this.FRepositories.push(_loc3_);
         return _loc3_;
      }
      
      protected function ConstructRepositorySWF(param1:String, param2:uint) : TResourceRepositorySwf
      {
         var _loc3_:TResourceRepositorySwf = null;
         _loc3_ = new TResourceRepositorySwf(param1,param2);
         _loc3_.InstanceType = param1;
         this.FRepositories.push(_loc3_);
         return _loc3_;
      }
      
      protected function ConstructRepositoryTexture(param1:String, param2:uint) : TResourceRepositoryTexture
      {
         var _loc3_:TResourceRepositoryTexture = null;
         _loc3_ = new TResourceRepositoryTexture(param1,param2);
         _loc3_.InstanceType = param1;
         this.FRepositories.push(_loc3_);
         return _loc3_;
      }
      
      protected function ConstructRepositories() : void
      {
         this.ConstructRepositories_Bin();
         this.ConstructRepositories_Map();
         this.ConstructRepositories_Swf();
         this.ConstructRepositories_Textures();
      }
      
      protected function ConstructRepositories_Bin() : void
      {
         if(SParametersCore.IsCombine)
         {
            if(TUtilityString.Empty(SParametersCore.VersionDir))
            {
               this.FResourceBin = this.ConstructRepositoryBin("Resources/Bin/combine/",2);
            }
            else
            {
               this.FResourceBin = this.ConstructRepositoryBin("Resources/Bin/" + SParametersCore.VersionDir + "/combine/",2);
            }
         }
         else if(TUtilityString.Empty(SParametersCore.VersionDir))
         {
            this.FResourceBin = this.ConstructRepositoryBin("Resources/Bin/normal/",2);
         }
         else
         {
            this.FResourceBin = this.ConstructRepositoryBin("Resources/Bin/" + SParametersCore.VersionDir + "/normal/",2);
         }
      }
      
      protected function ConstructRepositories_Map() : void
      {
         this.FResourceMap = this.ConstructRepositoryMap("Resources/Map/",6);
      }
      
      protected function ConstructRepositories_Swf() : void
      {
         var _loc1_:String = null;
         if(TUtilityString.Empty(SParametersCore.VersionDir))
         {
            this.FTexturesSwfCommon = this.ConstructRepositorySWF("Resources/Swf/Common/",1);
            this.FTexturesSwfVital = this.ConstructRepositorySWF("Resources/Swf/Vital/",10);
            this.FTexturesSwfCreateChar = this.ConstructRepositorySWF("Resources/Swf/CreateChar/",12);
            this.FTexturesSwfFont = this.ConstructRepositorySWF("Resources/Swf/Font/",13);
            this.FTexturesSwfChat = this.ConstructRepositorySWF("Resources/Swf/Chat/",14);
            this.FTexturesSwfLobby = this.ConstructRepositorySWF("Resources/Swf/Lobby/",15);
            this.FTexturesSwfPlot = this.ConstructRepositorySWF("Resources/Swf/Plot/",16);
            this.FTexturesSwfBattle = this.ConstructRepositorySWF("Resources/Swf/Battle/",17);
         }
         else
         {
            _loc1_ = SParametersCore.VersionDir;
            switch(_loc1_)
            {
               case "Mix_de_DE":
                  _loc1_ = "de_DE";
                  break;
               case "Mix_fr_FR":
                  _loc1_ = "fr_FR";
                  break;
               case "Mix_en_Eu":
                  _loc1_ = "en_Eu";
                  break;
               case "Mix_es_ES":
                  _loc1_ = "es_ES";
            }
            this.FTexturesSwfCommon = this.ConstructRepositorySWF("Resources/" + _loc1_ + "/Swf/Common/",1);
            this.FTexturesSwfVital = this.ConstructRepositorySWF("Resources/" + _loc1_ + "/Swf/Vital/",10);
            this.FTexturesSwfCreateChar = this.ConstructRepositorySWF("Resources/" + _loc1_ + "/Swf/CreateChar/",12);
            this.FTexturesSwfFont = this.ConstructRepositorySWF("Resources/" + _loc1_ + "/Swf/Font/",13);
            this.FTexturesSwfChat = this.ConstructRepositorySWF("Resources/" + _loc1_ + "/Swf/Chat/",14);
            this.FTexturesSwfLobby = this.ConstructRepositorySWF("Resources/" + _loc1_ + "/Swf/Lobby/",15);
            this.FTexturesSwfPlot = this.ConstructRepositorySWF("Resources/" + _loc1_ + "/Swf/Plot/",16);
            this.FTexturesSwfBattle = this.ConstructRepositorySWF("Resources/" + _loc1_ + "/Swf/Battle/",17);
         }
      }
      
      protected function ConstructRepositories_Textures() : void
      {
         var _loc1_:String = null;
         if(TUtilityString.Empty(SParametersCore.VersionDir))
         {
            this.FTexturesVital = this.ConstructRepositoryTexture("Resources/Textures/Vital/",5);
            this.FTexturesPreview = this.ConstructRepositoryTexture("Resources/Textures/Preview/",20);
            this.FTexturesLargeIcon = this.ConstructRepositoryTexture("Resources/Textures/LargeIcon/",22);
            this.FTexturesLobby = this.ConstructRepositoryTexture("Resources/Textures/Lobby/",24);
            this.FTexturesInventory = this.ConstructRepositoryTexture("Resources/Textures/Inventory/",26);
            this.FTexturesBackgroundIcon = this.ConstructRepositoryTexture("Resources/Textures/BackgroundIcon/",28);
            this.FTexturesMiddlePic = this.ConstructRepositoryTexture("Resources/Textures/MiddlePicture/",30);
            this.FTexturesBuffIcon = this.ConstructRepositoryTexture("Resources/Textures/BuffIcon/",32);
            this.FTexturesHeadIcon = this.ConstructRepositoryTexture("Resources/Textures/HeadIcon/",34);
            this.FTexturesSkillIcon = this.ConstructRepositoryTexture("Resources/Textures/SkillPicture/",36);
            this.FTexturesDailytaskPicture = this.ConstructRepositoryTexture("Resources/Textures/DailytaskPicture/",38);
            this.FTexturesSmallIcon = this.ConstructRepositoryTexture("Resources/Textures/SmallIcon/",42);
            this.FTexturesModel = this.ConstructRepositoryTexture("Resources/Textures/Model/",44);
            this.FTexturesSkill = this.ConstructRepositoryTexture("Resources/Textures/Skill/",45);
            this.FTexturesActivityBanner = this.ConstructRepositoryTexture("Resources/Textures/ActivityBanner/",50);
            this.FTexturesAchievementIcon = this.ConstructRepositoryTexture("Resources/Textures/AchievementIcon/",51);
            this.FTexturesAchievementTitle = this.ConstructRepositoryTexture("Resources/Textures/AchievementTitle/",52);
            this.FTexturesMap = this.ConstructRepositoryTexture("Resources/Textures/Map/",53);
         }
         else
         {
            _loc1_ = SParametersCore.VersionDir;
            switch(_loc1_)
            {
               case "Mix_de_DE":
                  _loc1_ = "de_DE";
                  break;
               case "Mix_fr_FR":
                  _loc1_ = "fr_FR";
                  break;
               case "Mix_en_Eu":
                  _loc1_ = "en_Eu";
                  break;
               case "Mix_es_ES":
                  _loc1_ = "es_ES";
            }
            this.FTexturesVital = this.ConstructRepositoryTexture("Resources/" + _loc1_ + "/Textures/Vital/",5);
            this.FTexturesPreview = this.ConstructRepositoryTexture("Resources/" + _loc1_ + "/Textures/Preview/",20);
            this.FTexturesLargeIcon = this.ConstructRepositoryTexture("Resources/" + _loc1_ + "/Textures/LargeIcon/",22);
            this.FTexturesLobby = this.ConstructRepositoryTexture("Resources/" + _loc1_ + "/Textures/Lobby/",24);
            this.FTexturesInventory = this.ConstructRepositoryTexture("Resources/" + _loc1_ + "/Textures/Inventory/",26);
            this.FTexturesBackgroundIcon = this.ConstructRepositoryTexture("Resources/" + _loc1_ + "/Textures/BackgroundIcon/",28);
            this.FTexturesMiddlePic = this.ConstructRepositoryTexture("Resources/" + _loc1_ + "/Textures/MiddlePicture/",30);
            this.FTexturesBuffIcon = this.ConstructRepositoryTexture("Resources/" + _loc1_ + "/Textures/BuffIcon/",32);
            this.FTexturesHeadIcon = this.ConstructRepositoryTexture("Resources/" + _loc1_ + "/Textures/HeadIcon/",34);
            this.FTexturesSkillIcon = this.ConstructRepositoryTexture("Resources/" + _loc1_ + "/Textures/SkillPicture/",36);
            this.FTexturesDailytaskPicture = this.ConstructRepositoryTexture("Resources/" + _loc1_ + "/Textures/DailytaskPicture/",38);
            this.FTexturesSmallIcon = this.ConstructRepositoryTexture("Resources/" + _loc1_ + "/Textures/SmallIcon/",42);
            this.FTexturesModel = this.ConstructRepositoryTexture("Resources/" + _loc1_ + "/Textures/Model/",44);
            this.FTexturesSkill = this.ConstructRepositoryTexture("Resources/" + _loc1_ + "/Textures/Skill/",45);
            this.FTexturesActivityBanner = this.ConstructRepositoryTexture("Resources/" + _loc1_ + "/Textures/ActivityBanner/",50);
            this.FTexturesAchievementIcon = this.ConstructRepositoryTexture("Resources/" + _loc1_ + "/Textures/AchievementIcon/",51);
            this.FTexturesAchievementTitle = this.ConstructRepositoryTexture("Resources/" + _loc1_ + "/Textures/AchievementTitle/",52);
            this.FTexturesMap = this.ConstructRepositoryTexture("Resources/" + _loc1_ + "/Textures/Map/",53);
         }
      }
      
      public function get PrimaryCount() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TResourceRepository = null;
         _loc1_ = 0;
         _loc2_ = int(this.FRepositories.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.FRepositories[_loc3_];
            _loc1_ += _loc4_.PrimaryCount;
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function get Loading() : Boolean
      {
         return this.LoadingPrimary || this.LoadingSecondary;
      }
      
      public function get LoadingPrimary() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TResourceRepository = null;
         _loc1_ = int(this.FRepositories.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FRepositories[_loc2_];
            if(_loc3_.LoadingPrimary)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function get LoadingSecondary() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TResourceRepository = null;
         _loc1_ = int(this.FRepositories.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FRepositories[_loc2_];
            if(_loc3_.LoadingSecondary)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function get PrimaryPercentage() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TResourceRepository = null;
         _loc1_ = 0;
         _loc2_ = int(this.FRepositories.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.FRepositories[_loc3_];
            _loc1_ = int(_loc4_.CurrentPercentage);
            if(_loc1_ != 0)
            {
               return _loc1_;
            }
            _loc3_++;
         }
         return 0;
      }
      
      public function get PrimaryKbps() : uint
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TResourceRepository = null;
         _loc1_ = 0;
         _loc2_ = int(this.FRepositories.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.FRepositories[_loc3_];
            _loc1_ = _loc4_.CurrentKbps;
            if(_loc1_ != 0)
            {
               return _loc1_;
            }
            _loc3_++;
         }
         return 0;
      }
      
      public function get TexturesSwfVital() : TResourceRepositorySwf
      {
         return this.FTexturesSwfVital;
      }
      
      public function get TexturesSwfChat() : TResourceRepositorySwf
      {
         return this.FTexturesSwfChat;
      }
      
      public function get TexturesSwfLobby() : TResourceRepositorySwf
      {
         return this.FTexturesSwfLobby;
      }
      
      public function get TexturesSwfBattle() : TResourceRepositorySwf
      {
         return this.FTexturesSwfBattle;
      }
      
      public function get TexturesSwfCommon() : TResourceRepositorySwf
      {
         return this.FTexturesSwfCommon;
      }
      
      public function get TexturesSwfCreateChar() : TResourceRepositorySwf
      {
         return this.FTexturesSwfCreateChar;
      }
      
      public function get TexturesSwfFont() : TResourceRepositorySwf
      {
         return this.FTexturesSwfFont;
      }
      
      public function get TexturesSwfPlot() : TResourceRepositorySwf
      {
         return this.FTexturesSwfPlot;
      }
      
      public function get TexturesVital() : TResourceRepositoryTexture
      {
         return this.FTexturesVital;
      }
      
      public function get TexturesPreview() : TResourceRepositoryTexture
      {
         return this.FTexturesPreview;
      }
      
      public function get TexturesLobby() : TResourceRepositoryTexture
      {
         return this.FTexturesLobby;
      }
      
      public function get TexturesModel() : TResourceRepositoryTexture
      {
         return this.FTexturesModel;
      }
      
      public function get TexturesSkill() : TResourceRepositoryTexture
      {
         return this.FTexturesSkill;
      }
      
      public function get TexturesSkillIcon() : TResourceRepositoryTexture
      {
         return this.FTexturesSkillIcon;
      }
      
      public function get TexturesDailytaskPicture() : TResourceRepositoryTexture
      {
         return this.FTexturesDailytaskPicture;
      }
      
      public function get TexturesLargeIcon() : TResourceRepositoryTexture
      {
         return this.FTexturesLargeIcon;
      }
      
      public function get TexturesSmallIcon() : TResourceRepositoryTexture
      {
         return this.FTexturesSmallIcon;
      }
      
      public function get TexturesHeadIcon() : TResourceRepositoryTexture
      {
         return this.FTexturesHeadIcon;
      }
      
      public function get TexturesMiddlePic() : TResourceRepositoryTexture
      {
         return this.FTexturesMiddlePic;
      }
      
      public function get TexturesMap() : TResourceRepositoryTexture
      {
         return this.FTexturesMap;
      }
      
      public function get TexturesBackgroundIcon() : TResourceRepositoryTexture
      {
         return this.FTexturesBackgroundIcon;
      }
      
      public function get TexturesInventory() : TResourceRepositoryTexture
      {
         return this.FTexturesInventory;
      }
      
      public function get TexturesBuffIcon() : TResourceRepositoryTexture
      {
         return this.FTexturesBuffIcon;
      }
      
      public function get ResourceBin() : TResourceRepositoryBin
      {
         return this.FResourceBin;
      }
      
      public function get ResourceMap() : TResourceRepositoryMap
      {
         return this.FResourceMap;
      }
      
      public function get TexturesActivityBanner() : TResourceRepositoryTexture
      {
         return this.FTexturesActivityBanner;
      }
      
      public function get TexturesAchievementIcon() : TResourceRepositoryTexture
      {
         return this.FTexturesAchievementIcon;
      }
      
      public function get TexturesAchievementTitle() : TResourceRepositoryTexture
      {
         return this.FTexturesAchievementTitle;
      }
      
      public function Update() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TResourceRepository = null;
         _loc1_ = int(this.FRepositories.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FRepositories[_loc2_];
            _loc3_.Process();
            _loc2_++;
         }
      }
   }
}

