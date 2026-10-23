package Processors.Game.Lobby.ExpDuplicate
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Foundation.Utilities.TUtilityTexture;
   import Logics.DatebaseVO.VO.TEnemyArmy;
   import Logics.ExpDuplicate.VO.TDuplicateVO;
   import Logics.Map.TMoudleInfor;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudle;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_MAP;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorExpDupItemCom extends TUIComponent
   {
      
      protected var FMainUI:MovieClip;
      
      protected var FData:TDuplicateVO;
      
      protected var FLevelTF:TextField;
      
      protected var FRoleMoudle:TSceneSpriteMoudle;
      
      protected var FQueryModel:TMoudleInfor;
      
      protected var FClickFun:Function;
      
      public function TProcessorExpDupItemCom(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function Update() : void
      {
         var _loc1_:TEnemyArmy = null;
         buttonMode = this.FData.IsOpen;
         if(this.FData.IsOpen)
         {
            addEventListener(MouseEvent.CLICK,this.OnClick);
            this.FMainUI.TF_Name.visible = true;
            this.FMainUI.TF_Name.text = this.FData.Config.Name;
            this.FMainUI.MC_Mon.MC_MysMon.visible = false;
            _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_EnemyArmy,this.FData.EnemyArmyID) as TEnemyArmy;
            if(_loc1_ == null) return;
            TUtilityTexture.QueryTwoDirectionShowCase(CONST_MAP.DIRECTION_RIGHT,_loc1_.LeaderID,this.FQueryModel);
            this.FRoleMoudle.ChangeRoleMoudle(this.FQueryModel.TextureID,1);
         }
         else
         {
            removeEventListener(MouseEvent.CLICK,this.OnClick);
            this.FMainUI.TF_Name.visible = true;
            this.FMainUI.TF_Name.text = this.FData.Config.Name;
            this.FMainUI.MC_Mon.MC_MysMon.visible = true;
            this.FRoleMoudle.ReleaseModuleResource();
            this.FRoleMoudle.Release();
         }
         if(this.FLevelTF != null)
         {
            this.FLevelTF.text = "Lv." + this.FData.Config.LvLimit;
         }
         this.FMainUI.TF_FixedAward.text = "Fixed Rewards: Exp+" + this.FData.Exp;
         this.FMainUI.TF_RandomAward.text = "Possible Primogems: 0-" + this.FData.Config.RewardTxt;
      }
      
      protected function OnOver(param1:MouseEvent) : void
      {
         this.FMainUI.MC_Mon.MC_MouseOverUI.visible = true;
      }
      
      protected function OnOut(param1:MouseEvent) : void
      {
         this.FMainUI.MC_Mon.MC_MouseOverUI.visible = false;
      }
      
      protected function OnClick(param1:MouseEvent) : void
      {
         if(this.FClickFun != null)
         {
            this.FClickFun(this);
         }
      }
      
      public function set ClickFun(param1:Function) : void
      {
         this.FClickFun = param1;
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         if(!param1 && this.FRoleMoudle != null)
         {
            this.FRoleMoudle.ReleaseModuleResource();
            this.FRoleMoudle.Release();
         }
      }
      
      public function UIDispatch(param1:MovieClip) : void
      {
         this.FMainUI = param1;
         addChild(this.FMainUI);
         addEventListener(MouseEvent.ROLL_OVER,this.OnOver);
         addEventListener(MouseEvent.ROLL_OUT,this.OnOut);
         this.FQueryModel = new TMoudleInfor();
         this.FMainUI.MC_Mon.MC_MouseOverUI.visible = false;
         this.FLevelTF = this.FMainUI.TF_Condition;
         this.FRoleMoudle = new TSceneSpriteMoudle();
         this.FMainUI.MC_Mon.MC_MountPoint.addChild(this.FRoleMoudle);
      }
      
      public function SetData(param1:TDuplicateVO) : void
      {
         this.FData = param1;
         this.Update();
      }
      
      public function LogicsPerform() : void
      {
         if(Visible)
         {
            if(this.FRoleMoudle.TextrueID != 0)
            {
               this.FRoleMoudle.UpdateView();
            }
         }
      }
   }
}

