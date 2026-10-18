'use strict';
const crypto = require('node:crypto');
function equal(a, b) { if (typeof a !== 'string' || typeof b !== 'string') return false; const left = Buffer.from(a), right = Buffer.from(b); return left.length === right.length && crypto.timingSafeEqual(left, right); }
function guard(req, res, admin = false) {
  if (!process.env.BLEACH_ACCOUNT_DIR) {
    res.writeHead(503, { 'Content-Type': 'text/plain; charset=utf-8' });
    res.end('Khởi động game qua OYUNU-BASLAT.bat và đăng nhập trước.'); return false;
  }
  if (req.method === 'OPTIONS' && [process.env.BLEACH_WEB_ORIGIN, `http://127.0.0.1:${process.env.BLEACH_ADMIN_PORT}`].includes(req.headers.origin)) return true;
  const internal = equal(req.headers['x-bleach-internal'], process.env.BLEACH_INTERNAL_SECRET);
  const cookie = (req.headers.cookie || '').split(';').map(s => s.trim()).find(s => s.startsWith('bleach_session='));
  if (!internal && (!cookie || !equal(cookie.slice(15), process.env.BLEACH_SESSION_TOKEN))) {
    res.writeHead(401); res.end('Unauthorized'); return false;
  }
  if (!internal && req.headers.origin && req.headers.origin !== process.env.BLEACH_WEB_ORIGIN && req.headers.origin !== `http://127.0.0.1:${process.env.BLEACH_ADMIN_PORT}`) {
    res.writeHead(403); res.end('Forbidden origin'); return false;
  }
  if (admin && !internal && process.env.BLEACH_ACCOUNT_ROLE !== 'admin') {
    res.writeHead(403); res.end('Admin required'); return false;
  }
  return true;
}
module.exports = { guard, equal };
