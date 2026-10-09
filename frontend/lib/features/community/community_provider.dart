import 'package:flutter_riverpod/legacy.dart';

class CommunityPost {
  final String id;
  final String authorHandle;
  final String category;
  final String title;
  final String content;
  final String timeAgo;
  final int likes;
  final int repliesCount;
  final bool isLiked;
  final bool isBookmarked;
  final bool isPinned;

  const CommunityPost({
    required this.id,
    required this.authorHandle,
    required this.category,
    required this.title,
    required this.content,
    required this.timeAgo,
    this.likes = 0,
    this.repliesCount = 0,
    this.isLiked = false,
    this.isBookmarked = false,
    this.isPinned = false,
  });

  CommunityPost copyWith({
    int? likes,
    int? repliesCount,
    bool? isLiked,
    bool? isBookmarked,
  }) {
    return CommunityPost(
      id: id,
      authorHandle: authorHandle,
      category: category,
      title: title,
      content: content,
      timeAgo: timeAgo,
      likes: likes ?? this.likes,
      repliesCount: repliesCount ?? this.repliesCount,
      isLiked: isLiked ?? this.isLiked,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isPinned: isPinned,
    );
  }
}

class CommunityState {
  final bool isPremiumUnlocked;
  final String selectedCategory;
  final List<String> categories;
  final List<CommunityPost> posts;
  final bool guidelinesAccepted;

  const CommunityState({
    this.isPremiumUnlocked = false,
    this.selectedCategory = 'All',
    this.categories = const ['All', 'Sleep & Rest', 'Pacing & Stress', 'Care Conversations', 'Gentle Wins'],
    this.posts = const [],
    this.guidelinesAccepted = false,
  });

  CommunityState copyWith({
    bool? isPremiumUnlocked,
    String? selectedCategory,
    List<CommunityPost>? posts,
    bool? guidelinesAccepted,
  }) {
    return CommunityState(
      isPremiumUnlocked: isPremiumUnlocked ?? this.isPremiumUnlocked,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      categories: categories,
      posts: posts ?? this.posts,
      guidelinesAccepted: guidelinesAccepted ?? this.guidelinesAccepted,
    );
  }
}

class CommunityNotifier extends StateNotifier<CommunityState> {
  CommunityNotifier() : super(const CommunityState()) {
    _loadInitialPosts();
  }

  void _loadInitialPosts() {
    state = state.copyWith(
      posts: [
        const CommunityPost(
          id: 'comm_1',
          authorHandle: 'Moderator_DrElena',
          category: 'Pacing & Stress',
          title: 'Welcome to Pulse Community: Safe, anonymous peer support',
          content: 'This space is strictly peer-to-peer encouragement and lived-experience sharing. Please remember this does not replace medical consultation with your care team.',
          timeAgo: 'Pinned',
          likes: 42,
          repliesCount: 8,
          isPinned: true,
        ),
        const CommunityPost(
          id: 'comm_2',
          authorHandle: 'GentlePacer44',
          category: 'Sleep & Rest',
          title: 'Anyone else notice evening wind-down works better without screens?',
          content: 'I switched my 10pm routine to 15 minutes of dim-light reading and simple breath tracking. My restorative sleep scores improved noticeably this week.',
          timeAgo: '2h ago',
          likes: 18,
          repliesCount: 5,
        ),
        const CommunityPost(
          id: 'comm_3',
          authorHandle: 'SteadyRhythm',
          category: 'Care Conversations',
          title: 'Sharing the Pre-Consult briefing made my appointment so much smoother',
          content: 'Instead of forgetting all my symptoms from the past month, my doctor had the digest ready. We actually talked about practical solutions instead of repeating history.',
          timeAgo: '4h ago',
          likes: 29,
          repliesCount: 7,
        ),
        const CommunityPost(
          id: 'comm_4',
          authorHandle: 'MindfulWalker',
          category: 'Gentle Wins',
          title: 'Hit 4 consecutive days of morning pacing!',
          content: 'Even just 10 minutes makes a real difference in keeping my energy steady through the afternoon.',
          timeAgo: 'Yesterday',
          likes: 31,
          repliesCount: 4,
        ),
      ],
    );
  }

  void setCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  void toggleLike(String postId) {
    state = state.copyWith(
      posts: state.posts.map((p) {
        if (p.id == postId) {
          final isLiked = !p.isLiked;
          return p.copyWith(
            isLiked: isLiked,
            likes: isLiked ? p.likes + 1 : p.likes - 1,
          );
        }
        return p;
      }).toList(),
    );
  }

  void toggleBookmark(String postId) {
    state = state.copyWith(
      posts: state.posts.map((p) {
        if (p.id == postId) {
          return p.copyWith(isBookmarked: !p.isBookmarked);
        }
        return p;
      }).toList(),
    );
  }

  void unlockPremium() {
    state = state.copyWith(isPremiumUnlocked: true);
  }

  void acceptGuidelines() {
    state = state.copyWith(guidelinesAccepted: true);
  }

  void addPost({required String title, required String content, required String category}) {
    final newPost = CommunityPost(
      id: 'comm_${DateTime.now().millisecondsSinceEpoch}',
      authorHandle: 'You_Anonymous',
      category: category,
      title: title,
      content: content,
      timeAgo: 'Just now',
      likes: 1,
      repliesCount: 0,
      isLiked: true,
    );
    state = state.copyWith(posts: [newPost, ...state.posts]);
  }
}

final communityProvider = StateNotifierProvider<CommunityNotifier, CommunityState>((ref) {
  return CommunityNotifier();
});
