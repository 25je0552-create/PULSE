import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/pulse_badge.dart';
import '../../core/widgets/pulse_button.dart';
import '../../core/widgets/pulse_card.dart';
import '../../core/widgets/pulse_text_field.dart';

class ConnectDoctorScreen extends StatefulWidget {
  const ConnectDoctorScreen({super.key});

  @override
  State<ConnectDoctorScreen> createState() => _ConnectDoctorScreenState();
}

class _ConnectDoctorScreenState extends State<ConnectDoctorScreen> {
  final _codeController = TextEditingController(text: 'SJH-4829');
  bool _isConnected = true;
  bool _isConnecting = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _handleConnect() async {
    setState(() => _isConnecting = true);
    try {
      await ApiClient().post(
        ApiEndpoints.careConnectDoctor,
        data: {'inviteCode': _codeController.text.trim()},
      );
    } catch (_) {}
    if (mounted) {
      setState(() {
        _isConnecting = false;
        _isConnected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => context.go(AppRoutes.baseline),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: PulseBadge(
                text: 'Step 4 of 4',
                variant: PulseBadgeVariant.primary,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Connect Care Team',
                style: AppTypography.headlineLarge.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Stay connected to your care.',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Pulse can help you share meaningful progress with your care team, so consultations are based on a clearer picture of what’s happening between visits.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              PulseCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.medical_services_outlined, color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Connect your care professional',
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'If your doctor, therapist, or health partner uses Pulse, enter their unique invite code.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: PulseTextField(
                            controller: _codeController,
                            hintText: 'Care Invite Code',
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 110,
                          child: PulseButton(
                            text: 'Connect',
                            isLoading: _isConnecting,
                            onPressed: _handleConnect,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You can find this on your intake form or clinic welcome email.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.outline,
                      ),
                    ),
                  ],
                ),
              ),
              if (_isConnected) ...[
                const SizedBox(height: 16),
                PulseCard(
                  backgroundColor: const Color(0xFFF0FDF4),
                  borderColor: const Color(0xFFBBF7D0),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Dr. Meera Sharma, MD',
                                    style: AppTypography.titleMedium.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF166534),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const PulseBadge(
                                  text: 'Active',
                                  variant: PulseBadgeVariant.success,
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Clinical Wellbeing Partner • St. Jude Health Center',
                              style: AppTypography.bodySmall.copyWith(
                                color: const Color(0xFF15803D),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 28),
              Text(
                'Why connect your care?',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              _buildReasonTile(
                icon: Icons.insights_outlined,
                title: 'Share meaningful progress',
                desc: 'Daily reflections and tracked trends can be summarized for consultations.',
              ),
              const SizedBox(height: 10),
              _buildReasonTile(
                icon: Icons.forum_outlined,
                title: 'Prepare for better consultations',
                desc: 'Structured context means less time repeating history and more on next steps.',
              ),
              const SizedBox(height: 10),
              _buildReasonTile(
                icon: Icons.hub_outlined,
                title: 'Keep your care journey connected',
                desc: 'Your doctor and therapist stay in the loop when needed seamlessly.',
              ),
              const SizedBox(height: 24),
              PulseCard(
                backgroundColor: const Color(0xFFF8FAFC),
                borderColor: const Color(0xFFE2E8F0),
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.shield_outlined, color: AppColors.secondary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'You stay in control.',
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.secondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'You decide what information is shared with your care team. Information sharing is permission-based, transparent, and can be modified anytime in your privacy preferences.',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              PulseButton(
                text: 'Continue to Pulse',
                icon: Icons.arrow_forward,
                onPressed: () => context.go(AppRoutes.home),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'You can connect or change your care team at any time in Profile Settings.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReasonTile({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return PulseCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
