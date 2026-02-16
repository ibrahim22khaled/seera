import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../core/services/validator.dart';
import '../../../../core/utils/auth_error_handler.dart';
import 'package:seera/core/theme/app_theme.dart';
import 'package:seera/generated/l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final l10n = AppLocalizations.of(context)!;
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      Fluttertoast.showToast(msg: l10n.pleaseFillAllFields);
      return;
    }

    setState(() => _isLoading = true);
    try {
      if (!_formKey.currentState!.validate()) {
        setState(() => _isLoading = false);
        return;
      }
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        Fluttertoast.showToast(msg: l10n.verifyEmailFirst);
        if (mounted) Navigator.pushReplacementNamed(context, '/verify-email');
        return;
      }
      Fluttertoast.showToast(
        msg: l10n.loginSuccessful,
        backgroundColor: Colors.green,
      );
      if (mounted) Navigator.pushReplacementNamed(context, '/chat');
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: AuthErrorHandler.getMessage(e, l10n));
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _googleSignIn() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      if (googleAuth != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        Fluttertoast.showToast(
          msg: l10n.loginSuccessful,
          backgroundColor: Colors.green,
        );
        if (mounted) Navigator.pushReplacementNamed(context, '/chat');
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: AuthErrorHandler.getMessage(e, l10n));
    } catch (e) {
      Fluttertoast.showToast(msg: l10n.googleSignInFailed(e.toString()));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    l10n.appTitle,
                    style: const TextStyle(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryBlue.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  l10n.welcomeBack,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headlineMedium?.color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.loginSubtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 48),
                _buildTextField(
                  l10n.email,
                  'name@example.com',
                  controller: _emailController,
                  validator: (val) {
                    if (val == null || val.isEmpty) return l10n.required;
                    if (!Validator.isValidEmail(val)) {
                      return l10n.invalidEmail;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  l10n.password,
                  l10n.enterPassword,
                  isPassword: true,
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  toggleVisibility: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  validator: (val) {
                    if (val == null || val.isEmpty) return l10n.required;
                    if (val.length < 6) return l10n.passwordTooShort;
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/forgot-password'),
                    child: Text(
                      l10n.forgotPassword,
                      style: const TextStyle(color: AppTheme.primaryBlue),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _login,
                        child: Text(l10n.login),
                      ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    const Expanded(child: Divider(color: Color(0xFF1E293B))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        l10n.orContinueWith,
                        style: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: Color(0xFF1E293B))),
                  ],
                ),
                const SizedBox(height: 32),
                if (Theme.of(context).platform == TargetPlatform.android)
                  _buildSocialButton(
                    l10n.google,
                    Icons.g_mobiledata,
                    Colors.white,
                    Colors.black,
                    onPressed: _googleSignIn,
                  ),
                if (Theme.of(context).platform == TargetPlatform.iOS)
                  _buildSocialButton(
                    l10n.apple,
                    Icons.apple,
                    const Color(0xFF1E293B),
                    Colors.white,
                    onPressed: () {}, // Implement Apple Sign-in if needed
                  ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.dontHaveAccount,
                      style: const TextStyle(color: AppTheme.textMuted),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/register'),
                      child: Text(
                        l10n.signUp,
                        style: const TextStyle(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint, {
    bool isPassword = false,
    TextEditingController? controller,
    bool obscureText = false,
    VoidCallback? toggleVisibility,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // In _buildTextField
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          // ...
          validator:
              validator ??
              (value) {
                final l10n = AppLocalizations.of(context)!;
                if (value == null || value.isEmpty) return l10n.required;
                return null;
              },
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: isPassword && toggleVisibility != null
                ? IconButton(
                    icon: Icon(
                      obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppTheme.textMuted,
                    ),
                    onPressed: toggleVisibility,
                  )
                : null,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1E293B)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(
    String label,
    IconData icon,
    Color bg,
    Color textCol, {
    VoidCallback? onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: textCol,
          elevation: 0,
          side: const BorderSide(color: Color(0xFF1E293B)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(color: textCol, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
