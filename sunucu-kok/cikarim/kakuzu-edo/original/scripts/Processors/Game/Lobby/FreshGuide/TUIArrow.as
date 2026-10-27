package Processors.Game.Lobby.FreshGuide
{
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.FreshGuide.TFreshStep;
   import Processors.Game.Lobby.Common.*;
   import Resources.Constants.CONST_FRESHGUIDE;
   import flash.display.*;
   import flash.text.*;
   
   public class TUIArrow extends TProcessorLobbyWindow
   {
      
      protected static const X_OFFSET:int = 194;
      
      protected static const Y_OFFSET:int = 30;
      
      protected var FTF_MessageText:TextField;
      
      protected var FTF_MessageDetail:TextField;
      
      protected var FMC_Arrow:MovieClip;
      
      protected var FFollowObj:DisplayObject;
      
      protected var FFollowCoordinate:TCoordinate;
      
      protected var FLeftArrow:MovieClip;
      
      protected var FRightArrow:MovieClip;
      
      public function TUIArrow(param1:TUIComponent)
      {
         super(param1);
         this.mouseEnabled = false;
         this.mouseChildren = false;
         this.FFollowCoordinate = new TCoordinate();
         this.visible = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_FRESHGUIDE.RESOURCESID_FreshGuide_Arrow);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:TextFormat = null;
         _loc1_ = TUtilityReflection.CreateDisplayObjectInstance("FreshGuide") as MovieClip;
         this.addChild(_loc1_);
         _loc1_.mouseChildren = false;
         _loc1_.mouseEnabled = false;
         this.FMC_Arrow = _loc1_["MC_Arrow"];
         this.FMC_Arrow.mouseChildren = false;
         this.FMC_Arrow.mouseEnabled = false;
         this.FMC_Arrow.alpha = 0.8;
         this.FTF_MessageText = this.FMC_Arrow["TF_Message"]["TF_MessageUp"];
         this.FTF_MessageText.mouseEnabled = false;
         this.FTF_MessageDetail = this.FMC_Arrow["TF_Message"]["TF_MessageDown"];
         this.FTF_MessageDetail.mouseEnabled = false;
         this.FLeftArrow = _loc1_["Arrow_Left"];
         this.FLeftArrow.mouseChildren = false;
         this.FLeftArrow.mouseEnabled = false;
         this.FRightArrow = _loc1_["Arrow_Right"];
         this.FRightArrow.mouseChildren = false;
         this.FRightArrow.mouseEnabled = false;
         this.ShowRightArrow();
         this.FMC_Arrow = _loc1_;
         super.ResourcesPerform_UILocations();
      }
      
      override public function LogicsProcess() : void
      {
         super.LogicsProcess();
         if(this.FFollowObj != null)
         {
            this.ProcessorResize();
         }
      }
      
      protected function ProcessorVisible() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:DisplayObject = null;
         _loc1_ = true;
         _loc2_ = this.FFollowObj;
         while(_loc2_.visible)
         {
            if(_loc2_.parent == null)
            {
               break;
            }
            if(!_loc2_.parent.visible)
            {
               _loc1_ = false;
               break;
            }
            _loc2_ = _loc2_.parent;
         }
         this.FMC_Arrow.visible = _loc1_;
      }
      
      override protected function ProcessorResize() : void
      {
         var _loc1_:TCoordinate = null;
         super.ProcessorResize();
         if(this.FFollowObj == null)
         {
            return;
         }
         _loc1_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(this.FFollowObj);
         this.FMC_Arrow.x = _loc1_.X + this.FFollowCoordinate.X - X_OFFSET;
         this.FMC_Arrow.y = _loc1_.Y + this.FFollowCoordinate.Y - Y_OFFSET;
      }
      
      public function SetArrowInfor(param1:DisplayObject, param2:TFreshStep, param3:DisplayObjectContainer) : void
      {
         var _loc4_:TCoordinate = null;
         this.FFollowObj = param1;
         this.FFollowCoordinate.X = param2.ArrowX;
         this.FFollowCoordinate.Y = param2.ArrowY;
         param3.addChild(this.FMC_Arrow);
         _loc4_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(this.FFollowObj);
         this.FMC_Arrow.x = _loc4_.X + this.FFollowCoordinate.X - X_OFFSET;
         this.FMC_Arrow.y = _loc4_.Y + this.FFollowCoordinate.Y - Y_OFFSET;
         this.FTF_MessageText.text = param2.GuideMessage;
         this.FTF_MessageDetail.text = param2.GuideDetial;
         visible = true;
         this.FMC_Arrow.visible = true;
      }
      
      public function Hide() : void
      {
         visible = false;
         this.FMC_Arrow.visible = false;
         this.FMC_Arrow.stop();
         this.FFollowObj = null;
      }
      
      public function ChangeOffset(param1:int, param2:int) : void
      {
         this.FFollowCoordinate.X += param1;
         this.FFollowCoordinate.Y += param2;
         this.ProcessorResize();
      }
      
      public function ShowLeftArrow() : void
      {
         this.FRightArrow.visible = false;
         this.FRightArrow.stop();
         this.FLeftArrow.visible = true;
         this.FLeftArrow.gotoAndPlay(1);
      }
      
      public function ShowRightArrow() : void
      {
         this.FLeftArrow.visible = false;
         this.FLeftArrow.stop();
         this.FRightArrow.visible = true;
         this.FRightArrow.gotoAndPlay(1);
      }
   }
}

