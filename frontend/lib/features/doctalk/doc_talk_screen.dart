import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/pulse_badge.dart';
import '../../core/widgets/pulse_button.dart';
import '../../core/widgets/pulse_card.dart';
import 'doctalk_provider.dart';

class DocTalkScreen extends ConsumerWidget {
  const DocTalkScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(docTalkProvider);
    final notifier = ref.read(docTalkProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DocTalk',
              style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              'Doctor & therapist consultations',
              style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.assignment_outlined, color: AppColors.primary),
            tooltip: 'Care Plans',
            onPressed: () => context.push(AppRoutes.docTalkCarePlans),
          ),
          IconButton(
            icon: const Icon(Icons.event_note_outlined, color: AppColors.secondary),
            tooltip: 'Appointments',
            onPressed: () => context.push(AppRoutes.appointments),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIntroBanner(context, state),
              const SizedBox(height: 20),
              Text(
                'Expert care, connected to your journey.',
                style: AppTypography.headlineLarge.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                'Connect with qualified healthcare professionals for personalized guidance and care.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              _buildCareTypeSelector(state, notifier),
              const SizedBox(height: 16),
              _buildSearchAndFilters(context, state, notifier),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  Text(
                    'Available Professionals (${state.filteredProfessionals.length})',
                    style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
                  ),
                  if (state.selectedCareType != 'All' || state.selectedMode != 'All')
                    TextButton(
                      onPressed: () {
                        notifier.selectCareType('All');
                        notifier.selectMode('All');
                        notifier.selectSpecialty('All');
                        notifier.setSearchQuery('');
                      },
                      child: Text(
                        'Reset Filters',
                        style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              if (state.filteredProfessionals.isEmpty)
                _buildEmptyState(context, notifier)
              else
                ...state.filteredProfessionals.map((pro) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildProfessionalCard(context, pro, state, notifier),
                    )),
              const SizedBox(height: 24),
              _buildSyntheticDisclaimerCard(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntroBanner(BuildContext context, DocTalkState state) {
    final offer = state.introductoryOffer;
    final isEligible = state.offerEligible;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE0F7F4), Color(0xFFE8F1FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.card_giftcard_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      offer?.title ?? 'First Consultation Free',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isEligible ? AppColors.primaryFixed : AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isEligible ? 'ACTIVE OFFER' : 'CLAIMED',
                        style: AppTypography.labelSmall.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                          color: isEligible ? AppColors.primary : AppColors.outline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  isEligible
                      ? 'Introductory offer: Your initial 45-minute consultation with an eligible doctor or therapist is 100% complimentary.'
                      : 'You have claimed your complimentary introductory consultation. Standard rates apply.',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareTypeSelector(DocTalkState state, DocTalkNotifier notifier) {
    final types = ['All', ...state.careTypes];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Care Type',
          style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: types.map((type) {
              final isSelected = state.selectedCareType == type;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(
                    type,
                    style: AppTypography.labelMedium.copyWith(
                      color: isSelected ? Colors.white : AppColors.onSurface,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surfaceContainerLow,
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.cardBorder,
                  ),
                  onSelected: (_) => notifier.selectCareType(type),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters(BuildContext context, DocTalkState state, DocTalkNotifier notifier) {
    final modes = ['All', 'Video Consultation', 'Audio Call', 'In-clinic'];

    return Column(
      children: [
        TextField(
          onChanged: notifier.setSearchQuery,
          decoration: InputDecoration(
            hintText: 'Search doctors, psychologists, nutritionists...',
            prefixIcon: const Icon(Icons.search, color: AppColors.outline),
            filled: true,
            fillColor: AppColors.surfaceContainerLowest,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.tune_outlined, size: 16, color: AppColors.outline),
            const SizedBox(width: 6),
            Text(
              'Mode:',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.outline,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: 32,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: modes.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 6),
                  itemBuilder: (context, index) {
                    final mode = modes[index];
                    final isSelected = state.selectedMode == mode;
                    return GestureDetector(
                      onTap: () => notifier.selectMode(mode),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.secondary : AppColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? AppColors.secondary : AppColors.cardBorder,
                          ),
                        ),
                        child: Text(
                          mode == 'All' ? 'All Modes' : mode.replaceAll(' Consultation', ''),
                          style: AppTypography.labelSmall.copyWith(
                            color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfessionalCard(
    BuildContext context,
    HealthcareProfessional pro,
    DocTalkState state,
    DocTalkNotifier notifier,
  ) {
    final isFreeEligible = state.offerEligible;

    return PulseCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.primaryContainer,
                child: Text(
                  pro.name.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            pro.name,
                            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        if (pro.isVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.verified, color: AppColors.primary, size: 16),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      pro.role,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${pro.experienceYears} yrs experience • ${pro.clinicOrOrg}',
                      style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              PulseBadge(
                text: pro.verificationNote,
                variant: PulseBadgeVariant.primary,
              ),
              ...pro.modes.map((m) => PulseBadge(
                    text: m,
                    variant: PulseBadgeVariant.secondary,
                  )),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            pro.bio,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Consultation Fee',
                    style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
                  ),
                  const SizedBox(height: 2),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      if (isFreeEligible) ...[
                        Text(
                          '₹${pro.fee.toInt()}',
                          style: AppTypography.bodyMedium.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.outline,
                          ),
                        ),
                        Text(
                          'FREE',
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const PulseBadge(
                          text: '1st Consult Offer',
                          variant: PulseBadgeVariant.success,
                        ),
                      ] else ...[
                        Text(
                          '₹${pro.fee.toInt()}',
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.onSurface,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          ' / 45 min',
                          style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      notifier.selectProfessional(pro);
                      context.push('${AppRoutes.docTalkProfile}/${pro.id}');
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      side: const BorderSide(color: AppColors.primary),
                    ),
                    child: Text(
                      'Profile',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      notifier.selectProfessional(pro);
                      context.push('${AppRoutes.docTalkBooking}/${pro.id}');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: Text(
                      'Book',
                      style: AppTypography.labelMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, DocTalkNotifier notifier) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 36),
        child: Column(
          children: [
            const Icon(Icons.search_off_rounded, size: 48, color: AppColors.outline),
            const SizedBox(height: 12),
            Text(
              'No professionals found for this filter.',
              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              'Try adjusting your specialty or consultation mode criteria.',
              style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
            ),
            const SizedBox(height: 16),
            PulseButton(
              text: 'View All Healthcare Professionals',
              isFullWidth: false,
              onPressed: () {
                notifier.selectCareType('All');
                notifier.selectMode('All');
                notifier.selectSpecialty('All');
                notifier.setSearchQuery('');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyntheticDisclaimerCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 16, color: AppColors.outline),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Evaluation Notice: Professional profiles shown here are synthetic demo entities with simulated booking slots for platform demonstration. Real practitioner registries connect via verified ABDM / NMC health ID credentials.',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.outline,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
