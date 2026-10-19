'use strict';
const {cv}=require('./paket');
function cutoff(now=new Date()) {
  const date=new Date(now);
  date.setHours(Number(cv(60140010,19)),Number(cv(60140011,30)),0,0);
  return {period:`${date.getFullYear()}-${String(date.getMonth()+1).padStart(2,'0')}-${String(date.getDate()).padStart(2,'0')}`,releasedAt:date.getTime()};
}
module.exports={cutoff};
