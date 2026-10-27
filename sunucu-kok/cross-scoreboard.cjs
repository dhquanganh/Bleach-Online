'use strict';
// One Mongo document commits both sides together, independently of account file saves.
const cfg=require('./sunucu/cross-server-config.json');
const seasonAt=seconds=>Math.floor(Math.floor((seconds+25200)/86400)/cfg.seasonDays);
function transfer(attacker,defender,won){return won&&attacker<=defender?cfg.transferScore:0;}
function createBoard(db,{runtimes=new Map(),snapshot,now=()=>Math.floor(Date.now()/1000),onUpdate=()=>{}}={}){
  const collection=db.collection('cross_scoreboards');let queue=Promise.resolve();
  function serial(action){const next=queue.catch(()=>{}).then(action);queue=next;return next;}
  async function load(){
    const season=seasonAt(now());let board=await collection.findOne({_id:season});
    if(!board){
      board={_id:season,revision:0,scores:{},receipts:{}};
      try{await collection.insertOne(board);}catch(error){if(error.code!==11000)throw error;board=await collection.findOne({_id:season});}
    }
    const accounts=await db.collection('accounts').find({}, {projection:{_id:1}}).toArray();
    const members=new Set(accounts.map(a=>a._id.toHexString()));
    const players=await db.collection('players').find({}, {projection:{files:1}}).toArray();
    const next=structuredClone(board);let changed=false;
    for(const player of players){
      const id=player._id.toHexString();if(!members.has(id)||Object.hasOwn(next.scores,id))continue;
      const rt=runtimes.get(id),files=rt&&snapshot?snapshot(rt.dir):player.files;
      const saved=JSON.parse(files?.['oyuncu.json']||'{}').crossServer;
      next.scores[id]=saved?.season===season?Math.max(0,Math.floor(Number(saved.score)||0)):0;changed=true;
    }
    if(changed){next.revision++;await write(board,next);board=next;onUpdate(view(board));}
    return {board,members};
  }
  async function write(before,after){
    const result=await collection.updateOne({_id:before._id,revision:before.revision},{$set:{scores:after.scores,receipts:after.receipts,revision:after.revision}});
    if(result.matchedCount!==1)throw Error('Cross scores changed concurrently; retry settlement');
  }
  function view(board){return {season:board._id,revision:board.revision,scores:board.scores};}
  return {
    snapshot:()=>serial(async()=>view((await load()).board)),
    settle:(accountId,message)=>serial(async()=>{
      if(!message||typeof message.id!=='string'||!/^[a-f0-9-]{36}$/i.test(message.id)||typeof message.won!=='boolean')throw Error('Invalid Cross result');
      const {board,members}=await load();
      if(message.season!==board._id)throw Error('Cross season ended');
      if(accountId===message.opponentId||!members.has(accountId)||!members.has(message.opponentId)||!Object.hasOwn(board.scores,accountId)||!Object.hasOwn(board.scores,message.opponentId))throw Error('Cross account unavailable');
      const key=accountId+':'+message.id;
      if(board.receipts[key])return {...view(board),...board.receipts[key],duplicate:true};
      const amount=transfer(board.scores[accountId],board.scores[message.opponentId],message.won);
      const next=structuredClone(board);next.scores[accountId]+=amount;next.scores[message.opponentId]=Math.max(0,next.scores[message.opponentId]-amount);
      const receipt={amount,opponentId:message.opponentId,won:message.won};next.receipts[key]=receipt;next.revision++;
      await write(board,next);const result={...view(next),...receipt};onUpdate(view(next));return result;
    })
  };
}
module.exports={createBoard,seasonAt,transfer};
