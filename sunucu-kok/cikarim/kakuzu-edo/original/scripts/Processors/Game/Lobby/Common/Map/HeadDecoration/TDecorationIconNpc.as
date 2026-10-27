package Processors.Game.Lobby.Common.Map.HeadDecoration
{
   import Foundation.Utilities.TUtilityReflection;
   import Logics.Quests.TQuest;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudleInMapNpc;
   import Resources.Constants.CONST_NPC;
   import Resources.Constants.CONST_QUEST;
   import flash.display.MovieClip;
   
   public class TDecorationIconNpc extends TDecoration
   {
      
      protected var FNpc:TSceneSpriteMoudleInMapNpc;
      
      protected var FHeadIcon:MovieClip;
      
      public function TDecorationIconNpc()
      {
         super();
      }
      
      protected function LoadResource() : void
      {
         if(this.FHeadIcon == null)
         {
            this.FHeadIcon = TUtilityReflection.CreateDisplayObjectInstance("QuestBadge") as MovieClip;
            addChild(this.FHeadIcon);
         }
      }
      
      protected function SetNpcMcStatus() : void
      {
         this.FHeadIcon.visible = true;
         switch(this.FNpc.UserType)
         {
            case CONST_NPC.NPC_FUNCTION_STONE:
               this.FHeadIcon.gotoAndStop(3);
               break;
            case CONST_NPC.NPC_FUNCTION_PUB:
               this.FHeadIcon.gotoAndStop(4);
               break;
            case CONST_NPC.NPC_FUNCTION_MADE:
               this.FHeadIcon.gotoAndStop(5);
               break;
            case CONST_NPC.NPC_FUNCTION_SUPERMARKET:
               if(this.FNpc.IfOpenUserFunction)
               {
                  this.FHeadIcon.gotoAndStop(6);
               }
               else
               {
                  this.FHeadIcon.visible = false;
               }
            default:
               this.FHeadIcon.visible = false;
         }
      }
      
      protected function GetFrameByStatus(param1:int) : String
      {
         switch(param1)
         {
            case CONST_QUEST.STATE_ACCEPT:
               return CONST_QUEST.RESOURCE_MC_Exclamation;
            case CONST_QUEST.STATE_TASKING:
               return CONST_QUEST.RESOURCE_MC_Question;
            case CONST_QUEST.STATE_TASKBACK:
               return CONST_QUEST.RESOURCE_MC_Question;
            default:
               return null;
         }
      }
      
      protected function SetNpcQuestStatus(param1:TQuest) : void
      {
         var _loc2_:String = null;
         var _loc3_:MovieClip = null;
         _loc2_ = this.GetFrameByStatus(param1.TaskState);
         if(_loc2_ == null)
         {
            return;
         }
         this.FHeadIcon.visible = true;
         this.FHeadIcon.gotoAndStop(_loc2_);
         _loc3_ = this.FHeadIcon[_loc2_];
         switch(param1.TaskState)
         {
            case CONST_QUEST.STATE_ACCEPT:
               _loc3_.gotoAndStop(1);
               break;
            case CONST_QUEST.STATE_TASKING:
               _loc3_.gotoAndStop(2);
               break;
            case CONST_QUEST.STATE_TASKBACK:
               _loc3_.gotoAndStop(1);
         }
      }
      
      protected function UpdateNpcHeadIconStatus() : void
      {
         if(this.FNpc.Questes.Count > 0)
         {
            this.SetNpcQuestStatus(this.FNpc.Questes.GetQuestByIndex(0));
         }
         else
         {
            this.SetNpcMcStatus();
         }
      }
      
      override public function get Position() : int
      {
         return POSITION_TOP;
      }
      
      override public function Update(param1:Object) : void
      {
         this.FNpc = param1 as TSceneSpriteMoudleInMapNpc;
         this.LoadResource();
         this.FHeadIcon.x = -this.width / 2;
         this.UpdateNpcHeadIconStatus();
      }
   }
}

