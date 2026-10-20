import com.jpexs.decompiler.flash.SWF;
import com.jpexs.decompiler.flash.abc.*;
import com.jpexs.decompiler.flash.abc.types.*;
import com.jpexs.decompiler.flash.abc.types.traits.TraitMethodGetterSetter;
import com.jpexs.decompiler.flash.abc.avm2.parser.pcode.*;
import java.io.*;
import java.nio.file.*;
import java.util.*;
public class RemoveRoutes {
 static void clean(SWF swf,String cls,String method,boolean dump)throws Exception {
  var abc=swf.getAS3Packs().stream().filter(p->p.getClassPath().toString().equals(cls)).findFirst().orElseThrow().abc;
  MethodBody body=null;
  for(var instance:abc.instance_info)if(abc.constants.getString(abc.constants.getMultiname(instance.name_index).name_index).equals(cls.substring(cls.lastIndexOf('.')+1)))
   for(var trait:instance.instance_traits.traits)if(trait instanceof TraitMethodGetterSetter t&&abc.constants.getString(abc.constants.getMultiname(t.name_index).name_index).equals(method))body=abc.findBody(t.method_info);
  if(body==null)throw new IllegalStateException(method);
  String code=body.getCode().toASMSource(abc).replace("\r\n","\n").replaceAll("(?m)^ +","").replaceAll("getlocal([0-3])\\b","getlocal_$1");
  if(dump){Files.writeString(Path.of("sunucu-kok/cikarim/flash-battlefield/removed/"+cls.substring(cls.lastIndexOf('.')+1)+"-"+method+".txt"),code);return;}
  if(method.equals("ConstructProcessorsWindows"))code=code.replaceAll("getlocal_0\\ngetproperty [^\\n]+\\ngetlocal_0\\ngetproperty [^\\n]+\\n(?:setproperty|initproperty) [^\\n]+\\\"OnField(?:BattleStatus|InitBattle)\\\"[^\\n]*\\n","");
  if(method.equals("PacketRegisterRoutines"))code=code.replaceAll("getlocal_0\\ngetproperty [^\\n]+\\npushint 18410752\\npushint 18410756\\ngetlocal_0\\ngetproperty [^\\n]+\\ncallpropvoid [^\\n]+, 3\\n","");
  if(method.equals("ProcessorOnBattleReturn")){
   int begin=code.indexOf("getlocal_0\ngetproperty",code.indexOf("pushscope")+9);
   int active=code.indexOf("FieldBattleActive",begin);
   if(active<0)throw new IllegalStateException("No battle prefix");
   int branch=code.indexOf("iffalse ",active);String label=code.substring(branch+8,code.indexOf('\n',branch)).trim();
   int end=code.indexOf(label+":",branch)+label.length()+1;
   code=code.substring(0,begin)+code.substring(end);
   // The legacy type 199 branch is also custom to Battlefield.
   int type=code.indexOf("pushshort 199");
   if(type>=0){int start=code.lastIndexOf("getlocal_2",type);int jump=code.indexOf("ifne ",type);String target=code.substring(jump+5,code.indexOf('\n',jump)).trim();int finish=code.indexOf(target+":",jump)+target.length()+1;code=code.substring(0,start)+code.substring(finish);}
  }
  if(code.contains("FieldBattle")||code.contains("OnField")||code.contains("18410752"))throw new IllegalStateException("Remaining route: "+method);
  var exceptions=body.exceptions;if(exceptions.length!=0)throw new IllegalStateException("Unexpected exception table");
  int index=body.method_info,scope=body.init_scope_depth,maxScope=body.max_scope_depth,regs=body.max_regs,stack=body.max_stack;var traits=body.traits;
  MissingSymbolHandler missing=(MissingSymbolHandler)java.lang.reflect.Proxy.newProxyInstance(MissingSymbolHandler.class.getClassLoader(),new Class<?>[]{MissingSymbolHandler.class},(p,m,v)->true);
  body.setCode(ASM3Parser.parse(abc,new StringReader(code),null,missing,body,new MethodInfo()));
  body.method_info=index;body.init_scope_depth=scope;body.max_scope_depth=maxScope;body.max_regs=regs;body.max_stack=stack;body.traits=traits;body.exceptions=exceptions;body.setModified();
  ((com.jpexs.decompiler.flash.tags.Tag)abc.parentTag).setModified(true);
 }
 public static void main(String[] args)throws Exception{
  SWF swf=new SWF(new FileInputStream(args[0]),false);boolean dump=args.length<2;
  for(String method:new String[]{"ConstructProcessorsWindows","PacketRegisterRoutines","ProcessorOnBattleReturn"})clean(swf,"Processors.Game.Lobby.TProcessorLobby",method,dump);
  clean(swf,"Processors.Game.TProcessorGameRoot","PacketRegisterRoutines",dump);
  if(!dump)try(var out=new FileOutputStream(args[1])){swf.saveTo(out);}
 }
}
