package ghostcat.util.data
{
   public class Json
   {
      
      private static var decoder:JsonDecoder = null;
      
      private static var encoder:JsonEncoder = null;
      
      public function Json()
      {
         super();
      }
      
      public static function decode(param1:String) : *
      {
         if(decoder == null)
         {
            decoder = new JsonDecoder();
         }
         return decoder.decode(param1);
      }
      
      public static function encode(param1:*) : String
      {
         if(encoder == null)
         {
            encoder = new JsonEncoder();
         }
         return encoder.encode(param1);
      }
   }
}

class JsonDecoder
{
   
   private var chr:int;
   
   private var tok:int;
   
   private var src:String;
   
   private var lastPos:int;
   
   private var nextPos:int;
   
   private var cachedChr:Boolean;
   
   private var cachedTok:Boolean;
   
   public function JsonDecoder()
   {
      super();
   }
   
   public function decode(param1:String) : *
   {
      var _loc2_:* = undefined;
      this.src = param1;
      this.nextPos = 0;
      this.cachedChr = false;
      this.cachedTok = false;
      _loc2_ = this.nextValue();
      if(this.nextToken() != 255)
      {
         this.error("More than one value");
      }
      return _loc2_;
   }
   
   private function nextChar() : int
   {
      if(this.cachedChr)
      {
         this.cachedChr = false;
         return this.chr;
      }
      return this.chr = int(this.src.charCodeAt(this.nextPos++)) || 0;
   }
   
   private function nextToken() : int
   {
      if(this.cachedTok)
      {
         this.cachedTok = false;
         return this.tok;
      }
      while(this.nextChar() == 32 || this.chr == 9 || Boolean(this.isNewline(this.chr)))
      {
      }
      if(this.chr == 47)
      {
         if(this.nextChar() == 47)
         {
            while(!this.isNewline(this.nextChar()))
            {
               if(this.chr == 0)
               {
                  return this.tok = 255;
               }
            }
         }
         else if(this.chr == 42)
         {
            while(true)
            {
               if(this.nextChar() == 42)
               {
                  if(this.nextChar() == 47)
                  {
                     break;
                  }
                  if(this.chr == 42)
                  {
                     this.cachedChr = true;
                  }
               }
               if(this.chr == 0)
               {
                  this.error("Find /* but cannot find */");
               }
            }
         }
         else
         {
            this.error("Unkown token /" + String.fromCharCode(this.chr));
         }
         return this.nextToken();
      }
      this.lastPos = this.nextPos - 1;
      if(this.chr == 34 || this.chr == 39)
      {
         return this.tok = 252;
      }
      if(this.chr == 93)
      {
         return this.tok = 251;
      }
      if(this.chr == 91)
      {
         return this.tok = 250;
      }
      if(this.chr == 125)
      {
         return this.tok = 249;
      }
      if(this.chr == 123)
      {
         return this.tok = 248;
      }
      if(this.chr == 44)
      {
         return this.tok = 246;
      }
      if(this.chr == 58)
      {
         return this.tok = 247;
      }
      if(this.chr == 45)
      {
         return this.tok = 245;
      }
      if(this.chr == 0)
      {
         return this.tok = 255;
      }
      if(this.chr == 46)
      {
         if(!this.isDigit(this.nextChar()))
         {
            this.error("Need digit after .");
         }
         return this.nextFraction();
      }
      if(this.isDigit(this.chr))
      {
         if(this.chr == 48)
         {
            if(this.nextChar() == 120)
            {
               if(!this.isHex(this.nextChar()))
               {
                  this.error("Need hexadecimal digit after 0x");
               }
               while(this.isHex(this.nextChar()))
               {
               }
               return this.cache(254);
            }
            this.cachedChr = true;
         }
         while(this.nextChar() != 46)
         {
            if(this.chr == 101 || this.chr == 69)
            {
               return this.nextExponent();
            }
            if(!this.isDigit(this.chr))
            {
               return this.cache(254);
            }
         }
         return this.nextFraction();
      }
      if(!this.isIdentifier(this.chr))
      {
         this.error("Unkown token " + this.flush());
      }
      while(this.isIdentifier(this.nextChar()))
      {
      }
      return this.cache(253);
   }
   
   private function nextValue() : *
   {
      var _loc1_:String = null;
      var _loc2_:Object = null;
      var _loc3_:String = null;
      var _loc4_:Array = null;
      var _loc5_:Boolean = false;
      var _loc6_:int = 0;
      if(this.nextToken() == 253)
      {
         _loc1_ = this.flush(1);
         if(_loc1_ == "NaN")
         {
            return NaN;
         }
         if(_loc1_ == "null")
         {
            return null;
         }
         if(_loc1_ == "true")
         {
            return true;
         }
         if(_loc1_ == "false")
         {
            return false;
         }
         if(_loc1_ == "Infinity")
         {
            return Infinity;
         }
         if(_loc1_ == "undefined")
         {
            return undefined;
         }
         this.error("Unkown idenfifier " + _loc1_);
      }
      if(this.tok == 248)
      {
         _loc2_ = {};
         if(this.nextToken() != 249)
         {
            this.cachedTok = true;
            while(true)
            {
               if(this.nextToken() == 252)
               {
                  _loc3_ = this.nextString();
               }
               else if(this.tok != 253)
               {
                  this.error("Unexpected token " + this.flush());
               }
               if(this.nextToken() != 247)
               {
                  this.error("Expected token : found " + this.flush());
               }
               _loc2_[_loc3_] = this.nextValue();
               if(this.nextToken() == 249)
               {
                  break;
               }
               if(this.tok != 246)
               {
                  this.error("Expected token } or , found " + this.flush());
               }
            }
         }
         return _loc2_;
      }
      if(this.tok == 250)
      {
         _loc4_ = [];
         if(this.nextToken() != 251)
         {
            _loc5_ = false;
            _loc6_ = 0;
            this.cachedTok = true;
            while(this.nextToken() != 251)
            {
               if(this.tok == 246)
               {
                  _loc4_.length = ++_loc6_;
                  _loc5_ = false;
               }
               else if(_loc5_)
               {
                  this.error("Expected token  ] or , found " + this.flush());
               }
               else
               {
                  _loc5_ = true;
                  this.cachedTok = true;
                  _loc4_[_loc6_] = this.nextValue();
               }
            }
         }
         return _loc4_;
      }
      if(this.tok == 252)
      {
         return this.nextString();
      }
      if(this.tok == 254)
      {
         return Number(this.flush(1));
      }
      if(this.tok == 255)
      {
         this.error("End of input was encountered");
      }
      if(this.tok != 245)
      {
         this.error("Unexpected token " + this.flush());
      }
      return -this.nextValue();
   }
   
   private function nextString() : String
   {
      var _loc3_:* = 0;
      this.lastPos = this.nextPos;
      var _loc1_:String = "";
      var _loc2_:int = int(this.chr);
      while(this.nextChar() != _loc2_)
      {
         if(this.chr == 0 || Boolean(this.isNewline(this.chr)))
         {
            this.error("Unclosed string");
         }
         if(this.chr == 92)
         {
            _loc1_ += this.flush(1);
            this.lastPos += 2;
            if(this.nextChar() == 117 || this.chr == 120)
            {
               _loc3_ = this.chr == 117 ? 4 : 2;
               while(_loc3_ > 0 && Boolean(this.isHex(this.nextChar())))
               {
                  _loc3_--;
               }
               if(_loc3_ == 0)
               {
                  _loc1_ += String.fromCharCode(parseInt(this.flush(),16));
               }
               else
               {
                  this.nextPos = --this.lastPos;
               }
            }
            else if(this.chr == 110)
            {
               _loc1_ += "\n";
            }
            else if(this.chr == 114)
            {
               _loc1_ += "\r";
            }
            else if(this.chr == 98)
            {
               _loc1_ += "\b";
            }
            else if(this.chr == 102)
            {
               _loc1_ += "\f";
            }
            else if(this.chr == 116)
            {
               _loc1_ += "\t";
            }
            else
            {
               --this.lastPos;
            }
         }
      }
      return _loc1_ + this.flush(1);
   }
   
   private function nextFraction() : int
   {
      while(!(this.nextChar() == 101 || this.chr == 69))
      {
         if(!this.isDigit(this.chr))
         {
            return this.cache(254);
         }
      }
      return this.nextExponent();
   }
   
   private function nextExponent() : int
   {
      if(this.nextChar() != 43 && this.chr != 45)
      {
         this.cachedChr = true;
      }
      if(!this.isDigit(this.nextChar()))
      {
         this.error("Need digit after exponent");
      }
      while(this.isDigit(this.nextChar()))
      {
      }
      return this.cache(254);
   }
   
   private function cache(param1:int) : int
   {
      this.cachedChr = true;
      return this.tok = param1;
   }
   
   private function flush(param1:int = 0) : String
   {
      return this.src.substring(this.lastPos,this.lastPos = this.nextPos - param1);
   }
   
   private function error(param1:String) : void
   {
      throw new Error(param1);
   }
   
   private function isHex(param1:int) : Boolean
   {
      return Boolean(this.isDigit(param1)) || param1 > 96 && param1 < 103 || param1 > 64 && param1 < 71;
   }
   
   private function isDigit(param1:int) : Boolean
   {
      return param1 > 47 && param1 < 58;
   }
   
   private function isNewline(param1:int) : Boolean
   {
      return param1 == 10 || param1 == 13;
   }
   
   private function isIdentifier(param1:int) : Boolean
   {
      if(this.isDigit(param1))
      {
         return true;
      }
      if(param1 > 96 && param1 < 123)
      {
         return true;
      }
      if(param1 > 64 && param1 < 91)
      {
         return true;
      }
      if(param1 == 95 || param1 == 36)
      {
         return true;
      }
      if(param1 == 215 || param1 == 247)
      {
         return false;
      }
      if(param1 < 192 || param1 > 64255)
      {
         return false;
      }
      if(param1 > 214 && param1 < 216)
      {
         return false;
      }
      if(param1 > 246 && param1 < 248)
      {
         return false;
      }
      if(param1 > 8191 && param1 < 12352)
      {
         return false;
      }
      if(param1 > 12687 && param1 < 13056)
      {
         return false;
      }
      if(param1 > 13183 && param1 < 13312)
      {
         return false;
      }
      if(param1 > 15661 && param1 < 19968)
      {
         return false;
      }
      if(param1 > 40959 && param1 < 63744)
      {
         return false;
      }
      return true;
   }
}

class JsonEncoder
{
   
   private var unescapes:Object = {
      "\b":"b",
      "\f":"f",
      "\n":"n",
      "\r":"r",
      "\t":"t"
   };
   
   private var escapePtn:RegExp = /["\b\f\n\r\t\\]/g;
   
   private var controlPtn:RegExp = /\x00-\x19/g;
   
   public function JsonEncoder()
   {
      super();
   }
   
   public function encode(param1:*) : String
   {
      var _loc4_:int = 0;
      var _loc5_:int = 0;
      var _loc6_:String = null;
      var _loc2_:String = null;
      var _loc3_:Boolean = false;
      switch(param1)
      {
         case null:
            return "null";
         case undefined:
            return "undefined";
         default:
            if(param1 is String)
            {
               return this.encodeString(param1);
            }
            if(param1 is Array)
            {
               _loc2_ = "[";
               _loc4_ = 0;
               _loc5_ = int(param1["length"]);
               while(_loc4_ < _loc5_)
               {
                  if(_loc3_)
                  {
                     _loc2_ += ",";
                  }
                  else
                  {
                     _loc3_ = true;
                  }
                  _loc2_ += this.encode(param1[_loc4_]);
                  _loc4_++;
               }
               return _loc2_ + "]";
            }
            if(param1["constructor"] == Object)
            {
               _loc2_ = "{";
               for(_loc6_ in param1)
               {
                  if(_loc3_)
                  {
                     _loc2_ += ",";
                  }
                  else
                  {
                     _loc3_ = true;
                  }
                  _loc2_ += this.encodeString(_loc6_) + ":" + this.encode(param1[_loc6_]);
               }
               return _loc2_ + "}";
            }
            return param1;
      }
   }
   
   private function escapeRepl(... rest) : String
   {
      return "\\" + (this.unescapes[rest[0]] || rest[0]);
   }
   
   private function controlRepl(... rest) : String
   {
      var _loc2_:String = String(rest[0]).charCodeAt(0).toString(16);
      if(_loc2_.length == 1)
      {
         _loc2_ = "0" + _loc2_;
      }
      return "\\x" + _loc2_;
   }
   
   private function encodeString(param1:String) : String
   {
      param1 = param1.replace(this.escapePtn,this.escapeRepl);
      param1 = param1.replace(this.controlPtn,this.controlRepl);
      return "\"" + param1 + "\"";
   }
}
