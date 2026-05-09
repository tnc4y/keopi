// keopi shared UI bits — icons, illustrations, screen wrapper, formatters

const fmtTL = (n) => `₺${n.toLocaleString('tr-TR')}`;

// ─── Icons (line, 24px) ────────────────────────────────────────
const Icon = {
  home: (a={}) => (
    <svg width={a.size||24} height={a.size||24} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round">
      <path d="M3 11.5L12 4l9 7.5"/><path d="M5 10v9a1 1 0 0 0 1 1h4v-6h4v6h4a1 1 0 0 0 1-1v-9"/>
    </svg>
  ),
  menu: (a={}) => (
    <svg width={a.size||24} height={a.size||24} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round">
      <rect x="3.5" y="4" width="17" height="3.5" rx="1"/><rect x="3.5" y="10.25" width="17" height="3.5" rx="1"/><rect x="3.5" y="16.5" width="17" height="3.5" rx="1"/>
    </svg>
  ),
  star: (a={}) => (
    <svg width={a.size||24} height={a.size||24} viewBox="0 0 24 24" fill={a.fill||'none'} stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round">
      <path d="M12 3l2.5 5.7 6.2.6-4.7 4.2 1.4 6.1L12 16.7 6.6 19.6 8 13.5 3.3 9.3l6.2-.6L12 3z"/>
    </svg>
  ),
  user: (a={}) => (
    <svg width={a.size||24} height={a.size||24} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round">
      <circle cx="12" cy="8" r="4"/><path d="M4 21c0-4.4 3.6-8 8-8s8 3.6 8 8"/>
    </svg>
  ),
  chevR: (a={}) => (
    <svg width={a.size||20} height={a.size||20} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"><path d="M9 6l6 6-6 6"/></svg>
  ),
  chevL: (a={}) => (
    <svg width={a.size||20} height={a.size||20} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"><path d="M15 6l-6 6 6 6"/></svg>
  ),
  close: (a={}) => (
    <svg width={a.size||22} height={a.size||22} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round"><path d="M6 6l12 12M18 6L6 18"/></svg>
  ),
  bag: (a={}) => (
    <svg width={a.size||22} height={a.size||22} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round">
      <path d="M5 7h14l-1 13H6L5 7z"/><path d="M9 7V5a3 3 0 0 1 6 0v2"/>
    </svg>
  ),
  search: (a={}) => (
    <svg width={a.size||20} height={a.size||20} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round"><circle cx="11" cy="11" r="7"/><path d="M16 16l4 4"/></svg>
  ),
  pin: (a={}) => (
    <svg width={a.size||18} height={a.size||18} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round">
      <path d="M12 21s7-7 7-12a7 7 0 0 0-14 0c0 5 7 12 7 12z"/><circle cx="12" cy="9" r="2.5"/>
    </svg>
  ),
  qr: (a={}) => (
    <svg width={a.size||22} height={a.size||22} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round">
      <rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/>
      <path d="M14 14h3v3M14 19h2M19 14v2M21 17v4h-4"/>
    </svg>
  ),
  plus: (a={}) => (
    <svg width={a.size||18} height={a.size||18} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round"><path d="M12 5v14M5 12h14"/></svg>
  ),
  minus: (a={}) => (
    <svg width={a.size||18} height={a.size||18} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round"><path d="M5 12h14"/></svg>
  ),
  heart: (a={}) => (
    <svg width={a.size||20} height={a.size||20} viewBox="0 0 24 24" fill={a.fill||'none'} stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round">
      <path d="M12 20s-7-4.5-7-10a4 4 0 0 1 7-2.6A4 4 0 0 1 19 10c0 5.5-7 10-7 10z"/>
    </svg>
  ),
  bell: (a={}) => (
    <svg width={a.size||22} height={a.size||22} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round">
      <path d="M6 16V11a6 6 0 0 1 12 0v5l1.5 2H4.5L6 16z"/><path d="M10 20a2 2 0 0 0 4 0"/>
    </svg>
  ),
  gift: (a={}) => (
    <svg width={a.size||22} height={a.size||22} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round">
      <rect x="3" y="9" width="18" height="11" rx="1"/><path d="M3 13h18M12 9v11"/><path d="M12 9c-2 0-4-1-4-3s2-3 4-1c2-2 4-1 4 1s-2 3-4 3z"/>
    </svg>
  ),
  clock: (a={}) => (
    <svg width={a.size||20} height={a.size||20} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/></svg>
  ),
  card: (a={}) => (
    <svg width={a.size||22} height={a.size||22} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round"><rect x="3" y="6" width="18" height="13" rx="2"/><path d="M3 11h18M7 16h3"/></svg>
  ),
  apple: (a={}) => (
    <svg width={a.size||22} height={a.size||22} viewBox="0 0 24 24" fill="currentColor"><path d="M16.4 12.5c0-2.4 2-3.5 2-3.6-1.1-1.6-2.8-1.8-3.4-1.8-1.4-.2-2.8.8-3.5.8-.7 0-1.9-.8-3.1-.8-1.6 0-3 .9-3.8 2.4-1.7 2.8-.4 7 1.2 9.3.8 1.1 1.7 2.4 3 2.3 1.2-.1 1.7-.8 3.1-.8 1.5 0 1.9.8 3.2.8 1.3 0 2.2-1.1 3-2.3.9-1.3 1.3-2.6 1.3-2.7-.1 0-2.5-1-2.5-3.6zm-2.4-6.6c.7-.8 1.1-1.9 1-3-.9 0-2.1.6-2.7 1.4-.6.7-1.2 1.8-1 2.9 1 .1 2-.5 2.7-1.3z"/></svg>
  ),
  cart: (a={}) => (
    <svg width={a.size||20} height={a.size||20} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round">
      <path d="M3 4h2l2.5 11.5a2 2 0 0 0 2 1.5h7a2 2 0 0 0 2-1.5L21 8H6"/><circle cx="9" cy="20" r="1.5"/><circle cx="17" cy="20" r="1.5"/>
    </svg>
  ),
  check: (a={}) => (
    <svg width={a.size||20} height={a.size||20} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round"><path d="M5 12l5 5 9-11"/></svg>
  ),
  cup: (a={}) => (
    <svg width={a.size||20} height={a.size||20} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round">
      <path d="M5 8h12v6a4 4 0 0 1-4 4H9a4 4 0 0 1-4-4V8z"/><path d="M17 10h2a2 2 0 0 1 0 4h-2"/><path d="M8 4c0 1 1 1 1 2s-1 1-1 2M12 4c0 1 1 1 1 2s-1 1-1 2"/>
    </svg>
  ),
  cake: (a={}) => (
    <svg width={a.size||22} height={a.size||22} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round">
      <path d="M4 14c2 1 4-1 8-1s6 2 8 1v6H4v-6z"/><path d="M4 14a3 3 0 0 1 3-3h10a3 3 0 0 1 3 3"/><path d="M12 6v5M12 4l1 2-1 1-1-1 1-2z"/>
    </svg>
  ),
  truck: (a={}) => (
    <svg width={a.size||22} height={a.size||22} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round">
      <rect x="2" y="7" width="11" height="9" rx="1"/><path d="M13 10h4l3 3v3h-7"/><circle cx="6" cy="18" r="2"/><circle cx="17" cy="18" r="2"/>
    </svg>
  ),
  flame: (a={}) => (
    <svg width={a.size||18} height={a.size||18} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round">
      <path d="M12 22s-6-3-6-9c0-3 2-5 3-7 1 2 2 2 2 4 1-2 3-3 3-6 3 3 4 6 4 9 0 6-6 9-6 9z"/>
    </svg>
  ),
  share: (a={}) => (
    <svg width={a.size||20} height={a.size||20} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round">
      <circle cx="6" cy="12" r="2.5"/><circle cx="17" cy="6" r="2.5"/><circle cx="17" cy="18" r="2.5"/><path d="M8 11l7-4M8 13l7 4"/>
    </svg>
  ),
};

// ─── Coffee illustration tiles (SVG, no PNGs) ─────────────────
function CoffeeTile({ kind = 'cup', size = 80, fg = '#3D2817', bg = '#E8C9A8' }) {
  // Stylized coffee/food tile, geometric
  const tiles = {
    cup: (
      <g>
        <ellipse cx="40" cy="24" rx="22" ry="6" fill="none" stroke={fg} strokeWidth="2"/>
        <path d="M18 24 L22 60 Q22 68 30 68 L50 68 Q58 68 58 60 L62 24" fill="none" stroke={fg} strokeWidth="2"/>
        <path d="M58 32 Q70 32 70 42 Q70 52 58 52" fill="none" stroke={fg} strokeWidth="2"/>
        <ellipse cx="40" cy="24" rx="18" ry="4" fill={fg} opacity="0.8"/>
      </g>
    ),
    bean: (
      <g>
        <ellipse cx="40" cy="40" rx="22" ry="28" fill={fg} transform="rotate(-20 40 40)"/>
        <path d="M28 22 Q42 40 28 60" stroke={bg} strokeWidth="2.5" fill="none" transform="rotate(-20 40 40)"/>
      </g>
    ),
    croissant: (
      <g>
        <path d="M14 50 Q20 28 40 24 Q60 28 66 50 Q60 56 50 52 Q40 48 30 52 Q20 56 14 50z" fill={fg}/>
        <path d="M22 44 L28 40 M32 42 L38 38 M42 42 L48 38 M52 44 L58 40" stroke={bg} strokeWidth="1.5"/>
      </g>
    ),
    leaf: (
      <g>
        <path d="M40 14 Q60 20 60 40 Q60 60 40 66 Q20 60 20 40 Q20 20 40 14z" fill={fg}/>
        <path d="M40 14 Q40 40 30 60" stroke={bg} strokeWidth="2" fill="none"/>
      </g>
    ),
    cake: (
      <g>
        <rect x="14" y="40" width="52" height="22" rx="2" fill={fg}/>
        <path d="M14 40 Q26 36 40 40 T66 40" stroke={bg} strokeWidth="2" fill="none"/>
        <rect x="36" y="22" width="2" height="14" fill={fg}/>
        <rect x="42" y="22" width="2" height="14" fill={fg}/>
        <path d="M36 22 Q37 18 38 22 M42 22 Q43 18 44 22" stroke={fg} fill="none" strokeWidth="2"/>
      </g>
    ),
    iced: (
      <g>
        <path d="M22 22 H58 L54 64 Q54 68 50 68 L30 68 Q26 68 26 64z" fill="none" stroke={fg} strokeWidth="2"/>
        <rect x="28" y="32" width="10" height="10" fill={fg} opacity="0.6" transform="rotate(15 33 37)"/>
        <rect x="42" y="42" width="8" height="8" fill={fg} opacity="0.4" transform="rotate(-10 46 46)"/>
        <rect x="34" y="50" width="9" height="9" fill={fg} opacity="0.5" transform="rotate(20 38 54)"/>
      </g>
    ),
    gift: (
      <g>
        <rect x="16" y="32" width="48" height="32" rx="2" fill={fg}/>
        <rect x="16" y="32" width="48" height="6" fill={bg} opacity="0.4"/>
        <rect x="36" y="32" width="8" height="32" fill={bg} opacity="0.4"/>
        <path d="M36 32 Q28 22 32 22 Q40 22 40 32 Q40 22 48 22 Q52 22 44 32" fill={fg} stroke={bg} strokeWidth="1.5"/>
      </g>
    ),
  };
  return (
    <svg width={size} height={size} viewBox="0 0 80 80">
      <rect width="80" height="80" rx="14" fill={bg}/>
      {tiles[kind] || tiles.cup}
    </svg>
  );
}

// Map a product id/cat to an illustration kind
function illuFor(p) {
  if (!p) return 'cup';
  if (p.cat === 'cold') return p.id === 'c1' ? 'iced' : 'iced';
  if (p.cat === 'hot') return 'cup';
  if (p.cat === 'tea') return 'leaf';
  if (p.cat === 'food') return 'croissant';
  if (p.cat === 'sweet') return 'cake';
  return 'cup';
}

// ─── Phone screen wrapper (handles padding for status + tab bar) ──
function Screen({ label, scroll = true, dark, padTop = 60, padBottom = 90, children, style = {} }) {
  return (
    <div
      data-screen-label={label}
      className={scroll ? 'kp-scroll' : ''}
      style={{
        position: 'absolute',
        inset: 0,
        background: 'var(--bg)',
        color: 'var(--text)',
        paddingTop: padTop,
        paddingBottom: padBottom,
        ...style,
      }}
    >
      {children}
    </div>
  );
}

// ─── Bottom tab bar ────────────────────────────────────────────
function TabBar({ active, onChange }) {
  const tabs = [
    { id: 'home', label: 'Ana', icon: 'home' },
    { id: 'menu', label: 'Menü', icon: 'menu' },
    { id: 'loyalty', label: 'Sadakat', icon: 'star' },
    { id: 'profile', label: 'Profil', icon: 'user' },
  ];
  return (
    <div className="kp-tabbar">
      {tabs.map(t => (
        <button key={t.id} className={`kp-tab ${active === t.id ? 'active' : ''}`} onClick={() => onChange(t.id)}>
          {Icon[t.icon]({ size: 22 })}
          <span>{t.label}</span>
        </button>
      ))}
    </div>
  );
}

Object.assign(window, { Icon, CoffeeTile, illuFor, Screen, TabBar, fmtTL });
