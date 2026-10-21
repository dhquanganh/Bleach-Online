'use strict';
/*
 * YEREL OZEL SUNUCU kabugu.
 *
 * bleach.gogames.me.exe ile AYNI Flash 22 calisma zamanini (pepflashplayer.dll)
 * kullanir, ama oyunu KENDI ozel sunucumuzdan yukler:
 *     http://127.0.0.1:7420/     -> dosyalar (serve.mjs --ozel)
 *     127.0.0.1:10025            -> oyun soketi (sunucu/oyun-sunucu.js)
 *     127.0.0.1:843              -> Flash policy
 *     http://127.0.0.1:7421/     -> admin + karakter magazasi API (launcher.html katmani)
 *
 * main.js'ten TEK farki: canli siteye (www.plaync100.net) giden yakalama
 * proxy'si (proxy.js) YUKLENMEZ. Yani internete hic cikmaz, her sey yerelde.
 *
 * TAM EKRAN: pencere tam ekran acilir (F11 ile degisir, Esc cikar); launcher.html oyun
 * sahnesini (1250x650) pencereye SIGDIRIR (Ctrl+Shift+F: sigdir / orijinal boyut).
 */
const path = require('path');
const { app, BrowserWindow, Menu, shell } = require('electron');

const PORT = parseInt(process.env.YEREL_PORT || '7420', 10);
const START_URL = `http://127.0.0.1:${PORT}/`;
const UA = 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36';
const TAM_EKRAN = (process.env.BLEACH_TAMEKRAN || '1') !== '0';   // bat: set BLEACH_TAMEKRAN=0 -> pencereli

// --- Oyunun kendi 32-bit Pepper Flash eklentisi ---
const flashPath = path.join(__dirname, 'runtime', 'flashplayer', 'pepflashplayer.dll');
app.commandLine.appendSwitch('ppapi-flash-path', flashPath);
app.commandLine.appendSwitch('ppapi-flash-version', '22.0.0.209');
app.commandLine.appendSwitch('no-user-gesture-required');
app.commandLine.appendSwitch('disable-features', 'OutOfBlinkCors');
// Local game resources are versioned on disk; do not reuse Flash HTTP responses
// from an earlier server run. This leaves account cookies and saves untouched.
app.commandLine.appendSwitch('disable-http-cache');

let win;

function buildMenu() {
  Menu.setApplicationMenu(Menu.buildFromTemplate([
    { label: 'Oyun', submenu: [
      { label: 'Ana Sayfa', accelerator: 'Alt+Home', click: () => win && win.loadURL(START_URL, { userAgent: UA }) },
      { label: 'Yenile (yeniden giris)', accelerator: 'F5', click: (i, w) => w && w.webContents.reloadIgnoringCache() },
      { type: 'separator' },
      { label: 'Tam Ekran', accelerator: 'F11', click: (i, w) => w && w.setFullScreen(!w.isFullScreen()) },
      { label: 'Tam Ekrandan Cik', accelerator: 'Escape', click: (i, w) => { if (w && w.isFullScreen()) w.setFullScreen(false); } },
      { label: 'Sigdir / Orijinal Boyut', accelerator: 'CmdOrCtrl+Shift+F', click: (i, w) => w && w.webContents.executeJavaScript('try{sigdirDegistir()}catch(e){}') },
      { type: 'separator' },
      { label: 'Cikis', accelerator: 'CmdOrCtrl+Q', click: () => app.quit() },
    ] },
    { label: 'Gorunum', submenu: [
      { label: 'Yakinlastir', accelerator: 'CmdOrCtrl+=', click: (i, w) => { const z = w.webContents.getZoomFactor ? w.webContents.getZoomFactor() : 1; w.webContents.setZoomFactor((z || 1) + 0.1); } },
      { label: 'Uzaklastir', accelerator: 'CmdOrCtrl+-', click: (i, w) => { const z = w.webContents.getZoomFactor ? w.webContents.getZoomFactor() : 1; w.webContents.setZoomFactor(Math.max(0.3, (z || 1) - 0.1)); } },
      { label: 'Zoom Sifirla', accelerator: 'CmdOrCtrl+0', click: (i, w) => w.webContents.setZoomFactor(1) },
      { type: 'separator' },
      { label: 'Admin Paneli', click: () => win && win.loadURL(START_URL + 'admin', { userAgent: UA }) },
      { label: 'DevTools', accelerator: 'F12', click: (i, w) => w && w.webContents.toggleDevTools() },
    ] },
  ]));
}

function createWindow() {
  win = new BrowserWindow({
    width: 1280,
    height: 800,
    fullscreen: TAM_EKRAN,
    autoHideMenuBar: true,
    title: 'Bleach Online - OZEL SUNUCU (yerel)',
    backgroundColor: '#000000',
    webPreferences: {
      plugins: true,          // Pepper Flash
      nodeIntegration: false,
      webSecurity: false,     // eski oyunun gevsek yuklemeleri
      partition: 'persist:bleachyerel',  // canli oturum cerezlerinden AYRI
    },
  });

  win.webContents.setUserAgent(UA);
  win.webContents.on('new-window', (e, url) => {
    if (!url.startsWith(START_URL)) { e.preventDefault(); shell.openExternal(url); }
  });

  win.loadURL(START_URL, { userAgent: UA });
  win.on('closed', () => { win = null; });
}

app.on('ready', () => { buildMenu(); createWindow(); });
app.on('window-all-closed', () => app.quit());
app.on('activate', () => { if (!win) createWindow(); });
