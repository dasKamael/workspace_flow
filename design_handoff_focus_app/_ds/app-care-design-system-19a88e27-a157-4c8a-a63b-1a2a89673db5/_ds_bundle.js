/* @ds-bundle: {"format":3,"namespace":"AppCareDesignSystem_19a88e","components":[],"sourceHashes":{"ui_kits/website/App.jsx":"cb6a65b51837","ui_kits/website/Header.jsx":"8b75a24c756a","ui_kits/website/Primitives.jsx":"153097c03095","ui_kits/website/SectionsA.jsx":"f6a164847876","ui_kits/website/SectionsB.jsx":"2f784c283a5a","ui_kits/website/SectionsC.jsx":"17cb60418e44","ui_kits/website/SectionsD.jsx":"2586380064cf"},"inlinedExternals":[],"unexposedExports":[]} */

(() => {

const __ds_ns = (window.AppCareDesignSystem_19a88e = window.AppCareDesignSystem_19a88e || {});

const __ds_scope = {};

(__ds_ns.__errors = __ds_ns.__errors || []);

// ui_kits/website/App.jsx
try { (() => {
// App-Care UI Kit — App assembly + interactivity

function Dialog({
  open,
  onClose,
  children
}) {
  if (!open) return null;
  return /*#__PURE__*/React.createElement("div", {
    onClick: onClose,
    style: {
      position: 'fixed',
      inset: 0,
      zIndex: 100,
      background: 'rgba(15,23,42,0.5)',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      padding: '1rem'
    }
  }, /*#__PURE__*/React.createElement("div", {
    onClick: e => e.stopPropagation(),
    style: {
      background: '#fff',
      borderRadius: 'var(--radius-xl)',
      boxShadow: 'var(--shadow-xl)',
      padding: '2rem',
      maxWidth: '24rem',
      width: '100%',
      textAlign: 'center'
    }
  }, children));
}
function Toast({
  msg
}) {
  if (!msg) return null;
  return /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'fixed',
      bottom: '1.5rem',
      left: '50%',
      transform: 'translateX(-50%)',
      zIndex: 120,
      background: 'var(--brand-950)',
      color: '#fff',
      padding: '.75rem 1.25rem',
      borderRadius: 'var(--radius-lg)',
      boxShadow: 'var(--shadow-xl)',
      fontSize: 'var(--text-sm)',
      display: 'flex',
      alignItems: 'center',
      gap: '.5rem'
    }
  }, /*#__PURE__*/React.createElement(Icon, {
    name: "check20",
    size: 16,
    style: {
      color: 'var(--brand-400)'
    }
  }), msg);
}
function App() {
  const [active, setActive] = React.useState('home');
  const [signedIn, setSignedIn] = React.useState(false);
  const [dialog, setDialog] = React.useState(false);
  const [toast, setToast] = React.useState('');
  const refs = {
    home: React.useRef(),
    leistungen: React.useRef(),
    pakete: React.useRef(),
    kontakt: React.useRef()
  };
  const showToast = m => {
    setToast(m);
    setTimeout(() => setToast(''), 2600);
  };
  const navigate = id => {
    if (id === 'blog') {
      showToast('Blog — im echten Produkt eine eigene Seite');
      return;
    }
    const map = {
      home: 'home',
      leistungen: 'leistungen',
      pakete: 'pakete',
      kontakt: 'kontakt'
    };
    const target = refs[map[id]];
    if (target && target.current) {
      const y = target.current.getBoundingClientRect().top + window.scrollY - 70;
      window.scrollTo({
        top: y,
        behavior: 'smooth'
      });
      setActive(id === 'home' ? 'home' : id);
    }
  };

  // scroll-spy
  React.useEffect(() => {
    const onScroll = () => {
      const order = ['kontakt', 'pakete', 'leistungen', 'home'];
      const pos = window.scrollY + 120;
      for (const id of order) {
        const el = refs[id].current;
        if (el && el.offsetTop <= pos) {
          setActive(id);
          break;
        }
      }
    };
    window.addEventListener('scroll', onScroll, {
      passive: true
    });
    return () => window.removeEventListener('scroll', onScroll);
  }, []);
  return /*#__PURE__*/React.createElement(React.Fragment, null, /*#__PURE__*/React.createElement(Header, {
    active: active,
    onNavigate: navigate,
    signedIn: signedIn,
    onToggleAuth: () => {
      setSignedIn(true);
      showToast('Eingeloggt — Header zeigt jetzt „Zum Cockpit"');
    }
  }), /*#__PURE__*/React.createElement("main", null, /*#__PURE__*/React.createElement("div", {
    ref: refs.home
  }, /*#__PURE__*/React.createElement(Hero, {
    onNavigate: navigate
  })), /*#__PURE__*/React.createElement("div", {
    ref: refs.leistungen
  }, /*#__PURE__*/React.createElement(Leistungen, null)), /*#__PURE__*/React.createElement(Realitaet, null), /*#__PURE__*/React.createElement(Solution, {
    onDownload: () => setDialog(true)
  }), /*#__PURE__*/React.createElement(CockpitCycle, null), /*#__PURE__*/React.createElement("div", {
    ref: refs.pakete
  }, /*#__PURE__*/React.createElement(Packages, {
    onRequest: () => navigate('kontakt')
  })), /*#__PURE__*/React.createElement(References, null), /*#__PURE__*/React.createElement(TeamTeaser, null), /*#__PURE__*/React.createElement(Whitepaper, {
    onSubmit: () => {}
  }), /*#__PURE__*/React.createElement("div", {
    ref: refs.kontakt
  }, /*#__PURE__*/React.createElement(FinalCTA, {
    onNavigate: navigate
  }))), /*#__PURE__*/React.createElement(Footer, null), /*#__PURE__*/React.createElement(Dialog, {
    open: dialog,
    onClose: () => setDialog(false)
  }, /*#__PURE__*/React.createElement("h3", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 700,
      color: 'var(--slate-900)',
      fontSize: 'var(--text-lg)',
      marginBottom: '.5rem'
    }
  }, "Kommt bald"), /*#__PURE__*/React.createElement("p", {
    style: {
      color: 'var(--slate-500)',
      fontSize: 'var(--text-sm)',
      lineHeight: 1.6,
      marginBottom: '1.25rem'
    }
  }, "Das Beispiel-PDF steht in K\xFCrze zum Download bereit. Sprich uns gerne direkt an \u2014 wir schicken es dir zu."), /*#__PURE__*/React.createElement("button", {
    onClick: () => setDialog(false),
    style: {
      background: 'transparent',
      border: 0,
      fontSize: 'var(--text-sm)',
      color: 'var(--slate-400)'
    }
  }, "Schlie\xDFen")), /*#__PURE__*/React.createElement(Toast, {
    msg: toast
  }));
}
ReactDOM.createRoot(document.getElementById('root')).render(/*#__PURE__*/React.createElement(App, null));
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/website/App.jsx", error: String((e && e.message) || e) }); }

// ui_kits/website/Header.jsx
try { (() => {
// App-Care UI Kit — sticky Header with nav, beta tag, auth-aware CTA, mobile menu

function Logo({
  onDark = false,
  size = 'xl'
}) {
  const fs = size === 'lg' ? '1.125rem' : '1.25rem';
  return /*#__PURE__*/React.createElement("span", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 800,
      fontSize: fs,
      letterSpacing: '-0.02em',
      whiteSpace: 'nowrap',
      color: onDark ? '#fff' : 'var(--slate-900)'
    }
  }, "App-Care", /*#__PURE__*/React.createElement("span", {
    style: {
      color: onDark ? 'var(--brand-500)' : 'var(--brand-600)'
    }
  }, "."));
}
function Header({
  active,
  onNavigate,
  signedIn,
  onToggleAuth
}) {
  const [menuOpen, setMenuOpen] = React.useState(false);
  const links = [{
    id: 'leistungen',
    label: 'Leistungen'
  }, {
    id: 'pakete',
    label: 'Pakete'
  }, {
    id: 'blog',
    label: 'Blog'
  }, {
    id: 'kontakt',
    label: 'Kontakt'
  }];
  const go = id => e => {
    e.preventDefault();
    setMenuOpen(false);
    onNavigate && onNavigate(id);
  };
  return /*#__PURE__*/React.createElement("header", {
    style: {
      position: 'sticky',
      top: 0,
      zIndex: 50,
      background: 'rgba(255,255,255,0.9)',
      backdropFilter: 'saturate(180%) blur(8px)',
      borderBottom: '1px solid var(--border)'
    }
  }, /*#__PURE__*/React.createElement("div", {
    className: "section-container"
  }, /*#__PURE__*/React.createElement("nav", {
    style: {
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'space-between',
      height: '4rem'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: '.5rem'
    }
  }, /*#__PURE__*/React.createElement("a", {
    href: "#",
    onClick: go('home')
  }, /*#__PURE__*/React.createElement(Logo, null)), /*#__PURE__*/React.createElement("span", {
    className: "badge-beta"
  }, "Beta")), /*#__PURE__*/React.createElement("div", {
    className: "hide-mobile",
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: '.25rem'
    }
  }, links.map(l => /*#__PURE__*/React.createElement("a", {
    key: l.id,
    href: "#",
    onClick: go(l.id),
    className: "nav-link",
    style: {
      position: 'relative',
      padding: '.5rem 1rem',
      fontSize: 'var(--text-sm)',
      fontWeight: 500,
      color: active === l.id ? 'var(--brand-600)' : 'var(--slate-500)',
      transition: 'color .2s'
    }
  }, l.label, active === l.id && /*#__PURE__*/React.createElement("span", {
    style: {
      position: 'absolute',
      bottom: 0,
      left: '1rem',
      right: '1rem',
      height: 2,
      background: 'var(--brand-600)',
      borderRadius: 999
    }
  })))), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: '.75rem'
    }
  }, signedIn ? /*#__PURE__*/React.createElement(Button, {
    variant: "primary",
    size: "sm",
    href: "#",
    onClick: e => {
      e.preventDefault();
    }
  }, "Zum Cockpit") : /*#__PURE__*/React.createElement(React.Fragment, null, /*#__PURE__*/React.createElement("a", {
    href: "#",
    onClick: e => {
      e.preventDefault();
      onToggleAuth && onToggleAuth();
    },
    className: "hide-mobile",
    style: {
      fontFamily: 'var(--font-display)',
      fontSize: 'var(--text-sm)',
      fontWeight: 500,
      color: 'var(--slate-500)'
    }
  }, "Login"), /*#__PURE__*/React.createElement("a", {
    href: "#",
    onClick: go('pakete'),
    className: "hide-mobile"
  }, /*#__PURE__*/React.createElement("span", {
    className: "btn btn-primary btn-sm"
  }, "Beta anfragen"))), /*#__PURE__*/React.createElement("button", {
    className: "show-mobile",
    onClick: () => setMenuOpen(!menuOpen),
    "aria-label": "Men\xFC",
    style: {
      background: 'transparent',
      border: 0,
      padding: '.5rem',
      borderRadius: 'var(--radius-lg)',
      color: 'var(--slate-500)',
      display: 'none'
    }
  }, /*#__PURE__*/React.createElement(Icon, {
    name: menuOpen ? 'close' : 'menu',
    size: 20
  })))), menuOpen && /*#__PURE__*/React.createElement("div", {
    className: "show-mobile",
    style: {
      borderTop: '1px solid var(--border)',
      padding: '.75rem 0',
      display: 'none'
    }
  }, links.map(l => /*#__PURE__*/React.createElement("a", {
    key: l.id,
    href: "#",
    onClick: go(l.id),
    style: {
      display: 'block',
      padding: '.75rem 1rem',
      fontSize: 'var(--text-sm)',
      fontWeight: 500,
      borderRadius: 'var(--radius-lg)',
      color: active === l.id ? 'var(--brand-600)' : 'var(--slate-600)',
      background: active === l.id ? 'var(--brand-50)' : 'transparent'
    }
  }, l.label)), /*#__PURE__*/React.createElement("div", {
    style: {
      padding: '.75rem 1rem 0'
    }
  }, /*#__PURE__*/React.createElement("a", {
    href: "#",
    onClick: go('pakete')
  }, /*#__PURE__*/React.createElement("span", {
    className: "btn btn-primary btn-sm",
    style: {
      width: '100%'
    }
  }, "Beta anfragen"))))));
}
Object.assign(window, {
  Header,
  Logo
});
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/website/Header.jsx", error: String((e && e.message) || e) }); }

// ui_kits/website/Primitives.jsx
try { (() => {
// App-Care UI Kit — shared primitives (Icons, Button, Badge, Eyebrow, SectionHeader)

// Heroicons (outline 24 / solid 20) path data — the brand's icon system.
const ICONS = {
  arrowRight: {
    v: 24,
    d: 'M17 8l4 4m0 0l-4 4m4-4H3',
    stroke: true
  },
  chevronRight: {
    v: 24,
    d: 'M9 5l7 7-7 7',
    stroke: true
  },
  caretUp: {
    v: 24,
    d: 'M5 15l7-7 7 7',
    stroke: true,
    w: 2.5
  },
  check20: {
    v: 20,
    d: 'M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z',
    solid: true
  },
  chart: {
    v: 24,
    d: 'M3 13.125C3 12.504 3.504 12 4.125 12h2.25c.621 0 1.125.504 1.125 1.125v6.75C7.5 20.496 6.996 21 6.375 21h-2.25A1.125 1.125 0 0 1 3 19.875v-6.75ZM9.75 8.625c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125v11.25c0 .621-.504 1.125-1.125 1.125h-2.25a1.125 1.125 0 0 1-1.125-1.125V8.625ZM16.5 4.125c0-.621.504-1.125 1.125-1.125h2.25C20.496 3 21 3.504 21 4.125v15.75c0 .621-.504 1.125-1.125 1.125h-2.25a1.125 1.125 0 0 1-1.125-1.125V4.125Z',
    stroke: true
  },
  chat: {
    v: 24,
    d: 'M8.625 12a.375.375 0 1 1-.75 0 .375.375 0 0 1 .75 0Zm0 0H8.25m4.125 0a.375.375 0 1 1-.75 0 .375.375 0 0 1 .75 0Zm0 0H12m4.125 0a.375.375 0 1 1-.75 0 .375.375 0 0 1 .75 0Zm0 0h-.375M21 12c0 4.556-4.03 8.25-9 8.25a9.764 9.764 0 0 1-2.555-.337A5.972 5.972 0 0 1 5.41 20.97a5.969 5.969 0 0 1-.474-.065 4.48 4.48 0 0 0 .978-2.025c.09-.457-.133-.901-.467-1.226C3.93 16.178 3 14.189 3 12c0-4.556 4.03-8.25 9-8.25s9 3.694 9 8.25Z',
    stroke: true
  },
  clock: {
    v: 24,
    d: 'M12 6v6h4.5m4.5 0a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z',
    stroke: true
  },
  mapPin: {
    v: 24,
    d: 'M15 10.5a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z M19.5 10.5c0 7.142-7.5 11.25-7.5 11.25S4.5 17.642 4.5 10.5a7.5 7.5 0 1 1 15 0Z',
    stroke: true
  },
  info: {
    v: 24,
    d: 'M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z',
    stroke: true
  },
  loop: {
    v: 24,
    d: 'M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15',
    stroke: true,
    w: 1.5
  },
  menu: {
    v: 24,
    d: 'M4 6h16M4 12h16M4 18h16',
    stroke: true
  },
  close: {
    v: 24,
    d: 'M6 18L18 6M6 6l12 12',
    stroke: true
  }
};
function Icon({
  name,
  size = 16,
  width,
  style,
  className = ''
}) {
  const ic = ICONS[name];
  if (!ic) return null;
  const sw = width || ic.w || 2;
  return /*#__PURE__*/React.createElement("svg", {
    className: `icon ${className}`,
    width: size,
    height: size,
    viewBox: `0 0 ${ic.v} ${ic.v}`,
    fill: ic.solid ? 'currentColor' : 'none',
    stroke: ic.solid ? 'none' : 'currentColor',
    strokeWidth: ic.solid ? 0 : sw,
    strokeLinecap: "round",
    strokeLinejoin: "round",
    style: style,
    "aria-hidden": "true"
  }, /*#__PURE__*/React.createElement("path", {
    d: ic.d,
    fillRule: ic.solid ? 'evenodd' : undefined,
    clipRule: ic.solid ? 'evenodd' : undefined
  }));
}
function Button({
  children,
  variant = 'primary',
  size = 'md',
  icon,
  href = '#',
  onClick,
  style
}) {
  const cls = `btn btn-${variant} btn-${size}`;
  return /*#__PURE__*/React.createElement("a", {
    href: href,
    className: cls,
    onClick: onClick,
    style: style
  }, children, icon && /*#__PURE__*/React.createElement(Icon, {
    name: icon,
    size: size === 'lg' ? 16 : 14
  }));
}
function Badge({
  children,
  variant = 'brand',
  style
}) {
  return /*#__PURE__*/React.createElement("span", {
    className: `badge badge-${variant}`,
    style: style
  }, children);
}
function Eyebrow({
  children,
  center = false,
  onDark = false
}) {
  return /*#__PURE__*/React.createElement("div", {
    className: `eyebrow ${center ? 'center' : ''} ${onDark ? 'on-dark' : ''}`
  }, /*#__PURE__*/React.createElement("span", {
    className: "rule"
  }), /*#__PURE__*/React.createElement("span", {
    className: "label"
  }, children), center && /*#__PURE__*/React.createElement("span", {
    className: "rule"
  }));
}
function SectionHeader({
  eyebrow,
  title,
  subtitle,
  center = true,
  onDark = false,
  maxWidth = 640
}) {
  return /*#__PURE__*/React.createElement("div", {
    style: {
      textAlign: center ? 'center' : 'left',
      maxWidth: center ? maxWidth : 'none',
      margin: center ? '0 auto 4rem' : '0 0 3rem'
    }
  }, eyebrow && /*#__PURE__*/React.createElement("div", {
    style: {
      marginBottom: '1.5rem'
    }
  }, /*#__PURE__*/React.createElement(Eyebrow, {
    center: center,
    onDark: onDark
  }, eyebrow)), /*#__PURE__*/React.createElement("h2", {
    className: "section-title",
    style: {
      marginBottom: '1rem',
      color: onDark ? '#fff' : undefined
    }
  }, title), subtitle && /*#__PURE__*/React.createElement("p", {
    className: "section-subtitle",
    style: {
      color: onDark ? 'var(--slate-400)' : undefined
    }
  }, subtitle));
}
Object.assign(window, {
  Icon,
  Button,
  Badge,
  Eyebrow,
  SectionHeader
});
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/website/Primitives.jsx", error: String((e && e.message) || e) }); }

// ui_kits/website/SectionsA.jsx
try { (() => {
// App-Care UI Kit — Homepage sections (part 1): Hero, Leistungen, Realität, Solution, Cockpit

function Hero({
  onNavigate
}) {
  const metrics = [{
    label: 'MAU',
    value: '+51%',
    hl: true
  }, {
    label: 'Crash-frei',
    value: '99,2%'
  }, {
    label: 'Store Rating',
    value: '4,8'
  }, {
    label: 'Subscriptions',
    value: '+53%'
  }, {
    label: 'Churn',
    value: '-50%'
  }, {
    label: 'Session-Dauer',
    value: '+62%'
  }];
  return /*#__PURE__*/React.createElement("section", {
    style: {
      background: '#fff',
      paddingTop: '4rem',
      paddingBottom: '6rem'
    }
  }, /*#__PURE__*/React.createElement("div", {
    className: "section-container"
  }, /*#__PURE__*/React.createElement("div", {
    className: "hero-grid",
    style: {
      display: 'grid',
      gridTemplateColumns: '1fr 1fr',
      gap: '5rem',
      alignItems: 'center'
    }
  }, /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: '.75rem',
      marginBottom: '2rem'
    }
  }, /*#__PURE__*/React.createElement("span", {
    className: "eyebrow-bar"
  }), /*#__PURE__*/React.createElement("span", {
    style: {
      fontFamily: 'var(--font-display)',
      fontSize: 'var(--text-xs)',
      fontWeight: 700,
      letterSpacing: 'var(--tracking-widest)',
      textTransform: 'uppercase',
      color: 'var(--brand-600)'
    }
  }, "App-Betreuung")), /*#__PURE__*/React.createElement("h1", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 800,
      fontSize: 'clamp(2.5rem,2rem+2.5vw,3.5rem)',
      lineHeight: 1.05,
      letterSpacing: '-0.02em',
      color: 'var(--slate-900)',
      marginBottom: '1.5rem'
    }
  }, "Deine App.", /*#__PURE__*/React.createElement("br", null), "Messbar ", /*#__PURE__*/React.createElement("span", {
    style: {
      color: 'var(--brand-600)'
    }
  }, "besser.")), /*#__PURE__*/React.createElement("p", {
    style: {
      fontSize: 'var(--text-xl)',
      color: 'var(--slate-500)',
      lineHeight: 1.6,
      marginBottom: '2.5rem',
      maxWidth: '32rem'
    }
  }, "Dein App-Care Cockpit. Dein Expertenteam. Jeden Monat messbar wachsen."), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      flexWrap: 'wrap',
      gap: '1rem'
    }
  }, /*#__PURE__*/React.createElement(Button, {
    variant: "primary",
    size: "lg",
    icon: "arrowRight",
    onClick: e => {
      e.preventDefault();
      onNavigate && onNavigate('pakete');
    }
  }, "Beta anfragen"), /*#__PURE__*/React.createElement(Button, {
    variant: "secondary",
    size: "lg",
    onClick: e => {
      e.preventDefault();
      onNavigate && onNavigate('pakete');
    }
  }, "Pakete ansehen"))), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'relative'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      background: '#fff',
      border: '1px solid var(--border)',
      borderRadius: 'var(--radius-2xl)',
      padding: '2rem',
      boxShadow: 'var(--shadow-sm)'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      justifyContent: 'space-between',
      alignItems: 'flex-start',
      marginBottom: '1.5rem'
    }
  }, /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("div", {
    style: {
      fontFamily: 'var(--font-display)',
      fontSize: 'var(--text-xs)',
      fontWeight: 700,
      letterSpacing: 'var(--tracking-widest)',
      textTransform: 'uppercase',
      color: 'var(--slate-400)'
    }
  }, "Dashboard"), /*#__PURE__*/React.createElement("div", {
    style: {
      fontSize: 'var(--text-sm)',
      color: 'var(--slate-500)',
      marginTop: 2
    }
  }, "Letzte 30 Tage")), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 4
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      width: 10,
      height: 10,
      borderRadius: '50%',
      background: 'var(--brand-600)'
    }
  }), /*#__PURE__*/React.createElement("span", {
    style: {
      width: 10,
      height: 10,
      borderRadius: '50%',
      background: 'var(--slate-200)'
    }
  }), /*#__PURE__*/React.createElement("span", {
    style: {
      width: 10,
      height: 10,
      borderRadius: '50%',
      background: 'var(--slate-200)'
    }
  }))), /*#__PURE__*/React.createElement("div", {
    style: {
      background: 'var(--slate-50)',
      borderRadius: 'var(--radius-xl)',
      padding: '1rem',
      marginBottom: '1.5rem'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      justifyContent: 'space-between',
      alignItems: 'flex-end',
      marginBottom: '.75rem'
    }
  }, /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("div", {
    style: {
      fontFamily: 'var(--font-mono)',
      fontWeight: 700,
      fontSize: '1.5rem',
      color: 'var(--slate-900)'
    }
  }, "12.847"), /*#__PURE__*/React.createElement("div", {
    style: {
      fontSize: 'var(--text-xs)',
      color: 'var(--slate-400)'
    }
  }, "Monthly Active Users")), /*#__PURE__*/React.createElement("span", {
    className: "badge-delta badge"
  }, /*#__PURE__*/React.createElement(Icon, {
    name: "caretUp",
    size: 12
  }), "+51%")), /*#__PURE__*/React.createElement("svg", {
    style: {
      width: '100%',
      height: 64
    },
    viewBox: "0 0 300 60",
    fill: "none",
    preserveAspectRatio: "none"
  }, /*#__PURE__*/React.createElement("path", {
    d: "M0 55 Q30 50, 60 45 T120 35 T180 25 T240 15 T300 5",
    stroke: "#2563eb",
    strokeWidth: "2.5",
    fill: "none",
    strokeLinecap: "round"
  }), /*#__PURE__*/React.createElement("path", {
    d: "M0 55 Q30 50, 60 45 T120 35 T180 25 T240 15 T300 5 V60 H0 Z",
    fill: "url(#hg)"
  }), /*#__PURE__*/React.createElement("defs", null, /*#__PURE__*/React.createElement("linearGradient", {
    id: "hg",
    x1: "0",
    y1: "0",
    x2: "0",
    y2: "1"
  }, /*#__PURE__*/React.createElement("stop", {
    offset: "0%",
    stopColor: "#2563eb",
    stopOpacity: "0.12"
  }), /*#__PURE__*/React.createElement("stop", {
    offset: "100%",
    stopColor: "#2563eb",
    stopOpacity: "0"
  }))))), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'grid',
      gridTemplateColumns: 'repeat(3,1fr)',
      gap: '.75rem'
    }
  }, metrics.map((m, i) => /*#__PURE__*/React.createElement("div", {
    key: i,
    style: {
      borderRadius: 'var(--radius-lg)',
      padding: '.75rem',
      background: m.hl ? 'var(--brand-50)' : 'var(--slate-50)',
      border: m.hl ? '1px solid var(--brand-200)' : '1px solid transparent'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      fontFamily: 'var(--font-mono)',
      fontWeight: 700,
      fontSize: '1.125rem',
      color: 'var(--slate-900)'
    }
  }, m.value), /*#__PURE__*/React.createElement("div", {
    style: {
      fontSize: 'var(--text-xs)',
      color: 'var(--slate-400)',
      marginTop: 2
    }
  }, m.label))))), /*#__PURE__*/React.createElement("div", {
    className: "dotgrid",
    "aria-hidden": "true"
  })))));
}
function Leistungen() {
  const items = [{
    title: 'Vom Report zum Release – alles in einem Tool',
    text: 'Das App-Care Cockpit verbindet KPI-Analyse, Management Summary, Feature-Board und Release Management. Kein Tool-Wechsel, kein Kontext-Verlust.'
  }, {
    title: 'Volle Transparenz per KPI-Report',
    text: 'Installationen, Verweildauer, Abbruchraten — verständlich aufbereitet im monatlichen Management Summary.',
    link: 'Management Summary ansehen'
  }, {
    title: 'Feedback in Features verwandeln',
    text: 'Store-Bewertungen, Crashlytics-Daten und KPIs fließen monatlich in den Summary. Aus Empfehlungen entstehen priorisierte Features.'
  }, {
    title: 'Sofortreaktion bei Bugs',
    text: 'Kritische Probleme werden behoben, bevor deine Nutzer sie bemerken.'
  }, {
    title: 'Stabilität durch Monitoring',
    text: 'Probleme werden erkannt und behoben, bevor sie eskalieren.'
  }, {
    title: 'Kontinuierliche Store-Optimierung',
    text: 'App-Store-Listings werden laufend gepflegt: Texte, Screenshots, Keywords — damit deine App gefunden wird.'
  }, {
    title: 'Aktuelle Dependencies, immer',
    text: 'Libraries, SDKs und OS-Kompatibilität werden regelmäßig geprüft und aktualisiert.'
  }, {
    title: 'Kein Recruiting, sofort einsatzbereit',
    text: 'Flexibel skalierbar, monatlich kündbar. Ein eingespieltes Team, das deine App von Anfang an kennt.'
  }, {
    title: '11 Experten, ein Team',
    text: 'Designer, Entwickler, QA — dauerhaft an deiner Seite. Senior-Level, lokal in Mainz, kein Off- oder Nearshore.'
  }];
  return /*#__PURE__*/React.createElement("section", {
    className: "section-padding",
    style: {
      background: '#fff'
    }
  }, /*#__PURE__*/React.createElement("div", {
    className: "section-container"
  }, /*#__PURE__*/React.createElement(SectionHeader, {
    eyebrow: "Leistungen",
    title: "Was in deinem Paket steckt",
    subtitle: "Von der KPI-Analyse bis zum Release \u2014 alle Leistungen, die monatlich f\xFCr deine App arbeiten."
  }), /*#__PURE__*/React.createElement("div", {
    className: "cards-3"
  }, items.map((it, i) => /*#__PURE__*/React.createElement("div", {
    key: i,
    className: "card"
  }, /*#__PURE__*/React.createElement("h3", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 700,
      fontSize: 'var(--text-base)',
      color: 'var(--slate-900)',
      marginBottom: '.75rem'
    }
  }, it.title), /*#__PURE__*/React.createElement("p", {
    style: {
      fontSize: 'var(--text-sm)',
      color: 'var(--slate-500)',
      lineHeight: 1.6
    }
  }, it.text), it.link && /*#__PURE__*/React.createElement("a", {
    href: "#",
    onClick: e => e.preventDefault(),
    style: {
      display: 'inline-flex',
      alignItems: 'center',
      gap: 4,
      color: 'var(--brand-600)',
      fontSize: 'var(--text-xs)',
      fontWeight: 600,
      marginTop: '1rem'
    }
  }, it.link, /*#__PURE__*/React.createElement(Icon, {
    name: "chevronRight",
    size: 12
  })))))));
}
function Realitaet() {
  const problems = [{
    icon: 'chat',
    title: 'Deine Nutzer reden. Hört jemand zu?',
    text: 'Store-Bewertungen stapeln sich, Crash-Reports häufen sich — aber ohne aktives Monitoring reagiert niemand.'
  }, {
    icon: 'chart',
    title: 'KPIs in Firebase. Bewertungen im Store. Crashes in Crashlytics.',
    text: 'Kein Tool zeigt das Gesamtbild. Ohne Überblick gibt es keine Strategie — nur Bauchgefühl.'
  }, {
    icon: 'clock',
    title: 'Jeder Monat ohne Betreuung kostet.',
    text: 'Sinkende Ratings, veraltete Dependencies, stagnierende Nutzerzahlen — eine App verliert still an Boden.'
  }];
  return /*#__PURE__*/React.createElement("section", {
    className: "section-padding bg-dark",
    style: {
      borderTop: '1px solid rgba(255,255,255,0.1)'
    }
  }, /*#__PURE__*/React.createElement("div", {
    className: "section-container"
  }, /*#__PURE__*/React.createElement("div", {
    className: "split-grid",
    style: {
      display: 'grid',
      gridTemplateColumns: '1fr 1fr',
      gap: '4rem',
      alignItems: 'start'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'sticky',
      top: '6rem'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      marginBottom: '1.5rem'
    }
  }, /*#__PURE__*/React.createElement(Eyebrow, {
    onDark: true
  }, "Realit\xE4t nach dem Launch")), /*#__PURE__*/React.createElement("h2", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 700,
      fontSize: 'clamp(1.875rem,1.4rem+1.6vw,2.25rem)',
      color: '#fff',
      lineHeight: 1.2,
      letterSpacing: '-0.02em',
      marginBottom: '1.5rem'
    }
  }, "Die meisten Apps stagnieren nach dem Launch. Nicht weil sie schlecht sind."), /*#__PURE__*/React.createElement("p", {
    style: {
      color: 'var(--slate-400)',
      fontSize: 'var(--text-lg)',
      lineHeight: 1.6,
      marginBottom: '2.5rem'
    }
  }, "Viele Apps werden gebaut und gelauncht. Wenige werden danach wirklich betrieben \u2014 mit Strategie, Monitoring und einem Team, das hinschaut."), /*#__PURE__*/React.createElement("div", {
    style: {
      background: 'rgba(37,99,235,0.2)',
      border: '1px solid rgba(59,130,246,0.2)',
      borderRadius: 'var(--radius-xl)',
      padding: '1.25rem 1.5rem'
    }
  }, /*#__PURE__*/React.createElement("p", {
    style: {
      color: '#fff',
      fontFamily: 'var(--font-display)',
      fontWeight: 700,
      letterSpacing: '-0.01em'
    }
  }, "Mit App-Care h\xF6rt das auf."), /*#__PURE__*/React.createElement("p", {
    style: {
      color: 'var(--slate-300)',
      fontSize: 'var(--text-sm)',
      marginTop: 4
    }
  }, "Monatlich. Messbar. Mit einem Team, das zuh\xF6rt und handelt."))), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      flexDirection: 'column',
      gap: '1rem'
    }
  }, problems.map((p, i) => /*#__PURE__*/React.createElement("div", {
    key: i,
    style: {
      background: 'rgba(255,255,255,0.05)',
      border: '1px solid rgba(255,255,255,0.1)',
      borderRadius: 'var(--radius-xl)',
      padding: '1.5rem',
      display: 'flex',
      gap: '1rem'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      width: 40,
      height: 40,
      borderRadius: 'var(--radius-lg)',
      background: 'rgba(59,130,246,0.15)',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      flexShrink: 0,
      color: 'var(--brand-400)'
    }
  }, /*#__PURE__*/React.createElement(Icon, {
    name: p.icon,
    size: 20,
    width: 1.5
  })), /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("h3", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 700,
      color: '#fff',
      fontSize: 'var(--text-base)',
      lineHeight: 1.3,
      marginBottom: '.5rem'
    }
  }, p.title), /*#__PURE__*/React.createElement("p", {
    style: {
      color: 'var(--slate-400)',
      fontSize: 'var(--text-sm)',
      lineHeight: 1.6
    }
  }, p.text))))))));
}
Object.assign(window, {
  Hero,
  Leistungen,
  Realitaet
});
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/website/SectionsA.jsx", error: String((e && e.message) || e) }); }

// ui_kits/website/SectionsB.jsx
try { (() => {
// App-Care UI Kit — Homepage sections (part 2): Solution + Trust bar, Cockpit cycle

function Solution({
  onDownload
}) {
  const points = ['Nutzerbasis, Engagement und Retention auf einen Blick', 'Crash-Analysen, Performance-Daten, Store-Ratings', 'Konkrete nächste Schritte mit erwartetem Impact', 'KI-gestützte Analyse, expertengeprüft und freigegeben', 'Freigabe-Status im Cockpit sichtbar'];
  return /*#__PURE__*/React.createElement(React.Fragment, null, /*#__PURE__*/React.createElement("section", {
    className: "section-padding",
    style: {
      background: '#fff'
    }
  }, /*#__PURE__*/React.createElement("div", {
    className: "section-container"
  }, /*#__PURE__*/React.createElement("div", {
    className: "split-grid",
    style: {
      display: 'grid',
      gridTemplateColumns: '1fr 1fr',
      gap: '5rem',
      alignItems: 'center'
    }
  }, /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("div", {
    style: {
      marginBottom: '1.5rem'
    }
  }, /*#__PURE__*/React.createElement(Eyebrow, null, "Management Summary")), /*#__PURE__*/React.createElement("h2", {
    className: "section-title",
    style: {
      marginBottom: '1.5rem'
    }
  }, "Weniger Raten. Mehr Entscheidungen. Jeden Monat."), /*#__PURE__*/React.createElement("p", {
    className: "section-subtitle",
    style: {
      marginBottom: '2.5rem'
    }
  }, "Das Herzst\xFCck von App-Care: alle KPIs, Auff\xE4lligkeiten und konkrete Empfehlungen \u2014 KI-analysiert, vom coodoo-Team gepr\xFCft und im Cockpit freigegeben, bevor du ihn siehst."), /*#__PURE__*/React.createElement("ul", {
    style: {
      listStyle: 'none',
      padding: 0,
      margin: '0 0 2.5rem',
      display: 'flex',
      flexDirection: 'column',
      gap: '1rem'
    }
  }, points.map((p, i) => /*#__PURE__*/React.createElement("li", {
    key: i,
    style: {
      display: 'flex',
      alignItems: 'flex-start',
      gap: '.75rem'
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      width: 6,
      height: 6,
      borderRadius: '50%',
      background: 'var(--brand-600)',
      marginTop: 8,
      flexShrink: 0
    }
  }), /*#__PURE__*/React.createElement("span", {
    style: {
      color: 'var(--slate-600)',
      fontSize: 'var(--text-sm)',
      lineHeight: 1.6
    }
  }, p)))), /*#__PURE__*/React.createElement(Button, {
    variant: "primary",
    onClick: e => {
      e.preventDefault();
      onDownload && onDownload();
    }
  }, "Beispiel herunterladen")), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      justifyContent: 'center'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'relative',
      width: '100%',
      maxWidth: '32rem'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      borderRadius: 'var(--radius-xl)',
      overflow: 'hidden',
      boxShadow: 'var(--shadow-xl)',
      border: '1px solid var(--border)',
      background: '#fff',
      transform: 'rotate(-1deg)'
    }
  }, /*#__PURE__*/React.createElement("img", {
    src: "../../assets/mgmt-summary-cover.png",
    alt: "Management Summary \u2014 Cyclotest mySense",
    style: {
      width: '100%'
    }
  })), /*#__PURE__*/React.createElement("p", {
    style: {
      textAlign: 'center',
      fontSize: 'var(--text-xs)',
      color: 'var(--slate-400)',
      marginTop: '1.5rem'
    }
  }, "Echtes Beispiel: Cyclotest mySense App")))))), /*#__PURE__*/React.createElement("div", {
    style: {
      background: 'var(--brand-950)',
      padding: '3rem 0'
    }
  }, /*#__PURE__*/React.createElement("div", {
    className: "section-container"
  }, /*#__PURE__*/React.createElement("div", {
    className: "trust-grid",
    style: {
      display: 'grid',
      gridTemplateColumns: 'repeat(3,1fr)',
      gap: '2rem',
      textAlign: 'center'
    }
  }, [['Dein festes Team', 'Kennt deine App bis ins Detail.'], ['Lokal in Mainz', 'Kein Off- oder Nearshore.'], ['Senior-Entwickler', 'Hunderte Apps. Ein Team.']].map(([t, s], i) => /*#__PURE__*/React.createElement("div", {
    key: i
  }, /*#__PURE__*/React.createElement("p", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 700,
      color: '#fff',
      fontSize: 'var(--text-sm)'
    }
  }, t), /*#__PURE__*/React.createElement("p", {
    style: {
      color: 'var(--slate-400)',
      fontSize: 'var(--text-sm)',
      marginTop: 4
    }
  }, s)))))));
}
function CockpitCycle() {
  const steps = [{
    n: '01',
    t: 'Daten',
    d: 'KPIs, Store-Bewertungen, Crashlytics und Release-Daten fließen automatisch ins Cockpit.'
  }, {
    n: '02',
    t: 'Management Summary',
    d: 'KI analysiert die Daten und erstellt einen monatlichen Report — expertengeprüft und freigegeben.'
  }, {
    n: '03',
    t: 'Feature-Board',
    d: 'Aus den Handlungsempfehlungen entstehen direkt im Cockpit priorisierte Features und Tasks.'
  }, {
    n: '04',
    t: 'Release',
    d: 'Umgesetzte Features werden mit Releases verknüpft — der Kreislauf beginnt von vorn.'
  }];
  return /*#__PURE__*/React.createElement("section", {
    className: "section-padding bg-subtle"
  }, /*#__PURE__*/React.createElement("div", {
    className: "section-container"
  }, /*#__PURE__*/React.createElement(SectionHeader, {
    eyebrow: "App-Care Cockpit",
    title: "Ein Tool. Der vollst\xE4ndige Kreislauf.",
    subtitle: "Das App-Care Cockpit verbindet alle Datenquellen, den Management Summary, das Feature-Board und das Release Management \u2014 an einem Ort, ohne Tool-Wechsel."
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'relative',
      maxWidth: '56rem',
      margin: '0 auto'
    }
  }, /*#__PURE__*/React.createElement("div", {
    className: "cycle-line"
  }), /*#__PURE__*/React.createElement("div", {
    className: "cycle-grid"
  }, steps.map((s, i) => /*#__PURE__*/React.createElement("div", {
    key: i,
    style: {
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      textAlign: 'center',
      position: 'relative'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'relative',
      zIndex: 1,
      width: 80,
      height: 80,
      borderRadius: '50%',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      marginBottom: '1.25rem',
      background: i === 1 ? 'var(--brand-600)' : '#fff',
      border: i === 1 ? '2px solid var(--brand-600)' : '2px solid var(--slate-200)'
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 800,
      fontSize: 'var(--text-sm)',
      color: i === 1 ? '#fff' : 'var(--slate-400)'
    }
  }, s.n)), /*#__PURE__*/React.createElement("h3", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 700,
      fontSize: 'var(--text-base)',
      marginBottom: '.5rem',
      color: i === 1 ? 'var(--brand-600)' : 'var(--slate-900)'
    }
  }, s.t), /*#__PURE__*/React.createElement("p", {
    style: {
      color: 'var(--slate-500)',
      fontSize: 'var(--text-sm)',
      lineHeight: 1.6
    }
  }, s.d)))), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      justifyContent: 'center',
      marginTop: '2rem'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: '.5rem',
      fontSize: 'var(--text-xs)',
      color: 'var(--slate-400)',
      fontFamily: 'var(--font-display)',
      letterSpacing: '.05em',
      textTransform: 'uppercase'
    }
  }, /*#__PURE__*/React.createElement(Icon, {
    name: "loop",
    size: 16,
    width: 1.5,
    style: {
      color: 'var(--brand-300)'
    }
  }), "Jeden Monat von vorn")))));
}
Object.assign(window, {
  Solution,
  CockpitCycle
});
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/website/SectionsB.jsx", error: String((e && e.message) || e) }); }

// ui_kits/website/SectionsC.jsx
try { (() => {
// App-Care UI Kit — Homepage sections (part 3): Packages, References, Team, Whitepaper, FinalCTA, Footer

function Packages({
  onRequest
}) {
  const free = [{
    t: '1 App'
  }, {
    t: 'Store-Audit + letzte 50 Reviews'
  }, {
    t: 'AI Advisory (vollständig)'
  }, {
    t: 'Wöchentliche E-Mail (niemals gesperrt)'
  }, {
    t: 'KPI-Dashboard',
    blur: true
  }, {
    t: 'PDF-Report Vorschau',
    blur: true
  }];
  const insights = ['Alles aus Free', 'Mehrere Apps', 'Volles KPI-Dashboard', 'API-Verbindungen (App Store Connect, Firebase, RevenueCat)', 'Monatlicher Management Summary PDF', 'Monatliches Review-Gespräch'];
  return /*#__PURE__*/React.createElement("section", {
    className: "section-padding",
    style: {
      background: '#fff'
    }
  }, /*#__PURE__*/React.createElement("div", {
    className: "section-container"
  }, /*#__PURE__*/React.createElement(SectionHeader, {
    eyebrow: "Pakete",
    title: "Klare Preise. Kein Risiko.",
    subtitle: "G\xFCnstiger als ein Festangestellter \u2014 und du bekommst ein ganzes Expertenteam."
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      maxWidth: '56rem',
      margin: '-2.5rem auto 0'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      justifyContent: 'center',
      marginBottom: '4rem'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'inline-flex',
      alignItems: 'center',
      gap: '.5rem',
      background: 'var(--brand-50)',
      border: '1px solid var(--brand-200)',
      color: 'var(--brand-700)',
      fontSize: 'var(--text-sm)',
      padding: '.75rem 1.25rem',
      borderRadius: 'var(--radius-xl)'
    }
  }, /*#__PURE__*/React.createElement(Icon, {
    name: "info",
    size: 16
  }), /*#__PURE__*/React.createElement("span", null, /*#__PURE__*/React.createElement("strong", null, "Beta-Phase:"), " Preise gelten ab vollem Launch. Jetzt als Beta-Tester starten."))), /*#__PURE__*/React.createElement("div", {
    className: "pkg-divider"
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      color: 'var(--brand-600)'
    }
  }, "Das Tool"), /*#__PURE__*/React.createElement("span", {
    className: "line",
    style: {
      background: 'var(--brand-200)'
    }
  }), /*#__PURE__*/React.createElement("em", null, "Du arbeitest mit App-Care")), /*#__PURE__*/React.createElement("div", {
    className: "pkg-grid",
    style: {
      maxWidth: '48rem',
      margin: '0 auto 4rem'
    }
  }, /*#__PURE__*/React.createElement("div", {
    className: "pkg-card",
    style: {
      background: '#f0fdf4',
      border: '2px solid #bbf7d0'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      marginBottom: '1.5rem'
    }
  }, /*#__PURE__*/React.createElement("p", {
    style: {
      fontFamily: 'var(--font-display)',
      fontSize: 'var(--text-xs)',
      fontWeight: 700,
      letterSpacing: 'var(--tracking-widest)',
      textTransform: 'uppercase',
      color: '#15803d',
      marginBottom: '.5rem'
    }
  }, "Indie Dev \xB7 Prospects"), /*#__PURE__*/React.createElement("h3", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 700,
      fontSize: 'var(--text-xl)',
      color: 'var(--slate-900)',
      marginBottom: '.75rem'
    }
  }, "Free"), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'baseline',
      gap: 4
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 800,
      fontSize: '2.25rem',
      color: 'var(--slate-900)'
    }
  }, "\u20AC0")), /*#__PURE__*/React.createElement("p", {
    style: {
      fontSize: 'var(--text-xs)',
      marginTop: 8,
      color: '#15803d'
    }
  }, "Kein Zeitlimit \xB7 Keine Kreditkarte")), /*#__PURE__*/React.createElement("ul", {
    className: "pkg-list"
  }, free.map((it, i) => /*#__PURE__*/React.createElement("li", {
    key: i,
    style: {
      color: it.blur ? 'var(--slate-400)' : 'var(--slate-600)'
    }
  }, it.blur ? /*#__PURE__*/React.createElement("span", {
    style: {
      color: 'var(--slate-300)',
      flexShrink: 0,
      lineHeight: 1
    }
  }, "\u22EF") : /*#__PURE__*/React.createElement(Icon, {
    name: "check20",
    size: 16,
    style: {
      color: '#16a34a',
      marginTop: 2
    }
  }), /*#__PURE__*/React.createElement("span", {
    style: {
      fontStyle: it.blur ? 'italic' : 'normal'
    }
  }, it.t, it.blur && /*#__PURE__*/React.createElement("span", {
    style: {
      marginLeft: 6,
      fontSize: 'var(--text-xs)',
      background: 'var(--slate-100)',
      color: 'var(--slate-400)',
      borderRadius: 4,
      padding: '2px 6px',
      fontStyle: 'normal'
    }
  }, "geblurrt"))))), /*#__PURE__*/React.createElement("a", {
    href: "#",
    onClick: e => {
      e.preventDefault();
      onRequest && onRequest();
    },
    className: "pkg-cta",
    style: {
      background: '#16a34a',
      color: '#fff'
    }
  }, "Beta-Zugang anfragen")), /*#__PURE__*/React.createElement("div", {
    className: "pkg-card",
    style: {
      background: '#fff',
      border: '2px solid var(--slate-200)'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      marginBottom: '1.5rem'
    }
  }, /*#__PURE__*/React.createElement("p", {
    style: {
      fontFamily: 'var(--font-display)',
      fontSize: 'var(--text-xs)',
      fontWeight: 700,
      letterSpacing: 'var(--tracking-widest)',
      textTransform: 'uppercase',
      color: 'var(--brand-600)',
      marginBottom: '.5rem'
    }
  }, "App Publisher \xB7 Studios"), /*#__PURE__*/React.createElement("h3", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 700,
      fontSize: 'var(--text-xl)',
      color: 'var(--slate-900)',
      marginBottom: '.75rem'
    }
  }, "Insights"), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'baseline',
      gap: 4
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 800,
      fontSize: '2.25rem',
      color: 'var(--slate-900)'
    }
  }, "\u20AC299"), /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 'var(--text-sm)',
      color: 'var(--slate-400)'
    }
  }, "/Monat")), /*#__PURE__*/React.createElement("p", {
    style: {
      fontSize: 'var(--text-xs)',
      marginTop: 8,
      color: 'var(--slate-400)'
    }
  }, "Jederzeit zum n\xE4chsten Monat k\xFCndbar")), /*#__PURE__*/React.createElement("ul", {
    className: "pkg-list"
  }, insights.map((t, i) => /*#__PURE__*/React.createElement("li", {
    key: i,
    style: {
      color: 'var(--slate-600)'
    }
  }, /*#__PURE__*/React.createElement(Icon, {
    name: "check20",
    size: 16,
    style: {
      color: 'var(--brand-600)',
      marginTop: 2
    }
  }), /*#__PURE__*/React.createElement("span", null, t)))), /*#__PURE__*/React.createElement("a", {
    href: "#",
    onClick: e => {
      e.preventDefault();
      onRequest && onRequest();
    },
    className: "pkg-cta",
    style: {
      background: 'var(--brand-600)',
      color: '#fff'
    }
  }, "Beta-Zugang anfragen"))), /*#__PURE__*/React.createElement("div", {
    className: "pkg-divider"
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      color: '#ef4444'
    }
  }, "Das Team"), /*#__PURE__*/React.createElement("span", {
    className: "line",
    style: {
      background: '#fecaca'
    }
  }), /*#__PURE__*/React.createElement("em", null, "Das coodoo-Team arbeitet f\xFCr dich")), /*#__PURE__*/React.createElement("div", {
    className: "team-teaser-row"
  }, /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("p", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 700,
      color: 'var(--slate-900)',
      fontSize: 'var(--text-lg)',
      marginBottom: 4
    }
  }, "Mehr als das Tool? Das coodoo-Team \xFCbernimmt aktiv."), /*#__PURE__*/React.createElement("p", {
    style: {
      fontSize: 'var(--text-sm)',
      color: 'var(--slate-500)'
    }
  }, "Ein festes Entwicklerteam aus Mainz \u2014 von reaktiver Absicherung \xFCber laufende Betreuung bis zu systematischem Wachstum. Ab \u20AC990/Monat.")), /*#__PURE__*/React.createElement("a", {
    href: "#",
    onClick: e => e.preventDefault(),
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 700,
      fontSize: 'var(--text-sm)',
      letterSpacing: 'var(--tracking-wide)',
      textTransform: 'uppercase',
      padding: '.75rem 1.5rem',
      borderRadius: 'var(--radius-lg)',
      background: 'var(--brand-950)',
      color: '#fff',
      whiteSpace: 'nowrap',
      flexShrink: 0
    }
  }, "Pakete ansehen")))));
}
function References() {
  const refs = [{
    app: 'WeatherPro',
    cat: 'Wetter & Lifestyle',
    kpis: [['Aktive Nutzer', '8.200', '12.400', '+51%'], ['Crash-frei', '94,1%', '99,2%', '+5,1pp'], ['Store Rating', '3,8', '4,7', '+0,9']],
    q: 'Endlich wissen wir, was in unserer App passiert. Der monatliche Report gibt uns Sicherheit und klare Empfehlungen.'
  }, {
    app: 'HealthTrack',
    cat: 'Gesundheit & Fitness',
    kpis: [['Subscriptions', '340', '520', '+53%'], ['Churn Rate', '8,2%', '4,1%', '-4,1pp'], ['Session-Dauer', '4,2 Min', '6,8 Min', '+62%']],
    q: 'App-Care hat uns geholfen, die wichtigen KPIs zu verstehen und gezielt daran zu arbeiten.'
  }];
  return /*#__PURE__*/React.createElement("section", {
    className: "section-padding bg-subtle"
  }, /*#__PURE__*/React.createElement("div", {
    className: "section-container"
  }, /*#__PURE__*/React.createElement(SectionHeader, {
    eyebrow: "Referenzen",
    title: "Echte Apps. Echte Zahlen.",
    subtitle: "Bevor du entscheidest \u2014 das haben andere mit App-Care erreicht."
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'grid',
      gridTemplateColumns: 'repeat(auto-fit,minmax(320px,1fr))',
      gap: '2rem',
      maxWidth: '56rem',
      margin: '0 auto'
    }
  }, refs.map((r, i) => /*#__PURE__*/React.createElement("div", {
    key: i,
    className: "card"
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      marginBottom: '1.5rem'
    }
  }, /*#__PURE__*/React.createElement("h3", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 700,
      color: 'var(--slate-900)',
      fontSize: 'var(--text-lg)'
    }
  }, r.app), /*#__PURE__*/React.createElement("span", {
    className: "badge badge-gray",
    style: {
      fontSize: 'var(--text-xs)',
      marginTop: 4
    }
  }, r.cat)), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      flexDirection: 'column',
      gap: '.75rem',
      marginBottom: '1.5rem'
    }
  }, r.kpis.map((k, j) => /*#__PURE__*/React.createElement("div", {
    key: j,
    style: {
      display: 'flex',
      justifyContent: 'space-between',
      alignItems: 'center',
      fontSize: 'var(--text-sm)'
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      color: 'var(--slate-500)'
    }
  }, k[0]), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: '.75rem'
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      color: 'var(--slate-300)',
      textDecoration: 'line-through',
      fontSize: 'var(--text-xs)'
    }
  }, k[1]), /*#__PURE__*/React.createElement("span", {
    style: {
      fontFamily: 'var(--font-mono)',
      fontWeight: 700,
      color: 'var(--slate-900)'
    }
  }, k[2]), /*#__PURE__*/React.createElement("span", {
    className: "badge",
    style: {
      background: 'var(--brand-50)',
      color: 'var(--brand-600)',
      fontSize: 'var(--text-xs)',
      fontWeight: 700,
      fontFamily: 'var(--font-display)'
    }
  }, k[3]))))), /*#__PURE__*/React.createElement("blockquote", {
    style: {
      borderLeft: '2px solid var(--brand-600)',
      paddingLeft: '1rem',
      margin: 0,
      fontSize: 'var(--text-sm)',
      color: 'var(--slate-500)',
      fontStyle: 'italic'
    }
  }, "\"", r.q, "\""))))));
}
Object.assign(window, {
  Packages,
  References
});
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/website/SectionsC.jsx", error: String((e && e.message) || e) }); }

// ui_kits/website/SectionsD.jsx
try { (() => {
// App-Care UI Kit — Homepage sections (part 4): Team, Whitepaper, FinalCTA, Footer

function TeamTeaser() {
  const names = ['Arend', 'Eike', 'Erik', 'Flo', 'Jan', 'Klemens', 'Marcel', 'Nico', 'Richard'];
  return /*#__PURE__*/React.createElement("section", {
    className: "section-padding bg-dark"
  }, /*#__PURE__*/React.createElement("div", {
    className: "section-container"
  }, /*#__PURE__*/React.createElement("div", {
    className: "split-grid",
    style: {
      display: 'grid',
      gridTemplateColumns: '1fr 1fr',
      gap: '4rem',
      alignItems: 'center'
    }
  }, /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("div", {
    style: {
      marginBottom: '1.5rem'
    }
  }, /*#__PURE__*/React.createElement(Eyebrow, {
    onDark: true
  }, "Team")), /*#__PURE__*/React.createElement("h2", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 700,
      fontSize: 'clamp(1.875rem,1.4rem+2vw,3rem)',
      color: '#fff',
      letterSpacing: '-0.02em',
      lineHeight: 1.1,
      marginBottom: '1.5rem'
    }
  }, "11 Experten.", /*#__PURE__*/React.createElement("br", null), "Ein Team.", /*#__PURE__*/React.createElement("br", null), /*#__PURE__*/React.createElement("span", {
    style: {
      color: 'var(--brand-400)'
    }
  }, "Deine App.")), /*#__PURE__*/React.createElement("p", {
    style: {
      color: 'var(--slate-400)',
      fontSize: 'var(--text-lg)',
      lineHeight: 1.6,
      marginBottom: '1.5rem'
    }
  }, "Betrieben von ", /*#__PURE__*/React.createElement("a", {
    href: "https://coodoo.de",
    target: "_blank",
    rel: "noopener",
    style: {
      color: '#fff',
      textDecoration: 'underline',
      textUnderlineOffset: 4
    }
  }, "coodoo GmbH"), " \u2014 Mobile App Studio aus Mainz. Jede App bekommt feste Ansprechpartner: ausgebildete Informatiker und Mobile-Experten."), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: '.75rem',
      background: 'rgba(255,255,255,0.05)',
      border: '1px solid rgba(255,255,255,0.1)',
      borderRadius: 'var(--radius-lg)',
      padding: '.75rem 1rem',
      marginBottom: '2rem',
      fontSize: 'var(--text-sm)',
      color: 'var(--slate-400)'
    }
  }, /*#__PURE__*/React.createElement(Icon, {
    name: "mapPin",
    size: 16,
    width: 1.5,
    style: {
      color: 'var(--brand-400)',
      flexShrink: 0
    }
  }), "Lokal in Mainz \u2014 kein Off- oder Nearshore."), /*#__PURE__*/React.createElement(Button, {
    variant: "on-dark",
    size: "md",
    icon: "chevronRight",
    onClick: e => e.preventDefault()
  }, "Team kennenlernen")), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'grid',
      gridTemplateColumns: 'repeat(3,1fr)',
      gap: '.75rem'
    }
  }, names.map((n, i) => /*#__PURE__*/React.createElement("div", {
    key: i,
    style: {
      aspectRatio: '1',
      borderRadius: 'var(--radius-xl)',
      overflow: 'hidden',
      background: '#fff'
    }
  }, /*#__PURE__*/React.createElement("img", {
    src: `../../assets/team/${n}.avif`,
    alt: n,
    style: {
      width: '100%',
      height: '100%',
      objectFit: 'cover',
      objectPosition: 'top'
    }
  })))))));
}
function Whitepaper({
  onSubmit
}) {
  const [email, setEmail] = React.useState('');
  const [sent, setSent] = React.useState(false);
  const submit = e => {
    e.preventDefault();
    if (email) {
      setSent(true);
      onSubmit && onSubmit(email);
    }
  };
  return /*#__PURE__*/React.createElement("section", {
    className: "section-padding bg-dark"
  }, /*#__PURE__*/React.createElement("div", {
    className: "section-container"
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      maxWidth: '48rem',
      margin: '0 auto',
      textAlign: 'center'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      marginBottom: '1.5rem'
    }
  }, /*#__PURE__*/React.createElement(Eyebrow, {
    center: true,
    onDark: true
  }, "Kostenlos")), /*#__PURE__*/React.createElement("h2", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 700,
      fontSize: 'clamp(1.875rem,1.4rem+2vw,3rem)',
      color: '#fff',
      letterSpacing: '-0.02em',
      marginBottom: '1rem'
    }
  }, "App-KPIs verstehen"), /*#__PURE__*/React.createElement("p", {
    style: {
      color: 'var(--slate-400)',
      fontSize: 'var(--text-lg)',
      lineHeight: 1.6,
      marginBottom: '2.5rem'
    }
  }, "Welche KPIs z\xE4hlen wirklich? Unser kostenloses Whitepaper erkl\xE4rt \xFCber 20 Mobile-App-KPIs aus 4 Kategorien \u2014 verst\xE4ndlich und praxisnah."), sent ? /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'inline-flex',
      alignItems: 'center',
      gap: '.5rem',
      background: 'rgba(37,99,235,0.2)',
      border: '1px solid rgba(59,130,246,0.25)',
      borderRadius: 'var(--radius-lg)',
      padding: '1rem 1.5rem',
      color: '#fff',
      fontSize: 'var(--text-sm)'
    }
  }, /*#__PURE__*/React.createElement(Icon, {
    name: "check20",
    size: 16,
    style: {
      color: 'var(--brand-400)'
    }
  }), "Danke! Wir haben dir das Whitepaper geschickt.") : /*#__PURE__*/React.createElement("form", {
    onSubmit: submit,
    style: {
      display: 'flex',
      gap: '.75rem',
      maxWidth: '28rem',
      margin: '0 auto',
      flexWrap: 'wrap'
    }
  }, /*#__PURE__*/React.createElement("input", {
    type: "email",
    required: true,
    placeholder: "Deine E-Mail-Adresse",
    value: email,
    onChange: e => setEmail(e.target.value),
    style: {
      flex: 1,
      minWidth: 180,
      padding: '.75rem 1rem',
      borderRadius: 'var(--radius-lg)',
      background: 'rgba(255,255,255,0.05)',
      border: '1px solid rgba(255,255,255,0.1)',
      color: '#fff',
      fontSize: 'var(--text-sm)',
      outline: 'none',
      fontFamily: 'var(--font-sans)'
    }
  }), /*#__PURE__*/React.createElement("button", {
    type: "submit",
    className: "btn btn-primary btn-md",
    style: {
      whiteSpace: 'nowrap'
    }
  }, "Herunterladen")), /*#__PURE__*/React.createElement("p", {
    style: {
      fontSize: 'var(--text-xs)',
      color: 'var(--slate-500)',
      marginTop: '1rem'
    }
  }, "Kein Spam. Keine Weitergabe. Jederzeit abmeldbar."))));
}
function FinalCTA({
  onNavigate
}) {
  return /*#__PURE__*/React.createElement("section", {
    className: "section-padding",
    style: {
      background: '#fff'
    }
  }, /*#__PURE__*/React.createElement("div", {
    className: "section-container"
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      maxWidth: '48rem',
      margin: '0 auto',
      textAlign: 'center'
    }
  }, /*#__PURE__*/React.createElement("h2", {
    className: "section-title",
    style: {
      marginBottom: '1rem'
    }
  }, "Bereit f\xFCr den n\xE4chsten Schritt?"), /*#__PURE__*/React.createElement("p", {
    className: "section-subtitle",
    style: {
      marginBottom: '2.5rem'
    }
  }, "30 Minuten, kostenlos, unverbindlich. Wir schauen gemeinsam, was deine App braucht."), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      justifyContent: 'center',
      gap: '1rem',
      flexWrap: 'wrap',
      marginBottom: '2rem'
    }
  }, /*#__PURE__*/React.createElement(Button, {
    variant: "primary",
    size: "lg",
    onClick: e => {
      e.preventDefault();
      onNavigate && onNavigate('kontakt');
    }
  }, "Gespr\xE4ch buchen"), /*#__PURE__*/React.createElement(Button, {
    variant: "secondary",
    size: "lg",
    onClick: e => {
      e.preventDefault();
      onNavigate && onNavigate('pakete');
    }
  }, "Pakete vergleichen")), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      justifyContent: 'center',
      gap: '2rem',
      flexWrap: 'wrap',
      fontSize: 'var(--text-sm)',
      color: 'var(--slate-400)',
      marginBottom: '3rem'
    }
  }, ['Kostenlos', 'Antwort in 24h', 'Kein Risiko'].map((t, i) => /*#__PURE__*/React.createElement("span", {
    key: i,
    style: {
      display: 'inline-flex',
      alignItems: 'center',
      gap: 6
    }
  }, /*#__PURE__*/React.createElement(Icon, {
    name: "check20",
    size: 16,
    style: {
      color: 'var(--brand-600)'
    }
  }), t))), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'inline-flex',
      alignItems: 'center',
      gap: '1rem',
      background: 'var(--slate-50)',
      border: '1px solid var(--border)',
      borderRadius: 'var(--radius-xl)',
      padding: '1rem 1.5rem'
    }
  }, /*#__PURE__*/React.createElement("img", {
    src: "../../assets/team/Markus.jpg",
    alt: "Markus K\xFChle",
    style: {
      width: 48,
      height: 48,
      borderRadius: '50%',
      objectFit: 'cover',
      flexShrink: 0
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      textAlign: 'left'
    }
  }, /*#__PURE__*/React.createElement("p", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 700,
      color: 'var(--slate-900)',
      fontSize: 'var(--text-sm)'
    }
  }, "Markus K\xFChle"), /*#__PURE__*/React.createElement("p", {
    style: {
      color: 'var(--slate-400)',
      fontSize: 'var(--text-xs)'
    }
  }, "Gesch\xE4ftsf\xFChrer, coodoo GmbH"))))));
}
function Footer() {
  const cols = [{
    h: 'Service',
    links: ['Leistungen', 'Pakete & Preise', 'Management Summary', 'App-Care Cockpit', 'App KPIs Ratgeber']
  }, {
    h: 'Unternehmen',
    links: ['Team', 'Blog', 'Kontakt']
  }];
  return /*#__PURE__*/React.createElement("footer", {
    style: {
      background: 'var(--slate-950)',
      color: 'var(--slate-400)'
    }
  }, /*#__PURE__*/React.createElement("div", {
    className: "section-container",
    style: {
      paddingTop: '3.5rem',
      paddingBottom: '3.5rem'
    }
  }, /*#__PURE__*/React.createElement("div", {
    className: "footer-grid"
  }, /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("div", {
    style: {
      marginBottom: '1rem'
    }
  }, /*#__PURE__*/React.createElement(Logo, {
    onDark: true,
    size: "lg"
  })), /*#__PURE__*/React.createElement("p", {
    style: {
      fontSize: 'var(--text-sm)',
      lineHeight: 1.6,
      marginBottom: '1rem'
    }
  }, "Monatliches Betreuungspaket f\xFCr Mobile Apps. KPI-getrieben, messbar, verl\xE4sslich."), /*#__PURE__*/React.createElement("p", {
    style: {
      fontSize: 'var(--text-xs)',
      color: 'var(--slate-500)'
    }
  }, "Ein Service der ", /*#__PURE__*/React.createElement("a", {
    href: "https://coodoo.de",
    target: "_blank",
    rel: "noopener",
    style: {
      color: 'var(--slate-400)',
      textDecoration: 'underline',
      textUnderlineOffset: 2
    }
  }, "coodoo GmbH"))), cols.map((c, i) => /*#__PURE__*/React.createElement("div", {
    key: i
  }, /*#__PURE__*/React.createElement("h3", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 700,
      color: '#fff',
      fontSize: 'var(--text-sm)',
      marginBottom: '1rem'
    }
  }, c.h), /*#__PURE__*/React.createElement("ul", {
    style: {
      listStyle: 'none',
      padding: 0,
      margin: 0,
      display: 'flex',
      flexDirection: 'column',
      gap: '.65rem'
    }
  }, c.links.map((l, j) => /*#__PURE__*/React.createElement("li", {
    key: j
  }, /*#__PURE__*/React.createElement("a", {
    href: "#",
    onClick: e => e.preventDefault(),
    style: {
      fontSize: 'var(--text-sm)'
    },
    className: "footer-link"
  }, l)))))), /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("h3", {
    style: {
      fontFamily: 'var(--font-display)',
      fontWeight: 700,
      color: '#fff',
      fontSize: 'var(--text-sm)',
      marginBottom: '1rem'
    }
  }, "Kontakt"), /*#__PURE__*/React.createElement("address", {
    style: {
      fontStyle: 'normal',
      fontSize: 'var(--text-sm)',
      lineHeight: 1.7
    }
  }, /*#__PURE__*/React.createElement("p", null, "coodoo GmbH"), /*#__PURE__*/React.createElement("p", null, "Mainz, Deutschland"), /*#__PURE__*/React.createElement("a", {
    href: "mailto:info@app-care.de",
    style: {
      display: 'block',
      marginTop: '.75rem',
      color: 'var(--brand-400)'
    }
  }, "info@app-care.de")), /*#__PURE__*/React.createElement("a", {
    href: "#",
    onClick: e => e.preventDefault(),
    style: {
      display: 'inline-flex',
      alignItems: 'center',
      gap: 4,
      marginTop: '1rem',
      fontSize: 'var(--text-sm)',
      fontWeight: 500,
      color: 'var(--brand-400)'
    }
  }, "Gespr\xE4ch buchen", /*#__PURE__*/React.createElement(Icon, {
    name: "chevronRight",
    size: 12
  })))), /*#__PURE__*/React.createElement("div", {
    style: {
      borderTop: '1px solid var(--slate-800)',
      marginTop: '2.5rem',
      paddingTop: '1.5rem',
      display: 'flex',
      justifyContent: 'space-between',
      alignItems: 'center',
      flexWrap: 'wrap',
      gap: '.75rem'
    }
  }, /*#__PURE__*/React.createElement("p", {
    style: {
      fontSize: 'var(--text-xs)',
      color: 'var(--slate-500)'
    }
  }, "\xA9 ", new Date().getFullYear(), " App-Care / coodoo GmbH"), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: '1rem'
    }
  }, /*#__PURE__*/React.createElement("a", {
    href: "#",
    onClick: e => e.preventDefault(),
    style: {
      fontSize: 'var(--text-xs)',
      color: 'var(--slate-500)'
    },
    className: "footer-link"
  }, "Impressum"), /*#__PURE__*/React.createElement("a", {
    href: "#",
    onClick: e => e.preventDefault(),
    style: {
      fontSize: 'var(--text-xs)',
      color: 'var(--slate-500)'
    },
    className: "footer-link"
  }, "Datenschutz")))));
}
Object.assign(window, {
  TeamTeaser,
  Whitepaper,
  FinalCTA,
  Footer
});
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/website/SectionsD.jsx", error: String((e && e.message) || e) }); }

})();
