package Utilities.UI.Windows
{
   import Foundation.Utilities.TUtilityReflection;
   import Processors.Game.Windows.Editors.TUIWindowEditor;
   import Processors.Game.Windows.Editors.TUIWindowEditorString;
   import Processors.Game.Windows.Information.TUIWindowBigInformation;
   import Processors.Game.Windows.Information.TUIWindowConfirmation;
   import Processors.Game.Windows.Information.TUIWindowInformation;
   import Processors.Game.Windows.Information.TUIWindowInputNum;
   import Processors.Game.Windows.Information.TUIWindowRecharge;
   import Processors.Game.Windows.Input.TUIWindowInputString;
   import Resources.Constants.CONST_COMMON;
   import flash.display.Sprite;
   
   public class TUtilityUIWindow
   {
      
      public function TUtilityUIWindow()
      {
         super();
      }
      
      protected static function ResourcesDispatchWindowInformation(param1:TUIWindowInformation) : void
      {
         param1.Resource = TUtilityReflection.CreateDisplayObjectInstance(CONST_COMMON.RESOURCE_ClassName_MC_Information) as Sprite;
         param1.Init();
      }
      
      protected static function ResourcesDispatchWindowBigInformation(param1:TUIWindowBigInformation) : void
      {
         param1.Resource = TUtilityReflection.CreateDisplayObjectInstance(CONST_COMMON.RESOURCE_ClassName_MC_BigInformation) as Sprite;
         param1.Init();
      }
      
      protected static function ResourcesDispatchWindowConfirmation(param1:TUIWindowConfirmation) : void
      {
         param1.Resource = TUtilityReflection.CreateDisplayObjectInstance(CONST_COMMON.RESOURCE_ClassName_MC_Confirmation) as Sprite;
         param1.Init();
      }
      
      protected static function ResourcesDispatchWindowEditor(param1:TUIWindowEditor) : void
      {
         param1.Resource = TUtilityReflection.CreateDisplayObjectInstance(CONST_COMMON.RESOURCE_ClassName_MC_Editor) as Sprite;
         param1.Init();
      }
      
      protected static function ResourcesDispatchWindowEditorString(param1:TUIWindowEditorString) : void
      {
         param1.Resource = TUtilityReflection.CreateDisplayObjectInstance(CONST_COMMON.RESOURCE_ClassName_MC_EditorString) as Sprite;
         param1.Init();
      }
      
      protected static function ResourcesDispatchWindowRecharge(param1:TUIWindowRecharge) : void
      {
         param1.Resource = TUtilityReflection.CreateDisplayObjectInstance(CONST_COMMON.RESOURCE_ClassName_MC_GotoRecharge) as Sprite;
         param1.Init();
      }
      
      protected static function ResourcesDispatchWindowInputString(param1:TUIWindowInputString) : void
      {
         param1.Resource = TUtilityReflection.CreateDisplayObjectInstance(CONST_COMMON.RESOURCE_ClassName_MC_InputString) as Sprite;
         param1.Init();
      }
      
      protected static function ResourcesDispatchWindowInputNum(param1:TUIWindowInputNum) : void
      {
         param1.Resource = TUtilityReflection.CreateDisplayObjectInstance(CONST_COMMON.RESOURCE_ClassName_MC_InputNum) as Sprite;
         param1.Init();
      }
      
      public static function SetupWindowInformation(param1:TUIWindowInformation) : void
      {
         ResourcesDispatchWindowInformation(param1);
      }
      
      public static function SetupWindowConfirmation(param1:TUIWindowConfirmation) : void
      {
         ResourcesDispatchWindowConfirmation(param1);
      }
      
      public static function SetupWindowBigInformation(param1:TUIWindowBigInformation) : void
      {
         ResourcesDispatchWindowBigInformation(param1);
      }
      
      public static function SetupWindowEditor(param1:TUIWindowEditor) : void
      {
         ResourcesDispatchWindowEditor(param1);
      }
      
      public static function SetupWindowEditorString(param1:TUIWindowEditorString) : void
      {
         ResourcesDispatchWindowEditorString(param1);
      }
      
      public static function SetupWindowRecharge(param1:TUIWindowRecharge) : void
      {
         ResourcesDispatchWindowRecharge(param1);
      }
      
      public static function SetupWindowInputString(param1:TUIWindowInputString) : void
      {
         ResourcesDispatchWindowInputString(param1);
      }
      
      public static function SetupWindowInputNum(param1:TUIWindowInputNum) : void
      {
         ResourcesDispatchWindowInputNum(param1);
      }
   }
}

