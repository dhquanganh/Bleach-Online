'use strict';
// Compact renderer fixture; deliberately forces three allied Mystery animations.
// Rule-accurate revival is separately covered by tests/jiraiya-combat.test.js.
const fs=require('fs'),codec=require('../../sunucu/kodek');
const role=(id,pos,hp)=>({pos,roleId:id,quality:7,level:100,curHealth:hp,totalHealth:hp,curAnger:0,skillId:id===11120903?13120911:13120901,name:id===11120903?'Jiraiya SSS':'Sage',rebirthNum:0});
const none=(camp,pos)=>({cmd:0,targetCamp:camp,targetPos:pos,reportTargetStatus:0,result:{}});
const hit=(camp,pos,hp,die=false)=>({cmd:1,targetCamp:camp,targetPos:pos,reportTargetStatus:(codec.ST.HIT|codec.ST.TARGET_EFFECT|(die?codec.ST.DIED:0))>>>0,result:{hurtHp:hp,hurtAnger:0}});
const label=(camp,pos,id,count=0)=>({cmd:9,targetCamp:camp,targetPos:pos,reportTargetStatus:codec.ST.HIT>>>0,result:{buffId:id,buffTurn:count}});
const frame=(camp,pos,skill,targets=[])=>({activeCamp:camp,activePos:pos,skillEffectId:skill,activeType:1,targets:[none(camp,pos),...targets]});
const report={version:3,player1:{roles:[role(11120903,6,100),role(11120901,11,10000)]},player2:{roles:[role(11120901,6,1000)]},turns:[
 {curTurn:1,actives:[
  frame(0,6,13120915),frame(1,6,13120903,[hit(0,6,100,true)]),
  ...[1,2,3].map(()=>({...frame(0,11,13120901,[hit(1,6,0)]),activeType:2})),
  {activeCamp:0,activePos:11,skillEffectId:0,activeType:4,targets:[hit(0,6,-30)]},
  frame(0,6,13120916,[label(0,6,19000307,30)]),
  frame(0,6,13120911,[label(0,6,19000301,2)]),
  frame(0,6,13120912,[hit(1,6,100),label(1,6,19000303)]),
  frame(0,6,13120914,[hit(1,6,100),label(1,6,19000204,16),label(0,6,19000308,1)])]},
 {curTurn:2,actives:[frame(0,6,13120915)]},
 {curTurn:3,actives:[frame(0,6,13120915,[label(0,6,19000309)]),frame(0,6,13120913,[hit(1,6,800,true)])]}
]};
if(process.argv.includes('--mirror')){
 const first=report.player1;report.player1=report.player2;report.player2=first;
 for(const turn of report.turns)for(const active of turn.actives){
  active.activeCamp=1-active.activeCamp;
  for(const target of active.targets)target.targetCamp=1-target.targetCamp;
 }
}
const payload=codec.encodeBattleReport(report),decoded=codec.decodeBattleReport(payload);
if(decoded._consumed!==decoded._total)throw Error('Invalid fixture');
fs.writeFileSync(process.argv[2],payload);
console.log('Native fixture written:',payload.length,'bytes');
