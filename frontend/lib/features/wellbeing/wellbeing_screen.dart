import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class WellbeingScreen extends StatefulWidget {
  const WellbeingScreen({super.key});

  @override
  State<WellbeingScreen> createState() => _WellbeingScreenState();
}

class _WellbeingScreenState extends State<WellbeingScreen> {
  final _reflectionController = TextEditingController(
    text: 'I\'ve been feeling overwhelmed with work lately.',
  );
  bool _saved = false;
  bool _microStepScheduled = false;

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  void _saveReflection() {
    setState(() => _saved = true);
    ApiClient().post(
      ApiEndpoints.wellbeingReflection,
      data: {'text': _reflectionController.text.trim()},
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reflection saved locally and kept private.'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showCalendarHistoryModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Wellbeing History & Rhythm',
                    style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Self-reported records are personal and help uncover patterns across weeks.',
              style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F3FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildHistoryDay('Mon', 'Okay', const Color(0xFF00685F)),
                  _buildHistoryDay('Tue', 'Calm', const Color(0xFF00685F)),
                  _buildHistoryDay('Wed', 'Tense', const Color(0xFFD97706)),
                  _buildHistoryDay('Thu', 'Tired', const Color(0xFF4648D4)),
                  _buildHistoryDay('Today', 'Okay', const Color(0xFF00685F)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  context.push(AppRoutes.progress);
                },
                child: const Text('View detailed progress trends', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryDay(String day, String status, Color color) {
    return Column(
      children: [
        Text(day, style: AppTypography.labelSmall.copyWith(color: AppColors.outline)),
        const SizedBox(height: 4),
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(height: 4),
        Text(status, style: AppTypography.labelSmall.copyWith(fontSize: 10, fontWeight: FontWeight.w600)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF8FF),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Center(
            child: Material(
              color: const Color(0xFFEAEDFF),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => context.pop(),
                child: const SizedBox(
                  width: 38,
                  height: 38,
                  child: Icon(Icons.arrow_back, color: Color(0xFF131B2E), size: 18),
                ),
              ),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Wellbeing',
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700, color: const Color(0xFF131B2E)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
              decoration: BoxDecoration(
                color: const Color(0xFFCCE5FF),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'SIGNAL · REFLECTION · SUPPORT',
                style: TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF001D31),
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Material(
                color: const Color(0xFFEAEDFF),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: _showCalendarHistoryModal,
                  child: const SizedBox(
                    width: 38,
                    height: 38,
                    child: Icon(Icons.calendar_today, color: Color(0xFF131B2E), size: 18),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Take a moment to check in with yourself.',
                style: AppTypography.bodyMedium.copyWith(color: const Color(0xFF3D4947)),
              ),
              const SizedBox(height: 16),
              _buildHeroBreathingCard(context),
              const SizedBox(height: 18),
              _buildRecentWellbeingCard(),
              const SizedBox(height: 18),
              _buildReflectionCard(),
              const SizedBox(height: 18),
              _buildNoticingCard(context),
              const SizedBox(height: 18),
              _buildAdaptiveStepCard(context),
              const SizedBox(height: 18),
              _buildWellbeingResourcesSection(context),
              const SizedBox(height: 18),
              _buildSafetyCard(context),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBreathingCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E7FF), width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 130,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [Color(0xFF00685F), Color(0xFF008378), Color(0xFF5BB8FE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Icon(
                        Icons.spa,
                        size: 90,
                        color: Colors.white.withValues(alpha: 0.18),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.spa, color: Color(0xFF00685F), size: 14),
                        SizedBox(width: 4),
                        Text(
                          'Calm breathing space',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF131B2E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'How are you really doing?',
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF131B2E),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Your wellbeing can change from day to day. There’s no right answer here.',
            style: AppTypography.bodySmall.copyWith(color: const Color(0xFF3D4947)),
          ),
          const SizedBox(height: 14),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              Material(
                color: const Color(0xFF00685F),
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () => context.push(AppRoutes.checkin),
                  borderRadius: BorderRadius.circular(10),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Check in',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAEDFF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.timer_outlined, size: 14, color: Color(0xFF00685F)),
                    SizedBox(width: 4),
                    Text(
                      'About 30 seconds',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF3D4947),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentWellbeingCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your recent wellbeing',
          style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700, color: const Color(0xFF131B2E)),
        ),
        const SizedBox(height: 2),
        Text(
          'Based on your recent self-reported check-ins. No clinical scores calculated.',
          style: AppTypography.bodySmall.copyWith(color: const Color(0xFF6D7A77)),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildMetricTile(
              'Mood',
              'Okay',
              'Gentle baseline',
              Icons.sentiment_satisfied,
              const Color(0xFF00685F),
              const Color(0xFFE6F5F3),
            ),
            const SizedBox(width: 10),
            _buildMetricTile(
              'Stress',
              'Moderate',
              'Evening indicator',
              Icons.waves,
              const Color(0xFF006398),
              const Color(0xFFCCE5FF),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildMetricTile(
              'Energy',
              'Low',
              'Resting phase',
              Icons.battery_3_bar,
              const Color(0xFFD97706),
              const Color(0xFFFEF3C7),
            ),
            const SizedBox(width: 10),
            _buildMetricTile(
              'Sleep',
              'Needs attention',
              'Interrupted rhythm',
              Icons.bedtime,
              const Color(0xFF4648D4),
              const Color(0xFFE1E0FF),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricTile(String label, String value, String sub, IconData icon, Color fg, Color bg) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEAEDFF), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3D4947),
                    letterSpacing: 0.5,
                  ),
                ),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
                  child: Icon(icon, size: 16, color: fg),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700, color: const Color(0xFF131B2E)),
            ),
            const SizedBox(height: 2),
            Text(
              sub,
              style: AppTypography.bodySmall.copyWith(color: const Color(0xFF6D7A77), fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReflectionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAEDFF), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.edit_note, color: Color(0xFF00685F), size: 20),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Take a moment',
                        style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700, color: const Color(0xFF131B2E)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAEDFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Private',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF3D4947)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Is there something on your mind today?',
            style: AppTypography.bodySmall.copyWith(color: const Color(0xFF6D7A77)),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _reflectionController,
            maxLines: 3,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF2F3FF),
              hintText: 'Write anything that feels helpful to get out...',
              hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF6D7A77)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
            style: const TextStyle(fontSize: 13, color: Color(0xFF131B2E)),
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              Icon(Icons.lock_outline, size: 14, color: Color(0xFF6D7A77)),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Only share what you\'re comfortable sharing. Reflections stay private and unshared by default.',
                  style: TextStyle(fontSize: 11, color: Color(0xFF6D7A77)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_saved)
                const Row(
                  children: [
                    Icon(Icons.check_circle, size: 16, color: Color(0xFF00685F)),
                    SizedBox(width: 4),
                    Text(
                      'Reflection saved locally',
                      style: TextStyle(color: Color(0xFF00685F), fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                )
              else
                const SizedBox.shrink(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00685F),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onPressed: _saveReflection,
                child: const Text('Save reflection', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoticingCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E7FF), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                  color: Color(0xFFCCE5FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.insights, size: 16, color: Color(0xFF006398)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'What you\'ve been noticing',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700, color: const Color(0xFF131B2E)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your recent check-ins show higher stress on days when your sleep was lower.',
                  style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700, color: const Color(0xFF131B2E)),
                ),
                const SizedBox(height: 4),
                Text(
                  'Patterns can take time to become clear. Observing connections helps you explore rhythms without self-judgment.',
                  style: AppTypography.bodySmall.copyWith(color: const Color(0xFF3D4947)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () => context.push(AppRoutes.progress),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View my progress',
                    style: TextStyle(
                      color: Color(0xFF006398),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 14, color: Color(0xFF006398)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdaptiveStepCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAEDFF), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'ADAPTIVE MICRO-STEP',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF00685F),
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.self_improvement, size: 18, color: Color(0xFF00685F)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Something small to try',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700, color: const Color(0xFF131B2E)),
          ),
          const SizedBox(height: 4),
          Text(
            'Take 10 quiet minutes away from your screen today.',
            style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700, color: const Color(0xFF131B2E)),
          ),
          const SizedBox(height: 4),
          Text(
            'Choose something that feels realistic, not perfect. No streak pressure.',
            style: AppTypography.bodySmall.copyWith(color: const Color(0xFF6D7A77)),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _microStepScheduled ? const Color(0xFF008378) : const Color(0xFF00685F),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                  ),
                  onPressed: () {
                    setState(() => _microStepScheduled = true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Scheduled 10-minute quiet pause today.')),
                    );
                  },
                  child: Text(
                    _microStepScheduled ? 'Scheduled ✓' : 'Try this',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFFEAEDFF),
                    foregroundColor: const Color(0xFF131B2E),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                  ),
                  onPressed: () => context.push(AppRoutes.adaptiveGoal),
                  child: const Text(
                    'Choose another',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWellbeingResourcesSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAEDFF), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.hub_outlined, size: 20, color: Color(0xFF006398)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Connected Support & Resources',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF131B2E),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Explore supportive spaces, care preparation, and learning resources at your own pace.',
            style: AppTypography.bodySmall.copyWith(color: const Color(0xFF3D4947)),
          ),
          const SizedBox(height: 14),
          _buildSupportRow(
            context: context,
            icon: Icons.psychology_outlined,
            iconBg: const Color(0xFFCCE5FF),
            iconColor: const Color(0xFF006398),
            title: 'Talk it through with Pulse AI',
            subtitle: 'Supportive reflection and gentle check-in prompts',
            actionText: 'Open AI',
            onTap: () => context.go(AppRoutes.pulseAi),
          ),
          const Divider(height: 16, color: Color(0xFFEAEDFF)),
          _buildSupportRow(
            context: context,
            icon: Icons.groups_outlined,
            iconBg: const Color(0xFFD6F5EE),
            iconColor: const Color(0xFF00685F),
            title: 'Community Peer Support',
            subtitle: 'Anonymous discussions, shared journeys, and empathy',
            actionText: 'Community',
            onTap: () => context.go(AppRoutes.community),
          ),
          const Divider(height: 16, color: Color(0xFFEAEDFF)),
          _buildSupportRow(
            context: context,
            icon: Icons.medical_services_outlined,
            iconBg: const Color(0xFFF2F3FF),
            iconColor: const Color(0xFF00685F),
            title: 'Your Care Team Preparation',
            subtitle: 'Prepare a summary for your next visit (not shared automatically)',
            actionText: 'Prepare',
            onTap: () => context.push(AppRoutes.preConsult),
          ),
          const Divider(height: 16, color: Color(0xFFEAEDFF)),
          _buildSupportRow(
            context: context,
            icon: Icons.menu_book_outlined,
            iconBg: const Color(0xFFF2F3FF),
            iconColor: const Color(0xFF3D4947),
            title: 'Understanding Stress & Awareness',
            subtitle: 'Learn how your nervous system responds to micro-pressures',
            actionText: 'Learn',
            onTap: () => context.push(AppRoutes.awareness),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportRow({
    required BuildContext context,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String actionText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: Color(0xFF131B2E),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF3D4947),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  actionText,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF00685F),
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(Icons.arrow_forward, size: 14, color: Color(0xFF00685F)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFDAD6).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFDAD6), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFDAD6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.emergency_outlined, size: 18, color: Color(0xFF93000A)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sometimes you need more than an app',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF131B2E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'If you\'re struggling, feeling overwhelmed, or feel unsafe, reaching out to a trusted person or qualified professional can be an important next step.',
                      style: AppTypography.bodySmall.copyWith(color: const Color(0xFF3D4947)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 10,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CRISIS LIFELINE',
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFF3D4947), letterSpacing: 0.4),
                  ),
                  Text(
                    'Call or text 988',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF131B2E)),
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF131B2E),
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
                onPressed: () => context.push(AppRoutes.safety),
                child: const Text('Get 24/7 human support', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
