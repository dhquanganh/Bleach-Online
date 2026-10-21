"""Make a review sheet from actual Flash captures of the previous/new clients."""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

BASE=Path(__file__).resolve().parent
before=BASE/'validation/compact-x2'
after=BASE/'validation/presentation-x2'
cases=[('Chidori',13121303,10),('Dragon Fire',13121305,28),('Kirin',13121301,95),('Susanoo',13121309,16)]
sheet=Image.new('RGB',(1250,4*355),'#151b20')
draw=ImageDraw.Draw(sheet)
font=ImageFont.truetype('C:/Windows/Fonts/arial.ttf',20)
for row,(name,skill,frame) in enumerate(cases):
 for column,(folder,label) in enumerate([(before,'TRƯỚC'),(after,'SAU')]):
  path=folder/f'CASE-{skill}-camp-0-frame-{frame}.jpg'
  with Image.open(path) as source:tile=source.resize((625,325),Image.Resampling.LANCZOS)
  x=column*625;y=row*355
  sheet.paste(tile,(x,y+30));draw.text((x+12,y+3),name+' — '+label,font=font,fill='white')
dest=BASE/'validation/presentation-before-after.jpg'
sheet.save(dest,quality=93)
print(dest)
