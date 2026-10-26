'use strict';
const fs=require('node:fs'),path=require('node:path');
const tower=require('../../../sunucu/tower-gold'),codec=require('../../../sunucu/kodek');
const fight=tower.fight;
tower.fight=function(...args){
 const fixture=path.join(__dirname,'baseline/report.bin');
 if(fs.existsSync(fixture)){
  const payload=fs.readFileSync(fixture),report=codec.decodeBattleReport(payload);
  return {floor:68,won:false,replay:true,turns:report.turns.length,frames:[{id:codec.OP.REPORT,payload},{id:codec.OP.RESULT,payload:codec.encodeSingleResult(false,[])}]};
 }
 const result=fight.apply(this,args);
 if(result&&result.frames){fs.writeFileSync(path.join(__dirname,'report.bin'),result.frames[0].payload);fs.writeFileSync(path.join(__dirname,'report.json'),JSON.stringify(codec.decodeBattleReport(result.frames[0].payload),null,2));}
 return result;
};
