package Processors.Game.Lobby.HeroCompanion.Components
{
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.TCompanionCard;
   import Logics.HeroCompanion.*;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class TCompanionCardTip extends TProcessorLobbyWindow
   {
      
      protected static var FCacheCardId:int;
      
      protected var SpaceY:int = 20;
      
      protected var FMainUI:Sprite;
      
      protected var FTFName:TextField;
      
      protected var FBackground:Sprite;
      
      protected var FData:TCompanionCard;
      
      protected var FCompanionData:THeroCompanionData;
      
      protected var FCardId:int;
      
      protected var FCardDesc:TCompanionCardDesc;
      
      public function TCompanionCardTip(param1:TUIComponent)
      {
         super(param1);
         this.mouseChildren = false;
         this.mouseEnabled = false;
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance(CONST_HEROCOMPANION.ResourceID_CompanionCardTip) as Sprite;
         addChild(this.FMainUI);
         this.InitWindow();
      }
      
      protected function InitWindow() : void
      {
         this.FTFName = this.FMainUI["TF_Name"];
         this.FBackground = this.FMainUI["MC_Bg"];
         this.FCardDesc = new TCompanionCardDesc(this.FMainUI["MC_Desc"]);
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
      
      public function InitData(param1:THeroCompanionData) : void
      {
         this.FCompanionData = param1;
      }
      
      public function SetData(param1:TCompanionCard) : void
      {
         var _loc2_:int = 0;
         this.FData = param1;
         if(this.FData == null)
         {
            return;
         }
         if(FCacheCardId == this.FData.Identifier)
         {
            return;
         }
         FCacheCardId = this.FData.Identifier;
         this.FCardDesc.Clear();
         this.FCardId = this.FData.Identifier;
         this.FTFName.htmlText = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_COMPANION_08),CONST_HEROCOMPANION.TextColor[this.FData.Quality],this.FData.Name);
         this.FCardDesc.SetData(this.FData);
         this.FBackground.height = this.FCardDesc.Y + this.FCardDesc.Height + this.SpaceY;
      }
      
      public function Update() : void
      {
         this.UpdatePosition_Perform();
      }
   }
}

