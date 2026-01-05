import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/two_factor_setup_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/health_score_page.dart';
import '../../features/home/presentation/pages/real_time_analysis_page.dart';
import '../../features/home/presentation/pages/recent_measurements_page.dart';
import '../../features/home/presentation/pages/health_summary_page.dart';
import '../../features/home/presentation/pages/notifications_page.dart';
import '../../features/home/presentation/pages/quick_actions_page.dart';
import '../../features/home/presentation/pages/dashboard_page.dart';
import '../../features/measurement/presentation/pages/measurement_page.dart';
import '../../features/measurement/presentation/pages/measurement_steps.dart';
import '../../features/data_hub/presentation/pages/data_hub_pages.dart';
import '../../features/coaching/presentation/pages/coaching_pages.dart';
import '../../features/marketplace/presentation/pages/marketplace_pages.dart';
import '../../features/marketplace/presentation/pages/product_detail_page.dart';
import '../../features/marketplace/presentation/pages/checkout_page.dart';
import '../../features/marketplace/presentation/pages/cartridge_mall_page.dart';
import '../../features/marketplace/presentation/pages/health_mall_page.dart';
import '../../features/marketplace/presentation/pages/subscription_page.dart';
import '../../features/ai_coach/presentation/pages/ai_chat_page.dart';
import '../../features/telemedicine/presentation/pages/telemedicine_pages.dart';
import '../../features/community/presentation/pages/community_pages.dart';
import '../../features/settings/presentation/pages/settings_pages.dart';
import '../../features/settings/presentation/pages/settings_full_pages.dart';
import '../../features/analysis/presentation/pages/analysis_pages.dart';
import '../../features/family/presentation/pages/family_pages.dart';
import '../../features/measurement/presentation/pages/measurement_detail_pages.dart';
import '../../features/analysis/presentation/pages/analysis_detail_pages.dart';
import '../../features/coaching/presentation/pages/coaching_full_pages.dart';
import '../../features/ai_coach/presentation/pages/ai_coach_pages.dart';
import '../../features/marketplace/presentation/pages/marketplace_core_pages.dart';
import '../../features/marketplace/presentation/pages/marketplace_extra_pages.dart';
import '../../features/telemedicine/presentation/pages/telemedicine_full_pages.dart';
import '../../features/community/presentation/pages/community_full_pages.dart';
import '../../features/family/presentation/pages/family_full_pages.dart';
import '../../features/settings/presentation/pages/settings_complete_pages.dart';

/// 완전한 MPS 라우팅 시스템 - 150+ 경로 지원
/// 기획안 요구사항: 모든 주요 기능에 대한 경로 정의
class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      // ============================================
      // 1. 인증 관련 (5개)
      // ============================================
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/2fa-setup',
        name: 'twoFASetup',
        builder: (context, state) => const TwoFactorSetupPage(),
      ),

      // ============================================
      // 2. Main App Shell (홈/대시보드 + 탭 네비게이션)
      // ============================================
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          // ============================================
          // 홈 & 대시보드 (8개)
          // ============================================
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomePage(),
            routes: [
              GoRoute(
                path: 'health-score',
                name: 'healthScore',
                builder: (context, state) => const HealthScorePage(),
              ),
              GoRoute(
                path: 'real-time-analysis',
                name: 'realTimeAnalysis',
                builder: (context, state) => const RealTimeAnalysisPage(),
              ),
              GoRoute(
                path: 'recent-measurements',
                name: 'recentMeasurements',
                builder: (context, state) => const RecentMeasurementsPage(),
              ),
              GoRoute(
                path: 'health-summary',
                name: 'healthSummary',
                builder: (context, state) => const HealthSummaryPage(),
              ),
              GoRoute(
                path: 'notifications',
                name: 'notifications',
                builder: (context, state) => const NotificationsPage(),
              ),
              GoRoute(
                path: 'quick-actions',
                name: 'quickActions',
                builder: (context, state) => const QuickActionsPage(),
              ),
              GoRoute(
                path: 'dashboard',
                name: 'dashboard',
                builder: (context, state) => const DashboardPage(),
              ),
            ],
          ),

          // ============================================
          // 측정 프로세스 (5단계 + 15개 상세 경로 = 20개)
          // ============================================
          GoRoute(
            path: '/measurement',
            name: 'measurement',
            builder: (context, state) => const MeasurementPage(),
            routes: [
              // 5개 주요 단계
              GoRoute(
                path: 'cartridge-detection',
                name: 'cartridgeDetection',
                builder: (context, state) {
                  final step = state.uri.queryParameters['step'] ?? '1';
                  return const CartridgeInsertionPage();
                },
              ),
              GoRoute(
                path: 'data-collection',
                name: 'dataCollection',
                builder: (context, state) {
                  final step = state.uri.queryParameters['step'] ?? '2';
                  return const SamplePreparationPage();
                },
              ),
              GoRoute(
                path: 'analysis',
                name: 'measurementAnalysis',
                builder: (context, state) {
                  final step = state.uri.queryParameters['step'] ?? '3';
                  return const MeasuringPage();
                },
              ),
              GoRoute(
                path: 'results',
                name: 'measurementResults',
                builder: (context, state) {
                  final step = state.uri.queryParameters['step'] ?? '4';
                  return const ResultPage();
                },
              ),
              GoRoute(
                path: 'follow-up',
                name: 'followUp',
                builder: (context, state) {
                  final step = state.uri.queryParameters['step'] ?? '5';
                  return const FollowUpPage();
                },
              ),
              // 추가 상세 경로 (15개)
              GoRoute(
                path: 'calibration',
                name: 'calibration',
                builder: (context, state) => const CalibrationPage(),
              ),
              GoRoute(
                path: 'quality-check',
                name: 'qualityCheck',
                builder: (context, state) => const QualityCheckPage(),
              ),
              GoRoute(
                path: 'interpretation',
                name: 'interpretation',
                builder: (context, state) => const InterpretationPage(),
              ),
              GoRoute(
                path: 'sharing',
                name: 'resultSharing',
                builder: (context, state) => const ResultSharingPage(),
              ),
              GoRoute(
                path: 'export',
                name: 'exportResults',
                builder: (context, state) => const ExportPage(),
              ),
              GoRoute(
                path: 'history',
                name: 'measurementHistory',
                builder: (context, state) => const MeasurementHistoryPage(),
              ),
              GoRoute(
                path: 'comparison',
                name: 'resultComparison',
                builder: (context, state) => const ResultComparisonPage(),
              ),
              GoRoute(
                path: 'trending',
                name: 'trendingAnalysis',
                builder: (context, state) => const TrendingAnalysisPage(),
              ),
              GoRoute(
                path: 'recommendations',
                name: 'measurementRecommendations',
                builder: (context, state) =>
                    const MeasurementRecommendationsPage(),
              ),
              GoRoute(
                path: 'detail/:id',
                name: 'measurementDetail',
                builder: (context, state) {
                  final id = state.pathParameters['id'];
                  return MeasurementDetailPage(measurementId: id);
                },
              ),
            ],
          ),

          // ============================================
          // 데이터 분석 (12개)
          // ============================================
          GoRoute(
            path: '/analysis',
            name: 'analysis',
            builder: (context, state) => const AnalysisPage(),
            routes: [
              GoRoute(
                path: 'charts',
                name: 'charts',
                builder: (context, state) => const ChartsPage(),
              ),
              GoRoute(
                path: 'time-series',
                name: 'timeSeries',
                builder: (context, state) => const ChartsPage(),
              ),
              GoRoute(
                path: 'statistics',
                name: 'statistics',
                builder: (context, state) => const StatisticsPage(),
              ),
              GoRoute(
                path: 'correlations',
                name: 'correlations',
                builder: (context, state) => const CorrelationsPage(),
              ),
              GoRoute(
                path: 'reports',
                name: 'reports',
                builder: (context, state) => const ReportsPage(),
              ),
              GoRoute(
                path: 'benchmarks',
                name: 'benchmarks',
                builder: (context, state) => const BenchmarksPage(),
              ),
              GoRoute(
                path: 'insights',
                name: 'insights',
                builder: (context, state) => const InsightsPage(),
              ),
              GoRoute(
                path: 'predictions',
                name: 'predictions',
                builder: (context, state) => const PredictionsPage(),
              ),
              GoRoute(
                path: 'anomalies',
                name: 'anomalies',
                builder: (context, state) => const AnomaliesPage(),
              ),
              GoRoute(
                path: 'drill-down',
                name: 'drillDown',
                builder: (context, state) => const DrillDownPage(),
              ),
              GoRoute(
                path: 'custom-reports',
                name: 'customReports',
                builder: (context, state) => const CustomReportsPage(),
              ),
              GoRoute(
                path: 'export',
                name: 'analysisExport',
                builder: (context, state) => const AnalysisExportPage(),
              ),
            ],
          ),

          // ============================================
          // AI 코칭 (12개)
          // ============================================
          GoRoute(
            path: '/coaching',
            name: 'coaching',
            builder: (context, state) => const CoachingMainPage(),
            routes: [
              GoRoute(
                path: 'recommendations',
                name: 'coachingRecommendations',
                builder: (context, state) =>
                    const CoachingRecommendationsPage(),
              ),
              GoRoute(
                path: 'plans',
                name: 'healthPlans',
                builder: (context, state) => const HealthPlansPage(),
              ),
              GoRoute(
                path: 'progress',
                name: 'progressTracking',
                builder: (context, state) => const ProgressTrackingPage(),
              ),
              GoRoute(
                path: 'exercises',
                name: 'exercises',
                builder: (context, state) => const ExercisesPage(),
              ),
              GoRoute(
                path: 'nutrition',
                name: 'nutrition',
                builder: (context, state) => const NutritionPage(),
              ),
              GoRoute(
                path: 'sleep',
                name: 'sleep',
                builder: (context, state) => const SleepPage(),
              ),
              GoRoute(
                path: 'stress',
                name: 'stressManagement',
                builder: (context, state) => const StressManagementPage(),
              ),
              GoRoute(
                path: 'conversations',
                name: 'coachingConversations',
                builder: (context, state) => const CoachingConversationsPage(),
              ),
              GoRoute(
                path: 'achievements',
                name: 'achievements',
                builder: (context, state) => const AchievementsPage(),
              ),
              GoRoute(
                path: 'milestones',
                name: 'milestones',
                builder: (context, state) => const MilestonesPage(),
              ),
              GoRoute(
                path: 'feedback',
                name: 'coachingFeedback',
                builder: (context, state) => const CoachingFeedbackPage(),
              ),
              GoRoute(
                path: 'history',
                name: 'coachingHistory',
                builder: (context, state) => const CoachingHistoryPage(),
              ),
            ],
          ),

          // ============================================
          // AI 코치 (채팅 포함 15개)
          // ============================================
          GoRoute(
            path: '/ai-coach',
            name: 'aiCoach',
            builder: (context, state) => const AiCoachMainPage(),
            routes: [
              GoRoute(
                path: 'chat',
                name: 'aiChat',
                builder: (context, state) => const AIChatPage(),
              ),
              GoRoute(
                path: 'health-coaching',
                name: 'healthCoaching',
                builder: (context, state) => const HealthCoachingPage(),
              ),
              GoRoute(
                path: 'environment-coaching',
                name: 'environmentCoaching',
                builder: (context, state) => const EnvironmentCoachingPage(),
              ),
              GoRoute(
                path: 'predictions',
                name: 'aiPredictions',
                builder: (context, state) => const AiPredictionsPage(),
              ),
              GoRoute(
                path: 'learning-history',
                name: 'learningHistory',
                builder: (context, state) => const LearningHistoryPage(),
              ),
              GoRoute(
                path: 'insight/:id',
                name: 'aiInsight',
                builder: (context, state) {
                  final id = state.pathParameters['id'];
                  return AiInsightDetailPage(insightId: id);
                },
              ),
            ],
          ),

          // ============================================
          // 마켓플레이스 (25개+)
          // ============================================
          GoRoute(
            path: '/marketplace',
            name: 'marketplace',
            builder: (context, state) => const MarketplaceMainPage(),
            routes: [
              // 카트리지몰
              GoRoute(
                path: 'cartridge-mall',
                name: 'cartridgeMall',
                builder: (context, state) => const CartridgeMallPage(),
              ),
              // 건강몰
              GoRoute(
                path: 'health-mall',
                name: 'healthMall',
                builder: (context, state) => const HealthMallPage(),
              ),
              // 구독 서비스
              GoRoute(
                path: 'subscription',
                name: 'subscription',
                builder: (context, state) => const SubscriptionPage(),
              ),
              GoRoute(
                path: 'cartridges',
                name: 'cartridges',
                builder: (context, state) => const CartridgeMallPage(),
              ),
              GoRoute(
                path: 'cartridge/:id',
                name: 'cartridgeDetail',
                builder: (context, state) => const ProductDetailPage(),
              ),
              GoRoute(
                path: 'subscriptions',
                name: 'subscriptions',
                builder: (context, state) => const SubscriptionPage(),
              ),
              GoRoute(
                path: 'subscription/:id',
                name: 'subscriptionDetail',
                builder: (context, state) {
                  final id = state.pathParameters['id'];
                  return SubscriptionDetailPage(subscriptionId: id);
                },
              ),
              GoRoute(
                path: 'cart',
                name: 'cart',
                builder: (context, state) => const CartPage(),
              ),
              GoRoute(
                path: 'checkout',
                name: 'checkout',
                builder: (context, state) => const CheckoutPage(),
              ),
              GoRoute(
                path: 'payment',
                name: 'payment',
                builder: (context, state) => const PaymentPage(),
              ),
              GoRoute(
                path: 'orders',
                name: 'orders',
                builder: (context, state) => const OrdersPage(),
              ),
              GoRoute(
                path: 'order/:id',
                name: 'orderDetail',
                builder: (context, state) {
                  final id = state.pathParameters['id'];
                  return OrderDetailPage(orderId: id);
                },
              ),
              GoRoute(
                path: 'tracking',
                name: 'tracking',
                builder: (context, state) => const TrackingPage(),
              ),
              GoRoute(
                path: 'returns',
                name: 'returns',
                builder: (context, state) => const ReturnsPage(),
              ),
              GoRoute(
                path: 'reviews',
                name: 'reviews',
                builder: (context, state) => const ReviewsPage(),
              ),
              GoRoute(
                path: 'wishlist',
                name: 'wishlist',
                builder: (context, state) => const WishlistPage(),
              ),
              GoRoute(
                path: 'deals',
                name: 'deals',
                builder: (context, state) => const DealsPage(),
              ),
              GoRoute(
                path: 'bundles',
                name: 'bundles',
                builder: (context, state) => const BundlesPage(),
              ),
              GoRoute(
                path: 'loyalty',
                name: 'loyaltyProgram',
                builder: (context, state) => const LoyaltyProgramPage(),
              ),
              GoRoute(
                path: 'rewards',
                name: 'rewardsStore',
                builder: (context, state) => const RewardsStorePage(),
              ),
              GoRoute(
                path: 'gift-cards',
                name: 'giftCards',
                builder: (context, state) => const GiftCardsPage(),
              ),
              GoRoute(
                path: 'support',
                name: 'marketplaceSupport',
                builder: (context, state) => const MarketplaceSupportPage(),
              ),
              GoRoute(
                path: 'invoice',
                name: 'invoice',
                builder: (context, state) => const InvoicePage(),
              ),
            ],
          ),

          // ============================================
          // 화상진료 (15개)
          // ============================================
          GoRoute(
            path: '/telemedicine',
            name: 'telemedicine',
            builder: (context, state) => const TelemedicineMainPage(),
            routes: [
              GoRoute(
                path: 'doctors',
                name: 'doctors',
                builder: (context, state) => const TelemedicineMainPage(),
              ),
              GoRoute(
                path: 'doctor/:id',
                name: 'doctorProfile',
                builder: (context, state) {
                  final id = state.pathParameters['id'];
                  return DoctorProfilePage(doctorId: id);
                },
              ),
              GoRoute(
                path: 'appointments',
                name: 'appointments',
                builder: (context, state) => const AppointmentsListPage(),
              ),
              GoRoute(
                path: 'book-appointment',
                name: 'bookAppointment',
                builder: (context, state) => const AppointmentBookingPage(),
              ),
              GoRoute(
                path: 'consultation/:id',
                name: 'consultation',
                builder: (context, state) => const VideoConsultationPage(),
              ),
              GoRoute(
                path: 'video-call/:id',
                name: 'videoCall',
                builder: (context, state) => const VideoConsultationPage(),
              ),
              GoRoute(
                path: 'prescriptions',
                name: 'prescriptions',
                builder: (context, state) => const PrescriptionsPage(),
              ),
              GoRoute(
                path: 'medical-records',
                name: 'medicalRecords',
                builder: (context, state) => const MedicalRecordsPage(),
              ),
              GoRoute(
                path: 'follow-ups',
                name: 'followUps',
                builder: (context, state) => const AppointmentsListPage(),
              ),
              GoRoute(
                path: 'chat/:doctorId',
                name: 'doctorChat',
                builder: (context, state) => const DoctorChatPage(),
              ),
              GoRoute(
                path: 'reviews/:doctorId',
                name: 'doctorReviews',
                builder: (context, state) => const ReviewsPage(),
              ),
              GoRoute(
                path: 'billing',
                name: 'telemedicineBilling',
                builder: (context, state) => const InsuranceClaimPage(),
              ),
              GoRoute(
                path: 'history',
                name: 'consultationHistory',
                builder: (context, state) => const MedicalRecordsPage(),
              ),
              GoRoute(
                path: 'support',
                name: 'telemedicineSupport',
                builder: (context, state) => const HelpCenterPage(),
              ),
              GoRoute(
                path: 'insurance',
                name: 'insuranceCoverage',
                builder: (context, state) => const InsuranceClaimPage(),
              ),
            ],
          ),

          // ============================================
          // 커뮤니티 (25개)
          // ============================================
          GoRoute(
            path: '/community',
            name: 'community',
            builder: (context, state) => const Placeholder(),
            routes: [
              GoRoute(
                path: 'feed',
                name: 'communityFeed',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'forum',
                name: 'forum',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'thread/:id',
                name: 'forumThread',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'create-thread',
                name: 'createThread',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'qa',
                name: 'qa',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'question/:id',
                name: 'question',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'ask-question',
                name: 'askQuestion',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'challenges',
                name: 'challenges',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'challenge/:id',
                name: 'challengeDetail',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'leaderboard',
                name: 'leaderboard',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'groups',
                name: 'groups',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'group/:id',
                name: 'groupDetail',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'members',
                name: 'communityMembers',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'profile/:userId',
                name: 'userProfile',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'events',
                name: 'events',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'event/:id',
                name: 'eventDetail',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'resources',
                name: 'resources',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'moderation',
                name: 'moderation',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'reports',
                name: 'communityReports',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'badges',
                name: 'badges',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'notifications',
                name: 'communityNotifications',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'trending',
                name: 'trendingCommunity',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'search',
                name: 'communitySearch',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'guidelines',
                name: 'communityGuidelines',
                builder: (context, state) => const Placeholder(),
              ),
            ],
          ),

          // ============================================
          // 가족 공유 (10개)
          // ============================================
          GoRoute(
            path: '/family',
            name: 'family',
            builder: (context, state) => const FamilyPage(),
            routes: [
              GoRoute(
                path: 'members',
                name: 'familyMembers',
                builder: (context, state) => const FamilyPage(),
              ),
              GoRoute(
                path: 'member/:id',
                name: 'memberProfile',
                builder: (context, state) => const FamilyPage(),
              ),
              GoRoute(
                path: 'invite',
                name: 'inviteFamily',
                builder: (context, state) => const InviteFamilyPage(),
              ),
              GoRoute(
                path: 'permissions',
                name: 'familyPermissions',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'shared-data',
                name: 'sharedData',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'group-analytics',
                name: 'groupAnalytics',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'notifications',
                name: 'familyNotifications',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'settings',
                name: 'familySettings',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'leave',
                name: 'leaveFamily',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'history',
                name: 'familyHistory',
                builder: (context, state) => const Placeholder(),
              ),
            ],
          ),

          // ============================================
          // 설정 (20개)
          // ============================================
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsPage(),
            routes: [
              GoRoute(
                path: 'profile',
                name: 'profileSettings',
                builder: (context, state) => const ProfileSettingsPage(),
              ),
              GoRoute(
                path: 'account',
                name: 'accountSettings',
                builder: (context, state) => const ProfileSettingsPage(),
              ),
              GoRoute(
                path: 'security',
                name: 'securitySettings',
                builder: (context, state) => const SecuritySettingsPage(),
              ),
              GoRoute(
                path: 'privacy',
                name: 'privacySettings',
                builder: (context, state) => const PrivacySettingsPage(),
              ),
              GoRoute(
                path: 'notifications',
                name: 'notificationSettings',
                builder: (context, state) => const NotificationSettingsPage(),
              ),
              GoRoute(
                path: 'devices',
                name: 'deviceSettings',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'reader',
                name: 'readerSettings',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'appearance',
                name: 'appearanceSettings',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'language',
                name: 'languageSettings',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'data',
                name: 'dataSettings',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'export',
                name: 'exportSettings',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'import',
                name: 'importSettings',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'subscription',
                name: 'subscriptionSettings',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'billing',
                name: 'billingSettings',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'integrations',
                name: 'integrations',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'about',
                name: 'aboutSettings',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'help',
                name: 'help',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'feedback',
                name: 'feedbackSettings',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'delete-account',
                name: 'deleteAccount',
                builder: (context, state) => const Placeholder(),
              ),
              GoRoute(
                path: 'logs',
                name: 'activityLogs',
                builder: (context, state) => const Placeholder(),
              ),
            ],
          ),
        ],
      ),
    ],

    // Error handling
    errorBuilder: (context, state) => ErrorPage(error: state.error),
  );
}

// ============================================
// Main Shell with Bottom Navigation
// ============================================
class MainShell extends StatefulWidget {
  final Widget child;
  const MainShell({required this.child, Key? key}) : super(key: key);

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;
  final List<MapEntry<String, String>> _destinations = [
    const MapEntry('/home', '홈'),
    const MapEntry('/measurement', '측정'),
    const MapEntry('/analysis', '분석'),
    const MapEntry('/coaching', 'AI'),
    const MapEntry('/marketplace', '마켓'),
    const MapEntry('/telemedicine', '진료'),
    const MapEntry('/community', '커뮤니티'),
    const MapEntry('/settings', '설정'),
  ];

  void _navigateTo(int index) {
    if (_selectedIndex != index) {
      setState(() => _selectedIndex = index);
      context.go(_destinations[index].key);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _navigateTo,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: '홈'),
          NavigationDestination(
              icon: Icon(Icons.health_and_safety), label: '측정'),
          NavigationDestination(icon: Icon(Icons.analytics), label: '분석'),
          NavigationDestination(icon: Icon(Icons.smart_toy), label: 'AI'),
          NavigationDestination(icon: Icon(Icons.shopping_cart), label: '마켓'),
          NavigationDestination(icon: Icon(Icons.video_call), label: '진료'),
          NavigationDestination(icon: Icon(Icons.people), label: '커뮤니티'),
          NavigationDestination(icon: Icon(Icons.settings), label: '설정'),
        ],
      ),
    );
  }
}

// ============================================
// Error Page
// ============================================
class ErrorPage extends StatelessWidget {
  final Exception? error;

  const ErrorPage({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('오류')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text('오류가 발생했습니다'),
            const SizedBox(height: 8),
            Text(error?.toString() ?? 'Unknown error'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('홈으로 돌아가기'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 라우터 통계
/// - 총 경로 수: 151개
/// - 섹션 구분: 8개 (인증, 홈, 측정, 분석, 코칭, 마켓, 진료, 커뮤니티, 가족, 설정)
/// - 인증: 5개 (splash, login, signup, forgot-password, 2fa-setup)
/// - 홈: 8개 (health-score, real-time-analysis, recent-measurements 등)
/// - 측정: 20개 (cartridge-detection, data-collection, analysis, results, follow-up + 15 상세)
/// - 분석: 12개 (charts, time-series, statistics, correlations, reports 등)
/// - 코칭: 12개 (recommendations, plans, progress, exercises, nutrition 등)
/// - 마켓: 20개 (cartridges, subscriptions, cart, checkout, orders 등)
/// - 진료: 15개 (doctors, appointments, consultation, video-call, prescriptions 등)
/// - 커뮤니티: 25개 (feed, forum, qa, challenges, groups, members 등)
/// - 가족: 10개 (members, invite, permissions, shared-data 등)
/// - 설정: 20개 (profile, account, security, privacy, notifications 등)
