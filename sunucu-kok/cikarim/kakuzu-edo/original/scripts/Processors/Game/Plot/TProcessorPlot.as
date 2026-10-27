package Processors.Game.Plot
{
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Quests.*;
   import Processors.Game.Lobby.Common.*;
   import Resources.Constants.*;
   import flash.display.Sprite;
   
   public class TProcessorPlot extends TProcessorLobbyPlate
   {
      
      protected static const SIZE_WIDTH_TalkWindow:int = 945;
      
      protected static const SIZE_HEIGHT_TalkWindow:int = 154;
      
      public static const PLOT_TYPE_Task:int = 1;
      
      public static const PLOT_TYPE_Nodal:int = 2;
      
      public static const PLOT_TYPE_Movie:int = 3;
      
      public static const PLOT_POS_Befor:int = 1;
      
      public static const PLOT_POS_End:int = 2;
      
      public static const PLOT_POS_FightEnd:int = 3;
      
      public static const PLOT_MODE_None:int = CONST_PLOT.PLOT_MODE_None;
      
      public static const PLOT_MODE_Movie:int = CONST_PLOT.PLOT_MODE_Movie;
      
      public static const PLOT_MODE_Talk:int = CONST_PLOT.PLOT_MODE_Talk;
      
      protected static const PLOT_INDEX_TYPE:int = 0;
      
      protected static const PLOT_INDEX_POS:int = 1;
      
      protected static const PLOT_INDEX_MODE:int = 2;
      
      protected static const PLOT_INDEX_ID:int = 3;
      
      protected static const PLOT_INDEX_NODAL_ID:int = 4;
      
      protected var FResourcesId:uint;
      
      protected var FProcessorTalkWindow:TProcessorTalkWindow;
      
      protected var FProcessorViewWindow:TProcessorViewWindow;
      
      protected var FBackSprite:Sprite;
      
      protected var FRoleModelBins:TBins;
      
      protected var FDialogueScriptBins:TBins;
      
      protected var FScriptVect:Vector.<Object>;
      
      protected var FCharacter:TCharacter;
      
      protected var FPlayedPlot:Vector.<uint>;
      
      protected var FOnEndPlot:Function;
      
      protected var FOnPlotNotify:Function;
      
      public function TProcessorPlot(param1:TUIComponent, param2:TLobbyParameters = null)
      {
         super(param1,param2);
         this.FCharacter = SLogicsCore.Character;
         this.FBackSprite = new Sprite();
         this.FBackSprite.graphics.beginFill(0);
         this.FBackSprite.graphics.drawRect(0,0,1250,650);
         this.FBackSprite.graphics.endFill();
         addChild(this.FBackSprite);
         this.FBackSprite.alpha = 0;
         this.FPlayedPlot = new Vector.<uint>();
         SLogicsCore.PlayPlotState = PLOT_MODE_None;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfPlot.LoadPrimary(CONST_PLOT.RESOURCESID_Swf_Plat);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         if(SLogicsCore.PlayPlotState == PLOT_MODE_Movie)
         {
            if(this.FProcessorViewWindow == null)
            {
               this.FProcessorViewWindow = new TProcessorViewWindow(this);
               this.FProcessorViewWindow.OnEndView = this.ProcessorOnPlotEnd;
            }
            this.FProcessorViewWindow.SetViewPlot(this.FResourcesId);
            this.FProcessorViewWindow.visible = true;
         }
         else if(SLogicsCore.PlayPlotState == PLOT_MODE_Talk)
         {
            if(this.FProcessorTalkWindow == null)
            {
               this.FProcessorTalkWindow = new TProcessorTalkWindow(this);
               this.FProcessorTalkWindow.OnEndTalk = this.ProcessorOnPlotEnd;
            }
            this.FProcessorTalkWindow.SetTalkInfo(this.FScriptVect);
            this.FProcessorTalkWindow.visible = true;
         }
         super.ResourcesPerform_UIDispatch();
      }
      
      protected function LoadPlotViewResource(param1:uint) : void
      {
         this.Visible = true;
         SResourcesCore.TexturesSwfPlot.LoadPrimary(param1);
         FResourcesState = RESOURCESSTATE_UIRequest;
      }
      
      protected function LoadPlotTalkResource(param1:uint) : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:TRoleModel = null;
         var _loc5_:TDialogueScript = null;
         this.Visible = true;
         if(this.FProcessorTalkWindow != null)
         {
            this.FProcessorTalkWindow.Visible = true;
         }
         if(this.FDialogueScriptBins == null)
         {
            this.FDialogueScriptBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_DialogueScript);
         }
         if(this.FRoleModelBins == null)
         {
            this.FRoleModelBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_RoleModel);
         }
         _loc5_ = this.FDialogueScriptBins.GetDatebaseByIdentifier(param1) as TDialogueScript;
         this.FScriptVect = Vector.<Object>(_loc5_.GetDecode());
         _loc3_ = 0;
         while(_loc3_ < this.FScriptVect.length)
         {
            _loc2_ = this.FScriptVect[_loc3_];
            if(_loc2_.leftIcon >= 0)
            {
               if(_loc2_.leftIcon == 0)
               {
                  _loc4_ = this.FRoleModelBins.GetDatebaseByIdentifier(this.FCharacter.MainHero.ModelID) as TRoleModel;
               }
               else
               {
                  _loc4_ = this.FRoleModelBins.GetDatebaseByIdentifier(_loc2_.leftIcon) as TRoleModel;
               }
               param1 = _loc4_.RoleHead;
               SResourcesCore.TexturesLargeIcon.LoadPrimary(param1);
            }
            if(_loc2_.rightIcon >= 0)
            {
               if(_loc2_.rightIcon == 0)
               {
                  _loc4_ = this.FRoleModelBins.GetDatebaseByIdentifier(this.FCharacter.MainHero.ModelID) as TRoleModel;
               }
               else
               {
                  _loc4_ = this.FRoleModelBins.GetDatebaseByIdentifier(_loc2_.rightIcon) as TRoleModel;
               }
               param1 = _loc4_.RoleHead;
               SResourcesCore.TexturesLargeIcon.LoadPrimary(param1);
            }
            _loc3_++;
         }
         FResourcesState = RESOURCESSTATE_UIRequest;
      }
      
      protected function ProcessorOnPlotEnd(param1:Object = null) : void
      {
         this.Visible = false;
         if(SLogicsCore.PlayPlotState == PLOT_MODE_Movie)
         {
            SResourcesCore.TexturesSwfPlot.DeleteByIdentifier(this.FResourcesId);
            MusicPlayNext(CONST_SIGNAL.SIGNALDESTINATION_SOUND,CONST_MUSIC.PLAY_SCENE_MainCity,23200001,false);
         }
         if(this.FOnEndPlot != null)
         {
            this.FOnEndPlot(param1);
         }
         if(this.FProcessorViewWindow != null)
         {
            this.FProcessorViewWindow.visible = false;
         }
         if(this.FProcessorTalkWindow != null)
         {
            this.FProcessorTalkWindow.visible = false;
            this.FProcessorTalkWindow.Reset();
         }
         if(SLogicsCore.PlayPlotState == PLOT_MODE_Talk)
         {
            if(this.FOnPlotNotify != null)
            {
               this.FOnPlotNotify(this,false);
            }
         }
         SLogicsCore.PlayPlotState = PLOT_MODE_None;
      }
      
      protected function SetPlot(param1:int, param2:uint) : void
      {
         if(this.FPlayedPlot.indexOf(param2) >= 0)
         {
            this.ProcessorOnPlotEnd();
            return;
         }
         this.FPlayedPlot.push(param2);
         SLogicsCore.PlayPlotState = param1;
         this.FResourcesId = param2;
         if(param1 == PLOT_MODE_Movie)
         {
            this.LoadPlotViewResource(param2);
         }
         else if(param1 == PLOT_MODE_Talk)
         {
            this.LoadPlotTalkResource(param2);
         }
         if(SLogicsCore.PlayPlotState == PLOT_MODE_Talk)
         {
            if(this.FOnPlotNotify != null)
            {
               this.FOnPlotNotify(this,true);
            }
         }
      }
      
      public function get OnEndPlot() : Function
      {
         return this.FOnEndPlot;
      }
      
      public function set OnEndPlot(param1:Function) : void
      {
         this.FOnEndPlot = param1;
      }
      
      public function get OnPlotNotify() : Function
      {
         return this.FOnPlotNotify;
      }
      
      public function set OnPlotNotify(param1:Function) : void
      {
         this.FOnPlotNotify = param1;
      }
      
      public function IsPlaying() : Boolean
      {
         return SLogicsCore.PlayPlotState != PLOT_MODE_None;
      }
      
      public function CheckPlot(param1:uint, param2:uint, param3:uint, param4:Function = null) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:TQuests = null;
         var _loc8_:TQuest = null;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         this.FOnEndPlot = param4;
         SLogicsCore.PlayPlotState = PLOT_MODE_None;
         if(param1 == PLOT_TYPE_Task && param2 == PLOT_POS_End)
         {
            _loc7_ = this.FCharacter.MainQuestComplete;
            _loc5_ = 0;
            for(; _loc5_ < _loc7_.Count; _loc5_++)
            {
               _loc8_ = _loc7_.GetQuestByIndex(_loc5_);
               if(_loc8_.Identifier == param3)
               {
                  _loc9_ = _loc8_.Plot.split(",");
                  _loc6_ = 0;
                  while(_loc6_ < _loc9_.length)
                  {
                     _loc10_ = _loc9_[_loc6_].split("_");
                     if(_loc10_.length > 2)
                     {
                        if(param1 == int(_loc10_[PLOT_INDEX_TYPE]) && param2 == int(_loc10_[PLOT_INDEX_POS]))
                        {
                           this.SetPlot(_loc10_[PLOT_INDEX_MODE],_loc10_[PLOT_INDEX_ID]);
                           return;
                        }
                     }
                     _loc6_++;
                  }
               }
            }
         }
         else
         {
            if(param1 == PLOT_TYPE_Movie)
            {
               this.SetPlot(PLOT_INDEX_MODE,param3);
               return;
            }
            _loc7_ = this.FCharacter.MainQuestsAlreadyAccept;
            _loc5_ = 0;
            while(_loc5_ < _loc7_.Count)
            {
               _loc8_ = _loc7_.GetQuestByIndex(_loc5_);
               _loc9_ = _loc8_.Plot.split(",");
               _loc6_ = 0;
               while(_loc6_ < _loc9_.length)
               {
                  _loc10_ = _loc9_[_loc6_].split("_");
                  if(_loc10_.length > 2)
                  {
                     if(param1 == int(_loc10_[PLOT_INDEX_TYPE]) && param2 == int(_loc10_[PLOT_INDEX_POS]))
                     {
                        if(param1 == PLOT_TYPE_Task)
                        {
                           this.SetPlot(_loc10_[PLOT_INDEX_MODE],_loc10_[PLOT_INDEX_ID]);
                           return;
                        }
                        if(param1 == PLOT_TYPE_Nodal)
                        {
                           if(param3 == int(_loc10_[PLOT_INDEX_NODAL_ID]))
                           {
                              this.SetPlot(_loc10_[PLOT_INDEX_MODE],_loc10_[PLOT_INDEX_ID]);
                              return;
                           }
                        }
                     }
                  }
                  _loc6_++;
               }
               _loc5_++;
            }
         }
         this.ProcessorOnPlotEnd();
      }
   }
}

