'use strict';
const {Y,satir,tablo,json}=require('./paket');
const clock=()=>Math.floor(Date.now()/1000);
function record(id,now,source){const row=satir('AchievementTitle',id);return row?{obtainedAt:now,expiresAt:Number(row.timeLimitNot)===1?now+Number(row.valTimeLimit):0,source}:null;}
function state(d,now=clock()){
 const u=d.unvan||={takili:[]};if(u.version!==2){u.owned||={};for(const id of u.takili||[]){const r=record(Number(id),now,'legacy');if(r&&!u.owned[id])u.owned[id]=r;}for(const a of tablo('Achievement').liste)if(d.basari?.[a._id]&&a.f8){const r=record(Number(a.f8),now,'achievement');if(r&&!u.owned[a.f8])u.owned[a.f8]=r;}u.version=2;}u.owned||={};u.takili||=[];return u;
}
function active(d,id,now=clock()){const r=state(d,now).owned[id];return !!satir('AchievementTitle',id)&&!!r&&(!r.expiresAt||r.expiresAt>now);}
function equipped(d,now=clock()){const u=state(d,now),groups=new Set();return u.takili.map(Number).filter(id=>{const row=satir('AchievementTitle',id);if(!row||!active(d,id,now)||groups.has(row.titleTypeGroup))return false;groups.add(row.titleTypeGroup);return true;});}
function prune(d,now=clock()){const u=state(d,now),next=equipped(d,now),changed=JSON.stringify(u.takili)!==JSON.stringify(next);u.takili=next;return changed;}
function grant(d,id,source='item',now=clock()){
 const row=satir('AchievementTitle',id);if(!row)return false;const u=state(d,now),old=u.owned[id];if(old&&!old.expiresAt)return false;
 const r=record(id,now,source);if(r.expiresAt)r.expiresAt=Math.min(0xffffffff,Math.max(old?.expiresAt||0,now)+Number(row.valTimeLimit));u.owned[id]=r;
 u.takili=equipped(d,now).filter(other=>satir('AchievementTitle',other).titleTypeGroup!==row.titleTypeGroup);u.takili.push(id);return true;
}
function list(w,d,now=clock()){const ids=equipped(d,now);w.u16(ids.length);for(const id of ids)w.u32(id);return w;}
function info(d,now=clock()){const u=state(d,now),rows=Object.entries(u.owned).filter(([id])=>satir('AchievementTitle',Number(id)));const w=list(new Y(),d,now).u16(rows.length);for(const [id,r]of rows)w.u32(Number(id)).i8(r.expiresAt&&r.expiresAt<=now?1:0).u32(r.expiresAt||0);return w.done();}
function change(d,error=0,now=clock()){return list(new Y().u32(error),d,now).done();}
function bonuses(d,heroId,now=clock()){const pos=Number(d.kadro?.[heroId])||0,out=[];for(const id of equipped(d,now)){const row=satir('AchievementTitle',id),scope=Number(row.formationType);if(row.notOrProp!==1||scope===2&&!(pos>=1&&pos<=5)||scope===3&&!(pos>=6&&pos<=10)||scope===4&&!(pos>=11&&pos<=15))continue;for(const a of json(row.f7,[]))if(Number.isFinite(Number(a.value)))out.push([Number(a.type),Number(a.value)]);}return out;}
function stats(d,push){const ids=new Set([require('./seviye').anaId(),...Object.keys(d.kadro||{}).map(Number),...Object.keys(d.seviye?.herolar||{}).map(Number)]);for(const id of ids){const p=require('./ekipman').statPaketi(d,id,require('./seviye').heroSeviye(d,id));if(p)push(0x01180104,p,'TITLE-stats');}}
function handlers(push){return {
 '0x01815203':({durum:d,kaydet:save,payload})=>{if(payload?.length)return info(d);const before=JSON.stringify(d.unvan);const changed=prune(d);if(before!==JSON.stringify(d.unvan)){try{save(d);}catch(error){console.error('[Title state save]',error.name);}}if(changed){push(0x01185204,change(d),'TITLE-expired');stats(d,push);}return info(d);},
 '0x01815204':ctx=>operate(ctx,false,push),
 '0x01815205':ctx=>({id:0x01185204,payload:operate(ctx,true,push)})
};}
function operate({payload,durum:d,kaydet:save},remove,push){if(payload?.length!==4)return change(d,4);const id=payload.readUInt32BE(),next=structuredClone(d);prune(next);const u=state(next),row=satir('AchievementTitle',id);if(!row||!active(next,id)||remove&&!u.takili.includes(id))return change(d,4);u.takili=u.takili.filter(other=>remove?other!==id:satir('AchievementTitle',other).titleTypeGroup!==row.titleTypeGroup);if(!remove)u.takili.push(id);try{save(next);}catch(e){return change(d,1);}Object.assign(d,next);stats(d,push);return change(d);}
module.exports={state,active,equipped,prune,grant,info,change,bonuses,stats,handlers};
