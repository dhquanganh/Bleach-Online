package Foundation.Network
{
   import Foundation.Utilities.TUtilityMath;
   import Foundation.Utilities.TUtilityMemory;
   import Resources.Constants.CONST_GT_NETWORK;
   import Resources.Constants.TEXT_ERROR;
   import flash.sampler.*;
   import flash.utils.*;
   
   public class TPacketCipher
   {
      
      private static const SIZE_PacketLength:uint = 0;
      
      private static const SIZE_CheckCodeLength:uint = CONST_GT_NETWORK.SIZE_CheckCodeLength;
      
      private static const SIZE_PacketID:uint = CONST_GT_NETWORK.SIZE_PacketID;
      
      private static const PACKET_MAX_LEN:uint = CONST_GT_NETWORK.PACKET_MAX_LEN;
      
      private static const SIZE_UINT:uint = 4;
      
      private static const SIZE_UCHAR:uint = 1;
      
      private static const SIZE_MAPPINGS:uint = SIZE_UCHAR * ENCRYPT_MAPKEY_LEN;
      
      private static const PACKET_KEY:uint = 3346777707;
      
      private static const ENCRYPT_MAPKEY_LEN:uint = 256;
      
      private static const ENCRYPT_STEP_LEN:uint = 1;
      
      private static const XOR_TIMES:uint = 8;
      
      private static const MAX_SOURCE_LEN:uint = 64;
      
      private static const MAX_ENCRYPT_LEN:uint = MAX_SOURCE_LEN * XOR_TIMES;
      
      private static const ENCRYPT_KEY_LEN:uint = 8;
      
      private static const MAPPING_EncryptMap:Array = [112,47,64,95,68,142,110,69,126,171,44,31,180,172,157,145,13,54,155,11,212,196,57,116,191,35,22,20,6,235,4,62,18,92,139,188,97,99,246,165,225,101,216,245,90,7,240,19,242,32,107,74,36,89,137,100,215,66,106,94,61,10,119,224,128,39,184,197,140,14,250,138,213,41,86,87,108,83,103,65,232,0,26,206,134,131,176,34,40,77,63,38,70,79,111,43,114,58,241,141,151,149,73,132,229,227,121,143,81,16,168,130,198,221,255,252,228,207,179,9,93,234,156,52,249,23,159,218,135,248,21,5,60,211,164,133,46,251,238,71,59,239,55,127,147,175,105,12,113,49,222,33,117,160,170,186,124,56,2,183,129,1,253,231,29,204,205,189,27,122,42,173,102,190,85,51,3,219,136,178,30,78,185,230,194,247,203,125,201,98,195,166,220,167,80,181,75,148,192,146,76,17,91,120,217,177,237,25,233,161,28,182,50,153,163,118,158,123,109,154,48,214,169,37,199,174,150,53,208,187,210,200,162,8,243,209,115,244,72,45,144,202,226,88,193,24,82,254,223,104,152,84,236,96,67,15];
      
      private static const MAPPING_CrevasseMap:Array = [81,161,158,176,30,131,28,45,233,119,61,19,147,16,69,255,109,201,32,47,27,130,26,125,245,207,82,168,210,164,180,11,49,151,87,25,52,223,91,65,88,73,170,95,10,239,136,1,220,149,212,175,123,227,17,142,157,22,97,140,132,60,31,90,2,79,57,254,4,7,92,139,238,102,51,196,200,89,181,93,194,108,246,77,251,174,74,75,243,53,44,202,33,120,59,3,253,36,189,37,55,41,172,78,249,146,58,50,76,218,6,94,0,148,96,236,23,152,215,62,203,106,169,217,156,187,8,143,64,160,111,85,103,135,84,128,178,54,71,34,68,99,5,107,240,15,199,144,197,101,226,100,250,213,219,18,122,14,216,126,153,209,232,214,134,39,191,193,110,222,154,9,13,171,225,145,86,205,179,118,12,195,211,159,66,182,155,229,35,167,173,24,198,244,184,190,21,67,112,224,231,188,241,186,165,166,83,117,228,235,230,133,20,72,221,56,42,204,127,177,192,113,150,248,63,40,242,105,116,104,183,163,80,208,121,29,252,206,138,141,46,98,48,234,237,43,38,185,129,124,70,137,115,162,247,114];
      
      private var FSendRound:uint;
      
      private var FRecvRound:uint;
      
      private var FSendXorKey:uint;
      
      private var FRecvXorKey:uint;
      
      private var FSendPacketCount:uint;
      
      private var FRecvPacketCount:uint;
      
      private var FEncryptMaps:Vector.<uint>;
      
      private var FCrevasseMaps:Vector.<uint>;
      
      private var FRoundStep:uint;
      
      private var FSendRoundEx:uint;
      
      private var FRecvRoundEx:uint;
      
      private var FSteps:Vector.<int>;
      
      public function TPacketCipher()
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         super();
         this.FSendRound = 0;
         this.FRecvRound = 0;
         this.FSendRoundEx = 0;
         this.FRecvRoundEx = 0;
         this.FSendPacketCount = 0;
         this.FRecvPacketCount = 0;
         this.FEncryptMaps = new Vector.<uint>(ENCRYPT_MAPKEY_LEN);
         _loc3_ = 4;
         _loc1_ = 0;
         while(_loc1_ < _loc3_)
         {
            this.FEncryptMaps[_loc1_] = MAPPING_EncryptMap[_loc1_];
            _loc1_++;
         }
         this.FCrevasseMaps = new Vector.<uint>(ENCRYPT_MAPKEY_LEN);
         this.FSteps = new Vector.<int>();
         _loc1_ = 2;
         while(_loc1_ < 100)
         {
            _loc4_ = Math.sqrt(Number(_loc1_));
            _loc2_ = 2;
            while(_loc2_ <= _loc4_)
            {
               if(_loc1_ % _loc2_ == 0)
               {
                  break;
               }
               _loc2_++;
            }
            if(_loc2_ > _loc4_)
            {
               this.FSteps.push(_loc1_);
            }
            _loc1_++;
         }
      }
      
      private function MapSendByte(param1:uint) : uint
      {
         var _loc2_:uint = 0;
         _loc2_ = uint(MAPPING_EncryptMap[(param1 + this.FSendRound) % 256]);
         this.FSendRound += 3;
         this.FSendRound %= 256;
         return _loc2_;
      }
      
      private function MapRecvByte(param1:uint) : uint
      {
         var _loc2_:uint = 0;
         _loc2_ = (MAPPING_CrevasseMap[param1 % 256] - this.FRecvRound + 256) % 256;
         this.FRecvRound += 3;
         this.FRecvRound %= 256;
         return _loc2_;
      }
      
      private function SeedRandMap(param1:uint) : uint
      {
         return uint(param1 * 241103 + 2933101 >>> 16);
      }
      
      private function MapRecvByteEx(param1:uint) : uint
      {
         var _loc2_:uint = (this.FCrevasseMaps[param1 % 256] - this.FRecvRoundEx) % 256;
         this.FRecvRoundEx += this.FRoundStep;
         this.FRecvRoundEx %= 256;
         return _loc2_;
      }
      
      private function MapSendByteEx(param1:uint) : uint
      {
         var _loc2_:uint = this.FEncryptMaps[(param1 % 256 + this.FSendRoundEx) % 256];
         this.FSendRoundEx += this.FRoundStep;
         this.FSendRoundEx %= 256;
         return _loc2_;
      }
      
      private function EncryptData(param1:ByteArray, param2:uint) : uint
      {
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:ByteArray = null;
         var _loc10_:uint = 0;
         if(param2 < SIZE_PacketLength + SIZE_PacketID)
         {
            return 0;
         }
         if(param2 > PACKET_MAX_LEN)
         {
            return 0;
         }
         _loc4_ = param2 + SIZE_CheckCodeLength - SIZE_PacketLength;
         _loc5_ = 0;
         if(_loc4_ % SIZE_UINT != 0)
         {
            _loc5_ = SIZE_UINT - _loc4_ % SIZE_UINT;
            param1.position = SIZE_PacketLength + _loc4_;
            _loc3_ = 0;
            while(_loc3_ < _loc5_)
            {
               param1.writeByte(0);
               _loc3_++;
            }
         }
         _loc6_ = 0;
         _loc3_ = int(SIZE_PacketLength);
         while(_loc3_ < param2)
         {
            _loc6_ += param1[_loc3_];
            _loc6_ = _loc6_ % 256;
            param1[_loc3_] = this.MapSendByte(param1[_loc3_]);
            _loc3_++;
         }
         param1.position = param2;
         _loc6_ = ~_loc6_ % 256;
         _loc6_ = (_loc6_ + 1) % 256;
         param1.writeByte(_loc6_);
         param2 += SIZE_CheckCodeLength;
         _loc7_ = this.FSendXorKey;
         if(this.FSendPacketCount == 0)
         {
            _loc7_ = uint(new Date().time);
            _loc7_ = this.SeedRandMap(_loc7_);
            _loc7_ = uint(_loc7_ | this.SeedRandMap(_loc7_ >>> 16) << 16);
            _loc7_ = uint(_loc7_ ^ PACKET_KEY);
            this.FSendXorKey = _loc7_;
         }
         _loc9_ = new ByteArray();
         _loc9_.endian = Endian.LITTLE_ENDIAN;
         param1.position = SIZE_PacketLength;
         var _loc11_:uint = (_loc4_ + _loc5_) / SIZE_UINT;
         _loc3_ = 0;
         while(_loc3_ < _loc11_)
         {
            _loc10_ = param1.readUnsignedInt();
            _loc9_.writeUnsignedInt(_loc10_ = uint(_loc10_ ^ _loc7_));
            _loc9_.position -= 4;
            _loc7_ = this.SeedRandMap(_loc9_.readUnsignedShort());
            _loc7_ = uint(_loc7_ | uint(this.SeedRandMap(_loc9_.readUnsignedShort())) << 16);
            _loc7_ = uint(_loc7_ ^ PACKET_KEY);
            _loc3_++;
         }
         param1.clear();
         var _loc12_:uint = 0;
         if(this.FSendPacketCount == 0)
         {
            param1.writeUnsignedInt(this.FSendXorKey);
            param2 += SIZE_UINT;
            _loc12_ = SIZE_UINT;
         }
         TUtilityMemory.CopyMemory(param1,_loc9_,_loc9_.length - _loc5_,_loc12_);
         _loc9_.clear();
         _loc9_ = null;
         ++this.FSendPacketCount;
         this.FSendXorKey = _loc7_;
         return param2;
      }
      
      private function EncryptDataEx(param1:ByteArray, param2:uint) : uint
      {
         var _loc8_:ByteArray = null;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc3_:int = 0;
         if(param2 < SIZE_PacketLength + SIZE_PacketID)
         {
            return 0;
         }
         if(param2 > PACKET_MAX_LEN)
         {
            return 0;
         }
         var _loc4_:uint = 0;
         _loc3_ = int(SIZE_PacketLength);
         while(_loc3_ < param2)
         {
            _loc4_ += param1[_loc3_];
            _loc4_ = _loc4_ % 256;
            param1[_loc3_] = this.MapSendByteEx(param1[_loc3_]);
            _loc3_++;
         }
         param1.position = param2;
         _loc4_ = ~_loc4_ % 256;
         _loc4_ = (_loc4_ + 1) % 256;
         param1.writeByte(_loc4_);
         param2 += SIZE_CheckCodeLength;
         var _loc5_:uint = SIZE_PacketLength;
         var _loc6_:uint = param2 - _loc5_;
         var _loc7_:uint = 0;
         if(_loc6_ % SIZE_UINT != 0)
         {
            _loc7_ = SIZE_UINT - _loc6_ % SIZE_UINT;
            param1.position = _loc5_ + _loc6_;
            _loc3_ = 0;
            while(_loc3_ < _loc7_)
            {
               param1.writeByte(0);
               _loc3_++;
            }
         }
         _loc8_ = new ByteArray();
         _loc8_.endian = Endian.LITTLE_ENDIAN;
         param1.position = _loc5_;
         var _loc9_:uint = this.FSendXorKey;
         var _loc12_:uint = (_loc6_ + _loc7_) / SIZE_UINT;
         _loc3_ = 0;
         while(_loc3_ < _loc12_)
         {
            _loc10_ = param1.readUnsignedInt();
            _loc8_.writeUnsignedInt(_loc10_ = uint(_loc10_ ^ _loc9_));
            _loc8_.position -= 4;
            _loc9_ = this.SeedRandMap(_loc8_.readUnsignedShort());
            _loc9_ = uint(_loc9_ | uint(this.SeedRandMap(_loc8_.readUnsignedShort())) << 16);
            _loc9_ = uint(_loc9_ ^ PACKET_KEY);
            _loc3_++;
         }
         param1.clear();
         TUtilityMemory.CopyMemory(param1,_loc8_,_loc8_.length - _loc7_);
         _loc8_.clear();
         _loc8_ = null;
         ++this.FSendPacketCount;
         this.FSendXorKey = _loc9_;
         return param2;
      }
      
      private function CrevasseDataEx(param1:ByteArray, param2:uint) : uint
      {
         var _loc8_:ByteArray = null;
         var _loc9_:ByteArray = null;
         var _loc10_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param2 < SIZE_PacketLength + SIZE_PacketID)
         {
            return 0;
         }
         param1.endian = Endian.LITTLE_ENDIAN;
         var _loc5_:uint = 0;
         if(param2 % SIZE_UINT != 0)
         {
            _loc5_ = SIZE_UINT - param2 % SIZE_UINT;
            param1.position = param2;
            _loc3_ = 0;
            while(_loc3_ < _loc5_)
            {
               param1.writeByte(0);
               _loc3_++;
            }
         }
         var _loc6_:uint = SIZE_PacketLength;
         if(this.FRecvPacketCount == 0)
         {
            _loc6_ += SIZE_UINT;
            if(param2 < _loc6_ + SIZE_MAPPINGS + SIZE_MAPPINGS + ENCRYPT_STEP_LEN)
            {
               return 0;
            }
            param1.position = SIZE_PacketLength;
            this.FRecvXorKey = param1.readUnsignedInt();
         }
         var _loc7_:uint = this.FRecvXorKey;
         _loc8_ = new ByteArray();
         _loc9_ = new ByteArray();
         _loc8_.endian = Endian.LITTLE_ENDIAN;
         _loc9_.endian = Endian.LITTLE_ENDIAN;
         param1.position = _loc6_;
         var _loc11_:uint = (param2 + _loc5_ - _loc6_) / 4;
         _loc3_ = 0;
         while(_loc3_ < _loc11_)
         {
            if(_loc3_ == _loc11_ - 1 && _loc5_ > 0)
            {
               _loc9_.writeUnsignedInt(this.FRecvXorKey);
               _loc4_ = SIZE_UINT - _loc5_;
               TUtilityMemory.CopyMemory(param1,_loc9_,_loc5_,param2,_loc4_);
            }
            _loc7_ = this.SeedRandMap(param1.readUnsignedShort());
            _loc7_ = uint(_loc7_ | uint(this.SeedRandMap(param1.readUnsignedShort())) << 16);
            _loc7_ = uint(_loc7_ ^ PACKET_KEY);
            param1.position -= SIZE_UINT;
            _loc10_ = param1.readUnsignedInt();
            _loc10_ = uint(_loc10_ ^ this.FRecvXorKey);
            this.FRecvXorKey = _loc7_;
            _loc8_.writeUnsignedInt(_loc10_);
            _loc3_++;
         }
         TUtilityMemory.CopyMemory(param1,_loc8_,0,_loc6_);
         _loc9_.clear();
         _loc8_.clear();
         _loc8_ = null;
         if(this.FRecvPacketCount == 0)
         {
            param1.position = _loc6_;
            this.FRoundStep = param1.readUnsignedByte();
            param1.position = _loc6_ + ENCRYPT_STEP_LEN;
            _loc3_ = 0;
            while(_loc3_ < SIZE_MAPPINGS)
            {
               this.FEncryptMaps[_loc3_] = param1.readUnsignedByte();
               _loc3_++;
            }
            param1.position = _loc6_ + ENCRYPT_STEP_LEN + SIZE_MAPPINGS;
            _loc3_ = 0;
            while(_loc3_ < SIZE_MAPPINGS)
            {
               this.FCrevasseMaps[_loc3_] = param1.readUnsignedByte();
               _loc3_++;
            }
            TUtilityMemory.CopyMemory(_loc9_,param1);
            TUtilityMemory.CopyMemory(param1,_loc9_,param2 - _loc6_ - ENCRYPT_STEP_LEN - SIZE_MAPPINGS - SIZE_MAPPINGS,SIZE_PacketLength,_loc6_ + ENCRYPT_STEP_LEN + SIZE_MAPPINGS + SIZE_MAPPINGS);
            param2 -= SIZE_MAPPINGS + SIZE_MAPPINGS + ENCRYPT_STEP_LEN + SIZE_UINT;
         }
         param2 -= SIZE_CheckCodeLength;
         param1.position = param2;
         var _loc12_:uint = param1.readUnsignedByte();
         _loc3_ = int(SIZE_PacketLength);
         while(_loc3_ < param2)
         {
            param1[_loc3_] = this.MapRecvByteEx(param1[_loc3_]);
            _loc12_ += param1[_loc3_];
            _loc12_ = _loc12_ % 256;
            _loc3_++;
         }
         if(_loc12_ != 0)
         {
            throw new Error(TEXT_ERROR.TEXT_ERROR_NETWORK_DATA);
         }
         ++this.FRecvPacketCount;
         return param2;
      }
      
      public function InitRandom() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         _loc2_ = TUtilityMath.RandomRange(0,int.MAX_VALUE);
         this.FRoundStep = this.FSteps[_loc2_ % this.FSteps.length] % 256;
         _loc1_ = 0;
         while(_loc1_ < ENCRYPT_MAPKEY_LEN)
         {
            _loc5_ = ENCRYPT_MAPKEY_LEN - 1 - _loc1_;
            _loc2_ = TUtilityMath.RandomRange(0,int.MAX_VALUE);
            _loc3_ = _loc2_ % (ENCRYPT_MAPKEY_LEN - _loc1_);
            _loc4_ = int(this.FEncryptMaps[_loc5_]);
            this.FEncryptMaps[_loc5_] = this.FEncryptMaps[_loc3_];
            this.FEncryptMaps[_loc3_] = _loc4_;
            this.FCrevasseMaps[this.FEncryptMaps[_loc5_]] = _loc5_;
            this.FCrevasseMaps[this.FEncryptMaps[_loc3_]] = _loc3_;
            _loc1_++;
         }
      }
      
      public function ClearData() : void
      {
         this.FSendRound = 0;
         this.FRecvRound = 0;
         this.FSendPacketCount = 0;
         this.FRecvPacketCount = 0;
         this.FSendRoundEx = 0;
         this.FRecvRoundEx = 0;
      }
      
      public function EncryptNetBuffer(param1:ByteArray, param2:uint, param3:Boolean = true) : uint
      {
         if(param3)
         {
            if(this.FSendPacketCount == 0)
            {
               return this.EncryptData(param1,param2);
            }
            return this.EncryptDataEx(param1,param2);
         }
         return this.EncryptDataEx(param1,param2);
      }
      
      public function CrevasseNetBuffer(param1:ByteArray, param2:uint) : uint
      {
         return this.CrevasseDataEx(param1,param2);
      }
   }
}

