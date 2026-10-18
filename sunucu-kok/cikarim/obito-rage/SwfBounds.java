import com.jpexs.decompiler.flash.SWF;
import com.jpexs.decompiler.flash.tags.base.BoundedTag;
import com.jpexs.decompiler.flash.types.RECT;
import java.io.FileInputStream;

/** Obtain the exact camera origin used by FFDec's sprite PNG exporter. */
class SwfBounds {
    public static void main(String[] args) throws Exception {
        SWF swf = new SWF(new FileInputStream(args[0]), false);
        for (int i = 1; i < args.length; i++) {
            int id = Integer.parseInt(args[i]);
            RECT rect = ((BoundedTag)swf.getCharacter(id)).getRectWithFilters();
            System.out.println(id + "," + rect.Xmin + "," + rect.Ymin + "," + rect.Xmax + "," + rect.Ymax);
        }
    }
}
