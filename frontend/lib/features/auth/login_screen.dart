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
  final _nameController = TextEditingController(text: 'Ananya Sharma');
  final _identifierController = TextEditingController(text: 'patient@pulse.health');
  final _passwordController = TextEditingController(text: 'pulse123');
  final _phoneController = TextEditingController(text: '+91 98765 43210');
  String _selectedRole = 'patient';
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _identifierController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final authNotifier = ref.read(authProvider.notifier);
    bool success = false;

    if (_isSignUp) {
      if (_nameController.text.trim().isEmpty ||
          _identifierController.text.trim().isEmpty ||
          _passwordController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all required fields.')),
        );
        return;
      }
      success = await authNotifier.register(
        name: _nameController.text.trim(),
        email: _identifierController.text.trim(),
        password: _passwordController.text.trim(),
        phone: _phoneController.text.trim(),
        role: _selectedRole,
      );
    } else {
      success = await authNotifier.login(
        identifier: _identifierController.text.trim(),
        password: _passwordController.text.trim(),
        role: _selectedRole,
      );
    }

    if (success && mounted) {
      if (_selectedRole == 'patient') {
        context.go(AppRoutes.onboarding);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Doctor role selected. Patient flow is the primary implementation.'),
          ),
        );
        context.go(AppRoutes.home);
      }
    } else if (mounted) {
      final err = ref.read(authProvider).error;
      if (err != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err), backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
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
              const SizedBox(height: 28),
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
              const SizedBox(height: 24),
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
                        onTap: () {
                          setState(() {
                            _isSignUp = false;
                          });
                        },
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
                        onTap: () {
                          setState(() {
                            _isSignUp = true;
                          });
                        },
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
              const SizedBox(height: 24),
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
                label: 'Email or Mobile number',
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
                hintText: '••••••••',
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
              if (!_isSignUp) ...[
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Password reset instructions sent to your email.'),
                        ),
                      );
                    },
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
              const SizedBox(height: 20),
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
                    onPressed: () {
                      setState(() {
                        _isSignUp = !_isSignUp;
                      });
                    },
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
