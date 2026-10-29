 function avatar(id,name){
  var box=document.createElement('span');box.style.cssText='display:inline-block;position:relative;width:44px;height:44px;flex-shrink:0;overflow:hidden;border:1px solid #665d4b;border-radius:6px;background:#252331;vertical-align:middle';
  var fallback=document.createElement('span');fallback.textContent=(name||'?').slice(0,1);fallback.style.cssText='display:block;text-align:center;line-height:44px;color:#f5cf79';box.appendChild(fallback);
  var img=document.createElement('img');img.alt='';img.loading='lazy';img.style.cssText='position:absolute;left:0;top:0;width:100%;height:200%;object-fit:cover;object-position:center top';
  img.onload=function(){img.style.height=img.naturalHeight>img.naturalWidth*1.5?'200%':'100%';};img.onerror=function(){img.remove();};img.src='/auth/admin/soul-palace/characters/'+id+'/avatar';box.appendChild(img);return box;
 }
 function characters(){
  if(!data)return;var select=el('palaceCharacter'),chosen=select.value,q=el('palaceSearch').value.toLowerCase(),list=el('palaceCharacterList');select.textContent='';list.textContent='';
  data.characters.filter(function(c){return c.name.toLowerCase().includes(q)||String(c.id).includes(q);}).slice(0,100).forEach(function(c){
   select.add(new Option(c.name+' · #'+c.id,c.id));var button=document.createElement('button');button.type='button';button.className='secondary';button.setAttribute('role','option');button.dataset.id=c.id;button.style.cssText='display:flex;align-items:center;gap:10px;text-align:left;margin:0;padding:8px;min-height:62px';
   button.appendChild(avatar(c.id,c.name));var label=document.createElement('span');label.textContent=c.name+' · #'+c.id+' · '+c.kind;button.appendChild(label);button.onclick=function(){select.value=String(c.id);highlight();};list.appendChild(button);
  });
  if(Array.from(select.options).some(function(o){return o.value===chosen;}))select.value=chosen;highlight();
  function highlight(){Array.from(list.children).forEach(function(b){var active=b.dataset.id===select.value;b.setAttribute('aria-selected',String(active));b.style.outline=active?'2px solid #f2c66c':'none';});}
 }
