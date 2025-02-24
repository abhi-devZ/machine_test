import 'package:bloc/bloc.dart';
import 'package:machine_test/data/repositories/product_remote_repository.dart';
import 'package:meta/meta.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepositoryRemote repository;

  ProductBloc({required this.repository}) : super(ProductInitial()) {
    on<FetchProductEvent>(_fetchProductEvent);
  }

  Future<void> _fetchProductEvent(FetchProductEvent event, Emitter<ProductState> emit) async {
    final result = await repository.fetchAllProducts();

    result.fold((error) => print(error.toString()), (userData) => print(userData.toString()));
  }
}
