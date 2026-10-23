'use strict';
// minorType 90 also includes crafting materials and guarding stones.
const books=new Set([14100001,14100002,14100003,14100004,14100005,14100701]);
const isExpBook=article=>!!article&&books.has(typeof article.id==='string'?parseInt(article.id,16):article.id);
const maxAdd=article=>isExpBook(article)?99999:999;
module.exports={isExpBook,maxAdd};
