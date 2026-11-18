# Skypane apps

Games and apps for **Skypane**, the desktop in the browser — each one a
single `.sky` file you can install in a few seconds, and an example to learn from.

| | App | What it is |
|---|---|---|
| 🃏 | [`games/solitaire.sky`](games/solitaire.sky) | **Solitaire** (Klondike): drag or tap, undo, draw one or three, finishes by itself when every card is face up, best scores by time and by moves |
| 💣 | [`games/mines.sky`](games/mines.sky) | **Loose Mine** («Mina Vagante»): find the mines under the meadow — three levels, a safe first square, flags by right click or long press, best times per level |
| 📝 | [`apps/notes.sky`](apps/notes.sky) | **Notes**: a tiny list of notes, and the smallest complete example of the format (menu, shortcuts, an asset, a data migration) |

Every app speaks English and Italian, follows the light and dark themes of the desktop, and works on phones too.

## Install one

1. Download the `.sky` file (open it on GitHub, then *Download raw file*).
2. In Skypane open **Applications › Add an app** and drop the file on *Upload a .sky file*.
3. It appears on the desktop and in the Start menu. To update it later, upload a newer version: its data are kept.

A `.sky` app runs closed in its window: it can't reach the internet, your files or other apps — it only keeps its
own data, encrypted on the server like everything else in Skypane.

## On phones

All three are made to be played and used with a finger:

- **Solitaire**: a tap sends a card where it fits (the double click of the mouse); cards are dragged with a short
  slack so that taps stay taps; the cards shrink with the screen, down to a 360 px wide phone.
- **Loose Mine**: a tap uncovers a square, a long press (or the 🚩 button, which turns taps into flags) marks a mine;
  squares never get smaller than 26 px; the expert level (30 × 16) scrolls sideways on a narrow screen.
- **Notes**: one column; the field stays at the top, above the keyboard.

The general rules for phones are in the guide below, under *Phones and tablets*.

## Make your own

Everything about the format follows: the same guide Skypane gives in *Applications › Add an app*. Pull requests with new apps are welcome — one `.sky` file per app, in `games/` or
`apps/`, with English and Italian texts.

---

# The .sky format

You are writing an app for **Skypane**, a desktop that runs in the browser. An app is **one XML file** with
the extension `.sky`. The user uploads it in *Applications › Add an app*; it then has its own icon, window
and (optionally) menu bar, like every other app of the desktop.

Write the whole file in one go, following this guide exactly. Reply with the file only.

## What an app can and cannot do

The app runs in a sandboxed window:

- **Can**: draw its interface with HTML, CSS and plain JavaScript (no build step, no frameworks, no modules);
  keep **one JSON document** per user (saved encrypted on the server); show toasts and confirmations; set its
  window title; open another window of itself; react to its menu; use its own pictures (assets) and texts
  (translations); follow the desktop's light/dark theme.
- **Cannot**: reach the network (`fetch`, `XMLHttpRequest`, WebSocket, external scripts, fonts or images are all
  blocked); read cookies or storage of the site; open popups; touch other apps, files or messages.
  `localStorage` is not available either: use `sky.data`.

## The file

```xml
<?xml version="1.0" encoding="UTF-8"?>
<sky-app id="it.yourname.appname" version="1.0.0" author="Your name">
  <translations>
    <lang code="en" default="true"><![CDATA[{ "name": "…", "description": "…", "info": "…", "…": "…" }]]></lang>
    <lang code="it"><![CDATA[{ "name": "…", "description": "…" }]]></lang>
  </translations>
  <icon><![CDATA[<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48">…</svg>]]></icon>
  <window width="640" height="480"/>
  <menu>
    <menu label="file">
      <item label="new" action="new" shortcut="Ctrl+N"/>
      <separator/>
      <item label="newWindow" action="" target="window"/>
    </menu>
  </menu>
  <style><![CDATA[ /* CSS */ ]]></style>
  <body><![CDATA[ <!-- HTML that goes inside <body> --> ]]></body>
  <script><![CDATA[ // JavaScript, run after the body ]]></script>
  <asset name="logo.svg" type="image/svg+xml"><![CDATA[<svg …>…</svg>]]></asset>
  <asset name="beep.mp3" type="audio/mpeg" encoding="base64">SUQz…</asset>
  <migrate from="1.0.0"><![CDATA[ (data) => ({ ...data, items: data.items ?? [] }) ]]></migrate>
</sky-app>
```

Rules:

| Part | Required | Notes |
|---|---|---|
| `id` | yes | Reverse domain, lowercase: `it.mario.pomodoro`. It identifies the app forever: keep it the same in every version. |
| `version` | yes | `major.minor.patch`. To update an installed app, upload a **higher** version: its data are kept. |
| `author` | no | Shown in the details. |
| `<translations>` | yes | One `<lang code="xx">` per language, each a JSON object of texts. One has `default="true"` (used when a text is missing). Keys **`name`** and **`description`** are required; **`info`** is the longer text of the details and of the "About" box (use `\n` for new lines). Every other key is yours: menu labels, buttons, messages. Provide at least `en`; `it` is welcome. |
| `<icon>` | yes | An inline **SVG**, square `viewBox` (48×48 works well), up to 64 KB. Glossy, colourful, simple. |
| `<window>` | no | Starting size, in pixels. |
| `<menu>` | no | One level of menus. `label` attributes are **translation keys**. An `<item>` has an `action` (a word your script receives), an optional `shortcut` (`F2`, `Ctrl+Z`, `Ctrl+Shift+S`…), and `target="window"` to run the action in a **new window** of the app (it receives it as `sky.launch.action`). `<separator/>` draws a line. When there is a menu, the desktop adds "? › About" with `name`, `description` and `info`. |
| `<style>` | no | CSS for your app. |
| `<body>` | one of the two | HTML placed in `<body>`. |
| `<script>` | one of the two | JavaScript placed at the end of `<body>`. Classic script, not a module. |
| `<asset>` | no | Pictures, sounds or fonts: `name`, `type` (`image/…`, `audio/…`, `font/…`); SVG as text in CDATA, anything else with `encoding="base64"`. Get them with `sky.asset(name)`. |
| `<migrate from="x.y.z">` | no | A JavaScript arrow function `(data) => newData`, run once when data saved by version `x.y.z` (or later, but older than this one) are read by this version. |

Never write a `<!DOCTYPE>` or entities. Keep code inside `<![CDATA[ … ]]>`; if your code ever contains the
characters `]]>`, write them as `]]]]><![CDATA[>`. The whole file must stay under 2 MB, the saved data under 1 MB.

## The `sky` object

Available to your script as `window.sky`:

```js
sky.t('key', { n: 3 })        // a text of <translations> in the user's language; "{n} items" → "3 items"
sky.lang                      // "it", "en"…
sky.asset('logo.svg')         // a data: URL for <img src>, CSS url(…), new Audio(…)
sky.launch.action             // the action this window was opened with (menu item target="window"), or ""

const data = await sky.data.get()        // your JSON document, or null the first time
await sky.data.set(data)                 // saves the whole document (keep it small: under 1 MB)
await sky.data.set(data, { force: true }) // saves even if another window of the app saved meanwhile

sky.on('menu', (action) => { … })        // a menu item or its shortcut was used
sky.on('theme', (scheme) => { … })       // the user switched light/dark ("light" | "dark")

await sky.ui.title('Report.txt')         // the window title
await sky.ui.toast('Saved')              // a short message
const yes = await sky.ui.confirm('Delete everything?')
await sky.ui.open('new')                 // a new window of this app, with sky.launch.action = "new"
await sky.ui.close()                     // closes this window
```

`sky.data.set()` without `force` is refused (the promise rejects with `error.code === "conflict"`) when another
window of the same app saved after this one read the data: then read again with `sky.data.get()` and merge.
For simple apps, `{ force: true }` (last save wins) is fine.

## Looking like the rest of the desktop

The desktop's stylesheet is already loaded. Use its colours, so the app follows every theme, light and dark:

- Colours: `var(--sky-text)`, `--sky-muted`, `--sky-bg` (page), `--sky-surface` (panels, inputs), `--sky-sunken`,
  `--sky-border`, `--sky-accent`, `--sky-accent-soft`, `--sky-hover`, `--sky-selected`, `--sky-danger`, `--sky-ok`.
- Shapes: `var(--sky-radius)`, `--sky-radius-small`, `--sky-shadow`, fonts `--sky-font`, `--sky-mono`.
- Ready-made classes: `.btn` (with `.is-primary`, `.is-danger`, `.is-small`, `.is-ghost`), `.icon-btn`,
  `.toolbar`, `.box`, `.form`, `.field` (a `<label class="field"><span>Label</span><input></label>`), `.row`,
  `.check`, `.switch`, `.segmented`, `.table`, `.muted`, `.empty`, `.badge`, `.meter`.
- Inputs (`input`, `select`, `textarea`) are already styled. The body has no margin and fills the window.

## Good habits

- Wrap the whole script in `(() => { … })();`: names like `top`, `name`, `status`, `history`, `parent`, `length`
  belong to the browser, and declaring them at the top level stops the script.
- Build the interface with the DOM (`document.createElement`, `textContent`); when you write HTML strings, never
  put user text in them without escaping.
- Load data with `sky.data.get()` at start, save after each change (debounce if changes are fast).
- Every visible text comes from `sky.t()`: no text written in the code.
- Make it work in a small window and on a phone (the window can be 360 px wide).
- Keep everything in one file: no external URLs anywhere.

## Phones and tablets

On a phone every window takes the whole screen (often 360–430 px wide) and there is no mouse. Plan for it from the
start; if something can't work on a small screen, say so in `info` rather than breaking.

- **Size**: measure the window (`innerWidth`, `ResizeObserver`, `addEventListener('resize', …)`) and lay out from that,
  never from a fixed width. Let wide content scroll (`overflow: auto`) instead of shrinking it below use.
- **Fingers**: anything tappable at least about 32 px; keep 4–6 px between targets.
- **No double click, no right click, no hover**: a single tap must be enough (use `pointerdown`/`pointerup` and
  `e.pointerType === 'touch'`); offer a long press (about 400 ms) or a visible toggle for what a right click does;
  never hide anything behind `:hover` only.
- **Dragging**: use Pointer Events with `touch-action: none` on what is dragged, and a few pixels of slack before a drag
  starts, so that a tap stays a tap.
- **The keyboard** covers half the screen: keep the field being typed in near the top, or scroll it into view.
- **Dialogs**: `sky.ui.confirm` works everywhere; for your own dialogs draw them inside the app (an overlay with a
  box), sized with `min(…, 100%)` — the browser's `prompt()` is not available in the app's sandbox.
- **Animations**: `document.documentElement.dataset.motion === 'reduced'` means the user turned animations off
  (slower devices): skip or shorten them.

## A complete example

```xml
<?xml version="1.0" encoding="UTF-8"?>
<sky-app id="it.example.counter" version="1.0.0" author="Example">
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
    <menu label="edit"><item label="reset" action="reset" shortcut="Ctrl+R"/></menu>
  </menu>
  <style><![CDATA[
    body { display: grid; place-content: center; gap: 14px; text-align: center; }
    #n { font-size: 48px; font-weight: 300; color: var(--sky-accent); }
  ]]></style>
  <body><![CDATA[
    <div id="n">0</div>
    <div><button class="btn" id="minus">−</button> <button class="btn is-primary" id="plus">+</button></div>
  ]]></body>
  <script><![CDATA[(() => {
    let data = { n: 0 };
    const show = () => { document.getElementById('n').textContent = data.n; sky.ui.title(sky.t('count', { n: data.n })); };
    const change = (d) => { data.n += d; show(); sky.data.set(data, { force: true }); };
    document.getElementById('plus').onclick = () => change(1);
    document.getElementById('minus').onclick = () => change(-1);
    sky.on('menu', (action) => { if (action === 'reset') change(-data.n); });
    sky.data.get().then((saved) => { data = saved || data; show(); });
  })();]]></script>
</sky-app>
```

## Before you answer, check

1. The root is `<sky-app>` with `id` (reverse domain, lowercase) and `version` (`x.y.z`).
2. `<translations>` has a default language with `name` and `description` (and `info` if there is a menu).
3. `<icon>` is a single inline `<svg>` with a square `viewBox`.
4. Every text on screen comes from `sky.t()`, every menu `label` is a translation key.
5. No network, no external URLs, no `localStorage`, no modules, no frameworks.
5b. It works with a finger on a 360 px wide screen (tap instead of double click, long press instead of right click).
6. Data are read with `sky.data.get()` and saved with `sky.data.set()`.
7. Colours use the `--sky-*` variables, so the app works in light and dark themes.
8. To update an existing app: same `id`, higher `version`, and a `<migrate from="…">` if the shape of the data changed.


---

## License

[GNU General Public License v3.0](LICENSE) — the apps in this repository, and what you build from them if you share it.
