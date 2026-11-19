# Making a Skypane theme

A theme changes how all of Skypane looks: the desktop, its bar and icons, the frames of the windows, what is inside
every window, the widgets. It is **a folder** with a `manifest.json` and a `theme.css` (plus its fonts and pictures,
if any), installed by the administrator. [`universe/`](universe/) is a complete theme, commented line by line: start
from a copy of it.

This guide is complete: a theme written by following it, part by part, works the first time.

## What a theme can and cannot do

- **It can**
  - set the colours, shapes, fonts and shadows of everything through variables (`--sky-*`, `--win-*`, `--taskbar-*`,
    `--widget-*`), separately for light and dark;
  - restyle Skypane's pieces with ordinary CSS (buttons, windows, the bar, the desktop icons, the Dock…);
  - bring its own fonts (`.woff2`) and pictures (`.svg`, `.png`, `.webp`, `.jpg`), next to `theme.css`;
  - offer wallpapers, drawn in CSS.
- **It cannot**
  - run JavaScript (a theme is only CSS);
  - load anything from other sites: no Google Fonts, no CDN, no remote pictures (the page refuses them);
  - change what pages contain, only how they look.

## The folder

```
universe/
  manifest.json      who it is
  theme.css          how it looks
  nunito.woff2       a font it uses (optional)
  nunito-OFL.txt     its licence (fonts must be free to redistribute: SIL OFL, Apache…)
  lang/it.po         its texts in Italian (optional; one file per language)
```

### manifest.json

```json
{
    "name": "Universe",
    "description": "White and silver, soft grey stripes, sky-blue light and round, friendly buttons…",
    "version": "1.0.0",
    "modes": ["light", "dark"],
    "preview": "linear-gradient(160deg, #ffffff, #e9eef2 55%, #34beed 55.5%, #8fdcf7)",
    "wallpapers": { "channels": "Channels", "plaza": "Plaza", "orbit": "Orbit", "stripes": "Stripes" },
    "type": "theme"
}
```

| Key | Required | What it is |
|---|---|---|
| `name` | yes | Shown in *Settings › Appearance › Theme*. |
| `description` | yes | One or two sentences under the name. |
| `version` | yes | `major.minor.patch`. To update an installed theme, upload a **higher** version. |
| `modes` | yes | `["light", "dark"]`, or only one of them: a theme with one mode ignores the user's light/dark choice. |
| `preview` | no | A CSS background (a gradient) for the little sample in Settings. |
| `wallpapers` | no | Its wallpapers: `id` → name. The first is the default. Each one is drawn by the class `.wp-{id}`. |
| `type` | yes | Always `"theme"`. |
| `id` | no | The theme's id (lowercase, digits, `-`, `_`). Without it, the folder's name is used. |

`name`, `description` and the wallpapers' names are written in English. Their translations go in
`lang/{locale}.po` (gettext: `msgid` the English text, `msgstr` the translation), as in [`universe/lang/it.po`](universe/lang/it.po).

## theme.css

Skypane loads its own `ui.css` (every page) and `shell.css` (the desktop) first, then `theme.css`: what the theme
says wins. The file has three parts, in this order.

### 1. The variables, for light and for dark

`sky.js` puts `data-scheme="light"` or `data-scheme="dark"` on `<html>`, from the user's choice or the system's. A
theme sets its two palettes there; what is the same in both (font, roundness) goes in `:root`.

```css
:root { --sky-font: "Skypane Rounded", ui-rounded, system-ui, sans-serif; --sky-radius: 14px; }
[data-scheme="light"] { --sky-text: #4a5259; --sky-bg: #f4f5f6; --sky-accent: #1a9fd6; color-scheme: light; … }
[data-scheme="dark"]  { --sky-text: #e3e8ec; --sky-bg: #1a1c1f; --sky-accent: #34beed; color-scheme: dark; … }
```

Always end each palette with `color-scheme: light` or `dark`: form fields, scrollbars and the widgets' frames
follow it.

**Inside every window** (`--sky-*`):

| Variable | What it colours |
|---|---|
| `--sky-font`, `--sky-mono` | The text; code and numbers in columns. |
| `--sky-text`, `--sky-muted` | Text; secondary text (hints, dates). |
| `--sky-bg`, `--sky-surface`, `--sky-sunken` | The page; panels, cards and fields; sidebars and troughs. |
| `--sky-border` | Lines and borders. |
| `--sky-hover`, `--sky-selected` | Under the pointer; what is chosen (rows, list items). |
| `--sky-accent`, `--sky-accent-text`, `--sky-accent-soft` | The theme's colour: links, marks, switches; text on it; a pale version of it. |
| `--sky-ok`, `--sky-danger` | Done and well; delete and errors. |
| `--sky-radius`, `--sky-radius-small` | Roundness of panels; of buttons and fields. |
| `--sky-shadow`, `--sky-focus` | Shadow of menus and dialogs; the ring around what has the keyboard's focus. |
| `--sky-button`, `--sky-button-hover`, `--sky-button-border` | Ordinary buttons (a colour or a gradient). |
| `--sky-primary`, `--sky-primary-border` | The main button (Save, OK) and the chosen part of a group of buttons. |
| `--sky-card`, `--sky-card-border` | Translucent cards on the sign-in page. |
| `--sky-blur` | How much glass blurs what is behind (`0px`: no glass). |

**The windows' frames** (`--win-*`):

| Variable | What it colours |
|---|---|
| `--win-frame`, `--win-frame-inactive` | The frame and title bar, in front and behind (a colour or a gradient: a gradient's first 34px are the title bar). |
| `--win-border`, `--win-shadow` | The frame's border; its shadow (also the glow of the window in front). |
| `--win-title`, `--win-title-inactive` | The title's colour. |
| `--win-gloss` | A shine over the title bar (`none`: none). |
| `--win-close` | The close button. |
| `--win-radius`, `--win-pad` | Roundness of the frame; its thickness around the content. |

**The desktop** (`--taskbar-*`, `--task-*`, …):

| Variable | What it colours |
|---|---|
| `--taskbar-bg`, `--taskbar-text` | The bar (also the menu bar and the Dock of the Mac layout). |
| `--task-bg`, `--task-active` | The windows' buttons in the bar; the one in front. |
| `--start-bg` | The Start menu, the notifications and the clock's panel. |
| `--icon-label` | The names under the desktop's icons (dark wallpapers want white, light ones a dark ink). |

**The widgets** (`--widget-*`): the glass the desktop draws around them and the text inside.

| Variable | What it colours |
|---|---|
| `--widget-bg`, `--widget-border`, `--widget-shadow`, `--widget-blur`, `--widget-radius` | The glass. |
| `--widget-text`, `--widget-muted`, `--widget-text-shadow` | The text inside; secondary text; a shadow that keeps it readable. |
| `--widget-tile`, `--widget-hover` | Small panels inside (the weather's days); under the pointer. |
| `--widget-font` | Their font (the theme's by default). |

Light glass wants dark text (`--widget-text: #3a434b; --widget-text-shadow: none`), dark or coloured glass white
text with a soft shadow. The sticky note keeps its paper colours in every theme.

A theme may also add **variables of its own** (Universe has `--tile-bg` and `--tile-border`) and use them below.

### 2. Restyling the pieces

Where variables are not enough, ordinary CSS on Skypane's classes:

- in every window (`ui.css`): `.btn` (`.is-primary`, `.is-danger`, `.is-ghost`), `.icon-btn`, `.segmented`, `.switch`,
  `.check`, `.toolbar`, `.field`, `.box`, `.meter`, `input`, `select`, `textarea`, `h1`–`h3`;
- on the desktop (`shell.css`): `.win`, `.win-title`, `.win-buttons button`, `.win-close`, `.win-body`, `.taskbar`,
  `.task` (`.is-active`), `.start-button`, `.clock`, `.tray-button`, `.start-menu`, `.notify-panel`, `.clock-panel`,
  `.desktop-icon` (`.is-selected`), `.dock`, `.dock-item`, `.widget`;
- the layouts: `body.layout-top` (the bar on top, as on phones), `body.layout-mac` (menu bar and Dock).

Keep to looks — colours, borders, roundness, shadows, fonts — and leave sizes and positions as they are: phones and
small windows depend on them. Write light and dark apart when they differ: `[data-scheme="dark"] .btn { … }`.

### 3. The wallpapers

One class per wallpaper of the manifest, `.wp-{id}`, drawn with gradients only (no pictures needed, and they look
sharp on every screen). `[data-scheme="dark"] .wp-{id}` gives the night version of the same wallpaper.

```css
.wp-channels { background: repeating-linear-gradient(0deg, rgba(150, 156, 162, .13) 0 2px, transparent 2px 6px), linear-gradient(#f2f3f4, #dcdfe2); }
[data-scheme="dark"] .wp-channels { background: linear-gradient(#1d2126, #111316); }
```

### Fonts and pictures

Put them next to `theme.css` and name them without a path:

```css
@font-face { font-family: "Skypane Rounded"; src: url("nunito.woff2") format("woff2"); font-weight: 400 800; font-display: swap; }
```

Only `.woff2` fonts and `.svg`, `.png`, `.webp`, `.jpg` pictures are served. Keep them small: subset a font to the
characters you need (Latin is enough for most languages of Europe); Universe's Nunito is 37 KB. Include the font's
licence.

## Install and update

1. Zip the folder: the archive holds `universe/manifest.json`, `universe/theme.css`… (or the files themselves,
   with an `"id"` in the manifest). From a copy of Skypane: `php bin/pack.php path/to/universe`.
2. In Skypane, **Administration › Themes › Upload**: it appears turned off. Turn it on, then choose it in
   **Settings › Appearance › Theme**.
3. To update it, upload a higher `version`: the users who chose it keep it.

## Checklist

1. `manifest.json` has `name`, `description`, `version` (`x.y.z`), `modes` and `"type": "theme"`.
2. Each mode of `modes` has its `[data-scheme="…"]` block, ending with `color-scheme`.
3. Text is readable on its backgrounds in both modes: `--sky-text` on `--sky-bg` and `--sky-surface`, `--sky-accent-text`
   on `--sky-primary`, `--taskbar-text` on `--taskbar-bg`, `--icon-label` on every wallpaper, `--widget-text` on
   `--widget-bg`.
4. Every wallpaper of the manifest has its `.wp-{id}`, for light and (if it differs) for dark.
5. Fonts and pictures are next to `theme.css`, named without a path, with their licence; nothing comes from
   other sites.
6. The texts of the manifest are translated in `lang/{locale}.po`, at least `it` if you can.
7. Only looks are restyled: sizes and positions stay Skypane's.
8. To update: same folder name (or `id`), higher `version`.
