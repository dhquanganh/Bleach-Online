package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import flash.utils.ByteArray;
   import ghostcat.util.data.*;
   
   use namespace ResourcesSpace;
   
   public class TConfigValue extends TDatebaseVO
   {
      
      protected static const TYPEVALUEINDEX_INT:uint = 0;
      
      protected static const TYPEVALUEINDEX_ARRAY:uint = 1;
      
      protected static const TYPEVALUEINDEX_ARRAYOBJECT:uint = 2;
      
      protected static const TYPEVALUEINDEX_OBJECT:uint = 3;
      
      protected static const TYPEVALUEINDEX_NUMBER:uint = 4;
      
      protected static const TYPEVALUE_INT:String = "int";
      
      protected static const TYPEVALUE_STRING:String = "String";
      
      protected static const TYPEVALUE_FLOAT:String = "float";
      
      protected static const ISCLIENT_STRING:String = "1";
      
      protected var FTypeValue:uint;
      
      protected var FDefineInt:uint;
      
      protected var FDefineNumber:Number;
      
      protected var FDefineVector:Vector.<uint>;
      
      protected var FDefineObjectVector:Vector.<Object>;
      
      protected var FDefineObject:Object;
      
      protected var FIsClient:Boolean;
      
      protected var FValue:String;
      
      protected var FValueType:String;
      
      public function TConfigValue()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         var _loc7_:Array = null;
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = TUtilityString.FetchUTF(param1);
         this.FIsClient = param1.readInt() != 0;
         if(!this.FIsClient)
         {
            return;
         }
         switch(_loc4_)
         {
            case TYPEVALUE_INT:
               this.FDefineInt = parseInt(_loc5_);
               this.FTypeValue = TYPEVALUEINDEX_INT;
               break;
            case TYPEVALUE_STRING:
               _loc6_ = Json.decode(_loc5_);
               if(_loc6_ is Array)
               {
                  _loc7_ = _loc6_ as Array;
                  _loc3_ = int(_loc7_.length);
                  _loc2_ = 0;
                  while(_loc2_ < _loc3_)
                  {
                     if(!(_loc7_[_loc2_] is int))
                     {
                        this.FTypeValue = TYPEVALUEINDEX_ARRAYOBJECT;
                        break;
                     }
                     _loc2_++;
                  }
                  switch(this.FTypeValue)
                  {
                     case TYPEVALUEINDEX_ARRAYOBJECT:
                        this.FDefineObjectVector = new Vector.<Object>(_loc3_);
                        _loc2_ = 0;
                        while(_loc2_ < _loc3_)
                        {
                           this.FDefineObjectVector[_loc2_] = _loc7_[_loc2_];
                           _loc2_++;
                        }
                        this.FTypeValue = TYPEVALUEINDEX_ARRAYOBJECT;
                        break;
                     default:
                        this.FDefineVector = new Vector.<uint>(_loc3_);
                        _loc2_ = 0;
                        while(_loc2_ < _loc3_)
                        {
                           this.FDefineVector[_loc2_] = _loc7_[_loc2_];
                           _loc2_++;
                        }
                        this.FTypeValue = TYPEVALUEINDEX_ARRAY;
                  }
               }
               else
               {
                  this.FDefineObject = _loc6_;
                  this.FTypeValue = TYPEVALUEINDEX_OBJECT;
               }
               break;
            case TYPEVALUE_FLOAT:
               this.FDefineNumber = parseFloat(_loc5_);
               this.FTypeValue = TYPEVALUEINDEX_NUMBER;
         }
      }
      
      public function get IsClient() : Boolean
      {
         return this.FIsClient;
      }
      
      public function get ValueType() : String
      {
         return this.FValueType;
      }
      
      public function get Value() : Object
      {
         switch(this.FTypeValue)
         {
            case TYPEVALUEINDEX_INT:
               return this.FDefineInt;
            case TYPEVALUEINDEX_ARRAY:
               return this.FDefineVector;
            case TYPEVALUEINDEX_ARRAYOBJECT:
               return this.FDefineObjectVector;
            case TYPEVALUEINDEX_OBJECT:
               return this.FDefineObject;
            case TYPEVALUEINDEX_NUMBER:
               return this.FDefineNumber;
            default:
               return null;
         }
      }
   }
}

