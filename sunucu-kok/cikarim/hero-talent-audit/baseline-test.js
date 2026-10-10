'use strict';
// Run a regression against the original implementation without checking out files
// or modifying a player's save. Useful when legacy tests depend on live state.
const path=require('path'),Module=require('module'),{execFileSync}=require('child_process');
const root=path.resolve(__dirname,'../../..');
for(const name of ['seviye','statlar','ekipman','meyhane','savas']) {
 const relative=`sunucu-kok/sunucu/${name}.js`,file=path.join(root,relative);
 const source=execFileSync('git',['show',`HEAD:${relative}`],{cwd:root,encoding:'utf8'});
 const m=new Module(file,module);m.filename=file;m.paths=Module._nodeModulePaths(path.dirname(file));require.cache[file]=m;m._compile(source,file);m.loaded=true;
}
require(path.join(root,'sunucu-kok/sunucu/tests',process.argv[2]));
