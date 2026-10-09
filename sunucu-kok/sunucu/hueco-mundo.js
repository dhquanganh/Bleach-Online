'use strict';
// Hueco Mundo Attack uses a one-byte VainTravel point index, not an Enter_Hurdle stage ID.
const { Y, cv, gunluk, satir, simdi, tablo, json } = require('./paket');
const envanter = require('./envanter');
const arena = require('./arena-bot');
const seviye = require('./seviye');
const COUNT = 15, COIN = 14140507;
const ALIVE = 1, BOX = 2, CLEARED = 3;
const OP = { INIT: 0x01187600, BATTLE: 0x01187601, RESET: 0x01187602, CLAIM: 0x01187603, REPORT: 0x01187604 };
const error = code => new Y().u32(code).done();
function vipConfig(d) {
  return tablo('VipConfig').liste.filter(v => v._id <= (Number(d.vipLevel) || 0)).sort((a,b) => b._id-a._id)[0] || {};
}
function shopState(d) {
  const s=state(d);
  s.shop=s.shop || { refresh:0, born:simdi(), bought:{} };
  if(!Array.isArray(s.shop.ids)) {
    const rows=tablo('BlackMarket').liste.filter(row => {
      const price=json(row.price,null);
      return Number(row.model)===2 && envanter.article(row.itemID) && price && envanter.odulTemplate(price.type,price.code)===COIN;
    });
    for (let i=rows.length-1; i>0; i--) {
      const j=Math.floor(Math.random()*(i+1));
      [rows[i],rows[j]]=[rows[j],rows[i]];
    }
    s.shop.ids=rows.slice(0,10).map(row=>row._id);
  }
  return s.shop;
}
function shopPacket(d) {
  const shop=shopState(d),w=new Y().u32(0).u32(2).i32(shop.refresh).i32(shop.born).i32(envanter.mevcut(d,COIN)).u16(shop.ids.length);
  for(const id of shop.ids)w.u32(id).i32(Number(shop.bought[String(id)])||0);
  return w.done();
}
function playerIds(d) { return arena.playerHeroes(d, seviye.anaId()); }
function state(d) {
  const g = gunluk(d);
  const s = g.seyahat = g.seyahat || {};
  for (const key of ['reset','resetBuy','relive','reliveBuy']) s[key] = Math.max(0, Number(s[key]) || 0);
  s.alinan = s.alinan || {};
  s.hp = s.hp || {};
  s.reports = Array.isArray(s.reports) ? s.reports : [];
  if (!Array.isArray(s.points) || s.points.length !== COUNT) {
    const level = seviye.anaDurum().lv;
    const bots = arena.build(level, playerIds(d));
    s.points = Array.from({length:COUNT}, (_,index) => {
      const bot = bots[index % bots.length];
      return { index, status: s.alinan[String(index)] ? CLEARED : ALIVE,
        opponent: { ...bot, heroes: bot.heroes.slice(), positions: bot.positions.slice(),
          name: `Hueco Mundo ${index + 1}`, power: 0.45 + index * 0.04 }, hp: {} };
    });
  }
  return s;
}
function initPacket(d) {
  const s = state(d), w = new Y().u32(0).i32(s.reset).i32(s.resetBuy).i32(s.relive).i32(s.reliveBuy).u16(COUNT);
  for (const point of s.points) {
    const bot = point.opponent;
    w.u8(point.index).u32(bot.id0).u32(bot.id1).i32(point.status).i32(0).i32(d.server || 974)
      .utf('Local').utf(bot.name).i32(bot.level).i32(0).i32(0).i32(Math.round(10000 * bot.power)).u16(bot.heroes.length);
    bot.heroes.forEach((id, i) => w.i32(i + 1).i32(id).i32(bot.level).u8(bot.positions[i])
      .u8(point.hp[String(id)] === undefined ? 100 : point.hp[String(id)]).i32(0).i32(0).i32(0));
  }
  const ids = Array.from(new Set([...playerIds(d), ...Object.keys(s.hp).map(Number)]));
  w.u16(ids.length);
  for (const id of ids) w.u32(id).u8(s.hp[String(id)] === undefined ? 100 : s.hp[String(id)]);
  w.u16(s.reports.length);
  for (const report of s.reports) w.i32(report.time).u8(0).u8(report.won ? 1 : 0).utf(d.nick || '').utf(report.name).utf('');
  return w.done();
}
function pointIndex(payload) { return Buffer.isBuffer(payload) && payload.length === 1 && payload[0] < COUNT ? payload[0] : -1; }
function canFight(d, payload) {
  const index = pointIndex(payload);
  if (index < 0) return false;
  const s = state(d);
  return s.points[index].status === ALIVE && s.points.slice(0,index).every(p => p.status === CLEARED) &&
    playerIds(d).some(id => s.hp[String(id)] === undefined || s.hp[String(id)] > 0);
}
function reward(index) {
  // Preserve the local mode's configured grant: ten Hueco Mundo Coins per cleared point.
  return [{type:24, code:28, amount:10}];
}
function claim(d, payload) {
  const index = pointIndex(payload);
  if (index < 0) return { ret:error(4), rewards:[] };
  const s = state(d), point = s.points[index];
  if (point.status !== BOX || s.alinan[String(index)]) return { ret:error(1), rewards:[] };
  point.status = CLEARED;
  s.alinan[String(index)] = 1;
  return { ret:new Y().u32(0).u8(index).odul(reward(index)).done(), rewards:reward(index) };
}
function battle(d, payload, simulate) {
  if (!canFight(d,payload)) return { ret:error(1), rewards:[] };
  const index = payload[0], s = state(d), point = s.points[index];
  const result = simulate(point.opponent, { playerState:d, playerHpRates:s.hp, enemyHpRates:point.hp,
    forceWin:false, requireEnemyDefeated:true });
  if (!result || !Buffer.isBuffer(result.payload) || !Array.isArray(result.remainingHp)) throw new Error('Hueco Mundo battle report unavailable');
  for (const unit of result.remainingHp) {
    const percent = Math.max(0, Math.min(100, Math.ceil(unit.rate * 100)));
    (unit.camp === 0 ? s.hp : point.hp)[String(unit.id)] = percent;
  }
  if (result.won) point.status = BOX;
  else if (s.relive < Math.max(0, Number(cv(60600008,5)) || 0) + s.reliveBuy) {
    s.relive++;
    for (const id of Object.keys(s.hp)) s.hp[id] = 100;
  }
  s.reports.push({ time:simdi(), won:!!result.won, name:point.opponent.name });
  s.reports = s.reports.slice(-30);
  const w = new Y().u32(0).u8(result.won ? 1 : 0).u8(index).u16(result.remainingHp.length);
  for (const unit of result.remainingHp) w.u8(unit.camp).u32(unit.id).u8((unit.camp === 0 ? s.hp : point.hp)[String(unit.id)]);
  const award = result.won ? claim(d,payload) : {rewards:[]};
  return { ret:w.done(), report:result.payload, won:!!result.won, rewards:award.rewards, claimRet:award.ret, index };
}
function kur(y) {
  const H = {}, save = (kaydet,d) => kaydet(d);
  H['0x01817600'] = ({durum,kaydet}) => { const p=initPacket(durum); save(kaydet,durum); return p; };
  H['0x01817603'] = ({durum,payload,kaydet}) => {
    const r=claim(durum,payload);
    if (r.rewards.length) { y.odulVer(durum,r.rewards); save(kaydet,durum); }
    return r.ret;
  };
  H['0x01817602'] = ({durum,kaydet}) => {
    const s=state(durum), vip=vipConfig(durum);
    const free=Math.max(0,Number(cv(60600001,1))||0)+(Number(vip.vainTravelFree)||0);
    const maximum=free+(Number(vip.vainTravelBuy)||0);
    if(s.reset>=maximum)return error(1);
    if(s.reset>=free){
      const costs=cv(60600002,[0]);
      const cost=Number(costs[Math.min(s.resetBuy,costs.length-1)])||0;
      if(cost>0){ const p=y.paraHarca([{type:0,code:1,amount:cost}]); if(!p)return error(16); y.ekSonra(0x01180105,p,'HUECO-reset-cost'); }
      s.resetBuy++;
    }
    s.reset++; s.alinan={}; s.hp={}; s.reports=[];
    for(const p of s.points){p.status=ALIVE;p.hp={};}
    save(kaydet,durum);y.ekSonra(OP.INIT,initPacket(durum),'HUECO-reset');return error(0);
  };
  H['0x01817608'] = ({durum,kaydet}) => {
    const s=state(durum),vip=vipConfig(durum);
    if(s.reliveBuy>=(Number(vip.vainTravelReliveTime)||0))return error(1);
    const costs=cv(60600011,[10]),cost=Number(costs[Math.min(s.reliveBuy,costs.length-1)])||0;
    if(cost>0){const p=y.paraHarca([{type:0,code:1,amount:cost}]);if(!p)return error(16);y.ekSonra(0x01180105,p,'HUECO-revive-cost');}
    s.reliveBuy++;save(kaydet,durum);return error(0);
  };
  const blackMarketHandlers = require('./black-market').kur(y);
  const mysticHandlers = require('./mystic-shop').kur(y);
  // TimeMall type 2 is Hueco Mundo; keep other market handlers unchanged.
  const type = payload => Buffer.isBuffer(payload) && payload.length >= 4 ? payload.readUInt32BE(0) : -1;
  H['0x01817a00'] = ctx => {
    if(type(ctx.payload)===0)return blackMarketHandlers['0x01817a00'](ctx);
    if(type(ctx.payload)===1)return mysticHandlers['0x01817a00'](ctx);
    if(type(ctx.payload)!==2)return require('./lonca').timeMall(ctx.durum,ctx.payload);
    const p=shopPacket(ctx.durum);ctx.kaydet(ctx.durum);return p;
  };
  H['0x01817a01'] = ctx => {
    if(type(ctx.payload)===0)return blackMarketHandlers['0x01817a01'](ctx);
    if(type(ctx.payload)===1)return mysticHandlers['0x01817a01'](ctx);
    if(type(ctx.payload)!==2)return require('./lonca').timeMall(ctx.durum,ctx.payload);
    const shop=shopState(ctx.durum),costs=cv(60600006,[]);
    if(shop.refresh>=costs.length)return new Y().u32(1).u32(2).done();
    const cost=costs[shop.refresh],amount=Number(cost.amount)||0;
    if(envanter.odulTemplate(cost.type,cost.code)!==COIN || !envanter.dus(ctx.durum,COIN,amount))return new Y().u32(21).u32(2).done();
    const update=envanter.guncellemePaketi(ctx.durum,COIN);
    y.ekSonra(update.id,update.payload,'HUECO-shop-cost');
    shop.refresh++;shop.born=simdi();shop.bought={};delete shop.ids;
    const p=shopPacket(ctx.durum);ctx.kaydet(ctx.durum);return p;
  };
  H['0x01817a02'] = ctx => {
    if(type(ctx.payload)===0)return blackMarketHandlers['0x01817a02'](ctx);
    if(type(ctx.payload)===1)return mysticHandlers['0x01817a02'](ctx);
    if(type(ctx.payload)!==2)return require('./lonca').timeMallSatin(ctx.payload);
    if(ctx.payload.length!==8)return new Y().u32(4).u32(2).done();
    const id=ctx.payload.readUInt32BE(4),shop=shopState(ctx.durum),row=satir('BlackMarket',id);
    if(!shop.ids.includes(id)||!row||(Number(shop.bought[String(id)])||0)>=(Number(row.totalTimes)||1))return new Y().u32(1).u32(2).done();
    const preview=JSON.parse(JSON.stringify(ctx.durum));
    const owned=envanter.mevcut(preview,Number(row.itemID)),quantity=Number(row.number)||1;
    envanter.ekle(preview,[{type:1,code:Number(row.itemID),amount:quantity}]);
    if(envanter.mevcut(preview,Number(row.itemID))!==owned+quantity)return new Y().u32(1).u32(2).done();
    const price=json(row.price,{}),amount=Number(price.amount)||0;
    if(amount<=0||envanter.odulTemplate(price.type,price.code)!==COIN||!envanter.dus(ctx.durum,COIN,amount))return new Y().u32(21).u32(2).done();
    const update=envanter.guncellemePaketi(ctx.durum,COIN);
    y.ekSonra(update.id,update.payload,'HUECO-exchange-cost');
    y.odulVer(ctx.durum,[{type:1,code:Number(row.itemID),amount:Number(row.number)||1}]);
    shop.bought[String(id)]=(Number(shop.bought[String(id)])||0)+1;
    ctx.kaydet(ctx.durum);
    return new Y().u32(0).u32(2).u32(id).u32(envanter.mevcut(ctx.durum,COIN)).done();
  };
  return H;
}
module.exports={COUNT,COIN,OP,state,initPacket,pointIndex,canFight,claim,battle,shopPacket,kur};
