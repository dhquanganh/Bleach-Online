'use strict';
// Deterministic renderer fixture, not a replacement for rule-accurate combat tests.
const fs=require('fs'),codec=require('../../sunucu/kodek');
const role=(id,pos,hp,max=hp,name='Kabuto probe')=>({pos,roleId:id,quality:7,level:100,curHealth:hp,totalHealth:max,curAnger:0,skillId:({11120910:13120931,11120911:13120937,11120912:13120939,11120913:13120940,11120914:13120941,11120901:13120901})[id],name,rebirthNum:0});
const none=(camp,pos)=>({cmd:0,targetCamp:camp,targetPos:pos,reportTargetStatus:0,result:{}});
const hp=(camp,pos,damage,die=false)=>({cmd:1,targetCamp:camp,targetPos:pos,reportTargetStatus:(codec.ST.HIT|codec.ST.TARGET_EFFECT|(die?codec.ST.DIED:0))>>>0,result:{hurtHp:damage,hurtAnger:0}});
const label=(camp,pos,id,count=0)=>({cmd:9,targetCamp:camp,targetPos:pos,reportTargetStatus:codec.ST.HIT>>>0,result:{buffId:19000400+id,buffTurn:count}});
const frame=(camp,pos,skill,targets=[],type=1)=>({activeCamp:camp,activePos:pos,skillEffectId:skill,activeType:type,targets:[none(camp,pos),...targets]});
const passive=(camp,pos,records)=>({activeCamp:camp,activePos:pos,skillEffectId:0,activeType:4,targets:records});
const report={version:3,player1:{roles:[role(11120910,11,8000,10000,'Kabuto SSS Support'),role(11120911,6,0,10000,'Mu'),role(11120912,1,0,1,'Deidara'),role(11120913,2,0,1,'Dan Kato'),role(11120914,3,0,1,'Pakura')]},player2:{roles:[role(11120901,6,100000,100000,'Enemy Sage')]},turns:[
{curTurn:1,actives:[
 frame(0,11,13120936,[label(0,11,1)]),passive(0,11,[hp(0,6,-10000)]),frame(0,6,13120942,[label(0,6,2,2)]),
 frame(0,6,13120938),passive(0,6,[hp(0,3,-1)]),frame(0,3,13120941,[hp(1,6,1000),label(1,6,8,3)]),passive(0,6,[hp(0,3,1,true),label(0,3,18)]),
 frame(0,6,13120937,[hp(1,6,1000)]),frame(0,6,13120938),passive(0,6,[hp(0,1,-1)]),frame(0,1,13120939,[hp(1,6,1000),label(1,6,12)]),passive(0,6,[hp(0,1,1,true),label(0,1,18)]),
 frame(0,11,13120934),passive(0,11,[hp(0,11,-1200),label(0,11,5,40)]),frame(0,11,13120932,[hp(1,6,1000),label(1,6,11,12)]),
 frame(0,11,13120934),passive(0,11,[hp(0,11,-800)]),frame(0,11,13120933,[hp(1,6,1000),label(1,6,9,1),label(1,6,14,1)])]},
{curTurn:2,actives:[
 frame(0,6,13120938),passive(0,6,[hp(0,2,-1)]),frame(0,2,13120940,[hp(1,6,1000),label(1,6,9,3),label(0,2,16,80)]),passive(0,6,[hp(0,2,1,true),label(0,2,18)]),
 frame(0,11,13120931,[hp(1,6,2000),label(1,6,6,3),label(1,6,7,3),label(1,6,10)],2),
 frame(1,6,13120903,[hp(0,11,10000,true)])]},
{curTurn:3,actives:[
 frame(0,6,13120938),passive(0,6,[hp(0,11,-2500)]),frame(0,11,13120935,[label(0,11,4,25)]),
 frame(0,11,13120936),frame(0,6,13120942,[label(0,6,2,2)]),frame(0,11,13120932,[hp(1,6,92000,true)])]}
]};
if(process.argv.includes('--mirror')){const first=report.player1;report.player1=report.player2;report.player2=first;for(const t of report.turns)for(const f of t.actives){f.activeCamp=1-f.activeCamp;for(const r of f.targets)r.targetCamp=1-r.targetCamp;}}
const payload=codec.encodeBattleReport(report),decoded=codec.decodeBattleReport(payload);if(decoded._consumed!==decoded._total)throw Error('Invalid renderer fixture');
fs.writeFileSync(process.argv[2],payload);console.log('Kabuto native fixture:',payload.length,'bytes; 12 skills / 4 summons / revival.');
