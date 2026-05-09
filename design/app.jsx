// keopi — main app shell

const { useState: useStateApp, useEffect: useEffectApp, useRef: useRefApp } = React;

const TWEAK_DEFAULTS = /*EDITMODE-BEGIN*/{
  "palette": "terra",
  "darkMode": false,
  "font": "serif",
  "homeLayout": "strip"
}/*EDITMODE-END*/;

function App() {
  const data = window.KEOPI_DATA;
  const [tab, setTab] = useStateApp('home');
  const [stack, setStack] = useStateApp([]); // stack of modal screens
  const [pendingCat, setPendingCat] = useStateApp(null);
  const [cart, setCart] = useStateApp([]);
  const [orderInfo, setOrderInfo] = useStateApp(null);
  const [user, setUser] = useStateApp(data.user);
  const [store, setStore] = useStateApp(data.stores[0]);
  const [toast, setToast] = useStateApp(null);

  const [tweaks, setTweak] = useTweaks(TWEAK_DEFAULTS);

  // Apply theme attrs to deepest container
  useEffectApp(() => {
    const root = document.documentElement;
    root.setAttribute('data-palette', tweaks.palette);
    root.setAttribute('data-theme', tweaks.darkMode ? 'dark' : 'light');
    root.setAttribute('data-font', tweaks.font);
  }, [tweaks]);

  function showToast(msg) {
    setToast(msg);
    setTimeout(() => setToast(null), 1800);
  }

  function pushScreen(name) {
    setStack(s => [...s, name]);
  }
  function popScreen() {
    setStack(s => s.slice(0, -1));
  }
  function clearStack() {
    setStack([]);
  }

  function handleNavigate(target) {
    if (target.startsWith('product:')) {
      const id = target.split(':')[1];
      const p = data.products.find(x => x.id === id);
      if (p) pushScreen({ kind: 'product', product: p });
    } else if (target === 'past') {
      pushScreen({ kind: 'past' });
    } else if (target === 'stores') {
      pushScreen({ kind: 'stores' });
    } else if (target === 'cart') {
      pushScreen({ kind: 'cart' });
    } else if (target === 'gift' || target === 'referral') {
      showToast('Yakında — şimdilik mockup');
    }
  }

  function handleAddToCart(item) {
    setCart(c => [...c, item]);
    popScreen();
    showToast(`${item.product.name} sepete eklendi`);
  }

  function handleUpdateCart(idx, qty) {
    if (qty <= 0) {
      setCart(c => c.filter((_, i) => i !== idx));
    } else {
      setCart(c => c.map((it, i) => i === idx ? { ...it, qty, total: it.unit * qty } : it));
    }
  }

  function handleCheckout() {
    pushScreen({ kind: 'checkout' });
  }

  function handlePay(payInfo) {
    const id = '28' + Math.floor(Math.random() * 90 + 10);
    setOrderInfo({ id, cart, total: payInfo.total });
    setUser(u => ({
      ...u,
      stamps: Math.min(5, u.stamps + cart.length),
      points: u.points + Math.floor(payInfo.total / 10) - (payInfo.pointsDiscount * 10),
    }));
    setStack([{ kind: 'tracking' }]);
  }

  function handleTrackingDone() {
    setCart([]);
    setOrderInfo(null);
    clearStack();
    setTab('home');
  }

  function handleTabChange(t, cat) {
    setTab(t);
    if (cat) setPendingCat(cat);
    clearStack();
  }

  function handleReorder(o) {
    // crude: pick first product matching name
    const items = o.items.map(it => {
      const p = data.products.find(x => x.name === it.name) || data.products[0];
      return {
        product: p, qty: it.qty,
        size: 'medium', milk: 'whole', shots: '2', syrup: null, note: '',
        unit: p.price, total: p.price * it.qty,
      };
    });
    setCart(items);
    clearStack();
    pushScreen({ kind: 'cart' });
    showToast('Sepete eklendi');
  }

  // Determine top-of-stack screen
  const top = stack[stack.length - 1];

  return (
    <div style={{ minHeight: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: 24, position: 'relative' }}>

      {/* Background warmth */}
      <div style={{
        position: 'fixed', inset: 0, zIndex: 0,
        background: 'radial-gradient(ellipse at top, #3D2817 0%, #1F1410 60%, #0F0A07 100%)',
      }}/>
      <div style={{
        position: 'fixed', inset: 0, zIndex: 0, opacity: 0.05,
        backgroundImage: 'radial-gradient(circle, #F5EFE6 1px, transparent 1.5px)',
        backgroundSize: '32px 32px',
      }}/>

      <div style={{ position: 'relative', zIndex: 1 }}>
        <IOSDevice width={402} height={874} dark={tweaks.darkMode}>
          <div style={{ position: 'absolute', inset: 0, background: 'var(--bg)', overflow: 'hidden' }}>
            {/* Tab content (always rendered, cheap to keep mounted) */}
            <div style={{ position: 'absolute', inset: 0 }}>
              {tab === 'home' && (
                <HomeScreen data={data} user={user} store={store} layout={tweaks.homeLayout}
                  onNavigate={handleNavigate} onTab={handleTabChange} />
              )}
              {tab === 'menu' && (
                <MenuScreen data={data} initialCat={pendingCat} cart={cart}
                  onProduct={(p) => pushScreen({ kind: 'product', product: p })} />
              )}
              {tab === 'loyalty' && (
                <LoyaltyScreen data={data} user={user} onNavigate={handleNavigate} />
              )}
              {tab === 'profile' && (
                <ProfileScreen user={user} onNavigate={handleNavigate} onTab={handleTabChange} />
              )}
            </div>

            {/* Tab bar (hidden when modal stack on top) */}
            {!top && <TabBar active={tab} onChange={handleTabChange} />}

            {/* Floating cart preview on Menu tab */}
            {tab === 'menu' && cart.length > 0 && !top && (
              <button onClick={() => pushScreen({ kind: 'cart' })} style={{
                position: 'absolute', bottom: 90, left: 16, right: 16,
                background: 'var(--coffee)', color: 'var(--cream)',
                borderRadius: 18, padding: '14px 18px',
                display: 'flex', alignItems: 'center', justifyContent: 'space-between',
                boxShadow: '0 12px 28px rgba(0,0,0,0.25)',
                zIndex: 5,
              }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                  <div style={{ width: 32, height: 32, borderRadius: '50%', background: 'var(--accent)', color: '#FFFBF5', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 13, fontWeight: 700, fontFamily: 'var(--font-mono)' }}>
                    {cart.reduce((s, it) => s + it.qty, 0)}
                  </div>
                  <span style={{ fontSize: 14, fontWeight: 600 }}>Sepete bak</span>
                </div>
                <span style={{ fontFamily: 'var(--font-mono)', fontWeight: 600 }}>
                  {fmtTL(cart.reduce((s, it) => s + it.total, 0))}
                </span>
              </button>
            )}

            {/* Modal screens (slide-up) */}
            {top && (
              <div style={{
                position: 'absolute', inset: 0, zIndex: 20,
                animation: 'kp-slide-up 0.28s cubic-bezier(0.2, 0.8, 0.2, 1)',
              }}>
                {top.kind === 'product' && (
                  <ProductScreen data={data} product={top.product} onBack={popScreen} onAdd={handleAddToCart} />
                )}
                {top.kind === 'cart' && (
                  <CartScreen cart={cart} store={store} onBack={popScreen} onUpdate={handleUpdateCart} onCheckout={handleCheckout} />
                )}
                {top.kind === 'checkout' && (
                  <CheckoutScreen cart={cart} store={store} user={user} onBack={popScreen} onPay={handlePay} />
                )}
                {top.kind === 'tracking' && (
                  <TrackingScreen store={store} orderInfo={orderInfo} onDone={handleTrackingDone} onNavigate={handleNavigate} />
                )}
                {top.kind === 'past' && (
                  <PastOrdersScreen data={data} onBack={popScreen} onReorder={handleReorder} />
                )}
                {top.kind === 'stores' && (
                  <StoresScreen data={data} current={store} onPick={(s) => { setStore(s); popScreen(); showToast('Mağaza güncellendi'); }} onBack={popScreen} />
                )}
              </div>
            )}

            {/* Toast */}
            {toast && (
              <div style={{
                position: 'absolute', bottom: 110, left: '50%', transform: 'translateX(-50%)',
                background: 'var(--coffee)', color: 'var(--cream)',
                padding: '12px 20px', borderRadius: 999,
                fontSize: 13, fontWeight: 500,
                whiteSpace: 'nowrap', zIndex: 30,
                boxShadow: '0 12px 28px rgba(0,0,0,0.3)',
                animation: 'kp-toast 0.25s ease',
              }}>{toast}</div>
            )}
          </div>
          <style>{`
            @keyframes kp-slide-up {
              from { transform: translateY(100%); opacity: 0.6; }
              to { transform: translateY(0); opacity: 1; }
            }
            @keyframes kp-toast {
              from { transform: translate(-50%, 12px); opacity: 0; }
              to { transform: translate(-50%, 0); opacity: 1; }
            }
          `}</style>
        </IOSDevice>

        {/* Side caption */}
        <div style={{ marginTop: 18, textAlign: 'center', color: 'rgba(245,239,230,0.5)', fontSize: 12, fontFamily: 'var(--font-mono)', letterSpacing: 0.5 }}>
          KEOPI · MOBILE PROTOTYPE · PROOF OF FLOW
        </div>
      </div>

      {/* Tweaks Panel */}
      <TweaksPanel>
        <TweakSection label="Renk teması">
          <TweakRadio
            label="Palet"
            value={tweaks.palette}
            options={['terra', 'forest', 'dusk']}
            onChange={(v) => setTweak('palette', v)}
          />
        </TweakSection>
        <TweakSection label="Görünüm">
          <TweakToggle label="Koyu mod" value={tweaks.darkMode} onChange={(v) => setTweak('darkMode', v)} />
          <TweakRadio
            label="Tipografi"
            value={tweaks.font}
            options={['serif', 'grotesk', 'editorial']}
            onChange={(v) => setTweak('font', v)}
          />
        </TweakSection>
        <TweakSection label="Ana ekran">
          <TweakRadio
            label="Kategoriler"
            value={tweaks.homeLayout}
            options={['strip', 'grid']}
            onChange={(v) => setTweak('homeLayout', v)}
          />
        </TweakSection>
      </TweaksPanel>
    </div>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(<App />);
