import com.jpexs.decompiler.flash.SWF;
import java.io.*;
import java.util.*;
public class PatchRankingText {
 public static void main(String[] args)throws Exception {
  SWF swf=new SWF(new FileInputStream(args[0]),false);
  var abc=swf.getAS3Packs().stream().filter(p->p.getClassPath().toString().equals("Processors.Game.Lobby.TProcessorLobby")).findFirst().orElseThrow().abc;
  var before=new ArrayList<byte[]>();for(var b:abc.bodies)before.add(b.getCodeBytes().clone());
  int count=0;
  for(int i=1;i<abc.constants.getStringCount();i++)if(abc.constants.getString(i).contains("Bot đánh mỗi 5 phút")){
   abc.constants.setString(i,"BXH người chơi thật. Lưu lượt sát thương cao nhất. Trao thưởng và reset lúc 00:00 UTC+7.");count++;
  }
  if(count!=1)throw new IllegalStateException("Expected exactly one ranking status, got "+count);
  for(int i=0;i<before.size();i++)if(!Arrays.equals(before.get(i),abc.bodies.get(i).getCodeBytes()))throw new IllegalStateException("Changed method body");
  ((com.jpexs.decompiler.flash.tags.Tag)abc.parentTag).setModified(true);
  try(var out=new FileOutputStream(args[1])){swf.saveTo(out);}
  System.out.println("PASS real-player ranking status; all method bodies unchanged");
 }
}
