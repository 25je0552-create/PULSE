import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/orb_widget.dart';
import '../../core/widgets/pulse_button.dart';
import 'ai_provider.dart';

class PulseAiScreen extends ConsumerStatefulWidget {
  const PulseAiScreen({super.key});

  @override
  ConsumerState<PulseAiScreen> createState() => _PulseAiScreenState();
}

class _PulseAiScreenState extends ConsumerState<PulseAiScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isVoiceMode = false;
  OrbState _voiceOrbState = OrbState.idle;
  String _userSpeech = '';
  String _voiceReply =
      'Tap the microphone below to talk through your signals, routines, or prepare notes for care.';

  final List<String> _suggestedPrompts = [
    'Why is my energy low today?',
    'How should I pace my afternoon?',
    'Suggest a 2-min nervous system reset',
    'Prepare notes for Dr. Meera Sharma',
    'Explain my sleep & stress pattern',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    _textController.clear();
    ref.read(aiProvider.notifier).sendMessage(text);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _toggleVoiceListening() {
    if (_voiceOrbState == OrbState.listening) {
      setState(() {
        _voiceOrbState = OrbState.idle;
      });
      return;
    }

    setState(() {
      _voiceOrbState = OrbState.listening;
      _userSpeech = 'Listening...';
    });

    Future.delayed(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      final samples = [
        'I feel really exhausted this afternoon and need a gentle pacing plan.',
        'Can you explain why my stress spikes after poor sleep?',
        'Suggest a 2-min nervous system reset.',
        'Prepare clinical summary notes for my doctor appointment.',
      ];
      final spoken = samples[math.Random().nextInt(samples.length)];

      setState(() {
        _voiceOrbState = OrbState.thinking;
        _userSpeech = spoken;
      });

      ref.read(aiProvider.notifier).sendMessage(spoken);

      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        final aiState = ref.read(aiProvider);
        if (aiState.messages.isNotEmpty) {
          final last = aiState.messages.last;
          if (last.sender == 'pulse_ai') {
            setState(() {
              _voiceOrbState = last.isSafetyEscalated ? OrbState.error : OrbState.speaking;
              _voiceReply = last.text;
            });
            Future.delayed(const Duration(seconds: 4), () {
              if (mounted && _voiceOrbState == OrbState.speaking) {
                setState(() => _voiceOrbState = OrbState.idle);
              }
            });
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final aiState = ref.watch(aiProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => context.canPop() ? context.pop() : context.go(AppRoutes.home),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: OrbWidget(
                size: 22,
                state: aiState.hasSafetyEscalation
                    ? OrbState.error
                    : (aiState.isSending ? OrbState.thinking : OrbState.idle),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Pulse AI',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: _isVoiceMode ? AppColors.primary : AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _isVoiceMode ? AppColors.primary : AppColors.cardBorder,
                    width: 1.0,
                  ),
                ),
                child: Icon(
                  _isVoiceMode ? Icons.chat_bubble_outline : Icons.mic,
                  color: _isVoiceMode ? Colors.white : AppColors.primary,
                  size: 18,
                ),
              ),
              tooltip: _isVoiceMode ? 'Switch to Chat' : 'Switch to Voice Assistant',
              onPressed: () {
                setState(() {
                  _isVoiceMode = !_isVoiceMode;
                });
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.health_and_safety_outlined, color: AppColors.error),
            tooltip: 'Safety & Emergency Help',
            onPressed: () => context.push(AppRoutes.safety),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: _isVoiceMode ? _buildVoiceView(aiState) : _buildChatView(aiState),
      ),
    );
  }

  Widget _buildChatView(AiState aiState) {
    return Column(
      children: [
        _buildDisclaimerBanner(),
        if (aiState.hasSafetyEscalation) _buildCrisisBanner(),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            itemCount: aiState.messages.length,
            itemBuilder: (context, index) {
              final msg = aiState.messages[index];
              return _buildMessageBubble(msg);
            },
          ),
        ),
        if (aiState.isSending)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: Row(
              children: [
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.8,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Pulse AI formulating continuous-care explanation...',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.outline,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _suggestedPrompts.length,
            separatorBuilder: (_, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final prompt = _suggestedPrompts[index];
              return ActionChip(
                label: Text(
                  prompt,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                backgroundColor: AppColors.surfaceContainerLow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                  side: const BorderSide(color: AppColors.cardBorder, width: 1.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                onPressed: () => _sendMessage(prompt),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        _buildInputBar(),
      ],
    );
  }

  Widget _buildDisclaimerBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.cardBorder, width: 1.0),
      ),
      child: Row(
        children: [
          const Icon(Icons.shield_outlined, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Continuous-care support · Non-diagnostic · Professional care backup',
              style: AppTypography.labelSmall.copyWith(
                fontSize: 11,
                color: AppColors.outline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    final isUser = msg.sender == 'user';
    final isSafety = msg.isSafetyEscalated;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.82,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? AppColors.primary
              : (isSafety ? const Color(0xFFFDE8E8) : AppColors.surfaceContainerLowest),
          borderRadius: BorderRadius.circular(16),
          border: isUser
              ? null
              : Border.all(
                  color: isSafety ? AppColors.error : AppColors.cardBorder,
                  width: 1.0,
                ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              msg.text,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.45,
                color: isUser
                    ? Colors.white
                    : (isSafety ? AppColors.error : AppColors.onSurface),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isUser) ...[
                  const Icon(Icons.auto_awesome, size: 10, color: AppColors.outline),
                  const SizedBox(width: 4),
                ],
                Text(
                  msg.timestamp,
                  style: TextStyle(
                    fontSize: 10,
                    color: isUser ? Colors.white70 : AppColors.outline,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.cardBorder, width: 1.0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.cardBorder, width: 1.0),
              ),
              child: TextField(
                controller: _textController,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w400,
                ),
                decoration: const InputDecoration(
                  hintText: 'Tell Pulse what\'s on your mind...',
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: AppColors.outline,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                ),
                onSubmitted: _sendMessage,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _sendMessage(_textController.text),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_upward_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceView(AiState aiState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          _buildDisclaimerBanner(),
          const SizedBox(height: 20),
          Text(
            _voiceOrbState == OrbState.listening
                ? 'Listening to you...'
                : (_voiceOrbState == OrbState.thinking
                    ? 'Pulse AI is reflecting...'
                    : (_voiceOrbState == OrbState.speaking
                        ? 'Pulse AI is speaking...'
                        : 'Voice Assistant Active')),
            style: AppTypography.labelLarge.copyWith(
              color: _voiceOrbState == OrbState.listening
                  ? AppColors.primary
                  : AppColors.outline,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: OrbWidget(
              size: 200,
              state: _voiceOrbState,
            ),
          ),
          const SizedBox(height: 32),
          if (_userSpeech.isNotEmpty && _voiceOrbState != OrbState.listening) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.record_voice_over, color: AppColors.primary, size: 16),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      '"$_userSpeech"',
                      style: AppTypography.bodySmall.copyWith(
                        fontStyle: FontStyle.italic,
                        color: AppColors.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.volume_up, size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'AI Speech Response',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  _voiceReply,
                  style: AppTypography.bodyMedium.copyWith(height: 1.45),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: _toggleVoiceListening,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _voiceOrbState == OrbState.listening
                    ? const Color(0xFFEF4444)
                    : AppColors.primary,
                boxShadow: [
                  BoxShadow(
                    color: (_voiceOrbState == OrbState.listening
                            ? const Color(0xFFEF4444)
                            : AppColors.primary)
                        .withValues(alpha: 0.35),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Icon(
                _voiceOrbState == OrbState.listening ? Icons.stop : Icons.mic,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _voiceOrbState == OrbState.listening
                ? 'Tap to stop'
                : 'Tap to speak with Pulse AI',
            style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
          ),
        ],
      ),
    );
  }

  Widget _buildCrisisBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFDE8E8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.error),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning, color: AppColors.error, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Safety Support Active',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Normal AI coaching has paused. Please connect with immediate human support or a verified professional helpline.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.error),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: PulseButton(
                  text: 'Tele-MANAS (14416)',
                  variant: PulseButtonVariant.primary,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: PulseButton(
                  text: 'Safety Screen',
                  variant: PulseButtonVariant.outlined,
                  onPressed: () => context.push(AppRoutes.safety),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
