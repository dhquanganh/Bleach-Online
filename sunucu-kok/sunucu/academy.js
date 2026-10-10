"use strict";
const {Y,tablo,cv}=require('./paket'),env=require('./envanter'),levels=require('./seviye');
const clone=d=>JSON.parse(JSON.stringify(d)),rows=tablo('SpiritSchoolExp').byId;
function date(){const now=new Date(Date.now()+7*3600000);return now.toISOString().slice(0,10);}
function state(d,today=date()){let s=d.spiritSchool;if(!s||!rows.has(Number(s.expId)))s=d.spiritSchool={expId:18301001,exp:0,free:0,freeDate:today};s.exp=Math.max(0,Math.floor(Number(s.exp)||0));if(s.freeDate!==today){s.free=0;s.freeDate=today;}s.free=Math.min(Number(cv(60109015,3)),Math.max(0,Math.floor(Number(s.free)||0)));return s;}
function plan(s,count){let id=s.expId,exp=s.exp,trained=0;const cap=Number(cv(60109017,500));while(trained<count){const row=rows.get(id);if(!row||row.monsterLevel+1>=cap)break;exp+=100;trained++;while(true){const r=rows.get(id),next=rows.get(id+1);if(!next||next.monsterId!==r.monsterId||next.monsterLevel!==r.monsterLevel+1||exp<r.needExp)break;exp-=r.needExp;id++;if(next.monsterLevel+1>=cap){exp=0;break;}}}return {expId:id,exp,trained,gain:trained*100};}
function packet(s,error,gain=0){const w=new Y();if(error!==undefined)w.u32(error);w.u32(s.expId).u32(s.exp).u32(s.free);if(error!==undefined)w.i32(gain).i32(0).i32(0);return w.done();}
function train(ctx,y,opt={}){const next=clone(ctx.durum),s=state(next,opt.date||date()),error=n=>packet(state(clone(ctx.durum),opt.date||date()),n);
 if(ctx.payload.length!==4)return error(4);const count=ctx.payload.readUInt32BE(0);if(count<1||count>50)return error(4);
 const account=opt.account||levels.veriOku();if(levels.anaDurum(account).lv<Number(cv(60109016,72)))return error(1);if(count>1&&Number(account.vipLevel||0)<Number(cv(60109014,3)))return error(1);
 const item=Number(cv(60109009,14100322)),cost=Number(cv(60109013,10)),remaining=Math.max(0,Number(cv(60109015,3))-s.free),available=remaining+(cost?Math.floor(env.mevcut(next,item)/cost):50),p=plan(s,Math.min(count,available));
 if(!p.trained)return error(rows.get(s.expId).monsterLevel+1>=Number(cv(60109017,500))?95:18);
 const free=Math.min(p.trained,remaining),paid=(p.trained-free)*cost;if(paid&&!env.dus(next,item,paid))return error(18);
 s.expId=p.expId;s.exp=p.exp;s.free+=free;
 try{ctx.kaydet(next);}catch(e){return error(1);}Object.assign(ctx.durum,next);
 if(paid)(y.ekOnce||y.ekSonra)(0x01180f00,env.loadBagPaketi(next),'ACADEMY-bag');
 for(const id of require('./hollow-soul-map').roster(next,account)){const hero=typeof id==='object'?id.id:id;try{const lv=hero===levels.anaId()?levels.anaDurum(account).lv:levels.heroDurum(next,hero,account).lv;const stat=require('./ekipman').statPaketi(next,hero,lv);(y.ekOnce||y.ekSonra)(0x01180104,stat,'ACADEMY-stat');}catch(e){}}
 return packet(s,0,p.gain);
}
function info(ctx,opt={}){const next=clone(ctx.durum),s=state(next,opt.date||date());try{ctx.kaydet(next);}catch(e){return packet(state(clone(ctx.durum),opt.date||date()));}Object.assign(ctx.durum,next);return packet(s);}
module.exports={state,plan,packet,train,info};
