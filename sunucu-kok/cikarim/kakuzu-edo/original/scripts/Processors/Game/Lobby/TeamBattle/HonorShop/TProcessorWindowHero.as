package Processors.Game.Lobby.TeamBattle.HonorShop
{
   import Foundation.Network.*;
   import Foundation.Queries.Textures.TQueryAnimationSequence;
   import Foundation.Resources.Repositories.TResourceRepositoryTexture;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HonorShop.*;
   import Logics.Purchases.TPurchaseParameters;
   import Logics.Purchases.TPurchaseRequest;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.TeamBattle.HonorShop.Component.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.text.*;
   
   public class TProcessorWindowHero extends TProcessorLobbyWindow
   {
      
      protected static var COUNT_HEROLIST:uint = 3;
      
      protected var FPurchaseParameters:TPurchaseParameters;
      
      protected var FScene:Sprite;
      
      protected var FMC_HeroInfo:Sprite;
      
      protected var FTF_HeroInventory:TextField;
      
      protected var FUIHeroList:Vector.<TUIHonorShopHeroItem>;
      
      protected var FUIHeroInfo:TUIHonorShopHeroInfo;
      
      protected var FDataHonorShop:THonorShopData;
      
      protected var FDataHero:Vector.<THonorShopItem>;
      
      protected var FDataOnClick:THonorShopItem;
      
      protected var FCharacter:TCharacter;
      
      protected var FRoleModelIDs:Vector.<uint>;
      
      protected var FUIWindowInformation:TUIWindowConfirmation;
      
      protected var FBtnOKOnClick:Function;
      
      protected var FOnExchange:Function;
      
      public function TProcessorWindowHero(param1:TUIComponent)
      {
         super(param1);
         this.FCharacter = SLogicsCore.Character;
         this.FRoleModelIDs = new Vector.<uint>();
         this.ConstructPurchase();
      }
      
      protected function ConstructPurchase() : void
      {
         this.FPurchaseParameters = new TPurchaseParameters();
         this.FPurchaseParameters.RoutineSuccess = this.PurchaseRoutineSuccess;
         this.FPurchaseParameters.RoutineFailure = this.PurchaseRoutineFailure;
         this.FPurchaseParameters.RoutineCancel = this.PurchaseRoutineCancel;
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.LogicsPerform();
         if(this.FScene != null && this.FScene.visible && this.FUIHeroList.length > 0)
         {
            _loc2_ = int(this.FUIHeroList.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FUIHeroList[_loc1_].ProcessorUpdateHero();
               _loc1_++;
            }
         }
      }
      
      protected function Resources_UIDispatch(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TUIHonorShopHeroItem = null;
         this.FScene = param1;
         this.FMC_HeroInfo = this.FScene[CONST_HONORSHOP.RESOURCE_Link_MC_HeroInfo];
         this.FTF_HeroInventory = this.FScene[CONST_HONORSHOP.RESOURCE_Link_TF_HeroInventory];
         this.FTF_HeroInventory.mouseEnabled = false;
         this.FTF_HeroInventory.text = "";
         if(this.FScene[CONST_HONORSHOP.RESOURCE_Link_MC_HeroList + 3] != null)
         {
            COUNT_HEROLIST = 4;
         }
         _loc3_ = int(COUNT_HEROLIST);
         this.FUIHeroList = new Vector.<TUIHonorShopHeroItem>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = new TUIHonorShopHeroItem(this);
            _loc4_.SequenceDefaultRole = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCEID_Textures_DefaultRole,0);
            _loc4_.OnBtnOKClick = this.BtnOkOnClick;
            _loc4_.OnHeroClick = this.HeroOnClick;
            _loc4_.OnQuerySequenceContext = this.HeroOnQuerySequenceContext;
            _loc4_.Perform_UIDispatch(this.FScene[CONST_HONORSHOP.RESOURCE_Link_MC_HeroList + _loc2_]);
            this.FUIHeroList[_loc2_] = _loc4_;
            _loc4_.Hide();
            _loc2_++;
         }
         this.FUIWindowInformation = SUtilityOverLayer.UIWindowConfirmation;
         this.FUIHeroInfo = new TUIHonorShopHeroInfo(this);
         this.FUIHeroInfo.OnHintOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FUIHeroInfo.OnHintOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FUIHeroInfo.Perform_UIDispatch(this.FMC_HeroInfo);
         this.FUIHeroInfo.Hide();
      }
      
      protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         _loc2_ = int(COUNT_HEROLIST);
         if(false)
         {
            _loc2_ = int(this.FDataHonorShop.HeroItems.length);
         }
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FUIHeroList[_loc1_].Show();
            this.FUIHeroList[_loc1_].ProcessorUpdateUI(this.FDataHonorShop.HonorCount,this.FDataHonorShop.HeroItems[_loc1_]);
            this.FUIHeroList[_loc1_].Visible = true;
            _loc1_++;
         }
         _loc3_ = CONST_COMMON.RewardIDToTemplateID(this.FDataHonorShop.HeroItems[0].Mall.Items.Type,this.FDataHonorShop.HeroItems[0].Mall.Items.Code);
         this.FTF_HeroInventory.text = this.FCharacter.Appliances.GetCountByTempleteID(_loc3_).toString();
      }
      
      protected function DoClear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         if(this.FUIHeroList != null && this.FUIHeroList.length > 0)
         {
            _loc2_ = int(this.FUIHeroList.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FUIHeroList[_loc1_].Clear();
               _loc1_++;
            }
         }
         if(this.FUIHeroInfo != null)
         {
            this.FUIHeroInfo.Clear();
         }
         _loc2_ = int(this.FRoleModelIDs.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FRoleModelIDs[_loc1_];
            SResourcesCore.TexturesModel.DeleteByIdentifier(_loc3_,true);
            _loc1_++;
         }
         this.FRoleModelIDs.length = 0;
      }
      
      protected function HeroOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         var _loc8_:TRoleModel = null;
         var _loc9_:uint = 0;
         _loc5_ = param2 as uint;
         _loc6_ = SResourcesCore.TexturesModel;
         _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,_loc5_) as TRoleModel;
         _loc9_ = CONST_ROLE.GetModelIDByIndex(_loc8_.Model,CONST_ROLE.ROLE_SEQUENCEINDEX_Showcase);
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc9_);
         if(_loc7_ != null)
         {
            param3.Value = _loc7_.GetAnimationSequenceByIndex(0);
         }
         else
         {
            _loc6_.LoadSecondary(_loc9_);
         }
         this.SetRoleModelID(_loc9_);
      }
      
      protected function SetRoleModelID(param1:uint) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FRoleModelIDs.indexOf(param1);
         if(_loc2_ < 0)
         {
            this.FRoleModelIDs.push(param1);
         }
      }
      
      protected function PurchaseRoutineSuccess() : void
      {
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_20));
      }
      
      protected function PurchaseRoutineFailure() : void
      {
      }
      
      protected function PurchaseRoutineCancel() : void
      {
      }
      
      protected function WindowInformationOnOK(param1:Object) : void
      {
         var _loc2_:TPurchaseRequest = null;
         _loc2_ = SLogicsCore.PoolPurchase.AcquirePurchaseRequest();
         _loc2_.IDTemplate = this.FDataOnClick.Mall.Identifier;
         _loc2_.Quantity = 1;
         if(this.FOnExchange != null)
         {
            this.FOnExchange(this,_loc2_,this.FPurchaseParameters);
         }
      }
      
      protected function WindowInformationOnCancel(param1:Object) : void
      {
         this.FDataOnClick = null;
      }
      
      protected function BtnOkOnClick(param1:Object, param2:THonorShopItem) : void
      {
         var _loc3_:uint = 0;
         this.FDataOnClick = param2;
         if(this.FDataHonorShop.CanBuyCount <= 0)
         {
            if(FOnEffectText != null)
            {
               FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_57));
            }
            return;
         }
         _loc3_ = CONST_COMMON.RewardIDToTemplateID(this.FDataOnClick.Mall.Items.Type,this.FDataOnClick.Mall.Items.Code);
         if(this.FCharacter.Appliances.GetCountByTempleteID(_loc3_) >= this.FDataOnClick.Mall.Items.Amount)
         {
            this.FUIWindowInformation.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_58);
            this.FUIWindowInformation.OnOK = this.WindowInformationOnOK;
            this.FUIWindowInformation.OnCancel = this.WindowInformationOnCancel;
            this.FUIWindowInformation.Visible = true;
         }
         else if(FOnEffectText != null)
         {
            FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_59));
         }
      }
      
      protected function HeroOnClick(param1:TBaseHero) : void
      {
         if(this.FUIHeroInfo != null)
         {
            this.FUIHeroInfo.ProcessorUpdateUI(param1);
            this.FUIHeroInfo.Show();
         }
      }
      
      public function get BtnOKOnClick() : Function
      {
         return this.FBtnOKOnClick;
      }
      
      public function set BtnOKOnClick(param1:Function) : void
      {
         this.FBtnOKOnClick = param1;
      }
      
      public function get OnExchange() : Function
      {
         return this.FOnExchange;
      }
      
      public function set OnExchange(param1:Function) : void
      {
         this.FOnExchange = param1;
      }
      
      public function Perform_UIDispatch(param1:Sprite) : void
      {
         this.Resources_UIDispatch(param1);
      }
      
      public function ProcessorUpdateUI(param1:THonorShopData) : void
      {
         this.FDataHonorShop = param1;
         this.FDataHero = this.FDataHonorShop.HeroItems;
         if(this.FScene.visible)
         {
            this.UpdateUI();
         }
      }
      
      public function Clear() : void
      {
         this.DoClear();
      }
      
      public function Show() : void
      {
         this.FScene.visible = true;
      }
      
      public function Hide() : void
      {
         this.FScene.visible = false;
         if(this.FUIHeroInfo != null)
         {
            this.FUIHeroInfo.Hide();
         }
      }
   }
}

