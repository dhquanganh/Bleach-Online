'use strict';
const fs=require('node:fs'),path=require('node:path'),zlib=require('node:zlib');
const cache=new Map();
module.exports=function icon(picture, directory='Inventory') {
  const key=directory+':'+picture;
  if(cache.has(key))return cache.get(key);
  const root=path.join(__dirname,'kaynak/login.gogames.me/public');
  const hex=(picture>>>0).toString(16).toUpperCase().padStart(8,'0');
  for(const version of ['2026090619','2017112917']) {
    const file=path.join(root,version,'Resources/Textures',directory,hex+'.TexClient');
    if(!fs.existsSync(file))continue;
    const raw=fs.readFileSync(file),surfaces=[raw];
    for(let i=0;i+1<raw.length;i++)if(raw[i]===0x78&&[0x01,0x9c,0xda].includes(raw[i+1])) {
      try {surfaces.push(zlib.inflateSync(raw.subarray(i)));}catch{}
    }
    for(const data of surfaces) {
      const start=data.indexOf(Buffer.from([0x89,0x50,0x4e,0x47]));
      const end=start<0?-1:data.indexOf(Buffer.from([0x49,0x45,0x4e,0x44,0xae,0x42,0x60,0x82]),start);
      if(end>=0){const result={type:'image/png',data:data.subarray(start,end+8)};cache.set(key,result);return result;}
      const jpg=data.indexOf(Buffer.from([0xff,0xd8,0xff])),last=jpg<0?-1:data.indexOf(Buffer.from([0xff,0xd9]),jpg+3);
      if(last>=0){const result={type:'image/jpeg',data:data.subarray(jpg,last+2)};cache.set(key,result);return result;}
    }
  }
  cache.set(key,null);return null;
};
