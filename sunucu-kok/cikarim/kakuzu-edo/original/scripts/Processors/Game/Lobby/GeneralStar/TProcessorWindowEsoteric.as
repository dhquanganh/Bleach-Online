package Processors.Game.Lobby.GeneralStar
{
   import Components.Pages.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.GeneralStar.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.GeneralStar.PackageStarPoint.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowEsoteric extends TProcessorLobbyWindow
   {
      
      protected static const POINT_ID:uint = 17200000;
      
      protected const POINT_COUNT:Vector.<int> = CONST_GENERAL_STAR.PointCount;
      
      protected const BAR_COUNT:Vector.<int> = CONST_GENERAL_STAR.BarCount;
      
      protected var FGeneralStarMC:MovieClip;
      
      protected var FReelLeft:MovieClip;
      
      protected var FReelRight:MovieClip;
      
      protected var FUIPage:TUIPage;
      
      protected var FCurrentPage:int;
      
      protected var FTotalQuantity:int;
      
      protected var FTimerID:uint;
      
      protected var FEsotericMC:Sprite;
      
      protected var FEsotericText:TextField;
      
      protected var FReelNameBox:Sprite;
      
      protected var FReelName:TextField;
      
      protected var FMiddleBackgrounds:Vector.<TUIMiddleBackground>;
      
      protected var FCharacter:TCharacter;
      
      protected var FEsotericPoints:TEsotericPoints;
      
      protected var FPageIndex:uint;
      
      protected var FMapIndex:uint;
      
      protected var FStarPointBin:TBins;
      
      protected var FStarMapBin:TBins;
      
      protected var FIsInit:Boolean;
      
      protected var FEsoterics:Vector.<TEsotericPoints>;
      
      protected var FOnHelpTipsOver:Function;
      
      protected var FOnHelpTipsOut:Function;
      
      protected var FOnPointMove:Function;
      
      protected var FOnPointOut:Function;
      
      protected var FOnPointClick:Function;
      
      protected var FOnSetQuality:Function;
      
      public function TProcessorWindowEsoteric(param1:TUIComponent, param2:MovieClip)
      {
         super(param1);
         this.FGeneralStarMC = param2;
         this.FUIPage = new TUIPage(this);
         this.FMiddleBackgrounds = new Vector.<TUIMiddleBackground>(this.POINT_COUNT.length);
         this.FCharacter = SLogicsCore.Character;
         this.FEsotericPoints = this.FCharacter.EsotericPoints;
         this.FEsoterics = new Vector.<TEsotericPoints>(this.POINT_COUNT.length);
      }
      
      protected function EsotericInit() : void
      {
         var _loc1_:TConfigValue = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:uint = 0;
         var _loc6_:MovieClip = null;
         var _loc7_:TUIMiddleBackground = null;
         addChild(this.FGeneralStarMC);
         this.FReelLeft = this.FGeneralStarMC["MC_Page"][CONST_GENERAL_STAR.RESOURCESID_NAME_ReelLeft];
         this.FUIPage.ButtonPrevious.Substrate = this.FReelLeft;
         this.FReelRight = this.FGeneralStarMC["MC_Page"][CONST_GENERAL_STAR.RESOURCESID_NAME_ReelRight];
         this.FUIPage.ButtonNext.Substrate = this.FReelRight;
         this.FUIPage.PageSize = 1;
         this.FUIPage.Init();
         this.FUIPage.OnChangePage = this.OnChangePage;
         this.FReelName = this.FGeneralStarMC["MC_Page"][CONST_GENERAL_STAR.RESPIRCESID_MC_REELNAME];
         this.FEsotericMC = this.FGeneralStarMC[CONST_GENERAL_STAR.RESPIRCESID_MC_SoulsBox];
         this.FEsotericText = this.FEsotericMC[CONST_GENERAL_STAR.RESPIRCESID_MC_Souls];
         _loc4_ = this.FGeneralStarMC[CONST_GENERAL_STAR.RESPIRCESID_MC_Reels];
         _loc3_ = this.POINT_COUNT.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = _loc4_[CONST_GENERAL_STAR.RESOURCESID_REEL + _loc2_];
            _loc5_ = uint(this.POINT_COUNT[_loc2_]);
            _loc7_ = new TUIMiddleBackground(this);
            _loc7_.OnGeneralStarMove = this.FOnPointMove;
            _loc7_.OnGeneralStarOut = this.FOnPointOut;
            _loc7_.OnGeneralStarClick = this.FOnPointClick;
            _loc7_.Init(_loc6_,_loc5_,this.BAR_COUNT[_loc2_]);
            this.FMiddleBackgrounds[_loc2_] = _loc7_;
            _loc2_++;
         }
         this.FStarPointBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_StarPoint);
         this.FStarMapBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_StarMap);
         this.FGeneralStarMC.MC_Open.visible = false;
      }
      
      private function OnChangePage(param1:Object, param2:int) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:TStarMap = null;
         if(param2 == this.FPageIndex)
         {
            return;
         }
         this.FPageIndex = param2;
         _loc3_ = 0;
         while(_loc3_ < this.POINT_COUNT.length)
         {
            this.FMiddleBackgrounds[_loc3_].Scene.visible = false;
            _loc3_++;
         }
         if(this.FPageIndex < this.FMapIndex)
         {
            this.FMiddleBackgrounds[this.FPageIndex].AllLight(this.FEsoterics[this.FPageIndex]);
         }
         if(this.FCharacter.StarMapIndex == this.FCharacter.EsotericPoints.GetEsotericPointByIndex(74).Identifier)
         {
            this.FMiddleBackgrounds[this.FPageIndex].AllLight(this.FEsoterics[this.FPageIndex]);
         }
         _loc4_ = this.FStarMapBin.GetDatebaseByIdentifier(this.FEsoterics[this.FPageIndex].GetEsotericPointByIndex(0).MapNum + POINT_ID) as TStarMap;
         this.FReelName.text = _loc4_.Name;
         this.FReelName.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[_loc4_.Quality];
         this.FGeneralStarMC.MC_BG.gotoAndStop(_loc4_.Quality - 1);
         this.UpdateInfo(_loc4_);
         this.FMiddleBackgrounds[this.FPageIndex].Scene.visible = true;
      }
      
      protected function UpdateInfo(param1:TStarMap) : void
      {
         var _loc2_:String = null;
         _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GENERALSTAR_FORMAT_04);
         _loc2_ += TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GENERALSTAR_FORMAT_05);
         _loc2_ = TUtilityString.Format(_loc2_,CONST_COMMON.TextColor[param1.Quality],param1.Name,CONST_COMMON.TextColor[param1.Quality + 1],TUtilityLobby.GetColorNameByIndex(param1.Quality + 1));
         this.FGeneralStarMC.MC_Information.TF_Information.htmlText = _loc2_;
      }
      
      protected function UpdateUIPage() : void
      {
         this.FUIPage.TotalQuantity = this.FMapIndex + 1;
         this.FUIPage.PageIndex = this.FPageIndex;
         this.FUIPage.Update();
      }
      
      protected function FilterPoint() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TEsotericPoints = null;
         var _loc4_:TEsotericPoint = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         _loc2_ = this.POINT_COUNT.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new TEsotericPoints();
            _loc6_ = uint(this.POINT_COUNT[_loc1_]);
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               _loc4_ = this.FEsotericPoints.GetEsotericPointByIndex(_loc5_ + _loc7_);
               _loc3_.AddEsotericPoint(_loc4_);
               _loc5_++;
            }
            _loc7_ += _loc6_;
            this.FEsoterics[_loc1_] = _loc3_;
            _loc1_++;
         }
      }
      
      protected function ShowReel() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TEsotericPoint = null;
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         var _loc5_:TStarMap = null;
         var _loc6_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < this.POINT_COUNT.length)
         {
            this.FMiddleBackgrounds[_loc1_].Scene.visible = false;
            _loc1_++;
         }
         _loc5_ = this.FStarMapBin.GetDatebaseByIdentifier(this.FEsoterics[this.FPageIndex].GetEsotericPointByIndex(0).MapNum + POINT_ID) as TStarMap;
         _loc4_ = _loc5_.Name;
         if(this.FCharacter.StarMapIndex == 0)
         {
            this.FMiddleBackgrounds[0].Scene.visible = true;
            this.FMiddleBackgrounds[0].UpdateGround(0,this.FEsoterics[0]);
            this.FMapIndex = 0;
         }
         else
         {
            _loc2_ = this.FEsotericPoints.GetEsotericPointByIdentifier(this.FCharacter.StarMapIndex) as TEsotericPoint;
            this.FPageIndex = _loc2_.MapNum - Math.floor(_loc2_.MapNum / 10) * 10 - 2;
            _loc3_ = uint(_loc2_.PointIndex);
            _loc5_ = this.FStarMapBin.GetDatebaseByIdentifier(this.FEsoterics[this.FPageIndex].GetEsotericPointByIndex(0).MapNum + POINT_ID) as TStarMap;
            _loc4_ = _loc5_.Name;
            if(_loc2_.PointIndex == this.POINT_COUNT[this.FPageIndex])
            {
               if(this.FPageIndex != this.POINT_COUNT.length - 1)
               {
                  this.FPageIndex += 1;
                  _loc3_ = 0;
                  _loc6_ = _loc2_.MapNum + 1 + POINT_ID;
                  _loc5_ = this.FStarMapBin.GetDatebaseByIdentifier(_loc6_) as TStarMap;
                  _loc4_ = _loc5_.Name;
               }
               else
               {
                  this.FMiddleBackgrounds[this.FPageIndex].AllLight(this.FEsoterics[this.FPageIndex]);
               }
            }
            this.FGeneralStarMC.MC_BG.gotoAndStop(_loc5_.Quality - 1);
            this.FMiddleBackgrounds[this.FPageIndex].UpdateGround(_loc3_,this.FEsoterics[this.FPageIndex]);
            this.FMiddleBackgrounds[this.FPageIndex].Scene.visible = true;
            this.FMapIndex = this.FPageIndex;
         }
         this.FReelName.text = _loc4_;
         this.FReelName.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[_loc5_.Quality];
         this.UpdateInfo(_loc5_);
      }
      
      private function UpdatePointAndCo() : void
      {
         var _loc1_:TEsotericPoint = null;
         var _loc2_:uint = 0;
         var _loc3_:String = null;
         var _loc4_:TStarMap = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:Vector.<String> = null;
         _loc1_ = this.FEsotericPoints.GetEsotericPointByIdentifier(this.FCharacter.StarMapIndex) as TEsotericPoint;
         _loc8_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRINGS_QUALITYCOLOR);
         this.FPageIndex = _loc1_.MapNum - Math.floor(_loc1_.MapNum / 10) * 10 - 2;
         if(_loc1_.PointIndex == this.POINT_COUNT[this.FPageIndex])
         {
            if(this.FPageIndex == this.POINT_COUNT.length - 1)
            {
               this.FMiddleBackgrounds[this.FPageIndex].UpdateGround(_loc1_.PointIndex - 1,this.FEsoterics[this.FPageIndex]);
               EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GENERALSTAR_FORMAT_09) + TUtilityLobby.GetColorNameByIndex(_loc8_.length - 1));
               if(this.FOnSetQuality != null)
               {
                  this.FOnSetQuality(_loc8_.length - 1);
               }
               return;
            }
            this.FPageIndex += 1;
            this.FMapIndex = this.FPageIndex;
            this.UpdateUIPage();
            _loc2_ = 0;
            _loc5_ = _loc1_.MapNum + 1 + POINT_ID;
            _loc4_ = this.FStarMapBin.GetDatebaseByIdentifier(_loc5_) as TStarMap;
            _loc3_ = _loc4_.Name;
            this.FReelName.text = _loc3_;
            this.FReelName.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[_loc4_.Quality];
            this.FGeneralStarMC.MC_BG.gotoAndStop(_loc4_.Quality - 1);
            this.UpdateInfo(_loc4_);
            this.FMiddleBackgrounds[this.FPageIndex].UpdateGround(_loc2_,this.FEsoterics[this.FPageIndex]);
            _loc7_ = this.FMiddleBackgrounds.length;
            _loc6_ = 0;
            while(_loc6_ < _loc7_)
            {
               this.FMiddleBackgrounds[_loc6_].Scene.visible = false;
               _loc6_++;
            }
            this.FMiddleBackgrounds[this.FPageIndex].Scene.visible = true;
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GENERALSTAR_FORMAT_09) + TUtilityLobby.GetColorNameByIndex(_loc4_.Quality));
            if(this.FOnSetQuality != null)
            {
               this.FOnSetQuality(_loc4_.Quality);
            }
         }
         else
         {
            this.FMiddleBackgrounds[this.FPageIndex].UpdatePointStar(_loc1_);
         }
         this.FEsotericText.text = this.FCharacter.GeneralsSoul.toString();
         this.UpdateUIPage();
      }
      
      protected function PlayAnimation() : void
      {
         this.FGeneralStarMC.MC_Effect.play();
      }
      
      public function get OnPointMove() : Function
      {
         return this.FOnPointMove;
      }
      
      public function set OnPointMove(param1:Function) : void
      {
         this.FOnPointMove = param1;
      }
      
      public function get OnPointOut() : Function
      {
         return this.FOnPointOut;
      }
      
      public function set OnPointOut(param1:Function) : void
      {
         this.FOnPointOut = param1;
      }
      
      public function get OnPointClick() : Function
      {
         return this.FOnPointClick;
      }
      
      public function set OnPointClick(param1:Function) : void
      {
         this.FOnPointClick = param1;
      }
      
      public function get OnSetQuality() : Function
      {
         return this.FOnSetQuality;
      }
      
      public function set OnSetQuality(param1:Function) : void
      {
         this.FOnSetQuality = param1;
      }
      
      public function Init() : void
      {
         if(!this.FIsInit)
         {
            this.FilterPoint();
            this.FIsInit = true;
         }
         this.PlayAnimation();
         this.ShowReel();
         this.UpdateUIPage();
         this.FEsotericText.text = this.FCharacter.GeneralsSoul.toString();
      }
      
      public function UpdatePoint() : void
      {
         this.UpdatePointAndCo();
      }
      
      public function GetGroundByIndex(param1:uint) : TUIMiddleBackground
      {
         return this.FMiddleBackgrounds[param1];
      }
      
      public function Esoteric() : void
      {
         this.EsotericInit();
      }
      
      public function Reset() : void
      {
         this.FGeneralStarMC.MC_Effect.stop();
      }
   }
}

