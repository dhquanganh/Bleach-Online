package Processors.Game.Lobby.HerosNew.Component
{
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.HeroNew.TWakeHeroAttributes;
   import Logics.HeroNew.TWakeProperties;
   import Processors.Game.Lobby.HerosNew.TWindowAttribute;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class THeroWakeMapTip extends Sprite
   {
      
      protected static const OffsetX:int = 20;
      
      protected static const OffsetY:int = -40;
      
      protected var FMainUI:Sprite;
      
      protected var FTFDesc0:TextField;
      
      protected var FTFDesc1:TextField;
      
      protected var FTFDesc2:TextField;
      
      protected var FTFDesc:TextField;
      
      protected var FTFAttributeVec:Vector.<TextField>;
      
      protected var FWakeAttributeIds:Vector.<int>;
      
      protected var FWakeAttributes:TWakeHeroAttributes;
      
      protected var FWakeTotalLevel:int;
      
      public function THeroWakeMapTip()
      {
         super();
         this.mouseChildren = false;
         this.mouseEnabled = false;
      }
      
      public function UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FWakeAttributeIds = new Vector.<int>();
         this.FWakeAttributeIds = this.FWakeAttributeIds.concat(TWindowAttribute.WakeAttributeDesIDs_Nomal);
         this.FWakeAttributeIds = this.FWakeAttributeIds.concat(TWindowAttribute.WakeAttributeDesIDs_Rate);
         this.FWakeAttributeIds = this.FWakeAttributeIds.concat(TWindowAttribute.WakeAttributeDesIDs_Other);
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_HeroWakeMapTip") as Sprite;
         this.FMainUI.x = OffsetX;
         this.FMainUI.y = OffsetY;
         addChild(this.FMainUI);
         this.FTFDesc0 = this.FMainUI["TF_Desc_0"];
         this.FTFDesc0.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_53);
         this.FTFDesc1 = this.FMainUI["TF_Desc_1"];
         this.FTFDesc1.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_55);
         this.FTFDesc2 = this.FMainUI["TF_Desc_2"];
         this.FTFDesc2.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_56);
         this.FTFDesc = this.FMainUI["TF_Desc"];
         this.FTFAttributeVec = new Vector.<TextField>();
         _loc2_ = int(this.FWakeAttributeIds.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTFAttributeVec.push(this.FMainUI["TF_Attribute_" + _loc1_] as TextField);
            _loc1_++;
         }
      }
      
      public function SetData(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:TWakeProperties = null;
         var _loc7_:String = null;
         var _loc8_:Number = NaN;
         var _loc9_:TWakeProperties = null;
         _loc6_ = this.FWakeAttributes.GetProperty(param1,param2,this.FWakeTotalLevel);
         this.FTFDesc.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_52),param2);
         _loc4_ = int(this.FWakeAttributeIds.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc8_ = _loc6_.GetValueByType(this.FWakeAttributeIds[_loc3_]);
            if(TUtilityLobby.GetViewtypeByAttributeName(this.FWakeAttributeIds[_loc3_]) && _loc8_ != 0)
            {
               _loc7_ = Number(_loc8_ * 100).toFixed(2) + "%";
            }
            else
            {
               _loc7_ = _loc8_ + "";
            }
            this.FTFAttributeVec[_loc3_].text = _loc7_;
            _loc3_++;
         }
      }
      
      public function set WakeAttributes(param1:TWakeHeroAttributes) : void
      {
         this.FWakeAttributes = param1;
      }
      
      public function set WakeTotalLevel(param1:int) : void
      {
         this.FWakeTotalLevel = param1;
      }
   }
}

