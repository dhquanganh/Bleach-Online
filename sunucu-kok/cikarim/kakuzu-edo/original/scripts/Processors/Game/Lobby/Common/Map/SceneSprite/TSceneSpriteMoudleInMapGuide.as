package Processors.Game.Lobby.Common.Map.SceneSprite
{
   import Resources.Constants.CONST_MAP;
   import flash.display.MovieClip;
   
   public class TSceneSpriteMoudleInMapGuide extends TSceneSpriteMoudleInMap
   {
      
      protected var FGuideComponent:MovieClip;
      
      protected var FGuideMonsterID:int;
      
      protected var FRunOver:Boolean;
      
      protected var FDisappear:Boolean;
      
      protected var FCallBack:Function;
      
      public function TSceneSpriteMoudleInMapGuide()
      {
         super();
         this.CreateGuideComponent();
         FCurrentState = CONST_MAP.STATE_WAIT;
         mouseChildren = false;
         mouseEnabled = false;
      }
      
      protected function CreateGuideComponent() : void
      {
      }
      
      override protected function HaveRoleMoudle() : Boolean
      {
         return false;
      }
      
      protected function CheckState() : void
      {
         if(this.FRunOver)
         {
            return;
         }
         if(this.FGuideComponent.currentFrameLabel == "End")
         {
            this.FGuideComponent.stop();
            this.RunComplete();
            this.FRunOver = true;
         }
      }
      
      protected function RunComplete() : void
      {
         if(this.FCallBack != null)
         {
            this.FCallBack(this);
         }
      }
      
      public function set GuideMonsterID(param1:int) : void
      {
         this.FGuideMonsterID = param1;
      }
      
      public function set CallBack(param1:Function) : void
      {
         this.FCallBack = param1;
      }
      
      public function get GuideMonsterID() : int
      {
         return this.FGuideMonsterID;
      }
      
      public function get Disappear() : Boolean
      {
         return this.FDisappear;
      }
      
      override public function UpdateData() : void
      {
         UpdateCoordinate();
         this.CheckState();
      }
      
      override public function UpdateView() : void
      {
      }
      
      public function StartShow() : void
      {
         this.FGuideComponent.gotoAndPlay(1);
         this.FRunOver = false;
      }
      
      public function ShowEnd() : void
      {
         this.FGuideComponent.gotoAndStop("End");
         this.FRunOver = true;
      }
      
      public function gotoAndLastFrame() : void
      {
         this.FGuideComponent.gotoAndStop(this.FGuideComponent.totalFrames);
      }
      
      override public function Release() : void
      {
         super.Release();
         this.FRunOver = true;
         this.FDisappear = false;
         this.FGuideComponent.visible = true;
      }
   }
}

