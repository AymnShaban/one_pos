part of '../../basket_imports.dart';

class BasketPosSummary extends StatefulWidget {
  const BasketPosSummary({super.key});

  @override
  State<BasketPosSummary> createState() => _BasketPosSummaryState();
}

class _BasketPosSummaryState extends State<BasketPosSummary> {
  double _discountPercent = 0.0;
  bool _isDiscountAddition =
      false; // true = addition, false = subtraction (discount)
  String _receiptNumber = '';
  PayWayModel? _selectedPayWay;
  CustomerAccountModel? _selectedAccount;
  final List<Map<String, dynamic>> _payments = [];

  late final PayWaysBloc _payWaysBloc;
  final TextEditingController _paidController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _payWaysBloc = getIt<PayWaysBloc>()..add(const FetchPayWays());
  }

  @override
  void dispose() {
    _payWaysBloc.close();
    _paidController.dispose();
    super.dispose();
  }

  Future<void> _openCustomerSearch() async {
    final result = await showDialog<CustomerAccountModel>(
      context: context,
      builder: (_) => const CustomerSearchDialog(),
    );
    if (result != null) {
      updateState(() => _selectedAccount = result);
    }
  }

  void updateState(VoidCallback fn) {
    if (mounted) setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BasketBloc, BaseState<ItemModel>>(
      builder: (context, state) {
        if (state.items.isEmpty) return const SizedBox.shrink();

        final totalAmount = state.items.fold<double>(
          0,
          (sum, item) => sum + item.totalSplitPrice,
        );

        final discountAmount = (totalAmount * _discountPercent) / 100;
        final netAmount = _isDiscountAddition
            ? totalAmount + discountAmount
            : totalAmount - discountAmount;

        final totalQuantity = state.items.fold<num>(
          0,
          (sum, item) => sum + item.salesQuantity,
        );

        final itemCount = state.items.length;
        final totalPaid = _payments.fold<double>(
          0,
          (sum, p) => sum + (p['amount'] as double),
        );
        final remainingAmount = netAmount - totalPaid;

        return Container(
          margin: EdgeInsets.all(12.w),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: context.isDarkMode ? AppColors.codGray : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAccountSearch(),
              SizedBox(height: 4.h),
              _buildTotalsSection(totalAmount, netAmount, discountAmount),
              SizedBox(height: 8.h),
              _buildQuantitySection(totalQuantity, itemCount),
              SizedBox(height: 16.h),
              _buildPaymentInputSection(remainingAmount),
              if (_payments.isNotEmpty) ...[
                SizedBox(height: 16.h),
                _buildPaymentsTable(),
              ],
              SizedBox(height: 16.h),
              _buildBalanceSummary(totalPaid, remainingAmount),
            ],
          ),
        );
      },
    );
  }
}
