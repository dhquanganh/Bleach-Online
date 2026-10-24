package {
 import flash.display.*;
 import flash.events.*;
 import flash.external.ExternalInterface;
 import flash.utils.*;
 public class TApplication extends Sprite {
  private var FCharacterTagRow:Sprite;
  private var FCharacterTagData:Object;
  private var FHint:Object = {Caption:""};
  private var FHintOnOver:Function;
  private var FHeros:Object;
  private var FTabHeroIndex:int = 0;
  private var captions:Array = [];
  private var heroes:Array = [{Identifier:11120930},{Identifier:11120940},{Identifier:11120970},{Identifier:11100001}];
  private var checked:int = 0;
  public function TApplication() {
   if(stage)run();else addEventListener(Event.ADDED_TO_STAGE,run);
  }
  private function check(ok:Boolean,label:String):void {if(!ok)throw new Error(label);checked++;}
  private function TFHintOnOut(event:Object):void {FHint.Caption="";}
  private function report(text:String):void {if(ExternalInterface.available)ExternalInterface.call("probe",text);}
  private function run(event:Event=null):void {
   try {
    var host:MovieClip = new MovieClip();addChild(host);
    var tab:Sprite = new Sprite();tab.graphics.beginFill(0x553322);tab.graphics.drawRect(0,0,68,22);tab.graphics.endFill();tab.x=172;tab.y=380;host["BtnPvP"]=tab;host.addChild(tab);
    FHintOnOver=function(owner:Object,hint:Object):void {captions.push(hint.Caption);};
    FHeros={Count:heroes.length,GetHeroByIndex:function(i:int):Object{return heroes[i];}};
    InitCharacterTags(host);
    check(FCharacterTagRow.parent==host,"profile header parent");
    check(FCharacterTagRow.x==244 && FCharacterTagRow.y==381,"tab-relative placement");
    RenderCharacterTags();
    check(FCharacterTagRow.numChildren==6,"Pain profile tags");
    var expected:Array=["Lightning","Male","Hidden Rain","Akatsuki","Blood Limit","Rinnegan"];
    for(var i:int=0;i<6;i++){
     var slot:Sprite=FCharacterTagRow.getChildAt(i) as Sprite;
     check(slot.name==expected[i],"Pain tag order");
     slot.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_MOVE));check(FHint.Caption==expected[i],"native hover handler");
     slot.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));check(FHint.Caption=="","native mouse out");
    }
    FTabHeroIndex=1;RenderCharacterTags();check(FCharacterTagRow.numChildren==9,"Hashirama switch");
    FTabHeroIndex=2;RenderCharacterTags();check(FCharacterTagRow.numChildren==11,"Sasuke switch");
    check(Math.abs(FCharacterTagRow.width-140)<0.01,"long row fits 140px");
    FTabHeroIndex=3;RenderCharacterTags();check(!FCharacterTagRow.visible && FCharacterTagRow.numChildren==0,"untagged hero clears");
    FHeros=null;RenderCharacterTags();check(!FCharacterTagRow.visible,"null profile safe");
    FHeros={Count:heroes.length,GetHeroByIndex:function(i:int):Object{return heroes[i];}};
    FTabHeroIndex=0;RenderCharacterTags();ClearProfileCharacterTags();check(!FCharacterTagRow.visible && FCharacterTagRow.numChildren==0,"reset clears row");
    RenderCharacterTags();
    setTimeout(finish,1500);
   }catch(error:Error){report("ERROR "+error+" "+error.getStackTrace());}
  }
  private function finish():void {
   try {
    for(var i:int=0;i<FCharacterTagRow.numChildren;i++){
     var icon:Loader=Sprite(FCharacterTagRow.getChildAt(i)).getChildAt(0) as Loader;
     check(icon.content!=null,"profile PNG loaded");
    }
    report("PASS "+checked+" profile tag checks: selection, names, hover/out, empty/null/reset, reopen, layout and PNG loads");
   }catch(error:Error){report("ERROR "+error+" "+error.getStackTrace());}
  }
       private function InitCharacterTags(host:Sprite) : void
      {
         FCharacterTagData = JSON.parse("{\"heroes\":{\"11120960\":[26,52,1,11,14,31,48],\"11120950\":[27,52,12],\"11120970\":[28,61,52,1,3,11,14,31,46,48,49],\"11120920\":[26,52,1,14,31,48],\"11120991\":[27,64,52,2,13,18,57],\"11120940\":[30,52,1,18,14,32,48,49,58],\"11120930\":[28,52,6,11,14,46],\"11120901\":[27,52,1,13,47,58],\"11120990\":[27,52,6,14,46,47]},\"tags\":{\"26\":{\"name\":\"Fire\",\"icon\":\"/public/character-tags/26.png\"},\"52\":{\"name\":\"Male\",\"icon\":\"/public/character-tags/52.png\"},\"1\":{\"name\":\"Konoha\",\"icon\":\"/public/character-tags/1.png\"},\"11\":{\"name\":\"Akatsuki\",\"icon\":\"/public/character-tags/11.png\"},\"14\":{\"name\":\"Blood Limit\",\"icon\":\"/public/character-tags/14.png\"},\"31\":{\"name\":\"Uchiha Clan\",\"icon\":\"/public/character-tags/31.png\"},\"48\":{\"name\":\"Secret Jutsu User\",\"icon\":\"/public/character-tags/48.png\"},\"27\":{\"name\":\"Wind\",\"icon\":\"/public/character-tags/27.png\"},\"12\":{\"name\":\"Confusion\",\"icon\":\"/public/character-tags/12.png\"},\"28\":{\"name\":\"Lightning\",\"icon\":\"/public/character-tags/28.png\"},\"61\":{\"name\":\"Sasuke Shinden\",\"icon\":\"/public/character-tags/61.png\"},\"3\":{\"name\":\"Hidden Sound\",\"icon\":\"/public/character-tags/3.png\"},\"46\":{\"name\":\"Rinnegan\",\"icon\":\"/public/character-tags/46.png\"},\"49\":{\"name\":\"Sword User\",\"icon\":\"/public/character-tags/49.png\"},\"64\":{\"name\":\"Swimsuit\",\"icon\":\"/public/character-tags/64.png\"},\"2\":{\"name\":\"Hidden Sand\",\"icon\":\"/public/character-tags/2.png\"},\"13\":{\"name\":\"Jinchuriki\",\"icon\":\"/public/character-tags/13.png\"},\"18\":{\"name\":\"Kage\",\"icon\":\"/public/character-tags/18.png\"},\"57\":{\"name\":\"Allied Shinobi Forces\",\"icon\":\"/public/character-tags/57.png\"},\"30\":{\"name\":\"Earth\",\"icon\":\"/public/character-tags/30.png\"},\"32\":{\"name\":\"Senju Clan\",\"icon\":\"/public/character-tags/32.png\"},\"58\":{\"name\":\"Senjutsu\",\"icon\":\"/public/character-tags/58.png\"},\"6\":{\"name\":\"Hidden Rain\",\"icon\":\"/public/character-tags/6.png\"},\"47\":{\"name\":\"Uzumaki Clan\",\"icon\":\"/public/character-tags/47.png\"}}}");
         FCharacterTagRow = new Sprite();
         FCharacterTagRow.name = "characterTags";
         var tab:DisplayObject = host["BtnPvP"];
         FCharacterTagRow.x = tab.x + tab.width + 4;
         FCharacterTagRow.y = tab.y + (tab.height - 20) / 2;
         host.addChild(FCharacterTagRow);
      }
      private function RenderCharacterTags() : void
      {
         if(FCharacterTagRow == null)return;
         this.TFHintOnOut(null);
         while(FCharacterTagRow.numChildren > 0)FCharacterTagRow.removeChildAt(0);
         var hero:Object = FHeros == null || FTabHeroIndex >= FHeros.Count ? null : FHeros.GetHeroByIndex(FTabHeroIndex);
         var ids:Array = hero == null ? null : FCharacterTagData.heroes[String(hero.Identifier)] as Array;
         FCharacterTagRow.visible = ids != null;
         if(!FCharacterTagRow.visible)return;
         var iconScale:Number = Math.min(1,7 / ids.length);
         for(var i:int = 0;i < ids.length;i++){
            AddCharacterTag(ids[i],i);
            var slot:Sprite = FCharacterTagRow.getChildAt(i) as Sprite;
            slot.scaleX = slot.scaleY = iconScale;
            slot.x = i * 20 * iconScale;
            slot.y = (20 - 20 * iconScale) / 2;
         }
      }
      private function AddCharacterTag(id:int,index:int) : void
      {
         var tag:Object = FCharacterTagData.tags[String(id)];
         if(tag == null)return;
         var slot:Sprite = new Sprite();
         slot.name = String(tag.name);
         slot.x = index * 20;
         slot.mouseChildren = false;
         slot.graphics.beginFill(0,0);
         slot.graphics.drawRect(0,0,20,20);
         slot.graphics.endFill();
         var icon:flash.display.Loader = new flash.display.Loader();
         icon.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,function(event:flash.events.Event):void {
            icon.width = 20;
            icon.height = 20;
         });
         icon.contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR,function(event:flash.events.IOErrorEvent):void {});
         icon.load(new flash.net.URLRequest(String(tag.icon)));
         slot.addChild(icon);
         slot.addEventListener(MouseEvent.MOUSE_MOVE,CharacterTagOnOver);
         slot.addEventListener(MouseEvent.MOUSE_OUT,this.TFHintOnOut);
         FCharacterTagRow.addChild(slot);
      }
      private function CharacterTagOnOver(event:MouseEvent) : void
      {
         FHint.Caption = Sprite(event.currentTarget).name;
         if(this.FHintOnOver != null)this.FHintOnOver(this,FHint);
      }
      private function ClearProfileCharacterTags() : void
      {
         if(FCharacterTagRow == null)return;
         this.TFHintOnOut(null);
         while(FCharacterTagRow.numChildren > 0)FCharacterTagRow.removeChildAt(0);
         FCharacterTagRow.visible = false;
      }
 }
}