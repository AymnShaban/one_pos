
import 'package:easy_localization/easy_localization.dart';

import '../../branch_profit_import.dart';


import '../widgets/results_panel.dart';

class BranchProfitResultsScreen extends StatefulWidget {
  final BranchProfitResponseModel data;
  final DateTime fromDate;
  final DateTime toDate;

  const BranchProfitResultsScreen({
    super.key,
    required this.data,
    required this.fromDate,
    required this.toDate,
  });

  @override
  State<BranchProfitResultsScreen> createState() => _BranchProfitResultsScreenState();
}

class _BranchProfitResultsScreenState extends State<BranchProfitResultsScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.slateBg,
      appBar:
      GradientAppBar(
        title: 'صافي أرباح الفروع',
        subtitle:  'تقرير الأرباح حسب الفرع',
        onBack: () => Navigator.of(context).maybePop(),
        accentIcon: Container(
          width: 34.w,
          height: 34.h,
          decoration: BoxDecoration(
            color: AppColors.blue,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            Icons.account_balance_wallet,
            color: AppColors.white,
            size: 16.sp,
          ),
        ),
      ),

      // ===== هنا استخدام ResultsPanel =====
      body: ResultsPanel(
        data: widget.data,
      ),
    );
  }
}

