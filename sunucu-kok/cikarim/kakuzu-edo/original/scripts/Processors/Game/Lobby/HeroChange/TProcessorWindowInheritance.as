package Processors.Game.Lobby.HeroChange
{
   import Components.Pages.TUIPage;
   import Components.SelectBox.TSelectBoxSingle;
   import Components.Standard.TUIButton;
   import Foundation.Common.THint;
   import Foundation.Network.*;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.TArticle;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.HeroChange.*;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.TextField;
   import flash.utils.*;
   
   public class TProcessorWindowInheritance extends TProcessorLobbyWindow
   {
      
      protected static const LIST_LEN:int = 5;
      
      protected static const MaxStarNum:int = 7;
      
      protected static const Left_Index:int = 0;
      
      protected static const Right_Index:int = 1;
      
      protected static const Change_Hero_Inherit_Silver:uint = 60380007;
      
      protected static const Change_Hero_Inherit_Gold:uint = 60380008;
      
      protected static const Change_Hero_Inherit_Silver_percent:uint = 60380009;
      
      protected static const Change_Hero_Inherit_Gold_percent:uint = 60380010;
      
      protected var FUIPage:TUIPage;
      
      protected var FBtnLeftCancel:TUIButton;
      
      protected var FBtnRightCancel:TUIButton;
      
      protected var FBtnOk:TUIButton;
      
      protected var FCurrentHeroPage:int;
      
      protected var FHeros:Vector.<THeroChange>;
      
      protected var FEffect:MovieClip;
      
      protected var FHeroHead1:Bitmap;
      
      protected var FHeroHead2:Bitmap;
      
      protected var FSelectBox:TSelectBoxSingle;
      
      protected var FTxtName1:TextField;
      
      protected var FTxtName2:TextField;
      
      protected var FStarsUI:Vector.<Sprite>;
      
      protected var FLightStars:Vector.<Vector.<Sprite>>;
      
      protected var FDarkStars:Vector.<Vector.<Sprite>>;
      
      protected var FHeroTextures:Vector.<BitmapData>;
      
      protected var FHeroList:Vector.<THeroChange>;
      
      protected var FHeroHeads:Vector.<Bitmap>;
      
      protected var FHeroInfors:Vector.<Sprite>;
      
      protected var FMilitaryTypes:Vector.<MovieClip>;
      
      protected var FSelectHeros:Vector.<THeroChange>;
      
      protected var FSelectHero:THeroChange;
      
      protected var FReceiveHero:THeroChange;
      
      protected var FHint:THint;
      
      protected var FTxtGet:TextField;
      
      protected var FIsReceive:Boolean;
      
      protected var FHeroChangeData:THeroChangeData;
      
      protected var FInheritSiliverCost:int = 100;
      
      protected var FInheritGoldCost:int = 100;
      
      protected var FRate:Number;
      
      protected var FCost:int;
      
      protected var FChipName:String;
      
      protected var FSelectIndex:uint;
      
      protected var FConfigValue:TBins;
      
      protected var FRateNomal:Number;
      
      protected var FRateGold:Number;
      
      protected var FNomalNum:uint;
      
      protected var FGoldNum:uint;
      
      public function TProcessorWindowInheritance(param1:TUIComponent)
      {
         super(param1);
         this.FHeros = new Vector.<THeroChange>();
      }
      
      public function UIDispatch(param1:Sprite) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:Sprite = null;
         var _loc4_:int = 0;
         var _loc5_:Bitmap = null;
         var _loc6_:Vector.<Sprite> = null;
         var _loc7_:Vector.<Sprite> = null;
         var _loc8_:Sprite = null;
         var _loc9_:int = 0;
         addChild(param1);
         this.FHeroInfors = new Vector.<Sprite>();
         this.FMilitaryTypes = new Vector.<MovieClip>();
         this.FHeroHeads = new Vector.<Bitmap>();
         _loc2_ = param1["HeroList"];
         this.FBtnOk = new TUIButton();
         this.FBtnOk.Substrate = param1["Btn_Ok"];
         this.FBtnOk.OnClick = this.BtnInheritanceOnClick;
         this.FBtnLeftCancel = new TUIButton();
         this.FBtnLeftCancel.Substrate = param1["Btn_Cancel_Left"];
         this.FBtnRightCancel = new TUIButton();
         this.FBtnRightCancel.Substrate = param1["Btn_Cancel_right"];
         this.FEffect = param1["MC_PetEffect"];
         this.FEffect.mouseEnabled = false;
         this.FEffect.mouseChildren = false;
         this.FEffect.visible = false;
         this.FEffect.addFrameScript(this.FEffect.totalFrames - 1,this.CancelButtons);
         this.FConfigValue = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue) as TBins;
         this.FRateNomal = (this.FConfigValue.GetDatebaseByIdentifier(Change_Hero_Inherit_Silver_percent) as TConfigValue).Value as Number;
         this.FRateGold = (this.FConfigValue.GetDatebaseByIdentifier(Change_Hero_Inherit_Gold_percent) as TConfigValue).Value as Number;
         this.FNomalNum = uint((this.FConfigValue.GetDatebaseByIdentifier(Change_Hero_Inherit_Silver) as TConfigValue).Value);
         this.FGoldNum = uint((this.FConfigValue.GetDatebaseByIdentifier(Change_Hero_Inherit_Gold) as TConfigValue).Value);
         this.FSelectBox = new TSelectBoxSingle();
         this.FSelectBox.SetTaskByIndex(0,param1["Need1"]["task_0"]);
         this.FSelectBox.SetTaskByIndex(1,param1["Need2"]["task_0"]);
         this.FSelectBox.CallBackOnSelect = this.SelectBoxSingleOnClick;
         this.FSelectBox.Init();
         this.SelectBoxSingleOnClick(null,0);
         this.FTxtName1 = param1["Name1"];
         this.FTxtName2 = param1["Name2"];
         this.FHeroHead1 = new Bitmap();
         param1["HeroHead1"].addChild(this.FHeroHead1);
         this.FHeroHead2 = new Bitmap();
         param1["HeroHead2"].addChild(this.FHeroHead2);
         this.FHeroTextures = new Vector.<BitmapData>(LIST_LEN);
         this.FHeroList = new Vector.<THeroChange>(LIST_LEN);
         _loc4_ = 0;
         while(_loc4_ < LIST_LEN)
         {
            _loc5_ = new Bitmap();
            this.FHeroHeads.push(_loc5_);
            _loc2_["mc_hero_" + _loc4_]["MC_MountPoint"].addChild(_loc5_);
            this.FHeroInfors.push(_loc2_["mc_hero_" + _loc4_]);
            this.FMilitaryTypes.push(_loc2_["mc_hero_" + _loc4_]["mc_militaryType"]);
            this.FHeroInfors[_loc4_]["mc_over"].visible = false;
            this.FHeroInfors[_loc4_].addEventListener(MouseEvent.CLICK,this.HeroHeadOnClick);
            this.FHeroInfors[_loc4_].addEventListener(MouseEvent.MOUSE_OVER,this.HeroHeadOnOver);
            this.FHeroInfors[_loc4_].addEventListener(MouseEvent.MOUSE_OUT,this.HeroHeadOnOut);
            _loc4_++;
         }
         _loc3_ = _loc2_["MC_HeroPage"];
         this.FUIPage = new TUIPage(this);
         this.FUIPage.ButtonNext.Substrate = _loc3_["MC_PageRight"];
         this.FUIPage.ButtonPrevious.Substrate = _loc3_["MC_PageLeft"];
         this.FUIPage.LabelPage = _loc3_["TF_Page"];
         this.FUIPage.PageSize = LIST_LEN;
         this.FUIPage.OnChangePage = this.PageOnSwitch;
         this.FUIPage.Init();
         this.FBtnLeftCancel.OnClick = this.BtnOnCancel;
         this.FBtnRightCancel.OnClick = this.BtnOnCancel;
         this.FStarsUI = new Vector.<Sprite>();
         this.FLightStars = new Vector.<Vector.<Sprite>>();
         this.FDarkStars = new Vector.<Vector.<Sprite>>();
         _loc4_ = 0;
         while(_loc4_ < 2)
         {
            _loc8_ = param1["StarLevel" + (_loc4_ + 1)];
            _loc8_.visible = false;
            this.FStarsUI.push(_loc8_);
            _loc6_ = new Vector.<Sprite>();
            _loc7_ = new Vector.<Sprite>();
            _loc9_ = 0;
            while(_loc9_ < MaxStarNum)
            {
               _loc6_.push(_loc8_["Lightstar" + _loc9_]);
               _loc7_.push(_loc8_["Darkstar" + _loc9_]);
               _loc9_++;
            }
            this.FLightStars.push(_loc6_);
            this.FDarkStars.push(_loc7_);
            _loc8_.addEventListener(MouseEvent.MOUSE_MOVE,this.StarOnMouseMove);
            _loc8_.addEventListener(MouseEvent.MOUSE_OUT,this.OnStartMouseOut);
            _loc4_++;
         }
         this.FTxtGet = param1["Txt_Get"];
         this.FTxtGet.text = "";
         this.FHint = new THint();
         this.FSelectHeros = new Vector.<THeroChange>();
         param1["Need1"]["CostValue_0"].text = this.FNomalNum + "";
         param1["Need2"]["CostValue_0"].text = this.FGoldNum + "";
      }
      
      public function UILocation() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         _loc1_ = 0;
         while(_loc1_ < LIST_LEN)
         {
            _loc2_ = this.FHeroInfors[_loc1_];
            _loc2_.addEventListener(MouseEvent.MOUSE_MOVE,this.HeroHeadOnMouseMove);
            _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.OnStartMouseOut);
            _loc1_++;
         }
      }
      
      protected function BtnInheritanceOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FCost <= 0)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_42));
            return;
         }
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_40),this.FChipName,this.FCost);
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.ReqInheritance;
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
      }
      
      protected function HeroHeadOnMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FHeroInfors.indexOf(param1.currentTarget as Sprite);
         _loc2_ += this.FCurrentHeroPage * LIST_LEN;
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FSelectHeros[_loc2_]);
      }
      
      protected function StarOnMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:THeroChange = null;
         _loc2_ = this.FStarsUI.indexOf(param1.currentTarget as Sprite);
         if(_loc2_ == 0)
         {
            _loc3_ = this.FSelectHero;
         }
         else
         {
            _loc3_ = this.FReceiveHero;
         }
         SUtilityOverLayer.UIComponentsHintOnOver(this,_loc3_);
      }
      
      protected function OnStartMouseOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHeros[0]);
      }
      
      protected function SelectBoxSingleOnClick(param1:Object, param2:int) : void
      {
         this.FSelectIndex = param2;
         if(param2 == 0)
         {
            this.FRate = this.FRateNomal * 0.01;
         }
         else if(param2 == 1)
         {
            this.FRate = this.FRateGold * 0.01;
         }
         if(this.FSelectHero)
         {
            this.CalculateCost();
         }
      }
      
      protected function BtnOnCancel(param1:Object, param2:MouseEvent) : void
      {
         if(param1 as TUIButton == this.FBtnLeftCancel)
         {
            this.SetCancel(0);
         }
         else
         {
            this.SetCancel(1);
         }
      }
      
      protected function PageOnSwitch(param1:Object, param2:int) : void
      {
         this.FCurrentHeroPage = param2;
         this.RenderHeroList();
      }
      
      protected function HeroHeadOnClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:THeroChange = null;
         var _loc4_:int = 0;
         _loc2_ = this.FHeroInfors.indexOf(param1.currentTarget as Sprite);
         this.FHeroInfors[_loc2_]["mc_over"].visible = true;
         _loc3_ = this.FHeroList[_loc2_];
         if(!this.FIsReceive)
         {
            this.FIsReceive = true;
            this.FHeroHead1.bitmapData = this.FHeroTextures[_loc2_];
            this.FTxtName1.text = _loc3_.Hero.Name;
            this.FTxtName1.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[_loc3_.Hero.Quality];
            this.FStarsUI[0].visible = true;
            this.RenderStarLevel(_loc3_,this.FLightStars[0],this.FDarkStars[0]);
            this.FSelectHero = _loc3_;
            this.FSelectHeros.length = 0;
            _loc4_ = 0;
            while(_loc4_ < this.FHeros.length)
            {
               if(this.FHeros[_loc4_].PartnerChanges.length <= this.FSelectHero.PartnerChanges.length)
               {
                  if(this.FHeros[_loc4_].Hero.Identifier != this.FSelectHero.Hero.Identifier)
                  {
                     this.FSelectHeros.push(this.FHeros[_loc4_]);
                  }
               }
               _loc4_++;
            }
            this.FCurrentHeroPage = 0;
            this.SetupPage(this.FSelectHeros.length,this.FCurrentHeroPage,this.FUIPage);
            this.RenderHeroList();
         }
         else
         {
            this.FReceiveHero = this.FSelectHeros[_loc2_ + this.FCurrentHeroPage * LIST_LEN];
            this.FHeroHead2.bitmapData = this.FHeroTextures[_loc2_];
            this.FTxtName2.text = _loc3_.Hero.Name;
            this.FTxtName2.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[_loc3_.Hero.Quality];
            this.FStarsUI[1].visible = true;
            this.RenderStarLevel(_loc3_,this.FLightStars[1],this.FDarkStars[1]);
            this.CalculateCost();
         }
      }
      
      protected function HeroHeadOnOver(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FHeroInfors.indexOf(param1.currentTarget as Sprite);
         this.FHeroInfors[_loc2_]["mc_over"].visible = true;
      }
      
      protected function HeroHeadOnOut(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FHeroInfors.indexOf(param1.currentTarget as Sprite);
         this.FHeroInfors[_loc2_]["mc_over"].visible = false;
      }
      
      protected function SetCancel(param1:int) : void
      {
         var _loc2_:int = 0;
         this.FHeroHead2.bitmapData = null;
         this.FStarsUI[Right_Index].visible = false;
         this.FTxtName2.text = "";
         this.FTxtGet.text = "";
         if(param1 == Left_Index)
         {
            this.FHeroHead1.bitmapData = null;
            this.FIsReceive = false;
            this.FTxtName1.text = "";
            this.FStarsUI[0].visible = false;
            this.FCurrentHeroPage = 0;
            this.SetupPage(SLogicsCore.Character.Heros.Count,this.FCurrentHeroPage,this.FUIPage);
            this.RenderHeroSelectInfo();
            this.RenderHeroList();
         }
      }
      
      protected function ReqInheritance(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_HeroChange_InheritanceReq);
         _loc3_ = _loc2_.Data;
         _loc3_.writeUnsignedInt(this.FSelectHero.Hero.Identifier);
         _loc3_.writeUnsignedInt(this.FReceiveHero.Hero.Identifier);
         _loc3_.writeUnsignedInt(this.FSelectIndex);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function RenderStarLevel(param1:THeroChange, param2:Vector.<Sprite>, param3:Vector.<Sprite>) : void
      {
         var _loc4_:int = 0;
         _loc4_ = 0;
         while(_loc4_ < MaxStarNum)
         {
            param2[_loc4_].visible = _loc4_ < param1.Hero.ChangeSchedule;
            param3[_loc4_].visible = _loc4_ < param1.PartnerChanges.length;
            _loc4_++;
         }
      }
      
      protected function EffectPlay() : void
      {
         this.FEffect.visible = true;
         this.FEffect.gotoAndPlay(1);
      }
      
      protected function CancelButtons() : void
      {
         this.SetCancel(Left_Index);
         this.FEffect.stop();
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_41),this.FChipName,this.FCost);
      }
      
      protected function SetupPage(param1:int, param2:int, param3:TUIPage) : void
      {
         param3.TotalQuantity = param1;
         param3.Update();
         param3.PageIndex = param2;
      }
      
      protected function RenderHeroSelectInfo() : void
      {
         var _loc1_:int = 0;
         this.FSelectHeros.length = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FHeros.length)
         {
            this.FSelectHeros.push(this.FHeros[_loc1_]);
            _loc1_++;
         }
      }
      
      protected function RenderHeroList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THero = null;
         var _loc6_:uint = 0;
         _loc2_ = this.FCurrentHeroPage * LIST_LEN;
         _loc3_ = Math.min(this.FSelectHeros.length,_loc2_ + LIST_LEN);
         _loc4_ = 0;
         _loc1_ = _loc2_;
         while(_loc1_ < _loc3_)
         {
            _loc5_ = this.FSelectHeros[_loc1_].Hero;
            _loc6_ = TUtilityLobby.GetStandPositionWithProfession(_loc5_.Profession);
            this.FHeroInfors[_loc4_].mouseEnabled = true;
            this.FHeroInfors[_loc4_].mouseChildren = true;
            this.FMilitaryTypes[_loc4_].visible = true;
            this.FMilitaryTypes[_loc4_].gotoAndStop(_loc6_);
            SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc5_.SmallID,this.PicArrive);
            _loc4_++;
            _loc1_++;
         }
         _loc1_ = _loc4_;
         while(_loc1_ < LIST_LEN)
         {
            this.FHeroHeads[_loc1_].bitmapData = null;
            this.FHeroInfors[_loc1_].mouseEnabled = false;
            this.FHeroInfors[_loc1_].mouseChildren = false;
            this.FMilitaryTypes[_loc1_].visible = false;
            _loc1_++;
         }
      }
      
      protected function CalculateCost() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TArticle = null;
         var _loc6_:Number = NaN;
         _loc2_ = this.FSelectHero.HeroChipNum;
         _loc1_ = this.FSelectHero.Hero.ChangeSchedule;
         _loc3_ = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_ += this.FSelectHero.PartnerChanges[_loc3_].Rewards.Amount[0];
            _loc3_++;
         }
         if(this.FReceiveHero.HeroChangeAttr.ChipValue > 0)
         {
            _loc6_ = this.FSelectHero.HeroChangeAttr.ChipValue / this.FReceiveHero.HeroChangeAttr.ChipValue;
         }
         else
         {
            _loc6_ = 0;
         }
         _loc2_ *= _loc6_ * this.FRate;
         _loc4_ = this.FReceiveHero.HeroChangeAttr.ChipID;
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc4_) as TArticle;
         this.FChipName = _loc5_.Name;
         this.FCost = _loc2_;
         this.FTxtGet.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_39),this.FChipName,this.FCost);
      }
      
      protected function PicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:int = 0;
         var _loc5_:THeroChange = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         _loc6_ = this.FCurrentHeroPage * LIST_LEN;
         _loc7_ = _loc6_ + LIST_LEN;
         _loc7_ = _loc7_ > this.FSelectHeros.length ? int(this.FSelectHeros.length) : _loc7_;
         _loc8_ = 0;
         _loc4_ = _loc6_;
         while(_loc4_ < _loc7_)
         {
            _loc5_ = this.FSelectHeros[_loc4_];
            if(_loc5_.Hero.SmallID == param3)
            {
               this.FHeroTextures[_loc8_] = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
               this.FHeroList[_loc8_] = _loc5_;
               this.FHeroHeads[_loc8_].bitmapData = this.FHeroTextures[_loc8_];
               return;
            }
            _loc8_++;
            _loc4_++;
         }
      }
      
      public function ChangeHeroList(param1:Vector.<THeroChange>, param2:int) : void
      {
         var _loc3_:THeros = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc3_ = SLogicsCore.Character.Heros;
         _loc5_ = _loc3_.Count;
         this.FHeros.length = 0;
         _loc4_ = 1;
         while(_loc4_ < _loc5_)
         {
            this.FHeros.push(this.FHeroChangeData.GetHeroChangeByHeroID(_loc3_.GetHeroByIndex(_loc4_).Identifier));
            _loc4_++;
         }
         this.SetupPage(_loc5_,0,this.FUIPage);
         this.FCurrentHeroPage = 0;
         this.CancelButtons();
      }
      
      public function InheritanceNotify() : void
      {
         this.EffectPlay();
         this.RenderHeroSelectInfo();
      }
      
      public function set HeroChangeData(param1:THeroChangeData) : void
      {
         this.FHeroChangeData = param1;
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FHeroHeads.length)
         {
            this.FHeroHeads[_loc1_].bitmapData = null;
            this.FHeroTextures[_loc1_] = null;
            _loc1_++;
         }
         this.FHeroHead1.bitmapData = null;
         this.FHeroHead2.bitmapData = null;
      }
   }
}

