import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_models/shared_models.dart';
import '../../../core/services/api_service.dart';

class ProductsState {
  final List<Product> products;
  final List<Category> categories;
  final String selectedCategory;
  final String searchQuery;
  final bool isLoading;
  final String? error;

  const ProductsState({
    this.products = const [],
    this.categories = const [],
    this.selectedCategory = 'all',
    this.searchQuery = '',
    this.isLoading = false,
    this.error,
  });

  ProductsState copyWith({
    List<Product>? products,
    List<Category>? categories,
    String? selectedCategory,
    String? searchQuery,
    bool? isLoading,
    String? error,
  }) {
    return ProductsState(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ProductsCubit extends Cubit<ProductsState> {
  final ApiService _apiService;

  ProductsCubit(this._apiService) : super(const ProductsState());

  Future<void> loadInitialData() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final categories = await _apiService.getCategories();
      final products = await _apiService.getProducts(
        categoryId: state.selectedCategory == 'all' ? null : state.selectedCategory,
        search: state.searchQuery.isEmpty ? null : state.searchQuery,
      );
      emit(state.copyWith(
        categories: categories,
        products: products,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> selectCategory(String categoryId) async {
    if (state.selectedCategory == categoryId) return;
    emit(state.copyWith(selectedCategory: categoryId, isLoading: true));
    try {
      final products = await _apiService.getProducts(
        categoryId: categoryId == 'all' ? null : categoryId,
        search: state.searchQuery.isEmpty ? null : state.searchQuery,
      );
      emit(state.copyWith(products: products, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> search(String query) async {
    emit(state.copyWith(searchQuery: query, isLoading: true));
    try {
      final products = await _apiService.getProducts(
        categoryId: state.selectedCategory == 'all' ? null : state.selectedCategory,
        search: query.isEmpty ? null : query,
      );
      emit(state.copyWith(products: products, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
