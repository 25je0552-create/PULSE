import 'package:flutter_riverpod/legacy.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

class ChatMessage {
  final String id;
  final String sender;
  final String text;
  final String timestamp;
  final bool isSafetyEscalated;
  final List<dynamic>? safetyResources;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
    this.isSafetyEscalated = false,
    this.safetyResources,
  });
}

class AiState {
  final bool isLoading;
  final bool isSending;
  final List<ChatMessage> messages;
  final Map<String, dynamic> checkinContext;
  final String synthesisText;
  final Map<String, dynamic> suggestedSmallStep;
  final bool hasSafetyEscalation;

  AiState({
    this.isLoading = false,
    this.isSending = false,
    this.messages = const [],
    this.checkinContext = const {
      'mood': 'Okay',
      'stress': 'High',
      'energy': 'Low',
      'sleep': 'Poorly',
      'reflection': 'Work has been overwhelming this week.',
    },
    this.synthesisText =
        'I noticed that your stress is higher and your energy is lower today, while you also reported poor sleep. That combination can make a busy day feel harder. Rather than trying to change everything at once, let\'s focus on one small thing you can do today.',
    this.suggestedSmallStep = const {
      'title': 'Take a 10-minute walk or spend 10 minutes away from your work screen today.',
      'duration': '10 min',
      'description': 'Choose whichever feels more realistic right now. Low pressure, non-medical habit.',
    },
    this.hasSafetyEscalation = false,
  });

  AiState copyWith({
    bool? isLoading,
    bool? isSending,
    List<ChatMessage>? messages,
    Map<String, dynamic>? checkinContext,
    String? synthesisText,
    Map<String, dynamic>? suggestedSmallStep,
    bool? hasSafetyEscalation,
  }) {
    return AiState(
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      messages: messages ?? this.messages,
      checkinContext: checkinContext ?? this.checkinContext,
      synthesisText: synthesisText ?? this.synthesisText,
      suggestedSmallStep: suggestedSmallStep ?? this.suggestedSmallStep,
      hasSafetyEscalation: hasSafetyEscalation ?? this.hasSafetyEscalation,
    );
  }
}

class AiNotifier extends StateNotifier<AiState> {
  final ApiClient _apiClient = ApiClient();

  AiNotifier()
      : super(
          AiState(
            messages: [
              ChatMessage(
                id: '1',
                sender: 'user',
                text: 'Work has been overwhelming this week.',
                timestamp: '08:32 AM',
              ),
              ChatMessage(
                id: '2',
                sender: 'pulse_ai',
                text:
                    'Taking brief moments to step back can give your nervous system a pause. Would you like a 2-minute breathing reset or ideas on setting gentle boundaries today?',
                timestamp: '08:33 AM',
              ),
            ],
          ),
        );

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: 'user',
      text: text,
      timestamp: 'Just now',
    );

    state = state.copyWith(
      isSending: true,
      messages: [...state.messages, userMsg],
    );

    try {
      final res = await _apiClient.post(
        ApiEndpoints.aiChat,
        data: {'message': text},
      );

      if (res.statusCode == 200 && res.data['success'] == true) {
        final isSafety = res.data['safetyEscalated'] == true;
        final responseText = res.data['text'] ?? '';
        final resources = res.data['resources'];

        final aiMsg = ChatMessage(
          id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
          sender: 'pulse_ai',
          text: responseText,
          timestamp: 'Just now',
          isSafetyEscalated: isSafety,
          safetyResources: resources,
        );

        state = state.copyWith(
          isSending: false,
          messages: [...state.messages, aiMsg],
          hasSafetyEscalation: isSafety,
        );
        return;
      }
    } catch (_) {}

    final fallbackAi = ChatMessage(
      id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
      sender: 'pulse_ai',
      text:
          'Taking brief moments to step back can give your nervous system a pause. Would you like a 2-minute breathing reset or ideas on setting gentle boundaries today?',
      timestamp: 'Just now',
    );

    state = state.copyWith(
      isSending: false,
      messages: [...state.messages, fallbackAi],
    );
  }
}

final aiProvider = StateNotifierProvider<AiNotifier, AiState>((ref) {
  return AiNotifier();
});
