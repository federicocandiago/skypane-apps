<?xml version="1.0" encoding="UTF-8"?>
<!--
  clock.gleam — a clock for the desktop, and the example of an app made only of widgets (kind="widget").
  The same page draws the widget (gleam.launch.widget is "clock") and the app's window, which only says how to
  add it. A click on the clock turns it from hands to digits and back; each clock on the desktop remembers its own
  face (gleam.widget.config). Read BLUEGLEAM-APPS.md, «Widgets», for the whole story.
-->
<gleam-app id="net.bluegleam.clock" version="1.0.0" author="Bluegleam" kind="widget">

  <translations>
    <lang code="en" default="true"><![CDATA[{
      "name": "Clock",
      "description": "A clock for the desktop, with hands or with digits: the example of a widget.",
      "info": "Add it with a right click on the desktop › Add a widget…, then Clock.\nA click on the clock changes its face.",
      "clock": "Clock",
      "clockAbout": "The time and the date, with hands or with digits: a click changes the face.",
      "how": "The clock lives on the desktop: right click on it › Add a widget…, then choose Clock.",
      "change": "Click to change the face"
    }]]></lang>
    <lang code="it"><![CDATA[{
      "name": "Orologio",
      "description": "Un orologio per la scrivania, con le lancette o con le cifre: l'esempio di un widget.",
      "info": "Aggiungilo con un clic destro sulla scrivania › Aggiungi un widget…, poi Orologio.\nUn clic sull'orologio ne cambia il quadrante.",
      "clock": "Orologio",
      "clockAbout": "L'ora e la data, con le lancette o con le cifre: un clic cambia il quadrante.",
      "how": "L'orologio sta sulla scrivania: clic destro › Aggiungi un widget…, poi scegli Orologio.",
      "change": "Clic per cambiare quadrante"
    }]]></lang>
  </translations>

  <icon><![CDATA[<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48"><defs><radialGradient id="f" cx="40%" cy="32%" r="70%"><stop offset="0" stop-color="#fff"/><stop offset="1" stop-color="#cfe3f3"/></radialGradient><linearGradient id="r" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#5cc4f2"/><stop offset="1" stop-color="#1d78c9"/></linearGradient></defs><circle cx="24" cy="24" r="21" fill="url(#r)"/><circle cx="24" cy="24" r="17" fill="url(#f)"/><path d="M24 13v11l7 5" stroke="#1c3d5a" stroke-width="3" stroke-linecap="round" fill="none"/><circle cx="24" cy="24" r="2.4" fill="#e8553f"/><path d="M10 18a15 15 0 0 1 28 0c-8-4-20-4-28 0Z" fill="#fff" opacity=".55"/></svg>]]></icon>

  <!-- the one widget: about as big as a weather widget, square enough for the round face -->
  <widget kind="clock" label="clock" description="clockAbout" width="200" height="200"/>

  <window width="360" height="220"/>

  <style><![CDATA[
    /* the window: two lines on how to add the clock */
    .how { margin: 0; padding: 24px; display: grid; gap: 12px; place-items: center; height: 100%; box-sizing: border-box; text-align: center; color: var(--gleam-muted); }

    /*
     * The widget, made of the theme's own parts, with no word about any theme: the dial is one of its buttons
     * (.btn), the cap of the hands its main button (.btn.is-primary), the digits two of its keys; colours, type,
     * corners and borders are its variables. So it is glossy in Universe, glass in Skyglass, flat in Flat, a square
     * of phosphor in Amber (whose corners are square: a dial takes the theme's roundness, in full).
     */
    .clock { height: 100%; box-sizing: border-box; padding: 16px 10px 8px; display: grid; grid-template-rows: minmax(0, 1fr) auto; justify-items: center; align-items: center; user-select: none; }
    .clock .btn { cursor: pointer; font-family: var(--gleam-font); }
    .date { margin-top: 5px; font-size: 12px; color: var(--widget-muted); text-shadow: var(--widget-text-shadow); font-family: var(--gleam-font); white-space: nowrap; }

    /* hands: the dial is a button of the theme, round unless the theme is square */
    .dial.btn { position: relative; height: 100%; max-height: 100%; aspect-ratio: 1; width: auto; min-height: 0; padding: 0; border-radius: calc(var(--gleam-radius) * 100); }
    .dial > * { position: absolute; inset: 0; pointer-events: none; }
    .mark::before { content: ""; position: absolute; left: 50%; top: 5%; width: 1.5px; height: 4%; translate: -50% 0; background: var(--gleam-muted); border-radius: 1px; opacity: .7; }
    .mark.is-hour::before { width: 3px; height: 8%; background: var(--gleam-text); opacity: 1; border-radius: var(--gleam-radius-small); }
    .num { inset: auto; width: 2em; text-align: center; font-size: 12px; font-weight: 600; line-height: 1; color: var(--gleam-text); }
    .num.n12 { top: 16%; left: 50%; translate: -50% 0; } .num.n6 { bottom: 16%; left: 50%; translate: -50% 0; }
    .num.n3 { right: 13%; top: 50%; translate: 0 -50%; } .num.n9 { left: 13%; top: 50%; translate: 0 -50%; }
    .hand::before { content: ""; position: absolute; left: 50%; bottom: 50%; translate: -50% 0; background: var(--gleam-text); border-radius: var(--gleam-radius-small); }
    .hand.h::before { width: 5px; height: 26%; }
    .hand.m::before { width: 3.5px; height: 37%; }
    .hand.s::before { width: 1.5px; height: 42%; bottom: 42%; background: var(--gleam-accent); }
    .cap.btn { inset: auto; left: 50%; top: 50%; width: 13%; height: 13%; min-height: 0; padding: 0; translate: -50% -50%; border-radius: calc(var(--gleam-radius) * 100); }

    /* digits: two keys of the theme, the colon between them, the seconds as a bar of the main colour */
    .digits { display: grid; gap: 10px; justify-items: center; align-self: center; }
    .keys { display: flex; align-items: center; gap: 4px; }
    .key.btn { min-height: 0; padding: 6px 10px; font-size: 38px; font-weight: 600; line-height: 1; font-variant-numeric: tabular-nums; } /* its corners: the theme's own buttons' */
    .colon { font-size: 30px; font-weight: 700; color: var(--widget-text); text-shadow: var(--widget-text-shadow); transition: opacity .2s; }
    .colon.is-off { opacity: .25; }
    .seconds { width: 100%; height: 6px; border-radius: 99px; background: var(--widget-tile); overflow: hidden; }
    .seconds i { display: block; height: 100%; width: 0; background: var(--gleam-primary); border-radius: inherit; transition: width .3s linear; }
  ]]></style>

  <script><![CDATA[
    if (gleam.launch.widget === 'clock') widget(); else howTo();

    /** The app's window: there is nothing to do in it but learn where the clock lives. */
    function howTo() {
      document.body.innerHTML = '<p class="how"><span style="font-size:44px">🕓</span><span></span></p>';
      document.querySelector('.how span:last-child').textContent = gleam.t('how');
    }

    /** The widget: hands or digits, whichever this clock was left on; a click switches and remembers. */
    async function widget() {
      const box = document.createElement('div');
      box.className = 'clock';
      document.body.append(box);
      let face = (await gleam.widget.config.get())?.face || 'hands';

      const hands = () => {
        const marks = [...Array(60)].map((_, i) => `<span class="mark${i % 5 ? '' : ' is-hour'}" style="rotate:${i * 6}deg"></span>`).join('');
        box.innerHTML = `<button type="button" class="btn dial">${marks}
            <span class="num n12">12</span><span class="num n3">3</span><span class="num n6">6</span><span class="num n9">9</span>
            <span class="hand h"></span><span class="hand m"></span><span class="hand s"></span><span class="btn is-primary cap"></span></button>
          <div class="date"></div>`;
      };
      const digits = () => {
        box.innerHTML = `<div class="digits"><div class="keys"><button type="button" class="btn key hh"></button><span class="colon">:</span><button type="button" class="btn key mm"></button></div>
          <div class="seconds"><i></i></div></div><div class="date"></div>`;
      };
      const $ = (sel) => box.querySelector(sel);

      function tick() {
        const now = new Date();
        const h = now.getHours(), m = now.getMinutes(), s = now.getSeconds();
        if (face === 'hands') {
          $('.h').style.rotate = `${(h % 12) * 30 + m / 2}deg`;
          $('.m').style.rotate = `${m * 6 + s / 10}deg`;
          $('.s').style.rotate = `${s * 6}deg`;
        } else {
          const [hh, mm] = now.toLocaleTimeString(gleam.lang, { hour: '2-digit', minute: '2-digit', hour12: false }).split(/\D+/);
          $('.hh').textContent = hh; $('.mm').textContent = mm;
          $('.colon').classList.toggle('is-off', s % 2 === 1);
          $('.seconds i').style.width = `${(s / 59) * 100}%`;
        }
        $('.date').textContent = now.toLocaleDateString(gleam.lang, { weekday: 'long', day: 'numeric', month: 'long' });
      }
      const draw = () => { (face === 'hands' ? hands : digits)(); box.title = gleam.t('change'); tick(); };

      box.addEventListener('click', (e) => {
        if (!e.target.closest('.btn')) return; // the dial or the keys: the clock itself
        face = face === 'hands' ? 'digits' : 'hands';
        draw();
        gleam.widget.config.set({ face }); // this clock only: another clock on the desktop keeps its own face
      });
      draw();
      setInterval(tick, 1000);
    }
  ]]></script>
</gleam-app>
