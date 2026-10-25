'use strict';
// Kept in the same account file as the gold debit. Refunds and top-ups do not earn pieces.
function earn(v,gold){if(!Number.isSafeInteger(gold)||gold<=0)return;const s=v.ultimateBP||={pieces:0,remainder:0,spent:0};const n=(s.remainder||0)+gold;s.pieces=Math.min(1000000000,(s.pieces||0)+Math.floor(n/10));s.remainder=n%10;s.spent=(s.spent||0)+gold;}
function refund(v,gold){const s=v.ultimateBP;if(!s||!Number.isSafeInteger(gold)||gold<=0)return;const total=Math.max(0,(s.pieces||0)*10+(s.remainder||0)-gold);s.pieces=Math.floor(total/10);s.remainder=total%10;s.spent=Math.max(0,(s.spent||0)-gold);}
module.exports={earn,refund};
