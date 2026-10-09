import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/pulse_button.dart';
import '../../core/widgets/pulse_card.dart';
import '../../core/widgets/pulse_text_field.dart';
import 'auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isSignUp = false;
  final _nameController = TextEditingController();
  final _identifierController = TextEditingController(text: 'patient@pulse.health');
  final _passwordController = TextEditingController(text: 'pulse123');
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedRole = 'patient';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = true;
  String? _localError;
  String? _successMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _identifierController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _fillDemoAccount(String role) {
    setState(() {
      _localError = null;
      _successMessage = null;
      _isSignUp = false;
      _selectedRole = role;
      if (role == 'patient') {
        _identifierController.text = 'patient@pulse.health';
        _passwordController.text = 'pulse123';
      } else {
        _identifierController.text = 'doctor@pulse.health';
        _passwordController.text = 'pulse123';
      }
    });
    ref.read(authProvider.notifier).clearError();
  }

  void _toggleMode(bool signUp) {
    setState(() {
      _isSignUp = signUp;
      _localError = null;
      _successMessage = null;
      if (_isSignUp) {
        if (_nameController.text.isEmpty) {
          _nameController.text = _selectedRole == 'patient' ? 'Ananya Sharma' : 'Dr. Meera Sharma';
        }
        if (_confirmPasswordController.text.isEmpty) {
          _confirmPasswordController.text = _passwordController.text;
        }
      }
    });
    ref.read(authProvider.notifier).clearError();
  }

  Future<void> _handleSubmit() async {
    setState(() {
      _localError = null;
      _successMessage = null;
    });
    ref.read(authProvider.notifier).clearError();

    final identifier = _identifierController.text.trim();
    final password = _passwordController.text.trim();

    if (_isSignUp) {
      final name = _nameController.text.trim();
      final confirmPassword = _confirmPasswordController.text.trim();

      if (name.isEmpty) {
        setState(() {
          _localError = 'Please enter your full name.';
        });
        return;
      }
      if (identifier.isEmpty) {
        setState(() {
          _localError = 'Please enter your email address.';
        });
        return;
      }
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(identifier)) {
        setState(() {
          _localError = 'Please enter a valid email address.';
        });
        return;
      }
      if (password.length < 6) {
        setState(() {
          _localError = 'Password must be at least 6 characters.';
        });
        return;
      }
      if (password != confirmPassword) {
        setState(() {
          _localError = 'Passwords do not match. Please verify.';
        });
        return;
      }
      if (!_agreedToTerms) {
        setState(() {
          _localError = 'Please accept the privacy terms to continue.';
        });
        return;
      }

      final success = await ref.read(authProvider.notifier).register(
        name: name,
        email: identifier,
        password: password,
        phone: _phoneController.text.trim(),
        role: _selectedRole,
      );

      if (success && mounted) {
        if (_selectedRole == 'patient') {
          context.go(AppRoutes.onboarding);
        } else {
          context.go(AppRoutes.home);
        }
      }
    } else {
      if (identifier.isEmpty) {
        setState(() {
          _localError = 'Please enter your email or mobile number.';
        });
        return;
      }
      if (password.isEmpty) {
        setState(() {
          _localError = 'Please enter your password.';
        });
        return;
      }

      final success = await ref.read(authProvider.notifier).login(
        identifier: identifier,
        password: password,
        role: _selectedRole,
      );

      if (success && mounted) {
        context.go(AppRoutes.home);
      }
    }
  }

  void _showForgotPasswordDialog() {
    final resetController = TextEditingController(text: _identifierController.text.trim());
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: AppColors.surfaceContainerLowest,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.lock_reset_rounded, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Reset Password',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your registered email and we will send you secure recovery instructions.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: resetController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'patient@pulse.health',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final targetEmail = resetController.text.trim();
                if (targetEmail.isEmpty) return;
                Navigator.of(ctx).pop();
                await ref.read(authProvider.notifier).resetPassword(targetEmail);
                if (mounted) {
                  setState(() {
                    _successMessage = 'Password reset instructions sent to $targetEmail';
                    _localError = null;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Send Link'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final displayedError = _localError ?? authState.error;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Row(
                children: [
                  Image.asset(
                    'assets/images/pulse_icon_transparent.png',
                    width: 38,
                    height: 38,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Pulse',
                    style: AppTypography.headlineMedium.copyWith(
                      color: const Color(0xFF03A1C6),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                _isSignUp ? 'Create your account' : 'Welcome to Pulse',
                style: AppTypography.displayMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isSignUp
                    ? 'Start your personalized continuous-care journey'
                    : 'Continuous care between consultations',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.outline,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.flash_on_rounded, size: 18, color: Color(0xFF03A1C6)),
                    const SizedBox(width: 8),
                    Text(
                      'Demo quick fill:',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          InkWell(
                            onTap: () => _fillDemoAccount('patient'),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: _selectedRole == 'patient' && !_isSignUp
                                    ? AppColors.primary
                                    : AppColors.surfaceContainerLowest,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _selectedRole == 'patient' && !_isSignUp
                                      ? AppColors.primary
                                      : AppColors.outlineVariant,
                                ),
                              ),
                              child: Text(
                                'Patient',
                                style: AppTypography.labelSmall.copyWith(
                                  color: _selectedRole == 'patient' && !_isSignUp
                                      ? Colors.white
                                      : AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => _fillDemoAccount('doctor'),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: _selectedRole == 'doctor' && !_isSignUp
                                    ? AppColors.secondary
                                    : AppColors.surfaceContainerLowest,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _selectedRole == 'doctor' && !_isSignUp
                                      ? AppColors.secondary
                                      : AppColors.outlineVariant,
                                ),
                              ),
                              child: Text(
                                'Doctor',
                                style: AppTypography.labelSmall.copyWith(
                                  color: _selectedRole == 'doctor' && !_isSignUp
                                      ? Colors.white
                                      : AppColors.secondary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _toggleMode(false),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: !_isSignUp ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: !_isSignUp
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              'Sign In',
                              style: AppTypography.labelLarge.copyWith(
                                color: !_isSignUp ? AppColors.primary : AppColors.outline,
                                fontWeight: !_isSignUp ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _toggleMode(true),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _isSignUp ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: _isSignUp
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              'Create Account',
                              style: AppTypography.labelLarge.copyWith(
                                color: _isSignUp ? AppColors.primary : AppColors.outline,
                                fontWeight: _isSignUp ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (displayedError != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.errorContainer.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          displayedError,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.onErrorContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _localError = null;
                          });
                          ref.read(authProvider.notifier).clearError();
                        },
                        child: const Icon(Icons.close_rounded, size: 18, color: AppColors.error),
                      ),
                    ],
                  ),
                ),
              ],
              if (_successMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.successContainer.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline_rounded, color: AppColors.success, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _successMessage!,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _successMessage = null;
                          });
                        },
                        child: const Icon(Icons.close_rounded, size: 18, color: AppColors.success),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
              if (_isSignUp) ...[
                PulseTextField(
                  label: 'Full Name',
                  hintText: 'Enter your full name',
                  controller: _nameController,
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                const SizedBox(height: 16),
              ],
              PulseTextField(
                label: _isSignUp ? 'Email address' : 'Email or Mobile number',
                hintText: 'patient@pulse.health',
                controller: _identifierController,
                prefixIcon: const Icon(Icons.email_outlined),
                keyboardType: TextInputType.emailAddress,
              ),
              if (_isSignUp) ...[
                const SizedBox(height: 16),
                PulseTextField(
                  label: 'Phone number (optional)',
                  hintText: '+91 98765 43210',
                  controller: _phoneController,
                  prefixIcon: const Icon(Icons.phone_outlined),
                  keyboardType: TextInputType.phone,
                ),
              ],
              const SizedBox(height: 16),
              PulseTextField(
                label: 'Password',
                hintText: _isSignUp ? 'At least 6 characters' : '••••••••',
                controller: _passwordController,
                obscureText: _obscurePassword,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: AppColors.outline,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              if (_isSignUp) ...[
                const SizedBox(height: 16),
                PulseTextField(
                  label: 'Confirm Password',
                  hintText: 'Re-enter your password',
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  prefixIcon: const Icon(Icons.lock_reset_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: AppColors.outline,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _agreedToTerms,
                        activeColor: AppColors.primary,
                        onChanged: (val) {
                          setState(() {
                            _agreedToTerms = val ?? true;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'I agree to the Terms of Service & Privacy Policy',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (!_isSignUp) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _showForgotPasswordDialog,
                    child: Text(
                      'Forgot password?',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Text(
                'I am using Pulse as:',
                style: AppTypography.labelLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: PulseCard(
                      onTap: () {
                        setState(() {
                          _selectedRole = 'patient';
                        });
                      },
                      borderColor: _selectedRole == 'patient'
                          ? AppColors.primary
                          : AppColors.cardBorder,
                      backgroundColor: _selectedRole == 'patient'
                          ? const Color(0xFFE6F4F1)
                          : AppColors.surfaceContainerLowest,
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.person_outline,
                            color: _selectedRole == 'patient'
                                ? AppColors.primary
                                : AppColors.outline,
                            size: 24,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Patient',
                            style: AppTypography.titleMedium.copyWith(
                              color: _selectedRole == 'patient'
                                  ? AppColors.primary
                                  : AppColors.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Continuous care journey',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PulseCard(
                      onTap: () {
                        setState(() {
                          _selectedRole = 'doctor';
                        });
                      },
                      borderColor: _selectedRole == 'doctor'
                          ? AppColors.secondary
                          : AppColors.cardBorder,
                      backgroundColor: _selectedRole == 'doctor'
                          ? const Color(0xFFEBF5FC)
                          : AppColors.surfaceContainerLowest,
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.medical_services_outlined,
                            color: _selectedRole == 'doctor'
                                ? AppColors.secondary
                                : AppColors.outline,
                            size: 24,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Doctor',
                            style: AppTypography.titleMedium.copyWith(
                              color: _selectedRole == 'doctor'
                                  ? AppColors.secondary
                                  : AppColors.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Manage your patients',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              PulseButton(
                text: _isSignUp
                    ? 'Create ${_selectedRole == 'patient' ? 'Patient' : 'Doctor'} Account'
                    : (_selectedRole == 'patient' ? 'Sign In as Patient' : 'Sign In as Doctor'),
                isLoading: authState.isLoading,
                onPressed: _handleSubmit,
              ),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    _isSignUp ? 'Already have an account?' : 'Don’t have an account?',
                    style: AppTypography.bodyMedium,
                  ),
                  const SizedBox(width: 4),
                  TextButton(
                    onPressed: () => _toggleMode(!_isSignUp),
                    child: Text(
                      _isSignUp ? 'Sign in' : 'Create account',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_outline, size: 14, color: AppColors.outline),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'Your health information stays private and secure.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.outline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
