part of '../../new_invoice_imports.dart';

class CartState {
  final List<CartItemModel> items;
  final List<PayReceiptModel> receipts;
  final double discountAmount;
  final double additionAmount;
  final double discountPercent;
  final double additionPercent;

  const CartState({
    this.items            = const [],
    this.receipts         = const [],
    this.discountAmount   = 0,
    this.additionAmount   = 0,
    this.discountPercent  = 0,
    this.additionPercent  = 0,
  });

  CartState copyWith({
    List<CartItemModel>?   items,
    List<PayReceiptModel>? receipts,
    double?                discountAmount,
    double?                additionAmount,
    double?                discountPercent,
    double?                additionPercent,
  }) {
    return CartState(
      items:           items           ?? this.items,
      receipts:        receipts        ?? this.receipts,
      discountAmount:  discountAmount  ?? this.discountAmount,
      additionAmount:  additionAmount  ?? this.additionAmount,
      discountPercent: discountPercent ?? this.discountPercent,
      additionPercent: additionPercent ?? this.additionPercent,
    );
  }

  // ── Computed ───────────────────────────────────────────
  List<CartItemModel> get activeItems =>
      items.where((i) => i.rowState != 'D').toList();

  double get subtotal => activeItems.fold(0, (sum, i) => sum + i.lineTotal);

  double get totalAfterAdjustments =>
      subtotal - discountAmount + additionAmount;

  double get totalPaid =>
      receipts.fold(0, (sum, r) => sum + r.payingValue);

  double get remaining =>
      totalAfterAdjustments - totalPaid;

  int get totalQuantity =>
      activeItems.fold(0, (sum, i) => sum + i.quantity.toInt());
}

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddItemToCart>(_onAdd);
    on<RemoveItemFromCart>(_onRemove);
    on<UpdateItemQuantity>(_onUpdateQty);
    on<UpdateItemPrice>(_onUpdatePrice);
    on<UpdateItemDiscount>(_onUpdateDiscount);
    on<UpdateItemNote>(_onUpdateNote);
    on<UpdateExpireDate>(_onUpdateExpireDate);
    on<ClearCart>(_onClear);
    on<AddPayReceipt>(_onAddReceipt);
    on<RemovePayReceipt>(_onRemoveReceipt);
    on<UpdateDiscountPercent>(_onUpdateDiscountPercent);
    on<UpdateAdditionPercent>(_onUpdateAdditionPercent);
  }

  void _onAdd(AddItemToCart event, Emitter<CartState> emit) {
    final items = List<CartItemModel>.from(state.items);
    final idx = items.indexWhere((i) => i.productId == event.item.productId);

    if (idx == -1) {
      items.add(event.item);
    } else {
      items[idx] = items[idx].copyWith(quantity: event.item.quantity);
    }
    emit(state.copyWith(items: items));
  }

  void _onRemove(RemoveItemFromCart event, Emitter<CartState> emit) {
    final items = List<CartItemModel>.from(state.items);
    final idx = items.indexWhere((i) => i.productId == event.productId);
    if (idx == -1) return;

    // Mark as D if from original invoice, else remove
    if (items[idx].rowState == 'U') {
      items[idx] = items[idx].copyWith(rowState: 'D');
    } else {
      items.removeAt(idx);
    }
    emit(state.copyWith(items: items));
  }

  void _onUpdateQty(UpdateItemQuantity event, Emitter<CartState> emit) {
    final items = List<CartItemModel>.from(state.items);
    final idx = items.indexWhere((i) => i.productId == event.productId);
    if (idx == -1) return;
    items[idx] = items[idx].copyWith(quantity: event.quantity);
    emit(state.copyWith(items: items));
  }

  void _onUpdatePrice(UpdateItemPrice event, Emitter<CartState> emit) {
    final items = List<CartItemModel>.from(state.items);
    items[event.index] = items[event.index].copyWith(price: event.newPrice);
    emit(state.copyWith(items: items));
  }

  void _onUpdateDiscount(UpdateItemDiscount event, Emitter<CartState> emit) {
    final items = List<CartItemModel>.from(state.items);
    items[event.index] =
        items[event.index].copyWith(discountPercent: event.discount);
    emit(state.copyWith(items: items));
  }

  void _onUpdateNote(UpdateItemNote event, Emitter<CartState> emit) {
    final items = List<CartItemModel>.from(state.items);
    items[event.index] = items[event.index].copyWith(notes: event.note);
    emit(state.copyWith(items: items));
  }

  void _onUpdateExpireDate(UpdateExpireDate event, Emitter<CartState> emit) {
    final items = List<CartItemModel>.from(state.items);
    final idx = items.indexWhere((i) => i.productId == event.productId);
    if (idx == -1) return;
    items[idx] = items[idx].copyWith(selectedExpireDate: event.expireDate);
    emit(state.copyWith(items: items));
  }

  void _onClear(ClearCart event, Emitter<CartState> emit) {
    emit(const CartState());
  }

  void _onAddReceipt(AddPayReceipt event, Emitter<CartState> emit) {
    emit(state.copyWith(receipts: [...state.receipts, event.receipt]));
  }

  void _onRemoveReceipt(RemovePayReceipt event, Emitter<CartState> emit) {
    final r = List<PayReceiptModel>.from(state.receipts);
    r.removeAt(event.index);
    emit(state.copyWith(receipts: r));
  }

  void _onUpdateDiscountPercent(
      UpdateDiscountPercent event,
      Emitter<CartState> emit,
      ) {
    final amount = state.subtotal * (event.percent / 100);
    emit(state.copyWith(
      discountPercent: event.percent,
      discountAmount:  amount,
      additionPercent: 0,
      additionAmount:  0,
    ));
  }

  void _onUpdateAdditionPercent(
      UpdateAdditionPercent event,
      Emitter<CartState> emit,
      ) {
    final amount = state.subtotal * (event.percent / 100);
    emit(state.copyWith(
      additionPercent: event.percent,
      additionAmount:  amount,
      discountPercent: 0,
      discountAmount:  0,
    ));
  }
}