import 'package:flutter_riverpod/legacy.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

class AwarenessItem {
  final String id;
  final String title;
  final String subtitle;
  final String category;
  final String duration;
  final String videoUrl;
  final bool isFeatured;
  final bool hasAudio;
  final String reviewedBy;
  final bool isSaved;
  final List<dynamic> takeaways;

  AwarenessItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.duration,
    required this.videoUrl,
    this.isFeatured = false,
    this.hasAudio = true,
    required this.reviewedBy,
    this.isSaved = false,
    this.takeaways = const [],
  });

  AwarenessItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? category,
    String? duration,
    String? videoUrl,
    bool? isFeatured,
    bool? hasAudio,
    String? reviewedBy,
    bool? isSaved,
    List<dynamic>? takeaways,
  }) {
    return AwarenessItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      category: category ?? this.category,
      duration: duration ?? this.duration,
      videoUrl: videoUrl ?? this.videoUrl,
      isFeatured: isFeatured ?? this.isFeatured,
      hasAudio: hasAudio ?? this.hasAudio,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      isSaved: isSaved ?? this.isSaved,
      takeaways: takeaways ?? this.takeaways,
    );
  }
}

class AwarenessState {
  final bool isLoading;
  final String selectedCategory;
  final List<AwarenessItem> items;

  AwarenessState({
    this.isLoading = false,
    this.selectedCategory = 'All',
    this.items = const [],
  });

  AwarenessState copyWith({
    bool? isLoading,
    String? selectedCategory,
    List<AwarenessItem>? items,
  }) {
    return AwarenessState(
      isLoading: isLoading ?? this.isLoading,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      items: items ?? this.items,
    );
  }
}

class AwarenessNotifier extends StateNotifier<AwarenessState> {
  final ApiClient _apiClient = ApiClient();

  AwarenessNotifier()
      : super(
          AwarenessState(
            items: [
              AwarenessItem(
                id: 'aware_1',
                title: 'Understanding stress and your body',
                subtitle: 'Learn how stress affects your everyday nervous system and what healthy, sustainable coping strategies look like.',
                category: 'Mental wellbeing',
                duration: '4 min',
                videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
                isFeatured: true,
                reviewedBy: 'Dr. Meera Sharma & Clinical Wellbeing Board',
                isSaved: true,
                takeaways: [
                  {
                    'title': 'Notice your signals',
                    'body': 'Stress responses show up physiologically in heart rate variability, shallow breath patterns, and altered sleep cycles. Recognizing them is the first step.'
                  },
                  {
                    'title': 'Small responses matter',
                    'body': 'Micro-breaks, deliberate diaphragmatic breathing, and consistent downtime actively stimulate the vagal nerve and parasympathetic recovery.'
                  },
                  {
                    'title': 'Know when to reach out',
                    'body': 'If stress feels persistent or interrupts daily tasks, discuss it openly with someone you trust or consult your certified clinical practitioner.'
                  }
                ],
              ),
              AwarenessItem(
                id: 'aware_2',
                title: 'Why restorative sleep matters',
                subtitle: 'Learn how sleep cycles connect with your daily energy baseline and emotional regulation.',
                category: 'Sleep',
                duration: '5 min',
                videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
                isFeatured: false,
                reviewedBy: 'Clinical Sleep Advisory',
                isSaved: true,
                takeaways: [
                  {
                    'title': 'Sleep rhythm consistency',
                    'body': 'Regular waking times stabilize your internal clock better than irregular weekend sleeping-in.'
                  }
                ],
              ),
              AwarenessItem(
                id: 'aware_3',
                title: 'Understanding PCOS & Everyday Wellbeing',
                subtitle: 'Demystifying insulin sensitivity, cyclic fluctuations, and non-stigmatized lifestyle pacing.',
                category: 'Care & consultations',
                duration: '6 min',
                videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
                isFeatured: false,
                reviewedBy: 'Women\'s Endocrinology Panel',
                isSaved: true,
                takeaways: [
                  {
                    'title': 'Whole-person approach',
                    'body': 'PCOS touches sleep, metabolic energy, and emotional state; small compassionate routines matter.'
                  }
                ],
              ),
              AwarenessItem(
                id: 'aware_4',
                title: 'Micro-movement for sustained energy',
                subtitle: 'Sustainable 10-minute movement snacks that fit easily into seated desk schedules.',
                category: 'Movement',
                duration: '3 min',
                videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
                isFeatured: false,
                reviewedBy: 'Physical Therapy Specialist',
                isSaved: false,
                takeaways: [
                  {
                    'title': 'Gentle mobilization',
                    'body': 'Frequent light walking beats high intensity exhaustion when recovering from poor sleep.'
                  }
                ],
              ),
            ],
          ),
        );

  void setCategory(String cat) {
    state = state.copyWith(selectedCategory: cat);
  }

  void toggleSave(String id) {
    state = state.copyWith(
      items: state.items.map((i) {
        if (i.id == id) {
          return i.copyWith(isSaved: !i.isSaved);
        }
        return i;
      }).toList(),
    );
    try {
      _apiClient.post('${ApiEndpoints.awareness}/$id/save');
    } catch (_) {}
  }
}

final awarenessProvider = StateNotifierProvider<AwarenessNotifier, AwarenessState>((ref) {
  return AwarenessNotifier();
});
