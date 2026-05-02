import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/home_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository;

  HomeCubit(this._homeRepository) : super(HomeInitial());

  Future<void> getCafes() async {
    emit(HomeLoading());
    try {
      final cafes = await _homeRepository.getCafes();
      emit(HomeSuccess(cafes: cafes));
    } catch (e) {
      emit(HomeFailure(errorMessage: e.toString()));
    }
  }
}