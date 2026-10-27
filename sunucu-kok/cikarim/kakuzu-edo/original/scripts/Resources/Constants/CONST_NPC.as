package Resources.Constants
{
   public class CONST_NPC
   {
      
      public static const TEXTUREID_HatakeKakashi:uint = 2032;
      
      public static const NPC_FUNCTION_STROY:uint = 1;
      
      public static const NPC_FUNCTION_COUNTRY:uint = 6;
      
      public static const NPC_FUNCTION_EXCHANGE_SHOP:uint = 3;
      
      public static const NPC_FUNCTION_PUB:uint = 4;
      
      public static const NPC_FUNCTION_MADE:uint = 2;
      
      public static const NPC_FUNCTION_STONE:uint = 5;
      
      public static const NPC_FUNCTION_GATE:uint = 7;
      
      public static const NPC_FUNCTION_SUPERMARKET:uint = 8;
      
      public static const NPC_FUNCTION_KINGCHALLENG:uint = 9;
      
      public static const NPC_Min_ID:uint = 22100001;
      
      public static const NPC_Max_ID:uint = 22200012;
      
      public static const NpcFunctionOpenType_AcceptQuest:int = 1;
      
      public static const NpcFunctionOpenType_CompleteQuest:int = 2;
      
      public static const NpcFunctionOpenType_Level:int = 3;
      
      public static const QUESTICON_STATE:Vector.<int> = Vector.<int>([CONST_QUEST.STATE_ACCEPT,CONST_QUEST.STATE_TASKING,CONST_QUEST.STATE_TASKBACK,CONST_QUEST.STATE_ALREADYBACK,CONST_QUEST.STATE_PREVIEW]);
      
      public static const QUESTICON_STATE_COLOR:Vector.<uint> = Vector.<uint>([65280,16762394,16762394,16762394,16711680]);
      
      public function CONST_NPC()
      {
         super();
      }
   }
}

