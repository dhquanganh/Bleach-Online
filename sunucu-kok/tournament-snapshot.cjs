'use strict';
try{
 const d=require('./sunucu/durum').yukle(),v=require('./sunucu/seviye').veriOku();
 if(!d.karakter?.anaId)throw Error('Chưa tạo nhân vật.');
 require('./sunucu/statlar').anaIdAyarla(d.karakter.anaId);
 const K=require('./sunucu/king-challenge'),units=require('./sunucu/savas').playerTeam({playerState:d,pvp:true});
 if(!units.length||units.length>7||new Set(units.map(u=>u.pos)).size!==units.length||units.some(u=>!Number.isInteger(u.pos)||u.pos<1||u.pos>15||!Number.isFinite(u.maxHp)||u.maxHp<=0||!['atk','def','speed'].every(f=>Number.isFinite(u[f])&&u[f]>=0)))throw Error('Đội hình không hợp lệ.');
 const power=Math.max(1,Math.min(0xffffffff,Math.round(units.reduce((sum,u)=>{const p=u.pvpStats||{};return sum+(p.hp??u.maxHp)/5+(p.atk??u.atk)*2+(p.def??u.def)+(p.speed??u.speed);},0))));
 process.send({group:K.groupFor(d,v),player:{low:Number(d.roleIdLo)||1,high:Number(d.roleIdHi)||1,model:d.karakter.anaId,name:d.karakter.nick||d.nick||'Player',server:'Local Player',agent:Number(d.agent)||0,serverId:Number(d.server)||1,power,units}},()=>process.disconnect());
}catch(e){process.stderr.write(e.message);process.exitCode=1;if(process.connected)process.disconnect();}
