package Foundation.SensitiveWord
{
   public class TTreeNode
   {
      
      protected var FData:Object;
      
      protected var FParent:TTreeNode;
      
      protected var FStr:String;
      
      protected var FIsLeaf:Boolean;
      
      protected var FIsOne:Boolean;
      
      protected var FMid:Boolean;
      
      protected var FIndex:int;
      
      public function TTreeNode()
      {
         super();
         this.FData = {};
         this.FIsLeaf = true;
      }
      
      public function get IsLeaf() : Boolean
      {
         return this.FIsLeaf;
      }
      
      public function set IsLeaf(param1:Boolean) : void
      {
         this.FIsLeaf = param1;
      }
      
      public function get Str() : String
      {
         return this.FStr;
      }
      
      public function set Str(param1:String) : void
      {
         this.FStr = param1;
      }
      
      public function get IsOne() : Boolean
      {
         return this.FIsOne;
      }
      
      public function set IsOne(param1:Boolean) : void
      {
         this.FIsOne = param1;
      }
      
      public function get Mid() : Boolean
      {
         return this.FMid;
      }
      
      public function set Mid(param1:Boolean) : void
      {
         this.FMid = param1;
      }
      
      public function get Parent() : TTreeNode
      {
         return this.FParent;
      }
      
      public function set Parent(param1:TTreeNode) : void
      {
         this.FParent = param1;
      }
      
      public function get Index() : int
      {
         return this.FIndex;
      }
      
      public function set Index(param1:int) : void
      {
         this.FIndex = param1;
      }
      
      public function GetNode(param1:String) : TTreeNode
      {
         return this.FData[param1];
      }
      
      public function SetNode(param1:String) : TTreeNode
      {
         var _loc2_:TTreeNode = null;
         _loc2_ = new TTreeNode();
         this.FData[param1] = _loc2_;
         _loc2_.Str = param1;
         _loc2_.Parent = this;
         return _loc2_;
      }
      
      public function GetSensitiveWord() : String
      {
         var _loc1_:String = null;
         var _loc2_:TTreeNode = null;
         _loc1_ = this.FStr;
         _loc2_ = this.FParent;
         while(_loc2_)
         {
            _loc1_ = _loc2_.Str + _loc1_;
            _loc2_ = _loc2_.Parent;
         }
         return _loc1_;
      }
   }
}

