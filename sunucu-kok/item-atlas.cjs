'use strict';
const fs=require('node:fs'),path=require('node:path'),zlib=require('node:zlib');
const cache=new Map();
// TexClient's first PAK stores frame rectangles and an RGB atlas. The red
// channel below atlasHeight is the alpha plane, not a second item image.
module.exports=function itemAtlas(picture){
 if(cache.has(picture))return cache.get(picture);
 const root=path.join(__dirname,'kaynak/login.gogames.me/public'),hex=(picture>>>0).toString(16).toUpperCase().padStart(8,'0');
 for(const version of fs.readdirSync(root).sort().reverse()){
  const file=path.join(root,version,'Resources/Textures/Inventory',hex+'.TexClient');if(!fs.existsSync(file))continue;
  try{
   const raw=fs.readFileSync(file),offset=8+raw.readUInt32LE(4),count=raw.readUInt16LE(offset);if(!count)return null;
   const size=raw.readUInt32LE(offset+2),pak=zlib.inflateSync(raw.subarray(offset+6,offset+6+size));
   const frames=pak.readUInt16BE(8);if(!frames||pak.length<10+frames*8+4)return null;
   const result={x:pak.readInt16BE(10),y:pak.readInt16BE(12),width:pak.readInt16BE(14),height:pak.readInt16BE(16),atlasHeight:pak.readUInt16BE(3)};
   if(result.width<1||result.height<1||result.x<0||result.y<0||result.y+result.height>result.atlasHeight)return null;
   cache.set(picture,result);return result;
  }catch{return null;}
 }
 return null;
};
