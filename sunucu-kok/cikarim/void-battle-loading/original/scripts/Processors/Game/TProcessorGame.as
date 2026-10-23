package Processors.Game
{
   import Debugging.*;
   import Foundation.Common.*;
   import Foundation.Common.Stubs.*;
   import Foundation.Network.*;
   import Foundation.Network.Spaces.*;
   import Foundation.Registries.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Affairs.*;
   import Processors.*;
   import Processors.Spaces.*;
   
   use namespace ProcessorSpace;
   use namespace NetworkSpace;
   
   public class TProcessorGame extends TProcessor
   {
      
      protected static const AFFAIRID_TimingDelay:uint = 0;
      
      ProcessorSpace var FPacketBindingsAffair:Vector.<TAffair>;
      
      ProcessorSpace var FPacketBindingsPacket:Vector.<TPacket>;
      
      protected var FAffairs:TEntityList;
      
      protected var FAffairGenerator:TAffairGenerator;
      
      protected var FAffairRoutines:TRegistryRoutine;
      
      protected var FPacketRoutines:TRegistryRoutineRange;
      
      protected var FIsResourcesLoadCompleted:Boolean;
      
      public function TProcessorGame(param1:TUIComponent)
      {
         super(param1);
         this.FPacketBindingsAffair = new Vector.<TAffair>();
         this.FPacketBindingsPacket = new Vector.<TPacket>();
         this.FAffairs = new TEntityList();
         this.FAffairRoutines = new TRegistryRoutine();
         this.AffairConstructGenerator();
         this.AffairRegisterRoutines();
         this.FPacketRoutines = new TRegistryRoutineRange();
         this.PacketRegisterRoutines();
         this.FIsResourcesLoadCompleted = false;
         FResourcesState = RESOURCESSTATE_Ready;
      }
      
      override protected function LogicsPerform() : void
      {
         this.LogicsPerform_Affairs();
      }
      
      protected function LogicsPerform_Affairs() : void
      {
         var _loc1_:TAffair = null;
         while(this.FAffairs.Count != 0)
         {
            _loc1_ = this.FAffairs.GetEntityByIndex(0) as TAffair;
            this.AffairPerform(_loc1_);
            switch(_loc1_.PostProcess)
            {
               case TAffair.POSTPROCESS_Remove:
                  this.FAffairs.Delete(0);
                  this.FAffairGenerator.Dispose(_loc1_);
                  break;
               case TAffair.POSTPROCESS_Pend:
                  return;
            }
         }
      }
      
      protected function AffairConstructGenerator() : void
      {
         this.FAffairGenerator = new TAffairGenerator(this.FAffairs);
      }
      
      protected function AffairRegisterRoutines() : void
      {
         this.FAffairRoutines.Register(AFFAIRID_TimingDelay,this.AffairPerform_TimingDelay);
      }
      
      protected function AffairPerform(param1:TAffair) : void
      {
         var _loc2_:Function = null;
         _loc2_ = this.FAffairRoutines.GetRoutineByIndentifier(param1.Identifier);
         if(_loc2_ != null)
         {
            _loc2_(param1);
         }
      }
      
      protected function AffairPerform_TimingDelay(param1:TAffair) : void
      {
         var _loc2_:TAffairDelay = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc2_ = param1 as TAffairDelay;
         _loc3_ = int(STimingCore.TickCount);
         _loc4_ = _loc2_.ReferenceTick;
         if(_loc4_ == 0)
         {
            _loc4_ = _loc3_;
            _loc2_.ReferenceTick = _loc3_;
         }
         if(_loc3_ >= _loc4_ + _loc2_.DelayTicks)
         {
            param1.PostProcess = TAffair.POSTPROCESS_Remove;
         }
         else
         {
            param1.PostProcess = TAffair.POSTPROCESS_Pend;
         }
      }
      
      protected function PacketRegisterRoutines() : void
      {
      }
      
      protected function PacketBindByAffair(param1:TPacket, param2:TAffair) : void
      {
         param1.StubReferences.Reference(param2);
         this.FPacketBindingsAffair.push(param2);
         this.FPacketBindingsPacket.push(param1);
      }
      
      protected function PacketUnbindByAffair(param1:TAffair) : TPacket
      {
         var _loc2_:int = 0;
         var _loc3_:TPacket = null;
         _loc2_ = this.FPacketBindingsAffair.indexOf(param1);
         if(_loc2_ >= 0)
         {
            _loc3_ = this.FPacketBindingsPacket[_loc2_];
            _loc3_.StubReferences.Dereference(param1);
            return _loc3_;
         }
         return null;
      }
      
      protected function PacketPerform(param1:TPacket) : void
      {
         var _loc2_:Function = null;
         _loc2_ = this.FPacketRoutines.GetRoutineByIndentifier(param1.Identifier);
         if(_loc2_ != null)
         {
            _loc2_(param1);
         }
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FIsResourcesLoadCompleted = true;
         super.ResourcesPerform_UILocations();
      }
      
      override public function UnLoad() : void
      {
         super.UnLoad();
         this.FIsResourcesLoadCompleted = false;
      }
      
      public function PacketProcess(param1:TPacket) : void
      {
         var _loc2_:TStubReferences = null;
         _loc2_ = param1.StubReferences;
         _loc2_.Reference(this);
         this.PacketPerform(param1);
         _loc2_.Dereference(this);
      }
   }
}

