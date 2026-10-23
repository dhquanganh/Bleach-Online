package Processors.Game.Lobby.VoidSoulWorld
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Timing.STimingCore;
   import Logics.DatebaseVO.VO.TBaseHero;
   import Logics.SLogicsCore;
   import Logics.VoidSoulWorld.TVoidSoulWorldData;
   import Logics.VoidSoulWorld.VO.TFrontPlayerVO;
   import Logics.VoidSoulWorld.VO.TFrontVO;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class TFrontController
   {
      
      public static const Direction_Up:String = "up";
      
      public static const Direction_Down:String = "down";
      
      protected var FStartPoint:Point;
      
      protected var FEndPoint:Point;
      
      protected var FEntrance:MovieClip;
      
      protected var FSpriteLayer:DisplayObjectContainer;
      
      protected var FSpriteList:Vector.<TPlayerSprite>;
      
      protected var FUVec:Point;
      
      protected var FVecLen:Number;
      
      protected var FTotalTime:uint;
      
      protected var FInterval:uint;
      
      protected var FDirection:String;
      
      protected var FData:TVoidSoulWorldData;
      
      protected var FPlay:Function;
      
      protected var FFrontVO:TFrontVO;
      
      protected var FAddPlayer:Function;
      
      protected var FRemovePlayer:Function;
      
      public function TFrontController()
      {
         super();
         this.FUVec = new Point();
         this.FData = SLogicsCore.VoidSoulWorldData;
      }
      
      protected function PlayLimit() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:TFrontPlayerVO = null;
         var _loc3_:uint = 0;
         if(this.FFrontVO.Players.length == 0)
         {
            return false;
         }
         _loc3_ = this.FFrontVO.Players.length - 1;
         _loc2_ = this.FFrontVO.Players[_loc3_];
         _loc1_ = STimingCore.ServerTickM - _loc2_.WarTime;
         return _loc1_ <= this.FInterval;
      }
      
      protected function GetPlayer(param1:TFrontPlayerVO) : TPlayerSprite
      {
         var _loc2_:TPlayerSprite = null;
         var _loc3_:String = null;
         var _loc4_:TBaseHero = null;
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,param1.TempleteID) as TBaseHero;
         _loc3_ = _loc4_.Profession + "_" + _loc4_.Sex + "_" + this.FDirection;
         _loc2_ = TPoolPlayerSprite.Get(_loc3_);
         _loc2_.SetName(param1.Name,param1.Quality);
         _loc2_.Run();
         return _loc2_;
      }
      
      protected function OnEntranceClick(param1:MouseEvent) : void
      {
         if(!this.FData.GameStart())
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_VoidSoulWorld_02));
            return;
         }
         if(!this.FData.HaveForm())
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_VoidSoulWorld_11));
            return;
         }
         this.FPlay(this);
      }
      
      public function RequestFight() : void
      {
         this.OnEntranceClick(null);
      }
      
      public function set FrontVO(param1:TFrontVO) : void
      {
         this.FFrontVO = param1;
      }
      
      public function set Play(param1:Function) : void
      {
         this.FPlay = param1;
      }
      
      public function set AddPlayer(param1:Function) : void
      {
         this.FAddPlayer = param1;
      }
      
      public function set RemovePlayer(param1:Function) : void
      {
         this.FRemovePlayer = param1;
      }
      
      public function SetCore(param1:Point, param2:Point, param3:MovieClip, param4:DisplayObjectContainer, param5:uint, param6:uint, param7:String) : void
      {
         this.FSpriteList = new Vector.<TPlayerSprite>();
         this.FDirection = param7;
         this.FStartPoint = param1;
         this.FEndPoint = param2;
         this.FEntrance = param3;
         this.FSpriteLayer = param4;
         this.FEntrance.addEventListener(MouseEvent.CLICK,this.OnEntranceClick);
         this.FEntrance.buttonMode = true;
         this.FUVec = new Point(param2.x - param1.x,param2.y - param1.y);
         this.FVecLen = Math.sqrt(this.FUVec.x * this.FUVec.x + this.FUVec.y * this.FUVec.y);
         this.FUVec.x /= this.FVecLen;
         this.FUVec.y /= this.FVecLen;
         this.FTotalTime = param5;
         this.FEntrance.play();
      }
      
      public function LogicsPerform() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TPlayerSprite = null;
         var _loc4_:TFrontPlayerVO = null;
         var _loc5_:Number = Number(NaN);
         var _loc6_:Number = Number(NaN);
         if(this.FData.GameStart())
         {
            _loc2_ = this.FSpriteList.length;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc3_ = this.FSpriteList[_loc1_];
               _loc4_ = this.FFrontVO.Players[_loc1_];
               _loc6_ = STimingCore.ServerTickM - _loc4_.WarTime;
               _loc5_ = this.FVecLen * _loc6_ / (this.FTotalTime * 1000);
               if(_loc5_ > this.FVecLen)
               {
                  _loc5_ = this.FVecLen;
                  _loc3_.Fighting();
               }
               _loc3_.x = this.FStartPoint.x + this.FUVec.x * _loc5_;
               _loc3_.y = this.FStartPoint.y + this.FUVec.y * _loc5_;
               _loc1_++;
            }
         }
      }
      
      public function UpdateAllPlayers() : void
      {
         var _loc1_:TPlayerSprite = null;
         var _loc2_:TFrontPlayerVO = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         while(this.FSpriteList.length)
         {
            _loc1_ = this.FSpriteList.pop();
            this.FSpriteLayer.removeChild(_loc1_);
            this.FRemovePlayer(_loc1_);
            TPoolPlayerSprite.Recover(_loc1_);
         }
         _loc4_ = this.FFrontVO.Players.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = this.FFrontVO.Players[_loc3_];
            _loc1_ = this.GetPlayer(_loc2_);
            this.FSpriteLayer.addChild(_loc1_);
            this.FSpriteList.push(_loc1_);
            this.FAddPlayer(_loc1_);
            _loc3_++;
         }
         this.LogicsPerform();
      }
      
      public function AddLast() : void
      {
         var _loc1_:TPlayerSprite = null;
         var _loc2_:TFrontPlayerVO = null;
         var _loc3_:uint = 0;
         _loc3_ = this.FFrontVO.Players.length - 1;
         _loc2_ = this.FFrontVO.Players[_loc3_];
         _loc1_ = this.GetPlayer(_loc2_);
         this.FSpriteLayer.addChild(_loc1_);
         this.FAddPlayer(_loc1_);
         this.FSpriteList.push(_loc1_);
         _loc1_.x = this.FStartPoint.x;
         _loc1_.y = this.FStartPoint.y;
      }
      
      public function Death(param1:uint) : void
      {
         var _loc2_:TPlayerSprite = null;
         _loc2_ = this.FSpriteList.splice(param1,1)[0];
         this.FSpriteLayer.removeChild(_loc2_);
         this.FRemovePlayer(_loc2_);
         TPoolPlayerSprite.Recover(_loc2_);
      }
   }
}

