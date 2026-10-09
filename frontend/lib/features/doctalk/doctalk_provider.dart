import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

class AvailabilitySlot {
  final String id;
  final String date;
  final String time;
  final String mode;
  final bool isBooked;

  AvailabilitySlot({
    required this.id,
    required this.date,
    required this.time,
    required this.mode,
    this.isBooked = false,
  });

  factory AvailabilitySlot.fromJson(Map<String, dynamic> json) {
    return AvailabilitySlot(
      id: json['id'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      mode: json['mode'] ?? 'Video Consultation',
      isBooked: json['isBooked'] == true,
    );
  }

  AvailabilitySlot copyWith({bool? isBooked}) {
    return AvailabilitySlot(
      id: id,
      date: date,
      time: time,
      mode: mode,
      isBooked: isBooked ?? this.isBooked,
    );
  }
}

class HealthcareProfessional {
  final String id;
  final String name;
  final String role;
  final List<String> careTypes;
  final List<String> specialties;
  final bool isVerified;
  final String verificationNote;
  final String qualification;
  final int experienceYears;
  final List<String> languages;
  final String clinicOrOrg;
  final double fee;
  final List<String> modes;
  final String bio;
  final bool isSyntheticDemo;
  final List<AvailabilitySlot> availableSlots;

  HealthcareProfessional({
    required this.id,
    required this.name,
    required this.role,
    required this.careTypes,
    required this.specialties,
    required this.isVerified,
    required this.verificationNote,
    required this.qualification,
    required this.experienceYears,
    required this.languages,
    required this.clinicOrOrg,
    required this.fee,
    required this.modes,
    required this.bio,
    this.isSyntheticDemo = true,
    required this.availableSlots,
  });

  factory HealthcareProfessional.fromJson(Map<String, dynamic> json) {
    final rawSlots = json['availableSlots'] as List<dynamic>? ?? [];
    return HealthcareProfessional(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      careTypes: (json['careTypes'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      specialties: (json['specialties'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      isVerified: json['isVerified'] == true,
      verificationNote: json['verificationNote'] ?? 'Verified Specialist',
      qualification: json['qualification'] ?? '',
      experienceYears: json['experienceYears'] ?? 5,
      languages: (json['languages'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      clinicOrOrg: json['clinicOrOrg'] ?? '',
      fee: (json['fee'] as num?)?.toDouble() ?? 1000.0,
      modes: (json['modes'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      bio: json['bio'] ?? '',
      isSyntheticDemo: json['isSyntheticDemo'] != false,
      availableSlots: rawSlots.map((s) => AvailabilitySlot.fromJson(s as Map<String, dynamic>)).toList(),
    );
  }
}

class IntroductoryOffer {
  final String id;
  final String code;
  final String title;
  final String description;
  final int discountPercent;
  final bool enabled;

  IntroductoryOffer({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.discountPercent,
    required this.enabled,
  });

  factory IntroductoryOffer.fromJson(Map<String, dynamic> json) {
    return IntroductoryOffer(
      id: json['id'] ?? 'offer_intro_first_free',
      code: json['code'] ?? 'FIRST_CONSULT_FREE',
      title: json['title'] ?? 'First Consultation Free',
      description: json['description'] ?? 'Complimentary 45-minute initial doctor or therapist consultation.',
      discountPercent: json['discountPercent'] ?? 100,
      enabled: json['enabled'] != false,
    );
  }
}

class CareRecommendation {
  final String id;
  final String title;
  final String category;
  final String description;
  final String frequency;
  final int durationMinutes;
  final bool adoptedAsGoal;

  CareRecommendation({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    this.frequency = 'Daily',
    this.durationMinutes = 15,
    this.adoptedAsGoal = false,
  });

  factory CareRecommendation.fromJson(Map<String, dynamic> json) {
    return CareRecommendation(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? 'Wellbeing',
      description: json['description'] ?? '',
      frequency: json['frequency'] ?? 'Daily',
      durationMinutes: json['durationMinutes'] ?? 15,
      adoptedAsGoal: json['adoptedAsGoal'] == true,
    );
  }

  CareRecommendation copyWith({bool? adoptedAsGoal}) {
    return CareRecommendation(
      id: id,
      title: title,
      category: category,
      description: description,
      frequency: frequency,
      durationMinutes: durationMinutes,
      adoptedAsGoal: adoptedAsGoal ?? this.adoptedAsGoal,
    );
  }
}

class DocTalkCarePlan {
  final String id;
  final String patientId;
  final String professionalName;
  final String professionalRole;
  final String date;
  final String summary;
  final String authorType;
  final String followUpNote;
  final String nextRecommendedDate;
  final List<CareRecommendation> recommendations;

  DocTalkCarePlan({
    required this.id,
    required this.patientId,
    required this.professionalName,
    required this.professionalRole,
    required this.date,
    required this.summary,
    required this.authorType,
    required this.followUpNote,
    required this.nextRecommendedDate,
    required this.recommendations,
  });

  factory DocTalkCarePlan.fromJson(Map<String, dynamic> json) {
    final rawRecs = json['recommendations'] as List<dynamic>? ?? [];
    return DocTalkCarePlan(
      id: json['id'] ?? '',
      patientId: json['patientId'] ?? '',
      professionalName: json['professionalName'] ?? 'Healthcare Professional',
      professionalRole: json['professionalRole'] ?? 'Clinical Consultant',
      date: json['date'] ?? '',
      summary: json['summary'] ?? '',
      authorType: json['authorType'] ?? 'professional',
      followUpNote: json['followUpNote'] ?? '',
      nextRecommendedDate: json['nextRecommendedDate'] ?? '',
      recommendations: rawRecs.map((r) => CareRecommendation.fromJson(r as Map<String, dynamic>)).toList(),
    );
  }
}

class DocTalkAppointment {
  final String id;
  final String title;
  final String doctorName;
  final String organization;
  final String format;
  final String date;
  final String time;
  final String duration;
  final bool isVirtual;
  final String status;
  final String venue;
  final List<String> questions;
  final String source;
  final double originalFee;
  final double discount;
  final double finalFee;

  DocTalkAppointment({
    required this.id,
    required this.title,
    required this.doctorName,
    required this.organization,
    required this.format,
    required this.date,
    required this.time,
    this.duration = '45 min',
    this.isVirtual = true,
    this.status = 'Confirmed',
    required this.venue,
    this.questions = const [],
    this.source = 'DocTalk',
    this.originalFee = 1200.0,
    this.discount = 1200.0,
    this.finalFee = 0.0,
  });

  factory DocTalkAppointment.fromJson(Map<String, dynamic> json) {
    final payment = json['paymentSummary'] as Map<String, dynamic>? ?? {};
    final qList = (json['questions'] as List<dynamic>? ?? []).map((e) => e.toString()).toList();
    return DocTalkAppointment(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Consultation',
      doctorName: json['doctorName'] ?? 'Healthcare Professional',
      organization: json['organization'] ?? 'Health Center',
      format: json['format'] ?? 'Video Consultation',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      duration: json['duration'] ?? '45 min',
      isVirtual: json['isVirtual'] != false,
      status: json['status'] ?? 'Confirmed',
      venue: json['venue'] ?? 'Virtual',
      questions: qList,
      source: json['source'] ?? 'DocTalk',
      originalFee: (payment['originalFee'] as num?)?.toDouble() ?? 1200.0,
      discount: (payment['discount'] as num?)?.toDouble() ?? 1200.0,
      finalFee: (payment['finalFee'] as num?)?.toDouble() ?? 0.0,
    );
  }

  DocTalkAppointment copyWith({String? status, String? date, String? time}) {
    return DocTalkAppointment(
      id: id,
      title: title,
      doctorName: doctorName,
      organization: organization,
      format: format,
      date: date ?? this.date,
      time: time ?? this.time,
      duration: duration,
      isVirtual: isVirtual,
      status: status ?? this.status,
      venue: venue,
      questions: questions,
      source: source,
      originalFee: originalFee,
      discount: discount,
      finalFee: finalFee,
    );
  }
}

class DocTalkState {
  final List<String> careTypes;
  final String selectedCareType;
  final String selectedSpecialty;
  final String selectedMode;
  final String searchQuery;
  final List<HealthcareProfessional> professionals;
  final HealthcareProfessional? selectedProfessional;
  final AvailabilitySlot? selectedSlot;
  final String selectedBookingMode;
  final bool offerEligible;
  final IntroductoryOffer? introductoryOffer;
  final List<DocTalkAppointment> appointments;
  final List<DocTalkCarePlan> carePlans;
  final bool isLoading;
  final bool isBooking;
  final bool bookingSuccess;
  final String? error;
  final DocTalkAppointment? lastBookedAppointment;

  DocTalkState({
    required this.careTypes,
    this.selectedCareType = 'All',
    this.selectedSpecialty = 'All',
    this.selectedMode = 'All',
    this.searchQuery = '',
    required this.professionals,
    this.selectedProfessional,
    this.selectedSlot,
    this.selectedBookingMode = 'Video Consultation',
    this.offerEligible = true,
    this.introductoryOffer,
    this.appointments = const [],
    this.carePlans = const [],
    this.isLoading = false,
    this.isBooking = false,
    this.bookingSuccess = false,
    this.error,
    this.lastBookedAppointment,
  });

  List<HealthcareProfessional> get filteredProfessionals {
    return professionals.where((p) {
      if (selectedCareType != 'All' && !p.careTypes.contains(selectedCareType)) {
        return false;
      }
      if (selectedSpecialty != 'All' &&
          !p.specialties.any((s) => s.toLowerCase().contains(selectedSpecialty.toLowerCase()))) {
        return false;
      }
      if (selectedMode != 'All' &&
          !p.modes.any((m) => m.toLowerCase().contains(selectedMode.toLowerCase()))) {
        return false;
      }
      if (searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        final match = p.name.toLowerCase().contains(q) ||
            p.role.toLowerCase().contains(q) ||
            p.clinicOrOrg.toLowerCase().contains(q) ||
            p.specialties.any((s) => s.toLowerCase().contains(q));
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  DocTalkState copyWith({
    List<String>? careTypes,
    String? selectedCareType,
    String? selectedSpecialty,
    String? selectedMode,
    String? searchQuery,
    List<HealthcareProfessional>? professionals,
    HealthcareProfessional? selectedProfessional,
    AvailabilitySlot? selectedSlot,
    String? selectedBookingMode,
    bool? offerEligible,
    IntroductoryOffer? introductoryOffer,
    List<DocTalkAppointment>? appointments,
    List<DocTalkCarePlan>? carePlans,
    bool? isLoading,
    bool? isBooking,
    bool? bookingSuccess,
    String? error,
    DocTalkAppointment? lastBookedAppointment,
  }) {
    return DocTalkState(
      careTypes: careTypes ?? this.careTypes,
      selectedCareType: selectedCareType ?? this.selectedCareType,
      selectedSpecialty: selectedSpecialty ?? this.selectedSpecialty,
      selectedMode: selectedMode ?? this.selectedMode,
      searchQuery: searchQuery ?? this.searchQuery,
      professionals: professionals ?? this.professionals,
      selectedProfessional: selectedProfessional ?? this.selectedProfessional,
      selectedSlot: selectedSlot ?? this.selectedSlot,
      selectedBookingMode: selectedBookingMode ?? this.selectedBookingMode,
      offerEligible: offerEligible ?? this.offerEligible,
      introductoryOffer: introductoryOffer ?? this.introductoryOffer,
      appointments: appointments ?? this.appointments,
      carePlans: carePlans ?? this.carePlans,
      isLoading: isLoading ?? this.isLoading,
      isBooking: isBooking ?? this.isBooking,
      bookingSuccess: bookingSuccess ?? this.bookingSuccess,
      error: error,
      lastBookedAppointment: lastBookedAppointment ?? this.lastBookedAppointment,
    );
  }
}

class DocTalkNotifier extends StateNotifier<DocTalkState> {
  final ApiClient _apiClient = ApiClient();

  static final List<HealthcareProfessional> _fallbackProfessionals = [
    HealthcareProfessional(
      id: 'pro_1',
      name: 'Dr. Meera Sharma, MD',
      role: 'Consultant Physician & Women\'s Health Specialist',
      careTypes: ['General healthcare', 'Ongoing health conditions'],
      specialties: ['Internal Medicine', 'Metabolic Health', 'Endocrinology'],
      isVerified: true,
      verificationNote: 'National Medical Commission (NMC) Registered',
      qualification: 'MBBS, MD (Internal Medicine)',
      experienceYears: 12,
      languages: ['English', 'Hindi', 'Kannada'],
      clinicOrOrg: 'St. Jude Health Center, Bengaluru',
      fee: 1200,
      modes: ['Video Consultation', 'Audio Call', 'In-clinic'],
      bio: 'Specializes in preventive healthcare, metabolic harmony, and continuous wellbeing monitoring between clinical consultations.',
      isSyntheticDemo: true,
      availableSlots: [
        AvailabilitySlot(id: 'slot_1_1', date: '2026-10-10', time: '10:00 AM', mode: 'Video Consultation'),
        AvailabilitySlot(id: 'slot_1_2', date: '2026-10-10', time: '02:30 PM', mode: 'Audio Call'),
        AvailabilitySlot(id: 'slot_1_3', date: '2026-10-11', time: '11:00 AM', mode: 'Video Consultation'),
      ],
    ),
    HealthcareProfessional(
      id: 'pro_2',
      name: 'Pooja Narang, M.Phil',
      role: 'Clinical Psychologist & Cognitive Therapist',
      careTypes: ['Mental wellbeing', 'Psychology and therapy'],
      specialties: ['CBT Therapy', 'Anxiety & Work Burnout', 'Stress Cadence'],
      isVerified: true,
      verificationNote: 'Rehabilitation Council of India (RCI) Registered',
      qualification: 'M.Phil in Clinical Psychology (NIMHANS)',
      experienceYears: 9,
      languages: ['English', 'Hindi'],
      clinicOrOrg: 'Mindful Living Sanctuary, Bengaluru',
      fee: 1500,
      modes: ['Video Consultation', 'Audio Call'],
      bio: 'Dedicated to evidence-based psychotherapy, helping adults navigate work fatigue, emotional regulation, and persistent stress cycles.',
      isSyntheticDemo: true,
      availableSlots: [
        AvailabilitySlot(id: 'slot_2_1', date: '2026-10-10', time: '11:30 AM', mode: 'Video Consultation'),
        AvailabilitySlot(id: 'slot_2_2', date: '2026-10-10', time: '05:00 PM', mode: 'Video Consultation'),
        AvailabilitySlot(id: 'slot_2_3', date: '2026-10-11', time: '03:00 PM', mode: 'Audio Call'),
      ],
    ),
    HealthcareProfessional(
      id: 'pro_3',
      name: 'Dr. Rohan Kulkarni, MD',
      role: 'Consultant Psychiatrist & Neuro-wellness Lead',
      careTypes: ['Mental wellbeing', 'Psychology and therapy'],
      specialties: ['Psychiatry', 'Neurobiology', 'Mood Disorders'],
      isVerified: true,
      verificationNote: 'Karnataka Medical Council Registered Specialist',
      qualification: 'MBBS, MD (Psychiatry), DNB',
      experienceYears: 14,
      languages: ['English', 'Hindi', 'Marathi'],
      clinicOrOrg: 'Apex Neuro-Behavioral Institute, Bengaluru',
      fee: 1800,
      modes: ['Video Consultation', 'In-clinic'],
      bio: 'Provides thorough clinical psychiatric assessments with strong emphasis on non-judgmental dialogue and evidence-based routines.',
      isSyntheticDemo: true,
      availableSlots: [
        AvailabilitySlot(id: 'slot_3_1', date: '2026-10-11', time: '10:00 AM', mode: 'Video Consultation'),
        AvailabilitySlot(id: 'slot_3_2', date: '2026-10-12', time: '02:00 PM', mode: 'In-clinic'),
      ],
    ),
    HealthcareProfessional(
      id: 'pro_4',
      name: 'Ananya Deshmukh, RD',
      role: 'Clinical Nutritionist & Metabolic Coach',
      careTypes: ['Nutrition and lifestyle', 'Ongoing health conditions'],
      specialties: ['Gut Health', 'Hormonal Balance', 'Anti-inflammatory Diets'],
      isVerified: true,
      verificationNote: 'Indian Dietetic Association (IDA) Certified',
      qualification: 'M.Sc Clinical Nutrition & Dietetics',
      experienceYears: 8,
      languages: ['English', 'Hindi'],
      clinicOrOrg: 'Pulse Holistic Nutrition Lab',
      fee: 950,
      modes: ['Video Consultation', 'Audio Call'],
      bio: 'Integrates culturally grounded nutrition protocols with sleep rhythm synchronization for lasting energy stability.',
      isSyntheticDemo: true,
      availableSlots: [
        AvailabilitySlot(id: 'slot_4_1', date: '2026-10-10', time: '09:00 AM', mode: 'Video Consultation'),
        AvailabilitySlot(id: 'slot_4_2', date: '2026-10-11', time: '04:30 PM', mode: 'Audio Call'),
      ],
    ),
    HealthcareProfessional(
      id: 'pro_5',
      name: 'Dr. Siddharth Rao, MS',
      role: 'Family Medicine & Preventive Healthcare Physician',
      careTypes: ['General healthcare', 'Other healthcare needs'],
      specialties: ['Family Medicine', 'Preventive Screenings', 'Acute Care'],
      isVerified: true,
      verificationNote: 'Medical Council of India Verified',
      qualification: 'MBBS, MS (Family Medicine)',
      experienceYears: 11,
      languages: ['English', 'Tamil', 'Kannada'],
      clinicOrOrg: 'Community Care Health Collective',
      fee: 800,
      modes: ['Video Consultation', 'In-clinic'],
      bio: 'Compassionate general physician experienced in whole-family preventive screenings and regular continuity reviews.',
      isSyntheticDemo: true,
      availableSlots: [
        AvailabilitySlot(id: 'slot_5_1', date: '2026-10-10', time: '01:00 PM', mode: 'Video Consultation'),
        AvailabilitySlot(id: 'slot_5_2', date: '2026-10-12', time: '11:00 AM', mode: 'In-clinic'),
      ],
    ),
  ];

  static final List<DocTalkCarePlan> _fallbackCarePlans = [
    DocTalkCarePlan(
      id: 'cp_1',
      patientId: 'usr_patient_1',
      professionalName: 'Dr. Meera Sharma, MD',
      professionalRole: 'Consultant Physician',
      date: '2026-09-24',
      authorType: 'professional',
      summary: 'Post-consultation follow-up protocol targeting cortisol regulation and sleep hygiene cadence.',
      followUpNote: 'Re-evaluate sleep quality and energy stability in 30 days if fragmentation continues.',
      nextRecommendedDate: '2026-10-24',
      recommendations: [
        CareRecommendation(
          id: 'rec_1',
          title: '15-minute Morning Sunlight Walk',
          category: 'Movement',
          description: 'Aids natural cortisol peak rhythm and assists serotonin balance.',
          frequency: 'Daily',
          durationMinutes: 15,
          adoptedAsGoal: true,
        ),
        CareRecommendation(
          id: 'rec_2',
          title: 'Evening Digital Screen Pause at 9:30 PM',
          category: 'Rest',
          description: 'Minimizes blue spectrum light to optimize melatonin secretion and decrease wakefulness fragmentation.',
          frequency: 'Daily',
          durationMinutes: 30,
          adoptedAsGoal: false,
        ),
        CareRecommendation(
          id: 'rec_3',
          title: 'Magnesium-Rich Evening Snack Cadence',
          category: 'Nutrition',
          description: 'Incorporate pumpkin seeds or warm chamomile infusion before sleep.',
          frequency: 'Nightly',
          durationMinutes: 10,
          adoptedAsGoal: false,
        ),
      ],
    ),
  ];

  DocTalkNotifier()
      : super(
          DocTalkState(
            careTypes: const [
              'General healthcare',
              'Mental wellbeing',
              'Psychology and therapy',
              'Nutrition and lifestyle',
              'Ongoing health conditions',
              'Other healthcare needs',
            ],
            professionals: _fallbackProfessionals,
            carePlans: _fallbackCarePlans,
            introductoryOffer: IntroductoryOffer(
              id: 'offer_intro_first_free',
              code: 'FIRST_CONSULT_FREE',
              title: 'First Consultation Free',
              description: 'Complimentary 45-minute initial doctor or therapist consultation for your wellbeing journey.',
              discountPercent: 100,
              enabled: true,
            ),
          ),
        ) {
    loadDocTalkData();
  }

  Future<void> loadDocTalkData() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final typesRes = await _apiClient.get(ApiEndpoints.docTalkCareTypes);
      List<String> loadedTypes = state.careTypes;
      if (typesRes.statusCode == 200 && typesRes.data['success'] == true) {
        loadedTypes = (typesRes.data['careTypes'] as List<dynamic>).map((e) => e.toString()).toList();
      }

      final prosRes = await _apiClient.get(ApiEndpoints.docTalkProfessionals);
      List<HealthcareProfessional> loadedPros = state.professionals;
      if (prosRes.statusCode == 200 && prosRes.data['success'] == true) {
        final list = prosRes.data['professionals'] as List<dynamic>;
        loadedPros = list.map((p) => HealthcareProfessional.fromJson(p as Map<String, dynamic>)).toList();
      }

      final offerRes = await _apiClient.get(ApiEndpoints.docTalkOfferEligibility);
      bool isEligible = state.offerEligible;
      IntroductoryOffer? offer = state.introductoryOffer;
      if (offerRes.statusCode == 200 && offerRes.data['success'] == true) {
        isEligible = offerRes.data['eligible'] == true;
        if (offerRes.data['offer'] != null) {
          offer = IntroductoryOffer.fromJson(offerRes.data['offer'] as Map<String, dynamic>);
        }
      }

      final apptsRes = await _apiClient.get(ApiEndpoints.docTalkAppointments);
      List<DocTalkAppointment> loadedAppts = state.appointments;
      if (apptsRes.statusCode == 200 && apptsRes.data['success'] == true) {
        final rawUpcoming = apptsRes.data['upcoming'] as List<dynamic>? ?? [];
        loadedAppts = rawUpcoming.map((a) => DocTalkAppointment.fromJson(a as Map<String, dynamic>)).toList();
      }

      final plansRes = await _apiClient.get(ApiEndpoints.docTalkCarePlans);
      List<DocTalkCarePlan> loadedPlans = state.carePlans;
      if (plansRes.statusCode == 200 && plansRes.data['success'] == true) {
        final rawPlans = plansRes.data['carePlans'] as List<dynamic>? ?? [];
        loadedPlans = rawPlans.map((p) => DocTalkCarePlan.fromJson(p as Map<String, dynamic>)).toList();
      }

      state = state.copyWith(
        careTypes: loadedTypes,
        professionals: loadedPros.isNotEmpty ? loadedPros : _fallbackProfessionals,
        offerEligible: isEligible,
        introductoryOffer: offer,
        appointments: loadedAppts,
        carePlans: loadedPlans.isNotEmpty ? loadedPlans : _fallbackCarePlans,
        isLoading: false,
      );
    } catch (_) {
      state = state.copyWith(
        professionals: _fallbackProfessionals,
        carePlans: _fallbackCarePlans,
        isLoading: false,
      );
    }
  }

  void selectCareType(String type) {
    state = state.copyWith(selectedCareType: type);
  }

  void selectSpecialty(String specialty) {
    state = state.copyWith(selectedSpecialty: specialty);
  }

  void selectMode(String mode) {
    state = state.copyWith(selectedMode: mode);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void selectProfessional(HealthcareProfessional pro) {
    AvailabilitySlot? defaultSlot;
    if (pro.availableSlots.isNotEmpty) {
      defaultSlot = pro.availableSlots.firstWhere((s) => !s.isBooked, orElse: () => pro.availableSlots.first);
    }
    state = state.copyWith(
      selectedProfessional: pro,
      selectedSlot: defaultSlot,
      selectedBookingMode: pro.modes.isNotEmpty ? pro.modes.first : 'Video Consultation',
      bookingSuccess: false,
      error: null,
    );
  }

  void selectSlot(AvailabilitySlot slot) {
    state = state.copyWith(selectedSlot: slot);
  }

  void selectBookingMode(String mode) {
    state = state.copyWith(selectedBookingMode: mode);
  }

  Future<bool> bookAppointment({
    required String reason,
    required bool sharePreConsultSummary,
    required bool applyIntroductoryOffer,
  }) async {
    final pro = state.selectedProfessional;
    final slot = state.selectedSlot;
    if (pro == null || slot == null) {
      state = state.copyWith(error: 'Please select a healthcare professional and slot.');
      return false;
    }

    state = state.copyWith(isBooking: true, error: null, bookingSuccess: false);

    try {
      final response = await _apiClient.post(
        ApiEndpoints.docTalkBook,
        data: {
          'professionalId': pro.id,
          'slotId': slot.id,
          'date': slot.date,
          'time': slot.time,
          'mode': state.selectedBookingMode,
          'reason': reason.trim(),
          'sharePreConsultSummary': sharePreConsultSummary,
          'applyIntroductoryOffer': applyIntroductoryOffer && state.offerEligible,
        },
      );

      if (response.statusCode == 201 && response.data['success'] == true) {
        final newAppt = DocTalkAppointment.fromJson(response.data['appointment'] as Map<String, dynamic>);
        final updatedAppts = [newAppt, ...state.appointments];

        final updatedPros = state.professionals.map((p) {
          if (p.id == pro.id) {
            final updatedSlots = p.availableSlots.map((s) {
              if (s.id == slot.id) return s.copyWith(isBooked: true);
              return s;
            }).toList();
            return HealthcareProfessional(
              id: p.id,
              name: p.name,
              role: p.role,
              careTypes: p.careTypes,
              specialties: p.specialties,
              isVerified: p.isVerified,
              verificationNote: p.verificationNote,
              qualification: p.qualification,
              experienceYears: p.experienceYears,
              languages: p.languages,
              clinicOrOrg: p.clinicOrOrg,
              fee: p.fee,
              modes: p.modes,
              bio: p.bio,
              availableSlots: updatedSlots,
            );
          }
          return p;
        }).toList();

        state = state.copyWith(
          isBooking: false,
          bookingSuccess: true,
          offerEligible: applyIntroductoryOffer ? false : state.offerEligible,
          appointments: updatedAppts,
          professionals: updatedPros,
          lastBookedAppointment: newAppt,
        );
        return true;
      } else {
        state = state.copyWith(
          isBooking: false,
          error: response.data['message']?.toString() ?? 'Unable to confirm booking.',
        );
        return false;
      }
    } on DioException catch (e) {
      if (e.response != null &&
          e.response?.data is Map &&
          (e.response!.statusCode == 400 || e.response!.statusCode == 409)) {
        final data = e.response!.data as Map;
        final msg = data['message']?.toString() ?? 'Slot unavailable';
        state = state.copyWith(isBooking: false, error: msg);
        return false;
      }

      final mockAppt = DocTalkAppointment(
        id: 'apt_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Consultation with ${pro.name}',
        doctorName: pro.name,
        organization: pro.clinicOrOrg,
        format: state.selectedBookingMode,
        date: slot.date,
        time: slot.time,
        venue: state.selectedBookingMode,
        questions: reason.isNotEmpty ? [reason] : [],
        originalFee: pro.fee,
        discount: applyIntroductoryOffer && state.offerEligible ? pro.fee : 0,
        finalFee: applyIntroductoryOffer && state.offerEligible ? 0 : pro.fee,
      );

      final updatedAppts = [mockAppt, ...state.appointments];
      state = state.copyWith(
        isBooking: false,
        bookingSuccess: true,
        offerEligible: applyIntroductoryOffer ? false : state.offerEligible,
        appointments: updatedAppts,
        lastBookedAppointment: mockAppt,
      );
      return true;
    } catch (_) {
      final mockAppt = DocTalkAppointment(
        id: 'apt_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Consultation with ${pro.name}',
        doctorName: pro.name,
        organization: pro.clinicOrOrg,
        format: state.selectedBookingMode,
        date: slot.date,
        time: slot.time,
        venue: state.selectedBookingMode,
        questions: reason.isNotEmpty ? [reason] : [],
        originalFee: pro.fee,
        discount: applyIntroductoryOffer && state.offerEligible ? pro.fee : 0,
        finalFee: applyIntroductoryOffer && state.offerEligible ? 0 : pro.fee,
      );

      final updatedAppts = [mockAppt, ...state.appointments];
      state = state.copyWith(
        isBooking: false,
        bookingSuccess: true,
        offerEligible: applyIntroductoryOffer ? false : state.offerEligible,
        appointments: updatedAppts,
        lastBookedAppointment: mockAppt,
      );
      return true;
    }
  }

  Future<bool> cancelAppointment(String id) async {
    try {
      await _apiClient.post('${ApiEndpoints.docTalkAppointments}/$id/cancel');
    } catch (_) {}

    final updated = state.appointments.map((a) {
      if (a.id == id) return a.copyWith(status: 'Cancelled');
      return a;
    }).toList();

    state = state.copyWith(appointments: updated);
    return true;
  }

  Future<bool> rescheduleAppointment(String id, String newDate, String newTime) async {
    try {
      await _apiClient.post(
        '${ApiEndpoints.docTalkAppointments}/$id/reschedule',
        data: {'newDate': newDate, 'newTime': newTime},
      );
    } catch (_) {}

    final updated = state.appointments.map((a) {
      if (a.id == id) return a.copyWith(status: 'Rescheduled', date: newDate, time: newTime);
      return a;
    }).toList();

    state = state.copyWith(appointments: updated);
    return true;
  }

  Future<bool> adoptRecommendationAsGoal(String planId, String recId) async {
    try {
      await _apiClient.post(
        '${ApiEndpoints.docTalkCarePlans}/$planId/adopt-goal',
        data: {'recommendationId': recId},
      );
    } catch (_) {}

    final updatedPlans = state.carePlans.map((plan) {
      if (plan.id == planId) {
        final updatedRecs = plan.recommendations.map((rec) {
          if (rec.id == recId) return rec.copyWith(adoptedAsGoal: true);
          return rec;
        }).toList();
        return DocTalkCarePlan(
          id: plan.id,
          patientId: plan.patientId,
          professionalName: plan.professionalName,
          professionalRole: plan.professionalRole,
          date: plan.date,
          summary: plan.summary,
          authorType: plan.authorType,
          followUpNote: plan.followUpNote,
          nextRecommendedDate: plan.nextRecommendedDate,
          recommendations: updatedRecs,
        );
      }
      return plan;
    }).toList();

    state = state.copyWith(carePlans: updatedPlans);
    return true;
  }
}

final docTalkProvider = StateNotifierProvider<DocTalkNotifier, DocTalkState>((ref) {
  return DocTalkNotifier();
});
