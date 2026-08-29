import '../../../../invoice_profit_imports.dart';

class PayWaysBloc extends Bloc<PayWaysEvent, PayWaysState> {
  final PayWaysDataSource dataSource;

  PayWaysBloc({required this.dataSource}) : super(const PayWaysState()) {
    on<LoadPayWays>(_onLoadPayWays);
    on<SelectPayWay>(_onSelectPayWay);
  }

  Future<void> _onLoadPayWays(
      LoadPayWays event,
      Emitter<PayWaysState> emit,
      ) async {
    emit(state.copyWith(status: Status.loading));

    final result = await dataSource.getPayWays();

    result.fold(
          (failure) => emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: failure.message,
        ),
      ),
          (payWays) {

        emit(
          state.copyWith(
            status: Status.success,
            payWays: payWays, // ✅ من غير "الكل"
            selectedPayWayId: null, // ✅ أول طريقة دفع
            selectedPayWayIds:null,
            errorMessage: null,
          ),
        );
      },
    );
  }

  void _onSelectPayWay(
      SelectPayWay event,
      Emitter<PayWaysState> emit,
      ) {
    final payWayId = event.payWayId;

    // ✅ نتأكد إن طريقة الدفع موجودة
    final exists = state.payWays.any((p) => p.pwid == payWayId);

    if (exists) {
      emit(
        state.copyWith(
          selectedPayWayId: payWayId,
          selectedPayWayIds: {payWayId},
        ),
      );
    }
  }
}