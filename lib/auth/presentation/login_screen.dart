import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import 'auth_widgets.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;
  bool _obscure = true;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() => _error = _authError(e.code));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _forgotPassword() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) {
      setState(() => _error = 'Önce e-posta adresinizi girin.');
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Şifre sıfırlama bağlantısı gönderildi.')),
      );
    } on FirebaseAuthException catch (e) {
      setState(() => _error = _authError(e.code));
    }
  }

  String _authError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Bu e-posta ile kayıtlı hesap bulunamadı.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'E-posta veya şifre hatalı.';
      case 'invalid-email':
        return 'Geçersiz e-posta adresi.';
      case 'too-many-requests':
        return 'Çok fazla deneme. Lütfen biraz bekleyin.';
      case 'user-disabled':
        return 'Bu hesap devre dışı bırakılmış.';
      default:
        return 'Bir hata oluştu. Lütfen tekrar deneyin.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),

                // ── Branding ─────────────────────────────────────────────────
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.coffee,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Icon(Icons.local_cafe, size: 36, color: AppColors.cream),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'keopi',
                    style: GoogleFonts.instrumentSerif(
                      fontSize: 42,
                      color: AppColors.coffee,
                      height: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Center(
                  child: Text(
                    'kahvenizle buluşun',
                    style: TextStyle(fontSize: 14, color: AppColors.muted),
                  ),
                ),
                const SizedBox(height: 52),

                // ── Email ─────────────────────────────────────────────────────
                AuthField(
                  controller: _emailCtrl,
                  hint: 'E-posta',
                  icon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'E-posta gerekli';
                    if (!v.contains('@')) return 'Geçersiz e-posta';
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // ── Şifre ─────────────────────────────────────────────────────
                AuthField(
                  controller: _passCtrl,
                  hint: 'Şifre',
                  icon: Icons.lock_outline_rounded,
                  obscure: _obscure,
                  suffix: GestureDetector(
                    onTap: () => setState(() => _obscure = !_obscure),
                    child: Icon(
                      _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      size: 20,
                      color: AppColors.muted,
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Şifre gerekli';
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // ── Şifremi unuttum ───────────────────────────────────────────
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: _forgotPassword,
                    child: const Text(
                      'Şifremi unuttum',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.accent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // ── Hata mesajı ───────────────────────────────────────────────
                if (_error != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0x1FB85A2D),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _error!,
                      style: const TextStyle(fontSize: 13, color: Color(0xFFB85A2D)),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // ── Giriş Yap butonu ──────────────────────────────────────────
                GestureDetector(
                  onTap: _loading ? null : _signIn,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    height: 54,
                    decoration: BoxDecoration(
                      color: _loading
                          ? AppColors.accent.withValues(alpha: 0.6)
                          : AppColors.accent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: _loading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Giriş Yap',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 32),

                // ── Kayıt ol linki ────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Hesabın yok mu? ',
                      style: TextStyle(fontSize: 14, color: AppColors.muted),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const RegisterScreen()),
                      ),
                      child: const Text(
                        'Kayıt ol',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
