import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ============================================================================
// STATES
// ============================================================================

abstract class CoachingState extends Equatable {
  const CoachingState();

  @override
  List<Object> get props => [];
}

class CoachingInitial extends CoachingState {
  const CoachingInitial();
}

class CoachingLoading extends CoachingState {
  const CoachingLoading();
}

class DailyGoalsLoaded extends CoachingState {
  final List<DailyGoal> goals;
  final double overallProgress;

  const DailyGoalsLoaded({
    required this.goals,
    required this.overallProgress,
  });

  @override
  List<Object> get props => [goals, overallProgress];
}

class ExerciseRecommendationsLoaded extends CoachingState {
  final List<ExerciseRecommendation> recommendations;
  final int weeklyTarget; // minutes
  final int weeklyCompleted; // minutes

  const ExerciseRecommendationsLoaded({
    required this.recommendations,
    required this.weeklyTarget,
    required this.weeklyCompleted,
  });

  @override
  List<Object> get props => [recommendations, weeklyTarget, weeklyCompleted];
}

class NutritionPlanLoaded extends CoachingState {
  final List<NutrientTarget> nutrients;
  final List<MealSuggestion> meals;

  const NutritionPlanLoaded({
    required this.nutrients,
    required this.meals,
  });

  @override
  List<Object> get props => [nutrients, meals];
}

class MindfulnessDataLoaded extends CoachingState {
  final SleepData sleepData;
  final int stressLevel; // 0-100
  final List<MeditationProgram> programs;

  const MindfulnessDataLoaded({
    required this.sleepData,
    required this.stressLevel,
    required this.programs,
  });

  @override
  List<Object> get props => [sleepData, stressLevel, programs];
}

class ChallengesLoaded extends CoachingState {
  final List<Challenge> activeChalle nges;
  final List<Challenge> completedChallenges;
  final List<Challenge> availableChallenges;

  const ChallengesLoaded({
    required this.activeChallenges,
    required this.completedChallenges,
    required this.availableChallenges,
  });

  @override
  List<Object> get props => [activeChallenges, completedChallenges, availableChallenges];
}

class RecommendationsUpdated extends CoachingState {
  final List<String> recommendations;
  final String category; // exercise, nutrition, mindfulness

  const RecommendationsUpdated({
    required this.recommendations,
    required this.category,
  });

  @override
  List<Object> get props => [recommendations, category];
}

class GoalCompleted extends CoachingState {
  final String goalId;
  final String goalName;
  final int rewardPoints;

  const GoalCompleted({
    required this.goalId,
    required this.goalName,
    required this.rewardPoints,
  });

  @override
  List<Object> get props => [goalId, goalName, rewardPoints];
}

class CoachingError extends CoachingState {
  final String message;
  final Exception? exception;

  const CoachingError({
    required this.message,
    this.exception,
  });

  @override
  List<Object> get props => [message];
}

// ============================================================================
// EVENTS
// ============================================================================

abstract class CoachingEvent extends Equatable {
  const CoachingEvent();

  @override
  List<Object> get props => [];
}

class LoadDailyGoals extends CoachingEvent {
  const LoadDailyGoals();
}

class LoadExerciseRecommendations extends CoachingEvent {
  const LoadExerciseRecommendations();
}

class LoadNutritionPlan extends CoachingEvent {
  const LoadNutritionPlan();
}

class LoadMindfulnessData extends CoachingEvent {
  const LoadMindfulnessData();
}

class LoadChallenges extends CoachingEvent {
  const LoadChallenges();
}

class CompleteGoal extends CoachingEvent {
  final String goalId;

  const CompleteGoal({required this.goalId});

  @override
  List<Object> get props => [goalId];
}

class LogActivity extends CoachingEvent {
  final String category;
  final String activityName;
  final int duration; // minutes
  final int calories;

  const LogActivity({
    required this.category,
    required this.activityName,
    required this.duration,
    required this.calories,
  });

  @override
  List<Object> get props => [category, activityName, duration, calories];
}

class UpdateStressLevel extends CoachingEvent {
  final int level; // 0-100

  const UpdateStressLevel({required this.level});

  @override
  List<Object> get props => [level];
}

class JoinChallenge extends CoachingEvent {
  final String challengeId;

  const JoinChallenge({required this.challengeId});

  @override
  List<Object> get props => [challengeId];
}

class CompleteChallenge extends CoachingEvent {
  final String challengeId;

  const CompleteChallenge({required this.challengeId});

  @override
  List<Object> get props => [challengeId];
}

class GetRecommendations extends CoachingEvent {
  final String category;

  const GetRecommendations({required this.category});

  @override
  List<Object> get props => [category];
}

// ============================================================================
// BLOC
// ============================================================================

class CoachingBloc extends Bloc<CoachingEvent, CoachingState> {
  CoachingBloc() : super(const CoachingInitial()) {
    on<LoadDailyGoals>(_onLoadDailyGoals);
    on<LoadExerciseRecommendations>(_onLoadExerciseRecommendations);
    on<LoadNutritionPlan>(_onLoadNutritionPlan);
    on<LoadMindfulnessData>(_onLoadMindfulnessData);
    on<LoadChallenges>(_onLoadChallenges);
    on<CompleteGoal>(_onCompleteGoal);
    on<LogActivity>(_onLogActivity);
    on<UpdateStressLevel>(_onUpdateStressLevel);
    on<JoinChallenge>(_onJoinChallenge);
    on<CompleteChallenge>(_onCompleteChallenge);
    on<GetRecommendations>(_onGetRecommendations);
  }

  final List<Challenge> _activeChallenges = [];
  final List<Challenge> _completedChallenges = [];
  int _stressLevel = 45;

  Future<void> _onLoadDailyGoals(
    LoadDailyGoals event,
    Emitter<CoachingState> emit,
  ) async {
    try {
      emit(const CoachingLoading());

      await Future.delayed(const Duration(milliseconds: 500));

      final goals = [
        DailyGoal(
          id: '1',
          name: '물 섭취',
          target: 8,
          completed: 5,
          unit: '잔',
          icon: '💧',
          category: 'health',
        ),
        DailyGoal(
          id: '2',
          name: '운동',
          target: 30,
          completed: 20,
          unit: '분',
          icon: '🏃',
          category: 'exercise',
        ),
        DailyGoal(
          id: '3',
          name: '수면',
          target: 8,
          completed: 7,
          unit: '시간',
          icon: '😴',
          category: 'health',
        ),
        DailyGoal(
          id: '4',
          name: '명상',
          target: 10,
          completed: 10,
          unit: '분',
          icon: '🧘',
          category: 'mindfulness',
        ),
      ];

      final overallProgress = goals
          .map((g) => (g.completed / g.target).clamp(0.0, 1.0))
          .reduce((a, b) => a + b) / goals.length;

      emit(DailyGoalsLoaded(goals: goals, overallProgress: overallProgress));
    } catch (e) {
      emit(CoachingError(
        message: 'Failed to load daily goals: $e',
        exception: e as Exception?,
      ));
    }
  }

  Future<void> _onLoadExerciseRecommendations(
    LoadExerciseRecommendations event,
    Emitter<CoachingState> emit,
  ) async {
    try {
      emit(const CoachingLoading());

      await Future.delayed(const Duration(milliseconds: 500));

      final recommendations = [
        ExerciseRecommendation(
          id: '1',
          name: '빠른 산책',
          description: '공원에서 30분 산책',
          duration: 30,
          intensity: 'moderate',
          calories: 150,
          icon: '🚶',
        ),
        ExerciseRecommendation(
          id: '2',
          name: '조깅',
          description: '밤 공기를 마시며 조깅',
          duration: 45,
          intensity: 'high',
          calories: 400,
          icon: '🏃',
        ),
        ExerciseRecommendation(
          id: '3',
          name: '요가',
          description: '스트레칭과 유연성 운동',
          duration: 20,
          intensity: 'low',
          calories: 80,
          icon: '🧘',
        ),
      ];

      emit(ExerciseRecommendationsLoaded(
        recommendations: recommendations,
        weeklyTarget: 150,
        weeklyCompleted: 95,
      ));
    } catch (e) {
      emit(CoachingError(
        message: 'Failed to load exercise recommendations: $e',
        exception: e as Exception?,
      ));
    }
  }

  Future<void> _onLoadNutritionPlan(
    LoadNutritionPlan event,
    Emitter<CoachingState> emit,
  ) async {
    try {
      emit(const CoachingLoading());

      await Future.delayed(const Duration(milliseconds: 500));

      final nutrients = [
        NutrientTarget(
          name: '탄수화물',
          current: 250,
          target: 300,
          unit: 'g',
          color: 0xFFFF6B6B,
        ),
        NutrientTarget(
          name: '단백질',
          current: 60,
          target: 75,
          unit: 'g',
          color: 0xFF4ECDC4,
        ),
        NutrientTarget(
          name: '지방',
          current: 50,
          target: 65,
          unit: 'g',
          color: 0xFFFFE66D,
        ),
        NutrientTarget(
          name: '식이섬유',
          current: 18,
          target: 25,
          unit: 'g',
          color: 0xFF95E1D3,
        ),
      ];

      final meals = [
        MealSuggestion(
          name: '고단백 계란 계란',
          description: '에그화이트 샐러드',
          calories: 250,
          nutrients: {'protein': 25, 'carbs': 5, 'fat': 10},
          icon: '🥗',
        ),
        MealSuggestion(
          name: '그릭요거트 스무디',
          description: '베리가 들어간 단백질 스무디',
          calories: 200,
          nutrients: {'protein': 20, 'carbs': 30, 'fat': 5},
          icon: '🥤',
        ),
        MealSuggestion(
          name: '구운 연어 샐러드',
          description: '오메가-3 풍부한 저녁 식사',
          calories: 450,
          nutrients: {'protein': 40, 'carbs': 20, 'fat': 25},
          icon: '🐟',
        ),
      ];

      emit(NutritionPlanLoaded(nutrients: nutrients, meals: meals));
    } catch (e) {
      emit(CoachingError(
        message: 'Failed to load nutrition plan: $e',
        exception: e as Exception?,
      ));
    }
  }

  Future<void> _onLoadMindfulnessData(
    LoadMindfulnessData event,
    Emitter<CoachingState> emit,
  ) async {
    try {
      emit(const CoachingLoading());

      await Future.delayed(const Duration(milliseconds: 500));

      final sleepData = SleepData(
        duration: 7.5,
        quality: 82,
        awakenings: 2,
        bedTime: '22:30',
        wakeTime: '06:00',
      );

      final programs = [
        MeditationProgram(
          id: '1',
          name: '아침 명상',
          duration: 5,
          description: '하루를 시작하기 위한 마음챙김',
          icon: '🌅',
          completed: false,
        ),
        MeditationProgram(
          id: '2',
          name: '스트레스 해소',
          duration: 15,
          description: '일상 스트레스 완화 명상',
          icon: '💆',
          completed: false,
        ),
        MeditationProgram(
          id: '3',
          name: '수면 유도',
          duration: 10,
          description: '깊은 수면을 위한 이완 명상',
          icon: '🌙',
          completed: false,
        ),
      ];

      emit(MindfulnessDataLoaded(
        sleepData: sleepData,
        stressLevel: _stressLevel,
        programs: programs,
      ));
    } catch (e) {
      emit(CoachingError(
        message: 'Failed to load mindfulness data: $e',
        exception: e as Exception?,
      ));
    }
  }

  Future<void> _onLoadChallenges(
    LoadChallenges event,
    Emitter<CoachingState> emit,
  ) async {
    try {
      emit(const CoachingLoading());

      await Future.delayed(const Duration(milliseconds: 500));

      final activeChallenges = [
        Challenge(
          id: '1',
          name: '30일 운동',
          description: '30일 동안 매일 운동하기',
          progress: 15,
          total: 30,
          reward: 5000,
          icon: '🏋️',
          status: 'active',
        ),
        Challenge(
          id: '2',
          name: '물 마시기',
          description: '매일 8잔 이상 물 마시기',
          progress: 20,
          total: 30,
          reward: 2000,
          icon: '💧',
          status: 'active',
        ),
      ];

      final completedChallenges = [
        Challenge(
          id: '3',
          name: '일주일 스트레칭',
          description: '7일 연속 스트레칭',
          progress: 7,
          total: 7,
          reward: 1000,
          icon: '🧘',
          status: 'completed',
        ),
      ];

      final availableChallenges = [
        Challenge(
          id: '4',
          name: '10km 달리기',
          description: '10km 달리기 완주하기',
          progress: 0,
          total: 1,
          reward: 10000,
          icon: '🏃',
          status: 'available',
        ),
      ];

      emit(ChallengesLoaded(
        activeChallenges: activeChallenges,
        completedChallenges: completedChallenges,
        availableChallenges: availableChallenges,
      ));
    } catch (e) {
      emit(CoachingError(
        message: 'Failed to load challenges: $e',
        exception: e as Exception?,
      ));
    }
  }

  Future<void> _onCompleteGoal(
    CompleteGoal event,
    Emitter<CoachingState> emit,
  ) async {
    try {
      emit(const CoachingLoading());

      await Future.delayed(const Duration(milliseconds: 500));

      emit(const GoalCompleted(
        goalId: 'goal_1',
        goalName: '명상',
        rewardPoints: 100,
      ));

      add(const LoadDailyGoals());
    } catch (e) {
      emit(CoachingError(
        message: 'Failed to complete goal: $e',
        exception: e as Exception?,
      ));
    }
  }

  Future<void> _onLogActivity(
    LogActivity event,
    Emitter<CoachingState> emit,
  ) async {
    try {
      emit(const CoachingLoading());

      await Future.delayed(const Duration(milliseconds: 300));

      add(const LoadExerciseRecommendations());
    } catch (e) {
      emit(CoachingError(
        message: 'Failed to log activity: $e',
        exception: e as Exception?,
      ));
    }
  }

  Future<void> _onUpdateStressLevel(
    UpdateStressLevel event,
    Emitter<CoachingState> emit,
  ) async {
    try {
      _stressLevel = event.level;
      add(const LoadMindfulnessData());
    } catch (e) {
      emit(CoachingError(
        message: 'Failed to update stress level: $e',
        exception: e as Exception?,
      ));
    }
  }

  Future<void> _onJoinChallenge(
    JoinChallenge event,
    Emitter<CoachingState> emit,
  ) async {
    try {
      emit(const CoachingLoading());

      await Future.delayed(const Duration(milliseconds: 500));

      add(const LoadChallenges());
    } catch (e) {
      emit(CoachingError(
        message: 'Failed to join challenge: $e',
        exception: e as Exception?,
      ));
    }
  }

  Future<void> _onCompleteChallenge(
    CompleteChallenge event,
    Emitter<CoachingState> emit,
  ) async {
    try {
      emit(const CoachingLoading());

      await Future.delayed(const Duration(milliseconds: 500));

      add(const LoadChallenges());
    } catch (e) {
      emit(CoachingError(
        message: 'Failed to complete challenge: $e',
        exception: e as Exception?,
      ));
    }
  }

  Future<void> _onGetRecommendations(
    GetRecommendations event,
    Emitter<CoachingState> emit,
  ) async {
    try {
      emit(const CoachingLoading());

      await Future.delayed(const Duration(milliseconds: 500));

      final recommendations = _getRecommendationsForCategory(event.category);

      emit(RecommendationsUpdated(
        recommendations: recommendations,
        category: event.category,
      ));
    } catch (e) {
      emit(CoachingError(
        message: 'Failed to get recommendations: $e',
        exception: e as Exception?,
      ));
    }
  }

  List<String> _getRecommendationsForCategory(String category) {
    switch (category) {
      case 'exercise':
        return [
          '주 5회, 하루 30분 유산소 운동',
          '근력 운동은 주 2-3회 추천',
          '운동 전 5분 스트레칭',
          '운동 후 수분 섭취',
        ];
      case 'nutrition':
        return [
          '충분한 단백질 섭취 (하루 75g)',
          '정제 탄수화물 피하기',
          '아침 식사 절대 거르지 않기',
          '야식은 자정 이전에',
        ];
      case 'mindfulness':
        return [
          '매일 10분 명상',
          '깊고 천천한 호흡 연습',
          '밤 11시 이전 취침',
          '카페인 섭취 자제 (오후 3시 이후)',
        ];
      default:
        return ['건강한 생활을 위해 노력하세요'];
    }
  }
}

// ============================================================================
// MODELS
// ============================================================================

class DailyGoal extends Equatable {
  final String id;
  final String name;
  final double target;
  final double completed;
  final String unit;
  final String icon;
  final String category;

  const DailyGoal({
    required this.id,
    required this.name,
    required this.target,
    required this.completed,
    required this.unit,
    required this.icon,
    required this.category,
  });

  @override
  List<Object> get props => [id, name, target, completed, unit, icon, category];
}

class ExerciseRecommendation extends Equatable {
  final String id;
  final String name;
  final String description;
  final int duration; // minutes
  final String intensity; // low, moderate, high
  final int calories;
  final String icon;

  const ExerciseRecommendation({
    required this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.intensity,
    required this.calories,
    required this.icon,
  });

  @override
  List<Object> get props => [id, name, description, duration, intensity, calories, icon];
}

class NutrientTarget extends Equatable {
  final String name;
  final double current;
  final double target;
  final String unit;
  final int color;

  const NutrientTarget({
    required this.name,
    required this.current,
    required this.target,
    required this.unit,
    required this.color,
  });

  @override
  List<Object> get props => [name, current, target, unit, color];
}

class MealSuggestion extends Equatable {
  final String name;
  final String description;
  final int calories;
  final Map<String, double> nutrients; // protein, carbs, fat
  final String icon;

  const MealSuggestion({
    required this.name,
    required this.description,
    required this.calories,
    required this.nutrients,
    required this.icon,
  });

  @override
  List<Object> get props => [name, description, calories, nutrients, icon];
}

class SleepData extends Equatable {
  final double duration;
  final int quality;
  final int awakenings;
  final String bedTime;
  final String wakeTime;

  const SleepData({
    required this.duration,
    required this.quality,
    required this.awakenings,
    required this.bedTime,
    required this.wakeTime,
  });

  @override
  List<Object> get props => [duration, quality, awakenings, bedTime, wakeTime];
}

class MeditationProgram extends Equatable {
  final String id;
  final String name;
  final int duration; // minutes
  final String description;
  final String icon;
  final bool completed;

  const MeditationProgram({
    required this.id,
    required this.name,
    required this.duration,
    required this.description,
    required this.icon,
    required this.completed,
  });

  @override
  List<Object> get props => [id, name, duration, description, icon, completed];
}

class Challenge extends Equatable {
  final String id;
  final String name;
  final String description;
  final int progress;
  final int total;
  final int reward; // points
  final String icon;
  final String status; // active, completed, available

  const Challenge({
    required this.id,
    required this.name,
    required this.description,
    required this.progress,
    required this.total,
    required this.reward,
    required this.icon,
    required this.status,
  });

  @override
  List<Object> get props => [id, name, description, progress, total, reward, icon, status];
}
