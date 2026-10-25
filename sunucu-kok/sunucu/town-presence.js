'use strict';
const {Y,satir}=require('./paket');
const OP={ENTER:0x01180200,ADD:0x01180300,MOVE:0x01180301,REMOVE:0x01180302};
function position(x,y){return Number.isInteger(x)&&Number.isInteger(y)&&x>=0&&y>=0&&x<=32767&&y<=32767;}
function appearance(d,v){const main=Number(d.karakter?.anaId),hero=satir('BaseHero',main);if(!hero||!d.karakter.nick)return null;const knife=Number(d.bicak?.sekil)||0;return {id0:d.roleIdHi>>>0,id1:d.roleIdLo>>>0,hero:main,name:String(d.karakter.nick).slice(0,100),rank:require('./military-rank').id(d,v),level:Math.max(1,Math.min(159,Number(v.level)||1)),quality:Number(hero.quality)||1,family:0,knife:satir('KnifeExpand',knife)?knife:0,pet:0,titles:require('./titles').equipped(d),rebirth:Math.max(0,Math.min(5,Number(d.yenidenDogus?.hero?.[main]?.n)||0))};}
function add(rows){const w=new Y().u16(rows.length);for(const r of rows){const birth=position(r.x,r.y)?(0x80000000|(r.x<<15)|r.y)>>>0:0;w.u32(r.id0).u32(r.id1).u32(r.hero).utf(r.name).u32(r.rank).u32(r.level).u32(r.family||0).i8(r.knife?1:0).u32(r.knife||0).u32(birth).i8(r.quality).u32(0).u8(0).u8(0).i32(r.pet||0).u16(r.titles.length);for(const id of r.titles)w.u32(id);w.i32(0).i8(r.rebirth||0);}return w.done();}
function remove(r){return new Y().u32(r.id0).u32(r.id1).done();}
function move(r){return new Y().u32(r.id0).u32(r.id1).u16(r.x).u16(r.y).done();}
function signature(r){const {x,y,profile,...appearance}=r;return JSON.stringify(appearance);}
function sync(previous,rows,send){const next=new Map(rows.map(r=>[r.accountId,r]));for(const [key,old]of previous)if(!next.has(key)||signature(old)!==signature(next.get(key)))send(OP.REMOVE,remove(old),'TOWN-leave');const additions=[];for(const [key,row]of next){const old=previous.get(key);if(!old||signature(old)!==signature(row))additions.push(row);else if(position(row.x,row.y)&&(row.x!==old.x||row.y!==old.y))send(OP.MOVE,move(row),'TOWN-move');}if(additions.length)send(OP.ADD,add(additions),'TOWN-online');return next;}
module.exports={OP,position,appearance,add,remove,move,sync};
