"""Recompile the patched Reincarnation AS3 classes, verify assets, then optionally install."""
import argparse
import hashlib
import shutil
import struct
import subprocess
import zlib
from datetime import datetime
from pathlib import Path

BASE = Path(__file__).resolve().parent
CLIENT = BASE.parents[1] / 'kaynak/login.gogames.me/public/2026090619/TApplication.swf'
CLASSES = 'Logics.CityDefend.TCityDefendData,Logics.CityDefend.TCityDefendRank,Logics.Battle.model.TRoleBattleInfo,Logics.Streamization.Battle.TUnstreamizerRoleBattleInfo,Processors.Game.Battle.Character.TBaseRole,Processors.Game.Battle.TBattleStage,Logics.Streamization.CityDefend.TUnstreamizerCityDefend,Processors.Game.Lobby.CityDefend.TProcessorCityDefend,Processors.Game.Lobby.CityDefend.TProcessorWindowCityDefned,Processors.Game.Battle.TBattleHandle,Logics.CityDefend.TCityDefendReports,Processors.Game.Lobby.CityDefend.TProcessorWindowDoorHeroList,Processors.Game.Lobby.DailyActivity.TProcessorDailyActivity'

def swap(data):
    data = bytearray(data)
    for a, b in [(1, 10), (20, 200)]:
        data[a], data[b] = data[b], data[a]
    return bytes(data)

def tags(data):
    assert data[:3] == b'CWS'
    raw = data[:8] + zlib.decompress(data[8:])
    assert len(raw) == struct.unpack_from('<I', raw, 4)[0]
    bits = raw[8] >> 3
    pos = 8 + (5 + 4 * bits + 7) // 8 + 4
    result = []
    while pos < len(raw):
        head = struct.unpack_from('<H', raw, pos)[0]
        pos += 2
        kind, length = head >> 6, head & 63
        if length == 63:
            length = struct.unpack_from('<I', raw, pos)[0]
            pos += 4
        result.append((kind, raw[pos:pos + length]))
        pos += length
        if kind == 0:
            break
    assert pos == len(raw)
    return result

def main():
    args = argparse.ArgumentParser()
    args.add_argument('--ffdec', type=Path, required=True, help='Path to ffdec.jar')
    args.add_argument('--install', action='store_true')
    args.add_argument('--processor-only', action='store_true')
    args.add_argument('--partner-only', action='store_true')
    args.add_argument('--menu-only', action='store_true')
    args.add_argument('--window-only', action='store_true')
    args.add_argument('--tower-only', action='store_true')
    args.add_argument('--popup-only', action='store_true')
    args.add_argument('--baseline', type=Path)
    opts = args.parse_args()
    original = CLIENT.read_bytes()
    decoded = swap(opts.baseline.read_bytes() if opts.baseline else original)
    old_tags = tags(decoded)
    source, compiled = BASE / 'TApplication-decoded.swf', BASE / 'TApplication-compiled.swf'
    source.write_bytes(decoded)
    def ffdec(*args):
        completed = subprocess.run(['java', '-Xmx2g', '-jar', str(opts.ffdec), *map(str, args)], capture_output=True, text=True, errors='replace')
        if completed.returncode:
            raise RuntimeError(completed.stdout + completed.stderr)
    order=['Logics/CityDefend/TCityDefendData.as', 'Logics/CityDefend/TCityDefendRank.as', 'Logics/Battle/model/TRoleBattleInfo.as', 'Logics/Streamization/Battle/TUnstreamizerRoleBattleInfo.as', 'Processors/Game/Battle/Character/TBaseRole.as', 'Processors/Game/Battle/TBattleStage.as', 'Logics/Streamization/CityDefend/TUnstreamizerCityDefend.as', 'Processors/Game/Lobby/CityDefend/TProcessorCityDefend.as', 'Processors/Game/Lobby/CityDefend/TProcessorWindowCityDefned.as']
    if opts.processor_only: order=['Processors/Game/Lobby/CityDefend/TProcessorCityDefend.as','Processors/Game/Battle/TBattleHandle.as']
    previous = source
    for index, name in enumerate(order):
        phase = BASE / ('phase-' + str(index) + '-' + datetime.now().strftime('%Y%m%d-%H%M%S-%f'))
        target = phase / name
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(BASE / 'patched' / name, target)
        output = compiled if index == len(order)-1 else BASE / ('phase-' + str(index) + '.swf')
        print('Compiling', name, flush=True)
        ffdec('-onerror', 'abort', '-importScript', previous, output, phase)
        previous = output

    rebuilt = compiled.read_bytes()
    new_tags = tags(rebuilt)
    assert len(old_tags) == len(new_tags)
    assert [t for t in old_tags if t[0] != 82] == [t for t in new_tags if t[0] != 82], 'Non-code SWF assets changed'
    ffdec('-selectclass', CLASSES, '-export', 'script', BASE / 'verify', compiled)
    scripts = BASE / 'verify/scripts'
    processor=(scripts/'Processors/Game/Lobby/CityDefend/TProcessorCityDefend.as').read_text(encoding='utf-8')
    assert 'FDeferredHp' in processor and 'FDeferredEnd' in processor and 'FightPending = false' in processor
    assert 'STATUS_ORGACTIVITY_End' not in processor and 'this.FMainRole == null || !this.FIsArriveTarget' in processor
    door=(scripts/'Processors/Game/Lobby/CityDefend/TProcessorWindowDoorHeroList.as').read_text(encoding='utf-8')
    assert 'CanRequestFight' in door and 'FightReadyAt' in door
    assert 'this.FOnSetBattleStatus(this,CONST_BATTLE.BattleType_CityDefend,0)' not in door
    daily=(scripts/'Processors/Game/Lobby/DailyActivity/TProcessorDailyActivity.as').read_text(encoding='utf-8')
    assert 'TYPE_ORGACTIVITY_MUYEGUARD ? BtnStatus_Open : param2' in daily
    history=(scripts/'Processors/Game/Lobby/CityDefend/TProcessorWindowCityDefned.as').read_text(encoding='utf-8')
    assert 'PacketAcquire' in history and 'NavigateToBattleReportUrl' not in history
    battle=(scripts/'Processors/Game/Battle/TBattleHandle.as').read_text(encoding='utf-8')
    assert 'if(this.FEnterType == ENTER_TYPE_CITYDEFEND)' in battle
    method=processor[processor.index('protected function PacketPerform_SC_FightRet'):processor.index('protected function PacketPerform_SC_ReviveRet')]
    assert 'TBattleHandle.IsInBattle = true' not in method and 'FightPending = true' in method
    decode=battle[battle.index('protected function PacketPerform_SC_BattleStartReportData'):battle.index('protected function PacketPerform_SC_SingleBattleResult')]
    assert decode.index('FUnstreamizerBattleRepot.Unstreamize') < decode.index('TBattleHandle.IsInBattle = true') < decode.index('this.CheckResources()')
    role=(scripts/'Logics/Battle/model/TRoleBattleInfo.as').read_text(encoding='utf-8')
    assert 'get TotleHealth() : Number' in role
    unstream=(scripts/'Logics/Streamization/Battle/TUnstreamizerRoleBattleInfo.as').read_text(encoding='utf-8')
    assert 'readDouble()' in unstream and 'CurBattleDataVersion >= 4' in unstream
    assert 'BossMaxHp:Number = 9100002004' in processor and 'var hp:Number = _loc2_.readDouble()' in processor
    assert 'CityDoorCurHp,0)).toFixed(0)' in history
    protected = swap(rebuilt)
    assert swap(protected) == rebuilt
    output = BASE / 'TApplication-protected.swf'
    output.write_bytes(protected)
    digest = hashlib.sha256(protected).hexdigest()
    print('Verified compiled client; only AS3 bytecode changed. SHA256:', digest)
    if opts.install:
        assert CLIENT.read_bytes() == original, 'Client changed during compilation'
        backup = BASE / 'backups' / (datetime.now().strftime('%Y%m%d-%H%M%S-%f') + '-TApplication.swf.bak')
        backup.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(CLIENT, backup)
        CLIENT.write_bytes(protected)
        print('Installed:', CLIENT)
        print('Backup:', backup)

if __name__ == '__main__':
    main()
