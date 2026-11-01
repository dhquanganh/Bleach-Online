package Processors.Game.Lobby.Common.Players
{
   import Components.Pages.*;
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Common.Integer.*;
   import Foundation.Queries.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.KnifeOfKillSoul.TKnifeOfKillSoulData;
   import Logics.KnifeOfKillSoul.TKnifeOfkillSoulDatas;
   import Logics.Rebirth.TRebirthData;
   import Logics.SLogicsCore;
   import Logics.Skills.*;
   import Logics.Unlocks.TUnlock;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Components.*;
   import Processors.Game.Lobby.HeroChange.TProcessorWindowHeroChangeMainUI;
   import Processors.Game.Lobby.TacticalDeployment.Components.TKnifeInforTip;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.net.URLRequest;
   import flash.text.*;
   
   public class TProcessorWindowPlayerAssets extends TProcessorLobbyWindow
   {
      
      protected static const TYPE_EQUIPMENT:uint = CONST_HEROS.TYPE_EQUIPMENT;
      
      protected static const TYPE_ORNAMENT:uint = CONST_HEROS.TYPE_ORNAMENT;
      
      protected static const BASEATTRIBUTENAMES:Vector.<uint> = CONST_COMMON.BASEATTRIBUTENAMES;
      
      protected static const CAPACITY_TF_OrnamentBaseAttributes:uint = CONST_HEROS.CAPACITY_TF_OrnamentBaseAttributes;
      
      protected static const CAPACITY_OrnamentMounted_Slots:uint = CONST_HEROS.CAPACITY_OrnamentMounted_Slots;
      
      protected static const CAPACITY_TF_HerosName:uint = 10;
      
      protected static const CAPACITY_EquipmentsMounted_Slots:uint = CONST_HEROS.CAPACITY_EquipmentsMounted_Slots;
      
      protected static const CAPACITY_TF_BaseAttributes:uint = CONST_HEROS.CAPACITY_TF_BaseAttributes;
      
      protected static const CATEGORY_TreasurePower:uint = CONST_INVENTORY.CATEGORYSECOND_TreasurePower;
      
      protected static const PROFESSION_Agility:uint = CONST_CHARACTER.PROFESSION_Agility;
      
      protected static const PROFESSION_Defending:uint = CONST_CHARACTER.PROFESSION_Defending;
      
      protected static const PROFESSION_Intellect:uint = CONST_CHARACTER.PROFESSION_Intellect;
      
      protected static const PROFESSION_Strength:uint = CONST_CHARACTER.PROFESSION_Strength;
      
      protected static const INDEX_TACTICALDEPLOYMENT_BEFORE:uint = CONST_HEROS.INDEX_TACTICALDEPLOYMENT_BEFORE;
      
      protected static const INDEX_TACTICALDEPLOYMENT_MIDDLE:uint = CONST_HEROS.INDEX_TACTICALDEPLOYMENT_MIDDLE;
      
      protected static const INDEX_TACTICALDEPLOYMENT_AFTER:uint = CONST_HEROS.INDEX_TACTICALDEPLOYMENT_AFTER;
      
      protected static const INVENTORIESINDEX_Heros_Ornament:uint = CONST_COMMON.INVENTORIESINDEX_Heros_Ornament;
      
      protected static const QUALITYCOLOR_INDEX:Vector.<uint> = CONST_COMMON.QUALITYCOLOR_INDEX;
      
      protected static const CAPACITY_TAB_Window:uint = CONST_HEROS.CAPACITY_TAB_Window;
      
      protected static const MaxStarNum:int = 7;
      
      protected var FSystemLanguages:TBins;
      
      protected var FHint:THint;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FUITabHeros:TUITab;
      
      protected var FTF_CurrentNumber:TextField;
      
      protected var FTF_Level:TextField;
      
      protected var FMC_Profession:MovieClip;
      
      protected var FBtn_Treasure:TUIButton;
      
      protected var FMC_HeroPosition:Sprite;
      
      protected var FTF_Experience:TextField;
      
      protected var FMC_ProgressBarExp:Sprite;
      
      protected var FMC_NormalAttribute:MovieClip;
      
      protected var FTF_BaseAttributes:Vector.<TextField>;
      
      protected var FTF_FightingCapacity:TextField;
      
      protected var FMC_AttackType:MovieClip;
      
      protected var FTF_SkillAttack:TextField;
      
      protected var FTF_Talent:TextField;
      
      protected var FTF_TacticalDeployment:TextField;
      
      protected var FTF_KnifeOfKillSoul:TextField;
      
      protected var FMC_PvPAttribute:MovieClip;
      
      protected var FTF_PvPBaseAttributes:Vector.<TextField>;
      
      protected var FTF_PvPFightingCapacity:TextField;
      
      protected var FMC_PvPAttackType:MovieClip;
      
      protected var FTF_PvPSkillAttack:TextField;
      
      protected var FTF_PvPTalent:TextField;
      
      protected var FTF_PvPTacticalDeployment:TextField;
      
      protected var FTF_PvPKnifeOfKillSoul:TextField;
      
      protected var FMC_Information:MovieClip;
      
      protected var FMC_CLoseInfomation:MovieClip;
      
      protected var FMC_OpenInfomation:MovieClip;
      
      protected var FMC_OpeningState:MovieClip;
      
      protected var FMC_ClosingState:MovieClip;
      
      protected var FBtnCloseInfomation:TUIButton;
      
      protected var FBtnOpenInfomation:TUIButton;
      
      protected var FMC_HeroPage:MovieClip;
      
      protected var FMC_PvPInformation:MovieClip;
      
      protected var FMC_PvPCLoseInfomation:MovieClip;
      
      protected var FMC_PvPOpenInfomation:MovieClip;
      
      protected var FMC_PvPOpeningState:MovieClip;
      
      protected var FMC_PvPClosingState:MovieClip;
      
      protected var FPvPBtnCloseInfomation:TUIButton;
      
      protected var FPvPBtnOpenInfomation:TUIButton;
      
      protected var FPvPMC_HeroPage:MovieClip;
      
      protected var FMC_OrnamentNormalAttribute:Sprite;
      
      protected var FTF_OrnamentNormalAttributes:Vector.<TextField>;
      
      protected var FMC_OrnamentPvPAttribute:Sprite;
      
      protected var FTF_OrnamentPvPAttributes:Vector.<TextField>;
      
      protected var FMC_Assess:MovieClip;
      
      protected var FHeroChangeStar:Sprite;
      
      protected var FProfileStarMarker:Sprite;
      
      protected var FProfileStarIcon:Bitmap;
      
      protected var FProfileStarBadge:TextField;
      
      protected var FHeroChangeLightStars:Vector.<Sprite>;
      
      protected var FHeroChangeDarkStars:Vector.<Sprite>;
      
      protected var FMcHeroState:Sprite;
      
      protected var FHeros:THeros;
      
      protected var FUIHero:TUIHero;
      
      protected var FSlotsEquipmentMounted:Vector.<TUISlot>;
      
      protected var FSlotsOrnamentMounted:Vector.<TUISlot>;
      
      protected var FBaseAttibutes:Vector.<Number>;
      
      protected var FPvPAttibutes:Vector.<Number>;
      
      protected var FHeroPage:TUIPage;
      
      protected var FKnifeOfKillSoulInforTip:TKnifeInforTip;
      
      protected var FKnifeOfKillSoulData:TKnifeOfKillSoulData;
      
      protected var FKnifeOfkillSoulDatas:TKnifeOfkillSoulDatas;
      
      protected var FRolesModelID:Vector.<int>;
      
      protected var FHeroPageIndex:int;
      
      protected var FTabHeroIndex:int;
      
      protected var FCurrentPageStore:int;
      
      protected var FInitializationSlots:Boolean;
      
      protected var FAttributeTab:TUITab;
      
      protected var FCurWindowType:uint;
      
      protected var FMC_Ornament:Sprite;
      
      protected var FMC_Equipment:Sprite;
      
      protected var FUITabWindow:TUITab;
      
      protected var FBtnCrashJade:TUIButton;
      
      protected var FChangeLevelNames:Vector.<String>;
      
      protected var FRebirthData:TRebirthData;
      
      protected var FOnInventoryOver:Function;
      
      protected var FOnInventoryOut:Function;
      
      protected var FHintOnOver:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FOnSkillOver:Function;
      
      protected var FOnSkillOut:Function;
      
      protected var FKnifeOfKillSoulID:int;
      
      private var FCharacterTagRow:Sprite;
      
      private var FCharacterTagData:Object;
      
      public function TProcessorWindowPlayerAssets(param1:TUIComponent)
      {
         super(param1);
         this.FCurWindowType = TYPE_EQUIPMENT;
         this.FSlotsEquipmentMounted = new Vector.<TUISlot>(CAPACITY_EquipmentsMounted_Slots);
         this.FSlotsOrnamentMounted = new Vector.<TUISlot>(CAPACITY_OrnamentMounted_Slots);
         this.FTF_BaseAttributes = new Vector.<TextField>(CAPACITY_TF_BaseAttributes);
         this.FTF_PvPBaseAttributes = new Vector.<TextField>(CAPACITY_TF_BaseAttributes);
         this.FTF_OrnamentNormalAttributes = new Vector.<TextField>(CAPACITY_TF_OrnamentBaseAttributes);
         this.FTF_OrnamentPvPAttributes = new Vector.<TextField>(CAPACITY_TF_OrnamentBaseAttributes);
         this.FBaseAttibutes = new Vector.<Number>(CONST_HEROS.CAPACITY_BaseAttribute);
         this.FPvPAttibutes = new Vector.<Number>(CONST_HEROS.CAPACITY_BaseAttribute);
         this.FHint = new THint();
         this.FRolesModelID = new Vector.<int>();
         this.FHeroPageIndex = 0;
         this.FTabHeroIndex = 0;
         this.FInitializationSlots = false;
         this.FKnifeOfkillSoulDatas = new TKnifeOfkillSoulDatas();
         this.FRebirthData = SLogicsCore.RebirthData;
      }
      
      private function InitCharacterTags(host:Sprite) : void
      {
         FCharacterTagData = JSON.parse("{\"heroes\":{\"11120960\":[26,52,1,11,14,31,48],\"11120950\":[27,52,12],\"11120970\":[28,61,52,1,3,11,14,31,46,48,49],\"11120920\":[26,52,1,14,31,48],\"11120991\":[27,64,52,2,13,18,57],\"11120940\":[30,52,1,18,14,32,48,49,58],\"11120930\":[28,52,6,11,14,46],\"11120901\":[27,52,1,13,47,58],\"11120990\":[27,52,6,14,46,47],\"11120992\":[29,67,54,1,18,32,48,57],\"11120994\":[27,52,1,13,47,58],\"11120995\":[30,52,11,12,14],\"11120997\":[30,52,7,11,48,51],\"11121001\":[26,52,1,14,31,48,49],\"11121003\":[27,62,52,1,18,58],\"11121005\":[26,52,1,13,14,31,46,48,58],\"11121006\":[27,52,1,13,14,47,57,58],\"11121007\":[28,52,1,57],\"11121008\":[27,52,13,14,49,56,58],\"11121009\":[27,62,52,1,3,11,14,15,49]},\"tags\":{\"26\":{\"name\":\"Fire\",\"icon\":\"/public/character-tags/26.png\"},\"52\":{\"name\":\"Male\",\"icon\":\"/public/character-tags/52.png\"},\"1\":{\"name\":\"Konoha\",\"icon\":\"/public/character-tags/1.png\"},\"11\":{\"name\":\"Akatsuki\",\"icon\":\"/public/character-tags/11.png\"},\"14\":{\"name\":\"Blood Limit\",\"icon\":\"/public/character-tags/14.png\"},\"31\":{\"name\":\"Uchiha Clan\",\"icon\":\"/public/character-tags/31.png\"},\"48\":{\"name\":\"Secret Jutsu User\",\"icon\":\"/public/character-tags/48.png\"},\"27\":{\"name\":\"Wind\",\"icon\":\"/public/character-tags/27.png\"},\"12\":{\"name\":\"Confusion\",\"icon\":\"/public/character-tags/12.png\"},\"28\":{\"name\":\"Lightning\",\"icon\":\"/public/character-tags/28.png\"},\"61\":{\"name\":\"Sasuke Shinden\",\"icon\":\"/public/character-tags/61.png\"},\"3\":{\"name\":\"Hidden Sound\",\"icon\":\"/public/character-tags/3.png\"},\"46\":{\"name\":\"Rinnegan\",\"icon\":\"/public/character-tags/46.png\"},\"49\":{\"name\":\"Sword User\",\"icon\":\"/public/character-tags/49.png\"},\"64\":{\"name\":\"Swimsuit\",\"icon\":\"/public/character-tags/64.png\"},\"2\":{\"name\":\"Hidden Sand\",\"icon\":\"/public/character-tags/2.png\"},\"13\":{\"name\":\"Jinchuriki\",\"icon\":\"/public/character-tags/13.png\"},\"18\":{\"name\":\"Kage\",\"icon\":\"/public/character-tags/18.png\"},\"57\":{\"name\":\"Allied Shinobi Forces\",\"icon\":\"/public/character-tags/57.png\"},\"30\":{\"name\":\"Earth\",\"icon\":\"/public/character-tags/30.png\"},\"32\":{\"name\":\"Senju Clan\",\"icon\":\"/public/character-tags/32.png\"},\"58\":{\"name\":\"Senjutsu\",\"icon\":\"/public/character-tags/58.png\"},\"6\":{\"name\":\"Hidden Rain\",\"icon\":\"/public/character-tags/6.png\"},\"47\":{\"name\":\"Uzumaki Clan\",\"icon\":\"/public/character-tags/47.png\"},\"29\":{\"name\":\"Water\",\"icon\":\"/public/character-tags/29.png\"},\"67\":{\"name\":\"Asian Style\",\"icon\":\"/public/character-tags/67.png\"},\"54\":{\"name\":\"Female\",\"icon\":\"/public/character-tags/54.png\"},\"7\":{\"name\":\"Hidden Waterfall\",\"icon\":\"/public/character-tags/7.png\"},\"51\":{\"name\":\"Edo Tensei\",\"icon\":\"/public/character-tags/51.png\"},\"62\":{\"name\":\"New Year\",\"icon\":\"/public/character-tags/62.png\"},\"56\":{\"name\":\"Otsutsuki Clan\",\"icon\":\"/public/character-tags/56.png\"},\"15\":{\"name\":\"Curse Mark\",\"icon\":\"/public/character-tags/15.png\"}}}");
         FCharacterTagRow = new Sprite();
         FCharacterTagRow.name = "characterTags";
         var tab:DisplayObject = host["BtnPvP"];
         FCharacterTagRow.x = tab.x + tab.width + 4;
         FCharacterTagRow.y = tab.y + (tab.height - 20) / 2;
         host.addChild(FCharacterTagRow);
      }
      
      private function RenderCharacterTags() : void
      {
         if(FCharacterTagRow == null)
         {
            return;
         }
         this.TFHintOnOut(null);
         while(FCharacterTagRow.numChildren > 0)
         {
            FCharacterTagRow.removeChildAt(0);
         }
         var hero:THero = FHeros == null || FTabHeroIndex >= FHeros.Count ? null : FHeros.GetHeroByIndex(FTabHeroIndex);
         var ids:Array = hero == null ? null : FCharacterTagData.heroes[String(hero.Identifier)] as Array;
         FCharacterTagRow.visible = ids != null;
         if(!FCharacterTagRow.visible)
         {
            return;
         }
         var iconScale:Number = Math.min(1,7 / ids.length);
         var i:int = 0;
         while(i < ids.length)
         {
            AddCharacterTag(ids[i],i);
            var slot:Sprite = FCharacterTagRow.getChildAt(i) as Sprite;
            slot.scaleX = slot.scaleY = iconScale;
            slot.x = i * 20 * iconScale;
            slot.y = (20 - 20 * iconScale) / 2;
            i++;
         }
      }
      
      private function AddCharacterTag(id:int, index:int) : void
      {
         var slot:Sprite;
         var icon:Loader;
         var tag:Object = FCharacterTagData.tags[String(id)];
         if(tag == null)
         {
            return;
         }
         slot = new Sprite();
         slot.name = String(tag.name);
         slot.x = index * 20;
         slot.mouseChildren = false;
         slot.graphics.beginFill(0,0);
         slot.graphics.drawRect(0,0,20,20);
         slot.graphics.endFill();
         icon = new Loader();
         icon.contentLoaderInfo.addEventListener(Event.COMPLETE,function(event:Event):void
         {
            icon.width = 20;
            icon.height = 20;
         });
         icon.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(event:IOErrorEvent):void
         {
         });
         icon.load(new URLRequest(String(tag.icon)));
         slot.addChild(icon);
         slot.addEventListener(MouseEvent.MOUSE_MOVE,CharacterTagOnOver);
         slot.addEventListener(MouseEvent.MOUSE_OUT,this.TFHintOnOut);
         FCharacterTagRow.addChild(slot);
      }
      
      private function CharacterTagOnOver(event:MouseEvent) : void
      {
         FHint.Caption = Sprite(event.currentTarget).name;
         if(this.FHintOnOver != null)
         {
            this.FHintOnOver(this,FHint);
         }
      }
      
      private function ClearProfileCharacterTags() : void
      {
         if(FCharacterTagRow == null)
         {
            return;
         }
         this.TFHintOnOut(null);
         while(FCharacterTagRow.numChildren > 0)
         {
            FCharacterTagRow.removeChildAt(0);
         }
         FCharacterTagRow.visible = false;
      }
      
      protected function Resources_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:MovieClip = null;
         var _loc5_:TUISlot = null;
         var _loc6_:BitmapData = null;
         var _loc7_:TextField = null;
         var _loc8_:MovieClip = null;
         var _loc9_:TextField = null;
         var _loc10_:MovieClip = null;
         var _loc11_:TBounds = null;
         var _loc12_:TCoordinate = null;
         this.FSystemLanguages = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SystemLanguage);
         _loc3_ = TUtilityReflection.CreateDisplayObjectInstance("HeroEquipInfor") as Sprite;
         addChild(_loc3_);
         this.Width = _loc3_.width;
         this.Height = _loc3_.height;
         this.FBtn_Close = _loc3_[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FUITabWindow = new TUITab(this);
         _loc2_ = int(CAPACITY_TAB_Window);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FUITabWindow.SetTabByIndex(_loc3_[CONST_COMMON.RESOURCE_Link_MC_Tab + _loc1_],_loc1_);
            _loc1_++;
         }
         this.FUITabWindow.OnSwitch = this.TabWindowOnSwitch;
         this.FUITabWindow.Init();
         this.FUITabHeros = new TUITab(this);
         _loc2_ = int(CAPACITY_TF_HerosName);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = _loc3_[CONST_HEROS.RESOURCE_Link_TF_HerosName + _loc1_];
            _loc4_.mouseChildren = false;
            this.FUITabHeros.SetTabByIndex(_loc4_,_loc1_);
            this.FUITabHeros.SetTabCaptionByIndex("",_loc1_);
            _loc1_++;
         }
         this.FUITabHeros.OnSwitch = this.TabHerosOnSwitch;
         this.FUITabHeros.Init();
         this.FTF_CurrentNumber = _loc3_[CONST_HEROS.RESOURCE_Link_TF_CurrentNumber];
         this.FTF_Level = _loc3_[CONST_HEROS.RESOURCE_Link_TF_Level];
         this.FTF_Level.mouseEnabled = false;
         this.FMC_Profession = _loc3_[CONST_HEROS.RESOURCE_Link_MC_Profession];
         this.FBtn_Treasure = new TUIButton();
         this.FBtn_Treasure.Substrate = _loc3_[CONST_HEROS.RESOURCE_Link_Btn_Treasure];
         this.FBtn_Treasure.OnOver = this.BtnTreasureHintOnOver;
         this.FBtn_Treasure.OnOut = this.BtnTreasureHintOnOut;
         this.FMC_HeroPosition = _loc3_[CONST_HEROS.RESOURCE_Link_MC_HeroPosition] as Sprite;
         this.FMC_Ornament = _loc3_[CONST_HEROS.RESOURCE_Link_MC_Ornament];
         this.FMC_Equipment = _loc3_[CONST_HEROS.RESOURCE_Link_MC_Equipment];
         this.FMC_Ornament.visible = false;
         this.FMC_Equipment.visible = false;
         _loc2_ = int(CAPACITY_EquipmentsMounted_Slots);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = new TUISlot(this);
            _loc5_.Resource = this.FMC_Equipment[CONST_HEROS.RESOURCE_Link_MC_SlotsEquipment + _loc1_] as Sprite;
            _loc5_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
            _loc5_.TextureAdvancedEffect = SResourcesCore.TexturesLobby.GetTextureByIdentifier(CONST_LOBBY.RESOURCESID_Texture_SlotAdvancedEffect);
            _loc5_.Tag = _loc1_;
            _loc5_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
            _loc5_.OnQueryEdgeColor = this.SlotsOnQueryEdgeColor;
            _loc5_.OnQueryEuqipLevel = this.SlotsOnQueryEuqipLevel;
            _loc5_.OnOver = this.SlotsOnMove;
            _loc5_.OnOut = this.SlotsOnOut;
            _loc5_.Init();
            this.FSlotsEquipmentMounted[_loc1_] = _loc5_;
            _loc1_++;
         }
         _loc2_ = int(CAPACITY_OrnamentMounted_Slots);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = new TUISlot(this);
            _loc5_.Resource = this.FMC_Ornament[CONST_HEROS.RESOURCE_Link_MC_SlotsOrnament + _loc1_] as Sprite;
            _loc5_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
            _loc5_.TextureAdvancedEffect = SResourcesCore.TexturesLobby.GetTextureByIdentifier(CONST_LOBBY.RESOURCESID_Texture_SlotAdvancedEffect);
            _loc5_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
            _loc5_.OnQueryEuqipLevel = this.SlotsOnQueryEuqipLevel;
            _loc5_.OnOver = this.SlotsOnMove;
            _loc5_.OnOut = this.SlotsOnOut;
            _loc5_.Tag = _loc1_;
            _loc5_.Init();
            this.FSlotsOrnamentMounted[_loc1_] = _loc5_;
            _loc1_++;
         }
         this.FTF_Experience = _loc3_[CONST_HEROS.RESOURCE_Link_TF_Experience];
         this.FMC_ProgressBarExp = _loc3_[CONST_HEROS.RESOURCE_Link_MC_ProgressBarExp] as Sprite;
         this.FTF_FightingCapacity = _loc3_[CONST_HEROS.RESOURCE_Link_TF_FightingCapacity];
         this.FAttributeTab = new TUITab(this);
         this.FAttributeTab.SetTabByIndex(_loc3_["BtnNormal"],0);
         this.FAttributeTab.SetTabByIndex(_loc3_["BtnPvP"],1);
         this.FAttributeTab.OnSwitch = this.SwithAttributeTab;
         this.FAttributeTab.Init();
         InitCharacterTags(_loc3_);
         _loc2_ = int(CAPACITY_TF_BaseAttributes);
         _loc10_ = _loc3_["NomalAttribute"];
         this.FMC_NormalAttribute = _loc10_;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc7_ = _loc10_[CONST_HEROS.RESOURCE_Link_TF_BaseAttributes + _loc1_];
            this.FTF_BaseAttributes[_loc1_] = _loc7_;
            _loc1_++;
         }
         this.FMC_AttackType = _loc10_[CONST_HEROS.RESOURCE_Link_MC_Attack];
         this.FTF_SkillAttack = _loc10_[CONST_HEROS.RESOURCE_Link_TF_SkillAttack];
         this.FTF_Talent = _loc10_[CONST_HEROS.RESOURCE_Link_TF_Talent];
         this.FTF_TacticalDeployment = _loc10_[CONST_HEROS.RESOURCE_Link_TF_TacticalDeployment];
         _loc10_ = _loc10_[CONST_HEROS.RESOURCE_Link_MC_Knife];
         this.FTF_KnifeOfKillSoul = _loc10_[CONST_HEROS.RESOURCE_Link_TF_Knife];
         this.FInitializationSlots = true;
         _loc2_ = int(CAPACITY_TF_BaseAttributes);
         _loc10_ = _loc3_["PvPAttribute"];
         this.FMC_PvPAttribute = _loc10_;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc7_ = _loc10_[CONST_HEROS.RESOURCE_Link_TF_BaseAttributes + _loc1_];
            this.FTF_PvPBaseAttributes[_loc1_] = _loc7_;
            _loc1_++;
         }
         this.FMC_PvPAttackType = _loc10_[CONST_HEROS.RESOURCE_Link_MC_Attack];
         this.FTF_PvPSkillAttack = _loc10_[CONST_HEROS.RESOURCE_Link_TF_SkillAttack];
         this.FTF_PvPTalent = _loc10_[CONST_HEROS.RESOURCE_Link_TF_Talent];
         this.FTF_PvPTacticalDeployment = _loc10_[CONST_HEROS.RESOURCE_Link_TF_TacticalDeployment];
         _loc10_ = _loc10_[CONST_HEROS.RESOURCE_Link_MC_Knife];
         this.FTF_PvPKnifeOfKillSoul = _loc10_[CONST_HEROS.RESOURCE_Link_TF_Knife];
         this.FInitializationSlots = true;
         this.FUIHero = new TUIHero(this);
         this.FMC_HeroPosition.mouseEnabled = false;
         this.FMC_HeroPosition.mouseChildren = false;
         this.FMC_HeroPosition.addChild(this.FUIHero);
         this.FUIHero.OnQuerySequenceContext = this.HeroOnQuerySequenceContext;
         this.FUIHero.SequenceDefaultRole = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCEID_Textures_DefaultRole,0);
         _loc11_ = new TBounds();
         _loc12_ = new TCoordinate();
         this.FUIHero.SequenceDefaultRole.Evaluate(_loc12_,_loc11_);
         this.FUIHero.X = _loc11_.X;
         this.FUIHero.Y = _loc11_.Y;
         this.FMC_Assess = _loc3_[CONST_HEROS.RESOURCE_Link_MC_Assess];
         this.FMC_OrnamentNormalAttribute = _loc3_[CONST_HEROS.RESOURCE_Link_MC_Ornament_NomalAttribute];
         this.FMC_OrnamentNormalAttribute.visible = false;
         _loc2_ = int(CAPACITY_TF_OrnamentBaseAttributes);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc7_ = this.FMC_OrnamentNormalAttribute[CONST_HEROS.RESOURCE_Link_TF_BaseAttributes + _loc1_];
            _loc7_.text = "";
            this.FTF_OrnamentNormalAttributes[_loc1_] = _loc7_;
            _loc1_++;
         }
         this.FMC_OrnamentPvPAttribute = _loc3_[CONST_HEROS.RESOURCE_Link_MC_Ornament_PvPAttribute];
         this.FMC_OrnamentPvPAttribute.visible = false;
         _loc2_ = int(CAPACITY_TF_OrnamentBaseAttributes);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc7_ = this.FMC_OrnamentPvPAttribute[CONST_HEROS.RESOURCE_Link_TF_BaseAttributes + _loc1_];
            _loc7_.text = "";
            this.FTF_OrnamentPvPAttributes[_loc1_] = _loc7_;
            _loc1_++;
         }
         this.FMC_Information = _loc3_[CONST_HEROS.RESOURCE_Link_MC_Information];
         this.FMC_OpenInfomation = this.FMC_Information[CONST_HEROS.RESOURCE_Link_MC_OpenInfomation];
         this.FMC_OpenInfomation.visible = false;
         this.FMC_ClosingState = this.FMC_OpenInfomation[CONST_HEROS.RESOURCE_Link_MC_ClosingState];
         this.FBtnCloseInfomation = new TUIButton();
         this.FBtnCloseInfomation.Substrate = this.FMC_OpenInfomation[CONST_HEROS.RESOURCE_Link_Btn_CloseInfomation];
         this.FBtnCloseInfomation.OnClick = this.BtnCloseInfomationOnClick;
         this.FMC_CLoseInfomation = this.FMC_Information[CONST_HEROS.RESOURCE_Link_MC_CLoseInfomation];
         this.FMC_CLoseInfomation.visible = true;
         this.FMC_OpeningState = this.FMC_CLoseInfomation[CONST_HEROS.RESOURCE_Link_MC_OpeningState];
         this.FBtnOpenInfomation = new TUIButton();
         this.FBtnOpenInfomation.Substrate = this.FMC_CLoseInfomation[CONST_HEROS.RESOURCE_Link_Btn_OpenInfomation];
         this.FBtnOpenInfomation.OnClick = this.BtnOpenInfomationOnClick;
         this.FMC_PvPInformation = _loc3_["MC_PvP"];
         this.FMC_PvPOpenInfomation = this.FMC_PvPInformation[CONST_HEROS.RESOURCE_Link_MC_OpenInfomation];
         this.FMC_PvPOpenInfomation.visible = false;
         this.FMC_PvPClosingState = this.FMC_PvPOpenInfomation[CONST_HEROS.RESOURCE_Link_MC_ClosingState];
         this.FPvPBtnCloseInfomation = new TUIButton();
         this.FPvPBtnCloseInfomation.Substrate = this.FMC_PvPOpenInfomation[CONST_HEROS.RESOURCE_Link_Btn_CloseInfomation];
         this.FPvPBtnCloseInfomation.OnClick = this.PvPBtnCloseInfomationOnClick;
         this.FMC_PvPCLoseInfomation = this.FMC_PvPInformation[CONST_HEROS.RESOURCE_Link_MC_CLoseInfomation];
         this.FMC_PvPCLoseInfomation.visible = true;
         this.FMC_PvPOpeningState = this.FMC_PvPCLoseInfomation[CONST_HEROS.RESOURCE_Link_MC_OpeningState];
         this.FPvPBtnOpenInfomation = new TUIButton();
         this.FPvPBtnOpenInfomation.Substrate = this.FMC_PvPCLoseInfomation[CONST_HEROS.RESOURCE_Link_Btn_OpenInfomation];
         this.FPvPBtnOpenInfomation.OnClick = this.PvPBtnOpenInfomationOnClick;
         this.FMC_HeroPage = _loc3_[CONST_HEROS.RESOURCE_Link_MC_HeroPage];
         _loc8_ = this.FMC_HeroPage[CONST_HEROS.RESOURCE_Link_MC_PageLeft];
         this.FHeroPage = new TUIPage(this);
         this.FHeroPage.ButtonPrevious.Substrate = _loc8_;
         _loc8_ = this.FMC_HeroPage[CONST_HEROS.RESOURCE_Link_MC_PageRight];
         this.FHeroPage.ButtonNext.Substrate = _loc8_;
         _loc9_ = this.FMC_HeroPage[CONST_HEROS.RESOURCE_Link_TF_Page];
         this.FHeroPage.LabelPage = _loc9_;
         this.FHeroPage.PageSize = CAPACITY_TF_HerosName;
         this.FHeroPage.OnChangePage = this.HeroPageOnChange;
         this.FHeroPage.Init();
         this.FMC_HeroPage.visible = true;
         this.FKnifeOfKillSoulInforTip = new TKnifeInforTip(FParent);
         this.FKnifeOfKillSoulInforTip.Visible = false;
         this.FKnifeOfKillSoulInforTip.UIDispatch();
         this.CreateBaseKnife();
         this.FBtnCrashJade = new TUIButton();
         this.FBtnCrashJade.Substrate = _loc3_["MC_CrashPower"];
         this.FBtnCrashJade.OnMove = this.BtnCrashJadeOnMove;
         this.FBtnCrashJade.OnOut = this.BtnCrashJadeOnOut;
         this.FMcHeroState = _loc3_["MC_HeroState"];
         if(this.FMcHeroState != null)
         {
            this.FMcHeroState.visible = false;
         }
         this.FHeroChangeStar = _loc3_["HeroChangLevel"];
         if(this.FHeroChangeStar != null)
         {
            this.FHeroChangeStar.visible = false;
            this.FHeroChangeStar.addEventListener(MouseEvent.MOUSE_MOVE,this.StarOnMouseOver);
            this.FHeroChangeStar.addEventListener(MouseEvent.MOUSE_OUT,this.StarOnMouseOut);
         }
         this.FHeroChangeStar.visible = true;
         this.FHeroChangeLightStars = new Vector.<Sprite>();
         this.FHeroChangeDarkStars = new Vector.<Sprite>();
         _loc1_ = 0;
         while(_loc1_ < MaxStarNum)
         {
            this.FHeroChangeLightStars.push(this.FHeroChangeStar["Lightstar" + _loc1_]);
            this.FHeroChangeDarkStars.push(this.FHeroChangeStar["Darkstar" + _loc1_]);
            _loc1_++;
         }
         this.FProfileStarMarker = new Sprite();
         this.FProfileStarMarker.x = 120;
         this.FProfileStarMarker.y = 300;
         this.FProfileStarMarker.mouseEnabled = false;
         this.FProfileStarMarker.mouseChildren = false;
         _loc3_.addChild(this.FProfileStarMarker);
         _loc6_ = new BitmapData(18,18,true,0);
         _loc6_.draw(this.FHeroChangeLightStars[0]);
         this.FProfileStarIcon = new Bitmap(_loc6_);
         this.FProfileStarMarker.addChild(this.FProfileStarIcon);
         this.FProfileStarBadge = new TextField();
         this.FProfileStarBadge.defaultTextFormat = new TextFormat("Arial",15,16765275,true);
         this.FProfileStarBadge.x = 22;
         this.FProfileStarBadge.y = -2;
         this.FProfileStarBadge.width = 52;
         this.FProfileStarBadge.height = 24;
         this.FProfileStarBadge.mouseEnabled = false;
         this.FProfileStarMarker.addChild(this.FProfileStarBadge);
         this.FChangeLevelNames = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_18);
      }
      
      protected function Resources_UILocations() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TextField = null;
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.ButtonCloseOnClick,false,0,true);
         _loc2_ = int(CAPACITY_TF_BaseAttributes);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FTF_BaseAttributes[_loc1_];
            _loc3_.addEventListener(MouseEvent.MOUSE_MOVE,this.TFBaseAttributesHintOnOver,false,0,true);
            _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this.TFHintOnOut,false,0,true);
            _loc3_ = this.FTF_PvPBaseAttributes[_loc1_];
            _loc3_.addEventListener(MouseEvent.MOUSE_MOVE,this.TFBaseAttributesHintOnOver,false,0,true);
            _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this.TFHintOnOut,false,0,true);
            _loc1_++;
         }
         this.FTF_Talent.addEventListener(MouseEvent.MOUSE_MOVE,this.TFTalentHintOnOver,false,0,true);
         this.FTF_Talent.addEventListener(MouseEvent.MOUSE_OUT,this.TFHintOnOut,false,0,true);
         this.FTF_PvPTalent.addEventListener(MouseEvent.MOUSE_MOVE,this.TFTalentHintOnOver,false,0,true);
         this.FTF_PvPTalent.addEventListener(MouseEvent.MOUSE_OUT,this.TFHintOnOut,false,0,true);
         this.FMC_Assess.addEventListener(MouseEvent.MOUSE_MOVE,this.MC_AssessHintOnOver,false,0,true);
         this.FMC_Assess.addEventListener(MouseEvent.MOUSE_OUT,this.TFHintOnOut,false,0,true);
         this.FTF_SkillAttack.addEventListener(MouseEvent.MOUSE_MOVE,this.TFSkillAttackHintOnOver,false,0,true);
         this.FTF_SkillAttack.addEventListener(MouseEvent.MOUSE_OUT,this.TFSkillAttackHintOnOut,false,0,true);
         this.FTF_PvPSkillAttack.addEventListener(MouseEvent.MOUSE_MOVE,this.TFSkillAttackHintOnOver,false,0,true);
         this.FTF_PvPSkillAttack.addEventListener(MouseEvent.MOUSE_OUT,this.TFSkillAttackHintOnOut,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.OnMouseDown);
         this.addEventListener(MouseEvent.MOUSE_UP,this.OnMouseUP);
         this.FTF_KnifeOfKillSoul.addEventListener(MouseEvent.MOUSE_MOVE,this.KnifeOfKillSoulOnMove);
         this.FTF_KnifeOfKillSoul.addEventListener(MouseEvent.MOUSE_OUT,this.KnifeOfKillSoulOnOut);
         this.FTF_PvPKnifeOfKillSoul.addEventListener(MouseEvent.MOUSE_MOVE,this.KnifeOfKillSoulOnMove);
         this.FTF_PvPKnifeOfKillSoul.addEventListener(MouseEvent.MOUSE_OUT,this.KnifeOfKillSoulOnOut);
         this.FHeroPage.OnChangePage = this.HeroPageOnChange;
         this.FKnifeOfKillSoulInforTip.UILocation();
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.FInitializationSlots)
         {
            return;
         }
         if(!Visible)
         {
            return;
         }
         if(this.FKnifeOfKillSoulInforTip.visible)
         {
            this.FKnifeOfKillSoulInforTip.UpdatePosition();
         }
         this.ProcessorUpdateSlotsRenderingState();
         this.FUIHero.Update();
         if(this.FMC_CLoseInfomation.visible)
         {
            if(this.FMC_CLoseInfomation.currentFrame == this.FMC_CLoseInfomation.totalFrames)
            {
               this.FMC_CLoseInfomation.visible = false;
               this.FMC_CLoseInfomation.gotoAndStop(1);
               this.FMC_OpenInfomation.visible = true;
               this.FMC_OpenInfomation.gotoAndStop(1);
            }
         }
         if(this.FMC_OpenInfomation.visible)
         {
            if(this.FMC_OpenInfomation.currentFrame == this.FMC_OpenInfomation.totalFrames)
            {
               this.FMC_OpenInfomation.visible = false;
               this.FMC_OpenInfomation.gotoAndStop(1);
               this.FMC_CLoseInfomation.visible = true;
               this.FMC_CLoseInfomation.gotoAndStop(1);
            }
         }
         if(this.FMC_PvPCLoseInfomation.visible)
         {
            if(this.FMC_PvPCLoseInfomation.currentFrame == this.FMC_PvPCLoseInfomation.totalFrames)
            {
               this.FMC_PvPCLoseInfomation.visible = false;
               this.FMC_PvPCLoseInfomation.gotoAndStop(1);
               this.FMC_PvPOpenInfomation.visible = true;
               this.FMC_PvPOpenInfomation.gotoAndStop(1);
            }
         }
         if(this.FMC_PvPOpenInfomation.visible)
         {
            if(this.FMC_PvPOpenInfomation.currentFrame == this.FMC_PvPOpenInfomation.totalFrames)
            {
               this.FMC_PvPOpenInfomation.visible = false;
               this.FMC_PvPOpenInfomation.gotoAndStop(1);
               this.FMC_PvPCLoseInfomation.visible = true;
               this.FMC_PvPCLoseInfomation.gotoAndStop(1);
            }
         }
      }
      
      protected function ProcessorUpdateSlotsRenderingState() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUISlot = null;
         if(this.FCurWindowType == TYPE_EQUIPMENT)
         {
            _loc2_ = int(CAPACITY_EquipmentsMounted_Slots);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc3_ = this.FSlotsEquipmentMounted[_loc1_];
               _loc3_.Update();
               _loc1_++;
            }
         }
         else if(this.FCurWindowType == TYPE_ORNAMENT)
         {
            _loc2_ = int(CAPACITY_OrnamentMounted_Slots);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc3_ = this.FSlotsOrnamentMounted[_loc1_];
               _loc3_.Update();
               _loc1_++;
            }
         }
      }
      
      protected function HeroOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:THero = null;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         var _loc8_:TBounds = null;
         var _loc9_:TCoordinate = null;
         var _loc10_:TRoleModel = null;
         var _loc11_:uint = 0;
         _loc5_ = param2 as THero;
         _loc8_ = new TBounds();
         _loc9_ = new TCoordinate();
         _loc6_ = SResourcesCore.TexturesModel;
         _loc10_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,_loc5_.Identifier) as TRoleModel;
         _loc11_ = CONST_ROLE.GetModelIDByIndex(_loc10_.Model,CONST_ROLE.ROLE_SEQUENCEINDEX_Showcase);
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc11_);
         if(_loc7_ != null)
         {
            param3.Value = _loc7_.GetAnimationSequenceByIndex(0);
            param3.Value.Evaluate(_loc9_,_loc8_);
            this.FUIHero.X = _loc8_.X;
            this.FUIHero.Y = _loc8_.Y;
         }
         else
         {
            _loc6_.LoadSecondary(_loc11_);
            this.FUIHero.X = 0;
            this.FUIHero.Y = 0;
         }
         this.SetRoleModelID(_loc11_);
      }
      
      protected function SetRoleModelID(param1:uint) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FRolesModelID.indexOf(param1);
         if(_loc2_ < 0)
         {
            this.FRolesModelID.push(param1);
         }
      }
      
      protected function SetBaseAttributeByIndex(param1:Vector.<TextField>, param2:String, param3:int) : void
      {
         var _loc4_:TextField = null;
         _loc4_ = param1[param3] as TextField;
         if(_loc4_.text != param2)
         {
            _loc4_.text = param2;
         }
      }
      
      protected function UpdateHeroUIPage() : void
      {
         this.FHeroPageIndex = 0;
         this.FHeroPage.TotalQuantity = this.FHeros.Count;
         this.FHeroPage.PageIndex = this.FHeroPageIndex;
         this.FHeroPage.Update();
      }
      
      protected function SetupHeroListPage(param1:int, param2:int) : void
      {
         this.FHeroPage.TotalQuantity = param1;
         this.FHeroPage.Update();
         this.FHeroPage.PageIndex = param2;
      }
      
      protected function UpdateTabs() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:THero = null;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         this.FHeros.Sort();
         _loc5_ = this.FHeroPageIndex * CAPACITY_TF_HerosName;
         _loc6_ = _loc5_ + CAPACITY_TF_HerosName;
         _loc6_ = _loc6_ > this.FHeros.Count ? this.FHeros.Count : _loc6_;
         _loc2_ = this.FHeros.Count;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_TF_HerosName)
         {
            if(_loc1_ + _loc5_ < _loc6_)
            {
               _loc3_ = this.FHeros.GetHeroByIndex(_loc1_ + _loc5_);
               _loc4_ = QUALITYCOLOR_INDEX[_loc3_.Quality];
               this.FUITabHeros.SetTabCaptionByIndex(_loc3_.Name,_loc1_,_loc4_);
               this.FUITabHeros.SetTabShowByIndex(_loc1_);
            }
            else
            {
               this.FUITabHeros.SetTabHideByIndex(_loc1_);
            }
            _loc1_++;
         }
         this.FTF_CurrentNumber.text = _loc2_.toString();
      }
      
      protected function LoadHeroQuality() : void
      {
         var _loc1_:int = 0;
         var _loc2_:THero = null;
         var _loc3_:TBaseHero = null;
         var _loc4_:int = 0;
         if(this.FHeroPageIndex == 0)
         {
            _loc1_ = 1;
         }
         else
         {
            _loc1_ = 0;
         }
         _loc4_ = this.FHeros.Count - CAPACITY_TF_HerosName * this.FHeroPageIndex;
         _loc4_ = _loc4_ > CAPACITY_TF_HerosName ? int(CAPACITY_TF_HerosName) : _loc4_;
         while(_loc1_ < this.FHeros.Count)
         {
            _loc2_ = this.FHeros.GetHeroByIndex(_loc1_ + this.FTabHeroIndex);
            _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,_loc2_.Identifier) as TBaseHero;
            _loc2_.Quality = _loc3_.Quality;
            _loc1_++;
         }
      }
      
      protected function UpdateRoleModel() : void
      {
         var _loc1_:THero = null;
         var _loc2_:TBaseHero = null;
         if(this.FHeros.Count <= this.FTabHeroIndex)
         {
            this.FTabHeroIndex = 0;
         }
         _loc1_ = this.FHeros.GetHeroByIndex(this.FTabHeroIndex);
         this.FUIHero.Context = _loc1_;
         RenderCharacterTags();
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,_loc1_.Identifier) as TBaseHero;
         this.FMC_Assess.gotoAndStop(_loc2_.Assess);
      }
      
      protected function CharacterUpdateBaseInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:THero = null;
         var _loc3_:uint = 0;
         var _loc4_:THeroExp = null;
         var _loc5_:UInt64 = null;
         var _loc6_:UInt64 = null;
         var _loc7_:Number = Number(NaN);
         var _loc8_:int = 0;
         var _loc9_:TUnlock = null;
         _loc1_ = this.FTabHeroIndex;
         _loc2_ = this.FHeros.GetHeroByIndex(_loc1_);
         _loc3_ = _loc2_.RebirthLevel;
         this.FTF_Level.text = _loc3_.toString();
         this.FMC_Profession.gotoAndStop(_loc2_.Profession);
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HeroExp,_loc2_.RebirthLevel) as THeroExp;
         _loc5_ = _loc2_.Experience;
         _loc6_ = this.FRebirthData.CalNeedExpByUInt64(_loc4_.NeedExp,_loc2_.RebirthNum);
         this.FTF_Experience.text = TUtilityString.Format(this.StringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_03),_loc5_.ToString(),_loc6_.ToString());
         _loc7_ = _loc5_.ToNumber() / _loc6_.ToNumber();
         if(_loc7_ > 1)
         {
            _loc7_ = 1;
         }
         this.FMC_ProgressBarExp.scaleX = _loc7_;
         this.FTF_Talent.text = _loc2_.TalentName;
         this.FTF_PvPTalent.text = _loc2_.TalentName;
         switch(_loc2_.Profession)
         {
            case PROFESSION_Agility:
            case PROFESSION_Strength:
               _loc8_ = int(INDEX_TACTICALDEPLOYMENT_MIDDLE);
               break;
            case PROFESSION_Defending:
               _loc8_ = int(INDEX_TACTICALDEPLOYMENT_BEFORE);
               break;
            case PROFESSION_Intellect:
               if(_loc2_.IsMain)
               {
                  _loc8_ = int(INDEX_TACTICALDEPLOYMENT_MIDDLE);
               }
               else
               {
                  _loc8_ = int(INDEX_TACTICALDEPLOYMENT_AFTER);
               }
         }
         switch(_loc8_)
         {
            case 1:
               this.FTF_TacticalDeployment.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_16);
               this.FTF_PvPTacticalDeployment.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_16);
               break;
            case 2:
               this.FTF_TacticalDeployment.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_17);
               this.FTF_PvPTacticalDeployment.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_17);
               break;
            case 3:
               this.FTF_TacticalDeployment.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_18);
               this.FTF_PvPTacticalDeployment.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_18);
         }
         if(this.FKnifeOfKillSoulData != null)
         {
            this.FTF_KnifeOfKillSoul.text = this.FKnifeOfKillSoulData.Name;
            this.FTF_PvPKnifeOfKillSoul.text = this.FKnifeOfKillSoulData.Name;
         }
         else
         {
            this.FTF_KnifeOfKillSoul.text = "";
            this.FTF_PvPKnifeOfKillSoul.text = "";
         }
         this.FKnifeOfKillSoulInforTip.KnifeData = this.FKnifeOfKillSoulData;
         _loc9_ = SLogicsCore.Unlocks.GetUnlockByIdentifier(CONST_FUNCTIONSWITCH.UNLOCK_CrashJade);
         if(_loc9_ != null)
         {
            if(_loc9_.State == TUnlock.UNLOCKSTATE_ForcedOff)
            {
               this.FBtnCrashJade.Visible = false;
            }
            else if(_loc9_.State == TUnlock.UNLOCKSTATE_Unlocked)
            {
               this.FBtnCrashJade.Visible = true;
            }
         }
         _loc9_ = SLogicsCore.Unlocks.GetUnlockByIdentifier(CONST_FUNCTIONSWITCH.UNLOCK_AccessoryReinforce);
         if(_loc9_ != null)
         {
            if(_loc9_.State == TUnlock.UNLOCKSTATE_ForcedOff)
            {
               this.FUITabWindow.SetTabHideByIndex(1);
            }
            else if(_loc9_.State == TUnlock.UNLOCKSTATE_Unlocked)
            {
               this.FUITabWindow.SetTabShowByIndex(1);
            }
         }
         this.RenderHeroChange();
      }
      
      protected function RenderHeroChange() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:THeroChangeAttr = null;
         var _loc4_:THero = null;
         var _loc5_:int = 0;
         _loc4_ = this.FHeros.GetHeroByIndex(this.FTabHeroIndex);
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HeroChangeAttr,_loc4_.Identifier) as THeroChangeAttr;
         if(_loc3_ == null || this.FCurWindowType == TYPE_ORNAMENT)
         {
            this.FHeroChangeStar.visible = false;
            this.FProfileStarMarker.visible = false;
            if(this.FMcHeroState != null)
            {
               this.FMcHeroState.visible = false;
            }
            return;
         }
         this.FHeroChangeStar.visible = true;
         _loc5_ = int(TProcessorWindowHeroChangeMainUI.StarCounts[String(_loc4_.Identifier)]);
         this.FProfileStarBadge.text = "x " + _loc5_;
         this.FProfileStarMarker.visible = true;
         this.FProfileStarMarker.parent.setChildIndex(this.FProfileStarMarker,this.FProfileStarMarker.parent.numChildren - 1);
         _loc1_ = 0;
         while(_loc1_ < MaxStarNum)
         {
            this.FHeroChangeLightStars[_loc1_].visible = _loc1_ < _loc4_.ChangeSchedule;
            this.FHeroChangeDarkStars[_loc1_].visible = _loc1_ < _loc3_.HeroStar.length;
            _loc1_++;
         }
         if(this.FMcHeroState != null)
         {
            this.FMcHeroState.visible = _loc4_.HeroOverTime != 0;
         }
      }
      
      protected function CharacterUpdateBaseAttributes() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:THero = null;
         var _loc5_:String = null;
         var _loc6_:TextField = null;
         var _loc7_:Vector.<String> = null;
         _loc3_ = this.FTabHeroIndex;
         _loc7_ = new Vector.<String>();
         _loc4_ = this.FHeros.GetHeroByIndex(_loc3_);
         _loc2_ = int(CAPACITY_TF_BaseAttributes);
         if(_loc4_.Profession == 3 || _loc4_.Profession == 5)
         {
            this.FMC_AttackType.gotoAndStop(2);
            this.FMC_PvPAttackType.gotoAndStop(2);
            _loc5_ = _loc4_.BaseAttributeMagicAttack.toString();
         }
         else
         {
            this.FMC_AttackType.gotoAndStop(1);
            this.FMC_PvPAttackType.gotoAndStop(1);
            _loc5_ = _loc4_.BaseAttributePhysicalAttack.toString();
         }
         _loc7_.push(_loc5_);
         _loc5_ = _loc4_.BaseAttributePhysicalDefends.toString();
         _loc7_.push(_loc5_);
         _loc5_ = _loc4_.ChangeSchedule == 0 ? TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_19) : this.FChangeLevelNames[_loc4_.ChangeSchedule - 1];
         _loc7_.push(_loc5_);
         _loc5_ = _loc4_.BaseAttributeMagicDefends.toString();
         _loc7_.push(_loc5_);
         _loc5_ = _loc4_.BaseAttributeHealth.toString();
         _loc7_.push(_loc5_);
         _loc5_ = _loc4_.BaseAttributeSpeed.toString();
         _loc7_.push(_loc5_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.SetBaseAttributeByIndex(this.FTF_BaseAttributes,_loc7_[_loc1_],_loc1_);
            _loc1_++;
         }
         this.FTF_FightingCapacity.text = _loc4_.BaseAttributeFightingPower.toString();
      }
      
      protected function CharacterUpdatePvPAttributes() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:THero = null;
         var _loc5_:String = null;
         var _loc6_:TextField = null;
         var _loc7_:Vector.<String> = null;
         _loc3_ = this.FTabHeroIndex;
         _loc7_ = new Vector.<String>();
         _loc4_ = this.FHeros.GetHeroByIndex(_loc3_);
         _loc2_ = int(CAPACITY_TF_BaseAttributes);
         if(_loc4_.Profession == 3 || _loc4_.Profession == 5)
         {
            this.FMC_AttackType.gotoAndStop(2);
            this.FMC_PvPAttackType.gotoAndStop(2);
            _loc5_ = _loc4_.PvPAttributeMagicAttack.toString();
         }
         else
         {
            this.FMC_AttackType.gotoAndStop(1);
            this.FMC_PvPAttackType.gotoAndStop(1);
            _loc5_ = _loc4_.PvPAttributePhysicalAttack.toString();
         }
         _loc7_.push(_loc5_);
         _loc5_ = _loc4_.PvPAttributePhysicalDefends.toString();
         _loc7_.push(_loc5_);
         _loc5_ = _loc4_.ChangeSchedule == 0 ? TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_19) : this.FChangeLevelNames[_loc4_.ChangeSchedule - 1];
         _loc7_.push(_loc5_);
         _loc5_ = _loc4_.PvPAttributeMagicDefends.toString();
         _loc7_.push(_loc5_);
         _loc5_ = _loc4_.PvPAttributeHealth.toString();
         _loc7_.push(_loc5_);
         _loc5_ = _loc4_.PvPAttributeSpeed.toString();
         _loc7_.push(_loc5_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.SetBaseAttributeByIndex(this.FTF_PvPBaseAttributes,_loc7_[_loc1_],_loc1_);
            _loc1_++;
         }
         this.FTF_FightingCapacity.text = _loc4_.BaseAttributeFightingPower.toString();
      }
      
      protected function InventoriesUpdateEquipmentsMounted() : void
      {
         var _loc1_:int = 0;
         var _loc2_:THero = null;
         _loc1_ = this.FTabHeroIndex;
         _loc2_ = this.FHeros.GetHeroByIndex(_loc1_);
         switch(this.FCurWindowType)
         {
            case TYPE_EQUIPMENT:
               this.InventoriesUpdateSlotsByCollection(this.FSlotsEquipmentMounted,_loc2_.EquipmentsMounted);
               break;
            case TYPE_ORNAMENT:
               this.InventoriesUpdateSlotsByCollection(this.FSlotsOrnamentMounted,_loc2_.OrnamentsMounted);
         }
      }
      
      protected function ProcessorAllHeroEquipmentMountedSuitCount() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THero = null;
         var _loc6_:THeros = null;
         var _loc7_:TCollectionInventory = null;
         var _loc8_:TEquipment = null;
         var _loc9_:Vector.<uint> = null;
         var _loc10_:int = 0;
         var _loc11_:uint = 0;
         _loc9_ = new Vector.<uint>();
         _loc6_ = this.FHeros;
         _loc2_ = _loc6_.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = _loc6_.GetHeroByIndex(_loc1_);
            _loc7_ = _loc5_.EquipmentsMounted;
            _loc4_ = _loc7_.Capacity;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc8_ = _loc7_.GetInventoryByIndex(_loc3_) as TEquipment;
               if(_loc8_ != null)
               {
                  _loc10_ = _loc9_.indexOf(_loc8_.SuitID);
                  if(_loc10_ < 0)
                  {
                     _loc9_.push(_loc8_.SuitID);
                     _loc11_ = _loc5_.GetSuitCountByEquipment(_loc8_);
                     _loc5_.SetSuitCount(_loc8_,_loc11_);
                  }
               }
               _loc3_++;
            }
            _loc9_.length = 0;
            _loc7_ = _loc5_.OrnamentsMounted;
            _loc4_ = _loc7_.Capacity;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc8_ = _loc7_.GetInventoryByIndex(_loc3_) as TEquipment;
               if(_loc8_ != null)
               {
                  _loc10_ = _loc9_.indexOf(_loc8_.SuitID);
                  if(_loc10_ < 0)
                  {
                     _loc9_.push(_loc8_.SuitID);
                     _loc11_ = _loc5_.GetSuitCountByOrnament(_loc8_);
                     _loc5_.SetOrnamentSuitCount(_loc8_,_loc11_);
                  }
               }
               _loc3_++;
            }
            _loc9_.length = 0;
            _loc7_ = _loc5_.TalismansMounted;
            _loc4_ = _loc7_.Capacity;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc8_ = _loc7_.GetInventoryByIndex(_loc3_) as TEquipment;
               if(_loc8_ != null)
               {
                  _loc11_ = _loc5_.GetSuitCountByTalisman(_loc8_);
                  _loc5_.SetTreasureSuitCount(_loc8_,_loc11_);
               }
               _loc3_++;
            }
            _loc1_++;
         }
      }
      
      protected function CharacterUpdateSkills() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:THero = null;
         var _loc5_:TSkill = null;
         var _loc6_:TSkills = null;
         var _loc7_:MovieClip = null;
         _loc3_ = this.FTabHeroIndex;
         _loc4_ = this.FHeros.GetHeroByIndex(_loc3_);
         _loc5_ = _loc4_.Skill;
         this.FTF_SkillAttack.text = _loc5_.Name;
         this.FTF_PvPSkillAttack.text = _loc5_.Name;
      }
      
      protected function UpdateHeroInformation() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:THero = null;
         var _loc4_:Number = Number(NaN);
         _loc3_ = this.FHeros.GetHeroByIndex(this.FTabHeroIndex);
         _loc2_ = this.FBaseAttibutes.length;
         this.FBaseAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_Power] = _loc3_.BaseAttributePower;
         this.FBaseAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_Intelligence] = _loc3_.BaseAttributeIntelligence;
         this.FBaseAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_Life] = _loc3_.BaseAttributeLife;
         this.FBaseAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_Agile] = _loc3_.BaseAttributeAgile;
         this.FBaseAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_Speed] = _loc3_.BaseAttributeSpeed;
         this.FBaseAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_Health] = _loc3_.BaseAttributeHealth;
         this.FMC_OpeningState["MC_Attack"].gotoAndStop(1);
         if(_loc3_.Profession == 3 || _loc3_.Profession == 5)
         {
            this.FBaseAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_Attack] = 0;
            this.FBaseAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_MagicAttack] = _loc3_.BaseAttributeMagicAttack;
         }
         else
         {
            this.FBaseAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_Attack] = _loc3_.BaseAttributePhysicalAttack;
            this.FBaseAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_MagicAttack] = 0;
         }
         this.FBaseAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_Hurt] = _loc3_.BaseAttributeHurt;
         this.FBaseAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_PhysicalDefends] = _loc3_.BaseAttributePhysicalDefends;
         this.FBaseAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_MagicDefends] = _loc3_.BaseAttributeMagicDefends;
         this.FBaseAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_Hit] = _loc3_.BaseAttributeHit;
         this.FBaseAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_Dodge] = _loc3_.BaseAttributeDodge;
         this.FBaseAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_Crit] = _loc3_.BaseAttributeCrit;
         this.FBaseAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_Uprising] = _loc3_.BaseAttributeUprising;
         this.FBaseAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_Wreck] = _loc3_.BaseAttributeWreck;
         this.FBaseAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_GridFile] = _loc3_.BaseAttributeGridFile;
         this.FBaseAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_Punch] = _loc3_.BaseAttributePunch;
         this.FBaseAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_Help] = _loc3_.BaseAttributeHelp;
         this.FBaseAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_InjuryFree] = _loc3_.BaseAttributeAvoidhurtRate;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc1_ > 9)
            {
               this.SetPercentSign(_loc1_,"%");
            }
            else
            {
               this.SetPercentSign(_loc1_,"");
            }
            _loc1_++;
         }
      }
      
      protected function UpdateHeroPvPInformation() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:THero = null;
         var _loc4_:Number = Number(NaN);
         _loc3_ = this.FHeros.GetHeroByIndex(this.FTabHeroIndex);
         _loc2_ = this.FPvPAttibutes.length;
         this.FPvPAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_Power] = _loc3_.PvPAttributePower;
         this.FPvPAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_Intelligence] = _loc3_.PvPAttributeIntelligence;
         this.FPvPAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_Life] = _loc3_.PvPAttributeLife;
         this.FPvPAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_Agile] = _loc3_.PvPAttributeAgile;
         this.FPvPAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_Speed] = _loc3_.PvPAttributeSpeed;
         this.FPvPAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_Health] = _loc3_.PvPAttributeHealth;
         this.FMC_PvPOpeningState["MC_Attack"].gotoAndStop(1);
         if(_loc3_.Profession == 3 || _loc3_.Profession == 5)
         {
            this.FPvPAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_Attack] = 0;
            this.FPvPAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_MagicAttack] = _loc3_.PvPAttributeMagicAttack;
         }
         else
         {
            this.FPvPAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_Attack] = _loc3_.PvPAttributePhysicalAttack;
            this.FPvPAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_MagicAttack] = 0;
         }
         this.FPvPAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_Hurt] = _loc3_.PvPAttributeHurt;
         this.FPvPAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_PhysicalDefends] = _loc3_.PvPAttributePhysicalDefends;
         this.FPvPAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_MagicDefends] = _loc3_.PvPAttributeMagicDefends;
         this.FPvPAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_Hit] = _loc3_.PvPAttributeHit;
         this.FPvPAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_Dodge] = _loc3_.PvPAttributeDodge;
         this.FPvPAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_Crit] = _loc3_.PvPAttributeCrit;
         this.FPvPAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_Uprising] = _loc3_.PvPAttributeUprising;
         this.FPvPAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_Wreck] = _loc3_.PvPAttributeWreck;
         this.FPvPAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_GridFile] = _loc3_.PvPAttributeGridFile;
         this.FPvPAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_Punch] = _loc3_.PvPAttributePunch;
         this.FPvPAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_Help] = _loc3_.PvPAttributeHelp;
         this.FPvPAttibutes[CONST_HEROS.BASEATTRIBUTEINDEX_InjuryFree] = _loc3_.PvPAttributeAvoidhurtRate;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc1_ > 9)
            {
               this.SetPvPPercentSign(_loc1_,"%");
            }
            else
            {
               this.SetPvPPercentSign(_loc1_,"");
            }
            _loc1_++;
         }
      }
      
      protected function SetPercentSign(param1:int, param2:String) : void
      {
         this.FMC_ClosingState["TF_Property_" + param1].text = this.FBaseAttibutes[param1] + param2;
         this.FMC_ClosingState["TF_Property_" + param1].mouseEnabled = false;
         this.FMC_OpeningState["TF_Property_" + param1].text = this.FBaseAttibutes[param1] + param2;
         this.FMC_OpeningState["TF_Property_" + param1].mouseEnabled = false;
      }
      
      protected function SetPvPPercentSign(param1:int, param2:String) : void
      {
         this.FMC_PvPClosingState["TF_Property_" + param1].text = this.FPvPAttibutes[param1] + param2;
         this.FMC_PvPClosingState["TF_Property_" + param1].mouseEnabled = false;
         this.FMC_PvPOpeningState["TF_Property_" + param1].text = this.FPvPAttibutes[param1] + param2;
         this.FMC_PvPOpeningState["TF_Property_" + param1].mouseEnabled = false;
      }
      
      protected function InventoriesUpdateSlotsByCollection(param1:Vector.<TUISlot>, param2:TCollectionInventory) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = param2.Capacity;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            if(param1[_loc4_] != null)
            {
               param1[_loc4_].Context = null;
            }
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            param1[_loc4_].Context = param2.GetInventoryByIndex(_loc4_);
            _loc4_++;
         }
      }
      
      protected function GetBinExp(param1:uint) : Number
      {
         var _loc2_:THeroExp = null;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HeroExp,param1) as THeroExp;
         if(_loc2_ != null)
         {
            return _loc2_.AllExp.ToNumber();
         }
         return 0;
      }
      
      protected function CheckEquipmentMouted(param1:Function, param2:TInventory) : void
      {
         var _loc3_:THero = null;
         var _loc4_:THeros = null;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc7_:TInventory = null;
         _loc3_ = this.FHeros.GetHeroByIndex(this.FTabHeroIndex);
         if(param2.Category == 2)
         {
            _loc6_ = CAPACITY_EquipmentsMounted_Slots;
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               _loc7_ = _loc3_.EquipmentsMounted.GetInventoryByIndex(_loc5_);
               if(_loc7_ != null && _loc7_ != param2 && _loc7_.CategorySecond == param2.CategorySecond)
               {
                  if(param1 != null)
                  {
                     param1(this,param2);
                  }
                  return;
               }
               _loc5_++;
            }
            if(param1 != null)
            {
               param1(this,param2);
            }
         }
         else if(param2.Category == 6)
         {
            _loc6_ = CAPACITY_OrnamentMounted_Slots;
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               _loc7_ = _loc3_.OrnamentsMounted.GetInventoryByIndex(_loc5_);
               if(_loc7_ != null && _loc7_ != param2 && _loc7_.CategorySecond == param2.CategorySecond)
               {
                  if(param1 != null)
                  {
                     param1(this,param2);
                  }
                  return;
               }
               _loc5_++;
            }
            if(param1 != null)
            {
               param1(this,param2);
            }
         }
         else if(param1 != null)
         {
            param1(this,param2);
         }
      }
      
      protected function StringByIdentifier(param1:uint) : String
      {
         var _loc2_:String = null;
         var _loc3_:TSystemLanguage = null;
         _loc2_ = "";
         _loc3_ = this.FSystemLanguages.GetDatebaseByIdentifier(param1) as TSystemLanguage;
         if(_loc3_ != null)
         {
            _loc2_ = _loc3_.Desc;
         }
         else
         {
            _loc2_ = "ID:" + param1.toString();
         }
         return _loc2_;
      }
      
      protected function CreateBaseKnife() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TBins = null;
         var _loc3_:TKnifeExpand = null;
         var _loc4_:TKnifeOfKillSoulData = null;
         _loc2_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_KnifeExpand);
         _loc1_ = 0;
         while(_loc1_ < _loc2_.Count)
         {
            _loc3_ = _loc2_.GetDatebaseByIndex(_loc1_) as TKnifeExpand;
            _loc4_ = new TKnifeOfKillSoulData();
            _loc4_.ID = _loc3_.Identifier;
            _loc4_.CurrentState = CONST_KNIFEOFKILLSOUL.KNIFESTATE_LackHandBook;
            this.AssignKnifeData(_loc4_);
            this.FKnifeOfkillSoulDatas.Add(_loc4_);
            _loc1_++;
         }
      }
      
      protected function AssignKnifeData(param1:TKnifeOfKillSoulData) : void
      {
         var _loc2_:TKnifeExpand = null;
         var _loc3_:TKnife = null;
         var _loc4_:TArticle = null;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_KnifeExpand,param1.ID) as TKnifeExpand;
         param1.Level = _loc2_.Level;
         param1.SkillID = _loc2_.SkillID;
         param1.NeedKnifeSoulLevel = _loc2_.KnifeSoulLevelNeed;
         param1.Quality = _loc2_.Quality;
         param1.KnifeSoulAdded = _loc2_.KnifeSoulAdded;
         param1.AddedFront = _loc2_.AddedFront;
         param1.AddedMiddle = _loc2_.AddedMiddle;
         param1.AddedBack = _loc2_.AddedBack;
         param1.NormalTrainExp = _loc2_.NormalExp;
         param1.GoldTrainExp = _loc2_.GoldExp;
         param1.NeedExp = _loc2_.NeedExp;
         param1.RelationID = _loc2_.RelationID;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Knife,param1.RelationID) as TKnife;
         param1.Type = _loc3_.TypeID;
         param1.Name = _loc3_.Name;
         param1.HandBook = _loc3_.HandBookID;
         param1.Appraise = _loc3_.Appraise;
         param1.GetRoad = _loc3_.GetRoad;
         param1.AttackAttr = _loc3_.AttackAttr;
         param1.DefenseAttr = _loc3_.DefenseAttr;
         param1.RecoveryAttr = _loc3_.RecoveryAttr;
         param1.ResistanceAttr = _loc3_.ResistanceAttr;
         param1.SpeedAttr = _loc3_.SpeedAttr;
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,param1.HandBook) as TArticle;
         param1.HandBookName = _loc4_.Name;
      }
      
      protected function UpdateSlotsUI() : void
      {
         switch(this.FCurWindowType)
         {
            case TYPE_EQUIPMENT:
               this.FMC_Equipment.visible = true;
               this.FMC_Ornament.visible = false;
               break;
            case TYPE_ORNAMENT:
               this.FMC_Ornament.visible = true;
               this.FMC_Equipment.visible = false;
         }
      }
      
      protected function StarOnMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:THero = null;
         _loc2_ = this.FHeros.GetHeroByIndex(this.FTabHeroIndex);
         SUtilityOverLayer.UIComponentsHintOnOver(this,SLogicsCore.HeroChangeData.GetHeroChangeByHeroID(_loc2_.Identifier));
      }
      
      protected function StarOnMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:THero = null;
         _loc2_ = this.FHeros.GetHeroByIndex(this.FTabHeroIndex);
         SUtilityOverLayer.UIComponentsHintOnOut(this,SLogicsCore.HeroChangeData.GetHeroChangeByHeroID(_loc2_.Identifier));
      }
      
      protected function BtnCrashJadeOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:THero = null;
         var _loc10_:TCrashJade = null;
         _loc9_ = this.FHeros.GetHeroByIndex(this.FTabHeroIndex);
         _loc7_ = 0;
         _loc8_ = "";
         _loc4_ = _loc9_.CrashJadeMounted.Capacity;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc10_ = _loc9_.CrashJadeMounted.GetInventoryByIndex(_loc3_) as TCrashJade;
            if(_loc10_ != null)
            {
               _loc8_ += _loc10_.Name + ":" + "\n";
               _loc6_ = int(_loc10_.AddAttributeType.length);
               _loc5_ = 0;
               while(_loc5_ < _loc6_)
               {
                  _loc8_ += TUtilityString.Format("%0 + %1",TUtilityLobby.GetAttributeName(_loc10_.AddAttributeType[_loc5_]),_loc10_.AddAttributeValue[_loc5_] <= 1 ? (_loc10_.AddAttributeValue[_loc5_] * 100).toFixed(2) + "%" : _loc10_.AddAttributeValue[_loc5_]);
                  _loc8_ += "\n";
                  _loc5_++;
               }
               _loc8_ += "\n";
            }
            _loc3_++;
         }
         _loc8_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_11),_loc7_) + "\n" + _loc8_;
         this.FHint.Caption = _loc8_;
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function BtnCrashJadeOnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      protected function TabWindowOnSwitch(param1:Object) : void
      {
         this.FCurWindowType = param1 as uint;
         this.UpdateSlotsUI();
         this.InventoriesUpdateEquipmentsMounted();
         this.FAttributeTab.SwithTagManual(0);
      }
      
      protected function TabHerosOnSwitch(param1:Object) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1 as int;
         this.FTabHeroIndex = _loc2_ + CAPACITY_TF_HerosName * this.FHeroPageIndex;
         this.FCurrentPageStore = this.FHeroPageIndex;
         this.UpdateRoleModel();
         this.CharacterUpdateBaseInfo();
         this.CharacterUpdateBaseAttributes();
         this.CharacterUpdatePvPAttributes();
         this.CharacterUpdateOrnamentPvPAttributes();
         this.CharacterUpdateOrnamentBaseAttributes();
         this.CharacterUpdateSkills();
         this.InventoriesUpdateEquipmentsMounted();
         this.UpdateHeroInformation();
         this.UpdateHeroPvPInformation();
      }
      
      protected function HeroPageOnChange(param1:Object, param2:int) : void
      {
         this.FHeroPageIndex = param2;
         this.FTabHeroIndex = 0;
         this.UpdateTabs();
         this.FUITabHeros.SwithTagManual(this.FTabHeroIndex);
      }
      
      protected function SlotsOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TInventory = null;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         _loc5_ = param2 as TInventory;
         _loc6_ = SResourcesCore.TexturesInventory;
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc5_.IDTexture);
         if(_loc7_ != null)
         {
            param3.Value = _loc7_.GetAnimationSequenceByIdentifier(param4);
         }
         else
         {
            _loc6_.LoadSecondary(_loc5_.IDTexture);
         }
      }
      
      protected function SlotsOnQueryEdgeColor(param1:Object, param2:Object, param3:TQueryUInt) : void
      {
         var _loc4_:TEquipment = null;
         if(param2 is TEquipment)
         {
            _loc4_ = param2 as TEquipment;
            param3.Value = _loc4_.IsEdgeColor;
         }
      }
      
      protected function SlotsOnQueryEuqipLevel(param1:Object, param2:Object, param3:TQueryString) : void
      {
         var _loc4_:TEquipment = null;
         if(param2 is TEquipment)
         {
            _loc4_ = param2 as TEquipment;
            if(_loc4_.UpgradingLevel > 0)
            {
               param3.Value = "Lv." + _loc4_.UpgradingLevel.toString();
            }
         }
      }
      
      protected function SlotsOnMove(param1:Object, param2:TInventory) : void
      {
         this.CheckEquipmentMouted(this.FOnInventoryOver,param2);
      }
      
      protected function SlotsOnOut(param1:Object, param2:TInventory) : void
      {
         this.CheckEquipmentMouted(this.FOnInventoryOut,param2);
      }
      
      protected function ButtonCloseOnClick(param1:MouseEvent) : void
      {
         TProcessorWindowHeroChangeMainUI.RequestStarInfo();
         this.Hide();
      }
      
      protected function BtnTreasureHintOnOver(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:THero = null;
         var _loc8_:TCollectionInventory = null;
         var _loc9_:TEquipment = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         _loc5_ = "";
         _loc6_ = this.FTabHeroIndex;
         _loc4_ = this.FHeros.Count;
         _loc7_ = this.FHeros.GetHeroByIndex(_loc6_);
         _loc8_ = _loc7_.TalismansMounted;
         _loc4_ = _loc8_.Capacity;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc10_ = _loc7_.GetFirstAttributeByIndex(_loc3_).toFixed();
            _loc9_ = _loc8_.GetInventoryByIndex(_loc3_) as TEquipment;
            if(_loc9_ != null && !TUtilityString.Empty(_loc10_))
            {
               _loc11_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRINGS_TreasuresAttributeCaption)[_loc9_.CategorySecond % CATEGORY_TreasurePower];
               _loc5_ += TUtilityString.Format(this.StringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_04),_loc9_.Name,_loc11_,_loc10_);
            }
            _loc3_++;
         }
         if(!TUtilityString.Empty(_loc5_))
         {
            this.FHint.Caption = _loc5_;
            if(this.FHintOnOver != null)
            {
               this.FHintOnOver(this,this.FHint);
            }
         }
      }
      
      protected function BtnTreasureHintOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHint);
         }
      }
      
      protected function BtnOpenInfomationOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.UpdateHeroInformation();
         this.FMC_CLoseInfomation.gotoAndPlay(1);
      }
      
      protected function PvPBtnOpenInfomationOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.UpdateHeroPvPInformation();
         this.FMC_PvPCLoseInfomation.gotoAndPlay(1);
      }
      
      protected function BtnCloseInfomationOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FMC_OpenInfomation.gotoAndPlay(1);
      }
      
      protected function PvPBtnCloseInfomationOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FMC_PvPOpenInfomation.gotoAndPlay(1);
      }
      
      protected function CheckEquipMentsMounted() : Boolean
      {
         var _loc1_:uint = 0;
         var _loc2_:THero = null;
         var _loc3_:int = 0;
         var _loc4_:TInventory = null;
         _loc2_ = this.FHeros.GetHeroByIndex(this.FTabHeroIndex);
         _loc1_ = uint(_loc2_.EquipmentsMounted.Capacity);
         _loc3_ = 0;
         while(_loc3_ < _loc1_)
         {
            _loc4_ = _loc2_.EquipmentsMounted.GetInventoryByIndex(_loc3_);
            if(_loc4_ != null)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      protected function CheckTalismanMounted() : Boolean
      {
         var _loc1_:uint = 0;
         var _loc2_:THero = null;
         var _loc3_:int = 0;
         var _loc4_:TInventory = null;
         _loc2_ = this.FHeros.GetHeroByIndex(this.FTabHeroIndex);
         _loc1_ = uint(_loc2_.TalismansMounted.Capacity);
         _loc3_ = 0;
         while(_loc3_ < _loc1_)
         {
            _loc4_ = _loc2_.TalismansMounted.GetInventoryByIndex(_loc3_);
            if(_loc4_ != null)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      protected function TFBaseAttributesHintOnOver(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TextField = null;
         var _loc5_:THero = null;
         var _loc6_:TBaseHero = null;
         var _loc7_:String = null;
         _loc4_ = param1.currentTarget as TextField;
         _loc2_ = this.FTF_BaseAttributes.indexOf(_loc4_);
         if(_loc2_ == -1)
         {
            _loc2_ = this.FTF_PvPBaseAttributes.indexOf(_loc4_);
         }
         _loc3_ = this.FTabHeroIndex;
         _loc5_ = this.FHeros.GetHeroByIndex(_loc3_);
         if(_loc5_.Profession == 3 || _loc5_.Profession == 5)
         {
            _loc7_ = this.StringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_20);
         }
         else
         {
            _loc7_ = this.StringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_18);
         }
         switch(_loc2_)
         {
            case 0:
               this.FHint.Caption = _loc7_;
               break;
            case 1:
               this.FHint.Caption = this.StringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_19);
               break;
            case 2:
               this.FHint.Caption = this.StringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_21);
               break;
            case 3:
               this.FHint.Caption = this.StringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_22);
               break;
            case 4:
               this.FHint.Caption = this.StringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_23);
               break;
            case 5:
               this.FHint.Caption = this.StringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_24);
         }
         if(this.FHintOnOver != null)
         {
            this.FHintOnOver(this,this.FHint);
         }
      }
      
      protected function TFTalentHintOnOver(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:THero = null;
         _loc2_ = this.FTabHeroIndex;
         _loc3_ = this.FHeros.GetHeroByIndex(_loc2_);
         this.FHint.Caption = _loc3_.TalentDesc;
         if(this.FHintOnOver != null)
         {
            this.FHintOnOver(this,this.FHint);
         }
      }
      
      protected function MC_AssessHintOnOver(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TextField = null;
         var _loc5_:THero = null;
         var _loc6_:TBaseHero = null;
         var _loc7_:Number = Number(NaN);
         var _loc8_:Number = Number(NaN);
         var _loc9_:Number = Number(NaN);
         var _loc10_:Number = Number(NaN);
         var _loc11_:String = null;
         _loc11_ = "";
         _loc3_ = this.FTabHeroIndex;
         _loc5_ = this.FHeros.GetHeroByIndex(_loc3_);
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,_loc5_.Identifier) as TBaseHero;
         _loc7_ = _loc6_.PowerGrow;
         _loc9_ = _loc6_.AgileGrow;
         _loc8_ = _loc6_.IntelligenceGrow;
         _loc10_ = _loc6_.LifeGrow;
         if(_loc3_ == 0)
         {
            _loc7_ = _loc5_.FirstAttributePowerRate;
            _loc8_ = _loc5_.FirstAttributeIntelligenceRate;
            _loc9_ = _loc5_.FirstAttributeAgileRate;
            _loc10_ = _loc5_.FirstAttributeHealthRate;
         }
         _loc11_ += TUtilityString.Format(this.StringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_14),_loc7_);
         _loc11_ += TUtilityString.Format(this.StringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_15),_loc8_);
         _loc11_ += TUtilityString.Format(this.StringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_16),_loc9_);
         _loc11_ += TUtilityString.Format(this.StringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_17),_loc10_);
         this.FHint.Caption = _loc11_;
         if(this.FHintOnOver != null)
         {
            this.FHintOnOver(this,this.FHint);
         }
      }
      
      protected function TFHintOnOut(param1:Object) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHint);
         }
      }
      
      protected function OnMouseDown(param1:MouseEvent) : void
      {
         this.startDrag();
      }
      
      protected function OnMouseUP(param1:MouseEvent) : void
      {
         this.stopDrag();
      }
      
      protected function KnifeOfKillSoulOnMove(param1:MouseEvent) : void
      {
         if(this.FKnifeOfKillSoulData != null)
         {
            this.FKnifeOfKillSoulInforTip.visible = true;
         }
      }
      
      protected function KnifeOfKillSoulOnOut(param1:MouseEvent) : void
      {
         this.FKnifeOfKillSoulInforTip.visible = false;
      }
      
      protected function TFSkillAttackHintOnOver(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:THero = null;
         var _loc4_:TSkill = null;
         _loc2_ = this.FTabHeroIndex;
         _loc3_ = this.FHeros.GetHeroByIndex(_loc2_);
         _loc4_ = _loc3_.Skill;
         if(_loc2_ == 0)
         {
            if(this.FOnSkillOver != null)
            {
               this.FOnSkillOver(this,_loc4_);
            }
         }
         else
         {
            this.FHint.Caption = _loc4_.Description;
            if(this.FHintOnOver != null)
            {
               this.FHintOnOver(this,this.FHint);
            }
         }
      }
      
      private function TFSkillAttackHintOnOut(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:THero = null;
         var _loc4_:TSkill = null;
         _loc3_ = this.FHeros.GetHeroByIndex(_loc2_);
         _loc4_ = _loc3_.Skill;
         _loc2_ = this.FTabHeroIndex;
         if(_loc2_ == 0)
         {
            if(this.FOnSkillOut != null)
            {
               this.FOnSkillOut(this,_loc4_);
            }
         }
         else if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHint);
         }
      }
      
      protected function SwithAttributeTab(param1:int) : void
      {
         if(param1 == 0)
         {
            if(this.FCurWindowType == TYPE_EQUIPMENT)
            {
               this.FMC_PvPAttribute.visible = false;
               this.FMC_NormalAttribute.visible = true;
               this.FMC_OrnamentNormalAttribute.visible = false;
               this.FMC_OrnamentPvPAttribute.visible = false;
               this.FHeroChangeStar.visible = true;
            }
            else
            {
               this.FMC_PvPAttribute.visible = false;
               this.FMC_NormalAttribute.visible = false;
               this.FMC_OrnamentNormalAttribute.visible = true;
               this.FMC_OrnamentPvPAttribute.visible = false;
               this.FHeroChangeStar.visible = false;
            }
            this.FMC_PvPInformation.visible = false;
            this.FMC_Information.visible = true;
            this.CharacterUpdateOrnamentBaseAttributes();
            this.CharacterUpdateBaseAttributes();
            this.UpdateHeroInformation();
         }
         else
         {
            if(this.FCurWindowType == TYPE_EQUIPMENT)
            {
               this.FMC_NormalAttribute.visible = false;
               this.FMC_PvPAttribute.visible = true;
               this.FMC_OrnamentNormalAttribute.visible = false;
               this.FMC_OrnamentPvPAttribute.visible = false;
            }
            else
            {
               this.FMC_NormalAttribute.visible = false;
               this.FMC_PvPAttribute.visible = false;
               this.FMC_OrnamentNormalAttribute.visible = false;
               this.FMC_OrnamentPvPAttribute.visible = true;
            }
            this.FMC_Information.visible = false;
            this.FMC_PvPInformation.visible = true;
            this.CharacterUpdatePvPAttributes();
            this.CharacterUpdateOrnamentPvPAttributes();
            this.CharacterUpdateOrnamentBaseAttributes();
            this.UpdateHeroPvPInformation();
         }
      }
      
      protected function CharacterUpdateOrnamentBaseAttributes() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THero = null;
         var _loc6_:String = null;
         var _loc7_:TextField = null;
         var _loc8_:Vector.<String> = null;
         _loc4_ = this.FTabHeroIndex;
         _loc8_ = new Vector.<String>();
         _loc5_ = this.FHeros.GetHeroByIndex(_loc4_);
         _loc6_ = _loc5_.BaseAttributePower.toString();
         _loc8_.push(_loc6_);
         _loc6_ = _loc5_.BaseAttributeSpeed.toString();
         _loc8_.push(_loc6_);
         _loc6_ = _loc5_.BaseAttributeAgile.toString();
         _loc8_.push(_loc6_);
         _loc6_ = _loc5_.BaseAttributeHealth.toString();
         _loc8_.push(_loc6_);
         _loc6_ = _loc5_.BaseAttributeIntelligence.toString();
         _loc8_.push(_loc6_);
         _loc2_ = 4;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc1_ < this.GetEffectStrByHero(_loc5_).length)
            {
               _loc6_ = this.GetEffectStrByHero(_loc5_)[_loc1_];
            }
            else
            {
               _loc6_ = "";
            }
            _loc8_.push(_loc6_);
            _loc1_++;
         }
         _loc2_ = int(CAPACITY_TF_OrnamentBaseAttributes);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.SetBaseAttributeByIndex(this.FTF_OrnamentNormalAttributes,_loc8_[_loc1_],_loc1_);
            _loc1_++;
         }
      }
      
      protected function CharacterUpdateOrnamentPvPAttributes() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THero = null;
         var _loc6_:String = null;
         var _loc7_:TextField = null;
         var _loc8_:Vector.<String> = null;
         _loc4_ = this.FTabHeroIndex;
         _loc8_ = new Vector.<String>();
         _loc5_ = this.FHeros.GetHeroByIndex(_loc4_);
         _loc6_ = _loc5_.PvPAttributePower.toString();
         _loc8_.push(_loc6_);
         _loc6_ = _loc5_.PvPAttributeSpeed.toString();
         _loc8_.push(_loc6_);
         _loc6_ = _loc5_.PvPAttributeAgile.toString();
         _loc8_.push(_loc6_);
         _loc6_ = _loc5_.PvPAttributeHealth.toString();
         _loc8_.push(_loc6_);
         _loc6_ = _loc5_.PvPAttributeIntelligence.toString();
         _loc8_.push(_loc6_);
         _loc2_ = 4;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc1_ < this.GetEffectStrByHero(_loc5_).length)
            {
               _loc6_ = this.GetEffectStrByHero(_loc5_)[_loc1_];
            }
            else
            {
               _loc6_ = "";
            }
            _loc8_.push(_loc6_);
            _loc1_++;
         }
         _loc2_ = int(CAPACITY_TF_OrnamentBaseAttributes);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.SetBaseAttributeByIndex(this.FTF_OrnamentPvPAttributes,_loc8_[_loc1_],_loc1_);
            _loc1_++;
         }
      }
      
      protected function GetEffectStrByHero(param1:THero) : Vector.<String>
      {
         var _loc2_:Vector.<String> = null;
         var _loc3_:Vector.<uint> = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:TEquipment = null;
         var _loc11_:TSuitEffect = null;
         var _loc12_:String = null;
         var _loc13_:TSuitEffects = null;
         var _loc14_:uint = 0;
         var _loc15_:String = null;
         var _loc16_:int = 0;
         var _loc17_:String = null;
         _loc3_ = new Vector.<uint>();
         _loc2_ = new Vector.<String>();
         _loc5_ = param1.OrnamentsMounted.Capacity;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc10_ = param1.OrnamentsMounted.GetInventoryByIndex(_loc4_) as TEquipment;
            if(_loc10_ != null)
            {
               if(_loc3_.indexOf(_loc10_.SuitID) == -1 && _loc10_.SuitCount >= 2)
               {
                  _loc15_ = "";
                  _loc12_ = "";
                  _loc3_.push(_loc10_.SuitID);
                  _loc13_ = _loc10_.SuitData.SuitEffects;
                  _loc9_ = _loc13_.Count;
                  _loc17_ = _loc10_.SuitData.Name;
                  _loc8_ = 0;
                  while(_loc8_ < _loc9_)
                  {
                     _loc11_ = _loc13_.GetSuitEffectByIndex(_loc8_);
                     _loc14_ = _loc11_.SuitQuantity;
                     _loc7_ = int(_loc11_.Value.length);
                     _loc6_ = 0;
                     while(_loc6_ < _loc7_)
                     {
                        if(_loc11_.Percentage[_loc6_] == 1)
                        {
                           _loc12_ = (parseFloat(_loc11_.Value[_loc6_]) * 100).toFixed(0) + "%";
                        }
                        else
                        {
                           _loc12_ = _loc11_.Value[_loc6_];
                        }
                        _loc16_ = BASEATTRIBUTENAMES.indexOf(_loc11_.Category[_loc6_]);
                        _loc15_ += TUtilityLobby.GetBaseAttributeNameByIndex(_loc16_) + "+" + _loc12_ + "   ";
                        _loc6_++;
                     }
                     _loc8_++;
                  }
                  _loc2_.push(TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_INVENTORY_BasisProperty_02),_loc17_,_loc15_));
               }
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function get OnInventoryOver() : Function
      {
         return this.FOnInventoryOver;
      }
      
      public function set OnInventoryOver(param1:Function) : void
      {
         this.FOnInventoryOver = param1;
      }
      
      public function get OnInventoryOut() : Function
      {
         return this.FOnInventoryOut;
      }
      
      public function set OnInventoryOut(param1:Function) : void
      {
         this.FOnInventoryOut = param1;
      }
      
      public function get HintOnOver() : Function
      {
         return this.FHintOnOver;
      }
      
      public function set HintOnOver(param1:Function) : void
      {
         this.FHintOnOver = param1;
      }
      
      public function get HintOnOut() : Function
      {
         return this.FHintOnOut;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function set Heros(param1:THeros) : void
      {
         this.FHeros = param1;
         this.LoadHeroQuality();
      }
      
      public function set OnSkillOver(param1:Function) : void
      {
         this.FOnSkillOver = param1;
      }
      
      public function set OnSkillOut(param1:Function) : void
      {
         this.FOnSkillOut = param1;
      }
      
      public function set KnifeOfKillSoulID(param1:int) : void
      {
         this.FKnifeOfKillSoulID = param1;
         this.FKnifeOfKillSoulData = this.FKnifeOfkillSoulDatas.GetByIndentifier(this.FKnifeOfKillSoulID);
      }
      
      public function Perform_UIDispatch() : void
      {
         this.Resources_UIDispatch();
         this.Resources_UILocations();
      }
      
      public function Show() : void
      {
         if(!this.FInitializationSlots)
         {
            return;
         }
         this.TabWindowOnSwitch(this.FCurWindowType);
         this.UpdateTabs();
         this.UpdateRoleModel();
         this.CharacterUpdateBaseInfo();
         this.CharacterUpdateBaseAttributes();
         this.CharacterUpdatePvPAttributes();
         this.CharacterUpdateSkills();
         this.InventoriesUpdateEquipmentsMounted();
         this.ProcessorAllHeroEquipmentMountedSuitCount();
         this.SetupHeroListPage(this.FHeros.Count,0);
         this.Visible = true;
      }
      
      public function Hide() : void
      {
         this.Reset();
         this.Visible = false;
      }
      
      public function Reset() : void
      {
         ClearProfileCharacterTags();
         if(this.FHeros == null)
         {
            return;
         }
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:uint = 0;
         this.FHeroPageIndex = 0;
         this.FTabHeroIndex = 0;
         this.FCurrentPageStore = 0;
         this.FUITabHeros.Reset();
         this.FAttributeTab.SwithTagManual(0);
         this.FUITabWindow.SwithTagManual(0);
         this.FMC_OpenInfomation.visible = false;
         this.FMC_OpenInfomation.gotoAndStop(1);
         this.FMC_CLoseInfomation.visible = true;
         this.FMC_CLoseInfomation.gotoAndStop(1);
         this.FMC_PvPOpenInfomation.visible = false;
         this.FMC_PvPOpenInfomation.gotoAndStop(1);
         this.FMC_PvPCLoseInfomation.visible = true;
         this.FMC_PvPCLoseInfomation.gotoAndStop(1);
         this.FUIHero.Context = null;
         this.FHeros.Clear();
         _loc2_ = int(this.FRolesModelID.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = uint(this.FRolesModelID[_loc1_]);
            _loc3_ = CONST_COMMON.CheckMainHeroModelID(_loc4_,SLogicsCore.Character.RoleSencePosition);
            if(!_loc3_)
            {
               SResourcesCore.TexturesModel.DeleteByIdentifier(_loc4_,true);
            }
            _loc1_++;
         }
         this.FRolesModelID.length = 0;
         _loc2_ = int(CAPACITY_EquipmentsMounted_Slots);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSlotsEquipmentMounted[_loc1_].Context = null;
            _loc1_++;
         }
         _loc2_ = int(CAPACITY_OrnamentMounted_Slots);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSlotsOrnamentMounted[_loc1_].Context = null;
            _loc1_++;
         }
      }
   }
}

