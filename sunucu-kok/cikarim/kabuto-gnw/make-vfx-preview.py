"""Contact sheet of native Flash captures, not a simulated battle or FPS benchmark."""
from pathlib import Path
from PIL import Image, ImageDraw

BASE = Path(__file__).resolve().parent/'validation/vfx-v3'
NATIVE = BASE/'native'
SAMPLES = [
    ('MYSTERY-camp-0-frame-4.jpg','Mystery: cut-in'),
    ('MYSTERY-camp-0-frame-20.jpg','Mystery: white snakes / broken earth'),
    ('MYSTERY-camp-0-frame-26.jpg','Mystery: violet detonation'),
    ('MYSTERY-camp-1-frame-20.jpg','Mirrored enemy camp'),
    ('CASE-13120933-camp-0-cast.jpg','Chase: white serpent / red pearl'),
    ('CASE-13120934-camp-0-cast.jpg','Self healing: green aura'),
]
board = Image.new('RGB',(1250,1065),'#18231d')
for i,(name,label) in enumerate(SAMPLES):
    frame = Image.open(NATIVE/name).convert('RGB').resize((625,325),Image.Resampling.LANCZOS)
    x,y=i%2*625,i//2*355
    board.paste(frame,(x,y+30))
    ImageDraw.Draw(board).text((x+12,y+9),label,fill='white')
board.save(BASE/'native-overview.jpg',quality=94)
print('Saved native Flash phase contact sheet; component preview, not combat replay.')
