const assert=require('node:assert/strict'),fs=require('node:fs'),vm=require('node:vm'),path=require('node:path');
const source=fs.readFileSync(path.join(__dirname,'../../cikarim/nagato-frog/presentation.py'),'utf8');
function body(name){let start=source.indexOf('function '+name+'('),p=source.indexOf('{',start),depth=1,end=p+1;for(;depth;end++){if(source[end]==='{')depth++;if(source[end]==='}')depth--;}return source.slice(p+1,end-1).replace(/var (\w+):\w+/g,'var $1');}
class Point{constructor(x=0,y=0){this.x=x;this.y=y;}}
function fixture(skill=13121401){const ctx={FId:11120990,FIndex:1,TYPE_ACTIVE_ATTACK:1,TYPE_ACTIVE_SKILL:2,FTargets:[{Camp:1,localToGlobal:()=>new Point(900,50)}],FResults:[{CMD:1}],Camp:0,FSkillId:skill,FFrameIndex:0,globalToLocal:p=>p,NagatoVfxManifest:()=>({poseTiming:{[skill]:{end:68,distance:skill===13121401?300:skill===13121403?240:360}}})};const run=()=>vm.runInNewContext('(function(){with(ctx){'+body('NagatoStrikeOffset')+'}})()',{ctx,Point,TTargetInfo:{CMD_ATTACK:1}});return {ctx,run};}
for(const skill of [13121401,13121402,13121403,13121406,13121407]){const {ctx,run}=fixture(skill);assert.equal(run().x,0);ctx.FFrameIndex=10;assert.equal(run().x,skill===13121401?600:skill===13121403?660:540);assert.equal(run().y,50);ctx.FFrameIndex=40;assert.equal(run().y,50);ctx.FFrameIndex=63;assert.equal(run().y,25);ctx.FFrameIndex=68;assert.equal(run().x,0);ctx.FId=11120950;assert.equal(run().x,0);}
{const {ctx,run}=fixture();ctx.FFrameIndex=20;ctx.FResults[0].CMD=9;assert.equal(run().x,0);ctx.FResults[0].CMD=1;ctx.FTargets[0].Camp=0;assert.equal(run().x,0);}
assert(source.includes('new Point(strikeOffset.x+70,strikeOffset.y)'));
console.log('PASS Nagato approach/hold/return, source attack distances, non-hit filtering and isolated actor/effect anchor');
