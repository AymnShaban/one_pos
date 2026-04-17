part of '../../invoice_collection_imports.dart';
class InvoiceCollectionScreen extends StatefulWidget {
  final Map<String, dynamic>? editCollection;

  const InvoiceCollectionScreen({super.key, this.editCollection});

  @override
  State<InvoiceCollectionScreen> createState() =>
      _InvoiceCollectionScreenState();
}

class _InvoiceCollectionScreenState extends State<InvoiceCollectionScreen> {
  @override
  void initState() {
    super.initState();
    context.read<InvoiceCollectionBloc>().add(const LoadCollectionSetupData());

    // If editing — pre-populate state
    if (widget.editCollection != null) {
      _prePopulate();
    }
  }

  void _prePopulate() {
    final e = widget.editCollection!;
    final bloc = context.read<InvoiceCollectionBloc>();

    bloc.add(CollectionBranchChanged(e['BranchId'] ?? 0));
    bloc.add(CollectionCurrencyChanged(
      currencyId: e['CurrencyId'] ?? 0,
      rate:       (e['CurrencyRate'] ?? 1.0).toDouble(),
    ));
    bloc.add(CollectionPayWayChanged(e['Code_PW'] ?? 0));
    bloc.add(CollectionBondTypeChanged(
      voucherType: e['VoucherType'] ?? 0,
      bankName:    e['BankAcName']?.toString() ?? '',
    ));
    if (e['VoucherAccounts'] != null &&
        (e['VoucherAccounts'] as List).isNotEmpty) {
      bloc.add(CollectionCustomerSearched(
        acId:   e['VoucherAccounts'][0]['AcId'] ?? 0,
        acName: e['CustomerName']?.toString() ?? '',
      ));
    }
    if (e['InvoiceID'] != null) {
      bloc.add(CollectionInvoiceLinked(
        invoiceId:    e['InvoiceID'],
        invoiceNo:    e['InvoiceNo'] ?? 0,
        voucherValue: (e['VoucherValue'] ?? 0).toDouble(),
        customerName: e['CustomerName'] ?? '',
        acId:         e['VoucherAccounts']?[0]?['AcId'] ?? 0,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xff5764EE),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text(
          'invoice_collection.title'.tr(),
          style: AppTextTheme.body2Bold.copyWith(color: AppColors.white),
        ),
      ),
      body: BlocListener<InvoiceCollectionBloc, InvoiceCollectionState>(
        listenWhen: (p, c) => p.submitStatus != c.submitStatus,
        listener: (context, state) {
          if (state.submitStatus == Status.success) {
            showCustomSnackBar(
              context,
              'invoice_collection.saved_successfully'.tr(),
            );
            // Navigate to voucher printing
            Navigator.pop(context, state.voucherResponse);
          }
          if (state.submitStatus == Status.failure) {
            showCustomSnackBar(
              context,
              state.errorMessage ?? 'common.error'.tr(),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(12.w),
            child: CollectionMobileLayout(
              editCollection: widget.editCollection,
            ),
          ),
        ),
      ),
    );
  }
}