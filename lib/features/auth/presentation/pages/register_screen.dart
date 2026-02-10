import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seera/core/theme/app_theme.dart';
import 'package:seera/generated/l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../core/services/validator.dart';
import '../../../../core/utils/auth_error_handler.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  // String _selectedLanguage = 'English';
  // String _selectedDialect = 'Slang English';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      Fluttertoast.showToast(msg: l10n.passwordsDoNotMatch);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      if (credential.user != null) {
        await credential.user!.updateDisplayName(_nameController.text.trim());

        // Send email verification
        await credential.user!.sendEmailVerification();
        Fluttertoast.showToast(msg: 'تم إرسال رابط تأكيد للبريد الإلكتروني.');

        // // Save selected dialect/locale
        // final prefs = await SharedPreferences.getInstance();
        // String locale = 'ar-EG';
        // if (_selectedDialect == 'Saudi Arabic') locale = 'ar-SA';
        // if (_selectedDialect == 'Slang English') locale = 'en-US';
        // await prefs.setString('selected_locale', locale);

        Fluttertoast.showToast(
          msg: l10n.welcomeToSeera(_nameController.text),
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        if (mounted) Navigator.pushReplacementNamed(context, '/chat');
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: AuthErrorHandler.getMessage(e, l10n));
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.signUp,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                Text(
                  l10n.joinSeera,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.loginSubtitle,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 32),
                _buildTextField(
                  l10n.fullName,
                  'John Doe',
                  controller: _nameController,
                  validator: (val) {
                    if (val == null || val.isEmpty) return l10n.required;
                    if (!Validator.isValidName(val)) {
                      return 'يرجى كتابة اسم حقيقي بدون أرقام.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  l10n.email,
                  'name@example.com',
                  controller: _emailController,
                  validator: (val) {
                    if (val == null || val.isEmpty) return l10n.required;
                    if (!Validator.isValidEmail(val)) {
                      return 'البريد الإلكتروني غير صحيح.';
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
                    if (val.length < 6) return 'كلمة المرور ضعيفة جداً.';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  l10n.confirmPassword,
                  l10n.confirmPassword,
                  isPassword: true,
                  controller: _confirmPasswordController,
                  obscureText: _obscurePassword,
                  toggleVisibility: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  validator: (val) {
                    if (val == null || val.isEmpty) return l10n.required;
                    if (val != _passwordController.text) {
                      return l10n.passwordsDoNotMatch;
                    }
                    return null;
                  },
                ),

                // Row(
                //   children: [
                //     const Icon(
                //       Icons.auto_awesome,
                //       color: AppTheme.primaryBlue,
                //       size: 20,
                //     ),
                //     const SizedBox(width: 8),
                //     Text(
                //       l10n.aiSettings,
                //       style: const TextStyle(
                //         color: Colors.white,
                //         fontSize: 18,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ],
                // ),

                // const SizedBox(height: 16),
                // Container(
                //   padding: const EdgeInsets.all(16),
                //   decoration: BoxDecoration(
                //     color: const Color(0xFF111827),
                //     borderRadius: BorderRadius.circular(16),
                //     border: Border.all(color: const Color(0xFF1E293B)),
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         l10n.primaryLanguage,
                //         style: const TextStyle(
                //           color: AppTheme.textMuted,
                //           fontSize: 14,
                //         ),
                //       ),
                //       const SizedBox(height: 12),
                //       Row(
                //         children: [
                //           _buildChoiceChip(
                //             'English',
                //             Icons.language,
                //             _selectedLanguage == 'English',
                //             (val) {
                //               setState(() => _selectedLanguage = 'English');
                //             },
                //           ),
                //           const SizedBox(width: 12),
                //           _buildChoiceChip(
                //             'العربية',
                //             Icons.language,
                //             _selectedLanguage == 'العربية',
                //             (val) {
                //               setState(() => _selectedLanguage = 'العربية');
                //             },
                //           ),
                //         ],
                //       ),
                //       const SizedBox(height: 20),
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text(
                //             l10n.preferredAiDialect,
                //             style: const TextStyle(
                //               color: AppTheme.textMuted,
                //               fontSize: 14,
                //             ),
                //           ),
                //           TextButton(
                //             onPressed: () {},
                //             child: Text(
                //               l10n.toneSetting,
                //               style: const TextStyle(
                //                 color: AppTheme.primaryBlue,
                //                 fontSize: 12,
                //                 fontWeight: FontWeight.bold,
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //       const SizedBox(height: 8),
                //       Wrap(
                //         spacing: 8,
                //         runSpacing: 8,
                //         children: [
                //           _buildSmallChoiceChip(
                //             l10n.slangEnglish,
                //             _selectedDialect == 'Slang English',
                //             (val) {
                //               setState(
                //                 () => _selectedDialect = 'Slang English',
                //               );
                //             },
                //           ),
                //           _buildSmallChoiceChip(
                //             l10n.egyptianArabic,
                //             _selectedDialect == 'Egyptian Arabic',
                //             (val) {
                //               setState(
                //                 () => _selectedDialect = 'Egyptian Arabic',
                //               );
                //             },
                //           ),
                //           _buildSmallChoiceChip(
                //             l10n.saudiArabic,
                //             _selectedDialect == 'Saudi Arabic',
                //             (val) {
                //               setState(() => _selectedDialect = 'Saudi Arabic');
                //             },
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(l10n.signUp),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, size: 20),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.alreadyHaveAccount,
                      style: const TextStyle(color: AppTheme.textMuted),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        l10n.login,
                        style: const TextStyle(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.bold,
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
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(color: Colors.white),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator:
              validator ??
              (value) {
                final l10n = AppLocalizations.of(context)!;
                if (value == null || value.isEmpty) return l10n.required;
                return null;
              },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppTheme.textMuted),
            fillColor: const Color(0xFF111827),
            filled: true,
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
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primaryBlue),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChoiceChip(
    String label,
    IconData icon,
    bool isSelected,
    Function(bool) onSelected,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onSelected(true),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? AppTheme.primaryBlue
                  : const Color(0xFF1E293B),
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : AppTheme.textMuted,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppTheme.textMuted,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallChoiceChip(
    String label,
    bool isSelected,
    Function(bool) onSelected,
  ) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: AppTheme.primaryBlue,
      backgroundColor: Colors.transparent,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppTheme.textMuted,
        fontSize: 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppTheme.primaryBlue : const Color(0xFF1E293B),
        ),
      ),
      showCheckmark: false,
    );
  }
}
