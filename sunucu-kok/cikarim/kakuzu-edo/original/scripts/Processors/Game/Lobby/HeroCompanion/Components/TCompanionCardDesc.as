package Processors.Game.Lobby.HeroCompanion.Components
{
   import Logics.DatebaseVO.VO.Json.TCompanionProperty;
   import Logics.DatebaseVO.VO.TCompanionCard;
   import Processors.Game.Lobby.HeroCompanion.Components.PropertyScroll.TCompanionScrollPropertyRender;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class TCompanionCardDesc
   {
      
      protected var Detial_OffsetX:int = 30;
      
      protected var SpaceY:int = 10;
      
      protected var FMainUI:Sprite;
      
      protected var FTFDesc0:TextField;
      
      protected var FTFDesc1:TextField;
      
      protected var FRenderBacks:Vector.<TCompanionScrollPropertyRender>;
      
      protected var FRenderPools:Vector.<TCompanionScrollPropertyRender>;
      
      public function TCompanionCardDesc(param1:Sprite)
      {
         super();
         this.FMainUI = param1;
         this.FTFDesc0 = this.FMainUI["TF_Desc_0"];
         this.FTFDesc1 = this.FMainUI["TF_Desc_1"];
         this.FTFDesc0.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_COMPANION_11);
         this.FTFDesc1.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_COMPANION_12);
         this.FRenderBacks = new Vector.<TCompanionScrollPropertyRender>();
         this.FRenderPools = new Vector.<TCompanionScrollPropertyRender>();
      }
      
      protected function GetRenderFromPool() : TCompanionScrollPropertyRender
      {
         var _loc1_:TCompanionScrollPropertyRender = null;
         _loc1_ = this.FRenderPools.pop();
         if(_loc1_ == null)
         {
            _loc1_ = new TCompanionScrollPropertyRender();
            _loc1_.x = this.Detial_OffsetX;
            this.FMainUI.addChild(_loc1_);
         }
         return _loc1_;
      }
      
      public function SetData(param1:TCompanionCard) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TCompanionScrollPropertyRender = null;
         var _loc5_:int = 0;
         _loc3_ = int(param1.LeaderProperties.length);
         if(_loc3_ > 0)
         {
            this.FTFDesc0.visible = true;
            _loc5_ = this.FTFDesc0.height + this.SpaceY;
         }
         else
         {
            this.FTFDesc0.visible = false;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.GetRenderFromPool();
            _loc4_.SetData(Vector.<TCompanionProperty>([param1.LeaderProperties[_loc2_]]));
            _loc4_.y = _loc5_;
            _loc5_ = _loc4_.y + _loc4_.height + this.SpaceY;
            this.FRenderBacks.push(_loc4_);
            _loc2_++;
         }
         this.FTFDesc1.y = _loc5_;
         _loc5_ += this.FTFDesc1.height + this.SpaceY;
         _loc3_ = int(param1.BaseProperties.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.GetRenderFromPool();
            _loc4_.SetData(Vector.<TCompanionProperty>([param1.BaseProperties[_loc2_]]));
            _loc4_.y = _loc5_;
            _loc5_ = _loc4_.y + _loc4_.height + this.SpaceY;
            this.FRenderBacks.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FRenderBacks.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FRenderPools.unshift(this.FRenderBacks[_loc1_]);
            _loc1_++;
         }
      }
      
      public function get Y() : int
      {
         return this.FMainUI.y;
      }
      
      public function set Y(param1:int) : void
      {
         this.FMainUI.y = param1;
      }
      
      public function get Height() : int
      {
         return this.FMainUI.height;
      }
      
      public function get Visible() : Boolean
      {
         return this.FMainUI.visible;
      }
      
      public function set Visible(param1:Boolean) : void
      {
         this.FMainUI.visible = param1;
      }
   }
}

