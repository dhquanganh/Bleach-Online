'use strict';
const fs=require('fs'),path=require('path'),{spawnSync}=require('child_process');
const tests=path.resolve(__dirname,'../../sunucu/tests');
const report={passed:[],preExistingFailures:[],regressions:[]};
const fingerprint=text=>({error:(text.match(/(?:AssertionError|TypeError)[^\r\n]*/)||[])[0],location:(text.match(/tests[\\/][\w.-]+\.test\.js:\d+:\d+/)||[])[0]});
for(const file of fs.readdirSync(tests).filter(f=>f.endsWith('.test.js')).sort()){
 const run=spawnSync(process.execPath,[path.join(tests,file)],{encoding:'utf8',timeout:60000});
 if(run.status===0){report.passed.push(file);console.log('PASS '+file);continue;}
 const current=fingerprint((run.stdout||'')+(run.stderr||''));
 const old=spawnSync(process.execPath,[path.join(__dirname,'baseline-test.js'),file],{encoding:'utf8',timeout:60000});
 const baseline=fingerprint((old.stdout||'')+(old.stderr||''));
 if(old.status!==0&&current.error&&current.error===baseline.error&&current.location===baseline.location){report.preExistingFailures.push({file,...current});console.log('BASELINE FAILURE '+file);}
 else {report.regressions.push({file,current,baseline,output:(run.stdout||'')+(run.stderr||'')});console.log('REGRESSION '+file);}
}
fs.writeFileSync(path.join(__dirname,'test-results.json'),JSON.stringify(report,null,2)+'\n');
console.log(JSON.stringify({passed:report.passed.length,preExistingFailures:report.preExistingFailures.length,regressions:report.regressions.length}));
if(report.regressions.length)process.exitCode=1;
