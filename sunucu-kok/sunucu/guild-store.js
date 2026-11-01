'use strict';
const fs=require('node:fs'),path=require('node:path');
const file=()=>process.env.BLEACH_GUILD_FILE||path.resolve(__dirname,'../../.accounts/guilds.json');
function createStore(target=file()){return require('./king-challenge-store').createStore(target);}
function root(registry){return registry.seasons.guilds||={nextId:90000001,guilds:{},membership:{},migrated:{},pending:{}};}
function read(){const f=file();return fs.existsSync(f)?root(JSON.parse(fs.readFileSync(f,'utf8'))):{guilds:{},membership:{},migrated:{},pending:{}};}
function key(d){return process.env.BLEACH_ACCOUNT_ID||`${Number(d.roleIdHi)||0}:${Number(d.roleIdLo)||1}`;}
module.exports={createStore,root,read,key,file};
