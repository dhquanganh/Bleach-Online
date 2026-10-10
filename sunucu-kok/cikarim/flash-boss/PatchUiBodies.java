import com.jpexs.decompiler.flash.SWF;
import com.jpexs.decompiler.flash.abc.*;
import com.jpexs.decompiler.flash.abc.types.*;
import com.jpexs.decompiler.flash.abc.types.traits.TraitMethodGetterSetter;
import com.jpexs.decompiler.flash.abc.avm2.parser.pcode.ASM3Parser;
import com.jpexs.decompiler.flash.abc.avm2.parser.pcode.MissingSymbolHandler;
import java.io.*;
import java.nio.file.*;
import java.util.*;
public class PatchUiBodies {
 static final String CLASS="Processors.Game.Lobby.TProcessorLobby";
 static ABC abc(SWF swf){return swf.getAS3Packs().stream().filter(p->p.getClassPath().toString().equals(CLASS)).findFirst().orElseThrow().abc;}
 static List<Integer> functions(MethodBody body){List<Integer> out=new ArrayList<>();for(var op:body.getCode().code)if(op.definition.instructionName.equals("newfunction"))out.add(op.operands[0]);return out;}
 static MethodBody body(ABC abc,String name){
  for(var instance:abc.instance_info)if(abc.constants.getString(abc.constants.getMultiname(instance.name_index).name_index).equals("TProcessorLobby"))
   for(var trait:instance.instance_traits.traits)if(trait instanceof TraitMethodGetterSetter method && abc.constants.getString(abc.constants.getMultiname(trait.name_index).name_index).equals(name))return abc.findBody(method.method_info);
  return null;
 }
 public static void main(String[] args)throws Exception {
  SWF target=new SWF(new FileInputStream(args[0]),false),stub=new SWF(new FileInputStream(args[1]),false);
  ABC dst=abc(target),src=abc(stub);
  Map<Integer,byte[]> unchanged=new HashMap<>();
  for(var method:dst.bodies)unchanged.put(method.method_info,method.getCodeBytes().clone());
  String[] names={"IllusionText","IllusionBox","IllusionButton","IllusionConstruct","IllusionRow","IllusionRender","IllusionUpdate"};
  for(String name:names){
   MethodBody old=body(dst,name),fresh=body(src,name);
   if(old==null||fresh==null)throw new IllegalStateException("Missing method "+name);
   if(fresh.exceptions.length!=0)throw new IllegalStateException("Unexpected exception table "+name);
   List<Integer> oldFn=functions(old),newFn=functions(fresh);
   if(oldFn.size()!=newFn.size())throw new IllegalStateException("Closure count changed "+name);
   if(old.init_scope_depth!=fresh.init_scope_depth)throw new IllegalStateException("Scope depth differs "+name);
   int originalMethod=old.method_info,originalScope=old.init_scope_depth;
   var originalTraits=old.traits;
   var originalExceptions=old.exceptions;
   var signature=dst.method_info.get(originalMethod);
   int originalParameters=signature.param_types.length;
   int expectedParameters=switch(name){case "IllusionText","IllusionButton"->8;case "IllusionBox"->7;case "IllusionRow"->4;default->0;};
   if(originalParameters!=expectedParameters)throw new IllegalStateException("Corrupt baseline signature "+name+": "+originalParameters);
   String assembly=fresh.getCode().toASMSource(src).replace("\r\n","\n");
   for(int i=0;i<newFn.size();i++)assembly=assembly.replace("newfunction "+newFn.get(i)+"\n","newfunction "+oldFn.get(i)+"\n");
   MissingSymbolHandler missing=(MissingSymbolHandler)java.lang.reflect.Proxy.newProxyInstance(MissingSymbolHandler.class.getClassLoader(),new Class<?>[]{MissingSymbolHandler.class},(proxy,method,values)->true);
   // A code-only ASM stream has no signature directives. Never pass the live
   // MethodInfo: ASM3Parser clears its parameters and optional arguments.
   old.setCode(ASM3Parser.parse(dst,new StringReader(assembly),null,missing,old,new MethodInfo()));
   old.method_info=originalMethod;old.init_scope_depth=originalScope;
   old.traits=originalTraits;old.exceptions=originalExceptions;
   if(signature.param_types.length!=originalParameters)throw new IllegalStateException("Method signature changed "+name);
   if(!functions(old).equals(oldFn))throw new IllegalStateException("Closure remap failed "+name);
   // Scope depth is inherited from the existing application; preserve its offset.
   int extra=fresh.max_scope_depth-fresh.init_scope_depth;
   old.max_stack=fresh.max_stack;old.max_regs=fresh.max_regs;old.max_scope_depth=originalScope+extra;
   old.setModified();System.out.println("Replaced UI method: "+name);
   unchanged.remove(old.method_info);
  }
  for(var method:dst.bodies)if(unchanged.containsKey(method.method_info)&&!Arrays.equals(unchanged.get(method.method_info),method.getCodeBytes()))throw new IllegalStateException("Unrelated method changed: "+method.method_info);
  System.out.println("Verified unchanged method bodies: "+unchanged.size());
  ((com.jpexs.decompiler.flash.tags.Tag)dst.parentTag).setModified(true);
  try(var out=new FileOutputStream(args[2])){target.saveTo(out);}
 }
}
