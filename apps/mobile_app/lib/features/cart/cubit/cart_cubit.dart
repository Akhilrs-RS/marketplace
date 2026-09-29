import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_models/shared_models.dart';

class CartState {
  final List<CartItem> items;
  final bool isLoading;

  const CartState({
    this.items = const [],
    this.isLoading = false,
  });

  CartSummary get summary => CartSummary.fromItems(items);
  int get totalItemCount => items.fold(0, (acc, item) => acc + item.quantity);

  CartState copyWith({
    List<CartItem>? items,
    bool? isLoading,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addItem(Product product, {int quantity = 1, String? variant}) {
    final currentItems = List<CartItem>.from(state.items);
    final existingIndex = currentItems.indexWhere(
      (item) => item.productId == product.id && item.selectedVariant == variant,
    );

    if (existingIndex >= 0) {
      final existing = currentItems[existingIndex];
      currentItems[existingIndex] = existing.copyWith(
        quantity: existing.quantity + quantity,
      );
    } else {
      currentItems.add(
        CartItem(
          id: 'cart_${DateTime.now().millisecondsSinceEpoch}',
          productId: product.id,
          product: product,
          quantity: quantity,
          unitPrice: product.effectivePrice,
          selectedVariant: variant,
        ),
      );
    }

    emit(state.copyWith(items: currentItems));
  }

  void updateQuantity(String itemId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(itemId);
      return;
    }

    final currentItems = state.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(quantity: newQuantity);
      }
      return item;
    }).toList();

    emit(state.copyWith(items: currentItems));
  }

  void removeItem(String itemId) {
    final currentItems = state.items.where((item) => item.id != itemId).toList();
    emit(state.copyWith(items: currentItems));
  }

  void clearCart() {
    emit(state.copyWith(items: const []));
  }
}
