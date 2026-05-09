// keopi screens — Home, Loyalty, Profile, Past Orders, Stores

const { useState, useEffect, useRef, useMemo } = React;

// ─── HOME ─────────────────────────────────────────────────────
function HomeScreen({ data, user, store, layout, onNavigate, onTab }) {
  const [campIdx, setCampIdx] = useState(0);
  const popular = data.products.filter(p => p.cat === 'popular');
  const newOnes = data.products.filter(p => p.tag === 'Yeni');

  return (
    <Screen label="01 Ana Ekran" padTop={56} padBottom={100}>
      {/* Top header — store + greeting */}
      <div style={{ padding: '8px 20px 18px', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <button onClick={() => onNavigate('stores')} style={{ display: 'flex', alignItems: 'center', gap: 6, textAlign: 'left' }}>
          {Icon.pin({ size: 16 })}
          <div>
            <div style={{ fontSize: 11, color: 'var(--text-muted)', fontWeight: 500, letterSpacing: 0.2 }}>SİPARİŞ ALAN</div>
            <div style={{ fontSize: 14, fontWeight: 600, display: 'flex', alignItems: 'center', gap: 4 }}>
              {store.name} {Icon.chevR({ size: 14 })}
            </div>
          </div>
        </button>
        <div style={{ display: 'flex', gap: 6 }}>
          <button style={iconBtnStyle()}>{Icon.qr({ size: 20 })}</button>
          <button style={iconBtnStyle()}>{Icon.bell({ size: 20 })}</button>
        </div>
      </div>

      {/* Greeting + name */}
      <div style={{ padding: '0 20px 16px' }}>
        <div style={{ fontSize: 13, color: 'var(--text-muted)' }}>Günaydın</div>
        <div style={{ fontFamily: 'var(--font-display)', fontSize: 38, lineHeight: 1, letterSpacing: -0.02, color: 'var(--coffee)' }}>
          {user.name}, ne içersin?
        </div>
      </div>

      {/* Loyalty mini-card */}
      <div style={{ padding: '0 20px 18px' }}>
        <button onClick={() => onTab('loyalty')} style={{
          width: '100%', textAlign: 'left',
          background: 'var(--coffee)', color: 'var(--cream)',
          borderRadius: 22, padding: '16px 18px',
          display: 'flex', alignItems: 'center', justifyContent: 'space-between',
          gap: 12,
        }}>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 11, opacity: 0.7, letterSpacing: 0.4, textTransform: 'uppercase' }}>Damga kartın</div>
            <div style={{ display: 'flex', gap: 6, marginTop: 8, alignItems: 'center' }}>
              {[0,1,2,3,4].map(i => (
                <div key={i} style={{
                  width: 26, height: 26, borderRadius: '50%',
                  border: '1.5px dashed rgba(245,239,230,0.4)',
                  background: i < user.stamps ? 'var(--accent)' : 'transparent',
                  borderStyle: i < user.stamps ? 'solid' : 'dashed',
                  borderColor: i < user.stamps ? 'var(--accent)' : 'rgba(245,239,230,0.4)',
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  color: '#FFFBF5',
                }}>
                  {i < user.stamps && Icon.cup({ size: 14 })}
                </div>
              ))}
            </div>
            <div style={{ fontSize: 12, marginTop: 8, opacity: 0.85 }}>
              {5 - user.stamps} kahve daha → bedava bir kahve
            </div>
          </div>
          {Icon.chevR({ size: 18 })}
        </button>
      </div>

      {/* Campaign carousel */}
      <div style={{ marginBottom: 20 }}>
        <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', padding: '0 20px 10px', gap: 12 }}>
          <div style={{ fontSize: 18, fontWeight: 600, fontFamily: 'var(--font-display)', letterSpacing: -0.01, whiteSpace: 'nowrap', flex: 1, minWidth: 0 }}>Sana özel</div>
          <button style={{ fontSize: 13, color: 'var(--text-muted)', whiteSpace: 'nowrap' }}>Tümü</button>
        </div>
        <div style={{ display: 'flex', overflowX: 'auto', gap: 12, padding: '0 20px 6px', scrollbarWidth: 'none' }} className="kp-scroll">
          {data.campaigns.map((c, i) => (
            <CampaignCard key={c.id} c={c} active={i === campIdx} onClick={() => setCampIdx(i)} />
          ))}
        </div>
      </div>

      {/* Quick actions row */}
      <div style={{ padding: '0 20px 22px', display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 10 }}>
        <QuickAction icon="cart" label="Önceki siparişi tekrar et" onClick={() => onNavigate('past')} />
        <QuickAction icon="truck" label="Pickup için sırala" onClick={() => onTab('menu')} />
        <QuickAction icon="gift" label="Hediye gönder" onClick={() => onNavigate('gift')} />
      </div>

      {/* Categories — depending on layout */}
      {layout === 'grid' ? <CategoryGrid data={data} onTab={onTab} /> : <CategoryStrip data={data} onTab={onTab} />}

      {/* En popüler */}
      <div style={{ marginTop: 24 }}>
        <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', padding: '0 20px 10px', gap: 12 }}>
          <div style={{ fontSize: 18, fontWeight: 600, fontFamily: 'var(--font-display)', letterSpacing: -0.01, whiteSpace: 'nowrap', flex: 1, minWidth: 0 }}>En popüler</div>
          <button style={{ fontSize: 13, color: 'var(--text-muted)', whiteSpace: 'nowrap' }} onClick={() => onTab('menu')}>Tümü</button>
        </div>
        <div style={{ display: 'flex', overflowX: 'auto', gap: 12, padding: '0 20px 6px', scrollbarWidth: 'none' }} className="kp-scroll">
          {popular.map(p => <ProductCardLg key={p.id} p={p} onClick={() => onNavigate('product:' + p.id)} />)}
        </div>
      </div>

      {/* Yeni ürünler */}
      <div style={{ marginTop: 24 }}>
        <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', padding: '0 20px 10px', gap: 12 }}>
          <div style={{ fontSize: 18, fontWeight: 600, fontFamily: 'var(--font-display)', letterSpacing: -0.01, whiteSpace: 'nowrap', flex: 1, minWidth: 0 }}>Yeni keşfet</div>
          <span className="kp-tag">YENİ</span>
        </div>
        <div style={{ padding: '0 20px', display: 'flex', flexDirection: 'column', gap: 10 }}>
          {newOnes.map(p => <ProductRow key={p.id} p={p} onClick={() => onNavigate('product:' + p.id)} />)}
        </div>
      </div>

      <div style={{ height: 24 }} />

      {/* Bottom tagline */}
      <div style={{ padding: '12px 20px 20px', textAlign: 'center', fontFamily: 'var(--font-display)', fontStyle: 'italic', color: 'var(--text-muted)', fontSize: 15 }}>
        “Bir fincan keopi, mahallenin sıcaklığı.”
      </div>
    </Screen>
  );
}

function iconBtnStyle() {
  return {
    width: 38, height: 38, borderRadius: '50%',
    background: 'var(--card)', border: '1px solid var(--line)',
    display: 'flex', alignItems: 'center', justifyContent: 'center',
    color: 'var(--coffee)',
  };
}

function CampaignCard({ c, active, onClick }) {
  return (
    <button onClick={onClick} style={{
      flex: '0 0 280px', height: 160, borderRadius: 24,
      background: c.bg, color: c.fg,
      padding: 18, textAlign: 'left',
      display: 'flex', flexDirection: 'column', justifyContent: 'space-between',
      position: 'relative', overflow: 'hidden',
    }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
        <span style={{
          fontSize: 10, padding: '4px 9px', borderRadius: 999,
          background: 'rgba(255,255,255,0.18)', backdropFilter: 'blur(6px)',
          fontWeight: 600, letterSpacing: 0.4, textTransform: 'uppercase',
        }}>{c.tag}</span>
      </div>
      <div>
        <div style={{ fontFamily: 'var(--font-display)', fontSize: 26, lineHeight: 1.1, whiteSpace: 'pre-line', letterSpacing: -0.01 }}>
          {c.title}
        </div>
        <div style={{ fontSize: 11.5, opacity: 0.85, marginTop: 6, lineHeight: 1.35 }}>{c.subtitle}</div>
      </div>
      {/* decorative shape */}
      <div style={{ position: 'absolute', right: -20, top: -20, width: 140, height: 140, borderRadius: '50%', background: 'rgba(255,255,255,0.08)' }}/>
      <div style={{ position: 'absolute', right: 14, top: 30, opacity: 0.55 }}>
        {c.illu === 'cup' && <CoffeeTile kind="iced" size={70} fg={c.fg} bg="transparent" />}
        {c.illu === 'gift' && <CoffeeTile kind="gift" size={70} fg={c.fg} bg="transparent" />}
        {c.illu === 'cake' && <CoffeeTile kind="cake" size={70} fg={c.fg} bg="transparent" />}
      </div>
    </button>
  );
}

function QuickAction({ icon, label, onClick }) {
  return (
    <button onClick={onClick} style={{
      background: 'var(--card)', border: '1px solid var(--line)',
      borderRadius: 18, padding: '14px 10px',
      display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 8,
      color: 'var(--coffee)',
      minHeight: 90,
    }}>
      <div style={{
        width: 36, height: 36, borderRadius: '50%',
        background: 'var(--tag-bg)', color: 'var(--accent)',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
      }}>{Icon[icon]({ size: 18 })}</div>
      <div style={{ fontSize: 11, lineHeight: 1.3, textAlign: 'center', textWrap: 'pretty', fontWeight: 500 }}>{label}</div>
    </button>
  );
}

function CategoryStrip({ data, onTab }) {
  return (
    <div>
      <div style={{ padding: '0 20px 10px', fontSize: 18, fontWeight: 600, fontFamily: 'var(--font-display)', letterSpacing: -0.01 }}>
        Kategoriler
      </div>
      <div style={{ display: 'flex', overflowX: 'auto', gap: 10, padding: '0 20px', scrollbarWidth: 'none' }} className="kp-scroll">
        {data.categories.map(cat => (
          <button key={cat.id} onClick={() => onTab('menu', cat.id)} style={{
            flex: '0 0 auto', minWidth: 88,
            background: 'var(--card)', border: '1px solid var(--line)',
            borderRadius: 18, padding: '14px 10px',
            display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 8,
          }}>
            <div style={{ fontSize: 26 }}>{cat.emoji}</div>
            <div style={{ fontSize: 12, fontWeight: 600, color: 'var(--coffee)' }}>{cat.name}</div>
          </button>
        ))}
      </div>
    </div>
  );
}

function CategoryGrid({ data, onTab }) {
  return (
    <div style={{ padding: '0 20px' }}>
      <div style={{ paddingBottom: 12, fontSize: 18, fontWeight: 600, fontFamily: 'var(--font-display)', letterSpacing: -0.01 }}>
        Kategoriler
      </div>
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 10 }}>
        {data.categories.map(cat => (
          <button key={cat.id} onClick={() => onTab('menu', cat.id)} style={{
            background: 'var(--card)', border: '1px solid var(--line)',
            borderRadius: 18, padding: '14px 8px',
            display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 6,
            minHeight: 86,
          }}>
            <div style={{ fontSize: 24 }}>{cat.emoji}</div>
            <div style={{ fontSize: 11, fontWeight: 600, color: 'var(--coffee)', textAlign: 'center' }}>{cat.name}</div>
          </button>
        ))}
      </div>
    </div>
  );
}

function ProductCardLg({ p, onClick }) {
  return (
    <button onClick={onClick} style={{
      flex: '0 0 160px',
      background: 'var(--card)', border: '1px solid var(--line)',
      borderRadius: 22, overflow: 'hidden', textAlign: 'left',
      display: 'flex', flexDirection: 'column',
    }}>
      <div style={{ padding: 12, paddingBottom: 4 }}>
        <CoffeeTile kind={illuFor(p)} size={132} fg="var(--coffee)" bg="var(--cream)" />
      </div>
      <div style={{ padding: '6px 12px 14px' }}>
        {p.tag && <div style={{ marginBottom: 6 }}><span className="kp-tag">{p.tag}</span></div>}
        <div style={{ fontSize: 14, fontWeight: 600, color: 'var(--coffee)', lineHeight: 1.2 }}>{p.name}</div>
        <div style={{ fontFamily: 'var(--font-mono)', fontSize: 13, color: 'var(--accent)', marginTop: 4 }}>{fmtTL(p.price)}</div>
      </div>
    </button>
  );
}

function ProductRow({ p, onClick }) {
  return (
    <button onClick={onClick} style={{
      display: 'flex', alignItems: 'center', gap: 14,
      background: 'var(--card)', border: '1px solid var(--line)',
      borderRadius: 18, padding: 12, textAlign: 'left',
    }}>
      <CoffeeTile kind={illuFor(p)} size={64} fg="var(--coffee)" bg="var(--cream)" />
      <div style={{ flex: 1, minWidth: 0 }}>
        {p.tag && <div style={{ marginBottom: 4 }}><span className="kp-tag">{p.tag}</span></div>}
        <div style={{ fontSize: 15, fontWeight: 600, color: 'var(--coffee)' }}>{p.name}</div>
        <div style={{ fontSize: 12, color: 'var(--text-muted)', marginTop: 2, lineHeight: 1.35,
          display: '-webkit-box', WebkitLineClamp: 2, WebkitBoxOrient: 'vertical', overflow: 'hidden' }}>{p.desc}</div>
      </div>
      <div style={{ textAlign: 'right' }}>
        <div style={{ fontFamily: 'var(--font-mono)', fontSize: 14, color: 'var(--accent)', fontWeight: 600 }}>{fmtTL(p.price)}</div>
        <div style={{
          marginTop: 6, width: 30, height: 30, borderRadius: '50%',
          background: 'var(--accent)', color: '#FFFBF5',
          display: 'flex', alignItems: 'center', justifyContent: 'center', marginLeft: 'auto',
        }}>{Icon.plus({ size: 18 })}</div>
      </div>
    </button>
  );
}

// ─── LOYALTY ──────────────────────────────────────────────────
function LoyaltyScreen({ data, user, onNavigate }) {
  return (
    <Screen label="08 Sadakat" padTop={56} padBottom={100}>
      <div style={{ padding: '8px 20px 14px', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <div style={{ fontFamily: 'var(--font-display)', fontSize: 32, color: 'var(--coffee)', letterSpacing: -0.02 }}>Sadakat</div>
        <button style={iconBtnStyle()}>{Icon.share({ size: 18 })}</button>
      </div>

      {/* Stamp card hero */}
      <div style={{ padding: '0 20px 18px' }}>
        <div style={{
          background: 'var(--coffee)', color: 'var(--cream)',
          borderRadius: 28, padding: '22px 22px 24px',
          position: 'relative', overflow: 'hidden',
        }}>
          {/* Bg pattern */}
          <div style={{ position: 'absolute', inset: 0, opacity: 0.06,
            backgroundImage: 'radial-gradient(circle at 20% 30%, var(--cream) 1px, transparent 1.5px), radial-gradient(circle at 70% 80%, var(--cream) 1px, transparent 1.5px)',
            backgroundSize: '24px 24px',
          }}/>
          <div style={{ position: 'relative' }}>
            <div style={{ fontSize: 11, opacity: 0.7, letterSpacing: 0.4, textTransform: 'uppercase' }}>Damga kartı</div>
            <div style={{ fontFamily: 'var(--font-display)', fontSize: 28, marginTop: 4, letterSpacing: -0.01 }}>
              5 al, 1 bedava.
            </div>
            <div style={{ fontSize: 13, opacity: 0.8, marginTop: 4 }}>Her kahvende bir damga.</div>

            {/* Stamps */}
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(5, 1fr)', gap: 10, marginTop: 18 }}>
              {[0,1,2,3,4].map(i => (
                <div key={i} style={{
                  aspectRatio: '1/1', borderRadius: '50%',
                  border: '1.5px dashed rgba(245,239,230,0.5)',
                  background: i < user.stamps ? 'var(--accent)' : 'transparent',
                  borderStyle: i < user.stamps ? 'solid' : 'dashed',
                  borderColor: i < user.stamps ? 'var(--accent)' : 'rgba(245,239,230,0.5)',
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  color: '#FFFBF5', position: 'relative',
                }}>
                  {i < user.stamps ? Icon.cup({ size: 22 }) : (
                    i === 4 ? <span style={{ fontFamily: 'var(--font-display)', fontSize: 20, color: 'rgba(245,239,230,0.5)' }}>★</span> : null
                  )}
                </div>
              ))}
            </div>
            <div style={{ marginTop: 16, display: 'flex', justifyContent: 'space-between', alignItems: 'center', fontSize: 12, opacity: 0.85 }}>
              <span>{user.stamps}/5 damga</span>
              <span>{5 - user.stamps} kahve sonra hediye →</span>
            </div>
          </div>
        </div>
      </div>

      {/* Points balance */}
      <div style={{ padding: '0 20px 18px' }}>
        <div style={{
          background: 'var(--card)', borderRadius: 22, padding: '18px 20px',
          border: '1px solid var(--line)',
          display: 'flex', alignItems: 'center', justifyContent: 'space-between',
        }}>
          <div>
            <div style={{ fontSize: 11, color: 'var(--text-muted)', letterSpacing: 0.3, textTransform: 'uppercase' }}>Puan bakiyen</div>
            <div style={{ fontFamily: 'var(--font-display)', fontSize: 36, lineHeight: 1, color: 'var(--coffee)', marginTop: 4 }}>
              {user.points} <span style={{ fontSize: 14, color: 'var(--text-muted)' }}>puan</span>
            </div>
          </div>
          <div style={{
            width: 56, height: 56, borderRadius: '50%',
            background: 'var(--accent)', color: '#FFFBF5',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
          }}>{Icon.star({ size: 28, fill: 'currentColor' })}</div>
        </div>
        <div style={{ marginTop: 10, padding: '10px 14px', background: 'var(--tag-bg)', borderRadius: 12, fontSize: 12, color: 'var(--accent)' }}>
          🎂 Doğum günün <strong>{user.birthday}</strong> — sana özel bir hediye yolda.
        </div>
      </div>

      {/* Tier progress */}
      <div style={{ padding: '0 20px 18px' }}>
        <div style={{ background: 'var(--card)', borderRadius: 22, padding: '16px 20px', border: '1px solid var(--line)' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 10 }}>
            <div style={{ fontSize: 14, fontWeight: 600, color: 'var(--coffee)' }}>{user.tier} seviyesi</div>
            <div style={{ fontSize: 12, color: 'var(--text-muted)' }}>→ {user.nextTier}</div>
          </div>
          <div style={{ height: 8, background: 'var(--cream)', borderRadius: 999, overflow: 'hidden' }}>
            <div style={{ width: '64%', height: '100%', background: 'var(--accent)', borderRadius: 999 }}/>
          </div>
          <div style={{ marginTop: 8, fontSize: 11, color: 'var(--text-muted)' }}>180 puan daha → {user.nextTier} olursun · ücretsiz süt değişimi açılır</div>
        </div>
      </div>

      {/* Rewards catalogue */}
      <div style={{ padding: '0 20px 14px' }}>
        <div style={{ fontSize: 18, fontWeight: 600, fontFamily: 'var(--font-display)', marginBottom: 10 }}>Puanını harca</div>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
          {data.rewards.map(r => (
            <div key={r.id} style={{
              background: 'var(--card)', border: '1px solid var(--line)',
              borderRadius: 18, padding: '14px 16px',
              display: 'flex', alignItems: 'center', gap: 14,
              opacity: r.available ? 1 : 0.55,
            }}>
              <div style={{
                width: 44, height: 44, borderRadius: '50%',
                background: 'var(--tag-bg)', color: 'var(--accent)',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
              }}>{Icon.gift({ size: 20 })}</div>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 14, fontWeight: 600, color: 'var(--coffee)' }}>{r.name}</div>
                <div style={{ fontFamily: 'var(--font-mono)', fontSize: 12, color: 'var(--text-muted)', marginTop: 2 }}>{r.points} puan</div>
              </div>
              <button disabled={!r.available} style={{
                padding: '8px 14px', borderRadius: 999,
                background: r.available ? 'var(--coffee)' : 'var(--cream)',
                color: r.available ? 'var(--cream)' : 'var(--text-muted)',
                fontSize: 12, fontWeight: 600,
              }}>{r.available ? 'Kullan' : 'Kilitli'}</button>
            </div>
          ))}
        </div>
      </div>

      <div style={{ padding: '8px 20px 0' }}>
        <button onClick={() => onNavigate('referral')} style={{
          width: '100%', textAlign: 'left',
          background: 'var(--accent)', color: '#FFFBF5',
          borderRadius: 22, padding: '16px 20px',
          display: 'flex', alignItems: 'center', justifyContent: 'space-between',
        }}>
          <div>
            <div style={{ fontSize: 12, opacity: 0.85, letterSpacing: 0.3, textTransform: 'uppercase' }}>Arkadaşa öner</div>
            <div style={{ fontFamily: 'var(--font-display)', fontSize: 20, marginTop: 2 }}>Sen 50 puan, o 1 filtre kahve</div>
          </div>
          {Icon.chevR({ size: 20 })}
        </button>
      </div>
    </Screen>
  );
}

// ─── PROFILE ──────────────────────────────────────────────────
function ProfileScreen({ user, onNavigate, onTab }) {
  const items = [
    { icon: 'clock', label: 'Geçmiş siparişler', sub: '14 sipariş', go: 'past' },
    { icon: 'pin', label: 'Kayıtlı mağazalar', sub: 'Bağdat Cd.', go: 'stores' },
    { icon: 'card', label: 'Ödeme yöntemleri', sub: 'Visa **24', go: null },
    { icon: 'gift', label: 'Hediye gönder', sub: 'Arkadaşına bir kahve ısmarla', go: 'gift' },
    { icon: 'qr', label: 'Üyelik kartım', sub: 'QR kodu mağazada göster', go: null },
    { icon: 'bell', label: 'Bildirimler', sub: 'Açık', go: null },
  ];

  return (
    <Screen label="09 Profil" padTop={56} padBottom={100}>
      <div style={{ padding: '8px 20px 18px' }}>
        <div style={{ fontFamily: 'var(--font-display)', fontSize: 32, color: 'var(--coffee)', letterSpacing: -0.02 }}>Profil</div>
      </div>

      {/* User card */}
      <div style={{ padding: '0 20px 18px' }}>
        <div style={{
          background: 'var(--card)', border: '1px solid var(--line)',
          borderRadius: 24, padding: '18px 20px',
          display: 'flex', alignItems: 'center', gap: 14,
        }}>
          <div style={{
            width: 56, height: 56, borderRadius: '50%',
            background: 'var(--coffee)', color: 'var(--cream)',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            fontFamily: 'var(--font-display)', fontSize: 24,
          }}>{user.name[0]}</div>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 17, fontWeight: 600, color: 'var(--coffee)' }}>{user.name} Y.</div>
            <div style={{ fontSize: 12, color: 'var(--text-muted)', marginTop: 2 }}>
              {user.tier} · Üye {user.memberSince}
            </div>
          </div>
          <button onClick={() => onTab('loyalty')} style={{
            padding: '8px 14px', borderRadius: 999,
            background: 'var(--tag-bg)', color: 'var(--accent)',
            fontSize: 12, fontWeight: 700,
            display: 'flex', alignItems: 'center', gap: 6,
          }}>{Icon.star({ size: 14, fill: 'currentColor' })}{user.points}</button>
        </div>
      </div>

      {/* Menu list */}
      <div style={{ padding: '0 20px' }}>
        <div style={{ background: 'var(--card)', border: '1px solid var(--line)', borderRadius: 22, overflow: 'hidden' }}>
          {items.map((it, i) => (
            <button key={it.label} onClick={() => it.go && onNavigate(it.go)} style={{
              width: '100%', display: 'flex', alignItems: 'center', gap: 14,
              padding: '14px 16px', textAlign: 'left',
              borderBottom: i < items.length - 1 ? '1px solid var(--line)' : 'none',
              color: 'var(--coffee)',
            }}>
              <div style={{
                width: 36, height: 36, borderRadius: '50%',
                background: 'var(--tag-bg)', color: 'var(--accent)',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
              }}>{Icon[it.icon]({ size: 18 })}</div>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 14, fontWeight: 600 }}>{it.label}</div>
                <div style={{ fontSize: 12, color: 'var(--text-muted)', marginTop: 1 }}>{it.sub}</div>
              </div>
              {Icon.chevR({ size: 18 })}
            </button>
          ))}
        </div>
      </div>

      <div style={{ padding: '24px 20px', textAlign: 'center', fontSize: 11, color: 'var(--text-muted)', letterSpacing: 0.4, textTransform: 'uppercase' }}>
        keopi v2.4.1 · Çıkış yap
      </div>
    </Screen>
  );
}

// ─── PAST ORDERS ──────────────────────────────────────────────
function PastOrdersScreen({ data, onBack, onReorder }) {
  return (
    <Screen label="07 Geçmiş Siparişler" padTop={56} padBottom={40}>
      <div style={{ padding: '4px 16px 14px', display: 'flex', alignItems: 'center', gap: 10 }}>
        <button onClick={onBack} style={iconBtnStyle()}>{Icon.chevL({ size: 18 })}</button>
        <div style={{ fontFamily: 'var(--font-display)', fontSize: 28, color: 'var(--coffee)', letterSpacing: -0.02 }}>Geçmiş siparişler</div>
      </div>

      <div style={{ padding: '0 20px', display: 'flex', flexDirection: 'column', gap: 12 }}>
        {data.pastOrders.map(o => (
          <div key={o.id} style={{ background: 'var(--card)', border: '1px solid var(--line)', borderRadius: 22, padding: '16px 18px' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 10 }}>
              <div>
                <div style={{ fontSize: 11, color: 'var(--text-muted)', letterSpacing: 0.3, textTransform: 'uppercase' }}>{o.id}</div>
                <div style={{ fontSize: 13, fontWeight: 600, color: 'var(--coffee)', marginTop: 1 }}>{o.date}</div>
              </div>
              <div style={{ textAlign: 'right' }}>
                <div style={{ fontFamily: 'var(--font-mono)', fontSize: 16, color: 'var(--coffee)', fontWeight: 600 }}>{fmtTL(o.total)}</div>
                <div style={{ fontSize: 11, color: 'var(--text-muted)', display: 'flex', alignItems: 'center', gap: 3, justifyContent: 'flex-end' }}>
                  {Icon.pin({ size: 11 })} {o.store}
                </div>
              </div>
            </div>

            <div style={{ borderTop: '1px solid var(--line)', paddingTop: 10, display: 'flex', flexDirection: 'column', gap: 6 }}>
              {o.items.map((it, i) => (
                <div key={i} style={{ display: 'flex', alignItems: 'center', gap: 10, fontSize: 13 }}>
                  <span style={{ fontFamily: 'var(--font-mono)', fontSize: 11, color: 'var(--text-muted)', width: 18 }}>×{it.qty}</span>
                  <span style={{ flex: 1, color: 'var(--coffee)', fontWeight: 500 }}>{it.name}</span>
                  {it.mods && <span style={{ fontSize: 11, color: 'var(--text-muted)' }}>{it.mods}</span>}
                </div>
              ))}
            </div>

            <div style={{ marginTop: 12, display: 'flex', gap: 8 }}>
              <button onClick={() => onReorder(o)} style={{
                flex: 1, padding: '10px', borderRadius: 999,
                background: 'var(--coffee)', color: 'var(--cream)',
                fontSize: 13, fontWeight: 600,
              }}>Tekrar sipariş ver</button>
              <button style={{
                padding: '10px 14px', borderRadius: 999,
                background: 'var(--cream)', color: 'var(--coffee)',
                fontSize: 13, fontWeight: 600, border: '1px solid var(--line)',
              }}>Fişi gör</button>
            </div>
          </div>
        ))}
      </div>
    </Screen>
  );
}

// ─── STORE PICKER ─────────────────────────────────────────────
function StoresScreen({ data, current, onPick, onBack }) {
  return (
    <Screen label="10 Mağaza Seç" padTop={56} padBottom={40}>
      <div style={{ padding: '4px 16px 14px', display: 'flex', alignItems: 'center', gap: 10 }}>
        <button onClick={onBack} style={iconBtnStyle()}>{Icon.chevL({ size: 18 })}</button>
        <div style={{ fontFamily: 'var(--font-display)', fontSize: 28, color: 'var(--coffee)', letterSpacing: -0.02 }}>Mağaza seç</div>
      </div>

      {/* Search bar */}
      <div style={{ padding: '0 20px 14px' }}>
        <div style={{
          background: 'var(--card)', border: '1px solid var(--line)',
          borderRadius: 14, padding: '12px 14px',
          display: 'flex', alignItems: 'center', gap: 10,
        }}>
          {Icon.search({ size: 18 })}
          <span style={{ fontSize: 14, color: 'var(--text-muted)' }}>Mağaza veya semt ara</span>
        </div>
      </div>

      {/* Map placeholder */}
      <div style={{ padding: '0 20px 14px' }}>
        <div style={{
          height: 140, borderRadius: 18,
          background: 'linear-gradient(135deg, var(--cream) 0%, var(--card) 100%)',
          border: '1px solid var(--line)',
          backgroundImage: `
            linear-gradient(135deg, var(--cream) 0%, var(--card) 100%),
            repeating-linear-gradient(45deg, transparent, transparent 8px, var(--line) 8px, var(--line) 9px)
          `,
          backgroundBlendMode: 'multiply',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          position: 'relative',
        }}>
          <div style={{ width: 36, height: 36, borderRadius: '50%', background: 'var(--accent)', color: '#FFFBF5', display: 'flex', alignItems: 'center', justifyContent: 'center', boxShadow: '0 6px 24px rgba(198,107,61,0.4)' }}>
            {Icon.pin({ size: 18 })}
          </div>
          <div style={{ position: 'absolute', top: 30, left: '30%', width: 8, height: 8, borderRadius: '50%', background: 'var(--coffee)' }}/>
          <div style={{ position: 'absolute', bottom: 22, right: '24%', width: 8, height: 8, borderRadius: '50%', background: 'var(--coffee)' }}/>
          <div style={{ position: 'absolute', top: 60, right: '14%', width: 8, height: 8, borderRadius: '50%', background: 'var(--coffee)' }}/>
        </div>
      </div>

      <div style={{ padding: '0 20px 8px', fontSize: 12, color: 'var(--text-muted)', letterSpacing: 0.3, textTransform: 'uppercase' }}>
        Yakındaki Mağazalar · {data.stores.length}
      </div>

      <div style={{ padding: '0 20px', display: 'flex', flexDirection: 'column', gap: 10 }}>
        {data.stores.map(s => (
          <button key={s.id} onClick={() => onPick(s)} style={{
            background: 'var(--card)', border: current?.id === s.id ? '2px solid var(--accent)' : '1px solid var(--line)',
            borderRadius: 18, padding: '14px 16px',
            textAlign: 'left',
            display: 'flex', alignItems: 'center', gap: 12,
          }}>
            <div style={{
              width: 44, height: 44, borderRadius: 12,
              background: 'var(--tag-bg)', color: 'var(--accent)',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
            }}>{Icon.pin({ size: 20 })}</div>
            <div style={{ flex: 1 }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
                <span style={{ fontSize: 15, fontWeight: 600, color: 'var(--coffee)' }}>{s.name}</span>
                {s.favorite && Icon.heart({ size: 14, fill: 'var(--accent)' })}
                {s.tag && <span className="kp-tag" style={{ fontSize: 9 }}>{s.tag}</span>}
              </div>
              <div style={{ fontSize: 12, color: 'var(--text-muted)', marginTop: 2 }}>{s.address}</div>
              <div style={{ fontSize: 11, color: s.open ? 'var(--success)' : '#B85A2D', marginTop: 4, fontWeight: 600 }}>
                {s.open ? '● Açık' : '● Kapalı'} <span style={{ color: 'var(--text-muted)', fontWeight: 400 }}> · {s.hours}</span>
              </div>
            </div>
            <div style={{ fontFamily: 'var(--font-mono)', fontSize: 12, color: 'var(--text-muted)' }}>{s.distance}</div>
          </button>
        ))}
      </div>
    </Screen>
  );
}

Object.assign(window, { HomeScreen, LoyaltyScreen, ProfileScreen, PastOrdersScreen, StoresScreen });
