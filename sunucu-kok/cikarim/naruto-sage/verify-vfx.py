"""Decode installed Flash effects and check alpha, registration and damage events."""
import io, json, struct, zlib
from PIL import Image
import vfx

def main():
    checked = 0
    for version in ['2017112917', '2026090619']:
        for effect in vfx.CONFIG['effects'].values():
            ident = effect['id']
            path = vfx.ROOT/'kaynak/login.gogames.me/public'/version/'Resources/Textures/Skill'/f'{ident:08X}.TexClient'
            data = path.read_bytes()
            resource, size = struct.unpack_from('<II', data)
            assert resource == ident
            sid, timing, count = struct.unpack_from('<IBH', data, 8)
            expected = vfx.frames(effect)
            assert (sid, timing, count) == (0, 1, len(expected))
            assert size == 7 + count * 14
            for i, (im, pivot) in enumerate(zip(expected, vfx.pivots(effect))):
                x, y, w, h, px, py, duration = struct.unpack_from('<hhhhhhH', data, 15+i*14)
                assert (w, h) == im.size and (px, py) == pivot
                assert duration == effect['duration']
            pos = 8 + size
            assert struct.unpack_from('<H', data, pos)[0] == 1
            length = struct.unpack_from('<I', data, pos+2)[0]
            pak = zlib.decompress(data[pos+6:pos+6+length])
            _, width, height, _, _, _, frames = struct.unpack_from('>BHHBBBH', pak)
            assert frames == count
            offset = 10+frames*8
            png_length = struct.unpack_from('>I', pak, offset)[0]
            atlas = Image.open(io.BytesIO(pak[offset+4:offset+4+png_length])).convert('RGB')
            assert atlas.size == (width, height*2)
            left = 0
            for im in expected:
                w, h = im.size
                decoded = atlas.crop((left, 0, left+w, h)).convert('RGBA')
                decoded.putalpha(atlas.crop((left, height, left+w, height+h)).getchannel('R'))
                assert decoded.tobytes() == im.tobytes(), 'Effect pixels/alpha corrupted'
                assert im.getchannel('A').getextrema()[0] == 0, 'Opaque effect background'
                left += w
                checked += 1
            assert left == width
            assert struct.unpack_from('<H', data, pos+6+length)[0] == 1
            assert pos+8+length == len(data)
    heroes = json.loads((vfx.ROOT/'cikarim/veri-json/BaseHero.json').read_text(encoding='utf-8'))
    for hero in heroes:
        if int(hero['id'], 16) not in [11120901,11120902]:
            continue
        attacks = json.loads(hero['attackEffect'])
        for skill, config in vfx.CONFIG['skills'].items():
            entries = attacks[skill]['appendEffect']
            charge = entries[str(config['chargeFrame'])]
            assert charge['target'] == 1 and 'anmyhp' not in charge
            assert int(charge['effectId']) == vfx.CONFIG['effects'][config['charge']]['id']
            total = 0
            for event in entries.values():
                if 'anmyhp' not in event:
                    continue
                assert event['target'] == 2
                assert int(event['effectId']) == vfx.CONFIG['effects'][config['impact']]['id']
                assert str(config['damageFrame']) in event['anmyhp']
                assert config['damageFrame'] < len(vfx.CONFIG['effects'][config['impact']]['frames'])
                total += sum(v for k,v in event['anmyhp'].items() if k != 'checkDie')
            assert total == 100
    print(f'PASS {checked} installed VFX frames: lossless alpha, registration, timing, caster/target binding and 100% damage.')

if __name__ == '__main__':
    main()
