package Processors.Game.Lobby.GongFuFight.MainUIComponent
{
   import Components.Standard.TUIButton;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.Characters.TCharacter;
   import Logics.Characters.THero;
   import Logics.GongFuFight.TGongFuFightPlayerInfor;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TComponentSelectEnemy extends TProcessorLobbyWindow
   {
      
      protected static const TotalFrame:int = 35;
      
      protected var FMainUI:MovieClip;
      
      protected var FEnemyPanleInfor:MovieClip;
      
      protected var FPlayerMe:MovieClip;
      
      protected var FMyPicMountPoint:Bitmap;
      
      protected var FMyName:TextField;
      
      protected var FMyLevel:TextField;
      
      protected var FPlayerEnemy:MovieClip;
      
      protected var FPlayerEnemyInforPanle:Sprite;
      
      protected var FEnemyPicMountPoint:Bitmap;
      
      protected var FEnemyName:TextField;
      
      protected var FEnemyLevel:TextField;
      
      protected var FEffect:MovieClip;
      
      protected var FRemindFlag:MovieClip;
      
      protected var FBtnFight:TUIButton;
      
      protected var FGongFuFightPlayerInfor:TGongFuFightPlayerInfor;
      
      protected var FOnStartFight:Function;
      
      public function TComponentSelectEnemy(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FMainUI != null && this.FMainUI.visible)
         {
            if(this.FMainUI.currentFrame == TotalFrame)
            {
               this.FMainUI.stop();
               this.FEnemyPanleInfor.stop();
            }
         }
      }
      
      public function UIDispatch(param1:Sprite) : void
      {
         this.FMainUI = param1["SelectEnemy"];
         this.FEnemyPanleInfor = param1["EnemyPanleInfor"];
         this.FPlayerMe = this.FMainUI["PlayerMe"];
         this.FMyPicMountPoint = new Bitmap();
         this.FPlayerMe["PicMountPoint"].addChild(this.FMyPicMountPoint);
         this.FMyName = this.FMainUI["PanleInforMe"]["Name"];
         this.FMyLevel = this.FMainUI["PanleInforMe"]["Level"];
         this.FPlayerEnemy = this.FMainUI["PlayerEnemy"];
         this.FPlayerEnemyInforPanle = this.FEnemyPanleInfor["PanleInforEnemy"];
         this.FEnemyPicMountPoint = new Bitmap();
         this.FPlayerEnemy["PicMountPoint"].addChild(this.FEnemyPicMountPoint);
         this.FEnemyName = this.FPlayerEnemyInforPanle["Name"];
         this.FEnemyLevel = this.FPlayerEnemyInforPanle["Level"];
         this.FBtnFight = new TUIButton();
         this.FBtnFight.Substrate = this.FPlayerEnemyInforPanle["BtnFight"];
         this.FBtnFight.OnClick = this.BtnFightOnClick;
         this.FRemindFlag = this.FMainUI["RemindFlag"];
         this.FEffect = this.FPlayerEnemyInforPanle["BtnFight"]["BtnEffect"];
      }
      
      protected function RenderView() : void
      {
         var _loc1_:THero = null;
         var _loc2_:TCharacter = null;
         var _loc3_:String = null;
         _loc2_ = SLogicsCore.Character;
         _loc1_ = _loc2_.Heros.GetHeroByIndex(0);
         SResourcesCore.TexturesBackgroundIcon.LoadAutoSecondary(_loc1_.Identifier,this.PicMeArrive);
         _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_22);
         this.FMyName.text = _loc2_.NickName;
         this.FMyLevel.text = TUtilityString.Format(_loc3_,_loc2_.GetMainRebirthLevel());
         if(this.FGongFuFightPlayerInfor != null)
         {
            this.FPlayerEnemy.visible = true;
            this.FEnemyPicMountPoint.bitmapData = null;
            this.FPlayerEnemyInforPanle.visible = true;
            this.FRemindFlag.visible = false;
            this.FRemindFlag.stop();
            SResourcesCore.TexturesBackgroundIcon.LoadAutoSecondary(this.FGongFuFightPlayerInfor.PlayerMainHeroID,this.PicMeArrive);
            _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_22);
            this.FEnemyName.text = this.FGongFuFightPlayerInfor.PlayerName;
            this.FEnemyLevel.text = TUtilityString.Format(_loc3_,this.FGongFuFightPlayerInfor.PlayerLevel);
            this.FEffect.gotoAndPlay(1);
            this.FEffect.visible = true;
         }
         else
         {
            this.FPlayerEnemyInforPanle.visible = false;
            this.FPlayerEnemy.visible = false;
            this.FRemindFlag.visible = true;
            this.FRemindFlag.play();
            this.FEffect.visible = false;
            this.FEffect.stop();
         }
      }
      
      protected function PicMeArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:THero = null;
         _loc4_ = SLogicsCore.Character.Heros.GetHeroByIndex(0);
         if(_loc4_.Identifier == param3)
         {
            this.FMyPicMountPoint.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
         }
         if(this.FGongFuFightPlayerInfor != null)
         {
            if(this.FGongFuFightPlayerInfor.PlayerMainHeroID == param3)
            {
               this.FEnemyPicMountPoint.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
            }
         }
      }
      
      protected function BtnFightOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnStartFight != null)
         {
            this.FOnStartFight(this.FGongFuFightPlayerInfor);
         }
      }
      
      public function set OnStartFight(param1:Function) : void
      {
         this.FOnStartFight = param1;
      }
      
      public function Update(param1:TGongFuFightPlayerInfor) : void
      {
         this.FGongFuFightPlayerInfor = param1;
         this.RenderView();
      }
      
      public function OpenView() : void
      {
         this.FMainUI.gotoAndPlay(1);
         this.FEnemyPanleInfor.gotoAndPlay(1);
      }
      
      public function Reset() : void
      {
         this.FMyPicMountPoint.bitmapData = null;
         this.FEnemyPicMountPoint.bitmapData = null;
         this.FEffect.stop();
      }
   }
}

