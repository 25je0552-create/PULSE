class ApiEndpoints {
  static const String health = '/health';
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String me = '/auth/me';

  static const String patientProfile = '/patient/profile';
  static const String patientBaseline = '/patient/baseline';
  static const String patientHome = '/patient/home';

  static const String checkins = '/checkins';
  static const String checkinsHistory = '/checkins/history';
  static const String progress = '/checkins/progress';

  static const String aiChat = '/ai/chat';
  static const String aiChatHistory = '/ai/chat/history';
  static const String aiInsight = '/ai/insight';
  static const String aiSummary = '/ai/summary';

  static const String goals = '/goals';
  static const String goalsActive = '/goals/active';
  static const String goalsAdapt = '/goals/adapt';

  static const String careOverview = '/care/overview';
  static const String careDoctor = '/care/doctor';
  static const String careConnectDoctor = '/care/doctor/connect';
  static const String appointments = '/care/appointments';
  static const String appointmentQuestions = '/care/appointments/questions';
  static const String preConsult = '/care/pre-consult';
  static const String preConsultApprove = '/care/pre-consult/approve';

  static const String awareness = '/awareness';
  static const String records = '/records';
  static const String family = '/family';
  static const String familyInvite = '/family/invite';
  static const String familyPermissions = '/family/permissions';

  static const String wellbeing = '/wellbeing';
  static const String wellbeingReflection = '/wellbeing/reflection';
  static const String safetyHelplines = '/safety/trusted-contact';

  static const String docTalkCareTypes = '/doctalk/care-types';
  static const String docTalkProfessionals = '/doctalk/professionals';
  static const String docTalkOfferEligibility = '/doctalk/offer-eligibility';
  static const String docTalkBook = '/doctalk/book';
  static const String docTalkAppointments = '/doctalk/appointments';
  static const String docTalkCarePlans = '/doctalk/care-plans';
}
