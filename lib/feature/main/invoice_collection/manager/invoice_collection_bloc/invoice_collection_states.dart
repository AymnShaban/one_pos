part of '../../invoice_collection_imports.dart';


/// Branches were extracted into the shared [BranchBloc] — `selectedBranchId`
/// is still tracked here (the layout pushes it on selection via
/// [CollectionBranchChanged]) so the submit payload can resolve which
/// branch the voucher is for.
class InvoiceCollectionState extends Equatable {
  // Setup data
  final Status currenciesStatus;
  final Status payWaysStatus;
  final Status bondTypesStatus;

  final List<Map<String, dynamic>> currencies;
  final List<Map<String, dynamic>> payWays;
  final List<BondTypeModel> bondTypes;

  // Selected values
  final int selectedBranchId;
  final int selectedCurrencyId;
  final double selectedCurrencyRate;
  final int selectedCodePw;
  final int selectedVoucherType;
  final String selectedBankName;

  // Linked invoice / customer
  final num invoiceId;
  final num invoiceNo;
  final double voucherValue;
  final String customerName;
  final num acId;

  // Submit
  final Status submitStatus;
  final VoucherResponseModel? voucherResponse;
  final String? errorMessage;

  const InvoiceCollectionState({
    this.currenciesStatus = Status.initial,
    this.payWaysStatus    = Status.initial,
    this.bondTypesStatus  = Status.initial,
    this.currencies       = const [],
    this.payWays          = const [],
    this.bondTypes        = const [],
    this.selectedBranchId      = 0,
    this.selectedCurrencyId    = 0,
    this.selectedCurrencyRate  = 1.0,
    this.selectedCodePw        = 0,
    this.selectedVoucherType   = 0,
    this.selectedBankName      = '',
    this.invoiceId             = 0,
    this.invoiceNo             = 0,
    this.voucherValue          = 0.0,
    this.customerName          = '',
    this.acId                  = 0,
    this.submitStatus          = Status.initial,
    this.voucherResponse,
    this.errorMessage,
  });

  Map<String, dynamic>? get selectedCurrency =>
      currencies
          .where((c) => c['CurrencyID'] == selectedCurrencyId)
          .isNotEmpty
          ? currencies.firstWhere((c) => c['CurrencyID'] == selectedCurrencyId)
          : null;

  String get equivalentRate =>
      selectedCurrencyRate != 0 && selectedCurrencyRate.isFinite
          ? (1 / selectedCurrencyRate).toStringAsFixed(3)
          : '0';

  InvoiceCollectionState copyWith({
    Status? currenciesStatus,
    Status? payWaysStatus,
    Status? bondTypesStatus,
    List<Map<String, dynamic>>? currencies,
    List<Map<String, dynamic>>? payWays,
    List<BondTypeModel>? bondTypes,
    int? selectedBranchId,
    int? selectedCurrencyId,
    double? selectedCurrencyRate,
    int? selectedCodePw,
    int? selectedVoucherType,
    String? selectedBankName,
    num? invoiceId,
    num? invoiceNo,
    double? voucherValue,
    String? customerName,
    num? acId,
    Status? submitStatus,
    VoucherResponseModel? voucherResponse,
    String? errorMessage,
  }) {
    return InvoiceCollectionState(
      currenciesStatus:     currenciesStatus     ?? this.currenciesStatus,
      payWaysStatus:        payWaysStatus        ?? this.payWaysStatus,
      bondTypesStatus:      bondTypesStatus      ?? this.bondTypesStatus,
      currencies:           currencies           ?? this.currencies,
      payWays:              payWays              ?? this.payWays,
      bondTypes:            bondTypes            ?? this.bondTypes,
      selectedBranchId:     selectedBranchId     ?? this.selectedBranchId,
      selectedCurrencyId:   selectedCurrencyId   ?? this.selectedCurrencyId,
      selectedCurrencyRate: selectedCurrencyRate ?? this.selectedCurrencyRate,
      selectedCodePw:       selectedCodePw       ?? this.selectedCodePw,
      selectedVoucherType:  selectedVoucherType  ?? this.selectedVoucherType,
      selectedBankName:     selectedBankName     ?? this.selectedBankName,
      invoiceId:            invoiceId            ?? this.invoiceId,
      invoiceNo:            invoiceNo            ?? this.invoiceNo,
      voucherValue:         voucherValue         ?? this.voucherValue,
      customerName:         customerName         ?? this.customerName,
      acId:                 acId                 ?? this.acId,
      submitStatus:         submitStatus         ?? this.submitStatus,
      voucherResponse:      voucherResponse      ?? this.voucherResponse,
      errorMessage:         errorMessage         ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        currenciesStatus, payWaysStatus, bondTypesStatus,
        currencies, payWays, bondTypes,
        selectedBranchId, selectedCurrencyId, selectedCurrencyRate,
        selectedCodePw, selectedVoucherType, selectedBankName,
        invoiceId, invoiceNo, voucherValue, customerName, acId,
        submitStatus, voucherResponse, errorMessage,
      ];
}
