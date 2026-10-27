package Foundation.Crypto
{
   import Foundation.Crypto.Utils.*;
   
   public class TAES
   {
      
      public static const BIT_KEY_128:int = 128;
      
      public static const BIT_KEY_192:int = 192;
      
      public static const BIT_KEY_256:int = 256;
      
      private static const SBOX:Array = [99,124,119,123,242,107,111,197,48,1,103,43,254,215,171,118,202,130,201,125,250,89,71,240,173,212,162,175,156,164,114,192,183,253,147,38,54,63,247,204,52,165,229,241,113,216,49,21,4,199,35,195,24,150,5,154,7,18,128,226,235,39,178,117,9,131,44,26,27,110,90,160,82,59,214,179,41,227,47,132,83,209,0,237,32,252,177,91,106,203,190,57,74,76,88,207,208,239,170,251,67,77,51,133,69,249,2,127,80,60,159,168,81,163,64,143,146,157,56,245,188,182,218,33,16,255,243,210,205,12,19,236,95,151,68,23,196,167,126,61,100,93,25,115,96,129,79,220,34,42,144,136,70,238,184,20,222,94,11,219,224,50,58,10,73,6,36,92,194,211,172,98,145,149,228,121,231,200,55,109,141,213,78,169,108,86,244,234,101,122,174,8,186,120,37,46,28,166,180,198,232,221,116,31,75,189,139,138,112,62,181,102,72,3,246,14,97,53,87,185,134,193,29,158,225,248,152,17,105,217,142,148,155,30,135,233,206,85,40,223,140,161,137,13,191,230,66,104,65,153,45,15,176,84,187,22];
      
      private static const RCON:Array = [[0,0,0,0],[1,0,0,0],[2,0,0,0],[4,0,0,0],[8,0,0,0],[16,0,0,0],[32,0,0,0],[64,0,0,0],[128,0,0,0],[27,0,0,0],[54,0,0,0]];
      
      public function TAES()
      {
         super();
         throw new Error("TAES Class Is Static Container Only");
      }
      
      private static function Cipher(param1:Array, param2:Array) : Array
      {
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:Array = null;
         var _loc4_:int = 4;
         _loc4_ = 4;
         _loc5_ = param2.length / _loc4_ - 1;
         _loc6_ = [[],[],[],[]];
         _loc3_ = 0;
         while(_loc3_ < 4 * _loc4_)
         {
            _loc6_[_loc3_ % 4][Math.floor(_loc3_ / 4)] = param1[_loc3_];
            _loc3_++;
         }
         _loc6_ = AddRoundKey(_loc6_,param2,0,_loc4_);
         _loc7_ = 1;
         while(_loc7_ < _loc5_)
         {
            _loc6_ = SubBytes(_loc6_,_loc4_);
            _loc6_ = ShiftRows(_loc6_,_loc4_);
            _loc6_ = MixColumns(_loc6_);
            _loc6_ = AddRoundKey(_loc6_,param2,_loc7_,_loc4_);
            _loc7_++;
         }
         _loc6_ = SubBytes(_loc6_,_loc4_);
         _loc6_ = ShiftRows(_loc6_,_loc4_);
         _loc6_ = AddRoundKey(_loc6_,param2,_loc5_,_loc4_);
         _loc8_ = new Array(4 * _loc4_);
         _loc3_ = 0;
         while(_loc3_ < 4 * _loc4_)
         {
            _loc8_[_loc3_] = _loc6_[_loc3_ % 4][Math.floor(_loc3_ / 4)];
            _loc3_++;
         }
         return _loc8_;
      }
      
      private static function KeyExpansion(param1:Array) : Array
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         _loc4_ = 4;
         _loc5_ = param1.length / 4;
         _loc6_ = _loc5_ + 6;
         _loc7_ = new Array(_loc4_ * (_loc6_ + 1));
         _loc8_ = new Array(4);
         _loc2_ = 0;
         while(_loc2_ < _loc5_)
         {
            _loc9_ = [param1[4 * _loc2_],param1[4 * _loc2_ + 1],param1[4 * _loc2_ + 2],param1[4 * _loc2_ + 3]];
            _loc7_[_loc2_] = _loc9_;
            _loc2_++;
         }
         _loc2_ = _loc5_;
         while(_loc2_ < _loc4_ * (_loc6_ + 1))
         {
            _loc7_[_loc2_] = new Array(4);
            _loc3_ = 0;
            while(_loc3_ < 4)
            {
               _loc8_[_loc3_] = _loc7_[_loc2_ - 1][_loc3_];
               _loc3_++;
            }
            if(_loc2_ % _loc5_ == 0)
            {
               _loc8_ = SubWord(RotWord(_loc8_));
               _loc3_ = 0;
               while(_loc3_ < 4)
               {
                  _loc8_[_loc3_] ^= RCON[_loc2_ / _loc5_][_loc3_];
                  _loc3_++;
               }
            }
            else if(_loc5_ > 6 && _loc2_ % _loc5_ == 4)
            {
               _loc8_ = SubWord(_loc8_);
            }
            _loc3_ = 0;
            while(_loc3_ < 4)
            {
               _loc7_[_loc2_][_loc3_] = _loc7_[_loc2_ - _loc5_][_loc3_] ^ _loc8_[_loc3_];
               _loc3_++;
            }
            _loc2_++;
         }
         return _loc7_;
      }
      
      private static function SubBytes(param1:Array, param2:int) : Array
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < 4)
         {
            _loc4_ = 0;
            while(_loc4_ < param2)
            {
               param1[_loc3_][_loc4_] = SBOX[param1[_loc3_][_loc4_]];
               _loc4_++;
            }
            _loc3_++;
         }
         return param1;
      }
      
      private static function ShiftRows(param1:Array, param2:int) : Array
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         _loc5_ = new Array(4);
         _loc3_ = 1;
         while(_loc3_ < 4)
         {
            _loc4_ = 0;
            while(_loc4_ < 4)
            {
               _loc5_[_loc4_] = param1[_loc3_][(_loc4_ + _loc3_) % param2];
               _loc4_++;
            }
            _loc4_ = 0;
            while(_loc4_ < 4)
            {
               param1[_loc3_][_loc4_] = _loc5_[_loc4_];
               _loc4_++;
            }
            _loc3_++;
         }
         return param1;
      }
      
      private static function MixColumns(param1:Array) : Array
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < 4)
         {
            _loc3_ = new Array(4);
            _loc4_ = new Array(4);
            _loc5_ = 0;
            while(_loc5_ < 4)
            {
               _loc3_[_loc5_] = param1[_loc5_][_loc2_];
               _loc4_[_loc5_] = param1[_loc5_][_loc2_] & 0x80 ? param1[_loc5_][_loc2_] << 1 ^ 0x011B : param1[_loc5_][_loc2_] << 1;
               _loc5_++;
            }
            param1[0][_loc2_] = _loc4_[0] ^ _loc3_[1] ^ _loc4_[1] ^ _loc3_[2] ^ _loc3_[3];
            param1[1][_loc2_] = _loc3_[0] ^ _loc4_[1] ^ _loc3_[2] ^ _loc4_[2] ^ _loc3_[3];
            param1[2][_loc2_] = _loc3_[0] ^ _loc3_[1] ^ _loc4_[2] ^ _loc3_[3] ^ _loc4_[3];
            param1[3][_loc2_] = _loc3_[0] ^ _loc4_[0] ^ _loc3_[1] ^ _loc3_[2] ^ _loc4_[3];
            _loc2_++;
         }
         return param1;
      }
      
      private static function AddRoundKey(param1:Array, param2:Array, param3:int, param4:int) : Array
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc5_ = 0;
         while(_loc5_ < 4)
         {
            _loc6_ = 0;
            while(_loc6_ < param4)
            {
               param1[_loc5_][_loc6_] ^= param2[param3 * 4 + _loc6_][_loc5_];
               _loc6_++;
            }
            _loc5_++;
         }
         return param1;
      }
      
      private static function SubWord(param1:Array) : Array
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < 4)
         {
            param1[_loc2_] = SBOX[param1[_loc2_]];
            _loc2_++;
         }
         return param1;
      }
      
      private static function RotWord(param1:Array) : Array
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(param1[0]);
         _loc2_ = 0;
         while(_loc2_ < 3)
         {
            param1[_loc2_] = param1[_loc2_ + 1];
            _loc2_++;
         }
         param1[3] = _loc3_;
         return param1;
      }
      
      public static function Encrypt(param1:String, param2:String = "", param3:int = 128) : String
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:String = null;
         var _loc14_:Array = null;
         var _loc15_:int = 0;
         var _loc16_:Array = null;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:Array = null;
         var _loc20_:int = 0;
         var _loc21_:Array = null;
         var _loc22_:String = null;
         _loc5_ = 16;
         if(!(param3 == BIT_KEY_128 || param3 == BIT_KEY_192 || param3 == BIT_KEY_256))
         {
            throw new Error("Must be a key mode of either 128, 192, 256 bits");
         }
         param1 = TUTF8.Encode(param1);
         param2 = TUTF8.Encode(param2);
         _loc6_ = param3 / 8;
         _loc7_ = new Array(_loc6_);
         _loc4_ = 0;
         while(_loc4_ < _loc6_)
         {
            _loc7_[_loc4_] = isNaN(param2.charCodeAt(_loc4_)) ? 0 : param2.charCodeAt(_loc4_);
            _loc4_++;
         }
         _loc8_ = Cipher(_loc7_,KeyExpansion(_loc7_));
         _loc8_ = _loc8_.concat(_loc8_.slice(0,_loc6_ - 16));
         _loc9_ = new Array(_loc5_);
         _loc10_ = new Date().getTime();
         _loc11_ = Math.floor(_loc10_ / 1000);
         _loc12_ = _loc10_ % 1000;
         _loc4_ = 0;
         while(_loc4_ < 4)
         {
            _loc9_[_loc4_] = _loc11_ >>> _loc4_ * 8 & 0xFF;
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < 4)
         {
            _loc9_[_loc4_ + 4] = _loc12_ & 0xFF;
            _loc4_++;
         }
         _loc13_ = "";
         _loc4_ = 0;
         while(_loc4_ < 8)
         {
            _loc13_ += String.fromCharCode(_loc9_[_loc4_]);
            _loc4_++;
         }
         _loc14_ = KeyExpansion(_loc8_);
         _loc15_ = Math.ceil(param1.length / _loc5_);
         _loc16_ = new Array(_loc15_);
         _loc17_ = 0;
         while(_loc17_ < _loc15_)
         {
            _loc18_ = 0;
            while(_loc18_ < 4)
            {
               _loc9_[15 - _loc18_] = _loc17_ >>> _loc18_ * 8 & 0xFF;
               _loc18_++;
            }
            _loc18_ = 0;
            while(_loc18_ < 4)
            {
               _loc9_[15 - _loc18_ - 4] = _loc17_ / 4294967296 >>> _loc18_ * 8;
               _loc18_++;
            }
            _loc19_ = Cipher(_loc9_,_loc14_);
            _loc20_ = _loc17_ < _loc15_ - 1 ? _loc5_ : int((param1.length - 1) % _loc5_ + 1);
            _loc21_ = new Array(_loc20_);
            _loc4_ = 0;
            while(_loc4_ < _loc20_)
            {
               _loc21_[_loc4_] = _loc19_[_loc4_] ^ param1.charCodeAt(_loc17_ * _loc5_ + _loc4_);
               _loc21_[_loc4_] = String.fromCharCode(_loc21_[_loc4_]);
               _loc4_++;
            }
            _loc16_[_loc17_] = _loc21_.join("");
            _loc17_++;
         }
         _loc22_ = _loc13_ + _loc16_.join("");
         return TBase64.Encode(_loc22_);
      }
      
      public static function Decrypt(param1:String, param2:String = "", param3:int = 128) : String
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         var _loc12_:String = null;
         var _loc13_:Array = null;
         var _loc14_:int = 0;
         var _loc15_:Array = null;
         var _loc16_:Array = null;
         var _loc17_:Array = null;
         var _loc18_:Array = null;
         var _loc19_:Array = null;
         var _loc20_:String = null;
         _loc7_ = 16;
         if(!(param3 == BIT_KEY_128 || param3 == BIT_KEY_192 || param3 == BIT_KEY_256))
         {
            throw new Error("Must be a key mode of either 128, 192, 256 bits");
         }
         param1 = TBase64.Decode(param1);
         param2 = TUTF8.Encode(param2);
         _loc8_ = param3 / 8;
         _loc9_ = new Array(_loc8_);
         _loc4_ = 0;
         while(_loc4_ < _loc8_)
         {
            _loc9_[_loc4_] = isNaN(param2.charCodeAt(_loc4_)) ? 0 : param2.charCodeAt(_loc4_);
            _loc4_++;
         }
         _loc10_ = Cipher(_loc9_,KeyExpansion(_loc9_));
         _loc10_ = _loc10_.concat(_loc10_.slice(0,_loc8_ - 16));
         _loc11_ = new Array(8);
         _loc12_ = param1.slice(0,8);
         _loc4_ = 0;
         while(_loc4_ < 8)
         {
            _loc11_[_loc4_] = _loc12_.charCodeAt(_loc4_);
            _loc4_++;
         }
         _loc13_ = KeyExpansion(_loc10_);
         _loc14_ = Math.ceil((param1.length - 8) / _loc7_);
         _loc15_ = new Array(_loc14_);
         _loc5_ = 0;
         while(_loc5_ < _loc14_)
         {
            _loc15_[_loc5_] = param1.slice(8 + _loc5_ * _loc7_,8 + _loc5_ * _loc7_ + _loc7_);
            _loc5_++;
         }
         _loc16_ = _loc15_;
         _loc17_ = new Array(_loc16_.length);
         _loc5_ = 0;
         while(_loc5_ < _loc14_)
         {
            _loc6_ = 0;
            while(_loc6_ < 4)
            {
               _loc11_[15 - _loc6_] = _loc5_ >>> _loc6_ * 8 & 0xFF;
               _loc6_++;
            }
            _loc6_ = 0;
            while(_loc6_ < 4)
            {
               _loc11_[15 - _loc6_ - 4] = (_loc5_ + 1) / 4294967296 - 1 >>> _loc6_ * 8 & 0xFF;
               _loc6_++;
            }
            _loc18_ = Cipher(_loc11_,_loc13_);
            _loc19_ = new Array(String(_loc16_[_loc5_]).length);
            _loc4_ = 0;
            while(_loc4_ < String(_loc16_[_loc5_]).length)
            {
               _loc19_[_loc4_] = _loc18_[_loc4_] ^ String(_loc16_[_loc5_]).charCodeAt(_loc4_);
               _loc19_[_loc4_] = String.fromCharCode(_loc19_[_loc4_]);
               _loc4_++;
            }
            _loc17_[_loc5_] = _loc19_.join("");
            _loc5_++;
         }
         _loc20_ = _loc17_.join("");
         return TUTF8.Decode(_loc20_);
      }
   }
}

