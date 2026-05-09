// keopi screens 2 — Menu, Product, Cart, Checkout, Tracking

const { useState: useState2, useEffect: useEffect2, useMemo: useMemo2 } = React;

// ─── MENU ─────────────────────────────────────────────────────
function MenuScreen({ data, initialCat, onProduct, cart }) {
  const [cat, setCat] = useState2(initialCat || 'popular');
  const [query, setQuery] = useState2('');

  const filtered = data.products.filter(p => {
    if (query) return p.name.toLowerCase().includes(query.toLowerCase()) || p.en.toLowerCase().includes(query.toLowerCase());
    return p.cat === cat;
  });

  return (
    <Screen label="02 Menü" padTop={56} padBottom={cart.length > 0 ? 170 : 100}>
      <div style={{ padding: '8px 20px 14px' }}>
        <div style={{ fontFamily: 'var(--font-display)', fontSize: 32, color: 'var(--coffee)', letterSpacing: -0.02 }}>Menü</div>
      </div>

      {/* Search */}
      <div style={{ padding: '0 20px 14px' }}>
        <div style={{
          background: 'var(--card)', border: '1px solid var(--line)',
          borderRadius: 14, padding: '12px 14px',
          display: 'flex', alignItems: 'center', gap: 10,
        }}>
          {Icon.search({ size: 18 })}
          <input
            value={query}
            onChange={e => setQuery(e.target.value)}
            placeholder="Ne içmek istersin?"
            style={{
              flex: 1, border: 'none', outline: 'none', background: 'transparent',
              fontSize: 14, fontFamily: 'inherit', color: 'var(--text)',
            }}
          />
          {query && <button onClick={() => setQuery('')} style={{ color: 'var(--text-muted)' }}>{Icon.close({ size: 18 })}</button>}
        </div>
      </div>

      {/* Category tabs */}
      <div style={{ display: 'flex', overflowX: 'auto', gap: 8, padding: '0 20px 18px', scrollbarWidth: 'none' }} className="kp-scroll">
        {data.categories.map(c => (
          <button key={c.id} onClick={() => { setCat(c.id); setQuery(''); }} style={{
            flex: '0 0 auto',
            padding: '9px 16px', borderRadius: 999,
            background: cat === c.id && !query ? 'var(--coffee)' : 'var(--card)',
            color: cat === c.id && !query ? 'var(--cream)' : 'var(--coffee)',
            border: '1px solid ' + (cat === c.id && !query ? 'var(--coffee)' : 'var(--line)'),
            fontSize: 13, fontWeight: 600,
            display: 'flex', alignItems: 'center', gap: 6,
          }}>
            <span>{c.emoji}</span> {c.name}
          </button>
        ))}
      </div>

      {/* Section title */}
      <div style={{ padding: '0 20px 12px', display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', gap: 12 }}>
        <div style={{ fontFamily: 'var(--font-display)', fontSize: 22, color: 'var(--coffee)', letterSpacing: -0.01, whiteSpace: 'nowrap', flex: 1, minWidth: 0, overflow: 'hidden', textOverflow: 'ellipsis' }}>
          {query ? `"${query}"` : (data.categories.find(c => c.id === cat)?.name)}
        </div>
        <span style={{ fontFamily: 'var(--font-mono)', fontSize: 11, color: 'var(--text-muted)', whiteSpace: 'nowrap' }}>{filtered.length} ürün</span>
      </div>

      {/* Product list */}
      <div style={{ padding: '0 20px', display: 'flex', flexDirection: 'column', gap: 10 }}>
        {filtered.length === 0 ? (
          <div style={{ padding: '40px 20px', textAlign: 'center', color: 'var(--text-muted)', fontSize: 14 }}>
            Aradığın ürün bulunamadı.
          </div>
        ) : filtered.map(p => <ProductRow key={p.id} p={p} onClick={() => onProduct(p)} />)}
      </div>

      <div style={{ height: 24 }} />
    </Screen>
  );
}

// ─── PRODUCT DETAIL ───────────────────────────────────────────
function ProductScreen({ data, product, onBack, onAdd }) {
  const [size, setSize] = useState2('medium');
  const [milk, setMilk] = useState2('whole');
  const [shots, setShots] = useState2('2');
  const [syrup, setSyrup] = useState2(null);
  const [qty, setQty] = useState2(1);
  const [note, setNote] = useState2('');
  const [fav, setFav] = useState2(false);

  const isCoffee = product.cat === 'hot' || product.cat === 'cold' || (product.cat === 'popular' && product.id !== 'p2');
  const isFood = product.cat === 'food' || product.cat === 'sweet';

  const sizeDelta = data.sizes.find(s => s.id === size)?.delta || 0;
  const milkDelta = isCoffee ? (data.milks.find(m => m.id === milk)?.delta || 0) : 0;
  const shotDelta = isCoffee ? (data.shots.find(s => s.id === shots)?.delta || 0) : 0;
  const syrupDelta = syrup ? (data.syrups.find(s => s.id === syrup)?.delta || 0) : 0;
  const unit = product.price + sizeDelta + milkDelta + shotDelta + syrupDelta;
  const total = unit * qty;

  return (
    <div data-screen-label="03 Ürün Detay" style={{ position: 'absolute', inset: 0, background: 'var(--bg)', display: 'flex', flexDirection: 'column' }}>
      {/* Hero */}
      <div className="kp-scroll" style={{ flex: 1, paddingBottom: 120 }}>
        <div style={{ position: 'relative', background: 'var(--cream)', height: 320, paddingTop: 56 }}>
          <div style={{ position: 'absolute', top: 56, left: 16, right: 16, display: 'flex', justifyContent: 'space-between', zIndex: 2 }}>
            <button onClick={onBack} style={iconBtnStyle()}>{Icon.chevL({ size: 18 })}</button>
            <button onClick={() => setFav(!fav)} style={{ ...iconBtnStyle(), color: fav ? 'var(--accent)' : 'var(--coffee)' }}>
              {Icon.heart({ size: 18, fill: fav ? 'currentColor' : 'none' })}
            </button>
          </div>
          <div style={{ position: 'absolute', inset: 0, display: 'flex', alignItems: 'center', justifyContent: 'center', paddingTop: 40 }}>
            <CoffeeTile kind={illuFor(product)} size={220} fg="var(--coffee)" bg="transparent" />
          </div>
          {/* Decorative dots */}
          <div style={{ position: 'absolute', inset: 0, opacity: 0.06,
            backgroundImage: 'radial-gradient(circle, var(--coffee) 1px, transparent 1.5px)',
            backgroundSize: '20px 20px',
          }}/>
        </div>

        {/* Body */}
        <div style={{ background: 'var(--bg)', borderRadius: '28px 28px 0 0', marginTop: -28, padding: '22px 22px 0', position: 'relative' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', gap: 12 }}>
            <div style={{ flex: 1 }}>
              {product.tag && <div style={{ marginBottom: 6 }}><span className="kp-tag">{product.tag}</span></div>}
              <div style={{ fontFamily: 'var(--font-display)', fontSize: 32, lineHeight: 1.05, color: 'var(--coffee)', letterSpacing: -0.02 }}>{product.name}</div>
              <div style={{ fontSize: 13, color: 'var(--text-muted)', marginTop: 2, fontStyle: 'italic' }}>{product.en}</div>
            </div>
            <div style={{ fontFamily: 'var(--font-mono)', fontSize: 22, fontWeight: 600, color: 'var(--accent)' }}>{fmtTL(unit)}</div>
          </div>

          <div style={{ marginTop: 12, fontSize: 14, lineHeight: 1.5, color: 'var(--text-muted)', textWrap: 'pretty' }}>
            {product.desc}
          </div>

          <div style={{ marginTop: 14, display: 'flex', gap: 16, fontSize: 11, color: 'var(--text-muted)', fontFamily: 'var(--font-mono)', letterSpacing: 0.3 }}>
            <span>{product.kcal} KCAL</span>
            {isCoffee && <span>%100 ARABICA</span>}
            <span>VEGAN OPSİYONLU</span>
          </div>

          {/* Size selector */}
          <Section title="Boy">
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 8 }}>
              {data.sizes.map(s => (
                <button key={s.id} onClick={() => setSize(s.id)} style={{
                  padding: '14px 8px', borderRadius: 16,
                  background: size === s.id ? 'var(--coffee)' : 'var(--card)',
                  color: size === s.id ? 'var(--cream)' : 'var(--coffee)',
                  border: '1px solid ' + (size === s.id ? 'var(--coffee)' : 'var(--line)'),
                  display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4,
                }}>
                  <CoffeeTile kind="cup" size={s.id === 'small' ? 30 : s.id === 'medium' ? 36 : 42} fg="currentColor" bg="transparent" />
                  <div style={{ fontSize: 13, fontWeight: 600 }}>{s.name}</div>
                  <div style={{ fontFamily: 'var(--font-mono)', fontSize: 10, opacity: 0.7 }}>{s.ml}</div>
                </button>
              ))}
            </div>
          </Section>

          {isCoffee && (
            <>
              <Section title="Süt seçimi">
                <Chips items={data.milks} value={milk} onChange={setMilk} />
              </Section>
              <Section title="Espresso shot">
                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 8 }}>
                  {data.shots.map(s => (
                    <button key={s.id} onClick={() => setShots(s.id)} style={{
                      padding: '12px', borderRadius: 14,
                      background: shots === s.id ? 'var(--coffee)' : 'var(--card)',
                      color: shots === s.id ? 'var(--cream)' : 'var(--coffee)',
                      border: '1px solid ' + (shots === s.id ? 'var(--coffee)' : 'var(--line)'),
                      fontSize: 13, fontWeight: 600,
                      display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 6,
                    }}>
                      {Icon.flame({ size: 14 })} {s.name}
                    </button>
                  ))}
                </div>
              </Section>
              <Section title="Aroma şurubu">
                <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
                  <SyrupChip label="Yok" active={!syrup} onClick={() => setSyrup(null)} delta={null} />
                  {data.syrups.map(s => (
                    <SyrupChip key={s.id} label={s.name} active={syrup === s.id} delta={s.delta} onClick={() => setSyrup(s.id === syrup ? null : s.id)} />
                  ))}
                </div>
              </Section>
            </>
          )}

          <Section title="Not (opsiyonel)">
            <input
              value={note}
              onChange={e => setNote(e.target.value)}
              placeholder="Az şekerli, ekstra sıcak…"
              style={{
                width: '100%', padding: '14px 16px',
                background: 'var(--card)', border: '1px solid var(--line)',
                borderRadius: 14, fontSize: 13,
                color: 'var(--text)', fontFamily: 'inherit',
                outline: 'none',
              }}
            />
          </Section>
        </div>
      </div>

      {/* Bottom CTA bar */}
      <div style={{
        position: 'absolute', bottom: 0, left: 0, right: 0,
        background: 'var(--card)', borderTop: '1px solid var(--line)',
        padding: '14px 20px 32px',
        display: 'flex', alignItems: 'center', gap: 12,
      }}>
        <div style={{
          display: 'flex', alignItems: 'center', gap: 10,
          background: 'var(--cream)', borderRadius: 999, padding: 4,
        }}>
          <button onClick={() => setQty(Math.max(1, qty-1))} style={{
            width: 36, height: 36, borderRadius: '50%', background: 'var(--card)',
            display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'var(--coffee)',
          }}>{Icon.minus({ size: 16 })}</button>
          <div style={{ minWidth: 16, textAlign: 'center', fontFamily: 'var(--font-mono)', fontSize: 15, fontWeight: 600 }}>{qty}</div>
          <button onClick={() => setQty(qty+1)} style={{
            width: 36, height: 36, borderRadius: '50%', background: 'var(--card)',
            display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'var(--coffee)',
          }}>{Icon.plus({ size: 16 })}</button>
        </div>

        <button onClick={() => onAdd({
          product, qty, size, milk: isCoffee ? milk : null,
          shots: isCoffee ? shots : null, syrup, note, unit, total,
        })} style={{
          flex: 1, height: 52, borderRadius: 999,
          background: 'var(--accent)', color: '#FFFBF5',
          fontSize: 15, fontWeight: 600,
          display: 'flex', alignItems: 'center', justifyContent: 'space-between',
          padding: '0 22px',
        }}>
          <span>Sepete ekle</span>
          <span style={{ fontFamily: 'var(--font-mono)' }}>{fmtTL(total)}</span>
        </button>
      </div>
    </div>
  );
}

function Section({ title, children }) {
  return (
    <div style={{ marginTop: 22 }}>
      <div style={{ fontSize: 13, fontWeight: 700, color: 'var(--coffee)', letterSpacing: 0.4, textTransform: 'uppercase', marginBottom: 10 }}>{title}</div>
      {children}
    </div>
  );
}

function Chips({ items, value, onChange }) {
  return (
    <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
      {items.map(it => (
        <button key={it.id} onClick={() => onChange(it.id)} style={{
          padding: '10px 16px', borderRadius: 999,
          background: value === it.id ? 'var(--coffee)' : 'var(--card)',
          color: value === it.id ? 'var(--cream)' : 'var(--coffee)',
          border: '1px solid ' + (value === it.id ? 'var(--coffee)' : 'var(--line)'),
          fontSize: 13, fontWeight: 600,
          display: 'flex', alignItems: 'center', gap: 6,
        }}>
          {it.name}
          {it.delta > 0 && <span style={{ fontFamily: 'var(--font-mono)', fontSize: 10, opacity: 0.7 }}>+₺{it.delta}</span>}
        </button>
      ))}
    </div>
  );
}

function SyrupChip({ label, active, delta, onClick }) {
  return (
    <button onClick={onClick} style={{
      padding: '10px 16px', borderRadius: 999,
      background: active ? 'var(--coffee)' : 'var(--card)',
      color: active ? 'var(--cream)' : 'var(--coffee)',
      border: '1px solid ' + (active ? 'var(--coffee)' : 'var(--line)'),
      fontSize: 13, fontWeight: 600,
      display: 'flex', alignItems: 'center', gap: 6,
    }}>
      {label}
      {delta && <span style={{ fontFamily: 'var(--font-mono)', fontSize: 10, opacity: 0.7 }}>+₺{delta}</span>}
    </button>
  );
}

// ─── CART ─────────────────────────────────────────────────────
function CartScreen({ cart, onBack, onUpdate, onCheckout, store }) {
  const subtotal = cart.reduce((s, it) => s + it.total, 0);
  const fee = cart.length > 0 ? 0 : 0; // pickup, no fee
  const total = subtotal + fee;

  return (
    <Screen label="04 Sepet" padTop={56} padBottom={cart.length > 0 ? 200 : 60}>
      <div style={{ padding: '4px 16px 14px', display: 'flex', alignItems: 'center', gap: 10 }}>
        <button onClick={onBack} style={iconBtnStyle()}>{Icon.chevL({ size: 18 })}</button>
        <div style={{ fontFamily: 'var(--font-display)', fontSize: 28, color: 'var(--coffee)', letterSpacing: -0.02 }}>Sepetim</div>
        <span style={{ marginLeft: 'auto', fontFamily: 'var(--font-mono)', fontSize: 12, color: 'var(--text-muted)' }}>{cart.length} ürün</span>
      </div>

      {/* Pickup info */}
      <div style={{ padding: '0 20px 14px' }}>
        <div style={{ background: 'var(--card)', border: '1px solid var(--line)', borderRadius: 18, padding: '14px 16px', display: 'flex', alignItems: 'center', gap: 12 }}>
          <div style={{
            width: 40, height: 40, borderRadius: 12,
            background: 'var(--tag-bg)', color: 'var(--accent)',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
          }}>{Icon.truck({ size: 20 })}</div>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 11, color: 'var(--text-muted)', letterSpacing: 0.3, textTransform: 'uppercase' }}>Pickup</div>
            <div style={{ fontSize: 14, fontWeight: 600, color: 'var(--coffee)' }}>{store.name} · ~12 dk</div>
          </div>
          <button style={{ fontSize: 12, color: 'var(--accent)', fontWeight: 600 }}>Değiştir</button>
        </div>
      </div>

      {cart.length === 0 ? (
        <div style={{ padding: '60px 24px', textAlign: 'center' }}>
          <CoffeeTile kind="cup" size={120} fg="var(--coffee)" bg="var(--cream)" />
          <div style={{ fontFamily: 'var(--font-display)', fontSize: 22, color: 'var(--coffee)', marginTop: 16, letterSpacing: -0.01 }}>Sepetin boş</div>
          <div style={{ fontSize: 13, color: 'var(--text-muted)', marginTop: 6 }}>Bir kahve seç, sıcak gelsin.</div>
        </div>
      ) : (
        <>
          <div style={{ padding: '0 20px', display: 'flex', flexDirection: 'column', gap: 10 }}>
            {cart.map((it, i) => <CartRow key={i} item={it} onUpdate={(q) => onUpdate(i, q)} />)}
          </div>

          {/* Add more */}
          <div style={{ padding: '14px 20px 0' }}>
            <button onClick={onBack} style={{
              width: '100%', padding: '12px', borderRadius: 14,
              background: 'transparent', border: '1.5px dashed var(--line-strong)',
              color: 'var(--coffee)', fontSize: 13, fontWeight: 600,
              display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
            }}>{Icon.plus({ size: 16 })} Daha fazla ekle</button>
          </div>

          {/* Promo + summary */}
          <div style={{ padding: '20px' }}>
            <div style={{ background: 'var(--card)', border: '1px solid var(--line)', borderRadius: 18, padding: '14px 16px', display: 'flex', alignItems: 'center', gap: 10, marginBottom: 14 }}>
              <div style={{ width: 32, height: 32, borderRadius: '50%', background: 'var(--tag-bg)', color: 'var(--accent)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>{Icon.gift({ size: 16 })}</div>
              <span style={{ flex: 1, fontSize: 13, color: 'var(--coffee)', fontWeight: 500 }}>İndirim kodu ekle</span>
              {Icon.chevR({ size: 16 })}
            </div>

            <div style={{ display: 'flex', flexDirection: 'column', gap: 6, fontSize: 13 }}>
              <SumRow label="Ara toplam" value={fmtTL(subtotal)} />
              <SumRow label="Pickup ücreti" value="Ücretsiz" green />
              <SumRow label={`+${Math.floor(subtotal/10)} sadakat puanı kazanacaksın`} value="" muted />
            </div>
          </div>
        </>
      )}

      {/* Bottom CTA */}
      {cart.length > 0 && (
        <div style={{
          position: 'absolute', bottom: 0, left: 0, right: 0,
          background: 'var(--card)', borderTop: '1px solid var(--line)',
          padding: '14px 20px 32px',
        }}>
          <button onClick={onCheckout} style={{
            width: '100%', height: 56, borderRadius: 999,
            background: 'var(--accent)', color: '#FFFBF5',
            fontSize: 15, fontWeight: 600,
            display: 'flex', alignItems: 'center', justifyContent: 'space-between',
            padding: '0 22px',
          }}>
            <span>Ödemeye geç</span>
            <span style={{ fontFamily: 'var(--font-mono)' }}>{fmtTL(total)}</span>
          </button>
        </div>
      )}
    </Screen>
  );
}

function SumRow({ label, value, green, muted }) {
  return (
    <div style={{ display: 'flex', justifyContent: 'space-between', color: muted ? 'var(--accent)' : 'var(--text-muted)', fontWeight: muted ? 600 : 400 }}>
      <span>{label}</span>
      <span style={{ fontFamily: 'var(--font-mono)', color: green ? 'var(--success)' : (muted ? 'var(--accent)' : 'var(--coffee)'), fontWeight: 600 }}>{value}</span>
    </div>
  );
}

function CartRow({ item, onUpdate }) {
  const { product, qty, size, milk, shots, syrup, note, total } = item;
  const mods = [
    size && KEOPI_DATA.sizes.find(s => s.id === size)?.name,
    milk && KEOPI_DATA.milks.find(m => m.id === milk)?.name + ' süt',
    shots && shots + ' shot',
    syrup && KEOPI_DATA.syrups.find(s => s.id === syrup)?.name,
  ].filter(Boolean).join(' · ');

  return (
    <div style={{ background: 'var(--card)', border: '1px solid var(--line)', borderRadius: 18, padding: 14, display: 'flex', gap: 12 }}>
      <CoffeeTile kind={illuFor(product)} size={64} fg="var(--coffee)" bg="var(--cream)" />
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ fontSize: 14, fontWeight: 600, color: 'var(--coffee)' }}>{product.name}</div>
        <div style={{ fontSize: 11, color: 'var(--text-muted)', marginTop: 2 }}>{mods}</div>
        {note && <div style={{ fontSize: 11, color: 'var(--accent)', marginTop: 4, fontStyle: 'italic' }}>“{note}”</div>}
        <div style={{ marginTop: 8, display: 'flex', alignItems: 'center', gap: 10 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 6, background: 'var(--cream)', borderRadius: 999, padding: 3 }}>
            <button onClick={() => onUpdate(qty - 1)} style={{ width: 26, height: 26, borderRadius: '50%', background: 'var(--card)', display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'var(--coffee)' }}>{Icon.minus({ size: 12 })}</button>
            <span style={{ minWidth: 14, textAlign: 'center', fontFamily: 'var(--font-mono)', fontSize: 13, fontWeight: 600 }}>{qty}</span>
            <button onClick={() => onUpdate(qty + 1)} style={{ width: 26, height: 26, borderRadius: '50%', background: 'var(--card)', display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'var(--coffee)' }}>{Icon.plus({ size: 12 })}</button>
          </div>
          <span style={{ marginLeft: 'auto', fontFamily: 'var(--font-mono)', fontSize: 14, fontWeight: 600, color: 'var(--coffee)' }}>{fmtTL(total)}</span>
        </div>
      </div>
    </div>
  );
}

// ─── CHECKOUT ─────────────────────────────────────────────────
function CheckoutScreen({ cart, store, user, onBack, onPay }) {
  const [method, setMethod] = useState2('saved');
  const [tip, setTip] = useState2(0);
  const [usePoints, setUsePoints] = useState2(false);

  const subtotal = cart.reduce((s, it) => s + it.total, 0);
  const pointsDiscount = usePoints ? Math.min(50, Math.floor(user.points / 10)) : 0;
  const total = subtotal + tip - pointsDiscount;

  return (
    <Screen label="05 Ödeme" padTop={56} padBottom={130}>
      <div style={{ padding: '4px 16px 14px', display: 'flex', alignItems: 'center', gap: 10 }}>
        <button onClick={onBack} style={iconBtnStyle()}>{Icon.chevL({ size: 18 })}</button>
        <div style={{ fontFamily: 'var(--font-display)', fontSize: 28, color: 'var(--coffee)', letterSpacing: -0.02 }}>Ödeme</div>
      </div>

      {/* Pickup details */}
      <div style={{ padding: '0 20px 14px' }}>
        <div style={{ background: 'var(--card)', border: '1px solid var(--line)', borderRadius: 18, padding: '14px 16px' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
            <div style={{ width: 40, height: 40, borderRadius: 12, background: 'var(--tag-bg)', color: 'var(--accent)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>{Icon.pin({ size: 18 })}</div>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 13, fontWeight: 600, color: 'var(--coffee)' }}>{store.name}</div>
              <div style={{ fontSize: 11, color: 'var(--text-muted)' }}>{store.address}</div>
            </div>
            <div style={{ textAlign: 'right' }}>
              <div style={{ fontSize: 11, color: 'var(--text-muted)', textTransform: 'uppercase', letterSpacing: 0.3 }}>Hazır</div>
              <div style={{ fontFamily: 'var(--font-mono)', fontSize: 14, color: 'var(--accent)', fontWeight: 600 }}>~12 dk</div>
            </div>
          </div>
        </div>
      </div>

      {/* Payment method */}
      <Section2 title="Ödeme yöntemi">
        <PayOption icon="card" label="Visa **24" sub="Varsayılan" active={method === 'saved'} onClick={() => setMethod('saved')} />
        <PayOption icon="apple" label="Apple Pay" sub="Touch ID ile" active={method === 'apple'} onClick={() => setMethod('apple')} />
        <PayOption icon="qr" label="Mağazada QR ile öde" sub="Kasada göster" active={method === 'qr'} onClick={() => setMethod('qr')} />
      </Section2>

      {/* Use points toggle */}
      <Section2 title="Sadakat">
        <div style={{ background: 'var(--card)', border: '1px solid var(--line)', borderRadius: 16, padding: '14px 16px', display: 'flex', alignItems: 'center', gap: 12 }}>
          <div style={{ width: 36, height: 36, borderRadius: '50%', background: 'var(--tag-bg)', color: 'var(--accent)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>{Icon.star({ size: 18, fill: 'currentColor' })}</div>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 13, fontWeight: 600, color: 'var(--coffee)' }}>Puanlarımı kullan</div>
            <div style={{ fontSize: 11, color: 'var(--text-muted)' }}>Bakiye: {user.points} puan → ₺{Math.floor(user.points/10)} indirim</div>
          </div>
          <button onClick={() => setUsePoints(!usePoints)} style={{
            width: 44, height: 26, borderRadius: 999,
            background: usePoints ? 'var(--accent)' : 'var(--cream)',
            border: '1px solid var(--line)',
            position: 'relative', transition: 'background 0.2s',
          }}>
            <div style={{
              position: 'absolute', top: 2, left: usePoints ? 20 : 2,
              width: 20, height: 20, borderRadius: '50%',
              background: '#FFFBF5', transition: 'left 0.2s',
              boxShadow: '0 1px 3px rgba(0,0,0,0.2)',
            }}/>
          </button>
        </div>
      </Section2>

      {/* Tip */}
      <Section2 title="Barista'ya bahşiş">
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 8 }}>
          {[0, 10, 20, 30].map(t => (
            <button key={t} onClick={() => setTip(t)} style={{
              padding: '12px 6px', borderRadius: 14,
              background: tip === t ? 'var(--coffee)' : 'var(--card)',
              color: tip === t ? 'var(--cream)' : 'var(--coffee)',
              border: '1px solid ' + (tip === t ? 'var(--coffee)' : 'var(--line)'),
              fontSize: 13, fontWeight: 600, fontFamily: 'var(--font-mono)',
            }}>{t === 0 ? 'Yok' : '₺' + t}</button>
          ))}
        </div>
      </Section2>

      {/* Summary */}
      <div style={{ padding: '0 20px', marginTop: 22 }}>
        <div style={{ background: 'var(--card)', border: '1px solid var(--line)', borderRadius: 18, padding: '16px 18px' }}>
          <div style={{ fontSize: 11, color: 'var(--text-muted)', letterSpacing: 0.3, textTransform: 'uppercase', marginBottom: 10 }}>Özet</div>
          <SumRow label="Ara toplam" value={fmtTL(subtotal)} />
          <SumRow label="Pickup ücreti" value="Ücretsiz" green />
          {tip > 0 && <SumRow label="Bahşiş" value={fmtTL(tip)} />}
          {usePoints && pointsDiscount > 0 && <SumRow label="Puan indirimi" value={`−${fmtTL(pointsDiscount)}`} green />}
          <div style={{ borderTop: '1px solid var(--line)', marginTop: 10, paddingTop: 10, display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <span style={{ fontSize: 14, fontWeight: 600, color: 'var(--coffee)' }}>Toplam</span>
            <span style={{ fontFamily: 'var(--font-mono)', fontSize: 20, fontWeight: 600, color: 'var(--coffee)' }}>{fmtTL(total)}</span>
          </div>
        </div>
      </div>

      {/* CTA */}
      <div style={{
        position: 'absolute', bottom: 0, left: 0, right: 0,
        background: 'var(--card)', borderTop: '1px solid var(--line)',
        padding: '14px 20px 32px',
      }}>
        <button onClick={() => onPay({ method, tip, total, usePoints, pointsDiscount })} style={{
          width: '100%', height: 56, borderRadius: 999,
          background: 'var(--coffee)', color: 'var(--cream)',
          fontSize: 15, fontWeight: 600,
          display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 10,
        }}>
          {method === 'apple' && Icon.apple({ size: 18 })}
          {method === 'qr' ? 'QR oluştur' : `${fmtTL(total)} öde`}
        </button>
      </div>
    </Screen>
  );
}

function Section2({ title, children }) {
  return (
    <div style={{ padding: '0 20px', marginTop: 18 }}>
      <div style={{ fontSize: 12, fontWeight: 700, color: 'var(--coffee)', letterSpacing: 0.4, textTransform: 'uppercase', marginBottom: 10 }}>{title}</div>
      <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>{children}</div>
    </div>
  );
}

function PayOption({ icon, label, sub, active, onClick }) {
  return (
    <button onClick={onClick} style={{
      background: 'var(--card)',
      border: '1px solid ' + (active ? 'var(--accent)' : 'var(--line)'),
      borderWidth: active ? 2 : 1,
      borderRadius: 16, padding: '14px 16px',
      display: 'flex', alignItems: 'center', gap: 14,
      textAlign: 'left',
    }}>
      <div style={{ width: 36, height: 36, borderRadius: 10, background: 'var(--cream)', color: 'var(--coffee)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>{Icon[icon]({ size: 18 })}</div>
      <div style={{ flex: 1 }}>
        <div style={{ fontSize: 14, fontWeight: 600, color: 'var(--coffee)' }}>{label}</div>
        <div style={{ fontSize: 11, color: 'var(--text-muted)' }}>{sub}</div>
      </div>
      <div style={{
        width: 22, height: 22, borderRadius: '50%',
        border: '2px solid ' + (active ? 'var(--accent)' : 'var(--line-strong)'),
        background: active ? 'var(--accent)' : 'transparent',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        color: '#FFFBF5',
      }}>{active && Icon.check({ size: 14 })}</div>
    </button>
  );
}

// ─── ORDER TRACKING ──────────────────────────────────────────
function TrackingScreen({ store, orderInfo, onDone, onNavigate }) {
  const [step, setStep] = useState2(0);
  const steps = [
    { label: 'Sipariş alındı', sub: 'Baristaya iletildi' },
    { label: 'Hazırlanıyor', sub: 'Espresso çekiliyor…' },
    { label: 'Hazır', sub: 'Tezgahtan alabilirsin' },
  ];

  useEffect2(() => {
    if (step < 2) {
      const t = setTimeout(() => setStep(step + 1), 3500);
      return () => clearTimeout(t);
    }
  }, [step]);

  return (
    <Screen label="06 Sipariş Takip" padTop={56} padBottom={130}>
      <div style={{ padding: '4px 16px 0', display: 'flex', alignItems: 'center', gap: 10 }}>
        <button onClick={onDone} style={iconBtnStyle()}>{Icon.close({ size: 18 })}</button>
      </div>

      {/* Hero */}
      <div style={{ padding: '14px 24px 20px', textAlign: 'center' }}>
        <div style={{
          margin: '0 auto 18px', width: 130, height: 130,
          borderRadius: '50%',
          background: 'radial-gradient(circle, var(--tag-bg) 0%, var(--bg) 70%)',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          position: 'relative',
        }}>
          {step < 2 ? (
            <>
              <div style={{
                position: 'absolute', inset: 0, borderRadius: '50%',
                border: '3px solid var(--accent)',
                borderTopColor: 'transparent',
                animation: 'kp-spin 1.4s linear infinite',
              }}/>
              <CoffeeTile kind="cup" size={70} fg="var(--coffee)" bg="transparent" />
            </>
          ) : (
            <div style={{
              width: 90, height: 90, borderRadius: '50%',
              background: 'var(--accent)', color: '#FFFBF5',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              fontSize: 40,
            }}>{Icon.check({ size: 50 })}</div>
          )}
        </div>
        <style>{`@keyframes kp-spin{to{transform:rotate(360deg)}}`}</style>

        <div style={{ fontFamily: 'var(--font-display)', fontSize: 30, color: 'var(--coffee)', letterSpacing: -0.02, lineHeight: 1.1 }}>
          {step === 0 && 'Sipariş alındı'}
          {step === 1 && 'Hazırlanıyor'}
          {step === 2 && 'Siparişin hazır.'}
        </div>
        <div style={{ fontSize: 13, color: 'var(--text-muted)', marginTop: 6 }}>
          {step < 2 ? `Tahmini hazırlık · ~${10 - step * 4} dk` : 'Tezgahtan alabilirsin'}
        </div>
      </div>

      {/* Progress steps */}
      <div style={{ padding: '0 32px 22px' }}>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 0, position: 'relative' }}>
          {steps.map((s, i) => (
            <div key={i} style={{ display: 'flex', alignItems: 'flex-start', gap: 14, paddingBottom: i < steps.length - 1 ? 22 : 0, position: 'relative' }}>
              {i < steps.length - 1 && (
                <div style={{
                  position: 'absolute', left: 13, top: 28, bottom: 0,
                  width: 2, background: i < step ? 'var(--accent)' : 'var(--line-strong)',
                }}/>
              )}
              <div style={{
                width: 28, height: 28, borderRadius: '50%',
                background: i <= step ? 'var(--accent)' : 'var(--card)',
                border: '2px solid ' + (i <= step ? 'var(--accent)' : 'var(--line-strong)'),
                color: '#FFFBF5',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                flexShrink: 0,
                zIndex: 1,
              }}>{i <= step ? Icon.check({ size: 14 }) : null}</div>
              <div style={{ paddingTop: 2 }}>
                <div style={{ fontSize: 14, fontWeight: 600, color: i <= step ? 'var(--coffee)' : 'var(--text-muted)' }}>{s.label}</div>
                <div style={{ fontSize: 12, color: 'var(--text-muted)', marginTop: 2 }}>{s.sub}</div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Store */}
      <div style={{ padding: '0 20px 12px' }}>
        <div style={{ background: 'var(--card)', border: '1px solid var(--line)', borderRadius: 18, padding: '14px 16px', display: 'flex', alignItems: 'center', gap: 12 }}>
          <div style={{ width: 40, height: 40, borderRadius: 10, background: 'var(--tag-bg)', color: 'var(--accent)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>{Icon.pin({ size: 18 })}</div>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 13, fontWeight: 600, color: 'var(--coffee)' }}>{store.name}</div>
            <div style={{ fontSize: 11, color: 'var(--text-muted)' }}>{store.address}</div>
          </div>
          <button style={{ fontSize: 12, color: 'var(--accent)', fontWeight: 600 }}>Yol tarifi</button>
        </div>
      </div>

      {/* Order summary */}
      <div style={{ padding: '0 20px' }}>
        <div style={{ background: 'var(--card)', border: '1px solid var(--line)', borderRadius: 18, padding: '14px 16px' }}>
          <div style={{ fontSize: 11, color: 'var(--text-muted)', letterSpacing: 0.3, textTransform: 'uppercase', marginBottom: 8 }}>Sipariş #{orderInfo.id}</div>
          {orderInfo.cart.map((it, i) => (
            <div key={i} style={{ display: 'flex', alignItems: 'center', gap: 10, padding: '6px 0', fontSize: 13 }}>
              <span style={{ fontFamily: 'var(--font-mono)', fontSize: 11, color: 'var(--text-muted)', width: 18 }}>×{it.qty}</span>
              <span style={{ flex: 1, color: 'var(--coffee)', fontWeight: 500 }}>{it.product.name}</span>
              <span style={{ fontFamily: 'var(--font-mono)', fontSize: 12, color: 'var(--text-muted)' }}>{fmtTL(it.total)}</span>
            </div>
          ))}
          <div style={{ borderTop: '1px solid var(--line)', marginTop: 10, paddingTop: 10, display: 'flex', justifyContent: 'space-between' }}>
            <span style={{ fontSize: 13, fontWeight: 600, color: 'var(--coffee)' }}>Toplam</span>
            <span style={{ fontFamily: 'var(--font-mono)', fontSize: 14, fontWeight: 600, color: 'var(--coffee)' }}>{fmtTL(orderInfo.total)}</span>
          </div>
          <div style={{ marginTop: 10, padding: '8px 12px', background: 'var(--tag-bg)', borderRadius: 10, fontSize: 11, color: 'var(--accent)', fontWeight: 600, textAlign: 'center' }}>
            🎉 +{Math.floor(orderInfo.total / 10)} sadakat puanı kazandın
          </div>
        </div>
      </div>

      {/* Bottom action */}
      <div style={{
        position: 'absolute', bottom: 0, left: 0, right: 0,
        background: 'var(--card)', borderTop: '1px solid var(--line)',
        padding: '14px 20px 32px',
      }}>
        <button onClick={onDone} className="kp-btn-primary" style={{ background: step === 2 ? 'var(--accent)' : 'var(--coffee)', color: 'var(--cream)' }}>
          {step === 2 ? 'Tamamlandı, ana ekrana dön' : 'Ana ekrana dön'}
        </button>
      </div>
    </Screen>
  );
}

Object.assign(window, { MenuScreen, ProductScreen, CartScreen, CheckoutScreen, TrackingScreen });
