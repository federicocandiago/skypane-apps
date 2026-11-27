<?xml version="1.0" encoding="UTF-8"?>
<!-- solitaire.gleam — Klondike patience, as a .gleam app. Cards are drawn with CSS; the game is saved as you play. -->
<gleam-app id="net.bluegleam.solitaire" version="1.2.0" author="Bluegleam">

  <translations>
    <lang code="en" default="true"><![CDATA[{
      "name": "Solitaire",
      "description": "Klondike patience: build the four foundations from Ace to King.",
      "info": "Move cards between the seven columns in descending order, alternating red and black. Only a King goes into an empty column. Build each foundation by suit, from Ace to King.\nClick the deck to draw. Double click (on a phone: tap) a card to send it where it fits. When every card is face up, the game finishes by itself. Ctrl+Z undoes, F2 starts a new game.\nYour game and your best scores are saved as you play.",
      "game": "Game", "cards": "Cards",
      "new": "New game",
      "undo": "Undo",
      "draw1": "Draw one card",
      "draw3": "Draw three cards",
      "newWindow": "New game in a new window",
      "moves": "Moves: {n}",
      "time": "Time: {t}",
      "stats": "Won {w} of {p}",
      "won": "You won!",
      "wonIn": "{n} moves, {t}.",
      "again": "Play again",
      "restart": "Start a new game? This one will be lost.",
      "scores": "Best scores",
      "byTime": "Fastest",
      "byMoves": "Fewest moves",
      "yourName": "Your name, for the scores",
      "save": "Save",
      "skip": "Skip",
      "nobody": "No games won yet.",
      "finish": "Finish",
      "close": "Close"
    }]]></lang>
    <lang code="it"><![CDATA[{
      "name": "Solitario",
      "description": "Il solitario Klondike: completa le quattro pile dall'Asso al Re.",
      "info": "Sposta le carte tra le sette colonne in ordine decrescente, alternando rosso e nero. In una colonna vuota può andare solo un Re. Completa ogni pila per seme, dall'Asso al Re.\nClicca il mazzo per pescare. Doppio clic (sul telefono: un tocco) su una carta per mandarla dove va. Quando tutte le carte sono scoperte, la partita si completa da sola. Ctrl+Z annulla, F2 inizia una nuova partita.\nPartita e migliori punteggi vengono salvati mentre giochi.",
      "game": "Partita", "cards": "Carte",
      "new": "Nuova partita",
      "undo": "Annulla",
      "draw1": "Pesca una carta",
      "draw3": "Pesca tre carte",
      "newWindow": "Nuova partita in un'altra finestra",
      "moves": "Mosse: {n}",
      "time": "Tempo: {t}",
      "stats": "Vinte {w} su {p}",
      "won": "Hai vinto!",
      "wonIn": "{n} mosse, {t}.",
      "again": "Gioca ancora",
      "restart": "Iniziare una nuova partita? Questa andrà persa.",
      "scores": "Migliori punteggi",
      "byTime": "I più veloci",
      "byMoves": "Meno mosse",
      "yourName": "Il tuo nome, per la classifica",
      "save": "Salva",
      "skip": "Salta",
      "nobody": "Ancora nessuna partita vinta.",
      "finish": "Completa",
      "close": "Chiudi"
    }]]></lang>
  </translations>

  <icon><![CDATA[<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48"><defs><linearGradient id="b" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#5db3ff"/><stop offset="1" stop-color="#1f5fb0"/></linearGradient></defs><g transform="rotate(-12 20 26)"><rect x="6" y="9" width="24" height="33" rx="3" fill="url(#b)" stroke="#fff" stroke-width="1.5"/><path d="M10 13h16v25H10z" fill="none" stroke="#fff" stroke-opacity=".5" stroke-dasharray="2 2"/></g><g transform="rotate(10 30 24)"><rect x="18" y="6" width="24" height="33" rx="3" fill="#fff" stroke="#9aa9b8"/><text x="22" y="16" font-family="Georgia, serif" font-size="9" font-weight="700" fill="#d32f2f">A</text><path d="M30 18c-2-4-8-2-6 3 1 3 6 6 6 8 0-2 5-5 6-8 2-5-4-7-6-3Z" fill="#d32f2f"/></g></svg>]]></icon>

  <window width="760" height="560"/>

  <!-- ☰ in Bluegleam's bar: the first menu is its first level, «Cards ›» a second level with ✓ on the way of drawing -->
  <menu>
    <menu label="game">
      <item label="new" action="new" shortcut="F2" icon="play"/>
      <item label="undo" action="undo" shortcut="Ctrl+Z" icon="undo"/>
      <item label="scores" action="scores" shortcut="Ctrl+B" icon="flag"/>
      <item label="newWindow" action="new" target="window" icon="new-window"/>
    </menu>
    <menu label="cards" icon="grid">
      <item label="draw1" action="draw1"/>
      <item label="draw3" action="draw3"/>
    </menu>
  </menu>

  <!-- the bar: «Undo», a word on a computer, the arrow on a phone -->
  <bar>
    <item label="undo" action="undo" icon="undo"/>
  </bar>

  <style><![CDATA[
    body { display: flex; flex-direction: column; user-select: none; -webkit-user-select: none; }
    #table { --w: 80px; --h: calc(var(--w) * 1.4); --gap: calc(var(--w) * .15); position: relative; flex: 1; overflow: hidden;
             background: radial-gradient(ellipse at 50% 30%, #2f8f4e, #1b5e33 75%); }
    [data-scheme="dark"] #table { background: radial-gradient(ellipse at 50% 30%, #1e5a36, #0d2c19 75%); }
    .slot { position: absolute; width: var(--w); height: var(--h); border: 2px solid rgba(255,255,255,.25); border-radius: 7px; }
    .slot.is-foundation::after { content: attr(data-suit); position: absolute; inset: 0; display: grid; place-items: center; font-size: calc(var(--w) * .45); color: rgba(255,255,255,.22); }
    .slot.is-stock { cursor: pointer; }
    .slot.is-stock::after { content: "↻"; position: absolute; inset: 0; display: grid; place-items: center; font-size: calc(var(--w) * .4); color: rgba(255,255,255,.35); }
    .card { position: absolute; width: var(--w); height: var(--h); border-radius: 7px; box-shadow: 0 1px 3px rgba(0,0,0,.35); transition: transform .12s; touch-action: none; }
    .card.up { background: #fff; border: 1px solid #bbb; color: #222; cursor: grab; }
    .card.red { color: #d32f2f; }
    .card.down { cursor: default; border: 2px solid #fff; background:
        repeating-linear-gradient(45deg, rgba(255,255,255,.15) 0 4px, transparent 4px 8px),
        linear-gradient(135deg, var(--gleam-accent), color-mix(in srgb, var(--gleam-accent) 60%, #000)); }
    .card .tl { position: absolute; top: 3px; left: 5px; font: 700 calc(var(--w) * .2)/1 Georgia, serif; text-align: center; }
    .card .br { position: absolute; bottom: 3px; right: 5px; font: 700 calc(var(--w) * .2)/1 Georgia, serif; transform: rotate(180deg); text-align: center; }
    .card .mid { position: absolute; inset: 0; display: grid; place-items: center; font-size: calc(var(--w) * .45); }
    .card.dragging { box-shadow: 0 10px 20px rgba(0,0,0,.4); transition: none; z-index: 1000 !important; cursor: grabbing; }
    .card.hint { outline: 3px solid #ffd54f; }
    #bar { display: flex; gap: 18px; padding: 4px 12px; font-size: 12.5px; color: var(--gleam-muted); background: var(--gleam-surface); border-top: 1px solid var(--gleam-border); }
    #bar .spacer { flex: 1; }
    #won, .modal { position: absolute; inset: 0; z-index: 2000; display: grid; place-items: center; padding: 12px; background: rgba(0,0,0,.35); }
    #won .box, .modal .box { text-align: center; max-width: min(420px, 100%); }
    .modal .box { text-align: left; display: grid; gap: 10px; width: 100%; }
    .modal h2 { margin: 0; }
    .modal .row-btns { display: flex; gap: 8px; justify-content: flex-end; }
    .scores { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
    .scores ol { margin: 4px 0 0; padding-left: 20px; font-size: 13px; }
    .scores li.is-new { font-weight: 700; color: var(--gleam-accent); }
    .scores h3 { margin: 0; font-size: 13px; }
    @media (max-width: 420px) { .scores { grid-template-columns: 1fr; } }
    #finish { position: absolute; right: 10px; bottom: 10px; z-index: 1500; }
    .card.flying { transition: left .16s ease-in, top .16s ease-in; z-index: 1600 !important; }
    #confetti { position: absolute; inset: 0; z-index: 1900; pointer-events: none; }
  ]]></style>

  <body><![CDATA[
    <div id="table"></div>
    <div id="bar"><span id="moves"></span><span id="time"></span><span class="spacer"></span><span id="stats"></span></div>
  ]]></body>

  <script><![CDATA[
    (() => { // everything inside a function: no clash with the names of the browser (top, name, history…)

    const SUITS = ['h', 'd', 'c', 's'];
    const SYMBOL = { h: '♥', d: '♦', c: '♣', s: '♠' };
    const RANK = ['', 'A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'];
    const red = (c) => c.s === 'h' || c.s === 'd';
    const table = document.getElementById('table');
    const calm = () => document.documentElement.dataset.motion === 'reduced' || matchMedia('(prefers-reduced-motion: reduce)').matches;
    const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

    let game = null;               // { stock, waste, foundations[4], tableau[7], drawThree, moves, seconds, won }
    let stats = { played: 0, won: 0 };
    let scores = [];               // { name, seconds, moves, draw, at } of the games won
    let lastName = '';
    let undoStack = [];            // earlier states, for undo
    let finishing = false;         // the automatic end is running
    const clone = (o) => JSON.parse(JSON.stringify(o));

    function deal(drawThree = false) {
      const deck = [];
      SUITS.forEach((s) => { for (let r = 1; r <= 13; r++) deck.push({ s, r, up: false }); });
      for (let i = deck.length - 1; i > 0; i--) { const j = Math.floor(Math.random() * (i + 1)); [deck[i], deck[j]] = [deck[j], deck[i]]; }
      const tableau = [];
      for (let i = 0; i < 7; i++) {
        tableau.push(deck.splice(0, i + 1));
        tableau[i][i].up = true;
      }
      stats.played++;
      return { stock: deck, waste: [], foundations: [[], [], [], []], tableau, drawThree, moves: 0, seconds: 0, won: false };
    }

    // ── Rules ──────────────────────────────────────────────────────────
    const last = (pile) => pile[pile.length - 1];
    function canFoundation(card, f) {
      const t = last(f);
      return t ? t.s === card.s && card.r === t.r + 1 : card.r === 1;
    }
    function canTableau(card, pile) {
      const t = last(pile);
      return t ? t.up && red(t) !== red(card) && card.r === t.r - 1 : card.r === 13;
    }

    /** A move: cards taken from (where, index, pos) to (where, index). Returns true if done. */
    function move(from, to, remember = true) {
      const source = pileOf(from);
      const cards = source.slice(from.pos);
      const target = pileOf(to);
      if (!cards.length || !cards[0].up) return false;
      if (to.where === 'f' && (cards.length !== 1 || !canFoundation(cards[0], target))) return false;
      if (to.where === 't' && !canTableau(cards[0], target)) return false;
      if (to.where === from.where && to.index === from.index) return false;
      if (remember) undoStack.push(clone(game));
      source.splice(from.pos);
      target.push(...cards);
      if (from.where === 't' && source.length && !last(source).up) last(source).up = true;
      game.moves++;
      after();
      return true;
    }

    function pileOf(p) {
      return p.where === 't' ? game.tableau[p.index] : p.where === 'f' ? game.foundations[p.index] : game.waste;
    }

    function draw() {
      if (finishing) return;
      undoStack.push(clone(game));
      if (!game.stock.length) {
        game.stock = game.waste.reverse().map((c) => ({ ...c, up: false }));
        game.waste = [];
      } else {
        const n = game.drawThree ? 3 : 1;
        for (let i = 0; i < n && game.stock.length; i++) game.waste.push({ ...game.stock.pop(), up: true });
      }
      game.moves++;
      after();
    }

    /** Double click (a tap on phones): to a foundation if possible, else to the first column that takes it. */
    function autoMove(from) {
      if (finishing) return false;
      const card = pileOf(from)[from.pos];
      if (from.pos === pileOf(from).length - 1) {
        for (let i = 0; i < 4; i++) if (canFoundation(card, game.foundations[i])) return move(from, { where: 'f', index: i });
      }
      for (let i = 0; i < 7; i++) if (canTableau(card, game.tableau[i]) && !(from.where === 't' && from.index === i)) return move(from, { where: 't', index: i });
      return false;
    }

    /** Nothing hidden and nothing left to draw: the game can finish by itself. */
    const solved = () => !game.won && !game.stock.length && !game.waste.length && game.tableau.every((p) => p.every((c) => c.up));

    function after() {
      if (!game.won && game.foundations.every((f) => f.length === 13)) {
        game.won = true;
        stats.won++;
        save();
        render();
        win();
        return;
      }
      save();
      render();
      if (solved() && !finishing) setTimeout(finish, 350);
    }

    /** The automatic end: one card at a time flies to its foundation, the lowest first. */
    async function finish() {
      if (finishing || !solved()) return;
      finishing = true;
      undoStack.push(clone(game));
      while (!game.won) {
        let best = null;
        game.tableau.forEach((pile, i) => {
          const card = last(pile);
          if (!card) return;
          const f = game.foundations.findIndex((fd) => canFoundation(card, fd));
          if (f >= 0 && (!best || card.r < best.card.r)) best = { card, from: { where: 't', index: i, pos: pile.length - 1 }, f };
        });
        if (!best) break;
        const el = [...table.querySelectorAll('.card')].find((c) => c.dataset.where === 't' && Number(c.dataset.index) === best.from.index && Number(c.dataset.pos) === best.from.pos);
        if (el && !calm()) {
          el.classList.add('flying');
          el.style.left = layout.x(3 + best.f) + 'px';
          el.style.top = layout.top + 'px';
          await sleep(170);
        }
        move(best.from, { where: 'f', index: best.f }, false);
      }
      finishing = false;
    }

    // ── Drawing ────────────────────────────────────────────────────────
    let layout = {};
    function measure() {
      const w = Math.min(96, Math.max(36, (table.clientWidth - 20) / 7.9)); // 7 columns and 6 gaps of 0.15 w
      table.style.setProperty('--w', w + 'px');
      const gap = w * 0.15;
      const x = (i) => 10 + i * (w + gap);
      layout = { w, h: w * 1.4, gap, x, top: 10, row: 10 + w * 1.4 + gap * 1.5 };
    }

    function cardEl(card, at, z) {
      const el = document.createElement('div');
      el.className = 'card ' + (card.up ? 'up' + (red(card) ? ' red' : '') : 'down');
      if (card.up) el.innerHTML = `<span class="tl">${RANK[card.r]}<br>${SYMBOL[card.s]}</span><span class="mid">${SYMBOL[card.s]}</span><span class="br">${RANK[card.r]}<br>${SYMBOL[card.s]}</span>`;
      el.style.left = at.x + 'px';
      el.style.top = at.y + 'px';
      el.style.zIndex = z;
      return el;
    }

    function slot(x, y, cls, data = {}) {
      const el = document.createElement('div');
      el.className = 'slot ' + cls;
      el.style.left = x + 'px';
      el.style.top = y + 'px';
      Object.assign(el.dataset, data);
      table.append(el);
      return el;
    }

    function render() {
      // the bar and ☰ (Bluegleam's): what can be undone, how cards are drawn
      gleam.ui.state('undo', { disabled: !undoStack.length || finishing });
      gleam.ui.state('draw1', { checked: !game.drawThree });
      gleam.ui.state('draw3', { checked: !!game.drawThree });
      measure();
      table.innerHTML = '';
      const { x, top: y0, row } = layout;
      // the deck and what has been drawn
      slot(x(0), y0, 'is-stock').addEventListener('click', draw);
      game.stock.forEach((c, i) => {
        const el = cardEl(c, { x: x(0) + Math.min(i, 4) * 0.5, y: y0 }, i + 1);
        el.addEventListener('click', draw);
        table.append(el);
      });
      const shown = game.waste.slice(-(game.drawThree ? 3 : 1));
      shown.forEach((c, i) => {
        const pos = game.waste.length - shown.length + i;
        const el = cardEl(c, { x: x(1) + i * layout.w * 0.22, y: y0 }, i + 1);
        if (pos === game.waste.length - 1) wire(el, { where: 'w', index: 0, pos });
        table.append(el);
      });
      // the four foundations
      for (let i = 0; i < 4; i++) {
        slot(x(3 + i), y0, 'is-foundation', { suit: SYMBOL[SUITS[i]], where: 'f', index: i });
        const f = game.foundations[i];
        if (f.length) {
          const el = cardEl(last(f), { x: x(3 + i), y: y0 }, 2);
          el.dataset.where = 'f';
          el.dataset.index = i;
          wire(el, { where: 'f', index: i, pos: f.length - 1 });
          table.append(el);
        }
      }
      // the seven columns
      game.tableau.forEach((pile, i) => {
        slot(x(i), row, 'is-column', { where: 't', index: i });
        let yy = row;
        const room = table.clientHeight - row - layout.h - 10;
        const faceUp = Math.max(0.12, Math.min(0.28, room / Math.max(1, pile.length) / layout.h));
        pile.forEach((c, pos) => {
          const el = cardEl(c, { x: x(i), y: yy }, pos + 1);
          el.dataset.where = 't';
          el.dataset.index = i;
          el.dataset.pos = pos;
          if (c.up) wire(el, { where: 't', index: i, pos });
          table.append(el);
          yy += layout.h * (c.up ? faceUp : 0.1);
        });
      });
      document.getElementById('moves').textContent = gleam.t('moves', { n: game.moves });
      document.getElementById('stats').textContent = gleam.t('stats', { w: stats.won, p: stats.played });
      clock();
      if (solved() && !finishing) {
        const b = document.createElement('button');
        b.id = 'finish';
        b.className = 'btn is-primary';
        b.textContent = gleam.t('finish');
        b.onclick = finish;
        table.append(b);
      }
    }

    // ── Dragging, clicking, tapping ────────────────────────────────────
    function wire(el, from) {
      el.addEventListener('dblclick', () => autoMove(from));
      el.addEventListener('pointerdown', (e) => {
        if (e.button !== 0 || finishing) return;
        e.preventDefault();
        const group = [...table.querySelectorAll('.card')].filter((c) => c.dataset.where === from.where && Number(c.dataset.index) === from.index && Number(c.style.zIndex) - 1 >= from.pos);
        const moving = from.where === 't' ? group : [el];
        const start = { x: e.clientX, y: e.clientY };
        const origin = moving.map((c) => ({ c, x: parseFloat(c.style.left), y: parseFloat(c.style.top) }));
        let dragged = false;
        const onMove = (ev) => {
          const dx = ev.clientX - start.x, dy = ev.clientY - start.y;
          if (!dragged && Math.hypot(dx, dy) < 6) return;
          dragged = true;
          origin.forEach(({ c, x, y }) => { c.classList.add('dragging'); c.style.left = x + dx + 'px'; c.style.top = y + dy + 'px'; c.style.pointerEvents = 'none'; });
        };
        const onUp = (ev) => {
          removeEventListener('pointermove', onMove);
          removeEventListener('pointerup', onUp);
          if (!dragged) { // a tap on a touch screen does what a double click does
            if (e.pointerType === 'touch') autoMove(from);
            return;
          }
          const under = document.elementFromPoint(ev.clientX, ev.clientY);
          const target = under?.closest('[data-where]');
          if (!target || !move(from, { where: target.dataset.where, index: Number(target.dataset.index) })) render();
        };
        addEventListener('pointermove', onMove);
        addEventListener('pointerup', onUp);
      });
    }

    // ── Winning: the name for the scores, the cascade, the box ─────────
    function modal(build) {
      document.querySelector('.modal')?.remove();
      const m = document.createElement('div');
      m.className = 'modal';
      m.innerHTML = '<div class="box"></div>';
      build(m.querySelector('.box'), () => m.remove());
      table.append(m);
      return m;
    }

    const el = (tag, cls, text) => { const x = document.createElement(tag); if (cls) x.className = cls; if (text !== undefined) x.textContent = text; return x; };

    function askName() {
      return new Promise((resolve) => {
        modal((box, close) => {
          box.append(el('h2', '', gleam.t('won')), el('p', 'muted', gleam.t('wonIn', { n: game.moves, t: format(game.seconds) })));
          const label = el('label', 'field');
          label.append(el('span', '', gleam.t('yourName')));
          const input = el('input');
          input.maxLength = 30;
          input.value = lastName;
          label.append(input);
          const btns = el('div', 'row-btns');
          const skip = el('button', 'btn', gleam.t('skip'));
          const ok = el('button', 'btn is-primary', gleam.t('save'));
          btns.append(skip, ok);
          box.append(label, btns);
          const done = (name) => { close(); resolve(name); };
          skip.onclick = () => done(null);
          ok.onclick = () => done(input.value.trim() || '—');
          input.addEventListener('keydown', (e) => { if (e.key === 'Enter') ok.click(); });
          setTimeout(() => { input.focus(); input.select(); }, 50);
        });
      });
    }

    function showScores(fresh = null) {
      modal((box, close) => {
        box.append(el('h2', '', gleam.t('scores')));
        const grid = el('div', 'scores');
        [['byTime', (a, b) => a.seconds - b.seconds || a.moves - b.moves], ['byMoves', (a, b) => a.moves - b.moves || a.seconds - b.seconds]].forEach(([title, order]) => {
          const col = el('div');
          col.append(el('h3', '', gleam.t(title)));
          const ol = el('ol');
          [...scores].sort(order).slice(0, 10).forEach((s) => {
            const li = el('li', s === fresh ? 'is-new' : '', `${s.name} — ${format(s.seconds)} · ${s.moves}`);
            ol.append(li);
          });
          if (!scores.length) col.append(el('p', 'muted', gleam.t('nobody'))); else col.append(ol);
          grid.append(col);
        });
        const btns = el('div', 'row-btns');
        const again = el('button', 'btn', gleam.t('again'));
        const shut = el('button', 'btn is-primary', gleam.t('close'));
        again.onclick = () => { close(); newGame(false); };
        shut.onclick = close;
        btns.append(again, shut);
        box.append(grid, btns);
      });
    }

    async function win() {
      const name = await askName();
      let fresh = null;
      if (name) {
        lastName = name;
        fresh = { name, seconds: game.seconds, moves: game.moves, draw: game.drawThree ? 3 : 1, at: Date.now() };
        scores.push(fresh);
        scores = scores.sort((a, b) => a.seconds - b.seconds).slice(0, 50);
        save();
      }
      await cascade();
      showScores(fresh);
    }

    /** The cards leave the foundations bouncing and leave a trail, the way old desktops celebrated. */
    function cascade() {
      if (calm()) return Promise.resolve();
      return new Promise((resolve) => {
        const canvas = el('canvas');
        canvas.id = 'confetti';
        canvas.width = table.clientWidth;
        canvas.height = table.clientHeight;
        table.append(canvas);
        const ctx = canvas.getContext('2d');
        const w = layout.w, h = layout.h;
        const queue = [];
        for (let r = 13; r >= 1; r--) for (let f = 0; f < 4; f++) queue.push({ s: SUITS[f], r, x: layout.x(3 + f), y: layout.top });
        let card = null;
        let frames = 0;
        const drawCard = (c) => {
          ctx.fillStyle = '#fff';
          ctx.strokeStyle = '#999';
          ctx.beginPath();
          ctx.roundRect ? ctx.roundRect(c.x, c.y, w, h, 7) : ctx.rect(c.x, c.y, w, h);
          ctx.fill();
          ctx.stroke();
          ctx.fillStyle = red(c) ? '#d32f2f' : '#222';
          ctx.font = `700 ${w * 0.22}px Georgia, serif`;
          ctx.fillText(RANK[c.r] + SYMBOL[c.s], c.x + 5, c.y + w * 0.25);
          ctx.font = `${w * 0.45}px serif`;
          ctx.fillText(SYMBOL[c.s], c.x + w * 0.3, c.y + h * 0.62);
        };
        const step = () => {
          if (!card) {
            card = queue.shift();
            if (!card) { setTimeout(() => { canvas.remove(); resolve(); }, 400); return; }
            card.vx = (Math.random() * 6 + 2) * (Math.random() < 0.5 ? -1 : 1);
            card.vy = -Math.random() * 6;
          }
          card.vy += 0.6;
          card.x += card.vx;
          card.y += card.vy;
          if (card.y + h > canvas.height) { card.y = canvas.height - h; card.vy *= -0.75; }
          drawCard(card);
          if (card.x + w < 0 || card.x > canvas.width) card = null;
          if (++frames > 2400) queue.length = 0; // never longer than this
          requestAnimationFrame(step);
        };
        canvas.addEventListener('pointerdown', () => { queue.length = 0; card = null; });
        canvas.style.pointerEvents = 'auto';
        requestAnimationFrame(step);
      });
    }

    // ── Time, saving, menu ─────────────────────────────────────────────
    const format = (s) => `${Math.floor(s / 60)}:${String(s % 60).padStart(2, '0')}`;
    function clock() { document.getElementById('time').textContent = gleam.t('time', { t: format(game.seconds) }); }
    setInterval(() => { if (game && !game.won && !finishing && document.visibilityState === 'visible') { game.seconds++; clock(); } }, 1000);

    let saving = null;
    function save() {
      clearTimeout(saving);
      saving = setTimeout(() => gleam.data.set({ game, stats, scores, lastName }, { force: true }).catch(() => {}), 400);
    }

    async function newGame(ask = true) {
      if (ask && game && game.moves && !game.won && !(await gleam.ui.confirm(gleam.t('restart')))) return;
      document.querySelector('.modal')?.remove();
      game = deal(game?.drawThree);
      undoStack = [];
      save();
      render();
    }

    gleam.on('menu', (action) => {
      if (action === 'new') newGame();
      if (action === 'undo' && undoStack.length && !finishing) { game = undoStack.pop(); save(); render(); }
      if (action === 'draw1' || action === 'draw3') { game.drawThree = action === 'draw3'; save(); render(); }
      if (action === 'scores') showScores();
    });
    addEventListener('resize', () => game && !finishing && !document.querySelector('.modal, #confetti') && render());

    gleam.data.get().then((saved) => {
      stats = saved?.stats || stats;
      scores = saved?.scores || [];
      lastName = saved?.lastName || '';
      // a window opened with "New game in a new window" starts fresh; otherwise the saved game goes on
      if (saved?.game && !saved.game.won && gleam.launch.action !== 'new') {
        game = saved.game;
        render();
        if (solved()) setTimeout(finish, 500);
      } else {
        newGame(false);
      }
    });
    })();
  ]]></script>

  <!-- 1.0.0 kept only the game and the statistics: the scores start empty -->
  <migrate from="1.0.0"><![CDATA[ (data) => ({ ...data, scores: data.scores || [], lastName: data.lastName || '' }) ]]></migrate>
</gleam-app>
