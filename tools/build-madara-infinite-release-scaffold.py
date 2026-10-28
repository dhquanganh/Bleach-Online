from pathlib import Path
R=Path(__file__).resolve().parents[1];B=R/'sunucu-kok/cikarim/madara-infinite'
s=(B.parent/'minato-new-year/release.py').read_text().replace("VERSION='2026102804'","VERSION='2026102805'").replace("assert active=='2026102803'","assert active=='2026102804'").replace("probe['cases']==24","probe['cases']==28").replace("validation['unchangedMethods']['TRole']>=224","validation['unchangedMethods']['TRole']>=235").replace('11121003','11121005').replace('14131003','14131005').replace('14141003','14141005').replace('131221','131222').replace('13623101','13623201').replace('range(13122201,13122211)','range(13122201,13122213)').replace('11121005,11121004,','11121005,').replace("'summonId':11121004,",'').replace(",'cloneLifecycle':clone",'')
s='\n'.join(line for line in s.splitlines() if "clone=json.loads" not in line)+'\n'
(B/'release.py').write_text(s)
