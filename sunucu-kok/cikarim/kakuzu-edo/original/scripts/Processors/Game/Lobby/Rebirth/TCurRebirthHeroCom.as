package Processors.Game.Lobby.Rebirth
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Foundation.Utilities.TUtilityTexture;
   import Logics.Characters.THero;
   import Logics.Map.TMoudleInfor;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudle;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_MAP;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TCurRebirthHeroCom extends TUIComponent
   {
      
      protected var FMainUI:MovieClip;
      
      protected var FSelectBtn:TUIButton;
      
      protected var FPropPowerCom:TPropPowerCom;
      
      protected var FAttackEffectCom:TAttackEffectCom;
      
      protected var FSpriteMoudle:TSceneSpriteMoudle;
      
      protected var FQureyMoudleInfor:TMoudleInfor;
      
      protected var FHero:THero;
      
      protected var FOpenSelectWin:Function;
      
      public function TCurRebirthHeroCom(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function OnSelectBtnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FOpenSelectWin();
      }
      
      public function set Hero(param1:THero) : void
      {
         this.FHero = param1;
      }
      
      public function set OpenSelectWin(param1:Function) : void
      {
         this.FOpenSelectWin = param1;
      }
      
      public function UIDispatch(param1:MovieClip) : void
      {
         this.FMainUI = param1;
         this.FSelectBtn = new TUIButton();
         this.FSelectBtn.Substrate = this.FMainUI.Btn_SelectHero;
         this.FSelectBtn.OnClick = this.OnSelectBtnClick;
         this.FPropPowerCom = new TPropPowerCom(this);
         this.FPropPowerCom.UIDispatch(this.FMainUI.MC_PropPower);
         this.FAttackEffectCom = new TAttackEffectCom(this);
         this.FAttackEffectCom.UIDispatch(this.FMainUI.MC_AttackEffect);
         this.FQureyMoudleInfor = new TMoudleInfor();
         this.FSpriteMoudle = new TSceneSpriteMoudle();
         this.FMainUI.MC_MountPoint.addChild(this.FSpriteMoudle);
      }
      
      public function UpdateUI() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         if(this.FHero.RebirthNum == 0)
         {
            _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Rebirth_04);
            _loc1_ = TUtilityString.Format(_loc2_,this.FHero.RebirthLevel);
         }
         else
         {
            _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Rebirth_05);
            _loc1_ = TUtilityString.Format(_loc2_,this.FHero.RebirthLevel,this.FHero.RebirthNum);
         }
         this.FMainUI.TF_Level.text = _loc1_;
         TUtilityTexture.QueryTwoDirectionShowCase(CONST_MAP.DIRECTION_RIGHT,this.FHero.Identifier,this.FQureyMoudleInfor);
         this.FSpriteMoudle.ChangeRoleMoudle(this.FQureyMoudleInfor.TextureID,this.FQureyMoudleInfor.Scalx);
         this.FSpriteMoudle.OpenRebirthEffect(this.FHero.IsMain,this.FHero.RebirthNum);
         this.FPropPowerCom.UpdateUI(this.FHero.PropPower,this.FHero.RebirthNum);
         this.FAttackEffectCom.UpdateUI(this.FHero.AttackEffect,this.FHero.RebirthNum);
      }
      
      public function LogicsPerform() : void
      {
         if(Visible && this.FMainUI != null)
         {
            this.FSpriteMoudle.UpdateView();
         }
      }
   }
}

