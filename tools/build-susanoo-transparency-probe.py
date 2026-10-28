from pathlib import Path
R=Path(__file__).resolve().parents[1];B=R/'sunucu-kok/cikarim/madara-infinite';W=B/'susanoo-transparency'
s=(B/'build-probe.py').read_text()
s=s.replace('B=Path(__file__).resolve().parent;', 'B=Path(__file__).resolve().parent.parent;')
s=s.replace("W=B/'revival-repair' if '--repair' in sys.argv else B",'W=Path(__file__).resolve().parent')
start=s.index('names=[');end=s.index('\nfor _ in range(2):',start)
s=s[:start]+"names=['susanoo'];ids=[13122206];bounds=[0]"+s[end:]
s=s.replace('slot<28','slot<2').replace('slot>=28','slot>=2').replace('slot<14','slot<1').replace('slot%14','slot%1')
s=s.replace('Infinite / Yellow Flash Clone','Madara Susanoo transparency').replace('Infinite/Yellow Flash Clone','Madara Susanoo transparency')
s=s.replace('7512','7514').replace('7513','7515')
(W/'build-probe.py').write_text(s)
