import 'package:flutter_bloc/flutter_bloc.dart';
import 'menu_state.dart';
import '../../data/repositories/menu_repository.dart';

class MenuCubit extends Cubit<MenuState> {
  final MenuRepository repository;

  MenuCubit(this.repository) : super(MenuInitial());

  // الدالة تستقبل id الكافيه كـ parameter
  Future<void> fetchMenu(String shopId) async {
    emit(MenuLoading());
    try {
      final products = await repository.getShopMenu(shopId);
      emit(MenuLoaded(products: products));
    } catch (e) {
      emit(MenuError(message: e.toString()));
    }
  }
}