"""Incremental Ryoka patch against the current client, preserving non-code assets."""
from pathlib import Path
import subprocess,hashlib,json,struct,zlib
B=Path(__file__).resolve().parent
ROOT=B.parents[2]
JAR=ROOT/'tools/ffdec/ffdec.jar'
def ff(*args):
 subprocess.run(['java','-Xmx3g','-jar',str(JAR),*map(str,args)],check=True)
def write(rel,t):
 p=B/'patched'/rel;p.parent.mkdir(parents=True,exist_ok=True);p.write_text(t,encoding='utf8')
def replace(t,a,b):
 assert a in t,a
 return t.replace(a,b,1)
def main():
 rel=Path('Processors/Game/Lobby/TraitorAttack/TProcessorTraitorAttack.as')
 t=(B/'original/scripts'/rel).read_text(encoding='utf8')
 t=replace(t,'      protected var FMonsters:', '      protected var FightPending:Boolean = false;\n      protected var DeferredPackets:Array = [];\n      protected var EntryDeadSeconds:uint = 0;\n      protected var EndRequested:Boolean = false;\n      protected var EndDeferred:Boolean = false;\n\n      protected var FMonsters:')
 t=replace(t,'      protected var FightPending:Boolean = false;','      protected var FightReadyAt:uint = 0;\n      protected var FightPending:Boolean = false;')
 marker='      protected function PacketPerform_SC_Enter_TraitorAttack('
 helper='''      protected function DeferRyoka(handler:Function, packet:TPacket) : Boolean
      {
         if(TBattleHandle.IsInBattle || this.FightPending || !FIsResourcesLoadCompleted)
         {
            var bytes:ByteArray = new ByteArray();
            bytes.writeBytes(packet.Data,packet.Data.position,packet.Data.bytesAvailable);
            bytes.position = 0;
            this.DeferredPackets.push({handler:handler,packet:new TPacket(0,bytes)});
            return true;
         }
         return false;
      }

'''
 t=replace(t,marker,helper+marker)
 for method in ['MonsterInfo','RoundUpdate','DeathNotify']:
  needle='      protected function PacketPerform_SC_'+method+'(param1:TPacket) : void\n      {'
  t=replace(t,needle,needle+'\n         if(this.DeferRyoka(this.PacketPerform_SC_'+method+',param1)) return;')
 t=replace(t,'         super.LogicsPerform();','''         super.LogicsPerform();
         if(TBattleHandle.IsInBattle) this.FightPending = false;
         if(!TBattleHandle.IsInBattle && !this.FightPending && FIsResourcesLoadCompleted)
         {
            if(this.EndDeferred){this.EndDeferred = false;this.TraitorAttackEnd();}
            while(this.DeferredPackets.length > 0)
            {
               var deferred:Object = this.DeferredPackets.shift();
               deferred.handler(deferred.packet);
            }
         }''')
 t=replace(t,'         this.FUnstreamizerTraitorAttack.Unstreamize(param1,this.FTraitorAttackData,null);','''         this.FightPending = false;
         this.EndRequested = false;
         this.EndDeferred = false;
         this.DeferredPackets = [];
         this.FMakeMonsterSign = new Dictionary();
         this.FTraitorAttackData.MonsterList = new Dictionary();
         this.FUnstreamizerTraitorAttack.Unstreamize(param1,this.FTraitorAttackData,null);
         if(param1.bytesAvailable > 0)
         {
            this.FUnstreamizerTraitorAttack.UnstreamizeTraitorAttackMonsterInfo(param1,this.FTraitorAttackData,null);
            this.FUnstreamizerTraitorAttack.UnstreamizeTraitorAttackRankUpdate(param1,this.FTraitorAttackData.RankList,null);
            this.FUnstreamizerTraitorAttack.UnstreamizeTraitorAttackScoreUpdate(param1,this.FTraitorAttackData,null);
            this.FTraitorAttackData.EnterHeroCount = param1.readUnsignedInt();
            this.EntryDeadSeconds = param1.readUnsignedInt();
            this.FightReadyAt = param1.readUnsignedInt();
         }''')
 # Only latch IsInBattle after the shared battle handler has decoded the report.
 t=replace(t,'            TBattleHandle.IsInBattle = true;','            this.FightPending = true;')
 t=replace(t,'         if(this.FBattleBack)\n         {','         if(this.FBattleBack)\n         {\n            this.FightPending = false;')
 t=replace(t,'      public function TraitorAttackEnd() : void\n      {','      public function TraitorAttackEnd() : void\n      {\n         this.EndRequested = true;\n         if(TBattleHandle.IsInBattle || this.FightPending){this.EndDeferred = true;return;}')
 t=replace(t,'         this.FProcessorWindowResurrection.SetScene(this.FScene.mc_Resurrection,false);','         this.FProcessorWindowResurrection.SetScene(this.FScene.mc_Resurrection,true);\n         this.FProcessorWindowResurrection.OnResurrection = this.OnResurrection;')
 t=replace(t,'         this.FProcessorWindowResurrection.StartCountdown(STimingCore.ServerTick + this.FDieTime,_loc2_);','         var until:uint = param1.Data.bytesAvailable >= 4 ? param1.Data.readUnsignedInt() : STimingCore.ServerTick + this.FDieTime;\n         this.FProcessorWindowResurrection.StartCountdown(until,_loc2_);')
 a=t.index('      protected function PacketPerform_SC_BattleRet(');b=t.index('      protected function PacketPerform_SC_RankUpdate(',a)
 part=t[a:b];part=replace(part,'         _loc3_ = _loc2_.readUnsignedInt();','         _loc3_ = _loc2_.readUnsignedInt();\n         this.FightReadyAt = _loc2_.bytesAvailable >= 4 ? _loc2_.readUnsignedInt() : STimingCore.ServerTick + 3;');part=replace(part,'            EffectGenerateTextByErrorCode(_loc3_);','            this.FightPending = false;\n            EffectGenerateTextByErrorCode(_loc3_);');t=t[:a]+part+t[b:]
 needle='      protected function EnterFightReq(param1:uint) : void\n      {'
 t=replace(t,needle,needle+'\n         if(this.FightPending || TBattleHandle.IsInBattle || this.FIsDie || this.EndRequested || STimingCore.ServerTick < this.FightReadyAt) return;\n         this.FightPending = true;')
 t=replace(t,'         this.OnShowBack(this,false);','''         this.OnShowBack(this,false);
         if(this.EntryDeadSeconds > 0)
         {
            var costs:uint = this.FCostVect[Math.min(this.FTraitorAttackData.ResurrectionTimes,this.FCostVect.length - 1)];
            this.FProcessorWindowResurrection.StartCountdown(STimingCore.ServerTick + this.EntryDeadSeconds,costs);
            this.EntryDeadSeconds = 0;
         }''')
 t=replace(t,'            _loc1_ = this.FTraitorAttackData.EndTime - STimingCore.ServerTick;','''            _loc1_ = this.FTraitorAttackData.EndTime > STimingCore.ServerTick ? this.FTraitorAttackData.EndTime - STimingCore.ServerTick : 0;
            if(_loc1_ == 0 && !this.EndRequested && !TBattleHandle.IsInBattle && !this.FightPending)
            {
               this.EndRequested = true;
               this.TraitorAttackEnd();
            }''')
 write(rel,t)
 rel=Path('Processors/Game/Battle/TBattleHandle.as');t=(B/'original/scripts'/rel).read_text(encoding='utf8')
 a=t.index('      protected function PacketPerform_SC_BattleStartReportData(');b=t.index('      protected function PacketPerform_SC_SingleBattleResult(',a)
 part=t[a:b].replace('this.FEnterType == ENTER_TYPE_CITYDEFEND','(this.FEnterType == ENTER_TYPE_CITYDEFEND || this.FEnterType == ENTER_TYPE_TRAITORATTACK)');t=t[:a]+part+t[b:];write(rel,t)
 rel=Path('Processors/Game/Lobby/DailyActivity/TProcessorDailyActivity.as');t=(B/'original/scripts'/rel).read_text(encoding='utf8')
 t=replace(t,'               this.UpdateAutoFight(this.FCurType);','               this.FMC_JoinConfig.visible = false;\n               this.FTF_AutoJoining.visible = false;')
 t=t.replace('param1 == TYPE_ORGACTIVITY_MUYEGUARD ? BtnStatus_Open : param2','(param1 == TYPE_ORGACTIVITY_MUYEGUARD || param1 == TYPE_ORGACTIVITY_TRAITORATTACK) ? BtnStatus_Open : param2')
 t=replace(t,'         if(_loc2_.ActivityType == TYPE_ORGACTIVITY_MUYEGUARD) this.FCurBtnStatus = BtnStatus_Open;' if '         if(_loc2_.ActivityType == TYPE_ORGACTIVITY_MUYEGUARD) this.FCurBtnStatus = BtnStatus_Open;' in t else '            if(_loc2_.ActivityType == TYPE_ORGACTIVITY_MUYEGUARD)\n            {\n               this.FCurBtnStatus = BtnStatus_Open;\n            }', '            if(_loc2_.ActivityType == TYPE_ORGACTIVITY_MUYEGUARD || _loc2_.ActivityType == TYPE_ORGACTIVITY_TRAITORATTACK) this.FCurBtnStatus = BtnStatus_Open;')
 write(rel,t)
 ff('-onerror','abort','-importScript',B/'source.swf',B/'compiled.swf',B/'patched')
 ff('-selectclass','Processors.Game.Lobby.TraitorAttack.TProcessorTraitorAttack,Processors.Game.Battle.TBattleHandle,Processors.Game.Lobby.DailyActivity.TProcessorDailyActivity','-export','script',B/'verify',B/'compiled.swf')
 print('Compiled Ryoka client',hashlib.sha256((B/'compiled.swf').read_bytes()).hexdigest())
if __name__=='__main__':main()
