package Foundation.SensitiveWord
{
   import Foundation.Utilities.*;
   
   public class TSensitiveWord
   {
      
      protected var FTreeNode:TTreeNode;
      
      protected var FWords:Vector.<String>;
      
      protected var FIsInitialized:Boolean;
      
      public function TSensitiveWord()
      {
         super();
         this.FWords = new Vector.<String>();
         this.FIsInitialized = false;
      }
      
      protected function SetSensitiveWordTree(param1:Vector.<String>) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:String = null;
         var _loc8_:TTreeNode = null;
         var _loc9_:TTreeNode = null;
         this.FTreeNode = new TTreeNode();
         this.FTreeNode.Str = "";
         _loc3_ = param1.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1[_loc2_];
            _loc5_ = uint(_loc4_.length);
            _loc8_ = this.FTreeNode;
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc8_.IsLeaf = false;
               _loc7_ = _loc4_.charAt(_loc6_);
               _loc9_ = _loc8_.GetNode(_loc7_);
               if(_loc9_ != null)
               {
                  _loc8_ = _loc9_;
                  if(_loc9_.IsLeaf)
                  {
                     _loc8_.Mid = true;
                  }
                  if(!_loc9_.IsLeaf && _loc6_ == _loc5_ - 1)
                  {
                     _loc8_.IsLeaf = true;
                  }
               }
               else
               {
                  _loc8_ = _loc8_.SetNode(_loc7_);
               }
               if(_loc5_ == 1)
               {
                  _loc8_.IsOne = true;
               }
               _loc6_++;
            }
            _loc2_++;
         }
      }
      
      protected function Replace(param1:String, param2:String) : String
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc6_:Vector.<TTreeNode> = null;
         var _loc7_:Vector.<uint> = null;
         var _loc8_:Array = null;
         var _loc9_:TTreeNode = null;
         var _loc10_:TTreeNode = null;
         var _loc11_:uint = 0;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:uint = 0;
         var _loc15_:uint = 0;
         var _loc16_:uint = 0;
         var _loc17_:uint = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         _loc6_ = new Vector.<TTreeNode>();
         _loc4_ = uint(param1.length);
         _loc7_ = new Vector.<uint>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc11_ = _loc6_.length;
            _loc5_ = param1.charAt(_loc3_);
            _loc17_ = _loc6_.length;
            while(_loc11_ > 0)
            {
               _loc10_ = _loc6_.shift();
               if(_loc10_ != null)
               {
                  _loc9_ = _loc10_.GetNode(_loc5_);
               }
               if(_loc9_ != null)
               {
                  if(_loc9_.IsLeaf || _loc9_.Mid && _loc10_.Parent != null)
                  {
                     _loc13_ = _loc9_.GetSensitiveWord();
                     _loc14_ = uint(_loc13_.length);
                     if(param1.indexOf(_loc13_) >= _loc3_ - _loc14_ && param1.indexOf(_loc13_) < _loc3_)
                     {
                        _loc15_ = _loc3_ - _loc14_ + 1;
                        while(_loc15_ <= _loc3_)
                        {
                           _loc7_[_loc15_] = 1;
                           _loc15_++;
                        }
                     }
                     else
                     {
                        _loc15_ = _loc3_ - _loc14_ - _loc16_ + 1;
                        while(_loc15_ <= _loc3_)
                        {
                           _loc7_[_loc15_] = 1;
                           _loc15_++;
                        }
                        _loc16_ = 0;
                     }
                  }
                  if(_loc9_.Mid && _loc9_.IsLeaf)
                  {
                     _loc6_.push(_loc9_);
                  }
                  else
                  {
                     _loc6_.push(_loc9_);
                  }
               }
               else
               {
                  _loc18_ = _loc10_.Str.charCodeAt(0);
                  _loc19_ = param1.charCodeAt(_loc3_);
                  if(this.IsValidUnicode(_loc18_) == true)
                  {
                     if(this.IsValidUnicode(_loc19_) == true)
                     {
                        if(_loc11_ == _loc17_)
                        {
                           _loc16_ = 0;
                        }
                     }
                  }
                  else if(this.IsValidChar(_loc18_) == true)
                  {
                     if(this.IsValidChar(_loc19_) == true)
                     {
                        if(_loc11_ == _loc17_)
                        {
                           _loc16_ = 0;
                        }
                     }
                  }
               }
               _loc18_ = _loc10_.Str.charCodeAt(0);
               _loc19_ = param1.charCodeAt(_loc3_);
               if(this.IsValidUnicode(_loc18_) == true)
               {
                  if(this.IsValidUnicode(_loc19_) == false)
                  {
                     if(_loc10_ != null)
                     {
                        _loc6_.push(_loc10_);
                        if(_loc11_ == _loc6_.length)
                        {
                           _loc16_++;
                        }
                     }
                  }
               }
               else if(this.IsValidChar(_loc18_) == true)
               {
                  if(this.IsValidChar(_loc18_) == false)
                  {
                     if(_loc10_ != null)
                     {
                        _loc6_.push(_loc10_);
                        if(_loc11_ == _loc6_.length)
                        {
                           _loc16_++;
                        }
                     }
                  }
               }
               _loc11_--;
            }
            _loc9_ = this.FTreeNode.GetNode(_loc5_);
            if(_loc9_ != null)
            {
               if(_loc9_.IsLeaf || _loc9_.IsOne)
               {
                  _loc7_[_loc3_] = 1;
               }
               _loc6_.push(_loc9_);
            }
            _loc3_++;
         }
         _loc8_ = param1.split("");
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(_loc7_[_loc3_] == 1)
            {
               _loc8_[_loc3_] = param2;
            }
            _loc3_++;
         }
         return _loc8_.join("");
      }
      
      protected function IsValidChar(param1:int) : Boolean
      {
         if(param1 >= 48 && param1 <= 57 || param1 >= 65 && param1 <= 90 || param1 >= 97 && param1 <= 122)
         {
            return true;
         }
         return false;
      }
      
      protected function IsValidUnicode(param1:int) : Boolean
      {
         if(param1 >= 19968 && param1 <= 40869)
         {
            return true;
         }
         return false;
      }
      
      public function AddKey(param1:String) : void
      {
         if(!TUtilityString.Empty(param1))
         {
            this.FWords.push(param1);
         }
      }
      
      public function Init() : void
      {
         if(!this.FIsInitialized)
         {
            this.SetSensitiveWordTree(this.FWords);
            this.FIsInitialized = true;
         }
      }
      
      public function Filter(param1:String) : String
      {
         var _loc2_:String = null;
         if(this.FIsInitialized)
         {
            _loc2_ = this.Replace(param1,"*");
         }
         else
         {
            _loc2_ = param1;
         }
         return _loc2_;
      }
   }
}

