import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

abstract class CartridgeMallEvent extends Equatable {
  const CartridgeMallEvent();
  @override
  List<Object?> get props => [];
}

class LoadCartridges extends CartridgeMallEvent {
  const LoadCartridges();
}

abstract class CartridgeMallState extends Equatable {
  const CartridgeMallState();
  @override
  List<Object?> get props => [];
}

class CartridgeMallInitial extends CartridgeMallState {
  const CartridgeMallInitial();
}

class CartridgeMallLoading extends CartridgeMallState {
  const CartridgeMallLoading();
}

class CartridgeMallLoaded extends CartridgeMallState {
  final List<dynamic> healthCartridges;
  final List<dynamic> environmentCartridges;
  final List<dynamic> waterCartridges;
  final List<dynamic> foodCartridges;
  final List<dynamic> safetyCartridges;
  final List<dynamic> researchCartridges;
  final List<dynamic> thirdPartyCartridges;
  final dynamic currentSubscription;
  
  const CartridgeMallLoaded({
    required this.healthCartridges,
    required this.environmentCartridges,
    required this.waterCartridges,
    required this.foodCartridges,
    required this.safetyCartridges,
    required this.researchCartridges,
    required this.thirdPartyCartridges,
    this.currentSubscription,
  });
  
  @override
  List<Object?> get props => [
    healthCartridges,
    environmentCartridges,
    waterCartridges,
    foodCartridges,
    safetyCartridges,
    researchCartridges,
    thirdPartyCartridges,
    currentSubscription,
  ];
}

class CartridgeMallBloc extends Bloc<CartridgeMallEvent, CartridgeMallState> {
  final dynamic getCartridgesUsecase;
  final dynamic purchaseUsecase;
  
  CartridgeMallBloc(this.getCartridgesUsecase, this.purchaseUsecase)
      : super(const CartridgeMallInitial()) {
    on<LoadCartridges>(_onLoadCartridges);
  }
  
  Future<void> _onLoadCartridges(LoadCartridges event, Emitter<CartridgeMallState> emit) async {
    emit(const CartridgeMallLoading());
    // TODO: Implement
  }
}
