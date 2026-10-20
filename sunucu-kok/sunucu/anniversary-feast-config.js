'use strict';
const fs=require('fs'),path=require('path');
const file=()=>process.env.BLEACH_FEAST_CONFIG||path.join(__dirname,'anniversary-feast.json');
function read(){try{return JSON.parse(fs.readFileSync(file(),'utf8'));}catch(e){if(e.code!=='ENOENT')throw e;return {heroId:11150045,price:40000,revision:1};}}
function write(value,expected){const old=read();if(old.revision!==expected){const e=Error('Hot Sale đã thay đổi. Tải lại cấu hình trước khi lưu.');e.status=409;throw e;}const next={heroId:value.heroId,price:value.price,revision:old.revision+1};const tmp=file()+'.tmp';fs.writeFileSync(tmp,JSON.stringify(next,null,2));fs.renameSync(tmp,file());return next;}
module.exports={read,write};
