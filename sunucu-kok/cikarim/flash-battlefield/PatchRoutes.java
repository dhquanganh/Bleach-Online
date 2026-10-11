import com.jpexs.decompiler.flash.SWF;
import com.jpexs.decompiler.flash.abc.*;
import com.jpexs.decompiler.flash.abc.types.*;
import com.jpexs.decompiler.flash.abc.types.traits.TraitMethodGetterSetter;
import com.jpexs.decompiler.flash.abc.avm2.parser.pcode.ASM3Parser;
import com.jpexs.decompiler.flash.abc.avm2.parser.pcode.MissingSymbolHandler;
import java.io.*;
import java.util.*;
public class PatchRoutes {
 static ABC abc(SWF swf,String cls){return swf.getAS3Packs().stream().filter(p->p.getClassPath().toString().equals(cls)).findFirst().orElseThrow().abc;}
 static MethodBody body(ABC abc,String cls,String name){
  for(var instance:abc.instance_info)if(abc.constants.getString(abc.constants.getMultiname(instance.name_index).name_index).equals(cls))
   for(var trait:instance.instance_traits.traits)if(trait instanceof TraitMethodGetterSetter method && abc.constants.getString(abc.constants.getMultiname(trait.name_index).name_index).equals(name))return abc.findBody(method.method_info);
  throw new IllegalStateException("Missing method "+cls+"."+name);
 }
 static String assembly(ABC abc,MethodBody b){return b.getCode().toASMSource(abc).replace("\r\n","\n");}
 static String symbol(ABC abc,MethodBody b,String name){
  for(String line:assembly(abc,b).split("\n")){
   int i=line.indexOf("QName(");
   if(i>=0 && line.contains(",\""+name+"\")"))return line.substring(i,line.indexOf(",\""+name+"\")")+name.length()+4);
  }
  throw new IllegalStateException("Missing symbol "+name);
 }
 static String pub(String name){return "QName(PackageNamespace(\"\"),\""+name+"\")";}
 static void patch(ABC abc,MethodBody b,String code)throws Exception{
  int index=b.method_info,scope=b.init_scope_depth,maxScope=b.max_scope_depth,regs=b.max_regs,stack=b.max_stack;
  var traits=b.traits;var exceptions=b.exceptions;
  if(exceptions.length!=0)throw new IllegalStateException("Cannot patch exception offsets");
  MissingSymbolHandler missing=(MissingSymbolHandler)java.lang.reflect.Proxy.newProxyInstance(MissingSymbolHandler.class.getClassLoader(),new Class<?>[]{MissingSymbolHandler.class},(p,m,v)->true);
  b.setCode(ASM3Parser.parse(abc,new StringReader(code),null,missing,b,new MethodInfo()));
  b.method_info=index;b.init_scope_depth=scope;b.max_scope_depth=maxScope;b.max_regs=regs;b.max_stack=Math.max(stack,6);b.traits=traits;b.exceptions=exceptions;
  b.setModified();((com.jpexs.decompiler.flash.tags.Tag)abc.parentTag).setModified(true);
 }
 static void patchEmptyModelTextures(SWF swf)throws Exception {
  ABC ui=abc(swf,"Processors.Game.Lobby.MainScene.Role.TUI");
  MethodBody update=body(ui,"TUI","UpdateModelTexture");String old=assembly(ui,update);
  if(old.contains(",\"Count\")"))return;
  Map<MethodBody,byte[]> unchanged=new IdentityHashMap<>();for(var b:ui.bodies)unchanged.put(b,b.getCodeBytes().clone());
  String texture=symbol(ui,update,"FTexture");int at=old.indexOf("initproperty "+texture);if(at<0)at=old.indexOf("setproperty "+texture);if(at<0)throw new IllegalStateException("Missing model texture assignment");at=old.indexOf('\n',at)+1;
  String guard="getlocal_0\ngetproperty "+texture+"\niffalse field_texture_wait\ngetlocal_0\ngetproperty "+texture+"\ngetproperty "+pub("Count")+"\npushbyte 0\nifgt field_texture_wait\ngetlocal_0\npushnull\nsetproperty "+texture+"\nfield_texture_wait:\n";
  patch(ui,update,old.substring(0,at)+guard+old.substring(at));
  for(var entry:unchanged.entrySet())if(entry.getKey()!=update&&!Arrays.equals(entry.getValue(),entry.getKey().getCodeBytes()))throw new IllegalStateException("Unrelated sprite code changed");
  System.out.println("Model sprites wait for nonempty texture sequences");
 }
 public static void main(String[] args)throws Exception{
  SWF swf=new SWF(new FileInputStream(args[0]),false);
  patchEmptyModelTextures(swf);
  ABC lobby=abc(swf,"Processors.Game.Lobby.TProcessorLobby");
  Map<MethodBody,byte[]> original=new IdentityHashMap<>();for(var b:lobby.bodies)original.put(b,b.getCodeBytes().clone());
  MethodBody construct=body(lobby,"TProcessorLobby","ConstructProcessorsWindows");
  MethodBody register=body(lobby,"TProcessorLobby","PacketRegisterRoutines");
  MethodBody back=body(lobby,"TProcessorLobby","ProcessorOnBattleReturn");
  ABC root=abc(swf,"Processors.Game.TProcessorGameRoot");MethodBody rr=body(root,"TProcessorGameRoot","PacketRegisterRoutines");
  if(assembly(lobby,construct).contains("OnFieldBattleStatus")){
   if(!assembly(lobby,register).contains("18410752") || !assembly(root,rr).contains("18410752") || !assembly(lobby,back).contains("FieldBattleReturn"))throw new IllegalStateException("Incomplete existing battlefield routes");
   String oldBack=assembly(lobby,back);
   if(!oldBack.contains("FieldBattleActive")){
    String field=symbol(lobby,construct,"FProcessorDailyActivity");
    String town=symbol(lobby,back,"ProcessorsOnReturnTown"),windows=symbol(lobby,back,"ProcessorWindowsSwitch");
    String route="getlocal_0\ngetproperty "+field+"\ngetproperty "+pub("FieldBattleActive")+"\niffalse field_video_original\n"+
      "getlocal_2\ngetlex QName(PackageNamespace(\"Resources.Constants\"),\"CONST_BATTLE\")\ngetproperty "+pub("BattleType_Replay")+"\nifne field_video_original\n"+
      "getlocal_0\ngetlocal_1\ncallpropvoid "+town+", 1\ngetlocal_0\ngetlocal_0\ngetproperty "+field+"\ncallpropvoid "+windows+", 1\n"+
      "getlocal_0\ngetproperty "+field+"\ncallpropvoid "+pub("FieldBattleReturn")+", 0\nreturnvoid\nfield_video_original:\n";
    int at=oldBack.indexOf("pushscope")+"pushscope".length();at=oldBack.indexOf('\n',at)+1;
    patch(lobby,back,oldBack.substring(0,at)+route+oldBack.substring(at));
    for(var entry:original.entrySet())if(entry.getKey()!=back&&!Arrays.equals(entry.getValue(),entry.getKey().getCodeBytes()))throw new IllegalStateException("Unrelated lobby code changed");
   }
   try(var out=new FileOutputStream(args[1])){swf.saveTo(out);}
   System.out.println("Battlefield routes installed, native replay return supported");return;
  }
  String field=symbol(lobby,construct,"FProcessorDailyActivity");
  MethodBody plates=body(lobby,"TProcessorLobby","ConstructProcessorsPlate");
  String status=symbol(lobby,plates,"ProcessorOnSetBattleStatus"),init=symbol(lobby,plates,"ProcessorLobbyOnInitBattle");
  String assign="getlocal_0\ngetproperty "+field+"\ngetlocal_0\ngetproperty "+status+"\nsetproperty "+pub("OnFieldBattleStatus")+"\n"+
    "getlocal_0\ngetproperty "+field+"\ngetlocal_0\ngetproperty "+init+"\nsetproperty "+pub("OnFieldInitBattle")+"\n";
  String old=assembly(lobby,construct);int end=old.lastIndexOf("returnvoid");patch(lobby,construct,old.substring(0,end)+assign+old.substring(end));
  String routines=symbol(lobby,register,"FPacketRoutines"),range=symbol(lobby,register,"RegisterRange"),route=symbol(lobby,register,"PacketPerform_ProcessorDailyActivity");
  String add="getlocal_0\ngetproperty "+routines+"\npushint 18410752\npushint 18410756\ngetlocal_0\ngetproperty "+route+"\ncallpropvoid "+range+", 3\n";
  old=assembly(lobby,register);end=old.lastIndexOf("returnvoid");patch(lobby,register,old.substring(0,end)+add+old.substring(end));
  String town=symbol(lobby,back,"ProcessorsOnReturnTown"),windows=symbol(lobby,back,"ProcessorWindowsSwitch");
  old=assembly(lobby,back);
  String branch="getlocal_0\ngetproperty "+field+"\ngetproperty "+pub("FieldBattleActive")+"\niffalse field_original\n"+
    "getlocal_2\ngetlex QName(PackageNamespace(\"Resources.Constants\"),\"CONST_BATTLE\")\ngetproperty "+pub("BattleType_Replay")+"\nifne field_original\ngetlocal_0\ngetlocal_1\ncallpropvoid "+town+", 1\n"+
    "getlocal_0\ngetlocal_0\ngetproperty "+field+"\ncallpropvoid "+windows+", 1\n"+
    "getlocal_0\ngetproperty "+field+"\ncallpropvoid "+pub("FieldBattleReturn")+", 0\nreturnvoid\nfield_original:\n";
  // Prefix after the method's initial pushscope so inherited protected names resolve normally.
  int at=old.indexOf("pushscope")+"pushscope".length();at=old.indexOf('\n',at)+1;
  patch(lobby,back,old.substring(0,at)+branch+old.substring(at));
  original.remove(construct);original.remove(register);original.remove(back);
  for(var e:original.entrySet())if(!Arrays.equals(e.getValue(),e.getKey().getCodeBytes()))throw new IllegalStateException("Unrelated lobby code changed");
  String rootRoutine=symbol(root,rr,"FPacketRoutines"),rootRange=symbol(root,rr,"RegisterRange"),rootRoute=symbol(root,rr,"PacketPerform_ProcessorLobby");
  old=assembly(root,rr);end=old.lastIndexOf("returnvoid");
  add="getlocal_0\ngetproperty "+rootRoutine+"\npushint 18410752\npushint 18410756\ngetlocal_0\ngetproperty "+rootRoute+"\ncallpropvoid "+rootRange+", 3\n";
  patch(root,rr,old.substring(0,end)+add+old.substring(end));
  try(var out=new FileOutputStream(args[1])){swf.saveTo(out);}
  System.out.println("Patched battlefield routes and return; unchanged lobby bodies: "+original.size());
 }
}
