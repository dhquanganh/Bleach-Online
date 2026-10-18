'use strict';
const {Y,simdi}=require('./paket');
const env=require('./envanter'),engine=require('./battlefield-engine');
const fs=require('fs'),path=require('path');
const OP={INFO:0x0181ed00,JOIN:0x0181ed01,FIGHT:0x0181ed02,SHOP:0x0181ed03,LEAVE:0x0181ed04};
const ITEM=14100015,PRICE=30;
const OFFERS=require('./battlefield-shop.json');
const clone=d=>JSON.parse(JSON.stringify(d));
function state(d) {
  if(!d.battlefield)d.battlefield={};
  const k=d.battlefield;
  for(const key of ['points','wins','losses','visits','honorApplied','activityApplied','activity'])if(!Number.isSafeInteger(k[key])||k[key]<0)k[key]=0;
  // Existing points become honor once. Old 30/10-per-battle scoring is retired.
  k.version=2;return k;
}
function identity(d) {return String(d.agentUserId||[d.roleIdHi||0,d.roleIdLo||0].join(':'));}
function profile(d) {
  const levels=require('./seviye'),stats=require('./statlar'),equip=require('./ekipman');
  const level=levels.anaDurum(levels.veriOku()).lv,main=stats.anaKaynak();
  let power=0;
  const ids=new Set([main&&main.id,...Object.entries(d.kadro||{}).filter(([,pos])=>pos>0).map(([id])=>Number(id))]);
  for(const id of ids)if(id){const packet=equip.statPaketi(d,id,levels.heroSeviye(d,id)||level);if(packet){const s=stats.blokOku(packet.subarray(4));if(s)power+=s.guc||s.hp+s.atk*6+s.def*4;}}
  return {key:identity(d),name:d.nick||'Hải tặc',server:'s'+(d.server||'Local'),hero:main?main.id:0,level,power:Math.max(1,power)};
}
function packet(data){return new Y().utf(JSON.stringify(data)).done();}
function simulatePlayerDuel(a,b,playerState) {
  const bot=require('./cross-server-bots').get(b.botId||b.id);if(!bot)throw Error('Battlefield opponent roster missing');
  const team={...bot,name:b.name,level:a.level||40,crossAttackScale:1,crossStatScale:Math.max(0.65,Math.min(1.25,b.power/a.power))};
  const report=require('./savas').kadroRapor(0,team,null,{playerState,playerStatBoosts:{atk:(a.strategyAtk||0)+(a.team===0?1:0),def:(a.strategyDef||0)+(a.team===1?1:0)},enemyStatBoosts:{atk:(b.strategyAtk||0)+(b.team===0?1:0),def:(b.strategyDef||0)+(b.team===1?1:0)},forceWin:false,requireEnemyDefeated:true,battleDataVersion:4});
  if(!report||typeof report.won!=='boolean'||!Buffer.isBuffer(report.payload))throw Error('Battlefield duel simulation failed');
  return {won:report.won,report};
}
function create(opt={}) {
  const now=opt.now||simdi;
  const arena=opt.arena||engine.create({now,config:opt.config,bots:opt.bots});
  function info(d,message='',error=0) {
    const k=state(clone(d)),v=arena.view(identity(d),now());
    const main=require('./statlar').anaKaynak(),positions={...(d.kadro||{})};if(main&&!positions[main.id])positions[main.id]=6;
    const formation=Object.entries(positions).filter(([,pos])=>pos>0).map(([id,pos])=>({hero:Number(id),position:Number(pos),name:(require('./paket').tablo('BaseHero').byId.get(Number(id))||{}).name||'Đồng đội'}));
    return {...v,error,message,points:k.points,wins:v.career?v.career.wins:k.wins,losses:v.career?v.career.losses:k.losses,visits:k.visits,
      formation,silver:d.gumus||0,gold:d.altin||0,activity:k.activity,title:v.career?v.career.title:'',price:PRICE,item:ITEM,offers:OFFERS,token:v.me?v.me.token:'',sequence:v.me?(v.me.sequence||0):0};
  }
  function handle(op,ctx) {
    const d=ctx.durum,next=clone(d),k=state(next),p=ctx.payload||Buffer.alloc(0),key=identity(d);
    arena.tick();
    if(op===OP.INFO&&!p.length)arena.heartbeat(key);
    // Arena counters survive disconnects. Delta and watermark are saved together in the
    // player record, so retries after a failed profile save cannot duplicate rewards.
    const career=arena.view(key).career;
    let changed=false,bag=null,message='',report=null;
    const resolve=(a,b)=>{
      if(!opt.simulate)return simulatePlayerDuel(a,b,next);
      const result=opt.simulate(a,b,next);
      if(!result||typeof result.won!=='boolean'||!Buffer.isBuffer(result.payload))throw Error('Battlefield duel simulation failed');
      return {won:result.won,report:result};
    };
    if(career) {
      const honor=career.honorEarned-k.honorApplied,activity=career.activityEarned-k.activityApplied;
      if(honor<0||activity<0)throw Error('Battlefield reward ledger moved backwards');
      if(honor||activity){k.points+=honor;k.activity+=activity;k.honorApplied=career.honorEarned;k.activityApplied=career.activityEarned;changed=true;}
      if(k.wins!==career.wins||k.losses!==career.losses){k.wins=career.wins;k.losses=career.losses;changed=true;}
    }
    const fail=(message,error=4)=>{if(changed){ctx.kaydet(next);Object.assign(d,next);}return {data:info(next,message,error)};};
    try {
      if(op===OP.INFO) {if(p.length)return fail('Yêu cầu không hợp lệ.');}
      else if(op===OP.JOIN) {
        if(p.length) {
          if(p.length<2||p.readUInt16BE(0)!==p.length-2||p.length>2048)return fail('Lệnh không hợp lệ.');
          const input=JSON.parse(p.subarray(2).toString('utf8'));arena.command(key,input,resolve);
          message=input.action==='capture'?'Đang chiếm cứ điểm; đứng trong vòng và tránh bị tranh chấp.':'';
        } else {
          const before=arena.view(key).joined;
          const prof=opt.profile?opt.profile(d):profile(next);
          arena.join({...prof,key});if(!before){k.visits++;changed=true;}message='Đã đăng ký chiến trường. Cấp tối thiểu 40.';
        }
      } else if(op===OP.FIGHT) {
        if(p.length<6||p.readUInt16BE(4)+6!==p.length)return fail('Lệnh không hợp lệ.');
        const v=arena.view(key),target=p.readUInt32BE(0),token=p.subarray(6).toString('utf8');
        if(target>=0x80000000)report=arena.replay(key,target&0x7fffffff,token);
        else {const result=arena.command(key,{action:'attack',target,token,sequence:(v.me?v.me.sequence||0:0)+1},resolve);if(result.report)report=result.report;}
      } else if(op===OP.LEAVE) {
        if(p.length)return fail('Lệnh không hợp lệ.');
        const v=arena.view(key);if(v.me&&v.me.active)arena.command(key,{action:'leave',token:v.me.token,sequence:(v.me.sequence||0)+1});message='Đã rời chiến trường. Điểm và phần thưởng được lưu.';
      } else if(op===OP.SHOP) {
        if(p.length!==2&&p.length!==6)return fail('Số lượng không hợp lệ.');
        const offer=OFFERS.find(o=>o.id===(p.length===2?1:p.readUInt32BE(0)));
        if(!offer)return fail('Vật phẩm không hợp lệ.');
        if(!Number.isSafeInteger(offer.price)||offer.price<1||!Number.isSafeInteger(offer.quantity)||offer.quantity<1)throw Error('Invalid battlefield shop configuration');
        const qty=p.readUInt16BE(p.length===2?0:4),cost=qty*offer.price,amount=qty*offer.quantity,item=offer.item;
        if(qty<1||qty>100)return fail('Số lượng không hợp lệ.');
        if(k.points<cost)return fail('Không đủ Vinh Danh đổi quà.',18);
        const before=env.mevcut(next,item);
        if(before+amount>env.MAX_ADET)return fail('Túi đồ đã đầy.',1);
        env.ekle(next,[{type:1,code:item,amount}]);
        if(env.mevcut(next,item)!==before+amount)return fail('Túi đồ đã đầy.',1);
        k.points-=cost;bag=env.loadBagPaketi(next);changed=true;message='Đã đổi '+qty+' '+offer.name+': -'+cost+' Vinh Danh.';
      } else return fail('Yêu cầu không hợp lệ.');
    } catch(e) {
      if(/^(Invalid|Unsupported|Battlefield|Missing)/.test(e.message))throw e;
      return fail(e instanceof SyntaxError?'Lệnh không hợp lệ.':e.message,1);
    }
    if(changed){ctx.kaydet(next);Object.assign(d,next);}
    return {data:{...info(next,message),hasReport:!!report},bag,report};
  }
  return {handle,info,arena};
}
let singleton;
function simulateBotDuel(a,b,playerState) {
  const battle=require('./savas'),pool=require('./cross-server-bots');
  const units=(actor,camp)=>{
    const bot=pool.get(actor.botId||actor.id);if(!bot)throw Error('Battlefield bot roster missing');
    const army=bot.heroes.map((id,i)=>battle.heroBirim(id,bot.positions[i],actor.level||40,i===0?actor.name:null,null,0,true)).filter(Boolean);
    const total=army.reduce((n,u)=>n+u.maxHp+6*u.atk+4*u.def,0),factor=actor.power/Math.max(1,total);
    for(const u of army){u.camp=camp;u.maxHp=u.hp=Math.max(1,Math.round(u.maxHp*factor));u.atk=Math.max(1,Math.round(u.atk*factor*(1+((actor.strategyAtk||0)+(actor.team===0?1:0))/100)));u.def=Math.max(0,Math.round(u.def*factor*(1+((actor.strategyDef||0)+(actor.team===1?1:0))/100)));}
    return army;
  };
  const snapshot={...clone(playerState||require('./durum').yukle()),nick:a.name};
  const report=battle.kadroRapor(0,null,{ad:b.name,birimler:units(b,1)},{playerState:snapshot,playerUnits:units(a,0),scaleEnemy:false,forceWin:false,requireEnemyDefeated:true,battleDataVersion:4});
  if(!report||!Buffer.isBuffer(report.payload)||typeof report.won!=='boolean')throw Error('Battlefield bot simulation failed');
  return {won:report.won,report};
}
function service() {
  if(singleton)return singleton;
  const file=require('./runtime-path')('battlefield-runtime.json'),auditFile=require('./runtime-path')('battlefield-audit.jsonl');
  let world;if(fs.existsSync(file))world=JSON.parse(fs.readFileSync(file,'utf8'));
  const roster=require('./cross-server-bots').all().map(b=>({id:b.id,name:'Bot '+b.id+' '+b.name.replace('Bot ','').split(' #')[0].slice(0,16),hero:b.heroes[0],power:b.power}));
  const arena=engine.create({world,bots:roster,
    simulateBots:simulateBotDuel,
    simulatePlayer:(a,b)=>simulatePlayerDuel(a,b,require('./durum').yukle()),
    persist:data=>{const temp=file+'.tmp';fs.writeFileSync(temp,JSON.stringify(data));fs.renameSync(temp,file);},
    audit:entry=>{if(fs.existsSync(auditFile)&&fs.statSync(auditFile).size>8*1024*1024)fs.renameSync(auditFile,auditFile+'.1');fs.appendFileSync(auditFile,JSON.stringify(entry)+'\n');}});
  singleton=create({arena});return singleton;
}
module.exports={OP,ITEM,PRICE,state,packet,create,service,profile,identity,simulateBotDuel,simulatePlayerDuel};
