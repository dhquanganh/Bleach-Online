from pathlib import Path
import lzma,zlib,struct,io
from PIL import Image,ImageDraw
base=Path('sunucu-kok/cikarim/myoboku/native/scan');base.mkdir(exist_ok=True);found=[]
for folder in ['operatingActivity','activity']:
 for p in (Path('E:/Naruto_Online_Full_Resources/resources/flash')/folder).glob('*.swf'):
  try:
   r=p.read_bytes()
   if r[:8]==b'ZWS\0\xff\xff\xff\xff':
    a=r[8:19:2];r=bytes((a[i]&15)|((a[i+1]&15)<<4) for i in range(0,6,2))+r[9:19:2]+bytes(v^(255 if i&1 else 0) for i,v in enumerate(r[19:147]))+r[147:]
   if r[:3]==b'ZWS':
    prop=r[12];lc=prop%9;lp=prop//9%5;pb=prop//45;d=struct.unpack_from('<I',r,13)[0];body=lzma.LZMADecompressor(format=lzma.FORMAT_RAW,filters=[{'id':lzma.FILTER_LZMA1,'dict_size':d,'lc':lc,'lp':lp,'pb':pb}]).decompress(r[17:]);r=r[:8]+body
   elif r[:3]==b'CWS':r=r[:8]+zlib.decompress(r[8:])
   pos=8+(5+4*(r[8]>>3)+7)//8+4
   while pos+2<=len(r):
    h=struct.unpack_from('<H',r,pos)[0];pos+=2;kind=h>>6;n=h&63
    if n==63:n=struct.unpack_from('<I',r,pos)[0];pos+=4
    b=r[pos:pos+n];pos+=n
    if kind not in [21,35,90]:continue
    ident=struct.unpack_from('<H',b)[0]
    if kind==21:im=Image.open(io.BytesIO(b[2:])).convert('RGBA')
    else:
     size=struct.unpack_from('<I',b,2)[0];start=8 if kind==90 else 6;im=Image.open(io.BytesIO(b[start:start+size])).convert('RGBA')
     if b[start+size:]:im.putalpha(Image.frombytes('L',im.size,zlib.decompress(b[start+size:])))
    if im.width>=600 and im.height>=300:
     name=p.stem+'-'+str(ident)+'.png';im.save(base/name);found.append((name,im.size));
  except Exception as e:pass
print('backgrounds',len(found))
out=Image.new('RGB',(1200,((len(found)+5)//6)*150),'#444');dr=ImageDraw.Draw(out)
for i,(name,size) in enumerate(found):
 im=Image.open(base/name);im.thumbnail((195,120));x=i%6*200;y=i//6*150;out.paste(im,(x,y),im);dr.text((x,y+121),name[:27],fill='white')
out.save(base/'contact.png')
