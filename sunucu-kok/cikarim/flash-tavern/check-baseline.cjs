const Module = require('module'), path = require('path'), cp = require('child_process');
const root = process.cwd();
const baseline = new Set(['meyhane.js','seviye.js','statlar.js','ekipman.js','handlers.js','oyun-sunucu.js','savas-etkinlik.js','sosyal.js'].map(f => path.join(root,'sunucu-kok','sunucu',f).toLowerCase()));
const original = Module._extensions['.js'];
Module._extensions['.js'] = function(module, filename) {
 if (!baseline.has(filename.toLowerCase())) return original(module, filename);
 const relative = path.relative(root, filename).split(path.sep).join('/');
 const result = cp.spawnSync('git', ['show', ':' + relative], {encoding:'utf8', maxBuffer:8*1024*1024});
 if (result.status !== 0) throw Error(result.stderr);
 module._compile(result.stdout, filename);
};
require(path.resolve(process.argv[2]));
