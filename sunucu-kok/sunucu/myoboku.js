'use strict';
const fs=require('fs'),runtime=require('./runtime-path'),config=require('./myoboku-config'),env=require('./envanter');
function atomic(file,data){const tmp=file+'.myoboku.tmp';fs.writeFileSync(tmp,JSON.stringify(data,null,2));fs.renameSync(tmp,file);}
// The debit and full resulting player state are committed together. Replay after
// interruption before any other player action, then clear the redo record.
function recover(){const file=runtime('veri.json');if(!fs.existsSync(file))return;const v=JSON.parse(fs.readFileSync(file,'utf8'));if(!v.myobokuPending)return;atomic(runtime('oyuncu.json'),v.myobokuPending);delete v.myobokuPending;atomic(file,v);}
function spin({load,save,random=require('crypto').randomInt}){
 recover();const d=load(),v=JSON.parse(fs.readFileSync(runtime('veri.json'),'utf8'));
 if((Number(v.altin)||0)<config.COST){const e=Error('Cần 1.000 vàng để quay.');e.status=400;throw e;}
 const settings=config.read(),total=settings.rewards.reduce((n,r)=>n+r.weight,0);let ticket=random(total),index=0;
 for(;index<settings.rewards.length-1;index++){if(ticket<settings.rewards[index].weight)break;ticket-=settings.rewards[index].weight;}
 const reward=settings.rewards[index],next=structuredClone(d),before=env.mevcut(next,reward.itemId);
 if(before+reward.amount>env.MAX_ADET){const e=Error('Túi đã đầy vật phẩm thưởng.');e.status=400;throw e;}
 env.ekle(next,[{type:1,code:reward.itemId,amount:reward.amount}]);
 if(env.mevcut(next,reward.itemId)!==before+reward.amount)throw Error('Không thể thêm phần thưởng vào túi.');
 v.altin-=config.COST;next.altin=v.altin;next.myoboku={spins:(next.myoboku?.spins||0)+1,last:{index,...reward,at:Date.now()}};
 v.myobokuPending=next;atomic(runtime('veri.json'),v);
 // Once the redo record is committed the spin has succeeded, including on retry.
 try{save(next);delete v.myobokuPending;atomic(runtime('veri.json'),v);}catch(e){recover();}
 return {ok:true,index,reward:config.view().rewards[index],gold:v.altin,spins:next.myoboku.spins,state:next};
}
module.exports={spin,recover};
