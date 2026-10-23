package {
import flash.display.*;import flash.events.*;import flash.utils.*;import flash.external.ExternalInterface;
public class TApplication extends MovieClip {
 private var FIdentifier0:uint;private var FIdentifier1:uint;private var FCharacter:Object;
 private var FMainWin:Object;private var FUnstreamizer:Object;private var FOnSetBattleStatus:Function;private var FOnInitBattle:Function;private var FIsResourcesLoadCompleted:Boolean=true;
 private var CONST_BATTLE:Object={BattleType_VoidSoulWorld:7};private var CONST_MUSIC:Object={ID_SCENE_OrganizationalWar:9};private var events:Array=[];
 public function TApplication(){if(stage)run();else addEventListener(Event.ADDED_TO_STAGE,run);}
 private function report(s:String):void{ExternalInterface.call("speedProbe",s);}
 private function EffectGenerateTextByErrorCode(code:uint):void{events.push("error");}
 private function Coerce(param1:uint,param2:uint):void{
         FIdentifier0 = param1;
         FIdentifier1 = param2;
      }
 private function packet(high:uint,low:uint,code:uint=0):Object{var d:ByteArray=new ByteArray();d.writeUnsignedInt(code);d.writeUnsignedInt(high);d.writeUnsignedInt(low);d.position=0;return {Data:d};}
 private function reset():void{events=[];FMainWin={EntryPending:true,Visible:true,AddLast:function(front:uint):void{events.push("player");}};FUnstreamizer={FightEnterRet:function(d:ByteArray):uint{return 2;}};FOnSetBattleStatus=function(sender:Object,type:uint,music:uint):void{events.push("status");};FOnInitBattle=function(sender:Object):void{events.push("battle");};}
 private function check(ok:Boolean,label:String):void{report((ok?"PASS ":"ERROR ")+label);}
 private function run(e:Event=null):void{try{
 Coerce(1,1569789919);FCharacter={Identifier0:FIdentifier0,Identifier1:FIdentifier1};
 reset();baseline(packet(1,1569789919));check(events.indexOf("battle")<0 && FMainWin.Visible,"baseline reproduces own admission ignored");
 reset();fixed(packet(1,1569789919));check(events.join(",")=="player,status,battle" && !FMainWin.Visible,"fixed own admission starts native battle, status before setup");
 reset();fixed(packet(1,1569789918));check(events.indexOf("battle")<0 && FMainWin.Visible,"another player does not start local battle");
 reset();fixed(packet(1,1569789919,1));check(events.join(",")=="error" && !FMainWin.EntryPending,"rejection clears pending without starting battle");
 report("DONE");}catch(err:Error){report("ERROR "+err+" "+err.getStackTrace());report("DONE");}}
 private function baseline(param1:Object):void{
         var code:uint = param1.Data.readUnsignedInt();
         this.FMainWin.EntryPending = false;
         if(code != 0)
         {
            EffectGenerateTextByErrorCode(code);
            return;
         }
         var cursor:uint = param1.Data.position;
         var high:uint = param1.Data.readUnsignedInt();
         var low:uint = param1.Data.readUnsignedInt();
         param1.Data.position = cursor;
         var front:uint = this.FUnstreamizer.FightEnterRet(param1.Data);
         if(FIsResourcesLoadCompleted)
         {
            this.FMainWin.AddLast(front);
         }
         if(high != FCharacter.Identifier1 || low != FCharacter.Identifier0)
         {
            return;
         }
         this.FMainWin.Visible = false;
         if(this.FOnSetBattleStatus != null)
         {
            this.FOnSetBattleStatus(this,CONST_BATTLE.BattleType_VoidSoulWorld,CONST_MUSIC.ID_SCENE_OrganizationalWar);
         }
         if(this.FOnInitBattle != null)
         {
            this.FOnInitBattle(this);
         }
      }
 private function fixed(param1:Object):void{
         var code:uint = param1.Data.readUnsignedInt();
         this.FMainWin.EntryPending = false;
         if(code != 0)
         {
            EffectGenerateTextByErrorCode(code);
            return;
         }
         var cursor:uint = param1.Data.position;
         var high:uint = param1.Data.readUnsignedInt();
         var low:uint = param1.Data.readUnsignedInt();
         param1.Data.position = cursor;
         var front:uint = this.FUnstreamizer.FightEnterRet(param1.Data);
         if(FIsResourcesLoadCompleted)
         {
            this.FMainWin.AddLast(front);
         }
         if(high != FCharacter.Identifier0 || low != FCharacter.Identifier1)
         {
            return;
         }
         this.FMainWin.Visible = false;
         if(this.FOnSetBattleStatus != null)
         {
            this.FOnSetBattleStatus(this,CONST_BATTLE.BattleType_VoidSoulWorld,CONST_MUSIC.ID_SCENE_OrganizationalWar);
         }
         if(this.FOnInitBattle != null)
         {
            this.FOnInitBattle(this);
         }
      }
}}
