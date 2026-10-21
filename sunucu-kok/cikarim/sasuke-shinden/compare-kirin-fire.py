"""Before/after captures from the original and corrected Flash VFX methods."""
from pathlib import Path
from PIL import Image,ImageDraw,ImageFont
BASE=Path(__file__).resolve().parent
cases=[('Kirin',13121301,80),('Kirin Blaze',13121302,86),('Dragon Fire',13121305,28),('Dragon Fire Blaze',13121306,41)]
sheet=Image.new('RGB',(1250,355*len(cases)),'#131b20');draw=ImageDraw.Draw(sheet)
font=ImageFont.truetype('C:/Windows/Fonts/arial.ttf',20)
for row,(label,skill,frame) in enumerate(cases):
 for col,(folder,title) in enumerate([('kirin-before-x2','TRƯỚC'),('kirin-fire-x2','SAU')]):
  with Image.open(BASE/'validation'/folder/f'CASE-{skill}-camp-0-frame-{frame}.jpg') as source:
   sheet.paste(source.resize((625,325),Image.Resampling.LANCZOS),(625*col,355*row+30))
  draw.text((625*col+12,355*row+3),label+' — '+title,font=font,fill='white')
dest=BASE/'validation/kirin-fire-before-after.jpg';sheet.save(dest,quality=93);print(dest)
