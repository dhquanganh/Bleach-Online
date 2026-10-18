'use strict';
const path = require('node:path');
module.exports = name => path.join(process.env.BLEACH_ACCOUNT_DIR || __dirname, name);
