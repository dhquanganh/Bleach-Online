package Processors.Game.Lobby.HerosNew
{
   import Components.ComboBox.TComboBox;
   import Components.Standard.TUIButton;
   import Components.Standard.TUITab;
   import Foundation.Common.THint;
   import Foundation.Network.TPacket;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.Characters.MainRoleWake.THeroWakeData;
   import Logics.Characters.TCharacter;
   import Logics.Characters.THero;
   import Logics.HeroNew.TWakeHeroAttributes;
   import Logics.HeroNew.TWakeProperties;
   import Logics.Inventories.TEquipment;
   import Logics.Inventories.TSuitEffect;
   import Logics.Inventories.TSuitEffects;
   import Logics.KnifeOfKillSoul.TKnifeOfKillSoulData;
   import Logics.SLogicsCore;
   import Logics.Skills.TSkill;
   import Logics.Skills.TSkills;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.TacticalDeployment.Components.TKnifeInforTip;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class TWindowAttribute extends TProcessorLobbyWindow
   {
      
      protected static const Wake_SubTab_Num:int = 3;
      
      protected static const Wake_Property_Num:int = 8;
      
      protected static const ShowType_Equipment:int = 0;
      
      protected static const ShowType_Decoration:int = 1;
      
      protected static const ShowType_WakeUp:int = 2;
      
      protected static const ShowSubType_Normal:int = 0;
      
      protected static const ShowSubType_PVP:int = 1;
      
      protected static const ShowSubType_Other:int = 2;
      
      protected static const AttrackType_Entity:int = 0;
      
      protected static const AttrackType_Ghost:int = 1;
      
      protected static const DecorationAttributeNum:int = 9;
      
      protected static const DecorationBufferNum:int = 4;
      
      protected static const SIZE_ComboboxHeight:int = 83;
      
      protected static const SIZE_SingleComboHeight:int = 20;
      
      protected static const DetailAttributeNum:int = 20;
      
      protected static const FreamIndexJmps:Vector.<int> = Vector.<int>([1,12]);
      
      protected static const WakeTab_Nomal:uint = 0;
      
      protected static const WakeTab_Rate:uint = 1;
      
      protected static const WakeTab_Other:uint = 2;
      
      protected static const EquipAttributeDesIDs_Entity:Vector.<int> = Vector.<int>([CONST_SYSTEMLANGUAGE.HEROS_STRING_18,CONST_SYSTEMLANGUAGE.HEROS_STRING_19,CONST_SYSTEMLANGUAGE.HEROS_STRING_21,CONST_SYSTEMLANGUAGE.HEROS_STRING_22,CONST_SYSTEMLANGUAGE.HEROS_STRING_23,CONST_SYSTEMLANGUAGE.HEROS_STRING_24]);
      
      protected static const EquipAttributeDesIDs_Ghost:Vector.<int> = Vector.<int>([CONST_SYSTEMLANGUAGE.HEROS_STRING_18,CONST_SYSTEMLANGUAGE.HEROS_STRING_19,CONST_SYSTEMLANGUAGE.HEROS_STRING_21,CONST_SYSTEMLANGUAGE.HEROS_STRING_22,CONST_SYSTEMLANGUAGE.HEROS_STRING_23,CONST_SYSTEMLANGUAGE.HEROS_STRING_24]);
      
      protected static const DetailAttributeIndexs:Vector.<int> = Vector.<int>([CONST_COMMON.BASEATTRIBUTEINDEX_Power,CONST_COMMON.BASEATTRIBUTEINDEX_Intelligence,CONST_COMMON.BASEATTRIBUTEINDEX_Life,CONST_COMMON.BASEATTRIBUTEINDEX_Agile,CONST_COMMON.BASEATTRIBUTEINDEX_Health,CONST_COMMON.BASEATTRIBUTEINDEX_Speed,CONST_COMMON.BASEATTRIBUTEINDEX_PhysicalAttack,CONST_COMMON.BASEATTRIBUTEINDEX_MagicAttack,CONST_COMMON.BASEATTRIBUTEINDEX_PhysicalDefends,CONST_COMMON.BASEATTRIBUTEINDEX_MagicDefends,CONST_COMMON.BASEATTRIBUTEINDEX_Hurt,CONST_COMMON.BASEATTRIBUTEINDEX_AvoidhurtRate,CONST_COMMON.BASEATTRIBUTEINDEX_Hit,CONST_COMMON.BASEATTRIBUTEINDEX_Dodge,CONST_COMMON.BASEATTRIBUTEINDEX_Crit,CONST_COMMON.BASEATTRIBUTEINDEX_Uprising,CONST_COMMON.BASEATTRIBUTEINDEX_Wreck,CONST_COMMON.BASEATTRIBUTEINDEX_GridFile,CONST_COMMON.BASEATTRIBUTEINDEX_Punch,CONST_COMMON.BASEATTRIBUTEINDEX_Help]);
      
      public static const WakeAttributeDesIDs_Nomal:Vector.<int> = Vector.<int>([CONST_COMMON.BASEATTRIBUTENAME_MAXHP,CONST_COMMON.BASEATTRIBUTENAME_Speed,CONST_COMMON.BASEATTRIBUTENAME_NearAttack,CONST_COMMON.BASEATTRIBUTENAME_StrategyAttack,CONST_COMMON.BASEATTRIBUTENAME_NearDefense,CONST_COMMON.BASEATTRIBUTENAME_StrategyDefense,CONST_COMMON.BASEATTRIBUTENAME_HurtRate,CONST_COMMON.BASEATTRIBUTENAME_AvoidhurtRate]);
      
      public static const WakeAttributeDesIDs_Rate:Vector.<int> = Vector.<int>([CONST_COMMON.BASEATTRIBUTENAME_DodgeRate,CONST_COMMON.BASEATTRIBUTENAME_BlockRate,CONST_COMMON.BASEATTRIBUTENAME_HitRate,CONST_COMMON.BASEATTRIBUTENAME_WreckRate,CONST_COMMON.BASEATTRIBUTENAME_AntiknockRate,CONST_COMMON.BASEATTRIBUTENAME_HelpRate,CONST_COMMON.BASEATTRIBUTENAME_PunchRate,CONST_COMMON.BASEATTRIBUTENAME_CritRate]);
      
      public static const WakeAttributeDesIDs_Other:Vector.<int> = Vector.<int>([CONST_COMMON.BASEATTRIBUTENAME_StartAnger,CONST_COMMON.BASEATTRIBUTENAME_RecoverRate,CONST_COMMON.BASEATTRIBUTENAME_WrathRate,CONST_COMMON.BASEATTRIBUTENAME_UnWrathRate,CONST_COMMON.BASEATTRIBUTENAME_DizzinessRate,CONST_COMMON.BASEATTRIBUTENAME_UnDizzinessRate]);
      
      protected static const BASEATTRIBUTENAMES:Vector.<uint> = CONST_COMMON.BASEATTRIBUTENAMES;
      
      protected var TXT_NORMAL:String;
      
      protected var TXT_PVP:String;
      
      protected var TXT_RATE:String;
      
      protected var TXT_OTHER:String;
      
      protected var FShowSubType:int = 0;
      
      protected var FHint:THint;
      
      protected var FAttributeValuse:Vector.<String>;
      
      protected var FUITab:TUITab;
      
      protected var FChangeLevelNames:Vector.<String>;
      
      protected var FWakeBoards:Vector.<Sprite>;
      
      protected var FWakeValues:Vector.<TextField>;
      
      protected var FEquipmentAttributePanle:Sprite;
      
      protected var FEquipmentAttributePVPBoard:Sprite;
      
      protected var FEquipmentAttributeNormalBoard:Sprite;
      
      protected var FAttackTypePVP:MovieClip;
      
      protected var FAttackTypeNormal:MovieClip;
      
      protected var FValueAttack:TextField;
      
      protected var FValueEntityDefend:TextField;
      
      protected var FValueChange:TextField;
      
      protected var FValueGhostDefend:TextField;
      
      protected var FValueBlood:TextField;
      
      protected var FValueSpeed:TextField;
      
      protected var FValueTalent:TextField;
      
      protected var FValueDeployment:TextField;
      
      protected var FValueSkill:TextField;
      
      protected var FValueKnife:TextField;
      
      protected var FEquipmentValues:Vector.<TextField>;
      
      protected var FKnifeOfKillSoulInforTip:TKnifeInforTip;
      
      protected var FKnifeOfKillSoulData:TKnifeOfKillSoulData;
      
      protected var FMC_ComboBox:Sprite;
      
      protected var FSkillAttackComboBox:TComboBox;
      
      protected var FItemList:Vector.<DisplayObject>;
      
      protected var FSkills:TSkills;
      
      protected var FDecorationAttributePanle:Sprite;
      
      protected var FDecorationAttributePVPBoard:Sprite;
      
      protected var FDecorationAttributeNormalBoard:Sprite;
      
      protected var FDecorationValues:Vector.<TextField>;
      
      protected var FWakeAttributePanel:Sprite;
      
      protected var FBufferStrs:Vector.<String>;
      
      protected var FMCDetailAttribute:MovieClip;
      
      protected var FDetailAttributePVPBoard:Sprite;
      
      protected var FDetailAttributeNormalBoard:Sprite;
      
      protected var FDetailAttributeAttackTypePVP:MovieClip;
      
      protected var FDetailAttributeAttackTypeNormal:MovieClip;
      
      protected var FDetailAttributeValues:Vector.<TextField>;
      
      protected var FDetailAttributes:Vector.<Number>;
      
      protected var FInitDetailAttribute:Boolean;
      
      protected var FTargetFrameIndex:int;
      
      protected var FBtnOpenDetailAttribute:TUIButton;
      
      protected var FBtnCloseDetailAttribute:TUIButton;
      
      protected var FWakeAttribute:TWakeHeroAttributes;
      
      protected var FHero:THero;
      
      protected var FShowType:int;
      
      protected var FAttackType:int;
      
      protected var FOnChangeSkillReq:Function;
      
      protected var FCharacter:TCharacter;
      
      protected var FHeroWakeData:THeroWakeData;
      
      private var FCharacterTagRow:Sprite;
      
      private var FCharacterTagData:Object;
      
      public function TWindowAttribute(param1:TUIComponent)
      {
         super(param1);
      }
      
      private function InitCharacterTags(host:Sprite) : void
      {
         FCharacterTagData = JSON.parse("{\"heroes\":{\"11120960\":[26,52,1,11,14,31,48],\"11120950\":[27,52,12],\"11120970\":[28,61,52,1,3,11,14,31,46,48,49],\"11120920\":[26,52,1,14,31,48],\"11120991\":[27,64,52,2,13,18,57],\"11120940\":[30,52,1,18,14,32,48,49,58],\"11120930\":[28,52,6,11,14,46],\"11120901\":[27,52,1,13,47,58]},\"tags\":{\"26\":{\"name\":\"Fire\",\"icon\":\"/public/character-tags/26.png\"},\"52\":{\"name\":\"Male\",\"icon\":\"/public/character-tags/52.png\"},\"1\":{\"name\":\"Konoha\",\"icon\":\"/public/character-tags/1.png\"},\"11\":{\"name\":\"Akatsuki\",\"icon\":\"/public/character-tags/11.png\"},\"14\":{\"name\":\"Blood Limit\",\"icon\":\"/public/character-tags/14.png\"},\"31\":{\"name\":\"Uchiha Clan\",\"icon\":\"/public/character-tags/31.png\"},\"48\":{\"name\":\"Secret Jutsu User\",\"icon\":\"/public/character-tags/48.png\"},\"27\":{\"name\":\"Wind\",\"icon\":\"/public/character-tags/27.png\"},\"12\":{\"name\":\"Confusion\",\"icon\":\"/public/character-tags/12.png\"},\"28\":{\"name\":\"Lightning\",\"icon\":\"/public/character-tags/28.png\"},\"61\":{\"name\":\"Sasuke Shinden\",\"icon\":\"/public/character-tags/61.png\"},\"3\":{\"name\":\"Hidden Sound\",\"icon\":\"/public/character-tags/3.png\"},\"46\":{\"name\":\"Rinnegan\",\"icon\":\"/public/character-tags/46.png\"},\"49\":{\"name\":\"Sword User\",\"icon\":\"/public/character-tags/49.png\"},\"64\":{\"name\":\"Swimsuit\",\"icon\":\"/public/character-tags/64.png\"},\"2\":{\"name\":\"Hidden Sand\",\"icon\":\"/public/character-tags/2.png\"},\"13\":{\"name\":\"Jinchuriki\",\"icon\":\"/public/character-tags/13.png\"},\"18\":{\"name\":\"Kage\",\"icon\":\"/public/character-tags/18.png\"},\"57\":{\"name\":\"Allied Shinobi Forces\",\"icon\":\"/public/character-tags/57.png\"},\"30\":{\"name\":\"Earth\",\"icon\":\"/public/character-tags/30.png\"},\"32\":{\"name\":\"Senju Clan\",\"icon\":\"/public/character-tags/32.png\"},\"58\":{\"name\":\"Senjutsu\",\"icon\":\"/public/character-tags/58.png\"},\"6\":{\"name\":\"Hidden Rain\",\"icon\":\"/public/character-tags/6.png\"},\"47\":{\"name\":\"Uzumaki Clan\",\"icon\":\"/public/character-tags/47.png\"}}}");
         FCharacterTagRow = new Sprite();
         FCharacterTagRow.name = "characterTags";
         var tab:DisplayObject = host["MC_PVP"];
         FCharacterTagRow.x = tab.x + tab.width + 4;
         FCharacterTagRow.y = tab.y + (tab.height - 20) / 2;
         host.addChild(FCharacterTagRow);
      }
      
      private function RenderCharacterTags() : void
      {
         if(FCharacterTagRow == null)return;
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
         while(FCharacterTagRow.numChildren > 0)FCharacterTagRow.removeChildAt(0);
         var ids:Array = FHero == null ? null : FCharacterTagData.heroes[String(FHero.Identifier)] as Array;
         FCharacterTagRow.visible = ids != null && FShowType != ShowType_WakeUp;
         if(!FCharacterTagRow.visible)return;
         var iconScale:Number = Math.min(1,7 / ids.length);
         for(var i:int = 0;i < ids.length;i++){
            AddCharacterTag(ids[i],i);
            var slot:Sprite = FCharacterTagRow.getChildAt(i) as Sprite;
            slot.scaleX = slot.scaleY = iconScale;
            slot.x = i * 20 * iconScale;
            slot.y = (20 - 20 * iconScale) / 2;
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
         slot.addEventListener(MouseEvent.MOUSE_OUT,this.TFOnOut);
         FCharacterTagRow.addChild(slot);
      }
      
      private function CharacterTagOnOver(event:MouseEvent) : void
      {
         FHint.Caption = Sprite(event.currentTarget).name;
         SUtilityOverLayer.UIComponentsHintOnOver(this,FHint);
      }
      
      public function UIDispatch(param1:Sprite) : void
      {
         InitCharacterTags(param1);
         this.FHint = new THint();
         this.FAttributeValuse = new Vector.<String>();
         this.FUITab = new TUITab(this);
         this.FUITab.SetTabByIndex(param1["MC_PVE"],ShowSubType_Normal);
         this.FUITab.SetTabByIndex(param1["MC_PVP"],ShowSubType_PVP);
         this.FUITab.SetTabByIndex(param1["MC_Other"],ShowSubType_Other);
         this.FUITab.OnSwitch = this.TabOnSwitch;
         this.FUITab.Init();
         this.FCharacter = SLogicsCore.Character;
         this.UIDispatchEquipment(param1);
         this.UIDispatchDecoration(param1);
         this.UIDispatchWakeUp(param1);
         this.UIDispatchDetailAttribute(param1);
         this.FChangeLevelNames = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_18);
      }
      
      protected function UIDispatchEquipment(param1:Sprite) : void
      {
         this.FEquipmentAttributePanle = param1["EquipmentAttribute"];
         this.FEquipmentAttributePVPBoard = this.FEquipmentAttributePanle["PVPBoard"];
         this.FEquipmentAttributeNormalBoard = this.FEquipmentAttributePanle["NormalBoard"];
         this.FAttackTypePVP = this.FEquipmentAttributePVPBoard["MC_Attack"];
         this.FAttackTypeNormal = this.FEquipmentAttributeNormalBoard["MC_Attack"];
         this.FValueAttack = this.FEquipmentAttributePanle["ValueAttack"];
         this.FValueEntityDefend = this.FEquipmentAttributePanle["ValueEntityDefend"];
         this.FValueChange = this.FEquipmentAttributePanle["ValueChange"];
         this.FValueGhostDefend = this.FEquipmentAttributePanle["ValueGhostDefend"];
         this.FValueBlood = this.FEquipmentAttributePanle["ValueBlood"];
         this.FValueSpeed = this.FEquipmentAttributePanle["ValueSpeed"];
         this.FValueTalent = this.FEquipmentAttributePanle["ValueTalent"];
         this.FValueDeployment = this.FEquipmentAttributePanle["ValueDeployment"];
         this.FValueSkill = this.FEquipmentAttributePanle["ValueSkill"]["TF_SkillAttack"];
         this.FValueKnife = this.FEquipmentAttributePanle["TF_Knife"];
         this.FEquipmentValues = new Vector.<TextField>();
         this.FEquipmentValues.push(this.FValueAttack);
         this.FEquipmentValues.push(this.FValueEntityDefend);
         this.FEquipmentValues.push(this.FValueChange);
         this.FEquipmentValues.push(this.FValueGhostDefend);
         this.FEquipmentValues.push(this.FValueBlood);
         this.FEquipmentValues.push(this.FValueSpeed);
         this.FItemList = new Vector.<DisplayObject>();
         this.FMC_ComboBox = param1["MC_ComboBox"];
         this.FSkillAttackComboBox = new TComboBox(this,this.FMC_ComboBox,this.FItemList,SIZE_ComboboxHeight,this.ComboBoxOnSelect);
         this.FSkills = new TSkills();
         this.FKnifeOfKillSoulInforTip = new TKnifeInforTip(FParent.Parent);
         this.FKnifeOfKillSoulInforTip.visible = false;
         this.FKnifeOfKillSoulInforTip.UIDispatch();
         this.FKnifeOfKillSoulInforTip.UILocation();
         this.UILocationEquipment();
      }
      
      protected function UILocationEquipment() : void
      {
         this.FValueAttack.addEventListener(MouseEvent.MOUSE_MOVE,this.TFEquipmentAttributesOnOver);
         this.FValueAttack.addEventListener(MouseEvent.MOUSE_OUT,this.TFOnOut);
         this.FValueEntityDefend.addEventListener(MouseEvent.MOUSE_MOVE,this.TFEquipmentAttributesOnOver);
         this.FValueEntityDefend.addEventListener(MouseEvent.MOUSE_OUT,this.TFOnOut);
         this.FValueChange.addEventListener(MouseEvent.MOUSE_MOVE,this.TFEquipmentAttributesOnOver);
         this.FValueChange.addEventListener(MouseEvent.MOUSE_OUT,this.TFOnOut);
         this.FValueGhostDefend.addEventListener(MouseEvent.MOUSE_MOVE,this.TFEquipmentAttributesOnOver);
         this.FValueGhostDefend.addEventListener(MouseEvent.MOUSE_OUT,this.TFOnOut);
         this.FValueBlood.addEventListener(MouseEvent.MOUSE_MOVE,this.TFEquipmentAttributesOnOver);
         this.FValueBlood.addEventListener(MouseEvent.MOUSE_OUT,this.TFOnOut);
         this.FValueSpeed.addEventListener(MouseEvent.MOUSE_MOVE,this.TFEquipmentAttributesOnOver);
         this.FValueSpeed.addEventListener(MouseEvent.MOUSE_OUT,this.TFOnOut);
         this.FValueKnife.addEventListener(MouseEvent.MOUSE_MOVE,this.KnifeOfKillSoulOnMove);
         this.FValueKnife.addEventListener(MouseEvent.MOUSE_OUT,this.KnifeOfKillSoulOnOut);
         this.FValueTalent.addEventListener(MouseEvent.MOUSE_MOVE,this.TFTalentHintOnOver,false,0,true);
         this.FValueTalent.addEventListener(MouseEvent.MOUSE_OUT,this.TFOnOut,false,0,true);
         this.FValueSkill.addEventListener(MouseEvent.MOUSE_MOVE,this.TFSkillAttackHintOnOver,false,0,true);
         this.FValueSkill.addEventListener(MouseEvent.MOUSE_OUT,this.TFSkillAttackHintOnOut,false,0,true);
         this.FMC_ComboBox.addEventListener(MouseEvent.MOUSE_MOVE,this.TFSkillAttackHintOnOver,false,0,true);
         this.FMC_ComboBox.addEventListener(MouseEvent.MOUSE_OUT,this.TFSkillAttackHintOnOut,false,0,true);
         this.FAttackTypePVP.stop();
         this.FAttackTypeNormal.stop();
      }
      
      protected function UIDispatchDecoration(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.FDecorationValues = new Vector.<TextField>();
         this.FDecorationAttributePanle = param1["MC_OrnamentAttribute"];
         this.FDecorationAttributePVPBoard = this.FDecorationAttributePanle["DecorationPVPBoard"];
         this.FDecorationAttributeNormalBoard = this.FDecorationAttributePanle["DecorationNormalBoard"];
         _loc3_ = DecorationAttributeNum;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FDecorationValues.push(this.FDecorationAttributePanle["TF_BaseAttribute_" + _loc2_]);
            _loc2_++;
         }
         this.FBufferStrs = new Vector.<String>();
      }
      
      protected function UILocationDecoration() : void
      {
      }
      
      protected function UIDispatchWakeUp(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         this.FWakeBoards = new Vector.<Sprite>();
         this.FWakeValues = new Vector.<TextField>();
         this.FWakeAttributePanel = param1["MC_WakeAttribute"];
         _loc2_ = 0;
         while(_loc2_ < Wake_SubTab_Num)
         {
            this.FWakeBoards.push(this.FWakeAttributePanel["WakeBoard_" + _loc2_]);
            this.FWakeBoards[_loc2_].visible = false;
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < Wake_Property_Num)
         {
            this.FWakeValues.push(this.FWakeAttributePanel["TF_BaseAttribute_" + _loc2_]);
            this.FWakeValues[_loc2_].visible = false;
            _loc2_++;
         }
         this.TXT_NORMAL = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_53));
         this.TXT_PVP = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_54));
         this.TXT_RATE = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_55));
         this.TXT_OTHER = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_56));
      }
      
      protected function UIDispatchDetailAttribute(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.FMCDetailAttribute = param1["DetailAttribute"];
         this.FDetailAttributePVPBoard = this.FMCDetailAttribute["Detail"]["DetailPVPBoard"];
         this.FDetailAttributeNormalBoard = this.FMCDetailAttribute["Detail"]["DetailNormalBoard"];
         this.FDetailAttributeAttackTypePVP = this.FDetailAttributePVPBoard["MC_Attack"];
         this.FDetailAttributeAttackTypeNormal = this.FDetailAttributeNormalBoard["MC_Attack"];
         this.FDetailAttributeValues = new Vector.<TextField>();
         this.FDetailAttributes = new Vector.<Number>(DetailAttributeNum);
         _loc3_ = DetailAttributeNum;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FDetailAttributeValues.push(this.FMCDetailAttribute["Detail"]["TF_Property_" + _loc2_]);
            _loc2_++;
         }
         this.FBtnOpenDetailAttribute = new TUIButton();
         this.FBtnOpenDetailAttribute.Substrate = this.FMCDetailAttribute["Btn_OpenInfomation"];
         this.FBtnOpenDetailAttribute.OnClick = this.DetailAttributeMCOnClick;
         this.FBtnCloseDetailAttribute = new TUIButton();
         this.FBtnCloseDetailAttribute.Substrate = this.FMCDetailAttribute["Btn_CloseInfomation"];
         this.FBtnCloseDetailAttribute.OnClick = this.DetailAttributeMCOnClick;
         this.UILocationDetailAttribute();
      }
      
      protected function UILocationDetailAttribute() : void
      {
         this.FDetailAttributeAttackTypePVP.stop();
         this.FDetailAttributeAttackTypeNormal.stop();
         this.FBtnOpenDetailAttribute.Visible = true;
         this.FBtnCloseDetailAttribute.Visible = false;
      }
      
      protected function RenderSelector() : void
      {
         var _loc1_:int = 0;
         this.FEquipmentAttributePanle.visible = false;
         this.FDecorationAttributePanle.visible = false;
         this.FWakeAttributePanel.visible = false;
         this.FUITab.SetTabHideByIndex(ShowSubType_Other);
         switch(this.FShowType)
         {
            case ShowType_Equipment:
               this.RenderDetailAttribute();
               this.FMCDetailAttribute.visible = true;
               this.FEquipmentAttributePanle.visible = true;
               this.FUITab.SetTabCaptionByIndex(this.TXT_NORMAL,ShowSubType_Normal);
               this.FUITab.SetTabCaptionByIndex(this.TXT_PVP,ShowSubType_PVP);
               if(this.FShowSubType == ShowSubType_Normal)
               {
                  this.RenderEquipmentAttribute_Normal();
               }
               else
               {
                  this.RenderEquipmentAttribute_PVP();
               }
               break;
            case ShowType_Decoration:
               this.RenderDetailAttribute();
               this.FMCDetailAttribute.visible = true;
               this.FDecorationAttributePanle.visible = true;
               this.FUITab.SetTabCaptionByIndex(this.TXT_NORMAL,ShowSubType_Normal);
               this.FUITab.SetTabCaptionByIndex(this.TXT_PVP,ShowSubType_PVP);
               if(this.FShowSubType == ShowSubType_Normal)
               {
                  this.RenderDecorationtAttribute_Normal();
               }
               else
               {
                  this.RenderDecorationtAttribute_PVP();
               }
               break;
            case ShowType_WakeUp:
               this.FMCDetailAttribute.visible = false;
               this.FWakeAttributePanel.visible = true;
               this.FUITab.SetTabShowByIndex(ShowSubType_Other);
               this.FUITab.SetTabCaptionByIndex(this.TXT_NORMAL,ShowSubType_Normal);
               this.FUITab.SetTabCaptionByIndex(this.TXT_RATE,ShowSubType_PVP);
               this.FUITab.SetTabCaptionByIndex(this.TXT_OTHER,ShowSubType_Other);
               _loc1_ = 0;
               while(_loc1_ < Wake_SubTab_Num)
               {
                  this.FWakeBoards[_loc1_].visible = false;
                  _loc1_++;
               }
               this.FWakeBoards[this.FShowSubType].visible = true;
               this.RenderWakeUpAttribute();
               if(this.FHero.IsMain)
               {
                  this.RenderHeroWakeUpAttribute();
               }
         }
      }
      
      protected function RenderEquipmentAttribute_Normal() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Vector.<String> = null;
         var _loc3_:String = null;
         this.FEquipmentAttributePVPBoard.visible = false;
         this.FEquipmentAttributeNormalBoard.visible = true;
         this.FAttackTypeNormal.gotoAndStop(this.FAttackType + 1);
         switch(this.FAttackType)
         {
            case AttrackType_Entity:
               this.FValueAttack.text = this.FHero.BaseAttributePhysicalAttack.toString();
               break;
            case AttrackType_Ghost:
               this.FValueAttack.text = this.FHero.BaseAttributeMagicAttack.toString();
         }
         this.FValueEntityDefend.text = this.FHero.BaseAttributePhysicalDefends.toString();
         this.FValueChange.text = this.FHero.ChangeSchedule == 0 ? TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_19) : this.FChangeLevelNames[this.FHero.ChangeSchedule - 1];
         this.FValueGhostDefend.text = this.FHero.BaseAttributeMagicDefends.toString();
         this.FValueBlood.text = this.FHero.BaseAttributeHealth.toString();
         this.FValueSpeed.text = this.FHero.BaseAttributeSpeed.toString();
         _loc1_ = int(TUtilityLobby.GetStandPositionWithProfession(this.FHero.Profession));
         _loc2_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.TACTICALDEPLOYMENT_STRING_20);
         this.FValueTalent.text = this.FHero.TalentName;
         this.FValueDeployment.text = _loc2_[_loc1_ - 1];
         this.RenderHeroSkill();
         this.FKnifeOfKillSoulData = this.FCharacter.KnifeOfKillSoul.GetByIndentifier(this.FCharacter.KnifeSoul.ChangedID);
         this.FKnifeOfKillSoulInforTip.KnifeData = this.FKnifeOfKillSoulData;
         if(this.FKnifeOfKillSoulData == null)
         {
            _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.COMMON_NONE);
            this.FValueKnife.text = _loc3_;
         }
         else
         {
            this.FValueKnife.text = this.FKnifeOfKillSoulData.Name;
         }
      }
      
      protected function RenderEquipmentAttribute_PVP() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Vector.<String> = null;
         var _loc3_:String = null;
         this.FEquipmentAttributePVPBoard.visible = true;
         this.FEquipmentAttributeNormalBoard.visible = false;
         this.FAttackTypePVP.gotoAndStop(this.FAttackType + 1);
         switch(this.FAttackType)
         {
            case AttrackType_Entity:
               this.FValueAttack.text = this.FHero.PvPAttributePhysicalAttack.toString();
               break;
            case AttrackType_Ghost:
               this.FValueAttack.text = this.FHero.PvPAttributeMagicAttack.toString();
         }
         this.FValueEntityDefend.text = this.FHero.PvPAttributePhysicalDefends.toString();
         this.FValueChange.text = this.FHero.ChangeSchedule == 0 ? TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_19) : this.FChangeLevelNames[this.FHero.ChangeSchedule - 1];
         this.FValueGhostDefend.text = this.FHero.PvPAttributeMagicDefends.toString();
         this.FValueBlood.text = this.FHero.PvPAttributeHealth.toString();
         this.FValueSpeed.text = this.FHero.PvPAttributeSpeed.toString();
         _loc1_ = int(TUtilityLobby.GetStandPositionWithProfession(this.FHero.Profession));
         _loc2_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.TACTICALDEPLOYMENT_STRING_20);
         this.FValueTalent.text = this.FHero.TalentName;
         this.FValueDeployment.text = _loc2_[_loc1_ - 1];
         this.RenderHeroSkill();
         this.FKnifeOfKillSoulData = this.FCharacter.KnifeOfKillSoul.GetByIndentifier(this.FCharacter.KnifeSoul.ChangedID);
         this.FKnifeOfKillSoulInforTip.KnifeData = this.FKnifeOfKillSoulData;
         if(this.FKnifeOfKillSoulData == null)
         {
            _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.COMMON_NONE);
            this.FValueKnife.text = _loc3_;
         }
         else
         {
            this.FValueKnife.text = this.FKnifeOfKillSoulData.Name;
         }
      }
      
      protected function RenderDecorationtAttribute_Normal() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FDecorationAttributePVPBoard.visible = false;
         this.FDecorationAttributeNormalBoard.visible = true;
         this.FAttributeValuse.length = 0;
         this.FAttributeValuse.push(this.FHero.BaseAttributePower.toString());
         this.FAttributeValuse.push(this.FHero.BaseAttributeSpeed.toString());
         this.FAttributeValuse.push(this.FHero.BaseAttributeAgile.toString());
         this.FAttributeValuse.push(this.FHero.BaseAttributeHealth.toString());
         this.FAttributeValuse.push(this.FHero.BaseAttributeIntelligence.toString());
         this.FBufferStrs.length = 0;
         this.GetEffectStrByHero(this.FHero,this.FBufferStrs);
         _loc2_ = int(this.FBufferStrs.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FAttributeValuse.push(this.FBufferStrs[_loc1_]);
            _loc1_++;
         }
         while(_loc1_ < DecorationBufferNum)
         {
            this.FAttributeValuse.push("");
            _loc1_++;
         }
         this.RenderDecorationAttribute_Common();
      }
      
      protected function RenderDecorationtAttribute_PVP() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FDecorationAttributePVPBoard.visible = false;
         this.FDecorationAttributeNormalBoard.visible = true;
         this.FAttributeValuse.length = 0;
         this.FAttributeValuse.push(this.FHero.PvPAttributePower.toString());
         this.FAttributeValuse.push(this.FHero.PvPAttributeSpeed.toString());
         this.FAttributeValuse.push(this.FHero.PvPAttributeAgile.toString());
         this.FAttributeValuse.push(this.FHero.PvPAttributeHealth.toString());
         this.FAttributeValuse.push(this.FHero.PvPAttributeIntelligence.toString());
         this.FBufferStrs.length = 0;
         this.GetEffectStrByHero(this.FHero,this.FBufferStrs);
         _loc2_ = int(this.FBufferStrs.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FAttributeValuse.push(this.FBufferStrs[_loc1_]);
            _loc1_++;
         }
         while(_loc1_ < DecorationBufferNum)
         {
            this.FAttributeValuse.push("");
            _loc1_++;
         }
         this.RenderDecorationAttribute_Common();
      }
      
      protected function RenderWakeUpAttribute() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<int> = null;
         var _loc4_:String = null;
         var _loc5_:TWakeProperties = null;
         var _loc6_:Number = Number(NaN);
         var _loc7_:TWakeProperties = null;
         switch(this.FShowSubType)
         {
            case WakeTab_Nomal:
               _loc3_ = WakeAttributeDesIDs_Nomal;
               break;
            case WakeTab_Rate:
               _loc3_ = WakeAttributeDesIDs_Rate;
               break;
            case WakeTab_Other:
               _loc3_ = WakeAttributeDesIDs_Other;
         }
         _loc7_ = this.FWakeAttribute.GetPropertyByHeroId(this.FHero.Identifier);
         if(_loc7_ == null)
         {
            _loc7_ = new TWakeProperties();
         }
         _loc2_ = int(_loc3_.length);
         _loc1_ = 0;
         while(_loc1_ < Wake_Property_Num)
         {
            if(_loc1_ < _loc2_)
            {
               _loc5_ = this.FWakeAttribute.GetProperty(this.FHero.Identifier,this.FHero.WakeupLevel - 1,this.FHero.WakeupLevel);
               if(_loc5_ == null)
               {
                  _loc5_ = new TWakeProperties();
               }
               _loc6_ = _loc5_.GetValueByType(_loc3_[_loc1_]) + _loc7_.GetValueByType(_loc3_[_loc1_]);
               if(TUtilityLobby.GetViewtypeByAttributeName(_loc3_[_loc1_]) && _loc6_ != 0)
               {
                  _loc4_ = (_loc6_ * 100).toFixed(2) + "%";
               }
               else
               {
                  _loc4_ = _loc6_ + "";
               }
               this.FWakeValues[_loc1_].visible = true;
               this.FWakeValues[_loc1_].text = _loc4_;
            }
            else
            {
               this.FWakeValues[_loc1_].visible = false;
            }
            _loc1_++;
         }
      }
      
      protected function RenderHeroWakeUpAttribute() : void
      {
         var _loc1_:Vector.<int> = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc6_:Number = Number(NaN);
         var _loc7_:Object = null;
         switch(this.FShowSubType)
         {
            case WakeTab_Nomal:
               _loc1_ = WakeAttributeDesIDs_Nomal;
               break;
            case WakeTab_Rate:
               _loc1_ = WakeAttributeDesIDs_Rate;
               break;
            case WakeTab_Other:
               _loc1_ = WakeAttributeDesIDs_Other;
         }
         _loc3_ = int(_loc1_.length);
         _loc2_ = 0;
         while(_loc2_ < Wake_Property_Num)
         {
            if(_loc2_ < _loc3_)
            {
               _loc4_ = uint(_loc1_[_loc2_]);
               _loc7_ = this.FHeroWakeData.HeroWakeAttributeS2C[_loc4_];
               if(_loc7_ != null)
               {
                  _loc5_ = _loc7_.toString();
               }
               else
               {
                  _loc6_ = this.FHeroWakeData.GetAttributesGross(_loc4_);
                  if(TUtilityLobby.GetViewtypeByAttributeName(_loc4_) && _loc6_ != 0)
                  {
                     _loc5_ = (_loc6_ * 100).toFixed(2) + "%";
                  }
                  else
                  {
                     _loc5_ = _loc6_ + "";
                  }
               }
               this.FWakeValues[_loc2_].visible = true;
               this.FWakeValues[_loc2_].text = _loc5_;
            }
            else
            {
               this.FWakeValues[_loc2_].visible = false;
            }
            _loc2_++;
         }
      }
      
      protected function RenderHeroSkill() : void
      {
         var _loc1_:THero = null;
         var _loc2_:TSkill = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Sprite = null;
         this.FValueSkill.text = this.FHero.Skill.Name;
         _loc1_ = SLogicsCore.Character.GetMainHero();
         this.FMC_ComboBox.visible = this.FHero == _loc1_;
         if(_loc1_ != this.FHero)
         {
            return;
         }
         this.FSkills.Clear();
         _loc4_ = this.FCharacter.Skills.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = this.FCharacter.Skills.GetSkillByIndex(_loc3_);
            if(_loc2_.IsUnlock)
            {
               _loc2_.Mounted = false;
               this.FSkills.Add(_loc2_);
            }
            if(_loc2_.Identifier == SLogicsCore.Character.MainHero.Skill.Identifier)
            {
               _loc2_.Mounted = true;
            }
            _loc3_++;
         }
         this.FSkills.HeroSort();
         this.FItemList.length = 0;
         _loc4_ = this.FSkills.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = this.FSkills.GetSkillByIndex(_loc3_);
            _loc5_ = TUtilityReflection.CreateDisplayObjectInstance("MC_Item") as Sprite;
            _loc5_["tf_into"].text = _loc2_.Name;
            this.FItemList.push(_loc5_);
            _loc3_++;
         }
         this.FSkillAttackComboBox.ResetList(this.FItemList);
      }
      
      protected function RenderDecorationAttribute_Common() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FAttributeValuse.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FDecorationValues[_loc1_].text = this.FAttributeValuse[_loc1_];
            _loc1_++;
         }
      }
      
      protected function RenderDetailAttribute() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Function = null;
         var _loc4_:String = null;
         this.FDetailAttributeAttackTypePVP.gotoAndStop(this.FAttackType + 1);
         this.FDetailAttributeAttackTypeNormal.gotoAndStop(this.FAttackType + 1);
         switch(this.FShowSubType)
         {
            case ShowSubType_Normal:
               _loc3_ = this.FHero.GetBaseAttributeByIndex;
               this.FDetailAttributePVPBoard.visible = false;
               this.FDetailAttributeNormalBoard.visible = true;
               break;
            case ShowSubType_PVP:
               _loc3_ = this.FHero.GetPvPAttributeByIndex;
               this.FDetailAttributePVPBoard.visible = true;
               this.FDetailAttributeNormalBoard.visible = false;
               break;
            case ShowSubType_Other:
               return;
         }
         _loc2_ = int(DetailAttributeIndexs.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FDetailAttributes[_loc1_] = _loc3_(DetailAttributeIndexs[_loc1_]);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = CONST_COMMON.BASSATTRIBUTENUMTYPE[_loc1_] == 1 ? "%" : "";
            this.FDetailAttributeValues[_loc1_].text = this.FDetailAttributes[_loc1_] + _loc4_;
            _loc1_++;
         }
      }
      
      protected function GetAttackTypeByHero(param1:THero) : int
      {
         if(this.FHero.Profession == 3 || this.FHero.Profession == 5)
         {
            return AttrackType_Ghost;
         }
         return AttrackType_Entity;
      }
      
      protected function GetEffectStrByHero(param1:THero, param2:Vector.<String>) : void
      {
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
                  param2.push(TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_INVENTORY_BasisProperty_02),_loc17_,_loc15_));
               }
            }
            _loc4_++;
         }
      }
      
      protected function TFEquipmentAttributesOnOver(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Vector.<int> = null;
         var _loc4_:int = 0;
         _loc2_ = this.FEquipmentValues.indexOf(param1.currentTarget as TextField);
         _loc4_ = this.GetAttackTypeByHero(this.FHero);
         switch(_loc4_)
         {
            case AttrackType_Entity:
               _loc3_ = EquipAttributeDesIDs_Entity;
               break;
            case AttrackType_Ghost:
               _loc3_ = EquipAttributeDesIDs_Ghost;
         }
         this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(_loc3_[_loc2_]);
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function TFOnOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      protected function TabOnSwitch(param1:int) : void
      {
         this.FShowSubType = param1;
         this.FInitDetailAttribute = false;
         this.RenderSelector();
      }
      
      protected function ComboBoxOnSelect(param1:Object, param2:uint) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         var _loc5_:THero = null;
         var _loc6_:TSkill = null;
         _loc5_ = SLogicsCore.Character.GetMainHero();
         _loc6_ = this.FSkills.GetSkillByIndex(param2);
         if(_loc6_.Mounted)
         {
            return;
         }
         if(this.FOnChangeSkillReq != null)
         {
            this.FOnChangeSkillReq(this,_loc6_);
         }
         this.TFSkillAttackHintOnOut();
      }
      
      protected function DetailAttributeMCOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         this.FBtnOpenDetailAttribute.Visible = !this.FBtnOpenDetailAttribute.Visible;
         this.FBtnCloseDetailAttribute.Visible = !this.FBtnCloseDetailAttribute.Visible;
         _loc3_ = FreamIndexJmps.indexOf(this.FMCDetailAttribute.currentFrame);
         _loc3_ = ++_loc3_ % FreamIndexJmps.length;
         this.FTargetFrameIndex = FreamIndexJmps[_loc3_];
         this.FMCDetailAttribute.play();
         this.RenderDetailAttribute();
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
      
      protected function TFTalentHintOnOver(param1:MouseEvent) : void
      {
         this.FHint.Caption = this.FHero.TalentDesc;
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function TFSkillAttackHintOnOver(param1:MouseEvent) : void
      {
         if(this.FHero.CustomHero == null)
         {
            if(this.FHero == this.FCharacter.MainHero)
            {
               SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHero.Skill);
               return;
            }
            this.FHint.Caption = this.FHero.Skill.Description;
            SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
            return;
         }
         if(this.FHero == this.FCharacter.MainHero && this.FHero.Skill.SkillID != this.FHero.CustomHero.CurSkill)
         {
            SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHero.Skill);
         }
         else
         {
            this.FHint.Caption = this.FHero.Skill.Description;
            SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
         }
      }
      
      private function TFSkillAttackHintOnOut(param1:MouseEvent = null) : void
      {
         if(this.FHero == this.FCharacter.MainHero)
         {
            SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHero.Skill);
         }
         else
         {
            SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
         }
      }
      
      public function set OnChangeSkillReq(param1:Function) : void
      {
         this.FOnChangeSkillReq = param1;
      }
      
      public function set HeroWakeData(param1:THeroWakeData) : void
      {
         this.FHeroWakeData = param1;
      }
      
      public function SwitchAttribute(param1:THero, param2:int, param3:TWakeHeroAttributes) : void
      {
         this.FShowType = param2;
         this.FHero = param1;
         RenderCharacterTags();
         this.FWakeAttribute = param3;
         this.FAttackType = this.GetAttackTypeByHero(param1);
         this.FInitDetailAttribute = false;
         if(this.FShowSubType == ShowSubType_Other && param2 != ShowType_WakeUp)
         {
            this.FUITab.SwithTagManual(ShowSubType_Normal);
         }
         else
         {
            this.RenderSelector();
         }
      }
      
      public function UpdateMainHeroSkill() : void
      {
         this.RenderHeroSkill();
      }
      
      public function Reset() : void
      {
         this.FBtnOpenDetailAttribute.Visible = true;
         this.FBtnCloseDetailAttribute.Visible = false;
         this.FMCDetailAttribute.gotoAndStop(1);
      }
      
      public function Running() : void
      {
         if(this.FTargetFrameIndex == this.FMCDetailAttribute.currentFrame)
         {
            this.FMCDetailAttribute.stop();
         }
         if(this.FKnifeOfKillSoulInforTip.visible)
         {
            this.FKnifeOfKillSoulInforTip.UpdatePosition();
         }
      }
      
      public function Update() : void
      {
         this.RenderSelector();
      }
   }
}

