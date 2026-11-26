# Rainbead apps

Games, apps and themes for **Rainbead**, the desktop in the browser: each app a **Dotbead**, a single `.bead` file you
install in a few seconds, each theme a folder — and an example to learn from.

| | App | What it is |
|---|---|---|
| 🃏 | [`games/solitaire.bead`](games/solitaire.bead) | **Solitaire** (Klondike): drag or tap, undo, draw one or three, finishes by itself when every card is face up, best scores by time and by moves |
| 💣 | [`games/mines.bead`](games/mines.bead) | **Loose Mine** («Mina Vagante»): find the mines under the meadow — three levels, a safe first square, flags by right click or long press, best times per level |
| 🎨 | [`apps/paint.bead`](apps/paint.bead) | **Paint** («Disegno»): pencil, brush, eraser, lines, rectangles, ellipses, fill and colour picker, with undo; opens your pictures and saves them in your files — the example of `bead.files` |
| 🕓 | [`apps/clock.bead`](apps/clock.bead) | **Clock** («Orologio»): a clock for the desktop, with hands or with digits — a click changes the face, each clock remembers its own. An app made **only of widgets**, and the example of them |
| 📝 | [`apps/notes.bead`](apps/notes.bead) | **Notes**: a tiny list of notes, and the smallest complete example of the format (menu, shortcuts, an asset, a data migration) |

Every app speaks English and Italian, follows the light and dark themes of the desktop, and works on phones too.

| | Theme | What it is |
|---|---|---|
| 🌐 | [`themes/universe/`](themes/universe/) | **Universe**: white and silver, icons as channel tiles that light up sky blue, round pill buttons, a soft round bar; charcoal by night. Commented line by line: the example of how a theme is made ([the guide](themes/README.md)) |

## Install one

1. Download the `.bead` file (open it on GitHub, then *Download raw file*).
2. In Rainbead open **Applications › Add an app** and drop the file on *Upload a .bead file*.
3. It appears on the desktop and in the Start menu. To update it later, upload a newer version: its data are kept.
   An app made only of widgets (Clock) is not on the desktop: add it with a right click on the desktop › *Add a widget…*.

## What an app can reach

A `.bead` app runs closed in its window: it can't reach the internet, other apps or your messages. It keeps its own
data, encrypted on the server like everything else in Rainbead.

Your files stay closed to it too, except the ones you give it yourself: a file you choose in Rainbead's own Open
window, one you open with the app from **Files › Open with…**, or one you save in Rainbead's Save as window. Those
windows belong to Rainbead, not to the app, so the app can't choose for you or look around. Paint, for instance,
sees only the pictures you open in it and the drawings you save.

## Install a theme

Zip the theme's folder (`themes/universe/` → a `.zip` holding `universe/manifest.json`, `universe/theme.css`…), then
in Rainbead **Administration › Themes › Upload**, turn it on, and choose it in **Settings › Appearance › Theme**.
Universe already comes with Rainbead: this copy is here to be read and copied. How a theme is made:
[themes/README.md](themes/README.md).

## On phones

All of them are made to be played and used with a finger:

- **Solitaire**: a tap sends a card where it fits (the double click of the mouse); cards are dragged with a short
  slack so that taps stay taps; the cards shrink with the screen, down to a 360 px wide phone.
- **Loose Mine**: a tap uncovers a square, a long press (or the 🚩 button, which turns taps into flags) marks a mine;
  squares never get smaller than 26 px; the expert level (30 × 16) scrolls sideways on a narrow screen.
- **Paint**: draw with a finger or a pen; the tools are one row that scrolls sideways, the picture takes the rest
  of the screen.
- **Notes**: one column; the field stays at the top, above the keyboard.

The general rules for phones are in the guide below, under *Phones and tablets*.

## Make your own

The whole format follows: the same guide Rainbead gives in *Applications › Add an app*. Pull requests with new
apps are welcome — one `.bead` file per app, in `games/` or `apps/`, with English and Italian texts.

---

# The .bead format

**Rainbead** is a desktop that runs in the browser. A Rainbead app is **one XML file** with the extension `.bead`:
its texts, icon, menu, style, HTML and JavaScript all live in that file. The user uploads it in
*Applications › Add an app*; from then on it has its own icon and window, and the same bar as every other app of
the desktop: ☰ with its menu, its title, its buttons, ⚙.

This guide is complete: an app written by following it, part by part, works the first time. It describes the
format, what an app can do, the `bead` object it talks to the desktop with, the rules for phones, a complete
example and a checklist.

## What an app can and cannot do

The app runs in a sandboxed window: a page with no cookies, no network and no access to the site.

- **It can**
  - draw its interface with HTML, CSS and plain JavaScript (no build step, no frameworks, no modules);
  - keep **one JSON document** per user, saved encrypted on the server (`bead.data`);
  - **open, read and save the user's files — only those the user chooses for it** in Rainbead's own Open and
    Save as windows, or opens with it from Files (`bead.files`, see *Files* below);
  - show toasts and confirmations, set its title, fill ☰ and the bar of its window, open another window of itself;
  - ask its own question before its window closes, with OK and Cancel (`bead.ui.confirmClose(text)`: Paint asks it
    when the drawing has unsaved changes);
  - use its own pictures, sounds and fonts (assets) and texts (translations);
  - follow the desktop's theme, light and dark.
- **It cannot**
  - reach the network: `fetch`, `XMLHttpRequest`, WebSocket, WebRTC, external scripts, fonts or images are all
    blocked;
  - read cookies or the storage of the site: `localStorage`, `sessionStorage` and IndexedDB are not available
    (use `bead.data`);
  - open popups or leave its page (loading another page stops the app);
  - see any file the user did not give it, other apps, messages, or anything else of the user.

## The file

```xml
<?xml version="1.0" encoding="UTF-8"?>
<bead-app id="it.yourname.appname" version="1.0.0" author="Your name">
  <translations>
    <lang code="en" default="true"><![CDATA[{ "name": "…", "description": "…", "info": "…", "…": "…" }]]></lang>
    <lang code="it"><![CDATA[{ "name": "…", "description": "…" }]]></lang>
  </translations>
  <icon><![CDATA[<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48">…</svg>]]></icon>
  <window width="640" height="480"/>
  <opens types=".png .jpg image/png image/jpeg"/>
  <menu>
    <menu label="file">
      <item label="new" action="new" icon="new"/>
      <item label="open" action="open" shortcut="Ctrl+O" icon="open"/>
      <separator/>
      <item label="newWindow" action="" target="window" icon="new-window"/>
    </menu>
    <menu label="edit" icon="edit">
      <item label="clear" action="clear"/>
    </menu>
  </menu>
  <bar>
    <item label="save" action="save" icon="save" primary="true"/>
  </bar>
  <style><![CDATA[ /* CSS */ ]]></style>
  <body><![CDATA[ <!-- HTML that goes inside <body> --> ]]></body>
  <script><![CDATA[ // JavaScript, run after the body ]]></script>
  <widget kind="today" label="todayName" description="todayAbout" width="220" height="160"/>
  <asset name="logo.svg" type="image/svg+xml"><![CDATA[<svg …>…</svg>]]></asset>
  <asset name="beep.mp3" type="audio/mpeg" encoding="base64">SUQz…</asset>
  <migrate from="1.0.0"><![CDATA[ (data) => ({ ...data, items: data.items ?? [] }) ]]></migrate>
</bead-app>
```

The parts, in any order inside `<bead-app>`:

| Part | Required | What it is |
|---|---|---|
| `id` | yes | Reverse domain, lowercase letters and digits: `it.mario.pomodoro`. It identifies the app forever: keep it the same in every version. |
| `version` | yes | `major.minor.patch`, numbers only (`1.0.0`). To update an installed app, upload a **higher** version: its data are kept. The same version is refused. |
| `author` | no | Shown in the details of the app. |
| `kind` | no | `app` (the default) or `widget`: an app made only of widgets, not on the desktop nor in the Start menu (see *Widgets*). |
| `<translations>` | yes | One `<lang code="xx">` per language, each a JSON object of texts. One has `default="true"`: it is used when a text is missing in the user's language. Keys **`name`** and **`description`** are required; **`info`** is the longer text of the details and of the "About" box (`\n` for new lines). Every other key is yours: menu labels, buttons, messages. At least `en`; `it` is welcome. |
| `<icon>` | yes | One inline **SVG**, square `viewBox` (48×48 works well), up to 64 KB. Colourful, glossy, simple; readable at 24 px. |
| `<window>` | no | Starting size in pixels: width 240–1600, height 160–1200 (default 640×480). |
| `<opens>` | no | The files the app can open from Files, in `types`, separated by spaces: extensions (`.png`) and types (`image/png`, `image/*`). The app is then offered in **Files › Open with…** for those files (a double click keeps opening them with the desktop's own app). See *Files*. |
| `<menu>` | no | What ☰ shows (see *The bar*): `<menu label="…">` holding `<item>` and `<separator/>`. The items of the **first** menu are the first level of ☰; each **other** menu is one entry of the first level (with its `icon`) that opens its items. `label` attributes are **translation keys**. An `<item>` has an `action` (a word your script receives), an optional `shortcut` (`F2`, `Ctrl+Z`, `Ctrl+Shift+S`…), an optional `icon` (shown on the first level only), and `target="window"` to run the action in a **new window** of the app (which receives it as `bead.launch.action`). Up to 8 menus of 30 items. |
| `<bar>` | no | Buttons of the window's bar, right of the title: up to 6 `<item>` like those of a menu, plus `primary="true"` for the main one (at most one: Save, Send…). Each has an `icon`: the bar shows the words on a computer and the icon on a phone. |
| `<style>` | no | CSS for the app. |
| `<body>` | one of the two | HTML placed in `<body>`. |
| `<script>` | one of the two | JavaScript placed at the end of `<body>`. A classic script, not a module. |
| `<widget>` | no | A widget the app offers for the desktop (see *Widgets*): `kind` (lowercase letters, digits, dashes), `label` and `description` (translation keys), `width` 160–480 and `height` 120–480 in pixels, `refresh` in seconds (drawn again that often; 0, the default: never). Up to 6. |
| `<asset>` | no | A picture, sound or font: `name` (letters, digits, `.`, `-`, `_`), `type` (`image/…`, `audio/…`, `font/…`); SVG as text in CDATA, anything else with `encoding="base64"`. Get it with `bead.asset(name)`. |
| `<migrate from="x.y.z">` | no | A JavaScript arrow function `(data) => newData`. When this version reads data saved by version `x.y.z` (or a later one older than this), the function changes them to the new shape, once. |

Write no `<!DOCTYPE>` and no entities. Keep code inside `<![CDATA[ … ]]>`; if the code ever contains the
characters `]]>`, write them as `]]]]><![CDATA[>`. The whole file stays under 2 MB, the saved data under 1 MB.

## The `bead` object

The app's script finds `window.bead`. Every call that talks to the desktop returns a promise; when it fails, the
promise rejects with an `Error` whose `message` is ready to show and whose `code` (when there is one) tells why.

```js
bead.t('key', { n: 3 })        // a text of <translations> in the user's language: "{n} items" → "3 items"
bead.lang                      // the user's language: "it", "en"…
bead.asset('logo.svg')         // a data: URL for <img src>, CSS url(…), new Audio(…)
bead.launch.action             // the action this window was opened with (menu item target="window"), or ""
bead.launch.file               // the file this window was opened with (Files › Open with…), or null

const data = await bead.data.get()          // the app's JSON document, or null the first time
await bead.data.set(data)                   // saves the whole document (under 1 MB)
await bead.data.set(data, { force: true })  // saves even if another window of the app saved meanwhile

const file = await bead.files.open({ types: ['image/*'] })        // Rainbead's Open window: a file, or null
const blob = await bead.files.read(file)                          // its content: a Blob…
const text = await bead.files.read(file, 'text')                  // …or "text", "arrayBuffer", "dataURL"
const same = await bead.files.write(file, blob)                   // saves over it (a Blob, a string or an ArrayBuffer)
const made = await bead.files.saveAs(blob, { name: 'Drawing.png', types: ['image/*'] }) // Save as: a new file, or null

bead.on('menu', (action) => { … })          // an item of ☰, a button of the bar or a shortcut was used
bead.on('theme', (scheme) => { … })         // the user switched light/dark: "light" | "dark"
bead.on('data', () => { … })                 // another window or widget of the app saved its data: read them again

bead.launch.widget                           // drawing a widget on the desktop: its kind ("today"); null in a window
const mine = await bead.widget.config.get()  // what this one widget keeps for itself (null the first time)
await bead.widget.config.set({ city: 'Rome' })  // saves it: a small JSON object, up to 16 KB

await bead.ui.title('Report.txt')           // the title, in the bar and on the window (document.title is not shown)
await bead.ui.dirty(true)                   // unsaved changes: a dot by the title, closing asks first; false when saved
await bead.ui.state('undo', { disabled: true })  // an item of ☰ and of the bar: disabled, checked (✓), hidden
await bead.ui.toast('Saved')                // a short message at the bottom
const yes = await bead.ui.confirm('Delete everything?')   // true or false
await bead.ui.open('new')                   // a new window of this app, with bead.launch.action = "new"
await bead.ui.close()                       // closes this window
```

`bead.data.set()` without `force` is refused (`code === "conflict"`) when another window of the same app saved
after this one read the data: read again with `bead.data.get()`, merge, save. For simple apps
`{ force: true }` (the last save wins) is fine.

## The bar

Every window has the same bar, drawn by Rainbead, not by the app:

```
[☰]  Title ………………………  [buttons of <bar>]  [⚙]
```

- **☰**, always first, opens the app's menu: the items of the first `<menu>`, then the other menus as entries
  that open their own items (*Edit ›*), then *About* (with `name`, `description`, `info`). On a phone, buttons of
  the bar that have no room go into ☰ too.
- **The title** is the app's name until `bead.ui.title()` changes it (the name of the open file, for instance);
  `bead.ui.dirty(true)` puts a dot by it.
- **The buttons** of `<bar>`: words on a computer, only the icon on a phone. Without an `icon` a button can't
  shrink, so it is the first to go into ☰.
- **⚙** opens the app's page in Applications: its details, where it shows, what it may do.

Do not draw another menu bar inside the app. A row of the app's own tools (brushes, colours…) under the bar is
fine: it is part of the content.

Keep the state honest: `bead.ui.state('redo', { disabled: true })` when there is nothing to redo,
`{ checked: true }` on the choice in use (a level, a view), `{ hidden: true }` for what makes no sense now (Save
with nothing to save). It applies to the item of ☰ and to the button of the bar with that `action`.

**Icons** (for `icon="…"`): `new`, `open`, `save`, `save-as`, `print`, `download`, `upload`, `new-window`,
`folder-plus`, `plus`, `edit`, `trash`, `archive`, `undo`, `redo`, `eraser`, `refresh`, `search`, `share`, `people`,
`star`, `flag`, `play`, `check`, `close`, `info`, `help`, `settings`, `view`, `list`, `grid`, `details`, `month`,
`agenda`, `day`, `today`, `image`, `text`, `palette`, `link`, `mail`, `home`, `sidebar`, `back`, `forward`, `up`,
`news`, `podcast`, `feeds`, `lines`, `clock`, `tag`, `clip`, `checklist`, `activity`. An unknown name shows no icon.

## Files

The app never looks into the user's files. It works only on the files the user **gives** it, in one of three ways:

1. **Open**: `bead.files.open()` shows Rainbead's own Open window (not the app's: the app can't draw it, change it
   or see into it). The user chooses one file; the app gets that one.
2. **Open with**: the user opens a file with the app from Files (*Open with…*, for the types in `<opens>`). The
   window starts with it in `bead.launch.file`.
3. **Save as**: `bead.files.saveAs(content, options)` shows Rainbead's Save as window, with `options.name`
   proposed. The user chooses the folder and the name; a new file is made there (or, if the user picks an existing
   one and confirms, it is replaced, the old content kept among its versions). The app gets that file.

What the app gets is a plain object, the same in the three cases:

```js
{ id: 42, name: 'Holiday.png', type: 'image/png', size: 183245, revision: 7, editable: true }
```

Then, **for as long as that window is open**:

- `bead.files.read(file, as)` reads it: a `Blob` (default), or `'text'`, `'arrayBuffer'`, `'dataURL'`.
- `bead.files.write(file, content, { force })` saves over it, when `editable` is true (a file shared with the user
  read only is not). It returns the file brought up to date (new `size` and `revision`): keep that one. The old
  content stays among the file's versions, in Files.

A new window of the app starts with no files (except `bead.launch.file`). Keep in `bead.data` what the app wants to
remember (tools, settings), not the files: to work on a file again, the user opens it again.

The options of `open` and `saveAs`:

| Option | Of | What it does |
|---|---|---|
| `types` | `open`, `saveAs` | Which files: extensions (`'.png'`) and types (`'image/png'`, `'image/*'`), an array or a string with spaces. `open` shows only those; `saveAs` shows the others faded. None: every file. |
| `name` | `saveAs` | The name proposed, extension included (`'Drawing.png'`). If the user writes a name without extension, this one's is added. |
| `type` | `saveAs` | The type of the content, when it is not a `Blob` with its own type (`'text/plain'`). |

When something goes wrong, the promise rejects with one of these `code`s:

| `code` | When |
|---|---|
| `"denied"` | The file was not given to the app (or is no longer there). |
| `"readonly"` | `write` on a file the user may not change: offer `saveAs` instead. |
| `"conflict"` | `write`, but the file changed elsewhere after it was read: ask the user, then `write(file, content, { force: true })`. |
| `"busy"` | An Open or Save as window of this app is already open. |
| none | Anything else (no room left, a file too big — 5 MB by default — a network error): show `error.message`. |

`open` and `saveAs` resolve to `null` when the user closes the window without choosing: that is not an error.

```js
// open a picture, draw it, save it back (or as a new file when it came from nowhere)
async function openPicture() {
  const file = await bead.files.open({ types: ['image/*'] });
  if (!file) return;
  const picture = await createImageBitmap(await bead.files.read(file));
  canvas.width = picture.width;
  canvas.height = picture.height;
  canvas.getContext('2d').drawImage(picture, 0, 0);
  current = file;
}
async function save() {
  const blob = await new Promise((done) => canvas.toBlob(done, 'image/png'));
  if (!current || !current.editable) {
    current = (await bead.files.saveAs(blob, { name: bead.t('untitled') + '.png', types: ['image/png'] })) || current;
    return;
  }
  try {
    current = await bead.files.write(current, blob);
  } catch (error) {
    if (error.code !== 'conflict' || !(await bead.ui.confirm(bead.t('changedElsewhere')))) throw error;
    current = await bead.files.write(current, blob, { force: true });
  }
}
```

## Widgets

An app can offer **widgets**: small frames on the desktop (a clock, a counter, today's list), each a little view of
the app. Declare each with `<widget>`; the user adds it from the desktop's right click, **Add a widget…**, moves it
by its top edge and removes it with its «×».

```xml
<widget kind="today" label="todayName" description="todayAbout" width="220" height="160"/>
```

A widget is **the same app**: the same `.bead`, the same `<style>`, `<body>` and `<script>`, in the same sandbox,
with the same data. It knows it is drawing a widget from `bead.launch.widget` (the `kind`), and shows something
else then:

```js
if (bead.launch.widget === 'today') {
  document.body.classList.add('is-widget');      // its own small layout, in <style>
  showToday(await bead.data.get());
  bead.on('data', async () => showToday(await bead.data.get()));  // a window of the app saved: draw again
} else {
  startTheApp();
}
```

- **The look**: the page is transparent and the desktop draws the theme's glass around it. Write on it with
  `var(--widget-text)` and `var(--widget-muted)` (already the colour of the page), tiles with `var(--widget-tile)`;
  keep the top 14 px and the top right corner free: the user drags the widget from there, and its «×» sits there.
- **Its own settings**: each copy of a widget keeps a small JSON object of its own with `bead.widget.config`
  (a city, a colour), apart from the app's data, which every window and widget share.
- **Opening the app**: `bead.ui.open('action')` opens a window of the app with `bead.launch.action`. Toasts and
  `bead.ui.confirm()` work too. A widget has no menu, no bar, no title and no files: `bead.files.*` is refused.
- **Phones**: widgets stand two in a row at the bottom, about 160–200 px wide: draw for that too.
- **Refresh**: a widget that shows time-bound things can ask to be drawn again every `refresh` seconds (60 or more);
  a clock is better kept by its own `setInterval`.
- **Only widgets**: `<bead-app … kind="widget">` makes an app of widgets alone: it does not appear on the desktop
  nor in the Start menu (it is still in **Applications**, and `bead.ui.open()` opens its window, which can be its
  settings or its help). It still needs a `<body>` or a `<script>`: the widgets are drawn by it.

See [`apps/clock.bead`](apps/clock.bead): a clock that is only a widget, in a few lines.

## Looking like the rest of the desktop

The desktop's stylesheet is already loaded in the app's page. Use its colours, so the app follows every theme,
light and dark:

- Colours: `var(--bead-text)`, `--bead-muted`, `--bead-bg` (the page), `--bead-surface` (panels, fields),
  `--bead-sunken`, `--bead-border`, `--bead-accent`, `--bead-accent-soft`, `--bead-hover`, `--bead-selected`,
  `--bead-danger`, `--bead-ok`.
- Shapes and fonts: `var(--bead-radius)`, `--bead-radius-small`, `--bead-shadow`, `--bead-font`, `--bead-mono`.
- Ready-made classes: `.btn` (with `.is-primary`, `.is-danger`, `.is-small`, `.is-ghost`), `.icon-btn`,
  `.toolbar`, `.box`, `.form`, `.field` (`<label class="field"><span>Label</span><input></label>`), `.row`,
  `.check`, `.switch`, `.segmented`, `.table`, `.muted`, `.empty`, `.badge`, `.meter`.
- Fields (`input`, `select`, `textarea`) are already styled. The body has no margin and fills the window.
- `document.documentElement.dataset.scheme` is `"light"` or `"dark"` now; `bead.on('theme', …)` tells when it changes
  (to redraw a canvas, for instance).

## Good habits

- Wrap the whole script in `(() => { … })();`: names like `top`, `name`, `status`, `history`, `parent`, `length`
  belong to the browser, and declaring them at the top level stops the script.
- Declare functions and constants **before** the code that uses them runs: a `const` used too early (in an
  event listener added before its line, for instance) stops the whole script with no visible error.
- Build the interface with the DOM (`document.createElement`, `textContent`); when you write HTML strings, never
  put user text in them without escaping.
- Load data with `bead.data.get()` at start, save after each change (wait a moment when changes are fast).
- Every visible text comes from `bead.t()`: no text written in the code.
- Shortcuts: the browser keeps `Ctrl+N`, `Ctrl+T`, `Ctrl+W` and `Ctrl+Tab` for itself; choose others.
- Make it work in a small window and on a phone (the window can be 360 px wide).
- Keep everything in one file: no external URLs anywhere.

## Phones and tablets

On a phone every window takes the whole screen (often 360–430 px wide) and there is no mouse. Plan for it from the
start; if something can't work on a small screen, say so in `info` rather than breaking.

- **Size**: measure the window (`innerWidth`, `ResizeObserver`, `addEventListener('resize', …)`) and lay out from that,
  never from a fixed width. Let wide content scroll (`overflow: auto`) instead of shrinking it below use. A row of
  many tools can scroll sideways (`overflow-x: auto` with `flex: none` on its items).
- **Fingers**: anything tappable at least about 32 px; keep 4–6 px between targets.
- **No double click, no right click, no hover**: a single tap must be enough (use `pointerdown`/`pointerup` and
  `e.pointerType === 'touch'`); offer a long press (about 400 ms) or a visible toggle for what a right click does;
  never hide anything behind `:hover` only.
- **Dragging and drawing**: use Pointer Events with `touch-action: none` on what is dragged or drawn on, and a few
  pixels of slack before a drag starts, so that a tap stays a tap. `setPointerCapture()` can fail: wrap it in
  `try`.
- **The keyboard** covers half the screen: keep the field being typed in near the top, or scroll it into view.
- **Dialogs**: `bead.ui.confirm` works everywhere; for your own dialogs draw them inside the app (an overlay with a
  box), sized with `min(…, 100%)`. The browser's `prompt()` is not available in the sandbox.
- **Animations**: `document.documentElement.dataset.motion === 'reduced'` means the user turned animations off
  (slower devices): skip or shorten them.

## A complete example

```xml
<?xml version="1.0" encoding="UTF-8"?>
<bead-app id="it.example.counter" version="1.0.0" author="Example">
  <translations>
    <lang code="en" default="true"><![CDATA[{
      "name": "Counter", "description": "Counts things, and remembers.",
      "info": "Press + and − to count.\nThe count is kept in your account.",
      "edit": "Edit", "reset": "Reset", "count": "Count: {n}"
    }]]></lang>
    <lang code="it"><![CDATA[{
      "name": "Contatore", "description": "Conta le cose, e se le ricorda.",
      "info": "Premi + e − per contare.\nIl conteggio resta nel tuo account.",
      "edit": "Modifica", "reset": "Azzera", "count": "Conteggio: {n}"
    }]]></lang>
  </translations>
  <icon><![CDATA[<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48"><rect x="6" y="6" width="36" height="36" rx="9" fill="#3b8de0"/><text x="24" y="32" font-size="20" font-family="Arial" font-weight="700" fill="#fff" text-anchor="middle">42</text></svg>]]></icon>
  <window width="320" height="260"/>
  <menu>
    <menu label="edit"><item label="reset" action="reset" shortcut="Ctrl+R" icon="refresh"/></menu>
  </menu>
  <style><![CDATA[
    body { display: grid; place-content: center; gap: 14px; text-align: center; }
    #n { font-size: 48px; font-weight: 300; color: var(--bead-accent); }
  ]]></style>
  <body><![CDATA[
    <div id="n">0</div>
    <div><button class="btn" id="minus">−</button> <button class="btn is-primary" id="plus">+</button></div>
  ]]></body>
  <script><![CDATA[(() => {
    let data = { n: 0 };
    const show = () => { document.getElementById('n').textContent = data.n; bead.ui.title(bead.t('count', { n: data.n })); };
    const change = (d) => { data.n += d; show(); bead.data.set(data, { force: true }); };
    document.getElementById('plus').onclick = () => change(1);
    document.getElementById('minus').onclick = () => change(-1);
    bead.on('menu', (action) => { if (action === 'reset') change(-data.n); });
    bead.data.get().then((saved) => { data = saved || data; show(); });
  })();]]></script>
</bead-app>
```

A bigger example, with files: **Paint** (`paint.bead`, in *Applications › Add an app › Examples*) opens pictures
with `bead.files.open()`, is offered by Files thanks to `<opens>`, starts from `bead.launch.file`, saves with
`bead.files.write()` and `bead.files.saveAs()`, and remembers its tools with `bead.data`. Its *Undo*, *Redo* and *Save*
are buttons of the bar (`<bar>`), kept up to date with `bead.ui.state()` and `bead.ui.dirty()`.

## Checklist

1. The root is `<bead-app>` with `id` (reverse domain, lowercase) and `version` (`x.y.z`).
2. `<translations>` has a default language with `name` and `description` (and `info` if there is a menu).
3. `<icon>` is one inline `<svg>` with a square `viewBox`.
4. Every text on screen comes from `bead.t()`, every menu and bar `label` is a translation key.
5. No menu bar of its own: commands go in `<menu>` (☰) and `<bar>`, with icons on the first level and on every
   button; their state follows `bead.ui.state()`, unsaved work `bead.ui.dirty()`.
6. No network, no external URLs, no `localStorage`, no modules, no frameworks.
7. It works with a finger on a 360 px wide screen (a tap instead of a double click, a long press instead of a right
   click).
8. Data are read with `bead.data.get()` and saved with `bead.data.set()`.
9. Files come only from `bead.files.open()`, `bead.launch.file` and `bead.files.saveAs()`; `null` (the user gave up)
   and the error codes are handled; `write` is used only when `file.editable` is true.
10. If the app opens files from Files, `<opens types="…">` lists their extensions and types.
11. Colours use the `--bead-*` variables, so the app works in light and dark themes.
12. To update an existing app: same `id`, higher `version`, and a `<migrate from="…">` if the shape of the data
    changed.

## License

[GNU General Public License v3.0](LICENSE) — the apps in this repository, and what you build from them if you share it.
The Universe theme carries the Nunito font (The Nunito Project Authors), under the
[SIL Open Font License 1.1](themes/universe/nunito-OFL.txt).
