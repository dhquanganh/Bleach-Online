import com.jpexs.decompiler.flash.SWF;
import com.jpexs.decompiler.flash.timeline.Timelined;
import com.jpexs.decompiler.flash.types.RECT;
import com.jpexs.decompiler.flash.exporters.commonshape.Matrix;
import java.io.*;
import java.awt.Point;
import javax.imageio.ImageIO;
class RenderCamera {
 public static void main(String[] a)throws Exception{
  SWF swf=new SWF(new FileInputStream(a[0]),false);int id=Integer.parseInt(a[2]);
  var timeline=((Timelined)swf.getCharacter(id)).getTimeline();
  int camera=a.length>4?Integer.parseInt(a[4]):0;
  RECT rect=new RECT();rect.Xmin=(camera-625)*20;rect.Xmax=(camera+625)*20;rect.Ymin=-450*20;rect.Ymax=200*20;
  File dir=new File(a[1]);dir.mkdirs();int selected=a.length>3?Integer.parseInt(a[3]):-1;int first=selected>=0?selected:0;int last=selected>=0?first+1:timeline.getFrameCount();
  for(int frame=first;frame<last;frame++){
   File out=new File(dir,String.format("%d.png",frame+1));if(out.exists())continue;
   var image=SWF.frameToImageGet(timeline,frame,0,null,0,rect,new Matrix(),null,null,1.0,true,1);
   ImageIO.write(image.getBufferedImage(),"png",out);if(frame%30==0)System.out.println(id+":"+frame);
  }
 }
}

