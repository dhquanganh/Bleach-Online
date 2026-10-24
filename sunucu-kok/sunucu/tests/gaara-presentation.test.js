const assert=require('node:assert/strict'),fs=require('node:fs'),vm=require('node:vm'),path=require('node:path');
const source=fs.readFileSync(path.join(__dirname,'../../cikarim/gaara-swimsuit/presentation.py'),'utf8');
function body(name){let start=source.indexOf('function '+name+'('),p=source.indexOf('{',start),depth=1,end=p+1;for(;depth;end++){if(source[end]==='{')depth++;if(source[end]==='}')depth--;}return source.slice(p+1,end-1).replace(/var (\w+):\w+/g,'var $1');}
class Point{constructor(x=0,y=0){this.x=x;this.y=y;}}
function fixture(skill=13121501){const ctx={FId:11120991,FIndex:1,TYPE_ACTIVE_ATTACK:1,TYPE_ACTIVE_SKILL:2,FTargets:[{Camp:1,localToGlobal:()=>new Point(900,50)}],FResults:[{CMD:1}],Camp:0,FSkillId:skill,FFrameIndex:0,globalToLocal:p=>p,GaaraVfxManifest:()=>({poseTiming:{[skill]:{end:68,distance:skill===13121501?300:skill===13121503?240:360}}})};const run=()=>vm.runInNewContext('(function(){with(ctx){'+body('GaaraStrikeOffset')+'}})()',{ctx,Point,TTargetInfo:{CMD_ATTACK:1}});return {ctx,run};}
for(const skill of [13121501,13121503,13121504]){const {ctx,run}=fixture(skill);assert.equal(run().x,0);ctx.FFrameIndex=10;assert.equal(run().x,skill===13121503?440:500);assert.equal(run().y,50);ctx.FFrameIndex=40;assert.equal(run().y,50);ctx.FFrameIndex=62;assert.equal(run().y,25);ctx.FFrameIndex=68;assert.equal(run().x,0);ctx.FId=11120950;assert.equal(run().x,0);}
{const {ctx,run}=fixture();ctx.FFrameIndex=20;ctx.FResults[0].CMD=9;assert.equal(run().x,0);ctx.FResults[0].CMD=1;ctx.FTargets[0].Camp=0;assert.equal(run().x,0);}
assert(source.includes('new Point(gaaraOffset.x+70,gaaraOffset.y)'));
{const {ctx,run}=fixture(13121502);ctx.FFrameIndex=20;assert.equal(run().x,0);assert.equal(run().y,0);}
console.log('PASS Gaara approach/hold/return, source sand surfing distances, non-hit filtering and isolated actor/effect anchor');
