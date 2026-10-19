'use strict';
const {cutoff}=require('./sunucu/arena-clock');
// Freeze the rank and level once per daily release, including offline accounts.
function createSettlement(db) {
  let cached=null,loaded=false;
  return async function settlement(rows,now=new Date()) {
    const {period,releasedAt}=cutoff(now),collection=db.collection('arenaSettlements');
    if(now.getTime()>=releasedAt&&cached?._id!==period){
      const rewards=rows.filter(r=>r.ranking>=1&&r.ranking<=1000).map(r=>({accountId:r.accountId,ranking:r.ranking,level:r.level}));
      await collection.updateOne({_id:period},{$setOnInsert:{releasedAt,rewards}},{upsert:true});
      cached=await collection.findOne({_id:period});loaded=true;
    }else if(!loaded){
      cached=await collection.findOne({releasedAt:{$lte:now.getTime()}},{sort:{releasedAt:-1}});loaded=true;
    }
    return cached;
  };
}
module.exports={createSettlement};
