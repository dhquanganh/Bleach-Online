"""Patch the current Tower panel without reverting later character/client work."""
from pathlib import Path
import argparse,runpy,subprocess
BASE=Path(__file__).resolve().parent
REL=Path('Processors/Game/Lobby/SkyTower/TProcessorSkyTower.as')
def main():
    parser=argparse.ArgumentParser();parser.add_argument('--ffdec',required=True);args=parser.parse_args()
    helper=runpy.run_path(str(BASE/'build.py'))
    source=BASE/'current.swf';source.write_bytes(helper['swap'](helper['CLIENT'].read_bytes()))
    subprocess.run(['java','-Xmx1g','-jar',args.ffdec,'-selectclass','Processors.Game.Lobby.SkyTower.TProcessorSkyTower','-export','script',str(BASE/'current'),str(source)],check=True)
    text=(BASE/'current/scripts'/REL).read_text(encoding='utf-8')
    assert 'GoldPrimogem' not in text,'Reward panel is already upgraded'
    def rep(a,b):
        nonlocal text
        assert a in text,a
        text=text.replace(a,b)
    rep('      protected var GoldCrystal:TUISlot;','      protected var GoldCrystal:TUISlot;\n      protected var GoldPrimogem:TUISlot;\n      protected var GoldPrimogemRoot:MovieClip;')
    rep('slot.y = 360;','slot.y = 366;')
    rep('crystal.x = 281;','crystal.x = 229;')
    rep('crystal.y = 360;','crystal.y = 366;')
    start=text.index('         var crystal:MovieClip = new MovieClip();')
    end=text.index('         this.GoldButton = new Sprite();',start)
    primogem=text[start:end].replace('crystal','primogem').replace('GoldCrystal','GoldPrimogem').replace('primogem.x = 229;','primogem.x = 420;')
    primogem+='         this.GoldPrimogemRoot=primogem;\n'
    rep('         this.GoldButton = new Sprite();',primogem+'         this.GoldButton = new Sprite();')
    rep('            this.GoldCrystal.Update();','            this.GoldCrystal.Update();\n            this.GoldPrimogem.Update();')
    rep('            EffectGenerateTextByErrorCode(error);','            if(p.Data.bytesAvailable>0)EffectGenerateText(p.Data.readUTF());else EffectGenerateTextByErrorCode(error);')
    rep('      protected function RenderGoldPanel() : void','''      protected function GoldRewardAmount(item:Object,code:uint,type:int=1) : Number
      {
         if(item == null || item.rewards == null) return 0;
         for each(var reward:Object in item.rewards)
            if(uint(reward.code)==code && int(reward.type)==type) return Number(reward.amount);
         return 0;
      }

      protected function RenderGoldPanel() : void''')
    rep('this.GoldBox(this.GoldContent,28,338,590,72,2629659);','this.GoldBox(this.GoldContent,28,338,590,86,2629659);')
    rep('         this.GoldHero.Context = uint(current.heroId);','''         this.GoldText(this.GoldContent,"ATK: "+String(current.atk),176,124,430,13,0xFFAE82).height=20;
         this.GoldHero.Context = uint(current.heroId);''')
    start=text.index('         var inv:TInventories = new TInventories();',text.index('protected function RenderGoldPanel'))
    end=text.index('         var i:int = 0;',start)
    text=text[:start]+'''         var stoneAmount:Number=this.GoldRewardAmount(current,14100698);
         var crystalAmount:Number=this.GoldRewardAmount(current,14100779);
         var primogemAmount:Number=this.GoldRewardAmount(current,14900001);
         var inv:TInventories = new TInventories();
         SToolReward.GetInventoryByIDAmount(14100698,stoneAmount,inv);
         this.GoldDrop.Context=inv.GetInventoryByIndex(0);
         this.GoldText(this.GoldContent,"x"+stoneAmount+"\\nReincarnation Stone",94,366,126,12,0xF2D193);
         var crystals:TInventories = new TInventories();
         SToolReward.GetInventoryByIDAmount(14100779,crystalAmount,crystals);
         this.GoldCrystal.Context=crystals.GetInventoryByIndex(0);
         this.GoldText(this.GoldContent,"x"+crystalAmount+"\\nBlood War Crystal",285,366,125,12,0xF2D193);
         this.GoldPrimogemRoot.visible=primogemAmount>0;
         if(primogemAmount>0)
         {
            var primogems:TInventories=new TInventories();
            SToolReward.GetInventoryByIDAmount(14900001,primogemAmount,primogems);
            this.GoldPrimogem.Context=primogems.GetInventoryByIndex(0);
            this.GoldText(this.GoldContent,"x"+primogemAmount+"\\nNguyên thạch",476,366,138,13,0xD9C0FF);
         }
         else this.GoldText(this.GoldContent,"Nguyên thạch:\\nTừ tầng 100",426,366,180,13,0xA99AAE);
         this.GoldText(this.GoldContent,this.GoldRewardAmount(current,1,0)+" Gold",450,342,164,13,0xFFD766).height=20;
'''+text[end:]
    rep('this.GoldText(this.GoldContent,String(item.name),669,115 + i * 77,147,12,13026231);','''this.GoldText(this.GoldContent,String(item.name),669,111 + i * 77,147,11,13026231).height=18;
            var upcoming:Number=this.GoldRewardAmount(item,14900001);
            this.GoldText(this.GoldContent,upcoming>0?"Nguyên thạch x"+upcoming:"Nguyên thạch: tầng 100",669,132+i*77,147,10,0xD9C0FF).height=17;''')
    dest=BASE/'patched'/REL;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(text,encoding='utf-8')
    print('PASS prepared live Tower panel: authoritative ATK, 3 reward slots, floor-100 unlock and upcoming rewards')
if __name__=='__main__':main()
